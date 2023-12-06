#Include "Protheus.ch"
#Include 'rwmake.ch'              
#Include 'colors.ch'
#Include 'stdwin.ch'
#Include 'TOTVS.ch'



/*

?
Funcion       COTFAT  Autor Alejandro de los Reyes  Fecha  08/08/2018 
?
Descripcion: Impresion Cotizacion de Venta en Facturacion  			  
                                                                       
?
Uso        SIGAFAT										              
?

|
*/

User Function PEDVTA(_nOrigen)
****************************

Local cPerg		:= "IMPPEDFAT "
Private oLeTxt
Private lEnd	:=.F.
Private nPag	:= 1
Private cEmp	:= "" 
Private cFilName	:= "PEDVTA"  
Private cPDFPed	:=  GetSrvProfString("Startpath","") + "PEDVTA\pdf01\"			
Private cNumped	:= ""
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
Private nDesc1    := 0
Private nDesc2    := 0
Private nDesCab   := 0
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
Private nIvaItem	:= 0
Private cObserva   	:= ""
Private cComents	:= ""
Private cPedimento  := ""
Private	cTipoEnt 	:= ""
Private	cPaquet		:= ""
Private	cTipoSer	:= ""
Private	cOrdenC		:= ""
Private cConvenio   := ""


Private cFileLogoR	:= GetSrvProfString('Startpath','') + 'LGMID'+cEmpAnt+'.png'


IF _nOrigen == 1		//NO MUESTRA INTERFACE
	mv_par01	:= SC5->C5_NUM
	mv_par02	:= SC5->C5_NUM
	cNumped	:= SC5->C5_NUM
	cFilName:= "PED"+ALLTRIM(MV_PAR01)
	Proceso(.F.)
Else
	AjustaSX1(cPerg)
	If	( ! Pergunte(cPerg,.T.) )
		Return
	Else
	cNumped	:= SC5->C5_NUM
	cFilName:= "PED"+ALLTRIM(MV_PAR01)+"_"+ALLTRIM(MV_PAR02)
	
	Endif
	@ 200,1 TO 400,400 DIALOG oLeTxt TITLE OemToAnsi("Pedido de Venta")
	@ 02,10 TO 080,190
	@ 10,018 Say " Pedido de Venta "
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
Private	oPrint		:= NIL //FWMsPrinter():New(ALLTRIM(cFilName)+".PDF",6,.T.,,.T.,,,,,,,.F.,)
//Private	oPrint	:= TMSPrinter():New(OemToAnsi('Presupuesto de Venta')),;

Private oBrush		:= TBrush():New(,4),;
oPen		:= TPen():New(0,5,CLR_BLACK),;
cFileLogoR	:= GetSrvProfString('Startpath','') + 'LGMID'+cEmpAnt+'.png',;
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
	oPrint:cPathPDF:= "C:\SPOOL\PEDIDOS\"

//	If nPag <> 1
//		Processa({|lEnd2| fImpRem(@lEnd2),OemToAnsi('Espere...')},OemToAnsi('Generando....'))
//	Else
		Processa({|lEnd2| fImpRem(@lEnd2),OemToAnsi('Espere...')},OemToAnsi('Generando....'))
//	Endif
	oPrint:Preview()
	
	IF ( MsgYesNo("Continuar con el envío de la Pedido por correo electrónico?") )
		EnviaPedido()
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
Private cAliasSC5  := GetNextAlias()


