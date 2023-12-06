#Include "Protheus.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CTBSTECK  ºAutor  ³Microsiga           º Data ³  08/10/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao auxiliar criada para auxiliar a contabilização      º±±
±±º          ³ retorna a conta contabil ou valor conforme parametros      º±±
±±º          ³ cLP = Lançamento Padrão                                    º±±
±±º          ³ cSeq = Sequencia de Lançamento                             º±±
±±º          ³ cTipo = "D" - Debito, "C" - Credito, "V" - Valor           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CTBSTECK(cLP,cSeq,cTipo)

	Local aArea	:= {}
	Local aArea2:= {}
	Local cCf	:= ""
	Local cTes	:= ""
	Local cDupl	:= ""
	Local cQuery	:= ""

	Local cAlias	:= ""
	Local lAchou	:= .F.
	Local _lLAE2    := .F.
	Local cEmp	:= SM0->M0_CODIGO
	Local xRet
	Local nCount	:= 0


// Definição da Conta Contábil a Débito LP 610
	If cLP = "560" .And. cSeq = "001" .And. cTipo = "D"

		cQuery := " SELECT E5_BANCO AS BANCO,E5_AGENCIA AS AGENCIA ,E5_CONTA AS NUMCON, A6_CONTA AS CONTACONT "
		cQuery += " FROM "+RetSqlName("SE5")+" SE5 "
		cQuery += " INNER JOIN "+RetSqlName("SA6")+" SA6 "
		cQuery += " ON SA6.D_E_L_E_T_ = ' ' "
		cQuery += " AND SA6.A6_FILIAL     = '"+xFilial("SA6")+"'
		cQuery += " AND SA6.A6_COD        = SE5.E5_BANCO "
		cQuery += " AND SA6.A6_AGENCIA    = SE5.E5_AGENCIA "
		cQuery += " AND SA6.A6_NUMCON     = SE5.E5_CONTA "
		cQuery += " WHERE "
		cQuery += " SE5.E5_FILIAL  = '"+SE5->E5_FILIAL+"' AND "
		cQuery += " SE5.E5_IDMOVI= '"+SE5->E5_IDMOVI+"' AND "
		cQuery += " SE5.E5_TIPODOC = 'TR'                  AND "
		cQuery += " SE5.E5_RECPAG  = 'R' AND "
		cQuery += " SE5.D_E_L_E_T_ = ' ' "

		cAlias := GetNextAlias()

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Fecha Alias se estiver em Uso ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !Empty(Select(cAlias))
			DbSelectArea(cAlias)
			(cAlias)->(dbCloseArea())
		Endif

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Monta Area de Trabalho executando a Query ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),cAlias,.T.,.T.)

		DbSelectArea(cAlias)
		(cAlias)->(dbGoTop())
		If !(cAlias)->(Eof())
			xRet := (cAlias)->CONTACONT
		Endif

		If Empty(xRet)
			xRet := ' '
		Endif

		If !Empty(Select(cAlias))
			DbSelectArea(cAlias)
			(cAlias)->(dbCloseArea())
		Endif

	ElseIf cLP = "572" .And. cSeq = "001" .And. cTipo = "D"

		If !EMPTY(SEU->EU_CONTA)
			xRet := SEU->EU_CONTA
		Else
			DbSelectArea("SED")
			SED->(DbSetOrder(1))
			SED->(DbSeek(xFilial("SED")+SEU->EU_X_NATUR))
			xRet := SED->ED_CONTA
			If !Empty(SEU->EU_CCD)
				dbSelectArea("CTT")
				CTT->(dbSetOrder(1))
				If CTT->(dbSeek(xFilial("CTT") + SEU->EU_CCD))
					If CTT->CTT_REFCTA = "2" .And. !Empty(SED->ED_XVEND) //Vendas
						xRet := SED->ED_XVEND
					ElseIf CTT->CTT_REFCTA $ "3,4" .And. !Empty(SED->ED_XCUST) //Custo
						xRet := SED->ED_XCUST
					EndIf
				EndIf
			EndIf
		EndIf

	ElseIf cLP = "610" .And. cSeq = "001" .And. cTipo = "D"

		cCf		:= Substr(AllTrim(SD2->D2_CF),2,3)
		cTes	:= AllTrim(SD2->D2_TES)
		xRet	:= 111001001
		cEst	:= IIF(SF2->F2_TIPOCLI="F",SA2->A2_EST,SA1->A1_EST)

		dbSelectArea("SF4")
		dbSetOrder(1)
		dbSeek(xFilial("SF4") + cTES)

		cDupl	:= SF4->F4_DUPLIC

		If cCf $"917"
			xRet := "114001040"
		ElseIf (cDupl = "S" .Or. cEst="EX" ) .And. !EMPTY(SA1->A1_CONTA)
			xRet := SA1->A1_CONTA
		ElseIf cTes $ "691" .And. cEmp = "01" .Or. cTes $ "720/731" .And. cEmp = "03"
			xRet := 410130060
		ElseIf cTes $ "522" .And. cEmp = "01" .Or. cTes $ "723" .And. cEmp = "03"
			xRet := 410130070
		ElseIf cCf $ "116/117"
			xRet := 210140001
		ElseIf cCf $"910" .And. SF4->F4_ZCLASOP == "2"
			xRet := 410130071
		ElseIf cCf $"949" .And. SF4->F4_ZCLASOP == "2"
			xRet := 410130071
		ElseIf cCf $"910" .And. SF4->F4_ZCLASOP == "3"
			xRet := 410130070
		ElseIf cCf $"949" .And. SF4->F4_ZCLASOP == "3"
			xRet := 410130070
		ElseIf cCf $"910" .And. SF4->F4_ZCLASOP == "4"
			xRet := 410130060
		ElseIf cCf $"949" .And. SF4->F4_ZCLASOP == "4"
			xRet := 410130060
			//ElseIf cCf $"910"
			//	xRet := 410130071
		ElseIf cCf $"911" .And. SF4->F4_ZCLASOP == "1"
			xRet := 410120010
		ElseIf cCf $"949" .And. SF4->F4_ZCLASOP == "1"
			xRet := 410120010
			//ElseIf cCf $"911/949"
			//	xRet := 410120010
		ElseIf cCf $"949" .And. (SF4->F4_ZCLASOP == "5" .Or. SF4->F4_ZCLASOP == "6")
			xRet := 410120001
		ElseIf cCf $"949" .And. (SF4->F4_ZCLASOP == "8" .OR. SF4->F4_ZCLASOP == "7" .OR. SF4->F4_ZCLASOP == "9" )
			//xRet := 511030057
			xRet := 410130091
		ElseIf cCf $"949"
			xRet := 511030057
		ElseIf cEst="EX"
			xRet := 111001002
		ElseIf cDupl = "N" .And. SF4->F4_ESTOQUE = "S" .And. Substr(AllTrim(SD2->D2_CF),1,1) <> "7"
			If SF4->F4_PODER3='D'
				xRet := 210130035
			ElseIf SF4->F4_PODER3='R' .OR. SD2->D2_TES="687"
				xRet := 114001045
			Else
				xRet := 510101001
			EndIf
		EndIf

		If cTes = "061"
			xRet := 510101001
		ElseIf cTes = "687"
			xRet := 114001045
		EndIf

		If Empty(SF4->F4_ZCLASOP)
			//Processo IG/OG
			xRet:= u_CTBIGOG(xRet)
		Endif

	ElseIf 	cLP = "610" .And. cSeq = "102" .And. cTipo = "D"

		If SF4->F4_ZCLASOP == "A"
			xRet := 511040005
		Else
			xRet := IF(SD2->D2_TES$"723",410130070,IF(SD2->D2_TES$"720/731",410130060,IF(Substr(AllTrim(SD2->D2_CF),2,3)$"910",410130071,IF(Substr(AllTrim(SD2->D2_CF),2,3)$"151/152",114001001,IF(Substr(AllTrim(SD2->D2_CF),2,3)$"116/117",311001001,IF(Substr(AllTrim(SD2->D2_CF),2,3)$"912/917",112001001,IF(Substr(AllTrim(SD2->D2_CF),2,3)$"913/918",210120001,IF(SF4->F4_DUPLIC="S",311001001,410140005))))))))
		Endif
		//Processo IG/OG
		xRet:= u_CTBIGOG(xRet)

	ElseIf cLP = "610" .And. cSeq = "102" .And. cTipo = "CCD"

		If SD2->D2_TES$"745" .And. SD2->D2_CLIENTE$"002552"
			xRet := 120201
		Else
			xRet := IIF(Substr(AllTrim(SD2->D2_CF),2,3)$"912/917/913/918" .OR. SF4->F4_DUPLIC="S","",IIF(SD2->D2_TES$"723/720/731".OR.Substr(AllTrim(SD2->D2_CF),2,3)$"910",114102,120401))
		Endif

		// Definição da Conta Contábil a Crédito LP 610
	ElseIf cLP = "610" .And. cSeq = "001" .And. cTipo = "C"

		cCf		:= Substr(AllTrim(SD2->D2_CF),2,3)
		cTes	:= AllTrim(SD2->D2_TES)
		xRet	:= IIF(!Empty(SD2->D2_CONTA),SD2->D2_CONTA,SB1->B1_CONTA)
		cEst	:= IIF(SF2->F2_TIPOCLI="F",SA2->A2_EST,SA1->A1_EST)


		dbSelectArea("SF4")
		dbSetOrder(1)
		dbSeek(xFilial("SF4") + cTES)

		cDupl	:= SF4->F4_DUPLIC

		If cDupl = "S"
			If cEst="EX"
				If cCf $"102/108/110/117/123/403"
					xRet := 310101003
				Else
					xRet := 310101005
				EndIf
			ElseIf cCf $ "116"
				xRet := 310101001
			ElseIf cCf $ "117"
				xRet := 310101002
			ElseIf cCf $ "501"
				xRet := 310101010
			ElseIf cCf $ "551"
				xRet := 322001005
			ElseIf cCf $ "933"
				xRet := 310101015
			ElseIf cCf $ "922"
				xRet := 210140001
			ElseIf SF4->F4_ZCLASOP=="D"
				xRet := 322001001
			ElseIf cTes $ "537/568/686/695/710" .And. cEmp = "01" .Or. cTes $ "716/734/737/743/745/746/753" .And. cEmp = "03" //Alterada regra conforme solitação 04/09/2014
				xRet := 322001001
			ElseIf cTes $ "645/703/613" .And. cEmp = "01" .Or. cTes $ "721" .And. cEmp = "03"
				xRet := 322001020
			Else
				If cCf $"102/108/110/117/123/403"
					xRet := 310101002
				Else
					xRet := 310101001
				EndIf
			EndIf
		ElseIf cEst="EX" .And. !cCf$"910/911/949"
			If cCf $"102/108/110/117/123/403"
				xRet := 310101003
			Else
				xRet := 310101005
			EndIf
		ElseIf cCf $ "116"
			xRet := 310101001
		ElseIf cCf $ "117"
			xRet := 310101002
		ElseIf cDupl = "N" .And. SF4->F4_ESTOQUE = "S" .And. Substr(AllTrim(SD2->D2_CF),1,1) <> "7"
			If SD2->D2_TES="687"

				If RTrim(SD2->D2_COD)=="020308" .Or. RTrim(SD2->D2_COD)=="020317"
					xRet := 510105002
				Else
					xRet := 114001010 //Solicitado por Eduardo Oliveira em 07/08/15
				Endif
			ElseIf SF4->F4_PODER3='D'
				xRet := 114001055
			EndIf
		ElseIf SD2->D2_TES="687"
			//xRet := 510105002
			If RTrim(SD2->D2_COD)=="020308" .Or. RTrim(SD2->D2_COD)=="020317"
				xRet := 510105002
			Else
				xRet := 114001010 //Solicitado por Eduardo Oliveira em 07/08/15
			Endif
		EndIf

		//Processo IG/OG
		xRet:= u_CTBIGOG(xRet)

	ElseIf cLP = "610" .And. cSeq = "001" .And. cTipo = "V"

		cCf	:= Substr(AllTrim(SD2->D2_CF),2,3)
		cTes	:= AllTrim(SD2->D2_TES)
		xRet	:= SD2->(D2_TOTAL+D2_VALIPI+D2_ICMSRET+D2_SEGURO+D2_VALFRE+D2_DESPESA)

		If SF4->F4_DUPLIC="N" .AND. SF4->F4_ESTOQUE="N" .AND. cCf$"151/152/554/901/906/905/912/914/915/916/923/949" .AND. AllTrim(SD2->D2_CF)<>"7949" .AND. cTes <> "687"
			xRet	:= 0
		ElseIf SF4->F4_DUPLIC="N" .AND. SF4->F4_ESTOQUE="S" .AND. cCf$"151/152/554/905/906"
			xRet	:= 0
		ElseIf cCf$"910"
			xRet	:= SD2->(D2_VALBRUT)
		Else
			If SD2->D2_TIPO="I"
				xRet	:= SD2->(D2_VALIPI+D2_ICMSRET)
			EndIf
		EndIf

		If cCf$"949"
			If SF4->F4_ICM=="S"
				xRet	:= SD2->(D2_TOTAL+D2_VALIPI+D2_ICMSRET+D2_SEGURO+D2_VALFRE+D2_DESPESA-D2_VALICM)
			Endif
		Endif

		If   cCf$("901")
		
			If SD2->D2_CUSTO1> 0
				xRet	:= SD2->D2_CUSTO1
			else
				xRet	:= SD2->(D2_TOTAL+D2_VALIPI+D2_ICMSRET+D2_SEGURO+D2_VALFRE+D2_DESPESA)
			Endif
		Endif

		// Definição do Centro de Custo a Débito LP 610
	ElseIf cLP = "610" .And. cSeq = "001" .And. cTipo = "X_CCD"

		cTes	    := AllTrim(SD2->D2_TES)
		cCf	 	:= Substr(AllTrim(SD2->D2_CF),2,3)
		xRet       := ""

		dbSelectArea("SF4")
		dbSetOrder(1)
		dbSeek(xFilial("SF4") + cTES)

		If cCf $ "910/911"
			xRet:= "114101"
		ElseIf cCf $ "949" .And. (SF4->F4_ZCLASOP == "5" .OR. SF4->F4_ZCLASOP == "6")
			xRet:= "114104"
		Elseif cCf $ "949" .And. SF4->F4_ZCLASOP == "1"
			If SubSTr(SD2->D2_CF,1,1) == "7"
				xRet:= "114105"
			Else
				xRet:= "114101"
			Endif
		ElseIf cCf $ "949" .And. (SF4->F4_ZCLASOP == "7" .OR. SF4->F4_ZCLASOP == "8" .OR. SF4->F4_ZCLASOP == "9" )
			//xRet:= "120209"
			xRet:= "114101"
		ElseIf cCf $ "949"
			xRet:= "120209"
		Endif

		//IF(Substr(AllTrim(SD2->D2_CF),2,3)$"910/911/949",114101,"")


	ElseIf cLP = "610" .And. cSeq = "001" .And. cTipo = "X_CCC"

		cTes	    := AllTrim(SD2->D2_TES)
		cCf	 	:= Substr(AllTrim(SD2->D2_CF),2,3)
		xRet       := ""

		dbSelectArea("SF4")
		dbSetOrder(1)
		dbSeek(xFilial("SF4") + cTES)

		If cCf $ "910/911"
			xRet:= "114101"
		ElseIf cCf $ "949" .And. (SF4->F4_ZCLASOP == "5" .OR. SF4->F4_ZCLASOP == "6")
			xRet:= "114104"
		ElseIf cCf $ "949" .And. (SF4->F4_ZCLASOP == "7" .OR. SF4->F4_ZCLASOP == "8")
			xRet:= "120209"
		ElseIf cCf $ "949"
			xRet:= "120209"
		Endif

		//IF(Substr(AllTrim(SD2->D2_CF),2,3)$"910/911/949",114101,"")

		// Definição do Valor a Débito LP 650
	ElseIf cLP = "650" .And. cSeq = "001" .And. cTipo = "VD"

		cCf		:= Substr(AllTrim(SD1->D1_CF),2,3)
		cTes	:= AllTrim(SD1->D1_TES)
		xRet	:= 0

		dbSelectArea("SF4")
		dbSetOrder(1)
		dbSeek(xFilial("SF4") + cTES)

		cDupl	:= SF4->F4_DUPLIC

		If cDupl = "S" .Or. cCf$"910/911/551/406" .Or. Substr(AllTrim(SD1->D1_CF),1,1) = "3" //Alterada regra para contabilização de Importação
			xRet := SD1->(D1_TOTAL+D1_VALIPI+D1_ICMSRET+D1_SEGURO+D1_DESPESA+D1_VALFRE-D1_VALDESC)
			If Substr(AllTrim(SD1->D1_CF),1,1) = "3"
				xRet := SD1->(D1_TOTAL+D1_VALIPI+D1_VALIMP5+D1_VALIMP6+D1_VALICM+D1_DESPESA+D1_SEGURO+D1_VALFRE-D1_VALDESC)
			EndIf
			If SF4->F4_CREDICM="S"
				xRet -= SD1->D1_VALICM
			EndIf
			If SF4->F4_CREDIPI="S"
				xRet -= SD1->D1_VALIPI
			EndIf
			If SF4->F4_PISCRED$"1/4"
				xRet -= SD1->(D1_VALIMP6+D1_VALIMP5)
			EndIf
			If SF4->F4_CREDST$"1/2"
				xRet -= SD1->D1_ICMSRET
			EndIf

			If SD1->D1_VALCMAJ > 0
				xRet+=SD1->D1_VALCMAJ
			Endif

			//Icms Difal
			If SD1->D1_ICMSCOM > 0
				xRet+=SD1->D1_ICMSCOM
			Endif


		ElseIf RTrim(SF4->F4_ZCLASOP)$"8"
			xRet := SD1->(D1_TOTAL+D1_VALIPI+D1_ICMSRET+D1_SEGURO+D1_DESPESA+D1_VALFRE-D1_VALDESC-SD1->D1_VALICM)
		ElseIf Substr(AllTrim(SD1->D1_CF),1,1) = "3"
			xRet := SD1->(D1_TOTAL+D1_DESPESA+D1_SEGURO+D1_VALFRE-D1_VALDESC)
		EndIf
		If SF1->F1_TIPO$"I,P"
			xRet := 0
		EndIf

		If cDupl = "N" .And. SD1->D1_FORNECE $ "006671/008186/010876" //Alterado conforme solicitação 20/04/2012
			xRet := SD1->D1_VALISS
		EndIf

		dbSelectArea("SDE")
		dbSetOrder(1)
		dbSeek(xFilial("SDE")+SD1->(D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_ITEM))
		If !EOF()
			xRet := 0
		EndIf

		// Definição do Valor a crédito LP 650
	ElseIf cLP = "650" .And. cSeq = "010" .And. cTipo = "VC"

		cCf		:= Substr(AllTrim(SD1->D1_CF),2,3)
		cTes	:= AllTrim(SD1->D1_TES)
		xRet	:= 0
		_cQryE2 := ""
		_nDifE2   := 0

		If Select("TSE2") > 0
			DbSelectArea("TSE2")
			DbCloSeArea()
		Endif

		dbSelectArea("SF4")
		dbSetOrder(1)
		dbSeek(xFilial("SF4") + cTES)

		cDupl	:= SF4->F4_DUPLIC

		If Substr(AllTrim(SD1->D1_CF),1,1) = "3"
			xRet := SD1->(D1_TOTAL+D1_VALIPI+D1_VALIMP5+D1_VALIMP6+D1_VALICM+D1_DESPESA+D1_SEGURO+D1_VALFRE-D1_VALDESC)
		ElseIf cDupl = "S" .Or. cCf$"910/911/551/406"
			xRet := SD1->(D1_TOTAL+D1_VALIPI+D1_ICMSRET-D1_VALINS-D1_VALIRR-D1_VALISS-D1_VALPIS-D1_VALCOF-D1_VALCSL+D1_SEGURO+D1_DESPESA+D1_VALFRE-D1_VALDESC)
		EndIf

		If RTrim(SF4->F4_ZCLASOP)$"8"
			xRet := SD1->(D1_TOTAL+D1_VALIPI+D1_ICMSRET+D1_SEGURO+D1_DESPESA+D1_VALFRE-D1_VALDESC-SD1->D1_VALICM)
		Endif

		If SF1->F1_TIPO$"I,P"
			xRet -= SD1->D1_TOTAL
		EndIf


		If RTrim(SF1->F1_ESPECIE)=="NFS"

			If Select("TSE2") > 0
				DbSelectArea("TSE2")
				DbCloSeArea()
			Endif

			_cQryE2 := " SELECT SE2.E2_FILIAL AS FIL ,                   "
			_cQryE2 += "        SE2.E2_VALOR  AS VALOR                   "
			_cQryE2 += " FROM "+RetSqlName("SE2")+" SE2                  "
			_cQryE2 += " WHERE SE2.E2_FILIAL ='"+xFilial("SE2")+"'   AND "
			_cQryE2 += "       SE2.D_E_L_E_T_ <> '*'                 AND "
			_cQryE2 += "       SE2.E2_NUM     ='"+SF1->F1_DOC+"'     AND "
			_cQryE2 += "       SE2.E2_FORNECE ='"+SF1->F1_FORNECE+"' AND "
			_cQryE2 += "       SE2.E2_LOJA    ='"+SF1->F1_LOJA+"'    AND "
			_cQryE2 += "       SE2.E2_PREFIXO = '"+SF1->F1_PREFIXO+"'    "

			TCQUERY _cQryE2 NEW ALIAS "TSE2"

			_nRec :=0
			DbEval({|| _nRec++ })

			DbSelectArea("TSE2")
			DbGotop()

			_nDifE2 := 	(xRet - TSE2->VALOR)
			_nDifE2 := IIF(_nDifE2<0,_nDifE2*(-1),_nDifE2)

			If _nDifE2 <=0.10
				xRet := TSE2->VALOR
			Endif



		Endif

	ElseIf cLP = "650" .And. cSeq = "014" .And. cTipo = "V"

		xRet	:= IF(SD1->D1_TIPO="D".OR.U_STVLDEV(SD1->D1_CF),0,IIF(RTRIM(SF1->F1_ESPECIE)=="NFS",SD1->(D1_VALPIS+D1_VALCOF+D1_VALCSL),SD1->(D1_VALPIS+D1_VALCOF+D1_VALCSL)))

		If RTrim(SF1->F1_ESPECIE)=="NFS"

			If Select("TE2") > 0
				DbSelectArea("TE2")
				DbCloSeArea()
			Endif

			_cQryE2 := " SELECT                                                      "
			_cQryE2 += "        SUM(SE2.E2_VALOR)  AS VALOR                          "
			_cQryE2 += " FROM "+RetSqlName("SE2")+" SE2                              "
			_cQryE2 += " WHERE SE2.E2_FILIAL ='"+xFilial("SE2")+"'               AND "
			_cQryE2 += "       SE2.D_E_L_E_T_ <> '*'                             AND "
			_cQryE2 += "       SUBSTR(SE2.E2_TITPAI,4,9)  ='"+SF1->F1_DOC+"'     AND "
			_cQryE2 += "       SUBSTR(SE2.E2_TITPAI,19,6) ='"+SF1->F1_FORNECE+"' AND "
			_cQryE2 += "       SUBSTR(SE2.E2_TITPAI,25,2) ='"+SF1->F1_LOJA+"'    AND "
			_cQryE2 += "       SE2.E2_PREFIXO = '"+SF1->F1_PREFIXO+"'            AND "
			_cQryE2 += "       SE2.E2_NATUREZ IN ('PIS','COFINS','CSLL')             "

			TCQUERY _cQryE2 NEW ALIAS "TSE2"

			_nRec :=0
			DbEval({|| _nRec++ })

			DbSelectArea("TSE2")
			DbGotop()
			If TSE2->VALOR > 0
				xRet := TSE2->VALOR
			Endif

		Endif

	ElseIf  cLP = "650" .And. cSeq = "012" .And. cTipo = "V"

		xRet	:= IF(SD1->D1_TIPO="D".OR.U_STVLDEV(SD1->D1_CF),0,IIF(RTRIM(SF1->F1_ESPECIE)=="NFS",Round(SD1->D1_BASEIRR*(SD1->D1_ALIQIRR/100),2),SD1->D1_VALIRR))

		If RTrim(SF1->F1_ESPECIE)=="NFS"

			If Select("TE2") > 0
				DbSelectArea("TE2")
				DbCloSeArea()
			Endif

			_cQryE2 := " SELECT                                                      "
			_cQryE2 += "        SUM(SE2.E2_VALOR)  AS VALOR                          "
			_cQryE2 += " FROM "+RetSqlName("SE2")+" SE2                              "
			_cQryE2 += " WHERE SE2.E2_FILIAL ='"+xFilial("SE2")+"'               AND "
			_cQryE2 += "       SE2.D_E_L_E_T_ <> '*'                             AND "
			_cQryE2 += "       SUBSTR(SE2.E2_TITPAI,4,9)  ='"+SF1->F1_DOC+"'     AND "
			_cQryE2 += "       SUBSTR(SE2.E2_TITPAI,19,6) ='"+SF1->F1_FORNECE+"' AND "
			_cQryE2 += "       SUBSTR(SE2.E2_TITPAI,25,2) ='"+SF1->F1_LOJA+"'    AND "
			_cQryE2 += "       SE2.E2_PREFIXO = '"+SF1->F1_PREFIXO+"'            AND "
			_cQryE2 += "       SE2.E2_NATUREZ IN ('IRF')             "

			TCQUERY _cQryE2 NEW ALIAS "TSE2"

			_nRec :=0
			DbEval({|| _nRec++ })

			DbSelectArea("TSE2")
			DbGotop()
			If TSE2->VALOR > 0
				xRet := TSE2->VALOR
			Endif

		Endif


		// Definição da Conta Contábil a Débito LP 650
	ElseIf cLP = "650" .And. cSeq = "001" .And. cTipo = "D"

		cCf		:= Substr(AllTrim(SD1->D1_CF),2,3)
		cTes	:= AllTrim(SD1->D1_TES)

		If cCf = "352"
			//If SA2->A2_COD $ "005593/006609/004855" .And. cEmp = "01" .Or. SA2->A2_COD $ "006609/010460" .And. cEmp = "03"  Solicitação Eduardo 02/12/2017
			//	xRet := "511030056"
			//Else
			//	xRet := "410130086"
			//EndIf
			If cEmp = "01"
				//xRet := "410130086" Reclassificação 19/08/2021 - Cristiano
				xRet := "511030058"
			ElseIf Rtrim(SD1->D1_CC) $ "114102" .And. cEmp = "03"
				//xRet := "410130086" Reclassificação 19/08/2021 - Cristiano
				xRet := "511030058"
			ElseIf RTrim(SD1->D1_CC) $ "120210" .And. cEmp = "03"
				xRet := "511030056"
			Else
				//xRet := "410130086" Reclassificação 19/08/2021 - Cristiano
				xRet := "511030058"
			Endif
		ElseIf cCf = "922"
			xRet := "122001045"
		ElseIf  SD1->D1_FORNECE $ "006671/008186/010876" //Alterado conforme solicitação 20/04/2013
			xRet := "410130081"
		ElseIf  Rtrim(SD1->D1_CC) $ "112105" //Alterado conforme solicitação 23/08/2021
			xRet := "511030071"
		Else //Alterado conforme solicitação 21/12/2012
			xRet := STCCPRD()
		EndIf


	ElseIf cLP = "650" .And. cSeq = "001" .And. cTipo = "CCD"

	/*
		IF Substr(AllTrim(SD1->D1_CF),2,3)$"352".And.SA2->A2_COD$"005593/006609/004855"
	//xRet := 120210
	xRet   := 115104
		ElseIf Substr(AllTrim(SD1->D1_CF),2,3)$"352"
	xRet := 114102
		ElseIf Alltrim(SD1->D1_FORNECE)$"006671/008186/010876"
	xRet := 112105
		Else
	xRet := SD1->D1_CC
		EndIf
	*/

		If Substr(AllTrim(SD1->D1_CF),2,3)$"352" .And. cEmp = "01"
			If !Empty(SD1->D1_CC) .And. (Rtrim(SD1->D1_CC)$"115104" .Or. RTrim(SD1->D1_CC)$"114102")
				//xRet   := SD1->D1_CC
				xRet   :=  "115103"
			Else
				//xRet   := "114102"
				xRet   := "115103"
			Endif
		Elseif Substr(AllTrim(SD1->D1_CF),2,3)$"352" .And. cEmp = "11"
			If !Empty(SD1->D1_CC) .And. (Rtrim(SD1->D1_CC)$"115104" .Or. RTrim(SD1->D1_CC)$"114102")
				//xRet   := SD1->D1_CC
				xRet   :=  "115103"
			Else
				//xRet   := "114102"
				xRet   := "115103"
			Endif
		ElseIf Substr(AllTrim(SD1->D1_CF),2,3)$"352" .And. cEmp = "03"

			If !Empty(SD1->D1_CC) .And. (RTrim(SD1->D1_CC)$"114102" .Or. RTrim(SD1->D1_CC)$"120210")

				If RTrim(SD1->D1_CC)$"114102"
					xRet   := "115110"
				else
					xRet   := SD1->D1_CC
					//xRet   := "115103"
				Endif
			Else
				If cEmp == "03"
					xRet   := "115103"
				Else
					xRet   := "114102"
				Endif

			Endif

		ElseIf Alltrim(SD1->D1_FORNECE)$"006671/008186/010876"
			xRet := 112105
		ElseIf  Rtrim(SD1->D1_CC) $ "112105" //Alterado conforme solicitação 23/08/2021
			xRet := "115109"
		Else
			xRet := SD1->D1_CC
		EndIf

		// Definição da Conta Contábil a Credito LP 650
	ElseIf cLP = "650" .And. cSeq = "010" .And. cTipo = "C"

		cCf		:= Substr(AllTrim(SD1->D1_CF),2,3)
		cTes	:= AllTrim(SD1->D1_TES)
		xRet	:= 210101005

		dbSelectArea("SF4")
		dbSetOrder(1)
		dbSeek(xFilial("SF4") + cTES)

		cDupl	:= SF4->F4_DUPLIC

		If Substr(AllTrim(SD1->D1_CF),1,1) = "3"
			xRet := 115001001
		ElseIf cCf $ "911/910"
			xRet := 322001035
		ElseIf cDupl = "S"
			If !Empty(SA2->A2_CONTA)
				xRet := SA2->A2_CONTA
			ElseIf SA2->A2_EST = "EX"
				xRet := 210101010
			Else
				xRet := 210101005
			EndIf
		ElseIf cDupl = "N" .And. cCf $ "551/406"
			xRet := 122001045
		EndIf

	ElseIf cLP = "650" .And. cSeq = "021" .And. cTipo = "D"

		cCf		:= Substr(AllTrim(SD1->D1_CF),2,3)
		cTes	:= AllTrim(SD1->D1_TES)
		xRet	:= 0

		dbSelectArea("SF4")
		dbSetOrder(1)
		dbSeek(xFilial("SF4") + cTES)

		If SF4->F4_PODER3 = 'R'
			xRet	:= 114001055
		ElseIf (SD1->D1_FORNECE=="000032" .Or. SD1->D1_FORNECE=="000693" .oR. SD1->D1_FORNECE=="010454") .And. SF4->F4_PODER3="D"
			xRet	:= 510105002
		ElseIf RTrim(SD1->D1_COD)=="020308" .Or. RTrim(SD1->D1_COD)=="020317"
			xRet	:= 510105002
		Else
			xRet	:= IIF(!Empty(SD1->D1_CONTA),SD1->D1_CONTA,SB1->B1_CONTA)
		EndIf

	ElseIf cLP = "650" .And. cSeq = "021" .And. cTipo = "C"

		cCf		:= Substr(AllTrim(SD1->D1_CF),2,3)
		cTes	:= AllTrim(SD1->D1_TES)
		xRet	:= 510101001

		dbSelectArea("SF4")
		dbSetOrder(1)
		dbSeek(xFilial("SF4") + cTES)

		If SF4->F4_PODER3 = 'R'
			xRet	:= 210130035
		ElseIf SF4->F4_PODER3 = 'D' .Or. cCf$"902/903"
			xRet	:= 114001045
		Else
			xRet	:= 510101001
		EndIf

	ElseIf cLP = "650" .And. cSeq = "021" .And. cTipo = "V"

		cCf		:= Substr(AllTrim(SD1->D1_CF),2,3)
		cTes	:= AllTrim(SD1->D1_TES)
		xRet	:= 0

		dbSelectArea("SF4")
		dbSetOrder(1)
		dbSeek(xFilial("SF4") + cTES)

		If SF4->F4_DUPLIC = 'N' .And. SF4->F4_ESTOQUE = 'S' .And. !cCf $ "554/151/152/201/411/905/906/910/911/406/551" .And. Substr(AllTrim(SD1->D1_CF),1,1) <> "3" .And. Substr(SD1->D1_COD,1,1) <> "U"
			xRet := SD1->D1_TOTAL
		EndIf


		If  cCf$"902/903"
			If SD1->D1_CUSTO > 0
				xRet := SD1->D1_CUSTO
			else
				xRet := SD1->D1_TOTAL
			Endif
		Endif

	ElseIf cLP = "530" .And. cSeq = "009" .And. cTipo = "V"

		cAlias := "QRYSE2"

		xRet := 0

		If !Empty(SE2->E2_FATURA) .AND. SE5->E5_MOTBX = "FAT"

			aArea := SE2->(GetArea())

			cQuery	+=	" SELECT DISTINCT(E2_LOJA) E2_LOJA FROM "+RetSqlName("SE2")
			cQuery	+=	" WHERE E2_FILIAL = '"+xFilial("SE2")+"' AND E2_FATPREF = '"+SE2->E2_FATPREF+"' AND E2_FATURA = '"+SE2->E2_FATURA+"' "
			cQuery	+=	" AND "+RetSqlName("SE2")+".D_E_L_E_T_= ' ' AND E2_TIPO NOT IN('TX ','INS','ISS')                                    "

			cQuery	:= ChangeQuery(cQuery)

			If !Empty(Select(cAlias))
				DbSelectArea(cAlias)
				(cAlias)->(dbCloseArea())
			Endif

			dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),cAlias, .T., .T.)

			dbSelectArea(cAlias)
			(cAlias)->(DbGoTop())

			While (cAlias)->(!Eof())
				nCount++
				If (cAlias)->E2_LOJA <> SE2->E2_FATLOJ
					lAchou := .T.
				EndIf


				(cAlias)->(DbSkip())
			Enddo

			If !Empty(Select(cAlias))
				DbSelectArea(cAlias)
				(cAlias)->(dbCloseArea())
			Endif

			RestArea(aArea)

			//If lAchou .Or. nCount > 1 - Cont Aglutinacao

			If !_lLAE2 .And. !(Rtrim(SE2->E2_TIPO)$('TX/INS/ISS'))
				xRet := SE5->E5_VALOR
			Endif
			//EndIF

		EndIf



	ElseIf cLP = "530" .And. cSeq = "010" .And. cTipo = "V"

		cAlias := "QRYSE2"

		xRet := 0

		If !Empty(SE2->E2_FATURA) .AND. SE5->E5_MOTBX = "FAT"

			aArea := SE2->(GetArea())

			cQuery	+=	" SELECT DISTINCT(E2_LOJA) E2_LOJA FROM "+RetSqlName("SE2")
			cQuery	+=	" WHERE E2_FILIAL = '"+xFilial("SE2")+"' AND E2_FATPREF = '"+SE2->E2_FATPREF+"' AND E2_FATURA = '"+SE2->E2_FATURA+"' "
			cQuery	+=	" AND "+RetSqlName("SE2")+".D_E_L_E_T_= ' ' AND E2_TIPO NOT IN('TX ','INS','ISS')                                    "

			cQuery	:= ChangeQuery(cQuery)

			If !Empty(Select(cAlias))
				DbSelectArea(cAlias)
				(cAlias)->(dbCloseArea())
			Endif

			dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),cAlias, .T., .T.)

			dbSelectArea(cAlias)
			(cAlias)->(DbGoTop())

			While (cAlias)->(!Eof())
				nCount++
				If (cAlias)->E2_LOJA <> SE2->E2_FATLOJ
					lAchou := .T.
				EndIf


				(cAlias)->(DbSkip())
			Enddo

			If !Empty(Select(cAlias))
				DbSelectArea(cAlias)
				(cAlias)->(dbCloseArea())
			Endif

			RestArea(aArea)

			//If lAchou .Or. nCount > 1 - Cont Aglutinacao

			If !_lLAE2 .And. !(Rtrim(SE2->E2_TIPO)$('TX/INS/ISS'))
				xRet := SE5->E5_VALOR
			Endif
			//EndIF

		EndIf

	ElseIf cLP = "530" .And. cSeq = "008" .And. cTipo = "CCD"

		xRet := 0
		cAlias := "QRYRC1"

		If Rtrim(SE2->E2_PREFIXO)=="GPE"

			aArea := RC1->(GetArea())

			cQuery	:=	" SELECT RC1.RC1_CC AS CC "
			cQuery	+=	" FROM "+RetSqlName("RC1")+" RC1 "
			cQuery	+=	" WHERE RC1.RC1_FILCEN='"+SE2->E2_FILIAL+"' AND RC1.RC1_NUMTIT = '"+SE2->E2_NUM+"' AND  "
			cQuery	+=	"       RC1.RC1_FORNEC = '"+SE2->E2_FORNECE+"'  AND RC1.RC1_LOJA='"+SE2->E2_LOJA+"' AND RC1.D_E_L_E_T_= ' '   "

			cQuery	:= ChangeQuery(cQuery)

			If !Empty(Select(cAlias))
				DbSelectArea(cAlias)
				(cAlias)->(dbCloseArea())
			Endif

			dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),cAlias, .T., .T.)

			dbSelectArea(cAlias)
			(cAlias)->(DbGoTop())

			If !Empty(Select(cAlias))
				xRet := 	(cAlias)->CC
				(cAlias)->(dbCloseArea())
			EndIf

			RestArea(aArea)

		Else
			xRet  := IIF(SE2->E2_NATUREZ=="24023",114105,IIF(SE2->E2_NATUREZ$"25501/25502/25503/25504/25505"," ",IIF(SE2->E2_NATUREZ=="22510",113101, IIF(!Empty(SE2->E2_CCD),SE2->E2_CCD,SE2->E2_CCUSTO))))
		Endif


	ElseIf cLP = "532" .And. cSeq = "008" .And. cTipo = "VD"

		cAlias := "QRYSE2"

		xRet := 0

		If SE5->E5_PREFIXO <>"AGL"
			xRet := IIF(SE5->E5_MOTBX$"DAC/FAT",0,IIF(SE2->E2_MOEDA==1,SE2->(E2_VALLIQ+E2_XDESC-E2_XJUROS-E2_XTARIFA-E2_XMULTA-(IIF(SE2->E2_XJUROS=0 .AND. SE2->E2_XMULTA=0 .AND.SE2->E2_ACRESC>0,SE2->E2_ACRESC,0))),SE2->(E2_VLCRUZ)))
		Else

			aArea := SE2->(GetArea())

			cQuery	+=	" SELECT E2_XJUROS FROM "+RetSqlName("SE2")
			cQuery	+=	" WHERE E2_FILIAL = '"+xFilial("SE2")+"' AND E2_FATPREF = '"+SE5->E5_PREFIXO+"' AND E2_FATURA = '"+SE5->E5_NUMERO+"'  "
			cQuery	+=	" AND "+RetSqlName("SE2")+".D_E_L_E_T_= ' ' AND E2_TIPO NOT IN('TX ','INS','ISS')                                     "

			cQuery	:= ChangeQuery(cQuery)

			If !Empty(Select(cAlias))
				DbSelectArea(cAlias)
				(cAlias)->(dbCloseArea())
			Endif

			dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),cAlias, .T., .T.)

			dbSelectArea(cAlias)
			(cAlias)->(DbGoTop())

			xRet:= IIF(SE5->E5_MOTBX$"DAC/FAT",0,IIF(SE2->E2_MOEDA==1,SE2->(E2_VALLIQ+E2_XDESC-E2_XJUROS-E2_XTARIFA-E2_XMULTA-(IIF(SE2->E2_XJUROS=0 .AND. SE2->E2_XMULTA=0 .AND.SE2->E2_ACRESC>0,SE2->E2_ACRESC,0))),SE2->(E2_VLCRUZ)))-(cAlias)->E2_XJUROS

			If !Empty(Select(cAlias))
				DbSelectArea(cAlias)
				(cAlias)->(dbCloseArea())
			Endif

			RestArea(aArea)



		EndIf

	ElseIf cLP = "532" .And. cSeq = "008" .And. cTipo = "ID"
		//xRet := IIF(U_CTBSTECK("532","008","D")$"111001001/111001002/210101005/210101010/112001001/112001005/112001010/112001015/112001020/112001025/112001030/122001010/210130005/210101006/210101011","2"+RTRIM(SA2->A2_COD)+RTRIM(SA2->A2_LOJA),IIF(U_CTBSTECK("532","008","D")$"210120001","5001",IIF(U_CTBSTECK("532","008","D")$"210120005","5010",IIF(U_CTBSTECK("532","008","D")$"210120010","5020",IIF(U_CTBSTECK("532","008","D")$"112002016","4053",IIF(U_CTBSTECK("532","008","D")$"112002021","4063",""))))))


		xRet := iif(u_CTBBRAIT(U_CTBSTECK("532","008","D")),"2"+RTRIM(SA2->A2_COD)+RTRIM(SA2->A2_LOJA),"")


		If Rtrim(cValToChar(U_CTBSTECK("532","008","D")))=="210120001"
			xRet :=  "5001"
		ElseIf RTrim(cValToChar(U_CTBSTECK("532","008","D")))=="210120005"
			xRet :="5010"
		ElseIf RTrim(cValToChar(U_CTBSTECK("532","008","D")))=="210120010"
			xRet :="5020"
		ElseIf RTrim(cValToChar(U_CTBSTECK("532","008","D")))=="112002016"
			xRet :="4053"
		ElseIf RTrim(cValToChar(U_CTBSTECK("532","008","D")))=="112001005"
			xRet :="4053"
		ElseIf RTrim(cValToChar(U_CTBSTECK("532","008","D")))=="112002021"
			xRet :="4063"
		Endif

		If Substr(cNumEmp,01,02)=="11"
			If RTrim(cValToChar(U_CTBSTECK("532","008","D")))=="112001005"
				xRet :="4013"
			Endif
		Endif


	ElseIf cLP = "532" .And. cSeq = "009" .And. cTipo = "V"

		cAlias := "QRYSE2"

		xRet := 0

		If SE5->E5_PREFIXO <>"AGL"
			xRet := 0
		Else

			aArea := SE2->(GetArea())

			cQuery	+=	" SELECT E2_XJUROS FROM "+RetSqlName("SE2")
			cQuery	+=	" WHERE E2_FILIAL = '"+xFilial("SE2")+"' AND E2_FATPREF = '"+SE5->E5_PREFIXO+"' AND E2_FATURA = '"+SE5->E5_NUMERO+"'  "
			cQuery	+=	" AND "+RetSqlName("SE2")+".D_E_L_E_T_= ' ' AND E2_TIPO NOT IN('TX ','INS','ISS')                                     "

			cQuery	:= ChangeQuery(cQuery)

			If !Empty(Select(cAlias))
				DbSelectArea(cAlias)
				(cAlias)->(dbCloseArea())
			Endif

			dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),cAlias, .T., .T.)

			dbSelectArea(cAlias)
			(cAlias)->(DbGoTop())

			xRet:= (cAlias)->E2_XJUROS

			If !Empty(Select(cAlias))
				DbSelectArea(cAlias)
				(cAlias)->(dbCloseArea())
			Endif


			If rtrim(SE2->E2_PREFIXO)=="AGL" .AND. rtrim(SE2->E2_NATUREZ)=="INSS"

				If Select("TSE2") > 0
					DbSelectArea("TSE2")
					DbCloSeArea()
				Endif

				cQuery := " SELECT                                           "
				cQuery += "        SUM(SE2.E2_VALOR)  AS VALOR               "
				cQuery += " FROM "+RetSqlName("SE2")+" SE2                   "
				cQuery += " WHERE                                            "
				cQuery += "       SE2.D_E_L_E_T_ <> '*'                 AND  "
				cQuery += "       SE2.E2_FATURA     ='"+SE2->E2_NUM+"'  AND  "
				cQuery += "       SE2.E2_PREFIXO='GPE'                       "


				cQuery	:= ChangeQuery(cQuery)

				If !Empty(Select(cAlias))
					DbSelectArea(cAlias)
					(cAlias)->(dbCloseArea())
				Endif

				dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),cAlias, .T., .T.)

				dbSelectArea(cAlias)
				(cAlias)->(DbGoTop())

				xRet:= (cAlias)->VALOR

				If !Empty(Select(cAlias))
					DbSelectArea(cAlias)
					(cAlias)->(dbCloseArea())
				Endif
			Endif

			RestArea(aArea)
		EndIf

	ElseIf cLP = "531" .And. cSeq = "005" .And. cTipo = "V"


		cAlias := "QRYSE2"

		xRet := 0

		If SE5->E5_PREFIXO <>"AGL"
			xRet := IIF(SE5->E5_MOTBX$"DAC/FAT",0,IIF(SE2->E2_JUROS>0,SE2->(E2_JUROS-E2_ACRESC),0)+SE2->(E2_XVARCAM+E2_XJUROS))
		Else

			aArea := SE2->(GetArea())

			cQuery	+=	" SELECT E2_XJUROS FROM "+RetSqlName("SE2")
			cQuery	+=	" WHERE E2_FILIAL = '"+xFilial("SE2")+"' AND E2_FATPREF = '"+SE5->E5_PREFIXO+"' AND E2_FATURA = '"+SE5->E5_NUMERO+"'  "
			cQuery	+=	" AND "+RetSqlName("SE2")+".D_E_L_E_T_= ' ' AND E2_TIPO NOT IN('TX ','INS','ISS')                                     "

			cQuery	:= ChangeQuery(cQuery)

			If !Empty(Select(cAlias))
				DbSelectArea(cAlias)
				(cAlias)->(dbCloseArea())
			Endif

			dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),cAlias, .T., .T.)

			dbSelectArea(cAlias)
			(cAlias)->(DbGoTop())

			xRet:= (cAlias)->E2_XJUROS

			If !Empty(Select(cAlias))
				DbSelectArea(cAlias)
				(cAlias)->(dbCloseArea())
			Endif

			RestArea(aArea)



		EndIf

	ElseIf cLP = "530" .And. cSeq = "008" .And. cTipo = "V"
		xRet := IIF(SE5->E5_MOTBX$"LIQ",0,IIF(SE5->E5_MOTBX$"DAC/FAT",0,IIF(SE2->E2_TIPO$"TX ".AND.!Empty(SE5->E5_AGLIMP),0,IIF(SE2->E2_MOEDA==1,IIF(SE2->(E2_JUROS+E2_MULTA+E2_DESCONT)>0,SE2->(E2_VALLIQ+E2_DESCONT-E2_JUROS-E2_MULTA),SE2->(IIF(E2_VALLIQ<=0,E2_VLCRUZ,E2_VALLIQ)-((E2_XJUROS+E2_XMULTA+E2_XTARIFA+E2_XVARCAM)-(E2_XVARDES+E2_XDESC)))),IIF(SE2->E2_PREFIXO$"EIC|EEC|THO",IIF(Rtrim(SA2->A2_EST)=="EX",0,SE5->E5_VALOR),SE2->(E2_VLCRUZ))))))
	ElseIf cLP = "530" .And. cSeq = "008" .And. cTipo = "D"

		DbSelectArea("CTT")
		DbSetOrder(1)
		If DbSeek(xFilial("CTT")+SE2->E2_CCD) .And. (Rtrim(SE2->E2_PREFIXO)<>"CMA" .And. Rtrim(SE2->E2_PREFIXO)<>"PA" .And. Rtrim(SE2->E2_PREFIXO)<>"EIC" .And. Rtrim(SE2->E2_PREFIXO)<>"THO" )
			If CTT->CTT_REFCTA=="1"
				xRet := SED->ED_XADM
			Elseif CTT->CTT_REFCTA=="2"
				xRet :=  SED->ED_XVEND
			ElseIf CTT->CTT_REFCTA$"3|4"
				xRet :=  SED->ED_XCUST
			else
				xRet := If(SE2->E2_TIPO="PA",SA6->A6_CONTA,If(Rtrim(SE2->E2_PREFIXO)$"EIC|THO",IIf(AllTrim(SE2->E2_FORNECE)$"021305|006156|013003|012158|UNIAO|ESTADO|",115001001,113001035),If(!Empty(SA2->A2_CONTA),SA2->A2_CONTA,If(SE2->E2_PREFIXO="CMA".AND.SE2->E2_NATUREZ="25001",210130010,If(SE2->E2_TIPO=="TX ".AND.ALLTRIM(SE2->E2_NATUREZ)$"PIS/COFINS/CSLL",210120045,If(!EMPTY(SE2->E2_CONTAD),SED->ED_CONTA,SED->ED_CONTA))))))
			Endif
		else
			xRet := If(SE2->E2_TIPO="PA",SA6->A6_CONTA,If(Rtrim(SE2->E2_PREFIXO)$"EIC|THO",IIf(AllTrim(SE2->E2_FORNECE)$"021305|006156|013003|012158|UNIAO|ESTADO|",115001001,113001035),If(!Empty(SA2->A2_CONTA),SA2->A2_CONTA,If(SE2->E2_PREFIXO="CMA".AND.SE2->E2_NATUREZ="25001",210130010,If(SE2->E2_TIPO=="TX ".AND.ALLTRIM(SE2->E2_NATUREZ)$"PIS/COFINS/CSLL",210120045,If(!EMPTY(SE2->E2_CONTAD),SED->ED_CONTA,SED->ED_CONTA))))))
		Endif

	ElseIf cLP = "510" .And. cSeq = "001" .And. cTipo = "D"

		DbSelectArea("CTT")
		DbSetOrder(1)
		If DbSeek(xFilial("CTT")+SE2->E2_CCD) .And. (Rtrim(SE2->E2_PREFIXO)=="CMA")
			If CTT->CTT_REFCTA=="1"
				xRet := SED->ED_XADM
			Elseif CTT->CTT_REFCTA=="2"
				xRet :=  SED->ED_XVEND
			ElseIf CTT->CTT_REFCTA$"3|4"
				xRet :=  SED->ED_XCUST
			else
				xRet :=IIF(ALLTRIM(SE2->E2_PREFIXO)$"EIC|THO",SED->ED_CONTA,IIF(ALLTRIM(SE2->E2_NATUREZ)=="24002","511020001",IIF(ALLTRIM(SE2->E2_NATUREZ)$"24029/24030","410110001",SED->ED_CONTA)))
			Endif
		else
			xRet := IIF(ALLTRIM(SE2->E2_PREFIXO)$"EIC|THO",SED->ED_CONTA,IIF(ALLTRIM(SE2->E2_NATUREZ)=="24002","511020001",IIF(ALLTRIM(SE2->E2_NATUREZ)$"24029/24030","410110001",SED->ED_CONTA)))
		Endif


	ElseIf cLP = "532" .And. cSeq = "008" .And. cTipo = "D"

		DbSelectArea("CTT")
		DbSetOrder(1)
		If DbSeek(xFilial("CTT")+SE2->E2_CCD) .And. (Rtrim(SE2->E2_PREFIXO)<>"CMA" .And. Rtrim(SE2->E2_PREFIXO)<>"PA" .And. Rtrim(SE2->E2_PREFIXO)<>"EIC" .And. Rtrim(SE2->E2_PREFIXO)<>"THO" )
			If CTT->CTT_REFCTA=="1"
				xRet := SED->ED_XADM
			Elseif CTT->CTT_REFCTA=="2"
				xRet :=  SED->ED_XVEND
			ElseIf CTT->CTT_REFCTA$"3|4"
				xRet :=  SED->ED_XCUST
			else
				xRet := If(SE2->E2_TIPO="PA",SA6->A6_CONTA,If(Rtrim(SE2->E2_PREFIXO)$"EIC|THO",IIf(AllTrim(SE2->E2_FORNECE)$"021305|006156|013003|012158|UNIAO|ESTADO|",115001001,113001035),If(!Empty(SA2->A2_CONTA) .And. Rtrim(SE2->E2_PREFIXO)<>"GPE",SA2->A2_CONTA,If(SE2->E2_PREFIXO="CMA".AND.SE2->E2_NATUREZ="25001",210130010,If(SE2->E2_TIPO=="TX ".AND.ALLTRIM(SE2->E2_NATUREZ)$"PIS/COFINS/CSLL",210120045,If(!EMPTY(SE2->E2_CONTAD),SED->ED_CONTA,SED->ED_CONTA))))))
			Endif
		else
			xRet := If(SE2->E2_TIPO="PA",SA6->A6_CONTA,If(Rtrim(SE2->E2_PREFIXO)$"EIC|THO",IIf(AllTrim(SE2->E2_FORNECE)$"021305|006156|013003|012158|UNIAO|ESTADO|",115001001,113001035),If(!Empty(SA2->A2_CONTA) .And. Rtrim(SE2->E2_PREFIXO)<>"GPE",SA2->A2_CONTA,If(SE2->E2_PREFIXO="CMA".AND.SE2->E2_NATUREZ="25001",210130010,If(SE2->E2_TIPO=="TX ".AND.ALLTRIM(SE2->E2_NATUREZ)$"PIS/COFINS/CSLL",210120045,If(!EMPTY(SE2->E2_CONTAD),SED->ED_CONTA,SED->ED_CONTA))))))
		Endif


	ElseIf cLP = "532" .And. cSeq = "008" .And. cTipo = "CCD"

		xRet := 0
		cAlias := "QRYRC1"

		If Rtrim(SE2->E2_PREFIXO)=="GPE"

			aArea := RC1->(GetArea())

			cQuery	:=	" SELECT RC1.RC1_CC AS CC "
			cQuery	+=	" FROM "+RetSqlName("RC1")+" RC1 "
			cQuery	+=	" WHERE RC1.RC1_FILCEN='"+SE2->E2_FILIAL+"' AND RC1.RC1_NUMTIT = '"+SE2->E2_NUM+"' AND  "
			cQuery	+=	"       RC1.RC1_FORNEC = '"+SE2->E2_FORNECE+"'  AND RC1.RC1_LOJA='"+SE2->E2_LOJA+"' AND RC1.D_E_L_E_T_= ' '   "

			cQuery	:= ChangeQuery(cQuery)

			If !Empty(Select(cAlias))
				DbSelectArea(cAlias)
				(cAlias)->(dbCloseArea())
			Endif

			dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),cAlias, .T., .T.)

			dbSelectArea(cAlias)
			(cAlias)->(DbGoTop())

			If !Empty(Select(cAlias))
				xRet := 	(cAlias)->CC
				(cAlias)->(dbCloseArea())
			EndIf

			If Empty(xRet )
				xRet:= "113101"
			Endif

			RestArea(aArea)

		Else
			xRet  := IIF(SE2->E2_NATUREZ=="24023",114105,IIF(SE2->E2_NATUREZ$"25501/25502/25503/25504/25505"," ",IIF(SE2->E2_NATUREZ=="22510",113101, SE2->E2_CCD)))
		Endif

		If SubStr(If(SE2->E2_TIPO="PA",SA6->A6_CONTA,If(Rtrim(SE2->E2_PREFIXO)$"EIC|THO",IIf(AllTrim(SE2->E2_FORNECE)$"021305|006156|013003|012158|UNIAO|ESTADO|","115001001","113001035"),If(!Empty(SA2->A2_CONTA),SA2->A2_CONTA,If(SE2->E2_PREFIXO="CMA".AND.SE2->E2_NATUREZ="25001","210130010",If(SE2->E2_TIPO=="TX ".AND.ALLTRIM(SE2->E2_NATUREZ)$"PIS/COFINS/CSLL","210120045",If(!EMPTY(SE2->E2_CONTAD),SE2->E2_CONTAD,SED->ED_CONTA)))))),1,1)$"1|2" .And. Rtrim(SE2->E2_PREFIXO)=="CMA"
			xRet := ""
		Endif


	ElseIf cLP = "522" .And. cSeq = "002" .And. cTipo = "V"

		cAlias := "QRYSE5"

		xRet := 0

		If SE5->E5_MOTBX = "TIT"

			aArea := SE5->(GetArea())

			cQuery	:=	" SELECT E5_VLDESCO "
			cQuery	+=	" FROM "+RetSqlName("SE5")
			cQuery	+=	" WHERE E5_FILIAL = '"+xFilial("SE5")+"' AND E5_TIPODOC = 'TR' AND E5_PREFIXO = '"+SE1->E1_PREFIXO+"' AND E5_NUMERO = '"+SE1->E1_NUM+"'  "
			cQuery	+=	" AND E5_PARCELA = '"+SE1->E1_PARCELA+"' AND E5_TIPO = '"+SE1->E1_TIPO+"' AND E5_SITUACA = ' ' AND "+RetSqlName("SE5")+".D_E_L_E_T_= ' ' "

			cQuery	:= ChangeQuery(cQuery)

			If !Empty(Select(cAlias))
				DbSelectArea(cAlias)
				(cAlias)->(dbCloseArea())
			Endif

			dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),cAlias, .T., .T.)

			dbSelectArea(cAlias)
			(cAlias)->(DbGoTop())

			If !Empty(Select(cAlias))
				xRet := 	(cAlias)->E5_VLDESCO
				(cAlias)->(dbCloseArea())
			EndIf

			RestArea(aArea)

		EndIf

	ElseIf cLP = "666" .And. cSeq = "001" .And. cTipo = "D"

		If !Empty(SD3->D3_OP)
			xRet := 114001010
		Else
			dbSelectArea("CTT")
			CTT->(dbSetOrder(1))
			CTT->(dbSeek(xFilial("CTT")+SD3->D3_CC))

			dbSelectArea("SBM")
			SBM->(dbSetOrder(1))
			SBM->(dbSeek(xFilial("SBM")+SB1->B1_GRUPO))

			If CTT->CTT_REFCTA = "1" .And. !Empty(SBM->BM_XCTA1)
				xRet := SBM->BM_XCTA1
			ElseIf CTT->CTT_REFCTA = "2" .And. !Empty(SBM->BM_XCTA2)
				xRet := SBM->BM_XCTA2
			ElseIf CTT->CTT_REFCTA $ "3,4" .And. !Empty(SBM->BM_XCTA3)
				xRet := SBM->BM_XCTA3
			ElseIf CTT->CTT_REFCTA = "5" .And. !Empty(SBM->BM_XCTA4)
				xRet := SBM->BM_XCTA4
			ElseIf !Empty(SD3->D3_CC)

				dbSelectArea("CTT")
				dbSetOrder(1)
				dbSeek(xFilial("CTT") + SD3->D3_CC)

				dbSelectArea("SB1")
				SB1->(dbSetOrder(1))
				SB1->(dbSeek(xFilial("SB1")+SD3->D3_COD))

				If CTT->CTT_REFCTA == "2" .And. !Empty(SB1->B1_XCONTA1) //Vendas
					xRet :=  SB1->B1_XCONTA1
				ElseIf CTT->CTT_REFCTA == "5" .And. !Empty(SB1->B1_XCONTA3) //Ativo
					xRet := SB1->B1_XCONTA3
				ElseIf CTT->CTT_REFCTA $ "3,4" .And. !Empty(SB1->B1_XCONTA2) //Custo
					xRet := SB1->B1_XCONTA2
				Else
					xRet := "511030040"
				EndIf
			ElseIf RTrim(SD3->D3_FILIAL) =="05"
				xRet := 510101001
			ElseIf SM0->M0_CODIGO=="11" .And. RTrim(SD3->D3_FILIAL) =="01" .And. RTrim(SB1->B1_ORIGEM)=="1"
				xRet := 510101005
			Else
				xRet := 510101001
			EndIf
		EndIf

	ElseIf cLP = "668" .And. cSeq = "001" .And. cTipo = "C"

		If !Empty(SD3->D3_OP)
			xRet := 114001010
		Else
			dbSelectArea("CTT")
			CTT->(dbSetOrder(1))
			CTT->(dbSeek(xFilial("CTT")+SD3->D3_CC))

			dbSelectArea("SBM")
			SBM->(dbSetOrder(1))
			SBM->(dbSeek(xFilial("SBM")+SB1->B1_GRUPO))

			If CTT->CTT_REFCTA = "1" .And. !Empty(SBM->BM_XCTA1)
				xRet := SBM->BM_XCTA1
			ElseIf CTT->CTT_REFCTA = "2" .And. !Empty(SBM->BM_XCTA2)
				xRet := SBM->BM_XCTA2
			ElseIf CTT->CTT_REFCTA $ "3,4" .And. !Empty(SBM->BM_XCTA3)
				xRet := SBM->BM_XCTA3
			ElseIf CTT->CTT_REFCTA = "5" .And. !Empty(SBM->BM_XCTA4)
				xRet := SBM->BM_XCTA4
			ElseIf !Empty(SD3->D3_CC)
				dbSelectArea("CTT")
				dbSetOrder(1)
				dbSeek(xFilial("CTT") + SD3->D3_CC)

				dbSelectArea("SB1")
				SB1->(dbSetOrder(1))
				SB1->(dbSeek(xFilial("SB1")+SD3->D3_COD))

				If CTT->CTT_REFCTA == "2" .And. !Empty(SB1->B1_XCONTA1) //Vendas
					xRet :=  SB1->B1_XCONTA1
				ElseIf CTT->CTT_REFCTA == "5" .And. !Empty(SB1->B1_XCONTA3) //Ativo
					xRet := SB1->B1_XCONTA3
				ElseIf CTT->CTT_REFCTA $ "3,4" .And. !Empty(SB1->B1_XCONTA2) //Custo
					xRet := SB1->B1_XCONTA2
				Else
					xRet := "511030040"
				EndIf
			ElseIf RTrim(SD3->D3_FILIAL) =="05"
				xRet := 510101001
			ElseIf SM0->M0_CODIGO=="11" .And. RTrim(SD3->D3_FILIAL) =="01" .And. RTrim(SB1->B1_ORIGEM)=="1"
				xRet := 510101005
			Else
				xRet := 510101001
			EndIf
		EndIf

	ElseIf cLP = "674" .And. cSeq = "001" .And. cTipo = "D"

		If RTrim(SD3->D3_FILIAL) =="05"
			xRet := 510101001
		ElseIf SM0->M0_CODIGO=="11" .And. RTrim(SD3->D3_FILIAL) =="01" .And. RTrim(SB1->B1_ORIGEM)=="1"
			xRet := 510101005
		Else
			xRet := 510101001
		EndIf

	ElseIf cLP = "676" .And. cSeq = "001" .And. cTipo = "C"

		If RTrim(SD3->D3_FILIAL) =="05"
			xRet := 510101001
		ElseIf SM0->M0_CODIGO=="11" .And. RTrim(SD3->D3_FILIAL) =="01" .And. RTrim(SB1->B1_ORIGEM)=="1"
			xRet := 510101005
		Else
			xRet := 510101001
		EndIf

	ElseIf cLP = "678" .And. cSeq = "001" .And. cTipo = "D"

		cCf	:= Substr(AllTrim(SD2->D2_CF),2,3)
		xRet	:= 510101001

		If cCf $"102/108/110/117/123/403"
			xRet := 510101005
		Else
			xRet := 510101001
		EndIf

		//Processo IG/OG
		xRet:= u_CTBIGOG(xRet)

	ElseIf cLP = "597" .And. cSeq = "001" .And. cTipo = "D"

		aArea := SE2->(GetArea())
		aArea2 := SA2->(GetArea())

		If SE2->E2_TIPO="PA" .And. !Empty(SE5->E5_FORNADT)
			DbSelectArea("SA2")
			SA2->(DbSetOrder(1))
			If SA2->(!DbSeek(xFilial("SA2")+SE5->(E5_FORNADT+E5_LOJAADT)))
				RestArea(aArea2)
			EndIf
		EndIf

		If Rtrim(SE2->E2_PREFIXO)$"EIC|THO" .And. SE5->E5_FORNADT==SE5->E5_FORNECE
			xRet:= 210130030
		ElseIf Rtrim(SE2->E2_PREFIXO)$"EIC|THO" .And. RTrim(SE5->E5_FORNADT)<> RTrim(SE5->E5_FORNECE)
			xRet:= 210101005
		ElseIf Rtrim(SE2->E2_PREFIXO)$"EIC|THO".AND.SE2->E2_TIPO<>"PA"
			xRet:= 511030071
		ElseIf SED->ED_CODIGO="24002"
			xRet:= 210130010
		ElseIf ALLTRIM(SED->ED_CODIGO)$"20101/20111/20506"
			xRet:= 410130030
		ElseIf SED->ED_CODIGO="30501"
			xRet:= 110110001
		ElseIf !EMPTY(SA2->A2_CONTA)
			xRet:= SA2->A2_CONTA
		ElseIf SA2->A2_EST=="EX"
			xRet:= 210101010
		ElseIf RTRIM(SE5->E5_MOTBX)$"CMP/FAT" .And. SE5->E5_FORNECE=="006156"
			xRet:= 210130030
		ElseIf 	ALLTRIM(SED->ED_CODIGO)$"24022/24022A/24023/24023A"
			xRet:= 210130030
		Else
			xRet:= 210101005
		EndIf


		If !Empty(SE2->E2_CCD) .And. !SubStr(cValTochar(xRet),1,1)$"1|2"

			DbSelectArea("CTT")
			DbSetOrder(1)
			If DbSeek(xFilial("CTT")+SE2->E2_CCD)
				If CTT->CTT_REFCTA=="1"
					xRet := SED->ED_XADM
				Elseif CTT->CTT_REFCTA=="2"
					xRet :=  SED->ED_XVEND
				ElseIf CTT->CTT_REFCTA$"3|4"
					xRet :=  SED->ED_XCUST
				Endif
			Endif

		Endif

		RestArea(aArea)
		RestArea(aArea2)

	ElseIf cLP = "597" .And. cSeq = "001" .And. cTipo = "ITD"
		xRet :=IIF(U_CTBBRAIT(U_CTBSTECK("597","001","D")),IIF(SUBSTR(SE5->E5_DOCUMEN,1,3)$"EIC|THO","2"+If(SE5->E5_TIPO="PA",SUBS(SE5->E5_DOCUMEN,19,8),ALLTRIM(SE5->E5_CLIFOR)+ALLTRIM(SE5->E5_LOJA)),IIF(ALLTRIM(SED->ED_CODIGO)$"20101/20111/20506".OR.SE2->E2_PREFIXO$"EIC|THO".AND.SE2->E2_TIPO<>"PA".OR.SUBSTR(SE5->E5_DOCUMEN,1,3)$"EIC|THO","","2"+If(SE5->E5_TIPO="PA",SUBS(SE5->E5_DOCUMEN,19,8),ALLTRIM(SE5->E5_CLIFOR)+ALLTRIM(SE5->E5_LOJA)))),"")
	ElseIf cLP = "597" .And. cSeq = "005" .And. cTipo = "ITC"
		xRet :=IIF(U_CTBBRAIT(U_CTBSTECK("597","005","C")),IIF(SUBSTR(SE5->E5_DOCUMEN,1,3)$"EIC|THO","2"+If(SE5->E5_TIPO="PA",SUBS(SE5->E5_DOCUMEN,19,8),ALLTRIM(SE5->E5_CLIFOR)+ALLTRIM(SE5->E5_LOJA)),IIF(ALLTRIM(SED->ED_CODIGO)$"20101/20111/20506".OR.SE2->E2_PREFIXO$"EIC|THO".AND.SE2->E2_TIPO<>"PA".OR.SUBSTR(SE5->E5_DOCUMEN,1,3)$"EIC|THO"," ","2"+If(SE5->E5_TIPO="PA",SUBS(SE5->E5_DOCUMEN,19,8),ALLTRIM(SE5->E5_FORNADT)+ALLTRIM(SE5->E5_LOJAADT)))),"")
	ElseIf cLP = "597" .And. cSeq = "005" .And. cTipo = "C"
		If Rtrim(SE5->E5_TIPO)=="NDF" .Or. SubStr(SE5->E5_DOCUMEN,16,3)=="NDF"

			If Select("TE5") > 0
				DbSelectArea("TE5")
				DbCloSeArea()
			Endif

			_cQryE5 := " SELECT                                                       "
			_cQryE5 += "        SED.ED_CONTA  AS CONTA,SE5.E5_TIPO AS TIPO                                "
			_cQryE5 += " FROM "+RetSqlName("SE5")+" SE5 ,"+RetSqlName("SED")+" SED    "
			_cQryE5 += " WHERE SE5.E5_FILIAL ='"+xFilial("SE5")+"'                AND "
			_cQryE5 += "       SE5.D_E_L_E_T_ <> '*'                              AND "
			_cQryE5 += "       SE5.E5_TIPO    = '"+SUBSTR(SE5->E5_DOCUMEN,16,3)+"' AND "
			_cQryE5 += "       SE5.E5_NUMERO  ='"+SUBSTR(SE5->E5_DOCUMEN,4,9)+"'  AND "
			_cQryE5 += "       SE5.E5_FORNADT ='"+SE5->E5_FORNECE+"'              AND "
			_cQryE5 += "       SE5.E5_LOJAADT   ='"+SE5->E5_LOJA+"'                 AND "
			_cQryE5 += "       SE5.E5_MOTBX   = '"+SE5->E5_MOTBX+"'               AND "
			_cQryE5 += "       SED.ED_CODIGO  = SE5.E5_NATUREZ                    AND "
			_cQryE5 += "       SED.D_E_L_E_T_ <>'*'                                   "



			TCQUERY _cQryE5 NEW ALIAS "TE5"

			_nRec :=0
			DbEval({|| _nRec++ })

			DbSelectArea("TE5")
			DbGotop()


			xRet := TE5->CONTA

			If Empty(xRet)
				xRet:= "113001030"
			Endif



		ElseIf RTRIM(SE5->E5_MOTBX)="CMP" .And. ( RTRIM(SE5->E5_TIPO)="NF" .oR. SUBSTR(SE5->E5_DOCUMEN,1,2)=="PA") .And. Rtrim(SE5->E5_PREFIXO)<> "THO" .And. SubStr(SE5->E5_DOCUMEN,1,3)<>"THO"
			If Select("TE5") > 0
				DbSelectArea("TE5")
				DbCloSeArea()
			Endif

			_cQryE5 := " SELECT                                                       "
			_cQryE5 += "        SED.ED_CONTA  AS CONTA,SE5.E5_TIPO AS TIPO                                "
			_cQryE5 += " FROM "+RetSqlName("SE5")+" SE5 ,"+RetSqlName("SED")+" SED    "
			_cQryE5 += " WHERE SE5.E5_FILIAL ='"+xFilial("SE5")+"'                AND "
			_cQryE5 += "       SE5.D_E_L_E_T_ <> '*'                              AND "
			_cQryE5 += "       SE5.E5_TIPO    = '"+SUBSTR(SE5->E5_DOCUMEN,16,3)+"' AND "
			_cQryE5 += "       SE5.E5_NUMERO  ='"+SUBSTR(SE5->E5_DOCUMEN,4,9)+"'  AND "
			_cQryE5 += "       SE5.E5_FORNADT ='"+SE5->E5_FORNECE+"'              AND "
			_cQryE5 += "       SE5.E5_LOJAADT   ='"+SE5->E5_LOJA+"'                 AND "
			_cQryE5 += "       SE5.E5_MOTBX   = '"+SE5->E5_MOTBX+"'               AND "
			_cQryE5 += "       SED.ED_CODIGO  = SE5.E5_NATUREZ                    AND "
			_cQryE5 += "       SED.D_E_L_E_T_ <>'*'                                   "



			TCQUERY _cQryE5 NEW ALIAS "TE5"

			_nRec :=0
			DbEval({|| _nRec++ })

			DbSelectArea("TE5")
			DbGotop()

			If Rtrim(TE5->TIPO)=="NDF"
				xRet := "113001030"
			ElseIf  Rtrim(SE5->E5_PREFIXO)=="EIC|THO"
				xRet:= IIF(SE5->E5_PREFIXO="EIC|THO" .OR. SUBSTR(SE5->E5_DOCUMEN,1,3)="EIC|THO",115001001,IIF(SED->ED_CODIGO="24002","120101015",IF(SED->ED_CODIGO="30501","113001025",IF(SE2->E2_TIPO$"NDF/PA ",IF(SA2->A2_EST=="EX",113001035,SED->ED_CONTA),SED->ED_CONTA))))
			ElseIf !Empty(TE5->CONTA )
				xRet := TE5->CONTA
			ElseIf !Empty(SED->ED_CONTA)
				xRet := SED->ED_CONTA
			Else
				xRet := "113001030"
			Endif
		Else
			xRet:= IIF(Rtrim(SE5->E5_PREFIXO)$"EIC|THO" .OR. SUBSTR(SE5->E5_DOCUMEN,1,3)$"EIC|THO",115001001,IIF(SED->ED_CODIGO="24002","120101015",IF(SED->ED_CODIGO="30501","113001025",IF(SE2->E2_TIPO$"NDF/PA ",IF(SA2->A2_EST=="EX",113001035,SED->ED_CONTA),SED->ED_CONTA))))
		Endif

	ElseIf cLP = "596" .And. cSeq = "001" .And. cTipo = "C"

		aArea := SE1->(GetArea())

		DbSelectArea("SE1")
		DbSetOrder(1)
		If DbSeek(SE5->E5_FILIAL+SubStr(SE5->E5_DOCUMEN,1,12)) .And. SubStr(SE5->E5_DOCUMEN,1,3) == "FIN"
			If AllTrim(SE1->E1_NATUREZ)$"10116"
				xRet:= 322001035
			Else
				xRet:= IF(SA1->A1_CONTA<>" ",Val(SA1->A1_CONTA),111001001)
			Endif
		Else
			xRet:= IF(SA1->A1_CONTA<>" ",Val(SA1->A1_CONTA),111001001)
		Endif

		RestArea(aArea)

	ElseIf cLP = "532" .And. cSeq = "001" .And. cTipo = "C"

		cQuery := " SELECT E5_BANCO AS BANCO,E5_AGENCIA AS AGENCIA ,E5_CONTA AS NUMCON, A6_CONTA AS CONTACONT "
		cQuery += " FROM "+RetSqlName("SE5")+" SE5 "
		cQuery += " INNER JOIN "+RetSqlName("SA6")+" SA6 "
		cQuery += " ON SA6.D_E_L_E_T_ = ' ' "
		cQuery += " AND A6_FILIAL     = '"+xFilial("SA6")+"'
		cQuery += " AND A6_COD        = E5_BANCO "
		cQuery += " AND A6_AGENCIA    = E5_AGENCIA "
		cQuery += " AND A6_NUMCON     = E5_CONTA "
		cQuery += " WHERE "
		cQuery += " SE5.E5_FILIAL  = '"+SE5->E5_FILIAL+"' AND "
		cQuery += " SE5.E5_LOTE = '"+Rtrim(SE5->E5_LOTE)+"' AND "
		cQuery += " SE5.E5_BANCO <> '   '               AND "
		cQuery += " SE5.E5_RECPAG  = 'P' AND "
		cQuery += " SE5.D_E_L_E_T_ = ' ' "

		cAlias := GetNextAlias()

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Fecha Alias se estiver em Uso ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !Empty(Select(cAlias))
			DbSelectArea(cAlias)
			(cAlias)->(dbCloseArea())
		Endif

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Monta Area de Trabalho executando a Query ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),cAlias,.T.,.T.)

		DbSelectArea(cAlias)
		(cAlias)->(dbGoTop())
		If !(cAlias)->(Eof())
			xRet := (cAlias)->CONTACONT
		Endif

		If Empty(xRet)
			xRet := IIF(SE5->E5_MOTBX=="FIN","220101001",SA6->A6_CONTA)
		Endif

		If !Empty(Select(cAlias))
			DbSelectArea(cAlias)
			(cAlias)->(dbCloseArea())
		Endif

	ElseIf cLP = "532" .And. cSeq = "001" .And. cTipo = "V"


		cAlias := "QRYSE5"

		xRet   := 0
		_cQry  := ""

		If !Empty(SE5->E5_LOTE) .And. (SE5->E5_X_AG<>"S"  .Or. (RTRIM(SE5->E5_TIPO)="FOL" .And. SE5->E5_X_AG<>"S") )

			aArea := SE5->(GetArea())

			If RTRIM(SE5->E5_TIPO)="FOL"

				cQuery	:=	" SELECT SUM(E5_VALOR) AS VALORLT "
				cQuery	+=	" FROM "+RetSqlName("SE5")+" SE5 "
				cQuery	+=	" WHERE E5_FILIAL = '"+xFilial("SE5")+"' AND E5_LOTE = '"+SE5->E5_LOTE+"' AND E5_TIPODOC='BA' AND E5_DATA = '"+Dtos(SE5->E5_DATA)+"' AND RTRIM(E5_DOCUMEN) = '"+RTRIM(SE5->E5_DOCUMEN)+"' AND E5_NUMERO = '"+SE5->E5_NUMERO+"' AND E5_PREFIXO = '"+SE5->E5_PREFIXO+"'     "
				cQuery	+=	" AND D_E_L_E_T_= ' ' "
			Else
				cQuery	:=	" SELECT SUM(E5_VALOR) AS VALORLT "
				cQuery	+=	" FROM "+RetSqlName("SE5")+" SE5 "
				cQuery	+=	" WHERE E5_FILIAL = '"+xFilial("SE5")+"' AND E5_LOTE = '"+SE5->E5_LOTE+"' AND E5_TIPODOC='BA' AND E5_DATA = '"+Dtos(SE5->E5_DATA)+"' AND RTRIM(E5_DOCUMEN) = '"+RTRIM(SE5->E5_DOCUMEN)+"'    "
				cQuery	+=	" AND D_E_L_E_T_= ' ' "
			Endif

			cQuery	:= ChangeQuery(cQuery)

			If !Empty(Select(cAlias))
				DbSelectArea(cAlias)
				(cAlias)->(dbCloseArea())
			Endif

			dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),cAlias, .T., .T.)

			dbSelectArea(cAlias)
			(cAlias)->(DbGoTop())

			If !Empty(Select(cAlias))
				xRet := 	(cAlias)->VALORLT
				(cAlias)->(dbCloseArea())
			EndIf

			RestArea(aArea)

			_cQry := " UPDATE "+RetSqlName("SE5")+"  SE5 SET E5_X_AG = 'S' WHERE E5_FILIAL ='"+xFilial("SE5")+"' AND E5_LOTE='"+SE5->E5_LOTE+"' AND E5_NATUREZ<>'NATMOVP' AND  E5_DATA='"+Dtos(SE5->E5_DATA)+"' AND D_E_L_E_T_ <> '*' AND RTRIM(E5_DOCUMEN) = '"+RTRIM(SE5->E5_DOCUMEN)+"'   "
			TcSQLExec(_cQry)


		EndIf

	ElseIf cLP = "532" .And. cSeq = "010" .And. cTipo = "V"


		If Select("TSE2") > 0
			DbSelectArea("TSE2")
			DbCloSeArea()
		Endif

		_cQryE2 := " SELECT                    "
		_cQryE2 += "        SUM(SE2.E2_VALOR)  AS VALOR                   "
		_cQryE2 += " FROM "+RetSqlName("SE2")+" SE2                  "
		_cQryE2 += " WHERE  "
		_cQryE2 += "       SE2.D_E_L_E_T_ <> '*'                 AND "
		_cQryE2 += "       SE2.E2_FATURA     ='"+SE2->E2_NUM+"'  AND  "
		_cQryE2 += "       SE2.E2_PREFIXO<>'GPE'                       "


		TCQUERY _cQryE2 NEW ALIAS "TSE2"

		_nRec :=0
		DbEval({|| _nRec++ })

		DbSelectArea("TSE2")
		DbGotop()

		xRet :=TSE2->VALOR

	EndIf

