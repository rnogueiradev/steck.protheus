#include 'Protheus.ch'
#include 'RWMAKE.ch'
#Define CR chr(13)+chr(10)
/*====================================================================================\
|Programa  | STEMBAM3         | Autor | GIOVANI.ZAGO             | Data | 04/05/2015  |
|=====================================================================================|
|Descri็ใo |  STEMBAM3    Gera็ใo de Nota Fiscal do Embarque                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STEMBAM3                                                                 |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Hist๓rico....................................|
\====================================================================================*/
*-----------------------------*
User Function STEMBAM3()
	Local 	_aArea     := GetArea()
	Private _nCust     := 0
	Private _aDados1   := {}
	Private _aDados2   := {}
	Private _cNfRet    := ' '

	If ZZT->ZZT_STATUS <> '2'
		MsgInfo("Embarque Precisa Estar Fechado para Gera a Nf...")
		Return()
	EndIf

	If GetMv("ST_EMBAM3",,.F.) .And. !(PVEMB())

		MsgInfo("Embarque Precisa Estar Fechado para Gera a Nf...")
		Return()
	EndIf

	If MsgYesNo("Deseja Gerar a Nota Fiscal"+CR+"do Embarque: "+ZZT->ZZT_NUMEMB)
		If Empty(Alltrim(ZZT->ZZT_TRANSP))
			MsgInfo("Embarque sem Transportadora......!!!")
			Return()
		Else
			Processa({|| 	CusTransfer(ZZT->ZZT_NUMEMB,ZZT->ZZT_FILDES)},'Aguarde - Analisando Custo para Transfer๊ncia')
			IF (len(_aDados1)>0 .or. len(_aDados2)>0)
				MSGALERT( "Existem Produtos no embarque "+ZZT->ZZT_NUMEMB+" que estใo sem Custo para Transfer๊ncia...!!!"+ Chr(10) + Chr(13) +;
				Chr(10) + Chr(13) +;
				"A Nota Fiscal nใo serแ emitida enquanto esses Produtos nใo tiverem Custo para Transfer๊ncia...!!!"+ Chr(10) + Chr(13) +;
				Chr(10) + Chr(13) +;
				"Favor Verificar ...!!!"+ Chr(10) + Chr(13),;
				"Produtos sem Custo de Transfer๊ncia")
			Else
				Processa({|| 	STNF01(ZZT->ZZT_NUMEMB,ZZT->ZZT_FILDES)},'Aguarde - Gerando Nota Fiscal de Saํda')
			Endif
		EndIf
	EndIf

	RestArea(_aArea)
	// giovani zago valida se existe compromisso para os itens faturados se nao existir inclui automatico 18/03/2016
	If Getmv("ST_LBAM3",,.F.)//DESABILITADO TEMPORARIAMENTE GIOVANI ZAGO 17/06/16
		If cEmpAnt = '03' .And. !(Empty(Alltrim(_cNfRet)))
			U_STEMBZZJ(_cNfRet) 
		EndIf
	EndIf

Return()