nTDes:=0
cQuery += " Select C5_CLIENTE,C5_CLIENT, C5_NUM,C5_CONDPAG, C5_TXMOEDA, C5_VEND1, C5_EMISSAO, C5_FRETE, C5_SEGURO ,C5_DESPESA, C5_CONDPAG, C5_MENNOTA, C5_ORDENC,"	
cQuery += " C5_MOEDA,C5_LOJACLI,C5_PESOL, C5_PBRUTO, C5_VOLUME1, C5_VEND1, C5_DESC1, C5_DESC2, C5_TIPOENT, C5_PAQUET, C5_TIPOSER, C5_CONVENI, C5_TIPOREM, "
cQuery += " C6_PRODUTO, C6_UM, C6_SEGUM, C6_QTDVEN, C6_PRCVEN, C6_PRUNIT,C6_LOCAL, C6_VALOR, C6_ENTREG, C6_UNSVEN, C6_OBS, TRIM(UTL_RAW.CAST_TO_VARCHAR2(C5_DESTINO)) DESTINO, "
cQuery += " C6_VALDESC, (C6_PRUNIT * C6_QTDVEN) nTOTAL,C6_TES, C6_DESCONT, "
cQuery += " A1_COD,  A1_LOJA, A1_NOME, A1_END, A1_MUN, A1_EST, A1_BAIRRO, A1_CEP, A1_TEL, A1_PAIS, A1_CGC,"
cQuery += " A1_NOME, A1_ENDENT, A1_BAIRROE, A1_MUNE, A1_ESTE, A1_CEPE, A1_CONTATO, A1_REGIAO"
cQuery += " FROM " +  RetSqlName("SC5") + " SC5," +  RetSqlName("SA1") + " SA1, " + RetSqlName("SC6") + " SC6"
cQuery += " WHERE SC5.D_E_L_E_T_ <> '*'"
cQuery += " AND   SA1.D_E_L_E_T_ <> '*'"
cQuery += " AND   SC6.D_E_L_E_T_ <> '*'"
cQuery += " AND C5_FILIAL    = '" + xFilial("SC5") + "'"
cQuery += " AND A1_FILIAL    = '" + xFilial("SA1") + "'"
cQuery += " AND C6_FILIAL    = '" + xFilial("SC6") + "'"
cQuery += " AND C5_NUM    BETWEEN  '" + ALLTRIM(mv_par01) + "' AND '" + ALLTRIM(mv_par02) + "'"
cQuery += " AND A1_COD 	= C5_CLIENTE"
cQuery += " AND A1_LOJA = C5_LOJACLI"
CQuery += " AND C6_NUM 	= C5_NUM"
cQuery += " ORDER BY C5_NUM"
cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasSC5,.F.,.T.)


dbselectarea(cAliasSC5)  
COUNT TO nRegs
//Procregua( nRegs )
(cAliasSC5)->(dbGoTop())

