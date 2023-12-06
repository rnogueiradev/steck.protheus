#Include "PROTHEUS.CH"
#Include "RPTDEF.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "FWPrintSetup.ch"

function u_impjob()
	StartJob("u_tstimpsv", getEnvServer(), .T.)
return nil

User Function tstimpsv()

	Local oPrinter
	Local cPath :=lower("c:\teste\") //local do .rel
	//PREPARE ENVIRONMENT EMPRESA "99" FILIAL "01"
    PREPARE ENVIRONMENT EMPRESA "11" FILIAL "01"
    cImpress := ""

    cImpress := "EPSONDDEC5B (L3150 Series)"
	//oPrinter := FWMSPrinter():New(lower('1.pdf'),IMP_SPOOL,.F.,cPath,.T.,,,"\\printserver-02.sp01.local\SPCloudPrinter-Mono",.F.,.F.,,.F.)
    //oPrinter := FWMSPrinter():New(lower('1.pdf'),IMP_SPOOL,.F.,cPath,.T.,,,"DIRECAO",.F.,.F.,,.F.)
    oPrinter := FWMSPrinter():New(lower('1.pdf'),IMP_SPOOL,.F.,cPath,.T.,,,cImpress,.F.,.F.,,.F.)
    
	oFont1 := TFont():New('Courier new',,-18,.T.)
	oPrinter:SetParm( "-RFS")
	//oPrinter:setDevice(IMP_PDF)
	oPrinter:cPathPDF := lower("/imp/")//diretorio na rede do pdf
	oPrinter:SetPortrait() //retrato
	//oPrinter:SetLandscape() //paisagem
	oPrinter:SetPaperSize(DMPAPER_A4) //Tamanho da folha
	//oPrinter:linjob         :=.T.
	//oPrinter:Setup()

	cTxt := "Lorem ipsum dolor sit amet. Qui laudantium obcaecati a dolores fugit quo dolor iure aut blanditiis facere."
	cTxt2 := "Rem odio nulla et perspiciatis explicabo et nisi facere cum dolor repudiandae nam incidunt dolorem et galisum distinctio qui soluta incidunt."

	oPrinter:SayAlign( 02/*linha*/,10/*coluna*/,cTxt/*texto*/,oFont1/*fonte*/,550/*Largura*/,;
		200/*Altura*/, CLR_HRED/*Cor*/, 3/*AlinhamentoH*/, 2/*AlinhamentoV*/ )

	oPrinter:SayAlign( 80/*linha*/,10/*coluna*/,cTxt2/*texto*/,oFont1/*fonte*/,550/*Largura*/,;
		200/*Altura*/, CLR_HRED/*Cor*/, 3/*AlinhamentoH*/, 2/*AlinhamentoV*/ )

	//oPrinter:QRCode(150,150,"QR Code gerado com sucesso", 100)
	//oPrinter:SayBitmap( 70 , 10 , "\system\logo.bmp" , 550 , 200 )

	oPrinter:EndPage()
	oPrinter:Preview()
	FreeObj(oPrinter)
	oPrinter := Nil

	RESET ENVIRONMENT

Return