Static Function STNF01(_cEmba,_cFilDes)

	Local nX			:= 0 
	Local cModalidade	:= ""
	Private cPerg       := 'STNF01'
	Private cTime       := Time()
	Private cHora       := SUBSTR(cTime, 1, 2)
	Private cMinutos    := SUBSTR(cTime, 4, 2)
	Private cSegundos   := SUBSTR(cTime, 7, 2)
	Private cAliasLif   := cPerg+cHora+ cMinutos+cSegundos
	Private cQuery     	:= ' '
	Private _nx     	:= 0
	Private	_nRecou    	:= 0
	Private aPvlNfs     := {}
	Private _cNota     	:= ' '
	Private _cSerAm     := '001'
	Private	_nVol    	:= 1
	Private _aComp      := {}
	Private _lZzu       := .F.
	Private	cAutoriza   := ""
	Private	cCodAutDPEC := ""
	Private	cCodRetNFE	:= ""

	cQuery := " SELECT
	cQuery += " ZZU.ZZU_PRODUT
	cQuery += ' "PRODUTO",
	cQuery += " SUM(ZZU.ZZU_QTDE)
	cQuery += ' "QUANT"
	cQuery += " FROM "+RetSqlName("ZZU")+" ZZU "
	cQuery += " WHERE ZZU.D_E_L_E_T_ = ' '
	cQuery += " AND ZZU.ZZU_NUMEMB = '"+_cEmba+"' "
	cQuery += " AND ZZU.ZZU_FILIAL = '"+xFilial("ZZU")+"'"
	cQuery += " AND ZZU_VIRTUA <> 'N' " //Chamado 007618
	cQuery += " GROUP BY ZZU.ZZU_PRODUT
	cQuery += " ORDER BY ZZU.ZZU_PRODUT

	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)


	If  Select(cAliasLif) > 0
		(cAliasLif)->(dbgotop())
		_nRecou :=	(cAliasLif)->(RecCount())
		ProcRegua(_nRecou )
		IncProc()
		While !(cAliasLif)->(Eof())
			_nx++
			IncProc(cvaltochar(_nx)+" / "+ cvaltochar(_nRecou))
			//Chamado 002701 - Atualiza็ใo do Pre็o de Venda na tabela SC6 e SC9 de acordo com o ๚ltimo custo
			If cEmpAnt == '01' .And. cFilAnt == '01'
				Begin Transaction
					_nCust := Sb2Saldo((cAliasLif)->PRODUTO)
					If _nCust > 0
						U_STUPDSC6(_cFilDes,(cAliasLif)->PRODUTO,_nCust,ZZT->ZZT_CLIENT)
						U_STUPDSC9(_cFilDes,(cAliasLif)->PRODUTO,_nCust,ZZT->ZZT_CLIENT)
					Endif
				End Transaction
			Endif

			STNF02(_cFilDes,(cAliasLif)->PRODUTO,(cAliasLif)->QUANT)


			(cAliasLif)->(dbSkip())
		End
	EndIf
	If Len(aPvlNfs)>0
		_cNota:=MaPvlNfs(aPvlNfs, _cSerAm, .F., .F., .F., .T., .F., 0, 0, .T., .F.)
	EndIf

	DbSelectArea("SF2")
	SF2->(DbSetOrder(1))
	SF2->(DbGoTop())
	If SF2->(DbSeek(xFilial("SF2")+_cNota+"001"))

		Aviso("Gera็ใo de Nota Fiscal", "Nota Fiscal Gerada com Sucesso n: "+_cNota,{"OK"},2)
		_cNfRet:= _cNota

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
		/* Ticket 20201116010652 - Everson Santana - 18.11.2020 
		AutoNfeEnv(cEmpAnt,SF2->F2_DOC,"0","1",SF2->F2_SERIE,SF2->F2_DOC,SF2->F2_DOC)

		_cEmail   := GetMv("ST_CADSZ31",.F.,"jussara.silva@steck.com.br;veronica.brandao@steck.com.br;bruna.cordeiro@steck.com.br;renato.oliveira@steck.com.br")
		_cCopia	  := "vanessa.silva@steck.com.br"
		_cAssunto := "[WFPROTHEUS] - Transmissใo da NFE "+SF2->F2_DOC+" Filial "+SF2->F2_FILIAL
		_aAttach  := {}
		_cCaminho := ""
		_cMsg	  := ""

		U_STMAILTES(_cEmail, _cCopia, _cAssunto, _cMsg,_aAttach,_cCaminho)
		*/
		If !(Empty(Alltrim(_cNota)))


			cQuery := " SELECT  DISTINCT ZZU_PALLET ,
			cQuery += " NVL((SELECT COUNT(DISTINCT ZZU_VOLUME)
			cQuery += " FROM "+RetSqlName("ZZU")+" SZU "
			cQuery += " WHERE SZU.D_E_L_E_T_ = ' '
			cQuery += " AND SZU.ZZU_NUMEMB = ZZU.ZZU_NUMEMB
			cQuery += " AND SZU.ZZU_PALLET = ZZU.ZZU_PALLET
			cQuery += " AND SZU.ZZU_FILIAL = '"+xFilial("ZZU")+"'"
			cQuery += ' GROUP BY ZZU_PALLET ),0) "VOLU"
			cQuery += " FROM "+RetSqlName("ZZU")+" ZZU "
			cQuery += " WHERE ZZU.D_E_L_E_T_ = ' ' AND ZZU.ZZU_NUMEMB = '"+ZZT->ZZT_NUMEMB+"' AND ZZU.ZZU_FILIAL = '"+xFilial("ZZU")+"'"
			cQuery += " ORDER BY ZZU_PALLET


			If Select(cAliasLif) > 0
				(cAliasLif)->(dbCloseArea())
			EndIf

			dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

			_nVol:=0
			If  Select(cAliasLif) > 0
				(cAliasLif)->(dbgotop())
				While !(cAliasLif)->(Eof())

					_nVol+= (cAliasLif)->VOLU

					(cAliasLif)->(dbSkip())
				End
			EndIf
			SF2->(RecLock("SF2",.F.))
			If SUBSTR(Alltrim(SF2->F2_HORA),1,2) = SUBSTR(Alltrim(time()),1,2)
				SF2->F2_HORA  	 :=  PADL(CVALTOCHAr(VAL(SUBSTR(Alltrim(SF2->F2_HORA),1,2))-2),2,'0')+SUBSTR(Alltrim(SF2->F2_HORA),3,3)
			EndIf
			SF2->F2_ESPECI1	 := 'VOLUME(S)'
			SF2->F2_VOLUME1  := _nVol
			//SF2->F2_PLIQUI   := Iif(nTotLiqu=0, nTotPeso,nTotLiqu)
			//SF2->F2_PBRUTO   := nTotPeso + _nPallet
			//SF2->F2_XCUBAGE	 := nTotCub
			SF2->(MsUnlock())
			SF2->(DbCommit())

			Reclock("ZZT",.F.)
			Replace ZZT_STATUS With "3"
			Replace ZZT_NF With _cNota
			Replace ZZT_SERIEN With "001"
			Replace ZZT_HRFIM With TIME()
			ZZT->(MsUnlock())
			ZZT->(DbCommit())
		EndIf
		_lZzu:=STVALEMB(SF2->F2_DOC,ZZT->ZZT_NUMEMB)
		If len(_aComp) > 0
			MailEmb(_lZzu,_aComp)
		EndIf
		//>>Ticket 20201116010652 - Everson Santana - 18.11.2020
		U_STAutoNfeEnv(cEmpAnt,SF2->F2_DOC,"0",AllTrim(GetMv("FS_TPAMBNF",,"2")),SF2->F2_SERIE,SF2->F2_DOC,SF2->F2_DOC)
		
		Sleep( GetMv("STEMBAM301",,20000) )

		DbSelectArea("SF3")
		SF3->(DbGoTop())
		SF3->(DbSetOrder(4))
		SF3->(DbSeek(SF2->(F2_FILIAL+F2_CLIENTE+F2_LOJA+F2_DOC+F2_SERIE)))
		/* retirei este trecho fora porque a rotina STRONFE jแ faz esta verifica็ใo.
		If SF3->(DbSeek(SF2->(F2_FILIAL+F2_CLIENTE+F2_LOJA+F2_DOC+F2_SERIE)))

			aNotas := {}

			aadd(aNotas,{})
			aadd(Atail(aNotas),.F.)
			aadd(Atail(aNotas),IIF(SF3->F3_CFO<"5","E","S"))
			aadd(Atail(aNotas),SF3->F3_ENTRADA)
			aadd(Atail(aNotas),SF3->F3_SERIE)
			aadd(Atail(aNotas),SF3->F3_NFISCAL)
			aadd(Atail(aNotas),SF3->F3_CLIEFOR)
			aadd(Atail(aNotas),SF3->F3_LOJA)

			If StaticCall (SPEDNFE,IsReady,,,,.F.)
				cIdEnt := ""
				cIdEnt := StaticCall (SPEDNFE,GetIdEnt,.F.)
				If !Empty(cIdEnt)
					aXml := GetXML(cIdEnt,aNotas,@cModalidade)
					nLenNotas := Len(aNotas)
					For nX := 1 To nLenNotas
						If !Empty(aXML[nX][2])
							If !Empty(aXml[nX])
								cAutoriza   	:= aXML[nX][1]
								cCodAutDPEC 	:= aXML[nX][5]
								cCodRetNFE		:= aXML[nX][9]
							Else
								cAutoriza   := ""
								cCodAutDPEC := ""
								cCodRetNFE	:= ""
							EndIf
						EndIf
						If (!Empty(cAutoriza) .Or. !Empty(cCodAutDPEC) .Or. Alltrim(aXML[nX][8]) $ "2,5,7") .And. !cCodRetNFE $ RetCodDene() //NF autorizada
							U_STRONFE(SF2->F2_DOC,.T.)
						EndIf
					Next
				EndIf
			EndIf

		EndIf
		*/

		U_STRONFE(SF2->F2_DOC,.T.)

		If cEmpAnt=="01"
			_cEmail   := GetMv("ST_CADSZ31",.F.,"jussara.silva@steck.com.br;veronica.brandao@steck.com.br;bruna.cordeiro@steck.com.br;luan.oliveira@steck.com.br;ulisses.almeida@steck.com.br;thiago.ribeiro@steck.com.br;paulo.cruz@steck.com.br;alex.lourenco@steck.com.br;rodrigo.ferreira@steck.com.br;giovanni.cursino@steck.com.br")
			_cCopia	  := "vanessa.silva@steck.com.br"
			_cAssunto := "[WFPROTHEUS] - Transmissใo da NFE "+SF2->F2_DOC+" Filial "+SF2->F2_FILIAL
			_aAttach  := {}
			AADD(_aAttach,cEmpAnt+"\"+SF2->F2_DOC+".pdf")
			_cCaminho := "\arquivos\xml_nfe\"
			_cMsg	  := ""

			U_STMAILTES(_cEmail, _cCopia, _cAssunto, _cMsg,_aAttach,_cCaminho)
		EndIf

		//<<
	Else
		msgINfo("ERRO NOTA, CHAMAR O T.I., "+_cNota+" - EMBARQUE: "+ZZT->ZZT_NUMEMB)
	EndIf
	DbCommitAll()


Return (.t.)


Static Function STNF02(_cFilDes,_cProd,_nQuant)
	Local _nRecSC9 		:= 0
	Private cPerg       := 'STNF02'
	Private cAlias2	    := cPerg+cHora+cMinutos+cSegundos

	cQuery:= ' '

	cQuery += " SELECT
	cQuery += ' C6_NUM,C6_ITEM,R_E_C_N_O_ AS "REC" , SC6.C6_QTDVEN , SC6.C6_QTDENT
	cQuery += " FROM "+RetSqlName("SC6")+" SC6 "
	cQuery += " WHERE SC6.D_E_L_E_T_ = ' '
	cQuery += " AND SC6.C6_BLQ     = ' '
	cQuery += " AND SC6.C6_QTDVEN  > SC6.C6_QTDENT
	cQuery += " AND SC6.C6_PRODUTO = '"+_cProd+"'
	cQuery += " AND SC6.C6_CLI     = '"+ZZT->ZZT_CLIENT+"'
	cQuery += " AND SC6.C6_LOJA    = '"+_cFilDes+"'
	cQuery += " AND SC6.C6_FILIAL  = '"+xFilial("SC6")+"'"

	If AllTrim(ZZT->ZZT_CLIENT)=="012047" .And. cEmpAnt=="01" .And. cFilAnt=="05"
		cQuery += " AND SC6.C6_OPER    = '01'
	Else
		cQuery += " AND SC6.C6_OPER    = '"+SuperGetMV("ST_OPEREMB",.F.,"15")+"'"
	EndIf

	cQuery += " AND SC6.C6_LOCAL   = '"+SuperGetMV("ST_LOCESC",,"15")+"' "
	cQuery += " ORDER BY R_E_C_N_O_


	If Select(cAlias2) > 0
		(cAlias2)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAlias2)


	If  Select(cAlias2) > 0
		(cAlias2)->(dbgotop())

		While !(cAlias2)->(Eof())
			DbSelectArea("SC9")
			//SC9->(DbSetOrder(1))
			SC9->(DbOrderNickName("BOBSC9"))
			If !(SC9->(DbSeek(xFilial("SC9")+(cAlias2)->C6_NUM+(cAlias2)->C6_ITEM+"         ")))
				nRecno:=(cAlias2)->REC
				MaLibDoFat(   (cAlias2)->REC,((cAlias2)->C6_QTDVEN    -   (cAlias2)->C6_QTDENT)  ,.T.,.T.,.T.,.T.,.T.,.T.,NIL,NIL,NIL,NIL,NIL,0)
				MaLiberOk({SC6->C6_NUM},.F.)
				MsUnLockall()
				SC6->(DbGoto(nRecno))
			EndIf
			DbSelectArea("SC9")
			SC9->(DbGoTop())
			SC9->(DbSetOrder(1))
			If SC9->(DbSeek(xFilial("SC9")+(cAlias2)->C6_NUM+(cAlias2)->C6_ITEM)) .And. _nQuant > 0
				If    Empty(Alltrim(SC9->C9_NFISCAL))
					_nRecSC9:= SC9->(RecNo())

				Else
					While SC9->(!EOF() .and. C9_FILIAL+C9_PEDIDO+C9_ITEM == xFilial("SC9")+(cAlias2)->C6_NUM+(cAlias2)->C6_ITEM)
						If    Empty(Alltrim(SC9->C9_NFISCAL))
							_nRecSC9:= SC9->(RecNo())
							EXIT
						EndIf
						SC9->(Dbskip())
					EndDo
				EndIf

				If _nRecSC9 = 0
					nRecno:= (cAlias2)->REC
					MaLibDoFat((cAlias2)->REC,((cAlias2)->C6_QTDVEN    -   (cAlias2)->C6_QTDENT)  ,.T.,.T.,.T.,.T.,.T.,.T.,NIL,NIL,NIL,NIL,NIL,0)
					MaLiberOk({SC6->C6_NUM},.F.)
					MsUnLockall()
					SC6->(DbGoto(nRecno))
					_nRecSC9:= SC9->(RecNo())
				EndIf



				SC9->(DbGoTo(_nRecSC9))

				If SC9->C9_PRODUTO = _cProd .and. SC9->C9_QTDLIB > _nQuant

					DbSelectArea("SC6")
					SC6->(DbSetOrder(1))
					If SC6->(DbSeek(xFilial("SC9")+SC9->C9_PEDIDO+SC9->C9_ITEM+SC9->C9_PRODUTO))
						_nSald:= SC9->C9_QTDLIB - _nQuant

						a460Estorna() // Estorna o item liberado
						nRecno:= SC6->(RecNo())
						MaLibDoFat(SC6->(RecNo()),(_nQuant),.T.,.T.,.T.,.T.,.T.,.T.,NIL,NIL,NIL,NIL,NIL,0)
						MaLiberOk({SC6->C6_NUM},.F.)
						MsUnLockall()
						SC6->(DbGoto(nRecno))
						SC9->(RecLock("SC9",.F.))
						SC9->C9_BLEST  := ' '
						SC9->C9_BLCRED := ' '
						SC9->C9_LOCAL  := '15'
						SC9->C9_NUMEMB := ZZT->ZZT_NUMEMB
						SC9->(MsUnlock())
						SC9->(DbCommit())
						_nRecSC9:= SC9->(RecNo())
						// Ticket 20210719013074 - EMBARQUE 003851 - Eduardo Pereira Sigamat - 21.07.2021 - Inicio
						//nRecno:= SC6->(RecNo())
						//MaLibDoFat(SC6->(RecNo()),(_nSald),.T.,.T.,.T.,.T.,.T.,.T.,NIL,NIL,NIL,NIL,NIL,0)
						//MaLiberOk({SC6->C6_NUM},.F.)
						//MsUnLockall()
						//SC6->(DbGoto(nRecno))
						// Ticket 20210719013074 - EMBARQUE 003851 - Eduardo Pereira Sigamat - 21.07.2021 - Fim
					Else
						msgINfo("ERRO CHAMAR O T.I., "+SC6->C6_NUM+" - "+SC6->C6_ITEM)
						Return(.F.)
					EndIf
				Else
					SC9->(RecLock("SC9",.F.))
					SC9->C9_BLEST  := ' '
					SC9->C9_BLCRED := ' '
					SC9->C9_LOCAL  := '15'
					SC9->C9_NUMEMB := ZZT->ZZT_NUMEMB
					SC9->(MsUnlock())
					SC9->(DbCommit())
					_nRecSC9:= SC9->(RecNo())
				EndIf


				DbSelectArea("SC9")
				SC9->(DbSetOrder(1))
				SC9->(DbGoTop())
				SC9->(DbGoTo(_nRecSC9))
				SC9->(RecLock("SC9",.F.))
				SC9->C9_BLEST  := ' '
				SC9->C9_BLCRED := ' '
				SC9->C9_LOCAL  := '15'
				SC9->C9_NUMEMB := ZZT->ZZT_NUMEMB
				SC9->(MsUnlock())
				SC9->(DbCommit())
				If _nRecSC9 > 0 .And. _nRecSC9 == SC9->(RecNo())
					_nRecSC9:= 0
					DbSelectArea("SC5")
					SC5->(DbSetOrder(1))
					If SC5->(DbSeek(xFilial("SC5")+SC9->C9_PEDIDO))
						SC5->(RecLock("SC5",.F.))
						SC5->C5_TRANSP  := ZZT->ZZT_TRANSP
						SC5->C5_TPFRETE := 'C'
						SC5->C5_CONDPAG := '502'
						SC5->C5_ZOBS    := ZZT->ZZT_OBSNF
						SC9->(MsUnlock())
						SC9->(DbCommit())
						DbSelectArea("SC6")
						SC6->(DbSetOrder(1))
						If SC6->(DbSeek(xFilial("SC9")+SC9->C9_PEDIDO+SC9->C9_ITEM+SC9->C9_PRODUTO))
							DbSelectArea("SE4")
							SE4->(DbSetOrder(1))
							If SE4->(DbSeek(xFilial("SE4")+SC5->C5_CONDPAG))
								DbSelectArea("SB1")
								SB1->(DbSetOrder(1))
								If		SB1->(DbSeek(xFilial("SB1")+SC9->C9_PRODUTO))
									DbSelectArea("SB2")
									SB2->(DbSetOrder(1))
									If		SB2->(DbSeek(xFilial("SB2")+SC9->C9_PRODUTO+SC9->C9_LOCAL))
										DbSelectArea("SF4")
										SF4->(DbSetOrder(1))
										If		SF4->(DbSeek(xFilial("SF4")+SC6->C6_TES))
											_nQuant-=SC9->C9_QTDLIB
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
				Endif

			Endif
			(cAlias2)->(dbSkip())
		End
	EndIf


