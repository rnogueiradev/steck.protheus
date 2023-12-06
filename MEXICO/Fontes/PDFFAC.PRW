#Include "PROTHEUS.Ch"
#include "TbiConn.ch" 
//FUNCION DE USUARIO PARA MANDAR IMPRIMIR FORMATO DE FACTURA Y NOTA DE CREDITO

USER FUNCTION PDFFAC()
    Local __aArea:= Getarea()
    Private cNumFac     := PARAMIXB[1]
    Private cSerie      := PARAMIXB[2]
    Private cEspecie    := PARAMIXB[3]
    Private cCliente    := PARAMIXB[4] 
    Private cLoja       := PARAMIXB[5]
    Private cTpOper     := "I"
    Private cRUTASRV 	:= &(SuperGetmv( "MV_CFDDOCS" , .F. , "\cfd\facturas\" ))	// Ruta donde se encuentran las facturas.xml (servidor)
    Private	cNameCFDI := Lower( Alltrim(cEspecie) + "_" + Alltrim(SubStr(cSerie,1,3)) + "_" + Alltrim(cNumFac) + ".xml" )	
	Private	cNCFDIpdf := Lower( Alltrim(cEspecie) + "_" + Alltrim(SubStr(cSerie,1,3)) + "_" + Alltrim(cNumFac) + ".pdf" )
    Private lFactura := .T.
    Private cObservaciones:= ""
    Private cTimbre := ""
    Private lVisPDF     := .F.

    lFactura  := IIF(Alltrim(cEspecie) =="NF" .or. Alltrim(cEspecie) =="NDC",.T.,.F.)
    IF lFactura
        DbSelectarea("SF2")
        dbSetOrder(1)
        Dbseek(xfilial("SF2")+cNumFac+cSerie+cCliente+cLoja)
    Else
        DbSelectarea("SF1")
        dbSetOrder(1)
        Dbseek(xfilial("SF1")+cNumFac+cSerie+cCliente+cLoja)
    Endif
    IF Funname() $ "FATA750"
        cTpOper :="I"
    Endif
    
	
    U_EFAT004(cNumFac , cSerie , cEspecie , cCliente , cLoja, cTpOper, lVisPDF) //l
    Restarea(__aArea)
Return


/* 	--------------------------------------------------------------------------
		Función: 	EFAT003
					Nota Fiscal de salida
		Parámetros: - cTP: Tipo de operación, (A)rchivo, (E)mail, (I)mprimir
	-------------------------------------------------------------------------- */
User Function EFAT004(cNumFac , cSerie , cEspecie , cCliente , cLoja, cTpOper, lVisPDF)
		Private cVendedor	:= ""
        IF lFactura  
            cVendedor	:= IIF(!Empty(SF2->F2_VEND1),UPPER(POSICIONE("SA3", 1, XFILIAL("SA3") + SF2->F2_VEND1, 'SA3->A3_NOME')),"")
            cTimbre 		:= SF2->F2_TIMBRE
			cObservaciones	:= SF2->F2_MENNOTA
    		Processa({ |lEnd| FATR01IM7("Generación de Archivos de Facturación Electrónica")},"Generando archivos , aguarde...")		
            /*
            dbselectarea("SF2")  //Abre el Archivo SF1 de NCC
            Reclock("SF2",.F.)
            SF2->F2_STATUS:="2"
            MsUnlock()
            */
        Else
    	    cVendedor	:= IIF(!Empty(SF1->F1_VEND1),UPPER(POSICIONE("SA3", 1, XFILIAL("SA3") + SF1->F1_VEND1, 'SA3->A3_NOME')),"")
            cTimbre := SF1->F1_TIMBRE
    		Processa({ |lEnd| FATR01IM7("Generación de Archivos de Facturación Electrónica")},"Generando archivos , aguarde...")		
            /*
            dbselectarea("SF1")  //Abre el Archivo SF1 de NCC
            Reclock("SF1",.F.)
            SF1->F1_STATUS:="2"
            MsUnlock()
            */
        Endif
Return              




/* 	--------------------------------------------------------------------------
		Función: 	FATR01IM7
					Gestiona las operaciones de generación, impresión y envío
					de las facturas electrónicas
	-------------------------------------------------------------------------- */
Static Function FATR01IM7()
	Local i 	 		:= 	1
	Local nIxb	 		:= 	0
	Local cRuta		:=	""
	Local cMensaje	:=	""
	Local cBodyMsg	:=	""

	Private oPrint	:= 	NIL
	Private nLin    	:= 	500
	Private nSalto  	:= 	60
	Private cMail2  	:= 	""
	Private cMail3  	:=  ""

	oXml			:=	Nil

	Titulo			:= 	PADC("Factura",74)
	lEnd      		:= 	.F.
	If ( cTpOper == "I" ) .OR. ( cTpOper == "A" )
        IF funname()=="MATA750" .or. !lVisPDF
		    oPrint		:= FWMsPrinter():New(cNCFDIpdf,6,.T.,,.T.,,,,,,,.F.,)	
        ElseIF (Funname() $ "MATR475/MATA467N/MATA468N" .AND. lVisPDF) 
		    oPrint		:= FWMsPrinter():New(cNCFDIpdf,6,.T.,,.T.,,,,,,,.T.,)	            
        Endif
	ElseIf ( cTpOper == "E" )
		oPrint		:= FWMsPrinter():New(cNCFDIpdf,6,.T.,,.T.,,,,,,,.F.,)
	EndIF
	IF oPrint == NIL
	    oPrint		:= FWMsPrinter():New(cNCFDIpdf,6,.T.,,.T.,,,,,,,.T.,)	            
	Endif

	oPrint:SetResolution(72)
	oPrint:SetPortrait()
	oPrint:SetPaperSize(1)
	oPrint:cPathPDF:= "C:\SPOOL\Facturas\"

	oXml 	:= 	GetXML()
	if ( oXml == Nil )
		FreeObj(oPrint)
		return(.F.)
	endif

	Imprime(oXml)

	nLin			:=	0
	
	// Elimina el PDF anterior
	ferase(oPrint:cPathPDF + cNCFDIpdf)
	
	oPrint:Print()
	
	// Copia el PDF final para la carpeta del servidor
	COPY FILE (oPrint:cPathPDF + cNCFDIpdf) TO (cRutaSRV + cNCFDIpdf)  

	FreeObj(oPrint)

	if lFactura
		cRelto 	:= Alltrim(Posicione("SA1",1,xFilial("SA1")+cCliente + cLOJA, "A1_EMAIL"))		
		cNomeTo	:= Alltrim(Posicione("SA1",1,xFilial("SA1")+cCliente + cLOJA, "A1_NOME"))		
		
		//Se agrega en el caso de no existir correo
		cRelTo := Padr(cRelTo,200)
		cMensaje := cNomeTo + CHR(13) + CHR(10)
		cMensaje += CHR(13) + CHR(10)
		cMensaje += "Estimado(a):" + CHR(13) + CHR(10)
		cMensaje += CHR(13) + CHR(10)
		cMensaje += "Por este medio le estamos enviando su Comprobante Fiscal Digital, correspondiente al documento: " + cNumFac + ", serie:" + cSerie + CHR(13) + CHR(10)
		cMensaje += CHR(13) + CHR(10)
		cMensaje += "Adjunto a este correo electrónico, le estamos enviando un archivo con extensión XML el cual es su factura electrónica conforme a la normatividad del SAT. " + CHR(13) + CHR(10)
		cMensaje += CHR(13) + CHR(10)
		cMensaje += "Adicionalmente, le estamos enviando un archivo con extensión PDF el cual es una versión legible del archivo XML. " + CHR(13) + CHR(10)
		cMensaje += CHR(13) + CHR(10)
		cMensaje += "Dicho archivo lo puede ud. imprimir cuantas veces lo requiera. " + CHR(13) + CHR(10)
		cMensaje += CHR(13) + CHR(10)
		cMensaje += "Favor de revisar sus datos, si tiene alguna corrección hacerla dentro de los siguientes 30 días " + CHR(13) + CHR(10)
		cMensaje += CHR(13) + CHR(10)
		cMensaje += CHR(13) + CHR(10)
		cMensaje += CHR(13) + CHR(10)
		cMensaje += "Gracias por su compra. " + CHR(13) + CHR(10)

		cBodyMsg := "<html>"
		cBodyMsg += "<head></head>"
		cBodyMsg += "<body>"
		cBodyMsg += "<div>"
		cBodyMsg += "<p><span>"+cNomeTo+"<o:p></o:p></span></p>"
		cBodyMsg += "<p><span>Estimado(a): <o:p></o:p></span></p>"
		cBodyMsg += "<p>Por este medio le estamos enviando su Comprobante Fiscal Digital, correspondiente al documento: " + cNumFac + ", serie:" + cSerie +" <o:p></o:p></span></p>"
		cBodyMsg += "<p><span>Adjunto a este correo electr&oacute;nico, le estamos enviando un archivo con extensi&oacute;n XML el cual es su factura electr&oacute;nica conforme a la normatividad del SAT. <o:p></o:p></span></p>"
		cBodyMsg += "<p><span>Adicionalmente, le estamos enviando un archivo con extensi&oacute;n PDF el cual es una versi&oacute;n legible del archivo XML. <o:p></o:p></span></p>"
		cBodyMsg += "<p><span>Dicho archivo lo puede ud. imprimir cuantas veces lo requiera. <o:p></o:p></span></p>"
		cBodyMsg += "<p><span>Favor de revisar sus datos, si tiene alguna correcci&oacute;n hacerla dentro de los siguientes 30 d&iacute;as <o:p></o:p></span></p>"
		cBodyMsg += "<p><span>Gracias por su compra.<o:p></o:p></span></p>"
		cBodyMsg += "</div>"
		cBodyMsg += "</body>"
		cBodyMsg += "</html>"
	else
		cRelto 	:= Alltrim(Posicione("SA1",1,xFilial("SA1")+cCliente + cLOJA, "A1_EMAIL"))
		cNomeTo	:= Alltrim(Posicione("SA1",1,xFilial("SA1")+cCliente + cLOJA, "A1_NOME"))		
		
		cRelTo := Padr(cRelTo,200)

		cMensaje := cNomeTo + CHR(13) + CHR(10)
		cMensaje += CHR(13) + CHR(10)
		cMensaje += "Estimado(a):" + CHR(13) + CHR(10)
		cMensaje += CHR(13) + CHR(10)
		cMensaje += "Por este medio le estamos enviando su Comprobante Fiscal Digital, correspondiente al documento: " + cNumFac + ", serie:" + cSerie + CHR(13) + CHR(10)
		cMensaje += CHR(13) + CHR(10)
		cMensaje += "Adjunto a este correo electrónico, le estamos enviando un archivo con extensión XML el cual es su factura electrónica conforme a la normatividad del SAT. " + CHR(13) + CHR(10)
		cMensaje += CHR(13) + CHR(10)
		cMensaje += "Adicionalmente, le estamos enviando un archivo con extensión PDF el cual es una versión legible del archivo XML. " + CHR(13) + CHR(10)
		cMensaje += CHR(13) + CHR(10)
		cMensaje += "Dicho archivo lo puede ud. imprimir cuantas veces lo requiera. " + CHR(13) + CHR(10)
		cMensaje += CHR(13) + CHR(10)
		cMensaje += "Favor de revisar sus datos, si tiene alguna corrección hacerla dentro de los siguientes 30 días " + CHR(13) + CHR(10)
		cMensaje += CHR(13) + CHR(10)
		cMensaje += CHR(13) + CHR(10)
		cMensaje += CHR(13) + CHR(10)

		cBodyMsg := "<html>"
		cBodyMsg += "<head></head>"
		cBodyMsg += "<body>"
		cBodyMsg += "<div>"
		cBodyMsg += "<p><span>"+cNomeTo+"<o:p></o:p></span></p>"
		cBodyMsg += "<p><span>Estimado(a): <o:p></o:p></span></p>"
		cBodyMsg += "<p>Por este medio le estamos enviando su Comprobante Fiscal Digital, correspondiente al documento: " + cNumFac + ", serie:" + cSerie +" <o:p></o:p></span></p>"
		cBodyMsg += "<p><span>Adjunto a este correo electr&oacute;nico, le estamos enviando un archivo con extensi&oacute;n XML el cual es su factura electr&oacute;nica conforme a la normatividad del SAT. <o:p></o:p></span></p>"
		cBodyMsg += "<p><span>Adicionalmente, le estamos enviando un archivo con extensi&oacute;n PDF el cual es una versi&oacute;n legible del archivo XML. <o:p></o:p></span></p>"
		cBodyMsg += "<p><span>Dicho archivo lo puede ud. imprimir cuantas veces lo requiera. <o:p></o:p></span></p>"
		cBodyMsg += "<p><span>Favor de revisar sus datos, si tiene alguna correcci&oacute;n hacerla dentro de los siguientes 30 d&iacute;as <o:p></o:p></span></p>"
		//cBodyMsg += "<p><span>Gracias por su compra.<o:p></o:p></span></p>"
		cBodyMsg += "</div>"
		cBodyMsg += "</body>"
		cBodyMsg += "</html>"

	endif

	if Alltrim(FUNNAME()) <> "FATA750"       								// Envío por correo electrónico.
		if ( MsgYesNo("¿Continuar con el envío del Comprobante Fiscal Digital por correo electrónico?") )
			cCaminhoXML := &(GetMv("MV_CFDDOCS"))
			aAttach 	:= {}
			cRelFrom 	:= GetMV("MV_RELACNT")

			AAdd(aAttach, cRutaSRV+cNCFDIpdf)
			AAdd(aAttach, cCaminhoXML+cNameCFDI)

			aAtcBkp := AClone(aAttach)

			if ( MBSendMail(GetMV("MV_RELACNT"),GetMV("MV_RELPSW"),GetMV("MV_RELSERV"),cRelFrom,cRelTo,"Envio de documento CFDI:  " + cNCFDIpdf,cMensaje,cBodyMsg,aAttach) )
				ApMsgInfo("¡CFDI enviado correctamente!", "Envío de CFDI")
			else
				ApMsgStop("¡No se realizó el envío de archivos digitales!","Envío de CFDI")
			endif
		endif
	endif
Return(.T.)

/* 	--------------------------------------------------------------------------
		Función: 	GetXML
					Realiza la lectura del archivo XML del documento y lo
					devuelve como un objeto.
		Retorno:
			oXML: 	Objeto con el contenido del archivo XML leído para el
					documento.
	-------------------------------------------------------------------------- */
Static Function GetXML()
	Local cCaminhoXML	:= &(GetMv("MV_CFDDOCS"))
	Local cNom          := ""
	Local oXML			:= Nil
	Local cAviso		:= ""
	Local cErro		:= ""
	Local cRuta		:= ""

	if lFactura  //Especie = NF o NDC
		cNom  := &(GetMv("MV_CFDNAF2"))
		cRuta := cCaminhoXML + cNom
	else
		cNom  :=  &(GetMv("MV_CFDNAF1"))
		cRuta := cCaminhoXML + cNom
	endif

	if ( !File(cRuta) )
		MsgAlert("El archivo XML del documento: "+ cNom +" no fué localizado en la ruta: "+ cCaminhoXML  +" , por tal motivo no será posible realizar la impresión del mismo.")
		return(Nil)
	endif
	oXML := XmlParserFile(cRuta, "_", @cAviso,@cErro )

	if ( !Empty(cAviso) .or. !Empty(cErro) )
		MsgAlert("Se detectaron problemas con el archivo XML: " +Chr(13)+Chr(10)+Upper(cAviso)+Chr(13)+Chr(10)+Upper(cErro))
		return(Nil)
	endif
Return(oXML)
/* 	--------------------------------------------------------------------------
		Función: 	Imprime
					Realiza la impresión del formato de la factura o nota.
		Parámetros:
			oXML: 	Objeto con el contenido del archivo XML leído para el
					documento.
	-------------------------------------------------------------------------- */
Static Function Imprime(oXML)
	// Coordenadas
	Private nPagLim		:= 3200	// Indica el límite vertical de la página para considerar EN LA PÁGINAción del formato.
	Private nPagNum		:= 1		// Indica el número de página actual.
	Private cDescItems  	:= 0
	Private cRetItems		:= 0
	Private nEmiX			:= 330		// Coordenadas de columna en donde inician datos del emisor
	Private nEmiY 		:= 130		// Coordenadas de línea en donde inician los datos del emisor
	Private nFacX			:= 1650   	// Columna de inicio de datos de factura en encabezado
	Private nFacY			:= 50		// Línea de inicio de datos de factura en enabezado
	Private nCliX			:= 120		// Columna de inicio de datos del cliente en encabezado
	Private nCliY			:= 458		// Línea de inicio de datos del cliente en encabezado
	Private nCdvX			:= 120   	// Columna de inicio de datos de Condiciones de venta
	Private nCdvY			:= 845		// Línea de inicio de datos de Condiciones de venta
	Private nDetX			:= 120 	// Columna de inicio de datos del detalle de la factura
	Private nDetY			:= 780		// Línea de inicio de datos del detalle de la factura. Se cambia, era 1000
	Private nFotX			:= 120		// Columna en donde comienza la impresión del pie del reporte.
	Private nFotY			:= 0		// Línea en donde comienza la impresión del pie del reporte.
	Private jmp			:= 40		// Tamaño del salto

	// Fuentes
	Private oFont08		:= TFont():New("Courier New",08,08,,.F.,,,,.T.,.F.)
	Private oCouNew06		:= TFont():New("Courier New",06,06,,.F.,,,,.T.,.F.)
	Private oCouNew07N	:= TFont():New("Courier New",07,07,,.T.,,,,.T.,.F.)
	Private oCouNew08		:= TFont():New("Courier New",08,08,,.F.,,,,.T.,.F.)
	Private oCouNew08N	:= TFont():New("Courier New",08,08,,.T.,,,,.T.,.F.)
	Private oCouNew09		:= TFont():New("Courier New",09,09,,.F.,,,,.T.,.F.)
	Private oCouNew09N	:= TFont():New("Courier New",09,09,,.T.,,,,.T.,.F.)
	Private oCouNew10		:= TFont():New("Courier New",10,10,,.F.,,,,.T.,.F.)
	Private oCouNew10N	:= TFont():New("Courier New",10,10,,.T.,,,,.T.,.F.)
	Private oCouNew11		:= TFont():New("Courier New",11,11,,.F.,,,,.T.,.F.)
	Private oCouNew11N	:= TFont():New("Courier New",11,11,,.T.,,,,.T.,.F.)

	Private oArial08  	:= TFont():New("Arial",08,08,,.F.,,,,.T.,.F.)
	Private oArial08N		:= TFont():New("Arial",08,08,,.T.,,,,.T.,.F.)
	Private oArial09  	:= TFont():New("Arial",09,09,,.F.,,,,.T.,.F.)
	Private oArial09N		:= TFont():New("Arial",10,10,,.T.,,,,.T.,.F.)
	Private oArial10  	:= TFont():New("Arial",10,10,,.F.,,,,.T.,.F.)
	Private oArial10N		:= TFont():New("Arial",10,10,,.T.,,,,.T.,.F.)
	Private oArial11 		:= TFont():New("Arial",11,11,,.F.,,,,.T.,.F.)
	Private oArial11N		:= TFont():New("Arial",11,11,,.T.,,,,.F.,.F.)
	Private oArial12 		:= TFont():New("Arial",12,12,,.F.,,,,.T.,.F.)
	Private oArial12N		:= TFont():New("Arial",12,12,,.T.,,,,.F.,.F.)
	Private oArial13 		:= TFont():New("Arial",13,13,,.F.,,,,.T.,.F.)
	Private oArial13N		:= TFont():New("Arial",13,13,,.T.,,,,.F.,.F.)
	Private oArial14		:= TFont():New("Arial",14,14,,.F.,,,,.F.,.F.)
	Private oArial14N		:= TFont():New("Arial",14,14,,.T.,,,,.F.,.F.)		   	// Negrito
	Private oArial16		:= TFont():New("Arial",16,16,,.F.,,,,.F.,.F.)
	Private oArial16N		:= TFont():New("Arial",16,16,,.T.,,,,.F.,.F.)		   	// Negrito
	Private oArial18N		:= TFont():New("Arial",18,18,,.T.,,,,.F.,.F.)		   	// Negrito
	Private oArial20N		:= TFont():New("Arial",20,20,,.T.,,,,.F.,.F.)		   	// Negrito
	Private oArial22N		:= TFont():New("Arial",22,22,,.T.,,,,.F.,.F.)		  	// Negrito
	Private oArialB23N	:= TFont():New("Arial black",23,23,,.T.,,,,.F.,.F.)	// Negrito
	Private oArialB24N	:= TFont():New("Arial black",24,24,,.T.,,,,.F.,.F.)	// Negrito
	Private oCal16b		:= TFont():New("Calibri",16,16,,.T.,,,,.F.,.F.)
	Private oCal14b		:= TFont():New("Calibri",14,14,,.T.,,,,.F.,.F.)
	Private oCal14		:= TFont():New("Calibri",14,14,,.F.,,,,.F.,.F.)
	Private oCal12b		:= TFont():New("Calibri",11,11,,.T.,,,,.F.,.F.)		//cambio de 12 a 11      negrito
	Private oCal12		:= TFont():New("Calibri",12,12,,.F.,,,,.F.,.F.)
	Private oCal10		:= TFont():New("Calibri",10,10,,.F.,,,,.F.,.F.)
	Private oCal08		:= TFont():New("Calibri",08,08,,.F.,,,,.F.,.F.)
	Private oCal10b		:= TFont():New("Calibri",10,10,,.T.,,,,.F.,.F.)

	Private oBrush		:= TBrush():New(,CLR_BLUE) 
	Private oBrushGray	:= TBrush():New(,13092807)       // Buscar en http://cloford.com/resources/colours/500col.htm
	Private oBrushLGren	:= TBrush():New(,4231485)
	Private oBrushWhite	:= TBrush():New(,16777215)
	Private oBrushLRed	:= TBrush():New(,255)

    Private nDifLBox	:= 4
    Private nDifLTxt	:= 30

	oPrint:StartPage() 														// Inicia nueva página
	PrtHeader(oXML)               										  	// Imprimir encabezado
	nFotY := ImpDet(oXML)				 						   			// Imprimir el detalle de la factura
	PrtFooter(oXML)													   		// Imprimir pie de página
	oPrint:EndPage()
Return .T.
/* 	--------------------------------------------------------------------------
		Función: 	PrtHeader
					Imprime la sección de encabezado del documento.
		Parámetros:
			oXML: 	Objeto con el contenido del archivo XML leído para el
					documento.
	-------------------------------------------------------------------------- */
Static Function PrtHeader(oXML)
	Local cLogoCli	:=  GetSrvProfString("Startpath","") + "LOGOFAC"+cEmpAnt+".JPG"				// Logo según filial en caso de requerirse
	
	//DOMICILIO FISCAL EMISOR
	Local cEmisor	   	:= OemToAnsi(oXML:_cfdi_COMPROBANTE:_cfdi_EMISOR:_NOMBRE:TEXT)
	Local cRfc			:= OemToAnsi("R.F.C.: "+oXML:_cfdi_COMPROBANTE:_cfdi_EMISOR:_RFC:TEXT) 
	Local cCalle		:= OemToAnsi(Alltrim(SM0->M0_ENDCOB))
	Local cMunic		:= OemToAnsi(Alltrim(SM0->M0_CIDCOB))
	Local cEstado		:= OemToansi("NL")      //todo JARS
	Local cPais			:= Alltrim("MEXICO")
	Local cComp			:= ""//OemToAnsi(oXML:_cfdi_COMPROBANTE:_cfdi_EMISOR:_cfdi_DOMICILIOFISCAL:_NOEXTERIOR:TEXT)
	Local cColonia		:= OemToAnsi(Alltrim(SM0->M0_BAIRCOB))
//	Local cCP			:= OemToAnsi(AllTrim(SM0->M0_CEPCOB)) 
	Local cCodpos  		:= AllTrim(oXML:_cfdi_COMPROBANTE:_LUGAREXPEDICION:TEXT) 
	
	Local cTipoCompr  	:= AllTrim(oXML:_cfdi_COMPROBANTE:_TIPODECOMPROBANTE:TEXT) 
	Local cTipoCambio  	:= AllTrim(oXML:_cfdi_COMPROBANTE:_TIPOCAMBIO:TEXT) 
	Local cVersion 		:= AllTrim(oXML:_cfdi_COMPROBANTE:_VERSION:TEXT)   
	
	Local cCFDIRel		:= ""
	
 	Local cCP			:= cCodpos  
	//DATOS DE LA FACTURA
	Local cCert		:= OemToAnsi(oXML:_cfdi_COMPROBANTE:_NOCERTIFICADO:TEXT)
	Local cCertSAT	:= " "
	Local cFolioFis	:= " "
	Local cFechaTimbre	:= " "
	Local cFECHAXml		:= oXML:_cfdi_COMPROBANTE:_FECHA:TEXT
	Local cFECHAFac		:= SubStr(cFECHAXml,9,2)+"/"+SubStr(cFECHAXml,6,2)+"/"+SubStr(cFECHAXml,1,4)+" "+SubStr(cFECHAXml,12,8)
	Local cForPag		:= AllTrim(oXML:_cfdi_COMPROBANTE:_FORMAPAGO:TEXT)
	//DATOS  DEL CLIENTE
	Local cNumClie	:= ""
	Local cCliNom		:= oXML:_cfdi_COMPROBANTE:_cfdi_RECEPTOR:_NOMBRE:TEXT
	Local cCliRfc		:= AllTrim(oXML:_cfdi_COMPROBANTE:_cfdi_RECEPTOR:_RFC:TEXT)
	Local cUsoCFDI		:= AllTrim(oXML:_cfdi_COMPROBANTE:_cfdi_RECEPTOR:_USOCFDI:TEXT)  
	Local cCliCalle		:= "" //OemToAnsi(Alltrim(UPPER(SA1->A1_END)))
	Local cCliNumExt	:= "" //ALLTRIM(UPPER(SA1->A1_NR_END)) 	//AllTrim(oXML:_cfdi_COMPROBANTE:_cfdi_RECEPTOR:_cfdi_DOMICILIO:_NOEXTERIOR:TEXT)
	Local cCliNumInt	:= "" //ALLTRIM(UPPER(SA1->A1_NROINT))
	Local cCliMun		:= "" //AllTrim(UPPER(SA1->A1_MUN))
	Local cCliCol		:= "" //AllTrim(UPPER(SA1->A1_MUN))
	Local cCliEst		:= "" //Alltrim(UPPER(SA1->A1_EST))
	Local cCliPais		:= "" //AllTrim("MEXICO")
	Local cCliCp		:= "" //AllTrim(SA1->A1_CEP) 
	Local cCliIdFis		:= ""
	Local cEntNombr		:= ""
	Local cEntRFC		:= ""
	Local cEntCalle		:= ""
	Local cEntNumExt	:= ""
	Local cEntNumInt	:= ""
	Local centMun		:= ""
	Local cEntEst		:= ""
	Local centPais		:= ""
	Local cEntCp		:= ""

	//DATOS DE LA SUCURSAL-> LUGAR DE EMISION
	Local cEmaiC		:= ""//ALLTRIM(SA1->A1_EMAIL)
	Local cTelC	   		:= ALLTRIM(SA1->A1_EMAIL)
	Local cCliEnt		:= ""
	Local cLojEnt		:= ""        
	Local nQtdRem 		:= 0
	Local cCliIdFis		:= ""
	local lcampos    	:= .T.
	lOCAL i 			:= 1
	Local nCurrentLine := 1
	PRIVATE cSerie	:= OemToAnsi(oXML:_cfdi_COMPROBANTE:_SERIE:TEXT)
	PRIVATE cFolio 	:= OemToAnsi(oXML:_cfdi_COMPROBANTE:_FOLIO:TEXT)
	PRIVATE cOCCliente	:= ""
	PRIVATE cPedido	:= ""
	PRIVATE cDocRem	:= ""
	PRIVATE cSerRem	:= "" 
	PRIVATE cRemision	:= "" 
	Private cRemis  := "" 


	//Agregue
	nTotRet			:= 0
	nTotTras		:= 0    


	if (nPagNum == 1)
		dbSelectArea("SD2")
		dbSetOrder(3)
		dbSeek(xFilial("SD2") + SF2->F2_DOC + SF2->F2_SERIE + SF2->F2_CLIENTE + SF2->F2_LOJA)
		dbSelectArea("SC5")
		dbSetOrder(1)
		dbSeek(xFilial("SC5") + SD2->D2_PEDIDO)
		dbSelectArea("SC6")
		dbSetOrder(1)
		dbSeek(xFilial("SC6") + SD2->D2_PEDIDO)
		dbSelectArea("SA3")
		dbSetOrder(1)
		dbSeek(xFilial("SA3") + SF2->F2_VEND1)		
	endif
	
	
	
    IF XMLChildEx(oXML:_CFDI_COMPROBANTE,"_CFDI_COMPLEMENTO") <> NIL
       cCertSAT	   	:= AllTrim(oXML:_cfdi_comprobante:_cfdi_Complemento:_tfd_TimbreFiscalDigital:_noCertificadoSAT:TEXT)
       cFolioFis	:= AllTrim(oXML:_cfdi_comprobante:_cfdi_Complemento:_tfd_TimbreFiscalDigital:_UUID:TEXT)
       cFechaTimbre	:= AllTrim(oXML:_cfdi_comprobante:_cfdi_Complemento:_tfd_TimbreFiscalDigital:_FechaTimbrado:TEXT)
       cRfcProvCert	:= AllTrim(oXML:_cfdi_comprobante:_cfdi_Complemento:_tfd_TimbreFiscalDigital:_RfcProvCertif:TEXT) 
       cNoCertSAT	:= AllTrim(oXML:_cfdi_comprobante:_cfdi_Complemento:_tfd_TimbreFiscalDigital:_NoCertificadoSAT:TEXT) 
    Else
 		MsgAlert("No se ha Generado el Timbrado del Documento!!")                                                               	
    Endif
    
	If Valtype(XmlChildex(oXML:_CFDI_COMPROBANTE,"_CFDI_CFDIRELACIONADOS")) = "O"
		If Valtype(XmlChildex(oXML:_CFDI_COMPROBANTE:_CFDI_CFDIRELACIONADOS,"_CFDI_CFDIRELACIONADO")) = "A"
			For i := 1 to Len(oXML:_CFDI_COMPROBANTE:_CFDI_CFDIRELACIONADOS:_CFDI_CFDIRELACIONADO)
		 		cCFDIRel2	:= oXML:_CFDI_COMPROBANTE:_CFDI_CFDIRELACIONADOS:_CFDI_CFDIRELACIONADO[i]:_UUID:TEXT  
		 		cCFDIRel 	:= cCFDIRel+" "+cCFDIRel2
	 		NEXT
		ELSE
	 		 cCFDIRel	:= oXML:_CFDI_COMPROBANTE:_CFDI_CFDIRELACIONADOS:_CFDI_CFDIRELACIONADO:_UUID:TEXT 
		endif

		cTipoRel	:= oXML:_CFDI_COMPROBANTE:_CFDI_CFDIRELACIONADOS:_TIPORELACION:TEXT
	Else 
		cCFDIRel	:= ""	
		cTipoRel	:= ""	
	Endif
	cCliEnt := (SC5->C5_CLIENT)
	cLojEnt := (SC5->C5_LOJAENT)
	
	/*
	if Alltrim(SC5->C5_CLIENTE) <> Alltrim(SC5->C5_CLIENT)
		cCliEnt := Alltrim(SC5->C5_CLIENT)
	else
		cCliEnt := alLtrim(SF2->F2_CLIENTE)
	endif
	*/
	cPedido := ALLTRIM(SD2->D2_PEDIDO)

	//Pendiente Orden de compra del cliente
	cOCCliente := alltrim(SF2->F2_ORDENC )

		If  lFactura 					// factura	
	
			cQry := "SELECT DISTINCT D2_REMITO "
			cQry += "FROM " + InitSqlName("SD2")+" SD2 "
			cQry += "WHERE SD2.D2_DOC  = '" + cFolio + "' "
			cQry += "AND SD2.D2_FILIAL = '" + xFilial("SD2") + "' "
			cQry += "AND SD2.D2_SERIE = '" + cSerie + "' "
			cQry += "AND SD2.D_E_L_E_T_ = ' '"
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),"REMIS",.T.,.T.)      
			
			While REMIS->(!eof())
				If !Empty(REMIS->D2_REMITO)
					cRemis += REMIS->D2_REMITO + ", "
					nQtdRem++
				EndIf
				REMIS->(Dbskip())
			EndDo			
			REMIS->(Dbclosearea())

		EndIf        
	
		If nQtdRem == 1
		
			cRemision := "Rem " + Substr(cRemis,1,Len(cRemis)-2)	
			
		ElseIf nQtdRem > 1
		
			cRemision := "Rem " + Substr(cRemis,1,Len(cRemis)-2)	
			
		EndIf
    // FPB Si el cliente de entrega sigue en blanco se asigana el mismo cliente de entrega
        cCotiza:= ""  
        // TODO JARS
	if empty(cCliEnt)
		if  lFactura // Factura
			cCliEnt		:= SF2->F2_CLIENTE
			cLojEnt		:= SF2->F2_LOJA
		else // Nota de Credito
			cCliEnt		:= SF1->F1_FORNECE
			cLojEnt		:= SF1->F1_LOJA
		endif
	endif

	IF EMPTY(cObservaciones)
		//Pendiente Observaciones del pedido de venta
		//cObservaciones := Alltrim(SC5->C5_OBS)
	ENDIF

	if  lFactura // Factura
		cNumClie		:= ALLTRIM(SF2->F2_CLIENTE)
    Else
		cNumClie		:= ALLTRIM(SF1->F1_FORNECE)
    
    Endif
	dbSelectArea("SA1")
	dbSetOrder(1)
                             
	IF lFactura 
	  	if dbSeek(xFilial("SA1") + SF2->F2_CLIENTE+ SF2->F2_LOJA)
			cEmaiC		:= ALLTRIM(SA1->A1_EMAIL)
			cTelC		:= ALLTRIM(SA1->A1_TEL)
		endif
	Else	
		if	DbSeek(xFilial("SA1") + SF1->F1_FORNECE + SF1->F1_LOJA)
			cEmaiC		:= ALLTRIM(SA1->A1_EMAIL)
			cTelC		:= ALLTRIM(SA1->A1_TEL)
		 endif                      
	Endif		                                                      
		cCliCalle	:= Alltrim(UPPER(SA1->A1_END))
		cCliNumExt	:= ALLTRIM(UPPER(SA1->A1_NR_END)) 	//AllTrim(oXML:_cfdi_COMPROBANTE:_cfdi_RECEPTOR:_cfdi_DOMICILIO:_NOEXTERIOR:TEXT)
		cCliNumInt	:= ALLTRIM(UPPER(SA1->A1_NROINT))
		cCliMun		:= AllTrim(UPPER(SA1->A1_MUN))
		cCliCol		:= AllTrim(UPPER(SA1->A1_BAIRRO))
		cCliEst		:= Alltrim(UPPER(SA1->A1_EST))
		cCliPais	:= Alltrim(Posicione("SYA",1,xFilial("SYA") + Posicione("SA1",1,xFilial("SA1") + cCliEnt + cLojEnt, "A1_PAIS"), "YA_DESCR"))
		cCliCp		:= AllTrim(SA1->A1_CEP) 
		cCliIdFis	:= AllTrim(SA1->A1_NIF) 
		
	

	if (Len(cCliRfc) == 12)
		cCliRfc := substr(cCliRfc,1,3)+"-"+substr(cCliRfc,4,6)+"-"+substr(cCliRfc,10,3)
	else
		cCliRfc := substr(cCliRfc,1,4)+"-"+substr(cCliRfc,5,6)+"-"+substr(cCliRfc,11,3)
	endif

	// Imprimir Logo de cliente
	oPrint:SayBitmap(100,050,cLogoCli,500,200) // y,x,archivo,ancho,alto

	// Direccion de emisor
	oPrint:Say(400,050,cEmisor			,oArial16N,,,,2)		//TODO QUITAR S.A. DE C.V.
	oPrint:Say(500,050,cRfc				,oArial12N,,,,2)   
	oPrint:Say(550,050,cCalle			,oArial10,,,,2)    
	oPrint:Say(600,050,cColonia 		,oArial10,,,,2)
	oPrint:Say(650,050,cMunic + ", " + cEstado + ", " + cPais		,oArial10,,,,2)
	oPrint:Say(700,050,"C.P. " + cCP 				,oArial10,,,,2)
 
	// Numero de Página
	oPrint:Say(070,	2100,	"Página:  " + STRZERO(nPagNum,2),	oArial10N,,,,2)
	// Layout del encabezado
    nLinBx		:= 90
    nDifLBox	:= 4
    nDifLTxt	:= 30

	// Inicio: Lugar de Expedicion y Numero de Certificado
	fGnBoxHead(nLinBx,	700, 380, "Lugar de Expedición")
	fGnBoxHead(nLinBx,	1085, 380, "Número de Certificado CSD")

	fGnBoxHead(nLinBx,		1475, 765, "")
	fGnBoxHead(nLinBx+40,	1475, 765, "")

	nLinBx	+=	45
 	fGnBoxDet(nLinBx,	700, 380, 45)
 	fGnBoxDet(nLinBx,	1085, 380, 45)

	fGnBoxDet(nLinBx+49,	1475, 765, 90)

