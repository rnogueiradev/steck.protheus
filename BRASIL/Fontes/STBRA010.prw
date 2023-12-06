#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

/*====================================================================================\
|Programa  | STBRA010        | Autor | Renato Nogueira            | Data | 15/10/2018 |
|=====================================================================================|
|Adaptado  | Por: Flávia Rocha                                                        |
|=====================================================================================|
|Sintaxe   | 			                                                              |
|=====================================================================================|
|Uso       | Especifico Steck                                                      	  |
|=====================================================================================|
|........................................Histórico....................................|
|22/06/2021 - FR - Atendimento ao Ticket #20210621010461                              |
|             Adaptação para uso na integração transportadora Braspress               |
\====================================================================================*/

User Function STBRA010()

	Local _cQuery3 		:= ""
	Local _cAlias3 		:= ""
	Local _cRomaneio    := ""
	Local _nX
	Private _cArquivo 	:= ""
	Private _cRemetente	:= "STECK"
	//Private _cDestinat	:= "TNT"
	Private _cDestinat	:= "BRASPRESS"		//FR - 22/06/2021 - Ticket: #20210621010461
	Private _dData		:= Date()
	Private _cData		:= SubStr(DTOS(_dData),7,2)+SubStr(DTOS(_dData),5,2)+SubStr(DTOS(_dData),3,2)
	Private _cData2		:= SubStr(DTOS(_dData),7,2)+SubStr(DTOS(_dData),5,2)+SubStr(DTOS(_dData),1,4)
	Private _cHora		:= SubStr(StrTran(Time(),":",""),1,4)
	Private _nTotalNfs	:= 0
	Private _nPesoNfs	:= 0
	Private _nDensTot	:= 0
	Private _nVolumes	:= 0
	Private _nValCob	:= 0
	Private _nSeguro	:= 0
	Private nPorta 		:= 21
	Private _aNotas		:= {}
	Private _lRet		:= .T.
	Private lEtiqueta   := .F.
	Private cDirDestP   := ""
	Private cDirDestE   := ""
	Private cDirDestEr   := ""
	Private cDir		:= ""
