#Include "Rwmake.ch"
#Include "Topconn.ch"
#Include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CTBI001     ºAutor  ³Jorge Mendoza       ºFecha ³  25/01/07 º±±
±±º                       ºValid  ³Karlo Zumaya        ºFecha ³  11/03/09 º±±
±±º                       ºModif  ³Wheelock Orozco     ºFecha ³  06/07/09 º±±
±±º                       ºValid  ³Karlo Zumaya        ºFecha ³  10/07/09 º±±
±±º                       ºModif  ³Eloisa Jimenez      ºFecha ³  12/06/14 º±±
±±º                       ºModif  ³EDUAR ANDIA         ºFecha ³  19/07/16 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Reporte para impresión de comprobantes contables.          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CTBI001(lband,nTipo)
	Private cPerg	:= "CTBIMPPOL"
	Default nTipo 	:= 1
//Default	lband	:= .T.
	Private nTpSld  := nTipo
	Private cDesTp	:= Posicione("SX5",1,xFilial("SX5")+"SL"+AllTrim(Str(nTpSld)),"X5_DESCRI")
	Private lRut	:= lband
	Private DctoIni,DctoFin,LotIni,LotFin,SbLot,SubLt,dataIn,dataFin

	If lband==NIL
		Private lRut:=.F.
		Private lRut:=.F.
	Else
		Private lRut:=.T.
		Private lRut:=.T.
	Endif


	If !lband
		AjustaSX1(cPerg)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Imprimir relatorio desde Botão Imprimir no PE - MT462MNU     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If Upper(Funname()) == "MATA101N"

			dataIn	:= CTOD("")
			dataFin	:= CTOD("")
			LotIni	:= ""
			LotFin	:= ""
			SbLot	:= ""
			SubLt	:= ""
			DctoIni	:= ""
			DctoFin	:= ""
			TipMon	:= "1"	//--- Tipo de Moneda
			cNomEmp := Posicione("SM0",1,CEMPANT+CFILANT,"M0_NOMECOM")
			cNIT    := Posicione("SM0",1,CEMPANT+CFILANT,"M0_CGC")

			Pergunte(cPerg,.F.)
			BuscaCT2(@dataIn,@dataFin,@LotIni,@LotFin,@SbLot,@SubLt,@DctoIni,@DctoFin)
			If !Empty(DctoIni)
				Processa({ |lEnd| xPrintRel(),OemToAnsi('Generando el Reporte !!!')}, OemToAnsi('Espere un Momento Por Favor...'))
			Else
				Aviso("Comprobante Contable","No se encontró el comprobante contable para la Factura - " + SF1->F1_DOC + "/" + SF1->F1_SERIE,{"OK"})
			Endif

			Return
		Endif

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Imprimir relatorio desde Botão Imprimir Asto.Contab.Auto     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If UPPER(Funname()) == "CTBA102"
			Pergunte(cPerg,.F.)
			DctoIni	:= CT2->CT2_DOC   			//--- Numero de Documento inicial
			DctoFin := CT2->CT2_DOC				//--- Numero de Documento Final
			LotIni  := CT2->CT2_LOTE			//--- Lote Inicial
			LotFin  := CT2->CT2_LOTE			//--- Lote final
			SbLot  	:= ALLTRIM(CT2->CT2_SBLOTE)	//ALLTRIM(TRANSFORM(mv_par05,"@R 9"))
			SubLt  	:= ALLTRIM(CT2->CT2_SBLOTE)
			dataIn	:= CT2->CT2_DATA			//--- Fecha Inicial
			dataFin := CT2->CT2_DATA			//--- Fecha Final
			TipMon	:= AllTrim(Str(nTpSld))		//--- Tipo de Saldo
			cNomEmp := POSICIONE("SM0",1,CEMPANT+CFILANT,"M0_NOMECOM")
			cNIT    := POSICIONE("SM0",1,CEMPANT+CFILANT,"M0_CGC")
		Else
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Imprimir desde Menu - Digitar Parámetros     				 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If ( !Pergunte(cPerg,.T.) )
				Return

			Else

				DctoIni	:= mv_par01   			//--- Numero de Documento inicial
				DctoFin := mv_par02				//--- Numero de Documento Final
				LotIni  := ALLTRIM(mv_par03)	//--- Lote Inicial
				LotFin  := ALLTRIM(mv_par04)	//--- Lote final
				SbLot  	:= ALLTRIM(mv_par05)	//ALLTRIM(TRANSFORM(mv_par05,"@R 9"))
				SubLt  	:= ALLTRIM(mv_par05)
				dataIn	:= mv_par06				//--- Fecha Inicial
				dataFin := mv_par07				//--- Fecha Final
				nTpSld  := val(mv_par08)
				//	TipMon	:= mv_par08				//--- Tipo de Moneda
				cNomEmp := POSICIONE("SM0",1,CEMPANT+CFILANT,"M0_NOMECOM") 	//M0_NOMECOM) + " " + ALLTRIM(SM0->M0_CGC
				cNIT    := POSICIONE("SM0",1,CEMPANT+CFILANT,"M0_CGC") 		//M0_NOMECOM) + " " + ALLTRIM(SM0->M0_CGC
				cDesTp	:= Posicione("SX5",1,xFilial("SX5")+"SL"+AllTrim(Str(nTpSld)),"X5_DESCRI")
			Endif
		Endif
		Processa({ |lEnd| xPrintRel(),OemToAnsi('Generando el Reporte !!!')}, OemToAnsi('Espere un Momento Por Favor...'))
	Else
		IF IsInCallStack("U_CTB105OUTM") //Ejecución antes de grabar CT2
			DctoIni  	:=  PARAMIXB[4]   		//--- Numero de Documento inicial
			DctoFin  	:=  PARAMIXB[4]			//--- Numero de Documento Final
			LotIni      :=  PARAMIXB[2]         //--- Lote inicia
			LotFin      :=  PARAMIXB[2]         //--- Lote final
			SbLot  		:=  PARAMIXB[3]         //--- Sublote inicial
			SbLot  		:=  PARAMIXB[3]         //--- Sublote final
			dataIn		:= 	dtos(PARAMIXB[1]) 	//--- Fecha Inicial
			dataFin 	:=  PARAMIXB[1] 		//--- Fecha Final
			cNomEmp   	:= POSICIONE("SM0",1,CEMPANT+CFILANT,"M0_NOMECOM") 	//M0_NOMECOM) + " " + ALLTRIM(SM0->M0_CGC
			cNIT      	:= POSICIONE("SM0",1,CEMPANT+CFILANT,"M0_CGC") 		//M0_NOMECOM) + " " + ALLTRIM(SM0->M0_CGC

		Elseif IsInCallStack("U_DEPCTBGRV")//Ejecucion despues de grabar CT2

			dataIn		:= 	dtos(PARAMIXB[2]) 	//--- Fecha Inicial
			dataFin 	:=  PARAMIXB[2] 		//--- Fecha Final
			LotIni      :=  PARAMIXB[3]         //--- Lote Inicial
			LotFin      :=  PARAMIXB[3]         //--- Lote Final
			SbLot  		:=  PARAMIXB[4]         //--- Sublote Inicial
			SbLot  		:=  PARAMIXB[4]         //--- Sublote final
			DctoIni  	:=  PARAMIXB[5]   		//--- Numero de Documento inicial
			DctoFin  	:=  PARAMIXB[5]			//--- Numero de Documento Final
			cNomEmp   	:= POSICIONE("SM0",1,CEMPANT+CFILANT,"M0_NOMECOM") 	//M0_NOMECOM) + " " + ALLTRIM(SM0->M0_CGC
			cNIT      	:= POSICIONE("SM0",1,CEMPANT+CFILANT,"M0_CGC") 		//M0_NOMECOM) + " " + ALLTRIM(SM0->M0_CGC  */

		Elseif IsInCallStack("U_CT102BUT")	//Ejecucion

			dataIn		:= DTOS(CT2->CT2_DATA)	//--- Fecha Inicial
			dataFin 	:= DTOS(CT2->CT2_DATA) 	//--- Fecha Final
			LotIni      := CT2->CT2_LOTE        //--- Lote Inicial
			LotFin      := CT2->CT2_LOTE        //--- Lote Final
			SbLot  		:= CT2->CT2_SBLOTE      //--- Sublote Inicial
			SbLot  		:= CT2->CT2_SBLOTE      //--- Sublote final
			DctoIni  	:= CT2->CT2_DOC   		//--- Numero de Documento inicial
			DctoFin  	:= CT2->CT2_DOC 		//--- Numero de Documento Final
			cNomEmp   	:= POSICIONE("SM0",1,CEMPANT+CFILANT,"M0_NOMECOM") 	//M0_NOMECOM) + " " + ALLTRIM(SM0->M0_CGC
			cNIT      	:= POSICIONE("SM0",1,CEMPANT+CFILANT,"M0_CGC") 		//M0_NOMECOM) + " " + ALLTRIM(SM0->M0_CGC  */
		Endif

		Processa({ |lEnd| xPrintRel(),OemToAnsi('Generando el Reporte !!!')}, OemToAnsi('Espere un Momento Por Favor...'))
	Endif