//	oPrint:Say(nLinBx + nDifLTxt,	710,	cEstado,	oArial09N,,,,2)   			//Lugar    xx cCodpos 
	oPrint:Say(nLinBx + nDifLTxt,	710,	cCodpos+ " "+cEstado,	oArial09N,,,,2)   			//Lugar    xx cCodpos 
	
	oPrint:Say(nLinBx + nDifLTxt,	1095,	cCert,		oArial09N,,,,2)   			//Certificado
	// Fin: Lugar de Expedicion y Numero de Certificado

	// Inicio: Indicacion de Factura / NCC / NDC
	if  lFactura 					// factura
		oPrint:Say(nLinBx+22,	1490,	"             F A C T U R A ", oArial20N,,CLR_WHITE,,2) //se dejo unicamente invoice a petición de intelbras
	else 				// CREDITO
		oPrint:Say(nLinBx+22, 	1490,	"  N O T A   D E   C R É D I T O", oArial20N,,CLR_WHITE,,2)
	endif

	oPrint:Say(nLinBx + 110,	1510,	cSerie,		oArial18N,,RGB(255,000,000),,2)
	oPrint:Say(nLinBx + 110,	1700,	cFolio,		oArial18N,,RGB(255,000,000),,2)
	// Fin: Indicacion de Factura / NCC / NDC

	// Inicio: FECHA de Expedicion y Año de Aprobacion
	nLinBx	+=	45
	fGnBoxHead(nLinBx + nDifLBox,	700, 380, "Fecha de Expedición")
	fGnBoxHead(nLinBx + nDifLBox,	1085, 380, "Fecha Certificación")

	nLinBx	+=	45
 	fGnBoxDet(nLinBx + nDifLBox,	700, 380, 45)
 	fGnBoxDet(nLinBx + nDifLBox,	1085, 380, 45)

	oPrint:Say(nLinBx + nDifLBox + nDifLTxt,	710,	cFECHAFac,	oArial09N,,,,2)   			//FECHA de Expedicion
	IF !empty(cTimbre)
     oPrint:Say(nLinBx + nDifLBox + nDifLTxt,	1095, cFechaTimbre,	oArial09N,,,,2)   			//Año
    ENDIF
	// Fin: FECHA de Expedicion y Año de Aprobacion

	// Inicio: Conducto, Numero de Aprobacion, Pedido y Orden de Compra Cliente
	nLinBx	+=	45
	fGnBoxHead(nLinBx + nDifLBox,	700, 380, "Forma Pago")
	fGnBoxHead(nLinBx + nDifLBox,	1085, 380, "Número Certificado SAT")
	fGnBoxHead(nLinBx + nDifLBox,	1475, 765, "Folio Fiscal")          
	
	nLinBx	+=	45
 	fGnBoxDet(nLinBx + nDifLBox,	700, 380, 45)
 	fGnBoxDet(nLinBx + nDifLBox,	1085, 380, 45)

 	fGnBoxDet(nLinBx + nDifLBox,	1475, 765, 45)
 	//fGnBoxDet(nLinBx + nDifLBox,	1860, 380, 45)

	oPrint:Say(nLinBx + nDifLBox + nDifLTxt,	710 ,AllTrim(cForPag),	oArial09N,,,,2)		//Forma de Pago
	if !empty(cTimbre)
     	oPrint:Say(nLinBx + nDifLBox + nDifLTxt,	1095,	cCertSAT,	oArial09N,,,,2)  	//cCertSAT
     	oPrint:Say(nLinBx + nDifLBox + nDifLTxt,	1485,	cFolioFis,	oArial09N,,,,2)  	//cCertSAT
    endif
    
    
	// Fin: Conducto, Numero de Aprobacion, Pedido y Orden de Compra Cliente

	// Inicio: Condiciones de Pago y Representante
	/*
	nLinBx	+=	45
	fGnBoxHead(nLinBx + nDifLBox,	0700, 765, "Metodo de Pago")
	fGnBoxHead(nLinBx + nDifLBox,	1475, 380, "Pedido")
	//fGnBoxHead(nLinBx + nDifLBox,	1860, 380, "Vendedor")
	fGnBoxHead(nLinBx + nDifLBox,	1860, 380, "O.Comp.Cli.")

	nLinBx	+=	45
	fGnBoxDet(nLinBx + nDifLBox,	700, 765, 45)
	oPrint:Say(nLinBx + nDifLBox + nDifLTxt,0710,AllTrim(alltrim(oXML:_cfdi_COMPROBANTE:_metodoDePago:TEXT)),oArial09N)			//forma de pago

 	fGnBoxDet(nLinBx + nDifLBox,	1475, 380, 45)
 	fGnBoxDet(nLinBx + nDifLBox,	1860, 380, 45)
	//If lFactura
	oPrint:Say(nLinBx + nDifLBox + nDifLTxt,1485,cPedido,oArial09N)	// Pedido
	//oPrint:Say(nLinBx + nDifLBox + nDifLTxt,1870,cVendedor,oArial09N) 	// Vendedor 
	oPrint:Say(nLinBx + nDifLBox + nDifLTxt,1870,cOCCliente,oArial09N) 	// Vendedor 
	//EndIf
    */
	// Inicio: Facturar a y Embarcar a
	nLinBx	+=	45                                         

	IF lFactura	
		fGnBoxHead(nLinBx + nDifLBox,	700, 765, "Facturar a")
	Else
		fGnBoxHead(nLinBx + nDifLBox,	700, 765, "Nota de Crédito a")
	Endif
	//fGnBoxHead(nLinBx + nDifLBox,	1475, 765, "Embarcar a") 
	fGnBoxHead(nLinBx + nDifLBox,	1475, 380, "Tipo de Comprobante")
	fGnBoxHead(nLinBx + nDifLBox,	1860, 380, "Tipo de Relacion")
    
 	nLinBx	+=	45
	fGnBoxDet(nLinBx + nDifLBox,	700, 765, 175)
	
    // FPB IMPRIME LA DIRECCION DEL CLIENTE CON FORMATO DIFERENTE
	oPrint:Say(nLinBx + nDifLBox + 30,	710,	SUBSTR(cNumClie+":"+cCliNom,1,50),oArial09N) 
