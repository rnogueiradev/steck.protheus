#Include "Protheus.ch"
#Include "RwMake.ch"
#Include "Ap5Mail.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "Topconn.ch"
#DEFINE CR    chr(13)+ chr(10)


/*/{Protheus.doc} STFATJOB
description
Rotina para enviar WF apresentando os campos alterados
Ticket 20191106000024,
@type function
@version Protheus 12 - Job para Faturamento Automatico
@author Everson Santana
@since 13/11/2020
@param aEnv, array, param_description
@return return_type, return_description
u_STFATJOB
/*/
User Function STFATJOB()

	Local lRet 			:= .T.
	Local i    			:= 0
	Local cAliasLif   	:= ' '
	Local cQuery     	:= ' '
	Local _aOderSep		:= {}
	Local lJob          := .F.
	public cFilAnt     := ""

	RpcSetType( 3 )
	//RpcSetEnv("01","02",,,"FAT") 
	RpcSetEnv("11","01",,,"FAT")       // Valdemir Rabelo 10/02/2022

	DbSelectArea("CB7")
	CB7->(DbSetOrder(1)) //CB7_FILIAL+CB7_ORDSEP
	
	cFilAnt := "01"

	lJob := GetMv('ST_FATBLQ',,.F.)
	If !lJob
		Return
	EndIf

	cAliasLif   	:= GetNextAlias()

	cQuery := " SELECT * FROM "+RetSqlName("CB7")+" CB7 "
	//-->> Clientes Autorizados a Faturar Automaticamente
	cQuery += " INNER JOIN "+RetSqlName("SA1")+" SA1 "
	cQuery += "    ON SA1.A1_FILIAL = ' ' "
	cQuery += "        AND SA1.A1_COD = CB7.CB7_CLIENT "
	cQuery += "        AND SA1.A1_LOJA = CB7.CB7_LOJA "
	cQuery += "        AND SA1.A1_XFATAU = '1' "
	cQuery += "        AND SA1.A1_EST NOT IN('EX') "
	//-->>Estado que precisa de Guia GNRE ST/DIFAL(PE/RO/SE/TO/CE/MT) - PIN(RO/AM/RR/AC/AP)
	// cQuery += "        AND SA1.A1_EST NOT IN('EX','PE','RO','SE','TO','CE','MT','AM','RR','AC','AP') "
	//--<<
	cQuery += "        AND SA1.D_E_L_E_T_ = ' ' "
	//--<<

	//-->> Alerta Faturamento
	cQuery += " INNER JOIN "+RetSqlName("SC5")+" SC5 "
	cQuery += "    ON SC5.C5_FILIAL = CB7.CB7_FILIAL "
	cQuery += "        AND SC5.C5_NUM = CB7.CB7_PEDIDO "
	cQuery += "        AND SC5.C5_XALERTF = ' ' "
	cQuery += "        AND SC5.C5_ZREFNF  = ' ' " //Refaturamento
	//cQuery += "        AND SC5.C5_XTIPO = '1' " //Somente Retira
	cQuery += "        AND SC5.D_E_L_E_T_ = ' ' "

