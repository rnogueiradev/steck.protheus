#include "totvs.ch" 
#INCLUDE "TBICONN.CH"

#DEFINE ENTER CHAR(13) + CHAR(10)

/*
    desenvolvedor: Ricardo Minoro
    data: 16/06/2023
    descrição: job para executar a fila para deletar empenhos
*/

User Function JOBDELEMP(cNewEmp,lJobExec,cOpProc)

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
    
    LockByName("JOBDELEMP", .T., .F.)

        CONOUT("[JOBDELEMP] [Emp: " + cNewEmp + "] - Monitoramento Deleção de Empenho(s)-INICIO Hora:" + Time() + " Data: " + DTOC(DDATABASE) )
        //Processar atualização do job
        ProcessaJob(cOpProc)
        
        CONOUT("[JOBDELEMP] - Monitoramento Deleção de Empenho(s)-FIM. Hora:" + Time() + " Data: " + DTOC(DDATABASE) )

    UnlockByName("JOBDELEMP", .T., .F., .F.)

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
    Local cTipDoc 	:= "2"
    Local cArmProd	:= supergetmv( "FS_LOCPROD" ,.F. , "90" )
    Local cCodSep   := ""
    Local aTransf   := {}

	cQry := "SELECT         " + ENTER
    cQry += "   CB7_PEDIDO, " + ENTER
    cQry += "   CB7_OP,     " + ENTER
    cQry += "   CB7_CODOPE, " + ENTER
    cQry += "   CB7_ORDSEP " + ENTER
	cQry += " FROM " + RetSqlName("CB7") + " CB7 "  + ENTER
	cQry += " WHERE CB7_FILIAL = '" + xFilial("CB7") + "'" + ENTER
	cQry += " AND CB7_STATUS = '9' " + ENTER
    cQry += " AND CB7_XETAPA = '01' " + ENTER
    cQry += " AND CB7_PEDIDO = ' ' " + ENTER
    cQry += " AND CB7.D_E_L_E_T_ = ' ' " + ENTER
    cQry += " AND ROWNUM = 1 "
    cQry += " GROUP BY CB7_PEDIDO, CB7_OP, CB7_CODOPE, CB7_ORDSEP "
    cQry += " ORDER BY CB7_ORDSEP "
	
    cQry := ChangeQuery(cQry) 
    cTmpAlias   := MPSysOpenQuery(cQry)

	CONOUT("[JOBDELEMP] - Monitoramento de Deleção Empenho(s)-Selecionados dados para processamento. Hora:" + Time() + " Data: " + DTOC(DDATABASE) )

	If (cTmpAlias)->(!eof())

		dbselectarea("CB7")
        CB7->( dbsetorder(1) )

        cCodSep := (cTmpAlias)->CB7_ORDSEP

		While (cTmpAlias)->(!eof())

            /*CB8->( dbseek( xFilial("CB8") + cCodSep ))
            while CB8->( !eof() ) .and. CB8->CB8_FILIAL == xFilial("CB8") .and. CB8->CB8_ORDSEP == cCodSep
                reclock("CB8", .F.)
                    cMsgProc	:= ""
                    cMsgProc 	+= alltrim(CB8->CB8_XMPROC) + CHR(13)+CHR(10)
                    cMsgProc 	+= replicate("-",30) + CHR(13)+CHR(10)
                    cMsgProc 	+= "Data: " + dtoc(ddatabase) + " - Hora: " + time() + " - [JOBDELEMP] Status: Processamento iniciando..."
                    CB8->CB8_XMPROC     := cMsgProc
                    CB8->CB8_XSTATUS    := "1" 
                CB8->( msunlock() )
                CB8->(dbskip())
            enddo*/
            CB7->( dbseek(xFilial("CB7") + cCodSep ) )
            reclock("CB7", .F.)
                cMsgProc	:= ""
                cMsgProc 	+= alltrim(CB7->CB7_XMPROC) + CHR(13)+CHR(10)
                cMsgProc 	+= replicate("-",30) + CHR(13)+CHR(10)
                cMsgProc 	+= "Data: " + dtoc(ddatabase) + " - Hora: " + time() + " - [JOBDELEMP] Status: Processamento iniciando..."
                CB7->CB7_XMPROC     := cMsgProc
                CB7->CB7_XSTATUS    := "1" 
            CB7->( msunlock() )
			
			aTransf := VerTransf( (cTmpAlias)->CB7_PEDIDO, cArmProd, (cTmpAlias)->CB7_CODOPE, cCodSep )

			(cTmpAlias)->(DbSkip())

		EndDo
        
	EndIF
	(cTmpAlias)->(dbCloseArea())

    if len(aTransf) > 0 

        DelEmp(cTipDoc,aTransf,cArmProd)
        //ProxEtapa()
        reclock("CB7", .F.)
            CB7->CB7_XETAPA     := "02"
            cMsgProc	:= ""
            cMsgProc 	+= alltrim(CB7->CB7_XMPROC) + CHR(13)+CHR(10)
            cMsgProc 	+= replicate("-",30) + CHR(13)+CHR(10)
            cMsgProc 	+= "Data: " + dtoc(ddatabase) + " - Hora: " + time() + " - [JOBDELEMP] Status: Processamento finalizada..."
            CB7->CB7_XMPROC     := cMsgProc
        CB7->( msunlock() )

    endif