Return


Static Function  xPrintRel()
	Private	oPrint := TMSPrinter():New(OemToAnsi('Comprobantes Contables')),;
		oBrush		 := TBrush():New(,4),;
		oPen		 := TPen():New(0,5,CLR_BLACK),;
		cFileLogo	 := GetSrvProfString('Startpath','') + 'logo' + '.bmp',;
		oFont07		 := TFont():New('Arial',07,07,,.F.,,,,.T.,.F.),;
		oFont07n	 := TFont():New('Arial',07,07,,.T.,,,,.T.,.F.),;
		oFont08		 := TFont():New('Arial',08,08,,.F.,,,,.T.,.F.),;
		oFont08n	 := TFont():New('Arial',08,08,,.T.,,,,.T.,.F.),;
		oFont09		 := TFont():New('Arial',09,09,,.F.,,,,.T.,.F.),;
		oFont09n	 := TFont():New('Arial',09,09,,.T.,,,,.T.,.F.),;
		oFont10		 := TFont():New('Arial',10,10,,.F.,,,,.T.,.F.),;
		oFont10n	 := TFont():New('Arial',10,10,,.T.,,,,.T.,.F.),;
		oFont11		 := TFont():New('Arial',11,11,,.F.,,,,.T.,.F.),;
		oFont12		 := TFont():New('Arial',12,12,,.T.,,,,.T.,.F.),;
		oFont14n	 := TFont():New('Arial',14,14,,.T.,,,,.T.,.F.),;
		oFont16		 := TFont():New('Arial',16,16,,.T.,,,,.T.,.F.),;
		oFont18		 := TFont():New('Arial',18,18,,.T.,,,,.T.,.T.),;
		nRegLin    	 := 470,;
		nTMoeda      := '$',;
		nValDesc     := 0,;
		nValImp      := 0,;
		oFont22		 := TFont():New('Arial',22,22,,.T.,,,,.T.,.F.)
	oPrint:SetPortrait()

	cNomEmp   	:= POSICIONE("SM0",1,CEMPANT+CFILANT,"M0_NOMECOM") 	//M0_NOMECOM
	cNIT      	:= POSICIONE("SM0",1,CEMPANT+CFILANT,"M0_CGC") 		//M0_CGC

	ctitulo  := "COMPROBANTE CONTABLE " + ALLTRIM(cNomemp)
	cSubTit  := "NIT: " + ALLTRIM(cNIT) //Titulo
	TotalDeb := 0; TotalHab := 0; Linea  := 100	; DocDebe  := 0; DocHaber := 0
	LotDebe  := 0; LotHaber := 0; MesDebe:= 0	; MesHaber := 0

	oPrint:StartPage()
	xCabec()

	If !lRut
		xDetalle()	//Query
	Else
		xDetalleP()	//TMP
	Endif

	If MsgYesno("¿Imprimir en PDF? ")
		oPrint:print(,1)
	else
		oPrint:Preview()
	Endif


Return

//**********************************//
//      Impresión del Encabezado	//
//**********************************//
Static Function xCabec()
	Local cStartPath := GetSrvProfString("StartPath","")
	Local cBmp 		 := cStartPath + "lgrl.bmp" 						//Logo
	Local cLog1		 := "logos\"+ "moto.png"
	Local cFileLog1  := GetSrvProfString("Startpath","") + cLog1  		// Logo según filial en caso de requerirse

// PARA INCLUSION DE LOGO EN EL INFORMES
	oPrint:SayBitmap(050,050,cFileLog1,0300,300) //  y,x,archivo,ancho,alto     LOGO DE MOTO
	oPrint:Say(0150,400,  ALLTRIM(cNomEmp),oFont16)
	oPrint:Say(0230,1100, "COMPROBANTE CONTABLE " + " / " + cDesTp  ,oFont10)
	oPrint:Say(0220,400,  "NIT: " + ALLTRIM(cNIT),oFont16)
	oPrint:Box(0385,0050,0455,2350)
	oPrint:Say(399,0060,  "Cuenta."		,oFont10)
//oPrint:Say(399,0280,"Cta Abono"	,oFont10)
	oPrint:Say(399,0260, "Descripcion"	,oFont10)
	oPrint:Say(399,0770, "Historial"	,oFont10)
//oPrint:Say(399,1500, "CC.Debe"	,oFont10)
	oPrint:Say(399,1310, "C.C. "	,oFont10)
	oPrint:Say(399,1500, "Item"	,oFont10)
	oPrint:Say(399,1690, "CVL "		,oFont10)
//oPrint:Say(399,2060, "Item.C"		,oFont10)
	oPrint:Say(399,1880, "NIT "		,oFont10)
