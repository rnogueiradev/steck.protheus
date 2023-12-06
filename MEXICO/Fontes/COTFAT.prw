#Include "Protheus.ch"
#Include 'rwmake.ch'              
#Include 'colors.ch'
#Include 'stdwin.ch'
#Include 'TOTVS.ch'



/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcion ³      COTFAT ³ Autor Alejandro de los Reyes  Fecha ³ 08/08/2018 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descripcion: Impresion Cotizacion de Venta en Facturacion  			  ³±±
±±³                                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ SIGAFAT										              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß|ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function COTFAT()
****************************

Local cPerg		:= "COTFAT    "
Private oLeTxt
Private lEnd	:=.F.
Private nPag	:= 1
Private cEmp	:= "" 
Private _nOrigen:= 0 
Private cFilName	:= "PROPUESTA"  
Private cPDFProp	:=  GetSrvProfString("Startpath","") + "PROPUESTAS\pdf\"			
Private cNumprop	:= ""
Private cCTE   	:= ""
Private cLoja   := ""
Private __aArea:=GetArea()
Private cMoeda1    := 0
Private nMoneda    := 0
Private cMoeda     := " "       
Private nTMerc   := 0
Private nTFle    := 0
Private nTSeg    := 0
Private nTGas	 := 0
Private nTot1	 := 0
Private nTDes    := 0
Private nTImp    := 0
Private cTot1    := 0
Private cTot2    := 0
Private nsTotal   := 0
Private _nTotal   := 0
Private nTuni    := 0
Private nTVol    := 0
Private nTPes    := 0
Private nTxMoeda := 0
Private nImp     := 0 
Private nValUnit := 0
Private nValDes  := 0
Private nValV	 := 0
Private nIvaItem:= 0
Private cObserva  := ""
Private cComents  := ""
Private cPedimento:= ""
Private	cNomeCli :=	""
Private	cDirCli	 :=	""
Private	cMunCli  :=	""
Private	cEstCli	 :=	""
Private	cColCli	 :=	""
Private	cCPCli	 :=	""
Private	cTelCli  := ""
Private	cRFCCli	 := ""
Private	cContCli := ""
Private cLogoCuen	:= GetSrvProfString("Startpath","") + "DatosC"+cEmpAnt+".jpg"       //Imagen con Datos de Cuentas
Private cLogoOfic	:= GetSrvProfString("Startpath","") + "DatosO"+cEmpAnt+".jpg"       //Imagen con Datos de Oficinas


IF FUNNAME()== "A415IMPRI" .OR. FUNNAME()== "MATA415"        //MUESTRA INTERFACE
	_nOrigen:= 1
Endif

IF _nOrigen == 1		//NO MUESTRA INTERFACE
//	Pergunte(cPerg,.F.)
	mv_par01	:= SCJ->CJ_NUM
	mv_par02	:= SCJ->CJ_NUM
	cNumprop	:= SCJ->CJ_NUM
	if ( MsgYesNo("¿Desea La propuesta en Ingles?") )	
		mv_par03	:= 2	
		cFilName:= "PROP"+ALLTRIM(MV_PAR01)+"_EN"
	Else
		mv_par03	:= 1
		cFilName:= "PROP"+ALLTRIM(MV_PAR01)+"_ES"
	Endif
	Proceso(.F.)
Else
	AjustaSX1(cPerg)
	If	( ! Pergunte(cPerg,.T.) )
		Return                   
	Else
		cNumprop	:= mv_par01+"_"+mv_par02
		cFilName:= "PROP"+ALLTRIM(MV_PAR01)+"_"+ALLTRIM(MV_PAR02)		
	EndIf
	@ 200,1 TO 400,400 DIALOG oLeTxt TITLE OemToAnsi("Presupuesto de Venta")
	@ 02,10 TO 080,190
	@ 10,018 Say " Impresion del Presupuesto de Venta en Facturacion"
	@ 08,001 Say " "
	@ 50,001 Say " "
	@ 70,098 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg,.T.)
	@ 70,128 BMPBUTTON TYPE 01 ACTION Processa({|lEnd| Proceso(@lEnd),OemToAnsi('Espere...')},OemToAnsi('Generando....'))
	@ 70,158 BMPBUTTON TYPE 02 ACTION Close(oLeTxt)
	Activate Dialog oLeTxt Centered
Endif   
RestArea(__aArea)
Return


Static Function Proceso(lEnd)