cQuery += "  INNER JOIN (
cQuery += " SELECT * 
cQuery += "  FROM (
cQuery += "  SELECT CB6_FILIAL, CB6_XORDSE, COUNT(*) QTD, SUM(CASE WHEN CB6_XPESO>0 THEN 1 ELSE 0 END) QTDPES
cQuery += "   FROM "+RetSqlName("CB6")+" CB6 
cQuery += "   WHERE CB6.D_E_L_E_T_=' '
cQuery += "   GROUP BY CB6_FILIAL, CB6_XORDSE
cQuery += "  ) XXX
cQuery += "  WHERE QTD=QTDPES
cQuery += "  ) XXX ON CB6_FILIAL=CB7_FILIAL AND CB6_XORDSE=CB7_ORDSEP	

	//--<<
	cQuery += " WHERE CB7.CB7_STATUS = '4'" //-- Embalagem Finalizada
	//cQuery += " AND CB7.CB7_FILIAL = '02' "
	cQuery += " AND CB7.CB7_FILIAL = '01' "     // Valdemir Rabelo 16/05/2022 - Chamado: 20220516010273
	cQuery += " AND CB7_NOTA = ' ' "
	cQuery += " AND CB7_LOCAL = '03' "
	cQuery += " AND CB7.D_E_L_E_T_ = ' ' "
	//cQuery += " AND CB7_PEDIDO = '023792' "          // Comentar essa linha após teste - Valdemir Rabelo 20/05/2021 - Ticket: 20210318004396
 
	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

	If  Select(cAliasLif) > 0
		(cAliasLif)->(dbgotop())

		While !(cAliasLif)->(Eof())
			i++
			
			If i >= 1
				_aOderSep:={}
				aadd(_aOderSep,{   (cAliasLif)->CB7_ORDSEP,(cAliasLif)->CB7_PEDIDO ,' '})
				//StartJob("U_STFATJOC",GetEnvServer(), .F.,_aOderSep)
				
				Conout("Iniciando processamento da OS "+(cAliasLif)->CB7_ORDSEP)
				U_STFATJOC(_aOderSep)
				Conout("Finalizado processamento da OS "+(cAliasLif)->CB7_ORDSEP)

				i:=0

				sleep(1000)
			EndIf
            

			(cAliasLif)->(dbSkip())
		End
	EndIf

	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	Reset Environment

Return(lRet)