Return()


Static  Function STVALEMB(_cNf,_cEmb)
	Local _lRet 		:= .T.
	Local	cQuery		:= ' '
	Local _cModal		:= ""
	Private cPerg       := 'STVALEMB'
	Private cTime       := Time()
	Private cHora       := SUBSTR(cTime, 1, 2)
	Private cMinutos    := SUBSTR(cTime, 4, 2)
	Private cSegundos   := SUBSTR(cTime, 7, 2)
	Private _cAlias     := cPerg+cHora+ cMinutos+cSegundos

	// Ticket 20210902017805 - Ajuste NF c/ erro -- Eduardo Pereira Sigamat - 02.09.2021 - Incluso AND SD2.D2_FILIAL = '"+xFilial("SD2")+"' na linha 506
	cQuery := " SELECT
	cQuery += ' ZZU_PRODUT "PRODUTO",
	cQuery += ' SUM(ZZU_QTDE) "QUANT",
	cQuery += " (SELECT SUM(D2_QUANT)  FROM "+RetSqlName("SD2")+" SD2 WHERE D2_DOC = '"+_cNf+"'
	cQuery += " AND SD2.D2_FILIAL = '"+xFilial("SD2")+"' AND SD2.D_E_L_E_T_ = ' ' AND D2_COD =ZZU_PRODUT )
	cQuery += ' 	"NF"
	cQuery += " FROM "+RetSqlName("ZZU")+" ZZU "
	cQuery += " WHERE ZZU_NUMEMB = '"+_cEmb+"' AND ZZU_FILIAL = '"+xFilial("ZZU")+"'"
	cQuery += " AND ZZU.D_E_L_E_T_ = ' '
	cQuery += " AND ZZU_VIRTUA <> 'N' " //Chamado 007618
	cQuery += " GROUP BY ZZU_PRODUT

	If Select(_cAlias) > 0
		(_cAlias)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),_cAlias)


	If  Select(_cAlias) > 0
		(_cAlias)->(dbgotop())
		//>> Ticket 20191213000012 - Everson Santana - 17.12.2019
		If Posicione("ZZT",1,xFilial("ZZT")+_cEmb,"ZZT_MODAL") $ "a#A"
			_cModal := "AEREO"
		Else
			_cModal := "RODOVIARIO"
		EndIf
		//<<
		Aadd(_aComp,{ 'NF:' , _cNf , 'Embarque' , _cEmb,'Modal',_cModal })
		Aadd(_aComp,{ ' ' , ' ' , ' ' , ' ',' ',' ' })
		Aadd(_aComp,{ 'PRODUTO' , 'QTD.EMB' , 'QTD.NF' , 'STATUS',' ',' ' })
		While !(_cAlias)->(Eof())

			If (_cAlias)->QUANT <> (_cAlias)->NF .And. _lRet
				_lRet:= .F.
			EndIf
			Aadd(_aComp,{ (_cAlias)->PRODUTO , (_cAlias)->QUANT , (_cAlias)->NF ,Iif((_cAlias)->QUANT <> (_cAlias)->NF,"ERRADO","OK"),' ',' ' })


			(_cAlias)->(dbSkip())
		End
	EndIf

	If Select(_cAlias) > 0
		(_cAlias)->(dbCloseArea())
	EndIf
Return(_lRet)

	/*====================================================================================\
	|Programa  | MailEmb          | Autor | GIOVANI.ZAGO             | Data | 14/07/2015  |
	|=====================================================================================|
	|Descri็ใo | MailEmb                                                                  |
	|          |                                                                          |
	|          |                                                                          |
	|=====================================================================================|
	|Sintaxe   | MailEmb                                                                  |
	|=====================================================================================|
	|Uso       | Especifico STECK                                                         |
	|=====================================================================================|
	|........................................Hist๓rico....................................|
	\====================================================================================*/
	*------------------------------------------------------------------*