Local cQry  	:= ""
Local nRegs		:= 0
Local lRet 		:= .F.
Local x			:= 0                                                    
Private nPag 	:= 1
Private	oPrint		:= NIL 
//FWMsPrinter():New(ALLTRIM(cFilName)+".PDF",6,.T.,,.T.,,,,,,,.F.,)
//Private	oPrint	:= TMSPrinter():New(OemToAnsi('Presupuesto de Venta')),;

Private oBrush		:= TBrush():New(,4),;
oPen		:= TPen():New(0,5,CLR_BLACK),;
cFileLogoR	:= GetSrvProfString("Startpath","") + "logoFac"+cEmpAnt+".jpg",;
oFont08		:= TFont():New('Arial',08,08,,.F.,,,,.T.,.F.),;
oFont08n	:= TFont():New('Arial',07,07,,.T.,,,,.T.,.F.),;
oFont10		:= TFont():New('Arial',10,10,,.F.,,,,.T.,.F.),;
oFont10n	:= TFont():New('Arial',10,10,,.T.,,,,.T.,.F.),;
oFont11		:= TFont():New('Arial',11,11,,.F.,,,,.T.,.F.),;
oFont11n	:= TFont():New('Arial',11,11,,.T.,,,,.T.,.F.),;
oFont12		:= TFont():New('Arial',12,12,,.F.,,,,.T.,.F.),;
oFont12n	:= TFont():New('Arial',12,12,,.T.,,,,.T.,.F.),;
oFont13		:= TFont():New('Arial',13,13,,.F.,,,,.T.,.F.),;
oFont13n	:= TFont():New('Arial',13,13,,.T.,,,,.T.,.F.),;
oFont15		:= TFont():New('Arial',15,15,,.F.,,,,.T.,.F.),;
oFont15n	:= TFont():New('Arial',13,13,,.T.,,,,.T.,.F.),;
oFont18n	:= TFont():New('Arial',20,20,,.T.,,,,.T.,.F.),;
oFont20		:= TFont():New('Arial',20,20,,.T.,,,,.T.,.F.),;
oFont50		:= TFont():New('Arial',50,50,,.T.,,,,.T.,.F.),;
oFont08CN   := TFont():New('Courier',10,10,,.F.,,,,.T.,.F.),;
oFont12CN   := TFont():New('Courier',12,12,,.T.,,,,.T.,.F.),;
oFont12C    := TFont():New('Courier',12,12,,.F.,,,,.T.,.F.),;
oFont15CN   := TFont():New('Courier',15,15,,.T.,,,,.T.,.F.)

Private nLin 		:= 1150
Private nMarX		:= 50
Private nMarY		:= 50
Private aSalIni 	:= { 0,0,0,0,0,0,0 }
Private aSldMov		:= { 0,0,0,0 }  
Private lEnd2	:=.F.

	oPrint		:= FWMsPrinter():New(ALLTRIM(cFilName)+".PDF",6,.T.,,.T.,,,,,,,.T.,)	
	oPrint:SetResolution(72)
	oPrint:SetPortrait()
	oPrint:SetPaperSize(1)
	oPrint:cPathPDF:= "C:\SPOOL\Propuestas\"

//	If nPag <> 1
//		Processa({|lEnd2| fImpRem(@lEnd2),OemToAnsi('Espere...')},OemToAnsi('Generando....'))
//	Else
		Processa({|lEnd2| fImpRem(@lEnd2),OemToAnsi('Espere...')},OemToAnsi('Generando....'))
//	Endif
	oPrint:Preview()
	
	IF ( MsgYesNo("¿Continuar con el envío de la Propuesta por correo electrónico?") )
		EnviaPropuesta()
	endif

Return


Static Function fImpRem(lEnd2)
****************************

Local aArea      := GetArea()
Local cQuery     := ""
Local cQuery1    := ""
Local cQuery2    := ""
Local cQuery3    := ""
Local cNumDoc    := ""
Local cNumOP     := ""
Local cNumLt     := ""
Local aDatos     := {}
Local cPedido	 := ""
Local nRegs:=0
Private cAliasSCJ  := GetNextAlias()