Return


/*
    função para buscar os dados na tabela CB9 e montar array de retorno
*/
Static Function VerTransf(cTipDoc,cArmProd,cXOper,cOrdSep)

	Local aArea		:= GetArea()
	Local aRet		:= {}

	//Como estou posicionado no CB7, vou buscar o CB9 para a comparacao do armazem
	CB9->(DbSetOrder(1)) //CB9_FILIAL+CB9_ORDSEP+CB9_CODETI
	CB9->(DbSeek(xFilial("CB9")+cOrdSep))
	While CB9->(!Eof() .and. CB9_FILIAL + CB9_ORDSEP == xFilial("CB9") + cOrdSep )

		If !(CB9->CB9_LOCAL == cArmProd) .and. CB9->CB9_STATUS == "1"
			
			Aadd( aRet, {   CB9->CB9_PROD,;      //produto
                            CB9->CB9_QTESEP,;    //quantidade
                            CB9->CB9_LOCAL,;     //local origem
                            cArmProd,;      //local destino
                            CB9->CB9_LCALIZ,;    //endereco
                            CB9->CB9_LOTSUG,;    //lote
                            CB9->CB9_SLOTSU,;    //sublote
                            "",;            //D4_TRT
                            ""})            //D4_OPORIG

		Endif
		CB9->(DbSkip())

	Enddo

	RestArea(aArea)

Return aRet

