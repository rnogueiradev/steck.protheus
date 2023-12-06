/*
+-----------------------------------------------------------------------+
| TOTVS MEXICO SA DE CV - Todos los derechos reservados.                |
|-----------------------------------------------------------------------|
|    Cliente:                                                           |
|    Archivo: EFAT005R.PRW                                              |
|   Objetivo: Impresión de Remisión de venta Modelo 1                   |
| Responable: Filiberto Pérez                                           |
|      Fecha: Junio del 2014                                            |
+-----------------------------------------------------------------------+
*/

#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "FONT.CH"                     

User Function EFAT005R()

Local cAreaA:=alias()
cPerg := "EFAT005E  " 

AjustaSX1()
Pergunte(cPerg,.F.)

	@ 200,1 TO 380,400 DIALOG oLeTxt TITLE OemToAnsi("Impresión de Remisión de Venta")
	@ 02,10 TO 080,190
	@ 10,018 Say " Este programa imprime el formato de Remisión de venta de acuerdo a  "
	@ 18,018 Say " los parámetros informados por el usuario.                           "
	@ 26,018 Say "                                                                     "
	
	@ 65,098 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg) 
	@ 65,128 BMPBUTTON TYPE 01 ACTION Reimprime()
	@ 65,158 BMPBUTTON TYPE 02 ACTION Close(oLeTxt)
	
Activate Dialog oLeTxt Centered
RETURN

static function REIMPRIME()
Processa({|lEnd|MontaRel()})
return

// FUNCION PRINCIPAL PARA IMPRESION DEL REPORTE
Static Function MontaRel()
local iNum       		:= 0
local iNumMax    		:= 17
local iCont       	:= 0
Local cDescripcion	:= ""
Local cNumSer			:= ""  
Local cQuery			:= ""
local nLines			:= 0

Private mes 		:= 0
Private ano 		:= space(4)
Private meses		:= {'Enero','Febrero','Marzo','Abril','Mayo','Junio','Julio','Agosto','Septiembre','Octubre','Noviembre','Diciembre'}
Private nom_mes	:= space(15) 
private oPrint	:= nil
private oBrush

private nPagNum 	:= 0
Private nRenIni  	:= 100 
Private nColIni  	:= 20 
Private nLin     	:= nRenIni+800
Private nLimDet		:= 2600

Private oArial10		:= TFont():New("Lucida Console",10,10,,.F.,,,,.T.,.F.)
Private oArial10N	:= TFont():New("Lucida Console",10,10,,.T.,,,,.T.,.F.)
Private oBrushGray	:= TBrush():New(,12632256) 

//Private cLogoCli	:=  GetSrvProfString("Startpath","") + "TOTVS.png"	
Private cLogoCli	:= GetSrvProfString('Startpath','') + 'LGMID'+cEmpAnt+'.png'
aArea:=Getarea()
oFont6  	:= TFont():New("Arial",9, 6,.T.,.F.,5,.T.,5,.T.,.F.)
oFont8  	:= TFont():New("Arial",9, 8,.T.,.F.,5,.T.,5,.T.,.F.)
oFont8n  	:= TFont():New("Arial",9, 8,.T.,.T.,5,.T.,5,.T.,.F.) 
oFont9x 	:= TFont():New("Arial",8,8,.T.,.F.,5,.T.,5,.T.,.F.)
oFont9 		:= TFont():New("Arial",9,9,.T.,.F.,5,.T.,5,.T.,.F.)
oFont10 	:= TFont():New("Arial",9,10,.T.,.F.,5,.T.,5,.T.,.F.)
oFont10n	:= TFont():New("Arial",9,10,.T.,.T.,5,.T.,5,.T.,.F.)
oFont12 	:= TFont():New("Arial",9,12,.T.,.F.,5,.T.,5,.T.,.F.)
oFont12n	:= TFont():New("Arial",9,12,.T.,.T.,5,.T.,5,.T.,.F.)
oFontCN 	:= TFont():New("Times New Roman",9,9,.T.,.F.,5,.T.,5,.T.,.F.)  

