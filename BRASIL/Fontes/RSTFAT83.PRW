#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  RSTFAT83     บAutor  ณRenato Nogueira บ Data ณ  24/06/15     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relat๓rio de altera็๕es de fornecedores                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function RSTFAT83()
         
	Local _aRet 			:= {}
	Local _aParamBox 		:= {}
	Local cQuery1 	:= ""
	Local cAlias1 	:= "QRYTEMP"
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
	Private nLinCB	:= 0 //Pula linha
	Private nItens		:= 0 //N๚mero de itens
	Private _nTotal		:= 0
	
	AADD(_aParamBox,{1,"Nome"			,Space(30),""  ,"","","",0,.F.}) //50
	AADD(_aParamBox,{1,"Mestre de"		,Space(9) ,""  ,"","","",0,.F.}) //50
	AADD(_aParamBox,{1,"Mestre ate" 	,Space(9) ,""  ,"","","",0,.F.}) //50
		
	If ParamBox(_aParamBox,"Mestre de inventแrio        ",@_aRet,,,.T.,,500)
	
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

	oPrint:StartPage()     // INICIALIZA a pแgina
	
	IMPCABEC()
	
	nLin	:= 100
	nLinCB	:= 7
	
	cQuery1 := " SELECT CBA_CODINV, CBA_LOCALI "
	cQuery1 += " FROM " +RetSqlName("CBA")+ " CBA "
	cQuery1 += " WHERE D_E_L_E_T_=' ' AND CBA_CODINV BETWEEN '"+MV_PAR02+"' AND '"+MV_PAR03+"' "
	cQuery1	+= " ORDER BY CBA_CODINV "

	If !Empty(Select(cAlias1))
		DbSelectArea(cAlias1)
		(cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery1),cAlias1,.T.,.T.)

	dbSelectArea(cAlias1)
	(cAlias1)->(dbGoTop())

	
	While (cAlias1)->(!Eof())
	
		nItens++
	
		oPrint:Say (nLin,002, (cAlias1)->CBA_LOCALI																		,oFont12) //ITEM
		oPrint:FWMSBAR("CODE128",nLinCB,032,(cAlias1)->CBA_CODINV,oPrint,/*lCheck*/,/*Color*/,/*lHorz*/,0.018 /*nWidth*/,0.75/*nHeigth*/, .T. /*lBanner*/,/*cFont*/,/*cMode*/,.F./*lPrint*/,/*nPFWidth*/,/*nPFHeigth*/,/*lCmtr2Pix*/)
		
		nLin	+= 80
		nLinCB	+= 6.7
	
		If nItens==9 //Pula pแgina
			nItens	:= 0
			nLin	:= 100
			nLinCB	:= 8
			oPrint:EndPage()       // Finaliza a pแgina
			oPrint:StartPage()     // INICIALIZA a pแgina
			IMPCABEC()
		EndIf
	
		(cAlias1)->(DbSkip())
		
	EndDo

	FERASE(cStartPath+_cNomePdf+".pdf")
	oPrint:cPathPDF := cStartPath
	
	oPrint:Print()
	oPrint:EndPage()     
	
	CpyS2T(cStartPath+_cNomePdf+'.pdf',_cDirRel+"\",.T.) // COPIA ARQUIVO PARA MAQUINA DO USUมRIO
	ShellExecute("open",_cDirRel+"\"+_cNomePdf+'.pdf', "", "", 1)
	
	EndIf

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFuno    ณ IMPCABEC ณ Autor ณ Renato Nogueira       ณ Data ณ 20/05/15 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescrio ณImprime cabe็alho						  			              ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณUso       ณ 		                                                     ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function IMPCABEC()

	//Primeiro box
	oPrint:box (020,001,045,580,"-1")

	oPrint:Say  (035,005,"OPERADOR RESPONSAVEL: "+ MV_PAR01  ,oFont15n)
	
Return()