//oPrint:Say(399,2400, "VL.C"		,oFont10)
	oPrint:Say(399,2080, "Debito."		,oFont10)
	oPrint:Say(399,2280, "Credito."		,oFont10)

	Linea:=500
Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impresión del Detalle / Query -CT2                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function xDetalle()
	Local cArea       := GetArea()
	Local cCadena     := ""
	Local cQuery      := ""
	Local cQuery1     := ""
	Local cQueryWhere := ""
	Local cTablaTemp  := Criatrab(Nil, .F.)
	Local cTablaTemp1 := Criatrab(Nil, .F.)
	Local cTabCT2     := InitSqlName("CT2")
	Local cFilCT2     := xFilial("CT2")
	Local cTabCT1     := InitSqlName("CT1")
	Local cFilCT1     := xFilial("CT1")
	Local cTabCTT     := InitSqlName("CTT")
	Local cFilCTT     := xFilial("CTT")
	Local cTabCTD     := InitSqlName("CTD")
	Local cFilCTD     := xFilial("CTD")
	Local cTabCTH     := InitSqlName("CTH")
	Local cFilCTH     := xFilial("CTH")
	Local cTabCV0     := InitSqlName("CV0")
	Local cFilCV0     := xFilial("CV0")
	Local cDoc        := ""
	Local nLote       := ""
	Local dFECHA      := ""
	Local docDebe     := 0
	Local docHaber    := 0
	Local loteDebe    := 0
	Local loteHaber   := 0
	Local mesDebe     := 0
	Local mesHaber    := 0
	Local totalDebe   := 0
	Local totalHaber  := 0
	Local cTipoC      := ""
	Local nCredito    := 0
	Local nDebito     := 0
	Local nCount      := 0
	Local cObservac   := ""

	cQryWhere := ""
	If (ALLTRIM(DctoIni) == "" .AND. ALLTRIM(DctoFin) == "ZZZZZZ")
	Else
		cQryWhere += " AND CT2_DOC BETWEEN '" + DctoIni + "' AND '" + DctoFin + "'"
	Endif

	If (LotIni == "" .AND. LotFin == "ZZZZZZ")
	Else
		cQryWhere += " AND CT2_LOTE BETWEEN '" + ALLTRIM(LotIni) + "' AND '" + ALLTRIM(LotFin) + "'"
	Endif


	cSbCod := POSICIONE("SX5",1,xFilial("SX21")+"SB","X5_CHAVE")

	If SubLt<>"ZZZ"
		cQryWhere += " AND CT2_SBLOTE = '" + ALLTRIM(SubLt) + "'"
	Endif


	cQuery := ""
	cQuery := "SELECT CT2_DC,CT2_DOC, CT2_DATA, CT2_DC, CT2_DEBITO, CT2_CREDIT, CT2_OBSCNF, "
	cQuery += "  CASE WHEN (CT1.CT1_DESC01) IS NULL THEN '' ELSE CT1.CT1_DESC01 END CT1_DESC01,"
	cQuery += "  CASE WHEN (CT1_2.CT1_DESC01 ) IS NULL THEN '' ELSE CT1_2.CT1_DESC01 END CT1_2_DESC01,"
	cQuery += "  CT2_LINHA,  CT2_HIST, CT2_CCD,"
	cQuery += "  CASE WHEN (CTT.CTT_DESC01) IS NULL THEN '' ELSE CTT.CTT_DESC01 END CTT_DESC01,"
	cQuery += "  CT2_CCC,"
	cQuery += "  CASE WHEN (CTT_2.CTT_DESC01) IS NULL THEN '' ELSE CTT_2.CTT_DESC01 END CTT_2_DESC01,"
	cQuery += "  CT2_ITEMD,"
	cQuery += "  CASE WHEN (CTD.CTD_DESC01) IS NULL THEN '' ELSE CTD.CTD_DESC01 END CTD_DESC01,"
	cQuery += "  CT2_ITEMC,"
	cQuery += "  CASE WHEN (CTD_2.CTD_DESC01) IS NULL THEN '' ELSE CTD_2.CTD_DESC01 END CTD_2_DESC01,"
	cQuery += "  CT2_CLVLDB,"
	cQuery += "  CASE WHEN (CTH.CTH_DESC01) IS NULL THEN '' ELSE CTH.CTH_DESC01 END CTH_DESC01,"
	cQuery += "  CT2_CLVLCR,"

	cQuery += "  CASE WHEN (CV0_2.CV0_DESC) IS NULL THEN '' ELSE CV0_2.CV0_DESC END CV0_2_DESC,"
	cQuery += "  CT2_EC05DB,"
	cQuery += "  CASE WHEN (CV0.CV0_DESC) IS NULL THEN '' ELSE CV0.CV0_DESC END CV0_DESC,"
	cQuery += "  CT2_EC05CR,"

	cQuery += "  CASE WHEN (CTH_2.CTH_DESC01) IS NULL THEN '' ELSE CTH_2.CTH_DESC01 END CTH_2_DESC01,"
	cQuery += "  CT2_MOEDLC, CT2_VALOR, CT2_LOTE, CT2_SBLOTE"

	If AllTrim(cFilCT1) <> ""
		//Verifica si la Tabla de CT1 está Exclusiva
		cQuery += " FROM "+ cTabCT2 +" CT2 LEFT JOIN " + cTabCT1 + " CT1 ON CT2.CT2_FILIAL = CT1.CT1_FILIAL"
		cQuery += "   AND CT2.CT2_DEBITO = CT1.CT1_CONTA AND CT1.D_E_L_E_T_ <> '*' "
		cQuery += " LEFT JOIN " + cTabCT1 + " CT1_2 ON  CT2.CT2_FILIAL = CT1_2.CT1_FILIAL"
	Else
		//Verifica si la Tabla de CT1 está Compartida
		cQuery += " FROM "+ cTabCT2 +" CT2 LEFT JOIN " + cTabCT1 + " CT1 ON CT2.CT2_DEBITO = CT1.CT1_CONTA"
		cQuery += "   AND CT2.CT2_DEBITO = CT1.CT1_CONTA AND CT1.D_E_L_E_T_ <> '*' "
		cQuery += " LEFT JOIN " + cTabCT1 + " CT1_2 ON CT2.CT2_CREDIT = CT1_2.CT1_CONTA"
	EndIf

	cQuery += "   AND CT2.CT2_CREDIT   = CT1_2.CT1_CONTA AND CT1_2.D_E_L_E_T_ <> '*' "
	cQuery += " LEFT JOIN " + cTabCTT + " CTT ON  CT2.CT2_FILIAL = CTT.CTT_FILIAL"
	cQuery += "  AND CT2.CT2_CCD    = CTT.CTT_CUSTO AND CTT.D_E_L_E_T_ <> '*'"
	cQuery += " LEFT JOIN " + cTabCTT + " CTT_2 ON  CT2.CT2_FILIAL = CTT_2.CTT_FILIAL"
	cQuery += "  AND CT2.CT2_CCC      = CTT_2.CTT_CUSTO AND CTT_2.D_E_L_E_T_ <> '*' "
	cQuery += " LEFT JOIN " + cTabCTD + " CTD ON  CT2.CT2_FILIAL = CTD.CTD_FILIAL"
	cQuery += "  AND CT2.CT2_ITEMD  = CTD.CTD_ITEM AND CTD.D_E_L_E_T_ <> '*' "
	cQuery += " LEFT JOIN " + cTabCTD + " CTD_2 ON  CT2.CT2_FILIAL = CTD_2.CTD_FILIAL"
	cQuery += "  AND CT2.CT2_ITEMC    = CTD_2.CTD_ITEM AND CTD_2.D_E_L_E_T_ <> '*' "
	cQuery += " LEFT JOIN " + cTabCTH + " CTH ON  CT2.CT2_FILIAL = CTH.CTH_FILIAL"
	cQuery += "  AND CT2.CT2_CLVLDB = CTH.CTH_CLVL AND CTH.D_E_L_E_T_ <> '*' "
	cQuery += " LEFT JOIN " + cTabCTH + " CTH_2 ON  CT2.CT2_FILIAL = CTH_2.CTH_FILIAL"
	cQuery += "  AND CT2.CT2_CLVLCR = CTH_2.CTH_CLVL AND CTH_2.D_E_L_E_T_ <> '*' "

	cQuery += " LEFT JOIN " + cTabCV0 + " CV0 ON  CT2.CT2_FILIAL = CV0.CV0_FILIAL"
	cQuery += "  AND CT2.CT2_EC05DB = CV0.CV0_CODIGO AND CV0.D_E_L_E_T_ <> '*' "
	cQuery += " LEFT JOIN " + cTabCV0 + " CV0_2 ON  CT2.CT2_FILIAL = CV0_2.CV0_FILIAL"
	cQuery += "  AND CT2.CT2_EC05CR = CV0_2.CV0_CODIGO AND CV0_2.D_E_L_E_T_ <> '*' "

	cQuery += " WHERE CT2.D_E_L_E_T_ <> '*' "
	cQuery += " 	AND CT2.CT2_TPSALD = '" + AllTrim(Str(nTpSld)) + "'"
	cQuery += "  	AND CT2_DATA BETWEEN '" + DTOS(dataIn) + "' AND '" + DTOS(dataFin) + "'"
	cQuery += cQryWhere
	cQuery += " ORDER BY CT2.CT2_DATA ASC, CT2.CT2_LOTE, CT2.CT2_SBLOTE, CT2.CT2_DOC,CT2.CT2_LINHA"
	cQuery := ChangeQuery(cQuery)

	dbUseArea(.T., "TOPCONN", TcGenQry(,,cQuery), cTablaTemp, .T., .T.)