Static Function  MailEmb(_lCh,_aMsg)
	*------------------------------------------------------------------*

	Local aArea 	:= GetArea()
	Local _cFrom   := "protheus@steck.com.br"
	Local _cAssunto:= 'Faturamento - NF emitida pelo Embarque('+ IIF(_lCh,"OK)","ERRADO)")+' - Empresa: '+ cEmpAnt+' - Filial: '+ cFilAnt
	Local cFuncSent:= "MailEmb"
	Local i        := 0
	Local cArq     := ""
	Local cMsg     := ""
	Local _nLin
	Local _cCopia  :=   ""
	Local _cEmail  := SuperGetMV("ST_MAILEMB",.F.,"everson.santana@STECK.COM.BR")
	Local cAttach  := ''

	If cEmpAnt=="03"
		_cEmail	:=	_cEmail+";sadoque.manoel@steck.com.br;andre.bugatti@steck.com.br;tiago.brandao@steck.com.br ;tamires.eufrazio@steck.com.br;jefferson.puglia@steck.com.br; Leandro.Nobre@steck.com.br;Kleber.Braga@steck.com.br;Guilherme.Fernandez@steck.com.br;vanessa.silva@steck.com.br"
	EndIf

	If cEmpAnt=="01"
		_cEmail := AllTrim(_cEmail)+";"+AllTrim(SuperGetMV("ST_FAT0001",.F.,""))
	EndIf

	If ( Type("l410Auto") == "U" .OR. !l410Auto )


		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Definicao do cabecalho do email                                             ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		cMsg := ""
		cMsg += '<html>'
		cMsg += '<head>'
		cMsg += '<title>' + _cAssunto + " - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title>'
		cMsg += '</head>'
		cMsg += '<body>'
		//cMsg += '<Img Src="C:/AP5/SIGAADV/LGRL01.BMP"><BR>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
		cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>' + _cAssunto +" - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+ '</FONT> </Caption>'
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Definicao do texto/detalhe do email                                         ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		For _nLin := 1 to Len(_aMsg)
			IF (_nLin/2) == Int( _nLin/2 )
				cMsg += '<TR BgColor=#B0E2FF>'
			Else
				cMsg += '<TR BgColor=#FFFFFF>'
			EndIF
			cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></B></TD>'
			cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + cvaltochar(_aMsg[_nLin,2]) + ' </Font></TD>'
			cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + cvaltochar(_aMsg[_nLin,3]) + ' </Font></TD>'
			cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,4] + ' </Font></TD>'
			cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,5] + ' </Font></TD>'
			cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,6] + ' </Font></TD>'
			cMsg += '</TR>'
		Next
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Definicao do rodape do email                                                ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		cMsg += '</Table>'
		cMsg += '<P>'
		cMsg += '<Table align="center">'
		cMsg += '<tr>'
		cMsg += '<td colspan="10" align="center"><font color="red" size="3">E-mail gerado em: '+ Dtoc(date())+'-'+ Time()+'  - <font color="red" size="1">('+cFuncSent+')</td>'
		cMsg += '</tr>'
		cMsg += '</Table>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		//cMsg += '<B><Font Color=#000000 Size="2" Face="Arial"> Atenciosamente </Font></B><BR>'
		//cMsg += '<B><Font Color=#000000 Size="2" Face="Arial">' + SM0->M0_NOMECOM + '</Font></B><BR>'
		//cMsg += '<Img Src="C:/AP5/SIGAADV/LGRL01.BMP">'
		cMsg += '</body>'
		cMsg += '</html>'


		If !(   U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,cAttach) )
			MsgInfo("Email nใo Enviado..!!!!")
		EndIf
	EndIf
	RestArea(aArea)
Return()




User Function KILLSC915( )

	Local _lRet 		:= .T.
	Local	cQuery		:= ' '
	Private cPerg       := 'KILLSC915'
	Private cTime       := Time()
	Private cHora       := SUBSTR(cTime, 1, 2)
	Private cMinutos    := SUBSTR(cTime, 4, 2)
	Private cSegundos   := SUBSTR(cTime, 7, 2)
	Private _cAlias     := cPerg+cHora+ cMinutos+cSegundos

	If cEmpAnt <> '03'
		Return()
	EndIf
	cQuery := "   SELECT SC6.R_E_C_N_O_
	cQuery += ' 	AS "REC" ,SC9.R_E_C_N_O_  AS "C9REC"
	cQuery += "  	FROM "+RetSqlName("SC6")+" SC6 "
	cQuery += "  inner join(SELECT * FROM "+RetSqlName("SC9")+") SC9
	cQuery += "  on SC9.D_E_L_E_T_ = ' '
	cQuery += "  AND C9_PEDIDO = C6_NUM
	cQuery += "  AND SC9.C9_ITEM = SC6.C6_ITEM
	cQuery += "  AND C9_PRODUTO = C6_PRODUTO
	cQuery += "  AND C9_NFISCAL = ' '
	cQuery += "  WHERE SC6.D_E_L_E_T_ = ' '
	//cQuery += "  AND SC6.C6_QTDVEN > SC6.C6_QTDENT
	cQuery += "  AND SC6.C6_BLQ <> 'R'
	cQuery += "  AND SC6.C6_OPER = '"+SuperGetMV("ST_OPEREMB",.F.,"15")+"'"


	If Select(_cAlias) > 0
		(_cAlias)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),_cAlias)


	If  Select(_cAlias) > 0
		(_cAlias)->(dbgotop())


		While !(_cAlias)->(Eof())


			DbSelectArea("SC6")
			SC6->(DbSetOrder(1))
			SC6->(DbGoTo((_cAlias)->REC))
			DbSelectArea("SC9")
			SC9->(DbSetOrder(1))
			SC9->(DbGoTop())
			SC9->(DbGoTo((_cAlias)->C9REC))


			If SC6->(RECNO()) = (_cAlias)->REC .And. SC9->(RECNO()) = (_cAlias)->C9REC

				a460Estorna() // Estorna o item liberado

			EndIf

			(_cAlias)->(dbSkip())
		End
	EndIf

	If Select(_cAlias) > 0
		(_cAlias)->(dbCloseArea())
	EndIf
	DbCommitAll()
	MsUnLockall()
Return()


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTUPDSC6   บAutor  ณJoao Rinaldi       บ Data ณ  09/10/2015 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Update para atualizar os valores do pedido de venda antes  บฑฑ
ฑฑบ          ณ de realizar o faturamento da Nota Fiscal de Saํda          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Steck Industria Eletrica Ltda.                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑบRotina    ณ STEMBAM3.prw                                               บฑฑ
ฑฑบNome      ณ Gera็ใo de Nota Fiscal de Saํda                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function STUPDSC6(_cFilDes,_cProd,_nCust,_cClient)

	Local _cQueryC6 := ""
	Local nErrC6    := 0

	_cQueryC6 := " UPDATE "+RetSqlName("SC6")+" SC6 "
	_cQueryC6 += " SET SC6.C6_PRCVEN = "+(StrTran(Cvaltochar(_nCust),",","."))"
	_cQueryC6 += " ,SC6.C6_PRUNIT    = "+(StrTran(Cvaltochar(_nCust),",","."))"
	_cQueryC6 += " ,SC6.C6_VALOR     = C6_QTDVEN*"+(StrTran(Cvaltochar(_nCust),",","."))"

	_cQueryC6 += " WHERE SC6.D_E_L_E_T_ = ' '
	_cQueryC6 += " AND SC6.C6_BLQ     = ' '
	_cQueryC6 += " AND SC6.C6_QTDVEN  > SC6.C6_QTDENT
	_cQueryC6 += " AND SC6.C6_PRODUTO = '"+_cProd+"'
	_cQueryC6 += " AND SC6.C6_CLI     = '"+_cClient+"'
	_cQueryC6 += " AND SC6.C6_LOJA    = '"+_cFilDes+"'
	_cQueryC6 += " AND SC6.C6_FILIAL  = '"+xFilial("SC6")+"'"
	_cQueryC6 += " AND SC6.C6_OPER    = '"+SuperGetMV("ST_OPEREMB",.F.,"15")+"'"
	_cQueryC6 += " AND SC6.C6_LOCAL   = '"+SuperGetMV("ST_LOCESC",,"15")+"'"

	nErrC6 := TCSqlExec( _cQueryC6 )

	If nErrC6 <> 0
		Return MsgStop("TCSQLError() " + TCSQLError())
	EndIf

Return()


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTUPDSC9   บAutor  ณJoao Rinaldi       บ Data ณ  09/10/2015 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Update para atualizar os valores da tabela SC9 antes       บฑฑ
ฑฑบ          ณ de realizar o faturamento da Nota Fiscal de Saํda          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Steck Industria Eletrica Ltda.                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑบRotina    ณ STEMBAM3.prw                                               บฑฑ
ฑฑบNome      ณ Gera็ใo de Nota Fiscal de Saํda                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function STUPDSC9(_cFilDes,_cProd,_nCust,_cClient)

	Local _cQueryC9 := ""
	Local nErrC9    := 0

	_cQueryC9 := " UPDATE "+RetSqlName("SC9")+" SC9 "
	_cQueryC9 += " SET SC9.C9_PRCVEN = "+(StrTran(Cvaltochar(_nCust),",","."))"

	_cQueryC9 += " WHERE SC9.D_E_L_E_T_ = ' '
	_cQueryC9 += " AND SC9.C9_FILIAL  = '"+xFilial("SC9")+"'"
	_cQueryC9 += " AND SC9.C9_PRODUTO = '"+_cProd+"'
	_cQueryC9 += " AND SC9.C9_CLIENTE = '"+_cClient+"'
	_cQueryC9 += " AND SC9.C9_LOJA    = '"+_cFilDes+"'
	_cQueryC9 += " AND SC9.C9_NFISCAL = ' '

	_cQueryC9 += " AND SC9.C9_PRODUTO =
	_cQueryC9 += " (SELECT C6_PRODUTO FROM "+RetSqlName("SC6")+" SC6 "
	_cQueryC9 += " WHERE SC6.D_E_L_E_T_ = ' '
	_cQueryC9 += " AND SC6.C6_BLQ     = ' '
	_cQueryC9 += " AND SC6.C6_QTDVEN  > SC6.C6_QTDENT
	_cQueryC9 += " AND SC6.C6_PRODUTO = '"+_cProd+"'
	_cQueryC9 += " AND SC6.C6_CLI     = '"+_cClient+"'
	_cQueryC9 += " AND SC6.C6_LOJA    = '"+_cFilDes+"'
	_cQueryC9 += " AND SC6.C6_FILIAL  = '"+xFilial("SC6")+"'"
	_cQueryC9 += " AND SC6.C6_OPER    = '"+SuperGetMV("ST_OPEREMB",.F.,"15")+"'"
	_cQueryC9 += " AND SC6.C6_LOCAL   = '"+SuperGetMV("ST_LOCESC",,"15")+"'"
	_cQueryC9 += " AND SC6.C6_FILIAL  = '"+xFilial("SC9")+"'"
	_cQueryC9 += " AND SC6.C6_NUM     = SC9.C9_PEDIDO
	_cQueryC9 += " AND SC6.C6_PRODUTO = SC9.C9_PRODUTO
	_cQueryC9 += " AND SC9.D_E_L_E_T_ = ' '
	_cQueryC9 += " )

	nErrC9 := TCSqlExec( _cQueryC9 )

	If nErrC9 <> 0
		Return MsgStop("TCSQLError() " + TCSQLError())
	EndIf

