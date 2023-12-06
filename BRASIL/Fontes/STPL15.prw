#INCLUDE "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT410TOK  ºAutor  ³Microsiga           º Data ³  12/09/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de Entrada na validacao TUDOOK do pedido de venda     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function STPL15()

Local _cLoja        := "M->C5_LOJACLI"
Local _cCliente     := "M->C5_CLIENTE"
Local cProdBLQ	    := GetMv("FS_PRODBLQ",.F.,"1020")
Local cTesBLQ	    := GetMv("FS_TESBLQ",.F.,"501") 
Local cOperBLQ	    := GetMv("FS_OPEBLQ",.F.,"02")
Local nPrcCon    	:= 0.02
Local aTMP          := {}
Local _lRet         := IsInCallSteck("MT410TOK")  .Or. IsInCallSteck("U_MT410TOK")

If    ( Type("l410Auto") == "U" .OR. !l410Auto )
dbSelectArea("SA1")
SA1->(dbSetOrder(1))
If SA1->(DbSeek(xFilial("SA1")+&_cCliente+&_cLoja)) 
	If !Empty(Alltrim(MSMM(SA1->A1_XCODMC,43))) .And. !M->C5_TIPO$"D#B" 
		M->C5_ZBLOQ    := "1"
		M->C5_ZMOTBLO  := 	ALLTRIM(M->C5_ZMOTBLO) +"MSG/"
		M->C5_XMSGCLI  :=  Alltrim(MSMM(SA1->A1_XCODMC,43))
       If	!_lRet	
		//AutoGrLog
		Alert(Alltrim(MSMM(SA1->A1_XCODMC,43)))
		//MostraErro()
       EndIf   

	   	DbSelectArea("SB1")
		SB1->(DbGoTop(1))
		SB1->(DbSeek(xFilial("SB1")+cProdBLQ))

	   	DbSelectArea("SF4")
		SF4->(DbGoTop(1))
		SF4->(DbSeek(xFilial("SF4")+cTesBLQ))
       		
		aTMP := aClone({aCols[1]})
		aCols := aTMP
		n:=1
		aCols[1,len(aHeader)+1] := .F.
		GDFieldPut( "C6_PRODUTO"	, cProdBLQ	, n)
		GDFieldPut( "C6_QTDVEN"		, 1			, n)
		GDFieldPut( "C6_DESCRI"		, SB1->B1_DESC , n)
		GDFieldPut( "C6_PRCVEN"		, nPrcCon	, n)
		GDFieldPut( "C6_TES"		, cTesBLQ	, n)
		GDFieldPut( "C6_PRUNIT"		, nPrcCon	, n)
		GDFieldPut( "C6_XPRCLIS"	, nPrcCon	, n)
		GDFieldPut( "C6_VALOR"  	, nPrcCon   , n)
		GDFieldPut( "C6_OPER"  	    , u_STOPERTEL() , n)
		GDFieldPut( "C6_LOCAL"  	, SB1->B1_LOCPAD , n)
		GDFieldPut( "C6_ZNCM"  		, SB1->B1_POSIPI , n)
		GDFieldPut( "C6_CF"  		, SF4->F4_CF , n)

		If ( Type("l410Auto") == "U" .or. ! l410Auto)          //Inserido Jefferson Carlos dia 25/11/2013
			If !( oGetDad == Nil )                             //Inserido Jefferson Carlos dia 25/11/2013
				oDlg                      := GetWndDefault()   //Inserido Jefferson Carlos dia 25/11/2013
				oDlg := oGetDad:oWnd                           //Inserido Jefferson Carlos dia 25/11/2013
			EndIf                                              //Inserido Jefferson Carlos dia 25/11/2013
		EndIf   

		Ma410Rodap(,,0)
		oGetDad:oBrowse:refresh()
		oGetDad:oBrowse:disable()
		
	EndIf
EndIf 
EndIf
Return (.F.)


 *---------------------------------------------------*
User Function STOPERTEL()
 *---------------------------------------------------*

Local oDlgEmail
Local _cVal       :=  SPACE(2)
Local lSaida      := .F.
Local nOpca       :=  0

Do While !lSaida
	nOpcao := 0
	DEFINE MSDIALOG oDlgEmail TITLE OemToAnsi("Digite o Tipo de Oper.") From  1,0 To 80,200 Pixel OF oMainWnd
	
	@ 02,04 SAY "Tp. Oper.:" PIXEL OF oDlgEmail
	@ 12,04 MSGet _cVal   Size 25,013  PIXEL OF oDlgEmail valid  ExistCpo("SX5","DJ"+_cVal)    f3 "DJ"                                                                                                 
	@ 12,62 Button "Ok"      Size 28,13 Action iif(!Empty(Alltrim(_cVal)) .and. ExistCpo("SX5","DJ"+_cVal)  ,Eval({||lSaida:=.T.,nOpca:=1,oDlgEmail:End()}),msginfo("Nao Encontrado Tip. Oper."))  Pixel
	
	ACTIVATE MSDIALOG oDlgEmail CENTERED
EndDo


Return (_cVal )