//	oPrint:Say(nLinBx + nDifLBox + 60,	710,	SUBSTR(cCliNom,51,60),			   												oArial09N)
	oPrint:Say(nLinBx + nDifLBox + 60,	710,	"RFC: " + cCliRfc + "     TEL: " + cTelC,	    								oArial09N)
	oPrint:Say(nLinBx + nDifLBox + 90,	710,	"DIRECCION: " + cCliCalle + " " + cCliNumExt + " " + cCliNumInt,				oArial09N)
//	oPrint:Say(nLinBx + nDifLBox + 150,	710,	AllTrim(oXML:_cfdi_COMPROBANTE:_cfdi_RECEPTOR:_cfdi_DOMICILIO:_COLONIA:TEXT) + ", " + cCliMun,	oArial09N)
	oPrint:Say(nLinBx + nDifLBox + 120,	710,	cCliCol+","+cCliMun,	oArial09N)
	OPrint:Say(nLinBx + nDifLBox + 150,	710,	cCliEst + " C.P. " + cCliCp +  " " + cCliPais, 									oArial09N)      
	IF !Empty(cCliIdFis)
		oPrint:Say(nLinBx + nDifLBox +180,	710,	"ID FISCAL: " + cCliIdFis,	    								oArial09N)
	Endif
	//Tipo de Comprobante
 	fGnBoxDet(nLinBx + nDifLBox,	1475, 380, 45)
  	oPrint:Say(nLinBx + nDifLBox + nDifLTxt,	1485,	cTipoCompr+"-"+U_DESCRIP4("S011",cTipoCompr,1,10),	oArial09N,,,,2)  

	//Tipo de Relacion
 	fGnBoxDet(nLinBx + nDifLBox,	1860, 380, 45)		 
  	oPrint:Say(nLinBx + nDifLBox + nDifLTxt,	1870,	cTipoRel+"-"+U_DESCRIP4("S012",cTipoRel,2,30),	oArial09N,,,,2)  
  		  
	//de aqui
	nLinBx	+=	45
	fGnBoxHead(nLinBx + nDifLBox,	1475, 765, "Uso CFDI")	

	nLinBx	+=	45	
	//Uso CFDI
 	fGnBoxDet(nLinBx + nDifLBox,	1475, 765, 45)
  	oPrint:Say(nLinBx + nDifLBox + nDifLTxt,	1485,	cUsoCFDI+"-"+U_DESCRIP4("S013",cUsoCFDI,3,40),	oArial09N,,,,2)  
 
 	//CFDI Relacionados... cuando es 1 el relacionado
	nLinBx	+=	45
	fGnBoxHead(nLinBx + nDifLBox,	1475, 765, "CFDI Relacionados")	
	nLinBx	+=	45	
	fGnBoxDet(nLinBx + nDifLBox,	1475, 765, 90)
	nLinDes:= 0	
	If Len(AllTrim(cCFDIRel)) > 40
		nLines := MLCOUNT(cCFDIRel, 36, 0, .T.)
		FOR nCurrentLine := 1 TO nLines
			oPrint:Say(nLinBx + nDifLBox + (nLinDes * 35),	1485, MEMOLINE(cCFDIRel,36,nCurrentLine,3,.T.) ,	oArial09N,,,,2)  
			nLinDes ++
		NEXT
	Else	
			oPrint:Say(nLinBx + nDifLBox,	1485, cCFDIRel ,	oArial09N,,,,2)  
	Endif	  		
	//hasta Aqui

	//fGnBoxDet(nLinBx + nDifLBox,	1475, 765, 180)

	If AllTrim(oXML:_cfdi_COMPROBANTE:_cfdi_RECEPTOR:_NOMBRE:TEXT) == "" .or. ;
	   AllTrim(oXML:_cfdi_COMPROBANTE:_cfdi_RECEPTOR:_RFC:TEXT) == "" 
		
		MsgInfo("Hay campos vacios en el catalogo de clientes, favor de llenarlos.")		
		Return
	EndIf

	// FPB VERIFICA SI EL NUMERO INTERIOR ESTA VACIO
	/* JARS
	IF VALTYPE(XmlChildex(oXML:_cfdi_COMPROBANTE:_cfdi_RECEPTOR:_cfdi_DOMICILIO,"_NOINTERIOR)")) = "O"
		cCliNumInt	:= AllTrim(oXML:_cfdi_COMPROBANTE:_cfdi_RECEPTOR:_cfdi_DOMICILIO:_NOINTERIOR:TEXT)
	ELSE
		cCliNumInt	:= ""
	ENDIF  
	*/
		

 
	// Inicio: Facturar a y Embarcar                     

	cEntNombr	:= Alltrim(Posicione("SA1",1,xFilial("SA1") + cCliEnt + cLojEnt, "A1_NOME"))
	cEntRFC		:= Alltrim(Posicione("SA1",1,xFilial("SA1") + cCliEnt + cLojEnt, "A1_CGC"))
	cEntCalle	:= Alltrim(Posicione("SA1",1,xFilial("SA1") + cCliEnt + cLojEnt, "A1_END"))
	cEntNumExt	:= Alltrim(Posicione("SA1",1,xFilial("SA1") + cCliEnt + cLojEnt, "A1_NR_END"))
	cEntNumInt	:= Alltrim(Posicione("SA1",1,xFilial("SA1") + cCliEnt + cLojEnt, "A1_NROINT"))
	centMun		:= Alltrim(Posicione("SA1",1,xFilial("SA1") + cCliEnt + cLojEnt, "A1_BAIRRO")) + ", " + Alltrim(Posicione("SA1",1,xFilial("SA1") + cCliEnt + cLojEnt, "A1_MUN"))
	cEntEst		:= Alltrim(POSICIONE("SX5", 1, XFILIAL("SX5") + '12' + Posicione("SA1",1,xFilial("SA1") + cCliEnt + cLojEnt, "A1_EST"), 'SX5->X5_DESCSPA'))
	centPais	:= Alltrim(Posicione("SYA",1,xFilial("SYA") + Posicione("SA1",1,xFilial("SA1") + cCliEnt + cLojEnt, "A1_PAIS"), "YA_DESCR"))
	cEntCp		:= Alltrim(Posicione("SA1",1,xFilial("SA1") + cCliEnt + cLojEnt, "A1_CEP"))
              

	//oPrint:Say(nLinBx + nDifLBox + 30,1485,cEntNombr,oArial09N)	//Cliente de entrega
	//oPrint:Say(nLinBx + nDifLBox + 90,1485,cEntRFC,oArial09N) //RFC Cliente
	//oPrint:Say(nLinBx + nDifLBox + 120,1485,	"DIRECCION: " + cEntCalle + " " + cEntNumExt + " " + cEntNumInt,				oArial09N)
	//oPrint:Say(nLinBx + nDifLBox + 150,1485,	cEntMun,	oArial09N)
	//OPrint:Say(nLinBx + nDifLBox + 180,1485,	cEntEst + " C.P. " + cEntCp +  " " + cEntPais, 									oArial09N)
	// Fin: Facturar a y Embarcar

	// Inicio: Metodo de Pago, Cuenta de Pago, Monedo y Tipo de Cambio
	cMetodoP	:= AllTrim(oXML:_cfdi_COMPROBANTE:_METODOPAGO:TEXT)
	fGnBoxHead(nLinBx + nDifLBox,	700, 765, "Metodo de Pago")
 	fGnBoxDet(nLinBx+45 + nDifLBox,	700, 765, 45)
	oPrint:Say(nLinBx+45 + nDifLBox + nDifLTxt,0710,AllTrim(cMetodoP)+"-"+U_DESCRIP4("S007",cMetodoP,3,40),oArial09N)

	nLinBx	+=	55

	nLinBx	+=	45
    // Fin: Metodo de Pago, Cuenta de Pago, Monedo y Tipo de Cambio
	if  lFactura	
		fGnBoxHead(nLinBx + nDifLBox,	700 , 380, "Remision")
		fGnBoxHead(nLinBx + nDifLBox,	1085, 380, "No.Pedido /Pedido Cte")
	 	fGnBoxDet(nLinBx+45 + nDifLBox,	700, 380, 45)
	 	fGnBoxDet(nLinBx+45 + nDifLBox,	1085, 380, 45)
	Endif
	fGnBoxHead(nLinBx + nDifLBox,	1475, 380, "Tipo de Cambio / Moneda")
	fGnBoxHead(nLinBx + nDifLBox,	1860, 380, "INCOTERM")

 	fGnBoxDet(nLinBx+45 + nDifLBox,	1475, 380, 45)
 	fGnBoxDet(nLinBx+45 + nDifLBox,	1860, 380, 45)
	
	oPrint:Say(nLinBx+45 + nDifLBox + nDifLTxt,1485,AllTrim(cTipoCambio)+"    /   "+AllTrim(oXML:_cfdi_COMPROBANTE:_MONEDA:TEXT),oArial09N)
	IF ValType(XMLChildEx(oXML:_CFDI_COMPROBANTE:_CFDI_COMPLEMENTO,"_CCE11_COMERCIOEXTERIOR")) == "O"
       cIncoterm	   	:= AllTrim(oXML:_cfdi_comprobante:_cfdi_Complemento:_cce11_ComercioExterior:_INCOTERM:TEXT)
   		oPrint:Say(nLinBx+45 + nDifLBox + nDifLTxt,1870,AllTrim(cIncoterm) ,oArial09N) //AllTrim(oXML:_cfdi_COMPROBANTE:_MONEDA:TEXT)
	Endif
	cCtaPago	:= "" //AllTrim(oXML:_cfdi_COMPROBANTE:_NUMCTAPAGO:TEXT)
	if  lFactura	
		oPrint:Say(nLinBx+45 + nDifLBox + nDifLTxt,710,AllTrim(cRemision),oArial09N)
		oPrint:Say(nLinBx+45 + nDifLBox + nDifLTxt,1100,AllTrim(cPedido)+"/"+AllTrim(cOCCliente),oArial09N)
	Endif	
Return ()

/* 	--------------------------------------------------------------------------
		Función: 	PrtFooter
					Imprime la sección al pie del documento.
		Parámetros:
			oXML: 	Objeto con el contenido del archivo XML leído para el
					documento.
	-------------------------------------------------------------------------- */
Static Function PrtFooter(oXML)
	LOCAL cSerie 	:= OemToAnsi(oXML:_cfdi_COMPROBANTE:_SERIE:TEXT)
	LOCAL cFolio 	:= OemToAnsi(oXML:_cfdi_COMPROBANTE:_FOLIO:TEXT)
	Local cDescTot	:= 0 //TODO JARS  HABILIT DSCTO VAL(OemToAnsi(oXML:_cfdi_COMPROBANTE:_DESCUENTO:TEXT))
	Local ntJmp		:= 2
	Local cImmex	:= ""
	Local cRFCP		:= OemToAnsi(oXML:_cfdi_COMPROBANTE:_cfdi_RECEPTOR:_RFC:TEXT)
	Local nSaltoRdp	:= 0
	LOCAL cCadOrig 	:= ""
	Local i			:= 0              

	dbSelectArea("SA1")
	dbSetOrder(1)

  	if dbSeek(xFilial("SA1") + SF2->F2_CLIENTE+ SF2->F2_LOJA)
		cNomClient		:= ALLTRIM(SA1->A1_NOME)
		cImmex			:= "" //ALLTRIM(SA1->A1_IMMEX)
	endif

	If nPagNum	>= 1
		nFotY	:= 	1900
	EndIf
	// Importe y totales
	cExtenso:= BtCan(oXML:_cfdi_COMPROBANTE:_TOTAL:TEXT, cFolio, cSerie )   					// Obtener la cantidad en letra
	cTotal  := Val(oXML:_cfdi_COMPROBANTE:_SUBTOTAL:TEXT)- cDescItems
	cDescTot:= cDescTot-cDescItems

	nFoty += jmp

	fGnBoxHead(nFotY,	050, 1420, "OBSERVACIONES")
 	fGnBoxDet(nFotY+45,	050, 1420, 180)

	//InfObsFT(cNumFac, cSerie)

	If (cObservaciones) <> " "
		fObs:=cObservaciones
		If Len(AllTrim(fObs)) >= 85     //Tamaño de la cantidad en letra
			nLoop	:= 1
			For i := 1 To Len(AllTrim(fObs)) Step 85
				oPrint:Say(nFotY + 75 +(nLoop*30),060,SUBS(fObs,i,85),oCouNew11)	//Observacion oCouNew09N
				nLoop++
			Next i
		Else
			oPrint:Say(nFotY + 75,060,cObservaciones,oCouNew11)	//Observacion
		EndIf
	EndIF

	fGnBoxHead(nFotY + nSaltoRdp,	1475, 300, "Sub-Total")
	fGnBoxDet(nFotY + nSaltoRdp,	1780, 460, 45)
	oPrint:Say(nFotY + nSaltoRdp + 30,	2000,Transform(Val(oXML:_cfdi_COMPROBANTE:_SUBTOTAL:TEXT)," 999,999,999.99"),oCouNew10N)	//Subtotal

	nSaltoRdp	+=	45

	If lFactura

		IF XMLChildEx(oXML:_cfdi_COMPROBANTE,"_DESCUENTO") <> NIL
			nDesPrd	:= Val(oXML:_cfdi_COMPROBANTE:_DESCUENTO:TEXT)
		Else
			nDesPrd	:= 0
		ENDIF
		if (nDesPrd > 0)
			fGnBoxHead(nFotY + nSaltoRdp,	1475, 300, "Descuento")
	 		fGnBoxDet(nFotY + nSaltoRdp,	1780, 460, 45)
			oPrint:Say(nFotY + nSaltoRdp + 30,2000,Transform(Val(oXML:_cfdi_COMPROBANTE:_DESCUENTO:TEXT)," 999,999,999.99"),oCouNew10N)  	//descuento  0 if empresa == 2

			nSaltoRdp	+=	45
		endif
	EndIf

//	IF (cRFCP<>"XAXX010101000")
		fGnBoxHead(nFotY + nSaltoRdp,	1475, 300, "I.V.A.")
 		fGnBoxDet(nFotY + nSaltoRdp,	1780, 460, 45) 
 		IF VALTYPE(XMLChildEx(oXML:_CFDI_COMPROBANTE,"_CFDI_IMPUESTOS")) == "O"          
// 			IF nTotTras > 0 
 			IF XMLChildEx(oXML:_cfdi_COMPROBANTE:_CFDI_IMPUESTOS,"_TOTALIMPUESTOSTRASLADADOS") <> NIL
				oPrint:Say(nFotY + nSaltoRdp + 30,	1820,	+Substring(AllTrim(oXML:_cfdi_COMPROBANTE:_cfdi_IMPUESTOS:_cfdi_TRASLADOS:_cfdi_TRASLADO:_TASAOCUOTA:TEXT),3,2)+"%" ,oCouNew10N)
				oPrint:Say(nFotY + nSaltoRdp + 30,	2000,	Transform( Val(oXML:_cfdi_COMPROBANTE:_cfdi_IMPUESTOS:_TOTALIMPUESTOSTRASLADADOS:TEXT)," 999,999,999.99"), oCouNew10N)  			
			Else
				oPrint:Say(nFotY + nSaltoRdp + 30,	2000,	Transform( Val("0.00")," 999,999,999.99"), oCouNew10N)	
			Endif           
		Else		//No hay nodo de Impuestos
				oPrint:Say(nFotY + nSaltoRdp + 30,	2000,	Transform( Val("0.00")," 999,999,999.99"), oCouNew10N)
		Endif
			nSaltoRdp	+=	45
//	EndIf

	if ( cRetItems > 0	)
		fGnBoxHead(nFotY + nSaltoRdp,	1475, 300, "Retencion")
 		fGnBoxDet(nFotY + nSaltoRdp,	1780, 460, 45)
 		
		if (cRetItems > 0)
