#include "totvs.ch" 
#INCLUDE "TBICONN.CH"

#DEFINE ENTER CHAR(13) + CHAR(10)

/*
    desenvolvedor: Ricardo Minoro
    data: 16/06/2023
    descrição: job para executar a fila para deletar empenhos
*/

User Function JOBINCEMP(cNewEmp,lJobExec,cOpProc)

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
    
    LockByName("JOBINCEMP", .T., .F.)

        CONOUT("[JOBINCEMP] [Emp: " + cNewEmp + "] - Monitoramento Criação de Empenho(s)-INICIO Hora:" + Time() + " Data: " + DTOC(DDATABASE) )
        //Processar atualização do job
        ProcessaJob(cOpProc)
        
        CONOUT("[JOBINCEMP] - Monitoramento Criação de Empenho(s)-FIM. Hora:" + Time() + " Data: " + DTOC(DDATABASE) )

    UnlockByName("JOBINCEMP", .T., .F., .F.)

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
    Local cArmExp 	:= GetMv("FS_ARMEXP")
	Local cArmEst 	:= GetMv("FS_ARMEST")
    Local cArmComp	:= Iif(cTipDoc == "1",cArmExp,cArmEst)
    Local cCodSep   := ""
	Local aTransf	:= {}
    PRIVATE cAlias3   	    := getnextalias()

	cArmComp := cArmProd

	cQry := "SELECT         " + ENTER
    cQry += "   CB7_PEDIDO, " + ENTER
    cQry += "   CB7_OP,     " + ENTER
    cQry += "   CB7_CODOPE, " + ENTER
    cQry += "   CB7_ORDSEP " + ENTER
	cQry += " FROM " + RetSqlName("CB7") + " CB7 "  + ENTER
	cQry += " WHERE CB7_FILIAL = '" + xFilial("CB7") + "'" + ENTER
	cQry += " AND CB7_STATUS = '9' " + ENTER
    cQry += " AND CB7_XETAPA = '03' " + ENTER
    cQry += " AND CB7.D_E_L_E_T_ = ' ' " + ENTER
    cQry += " AND ROWNUM = 1 "
    cQry += " GROUP BY CB7_PEDIDO, CB7_OP, CB7_CODOPE, CB7_ORDSEP "
    cQry += " ORDER BY CB7_ORDSEP "
	
    cQry := ChangeQuery(cQry) 
    cTmpAlias   := MPSysOpenQuery(cQry)

	CONOUT("[JOBINCEMP] - Monitoramento de Criação Empenho(s)-Selecionados dados para processamento. Hora:" + Time() + " Data: " + DTOC(DDATABASE) )

	If (cTmpAlias)->(!eof())

		dbselectarea("CB8")
        CB8->( dbsetorder(1) )

        cCodSep := (cTmpAlias)->CB7_ORDSEP

		While (cTmpAlias)->(!eof())

            /*CB8->( dbseek( xFilial("CB8") + cCodSep ))
            while CB8->( !eof() ) .and. CB8->CB8_FILIAL == xFilial("CB8") .and. CB8->CB8_ORDSEP == cCodSep
                reclock("CB8", .F.)
                    cMsgProc	:= ""
                    cMsgProc 	+= alltrim(CB8->CB8_XMPROC) + CHR(13)+CHR(10)
                    cMsgProc 	+= replicate("-",30) + CHR(13)+CHR(10)
                    cMsgProc 	+= "Data: " + dtoc(ddatabase) + " - Hora: " + time() + " - [JOBINCEMP] Status: Processamento iniciando..."
                    CB8->CB8_XMPROC     := cMsgProc
                    CB8->CB8_XSTATUS    := "1" 
                    CB8->CB8_XETAPA     := "03"
                CB8->( msunlock() )
                CB8->(dbskip())
            enddo*/
			
			aTransf := VerTransf( (cTmpAlias)->CB7_PEDIDO, cArmProd, (cTmpAlias)->CB7_CODOPE, cCodSep )

			(cTmpAlias)->(DbSkip())

		EndDo
        
	EndIF
	(cTmpAlias)->(dbCloseArea())

	if len(aTransf) > 0
		conout("possui dados.......")
		dbselectarea("CB7")
		CB7->( dbsetorder(1) )
		CB7->( dbseek( xFilial("CB7") + cCodSep ) )

		CRIAALIAS( CB7->CB7_OP, aTransf )
		CriaEmp(cTipDoc,aTransf,cArmComp,CB7->CB7_OP)
		reclock("CB7", .F.)
			CB7->CB7_XETAPA := "99"
			cMsgProc	:= ""
            cMsgProc 	+= alltrim(CB7->CB7_XMPROC) + CHR(13)+CHR(10)
            cMsgProc 	+= replicate("-",30) + CHR(13)+CHR(10)
            cMsgProc 	+= "Data: " + dtoc(ddatabase) + " - Hora: " + time() + " - [JOBINCEMP] Status: Processamento executado com sucesso..."
			CB7->CB7_XMPROC     := cMsgProc 
		CB7->( msunlock() )

		(cAlias3)->(dbclosearea())
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

