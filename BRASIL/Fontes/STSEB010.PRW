#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWMVCDEF.CH"

/*====================================================================================\
|Programa  | STSEB010        | Autor | RENATO.OLIVEIRA           | Data | 06/03/2020  |
|=====================================================================================|
|Descrição | Rotina para inserir os pedidos de venda da schneider                     |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Histórico | 20211005020970 - Ajuste para SFTP					                      |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STSEB010()

	Local oFTPHandle
	Local nX
	Local cCaminho
	Local cAviso 	 		:= ""
	Local cErro 	 		:= ""
	Local _cX		 		:= "00"
	Local _aProc			:= {}
	Local _cQuery1 			:= ""
	Local _cAlias1			:= ""
	Local _cTipoCli			:= ""
	Local _nY, _nX
	Local aFiles
	Local aSizes
	Private lMsErroAuto 	:= .F.

	RpcSetType( 3 )
	RpcSetEnv("01","05",,,"FAT")

	_cAlias1 := GetNextAlias()

	cServer 	:= GetMv("STSEB0101",,"10.152.4.36")
	nPorta  	:= GetMv("STSEB0102",,21)
	cUser   	:= GetMv("STSEB0103",,"steck-ftp")
	cPass		:= GetMv("STSEB0104",,"Br@s1l@2020")
	cCamSrv 	:= GetMv("STSEB0105",,"\arquivos\seb\quality\edi\po\")
	cCamFTP 	:= GetMv("STSEB0106",,"/seb/quality/edi/po/")
	cModArq 	:= GetMv("STSEB0107",,"Teste")

	cCamSrvPe := "\arquivos\SFTP-INTEGRAÇÕES\SCHNEIDER\INPUT\EDI-PEDIDOGUARAREMA\PENDING\"
	cCamSrvOk := "\arquivos\SFTP-INTEGRAÇÕES\SCHNEIDER\INPUT\EDI-PEDIDOGUARAREMA\PROCESSED\"
	
	ADir(cCamSrvPe+"*.*", aFiles, aSizes)

	ConOut("[STSEB010]["+ FWTimeStamp(2) +"] Início do processamento.")

	DbSelectArea("SB1")
	SB1->(DbSetOrder(1))

	If !LockByName("STSEB010",.F.,.F.,.T.)
		ConOut("[STSEB010]["+ FWTimeStamp(2) +"] - Já existe uma sessão em processamento.")
		Return()
	EndIf

	DbSelectArea("SA1")
	SA1->(DbSetOrder(1))

	DbSelectArea("DA1")
	DA1->(DbSetOrder(1)) //DA1_FILIAL+DA1_CODTAB+DA1_CODPRO+DA1_INDLOT+DA1_ITEM

	//aFiles := Directory(cCaminho+"pendentes\"+"*.*")
	For nX:=1 To Len(aFiles)

		_lErro := .F.
		aCabec := {}
		aSC6   := {}
		_cX	   := "00"

		aFiles[nX] := Lower(aFiles[nX])

		oXml := XmlParserFile(cCamSrvPe+aFiles[nX],"_",@cAviso,@cErro)

		If !SA1->(DbSeek(xFilial("SA1")+"012047"+"09"))
			ConOut("[STSEB010]["+ FWTimeStamp(2) +"]["+aFiles[nX]+"] - Cliente não encontrado!")
			Loop
		EndIf
		
		_cTipoCli := SA1->A1_TIPO

		If AllTrim(cModArq)=="Producao"
			_cOrdem := AllTrim(oXml:_ZLO_PO_AMOUNT_BR:_IDOC:_E1EDK01:_BELNR:TEXT)
		Else
			_cOrdem := AllTrim(oXml:_ORDERS05:_IDOC:_E1EDK01:_BELNR:TEXT)
		EndIf

		_cQuery1 := " SELECT C5_NUM
		_cQuery1 += " FROM "+RetSqlName("SC5")+" C5
		_cQuery1 += " WHERE C5.D_E_L_E_T_=' ' AND C5_FILIAL='"+cFilAnt+"'
		_cQuery1 += " AND C5_XORDEM='"+_cOrdem+"' AND SUBSTR(C5_NOTA,1,1)<>'X'

		If !Empty(Select(_cAlias1))
			DbSelectArea(_cAlias1)
			(_cAlias1)->(dbCloseArea())
		Endif

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

		dbSelectArea(_cAlias1)
		(_cAlias1)->(dbGoTop())

		If (_cAlias1)->(!Eof())
			AADD(_aProc,{aFiles[nX],"ERRO","OC "+_cOrdem+" já inserida no pedido "+(_cAlias1)->C5_NUM})
			__CopyFile(cCamSrvPe+aFiles[nX],cCamSrvOk+aFiles[nX])
			FERASE(cCamSrvPe+aFiles[nX])
			Loop
		EndIf

		_cCondPag := "511"

		aAdd(aCabec, {"C5_TIPO"		,"N"												,Nil}) // Tipo do Pedido
		aAdd(aCabec, {"C5_CLIENTE"	,SA1->A1_COD										,Nil}) // Codigo do Cliente
		aAdd(aCabec, {"C5_LOJACLI"	,SA1->A1_LOJA										,Nil}) // Loja do Cliente
		aAdd(aCabec, {"C5_TIPOCLI"	,_cTipoCli											,Nil}) // Tipo do Cliente
		aAdd(aCabec, {"C5_CONDPAG"	,_cCondPag											,Nil}) // Condicao de pagamanto
		aAdd(aCabec, {"C5_ZCONDPG"	,_cCondPag											,Nil}) // COND PG
		aAdd(aCabec, {"C5_TPFRETE"	,"C"												,Nil}) // Frete
		aAdd(aCabec, {"C5_TRANSP"	,"004064"											,Nil}) // Transportadora
		aAdd(aCabec, {"C5_XTIPO"	,"2"												,Nil}) // Moeda C5_XTIPO
		aAdd(aCabec, {"C5_XTIPF"	,"1"												,Nil}) // Moeda C5_XTIPO   C5_XTIPF
		aAdd(aCabec, {"C5_XORDEM"	,_cOrdem											,Nil})
		aAdd(aCabec, {"C5_XALTDT"	,"S"												,Nil})
		//aAdd(aCabec, {"C5_ZCONSUM"	,"1"												,Nil})

		If AllTrim(cModArq)=="Producao"
			_aItensObj := oXml:_ZLO_PO_AMOUNT_BR:_IDOC:_E1EDP01
		Else
			_aItensObj := oXml:_ORDERS05:_IDOC:_E1EDP01
		EndIf

		_cErro := "codigo;status"+CHR(13)+CHR(10)
		
		If Type("_aItensObj")=="O"

			_cItem 	:= ""
			_cProd 	:= ""
			_nQuant	:= 0
			_nPreco := 0
			_nTotal	:= 0
			_cX		:= Soma1(_cX)

			For _nY:=1 To Len(_aItensObj:_E1EDP02)
				If AllTrim(_aItensObj:_E1EDP02[_nY]:_QUALF:TEXT)=="001"
					_cItem := AllTrim(_aItensObj:_E1EDP02[_nY]:_ZEILE:TEXT)
				EndIf
			Next

			For _nY:=1 To Len(_aItensObj:_E1EDP19)
				If AllTrim(_aItensObj:_E1EDP19[_nY]:_QUALF:TEXT)=="001"
					_cProd := AllTrim(_aItensObj:_E1EDP19[_nY]:_IDTNR:TEXT)
				EndIf
			Next

			If !SB1->(DbSeek(xFilial("SB1")+_cProd))
				_lErro := .T.
				AADD(_aProc,{aFiles[nX],"ERRO","Produto nao encontrado: "+_cProd})
				_cErro += AllTrim(_cProd)+";Produto nao encontrado"+CHR(13)+CHR(10)
				Loop
			EndIf

			_nQuant := Val(_aItensObj:_E1EDP20:_WMENG:TEXT)

			If !DA1->(DbSeek(xFilial("DA1")+"GUA"+SB1->B1_COD))
			
				If AllTrim(cModArq)=="Producao"
					If Type("oXml:_ZLO_PO_AMOUNT_BR:_IDOC:_E1EDK01:_ZTOTALAMOUNT:_ZITEMAMOUNT")=="O"
						_nTotal := Val(oXml:_ZLO_PO_AMOUNT_BR:_IDOC:_E1EDK01:_ZTOTALAMOUNT:_ZITEMAMOUNT:_WO_IPI:TEXT)
					Else
						For _nY:=1 To Len(oXml:_ZLO_PO_AMOUNT_BR:_IDOC:_E1EDK01:_ZTOTALAMOUNT:_ZITEMAMOUNT)
							If AllTrim(oXml:_ZLO_PO_AMOUNT_BR:_IDOC:_E1EDK01:_ZTOTALAMOUNT:_ZITEMAMOUNT[_nY]:_ITEM:TEXT)==AllTrim(_cItem)
								_nTotal := Val(oXml:_ZLO_PO_AMOUNT_BR:_IDOC:_E1EDK01:_ZTOTALAMOUNT:_ZITEMAMOUNT[_nY]:_WO_IPI:TEXT)
							EndIf
						Next
					EndIf
				Else
					For _nY:=1 To Len(oXml:_ORDERS05:_IDOC:_E1EDK01:_ZTOTALAMOUNT:_ZITEMAMOUNT)
						If AllTrim(oXml:_ORDERS05:_IDOC:_E1EDK01:_ZTOTALAMOUNT:_ZITEMAMOUNT[_nY]:_ITEM:TEXT)==AllTrim(_cItem)
							_nTotal := Val(oXml:_ORDERS05:_IDOC:_E1EDK01:_ZTOTALAMOUNT:_ZITEMAMOUNT[_nY]:_WO_IPI:TEXT)
						EndIf
					Next
				EndIf

				_nPreco := NoRound(_nTotal/_nQuant,2)
				_nTotal := Round(_nQuant*_nPreco,2)

				_cEmail   := GetMv("STSEB0109",,"renato.oliveira@steck.com.br;reinaldo.franca@steck.com.br")
				_cCopia	  := ""
				_cAssunto := "[WFPROTHEUS] - Item "+AllTrim(SB1->B1_COD)+" sem preço na tabela GUA"
				_aAttach  := {}
				_cCaminho := ""
				_cMsg 	  := ""

				U_STMAILTES(_cEmail, _cCopia, _cAssunto, _cMsg,_aAttach,_cCaminho)

			Else

				_nPreco := DA1->DA1_PRCVEN
				_nTotal := Round(_nQuant*_nPreco,2)

			EndIf

			cTesPad := U_STRETSST('01',SA1->A1_COD,SA1->A1_LOJA,SB1->B1_COD,_cCondPag,'TES',.F.,_cTipoCli,"")

			Aadd(aSC6 ,{{"C6_ITEM"		,_cX			        ,Nil},;
			{"C6_PRODUTO"				,SB1->B1_COD		    ,Nil},;
			{"C6_QTDVEN"				,_nQuant				,Nil},;
			{"C6_PRCVEN"				,_nPreco				,Nil},;
			{"C6_PRUNIT"				,_nPreco				,Nil},;
			{"C6_TOTAL"					,_nTotal				,Nil},;
			{"C6_LOCAL"					,SB1->B1_LOCPAD			,Nil},;
			{"C6_OPER"					,"01"					,Nil},;
			{"C6_XALTDT"				,"S"					,Nil},;
			{"C6_NUMPCOM"				,_cOrdem				,Nil},;
			{"C6_ITEMPC"				,_cItem					,Nil},;
			{"C6_TES"					,cTesPad				,Nil}})

		Else
		
			For _nX:=1 To Len(_aItensObj)

			_cItem 	:= ""
			_cProd 	:= ""
			_nQuant	:= 0
			_nPreco := 0
			_nTotal	:= 0
			_cX		:= Soma1(_cX)

				For _nY:=1 To Len(_aItensObj[_nY]:_E1EDP02)
					If AllTrim(_aItensObj[_nX]:_E1EDP02[_nY]:_QUALF:TEXT)=="001"
					_cItem := AllTrim(_aItensObj[_nX]:_E1EDP02[_nY]:_ZEILE:TEXT)
					EndIf
				Next

				For _nY:=1 To Len(_aItensObj[_nX]:_E1EDP19)
					If AllTrim(_aItensObj[_nX]:_E1EDP19[_nY]:_QUALF:TEXT)=="001"
					_cProd := AllTrim(_aItensObj[_nX]:_E1EDP19[_nY]:_IDTNR:TEXT)
					EndIf
				Next

				If !SB1->(DbSeek(xFilial("SB1")+_cProd))
				_lErro := .T.
				AADD(_aProc,{aFiles[nX],"ERRO","Produto nao encontrado: "+_cProd})
				_cErro += AllTrim(_cProd)+";Produto nao encontrado"+CHR(13)+CHR(10)
				Loop
				EndIf

				_nQuant := Val(_aItensObj[_nX]:_E1EDP20:_WMENG:TEXT)

				If !DA1->(DbSeek(xFilial("DA1")+"GUA"+SB1->B1_COD))
			
					If AllTrim(cModArq)=="Producao"
						If Type("oXml:_ZLO_PO_AMOUNT_BR:_IDOC:_E1EDK01:_ZTOTALAMOUNT:_ZITEMAMOUNT")=="O"
							_nTotal := Val(oXml:_ZLO_PO_AMOUNT_BR:_IDOC:_E1EDK01:_ZTOTALAMOUNT:_ZITEMAMOUNT:_WO_IPI:TEXT)
						Else
							For _nY:=1 To Len(oXml:_ZLO_PO_AMOUNT_BR:_IDOC:_E1EDK01:_ZTOTALAMOUNT:_ZITEMAMOUNT)
								If AllTrim(oXml:_ZLO_PO_AMOUNT_BR:_IDOC:_E1EDK01:_ZTOTALAMOUNT:_ZITEMAMOUNT[_nY]:_ITEM:TEXT)==AllTrim(_cItem)
									_nTotal := Val(oXml:_ZLO_PO_AMOUNT_BR:_IDOC:_E1EDK01:_ZTOTALAMOUNT:_ZITEMAMOUNT[_nY]:_WO_IPI:TEXT)
								EndIf
							Next
						EndIf
					Else
						For _nY:=1 To Len(oXml:_ORDERS05:_IDOC:_E1EDK01:_ZTOTALAMOUNT:_ZITEMAMOUNT)
							If AllTrim(oXml:_ORDERS05:_IDOC:_E1EDK01:_ZTOTALAMOUNT:_ZITEMAMOUNT[_nY]:_ITEM:TEXT)==AllTrim(_cItem)
								_nTotal := Val(oXml:_ORDERS05:_IDOC:_E1EDK01:_ZTOTALAMOUNT:_ZITEMAMOUNT[_nY]:_WO_IPI:TEXT)
							EndIf
						Next
					EndIf

				_nPreco := NoRound(_nTotal/_nQuant,2)
				_nTotal := Round(_nQuant*_nPreco,2)

				_cEmail   := GetMv("STSEB0109",,"renato.oliveira@steck.com.br;reinaldo.franca@steck.com.br")
				_cCopia	  := ""
				_cAssunto := "[WFPROTHEUS] - Item "+AllTrim(SB1->B1_COD)+" sem preço na tabela GUA"
				_aAttach  := {}
				_cCaminho := ""
				_cMsg 	  := ""

				U_STMAILTES(_cEmail, _cCopia, _cAssunto, _cMsg,_aAttach,_cCaminho)

				Else

				_nPreco := DA1->DA1_PRCVEN
				_nTotal := Round(_nQuant*_nPreco,2)

				EndIf

			cTesPad := U_STRETSST('01',SA1->A1_COD,SA1->A1_LOJA,SB1->B1_COD,_cCondPag,'TES',.F.,_cTipoCli,"")

			Aadd(aSC6 ,{{"C6_ITEM"		,_cX			        ,Nil},;
			{"C6_PRODUTO"				,SB1->B1_COD		    ,Nil},;
			{"C6_QTDVEN"				,_nQuant				,Nil},;
			{"C6_PRCVEN"				,_nPreco				,Nil},;
			{"C6_PRUNIT"				,_nPreco				,Nil},;
			{"C6_TOTAL"					,_nTotal				,Nil},;
			{"C6_LOCAL"					,SB1->B1_LOCPAD			,Nil},;
			{"C6_OPER"					,"01"					,Nil},;
			{"C6_XALTDT"				,"S"					,Nil},;
			{"C6_NUMPCOM"				,_cOrdem				,Nil},;
			{"C6_ITEMPC"				,_cItem					,Nil},;
			{"C6_TES"					,cTesPad				,Nil}})

			Next

		EndIf

		_lErro := .F. //Vai processar parcial mesmo se nao encontrar a referencia

		If !_lErro

			lMsErroAuto := .F.

			If Len(aSC6)>0
				ConOut("[STSEB010]["+ FWTimeStamp(2) +"] Inserindo ordem de compra "+_cOrdem)
				MsExecAuto({|x, y, z| MATA410(x, y, z)}, aCabec, aSC6,3)
				ConOut("[STSEB010]["+ FWTimeStamp(2) +"] Finalizada ordem de compra "+_cOrdem)
			EndIf

			aCabec := {}
			aSc6   := {}

			If lMsErroAuto
				_cErro := MostraErro("arquivos\logs",dtos(date())+time()+".log")
				AADD(_aProc,{aFiles[nX],"ERRO",_cErro})
				ConOut("[STSEB010]["+ FWTimeStamp(2) +"] Erro na ordem de compra "+_cOrdem)
			Else
				__CopyFile(cCamSrvPe+aFiles[nX],cCamSrvOk+aFiles[nX])
				FERASE(cCamSrvPe+aFiles[nX])
				AADD(_aProc,{aFiles[nX],"OK","Pedido inserido com sucesso: "+SC5->C5_NUM})
				ConOut("[STSEB010]["+ FWTimeStamp(2) +"] Ordem de compra inserida "+_cOrdem)
			EndIf

		EndIf

	Next

	cMsg := ""
	cMsg += '<html><head><title>'+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title></head><body>'
	cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>
	cMsg += '<TR BgColor=#FFFFFF>
	cMsg += '<TD><B><Font Color="black" Size="3" Face="Arial">Arquivo</Font></B></TD>
	cMsg += '<TD><B><Font Color="black" Size="3" Face="Arial">Status</Font></B></TD>
	cMsg += '<TD><B><Font Color="black" Size="3" Face="Arial">Observação</Font></B></TD>
	cMsg += '</TR>

	For _nX:=1 To Len(_aProc)

		_cColor := "white"

		If AllTrim(_aProc[_nX][2])=="ERRO"
			cMsg += '<TR BgColor=#FF0000>
			_cColor := "white"
		Else
			cMsg += '<TR BgColor=#00FF00>
			_cColor := "black"
		EndIf

		cMsg += '<TD><B><Font Color="'+_cColor+'" Size="3" Face="Arial">'+AllTrim(_aProc[_nX][1])+'</Font></B></TD>
		cMsg += '<TD><B><Font Color="'+_cColor+'" Size="3" Face="Arial">'+AllTrim(_aProc[_nX][2])+'</Font></B></TD>
		cMsg += '<TD><B><Font Color="'+_cColor+'" Size="3" Face="Arial">'+AllTrim(_aProc[_nX][3])+'</Font></B></TD>
		cMsg += '</TR>

	Next

	cMsg += '</body></html>'

	_cEmail := GetMv("STSEB0108",,"renato.oliveira@steck.com.br")

	If Len(_aProc)>0
		U_STMAILTES(_cEmail,"","[WFPROTHEUS] - Resumo de processamento pedidos SEB",cMsg,{},"")
	EndIf

	UnLockByName("STSEB010",.F.,.F.,.T.)

	ConOut("[STSEB010]["+ FWTimeStamp(2) +"] Fim do processamento.")

Return()
