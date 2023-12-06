#Include "Protheus.ch"
#Include "Totvs.ch"
#Include "FWMVCDef.ch"
#Include "TOPConn.ch"
#Include "FwPrintSetup.ch"
#Include "RPTDef.ch"

Static oFont06	:= TFont():New("Arial",06,06,,.T.,,,,.T.,.F.)
Static oFont06N	:= TFont():New("Arial",06,06,,.T.,,,,.T.,.F.)
Static oFont08	:= TFont():New("Arial",07,07,,.T.,,,,.T.,.F.)
Static oFont08N	:= TFont():New("Arial",08,08,,.T.,,,,.T.,.F.)
Static oFont10	:= TFont():New("Arial",10,10,,.F.,,,,.T.,.F.)
Static oFont10N	:= TFont():New("Arial",10,10,,.T.,,,,.T.,.F.)
Static oFont12	:= TFont():New("Arial",12,12,,.F.,,,,.T.,.F.)
Static oFont12N	:= TFont():New("Arial",12,12,,.T.,,,,.T.,.F.)
Static oFont13 	:= TFont():New("Arial",13,13,,.F.,,,,.T.,.F.)
Static oFont13N	:= TFont():New("Arial",13,13,,.T.,,,,.T.,.F.)
Static oFont14 	:= TFont():New("Arial",14,14,,.F.,,,,.T.,.F.)
Static oFont14N	:= TFont():New("Arial",14,14,,.T.,,,,.T.,.F.)
Static oFont16 	:= TFont():New("Arial",16,16,,.F.,,,,.T.,.F.)
Static oFont16N	:= TFont():New("Arial",16,16,,.T.,,,,.T.,.F.)
Static oFont18 	:= TFont():New("Arial",18,18,,.F.,,,,.T.,.F.)
Static oFont18N	:= TFont():New("Arial",18,18,,.T.,,,,.T.,.F.)

