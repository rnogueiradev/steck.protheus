#Include "Protheus.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � STFSPC30     �Autor  �Giovani Zago     � Data �  06/12/12  ���
�������������������������������������������������������������������������͹��
���Desc.     �  Menu Especifico  Impressao de Etiqueta					  ���
���          �  								                          ���
�������������������������������������������������������������������������͹��
���Uso       � Steck		                                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
*---------------------------------------------------*
User Function STFSPC30()  // chamada com as 3 opcoes
	*---------------------------------------------------*
	u_xACDI011()
Return

User Function STFSPC31()  // chamada por produto
	u_xACDI011()
Return

User Function STFSPC32()  // chamada por OP
	u_xACDI011()
Return

User Function STFSPC33()  // chamada por Ordem de separacao
	u_xACDI011()
Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �STFSPC35  �Autor  �Microsiga           � Data �  03/09/10   ���
�������������������������������������������������������������������������͹��
���Desc.     � Imagem ZPL da etiqueta de produto acabado Grande           ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function STFSPC35(nCopias,nQtde,cLote,cColetivo,cPaisImp,cEmpresa,cEan14,_nFrac)
	Local cMsg := ""//VldProduto()
	//If ! Empty(cMsg)
	//CBAlert("Existem campos obrigatorios em branco!")
	//CBAlert(cMsg)
	//Return
	//EndIf

	If ! cPaisImp=="Mexico"

		If Alltrim(SB1->B1_GRUPO) $ SuperGetMv("ST_FAT0002",.F.,'105#125') .And. ISINCALLSTACK("U_STFSPC31")

			ImgStela(nCopias,nQtde,cLote,cColetivo,cEmpresa,cEan14,_nFrac)

		Else

			ImgGrArg(nCopias,nQtde,cLote,cColetivo,cEmpresa,cEan14,_nFrac)

		EndIf

	Else
		ImgGrMex(nCopias,nQtde,cLote,cColetivo,cEmpresa)
	EndIf
Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �STFSPC36  �Autor  �Microsiga           � Data �  03/09/10   ���
�������������������������������������������������������������������������͹��
���Desc.     � Imagem ZPL da etiqueta de produto acabado pequena          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function STFSPC36(nCopias,nQtde,cLote,cColetivo,cPaisImp)
	If ! cPaisImp=="Mexico"
		ImgPqArg(nCopias,nQtde,cLote,cColetivo)
	Else
		ImgPqMex(nCopias,nQtde,cLote,cColetivo)
	EndIf
Return

