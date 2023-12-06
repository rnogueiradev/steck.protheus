#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STVECAPDIA ºAutor  ³Renato Nogueira    º Data ³  20/08/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function STTMKR01()

	Local oReport

	PutSx1( "STCAP", "01","Data?","","","mv_ch1","D",8,0,0,"G","","","","","mv_par01","","","","","","","","","","","","","","","","")
	PutSx1( "STCAP", "02","(S) Sintético ou (A) Analítico?","","","mv_ch2","C",1,0,0,,"","","","","mv_par02","","","","","","","","","","","","","","","","")

	oReport		:= ReportDef()
	oReport		:PrintDialog()

Return

Static Function ReportDef()

	Local oReport
	Local oSection
	Local oSection1
	//Local oSection2

	oReport := TReport():New("STCAP","RELATÓRIO DE CAPTAÇÃO DIÁRIO","STCAP",{|oReport| ReportPrint(oReport)},"Este programa irá imprimir um relatório de captação diário.")

	Pergunte("STCAP",.F.)

	If mv_par02="S"

		oSection := TRSection():New(oReport,"CAPTAÇÃO DO DIA",{"SC6"})

		TRCell():New(oSection,"TOTCIMP" ,"SC6","TOTAL COM IMPOSTOS","@E 99,999,999.99",14)
		TRCell():New(oSection,"TOTSIMP","SC6","TOTAL SEM IMPOSTOS","@E 99,999,999.99",14)

		oSection:SetHeaderSection(.T.)
		oSection:Setnofilter("SC6")

	Elseif mv_par02="A"

		oSection1 := TRSection():New(oReport,"CAPTAÇÃO DO DIA",{"SC6"})

		//    01        02   03  04       				05 							06 	07  08	09	10
		TRCell():New(oSection1,"01",  	,"PEDIDO"				,  							,06	,.F.,	,	,	)
		TRCell():New(oSection1,"02",	,"TOTAL COM IMPOSTOS","@E 99,999,999.99"		,14	,	,	,	,	)
		TRCell():New(oSection1,"03",	,"TOTAL SEM IMPOSTOS","@E 99,999,999.99"		,14	,	,	,	,	)
		TRCell():New(oSection1,"04",	,"NOME CLIENTE"		,"@!"						,60	,	,	,	,	)
		TRCell():New(oSection1,"15",	,"ORIGEM"			,"@!"						,20	,	,	,	,	)
		TRCell():New(oSection1,"05",	,"FRETE","@!"			,1							,	,	,	,	,	)
		TRCell():New(oSection1,"06",	,"COND PAGTO"			,"@!"						,15	,	,	,	,	)
		TRCell():New(oSection1,"07",	,"VEND 1","@!"		,6							,	,	,	,	,	)
		TRCell():New(oSection1,"08",	,"VEND 2","@!"		,6							,	,	,	,	,	)
		TRCell():New(oSection1,"09",	,"FRETE CLIENTE"		,"@!"						,1	,	,	,	,	)
		TRCell():New(oSection1,"10",	,"VALOR CIF"			,"@E 99,999,999,999.99"	,14	,	,	,	,	)

		//oSection2 := TRSection():New(oReport,"LOG FRETE",{"SC6"})
		TRCell():New(oSection1,"11",	,"TIPO"	    		,"@!"						,10	,	,	,	,	)
		TRCell():New(oSection1,"12",	,"LOG DE FRETE"		,"@!"						,250,	,	,	,	)
		TRCell():New(oSection1,"13",	,"DE"					,"@!"						,5	,	,	,	,	)
		TRCell():New(oSection1,"14",	,"ATE"	    			,"@!"						,5	,	,	,	,	)

		oSection1:SetHeaderSection(.T.)
		oSection1:Setnofilter("SC6")

		//oSection2:SetHeaderSection(.T.)
		//oSection2:Setnofilter("SC6")

	EndIf

Return oReport