cQuery := " SELECT "
cQuery += " CJ_CLIENTE, CJ_LOJA   , CJ_PROSPE , CJ_LOJPRO  , CJ_NUM   , CJ_CONDPAG , CJ_TXMOEDA , CJ_EMISSAO , CJ_FRETE, CJ_SEGURO ,CJ_DESPESA, "
cQuery += " CJ_MOEDA  , CJ_TABELA , CJ_DESC1  , CJ_DATA1   , CJ_VEND  , CJ_MENNOTA ,(CJ_DESC1 + CJ_DESC2 + CJ_DESC3 + CJ_DESC4) nDesc,"
cQuery += " CK_PRODUTO, CK_UM     , CK_QTDVEN , CK_PRCVEN  , CK_PRUNIT, CK_LOCAL   , CK_VALOR   , CK_ENTREG  ,"
cQuery += " CK_OBS    , CK_VALDESC, (CK_PRUNIT * CK_QTDVEN) nTOTAL    , CK_TES    "
cQuery += " From " +  RetSqlName("SCJ") + " SCJ," + RetSqlName("SCK") + " SCK"
cQuery += " WHERE   SCJ.D_E_L_E_T_ <> '*'"
cQuery += " AND   SCK.D_E_L_E_T_ <> '*'"
cQuery += " AND CJ_FILIAL    = '" + xFilial("SCJ") + "'"
cQuery += " AND CK_FILIAL    = '" + xFilial("SCK") + "'"
cQuery += " AND CJ_NUM BETWEEN  '" + ALLTRIM(mv_par01) + "' AND '" + ALLTRIM(mv_par02) + "'"
CQuery += " AND CK_NUM  = CJ_NUM"
cQuery += " ORDER BY CJ_NUM"
cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasSCJ,.F.,.T.)

dbselectarea(cAliasSCJ)  
COUNT TO nRegs
//Procregua( nRegs )
(cAliasSCJ)->(dbGoTop())

While !(cAliasSCJ)->(Eof())
	
		IF (cAliasSCJ)->CJ_MOEDA  == 2    //1
			cMoeda := " USD - US DOLLAR"
		ELSEIF (cAliasSCJ)->CJ_MOEDA  == 3                         
			cMoeda := " EUR - €  EURO"
		ELSE
			cMoeda := " MXP - $  PESOS"
		ENDIF

		IF  Empty((cAliasSCJ)->CJ_CLIENTE)
			cCTE     := (cAliasSCJ)->CJ_PROSPE
			cLoja    := (cAliasSCJ)->CJ_LOJAPRO			
		Else
			cCTE     := (cAliasSCJ)->CJ_CLIENTE
			cLoja    := (cAliasSCJ)->CJ_LOJA
		Endif
		
		If cPedido <> (cAliasSCJ)->CJ_NUM			
	        
	        if nPag <>1
				Totales()
				ImpPiePagina(2)			
			    nPag+=1
				oPrint:EndPage()
			Endif
				oPrint:StartPage()
				nLin := 0200						
		    	xcabec()	    
		ENDIF
	
		If	( nLin >= 2000 )
			ImpPiePagina(1)
			oPrint:EndPage()
			oPrint:StartPage()
			nPag ++         
			nLin := 0200
			xCabec() 		
		EndIf

		cPedido  := (cAliasSCJ)->CJ_NUM
		cMoeda1  := (cAliasSCJ)->CJ_MOEDA


		nFacConv	:= Posicione("SB1", 1, xFilial("SB1") + (cAliasSCJ)->CK_PRODUTO, "B1_CONV")     		//Factor de Conversion
		nTipConv	:= Posicione("SB1", 1, xFilial("SB1") + (cAliasSCJ)->CK_PRODUTO, "B1_TIPCONV")
		Unid		:= Posicione("SB1", 1, xFilial("SB1") + (cAliasSCJ)->CK_PRODUTO, "B1_UM") 
		ProdU		:= Posicione("SB1", 1, xFilial("SB1") + (cAliasSCJ)->CK_PRODUTO, "B1_LOCALIZ") 			//Asigna el valor de la localizacion
	
		IF !Empty((cAliasSCJ)->CK_TES)
			cImp    := Posicione("SFC", 1, xFilial("SFC") + (cAliasSCJ)->CK_TES, "FC_IMPOSTO")			//(cAliasSC5a)->FB_ALIQ       //TODO
			nImp    := Posicione("SFB", 1, xFilial("SFB") + cImp, "FB_ALIQ")			//(cAliasSC5a)->FB_ALIQ       //TODO
		Else
		    nImp	:= 0
		Endif
		//Si se tiene descuento se toma el campo 
		If (cAliasSCJ)->CK_VALDESC > 0
			nValUnit 	:= (cAliasSCJ)->CK_PRUNIT
		Else 	                                 
			nValUnit 	:= (cAliasSCJ)->CK_PRCVEN
		EndIf	

		cUM 	 	:= (cAliasSCJ)->CK_UM                             										//Unidad de medida
		nCant    	:= (cAliasSCJ)->CK_QTDVEN                                                          		//Cantidad

