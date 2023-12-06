
#INCLUDE "TOTVS.CH"

#Define ENTER  Chr(10) + Chr (13)

/*/{Protheus.doc} GERA338
Função para geração dos movimentos na MATA338
@type function
@author Tiago Castilho
@since 07/07/2023
/*/
User Function GERA338()

    If FWAlertNoYes("Essa rotina deve ser executada no último dia do mês, deseja continuar?",;
                "AVISO: TEM QUE EXECUTAR NO ÚLTIMO DIA DO MÊS!")

        oProcess := MsNewProcess():New({|| GERAEXC338(oProcess)}, "Atualizando dados!...", "Aguarde...", .T.)
        oProcess:Activate()
        FwFreeObj(oProcess)
    Endif

  

Return

Static function GERAEXC338(oObj)

    Local aArea             := {}
    Local aLog              := {}  
    Local aItem             := {}
    Local cAliasQry         := GetNextAlias()
    Local cDataCal          := DtoS(dDATABASE)
   	Local nLast             := 0
    Local nTotal            := 0  
    Local nX                := 0        

    Private bBlock          := ErrorBlock({|e|ChkErr(e)})
	Private cErrorL         := ""
    Private lMsErroAuto		:= .F.
	Private lMsHelpAuto		:= .T.
	Private lAutoErrNoFile	:= .T.

    Default oObj            := Nil

    aArea := {GetArea()}
    AADD(aArea,SB1->(GetArea()))
    AADD(aArea,SB2->(GetArea()))
    AADD(aArea,SDQ->(GetArea()))

    DbSelectArea("SB1")
    DbSelectArea("SB2")
    DbSelectArea("SDQ")

    SB1->(DbSetOrder(1))
    SB2->(DbSetOrder(1))
    SDQ->(DbSetOrder(1))
    
    SB1->(DbGoTop())
    SB2->(DbGoTop())
    SDQ->(DbGoTop())

    BeginSQL Alias cAliasQry
		SELECT
			B1_COD,
            R_E_C_N_O_ RegSB1	
			
		FROM
			%Table:SB1% SB1
		WHERE
				SB1.B1_FILIAL = %xfilial:SB1%
			AND SB1.B1_UCALSTD = %exp:cDataCal%
			AND SB1.%NotDel%

        ORDER BY  
            B1_COD
	EndSQL

    Count To nTotal

    (cAliasQry)->(DBGoTop())
    If (cAliasQry)->(!Eof())
        While (cAliasQry)->(!Eof())
            nLast ++
            oObj:SetRegua1(nLast)
            oObj:IncRegua1("Validando data produto " + Alltrim(SB1->B1_COD) + "...")

            nRegSB1 := (cAliasQry)->RegSB1
            
            SB1->(DbGoTo(nRegSB1))

            If SB1->(Recno()) == nRegSB1 
                If SB2->(DbSeek(xFilial("SB2") + SB1->B1_COD))
                    While SB2->(!EoF()).And. SB2->B2_FILIAL + SB2->B2_COD == xFilial("SB2") + SB1->B1_COD
                            
                        oObj:IncRegua1("Validando Saldo do Produto " + Alltrim(SB1->B1_COD) + " no armazem " + Alltrim(SB2->B2_LOCAL) + "...")

                        nSaldoAtu := SaldoSB2() 

                        If nSaldoAtu > 0 
                            //Incrementa a mensagem na régua
                            oObj:SetRegua2(nTotal)
                            oObj:IncRegua2("Gerando MATA338 do produto " + Alltrim(SB2->B2_COD) + " para o armazem " + Alltrim(SB2->B2_LOCAL) + "...")
                            
                            IF SDQ->(!DbSeek(xFilial("SDQ")+Avkey(SB2->B2_COD,"B2_COD")+Avkey(SB2->B2_LOCAL,"B2_LOCAL")+DtoS(dDATABASE)))

                                lMsErroAuto := .F.

                                aItem := {}
                                AAdd(aItem,{"DQ_COD"    ,SB2->B2_COD    ,Nil})
                                AAdd(aItem,{"DQ_LOCAL"  ,SB2->B2_LOCAL  ,Nil})
                                AAdd(aItem,{"DQ_DATA"   ,dDATABASE      ,Nil})
                                AAdd(aItem,{"DQ_CM1"    ,SB1->B1_UPRC   ,Nil})
                                AAdd(aItem,{"DQ_CM2"    ,SB1->B1_CUSTD  ,Nil})
                                AAdd(aItem,{"DQ_CM3"    ,0              ,Nil})
                                AAdd(aItem,{"DQ_CM4"    ,0              ,Nil})
                        
                                MSExecAuto({|x,y,z| MATA338(x,y)},aItem,3)//3-Inclusão, 4-Alteração e 5-Exclusão 
                                If lMsErroAuto 
                                    aLog := GetAutoGRLog()
                                    For nX := 1 To Len(aLog)
                                        cMsgErro += aLog[nX] + " "
                                    Next nX
                                    eecView("********ERRO DE EXECAUTO - MATA338 ********"+ENTER+ENTER+cMsgErro)
                                Endif
                            Endif
                        Endif

                        SB2->( dbSkip() )
                    EndDo
                Endif
            Endif
            (cAliasQry)->( dbSkip() )
        EndDo
        
        ErrorBlock(bBlock) // Capturar error log

        If !Empty(cErrorL)
            eecView(cErrorL)
        Else 
            FWAlertSuccess("Inclusão no MATA338 executada com sucesso", "Processamento Finalizado!")
        Endif
    Else
        FWAlertError("Não retornou nenhuma informação no select!", "Erro no Select!")
    Endif


    (cAliasQry)->( DbCloseArea() )

    AEval(aArea, {|aArea| RestArea(aArea)})
    FwFreeArray(aArea)
    FwFreeArray(aLog)
    FwFreeArray(aItem)

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