While !(cAliasSC5)->(Eof())
	
	IF (cAliasSC5)->C5_MOEDA  == 2    //1
		cMoeda := " USD - US DOLLAR"
	ELSEIF (cAliasSC5)->C5_MOEDA  == 3                         
		cMoeda := " EUR -   EURO"
	ELSE
		cMoeda := " MXP - $  PESOS"
	ENDIF
		
		If cPedido <> (cAliasSC5)->C5_NUM			
			cTipoEnt 	:= (cAliasSC5)->C5_TIPOENT
			cPaquet		:= (cAliasSC5)->C5_PAQUET
			cTipoSer	:= (cAliasSC5)->C5_TIPOSER
			cOrdenC		:= (cAliasSC5)->C5_ORDENC
			cConvenio	:= (cAliasSC5)->C5_CONVENI
			cDestino    := Alltrim((cAliasSC5)->DESTINO)

	        if nPag <>1
				Totales()
			    nPag+=1
				oPrint:EndPage()
			Endif
				oPrint:StartPage()
				nLin := 0200						
		    	xcabec()	    
		ENDIF
	
			If	( nLin >= 2750 )
			//	PiePagina()
				oPrint:EndPage()
				oPrint:StartPage()
				nPag ++         
				nLin := 0200
				xCabec() 		
			EndIf
	
			cPedido := (cAliasSC5)->C5_NUM
			cCTE   := (cAliasSC5)->C5_CLIENT
			cLoja   := (cAliasSC5)->C5_LOJACLI
			cMoeda1 := (cAliasSC5)->C5_MOEDA
	

			nFacConv	:= Posicione("SB1", 1, xFilial("SB1") + (cAliasSC5)->C6_PRODUTO, "B1_CONV")     		//Factor de Conversion
			nTipConv	:= Posicione("SB1", 1, xFilial("SB1") + (cAliasSC5)->C6_PRODUTO, "B1_TIPCONV")
			Unid		:=Posicione("SB1", 1, xFilial("SB1") + (cAliasSC5)->C6_PRODUTO, "B1_UM") 
			ProdU		:=Posicione("SB1", 1, xFilial("SB1") + (cAliasSC5)->C6_PRODUTO, "B1_LOCALIZ") 			//Asigna el valor de la localizacion
		
			IF !Empty((cAliasSC5)->C6_TES)
				cImp    := Posicione("SFC", 1, xFilial("SFC") + (cAliasSC5)->C6_TES, "FC_IMPOSTO")			//(cAliasSC5a)->FB_ALIQ       //TODO
				nImp    := Posicione("SFB", 1, xFilial("SFB") + cImp, "FB_ALIQ")			//(cAliasSC5a)->FB_ALIQ       //TODO
			Else
			    nImp	:= 0
			Endif
			//Si se tiene descuento se toma el campo 
			If (cAliasSC5)->C6_PRUNIT > 0 .AND. ((cAliasSC5)->C6_VALDESC > 0 .OR. ((cAliasSC5)->C5_DESC1 > 0 .OR. (cAliasSC5)->C5_DESC2 > 0))  
				nValUnit 	:= (cAliasSC5)->C6_PRUNIT
			Else 	                                 
				nValUnit 	:= (cAliasSC5)->C6_PRCVEN
			EndIf	

			cUM 	 	:= (cAliasSC5)->C6_UM                             										//Unidad de medida
			nCant    	:= (cAliasSC5)->C6_QTDVEN                                                          		//Cantidad
			
			
			nTValUnit	:= nValUnit * nCant                                    //Calcula el Importe Precio Unitario * Cantidad (Sin descuentos)		

		oPrint:Say(nLin,0030,Transform(nCant,"@E 9,999,999.99"),oFont12C)    								//Cantidad

		oPrint:Say(nLin,0300,cUM,oFont12C)          										   				//Unidad de Medida
	//	oPrint:Say(nLin,0400,(cAliasSC5)->CK_LOCAL,oFont08CN)       										//Deposito
		oPrint:Say(nLin,0400,(cAliasSC5)->C6_PRODUTO,oFont12C)     										//Codigo Producto
		oPrint:Say(nLin,0750,SUBSTR(Posicione("SB1",1,xFilial("SB1") + (cAliasSC5)->C6_PRODUTO ,"B1_DESC"),1,60),oFont12C) //Descr. Producto
	
		oPrint:Say(nLin,1650,Transform(nValUnit,"@E 999,999,999.99"),oFont12C) //Precio Unitario
		oPrint:Say(nLin,2000,Transform(nTValUnit,"@E 9,999,999.99"),oFont12C)    //Total
		nTMerc   += nTValUnit      
		nValV	 += (cAliasSC5)->C6_VALOR
		nLin += 40
	    cObs := Alltrim((cAliasSC5)->C6_Obs) 
		If cObs <> ""
			oPrint:Say(nLin,0750,"("+cObs+")",oFont12C)
			nLin += 50
		Endif
	    
		nTSeg     := (cAliasSC5)->C5_SEGURO
		nTGas	  := (cAliasSC5)->C5_DESPESA
		nTFle     := (cAliasSC5)->C5_FRETE
		nValDes	  := (cAliasSC5)->C6_VALDESC
		
		If  (cAliasSC5)->C6_VALDESC > 0 .OR. ((cAliasSC5)->C5_DESC1 > 0 .OR. (cAliasSC5)->C5_DESC2 > 0)  
			nDesc1	 := nTValUnit*((cAliasSC5)->C5_DESC1/100) 
			nDesc2	 := (nTValUnit-nDesc1) *((cAliasSC5)->C5_DESC2/100)
			nDesCab	 := nDesc1+nDesc2
			nTDes	 += nDesCab 			//Descuento Cabecera
		   	nTDes	 += (cAliasSC5)->C6_VALDESC   //Descuento Total
		   	nValDes  := nDesCab+(cAliasSC5)->C6_VALDESC	//desscuento a nivel item 	  						
		EndIf	
		nIvaItem += round((((nCant * nValUnit)-nValDes) * (nImp/100)),2)			
		
		nTxMoeda  := (cAliasSC5)->C5_TXMOEDA	
		
		cComents  := Alltrim((cAliasSC5)->C5_MENNOTA)
		nTImp     += 0

		(cAliasSC5)->(dbSkip())	
	
		IF (cPedido <> (cAliasSC5)->C5_NUM)		
			Totales()		
		EndIf
EndDo    
	oPrint:EndPage()
	
	(cAliasSC5)->(dbCloseArea())
	RestArea(aArea)
	oPrint:EndPage()
Return      
      
//Funcion x Cabec
//Descripcion: Funcion encargada de imprimir el 
Static Function xCabec()
Local nCX := 0
Local nCol2	:= 1300
Local iCont := 1
Local cTipoPed :=IIF((cAliasSC5)->C5_TIPOREM=="0","PEDIDO DE VENTA","PEDIDO DE MUESTRA")
		oPrint:SayBitmap(200,100,cFileLogoR,340,200)
//		oPrint:Say(0050,2300,IIF(mv_par03 = 1,"Pagina ", "Page ") + STRZERO(nPage,2),oFont10)		  //Numero de pagina

