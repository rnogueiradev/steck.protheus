#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "AP5MAIL.CH"
#Include "TOPCONN.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "colors.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ ARFAT04 ³ Autor ³ Everson Santana        ³ Data ³17/07/18  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³  Factura de venta Gráfica			                      ³±±

±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico Steck                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³Ajuste no texto do e-mail - Everson Santana - 09/08/2018               ³±±
±±³Codigo de Barras - Everson Santana - 09/08/2018              		  ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function ARFAT04(jRemisi,jRemisf,jSerie,jTipo,lvar)
	Local cQuery 		:= ''
	Local cRemisf 		:= ""
	Local cSerie  		:= ""
	Local lRet    		:= .F.
	Local lPeg	  		:= .F.
	Private mMemo		:= ""
	Private cRemisi 	:= ""
	Private lJob  		:= .F.
	Private cTipo   	:= ""
	Private cTempF 		:= CriaTrab(nil, .f.)
	Private _cPerg 	 	:= PadR ("ARFAT04", Len (SX1->X1_GRUPO))
	Private cEmailFor	:= ""
	Private cCopia		:= ""
	Private _nLote		:= 1
	PRIVATE oPrint
	PRIVATE _cNomeCom   := SM0->M0_NOMECOM
	PRIVATE _cEndereco	:= SM0->M0_ENDENT
	PRIVATE cCep        := SM0->M0_CEPENT
	PRIVATE cCidade     := SM0->M0_CIDENT
	PRIVATE cEstado     := SM0->M0_ESTENT
	PRIVATE cCNPJ       := SM0->M0_CGC
	PRIVATE cTelefone   := SM0->M0_TEL
	PRIVATE cFax        := SM0->M0_FAX
	PRIVATE	cBairro		:= SM0->M0_BAIRENT
	PRIVATE cIe         := Alltrim(SM0->M0_INSC)
	PRIVATE	titulo	  	:= ""
	PRIVATE cStartPath 	:= '\arquivos\orcamentobrowse\' //'\arquivos\orcamentobrowse\'//GetSrvProfString("Startpath","") +'orcamento\'
	PRIVATE _cPath		:= GetSrvProfString("RootPath","") //GetPvProfString( GetEnvServer(), "RootPath"	, "", GetAdv97() )
	PRIVATE _cNomePdf   :=''
	Private _cDirRel    := Getmv("MV_RELT",,'C:\ARQUIVOS_PROTHEUS\')
	Private _lxRet      := .T.
	Private _aJob		:= {}
	Private _TpDesc		:= " "
	Private _cCliente	:= " "
	Private _cNotCred	:= " "
	Private _cDocum		:= ""

	lJob := lvar

	If lJob
		lPeg := .t.
	Else
		ValidPerg()
		lPeg :=  Pergunte(_cPerg, .T.)
	EndIF

	If lPeg
		dbSelectArea("SA3")
		dbSetOrder(1)

		If SA3->(dbSeek(xFilial("SA3") + SF2->F2_VEND1))
			cCopia := IIF(!Empty(SA3->A3_CODUSR),GetEmail(SA3->A3_CODUSR),"")
		EndIf

		If lJob
			cRemisi := jRemisi
			cRemisf := jRemisf
			cSerie  := jSerie
			cTipo   := jTipo
			_nLote  := 1
		Else
			cRemisi := MV_PAR01
			cRemisf := MV_PAR02
			cSerie  := MV_PAR03
			cTipo   := MV_PAR04
			_nLote  := MV_PAR05
		EndIf

		titulo	  	  := "FACTURA ELECTRONICA - STECK  - Factura Nº " + cRemisi //Chamado 008856 - Everson Santana - 21.01.2019

		If cTipo == 1
			cQuery := "SELECT F1_ESPECIE ESPEC, F1_SERIE SERIE, F1_DOC DOCUM, F1_FORNECE CLIEN,F1_LOJA LOJA, F1_EMISSAO FECHA, F1_VALBRUT VALOR, F1_VALMERC MERCA, F1_RG1415 VOUCHER, F1_FLFTEX FLFTEX , F1_ADIC62 ADIC62, F1_XOBS XOBS, "
			cQuery += "F1_TRANSP TRANSP, F1_DESPESA GASTO, F1_FRETE FLETE, F1_DESCONT DESCT, F1_SEGURO SEGUR, D1_ITEM, D1_DESC, '' D2_DESCON, "
			cQuery += "D1_QUANT CANTI, D1_UM UMEDI, D1_VUNIT PRECV, D1_TOTAL TOTAL, D1_LOTECTL LOTE , D1_DTVALID FECVA, D1_PESO PESO, F1_COND COND, D1_PEDIDO PEDIDO, D1_COD PROD, F1_MOEDA MOEDA, "
			cQuery += "D1_NFORI NFORI,D1_SERIORI SERIORI, "
			cQuery += "A1_NOME, A1_END, A1_BAIRRO, A1_EST, A1_MUN, A1_PAIS, A1_CEP, A1_EMAIL EMAIL, A1_CGC, B1_DESC, B1_DESC,B1_XPAIS,D1_REMITO REMITO,D1_VALIMP1 IVA,D1_VALIMP6 PERCEPCION "
			cQuery += "FROM "+RetSqlName("SF1")+" SF1, "+RetSqlName("SA1")+" SA1, "+RetSqlName("SD1")+" SD1, "+RetSqlName("SB1")+" SB1 "
			cQuery += "WHERE  F1_DOC BETWEEN '"+cRemisi+"' AND '"+cRemisf+"' AND F1_SERIE = '"+cSerie+"' "
			cQuery += "AND F1_TIPO IN('D','B') "
			cQuery += "AND F1_FORNECE = A1_COD AND F1_LOJA = A1_LOJA AND F1_DOC = D1_DOC AND F1_SERIE = D1_SERIE AND A1_COD = D1_FORNECE "
			cQuery += "AND A1_LOJA = D1_LOJA AND D1_COD = B1_COD "
			cQuery += "AND F1_FILIAL = '"+xFilial("SF1")+"' AND D1_FILIAL = '"+xFilial("SD1")+"' "
			cQuery += "AND A1_FILIAL = '"+xFilial("SA1")+"' AND B1_FILIAL = '"+xFilial("SB1")+"' "
			cQuery += "AND SA1.D_E_L_E_T_ = ' ' AND SB1.D_E_L_E_T_ = ' ' "
			cQuery += "AND SF1.D_E_L_E_T_ = ' ' AND SD1.D_E_L_E_T_ = ' ' "
			cQuery += "ORDER BY D1_DOC, D1_ITEM"
		Else
			cQuery := "SELECT F2_ESPECIE ESPEC, F2_SERIE SERIE, F2_DOC DOCUM, F2_CLIENTE CLIEN,F2_LOJA LOJA, F2_EMISSAO FECHA, F2_VALBRUT VALOR, F2_VALMERC MERCA, F2_RG1415 VOUCHER, F2_FLFTEX FLFTEX , '' ADIC62,  F2_XOBS XOBS, "
			cQuery += "F2_TRANSP TRANSP, F2_DESPESA GASTO, F2_FRETE FLETE, F2_DESCONT DESCT, F2_SEGURO SEGUR, D2_ITEM, D2_DESC, D2_DESCON, "
			cQuery += "D2_QUANT CANTI, D2_UM UMEDI, D2_PRCVEN PRECV, D2_TOTAL TOTAL, D2_LOTECTL LOTE , D2_DTVALID FECVA, D2_PESO PESO, F2_COND COND, D2_PEDIDO PEDIDO, D2_COD PROD, F2_MOEDA MOEDA, "
			cQuery += "D2_NFORI NFORI,D2_SERIORI SERIORI, "
			cQuery += "A1_NOME, A1_END, A1_BAIRRO, A1_EST, A1_MUN, A1_PAIS, A1_CEP, A1_EMAIL EMAIL ,A1_CGC, B1_DESC, B1_DESC,B1_XPAIS,D2_REMITO REMITO,D2_VALIMP1 IVA,D2_VALIMP6 PERCEPCION "
			cQuery += "FROM "+RetSqlName("SF2")+" SF2, "+RetSqlName("SA1")+" SA1, "+RetSqlName("SD2")+" SD2, "+RetSqlName("SB1")+" SB1 "
			cQuery += "WHERE  F2_DOC BETWEEN '"+cRemisi+"' AND '"+cRemisf+"' AND F2_SERIE = '"+cSerie+"' "
			cQuery += "AND F2_CLIENTE = A1_COD AND F2_LOJA = A1_LOJA AND F2_DOC = D2_DOC AND F2_SERIE = D2_SERIE AND A1_COD = D2_CLIENTE "
			cQuery += "AND A1_LOJA = D2_LOJA AND D2_COD = B1_COD "
			cQuery += "AND F2_FILIAL = '"+xFilial("SF2")+"' AND D2_FILIAL = '"+xFilial("SD2")+"' "
			cQuery += "AND A1_FILIAL = '"+xFilial("SA1")+"' AND B1_FILIAL = '"+xFilial("SB1")+"' "
			cQuery += "AND SA1.D_E_L_E_T_ = ' ' AND SB1.D_E_L_E_T_ = ' ' "
			cQuery += "AND SF2.D_E_L_E_T_ = ' ' AND SD2.D_E_L_E_T_ = ' ' "
			cQuery += "ORDER BY  D2_DOC, D2_ITEM "
		EndIf

		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cTempF,.T.,.T.)

		Processa({|lEnd| lRet := xMontaRel()})

	EndIF

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
	±±³Ajuste no texto do e-mail - Everson Santana - 09/08/2018               ³±±
	±±³Codigo de Barras - Everson Santana - 09/08/2018              		  ³±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function xMontaRel()

	If Empty((cTempF)->DOCUM)
		cMsg1 := "Factura no encontrada, compruebe los parámetros."
		cMsg1 += "Compruebe el tipo de operación si es entrada o salida."

		If lJob
			Aadd(_ajob,{(cTempF)->DOCUM,A1_NOME,EMAIL,cMsg1})
			ARFATNOT(_ajob)
		Else
			MsgAlert(cMsg1)
		EndIf

		Return .F.
	Endif

	If (cTempF)->FLFTEX <> 'S' .AND. cTipo <> 1
		cMsg1 := "La factura no transmitida, no se puede imprimir."
		cMsg1 += "Por favor, transmita la factura e inténtelo de nuevo."

		//If lJob

		//	Aadd(_ajob,{(cTempF)->DOCUM,A1_NOME,EMAIL,cMsg1})

		//	ARFATNOT(_ajob)

		//Else

		MsgAlert(cMsg1)

		//EndIf

		Return .F.
	Endif

	If cTipo == 1
		_TpDesc :=  "NOTA DE CREDITO"
		_cNotCred := GetMv("ST_NOTCRED",,"everson.santana@steck.com.br")
		_cNomePdf  := cEmpAnt+"_NOTA_DE_CREDITO_"+(cTempF)->DOCUM
	Else
		If Alltrim((cTempF)->ESPEC) $ "NDC"
			_TpDesc := "NOTA DE DEBITO"
			_cNotCred := GetMv("ST_NOTCRED",,"everson.santana@steck.com.br")
			_cNomePdf  := cEmpAnt+"_NOTA_DE_DEBITO_"+(cTempF)->DOCUM
		Else
			_TpDesc := "FACTURA"
			_cNomePdf  := cEmpAnt+"_FACTURA_"+(cTempF)->DOCUM
		Endif
	EndIf

	_cDocum := (cTempF)->DOCUM
	//_cNomePdf  := "" //cEmpAnt+"_Factura_"+(cTempF)->DOCUM
	oPrint:= fwmsprinter():New( _cNomePdf , 6      ,.F.             , '\arquivos\orcamentobrowse\'  ,.T.			,  ,  ,  ,  .f.,  ,.f.,.f. )
	oPrint:SetPortrait(.T.)     //SetPortrait() ou SetLandscape()
	oPrint:SetMargin(60,60,60,60)
	oPrint:setPaperSize(9)

	Dbselectarea(cTempF)

	xImpress()

	// Indique o caminho onde será gravado o PDF
	FERASE(cStartPath+_cNomePdf+".pdf")
	oPrint:cPathPDF := cStartPath //"c:\"
	oPrint:Print()

	titulo	  	  := _TpDesc+" ELECTRONICA - STECK  - Nº " + cRemisi //Chamado 008856 - Everson Santana - 21.01.2019

	If lJob
		xBrEnvMail(oPrint,"Factura : "+ _cDocum,{"Factura: "+ _cDocum},cEmailFor,"",{},10,lJob)
	Else
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
				If _x2lChkMail(cEmailFor) // Abre tela Para Digitar Manualmente E-Mails
					Processa({|lEnd| xBrEnvMail(oPrint,"Factura : "+ _cDocum,{"Factura: "+ _cDocum},cEmailFor,"",{},10,lJob)},titulo)
				Endif
			Endif

		Endif

	EndIF

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
	Local _nGasto		:= 0
	Local _nDesc		:= 0
	Local _nIva			:= 0
	Local _nPercep		:= 0

	Local _cOrLot		:= ''
	Local _nMoeda		:= ""
	Local cnt := 0
	Local nPes := 0
	Local cDoc := ''
	Local cTransp := ''
	Local lRet := .F.
	Local nCount := 0
	Local _nTaxa := 0
	Local _nTotG	:= 0
	Local _cPedido 	:= ""

	Local _cNFE_ID	:= ""

	Local _cCae		:= ""
	Local _dFchVenc := ""
	Local _cADIC62  := ""
	Local _cXOBS 	:= ""
	Local _cNfOri	:= "" //Chamado 008373
	Local nLineLength 	:= 232
	Local nTabSize 		:= 3
	Local lWrap 		:= .T.
	Local nCurrentLine	:= 0

	Private _cRemito	:= ""
	Private _cCOND		:= ""
	Private _dEmis 		//:= Stod(" / / ")
	Private _cVoucher   := ""
	Private _cSerie		:= ""
	Private _cEspec		:= ""
	Private _nLin 		:= 4000
	Private _aRet 		:= {}
	Private _aRetOrc 	:= {}

	Private _cStQRC		:= ""	// String Principal QRCode
	Private _cfecha		:= ""	// Data
	Private _cptoVta	:= ""	// Punto de Venta
	Private _ctipoCmp	:= ""	// Tipo Documento
	Private _cmoneda	:= ""	// Moeda
	Private _nCtz		:= 0	// Cotacao da Moeda
	Private _ctipoDocRec:= ""	// Código del Tipo de documento del receptor
	Private _cnroCmp	:= ""	// Número del comprobante
	Private _nimporte	:= 0	// Importe Total del comprobante (en la moneda en la que fue emitido)
	Private _cnroDocRec	:= ""	// Número de documento del receptor correspondiente al tipo de documento indicado
	Private _ctipoCodAut:= "" 	// “A” para comprobante autorizado por CAEA, “E” para comprobante autorizado por CAE
	Private _ccodAut	:= ""	// Código de autorización otorgado por AFIP para el comprobante
	Private aBmp 		:= "lgrl0701.BMP"
	Private aAFIP 		:= "AFIP.BMP"

	oFont2n := TFont():New("Times New Roman",,10,,.T.,,,,,.F. )
	oFont7  := TFont():New("Arial",9,7 ,.T.,.F.,5,.T.,5,.T.,.F.)
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
	oFont18I2:= TFont():New( "Arial"        ,,20,,.T.,,,,,.f. )
	oFont19I:= TFont():New( "Arial"        ,,24,,.T.,,,,,.f. )
	oFont20I:= TFont():New( "Arial Black"   ,,08,,.t.,,,,,.f. )
	oFont21I:= TFont():New( "Arial"        ,,16,,.t.,,,,,.f. )
	oFont22I:= TFont():New( "Arial"        ,,13,,.t.,,,,,.f. )
	oFont23I:= TFont():New( "Arial Black"   ,,15.7,,.t.,,,,,.f. )
	oFont24I:= TFont():New( "Arial Black"   ,,10,,.t.,,,,,.f. )

	oBrush := TBrush():New("",4)

	_ntotal 	:= 0
	_nIva		:= 0
	_nPercep	:= 0
	_npagina 	:= 0
	_aItRed		:= {}

	count to nCount

	(cTempF)->(dbGoTop())
	ProcRegua(nCount)

	While (!(cTempF)->(EOF()))

		oPrint:StartPage()     // INICIALIZA a página

		cnt++
		cDoc 		:= (cTempF)->DOCUM
		_cNFE_ID 	:= (cTempF)->DOCUM+(cTempF)->SERIE
		_cSerie		:= (cTempF)->SERIE
		_cEspec		:= (cTempF)->ESPEC
		_cCOND		:= (cTempF)->COND
		_cVoucher 	:= (cTempF)->VOUCHER
		cTransp 	:= (cTempF)->TRANSP
		_nMoeda 	:= (cTempF)->MOEDA
		_nGasto 	:= (cTempF)->GASTO
		_nDesc 		:= (cTempF)->DESCT
		_dEmis		:= Stod((cTempF)->FECHA)
		_cRemito 	:= (cTempF)->REMITO
		cEmailFor 	:= (cTempF)->EMAIL
		_cADIC62	:= (cTempF)->ADIC62
		_cXOBS		:= (cTempF)->XOBS
		_cNfOri		:= ""
		_cDocum		:= (cTempF)->DOCUM
		_cCliente 	:= (cTempF)->CLIEN + (cTempF)->LOJA
		_ctexto		:= ""
		_ctexto2	:= ""

		xCabOrc(1)

		If Empty(cEmailFor)
			Aadd(_ajob,{(cTempF)->DOCUM,(cTempF)->A1_NOME,(cTempF)->EMAIL," Correo electrónico no registra para el cliente"})
		EndIf

		If _nMoeda == 1
			_cDMoed := "$"
		Else
			_cDMoed := "U$S"
		EndIF

		nPes 		:= 0
		_nTotal 	:= 0
		_nIva		:= 0
		_nPercep	:= 0

		While (!(cTempF)->(EOF())) .and. cDoc == (cTempF)->DOCUM
			Incproc()
			nPes		+= (cTempF)->PESO
			_nTotal		+= (cTempF)->TOTAL
			_nIva		+= (cTempF)->IVA
			_nPercep 	+= (cTempF)->PERCEPCION
			_ctexto		:= ""
			_ctexto2	:= ""

			//>> Chamado 008373 - Everson Santana - 19/12/18
			If !(cTempF)->NfOri $ _cNfOri
				_cNfOri += (cTempF)->NfOri+" "
			EndIf
			//<<

			If _nLin > 680
				_nLin+=10
				oPrint:Say  (_nLin,020, "* * *   C O N T I N Ú A    * * *",oFont12)
				oPrint:EndPage()     // Finaliza a página
				oPrint:StartPage()     // INICIALIZA a página
				xCabOrc(1)
			Endif

			//oPrint:Line (_nLin-15,105,600,105)
			//oPrint:Line (_nLin-15,160,600,160)

			oPrint:Line (_nLin-15,075,_nLin+15,075)
			oPrint:Line (_nLin-15,120,_nLin+15,120)
			oPrint:Line (_nLin-15,460,_nLin+15,460)
			oPrint:Line (_nLin-15,510,_nLin+15,510)

			oPrint:Say  (_nLin,010, (cTempF)->PROD	  ,oFont7)
			oPrint:Say  (_nLin,080, PADL(alltrim(TRANSFORM((cTempF)->CANTI,PESQPICT("SD2","D2_QUANT"))),13)	  ,oFont7)

			_cOrLot := VerOrLot( Alltrim( (cTempF)->LOTE)  )

			If _nLote == 1 //Imprime lote
				_ctexto := SubStr(Alltrim((cTempF)->B1_DESC) +" " + Alltrim((cTempF)->LOTE) + " " + Alltrim((cTempF)->B1_XPAIS),1,90)
				_ctexto2 := SubStr(Alltrim((cTempF)->B1_DESC) +" " + Alltrim((cTempF)->LOTE) + " " + Alltrim((cTempF)->B1_XPAIS),91,90)
			Else
				_ctexto := SubStr(Alltrim((cTempF)->B1_DESC),1,90)
				_ctexto2 := SubStr(Alltrim((cTempF)->B1_DESC),91,90)
			EndIf

			oPrint:Say  (_nLin ,125, _ctexto,oFont7)
			If !Empty(_ctexto2)
				_nLin+=15
				oPrint:Say  (_nLin ,125, _ctexto2,oFont7)
				_nLin-=15
			EndIF

			oPrint:Say  (_nLin,460, PADL(alltrim(TRANSFORM((cTempF)->PRECV,PESQPICT("SD2","D2_PRCVEN"))),17)	  ,oFont7)
			oPrint:Say  (_nLin,505, PADl(alltrim(TRANSFORM((cTempF)->TOTAL,PESQPICT("SD2","D2_TOTAL"))),17)	  ,oFont7)

			If !Empty(_ctexto2)
				_nLin+=15
			EndIF

			_nLin+=15

			If _nLin > 680
				_nLin+=10
				oPrint:Say  (_nLin,020, "* * *   C O N T I N Ú A    * * *",oFont12)
				oPrint:EndPage()     // Finaliza a página
				oPrint:StartPage()     // INICIALIZA a página
				xCabOrc(1)
			Endif

			(cTempF)->(dbSkip())

		EndDo

		If !Empty(_ctexto2)
			_nLin-=15
		EndIF
		//_nLin-=15
		//_nLin := 600
		oPrint:Line (_nLin, 005,_nLin,560) // Imprime Linha Fina

		_nLin+=15

		If _nMoeda == 1
			oPrint:Say  (_nLin+10,015, "SON PESOS "+Extenso((_nPercep+_nIva+_nTotal)-(_nDesc+_nGasto) ,.F.,1,,"2",.t.,.f.)	,oFont8)//Ajustado a posição da linha  Emerson Holanda 04/10/23
		Else
			oPrint:Say  (_nLin+10,015, "SON DOLAR "+Extenso((_nPercep+_nIva+_nTotal)-(_nDesc+_nGasto) ,.F.,2,,"2",.t.,.f.)	,oFont8)//Ajustado a posição da linha  Emerson Holanda 04/10/23
		EndIf

		oPrint:Say  (_nLin,450, "SUBTOTAL "	,oFont12)
		oPrint:Say  (_nLin,510, Alltrim(TRANSFORM(_nTotal,PESQPICT("SD2","D2_TOTAL")))	,oFont8)

		_nTaxa := VerTaxa(_dEmis,_cRemito)
		_nTotG := (_nPercep+_nIva+_nTotal)-(_nDesc+_nGasto)
		_nLin+=15
		//oPrint:Say  (_nLin,380, "Tipo de cambio del dia en pesos:"+_cDMoed+TransForm(_nTaxa,PESQPICT("SM2","M2_MOEDA2"))	,oFont8)
		oPrint:Say  (_nLin+10,015, "Tipo de Cambio Vendedor en pesos (Cotización Billetes) del Cierre del día de la Fecha "+_cDMoed+TransForm(_nTaxa,PESQPICT("SM2","M2_MOEDA2"))	,oFont8) //Ajustado a posição da linha  Emerson Holanda 04/10/23

		_nLin+=15
		oPrint:Say  (_nLin+05,015, "OBSERVACIONES: "+IIf(Empty(_cADIC62),"",Alltrim(_cADIC62))+Iif(Empty(_cNfOri),""," FC ORI:"+_cNfOri)+IIf(Empty(_cXOBS),"",Alltrim(_cXOBS))	,oFont8) //////Ajustado a posição da linha  Emerson Holanda 04/10/23

		//>> Chamado 008726 - Everson Santana - 09.01.2019
		_cPedido := VerPed(_cRemito)

		nLines1 := 0
		nCurrentLine1 := 0

		nLineLength := 100

		nLines1 := MLCOUNT(POSICIONE("SC5", 1, xFilial("SC5") + _cPedido, "SC5->C5_XOBS"), nLineLength, nTabSize, lWrap)

		FOR nCurrentLine := 1 TO nLines1

			xText1 := MEMOLINE(POSICIONE("SC5", 1, xFilial("SC5") +_cPedido, "SC5->C5_XOBS"), nLineLength, nCurrentLine, nTabSize, lWrap)

			oPrint:Say  (_nLin,110, " "+ Alltrim(xText1) 				,oFont10)

			_nLin+=15

			If _nLin > 680
				_nLin+=10

				oPrint:Say  (_nLin,020, "* * *   C O N T I N Ú A    * * *",oFont12)
				oPrint:EndPage()     // Finaliza a página
				oPrint:StartPage()     // INICIALIZA a página
				xCabOrc(2)
				oPrint:Line (_nLin, 005,_nLin,800) // Imprime Linha Fina
				_nLin+=15
				oPrint:Say  (_nLin,020, "Observaciones: "					,oFont12)
				_nLin+=15
			Endif
		NEXT

		If nLines1 = 1
			_nLin+=15
		Endif

		If !Empty(POSICIONE("SC5", 1, xFilial("SC5") +_cPedido, "SC5->C5_INCOTER"))
			oPrint:Say  (_nLin,110, "INCOTERM: "+POSICIONE("SC5", 1, xFilial("SC5") +_cPedido, "SC5->C5_INCOTER") 				,oFont10)
		EndIf
		//<< Chamado 008726

		_nLin+=15
		If _nMoeda == 1
			oPrint:Say  (_nLin,110, "La presente factura equivale a U$S "+Alltrim(TRANSFORM(_nTotG/_nTaxa,PESQPICT("SD2","D2_TOTAL")))	,oFont12)
		Else
			oPrint:Say  (_nLin,110, "La presente factura equivale a U$S "+Alltrim(TRANSFORM(_nTotG,PESQPICT("SD2","D2_TOTAL")))	,oFont12)
		EndIf

/*
		_nLin+=15
		oPrint:Say  (_nLin,015, " "	,oFont8)
		oPrint:Say  (_nLin,270, "Orden de Compra: "	,oFont12)

		VerOrPc(_cPedido)

		_cOrdCom := _aRetOrc[01][01]
		_dOrdCom := Stod(_aRetOrc[01][02])

		oPrint:Say  (_nLin,360,Alltrim(_cOrdCom)	,oFont8)
		oPrint:Say  (_nLin,450, "Fecha : "			,oFont12)
		oPrint:Say  (_nLin,490, DtoC(_dOrdCom) ,oFont8)
*/
		If _nLin > 659
			_nLin+=15

			oPrint:Say  (_nLin,020, "* * *   C O N T I N Ú A    * * *",oFont12)
			oPrint:EndPage()     // Finaliza a página
			oPrint:StartPage()     // INICIALIZA a página
			xCabOrc(2)
			//oPrint:Line (_nLin, 005,_nLin,560) // Imprime Linha Fina
			_nLin+=15
			oPrint:Say  (_nLin,020, "Observaciones: "					,oFont12)
			_nLin+=15
		Endif

		_nLin+=15
		oPrint:Line (_nLin,005,_nLin,560) // Imprime Linha Fina
		oPrint:Line (_nLin,098,_nLin+30,098)
		oPrint:Line (_nLin,191,_nLin+30,191)
		oPrint:Line (_nLin,284,_nLin+30,284)
		oPrint:Line (_nLin,377,_nLin+30,377)
		oPrint:Line (_nLin,470,_nLin+30,470)

		_nLin+=15
		oPrint:Say  (_nLin,015, "DESCUENTOS"	,oFont12)
		oPrint:Say  (_nLin,110, "RECARGOS"	,oFont12)
		//oPrint:Say  (_nLin-5,205, "PERCEPCION"	,oFont12)
		oPrint:Say  (_nLin-5,198, "PERC.INGR.BRUT"	,oFont12)
		oPrint:Say  (_nLin,300, "SUBTOTAL"	,oFont12)
		oPrint:Say  (_nLin,400, "IVA 21.00%"	,oFont12)
		oPrint:Say  (_nLin,485, "TOTAL"	,oFont12)

		_nLin+=15
		oPrint:Say  (_nLin-5,015, ""	,oFont12)
		oPrint:Say  (_nLin-5,110, ""	,oFont12)
		oPrint:Say  (_nLin-5,205, "RG 38/95 BA"	,oFont12)
		oPrint:Say  (_nLin-5,300, ""	,oFont12)
		oPrint:Say  (_nLin-5,400, ""	,oFont12)
		oPrint:Say  (_nLin-5,485, ""	,oFont12)

		oPrint:Line (_nLin,005,_nLin,560) // Imprime Linha Fina
		oPrint:Line (_nLin,098,_nLin+15,098)
		oPrint:Line (_nLin,191,_nLin+15,191)
		oPrint:Line (_nLin,284,_nLin+15,284)
		oPrint:Line (_nLin,377,_nLin+15,377)
		oPrint:Line (_nLin,470,_nLin+15,470)

		_nLin+=15
		oPrint:Say  (_nLin-5,040, Alltrim(TRANSFORM(_nDesc,PESQPICT("SF2","F2_DESCONT")))	,oFont8)//Ajustado a posição da linha  Emerson Holanda 04/10/23
		oPrint:Say  (_nLin-5,140, Alltrim(TRANSFORM(_nGasto,PESQPICT("SF2","F2_DESPESA")))	,oFont8)//Ajustado a posição da linha  Emerson Holanda 04/10/23
		oPrint:Say  (_nLin-5,224, Alltrim(TRANSFORM(_nPercep,PESQPICT("SD2","D2_VALIMP6")))	,oFont8)//Ajustado a posição da linha  Emerson Holanda 04/10/23
		oPrint:Say  (_nLin-5,305, Alltrim(TRANSFORM(_nTotal,PESQPICT("SD2","D2_TOTAL")))	,oFont8)//Ajustado a posição da linha  Emerson Holanda 04/10/23
		oPrint:Say  (_nLin-5,407, Alltrim(TRANSFORM(_nIva,PESQPICT("SD2","D2_VALIMP1")))	,oFont8)//Ajustado a posição da linha  Emerson Holanda 04/10/23
		oPrint:Say  (_nLin-5,490, Alltrim(TRANSFORM((_nPercep+_nIva+_nTotal)-(_nDesc+_nGasto),PESQPICT("SD2","D2_TOTAL")))	,oFont8)//Ajustado a posição da linha  Emerson Holanda 04/10/23
		oPrint:Line (_nLin,005,_nLin,560) // Imprime Linha Fina

		//oPrint:Line (_nLin,005,_nLin,560) // Imprime Linha Fina
		_nLin+=15

		VerProt(_cNFE_ID)

		_cCae 		:= _aRet[01][01]
		_dFchVenc 	:= Stod(_aRet[01][02])

		If Empty(_cCae)
			_cCae := ""
		EndIf

		If Empty(_dFchVenc)
			_dFchVenc := Ctod("  /  /  ")
		EndIf

		oPrint:Say  (_nLin,015, "C.A.E.: "+_cCae  	,oFont12)
		oPrint:Say  (_nLin,155, "Fecha Vto.: "+Dtoc(_dFchVenc) 	,oFont12)
		_nLin+=05
		oPrint:Line (_nLin,005,_nLin,560) // Imprime Linha Fina

/*
		_cCodBar := StrZero(Val(cCNPJ),11)+StrZero(Val(_cVoucher),2)+StrZero(Val(Substring(cDoc,1,4)),4)+StrZero(Val(_cCae),14)+dtos(_dFchVenc) //'3054856093001000468300350229678201808051'//+cDv
		cDv := CalcMod10(_cCodBar)
		_cCodBar := _cCodBar+StrZero(Val(cDv),1)
		//_nLin+=05
		_nLinCB := 0
		_nLinCB := _nLin/12
*/		
		//oPrint:FWMSBAR("INT25" /*cTypeBar*/,_nLinCB/*nRow*/ ,7/*nCol*/, _cCodBar/*cCode*/,oPrint/*oPrint*/,.F./*lCheck*/,/*Color*/,.T./*lHorz*/,0.019/*nWidth*/,0.5/*nHeigth*/,.F./*lBanner*/,"Times New Roman"/*cFont*/,"1"/*cMode*/,.F./*lPrint*/,1/*nPFWidth*/,1/*nPFHeigth*/,.F./*lCmtr2Pix*/)

		_cfecha		:= IIF(cTipo = 1, Dtos(SF1->F1_EMISSAO),Dtos(SF2->F2_EMISSAO))
		_cfecha		:= Chr(34) + Left(_cfecha,4) + "-" + Substr(_cfecha,5,2) + "-" + Substr(_cfecha,7,2) + Chr(34)
		_cptoVta 	:= IIF(cTipo = 1, SF1->F1_PV, SF2->F2_PV)
		_cptoVta 	:= StrZero(Val(_cptoVta),5)

		Do Case
		Case cTipo = 1
			Do Case
			Case SF1->F1_SERIE == "A" .And. SF1->F1_ESPECIE == 'NCC'
				_ctipoCmp := "003"
			EndCase
		Case cTipo = 2
			Do Case
			Case Alltrim(SF2->F2_SERIE) == "A" .And. SF2->F2_ESPECIE == 'NF'
				_ctipoCmp := "001"
			Case Alltrim(SF2->F2_SERIE) == "E" .And. SF2->F2_ESPECIE == 'NF'
				_ctipoCmp := "019"
			Case Alltrim(SF2->F2_SERIE) == "A" .And. SF2->F2_ESPECIE == 'NDC'
				_ctipoCmp := "002"
			EndCase
			Other
			_ctipoCmp := "001"
		EndCase

		_cnroCmp	:= Right(IIF(cTipo = 1, SF1->F1_DOC,SF2->F2_DOC),8)
		_nimporte	:= IIF(cTipo = 1, SF1->F1_VALBRUT*100, SF2->F2_VALBRUT*100)

		Do Case
		Case cTipo = 1
			_cmoneda := IIF(SF1->F1_MOEDA = 1,"PES", "DOL")
		Case cTipo = 2
			_cmoneda := IIF(SF2->F2_MOEDA = 1,"PES", "DOL")
			Other
			_cmoneda := "PES"
		EndCase

		SM2->(dbSetOrder(1))
		SM2->(dbSeek(IIF(cTipo = 1, Dtos(SF1->F1_EMISSAO), Dtos(SF2->F2_EMISSAO))))

		_nCtz := SM2->M2_MOEDA2 * 1000000

		SA1->(dbSetOrder(1))
		SA1->(dbSeek(xFilial("SA1") + IIF(cTipo = 1, SF1->F1_FORNECE, SF2->F2_CLIENTE)))

		_ctipoDocRec	:= IIF(SA1->A1_EST =="EX","91","80")
		_cnroDocRec		:= StrZero(Val(SA1->A1_CGC),20)
		_ctipoCodAut	:= IIF(cTipo = 1, Alltrim(SF1->F1_SERIE), Alltrim(SF2->F2_SERIE))
		_ccodAut		:= IIF(cTipo = 1, SF1->F1_CAEE, SF2->F2_CAEE )

		_cStQRC	:= '"ver":1' +;
			',"fecha"'		+ ":" + _cfecha +;
			',"cuit"'		+ ":" + StrZero(Val(cCNPJ),14) +;
			',"ptoVta"' 	+ ":" + _cptoVta +;
			',"tipoCmp"'	+ ":" + _ctipoDocRec +;
			',"nroCmp"'		+ ":" + _cnroCmp +;
			',"importe"'	+ ":" + Alltrim(Str(_nimporte)) +;
			',"moneda"'		+ ":" +	Chr(34) + _cmoneda + Chr(34) +;
			',"ctz"'		+ ":" + Alltrim(Str(_nCtz)) +;
			',"tipoDocRec"'	+ ":" + _ctipoDocRec  +;
			',"nroDocRec"'	+ ":" + _cnroDocRec  +;
			',"tipoCodAut"'	+ ":" + _ctipoCodAut  +;
			',"codAut"'		+ ":" + _ccodAut

		_cStQRC:=Encode64("{"+_cStQRC+"}")
		_cStQRC	:= "https://www.afip.gob.ar/fe/qr/?p=" + _cStQRC

		//https://www.afip.gob.ar/fe/qr/?p=eyJ2ZXIiOjEsImZlY2hhIjoiMjAyMC0xMC0xMyIsImN1aXQiOjMwMDAwMDAwMDA3LCJwdG9WdGEiOjEwLCJ0aXBvQ21wIjoxLCJucm9DbXAiOjk0LCJpbXBvcnRlIjoxMjEwMCwibW9uZWRhIjoiRE9MIiwiY3R6Ijo2NSwidGlwb0RvY1JlYyI6ODAsIm5yb0RvY1JlYyI6MjAwMDAwMDAwMDEsInRpcG9Db2RBdXQiOiJFIiwiY29kQXV0Ijo3MDQxNzA1NDM2NzQ3Nn0=

		//_nLin := 800
		_nLin += 100 //Ajustado a posição da linha  Emerson Holanda 04/10/23
		//Alert("Linha:"+Alltrim(Str(_nLin)))
		If File(aAFIP)
			oPrint:SayBitmap(_nLin-90,130,aAFIP,380,080)
		EndIf

		oPrint:QrCode(_nLin,012, _cStQRC, 100) //Ajustado a posição da linha do qr code Emerson Holanda 04/10/23

		//_nLin := 810
		//_nLin += 25
		//oPrint:Line (_nLin,005,_nLin,560) // Imprime Linha Fina
		//Alert("Linha:"+Alltrim(Str(_nLin)))
		//Ajustado a posição da linha  Emerson Holanda 04/10/23
		_nLin:= 840
		oPrint:Say (_nLin,015, "Solicite por e-mail las licencias de los productos alcanzados por la Res. 171/2016 haciendo referencia a su Nro. de factura de compra. (ventas.ar@steckgroup.com)"  ,oFont8)

		_nLin += 05 //Ajustado a posição da linha  Emerson Holanda 04/10/23
		oPrint:Line (_nLin,005,_nLin,560) // Imprime Linha Fina

		oPrint:EndPage()     // Finaliza a página
	EndDo

	(cTempF)->(dbCloseArea())

	lRet := cnt > 0

	If Len(_ajob) > 0

		ARFATNOT(_ajob)

	EndIf

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

Static Function xCabOrc(_nOpc)

	Local _aTpDesc 	:= {}
	Local _nPos	 	:= 0

	oPrint:Box(045,005,830,560)

	If File(aBmp)
		oPrint:SayBitmap(050,020,aBmp,115,050 )            // Valdemir Rabelo 20/12/2021 - Ticket: 20211216026887
	EndIf

	oPrint:Say  (110,015, _cNomeCom  ,oFont12)
	oPrint:Say  (125,015, Alltrim(_cEndereco)+" - "+cBairro ,oFont12)
	oPrint:Say  (140,015,"CP: "+ cCep +" - "+Alltrim(cCidade)+" - "+cEstado+" - ARGENTINA",oFont12)
	oPrint:Say  (155,015,"TEL.: (005411) 6288-7879 | TEL.: (005411) 5808-2011",oFont12)         // +54 11 6288-7879 | +54 11 5808-2011
	oPrint:Say  (170,015,"ventas.ar@steckgroup.com",oFont11)
	oPrint:Say  (185,015,"www.steckgroup.com",oFont11)

	If AllTrim(_cSerie)=="ACC" .Or. AllTrim(_cSerie)=="ACD" .Or. AllTrim(_cSerie)=="ACF"
		oPrint:Say  (065,300, "A"  ,oFont19I)
	Else
		oPrint:Say  (065,300, substr(allTrim(_cSerie),1,1) ,oFont19I)
	EndIf

	//oPrint:Say  (080,280, "CÓDIGO DE"  ,oFont12)
	oPrint:Say  (080,280, "CODIGO DE"  ,oFont12)
	oPrint:Say  (095,270, "COMPROBANTE"  ,oFont12)
	oPrint:Say  (105,300, "N.: "+_cVoucher  ,oFont8)

	If cTipo == 1
		oPrint:Say  (105,410, "NOTA DE CREDITO"  ,oFont20n)
	Else

		If Alltrim(_cEspec) $ "NDC"
			oPrint:Say  (105,415, "NOTA DE DEBITO"  ,oFont20n)
		Else
			If AllTrim(_cSerie)=="ACC" .Or. AllTrim(_cSerie)=="ACD" .Or. AllTrim(_cSerie)=="ACF"
				oPrint:Say  (100,440, "FACTURA DE CRÉDITO"  ,oFont9)
				oPrint:Say  (110,430, "ELECTRÔNICA MiPyMEs (FCE)"  ,oFont9)
			Else
				oPrint:Say  (105,440, "FACTURA"  ,oFont20n)
			EndIf
		Endif

	EndIf

	oPrint:Say  (125,420, "N."+_cDocum  ,oFont20n)

	oPrint:Box(140,420,170,540)
	oPrint:Line (155,420,155,540)
	oPrint:Line (140,460,170,460)
	oPrint:Line (140,500,170,500)

	oPrint:Say  (150,430, "DIA"  ,oFont12)
	oPrint:Say  (150,470, "MES"  ,oFont12)
	oPrint:Say  (150,510, "AÑO"  ,oFont12)

	oPrint:Say  (165,435, Alltrim(StrZero(Day(_dEmis),2))  ,oFont12)
	oPrint:Say  (165,475, Alltrim(StrZero(Month(_dEmis),2))  ,oFont12)
	oPrint:Say  (165,510, Alltrim(Str(Year(_dEmis)))  ,oFont12)

	oPrint:Say  (185,380,"C.U.I.T.: "+TRANSFORM(cCNPJ,PESQPICT("SA1","A1_CGC")),oFont9)
	If AllTrim(_cSerie)=="ACC" .Or. AllTrim(_cSerie)=="ACD" .Or. AllTrim(_cSerie)=="ACF"
		oPrint:Say  (200,380,"INGRESOS BRUTOS CONV, MULT: 30-70866776-1 901",oFont9)
	Else
		oPrint:Say  (200,380,"INGRESOS BRUTOS CONV, MULT: "+TRANSFORM(cIe,PESQPICT("SA1","A1_INSCR")),oFont9)
	EndIf

	oPrint:Say  (215,380,"FECHA DE INICIO DE ACT: 01/03/2004 ",oFont9)//Verificar

	oPrint:Say  (215,015,"IVA: RESPONSABLE INSCRIPTO",oFont12)//Verificar

	dbselectarea("SA1")
	dbSetOrder(1)
	//MsSeek(Xfilial("SA1")  + (cTempF)->CLIEN + (cTempF)->LOJA )
	MsSeek(Xfilial("SA1")  + _cCliente )

	oPrint:Box(230,005,320,560)

	dbselectarea("SE4")
	MsSeek(Xfilial("SE4")  + _cCOND )

	oPrint:Say  (245,015,"SEÑOR/es: "         											,oFont13n)
	oPrint:Say  (245,075, _cCliente +" - "+Upper(SA1->A1_NOME)   ,oFont10)
	oPrint:Say  (245,370,"Plazo de Pago: "         										,oFont12)
	oPrint:Say  (245,445, AllTrim(SE4->E4_DESCRI)   ,oFont10)

	oPrint:Say  (260,075,Upper(Alltrim(SA1->A1_END)) 	,oFont10)
	oPrint:Say  (260,370,"Forma de Pago: "         										,oFont12)

	If AllTrim(_cSerie)=="ACC" .Or. AllTrim(_cSerie)=="ACD" .Or. AllTrim(_cSerie)=="ACF"
		oPrint:Say  (260,445, "Transferencia"   ,oFont10)
	Else
		oPrint:Say  (260,445, "Efectivo,Cheque al día, Cheque"   ,oFont10)
	EndIf

	oPrint:Say  (275,075,Upper(Alltrim(SA1->A1_BAIRRO) + " - " + Alltrim(SA1->A1_MUN) + " - " + Alltrim(SA1->A1_EST)) + " - " + Alltrim(SA1->A1_CEP)         					,oFont10)
	oPrint:Say  (275,370,"C.U.I.T.: "							,oFont12)
	oPrint:Say  (275,445, TRANSFORM(SA1->A1_CGC,PESQPICT("SA1","A1_CGC"))   ,oFont10)

	oPrint:Say  (290,030,"Telefono: " ,oFont12)
	oPrint:Say  (290,075,Alltrim(SA1->A1_TEL) ,oFont10)
	oPrint:Say  (290,370,"REMITO N.: "							,oFont12)
	oPrint:Say  (290,445, _cRemito   ,oFont10)

	If AllTrim(_cSerie)=="ACC" .Or. AllTrim(_cSerie)=="ACD" .Or. AllTrim(_cSerie)=="ACF"
		oPrint:Say  (305,370,"CBU del Emisor: "	,oFont12)
		oPrint:Say  (305,445, "0720045820000000268886"   ,oFont10)
	EndIf

	_aTpDesc := RetSX3Box(GetSX3Cache("A1_TIPO","X3_CBOX"),,,1)
	_nPos	  := aScan(_aTpDesc,{|x| AllTrim(x[2]) == SA1->A1_TIPO})
	oPrint:Say  (300,050,"IVA: "								,oFont12)
	oPrint:Say  (300,075,UPPER(Alltrim(_aTpDesc[_nPos][03]))	,oFont10)

	If SE4->E4_COND = "0"
		_cCondVent	:= "Efectivo"
	Else
		_cCondVent	:= "Cuenta Corriente"
	EndIf

	oPrint:Say  (315,015, "CONDICIONES DE VENTA: " 	,oFont12)
	oPrint:Say  (315,140, _cCondVent				,oFont10)
	oPrint:Say  (315,225,"PEDIDO N.: "				,oFont12)//Ajustado a posição da linha  Emerson Holanda 04/10/23

	If Len(Alltrim(VerPed(_cRemito))) <= 63 //Ajustado a posição da linha  Emerson Holanda 04/10/23
		oPrint:Say  (315,280, VerPed(_cRemito)	,oFont10)
	Else
		oPrint:Say  (305,280, Substr(VerPed(_cRemito),1,63)	,oFont10)
		oPrint:Say  (315,280, Substr(VerPed(_cRemito),64,Len(Alltrim(VerPed(_cRemito))))	,oFont10)
	EndIf
	//Alert("Qtd caracteres Pedido:"+Str(Len(Alltrim(VerPed(_cRemito)))))
	If _nOpc == 1
		oPrint:Say  (330,015, " - Condición de cobro " 	,oFont10n)
		oPrint:Say  (340,015, " - El valor a abonar será el equivalente al importe total en Dólares" 	,oFont10n)
		oPrint:Say  (350,015, "americanos convertidos a pesos argentinos según el tipo de cambio " 	,oFont10n)
		oPrint:Say  (360,015, "vendedor (Cotización Divisas - Banco de la Nación Argentina) del " 	,oFont10n)
		oPrint:Say  (370,015, "cierre del día anterior al pago, según las siguientes condiciones:" 	,oFont10n)
		//FR - 06/07/2022 - Flávia Rocha - Sigamat Consultoria - alteração dos dizeres mediante ticket #20220705013381
		//oPrint:Say  (380,015, "- Dentro de los 20 días F.F. se respetará el valor total en pesos " 	,oFont10n)
		oPrint:Say  (380,015, "- Dentro de los 3 días F.F. se respetará el valor total en pesos " 	,oFont10n)
		//FR - 06/07/2022 - Flávia Rocha - Sigamat Consultoria - alteração dos dizeres mediante ticket #20220705013381
		oPrint:Say  (390,015, "de la factura " 	,oFont10n)

		//FR - 06/07/2022 - Flávia Rocha - Sigamat Consultoria - alteração dos dizeres mediante ticket #20220705013381
		//oPrint:Say  (330,280, " - Luego de los 20 días F.F. y de existir una variación del 3% del dólar" 	,oFont10n)
		oPrint:Say  (330,280, " - Luego de los 3 días F.F. y de existir una variación del 3% del dólar" 	,oFont10n)
		//FR - 06/07/2022 - Flávia Rocha - Sigamat Consultoria - alteração dos dizeres mediante ticket #20220705013381

		oPrint:Say  (340,280, "(mayor o menor) entre el tipo de cambio expresado en el documento" 		,oFont10n)
		oPrint:Say  (350,280, "y aquel correspondiente al día de la efectiva acreditación del cheque" 	,oFont10n)
		oPrint:Say  (360,280, "y/o transferencia, Steck Electric S.A. realizara la Nota de credito o" 	,oFont10n)
		oPrint:Say  (370,280, "debito según corresponda, ajustando el monto total en pesos a cobrar" 	,oFont10n)
		oPrint:Say  (380,280, "de forma inmediata" 	,oFont10n)
		/*
		oPrint:Say  (360,015, "efectivo pago. De existir una variacíon superior al 3% entre al tipo de cambio expresado en la presente con" ,oFont12)
		oPrint:Say  (375,015, "aquel correspondiente a día de la efectiva acreditación del pago de esta factura, Steck Electric S.A." 		,oFont12)
		//oPrint:Say  (390,015, "realizará la Nota de débito/crédito según corresponda." 														,oFont12)
		oPrint:Say  (390,015, "realizará la Nota de según corresponda." 														,oFont12) // Chamado 008856 - Everson Santana - 21.01.2019
		*/

		oPrint:Box(395,005,420,560)

		oPrint:Say  (405,020, "CODIGO DEL "		,oFont8)
		oPrint:Say  (415,020, "PRODUCTO "		,oFont8)

		oPrint:Line (395,075,420,075)
		oPrint:Say  (405,080, "CANTIDAD"				,oFont8)

		oPrint:Line (395,120,420,120)
		oPrint:Say  (405,230, "DESCRIPCION DEL PRODUCTO",oFont8)

		oPrint:Line (395,460,420,460)
		oPrint:Say  (405,473, "VALOR"			,oFont8)
		oPrint:Say  (415,468, "UNITARIO"		,oFont8)

		oPrint:Line (395,510,420,510)
		oPrint:Say  (405,521, "VALOR"			,oFont8)
		oPrint:Say  (415,523, "TOTAL"			,oFont8)

		_nLin := 435
	Else
		_nLin := 320
	EndIf

Return()

/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Programa  ³xBrEnvMail³ Autor ³ Everson Santana       ³ Data ³19/07/18  ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³ Envio Do Orcamento/Cotacao por e-mail automaticamente      ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Uso       ³ Especifico Steck                                           ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function xBrEnvMail(oGraphic,cAssunto,aTexto,cTo,cCC,aTabela,nEspacos,lJob)
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
	Local _aAttach 		:= {}//'c:\six0101.dbf'
	Local _cCaminho 	:= cStartPath
	Local _nIni:=1
	Local _nFim:=100

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

	cMensagem += "<br><font Face='CALIBRI' >" + "Factura enviada automaticamente por el sistema PROTHEUS" + "</font></br>"
	cMensagem += "<br><font Face='CALIBRI' >" + "Enviado por: " + UsrFullName(RetCodUsr()) + "</font></br>"
	cMensagem += "<br><font Face='CALIBRI' >" + "No Responda este correo, por favor, por consultas o comentarios, reenvielo a ventas.ar@steckgroup.com" + "</font></br>"
	cMensagem += "<br><font Face='CALIBRI' >" + "Factura nro.: " + _cDocum + "</font></br>"

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

	//If lJob

	cCopia := GetMv("ST_NOTEMAI",,"everson.santana@steck.com.br")

	If !Empty(_cNotCred)
		cCopia := cCopia+";"+_cNotCred
	Endif

	/*
	Else

	cCopia:=_cNotCred //Ticket 20190412000121

	EndIF
	*/

	If  !(	U_ARMAILTES(cEmailFor,cCopia,titulo,cMensagem,_aAttach,_cCaminho)  )
		MsgInfo("Correo no enviado.....!!!!!")
	EndIf

	If lJob

		If cTipo == 2

			DbSelectArea("SF2")
			DbSetOrder(1)
			DbGotop()
			DbSeek(xFilial("SF2")+_cDocum)

			SF2->(RecLock("SF2",.F.))

			SF2->F2_ENVLOG		:= "Factura "+_cDocum+" enviada automáticamente por el sistema PROTHEUS para "+cEmailFor

			SF2->(MsUnlock())

		Else

			DbSelectArea("SF1")
			DbSetOrder(1)
			DbGotop()
			DbSeek(xFilial("SF1")+_cDocum)

			SF1->(RecLock("SF1",.F.))

			SF1->F1_ENVLOG := "Factura "+_cDocum+" enviada automáticamente por el sistema PROTHEUS para "+cEmailFor

			SF1->(MsUnlock())

		EndIF

	EndIf

Return lOk


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

Static Function StMSg()

	Local _cText:= "<br><font Face='ARIAL' style='color:#0000FF;' >Comentarios:</br> "+;
	mMemo+"</font>"+;
	"<br>Estimado cliente, "+;
	"De acuerdo a la normativa de la AFIP, nuestra empresa emite sus facturas en forma electrónica remitiendo la misma exclusivamente por mail, como en este caso.  Por tal motivo, es necesario tengan a bien acusar recibo de su recepción."+;
	"Cabe destacar que la factura electrónica, a efectos impositivos, tiene el mismo valor que las emitidas hasta el momento de manera impresa. A su vez, es completamente válida debido a que es exigida por la AFIP a determinados contribuyentes establecidos en la RG."+;
	"IMPORTANTE:                  "+;
	"Pueden optar por imprimirla en papel para proceder a su archivo en forma tradicional o adherir al sistema de archivo electrónico, si no estuviera comprendido en forma obligatoria."+;
	"Ante cualquier consulta no dude en comunicarse con nosotros.-</br>"+;
	"Cordialmente.- "

Return  (alltrim(_cText))


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
Busco a taxa do dia
*/
Static Function VerTaxa(dData,nRemito)

	Local _cQry := ""
	Local _cQry1 := ""
	Local _nRet := 0
	Local _cRefMoed := 2

	If Select("TRC") > 0
		TRC->(DbCloseArea())
	Endif

	_cQry1 := " "
	_cQry1 += " SELECT DISTINCT F2_REFMOED FROM "+RetSqlName("SF2") "
	_cQry1 += " WHERE F2_DOC = '" + nRemito +"' "
	_cQry1 += " AND D_E_L_E_T_ = ' ' "

	TcQuery _cQry1 New Alias "TRC"

	_cRefMoed := TRC->F2_REFMOED

	If Select("TRD") > 0
		TRD->(DbCloseArea())
	Endif

	_cQry := " "
	_cQry += " SELECT DISTINCT * FROM "+RetSqlName("SM2") "
	_cQry += " WHERE M2_DATA = '" + dtos(dData) +"' "

	_cQry += " AND D_E_L_E_T_ = ' ' "

	TcQuery _cQry New Alias "TRD"

	If _cRefMoed = 1
		_nRet := TRD->M2_MOEDA1
	ElseIf _cRefMoed = 2
		_nRet := TRD->M2_MOEDA2
	ElseIf _cRefMoed = 3
		_nRet := TRD->M2_MOEDA3
	ElseIf _cRefMoed = 4
		_nRet := TRD->M2_MOEDA4
	ElseIF _cRefMoed = 5
		_nRet := TRD->M2_MOEDA5
	Else
		_nRet := TRD->M2_MOEDA2
	EndIf

Return(_nRet)


/*
Verifico os pedidos faturados para um determinado Factura
*/
Static Function VerPed(nFactura)

	Local _cQry := ""
	Local _cRet := ""

	If Select("TRD") > 0
		TRD->(DbCloseArea())
	Endif

	_cQry := " "
	_cQry += " SELECT DISTINCT D2_PEDIDO FROM "+RetSqlName("SD2") "
	_cQry += " WHERE D2_DOC = '" + nFactura +"' "
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
Verifico o numero da ordem de compra no pedido de venda.
*/
Static Function VerOrPc(cPedido)

	Local _cQry 	:= ""
	//Local _cRet 	:= ""
	//Local _cRetDt 	:= ""
	If Select("TRD") > 0
		TRD->(DbCloseArea())
	Endif

	_cQry := " "
	_cQry += " SELECT DISTINCT C5_XORPC,C5_XDTORC FROM "+RetSqlName("SC5") "
	_cQry += " WHERE C5_NUM = '" + StrTran(cPedido,",","") +"' "
	_cQry += " AND D_E_L_E_T_ = ' ' "

	TcQuery _cQry New Alias "TRD"

	TRD->(dbGoTop())

	Aadd(_aRetOrc,{TRD->C5_XORPC,TRD->C5_XDTORC})
	//_cRet 	:= TRD->C5_XORPC
	//_cRetDt := TRD->C5_XDTORC

Return(_aRetOrc)

/*
Verifico o numero do protocolo
*/
Static Function VerProt(cChave)

	Local _cQry := ""
	//Local _cRet := ""

	If Select("TRD") > 0
		TRD->(DbCloseArea())
	Endif

	/*
	_cQry := " "
	_cQry += " SELECT NFE_PROT FROM SPED050L "
	_cQry += " WHERE NFE_ID = '"+cChave+"'  "
	_cQry += " AND D_E_L_E_T_ = ' ' "
	*/

	_cQry := " "
	_cQry += " SELECT NFE_PROT,FCH_VENC FROM SPED054L"
	_cQry += " WHERE NFE_ID = '"+cChave+"'  "
	_cQry += "AND NFE_PROT <> ' ' "
	_cQry += " AND D_E_L_E_T_ = ' ' "


	TcQuery _cQry New Alias "TRD"

	TRD->(dbGoTop())

	Aadd(_aRet,{ TRD->NFE_PROT, TRD->FCH_VENC })
	//_cRet := TRD->NFE_PROT


Return(_aRet)

//----- Calcula Digito Verificador usando modulo 10
//----- Sequencia de Numeros para calculo do digito verificador
STATIC FUNCTION CalcMod10(_cNros)

	Local i

	//_cNros := '01234567890'
	aNros 		:= {}
	_cProdutos:= ''
	_nsoma		:= 0
	For i := Len(_cNros) to 1 step -1
		AADD(aNros,Subs(_cNros,i,1))
	Next
	For i := 1 to Len(aNros)
		If !( i%2 ) = 0
			/*[ Posicao Par na Sequencia ]*/
			_cProdutos := _cProdutos+alltrim(str(Val(aNros[i])*1	))
		Else
			/*[ Posicao Impar na Sequencia ]*/
			_cProdutos := _cProdutos+alltrim(str(Val(aNros[i])*1))
		Endif
	Next
	For i:= 1 to Len(_cProdutos)
		_nSoma := _nSoma+Val(Subs(_cProdutos,i,1))
	Next
	_nDV  := 10 - Mod(_nSoma,10)
	_nDV 	:= IIF( _nDV==10, 0, _nDV )
	_cDv :=	 Alltrim(Str(_nDV))
Return _cDv


/*
Criacao e apresentacao das perguntas
*/
Static Function ValidPerg()
	Local _sAlias := GetArea()
	Local _aRegs  := {}
	Local i := 0
	Local j := 0
	_cPerg         := PADR(_cPerg,10)
	AADD(_aRegs,{_cPerg,"01","De Factura ?  ","De Factura ?","De Factura ?" ,"mv_ch1","C",12,0,0,"G","          ","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(_aRegs,{_cPerg,"02","A Factura  ?  ","A Factura  ?","A Factura  ? ","mv_ch2","C",12,0,0,"G","          ","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(_aRegs,{_cPerg,"03","Serie  ?  "     ,"Serie  ?"     ,"Serie  ? "     ,"mv_ch3","C",03,0,0,"G","          ","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(_aRegs,{_cPerg,"04","Tipo de Operación  ? "     ,"Tipo de Operación  ?","Tipo de Operación  ?"     ,"mv_ch4","C",01,0,0,"C","          ","mv_par04","1=Entrada","1=Entrada","1=Entrada","","","2=Salida","2=Salida","2=Salida","","","","","","","","","","","","","","","","","",""})
	AADD(_aRegs,{_cPerg,"05","Imprimi el lote?  "     ,"Imprimi el lote  ?"     ,"Imprimi el lote  ? "     ,"mv_ch4","N",01,0,0,"C","          ","mv_par05","Sin","Sin","Sin","","","No","No","No","","","","","","","","","","","","","","","","","",""})
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

Static Function ARFATNOT(_ajob)

	Local _cAssunto := "[WFPROTHEUS] Notificacion de Factura no enviada."
	Local cFuncSent := "ARFAT04"
	Local _aAttach  := {}
	Local titulo	:= "[WFPROTHEUS] Notificacion de Factura no enviada."
	Local _cCaminho := cStartPath
	Local _cEmail   := GetMv("ST_NOTEMAI",,"everson.santana@steck.com.br")
	Local _nLin


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Definicao do cabecalho do email                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cMsg := ""
	cMsg += '<html>'
	cMsg += '<head>'
	cMsg += '<title>' + _cAssunto + " - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title>'
	cMsg += '</head>'
	cMsg += '<body>'
	cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
	cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
	cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>' + _cAssunto +" - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+ '</FONT> </Caption>'
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Definicao do texto/detalhe do email                                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For _nLin := 1 to Len(_ajob)
		IF (_nLin/2) == Int( _nLin/2 )
			cMsg += '<TR BgColor=#B0E2FF>'
		Else
			cMsg += '<TR BgColor=#FFFFFF>'
		EndIF
		cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _ajob[_nLin,1] + ' </Font></B></TD>'
		cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + _ajob[_nLin,2] + ' </Font></TD>'
		cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + _ajob[_nLin,3] + ' </Font></TD>'
		cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + _ajob[_nLin,4] + ' </Font></TD>'
		cMsg += '</TR>'
	Next
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Definicao do rodape do email                                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cMsg += '</Table>'
	cMsg += '<P>'
	cMsg += '<Table align="center">'
	cMsg += '<tr>'
	cMsg += '<td colspan="10" align="center"><font color="red" size="3">Mensagem enviada automaticamente pelo sistema PROTHEUS - <font color="red" size="1">('+cFuncSent+')</td>'
	cMsg += '</tr>'
	cMsg += '</Table>'
	cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
	cMsg += '</body>'
	cMsg += '</html>'

	If  !(	U_ARMAILTES(_cEmail,cCopia,titulo,cMsg,_aAttach,_cCaminho)  )
		MsgInfo("Correo no enviado.....!!!!!")
	EndIf

Return

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

	cEMail	 		:= Alltrim(cEMail) + Space(200)

	// Variaveis Private da Funcao
	Private _oDlg				// Dialog Principal
	Private INCLUI := .F.	// (na Enchoice) .T. Traz registro para Inclusao / .F. Traz registro para Alteracao/Visualizacao

	DEFINE MSDIALOG _oDlg TITLE OemtoAnsi("Envío automático de correo electrónico") FROM C(330),C(243) TO C(500),C(721) PIXEL

	// Cria Componentes Padroes do Sistema
	@ C(013),C(010) Say "Enviar correo electrónico al cliente que aparece a continuación? (Separar por ';')" Size C(167),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	@ C(020),C(010) MsGet oEdit1 Var cEMail Size C(218),C(009) COLOR CLR_BLACK PIXEL OF _oDlg Picture "@S60"

	If !Empty(SF2->F2_VEND1)
		@ C(030),C(010) Say "CC: " + cCopia Size C(167),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
	EndIf

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