/*		
		If Unid == 'CA'                                                           			   			//Unidad de medida en DESARROLLO  'CA' para PRODUCCION
			If nTipConv == 'M'
				nCant	 := (cAliasSCJ)->CK_QTD2UM 
				nValUnit := (nValUnit / nFacConv ) 
				cUM 	 := (cAliasSCJ)->CK_2UM															//Posicione("SB1", 1, xFilial("SB1") + (cAliasSCJ)->CK_PRODUTO, "B1_SEGUM") 
			Else
				nValUnit := (nValUnit * nFacConv )
				cUM 	 := (cAliasSCJ)->CK_QTD2UM														//Posicione("SB1", 1, xFilial("SB1") + (cAliasSCJ)->CK_PRODUTO, "B1_SEGUM") 	
			EndIf  
		EndIf 
*/
		oPrint:Say(nLin,0030,Transform(nCant,"@E 9,999,999.99"),oFont12C)    								//Cantidad

		oPrint:Say(nLin,0300,cUM,oFont12C)          										   				//Unidad de Medida
	//	oPrint:Say(nLin,0400,(cAliasSCJ)->CK_LOCAL,oFont08CN)       										//Deposito
		oPrint:Say(nLin,0400,(cAliasSCJ)->CK_PRODUTO,oFont12C)     										//Codigo Producto
		oPrint:Say(nLin,0750,SUBSTR(Posicione("SB1",1,xFilial("SB1") + (cAliasSCJ)->CK_PRODUTO ,"B1_DESC"),1,60),oFont12C) //Descr. Producto
	
		oPrint:Say(nLin,1650,Transform(nValUnit,"@E 999,999,999.99"),oFont12C) //Precio Unitario
		oPrint:Say(nLin,2000,Transform(nValUnit * nCant,"@E 9,999,999.99"),oFont12C)    //Total
		nTMerc   += nCant * nValUnit
		nValV	:= nValV+(cAliasSCJ)->CK_VALOR
		nLin += 50
	

		If (cAliasSCJ)->CK_Obs <> " "
			oPrint:Say(nLin,0850,(cAliasSCJ)->CK_Obs,oFont12C)
			nLin += 50
		Endif
	
	
		nTSeg     := (cAliasSCJ)->CJ_SEGURO
		nTGas	  := (cAliasSCJ)->CJ_DESPESA
		nTFle     := (cAliasSCJ)->CJ_FRETE
		nValDes	  := (cAliasSCJ)->CK_VALDESC
		nTDes     += (cAliasSCJ)->CK_VALDESC			//(cAliasSCJ)->CK_VALDESC //* (cAliasSCJ)->CK_QTDVEN
	
		nIvaItem += round((((nCant * nValUnit)-nValDes) * (nImp/100)),2)			
		
		nTxMoeda  := (cAliasSCJ)->CJ_TXMOEDA	
		
		cComents  := Alltrim((cAliasSCJ)->CJ_MENNOTA)

		nTImp     += 0

	//    IncProc("Generando Informe...."+(cAliasSCJ)->CJ_NUM)	
		(cAliasSCJ)->(dbSkip())	
	
		IF (cPedido <> (cAliasSCJ)->CJ_NUM)		
			Totales()		
			ImpPiePagina(2)			
		EndIf
EndDo    
	oPrint:EndPage()
	
	(cAliasSCJ)->(dbCloseArea())
	//(cAliasSCJa)->(dbCloseArea())
	//(cAliasSC5b)->(dbCloseArea())
	RestArea(aArea)
	oPrint:EndPage()
Return      



