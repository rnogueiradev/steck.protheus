#INCLUDE "rwmake.ch"
#include "totvs.ch"
#include "protheus.ch"
#include 'topconn.ch'
#INCLUDE "TbiConn.ch"
#include 'parmtype.ch'

#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"

#INCLUDE "COLORS.CH"
#include "report.ch"


/* **********************************************************

         _.-'~~~~~~'-._            | Funcion:  			RelDocso() 		                                      
        /      ||      \           |                                        
       /       ||       \          | Descripcion: 	 	Impresión documento soporte
      |        ||        |         | 				                       
      | _______||_______ |         |                                        
      |/ ----- \/ ----- \|         | Parametros:	                                       
     /  (     )  (     )  \        | 				                                     
    / \  ----- () -----  / \       |                                        
   /   \      /||\      /   \      | Retorno:		                                      
  /     \    /||||\    /     \     |
 /       \  /||||||\  /       \    |                                        
/_        \o========o/        _\   | Autor: Daniel Mira                                       
  '--...__|'-._  _.-'|__...--'     |                                        
          |    ''    |             |
************************************************************** */

/*
Tabela de cores 
CLR_BLACK         // RGB( 0, 0, 0 )
CLR_BLUE           // RGB( 0, 0, 128 )
CLR_GREEN        // RGB( 0, 128, 0 )
CLR_CYAN          // RGB( 0, 128, 128 )
CLR_RED            // RGB( 128, 0, 0 )
CLR_MAGENTA    // RGB( 128, 0, 128 )
CLR_BROWN       // RGB( 128, 128, 0 )
CLR_HGRAY        // RGB( 192, 192, 192 )
CLR_LIGHTGRAY // RGB( 192, 192, 192 )
CLR_GRAY          // RGB( 128, 128, 128 )
CLR_HBLUE        // RGB( 0, 0, 255 )
CLR_HGREEN      // RGB( 0, 255, 0 )
CLR_HCYAN        // RGB( 0, 255, 255 )
CLR_HRED          // RGB( 255, 0, 0 )
CLR_HMAGENTA  // RGB( 255, 0, 255 )
CLR_YELLOW      // RGB( 255, 255, 0 )
CLR_WHITE        // RGB( 255, 255, 255 )

*/



user function RelDocso()
    //msginfo(cvaltochar(cDoc))
    Local cPreg := Padr('RelDocso',10)

    Private cNroDoc := ''//cDoc
    Private cserDoc := ''//cSer

    AjustaSX1(cPreg)
	IF !Pergunte(cPreg,.T.)
		Return {'@almacenamiento','@tempav','@temppro','@selloseg','@nomecond','@placa','@transportista','@observacion','@Fechahora'}
	EndIF
    
    cserDoc := alltrim(MV_PAR01)
    cNroDoc := alltrim(MV_PAR02)
    
    Processa( {|| relpdf() }, "Espere...", "Generando reporte...",.F.)
    

    
Return