oArial08 	:= TFont():New("Arial",9, 8,.T.,.F.,5,.T.,5,.T.,.F.)
oArial08N	:= TFont():New("Arial",9, 8,.T.,.T.,5,.T.,5,.T.,.F.)
oArial10 	:= TFont():New("Arial",11,11,.T.,.F.,5,.T.,5,.T.,.F.)
oArial10N	:= TFont():New("Arial",11,11,.T.,.T.,5,.T.,5,.T.,.F.)
oArial12 	:= TFont():New("Arial",9,12,.T.,.F.,5,.T.,5,.T.,.F.)
oArial12N	:= TFont():New("Arial",9,12,.T.,.T.,5,.T.,5,.T.,.F.)
oArial14 	:= TFont():New("Arial",9,14,.T.,.F.,5,.T.,5,.T.,.F.)
oArial14N	:= TFont():New("Arial",9,14,.T.,.T.,5,.T.,5,.T.,.F.)

SD2->(dbsetorder(3))  

cQuery  =   " SELECT *"
cQuery  +=  " FROM "+RetSqlName("SF2")+" SF2 "
cQuery  +=  " WHERE F2_FILIAL='"+xFilial("SF2")+"' "
cQuery  +=  " AND F2_DOC   >= '" + mv_par01 + "' AND F2_DOC   <='" + mv_par02 + "' "
cQuery  +=  " AND F2_ESPECIE='RFN  '"
cQuery  +=  " AND SF2.D_E_L_E_T_<>'*' "
cQuery  +=  " ORDER BY F2_DOC, F2_SERIE"
cQuery := ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"ENC",.T.,.T.) 
If ENC->(eof())
	Aviso("Atencion","No existen información por reportar",{ "Ok" })
	Return
Else

	cFileName := ALLTRIM(ENC->F2_SERIE) + ALLTRIM(ENC->F2_DOC) + "_Mod1.pdf"
	oPrint	:= FWMsPrinter():New(cFileName,6,.T.,,.T.,,,,,,,.t.,)
	oPrint:SetResolution()
	oPrint:SetPortrait()
	oPrint:cPathPDF:= "C:\SPOOL\Remisiones\"

	ProcRegua(10) 
	While !ENC->(eof())
		nPagNum := 0
		oPrint:StartPage()
		EncPag()
		cNum := 0
		iNum := 0
		nTuni    := 0
		nTSeg    := 0
		IncProc()
		
		// RUTINAS PARA DESCUENTO DEL ITEM SOLO COMO REFERENCIA 
		cQuery := " SELECT * "
		cQuery += " FROM " + RetSqlName("SD2")+" SD2 "
		cQuery += " WHERE D2_SERIE 	= '"+ENC->F2_SERIE+"'"
		cQuery += "   AND D2_DOC    = '"+ENC->F2_DOC+"'"                                
		cQuery += "   AND D2_FILIAL = '" + xFilial("SD2") + "'"
		cQuery += "   AND D_E_L_E_T_<>'*' ORDER BY D2_ITEM" 
		cQuery := ChangeQuery(cQuery) 
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"DET",.T.,.T.)
		While !DET->(eof())
		
			oPrint:Say( nLin,nColIni     , DET->D2_COD   		, oArial10, 100)
			oPrint:Say( nLin,nColIni+1450 , DET->D2_LOCAL        , oArial10, 100)
			oPrint:Say( nLin,nColIni+1550, TRANSFORM(DET->D2_QUANT,"@E 999,999.99")        , oArial10, 100)  
			cUnidad:=ALLTRIM(Posicione("SB1",1,xFilial("SB1")+DET->D2_COD,"B1_UM"))
		   	oPrint:Say( nLin,nColIni+1950, cUnidad                               			, oArial10, 100)			
			cDescripcion:=ALLTRIM(Posicione("SB1",1,xFilial("SB1")+DET->D2_COD,"B1_DESC"))