//	Private lFora  		:= .F.
	Private cServer		:= ""//GetMv("ST_FTPSRBRA",,"ftp.braspress.com.br")
	Private	cUser		:= ""//GetMv("ST_FTPUSVRA",,"steck")
	Private	cPass		:= ""//GetMv("ST_FTPPSWBR",,"AFdMoBcjC")
	Private nPorta 		:= 21
	
	//ConOut("[STTNT010]["+ FWTimeStamp(2) +"] - Iniciando processamento.")
	ConOut("[STBRA010]["+ FWTimeStamp(2) +"] - Iniciando processamento.")

	If IsBlind()
		PREPARE ENVIRONMENT EMPRESA '11' FILIAL '01'
		ConOut("[STBRA010]["+ FWTimeStamp(2) +"] - IsBlind.")
	//	lFora := .T.
	EndIf

	If Select( 'SX2' ) == 0
		PREPARE ENVIRONMENT EMPRESA '11' FILIAL '01'
		//PREPARE ENVIRONMENT EMPRESA '01' FILIAL '02'
		ConOut("[STBRA010]["+ FWTimeStamp(2) +"] - Select.")
		sleep( 5000 )
	//	lFora := .T.		
	EndIf
	//teste:= Iif(lFora,"Verdadeiro","Falso")
	//;ConOut("[STBRA010]["+ FWTimeStamp(2) +"] - lFora:="+teste)

	//If lFora
		cDir    := GetNewPar("ST_NFSBRAP", "\arquivos\INTEG_BRAS\NFS\")

	If !ExistDir(cDir)
			Makedir(cDir)
	EndIf

		cDirDestP := cDir + "PENDING\"
		//cDirDestE := cDir + "SEND\"
		cDirDestEr := cDir + "Erro\"

	If !ExistDir(cDirDestP)
			Makedir(cDirDestP)
	EndIf

	If !ExistDir(cDirDestE)
			Makedir(cDirDestE)
	EndIf

	If !ExistDir(cDirDestEr)
			Makedir(cDirDestEr)
	EndIf

		lEtiqueta := GetNewPar("ST_NEWBRA", .T.)
	If !lEtiqueta
			Return
	EndIf

		_cAlias3 		:= GetNextAlias()

		//Verificar se arquivos foram processados, tirar da fila de envio e gravar tabela PD1
		aDados := {}

		ConOut("[STBRA010]["+ FWTimeStamp(2) +"] - Antes de Montar o Arquivo")
		aDados := fMontaCSV()		//monta array dos romaneios para depois gravar data envio
		ConOut("[STBRA010]["+ FWTimeStamp(2) +"] - Depois de MOntar o Arquivo")
		DbSelectArea("PD1")
		PD1->(DbSetOrder(1))

	For _nX:=1 To Len(aDados)
			cRomProc := StrTran(AllTrim(aDados[_nX][1]),chr(13))
			cArquivo := cDirDestP+"NOTFIS_"+StrTran(AllTrim(aDados[_nX][1])+".TXT",chr(13))
			//cDestino := cDirDestE+"NOTFIS_"+StrTran(AllTrim(aDados[_nX][1])+".TXT",chr(13))
			/*
			cServer	:= GetMv("ST_FTPSRBRA",,"ftp.braspress.com.br")
			cUser	:= GetMv("ST_FTPUSVRA",,"steck")
			cPass	:= GetMv("ST_FTPPSWBR",,"AFdMoBcjC")

			oFTPHandle := tFtpClient():New()
			oFTPHandle:nTransferType := 0
			nRet := oFTPHandle:FTPConnect(cServer,nPorta,cUser,cPass)
			nRet := oFTPHandle:ChDir("/NOTFIS")
			nRet := oFTPHandle:SendFile(cArquivo,"NOTFIS_"+StrTran(AllTrim(aDados[_nX][1])+".TXT",chr(13)))
			oFTPHandle:Close()
			*/
		//If nRet = 0
				ConOut("[STBRA010]["+ FWTimeStamp(2) +"] - Arquivo enviado para FTP BrasPress.")
		//	If __CopyFile(cArquivo,cDestino)
		//		If FERASE(cArquivo)==-1

		//		Else
					If PD1->(DbSeek(xFilial("PD1")+cRomProc))
							PD1->(RecLock("PD1",.F.))
							PD1->PD1_XDENVT := Date()
							PD1->PD1_XHENVT := Time()
							PD1->(MsUnLock())
					EndIf
					ConOut("[STBRA010]["+ FWTimeStamp(2) +"] - Status Atualizado.")
		//		EndIf
		//	EndIf
		/*	
		else
				cDestinoEr := cDirDestEr+"NOTFIS_"+StrTran(AllTrim(aDados[_nX][1])+".TXT",chr(13))
				ConOut("[STBRA010]["+ FWTimeStamp(2) +"] - Arquivo não enviado para FTP.")
			If __CopyFile(cArquivo,cDestinoEr)
				If FERASE(cArquivo)==-1
						Conout("")

				EndIf
			EndIf
		EndIf
		*/
	Next

//Endif

Return


/*====================================================================================\
|Programa  | fMontaCSV       | Adaptado por | Flávia Rocha        | Data | 06/06/2021 |
|=====================================================================================|
|Descrição | Monta o arquivo csv com as informações do romaneio e nf                  |
|=====================================================================================|
|Sintaxe   | 			                                                              |
|=====================================================================================|
|Uso       | Especifico Steck                                                      	  |
|=====================================================================================|
|........................................Histórico....................................|
| Flávia Rocha - Atendimento ao Ticket #20210528008865                                |
\====================================================================================*/
Static Function fMontaCSV()
Local aRet 		:= {}
Local _cQuery3 	:= ""
Local cDir		:= ""
Local _cArq		:= ""
Local _cAux		:= ""
lOCAL _cAlias3  := "QRY"
Local lCopiou	:= .F.

_cQuery3 := " SELECT PD1.R_E_C_N_O_ RECPD1
_cQuery3 += " FROM "+RetSqlName("PD1")+" PD1
_cQuery3 += " WHERE PD1.D_E_L_E_T_=' ' AND PD1_FILIAL='"+xFilial("PD1")+"'
//_cQuery3 += " AND PD1_PLACA='TNT'
_cQuery3 += " AND PD1_PLACA='BRASPRES' " 		//FR - 22/06/2021

	If IsBlind() //lFora
	_cQuery3 += " AND PD1_XDENVT=' ' AND PD1_STATUS IN ('2','3')
	Else
	_cQuery3 += " AND PD1_CODROM='"+PD1->PD1_CODROM+"'
	EndIf
MemoWrite("C:\TEMP\SELPD1.SQL" , _cQuery3)

	If !Empty(Select(_cAlias3))
	DbSelectArea(_cAlias3)
	(_cAlias3)->(dbCloseArea())
	Endif

dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery3),_cAlias3,.T.,.T.)