Static Function CriaEmp(cTipDoc,aTransf,cArmComp,cDoc)

	Local aSaldos	:= {}
	Local lUsaVenc	:= SuperGetMv('MV_LOTVENC')=='S'
	Local nReserva	:= 0
	Local cOSSeek	:= CB7->CB7_ORDSEP
	Local cOSPai	:= CB7->CB7_XOSPAI
	Local nI

	If cTipDoc == "1" // pedido

		SC6->(DbSetOrder(1))
		SC9->(DbSetOrder(1)) //C9_FILIAL+C9_PEDIDO+C9_ITEM+C9_SEQUEN+C9_PRODUTO

		SC6->(DbSeek(xFilial('SC6')+cDoc))
		While SC6->(! Eof() .and. C6_FILIAL+C6_NUM == xFilial('SC6')+cDoc)
			If ( nPos := ascan(aTransf,{|x| x[1] == SC6->C6_PRODUTO}) ) == 0
				SC6->(DbSkip())
				Loop
			Endif

			nReserva := aTransf[nPos,2]

			//Ajusta o armazem no PEDIDO DE VENDA
			/*		SC6->(RecLock("SC6",.F.))
			SC6->C6_LOCAL := cArmComp
			SC6->(MsUnlock())          Retirado dia 09/04/2013 pois estava pegando o c6_local errado*/

			If cEmpAnt=="11" .And. cFilAnt=="01"
				aSaldos := U_SLDSTECK(SC6->C6_PRODUTO,SC6->C6_LOCAL,nReserva,ConvUm(SC6->C6_PRODUTO,2,0,nReserva),SC6->C6_LOTECTL,SC6->C6_NUMLOTE,SC6->C6_LOCALIZ,SC6->C6_NUMSERI,NIL,NIL,NIL,lUsaVenc,nil,nil,dDataBase)
			Else
				If Rastro(SC6->C6_PRODUTO)
					aSaldos := SldPorLote(SC6->C6_PRODUTO,SC6->C6_LOCAL,nReserva,ConvUm(SC6->C6_PRODUTO,2,0,nReserva),SC6->C6_LOTECTL,SC6->C6_NUMLOTE,SC6->C6_LOCALIZ,SC6->C6_NUMSERI,NIL,NIL,NIL,lUsaVenc,nil,nil,dDataBase)
				Else
					aSaldos := {{ "","","","",nReserva,ConvUm(SC6->C6_PRODUTO,2,0,nReserva),Ctod(""),"","","",cArmComp,0}}
				Endif
			EndIf

			nRecno:= SC6->(Recno())
			MaLibDoFat(SC6->(Recno()),nReserva,.T.,.T.,.F.,.F.,.F.,.F.,Nil,{||SC9->C9_ORDSEP:= Iif(Empty(CB7->CB7_XOSPAI),CB7->CB7_ORDSEP,CB7->CB7_XOSPAI) },aSaldos,Nil,Nil,Nil)
			MaLiberOk({SC6->C6_NUM},.F.)
			MsUnLockall()
			SC6->(DbGoto(nRecno))
			SC6->(DbSkip())
		End
	Else

		JOBSD4DEL(cDoc)

		U_STMONISDC(cDoc)

	EndIf
    //Ajusta o CB8/CB9
    CB8->(DbSetOrder(1)) //CB8_FILIAL+CB8_ORDSEP+CB8_ITEM+CB8_SEQUEN+CB8_PROD
    //CB9->(DbSetOrder(1)) //CB9_FILIAL+CB9_ORDSEP+CB9_CODETI
    CB9->(DbSetOrder(6)) //CB9_FILIAL+CB9_ORDSEP+CB9_ITESEP+CB9_PROD+CB9_LOCAL+CB9_LCALIZ+CB9_LOTECT+C

    For nI:=1 to 2 //Ajusta a OrdSep atual e a Pai se houver

        If nI == 2
            cOSSeek := cOSPai
        Endif
        CB8->(DbSeek(xFilial("CB8")+cOSSeek))

        While CB8->(!Eof() .and. CB8_FILIAL+CB8_ORDSEP == xFilial('CB8')+cOSSeek)

            If CB8->CB8_SALDOS > 0 .and. nI == 1
                CB8->(DbSkip())
                Loop
            Endif

            If CB8->CB8_LOCAL == cArmComp
                CB8->(DbSkip())
                Loop
            Endif

            If ( nPos := ascan(aTransf,{|x| x[1] == CB8->CB8_PROD}) ) == 0
                CB8->(DbSkip())
                Loop
            Endif

            CB8->(RecLock("CB8",.F.))
                CB8->CB8_LOCAL := cArmComp
            CB8->(MsUnlock())
            CB8->(DbCommit())

            CB9->(DbSeek(xFilial("CB9")+CB8->(CB8_ORDSEP+CB8_ITEM+CB8_PROD)))

            While CB9->(!Eof() .and. CB9_FILIAL+CB9_ORDSEP+CB9_ITESEP+CB9_PROD == xFilial("CB9")+CB8->(CB8_ORDSEP+CB8_ITEM+CB8_PROD))
                If !(CB9->CB9_LOCAL == cArmComp) .and. CB9->CB9_STATUS == "1"
                    CB9->(RecLock("CB9",.F.))
                        CB9->CB9_LOCAL := cArmComp
                    CB9->(MsUnlock())
                    CB9->(DbCommit())
                Endif
                CB9->(DbSkip())
            End
            CB8->(DbSkip())
        Enddo
    Next

