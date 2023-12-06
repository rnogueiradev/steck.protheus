#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  RSTFAT84     ºAutor  ³Renato Nogueira º Data ³  29/06/15     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Relatório de divergências do inventário                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RSTFAT84()
         
	Local _aRet 			:= {}
	Local _aParamBox 		:= {}
	Local cQuery1 	:= ""
	Local cAlias1 	:= "QRYTEMP"
	Local cQuery2 	:= ""
	Local cAlias2 	:= "QRYTEMP2"
	Private _cNomeCom  	:= SM0->M0_NOMECOM
	Private _cEndereco 	:= SM0->M0_ENDENT
	Private cCep       	:= SM0->M0_CEPENT
	Private cCidade    	:= SM0->M0_CIDENT
	Private cEstado    	:= SM0->M0_ESTENT
	Private cCNPJ      	:= SM0->M0_CGC
	Private cTelefone  	:= SM0->M0_TEL
	Private cFax       	:= SM0->M0_FAX
	Private _cNomePdf 	:= ""
	Private cStartPath	:= '\arquivos\pedido\'//GetSrvProfString("Startpath","") +'orcamento\'
	Private _cDirRel  	:= Getmv("MV_RELT",,'C:\ARQUIVOS_PROTHEUS\')
	Private nPlin		:= 10 //Pula linha
	Private nLin		:= 0 //Pula linha
	Private nLin2		:= 0 //Pula linha
	Private nLin3		:= 1 //Pula linha
	Private nLinCB	:= 0 //Pula linha
	Private nItens		:= 0 //Número de itens
	Private _nTotal		:= 0
	
	//AADD(_aParamBox,{1,"Nome"			,Space(30),""  ,"","","",0,.F.}) //50
	//AADD(_aParamBox,{1,"Mestre de"		,Space(9) ,""  ,"","","",0,.F.}) //50
	//AADD(_aParamBox,{1,"Mestre ate" 	,Space(9) ,""  ,"","","",0,.F.}) //50
		
	//If ParamBox(_aParamBox,"Mestre de inventário        ",@_aRet,,,.T.,,500)
	
	_cNomePdf  := cEmpAnt+"_Pedido_"+MV_PAR01
		
	oPrint:= fwmsprinter():New( _cNomePdf , 6      ,.F.             , '\arquivos\Pedido\'  ,.T.			,  ,  ,  ,  .f.,  ,.f.,.f. )
	oPrint:SetPortrait()     //Retrato - SetPortrait() ou Paisagem - SetLandscape()
	oPrint:SetMargin(30,30,30,30)
	oPrint:setPaperSize(9)

	aBmp := "STECK.BMP"

	oFont2n := TFont():New("Times New Roman",,10,,.T.,,,,,.F. )
	oFont8  := TFont():New("Arial",9,8 ,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont9  := TFont():New("Arial",9,9 ,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont10 := TFont():New("Arial",9,10,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont10n:= TFont():New("Arial",9,10,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont11 := TFont():New("Arial",9,11,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont11n:= TFont():New("Arial",9,11,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont12 := TFont():New("Arial",9,12,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont12n:= TFont():New("Arial",9,12,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont13 := TFont():New("Arial",9,13,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont13n:= TFont():New("Arial",9,13,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont14n:= TFont():New("Arial",9,14,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont15n:= TFont():New("Arial",9,15,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont16 := TFont():New("Arial",9,16,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont16n:= TFont():New("Arial",9,16,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont17 := TFont():New("Arial",9,17,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont17n:= TFont():New("Arial",9,17,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont20 := TFont():New("Arial",9,18,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont20n:= TFont():New("Arial",9,18,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont18 := TFont():New("Arial",9,18,.T.,.T.,5,.T.,5,.T.,.F.)

	oPrint:StartPage()     // INICIALIZA a página
	
	//IMPCABEC()
	
	nLin	:= 100
	nLinCB	:= 7
	
	cQuery1 := " SELECT CODIGO, QTDLEGADO, QTDPROTHEUS, UNIDADE, DESCRICAO "
	cQuery1 += " FROM ( "
	cQuery1 += " SELECT B1_COD CODIGO, B1_ZQATU QTDLEGADO, B1_UM UNIDADE, B1_DESC DESCRICAO, "
	cQuery1 += " (SELECT SUM(B7_QUANT) FROM SB7030 B7 WHERE B7.D_E_L_E_T_=' ' AND B7.B7_COD=B1.B1_COD) QTDPROTHEUS "
	cQuery1 += " FROM SB1030 B1 "
	cQuery1 += " WHERE B1.D_E_L_E_T_=' ' AND B1_PORCPRL='S' ) "
	cQuery1 += " WHERE QTDPROTHEUS<>QTDLEGADO "

	If !Empty(Select(cAlias1))
		DbSelectArea(cAlias1)
		(cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery1),cAlias1,.T.,.T.)

	dbSelectArea(cAlias1)
	(cAlias1)->(dbGoTop())

	
	While (cAlias1)->(!Eof())
	
		nItens++
	
		//oPrint:Say (nLin,002, (cAlias1)->CBA_CODINV																		,oFont12) //ITEM
		//oPrint:FWMSBAR("CODE128",nLinCB,032,(cAlias1)->CBA_CODINV,oPrint,/*lCheck*/,/*Color*/,/*lHorz*/,0.018 /*nWidth*/,0.75/*nHeigth*/, .T. /*lBanner*/,/*cFont*/,/*cMode*/,.F./*lPrint*/,/*nPFWidth*/,/*nPFHeigth*/,/*lCmtr2Pix*/)
		
		nLin	+= 80
		nLinCB	+= 6.7
	
		If nItens==1 //Pula página
			nItens	:= 0
			nLin	:= 100
			nLinCB	:= 8
			
	//Primeiro box
	oPrint:box (020,001,045,580,"-1")

	oPrint:Say  (035,005,CVALTOCHAR(nLin3)+" PRODUTO: "+ AllTrim((cAlias1)->CODIGO)+ ;
	"       QTD LEGADO: "+ CVALTOCHAR((cAlias1)->QTDLEGADO) + "       QTD PROTHEUS: "+ ;
	CVALTOCHAR((cAlias1)->QTDPROTHEUS)  ,oFont15n)
	
	nLin3++

	cQuery2 := " SELECT CODIGO, QTDLEGADO, QTDPROTHEUS, UNIDADE, DESCRICAO, B7_DOC, B7_LOCALIZ, B7_QUANT "
	cQuery2 += " FROM ( "
	cQuery2 += " SELECT B1_COD CODIGO, B1_ZQATU QTDLEGADO, B1_UM UNIDADE, B1_DESC DESCRICAO, "
	cQuery2 += " (SELECT SUM(B7_QUANT) FROM SB7030 B7 WHERE B7.D_E_L_E_T_=' ' AND B7.B7_COD=B1.B1_COD) QTDPROTHEUS "
	cQuery2 += " FROM SB1030 B1 "
	cQuery2 += " WHERE B1.D_E_L_E_T_=' ' AND B1_PORCPRL='S' "
	cQuery2 += " ) "
	cQuery2 += " LEFT JOIN SB7030 SB7 "
	cQuery2 += " ON B7_COD=CODIGO "
	cQuery2 += " WHERE QTDPROTHEUS<>QTDLEGADO AND SB7.D_E_L_E_T_=' ' AND CODIGO='"+(cAlias1)->CODIGO+"' "
	

	If !Empty(Select(cAlias2))
		DbSelectArea(cAlias2)
		(cAlias2)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery2),cAlias2,.T.,.T.)

	dbSelectArea(cAlias2)
	(cAlias2)->(dbGoTop())
	
	nLin2	:= 060
		
	While (cAlias2)->(!Eof())

	oPrint:Say  (nLin2,005,"PRODUTO: "+ AllTrim((cAlias2)->CODIGO)+ ;
	"       MESTRE: "+ (cAlias2)->B7_DOC + "       END: "+ ;
	(cAlias2)->B7_LOCALIZ+ "       QUANT: "+ CVALTOCHAR((cAlias2)->B7_QUANT)+ "_____________"  ,oFont15n)
	
	nLin2	+= 15
	
	(cAlias2)->(DbSkip())
	
	EndDo

			
			oPrint:EndPage()       // Finaliza a página
			oPrint:StartPage()     // INICIALIZA a página
			//IMPCABEC()
		EndIf
	
		(cAlias1)->(DbSkip())
		
	EndDo

	FERASE(cStartPath+_cNomePdf+".pdf")
	oPrint:cPathPDF := cStartPath
	
	oPrint:Print()
	oPrint:EndPage()     
	
	CpyS2T(cStartPath+_cNomePdf+'.pdf',_cDirRel+"\",.T.) // COPIA ARQUIVO PARA MAQUINA DO USUÁRIO
	ShellExecute("open",_cDirRel+"\"+_cNomePdf+'.pdf', "", "", 1)
	
	//EndIf

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ IMPCABEC ³ Autor ³ Renato Nogueira       ³ Data ³ 20/05/15 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Imprime cabeçalho						  			              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ 		                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function IMPCABEC()

	//Primeiro box
	oPrint:box (020,001,045,580,"-1")

	oPrint:Say  (035,005,"PRODUTO: "+ AllTrim((cAlias1)->CODIGO)+ ;
	"QTD LEGADO: "+ CVALTOCHAR((cAlias1)->QTDLEGADO) + "QTD PROTHEUS: "+ ;
	CVALTOCHAR((cAlias1)->QTDPROTHEUS)  ,oFont15n)
	
Return()