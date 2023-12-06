#INCLUDE "Rwmake.ch"
//Alinhamentos
#Define PAD_LEFT    0
#Define PAD_RIGHT   1
#Define PAD_CENTER  2
#Define PAD_JUSTIFY 3 //Opção disponível somente a partir da versão 1.6.2 da TOTVS Printer

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ RSTFAT78 ³ Autor ³ Renato Nogueira       ³ Data ³ 20/05/15 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Rotina de impressão do pro-forma  			              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ 		                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RSTFAT78()

	local nx := 0

	Private _cPerg 	 := PadR ("RSTFAT78", Len (SX1->X1_GRUPO)) //>> Chamado 007053 - Inclui no fonte a opção de impressão do dados bancários do Mexico - Everson Santana - 26.03.2018
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
	Private nPlin			:= 10 //Pula linha
	Private nLin			:= 0 //Pula linha
	Private nItens		:= 0 //Número de itens
	Private _nTotal		:= 0
	Private _nPag			:= 0
	Private _nTotItens	:= 0
	Private oPrint      := NIL

	Private cNomeFont  := "Arial"
	Private oFontDet   := TFont():New(cNomeFont,16, -14, .T., .F., 5, .T., 5, .T., .T.)
	Private oFontDetN  := TFont():New(cNomeFont,16, -14, .T., .T., 5, .T., 5, .T., .F.)

	Pergunte(_cPerg,.T.) //>> Chamado 007053 - Inclui no fonte a opção de impressão do dados bancários do Mexico - Everson Santana - 26.03.2018

	_cNomePdf  :=cEmpAnt+"_Pedido_"+PPJ->PPJ_NUM

	oPrint:= fwmsprinter():New( _cNomePdf , 6      ,.F.             , '\arquivos\Pedido\'  ,.T.			,  ,  ,  ,  .f.,  ,.f.,.f. )
	oPrint:SetPortrait()     //Retrato - SetPortrait() ou Paisagem - SetLandscape()
	oPrint:SetMargin(30,30,30,30)
	oPrint:setPaperSize(9)

	aBmp := "STECK.BMP"

	oFont2n := TFont():New("Times New Roman",,10,,.T.,,,,,.F. )
	oFont8  := TFont():New("Arial",9,8 ,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont8n := TFont():New("Courier",9,11 ,.T.,.T.,5,.T.,5,.T.,.F.)
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

	_nTotItens	:= TOTALITENS()

	IMPCABEC()

	DbSelectArea("PPL")
	PPL->(DbSetOrder(1))
	PPL->(DbGoTop())
	PPL->(DbSeek(xFilial("PPL")+PPJ->PPJ_NUM))

	nLin	:= 245

	While PPL->(!Eof()) .And. PPJ->PPJ_NUM==PPL->PPL_NUM

		nItens++
		_nTotal	+= PPL->PPL_TOTAL

		DbSelectArea("SB1")
		SB1->(DbSetOrder(1))
		SB1->(DbGoTop())
		SB1->(DbSeek(xFilial("SB1")+PPL->PPL_PRODUT))

		nLin	+= 17

		oPrint:Say (nLin,008, PPL->PPL_ITEM																		,oFont8) //ITEM
		oPrint:Say (nLin,032, PPL->PPL_PRODUT																		,oFont8) //CÓDIGO
		oPrint:Say (nLin,100, SB1->B1_DESC																			,oFont8) //DESCRIÇAO
		oPrint:Say (nLin,355, SB1->B1_POSIPI																		,oFont8) //NCM
		//oPrint:Say (nLin,387, PADL(StrTran(AllTrim(CVALTOCHAR(PPL->PPL_QUANT)),".",","),8)															,oFont8n) //QTDE
		//oPrint:Say (nLin,455, PADL(AllTrim(TRANSFORM(PPL->PPL_PRCVEN,"@E 99,999,999,999.99")),8)														,oFont8n)
		//oPrint:Say (nLin,510, PADL(AllTrim(TRANSFORM(PPL->PPL_TOTAL, "@E 99,999,999,999.99")),8)															,oFont8n)
		oPrint:Say (nLin,350, TRANSFORM(PPL->PPL_QUANT ,"@E 99,999,999,999.99")													,oFont8n) //QTDE
		oPrint:Say (nLin,410, TRANSFORM(PPL->PPL_PRCVEN,"@E 99,999,999,999.99")											,oFont8n)
		oPrint:Say (nLin,475, TRANSFORM(PPL->PPL_TOTAL ,"@E 99,999,999,999.99")											,oFont8n)

		If (nItens==23 .And. _nPag==1) .Or. (nItens==33 .And. _nPag>1) //Pula página
			nItens	:= 0
			nLin	:= 95//245
			oPrint:EndPage()       // Finaliza a página
			oPrint:StartPage()     // INICIALIZA a página
			IMPCABEC()
		EndIf

		PPL->(DbSkip())

	EndDo

	oPrint:Line( 640, 001, 640, 580, ,"-4")

	oPrint:Say (652,396, "SUB-TOTAL "+STGETFRE(PPJ->PPJ_TPFRET)										,oFont12) //SUBTOTAL FOB
	oPrint:Say (652,470, ": $ "+TRANSFORM(_nTotal,"@E 99,999,999,999.99")							,oFont8n) //SUBTOTAL FOB
	oPrint:Say (662,396, "FLETE EST"																		,oFont12) //SUBTOTAL FOB
	oPrint:Say (662,470, ": $ "+TRANSFORM(PPJ->PPJ_FRETE,"@E 99,999,999,999.99")					,oFont8n) //SUBTOTAL FOB
	oPrint:Say (672,396, "SEGURO"																			,oFont12) //SUBTOTAL FOB
	oPrint:Say (672,470, ": $ "+TRANSFORM(PPJ->PPJ_SEGURO,"@E 99,999,999,999.99")								,oFont8n) //SUBTOTAL FOB
	oPrint:Say (682,396, "DESCUENTO"																		,oFont12) //SUBTOTAL FOB
	oPrint:Say (682,470, ": $ "+TRANSFORM(PPJ->PPJ_DESC,"@E 99,999,999,999.99")					,oFont8n) //SUBTOTAL FOB
	oPrint:Say (692,396, "TOTAL "+STGETFRE(PPJ->PPJ_TPFRET)																		,oFont12) //SUBTOTAL FOB
	oPrint:Say (692,470, ": $ "+TRANSFORM(_nTotal+PPJ->PPJ_FRETE-PPJ->PPJ_DESC+PPJ->PPJ_SEGURO,"@E 99,999,999,999.99")		,oFont8n) //SUBTOTAL FOB

	FERASE(cStartPath+_cNomePdf+".pdf")
	oPrint:cPathPDF := cStartPath

	oPrint:EndPage()

	//chamado 20231009012628 - inclusao cláusulas
	oPrint:StartPage()
	IMPCABEC("CL")

	aTexto     := fCriaTexto()
	nLinAtu    := 130
	nLinFin    := 550
	nColIni    := 050
	nColFin    := 580
	nEspCol    := (nColFin-(nColIni+150))/13
	nColMeio   := (nColFin-nColIni)/2

	oPrint:SayAlign(nLinAtu, nColIni, "Clausulas",                         oFontDetN,   (nColFin - nColIni),    300, , PAD_JUSTIFY,  )

	nLinAtu += 30

	for nX := 1 to len(aTexto)
		if substr(aTexto[nX],1,6) = "Global"
			oPrint:SayAlign(nLinAtu, nColIni, aTexto[nX],                         oFontDetN,   (nColFin - nColIni),    300, , PAD_JUSTIFY,  )
		else
			oPrint:SayAlign(nLinAtu, nColIni, aTexto[nX],                         oFontDet ,   (nColFin - nColIni),    300, , PAD_JUSTIFY,  )
		ENDIF
		nLinAtu += 15
		if nLinAtu > nLinFin
			oPrint:EndPage()     // Finaliza a página
			oPrint:StartPage()     // INICIALIZA a página
			IMPCABEC("CL")
			nLinAtu    := 130
		endif
	NEXT
	//Encerrando a impressão e exibindo o pdf
	oPrint:Print()
	oPrint:EndPage()


	CpyS2T(cStartPath+_cNomePdf+'.pdf',_cDirRel+"\",.T.) // COPIA ARQUIVO PARA MAQUINA DO USUÁRIO
	ShellExecute("open",_cDirRel+"\"+_cNomePdf+'.pdf', "", "", 1)

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ STGETFRE ³ Autor ³ Renato Nogueira       ³ Data ³ 20/05/15 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Devolve o nome do frete				  			              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ 		                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function STGETFRE(_cTpFrete)

	Local _cFrete	:= ""

	Do case
	Case _cTpFrete=="1"
		_cFrete	:= "FOB"
	Case _cTpFrete=="2"
		_cFrete	:= "FCA"
	Case _cTpFrete=="3"
		_cFrete	:= "CIF"
	Case _cTpFrete=="4"
		_cFrete	:= "CPT"
	Case _cTpFrete=="5"
		_cFrete	:= "EXW"
	Case _cTpFrete=="6"
		_cFrete	:= "FAS"
	Case _cTpFrete=="7"
		_cFrete	:= "CFR"
	Case _cTpFrete=="8"
		_cFrete	:= "CIP"
	Case _cTpFrete=="9"
		_cFrete	:= "DAT"
	Case _cTpFrete=="10"
		_cFrete	:= "DAP"
	Case _cTpFrete=="11"
		_cFrete	:= "DDP"
	EndCase

Return(_cFrete)

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

Static Function IMPCABEC(cCbc)

	Local _cMoeda	:= ""

	_nPag++

	//Primeiro box
	oPrint:box (020,001,075,580,"-1")

	If File(aBmp)
		oPrint:SayBitmap(025,003,aBmp,100,030)
	EndIf

	//oPrint:Say  (032,110, "STECK INDÚSTRIA ELÉTRICA LTDA"  ,oFont12)
	//oPrint:Say  (042,110, _cEndereco ,oFont12)
	//oPrint:Say  (052,110,"CEP: "+ SUBSTR(cCep,1,5)+"-"+SUBSTR(cCep,6,3) +" - "+Alltrim(cCidade)+" - "+cEstado,oFont12)
	//oPrint:Say  (062,110,"TEL.: (11) 2248-7000 | FAX.: (11) 2248-7051 | E-MAIL: contato.vendas@steck.com.br",oFont12)

	DbSelectArea("SA1")
	SA1->(DbSetOrder(1))
	SA1->(DbGoTop())
	SA1->(DbSeek(xFilial("SA1")+PPJ->(PPJ_CLIENTE+PPJ_LOJA)))

	If _nPag==1

		//Segundo box
		oPrint:box (075,001,095,580,"-1")
		oPrint:Say (090,250, "PROFORMA"  ,oFont16n)

		//Terceiro box
		oPrint:box (095,001,160,580,"-1")
		oPrint:Say (107,005, "CONSIGNATARIO"							,oFont12n)
		oPrint:Say (107,090, ": "+AllTrim(SA1->A1_NOME)				,oFont12)
		oPrint:Say (117,005, "DIRECCIÓN"  													,oFont12)
		oPrint:Say (117,090, ": "+AllTrim(SA1->A1_END)+" - "+AllTrim(SA1->A1_BAIRRO)+" - "+AllTrim(SA1->A1_MUN)+" - "+AllTrim(Posicione("SYA",1,xFilial("SYA")+SA1->A1_PAIS,"YA_DESCR"))	,oFont12)
		oPrint:Say (127,005, "RUC/NIT" 														,oFont12)
		oPrint:Say (127,090, ": "+SA1->A1_XRUCNIT												,oFont12)
		oPrint:Say (137,005, "CONTACTO" 		 												,oFont12)
		oPrint:Say (137,090, ": "+PPJ->PPJ_CONTAT											,oFont12)
		oPrint:Say (147,005, "FONE" 		 												,oFont12)
		oPrint:Say (147,090, ": "+PPJ->PPJ_TEL												,oFont12)

		oPrint:box (095,450,128,580,"-1")
		oPrint:Say (115,455, "FECHA"									,oFont12)
		oPrint:Say (115,520, ": "+DTOC(PPJ->PPJ_EMISSA)				,oFont12)

		oPrint:box (128,450,160,580,"-1")
		oPrint:Say (145,455,"FACTURA NR" 											,oFont12)
		oPrint:Say (145,520,": "+PPJ->PPJ_NUM+"/"+SubStr(DTOS(PPJ->PPJ_EMISSA),3,2)	,oFont12)

		//Quarto box
		oPrint:box (160,001,225,580,"-1")
		oPrint:box (160,001,175,580,"-1")
		oPrint:box (175,190,225,380,"-1")
		oPrint:Say (170,005, "CONDICIONES COMERCIALES"																		,oFont12n)

		oPrint:Say (185,002, "INCOTERM"	  																						,oFont12)
		oPrint:Say (185,055, ": "+STGETFRE(PPJ->PPJ_TPFRET)																	,oFont12)
		oPrint:Say (197,002, "MODAL"																							,oFont12)
		oPrint:Say (197,055, ": "+IIf(PPJ->PPJ_MODAL=="1","RODOVIÁRIO",IIF(PPJ->PPJ_MODAL=="2","MARÍTIMO","AÉREO"))	,oFont12)
		oPrint:Say (209,002, "ORIGEN"																						,oFont12)
		oPrint:Say (209,055, ": "+SubStr(PPJ->PPJ_PORTEM,1,20)																				,oFont12)
		oPrint:Say (221,002, "DESTINO" 																					,oFont12)
		oPrint:Say (221,055, ": "+SubStr(PPJ->PPJ_PORTDE,1,20)																				,oFont12)

		oPrint:Say (185,193, "PAIS ORIGEN"																							,oFont12)
		oPrint:Say (185,255, ": "+Iif(PPJ->PPJ_XPAISO=="B","BRASIL",IIf(PPJ->PPJ_XPAISO=="C","CHINA",""))											,oFont12)
		oPrint:Say (197,193, "COND. PAGO"																						,oFont12)
		oPrint:Say (197,255, ": "+SubStr(PPJ->PPJ_CONDPG,1,18)																				,oFont12)
		oPrint:Say (209,193, "CADUCIDAD"		 																				,oFont12)
		oPrint:Say (209,255, ": "+SubStr(PPJ->PPJ_VALIDA,1,18)																				,oFont12)
		oPrint:Say (221,193, "ENTREGA"																							,oFont12)
		oPrint:Say (221,255, ": "+CVALTOCHAR(PPJ->PPJ_DIAENT)+" DÍAS LABORALES"											,oFont12)

		Do case
		Case PPJ->PPJ_MOEDA=="1"
			_cMoeda	:= "REAL BRL"
		Case PPJ->PPJ_MOEDA=="2"
			_cMoeda	:= "DOLAR U$$"
		Case PPJ->PPJ_MOEDA=="3"
			_cMoeda	:= "PESO"
		EndCase

		oPrint:Say (185,383, "FREIGHT FWD"	 																				,oFont12)
		oPrint:Say (185,460, ": "+SubStr(PPJ->PPJ_AGCARG,1,17)																				,oFont12)
		oPrint:Say (197,383, "PESO (Kg)"																					,oFont12)
		oPrint:Say (197,460, ": "+SubStr(CVALTOCHAR(STPESONT()),1,17)																		,oFont12)
		oPrint:Say (209,383, "N° PALLETS"		 																				,oFont12)
		oPrint:Say (209,460, ": "+SubStr(PPJ->PPJ_PALLET,1,17)																				,oFont12)
		oPrint:Say (221,383, "MONEDA"																							,oFont12)
		oPrint:Say (221,460, ": "+_cMoeda																						,oFont12)

		//Quinto box
		oPrint:box (225,001,245,580,"-1")
		oPrint:Say (240,008, "ITEM" 			,oFont10)
		oPrint:Say (240,032, "CÓDIGO"		 	,oFont10)
		oPrint:Say (240,100, "DESCRIPCIÓN" 	,oFont10)
		oPrint:Say (240,360, "NCM" 				,oFont10)
		oPrint:Say (240,415, "CTD" 				,oFont10)
		oPrint:Say (240,460, "PRECIO UN" 			,oFont10)
		oPrint:Say (240,525, "TOTAL" 			,oFont10)

		//Sexto box
		oPrint:box (245,001,697,580,"-1")

	Else
		if Empty(cCBC)
			//Quinto box //segunda pagina pra frente
			oPrint:box (075,001,095,580,"-1")
			oPrint:Say (090,008, "ITEM" 			,oFont10)
			oPrint:Say (090,032, "CÓDIGO"		 	,oFont10)
			oPrint:Say (090,100, "DESCRIPCIÓN" 	,oFont10)
			oPrint:Say (090,360, "NCM" 				,oFont10)
			oPrint:Say (090,415, "CTD" 				,oFont10)
			oPrint:Say (090,460, "PRECIO UN" 			,oFont10)
			oPrint:Say (090,525, "TOTAL" 			,oFont10)
		endif
		//Sexto box
		oPrint:box (095,001,697,580,"-1")

	EndIf

	//Sétimo box
	oPrint:box (697,001,735,580,"-1")
	oPrint:Say (705,005, "OBSERVACIONES:" ,oFont12n)
	//oPrint:Say (720,005, SubStr(PPJ->PPJ_OBS,1,135) 		,oFont11)
	//oPrint:Say (730,005, SubStr(PPJ->PPJ_OBS,136,300) 	,oFont11)
	oPrint:Say (720,005, SubStr(PPJ->PPJ_OBS1,1,100) 		,oFont11)
	oPrint:Say (730,005, SubStr(PPJ->PPJ_OBS2,1,100) 		,oFont11)

	If MV_PAR01 = 1 //>> Chamado 007053 - Inclui no fonte a opção de impressão do dados bancários do Mexico - Everson Santana - 26.03.2018
		//Oitavo box
		oPrint:box (735,001,785,580,"-1")
		oPrint:Say (745,005, "DATOS BANCARIOS:" 			,oFont12n)
		oPrint:Say (760,005, "BANCO CITIBANK S.A." 		,oFont11)
		oPrint:Say (770,005, "DEPTO. DE CAMBIO" 			,oFont11)
		oPrint:Say (780,005, "SÃO PAULO/SP - BRASIL" 		,oFont11)

		oPrint:Say (760,200, "BENEFICIÁRIO: STECK DISTRIBUIDORA LTDA" 	,oFont11)
		oPrint:Say (770,200, "CUENTA NR. 36125649" 								,oFont11)
		oPrint:Say (780,200, "CLAVE.SWIFT: CITIBRBR" 								,oFont11)

		//Nono box
		oPrint:box (785,001,845,580,"-1")
		oPrint:Say (800,200, "STECK DISTRIBUIDORA LTDA",oFont11)
		oPrint:Say (810,220, "CNPJ: 44.415.136/0001-38",oFont11)
		oPrint:Say (820,110, "Dirección: Estrada Adilia Barbosa Neves, N° 3925 - CEP 07413-000 - Arujá/SP - Brasil" ,oFont11)

		//>> Chamado 007053 - Inclui no fonte a opção de impressão dos dados bancários do Mexico - Everson Santana - 26.03.2018
	Else
		//Oitavo box
		oPrint:box (735,001,785,580,"-1")
		oPrint:Say (745,005, "DATOS BANCARIOS:" 								,oFont12n)
		oPrint:Say (760,005, "BBVA BANCOMER" 									,oFont11)
		oPrint:Say (770,005, "BENEFICIÁRIO: STECK DE MÉXICO S.A DE C.V" 	,oFont11)
		oPrint:Say (780,005, "CUENTA NR. 0111463713" 							,oFont11)

		oPrint:Say (750,210, "SWIFT: BCMRMXMMPYM " 							,oFont11)
		oPrint:Say (760,210, "CLABE : 012180001114637137 " 					,oFont11)
		oPrint:Say (770,210, "ABA: 121000358" 									,oFont11)
		oPrint:Say (780,210, "DERECCIÓN: Calzada de Guadalupe 110, Col. Ex Hipódromo de Peralvillo CP 06250 - CDMX" ,oFont11)

		//Nono box
		oPrint:box (785,001,845,580,"-1")
		oPrint:Say (800,200, "STECK DE MÉXICO S.A DE C.V" 					,oFont11)
		oPrint:Say (810,220, "R.F.C.: SME981217GS4" 							,oFont11)
		oPrint:Say (820,050, "DIRECCIÓN: CTO CIRCUNVALACION, 149, INT. B - COL. CIUDAD SATÉLITE - NAUCALPAN DE JUAREZ - CP: 53120 - ESTADO MEXICO - MÉXICO.",oFont11)

	EndIf
	//<< Chamado 007053 - Inclui no fonte a opção de impressão do dados bancários do Mexico - Everson Santana - 26.03.2018

	Do Case
	Case PPJ->PPJ_USER=="000369"
		oPrint:Say (830,075, "Contacto: Cintya Greany - E-mail: cinthya.greany@steckgroup.com - Fone (55) 2248-7023 - www.steck.com.br"		 		,oFont11)
	Case PPJ->PPJ_USER=="000619"
		oPrint:Say (830,075, "Contacto: Jorge Soto - E-mail: jorge.soto@steckgroup.com - Fone (55) 2248-7062 - www.steck.com.br"		 		,oFont11)
	EndCase

	oPrint:Say (840,567, CVALTOCHAR(_nPag) 								,oFont11)

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ RSTFAT78 ³ Autor ³ Renato Nogueira       ³ Data ³ 20/05/15 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Rotina de impressão do pro-forma  			              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ 		                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function STPESONT()

	Local _nPesoTot	:= 0
	Local cQuery1 	:= ""
	Local cAlias1 	:= "QRYTEMP"

	cQuery1	 := " SELECT SUM(PESOTOT) PESOTOT "
	cQuery1  += " FROM ( "
	cQuery1	 += " SELECT B1_PESO*PPL_QUANT PESOTOT "
	cQuery1  += " FROM " +RetSqlName("PPL")+ " PPL "
	cQuery1  += " LEFT JOIN " +RetSqlName("SB1")+ " SB1 "
	cQuery1	 += " ON B1_COD=PPL_PRODUT "
	cQuery1	 += " WHERE PPL.D_E_L_E_T_=' ' AND SB1.D_E_L_E_T_=' ' AND PPL_NUM='"+PPJ->PPJ_NUM+"' "
	cQuery1  += " ) "

	If !Empty(Select(cAlias1))
		DbSelectArea(cAlias1)
		(cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery1),cAlias1,.T.,.T.)

	dbSelectArea(cAlias1)
	(cAlias1)->(dbGoTop())
	_nPesoTot	:= (cAlias1)->PESOTOT

Return(_nPesoTot)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ RSTFAT78 ³ Autor ³ Renato Nogueira       ³ Data ³ 20/05/15 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Rotina de impressão do pro-forma  			              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ 		                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function TOTALITENS()

	Local cQuery 		:= ""
	Local cAlias 		:= "QRYTEMP1"
	Local _nQtdItens	:= 0

	cQuery	 := " SELECT COUNT(*) TOTAL "
	cQuery  += " FROM "+RetSqlName("PPL")+" PPL "
	cQuery	 += " WHERE PPL.D_E_L_E_T_=' ' AND PPL_NUM='"+PPJ->PPJ_NUM+"' "

	If !Empty(Select(cAlias))
		DbSelectArea(cAlias)
		(cAlias)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

	dbSelectArea(cAlias)
	(cAlias)->(dbGoTop())
	_nQtdItens	:= (cAlias)->TOTAL

Return(_nQtdItens)

Static Function fCriaTexto()
	Local aTexto    := {}
	local cTexto    := ''

	cTexto := "Global Export Control Clauses for Tender, Bid or Quote Submissions" 
	AADD( aTexto, cTexto )
	cTexto := "" 
	AADD( aTexto, cTexto )
	cTexto := "This offer is subject to the approval and/or issuance of any required licenses, authorization or approvals by "
	AADD( aTexto, cTexto )
	cTexto := " any relevant government authority. If any required licenses, authorization or approval are not obtained, "
	AADD( aTexto, cTexto )
	cTexto := " whether arising from inaction by any relevant government authority or otherwise, or if any such license "
	AADD( aTexto, cTexto )
	cTexto := " authorization or approvals are denied or revoked, or if the applicable export control laws and/or regulations "
	AADD( aTexto, cTexto )
	cTexto := " would prohibit Seller from fulfilling any order, or would in Seller s judgment otherwise expose Seller to a risk "
	AADD( aTexto, cTexto )
	cTexto := "  of liability under the applicable export control laws and/or regulations if it fulfilled the offer, Seller shall be "
	AADD( aTexto, cTexto )
	cTexto := " excused from all obligation/s under this offer." 
	AADD( aTexto, cTexto )

	cTexto := "" 
	AADD( aTexto, cTexto )

	cTexto := "Global Export Control Clauses for Sales and Distributor Contacts or T&Cs" 
	AADD( aTexto, cTexto )

	cTexto := "" 
	AADD( aTexto, cTexto )
	cTexto := "The deliverables provided by Seller under this Agreement contain or may contain components and/or "
	AADD( aTexto, cTexto )
	cTexto := " technologies from the United States of America (“US”), the European Union (“EU”) and/or other nations. "
	AADD( aTexto, cTexto )
	cTexto := " Buyer acknowledges and agrees that the supply, assignment and/or usage of the products, software, "
	AADD( aTexto, cTexto )
	cTexto := " services, information, other deliverables and/or the embedded technologies (hereinafter referred to as  "
	AADD( aTexto, cTexto )
	cTexto := " “Deliverables”) under this Agreement shall fully comply with related applicable US, EU and other national and  "
	AADD( aTexto, cTexto )
	cTexto := " international export control laws and/or regulations." 
	AADD( aTexto, cTexto )

	cTexto := "" 
	AADD( aTexto, cTexto )
	cTexto := "Unless applicable export license/s has been obtained from the relevant authority and the Seller has approved, "
	AADD( aTexto, cTexto )
	cTexto := " the Deliverables shall not (i) be exported and/or re-exported to any destination and party (may include but not "
	AADD( aTexto, cTexto )
	cTexto := " limited to an individual, group and/or legal entity) restricted by the applicable export control laws and/or "
	AADD( aTexto, cTexto )
	cTexto := " regulations; or (ii) be used for those purposes and fields restricted by the applicable export control laws "
	AADD( aTexto, cTexto )
	cTexto := " and/or regulations. Buyer also agrees that the Deliverables will not be used either directly or indirectly in any "
	AADD( aTexto, cTexto )
	cTexto := " rocket systems or unmanned air vehicles; nor be used in any nuclear weapons delivery systems; and will not "
	AADD( aTexto, cTexto )
	cTexto := " be used in any design, development, production or use for any weapons which may include but not limited to "
	AADD( aTexto, cTexto )
	cTexto := " chemical, biological or nuclear weapons. " 
	AADD( aTexto, cTexto )

	cTexto := "" 
	AADD( aTexto, cTexto )
	cTexto := "If any necessary or advisable licenses, authorizations or approvals are not obtained, whether arising from "
	AADD( aTexto, cTexto )
	cTexto := " inaction by any relevant government authority or otherwise, or if any such licenses, authorizations or "
	AADD( aTexto, cTexto )
	cTexto := " approvals are denied or revoked, or if the applicable export control laws and/or regulations would prohibit "
	AADD( aTexto, cTexto )
	cTexto := " Seller from fulfilling any order, or would in Seller s judgment otherwise expose Seller to a risk of liability under "
	AADD( aTexto, cTexto )
	cTexto := " the applicable export control laws and/or regulations if it fulfilled the order, Seller shall be excused from all "
	AADD( aTexto, cTexto )
	cTexto := " obligations under such order and/or this Agreement. " 
	AADD( aTexto, cTexto )

	cTexto := "" 
	AADD( aTexto, cTexto )

	cTexto := "Global Export Control Clause for Purchasing and Supplier Contract & T&Cs" 
	AADD( aTexto, cTexto )

	cTexto := "" 
	AADD( aTexto, cTexto )
	cTexto := "The Supplier acknowledges that it is fully aware of, and knowledgeable about, the export and re-export "
	AADD( aTexto, cTexto )
	cTexto := " controls regulations, ordinances and laws in the jurisdiction from which the Products are exported or the "
	AADD( aTexto, cTexto )
	cTexto := " Services are provided and agrees to obtain all necessary export and re-export permits or licenses at the "
	AADD( aTexto, cTexto )
	cTexto := " Supplier s expense to ensure that the Purchaser enjoys the full benefit under the relevant Purchase Order "
	AADD( aTexto, cTexto )
	cTexto := " and these T&C. Further, the Supplier shall supply the Purchaser with the information regarding any "
	AADD( aTexto, cTexto )
	cTexto := " applicable export controls rules and required permits or licenses for the Products or Works to be shipped,  "
	AADD( aTexto, cTexto )
	cTexto := " in writing within three (3) working days from the receipt of Purchase Order. The Supplier shall also notify  "
	AADD( aTexto, cTexto )
	cTexto := " in writing of any changes to such export and re-export controls regulations and/or permit or licensing "
	AADD( aTexto, cTexto )
	cTexto := " the Purchaser requirements which may affect the Purchaser s benefits under the Agreement. The Supplier  "
	AADD( aTexto, cTexto )
	cTexto := " comply with all export and re-export controls regulations or rules in relation to the delivery of the Products, "
	AADD( aTexto, cTexto )
	cTexto := " undertakes to the Works and the provision of the Services and shall indemnify Purchaser against all liability,  "
	AADD( aTexto, cTexto )
	cTexto := " losses, damages, and expenses (including reasonable attorney s fees) resulting from the Supplier s   "
	AADD( aTexto, cTexto )
	cTexto := " non-compliance or violations of such export and re-export controls regulations." 
	AADD( aTexto, cTexto )

Return aTexto