//		  	oPrint:Say(nFotY + nSaltoRdp + 30,	1820,	(oXML:_cfdi_COMPROBANTE:_cfdi_IMPUESTOS:_cfdi_RETENCIONES:_cfdi_RETENCION:_IMPUESTO:TEXT),oCouNew10N)
			oPrint:Say(nFotY + nSaltoRdp + 30,	2000,	Transform(Val(oXML:_cfdi_COMPROBANTE:_cfdi_IMPUESTOS:_cfdi_RETENCIONES:_TOTALIMPUESTOSRETENIDOS:_IMPORTE:TEXT)," 999,999,999.99"),oCouNew10N)
			ntJmp++
		endif
		nSaltoRdp	+=	45
	endif

	fGnBoxHead(nFotY + nSaltoRdp,	1475, 300, "Total")
	fGnBoxDet(nFotY + nSaltoRdp,	1780, 460, 45)
	oPrint:Say(nFotY + nSaltoRdp + 30,	2000,Transform(Val(oXML:_cfdi_COMPROBANTE:_TOTAL:TEXT)," 999,999,999.99"),oCouNew10N)				//Total

	nFotY	+=	225 + 10

	fGnBoxHead(nFotY,	050, 2190, "Cantidad con Letra")
	nFotY	+=	45
 	fGnBoxDet(nFotY,	050, 2190, 45)
 	oPrint:Say(nFotY + 30,		060, cExtenso,oCouNew11N)

	nFotY	+=	45 + 10
   	fGnBoxHead(nFotY,	0350, 1890, "Sello Digital del CFDI")
	nFotY	+=	45

 	fGnBoxDet(nFotY,	0350, 1890, 100)
 	nRenglon	:= 30
 	nLoop		:= 0
 	For i := 1 To Len(oXML:_cfdi_COMPROBANTE:_SELLO:TEXT) Step 150
		oPrint:Say(nFotY + nRenglon, 360,SubStr(oXML:_cfdi_COMPROBANTE:_SELLO:TEXT,i,150),oCouNew09N)
		nRenglon += 30
		nLoop++
		If nLoop == 9999
			Exit
		EndIf
	Next i
	nFotY	+=	45 + 65
   	fGnBoxHead(nFotY,  350, 1890, "Sello del SAT")
	nFotY	+=	45
 	fGnBoxDet(nFotY,	350, 1890, 100)
	nRenglon	:= 30
 	nLoop		:= 0
 	
 	IF XMLChildEx(oXML:_CFDI_COMPROBANTE,"_CFDI_COMPLEMENTO") <> NIL
			 
 		For i := 1 To Len(oXML:_cfdi_COMPROBANTE:_cfdi_Complemento:_tfd_TimbreFiscalDigital:_selloSAT:TEXT) Step 150
			oPrint:Say(nFotY + nRenglon, 360,SubStr(oXML:_cfdi_COMPROBANTE:_cfdi_Complemento:_tfd_TimbreFiscalDigital:_selloSAT:TEXT,i,150),oCouNew09N)
			nRenglon += 30
			nLoop++
			If nLoop == 9999
				Exit
			EndIf
		Next i
	  	
		BuscaCadOri(@cCadOrig,oXML)
  	
  	Else
 		MsgAlert("No se ha Generado el Timbrado del Documento!!")                                                               
	Endif
  	
	nFotY	+=	100 + 10

	fGnBoxHead(nFotY,	350, 1890, "CADENA ORIGINAL DEL COMPLEMENTO DE CERTIFICACIÓN DIGITAL DEL SAT")
	nFotY	+=	45
 	fGnBoxDet(nFotY,	350, 1890, 100)

//	nFotY	+= 45
	nFotY2	:=0
	lBanhoja:=.F.
	nRenglon	:= 30
	//IF !empty(cTimbre)
	 IF XMLChildEx(oXML:_CFDI_COMPROBANTE,"_CFDI_COMPLEMENTO") <> NIL
		For i := 1 To Len(cCadOrig) Step 150 //210
			If (nFotY + nRenglon) <= 3180
				oPrint:Say(nFotY + nRenglon, 360,SubStr(cCadOrig,i,150),oCouNew09N)
				nRenglon +=25
				nLoop++
				nFotY2	:=nFotY+nRenglon+20
			Else

				SetNewPage(oXML)
//				nFotY := 780
				oPrint:Say(nFotY + nRenglon,360,SubStr(cCadOrig,i,150),oCouNew09N)
				nRenglon +=25
				nLoop++
				nFotY2	:=nFotY+nRenglon+20
			EndIf
			If nLoop == 9999
				Exit
			EndIf
		Next  	i
	else
		nFotY2	:=2690
	   	nFotY	:=2650
	endif
	/* Impresion del Código de Barras */
	//IF !empty(cTimbre)
	IF XMLChildEx(oXML:_CFDI_COMPROBANTE,"_CFDI_COMPLEMENTO") <> NIL
		cUUID:="?re="+Alltrim(oXML:_cfdi_COMPROBANTE:_cfdi_EMISOR:_RFC:TEXT)
		cUUID+="&rr="+Alltrim(oXML:_cfdi_COMPROBANTE:_cfdi_RECEPTOR:_RFC:TEXT)
		cUUID+="&tt="+Alltrim(oXML:_cfdi_COMPROBANTE:_TOTAL:TEXT)
		cUUID+="0000&id="+Alltrim(oXML:_cfdi_COMPROBANTE:_cfdi_Complemento:_tfd_TimbreFiscalDigital:_UUID:TEXT)
		If lFactura
			cArchivo := Lower(AllTrim(SF2->F2_ESPECIE)) + '_' + Lower(AllTrim(SF2->F2_SERIE)) + '_' + Lower(AllTrim(SF2->F2_DOC))
		else
		    cArchivo := Lower(AllTrim(SF1->F1_ESPECIE)) + '_' + Lower(AllTrim(SF1->F1_SERIE)) + '_' + Lower(AllTrim(SF1->F1_DOC))
		endif
		CodBarQR( cUUID , cArchivo )
		//oPrint:SayBitMap( nFotY+50,1750, GetClientDir() + cFilQr + ".bmp", 372, 380)
		oPrint:SayBitMap( 2280,0050, GetClientDir() + cArchivo+".bmp", 290, 290)
	endif
	nFoty +=30
	nFotY2-=10  //20

	nFoty += jmp - 10

	oPrint:SayBitMap( 2745,0350, "STECK_TYC.jpg", 1890, 170)
	nFotY2 += 180

	oPrint:Sayalign(	nFotY2+30,	500,	"ESTE DOCUMENTO ES UNA REPRESENTACION IMPRESA DE UN CFDI.", oArial10,1200,60,,2,0)
	nFoty += jmp - 10
	If CTOD(SubStr(oXML:_cfdi_COMPROBANTE:_FECHA:TEXT,9,2)+"/"+SubStr(oXML:_cfdi_COMPROBANTE:_FECHA:TEXT,6,2)+"/"+SubStr(oXML:_cfdi_COMPROBANTE:_FECHA:TEXT,1,4)) > CTOD("30/06/2012")
		oPrint:Sayalign(	nFotY2+30+30,	500,"REGIMEN FISCAL:  " + oXML:_cfdi_COMPROBANTE:_cfdi_EMISOR:_REGIMENFISCAL:TEXT, oArial10,1200,60,,2,0)
   	EndIf
	oPrint:EndPage()
//	fWrite(_hDL,"Fin de Footer:"+time()+cEOL)                 

Return ()
/* 	--------------------------------------------------------------------------
		Función: 	ImpDet
					Imprime la sección de detalle del documento.
		Parámetros:
			oXML: 	Objeto con el contenido del archivo XML leído para el
					documento.
		Retorno:    Número de línea de la página actual en donde termina de
					imprimir el detalle.
	-------------------------------------------------------------------------- */
Static Function ImpDet(oXML)

Local nTotItem 	:= GetMv("MV_NUMITEM",,50)
Local nCurLine	:= nDetY
LOCAL cObs      	:= ""
LOCAL cSec      	:= 0
LOCAL cProd     	:= ""
local cQueryObs	:= ""
local cSQLObs    	:= "TRX"
LOCAL cSecNumPed	:= ""
Local cObsItemFac	:= ""
Local cSerieLocal	:= OemToAnsi(oXML:_cfdi_COMPROBANTE:_SERIE:TEXT)
Local cFolioLocal	:= OemToAnsi(oXML:_cfdi_COMPROBANTE:_FOLIO:TEXT)
LOCAL cSecItFt   	:= 0
Local rt			:= 0
Local O			:= 0
Local i			:= 0      
Local cPedido	:= ""      


nFall		:= 2

public cPedimAc[99]

//fWrite(_hDL,"Inicio de Det:"+time()+cEOL)                 
/*
fGnBoxCe(nDetY + nDifLBox,	50, 200, "       CANTIDAD")
fGnBoxCe(nDetY + nDifLBox,	255, 350, "  CODIGO/FRACC ARANC.")
fGnBoxCe(nDetY + nDifLBox,	610, 710, "                                   DESCRIPCIÓN")
fGnBoxCe(nDetY + nDifLBox,	1322, 128, "  UM /UMT")
fGnBoxCe(nDetY + nDifLBox,	1455, 220, "       PRECIO U")
fGnBoxCe(nDetY + nDifLBox,	1680, 280, "       IMPORTE")
fGnBoxCe(nDetY + nDifLBox,	1962, 280, "       DSCTO")
*/
	fGnBoxCe(nDetY + nDifLBox,	50, 200, "       CANTIDAD")
	fGnBoxCe(nDetY + nDifLBox,	255, 150, "       UM")
	fGnBoxCe(nDetY + nDifLBox,	410, 450, "     CODIGO         /   COD SAT.")
	fGnBoxCe(nDetY + nDifLBox,	865, 710, "                                   DESCRIPCIÓN")
	fGnBoxCe(nDetY + nDifLBox,	1580, 330, "               PRECIO U.")
	fGnBoxCe(nDetY + nDifLBox,	1915, 330, "               IMPORTE")


nDetY	+= 80

nFall := 2

If  lFactura 					// Tipo Doc: factura

	nLinDes	:= 0

	if ( ValType(oXML:_cfdi_COMPROBANTE:_cfdi_CONCEPTOS:_cfdi_CONCEPTO) <> "O" )		// Más de una partida en factura

		for i := 1 to Len(oXML:_cfdi_COMPROBANTE:_cfdi_CONCEPTOS:_cfdi_CONCEPTO)

			nLinDes	:= 0

			if ( i > nTotItem )
				Exit
			endif

			if ( nFall > 31 ) 	// 31 items por página como máximo.

				If lFactura
					fGnBoxHead(nDetY + 100,	50, 2190, "LA IMPRESION DE ESTA FACTURA CONTINUA EN LA PÁGINA " + strzero(nPagNum+1,2))
                Else
                	fGnBoxHead(nDetY + 100,	50, 2190, "LA IMPRESION DE ESTA NOTA DE CRÉDITO CONTINUA EN LA PÁGINA " + strzero(nPagNum+1,2))
                EndIf

				SetNewPage(oXML)

				nDetY	:= 780

				fGnBoxCe(nDetY + nDifLBox,	50, 200, "       CANTIDAD")
				fGnBoxCe(nDetY + nDifLBox,	255, 150, "       UM")
				fGnBoxCe(nDetY + nDifLBox,	410, 450, "     CODIGO         /   COD SAT.")
				fGnBoxCe(nDetY + nDifLBox,	865, 710, "                                   DESCRIPCIÓN")
				fGnBoxCe(nDetY + nDifLBox,	1580, 330, "               PRECIO U.")
				fGnBoxCe(nDetY + nDifLBox,	1915, 330, "               IMPORTE")

				/*
				fGnBoxCe(nDetY + nDifLBox,	1525, 150, "       UM")
				fGnBoxCe(nDetY + nDifLBox,	1680, 280, "               PRECIO U.")
				fGnBoxCe(nDetY + nDifLBox,	1962, 280, "               IMPORTE")
                */

				nDetY	+= 80

				nFall := 2
				nLinDes	:= 0
				nCurLine := nDetY
			endif

			// FPB EXTRAE EL CODIGO DE PRODUCTO Y LA SECUENCIA EN LA FACTURA
			cSec 	:= left(oXML:_cfdi_COMPROBANTE:_cfdi_CONCEPTOS:_cfdi_CONCEPTO[i]:_noIdentificacion:TEXT,2)
			cProd 	:= right(oXML:_cfdi_COMPROBANTE:_cfdi_CONCEPTOS:_cfdi_CONCEPTO[i]:_noIdentificacion:TEXT,len(oXML:_cfdi_COMPROBANTE:_cfdi_CONCEPTOS:_cfdi_CONCEPTO[i]:_noIdentificacion:TEXT) - 2)
                 cCodSat	:= oXML:_CFDI_COMPROBANTE:_CFDI_CONCEPTOS:_CFDI_CONCEPTO[i]:_CLAVEPRODSERV:TEXT            
           
			cFraccAran 	:= ""
			cUMT 		:= ""
			//fracc Arancelaria
	     	IF XMLChildEx(oXML:_CFDI_COMPROBANTE,"_CFDI_COMPLEMENTO") <> NIL
	    		IF XMLChildEx(oXML:_CFDI_COMPROBANTE:_CFDI_COMPLEMENTO,"_CCE11_COMERCIOEXTERIOR") <> NIL
		    		cFraccAran	:= oXML:_CFDI_COMPROBANTE:_CFDI_COMPLEMENTO:_CCE11_COMERCIOEXTERIOR:_CCE11_MERCANCIAS:_CCE11_MERCANCIA[i]:_FRACCIONARANCELARIA:TEXT   
		    		cUMT		:= oXML:_CFDI_COMPROBANTE:_CFDI_COMPLEMENTO:_CCE11_COMERCIOEXTERIOR:_CCE11_MERCANCIAS:_CCE11_MERCANCIA[i]:_UnidadAduana:TEXT   
	    		Endif
	    	Endif 
		
    			//Datos del cuerpo de la factura
   			oPrint:Say(nDetY,	060,Transform(Val(oXML:_CFDI_COMPROBANTE:_CFDI_CONCEPTOS:_CFDI_CONCEPTO[i]:_CANTIDAD:TEXT) ,"999,999.9999"),oCouNew10)
			oPrint:Say(nDetY,	280, (oXML:_cfdi_COMPROBANTE:_cfdi_CONCEPTOS:_cfdi_CONCEPTO[i]:_UNIDAD:TEXT),	oCouNew10)
            oPrint:Say(nDetY,	410, cProd+"/ "+cCodSat, oCouNew10)
//            oPrint:Say(nDetY,	500, "/"+cCodSat, oCouNew10)
			/*
			IF !Empty(Alltrim(cUMT))
				oPrint:Say(nDetY,	1380, "/"+cUMT,	oCouNew10)
			Endif
			*/

			// DESCRIPCION

			nLinDes := 0
			If  Alltrim(oXML:_cfdi_COMPROBANTE:_cfdi_CONCEPTOS:_cfdi_CONCEPTO[i]:_DESCRIPCION:TEXT) <>  ""
				cDescT:=(oXML:_cfdi_COMPROBANTE:_cfdi_CONCEPTOS:_cfdi_CONCEPTO[i]:_DESCRIPCION:TEXT)		//Descripcion
				If Len(AllTrim(cDescT)) > 50
					nLoop	:= 1
					For rt := 1 To Len(AllTrim(cDescT)) Step 50
						oPrint:Say(nDetY + (nLinDes * 35),0865,SUBSTR(cDescT,rt,50),oCouNew10)		//Descripcion
						nLoop ++
						nLinDes ++
						nFall ++
					Next rt
				Else
					oPrint:Say(nDetY,0865,Substr(oXML:_cfdi_COMPROBANTE:_cfdi_CONCEPTOS:_cfdi_CONCEPTO[i]:_DESCRIPCION:TEXT,1,50),oCouNew10)
					nLinDes ++
					nFall ++
				Endif
			Endif

			//OBSERVACIONES
			If lFactura
				// RUTINAS PARA BUSCAR LA SECUENCIA EN EL PEDIDO DE VENTA
			// RUTINAS PARA BUSCAR LA SECUENCIA EN EL PEDIDO DE VENTA
			cQueryObs := " SELECT * "
	        cQueryObs += " FROM " + InitSqlName("SD2")+" SD2 "
	        cQueryObs += " WHERE SD2.D2_SERIE  = '"+cSerieLocal+"'"
	        cQueryObs += "   AND SD2.D2_DOC    = '"+cFolioLocal+"'"
	        cQueryObs += "   AND SD2.D2_COD    = '"+cProd +"'"
	        cQueryObs += "   AND SD2.D2_ITEM   = '"+cSec  +"'"
	        cQueryObs += "   AND SD2.D2_FILIAL = '" + xFilial("SD2") + "'"
	        cQueryObs += "   AND SD2.D_E_L_E_T_ = ' '"
	        dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQueryObs),cSQLObs,.T.,.T.)
		        If (cSQLObs)->(!eof())
		            Do while !eof()
		                cSecNumPed 	:= (cSQLObs)->D2_ITEMPV
		                cObs 		:= (cSQLObs)->D2_OBS
		                cSecItFt    := (cSQLObs)->D2_NUMSEQ
		                (cSQLObs)->(Dbskip())
		            End
		        EndIf
		        (cSQLObs)->(Dbclosearea())

				If Len(AllTrim(cObs)) > 50
					nLoop	:= 1
					For O := 1 To Len(AllTrim(cObs)) Step 50
						oPrint:Say(nDetY + (nLinDes * 35),0865,SUBSTR(cObs,O,50),oCouNew10)		
						nLoop ++
						nLinDes ++
						nFall ++
					Next O
				Else
					IF !EMPTY(cObs)
						oPrint:Say(nDetY + (nLinDes * 35),0865,SUBS(cObs,1,50),oCouNew10)
						nLinDes ++
						nFall ++
					ENDIF
				EndIf
			EndIf
			/*		
			oPrint:Say(nDetY,	1330, (oXML:_cfdi_COMPROBANTE:_cfdi_CONCEPTOS:_cfdi_CONCEPTO[i]:_UNIDAD:TEXT),	oCouNew10)
			IF !Empty(Alltrim(cUMT))
				oPrint:Say(nDetY,	1380, "/"+cUMT,	oCouNew10)
			Endif
			*/
			oPrint:Say(nDetY,	1580, Transform(Val(oXML:_cfdi_COMPROBANTE:_cfdi_CONCEPTOS:_cfdi_CONCEPTO[i]:_VALORUNITARIO:TEXT)," 99,999,999.99"),	oCouNew10)
			oPrint:Say(nDetY,	1980, Transform(Val(oXML:_cfdi_COMPROBANTE:_cfdi_CONCEPTOS:_cfdi_CONCEPTO[i]:_IMPORTE:TEXT), " 99,999,999.99"),oCouNew10)
            //TODO JARS HABILITAR DSCTO
			//oPrint:Say(nDetY,	1980, Transform(Val(oXML:_cfdi_COMPROBANTE:_cfdi_CONCEPTOS:_cfdi_CONCEPTO[i]:_DESCUENTO:TEXT), " 99,999,999.99"),oCouNew10)
        

			nDetY	+= (35 * nLinDes)
            /*
			nDetY	:= DetSats(oXML,nDetY,i)
	   		nFall++ 
	   		
	   		nDetY	:= ImpSats(oXML,nDetY,i)
	   		nFall++ 
	   		*/			
			nCurLine 	+= jmp
			cRetItems 	+= SD2->D2_VALIMP2

		next i
	else

		nLinDes	:= 0
    

		cFraccAran 	:= ""
		cUMT 		:= ""
		//fracc Arancelaria
     	IF XMLChildEx(oXML:_CFDI_COMPROBANTE,"_CFDI_COMPLEMENTO") <> NIL
    		IF XMLChildEx(oXML:_CFDI_COMPROBANTE:_CFDI_COMPLEMENTO,"_CCE11_COMERCIOEXTERIOR") <> NIL
	    		cFraccAran	:= oXML:_CFDI_COMPROBANTE:_CFDI_COMPLEMENTO:_CCE11_COMERCIOEXTERIOR:_CCE11_MERCANCIAS:_CCE11_MERCANCIA:_FRACCIONARANCELARIA:TEXT   
	    		cUMT		:= oXML:_CFDI_COMPROBANTE:_CFDI_COMPLEMENTO:_CCE11_COMERCIOEXTERIOR:_CCE11_MERCANCIAS:_CCE11_MERCANCIA:_UnidadAduana:TEXT   
    		Endif
    	Endif 

		// FPB EXTRAE EL CODIGO DE PRODUCTO Y LA SECUENCIA EN LA FACTURA
		cSec 	:= left(oXML:_cfdi_COMPROBANTE:_cfdi_CONCEPTOS:_cfdi_CONCEPTO:_noIdentificacion:TEXT,2)
		cProd 	:= right(oXML:_cfdi_COMPROBANTE:_cfdi_CONCEPTOS:_cfdi_CONCEPTO:_noIdentificacion:TEXT,len(oXML:_cfdi_COMPROBANTE:_cfdi_CONCEPTOS:_cfdi_CONCEPTO:_noIdentificacion:TEXT) - 2)
		cCodSat	:= oXML:_CFDI_COMPROBANTE:_CFDI_CONCEPTOS:_CFDI_CONCEPTO:_CLAVEPRODSERV:TEXT            

		oPrint:Say(nDetY,	60,	Transform(Val(oXML:_cfdi_COMPROBANTE:_cfdi_CONCEPTOS:_cfdi_CONCEPTO:_CANTIDAD:TEXT) ," 999,999.99"),	oCouNew10)
		oPrint:Say(nDetY,	410, cProd+"/"+cCodSat, oCouNew10)