Static Function ImgGrArg(nCopias,nQtde,cLote,cColetivo,cEmpresa,cEan14,_nFrac)
	Local cQtd		:= Alltrim(str(nQtde))
	Local cBarCod	:= AllTrim(SB1->B1_CODBAR)
	Local cBarCod14	:= ""
	Local cCodPro  := AllTrim(SB1->B1_COD)
	Local cCodBar	:= ""//U_STBarra(cCodPro,cLote,nQtde,cEmpresa)
	Local cColetivo	:= "N�o"
	Local cPaisImp	:= "Padrao"
	Local cTamanho	:= "Grande"
	Local cParte1	:= Alltrim(SB1->B1_DESC)
	Local cParte2	:= AllTrim(SB1->B1_XDESESP)
	Local nLinH	:= 9
	Local nLinV := 0

	Local ctamG:= "028,025"
	Local ctamM:= "024,020"
	Local ctamP:= "021,018"
	Local ctamx:= "018,015"

	Local cNomeImp		:=	"STECK ELECTRIC S.A."
	Local cEndeImp		:=	"BELISARIO HUEYO165"
	Local cEstaImp		:=	"AVELLANEDA - PCIA BS AS - ARGENTINA"
	Local cEstaImp2		:=  ""
	Local aCompo 		:= {"mat.plastico","ligas/aleaciones met�licas","mat.plastico e/y ligas/aleaciones metalicas"}
	Local aEmp			:= BuscaEmp(cEmpresa)
	Local cM0_NOME 	    := aEmp[1]
	Local cM0_CGC		:= aEmp[3]
	Local cComposicao   := ""
	Local cTensao		:= Alltrim(SB1->B1_XTENSAO)
	Local cCorrente	    := Alltrim(SB1->B1_XCORREN)
	Local aCombo		:= {}
	Local aParamBox		:= {}
	Local aRet			:= {}
	Local _cOrigem	:= ""
	Local _nAt			:= 0

	If SubStr(cM0_CGC,1,8)=="05890658" //SP Sempre Guararema
		cM0_CGC := "05890658000563"
	EndIf

	If !Empty(_nFrac)
		cCodBar	:= U_STBarra(cCodPro,cLote,Val(_nFrac),cEmpresa)
	Else
		cCodBar	:= U_STBarra(cCodPro,cLote,nQtde,cEmpresa)
	EndIF

	_cOrigem	:= GETORIGEM()

	DbSelectArea("SX5")
	SX5->(DbSetOrder(1))
	SX5->(DbGoTop())
	SX5->(Dbseek(xFilial("SX5")+"Z1"+SB1->B1_XCOMPOS))

	If Empty(cColetivo)
		cColetivo	:= "Nao"
	EndIf
	If ! Empty(SB1->B1_XCOMPOS)
		//cComposicao := aCompo[Val(SB1->B1_XCOMPOS)]
		cComposicao := SX5->X5_DESCRI
	Else
		cComposicao := " "
	EndIf

	MSCBInfoEti("Produto","")
	MSCBloadGrf("steck01.GRF")
	MSCBloadGrf("tuv.GRF")
	MSCBloadGrf("seg.GRF")
	MSCBloadGrf("CRC.GRF")
	MSCBloadGrf("IMC7.GRF")
	MSCBloadGrf("CEN.GRF")
	MSCBloadGrf("BV.GRF")
	MSCBloadGrf("BV2.GRF")

	//MSCBBEGIN(nCopias,6)
	If IsTelNet()
		MSCBBEGIN(1,6)
	Else
		MSCBBEGIN(nCopias,6) //Chamado 002976 - Ajuste na quantidade de copias que estava incorreta - 03/11/2015
	EndIf
	If cColetivo == "Sim"	// Logo lateral sobre Negrito
		MSCBBOX(03,03,22,62,80)
	Endif
	MSCBSAY(nLinH+15,nLinV+03,cParte1																		,"N","0",ctamG)
	MSCBSAY(nLinH+15,nLinV+07,cParte2																		,"N","0",ctamG)
	MSCBSAY(nLinH+15,nLinV+11,"REF: "	+ StrTran(Alltrim(SB1->B1_COD),"_"," ")		  				,"N","0",ctamG)
	//>>Argentina
	_nAt := at("_",Alltrim(SB1->B1_COD))

	If _nAt > 0
		If _nAt = 3
			MSCBBOX(nLinH+25.5,nLinV+13.8,nLinH+27,nLinV+13.8)
		Else
			MSCBBOX(nLinH+23.5,nLinV+13.8,nLinH+25,nLinV+13.8)
		EndIf

	EndIf
	//<<Argentina
	//MSCBSAY(nLinH+15,nLinV+11,"REF: "	+ Alltrim(SB1->B1_COD)		  								,"N","0",ctamG)

	//Codigos: Produto e Lote
	//MSCBSAY(nLinH+60,nLinV+29,SB1->B1_COD									,"N","0",ctamM)
	MSCBSAY(nLinH+45,nLinV+11,cLote											,"N","0",ctamM)
	//Texto Fixo

	//Quantidade

	MSCBSAY(nLinH+75,nLinV+10,"Conteudo/Contenido: "						,"N","0",ctamP)
	MSCBSAY(nLinH+75,nLinV+13,"Peca(s)/Pieza(s)"							,"N","0",ctamP)
	If !Empty(_nFrac)
		MSCBSAY(nLinH+85,nLinV+16,Alltrim(_nFrac)						,"N","0",ctamG)
	Else
		MSCBSAY(nLinH+85,nLinV+16,cQtd										,"N","0",ctamG)
	EndIf

	If ! Empty(SB1->B1_XCODEXP)
		MSCBSAY(nLinH+62,nLinV+11,"COD: "	+ Alltrim(SB1->B1_XCODEXP)					  		,"N","0",ctamG)
	EndIf
	MSCBSAY(nLinH+15,nLinV+16,"Composicao/Composicion: "+ cComposicao							,"N","0",ctamP)
	MSCBSAY(nLinH+15,nLinV+19,"Tensao/Tension Max.: "	+ cTensao								,"N","0",ctamP)
	MSCBSAY(nLinH+45,nLinV+19,"Corrente/Intensidad: "	+ Alltrim(cCorrente) +"     "+ Alltrim(SB1->B1_XPROTEC)	,"N","0",ctamP) // Ticket 20200420001760
	MSCBSAY(nLinH+15,nLinV+22,"Produto nao perecivel - Producto no Perecedero"					,"N","0",ctamP)
	//If SB1->B1_CLAPROD<>"I"
	//MSCBSAY(nLinH+15,nLinV+25,"Industria Brasileira - Industria Brasilena"					,"N","0",ctamP)
	MSCBSAY(nLinH+15,nLinV+25	,"Fabricado/Hecho "+_cOrigem,"N","0",ctamP)
	//EndIf
	MSCBSAY(nLinH+15,nLinV+28,"www.steck.com.br"												,"N","0",ctamP) //"0"

	//Codigo EAN
	If Empty(_nFrac)
		If Alltrim(cEan14)=="Sim"
			DbSelectArea("SB5")
			SB5->(DbSetOrder(1))
			SB5->(DbGoTop())
			If SB5->(DbSeek(xFilial("SB5")+SB1->B1_COD))

				Do Case
					Case AllTrim(cQtd) == CVALTOCHAR(SB5->B5_EAN141)
					cBarCod14	:= "1"
					Case AllTrim(cQtd) == CVALTOCHAR(SB5->B5_EAN142)
					cBarCod14	:= "2"
					Case AllTrim(cQtd) == CVALTOCHAR(SB5->B5_EAN143)
					cBarCod14	:= "3"
					Case AllTrim(cQtd) == CVALTOCHAR(SB5->B5_EAN144)
					cBarCod14	:= "4"
					Case AllTrim(cQtd) == CVALTOCHAR(SB5->B5_EAN145)
					cBarCod14	:= "5"
					Case AllTrim(cQtd) == CVALTOCHAR(SB5->B5_EAN146)
					cBarCod14	:= "6"
					Case AllTrim(cQtd) == CVALTOCHAR(SB5->B5_EAN147)
					cBarCod14	:= "7"
					Case AllTrim(cQtd) == CVALTOCHAR(SB5->B5_EAN148)
					cBarCod14	:= "8"
				EndCase

				cBarCod		:= SubStr(cBarCod,1,12)
				cBarCod14	:= Alltrim(cBarCod14)+Alltrim(cBarCod)
				cBarCod14	:= Alltrim(cBarCod14)+U_STEAN14F(Alltrim(cBarCod14))

				MSCBSAYBAR(nLinH+18,nLinV+32,cBarCod14,"N","MB01",13,.F.,.T.,.F.,,2,2,.F.)
			EndIf
		Else
			MSCBSAYBAR(nLinH+18,nLinV+32,cBarCod,"N","MB04",13,.F.,.T.,.F.,,2,2,.F.)
		EndIf
	EndIf

	// Logo Lateral 
	// Valdemir Rabelo 05/01/2022 - Ticket: 20220104000135 - Adicionar o logo	
	//IF SB1->B1_XCODSE != "S"			 // Valdemir Rabelo 25/11/2020 - Ticket: 20201116010613
	   MSCBGrafic(07,03,"steck01",.T.)   //MSCBGrafic(07,09,"steck01",.T.)
	//Endif 

	If SB1->B1_XGRFBV $ " /2" .And. SB1->B1_XGRFCEN $ " /2" .And. SB1->B1_XGRFIMC=="1" .And. SB1->B1_XGRFUC $ " /2"
		MSCBGrafic(nLinH+45,nLinV+30,"IMC7")
	EndIf
	If SB1->B1_XGRFBV=="1" .And. SB1->B1_XGRFCEN $ " /2" .And. SB1->B1_XGRFIMC $ " /2" .And. SB1->B1_XGRFUC $ " /2"
		MSCBGrafic(nLinH+45,nLinV+35,"BV2")
	EndIf
	If SB1->B1_XGRFBV $ " /2" .And. SB1->B1_XGRFCEN $ " /2" .And. SB1->B1_XGRFIMC $ " /2" .And. SB1->B1_XGRFUC=="1"
		MSCBGrafic(nLinH+45,nLinV+35,"seg",.T.) //coluna, altura, imagem
		MSCBGrafic(nLinH+45,nLinV+38,"tuv",.T.) //coluna, altura, imagem
	EndIf

	_cClaAm	:= STCLAAM(SB1->B1_COD)
	_cClaSp	:= STCLASP(SB1->B1_COD)

	If AllTrim(SB1->B1_COD) $ "SMEBT2F#SMEBT2M"
		MSCBSAY(nLinH+10,nLinV+22,"CNPJ " + Transform("05890658000210", "@R 99.999.999/9999-99")	,"B","0",ctamP,.t.) // 30
	Else
		If cEmpresa = "01" .And. Alltrim(SB1->B1_CLAPROD)=="C" .And. Alltrim(_cClaAm)=="F"
			MSCBSAY(nLinH+10,nLinV+22,"CNPJ " + Transform("06048486000114", "@R 99.999.999/9999-99")	,"B","0",ctamP,.t.) // 30
		ElseIf cEmpresa = "03" .And. Alltrim(SB1->B1_CLAPROD)=="F" .And. Alltrim(_cClaSp)=="C"
			MSCBSAY(nLinH+10,nLinV+22,"CNPJ " + Transform("06048486000114", "@R 99.999.999/9999-99")	,"B","0",ctamP,.t.) // 30
		ElseIf SB1->B1_CLAPROD=="I"
			MSCBSAY(nLinH+10,nLinV+22,"CNPJ " + Transform("05890658000210", "@R 99.999.999/9999-99")	,"B","0",ctamP,.t.) // 30
		Else
			MSCBSAY(nLinH+10,nLinV+22,"CNPJ " + Transform("05890658000563", "@R 99.999.999/9999-99")	,"B","0",ctamP,.t.) // 30     Valdemir Rabelo 22/12/2020 - Ticket: 20201221012646
		EndIf
	EndIf

	_lImprime := .T.

	If SB1->B1_CLAPROD $ "F#C"
		If AllTrim(SB1->B1_COD) $ "SMEBT2F#SMEBT2M" .Or. AllTrim(SB1->B1_GRUPO) $ "129"
			_lImprime := .F.
			MSCBSAY(nLinH+62,nLinV+22,"DISTRIBUIDO NO BRASIL POR:	"			,"N","0",ctamx)
			// Ticket: 20210414006027
			//MSCBSAY(nLinH+62,nLinV+26,"AV. CONDESSA ELISABETH ROBIANO 320"		,"N","0",ctamx)
			//MSCBSAY(nLinH+62,nLinV+28,"BOX H - CEP 03074-000 - SAO PAULO"		,"N","0",ctamx)

			MSCBSAY(nLinH+62,nLinV+26,"ESTR. ADILIA BARBOSA NEVES, 3925"		,"N","0",ctamx)
			MSCBSAY(nLinH+62,nLinV+28,"BAIRRO PORT�O - CEP 07413-000 - ARUJA"		,"N","0",ctamx)
		Else
			IF SB1->B1_XCODSE != "S"			 // Valdemir Rabelo 26/11/2020 - Ticket: 20201116010613
				MSCBSAY(nLinH+62,nLinV+22,"FABRICADO NO BRASIL POR:	"			,"N","0",ctamx)
			Endif 
		EndIf
		If cEmpresa = "01" .And. Alltrim(SB1->B1_CLAPROD)=="C" .And. Alltrim(_cClaAm)=="F" .And. _lImprime
			MSCBSAY(nLinH+62,nLinV+24,"STECK DA AMAZONIA IND. ELET. LTDA"	,"N","0",ctamx)
			MSCBSAY(nLinH+62,nLinV+26,"RUA BAMBUZINHO S/N"	,"N","0",ctamx)
			MSCBSAY(nLinH+62,nLinV+28,"CEP 69075-846 - DIST IND II"	,"N","0",ctamx)
			MSCBSAY(nLinH+62,nLinV+30,"MANAUS - AM"	,"N","0",ctamx)
		ElseIf cEmpresa = "03" .And. Alltrim(SB1->B1_CLAPROD)=="F" .And. Alltrim(_cClaSp)=="C" .And. _lImprime
			MSCBSAY(nLinH+62,nLinV+24,"STECK DA AMAZONIA IND. ELET. LTDA"	,"N","0",ctamx)
			MSCBSAY(nLinH+62,nLinV+26,"RUA BAMBUZINHO S/N"	,"N","0",ctamx)
			MSCBSAY(nLinH+62,nLinV+28,"CEP 69075-846 - DIST IND II"	,"N","0",ctamx)
			MSCBSAY(nLinH+62,nLinV+30,"MANAUS - AM"	,"N","0",ctamx)
		Else
			If _lImprime
				IF SB1->B1_XCODSE != "S"			 // Valdemir Rabelo 26/11/2020 - Ticket: 20201116010613
					MSCBSAY(nLinH+62,nLinV+24,"STECK INDUSTRIA ELETRICA LTDA"		,"N","0",ctamx)
					MSCBSAY(nLinH+62,nLinV+26,"EST. MUNICIPAL NORIKO HAMADA, 180"	,"N","0",ctamx)   // Valdemir Rabelo - Ticket: 20201221012646 22/12/2020
					MSCBSAY(nLinH+62,nLinV+28,"CEP 08900-000 - GUARAREMA - SP"	,"N","0",ctamx)
				Endif            
			EndIf
		EndIf
	ElseIf SB1->B1_CLAPROD == "I"
		MSCBSAY(nLinH+62,nLinV+22,"IMPORTADO E DISTRIBUIDO POR"				,"N","0",ctamx)
		MSCBSAY(nLinH+62,nLinV+24,"STECK INDUSTRIA ELETRICA LTDA"			,"N","0",ctamx)
		
		// Ticket: 20210414006027
		//MSCBSAY(nLinH+62,nLinV+26,"AV. CONDESSA ELISABETH ROBIANO 320"		,"N","0",ctamx)
		//MSCBSAY(nLinH+62,nLinV+28,"BOX H - CEP 03074-000 - SAO PAULO"		,"N","0",ctamx)
		//MSCBSAY(nLinH+62,nLinV+30,"BRASIL"		,"N","0",ctamx)

		MSCBSAY(nLinH+62,nLinV+26,"ESTR. ADILIA BARBOSA NEVES, 3925",	"N","0",ctamx)
		MSCBSAY(nLinH+62,nLinV+28,"BAIRRO PORT�O - CEP 07413-000",		"N","0",ctamx)
		MSCBSAY(nLinH+62,nLinV+30,"ARUJ� - SP - BRASIL",				"N","0",ctamx)

	EndIf

	If SB1->B1_CLAPROD <> "I"
		IF SB1->B1_XCODSE != "S"			 // Valdemir Rabelo 26/11/2020 - Ticket: 20201116010613
			MSCBSAY(nLinH+62,nLinV+33,"IMPORTADO E DISTRIBUIDO POR"				,"N","0",ctamx)
		Endif 
	EndIf

	IF SB1->B1_XCODSE != "S"			 // Valdemir Rabelo 26/11/2020 - Ticket: 20201116010613
		MSCBSAY(nLinH+62,nLinV+35,"STECK ELECTRIC S.A."						,"N","0",ctamx)
		MSCBSAY(nLinH+62,nLinV+37,"BELISARIO HUEYO, 165 - AVELLANEDA"  					,"N","0",ctamx)
		MSCBSAY(nLinH+62,nLinV+39,"BUENOS AIRES - ARGENTINA"				,"N","0",ctamx)
	Endif 

	IF SB1->B1_XCODSE != "S"			 // Valdemir Rabelo 26/11/2020 - Ticket: 20201116010613
		// Zeca Ticket: 20210209002184
		MSCBSAY(nLinH+62,nLinV+42,"STECK DE M�XICO S.A. DE C.V.",		"N","0",ctamx)
		MSCBSAY(nLinH+62,nLinV+44,"AV. CTO CIRCUNVALACION 149, INT. B ","N","0",ctamx)
		MSCBSAY(nLinH+62,nLinV+46,"COL. CIUDAD SATELITE - NAUCALPAN",	"N","0",ctamx)
		MSCBSAY(nLinH+62,nLinV+48,"DE JUAREZ - EDO. MEXICO - MEXICO",	"N","0",ctamx)
	Endif

	//<< 20200420001748

	//Codigo Code 128
	//	ConOut("Coletor - cCodBar -> "+cCodBar)
	cCodBar	:= SubStr(Alltrim(cCodBar),1,Len(Alltrim(cCodBar))-3)
	MSCBSAYBAR(nLinH+02,nLinV+50.5,cCodBar,"N","MB07",9.5,.F.,.t.,.F.,"C",2.3,2,.F.)   //15
	//MSCBSAYBAR(nLinH+19,nLinV+15,cCodBar,"N","MB07",9.5,.F.,.t.,.F.,"C",2,2,.F.)

	MSCBEND()
