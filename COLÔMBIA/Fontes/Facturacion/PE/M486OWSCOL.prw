#include 'protheus.ch'
#include 'parmtype.ch'
#include "FILEIO.CH"
#include "rwmake.ch"

/*/{Protheus.doc} M486OWSCOL
Punto de entrada para notificar del Productos de Obsequi, Importaciones y Campos especiales Fact Eletr Colombia
@type function
@version 
@author AxelDiaz
@since 17/11/2020
@return return_type, return_description       // MV_CFDIAMB, MV_WSRTSS , MV_TKN_EMP, MV_TKN_PAS
/*/ 
User Function M486OWSCOL
    Local cSerieDoc := PARAMIXB[1] //Serie
    Local cNumDoc   := PARAMIXB[2] //Número de Documento
    Local cCodCli   := PARAMIXB[3] //Código de Cliente
    Local cCodLoj   := PARAMIXB[4] //Código de la Tienda
    Local oXML      := PARAMIXB[5] //Objeto del XML
    Local nOpc      := PARAMIXB[6] //1=Nivel documento 2=Nivel detalle
    Local oWS       := PARAMIXB[7] //Objeto de web servicesdeve
 
    //Local nItem     := Val(oXML:_CBC_ID:TEXT)
    Local cCodProd  := ""
    Local cSDITem   := ""
    //Local cFilSD    := xFilial("SD2")
	//Local cFilSD1   := xFilial("SD1")
    
    Local nTotalNF  :=POSICIONE("SF2",2,XFILIAL("SF2")+cCodCli+cCodLoj+cNumDoc+cSerieDoc+'N'+'NF   ',"F2_VALBRUT")
    Local dVence    := dDatabase
    Local cVence    := ""
    Local lGratis   := .F.
	Local aCabDatos	:= {}
	Local aOrdCom	:= {}
	Local dORDC

    Local aEmail := {}
    Local oWSDest := Nil
    //Local oWSCta := Nil
    Local nX := 0
	Local cNFcc	:=	" " //:= SuperGetmv( "ST_NFCC" 	, .F. 	, " " )
	Local cAmbiente	:= SuperGetMV("MV_CFDIAMB"	,.F.	, "2" )
    //F2_FILIAL+F2_CLIENTE+F2_LOJA+F2_DOC+F2_SERIE+F2_TIPO+F2_ESPECIE 
	
	If AllTrim(cSerieDoc)=="NAJ" .Or. AllTrim(cSerieDoc)=="DCS"
		Return nil
	EndIf

    If nOpc == 1 //Encabezado

		// Posicionar cliente
		If cAmbiente<>'2'  // No es Demo  // Habilita el envio de Correos desde THE FACTORY
			SA1->(dbSetOrder(1))
			If SA1->(msSeek(xFilial("SA1")+cCodCli+cCodLoj)) 
				If !Empty(SA1->A1_EMAIL) // Como ejemplo se usa el campo A1_EMAIL (Comentarios de perfil)
					aEmail := StrTokArr(alltrim(SA1->A1_EMAIL), ",") // Las cuentas de correo están separadas por coma
					oWS:oWSCliente:cnotificar := "SI" // Indicar Sí notificar
					oWSDest := Service_Destinatario():NEW() // Crea objeto destinatario, el medio de entrega es 0=email
					oWSDest:ccanalDeEntrega := "0"
					oWSDest:oWSemail := Service_ArrayOfstring():NEW() // Crea arreglo de las cuentas de correo
					For nX := 1 to Len(aEmail)
						aAdd(oWSDest:oWSEmail:cstring, aEmail[nX])
					Next nX
					If !EMPTY(cNFcc) 
						aAdd(oWSDest:oWSEmail:cstring,cNFcc)
					EndIf
					oWS:oWSCliente:oWSDestinatario := Service_ArrayOfDestinatario():New()
					aAdd(oWS:oWSCliente:oWSDestinatario:oWSDestinatario, oWSDest) // Agrega destinatario al objeto principal
				EndIf
			EndIf
		EndIf
		aCabDatos :=CabDatos()

		IF (ALLTRIM(cEspecie)<>'NCC') 
			lGratis   := aCabDatos[1][14]=='O'  // La factura es de Obsequio ?
			If !lGratis  // No Obsequio
				// E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
				// Cliente + Tienda + Prefijo + Num. Titulo + Cuota + Tipo 
				cBuscaSE1:=xFilial("SE1")+ cCodCli + cCodLoj + cSerieDoc + cNumDoc+SPACE(TamSX3("E1_PARCELA")[1])+cEspecie             
				//
				dVence:=POSICIONE("SE1",2,cBuscaSE1,"E1_VENCTO")
				cVence:=dtos(dVence)

				IF !EMPTY(ALLTRIM(aCabDatos[1][12]))   // Direccion de entrega (SF2->F2_XENDENT)
					oWS:oWSentregaMercancia:=Service_Entrega():New()
					oWSdireccionEntrega:=Service_Direccion():New()
					oWSdireccionEntrega:cdireccion:=ALLTRIM(aCabDatos[1][12])
				ENDIF
				If !EMPTY(cVence)  // Fecha de Vencimiento del Titulo
					oWS:oWSMediosDePago:=Service_ArrayOfMediosDePago():New()
					oWSMediosPago:=Service_MediosDePago():New()
					oWSMediosPago:cfechaDeVencimiento:=LEFT(cVence,4)+"-"+SUBSTR(cVence,5,2)+"-"+RIGHT(cVence,2)
					oWSMediosPago:cmedioPago:="ZZZ"
					oWSMediosPago:cmetodoDePago:=IIF(ALLTRIM(aCabDatos[1][6])=='0','1','2') // "2"=Credito
					oWSMediosPago:cnumeroDeReferencia:='01' //alltrim(cSerieDoc)+"-"+ cValToChar(val(cNumDoc))//"01"
					aAdd(oWS:oWSMediosDePago:oWSMediosDePago,oWSMediosPago)
				else
					oWS:oWSMediosDePago:=Service_ArrayOfMediosDePago():New()
					oWSMediosPago:=Service_MediosDePago():New()
					//oWSMediosPago:cfechaDeVencimiento:=LEFT(cVence,4)+"-"+SUBSTR(cVence,5,2)+"-"+RIGHT(cVence,2)
					oWSMediosPago:cmedioPago:="ZZZ"
					oWSMediosPago:cmetodoDePago:=IF(ALLTRIM(aCabDatos[1][6])=='0','1','2') // "2"=Credito
					oWSMediosPago:cnumeroDeReferencia:='01' //alltrim(cSerieDoc)+"-"+ cValToChar(val(cNumDoc))//"01"
					aAdd(oWS:oWSMediosDePago:oWSMediosDePago,oWSMediosPago)
				ENDIF

				aOrdCom:=separa(aCabDatos[1][7],"/",.T.)
				IF !EMPTY(aOrdCom) .and. LEN(aOrdCom)==3  // ORDEN DE COMPRA
					If LEN(aOrdCom)==3 .AND. !EMPTY(STRTRAN(alltrim(aOrdCom[3]),"-",""))
						dORDC:=STOD(STRTRAN(alltrim(aOrdCom[3]),"-",""))
					EndIf
					oWS:oWSordenDeCompra:=Service_ArrayOfOrdenDeCompra():New()
					oWSOrdenDeCompra:=Service_OrdenDeCompra():New()
					If valtype(dORDC)=="D"
						dORDC:=DTOS(dORDC)
						oWSOrdenDeCompra:cfecha:=LEFT(dORDC,4)+"-"+SUBSTR(dORDC,5,2)+"-"+RIGHT(dORDC,2)+" 00:00:00"
					EndIf
					If LEN(aOrdCom)>1
						oWSOrdenDeCompra:cnumeroOrden:=IF(EMPTY(aOrdCom[2]),"S/N",aOrdCom[2])
					EndIf

					oWSOrdenDeCompra:cnumeroPedido:=ALLTRIM(IF(EMPTY(aCabDatos[1][8]),"NF Directa",aCabDatos[1][8]))
					oWSOrdenDeCompra:ccodigoCliente:=ALLTRIM(cCodCli)+"-"+ALLTRIM(cCodLoj)
					aAdd(oWS:oWSordenDeCompra:oWSordenDeCompra,oWSOrdenDeCompra) 
				ElseIf !EMPTY(aCabDatos[1][8])   // PEDIDO DE COMPRA SIN ORDEN DE COMPRA
					//D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM
					dFecPed:= DTOS(POSICIONE("SC5",1, XFILIAL("SC5")+aCabDatos[1][8],"C5_EMISSAO")) 

					oWS:oWSordenDeCompra:=Service_ArrayOfOrdenDeCompra():New()
					oWSOrdenDeCompra:=Service_OrdenDeCompra():New()
					oWSOrdenDeCompra:cfecha:=LEFT(dFecPed,4)+"-"+SUBSTR(dFecPed,5,2)+"-"+RIGHT(dFecPed,2)+" 00:00:00"
					oWSOrdenDeCompra:cnumeroPedido:=ALLTRIM(IF(EMPTY(aCabDatos[1][8]),"NF Directa",aCabDatos[1][8]))
					oWSOrdenDeCompra:ccodigoCliente:=ALLTRIM(cCodCli)+"-"+ALLTRIM(cCodLoj)
					oWSOrdenDeCompra:cnumeroOrden:=IF(LEN(aOrdCom)==1 /*/.OR. EMPTY(aOrdCom[2])/*/,"S/N",aOrdCom[2])
					aAdd(oWS:oWSordenDeCompra:oWSordenDeCompra,oWSOrdenDeCompra) 
				EndIf
								
				IF !EMPTY(aCabDatos[1][9])  // oBSERVACIONES
					oWS:oWSinformacionAdicional:=Service_ArrayOfstring():New()
					aAdd(oWS:oWSinformacionAdicional:cstring, aCabDatos[1][9])
					IF aCabDatos[1][14] $ "ExB"  // Exportacion o Back to Back
						aAdd(oWS:oWSinformacionAdicional:cstring, "Incoterms: "+aCabDatos[1][13]+" - "+IncoST(aCabDatos[1][13]) )
						OWS:oWSextras := Service_ArrayOfExtras():NEW()
					EndIf
				Elseif aCabDatos[1][14] $ "ExB"
					oWS:oWSinformacionAdicional:=Service_ArrayOfstring():New()
					aAdd(oWS:oWSinformacionAdicional:cstring, "Incoterms: "+aCabDatos[1][13]+" - "+IncoST(aCabDatos[1][13]) )
					OWS:oWSextras := Service_ArrayOfExtras():NEW()
				ENDIF


				/*/
				//Clase oWSterminosEntrega
				IF aCabDatos[1][14] $ "ExB"
					oWS:oWSterminosEntrega := Service_TerminosDeEntrega():New() 
					oWs:oWSterminosEntrega:ccodigoCondicionEntrega:= aCabDatos[1][13]
				ENDiF
				/*/
			Else //Obsequio
					If ALLTRIM(cEspecie)=='NF'
						oWS:oWSinformacionAdicional:=Service_ArrayOfstring():New()
						aAdd(oWS:oWSinformacionAdicional:cstring, "Producto(s) de Obsequio(s)")	
					EndIf
					oWS:oWSMediosDePago:=Service_ArrayOfMediosDePago():New()
					oWSMediosPago:=Service_MediosDePago():New()
					oWSMediosPago:cmedioPago:="ZZZ"
					oWSMediosPago:cmetodoDePago:="1" // Contado
					oWSMediosPago:cnumeroDeReferencia:='01' //alltrim(cSerieDoc)+"-"+ cValToChar(val(cNumDoc))//"01"
					aAdd(oWS:oWSMediosDePago:oWSMediosDePago,oWSMediosPago) 
			EndIf
		ElseIf AllTrim(aCabDatos[1][17])=="DCS"
			lGratis   := aCabDatos[1][14]=='O'  // La factura es de Obsequio ?
			If !lGratis  // No Obsequio
				
				cVence := ""

				DbSelectArea("SE2")
				SE2->(DbSetOrder(1))
				If SE2->(DbSeek(xFilial("SE2")+ AllTrim(aCabDatos[1][17]) + cNumDoc + SPACE(TamSX3("E2_PARCELA")[1]) + PADR(AllTrim(aCabDatos[1][16]),3) + cCodCli + cCodLoj))
					cVence := DTOS(SE2->E2_VENCTO)
				Else
					cVence := ""
				EndIf

				If !EMPTY(cVence)  // Fecha de Vencimiento del Titulo
					oWS:oWSMediosDePago:=Service_ArrayOfMediosDePago():New()
					oWSMediosPago:=Service_MediosDePago():New()
					oWSMediosPago:cfechaDeVencimiento:=LEFT(cVence,4)+"-"+SUBSTR(cVence,5,2)+"-"+RIGHT(cVence,2)
					oWSMediosPago:cmedioPago:="ZZZ"
					oWSMediosPago:cmetodoDePago:=IIF(ALLTRIM(aCabDatos[1][6])=='0','1','2') // "2"=Credito
					oWSMediosPago:cnumeroDeReferencia:='01' //alltrim(cSerieDoc)+"-"+ cValToChar(val(cNumDoc))//"01"
					aAdd(oWS:oWSMediosDePago:oWSMediosDePago,oWSMediosPago)
				else
					oWS:oWSMediosDePago:=Service_ArrayOfMediosDePago():New()
					oWSMediosPago:=Service_MediosDePago():New()
					//oWSMediosPago:cfechaDeVencimiento:=LEFT(cVence,4)+"-"+SUBSTR(cVence,5,2)+"-"+RIGHT(cVence,2)
					oWSMediosPago:cmedioPago:="ZZZ"
					oWSMediosPago:cmetodoDePago:=IF(ALLTRIM(aCabDatos[1][6])=='0','1','2') // "2"=Credito
					oWSMediosPago:cnumeroDeReferencia:='01' //alltrim(cSerieDoc)+"-"+ cValToChar(val(cNumDoc))//"01"
					aAdd(oWS:oWSMediosDePago:oWSMediosDePago,oWSMediosPago)
				ENDIF
			EndIf
		ELSE  // NCC
			IF !EMPTY(aCabDatos[1][9])  // oBSERVACIONES
				oWS:oWSinformacionAdicional:=Service_ArrayOfstring():New()
				aAdd(oWS:oWSinformacionAdicional:cstring, aCabDatos[1][9])
				IF aCabDatos[1][14] $ "ExB"  // Exportacion o Back to Back
					aAdd(oWS:oWSinformacionAdicional:cstring, "Incoterms: "+aCabDatos[1][13]+" - "+IncoST(aCabDatos[1][13]))
				EndIF
			ElseIf aCabDatos[1][14] $ "ExB"
				oWS:oWSinformacionAdicional:=Service_ArrayOfstring():New()
				aAdd(oWS:oWSinformacionAdicional:cstring, "Incoterms: "+aCabDatos[1][13]+" - "+IncoST(aCabDatos[1][13]))
			ENDIF

			IF aCabDatos[1][15] == '22'
				oWS:oWSDocumentosReferenciados := Service_ArrayOfDocumentoReferenciado():NEW()
			ENDif
		ENDIF

    ElseIf nOpc == 2 //Detalle del documento
		aCabDatos :=CabDatos()
		
		IF (ALLTRIM(aCabDatos[1][16])=='NCC') 
			cCodProd := Padr(oXML:_CAC_ITEM:_CAC_SELLERSITEMIDENTIFICATION:_CBC_ID:TEXT,TamSX3("D1_COD")[1],' ')
			cSDITem := Padl(oXML:_CBC_ID:TEXT,TamSX3("D1_ITEM")[1],'0')
			dbSelectArea("SD1")
			SD1->(dbSetOrder(1)) //D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM
		EndIf
		
		IF (ALLTRIM(aCabDatos[1][16])=='NF' /*/.OR. ALLTRIM(cEspecie)=='NDC'/*/) 
			cCodProd := Padr(oXML:_FE_ITEM:_CAC_SELLERSITEMIDENTIFICATION:_CBC_ID:TEXT,TamSX3("D2_COD")[1],' ')
			cSDITem := Padl(oXML:_CBC_ID:TEXT,TamSX3("D2_ITEM")[1],'0')
			
			dbSelectArea("SD2")
			SD2->(dbSetOrder(3)) //D2_FILIAL + D2_DOC + D2_SERIE + D2_CLIENTE + D2_LOJA + D2_COD + D2_ITEM

			IF lGratis
				oWS:cmuestragratis      := "1"
				oWS:cprecioreferencia   := formatValEnv(SD2->D2_TOTAL,2)
				oWS:cprecioTotalSinImpuestos    := formatValEnv(0,2)
				oWS:cprecioTotal        := formatValEnv(0,2)
				oWS:csecuencia          := "1"
				oWs:cPrecioventaunitario:= formatValEnv(0,2) 
			EndIf

		EndIf
    EndIf
    IF lGratis
        oWS:oWScargosDescuentos     := Service_ArrayOfCargosDescuentos():New()
        oWSDesDtl                   := Service_CargosDescuentos():NEW()
        oWSDesDtl:ccodigo           := "00"
        oWSDesDtl:cdescripcion      := "Descuento TOTAL de la Factura (impuesto asumido)"
        oWSDesDtl:cindicador        := "0"
        oWSDesDtl:cmonto            := formatValEnv(nTotalNF,2)
        oWSDesDtl:cmontoBase        := formatValEnv(nTotalNF,2)
        oWSDesDtl:cporcentaje       := formatValEnv(99.99,2)
        oWSDesDtl:csecuencia        := "1"
        aAdd(oWS:oWScargosDescuentos:oWScargosDescuentos,oWSDesDtl) 
        Ows:ctotalDescuentos        := formatValEnv(nTotalNF,2)
        oWs:ctotalMonto             := cValToChar(0.00)//(nTotalFc+nDescTtal)-nDescTtal)
    ENDiF 