//		oPrint:Say(nDetY,	500, "/"+cCodSat, oCouNew10)
		oPrint:Say(nDetY,	280, (oXML:_cfdi_COMPROBANTE:_cfdi_CONCEPTOS:_cfdi_CONCEPTO:_UNIDAD:TEXT),	oCouNew10)
/*
		IF !Empty(Alltrim(cUMT))
			oPrint:Say(nDetY,	1380, "/"+cUMT,	oCouNew10)
		Endif
*/

		// DESCRIPCION
		If  Alltrim(oXML:_cfdi_COMPROBANTE:_cfdi_CONCEPTOS:_cfdi_CONCEPTO:_DESCRIPCION:TEXT) <>  ""
			cDescT:=(oXML:_cfdi_COMPROBANTE:_cfdi_CONCEPTOS:_cfdi_CONCEPTO:_DESCRIPCION:TEXT)		//Descripcion
			If Len(AllTrim(cDescT)) > 50
				nLoop	:= 1
				For rt := 1 To Len(AllTrim(cDescT)) Step 50
					oPrint:Say(nDetY + (nLinDes * 35),0865,SUBSTR(cDescT,rt,50),oCouNew10)		//Descripcion
					nLoop ++
					nLinDes ++
					nFall ++
				Next rt
			Else
				oPrint:Say(nDetY,0865,Substr(oXML:_cfdi_COMPROBANTE:_cfdi_CONCEPTOS:_cfdi_CONCEPTO:_DESCRIPCION:TEXT,1,50),oCouNew10)
				nLinDes ++
				nFall ++
			Endif
		Endif

		//OBSERVACIONES
		
		If lFactura      
			
			// RUTINAS PARA BUSCAR LA SECUENCIA EN EL PEDIDO DE VENTA
			cQueryObs := " SELECT * "
	        cQueryObs += " FROM " + InitSqlName("SD2")+" SD2 "
	        cQueryObs += " WHERE SD2.D2_SERIE  = '"+cSerieLocal+"'"
	        cQueryObs += "   AND SD2.D2_DOC    = '"+cFolioLocal+"'"
	        cQueryObs += "   AND SD2.D2_COD    = '"+cProd +"'"
	        cQueryObs += "   AND SD2.D2_ITEM   = '"+cSec  +"'"
	        cQueryObs += "   AND SD2.D2_FILIAL = '" + xFilial("SD2") + "'"
	        cQueryObs += "   AND SD2.D_E_L_E_T_ = ' '"
	        dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQueryObs),cSQLObs,.T.,.T.)
		        If (cSQLObs)->(!eof())
		            Do while !eof()
		                cSecNumPed 	:= (cSQLObs)->D2_ITEMPV
		                cObs 		:= (cSQLObs)->D2_OBS
		                cSecItFt    := (cSQLObs)->D2_NUMSEQ
		                (cSQLObs)->(Dbskip())
		            End
		        EndIf
		        (cSQLObs)->(Dbclosearea())

				If Len(AllTrim(cObs)) > 50
					nLoop	:= 1
					For O := 1 To Len(AllTrim(cObs)) Step 50
						oPrint:Say(nDetY + (nLinDes * 35),0865,SUBSTR(cObs,O,50),oCouNew10)		
						nLoop ++
						nLinDes ++
						nFall ++
					Next O
				Else
					IF !EMPTY(cObs)
						oPrint:Say(nDetY + (nLinDes * 35),0865,SUBS(cObs,1,50),oCouNew10)
						nLinDes ++
						nFall ++
					ENDIF
				EndIf
			EndIf
		
		/*
		// FPB IMPRESION DE PEDIMENTOS ES NECESARIO IMPLEMENTAR EL PEPEDIM
		If lFactura
			cPedimento := ALLTRIM(cPedimento)
			If !empty(cPedimento)
				fPedimento := Dtos(POSICIONE("ZZP", 1, XFILIAL("ZZP") + cPedimento, 'ZZP_FECPED'))
				fPedimento := Left(fPedimento,4) + "-" + Substr(fPedimento,5,2)+ "-" + Right(fPedimento,2)
				aPedimento := Alltrim(POSICIONE("ZZP", 1, XFILIAL("ZZP") + cPedimento, 'ZZP_NOMADU'))

				cObs:= "NO. PED. " + cPedimento + ", FECHA:" + fPedimento + ", ADUANA:" + aPedimento
                cPedimAc[val(ALLTRIM(cSec))] := alltrim(cPedimento + "|" + fPedimento + "|" + aPedimento) + "|"

				If Len(AllTrim(cObs)) > 100
					nLoop	:= 1
					For O := 1 To Len(AllTrim(cObs)) Step 100
						oPrint:Say(nDetY + (nLinDes * 35),0615,SUBSTR(cObs,O,100),oCouNew10)
						nLoop ++
						nLinDes ++
						nFall ++
					Next O
				Else
					IF !EMPTY(cObs)
						oPrint:Say(nDetY + (nLinDes * 35),0615,SUBS(cObs,1,100),oCouNew10)
						nLinDes ++
						nFall ++
					EndIf
				ENDIF
			ENDIF
		ENDIF
       */
       
		/*
		oPrint:Say(nDetY,	1330, (oXML:_cfdi_COMPROBANTE:_cfdi_CONCEPTOS:_cfdi_CONCEPTO:_UNIDAD:TEXT),	oCouNew10)
		IF !Empty(Alltrim(cUMT))
			oPrint:Say(nDetY,	1380, "/"+cUMT,	oCouNew10)
		Endif
		*/
			oPrint:Say(nDetY,	1580, Transform(Val(oXML:_cfdi_COMPROBANTE:_cfdi_CONCEPTOS:_cfdi_CONCEPTO:_VALORUNITARIO:TEXT)," 99,999,999.99"),	oCouNew10)
			oPrint:Say(nDetY,	1980, Transform(Val(oXML:_cfdi_COMPROBANTE:_cfdi_CONCEPTOS:_cfdi_CONCEPTO:_IMPORTE:TEXT), " 99,999,999.99"),oCouNew10)
            //TODO JARS 
			//oPrint:Say(nDetY,	1980, Transform(Val(oXML:_cfdi_COMPROBANTE:_cfdi_CONCEPTOS:_cfdi_CONCEPTO:_DESCUENTO:TEXT), " 99,999,999.99"),oCouNew10)

   		nDetY	+= 35
   		/*
   		nDetY	:= DetSat(oXML,nDetY)
   		nFall++  
   		
	   	nDetY	:= ImpSat(oXML,nDetY)
	   	nFall++ 
        */
	EndIf
Else				// Tipo Docto: credito

	dbSelectArea("SD1")
	dbSetOrder(1)
	dbSeek(xFilial("SD1") + cNumFac + cSerie + cCliente + cLOJA )

 	dbSelectArea("SF1")
	dbSetOrder(1)
	dbSeek(xFilial("SF1") + cNumFac + cSerie + cCliente + cLOJA )

	if ( ValType(oXML:_cfdi_COMPROBANTE:_cfdi_CONCEPTOS:_cfdi_CONCEPTO) <> "O" )		// Más de una partida en factura

		for i := 1 to Len(oXML:_cfdi_COMPROBANTE:_cfdi_CONCEPTOS:_cfdi_CONCEPTO)

			nLinDes	:= 0

			if ( i > nTotItem )
				Exit
			endif

			if ( nFall > 31 ) 	// 31 lineas de detalle por página como máximo.
				fGnBoxHead(nDetY + 100,	50, 2190, "LA IMPRESION DE ESTA NOTA DE CRÉDITO CONTINUA EN LA PÁGINA " + strzero(nPagNum+1,2))

				SetNewPage(oXML)

				nDetY	:= 780

			fGnBoxCe(nDetY + nDifLBox,	50, 200, "       CANTIDAD")
			fGnBoxCe(nDetY + nDifLBox,	255, 150, "       UM")
			fGnBoxCe(nDetY + nDifLBox,	410, 450, "  CODIGO/COD SAT.")
			fGnBoxCe(nDetY + nDifLBox,	865, 710, "                                   DESCRIPCIÓN")
			fGnBoxCe(nDetY + nDifLBox,	1580, 330, "               PRECIO U.")
			fGnBoxCe(nDetY + nDifLBox,	1915, 330, "               IMPORTE")


				nFall := 2
				nCurLine := nDetY
			endif

			// FPB EXTRAE EL CODIGO DE PRODUCTO Y LA SECUENCIA EN LA FACTURA
			cSec 	:= left(oXML:_cfdi_COMPROBANTE:_cfdi_CONCEPTOS:_cfdi_CONCEPTO[i]:_noIdentificacion:TEXT,4)
			cProd 	:= right(oXML:_cfdi_COMPROBANTE:_cfdi_CONCEPTOS:_cfdi_CONCEPTO[i]:_noIdentificacion:TEXT,len(oXML:_cfdi_COMPROBANTE:_cfdi_CONCEPTOS:_cfdi_CONCEPTO[i]:_noIdentificacion:TEXT) - 4)
			cCodSat	:= oXML:_CFDI_COMPROBANTE:_CFDI_CONCEPTOS:_CFDI_CONCEPTO[i]:_CLAVEPRODSERV:TEXT            

   			//Datos del cuerpo de la factura
   			oPrint:Say(nDetY,	60,	Transform(Val(oXML:_cfdi_COMPROBANTE:_cfdi_CONCEPTOS:_cfdi_CONCEPTO[i]:_CANTIDAD:TEXT) ," 999,999.99"),	oCouNew10)
 			oPrint:Say(nDetY,	150, (oXML:_cfdi_COMPROBANTE:_cfdi_CONCEPTOS:_cfdi_CONCEPTO[i]:_UNIDAD:TEXT),	oCouNew10)
            oPrint:Say(nDetY,	410, cProd + "/"+cCodSat, oCouNew11)

			// DESCRIPCION
			If  Alltrim(oXML:_cfdi_COMPROBANTE:_cfdi_CONCEPTOS:_cfdi_CONCEPTO[i]:_DESCRIPCION:TEXT) <>  ""
				cDescT:=(oXML:_cfdi_COMPROBANTE:_cfdi_CONCEPTOS:_cfdi_CONCEPTO[i]:_DESCRIPCION:TEXT)		//Descripcion
				If Len(AllTrim(cDescT)) > 50
					nLoop	:= 1
					For rt := 1 To Len(AllTrim(cDescT)) Step 50                               
						oPrint:Say(nDetY + (nLinDes * 35),0615,SUBSTR(cDescT,rt,50),oCouNew10)		//Descripcion
						nLoop ++
						nLinDes ++
						nFall ++
					Next rt
				Else
					oPrint:Say(nDetY,0615,Substr(oXML:_cfdi_COMPROBANTE:_cfdi_CONCEPTOS:_cfdi_CONCEPTO[i]:_DESCRIPCION:TEXT,1,50),oCouNew10)
					nLinDes ++
					nFall ++
				Endif
			Endif

			//OBSERVACIONES
			//RUTINAS PARA BUSCAR EL PEDIMENTO Y LAS OBSERVACIONES DEL ITEM DE LA NOTA
			cQueryObs := " SELECT * "
		    cQueryObs += " FROM " + InitSqlName("SD1")+" SD1 "
		    cQueryObs += " WHERE SD1.D1_SERIE  = '"+cSerieLocal+"'"
		    cQueryObs += "   AND SD1.D1_DOC    = '"+cFolioLocal+"'"
		    cQueryObs += "   AND SD1.D1_COD    = '"+cProd +"'"
		    cQueryObs += "   AND SD1.D1_ITEM   = '"+cSec  +"'"
		    cQueryObs += "   AND SD1.D1_FILIAL = '" + xFilial("SD1") + "'"
		    cQueryObs += "   AND SD1.D_E_L_E_T_ = ' '"
		    dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQueryObs),cSQLObs,.T.,.T.)
		    If (cSQLObs)->(!eof())
		        Do while !eof()
		          	//cPedimento  := (cSQLObs)->D1_PEDIM
					cSecItFt    := (cSQLObs)->D1_NUMSEQ
		          	(cSQLObs)->(Dbskip())
		        End
		    EndIf
		    (cSQLObs)->(Dbclosearea())
	        // EXTRAE LAS OBSERVACIONES DEL ITEM DEL CAMPO ESPECIFICO DE INTELBRAS
	        IF !EMPTY(cSecItFt)
					SD1->(DBSETORDER(4))
					SD1->(DbSeek(xFilial("SD1") + alltrim(cSecItFt),.T.))
					//cObsItemFac := Alltrim(SD1->D1_OBS)
	        ENDIF
			cObs:=cObsItemFac		//Observacion
			If Len(AllTrim(cObs)) > 50
				nLoop	:= 1
				For O := 1 To Len(AllTrim(cObs)) Step 50
					oPrint:Say(nDetY + (nLinDes * 35),0615,SUBSTR(cObs,O,50),oCouNew10)
					nLoop ++
					nLinDes ++
					nFall ++
				Next O
			Else
				IF !EMPTY(cObs)
					oPrint:Say(nDetY + (nLinDes * 35),0615,SUBS(cObs,1,50),oCouNew10)
					nLinDes ++
					nFall ++
				ENDIF
			EndIf
			/*
			// FPB IMPRESION DE PEDIMENTOS ES NECESARIO IMPLEMENTAR EL PEPEDIM
			cPedimento := ALLTRIM(cPedimento)
			If !empty(cPedimento)
				fPedimento := Dtos(POSICIONE("ZZP", 1, XFILIAL("ZZP") + cPedimento, 'ZZP_FECPED'))
				fPedimento := Left(fPedimento,4) + "-" + Substr(fPedimento,5,2)+ "-" + Right(fPedimento,2)
				aPedimento := Alltrim(POSICIONE("ZZP", 1, XFILIAL("ZZP") + cPedimento, 'ZZP_NOMADU'))

				cObs:= "NO. PED. " + cPedimento + ", FECHA:" + fPedimento + ", ADUANA:" + aPedimento
                cPedimAc[val(ALLTRIM(cSec))] := alltrim(cPedimento + "|" + fPedimento + "|" + aPedimento) + "|"

				If Len(AllTrim(cObs)) > 100
					nLoop	:= 1
					For O := 1 To Len(AllTrim(cObs)) Step 100
						oPrint:Say(nDetY + (nLinDes * 35),0615,SUBSTR(cObs,O,100),oCouNew10)
						nLoop ++
						nLinDes ++
						nFall ++
					Next O
				Else
					IF !EMPTY(cObs)
						oPrint:Say(nDetY + (nLinDes * 35),0615,SUBS(cObs,1,100),oCouNew10)
						nLinDes ++
						nFall ++
					EndIf
				ENDIF
			ENDIF
			*/
			oPrint:Say(nDetY,	1455, Transform(Val(oXML:_cfdi_COMPROBANTE:_cfdi_CONCEPTOS:_cfdi_CONCEPTO[i]:_VALORUNITARIO:TEXT)," 99,999,999.99"),	oCouNew10)
			oPrint:Say(nDetY,	1700, Transform(Val(oXML:_cfdi_COMPROBANTE:_cfdi_CONCEPTOS:_cfdi_CONCEPTO[i]:_IMPORTE:TEXT), " 99,999,999.99"),oCouNew10)
//			oPrint:Say(nDetY,	1980, Transform(Val(oXML:_cfdi_COMPROBANTE:_cfdi_CONCEPTOS:_cfdi_CONCEPTO[i]:_DESCUENTO:TEXT), " 99,999,999.99"),oCouNew10)
            //TODO JARS HABILITAR DESCTO
			//oPrint:Say(nDetY,	1980, Transform(Val(oXML:_cfdi_COMPROBANTE:_cfdi_CONCEPTOS:_cfdi_CONCEPTO[i]:_DESCUENTO:TEXT), " 99,999,999.99"),oCouNew10)

			nDetY	+= (35 * nLinDes)
			
			/*
			nDetY	:= DetSats(oXML,nDetY,i)
	   		nFall++     
	   		
	  	  	nDetY	:= ImpSats(oXML,nDetY,i)
	   		nFall++ 
            */
			nCurLine 	+= jmp
			nCurLine 	+= jmp
			cDescItems 	+= SD1->D1_VUNIT * (SD1->D1_DESC / 100) * SD1->D1_QUANT
			cRetItems 	+= SD1->D1_VALIMP2

			dbSelectArea("SF1")
			dbSetOrder(1)
			dbSeek(xFilial("SF1") + cNumFac + cSerie + cCliente + cLOJA )

		next i
	else

		nLinDes	:= 0

		// FPB EXTRAE EL CODIGO DE PRODUCTO Y LA SECUENCIA EN LA FACTURA
		cSec 	:= left(oXML:_cfdi_COMPROBANTE:_cfdi_CONCEPTOS:_cfdi_CONCEPTO:_noIdentificacion:TEXT,4)
		cProd 	:= right(oXML:_cfdi_COMPROBANTE:_cfdi_CONCEPTOS:_cfdi_CONCEPTO:_noIdentificacion:TEXT,len(oXML:_cfdi_COMPROBANTE:_cfdi_CONCEPTOS:_cfdi_CONCEPTO:_noIdentificacion:TEXT) - 4)
		cCodSat	:= oXML:_CFDI_COMPROBANTE:_CFDI_CONCEPTOS:_CFDI_CONCEPTO:_CLAVEPRODSERV:TEXT            

   		//Datos del cuerpo de la factura
   		oPrint:Say(nDetY,	60,	Transform(Val(oXML:_cfdi_COMPROBANTE:_cfdi_CONCEPTOS:_cfdi_CONCEPTO:_CANTIDAD:TEXT) ," 999,999.99"),	oCouNew10)
		oPrint:Say(nDetY,	150, (oXML:_cfdi_COMPROBANTE:_cfdi_CONCEPTOS:_cfdi_CONCEPTO:_UNIDAD:TEXT),	oCouNew10)
      	oPrint:Say(nDetY,	410, cProd+"/ "+cCodSat, oCouNew10)

		// DESCRIPCION
		If  Alltrim(oXML:_cfdi_COMPROBANTE:_cfdi_CONCEPTOS:_cfdi_CONCEPTO:_DESCRIPCION:TEXT) <>  ""
			cDescT:=(oXML:_cfdi_COMPROBANTE:_cfdi_CONCEPTOS:_cfdi_CONCEPTO:_DESCRIPCION:TEXT)		//Descripcion
			If Len(AllTrim(cDescT)) > 50
				nLoop	:= 1
				For rt := 1 To Len(AllTrim(cDescT)) Step 50
					oPrint:Say(nDetY + (nLinDes * 35),0615,SUBSTR(cDescT,rt,50),oCouNew10)		//Descripcion
					nLoop ++
					nLinDes ++
					nFall ++
				Next rt
			Else
				oPrint:Say(nDetY,0615,Substr(oXML:_cfdi_COMPROBANTE:_cfdi_CONCEPTOS:_cfdi_CONCEPTO:_DESCRIPCION:TEXT,1,50),oCouNew10)
				nLinDes ++
				nFall ++
			Endif
		Endif

		//OBSERVACIONES
		//RUTINAS PARA BUSCAR EL PEDIMENTO Y LAS OBSERVACIONES DEL ITEM DE LA NOTA
		cQueryObs := " SELECT * "
	    cQueryObs += " FROM " + InitSqlName("SD1")+" SD1 "
	    cQueryObs += " WHERE SD1.D1_SERIE  = '"+cSerieLocal+"'"
	    cQueryObs += "   AND SD1.D1_DOC    = '"+cFolioLocal+"'"
	    cQueryObs += "   AND SD1.D1_COD    = '"+cProd +"'"
	    cQueryObs += "   AND SD1.D1_ITEM   = '"+cSec  +"'"
	    cQueryObs += "   AND SD1.D1_FILIAL = '" + xFilial("SD1") + "'"
	    cQueryObs += "   AND SD1.D_E_L_E_T_ = ' '"
	    dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQueryObs),cSQLObs,.T.,.T.)
	    If (cSQLObs)->(!eof())
	        Do while !eof()
	          	//cPedimento  := (cSQLObs)->D1_PEDIM
				cSecItFt    := (cSQLObs)->D1_NUMSEQ
	          	(cSQLObs)->(Dbskip())
	        End
	    EndIf
	    (cSQLObs)->(Dbclosearea())
        // EXTRAE LAS OBSERVACIONES DEL ITEM DEL CAMPO ESPECIFICO DE INTELBRAS
        IF !EMPTY(cSecItFt)
				SD1->(DBSETORDER(4))
				SD1->(DbSeek(xFilial("SD1") + alltrim(cSecItFt),.T.))
				//cObsItemFac := Alltrim(SD1->D1_OBS)
        ENDIF
		cObs:=cObsItemFac		//Observacion
		If Len(AllTrim(cObs)) > 50
			nLoop	:= 1
			For O := 1 To Len(AllTrim(cObs)) Step 50
				oPrint:Say(nDetY + (nLinDes * 35),0615,SUBSTR(cObs,O,50),oCouNew10)
				nLoop ++
				nLinDes ++
				nFall ++
			Next O
		Else
			IF !EMPTY(cObs)
				oPrint:Say(nDetY + (nLinDes * 35),0615,SUBS(cObs,1,50),oCouNew10)
				nLinDes ++
				nFall ++
			ENDIF
		EndIf
		/*
		// FPB IMPRESION DE PEDIMENTOS ES NECESARIO IMPLEMENTAR EL PEPEDIM
		cPedimento := ALLTRIM(cPedimento)
		If !empty(cPedimento)
			fPedimento := Dtos(POSICIONE("ZZP", 1, XFILIAL("ZZP") + cPedimento, 'ZZP_FECPED'))
			fPedimento := Left(fPedimento,4) + "-" + Substr(fPedimento,5,2)+ "-" + Right(fPedimento,2)
			aPedimento := Alltrim(POSICIONE("ZZP", 1, XFILIAL("ZZP") + cPedimento, 'ZZP_NOMADU'))

			cObs:= "NO. PED. " + cPedimento + ", FECHA:" + fPedimento + ", ADUANA:" + aPedimento
            cPedimAc[val(ALLTRIM(cSec))] := alltrim(cPedimento + "|" + fPedimento + "|" + aPedimento) + "|"

			If Len(AllTrim(cObs)) > 100
				nLoop	:= 1
				For O := 1 To Len(AllTrim(cObs)) Step 100
					oPrint:Say(nDetY + (nLinDes * 35),0615,SUBSTR(cObs,O,100),oCouNew10)
					nLoop ++
					nLinDes ++
					nFall ++
				Next O
			Else
				IF !EMPTY(cObs)
					oPrint:Say(nDetY + (nLinDes * 35),0615,SUBS(cObs,1,100),oCouNew10)
					nLinDes ++
					nFall ++
				EndIf
			ENDIF
		ENDIF
		*/