Return(xRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ STCCPRD  ºAutor  ³Microsiga           º Data ³  06/12/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função para carregar a conta específica do produto         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Steck                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function STCCPRD()

	Local cRet := IIF(!Empty(SD1->D1_CONTA),SD1->D1_CONTA,SB1->B1_CONTA)


	If !Empty(SD1->D1_CC)
		dbSelectArea("CTT")
		dbSetOrder(1)
		dbSeek(xFilial("CTT") + SD1->D1_CC)
		If CTT->CTT_REFCTA = "2" .And. !Empty(SB1->B1_XCONTA1) //Vendas
			cRet := SB1->B1_XCONTA1
		ElseIf CTT->CTT_REFCTA = "5" .And. !Empty(SB1->B1_XCONTA3) //Ativo
			cRet := SB1->B1_XCONTA3
		ElseIf CTT->CTT_REFCTA $ "3,4" .And. !Empty(SB1->B1_XCONTA2) //Custo
			cRet := SB1->B1_XCONTA2
		EndIf

		If SB1->B1_COD = "U" .And. !Substr(AllTrim(SD1->D1_CF),2,3)$"406/551" .And. !Empty(SB1->B1_GRUPO)

			dbSelectArea("SBM")
			SBM->(dbSetOrder(1))
			SBM->(dbSeek(xFilial("SBM")+SB1->B1_GRUPO))

			If CTT->CTT_REFCTA = "1"
				xRet := SBM->BM_XCTA1
			ElseIf CTT->CTT_REFCTA = "2"
				xRet := SBM->BM_XCTA2
			ElseIf CTT->CTT_REFCTA $ "3,4"
				xRet := SBM->BM_XCTA3
			ElseIf CTT->CTT_REFCTA = "5"
				xRet := SBM->BM_XCTA4
			EndIf

		EndIf

	EndIf


Return(cRet)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ STVLDEV  ºAutor  ³Microsiga           º Data ³  06/12/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função de usuário para identificar as devoluções retornandoº±±
±±º          ³ .T. ou .F.                                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Steck                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function STVLDEV(cCF)

	Local lRet	:= .F.

	If Substr(AllTrim(cCF),1,1) $ "1/2/3" .And. Substr(AllTrim(cCF),2,3) $ "200,201,202,203,204,410,411,553"
		lRet	:= .T.
	ElseIf Substr(AllTrim(cCF),1,1) $ "5/6/7" .And. Substr(AllTrim(cCF),2,3) $ "201,202,208,209,210,211,410,411,412,413,503,553,555,556,660,661,662,908,919,921"
		lRet	:= .T.
	EndIf

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ STVLIMP  ºAutor  ³Microsiga           º Data ³  06/12/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função de usuário para contabilizar a reclassificação de   º±±
±±º          ³ valores da conta de adiantamento de importação para segurosº±±
±±º          ³ e fornecedores                                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Steck                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function STVLIMP(cTP)

	Local	nSeguro		:= 0
	Local	nTaxa		:= 0
	Local	nTotal		:= 0
	Local	nValor		:= 0
	Local	cAlias 		:= "SWNQRY"
	Local	cQuery		:= ""

	If !Empty(SF1->F1_HAWB) .AND. SF1->F1_TIPO <> "C"

		dbSelectArea("SW6")
		dbSetOrder(1)
		dbSeek(xFilial("SW6") + SF1->F1_HAWB)

		nSeguro	:=	SW6->W6_VLSEGMN
		nTaxa	:=	SW6->W6_TX_US_D
		nTotal	:=	SW6->W6_VLMLEMN

		cQuery	+=	" SELECT SUM(W7_QTDE*W7_PRECO) W7_VALOR FROM "+RetSqlName("SWN")
		cQuery	+= 	" LEFT JOIN "+RetSqlName("SW7")+" ON WN_FILIAL = W7_FILIAL AND  WN_HAWB = W7_HAWB AND WN_PO_NUM = W7_PO_NUM "
		cQuery	+=	" AND WN_ITEM = W7_POSICAO AND WN_PRODUTO = W7_COD_I AND "+RetSqlName("SW7")+".D_E_L_E_T_= ' ' "
		cQuery	+=	" WHERE WN_FILIAL = '"+SF1->F1_FILIAL+"' AND WN_DOC = '"+SF1->F1_DOC+"' AND WN_SERIE = '"+SF1->F1_SERIE+"' "
		cQuery	+=	" AND WN_FORNECE = '"+SF1->F1_FORNECE+"' AND WN_LOJA = '"+SF1->F1_LOJA+"' AND "+RetSqlName("SWN")+".D_E_L_E_T_= ' ' "
		cQuery	+=	" GROUP BY WN_DOC "

		cQuery	:= ChangeQuery(cQuery)

		dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),cAlias, .F., .T.)

		dbSelectArea(cAlias)
		(cAlias)->(DbGoTop())

		If cTP = "1"
			nValor	:=	(cAlias)->W7_VALOR*nTaxa
		Else
			nValor	:=	nSeguro//(cAlias)->W7_VALOR*nTaxa/nTotal*nSeguro
		EndIf

		(cAlias)->(DbCLoseArea())

	EndIf

Return(nValor)

// Atualizado ate 08/10/2015
// Atualizado em 05.01.2017 (Ajuste na Query)Linha 39 -> 55