//		oPrint:Say(nLin,0600, SM0->M0_CODFIL+"  " +SM0->M0_FILIAL,oFont08CN)
		oPrint:Say(nLin,0600, SM0->M0_NOMECOM,oFont18n)		
		oPrint:Say(nLin,1580,cTipoPed,oFont18n)
		nLin+=50
		oPrint:Say(nLin,0600, SM0->M0_ENDENT,oFont12CN)
		nLin+=50
		oPrint:Say(nLin,0600, Alltrim(SM0->M0_CIDENT)+", " +SM0->M0_ESTENT+",MEXICO",oFont12CN)
		oPrint:Say(nLin,1580,"No. Pedido:",oFont12CN)
		oPrint:Say(nLin,2000,(cAliasSC5)->C5_NUM,oFont15CN,RGB(255,000,000),,2)                 //No. Cotizacion

		nLin+=50
		oPrint:Say(nLin,0600, "C.P. " +SM0->M0_CEPENT,oFont12CN)
		nLin+=50
		oPrint:Say(nLin,0600, "Tel.\Fax.: " + Alltrim(SM0->M0_TEL),oFont12CN)
		oPrint:Say(nLin,1580,"Fecha: " + DTOC(STOD((cAliasSC5)->C5_EMISSAO)) + " Hora: " + TIME() + " hrs.",oFont12CN)		
		nLin+=50
		oPrint:Say(nLin,0600,"RFC: "+SM0->M0_CGC,oFont12CN) //"CGC : ")		
		nLin+=50		
		oPrint:Say(nLin,0100,(cAliasSC5)->C5_CLIENTE +" - " + (cAliasSC5)->A1_NOME,oFont12CN)
		nLin+=50		
   		oPrint:Say(nLin,0100,(cAliasSC5)->A1_CGC,oFont12CN)
		nLin+=50
		if nPag==1             
		   //	nLin+=50		
			oPrint:Say(nLin,0100,(cAliasSC5)->A1_END,oFont12CN)
			oPrint:Say(nLin,nCol2,"Condicion Pago:" ,oFont12CN)
			oPrint:Say(nLin,1580,(cAliasSC5)->C5_CONDPAG + " " + Posicione("SE4",1,xFilial("SE4") + (cAliasSC5)->C5_CONDPAG ,"E4_DESCRI"),oFont12CN)
			nLin+=50
			oPrint:Say(nLin,0100,(cAliasSC5)->A1_BAIRRO,oFont12CN)                           
			oPrint:Say(nLin,nCol2,"Moneda:",oFont12CN)
			oPrint:Say(nLin,1580,Alltrim(Transform((cAliasSC5)->C5_MOEDA,"@E 99") + cMoeda ),oFont12CN) 		
			nLin+=50			
			oPrint:Say(nLin,0100,AllTrim((cAliasSC5)->A1_MUN) + ", " +(cAliasSC5)->A1_EST+" C.P."+(cAliasSC5)->A1_CEP,oFont12CN)  
			oPrint:Say(nLin,nCol2,"Contacto:",oFont12CN)			
			oPrint:Say(nLin,1580,(cAliasSC5)->A1_CONTATO,oFont12CN)  
			/*
  			oPrint:Say(nLin,1200,"Lista Precios:",oFont10)			
			oPrint:Say(nLin,1580,(cAliasSC5)->CJ_TABELA,oFont10)                            
			*/
			nLin+=50                                                                        
			oPrint:Say(nLin,0100,"Tel. "+(cAliasSC5)->A1_TEL,oFont12CN)  
			oPrint:Say(nLin,nCol2,"Vendedor:",oFont12CN)
			oPrint:Say(nLin,1580,Posicione("SA3",1,xFilial("SA3") + (cAliasSC5)->C5_VEND1 ,"A3_NOME"),oFont12CN) 		
			nLin+=30                                                                        
			oPrint:Line(nLin,0050,nLin,2200)
			nLin+=30                                                                        
			oPrint:Say(nLin,0100,"Tipo de Entrega: ",oFont12CN)  
			oPrint:Say(nLin,0450,POSICIONE("SX5",1, xFilial("SX5")+"Z1"+cTipoEnt,"SX5->X5_DESCSPA"),oFont12CN)  
			oPrint:Say(nLin,nCol2,"Paqueteria:",oFont12CN)
			oPrint:Say(nLin,1520,POSICIONE("SX5",1,xFilial("SX5")+"Z2"+cPaquet,"SX5->X5_DESCSPA"),oFont12CN) 		
			nLin+=50
			oPrint:Say(nLin,0100,"Tipo de Servicio :",oFont12CN)  
			oPrint:Say(nLin,0450,cTipoSer,oFont12CN)  
			oPrint:Say(nLin,nCol2,"Convenio :",oFont12CN)  
			oPrint:Say(nLin,1520,cConvenio,oFont12CN)  
			nLin+=50
			oPrint:Say(nLin,0100,"Destino:",oFont12CN)
			oPrint:Say(nLin,ncol2,"Orden Compra :",oFont12CN)  
			oPrint:Say(nLin,1520,cOrdenc,oFont12CN)  
			if !empty(Alltrim(cDestino))    
				nLines := MLCount(cDestino,45,0,.T.)
				nLin-=50		
				For iCont := 1 To nLines
					IF !EMPTY(MemoLine(cDestino,,iCont))															
						oPrint:Say(nLin+(iCont*40),450,ALLTRIM(MemoLine(cDestino,,iCont)),oFont12CN)
					ENDIF
				Next iCont			
				nLin+=(nLines*40)	
			endif
	    Endif
		nLin+=50                       
		oPrint:Line(nLin,0050,nLin,2200)
		nLin+=50                       
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
Return
             