Return()


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSb2Saldo   บAutor  ณJoao Rinaldi       บ Data ณ  09/10/2015 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo para retornar o custo do produto. A fun็ใo Sb2Saldo บฑฑ
ฑฑบ          ณ ้ utilizada no programa STFATG02.prw                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Steck Industria Eletrica Ltda.                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑบRotina    ณ STEMBAM3.prw                                               บฑฑ
ฑฑบNome      ณ Gera็ใo de Nota Fiscal de Saํda                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Sb2Saldo(_cCod)

	Local _aArea     := GetArea()
	Local cAliasLif  := 'TMPB2'
	Local cQuery     := ' '
	Local  _nQut     := 0
	Local  _nVal     := 0
	Local  _nCust    := 0

	DbSelectArea("SB1")
	SB1->(DbSetOrder(1))
	SB1->(DbSeek(xFilial("SB1")+_cCod))




	cQuery := " SELECT B2_COD, B2_LOCAL,B2_FILIAL,B2_QATU,B2_VATU1 ,B2_CMFIM1
	cQuery += " FROM "+RetSqlName("SB2")+" SB2 "
	cQuery += " WHERE SB2.D_E_L_E_T_ = ' '
	cQuery += " AND   SB2.B2_COD   = '"+SB1->B1_COD+"'"
	cQuery += " AND   SB2.B2_LOCAL = '"+SB1->B1_LOCPAD+"'"
	cQuery += " AND   SB2.B2_FILIAL= '"+xFilial("SB2")+"'"
	cQuery += " ORDER BY SB2.R_E_C_N_O_



	cQuery := ChangeQuery(cQuery)

	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)
	dbSelectArea(cAliasLif)
	If  Select(cAliasLif) > 0
		(cAliasLif)->(dbgotop())
		While (cAliasLif)->(!Eof())

			_nQut 	:= (cAliasLif)->B2_QATU
			_nVal	:= (cAliasLif)->B2_VATU1
			_nCust  := (cAliasLif)->B2_CMFIM1

			(cAliasLif)->(DbSkip())
		End
	EndIf


	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	If  !(_nCust > 0).and. SB1->B1_CLAPROD <> 'F'

		cQuery := " SELECT D1_VUNIT
		cQuery += ' "SALDO"
		cQuery += " FROM "+RetSqlName("SD1")+" SD1 "
		cQuery += " WHERE  SD1.D_E_L_E_T_ = ' '
		cQuery += " AND SD1.D1_FILIAL = '"+xFilial("SD1")+"'"
		cQuery += " AND SD1.D1_COD = '"+SB1->B1_COD+"'"
		cQuery += " AND SD1.D1_FORNECE <> '005764'
		cQuery += " AND SD1.D1_TIPO = 'N'
		cQuery += " ORDER BY   SD1.R_E_C_N_O_ DESC


		cQuery := ChangeQuery(cQuery)

		If Select(cAliasLif) > 0
			(cAliasLif)->(dbCloseArea())
		EndIf

		dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)
		dbSelectArea(cAliasLif)
		If  Select(cAliasLif) > 0
			(cAliasLif)->(dbgotop())
			_nCust  := (cAliasLif)->SALDO
		EndIf



		If Select(cAliasLif) > 0
			(cAliasLif)->(dbCloseArea())
		EndIf

	EndIf

	If  !(_nCust > 0).and. SB1->B1_CLAPROD $ 'F#C' //Renato Nogueira - 25/11/2013 - Chamado 000019

		cQuery := " SELECT C2_APRATU1/C2_QUJE SALDO "
		cQuery += " FROM "+RetSqlName("SC2")+" C2 "
		cQuery += " WHERE D_E_L_E_T_=' ' AND R_E_C_N_O_ = ( "
		cQuery += " SELECT MAX(R_E_C_N_O_) "
		cQuery += " FROM "+RetSqlName("SC2")+" C2 "
		cQuery += " WHERE C2.D_E_L_E_T_=' ' AND C2_PRODUTO= '"+SB1->B1_COD+"' AND C2_APRATU1>0 AND C2_QUJE>0 "
		cQuery += " GROUP BY C2_PRODUTO)

		cQuery := ChangeQuery(cQuery)

		If Select(cAliasLif) > 0
			(cAliasLif)->(dbCloseArea())
		EndIf

		dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)
		dbSelectArea(cAliasLif)
		If  Select(cAliasLif) > 0
			(cAliasLif)->(dbgotop())
			_nCust  := (cAliasLif)->SALDO
		EndIf

		If Select(cAliasLif) > 0
			(cAliasLif)->(dbCloseArea())
		EndIf

	EndIf
	/*
	If !(_nCust > 0) //!(_nVal/_nQut > 0)  alterado por giovani zago solicita็ใo rogerio martelo 10/06/13
	MsgInfo('Produto nใo Possui Valor na Tabela de Custo, Contactar o Departamento de T.I. ou Departamento de Custo !!!!!!!!!!!')
	EndIf
	*/
	RestArea(_aArea)
Return(round(_nCust,2))



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCusTransferบAutor  ณJoao Rinaldi       บ Data ณ  09/10/2015 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo para retornar se os produtos de um determinado      บฑฑ
ฑฑบ          ณ embarque possui Custo de Transfer๊ncia                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Steck Industria Eletrica Ltda.                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑบRotina    ณ STEMBAM3.prw                                               บฑฑ
ฑฑบNome      ณ Gera็ใo de Nota Fiscal de Saํda                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function CusTransfer(_cEmbarque,_cDestino)

	Local cQueryEmb := ""
	Local _lRet     := .T.
	Local _nCusto   := 0

	Local aButtons  := {}
	Local _cTitulo  := "Rela็ใo de Produtos no Embarque sem Custo Cadastrado"
	Local aSize     := MsAdvSize(, .F., 400)
	Local aInfo     := {aSize[1],aSize[2],aSize[3],aSize[4]-12, 1, 1 }
	Local aObjects  := {{100, 100,.T.,.T. }}
	Local aPosObj   := MsObjSize( aInfo, aObjects,.T. )
	Local nStyle    := GD_INSERT+GD_DELETE+GD_UPDATE
	Local _cGrp1    := "039,041,042,047,100,110,999"
	Local _cGrp2    := "000 Somente os c๓digos com Final 'BM' e 'BM1' "

	Private cAliasEmb   := GetNextAlias()
	Private oGetDados1
	Private oGetDados2
	Private _aHeader := {}

	oFont13 := TFont():New("Arial",9,24,.T.,.F.,5,.T.,5,.T.,.F.)

	If cEmpAnt == '01'
		cQueryEmb := " SELECT
		cQueryEmb += " ZZU.ZZU_PRODUT    AS A1_PRODUTO
		cQueryEmb += ",SB1.B1_DESC       AS A2_DESCRICAO
		cQueryEmb += ",SB1.B1_TIPO       AS A3_TIPO
		cQueryEmb += ",SB1.B1_GRUPO      AS A4_GRUPO
		cQueryEmb += ",SBM.BM_DESC       AS A5_DESCGRP
		cQueryEmb += ",SUM(ZZU.ZZU_QTDE) AS A6_QUANT

		cQueryEmb += " FROM "+RetSqlName("ZZU")+" ZZU "

		cQueryEmb += " INNER JOIN "+RetSqlName("SB1")+" SB1 "
		cQueryEmb += " ON  SB1.D_E_L_E_T_ = ' '
		cQueryEmb += " AND B1_COD = ZZU_PRODUT

		cQueryEmb += " LEFT JOIN "+RetSqlName("SBM")+" SBM "
		cQueryEmb += " ON  SBM.D_E_L_E_T_ = ' '
		cQueryEmb += " AND B1_GRUPO = BM_GRUPO

		cQueryEmb += " WHERE ZZU.D_E_L_E_T_ = ' '
		cQueryEmb += " AND ZZU.ZZU_NUMEMB = '"+_cEmbarque+"' "
		cQueryEmb += " AND ZZU.ZZU_FILIAL = '"+xFilial("ZZU")+"'"
		cQueryEmb += " AND ZZU_VIRTUA <> 'N' " //Chamado 007618
		cQueryEmb += " GROUP BY ZZU.ZZU_PRODUT, B1_DESC,B1_TIPO,B1_GRUPO,BM_DESC
		cQueryEmb += " ORDER BY ZZU.ZZU_PRODUT

		If Select(cAliasEmb) > 0
			(cAliasEmb)->(dbCloseArea())
		EndIf

		dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQueryEmb),cAliasEmb)

		DbSelectArea(cAliasEmb)
		(cAliasEmb)->(DbGoTop())
		If  Select(cAliasEmb) > 0
			While 	(cAliasEmb)->(!Eof())
				_lRet   := U_STUNICOM((cAliasEmb)->A1_PRODUTO)
				_nCusto := Sb2Saldo((cAliasEmb)->A1_PRODUTO)
				If !(_nCusto > 0)
					If _lRet
						Aadd(_aDados1,{	xFilial("ZZU"),;
							((cAliasEmb)->A1_PRODUTO),;
							((cAliasEmb)->A2_DESCRICAO),;
							((cAliasEmb)->A3_TIPO),;
							((cAliasEmb)->A4_GRUPO),;
							((cAliasEmb)->A5_DESCGRP),;
							((cAliasEmb)->A6_QUANT),;
							_nCusto,;
							.F.})
					Else
						Aadd(_aDados2,{	xFilial("ZZU"),;
							((cAliasEmb)->A1_PRODUTO),;
							((cAliasEmb)->A2_DESCRICAO),;
							((cAliasEmb)->A3_TIPO),;
							((cAliasEmb)->A4_GRUPO),;
							((cAliasEmb)->A5_DESCGRP),;
							((cAliasEmb)->A6_QUANT),;
							_nCusto,;
							.F.})
					Endif
				Endif
				(cAliasEmb)->(dbskip())
			End
			(cAliasEmb)->(dbCloseArea())
		Endif

		IF (len(_aDados1)>0 .or. len(_aDados2)>0)
			STaHeader()
			Define MSDialog oDlgCons Title _cTitulo From aSize[7],000 To aSize[6],aSize[5] of GetWndDefault() Pixel

			@ aPosObj[1,1]+2,aPosObj[1,2]+5 say "Produtos de Linha:"  Of oDlgCons Pixel COLOR CLR_HBLUE FONT oFont13
			oGetDados1 := MsNewGetDados():New( aPosObj[1,1]+20      , aPosObj[1,2]+5                , aPosObj[1,3]/2     , aPosObj[1,4] ,              ,"AllWaysTrue","AllWaysTrue",""        ,             ,/*freeze*/,999,/*fieldok*/,/*superdel*/,/*delok*/,oDlgCons,_aHeader,_aDados2)

			@ aPosObj[1,3]/2+5,aPosObj[1,2]+5 say "Produtos Unicom -> Grupos: "+_cGrp1 +" e "+_cGrp2  Of oDlgCons Pixel COLOR CLR_HBLUE FONT oFont13
			oGetDados2 := MsNewGetDados():New( aPosObj[1,3]/2+20    , aPosObj[1,2]+5                , aPosObj[1,3]       , aPosObj[1,4] ,              ,"AllWaysTrue","AllWaysTrue",""        ,             ,/*freeze*/,999,/*fieldok*/,/*superdel*/,/*delok*/,oDlgCons,_aHeader,_aDados1)

			ACTIVATE MSDIALOG oDlgCons ON INIT EnchoiceBar(oDlgCons,{|| nOpca := 1,oDlgCons:End() },{||oDlgCons:End()},,aButtons)
		Endif
	Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTaHeader  บAutor  ณJoao Rinaldi       บ Data ณ  23/10/2015 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo para retornar o aHeader                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Steck Industria Eletrica Ltda.                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑบRotina    ณ STEMBAM3.prw                                               บฑฑ
