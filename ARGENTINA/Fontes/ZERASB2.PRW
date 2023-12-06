
#INCLUDE "TOTVS.CH"

/*/{Protheus.doc} ZERASB2
Função para limpeza dos custos de quantidade zerasS
@type function
@author Tiago Castilho
@since 07/07/2023
/*/
User Function ZERASB2()

    If FWAlertNoYes("Essa rotina deve ser executada no último dia do mês, deseja continuar?",;
                "AVISO: TEM QUE EXECUTAR NO ÚLTIMO DIA DO MÊS!")

        oProcess := MsNewProcess():New({|| CUSTOSB2(oProcess)}, "Atualizando dados!...", "Aguarde...", .T.)
        oProcess:Activate()
    
        FwFreeObj(oProcess)
    Endif

Return

Static function CUSTOSB2(oObj)

    Local aArea     := {}
    Local cMsg      := ""
  	Local nLast     := 0
    Local nTotal    := 0          

    Private bBlock  := ErrorBlock({|e|ChkErr(e)})
	Private cErrorL := ""

    Default oObj    := Nil

    aArea := {GetArea()}
    AADD(aArea,SB2->(GetArea()))

    DbSelectArea("SB2")
    SB2->(DbSetOrder(1))
    SB2->(DbGoTop())

    nTotal := SB2->(RecNo())

    cMsg += "==========  FINALIZADO COM SUCESSO ========== " +CRLF +CRLF +CRLF
    cMsg += "LINHA"+';'+"B2_COD"+';'+ "B2_LOCAL"+ CRLF

    While SB2->(EoF())
        nLast ++
        
        oObj:SetRegua1(nLast)
        oObj:IncRegua1("Validando Saldo do Produto " + Alltrim(SB2->B2_COD) + " no armazem " + Alltrim(SB2->B2_LOCAL) + "...")

        nSaldoAtu := SaldoSB2() 

        If nSaldoAtu <= 0 
            //Incrementa a mensagem na régua
            oObj:SetRegua2(nTotal)
            oObj:IncRegua2("Zerando custo do Produto " + Alltrim(SB2->B2_COD) + " no armazem " + Alltrim(SB2->B2_LOCAL) + "...")
            
            cMsg += CvalToChar(nAtual)+';'+Alltrim(SB2->B2_COD)+';'+cValToChar(SB2->B2_LOCAL)+ CRLF

            RecLock("SB2", .F.)
            SB2->B2_CM1      := 0
            SB2->B2_CM2      := 0
            SB2->B2_CM3      := 0
            SB2->B2_CM4      := 0
            SB2->B2_CM5      := 0
            SB2->B2_CMFIM1   := 0
            SB2->B2_CMFIM2   := 0
            SB2->B2_CMFIM3   := 0
            SB2->B2_CMFIM4   := 0
            SB2->B2_CMFIM5   := 0
            SB2->B2_CMRP1    := 0
            SB2->B2_CMRP2    := 0
            SB2->B2_CMRP3    := 0
            SB2->B2_CMRP4    := 0
            SB2->B2_CMRP5    := 0
            SB2->B2_VFRP1    := 0
            SB2->B2_VFRP2    := 0
            SB2->B2_VFRP3    := 0
            SB2->B2_VFRP4    := 0
            SB2->B2_VFRP5    := 0
            SB2->B2_VATU1    := 0
            SB2->B2_VATU2    := 0
            SB2->B2_VATU3    := 0
            SB2->B2_VATU4    := 0
            SB2->B2_VATU5    := 0
            SB2->(MsUnlock())
        Endif
    
        SB2->( dbSkip() )
	EndDo

    ErrorBlock(bBlock) // Capturar error log

	If !Empty(cErrorL)
        eecView(cErrorL)
    Else
        eecView(cMsg)
    Endif

    AEval(aArea, {|aArea| RestArea(aArea)})
    FwFreeArray(aArea)

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