/*/{Protheus.doc}

@type function U_STFATJOC
@author Everson Santana
@since 13/11/2020
@version Protheus 12 - StartJob para Faturamento Automatico

@history Ticket 20191106000024,

/*/
User Function STFATJOC(_aOderSep)

	Local cQuery    := ""
	Local _cQuery2  := ""
	Local _nx       := 0
	Local _cLockBy	:= ""
	Local aPvlNfs   := {}
	Local _cNota    := ""
	Local _cSerAm   := '001'
	Local lRet      := .T.
	Local cQryTab	:= ""
	Local nQRegSC9	:= 0
	Local nQtdISC9	:= 0
	Local nQRegCB8	:= 0
	Local nQtdICB8	:= 0
	Local aRestr    := {}
	Local nJ        := 0
	Local cIdEnt    := ""
	Local aListBox  := {}
	Local nTenta    := 0
	Local cErrNFE   := ""
	Local cUrl		:= Padr( GetNewPar("MV_SPEDURL",""), 250 )
	Local cModel    := ""
	Local lCTe      := .F.
	Local lMDFe     := .F.	
	Local lNFCE	    := IIf (FunName()$"LOJA701",.T.,.F.)
	Local nTempo    := 0

	Local cSerie     := ''
	Local cNotaIni   := ''
	Local cNotaFim   := ''
	Local lTMS       := .F.
	Local lAutoColab := .F.
	Local lExibTela  := .F. // Não exibe se Falso
	Local lUsaColab  := .F.
	Local lICC       := .F.
	Local _cInvent      := .T. // Variavel para analisar se no pedido de venda existe algum item em inventario rotativo
	Local _lInc			:= .T.
	Local _cQuery3  	:= ""
	Local _cAlias3  	:= GetNextAlias()
	Private _cPeInve		:= ' '
	Private _cProdInv		:= ' '
	Private lUsaColab	:= UsaColaboracao("1")
	Private cUSACOLAB	:= GetNewPar("MV_SPEDCOL","N")
	Private cDOCSCOL	:= GetNewPar("MV_DOCSCOL","")

	Private cCondicao  	:= ""
	Private cCondQry   	:= ""
	Private cIdEnt		:= ""
	Private cCadastro  	:= ""
	Private cVersaoTSS	:= ""
	Private LINCOND
	public cFilAnt     := ""

	lUsaColab := UsaColaboracao( IIF(lCte,"2",IIF(lMDFe,"5",IIF(lNFCE,,"1"))))
	if lUsaColab .And. Empty(cModel)
		cModel := Iif(lCte,"57",iif(lMDFe,"58","55"))
	endif	

	If Len(_aOderSep)>0
		_cLockBy		:= "STFATJOC"+cValToChar(_aOderSep[1,1])
	Else
		_cLockBy		:= "STFATJOC"
	EndIf

	cFilAnt := "01"

	If !LockByName(_cLockBy,.F.,.F.,.T.)
		Return()
	EndIf

	// Verifico se a tabela existe - Valdemir Rabelo 14/05/2021 - Ticket: 20210211002338
	if TCCanOpen('ZS3')
		dbSelectArea("ZS3")
		dbSetOrder(2)
	Endif

	For _nx := 1 To Len(_aOderSep)


		If Select("TMPC9") > 0
			TMPC9->( dbCloseArea() )
		EndIf
		cQryTab	:= " SELECT COUNT(*) QTD_REGC9, SUM(C9_QTDLIB) QTD_LIBC9 "
		cQryTab	+= " FROM " + RetSQLName("SC9")
		cQryTab	+= " WHERE D_E_L_E_T_ = ' ' "
		cQryTab	+= " 	AND C9_FILIAL = '" + xFilial("SC9") + "' "
		cQryTab	+= "	AND C9_ORDSEP = '"+_aOderSep[_nx][01]+"' "
		cQryTab	+= "	AND C9_PEDIDO = '"+_aOderSep[_nx][02]+"' "

		dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQryTab),"TMPC9")

		//TCQuery cQryTab New Alias "TMPC9"
		nQRegSC9 := TMPC9->QTD_REGC9
		nQtdISC9 := TMPC9->QTD_LIBC9
		// Filtro a quantidade de registro e separacao da Tabela CB8
		If Select("TMPCB8") > 0
			TMPCB8->( dbCloseArea() )
		EndIf
		cQryTab	:= " SELECT COUNT(*) QTD_REGCB8, SUM(CB8_QTDORI) QTD_LIBCB8 "
		cQryTab	+= " FROM " + RetSQLName("CB8")
		cQryTab	+= " WHERE D_E_L_E_T_ = ' ' "
		cQryTab	+= "	AND CB8_FILIAL = '" + xFilial("CB8") + "' "
		cQryTab	+= "	AND CB8_ORDSEP = '"+_aOderSep[_nx][01]+"' "
		cQryTab	+= "	AND CB8_PEDIDO = '"+_aOderSep[_nx][02]+"' "
		dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQryTab),"TMPCB8")

		//TCQuery cQryTab New Alias "TMPCB8"
		nQRegCB8 := TMPCB8->QTD_REGCB8
		nQtdICB8 := TMPCB8->QTD_LIBCB8
		If nQtdISC9 != nQtdICB8
			lRet := .F.
			Exit
		EndIf

		If lRet

			cAlias := GetNextAlias()

			cQuery := " SELECT * FROM "+RetSqlname("SC9")+" SC9 "
			cQuery += " WHERE C9_ORDSEP =  '"+_aOderSep[_nx][01]+"' "
			cQuery += " AND C9_NFISCAL = ' ' "
			cQuery += " AND D_E_L_E_T_ = ' '"

			If Select(cAlias) > 0
				(cAlias)->(dbCloseArea())
			EndIf

			dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAlias)

			If  Select(cAlias) > 0
				(cAlias)->(dbgotop())

				While !(cAlias)->(Eof())

					DbSelectArea("SC9")
					SC9->(DbSetOrder(1))
					If SC9->(DbSeek(xFilial("SC9")+(cAlias)->C9_PEDIDO+(cAlias)->C9_ITEM+(cAlias)->C9_SEQUEN+(cAlias)->C9_PRODUTO))
						DbSelectArea("SC5")
						SC5->(DbSetOrder(1))
						If SC5->(DbSeek(xFilial("SC5")+SC9->C9_PEDIDO))
							DbSelectArea("SC6")
							SC6->(DbSetOrder(1))
							If SC6->(DbSeek(xFilial("SC6")+SC9->C9_PEDIDO+SC9->C9_ITEM+SC9->C9_PRODUTO))
								DbSelectArea("SE4")
								SE4->(DbSetOrder(1))
								If SE4->(DbSeek(xFilial("SE4")+SC5->C5_CONDPAG))
									DbSelectArea("SB1")
									SB1->(DbSetOrder(1))
									If SB1->(DbSeek(xFilial("SB1")+SC9->C9_PRODUTO))
										DbSelectArea("SB2")
										SB2->(DbSetOrder(1))
										If SB2->(DbSeek(xFilial("SB2")+SC9->C9_PRODUTO+SC9->C9_LOCAL))
											DbSelectArea("SF4")
											SF4->(DbSetOrder(1))
											If SF4->(DbSeek(xFilial("SF4")+SC6->C6_TES))												
												
												dbSelectArea("CBA")
												dbSetOrder(4)
												dbGoTop()
												If dbSeek(xFilial("CBA")+SC9->C9_PRODUTO+"1"+SC9->C9_LOCAL) // Filtra itens do pedido de venda que estejam em inventario rotativo.
													while CBA->(!eof()) .and. SC9->C9_PRODUTO == CBA->CBA_PROD .AND. CBA->CBA_XROTAT = "1" .AND. SC9->C9_LOCAL == CBA->CBA_LOCAL

														if CBA->CBA_STATUS $ "1/2/3/4/6"
															_lInc := .F.
															_cInvent := .F.
															_cPeInve+= Alltrim(SC9->C9_PEDIDO)+'#'
															_cProdInv +=Alltrim(SC9->C9_PRODUTO)+"#CBA#"
															CBA->(dbSkip())
															Exit

														elseif CBA->CBA_STATUS = "5"
															dbSelectArea("SB7")
															SB7->(dbSetOrder(3))
															SB7->(dbGoTop())
															If SB7->(dbSeek(xFilial("SB7")+CBA->CBA_CODINV))

																if SB7->B7_STATUS <> "2"
																	_lInc := .F.
																	_cInvent := .F.
																	_cPeInve+= Alltrim(SC9->C9_PEDIDO)+'#'
																	_cProdInv +=Alltrim(SC9->C9_PRODUTO)+"#SB7#"
																	CBA->(dbSkip())
																	Exit
																endif

															endif

														endif
														CBA->(dbSkip())
													end
												Endif
												//>> Rotina para verificar se o endereço está bloqueado mesmo que os itens do pedido não esteja sendo inventariado - Everson Santana 22.08.2019
												
												If !Alltrim(SC9->C9_PEDIDO) $ _cPeInve

													_cQuery3 := " SELECT * FROM "+RetSqlName("SDC")+" DC"
													_cQuery3 += " WHERE DC_ORIGEM = 'SC6'
													_cQuery3 += " AND DC_QUANT > 0
													_cQuery3 += " AND DC_PEDIDO = '"+Alltrim(SC9->C9_PEDIDO)+"'
													_cQuery3 += " AND D_E_L_E_T_ = ' '

													If !Empty(Select(_cAlias3))
														DbSelectArea(_cAlias3)
														(_cAlias3)->(dbCloseArea())
													Endif

													dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery3),_cAlias3,.T.,.T.)

													dbSelectArea(_cAlias3)
													(_cAlias3)->(dbGoTop())

													If (_cAlias3)->(!Eof())

														dbSelectArea("SBE")
														dbSetOrder(1)
														dbGotop()
														If dbSeek(xFilial("SBE")+(_cAlias3)->DC_LOCAL+(_cAlias3)->DC_LOCALIZ)

															If !Empty(SBE->BE_DTINV)

																_cPeInve+= Alltrim(SC9->C9_PEDIDO)+'#'
																_cProdInv +=Alltrim(SC9->C9_PRODUTO)+"#SBE#"

															Endif

														EndIf

														(_cAlias3)->(dbSkip())

													EndIf

												Endif
												//<<
												If Alltrim(SC9->C9_PEDIDO) $ _cPeInve
													conout("Pedido "+SC9->C9_PEDIDO+" com item sendo inventáriado")
													_lInc := .F.
													SC9->(dbSkip())
													Exit
												Else
			
													Aadd(aPvlNfs,{;
														SC9->C9_PEDIDO,;
														SC9->C9_ITEM,;
														SC9->C9_SEQUEN,;
														SC9->C9_QTDLIB,;
														SC9->C9_PRCVEN,;
														SC9->C9_PRODUTO,;
														.F.,;
														SC9->(RecNo()),;
														SC5->(RecNo()),;
														SC6->(RecNo()),;
														SE4->(RecNo()),;
														SB1->(RecNo()),;
														SB2->(RecNo()),;
														SF4->(RecNo())})
												Endif
											Endif
										Endif
									Endif
								Endif
							Endif
						EndIf
					EndIf
					(cAlias)->(dbSkip())
				End
			EndIf

			If Select(cAlias) > 0
				(cAlias)->(dbCloseArea())
			EndIf
		EndIf
	Next

	If Len(aPvlNfs)>0 .And. _lInc

		SC9->(DbGoTo(aPvlNfs[1][8]))
		If SC9->(!Eof())
			CB7->(DbSetOrder(1)) //CB7_FILIAL+CB7_ORDSEP
			If CB7->(DbSeek(SC9->(C9_FILIAL+C9_ORDSEP)))
				If AllTrim(CB7->CB7_STATUS)=="4"
					_cNota := MaPvlNfs(aPvlNfs, _cSerAm, .F., .F., .F., .T., .F., 0, 0, .T., .F.)
				EndIf
			EndIf
		EndIf
	EndIf

	if !Empty(_cNota)    // Valdemir Rabelo 18/05/2022

		DbSelectArea("SF2")
		SF2->(DbSetOrder(1))
		SF2->(DbGoTop())
		If SF2->(DbSeek(xFilial("SF2")+_cNota+"001"))
			conout("Encontrou a nota: "+_cNota)
			// Valdemir Rabelo - Ticket: 20210329005029
			Conout("Atualizando Status da nota para geração: AUT")
			RecLock("SF2",.F.)
			SF2->F2_XSTATFT := "AUT"
			MsUnlock()

			// Valdemir Rabelo - Ticket: 20210318004396 - Regras para Envio WF
			VldRestr(@aRestr)
			// --------
			// Verifico se foi informado agendamento - Ticket: 20210211002338
			if Select("ZS3") > 0
				For nJ := 1 to Len(aPvlNfs)
					if ZS3->( dbSeek(xFilial("ZS3")+aPvlNfs[nJ, 1]) )
						IF Empty(ZS3->ZS3_NOTAFI)
							RecLock("ZS3", .f. )
							ZS3->ZS3_NOTAFI := _cNota
							MsUnlock()
						Endif
					endif
				Next
			Endif
			// Envio WF caso exista Notas com restrições - Ticket: 20210318004396 - Valdemir Rabelo 13/05/2021
			if Len(aRestr) > 0
				EnvRestr(aRestr)
			Endif
			// ------------------------------------
			_cQuery2 := " MERGE INTO "+RetSqlName("CD2")+" CD2
			_cQuery2 += " USING (
			_cQuery2 += " SELECT CD2.R_E_C_N_O_ RECCD2, CD2_ORIGEM, B1_ORIGEM
			_cQuery2 += " FROM "+RetSqlName("CD2")+" CD2
			_cQuery2 += " LEFT JOIN "+RetSqlName("SB1")+" B1
			_cQuery2 += " ON B1_COD=CD2_CODPRO
			_cQuery2 += " WHERE CD2.D_E_L_E_T_=' ' AND B1.D_E_L_E_T_=' ' AND CD2.CD2_ORIGEM=' '
			_cQuery2 += " AND CD2.CD2_FILIAL='"+SF2->F2_FILIAL+"' AND CD2.CD2_DOC='"+SF2->F2_DOC+"'
			_cQuery2 += " AND CD2.CD2_SERIE='"+SF2->F2_SERIE+"' AND CD2.CD2_CODCLI='"+SF2->F2_CLIENTE+"'
			_cQuery2 += " AND CD2.CD2_LOJCLI='"+SF2->F2_LOJA+"'
			_cQuery2 += " ) XXX
			_cQuery2 += " ON (XXX.RECCD2=CD2.R_E_C_N_O_)
			_cQuery2 += " WHEN MATCHED THEN UPDATE SET
			_cQuery2 += " CD2.CD2_ORIGEM=XXX.B1_ORIGEM
			_cQuery2 += " WHERE CD2.R_E_C_N_O_=XXX.RECCD2

			TCSqlExec( _cQuery2 )
			conout('Transmitindo a nota: '+SF2->F2_DOC)
			//AutoNfeEnv(cEmpAnt,SF2->F2_DOC,"0",AllTrim(GetMv("FS_TPAMBNF",,"2")),SF2->F2_SERIE,SF2->F2_DOC,SF2->F2_DOC)
			U_STAutoNfeEnv(cEmpAnt,SF2->F2_DOC,"0",AllTrim(GetMv("FS_TPAMBNF",,"2")),SF2->F2_SERIE,SF2->F2_DOC,SF2->F2_DOC)

			cDOCSF2  := SF2->F2_DOC
			cSerSF2  := SF2->F2_SERIE
			cCliSF2  := SF2->F2_CLIENTE
			cLojSF2  := SF2->F2_LOJA
			cErrNFE  := ""
			nTenta   := 0
			//While nTenta <= 5
			//	nTenta += 1
			nTempo := GetMv("ST_LIBSEFZ",.F.,20000)
			sleep(nTempo)
			conout('Tempo de 5 segundos para tentar atualizar ')
			aListBox := u_stFaixaNFE(cSerSF2,cDOCSF2,cDOCSF2)
			conout('Atualizou a nota List:'+ cValToChar(Len(aListBox)))
			
			if Len(aListBox) > 0
				if Left(aListBox[1][6], 3)=="001"
					SF2->( dbSeek(xFilial('SF2')+cDOCSF2+cSerSF2+cCliSF2+cLojSF2))
					conout('Encontrou a nota atualizada: '+cDOCSF2)
				elseif Left(aListBox[1][6], 3)!="001" .and. (!Empty(aListBox[1][6]))
					cErrNFE := aListBox[1][6]
					conout('Ocorreu um erro na atualização: '+cErrNFE)
				Endif
				nTenta := 7
			endif
			//EndDo

			_cEmail   := GetMv("ST_CADSZ31",.F.,"jussara.silva@steck.com.br;veronica.brandao@steck.com.br;bruna.cordeiro@steck.com.br;renato.oliveira@steck.com.br")
			_cCopia	  := ""
			_cAssunto := "[WFPROTHEUS] - Transmissão da NFE "+SF2->F2_DOC+" Filial "+SF2->F2_FILIAL
			_aAttach  := {}
			_cCaminho := ""
			_cMsg	  := ""

			U_STMAILTES(_cEmail, _cCopia, _cAssunto, _cMsg,_aAttach,_cCaminho)

			// Valdemir Rabelo 05/10/2021 - Ticket: 20210615010129
			if !Empty(cErrNFE)
				Conout("Envio de WF por não ter chave NFE")
				EnvWFNFE(cErrNFE)
			endif

		else
			Conout("Nota Fiscal: "+_cNota+" não encontrada. Por favor, verifique...")
		EndIf

	else 
	   Conout("Foi detectado alguma inconsistência na geração da nota")
	endif 
	UnLockByName(_cLockBy,.F.,.F.,.T.)
	//Reset Environment

	If Select("SF2")>0
		SF2->(DbCloseArea())
	EndIf
	If Select("SC9")>0
		SF2->(DbCloseArea())
	EndIf
	If Select("SC6")>0
		SF2->(DbCloseArea())
	EndIf
	If Select("SC5")>0
		SF2->(DbCloseArea())
	EndIf
	If Select("SE4")>0
		SF2->(DbCloseArea())
	EndIf
	If Select("SB1")>0
		SF2->(DbCloseArea())
	EndIf
	If Select("SB2")>0
		SF2->(DbCloseArea())
	EndIf
	If Select("SF4")>0
		SF2->(DbCloseArea())
	EndIf
	If Select("CBA")>0
		SF2->(DbCloseArea())
	EndIf
	If Select("SBE")>0
		SF2->(DbCloseArea())
	EndIf

