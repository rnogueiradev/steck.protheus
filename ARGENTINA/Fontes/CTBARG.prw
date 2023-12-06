#Include "Protheus.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CTBARG    ºAutor  ³Microsiga           º Data ³  08/10/12   º±±
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

User Function CTBARG(cLP,cSeq,cTipo)

	Local xRet      :=''
	Local cQuery    :=''


	If cLP = "650" .And. cSeq = "001" .And. cTipo = "D"

		If SubStr(SD1->D1_COD,1,1)=="S" .Or. SubStr(SD1->D1_COD,1,1)=="E" .Or. SubStr(SD1->D1_COD,1,1)=="U"

			cQuery := " SELECT CQK.CQK_DEBITO AS DEBITO                  "
			cQuery += " FROM "+RetSqlName("CQK")+" CQK                   "
			cQuery += " WHERE CQK.CQK_FILIAL = '"+xFilial("CQK")+"'  AND "
			cQuery += "       CQK.D_E_L_E_T_ <>'*'                   AND "
			cQuery += "       CQK.CQK_XPROD='"+SD1->D1_COD+"'        AND "
			cQuery += "       CQK.CQK_CCD='"+SD1->D1_CC+"'               "

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
				xRet := (cAlias)->DEBITO
			Endif

			If Empty(xRet)
				xRet := SB1->B1_CONTA
			Endif

			If !Empty(Select(cAlias))
				DbSelectArea(cAlias)
				(cAlias)->(dbCloseArea())
			Endif

		Else
			xRet := SB1->B1_CONTA
		Endif

	ElseIf cLP = "650" .And. cSeq = "001" .And. cTipo = "VD"


		If (SubStr(SD1->D1_COD,1,1)=="S" .Or. SubStr(SD1->D1_COD,1,1)=="E" .Or. SubStr(SD1->D1_COD,1,1)=="U") .And. SB1->B1_X_RAT =="S"
			xRet := 0
		ElseIf SF1->F1_TXMOEDA>0 .And. SF1->F1_MOEDA<>1 .And. SD1->D1_QUANT==0
			xRet := 0
		ElseIf SF1->F1_TXMOEDA>0 .And. SF1->F1_MOEDA==1 .And. SD1->D1_QUANT==0
			xRet := 0	
		ElseIf SF1->F1_TXMOEDA>0 .And. SF1->F1_MOEDA<>1 .And. SD1->D1_QUANT>0
			xRet := SD1->(D1_TOTAL) * SF1->F1_TXMOEDA
		ElseIf SF1->F1_TXMOEDA>0 .And. SF1->F1_MOEDA==1 .And. SD1->D1_QUANT>0
			xRet := SD1->(D1_TOTAL) 
		Else
			xRet := SD1->(D1_TOTAL)
		Endif
	ElseIf cLP = "650" .And. cSeq = "010" .And. cTipo = "VC"

		If (SubStr(SD1->D1_COD,1,1)=="S" .Or. SubStr(SD1->D1_COD,1,1)=="E" .Or. SubStr(SD1->D1_COD,1,1)=="U") .And. SB1->B1_X_RAT =="S"
			xRet := 0
		ElseIf SF1->F1_TXMOEDA>0 .And. SF1->F1_MOEDA<>1  .And. SD1->D1_QUANT==0
			xRet := SD1->(D1_VALIMP1+D1_VALIMP2+D1_VALIMP3+D1_VALIMP4+D1_VALIMP5+D1_VALIMP6+D1_VALIMP9+D1_VALIMPC+D1_VALIMPZ)*SF1->F1_TXMOEDA

		ElseIf SF1->F1_TXMOEDA>0 .And. SF1->F1_MOEDA==1  .And. SD1->D1_QUANT==0
			xRet := SD1->(D1_VALIMP1+D1_VALIMP2+D1_VALIMP3+D1_VALIMP4+D1_VALIMP5+D1_VALIMP6+D1_VALIMP9+D1_VALIMPC+D1_VALIMPZ)
		

		ElseIf  SF1->F1_TXMOEDA>0 .And. SF1->F1_MOEDA<>1  .And. SD1->D1_QUANT>0
			If RTrim(SD1->D1_SERIREM)=='R'
				xRet :=  SD1->D1_TOTAL*SF1->F1_TXMOEDA
			Else
				If SD1->D1_RATEIO<>'1'
					xRet :=  SD1->(D1_TOTAL+D1_VALIMP1+D1_VALIMP2+D1_VALIMP3+D1_VALIMP4+D1_VALIMP5+D1_VALIMP6+D1_VALIMP7+D1_VALIMP9+D1_VALIMPC+D1_VALIMPZ)*SF1->F1_TXMOEDA
				Else
					xRet :=  SD1->(D1_VALIMP2+D1_VALIMP3+D1_VALIMP4+D1_VALIMP5+D1_VALIMP6+D1_VALIMP7+D1_VALIMP9+D1_VALIMPC+D1_VALIMPZ)*SF1->F1_TXMOEDA
				Endif
			Endif
		ElseIf  SF1->F1_TXMOEDA>0 .And. SF1->F1_MOEDA==1  .And. SD1->D1_QUANT>0
			If RTrim(SD1->D1_SERIREM)=='R'
				xRet :=  SD1->D1_TOTAL
			Else
				If SD1->D1_RATEIO<>'1'
					xRet :=  SD1->(D1_TOTAL+D1_VALIMP1+D1_VALIMP2+D1_VALIMP3+D1_VALIMP4+D1_VALIMP5+D1_VALIMP6+D1_VALIMP7+D1_VALIMP9+D1_VALIMPC+D1_VALIMPZ)*SF1->F1_TXMOEDA
				Else
					xRet :=  SD1->(D1_VALIMP2+D1_VALIMP3+D1_VALIMP4+D1_VALIMP5+D1_VALIMP6+D1_VALIMP7+D1_VALIMP9+D1_VALIMPC+D1_VALIMPZ)*SF1->F1_TXMOEDA
				Endif
			Endif
		Else
			If RTrim(SD1->D1_SERIREM)=='R'
				xRet :=  SD1->D1_TOTAL
			Else
				If SD1->D1_RATEIO<>'1'
					xRet :=  SD1->(D1_TOTAL+D1_VALIMP1+D1_VALIMP2+D1_VALIMP3+D1_VALIMP4+D1_VALIMP5+D1_VALIMP7+D1_VALIMP6+D1_VALIMPC+D1_VALIMPZ)
				Else
					xRet :=  SD1->(D1_VALIMP2+D1_VALIMP3+D1_VALIMP4+D1_VALIMP5+D1_VALIMP6+D1_VALIMP7+D1_VALIMP9+D1_VALIMPC+D1_VALIMPZ)*SF1->F1_TXMOEDA
				Endif
			Endif
		Endif
	ElseIf cLP = "610" .And. cSeq = "001" .And. cTipo = "D"
		xRet := SA1->A1_CONTA
	ElseIf cLP = "610" .And. cSeq = "001" .And. cTipo = "C"
		If SA1->A1_EST <> 'EX' .Or. SA1->A1_EST=="TF"
			xRet := "310101001"
		ElseIf  SA1->A1_EST == 'EX'
			xRet := "310101005"
		Endif
	ElseIf cLP = "610" .And. cSeq = "001" .And. cTipo = "VD"

		If LTrim(RTrim(cValToChar(SF2->F2_MOEDA))) = '1'
			xRet	:= SD2->(D2_TOTAL+D2_VALIMP1+D2_VALIMP2+D2_VALIMP3+D2_VALIMP4+D2_VALIMP5+D2_VALIMP6)
		Else
			xRet	:= SD2->(D2_TOTAL+D2_VALIMP1+D2_VALIMP2+D2_VALIMP3+D2_VALIMP4+D2_VALIMP5+D2_VALIMP6)*SF2->F2_TXMOEDA
		Endif

	ElseIf cLP = "610" .And. cSeq = "001" .And. cTipo = "VC"
	
	    If LTrim(RTrim(cValToChar(SF2->F2_MOEDA))) = '1'
			xRet	:= SD2->(D2_TOTAL)
		Else
			xRet	:= SD2->(D2_TOTAL)*SF2->F2_TXMOEDA
		Endif
		

		// Definição da Conta Contábil a Débito LP 610
	ElseIf cLP = "560" .And. cSeq = "001" .And. cTipo = "D"

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
		cQuery += " SE5.E5_PROCTRA = '"+SE5->E5_PROCTRA+"' AND "
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
	ElseIf cLP = "530" .And. cSeq = "001" .And. cTipo = "C"
	      xRet := IIF(RTRIM(SE5->E5_MOTBX)$"FAT",IIF(RTRIM(SE2->E2_PREFIXO)$"FIN/CMA",SED->ED_CONTA,IIF(!Empty(SE2->E2_CONTAD),SE2->E2_CONTAD,IIF(Rtrim(SE2->E2_TIPO)=="FOL",210110001,SA2->A2_CONTA))),IIF(Rtrim(SE5->E5_TIPO)="NCP",SA2->A2_CONTA,SA6->A6_CONTA))  
	ElseIf 	cLP = "530" .And. cSeq = "005" .And. cTipo = "D"
	      xRet := IIF(SE5->E5_TIPO="NCP",SA6->A6_CONTA,IIF(RTRIM(SE2->E2_PREFIXO)$"FIN/CMA",SED->ED_CONTA,IIF(!Empty(SE2->E2_CONTAD),SE2->E2_CONTAD,IIF(Rtrim(SE2->E2_TIPO)=="FOL",210110001,SA2->A2_CONTA))))     
	ElseIf cLP = "560" .And. cSeq = "001" .And. cTipo = "D"

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
		cQuery += " SE5.E5_PROCTRA = '"+SE5->E5_PROCTRA+"' AND "
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
			SED->(DbSeek(xFilial("SED")+SEU->EU_NATUREZ))
			xRet := SED->ED_CONTA
		EndIf

	ElseIf cLP = "596" .And. cSeq = "001" .And. cTipo = "C"

		aArea := SE1->(GetArea())

		DbSelectArea("SE1")
		DbSetOrder(1)
		If DbSeek(SE5->E5_FILIAL+SubStr(SE5->E5_DOCUMEN,1,12)) .And. SubStr(SE5->E5_DOCUMEN,1,3) == "FIN"
			If AllTrim(SE1->E1_NATUREZ)$"10116"
				xRet:= 322001035
			Else
				xRet:= IF(SA1->A1_CONTA<>" ",SA1->A1_CONTA,111001001)
			Endif
		Else
			xRet:= IF(SA1->A1_CONTA<>" ",SA1->A1_CONTA,111001001)
		Endif

		RestArea(aArea)

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

		If SE2->E2_PREFIXO="EIC".AND.SE2->E2_TIPO<>"PA".OR.SUBSTR(SE5->E5_DOCUMEN,1,3)="EIC"
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
		Else
			xRet:= 210101005
		EndIf

		RestArea(aArea)
		RestArea(aArea2)


	ElseIf cLP = "597" .And. cSeq = "001" .And. cTipo = "H"

		cRet :=IIF(Rtrim(SE2->E2_PREFIXO)="EIC","COMP. "+Rtrim(SE2->E2_HIST),"COMPENS PGTO ANTEC TIT "+RTrim(SE2->E2_NUM)+" "+RTrim(SA2->A2_NREDUZ))

		If Rtrim(SE5->E5_TIPO) == "PA" .And. Rtrim(SE5->E5_PREFIXO) =="EIC"
			_cDocPO  := SubStr(SE5->E5_DOCUMEN,4,9)

			DbSelectArea("SWD")
			DbSetOrder(4)
			If DbSeek(xFilial("SWD")+_cDocPO)
				DbSelectArea("SYB")
				DbSetOrder(1)
				If DbSeek(xFilial("SYB")+SWD->WD_DESPESA)
					cRet += " - "+RTrim(SubSTr(SYB->YB_DESCR,1,10))
				Endif
			Endif

		Endif
		cRet := AllTrim(cRet)

	ElseIf cLP = "597" .And. cSeq = "005" .And. cTipo = "H"

		cRet := IIF(RTrim(SE2->E2_PREFIXO)="EIC","COMP. "+RTrim(SE2->E2_HIST),"COMPENS PGTO ANTEC TIT "+RTrim(SE2->E2_NUM)+" "+RTrim(SA2->A2_NREDUZ))

		If Rtrim(SE5->E5_TIPO) == "PA" .And. Rtrim(SE5->E5_PREFIXO) =="EIC"
			_cDocPO  := SubStr(SE5->E5_DOCUMEN,4,9)

			DbSelectArea("SWD")
			DbSetOrder(4)
			If DbSeek(xFilial("SWD")+_cDocPO)
				DbSelectArea("SYB")
				DbSetOrder(1)
				If DbSeek(xFilial("SYB")+SWD->WD_DESPESA)
					cRet += " - "+SubSTr(RTrim(SYB->YB_DESCR),1,10)
				Endif
			Endif

		Endif
		cRet := AllTrim(cRet)

	ElseIf cLP = "575" .And. cSeq = "001" .And. cTipo = "D"

		If RTRIM(SEL->EL_TIPO)$"RG"
			xRet := "112001025"
		ElseIf RTRIM(SEL->EL_TIPO)$"RI"
			xRet := "112001010"
		ElseIf RTRIM(SEL->EL_TIPO)$"RS"
			xRet := "112001040"
		ElseIf RTRIM(SEL->EL_TIPO)$"RB"
			If SA1->A1_EST=="BA"
				xRet := "112002005"
			ElseIf SA1->A1_EST=="CF"
				xRet := "112002001"
			Else
				xRet := "112002006"
			Endif
		ElseIf RTRIM(SEL->EL_TIPO)$"OT"
			xRet := "112002006"
		ElseIf RTRIM(SEL->EL_TIPO)$"RA"
			xRet := "210130010"	
		Else
			xRet:=	IIF(RTRIM(SEL->EL_TIPO)$"NCC","210130010",SA6->A6_CONTA)
		Endif
	
	ElseIf cLP = "575" .And. cSeq = "001" .And. cTipo = "VD"
	    xRet := IIF(RTRIM(SEL->EL_TIPODOC)$"RB/RG/RI/RS/TF/EF/CH/OT" .OR. (RTRIM(SEL->EL_TIPO)$"NCC/RA" .AND. (RTRIM(SEL->EL_TIPODOC)<>"RA")) ,IIF(RTRIM(SEL->EL_MOEDA)='2' .OR. RTRIM(SEL->EL_MOEDA)='02',SEL->EL_VLMOED1,SEL->EL_VALOR),0)
	ElseIf cLP = "575" .And. cSeq = "002" .And. cTipo = "VC"
	    xRet := IIF( !(RTRIM(SEL->EL_TIPODOC)$"RB/RG/RI/RS/TF/EF/CH/OT") .AND. !(RTRIM(SEL->EL_TIPO)$"NCC/RA" .AND. (RTRIM(SEL->EL_TIPODOC)<>"RA")) ,IIF(RTRIM(SEL->EL_MOEDA)='2' .OR. RTRIM(SEL->EL_MOEDA)='02',SEL->EL_VLMOED1,SEL->EL_VALOR),0)                                                     
	ElseIf cLP = "570" .And. cSeq = "002" .And. cTipo = "C"

		cQuery := " SELECT SA6.A6_CONTA AS CONTA      "
		cQuery += " FROM "+RetSqlName("SA6")+" SA6,"+RetSqlName("SEK")+" SEK  "
		cQuery += " WHERE SEK.EK_ORDPAGO='"+SEK->EK_ORDPAGO+"'	         AND  "
		cQuery += "       SEK.EK_FILIAL ='"+xFilial("SEK")+"'           AND   "
		cQuery += "       SEK.D_E_L_E_T_ <> '*'                         AND   "
		cQuery += "       SEK.EK_PREFIXO='PA'                           AND   "
		cQuery += "       SEK.EK_BANCO=SA6.A6_COD                       AND   "
		cQuery += "       SEK.EK_AGENCIA=SA6.A6_AGENCIA                 AND   "
		cQuery += "       SEK.EK_CONTA = SA6.A6_NUMCON                  AND   "
		cQuery += "       SA6.D_E_L_E_T_ <>'*'                                "

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
			xRet := (cAlias)->CONTA
		Endif

		If Empty(xRet)
			xRet := SA6->A6_CONTA
		Endif

		If !Empty(Select(cAlias))
			DbSelectArea(cAlias)
			(cAlias)->(dbCloseArea())
		Endif

	ElseIf cLP = "570" .And. cSeq = "001" .And. cTipo = "V"
		xRet := IIF(SUBSTR(RTRIM(SEK->EK_TIPODOC),1,1)$"R",IIF(RTRIM(SEK->EK_TIPODOC)$"RB/RG/RI/RS/TF/EF/CH/CP" .OR. (RTRIM(SEK->EK_TIPO)$"PA" .AND. (RTRIM(SEK->EK_TIPODOC)<>"PA")) ,IIF(SEK->EK_MOEDA=='2',SEK->EK_VLMOED1,SEK->EK_VALOR),0),0)
	ElseIf cLP = "570" .And. cSeq = "003" .And. cTipo = "V"
	   xRet := IIF(( RTRIM(SEK->EK_TIPODOC)$"PA" .OR. ( RTRIM(SEK->EK_TIPODOC)$"CP" .AND. (RTRIM(SEK->EK_TIPO)$"TF/EF") )) .And. !Empty(SEK->EK_BANCO),IIF(SEK->EK_MOEDA=='2',SEK->EK_VLMOED1,SEK->EK_VALOR),0)   
	ElseIf  cLP = "570" .And. cSeq = "004" .And. cTipo = "V"
	     xRet := IIF((RTRIM(SEK->EK_TIPO)$"FT".OR. (RTRIM(SEK->EK_TIPO)$"PA" .and. !RTrim(SEK->EK_TIPODOC)$"PA")).AND. (RTrim(SEK->EK_PREFIXO)$"FAT/FIN" .OR. SEK->EK_PREFIXO=Space(3)),IIF(SEK->EK_MOEDA=='2',SEK->EK_VLMOED1,SEK->EK_VALOR),0)            
	ElseIf  cLP = "570" .And. cSeq = "002" .And. cTipo = "D"

		cQuery := " SELECT SEK.EK_ORDPAGO AS ORPAGO      "
		cQuery += " FROM "+RetSqlName("SEK")+" SEK  "
		cQuery += " WHERE SEK.EK_ORDPAGO='"+SEK->EK_ORDPAGO+"'	        AND  "
		cQuery += "       SEK.EK_FILIAL ='"+xFilial("SEK")+"'           AND  "
		cQuery += "       SEK.D_E_L_E_T_ <> '*'                         AND  "
		cQuery += "       SEK.EK_TIPODOC='PA' AND SEK.EK_TIPO='PA'           "
		
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
			xRet := 'PA'
		Endif

		If xRet=='PA'
            xRet := IIF(RTRIM(xRet)$"PA",IIF(RTrim(Posicione("SA2",1,xFilial("SA2")+SEK->EK_FORNECE+SEK->EK_LOJA,"A2_CONTA"))=="210101011","113001025",IIF(RTrim(Posicione("SA2",1,xFilial("SA2")+SEK->EK_FORNECE+SEK->EK_LOJA,"A2_CONTA"))=="210101010",113001020,IIF(RTrim(Posicione("SA2",1,xFilial("SA2")+SEK->EK_FORNECE+SEK->EK_LOJA,"A2_CONTA"))=="210101005","113001015",""))),Posicione("SA2",1,xFilial("SA2")+SEK->EK_FORNECE+SEK->EK_LOJA,"A2_CONTA"))                       
		Else
            xRet := IIF(RTRIM(SEK->EK_TIPODOC)$"PA" ,IIF(RTrim(Posicione("SA2",1,xFilial("SA2")+SEK->EK_FORNECE+SEK->EK_LOJA,"A2_CONTA"))=="210101011","113001025",IIF(RTrim(Posicione("SA2",1,xFilial("SA2")+SEK->EK_FORNECE+SEK->EK_LOJA,"A2_CONTA"))=="210101010",113001020,IIF(RTrim(Posicione("SA2",1,xFilial("SA2")+SEK->EK_FORNECE+SEK->EK_LOJA,"A2_CONTA"))=="210101005","113001015",""))),Posicione("SA2",1,xFilial("SA2")+SEK->EK_FORNECE+SEK->EK_LOJA,"A2_CONTA"))                       
		Endif 
	ElseIf  cLP = "570" .And. cSeq = "004" .And. cTipo = "C"

	       xRet :=  IIF(RTrim(Posicione("SA2",1,xFilial("SA2")+SEK->EK_FORNECE+SEK->EK_LOJA,"A2_CONTA"))=="210101011","113001025",IIF(RTrim(Posicione("SA2",1,xFilial("SA2")+SEK->EK_FORNECE+SEK->EK_LOJA,"A2_CONTA"))=="210101010",113001020,IIF(RTrim(Posicione("SA2",1,xFilial("SA2")+SEK->EK_FORNECE+SEK->EK_LOJA,"A2_CONTA"))=="210101005","113001015","")))

	ElseIf  cLP = "570" .And. cSeq = "002" .And. cTipo = "H"
	      IF (Rtrim(SEK->EK_TIPODOC)="CP" .And. SEK->EK_SALDO=0) .Or. SEK->EK_TIPODOC="PA"
		     xRet := " ORDEN PAGO PROVEDOR "+SEK->EK_ORDPAGO+" PA "+SEK->EK_NUM+"   "+SEK->EK_TIPO  
		  Else
	      xRet := " ORDEN PAGO PROVEDOR "+SEK->EK_ORDPAGO+" FATURA "+SEK->EK_NUM+"   "+SEK->EK_TIPO  
		  Endif   
	ElseIf   cLP = "571" .And. cSeq = "002" .And. cTipo = "H"    

	        IF (Rtrim(SEK->EK_TIPODOC)="CP" .And. SEK->EK_SALDO=0) .Or. SEK->EK_TIPODOC="PA"
		     xRet := " CANC ORDEN PAGO PROVEDOR "+SEK->EK_ORDPAGO+" PA "+SEK->EK_NUM+"   "+SEK->EK_TIPO  
		  Else
	      xRet := " CANC ORDEN PAGO PROVEDOR "+SEK->EK_ORDPAGO+" FATURA "+SEK->EK_NUM+"   "+SEK->EK_TIPO  
		  Endif                                                                         	 
	ElseIf cLP = "570" .And. cSeq = "006" .And. cTipo = "V"
	
	    cQuery := " SELECT SEK.EK_ORDPAGO AS ORPAGO      "
		cQuery += " FROM "+RetSqlName("SEK")+" SEK  "
		cQuery += " WHERE SEK.EK_ORDPAGO='"+SEK->EK_ORDPAGO+"'	        AND  "
		cQuery += "       SEK.EK_FILIAL ='"+xFilial("SEK")+"'           AND  "
		cQuery += "       SEK.D_E_L_E_T_ <> '*'                         AND  "
		cQuery += "       SEK.EK_TIPODOC='CP'                                "
		
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
			xRet := '0'
		Endif

		If !Empty(xRet)
			xRet := IIF(((rtrim(SEK->EK_TIPO)="FT" .And. rtrim(SEK->EK_TIPODOC)="TB" .And. rtrim(SEK->EK_PREFIXO)="FIN" )   ) .And. Empty(SEK->EK_BANCO) ,IIF(SEK->EK_MOEDA=='2',SEK->EK_VLMOED1,SEK->EK_VALOR),0)
		Else
		  xRet :=IIF(( (rtrim(SEK->EK_TIPO)="NF" .And. rtrim(SEK->EK_TIPODOC)="TB"  )    ) .And. Empty(SEK->EK_BANCO) ,IIF(SEK->EK_MOEDA=='2',SEK->EK_VLMOED1,SEK->EK_VALOR),0)
		Endif

		If !Empty(Select(cAlias))
			DbSelectArea(cAlias)
			(cAlias)->(dbCloseArea())
		Endif
	
	
	         
	ElseIf 	cLP = "570" .And. cSeq = "002" .And. cTipo = "V"

		If SEK->EK_MOEDA=='2'

			cQuery := " SELECT SE2.E2_FILIAL AS FIL,                        "
			cQuery += "        SE2.E2_NUM    AS NUM,                        "
			cQuery += "        SE2.E2_FORNECE AS FORNECE,                   "
			cQuery += "        SE2.E2_LOJA    AS LOJA,                      "
			cQuery += "        SE2.E2_PREFIXO AS PREFIXO,                   " 
			cQuery += "        SE2.E2_TXMOEDA AS TXMOEDA                    "
			cQuery += " FROM "+RetSqlName("SE2")+" SE2                      "
			cQuery += " WHERE SE2.E2_FILIAL   = '"+xFilial("SEK")+"'   AND  "
			cQuery += "       SE2.E2_NUM      ='"+SEK->EK_NUM+"'       AND  "
			cQuery += "       SE2.E2_FORNECE  = '"+SEK->EK_FORNECE+"'  AND  "
			cQuery += "       SE2.E2_LOJA     = '"+SEK->EK_LOJA+"'     AND  "
			cQuery += "       SE2.D_E_L_E_T_ <> '*'                    AND  "
			cQuery += "       SE2.E2_PREFIXO = '"+SEK->EK_PREFIXO+"'        "

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
				xRet := (cAlias)->TXMOEDA *SEK->EK_VALOR
			Endif 


			If !Empty(Select(cAlias))
				DbSelectArea(cAlias)
				(cAlias)->(dbCloseArea())
			Endif
		ElseIf SEK->EK_MOEDA=='1'


			cQuery := " SELECT COUNT(*) AS QTD_ORD                                   "
			cQuery += " FROM "+RetSqlName("SEK")+" SEK                               "
			cQuery += " WHERE SEK.EK_FILIAL     = '"+xFilial("SEK")+"'          AND  "
			cQuery += "       SEK.EK_ORDPAGO      ='"+SEK->EK_ORDPAGO +"'       AND  "
			cQuery += "       SEK.EK_MOEDA='2'                                  AND  "
			cQuery += "       SEK.D_E_L_E_T_ <> '*'                                  "

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

				If (cAlias)->QTD_ORD > 0
					xRet := (cAlias)->QTD_ORD
				Else
					xRet :=0 
				Endif
			Endif 


			If !Empty(Select(cAlias))
				DbSelectArea(cAlias)
				(cAlias)->(dbCloseArea())
			Endif

			If xRet <= 0
				xRet := IIF(SUBSTR(RTRIM(SEK->EK_TIPODOC),1,1)$"R",0,IIF(RTRIM(SEK->EK_TIPODOC)$"RB/RG/RI/RS/TF/EF/CH/CP" .OR. (RTRIM(SEK->EK_TIPO)$"PA" .AND. (RTRIM(SEK->EK_TIPODOC)<>"PA") .OR. Rtrim(SEK->EK_TIPO)="NDI"),IIF(SEK->EK_MOEDA=='2',SEK->EK_VLMOED1,SEK->EK_VALOR),0))
			Else
				xRet  := 0 
			Endif
		Endif

	ElseIf 	cLP = "570" .And. cSeq = "005" .And. cTipo = "V"

		If SEK->EK_MOEDA=='2'

			cQuery := " SELECT SE2.E2_FILIAL AS FIL,                        "
			cQuery += "        SE2.E2_NUM    AS NUM,                        "
			cQuery += "        SE2.E2_FORNECE AS FORNECE,                   "
			cQuery += "        SE2.E2_LOJA    AS LOJA,                      "
			cQuery += "        SE2.E2_PREFIXO AS PREFIXO,                   " 
			cQuery += "        SE2.E2_TXMOEDA AS TXMOEDA                    "
			cQuery += " FROM "+RetSqlName("SE2")+" SE2                      "
			cQuery += " WHERE SE2.E2_FILIAL   = '"+xFilial("SEK")+"'   AND  "
			cQuery += "       SE2.E2_NUM      ='"+SEK->EK_NUM+"'       AND  "
			cQuery += "       SE2.E2_FORNECE  = '"+SEK->EK_FORNECE+"'  AND  "
			cQuery += "       SE2.E2_LOJA     = '"+SEK->EK_LOJA+"'     AND  "
			cQuery += "       SE2.D_E_L_E_T_ <> '*'                    AND  "
			cQuery += "       SE2.E2_PREFIXO = '"+SEK->EK_PREFIXO+"'        "

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
				xRet := (cAlias)->TXMOEDA *SEK->EK_VALOR
			Endif 

			If xRet  > 0
				xRet := SEK->EK_VLMOED1- xRet
			Endif


			If !Empty(Select(cAlias))
				DbSelectArea(cAlias)
				(cAlias)->(dbCloseArea())
			Endif
		Endif
    
	ElseIf 	cLP = "570" .And. cSeq = "008" .And. cTipo = "V"

		If SEK->EK_MOEDA=='2'

			cQuery := " SELECT SE2.E2_FILIAL AS FIL,                        "
			cQuery += "        SE2.E2_NUM    AS NUM,                        "
			cQuery += "        SE2.E2_FORNECE AS FORNECE,                   "
			cQuery += "        SE2.E2_LOJA    AS LOJA,                      "
			cQuery += "        SE2.E2_PREFIXO AS PREFIXO,                   " 
			cQuery += "        SE2.E2_TXMOEDA AS TXMOEDA                    "
			cQuery += " FROM "+RetSqlName("SE2")+" SE2                      "
			cQuery += " WHERE SE2.E2_FILIAL   = '"+xFilial("SEK")+"'   AND  "
			cQuery += "       SE2.E2_NUM      ='"+SEK->EK_NUM+"'       AND  "
			cQuery += "       SE2.E2_FORNECE  = '"+SEK->EK_FORNECE+"'  AND  "
			cQuery += "       SE2.E2_LOJA     = '"+SEK->EK_LOJA+"'     AND  "
			cQuery += "       SE2.D_E_L_E_T_ <> '*'                    AND  "
			cQuery += "       SE2.E2_PREFIXO = '"+SEK->EK_PREFIXO+"'        "

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
				xRet := (cAlias)->TXMOEDA *SEK->EK_VALOR
			Endif 

			If xRet  > 0
				xRet := xRet-SEK->EK_VLMOED1 
			Endif


			If !Empty(Select(cAlias))
				DbSelectArea(cAlias)
				(cAlias)->(dbCloseArea())
			Endif
		Endif


	ElseIf cLP = "530" .And. cSeq = "001" .And. cTipo = "IC"


		cQuery := "  SELECT SE5.E5_CLIFOR AS CLIFOR,SE5.E5_LOJA AS LOJA "
		cQuery += "  FROM "+RetSqlName("SE5")+" SE5	                     "
		cQuery += "  WHERE SE5.E5_FILIAL = '"+xFilial("SE5")+"'      AND "
		cQuery += "        SE5.D_E_L_E_T_ <> '*'                     AND "
		cQuery += "        SE5.E5_PREFIXO='FAT'                      AND "
		cQuery += "        SE5.E5_NUMERO LIKE '%"+SubStr(SE5->E5_HISTOR,18,12)+"%'  AND " 
		cQuery += "        SE5.E5_SITUACA <> 'C'                                          "


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
			xRet := '2'+(cAlias)->CLIFOR+(cAlias)->LOJA
		Endif 

		If Empty(xRet)
             xRet := IIF(SE5->E5_TIPO="NCP","2"+ALLTRIM(SA2->A2_COD)+ALLTRIM(SA2->A2_LOJA),IIF(RTRIM(SE5->E5_MOTBX)$"FAT",IIF(U_CTBARIT(SA2->A2_CONTA),"2"+ALLTRIM(SA2->A2_COD)+ALLTRIM(SA2->A2_LOJA),''),IIF(U_CTBARIT(SA6->A6_CONTA),"2"+ALLTRIM(SA2->A2_COD)+ALLTRIM(SA2->A2_LOJA),'')))                          	                                                  
		Endif


		If !Empty(Select(cAlias))
			DbSelectArea(cAlias)
			(cAlias)->(dbCloseArea())
		Endif
	EndIf



