#include "totvs.ch" 
#INCLUDE "TBICONN.CH"


#DEFINE ENTER CHAR(13) + CHAR(10)

/*
    desenvolvedor: Ricardo Minoro
    data: 16/06/2023
    descrição: job para executar a fila para deletar empenhos
*/

User Function JOBTRFCB7(cNewEmp,lJobExec,cOpProc)

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

    LockByName("JOBTRFCB7", .T., .F.)
    
        CONOUT("[JOBTRFCB7] [Emp: " + cNewEmp + "] - Monitoramento Transferencias-INICIO Hora:" + Time() + " Data: " + DTOC(DDATABASE) )
        //Processar atualização do job
        ProcessaJob(cOpProc)
        
        CONOUT("[JOBTRFCB7] - Monitoramento Transferencias-FIM. Hora:" + Time() + " Data: " + DTOC(DDATABASE) )
    
    UnlockByName("JOBTRFCB7", .T., .F., .F.)

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
    Local lRet      := .T.
    Local cArmProd	:= supergetmv( "FS_LOCPROD" ,.F. , "90" )
	Local cCodSep	:= ""
	Local aTransf   := {}

	cQry := "SELECT 		" + ENTER
    cQry += "   CB7_PEDIDO, " + ENTER
    cQry += "   CB7_OP,     " + ENTER
    cQry += "   CB7_CODOPE, " + ENTER
    cQry += "   CB7_ORDSEP " + ENTER
	cQry += " FROM " + RetSqlName("CB7") + " CB7 "  + ENTER
	cQry += " WHERE CB7_FILIAL = '" + xFilial("CB7") + "'" + ENTER
	cQry += " AND CB7_STATUS = '9' " + ENTER
    cQry += " AND CB7_XETAPA = '02' " + ENTER
	cQry += " AND CB7_XSTATU <> '3' " + ENTER
    cQry += " AND CB7.D_E_L_E_T_ = ' ' " + ENTER
	cQry += " AND ROWNUM = 1 " + ENTER
    cQry += " GROUP BY CB7_PEDIDO, CB7_OP, CB7_CODOPE, CB7_ORDSEP " + ENTER
    cQry += " ORDER BY CB7_ORDSEP " + ENTER
	
    cQry := ChangeQuery(cQry) 
    cTmpAlias   := MPSysOpenQuery(cQry)

	CONOUT("[JOBTRFCB7] - Monitoramento de Transferencias-Selecionados dados para processamento. Hora:" + Time() + " Data: " + DTOC(DDATABASE) )

	If (cTmpAlias)->(!eof())

		//dbselectarea("CB8")

		cCodSep := (cTmpAlias)->CB7_ORDSEP
		
		dbselectarea("CB7")
		CB7->( dbsetorder(1) )
		CB7->( dbseek( xFilial("CB7") + cCodSep ) )

		While (cTmpAlias)->(!eof())

            /*CB8->( dbgoto( (cTmpAlias)->CB8RECNO ))
            reclock("CB8", .F.)
                cMsgProc	:= ""
                cMsgProc 	+= alltrim(CB8->CB8_XMPROC) + CHR(13)+CHR(10)
                cMsgProc 	+= replicate("-",30) + CHR(13)+CHR(10)
                cMsgProc 	+= "Data: " + dtoc(ddatabase) + " - Hora: " + time() + " - [JOBTRFCB7] Status: Processamento iniciando..."
                CB8->CB8_XMPROC     := cMsgProc
                CB8->CB8_XSTATUS    := "1" 
            CB8->( msunlock() )*/
			reclock("CB7", .F.)
                cMsgProc	:= ""
                cMsgProc 	+= alltrim(CB7->CB7_XMPROC) + CHR(13)+CHR(10)
                cMsgProc 	+= replicate("-",30) + CHR(13)+CHR(10)
                cMsgProc 	+= "Data: " + dtoc(ddatabase) + " - Hora: " + time() + " - [JOBTRFCB7] Status: Processamento iniciando..."
                CB7->CB7_XMPROC     := cMsgProc
                //CB7->CB7_XSTATUS    := "1" 
            CB7->( msunlock() )
			
			
			aTransf := VerTransf( (cTmpAlias)->CB7_PEDIDO, cArmProd, (cTmpAlias)->CB7_CODOPE, cCodSep )

			(cTmpAlias)->(DbSkip())

		EndDo
        
	EndIF
	(cTmpAlias)->(dbCloseArea())

	if len(aTransf) > 0

		lRet := TransfArm(aTransf,CB7->CB7_CODOPE,.F.)
		if lRet
			if CB7->CB7_XETAPA == "02"
				Reclock("CB7", .F.)
					CB7->CB7_XETAPA := "03"
				CB7->( msunlock() )
			endif
		endif
	endif