Return()


/*/{Protheus.doc} VldRestr
description
Rotina que valida se existe notas com Guia/PIN/Declaração
@type function
@version  
@author Valdemir Jose
@since 13/05/2021
@param aRestr, array, param_description
@return return_type, return_description
/*/
Static Function VldRestr(aRestr)
	Local aAreaR := GetArea()
	Local aMunEst:= getMunEst()
	Local nMunEst:= aScan(aMunEst, { |X,Y| Upper(alltrim(X)) $ UPPER(ALLTRIM(SA1->A1_MUN)) .AND. Upper(alltrim(Y))== Upper(alltrim(SA1->A1_EST)) })
	Local cMsg   := ""
	Local _cGuia := ""

	dbSelectArea("CB7")
	dbSelectArea("SF2")
	CB7->(DbSetOrder(4))
	If CB7->(DbSeek(xFilial('CB7')+SF2->(F2_DOC+F2_SERIE)))
		If!Empty(DTOC(CB7->CB7_XDFEM))  .AND. !(CB7->CB7_STATUS $ "1/9")

			If !(Empty(Alltrim(SF2->F2_XGUIA)))
				dbselectarea("SE2")
				SE2->(dbSetOrder(1))
				If SE2->(DbSeek(Xfilial("SE2")  +SF2->F2_XPRFGUI+padr(alltrim(SF2->F2_EST+Right( AllTrim( SF2->F2_DOC ) , 5 )),9,' ')+'   '+'TX ESTADO00' ) )			//BUSCA GUIA DE RECOLHIMENTO NO FINANCEIRO
					If SE2->E2_SALDO > 0
						_cGuia:= 'Pendente Recolhimento Financeiro'
					Endif
				Else
					_cGuia:= 'Pendente Recolhimento Financeiro'
				Endif
			Endif
		Endif
	Else
		if (ALLTRIM(SA1->A1_ATIVIDA)=="E3") .AND. (ALLTRIM(SF2->F2_EST) == 'MS') .AND. (SF2->F2_XDECLA=="S")		// Valdemir Rabelo 04/02/2020 - Declaração - Trocado de E5 p/ E3 - Ticket: 20210318004396
			_cGuia:= 'Declaração MS'
		endif
	Endif

	// PIN
	IF (nMunEst > 0)
		cMsg += " PIN"
	Endif

	if !Empty(_cGuia) .or. !Empty(cMsg)
		aAdd(aRestr,{"Nota: "+SF2->F2_DOC+" Serie: "+SF2->F2_SERIE, cMsg+" "+_cGuia})
	Endif

	RestArea( aAreaR )
	DbSelectArea("SF2")