Return

Static Function ImgGrMex(nCopias,nQtde,cLote,cColetivo,cEmpresa)
	Local cQtd			:= Alltrim(str(nQtde))
	Local cCodPro  	:= AllTrim(SB1->B1_COD)
	Local	cCodBar		:= U_STBarra(cCodPro,cLote,nQtde)
	Local aEmp			:= BuscaEmp(cEmpresa)
	Local cM0_NOME 	:= aEmp[1]
	Local cM0_ENDCOB	:= aEmp[2]

	Local nLinH	:= 9
	Local nLinV := 0

	// Fontes:	"A","B","C","D","E","F","G","H","0"
	Local ctamG:= "028,025"
	Local ctamM:= "024,020"
	Local ctamP:= "021,018"
	//Local ctamx:= "018,015"
	Local aCompo 	:= {"mat.plastico","aleaciones met�licas","mat.plastico y aleaciones metalicas"}
	Local cComposicao := ""

	If Empty(cColetivo)
		cColetivo	:= "Nao"
	EndIf

	DbSelectArea("SX5")
	SX5->(DbSetOrder(1))
	SX5->(DbGoTop())
	SX5->(Dbseek(xFilial("SX5")+"Z1"+SB1->B1_XCOMPOS))

	If ! Empty(SB1->B1_XCOMPOS)
		//cComposicao := Upper(aCompo[Val(SB1->B1_XCOMPOS)])
		cComposicao := SX5->X5_DESCRI
	EndIf

	MSCBInfoEti("Produto","")

	MSCBloadGrf("steck01.GRF")

	MSCBBEGIN(nCopias,6)

	If cColetivo == "Sim"	// Logo lateral sobre Negrito
		MSCBBOX(03,03,22,62,80)
	Endif
	// Logo Topo
	MSCBGrafic(03,03,"steck01",.T.)

	MSCBSAY(nLinH+15,nLinV+05,"REF: "	+ StrTran(Alltrim(SB1->B1_COD),"_","-")			,"N","0",ctamG)
	MSCBSAY(nLinH+15,nLinV+09,Alltrim(SB1->B1_DESC)										,"N","0",ctamG)

	MSCBSAY(nLinH+15,nLinV+14,"Producto no Perecedero"										,"N","0",ctamP)
	MSCBSAY(nLinH+15,nLinV+17,"VER INSTRUCTIVO ANEXO Y"									,"N","0",ctamP)
	MSCBSAY(nLinH+15,nLinV+20,"GARANTIA DEL PRODUCTO"										,"N","0",ctamP)
	MSCBSAY(nLinH+15,nLinV+23,"Composicion: " 	+ cComposicao								,"N","0",ctamP)

	MSCBSAY(nLinH+60,nLinV+17,cLote																,"N","0",ctamG)

	MSCBSAYBAR(nLinH+05,nLinV+26,cCodBar,"N","MB07",14,.F.,.t.,.F.,"C",2,2,.F.)

	//Texto Fixo
	MSCBSAY(nLinH+15,nLinV+47,"EXPORTADO POR"									,"N","0"		,ctamG)
	MSCBSAY(nLinH+15,nLinV+51,cM0_NOME											,"N","0"		,ctamM)
	MSCBSAY(nLinH+15,nLinV+54,cM0_ENDCOB										,"N","0"		,ctamM)

	//Quantidade
	MSCBSAY(nLinH+15,nLinV+60,"Contenido: "+cQtd	+" Pieza(s)"			,"N","0"		,ctamG)

	MSCBSAY(nLinH+62,nLinV+47,"IMPORTADO POR"									,"N","0"		,ctamG)
	MSCBSAY(nLinH+62,nLinV+51,"STECK DE MEXICO S.A. DE CV"				,"N","0"		,ctamM)
	MSCBSAY(nLinH+62,nLinV+54,"Calzada Misterios 224 - 201"				,"N","0"		,ctamM)
	MSCBSAY(nLinH+62,nLinV+57,"Col. Vallejo C.P. 07870 Mexico D.F."	,"N","0"		,ctamM)
	MSCBSAY(nLinH+62,nLinV+60,"FABRICADO EN BRASIL"							,"N","0"		,ctamG)

	MSCBEND()