//			oPrint:Say(nDetY,	1330, (oXML:_cfdi_COMPROBANTE:_cfdi_CONCEPTOS:_cfdi_CONCEPTO:_UNIDAD:TEXT),	oCouNew10)
			oPrint:Say(nDetY,	1455, Transform(Val(oXML:_cfdi_COMPROBANTE:_cfdi_CONCEPTOS:_cfdi_CONCEPTO:_VALORUNITARIO:TEXT)," 99,999,999.99"),	oCouNew10)
			oPrint:Say(nDetY,	1700, Transform(Val(oXML:_cfdi_COMPROBANTE:_cfdi_CONCEPTOS:_cfdi_CONCEPTO:_IMPORTE:TEXT), " 99,999,999.99"),oCouNew10)
//			oPrint:Say(nDetY,	1980, Transform(Val(oXML:_cfdi_COMPROBANTE:_cfdi_CONCEPTOS:_cfdi_CONCEPTO:_DESCUENTO:TEXT), " 99,999,999.99"),oCouNew10)

		nDetY	+= (35 + nLinDes)
		/*
		nDetY	:= DetSat(oXML,nDetY)
	 	nFall++
        
   	   	nDetY	:= ImpSat(oXML,nDetY)
	  	nFall++  
	  	*/
		nCurLine 	+= jmp
		cDescItems 	+= SD1->D1_VUNIT * (SD1->D1_DESC / 100) * SD1->D1_QUANT
		cRetItems 	+= SD1->D1_VALIMP2

	EndIf

Endif

nCurLine += 10            

//	fWrite(_hDL,"Fin de Det:"+time()+cEOL)                 

Return (nCurLine)


Static Function SetNewPage(oXML)
	oPrint:EndPage()
	oPrint:StartPage()
	nPagNum++
	PrtHeader(oXML)
	nFotY	:= nDetY
Return ()

 
Static Function BuscaCadOri(cCadOrig,oXML)
		cCadOrig :="||"
		cCadOrig += Alltrim( oXML:_cfdi_COMPROBANTE:_cfdi_Complemento:_tfd_TimbreFiscalDigital:_version:TEXT )  + "|"
	  	cCadOrig += Alltrim( oXML:_cfdi_COMPROBANTE:_cfdi_Complemento:_tfd_TimbreFiscalDigital:_UUID:TEXT )  + "|"
		cCadOrig += Alltrim( oXML:_cfdi_COMPROBANTE:_cfdi_Complemento:_tfd_TimbreFiscalDigital:_FechaTimbrado:TEXT )  + "|"
	 	cCadOrig += Alltrim( oXML:_cfdi_COMPROBANTE:_cfdi_Complemento:_tfd_TimbreFiscalDigital:_selloCFD:TEXT )  + "|"
		cCadOrig += Alltrim( oXML:_cfdi_COMPROBANTE:_cfdi_Complemento:_tfd_TimbreFiscalDigital:_noCertificadoSAT:TEXT ) + "|"
		cCadOrig += "|"
Return(Nil)

Static Function MBSendMail(cAccount,cPassword,cServer,cFrom,cEmail,cAssunto,cMensagem,cBodyMsg,xAttach)

Local cEmailTo := ""
Local cEmailBcc:= ""
Local lResult  := .F.
Local cError   := ""
Local lRelauth := GetMv("MV_RELAUTH")		// Parametro que indica se existe autenticacao no e-mail
Local lRet	   := .F.
Local cConta   := ALLTRIM(cAccount)
Local xSenha   := ALLTRIM(cPassword)
Local aAttach  := ""

IF ValType(xAttach) <> "A"
   aAttach := { xAttach }
Else
   aAttach := xAttach
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Envia o mail para a lista selecionada. Envia como BCC para que a pessoa pense³
//³que somente ela recebeu aquele email, tornando o email mais personalizado.   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

if (TelaEmail(@cMensagem,cAssunto,@aAttach,@cEmail))

	cEmailTo := cEmail
	If At(";",cEmail) > 0 // existe um segundo e-mail.
		cEmailBcc:= SubStr(cEmail,At(";",cEmail)+1,Len(cEmail))
	Endif

	lResult := MailSmtpOn( cServer, cConta, xSenha, )

	// Se a conexao com o SMPT esta ok
	If lResult
		// Se existe autenticacao para envio valida pela funcao MAILAUTH
		If lRelauth
			lRet := Mailauth(cConta,xSenha)
		Else
			lRet := .T.
	    Endif

		If lRet

	        lResult := MailSend( cFrom, { cEmailTo }, { }, { cEmailBcc }, cAssunto, cBodyMsg, aAttach , .F. )

			If !lResult
				//Erro no envio do email
				cError:=MailGetErr( )
				Help(" ",1,"ATENCIÓN",,cError+ " " + cEmailTo,4,5)
			Endif

		Else
			cError:=MailGetErr( )
			Help(" ",1,"Autenticación",,cError,4,5)
			MsgStop("Error en la autenticación","Hace la verificación de la cuenta y contraseña")
		Endif

		MailSmtpOff()  // Disconnect to Smtp Server

	Else
		//Erro na conexao com o SMTP Server
		cError:=MailGetErr( )
		Help(" ",1,"Atención",,cError,4,5)
	Endif

EndIf

Return(lResult)



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ TelaEmail   ³ Autor ³ Microsiga ³          Data ³07/08/03  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Monta o e-mail para Cross-Posting                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso	     ³Lista de Contatos                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function TelaEmail(cMensagem,cAssunto,aAttach,cEmail)
	Local oDlgMb
	Local oMens
	Local oSubj
	Local oAttach
	Local nAttach := 0 							// Controle do ListBox
	Local nOpcao  := 0
	Local lRet    := .F.

	cMensagem 	+= Space(100)
	cAttach   	:= ""
	nOpcRet 	:= 0

	while (nOpcRet == 0)
		DEFINE MSDIALOG oDlgMb FROM 05,2 TO 350,530 TITLE "Composición del correo "+cAssunto PIXEL
			@ 02, 04 TO  25,260 OF oDlgMb PIXEL
			@ 09, 08 SAY "Para:" OF oDlgMb SIZE 40,8 PIXEL
			@ 09, 32 GET oSubj VAR cEmail OF oDlgMb SIZE 225,8 PIXEL

			@ 27, 04 TO 105,260 LABEL "Mensaje" OF oDlgMb PIXEL

			@ 33, 06 GET oMens VAR cMensagem WHEN .F. OF oDlgMb MEMO SIZE 250,70 PIXEL WHEN .T.

			@ 106,04 TO 155,260 LABEL "" OF oDlgMb PIXEL

			@ 109,06 LISTBOX oAttach VAR nAttach FIELDS HEADER "Anexos" SIZE 250,45 OF oDlgMb PIXEL NOSCROLL
			oAttach:SetArray(aAttach)
			oAttach:Refresh()
			DEFINE SBUTTON FROM 160 ,170 TYPE 3 PIXEL ACTION (RemoveAnexo(@aAttach,@oAttach)) ENABLE OF oDlgMb
			DEFINE SBUTTON FROM 160 ,202 TYPE 2 PIXEL ACTION Eval( {|| nOpcRet := 2, oDlgMb:End() }) ENABLE OF oDlgMb
			DEFINE SBUTTON FROM 160 ,234 TYPE 1 PIXEL ACTION Eval( {|| IIF(ValEmail(cEmail,cMensagem),nOpcRet := 1,nOpcRet := 0),oDlgMb:End()}) ENABLE OF oDlgMb
		ACTIVATE MSDIALOG oDlgMb CENTERED
	enddo

	oMainWnd:Refresh()

	if (nOpcRet == 2)
		Return .F.
	endif
Return .T.

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçäo    ¦ ValEmail    ¦Autor  ¦Microsiga           ¦ Data ¦07/08/03  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçäo ¦Valida o assunto e a mensagem do e-mail                     ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso           ¦Lista de Contatos
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/
Static Function ValEmail(cEmail,cMensagem)
	Local lRet	:= .F.

	//+---------------------------------------+
	//¦Valida se foi digitada o assunto.      ¦
	//+---------------------------------------+
	if Empty(cEmail)
		Help(" ",1,"SEMEMAIL")
	else
        //+---------------------------------------+
        //¦Valida se foi digitada alguma mensagem.¦
        //+---------------------------------------+
        if Empty(cMensagem)
        	Help(" ",1,"SEMMENSAGE")
        else
 			lRet := .T.
        endif
	endif
Return(lRet)
/*/
________________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+---------------------------------------------------------------------------¦¦
¦¦¦Funçäo    ¦ RemoveAnexo ¦  Autor  ¦Rafael M. Quadrotti    ¦ Data ¦07/08/03 ¦¦
¦¦+----------+----------------------------------------------------------------¦¦
¦¦¦Descriçäo ¦Remove o Anexo de arquivos para o email                         ¦¦
¦¦+----------+----------------------------------------------------------------¦¦
¦¦¦Uso           ¦Lista de Contatos                                           ¦¦
¦¦+---------------------------------------------------------------------------¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/
Static Function RemoveAnexo(aAttach,oAttach)
	if Len(aAttach) > 0
	   ADel(aAttach,oAttach:nAt)  			// deleta o item
	   ASize(aAttach, Len(aAttach) - 1) 	//redimensiona o array
	endif

	oAttach:SetArray(aAttach)
	oAttach:Refresh()
Return .T.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AjustaSX1 ºAutor  ³Bruno Daniel Borges º Data ³ 17/03/2008  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Signature                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AjustaSX1()
/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³ Verifica as perguntas selecionadas ³
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	Local aRegs := {}
	Local cPerg := "EFAT002R"

	aAdd(aRegs,{cPerg,"01","De Fecha          ","De Fecha          ","De Fecha          ","mv_ch1","D", 08,0,2,"G","","mv_par01","","","","'01/04/09'","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"02","A Fecha           ","A Fecha           ","A Fecha           ","mv_ch2","D", 08,0,2,"G","","mv_par02","","","","'31/12/09'","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"03","De Serie          ","De Serie          ","De Serie          ","mv_ch3","C", 03,0,2,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"04","A Serie           ","A Serie           ","A Serie           ","mv_ch4","C", 03,0,2,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"05","De Factura        ","De Factura        ","De Factura        ","mv_ch5","C", 10,0,2,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"06","A Factura         ","A Factura         ","A Factura         ","mv_ch6","C", 10,0,2,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AAdd(aRegs,{cPerg,"07","Tipo de Documento ","Tipo de Documento ","Tipo de Documento ","mv_ch7","N", 01,0,1,"C","","mv_par07","Factura - NF","Factura - NF","Factura - NF","","","Nota de Credito - NCC","Nota de Credito - NCC","Nota de Credito - NCC","","","","","","","","","","","","","","","","","",""})
	//aAdd(aRegs,{cPerg,"08","Entrada o Salida  ","Entrada o Salida  ","Entrada o Salida  ","mv_ch8","N", 01,0,1,"C","","mv_par08","Salida","Salida","Salida","","","Entrada","Entrada","Entrada","","","","","","","","","","","","","","","","","",""})

//	LValidPerg( aRegs )

Return

Static Function BtCan(cCad,cNumFac,cSerie)
Local cRet := ""
Local nTipoMon := 0

If lFactura //Si es Factura de Salida
	nTipoMon := SF2->F2_MOEDA
ELSE
	nTipoMon := SF1->F1_MOEDA
ENDIF

//cRet  := Extenso( Val(cCad) ,      , nTipoMon ,        , IIF(nTipoMon ==1,"2","3") , 	 , .T. ,       , "2" )
cRet  := Extenso( Val(cCad) ,           , nTipoMon ,           , "2"      , 	   , .T. ,       , "2" )
       //Extenso( <nValor>  , <lQuantid>, <nMoeda> , <cPrefixo>, <cIdioma>, <lCent>, <lFrac> )

Return (cRet)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fGnBoxHead ºAutor  ³Cleverson Schaefer  º Data ³  18/10/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rutina para generar rectangulo llenado y con su texto       º±±
±±º          ³                                                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Microsiga Mexico                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function fGnBoxHead(nLinIni, nColIni, nTamBox, cTexBox)
**************************************************************

	nAltBox		:= 45
	nITextLin	:= 30
	nITextCol	:= 10
/*
	oPrint:Box( nLinIni + 2,;
				nColIni + 1,;
				nLinIni + 2 + nAltBox,;
				nColIni + 1 + nTamBox)
*/
	oPrint:Fillrect( {nLinIni + 1 ,;
					  nColIni + 1 ,;
					  nLinIni + 1 + nAltBox ,;
					  nColIni + 1 + nTamBox };
					  ,oBrushGray, "-2")

	oPrint:Say( nLinIni + 1 + nITextLin,;
				nColIni + 1 + nITextCol,;
				cTexBox,;
				oArial09N,,CLR_WHITE,,2)

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fGnBoxDet ºAutor  ³Cleverson Schaefer  º Data ³  18/10/12    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rutina para generar rectangulo vacion que será llenado con  º±±
±±º          ³ la clase SAY()                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Microsiga Mexico                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function fGnBoxDet(nLinIni, nColIni, nTamBox, nAltBox)
*************************************************************
	oPrint:Box( nLinIni + 2,;
				nColIni + 1,;
				nLinIni + 2 + nAltBox,;
				nColIni + 1 + nTamBox)

Return

// Funcion que muestra una ventana donde se puede informar las observaciones de la factura
// 30/01/2013 Filiberto Perez
STATIC Function InfObsFT(cNumFac, cSerie)
	Local	nbansal		:=0
	Local   cQry        := ""
	Local   cRemis      := ""                    
	Local   nQtdRem     := 0
	PUBLIC   cObserva    := cObservaciones
	PUBLIC 	oDlg       
	
	If  lFactura 					// factura	
	
		cQry := "SELECT DISTINCT D2_REMITO "
		cQry += "FROM " + InitSqlName("SD2")+" SD2 "
		cQry += "WHERE SD2.D2_DOC  = '" + cNumFac + "' "
		cQry += "AND SD2.D2_FILIAL = '" + xFilial("SD2") + "' "
		cQry += "AND SD2.D2_SERIE = '" + cSerie + "' "
		cQry += "AND SD2.D_E_L_E_T_ = ' '"
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),"REMIS",.T.,.T.)      
		
		While REMIS->(!eof())
			If !Empty(REMIS->D2_REMITO)
				cRemis += REMIS->D2_REMITO + ", "
				nQtdRem++
			EndIf
		    REMIS->(Dbskip())
		EndDo
        
        REMIS->(Dbclosearea())
	
	EndIf        
	
	If nQtdRem == 1
	
		cObserva := "Remisión " + Substr(cRemis,1,Len(cRemis)-2)	
		
	ElseIf nQtdRem > 1
	
		cObserva := "Remisiones " + Substr(cRemis,1,Len(cRemis)-2)	
		
	EndIf

	define msDialog oDlg title 'Observaciones de la factura ' from 00,00 to 150,600 pixel
	@ 003,003 GET oObserva VAR cObserva OF oDlg MULTILINE SIZE 267,50 COLORS 0, 16777215 NO VSCROLL PIXEL
	@ 060, 234 BUTTON oBtAceptar PROMPT "Aceptar" SIZE 037, 012 OF oDlg ACTION SaveObs(cNumFac, cSerie) PIXEL
	ACTIVATE MSDIALOG oDlg CENTERED

	If nbansal == 0
		cObserva:=""
	Endif
return

STATIC Function SaveObs(cNumFac, cSerie)
	cObservaciones := cObserva    
	cObserva := ""
	
	if  lFactura 					// factura
		DbSelectArea("SF2")
		DbSetOrder(1)
		DbSeek( xFilial("SF2") + cNumFac + cSerie ) // Búsqueda exacta
		IF Found() // Evalúa la devolución del último DbSeek realizado
			RecLock("SF2",.F.)
			//SF2->F2_OBS := Alltrim(cObservaciones)
			MsUnLock() // Confirma y finaliza la operación
		ENDIF
	else 				// CREDITO
		DbSelectArea("SF1")
		DbSetOrder(1)
		DbSeek( xFilial("SF1") + cNumFac + cSerie ) // Búsqueda exacta
		IF Found() // Evalúa la devolución del último DbSeek realizado
			RecLock("SF1",.F.)
			//SF1->F1_OBS := Alltrim(cObservaciones)
			MsUnLock() // Confirma y finaliza la operación
		ENDIF
	endif

	oDlg:End()
RETURN

// FPB FUNCION QUE GENERA LOS ITULOS DE LAS COLUMNAS CENTRALIZADOS.
Static Function fGnBoxCe(nLinIni, nColIni, nTamBox, cTexBox)

	nAltBox	:= 45
	nITextLin	:= 30
	nITextCol	:= 10

	oPrint:Fillrect( {nLinIni + 1 ,;
					  nColIni + 1 ,;
					  nLinIni + 1 + nAltBox ,;
					  nColIni + 1 + nTamBox };
					  ,oBrushGray, "-2")

	oPrint:Say( nLinIni + 1 + nITextLin,;
				nColIni + 1 + nITextCol,;
				cTexBox,;
				oArial09N,,CLR_WHITE,,2)

