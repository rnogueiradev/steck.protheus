#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "XMLXFUN.CH"
#INCLUDE "ap5mail.ch"
#INCLUDE "FILEIO.CH"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "TOPCONN.CH"

#Define CR chr(13)+chr(10)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSELMANIF	บAutor  ณRenato Nogueira     บ Data ณ  03/06/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFonte utilizado para selecionar as chaves que serใo feitas  บฑฑ
ฑฑบ          ณa manifesta็ใo 											  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametro ณ Nenhum                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑบRetorno   ณ Nenhum                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function SELMANIF()

	Local nY			:= 0
	Local nX			:= 0
	Local lSaida   		:= .T.
	Local aSize	   		:= MsAdvSize(.F.)
	Local aCampoEdit	:= {}
	Local lConfirma		:= .F.
	Local cQuery 		:= ""
	Local cAlias 		:= "QRYTEMP"
	Local nColMani		:= 0
	Local aArea			:= {}
	Local aAreaSM0		:= {}
	Local _nPosChave	:= 0
	Local oGreen    := LoadBitmap( GetResources(), "BR_VERDE")
	Local oRed      := LoadBitmap( GetResources(), "BR_VERMELHO")
	Local oBlack    := LoadBitmap( GetResources(), "BR_PRETO")
	Local oYellow   := LoadBitmap( GetResources(), "BR_AMARELO")
	Local oBrown    := LoadBitmap( GetResources(), "BR_MARROM")
	Local oBlue     := LoadBitmap( GetResources(), "BR_AZUL")
	Local oOrange   := LoadBitmap( GetResources(), "BR_LARANJA")
	Local oViolet   := LoadBitmap( GetResources(), "BR_VIOLETA")
	Local oPink     := LoadBitmap( GetResources(), "BR_PINK")
	Local oGray     := LoadBitmap( GetResources(), "BR_CINZA")
	Private	oWindow,;
		oFontWin,;
		aHead				:= {},;
		bOk 				:= {||(	lSaida:=.f., lConfirma:=.T.,oWindow:End()) },;
		bCancel 	    	:= {||(	lSaida:=.f.,oWindow:End()) },;
		aButtons	    	:= {},;
		oGet
	Private aHeader		:= {}
	Private aCols		:= {}

	cCnpj	:= Posicione("SM0",1,cEmpAnt+cFilAnt,"M0_CGC")

	If !U_XCNPJAUT(cCnpj)
		MsgAlert("Aten็ใo, este CNPJ nใo estแ autorizado para utilizar a rotina")
		Return()
	EndIf

	//AADD(aButtons, {"Contatos",{||U_CONTATGR()},OemToAnsi("Contatos"),"Contatos"})
	//AADD(aButtons, {"Atualizar",{||U_REFRESHT()},OemToAnsi("Atualizar"),"Atualizar"})
	AADD(aButtons, {"Ver Danfe",{||U_VERDANFE()},OemToAnsi("Ver Danfe"),"Ver Danfe"})
	/*
	MsgAlert("Esta ้ uma versใo de teste e irแ expirar no dia 15/06/2015")
	If date()>CTOD("15/06/2015")
		MsgAlert("Aten็ใo, o tempo de uso da funcionalidade expirou, entre em contato com o Administrador!")
		Return()
	EndIf
	*/
	DbSelectArea("SX3")
	SX3->(DbGoTop())
	SX3->(DbSetOrder(1))
	SX3->(DbSeek("SZ9"))

	//Monta cabe็alho
	Aadd(aHeader,{"Status"		 , "COR"		  , "@BMP"				,    1   ,      0 ,.T.			,       ,""     ,""     ,"R"		,""			  ,            "",            .F.,            "V",            "",            "",            "",            ""})
	Aadd(aHeader,{"Manifesta็ใo" , "Z9_MANIF" 	  , "@!" 				,    1   ,      0 ,"U_VLDSTAT()",   	,"C" 	,""		,"R"		,"1=Confirma็ใo da opera็ใo;2=Desconhecimento da opera็ใo;3=Opera็ใo nใo realizada;4=Ci๊ncia da opera็ใo;5=Nใo processar"})

	While SX3->(!Eof()) .And. AllTrim(SX3->X3_ARQUIVO)=="SZ9"

		If !AllTrim(SX3->X3_CAMPO)$"Z9_STATUS#Z9_XML#Z9_DOC#Z9_SERIE"

			Aadd(aHeader,{SX3->X3_TITULO  ,SX3->X3_CAMPO  ,SX3->X3_PICTURE  ,SX3->X3_TAMANHO  ,SX3->X3_DECIMAL  ,""        ,     ,SX3->X3_TIPO  ,SX3->X3_CONTEXT})

		EndIf
		//            																						  allwaystrue usado                                ,cbox
		SX3->(DbSkip())

	EndDo

	nColMani	:= aScan(aHeader,{|x| Trim(x[2])=="Z9_MANIF"})
	_nPosChave	:= aScan(aHeader,{|x| Trim(x[2])=="Z9_CHAVE"})

	aCampoEdit := {"Z9_MANIF"}

	aAreaSM0	:= GetArea("SM0")
	aArea		:= GetArea()
	/*
	//Abrir threads por empresa da fun็ใo conslote
	DbSelectArea("SM0")
	SM0->(DbSetOrder(1))
	SM0->(DbGoTop())

	While SM0->(!Eof())

		If !U_XCNPJAUT(SM0->M0_CGC)
			MsgAlert("Aten็ใo, o CNPJ: "+SM0->M0_CGC+" nใo estแ autorizado para utilizar a rotina")
			SM0->(DbSkip())
		EndIf

		If (SM0->M0_CODIGO=="01" .And. SM0->M0_CODFIL=="01") .Or.;
				(SM0->M0_CODIGO=="01" .And. SM0->M0_CODFIL=="02") .Or.;
				(SM0->M0_CODIGO=="01" .And. SM0->M0_CODFIL=="03") .Or.;
				(SM0->M0_CODIGO=="01" .And. SM0->M0_CODFIL=="04") .Or.;
				(SM0->M0_CODIGO=="03" .And. SM0->M0_CODFIL=="01")
			//desabilitei pois o job ja realiza a pesquisa automatico giovani zago 22/10/16
			//StartJob("U_CONSLOTE",GetEnvServer(), .F.,SM0->M0_CODIGO,SM0->M0_CODFIL,_nPosChave)

		EndIf
		SM0->(DbSkip())

	EndDo

	RestArea(aArea)
	RestArea(aAreaSM0)
	*/
	//Monta aCols

	cQuery := " SELECT Z9_FILIAL, Z9_NOMFOR, Z9_VALORNF, Z9_CHAVE, Z9_NFEORI, Z9_SERORI, Z9_DTEMIS, Z9_STATUSA, R_E_C_N_O_ "
	cQuery += " FROM "+RetSqlName("SZ9")+" Z9 "
	cQuery += " WHERE Z9.D_E_L_E_T_=' ' AND Z9_STATUS='0' AND Z9_FILIAL='"+cFilAnt+"' "
	cQuery += " ORDER BY Z9_DTEMIS "

	If !Empty(Select(cAlias))
		DbSelectArea(cAlias)
		(cAlias)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

	dbSelectArea(cAlias)
	(cAlias)->(dbGoTop())

	While !(cAlias)->(Eof())

		If AllTrim(UPPER((cAlias)->Z9_STATUSA))=="CONFIRMADA OPERACAO" .Or. AllTrim(UPPER((cAlias)->Z9_STATUSA))=="OPERACAO NAO REALIZADA"
			(cAlias)->(DbSkip())
			Loop
		EndIf

		AADD(aCols,Array(Len(aHeader)+1))

		For nY := 1 To Len(aHeader)

			DO CASE
			CASE AllTrim(aHeader[nY][2]) =  "Z9_FILIAL"
				aCols[Len(aCols)][nY] := (cAlias)->Z9_FILIAL
			CASE AllTrim(aHeader[nY][2]) =  "Z9_NOMFOR"
				aCols[Len(aCols)][nY] := (cAlias)->Z9_NOMFOR
			CASE AllTrim(aHeader[nY][2]) =  "Z9_VALORNF"
				aCols[Len(aCols)][nY] := (cAlias)->Z9_VALORNF
			CASE AllTrim(aHeader[nY][2]) =  "Z9_CHAVE"
				aCols[Len(aCols)][nY] := (cAlias)->Z9_CHAVE
			CASE AllTrim(aHeader[nY][2]) =  "Z9_NFEORI"
				aCols[Len(aCols)][nY] := (cAlias)->Z9_NFEORI
			CASE AllTrim(aHeader[nY][2]) =  "Z9_SERORI"
				aCols[Len(aCols)][nY] := (cAlias)->Z9_SERORI
			CASE AllTrim(aHeader[nY][2]) =  "Z9_DTEMIS"
				aCols[Len(aCols)][nY] := DTOC(STOD((cAlias)->Z9_DTEMIS))
			CASE AllTrim(aHeader[nY][2]) =  "Z9_STATUSA"
				aCols[Len(aCols)][nY] := (cAlias)->Z9_STATUSA
			CASE AllTrim(aHeader[nY][2]) =  "Z9_MANIF"
				aCols[Len(aCols)][nY] := "5"
			CASE AllTrim(aHeader[nY][2]) =  "COR"
				If AllTrim(UPPER((cAlias)->Z9_STATUSA))=="NF CANCELADA"
					aCols[Len(aCols)][nY] := oBlack
				ElseIf AllTrim(UPPER((cAlias)->Z9_STATUSA))=="CIENCIA" .OR. AllTrim(UPPER((cAlias)->Z9_STATUSA))=="CIสNCIA"
					aCols[Len(aCols)][nY] := oGreen
				ElseIf AllTrim(UPPER((cAlias)->Z9_STATUSA))=="CONFIRMADA OPERACAO"
					aCols[Len(aCols)][nY] := oBlue
				ElseIf AllTrim(UPPER((cAlias)->Z9_STATUSA))=="SEM MANIFESTACAO"
					aCols[Len(aCols)][nY] := oYellow
				ElseIf AllTrim(UPPER((cAlias)->Z9_STATUSA))=="OPERACAO NAO REALIZADA"
					aCols[Len(aCols)][nY] := oGray
				EndIf
			ENDCASE

		Next

		aCols[Len(aCols)][Len(aHeader)+1] := .F.

		(cAlias)->(DbSkip())

	EndDo

	While lSaida

		DEFINE MSDIALOG oWindow FROM 0,0 TO aSize[6],aSize[5]/*500,1200*/ TITLE Alltrim(OemToAnsi('Manifesta็ใo do destinatแrio')) Pixel //430,531

		oGet	:= MsNewGetDados():New( 0,  0,  270,650, GD_UPDATE ,"AllWaysTrue()","AllWaysTrue()",,aCampoEdit,,Len(aCols),,, ,oWindow, aHeader, aCols )
		MsNewGetDados():SetEditLine (.T.)

		ACTIVATE MSDIALOG oWindow CENTERED ON INIT EnchoiceBar(oWindow,bOk,bCancel,,aButtons)

	End

	aCols:= aClone(oGet:aCols)

	If lConfirma .And. MsgYesNo('Confirma as manifesta็๕es cadastradas?')

		cCnpj	:= Posicione("SM0",1,cEmpAnt+cFilAnt,"M0_CGC")
		cUf		:= Posicione("SM0",1,cEmpAnt+cFilAnt,"M0_ESTENT")

		Processa( {|lEnd| U_EXEMANIF(aCols,cCnpj,cUf,nColMani,@lEnd,_nPosChave)}, "Aguarde...","Executando manifesto.", .T. )

		MsgInfo("Processamento finalizado")

	EndIf

	If lConfirma
		U_SELMANIF()
	EndIf

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณEXEMANIF	บAutor  ณRenato Nogueira     บ Data ณ  03/06/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFonte utilizado para realizar o manifesto das chaves 		  บฑฑ
ฑฑบ          ณselecionadas na secretaria da fazenda  				      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametro ณ Nenhum                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑบRetorno   ณ Nenhum                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function EXEMANIF(aCols,cCnpj,cUf,nColMani,lEnd,_nPosChave)

	Local oWsManif
	Local oWsNfe
	Local nX			:= 0
	Local ctpEvento		:= ""
	Local cDescEvento	:= ""
	Local lContinua		:= .F.
	Local lOk        	:= .T.
	Local nCnt			:= 0
	Local cQuery 		:= ""
	Local cAlias 		:= "QRYTEMP"
	//Local _nPosChave
	Local _nPosFil		:= 4 //Posi็ใo Fixa para Filial
	Local cHorVerao		:= ""
	Local cURL       	:= PadR(GetNewPar("MV_SPEDURL","http://"),250)
	Local _cIdEnt		:= ""
	Local _cPass		:= ""
	Private oWsManif    := Nil

	//dbEval( {|x| nCnt++ },,)
	ProcRegua(100)
	/*
	DbSelectArea("SX6")
	SX6->(DbSetOrder(1))
	SX6->(DbGoTop())
	SX6->(DbSeek("  "+"FS_TPAMBNF"))

	If SX6->(Eof())

		SX6->(RecLock("SX6",.T.))
		SX6->X6_FIL		:= ""
		SX6->X6_VAR		:= "FS_TPAMBNF"
		SX6->X6_TIPO	:= "C"
		SX6->X6_DESCRIC	:= "Tipo de ambiente - 1=Prod;2=Homol"
		SX6->X6_CONTEUD	:= "1" //Inicia com produ็ใo
		SX6->(MsUnLock())

	EndIf
	*/
	For nX:=1 To Len(aCols)

		IncProc(CVALTOCHAR(nX)+" processando chave: "+AllTrim(aCols[nX][_nPosChave]))

		lContinua	:= .T.

		DO CASE
		CASE AllTrim(aCols[nX][nColMani])=="1" //Confirma็ใo da opera็ใo
			ctpEvento	:= "210200"
			cDescEvento	:= "Confirmacao da Operacao"
		CASE AllTrim(aCols[nX][nColMani])=="2" //Desconhecimento da opera็ใo
			ctpEvento	:= "210220"
			cDescEvento	:= "Desconhecimento da Operacao"
		CASE AllTrim(aCols[nX][nColMani])=="3" //Opera็ใo nใo realizada
			ctpEvento	:= "210240"
			cDescEvento	:= "Operacao nao Realizada"
		CASE AllTrim(aCols[nX][nColMani])=="4" //Ci๊ncia da opera็ใo
			ctpEvento	:= "210210"
			cDescEvento	:= "Ciencia da Operacao"
		CASE AllTrim(aCols[nX][nColMani])=="5" //Nใo processar
			lContinua	:= .F.
		ENDCASE

		If lContinua

			If AllTrim(GetMv("FS_TPAMBNF"))=="2" //Homologa็ใo
				oWsManif := WSRecepcaoEveHml():New()
			ElseIf AllTrim(GetMv("FS_TPAMBNF"))=="1" //Producao
				oWsManif := WSNFeRecepcaoEvento4():New()
			EndIf

			_cIdEnt := U_XGETIND(cCnpj,"1")
			_cPass  := U_XGETIND(cCnpj,"2")

			oWsManif:_CERT			:= "D:\TOTVS\TSS30\certs\"+_cIdEnt+"_all.pem"
			oWsManif:_PRIVKEY		:= "D:\TOTVS\TSS30\certs\"+_cIdEnt+"_key.pem"
			oWsManif:_PASSPHRASE	:= _cPass

			oWS:=WsSpedCfgNfe():New()
			oWS:cUSERTOKEN 	  	:= "TOTVS"
			oWS:cID_ENT    		:= _cIdEnt
			oWS:nAMBIENTECCE	:= 0
			oWS:cVERCCELAYOUT	:= "1.00"
			oWS:cVERCCELAYEVEN	:= "1.00"
			oWS:cVERCCEEVEN		:= "1.00"
			oWS:cVERCCE			:= "1.00"
			oWS:cHORAVERAOCCE	:= "2-Nao"
			oWS:cHORARIOCCE		:= "2-Brasilia"
			oWS:_URL       		:= AllTrim(cURL)+"/SpedCfgNfe.apw"
			lOk:=oWS:CfgCCe()

			If lOk

				If ValType(oWS:oWsCfgCCeResult:cHoraVeraoCCe) <> "U"
					cHorVerao	:= oWS:oWsCfgCCeResult:cHoraVeraoCCe
				Else
					cHorVerao	:= "2-Nao"
				EndIf

			EndIf
			_ctime:=  (val(Substr(time(),4,2))-5)
			If  _ctime < 0
				_ctime:= 00
			EndIf
			_ctime:= strzero(_ctime,2)
			_ctime:= Substr(time(),1,3)+_ctime+':00'

			_ctime:= time()

			cSchema	:= '<envEvento versao="1.00" xmlns="http://www.portalfiscal.inf.br/nfe">'
			cSchema	+= '<idLote>1</idLote>'
			cSchema	+= '<evento versao="1.00" xmlns="http://www.portalfiscal.inf.br/nfe">'
			cSchema	+= '<infEvento Id="ID'+ctpEvento+AllTrim(aCols[nX][_nPosChave])+'01'+'">'
			//cSchema	+= '<cOrgao>'+cUf+'</cOrgao>'
			cSchema	+= '<cOrgao>91</cOrgao>'
			cSchema	+= '<tpAmb>'+AllTrim(GetMv("FS_TPAMBNF"))+'</tpAmb>'
			cSchema	+= '<CNPJ>'+cCnpj+'</CNPJ>'
			cSchema	+= '<chNFe>'+ AllTrim(aCols[nX][_nPosChave])+'</chNFe>'
			/*
			If Len(SubStr(dtoc(date()),7,4)+'-'+SubStr(dtoc(date()),4,2)+'-'+SubStr(dtoc(date()),1,2)+'T'+time()+'-0'+IIf(AllTrim(cHorVerao)=="2-Nao",'3','2')+':00')==23
				cSchema	+= '<dhEvento>'+SubStr(dtoc(date()),7,4)+'-'+SubStr(dtoc(date()),4,2)+'-'+SubStr(dtoc(date()),1,2)+'T'+_ctime+'-0'+IIf(AllTrim(cHorVerao)=="2-Nao",'3','2')+':00'+'</dhEvento>'
			Else
				cSchema	+= '<dhEvento>'+SubStr(dtoc(date()),7,4)+'-'+SubStr(dtoc(date()),4,2)+'-'+SubStr(dtoc(date()),1,2)+'T'+_ctime+'-0'+IIf(AllTrim(cHorVerao)=="2-Nao",'3','2')+':00'+'</dhEvento>'
			EndIf
			*/
			_cDtAju:= SubStr(dtoc(date()),7,4)
			If Len(Alltrim(_cDtAju)) = 2
				_cDtAju:= '20'+ _cDtAju
			EndIf
			cSchema	+= '<dhEvento>'+_cDtAju+'-'+;
				SubStr(dtoc(date()),4,2)+'-'+SubStr(dtoc(date()),1,2)+'T'+;
				_ctime+'-0'+ IIf(AllTrim(cHorVerao)=="2-Nao",'3','2')+':00'+'</dhEvento>'

			//conout(cSchema)
			cSchema	+= '<tpEvento>'+ctpEvento+'</tpEvento>'
			cSchema	+= '<nSeqEvento>1</nSeqEvento>'
			cSchema += '<verEvento>1.00</verEvento>'
			cSchema += '<detEvento versao="1.00">'
			cSchema += '<descEvento>'+cDescEvento+'</descEvento>'

			If ctpEvento=="210240" //opera็ใo nใo realizada
				cSchema += '<xJust>'+ Alltrim(AllTrim(aCols[nX][3])) +'</xJust>'
			EndIf


			cSchema += '</detEvento>'
			cSchema += '</infEvento>'
			cSchema += '</evento>'
			cSchema += '</envEvento>'

			cSchema	:=	ASSINXML(cSchema,"infEvento","Id",_cIdEnt)
			//35170301847854000251550010001593271001593275
			//oXml := XmlParser(cSchema,"_",@cErro,@cAviso)

			//oWsManif:cversaoDados	:= "1.00"
			//oWsManif:ccUF			:= "91"//cUf
			oWsManif:oWS			:= cSchema

			If oWsManif:nfeRecepcaoEventoNF()
				// M้todo executado com sucesso
				if !AttIsMemberOf( oWsManif:OWS:_RETENVEVENTO, "_RETEVENTO", .F. )    // Valdemir Rabelo 17/03/2022 - Verifico se a propriedade existe no objetp
				   Loop
				endif 

				If oWsManif:OWS:_RETENVEVENTO:_RETEVENTO:_INFEVENTO:_CSTAT:TEXT=="135" //Evento processado e vinculado

					DbSelectArea("SZ9")
					SZ9->(DbGoTop())
					SZ9->(DbSetOrder(1))
					If SZ9->(DbSeek(aCols[nX][_nPosFil]+aCols[nX][_nPosChave]))
						SZ9->(Reclock("SZ9",.F.))
						If ctpEvento=="210200" .And. SZ9->Z9_STATUSA <> "Confirmada Opera็ใo"//Confirma็ใo da Opera็ใo
							SZ9->Z9_STATUS	:= "1"
							SZ9->Z9_STATUSA	:= "Confirmada Opera็ใo"
						ElseIf ctpEvento=="210210"  //Ci๊ncia da Opera็ใo
							SZ9->Z9_STATUS	:= "0"
							SZ9->Z9_STATUSA	:= "Ci๊ncia"
						ElseIf ctpEvento=="210220"  //Desconhecimento da opera็ใo
							SZ9->Z9_STATUS	:= "3"
							SZ9->Z9_STATUSA	:= "Desconhecida"
						ElseIf ctpEvento=="210240"  //Opera็ใo nใo realizada
							SZ9->Z9_STATUS	:= "3"
							SZ9->Z9_STATUSA	:= "Opera็ใo nใo Realizada"
						Else
							SZ9->Z9_STATUS	:= "3"
							SZ9->Z9_XML		:= cDescEvento
						EndIf
						SZ9->Z9_LOG 	:= Alltrim(SZ9->Z9_LOG)+ CR + SZ9->Z9_STATUSA+" Chave: "+SZ9->Z9_CHAVE + " - Empresa : "+cEmpAnt+" filial: "+cFilAnt+" - "+dtoc(date())+" - "+time()


						SZ9->(MsUnlock())
						SZ9->(DbCommit())
					EndIf

					If ctpEvento=="210200" .Or. ctpEvento=="210210" //Confirma็ใo da Opera็ใo ou Ci๊ncia da Opera็ใo
						//U_BAIXAXML(aCols[nX][_nPosChave],cUf,cCnpj)
					EndIf

				ElseIF oWsManif:OWS:_RETENVEVENTO:_RETEVENTO:_INFEVENTO:_CSTAT:TEXT=="596" //Consumo indevido
				      Conout("Rejei็ใo 596: Evento apresentado fora do prazo")
				ElseIF oWsManif:OWS:_RETENVEVENTO:_RETEVENTO:_INFEVENTO:_CSTAT:TEXT=="650" //NF cancelada ou denegada

					DbSelectArea("SZ9")
					SZ9->(DbGoTop())
					SZ9->(DbSetOrder(1))
					If SZ9->(DbSeek(aCols[nX][_nPosFil]+aCols[nX][_nPosChave]))
						If AllTrim(SZ9->Z9_STATUS)<>"3"
							SZ9->(Reclock("SZ9",.F.))
							SZ9->Z9_STATUS	:= "3"
							SZ9->Z9_XML		:= "Nota fiscal cancelada"
							SZ9->(MsUnlock())
							SZ9->(DbCommit())
						EndIf


					EndIf

				ElseIF oWsManif:OWS:_RETENVEVENTO:_RETEVENTO:_INFEVENTO:_CSTAT:TEXT=="573"
					_cDuplic := ' '
					_cDuplic := oWsManif:OWS:_RETENVEVENTO:_RETEVENTO:_INFEVENTO:_XMOTIVO:TEXT
					ConOut(_cDuplic +' - '+ AllTrim(aCols[nX][nColMani])+' - '+ aCols[nX][_nPosChave])

					 IF oWsManif:OWS:_RETENVEVENTO:_RETEVENTO:_INFEVENTO:_TPEVENTO:TEXT=="210200"

						DbSelectArea("SZ9")
						SZ9->(DbGoTop())
						SZ9->(DbSetOrder(1))
						If SZ9->(DbSeek(aCols[nX][_nPosFil]+aCols[nX][_nPosChave]))

							SZ9->(Reclock("SZ9",.F.))
							dbSelectArea("SF1")
							SF1->(DbSetOrder(8))
							If  SF1->(DbSeek(SZ9->Z9_FILIAL+SZ9->Z9_CHAVE))
								If SZ9->Z9_DOC <> Alltrim(SF1->F1_DOC) .Or. SZ9->Z9_SERIE <> SF1->F1_SERIE
									SZ9->Z9_SERIE	:= Alltrim(SF1->F1_SERIE)
									SZ9->Z9_DOC		:= Alltrim(SF1->F1_DOC)
									//SZ9->Z9_ORIGEM	:= 'S'
								EndIf

								SZ9->Z9_STATUS	:= "1"
								SZ9->Z9_STATUSA	:= "Confirmada Opera็ใo"

							EndIf
							SZ9->(MsUnlock())
							SZ9->(DbCommit())

						EndIf
					EndIf

					//MsgAlert(oWsManif:OWS:_RETENVEVENTO:_RETEVENTO:_INFEVENTO:_XMOTIVO:TEXT)
				EndIf
			Else
				cSvcError   := GetWSCError()  // Resumo do erro
				cSoapFCode  := GetWSCError(2) // Soap Fault Code
				cSoapFDescr := GetWSCError(3) // Soap Fault Description
				//MsgAlert(Alltrim(cSvcError)+' - chave: '+AllTrim(aCols[nX][_nPosChave]))
				Conout(cSvcError)
			EndIf

		EndIf

		MsUnLockAll()
		DbCommitAll()

	Next

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma  ณSpedSignXMLบAutor  ณRenato Nogueira     บ Data ณ  03/06/14  บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออนฑฑ
ฑฑบDesc.     ณFonte utilizado para instanciar os objetos do webservice	  บฑฑ
ฑฑบ          ณe baixar arquivo xml do site da sefaz   				      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametro ณ Nenhum                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑบRetorno   ณ Nenhum                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ASSINXML(cXML,cTag,cAttID,_cIdEnt)

	Local cXmlToSign  := ""
	Local cURI        := ""
	Local cDir        := IIf(IsSrvUnix(),"certificados/", "certificados\")
	Local cRootPath   := StrTran(GetSrvProfString("RootPath","")+IIf(!IsSrvUnix(),"\","/"),IIf(!IsSrvUnix(),"\\","//"),IIf(!IsSrvUnix(),"\","/"))
	Local cStartPath  := StrTran(cRootPath+IIf(!IsSrvUnix(),"\","/")+GetSrvProfString("StartPath","")+IIf(!IsSrvUnix(),"\","/"),IIf(!IsSrvUnix(),"\\","//"),IIf(!IsSrvUnix(),"\","/"))
	Local cArqXML     := Lower(CriaTrab(,.F.))
	Local cMacro      := ""
	Local cError      := ""
	Local cWarning    := ""
	Local cDigest     := ""
	Local cSignature  := ""
	Local cSignInfo   := ""
	Local cIniXml     := ""
	Local cFimXml     := ""
	Local cNameSpace  := ""
	Local cNewTag     := ""
	Local cThreadID	  := GetSrvProfString("SPED_THREADID","0")
	Local nAt         := 0
	Local nAtVer  	  := 0
	Local oWs

	cRootPath  := StrTran(cRootPath,IIf(!IsSrvUnix(),"\\","//"),IIf(!IsSrvUnix(),"\","/"))
	cStartPath := StrTran(cStartPath,IIf(!IsSrvUnix(),"\\","//"),IIf(!IsSrvUnix(),"\","/"))
	cStartPath := StrTran(cStartPath,IIf(!IsSrvUnix(),"\\","//"),IIf(!IsSrvUnix(),"\","/"))

	If !Empty(Select("SPED001"))
		DbSelectArea("SPED001")
		("SPED001")->(dbCloseArea())
	Endif

	USE &("SPED001") ALIAS &("SPED001") SHARED NEW VIA "TOPCONN"
	DBSELECTAREA("SPED001")
	DBSETINDEX("SPED00101")

	MsSeek(_cIdEnt)

	If !Empty(Select("SPED000"))
		DbSelectArea("SPED000")
		("SPED000")->(dbCloseArea())
	Endif

	USE &("SPED000") ALIAS &("SPED000") SHARED NEW VIA "TOPCONN"
	DBSELECTAREA("SPED000")
	DBSETINDEX("SPED00001")

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณObtenho a URI                                                           ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cUri := SpedNfeId(cXML,cAttId)
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณAssina a NFe                                                            ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	Do Case
	Case  FindFunction("EVPPrivSign")
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณCanoniza o XML                                                          ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		cXmlToSign := XmlC14N(cXml, "", @cError, @cWarning)
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณTratamento para troca de caracter referente ao xml da ANFAVEAณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		cXmlToSign := (StrTran(cXmlToSign,"&lt;/","</"))
		cXmlToSign = (StrTran(cXmlToSign,"/&gt;","/>"))
		cXmlToSign = (StrTran(cXmlToSign,"&lt;","<"))
		cXmlToSign = (StrTran(cXmlToSign,"&gt;",">"))
		cXmlToSign = (StrTran(cXmlToSign,"<![CDATA[[ ","<![CDATA["))
		//		varinfo("cXmlToSign : ",cXmlToSign)

		If Empty(cError) .And. Empty(cWarning)
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณRetira a Tag anterior a tag de assinatura                               ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			nAt := At("<"+cTag,cXmlToSign)
			cIniXML    := SubStr(cXmlToSign,1,nAt-1)
			cXmlToSign := SubStr(cXmlToSign,nAt)
			nAt := At("</"+cTag+">",cXmltoSign)
			cFimXML    := SubStr(cXmltoSign,nAt+Len(cTag)+3)
			cXmlToSign := SubStr(cXmlToSign,1,nAt+Len(cTag)+2)
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณDescobre o namespace complementar da tag de assinatura                  ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			cNewTag := AllTrim(cIniXml)
			cNewTag := SubStr(cIniXml,2,At(" ",cIniXml)-2)
			cNameSpace := StrTran(cIniXml,"<"+cNewTag,"")
			cNameSpace := AllTrim(StrTran(cNameSpace,">",""))
			nAtver := At("versao",cNameSpace) // Pode ter um atributo versao Ex. ( xmlns="http://" versao="1.01")
			If nAtver > 0
				cNameSpace := SubStr(cNameSpace, 1, nAtver-1) // -2 por causa do espaco
				cNameSpace := RTrim(cNameSpace)
			Endif
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณCalcula o DigestValue da assinatura                                     ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			cDigest := StrTran(cXmlToSign,"<"+cTag+" ","<"+cTag +" "+cNameSpace+" ")
			cDigest := XmlC14N(cDigest, "", @cError, @cWarning)
			cMacro  := "EVPDigest"
			cDigest := Encode64(&cMacro.( cDigest , 3 ))
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณCalcula o SignedInfo  da assinatura                                     ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			cSignInfo := NfeSignedInfo(cUri,cDigest)
			cSignInfo := XmlC14N(cSignInfo, "", @cError, @cWarning)
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณAssina o XML                                                            ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			If SpedGetMv("MV_HSM",_cIdEnt)=="0"
				cMacro   := "EVPPrivSign"
				cSignature := &cMacro.(IIf(IsSrvUnix(),"/", "\")+cDir+_cIdEnt+"_key.pem" , cSignInfo , 3 , Decode64(AllTrim(SPED001->PASSCERT)) , @cError)
			Else
				If GetBuild() >= '7.00.081215P-20090626'
					cMacro   := "HSMPrivSign"
					cSignature := &cMacro.("slot_"+SpedGetMv("MV_HSMSLOT",_cIdEnt)+"-label_"+SpedGetMv("MV_KEYLABE",_cIdEnt), cSignInfo , 3 , @cError, Decode64(AllTrim(SPED001->PASSCERT)))
				Else
					cMacro   := "HSMPrivSign"
					cSignature := &cMacro.("slot_"+SpedGetMv("MV_HSMSLOT",_cIdEnt)+"-label_"+SpedGetMv("MV_KEYLABE",_cIdEnt), cSignInfo , 3 , @cError)
				EndIf
			EndIf
			cSignature := Encode64(cSignature)
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณEnvelopa a assinatura                                                   ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			cCert := GetCertificate(IIf(IsSrvUnix(),"/", "\")+cDir+_cIdEnt+"_cert.pem",SpedGetMv("MV_HSM",_cIdEnt)=="1",_cIdEnt)
			If !Empty(cCert)
				cXmlToSign += '<Signature xmlns="http://www.w3.org/2000/09/xmldsig#">'
				cXmltoSign += cSignInfo
				cXmlToSign += '<SignatureValue>'+cSignature+'</SignatureValue>'
				cXmltoSign += '<KeyInfo>'
				cXmltoSign += '<X509Data>'
				cXmltoSign += '<X509Certificate>'+cCert+'</X509Certificate>'
				cXmltoSign += '</X509Data>'
				cXmltoSign += '</KeyInfo>'
				cXmltoSign += '</Signature>'
				cXmlToSign := cIniXML+cXmlToSign+cFimXML
			Else
				cXmlToSign:= ""
			EndIf
		Else
			cXmlToSign := cXml
			ConOut(IIF(cThreadID=="1",'ThreadID='+AllTrim(Str(ThreadID(),15)),"")+" - Sign Error thread: "+cError+"/"+cWarning)
		EndIf
	Case FindFunction("NFeSign")
		cMacro := "NFeSign"
		&cMacro.('<?xml version="1.0" encoding="UTF-8"?><!DOCTYPE test [<!ATTLIST '+cTag+' Id ID #IMPLIED>]>'+cXML,"#"+cURI,cStartPath+cArqXML+".xml",cRootPath+cDir+_cIdEnt+"_key.pem",Decode64(AllTrim(SPED001->PASSCERT)),cRootPath+cDir+_cIdEnt+"_cert.pem")

		cXmlToSign := NfeLoadTXT(cArqXml+".xml")
		FErase(cArqXml+".xml")
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณConfirma se houve a assinatura                                          ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If !"DIGESTVALUE"$Upper(cXmltoSign)
			cXmlToSign := ""
		Else
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณRetira o AttList da mensagem assinada                                   ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			Do Case
			Case (nAt := At("<NFe",cXmlToSign))<>0
				cXmlToSign := SubStr(cXmlToSign,nAt)
			Case (nAt := At("<inutNFe",cXmlToSign))<>0
				cXmlToSign := SubStr(cXmlToSign,nAt)
			Case (nAt := At("<cancNFe",cXmlToSign))<>0
				cXmlToSign := SubStr(cXmlToSign,nAt)
			Case (nAt := At("<CTe",cXmlToSign))<>0
				cXmlToSign := SubStr(cXmlToSign,nAt)
			Case (nAt := At("<inutCTe",cXmlToSign))<>0
				cXmlToSign := SubStr(cXmlToSign,nAt)
			Case (nAt := At("<cancCTe",cXmlToSign))<>0
				cXmlToSign := SubStr(cXmlToSign,nAt)
			Case (nAt := At("<envDPEC",cXmlToSign))<>0
				cXmlToSign := SubStr(cXmlToSign,nAt)
			Case (nAt := At("<EnviarLoteRpsEnvio",cXmlToSign))<>0
				cXmlToSign := SubStr(cXmlToSign,nAt)
			Case (nAt := At("<Rps",cXmlToSign))<>0
				cXmlToSign := SubStr(cXmlToSign,nAt)
			Case (nAt := At("<Pedido",cXmlToSign))<>0
				cXmlToSign := SubStr(cXmlToSign,nAt)
			EndCase
		EndIf
	EndCase

	("SPED001")->(DbCloseArea())
	("SPED000")->(DbCloseArea())
	//conout(cXmlToSign)
Return(cXmlToSign)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma  ณNfeSignedInfo												  บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออนฑฑ
ฑฑบDesc.     ณFonte utilizado para instanciar os objetos do webservice	  บฑฑ
ฑฑบ          ณe baixar arquivo xml do site da sefaz   				      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametro ณ Nenhum                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑบRetorno   ณ Nenhum                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function NfeSignedInfo(cUri,cDigest)

	Local cSignedInfo := ""

	cSignedInfo += '<SignedInfo xmlns="http://www.w3.org/2000/09/xmldsig#">'
	cSignedInfo += '<CanonicalizationMethod Algorithm="http://www.w3.org/TR/2001/REC-xml-c14n-20010315"></CanonicalizationMethod>'
	cSignedInfo += '<SignatureMethod Algorithm="http://www.w3.org/2000/09/xmldsig#rsa-sha1"></SignatureMethod>'
	cSignedInfo += '<Reference URI="#'+ cUri +'">'
	cSignedInfo += '<Transforms>'
	cSignedInfo += '<Transform Algorithm="http://www.w3.org/2000/09/xmldsig#enveloped-signature"></Transform>'
	cSignedInfo += '<Transform Algorithm="http://www.w3.org/TR/2001/REC-xml-c14n-20010315"></Transform>'
	cSignedInfo += '</Transforms>'
	cSignedInfo += '<DigestMethod Algorithm="http://www.w3.org/2000/09/xmldsig#sha1"></DigestMethod>'
	cSignedInfo += '<DigestValue>' + cDigest + '</DigestValue></Reference></SignedInfo>'

Return(cSignedInfo)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma  ณGetCertificate											  บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออนฑฑ
ฑฑบDesc.     ณFonte utilizado para instanciar os objetos do webservice	  บฑฑ
ฑฑบ          ณe baixar arquivo xml do site da sefaz   				      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametro ณ Nenhum                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑบRetorno   ณ Nenhum                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function GetCertificate(cFile,lHSM,_cIdEnt)

	Local cCertificado := ""
	Local nAT          := 0
	Local nRAT         := 0
	Local nHandle      := 0
	Local nBuffer      := 0
	Local cNewFunc     := ""
	Local lExistCert   := .T.

	If lHSM
		cNewFunc := "HSMGETCERTFILE"
		&cNewFunc.("slot_"+SpedGetMv("MV_HSMSLOT",_cIdEnt)+"-label_"+SpedGetMv("MV_HSMLABE",_cIdEnt),cFile)
	EndIf
	nHandle      := FOpen( cFile, 0 )
	nBuffer      := FSEEK(nHandle,0,FS_END)

	FSeek( nHandle, 0 )
	If nHandle > 0
		FRead( nHandle , cCertificado , nBuffer )
		FClose( nHandle )
	Else
		Conout("Certificado nao encontrado no diretorio Certs - Realizar a configuracao do certificado para entidade "+_cIdEnt+" !")
		lExistCert := .F.
	EndIf
	If lExistCert
		nAt := AT("BEGIN CERTIFICATE", cCertificado)
		If (nAt > 0)
			nAt := nAt + 22
			cCertificado := substr(cCertificado, nAt)
		EndIf
		nRat := AT("END CERTIFICATE", cCertificado)
		If (nRAt > 0)
			nRat := nRat - 6
			cCertificado := substr(cCertificado, 1, nRat)
		EndIf
		cCertificado := StrTran(cCertificado, Chr(13),"")
		cCertificado := StrTran(cCertificado, Chr(10),"")
		cCertificado := StrTran(cCertificado, Chr(13)+Chr(10),"")
	EndIf

Return(cCertificado)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณREFRESHT	บAutor  ณRenato Nogueira     บ Data ณ  03/06/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณBotใo utilizado para dar refresh na tela de manifesto		  บฑฑ
ฑฑบ          ณ														      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametro ณ Nenhum                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑบRetorno   ณ Nenhum                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function REFRESHT()

	Local cQuery 		:= ""
	Local cAlias 		:= "QRYTEMP"
	Local nY			:= 0

	oGet:aCols := {}

	//Monta aCols

	cQuery := " SELECT Z9_FILIAL, Z9_NOMFOR, Z9_VALORNF, Z9_CHAVE, Z9_NFEORI, Z9_SERORI, Z9_DTEMIS, Z9_STATUSA, R_E_C_N_O_ "
	cQuery += " FROM "+RetSqlName("SZ9")+" Z9 "
	cQuery += " WHERE Z9.D_E_L_E_T_=' ' AND Z9_STATUS='0' AND Z9_FILIAL='"+cFilAnt+"' "
	cQuery += " ORDER BY Z9_DTEMIS "

	If !Empty(Select(cAlias))
		DbSelectArea(cAlias)
		(cAlias)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

	dbSelectArea(cAlias)
	(cAlias)->(dbGoTop())

	While !(cAlias)->(Eof())

		AADD(oGet:aCols,Array(Len(aHeader)+1))

		For nY := 1 To Len(aHeader)

			DO CASE
			CASE AllTrim(aHeader[nY][2]) =  "Z9_FILIAL"
				oGet:aCols[Len(oGet:aCols)][nY] := (cAlias)->Z9_FILIAL
			CASE AllTrim(aHeader[nY][2]) =  "Z9_NOMFOR"
				oGet:aCols[Len(oGet:aCols)][nY] := (cAlias)->Z9_NOMFOR
			CASE AllTrim(aHeader[nY][2]) =  "Z9_VALORNF"
				oGet:aCols[Len(oGet:aCols)][nY] := (cAlias)->Z9_VALORNF
			CASE AllTrim(aHeader[nY][2]) =  "Z9_CHAVE"
				oGet:aCols[Len(oGet:aCols)][nY] := (cAlias)->Z9_CHAVE
			CASE AllTrim(aHeader[nY][2]) =  "Z9_NFEORI"
				oGet:aCols[Len(oGet:aCols)][nY] := (cAlias)->Z9_NFEORI
			CASE AllTrim(aHeader[nY][2]) =  "Z9_SERORI"
				oGet:aCols[Len(oGet:aCols)][nY] := (cAlias)->Z9_SERORI
			CASE AllTrim(aHeader[nY][2]) =  "Z9_DTEMIS"
				oGet:aCols[Len(oGet:aCols)][nY] := DTOC(STOD((cAlias)->Z9_DTEMIS))
			CASE AllTrim(aHeader[nY][2]) =  "Z9_STATUSA"
				oGet:aCols[Len(oGet:aCols)][nY] := (cAlias)->Z9_STATUSA
			CASE AllTrim(aHeader[nY][2]) =  "Z9_MANIF"
				oGet:aCols[Len(oGet:aCols)][nY] := "5"
			ENDCASE

		Next

		oGet:aCols[Len(oGet:aCols)][Len(aHeader)+1] := .F.

		(cAlias)->(DbSkip())

	EndDo

	oGet:oBrowse:Refresh()
	oGet:Refresh()

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVLDSTAT	บAutor  ณRenato Nogueira     บ Data ณ  03/06/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณValida status para manifesta็ใo							  บฑฑ
ฑฑบ          ณ														      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametro ณ Nenhum                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑบRetorno   ณ Nenhum                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function VLDSTAT()

	Local _lRet		:= .T.
	Local _nManif	:= aScan(aHeader,{|x| Trim(x[2])=="Z9_MANIF"})
	Local _nStaAtu	:= aScan(aHeader,{|x| Trim(x[2])=="Z9_STATUSA"})

	If AllTrim(UPPER(aCols[n][_nStaAtu]))=="CIENCIA" .And. AllTrim(&(ReadVar()))=="4"
		MsgAlert("Aten็ใo, essa nota jแ foi manifestada com ci๊ncia da opera็ใo, favor escolher outra op็ใo")
		_lRet	:= .F.
	ElseIf AllTrim(UPPER(aCols[n][_nStaAtu]))=="NF CANCELADA"
		MsgAlert("Aten็ใo, essa nota foi cancelada, opera็ใo nใo permitida!")
		_lRet	:= .F.
	ElseIf Empty(&(ReadVar()))
		MsgAlert("Favor escolha uma op็ใo!")
		_lRet	:= .F.
	EndIf

Return(_lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVERDANFE	บAutor  ณRenato Nogueira     บ Data ณ  03/06/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณMostra Danfe a partir do xml 								  บฑฑ
ฑฑบ          ณ														      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametro ณ Nenhum                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑบRetorno   ณ Nenhum                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function VERDANFE()

	Local _nPosChave	:= aScan(aHeader,{|x| Trim(x[2])=="Z9_CHAVE"})
	Local _nPosXml		:= aScan(aHeader,{|x| Trim(x[2])=="Z9_XML"})
	Local _aAreaSZ9		:= GetArea("SZ9")
	Local _aArea		:= GetArea()
	Local oNfe
	Local cAviso     	:= ""
	Local cErro      	:= ""

	cAviso := ""
	cErro  := ""

	DbSelectArea("SZ9")
	SZ9->(DbSetOrder(1))
	SZ9->(DbGoTop())

	If SZ9->(DbSeek(xFilial("SZ9")+aCols[oGet:nAt][_nPosChave]))

		IF !Empty(SZ9->Z9_XML)

			_cXml:= Alltrim(SZ9->Z9_XML)
			_cXml:= FwCutOff(_cXml, .t.)
			oNfe := XmlParser(_cXml,"_",@cAviso,@cErro)

			If (oNfe == NIL )
				MsgStop("Falha ao gerar Objeto XML : "+cAviso+" / "+cErro)
				Return
			EndIf

			U_VISDANFE(oNfe)
		Else
			MsgAlert("Aten็ใo, o xml desta NF nใo estแ disponํvel, verifique!")
		EndIf

	EndIf

	RestArea(_aArea)
	RestArea(_aAreaSZ9)

Return()

User Function XVERDANFE(_cchave)


	Local _aAreaSZ9		:= GetArea("SZ9")
	Local _aArea		:= GetArea()
	Local oNfe
	Local cAviso     	:= ""
	Local cErro      	:= ""

	cAviso := ""
	cErro  := ""

	DbSelectArea("SZ9")
	SZ9->(DbGoTop())
	SZ9->(DbSetOrder(1))
	If SZ9->(DbSeek(xFilial("SZ9")+Alltrim(_cchave)))

		IF !(Empty(SZ9->Z9_XML))

			_cXml:= Alltrim(SZ9->Z9_XML)
			_cXml:= FwCutOff(_cXml, .t.)
			oNfe := XmlParser(_cXml,"_",@cAviso,@cErro)

			If (oNfe == NIL )
				MsgStop("Falha ao gerar Objeto XML : "+cAviso+" / "+cErro)
				Return
			EndIf

			U_VISDANFE(oNfe)
		Else
			MsgAlert("Aten็ใo, o xml desta NF nใo estแ disponํvel, verifique!")
		EndIf

	EndIf

	RestArea(_aArea)
	RestArea(_aAreaSZ9)

Return()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFuncao    ณSpedNfeID ณ Autor ณEduardo Riera          ณ Data ณ16.06.2006ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณFuncao de obtencao do ID da nota fiscal eletronica          ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณRetorno   ณExpC1: String                                               ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametrosณExpC1: String com o XML que sera assinado                   ณฑฑ
ฑฑณ          ณExpC3: Tag que contem o ID                                  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ   DATA   ณ Programador   ณManutencao Efetuada                         ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ          ณ               ณ                                            ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function SpedNfeId(cXML,cAttId)
Local nAt  := 0
Local cURI := ""
Local nSoma:= Len(cAttId)+2

nAt := At(cAttId+'=',cXml)
cURI:= SubStr(cXml,nAt+nSoma)
nAt := At('"',cURI)
If nAt == 0
	nAt := At("'",cURI)
EndIf
cURI:= SubStr(cURI,1,nAt-1)
Return(cUri)



/*/{Protheus.doc} SpedGetMV
Rotina que irแ buscar o conteudo parametro SPED
Ticket: 20220307005266
@type function
@version  12.1.27
@author Valdemir Rabelo
@since 16/03/2022
@return variant, String
/*/
Static Function SpedGetMV(cParam,cIdEnt)             
	Local aArea := GetArea()
	cParam := PadR(UPPER(cParam),10)
	dbSelectArea("SPED000")
	dbSetOrder(1)
	If MsSeek(cIdEnt+cParam,.F.)
		Return(AllTrim(SPED000->CONTEUDO))
	Else
		dbSelectArea("SPED000")
		dbSetOrder(1)
		If MsSeek(Space(Len(SPED000->ID_ENT))+cParam,.F.)
			Return(AllTrim(SPED000->CONTEUDO))
		EndIf
	EndIf
	RestArea(aArea)
Return(Nil)