//MemoWrite("Commprobante02.sql",cQuery)
//Aviso("cQuery -CT2:",cQuery,{"OK"},,,,,.T.)

	Do While !( (cTablaTemp)->(EOF()) )
		If ((cTablaTemp)->(CT2_LOTE) >= LotIni .AND. (cTablaTemp)->(CT2_LOTE) <= LotFin)

			If SubLt<>"ZZZ"
				//Verifica que este en el rango de lotes
				If ALLTRIM((cTablaTemp)->(CT2_SBLOTE)) == SubLt //.OR. _sblot=="000"  					//Verifica el sublote
					If ((cTablaTemp)->(CT2_DOC) >= DctoIni .AND. (cTablaTemp)->(CT2_DOC) <= DctoFin )   //que este dentro de los documentos

						IF (cTablaTemp)->(CT2_MOEDLC) <> "01"
							(cTablaTemp)->(dbSkip())
						Endif

						If (cDoc >= DctoIni  .and. cDoc <= DctoFin) .and. (cDoc <> (cTablaTemp)->(CT2_DOC) .OR. nLote <> (cTablaTemp)->(CT2_LOTE) .OR. dFecha <> (cTablaTemp)->(CT2_DATA)) // Si cambia cualquiera cambia de poliza
							Linea:= Linea + 100
							oPrint:Say(330,200	,"Número de comprobante " + cDoc + "-" + nLote  + "-" + SubLt		,oFont12)	//Imprime número de comprobante
							oPrint:Say(330,1500	,SubStr(dFecha,7,2)+"/"+SubStr(dFecha,5,2)+"/"+SubStr(dFecha,1,4)	,oFont12)

							oPrint:Say(Linea,0060, "Total Comprobante: " + cDoc + transform(nLote,  "@r 999") + SubLt, oFont12)
							oPrint:Say(Linea,1240, RTrim(Transform(docDebe ,"@r 999,999,999,999.99")),oFont12,,,,1)
							oPrint:Say(Linea,2000, RTrim(Transform(docHaber,"@r 999,999,999,999.99")),oFont12,,,,1)
							docDebe  := 0
							docHaber := 0
							Linea    := 2500
						Endif

						If Linea > 2300
							xVerPag()
						Endif

						//Para hacer los acumulados
						If (cTablaTemp)->(CT2_DC) == "3"
							cTipoC   := "P"
							nCredito := (cTablaTemp)->(CT2_VALOR)
							nDebito  := (cTablaTemp)->(CT2_VALOR)
						ElseIf (cTablaTemp)->(CT2_DC) = "2"
							cTipoC   := "C"
							nCredito := (cTablaTemp)->(CT2_VALOR)
							nDebito  := 0
						Else
							cTipoC   := "D"
							nDebito  := (cTablaTemp)->(CT2_VALOR)
							nCredito := 0
						Endif

						If (cTablaTemp)->(CT2_DC) == "3"
							oPrint:Say(linea, 0060, ALLTRIM((cTablaTemp)->(CT2_DEBITO)) ,oFont07)              	//CuentaDeb
							oPrint:Say(linea, 0240, SubStr(ALLTRIM((cTablaTemp)->(CT1_DESC01)),1,30)  ,oFont07)	//Descripcion
							linea := linea + 100
							oPrint:Say(linea, 0060, AllTrim((cTablaTemp)->(CT2_CREDIT))   ,oFont07)            	//CuentaCrd
							oPrint:Say(linea, 0240, SubStr(AllTrim((cTablaTemp)->(CT1_2_DESC01)),1,30),oFont07) //Descripción
						Else
							oPrint:Say(linea, 0060, ALLTRIM((cTablaTemp)->(CT2_DEBITO)) ,oFont07)              	//CuentaDeb
							oPrint:Say(linea, 0060, ALLTRIM((cTablaTemp)->(CT2_CREDIT)) ,oFont07)              	//CuentaCrd
							oPrint:Say(linea, 0240, SubStr(ALLTRIM((cTablaTemp)->(CT1_DESC01  )),1,30),oFont07)	//Descripcion
							oPrint:Say(linea, 0240, SubStr(AllTrim((cTablaTemp)->(CT1_2_DESC01)),1,30),oFont07) //Descripcion
						EndIf

						If AllTrim((cTablaTemp)->(CT2_DC)) <> "4"

							If AllTrim((cTablaTemp)->(CT2_DC)) == "3"
								oPrint:Say(linea-100,2180, RTrim(Transform(nDebito	,"@r 999,999,999,999.99"))	,oFont07,,,,1)	//Línea Débito
								oPrint:Say(linea	,2380, RTrim(Transform(nCredito	,"@r 999,999,999,999.99"))	,oFont07,,,,1)	//Línea Crédito
							Else
								If nDebito > 0
									oPrint:Say(linea,2180, RTrim(Transform(nDebito,"@r 999,999,999,999.99"))	,oFont07,,,,1)  //Línea Débito
								Endif

								If nCredito > 0
									oPrint:Say(linea,2380, RTrim(Transform(nCredito,"@r 999,999,999,999.99"))	,oFont07,,,,1)  //Línea Crédito
								Endif
							Endif
						Endif

						If ALLTRIM((cTablaTemp)->(CT2_DC)) == "3"
							linea := linea - 100

							oPrint:Say(linea, 0770, ALLTRIM(SUBSTR((cTablaTemp)->(CT2_HIST),1,35)),oFont07) 		//Historial
							oPrint:Say(linea, 1260, ALLTRIM(SUBSTR((cTablaTemp)->(CT2_CCD),1,15 )),oFont07)   		//CC.Debe
							//oPrint:Say(linea, 0240, ALLTRIM( SUBSTR((cTablaTemp)->(CTT_DESC01),1,15) ) ,oFont07)  //Descripcion
							oPrint:Say(linea, 1570, ALLTRIM(SUBSTR((cTablaTemp)->(CT2_ITEMD),1,5)),oFont07)         //ItemD
							//oPrint:Say(linea, 2380, ALLTRIM( SUBSTR((cTablaTemp)->(CTD_DESC01),1,15) ) ,oFont07)  //Descripcion
							//oPrint:Say(linea, 1760, ALLTRIM(SUBSTR((cTablaTemp)->(CT2_CLVLDB),1,10)),oFont07)     	//Vld
							//oPrint:Say(linea, 2850, ALLTRIM( SUBSTR((cTablaTemp)->(CTH_DESC01),1,15) ) ,oFont07)  //Descripcion
							oPrint:Say(linea, 1760, ALLTRIM(SUBSTR((cTablaTemp)->(CT2_EC05DB),1,10)),oFont07)     	//NIT
							//oPrint:Say(linea, 2850, ALLTRIM( SUBSTR((cTablaTemp)->(CV0_DESC),1,15) ) ,oFont07)  //Descripcion
							linea := linea + 100

							oPrint:Say(linea, 0770, ALLTRIM(SUBSTR((cTablaTemp)->(CT2_HIST),1,4)),oFont07) 			//Historial
							oPrint:Say(linea, 1260, ALLTRIM(SUBSTR((cTablaTemp)->(CT2_CCC),1,15)),oFont07)    		//CC.Haber
							//oPrint:Say(linea, 0240, ALLTRIM( SUBSTR((cTablaTemp)->(CTT_2_DESC01),1,15)),oFont07)  //Descripcion
							oPrint:Say(linea, 1570, ALLTRIM(SUBSTR((cTablaTemp)->(CT2_ITEMC),1,5)),oFont07)         //ItemC
							//oPrint:Say(linea, 2380, ALLTRIM( SUBSTR((cTablaTemp)->(CTD_2_DESC01),1,15)),oFont07)	//Descripcion
							//oPrint:Say(linea, 1760, ALLTRIM(SUBSTR((cTablaTemp)->(CT2_CLVLCR),1,10)),oFont07)     	//Vlc
							//oPrint:Say(linea, 2850, ALLTRIM( SUBSTR((cTablaTemp)->(CTH_2_DESC01),1,15)),oFont07)  //Descripcion
							oPrint:Say(linea, 1760, ALLTRIM(SUBSTR((cTablaTemp)->(CT2_EC05CR),1,10)),oFont07)     	//NIT
							//oPrint:Say(linea, 2850, ALLTRIM( SUBSTR((cTablaTemp)->(CV0_2_DESC),1,15)),oFont07)  //Descripcion

						Else
							//oPrint:Say(linea, 0240, ALLTRIM( SUBSTR((cTablaTemp)->(CTT_2_DESC01),1,15)) ,oFont07)	//Descripcion
							oPrint:Say(linea, 0770, ALLTRIM(SubStr((cTablaTemp)->(CT2_HIST),1,35)),oFont07) 		//Historial
							oPrint:Say(linea, 1260, ALLTRIM(SubStr((cTablaTemp)->(CT2_CCD),1,15 )),oFont07)   		//CC.Debe
							oPrint:Say(linea, 1260, ALLTRIM(SubStr((cTablaTemp)->(CT2_CCC),1,15)) ,oFont07)    		//CC.Haber
							oPrint:Say(linea, 1570, ALLTRIM(SubStr((cTablaTemp)->(CT2_ITEMD),1,5)),oFont07)         //ItemD
							oPrint:Say(linea, 1570, ALLTRIM(SubStr((cTablaTemp)->(CT2_ITEMC),1,5)),oFont07)         //ItemC
							//oPrint:Say(linea, 2380, ALLTRIM( SUBSTR((cTablaTemp)->(CTD_DESC01),1,15) ) ,oFont07)  //Descripcion
							//oPrint:Say(linea, 2380, ALLTRIM( SUBSTR((cTablaTemp)->(CTD_2_DESC01),1,15)),oFont07)  //Descripcion
							//oPrint:Say(linea, 1760, ALLTRIM(SubStr((cTablaTemp)->(CT2_CLVLDB),1,10)),oFont07)     	//Vld
							//oPrint:Say(linea, 1760, ALLTRIM(SubStr((cTablaTemp)->(CT2_CLVLCR),1,10)),oFont07)     	//Vlc

							oPrint:Say(linea, 1760, ALLTRIM(SubStr((cTablaTemp)->(CT2_EC05DB),1,10)),oFont07)     	//Vld
							oPrint:Say(linea, 1760, ALLTRIM(SubStr((cTablaTemp)->(CT2_EC05CR),1,10)),oFont07)     	//Vlc
							//oPrint:Say(linea, 0240, ALLTRIM( SUBSTR((cTablaTemp)->(CTT_DESC01),1,15) ) ,oFont07)  //Descripcion
							//oPrint:Say(linea, 2850, ALLTRIM( SUBSTR((cTablaTemp)->(CTH_DESC01),1,15) ) ,oFont07)  //Descripcion
							//oPrint:Say(linea, 2850, ALLTRIM( SUBSTR((cTablaTemp)->(CTH_2_DESC01),1,15)),oFont07)  //Descripcion
						Endif

						//----- Suma Los valores a calcular -------////
						docDebe    := docDebe    + nDebito
						docHaber   := docHaber   + nCredito
						loteDebe   := loteDebe   + nDebito
						loteHaber  := loteHaber  + nCredito
						mesDebe    := mesDebe    + nDebito
						mesHaber   := mesHaber   + nCredito
						totalDebe  := totalDebe  + nDebito
						totalHaber := totalHaber + nCredito
						cObservac  += ALLTRIM((cTablaTemp)->(CT2_OBSCNF))
						//----- Termina Suma Los valores a calcular -------////
						linea := linea + 100
						cDoc  := (cTablaTemp)->(CT2_DOC)
					Endif // validacion de documento

					SbLot := CT2->CT2_SBLOTE
				Endif // validacion del lote

			else


				//Verifica que este en el rango de lotes
				If ((cTablaTemp)->(CT2_DOC) >= DctoIni .AND. (cTablaTemp)->(CT2_DOC) <= DctoFin )   //que este dentro de los documentos

					IF (cTablaTemp)->(CT2_MOEDLC) <> "01"
						(cTablaTemp)->(dbSkip())
					Endif

					If (cDoc >= DctoIni  .and. cDoc <= DctoFin) .and. (cDoc <> (cTablaTemp)->(CT2_DOC) .OR. nLote <> (cTablaTemp)->(CT2_LOTE) .OR. dFecha <> (cTablaTemp)->(CT2_DATA)) // Si cambia cualquiera cambia de poliza
						Linea:= Linea + 100
						oPrint:Say(330,200	,"Número de comprobante " + cDoc + "-" + nLote  + "-" + SubLt		,oFont12)	//Imprime número de comprobante
						oPrint:Say(330,1500	,SubStr(dFecha,7,2)+"/"+SubStr(dFecha,5,2)+"/"+SubStr(dFecha,1,4)	,oFont12)

						oPrint:Say(Linea,0060, "Total Comprobante: " + cDoc + transform(nLote,  "@r 999") + SubLt, oFont12)
						oPrint:Say(Linea,1240, RTrim(Transform(docDebe ,"@r 999,999,999,999.99")),oFont12,,,,1)
						oPrint:Say(Linea,2000, RTrim(Transform(docHaber,"@r 999,999,999,999.99")),oFont12,,,,1)
						docDebe  := 0
						docHaber := 0
						Linea    := 2500
					Endif

					If Linea > 2300
						xVerPag()
					Endif

					//Para hacer los acumulados
					If (cTablaTemp)->(CT2_DC) == "3"
						cTipoC   := "P"
						nCredito := (cTablaTemp)->(CT2_VALOR)
						nDebito  := (cTablaTemp)->(CT2_VALOR)
					ElseIf (cTablaTemp)->(CT2_DC) = "2"
						cTipoC   := "C"
						nCredito := (cTablaTemp)->(CT2_VALOR)
						nDebito  := 0
					Else
						cTipoC   := "D"
						nDebito  := (cTablaTemp)->(CT2_VALOR)
						nCredito := 0
					Endif

					If (cTablaTemp)->(CT2_DC) == "3"
						oPrint:Say(linea, 0060, ALLTRIM((cTablaTemp)->(CT2_DEBITO)) ,oFont07)              	//CuentaDeb
						oPrint:Say(linea, 0240, SubStr(ALLTRIM((cTablaTemp)->(CT1_DESC01)),1,30)  ,oFont07)	//Descripcion
						linea := linea + 100
						oPrint:Say(linea, 0060, AllTrim((cTablaTemp)->(CT2_CREDIT))   ,oFont07)            	//CuentaCrd
						oPrint:Say(linea, 0240, SubStr(AllTrim((cTablaTemp)->(CT1_2_DESC01)),1,30),oFont07) //Descripción
					Else
						oPrint:Say(linea, 0060, ALLTRIM((cTablaTemp)->(CT2_DEBITO)) ,oFont07)              	//CuentaDeb
						oPrint:Say(linea, 0060, ALLTRIM((cTablaTemp)->(CT2_CREDIT)) ,oFont07)              	//CuentaCrd
						oPrint:Say(linea, 0240, SubStr(ALLTRIM((cTablaTemp)->(CT1_DESC01  )),1,30),oFont07)	//Descripcion
						oPrint:Say(linea, 0240, SubStr(AllTrim((cTablaTemp)->(CT1_2_DESC01)),1,30),oFont07) //Descripcion
					EndIf

					If AllTrim((cTablaTemp)->(CT2_DC)) <> "4"

						If AllTrim((cTablaTemp)->(CT2_DC)) == "3"
							oPrint:Say(linea-100,2180, RTrim(Transform(nDebito	,"@r 999,999,999,999.99"))	,oFont07,,,,1)	//Línea Débito
							oPrint:Say(linea	,2380, RTrim(Transform(nCredito	,"@r 999,999,999,999.99"))	,oFont07,,,,1)	//Línea Crédito
						Else
							If nDebito > 0
								oPrint:Say(linea,2180, RTrim(Transform(nDebito,"@r 999,999,999,999.99"))	,oFont07,,,,1)  //Línea Débito
							Endif

							If nCredito > 0
								oPrint:Say(linea,2380, RTrim(Transform(nCredito,"@r 999,999,999,999.99"))	,oFont07,,,,1)  //Línea Crédito
							Endif
						Endif
					Endif

					If ALLTRIM((cTablaTemp)->(CT2_DC)) == "3"
						linea := linea - 100

						oPrint:Say(linea, 0770, ALLTRIM(SUBSTR((cTablaTemp)->(CT2_HIST),1,35)),oFont07) 		//Historial
						oPrint:Say(linea, 1260, ALLTRIM(SUBSTR((cTablaTemp)->(CT2_CCD),1,15 )),oFont07)   		//CC.Debe
						//oPrint:Say(linea, 0240, ALLTRIM( SUBSTR((cTablaTemp)->(CTT_DESC01),1,15) ) ,oFont07)  //Descripcion
						oPrint:Say(linea, 1570, ALLTRIM(SUBSTR((cTablaTemp)->(CT2_ITEMD),1,5)),oFont07)         //ItemD
						//oPrint:Say(linea, 2380, ALLTRIM( SUBSTR((cTablaTemp)->(CTD_DESC01),1,15) ) ,oFont07)  //Descripcion
						//oPrint:Say(linea, 1760, ALLTRIM(SUBSTR((cTablaTemp)->(CT2_CLVLDB),1,10)),oFont07)     	//Vld
						//oPrint:Say(linea, 2850, ALLTRIM( SUBSTR((cTablaTemp)->(CTH_DESC01),1,15) ) ,oFont07)  //Descripcion
						oPrint:Say(linea, 1760, ALLTRIM(SUBSTR((cTablaTemp)->(CT2_EC05DB),1,10)),oFont07)     	//NIT
						//oPrint:Say(linea, 2850, ALLTRIM( SUBSTR((cTablaTemp)->(CV0_DESC),1,15) ) ,oFont07)  //Descripcion
						linea := linea + 100

						oPrint:Say(linea, 0770, ALLTRIM(SUBSTR((cTablaTemp)->(CT2_HIST),1,4)),oFont07) 			//Historial
						oPrint:Say(linea, 1260, ALLTRIM(SUBSTR((cTablaTemp)->(CT2_CCC),1,15)),oFont07)    		//CC.Haber
						//oPrint:Say(linea, 0240, ALLTRIM( SUBSTR((cTablaTemp)->(CTT_2_DESC01),1,15)),oFont07)  //Descripcion
						oPrint:Say(linea, 1570, ALLTRIM(SUBSTR((cTablaTemp)->(CT2_ITEMC),1,5)),oFont07)         //ItemC
						//oPrint:Say(linea, 2380, ALLTRIM( SUBSTR((cTablaTemp)->(CTD_2_DESC01),1,15)),oFont07)	//Descripcion
						//oPrint:Say(linea, 1760, ALLTRIM(SUBSTR((cTablaTemp)->(CT2_CLVLCR),1,10)),oFont07)     	//Vlc
						//oPrint:Say(linea, 2850, ALLTRIM( SUBSTR((cTablaTemp)->(CTH_2_DESC01),1,15)),oFont07)  //Descripcion
						oPrint:Say(linea, 1760, ALLTRIM(SUBSTR((cTablaTemp)->(CT2_EC05CR),1,10)),oFont07)     	//NIT
						//oPrint:Say(linea, 2850, ALLTRIM( SUBSTR((cTablaTemp)->(CV0_2_DESC),1,15)),oFont07)  //Descripcion

					Else
						//oPrint:Say(linea, 0240, ALLTRIM( SUBSTR((cTablaTemp)->(CTT_2_DESC01),1,15)) ,oFont07)	//Descripcion
						oPrint:Say(linea, 0770, ALLTRIM(SubStr((cTablaTemp)->(CT2_HIST),1,35)),oFont07) 		//Historial
						oPrint:Say(linea, 1260, ALLTRIM(SubStr((cTablaTemp)->(CT2_CCD),1,15 )),oFont07)   		//CC.Debe
						oPrint:Say(linea, 1260, ALLTRIM(SubStr((cTablaTemp)->(CT2_CCC),1,15)) ,oFont07)    		//CC.Haber
						oPrint:Say(linea, 1570, ALLTRIM(SubStr((cTablaTemp)->(CT2_ITEMD),1,5)),oFont07)         //ItemD
						oPrint:Say(linea, 1570, ALLTRIM(SubStr((cTablaTemp)->(CT2_ITEMC),1,5)),oFont07)         //ItemC
						//oPrint:Say(linea, 2380, ALLTRIM( SUBSTR((cTablaTemp)->(CTD_DESC01),1,15) ) ,oFont07)  //Descripcion
						//oPrint:Say(linea, 2380, ALLTRIM( SUBSTR((cTablaTemp)->(CTD_2_DESC01),1,15)),oFont07)  //Descripcion
						//oPrint:Say(linea, 1760, ALLTRIM(SubStr((cTablaTemp)->(CT2_CLVLDB),1,10)),oFont07)     	//Vld
						//oPrint:Say(linea, 1760, ALLTRIM(SubStr((cTablaTemp)->(CT2_CLVLCR),1,10)),oFont07)     	//Vlc

						oPrint:Say(linea, 1760, ALLTRIM(SubStr((cTablaTemp)->(CT2_EC05DB),1,10)),oFont07)     	//Vld
						oPrint:Say(linea, 1760, ALLTRIM(SubStr((cTablaTemp)->(CT2_EC05CR),1,10)),oFont07)     	//Vlc
						//oPrint:Say(linea, 0240, ALLTRIM( SUBSTR((cTablaTemp)->(CTT_DESC01),1,15) ) ,oFont07)  //Descripcion
						//oPrint:Say(linea, 2850, ALLTRIM( SUBSTR((cTablaTemp)->(CTH_DESC01),1,15) ) ,oFont07)  //Descripcion
						//oPrint:Say(linea, 2850, ALLTRIM( SUBSTR((cTablaTemp)->(CTH_2_DESC01),1,15)),oFont07)  //Descripcion
					Endif

					//----- Suma Los valores a calcular -------////
					docDebe    := docDebe    + nDebito
					docHaber   := docHaber   + nCredito
					loteDebe   := loteDebe   + nDebito
					loteHaber  := loteHaber  + nCredito
					mesDebe    := mesDebe    + nDebito
					mesHaber   := mesHaber   + nCredito
					totalDebe  := totalDebe  + nDebito
					totalHaber := totalHaber + nCredito
					cObservac  += ALLTRIM((cTablaTemp)->(CT2_OBSCNF))
					//----- Termina Suma Los valores a calcular -------////
					linea := linea + 100
					cDoc  := (cTablaTemp)->(CT2_DOC)
				Endif // validacion de documento

				SbLot := CT2->CT2_SBLOTE



			Endif

			nLote  := (cTablaTemp)->(CT2_LOTE)
			dFECHA := (cTablaTemp)->(CT2_DATA)
		Endif // validacion del parametro

		//Linea += 50
		(cTablaTemp)->(dbSkip())
	EndDo