Static Function ReportPrint(oReport)

	Local oSection	:= oReport:Section(1)
	Local oSection1	:= oReport:Section(1)
	//Local oSection2	:= oReport:Section(2)
	Local nX			:= 0
	Local cQuery 	:= ""
	Local cAlias 		:= "QRYTEMP9"
	Local aDados[2]
	Local aDados1[99]
	Local nValLiq 	:= 0
	Local nValBrut	:= 0
	Local aEmpQry  := {}
	Local _n, _i
	Local aEmpresa := {}

	dData := DTOS(mv_par01)

	If mv_par02="S"

		oSection:Cell("TOTCIMP"):SetBlock( { || aDados[1] } )
		oSection:Cell("TOTSIMP"):SetBlock( { || aDados[2] } )

	ElseIf mv_par02="A"

		oSection1:Cell("01"):SetBlock( { || aDados1[1] } )
		oSection1:Cell("02"):SetBlock( { || aDados1[2] } )
		oSection1:Cell("03"):SetBlock( { || aDados1[3] } )
		oSection1:Cell("04"):SetBlock( { || aDados1[4] } )
		oSection1:Cell("05"):SetBlock( { || aDados1[5] } )
		oSection1:Cell("06"):SetBlock( { || aDados1[6] } )
		oSection1:Cell("07"):SetBlock( { || aDados1[7] } )
		oSection1:Cell("08"):SetBlock( { || aDados1[8] } )
		oSection1:Cell("09"):SetBlock( { || aDados1[9] } )
		oSection1:Cell("10"):SetBlock( { || aDados1[10] } )

		oSection1:Cell("11"):SetBlock( { || aDados1[11] } )
		oSection1:Cell("12"):SetBlock( { || aDados1[12] } )
		oSection1:Cell("13"):SetBlock( { || aDados1[13] } )
		oSection1:Cell("14"):SetBlock( { || aDados1[14] } )
		oSection1:Cell("15"):SetBlock( { || aDados1[15] } )

	EndIf

	oReport:SetTitle("Captação do dia")// Titulo do relatório

	aEmpQry := MarkFile()

	For _n := 1 to Len(aEmpQry)
		If aEmpQry[_n][1]
			AADD(aEmpresa,aEmpQry[_n][2])
		EndIf
	Next _n

	If Len(aEmpresa)==0
		MsgAlert("Atenção, nenhuma empresa foi selecionada!")
		Return
	EndIf

	If mv_par02="S"

		cQuery := " SELECT SUM(C6_VALOR) C6_VALOR, SUM(C6_ZVALLIQ) C6_ZVALLIQ FROM (

		For _i := 1 to Len(aEmpresa)

			If _i > 1
				cQuery += " UNION ALL"
			EndIf

			cQuery += " SELECT SUM(CASE WHEN C6_BLQ = 'R' THEN C6_VALOR/C6_QTDVEN*C6_QTDENT ELSE C6_VALOR END) C6_VALOR,

			If aEmpresa[_i]="01"
				cQuery += " SUM(CASE WHEN C6_BLQ = 'R' AND C6_ZVALLIQ > 0 THEN C6_ZVALLIQ/C6_QTDVEN*C6_QTDENT WHEN C6_ZVALLIQ > 0 THEN C6_ZVALLIQ WHEN C6_BLQ = 'R' THEN C6_VALOR/C6_QTDVEN*C6_QTDENT ELSE C6_VALOR END) C6_ZVALLIQ
			Else
				cQuery += " SUM(CASE WHEN C6_BLQ = 'R' THEN C6_VALOR/C6_QTDVEN*C6_QTDENT ELSE C6_VALOR END) C6_ZVALLIQ "
			EndIf

			cQuery += " FROM SC5"+aEmpresa[_i]+"0 C5"
			cQuery += " INNER JOIN SC6"+aEmpresa[_i]+"0 SC6 ON C5_FILIAL = C6_FILIAL AND C5_NUM = C6_NUM AND C5_CLIENTE = C6_CLI AND C5_LOJACLI = C6_LOJA AND SC6.D_E_L_E_T_ = ' '
			cQuery += " LEFT JOIN SA1"+aEmpresa[_i]+"0 SA1 ON C5_CLIENTE=A1_COD AND C5_LOJACLI=A1_LOJA AND SA1.D_E_L_E_T_ <> '*'
			cQuery += " LEFT JOIN SF4"+aEmpresa[_i]+"0 SF4 ON C6_TES = F4_CODIGO AND SF4.D_E_L_E_T_ = ' ' "
			cQuery += " LEFT JOIN SB1"+aEmpresa[_i]+"0 SB1 ON B1_COD = C6_PRODUTO AND SB1.D_E_L_E_T_ = ' ' "
			cQuery += " LEFT JOIN SBM"+aEmpresa[_i]+"0 SBM ON B1_GRUPO = BM_GRUPO AND SBM.D_E_L_E_T_ = ' ' "

			If aEmpresa[_i]="01"
				cQuery += " LEFT JOIN PC1"+aEmpresa[_i]+"0 PC1 ON C6_NUM=PC1_PEDREP AND PC1.D_E_L_E_T_ = ' ' "
			EndIf

			cQuery += " WHERE
			cQuery += " C5_EMISSAO= '"+dData+"' AND
			cQuery += " C5_TIPO='N' AND
			cQuery += " A1_GRPVEN NOT IN ('ST','SC') AND
			cQuery += " A1_EST<>'EX' AND
			cQuery += " F4_DUPLIC = 'S' AND
			cQuery += " A1_COD NOT IN ('033467','019886','012047','033833' ) AND
			cQuery += " C6_CF IN ('5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5403','5501','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6501','6502','7101','7102') AND
			cQuery += " C5_ZOPERAD<>' ' AND

			If aEmpresa[_i]="01"
				cQuery += " PC1_PEDREP IS NULL AND C5_FILIAL='02' AND
			EndIf

			cQuery += " C5.D_E_L_E_T_=' '

		Next

		cQuery += " ) XXX

	Elseif mv_par02="A"

		cQuery := " SELECT C6_NUM, C6_VALOR, C6_ZVALLIQ, A1_NOME, A1_TPFRET, FRETE, A1_XCIF, CONDPAG, VEND1, VEND2, LOGFRE, C5_XMDE, C5_XMATE, C5_XDE, C5_XATE, C5_XDANO, C5_XAANO, C5_XORIG, C5_ZEDI  FROM (

		For _i := 1 to Len(aEmpresa)

			If _i > 1
				cQuery += " UNION ALL"
			EndIf

			cQuery += " SELECT C6_NUM, SUM(CASE WHEN C6_BLQ = 'R' THEN C6_VALOR/C6_QTDVEN*C6_QTDENT ELSE C6_VALOR END) C6_VALOR, "

			If aEmpresa[_i]="01"
				cQuery += " SUM(CASE WHEN C6_BLQ = 'R' AND C6_ZVALLIQ > 0 THEN C6_ZVALLIQ/C6_QTDVEN*C6_QTDENT WHEN C6_ZVALLIQ > 0 THEN C6_ZVALLIQ WHEN C6_BLQ = 'R' THEN C6_VALOR/C6_QTDVEN*C6_QTDENT ELSE C6_VALOR END) C6_ZVALLIQ,
			Else
				cQuery += " SUM(CASE WHEN C6_BLQ = 'R' THEN C6_VALOR/C6_QTDVEN*C6_QTDENT ELSE C6_VALOR END) C6_ZVALLIQ, "
			EndIf
			cQuery += " A1_NOME, A1_TPFRET, C5_TPFRETE FRETE, A1_XCIF, C5_CONDPAG CONDPAG, C5_VEND1 VEND1,C5_VEND2 VEND2, C5_XLOGFRE LOGFRE, "
			cQuery += " NVL(C5_XMDE,' ') C5_XMDE, NVL(C5_XMATE,' ') C5_XMATE, NVL(C5_XDE,' ') C5_XDE, NVL(C5_XATE,' ') C5_XATE, NVL(C5_XDANO,' ') C5_XDANO, NVL(C5_XAANO,' ') C5_XAANO, C5_XORIG, C5_ZEDI "
			cQuery += " FROM SC5"+aEmpresa[_i]+"0 C5"
			cQuery += " INNER JOIN SC6"+aEmpresa[_i]+"0 C6 ON C6_FILIAL=C5_FILIAL AND C5_NUM=C6_NUM AND C5_CLIENTE=C6_CLI AND C5_LOJACLI=C6_LOJA AND C6.D_E_L_E_T_ <> '*' "
			cQuery += " LEFT JOIN SA1"+aEmpresa[_i]+"0 SA1 ON C5_CLIENTE=A1_COD AND C5_LOJACLI=A1_LOJA AND SA1.D_E_L_E_T_ <> '*'
			cQuery += " LEFT JOIN SF4"+aEmpresa[_i]+"0 SF4 ON C6_TES = F4_CODIGO AND SF4.D_E_L_E_T_ = ' ' "
			cQuery += " LEFT JOIN SB1"+aEmpresa[_i]+"0 SB1 ON B1_COD = C6_PRODUTO AND SB1.D_E_L_E_T_ = ' ' "
			cQuery += " LEFT JOIN SBM"+aEmpresa[_i]+"0 SBM ON B1_GRUPO = BM_GRUPO AND SBM.D_E_L_E_T_ = ' ' "

			If aEmpresa[_i]="01"
				cQuery += " LEFT JOIN PC1"+aEmpresa[_i]+"0 PC1 ON C6_NUM=PC1_PEDREP AND PC1.D_E_L_E_T_ = ' ' "
			EndIf

			cQuery += " WHERE
			cQuery += " C5_EMISSAO= '"+dData+"' AND
			cQuery += " C5_TIPO='N' AND
			cQuery += " A1_GRPVEN NOT IN ('ST','SC') AND
			cQuery += " A1_EST<>'EX' AND
			cQuery += " F4_DUPLIC = 'S' AND
			cQuery += " A1_COD NOT IN ('033467','019886','012047','033833' ) AND
			cQuery += " C6_CF IN ('5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5403','5501','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6501','6502','7101','7102') AND
			cQuery += " C5_ZOPERAD<>' ' AND

			If aEmpresa[_i]="01"
				cQuery += " PC1_PEDREP IS NULL AND C5_FILIAL='02' AND
			EndIf

			cQuery += " C5.D_E_L_E_T_=' '
			cQuery += " GROUP BY C6_NUM, A1_NOME, A1_TPFRET, C5_TPFRETE, A1_XCIF, C5_CONDPAG, C5_VEND1, C5_VEND2, C5_XLOGFRE, C5_XMDE "
			cQuery += " ,C5_XDE, C5_XATE, C5_XDANO, C5_XMATE, C5_XAANO, C5_XORIG, C5_ZEDI "

		Next

		cQuery += " ) XXX
		cQuery += " ORDER BY C5_XORIG

	Endif

	If !Empty(Select(cAlias))
		DbSelectArea(cAlias)
		(cAlias)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

	oReport:SetMeter(0)
	aFill(aDados,nil)
	aFill(aDados1,nil)
	//	oSection:Init()

	If mv_par02="S"

		oSection:Init()

		dbSelectArea(cAlias)
		(cAlias)->(dbGoTop())
		While !(cAlias)->(Eof())
			nX++

			nValBrut	+=	(cAlias)->C6_VALOR
			nValLiq		+=  (cAlias)->C6_ZVALLIQ

			aDados[1]	:=	(cAlias)->C6_VALOR
			aDados[2]	:=	(cAlias)->C6_ZVALLIQ

			oSection:PrintLine()
			aFill(aDados,nil)

			(cAlias)->(DbSkip())

		EndDo

		oReport:SkipLine()

	ElseIf mv_par02="A"

		oSection1:Init()
		//oSection2:init()
		dbSelectArea(cAlias)
		(cAlias)->(dbGoTop())
		While !(cAlias)->(Eof())
			nX++

			nValLiq		+=  (cAlias)->C6_ZVALLIQ
			nValBrut	+=	(cAlias)->C6_VALOR

			aDados1[1]	:=	(cAlias)->C6_NUM
			aDados1[2]	:=	(cAlias)->C6_VALOR
			aDados1[3]	:=	(cAlias)->C6_ZVALLIQ
			aDados1[4]	:=	(cAlias)->A1_NOME
			aDados1[5]	:=	(cAlias)->FRETE

			DbSelectArea("SE4")
			DbSetOrder(1)
			DbSeek(xFilial("SE4")+(cAlias)->CONDPAG)

			If !SE4->(Eof())
				aDados1[6]	:=	SE4->E4_DESCRI
			EndIf

			aDados1[7]			:=	(cAlias)->VEND1
			aDados1[8]			:=	(cAlias)->VEND2
			aDados1[9]			:=	(cAlias)->A1_TPFRET
			aDados1[10]		:=	(cAlias)->A1_XCIF

			If Empty(Alltrim((cAlias)->C5_XMDE))
				aDados1[11]	:=  (cAlias)->C5_XDE
				aDados1[12]	:=	(cAlias)->LOGFRE
				aDados1[13]	:=  (cAlias)->C5_XATE
				aDados1[14]	:=  'Mensal'
			Else
				aDados1[11]	:=  (cAlias)->C5_XDE+'/'+(cAlias)->C5_XMDE+'/'+(cAlias)->C5_XDANO
				aDados1[12]	:=	(cAlias)->LOGFRE
				aDados1[13]	:=  (cAlias)->C5_XATE+'/'+(cAlias)->C5_XMATE+'/'+(cAlias)->C5_XAANO
				aDados1[14]	:=  'Intervalo'

			EndIf

			DO CASE
			Case AllTrim(UPPER((cAlias)->C5_ZEDI))=="S"
				aDados1[15]	:=  "EDI"
			CASE Empty((cAlias)->C5_XORIG)
				aDados1[15]	:=  "Normal"
			CASE AllTrim((cAlias)->C5_XORIG)=="1" //Portal do cliente
				aDados1[15]	:=  "Portal do cliente"
			CASE AllTrim((cAlias)->C5_XORIG)=="2" //Marketplaces
				aDados1[15]	:=  "MarketPlaces"
			ENDCASE

			oSection1:PrintLine()
			//oSection2:Printline()

			aFill(aDados1,nil)

			(cAlias)->(DbSkip())

		EndDo

		oReport:SkipLine()

		aDados1[2]	:=	nValBrut
		aDados1[3]	:=	nValLiq

		oSection1:PrintLine()
		aFill(aDados1,nil)

	EndIf

	DbSelectArea(cAlias)
	(cAlias)->(dbCloseArea())