Return


/*
    função para buscar os dados na tabela CB9 e montar array de retorno
*/
Static Function VerTransf(cTipDoc,cArmComp,cXOper,cOrdSep)

	Local aArea		:= GetArea()
	Local aRet		:= {}

	//Como estou posicionado no CB7, vou buscar o CB9 para a comparacao do armazem
	CB9->(DbSetOrder(1)) //CB9_FILIAL+CB9_ORDSEP+CB9_CODETI
	CB9->(DbSeek(xFilial("CB9")+cOrdSep))
	While CB9->(!Eof() .and. CB9_FILIAL + CB9_ORDSEP == xFilial("CB9") + cOrdSep )

		If !(CB9->CB9_LOCAL == cArmComp) .and. CB9->CB9_STATUS == "1"
			
			Aadd( aRet, {   CB9->CB9_PROD,;      //produto
                            CB9->CB9_QTESEP,;    //quantidade
                            CB9->CB9_LOCAL,;     //local origem
                            cArmComp,;      //local destino
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

Static Function TransfArm(aDados,cxOPER,lTela)

	Local dValid	:= dDatabase
	Local aArea		:= GetArea()
	Local cEndPad	:= Iif(!Empty(CB7->CB7_PEDIDO),GetMv("FS_ENDEXP",.F.,"EMBALAGEM"),GetMv("FS_ENDPAD",.F.,"PRODUCAO"))
	Local nI
	Local nxQuant := 0
	Local cTmpAliasSD3 := ""
	Local lSemErro	:= .F.
	
	Private lMsErroAuto	:= .F.
	Private lRetExec  :=.t.
	Private aTransf	:= {}
	Private cPath	:= "\logtransf\"

	//-----------------------------------------------------------------------------------------------------------//
	//FR - 29/09/2022 - Ticket #20220928018340 - reprocessar transferência (qdo não realizada via coletor)
	Default lTela := .F.  	//esta variável indicará se a chamada veio direto do Protheus e não via coletor,
							//se for via coletor, lTela = .F. , 
							//se for via tela de prioridade, esta variável fica = .T.
	//-----------------------------------------------------------------------------------------------------------//							

	nxQuant :=xArraLen(aDados,cxOPER)
	SB2->(DbSetOrder(1))
	SBE->(DbSetOrder(1)) //BE_FILIAL+BE_LOCAL+BE_LOCALIZ
	//aadd(aLista,{cProduto,nQtdeProd,cArmOri,cLote,cSLote,cNumSerie})

	aTransf:=Array(nxQuant+1)
	aTransf[1] := {"OS." + CB7->CB7_ORDSEP,dDataBase}

	For nI := 1 to nxQuant
		If lRetExec
			SB1->(dbSeek(xFilial("SB1")+aDados[nI,1]))
			dValid := dDatabase+SB1->B1_PRVALID

			If Rastro(aDados[nI,1])
				SB8->(DbSetOrder(3)) //B8_FILIAL+B8_PRODUTO+B8_LOCAL+B8_LOTECTL+B8_NUMLOTE+DTOS(B8_DTVALID)
				SB8->(DbSeek(xFilial("SB8")+aDados[nI,1]+aDados[nI,3]+aDados[nI,6]+AllTrim(aDados[nI,7])))
				dValid := SB8->B8_DTVALID
			EndIf

			If !SB2->(DbSeek(xFilial("SB2")+aDados[nI,1]+aDados[nI,4]))
				CriaSB2(aDados[nI,1],aDados[nI,4])
			EndIf

			aTransf[nI+1]:=  {{"D3_COD" 		, SB1->B1_COD						,NIL}}
			aAdd(aTransf[nI+1],{"D3_DESCRI" , SB1->B1_DESC							,NIL})
			aAdd(aTransf[nI+1],{"D3_UM"     , SB1->B1_UM							,NIL})
			aAdd(aTransf[nI+1],{"D3_LOCAL"  , aDados[nI,3]							,NIL})
			aAdd(aTransf[nI+1],{"D3_LOCALIZ", aDados[nI,5]							,NIL})
			aAdd(aTransf[nI+1],{"D3_COD"    , SB1->B1_COD							,NIL})
			aAdd(aTransf[nI+1],{"D3_DESCRI" , SB1->B1_DESC							,NIL})
			aAdd(aTransf[nI+1],{"D3_UM"     , SB1->B1_UM							,NIL})
			aAdd(aTransf[nI+1],{"D3_LOCAL"  , aDados[nI,4]							,NIL})
			aAdd(aTransf[nI+1],{"D3_LOCALIZ", cEndPad								,NIL})
			aAdd(aTransf[nI+1],{"D3_NUMSERI", CriaVar("D3_NUMSERI",.F.) 			,NIL})//numserie
			aAdd(aTransf[nI+1],{"D3_LOTECTL", criavar("D3_LOTECTL",.F.)			,NIL})//lote
			aAdd(aTransf[nI+1],{"D3_NUMLOTE", criavar("D3_NUMLOTE",.F.)			,NIL})//sublote
			aAdd(aTransf[nI+1],{"D3_DTVALID", criavar("D3_DTVALID",.F.)			,NIL})
			aAdd(aTransf[nI+1],{"D3_POTENCI", criavar("D3_POTENCI",.F.)			,NIL})
			aAdd(aTransf[nI+1],{"D3_QUANT"  , aDados[nI,2]							,NIL})
			aAdd(aTransf[nI+1],{"D3_QTSEGUM", CriaVar("D3_QTSEGUM",.F.)			,NIL})
			aAdd(aTransf[nI+1],{"D3_ESTORNO", CriaVar("D3_ESTORNO",.F.)			,NIL})
			aAdd(aTransf[nI+1],{"D3_NUMSEQ" , CriaVar("D3_NUMSEQ",.F.)				,NIL})
			aAdd(aTransf[nI+1],{"D3_LOTECTL", criavar("D3_LOTECTL",.F.)			,NIL})
			aAdd(aTransf[nI+1],{"D3_DTVALID", criavar("D3_DTVALID",.F.)			,NIL})

		Endif
	Next nI
		
    MSExecAuto({|x,y| MATA261(x,y)},aTransf,3)		
	
	If lMsErroAuto

		if cEmpAnt == "03"

			cQry := "SELECT 				" + ENTER
			cQry += "   COUNT(*) AS MOVIM 	" + ENTER
			cQry += " FROM " + RetSqlName("SD3") + " SD3 "  + ENTER
			cQry += " WHERE D3_FILIAL = '" + xFilial("SD3") + "'" + ENTER
			cQry += " AND D3_EMISSAO = '" + dtos(ddatabase) + "' " + ENTER
			cQry += " AND D3_DOC LIKE '%OS." + alltrim(CB7->CB7_ORDSEP) + "%' " + ENTER
			cQry += " AND SD3.D_E_L_E_T_ = ' ' " + ENTER
			
			cQry := ChangeQuery(cQry) 
			cTmpAliasSD3   := MPSysOpenQuery(cQry)
			if select(cTmpAliasSD3) > 0 
				if (cTmpAliasSD3)->MOVIM > 0
					lSemErro := .T.
				endif
			endif
			(cTmpAliasSD3)->(dbclosearea())

			if !lSemErro
				reclock("CB7", .F.)
					cMsgProc	:= ""
					cMsgProc 	+= alltrim(CB7->CB7_XMPROC) + CHR(13)+CHR(10)
					cMsgProc 	+= replicate("-",30) + CHR(13)+CHR(10)
					cMsgProc 	+= "Data: " + dtoc(ddatabase) + " - Hora: " + time() + " - [JOBTRFCB7] Status: Processamento gerou erro..."
					CB7->CB7_XMERRO     := mostraerro("/")
					CB7->CB7_XSTATUS    := "3"
					CB7->CB7_XMPROC     := cMsgProc 
				CB7->( msunlock() )
				lSemErro := .F.
			else
				reclock("CB7", .F.)
					cMsgProc	:= ""
					cMsgProc 	+= alltrim(CB7->CB7_XMPROC) + CHR(13)+CHR(10)
					cMsgProc 	+= replicate("-",30) + CHR(13)+CHR(10)
					cMsgProc 	+= "Data: " + dtoc(ddatabase) + " - Hora: " + time() + " - [JOBTRFCB7] Status: Processamento executado com sucesso..."
					CB7->CB7_XSTATUS    := "2"
					CB7->CB7_XMPROC     := cMsgProc 
				CB7->( msunlock() )
				lSemErro := .T.
			endif
		else
			reclock("CB7", .F.)
				cMsgProc	:= ""
				cMsgProc 	+= alltrim(CB7->CB7_XMPROC) + CHR(13)+CHR(10)
				cMsgProc 	+= replicate("-",30) + CHR(13)+CHR(10)
				cMsgProc 	+= "Data: " + dtoc(ddatabase) + " - Hora: " + time() + " - [JOBTRFCB7] Status: Processamento gerou erro..."
				CB7->CB7_XMERRO     := mostraerro("/")
				CB7->CB7_XSTATUS    := "3"
				CB7->CB7_XMPROC     := cMsgProc 
			CB7->( msunlock() )
			lSemErro := .F.
		endif

	else
		cQry := "SELECT 				" + ENTER
		cQry += "   COUNT(*) AS MOVIM 	" + ENTER
		cQry += " FROM " + RetSqlName("SD3") + " SD3 "  + ENTER
		cQry += " WHERE D3_FILIAL = '" + xFilial("SD3") + "'" + ENTER
		cQry += " AND D3_EMISSAO = '" + dtos(ddatabase) + "' " + ENTER
		cQry += " AND D3_DOC LIKE '%OS." + alltrim(CB7->CB7_ORDSEP) + "%' " + ENTER
		cQry += " AND SD3.D_E_L_E_T_ = ' ' " + ENTER
		
		cQry := ChangeQuery(cQry) 
		cTmpAliasSD3   := MPSysOpenQuery(cQry)
		if select(cTmpAliasSD3) > 0 
			if (cTmpAliasSD3)->MOVIM > 0
				lSemErro := .T.
			endif
		endif
		(cTmpAliasSD3)->(dbclosearea())
		if lSemErro
			reclock("CB7", .F.)
				cMsgProc	:= ""
				cMsgProc 	+= alltrim(CB7->CB7_XMPROC) + CHR(13)+CHR(10)
				cMsgProc 	+= replicate("-",30) + CHR(13)+CHR(10)
				cMsgProc 	+= "Data: " + dtoc(ddatabase) + " - Hora: " + time() + " - [JOBTRFCB7] Status: Processamento executado com sucesso..."
				CB7->CB7_XSTATUS    := "2"
				CB7->CB7_XMPROC     := cMsgProc 
			CB7->( msunlock() )
		else
			reclock("CB7", .F.)
				cMsgProc	:= ""
				cMsgProc 	+= alltrim(CB7->CB7_XMPROC) + CHR(13)+CHR(10)
				cMsgProc 	+= replicate("-",30) + CHR(13)+CHR(10)
				cMsgProc 	+= "Data: " + dtoc(ddatabase) + " - Hora: " + time() + " - [JOBTRFCB7] Status: Processamento gerou erro..."
				CB7->CB7_XSTATUS    := "3"
				CB7->CB7_XMPROC     := cMsgProc 
			CB7->( msunlock() )
			lSemErro := .F.
		endif
    endif

	RestArea(aArea)

Return lSemErro


Static Function xArraLen(aDados,cCodOpe)   //giovani

	Local nxretDados:=0
	Local i:= 0
	DbSelectArea("CB1")
	CB1->(DbSetOrder(1))
	If  CB1->(DbSeek(xFilial('CB1')+cCodOpe))
		For i:=1 To Len(aDados)
			If aDados[i,3]  = CB1->CB1_XLOCAL
				nxretDados+=1
			Endif
		Next i
	Endif
	If 	nxretDados=0
		nxretDados:=Len(aDados)
	EndIf
Return (nxretDados)