//*************************************************************
	oPrint:Say(330,200, "Número de Comprobante " + cDoc + "-" + nLote + "-" + SubLt, oFont12)		//Imprime numero de comprobante
	oPrint:Say(330,1500,    SubStr((dFecha),7,2) + "/" + SubStr((dFecha),5,2) + "/" + SubStr((dFecha),1,4),oFont12)
	Linea := Linea + 100
	oPrint:Say(Linea,0060, "-------------------------------------------------------------------------------------------------------------------------------------------------------------------", oFont10)
	Linea:= Linea + 30
    oPrint:Say(Linea,0060, "Observaciones: " +  cObservac, oFont12)
	Linea:= Linea + 30
	oPrint:Say(Linea,0060, "-------------------------------------------------------------------------------------------------------------------------------------------------------------------", oFont10)
	Linea:= Linea + 30
	oPrint:Say(Linea,0060, "Total Comprobante: " + cDoc + transform(nLote,  "@r 999") + SubLt, oFont12)
	oPrint:Say(Linea,1240, RTrim(transform(docDebe,  "@r 999,999,999,999.99")),oFont12,,,,1)
	oPrint:Say(Linea,2000, RTrim(transform(docHaber, "@r 999,999,999,999.99")),oFont12,,,,1)
	Linea:= Linea + 30
	oPrint:Say(Linea,0060, "-------------------------------------------------------------------------------------------------------------------------------------------------------------------", oFont10)
	Linea:= Linea + 30
	oPrint:Say(Linea,0060, "Total General Informe:",oFont14n)
	oPrint:Say(Linea,1240, RTrim(transform(totalDebe,  "@r 999,999,999,999.99")),oFont12,,,,1)
	oPrint:Say(Linea,2000, RTrim(transform(totalHaber, "@r 999,999,999,999.99")),oFont12,,,,1)
	Linea:= Linea + 30
	oPrint:Say(Linea,0060, "-------------------------------------------------------------------------------------------------------------------------------------------------------------------", oFont10)
	Linea:= Linea + 30