Static Function relpdf()
	//MsgInfo("Informe en PDF","title")
	Local lAdjustToLegacy := .F.
	Local lDisableSetup  := .T.
	Local cLocal          := "c:\tmp\"   
	Local cFilePrint := ""
	
	PRIVATE oPrinter
	PRIVATE oFont1 := TFont():New('Courier new',,-18,.T.)

	
    IF !ExistDir( "c:\tmp\")
		MakeDir( "c:\tmp\" )
	ENDIF

	oPrinter := FWMSPrinter():New('docsoporte.PD_', IMP_PDF, lAdjustToLegacy,cLocal, lDisableSetup, , , , , , .F., )
	//oPrinter := TMSPrinter():New(OemToAnsi('Reporte especial proyectos'))
	//oPrinter:Say(10,10,"Teste")
	
	pdf()
	cFilePrint := cLocal+"docsoporte.PD_"
	File2Printer( cFilePrint, "PDF" )
    oPrinter:cPathPDF:= cLocal 
	oPrinter:Preview()
	
Return

Static function pdf()
	
	// ( <nRed> + ( <nGreen> * 256 ) + ( <nBlue> * 65536 ) )
	PRIVATE oBrushA := TBrush():New( , 11206656 ) //RGB (azul: RGB 0/51/171)
	PRIVATE oBrushN := TBrush():New( , 39423 ) //RGB (naranja: 255/153/0)
	PRIVATE oBrushV := TBrush():New( , 9437096 )
	PRIVATE oBrushR := TBrush():New( , 9027071 )
	PRIVATE oBrushG := TBrush():New( , 12107714 ) //RGB (gris: 194/191/184)    
	
	PRIVATE oBrushNE := TBrush():New( , 52479 ) //RGB (naranja: 255/204/0)
	PRIVATE oBrushVE := TBrush():New( , 4697456 ) //RGB (VERDE: 112/173/71)
	PRIVATE oBrushRE := TBrush():New( , 5263615 ) //RGB (ROJO: 255/80/80)
	PRIVATE oBrushND := TBrush():New( , 13434879 ) //RGB (naranja: 255/255/204)
	PRIVATE oBrushVD := TBrush():New( , 13434828 ) //RGB (VERDE: 204/255/204)
	PRIVATE oBrushRD := TBrush():New( , 13421823 ) //RGB (ROJO: 255/204/204)
	
	
	Private oFont06 := TFont():New("Courier New",,-6,.T.) 
	Private oFont07 := TFont():New("Courier New",,-7,.T.) 
	Private oFont08 := TFont():New("Courier New",,-8,.T.) 
	Private oFont12 := TFont():New("Courier New",,-12,.T.) 
	Private oFont14 := TFont():New("Courier New",,-14,.T.) 
    
    Private oFont08b := TFont():New("Courier New",,-8,.T.,.T.) 
    Private oFont12b := TFont():New("Courier New",,-12,.T.,.T.)
	Private oFont14b := TFont():New("Courier New",,-14,.T.,.T.) 
	
	Private cFileLogo	:= GetSrvProfString('Startpath','') + 'LGMID01' + '.png'
    Private cFileLog2	:= GetSrvProfString('Startpath','') + 'LGMID02' + '.png'
	
	//oPrinter:SetLandscape()
	oPrinter:SetPortrait()

    //PRIMERA PAGINA
    
    Encab()
    detalle()
	
	
Return

Static function Encab()
    //Local aSM0Data2 := FWSM0Util():GetSM0Data()
    Local aRes := strtokarr ( GETMV("MV_XRESDOS"), "|" )
    //Local aSM0Data2 := {}
    
    //Nro Res   |data res|data vld|serie|num ini|num fin   
    //1234567890|20210101|20211231|DOCS |1      |1000  
    oPrinter:StartPage()
	
    
    

	//oPrinter:Box( 0040, 0030, 0100, 0150, "-4") //Espacio logo izquierda
    oPrinter:SayBitmap(40,31,cFileLogo,117,067) //LOGO IZQUIERDA
    
    //Representación Impresa Realizada por TOTVS
    
    oPrinter:Say(0040,0160,"DOCUMENTO SOPORTE EN ADQUISICIONES EFECTUADAS A NO",oFont12,1400,CLR_BLACK)
    oPrinter:Say(0050,0160,"OBLIGADOS A FACTURAR",oFont12,1400,CLR_BLACK)
    //oPrinter:Say(0080,0160,UPPER("TRASLADO ENTRE SEDES"),oFont08,1400,CLR_BLACK)
    
    //aSM0Data2 := FWSM0Util():GetSM0Data()
    oPrinter:Say(0060,0160,POSICIONE("SM0",1,CEMPANT+CFILANT,"M0_NOMECOM"),oFont12b,1400,CLR_BLACK)
    oPrinter:Say(0070,0160,"NIT: " + POSICIONE("SM0",1,CEMPANT+CFILANT,"M0_CGC"),oFont12b,1400,CLR_BLACK)
    oPrinter:Say(0080,0160,"Dirección: " + POSICIONE("SM0",1,CEMPANT+CFILANT,"M0_ENDENT"),oFont12b,1400,CLR_BLACK)
    oPrinter:Say(0090,0160,"Teléfono: " + POSICIONE("SM0",1,CEMPANT+CFILANT,"M0_TEL"),oFont12b,1400,CLR_BLACK)
    
    oPrinter:Say(0100,0160,"Representación Impresa Realizada por TOTVS",oFont06,1400,CLR_BLACK)
    //oPrinter:Say(0080,0310,UPPER("Fecha: NOV 2018"),oFont08,1400,CLR_BLACK)
    //oPrinter:Say(0095,0310,UPPER("Página: " + cvaltochar(nPagatu) + " de " + cvaltochar(nPag)),oFont08,1400,CLR_BLACK)

    oPrinter:Box(0120,0030, 0150, 0260, "-4")
    oPrinter:Box(0120,0260, 0150, 0330, "-4")
    oPrinter:Box(0120,0330, 0150, 0480, "-4")
    oPrinter:Box(0120,0480, 0150, 0570, "-4")
    oPrinter:Fillrect({0121,0481,0149,0569},oBrushG)


    oPrinter:Box(0150,0030, 0180, 0260, "-4")
    oPrinter:Box(0150,0260, 0180, 0330, "-4")
    oPrinter:Box(0150,0330, 0180, 0570, "-4")
    oPrinter:Box(0180,0030, 0210, 0570, "-4")

    //cserDoc := alltrim(MV_PAR01)
    //cNroDoc := alltrim(MV_PAR02)

    dbSelectArea("SF1")
    SF1->(dbSetOrder(1))
    SF1->(DbSeek(xFilial("SF1")+MV_PAR02+MV_PAR01))
    oPrinter:Say(0130,0040,UPPER("Proveedor"),oFont14b,1400,CLR_BLACK)
    oPrinter:Say(0130,0270,UPPER("NIT"),oFont14b,1400,CLR_BLACK)
    oPrinter:Say(0130,0340,UPPER("Fecha"),oFont14b,1400,CLR_BLACK)
    oPrinter:Say(0130,0490,UPPER("No. Doc"),oFont14b,1400,CLR_BLACK)
    oPrinter:Say(0160,0040,"Dirección",oFont14b,1400,CLR_BLACK)
    oPrinter:Say(0160,0270,"Teléfono",oFont14b,1400,CLR_BLACK)
    oPrinter:Say(0190,0040,"Por Concepto De:",oFont14b,1400,CLR_BLACK)
    //oPrinter:Say(0160,0300,"Placa vehículo",oFont12,1400,CLR_BLACK)
    //oPrinter:Say(0160,0400,"T° vehic.",oFont12,1400,CLR_BLACK)
    //oPrinter:Say(0160,0485,"Sello seguridad",oFont12,1400,CLR_BLACK)
    //1 ORIGEN, 2 DESTINO, 3 FECHA, 4 SOLICITANTE, 5 TIPO VEHICULO, 6 CONDUCTOR, 7 PLACA, 8 TEMP, 9 SELLO
    oPrinter:Say(0140,0040,cvaltochar(Posicione("SA2",1,xfilial("SA2")+SF1->F1_FORNECE,"A2_NOME")),oFont08,1400,CLR_BLACK)
    oPrinter:Say(0140,0270,cvaltochar(SF1->F1_FORNECE),oFont08,1400,CLR_BLACK)
    oPrinter:Say(0140,0340,cvaltochar(SF1->F1_EMISSAO) + " " + cvaltochar(SF1->F1_HORA),oFont08,1400,CLR_BLACK)
    oPrinter:Say(0140,0490,cvaltochar(SF1->F1_SERIE)+'-'+cvaltochar(VAL(SF1->F1_XDOC)),oFont12b,1400,CLR_RED)
    oPrinter:Say(0170,0035,cvaltochar(alltrim(Posicione("SA2",1,xfilial("SA2")+SF1->F1_FORNECE,"A2_END")) + " " + Posicione("SA2",1,xfilial("SA2")+SF1->F1_FORNECE,"A2_MUN")),oFont08,1400,CLR_BLACK)
    oPrinter:Say(0170,0270,cvaltochar(Posicione("SA2",1,xfilial("SA2")+SF1->F1_FORNECE,"A2_TEL")),oFont08,1400,CLR_BLACK)
    oPrinter:Say(0190,0160,cvaltochar(SF1->F1_XOBS),oFont12b,1400,CLR_BLACK)
    //aRes := strtokarr ( GETMV("MV_XRESDOS"), "|" )
    //Nro Res   |data res|data vld|serie|num ini|num fin   
    //1234567890|20210101|20211231|DOCS |1      |1000  
    oPrinter:Say(0160,0340,cvaltochar("Documento Oficial de Autorización de numeración de documento soporte"),oFont06,1400,CLR_BLACK)
    oPrinter:Say(0168,0340,cvaltochar("DIAN N° " + aRes[1] + ". Vigencia: 12 meses. " + "Desde el " + aRes[2]),oFont06,1400,CLR_BLACK)
    oPrinter:Say(0176,0340,cvaltochar(" la cual habilita el prefijo " + aRes[4] + " desde el No. " + aRes[5] + " hasta " + aRes[6]),oFont06,1400,CLR_BLACK)
    //oPrinter:Say(0160,0340,cvaltochar("Numeración Dian No " + aRes[1] ),oFont12b,1400,CLR_BLACK)
    //oPrinter:Say(0168,0340,cvaltochar("Desde la " + aRes[4] + " " + aRes[5] + " hasta la " + aRes[4] + " " + aRes[6]) ,oFont12b,1400,CLR_BLACK)
    //oPrinter:Say(0176,0340,cvaltochar("Del " + aRes[2] ) ,oFont12b,1400,CLR_BLACK)
    //oPrinter:Say(0170,0400,cvaltochar('BLA7'),oFont12,1400,CLR_BLACK)
    //oPrinter:Say(0170,0485,cvaltochar('BLA8'),oFont12,1400,CLR_BLACK)
    SF1->(DbCloseArea())
Return


Static function detalle()
    Local nLinha := 0200
    Local ix := 0
    Local nRegs := 0

    Local nSubtot := 0
    Local nRF := 0
    Local nRI := 0
    Local nRica := 0
    

    //cNroDoc+cserDoc)
    dbSelectArea("SD1")
    SD1->(dbSetOrder(1))
    SD1->(Dbsetfilter({||D1_SERIE==cvaltochar(MV_PAR01) .AND. D1_DOC==cvaltochar(MV_PAR02)} , "D1_SERIE=='" + cvaltochar(MV_PAR01) + "' .AND. D1_DOC=='" + cvaltochar(MV_PAR02) + "'" ))

    Count To nRegs

    for ix := 1 to nRegs+1  //SET COUNT TO 
    //ix := 1
    //while SD1->( ! Eof() )
        
    
        oPrinter:Box( nLinha, 0030, nLinha+15, 0060, "-4") //NUMERO LINEA
        oPrinter:Box( nLinha, 0060, nLinha+15, 0150, "-4") //PRODUCTO
        oPrinter:Box( nLinha, 0150, nLinha+15, 0370, "-4") //DESCRIPCION
        oPrinter:Box( nLinha, 0370, nLinha+15, 0420, "-4") //UM
        //oPrinter:Box( nLinha, 0370, nLinha+15, 0420, "-4")
        oPrinter:Box( nLinha, 0420, nLinha+15, 0470, "-4") //CANTIDAD
        oPrinter:Box( nLinha, 0470, nLinha+15, 0530, "-4") //VLRUNIT
        oPrinter:Box( nLinha, 0530, nLinha+15, 0570, "-4") //TOTAL
        oPrinter:Fillrect({nLinha+1,0531,nLinha+14,0569},oBrushG)
        
        if ix==1
            oPrinter:Say(nLinha+10,0040,"No",oFont12b,1400,CLR_BLACK)
            oPrinter:Say(nLinha+10,0065,"Producto",oFont12b,1400,CLR_BLACK)
            oPrinter:Say(nLinha+10,0155,"Descripción.",oFont12b,1400,CLR_BLACK)
            oPrinter:Say(nLinha+10,0375,"UM",oFont12b,1400,CLR_BLACK)
            //oPrinter:Say(nLinha+10,0380,"Cant.",oFont12b,1400,CLR_BLACK)
            oPrinter:Say(nLinha+10,0430,"Cant.",oFont12b,1400,CLR_BLACK)
            oPrinter:Say(nLinha+10,0471,"Vlr. Unit.",oFont12b,1400,CLR_BLACK)
            oPrinter:Say(nLinha+10,0540,"Total",oFont12b,1400,CLR_BLACK)
        else
            oPrinter:Say(nLinha+10,0040,cvaltochar(ix-1),oFont12b,1400,CLR_BLACK)
            
        endif
        nLinha += 15
        //ix += 1
        //SD1->(DbSkip())
    //end
    next ix
    SD1->(DbGoTop())
    nLinha := 0225

    //for ix := 1 to len(aDet)
    while SD1->( ! Eof() )
        //1 PRODUCTO, 2 CANTIDAD, 3 OP (VACIO), 4 PESO, 5 TEMP, 6 VENCIMIENTO
        oPrinter:Say(nLinha,0065,cvaltochar(alltrim(SD1->D1_COD)) ,oFont08,1400,CLR_BLACK)
        oPrinter:Say(nLinha,0151,cvaltochar(Posicione("SB1",1,xFilial("SB1")+SD1->D1_COD,"B1_DESC")),oFont08,1400,CLR_BLACK)
        oPrinter:Say(nLinha,0376,cvaltochar(Posicione("SB1",1,xFilial("SB1")+SD1->D1_COD,"B1_UM")),oFont08,1400,CLR_BLACK)

        oPrinter:Say(nLinha,0430,cvaltochar(SD1->D1_QUANT),oFont08,1400,CLR_BLACK)
        oPrinter:Say(nLinha,0471,cvaltochar(alltrim(Transform(SD1->D1_VUNIT,"@E 999999999.99"))),oFont07,1400,CLR_BLACK)
        oPrinter:Say(nLinha,0532,cvaltochar(alltrim(Transform(SD1->D1_TOTAL,"@E 999999999.99"))),oFont07,1400,CLR_BLACK)
        nLinha += 15
        
        nSubtot += SD1->D1_TOTAL
        nRF += SD1->D1_VALIMP4
        nRI += SD1->D1_VALIMP2
        nRica += SD1->D1_VALIMP7
        
        SD1->(DbSkip())
    end    
    //next ix
    //Transform ( < xExp>, [ cSayPicture] )
    
    SD1->(DbCloseArea())
    nLinha -=10
    for ix := 1 to 5
        oPrinter:Box( nLinha, 0470, nLinha+15, 0530, "-4")
        oPrinter:Box( nLinha, 0530, nLinha+15, 0570, "-4")     
        if ix==1
            oPrinter:Say(nLinha+7,0471,cvaltochar("SUBTOTAL"),oFont08b,1400,CLR_BLACK)
            oPrinter:Say(nLinha+7,0532,cvaltochar(alltrim(Transform(nSubtot,"@E 999999999.99"))),oFont07,1400,CLR_BLACK)    
        endif
        if ix==2
            oPrinter:Say(nLinha+7,0471,cvaltochar("RTEFTE"),oFont08b,1400,CLR_BLACK)
            oPrinter:Say(nLinha+7,0532,cvaltochar(alltrim(Transform(nRF,"@E 999999999.99"))),oFont07,1400,CLR_BLACK)    
        endif
        if ix==3
            oPrinter:Say(nLinha+7,0471,cvaltochar("RETEIVA"),oFont08b,1400,CLR_BLACK)
            oPrinter:Say(nLinha+7,0532,cvaltochar(alltrim(Transform(nRI,"@E 999999999.99"))),oFont07,1400,CLR_BLACK)    
        endif
        if ix==4
            oPrinter:Say(nLinha+7,0471,cvaltochar("RETEICA"),oFont08b,1400,CLR_BLACK)
            oPrinter:Say(nLinha+7,0532,cvaltochar(alltrim(Transform(nRica,"@E 999999999.99"))),oFont07,1400,CLR_BLACK)    
        endif
        if ix==5
            oPrinter:Say(nLinha+7,0471,cvaltochar("TOTAL"),oFont08b,1400,CLR_BLACK)
            oPrinter:Say(nLinha+7,0532,cvaltochar(alltrim(Transform(nSubtot-nRF-nRI-nRica,"@E 999999999.99"))),oFont07,1400,CLR_BLACK)    
            
            oPrinter:Box( nLinha+15, 0470, nLinha+15, 0570, "-4")
            //Extenso(nSubtot-nRF-nRI-nRica,.F.,1,,"2",.t.,.f.)
            oPrinter:Say(nLinha+7+15,0151,"Total en letras: " + Extenso(nSubtot-nRF-nRI-nRica,.F.,1,,"2",.t.,.f.),oFont08,1400,CLR_BLACK)   
        endif
        nLinha += 15
    next
    
    nLinha := 0320
    nLinha := 370
    
	oPrinter:EndPage()
Return



static function AjustaSX1(cPerg)
	//Local _sAlias := Alias()
	Local i := 0
	Local j:= 0
	dbSelectArea("SX1")
	dbSetOrder(1)
	aRegs:={}
	
	
	aAdd(aRegs,{cPerg,"01","Serie: "  ,"Serie: "  ,"Serie: "   ,"MV_CH1"	,"C"	,3,0,0	,"G"	,""	,"MV_PAR01"	,"","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"02","Documento.: "  ,"Documento: "  ,"Documento: "   ,"MV_CH2"	,"C"	,13,0,0	,"G"	,""	,"MV_PAR02"	,"","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	
	
	If DbSeek(cPerg)
		return
	endif
	
	For i:=1 to Len(aRegs)
		If !DbSeek(cPerg+aRegs[i,2])
			RecLock("SX1",.T.)
			For j:=1 to FCount()
				If j <= Len(aRegs[i])
					FieldPut(j,aRegs[i,j])
				Endif
			Next
			MsUnlock()
		Endif
	Next i
	//dbSelectArea(_sAlias)
return