Return oReport

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MARKFILE ºAutor  ³ Vitor Merguizo     º Data ³  08/09/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função auxiliar para seleção de Arquivos                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function MarkFile()

	Local aArea		:= SM0->(GetArea())
	Local aChaveArq := {}
	Local lSelecao	:= .T.
	Local cTitulo 	:= "Seleção de Empresas para Geração de Relatorio: "
	Local cEmpresa	:= ""
	Local bCondicao := {|| .T.}

	// Variáveis utilizadas na seleção de categorias
	Local oChkQual,lQual,oQual,cVarQ

	// Carrega bitmaps
	Local oOk := LoadBitmap( GetResources(), "LBOK")
	Local oNo := LoadBitmap( GetResources(), "LBNO")

	// Variáveis utilizadas para lista de filiais
	Local nx := 0
	Local nAchou := 0

	DbSelectArea("SM0")
	DbSetOrder(1)
	SM0->(DbGoTop())

	While SM0->(!Eof())
		If SM0->M0_CODIGO <> cEmpresa .And. SM0->M0_CODIGO $ "01#03" //Não Carrega a EMpresa 06
			//+--------------------------------------------------------------------+
			//| aChaveArq - Contem os arquivos que serão exibidos para seleção |
			//+--------------------------------------------------------------------+
			AADD(aChaveArq,{.F.,SM0->M0_CODIGO,SM0->M0_NOMECOM})
		EndIf
		cEmpresa := SM0->M0_CODIGO
		SM0->(dbSkip())
	EndDo

	If Empty(aChaveArq)
		ApMsgAlert("Nao foi possivel Localizar Empresas.")
		RestArea(aArea)
		Return aChaveArq
	EndIf

	RestArea(aArea)

	//+--------------------------------------------------------------------+
	//| Monta tela para seleção dos arquivos contidos no diretório |
	//+--------------------------------------------------------------------+
	DEFINE MSDIALOG oDlg TITLE cTitulo STYLE DS_MODALFRAME From 145,0 To 445,628 OF oMainWnd PIXEL
	oDlg:lEscClose := .F.
	@ 05,15 TO 125,300 OF oDlg PIXEL
	@ 15,20 CHECKBOX oChkQual VAR lQual PROMPT "Inverte Seleção" SIZE 50, 10 OF oDlg PIXEL;
	ON CLICK (AEval(aChaveArq, {|z| z[1] := If(z[1]==.T.,.F.,.T.)}),oQual:Refresh(.F.))
	@ 30,20 LISTBOX oQual VAR cVarQ Fields HEADER "","Codigo","Nome" SIZE;
	273,090 ON DBLCLICK (aChaveArq:=Troca(oQual:nAt,aChaveArq),oQual:Refresh()) NoScroll OF oDlg PIXEL
	oQual:SetArray(aChaveArq)
	oQual:bLine := { || {If(aChaveArq[oQual:nAt,1],oOk,oNo),aChaveArq[oQual:nAt,2],aChaveArq[oQual:nAt,3]}}
	DEFINE SBUTTON FROM 134,240 TYPE 1 ACTION IIF(MarcaOk(aChaveArq),(lSelecao := .T., oDlg:End(),.T.),.F.) ENABLE OF oDlg
	DEFINE SBUTTON FROM 134,270 TYPE 2 ACTION (lSelecao := .F., oDlg:End()) ENABLE OF oDlg
	ACTIVATE MSDIALOG oDlg CENTERED

RETURN aChaveArq

//Função auxiliar: TROCA()
Static Function Troca(nIt,aArray)
	aArray[nIt,1] := !aArray[nIt,1]
Return aArray

//Função auxiliar: MARCAOK()
Static Function MarcaOk(aArray)
	Local lRet:=.F.
	Local nx:=0
	// Checa marcações efetuadas
	For nx:=1 To Len(aArray)
		If aArray[nx,1]
			lRet:=.T.
		EndIf
	Next
	// Checa se existe algum item marcado na confirmação
	If !lRet
		MsgAlert("Não existem Empresas marcadas")
	EndIf
Return lRet