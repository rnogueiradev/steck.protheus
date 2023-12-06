#include "totvs.ch" 
#INCLUDE "TBICONN.CH"

#DEFINE ENTER CHAR(13) + CHAR(10)

/*
    desenvolvedor: Ricardo Minoro
    data: 16/06/2023
    descrição: job para executar a fila para deletar empenhos
*/

User Function JOBPRECB7(cNewEmp,lJobExec,cOpProc)

	Private nqtdExec   := 0	
	Private _lok       := .F.	

	Default lJobExec :=".T."
	Default cOpProc  := "2"
    Default cNewEmp  := "03"

	If IsBlind() .Or. &(lJobExec)

		if cNewEmp == "03"
		    cNewFil := "01"
        elseif cNewEmp == "01"
            cNewFil := "05"
        endif

		Reset Environment

		RpcSetType( 3 )
		RpcSetEnv( cNewEmp, cNewFil,,,"PCP")

	EndIf

    LockByName("JOBPRECB7", .T., .F.)
    
        CONOUT("[JOBPRECB7] [Emp: " + cNewEmp + "]- Monitoramento Preparar Etapa Deleção Empenho-INICIO Hora:" + Time() + " Data: " + DTOC(DDATABASE) )
        //Processar atualização do job
        ProcessaJob(cOpProc)
        
        CONOUT("[JOBPRECB7] - Monitoramento Preparar Etapa Deleção Empenho-FIM. Hora:" + Time() + " Data: " + DTOC(DDATABASE) )

    UnlockByName("JOBPRECB7", .T., .F., .F.)

	If IsBlind() .Or. &(lJobExec)
		Reset Environment
	EndIf

Return

/*
    função para processamento do job em fila de deleção de empenho
*/
Static Function ProcessaJob(cOpProc)

	Local cQry      := ""
    Local cTmpAlias := ""
    Local aArea     := getarea()
    Local aLoc90    := {}

	cQry := "SELECT  " + ENTER
    cQry += "   CB7_ORDSEP  " + ENTER
	cQry += " FROM " + RetSqlName("CB7") + " CB7 "  + ENTER
	cQry += " WHERE CB7_FILIAL = '" + xFilial("CB7") + "'" + ENTER
	cQry += " AND CB7_STATUS = '9' " + ENTER
    cQry += " AND CB7_XETAPA = '00' " + ENTER
    cQry += " AND CB7_PEDIDO = ' ' " + ENTER
    cQry += " AND CB7.D_E_L_E_T_ = ' ' " + ENTER
    cQry += " AND ROWNUM = 1 "
    cQry += " GROUP BY CB7_ORDSEP "
    cQry += " ORDER BY CB7_ORDSEP "
	
    cQry := ChangeQuery(cQry) 
    cTmpAlias   := MPSysOpenQuery(cQry)

	CONOUT("[JOBPRECB7] - Monitoramento Preparar Etapa Deleção Empenho-Selecionados dados para processamento. Hora:" + Time() + " Data: " + DTOC(DDATABASE) )

	If (cTmpAlias)->(!eof())

		dbselectarea("CB8")
        CB8->( dbsetorder(1) )
        CB8->( dbgotop() )

        dbselectarea("CB7")
        CB7->( dbsetorder(1) )

        Begin Transaction 

            While (cTmpAlias)->(!eof())
                
                aLoc90 := {}
                if CB8->( dbseek( xFilial("CB8") + (cTmpAlias)->CB7_ORDSEP ) )
                    while CB8->( !eof()) .and. CB8->CB8_FILIAL == xFilial("CB8") .and. CB8->CB8_ORDSEP == (cTmpAlias)->CB7_ORDSEP
                        if CB8->CB8_LOCAL == "90"
                            aadd(aLoc90, { CB8->CB8_ORDSEP, CB8->CB8_ITEM, CB8->CB8_PROD, CB8->CB8_LOCAL })
                        endif
                        CB8->( dbskip() )
                    enddo
                endif
                
                if len(aLoc90) > 0
                    if CB7->( dbseek( xFilial("CB7") + (cTmpAlias)->CB7_ORDSEP ) )
                        reclock("CB7", .F.)
                            CB7->CB7_XETAPA := "99"
                            cMsgProc	:= ""
                            //cMsgProc 	+= alltrim(CB8->CB8_XMPROC) + CHR(13)+CHR(10)
                            cMsgProc 	+= replicate("-",30) + CHR(13)+CHR(10)
                            cMsgProc 	+= "Data: " + dtoc(ddatabase) + " - Hora: " + time() + " - [JOBPRECB7] Status: Processamento executado com sucesso..."
                            cMsgProc 	+= replicate("-",30) + CHR(13)+CHR(10)
                            cMsgProc 	+= "--------------Separação já consta com Armazem 90 ---------------"
                            CB7->CB7_XMPROC     := cMsgProc
                            CB7->CB7_XSTATUS := "0"
                        CB7->( msunlock() )
                    endif
                else
                    if CB7->( dbseek( xFilial("CB7") + (cTmpAlias)->CB7_ORDSEP ) )
                        reclock("CB7", .F.)
                            CB7->CB7_XETAPA := "01"
                            cMsgProc	:= ""
                            //cMsgProc 	+= alltrim(CB8->CB8_XMPROC) + CHR(13)+CHR(10)
                            cMsgProc 	+= replicate("-",30) + CHR(13)+CHR(10)
                            cMsgProc 	+= "Data: " + dtoc(ddatabase) + " - Hora: " + time() + " - [JOBPRECB7] Status: Processamento executado com sucesso..."
                            CB7->CB7_XMPROC     := cMsgProc
                            CB7->CB7_XSTATUS := "0"
                        CB7->( msunlock() )
                    endif
                endif

                (cTmpAlias)->(DbSkip())
            EndDo
            
        End Transaction 
	EndIF

	(cTmpAlias)->(dbCloseArea())

    restarea(aArea)

Return