Static Function Totales
Local y:= 0
			//***************************************		
			nLin:= 2700
			oPrint:Line(nLin,0050,nLin,2200)
			nLin += 50			
			//Impresion de Flete
			If ntFle > 0
				oPrint:Say(nLin,1700,"Flete:",oFont12)   
				oPrint:Say(nLin,2000,Transform(ntFle,"@E 9,999,999.99"),oFont12CN,,) 
				nLin += 50 
			EndIf 
		
			//Impresion de Seguro
			If nTSeg > 0
				oPrint:Say(nLin,1700,"Seguro:",oFont12)   
				oPrint:Say(nLin,2000,Transform(nTSeg,"@E 9,999,999.99"),oFont12CN,,) 
				nLin += 50 
			EndIf 
			
			//Impresion de Gastos
			If nTGas > 0
				oPrint:Say(nLin,1700,"Gastos:",oFont12)   
				oPrint:Say(nLin,2000,Transform(nTGas,"@E 9,999,999.99"),oFont12CN,,) 
				nLin += 50 
			EndIf		
			
			nsTotal := nTMerc + ntFle + nTSeg + nTGas
			oPrint:Say(nLin,0200,"Total Unidades:",oFont12)
			oPrint:Say(nLin,0500,Transform(nTuni,"@E 9,999,999.99"),oFont12CN,,)
	
			oPrint:Say(nLin,1700,"Total:",oFont12)
			oPrint:Say(nLin,2000,Transform(nsTotal,"@E 9,999,999.99"),oFont12CN,,)
			nLin += 50
			oPrint:Say(nLin,0200,"Tipo de Cambio:",oFont12)
			
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
			
			oPrint:Say(nLin,0500,Transform(nTxMoeda,"@E 9,999,999.99"),oFont12CN,,RGB(0,0,0))		
			nCX := 27            
			nTDes:=  nsTotal - nValV 
			oPrint:Say(nLin,1700,"Descuento:",oFont12)		
			oPrint:Say(nLin,2000 ,Transform(nTDes,"@E 9,999,999.99"),oFont12CN,,RGB(0,0,0))
			nCX := 47
			nLin += 50
			oPrint:Say(nLin,1700,"SubTotal:",oFont12)
			nCX := 67
			nTot1 := nsTotal - nTDes
			oPrint:Say(nLin,2000,Transform(nValV,"@E 9,999,999.99"),oFont12CN ,,RGB(0,0,0))   
			nLin += 50
			oPrint:Say(nLin,1700,"I.V.A.:",oFont12)
			
			//Calculo del IVA
			/*
			IF nImp <> 0
				nTImp  :=  ((nTot1 * nImp)/100)
			endif 
			*/
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
				oPrint:Say(nLin,0100,"Observaciones: ", oFont10)
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
			nTuni    := 0 //(cAliasSC5)->CK_QTDVEN
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