Static function DatCliPros(_cCliProsp)
    __aArea:= GetArea() 		                                           
	IF !Empty(_cCliProsp)          
		DbSelectArea("SA1")
		DbSetOrder(1)
		IF Dbseek(xFilial("SA1")+cCTE+cLoja)	
			cNomeCli :=	SA1->A1_NOME
			cDirCli	 :=	SA1->A1_END
			cMunCli  :=	SA1->A1_MUN
			cEstCli	 :=	SA1->A1_EST
			cColCli	 :=	SA1->A1_BAIRRO
			cCPCli	 :=	SA1->A1_CEP
			cTelCli  := SA1->A1_TEL
			cRFCCli	 := SA1->A1_CGC
			cContCli := SA1->A1_CONTATO
		Else
 			MsgInfo("No Encontró Cliente")		
		
		Endif
	Else
		DbSelectArea("SUS")
		DbSetOrder(1)
		IF Dbseek(xFilial("SUS")+cCTE+cLoja)		
			cNomeCli :=	SUS->US_NOME
			cDirCli	 :=	SUS->US_END
			cMunCli  :=	SUS->US_MUN
			cEstCli	 :=	SUS->US_EST
			cColCli	 :=	SUS->US_BAIRRO
			cCPCli	 :=	SUS->US_CEP
			cTelCli  := SUS->US_TEL
			cRFCCli	 := SUS->US_CGC
			cContCli := SUS->US_CONTATO
		Endif
	Endif  
	RestArea(__aArea)
Return
      
//Funcion x Cabec
//Descripcion: Funcion encargada de imprimir el 
Static Function xCabec()

Local nCX := 0

		DatCliPros((cAliasSCJ)->CJ_CLIENTE)		//BUSCA DATOS DE CLIENTE O PROSPECTO

		oPrint:SayBitmap(200,100,cFileLogoR,340,200)
//		oPrint:Say(0050,2300,IIF(mv_par03 = 1,"Pagina ", "Page ") + STRZERO(nPage,2),oFont10)		  //Numero de pagina

//		oPrint:Say(nLin,0600, SM0->M0_CODFIL+"  " +SM0->M0_FILIAL,oFont08CN)
		oPrint:Say(nLin,0600, SM0->M0_NOMECOM,oFont18n)		
		oPrint:Say(nLin,1580,IIF(mv_par03 = 1,"PRESUPUESTO DE VENTA","SALES BUDGET"),oFont18n)
		nLin+=50
		oPrint:Say(nLin,0600, SM0->M0_ENDENT,oFont12CN)
		nLin+=50
		oPrint:Say(nLin,0600, Alltrim(SM0->M0_CIDENT)+", " +SM0->M0_ESTENT+",MEXICO",oFont12CN)
		oPrint:Say(nLin,1580,IIF(mv_par03 = 1,"No. Presupuesto:","Budget Number:"),oFont12CN)
		oPrint:Say(nLin,2000,(cAliasSCJ)->CJ_NUM,oFont15CN,RGB(255,000,000),,2)                 //No. Cotizacion

		nLin+=50
		oPrint:Say(nLin,0600, "C.P. " +SM0->M0_CEPENT,oFont12CN)
		nLin+=50
		oPrint:Say(nLin,0600, "Tel.\Fax.: " + Alltrim(SM0->M0_TEL),oFont12CN)
		oPrint:Say(nLin,1580,IIF(mv_par03 = 1,"Fecha: ","Date: ") + DTOC(STOD((cAliasSCJ)->CJ_EMISSAO)) + IIF(mv_par03 = 1," Hora: ", "Hour: ") + TIME() + " hrs.",oFont12CN)		
		nLin+=50
		oPrint:Say(nLin,0600, IIF(mv_par03 = 1,"RFC: ","TIN: ")+SM0->M0_CGC,oFont12CN) //"CGC : ")		
		nLin+=50		
		oPrint:Say(nLin,0100,(cAliasSCJ)->CJ_CLIENTE +" - " + cNomeCli,oFont12CN)
		nLin+=50		
                                                              
   
		if nPag==1             
			oPrint:Say(nLin,0100,cDirCli,oFont12CN)
			oPrint:Say(nLin,1200,IIF(mv_par03 = 1,"Condicion Pago:", "Payments Conditions") ,oFont12CN)
			oPrint:Say(nLin,1580,(cAliasSCJ)->CJ_CONDPAG + " " + Posicione("SE4",1,xFilial("SE4") + (cAliasSCJ)->CJ_CONDPAG ,"E4_DESCRI"),oFont12CN)
			nLin+=50
			oPrint:Say(nLin,0100,cColCli,oFont12CN)                           
			oPrint:Say(nLin,1200,IIF(mv_par03 = 1,"Moneda:", "Currency"),oFont12CN)
			oPrint:Say(nLin,1580,Alltrim(Transform((cAliasSCJ)->CJ_MOEDA,"@E 99") + cMoeda ),oFont12CN) 		
			nLin+=50			


			oPrint:Say(nLin,0100,AllTrim(cMunCli) + ", " +cEstCli,oFont12CN)  
			oPrint:Say(nLin,1200,IIF(mv_par03 = 1,"Contacto:","Contact:"),oFont12CN)			
			oPrint:Say(nLin,1580,cContCli,oFont12CN)  
			nLin+=50                                                                        
			oPrint:Say(nLin,0100,IIF(mv_par03 = 1,"C.P. ","Postal Code") + cCPCli,oFont12CN)  
			oPrint:Say(nLin,1200,IIF(mv_par03 = 1,"Vendedor:","Seller"),oFont12CN)
			oPrint:Say(nLin,1580,Posicione("SA3",1,xFilial("SA3") + (cAliasSCJ)->CJ_VEND ,"A3_NOME"),oFont12CN) 		
			nLin+=50                                                                        
			oPrint:Say(nLin,0100,"Tel. "+cTelCli,oFont12CN)  
			nLin+=50
	    Endif

		oPrint:Line(nLin,0050,nLin,2200)
		nLin+=50                       
		IF mv_par03  = 1
			oPrint:Say(nLin,0090,"Cantidad",oFont10n)
			oPrint:Say(nLin,0280,"UM",oFont10n)
  //		oPrint:Say(nLin,0400,"Dep.",oFont10n)
			oPrint:Say(nLin,0400,"Codigo",oFont10n)
			oPrint:Say(nLin,0750,"Descripcion",oFont10n)
			oPrint:Say(nLin,1755,"Precio",oFont10n)
			oPrint:Say(nLin,2090,"Total",oFont10n)
			nLin+=50
			oPrint:Line(nLin,0050,nLin,2200)                                                                            			
			nLin+=50
		Else
			oPrint:Say(nLin,0090,"Quant",oFont10n)
			oPrint:Say(nLin,0280,"UM",oFont10n)
