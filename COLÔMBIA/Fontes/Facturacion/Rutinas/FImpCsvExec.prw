#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"

Static lGravou := .F.
Static lError  := .f.

/*====================================================================================\
|Programa  | FIMPCSVEXEC        | Autor | BRUNO REIS           | Data | 04/05/2023  |
|=====================================================================================|
|DescriÃ§Ã£o | ROTINA PARA INSERIR PEDIDO DE VENDA E ORCAMENTO VIA CSV                  |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................HistÃ³rico....................................|
\====================================================================================*/
User function FIMPCSVEXEC()
    Default cFilEmp    := ''
	Default cEmpresa   := ''
	default cMessageError := ''
    Private _cPastLoc := "c:\logcsv\"  
	Private aCombo			:= {}
	Private __aRet := {}
	Private aParamBox := {}
	Private _cAno		:= Space(4)
    Private cTipoImp    := '01'  //01 =PEDIDO DE VENDA //02 = ORCAMENTO

    If	! ExistDir( _cPastLoc )
		MakeDir(_cPastLoc) 		// cria o diretorio local
	EndIf
	aCombo := {"01-PED.VENDA","02-ORC VENDA" }

	AADD(aParamBox,{2,"Importacao de CSV",,aCombo,100,"",.T.})
 
	If !ParamBox(aParamBox,"Importacao de CSV ",@__aRet,,,.T.,,500) 
		Return
	Endif
	
    If __aRet[1] == "01-PED.VENDA"
        cTipoImp := "01"
    ElseIf __aRet[1] == "02-ORC VENDA"  
        cTipoImp := "02"
    Endif    

    Processa({|| u_FArqCsv(cTipoImp)}, "Lendo TXT....")

Return