//oPrint:Say(Linea,0060, "_________________________________________________Fin del reporte_____________________________________________________________", oFont10)				

	(cTablaTemp)->(dbCloseArea())
	RestArea(cArea)

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Función para Revisar el Salto de Pág. del Reporte ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function xVerPag()
	If (Linea>=2300)
		xCabec()
		Linea := 360
		oPrint:EndPage()
		oPrint:StartPage()
		xCabec()
	EndIf
Return


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impresión del Detalle / TMP                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function xDetalleP()
	Local cArea       := GetArea()
	Local cCadena     := ""
	Local cDoc        := ""
	Local nLote       := ""
	Local dFECHA      := ""
	Local docDebe     := 0
	Local docHaber    := 0
	Local loteDebe    := 0
	Local loteHaber   := 0
	Local mesDebe     := 0
	Local mesHaber    := 0
	Local totalDebe   := 0
	Local totalHaber  := 0
	Local cTipoC      := ""
	Local nCredito    := 0
	Local nDebito     := 0
	Local nCount      := 0
	Local cObservac   := ""

	If Linea > 2300
		xVerPag()
	Endif

//Para hacer los acumulados
	TMP->(DBGOTOP())
	While !(TMP->(EOF()))

		If TMP->CT2_TPSALD == AllTrim(Str(nTpSld))	//Tipo de Saldo
			If Linea > 2300
				xVerPag()
			Endif

			If TMP->CT2_FLAG
				TMP->(DBSKIP())
				Loop
			EndIf

			If TMP->CT2_DC == "3"
				cTipoC   := "P"
				nCredito := TMP->CT2_VALOR
				nDebito  := TMP->CT2_VALOR
			ElseIf TMP->CT2_DC = "2"
				cTipoC   := "C"
				nCredito := TMP->CT2_VALOR
				nDebito  := 0
			Else
				cTipoC   := "D"
				nDebito  := TMP->CT2_VALOR
				nCredito := 0
			Endif

			If TMP->CT2_DC == "3"
				oPrint:Say(linea, 0060, ALLTRIM(TMP->CT2_DEBITO) ,oFont07)              				//CuentaDeb
				cDesc:=SUBSTR(Posicione("CT1",1,xfilial("CT1")+TMP->CT2_DEBITO,"CT1_DESC01"),1,30)
				oPrint:Say(linea, 0240, ALLTRIM(cDesc) ,oFont07)              							//Descripcion
				linea := linea + 100
				oPrint:Say(linea, 0060, ALLTRIM(TMP->CT2_CREDIT) ,oFont07)
				cDesc:=SUBSTR(Posicione("CT1",1,xfilial("CT1")+TMP->CT2_CREDIT,"CT1_DESC01"),1,30)
				//oPrint:Say(linea, 0280, ALLTRIM(cDesc) ,oFont10)              						//CuentaCrd
				oPrint:Say(linea, 0240, ALLTRIM(cDesc) ,oFont07)              							//Descripcion
			Else
				oPrint:Say(linea, 0060, ALLTRIM(TMP->CT2_DEBITO) ,oFont07)              				//CuentaDeb
				oPrint:Say(linea, 0060, ALLTRIM(TMP->CT2_CREDIT) ,oFont07)              				//CuentaCrd
				cDesc:=SUBSTR(Posicione("CT1",1,xfilial("CT1")+TMP->CT2_DEBITO,"CT1_DESC01"),1,30)
				oPrint:Say(linea, 0240, ALLTRIM(cDesc) ,oFont07)              							//Descripcion
				cDesc:=SUBSTR(Posicione("CT1",1,xfilial("CT1")+TMP->CT2_CREDIT,"CT1_DESC01"),1,30)
				oPrint:Say(linea, 0240, ALLTRIM(cDesc) ,oFont07)              							//Descripcion
			End If

			If ALLTRIM(TMP->CT2_DC) <> "4"
				If ALLTRIM(TMP->CT2_DC) == "3"
					oPrint:Say(linea-100,2180, RTrim(transform(nDebito,"@r 999,999,999,999.99")),oFont07,,,,1)  //Linea debito
					oPrint:Say(linea,2380, RTrim(transform(nCredito,"@r 999,999,999,999.99")),oFont07,,,,1)  	//Linea credito
				Else
					If nDebito > 0
						oPrint:Say(linea,2180, RTrim(transform(nDebito,"@r 999,999,999,999.99")),oFont07,,,,1)  //Linea debito
					Endif

					IF nCredito > 0
						oPrint:Say(linea,2380, RTrim(transform(nCredito,"@r 999,999,999,999.99")),oFont07,,,,1) //Linea credito
					Endif
				Endif
			Endif

			If ALLTRIM(TMP->CT2_DC) == "3"

				linea := linea - 100
				oPrint:Say(linea, 0770, ALLTRIM(SUBSTR(TMP->CT2_HIST,1,35)),oFont07)                        //Historial
				//oPrint:Say(linea, 2300, ALLTRIM(SUBSTR(TMP->CT2_CCD,1,5 )),oFont10)         			    //CC.Debe
				oPrint:Say(linea, 1310, ALLTRIM(SUBSTR(TMP->CT2_CCD,1,15 )),oFont07)                 		//CC.Debe
				//oPrint:Say(linea, 2110, ALLTRIM( SUBSTR((cTablaTemp)->(CTT_DESC01),1,15) ) ,oFont07)      //Descripcion
				oPrint:Say(linea, 1500, ALLTRIM(SUBSTR(TMP->CT2_ITEMD,1,5)),oFont07)               			//ItemD
				//oPrint:Say(linea, 2380, ALLTRIM( SUBSTR((cTablaTemp)->(CTD_DESC01),1,15) ) ,oFont07)      //Descripcion
				oPrint:Say(linea, 1690, ALLTRIM(SUBSTR(TMP->CT2_CLVLDB,1,10)),oFont07)              		//Vld
				//oPrint:Say(linea, 2850, ALLTRIM( SUBSTR((cTablaTemp)->(CTH_DESC01),1,15) ) ,oFont07)      //Descripcion
				oPrint:Say(linea, 1880, ALLTRIM(SUBSTR(TMP->CT2_EC05DB,1,10)),oFont07)              		//NIT
				//oPrint:Say(linea, 2850, ALLTRIM( SUBSTR((cTablaTemp)->(CV0_DESC),1,15) ) ,oFont07)      //Descripcion


				linea := linea + 100
				oPrint:Say(linea, 0770, ALLTRIM(SUBSTR(TMP->CT2_HIST,1,35)),oFont07)						//Historial
				//oPrint:Say(linea, 2460, ALLTRIM(SUBSTR(TMP->CT2_CCC,1,5)),oFont10)                 		//CC.Haber
				oPrint:Say(linea, 1310, ALLTRIM(SUBSTR(TMP->CT2_CCC,1,15)),oFont07)                 		//CC.Haber
				//oPrint:Say(linea, 2110, ALLTRIM( SUBSTR((cTablaTemp)->(CTT_2_DESC01),1,15) ) ,oFont07)    //Descripcion
				oPrint:Say(linea, 1500, ALLTRIM(SUBSTR(TMP->CT2_ITEMC,1,5)),oFont07)               			//ItemC
				//oPrint:Say(linea, 2380, ALLTRIM( SUBSTR((cTablaTemp)->(CTD_2_DESC01),1,15) ) ,oFont07)    //Descripcion
				oPrint:Say(linea, 1690, ALLTRIM(SUBSTR(TMP->CT2_CLVLCR,1,10)),oFont07)               		//Vlc
				//oPrint:Say(linea, 2850, ALLTRIM( SUBSTR((cTablaTemp)->(CTH_2_DESC01),1,15) ) ,oFont07)    //Descripcion
				oPrint:Say(linea, 1880, ALLTRIM(SUBSTR(TMP->CT2_EC05CR,1,10)),oFont07)               		//NIT
				//oPrint:Say(linea, 2850, ALLTRIM( SUBSTR((cTablaTemp)->(CV0_2_DESC),1,15) ) ,oFont07)    //Descripcion

			Else
				oPrint:Say(linea, 0770, ALLTRIM(SUBSTR(TMP->CT2_HIST,1,40)),oFont07) 			//Historial
				//oPrint:Say(linea, 2300, ALLTRIM(SUBSTR(TMP->CT2_CCD,1,5 )),oFont10)           //CC.Debe
				//oPrint:Say(linea, 2460, ALLTRIM(SUBSTR(TMP->CT2_CCC,1,5)),oFont10)            //CC.Haber
				oPrint:Say(linea, 1310, ALLTRIM(SUBSTR(TMP->CT2_CCD,1,15 )),oFont07)            //CC.Debe
				oPrint:Say(linea, 1310, ALLTRIM(SUBSTR(TMP->CT2_CCC,1,15)),oFont07)             //CC.Haber


				//oPrint:Say(linea, 2110, ALLTRIM( SUBSTR((cTablaTemp)->(CTT_DESC01),1,15) ) ,oFont07)      //Descripcion
				//oPrint:Say(linea, 2110, ALLTRIM( SUBSTR((cTablaTemp)->(CTT_2_DESC01),1,15) ) ,oFont07)    //Descripcion
				oPrint:Say(linea, 1500, ALLTRIM(SUBSTR(TMP->CT2_ITEMD,1,5)),oFont07)               			//ItemD
				oPrint:Say(linea, 1500, ALLTRIM(SUBSTR(TMP->CT2_ITEMC,1,5)),oFont07)               			//ItemC
				//oPrint:Say(linea, 2380, ALLTRIM( SUBSTR((cTablaTemp)->(CTD_DESC01),1,15) ) ,oFont07)      //Descripcion
				//oPrint:Say(linea, 2380, ALLTRIM( SUBSTR((cTablaTemp)->(CTD_2_DESC01),1,15) ) ,oFont07)    //Descripcion
				oPrint:Say(linea, 1690, ALLTRIM(SUBSTR(TMP->CT2_CLVLDB,1,10)),oFont07)              		//Vld
				oPrint:Say(linea, 1690, ALLTRIM(SUBSTR(TMP->CT2_CLVLCR,1,10)),oFont07)              		//Vlc
				//oPrint:Say(linea, 2850, ALLTRIM( SUBSTR((cTablaTemp)->(CTH_DESC01),1,15) ) ,oFont07)      //Descripcion
				//oPrint:Say(linea, 2850, ALLTRIM( SUBSTR((cTablaTemp)->(CTH_2_DESC01),1,15) ) ,oFont07)    //Descripcion
				oPrint:Say(linea, 1880, ALLTRIM(SUBSTR(TMP->CT2_EC05DB,1,10)),oFont07)              		//NITd
				oPrint:Say(linea, 1880, ALLTRIM(SUBSTR(TMP->CT2_EC05CR,1,10)),oFont07)              		//NITc
				//oPrint:Say(linea, 2850, ALLTRIM( SUBSTR((cTablaTemp)->(CV0_DESC),1,15) ) ,oFont07)      //Descripcion
				//oPrint:Say(linea, 2850, ALLTRIM( SUBSTR((cTablaTemp)->(CV0_2_DESC),1,15) ) ,oFont07)    //Descripcion

			Endif

			//----- Suma Los valores a calcular -------////
			docDebe    := docDebe    + nDebito
			docHaber   := docHaber   + nCredito
			loteDebe   := loteDebe   + nDebito
			loteHaber  := loteHaber  + nCredito
			mesDebe    := mesDebe    + nDebito
			mesHaber   := mesHaber   + nCredito
			totalDebe  := totalDebe  + nDebito
			totalHaber := totalHaber + nCredito
			cObservac  := cObservac  + ALLTRIM(TMP->CT2_OBSCNF)
			//----- Termina Suma Los valores a calcular -------////
			linea := linea + 100
		Endif

		TMP->(DBSKIP())
	Enddo

	If Type("dataIn")=="D"
		dataIn	:= DTOC(dataIn)
		dataFin := DTOC(dataFin)
	Endif

	oPrint:Say(330,0200	, "Número de comprobante " + DctoIni + "-" + LotIni + "-" + SbLot, oFont12) // Imprime numero de comprobante
	oPrint:Say(330,1500	, SubStr((dataIn),7,2) + "/" + SubStr((dataIn),5,2) + "/" + SubStr((dataIn),1,4),oFont12)

	Linea := Linea + 100
	oPrint:Say(Linea,0060, "-------------------------------------------------------------------------------------------------------------------------------------------------------------------", oFont10)
	Linea:= Linea + 30
	oPrint:Say(Linea,0060, "Observaciones: " +  cObservac, oFont12)
    //oPrint:Say(Linea,0060, "Observaciones: " + ALLTRIM((cTablaTemp)->(CT2_OBSCNF)), oFont12)   
	Linea:= Linea + 30
	oPrint:Say(Linea,0060, "-------------------------------------------------------------------------------------------------------------------------------------------------------------------", oFont10)
	Linea:= Linea + 30
	oPrint:Say(Linea,0060, "Total comprobante: " + DctoIni + Transform(LotIni,  "@r 999") + SbLot, oFont12)
	oPrint:Say(Linea,1240, RTrim(Transform(docDebe,  "@r 999,999,999,999.99")),oFont12,,,,1)
	oPrint:Say(Linea,1900, RTrim(Transform(docHaber, "@r 999,999,999,999.99")),oFont12,,,,1)
	Linea:= Linea + 30
	oPrint:Say(Linea,0060, "-------------------------------------------------------------------------------------------------------------------------------------------------------------------", oFont10)
	Linea:= Linea + 30
	oPrint:Say(Linea,0060, "Total General Informe:",oFont14n)
	oPrint:Say(Linea,1240, RTrim(Transform(totalDebe,  "@r 999,999,999,999.99")),oFont12,,,,1)
	oPrint:Say(Linea,1900, RTrim(Transform(totalHaber, "@r 999,999,999,999.99")),oFont12,,,,1)
	Linea:= Linea + 30
	oPrint:Say(Linea,0060, "-------------------------------------------------------------------------------------------------------------------------------------------------------------------", oFont10)
	Linea:= Linea + 30

	TMP->(DBGOTOP())
	RestArea(cArea)