//			oPrint:Say( nLin,nColIni+1850,TRANSFORM(DET->D2_QTSEGUM,"@E 999,999.99")	, oArial10, 100)
//			oPrint:Say( nLin,nColIni+2150, "LOTE123456"	, oArial10, 100)
			oPrint:Say( nLin,nColIni+2150, DET->D2_LOTECTL	, oArial10, 100)
			iCont := 1                  
			nTuni    += DET->D2_QUANT
			nTSeg    += DET->D2_QTSEGUM
			WHILE iCont < len(TRIM(cDescripcion))
				if nLin >= nLimDet
					oPrint:EndPage() 
					oPrint:StartPage()
					EncPag()
					iNum := 0
					nLin := nRenIni+800
				endif				
				oPrint:Say( nLin,nColIni+250, SUBSTR(TRIM(cDescripcion),iCont,50), oArial10, 100)
				iCont += 50
				nLin  += 40
				iNum  ++      
			ENDDO   
			iCont := 1
			if !empty(alltrim(DET->D2_NUMSERI))
				cNumSer :=  "Numero de Serie: " + TRIM(DET->D2_NUMSERI)
				WHILE iCont < len(cNumSer)
					oPrint:Say( nLin,nColIni+250, SUBSTR(cNumSer,iCont,45), oArial10, 100)
					iCont += 45
					nLin  += 40
					iNum  ++      
				ENDDO 	
			endif		  
			SD2->(DBSETORDER(4))
			SD2->(DbSeek(xFilial("SD2") + DET->D2_NUMSEQ),.T.)
			cObs := Alltrim(SD2->D2_OBS)					

			if !empty(cObs)    
				nLines := MLCount(cObs)
							
				For iCont := 1 To nLines
					IF !EMPTY(MemoLine(cObs,,iCont))
					
						if nLin >=nLimDet
							oPrint:EndPage() 
							oPrint:StartPage()
							EncPag()
							iNum := 0
							nLin := nRenIni+800
						endif											
						iNum ++
						oPrint:Say(nLin,nColIni+250,ALLTRIM(MemoLine(cObs,,iCont)),oArial10)
						nLin += 40
					ENDIF
				Next iCont			
			endif
			
			iNum ++
			nLin += 40

			if nLin >= nLimDet
				oPrint:EndPage() 
				oPrint:StartPage()
				EncPag()
				iNum := 0
				nLin := nRenIni+800
			endif 					
		
            DET->(Dbskip())
        End
        DET->(Dbclosearea())
		
		PiePag()
		ENC->(dbSkip())
	EndDo 

	ENC->(dbCloseArea())

	oPrint:EndPage()
	//FUNCION PARA ENVIAR VIA CORREO
		
	
	//
	oPrint:Print()
	FreeObj(oPrint)
	
Endif
restarea(aArea)
Return

// FUNDION PARA IMPRESION DE ENCABEZADO
Static Function EncPag()