Return


static function JOBSD4DEL(cDoc)
	*----------------------------------------------------------------------------------*
	Local aSD4x := {}
	Local cOP	:= Padr(cDoc,14)
	Local cQuery        := ""
	Local cAlias4		:= "STGIOSD4"
	Local cPerg       	:= "STGIOSD4999"
	Local cTime         := Time()
	Local cHora         := SUBSTR(cTime, 1, 2)
	Local cMinutos    	:= SUBSTR(cTime, 4, 2)
	Local cSegundos   	:= SUBSTR(cTime, 7, 2)
	Local cxAliasLif   	    := cPerg+cHora+ cMinutos+cSegundos
	Local aTravas		:={}
	Local cAux 			:= Subs(Dtos(dDatabase)+StrTran(Time(),":",""),2)
	Local aSaldo 		:= {}
	Local aLotes 		:= {}
	Local aAlias3		:= {}
	Local aAlias3a		:= {}
	Local _nPosProd		:= 0
	Local nX:= 0
	Local nXz:= 0
	Local nxx:= 0

	SD4->(DbSetOrder(2))
	If	SD4->(DbSeek(xFilial('SD4')+cOP))

		dbSelectArea(cAlias3)
		(cAlias3)->(dbGoTop())

		do While (cAlias3)->(!Eof())
			aadd(aAlias3,{ (cAlias3)->PRODUTO,(cAlias3)->FALTA,(cAlias3)->SOMA,(cAlias3)->OP ,(cAlias3)->TRT })
			(cAlias3)->(DbSkip())
		EndDo

		While SD4->(! Eof() .and. D4_FILIAL+D4_OP == xFilial('SD4')+cOP)
			If ! Empty(SD4->D4_XORDSEP)
				SD4->(DBSkip())
				Loop
			EndIf
			_nPosProd     := aScan(aAlias3, { |x| Alltrim(x[1]) == Alltrim(SD4->D4_COD)   })
			If _nPosProd > 0
				aadd(aSD4x,SD4->(Recno()))
				_nPosProd:=0
			EndIf

			SD4->(DbSkip())
		End

		For nX:= 1 to len(aSD4x)
			// eliminar o sd4 original.
			SD4->(DbGoto(aSD4x[nX]))

			SD4->(RecLock('SD4',.F.))
			SD4->(DbDelete())
			SD4->(MsUnlock())
			SD4->(DbCommit())
		Next nx

		For nX:= 1 to len(aAlias3)

			If aAlias3[nX,2] > 0

				A650ReplD4(;
				aAlias3[nX,1] ,;
				'01',;
				dDataBase,;
				aAlias3[nX,2],;
				aAlias3[nX,4],;
				aAlias3[nX,5],;
				NIL,;
				NIL,;
				NIL,;
				Repl("Z",13))
			EndIf
			//CRIO A SD4 DE ACORDO COM SDC
			aSaldo := SldPorLote(aAlias3[nX,1] ,'90',aAlias3[nX,3])
			aLotes := {}
			For nXz:= 1 to len(aSaldo)
				nPos := ascan(aLotes,{|x| x[1] == aSaldo[nXz,1]})
				If nPos == 0
					aadd(aLotes,aClone(aSaldo[nxz]))
				Else
					aLotes[nPos,5] +=	aSaldo[nxz,5]
					aLotes[nPos,6] +=	aSaldo[nxz,6]
				EndIf
			Next nxz
			A650ReplD4(;
			aAlias3[nX,1] ,;
			'90',;
			dDataBase,;
			aAlias3[nX,3],;
			aAlias3[nX,4],;
			aAlias3[nX,5],;
			NIL,;
			NIL,;
			NIL,;
			Subs(Dtos(dDatabase)+StrTran(Time(),":",""),2))
			For nXx:= 1 to len(aLotes)
				//CONOUT(aAlias3[nX,1] + " - GRAVAEMP")
				GravaEmp(aAlias3[nX,1],;      					// produto
				'90',;							// local
				aLotes[nXx,5],;					// qtde 1 un
				aLotes[nXx,6],;					// qtde 2 un
				aLotes[nXx,1],;					// lote
				aLotes[nXx,2],;					// num lote
				NIL,;							// endereço
				NIL,;							// numero de serie
				aAlias3[nX,4],;					// op
				aAlias3[nX,5],;				// sequencia
				NIL,;							// pedido de venda
				NIL,;							// item do pedido
				"SC2",;							// origem
				cAux,;							// op original
				dDataBase,;						// data de entrega
				@aTravas,;						// controle de travas nao sei o que faz
				.F.,;							// estorno
				NIL,;							// integracao PMS
				.T.,;              				// atualiz sb2
				.F.,;							// gera sd4
				NIL,;				  			// considera lote vencido
				.T.,;							// Empenha SB8 e SBF
				.T.,;  							//	CriaSDC
				NIL,;                      		// Encerra OP
				aAlias3[nX,4])					// ID DCF, estamos utilizando este campo nos espeficios no ACD

				MaDestrava(aTravas)

			Next nxx

		Next nx

	EndIf