Return

Static Function ImgPqArg(nCopias,nQtde,cLote,cColetivo)

	Local	_cCnpj	:= ""

	MSCBInfoEti("Produto Pq","")
	MSCBLoadGrf("steckp.GRF")
	MSCBloadGrf("tuv.GRF")
	MSCBloadGrf("seg.GRF")
	MSCBloadGrf("CRC.GRF")
	MSCBloadGrf("IMC7.GRF")
	MSCBloadGrf("CEN.GRF")
	MSCBloadGrf("BV.GRF")
	MSCBloadGrf("BV2.GRF")
	MSCBloadGrf("BV2P.GRF")

	If nCopias > 1
		MSCBBEGIN(Int(nCopias/2),6)
		//ImgPqArg2(0,cLote)
		//ImgPqArg2(51,cLote)
		ImgPqArg2(3,cLote)
		ImgPqArg2(54,cLote)
		MSCBEND()
	EndIf
	If Mod(nCopias,2) == 1 .or. nCopias ==1
		MSCBBEGIN(1,6)
		ImgPqArg2(0,cLote)
		MSCBEND()
	EndIf

Return

Static Function ImgPqArg2(nLinH,cLote)
	Local cBarCod		:= AllTrim(SB1->B1_CODBAR)
	Local cDesc1		:= SubStr(Alltrim(SB1->B1_DESC),1		,40)
	Local cDesc2		:= Left(AllTrim(SB1->B1_XDESESP)	,40)
	Local nLinV 		:= 0
	Local ctamv			:= "016,014"
	Local ctamx			:= "018,016"
	Local ctamY			:= "012,010"
	Local cComposicao := ""
	Local cCompoEspa 	:= ""
	Local aCompo 		:= {"MAT.PLASTICO","LIGAS METALICAS","MAT.PLASTICO E LIGAS METALICAS"}
	Local aCompo2 		:= {"MAT.PLASTICO","LIGAS ALEACIONES","MAT.PLASTICO Y ALEACIONES METALICAS"}
	Local lImprim		:= .F.
	Local _cClaAm		:= ""
	Local _cOrigem	:= ""

	_cOrigem	:= GETORIGEM()

	nLinV	:= 1	//Solicita��o jonas.santos em 22/07/2014

	DbSelectArea("SX5")
	SX5->(DbSetOrder(1))
	SX5->(DbGoTop())
	SX5->(Dbseek(xFilial("SX5")+"Z1"+SB1->B1_XCOMPOS))

	//cComposicao := Iif(!Empty(SB1->B1_XCOMPOS),aCompo[Val(SB1->B1_XCOMPOS)],"")
	cComposicao := Iif(!Empty(SB1->B1_XCOMPOS),SX5->X5_DESCRI,"")
	cCompoEspa	:= Iif(!Empty(SB1->B1_XCOMPOS),SX5->X5_DESCRI,"")

	_cClaAm	:= STCLAAM(SB1->B1_COD)

	MSCBLineV(nLinH+06,nLinV+00,nLinV+40,3)
	MSCBGrafic(nLinH+01,nLinV+02,"steckp",.T.)
	
	If SB1->B1_XGRFBV $ " /2" .And. SB1->B1_XGRFCEN $" /2" .And. SB1->B1_XGRFIMC=="1" .And. SB1->B1_XGRFUC $ " /2"
		MSCBGrafic(nLinH+00,nLinV+21,"IMC7")
	EndIf
	If SB1->B1_XGRFBV=="1" .And. SB1->B1_XGRFCEN $ " /2" .And. SB1->B1_XGRFIMC $ " /2" .And. SB1->B1_XGRFUC $ " /2"
		MSCBGrafic(nLinH+00,nLinV+26,"BV2P")
	EndIf
	If SB1->B1_XGRFBV $ " /2" .And. SB1->B1_XGRFCEN $ " /2" .And. SB1->B1_XGRFIMC $ " /2" .And. SB1->B1_XGRFUC=="1"
		MSCBGrafic(nLinH+00,nLinV+26,"CRC")
	EndIf

	If AllTrim(SB1->B1_COD) $ "SMEBT2F#SMEBT2M"
		_cCnpj	:= "05890658000210"
	Else
		If cEmpAnt = "01" .And. Alltrim(SB1->B1_CLAPROD)=="C" .And. Alltrim(_cClaAm)=="F" //Fabrica em Manaus
			_cCnpj	:= "06048486000114"
		ElseIf cEmpAnt = "03" .And. Alltrim(_cClaAm)=="F" //Fabrica em Manaus
			_cCnpj	:= "06048486000114"
		ElseIf SB1->B1_CLAPROD=="I"
			_cCnpj	:= "05890658000210"
		Else
			_cCnpj	:= "05890658000563"    				// Valdemir Rabelo 22/12/2020 - Ticket: 20201221012646
		EndIf
	EndIf
	_cCnpj	:= Transform(_cCnpj, "@R 99.999.999/9999-99")

	MSCBSAY(nLinH+07,nLinV+00		,cDesc1															,"N","0",ctamv)
	MSCBSAY(nLinH+07,nLinV+02		,SubStr(Alltrim(SB1->B1_DESC),41		,80)+"     "+Alltrim(SB1->B1_XPROTEC),"N","0",ctamv)
	MSCBSAY(nLinH+07,nLinV+04		,cDesc2															,"N","0",ctamv)
	MSCBSAY(nLinH+07,nLinV+06		,"REF: "	+ StrTran(Alltrim(SB1->B1_COD),"_"," ")			,"N","0",ctamx)

	//>>Argentina
	_nAt := at("_",Alltrim(SB1->B1_COD))

	If _nAt > 0
		If _nAt = 3
			MSCBBOX(nLinH+13.5,nLinV+7.3,nLinH+14.5,nLinV+7.3)
		Else
			MSCBBOX(nLinH+12.5,nLinV+7.3,nLinH+13.5,nLinV+7.3)
		EndIf

	EndIf
	//<<Argentina

	//MSCBSAY(nLinH+07,nLinV+06		,"REF: "	+ StrTran(Alltrim(SB1->B1_COD),"_","-")			,"N","0",ctamx)
	MSCBSAY(nLinH+30,nLinV+06		,cLote			,"N","0",ctamx)

	MSCBSAY(nLinH+07,nLinV+08.0	,"Composicao/Composicion: "+AllTrim(SX5->X5_DESCRI)	,"N","0","013,011") //OK
	MSCBSAY(nLinH+07,nLinV+09.5	,"Produto nao perecivel / Producto no perecedero","N","0","013,011") //OK
	MSCBSAY(nLinH+07,nLinV+11.0	,"CNPJ: "+_cCnpj+" - Fabricado/Hecho "+_cOrigem,"N","0","013,011") //OK

	//Chamado 003556
	If SB1->B1_CLAPROD="I" .Or. AllTrim(SB1->B1_GRUPO) $ "129"

		If AllTrim(SB1->B1_COD) $ "SMEBT2F#SMEBT2M" .Or. AllTrim(SB1->B1_GRUPO) $ "129"
			MSCBSAY(nLinH+07,nLinV+13.0	,"Distrib no Brasil por"	,"N","0",ctamY) //OK
		Else
			MSCBSAY(nLinH+07,nLinV+13.0	,"Importado e distrib por"	,"N","0",ctamY) //OK
		EndIf

		MSCBSAY(nLinH+07,nLinV+14.5	,"Steck Ind Eletrica Ltda"	,"N","0",ctamY) //OK
		// Ticket: 20210414006027