ฑฑบNome      ณ Gera็ใo de Nota Fiscal de Saํda                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function STaHeader()

	aAdd(_aHeader,{"Filial"          ,"XX_ITEM"     ,PesqPict("ZZU","ZZU_FILIAL") ,TamSx3("ZZU_FILIAL")[1],0,"","€€€€€€€€€€€€€€€","C","","","","",".T."})
	aAdd(_aHeader,{"C๓digo"          ,"XX_COD"      ,PesqPict("SB1","B1_COD")     ,TamSx3("B1_COD")[1]    ,0,"","€€€€€€€€€€€€€€€","C","","","","",".T."})
	aAdd(_aHeader,{"Descri็ใo"       ,"XX_COD"      ,PesqPict("SB1","B1_DESC")    ,TamSx3("B1_DESC")[1]   ,0,"","€€€€€€€€€€€€€€€","C","","","","",".T."})
	aAdd(_aHeader,{"Tipo"            ,"XX_TIPO"     ,PesqPict("SB1","B1_TIPO")    ,TamSx3("B1_TIPO")[1]   ,0,"","€€€€€€€€€€€€€€€","C","","","","",".T."})
	aAdd(_aHeader,{"Grupo"           ,"XX_GRUPO"    ,PesqPict("SB1","B1_GRUPO")   ,TamSx3("B1_GRUPO")[1]  ,0,"","€€€€€€€€€€€€€€€","C","","","","",".T."})
	aAdd(_aHeader,{"Descri็ใo Grupo" ,"XX_DESCGRUPO",PesqPict("SBM","BM_DESC")    ,TamSx3("BM_DESC")[1]   ,0,"","€€€€€€€€€€€€€€€","C","","","","",".T."})
	aAdd(_aHeader,{"Qtde. Embarque"  ,"XX_QTDEEMB"  ,PesqPict("ZZU","ZZU_QTDE")   ,TamSx3("ZZU_QTDE")[1]  ,0,"","€€€€€€€€€€€€€€€","C","","","","",".T."})
	aAdd(_aHeader,{"Custo Produto"   ,"XX_CUSPROD"  ,PesqPict("SB2","B2_CMFIM1")  ,TamSx3("B2_CMFIM1")[1] ,0,"","€€€€€€€€€€€€€€€","C","","","","",".T."})

Return()



User Function STOPCOM(_cOp,_nOp)

	Local	cQuery		:= ' '
	Local	_aMaiTo		:= {}
	Private cPerg       := 'STOPCOM'
	Private cTime       := Time()
	Private cHora       := SUBSTR(cTime, 1, 2)
	Private cMinutos    := SUBSTR(cTime, 4, 2)
	Private cSegundos   := SUBSTR(cTime, 7, 2)
	Private _cAliasZ    := cPerg+cHora+ cMinutos+cSegundos


	cQuery := "  SELECT DISTINCT CB7_OP,C2_PRODUTO FROM CB7030 CB7 INNER JOIN(SELECT * FROM SC2030) SC2 ON SC2.D_E_L_E_T_ = ' ' AND SC2.C2_NUM||C2_ITEM||C2_SEQUEN = CB7.CB7_OP   AND CB7_FILIAL = C2_FILIAL AND C2_ZDESTIN = '1' WHERE CB7.D_E_L_E_T_ = ' ' AND CB7_OP <> ' ' AND NOT EXISTS (SELECT * FROM ZZJ010 ZZJ WHERE ZZJ.D_E_L_E_T_ = ' ' AND ZZJ_COD = C2_PRODUTO
	cQuery += "  AND ZZJ_DATA > '"+ dtos(ddatabase)+"'  )
	If _nOp = 1
		cQuery += "  AND CB7_ORDSEP = '"+_cOp+"'"
	Else
		cQuery += "  AND CB7_DTEMIS >= '"+ dtos((ddatabase-2))+"'
	EndIf




	If Select(_cAliasZ) > 0
		(_cAliasZ)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),_cAliasZ)

	Aadd(_aMaiTo,{'Op','Produto'})
	If  Select(_cAliasZ) > 0
		(_cAliasZ)->(dbgotop())



		While !(_cAliasZ)->(Eof())

			Aadd(_aMaiTo,{(_cAliasZ)->CB7_OP,(_cAliasZ)->C2_PRODUTO})

			(_cAliasZ)->(dbSkip())
		End
	EndIf

	If Len(_aMaiTo) > 1

		STOPCMAI(_aMaiTo,_nOp)

	EndIf





Return()

	*------------------------------------------------------------------*
Static Function  STOPCMAI(_aMsg,_nOp)
	*------------------------------------------------------------------*

	Local aArea 	:= GetArea()
	Local _cFrom   := "protheus@steck.com.br"
	Local _cAssunto:= 'Op Sem Compromisso'
	Local cFuncSent:= "STOPCMAI"
	Local i        := 0
	Local cArq     := ""
	Local cMsg     := ""
	Local _nLin
	Local _cCopia  := ' '
	Local _cEmail  :=  ' '

	If __cuserid = '000000'
		_cAssunto:= "TESTE DE ENVIO DE EMAIL FAVOR DESCONSIDERAR - "+_cAssunto
	EndIf

	_cEmail  := ' sadoque.manoel@steck.com.br;tiago.brandao@steck.com.br;' + GetMv("ST_STOPCMA",,"")
	If _nOp <> 1
		_cEmail:= '  andre.bugatti@steck.com.br ;tamires.eufrazio@steck.com.br;tiago.brandao@steck.com.br;'+_cEmail
	EndIf
	If ( Type("l410Auto") == "U" .OR. !l410Auto )


		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Definicao do cabecalho do email                                             ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		cMsg := ""
		cMsg += '<html>'
		cMsg += '<head>'
		cMsg += '<title>' + _cAssunto + " - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title>'
		cMsg += '</head>'
		cMsg += '<body>'
		//cMsg += '<Img Src="C:/AP5/SIGAADV/LGRL01.BMP"><BR>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
		cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>' + _cAssunto +" - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+ '</FONT> </Caption>'
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Definicao do texto/detalhe do email                                         ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		For _nLin := 1 to Len(_aMsg)
			IF (_nLin/2) == Int( _nLin/2 )
				cMsg += '<TR BgColor=#B0E2FF>'
			Else
				cMsg += '<TR BgColor=#FFFFFF>'
			EndIF
			cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></B></TD>'
			cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></TD>'
			cMsg += '</TR>'
		Next
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Definicao do rodape do email                                                ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		cMsg += '</Table>'
		cMsg += '<P>'
		cMsg += '<Table align="center">'
		cMsg += '<tr>'
		cMsg += '<td colspan="10" align="center"><font color="red" size="3">E-mail gerado em: '+ Dtoc(date())+'-'+ Time()+'  - <font color="red" size="1">('+cFuncSent+')</td>'
		cMsg += '</tr>'
		cMsg += '</Table>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		//cMsg += '<B><Font Color=#000000 Size="2" Face="Arial"> Atenciosamente </Font></B><BR>'
		//cMsg += '<B><Font Color=#000000 Size="2" Face="Arial">' + SM0->M0_NOMECOM + '</Font></B><BR>'
		//cMsg += '<Img Src="C:/AP5/SIGAADV/LGRL01.BMP">'
		cMsg += '</body>'
		cMsg += '</html>'


		If !(   U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,) )
			MsgInfo("Email nใo Enviado..!!!!")
		EndIf
	EndIf
	RestArea(aArea)