//			oPrint:Say(nLin,0400,"Dep.",oFont10n)
			oPrint:Say(nLin,0400,"Code",oFont10n)
			oPrint:Say(nLin,0750,"Description",oFont10n)
			oPrint:Say(nLin,1755,"U Price",oFont10n)
			oPrint:Say(nLin,2090,"Total",oFont10n)
			nLin+=50
			oPrint:Line(nLin,0050,nLin,2200)                                                                            			
			nLin+=50		
		Endif
Return
             

Static Function Totales
Local y := 0
			//***************************************		
			nLin:= 2000
			oPrint:Line(nLin,0050,nLin,2200)
			nLin += 50			
			//Impresion de Flete
			If ntFle > 0
				oPrint:Say(nLin,1700,IIF(mv_par03 = 1,"Flete:","Freight:"),oFont12)   
				oPrint:Say(nLin,2000,Transform(ntFle,"@E 9,999,999.99"),oFont12CN,,) 
				nLin += 50 
			EndIf 
		
			//Impresion de Seguro
			If nTSeg > 0
				oPrint:Say(nLin,1700,IIF(mv_par03 = 1,"Seguro:", "Insurance"),oFont12)   
				oPrint:Say(nLin,2000,Transform(nTSeg,"@E 9,999,999.99"),oFont12CN,,) 
				nLin += 50 
			EndIf 
			
			//Impresion de Gastos
			If nTGas > 0
				oPrint:Say(nLin,1700,IIF(mv_par03 = 1,"Gastos:","Expenses:"),oFont12)   
				oPrint:Say(nLin,2000,Transform(nTGas,"@E 9,999,999.99"),oFont12CN,,) 
				nLin += 50 
			EndIf		
			
			nsTotal := nTMerc + ntFle + nTSeg + nTGas    
			
//			oPrint:Say(nLin,0200,IIF(mv_par03 = 1,"Total Unidades:", "Total Units:"),oFont12)
//			oPrint:Say(nLin,0500,Transform(nTuni,"@E 9,999,999.99"),oFont12CN,,)

			cValidez1:= "LA VALIDEZ DE ESTA COTIZACION ES PARA ACEPTACION INMEDIATA" 
			cValidez2:= "FLETES FORANEOS POR COBRAR"
		    cValidez4:= "SUJETO AL TIPO DE CAMBIO DEL DIA"
	
			oPrint:Say(nLin,1700,"Total:",oFont12)
			oPrint:Say(nLin,2000,Transform(nsTotal,"@E 9,999,999.99"),oFont12CN,,)
			oPrint:Say(nLin,0100,cValidez1,oFont12)
			nLin += 50