Return


Static Function AjustaSX1
	Local aAlias := Alias()
	Local aRegs	 := {}
	Local i,j	 := 0

	DbSelectArea("SX1")
	DbSetOrder(1)
	cPerg := PADR(cPerg,10)

	aAdd(aRegs,{cPerg,"01","","De Documento	"	,"","mv_ch1"	,"C"	,6,0,0	,"G",""								,"mv_par01","","","","","","","","","","","","","","","","","","","","","","","","",""  })
	aAdd(aRegs,{cPerg,"02","","A Documento 	"	,"","mv_ch2"	,"C"	,6,0,0	,"G","(mv_par02 >= mv_par01)"		,"mv_par02","","","","","","","","","","","","","","","","","","","","","","","","",""  })
	aAdd(aRegs,{cPerg,"03","","De Lote    	"	,"","mv_ch3"	,"C"	,6,0,0	,"G",""								,"mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","09"})
	aAdd(aRegs,{cPerg,"04","","A Lote     	"	,"","mv_ch4"	,"C"	,6,0,0	,"G","(mv_par04 >= mv_par03)"		,"mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","09"})
	aAdd(aRegs,{cPerg,"05","","Sub Lote     "	,"","mv_ch5"	,"C"	,3,0,0	,"G","!EMPTY(mv_par05)"				,"mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","SB"})
	aAdd(aRegs,{cPerg,"06","","De Fecha		"	,"","mv_ch6"	,"D"	,8,0,0	,"G",""								,"mv_par06","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"07","","A Fecha		"	,"","mv_ch7"	,"D"	,8,0,0	,"G","!EMPTY(mv_par07 >= mv_par06)"	,"mv_par07","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"08","","Tipo de saldo?"	,"","mv_ch8"	,"C"	,1,0,0	,"G",""								,"mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","SL"})
	For i:=1 to Len(aRegs)
		If !dbSeek(cPerg+aRegs[i,2])
			RecLock("SX1",.T.)
			For j:=1 to FCount()
				If j <= Len(aRegs[i])
					FieldPut(j,aRegs[i,j])
				Endif
			Next
			MsUnlock()
		Endif
	Next

	DbSelectArea(aAlias)