Return()


Static Function GetXML(cIdEnt,aIdNFe,cModalidade)

	Local aRetorno		:= {}
	Local aDados		:= {}

	Local cURL			:= PadR(GetNewPar("MV_SPEDURL","http://localhost:8080/sped"),250)
	Local cModel		:= "55"

	Local nZ			:= 0
	Local nCount		:= 0

	Local oWS

	If Empty(cModalidade)

		oWS := WsSpedCfgNFe():New()
		oWS:cUSERTOKEN := "TOTVS"
		oWS:cID_ENT    := cIdEnt
		oWS:nModalidade:= 0
		oWS:_URL       := AllTrim(cURL)+"/SPEDCFGNFe.apw"
		oWS:cModelo    := cModel
		If oWS:CFGModalidade()
			cModalidade    := SubStr(oWS:cCfgModalidadeResult,1,1)
		Else
			cModalidade    := ""
		EndIf

	EndIf

	oWs := nil

	For nZ := 1 To len(aIdNfe)

		nCount++

		aDados := executeRetorna( aIdNfe[nZ], cIdEnt )

		if ( nCount == 10 )
			delClassIntF()
			nCount := 0
		endif

		aAdd(aRetorno,aDados)

	Next nZ

Return(aRetorno)

//-----------------------------------------------------------------------
/*/{Protheus.doc} executeRetorna
Executa o retorna de notas

@author Henrique Brugugnoli
@since 17/01/2013
@version 1.0

@param  cID ID da nota que sera retornado

@return aRetorno   Array com os dados da nota
/*/
//-----------------------------------------------------------------------
static function executeRetorna( aNfe, cIdEnt, lUsacolab )

	Local aExecute		:= {}
	Local aFalta		:= {}
	Local aResposta		:= {}
	Local aRetorno		:= {}
	Local aDados		:= {}
	Local aIdNfe		:= {}

	Local cAviso		:= ""
	Local cDHRecbto		:= ""
	Local cDtHrRec		:= ""
	Local cDtHrRec1		:= ""
	Local cErro			:= ""
	Local cModTrans		:= ""
	Local cProtDPEC		:= ""
	Local cProtocolo	:= ""
	Local cMsgNFE			:= ""
	Local cRetDPEC		:= ""
	Local cRetorno		:= ""
	Local cCodRetNFE	:= ""
	Local cURL			:= PadR(GetNewPar("MV_SPEDURL","http://localhost:8080/sped"),250)
	Local cModel		:= "55"

	Local dDtRecib		:= CToD("")

	Local lFlag			:= .T.

	Local nDtHrRec1		:= 0
	Local nL			:= 0
	Local nX			:= 0
	Local nY			:= 0
	Local nZ			:= 1
	Local nCount		:= 0
	Local nLenNFe
	Local nLenWS

	Local oWS

	Private oDHRecbto
	Private oNFeRet
	Private oDoc

	default lUsacolab	:= .F.

	aAdd(aIdNfe,aNfe)

	if !lUsacolab

		oWS:= WSNFeSBRA():New()
		oWS:cUSERTOKEN        := "TOTVS"
		oWS:cID_ENT           := cIdEnt
		oWS:nDIASPARAEXCLUSAO := 0
		oWS:_URL 			  := AllTrim(cURL)+"/NFeSBRA.apw"
		oWS:oWSNFEID          := NFESBRA_NFES2():New()
		oWS:oWSNFEID:oWSNotas := NFESBRA_ARRAYOFNFESID2():New()

		aadd(aRetorno,{"","",aIdNfe[nZ][4]+aIdNfe[nZ][5],"","","",CToD(""),"","",""})

		aadd(oWS:oWSNFEID:oWSNotas:oWSNFESID2,NFESBRA_NFESID2():New())
		Atail(oWS:oWSNFEID:oWSNotas:oWSNFESID2):cID := aIdNfe[nZ][4]+aIdNfe[nZ][5]

		If oWS:RETORNANOTASNX()
			If Len(oWs:oWSRETORNANOTASNXRESULT:OWSNOTAS:OWSNFES5) > 0
				For nX := 1 To Len(oWs:oWSRETORNANOTASNXRESULT:OWSNOTAS:OWSNFES5)
					cRetorno        := oWs:oWSRETORNANOTASNXRESULT:OWSNOTAS:OWSNFES5[nX]:oWSNFE:CXML
					cProtocolo      := oWs:oWSRETORNANOTASNXRESULT:OWSNOTAS:OWSNFES5[nX]:oWSNFE:CPROTOCOLO
					cDHRecbto  		:= oWs:oWSRETORNANOTASNXRESULT:OWSNOTAS:OWSNFES5[nX]:oWSNFE:CXMLPROT
					oNFeRet			:= XmlParser(cRetorno,"_",@cAviso,@cErro)
					cModTrans		  := IIf(Type("oNFeRet:_NFE:_INFNFE:_IDE:_TPEMIS:TEXT") <> "U",IIf (!Empty("oNFeRet:_NFE:_INFNFE:_IDE:_TPEMIS:TEXT"),oNFeRet:_NFE:_INFNFE:_IDE:_TPEMIS:TEXT,1),1)
					If ValType(oWs:OWSRETORNANOTASNXRESULT:OWSNOTAS:OWSNFES5[nX]:OWSDPEC)=="O"
						cRetDPEC        := oWs:oWSRETORNANOTASNXRESULT:OWSNOTAS:OWSNFES5[nX]:oWSDPEC:CXML
						cProtDPEC       := oWs:oWSRETORNANOTASNXRESULT:OWSNOTAS:OWSNFES5[nX]:oWSDPEC:CPROTOCOLO
					EndIf

					//Tratamento para gravar a hora da transmissao da NFe
					If !Empty(cProtocolo)
						oDHRecbto		:= XmlParser(cDHRecbto,"","","")
						cDtHrRec		:= IIf(Type("oDHRecbto:_ProtNFE:_INFPROT:_DHRECBTO:TEXT")<>"U",oDHRecbto:_ProtNFE:_INFPROT:_DHRECBTO:TEXT,"")
						nDtHrRec1		:= RAT("T",cDtHrRec)

						If nDtHrRec1 <> 0
							cDtHrRec1   :=	SubStr(cDtHrRec,nDtHrRec1+1)
							dDtRecib	:=	SToD(StrTran(SubStr(cDtHrRec,1,AT("T",cDtHrRec)-1),"-",""))
						EndIf

						AtuSF2Hora(cDtHrRec1,aIdNFe[nZ][5]+aIdNFe[nZ][4]+aIdNFe[nZ][6]+aIdNFe[nZ][7])

					EndIf

					nY := aScan(aIdNfe,{|x| x[4]+x[5] == SubStr(oWs:oWSRETORNANOTASNXRESULT:OWSNOTAS:OWSNFES5[nX]:CID,1,Len(x[4]+x[5]))})

					oWS:cIdInicial    := aIdNfe[nZ][4]+aIdNfe[nZ][5]
					oWS:cIdFinal      := aIdNfe[nZ][4]+aIdNfe[nZ][5]
					If oWS:MONITORFAIXA()
						cCodRetNFE := oWS:oWsMonitorFaixaResult:OWSMONITORNFE[1]:OWSERRO:OWSLOTENFE[len(oWS:oWsMonitorFaixaResult:OWSMONITORNFE[1]:OWSERRO:OWSLOTENFE)]:CCODRETNFE
						cMsgNFE	:= oWS:oWsMonitorFaixaResult:OWSMONITORNFE[1]:OWSERRO:OWSLOTENFE[len(oWS:oWsMonitorFaixaResult:OWSMONITORNFE[1]:OWSERRO:OWSLOTENFE)]:CMSGRETNFE
					EndIf

					If nY > 0
						aRetorno[nY][1] := cProtocolo
						aRetorno[nY][2] := cRetorno
						aRetorno[nY][4] := cRetDPEC
						aRetorno[nY][5] := cProtDPEC
						aRetorno[nY][6] := cDtHrRec1
						aRetorno[nY][7] := dDtRecib
						aRetorno[nY][8] := cModTrans
						aRetorno[nY][9] := cCodRetNFE
						aRetorno[nY][10]:= cMsgNFE

						//aadd(aResposta,aIdNfe[nY])
					EndIf
					cRetDPEC := ""
					cProtDPEC:= ""
				Next nX
				/*For nX := 1 To Len(aIdNfe)
				If aScan(aResposta,{|x| x[4] == aIdNfe[nX,04] .And. x[5] == aIdNfe[nX,05] })==0

				conout("Falta")
				conout(aIdNfe[nX][4]+" - "+aIdNfe[nX][5])
				aadd(aFalta,aIdNfe[nX])
				EndIf
				Next nX
				If Len(aFalta)>0
				aExecute := GetXML(cIdEnt,aFalta,@cModalidade)
				Else
				aExecute := {}
				EndIf*/
				/*For nX := 1 To Len(aExecute)
				nY := aScan(aRetorno,{|x| x[3] == aExecute[nX][03]})
				If nY == 0
				aadd(aRetorno,{aExecute[nX][01],aExecute[nX][02],aExecute[nX][03]})
				Else
				aRetorno[nY][01] := aExecute[nX][01]
				aRetorno[nY][02] := aExecute[nX][02]
				EndIf
				Next nX*/
			EndIf
		Else
			Aviso("DANFE",IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)),{"OK"},3)
		EndIf
	else
		oDoc 			:= ColaboracaoDocumentos():new()
		oDoc:cModelo	:= "NFE"
		oDoc:cTipoMov	:= "1"
		oDoc:cIDERP	:= aIdNfe[nZ][4]+aIdNfe[nZ][5]+FwGrpCompany()+FwCodFil()

		aadd(aRetorno,{"","",aIdNfe[nZ][4]+aIdNfe[nZ][5],"","","",CToD(""),"","",""})

		if odoc:consultar()
			aDados := ColDadosNf(1)

			if !Empty(oDoc:cXMLRet)
				cRetorno	:= oDoc:cXMLRet
			else
				cRetorno	:= oDoc:cXml
			endif

			aDadosXml := ColDadosXMl(cRetorno, aDados, @cErro, @cAviso)

			if '<obsCont xCampo="nRegDPEC">' $ cRetorno
				aDadosXml[9] := SubStr(cRetorno,At('<obsCont xCampo="nRegDPEC"><xTexto>',cRetorno)+35,15)
			endif

			cProtocolo		:= aDadosXml[3]
			cModTrans		:= IIF(Empty(aDadosXml[5]),aDadosXml[7],aDadosXml[5])
			cCodRetNFE := aDadosXml[1]
			cMsgNFE := iif (aDadosXml[2]<> nil ,aDadosXml[2],"")
			//Dados do DEPEC
			If !Empty( aDadosXml[9] )
				cRetDPEC        := cRetorno
				cProtDPEC       := aDadosXml[9]
			EndIf

			//Tratamento para gravar a hora da transmissao da NFe
			If !Empty(cProtocolo)
				cDtHrRec		:= aDadosXml[4]
				nDtHrRec1		:= RAT("T",cDtHrRec)

				If nDtHrRec1 <> 0
					cDtHrRec1   :=	SubStr(cDtHrRec,nDtHrRec1+1)
					dDtRecib	:=	SToD(StrTran(SubStr(cDtHrRec,1,AT("T",cDtHrRec)-1),"-",""))
				EndIf

				AtuSF2Hora(cDtHrRec1,aIdNFe[nZ][5]+aIdNFe[nZ][4]+aIdNFe[nZ][6]+aIdNFe[nZ][7])

			EndIf

			aRetorno[1][1] := cProtocolo
			aRetorno[1][2] := cRetorno
			aRetorno[1][4] := cRetDPEC
			aRetorno[1][5] := cProtDPEC
			aRetorno[1][6] := cDtHrRec1
			aRetorno[1][7] := dDtRecib
			aRetorno[1][8] := cModTrans
			aRetorno[1][9] := cCodRetNFE
			aRetorno[1][10]:= cMsgNFE

			cRetDPEC := ""
			cProtDPEC:= ""

		endif
	endif

	oWS       := Nil
	oDHRecbto := Nil
	oNFeRet   := Nil