//			oPrint:Say(nLin,0200,IIF(mv_par03 = 1,"Tipo de Cambio:", "Exchange Rate:"),oFont12)
			
			nMoneda:= UPPER(GETMV("MV_MOEDAP" + AllTrim(Str(cmoeda1))))
			//     lc_Moneda:= UPPER(GETMV("MV_MOEDAP" + AllTrim(Str(SF2->F2_MOEDA))))
			If  cmoeda1 == 1
				cMoneda := "M.N."
				cIdio   := "2"
			ElseIF cMoeda1 == 2
				cMoneda := "USD"
				cIdio   := "3"
			ElseIF cMoeda1 == 3
				cMoneda := "EUR"
				cIdio   := "4"
			EndIf             

		    cValidez3:= "LOS PRECIOS SON EN "+cMoeda +" "+ IIF(cMoeda1 <> 1,cValidez4,"")
			
//			oPrint:Say(nLin,0500,Transform(nTxMoeda,"@E 9,999,999.99"),oFont12CN,,RGB(0,0,0))		
			nCX := 27            
			nTDes:=  nsTotal - nValV 
			oPrint:Say(nLin,1700,IIF(mv_par03 = 1,"Descuento:","Discount :"),oFont12)		
			oPrint:Say(nLin,2000 ,Transform(nTDes,"@E 9,999,999.99"),oFont12CN,,RGB(0,0,0))
			oPrint:Say(nLin,0100,cValidez2,oFont12)
			nCX := 47
			nLin += 50
			oPrint:Say(nLin,1700,"SubTotal:",oFont12)
			oPrint:Say(nLin,0100,cValidez3,oFont12)
			nCX := 67
			nTot1 := nsTotal - nTDes
			oPrint:Say(nLin,2000,Transform(nValV,"@E 9,999,999.99"),oFont12CN ,,RGB(0,0,0))   
			nLin += 50
			oPrint:Say(nLin,1700,IIF(mv_par03 = 1,"I.V.A.:", "TAX :"),oFont12)
			
			nCX := 94
			oPrint:Say(nLin,2000,Transform(nIvaItem,"@E 9,999,999.99"),oFont12CN,,RGB(0,0,0))
			nLin += 50
			oPrint:Say(nLin,1700,"Total:",oFont12n)
			_nTotal := nTot1 + nIvaItem
			
			oPrint:Say(nLin,2000,Transform(_nTotal,"@E 9,999,999.99"),oFont12CN,,RGB(0,0,0))
			nLin += 50
			//oPrint:Say(nLin,1000,nTot2,oFont12CN,,RGB(0,0,0))
			nLin += 50
							   		
			If Len(AllTrim(cComents)) > 0		
				oPrint:Say(nLin,0100,IIF(mv_par03 = 1,"Observaciones: ", "Comments :"), oFont10)
				If len(cComents) > 100
		   			nLoop := 1
					For y := 1 To Len(cComents) Step 100
						oPrint:Say(nLin,0360,SubStr(cComents,y,100),oFont10)
						nLin += 50
						nLoop++
					Next y
	   			Else
					oPrint:Say(nLin,0360,cComents,oFont10)
				Endif			
			EndIf
			
			nLin += 50
			nTMerc     := 0
			nTuni    := (cAliasSCJ)->CK_QTDVEN
			nTFle    := 0                                  
			nTSeg    := 0                                  
			nTGas	 := 0
			nTDes    := 0
			nTxMoeda := 0
			nTImp    := 0
			nTuni    := 0
			nTVol    := 0
			nTPes    := 0
			ntImp    := 0
			nImp     := 0    
			nValV    := 0              
			nIvaItem := 0		
			nPag ++
Return

Static Function AjustaSX1(cPerg)
Local i, j := 0
_sAlias := Alias()
dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,10)
aRegs:={}

