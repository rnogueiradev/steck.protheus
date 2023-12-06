
#INCLUDE "TOTVS.CH"

/*/{Protheus.doc} ATUSB1
Função para importação dos valores de custo
@type function
@author Tiago Castilho
@since 07/07/2023
/*/
User Function ATUSB1()

    If FWAlertNoYes("Essa rotina deve ser executada no último dia do mês, deseja continuar?",;
                "AVISO: TEM QUE EXECUTAR NO ÚLTIMO DIA DO MÊS!")

        oProcess := MsNewProcess():New({|| CUSTOSB1(oProcess)}, "Atualizando dados!...", "Aguarde...", .T.)
        oProcess:Activate()
        
        FwFreeObj(oProcess)
    Endif

Return

Static function CUSTOSB1(oObj)

    Local nAtual    := 0
    Local nTotal    := 0
    Local nY        := 0
    Local aDados    := {}
    Local aArea     := {}
    Local cArq      := ""
	Local cLinha    := ""
    Local cMsg      := ""
	Local lPrim     := .T.
	Local i         := 0
    Local nLast     := 0
    Local cTitulo   := "Atualização de produto por CSV"
	Local cExtens   := "Arquivo CSV | *.CSV"
	Local cMainPath := ""
    
	Private bBlock  := ErrorBlock({|e|ChkErr(e)})
	Private cErrorL := ""
	Private cEOL    := ""
	Private cLin    := ""  

    Default oObj    := Nil

    aArea := {GetArea()}
    AADD(aArea,SB1->(GetArea()))
   
    cArq := cGetFile(cExtens, cTitulo,, cMainPath, .T.)

  	If !File(cArq)
	    MsgStop("O arquivo " + cArq + " nao foi encontrado. A importacao sera abortada!","ATENCAO")
	    Return
	EndIf
    
    FT_FUSE(cArq)           // Abre o arquivo
	nLast := FT_FLASTREC()  // Retorna o número de linhas do arquivo
    FT_FGOTOP()             // Posiciona na primeria linha

	While !FT_FEOF() // Verifica se é fim de arquivo
		i++
	    cLinha := FT_FREADLN() // Retorna a linha corrente

        oObj:SetRegua1(nLast)
        oObj:IncRegua1("Lendo arquivo! " + cValToChar(i) + " de " + cValToChar(nLast) + "...")

	    If lPrim
	        aCampos := Separa(cLinha,";",.T.)
	        lPrim := .F.
	    Else 
	        AADD(aDados,Separa(cLinha,";",.T.))
	    EndIf

	    FT_FSKIP() // Pula para próxima linha
	EndDo

	FT_FUSE() // Fecha o Arquivo

    DbSelectArea("SB1")
    SB1->(DbSetOrder(1))
    SB1->(DbGoTop())

    cMsg += "==========  FINALIZADO COM SUCESSO ========== " +CRLF +CRLF +CRLF
    cMsg += "LINHA"+';'+"B1_COD"+';'+"B1_CUSTD"+';'+"B1_UPRC"+';'+"B1_UCALSTD"+';'+"B1_UCOM"+CRLF

    nTotal := Len(aDados)
    For nY := 1 To Len(aDados)
        If SB1->(DbSeek(xfilial("SB1")+Avkey(aDados[nY,1],"B1_COD")))
            nAtual ++
            
            cMsg += CvalToChar(nAtual)+';'+Alltrim(SB1->B1_COD)+';'+cValToChar(SB1->B1_CUSTD)+';'+cValToChar(SB1->B1_UPRC)+';'+DtoS(SB1->B1_UCALSTD)+';'+DtoS(SB1->B1_UCOM)+CRLF
        
            //Incrementa a mensagem na régua
            oObj:SetRegua2(nTotal)
            oObj:IncRegua2("Processando Registro = " + Alltrim(aDados[nY,1]) + "...")
            
            RecLock("SB1", .F.)
            SB1->B1_CUSTD   := Val(strtran(aDados[nY,2],',','.'))
            SB1->B1_UPRC    := Val(strtran(aDados[nY,3],',','.'))
            SB1->B1_UCALSTD := dDATABASE 
            SB1->B1_UCOM    := dDATABASE 
            SB1->(MsUnlock())
        Endif
    Next nY

    ErrorBlock(bBlock) // Capturar error log

	If !Empty(cErrorL)
        eecView(cErrorL)
    Else
        eecView(cMsg)
    Endif

    AEval(aArea, {|aArea| RestArea(aArea)})
    FwFreeArray(aArea)
    FwFreeArray(aDados)
    
Return 

Static Function ChkErr(oErroArq)

	Local nI := 0

	If oErroArq:GenCode > 0
		cErrorL := '(' + Alltrim(Str(oErroArq:GenCode)) + ') : ' + AllTrim(oErroArq:Description) + CRLF
	EndIf

	nI := 2
	
    While (!Empty(ProcName(ni)))
		cErrorL += Trim(ProcName(ni)) + "(" + Alltrim(Str(ProcLine(ni))) + ") " + CRLF
		ni ++
	End
	
    If Intransact()
		cErrorL +="Transação Aberta Desarmada"
		Break
	EndIf

    FwFreeObj(oErroArq)

Return
