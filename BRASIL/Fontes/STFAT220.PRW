#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWMVCDEF.CH"

/*====================================================================================\
|Programa  | STFAT220        | Autor | RENATO.OLIVEIRA           | Data | 01/10/2019  |
|=====================================================================================|
|Descrição | Verificar xmls de devolução e incluir fatec automaticamente              |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|====================DB=================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STFAT220()

	Local _cQuery1 := ""
	Local _cAlias1 := ""
	Local _cQuery2 := ""
	Local _cAlias2 := ""
	Local _nX 	   := 0
	Local _nY	   := 0

	//RpcSetType( 3 )
	//RpcSetEnv("11","01",,,"FAT")
	PREPARE ENVIRONMENT EMPRESA '11' FILIAL '01'

	If !LockByName("STFAT220",.F.,.F.,.T.)
		ConOut("[STFAT220]["+ FWTimeStamp(2) +"] - Já existe uma sessão em processamento.")
		Return()
	EndIf

	Conout("[STFAT220]"+FWTimeStamp(2)+" - Inicio do processamento de fatec automática")

	_cAlias1 := GetNextAlias()
	_cAlias2 := GetNextAlias()

	DbSelectArea("SZ9")
	DbSelectArea("PC1")
	DbSelectArea("PC2")
	DbSelectArea("SA1")
	SA1->(DbSetOrder(1))
	DbSelectArea("SA3")
	SA3->(DbSetOrder(1))
	DbSelectArea("SB1")
	SB1->(DbSetOrder(1))
	DbSelectArea("SBM")
	SBM->(DbSetOrder(1))
	DbSelectArea("SA7")
	SA7->(DbSetOrder(3))

	_cQuery1 := " SELECT Z9.R_E_C_N_O_ RECSZ9
	_cQuery1 += " FROM "+RetSqlName("SZ9")+" Z9 "
	_cQuery1 += " WHERE Z9.D_E_L_E_T_=' ' AND Z9_FILIAL='"+xFilial("SZ9")+"' "
	_cQuery1 += " AND Z9_C14='DEVOLUCAO' "
	_cQuery1 += " AND Z9_DTVLDDV=' '  "   
		
	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)

	(_cAlias1)->(dbGoTop())

	While (_cAlias1)->(!Eof())

		SZ9->(DbGoTo((_cAlias1)->RECSZ9))

		If SZ9->(Eof())
			(_cAlias1)->(DbSkip())
			Loop
		EndIf

		cAviso := ""
		cErro  := ""

		oNfe := XmlParser(SZ9->Z9_XML,'_',@cErro,@cAviso)

		If Empty(cErro) .And. Empty(cAviso)

			_xNfRef 	:=  XmlChildEx ( oNfe:_NFEPROC:_NFE:_INFNFE:_IDE,"_NFREF" )
			_aNfs 		:= {}
			_aNfsNE 	:= {}
			_aProds		:= {}
			_aProdsEnc 	:= {}
			_cErro  	:= ""
			_aErros		:= {}
			_lTemErro	:= .F.
			_nValDif	:= 0
			_cCliente   := ""
			_cLoja	    := ""
			_cEmlVen    := ""
			_cCnpjCli	:= ""

			If Type("_xNfRef")=="O"
				If Type("_xNfRef:_REFNFE:TEXT")=="C"
					AADD(_aNfs,_xNfRef:_REFNFE:TEXT)
				EndIf
			ElseIf Type("_xNfRef")=="A"
				For _nX:=1 To Len(_xNfRef)
					If Type("_xNfRef["+cValToChar(_nX)+"]:_REFNFE:TEXT")=="C"
						AADD(_aNfs,_xNfRef[_nX]:_REFNFE:TEXT)
					EndIf
				Next
			EndIf

			If Len(_aNfs)<=0
				SZ9->(RecLock("SZ9",.F.))
				SZ9->Z9_DTVLDDV := Date()
				SZ9->(MsUnLock())
				_cErro := "Não possui nota de devolução referenciada."
				ENVEMAIL(_cErro)  
				(_cAlias1)->(DbSkip())
				Loop
			Else

				//Verificar se CNPJ de destino é o CD
				_xDest 	:=  XmlChildEx ( oNfe:_NFEPROC:_NFE:_INFNFE:_DEST,"_CNPJ" )
				//>> Ticket 20220428008993 - Everson Santana - 25.05.2022
				If Empty(_xDest)
					SZ9->(RecLock("SZ9",.F.))
					SZ9->Z9_DTVLDDV := Date()
					SZ9->(MsUnLock())
					_cErro := "CNPJ do CD não Localizado no XML"
					ENVEMAIL(_cErro)  
					(_cAlias1)->(DbSkip())
					Loop
				EndiF
				//<<
				If !(AllTrim(_xDest:TEXT)=="44415136000138")
					SZ9->(RecLock("SZ9",.F.))
					SZ9->Z9_DTVLDDV := Date()
					SZ9->(MsUnLock())
					_cErro := "CNPJ de destino não é o CD."
					ENVEMAIL(_cErro)  
					(_cAlias1)->(DbSkip())
					Loop
				EndIf

				//Verificar se encontra todas as notas de devolução
				For _nX:=1 To Len(_aNfs)

					_cQuery2 := " SELECT COUNT(*) QTD
					_cQuery2 += " FROM "+RetSqlName("SF2")+" F2
					_cQuery2 += " WHERE F2.D_E_L_E_T_=' ' AND F2_FILIAL='"+xFilial("SZ9")+"'
					_cQuery2 += " AND F2_CHVNFE='"+_aNfs[_nX]+"'

					If !Empty(Select(_cAlias2))
						DbSelectArea(_cAlias2)
						(_cAlias2)->(dbCloseArea())
					Endif

					dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery2),_cAlias2,.T.,.T.)

					dbSelectArea(_cAlias2)

					(_cAlias2)->(dbGoTop())

					If (_cAlias2)->QTD>0
						AADD(_aNfsNE,_aNfs[_nX])
					EndIf

				Next

				If Len(_aNfsNE)==0
					SZ9->(RecLock("SZ9",.F.))
					SZ9->Z9_DTVLDDV := Date()
					SZ9->(MsUnLock())
					_cErro := "Nota(s) referenciada(s) não encontrada(s) na nossa base."
					ENVEMAIL(_cErro) 
					(_cAlias1)->(DbSkip())
					Loop
				EndIf

				//Verificar se todos os itens são encontrados nas notas de saída
				_xProds :=  XmlChildEx ( oNfe:_NFEPROC:_NFE:_INFNFE,"_DET")
				_cCfop  := ""

				_cCnpjCli := AllTrim(oNfe:_NFEPROC:_NFE:_INFNFE:_EMIT:_CNPJ:TEXT)

				SA1->(DbSetOrder(3))
				If !SA1->(DbSeek(xFilial("SA1")+_cCnpjCli))
					SZ9->(RecLock("SZ9",.F.))
					SZ9->Z9_DTVLDDV := Date()
					SZ9->(MsUnLock())
					_cErro := "Cliente não encontrado pelo cnpj."
					ENVEMAIL(_cErro)  
					(_cAlias1)->(DbSkip())
					Loop
				EndIf

				If Type("_xProds")=="O"
					If Type("_xProds:_PROD:_CPROD:TEXT")=="C"

						_nIcms := 0
						_nIpi  := 0
						_nSt   := 0

						If Type("_xProds:_IMPOSTO:_ICMS:_ICMS00:_VICMS:TEXT")=="C"
							_nIcms := Val(_xProds:_IMPOSTO:_ICMS:_ICMS00:_VICMS:TEXT)
						EndIf
						If Type("_xProds:_IMPOSTO:_ICMS:_ICMS10:_VICMS:TEXT")=="C"
							_nIcms := Val(_xProds:_IMPOSTO:_ICMS:_ICMS10:_VICMS:TEXT)
						EndIf
						If Type("_xProds:_IMPOSTO:_IPI:_IPITRIB:_VIPI:TEXT")=="C"
							_nIpi += Val(_xProds:_IMPOSTO:_IPI:_IPITRIB:_VIPI:TEXT)
						EndIf
						If Type("_xProds:_IMPOSTODEVOL:_IPI:_VIPIDEVOL:TEXT")=="C"
							_nIpi += Val(_xProds:_IMPOSTODEVOL:_IPI:_VIPIDEVOL:TEXT)
						EndIf
						If Type("_xProds:_PROD:_VOUTRO:TEXT")=="C"
							_nSt := Val(_xProds:_PROD:_VOUTRO:TEXT)
						EndIf

						AADD(_aProds,{;
						_xProds:_NITEM:TEXT,;
						_xProds:_PROD:_CPROD:TEXT,;
						_xProds:_PROD:_CEAN:TEXT,;
						_xProds:_PROD:_QCOM:TEXT,;
						_xProds:_PROD:_VUNCOM:TEXT,;
						_nIcms,;
						_nIpi,;
						_nSt,;
						"",;
						.F.})

						_cCfop := _xProds:_PROD:_CFOP:TEXT

					EndIf
				ElseIf Type("_xProds")=="A"
					For _nX:=1 To Len(_xProds)
						If Type("_xProds["+cValToChar(_nX)+"]:_PROD:_CPROD:TEXT")=="C"

							_nIcms := 0
							_nIpi  := 0
							_nSt   := 0

							If Type("_xProds["+cValToChar(_nX)+"]:_IMPOSTO:_ICMS:_ICMS00:_VICMS:TEXT")=="C"
								_nIcms := Val(_xProds[_nX]:_IMPOSTO:_ICMS:_ICMS00:_VICMS:TEXT)
							EndIf
							If Type("_xProds["+cValToChar(_nX)+"]:_IMPOSTO:_ICMS:_ICMS10:_VICMS:TEXT")=="C"
								_nIcms := Val(_xProds[_nX]:_IMPOSTO:_ICMS:_ICMS10:_VICMS:TEXT)
							EndIf
							If Type("_xProds["+cValToChar(_nX)+"]:_IMPOSTO:_IPI:_IPITRIB:_VIPI:TEXT")=="C"
								_nIpi += Val(_xProds[_nX]:_IMPOSTO:_IPI:_IPITRIB:_VIPI:TEXT)
							EndIf
							If Type("_xProds["+cValToChar(_nX)+"]:_IMPOSTODEVOL:_IPI:_VIPIDEVOL:TEXT")=="C"
								_nIpi += Val(_xProds[_nX]:_IMPOSTODEVOL:_IPI:_VIPIDEVOL:TEXT)
							EndIf
							If Type("_xProds["+cValToChar(_nX)+"]:_PROD:_VOUTRO:TEXT")=="C"
								_nSt := Val(_xProds[_nX]:_PROD:_VOUTRO:TEXT)
							EndIf

							AADD(_aProds,{;
							_xProds[_nX]:_NITEM:TEXT,;
							_xProds[_nX]:_PROD:_CPROD:TEXT,;
							_xProds[_nX]:_PROD:_CEAN:TEXT,;
							_xProds[_nX]:_PROD:_QCOM:TEXT,;
							_xProds[_nX]:_PROD:_VUNCOM:TEXT,;
							_nIcms,;
							_nIpi,;
							_nSt,;
							"",;
							.F.})

							_cCfop := _xProds[_nX]:_PROD:_CFOP:TEXT

						EndIf
					Next
				EndIf

				If !(SubStr(_cCfop,1,1) $ "5#6")
					SZ9->(RecLock("SZ9",.F.))
					SZ9->Z9_DTVLDDV := Date()
					SZ9->(MsUnLock())
					(_cAlias1)->(DbSkip())
					Loop
				EndIf

				If Len(_aProds)<=0
					SZ9->(RecLock("SZ9",.F.))
					SZ9->Z9_DTVLDDV := Date()
					SZ9->(MsUnLock())
					_cErro := "Nenhum produto foi encontrado na nota."
					ENVEMAIL(_cErro,,,,_cCfop)  
					(_cAlias1)->(DbSkip())
					Loop
				EndIf

				_lErro := .F.

				For _nX:=1 To Len(_aProds)

					//Procurar pelo código steck
					If SB1->(DbSeek(xFilial("SB1")+_aProds[_nX][2]))
						_aProds[_nX][9] := SB1->B1_COD
						Loop
					EndIf

					//Procurar pelo código de barras
					SB1->(DbSetOrder(5))
					If SB1->(DbSeek(xFilial("SB1")+_aProds[_nX][3]))
						_aProds[_nX][9] := SB1->B1_COD
						Loop
					EndIf

					//Procurar pela amarração produto x cliente
					If SA7->(DbSeek(xFilial("SA7")+SA1->(A1_COD+A1_LOJA)+_aProds[_nX][2]))
						_aProds[_nX][9] := SA7->A7_PRODUTO
						Loop
					EndIf

					If Empty(_aProds[_nX][9])
						_lErro := .T.
						_aProds[_nX][Len(_aProds[_nX])] := .T.
					EndIf

				Next

				If _lErro
					SZ9->(RecLock("SZ9",.F.))
					SZ9->Z9_DTVLDDV := Date()
					SZ9->(MsUnLock())
					_cErro := "Não encontrada amarração de produtos"
					ENVEMAIL(_cErro,_aProds,_aProdsEnc,,_cCfop)  
					(_cAlias1)->(DbSkip())
					Loop				
				EndIf

				SB1->(DbSetOrder(1))

				For _nX:=1 To Len(_aNfs)

					For _nY:=1 To Len(_aProds)

						_cQuery2 := " SELECT D2_COD,D2_DOC,D2_SERIE,D2_ITEM,D2_QUANT,D2_QUANT-D2_QTDEDEV SALDO,D2_VALICM,D2_PRCVEN,B1_CODBAR
						_cQuery2 += " ,F2_CLIENTE, F2_LOJA, A1_NOME, D2_VALIPI, D2_ICMSRET
						_cQuery2 += " FROM "+RetSqlName("SF2")+" F2
						_cQuery2 += " LEFT JOIN "+RetSqlName("SD2")+" D2
						_cQuery2 += " ON F2_FILIAL=D2_FILIAL AND F2_DOC=D2_DOC AND F2_SERIE=D2_SERIE
						_cQuery2 += " AND F2_CLIENTE=D2_CLIENTE AND F2_LOJA=D2_LOJA
						_cQuery2 += " LEFT JOIN "+RetSqlName("SB1")+" B1
						_cQuery2 += " ON B1_COD=D2_COD 
						_cQuery2 += " LEFT JOIN "+RetSqlName("SA1")+" A1
						_cQuery2 += " ON F2_CLIENTE=A1_COD AND F2_LOJA=A1_LOJA
						_cQuery2 += " WHERE F2.D_E_L_E_T_=' ' AND D2.D_E_L_E_T_=' ' AND A1.D_E_L_E_T_=' ' AND B1.D_E_L_E_T_=' ' 
						_cQuery2 += " AND F2_FILIAL='"+xFilial("SZ9")+"'
						_cQuery2 += " AND F2_CHVNFE='"+_aNfs[_nX]+"'
						_cQuery2 += " AND B1_COD='"+_aProds[_nY][9]+"'

						If !Empty(Select(_cAlias2))
							DbSelectArea(_cAlias2)
							(_cAlias2)->(dbCloseArea())
						Endif

						dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery2),_cAlias2,.T.,.T.)

						dbSelectArea(_cAlias2)

						(_cAlias2)->(dbGoTop())

						If (_cAlias2)->(!Eof())

							If SB1->(DbSeek(xFilial("SB1")+(_cAlias2)->D2_COD))

								If SBM->(DbSeek(xFilial("SBM")+SB1->B1_GRUPO))

									AADD(_aProdsEnc,{;
									(_cAlias2)->D2_ITEM,;
									(_cAlias2)->D2_COD,;
									(_cAlias2)->B1_CODBAR,;
									(_cAlias2)->SALDO,;
									(_cAlias2)->D2_PRCVEN,;
									Round(((_cAlias2)->D2_VALICM/(_cAlias2)->D2_QUANT)*Val(_aProds[_nY][4]),2),;
									(_cAlias2)->D2_DOC,;
									(_cAlias2)->D2_SERIE,;
									_aProds[_nY][1],;
									(_cAlias2)->D2_QUANT,;
									SB1->B1_DESC,;
									SB1->B1_GRUPO,;
									SBM->BM_DESC,;
									Round(((_cAlias2)->D2_VALIPI/(_cAlias2)->D2_QUANT)*Val(_aProds[_nY][4]),2),;
									_aProds[_nY][2],;
									Round(((_cAlias2)->D2_ICMSRET/(_cAlias2)->D2_QUANT)*Val(_aProds[_nY][4]),2)})

									_cCliente := (_cAlias2)->F2_CLIENTE
									_cLoja	  := (_cAlias2)->F2_LOJA
									_cNome    := (_cAlias2)->A1_NOME

								EndIf

							EndIf
						EndIf

					Next

				Next

				If !(Len(_aProds)==Len(_aProdsEnc))
					SZ9->(RecLock("SZ9",.F.))
					SZ9->Z9_DTVLDDV := Date()
					SZ9->(MsUnLock())
					_cErro := "Produtos não encontrados nas nossas notas."
					ENVEMAIL(_cErro,_aProds,_aProdsEnc,,_cCfop) 
					(_cAlias1)->(DbSkip())
					Loop
				EndIf

				//Validação de quantidade,preço e impostos
				For _nX:=1 To Len(_aProds)
					//For _nY:=1 To Len(_aProdsEnc)
					//If AllTrim(_aProds[_nX][2])==AllTrim(_aProdsEnc[_nY][15])

					//Validar quantidade
					If Val(_aProds[_nX][4])>_aProdsEnc[_nX][4]
						_nValDif += 1
						_aProds[_nX][Len(_aProds[_nX])] := .T.
					EndIf

					//Validar preço
					If Abs(Val(_aProds[_nX][5])-_aProdsEnc[_nX][5])>0
						_aProds[_nX][Len(_aProds[_nX])] := .T.
					EndIf
					_nValDif += Abs(Val(_aProds[_nX][5])-_aProdsEnc[_nX][5])

					//Validar icms
					If Abs(_aProds[_nX][6]-_aProdsEnc[_nX][6])>0
						_aProds[_nX][Len(_aProds[_nX])] := .T.
					EndIf
					_nValDif += Abs(_aProds[_nX][6]-_aProdsEnc[_nX][6])

					//Validar IPI+ST
					If Abs((_aProds[_nX][7]+_aProds[_nX][8])-(_aProdsEnc[_nX][14]+_aProdsEnc[_nX][16]))>0
						_aProds[_nX][Len(_aProds[_nX])] := .T.
					EndIf
					_nValDif += Abs((_aProds[_nX][7]+_aProds[_nX][8])-(_aProdsEnc[_nX][14]+_aProdsEnc[_nX][16]))

					//Exit
					//EndIf
					//Next
				Next

				If _nValDif>0.05
					SZ9->(RecLock("SZ9",.F.))
					SZ9->Z9_DTVLDDV := Date()
					SZ9->(MsUnLock())
					_cErro := "Erro na conferência dos produtos"
					ENVEMAIL(_cErro,_aProds,_aProdsEnc,,_cCfop)  
					(_cAlias1)->(DbSkip())
					Loop
				Else
					//Inserir FATEC

					/*/
					//FR - 18/07/2022 - Flávia Rocha - Sigamat Consultoria
					//Alteração solicitada no ticket #20220602011433 - gerar Fatec automática apenas para estes clientes:
					CÓDIGO  CLIENTE
					101510	TUL
					101615	Sooper
					014519	C&C
					023789	Construdecor
					028358	Saint-Gobain (Telha Norte)
					036970	Joli
					038134	Leroy Merlin
					047687	Center Castilho
					053211	Village
					064388	Conibase
					090222	Obramax
					092187	Tumelero
					*/
					//parâmetro para armazenar os clientes que serão geradas Fatec automaticamente, apenas estes do parâmetro: 	
					cCliAutom := GetNewPar("STFAT220C" , "101510,101615,014519,023789,028358,036970,038134,047687,053211,064388,090222,092187")
					//FR - 18/07/2022 - Alteração solicitada no ticket #20220602011433 - gerar Fatec automática apenas para estes clientes:

					SA1->(DbSetOrder(1))
					If _cCliente $ cCliAutom
						If SA1->(DbSeek(xFilial("SA1")+_cCliente+_cLoja))
							If SA3->(DbSeek(xFilial("SA3")+SA1->A1_VEND))
								_cEmlVen := AllTrim(SA3->A3_EMAIL)+";"
								If SA3->(DbSeek(xFilial("SA3")+SA3->A3_XCODINT))
									_cEmlVen := AllTrim(SA3->A3_EMAIL)+";"
								EndIf
								If SA3->(DbSeek(xFilial("SA3")+SA3->A3_XSUPINT))
									_cEmlVen += AllTrim(SA3->A3_EMAIL)+";"
								EndIf
							EndIf
						EndIf

						Begin Transaction

							_cNumFat := GETSX8NUM("PC1","PC1_NUMERO")
							PC1->(ConfirmSX8())

							PC1->(RecLock("PC1",.T.))
							PC1->PC1_FILIAL	:= xFilial("PC1")
							PC1->PC1_NUMERO	:= _cNumFat
							PC1->PC1_STATUS	:= "0"
							PC1->PC1_NOTAE	:=	""
							PC1->PC1_SERIEE	:=	""
							PC1->PC1_CODCLI	:= _cCliente
							PC1->PC1_NOMCLI	:= _cNome
							PC1->PC1_LOJA	:= _cLoja
							PC1->PC1_CONTAT	:=	"ROTINA AUTOMATICA"
							PC1->PC1_ATENDE	:=	SUBSTR(CUSUARIO,7,15)
							PC1->PC1_MOTIVO	:=	"999"
							PC1->PC1_REPOSI	:=	"2"
							PC1->PC1_DEVMAT	:=	"1"
							PC1->PC1_DTOCOR	:=	Date()
							PC1->PC1_PEDREP	:=	""
							PC1->PC1_CODUSR	:= __cUserId
							PC1->(MsUnLock())

							For _nX:=1 To Len(_aProdsEnc)
								PC2->(RecLock("PC2",.T.))
								PC2->PC2_FILIAL := xFilial("PC2")
								PC2->PC2_NFATEC := _cNumFat
								PC2->PC2_PRODUT := _aProdsEnc[_nX][2]
								PC2->PC2_DESPRO	:= _aProdsEnc[_nX][11]
								PC2->PC2_NFORIG := _aProdsEnc[_nX][7]
								PC2->PC2_SERIE  := _aProdsEnc[_nX][8]
								PC2->PC2_ITEM	:= _aProdsEnc[_nX][1]
								PC2->PC2_QTDNFS	:= _aProdsEnc[_nX][10]
								PC2->PC2_QTDFAT	:= Val(_aProds[_nX][4])
								PC2->PC2_GRPPRO	:= _aProdsEnc[_nX][12]
								PC2->PC2_DSCPRO := _aProdsEnc[_nX][13]
								PC2->(MsUnLock())
							Next

						End Transaction

						SZ9->(RecLock("SZ9",.F.))
						SZ9->Z9_DTVLDDV := Date()
						SZ9->Z9_FATEC   := _cNumFat
						SZ9->(MsUnLock())
						_cErro := "Fatec "+_cNumFat+" inserida com sucesso!"
						ENVEMAIL(_cErro,_aProds,_aProdsEnc,_cEmlVen,_cCfop)

					Endif
					//FR - 18/07/2022 - Alteração solicitada no ticket #20220602011433 - gerar Fatec automática apenas para estes clientes

					(_cAlias1)->(DbSkip())
					Loop

				EndIf

			EndIf

		Else

			SZ9->(RecLock("SZ9",.F.))
			SZ9->Z9_DTVLDDV := Date()
			SZ9->(MsUnLock())

		EndIf

		(_cAlias1)->(DbSkip())
	EndDo
	
	UnLockByName("STFAT220",.F.,.F.,.T.)

	Conout("[STFAT220]"+FWTimeStamp(2)+" - Fim do processamento de fatec automática")

	Reset Environment
	