/*
		MSCBSAY(nLinH+07,nLinV+16.0	,"Av Cond E Robiano 320"	,"N","0",ctamY) //OK
		MSCBSAY(nLinH+07,nLinV+17.5	,"Box H CEP 03074-000"	,"N","0",ctamY) //OK
		MSCBSAY(nLinH+07,nLinV+19.0	,"Sao Paulo - SP"	,"N","0",ctamY) //OK
*/
		MSCBSAY(nLinH+07,nLinV+16.0	,"Estr Adilia B Neves 3925"	,"N","0",ctamY) //OK
		MSCBSAY(nLinH+07,nLinV+17.5	,"B Port�o CEP 07413000"	,"N","0",ctamY) //OK
		MSCBSAY(nLinH+07,nLinV+19.0	,"Aruja - SP - Brasil"	,"N","0",ctamY) //OK

	ElseIf STCLASP(SB1->B1_COD)=="F"

		If AllTrim(SB1->B1_COD) $ "SMEBT2F#SMEBT2M" .Or. AllTrim(SB1->B1_GRUPO) $ "129"
			MSCBSAY(nLinH+07,nLinV+13.0	,"Distrib no Brasil por"	,"N","0",ctamY) //OK
		Else
			MSCBSAY(nLinH+07,nLinV+13.0	,"Fabricado no Brasil por"	,"N","0",ctamY) //OK
		EndIf

		MSCBSAY(nLinH+07,nLinV+14.5	,"Steck Ind Eletrica Ltda"	,"N","0",ctamY) //OK
		MSCBSAY(nLinH+07,nLinV+16.0	,"ESM Noriko Hamada 180"	,"N","0",ctamY) //OK     - Valdemir 22/12/2020 - Ticket: 20201221012646
		MSCBSAY(nLinH+07,nLinV+17.5	,"CEP 08900-000"	,"N","0",ctamY) //OK
		MSCBSAY(nLinH+07,nLinV+19.0	,"Guararema - SP"	,"N","0",ctamY) //OK

	ElseIf STCLAAM(SB1->B1_COD)=="F" .And. STCLASP(SB1->B1_COD)$"C#I"

		If AllTrim(SB1->B1_COD) $ "SMEBT2F#SMEBT2M" .Or. AllTrim(SB1->B1_GRUPO) $ "129"
			MSCBSAY(nLinH+07,nLinV+13.0	,"Distrib no Brasil por"	,"N","0",ctamY) //OK
		Else
			MSCBSAY(nLinH+07,nLinV+13.0	,"Fabricado no Brasil por"	,"N","0",ctamY) //OK
		EndIf

		MSCBSAY(nLinH+07,nLinV+14.5	,"Steck Am Ind Elet Ltda"	,"N","0",ctamY) //OK
		MSCBSAY(nLinH+07,nLinV+16.0	,"Rua Bambuzinho S/N"	,"N","0",ctamY) //OK
		MSCBSAY(nLinH+07,nLinV+17.5	,"CEP 69075-846"	,"N","0",ctamY) //OK
		MSCBSAY(nLinH+07,nLinV+19.0	,"Dist Ind II"	,"N","0",ctamY) //OK
		MSCBSAY(nLinH+07,nLinV+20.5	,"Manaus - AM"	,"N","0",ctamY) //OK

	EndIf

	MSCBSAY(nLinH+20,nLinV+13.0	,"Importado e distribuido"	,"N","0",ctamY) //OK
	MSCBSAY(nLinH+20,nLinV+14.5	,"por Steck Electric SA"	,"N","0",ctamY) //OK
	MSCBSAY(nLinH+20,nLinV+16.0	,"Belisario Hueyo 165"	,"N","0",ctamY) //OK
	MSCBSAY(nLinH+20,nLinV+17.5	,"Avellaneda - B.A"	,"N","0",ctamY) //OK
	MSCBSAY(nLinH+20,nLinV+19.0	,"Buenos Aires"	,"N","0",ctamY) //OK
	MSCBSAY(nLinH+20,nLinV+20.5	,"Argentina"	,"N","0",ctamY) //OK

	// Ticket: 20210209002184
	MSCBSAY(nLinH+33,nLinV+13.0	,"Steck de Mexico S.A de C.V",	"N","0",ctamY) //OK
	MSCBSAY(nLinH+33,nLinV+14.5	,"Av. Cto Circunvalacion 149",	"N","0",ctamY) //OK
	MSCBSAY(nLinH+33,nLinV+16.0	,"Colonia Ciudad Satelite",		"N","0",ctamY) //OK
	MSCBSAY(nLinH+33,nLinV+17.5	,"Naucalpan de Juarez",			"N","0",ctamY) //OK
	MSCBSAY(nLinH+33,nLinV+19.0	,"Edo. Mexico - Mexico",		"N","0",ctamY) //OK

	//>> Ticket 20200420001748
	MSCBSAYBAR(nLinH+10,nLinV+22	,cBarCod,"N","MB04",14,.F.,.t.,.F.,,3,3,.F.)

Return

Static Function ImgPqMex(nCopias,nQtde,cLote,cColetivo)
	MSCBInfoEti("Produto Pq","")
	MSCBLoadGrf("steckp.GRF")

	If nCopias > 1
		MSCBBEGIN(Int(nCopias/2),6)
		ImgPqMex2(0)
		ImgPqMex2(51)
		MSCBEND()
	EndIf
	If Mod(nCopias,2) == 1 .or. nCopias ==1
		MSCBBEGIN(1,6)
		ImgPqMex2(0)
		MSCBEND()
	EndIf

Return

Static Function ImgPqMex2(nLinH)
	Local cBarCod		:= AllTrim(SB1->B1_CODBAR)
	Local nLinV 		:= 0
	Local ctamx			:= "018,016"
	Local ctamY			:= "014,013"
	Local cCompoEspa 	:= ""
	Local aCompo2 		:= {"MAT.PLASTICO","LIGAS ALEACIONES","MAT.PLASTICO Y ALEACIONES METALICAS"}

	cCompoEspa	:= aCompo2[Val(SB1->B1_XCOMPOS)]

	MSCBLineV(nLinH+10,nLinV+00,nLinV+27,3)
	MSCBGrafic(nLinH+05,nLinV+03,"steckp",.T.)

	MSCBSAY(nLinH+11,nLinV+01	,Left(Alltrim(SB1->B1_DESC)		,40)					,"N","0",ctamx)
	MSCBSAY(nLinH+11,nLinV+03	,"REF:"+StrTran(Alltrim(SB1->B1_COD),"_","-")			,"N","0",ctamx)
	MSCBSAY(nLinH+11,nLinV+06	,"COMPOSICION:" + Alltrim(cCompoEspa)					,"N","0",ctamY)
	MSCBSAY(nLinH+11,nLinV+08	,"PRODUCTO NO PERECEDERO"									,"N","0",ctamY)
	MSCBSAY(nLinH+30,nLinV+08	,"FABRICADO EN BRASIL"										,"N","0",ctamx)

	MSCBSAYBAR(nLinH+14,nLinV+10	,cBarCod,"N","MB04",14,.F.,.t.,.F.,,3,3,.F.)

Return

Static Function BuscaEmp(cEmpresa)
	Local nRecnoSM0 := SM0->(Recno())
	Local aEmp	:= {'','',''}
	If SM0->(DbSeek(cEmpresa+cFilAnt))		// Adicionado cFilAnt - Valdemir Rabelo 30/12/2020 - Ticket: 20201221012646
		aEmp := {SM0->M0_NOME,SM0->M0_ENDCOB,SM0->M0_CGC}
	EndIf
	SM0->(DbGoto(nRecnoSM0))
Return aClone(aEmp)

Static Function VldProduto()
	Local cMsg		:=""
	Local aArea		:=GetArea()
	Local aAreaSX3 :=SX3->(GetArea())
	Local aCampos 	:= {"B1_XTENSAO","B1_XCORREN","B1_XCOMPOS","B1_XGRFUC","B1_XGRFIMC","B1_XGRFCEN","B1_XGRFBV"}
	Local nX

	SX3->(DbSetOrder(2))
	For nx:= 1 to len(aCampos)
		If Empty(SB1->(FieldGet(FieldPos(aCampos[nX]))))
			SX3->(Dbseek(aCampos[nX]))
			cMsg +=aCampos[nX]+" - "+X3Titulo()+CRLF
		EndIf
	Next
	RestArea(aAreaSX3)
	RestArea(aArea)
