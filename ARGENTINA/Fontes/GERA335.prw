
#INCLUDE "TOTVS.CH"

#Define ENTER  Chr(10) + Chr (13)

/*/{Protheus.doc} GERA335
Função para geração dos movimentos na MATA335
@type function
@author Tiago Castilho
@since 07/07/2023
/*/
User Function GERA335()

    If FWAlertNoYes("Essa rotina deve ser executada no último dia do mês, deseja continuar?",;
                    "AVISO: TEM QUE EXECUTAR NO ÚLTIMO DIA DO MÊS!")

        oProcess := MsNewProcess():New({|| GERAEXC335(oProcess)}, "Atualizando dados!...", "Aguarde...", .T.)
        oProcess:Activate()

        FwFreeObj(oProcess)

    Endif
  
Return

Static function GERAEXC335(oObj)

    Local aArea         := {}
    Local cAliasQry     := GetNextAlias()
    Local cDocumento    := ''
    Local cDataatual    := DtoS(dDATABASE)
    Local nLast         := 0
    Local nTotal        := 0  
           
    Private bBlock      := ErrorBlock({|e|ChkErr(e)})
	Private cErrorL     := ""
   
    Default oObj        := Nil

    aArea := {GetArea()}
    AADD(aArea,SB1->(GetArea()))
    AADD(aArea,SB2->(GetArea()))
    AADD(aArea,SD3->(GetArea()))

    DbSelectArea("SB1")
    DbSelectArea("SB2")
    DbSelectArea("SD3")
    
    SB1->(DbSetOrder(1))
    SB2->(DbSetOrder(1))
    SD3->(DbSetOrder(1))

    SB1->(DbGoTop())
    SB2->(DbGoTop())
    SD3->(DbGoTop())
    
    BeginSQL Alias cAliasQry
		SELECT
	        R_E_C_N_O_ RegSB1 
			
		FROM
			%Table:SB1% SB1
		WHERE
				SB1.B1_FILIAL  = %xfilial:SB1%
            AND sb1.B1_UCALSTD = %Exp:cDataatual%
		    AND SB1.%NotDel%

        ORDER BY R_E_C_N_O_
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

                        nSaldoAtu := 1 //SaldoSB2() 

                        If nSaldoAtu > 0 
                            //Incrementa a mensagem na régua
                            oObj:SetRegua2(nTotal)
                            oObj:IncRegua2("Gerando MATA338 do produto " + Alltrim(SB2->B2_COD) + " para o armazem " + Alltrim(SB2->B2_LOCAL) + "...")
                    
                            // Cria movimento na moeda 1
                            cDocumento := NextNumero("SD3",2,"D3_DOC",.T.)
                            RecLock("SD3",.T.)
                            SD3->D3_FILIAL	:= xFilial("SD3")
                            SD3->D3_COD		:= SB2->B2_COD
                            SD3->D3_TM		:= "499"
                            SD3->D3_LOCAL	:= SB2->B2_LOCAL
                            SD3->D3_DOC		:= cDocumento
                            SD3->D3_EMISSAO	:= dDATABASE
                            SD3->D3_NUMSEQ	:= ProxNum()
                            SD3->D3_UM		:= SB1->B1_UM
                            SD3->D3_GRUPO	:= SB1->B1_GRUPO
                            SD3->D3_TIPO	:= SB1->B1_TIPO
                            SD3->D3_SEGUM	:= SB1->B1_SEGUM
                            SD3->D3_CONTA	:= SB1->B1_CONTA
                            SD3->D3_CF		:= "DE6"
                            SD3->D3_STATUS	:= "RP" //AJUSTE CUSTO DE REPOSICAO
                            SD3->D3_USUARIO	:= SubStr(cUsuario,7,15)
                            SD3->D3_CMRP	:= ROUND(SB1->B1_UPRC,4)
                            SD3->D3_MOEDRP  := '1'
                            SD3->(MsUnLock())

                            // Cria movimento na moeda 2
                            cDocumento := ' '
                            cDocumento := NextNumero("SD3",2,"D3_DOC",.T.)
                            RecLock("SD3",.T.)
                            SD3->D3_FILIAL	:= xFilial("SD3")
                            SD3->D3_COD		:= SB2->B2_COD
                            SD3->D3_TM		:= "499"
                            SD3->D3_LOCAL	:= SB2->B2_LOCAL
                            SD3->D3_DOC		:= cDocumento
                            SD3->D3_EMISSAO	:= dDATABASE
                            SD3->D3_NUMSEQ	:= ProxNum()
                            SD3->D3_UM		:= SB1->B1_UM
                            SD3->D3_GRUPO	:= SB1->B1_GRUPO
                            SD3->D3_TIPO	:= SB1->B1_TIPO
                            SD3->D3_SEGUM	:= SB1->B1_SEGUM
                            SD3->D3_CONTA	:= SB1->B1_CONTA
                            SD3->D3_CF		:= "DE6"
                            SD3->D3_STATUS	:= "RP" //AJUSTE CUSTO DE REPOSICAO
                            SD3->D3_USUARIO	:= SubStr(cUsuario,7,15)
                            SD3->D3_CMRP	:= SB1->B1_CUSTD
                            SD3->D3_MOEDRP  := '2'
                            SD3->(MsUnLock())
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