Static Function DelEmp( cTipDoc, aTransf, cArmProd )

	Local aArea		:= GetArea()
    Local lAchou    := .F.

	If cTipDoc == "1" // pedido

		SC6->(DbSetOrder(1))
		SC9->(DbSetOrder(1)) //C9_FILIAL+C9_PEDIDO+C9_ITEM+C9_SEQUEN+C9_PRODUTO

		SC6->(DbSeek(xFilial('SC6')+CB7->CB7_PEDIDO))
		While SC6->(! Eof() .and. C6_FILIAL+C6_NUM == xFilial('SC6')+CB7->CB7_PEDIDO)

			If ( nPos := ascan(aTransf,{|x| x[1] == SC6->C6_PRODUTO}) ) == 0
				SC6->(DbSkip())
				Loop
			Endif

			U_STDelSDC(SC6->C6_NUM,SC6->C6_PRODUTO,Iif(Empty(CB7->CB7_XOSPAI),CB7->CB7_ORDSEP,CB7->CB7_XOSPAI),SC6->(Recno()),.F.)

			SC6->(DbSkip())
		End
	else
        
        dbselectarea("CB8")
        CB8->( dbsetorder(7) )

        dbselectarea("SDC")
        SDC->( dbsetorder(2) )

		SD4->(DbSetOrder(2))
		SD4->(DbSeek( xFilial('SD4') + Alltrim(CB7->CB7_OP) ))

        Begin Transaction 

            While SD4->(! Eof() .and. D4_FILIAL + Alltrim(D4_OP) == xFilial('SD4') + Alltrim(CB7->CB7_OP))

                If ( nPos := ascan(aTransf,{|x| x[1] == SD4->D4_COD }) ) == 0
                    SD4->(DBSkip())
                    Loop
                EndIf
                If Empty(SD4->D4_XORDSEP)
                    SD4->(DBSkip())
                    Loop
                Endif

                aTransf[nPos,8] := SD4->D4_TRT
                aTransf[nPos,9] := SD4->D4_OPORIG

                U_STDelSDC( CB7->CB7_OP, SD4->D4_COD, CB7->CB7_ORDSEP, SD4->(Recno()) )

                SDC->( dbgotop() )
                if SDC->( dbseek( xFilial("SDC") + SD4->D4_COD + SD4->D4_LOCAL + SD4->D4_OP + SD4->D4_TRT + SD4->D4_LOTECTL + SD4->D4_NUMLOTE ) )
                    lAchou := .T.
                else
                    lAchou := .F.
                endif

                CB8->( dbgotop() )
                if CB8->( dbseek( xFilial("CB8") + CB7->CB7_ORDSEP + SD4->D4_LOCAL + aTransf[nPos,5] + SD4->D4_COD + SD4->D4_LOTECTL + SD4->D4_NUMLOTE ) )
                    reclock("CB8",.F.)
                        if lAchou
                            cMsgErro := "-- Erro de Deleção Empenho - Data: " +dtoc(ddatabase) + " - hora: " + time()
                            //CB8->CB8_XSTATU    := '3'
                            //CB8->CB8_XMPROC     := ALLTRIM(CB8->CB8_XMPROC) + CHR(13)+CHR(10) + cMsgErro
                            //CB8->CB8_XMERRO     := cMsgErro
                        else
                            cMsgProc	:= ""
                            //cMsgProc 	+= alltrim(CB8->CB8_XMPROC) + CHR(13)+CHR(10)
                            cMsgProc 	+= replicate("-",30) + CHR(13)+CHR(10)
                            cMsgProc 	+= "Data: " + dtoc(ddatabase) + " - Hora: " + time() + " - [JOBDELEMP] Status: Processamento executado com sucesso..."
                            CB8->CB8_XMPROC     := cMsgProc
                            CB8->CB8_XETAPA     := "01"
                            //CB8->CB8_XSTATU    := "2" 
                        endif
                    CB8->( msunlock() )
                endif

                SD4->(DbSkip())
            End

        End Transaction

	EndIf

	RestArea(aArea)

Return

static function ProxEtapa()

    local aArea     := getarea()
    local lContinua := .T.

    dbselectarea("CB8")
    CB8->( dbsetorder(1) )
    if CB8->( dbseek( xfilial("CB8") + CB7->CB7_ORDSEP ) )
        Begin Transaction 
            while CB8->(!eof()) .and. CB8->CB8_FILIAL == xFilial("CB8") .and. CB8->CB8_ORDSEP == CB7->CB7_ORDSEP .and. lContinua

                if CB8->CB8_XETAPA == "01" .and. CB8->CB8_XSTATUS == "2"
                    Reclock("CB8", .F.)
                        CB8->CB8_XETAPA     := "02"
                        //CB8->CB8_XSTATU    := "0"
                    CB8->( msunlock() )
                else
                    lContinua := .F.
                    DisarmTransaction()
                endif

                CB8->( dbskip() )
            enddo
            reclock("CB7", .F.)
                CB7->CB7_XETAPA     := "02"
            CB7->( msunlock() )
        End Transaction 
    endif

    restarea(aArea)

return