Local	cTipoE 		:= ""
Local 	cPaquet		:= ""
Local 	cTipoSer	:= ""
Local	cTipoEnt 	:= ""
Local	cPaqueteria	:= ""
Local	cPedido		:= ""
Local 	iCont 		:= 1
	cDoc   		:= ENC->F2_DOC
	cSer   		:= ENC->F2_SERIE
	
	Fec := ENC->F2_EMISSAO
	dia := substr(fec,7,2)
	mes := substr(fec,5,2)
	ano := substr(fec,1,4)
	
	nLin := nRenIni+800

	/* IMPRIME DATOS DE LA EMPRESA */
	oPrint:SayBitmap(50,50,cLogoCli,400,200)
	oPrint:Say( nRenIni,nColIni+800     ,Alltrim(SM0->M0_NOMECOM)														,oArial14N) 
	oPrint:Say( nRenIni+70,nColIni+800  ,Alltrim(SM0->M0_ENDCOB) + " " + AllTrim(SM0->M0_COMPCOB)					,oArial10N) 
	oPrint:Say( nRenIni+120,nColIni+800 ,AllTrim(SM0->M0_BAIRCOB) + ", " + AllTrim(SM0->M0_CIDCOB)					,oArial10N) 
	oPrint:Say( nRenIni+170,nColIni+800 ," Mexico. C.P. " + AllTrim(SM0->M0_CEPCOB)	,oArial10N) 
	oPrint:Say( nRenIni+220,nColIni+800 ,"RFC: " + Alltrim(SM0->M0_CGC) + ". Teléfono: " + Alltrim(SM0->M0_TEL)	,oArial10N) 

	nPagNum := nPagNum + 1
	oPrint:Say(0050,2250,"Página: "+Transform(nPagNum,"999"),oArial10N) // Numero de la pagina


	cTipoE 		:= ENC->F2_TIPOENT
	cPaquet		:= ENC->F2_PAQUET
	cTipoSer	:= ENC->F2_TIPOSER
	cConvenio	:= ENC->F2_CONVENI
	cTipoRem	:= IIF(ENC->F2_TIPOREM=="0","REMISION DE VENTA","REMISION DE MUESTRA") 
	cTipoEnt 	:=POSICIONE("SX5",1, xFilial("SX5")+"Z1"+cTipoE,"SX5->X5_DESCSPA")
	cPaqueteria	:=POSICIONE("SX5",1,xFilial("SX5")+"Z2"+cPaquet,"SX5->X5_DESCSPA")
	cDestino	:=POSICIONE("SF2",1,xFilial("SF2")+cDoc+cSer,"F2_DESTINO")

	cPedido := POSICIONE("SD2",3,xFilial("SD2")+cDoc+cSer,"D2_PEDIDO")
   	/*IMPRIME DATOS DEL CLIENTE*/ 
	dbselectarea("SA1")
	dbSetOrder(1)
	IF SA1->(dbseek(xFILIAL("SA1")+ENC->F2_CLIENTE+ENC->F2_LOJA)) 
		cNumcLII  	:= ALLTRIM(ENC->F2_CLIENTE)
		cCliNom		:= ALLTRIM(SA1->A1_NOME)
		cCliRfc		:= ALLTRIM(SA1->A1_CGC)
		cCliCalle	:= ALLTRIM(SA1->A1_END)
		cCliNumExt	:= ALLTRIM(SA1->A1_NR_END)
		cCliNumInt	:= ALLTRIM(SA1->A1_NROINT)
		cCliMun		:= ALLTRIM(SA1->A1_MUN)
		cCliCol		:= ALLTRIM(SA1->A1_BAIRRO)
		cCliEst		:= AllTrim(POSICIONE("SX5", 1, XFILIAL("SX5") + '12' + SA1->A1_EST, 'SX5->X5_DESCSPA'))
		cCliPais	:= AllTrim(POSICIONE("SYA", 1, XFILIAL("SX5") + SA1->A1_PAIS, 'SYA->YA_DESCR'))
		cCliCp		:= ALLTRIM(SA1->A1_CEP)    
		cTelP	   	:= ALLTRIM(SA1->A1_TEL)
		cCliCont  	:= ALLTRIM(SA1->A1_CONTATO)	
		cMoneda   	:= AllTrim(POSICIONE("CTO",1,XFILIAL("CTO")+strzero(SC5->C5_MOEDA,2),"CTO_DESC"))
		
		oPrint:Say( nRenIni+300,050,"CLIENTE:     ", oArial10N, 100) /*Nombre */
		oPrint:Say( nRenIni+350,050,"R.F.C.:      ", oArial10N, 100) /*R.F.C. */
		oPrint:Say( nRenIni+400,050,"DIRECCION:   ", oArial10N, 100) /*Direccion, Colonia */
		oPrint:Say( nRenIni+550,050,"TIPO DE ENT: ", oArial10N, 100) 
		oPrint:Say( nRenIni+600,050,"TIPO DE SERV: ", oArial10N, 100) 
		oPrint:Say( nRenIni+650,050,"CONVENIO: ", oArial10N, 100) 
		
	   	oPrint:Say( nRenIni+300,300,"(" + cNumcLII + ") - " + cCliNom 		   								,oArial10, 100) /*Nombre */ 
		oPrint:Say( nRenIni+350,300,cCliRfc                                            					,oArial10, 100) /*R.F.C. */
		oPrint:Say( nRenIni+400,300,cCliCalle + " " + cCliNumExt + " " + cCliNumInt + ", " + cCliCol		,oArial10, 100) /*Direccion, Colonia */	
		oPrint:Say( nRenIni+450,300,cCliMun + ", " + cCliEst + " C.P. " + cCliCp +  " " + cCliPais      	,oArial10, 100) /*Ciudad, CP */ 
		oPrint:Say( nRenIni+500,300,"TEL. " + cTelP + " FAX. "+SA1->A1_FAX 									,oArial10, 100) /*Email, tel y fax */ 
		oPrint:Say( nRenIni+550,300,ALLTRIM(cTipoEnt)  															,oArial10)                                         
		oPrint:Say( nRenIni+600,300,ALLTRIM(cTipoSer) 								,oArial10)
		oPrint:Say( nRenIni+650,300,ALLTRIM(cConvenio) , oArial10)
		oPrint:Say( nRenIni+300,1520,cTipoRem, oArial14N, 100) 

		oPrint:Say( nRenIni+350,1520,"NÚMERO:       ", oArial10N, 100) 
		oPrint:Say( nRenIni+400,1520,"FECHA:        ", oArial10N, 100)
		oPrint:Say( nRenIni+450,1520,"MONEDA:       ", oArial10N, 100) 
		oPrint:Say( nRenIni+500,1520,"PEDIDO:     ", oArial10N, 100) 
		oPrint:Say( nRenIni+550,1520,"PAQUETERIA:   ", oArial10N, 100) 
		oPrint:Say( nRenIni+600,1520,"DESTINO:   	", oArial10N, 100) 
	
		oPrint:Say( nRenIni+350 ,1750,cDoc             				,oArial10N) 
		oPrint:Say( nRenIni+400 ,1750,DIA + "/" + MES + "/" + ANO	,oArial10N) // Fecha 
		oPrint:Say( nRenIni+450 ,1750,cMoneda           			,oArial10) 
		oPrint:Say( nRenIni+500 ,1750,cPedido       				,oArial10) 
		oPrint:Say( nRenIni+550 ,1750,cPaqueteria       			,oArial10)
			if !empty(cDestino)    
				nLines := MLCount(cDestino)
							
				For iCont := 1 To nLines
					IF !EMPTY(MemoLine(cDestino,,iCont))															
						oPrint:Say(nRenIni+550+(iCont*40),1750,ALLTRIM(MemoLine(cDestino,,iCont)),oArial10)
						
					ENDIF
				Next iCont			
			endif

	ENDIF
	
	oPrint:Fillrect( {nRenIni+690 , 010 , nRenIni+760 , 2400} , oBrushGray, "-2")

	oPrint:Say( nRenIni+730,nColIni     , "PRODUCTO"             	,oArial10N, 100)
	oPrint:Say( nRenIni+730,nColIni+250 , "D E S C R I P C I Ó N"   ,oArial10N, 100)
	oPrint:Say( nRenIni+730,nColIni+1400 , "ALMACÉN"					,oArial10N, 100) 
	oPrint:Say( nRenIni+730,nColIni+1600, "CANT"            		,oArial10N, 100)  
	oPrint:Say( nRenIni+730,nColIni+2000, "UM"      	,oArial10N, 100)