Return

/*/{Protheus.doc} getMunEst
description
Rotina que carrega os Municipios e Estados que precisam de ação diferenciada
@type function
@version  
@author Valdemir Jose
@since 13/05/2021
@return return_type, return_description
/*/
Static Function getMunEst()
	Local aRET := {;
		{'Rio Preto da Eva','AM'},;
		{'Manaus','AM'},;
		{'Presidente Figueiredo','AM'},;
		{'Tabatinga','AM'},;
		{'Boa Vista','RR'},;
		{'Bonfim','RR'},;
		{'Pacaraíma','RR'},;
		{'Macapá','AP'},;
		{'Santana','AP'},;
		{'Cruzeiro do Sul','AC'},;
		{'Brasileia','AC'},;
		{'Epitaciolândia','AC'},;
		{'Guajará-mirim','RO'}}

Return aRET

/*/{Protheus.doc} EnvRestr
description
Rotina que irá disparar WF informando sobre guias da nota
Ticket: 20210318004396
@type function
@version  
@author Valdemir Jose
@since 13/05/2021
@param aEnv, array, param_description
@return return_type, return_description
/*/
Static Function EnvRestr(paEnv)
	Local aArea     := Getarea()
	Local cMsg      := ""
	Local aEnv      := aClone(paEnv)
	Local cCC       := ""
	Local _aMsg     := {}
	Local _cAssunto := ""
	Local cSubject  := "NOTA: "+aEnv[1,1]+" - DECLARAÇÃO/PIN/GUIA"
	Local cEmail    := GetMV("ST_WFAUTFT",.f.,"jussara.silva@steck.com.br,juliete.vieira@steck.com.br,valdemir.rabelo@steck.com.br")
	Local _nLin

	aAdd(_aMsg, {"Data", dtoc(dDatabase)} )
	aAdd(_aMsg, {"Hora", Time() } )

	//A Definicao do cabecalho do email
	cMsg := ""
	cMsg += '<html>'
	cMsg += '<head>'
	cMsg += '<title>' + _cAssunto + " - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title>'
	cMsg += '</head>'
	cMsg += '<body>'
	cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
	cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
	cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>' + _cAssunto +" - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+ '</FONT> </Caption>'

	//A Definicao do texto/detalhe do email
	For _nLin := 1 to Len(aEnv)
		If (_nLin/2) == Int( _nLin/2 )
			cMsg += '<TR BgColor=#B0E2FF>'
		Else
			cMsg += '<TR BgColor=#FFFFFF>'
		EndIf
		cMsg += '<TD><B>' + aEnv[_nLin,1] + ' </Font></B></TD>'
		cMsg += '<TD>' + aEnv[_nLin,2] + ' </Font></TD>'
	Next

	For _nLin := 1 to Len(_aMsg)
		If (_nLin/2) == Int( _nLin/2 )
			cMsg += '<TR BgColor=#B0E2FF>'
		Else
			cMsg += '<TR BgColor=#FFFFFF>'
		EndIf
		if _nLin == Len(_aMsg)
			cMsg += '<TD><B><Font Color=#FF0000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></B></TD>'
		else
			cMsg += '<TD><B>' + _aMsg[_nLin,1] + ' </Font></B></TD>'
		endif
		cMsg += '<TD>' + _aMsg[_nLin,2] + ' </Font></TD>'
	Next

	//A Definicao do rodape do email
	cMsg += '</Table>'
	cMsg += '<P>'
	cMsg += '<Table align="center">'
	cMsg += '<tr>'
	cMsg += '<td colspan="10" align="center"><font color="red" size="3">Mensagem enviada automaticamente pelo sistema PROTHEUS - <font color="red" size="1"></td>'
	cMsg += '</tr>'
	cMsg += '</Table>'
	cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
	cMsg += '</body>'
	cMsg += '</html>'

	cNumNF  := ""

	RestArea( aArea )

	U_STMAILTES(cEmail, cCC, cSubject, cMsg,{},"")

