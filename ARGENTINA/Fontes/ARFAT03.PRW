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
±±³Programa  ³ ARFAT03 ³ Autor ³ Everson Santana        ³ Data ³17/07/18  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³  Remision de venta Gráfica			                      ³±±

±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico Steck                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Ajuste no texto do e-mail - Everson Santana - 09/08/2018               ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function ARFAT03()

	Local cQuery := ''
	Local cRemisi := ""
	Local cRemisf := ""
	Local cSerie  := ""
	Local cTipo   := ""
	Local lRet    := .F.
	Local lPeg	  := .F.	
	Private cTempF := CriaTrab(nil, .f.)
	Private _cPerg 	 := PadR ("ARFAT03", Len (SX1->X1_GRUPO))
	Private cEmailFor	  := ""
	PRIVATE oPrint
	PRIVATE _cNomeCom     := "" // SM0->M0_NOMECOM
	PRIVATE _cEndereco    := "" //SM0->M0_ENDENT
	PRIVATE cCep          := "" //SM0->M0_CEPENT
	PRIVATE cCidade       := "" //SM0->M0_CIDENT
	PRIVATE cEstado       := "" //SM0->M0_ESTENT
	PRIVATE cCNPJ         := "" //SM0->M0_CGC
	PRIVATE cTelefone     := "" //SM0->M0_TEL
	PRIVATE cFax          := "" //SM0->M0_FAX
	PRIVATE cBairro		  := "" //SM0->M0_BAIRENT
	PRIVATE cIe           := "" //Alltrim(SM0->M0_INSC)
	PRIVATE	cCopia    	:= ""
	PRIVATE	titulo	  	:= ""
	PRIVATE cStartPath 	  := '\arquivos\orcamentobrowse\'//GetSrvProfString("Startpath","") +'orcamento\'
	PRIVATE _cPath		  := GetSrvProfString("RootPath","") //GetPvProfString( GetEnvServer(), "RootPath"	, "", GetAdv97() )
	PRIVATE _cNomePdf     :=''
	Private _cDirRel      := Getmv("MV_RELT",,'C:\ARQUIVOS_PROTHEUS\')
	Private _lxRet        := .T.

	//Dbselectarea("SM0")

	ValidPerg()

	lPeg := Pergunte(_cPerg, .T.)

	If lPeg

		cRemisi := MV_PAR01
		cRemisf := MV_PAR02
		cSerie  := MV_PAR03
		cTipo   := MV_PAR04

		If cTipo == 1
			cTipo := "RCN"
		Else
			cTipo := "RFN"
		EndIf

		titulo	  	:= "Envío de E-Mail Remito nº: " + MV_PAR01 + " - Steck Electric S.A "

		If cTipo == "RCN" // remisiones de entrada SF1 y SD1
			cQuery := "SELECT F1_ESPECIE ESPEC, F1_SERIE SERIE, F1_DOC DOCUM, F1_FORNECE CLIEN, F1_LOJA LOJA, F1_EMISSAO FECHA, '' HORA, F1_VALBRUT VALOR, F1_VALMERC MERCA, '' CLAVE, '' AUT, '' VOUCHER,'' F2_VEHICL, "
			cQuery += "F1_TRANSP TRANSP, F1_DESPESA GASTO, F1_FRETE FLETE, F1_DESCONT DESCT, F1_SEGURO SEGUR, D1_DESC, "
			cQuery += "D1_QUANT CANTI, D1_UM UMEDI, D1_VUNIT PRECV, D1_TOTAL TOTAL, D1_LOTECTL LOTE, D1_DTVALID FECVA, D1_PESO PESO, F1_COND COND, D1_PEDIDO PEDIDO, D1_COD PROD,F1_MOEDA MOEDA,F1_CLIORI CLIENT,F1_LOJAORI LOJAENT, "
		Else
			cQuery := "SELECT F2_ESPECIE ESPEC, F2_SERIE SERIE, F2_DOC DOCUM, F2_CLIENTE CLIEN,F2_LOJA LOJA, F2_EMISSAO FECHA, F2_HORA HORA, F2_VALBRUT VALOR, F2_VALMERC MERCA,F2_COMCOT CLAVE ,F2_AUTHCOT AUT, F2_RG1415 VOUCHER, F2_VEHICL,"
			cQuery += "F2_TRANSP TRANSP, F2_DESPESA GASTO, F2_FRETE FLETE, F2_DESCONT DESCT, F2_SEGURO SEGUR, D2_DESC, D2_DESCON, "
			cQuery += "D2_QUANT CANTI, D2_UM UMEDI, D2_PRCVEN PRECV, D2_TOTAL TOTAL, D2_LOTECTL LOTE , D2_DTVALID FECVA, D2_PESO PESO, F2_COND COND, D2_PEDIDO PEDIDO, D2_COD PROD, F2_MOEDA MOEDA, F2_CLIENT CLIENT, F2_LOJENT LOJAENT,  "
		Endif
		cQuery += "A1_NOME, A1_END, A1_BAIRRO, A1_EST, A1_MUN, A1_PAIS, A1_CEP, A1_CGC, B1_DESC,B1_XPAIS "
		If cPaisLoc == 'MEX'
			cQuery += ", A1_NR_END, A1_NROINT "
		EndIf
		if cTipo == "RCN"
			cQuery += "FROM "+RetSqlName("SF1")+" SF1, "+RetSqlName("SA1")+" SA1, "+RetSqlName("SD1")+" SD1, "+RetSqlName("SB1")+" SB1 "
		else
			cQuery += "FROM "+RetSqlName("SF2")+" SF2, "+RetSqlName("SA1")+" SA1, "+RetSqlName("SD2")+" SD2, "+RetSqlName("SB1")+" SB1 "
		endif
		if cTipo == "RCN"
			cQuery += "WHERE  F1_DOC BETWEEN '"+cRemisi+"' AND '"+cRemisf+"' AND F1_SERIE = '"+cSerie+"' AND F1_ESPECIE = '"+cTipo+"' "
			cQuery += "AND F1_FORNECE = A1_COD AND F1_LOJA = A1_LOJA AND F1_DOC = D1_DOC AND F1_SERIE = D1_SERIE AND A1_COD = D1_FORNECE "
			cQuery += "AND A1_LOJA = D1_LOJA AND D1_COD = B1_COD "
			cQuery += "AND F1_FILIAL = '"+xFilial("SF1")+"' AND D1_FILIAL = '"+xFilial("SD1")+"' "
		else
			cQuery += "WHERE  F2_DOC BETWEEN '"+cRemisi+"' AND '"+cRemisf+"' AND F2_SERIE = '"+cSerie+"' AND F2_ESPECIE = '"+cTipo+"' "
			cQuery += "AND F2_CLIENTE = A1_COD AND F2_LOJA = A1_LOJA AND F2_DOC = D2_DOC AND F2_SERIE = D2_SERIE AND A1_COD = D2_CLIENTE "
			cQuery += "AND A1_LOJA = D2_LOJA AND D2_COD = B1_COD "
			cQuery += "AND F2_FILIAL = '"+xFilial("SF2")+"' AND D2_FILIAL = '"+xFilial("SD2")+"' "
		endif
		cQuery += "AND A1_FILIAL = '"+xFilial("SA1")+"' AND B1_FILIAL = '"+xFilial("SB1")+"' "
		cQuery += "AND SA1.D_E_L_E_T_ = ' ' AND SB1.D_E_L_E_T_ = ' ' "
		if cTipo == "RCN"
			cQuery += "AND SF1.D_E_L_E_T_ = ' ' AND SD1.D_E_L_E_T_ = ' ' "
			cQuery += "ORDER BY  F1_DOC"
		else
			cQuery += "AND SF2.D_E_L_E_T_ = ' ' AND SD2.D_E_L_E_T_ = ' ' "
			cQuery += "ORDER BY  F2_DOC "
		endif

		//cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cTempF,.T.,.T.)


		Processa({|lEnd| lRet := xMontaRel()})

	EndIf

	/*
	if !lRet
	MsgInfo("No existen remisiones dentro de los rangos seleccionados")
	ELSE
	MsgInfo ("Impresion Terminada")
	endif
	*/

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

	_cNomePdf  :=cEmpAnt+"_Remito_"+(cTempF)->DOCUM
	oPrint:= fwmsprinter():New( _cNomePdf , 6      ,.F.             , '\orcamentobrowse\'  ,.T.			,  ,  ,  ,  .f.,  ,.f.,.f. )
	oPrint:SetPortrait(.T.)     //SetPortrait() ou SetLandscape()
	oPrint:SetMargin(60,60,60,60)
	oPrint:setPaperSize(9)

	Dbselectarea(cTempF)

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

	Endif


Return nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ xImpress ³ Autor ³ Everson Santana       ³ Data ³19/07/18  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao do Relatório                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico Steck                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function xImpress()

	Local _cDMoed		:= "U$S"
	LOCAL oBrush
	Local _nTotal		:= 0
	Local _cOrLot		:= ''
	Local _nMoeda		:= ""
	Local cnt := 0
	Local nPes := 0
	Local cDoc := ''
	Local cTransp := ''
	Local _cClave := ''
	Local _cAut	  := ''
	Local lRet := .F.
	Local nCount := 0
	Local nTotReg := 0
	Local _nLinF	:= 0
	Local _dEmis	:= ""
	Local _hEmis	:= ""
	Local _nBultos  := 0
	Local _cVoucher := ""
	Local _cPlaca	:= ""
	Private _nLin 		:= 4000
	Private _aRet := {}
	aBmp := "lgrl0701.BMP"

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

	oFont13I:= TFont():New( "Arial"       ,,06,,.f.,,,,,.f. )
	oFont14I:= TFont():New( "Arial"       ,,08,,.F.,,,,,.f. )
	oFont15I:= TFont():New( "Arial"        ,,09,,.t.,,,,,.f. )
	oFont16I:= TFont():New( "Arial"        ,,10,,.f.,,,,,.f. )
	oFont17I:= TFont():New( "Arial"        ,,14,,.T.,,,,,.f. )
	oFont18I:= TFont():New( "Arial"        ,,09,,.T.,,,,,.f. )
	oFont19I:= TFont():New( "Arial"        ,,24,,.T.,,,,,.f. )
	oFont20I:= TFont():New( "Arial Black"   ,,08,,.t.,,,,,.f. )
	oFont21I:= TFont():New( "Arial"        ,,16,,.t.,,,,,.f. )
	oFont22I:= TFont():New( "Arial"        ,,13,,.t.,,,,,.f. )
	oFont23I:= TFont():New( "Arial Black"   ,,15.7,,.t.,,,,,.f. )
	oFont24I:= TFont():New( "Arial Black"   ,,10,,.t.,,,,,.f. )

	oBrush := TBrush():New("",4)

	_ntotal := 0
	_npagina := 0
	_aItRed	:= {}

	_cNomeCom     := SM0->M0_NOMECOM
	_cEndereco    := SM0->M0_ENDENT
	cCep          := SM0->M0_CEPENT
	cCidade       := SM0->M0_CIDENT
	cEstado       := SM0->M0_ESTENT
	cCNPJ         := SM0->M0_CGC
	cTelefone     := SM0->M0_TEL
	cFax          := SM0->M0_FAX
	cBairro		  := SM0->M0_BAIRENT
	cIe           := Alltrim(SM0->M0_INSC)

	count to nCount

	(cTempF)->(dbGoTop())
	ProcRegua(nCount)

	While (!(cTempF)->(EOF()))

		oPrint:StartPage()     // INICIALIZA a página
		xCabOrc()

		cnt++
		cDoc 		:= (cTempF)->DOCUM
		cTransp 	:= (cTempF)->TRANSP
		_nMoeda 	:= (cTempF)->MOEDA
		_cClient	:= (cTempF)->CLIENT+(cTempF)->LOJAENT 
		_cClave 	:= VerChv((cTempF)->SERIE+(cTempF)->DOCUM)
		_cAut	  	:= (cTempF)->AUT
		_dEmis		:= Stod((cTempF)->FECHA)
		_hEmis		:= (cTempF)->HORA
		_cVoucher 	:= (cTempF)->VOUCHER
		_cPlaca 	:=  POSICIONE("DA3", 1, xFilial("DA3") + (cTempF)->F2_VEHICL, "DA3_PLACA")

		If _nMoeda == 1
			_cDMoed := "$"
		Else
			_cDMoed := "U$S"
		EndIF
		nPes 	:= 0
		_nTotal := 0

		While (!(cTempF)->(EOF())) .and. cDoc == (cTempF)->DOCUM

			Incproc()
			//nPes+= (cTempF)->PESO
			_nTotal+=(cTempF)->TOTAL


			If _nLin > 680
				_nLin+=10
				oPrint:Say  (_nLin,020, "* * *   C O N T I N Ú A    * * *",oFont12)
				oPrint:EndPage()     // Finaliza a página
				oPrint:StartPage()     // INICIALIZA a página
				xCabOrc()
			Endif


			oPrint:Line (_nLin-15,105,600,105)
			oPrint:Line (_nLin-15,160,600,160)
			oPrint:Say  (_nLin,010, (cTempF)->PROD	  ,oFont8)
			oPrint:Say  (_nLin,115, TRANSFORM((cTempF)->CANTI,PESQPICT("SD2","D2_QUANT"))	  ,oFont8)
			_cOrLot := VerOrLot( Alltrim( (cTempF)->LOTE)  )
			oPrint:Say  (_nLin,165, Alltrim((cTempF)->B1_DESC) +" " + Alltrim((cTempF)->LOTE) + " " + Alltrim((cTempF)->B1_XPAIS) ,oFont8)

			_nLin+=15

			If _nLin > 680// _nLinF-30
				_nLin+=10
				oPrint:Say  (_nLin,020, "* * *   C O N T I N Ú A    * * *",oFont12)
				oPrint:EndPage()     // Finaliza a página
				oPrint:StartPage()     // INICIALIZA a página
				xCabOrc()
			Endif


			(cTempF)->(dbSkip())

		EndDo

		_nLin := 600 // _nLinF
		oPrint:Line (_nLin, 005,_nLin,560) // Imprime Linha Fina

		_nLin+=15

		_nLin+=15
		oPrint:Say  (_nLin,015, "Direccion de entrega:"					,oFont12)
		_nLin+=15
		oPrint:Say  (_nLin,015, Alltrim(POSICIONE("SA1", 1, xFilial("SA1") + _cClient, "A1_END"))+" "+Alltrim(POSICIONE("SA1", 1, xFilial("SA1") + _cClient, "A1_MUN"))	 ,oFont12)
		_nLin+=15
		oPrint:Line (_nLin, 005,_nLin,560) // Imprime Linha Fina

		_nLin+=15
		
		_aRet := {}

		VerVol(cDoc)

		_nBultos := _aRet[01][01]
		nPes 	:=  _aRet[01][02]

		If Empty(_nBultos)
			_nBultos := 0
		EndIf

		If Empty(nPes)
			nPes := 0
		EndIf

		oPrint:Say  (_nLin,015, "CANT. DE BULTOS:"					,oFont12)
		//oPrint:Say  (_nLin,115, Iif(Empty(_aRet[01][01]),0,TRANSFORM(Val(Str(_aRet[01][01])),PESQPICT("SD2","D2_PESO")))				,oFont12)
		oPrint:Say  (_nLin,115, TRANSFORM(_nBultos,PESQPICT("SD2","D2_PESO"))				,oFont20n)
		oPrint:Say  (_nLin,380, "PESO TOTAL:"					,oFont12)
		oPrint:Say  (_nLin,480, TRANSFORM(nPes,PESQPICT("SD2","D2_PESO"))				,oFont12)
		_nLin+=15
		oPrint:Line (_nLin, 005,_nLin,560) // Imprime Linha Fina

		_nLin+=15
		oPrint:Say  (_nLin,015, "DATOS DEL TRANSPORTISTA: "					,oFont12)
		oPrint:Say  (_nLin,190, Alltrim(POSICIONE("SA4", 1, xFilial("SA4") + cTransp, "A4_NOME")) ,oFont8)
		oPrint:Say  (_nLin,490, "Placa : "+_cPlaca ,oFont8)
		_nLin+=15
		oPrint:Say  (_nLin,015, Alltrim(POSICIONE("SA4", 1, xFilial("SA4") + cTransp, "A4_END"))+" - "+Alltrim(POSICIONE("SA4", 1, xFilial("SA4") + cTransp, "A4_BAIRRO"))+" "+Alltrim(POSICIONE("SA4", 1, xFilial("SA4") + cTransp, "A4_MUN"))				,oFont8)
		_nLin+=15
		oPrint:Say  (_nLin,015, "A efecto de seguro/flete el valor de la mercadería equivale a "+_cDMoed+" "+Alltrim(TRANSFORM(_nTotal,PESQPICT("SD2","D2_TOTAL")))					,oFont12)
		_nLin+=15		
		oPrint:Line (_nLin, 005,_nLin,560) // Imprime Linha Fina

		_nLin+=30
		oPrint:Line (_nLin, 015,_nLin,265) // Imprime Linha Fina
		oPrint:Line (_nLin, 300,_nLin,545) // Imprime Linha Fina
		_nLin+=10
		oPrint:Say  (_nLin,115, "Firma "					,oFont12)
		oPrint:Say  (_nLin,415, "Aclaración "				,oFont12)
		_nLin+=5
		oPrint:Line (_nLin,005,_nLin,560) // Imprime Linha Fina
		_nLin+=10
		oPrint:Say  (_nLin,015, "Clave: "					,oFont12)
		oPrint:Say  (_nLin,045, Alltrim(_cClave)						,oFont8)
		oPrint:Say  (_nLin,200, "C.A.I.: "			,oFont12)
		oPrint:Say  (_nLin,270, Alltrim(_cAut)						,oFont8)
		oPrint:Say  (_nLin,420, "Fecho Vto: "			,oFont12)
		oPrint:Say  (_nLin,490, dtoc(_dEmis+7)						,oFont8)
		
		_nLin+=5
		oPrint:Line (_nLin,005,_nLin,560) // Imprime Linha Fina
		_nLin+=15

		oPrint:Say  (_nLin,015, "Orden de Compra: "		,oFont12)
		oPrint:Say  (_nLin,110, VerOrPc(VerPed(cDoc))				,oFont8)
		//oPrint:Say  (_nLin,200, "Fecho: "				,oFont12)
		//oPrint:Say  (_nLin,235, dtoc(_dEmis)			,oFont8)
		oPrint:Say  (_nLin,360, "Hora: "				,oFont12)
		oPrint:Say  (_nLin,390, _hEmis					,oFont8)
		_nLin+=5

		oPrint:EndPage()     // Finaliza a página

	EndDo

	(cTempF)->(dbCloseArea())
	lRet := cnt > 0

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ"±±
±±ºPrograma  ³xCabOrc   ºAutor  ³ Everson Santana    º Data ³ 19/07/18    º±±
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

	oPrint:Box(045,005,830,560)

	If File(aBmp)
		//oPrint:SayBitmap(060,020,aBmp,095,030 )
		oPrint:SayBitmap(050,020,aBmp,115,050 )         // Valdemir Rabelo 21/12/2021 - Ticket: 20211216026887
	EndIf

	oPrint:Say  (110,015, _cNomeCom  ,oFont12)
	oPrint:Say  (125,015, Alltrim(_cEndereco)+" - "+cBairro ,oFont12)
	oPrint:Say  (140,015,"CP: "+ cCep +" - "+Alltrim(cCidade)+" - "+cEstado,oFont12)
	oPrint:Say  (155,015,"TEL.: (005411) 6288-7879 | TEL.: (005411) 5808-2011",oFont12)      // Valdemir Rabelo 21/12/2021 - Ticket: 20211216026887     
	oPrint:Say  (170,015,"ventas.ar@steckgroup.com",oFont11)
	oPrint:Say  (185,015,"www.steckgroup.com",oFont11)

	oPrint:Say  (065,300, (cTempF)->SERIE  ,oFont19I)
	oPrint:Say  (080,280, "CÓDIGO DE"  ,oFont12)
	oPrint:Say  (095,270, "COMPROBANTE"  ,oFont12)
	//	oPrint:Say  (105,300, "N.: "+(cTempF)->VOUCHER  ,oFont8)

	oPrint:Say  (065,450, "REMITO"  ,oFont20n)
	oPrint:Say  (080,420, "DOCUMENTO NO VÁLIDO"  ,oFont12)
	oPrint:Say  (095,440, "COMO FACTURA"  ,oFont12)

	oPrint:Say  (125,420, "N."+(cTempF)->DOCUM  ,oFont20n)

	oPrint:Box(140,420,170,540)
	oPrint:Line (155,420,155,540)
	oPrint:Line (140,460,170,460)
	oPrint:Line (140,500,170,500)

	oPrint:Say  (150,430, "DIA"  ,oFont12)
	oPrint:Say  (150,470, "MES"  ,oFont12)
	oPrint:Say  (150,510, "AÑO"  ,oFont12)

	oPrint:Say  (165,435, Alltrim(StrZero(Day(StoD((cTempF)->FECHA)),2))  ,oFont12)
	oPrint:Say  (165,475, Alltrim(StrZero(Month(StoD((cTempF)->FECHA)),2))  ,oFont12)
	oPrint:Say  (165,510, Alltrim(Str(Year(StoD((cTempF)->FECHA))))  ,oFont12)

	oPrint:Say  (185,380,"C.U.I.T.: "+TRANSFORM(cCNPJ,PESQPICT("SA1","A1_CGC")),oFont9)
	oPrint:Say  (200,380,"INGRESOS BRUTOS CONV, MULT: "+TRANSFORM(cIe,PESQPICT("SA1","A1_INSCR")),oFont9)
	oPrint:Say  (215,380,"FECHA DE INICIO DE ACT: 01/03/2004 ",oFont9)

	oPrint:Say  (215,015,"IVA: RESPONSABLE INSCRIPTO",oFont12)//Verificar

	dbselectarea("SA1")
	MsSeek(Xfilial("SA1")  + (cTempF)->CLIEN + (cTempF)->LOJA )

	oPrint:Box(230,005,320,560)

	oPrint:Say  (245,015,"SEÑOR/es: "         											,oFont13n)
	oPrint:Say  (245,075, (cTempF)->CLIEN + (cTempF)->LOJA+" - "+Upper(SA1->A1_NOME)   ,oFont12)
	oPrint:Say  (260,075,Upper(Alltrim(SA1->A1_END)) 	,oFont10)
	oPrint:Say  (275,075,Upper(Alltrim(SA1->A1_BAIRRO) + " - " + Alltrim(SA1->A1_MUN) + " - " + Alltrim(SA1->A1_EST)) + " - " + Alltrim(SA1->A1_CEP)         					,oFont10)

	_aTpDesc := RetSX3Box(GetSX3Cache("A1_TIPO","X3_CBOX"),,,1)
	_nPos	  := aScan(_aTpDesc,{|x| AllTrim(x[2]) == SA1->A1_TIPO})
	oPrint:Say  (300,050,"IVA: "								,oFont12)
	oPrint:Say  (300,075,UPPER(Alltrim(_aTpDesc[_nPos][03]))	,oFont10)
	oPrint:Say  (300,380,"C.U.I.T.: "							,oFont12)
	oPrint:Say  (300,440, TRANSFORM(SA1->A1_CGC,PESQPICT("SA1","A1_CGC"))   ,oFont10)

	dbselectarea("SE4")
	MsSeek(Xfilial("SE4")  + (cTempF)->COND )

	oPrint:Say  (315,015, "CONDICIONES DE VENTA: " 	,oFont12)
	oPrint:Say  (315,140, SE4->E4_DESCRI			,oFont10)
	oPrint:Say  (315,280,"PEDIDO N.: "				,oFont12)
	oPrint:Say  (315,340, VerPed((cTempF)->DOCUM)				,oFont10)

	oPrint:Box(320,005,335,560)
	oPrint:Line (320,105,335,105)
	oPrint:Line (320,160,335,160)

	oPrint:Say  (330,010, "CODIGO DE PRODUCTO"			,oFont10)
	oPrint:Say  (330,115, "CANTIDAD"					,oFont10)
	oPrint:Say  (330,300, "DESCRIPCION DEL PRODUCTO"	,oFont10)

	_nLin := 345

Return()

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³   C()      ³ Autor ³ João Victor           ³ Data ³31/07/13  ³±±
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

/*
Verifico a origem do item atraves do numero do lote
*/
Static Function VerOrLot(nLote)

	Local _cQry := ""
	Local _cRet := ""

	If Select("TRD") > 0
		TRD->(DbCloseArea())
	Endif

	_cQry := " "
	_cQry += " SELECT DISTINCT D1_XORIGEM FROM "+RetSqlName("SD1") "
	_cQry += " WHERE D1_LOTECTL = '" + nLote +"' "
	_cQry += " AND D_E_L_E_T_ = ' ' "

	TcQuery _cQry New Alias "TRD"

	_cRet := TRD->D1_XORIGEM

Return(_cRet)

/*
Verifico chave do remito
*/
Static Function VerChv(nDoc)

	Local _cQry := ""
	Local _cRet := ""

	If Select("TRD") > 0
		TRD->(DbCloseArea())
	Endif

	_cQry := " "
	_cQry += " SELECT DISTINCT CHV_REMITO FROM SPED057L "
	_cQry += " WHERE REMITO_ID = '"+nDoc+"' "
	_cQry += " AND D_E_L_E_T_ = ' ' "

	TcQuery _cQry New Alias "TRD"

	_cRet := TRD->CHV_REMITO

Return(_cRet)

/*
Verifico os pedidos faturados para um determinado remito
*/
Static Function VerPed(nRemito)

	Local _cQry := ""
	Local _cRet := ""

	If Select("TRD") > 0
		TRD->(DbCloseArea())
	Endif

	_cQry := " "
	_cQry += " SELECT DISTINCT D2_PEDIDO FROM "+RetSqlName("SD2") "
	_cQry += " WHERE D2_DOC = '" + nRemito +"' "
	_cQry += " AND D_E_L_E_T_ = ' ' "

	TcQuery _cQry New Alias "TRD"

	TRD->(dbGoTop())

	While !EOF()

		If Empty(TRD->D2_PEDIDO)
			dbSkip()
			loop
		EndIf


		_cRet += TRD->D2_PEDIDO+","

		TRD->(dbSkip())

	End

Return(_cRet)

/*
Verifico os volumes e pesos do remito
*/
Static Function VerVol(nRemito)

	Local _cQry := ""
	//Private _aRet := {}

	If Select("TRD") > 0
		TRD->(DbCloseArea())
	Endif

	_cQry := " "
	_cQry += ' SELECT DISTINCT CB6_XORDSE "OS", 
	_cQry += "	(SELECT COUNT(*) FROM "+ RetSqlName("CB6") +" CB6 WHERE   CB7_ORDSEP = CB6_XORDSE AND CB6.CB6_FILIAL = '"+xFilial("CB6")+"' AND  CB6.D_E_L_E_T_ = ' ' ) " 
	_cQry += '	"SOMA",    
	_cQry += "	(SELECT SUM(CB6.CB6_XPESO) FROM "+ RetSqlName("CB6") +" CB6 WHERE   CB7_ORDSEP = CB6_XORDSE AND CB6.CB6_FILIAL = '"+xFilial("CB6")+"' AND  CB6.D_E_L_E_T_ = ' ' ) " 
	_cQry += '	"PESO"   
	_cQry += " FROM "+ RetSqlName("CB7") +" CB7 "	
	_cQry += "  INNER JOIN(SELECT * FROM "+ RetSqlName("CB6") +") CB6 "
	_cQry += " ON   CB7_ORDSEP = CB6_XORDSE AND  CB6.D_E_L_E_T_ = ' ' AND CB6.CB6_FILIAL = '"+xFilial("CB6")+"' "
	_cQry += " WHERE CB7.D_E_L_E_T_ = ' '  AND CB7.CB7_FILIAL = '"+xFilial("CB7")+"' "
	_cQry += " AND CB7.CB7_NOTA     = '"+ nRemito +"' "
	_cQry += " AND CB7.CB7_SERIE    = 'R' "

	TcQuery _cQry New Alias "TRD"

	TRD->(dbGoTop())

	Aadd(_aRet,{ TRD->SOMA, TRD->PESO }) 

Return

/*
Verifico o numero da ordem de compra no pedido de venda.
*/
Static Function VerOrPc(cPedido)

	Local _cQry := ""
	Local _cRet := ""

	If Select("TRD") > 0
		TRD->(DbCloseArea())
	Endif

	_cQry := " "
	_cQry += " SELECT DISTINCT C5_XORPC,C5_EMISSAO FROM "+RetSqlName("SC5") "
	_cQry += " WHERE C5_NUM = '" + StrTran(cPedido,",","") +"' "
	_cQry += " AND D_E_L_E_T_ = ' ' "

	TcQuery _cQry New Alias "TRD"

	TRD->(dbGoTop())

	_cRet := TRD->C5_XORPC


Return(_cRet)




/*
Criacao e apresentacao das perguntas
*/
Static Function ValidPerg()
	Local _sAlias := GetArea()
	Local _aRegs  := {}
	Local i := 0
	Local j := 0
	_cPerg         := PADR(_cPerg,10)
	AADD(_aRegs,{_cPerg,"01","De Remisión ?  ","De Remisión ?","De Remisión ?" ,"mv_ch1","C",12,0,0,"G","          ","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(_aRegs,{_cPerg,"02","A Remisión  ?  ","A Remisión  ?","A Remisión  ? ","mv_ch2","C",12,0,0,"G","          ","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(_aRegs,{_cPerg,"03","Serie  ?  "     ,"Serie  ?"     ,"Serie  ? "     ,"mv_ch3","C",03,0,0,"G","          ","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(_aRegs,{_cPerg,"04","Tipo de Operación  ?  ","Tipo de Operación  ?  " ,"Tipo de Operación  ?  "            ,"mv_ch4","C",01,0,0,"G","          ","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	dbSelectArea("SX1")
	SX1->(dbSetOrder(1))
	for i := 1 to len(_aRegs)
		If !SX1->(dbSeek(_cPerg+_aRegs[i,2]))
			RecLock("SX1",.T.)
			for j := 1 to FCount()
				If j <= Len(_aRegs[i])
					FieldPut(j,_aRegs[i,j])
				Else
					Exit
				EndIf
			next
			MsUnlock()
		EndIf
	next
	RestArea(_sAlias)
return
