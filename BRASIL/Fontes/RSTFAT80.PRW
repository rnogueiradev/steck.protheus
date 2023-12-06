#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  RSTFAT80     ºAutor  ³Renato Nogueira º Data ³  01/06/15     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Relatorio packing list				                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RSTFAT80()

	Local _aRet 			:= {}
	Local _aParamBox 		:= {}
	Local nRec				:= 0
	Local nQtd				:= 0
	Private cQuery1		:= ""
	Private cAlias1		:= "QRYTEMP"
	Private _cNomeCom  	:= SM0->M0_NOMECOM
	Private _cEndereco 	:= SM0->M0_ENDENT
	Private cCep       	:= SM0->M0_CEPENT
	Private cCidade    	:= SM0->M0_CIDENT
	Private cEstado    	:= SM0->M0_ESTENT
	Private cCNPJ      	:= SM0->M0_CGC
	Private cTelefone  	:= SM0->M0_TEL
	Private cFax       	:= SM0->M0_FAX
	Private _cNomePdf 	:= ""
	Private cStartPath	:= 'C:\arquivos_protheus\'//GetSrvProfString("Startpath","") +'orcamento\'
	Private _cDirRel  	:= Getmv("MV_RELT",,'C:\ARQUIVOS_PROTHEUS\')
	Private nPlin		:= 10 //Pula linha
	Private nLin		:= 0 //Pula linha
	Private nLinCB	:= 0 //Pula linha
	Private nItens		:= 0 //Número de itens
	Private _nTotal		:= 0

	AADD(_aParamBox,{1,"NF de"			,Space(9) ,""  ,"","","",0,.F.}) //50
	AADD(_aParamBox,{1,"NF ate"			,Space(9) ,""  ,"","","",0,.F.}) //50
	AADD(_aParamBox,{1,"SERIE"			,Space(3) ,""  ,"","","",0,.F.}) //50
	AADD(_aParamBox,{1,"PEQUENA(S/N)"	,Space(1) ,""  ,"","","",0,.F.}) //50

	If ParamBox(_aParamBox,"Filtro de notas        ",@_aRet,,,.T.,,500)

		cQuery1  := " SELECT F2_FILIAL, F2_DOC, F2_SERIE, F2_CLIENTE "
		cQuery1  += " FROM " +RetSqlName("SF2")+ " F2 "
		cQuery1  += " WHERE F2.D_E_L_E_T_=' ' AND F2_FILIAL='"+cFilAnt+"' AND F2_DOC BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
		//	cQuery1  += " AND F2_SERIE='"+MV_PAR03+"' AND F2_CLIENTE='038134' "
		cQuery1  += " AND F2_SERIE='"+MV_PAR03+"'"

		If !Empty(Select(cAlias1))
			DbSelectArea(cAlias1)
			(cAlias1)->(dbCloseArea())
		Endif

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery1),cAlias1,.T.,.T.)

		Count To nRec

		dbSelectArea(cAlias1)
		(cAlias1)->(dbGoTop())

		If MV_PAR04=="S"
			STETIQPEQ()
			Return()
		EndIf

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

		While (cAlias1)->(!Eof())

			nQtd++

			DbSelectArea("SF2")
			SF2->(DbSetOrder(1))
			SF2->(DbGoTop())
			SF2->(DbSeek(xFilial("SF2")+(cAlias1)->(F2_DOC+F2_SERIE)))

			DbSelectArea("SA1")
			SA1->(DbSetOrder(1))
			SA1->(DbGoTop())
			SA1->(DbSeek(xFilial("SA1")+SF2->(F2_CLIENTE+F2_LOJA)))

			DbSelectArea("SD2")
			SD2->(DbSetOrder(3))
			SD2->(DbGoTop())
			SD2->(DbSeek(xFilial("SD2")+SF2->(F2_DOC+F2_SERIE)))

			IMPCABEC()

			nLin	:= 135
			nLinCB	:= 10

			While SD2->(!Eof()) .And. SF2->(F2_FILIAL+F2_DOC+F2_SERIE)==SD2->(D2_FILIAL+D2_DOC+D2_SERIE)

				nItens++
				
				DbSelectArea("SB1")
				SB1->(DbSetOrder(1))
				SB1->(DbGoTop())
				SB1->(DbSeek(xFilial("SB1")+SD2->D2_COD))

				oPrint:Say (nLin,002, SD2->D2_COD																		,oFont12) //ITEM
				oPrint:Say (nLin,070, SubStr(SB1->B1_DESC,1,40)																		,oFont12) //CÓDIGO
				oPrint:Say (nLin+10,070, SubStr(SB1->B1_DESC,41,99999)																		,oFont12) //CÓDIGO
				oPrint:Say (nLin,315, CVALTOCHAR(SD2->D2_QUANT)															,oFont12) //DESCRIÇAO
				oPrint:Say (nLin,345, SB1->B1_UM																		,oFont12) //NCM
				//oPrint:FWMSBAR("EAN13",001,001,SB1->B1_CODBAR,oPrint) //EAN13 
				oPrint:FWMSBAR("CODE128",nLinCB,032,SB1->B1_CODBAR,oPrint,/*lCheck*/,/*Color*/,/*lHorz*/,0.018 /*nWidth*/,0.75/*nHeigth*/, .T. /*lBanner*/,/*cFont*/,/*cMode*/,.F./*lPrint*/,/*nPFWidth*/,/*nPFHeigth*/,/*lCmtr2Pix*/)

				nLin	+= 40
				nLinCB	+= 3.4

				If nItens==17 //Pula página
					nItens	:= 0
					nLin	:= 135
					nLinCB	:= 10
					oPrint:EndPage()       // Finaliza a página
					oPrint:StartPage()     // INICIALIZA a página
					IMPCABEC()
				EndIf

				SD2->(DbSkip())

			EndDo

			If !(nQtd==nRec)
				nItens	:= 0
				nLin	:= 135
				nLinCB	:= 10
				oPrint:EndPage()       // Finaliza a página
				oPrint:StartPage()     // INICIALIZA a página
				IMPCABEC()
			EndIf

			(cAlias1)->(DbSkip())

		EndDo

		FERASE(_cDirRel+_cNomePdf+".pdf")
		oPrint:cPathPDF := cStartPath

		oPrint:Print()
		oPrint:EndPage()

		//CpyS2T(cStartPath+_cNomePdf+'.pdf',_cDirRel+"\",.T.) // COPIA ARQUIVO PARA MAQUINA DO USUÁRIO
		ShellExecute("open",_cDirRel+"\"+_cNomePdf+'.pdf', "", "", 1)

	EndIf

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

	Local _aAreaSD2 := SD2->(GetArea())

	//Primeiro box
	oPrint:box (020,001,095,580,"-1")

	If File(aBmp)
		oPrint:SayBitmap(045,003,aBmp,100,030)
	EndIf

	oPrint:Say  (032,110, "STECK INDÚSTRIA ELÉTRICA LTDA"  ,oFont12)
	oPrint:Say  (042,110, _cEndereco ,oFont12)
	oPrint:Say  (052,110,"CEP "+ SUBSTR(cCep,1,5)+SUBSTR(cCep,6,3) +" - "+Alltrim(cCidade)+" - "+cEstado,oFont12)
	//oPrint:Say  (062,110,"TEL.: (11) 2248-7000 | FAX.: (11) 2248-7051 | E-MAIL: contato.vendas@steck.com.br",oFont12)
	If !(AllTrim(SF2->F2_CLIENTE)+'00' $ GetMv("ST_ETIEXP"))
		_cPed := Posicione("SD2",3,xFilial("SF2")+SF2->F2_DOC+SF2->F2_SERIE,"D2_PEDIDO")
		oPrint:Say  (072,110,"CLIENTE: "+SA1->A1_NOME+" LOJA: "+Posicione("SC5",1,xFilial("SC5")+_cPed,"C5_XOBSVEN"),oFont12)
	Else
		oPrint:Say  (072,110,"CLIENTE: "+SA1->A1_NOME+" LOJA: "+SA1->A1_XLOJA,oFont12)
	EndIf
	oPrint:Say  (082,110,"NOTA FISCAL: "+CVALTOCHAR(SF2->F2_DOC)+"           TOTAL DE VOLUMES: "+CVALTOCHAR(SF2->F2_VOLUME1),oFont12)

	//Segundo box
	oPrint:box (097,001,115,580,"-1")
	oPrint:Say (110,002, "CÓDIGO"  		,oFont12)
	oPrint:Say (110,070, "DESCRIÇÃO"   ,oFont12)
	oPrint:Say (110,315, "QTD"		   ,oFont12)
	oPrint:Say (110,345, "UM"		   ,oFont12)
	oPrint:Say (110,375, "CÓD BARRAS"  ,oFont12)
	
	RestArea(_aAreaSD2)

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  STETIQPEQ     ºAutor  ³Renato Nogueira º Data ³  01/06/15    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Imprime etiqueta de volumes menor                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function STETIQPEQ()

	Local cLocImp	:= Space(06)
	Local aParBox	:= {}
	Local aRetPar	:= {}
//	Local nLinH	:= 0
//	Local nLinV 	:= 0
//	Local ctamG		:= "023,044"
	Local ctamM		:= "024,037"
//	Local ctamP		:= "020,018"
//	Local ctamx		:= "016,014"
	Local _nx	:= 0
	Local _cPed := ""
	LOCAL nSleep := 0

	//aParBox := {1,"Local Impressao"	,	cLocImp	,	""			,"","CB5"	,".T.",0,.T.}
	AADD(aParBox,{1,"Local Impressao",cLocImp,"","","CB5","",0,.F.})


	If ParamBox(aParBox,"Parametros",@aRetPar,,,,,,,,.f.)
		cLocImp	:= aRetPar[1]
		DbSelectArea("CB5")
		CB5->(DbSetOrder(1))
		If !CB5->(DbSeek(xFilial("CB5")+Trim(cLocImp)))
			MsgAlert("Local de Impressão Inválido")
			Return
		Endif

		While (cAlias1)->(!Eof())

			DbSelectArea("SF2")
			SF2->(DbSetOrder(1))
			SF2->(DbGoTop())
			SF2->(DbSeek(xFilial("SF2")+(cAlias1)->(F2_DOC+F2_SERIE)))

			DbSelectArea("SA1")
			SA1->(DbSetOrder(1))
			SA1->(DbGoTop())
			SA1->(DbSeek(xFilial("SA1")+SF2->(F2_CLIENTE+F2_LOJA)))

			//	DbSelectArea("SC5")
			//	SC5->(DbSetOrder(1))
			//SC5->(DbGoTop())
			//	SC5->(DbSeek(xFilial("SC5")))


			For _nX:=1 To SF2->F2_VOLUME1

				IF nSleep >= 5
				  nSleep := 0
					Sleep( 5000 )
				ELSE
					nSleep++
				ENDIF

				If !(AllTrim(SF2->F2_CLIENTE)+'00' $ GetMv("ST_ETIEXP"))

					CB5SetImp(cLocImp)
					MSCBCHKSTATUS(.F.)
					MSCBBEGIN(1,6)

					_cPed := Posicione("SD2",3,xFilial("SF2")+SF2->F2_DOC+SF2->F2_SERIE,"D2_PEDIDO")

					MSCBSAY(04,04,SA1->A1_NOME							,"N","0",ctamM)
					MSCBSAY(04,12,"VOL: "+CVALTOCHAR(_nX)+"/"+CVALTOCHAR(SF2->F2_VOLUME1)							,"N","0",ctamM)
					MSCBSAY(04,20,"NF: "+SF2->F2_DOC							,"N","0",ctamM)
					MSCBSAY(04,28,"LOJA: " +Posicione("SC5",1,xFilial("SC5")+_cPed,"C5_XOBSVEN"),"N","0",ctamM)
					//MSCBSAY(04,28,"LOJA: " +SC5->C5_XOBSVEN						,"N","0",ctamM)			
					MSCBSAY(04,36,"PEDIDO: "+_cPed+" - OC: " + Posicione("SC5",1,xFilial("SC5")+_cPed,"C5_XORDEM")							,"N","0",ctamM)
					MSCBEND()
					MSCBCLOSEPRINTER()
					
				ELSE

					CB5SetImp(cLocImp)
					MSCBCHKSTATUS(.F.)
					MSCBBEGIN(1,6)

					MSCBSAY(04,04,SA1->A1_NOME							,"N","0",ctamM)
					MSCBSAY(04,12,"VOL: "+CVALTOCHAR(_nX)+"/"+CVALTOCHAR(SF2->F2_VOLUME1)							,"N","0",ctamM)
					MSCBSAY(04,20,"NF: "+SF2->F2_DOC							,"N","0",ctamM)
					MSCBSAY(04,28,"LOJA: "+SA1->A1_XLOJA							,"N","0",ctamM)
					MSCBSAY(04,36,"PEDIDO: "+Posicione("SD2",3,SF2->(F2_FILIAL+F2_DOC+F2_SERIE),"D2_PEDIDO")+" - OC: ";
					+Posicione("SC5",1,xFilial("SC5")+Posicione("SD2",3,SF2->(F2_FILIAL+F2_DOC+F2_SERIE),"D2_PEDIDO"),"C5_XORDEM")	,"N","0",ctamM)
					MSCBEND()
					MSCBCLOSEPRINTER()

				ENDIF

			Next

			(cAlias1)->(DbSkip())

		EndDo


	Endif

Return()