/*
nRow 		Numérico 	Indica a coordenada vertical em pixels ou caracteres. X
nCol 		Numérico 	Indica a coordenada horizontal em pixels ou caracteres. X
cText 		Caracter 	Indica o texto que será impresso. X
oFont 		Objeto 		Indica o objeto do tipo TFont utilizado para definir as características da fonte aplicada na exibição do conteúdo do controle visual.
nWidth 		Numérico 	Indica a largura em pixels do objeto.
nHeigth 	Numérico 	Indica a altura em pixels do objeto.
nClrText 	Numérico 	Indica a cor do texto do objeto.
nAlignHorz 	Numérico 	Alinhamento Horizontal. Para mais informações sobre os alinhamentos disponíveis, consulte a área Observações.
nAlignVert 	Numérico 	Alinhamento Vertical. Para mais informações sobre os alinhamentos disponíveis, consulte a área Observações.

Tabela de códigos de alinhamento horizontal.
•0 - Alinhamento à esquerda;
•1 - Alinhamento à direita;
•2 - Alinhamento centralizado

Tabela de códigos de alinhamento vertical.
•0 - Alinhamento centralizado;
•1 - Alinhamento superior;
•2 - Alinhamento inferior
*/
Return

Static Function GeraTRB()
Local aStruTRB := {}
Local aCamposTRB := {}
Local aCpoQuery := {}
Local aAreaTrb  := {}
Local nI := 1

	if lFactura
		aSindex := {	{ "1","F2_FILIAL+F2_DOC"},;
			{ "2","F2_FILIAL+F2_CLIENTE+F2_LOJA+F2_SERIE+F2_DOC"},;
			{ "3","F2_FILIAL+F2_CLIENTE+F2_LOJA"},;
			{ "4","F2_FILIAL+F2_OK+F2_CLIENTE+F2_LOJA"} }   
			
			 //Irei criar a pesquisa que será apresentada na tela
        aAdd(aSeek,{"Sucursal+Documento"	,{{"","C",28,0,"Sucursal+Documento"	,"@!"}} } )
        aAdd(aSeek,{"Sucursal+Cliente+Loja+Serie+Documento",{{"","C",33,0,"Sucursal+Cliente+Loja+Serie+Documento"	,"@!"}} } )
        aAdd(aSeek,{"Sucursal+Cliente+Loja",{{"","C",10,0,"Sucursal+Cliente+Loja",""}} } )
        //aAdd(aSeek,{"ID"	,{{"","C",006,0,"ID"	,"@!"}} } )
			
	Else
		aSindex := {	{ "1","F1_FILIAL+F1_DOC"},;
			{ "2","F1_FILIAL+F1_FORNECE+F1_LOJA+F1_SERIE+F1_DOC"},;
			{ "3","F1_FILIAL+F1_FORNECE+F1_LOJA"},;
			{ "4","F1_FILIAL+F1_OK+F1_FORNECE+F1_LOJA"} }
	
	    aAdd(aSeek,{"Sucursal+Documento"	,{{"","C",28,0,"Sucursal+Documento"	,"@!"}} } )
        aAdd(aSeek,{"Suursal+Cliente+Loja+Serie+Documento",{{"","C",33,0,"Login"	,"@!"}} } )
   		aAdd(aSeek,{"Sucursal+Cliente+Loja",{{"","C",10,0,"Sucursal+Cliente+Loja",""}} } )  
   		
	Endif
	
	If Select("TRB") <> 0
			dbSelectArea("TRB")
			dbCloseArea()
	EndIf
	
	//aStruTRB := {"RECNO","N",10,0}
	
	if lFactura
		//dbSelectArea("SF2")	
		Aadd(aStruTRB,{"F2_FILIAL","C",2,0})
		Aadd(aStruTRB,{"F2_DOC","C",20,0})
	   Aadd(aStruTRB,{"F2_SERIE","C",3,0})
	   Aadd(aStruTRB,{"F2_ESPECIE","C",3,0})
	   Aadd(aStruTRB,{"F2_EMISSAO","D",8,0})
	   Aadd(aStruTRB,{"F2_CLIENTE","C",6,0})
	   Aadd(aStruTRB,{"F2_LOJA","C",2,0})
	   Aadd(aStruTRB,{"F2_MOEDA","N",2,0})
	   Aadd(aStruTRB,{"F2_UUID","C",36,0})
	   Aadd(aStruTRB,{"F2_OK","C",2,0})	
	   Aadd(aStruTRB,{"F2_STATUS","C",1,0})			
	else
		//dbselectarea("SF1")
		Aadd(aStruTRB,{"F1_FILIAL","C",2,0})
		Aadd(aStruTRB,{"F1_DOC","C",20,0})
	   Aadd(aStruTRB,{"F1_SERIE","C",3,0})
	   Aadd(aStruTRB,{"F1_ESPECIE","C",3,0})
	   Aadd(aStruTRB,{"F1_EMISSAO","C",10,0})
	   Aadd(aStruTRB,{"F1_FORNECE","C",6,0})
	   Aadd(aStruTRB,{"F1_LOJA","C",2,0})
	   Aadd(aStruTRB,{"F1_MOEDA","N",2,0})
	   Aadd(aStruTRB,{"F1_UUID","C",36,0})
	   Aadd(aStruTRB,{"F1_OK","C",2,0})
	   Aadd(aStruTRB,{"F1_STATUS","C",1,0})		
	Endif
	
	Aadd(aStruTRB,{"RECNOF","N",10,0})
	Aadd(aStruTRB,{"A1_NOME","C",30,0})
	//Aadd(aStruTRB,{"A3_NOME","C",30,0})
	cQuery := "SELECT  "
		/*
		For nI:=1 To Len(aStruTRB)
			If Alltrim(aStruTRB[nI][1]) <> 'D2_QTDAFAT'
				cQuery += aStruTRB[nI][1]+","
			Endif
		Next nI*/
		
	
	
	cNomeArq:=CriaTrab( aStruTRB, .T. )
	dbUseArea(.T.,__LocalDriver,cNomeArq,"TRB",.T.,.F.)
		
	For nI := 1 To Len(aSindex)
		Aadd(aIndTRB,SubStr(CriaTrab(Nil,.F.),1,7)+AllTrim(aSindex[nI][1]))
		cChave := aSindex[nI][2]
		dbSelectArea("TRB")
		dbCreateInd(aIndTRB[Len(aIndTRB)]+OrdBagExt(),cChave, {|| cChave})
	Next nI
	
	dbClearInd()
		
	For nI := 1 To Len(aSindex)
		dbSetIndex(aIndTRB[nI]+OrdBagExt())				
	Next nI
	
	if lFactura
		cQuery += "  F2_FILIAL,F2_OK,F2_DOC,F2_SERIE,F2_ESPECIE,F2_EMISSAO,F2_CLIENTE,F2_LOJA,A1_NOME,F2_MOEDA,F2_STATUS,F2_UUID, SF2.R_E_C_N_O_ RECNOF "
		cSelect := cQuery
		cQuery += " FROM " + RetSqlName("SF2") + " SF2, "+RetSqlName("SA1") + " SA1 "
	    cQuery += " WHERE " +  " F2_EMISSAO  BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"' AND "
	    cQuery += " F2_SERIE BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' AND "
	    cQuery += " F2_DOC BETWEEN '"+mv_par05+"' AND '"+mv_par06+"' AND "
	    cQuery += " F2_FILIAL='"+xFilial("SF2")+"' AND "
	    cQuery += " F2_CLIENTE = A1_COD AND F2_LOJA= A1_LOJA AND SF2.D_E_L_E_T_ <> '*' AND SA1.D_E_L_E_T_ <> '*'  AND"
	    cQuery += " F2_TIPODOC='01' "
    Else
    	cQuery += "  F1_FILIAL,F1_OK,F1_DOC,F1_SERIE,F1_ESPECIE,F1_EMISSAO,F1_FORNECE,F1_LOJA,A1_NOME,F1_MOEDA,F1_STATUS,F1_UUID, SF1.R_E_C_N_O_ RECNOF "
		cSelect := cQuery
		cQuery += " FROM " + RetSqlName("SF1") + " SF1, "+RetSqlName("SA1") + " SA1 "
	    cQuery += " WHERE " +  " F1_EMISSAO  BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"' AND "
	    cQuery += " F1_SERIE BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' AND "
	    cQuery += " F1_DOC BETWEEN '"+mv_par05+"' AND '"+mv_par06+"' AND "
	    cQuery += " F1_FILIAL= '"+xFilial("SF1")+"'  AND "
	    cQuery += " F1_FORNECE = A1_COD AND F1_LOJA= A1_LOJA  AND SF1.D_E_L_E_T_ <> '*' AND SA1.D_E_L_E_T_ <> '*'  AND"
	    cQuery += " F1_TIPODOC='04' "
    
    Endif 
    
	MsAguarde({|| SqlToTrb(cQuery, aStruTRB, 'TRB')},OemToAnsi("Seleccionando Comprobantes...")) 
	
	dbSelectArea("TRB")
	DbSetOrder(1)
	DbGoTop()
	If Bof() .and. Eof()
	//"No hay +cRetTitle+ "s(es) disponibles para Facturacion..."
	cMsg :="No hay Documentos disponibles para Impresion..." 
	MsgStop( cMsg )
	Return .F.
EndIf

Return .T.

Static Function fLegenda()
	aLegenda:= {{ 'BR_VERDE'    , 'Doc. Timbrado' },;  
					{ 'BR_VERMELHO' , 'Doc. no Timbrado' },;
					{ 'BR_LARANJA' , 'Doc.  Timbrado e Impreso' },;
					{ 'BR_AZUL' , 'Doc. Timbrado y Enviado por Correo' }}  

	BrwLegenda("Comprobantes Fiscales","Leyenda",aLegenda)     
Return	
	


//Funcion para mandar el Detalle de prod Sat cuando son varios conceptos
Static Function DetSats(oXML,nDetY,i)                                    
	Local cCodSAT	:= oXML:_CFDI_COMPROBANTE:_CFDI_CONCEPTOS:_CFDI_CONCEPTO[i]:_CLAVEPRODSERV:TEXT
	Local cDescSat	:= U_DESCRIP4("S002",cCodSAT,8,70)   	//Buscar la Descripcion del Producto SAT
	Local cUMSat	:= oXML:_CFDI_COMPROBANTE:_CFDI_CONCEPTOS:_CFDI_CONCEPTO[i]:_CLAVEUNIDAD:TEXT 
	
	oPrint:Say(nDetY, 260,	cCodSat, oArial09)         
	oPrint:Say(nDetY, 615,	Substr(cDescSat,1,75),oArial09)
 	oPrint:Say(nDetY, 1530, cUMSat,	oArial09) 	
// 	nFall++                                          
 	nDetY	:= nDetY+35
Return  nDetY


//Funcion para mandar el Detalle de prod Sat cuando es un Solo Concepto
Static Function DetSat(oXML,nDetY)                                     
	Local cCodSAT		:=	oXML:_CFDI_COMPROBANTE:_CFDI_CONCEPTOS:_CFDI_CONCEPTO:_CLAVEPRODSERV:TEXT
	Local cDescSat		:=	U_DESCRIP4("S002",cCodSAT,8,70)   	//Buscar la Descripcion del Producto SAT
	Local cUMSat		:=	oXML:_CFDI_COMPROBANTE:_CFDI_CONCEPTOS:_CFDI_CONCEPTO:_CLAVEUNIDAD:TEXT 	
	oPrint:Say(nDetY, 260,	cCodSat, oArial09)         
	oPrint:Say(nDetY, 615,	Substr(cDescSat,1,75),oArial09)
 	oPrint:Say(nDetY, 1530, cUMSat,	oArial09) 	
//	nFall++         
	nDetY	:= nDetY+35
Return nDetY   


//Para ver si hay impuestos para Imprimirlos a Nivel Item cuando son varios Conceptos
Static Function ImpSats(oXML,nDetY,i)
Local cCodImp	:= ""
Local nImpImp	:= 0
Local nTasaImp	:= 0.000000
Local cTipoImp	:= ""
Local cImpuesto	:= ""
Local nBase		:= 0
Local r := 1
	IF XmlChildEx(oXML:_CFDI_COMPROBANTE:_CFDI_CONCEPTOS:_CFDI_CONCEPTO[i],"_CFDI_IMPUESTOS" ) <> NIL                     
		IF XmlChildEx(oXML:_CFDI_COMPROBANTE:_CFDI_CONCEPTOS:_CFDI_CONCEPTO[i]:_CFDI_IMPUESTOS, "_CFDI_TRASLADOS" ) <> NIL
			if ( ValType(oXML:_CFDI_COMPROBANTE:_CFDI_CONCEPTOS:_CFDI_CONCEPTO[i]:_CFDI_IMPUESTOS:_CFDI_TRASLADOS:_CFDI_TRASLADO) <> "O" )
				for r := 1 to Len(oXML:_CFDI_COMPROBANTE:_CFDI_CONCEPTOS:_CFDI_CONCEPTO[i]:_CFDI_IMPUESTOS:_CFDI_TRASLADOS:_CFDI_TRASLADO) 
					cImpuesto	:= oXML:_CFDI_COMPROBANTE:_CFDI_CONCEPTOS:_CFDI_CONCEPTO[i]:_CFDI_IMPUESTOS:_CFDI_TRASLADOS:_CFDI_TRASLADO[r]:_IMPUESTO:TEXT
		 //			cImpuesto	:= DescImpuesto()
					cTipoImp	:= oXML:_CFDI_COMPROBANTE:_CFDI_CONCEPTOS:_CFDI_CONCEPTO[i]:_CFDI_IMPUESTOS:_CFDI_TRASLADOS:_CFDI_TRASLADO[r]:_TIPOFACTOR:TEXT 
					IF VALTYPE(XmlChildex(oXML:_CFDI_COMPROBANTE:_CFDI_CONCEPTOS:_CFDI_CONCEPTO[i]:_CFDI_IMPUESTOS:_CFDI_TRASLADOS:_CFDI_TRASLADO[r],"_TASAOCUOTA")) = "O"
						nTasaImp	:= oXML:_CFDI_COMPROBANTE:_CFDI_CONCEPTOS:_CFDI_CONCEPTO[i]:_CFDI_IMPUESTOS:_CFDI_TRASLADOS:_CFDI_TRASLADO[r]:_TASAOCUOTA:TEXT
					Else
						nTasaImp	:= "0.000000"
					Endif 
					IF VALTYPE(XmlChildex(oXML:_CFDI_COMPROBANTE:_CFDI_CONCEPTOS:_CFDI_CONCEPTO[i]:_CFDI_IMPUESTOS:_CFDI_TRASLADOS:_CFDI_TRASLADO[r],"_IMPORTE")) = "O"
					    cImporte	 := oXML:_CFDI_COMPROBANTE:_CFDI_CONCEPTOS:_CFDI_CONCEPTO[i]:_CFDI_IMPUESTOS:_CFDI_TRASLADOS:_CFDI_TRASLADO[r]:_IMPORTE:TEXT
						nTotTras	 += Val(cImporte)
					Else 
						cImporte	:= "0.00"
					Endif
					
					oPrint:Say(nDetY,	0260, "BASE :"+Transform(Val(oXML:_CFDI_COMPROBANTE:_CFDI_CONCEPTOS:_CFDI_CONCEPTO[i]:_CFDI_IMPUESTOS:_CFDI_TRASLADOS:_CFDI_TRASLADO[r]:_BASE:TEXT) ,"999,999.9999"),	oArial09)
			 		oPrint:Say(nDetY,	0615, "IMPUESTO: "+cImpuesto,	oArial09)
			 		oPrint:Say(nDetY,	1000, "TIPO FACTOR: "+cTipoImp,	oCouNew10) 
					oPrint:Say(nDetY,	1530, "Tasa o Cuota: " +nTasaImp,	oCouNew10) 
					oPrint:Say(nDetY,	1900, "IMPORTE: "+Transform(Val(cImporte),"9,999,999.99"),	oCouNew10)		
					nFall++    
					nDetY	:= nDetY+35
				End for
			Else   
			
					cImpuesto	:= oXML:_CFDI_COMPROBANTE:_CFDI_CONCEPTOS:_CFDI_CONCEPTO[i]:_CFDI_IMPUESTOS:_CFDI_TRASLADOS:_CFDI_TRASLADO:_IMPUESTO:TEXT
					cTipoImp	:= oXML:_CFDI_COMPROBANTE:_CFDI_CONCEPTOS:_CFDI_CONCEPTO[i]:_CFDI_IMPUESTOS:_CFDI_TRASLADOS:_CFDI_TRASLADO:_TIPOFACTOR:TEXT