return aRetorno[len(aRetorno)]

static function atuSf2Hora( cDtHrRec,cSeek )

	local aArea := GetArea()

	dbSelectArea("SF2")
	dbSetOrder(1)
	If MsSeek(xFilial("SF2")+cSeek)
		If SF2->(FieldPos("F2_HORA"))<>0 .And. Empty(SF2->F2_HORA)
			RecLock("SF2")
			SF2->F2_HORA := cDtHrRec
			MsUnlock()
		EndIf
	EndIf
	dbSelectArea("SF1")
	dbSetOrder(1)
	If MsSeek(xFilial("SF1")+cSeek)
		If SF1->(FieldPos("F1_HORA"))<>0 .And. Empty(SF1->F1_HORA)
			RecLock("SF1")
			SF1->F1_HORA := cDtHrRec
			MsUnlock()
		EndIf
	EndIf

	RestArea(aArea)

return nil

//-----------------------------------------------------------------------
/*/{Protheus.doc} ColDadosNf
Devolve os dados com a informa็ใo desejada conforme parโmetro nInf.

@author 	Rafel Iaquinto
@since 		30/07/2014
@version 	11.9

@param	nInf, inteiro, Codigo da informa็ใo desejada:<br>1 - Normal<br>2 - Cancelametno<br>3 - Inutiliza็ใo

@return aRetorno Array com as posi็๕es do XML desejado, sempre deve retornar a mesma quantidade de posi็๕es.
/*/
//-----------------------------------------------------------------------
static function ColDadosNf(nInf)

	local aDados	:= {}

	do case
		case nInf == 1
		//Informa็oes da NF-e
		aadd(aDados,"NFEPROC|PROTNFE|INFPROT|CSTAT") //1 - Codigo Status documento
		aadd(aDados,"NFEPROC|PROTNFE|INFPROT|XMOTIVO") //2 - Motivo do status
		aadd(aDados,"NFEPROC|PROTNFE|INFPROT|NPROT")	//3 - Protocolo Autporizacao
		aadd(aDados,"NFEPROC|PROTNFE|INFPROT|DHRECBTO")	//4 - Data e hora de recebimento
		aadd(aDados,"NFEPROC|NFE|INFNFE|IDE|TPEMIS") //5 - Tipo de Emissao
		aadd(aDados,"NFEPROC|NFE|INFNFE|IDE|TPAMB") //6 - Ambiente de transmissใo
		aadd(aDados,"NFE|INFNFE|IDE|TPEMIS") //7 - Tipo de Emissao - Caso nao tenha retorno
		aadd(aDados,"NFE|INFNFE|IDE|TPAMB") //8 - Ambiente de transmissใo -  Caso nao tenha retorno
		aadd(aDados,"NFEPROC|RETDEPEC|INFDPECREG|NREGDPEC") //9 - Numero de autoriza็ใo DPEC
		aadd(aDados,"NFEPROC|PROTNFE|INFPROT|CHNFE") //10 - Chave da autorizacao

		case nInf == 2
		//Informacoes do cancelamento - evento
		aadd(aDados,"PROCEVENTONFE|RETEVENTO|INFEVENTO|CSTAT") //1 - Codigo Status documento
		aadd(aDados,"PROCEVENTONFE|RETEVENTO|INFEVENTO|XMOTIVO") //2 - Motivo do status
		aadd(aDados,"PROCEVENTONFE|RETEVENTO|INFEVENTO|NPROT")	//3 - Protocolo Autporizacao
		aadd(aDados,"PROCEVENTONFE|RETEVENTO|INFEVENTO|DHREGEVENTO")	//4 - Data e hora de recebimento
		aadd(aDados,"") //5 - Tipo de Emissao
		aadd(aDados,"PROCEVENTONFE|RETEVENTO|INFEVENTO|TPAMB") //6 - Ambiente de transmissใo
		aadd(aDados,"") //7 - Tipo de Emissao - Caso nao tenha retorno
		aadd(aDados,"ENVEVENTO|EVENTO|INFEVENTO|TPAMB") //8 - Ambiente de transmissใo -  Caso nao tenha retorno
		aadd(aDados,"") //9 - Numero de autoriza็ใo DPEC
		aadd(aDados,"") //10 - Chave da autorizacao

		case nInf == 3
		//Informa็๕es da Inutiliza็ใo
		aadd(aDados,"PROCINUTNFE|RETINUTNFE|INFINUT|CSTAT") //1 - Codigo Status documento
		aadd(aDados,"PROCINUTNFE|RETINUTNFE|INFINUT|XMOTIVO") //2 - Motivo do status
		aadd(aDados,"PROCINUTNFE|RETINUTNFE|INFINUT|NPROT")	//3 - Protocolo Autporizacao
		aadd(aDados,"PROCINUTNFE|RETINUTNFE|INFINUT|DHRECBTO")	//4 - Data e hora de recebimento
		aadd(aDados,"") //5 - Tipo de Emissao
		aadd(aDados,"PROCINUTNFE|RETINUTNFE|INFINUT|TPAMB") //6 - Ambiente de transmissใo
		aadd(aDados,"") //7 - Tipo de Emissao - Caso nao tenha retorno
		aadd(aDados,"INUTNFE|INFINUT|TPAMB	") //8 - Ambiente de transmissใo -  Caso nao tenha retorno
		aadd(aDados,"") //9 - Numero de autoriza็ใo DPEC
		aadd(aDados,"") //10 - Chave da autorizacao
	end

return(aDados)