Return cMsg

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �STCLAAM	�Autor  �Renato Nogueira     � Data �  18/03/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Fonte utilizado para verificar classifica��o do produto em  ���
���          �Manaus								 				      ���
�������������������������������������������������������������������������͹��
���Parametro � C�digo do produto                                          ���
�������������������������������������������������������������������������ͼ��
���Retorno   � Classifica��o em Manaus                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function STCLAAM(_cCod)

	Local cQuery 	:= ""
	Local cAlias 	:= "QRYTEMP"
	Local cBD       := ""

	if (cEmpAnt=="03")          // Valdemir Rabelo 31/03/2022 - Ticket: 20220331006994
		cBD := RetSqlName("SB1")
	Else 
		cBD := "UDBP12.SB1030"
	endif 

	cQuery := " SELECT B1_COD, B1_CLAPROD "
	//cQuery += " FROM SB1030 "
	cQuery += " FROM "+cBD + " "    // Valdemir Rabelo 29/12/2021 - Ticket: 20211228027525
	cQuery += " WHERE D_E_L_E_T_=' ' AND B1_COD='"+_cCod+"' "

	If !Empty(Select(cAlias))
		DbSelectArea(cAlias)
		(cAlias)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

	dbSelectArea(cAlias)
	(cAlias)->(dbGoTop())

Return((cAlias)->B1_CLAPROD)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �STCLASP	�Autor  �Renato Nogueira     � Data �  18/03/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Fonte utilizado para verificar classifica��o do produto em  ���
���          �SP    								 				      ���
�������������������������������������������������������������������������͹��
���Parametro � C�digo do produto                                          ���
�������������������������������������������������������������������������ͼ��
���Retorno   � Classifica��o em SP	                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function STCLASP(_cCod)

	Local cQuery 	:= ""
	Local cAlias 	:= "QRYTEMP"
	Local cBD       := ""

	if (cEmpAnt=="03")    // Valdemir Rabelo 31/03/2022 - Ticket: 20220331006994
		cBD := "UDBP12.SB1010"  
	else 
		cBD := RetSqlName("SB1")
	endif 

	cQuery := " SELECT B1_COD, B1_CLAPROD "
	cQuery += " FROM " + cBD + " "           // Valdemir Rabelo 29/12/2021 - Ticket: 20211228027525
	cQuery += " WHERE D_E_L_E_T_=' ' AND B1_COD='"+_cCod+"' "

	If !Empty(Select(cAlias))
		DbSelectArea(cAlias)
		(cAlias)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

	dbSelectArea(cAlias)
	(cAlias)->(dbGoTop())

Return((cAlias)->B1_CLAPROD)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �STEAN14F  �Autor  �Renato Nogueira     � Data �  30/01/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Fun��o utilizada para gerar o d�gito verificador do EAN14   ���
���Par�metro �String com 13 digito									      ���
���Retorno   �String contendo d�gito verificador					      ���
�������������������������������������������������������������������������͹��
���Uso       � Steck                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User function STEAN14F(cCod13)

	Local nOdd := 0
	Local nEven := 0
	Local nI
	Local nDig
	Local nMul := 10

	For nI := 1 to 13
		If (nI%2) == 0
			nEven += val(substr(cCod13,nI,1))
		Else
			nOdd += val(substr(cCod13,nI,1))
		Endif
	Next

	nDig := nEven + (nOdd*3)

	While nMul<nDig
		nMul += 10
	Enddo

Return strzero(nMul-nDig,1)

Static Function GETORIGEM()

	Local _cOrigem	:= ""

	Do Case
		Case SB1->B1_XPAIS=="1"
		_cOrigem	:= "na/en: China"
		Case SB1->B1_XPAIS=="2"
		_cOrigem	:= "na/en: Italia"
		Case SB1->B1_XPAIS=="3"
		_cOrigem	:= "na/en: Argentina"
		Case SB1->B1_XPAIS=="4"
		_cOrigem	:= "na/en: Colombia"
		Case SB1->B1_XPAIS=="5"
		_cOrigem	:= "no/en: Portugal"
		Case SB1->B1_XPAIS=="6"
		_cOrigem	:= "na/en: Espanha"
		Case SB1->B1_XPAIS=="7"
		_cOrigem	:= "na/en: Alemanha"
		Case SB1->B1_XPAIS=="8"
		_cOrigem	:= "na/en: Austria"
		Case SB1->B1_XPAIS=="9"
		_cOrigem	:= "no/en: Brasil"
	EndCase