Return()

static function CriaAlias(cDoc,_aTrans)

	Local cOP			:= Padr(cDoc,14)
	Local cQuery        := ""
	Local _cPrOs        := ' '
	Local i:=0

	For i:= 1 To Len(_aTrans)
		If i = 1
			_cPrOs := "( '"+_aTrans[i,1]+"'"
		Else
			_cPrOs += ",'"+_aTrans[i,1]+"'"
		EndIf

	Next i

	_cPrOs        += " )"
	//CONOUT(_cPrOs )
	cQuery := " SELECT DC_FILIAL, DC_ORIGEM, DC_PRODUTO AS PRODUTO , DC_LOCAL, SUM(DC_QUANT) AS SOMA , DC_OP AS OP,DC_TRT AS TRT,
	cQuery += " NVL((SELECT  SUM (PA1_QUANT)
	cQuery += " FROM "+RetSqlName("PA1")+" PA1 "
	cQuery += " WHERE PA1.D_E_L_E_T_ = ' ' AND  PA1_CODPRO = DC_PRODUTO AND PA1_TIPO = '2' AND PA1_DOC = DC_OP AND PA1_FILIAL = DC_FILIAL),0)
	cQuery += " AS FALTA
	cQuery += " FROM "+RetSqlName("SDC")+" DC "
	cQuery += " INNER JOIN "+RetSqlName("CB7")+" CB7 "
	cQuery += " 	ON CB7_FILIAL = DC_FILIAL "
	cQuery += " 	AND CB7_OP = DC_OP "
	cQuery += " 	AND CB7.D_E_L_E_T_ = ' ' "
	cQuery += " INNER JOIN "+RetSqlName("CB9")+" CB9 "
	cQuery += " 	ON CB9_FILIAL = CB7_FILIAL "
	cQuery += " 	AND CB9_ORDSEP = CB7_ORDSEP "
	cQuery += " 	AND CB9_PROD = DC_PRODUTO "
	cQuery += "		AND CB9_LOCAL = DC_LOCAL "
	cQuery += "		AND CB9_LCALIZ = DC_LOCALIZ "
	cQuery += " 	AND CB9.D_E_L_E_T_ = ' ' "
	cQuery += " WHERE DC.D_E_L_E_T_='*' AND DC_OP= '"+cOP+"' AND DC_FILIAL = '"+xFilial("SDC")+"'
	cQuery += " AND DC_PRODUTO IN "+_cPrOs

	cQuery += " GROUP BY DC_FILIAL, DC_ORIGEM, DC_PRODUTO, DC_LOCAL, DC_OP,DC_TRT

	If !Empty(Select(cAlias3))
		DbSelectArea(cAlias3)
		(cAlias3)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias3,.T.,.T.)
Return()
