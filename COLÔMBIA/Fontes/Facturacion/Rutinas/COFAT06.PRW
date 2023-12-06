#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "AP5MAIL.CH"
#Include "TOPCONN.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"

/*/{Protheus.doc} COFAT06
@type function
@author Everson Santana
@since 21/05/2019
@version Protheus 12 - Faturamento
/*/

User Function COFAT06()

	LOCAL   n := 0
	Local aArea  := GetArea()
	Private cEmailFor	  := ""
	PRIVATE oPrint
	PRIVATE _cNomeCom     := SM0->M0_NOMECOM
	PRIVATE _cEndereco    := SM0->M0_ENDENT
	PRIVATE cCep          := SM0->M0_CEPENT
	PRIVATE cCidade       := SM0->M0_CIDENT
	PRIVATE cBairro       := SM0->M0_BAIRENT
	PRIVATE cEstado       := SM0->M0_ESTENT
	PRIVATE cCNPJ         := SM0->M0_CGC
	PRIVATE cTelefone     := SM0->M0_TEL
	PRIVATE cFax          := SM0->M0_FAX
	PRIVATE cIe           := Alltrim(SM0->M0_INSC)
	PRIVATE	cCopia    	:= ""
	PRIVATE	titulo	  	:= "Envío de E-Mail - Steck Electric S.A. - Cotización Nº " + SCJ->CJ_NUM
	//PRIVATE cBmpName  	  :=''
	PRIVATE cStartPath 	  := '\arquivos\invoicecol\'//GetSrvProfString("Startpath","") +'orcamento\'
	PRIVATE _cPath		  := GetSrvProfString("RootPath","") //GetPvProfString( GetEnvServer(), "RootPath"	, "", GetAdv97() )
	PRIVATE _cNomePdf     :=''
	Private _cDirRel      := Getmv("MV_RELT",,'C:\ARQUIVOS_PROTHEUS\')
	Private _lxRet        := .T.

	DbSelectArea("SC7")

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
	Local _lCont := .f.

	If SC7->(eof())

		msgstop("Pedido No Encontrado !!!  Comprobar !!! " )

	else

		_cNomePdf  :=cEmpAnt+"_INVOICE_"+SC7->C7_NUM
		oPrint:= fwmsprinter():New( _cNomePdf , 6      ,.F.             , '\arquivos\invoicecol\'  ,.T.			,  ,  ,  ,  .f.,  ,.f.,.f. )
		oPrint:SetLandScape()     //SetPortrait() ou SetLandscape()
		oPrint:SetMargin(60,60,60,60)
		oPrint:setPaperSize(9)

		DbSelectArea("SA2")
		SA2->(dbSetOrder(1))
		SA2->(DbSeek(xFilial("SA2")+ SC7->C7_FORNECE + SC7->C7_LOJA ))

		cEmailFor := "" //SA1->A1_EMAIL
		//_cVend	  := "" //SA1->A1_VEND
		//_cTelCli  := "" //SA1->A1_TEL
		//_cTransp  := "" //SA1->A1_TRANSP

		Dbselectarea("SE4")
		MsSeek(Xfilial("SE4")  + SC7->C7_COND )

		nCond := SE4->E4_COND

		Dbselectarea("SC7")

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
			/*
			If MsgBox("Enviar correo electrónico al cliente?","Envío de E-Mail","YESNO")

			lRet := U__x2lChkMail() // Abre tela Para Digitar Manualmente E-Mails

			If lRet
			Processa({|lEnd| xBrEnvMail(oPrint,"Presupuesto: "+ SCJ->CJ_NUM,{"Presupuesto: "+ SCJ->CJ_NUM},cEmailFor,"",{},10)},titulo)
			EndIf

			Endif
			*/
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

	LOCAL 	i 			:= 0
	LOCAL oBrush
	Local _nMoeda		:= SC7->C7_MOEDA
	Local nLineLength 	:= 95
	Local nTabSize 		:= 3
	Local lWrap 		:= .T.
	Local _nTotVlr		:= 0
	Local _nTotQtd		:= 0
	Local cCodUser := RetCodUsr() //Retorna o Codigo do Usuario
	Local cNamUser := UsrFullName( cCodUser ) +" - "+UsrRetMail ( cCodUser )//Retorna o nome do usuario
	Local _cUsrInc := ""//UsrFullName( SCJ->CJ_XUSRINC )+" - "+DtoC(SCJ->CJ_EMISSAO) // Chamado 008811 - Everson Santana
	Local nLines1 := 0
	Local nCurrentLine := 0
	Local _aTpDesc := {}
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

	//_ntotal := 0
	_npagina := 0
	_aItRed	:= {}
	Dbselectarea("SM0")

	oPrint:StartPage()     // INICIALIZA a página
	xCabOrc()

	Dbselectarea("SC7")
	SC7->(Dbsetorder(1))
	SC7->(Dbseek(xfilial("SC7")+Alltrim(SC7->C7_NUM)))

	cPed    := Alltrim(SC7->C7_NUM)
	cForLoj := SC7->C7_FORNECE + SC7->C7_LOJA

	While !eof() .and. Alltrim(SC7->C7_NUM) = cPed

		DbSelectArea("SA2")
		DbSetOrder(1)
		MsSeek(xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA)

		_nTotVlr += SC7->C7_TOTAL
		_nTotQtd += SC7->C7_QUANT

		If _nLin > 600
			_nLin+=05
			oPrint:Say  (_nLin,020, "* * *   C O N T I N Ú A    * * *",oFont12)
			oPrint:EndPage()     // Finaliza a página
			oPrint:StartPage()     // INICIALIZA a página
			xCabOrc()
		Endif

		// Posiciona No Cad Produtos
		DbSelectArea("SB1")
		DbSetOrder(1)
		MsSeek(xFilial("SB1")+SC7->C7_PRODUTO)

		// Posiciona No Cad De TES
		DbSelectArea("SF4")
		DbSetOrder(1)
		MsSeek(xFilial("SF4") + SC7->C7_TES,.t.)

		//Pisicina No Impuestos Variables

		//DbSelectArea("SFB")
		//DbSetOrder(1)
		//MsSeek(xFilial("SFB") + "IVA",.t.)

		//_nXmargSf7:= 0 //SFB->FB_ALIQ //Posicione('SF7',3,xFilial("SF7")+SB1->B1_GRTRIB+&_cxCliContr+&_cCliEst+&_cTipoCli,'F7_MARGEM')
		//_nItemIVA  := 0 //((SCK->CK_VALOR * SFB->FB_ALIQ)/100)
		//IF SCK->CK_NUM <> 'N'

		//Impressao do Item
		oPrint:Say  (_nLin,020, SC7->C7_ITEM	,oFont8)

		//Impressao do Codigo e Descricao do Produto
		oPrint:Say  (_nLin,040, SC7->C7_PRODUTO	,oFont8)
		_ctexto  	:= Substr(Posicione('SB1',1,xFilial("SB1")+SC7->C7_PRODUTO,'SB1->B1_DESC'),1,40)
		_ctexto1  	:= Substr(Posicione('SB1',1,xFilial("SB1")+SC7->C7_PRODUTO,'SB1->B1_DESC'),41,100)
		oPrint:Say  (_nLin ,095, _ctexto,oFont8)
		If !Empty(_ctexto1)
			_nLin+=15
			oPrint:Say  (_nLin ,095, _ctexto1,oFont8)
			_nLin-=15
		EndIF
		//Impressao da Quantidade e Unidade de Medida
		oPrint:Say  (_nLin,280, PADl(Alltrim(transform(SC7->C7_QUANT, PesqPict("SC7","C7_QUANT"))),TamSX3("C7_QUANT")[1],"") ,oFont8)

		//Impressao do Valor Unitario
		oPrint:Say  (_nLin,335, PADl(Alltrim(transform(SC7->C7_PRECO	,PesqPict("SC7","C7_PRECO"))),TamSX3("C7_PRECO")[1],"")	,oFont8)

		//Impressao do Valor Total
		oPrint:Say  (_nLin,400, PADl(Alltrim(transform(SC7->C7_TOTAL	,PesqPict("SC7","C7_TOTAL"))),TamSX3("C7_TOTAL")[1],"")	,oFont8)

		//Impressao do Cert
		//oPrint:Say  (_nLin,460, Posicione('SB1',1,xFilial("SB1")+SC7->C7_PRODUTO,'SB1->B1_XCERT')	,oFont8)

		//Impressao do Venc
		//oPrint:Say  (_nLin,535, DtoC(Posicione('SB1',1,xFilial("SB1")+SC7->C7_PRODUTO,'SB1->B1_XVENCER'))	,oFont8)

		//Impressao do NCM-SIM
		oPrint:Say  (_nLin,580, Posicione('SB1',1,xFilial("SB1")+SC7->C7_PRODUTO,'B1_POSIPI')	,oFont8)

		oPrint:Say  (_nLin,530, ''	,oFont8)

		//_nItemIVA := 0

		If !Empty(_ctexto1)
			_nLin+=15
		EndIF

		_nLin+=15

		If _nLin > 600
			_nLin+=05
			oPrint:Say  (_nLin,020, "* * *   C O N T I N Ú A    * * *",oFont12)
			oPrint:EndPage()     // Finaliza a página
			oPrint:StartPage()     // INICIALIZA a página
			xCabOrc()
		Endif

		Dbselectarea("SC7")
		SC7->(DbSkip())

	End

	If _nLin > 600
		_nLin+=05
		oPrint:Say  (_nLin,020, "* * *   C O N T I N Ú A    * * *",oFont12)
		oPrint:EndPage()     // Finaliza a página
		oPrint:StartPage()     // INICIALIZA a página
		xCabOrc()
	Endif

	oPrint:Say  (_nLin,230, "Total -> ",oFont10)
	oPrint:Say  (_nLin,280, PADl(Alltrim(transform(_nTotQtd, PesqPict("SC7","C7_QUANT"))),TamSX3("C7_QUANT")[1],"") ,oFont8)
	oPrint:Say  (_nLin,400, PADl(Alltrim(transform(_nTotVlr	,PesqPict("SC7","C7_TOTAL"))),TamSX3("C7_TOTAL")[1],"")	,oFont8)

	_nLin+=5

	oPrint:Line (_nLin, 005,_nLin,800)
	// Imprime Total Do Orcamento
	_nLin+=15
	If _nLin > 600
		_nLin+=05
		oPrint:Say  (_nLin,020, "* * *   C O N T I N Ú A    * * *",oFont12)
		oPrint:EndPage()     // Finaliza a página
		oPrint:StartPage()     // INICIALIZA a página
		xCabOrc()
	Endif

	oPrint:Say  (_nLin,020, "Peso Neto: "  		,oFont10)
	If _nLin > 600
		_nLin+=05
		oPrint:Say  (_nLin,020, "* * *   C O N T I N Ú A    * * *",oFont12)
		oPrint:EndPage()     // Finaliza a página
		oPrint:StartPage()     // INICIALIZA a página
		xCabOrc()
	Endif
	_nLin+=15
	oPrint:Say  (_nLin,020, "Peso Bruto: " 			,oFont10)
	If _nLin > 600
		_nLin+=05
		oPrint:Say  (_nLin,020, "* * *   C O N T I N Ú A    * * *",oFont12)
		oPrint:EndPage()     // Finaliza a página
		oPrint:StartPage()     // INICIALIZA a página
		xCabOrc()
	Endif

	_nLin+=15
	oPrint:Say  (_nLin,020, "Volumen: " 		,oFont10)
	If _nLin > 600
		_nLin+=05
		oPrint:Say  (_nLin,020, "* * *   C O N T I N Ú A    * * *",oFont12)
		oPrint:EndPage()     // Finaliza a página
		oPrint:StartPage()     // INICIALIZA a página
		xCabOrc()
	Endif
	_nLin+=15
	oPrint:Say  (_nLin,020, "Total: " 		,oFont10)
	If _nLin > 600
		_nLin+=05
		oPrint:Say  (_nLin,020, "* * *   C O N T I N Ú A    * * *",oFont12)
		oPrint:EndPage()     // Finaliza a página
		oPrint:StartPage()     // INICIALIZA a página
		xCabOrc()
	Endif

	oPrint:Line (_nLin, 315,_nLin,500)
	_nLin+=15
	oPrint:Say  (_nLin,320, "Departamento Importación/Exportación"	,oFont12)

	If _nLin > 600
		_nLin+=05
		oPrint:Say  (_nLin,020, "* * *   C O N T I N Ú A    * * *",oFont12)
		oPrint:EndPage()     // Finaliza a página
		oPrint:StartPage()     // INICIALIZA a página
		xCabOrc()
	Endif

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

	oPrint:Box(045,005,610,800)

	If File(aBmp)
		oPrint:SayBitmap(050,040,aBmp,105,050 )
	EndIf

	oPrint:Say  (110,010, UPPER(Alltrim(Posicione('SA2',1,xFilial("SA2")+SC7->C7_FORNECE + SC7->C7_LOJA,'A2_NOME'))) ,oFont10)
	oPrint:Say  (120,010, UPPER(Alltrim(Posicione('SA2',1,xFilial("SA2")+SC7->C7_FORNECE + SC7->C7_LOJA,'A2_END'))) ,oFont10)
	oPrint:Say  (130,010, UPPER(Alltrim(Posicione('SA2',1,xFilial("SA2")+SC7->C7_FORNECE + SC7->C7_LOJA,'A2_BAIRRO'))) ,oFont10)

	oPrint:Box(045,198,140,198)

	oPrint:Say  (065,200,"Importador / Consignatario: "+ _cNomeCom  ,oFont20n)
	oPrint:Say  (080,200, Alltrim(_cEndereco)+" "+Alltrim(cBairro)+" "+Alltrim(cCidade)+" ARGENTINA" ,oFont12)
	oPrint:Say  (095,200,"CP: "+ cCep +" - "+Alltrim(cCidade)+" - "+cEstado,oFont12)
	oPrint:Say  (110,200,"N° de CUIT.: "+TRANSFORM(cCNPJ,PESQPICT("SM0","M0_CGC"))			        			  ,oFont12)
	oPrint:Say  (125,200,"Noticar: TEL.: (005411) 4201-1489 | FAX.: (005411) 4201-7534/8396 ",oFont12)

	oPrint:Box(045,640,080,800)
	oPrint:Say  (060,645,"Local/Fecha"  ,oFont12)
	//oPrint:Say  (075,645, UPPER(Alltrim(Posicione('Z27',1,xFilial("Z27")+SC7->C7_NUM+SC7->C7_FORNECE + SC7->C7_LOJA,'Z27->Z27_LOCAL'))+", "+Alltrim(Str(Day(SC7->C7_EMISSAO)))+" de "+MesExtenso(SC7->C7_EMISSAO)+" de "+Alltrim(Str(Year(SC7->C7_EMISSAO)))) ,oFont10)

	oPrint:Box(080,640,095,800)
	oPrint:Say  (090,645,"Factura: "  ,oFont12)

	oPrint:Box(095,640,140,800)
	oPrint:Say  (110,645,"Cond. Pago"  ,oFont12)
	oPrint:Say  (125,645,UPPER(Alltrim(nCond) + " días de la fecha del arribo")  ,oFont10)

	oPrint:Box(140,005,165,800)

	oPrint:Say  (155,020,"Marca: "  			,oFont12)
	oPrint:Say  (155,220,"Pedido Brasil: "			,oFont12)
	oPrint:Say  (155,420,"Pedido Colômbia: "+Alltrim(SC7->C7_NUM),oFont12)

	oPrint:Box(160,005,195,800)

	oPrint:Say  (175,020,"Puerto de Embarque:"  	,oFont12)
	//oPrint:Say  (190,020,Posicione('Z27',1,xFilial("Z27")+SC7->C7_NUM+SC7->C7_FORNECE + SC7->C7_LOJA,'Z27->Z27_EMBARQ')  		,oFont10)
	oPrint:Say  (175,220,"Destino Final:"			,oFont12)
	//oPrint:Say  (190,220,Posicione('Z27',1,xFilial("Z27")+SC7->C7_NUM+SC7->C7_FORNECE + SC7->C7_LOJA,'Z27->Z27_DESTIN')    	,oFont10)
	oPrint:Say  (175,420,"Puerto de Desemb:"		,oFont12)
	//oPrint:Say  (190,420,Posicione('Z27',1,xFilial("Z27")+SC7->C7_NUM+SC7->C7_FORNECE + SC7->C7_LOJA,'Z27->Z27_DESEMB')   	,oFont10)

	oPrint:Say  (210,020, "Iten"			,oFont10)
	oPrint:Say  (210,040, "Codigo"			,oFont10)
	oPrint:Say  (210,095, "Descripción"		,oFont10)
	oPrint:Say  (210,285, "Cantidad"		,oFont10)
	oPrint:Say  (210,335, "Unitario"	,oFont10)
	oPrint:Say  (210,405, "Total"		,oFont10)
	oPrint:Say  (210,465, "Certificado"		,oFont10)
	oPrint:Say  (210,525, "Vencimiento"		,oFont10)
	oPrint:Say  (210,585, "NCM-SIM"			,oFont10)
	oPrint:Say  (210,650, "Licencia"		,oFont10)
	oPrint:Say  (210,720, "Seguridad"		,oFont10)
	oPrint:Say  (210,770, "Origen"			,oFont10)

	_nLin := 225

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
/*
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
*/
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