Return


/*/{Protheus.doc} EnvWFNFE
description
Rotina para enviar o WF para pessoa responsável verificar o que
deu errado na transmissão
@type function
@version  
@author Valdemir Jose
@since 05/10/2021
@return variant, return_description
/*/
Static Function EnvWFNFE(cErrNFE)
	Local cBody    := ""
	Local cEmail   := getMV("ST_ERRONFE",.F.,"juliete.vieira@steck.com.br")
	Local cCC      := ""
	Local cSubject := "Problemas na transmissão da nota: "+SF2->F2_DOC+" serie: " + SF2->F2_SERIE

	cBody := '<html><head><title>Problemas de Transmissão</title></head><body>'

	cBody += '<br><br>'
	cBody += 'Ocorreu problemas na transmissão'
	cBody += '<br>'
	cBody += '<br><b>Nota Fiscal:</b>'+SF2->F2_DOC
	cBody += '<br><b>Serie:</b>'+SF2->F2_SERIE
	cBody += '<br><b>Dt Emissão:</b>'+DTOC(SF2->F2_EMISSAO)
	cBody += '<br><b>Notificação: </b>'+cErrNFE

	cBody += '</body></html>'


	U_STMAILTES(cEmail, cCC, cSubject, cBody,{},"")

Return



/*/{Protheus.doc} getAlt
description
Rotina para verificar se ocorreu alteração
@type function
@version  1.00
@author Valdemir Jose
@since 19/04/2021
@param pCampo, param_type, param_description
@param aMuda, array, param_description
@return return_type, return_description
/*/
Static Function getAlt(pCampo, aMuda)
	Local cRET := ""
	if Len(aMuda) > 0
		if aScan(aMuda, { |X| Alltrim(X[1])==Alltrim(pCampo)})
			cRET := "<B>* </B>"
		endif
	Endif
Return cRET