Return(_cOrigem)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ImgStela  �Autor  �Microsiga           � Data �  10/19/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � Fun��o Auxiliar para impress�o                             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Steck                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function ImgStela(nCopias,nQtde,cLote,cColetivo,cEmpresa,cEan14,_nFrac)

	Local cQtd		:= Alltrim(str(nQtde))
	Local cBarCod	:= AllTrim(SB1->B1_CODBAR)
	Local cBarCod14	:= ""
	Local ctamG		:= "030,034"
	Local ctamM		:= "022,018"
	Local ctamP		:= "016,014"
	Local ctamx		:= "016,012"
	//Local cPorta:="LPT1"
	Local ccxmet
	Local nLinH		:= 9
	Local nLinV 	:= 0
	Local aEmp			:= BuscaEmp(cEmpAnt)
	Local cM0_CGC		:= aEmp[3]
	Local cImg
	Local _lSeg			:= .F.

	If SubStr(cM0_CGC,1,8)=="05890658" //SP Sempre Guararema
		cM0_CGC := "05890658000563"
	EndIf

	//DbSelectArea("SB1")
	//DbSetOrder(1)
	//DbSeek( xFilial("SB1") + mv_par01 )

	//If !SB1->(Eof())

	If !CB5SETIMP("000005",IsTelNet())
		MsgAlert("Falha na comunicacao com a impressora.")
		Return(Nil)
	EndIf

	MSCBINFOETI("Etiqueta 1","MODELO 1")

	If Alltrim(SB1->B1_COD) $ "868010#868011#868020#868021#868030#868031#868040#868080#868081#868082#868083"
		MSCBLOADGRF("868010.GRF")
		cImg	:= "868010"
	ElseIf Alltrim(SB1->B1_COD) $ "868050"
		MSCBLOADGRF("868050.GRF")
		cImg	:= "868050"
	ElseIf Alltrim(SB1->B1_COD) $ "868051"
		MSCBLOADGRF("868051.GRF")
		cImg	:= "868051"
	ElseIf Alltrim(SB1->B1_COD) $ "868070#SO868070"
		MSCBLOADGRF("868070.GRF")
		cImg	:= "868070"
	ElseIf Alltrim(SB1->B1_COD) $ "868071#SO868071"
		MSCBLOADGRF("868071.GRF")
		cImg	:= "868071"
	ElseIf Alltrim(SB1->B1_COD) $ "868072#SO868072"
		MSCBLOADGRF("868072.GRF")
		cImg	:= "868072"
	ElseIf Alltrim(SB1->B1_COD) $ "868073#SO868073"
		MSCBLOADGRF("868073.GRF")
		cImg	:= "868073"
	ElseIf Alltrim(SB1->B1_COD) $ "868074#SO868074"
		MSCBLOADGRF("868074.GRF")
		cImg	:= "868074"
	ElseIf Alltrim(SB1->B1_COD) $ "868090#SO868090#SO878090"
		MSCBLOADGRF("868090.GRF")
		cImg	:= "868090"
	ElseIf Alltrim(SB1->B1_COD) $ "868091#SO868091#SO878091"
		MSCBLOADGRF("868091.GRF")
		cImg	:= "868091"
	ElseIf Alltrim(SB1->B1_COD) $ "868092#SO868092#SO878092"
		MSCBLOADGRF("868092.GRF")
		cImg	:= "868092"
	ElseIf Alltrim(SB1->B1_COD) $ "868093#868094#868095#SO868095#SO868093#SO868094#SO878093#SO878094#SO878095"
		MSCBLOADGRF("868095.GRF")
		cImg	:= "868095"
	ElseIf Alltrim(SB1->B1_COD) $ "868096#SO868096#SO878096"
		MSCBLOADGRF("868096.GRF")
		cImg	:= "868096"
	ElseIf Alltrim(SB1->B1_COD) $ "869596"
		MSCBLOADGRF("869596.GRF")
		cImg	:= "869596"
	ElseIf Alltrim(SB1->B1_COD) $ "868097"
		MSCBLOADGRF("868097.GRF")
		cImg	:= "868097"
	ElseIf Alltrim(SB1->B1_COD) $ "869010"
		MSCBLOADGRF("869010.GRF")
		cImg	:= "869010"
	ElseIf Alltrim(SB1->B1_COD) $ "869011"
		MSCBLOADGRF("869011.GRF")
		cImg	:= "869011"
	ElseIf Alltrim(SB1->B1_COD) $ "869012"
		MSCBLOADGRF("869012.GRF")
		cImg	:= "869012"
	ElseIf Alltrim(SB1->B1_COD) $ "869013"
		MSCBLOADGRF("869013.GRF")
		cImg	:= "869013"
	ElseIf Alltrim(SB1->B1_COD) $ "869014"
		MSCBLOADGRF("869014.GRF")
		cImg	:= "869014"
	ElseIf Alltrim(SB1->B1_COD) $ "869015"
		MSCBLOADGRF("869015.GRF")
		cImg	:= "869015"
	ElseIf Alltrim(SB1->B1_COD) $ "869016"
		MSCBLOADGRF("869016.GRF")
		cImg	:= "869016"
	ElseIf Alltrim(SB1->B1_COD) $ "869017"
		MSCBLOADGRF("869017.GRF")
		cImg	:= "869017"
	ElseIf Alltrim(SB1->B1_COD) $ "869018"
		MSCBLOADGRF("869018.GRF")
		cImg	:= "869018"
	ElseIf Alltrim(SB1->B1_COD) $ "869019"
		MSCBLOADGRF("869019.GRF")
		cImg	:= "869019"
	ElseIf Alltrim(SB1->B1_COD) $ "869020"
		MSCBLOADGRF("869020.GRF")
		cImg	:= "869020"
	ElseIf Alltrim(SB1->B1_COD) $ "869070#SO869070"             // Valdemir Rabelo Chamado: 20220203002759
		MSCBLOADGRF("869070.GRF")
		cImg	:= "869070"
	ElseIf Alltrim(SB1->B1_COD) $ "869072"
		MSCBLOADGRF("869072.GRF")
		cImg	:= "869072"
	ElseIf Alltrim(SB1->B1_COD) $ "869073"						// Valdemir Rabelo Chamado: 20220104000198 - 16/03/2022
		MSCBLOADGRF("869073.GRF")
		cImg	:= "869073"
	ElseIf Alltrim(SB1->B1_COD) $ "869160#869161"
		MSCBLOADGRF("869161.GRF")
		cImg	:= "869161"
	ElseIf Alltrim(SB1->B1_COD) $ "869171"
		MSCBLOADGRF("869171.GRF")
		cImg	:= "869171"
	ElseIf Alltrim(SB1->B1_COD) $ "869110#869111#869120#869121#869130#869131#869140#869180#869181#869182#869183"
		MSCBLOADGRF("869183.GRF")
		cImg	:= "869183"
	ElseIf Alltrim(SB1->B1_COD) $ "869191"
		MSCBLOADGRF("869191.GRF")
		cImg	:= "869191"
	ElseIf Alltrim(SB1->B1_COD) $ "869192"
		MSCBLOADGRF("869192.GRF")
		cImg	:= "869192"
	ElseIf Alltrim(SB1->B1_COD) $ "869193#869194#869195"
		MSCBLOADGRF("869195.GRF")
		cImg	:= "869195"
	ElseIf Alltrim(SB1->B1_COD) $ "869210#869211#869220#869221"
		MSCBLOADGRF("869221.GRF")
		cImg	:= "869221"
	ElseIf Alltrim(SB1->B1_COD) $ "869260#869261"
		MSCBLOADGRF("869260.GRF")
		cImg	:= "869260"
	ElseIf Alltrim(SB1->B1_COD) $ "869270"
		MSCBLOADGRF("869270.GRF")
		cImg	:= "869270"
	ElseIf Alltrim(SB1->B1_COD) $ "869310#869312#869320"
		MSCBLOADGRF("869320.GRF")
		cImg	:= "869320"
	ElseIf Alltrim(SB1->B1_COD) $ "869316#869317#869326#869327"
		MSCBLOADGRF("869327.GRF")
		cImg	:= "869327"
	ElseIf Alltrim(SB1->B1_COD) $ "869360#869361"
		MSCBLOADGRF("869361.GRF")
		cImg	:= "869361"
	ElseIf Alltrim(SB1->B1_COD) $ "869370"
		MSCBLOADGRF("869370.GRF")
		cImg	:= "869370"
	ElseIf Alltrim(SB1->B1_COD) $ "869393#869394"
		MSCBLOADGRF("869394.GRF")
		cImg	:= "869394"
	ElseIf Alltrim(SB1->B1_COD) $ "869473"
		MSCBLOADGRF("869473.GRF")
		cImg	:= "869473"
	ElseIf Alltrim(SB1->B1_COD) $ "869510#869512#869520#869521"
		MSCBLOADGRF("869521.GRF")
		cImg	:= "869521"
	ElseIf Alltrim(SB1->B1_COD) $ "869516#869517#869526#869527"
		MSCBLOADGRF("869527.GRF")
		cImg	:= "869527"
	ElseIf Alltrim(SB1->B1_COD) $ "869570"
		MSCBLOADGRF("869570.GRF")
		cImg	:= "869570"
	ElseIf Alltrim(SB1->B1_COD) $ "869672"
		MSCBLOADGRF("869672.GRF")
		cImg	:= "869672"
	ElseIf Alltrim(SB1->B1_COD) $ "869772"
		MSCBLOADGRF("869772.GRF")
		cImg	:= "869772"
	ElseIf Alltrim(SB1->B1_COD) $ "869872"
		MSCBLOADGRF("869872.GRF")
		cImg	:= "869872"
	ElseIf Alltrim(SB1->B1_COD) $ "869974"
		MSCBLOADGRF("869974.GRF")
		cImg	:= "869974"
	ElseIf Alltrim(SB1->B1_COD) $ "868060#868060VM#868061#868061VM#SO868061#SO868060#SO868060VM#SO868061VM#SO878060#SO878061"
		MSCBLOADGRF("868061VM.GRF")
		cImg	:= "868061VM"
	ElseIf Alltrim(SB1->B1_COD) $ "868098#868099"
		MSCBLOADGRF("gar.GRF")
		cImg	:= "gar"
	ElseIf Alltrim(SB1->B1_COD) $ "868103#SO868103#SO878103"
		MSCBLOADGRF("868103.GRF")
		cImg	:= "868103"
	ElseIf Alltrim(SB1->B1_COD) $ "SO869198"
		MSCBLOADGRF("SO869198.GRF")
		cImg	:= "SO869198"
	ElseIf Alltrim(SB1->B1_COD) $ "SO868097#SO878097"
		MSCBLOADGRF("SO868097.GRF")
		cImg	:= "SO868097"
	ElseIf Alltrim(SB1->B1_COD) $ "SO868010#SO868020#SO868030#SO868031#SO868040#SO868080#SO868082#SO878010#SO878020#SO878030#SO878031#SO878040#SO878080#SO878082"
		MSCBLOADGRF("SO868010.GRF")
		cImg	:= "SO868010"
	ElseIf Alltrim(SB1->B1_COD) $ "SO869010#SO879010#SO889010#SO899010"
		MSCBLOADGRF("SO869010.GRF")
		cImg	:= "SO869010"
	ElseIf Alltrim(SB1->B1_COD) $ "SO869011#SO879011#SO889011#SO899011"
		MSCBLOADGRF("SO869011.GRF")
		cImg	:= "SO869011"
	ElseIf Alltrim(SB1->B1_COD) $ "SO869012#SO899012#SO889012#SO879012"
		MSCBLOADGRF("SO869012.GRF")
		cImg	:= "SO869012"
	ElseIf Alltrim(SB1->B1_COD) $ "SO869013#SO879013#SO889013#SO899013"
		MSCBLOADGRF("SO869013.GRF")
		cImg	:= "SO869013"
	ElseIf Alltrim(SB1->B1_COD) $ "SO869014#SO879014#SO889014#SO899014"
		MSCBLOADGRF("SO869014.GRF")
		cImg	:= "SO869014"
	ElseIf Alltrim(SB1->B1_COD) $ "SO869015#SO879015#SO889015#SO899015"
		MSCBLOADGRF("SO869015.GRF")
		cImg	:= "SO869015"
	ElseIf Alltrim(SB1->B1_COD) $ "SO869016#SO879016#SO889016#SO899016"
		MSCBLOADGRF("SO869016.GRF")
		cImg	:= "SO869016"
	ElseIf Alltrim(SB1->B1_COD) $ "SO869017#SO879017#SO889017#SO899017"
		MSCBLOADGRF("SO869017.GRF")
		cImg	:= "SO869017"
	ElseIf Alltrim(SB1->B1_COD) $ "SO869018#SO879018#SO889018#SO899018"
		MSCBLOADGRF("SO869018.GRF")
		cImg	:= "SO869018"
	ElseIf Alltrim(SB1->B1_COD) $ "SO869019#SO879019#SO889019#SO899019"
		MSCBLOADGRF("SO869019.GRF")
		cImg	:= "SO869019"
	ElseIf Alltrim(SB1->B1_COD) $ "SO869020#SO879020#SO889020#SO899020"
		MSCBLOADGRF("SO869020.GRF")
		cImg	:= "SO869020"
	ElseIf Alltrim(SB1->B1_COD) $ "SO869210#SO869220"
		MSCBLOADGRF("SO869210.GRF")
		cImg	:= "SO869210"
	ElseIf Alltrim(SB1->B1_COD) $ "SO869110#SO869120#SO869130#SO869180"
		MSCBLOADGRF("SO869110.GRF")
		cImg	:= "SO869110"
	ElseIf Alltrim(SB1->B1_COD) $ "SO869160#SO869161"
		MSCBLOADGRF("SO869160.GRF")
		cImg	:= "SO869160"
	ElseIf Alltrim(SB1->B1_COD) $ "SO869192"
		MSCBLOADGRF("SO869192.GRF")
		cImg	:= "SO869192"
	ElseIf Alltrim(SB1->B1_COD) $ "SO869191"
		MSCBLOADGRF("SO869191.GRF")
		cImg	:= "SO869191"
	ElseIf Alltrim(SB1->B1_COD) $ "SO869199"
		MSCBLOADGRF("SO869199.GRF")
		cImg	:= "SO869199"
	ElseIf Alltrim(SB1->B1_COD) $ "SO869193#SO869194#SO869195"
		MSCBLOADGRF("SO869193.GRF")
		cImg	:= "SO869193"
	ElseIf Alltrim(SB1->B1_COD) $ "SO869260#SO869261"
		MSCBLOADGRF("SO869260.GRF")
		cImg	:= "SO869260"
	ElseIf Alltrim(SB1->B1_COD) $ "SO869310#SO869312#SO869320"
		MSCBLOADGRF("SO869310.GRF")
		cImg	:= "SO869310"
	ElseIf Alltrim(SB1->B1_COD) $ "SO869316#SO869317"
		MSCBLOADGRF("SO869316.GRF")
		cImg	:= "SO869316"
	ElseIf Alltrim(SB1->B1_COD) $ "SO869360#SO869361"
		MSCBLOADGRF("SO869360.GRF")
		cImg	:= "SO869360"
	ElseIf Alltrim(SB1->B1_COD) $ "SO869510"
		MSCBLOADGRF("SO869510.GRF")
		cImg	:= "SO869510"
	ElseIf Alltrim(SB1->B1_COD) $ "SO869516"
		MSCBLOADGRF("SO869516.GRF")
		cImg	:= "SO869516"
	ElseIf Alltrim(SB1->B1_COD) $ "SO869596"
		MSCBLOADGRF("SO869596.GRF")
		cImg	:= "SO869596"
	EndIf

	MSCBloadGrf("steck01.GRF")
	MSCBloadGrf("tuv.GRF")
	MSCBloadGrf("seg.GRF")
	MSCBloadGrf("bv2.grf")

	MSCBBEGIN(nCopias,1)
	MSCBGrafic(04,08,"steck01",.T.)
	MSCBSAY(nLinH+10,nLinV+22,"CNPJ " + Transform(cM0_CGC, "@R 99.999.999/9999-99")	,"B","0","021,018",.t.) // 30
	MSCBSAY(025,004,SB1->B1_DESC													,"N","0",ctamG) //coluna,linha
	//MSCBLineV(021,004,130,1.5,"B")
	MSCBSAY(025,014,"REF:"+SB1->B1_COD												,"N","0",ctamG)
	MSCBSAY(025,019, cLote															,"N","0",ctamG)
	MSCBSAY(025,024,"Conteudo: "													,"N","0",ctamM)

	If !Empty(_nFrac)
		MSCBSAY(038,025,Alltrim(_nFrac)												,"N","0",ctamG)
	Else
		MSCBSAY(038,025,cQtd														,"N","0",ctamG)
	EndIf

	MSCBSAY(027,027,"Peca(s) "														,"N","0",ctamM)
	If !Empty(cImg)
		MSCBGrafic(100,012,cImg,.T.) //coluna, altura, imagem
	EndIf
	If SB1->B1_XGRFBV=="1"
		MSCBGrafic(065,023,"bv2",.T.) //coluna, altura, imagem
	ElseIf SB1->B1_XGRFUC=="1"
		MSCBGrafic(065,023,"seg",.T.) //coluna, altura, imagem
		MSCBGrafic(065,026,"tuv",.T.) //coluna, altura, imagem
	EndIf
	MSCBSAY(025,032,"FABRICADO NO BRASIL"											,"N","0",ctamP)
	MSCBSAY(025,035,"STECK INDUSTRIA ELETRICA LTDA."								,"N","0",ctamP)
	//Codigo EAN
	If Empty(_nFrac)
		If Alltrim(cEan14)=="Sim"
			DbSelectArea("SB5")
			SB5->(DbSetOrder(1))
			SB5->(DbGoTop())
			If SB5->(DbSeek(xFilial("SB5")+SB1->B1_COD))

				Do Case
					Case AllTrim(cQtd) == CVALTOCHAR(SB5->B5_EAN141)
					cBarCod14	:= "1"
					Case AllTrim(cQtd) == CVALTOCHAR(SB5->B5_EAN142)
					cBarCod14	:= "2"
					Case AllTrim(cQtd) == CVALTOCHAR(SB5->B5_EAN143)
					cBarCod14	:= "3"
					Case AllTrim(cQtd) == CVALTOCHAR(SB5->B5_EAN144)
					cBarCod14	:= "4"
					Case AllTrim(cQtd) == CVALTOCHAR(SB5->B5_EAN145)
					cBarCod14	:= "5"
					Case AllTrim(cQtd) == CVALTOCHAR(SB5->B5_EAN146)
					cBarCod14	:= "6"
					Case AllTrim(cQtd) == CVALTOCHAR(SB5->B5_EAN147)
					cBarCod14	:= "7"
					Case AllTrim(cQtd) == CVALTOCHAR(SB5->B5_EAN148)
					cBarCod14	:= "8"
				EndCase

				cBarCod		:= SubStr(cBarCod,1,12)
				cBarCod14	:= Alltrim(cBarCod14)+Alltrim(cBarCod)
				cBarCod14	:= Alltrim(cBarCod14)+U_STEAN14F(Alltrim(cBarCod14))

				MSCBSAYBAR(029,040,cBarCod14,"N","MB01",13,.F.,.T.,.F.,,2,2,.F.)
			EndIf
		Else
			MSCBSAYBAR(029,040,Alltrim(SB1->B1_CODBAR)										,"N","MB04",14,.F.,.T.,.F.,,,)
		EndIF
	EndIf

	If !Empty(_nFrac)
		MSCBSAYBAR(018,065,Alltrim(SB1->B1_COD)+"="+Alltrim(cLote)+"="+Alltrim(_nFrac)+"="+Alltrim(cEmpAnt)    ,"N","MB07",14,.T.,.T.,.F.,"B",2,1)
	Else
		MSCBSAYBAR(018,065,Alltrim(SB1->B1_COD)+"="+Alltrim(cLote)+"="+Alltrim(cQtd)+"="+Alltrim(cEmpAnt)    ,"N","MB07",14,.T.,.T.,.F.,"B",2,1)
	EndIf

	MSCBEND()

	//MSCBCLOSEPRINTER()

	//Else

	//	MsgAlert("Produto n�o encontrado!")

	//EndIf

Return