Return Nil

Static Function formatValEnv(nValFormat,tpformat)
    Local cValformatado     := " "
    DEFAULT nValFormat := 0

    cValformatado   := transform(nValFormat,"@E 999,999,999,999.99") 
    cValformatado   := STRTRAN(cValformatado, ".", ";")
    cValformatado   := STRTRAN(cValformatado, ",", ".")
    If tpformat = 1
        cValformatado   := STRTRAN(cValformatado, ";", ",")
    Else
        cValformatado   := STRTRAN(cValformatado, ";", "")
    EndIf
    cValformatado := Alltrim(cValformatado)
Return cValformatado

// funcion que rescata datos necesario para la factura , ncc y ndc en un array
Static function	CabDatos
    Local cSerieDoc := PARAMIXB[1] //Serie
    Local cNumDoc   := PARAMIXB[2] //Número de Documento
    Local cCodCli   := PARAMIXB[3] //Código de Cliente
    Local cCodLoj   := PARAMIXB[4] //Código de la Tienda
    //Local oXML      := PARAMIXB[5] //Objeto del XML
    //Local nOpc      := PARAMIXB[6] //1=Nivel documento 2=Nivel detalle
    //Local oWS       := PARAMIXB[7] //Objeto de web services
	//Local cQry		:=''
	//Local cAliQry1 := GetNextAlias()
	//Local cAliQry2 := GetNextAlias()
	Local aCabDatos	:= {}
	Local cPedido,nCantD2,nPeso
	If (ALLTRIM(cEspecie)=='NF' .OR. ALLTRIM(cEspecie)=='NDC')

		dbSelectArea("SF2")
		dbSelectArea("SD2")
		dbSelectArea("SE4")

		SF2->(dbSetOrder(2))  // F2_FILIAL+F2_CLIENTE+F2_LOJA+F2_DOC+F2_SERIE+F2_TIPO+F2_ESPECIE 
		SD2->(dbSetOrder(3))  // D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM 
		SE4->(dbSetOrder(1))  // E4_FILIAL+E4_CODIGO  

		SF2->(dbSeek(xFilial("SF2")+cCodCli+cCodLoj+cNumDoc+cSerieDoc+"N"+cEspecie))
		SD2->(dbSeek(xFilial("SD2")+cNumDoc+cSerieDoc+cCodCli+cCodLoj))
		SE4->(dbSeek(xFilial("SE4")+SF2->F2_COND))

		cPedido:=SD2->D2_PEDIDO
		nCantD2:=0
		nPeso:=0
		While  SD2->(!Eof()) .AND. SD2->D2_PEDIDO==cPedido
			nCantD2+=SD2->D2_QUANT
			nPeso+=SD2->D2_PESO
			SD2->(dbSkip())
		Enddo

		aAdd(aCabDatos,{ SF2->F2_COND,;  		//1
						 SF2->F2_VALBRUT,;		//2
						 SF2->F2_BASIMP1,;		//3
						 SF2->F2_VALIMP1,;		//4
						 SF2->F2_BASIMP1+SF2->F2_VALIMP1,;			//5
						 SE4->E4_COND,;			//6
						 IF(EMPTY(Alltrim(SF2->F2_UUIDREL))," ",Alltrim(SF2->F2_UUIDREL)),;		//7
						 cPedido,;				//8
						 SF2->F2_XOBS,; 		//9
						 nCantD2,;				//10
						 nPeso,;				//11
						 SF2->F2_XENDENT,;		//12
						 SF2->F2_INCOTER,;		//13
						 SF2->F2_XTPED,;		//14
						 " ",;					//15
						 SF2->F2_ESPECIE,;      //16
						 SF2->F2_SERIE;		//17			
						 })
						 

		SF2->(DbCloseArea())
		SD2->(DbCloseArea())
		SE4->(DbCloseArea())
		Return aCabDatos

	else

		dbSelectArea("SF1")
		dbSelectArea("SD1")
		dbSelectArea("SE4")

		SF1->(dbSetOrder(1))  //F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_TIPO 
		SD1->(dbSetOrder(1))  //D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM   
		SE4->(dbSetOrder(1))  //E4_FILIAL+E4_CODIGO  

		SF1->(dbSeek(xFilial("SF1")+cNumDoc+cSerieDoc+cCodCli+cCodLoj))
		SD1->(dbSeek(xFilial("SD1")+cNumDoc+cSerieDoc+cCodCli+cCodLoj))
		SE4->(dbSeek(xFilial("SE4")+SF1->F1_COND))

		cPedido:=""
		nCantD2:=0
		nPeso:=0
		While  SD1->(!Eof()) .AND. xFilial("SD1")+SD1->D1_FILIAL+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA==xFilial("SD1")+cNumDoc+cSerieDoc+cCodCli+cCodLoj
			nCantD2+=SD1->D1_QUANT
			SD1->(dbSkip())
		Enddo
		aAdd(aCabDatos,{ SF1->F1_COND,;  	//1
					SF1->F1_VALBRUT,;		//2
					SF1->F1_BASIMP1,;		//3
					SF1->F1_VALIMP1,;		//4
					SF1->F1_BASIMP1+SF1->F1_VALIMP1,;			//5
					SE4->E4_COND,;			//6
					" ",;					//7
					" ",;					//8
					SF1->F1_MOTIVO,; 		//9
					nCantD2,;				//10
					nPeso,;					//11
					" ",;					//12
					SF1->F1_INCOTER,;		//13
					SF1->F1_XTPED,;			//14 
					ALLTRIM(SF1->F1_TIPOPE),; //15
					SF1->F1_ESPECIE,;         //16
					SF1->F1_SERIE;			//17
					})		

		SF2->(DbCloseArea())
		SD2->(DbCloseArea())
		SE4->(DbCloseArea())
		Return aCabDatos

	EndIf