//	oPrint:Say( nRenIni+730,nColIni+1920, "CANT 2UM"                   	,oArial10N, 100)
	oPrint:Say( nRenIni+730,nColIni+2150, "LOTE"              	,oArial10N, 100)

Return                     

// FUNCION PARA IMPRESIOND DE PIE DE PÁGINA 
Static Function PiePag() 

	/* IMPRIME Notas del Pedido, SUBTOTALES Y TOTALES */ 
	oPrint:Fillrect( {nRenIni+2300+190 , 010 , nRenIni+2300+200 , 2400} , oBrushGray, "-2")
	oPrint:Say (nRenIni+2350+200,nColIni     ,"OBSERVACIONES: "  	,oArial10N, 100 )
	oPrint:Say (nRenIni+2400+200,nColIni+300 ,ALLTRIM(MV_PAR03) 	,oArial10N, 100 )   
	oPrint:Say (nRenIni+2450+200,nColIni+300 ,ALLTRIM(MV_PAR04) 	,oArial10N, 100 )
	oPrint:Say (nRenIni+2500+200,nColIni+300 ,ALLTRIM(MV_PAR05) 	,oArial10N, 100 )
	
	oPrint:Say (nRenIni+2650+150,nColIni+280 ,"________________"  	,oArial10N, 100 )
	oPrint:Say (nRenIni+2650+200,nColIni+300 ,"ENTREGO: "  	,oArial10N, 100 )
	oPrint:Say (nRenIni+2650+250,nColIni+280 ,"NOMBRE Y FIRMA: "  	,oArial10N, 100 )
	
	oPrint:Say (nRenIni+2650+150,nColIni+1680 ,"________________"  	,oArial10N, 100 )
	oPrint:Say (nRenIni+2650+200,nColIni+1700 ,"RECIBIO: "  	,oArial10N, 100 )
	oPrint:Say (nRenIni+2650+250,nColIni+1680 ,"NOMBRE Y FIRMA: "  	,oArial10N, 100 )
		                            
	oPrint:Say (nRenIni+2350+200,nColIni+1500,"TOTAL:    " 		,oArial10N, 100)			
	oPrint:Say( nRenIni+2350+200,nColIni+1650, TRANSFORM(nTUni,"@E 9,999,999.9999") , oArial10, 100)  
	//oPrint:Say( nRenIni+2350+200,nColIni+2080, TRANSFORM(nTSeg,"@E 9,999,999.9999")	, oArial10, 100)
		