Return


//Static Function BuscaCT2(dFecha,cLote,cSubLT,cDocumento)
Static Function BuscaCT2(dataIn,dataFin,LotIni,LotFin,SbLot,SubLt,DctoIni,DctoFin)
	Local cQuery	:= ""
	Local cKey		:= SF1->F1_FILIAL+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_TIPO+SF1->F1_ESPECIE

	cQuery := "SELECT * "
	cQuery += " FROM " + RetSqlName("CT2") + " CT2"
	cQuery += " WHERE CT2.D_E_L_E_T_<> '*'"
	cQuery += " AND CT2_KEY = '" + cKey + "'"
	cQuery := ChangeQuery(cQuery)

	If Select("StrSQL") > 0  //En uso
		StrSQL->(DbCloseArea())
	Endif
	dbUseArea(.T.,'TOPCONN', TCGenQry(,,cQuery),"StrSQL", .F., .T.)
//MemoWrite("Commprobante.sql",cQuery)  	 

	DbSelectArea("StrSQL")
	DbGoTop()
	If !Empty(StrSQL->(CT2_DOC))
		dataIn	:= STOD(StrSQL->(CT2_DATA))
		dataFin	:= STOD(StrSQL->(CT2_DATA))
		LotIni	:= StrSQL->(CT2_LOTE)
		LotFin	:= StrSQL->(CT2_LOTE)
		SbLot	:= StrSQL->(CT2_SBLOTE)
		SubLt	:= StrSQL->(CT2_SBLOTE)
		DctoIni	:= StrSQL->(CT2_DOC)
		DctoFin	:= StrSQL->(CT2_DOC)
	Endif
	StrSQL->(dbCloseArea())
Return