Return()

/*====================================================================================\
|Programa  | ENVEMAIL        | Autor | RENATO.OLIVEIRA           | Data | 01/10/2019  |
|=====================================================================================|
|Descrição | Enviar workflow                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

Static Function ENVEMAIL(_cStatus,_aProds,_aProdsEnc,_cEmlVend,_cCfop)

	Local _cEmail 		:= ""
	Local _cCopia 		:= ""
	Local _cAssunto		:= ""
	Local _aAttach  	:= {}
	Local _cCaminho 	:= ""
	Local cMsg			:= ""
	Local _nX			:= 0
	Default _aProds 	:= {}
	Default _aProdsEnc 	:= {}
	Default _cEmlVend	:= ""
	Default _cCfop		:= ""

	_cEmail   := GetMv("STFAT220",.F.,"renato.oliveira@steck.com.br;veronica.brandao@steck.com.br;rafael.pereira@steck.com.br;julio.oliveira@steck.com.br;marcelo.avelino@steck.com.br")
	_cCopia	  := _cEmlVend
	
	//_cEmail   := "flah.rocha@sigamat.com.br"  //FR TESTE RETIRAR
	//_cCopia   := "flah.rocha@gmail.com;caroline.atouguia@steck.com.br"			//FR TESTE RETIRAR

	_cAssunto := "[WFPROTHEUS] - Documento "+SubStr(SZ9->Z9_CHAVE,26,9)+" de Devolução"	
	_aAttach  := {}
	_cCaminho := ""

	DbSelectArea("SA1")
	SA1->(DbSetOrder(3))
	If SA1->(DbSeek(xFilial("SA1")+SZ9->Z9_CNPJ))
		If SA1->A1_COD $ '028358/038134/014519/090222/092187'
			_cEmail+=';juliana.ferreira@steck.com.br' 
		EndIf
	EndIf

	cMsg := ""
	cMsg += '<html><head><title>'+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title></head><body>'
	cMsg += '<b>Documento: </b>'+SubStr(SZ9->Z9_CHAVE,26,9)+'<br>'
	cMsg += '<b>Chave: </b>'+SZ9->Z9_CHAVE+'<br>'
	cMsg += '<b>Série: </b>'+SubStr(SZ9->Z9_CHAVE,23,3)+'<br>'
	cMsg += '<b>Fornecedor: </b>'+SZ9->Z9_NFOR+'<br>'
	cMsg += '<b>CNPJ: </b>'+SZ9->Z9_CNPJ+'<br>'
	cMsg += '<b>Valor: </b>'+cValToChar(SZ9->Z9_VALORNF)+'<br>'
	cMsg += '<b>Dt emissão: </b>'+DTOC(SZ9->Z9_DTEMIS)+'<br>'
	cMsg += '<b>Status: </b>'+_cStatus+'<br>'
	cMsg += '<b>Cfop: </b>'+_cCfop+'<br><br>'

	cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
	cMsg += '<center><TR BgColor=#91b1c4><B><TD colspan="7">XML</TD><TD colspan="7">Steck</TD></TR></center>
	cMsg += '<TR BgColor=#91b1c4><B><TD>Item</TD><TD>Produto</TD><TD>EAN</TD><TD>Qtde</TD><TD>Preço</TD><TD>Icms</TD><TD>Outros (IPI+ST)</TD>
	cMsg += '<TD>Item</TD><TD>Produto</TD><TD>EAN</TD><TD>Qtde</TD><TD>Preço</TD><TD>Icms</TD><TD>Outros (IPI+ST)</TD>
	cMsg += '</B></TR>'

	_nLin := 0

	For _nX:=1 To Len(_aProds)

		//For _nY:=1 To Len(_aProdsEnc)
		//If AllTrim(_aProds[_nX][2])==AllTrim(_aProdsEnc[_nY][15])

		_nLin++

		If _aProds[_nX][Len(_aProds[_nX])]
			cMsg += '<TR BgColor=#ff7777>'
		Else
			cMsg += '<TR BgColor=#FFFFFF>'
		EndIf

		cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aProds[_nX][1] + ' </Font></TD>'
		cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aProds[_nX][2] + ' </Font></TD>'
		cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aProds[_nX][3] + ' </Font></TD>'
		cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aProds[_nX][4] + ' </Font></TD>'
		cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aProds[_nX][5] + ' </Font></TD>'
		cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + cValToChar(_aProds[_nX][6]) + ' </Font></TD>'
		cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + cValToChar(_aProds[_nX][7]+_aProds[_nX][8]) + ' </Font></TD>'

		If Len(_aProdsEnc)>=_nX
			cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aProdsEnc[_nX][1] + ' </Font></TD>'
			cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aProdsEnc[_nX][2] + ' </Font></TD>'
			cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aProdsEnc[_nX][3] + ' </Font></TD>'
			cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + cValToChar(_aProdsEnc[_nX][4]) + ' </Font></TD>'
			cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + cValToChar(_aProdsEnc[_nX][5]) + ' </Font></TD>'
			cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + cValToChar(_aProdsEnc[_nX][6]) + ' </Font></TD>'
			cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + cValToChar(_aProdsEnc[_nX][14]+_aProdsEnc[_nX][16]) + ' </Font></TD>'
		EndIf

		cMsg += '</TR>'

		//	Exit
		//EndIf

		//Next

	Next

	cMsg += '</Table>'
	cMsg += '</body></html>'

	U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,_cCaminho)

Return