dbSelectArea(_cAlias3)
(_cAlias3)->(dbGoTop())

	While (_cAlias3)->(!Eof())

	PD1->(DbGoTo((_cAlias3)->RECPD1))

	//cDir	:= SuperGetMv("ST_NFSTNT",.F.,"\arquivos\INTEG_TNT\NFS\")
	cDir	:= SuperGetMv("ST_NFSBRAP",.F.,"\arquivos\INTEG_BRAS\NFS\")
	//cDir    += "NFS\"

		If !ExistDir(cDir)
		Makedir(cDir)
		EndIf

	//Bloco 000
	_cArquivo := "000"
	_cArquivo += PADR(_cRemetente,35)
	_cArquivo += PADR(_cDestinat,35)
	_cArquivo += _cData
	_cArquivo += _cHora
	_cArquivo += "NOT"+SubStr(_cData,1,4)+_cHora+"S"
	_cArquivo += Space(145)
	_cArquivo += CHR(13)+CHR(10)

	//Bloco 310
	_cArquivo += "310"
	_cArquivo += "NOTFI"+SubStr(_cData,1,4)+_cHora+"S"
	_cArquivo += Space(223)
	_cArquivo += CHR(13)+CHR(10)

	//Bloco 311
	_cArquivo += "311" //1
	_cArquivo += PADR(SM0->M0_CGC,14) //4
	_cArquivo += PADR(SM0->M0_INSC,15) //18
	_cArquivo += PADR(SM0->M0_ENDCOB,40) //33
	_cArquivo += PADR(SM0->M0_CIDCOB,35) //73
	_cArquivo += PADR(SM0->M0_CEPCOB,9) //108
	_cArquivo += PADR(SM0->M0_ESTCOB,9) //117
	_cArquivo += PADR(_cData2,8) //126
	_cArquivo += PADR(SM0->M0_NOME,40) //134
	_cArquivo += Space(67) //174
	_cArquivo += CHR(13)+CHR(10)

	//MONTANFS()
	_cAux := MONTANFS(PD1->PD1_CODROM)
	_cArquivo += _cAux 

	//Bloco 318
	_cArquivo += "318"
	_cArquivo += AJUSTANUM(_nTotalNfs,13,2)
	_cArquivo += AJUSTANUM(_nPesoNfs,13,2)
	_cArquivo += AJUSTANUM(_nDensTot,13,2)
	_cArquivo += AJUSTANUM(_nVolumes,13,2)
	_cArquivo += AJUSTANUM(_nValCob,13,2)
	_cArquivo += AJUSTANUM(_nSeguro,13,2)
	_cArquivo += Space(147)
	_cArquivo += CHR(13)+CHR(10)
	
	_cArquivo := EncodeUtf8(_cArquivo)		//FR - 22/06/2021 - decodifica o arquivo

	_cArq  := "NOTFIS_"+PD1->PD1_CODROM+".TXT"

		If !Empty(_cArquivo)

		Aadd(aRet, { PD1->PD1_CODROM, _cArq } )		//adiciona o número do romaneio, //adiciona o nome do arquivo

			If  IsBlind() //lFora
			_cFile := cDir+"PENDING\"+_cArq
			Else
			_cFile := cGetFile(,"Selecione o diretorio",,"",.T.,GETF_LOCALFLOPPY+GETF_LOCALHARD+128)+_cArq
			EndIf

			If File(_cFile)
			FErase(_cFile)
			EndIf

		nHdlXml   := FCreate(_cFile,0)

			If nHdlXml > 0
				
			FWrite(nHdlXml,_cArquivo)
			FClose(nHdlXml)

				If IsBlind() //lFora

				//_cEmail 	:= GetMv("STTNT0101",,"edi@tntbrasil.com.br;francisco.smania@steck.com.br;kleber.braga@steck.com.br;renato.oliveira@steck.com.br")
				_cEmail 	:= GetNewPar("ST_BRAMAIL","francisco.smania@steck.com.br;kleber.braga@steck.com.br;renato.oliveira@steck.com.br") //FR - 22/06/2021
				//_cEmail  	:= "flah.rocha@sigamat.com.br"	//TESTE RETIRAR
				_cCopia 	:= ""
				_cAssunto	:= "[WFPROTHEUS] - Envio de arquivo NOTFIS "+AllTrim(PD1->PD1_CODROM)
				cMsg 		:= ""
				_aAttach	:= {}

				aadd(_aAttach,cDir+"PENDING\"+_cArq)
				//aadd(_aAttach,cDir+"SEND\"+_cArq)

				U_STMAILTES(_cEmail,_cCopia,_cAssunto,cMsg,_aAttach)
				
				/*
				lCopiou := CpyS2T( cStartPath + _cArq, cDirDestP )		//copia da máquina local em que gravou para o \system\
					If !lCopiou
					lCopiou := CpyT2S( cDirDestP + _cArq, cStartPath )
					Endif

				cAnexo      := cStartPath + _cArq
							
				lEnviou := U_FRSendMail(_cEmail, _cCopia, _cAssunto, cMsg, cAnexo)
					If lEnviou
					//MsgAlert("OK EMAIL")
					Else
					//MsgAlert("ERRO EMAIL")
					Endif
				*/

				EndIf

			Endif
		Endif

		(_cAlias3)->(DbSkip())
	EndDo

	//ConOut("[STTNT010]["+ FWTimeStamp(2) +"] - Processamento finalizado.")
	ConOut("[STBRA010]["+ FWTimeStamp(2) +"] - Processamento finalizado.")

//Return(_lRet)
Return(aRet)

/*====================================================================================\
|Programa  | MONTANFS         | Autor | Renato Nogueira            | Data | 26/01/2017|
|=====================================================================================|
|Descrição | Monta blocos de notas  					                              |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 			                                                              |
|=====================================================================================|
|Uso       | Especifico Steck                                                      |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

Static Function MONTANFS(_cRomaneio)

	Local _cQuery  		:= ""
	Local _cAlias  		:= GetNextAlias()
	Local _cQuery1 		:= ""
	Local _cAlias1 		:= GetNextAlias()
	Local _cQuery2 		:= ""
	Local _cAlias2 		:= GetNextAlias()
	Local _cOs			:= ""
	Local _cArquivo     := ""
	Local _cCodBraspres := Alltrim(GetNewPar("ST_BRACODT","004064")) 

	_cQuery := " SELECT A1_NOME, A1_CGC, A1_INSCR, A1_END, A1_COMPLEM, A1_BAIRRO, A1_MUN, A1_CEP, A1_COD_MUN, A1_EST, A1_TEL,"+CRLF
	_cQuery += " F2_SERIE, F2_DOC, F2_EMISSAO, F2_ESPECI1, F2_VOLUME1,"+CRLF
	_cQuery += " F2_VALBRUT, F2_PBRUTO, F2_PLIQUI, F2_VALICM, F2_SEGURO, D2_PEDIDO,"+CRLF
	_cQuery += " F2_FRETE,F2_CHVNFE,F2_ICMSRET,A1_PESSOA, F2.R_E_C_N_O_ RECSF2, A1_COD, A1_LOJA, F2_TPFRETE"+CRLF
	_cQuery += " FROM "+RetSqlName("PD1")+" PD1 "+CRLF
	_cQuery += " LEFT JOIN "+RetSqlName("PD2")+" PD2 "+CRLF
	_cQuery += " ON PD1_FILIAL=PD2_FILIAL AND PD1_CODROM=PD2_CODROM "+CRLF
	_cQuery += " LEFT JOIN "+RetSqlName("SF2")+" F2 "+CRLF
	_cQuery += " ON PD2_FILIAL=F2_FILIAL AND PD2_NFS=F2_DOC AND PD2_SERIES=F2_SERIE AND PD2_CLIENT=F2_CLIENTE AND PD2_LOJCLI=F2_LOJA "+CRLF
	_cQuery += " LEFT JOIN "+RetSqlName("SA1")+" A1 "+CRLF
	_cQuery += " ON A1_COD=F2_CLIENTE AND A1_LOJA=F2_LOJA "+CRLF
	_cQuery += " LEFT JOIN "+RetSqlName("SD2")+" D2 "+CRLF
	_cQuery += " ON D2_FILIAL=F2_FILIAL AND D2_DOC=F2_DOC AND D2_SERIE=F2_SERIE AND D2_CLIENTE=F2_CLIENTE AND D2_LOJA=F2_LOJA "+CRLF
	_cQuery += " WHERE A1.D_E_L_E_T_=' ' AND F2.D_E_L_E_T_=' ' AND D2.D_E_L_E_T_=' ' "+CRLF
	//_cQuery += " AND F2_TRANSP='000163' "  +CRLF//TESTE RETIRAR TNT
	_cQuery += " AND F2_TRANSP = '"+ _cCodBraspres +"' " //VOLTAR BRASPRESS
	_cQuery += " AND F2_CHVNFE<>' ' "+CRLF
	_cQuery += " AND PD1_FILIAL='"+xFilial("PD1")+"' AND PD1_CODROM='"+PD1->PD1_CODROM+"' " +CRLF
	_cQuery += " GROUP BY A1_NOME, A1_CGC, A1_INSCR, A1_END, A1_COMPLEM, A1_BAIRRO, A1_MUN, A1_CEP, A1_COD_MUN, A1_EST, A1_TEL, F2_SERIE, F2_DOC, F2_EMISSAO, F2_ESPECI1, F2_VOLUME1, "+CRLF
	_cQuery += " F2_VALBRUT, F2_PBRUTO, F2_PLIQUI, F2_VALICM, F2_SEGURO, F2_FRETE,F2_CHVNFE,F2_ICMSRET,A1_PESSOA, F2.R_E_C_N_O_, D2_PEDIDO, A1_COD, A1_LOJA, F2_TPFRETE "+CRLF

	MemoWrite("C:\TEMP\SELNFS.SQL", _cQuery)

	If !Empty(Select(_cAlias))
		DbSelectArea(_cAlias)
		(_cAlias)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cAlias,.T.,.T.)

	dbSelectArea(_cAlias)

	(_cAlias)->(dbGoTop())

	If (_cAlias)->(Eof())
		_lRet := .F.
	EndIf

	DbSelectArea("SC5")
	SC5->(DbSetOrder(1))

	DbSelectArea("SA1")
	SA1->(DbSetOrder(1))

	DbSelectArea("CC2")
	CC2->(DbSetOrder(4))

	While (_cAlias)->(!Eof())

		SC5->(DbSeek(xFilial("SC5")+(_cAlias)->D2_PEDIDO))

		//_aEndEnt := U_STTNT011()
		_aEndEnt := U_STBRA011()

		//Bloco 312
		_cArquivo += "312"
		_cArquivo += PADR(AllTrim((_cAlias)->A1_NOME),40)
		_cArquivo += PADL(AllTrim((_cAlias)->A1_CGC),14,"0")
		_cArquivo += PADR(AllTrim((_cAlias)->A1_INSCR),15)

		_cArquivo += SubStr((_cAlias)->A1_END,1,40)
		_cArquivo += PADR(AllTrim((_cAlias)->A1_BAIRRO),20)
		_cArquivo += PADR(AllTrim((_cAlias)->A1_MUN),35)
		_cArquivo += PADR(AllTrim((_cAlias)->A1_CEP),9)
		_cArquivo += PADR(AllTrim((_cAlias)->A1_COD_MUN),9)
		_cArquivo += PADR(AllTrim((_cAlias)->A1_EST),9)

		_cArquivo += Space(4)
		_cArquivo += PADR(AllTrim((_cAlias)->A1_TEL),35)
		_cArquivo += Space(7)
		_cArquivo += CHR(13)+CHR(10)

		//Bloco 313
		_cArquivo += "313"
		_cArquivo += Space(15)
		_cArquivo += Space(7)
		_cArquivo += "1" //Rodoviario
		_cArquivo += "1" //Carga fechada
		_cArquivo += "2" //Seca
		_cArquivo += AllTrim((_cAlias)->F2_TPFRETE) //CIF
		_cArquivo += PADR(AllTrim((_cAlias)->F2_SERIE),3)
		_cArquivo += SubStr(AllTrim((_cAlias)->F2_DOC),2,8)
		_cArquivo += SubStr((_cAlias)->F2_EMISSAO,7,2)+SubStr((_cAlias)->F2_EMISSAO,5,2)+SubStr((_cAlias)->F2_EMISSAO,1,4)
		_cArquivo += PADR("MAT ELETRICOS",15)
		_cArquivo += PADR((_cAlias)->F2_ESPECI1,15)
		_cArquivo += AJUSTANUM((_cAlias)->F2_VOLUME1,5,2)
		_cArquivo += AJUSTANUM((_cAlias)->F2_VALBRUT,13,2)
		_cArquivo += AJUSTANUM((_cAlias)->F2_PBRUTO,5,2)
		_cArquivo += AJUSTANUM((_cAlias)->F2_PLIQUI,3,2)
		_cArquivo += IIf((_cAlias)->F2_VALICM>0,"S","N")
		_cArquivo += IIf((_cAlias)->F2_SEGURO>0,"S","N")
		_cArquivo += AJUSTANUM((_cAlias)->F2_SEGURO,13,2)
		_cArquivo += PADR("0",15)
		_cArquivo += Space(7)
		_cArquivo += "N"
		_cArquivo += AJUSTANUM((_cAlias)->F2_FRETE,13,2)
		_cArquivo += PADR("0",15)
		_cArquivo += PADR("0",15)
		_cArquivo += AJUSTANUM((_cAlias)->F2_FRETE,13,2)
		_cArquivo += "I"
		_cArquivo += PADL((_cAlias)->D2_PEDIDO,10,"0")
		_cArquivo += Space(15)
		_cArquivo += (_cAlias)->F2_CHVNFE
		_cArquivo += CHR(13)+CHR(10)

		_nTotalNfs 	+= (_cAlias)->F2_VALBRUT
		_nPesoNfs	+= (_cAlias)->F2_PBRUTO
		_nVolumes	+= (_cAlias)->F2_VOLUME1
		_nSeguro	+= (_cAlias)->F2_SEGURO

		_cQuery2 := " SELECT DISTINCT CB6_XTNT,CB6_XORDSE "			+CRLF
		_cQuery2 += " FROM "+RetSqlName("CB7")+" CB7 "		+CRLF
		_cQuery2 += " LEFT JOIN "+RetSqlName("CB6")+" CB6 "	+CRLF
		_cQuery2 += " ON CB7_FILIAL=CB6_FILIAL "			+CRLF
		_cQuery2 += " AND CB7_ORDSEP=CB6_XORDSE "			+CRLF
		_cQuery2 += " WHERE CB7.D_E_L_E_T_=' ' "			+CRLF
		_cQuery2 += " AND CB6.D_E_L_E_T_=' ' " 				+CRLF
		_cQuery2 += " AND CB7.CB7_FILIAL='"+xFilial("PD1")+"' AND CB7_NOTA='"+(_cAlias)->F2_DOC+"' AND CB7_SERIE='"+(_cAlias)->F2_SERIE+"'" 	+CRLF
		_cQuery2 += " AND CB7_PEDIDO='"+(_cAlias)->D2_PEDIDO+"' AND CB7_CLIENT='"+(_cAlias)->A1_COD+"' AND CB7_LOJA='"+(_cAlias)->A1_LOJA+"'"	+CRLF
	
		If !Empty(Select(_cAlias2))
			DbSelectArea(_cAlias2)
			(_cAlias2)->(dbCloseArea())
		Endif

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery2),_cAlias2,.T.,.T.)

		dbSelectArea(_cAlias2)

		(_cAlias2)->(dbGoTop())

		_cOs := ""

		While (_cAlias2)->(!Eof())

			//Bloco 314
			_cArquivo += "314"
			_cArquivo += AllTrim((_cAlias2)->CB6_XTNT)
			_cArquivo += CHR(13)+CHR(10)

			_cOs := AllTrim((_cAlias2)->CB6_XORDSE)

			(_cAlias2)->(DbSkip())
		EndDo

		//Bloco 315
		_cArquivo += "315"

		If _aEndEnt[1][7]

			_cArquivo += PADR(AllTrim((_cAlias)->A1_NOME),40)
			_cArquivo += PADL(AllTrim((_cAlias)->A1_CGC),14,"0")
			_cArquivo += PADR(AllTrim((_cAlias)->A1_INSCR),15)

			_cArquivo += SubStr(_aEndEnt[1][2],1,40)
			_cArquivo += PADR(AllTrim(_aEndEnt[1][3]),20)
			_cArquivo += PADR(AllTrim(_aEndEnt[1][5]),35)
			_cArquivo += PADR(AllTrim(_aEndEnt[1][1]),9)
			_cArquivo += PADR(AllTrim(_aEndEnt[1][4]),9)
			_cArquivo += PADR(AllTrim(_aEndEnt[1][6]),9)

			_cArquivo += Space(4)
			_cArquivo += PADR(AllTrim((_cAlias)->A1_TEL),35)
			_cArquivo += Space(7)

		EndIf

		_cArquivo += CHR(13)+CHR(10)

		//Bloco 317
		_cArquivo += "317"
		_cArquivo += PADR(SM0->M0_NOME,40)
		_cArquivo += PADR(SM0->M0_CGC,14)
		_cArquivo += PADR(SM0->M0_INSC,15)
		_cArquivo += PADR(SM0->M0_ENDCOB,40)
		_cArquivo += PADR(SM0->M0_BAIRCOB,20)
		_cArquivo += PADR(SM0->M0_CIDCOB,35)
		_cArquivo += PADR(SM0->M0_CEPCOB,9)
		_cArquivo += PADR(SM0->M0_CODMUN,9)
		_cArquivo += PADR(SM0->M0_ESTCOB,9)
		_cArquivo += PADR(SM0->M0_TEL,35)
		_cArquivo += Space(11)
		_cArquivo += CHR(13)+CHR(10)

		//Bloco 329
		_cArquivo += "329"
		_cArquivo += "PEDIDO: "+(_cAlias)->D2_PEDIDO+", ORDEM DE SERVICO: "+_cOs
		_cArquivo += CHR(13)+CHR(10)

		(_cAlias)->(DbSkip())
	EndDo

//Return()
Return(_cArquivo)

/*====================================================================================\
|Programa  | AJUSTANUM        | Autor | Renato Nogueira            | Data | 26/01/2017|
|=====================================================================================|
|Descrição | Ajustar valor 								                              |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 			                                                              |
|=====================================================================================|
|Uso       | Especifico Steck                                                      |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

Static Function AJUSTANUM(_nValor,_nTamInt,_nTamDec)

	Local _cInt	:= ""
	Local _cDec := ""
	Local _cValor := ""
	Default _nValor  := 0
	Default _nTamInt := 0
	Default _nTamDec := 0

	_cInt := PADL(INT(_nValor),_nTamInt,"0")

	If AT(".",CVALTOCHAR(_nValor))>0
		_cDec := PADR(SubStr(CVALTOCHAR(_nValor),AT(".",CVALTOCHAR((_nValor)))+1,Len(CVALTOCHAR(_nValor))),_nTamDec,"0")
	Else
		_cDec := PADR("0",_nTamDec,"0")
	EndIf

	_cValor := _cInt+_cDec

Return(_cValor)

/*====================================================================================\
|Programa  | STTNT011        | Autor | Renato Nogueira            | Data | 13/08/2019 |
|=====================================================================================|
|Descrição | Retornar endereço de entrega do pedido			                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 			                                                              |
|=====================================================================================|
|Uso       | Especifico Steck                                                      	  |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

//User Function STTNT011()
User Function STBRA011()

	Local _aEndereco := {}
	Local _aArea	 := GetArea()
	Local _cCep		 := ""
	Local _cEnd		 := ""
	Local _cBair 	 := ""
	Local _cCodM	 := ""
	Local _cMune	 := ""
	Local _cEst		 := ""
	Local _lEndDif	 := .F.

	If SC5->(Eof())
		Return(_aEndereco)
	EndIf

	If !Empty(SC5->C5_ZCEPE)

		_cCep 	:= SC5->C5_ZCEPE
		_cEnd 	:= SC5->C5_ZENDENT
		_cBair	:= SC5->C5_ZBAIRRE

		If CC2->(DbSeek(xFilial("CC2")+SC5->C5_ZESTE+SC5->C5_ZMUNE))
			_cCodM	:= CC2->CC2_CODMUN
		Else
			_cCodM	:= ""
		EndIf

		_cMune  := SC5->C5_ZMUNE
		_cEst	:= SC5->C5_ZESTE
		_lEndDif:= .T.

	ElseIf !Empty(SC5->C5_LOJAENT)

		If SA1->(DbSeek(xFilial("SA1")+SC5->C5_CLIENT+SC5->C5_LOJAENT))

			_cCep 	:= SA1->A1_CEP
			_cEnd 	:= SA1->A1_END
			_cBair	:= SA1->A1_BAIRRO
			_cCodM	:= SA1->A1_COD_MUN
			_cMune  := SA1->A1_MUN
			_cEst	:= SA1->A1_EST

		EndIf

	Else

		If SA1->(DbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI))

			_cCep 	:= SA1->A1_CEP
			_cEnd 	:= SA1->A1_END
			_cBair	:= SA1->A1_BAIRRO
			_cCodM	:= SA1->A1_COD_MUN
			_cMune  := SA1->A1_MUN
			_cEst	:= SA1->A1_EST

		EndIf

	EndIf

	AADD(_aEndereco,{_cCep,_cEnd,_cBair,_cCodM,_cMune,_cEst,_lEndDif})

	RestArea(_aArea)

Return(_aEndereco)

/*====================================================================================\
|Programa  | STTNT012        | Autor | Renato Nogueira            | Data | 13/08/2019 |
|=====================================================================================|
|Descrição | Retornar próximo número sequencial SZV			                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 			                                                              |
|=====================================================================================|
|Uso       | Especifico Steck                                                      	  |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

//User Function STTNT012()
User Function STBRA012()

	Local _cQuery4 := ""
	Local _cAlias4 := GetNextAlias()
	Local _cProxN  := ""

	_cQuery4 := " SELECT MAX(ZV_NUM) ULTNUM
	_cQuery4 += " FROM "+RetSqlName("SZV")+" ZV
	_cQuery4 += " WHERE ZV.D_E_L_E_T_=' '

	If !Empty(Select(_cAlias4))
		DbSelectArea(_cAlias4)
		(_cAlias4)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery4),_cAlias4,.T.,.T.)

	dbSelectArea(_cAlias4)

	(_cAlias4)->(dbGoTop())

	If (_cAlias4)->(!Eof())
		If !Empty((_cAlias4)->ULTNUM)
			_cProxN := Soma1((_cAlias4)->ULTNUM)
		Else
			_cProxN := "0000000001"
		EndIf
	Else
		_cProxN := "0000000001"
	EndIf

Return(_cProxN)