User Function FArqCsv(cTipoImp)
    Local cLinha    := ""
    Local nTotLinha := 0
    Local nAtual    := 0
    Private aItens  := {}
    Private aCampos := {}

    lGravou := .F.
    lError  := .f.

    cfOpen:=cGetFile("Arquivos Csv (MS DOS)|*.csv",;
                    OemToAnsi("Abrir Arquivo para Importacao *CSV..."),;
                    0,;
                    GetSrvProfString("c:\",""),;
                    .T.)

    if !Empty(cFOpen)
            //Alert(" Arquivo Encontrado ! ")
            FT_Fuse(cfOpen)
            nTotLinha:= FT_FLASTREC()
            FT_FGOTOP()
            While !FT_FEOF()
                nAtual := nAtual + 1
                ProcRegua(nTotLinha)
                IncProc("Lendo a linha " + cValToChar(nAtual) + " de " + cValToChar(nTotLinha) + "...")       
                //Alert(" Passou Aqui 1 ! ")
                cLinha  := FT_FReadLn() // Retorna a linha corrente
                If  Empty(aCampos)
                    //Alert(" Passou Aqui 2 ! ")
                    aCampos := &("{'"+StrTran(cLinha,";","','")+"'}")
                Else
                    //Alert(" Passou Aqui 2 ! ")
                    aAdd(aItens,&("{'"+StrTran(cLinha,";","','")+"'}"))
                Endif
                FT_FSkip()
            End		
            FT_FUse()
            nTotal := Len(aItens)
        
    Endif   

    Processa({|| U_FGerArrExec(aCampos,aItens,cTipoImp)}, "Importando  ....")     

Return 


User Function FGerArrExec(aCampos,aItens,cTipoImp)
    Local aArrCabExec := {}
    Local aArrITNExec := {}
    Local x           := 0
    Local y           := 0
    Local cTypeLg     := ""
    Local cCampoCab   := "" 
    Local cCampoItn   := ""
    Local aItensSC6   := {}
    Local nTotLinha  := Len(aItens)
    Local nAtual     := 0

    lGravou := .F.
    lError  := .F.

	For x := 1 to Len(aItens)
        If Len(aItens[x]) == Len(aCampos)
            nAtual := nAtual+ 1
            ProcRegua(nTotLinha)
            IncProc("Lendo " + cValToChar(nAtual) + " de " + cValToChar(nTotLinha) + "...")       
            For y := 1 to Len(aCampos)
                if Alltrim(Upper(aItens[x][1])) <> "PULA_LINHA" //$ aItens[x][1]
                    If "CAB_" $ aCampos[y]  
                        If Alltrim(Upper(aItens[x][1])) <> "CABECALHO"
                            cCampoCab   := Alltrim(SubStr(aCampos[y],5,len(aCampos[y])))
                            cTypeLg     := FWSX3Util():GetFieldType(cCampoCab)
                            aadd(aArrCabExec,{cCampoCab , TrataCampo(aItens[x][y], cTypeLg  ) , Nil})	
                        Endif    
                    Else
            
                        cCampoItn   := Alltrim(SubStr(aCampos[y],5,len(aCampos[y])))
                        cTypeLg     := FWSX3Util():GetFieldType(cCampoItn) 
                        aadd(aArrITNExec,{cCampoItn , TrataCampo(aItens[x][y], cTypeLg ) , Nil})	  

                    Endif
                Else
                    
                    U_FGEREXECAUT(aArrCabExec,aItensSC6,cTipoImp)
                    aArrCabExec := {}
                    aArrITNExec := {}
                    aItensSC6   := {}
                    x := x+1
                    y := 0
                    If x > len(aItens)
                        MSGINFO( "Importacao finalizado com sucesso verifique a pasta  C:\LOGCSV\ ", "Imp.CSV" )
                        Return
                    Endif
                
                Endif    
            Next
            If cTipoImp == '01'
                aArrCabExec := FWVetByDic( aArrCabExec, 'SC5' )
                aArrITNExec := FWVetByDic( aArrITNExec, 'SC6' )
            ELseIf  cTipoImp == '02'
                aArrCabExec := FWVetByDic( aArrCabExec, 'SCJ' )
                aArrITNExec := FWVetByDic( aArrITNExec, 'SCK' )
            Endif   
            aadd(aItensSC6, aArrITNExec)
            
            y := 0  
            
            aArrITNExec := {}
        Else
            MSGINFO( "Cabecalho esta diferente dos itens, verifique a quantidade de campos x linha de itens", "Imp. Pedido CSV" )
            Return
        Endif

    next x

    if lGravou .and. !lError 
       FWAlertInfo("Importacao Finalizada com sucesso!","Informacao!")
    elseif lGravou .and. lError 
       FWAlertInfo("Importacao Finalizda com resultado parcial, pois apresentou restricoes","Informacao!")
    else 
       if !lGravou .and. lError
          FWAlertInfo("Importacao Finalizada e não importada. Por gentileza, verifique.","Informacao!")
       endif 
    Endif 

Return


User Function FGEREXECAUT(aArrCabExec,aItensSC6,cTipoImp)
    Local cRetExec  := ""
    Local cCodCli   := ""
    Local cLoja     := ""
    Local cTransp   := ""
    Local aRetLog   := {}
    Local nZ        := 0
    Local nX        := 0
    Local cLogName  := "IMPCSV"+ "_" + DToS(Date()) + "_" + StrTran(Time(), ":", "_")+".log"
    Local _cPastLoc := "c:\logcsv"

    //Variaveis Private tratativa de retorno da execauto.
    Private lMsErroAuto    := .F.
    //Para uso da GetAutoGrLog()
    Private lAutoErrNoFile := .T. 

    dbSelectArea("SA1")
    dbSetOrder( 1 )

    If Len(aItensSC6) > 0 .AND. Len(aArrCabExec) > 0 
        cCodCli := PadR(aArrCabExec[1, 2], GETSX3CACHE(aArrCabExec[1, 1], "X3_TAMANHO"),'')
        cLoja   := PadL(aArrCabExec[2, 2], GETSX3CACHE(aArrCabExec[2, 1], "X3_TAMANHO"),'0')
        cTransp := PadL(aArrCabExec[3, 2], GETSX3CACHE(aArrCabExec[3, 1], "X3_TAMANHO"),'0')
        aArrCabExec[2, 2] := cLoja
        If cTipoImp == '01'	
            aArrCabExec[3, 2] := iif(Empty(aArrCabExec[3, 2]),aArrCabExec[3, 2],cTransp)
            For nX := 1 to Len(aItensSC6)
                nPos := aScan(aItensSC6[nX], {|X| X[1]== "C6_ITEM"})
                aItensSC6[nX][nPos][2] := PadL(aItensSC6[nX][nPos][2], GETSX3CACHE(aItensSC6[nX][nPos][1], "X3_TAMANHO"),'0')
            next
        endif 
        SA1->( dbSeek(xFilial('SA1')+cCodCli+cLoja) )
        // Executa a inclusÃ£o do pedido de venda
        If cTipoImp == '01'		
            nPos := aScan(aArrCabExec, {|X| X[1]=="C5_CODMUN"})
            if nPos == 0
                aAdd(aArrCabExec,{"C5_CODMUN",SA1->A1_XFISCAL,"C"})
            endif 
            For nX := 1 to Len(aItensSC6)	
                nPos := aScan(aItensSC6[nX], {|x| x[1]=="C6_TES"})
                IF (nPos > 0) .AND. (!EMPTY(SA1->A1_XTES))
                    aItensSC6[nX][nPos][2] := SA1->A1_XTES
                endif 
            next
            lMsErroAuto := .F.
            
            MSExecAuto( { |a,b,c| MATA410(a,b,c) }, aArrCabExec, aItensSC6, 3)
        ELseIf  cTipoImp == '02'
            For nX := 1 to Len(aItensSC6)
                IF (!EMPTY(SA1->A1_XTES))
                    aAdd(aItensSC6[nX],{'CK_TES', SA1->A1_XTES,NIL})
                endif
            next 
            lMsErroAuto := .f.
            MATA415(aArrCabExec,aItensSC6,3)
        Endif
        // Foi necessário realizar este ajuste, devido a variavel lMsErroAuto
        // Não estar retornando o conteudo correto - Valdemir Rabelo 26/06/2023
        //cRetExec    := MostraErro(_cPastLoc,"\erro_"+cLogName)
        //lMsErroAuto := !Empty(cRetExec)
        // ------------------------
        
        //005576 - inclusão manual usado para comparar com a execução automática
        //Alteração realizado por Tiago Dias - 28/06/2023
        //váriavel lMsErroAuto sempre retorna .T. se ocorreu algum erro no ExecAuto, necessário verificar se o MostraErro() não está em branco,
        //se estiver, é por motivo de campo customizado como identificado no cadastro de cliente (A1_XTES) e layout do arquivo CSV.

        // Se execauto com erro
        If lMsErroAuto        
            MostraErro()    
            lError      := .T.
            cRetExec    := "Nao foi possi­vel incluir. " + CRLF
            aRetLog     := GetAutoGrLog()
            For nZ := 1 To Len(aRetLog)
                cRetExec += aRetLog[nZ] + CRLF
            Next nZ

            MSGALERT( "Erro na inclusão do Pedido", cRetExec )

            EECVIEW(cRetExec)
            MemoWrite(_cPastLoc+"\erro_"+cLogName, cRetExec)
        Else
            lGravou := .T.
            If cTipoImp == '01'	
                cRetExec := "PEDIDO INCLUIDO COM SUCESSO->"+SC5->C5_NUM
                MemoWrite(_cPastLoc+"\OK_"+SC5->C5_FILIAL+"_"+SC5->C5_NUM+"_"+cLogName, cRetExec)
                //Alert("INCLUIDO COM SUCESSO")
            ELseIf  cTipoImp == '02'
                cRetExec := "PRESUPUESTO INCLUIDO COM SUCESSO->"+SCJ->CJ_NUM
                MemoWrite(_cPastLoc+"\OK_"+SCJ->CJ_FILIAL+"_"+SCJ->CJ_NUM+"_"+cLogName, cRetExec)
            Endif
        Endif    
    Endif
		
Return 


User Function cCmpObrigat()
    Local aCmpSC5 :={}
    Local aCmpSC6 :={}
    Local x := 0
    Local cCriaArq := ""

    aCmpSC5:= FWSX3Util():GetAllFields( "SCJ" , .F. )
    aCmpSC6:= FWSX3Util():GetAllFields( "SCK" , .F. )
    
    for x := 1 to Len(aCmpSC5)
        If X3Obrigat(aCmpSC5[x])
            cCriaArq:= cCriaArq + "CAB_"+alltrim(aCmpSC5[x])+";"
        Endif
    next
    x:= 0
    for x := 1 to Len(aCmpSC6)
        If X3Obrigat(aCmpSC6[x])
            cCriaArq:= cCriaArq + "ITN_"+alltrim(aCmpSC6[x])+";"
        Endif  
    next
    
    MemoWrite("c:\log\cmpped.txt", cCriaArq)

Return

Static Function TrataCampo(xCampo,xTpType,lRetCmp,cTamCmp) 						
	Local  aArea    := GetArea()
	Local cRet
	Default lRetCmp := .T.

	If upper(xCampo) == ".T." .or. upper(xCampo) == ".F." 
		xTpType := "L"
	Endif

	Do Case
		Case xTpType == "L" 	
				If upper(xCampo) == ".T."
					cRet := .T.
				ELSE
					cRet := .F.
				ENDIF	
		Case xTpType == ValType(xCampo)//regra para campo logico
				cRet := xCampo
				/*
				If ValType(cRet) == "C"
				    lRetCmp := LEN(cRet) <= cTamCmp
				Else
					lRetCmp := .T.
				Endif
				*/
        Case xTpType == "N" .And. ValType(xCampo) == "C"
            //xCampo := StrTran(xCampo,".","")
            xCampo := StrTran(xCampo,",",".")
            //lRetCmp := LEN(xCampo) <= cTamCmp //VALIDA TAMNHO DO CAMPO
            cRet := Val(xCampo)

        Case xTpType == "C" .And. ValType(xCampo) == "N"
            cRet := AllTrim(Str(xCampo))
            //lRetCmp := LEN(cRet) <= cTamCmp //VALIDA TAMNHO DO CAMPO

        Case xTpType == "C" .And. ValType(xCampo) == "D"
            cRet := DtoC(xCampo)
            //lRetCmp := LEN(cRet) <= cTamCmp //VALIDA TAMNHO DO CAMPO

        Case xTpType = "D" .And. ValType(xCampo) == "C"
            //lRetCmp := LEN(xCampo) <= cTamCmp //VALIDA TAMNHO DO CAMPO
            cRet :=CtoD(xCampo)

            If Empty(cRet)
                cRet := StoD(xCampo)
            EndIf

        Case xTpType == "M"
            //cRet := xGrava
            cRet := xCampo
    EndCase

    RestArea(aArea)

return cRet


/*/{Protheus.doc} GatSCK
Rotina para gatilhar a TES no
Orçamento
@type function
@version 12.1.33
@author Valdemir Rabelo
@since 23/06/2023
@return variant, return_description
/*/
User Function GatSCK()
    Local cReadVar := ReadVar()
    Local uVarRet
    Local aAreaSa1 := FWGetArea()

    uVarRet := GetMemVar(cReadVar)

    IF SELECT("SA1")==0
       dbSelectArea("SA1")
       dbSetOrder(1)
    ENDIF 
    SA1->( dbSeek(xFilial("SA1")+M->CJ_CLIENTE+M->CJ_LOJA) )
    uVarRet := SA1->A1_XTES
    TMP1->CK_TES := uVarRet

	// Atualiza a Variável de Retorno
	cRETGERVR    := uVarRet
	//------------------------------------------------------------------------------------------------
	// Atualiza a Variável de Memória com o Conteúdo do Retorno
	SetMemVar(cReadVar,cRETGERVR)
    //VAR_IXB := uVarRet
	//------------------------------------------------------------------------------------------------
	// Força a atualização dos Componentes (Provavelmente não irá funcionar). A solução. ENTER
	SysRefresh(.T.)      

    FWRestArea( aAreaSA1 )

Return cRETGERVR
