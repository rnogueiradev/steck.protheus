#include "totvs.ch"
#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CTBSTECKH  ºAutor  ³Renato            º Data ³  06/12/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função para carregar o histórico do LP                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Steck                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CTBSTHIST(cLP,cSeq,cTipo)

	Local cRet      := ' '
	Local _cDocPO   := ' '

	If cLP = "610" .And. cSeq = "101" .And. cTipo = "H"

		If SF2->F2_TIPO=="D" .Or. SF2->F2_TIPO=="B"
			DbSelectArea("SA2")
			DbSetOrder(1)
			DbSeek(xFilial("SA2")+SD2->D2_CLIENTE+SD2->D2_LOJA)
		Else
			DbSelectArea("SA1")
			DbSetOrder(1)
			DbSeek(xFilial("SA1")+SD2->D2_CLIENTE+SD2->D2_LOJA)
		Endif

		cRet := "VR "

		If Rtrim(SD2->D2_CF) $"5917" .Or.  Rtrim(SD2->D2_CF) $"6917"
		    cRet += "VR CONSIGNAÇÃO. NF "+SD2->D2_DOC+" "+Iif(SF2->F2_TIPO="D" .Or. SF2->F2_TIPO="B",Substr(SA2->A2_NOME,1,18),Substr(SA1->A1_NREDUZ,1,18)) 
        ElseIf Rtrim(SD2->D2_CF) $ "7102"
            cRet += "REVENDA EXPORTACAO NF."+SD2->D2_DOC+" "+Iif(SF2->F2_TIPO=="D" .Or. SF2->F2_TIPO="B",Substr(SA2->A2_NOME,1,18),Substr(SA1->A1_NREDUZ,1,18))
		ElseIf Rtrim(SD2->D2_CF) $ "7101"
		    cRet += "VENDA EXPORTACAO NF."+SD2->D2_DOC+" "+Iif(SF2->F2_TIPO=="D" .Or. SF2->F2_TIPO="B",Substr(SA2->A2_NOME,1,18),Substr(SA1->A1_NREDUZ,1,18))
		ElseIf SF4->F4_ZCLASOP == "1"
			cRet += "AMOSTRA NF."+SD2->D2_DOC+" "+Iif(SF2->F2_TIPO="D" .Or. SF2->F2_TIPO="B",Substr(SA2->A2_NOME,1,18),Substr(SA1->A1_NREDUZ,1,18))
		ElseIf SF4->F4_ZCLASOP == "2"
			cRet += "BONIF. NF."+SD2->D2_DOC+" "+Iif(SF2->F2_TIPO="D" .Or. SF2->F2_TIPO="B",Substr(SA2->A2_NOME,1,18),Substr(SA1->A1_NREDUZ,1,18))
		ElseIf SF4->F4_ZCLASOP == "3"
			cRet += "BRINDE NF."+SD2->D2_DOC+" "+Iif(SF2->F2_TIPO="D" .Or. SF2->F2_TIPO="B",Substr(SA2->A2_NOME,1,18),Substr(SA1->A1_NREDUZ,1,18))
		ElseIf  SF4->F4_ZCLASOP == "4"
			cRet += "DOACAO NF."+SD2->D2_DOC+" "+Iif(SF2->F2_TIPO="D" .Or. SF2->F2_TIPO="B",Substr(SA2->A2_NOME,1,18),Substr(SA1->A1_NREDUZ,1,18))
		ElseIf  SF4->F4_ZCLASOP == "5" .Or. SF4->F4_ZCLASOP == "6"
			cRet += "PROPAG NF."+SD2->D2_DOC+" "+Iif(SF2->F2_TIPO="D" .Or. SF2->F2_TIPO="B",Substr(SA2->A2_NOME,1,18),Substr(SA1->A1_NREDUZ,1,18))
		ElseIf  SF4->F4_ZCLASOP == "7" .Or. SF4->F4_ZCLASOP == "8" .Or. SF4->F4_ZCLASOP == "9"
			cRet += "TROCA/GAR NF."+SD2->D2_DOC+" "+Iif(SF2->F2_TIPO="D" .Or. SF2->F2_TIPO="B",Substr(SA2->A2_NOME,1,18),Substr(SA1->A1_NREDUZ,1,18))
		ElseIF SD2->D2_TES$"522"
			cRet += "BRINDE NF."+SD2->D2_DOC+" "+Iif(SF2->F2_TIPO="D" .Or. SF2->F2_TIPO="B",Substr(SA2->A2_NOME,1,18),Substr(SA1->A1_NREDUZ,1,18))
		ElseIf SD2->D2_TES$"521/691"
			cRet += "DOACAO NF."+SD2->D2_DOC+" "+Iif(SF2->F2_TIPO="D" .Or. SF2->F2_TIPO="B",Substr(SA2->A2_NOME,1,18),Substr(SA1->A1_NREDUZ,1,18))
		ElseIf Substr(AllTrim(SD2->D2_CF),2,3)$"910"
			cRet += "BONIF. NF."+SD2->D2_DOC+" "+Iif(SF2->F2_TIPO="D" .Or. SF2->F2_TIPO="B",Substr(SA2->A2_NOME,1,18),Substr(SA1->A1_NREDUZ,1,18))
		ElseIf SF4->F4_DUPLIC="S"
			cRet += "VENDAS NF."+SD2->D2_DOC+" "+Iif(SF2->F2_TIPO=="D" .Or. SF2->F2_TIPO="B",Substr(SA2->A2_NOME,1,18),Substr(SA1->A1_NREDUZ,1,18))
		ElseIf SF4->F4_PODER3='R' .OR. ( SD2->D2_TES="687" .Or. SD2->D2_TES="705")
			cRet += "REM IND NF."+SD2->D2_DOC+" "+Iif(SF2->F2_TIPO="D" .Or. SF2->F2_TIPO="B",Substr(SA2->A2_NOME,1,18),Substr(SA1->A1_NREDUZ,1,18))
		Else
			//cRet += "EXPORTACAO NF. "+SD2->D2_DOC+" "+Iif(SF2->F2_TIPO="D" .Or. SF2->F2_TIPO="B",Substr(SA2->A2_NOME,1,18),Substr(SA1->A1_NREDUZ,1,18))
			cRet += "VALOR MERC. "+SD2->D2_DOC+" "+Iif(SF2->F2_TIPO="D" .Or. SF2->F2_TIPO="B",Substr(SA2->A2_NOME,1,18),Substr(SA1->A1_NREDUZ,1,18))
		EndIf

	EndIf


	If cLP = "530" .And. cSeq = "001" .And. cTipo = "H"

		If SE2->E2_PREFIXO$"EEC|THO"
			cRet :=   IIF(SE5->E5_MOTBX=="FIN","NF "+SE2->E2_NUM+"TRANSF LIQ. ATRAVES DE FINAME",IIF(!EMPTY(SE5->E5_NUMCHEQ),"BAIXA TIT. CH. "+SE5->E5_NUMCHEQ,IIF(AllTrim(SE2->E2_PREFIXO)$"EEC|THO","BX TIT. "+SE2->E2_NUM+"-"+RTRIM(SE2->E2_HIST)+"ORIG     "+RTrim(cValToChar(SE5->E5_VLMOED2)),"BX TIT. REF."+SE2->E2_TIPO+" "+SE2->E2_NUM)))
		Else
			cRet :=   IIF(SE5->E5_MOTBX=="FIN","NF "+SE2->E2_NUM+"TRANSF LIQ. ATRAVES DE FINAME",IIF(!EMPTY(SE5->E5_NUMCHEQ),"BAIXA TIT. CH. "+SE5->E5_NUMCHEQ,"BX TIT. REF."+SE2->E2_TIPO+" "+SE2->E2_NUM+"-"+RTRIM(SE2->E2_HIST)))
		Endif
	Endif


	If cLP = "531" .And. cSeq = "001" .And. cTipo = "H"

		If SE2->E2_PREFIXO$"EEC|THO"
			cRet :=   "CANC: "+IIF(SE5->E5_MOTBX=="FIN","NF "+SE2->E2_NUM+"TRANSF LIQ. ATRAVES DE FINAME",IIF(!EMPTY(SE5->E5_NUMCHEQ),"BAIXA TIT. CH. "+SE5->E5_NUMCHEQ,IIF(AllTrim(SE2->E2_PREFIXO)$"EEC|THO","BX TIT. "+SE2->E2_NUM+"-"+RTRIM(SE2->E2_HIST)+"ORIG     "+RTrim(cValToChar(SE5->E5_VLMOED2)),"BX TIT. REF."+SE2->E2_TIPO+" "+SE2->E2_NUM)))
		Else
			cRet :=   "CANC: "+IIF(SE5->E5_MOTBX=="FIN","NF "+SE2->E2_NUM+"TRANSF LIQ. ATRAVES DE FINAME",IIF(!EMPTY(SE5->E5_NUMCHEQ),"BAIXA TIT. CH. "+SE5->E5_NUMCHEQ,"BX TIT. REF."+SE2->E2_TIPO+" "+SE2->E2_NUM))
		Endif
	Endif


	If cLP = "530" .And. cSeq = "011" .And. cTipo = "H"

		cQuery := " SELECT  SE2.E2_NUM  AS NUMAGL                               "
		cQuery += " FROM "+RetSqlName("SE2")+" SE2                                   "
		cQuery += " WHERE SE2.E2_FILIAL = '"+xFilial("SE2")+"'           AND         "
		cQuery += "       SE2.D_E_L_E_T_  <> '*'                         AND         "
		cQuery += "       SE2.E2_NUMLIQ  = '"+Rtrim(SE5->E5_DOCUMEN)+"'              "

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
			cRet := "BX. AGL. REF LIQ "+" NF "+SE5->E5_NUMERO+" PROC "+(cAlias)->NUMAGL
		Endif

		If Empty(cRet)
			cRet := ' '
		Endif

		If !Empty(Select(cAlias))
			DbSelectArea(cAlias)
			(cAlias)->(dbCloseArea())
		Endif

	Endif


	If cLP = "597" .And. cSeq = "001" .And. cTipo = "H"

		cRet :=IIF(Rtrim(SE2->E2_PREFIXO)$"EIC|THO","COMP."+Rtrim(SE2->E2_HIST),"COMPENS PGTO ANTEC TIT "+Rtrim(SE2->E2_HIST)+RTrim(SE2->E2_NUM)+" "+RTrim(SA2->A2_NREDUZ))

		If Rtrim(SE5->E5_TIPO) == "PA" .And. Rtrim(SE5->E5_PREFIXO) $"EIC|THO"
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

		If SubStr(SE5->E5_DOCUMEN,1,3)$"EIC|THO"
			cRet += " "+RTrim(SE5->E5_DOCUMEN)
		Endif

		cRet := AllTrim(cRet)
	Endif


	If cLP = "597" .And. cSeq = "005" .And. cTipo = "H"

		cRet := IIF(RTrim(SE2->E2_PREFIXO)$"EIC|THO","COMP. "+RTrim(SE2->E2_HIST),"COMPENS PGTO ANTEC TIT "+RTrim(SE2->E2_NUM)+" "+RTrim(SA2->A2_NREDUZ))

		If Rtrim(SE5->E5_TIPO) == "PA" .And. Rtrim(SE5->E5_PREFIXO) $"EIC|THO"
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


		If SubStr(SE5->E5_DOCUMEN,1,3)$"EIC|THO"
			cRet += " "+RTrim(SE5->E5_DOCUMEN)
		ElseIf SubStr(SE5->E5_PREFIXO,1,3)$"EIC|THO"
			cRet += " "+RTrim(SE5->E5_NUMERO)
		Endif

		cRet := AllTrim(cRet)
	Endif


	//If cLP = "610" .And. cSeq = "101" .And. cTipo = "H"
	//	cRet := IF((SF4->F4_DUPLIC="S"),"VR.VENDAS NF."+SD2->D2_DOC+" "+Substr(SA1->A1_NREDUZ,1,18),IF((Substr(AllTrim(SF4->F4_CF),2,3)$"910"),"SAIDA BRINDE/BONIF.NF."+SD2->D2_DOC+" "+Substr(SA1->A1_NREDUZ,1,18),IIF(SD2->D2_EST=="EX","VR EXPORTACAO NF "+SD2->D2_DOC+" "+Substr(SA1->A1_NREDUZ,1,18),"OUTRAS OP NF"+SD2->D2_DOC+" "+Substr(SA1->A1_NREDUZ,1,18))))
	//Endif

	If cLP = "610" .And. cSeq = "116" .And. cTipo = "H"

	    If SF2->F2_TIPO=="D" .Or. SF2->F2_TIPO=="B"
			DbSelectArea("SA2")
			DbSetOrder(1)
			DbSeek(xFilial("SA2")+SD2->D2_CLIENTE+SD2->D2_LOJA)
		Else
			DbSelectArea("SA1")
			DbSetOrder(1)
			DbSeek(xFilial("SA1")+SD2->D2_CLIENTE+SD2->D2_LOJA)
		Endif

		cRet :=  "VR IPI S/ "+IF(SD2->D2_TES$"522","BRINDE",IF(SD2->D2_TES$"521/691","DOACAO",IF(Substr(AllTrim(SD2->D2_CF),2,3)$"910","BONIF.",IF(Substr(AllTrim(SD2->D2_CF),2,3)$"151/152","TRANSF",IF(SF4->F4_DUPLIC="S","REPO","OUTRAS OP")))))+" NF "+ SD2->D2_DOC
	Endif

	If cLP = "678" .And. cSeq = "001" .And. cTipo = "H"
			DbSelectArea("SA1")
			DbSetOrder(1)
			DbSeek(xFilial("SA1")+SD2->D2_CLIENTE+SD2->D2_LOJA)

		cRet :=  "APURACAO DO CMV " + SD2->D2_DOC+" "+Rtrim(SA1->A1_NREDUZ)                                                                                                                                                                                                
	Endif

	If cLP = "610" .And. cSeq = "102" .And. cTipo = "H"

	    If SF2->F2_TIPO=="D" .Or. SF2->F2_TIPO=="B"
			DbSelectArea("SA2")
			DbSetOrder(1)
			DbSeek(xFilial("SA2")+SD2->D2_CLIENTE+SD2->D2_LOJA)
		Else
			DbSelectArea("SA1")
			DbSetOrder(1)
			DbSeek(xFilial("SA1")+SD2->D2_CLIENTE+SD2->D2_LOJA)
		Endif


		cRet := "VR ICMS S/ "+IF(SD2->D2_TES$"522","BRINDE",IF(SD2->D2_TES$"521/691","DOACAO",IF(Substr(AllTrim(SD2->D2_CF),2,3)$"910","BONIF.",IF(Substr(AllTrim(SD2->D2_CF),2,3)$"151/152","TRANSF",IF(SF4->F4_DUPLIC="S","VENDA","OUTRAS OP")))))+" NF "+ SD2->D2_DOC

		If Rtrim(SD2->D2_CF) $"5917" .Or.  Rtrim(SD2->D2_CF) $"6917"
               cRet := "VR ICMS S/ CONSIGNAÇÃO "+ SD2->D2_DOC
		Endif
	Endif

	If cLP = "610" .And. cSeq = "104" .And. cTipo = "H"
	   
	   If SF2->F2_TIPO=="D" .Or. SF2->F2_TIPO=="B"
			DbSelectArea("SA2")
			DbSetOrder(1)
			DbSeek(xFilial("SA2")+SD2->D2_CLIENTE+SD2->D2_LOJA)
		Else
			DbSelectArea("SA1")
			DbSetOrder(1)
			DbSeek(xFilial("SA1")+SD2->D2_CLIENTE+SD2->D2_LOJA)
		Endif


		cRet := "VR IPI S/ "+IF(SD2->D2_TES$"522","BRINDE",IF(SD2->D2_TES$"521/691","DOACAO",IF(Substr(AllTrim(SD2->D2_CF),2,3)$"910","BONIF.",IF(Substr(AllTrim(SD2->D2_CF),2,3)$"151/152","TRANSF",IF(SF4->F4_DUPLIC="S","VENDA","OUTRAS OP")))))+" NF "+ SD2->D2_DOC

		If Rtrim(SD2->D2_CF) $"5917" .Or.  Rtrim(SD2->D2_CF) $"6917"
               cRet := "VR IPI S/  CONSIGNAÇÃO "+ SD2->D2_DOC
		Endif
	Endif

	If cLP = "610" .And. cSeq = "103" .And. cTipo = "H"
	   
	   If SF2->F2_TIPO=="D" .Or. SF2->F2_TIPO=="B"
			DbSelectArea("SA2")
			DbSetOrder(1)
			DbSeek(xFilial("SA2")+SD2->D2_CLIENTE+SD2->D2_LOJA)
		Else
			DbSelectArea("SA1")
			DbSetOrder(1)
			DbSeek(xFilial("SA1")+SD2->D2_CLIENTE+SD2->D2_LOJA)
		Endif


		cRet := "VR ICMS ST S/ "+IF(SD2->D2_TES$"522","BRINDE",IF(SD2->D2_TES$"521/691","DOACAO",IF(Substr(AllTrim(SD2->D2_CF),2,3)$"910","BONIF.",IF(SF4->F4_DUPLIC="S","VENDA","OUTRAS OP"))))+" NF "+ SD2->D2_DOC+" "+Substr(SA1->A1_NREDUZ,1,18)       

		If Rtrim(SD2->D2_CF) $"5917" .Or.  Rtrim(SD2->D2_CF) $"6917"
               cRet := "VR ICMS ST S/ "+ SD2->D2_DOC
		Endif
	Endif



	If cLP = "610" .And. cSeq = "117" .And. cTipo = "H"
		cRet :=  "VR ICMS ST S/ "+IF(SD2->D2_TES$"522","BRINDE",IF(SD2->D2_TES$"521/691","DOACAO",IF(Substr(AllTrim(SD2->D2_CF),2,3)$"910","BONIF.",IF(SF4->F4_DUPLIC="S","VENDA","OUTRAS OP"))))+" NF "+ SD2->D2_DOC
	Endif

	If cLP = "610" .And. cSeq = "118" .And. cTipo = "H"

	    If SF2->F2_TIPO=="D" .Or. SF2->F2_TIPO=="B"
			DbSelectArea("SA2")
			DbSetOrder(1)
			DbSeek(xFilial("SA2")+SD2->D2_CLIENTE+SD2->D2_LOJA)
		Else
			DbSelectArea("SA1")
			DbSetOrder(1)
			DbSeek(xFilial("SA1")+SD2->D2_CLIENTE+SD2->D2_LOJA)
		Endif

		cRet := "VR IPI S/ "+IF(SD2->D2_TES$"522","BRINDE",IF(SD2->D2_TES$"521/691","DOACAO",IF(Substr(AllTrim(SD2->D2_CF),2,3)$"910","BONIF.",IF(Substr(AllTrim(SD2->D2_CF),2,3)$"151/152","TRANSF",IF(SF4->F4_DUPLIC="S","VENDA","OUTRAS OP")))))+" NF "+ SD2->D2_DOC
	Endif

	If cLP = "610" .And. cSeq = "120" .And. cTipo = "H"

	     If SF2->F2_TIPO=="D" .Or. SF2->F2_TIPO=="B"
			DbSelectArea("SA2")
			DbSetOrder(1)
			DbSeek(xFilial("SA2")+SD2->D2_CLIENTE+SD2->D2_LOJA)
		Else
			DbSelectArea("SA1")
			DbSetOrder(1)
			DbSeek(xFilial("SA1")+SD2->D2_CLIENTE+SD2->D2_LOJA)
		Endif

		cRet := "VR ICMS S/ "+IF(SD2->D2_TES$"522","BRINDE",IF(SD2->D2_TES$"521/691","DOACAO",IF(Substr(AllTrim(SD2->D2_CF),2,3)$"910","BONIF.",IF(Substr(AllTrim(SD2->D2_CF),2,3)$"151/152","TRANSF",IF(SF4->F4_DUPLIC="S","REPOS.","OUTRAS OP")))))+" NF "+ SD2->D2_DOC+Iif(SF2->F2_TIPO="D" .Or. SF2->F2_TIPO="B",Substr(SA2->A2_NOME,1,18),Substr(SA1->A1_NREDUZ,1,18))
	Endif

	If cLP = "610" .And. cSeq = "105" .And. cTipo = "H"

	     If SF2->F2_TIPO=="D" .Or. SF2->F2_TIPO=="B"
			DbSelectArea("SA2")
			DbSetOrder(1)
			DbSeek(xFilial("SA2")+SD2->D2_CLIENTE+SD2->D2_LOJA)
		Else
			DbSelectArea("SA1")
			DbSetOrder(1)
			DbSeek(xFilial("SA1")+SD2->D2_CLIENTE+SD2->D2_LOJA)
		Endif

		cRet := "VR PIS S/ VENDA NF " + SD2->D2_DOC+" "+Substr(SA1->A1_NREDUZ,1,18)                                                                                                                     
	Endif

	If cLP = "610" .And. cSeq = "106" .And. cTipo = "H"

	     If SF2->F2_TIPO=="D" .Or. SF2->F2_TIPO=="B"
			DbSelectArea("SA2")
			DbSetOrder(1)
			DbSeek(xFilial("SA2")+SD2->D2_CLIENTE+SD2->D2_LOJA)
		Else
			DbSelectArea("SA1")
			DbSetOrder(1)
			DbSeek(xFilial("SA1")+SD2->D2_CLIENTE+SD2->D2_LOJA)
		Endif

		cRet := "VR COFINS S/ VENDA NF " + SD2->D2_DOC+" "+Substr(SA1->A1_NREDUZ,1,18)                                                                                                                
	Endif

	If cLP = "610" .And. cSeq = "121" .And. cTipo = "H"

	    If SF2->F2_TIPO=="D" .Or. SF2->F2_TIPO=="B"
			DbSelectArea("SA2")
			DbSetOrder(1)
			DbSeek(xFilial("SA2")+SD2->D2_CLIENTE+SD2->D2_LOJA)
		Else
			DbSelectArea("SA1")
			DbSetOrder(1)
			DbSeek(xFilial("SA1")+SD2->D2_CLIENTE+SD2->D2_LOJA)
		Endif


		cRet :=  "VR IPI S/ "+IF(SD2->D2_TES$"522","BRINDE",IF(SD2->D2_TES$"521/691","DOACAO",IF(Substr(AllTrim(SD2->D2_CF),2,3)$"910","BONIF.",IF(Substr(AllTrim(SD2->D2_CF),2,3)$"151/152","TRANSF",IF(SF4->F4_DUPLIC="S","REPOS.","OUTRAS OP")))))+" NF "+ SD2->D2_DOC+Iif(SF2->F2_TIPO="D" .Or. SF2->F2_TIPO="B",Substr(SA2->A2_NOME,1,18),Substr(SA1->A1_NREDUZ,1,18))
	Endif

	If cLP = "630" .And. cSeq = "102" .And. cTipo = "H"

	    If SF2->F2_TIPO=="D" .Or. SF2->F2_TIPO=="B"
			DbSelectArea("SA2")
			DbSetOrder(1)
			DbSeek(xFilial("SA2")+SD2->D2_CLIENTE+SD2->D2_LOJA)
		Else
			DbSelectArea("SA1")
			DbSetOrder(1)
			DbSeek(xFilial("SA1")+SD2->D2_CLIENTE+SD2->D2_LOJA)
		Endif

		cRet := "CANC VR ICMS S/ "+IF(SD2->D2_TES$"522","BRINDE",IF(SD2->D2_TES$"521/691","DOACAO",IF(Substr(AllTrim(SD2->D2_CF),2,3)$"910","BONIF.",IF(Substr(AllTrim(SD2->D2_CF),2,3)$"151/152","TRANSF",IF(SF4->F4_DUPLIC="S","VENDA","OUTRAS OP")))))+" NF "+ SD2->D2_DOC
	Endif


	If cLP = "630" .And. cSeq = "104" .And. cTipo = "H"

	    If SF2->F2_TIPO=="D" .Or. SF2->F2_TIPO=="B"
			DbSelectArea("SA2")
			DbSetOrder(1)
			DbSeek(xFilial("SA2")+SD2->D2_CLIENTE+SD2->D2_LOJA)
		Else
			DbSelectArea("SA1")
			DbSetOrder(1)
			DbSeek(xFilial("SA1")+SD2->D2_CLIENTE+SD2->D2_LOJA)
		Endif


		cRet := "CANC"+" VR IPI S/ "+IF(SD2->D2_TES$"522","BRINDE",IF(SD2->D2_TES$"521/691","DOACAO",IF(Substr(AllTrim(SD2->D2_CF),2,3)$"910","BONIF.",IF(Substr(AllTrim(SD2->D2_CF),2,3)$"151/152","TRANSF",IF(SF4->F4_DUPLIC="S","VENDA","OUTRAS OP")))))+" NF "+ SD2->D2_DOC
	Endif


	If cLP = "630" .And. cSeq = "116" .And. cTipo = "H"
	     
		 If SF2->F2_TIPO=="D" .Or. SF2->F2_TIPO=="B"
			DbSelectArea("SA2")
			DbSetOrder(1)
			DbSeek(xFilial("SA2")+SD2->D2_CLIENTE+SD2->D2_LOJA)
		Else
			DbSelectArea("SA1")
			DbSetOrder(1)
			DbSeek(xFilial("SA1")+SD2->D2_CLIENTE+SD2->D2_LOJA)
		Endif


		cRet :=  "CANC. "+"VR ICMS S/ "+IF(SD2->D2_TES$"522","BRINDE",IF(SD2->D2_TES$"521/691","DOACAO",IF(Substr(AllTrim(SD2->D2_CF),2,3)$"910","BONIF.",IF(Substr(AllTrim(SD2->D2_CF),2,3)$"151/152","TRANSF",IF(SF4->F4_DUPLIC="S","VENDA","OUTRAS OP")))))+" NF "+ SD2->D2_DOC
	Endif

	If cLP = "630" .And. cSeq = "118" .And. cTipo = "H"

	    If SF2->F2_TIPO=="D" .Or. SF2->F2_TIPO=="B"
			DbSelectArea("SA2")
			DbSetOrder(1)
			DbSeek(xFilial("SA2")+SD2->D2_CLIENTE+SD2->D2_LOJA)
		Else
			DbSelectArea("SA1")
			DbSetOrder(1)
			DbSeek(xFilial("SA1")+SD2->D2_CLIENTE+SD2->D2_LOJA)
		Endif


		cRet := "CANC. "+"VR IPI S/ "+IF(SD2->D2_TES$"522","BRINDE",IF(SD2->D2_TES$"521/691","DOACAO",IF(Substr(AllTrim(SD2->D2_CF),2,3)$"910","BONIF.",IF(Substr(AllTrim(SD2->D2_CF),2,3)$"151/152","TRANSF",IF(SF4->F4_DUPLIC="S","VENDA","OUTRAS OP")))))+" NF "+ SD2->D2_DOC
	Endif

	If cLP = "630" .And. cSeq = "120" .And. cTipo = "H"

	    If SF2->F2_TIPO=="D" .Or. SF2->F2_TIPO=="B"
			DbSelectArea("SA2")
			DbSetOrder(1)
			DbSeek(xFilial("SA2")+SD2->D2_CLIENTE+SD2->D2_LOJA)
		Else
			DbSelectArea("SA1")
			DbSetOrder(1)
			DbSeek(xFilial("SA1")+SD2->D2_CLIENTE+SD2->D2_LOJA)
		Endif


		cRet := "CAN ICMS S/ "+IF(SD2->D2_TES$"522","BRINDE",IF(SD2->D2_TES$"521/691","DOACAO",IF(Substr(AllTrim(SD2->D2_CF),2,3)$"910","BONIF.",IF(Substr(AllTrim(SD2->D2_CF),2,3)$"151/152","TRANSF",IF(SF4->F4_DUPLIC="S","REPOS.","OUTRAS OP")))))+" NF "+ SD2->D2_DOC
	Endif

	If cLP = "630" .And. cSeq = "121" .And. cTipo = "H"

	    If SF2->F2_TIPO=="D" .Or. SF2->F2_TIPO=="B"
			DbSelectArea("SA2")
			DbSetOrder(1)
			DbSeek(xFilial("SA2")+SD2->D2_CLIENTE+SD2->D2_LOJA)
		Else
			DbSelectArea("SA1")
			DbSetOrder(1)
			DbSeek(xFilial("SA1")+SD2->D2_CLIENTE+SD2->D2_LOJA)
		Endif


		cRet := "CAN IPI S/ "+IF(SD2->D2_TES$"522","BRINDE",IF(SD2->D2_TES$"521/691","DOACAO",IF(Substr(AllTrim(SD2->D2_CF),2,3)$"910","BONIF.",IF(Substr(AllTrim(SD2->D2_CF),2,3)$"151/152","TRANSF",IF(SF4->F4_DUPLIC="S","REPOS.","OUTRAS OP")))))+" NF "+ SD2->D2_DOC
	Endif

	If cLP = "630" .And. cSeq = "101" .And. cTipo = "H"

	     If SF2->F2_TIPO=="D" .Or. SF2->F2_TIPO=="B"
			DbSelectArea("SA2")
			DbSetOrder(1)
			DbSeek(xFilial("SA2")+SD2->D2_CLIENTE+SD2->D2_LOJA)
		Else
			DbSelectArea("SA1")
			DbSetOrder(1)
			DbSeek(xFilial("SA1")+SD2->D2_CLIENTE+SD2->D2_LOJA)
		Endif


		cRet := "CANC "+IF((SF4->F4_DUPLIC="S"),"VR.VENDAS NF."+SD2->D2_DOC+" "+Substr(SA1->A1_NREDUZ,1,18),IF((Substr(AllTrim(SF4->F4_CF),2,3)$"910"),"SAIDA BRINDE/BONIF.NF."+SD2->D2_DOC+" "+Substr(SA1->A1_NREDUZ,1,18),IIF(SD2->D2_EST=="EX","VR EXPORTACAO NF "+SD2->D2_DOC+" "+Substr(SA1->A1_NREDUZ,1,18),"OUTRAS OP NF"+SD2->D2_DOC+" "+Substr(SA1->A1_NREDUZ,1,18))))
	Endif



Return(cRet)
