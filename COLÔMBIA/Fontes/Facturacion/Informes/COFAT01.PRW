#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "AP5MAIL.CH"
#Include "TOPCONN.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"

//Alinhamentos
#Define PAD_LEFT    0
#Define PAD_RIGHT   1
#Define PAD_CENTER  2
#Define PAD_JUSTIFY 3 //Opção disponível somente a partir da versão 1.6.2 da TOTVS Printer

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ COFAT01 ³ Autor ³ Everson Santana        ³ Data ³31/07/13  ³±±
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

User Function COFAT01()

	LOCAL n 				:= 0
	Local aArea  			:= GetArea()
	Private cEmailFor		:= ""
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
	PRIVATE cResponsavel  	:= Alltrim(MV_PAR04)
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
	PRIVATE	cCopia    		:= ""
	PRIVATE	titulo	  		:= "Envío de E-Mail - Steck Andina S.A. - Cotización Nº " + SCJ->CJ_NUM
	PRIVATE cBmpName  	  	:=''
	PRIVATE cStartPath 	  	:= '\arquivos\orcamentobrowse\'//GetSrvProfString("Startpath","") +'orcamento\'
	PRIVATE _cPath		  	:= GetSrvProfString("RootPath","") //GetPvProfString( GetEnvServer(), "RootPath"	, "", GetAdv97() )
	PRIVATE _cNomePdf     	:=''
	Private _cDirRel      	:= Getmv("MV_RELT",,'C:\ARQUIVOS_PROTHEUS\')
	Private _lxRet        	:= .T.

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
		//cMsg1 += " Por favor acceda al módulo Facturación y realice la impresión de la Solicitud de Venta emitida!"

		If ApMsgYesNo(cMsg1 + " Confirma impression del informe de Pedido de Venta?")
			If !Empty(SCJ->CJ_XNUMSC5)
				If SC5->(dbSeek(xFilial("SC5") + SCJ->CJ_XNUMSC5))
					u_COFAT02()
				Else
					MsgAlert("Atencion. Ocorreo un error...")
				Endif
			EndIf
		EndIf

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

		cEmailFor := SA1->A1_EMAIL
		_cVend	  := SA1->A1_VEND
		_cTelCli  := SA1->A1_TEL
		_cTransp  := SC5->C5_TRANSP

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
			ShellExecute("open",_cDirRel+"\"+_cNomePdf+'.pdf', "", "", 1)
			If MsgBox("Enviar correo electrónico al cliente?","Envío de E-Mail","YESNO")

				lRet := U__x2lChkMail() // Abre tela Para Digitar Manualmente E-Mails

				If lRet
					Processa({|lEnd| xBrEnvMail(oPrint,"Presupuesto: "+ SCJ->CJ_NUM,{"Presupuesto: "+ SCJ->CJ_NUM},cEmailFor,"",{},10)},titulo)
				EndIf

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

	LOCAL _nTxper 		:= GETMV("MV_TXPER")
	LOCAL 	i 			:= 0
	LOCAL oBrush
	Local _nTotIPI  	:= 0
	Local _nTotIVA  	:= 0
	Local _nItemIVA		:= 0
	Local _nTotICMSST	:= 0
	Local _nTotal		:= 0
	Local _nTotSuf		:= 0
	Local _ncount		:= 0
	Local nLineLength 	:= 95
	Local nTabSize 		:= 3
	Local lWrap 		:= .T.

	Local cCodUser := RetCodUsr() //Retorna o Codigo do Usuario
	Local cNamUser := UsrFullName( cCodUser ) +" - "+UsrRetMail ( cCodUser )//Retorna o nome do usuario
	Local _cUsrInc := UsrFullName( SCJ->CJ_XUSRINC )+" - "+DtoC(SCJ->CJ_EMISSAO) // Chamado 008811 - Everson Santana
	Local nLines1 := 0
	Local nCurrentLine := 0
	Local nx := 0

	Private _nLin 		:= 4000
	Private _nMoeda		:= SCJ->CJ_MOEDA
	Private _cDMoed		:= IIF(_nMoeda = 1, "COP", "US$")

	Private cNomeFont  := "Arial"
	Private oFontDet   := TFont():New(cNomeFont,16, -14, .T., .F., 5, .T., 5, .T., .T.)
	Private oFontDetN  := TFont():New(cNomeFont,16, -14, .T., .T., 5, .T., 5, .T., .F.)

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
			_ctexto  	:= Substr(Posicione('SB1',1,xFilial("SB1")+SCK->CK_PRODUTO,'SB1->B1_DESC'),1,50)
			_ctexto1  	:= Substr(Posicione('SB1',1,xFilial("SB1")+SCK->CK_PRODUTO,'SB1->B1_DESC'),51,100)
			oPrint:Say  (_nLin ,095, _ctexto,oFont8)

			If !Empty(_ctexto1)
				_nLin+=15
				oPrint:Say  (_nLin ,095, _ctexto1,oFont8)
				_nLin-=15
			EndIF

			//Impressao da Quantidade e Unidade de Medida
			oPrint:Say  (_nLin,350, transform(SCK->CK_QTDVEN,"@E 999999.99")	,oFont8)
			oPrint:Say  (_nLin,390, Alltrim(SB1->B1_UM),oFont8)

			//Impressao do Valor Unitario
			oPrint:Say  (_nLin,410, transform(SCK->CK_PRCVEN	,"@E 99,999,999.99")	,oFont8)

			If _nMoeda == 1
				//Impressao do Percentual de IVA
				oPrint:Say  (_nLin,460, transform(_nXmargSf7	,"@E 999.99")	   		,oFont8)

				//Impressao do Valor de IVA
				oPrint:Say  (_nLin,490, transform((_nItemIVA)	,"@E 99,999,999,999.99")		,oFont8) //SUB->UB_ZVALIST
			EndIf

			//Impressao do Valor Total
			oPrint:Say  (_nLin,560, transform(SCK->CK_VALOR	,"@E 9,999,999.99")	,oFont8)

			_nTotal	+= SCK->CK_VALOR
			_nTotIVA += _nItemIVA

			//Impressao do Prazo de Entraga
			oPrint:Say  (_nLin,610, Dtoc(SCK->CK_ENTREG)	,oFont8)
			oPrint:Say  (_nLin,660, SubStr(SCK->CK_OBS,1,25)				,oFont8)

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

	oPrint:Say  (_nLin,550, "Valor total de los productos (" + _cDMoed + ")"	,oFont10)
	oPrint:Say  (_nLin,680, ": " + Transform(_nTotal,"@E 99,999,999,999.99")	,oFont10)

	If _nLin > 580
		_nLin+=10
		oPrint:Say  (_nLin,020, "* * *   C O N T I N Ú A    * * *",oFont12)
		oPrint:EndPage()     // Finaliza a página
		oPrint:StartPage()     // INICIALIZA a página
		xCabOrc()
	Endif

	_nLin+=15

	If _nMoeda == 1
		oPrint:Say  (_nLin,550, "Valor total del IVA (" + _cDMoed + ")"			,oFont10)
		oPrint:Say  (_nLin,680, ": " + Transform(_nTotIVA,"@E 99,999,999,999.99")	,oFont10)
	EndIf

	If _nLin > 580
		_nLin+=10
		oPrint:Say  (_nLin,020, "* * *   C O N T I N Ú A    * * *",oFont12)
		oPrint:EndPage()     // Finaliza a página
		oPrint:StartPage()     // INICIALIZA a página
		xCabOrc()
	Endif

	_nLin+=15
	oPrint:Say  (_nLin,550, "Valor total del presupuesto (" + _cDMoed + ")"	,oFont10)

	If AllTrim(SCJ->CJ_XTPED)=="B"
		_nTotIVA := 0
	EndIf

	oPrint:Say  (_nLin,680, ": " + Transform(_nTotal+_nTotIVA,"@E 99,999,999,999.99")	,oFont10)

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

	oPrint:Say  (600,010, "Somos contribuyentes de ICA en la ciudad de Bogotá.",oFont20n)
	oPrint:Say  (615,010, "Los precios que se relacionan en esta cotización son acordados en la ciudad de Bogotá.",oFont20n)

/*
	oPrint:Say  (600,020, "Incluido por: "+_cUsrInc,oFont8) // Chamado 008811 - Everson Santana
	oPrint:Say  (610,020, "Impreso: "+cNamUser+" - " + DtoC(dDataBase)+" - "+TIME() ,oFont8)
*/

	oPrint:EndPage()     // Finaliza a página

	//chamado 20231009012628 - inclusao cláusulas

	oPrint:StartPage()

	xCabOrc("CL")

	aTexto     := fCriaTexto()
	nLinAtu    := 130
	nLinFin    := 550
	nColIni    := 050
	nColFin    := 580
	nEspCol    := (nColFin-(nColIni+150))/13
	nColMeio   := (nColFin-nColIni)/2

	oPrint:SayAlign(nLinAtu, nColIni, "Clausulas",                         oFontDetN,   (nColFin - nColIni),    300, , PAD_JUSTIFY,  )

	nLinAtu += 30

	for nX := 1 to len(aTexto)
		if substr(aTexto[nX],1,6) = "Global"
			oPrint:SayAlign(nLinAtu, nColIni, aTexto[nX],                         oFontDetN,   (nColFin - nColIni),    300, , PAD_JUSTIFY,  )
		else
			oPrint:SayAlign(nLinAtu, nColIni, aTexto[nX],                         oFontDet ,   (nColFin - nColIni),    300, , PAD_JUSTIFY,  )
		ENDIF
		nLinAtu += 15
		if nLinAtu > nLinFin
			oPrint:EndPage()     // Finaliza a página
			oPrint:StartPage()     // INICIALIZA a página
			xCabOrc("CL")
			nLinAtu    := 130
		endif
	NEXT
	//Encerrando a impressão e exibindo o pdf
	oPrint:EndPage()

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

Static Function xCabOrc(cCBC)

	Local _aTpDesc 	:= {}
	Local _nPos	 	:= 0
	Local cTelCab	:= Getmv("MV_TELCAB",,"+57 311 8764988")
	Local cEmailCab	:= Getmv("MV_EMAILCT",,"ventas.co@steckgroup.com")

	default cCBC = ''

	oPrint:Box(045,005,600,800)

	If File(aBmp)
		oPrint:SayBitmap(060,020,aBmp,095,050 )
	EndIf

	oPrint:Say  (065,120, _cNomeCom  ,oFont12)
	oPrint:Say  (065,650, "Presupuesto"  ,oFont20n)
	oPrint:Say  (080,120, _cEndereco ,oFont12)
	oPrint:Say  (095,120, "CP: "+ cCep +" - "+Alltrim(cCidade)+" - "+cEstado,oFont12)
	oPrint:Say  (110,120, "TEL.: " + Alltrim(cTelCab) + " | E-MAIL: " + Alltrim(cEmailCab),oFont12)

	dbselectarea("SA1")
	MsSeek(Xfilial("SA1")  + SCJ->CJ_CLIENTE + SCJ->CJ_LOJA )

	if !Empty(cCBC)
		oPrint:Box(125,005,125,800)
	else
		oPrint:Box(125,005,230,800)

		oPrint:Say  (140,020,"Cliente: "+ Upper(SA1->A1_NOME)         									,oFont12)
		oPrint:Say  (155,020,"Codigo de Cliente: "+ SCJ->CJ_CLIENTE + " - " + SCJ->CJ_LOJA+ "- Telefono: "+TRANSFORM(_cTelCli,PESQPICT("SA1","A1_TEL"))				,oFont12)

		oPrint:Say  (170,020,"Datos de facturación: " 													,oFont12)
		oPrint:Say  (185,020,"Dirección: "+Upper(Alltrim(SA1->A1_END) + " - " + Alltrim(SA1->A1_BAIRRO) + " - " + Alltrim(SA1->A1_MUN) + " - " + Alltrim(SA1->A1_EST) + " - " + Alltrim(SA1->A1_CEP))         					,oFont12)
		oPrint:Say  (200,020,"NIT.: "+TRANSFORM(SA1->A1_CGC,PESQPICT("SA1","A1_CGC"))			        			,oFont12)

		If _nMoeda == 1
			_aTpDesc := RetSX3Box(GetSX3Cache("A1_TIPO","X3_CBOXSPA"),,,1)
			_nPos	  := aScan(_aTpDesc,{|x| AllTrim(x[2]) == SA1->A1_TIPO})
			oPrint:Say  (215,020,"Tipo: "+ Alltrim(_aTpDesc[_nPos][03])							   			,oFont12)
		Endif

		oPrint:Box(230,005,295,800)
		cBmpName  :=SCJ->CJ_NUM

		oPrint:Say  (245,020,"Presupuesto"					,oFont12)
		oPrint:Say  (245,090,": " + SCJ->CJ_NUM				,oFont12)
		oPrint:Say  (245,240,"Emisión" 						,oFont12)
		oPrint:Say  (245,350,": " + dtoc(SCJ->CJ_EMISSAO)	,oFont12)

		dbselectarea("SE4")
		MsSeek(Xfilial("SE4")  + SCJ->CJ_CONDPAG )

		oPrint:Say  (260,020, "Cond. Pago" 						,oFont12)
		oPrint:Say  (260,090, ": " + SE4->E4_DESCRI				,oFont12)
		oPrint:Say  (260,240, "Orden de Compra" 				,oFont12)
		oPrint:Say  (260,350, ": "+ SCJ->CJ_XORPC				,oFont12)

		oPrint:Say  (275,020, "Vendedor" 						,oFont12)
		oPrint:Say  (275,090, ": " + _cVend	+" - "+Alltrim(POSICIONE("SA3",1,XFILIAL("SA3") +_cVend,"A3_NOME"))		,oFont12)

		oPrint:Say  (290,020, "Transportador",					oFont12)
		oPrint:Say  (290,090, ": " + IIF (!Empty(_cTransp), _cTransp	+" - "+Alltrim(POSICIONE("SA4",1,XFILIAL("SA4") +_cTransp,"A4_NOME")),"")		,oFont12)

		oPrint:Box(295,005,320,800)
		oPrint:Say  (310,020, "Iten"			    ,oFont10)
		oPrint:Say  (310,040, "Codigo"				,oFont10)
		oPrint:Say  (310,095, "Descripción"			,oFont10)

		oPrint:Say  (310,350, "Cantidad"			,oFont10)
		oPrint:Say  (310,390, "UM"					,oFont10)
		oPrint:Say  (310,420, "Unitario"  			,oFont10)
		oPrint:Say  (310,465, "IVA"				    ,oFont10)
		oPrint:Say  (310,500, "Vlr IVA"				,oFont10)
		oPrint:Say  (310,560, "Importe"				,oFont10)
		oPrint:Say  (310,610, "Fch Entrega"			,oFont10)
		oPrint:Say  (310,660, "Observaciones"		,oFont10)
	ENDIF
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
	Local lBmp := !( oGraphic == NIL )
	Local  nWidth := 0
	Local cError
	local _aAttach := {}//'c:\six0101.dbf'
	Local _cCaminho:=cStartPath
	Local _nIni:=1
	Local _nFim:=100

	aadd( _aAttach  ,_cNomePdf+'.pdf')
	If Empty(cCC)

	EndIf

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
	//cMensagem += "<br><font Face='CALIBRI' >" + "ATENCIÓN! No responda este correo. Reenvíe su respuesta a la siguiente dirección: ventas.ar@steckgroup.com" + "</font></br>"
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

	If  !(	U_ARMAILTES(cEmailFor,cCopia,titulo,cMensagem,_aAttach,_cCaminho)  )
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
User Function _x2lChkMail()

	//Variaveis Locais da Funcao
	Local oEdit1
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
	Local _cText:= "Estimado cliente, Gracias por requerir nuestra cotización. Si desea realizar consultas acerca de este presupuesto, no dude en comunicarse con nosotros.-"+;
	" (La existencia/stock de los materiales cotizados, queda supeditado a su venta previa)"+;
	" Muchas gracias. Cordiales saludos.-"

Return  (alltrim(_cText))

Static Function fCriaTexto()
	Local aTexto    := {}
	local cTexto    := ''

	cTexto := "Global Export Control Clauses for Tender, Bid or Quote Submissions" + CRLF
	AADD( aTexto, cTexto )
	cTexto := "" + CRLF
	AADD( aTexto, cTexto )
	cTexto := "This offer is subject to the approval and/or issuance of any required licenses, authorization or approvals by "
	AADD( aTexto, cTexto )
	cTexto := " any relevant government authority. If any required licenses, authorization or approval are not obtained, "
	AADD( aTexto, cTexto )
	cTexto := " whether arising from inaction by any relevant government authority or otherwise, or if any such license "
	AADD( aTexto, cTexto )
	cTexto := " authorization or approvals are denied or revoked, or if the applicable export control laws and/or regulations "
	AADD( aTexto, cTexto )
	cTexto := " would prohibit Seller from fulfilling any order, or would in Seller s judgment otherwise expose Seller to a risk "
	AADD( aTexto, cTexto )
	cTexto := "  of liability under the applicable export control laws and/or regulations if it fulfilled the offer, Seller shall be "
	AADD( aTexto, cTexto )
	cTexto := " excused from all obligation/s under this offer." + CRLF
	AADD( aTexto, cTexto )

	cTexto := "" + CRLF
	AADD( aTexto, cTexto )

	cTexto := "Global Export Control Clauses for Sales and Distributor Contacts or T&Cs" + CRLF
	AADD( aTexto, cTexto )

	cTexto := "" + CRLF
	AADD( aTexto, cTexto )
	cTexto := "The deliverables provided by Seller under this Agreement contain or may contain components and/or "
	AADD( aTexto, cTexto )
	cTexto := " technologies from the United States of America (“US”), the European Union (“EU”) and/or other nations. "
	AADD( aTexto, cTexto )
	cTexto := " Buyer acknowledges and agrees that the supply, assignment and/or usage of the products, software, "
	AADD( aTexto, cTexto )
	cTexto := " services, information, other deliverables and/or the embedded technologies (hereinafter referred to as  "
	AADD( aTexto, cTexto )
	cTexto := " “Deliverables”) under this Agreement shall fully comply with related applicable US, EU and other national and  "
	AADD( aTexto, cTexto )
	cTexto := " international export control laws and/or regulations." + CRLF
	AADD( aTexto, cTexto )

	cTexto := "" + CRLF
	AADD( aTexto, cTexto )
	cTexto := "Unless applicable export license/s has been obtained from the relevant authority and the Seller has approved, "
	AADD( aTexto, cTexto )
	cTexto := " the Deliverables shall not (i) be exported and/or re-exported to any destination and party (may include but not "
	AADD( aTexto, cTexto )
	cTexto := " limited to an individual, group and/or legal entity) restricted by the applicable export control laws and/or "
	AADD( aTexto, cTexto )
	cTexto := " regulations; or (ii) be used for those purposes and fields restricted by the applicable export control laws "
	AADD( aTexto, cTexto )
	cTexto := " and/or regulations. Buyer also agrees that the Deliverables will not be used either directly or indirectly in any "
	AADD( aTexto, cTexto )
	cTexto := " rocket systems or unmanned air vehicles; nor be used in any nuclear weapons delivery systems; and will not "
	AADD( aTexto, cTexto )
	cTexto := " be used in any design, development, production or use for any weapons which may include but not limited to "
	AADD( aTexto, cTexto )
	cTexto := " chemical, biological or nuclear weapons. " + CRLF
	AADD( aTexto, cTexto )

	cTexto := "" + CRLF
	AADD( aTexto, cTexto )
	cTexto := "If any necessary or advisable licenses, authorizations or approvals are not obtained, whether arising from "
	AADD( aTexto, cTexto )
	cTexto := " inaction by any relevant government authority or otherwise, or if any such licenses, authorizations or "
	AADD( aTexto, cTexto )
	cTexto := " approvals are denied or revoked, or if the applicable export control laws and/or regulations would prohibit "
	AADD( aTexto, cTexto )
	cTexto := " Seller from fulfilling any order, or would in Seller s judgment otherwise expose Seller to a risk of liability under "
	AADD( aTexto, cTexto )
	cTexto := " the applicable export control laws and/or regulations if it fulfilled the order, Seller shall be excused from all "
	AADD( aTexto, cTexto )
	cTexto := " obligations under such order and/or this Agreement. " + CRLF
	AADD( aTexto, cTexto )

	cTexto := "" + CRLF
	AADD( aTexto, cTexto )

	cTexto := "Global Export Control Clause for Purchasing and Supplier Contract & T&Cs" + CRLF
	AADD( aTexto, cTexto )

	cTexto := "" + CRLF
	AADD( aTexto, cTexto )
	cTexto := "The Supplier acknowledges that it is fully aware of, and knowledgeable about, the export and re-export "
	AADD( aTexto, cTexto )
	cTexto := " controls regulations, ordinances and laws in the jurisdiction from which the Products are exported or the "
	AADD( aTexto, cTexto )
	cTexto := " Services are provided and agrees to obtain all necessary export and re-export permits or licenses at the "
	AADD( aTexto, cTexto )
	cTexto := " Supplier s expense to ensure that the Purchaser enjoys the full benefit under the relevant Purchase Order "
	AADD( aTexto, cTexto )
	cTexto := " and these T&C. Further, the Supplier shall supply the Purchaser with the information regarding any "
	AADD( aTexto, cTexto )
	cTexto := " applicable export controls rules and required permits or licenses for the Products or Works to be shipped,  "
	AADD( aTexto, cTexto )
	cTexto := " in writing within three (3) working days from the receipt of Purchase Order. The Supplier shall also notify  "
	AADD( aTexto, cTexto )
	cTexto := " in writing of any changes to such export and re-export controls regulations and/or permit or licensing "
	AADD( aTexto, cTexto )
	cTexto := " the Purchaser requirements which may affect the Purchaser s benefits under the Agreement. The Supplier  "
	AADD( aTexto, cTexto )
	cTexto := " comply with all export and re-export controls regulations or rules in relation to the delivery of the Products, "
	AADD( aTexto, cTexto )
	cTexto := " undertakes to the Works and the provision of the Services and shall indemnify Purchaser against all liability,  "
	AADD( aTexto, cTexto )
	cTexto := " losses, damages, and expenses (including reasonable attorney s fees) resulting from the Supplier s   "
	AADD( aTexto, cTexto )
	cTexto := " non-compliance or violations of such export and re-export controls regulations." + CRLF
	AADD( aTexto, cTexto )

Return aTexto