#Define MODULE_PIXEL_SIZE 12
#Define lAdjustToLegacy  .F.
#Define lDisableSetup    .T. 
#Define cPath         "\arquivos\seb\imagens\"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³STFLRE05  ºAutor  ³Jefferson Carlos    º Data ³  19/12/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Impressão de Etiquetas modelo Schneider                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Steck                                                      º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function STFLRE05()
	
	Private cProdut1
	Private cOS2
	Private cQtdImp3
	Private cAnoMes4
	Private cTipo5
	Private cImpres6

	Ajusta()
	If !Pergunte("STFLR05",.T.)
		Return
	EndIf

	cProdut1 := MV_PAR01
	cOS2     := MV_PAR02
	cQtdImp3 := MV_PAR03
	cAnoMes4 := MV_PAR04
	cTipo5   := MV_PAR05
	cImpres6 := MV_PAR06

	If Empty(cProdut1) .Or. Empty(cOS2) .Or. Empty(cQtdImp3) .Or. Empty(cAnoMes4) .Or. Empty(cTipo5)
		MsgAlert("Atenção, todos os parâmetros são de preenchimento obrigatório.")
		Return
	Else
		If ApMsgYesNo("Confirma a Impressão de Etiquetas (S/N)?")
			Processa({||STFLR01A(),"Imprimindo ..."})
		EndIf
	EndIf

	FWMsgRun(,{|| sleep(3000)},'Informação',"Impressão Finalizada")

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³STFLR01A  ºAutor  ³Microsiga           º Data ³  10/19/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função Auxiliar para impressão                             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Steck                                                      º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function STFLR01A()
	
	Local oPrinter
	Local ctamG			:= "023,044"
	Local ctamM			:= "019,029"
	//Local ctamP		:= "020,018"
	Local ctamx			:= "016,014"
	//Local cPorta		:= "LPT1"
	//Local ccxmet
	Local cCPO1			:= ""
	Local cCodBar1		:= ""
	Local cCodBar2		:= ""
	Local aRet			:= {}
	Local aParamBox		:= {}
	Local aCombo		:= {}
	Local _cCodEan14	:= ""
	Local nLin			:= 0
	Local nCol			:= 0
	Local lOK			:= .T.
	Local lVazio		:= .F.
	Private cdesc1		:= ""
	Private cdesc2		:= ""
	Private cdesc3		:= ""
	Private _Imagem		:= ""
	Private cimgqd		:= ""

	dbSelectArea("SB5")
	dbSetOrder(1)
	If !dbSeek( xFilial("SB5") + cProdut1 )
		MsgAlert("Produto não Cadastrado na Tabela de Complementos.")
		Return
	EndIf

	dbSelectArea("SB1")
	dbSetOrder(1)
	If !dbSeek( xFilial("SB1") + cProdut1 )
		MsgAlert("Produto não Cadastrado na Tabela de Produtos.")
		Return
	EndIf
	
	If !CB5SETIMP(cImpres6, IsTelNet())
		MsgAlert("Falha na comunicacao com a impressora.")
		Return Nil
	EndIf
	
	dbSelectArea("SZ7")
	SZ7->( dbGoTop())
	SZ7->( dbSetOrder(1) )
	lOK := SZ7->( dbSeek(xFilial("SZ7") + Alltrim(SB1->B1_COD)) )

	If lOK
		cdesc1	:= 	Left(Alltrim(SZ7->Z7_DESCRI1),50)
		cdesc2	:=  Left(Alltrim(SZ7->Z7_DESCRI2),50)
		cdesc3	:=  Left(Alltrim(SZ7->Z7_DESCRI3),50)
		nLin	:= 5
		nCol	:= 10
		lVazio := (Empty(cdesc1) .Or. Empty(cdesc2) .Or. Empty(cdesc3))
		// Melhorias realizada Ticket: 20210210002232  - Valdemir Rabelo 27/04/2021
		If cTipo5 == "I" // Se for etiqueta individual
			cCPO1    := '1'
			cCodBar1 := Alltrim(SZ7->Z7_EAN13)
			cCodBar2 := Alltrim(SB5->B5_COD) + "=" + AllTrim(cOS2) + "=" + "01"
		Else
			aCombo := {cValtoChar(SZ7->Z7_Q1EAN14), cValtoChar(SZ7->Z7_Q2EAN14), cValtoChar(SZ7->Z7_Q3EAN14)}
			aAdd(aParamBox,{2,"Selecione a Quantidade",,aCombo,50,"",.T.})
			lOK  := ParamBox(aParamBox,"Parâmetros...",@aRet)
			Do Case
				Case AllTrim(aRet[1]) == cValtoChar(SZ7->Z7_Q1EAN14)
					_cCodEan14	:= SZ7->Z7_1EAN14
				Case AllTrim(aRet[1]) == cValtoChar(SZ7->Z7_Q2EAN14)
					_cCodEan14	:= SZ7->Z7_2EAN14
				OtherWise
					_cCodEan14	:= SZ7->Z7_3EAN14
			EndCase
			cCPO1    := aRet[1]
			cCodBar1 := Alltrim(_cCodEan14)
			If cEmpAnt == "01"
			    cCodBar2 := Alltrim(SB5->B5_COD) + "=" + AllTrim(cOS2) + "=" + aRet[1]
			Else
				cCodBar2 := Alltrim(SB5->B5_COD) + "=" + AllTrim(cOS2) + "=" + aRet[1]
			EndIf
		EndIf
		If cEmpAnt == "01"
			If lOK
			    If lVazio
			    	GetDESC()    // Carrego Dados fixo
				EndIf 
			    MSCBINFOETI("STFLR05","STFLR05")
				MSCBLOADGRF("cxmet2.grf")
				MSCBLOADGRF(cimgqd)
				//MSCBPRINTER("ETIQUETA",'LPT1',,120,.F.,,,,,,.T.)     // Liberado para Valdemir fazer TESTE comentar após uso
				MSCBBEGIN(cQtdImp3,4)
				MSCBSAY(005-nCol,007-nLin,SB5->B5_COD												,"N","0",ctamG)
				MSCBSAY(076-nCol,007-nLin,"X" + cCPO1												,"N","0",ctamG)
				MSCBLineH(005-nCol,010-nLin,080,1.5,"B")
				MSCBSAY(021-nCol,011-nLin,cdesc1													,"N","0",ctamx)
				MSCBSAY(021-nCol,013-nLin,cdesc2													,"N","0",ctamx)
				MSCBSAY(069-nCol,011-nLin,cAnoMes4 + " " + AllTrim(cOS2)							,"N","0",ctamx)
				MSCBLineH(069-nCol,013-nLin,080,1.5,"B")
				MSCBSAY(021-nCol,015-nLin,cdesc3													,"N","0",ctamx)
				MSCBSAY(069-nCol,014-nLin,Subs(SB1->B1_CODBAR,7,6) 									,"N","0",ctamX)
				MSCBGrafic(066-nCol,017-nLin,cimgqd,.T.)
				MSCBLineH(021-nCol,017-nLin,055,2.0,"B")
				MSCBSAY(021-nCol,018-nLin,"EASY9"													,"N","0",ctamM)
				MSCBSAY(021-nCol,020-nLin,cValToChar(SB5->B5_XDESC1)								,"N","0",ctamx)
				MSCBSAY(021-nCol,022-nLin,cValToChar(SB5->B5_XDESC2)								,"N","0",ctamx)
				MSCBSAY(021-nCol,024-nLin,cValToChar(SB5->B5_XDESC3)								,"N","0",ctamx)
				MSCBSAY(021-nCol,025-nLin,cValToChar(SB5->B5_COMPR) + "x" + cValToChar(SB5->B5_ESPESS) + "x" + cValToChar(SB5->B5_LARG),"N","0",ctamx)
				MSCBLineH(021-nCol,027-nLin,050,1.5,"B")
				// Ticket 20210813015692 - Erro no Código de Barras etiqueta Schneider EASY9 - Eduardo Pereira Sigamat - 18.08.2021 - Inicio
				If cTipo5 == "I"
					MSCBSAYBAR(025-nCol,028-nLin,cCodBar1, "N","MB04",6 ,.F.,.T.,.F.,   ,2,1)
				Else
					MSCBSAYBAR(025-nCol,028-nLin,cCodBar1, "N","MB01",6 ,.F.,.T.,.F.,   ,2,1)
				EndIf
				// Ticket 20210813015692 - Erro no Código de Barras etiqueta Schneider EASY9 - Eduardo Pereira Sigamat - 18.08.2021 - Fim
				MSCBSAYBAR(005-nCol,038-nLin,cCodBar2, "N","MB07",6,.T.,.T.,.F.,"B",2,1)
				MSCBLineH(015-nCol,042,080,1.5,"B")
			EndIf
			MSCBEND()
			MSCBCLOSEPRINTER()
		Else
			_Imagem := Alltrim(SB1->B1_XPROTHU)
			InstPrn(@oPrinter, cQtdImp3, _Imagem)
			oPrinter:StartPage()
			nLin += 20
			oPrinter:Say(nLin, nCol+040, SB5->B5_COD,        oFont14N)
			oPrinter:Say(nLin, nCol+210, "X",                oFont13N)
			oPrinter:Say(nLin, nCol+225, cCPO1,              oFont13N)
			nLin += 6
			oPrinter:Line( nLin, nCol+035, nLin, 260, , "-9")
			nLin += 6.5
			oPrinter:Say(nLin, nCol+040, cdesc1, oFont06)             
			oPrinter:Say(nLin, nCol+200, cAnoMes4 + " " + AllTrim(cOS2) , oFont06)             
			nLin += 7
			oPrinter:Line( nLin-4, nCol+200, nLin-4, 260, , "-9")
			oPrinter:Say(nLin,   nCol+040, cdesc2, oFont06)       
			oPrinter:Say(nLin+2, nCol+200, Subs(SB1->B1_CODBAR,7,6), oFont06)             
			nLin += 7
			oPrinter:Say(nLin, nCol+040, cdesc3, oFont06)  
			// Adicionar imagem do Produto
			If File(cPath + _Imagem + ".png")
			   	oPrinter:SayBitmap ( nLin, 160, cPath + _Imagem + ".png", 50, 70 )
			Else
				If File(cPath + _Imagem + ".bmp")
					oPrinter:SayBitmap ( nLin, 160, cPath + _Imagem + ".bmp", 50, 70 )
				EndIf
			EndIf
			nLin += 7
			oPrinter:Line( nLin, nCol+040, nLin, 150, , "-9")
			nLin += 6.5
			oPrinter:Say(nLin, nCol+040, cValToChar(SB5->B5_XDESC1), oFont06)             // Desc.English
			nLin += 7
			oPrinter:Say(nLin, nCol+040, cValToChar(SB5->B5_XDESC2), oFont06)
			nLin += 7
			oPrinter:Say(nLin, nCol+040, cValToChar(SB5->B5_XDESC3), oFont06)
			nLin += 7		
			oPrinter:Say(nLin, nCol+040, cValToChar(SB5->B5_COMPR) + "x" + cValToChar(SB5->B5_ESPESS) + "x" + cValToChar(SB5->B5_LARG), oFont06)
			nLin += 7
			oPrinter:Line( nLin, nCol+040, nLin, 150, , "-9")
			nLin += 3
			//nLin += 9
			oPrinter:FWMSBAR("EAN13",;          // 01 - Tipo Código Barra
			7.7,;                              	// 02 - Linha
			4.5,;                              	// 03 - Coluna
			ALLTRIM(cCodBar1),;                 // 04 - Chave Codigo barra
			oPrinter,;                          // 05 - Objeto Printer
			.F.,;                               // 06 - Se calcula o digito de controle. Defautl .T.
			,;                                  // 07 - Numero da Cor, utilize a "color.ch". Default CLR_BLACK
			.T.,;                               // 08 - Se imprime na Horizontal. Default .T.
			0.045,;                             // 09 - Numero do Tamanho da barra. Default 0.025
			1.0,;                               // 10 - Numero da Altura da barra. Default 1.5
			.T.,;                               // 11 - Se imprime a linha com o código embaixo da barra. Default .T.
			"Arial",;                           // 12 - Nome do Fonte a ser utilizado. Defautl "Arial"
			,;                                  // 13 - Modo do codigo de barras CO. Default ""
			.F.,;                               // 14 - Se executa o método Print() de oPrinter pela MsBar. Default .T.
			1/*0.1*/,;                          // 15 - Número do índice de ajuste da largura da fonte. Default 1
			1/*0.5*/,;                          // 16 - Número do índice de ajuste da altura da fonte. Default 1
			.F.)                                // 17 - Utiliza o método Cmtr2Pix() do objeto Printer.Default .T.
			nLin += 45
			oPrinter:Code128( nLin, nCol+043 , cCodBar2, 1.4, 18,.T., oFont06)
			oPrinter:EndPage()
			oPrinter:Preview()
			FreeObj(oPrinter)
			oPrinter := Nil
		EndIf
	Else
		Msgalert("Codigo não encontrado (Itens Schneider). VERIFIQUE!")
		Return
	EndIf

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³Ajusta    ºAutor  ³Microsiga           º Data ³  10/19/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Atualização do SX1                                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function Ajusta()

	Local aPergs 	:= {}

	aAdd(aPergs,{"Produto ?					","Produto ?				","Product ?			","mv_ch1","C",15,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SB5","S","",""})
	aAdd(aPergs,{"OS ?                      ","OS ?                     ","SO ?                	","mv_ch2","C",8 ,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","   ","S","",""})
	aAdd(aPergs,{"Quantidade de Impressão ? ","Cantidad de Impresion ?  ","Number of Copys ?   	","mv_ch3","N",3 ,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","   ","S","",""})
	aAdd(aPergs,{"Ano+Mês ?                 ","Ano+Mês ?                ","Ano+Mês ?           	","mv_ch4","C",6 ,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","   ","S","",""})
	aAdd(aPergs,{"Tipo(I/C) ?               ","Tipo(I/C) ?              ","Tipo(I/C) ?         	","mv_ch5","C",1 ,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","   ","S","",""})
	aAdd(aPergs,{"Impressora ?              ","Impressora ?             ","Impressora ?        	","mv_ch6","C",6 ,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","CB5","S","",""})

	//AjustaSx1("STFLR05",aPergs)
Return

/*/Protheus.doc InstPrn
description
Rotina que instancia o objeto de impressão
@type function
@version 12.1.25
@author Valdemir Jose
@since 28/04/2021
/*/

Static Function InstPrn(oPrinter, _nQtdCop, pNome)

	Local lVis      := .F. // faço uma pergunta se deseja visualizar ou imprimir direto
	Local cHora     := Substr(Time(), 1, 2)
	Local cMinutos  := Substr(Time(), 4, 2)
	Local cSegundos := Substr(Time(), 7, 2)
	Local cAliasLif := pNome + cHora + cMinutos + cSegundos + Alltrim(GetComputerName())

    oPrinter := FWMSPrinter():New(cAliasLif,IMP_SPOOL, lAdjustToLegacy,"/spool/",lDisableSetup, , , , , , .F., .T.,_nQtdCop )
    // If lVis
    //     Abre configuração de impressora
    //     oPrinter:Setup()
    // EndIf 
    // Salva arquivo PDF na pasta c:\Temp
    If File("C:\Temp\" + pNome + ".pdf")
        FErase("C:\Temp\" + pNome + ".pdf")
    EndIf
    oPrinter:setDevice( If(!lVis, IMP_SPOOL, IMP_PDF) )		// Define se envia para impressora ou visualiza em tela
    oPrinter:SetResolution(72)                              // Resolução
    oPrinter:SetParm( "-RFS")                               // Parâmetro de qualidade de fonte
    oPrinter:cPathPDF :="C:\Temp\"                          // Local a ser salvo o arquivo
	oPrinter:cPrinter := "ETIQUETA"                         // Nome da Impressora Renomeada
    oPrinter:SetMargin(001,001,001,001)                     // Margem de impressão

Return 

/*/Protheus.doc GetDESC
description
@type function
@version 12.1.25
@author Valdemir Jose
@since 14/06/2021
/*/

Static Function GetDESC()

	If Alltrim(SB1->B1_COD) $ "EZ9E3305"
		cimgqd	:=	"qdez9e3305.GRF"
		cdesc1	:= 	"Quadro de distribuicao 5 modulos"
		cdesc2	:=  "Consumer unit flush 5 ways"
		cdesc3	:=  "Tablero de distribucion 5 modulos"
	ElseIf Alltrim(SB1->B1_COD) $ "EZ9E3336"
		cimgqd  :="qdez9e3336.GRF"
		cdesc1	:= 	"Quadro de distribuicao 36 modulos"
		cdesc2	:=  "Consumer unit flush 36 ways"
		cdesc3	:=  "Tablero de distribucion 36 modulos"
	ElseIf Alltrim(SB1->B1_COD) $ "EZ9E3308"
		cimgqd	:="qdez9e3308.GRF"
		cdesc1	:= 	"Quadro de distribuicao 8 modulos"
		cdesc2	:=  "Consumer unit flush 8 ways"
		cdesc3	:=  "Tablero de distribucion 8 modulos"
	ElseIf Alltrim(SB1->B1_COD) $ "EZ9E3348"
		cimgqd	:="qdez9e3348.GRF"
		cdesc1	:= 	"Quadro de distribuicao 48 modulos"
		cdesc2	:=  "Consumer unit flush 48 ways"
		cdesc3	:=  "Tablero de distribucion 48 modulos"
	ElseIf Alltrim(SB1->B1_COD) $ "EZ9E3312"
		cimgqd:="qdez9e3312.GRF"
		cdesc1	:= 	"Quadro de distribuicao 12 modulos"
		cdesc2	:=  "Consumer unit flush 12 ways"
		cdesc3	:=  "Tablero de distribucion 12 modulos"
	ElseIf Alltrim(SB1->B1_COD) $ "EZ9E3316"
		cimgqd:="qdez9e3316.GRF"
		cdesc1	:= 	"Quadro de distribuicao 16 modulos"
		cdesc2	:=  "Consumer unit flush 16 ways"
		cdesc3	:=  "Tablero de distribucion 16 modulos"
	ElseIf Alltrim(SB1->B1_COD) $ "EZ9E3324"
		cimgqd:="qdez9e3324.GRF"
		cdesc1	:= 	"Quadro de distribuicao 24 modulos"
		cdesc2	:=  "Consumer unit flush 24 ways"
		cdesc3	:=  "Tablero de distribucion 24 modulos"
	ElseIf Alltrim(SB1->B1_COD) $ "EZ9E3312F"
		cimgqd:="qdez9e3312f.GRF"
		cdesc1	:= 	"Quadro de distribuicao 12 modulos frontal"
		cdesc2	:=  "Consumer Unit Flush 12 Ways Frontal"
		cdesc3	:=  "Tablero de distribución 12 módulos frontal"
	ElseIf Alltrim(SB1->B1_COD) $ "EZ9E33105"
		cimgqd:="qdez9e33105.GRF"
		cdesc1	:= 	"OBTURADOR PARA 5 MODULOS"
		cdesc2	:=  "BLANKING PLATES 5 UNITS"
		cdesc3	:=  "OBTURADOR 5 MÓDULOS"
	ElseIf Alltrim(SB1->B1_COD) $ "EZ9E33B04"
		cimgqd:="qdez9e33b04.GRF"
		cdesc1	:= "BARRAMENTO N/T 4 TERMINAIS EASY9"
		cdesc2	:= "Bus Bar Neutral/Ground 4 Terminais"
		cdesc3	:= "Regleta Conexion Neutro y Tierra 5 Modulos "
	ElseIf Alltrim(SB1->B1_COD) $ "EZ9E33B06"
		cimgqd:="qdez9e33b06.GRF"
		cdesc1	:= "BARRAMENTO N/T 6 TERMINAIS EASY9"
		cdesc2	:= "Bus Bar Neutral/Ground 6 Terminals"
		cdesc3	:= "Regleta Conexion Neutro y Tierra 8 Modulos"
	ElseIf Alltrim(SB1->B1_COD) $ "EZ9E33B08"
		cimgqd:="qdez9e33b08.GRF"
		cdesc1	:= "BARRAMENTO N/T 8 TERMINAIS EASY9"
		cdesc2	:= "Bus Bar Neutral/Ground 8 Terminals"
		cdesc3	:= "Regleta Conexion Neutro y Tierra 12/16 modulos"
	ElseIf Alltrim(SB1->B1_COD) $ "EZ9E33B11"
		cimgqd:="qdez9e33b11.GRF"
		cdesc1	:= "BARRAMENTO N/T 11 TERMINAIS EASY9"
		cdesc2	:= "Bus Bar Neutral/Ground 11 Terminals"
		cdesc3	:= "Regleta Conexion Neutro y Tierra 24/36/48 modulos"
	ElseIf Alltrim(SB1->B1_COD) $ "EZ9E3305P"
		cimgqd:="qdez9e3305p.GRF"
		cdesc1	:= "PORTA QUADRO DE DISTRIBUICAO 5 MODULOS"
		cdesc2	:= "Door - Consumer Unit Flush 5 ways"
		cdesc3	:= "Puerta - Tablero de distribucion 5 modulos"
	ElseIf Alltrim(SB1->B1_COD) $ "EZ9E3308P"
		cimgqd:="qdez9e3308P.GRF"
		cdesc1	:= "PORTA QUADRO DE DISTRIBUICAO 8 MODULOS"
		cdesc2	:= "Door - Consumer Unit Flush 8 ways"
		cdesc3	:= "Puerta - Tablero de distribucion 8 modulos"
	ElseIf Alltrim(SB1->B1_COD) $ "EZ9E3312P"
		cimgqd:="qdez9e3312p.GRF"
		cdesc1	:= "PORTA QUADRO DE DISTRIBUICAO 12 MODULOS"
		cdesc2	:= "Door - Consumer Unit Flush 12 ways"
		cdesc3	:= "Puerta - Tablero de distribucion 12 modulos"
	ElseIf Alltrim(SB1->B1_COD) $ "EZ9E3316P"
		cimgqd:="qdez9e3316p.GRF"
		cdesc1	:= "PORTA QUADRO DE DISTRIBUICAO 16 MODULOS"
		cdesc2	:= "Door - Consumer Unit Flush 16 ways"
		cdesc3	:= "Puerta - Tablero de distribucion 16 modulos"
	ElseIf Alltrim(SB1->B1_COD) $ "EZ9E3324P"
		cimgqd:="qdez9e3324p.GRF"
		cdesc1	:= "PORTA QUADRO DE DISTRIBUICAO 24 MODULOS"
		cdesc2	:= "Door - Consumer Unit Flush 24 ways"
		cdesc3	:= "Puerta - Tablero de distribucion 24 modulos"
	ElseIf Alltrim(SB1->B1_COD) $ "EZ9E3336P"
		cimgqd:="qdez9e3336p.GRF"
		cdesc1	:= "PORTA QUADRO DE DISTRIBUICAO 36 MODULOS"
		cdesc2	:= "Door - Consumer Unit Flush 36 ways"
		cdesc3	:= "Puerta - Tablero de distribucion 36 modulos"
	ElseIf Alltrim(SB1->B1_COD) $ "EZ9E3348P"
		cimgqd:="qdez9e3348p.GRF"
		cdesc1	:= "PORTA QUADRO DE DISTRIBUICAO 48 MODULOS"
		cdesc2	:= "Door - Consumer Unit Flush 48 ways"
		cdesc3	:= "Puerta - Tablero de distribucion 48 modulos"
	ElseIf Alltrim(SB1->B1_COD) $ "EZ9X33112"
		cimgqd:="qdez9e33112.GRF"
		cdesc1	:= "BARRAMENTO FASE 1P 80A 12 POLOS EASY9"
		cdesc2	:= "Comb Bus Bar 1P 80A 12 Pole"
		cdesc3	:= "Regleta de Fase 1P 80A 12 polos"
	ElseIf Alltrim(SB1->B1_COD) $ "EZ9X33157"
		cimgqd:="qdez9x33157.GRF"
		cdesc1	:= "BARRAMENTO FASE 1P 80A 57 POLOS EASY9"
		cdesc2	:= "Comb Bus Bar 1P 80A 57 Pole"
		cdesc3	:= "Regleta de Fase 1P 57 polos"
	ElseIf Alltrim(SB1->B1_COD) $ "EZ9X33212"
		cimgqd:="qdez9e33212.GRF"
		cdesc1	:= "BARRAMENTO FASE 2P 80A 12 POLOS EASY9"
		cdesc2	:= "Comb Bus Bar 2P 80A 12 Pole"
		cdesc3	:= "Regleta de Fase 2P 80A 12 polos"
	ElseIf Alltrim(SB1->B1_COD) $ "EZ9X33257"
		cimgqd:="qdez9x33257.GRF"
		cdesc1	:= "BARRAMENTO FASE 2P 80A 57 POLOS EASY9"
		cdesc2	:= "Comb Bus Bar 2P 80A 57 Pole"
		cdesc3	:= "Regleta de Fase 2P 80A 57 polos"
	ElseIf Alltrim(SB1->B1_COD) $ "EZ9X33312"
		cimgqd:="qdez9e33312.GRF"
		cdesc1	:= "BARRAMENTO FASE 3P 80A 12 POLOS EASY9"
		cdesc2	:= "Comb Bus Bar 3P 80A 12 Pole"
		cdesc3	:= "Regleta de Fase 3P 80A 12 polos"
	ElseIf Alltrim(SB1->B1_COD) $ "EZ9X33357"
		cimgqd:="qdez9e33357.GRF"
		cdesc1	:= "BARRAMENTO FASE 3P 80A 57 POLOS EASY9"
		cdesc2	:= "Comb Bus Bar 3P 80A 57 Pole"
		cdesc3	:= "Regleta de Fase 3P 80A 57 polos"
	ElseIf Alltrim(SB1->B1_COD) $ "EZ9X33M50"
		cimgqd:="qdez9x33m50.GRF"
		cdesc1	:= "CONECTOR GENERICO CABOS ATE 50MM2 EASY9"
		cdesc2	:= "Generic Connector - Cables to 50 mm²"
		cdesc3	:= "Conector Generico - cables hasta 50mm2"
	ElseIf Alltrim(SB1->B1_COD) $ "EZ9X33905"
		cimgqd:="qdez9x33905.GRF"
		cdesc1	:= "PROTETOR DE BARRAMENTOS 5 POLOS EASY9"
		cdesc2	:= "Protector of Bus Bar"
		cdesc3	:= "Protector de Regletas 5 polos"
ElseIf Alltrim(SB1->B1_COD) $ "EZ9E33B08E"
		cimgqd:="qdez9e33b08.GRF"
		cdesc1	:= "BARRAMENTO 8 TERMINAIS TERRA EASY9"
		cdesc2	:= "GROUND BAR 8 CONNECTIONS EASY9"
		cdesc3	:= "BARRAJE DE TIERRA 8 TERMINALES EASY9"
		//>> Ticket 20200415001660
	ElseIf Alltrim(SB1->B1_COD) $ "EZ9E33B06E" 
		cimgqd:="qdezpe33b06e.GRF"
		cdesc1	:= "BARRAMENTO 6 TERMINAIS TERRA EASY9"
		cdesc2	:= "GROUND BAR 6 CONNECTIONS EASY9"
		cdesc3	:= "BARRAJE DE TIERRA 6 TERMINALES EASY9"
	ElseIf Alltrim(SB1->B1_COD) $ "EZ9E33B06N" 
		cimgqd:="qdez9e33b06n.GRF"
		cdesc1	:= "BARRAMENTO 6 TERMINAIS NEUTRO EASY9"
		cdesc2	:= "NEUTRAL BAR 6 CONNECTIONS EASY9"
		cdesc3	:= "BARRAJE DE NEUTRO 6 TERMINALES EASY9"
	ElseIf Alltrim(SB1->B1_COD) $ "EZ9E33B08N" 
		cimgqd:="qdez9e33b08.GRF" 
		cdesc1	:= "BARRAMENTO 8 TERMINAIS NEUTRO EASY9"
		cdesc2	:= "NEUTRAL BAR 8 CONNECTIONS EASY9"
		cdesc3	:= "BARRAJE DE NEUTRO 8 TERMINALES EASY9"
	ElseIf Alltrim(SB1->B1_COD) $ "EZ9E33B08U" 
		cimgqd:="qdez9e33b08u.GRF"
		cdesc1	:= "BARRAMENTO 8 TERMINAIS NEUTRO/TERRA EASY9"
		cdesc2	:= "GROUND/NEUTRAL BAR 8 CONNECTIONS EASY9"
		cdesc3	:= "BARRAJE DE NEUTRO/TIERRA 8 TERMINALES EASY9"
	ElseIf Alltrim(SB1->B1_COD) $ "EZ9E33B11E" 
		cimgqd:="qdez9e33b11.GRF"
		cdesc1	:= "BARRAMENTO 11 TERMINAIS TERRA EASY9"
		cdesc2	:= "GROUND BAR 11 CONNECTIONS EASY9"
		cdesc3	:= "BARRAJE DE TIERRA 11 TERMINALES EASY9"	
	ElseIf Alltrim(SB1->B1_COD) $ "EZ9E33B11N" 
		cimgqd:="qdez9e33b11.GRF"
		cdesc1	:= "BARRAMENTO 11 TERMINAIS NEUTRO EASY9"
		cdesc2	:= "NEUTRAL BAR 11 CONNECTIONS EASY9"
		cdesc3	:= "BARRAJE DE NEUTRO 11 TERMINALES EASY9"	
	ElseIf Alltrim(SB1->B1_COD) $ "EZ9E33B12U" 
		cimgqd:="qdeze33b12u.GRF"
		cdesc1	:= "BARRAMENTO 12 TERMINAIS NEUTRO/TERRA EASY9"
		cdesc2	:= "GROUND/NEUTRAL BAR 12 CONNECTIONS EASY9"
		cdesc3	:= "BARRAJE DE NEUTRO/TIERRA 12 TERMINALES EASY9"		
		//<< Ticket 20200415001660
	EndIf

Return .T.
