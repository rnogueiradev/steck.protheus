#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "AP5MAIL.CH"
#Include "TOPCONN.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ ARFAT01 ³ Autor ³ Everson Santana        ³ Data ³31/07/13  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao da Cotação Gráfica                               ³±±
±±³          ³ no Browse da Orçamento do módulo Faturamento chamado       ³±±
±±³          ³ pelo Ponto de Entrada TK271ROTM (Ações Relacionadas)       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico Steck                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Ajuste no texto do e-mail - Everson Santana - 09/08/2018               ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function ARFAT01()

	LOCAL   n := 0
	Local aArea  := GetArea()
	Private mMemo		  	:= ""
	Private cEmail			:= ""
	Private cCopia			:= ""
	
	Private _cVend		  	:= ""
	Private _cTelCli	  	:= ""
	Private _cTransp	  	:= ""
	PRIVATE _nXmargSf7    	:= 0
	PRIVATE oPrint
	PRIVATE _cNomeCom     	:= SM0->M0_NOMECOM
	PRIVATE _cEndereco    	:= SM0->M0_ENDENT
	PRIVATE cCep          	:= SM0->M0_CEPENT
	PRIVATE cCidade       	:= SM0->M0_CIDENT
	PRIVATE cEstado       	:= SM0->M0_ESTENT
	PRIVATE cCNPJ         	:= SM0->M0_CGC
	PRIVATE cTelefone     	:= SM0->M0_TEL
	PRIVATE cFax          	:= SM0->M0_FAX
	PRIVATE cResponsavel	:= Alltrim(MV_PAR04)
	PRIVATE cIe           	:= Alltrim(SM0->M0_INSC)
	PRIVATE _nTotPed      	:= 0
	PRIVATE	nAliqICM      	:= 0
	PRIVATE	nValICms      	:= 0
	PRIVATE nCnt          	:= 0
	PRIVATE	nAliqIPI      	:= 0
	PRIVATE	nValIPI       	:= 0
	PRIVATE	nValICMSST    	:= 0
	PRIVATE	nValSuf    	  	:= 0
	PRIVATE	nValPis       	:= 0
	PRIVATE	nValCof	      	:= 0
	PRIVATE _cxCliContr   	:= "SA1->A1_GRPTRIB"
	PRIVATE _cCliEst      	:= "SA1->A1_EST"
	PRIVATE	titulo	  		:= "Envío de E-Mail - Steck Electric S.A. - Cotización Nº " + SCJ->CJ_NUM
	PRIVATE cBmpName  	  	:= ''
	PRIVATE cStartPath		:= '\arquivos\orcamentobrowse\'//GetSrvProfString("Startpath","") +'orcamento\'
	PRIVATE _cPath		  	:= GetSrvProfString("RootPath","") //GetPvProfString( GetEnvServer(), "RootPath"	, "", GetAdv97() )
	PRIVATE _cNomePdf     	:= ''
	Private _cDirRel      	:= Getmv("MV_RELT",,'C:\ARQUIVOS_PROTHEUS\')
	Private _lxRet        	:= .T.

	dbSelectArea("SA3")
	dbSetOrder(1)
	
	If SA3->(dbSeek(xFilial("SA3") + SCJ->CJ_XCVEND))
		cCopia := IIF(!Empty(SA3->A3_CODUSR),GetEmail(SA3->A3_CODUSR),"")
	EndIf

	DbSelectArea("SCJ")

	Processa({|lEnd|xMontaRel()})

	RestArea(aArea)
Return Nil
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ MontaRel ³ Autor ³ Everson Santana       ³ Data ³31/07/13  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao DO RELATORIO                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico Steck                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function xMontaRel()

	Local lRet := .f.

	If SCJ->CJ_STATUS $ 'B'
		cMsg1 := "El presupuesto en cuestión ya se había convertido en Pedido de Venta."
		cMsg1 += " Por favor acceda al módulo Facturación y realice la impresión de la Solicitud de Venta emitida!"
		MsgAlert(cMsg1)
		Return .F.
	Endif

	if SCJ->(eof())

		msgstop("Presupuesto No Encontrado !!!  Comprobar !!! " )

	else

		_cNomePdf  :=cEmpAnt+"_Presupuesto_"+SCJ->CJ_NUM
		oPrint:= fwmsprinter():New( _cNomePdf , 6      ,.F.             , '\arquivos\orcamentobrowse\'  ,.T.			,  ,  ,  ,  .f.,  ,.f.,.f. )
		oPrint:SetLandScape()     //SetPortrait() ou SetLandscape()
		oPrint:SetMargin(60,60,60,60)
		oPrint:setPaperSize(9)

		DbSelectArea("SA1")
		SA1->(dbSetOrder(1))
		SA1->(DbSeek(xFilial("SA1")+ SCJ->CJ_CLIENTE + SCJ->CJ_LOJA ))

		cEmail 		:= Alltrim(SA1->A1_EMAIL)
		_cVend	  	:= SA1->A1_VEND
		_cTelCli  	:= SA1->A1_TEL
		_cTransp	:= SA1->A1_TRANSP

		Dbselectarea("SE4")
		MsSeek(Xfilial("SE4")  + SCJ->CJ_CONDPAG )

		Dbselectarea("SCJ")

		xImpress()

		// Indique o caminho onde será gravado o PDF
		FERASE(cStartPath+_cNomePdf+".pdf")
		oPrint:cPathPDF := cStartPath//"c:\"
		oPrint:Print()

		If ExistDir(_cDirRel)
			_lxRet := .T.
		Else
			If MakeDir(_cDirRel) == 0
				MakeDir(_cDirRel)
				Aviso("Creación de carpetas","Se ha creado en esa computadora una carpeta para que las cotizaciones emitidas allí sean guardadas después de la impresión ... !!!"+CHR(10)+CHR(13)+;
				CHR(10)+CHR(13)+;
				"Sigue la ruta del directorio creado:"+CHR(10)+CHR(13)+;
				CHR(10)+CHR(13)+;
				_cDirRel,;
				{"OK"},3)
				_lxRet := .T.
			Else
				Aviso("Error en la creación de carpetas","Para guardar el Pedido de Venta en cuestión es necesario que una carpeta sea creada en ese ordenador ... !!!"+CHR(10)+CHR(13)+;
				CHR(10)+CHR(13)+;
				"Por favor, póngase en contacto con el TI para que la creación de la carpeta se realice ... !!!:"+CHR(10)+CHR(13)+;
				CHR(10)+CHR(13)+;
				"No será posible realizar la apertura del Pedido de Venta en archivo PDF y consecuentemente no será enviado vía e-mail al cliente ... !!!",;
				{"OK"},3)
				_lxRet := .F.
			Endif
		Endif

		If _lxRet
			FERASE(_cDirRel+"\"+_cNomePdf+".pdf")
			CpyS2T(cStartPath+_cNomePdf+'.pdf',_cDirRel+"\",.T.) // COPIA ARQUIVO PARA MAQUINA DO USUÁRIO
			
			If FunName() <> "ARAGENDA"
				ShellExecute("open",_cDirRel+"\"+_cNomePdf+'.pdf', "", "", 1)
				
				If MsgBox("Enviar correo electronico al cliente?","Envio de E-Mail","YESNO")
					lRet := _x2lChkMail(cEmail) // Abre tela Para Digitar Manualmente E-Mails

					If lRet
						Processa({|lEnd| xBrEnvMail(oPrint,"Presupuesto: "+ SCJ->CJ_NUM,{"Presupuesto: "+ SCJ->CJ_NUM},cEmail,"",{},10)},titulo)
					EndIf
				Endif
				
			Endif
		Endif
	EndIf

Return nil


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ xImpress ³ Autor ³ Everson Santana       ³ Data ³31/07/13  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao do Relatório                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico Steck                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function xImpress()

	LOCAL _nTxper 	:= GETMV("MV_TXPER")
	LOCAL 	i 			:= 0
	Local _cDMoed		:= "U$S"
	LOCAL oBrush
	Local _nTotIPI  	:= 0
	Local _nTotIVA  	:= 0
	Local _nItemIVA		:= 0
	Local _nTotICMSST	:= 0
	Local _nTotal		:= 0
	Local _nTotSuf		:= 0
	Local _ncount		:= 0
	Local _nMoeda		:= SCJ->CJ_MOEDA
	Local nLineLength 	:= 95
	Local nTabSize 		:= 3
	Local lWrap 		:= .T.

	Local cCodUser := RetCodUsr() //Retorna o Codigo do Usuario
	Local cNamUser := UsrFullName( cCodUser ) +" - "+UsrRetMail ( cCodUser )//Retorna o nome do usuario
	Local _cUsrInc := UsrFullName( SCJ->CJ_XUSRINC )+" - "+DtoC(SCJ->CJ_EMISSAO) // Chamado 008811 - Everson Santana
	Local nLines1 := 0
	Local nCurrentLine := 0

	Private _nLin 		:= 4000

	aBmp := "STECK.BMP"

	//Parâmetros de TFont.New()
	//1.Nome da Fonte (Windows)
	//3.Tamanho em Pixels
	//5.Bold (T/F)
	oFont2n := TFont():New("Times New Roman",,10,,.T.,,,,,.F. )
	oFont8  := TFont():New("Arial",9,8 ,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont9  := TFont():New("Arial",9,9 ,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont10 := TFont():New("Arial",9,10,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont10n:= TFont():New("Arial",9,10,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont11 := TFont():New("Arial",9,11,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont12 := TFont():New("Arial",9,12,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont13 := TFont():New("Arial",9,13,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont13n:= TFont():New("Arial",9,13,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont14n:= TFont():New("Arial",9,14,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont15n:= TFont():New("Arial",9,15,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont16 := TFont():New("Arial",9,16,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont16n:= TFont():New("Arial",9,16,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont17 := TFont():New("Arial",9,17,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont17n:= TFont():New("Arial",9,17,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont20 := TFont():New("Arial",9,18,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont20n:= TFont():New("Arial",9,18,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont18 := TFont():New("Arial",9,18,.T.,.T.,5,.T.,5,.T.,.F.)

	oBrush := TBrush():New("",4)

	_ntotal := 0
	_npagina := 0
	_aItRed	:= {}
	Dbselectarea("SM0")

	oPrint:StartPage()     // INICIALIZA a página
	xCabOrc()

	Dbselectarea("SCK")
	SCK->(Dbsetorder(1))
	SCK->(Dbseek(xfilial("SCK")+Alltrim(SCJ->CJ_NUM)))

	While !eof() .and. Alltrim(SCJ->CJ_NUM) = Alltrim(SCK->CK_NUM)

		DbSelectArea("SA1")
		DbSetOrder(1)
		MsSeek(xFilial("SA1")+SCJ->CJ_CLIENTE+SCJ->CJ_LOJA)

		_nTotIPI    := (nValIPI)+_nTotIPI
		_nTotICMSST := (nValICMSST)+_nTotICMSST
		_nTotSuf	:= (nValSuf)+_nTotSuf

		If _nLin > 580
			_nLin+=10
			oPrint:Say  (_nLin,020, "* * *   C O N T I N Ú A    * * *",oFont12)
			oPrint:EndPage()     // Finaliza a página
			oPrint:StartPage()     // INICIALIZA a página
			xCabOrc()
		Endif

		// Posiciona No Cad Produtos
		DbSelectArea("SB1")
		DbSetOrder(1)
		MsSeek(xFilial("SB1")+SCK->CK_PRODUTO)

		// Posiciona No Cad De TES
		DbSelectArea("SF4")
		DbSetOrder(1)
		MsSeek(xFilial("SF4") + SCK->CK_TES,.t.)

		//Pisicina No Impuestos Variables

		DbSelectArea("SFB")
		DbSetOrder(1)
		MsSeek(xFilial("SFB") + "IVA",.t.)

		_nXmargSf7:= SFB->FB_ALIQ //Posicione('SF7',3,xFilial("SF7")+SB1->B1_GRTRIB+&_cxCliContr+&_cCliEst+&_cTipoCli,'F7_MARGEM')
		_nItemIVA  := ((SCK->CK_VALOR * SFB->FB_ALIQ)/100)

		IF SCK->CK_NUM <> 'N'

			//Impressao do Item
			oPrint:Say  (_nLin,020, SCK->CK_ITEM	,oFont8)

			//Impressao do Codigo e Descricao do Produto
			oPrint:Say  (_nLin,040, SCK->CK_PRODUTO	,oFont8)
			_ctexto  	:= Substr(Posicione('SB1',1,xFilial("SB1")+SCK->CK_PRODUTO,'SB1->B1_DESC'),1,90)
			_ctexto1  	:= Substr(Posicione('SB1',1,xFilial("SB1")+SCK->CK_PRODUTO,'SB1->B1_DESC'),91,90)
			oPrint:Say  (_nLin ,095, _ctexto,oFont8)

			If !Empty(_ctexto1)
				_nLin+=15
				oPrint:Say  (_nLin ,095, _ctexto1,oFont8)
				_nLin-=15
			EndIF

			//Impressao da Quantidade e Unidade de Medida
			oPrint:Say  (_nLin,530, transform(SCK->CK_QTDVEN,"@E 999999.99")	,oFont8)
			oPrint:Say  (_nLin,560, Alltrim(SB1->B1_UM),oFont8)

			//Impressao do Valor Unitario
			oPrint:Say  (_nLin,600, transform(SCK->CK_PRCVEN	,"@E 99,999,999.99")	,oFont8)

			//Impressao do Percentual de IVA
			oPrint:Say  (_nLin,650, transform(_nXmargSf7	,"@E 999.99")	   		,oFont8)

			//Impressao do Valor de IVA
			oPrint:Say  (_nLin,690, transform((_nItemIVA)	,"@E 99,999,999,999.99")		,oFont8) //SUB->UB_ZVALIST

			//Impressao do Valor Total
			oPrint:Say  (_nLin,750, transform(SCK->CK_VALOR	,"@E 9,999,999.99")	,oFont8)
			_nTotal	+= SCK->CK_VALOR
			_nTotIVA += _nItemIVA
			//Impressao do Prazo de Entraga
			//oPrint:Say  (_nLin,750, Dtoc(SCK->CK_ENTREG)	,oFont8)
			//oPrint:Say  (_nLin,650, SubStr(SCK->CK_OBS,1,25)				,oFont8)

			_nItemIVA := 0

			If !Empty(_ctexto1)
				_nLin+=15
			EndIF
		Endif

		_nLin+=15

		If _nLin > 580
			_nLin+=10
			oPrint:Say  (_nLin,020, "* * *   C O N T I N Ú A    * * *",oFont12)
			oPrint:EndPage()     // Finaliza a página
			oPrint:StartPage()     // INICIALIZA a página
			xCabOrc()
		Endif

		Dbselectarea("SCK")
		SCK->(DbSkip())

	End

	If _nLin > 580
		_nLin+=10
		oPrint:Say  (_nLin,020, "* * *   C O N T I N Ú A    * * *",oFont12)
		oPrint:EndPage()     // Finaliza a página
		oPrint:StartPage()     // INICIALIZA a página
		xCabOrc()
	Endif

	oPrint:Line (_nLin, 005,_nLin,800)
	// Imprime Total Do Orcamento
	_nLin+=15
	If _nLin > 580
		_nLin+=10
		oPrint:Say  (_nLin,020, "* * *   C O N T I N Ú A    * * *",oFont12)
		oPrint:EndPage()     // Finaliza a página
		oPrint:StartPage()     // INICIALIZA a página
		xCabOrc()
	Endif
	If _nMoeda == 2
		oPrint:Say  (_nLin,020, "Todos los valores están en Dolar"	,oFont12)
	EndIf

	oPrint:Say  (_nLin,610, "Valor total de los productos (" + _cDMoed + ")"	,oFont10)
	oPrint:Say  (_nLin,740, ": " + Transform(/*SUA->UA_VALMERC*/_nTotal,"@E 9999,999.99")	,oFont10)
	If _nLin > 580
		_nLin+=10
		oPrint:Say  (_nLin,020, "* * *   C O N T I N Ú A    * * *",oFont12)
		oPrint:EndPage()     // Finaliza a página
		oPrint:StartPage()     // INICIALIZA a página
		xCabOrc()
	Endif
	_nLin+=15
	oPrint:Say  (_nLin,610, "Valor total del IVA (" + _cDMoed + ")"			,oFont10)
	oPrint:Say  (_nLin,740, ": " + Transform(_nTotIVA,"@E 9999,999.99")	,oFont10)
	If _nLin > 580
		_nLin+=10
		oPrint:Say  (_nLin,020, "* * *   C O N T I N Ú A    * * *",oFont12)
		oPrint:EndPage()     // Finaliza a página
		oPrint:StartPage()     // INICIALIZA a página
		xCabOrc()
	Endif

	_nLin+=15
	oPrint:Say  (_nLin,610, "Valor total del presupuesto (" + _cDMoed + ")"	,oFont10)
	//oPrint:Say  (_nLin,680, ": " + Transform(SUA->UA_VLRLIQ,"@E 9999,999.99")	,oFont10)
	oPrint:Say  (_nLin,740, ": " + Transform(/*SUA->UA_VLRLIQ*/_nTotal+_nTotIVA,"@E 9999,999.99")	,oFont10)
	If _nLin > 580
		_nLin+=10
		oPrint:Say  (_nLin,020, "* * *   C O N T I N Ú A    * * *",oFont12)
		oPrint:EndPage()     // Finaliza a página
		oPrint:StartPage()     // INICIALIZA a página
		xCabOrc()
	Endif
	_nLin+=15
	If _nLin > 580
		_nLin+=10
		oPrint:Say  (_nLin,020, "* * *   C O N T I N Ú A    * * *",oFont12)
		oPrint:EndPage()     // Finaliza a página
		oPrint:StartPage()     // INICIALIZA a página
		xCabOrc()
	Endif

	If !Empty(SCJ->CJ_XOBS)

		oPrint:Line (_nLin, 005,_nLin,800) // Imprime Linha Fina
		_nLin+=15
		If _nLin > 580
			_nLin+=10
			oPrint:Say  (_nLin,020, "* * *   C O N T I N Ú A    * * *",oFont12)
			oPrint:EndPage()     // Finaliza a página
			oPrint:StartPage()     // INICIALIZA a página
			xCabOrc()
		Endif

		// Observação da Cotação:
		oPrint:Say  (_nLin,020, "Observaciones: "					,oFont12)
		_nLin+=15

		nLines1 := 0
		nCurrentLine1 := 0

		nLines1 := MLCOUNT(Alltrim(SCJ->CJ_XOBS), nLineLength, nTabSize, lWrap)

		FOR nCurrentLine := 1 TO nLines1

			xText1 := MEMOLINE(Alltrim(SCJ->CJ_XOBS), nLineLength, nCurrentLine, nTabSize, lWrap)

			If !Empty(xText1)

				oPrint:Say  (_nLin,020, Alltrim(xText1) 				,oFont10)
				_nLin+=15

			EndIf

			If _nLin > 580
				_nLin+=10

				oPrint:Say  (_nLin,020, "* * *   C O N T I N Ú A    * * *",oFont12)
				oPrint:EndPage()     // Finaliza a página
				oPrint:StartPage()     // INICIALIZA a página
				xCabOrc()
				oPrint:Line (_nLin, 005,_nLin,800) // Imprime Linha Fina
				_nLin+=15
				oPrint:Say  (_nLin,020, "Observaciones: "					,oFont12)
				_nLin+=15
			Endif


		NEXT

		_nLin+=15

		If _nLin > 580
			_nLin+=10
			oPrint:Say  (_nLin,020, "* * *   C O N T I N Ú A    * * *",oFont12)
			oPrint:EndPage()     // Finaliza a página
			oPrint:StartPage()     // INICIALIZA a página
			xCabOrc()
		Endif
		oPrint:Line (_nLin, 005,_nLin,800) // Imprime Linha Fina
	EndIf
	// Inicia Mensagens Do Orcamento
	_nLin+=15
	If _nLin > 580
		_nLin+=10
		oPrint:Say  (_nLin,020, "* * *   C O N T I N Ú A    * * *",oFont12)
		oPrint:EndPage()     // Finaliza a página
		oPrint:StartPage()     // INICIALIZA a página
		xCabOrc()
	Endif

	oPrint:Say  (600,020, "Incluido por: "+_cUsrInc,oFont8) // Chamado 008811 - Everson Santana
	oPrint:Say  (610,020, "Impreso: "+cNamUser+" - " + DtoC(dDataBase)+" - "+TIME() ,oFont8)
	oPrint:EndPage()     // Finaliza a página

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ"±±
±±ºPrograma  ³xCabOrc   ºAutor  ³ Everson Santana    º Data ³ 31/07/13    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Steck                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function xCabOrc()

	Local _aTpDesc := {}
	Local _nPos	 := 0

	oPrint:Box(045,005,580,800)

	If File(aBmp)
		oPrint:SayBitmap(060,020,aBmp,095,050 )
	EndIf

	oPrint:Say  (065,120, _cNomeCom  ,oFont12)
	oPrint:Say  (065,650, "Presupuesto"  ,oFont20n)
	oPrint:Say  (080,120, _cEndereco ,oFont12)
	oPrint:Say  (095,120,"CP: "+ cCep +" - "+Alltrim(cCidade)+" - "+cEstado,oFont12)
	oPrint:Say  (110,120,"TEL.: (005411) 4201-1489 | FAX.: (005411) 4201-7534/8396 | E-MAIL: ventas.ar@steckgroup.com",oFont12)

	dbselectarea("SA1")
	MsSeek(Xfilial("SA1")  + SCJ->CJ_CLIENTE + SCJ->CJ_LOJA )

	oPrint:Box(125,005,230,800)

	oPrint:Say  (140,020,"Cliente: "+ Upper(SA1->A1_NOME)         									,oFont12)
	oPrint:Say  (155,020,"Codigo de Cliente: "+ SCJ->CJ_CLIENTE + " - " + SCJ->CJ_LOJA+ "- Telefono: "+TRANSFORM(_cTelCli,PESQPICT("SA1","A1_TEL"))				,oFont12)

	oPrint:Say  (170,020,"Datos de facturación: " 													,oFont12)
	oPrint:Say  (185,020,"Dirección: "+Upper(Alltrim(SA1->A1_END) + " - " + Alltrim(SA1->A1_BAIRRO) + " - " + Alltrim(SA1->A1_MUN) + " - " + Alltrim(SA1->A1_EST) + " - " + Alltrim(SA1->A1_CEP))         					,oFont12)
	oPrint:Say  (200,020,"C.U.I.T.: "+TRANSFORM(SA1->A1_CGC,PESQPICT("SA1","A1_CGC"))			        			,oFont12)

	_aTpDesc := RetSX3Box(GetSX3Cache("A1_TIPO","X3_CBOX"),,,1)
	_nPos	  := aScan(_aTpDesc,{|x| AllTrim(x[2]) == SA1->A1_TIPO})
	oPrint:Say  (215,020,"Tipo: "+ Alltrim(_aTpDesc[_nPos][03])							   			,oFont12)

	oPrint:Box(230,005,295,800)
	cBmpName  :=SCJ->CJ_NUM
	oPrint:Say  (245,020,"Presupuesto"					,oFont12)
	oPrint:Say  (245,080,": " + SCJ->CJ_NUM				,oFont12)
	oPrint:Say  (245,240,"Emisión" 						,oFont12)
	oPrint:Say  (245,350,": " + dtoc(SCJ->CJ_EMISSAO)	,oFont12)

	dbselectarea("SE4")
	MsSeek(Xfilial("SE4")  + SCJ->CJ_CONDPAG )

	oPrint:Say  (260,020, "Cond. Pago" 						,oFont12)
	oPrint:Say  (260,080, ": " + SE4->E4_DESCRI				,oFont12)
	oPrint:Say  (260,240, "Orden de Compra" 				,oFont12)
	oPrint:Say  (260,350, ": "+ SCJ->CJ_XORPC				,oFont12)

	oPrint:Say  (275,020, "Vendedor" 						,oFont12)
	oPrint:Say  (275,080, ": " + _cVend	+" - "+Alltrim(POSICIONE("SA3",1,XFILIAL("SA3") +_cVend,"A3_NOME"))		,oFont12)

	oPrint:Say  (275,240, "Transportador:" 						,oFont12)
	oPrint:Say  (275,350, ": " + _cTransp	+" - "+Alltrim(POSICIONE("SA4",1,XFILIAL("SA4") +_cTransp,"A4_NOME"))		,oFont12)

	oPrint:Box(295,005,320,800)
	oPrint:Say  (310,020, "Iten"			    ,oFont10)
	oPrint:Say  (310,040, "Codigo"				,oFont10)
	oPrint:Say  (310,095, "Descripción"			,oFont10)

	oPrint:Say  (310,530, "Cantidad"			,oFont10)
	oPrint:Say  (310,565, "UM"					,oFont10)
	oPrint:Say  (310,600, "Unitario"  			,oFont10)
	oPrint:Say  (310,650, "IVA"				    ,oFont10)
	oPrint:Say  (310,700, "Vlr IVA"				,oFont10)
	oPrint:Say  (310,750, "Importe"				,oFont10)
	//oPrint:Say  (310,750, "Fch Entrega"			,oFont10)
	//oPrint:Say  (310,650, "Observaciones"		,oFont10)

	_nLin := 330

Return()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³xBrEnvMail³ Autor ³ Everson Santana       ³ Data ³31/07/13  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Envio Do Orcamento/Cotacao por e-mail automaticamente      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico Steck                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function xBrEnvMail(oGraphic,cAssunto,aTexto,cTo,cCC,aTabela,nEspacos)

	Local cMailConta	:= GETMV("MV_RELACNT")
	Local cMailServer	:= GETMV("MV_RELSERV")
	Local cMailSenha	:= GETMV("MV_RELPSW")
	Local lAuth 		:= GetMv("MV_RELAUTH",,.F.)

	Local lOk			:= .F.
	Local cMensagem
	Local nx			:= 0
	Local lBmp 			:= !( oGraphic == NIL )
	Local  nWidth 		:= 0
	Local cError
	local _aAttach 		:= {}//'c:\six0101.dbf'
	Local _cCaminho		:= cStartPath
	Local _nIni			:= 1
	Local _nFim			:= 100

	cTo := Alltrim(cTo)

	aadd( _aAttach  ,_cNomePdf+'.pdf')

	aTexto   := IIF( aTexto == NIL,{},aTexto )
	aTabela  := IIF( aTabela == NIL,{},aTabela)
	nEspacos := IIF( nEspacos == NIL, 10, nEspacos )

	cMensagem := '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//PT">'
	cMensagem += '<HTML><HEAD>'
	cMensagem += '<META content="text/html; charset=iso-8859-1" http-equiv=Content-Type>'
	cMensagem += '<META content="MSHTML 5.00.2920.0" name=GENERATOR></HEAD>'
	cMensagem += '<BODY aLink=#ff0000 bgColor=#ffffff link=#0000ee text=#000000 '
	cMensagem += 'vLink=#551a8b><B>'

	cMensagem += "<br><font Face='CALIBRI' >" + "Presupuesto enviado automáticamente por el sistema PROTHEUS" + "</font></br>"
	cMensagem += "<br><font Face='CALIBRI' >" + "Enviado por: " + UsrFullName(RetCodUsr()) + "</font></br>"
	cMensagem += "<br><font Face='CALIBRI' >" + "No Responda este correo, por favor, por consultas o comentarios, reenvielo a ventas.ar@steckgroup.com" + "</font></br>"
	cMensagem += "<br><font Face='CALIBRI' >" + "Presupuesto nº: " + SCJ->CJ_NUM + "</font></br>"

	_cMesCorp:= StMSg()
	cMensagem += "<br><div align='left'><font Face='CALIBRI' >"+ strtran(_cMesCorp,'.',".</FONT>  </br></div>   </tr></table></br><div align='left'><font Face='CALIBRI' > ")    +'</FONT></div>'
	cMensagem:=STRTRAN(cMensagem,'ZZZZ','.')
	cMensagem:=STRTRAN(cMensagem,'AAAA',"</FONT></br>  </div>   </tr></table>  <div align='left'><br><font Face='CALIBRI' >")
	cMensagem += '</B>'
	cMensagem += '<BR>&nbsp;</BR>'

	cMensagem += "</CENTER>"
	cMensagem += '</body>'

	ProcRegua(8)

	IncProc()
	IncProc("Conectando servidor...")

	// Envia e-mail com os dados necessarios

	If  !(u_ARMAILTES(cTo,cCopia,titulo,cMensagem,_aAttach,_cCaminho)  )
		MsgInfo("Correo no enviado.....!!!!!")
	EndIf

Return lOk

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³_x2lChkMail³ Autor ³ Everson Santana      ³ Data ³31/07/13  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Caixa De Texto Para Digitação De E-Mail Opcional.          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico Steck                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function _x2lChkMail(cEmail)

	//Variaveis Locais da Funcao
	Local oEdit1
	Local oMemo
	Local _lRet		:= .f.

	cEMail	 		:= cEMail + Space(200)

	// Variaveis Private da Funcao
	Private _oDlg				// Dialog Principal
	Private INCLUI := .F.	// (na Enchoice) .T. Traz registro para Inclusao / .F. Traz registro para Alteracao/Visualizacao

	DEFINE MSDIALOG _oDlg TITLE OemtoAnsi("Envío automático de correo electrónico") FROM C(330),C(243) TO C(500),C(721) PIXEL

	// Cria Componentes Padroes do Sistema
	@ C(013),C(010) Say "Enviar correo electrónico al cliente que aparece a continuación? (Separar por ';')" Size C(167),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(020),C(010) MsGet oEdit1 Var cEMail Size C(218),C(009) COLOR CLR_BLACK PIXEL OF _oDlg Picture "@S60"

	@ C(030),C(010) Say "CC: " + cCopia Size C(167),C(008) COLOR CLR_BLACK PIXEL OF _oDlg 

	@ C(040),C(010) Say "Comentarios" Size C(147),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(047),C(010) Get oMemo Var mMemo of _oDlg MULTILINE Size C(218),C(019) COLOR CLR_BLACK PIXEL

	@ C(070),C(137) Button OemtoAnsi("Enviar") Size C(037),C(012) PIXEL OF _oDlg	Action Eval( { || _lRet:= .t. , _oDlg:End() }  )
	@ C(070),C(185) Button OemtoAnsi("Anular") Size C(037),C(012) PIXEL OF _oDlg	Action(_oDlg:End())

	ACTIVATE MSDIALOG _oDlg CENTERED

	/*
	//Variaveis Locais da Funcao
	Local oEdit1
	Local oMemo
	Local _lRet		:= .f.

	cEMailFor 		:= cEMailFor+Space(200)

	// Variaveis Private da Funcao
	Private _oDlg				// Dialog Principal
	Private INCLUI := .F.	// (na Enchoice) .T. Traz registro para Inclusao / .F. Traz registro para Alteracao/Visualizacao

	DEFINE MSDIALOG _oDlg TITLE OemtoAnsi("Envío automático de correo electrónico") FROM C(330),C(243) TO C(449),C(721) PIXEL


	// Cria Componentes Padroes do Sistema
	@ C(008),C(009) Say "Enviar correo electrónico al cliente que aparece a continuación? (Separar por ';')" Size C(147),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(021),C(010) MsGet oEdit1 Var cEMailFor Size C(218),C(009) COLOR CLR_BLACK PIXEL OF _oDlg Picture "@S60"
	@ C(044),C(137) Button OemtoAnsi("Enviar") Size C(037),C(012) PIXEL OF _oDlg	Action Eval( { || _lRet:= .t. , _oDlg:End() }  )
	@ C(044),C(185) Button OemtoAnsi("Anular") Size C(037),C(012) PIXEL OF _oDlg	Action(_oDlg:End())


	ACTIVATE MSDIALOG _oDlg CENTERED
	*/

Return(_lRet)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³   C()      ³ Autor ³ Everson Santana       ³ Data ³31/07/13  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ³ Funcao responsavel por manter o Layout independente da       ³±±
±±³           ³ resolução horizontal do Monitor do Usuario.                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso        ³ Especifico Steck                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function xC(nTam)
	Local nHRes	:=	oMainWnd:nClientWidth	//Resolucao horizontal do monitor
	Do Case
		Case nHRes == 640	//Resolucao 640x480
		nTam *= 0.8
		Case nHRes == 800	//Resolucao 800x600
		nTam *= 1
		OtherWise			//Resolucao 1024x768 e acima
		nTam *= 1.28
	EndCase
	If "MP8" $ oApp:cVersion
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Tratamento para tema "Flat"³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If (Alltrim(GetTheme()) == "FLAT").Or. SetMdiChild()
			nTam *= 0.90
		EndIf
	EndIf
Return Int(nTam)

Static Function StMSg()
	Local _cText:= 	"<br><font Face='ARIAL' style='color:#0000FF;' >Comentarios:</br> "+;
	mMemo+"</font>"+;
	"<br>Estimado cliente, Gracias por requerir nuestra cotización. Si desea realizar consultas acerca de este presupuesto, no dude en comunicarse con nosotros.-"+;
	" (La existencia/stock de los materiales cotizados, queda supeditado a su venta previa)</br>"+;
	" Muchas gracias. Cordiales saludos.-"

Return  (alltrim(_cText))

//-------------------------------------------------------------------
// Busca e-mail conforme parâmetro passado
// Input: Model
// Retorno: String
//-------------------------------------------------------------------
Static Function GetEmail(cUsuMail)
	Local aGrpMail := Separa(cUsuMail,"/",.F.)
	Local nX   := 0
	Local cRET := ""
	Local cCodTMP := ""

	if VldUsu(cUsuMail)
	   PswOrder(2)
		if PswSeek( cUsuMail, .T. )
			cCodTMP := PswID()
		endif
	   cRET := UsrRetMail( cCodTMP ) 
	else
		For nX := 1 to Len(aGrpMail)
			if nX > 1
			cRET += ";"
			Endif
			cRET += UsrRetMail(aGrpMail[nX])
		Next
	Endif

Return cRET

//-------------------------------------------------------------------
// Valida Usuário. Verifica se foi passado usuário 
// Input: Model
// Retorno: Lógico
//-------------------------------------------------------------------
Static Function Vldusu(pcUsuMail)
	Local lRET := .F.
	Local aVld := Separa("A/a/E/e/I/i/O/o/U/u",'/')
	Local nX   := 0

	For nX := 1 to Len(aVld)
		if !lRET
		   lRET := (At(aVld[nX], pcUsuMail) > 0)
		Endif
	Next

Return lRET