Return(xRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ STKCXAR³ Autor ³ Cristiano Pereira     ³ Data ³ 24/04/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Desc.     ³ Funcao utilizada no Lancamentos Padrões 572 para carregar  ³±±
±±³          ³ a conta contábil da natureza utilizada no adiantamento     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ STECK			                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function STKCXAR()

	Local _cConta	:= "" // Conta Contábil
	Local cQuery	:= ""
	Local cAlias	:= 'xxxtemp'
	Local aArea		:= {SEU->(GetArea("SEU")), GetArea()}
	Local nA := 0
	IF !EMPTY(SEU->EU_NROADIA)
		If Select( cAlias ) > 0
			DbSelectArea( cAlias )
			(cAlias)->(DbCloseArea())
		Endif

		cQuery += " SELECT ED_CONTA AS CONTA"
		cQuery += " FROM "+RETSQLNAME("SEU")
		cQuery += " LEFT JOIN "+RETSQLNAME("SED")+" ON ED_FILIAL = ' ' AND ED_CODIGO = EU_X_NATUR"
		cQuery += " WHERE EU_FILIAL = '"+SEU->EU_FILIAL+"' AND EU_NUM = '"+SEU->EU_NROADIA+"' AND EU_CAIXA = '"+SEU->EU_CAIXA+"' AND "+RETSQLNAME("SEU")+".D_E_L_E_T_ = ' '"

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

		While !(cAlias)->(Eof())
			_cConta := (cAlias)->CONTA
			(cAlias)->(dbSkip())
		EndDo

		(cAlias)->(DbCloseArea())

	Else
		_cConta := "110101001"
	Endif

	For nA := 1 to Len(aArea)
		RestArea(aArea[nA])
	Next

Return(_cConta)