aAdd(aRegs,{cPerg,"01","De Pedido ?","De Pedido ?","De Pedido ?","mv_ch1","C",06,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SC5","",""})
aAdd(aRegs,{cPerg,"02","A  Pedido ?","A  Pedido ?","A  Pedido ?","mv_ch2","C",06,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SC5","",""})

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



//FUNCIONES PARA ENVIAR PEDIDO VIA CORREO
Static Function EnviaPedido

	// Copia el PDF final para la carpeta del servidor
		COPY FILE (oPrint:cPathPDF + ALLTRIM(cFilName)+".PDF") TO (cPDFPed + ALLTRIM(cFilName)+".PDF")  
	
		cRelto 	:= Alltrim(Posicione("SA1",1,xFilial("SA1")+cCTE + cLOJA, "A1_EMAIL"))		
		cNomeTo	:= Alltrim(Posicione("SA1",1,xFilial("SA1")+cCTE + cLOJA, "A1_NOME"))		
		
		IF Empty(cRelto)
			cRelTo	:= "alejandro.delosreyes@hotmail.com"
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
		cMensaje += "Por este medio le estamos enviando El Pedido No.: " + cNumped+ CHR(13) + CHR(10)
		cMensaje += "Dicho archivo lo puede ud. imprimir cuantas veces lo requiera. " + CHR(13) + CHR(10)
		cMensaje += CHR(13) + CHR(10)
		cMensaje += "Gracias por su confianza. " + CHR(13) + CHR(10)

		cBodyMsg := "<html>"
		cBodyMsg += "<head></head>"
		cBodyMsg += "<body>"
		cBodyMsg += "<div>"
		cBodyMsg += "<p><span>"+cNomeTo+"<o:p></o:p></span></p>"
		cBodyMsg += "<p><span>Estimado(a): <o:p></o:p></span></p>"
		cBodyMsg += "<p>Por este medio le estamos enviando el Pedido correspondiente al documento: " + cNumped +" <o:p></o:p></span></p>"
		cBodyMsg += "<p><span>Gracias por su compra.<o:p></o:p></span></p>"
		cBodyMsg += "</div>"
		cBodyMsg += "</body>"
		cBodyMsg += "</html>"
	
		aAttach 	:= {}
		cRelFrom 	:= GetMV("MV_RELACNT")
		AAdd(aAttach, cPDFPed+cFilName+".PDF")
		aAtcBkp := AClone(aAttach)
		if ( MBSendMail(GetMV("MV_RELACNT"),GetMV("MV_RELPSW"),GetMV("MV_RELSERV"),cRelFrom,cRelTo,"Envio de Pedido:  " + cFilName,cMensaje,cBodyMsg,aAttach) )
			ApMsgInfo("Pedido enviada correctamente!", "Envio de Pedido")
		else
			ApMsgStop("No se realizo el envio de la Pedido!","Envio de Pedido")
		endif
Return

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

//?
//Envia o mail para a lista selecionada. Envia como BCC para que a pessoa pense
//que somente ela recebeu aquele email, tornando o email mais personalizado.   
//

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
				Help(" ",1,"ATENCION",,cError+ " " + cEmailTo,4,5)
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


?
Funo     TelaEmail    Autor  Microsiga           Data 07/08/03  
?
Descrio Monta o e-mail para Cross-Posting                           
?
Uso	     Lista de Contatos                                           
?


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

+-----------------------------------------------------------------------+
Funo     ValEmail    Autor  Microsiga            Data 07/08/03  
+----------+------------------------------------------------------------
Descrio Valida o assunto e a mensagem do e-mail                     
+----------+------------------------------------------------------------
Uso           Lista de Contatos
+-----------------------------------------------------------------------+


/*/
Static Function ValEmail(cEmail,cMensagem)
	Local lRet	:= .F.

	//+---------------------------------------+
	//Valida se foi digitada o assunto.      
	//+---------------------------------------+
	if Empty(cEmail)
		Help(" ",1,"SEMEMAIL")
	else
        //+---------------------------------------+
        //Valida se foi digitada alguma mensagem.
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

+---------------------------------------------------------------------------
Funo     RemoveAnexo   Autor  Rafael M. Quadrotti     Data 07/08/03 
+----------+----------------------------------------------------------------
Descrio Remove o Anexo de arquivos para o email                         
+----------+----------------------------------------------------------------
Uso           Lista de Contatos                                           
+---------------------------------------------------------------------------


/*/
Static Function RemoveAnexo(aAttach,oAttach)
	if Len(aAttach) > 0
	   ADel(aAttach,oAttach:nAt)  			// deleta o item
	   ASize(aAttach, Len(aAttach) - 1) 	//redimensiona o array
	endif

	oAttach:SetArray(aAttach)
	oAttach:Refresh()
Return .T.