//					nTasaImp	:= oXML:_CFDI_COMPROBANTE:_CFDI_CONCEPTOS:_CFDI_CONCEPTO[i]:_CFDI_IMPUESTOS:_CFDI_TRASLADOS:_CFDI_TRASLADO:_TASAOCUOTA:TEXT  
					
					IF VALTYPE(XmlChildex(oXML:_CFDI_COMPROBANTE:_CFDI_CONCEPTOS:_CFDI_CONCEPTO[i]:_CFDI_IMPUESTOS:_CFDI_TRASLADOS:_CFDI_TRASLADO,"_TASAOCUOTA")) = "O"
						nTasaImp	:= oXML:_CFDI_COMPROBANTE:_CFDI_CONCEPTOS:_CFDI_CONCEPTO[i]:_CFDI_IMPUESTOS:_CFDI_TRASLADOS:_CFDI_TRASLADO:_TASAOCUOTA:TEXT
					Else
						nTasaImp	:= "0.000000"
					Endif 
					IF VALTYPE(XmlChildex(oXML:_CFDI_COMPROBANTE:_CFDI_CONCEPTOS:_CFDI_CONCEPTO[i]:_CFDI_IMPUESTOS:_CFDI_TRASLADOS:_CFDI_TRASLADO,"_IMPORTE")) = "O"
					    cImporte	:= oXML:_CFDI_COMPROBANTE:_CFDI_CONCEPTOS:_CFDI_CONCEPTO[i]:_CFDI_IMPUESTOS:_CFDI_TRASLADOS:_CFDI_TRASLADO:_IMPORTE:TEXT
						nTotTras	 += Val(cImporte)
					Else 
						cImporte	:= "0.00"
					Endif
		
					oPrint:Say(nDetY,	0260, "BASE: "		 +Transform(Val(oXML:_CFDI_COMPROBANTE:_CFDI_CONCEPTOS:_CFDI_CONCEPTO[i]:_CFDI_IMPUESTOS:_CFDI_TRASLADOS:_CFDI_TRASLADO:_BASE:TEXT) ,"999,999.9999"),	oArial09)
			 		oPrint:Say(nDetY,	0615, "IMPUESTO: "	 +oXML:_CFDI_COMPROBANTE:_CFDI_CONCEPTOS:_CFDI_CONCEPTO[i]:_CFDI_IMPUESTOS:_CFDI_TRASLADOS:_CFDI_TRASLADO:_IMPUESTO:TEXT,	oArial09)
			 		oPrint:Say(nDetY,	1000, "TIPO FACTOR: "+oXML:_CFDI_COMPROBANTE:_CFDI_CONCEPTOS:_CFDI_CONCEPTO[i]:_CFDI_IMPUESTOS:_CFDI_TRASLADOS:_CFDI_TRASLADO:_TIPOFACTOR:TEXT,	oCouNew10) 
					oPrint:Say(nDetY,	1530, "Tasa o Cuota: " 	 +nTasaImp,	oCouNew10) 
					oPrint:Say(nDetY,	1900, "IMPORTE: "	 +Transform(Val(cImporte),"9,999,999.99"),	oCouNew10)		
					nFall++
					nDetY	:= nDetY+35
			Endif 	  
		Endif		//NO EXISTE NODO TRASLADOS
		
		//RETENCIONES
		IF XmlChildEx(oXML:_CFDI_COMPROBANTE:_CFDI_CONCEPTOS:_CFDI_CONCEPTO[i]:_CFDI_IMPUESTOS, "_CFDI_RETENCIONES" ) <> NIL
			if ( ValType(oXML:_CFDI_COMPROBANTE:_CFDI_CONCEPTOS:_CFDI_CONCEPTO[i]:_CFDI_IMPUESTOS:_CFDI_RETENCIONES:_CFDI_RETENCION) <> "O" )
				for r := 1 to Len(oXML:_CFDI_COMPROBANTE:_CFDI_CONCEPTOS:_CFDI_CONCEPTO[i]:_CFDI_IMPUESTOS:_CFDI_RETENCIONES:_CFDI_RETENCION) 
					cImpuesto	:= oXML:_CFDI_COMPROBANTE:_CFDI_CONCEPTOS:_CFDI_CONCEPTO[i]:_CFDI_IMPUESTOS:_CFDI_RETENCIONES:_CFDI_RETENCION[r]:_IMPUESTO:TEXT
					cTipoImp	:= oXML:_CFDI_COMPROBANTE:_CFDI_CONCEPTOS:_CFDI_CONCEPTO[i]:_CFDI_IMPUESTOS:_CFDI_RETENCIONES:_CFDI_RETENCION[r]:_TIPOFACTOR:TEXT
					nTasaImp	:= oXML:_CFDI_COMPROBANTE:_CFDI_CONCEPTOS:_CFDI_CONCEPTO[i]:_CFDI_IMPUESTOS:_CFDI_RETENCIONES:_CFDI_RETENCION[r]:_TASAOCUOTA:TEXT
					oPrint:Say(nDetY,	0260, "BASE: "		+Transform(Val(oXML:_CFDI_COMPROBANTE:_CFDI_CONCEPTOS:_CFDI_CONCEPTO[i]:_CFDI_IMPUESTOS:_CFDI_RETENCIONES:_CFDI_RETENCION[r]:_BASE:TEXT) ,"999,999.9999"),	oArial09)
			 		oPrint:Say(nDetY,	0615, "IMPUESTO: "	+cImpuesto,	oArial09)
			 		oPrint:Say(nDetY,	1000, "TIPO FACTOR:"+cTipoImp,	oCouNew10) 
					oPrint:Say(nDetY,	1530, "Tasa o Cuota: " 	+nTasaImp,	oCouNew10) 
					oPrint:Say(nDetY,	1900, "IMPORTE:"	+Transform(Val(oXML:_CFDI_COMPROBANTE:_CFDI_CONCEPTOS:_CFDI_CONCEPTO[i]:_CFDI_IMPUESTOS:_CFDI_RETENCIONES:_CFDI_RETENCION[r]:_IMPORTE:TEXT),"9,999,999.99"),	oCouNew10)		
					nTotRet	 +=Val(oXML:_CFDI_COMPROBANTE:_CFDI_CONCEPTOS:_CFDI_CONCEPTO[i]:_CFDI_IMPUESTOS:_CFDI_RETENCIONES:_CFDI_RETENCION[r]:_IMPORTE:TEXT) 
					nFall++
					nDetY	:= nDetY+35
				End for
			Else   
					cImpuesto	:= oXML:_CFDI_COMPROBANTE:_CFDI_CONCEPTOS:_CFDI_CONCEPTO[i]:_CFDI_IMPUESTOS:_CFDI_RETENCIONES:_CFDI_RETENCION:_IMPUESTO:TEXT
					cTipoImp	:= oXML:_CFDI_COMPROBANTE:_CFDI_CONCEPTOS:_CFDI_CONCEPTO[i]:_CFDI_IMPUESTOS:_CFDI_RETENCIONES:_CFDI_RETENCION:_TIPOFACTOR:TEXT
					nTasaImp	:= oXML:_CFDI_COMPROBANTE:_CFDI_CONCEPTOS:_CFDI_CONCEPTO[i]:_CFDI_IMPUESTOS:_CFDI_RETENCIONES:_CFDI_RETENCION:_TASAOCUOTA:TEXT
					oPrint:Say(nDetY,	0260, "BASE: "	   +Transform(Val(oXML:_CFDI_COMPROBANTE:_CFDI_CONCEPTOS:_CFDI_CONCEPTO[i]:_CFDI_IMPUESTOS:_CFDI_RETENCIONES:_CFDI_RETENCION:_BASE:TEXT) ,"999,999.9999"),	oArial09)
			 		oPrint:Say(nDetY,	0615, "IMPUESTO: " +oXML:_CFDI_COMPROBANTE:_CFDI_CONCEPTOS:_CFDI_CONCEPTO[i]:_CFDI_IMPUESTOS:_CFDI_RETENCIONES:_CFDI_RETENCION:_IMPUESTO:TEXT,	oArial09)
			 		oPrint:Say(nDetY,	1000, "TIPO FACTOR: "+oXML:_CFDI_COMPROBANTE:_CFDI_CONCEPTOS:_CFDI_CONCEPTO[i]:_CFDI_IMPUESTOS:_CFDI_RETENCIONES:_CFDI_RETENCION:_TIPOFACTOR:TEXT,	oCouNew10) 
					oPrint:Say(nDetY,	1530, "Tasa o Cuota: "  +nTasaImp,	oCouNew10) 
					oPrint:Say(nDetY,	1900, "IMPORTE: "  +Transform(Val(oXML:_CFDI_COMPROBANTE:_CFDI_CONCEPTOS:_CFDI_CONCEPTO[i]:_CFDI_IMPUESTOS:_CFDI_RETENCIONES:_CFDI_RETENCION:_IMPORTE:TEXT),"9,999,999.99"),	oCouNew10)		
					nTotRet	+= Val(oXML:_CFDI_COMPROBANTE:_CFDI_CONCEPTOS:_CFDI_CONCEPTO[i]:_CFDI_IMPUESTOS:_CFDI_RETENCIONES:_CFDI_RETENCION:_IMPORTE:TEXT)
					nFall++
					nDetY	:= nDetY+35
			Endif 	  
		Endif		//NO EXISTE NODO retenciones
		//FIN RETENCIONES		
	Endif			
Return nDetY



//Para ver si hay impuestos para Imprimirlos a Nivel Item cuando son varios Conceptos
Static Function ImpSat(oXML,nDetY) 
Local cCodImp	:= ""
Local nImpImp	:= 0
Local nTasaImp	:= 0.000000
Local cTipoImp	:= ""
Local cImpuesto	:= ""
Local nBase		:= 0
Local r := 1
	IF XmlChildEx(oXML:_CFDI_COMPROBANTE:_CFDI_CONCEPTOS:_CFDI_CONCEPTO,"_CFDI_IMPUESTOS" ) <> NIL  
		IF XmlChildEx(oXML:_CFDI_COMPROBANTE:_CFDI_CONCEPTOS:_CFDI_CONCEPTO:_CFDI_IMPUESTOS, "_CFDI_TRASLADOS" ) <> NIL
			if ( ValType(oXML:_CFDI_COMPROBANTE:_CFDI_CONCEPTOS:_CFDI_CONCEPTO:_CFDI_IMPUESTOS:_CFDI_TRASLADOS:_CFDI_TRASLADO) <> "O" )
				for r := 1 to Len(oXML:_CFDI_COMPROBANTE:_CFDI_CONCEPTOS:_CFDI_CONCEPTO:_CFDI_IMPUESTOS:_CFDI_TRASLADOS:_CFDI_TRASLADO) 
					cImpuesto	:= oXML:_CFDI_COMPROBANTE:_CFDI_CONCEPTOS:_CFDI_CONCEPTO:_CFDI_IMPUESTOS:_CFDI_TRASLADOS:_CFDI_TRASLADO[r]:_IMPUESTO:TEXT
					cTipoImp	:= oXML:_CFDI_COMPROBANTE:_CFDI_CONCEPTOS:_CFDI_CONCEPTO:_CFDI_IMPUESTOS:_CFDI_TRASLADOS:_CFDI_TRASLADO[r]:_TIPOFACTOR:TEXT
					
 //					nTasaImp	:= oXML:_CFDI_COMPROBANTE:_CFDI_CONCEPTOS:_CFDI_CONCEPTO:_CFDI_IMPUESTOS:_CFDI_TRASLADOS:_CFDI_TRASLADO[r]:_TASAOCUOTA:TEXT
					
					IF VALTYPE(XmlChildex(oXML:_CFDI_COMPROBANTE:_CFDI_CONCEPTOS:_CFDI_CONCEPTO:_CFDI_IMPUESTOS:_CFDI_TRASLADOS:_CFDI_TRASLADO[r],"_TASAOCUOTA")) = "O"
						nTasaImp	:= oXML:_CFDI_COMPROBANTE:_CFDI_CONCEPTOS:_CFDI_CONCEPTO:_CFDI_IMPUESTOS:_CFDI_TRASLADOS:_CFDI_TRASLADO[r]:_TASAOCUOTA:TEXT
					Else
						nTasaImp	:= "0.000000"
					Endif 
					IF VALTYPE(XmlChildex(oXML:_CFDI_COMPROBANTE:_CFDI_CONCEPTOS:_CFDI_CONCEPTO:_CFDI_IMPUESTOS:_CFDI_TRASLADOS:_CFDI_TRASLADO[r],"_IMPORTE")) = "O"
					    cImporte	 := oXML:_CFDI_COMPROBANTE:_CFDI_CONCEPTOS:_CFDI_CONCEPTO:_CFDI_IMPUESTOS:_CFDI_TRASLADOS:_CFDI_TRASLADO[r]:_IMPORTE:TEXT
						nTotTras	 += Val(oXML:_CFDI_COMPROBANTE:_CFDI_CONCEPTOS:_CFDI_CONCEPTO:_CFDI_IMPUESTOS:_CFDI_TRASLADOS:_CFDI_TRASLADO[r]:_IMPORTE:TEXT)
					Else 
						cImporte	:= "0.00"
					Endif					
  							
					oPrint:Say(nDetY,	0260, "BASE: "+Transform(Val(oXML:_CFDI_COMPROBANTE:_CFDI_CONCEPTOS:_CFDI_CONCEPTO:_CFDI_IMPUESTOS:_CFDI_TRASLADOS:_CFDI_TRASLADO[r]:_BASE:TEXT) ,"999,999.9999"),	oArial09)
			 		oPrint:Say(nDetY,	0615, "IMPUESTO: "+cImpuesto,	oArial09)
			 		oPrint:Say(nDetY,	1000, "TIPO FACTOR: "+cTipoImp,	oCouNew10) 
					oPrint:Say(nDetY,	1530, "Tasa o Cuota: " +nTasaImp,	oCouNew10) 
					oPrint:Say(nDetY,	1900, "IMPORTE: "+Transform(Val(cImporte),"9,999,999.99"),	oCouNew10)		
					nFall++
					nDetY	:= nDetY+35
				End for
			Else  
					cImpuesto	:= oXML:_CFDI_COMPROBANTE:_CFDI_CONCEPTOS:_CFDI_CONCEPTO:_CFDI_IMPUESTOS:_CFDI_TRASLADOS:_CFDI_TRASLADO:_IMPUESTO:TEXT
					cTipoImp	:= oXML:_CFDI_COMPROBANTE:_CFDI_CONCEPTOS:_CFDI_CONCEPTO:_CFDI_IMPUESTOS:_CFDI_TRASLADOS:_CFDI_TRASLADO:_TIPOFACTOR:TEXT 
 //					nTasaImp	:= oXML:_CFDI_COMPROBANTE:_CFDI_CONCEPTOS:_CFDI_CONCEPTO:_CFDI_IMPUESTOS:_CFDI_TRASLADOS:_CFDI_TRASLADO:_TASAOCUOTA:TEXT 

					IF VALTYPE(XmlChildex(oXML:_CFDI_COMPROBANTE:_CFDI_CONCEPTOS:_CFDI_CONCEPTO:_CFDI_IMPUESTOS:_CFDI_TRASLADOS:_CFDI_TRASLADO,"_TASAOCUOTA")) = "O"
						nTasaImp	:= oXML:_CFDI_COMPROBANTE:_CFDI_CONCEPTOS:_CFDI_CONCEPTO:_CFDI_IMPUESTOS:_CFDI_TRASLADOS:_CFDI_TRASLADO:_TASAOCUOTA:TEXT
					Else
						nTasaImp	:= "0.000000"
					Endif 
					IF VALTYPE(XmlChildex(oXML:_CFDI_COMPROBANTE:_CFDI_CONCEPTOS:_CFDI_CONCEPTO:_CFDI_IMPUESTOS:_CFDI_TRASLADOS:_CFDI_TRASLADO,"_IMPORTE")) = "O"
					    cImporte	:= oXML:_CFDI_COMPROBANTE:_CFDI_CONCEPTOS:_CFDI_CONCEPTO:_CFDI_IMPUESTOS:_CFDI_TRASLADOS:_CFDI_TRASLADO:_IMPORTE:TEXT
						nTotTras	+=	Val(oXML:_CFDI_COMPROBANTE:_CFDI_CONCEPTOS:_CFDI_CONCEPTO:_CFDI_IMPUESTOS:_CFDI_TRASLADOS:_CFDI_TRASLADO:_IMPORTE:TEXT)
					Else 
						cImporte	:= "0.00"
					Endif
										
					oPrint:Say(nDetY,	0260, "BASE: "+Transform(Val(oXML:_CFDI_COMPROBANTE:_CFDI_CONCEPTOS:_CFDI_CONCEPTO:_CFDI_IMPUESTOS:_CFDI_TRASLADOS:_CFDI_TRASLADO:_BASE:TEXT) ,"999,999.9999"),	oArial09)
			 		oPrint:Say(nDetY,	0615, "IMPUESTO: "+cImpuesto,	oArial09)
			 		oPrint:Say(nDetY,	1000, "TIPO FACTOR: "+cTipoImp,	oCouNew10) 
					oPrint:Say(nDetY,	1530, "Tasa o Cuota: " +nTasaImp,	oCouNew10) 
					oPrint:Say(nDetY,	1900, "IMPORTE: " +Transform(Val(cImporte),"9,999,999.99"),	oCouNew10)		 
					nFall++            
					nDetY	:= nDetY+35							 
			Endif   //
		Endif		//NO EXISTE NODO TRASLADOS
	Endif			
	
	//RETENCIONES
		IF XmlChildEx(oXML:_CFDI_COMPROBANTE:_CFDI_CONCEPTOS:_CFDI_CONCEPTO:_CFDI_IMPUESTOS, "_CFDI_RETENCIONES" ) <> NIL
			if ( ValType(oXML:_CFDI_COMPROBANTE:_CFDI_CONCEPTOS:_CFDI_CONCEPTO:_CFDI_IMPUESTOS:_CFDI_RETENCIONES:_CFDI_RETENCION) <> "O" )
				for r := 1 to Len(oXML:_CFDI_COMPROBANTE:_CFDI_CONCEPTOS:_CFDI_CONCEPTO:_CFDI_IMPUESTOS:_CFDI_RETENCIONES:_CFDI_RETENCION) 
//					LayImpuestos()
					cImpuesto	:= oXML:_CFDI_COMPROBANTE:_CFDI_CONCEPTOS:_CFDI_CONCEPTO:_CFDI_IMPUESTOS:_CFDI_RETENCIONES:_CFDI_RETENCION[r]:_IMPUESTO:TEXT
					cTipoImp	:= oXML:_CFDI_COMPROBANTE:_CFDI_CONCEPTOS:_CFDI_CONCEPTO:_CFDI_IMPUESTOS:_CFDI_RETENCIONES:_CFDI_RETENCION[r]:_TIPOFACTOR:TEXT
					nTasaImp	:= oXML:_CFDI_COMPROBANTE:_CFDI_CONCEPTOS:_CFDI_CONCEPTO:_CFDI_IMPUESTOS:_CFDI_RETENCIONES:_CFDI_RETENCION[r]:_TASAOCUOTA:TEXT
					oPrint:Say(nDetY,	0260,	Transform(Val(oXML:_CFDI_COMPROBANTE:_CFDI_CONCEPTOS:_CFDI_CONCEPTO:_CFDI_IMPUESTOS:_CFDI_RETENCIONES:_CFDI_RETENCION[r]:_BASE:TEXT) ,"999,999.9999"),	oArial09)
			 		oPrint:Say(nDetY,	0615,  cImpuesto,	oArial09)
			 		oPrint:Say(nDetY,	1000,  cTipoImp,	oCouNew10) 
					oPrint:Say(nDetY,	1530, nTasaImp,	oCouNew10) 
					oPrint:Say(nDetY,	1900, Transform(Val(oXML:_CFDI_COMPROBANTE:_CFDI_CONCEPTOS:_CFDI_CONCEPTO:_CFDI_IMPUESTOS:_CFDI_RETENCIONES:_CFDI_RETENCION[r]:_IMPORTE:TEXT),"9,999,999.99"),	oCouNew10)		
					nTotRet	+= Val(oXML:_CFDI_COMPROBANTE:_CFDI_CONCEPTOS:_CFDI_CONCEPTO:_CFDI_IMPUESTOS:_CFDI_RETENCIONES:_CFDI_RETENCION[r]:_IMPORTE:TEXT)
					nFall++            
					nDetY	:= nDetY+35
				End for
			Else  
//					LayImpuestos()
					cImpuesto	:= oXML:_CFDI_COMPROBANTE:_CFDI_CONCEPTOS:_CFDI_CONCEPTO:_CFDI_IMPUESTOS:_CFDI_RETENCIONES:_CFDI_RETENCION:_IMPUESTO:TEXT
					cTipoImp	:= oXML:_CFDI_COMPROBANTE:_CFDI_CONCEPTOS:_CFDI_CONCEPTO:_CFDI_IMPUESTOS:_CFDI_RETENCIONES:_CFDI_RETENCION:_TIPOFACTOR:TEXT
					nTasaImp	:= oXML:_CFDI_COMPROBANTE:_CFDI_CONCEPTOS:_CFDI_CONCEPTO:_CFDI_IMPUESTOS:_CFDI_RETENCIONES:_CFDI_RETENCION:_TASAOCUOTA:TEXT
					oPrint:Say(nDetY,	0260,	Transform(Val(oXML:_CFDI_COMPROBANTE:_CFDI_CONCEPTOS:_CFDI_CONCEPTO:_CFDI_IMPUESTOS:_CFDI_RETENCIONES:_CFDI_RETENCION:_BASE:TEXT) ,"999,999.9999"),	oArial09)
			 		oPrint:Say(nDetY,	0615,  cImpuesto,	oArial09)
			 		oPrint:Say(nDetY,	1000,  cTipoImp,	oCouNew10) 
					oPrint:Say(nDetY,	1530, nTasaImp,	oCouNew10) 
					oPrint:Say(nDetY,	1900, Transform(Val(oXML:_CFDI_COMPROBANTE:_CFDI_CONCEPTOS:_CFDI_CONCEPTO:_CFDI_IMPUESTOS:_CFDI_RETENCIONES:_CFDI_RETENCION:_IMPORTE:TEXT),"9,999,999.99"),oCouNew10)		
					nTotRet	+=  Val(oXML:_CFDI_COMPROBANTE:_CFDI_CONCEPTOS:_CFDI_CONCEPTO:_CFDI_IMPUESTOS:_CFDI_RETENCIONES:_CFDI_RETENCION:_IMPORTE:TEXT)
					nFall++            
					nDetY	:= nDetY+35
			Endif   //
		Endif		//NO EXISTE NODO RETENCIOS
	//FIN RETENCIONES	
Return  nDetY


User Function Descrip4(cTabla, cllave, nTamLlave, nTamCampo)
Local _aArea	:= GetArea() 
Local lEncontro	:= .F.
     DbSelectArea("F3I")
     DbSetOrder(1) 
     IF Dbseek(xFilial("F3I")+cTabla)
     	Do While !Eof() .and. F3I_CODIGO==cTabla  .and. !lEncontro
     		IF Substring(F3I->F3I_CONTEU,1,nTamLlave)==cLlave
     			cRetDesc	:=  Substring(F3I->F3I_CONTEU,nTamLlave+1,nTamCampo)
     			lEncontro	:= .T.	
     		Else
     			cRetDesc	:=  "CODIGO NO ENCONTRADO"
     		Endif
     		Dbskip()
     	EndDo
     Endif
RestArea(_aArea)
Return cRetDesc


Return