Return aCabDatos
/*/{Protheus.doc} IncoST
funcion que devuelve la Descripción del Incoterms
@type function
@version  
@author AxelDiaz
@since 25/5/2021
@param cInco, character, param_description
@return return_type, return_description
/*/
Static function IncoST(cInco)
	Local cRet := ""
	DbSelectArea("F3I")
	F3I->(dbSetOrder(1))
	F3I->(dbSeek(xFilial("F3I")+"S01100001"))
	Do While F3I->(!Eof()) .and. F3I->F3I_CODIGO='S011'
		IF SUBSTR(F3I_CONTEU,1,3)==cInco
			cRet:= alltrim(SUBSTR(F3I_CONTEU,4,150))
			F3I->(DbCloseArea())
			return cRet
		EndIf
		F3I->(dbSkip())
	EndDo
Return cRet 




// EJEMPLO DE IVA ASUMIDO
/*/
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/" xmlns:arr="http://schemas.microsoft.com/2003/10/Serialization/Arrays">
	<soapenv:Header/>
	<soapenv:Body>
		<tem:Enviar>
			<tem:tokenEmpresa>b2b12cafe6f516330e05f7c7b3b1f6b055f30a74</tem:tokenEmpresa>
			<tem:tokenPassword>3751074bb5ec0dee97b98b9b487975e1543ac7d4</tem:tokenPassword>
			<tem:factura xmlns="http://schemas.datacontract.org/2004/07/ServiceSoap.UBL2._0.Models.Object">
				<cantidadDecimales>2</cantidadDecimales>
				<cargosDescuentos>
					<CargosDescuentos>
						<codigo>00</codigo>
						<descripcion>Descuento por impuesto asumido</descripcion>
						<indicador>0</indicador>
						<monto>381.14</monto>
						<montoBase>381.14</montoBase>
						<porcentaje>99.99</porcentaje>
						<secuencia>1</secuencia>
					</CargosDescuentos>
				</cargosDescuentos>
				<cliente>
					<destinatario>
						<Destinatario>
							<canalDeEntrega>0</canalDeEntrega>
							<email>
								<arr:string>email@thefactoryhka.com</arr:string>
							</email>
							<fechaProgramada>2019-06-01 00:00:00</fechaProgramada>
							<nitProveedorReceptor>1</nitProveedorReceptor>
							<telefono>123456789</telefono>
						</Destinatario>
					</destinatario>
					<detallesTributarios>
						<Tributos>
							<codigoImpuesto>01</codigoImpuesto>
						</Tributos>
					</detallesTributarios>
					<direccionCliente>
						<ciudad>MANIZALES</ciudad>
						<codigoDepartamento>11</codigoDepartamento>
						<departamento>Bogotá</departamento>
						<direccion>Direccion</direccion>
						<lenguaje>es</lenguaje>
						<municipio>11001</municipio>
						<pais>CO</pais>
						<zonaPostal>110211</zonaPostal>
					</direccionCliente>
					<direccionFiscal>
						<ciudad>MANIZALES</ciudad>
						<codigoDepartamento>11</codigoDepartamento>
						<departamento>Bogotá</departamento>
						<direccion>Direccion</direccion>
						<lenguaje>es</lenguaje>
						<municipio>11001</municipio>
						<pais>CO</pais>
						<zonaPostal>110211</zonaPostal>
					</direccionFiscal>
					<email>email@thefactoryhka.com</email>
					<informacionLegalCliente>
						<codigoEstablecimiento>00001</codigoEstablecimiento>
						<nombreRegistroRUT>CONSORCIO ALIANZA SAN CRISTOBAL 4</nombreRegistroRUT>
						<numeroIdentificacion>901041710</numeroIdentificacion>
						<numeroIdentificacionDV>5</numeroIdentificacionDV>
						<tipoIdentificacion>31</tipoIdentificacion>
					</informacionLegalCliente>
					<nombreRazonSocial>The Factory HKA Colombia</nombreRazonSocial>
					<notificar>SI</notificar>
					<numeroDocumento>901041710</numeroDocumento>
					<numeroIdentificacionDV>5</numeroIdentificacionDV>
					<responsabilidadesRut>
						<Obligaciones>
							<obligaciones>O-14</obligaciones>
							<regimen>04</regimen>
						</Obligaciones>
					</responsabilidadesRut>
					<tipoIdentificacion>31</tipoIdentificacion>
					<tipoPersona>1</tipoPersona>
				</cliente>
				<consecutivoDocumento>CONSECUTIVO</consecutivoDocumento>
				<detalleDeFactura>
					<FacturaDetalle>
						<cantidadPorEmpaque>1</cantidadPorEmpaque>
						<cantidadReal>1.00</cantidadReal>
						<cantidadRealUnidadMedida>WSD</cantidadRealUnidadMedida>
						<cantidadUnidades>2.00</cantidadUnidades>
						<codigoProducto>P000001</codigoProducto>
						<codigoTipoPrecio>01</codigoTipoPrecio>
						<descripcion>Impresora HKA80</descripcion>
						<descripcionTecnica>Impresora térmica de punto de venta, ideal para puntos de venta con alto rendimiento</descripcionTecnica>
						<estandarCodigo>999</estandarCodigo>
						<estandarCodigoProducto>PHKA80</estandarCodigoProducto>
						<impuestosDetalles>
							<FacturaImpuestos>
								<baseImponibleTOTALImp>2006.00</baseImponibleTOTALImp>
								<codigoTOTALImp>01</codigoTOTALImp>
								<porcentajeTOTALImp>19.00</porcentajeTOTALImp>
								<unidadMedida>WSD</unidadMedida>
								<unidadMedidaTributo/>
								<valorTOTALImp>381.14</valorTOTALImp>
								<valorTributoUnidad/>
							</FacturaImpuestos>
						</impuestosDetalles>
						<impuestosTotales>
							<ImpuestosTotales>
								<codigoTOTALImp>01</codigoTOTALImp>
								<montoTotal>381.14</montoTotal>
							</ImpuestosTotales>
						</impuestosTotales>
						<marca>HKA</marca>
						<muestraGratis>1</muestraGratis>
						<precioReferencia>1003.00</precioReferencia>
						<precioTotal>0.00</precioTotal>
						<precioTotalSinImpuestos>0.00</precioTotalSinImpuestos>
						<precioVentaUnitario>1003.00</precioVentaUnitario>
						<secuencia>1</secuencia>
						<unidadMedida>WSD</unidadMedida>
					</FacturaDetalle>
				</detalleDeFactura>
				<fechaEmision>2019-12-17 00:00:00</fechaEmision>
				<impuestosGenerales>
					<FacturaImpuestos>
						<baseImponibleTOTALImp>2006.00</baseImponibleTOTALImp>
						<codigoTOTALImp>01</codigoTOTALImp>
						<porcentajeTOTALImp>19.00</porcentajeTOTALImp>
						<unidadMedida>WSD</unidadMedida>
						<unidadMedidaTributo/>
						<valorTOTALImp>381.14</valorTOTALImp>
						<valorTributoUnidad/>
					</FacturaImpuestos>
				</impuestosGenerales>
				<impuestosTotales>
					<ImpuestosTotales>
						<codigoTOTALImp>01</codigoTOTALImp>
						<montoTotal>381.14</montoTotal>
					</ImpuestosTotales>
				</impuestosTotales>
				<informacionAdicional>
					<arr:string>El total de la Factura a cobrar corresponde a los items registrado sin considerar la muestra gratis</arr:string>
				</informacionAdicional>
				<mediosDePago>
					<MediosDePago>
						<fechaDeVencimiento>2019-10-15</fechaDeVencimiento>
						<medioPago>10</medioPago>
						<metodoDePago>2</metodoDePago>
						<numeroDeReferencia>01</numeroDeReferencia>
					</MediosDePago>
				</mediosDePago>
				<moneda>COP</moneda>
				<rangoNumeracion>PREFIJO-CAMPODESDE</rangoNumeracion>
				<redondeoAplicado>0.00</redondeoAplicado>
				<tipoDocumento>01</tipoDocumento>
				<tipoOperacion>10</tipoOperacion>
				<totalBaseImponible>2006.00</totalBaseImponible>
				<totalBrutoConImpuesto>381.14</totalBrutoConImpuesto>
				<totalDescuentos>381.14</totalDescuentos>
				<totalMonto>0.00</totalMonto>
				<totalProductos>1</totalProductos>
				<totalSinImpuestos>0.00</totalSinImpuestos>
			</tem:factura>
			<tem:adjuntos>0</tem:adjuntos>
		</tem:Enviar>
	</soapenv:Body>
</soapenv:Envelope>
/*/