//	oPrint:Say (nRenIni+2350+200,nColIni+2130,TRANSFORM(ENC->F2_VALBRUT,"999,999,999.9999")	,oArial10N, 100 )
//	cTotal := Implet(ENC->F2_VALBRUT,ENC->F2_MOEDA)
//	oPrint:Say( 2850,020,ALLTRIM(cTotal),oArial10N, 100)       
			
Return

Static Function ImpLet(pTotal,pMoneda)                            
       If  pMoneda == 1
          _cSimbM := " $ "
          _cLin := Extenso(pTotal,.f.,1,,"2",.t.,.t.,.f.,"2")        
           cCentavos := Right(_cLin,9)
          _cLin := "("+Left(_cLin,Len(_cLin)-9)+cCentavos+")"
       else
           _cSimbM := " USD$ "
           _cLin := Extenso(pTotal,.f.,2,,"2",.t.,.t.,.f.,"2")
           cCentavos := Right(_cLin,8)
           _cLin :="("+ Left(_cLin,Len(_cLin)-8)+cCentavos + ")"
    EndIf                                   
Return(_cLin)  

// FUNCION DE AJUSTE DE PREGUNTAS
Static Function AjustaSX1()
LOCAL aRegs 	:= {}
Local iTamDoc	:= TamSX3("F2_DOC")[01] 

cPerg := "EFAT005E  "
	aAdd(aRegs,{cPerg,"01","De Remisión:   ","De Remisión    ","De Remisión    ","MV_CH1","C",iTamDoc,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","",""}) 
	aAdd(aRegs,{cPerg,"02","A Remisión:    ","A Remisión     ","A Remisión     ","MV_CH2","C",iTamDoc,0,0,"G","","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","",""}) 
	aAdd(aRegs,{cPerg,"03","Observación 1: ","Observación 1: ","Observación 1: ","MV_CH3","C",90,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","",""}) 				
	aAdd(aRegs,{cPerg,"04","Observación 2: ","Observación 2: ","Observación 2: ","MV_CH4","C",90,0,0,"G","","MV_PAR04","","","","","","","","","","","","","","","","","","","","","","","","",""}) 						
	aAdd(aRegs,{cPerg,"05","Observación 3: ","Observación 3: ","Observación 3: ","MV_CH5","C",90,0,0,"G","","MV_PAR05","","","","","","","","","","","","","","","","","","","","","","","","",""}) 						
	aAdd(aRegs,{cPerg,"06","Entregar en 1: ","Entregar en 1: ","Entregar en 1: ","MV_CH6","C",90,0,0,"G","","MV_PAR06","","","","","","","","","","","","","","","","","","","","","","","","",""})		
	aAdd(aRegs,{cPerg,"07","Entregar en 2: ","Entregar en 2: ","Entregar en 2: ","MV_CH7","C",90,0,0,"G","","MV_PAR07","","","","","","","","","","","","","","","","","","","","","","","","",""})		
	aAdd(aRegs,{cPerg,"08","Entregar en 3: ","Entregar en 3: ","Entregar en 3: ","MV_CH8","C",90,0,0,"G","","MV_PAR08","","","","","","","","","","","","","","","","","","","","","","","","",""})		
//	aAdd(aRegs,{cPerg,"09","Importes:      ","Importes:      ","Importes:      ","mv_ch9","N",01,0,1,"C","","mv_par09","Con precios","Con precios","Con precios","","","Sin precios","Sin precios","Sin precios","","","","","","","","","","","","","","","","","",""})
Return          