aAdd(aRegs,{cPerg,"01","¨De Presupuesto?","¨De Presupuesto?","¨De Presupuesto?","mv_ch1","C",06,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SCJ","",""})
aAdd(aRegs,{cPerg,"02","¨A  Presupuesto?","¨A  Presupuesto?","¨A  Presupuesto?","mv_ch2","C",06,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SCJ","",""})
aAdd(aRegs,{cPerg,"03","Idioma"," Idioma?","Idioma?","mv_ch3","N",1,0,0,"C","","mv_par03","Español","Español","Español","","","Ingles","Ingles","Ingles","","","","","","","","","","","","","","","","","","",""})

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
dbSelectArea(_sAlias)
Return              



//FUNCIONESPARA ENVIAR PROPUESTA VIA CORREO
Static Function EnviaPropuesta

	// Copia el PDF final para la carpeta del servidor
		COPY FILE (oPrint:cPathPDF + ALLTRIM(cFilName)+".PDF") TO (cPDFProp + ALLTRIM(cFilName)+".PDF")  
	
		cRelto 	:= Alltrim(Posicione("SA1",1,xFilial("SA1")+cCTE + cLOJA, "A1_EMAIL"))		
		cNomeTo	:= Alltrim(Posicione("SA1",1,xFilial("SA1")+cCTE + cLOJA, "A1_NOME"))		
		
		IF Empty(cRelto)
			cRelTo	:= "alejandro.delosreyes@orbitas.mx"
		Endif
		
		IF Empty(cNometo)
			cNomeTo	:= "Falta Definir Nombre de Cliente"
		Endif
		
		//Se agrega en el caso de no existir correo
		cRelTo := Padr(cRelTo,200)
		cMensaje := cNomeTo + CHR(13) + CHR(10)
		cMensaje += CHR(13) + CHR(10)
		cMensaje += "Estimado(a):" + CHR(13) + CHR(10)
		cMensaje += CHR(13) + CHR(10)
		cMensaje += "Por este medio le estamos enviando La propuesta No.: " + cNumprop+ CHR(13) + CHR(10)
		cMensaje += "Dicho archivo lo puede ud. imprimir cuantas veces lo requiera. " + CHR(13) + CHR(10)
		cMensaje += CHR(13) + CHR(10)
		cMensaje += "Gracias por su confianza. " + CHR(13) + CHR(10)

		cBodyMsg := "<html>"
		cBodyMsg += "<head></head>"
		cBodyMsg += "<body>"
		cBodyMsg += "<div>"
		cBodyMsg += "<p><span>"+cNomeTo+"<o:p></o:p></span></p>"
		cBodyMsg += "<p><span>Estimado(a): <o:p></o:p></span></p>"
		cBodyMsg += "<p>Por este medio le estamos enviando la Propuesta, correspondiente al documento: " + cNumprop +" <o:p></o:p></span></p>"
		cBodyMsg += "<p><span>Gracias por su compra.<o:p></o:p></span></p>"
		cBodyMsg += "</div>"
		cBodyMsg += "</body>"
		cBodyMsg += "</html>"
	
		aAttach 	:= {}
		cRelFrom 	:= GetMV("MV_RELACNT")
		AAdd(aAttach, cPDFProp+cFilName+".PDF")
		aAtcBkp := AClone(aAttach)
		if ( MBSendMail(GetMV("MV_RELACNT"),GetMV("MV_RELPSW"),GetMV("MV_RELSERV"),cRelFrom,cRelTo,"Envio de Propuesta:  " + cFilName,cMensaje,cBodyMsg,aAttach) )
			ApMsgInfo("¡Propuesta enviada correctamente!", "Envío de Propuesta")
		else
			ApMsgStop("¡No se realizó el envío de la Propuesta!","Envío de Propuesta")
		endif
Return

// 				MBSendMail(GetMV("MV_RELACNT"),GetMV("MV_RELPSW"),GetMV("MV_RELSERV"),cRelFrom,cRelTo,"Envio de Propuesta:  " + cFilName,cMensaje,cBodyMsg,aAttach)
Static Function MBSendMail(cAccount			  ,cPassword         ,cServer            ,cFrom   ,cEmail,cAssunto                          ,cMensagem,cBodyMsg,xAttach)

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


Static Function ImpPiePagina(nOpcion)
	nLinPie	:= 2100
	IF nOpcion== 1 
		nLinPie+=500
	Else            
		nLinPie+=100			
		oPrint:SayBitmap(nLinPie,100,cLogoCuen,1000,400) // y,x,archivo,ancho,alto	
		nLinPie+=400					
    Endif		
		oPrint:SayBitmap(nLinPie,100,cLogoOfic,2000,400) // y,x,archivo,ancho,alto	
	
Return


