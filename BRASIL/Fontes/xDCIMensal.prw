#Include "Protheus.Ch" 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DCIMensal ºAutor  ³Sueli               º Data ³  25.05.06    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³DCI Mensal - Declaracao de Controle de Internacao Mensal     º±±
±±º          ³para Zona Franca de Manaus								   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function xDCIMensal(cAls,lIndiv)

	Local lRet := .T.
	Private cIndSF3	:= ""

	Default lIndiv	 := .F.

	If MontPainel(lIndiv)
		Processa({||ProcessaReg(@cAls,lIndiv)})
	Else
		lRet := .F.
	Endif

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao	 ³ProcessaReg ºAutor  ³Sueli C. dos Santos º Data ³  19/04/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Faz o processamento de forma a montar os arquivos temporariosº±±
±±º          ³para carregar os Registros do Arquivo.                     	º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MATA909                                                  	º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ProcessaReg(cAls,lIndiv)

	Private aCfp := {}
	Private cIndSF3	:= ""
/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³Parametros															    ³
³mv_par01 - Data Inicial       ?     									³
³mv_par02 - Data Final         ?   										³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/
	PRIVATE	dDtIni	 :=	mv_par01
	PRIVATE	dDtFim	 :=	mv_par02

	Default lIndiv	 := .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Lê a Wizard com as perguntas                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	If !lIndiv
		xMagLeWiz("DCIMENSAL",@aCfp,.T.)
	Else
		xMagLeWiz("DCIINDIVI",@aCfp,.T.)  //com outro nome
	EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria arquivos temporarios       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	CRTemp(@cAls)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta arquivo de Trabalho                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	MontaTrab(lIndiv)

return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao   ³ApagTemp    ºAutor  ³ Sueli C.dos Santos º Data ³  19/04/06  º±±
±±ÌÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.    ³ Apaga arquivos temporarios criados para gerar o arquivo     º±±
±±º         ³ Magnetico                                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso      ³ MATA909                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function ApagTemp(cAls)

	If File(cAls+GetDBExtension())
		dbSelectArea("R00")
		dbCloseArea()
		Ferase(cAls+GetDBExtension())
		Ferase(cAls+OrdBagExt())
	Endif

	If File(cAls+GetDBExtension())
		dbSelectArea("R01")
		dbCloseArea()
		Ferase(cAls+GetDBExtension())
		Ferase(cAls+OrdBagExt())
	Endif

	If File(cAls+GetDBExtension())
		dbSelectArea("R03")
		dbCloseArea()
		Ferase(cAls+GetDBExtension())
		Ferase(cAls+OrdBagExt())
	Endif

	If File(cals+GetDBExtension())
		dbSelectArea("R11")
		dbCloseArea()
		Ferase(cAls+GetDBExtension())
		Ferase(cAls+OrdBagExt())
	Endif

	If File(cAls+GetDBExtension())
		dbSelectArea("R12")
		dbCloseArea()
		Ferase(cAls+GetDBExtension())
		Ferase(cAls+OrdBagExt())
	Endif

	If File(cAls+GetDBExtension())
		dbSelectArea("R13")
		dbCloseArea()
		Ferase(cAls+GetDBExtension())
		Ferase(cAls+OrdBagExt())
	Endif

	If File(cAls+GetDBExtension())
		dbSelectArea("R14")
		dbCloseArea()
		Ferase(cAls+GetDBExtension())
		Ferase(cAls+OrdBagExt())
	Endif

	If File(cAls+GetDBExtension())
		dbSelectArea("R21")
		dbCloseArea()
		Ferase(cAls+GetDBExtension())
		Ferase(cAls+OrdBagExt())
	Endif

	If File(cAls+GetDBExtension())
		dbSelectArea("R31")
		dbCloseArea()
		Ferase(cAls+GetDBExtension())
		Ferase(cAls+OrdBagExt())
	Endif

	If File(cAls+GetDBExtension())
		dbSelectArea("R32")
		dbCloseArea()
		Ferase(cAls+GetDBExtension())
		Ferase(cAls+OrdBagExt())
	Endif

	If File(cAls+GetDBExtension())
		dbSelectArea("R33")
		dbCloseArea()
		Ferase(cAls+GetDBExtension())
		Ferase(cAls+OrdBagExt())
	Endif

	If File(cAls+GetDBExtension())
		dbSelectArea("R34")
		dbCloseArea()
		Ferase(cAls+GetDBExtension())
		Ferase(cAls+OrdBagExt())
	Endif

	If File(cAls+GetDBExtension())
		dbSelectArea("R35")
		dbCloseArea()
		Ferase(cAls+GetDBExtension())
		Ferase(cAls+OrdBagExt())
	Endif
	If File(cAls+GetDBExtension())
		dbSelectArea("R36")
		dbCloseArea()
		Ferase(cAls+GetDBExtension())
		Ferase(cAls+OrdBagExt())
	Endif
	If File(cAls+GetDBExtension())
		dbSelectArea("R41")
		dbCloseArea()
		Ferase(cAls+GetDBExtension())
		Ferase(cAls+OrdBagExt())
	Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFunction³ MontaTrab  ºAutor  ³Sueli C.Santos      º Data ³  25/04/06   º±±
±±ÌÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.   ³Armazena as informacoes nos arquivos temporarios para depois  º±±
±±º        ³gerar arquivo texto.                                          º±±
±±ÌÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso     ³ MATA909                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MontaTrab(lIndiv)

	LOCAL cCNPJ	:=	""
	Local cAliasSF3 := "SF3"
	Local cEntrada := ""
	Local cEntradaI := ""
	Local cInsumo := ""
	Local cLocal:=""
	Local lProdLocal := IIf(SB1->(FieldPos("B1_DCI"))>0 .And. SB1->(FieldPos("B1_DCR"))>0 .And. SB1->(FieldPos("B1_DCRE"))>0  .And. ;
		SB1->(FieldPos("B1_DCRII"))>0 .And. SB1->(FieldPos("B1_COEFDCR"))>0,.T.,.F.)
	Local cPessoa	:= ""
	Local cNDI 		:= ""
	Local cNADICAO		:= ""
	Local cNITEMAD		:= ""
	Local lB5BENDL := SB5->(FieldPos("B5_BENDL")) > 0
	Local aDI  := {}
	Local _nLin

	#IFDEF TOP
		Local nSF3	   := 0
	#ENDIF

	Private _aEstrut    := {}
	Private _l21        := .F.
	Private _aArea
	Private nNivel  := 2
	Private _aEstrut2  := {}  //Array com a explosão da estrutura

	Default lIndiv   := .F.

	DbSelectArea("CD5")
	CD5->(DbSetOrder(4))


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Registro Header - R00 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	IF SUBSTR(Alltrim(aCfp[1][04]),1,1)$"1"
		cEntrada := "1"
	ELSEIF SUBSTR(Alltrim(aCfp[1][04]),1,1)$"2"
		cEntrada:="2"
	ELSE
		cEntrada:="3"
	END IF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Tipo de Documento do Entrada do Insumo - R00 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	IF SUBSTR(Alltrim(aCfp[1][05]),1,1)$"1"
		cEntradaI := "1"
	ELSEIF SUBSTR(Alltrim(aCfp[1][05]),1,1)$"2"
		cEntradaI:="2"
	ELSE
		cEntradaI:="3"
	END IF

	#IFDEF TOP
		If TcSrvType() <> "AS/400"
			cAliasSF3:= "aMontaTrab"
			lQuery    := .T.
			aStruSF3  := SF3->(dbStruct())
			cQuery := "SELECT SF3.F3_FILIAL,SF3.F3_ENTRADA,SF3.F3_DTCANC,SF3.F3_ESPECIE, "
			cQuery += "SF3.F3_TIPO,SF3.F3_CFO,SF3.F3_ESTADO,SF3.F3_VALCONT,SF3.F3_BASEICM, "
			cQuery += "SF3.F3_VALICM,SF3.F3_ISENICM,SF3.F3_OUTRICM,SF3.F3_ICMSRET, "
			cQuery += "SF3.F3_CLIEFOR,SF3.F3_LOJA,SF3.F3_NFISCAL,SF3.F3_EMISSAO, "
			cQuery += "SF3.F3_SERIE "
			cQuery += IIf(SF3->(FieldPos("F3_TRFICM"))>0,",SF3.F3_TRFICM "," ")
			cQuery += "FROM "
			cQuery += RetSqlName("SF3") + " SF3 "
			cQuery += "WHERE "
			cQuery += "SF3.F3_FILIAL = '"+xFilial("SF3")+"' AND "  
			cQuery += "SF3.F3_CFO NOT IN ('3201')           AND "

			If !lIndiv
				cQuery += "SF3.F3_ENTRADA >= '"+DTOS(dDtIni)+"' AND "
				cQuery += "SF3.F3_ENTRADA <= '"+DTOS(dDtFim)+"' AND "
			Else
				cQuery += "SF3.F3_ENTRADA = '"+aCfp[3][01]+"' AND "
				cQuery += "SF3.F3_NFISCAL = '"+aCfp[3][02]+"' AND "
				cQuery += "SF3.F3_SERIE = '"+aCfp[3][03]+"' AND "
				cQuery += "SF3.F3_CLIEFOR = '"+aCfp[3][04]+"' AND "
				cQuery += "SF3.F3_LOJA = '"+aCfp[3][05]+"' AND "
			EndIf

			cQuery += "SF3.D_E_L_E_T_ = ' '"

			cQuery := ChangeQuery(cQuery)

			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSF3,.T.,.T.)

			For nSF3 := 1 To Len(aStruSF3)
				If aStruSF3[nSF3][2] <> "C" .and. FieldPos(aStruSF3[nSF3][1]) > 0
					TcSetField(cAliasSF3,aStruSF3[nSF3][1],aStruSF3[nSF3][2],aStruSF3[nSF3][3],aStruSF3[nSF3][4])
				EndIf
			Next nSF3

		Else
		#ENDIF
		dbSelectArea(cAliasSF3)
		cIndSF3	:=	CriaTrab(NIL,.F.)
		cChave	:=	IndexKey()
		cFiltro	:=	"F3_FILIAL=='"+xFilial("SF3")+"'"

		cFiltro	+=	".And. DTOS(F3_ENTRADA)>='"+DTOS(dDtIni)+"'.AND.DTOS(F3_ENTRADA)<='"+DTOS(dDtFim)+"'"


		IndRegua(cAliasSF3,cIndSF3,cChave,,cFiltro,"DTREF")
		#IFDEF TOP
		Endif
	#ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Registro Header - R00 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	HeaderMensal(lIndiv)

	If (cAliasSF3)->F3_TIPO$"BD"
		SA2->(dbSetOrder(1))
		SA2->(dbSeek(xFilial("SA2")+(cAliasSF3)->F3_CLIEFOR+(cAliasSF3)->F3_LOJA))
		cCNPJ := aFisFill(aRetDig(SA2->A2_CGC,.F.),14)
		cPessoa := IIf(SA2->A2_TIPO=="J","1","2")
	Else
		SA1->(dbSetOrder(1))
		SA1->(dbSeek(xFilial("SA1")+(cAliasSF3)->F3_CLIEFOR+(cAliasSF3)->F3_LOJA))
		cCNPJ := aFisFill(aRetDig(SA1->A1_CGC,.F.),14)
		cPessoa := IIf(SA1->A1_PESSOA=="J","1","2")
	EndIf

//Registro R01
	DadosMensais(lIndiv,cAliasSF3, cCNPJ, cPessoa)

	If (cAliasSF3)->(Eof())
		//Alert("Notas Fiscais não encontradas!")
	EndIf

	While (cAliasSF3)->(!Eof()).and. xFilial("SF3")==(cAliasSF3)->F3_FILIAL

		cMesRef := SUBSTR(Dtos(SF3->F3_ENTRADA),1,6)  //verifica o mes corrente

		If Substr((cAliasSF3)->F3_CFO,1,1)$"5,6,7"
			If Empty((cAliasSF3)->F3_DTCANC)
				dbSelectArea("SD2")
				dbSetOrder(3)
				dbSeek(xFilial("SD2")+(cAliasSF3)->F3_NFISCAL+(cAliasSF3)->F3_SERIE+(cAliasSF3)->F3_CLIEFOR+(cAliasSF3)->F3_LOJA)

				While !Eof() .And. xFilial("SD2") == SD2->D2_FILIAL .And. ;
						SD2->D2_DOC == (cAliasSF3)->F3_NFISCAL .And. SD2->D2_SERIE == (cAliasSF3)->F3_SERIE .And. ;
						SD2->D2_CLIENTE == (cAliasSF3)->F3_CLIEFOR .And. SD2->D2_LOJA == (cAliasSF3)->F3_LOJA

					SB1->(dbSetOrder(1))
					If SB1->(dbSeek(xFilial("SB1")+SD2->D2_COD)) .And. SB1->B1_ORIGEM=="1"
						cLocal := ALLTRIM(STR(IIf(SD2->D2_EST == "AM",1,IIf(SD2->D2_EST $ "AC/AP/AM/RO/RR",3,IIf(SD2->D2_EST $"AC/AP/RO/RR",4,2)))))
						IF !R11->(dbSeek(cMesRef+SB1->B1_COD+cLocal))
							RecLock("R11",.T.)
							R11->DTREF	:=	cMesRef
							R11->CODINT := SB1->B1_COD
							R11->DEST := cLocal
						ELSE
							RecLock("R11",.F.)
						END IF
						R11->NFITEM := Val(SD2->D2_ITEM)
						R11->CODNCM := SubStr(SB1->B1_POSIPI,1,8)
						R11->CDESC   := SB1->B1_DESC
						R11->CDDEST := IIf(SD2->D2_EST == "AM",1,IIf(SD2->D2_EST $ "AC/AP/AM/RO/RR",3,IIf(SD2->D2_EST $"AC/AP/RO/RR",4,2)))
						R11->QUNTOT := SD2->D2_QUANT
						R11->QTOT   := SD2->D2_QUANT
						SAH->(dbSetOrder(1))
					// Unidade do produto
						SAH->(dbSeek(xFilial("SAH")+AllTrim (SB1->B1_UM)))
						R11->UNIMED  :=SAH->AH_DESCPO
					// Unidade comercializada
						SAH->(dbSeek(xFilial("SAH")+SD2->D2_UM))
						R11->UNIDADE := SAH->AH_DESCPO
						R11->QUANTID := SD2->D2_QUANT
						R11->VALUNIT := SD2->D2_PRCVEN
						R11->IPIDESTA := SD2->D2_VALIPI
						MsUnlock()
					ElseIf SB1->(dbSeek(xFilial("SB1")+SD2->D2_COD)) .And. SB1->B1_ORIGEM=="0"
						IF !R41->(dbSeek(cMesRef+SB1->B1_COD))
							RecLock("R41",.T.)
							R41->DTREF	:=	cMesRef
							R41->CDPROD := SB1->B1_COD //Codigo interno do Produto
						ELSE
							RecLock("R41",.F.)
						ENDIF
						R41->NFITEM := Val(SD2->D2_ITEM)
						R41->QTDUNI := SD2->D2_QUANT
						R41->VUNIT := SD2->D2_PRCVEN
						R41->QTDNCM := SD2->D2_QUANT

						R41->CDNCM := SubStr(SB1->B1_POSIPI,1,8)
						R41->CDESC  := SB1->B1_DESC  //Descricao do Produto
						SAH->(dbSetOrder(1))
						SAH->(dbSeek(xFilial("SAH")+AllTrim (SB1->B1_UM)))
						R41->UNIMED :=SAH->AH_DESCPO  //Unidade de Medida
						R41->VTOTUN += SD2->D2_PRCVEN
						R41->QTPROD += SD2->D2_QUANT//Qtde total do produto na unidade comercializada
						R41->QTPRODE += SD2->D2_QUANT
						MsUnlock()

					//##################################
					//Faz a explosão da estrutura      #
					//##################################
						_l21  := .F.


						DbSelectArea("SG1")
						DbSetOrder(1)
						If dbSeek(xFilial("SG1")+SD2->D2_COD)
							_aEstrut := GeraExpl(SD2->D2_COD,If(SB1->B1_QB == 0,1,SB1->B1_QB),nNivel,SB1->B1_OPC,SG1->G1_QUANT)
							_aArea := GetArea()
							For _nLin := 1 to len(_aEstrut)
								DbSelectArea("SB1")
								DbSetOrder(1)
								If DbSeek(xFilial("SB1")+_aEstrut[_nlin][3]) .And. SB1->B1_ORIGEM == "1"
									_l21  := .T.
									Exit
								Endif
							Next _nLin

							RestArea(_aArea)

							DbSelectArea("SB1")
							DbSetOrder(1)
							DbSeek(xFilial("SB1")+SD2->D2_COD)


							cLocal := ALLTRIM(STR(IIf(SD2->D2_EST == "AM",1,IIf(SD2->D2_EST $ "AC/AP/AM/RO/RR",3,IIf(SD2->D2_EST $"AC/AP/RO/RR",4,2)))))

							If lProdLocal .And. SB1->B1_DCI == "1"  .And. _l21

								If !R21->(dbSeek(cMesRef+SB1->B1_COD+Alltrim(cLocal)))
									RecLock("R21",.T.)
									R21->DTREF	:=	cMesRef
									R21->CDDEST  := Alltrim(cLocal)
									R21->CDPROD := SB1->B1_COD
								Else
									RecLock("R21",.F.)
								Endif
								SAH->(dbSetOrder(1))
								SAH->(dbSeek(xFilial("SAH")+AllTrim (SB1->B1_UM)))
								R21->NRITEM 	:= Val(SD2->D2_ITEM) // GRAZI
								R21->DCRE      	:= IIF(!Empty(SB1->B1_DCRE),val(SB1->B1_DCRE),0)
								R21->DCR		:= IIF(Empty(SB1->B1_DCRE),val(SB1->B1_DCR),0)
								R21->CDESC 		:= SB1->B1_DESC
								R21->VUNDOL		:= IIF(!Empty(SB1->B1_DCR),SB1->B1_DCRII,0)
								R21->CREDUCAO	:= IIF(!Empty(SB1->B1_DCR),SB1->B1_COEFDCR,0)
								R21->QTDPROD 	+= SD2->D2_QUANT
								R21->QUANT  	+= SD2->D2_QUANT
								R21->UNIMED 	:= IIF(!Empty(SB1->B1_DCR),SAH->AH_DESCPO,"")
						//15/04/2015 Vitor Merguizo - Solicitado pela Claudia e Rogerio zerar os valores de pis e cofins.
						//R21->VPIS		+= SD2->D2_VALIMP6
						//R21->VCOFINS 	+= SD2->D2_VALIMP5
								R21->QTDPROD 	+= SD2->D2_QUANT
								MsUnlock()
							Endif
						Endif
					EndIf

					If SB1->(dbSeek(xFilial("SB1")+SD2->D2_COD)) .And. !SB1->B1_ORIGEM=="0"
						SB5->(dbSetOrder(1))
						SB5->(dbSeek(xFilial("SB5")+SB1->B1_COD))
						cInsumo:= IIF(SB5->(FieldPos("B5_PINSUMO")) == 0,"N",IIF(Empty(SB5->B5_PINSUMO),"N",SB5->B5_PINSUMO))

						cLocal := STR(IIf(SD2->D2_EST == "AM",1,IIf(SD2->D2_EST $ "AC/AP/AM/RO/RR",3,IIf(SD2->D2_EST $"AC/AP/RO/RR",4,2)))) //Locasl de destino (1 - Amazonia Ocidental)

						IF lProdLocal .And. SB1->B1_DCI == "2"
							IF !R31->(dbSeek(cMesRef+SB1->B1_COD+Alltrim(cLocal)))
								RecLock("R31",.T.)
								R31->DTREF	:=	cMesRef
								R31->DEST := Alltrim(cLocal)
								R31->CDPROD := SB1->B1_COD
							ELSE
								RecLock("R31",.F.)
							ENDIF

							R31->CDESC   := SB1->B1_DESC
							R31->NFITEM := Val(SD2->D2_ITEM)
							R31->QUANT  := SD2->D2_QUANT
							R31->VALUNIT  := SD2->D2_PRCVEN
							SAH->(dbSetOrder(1))
							SAH->(dbSeek(xFilial("SAH")+AllTrim (SB1->B1_UM)))
							R31->UNIMED  :=SAH->AH_DESCPO
							R31->DNCM := Val(SubStr(SB1->B1_POSIPI,1,8))
							R31->DESTINO := IIf(SD2->D2_EST == "AM",1,IIf(SD2->D2_EST $ "AC/AP/AM/RO/RR",3,IIf(SD2->D2_EST $"AC/AP/RO/RR",4,2))) //Locasl de destino (1 - Amazonia Ocidental)
							R31->QDEST   += IIF(R31->DESTINO==1,SD2->D2_QUANT,0) //Se Destino=1 informar a quantidade internada do produto, senao preencher com zeros
							R31->DESTINO2 := IIf(SD2->D2_EST == "AM",1,IIf(SD2->D2_EST $ "AC/AP/AM/RO/RR",3,IIf(SD2->D2_EST $"AC/AP/RO/RR",4,2))) //Locasl de destino (1 - Amazonia Ocidental)  //Local de Destino (2 - Demais Regioes)
							R31->QDEST2  += IIF(R31->DESTINO==2,SD2->D2_QUANT,0) //Se Destino=2, informar a quantidade internada do produto, senao preencher com zeros
							R31->DESTINO3 := IIf(SD2->D2_EST == "AM",1,IIf(SD2->D2_EST $ "AC/AP/AM/RO/RR",3,IIf(SD2->D2_EST $"AC/AP/RO/RR",4,2))) //Locasl de destino (1 - Amazonia Ocidental)  //Local de Destino (3 - ALC situada dentro da Amazonia Ocidental)
							R31->QDEST3 += IIF(R31->DESTINO==3,SD2->D2_QUANT,0) //Se Destino=3, informar a quantidade internada do produto, senao preencher com zeros
							R31->DESTINO4 := IIf(SD2->D2_EST == "AM",1,IIf(SD2->D2_EST $ "AC/AP/AM/RO/RR",3,IIf(SD2->D2_EST $"AC/AP/RO/RR",4,2))) //Locasl de destino (1 - Amazonia Ocidental) //Local de Destino (4 - ALC situada fora da Amazonia Ocidental)
							R31->QDEST4  += IIF(R31->DESTINO==4,SD2->D2_QUANT,0)//Se Destino=4, informar a quantidade internada do produto, senao preencher com zeros
							MsUnlock()
						ElseIf lProdLocal .And. SB1->B1_DCI == "1"
							If !R21->(dbSeek(cMesRef+SB1->B1_COD+Alltrim(cLocal)))
								RecLock("R21",.T.)
								R21->DTREF	:=	cMesRef
								R21->CDDEST  := Alltrim(cLocal)
								R21->CDPROD := SB1->B1_COD
							Else
								RecLock("R21",.F.)
							Endif
							SAH->(dbSetOrder(1))
							SAH->(dbSeek(xFilial("SAH")+AllTrim (SB1->B1_UM)))
							R21->NRITEM 	:= Val(SD2->D2_ITEM) // GRAZI
							R21->DCRE      	:= IIF(!Empty(SB1->B1_DCRE),val(SB1->B1_DCRE),0)
							R21->DCR		:= IIF(Empty(SB1->B1_DCRE),val(SB1->B1_DCR),0)
							R21->CDESC 		:= SB1->B1_DESC
							R21->VUNDOL		:= IIF(!Empty(SB1->B1_DCR),SB1->B1_DCRII,0)
							R21->CREDUCAO	:= IIF(!Empty(SB1->B1_DCR),SB1->B1_COEFDCR,0)
							R21->QTDPROD 	+= SD2->D2_QUANT
							R21->QUANT  	+= SD2->D2_QUANT
							R21->UNIMED 	:= IIF(!Empty(SB1->B1_DCR),SAH->AH_DESCPO,"")
						//15/04/2015 Vitor Merguizo - Solicitado pela Claudia e Rogerio zerar os valores de pis e cofins.
						//R21->VPIS		+= SD2->D2_VALIMP6
						//R21->VCOFINS 	+= SD2->D2_VALIMP5
							R21->QTDPROD 	+= SD2->D2_QUANT
							MsUnlock()
						EndIf
   					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Verifica se o Item e Insumo ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						IF cInsumo=="S"

							IF !R32->(dbSeek(cMesRef+SB1->B1_COD))
								RecLock("R32",.T.)
								R32->DTREF	:=	cMesRef
								R32->CDPROD := SB1->B1_COD //Codigo interno do Produto
							ELSE
								RecLock("R32",.F.)
							ENDIF


							R32->CDISUM := SB1->B1_COD //Codigo interno do Insumo
							R32->CDNCM  := SubStr(SB1->B1_POSIPI,1,8)
							R32->DNCM  := SB1->B1_DESC//Descricao Insumo
							SAH->(dbSetOrder(1))
							SAH->(dbSeek(xFilial("SAH")+AllTrim (SB1->B1_UM)))
							R32->UNIMED  := SAH->AH_DESCPO  //Unidade de Medida
							R32->QTINSUM += SD2->D2_QUANT //Qtde do Insumo
							MsUnlock()

							IF !R33->(dbSeek(cMesRef+SB1->B1_COD))
								RecLock("R33",.T.)
								R33->DTREF	:=	cMesRef
								R33->CDISUM := SB1->B1_COD //Codigo interno do Insumo
							ELSE
								RecLock("R33",.F.)
							ENDIF

							R33->QTOTINS  += SD2->D2_QUANT//Qtde total do Insumo
							R33->LOCDEST  := R31->DESTINO //Local de Destino ,de cada Local informado do Reg 31
							R33->QTINSD  += SD2->D2_QUANT//Qtde total do Insumo internado para o Local de Destino
							MsUnlock()
						EndIF
					ElseIf SB1->(dbSeek(xFilial("SB1")+SD2->D2_COD)) .And. SB1->B1_ORIGEM=="0"
						IF !R41->(dbSeek(cMesRef+SB1->B1_COD))
							RecLock("R41",.T.)
							R41->DTREF	:=	cMesRef
							R41->CDPROD := SB1->B1_COD //Codigo interno do Produto
						ELSE
							RecLock("R41",.F.)
						ENDIF

						R41->CDNCM := SubStr(SB1->B1_POSIPI,1,8)
						R41->CDESC  := SB1->B1_DESC  //Descricao do Produto
						SAH->(dbSetOrder(1))
						SAH->(dbSeek(xFilial("SAH")+AllTrim (SB1->B1_UM)))
						R41->UNIMED :=SAH->AH_DESCPO  //Unidade de Medida
						R41->VTOTUN += SD2->D2_PRCVEN
						R41->QTPROD += SD2->D2_QUANT//Qtde total do produto na unidade comercializada
						R41->QTPRODE += SD2->D2_QUANT
						MsUnlock()
					EndIf


					dbSelectArea("SD2")
					dbSkip()
				EndDo
			Endif

		ELSEIF Substr((cAliasSF3)->F3_CFO,1,1)$"3" .And. (cAliasSF3)->F3_ESTADO =="EX" .And. (cAliasSF3)->F3_TIPO <>"D"
			If Empty((cAliasSF3)->F3_DTCANC)
				dbSelectArea("SD1")
				dbSetOrder(1)
				dbSeek(xFilial("SD1")+(cAliasSF3)->F3_NFISCAL+(cAliasSF3)->F3_SERIE+(cAliasSF3)->F3_CLIEFOR+(cAliasSF3)->F3_LOJA)

				While !Eof() .And. xFilial("SD1") == SD1->D1_FILIAL .And. ;
						SD1->D1_DOC == (cAliasSF3)->F3_NFISCAL .And. SD1->D1_SERIE == (cAliasSF3)->F3_SERIE .And. ;
						SD1->D1_FORNECE == (cAliasSF3)->F3_CLIEFOR .And. SD1->D1_LOJA == (cAliasSF3)->F3_LOJA

					aDI  := {}

					SB1->(dbSetOrder(1))
					If SB1->(dbSeek(xFilial("SB1")+SD1->D1_COD)) .And. !SB1->B1_ORIGEM=="0"
						SB5->(dbSetOrder(1))
						SB5->(dbSeek(xFilial("SB5")+SB1->B1_COD))
						If cEntrada$"1"
							IF !R12->(dbSeek(cMesRef+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_ITEM))
								RecLock("R12",.T.)
								R12->DTREF	:=	cMesRef
								R12->NF2 := If(cEntrada$"1",SD1->D1_DOC,0)
								R12->SERIE:= If(cEntrada$"1",SD1->D1_SERIE,"")
							ELSE
								RecLock("R12",.F.)
							END IF
					  	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Verifica se o documento de entrada ulitizado e uma Nota FIscal ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							R12->CNPJFOR := Val(If(cEntrada$"1",cCNPJ,0))
							R12->NF := If(cEntrada$"1",SD1->D1_DOC,0)
							R12->NRITEMNOTA:=val(If(cEntrada$"1",SD1->D1_ITEM,0))
							R12->EMISSAO:= val(If(cEntrada$"1",Dtos(SD1->D1_EMISSAO),0))
							R12->CFOP := Val(If(cEntrada$"1",SD1->D1_CF,0))
							R12->DL288 := IF(SB5->(FieldPos("B5_BENDL")) == 0,"N",IF(Empty(SB5->B5_BENDL),"N",SB5->B5_BENDL))
							R12->OBSOLE := If(cEntrada$"1",If(R12->DL288=="S","S","N"),"N")
							R12->QUANT:= If(cEntrada$"1",SD1->D1_QUANT,0)
							R12->VLUNIT :=  If(cEntrada$"1",If(R12->DL288=="S" .AND. R12->OBSOLE=="N",SD1->D1_VUNIT,0),0)
							R12->VLOBSOLE := If(cEntrada$"1",If(R12->OBSOLE=="S" ,SD1->D1_TOTAL,0),0)
							MsUnlock()
						ElseIf	cEntrada$"2"
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Verifica se o documento de entrada ulitizado e uma DI ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

							cNDI 		:= Replicate("0",10)
							cNADICAO	:= "000"
							cNITEMAD	:= "00"
							If CD5->(DbSeek(xFilial("CD5")+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_ITEM))
								cNDI 		:= Left(CD5->CD5_NDI,10)
								cNADICAO	:= CD5->CD5_NADIC
								cNITEMAD	:= Left(CD5->CD5_SQADIC,2)
							Else

								If SD1->D1_TIPO_NF == "6"
									aadd(aDI,(GetNFEIMP(.F.,SD1->D1_DOC,SD1->D1_SERIE,SD1->D1_FORNECE,SD1->D1_LOJA,'5',SD1->D1_PEDIDO,SD1->D1_ITEMPC)))

									cNDI 		:= Left(aDI[1][4][3],10)
									cNADICAO	:= StrZero(aDI[1][10][3],3)
									cNITEMAD	:= StrZero(aDI[1][11][3],2)

									For _nlin:=1 to len(aDI[1])

										If aDI[1][_nlin][2] == "nDI"
											cNDI 		:= Left(aDI[1][_nlin][3],10)
										ElseIf aDI[1][_nlin][2] == "nAdicao"
											cNADICAO	:= StrZero(aDI[1][_nlin][3],3)
										ElseIf aDI[1][_nlin][2] == "nSeqAdi"
											cNITEMAD	:= StrZero(aDI[1][_nlin][3],2)
										Endif

									Next _nlin

								Else
									aadd(aDI,(GetNFEIMP(.F.,SD1->D1_DOC,SD1->D1_SERIE,SD1->D1_FORNECE,SD1->D1_LOJA,SD1->D1_TIPO_NF,SD1->D1_PEDIDO,SD1->D1_ITEMPC)))


									For _nlin:=1 to len(aDI[1])

										If aDI[1][_nlin][2] == "nDI"
											cNDI 		:= Left(aDI[1][_nlin][3],10)
										ElseIf aDI[1][_nlin][2] == "nAdicao"
											cNADICAO	:= StrZero(aDI[1][_nlin][3],3)
										ElseIf aDI[1][_nlin][2] == "nSeqAdi"
											cNITEMAD	:= StrZero(aDI[1][_nlin][3],2)
										Endif

									Next _nlin

								Endif

							Endif

							IF SD1->D1_TES = '318'
								IF !R13->(dbSeek(cMesRef))
									RecLock("R13",.T.)
									R13->DTREF	:=	cMesRef
								ELSE
									RecLock("R13",.F.)
								ENDIF
								R13->NDI			:= cNDI
								R13->NDIANT		:= Replicate("0",15)
								R13->NADICAO		:= cNADICAO
								R13->NITEMAD		:= cNITEMAD
								R13->DL288			:= IIf(lB5BENDL .And. !Empty(SB5->B5_BENDL), SB5->B5_BENDL, "N")
								R13->OBSOLE		:= IIf(AllTrim(R13->DL288) == "S", "S", "N")
								R13->QUANT			:= SD1->D1_QUANT
								R13->VUNIT			:= SD1->D1_VUNIT
								R13->SUSPPISCOF	:= "N"
								MsUnlock()
							ENDIF
						Else
							IF !R14->(dbSeek(cMesRef))
								RecLock("R14",.T.)
								R14->DTREF	:=	cMesRef
							ELSE
								RecLock("R14",.F.)
							ENDIF

							R14->SUSPPISCOF:= "N"
							MsUnlock()
						EndIf
					EndIf
					dbSelectArea("SD1")
					dbSkip()
				EndDo
			Endif

		ELSEIF Substr((cAliasSF3)->F3_CFO,1,1)$"1/2"
			If Empty((cAliasSF3)->F3_DTCANC)
				dbSelectArea("SD1")
				dbSetOrder(1)
				dbSeek(xFilial("SD1")+(cAliasSF3)->F3_NFISCAL+(cAliasSF3)->F3_SERIE+(cAliasSF3)->F3_CLIEFOR+(cAliasSF3)->F3_LOJA)

				While !Eof() .And. xFilial("SD1") == SD1->D1_FILIAL .And. ;
						SD1->D1_DOC == (cAliasSF3)->F3_NFISCAL .And. SD1->D1_SERIE == (cAliasSF3)->F3_SERIE .And. ;
						SD1->D1_FORNECE == (cAliasSF3)->F3_CLIEFOR .And. SD1->D1_LOJA == (cAliasSF3)->F3_LOJA

					SB1->(dbSetOrder(1))
					If SB1->(dbSeek(xFilial("SB1")+SD1->D1_COD)) .And. !SB1->B1_ORIGEM=="0"

						SB5->(dbSetOrder(1))
						SB5->(dbSeek(xFilial("SB5")+SB1->B1_COD))
						cInsumo:= IIF(SB5->(FieldPos("B5_PINSUMO")) == 0,"N",IIF(Empty(SB5->B5_PINSUMO),"N",SB5->B5_PINSUMO))

	    	       	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Verifica se o Item e Insumo ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						IF cInsumo=="S"
							If cEntradaI$"1"
								IF !R34->(dbSeek(cMesRef+SD1->D1_DOC+SD1->D1_SERIE))
									RecLock("R34",.T.)
									R34->DTREF	:=	cMesRef
									R34->NF2 := If(cEntradaI$"1",SD1->D1_DOC,0)
									R34->SERIE:= If(cEntradaI$"1",SD1->D1_SERIE,"")
								ELSE
									RecLock("R34",.F.)
								END IF

						  	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³Verifica se o documento de entrada ulitizado e uma Nota FIscal ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								R34->CNPJFOR := Val(If(cEntradaI$"1",cCNPJ,0))
								R34->NF := If(cEntradaI$"1",SD1->D1_DOC,0)
								R34->NRITEMNOTA:=val(If(cEntradaI$"1",SD1->D1_ITEM,0))
								R34->EMISSAO:= val(If(cEntradaI$"1",Dtos(SD1->D1_EMISSAO),0))
								R34->CFOP := Val(If(cEntradaI$"1",SD1->D1_CF,0))
								SB5->(dbSetOrder(1))
								SB5->(dbSeek(xFilial("SB5")+SB1->B1_COD))
								R34->DL288 := IF(SB5->(FieldPos("B5_BENDL")) == 0,"N",IF(Empty(SB5->B5_BENDL),"N",SB5->B5_BENDL))
								R34->QTINSUMO:= If(cEntradaI$"1",SD1->D1_QUANT,0)
								R34->VLUNIT :=  If(cEntradaI$"1",SD1->D1_VUNIT,0)  //Valor Unitario Insumo
								R34->CDISUM := If(cEntradaI$"1",SB1->B1_COD,0) //Codigo interno do Insumo
								R34->LOCDEST := If(cEntradaI$"1",R33->LOCDEST,0)  //Local de Destino ,de cada Local informado do Reg 33
								MsUnlock()

							ElseIf cEntradaI$"2"
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³Verifica se o documento de entrada ulitizado e um DI ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								IF !R35->(dbSeek(cMesRef))
									RecLock("R35",.T.)
									R35->DTREF	:=	cMesRef
								ELSE
									RecLock("R35",.F.)
								END IF

								R35->DL288 := "N"
								R35->SUSPPISCOF := "N"
								MsUnlock()
							Else
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³Verifica se o documento de entrada ulitizado e um DSI ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								IF !R36->(dbSeek(cMesRef))
									RecLock("R36",.T.)
									R36->DTREF	:=	cMesRef
								ELSE
									RecLock("R36",.F.)
								END IF

								R36->SUSPPISCOF:= "N"
								MsUnlock()
							EndIf
						EndIf
					EndIf
					dbSelectArea("SD1")
					dbSkip()
				EndDo
			Endif
		Endif
		(cAliasSF3)->( dbSkip() )
	EndDo

	If lQuery
		dbSelectArea(cAliasSF3)
		dbCloseArea()
		Ferase(cIndSF3+OrdBagExt())
		dbSelectArea("SF3")
		RetIndex("SF3")
	Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao  ³CRTemp      ºAutor  ³Sueli C. Santos     º Data ³  25.05.06   º±±
±±ÌÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.   ³Cria todos os arquivos temporarios necessarios a geracao da   º±±
±±º        ³DS                                                            º±±
±±ÌÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso     ³                                                              º±±
±±ÈÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function CRTemp(cAls)

	LOCAL aCampos	:=	{}
	Local oTable

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ`¿
//³Atenção ao alterar, pois existem 2 arquivos .INI que utilizam essa mesma estrutura, ³
//³o DCIMENSAL.ini e o DCIINDIV.ini                                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ`Ù

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Registro Header - R00	³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	AADD(aCampos,{"DTREF"	,"N"	,006,0})
	AADD(aCampos,{"NRINSES"	,"N"	,014,0})
	AADD(aCampos,{"SERIE"	,"C"	,005,0})
	AADD(aCampos,{"NFISCAL"	,"C"	,TamSX3("F2_DOC")[1],0})
	AADD(aCampos,{"CNPJINT" ,"N"	,014,0})
	AADD(aCampos,{"VERS"    ,"C"    ,005,0})

	//cAls := CriaTrab(aCampos) 			//Função CriaTrab descontinuada, adicionado o oTable no lugar
	oTable := FWTemporaryTable():New("R00") //adicionado\Ajustado
	oTable:SetFields(aCampos)				//adicionado\Ajustado
	oTable:AddIndex("01",{"DTREF"})
	oTable:Create()							//adicionado\Ajustado
	cAls := oTable:GetRealName()			//adicionado\Ajustado
	//dbUseArea(.T.,"TOPCONN",cAls,"R00")		//adicionado o driver TOPCONN \Ajustado
	//IndRegua("R00",cAls,"DTREF")


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Registro DCI Mensal - R01³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aCampos	:= {}
	cAls	:= ""
	AADD(aCampos,{"DTREF"   ,"N"	,006,0})
	AADD(aCampos,{"CNPJINT" ,"N"	,014,0})
	AADD(aCampos,{"NRINSES"	,"N"	,014,0})
	AADD(aCampos,{"SERIE"	,"C"	,005,0})
	AADD(aCampos,{"NFISCAL"	,"C"	,TamSX3("F2_DOC")[1],0})
	AADD(aCampos,{"DTEMISS"	,"C"	,008,0})
	AADD(aCampos,{"DTSAIDA"	,"C"	,008,0})
	AADD(aCampos,{"CODCFOP"	,"C"	,004,0})
	AADD(aCampos,{"TPPESSOA","C"	,001,0})
	AADD(aCampos,{"CPFCNPJ"	,"C"	,014,0})
	AADD(aCampos,{"UFDEST"	,"C"	,002,0})
	AADD(aCampos,{"INTERNAC","C"	,001,0})
	AADD(aCampos,{"NBCO"	,"N"	,003,0})
	AADD(aCampos,{"NAG" 	,"N"	,004,0})
	AADD(aCampos,{"NCC"	    ,"C"	,019,0})

	//cAls := CriaTrab(aCampos) 			//Função CriaTrab descontinuada, adicionado o oTable no lugar
	oTable := FWTemporaryTable():New("R01") //adicionado \Ajustado
	oTable:SetFields(aCampos)				//adicionado \Ajustado
	oTable:AddIndex("01",{"DTREF"})
	oTable:Create()							//adicionado \Ajustado
	cAls := oTable:GetRealName()			//adicionado \Ajustado
	//dbUseArea(.T.,"TOPCONN",cAls,"R01")		//adicionado o driver TOPCONN \Ajustado
	//IndRegua("R01",cAls,"DTREF")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Registro DCI Mensal - R03³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	aCampos	:= {}
	cAls	:= ""
	AADD(aCampos,{"NRDCI"	,"N"	,010,0})
	AADD(aCampos,{"NRRET"	,"N"	,017,0})
	AADD(aCampos,{"VDIFPE"	,"N"	,015,2})
	AADD(aCampos,{"VMDIFPE"	,"N"	,015,2})
	AADD(aCampos,{"VJDIFPE"	,"N"	,015,2})
	AADD(aCampos,{"VIPIPE"	,"N"	,015,2})
	AADD(aCampos,{"VMIPIPE"	,"N"	,015,2})
	AADD(aCampos,{"VJIPIPE"	,"N"	,015,2})
	AADD(aCampos,{"VPISPE"	,"N"	,015,2})
	AADD(aCampos,{"VMPISPE"	,"N"	,015,2})
	AADD(aCampos,{"VJPISPE"	,"N"	,015,2})
	AADD(aCampos,{"VCOFPE"	,"N"	,015,2})
	AADD(aCampos,{"VMCOFPE"	,"N"	,015,2})
	AADD(aCampos,{"VJCOFPE"	,"N"	,015,2})
	AADD(aCampos,{"VPPB"	,"N"	,015,2})
	AADD(aCampos,{"VMPPB"	,"N"	,015,2})
	AADD(aCampos,{"VJPPB"	,"N"	,015,2})
	AADD(aCampos,{"VPISPPB"	,"N"	,015,2})
	AADD(aCampos,{"VMPISPPB","N"	,015,2})
	AADD(aCampos,{"VJPISPPB","N"	,015,2})
	AADD(aCampos,{"VCOFPPB"	,"N"	,015,2})
	AADD(aCampos,{"VMCOFPPB","N"	,015,2})
	AADD(aCampos,{"VJCOFPPB","N"	,015,2})
	AADD(aCampos,{"VPI"		,"N"	,015,2})
	AADD(aCampos,{"VMPI"	,"N"	,015,2})
	AADD(aCampos,{"VJPI"	,"N"	,015,2})
	AADD(aCampos,{"VIPIPI"	,"N"	,015,2})
	AADD(aCampos,{"VMIPIPI"	,"N"	,015,2})
	AADD(aCampos,{"VJIPIPI"	,"N"	,015,2})
	AADD(aCampos,{"VPISPI"	,"N"	,015,2})
	AADD(aCampos,{"VMPISPI"	,"N"	,015,2})
	AADD(aCampos,{"VJPISPI"	,"N"	,015,2})
	AADD(aCampos,{"VCOFPI"	,"N"	,015,2})
	AADD(aCampos,{"VMCOFPI"	,"N"	,015,2})
	AADD(aCampos,{"VJCOFPI"	,"N"	,015,2})
	//cAls := CriaTrab(aCampos) 			//Função CriaTrab descontinuada, adicionado o oTable no lugar
	oTable := FWTemporaryTable():New("R03") //adicionado\Ajustado
	oTable:SetFields(aCampos)				//adicionado\Ajustado
	oTable:AddIndex("01",{"NRDCI"})
	oTable:Create()							//adicionado\Ajustado
	cAls := oTable:GetRealName()			//adicionado\Ajustado
	//dbUseArea(.T.,"TOPCONN",cAls,"R03") 	//adicionado o driver TOPCONN \Ajustado
	//IndRegua("R03",cAls,"NRDCI")

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Registro Dados do Produto Local - R11³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	aCampos	:= {}
	cAls	:= ""
	AADD(aCampos,{"DTREF"   ,"N"	,006,0})
	AADD(aCampos,{"NFITEM"  ,"N"	,003,0})
	AADD(aCampos,{"CODNCM"  ,"C"	,008,0})
	AADD(aCampos,{"CODINT"  ,"C"	,015,0})
	AADD(aCampos,{"DEST"    ,"C"	,001,0})
	AADD(aCampos,{"CDDEST"  ,"N"	,001,0})
	AADD(aCampos,{"CDESC"   ,"C"    ,045,0})
	AADD(aCampos,{"TXJTEC"  ,"C"	,253,0})
	AADD(aCampos,{"ALIQTEC" ,"N"	,005,2})
	AADD(aCampos,{"TXIPI"   ,"C"	,253,0})
	AADD(aCampos,{"ALIQIPI" ,"N"	,005,2})
	AADD(aCampos,{"UNIDADE"	,"C"	,020,0})
	AADD(aCampos,{"QUANTID"	,"N"	,014,0})
	AADD(aCampos,{"QUNTOT"  ,"N"	,014,5})
	AADD(aCampos,{"VALUNIT"	,"N"	,020,0})
	AADD(aCampos,{"IPIDESTA","N"	,015,0})
	AADD(aCampos,{"QTOT"    ,"N"	,014,5})
	AADD(aCampos,{"UNIMED"	,"C"	,020,0})

	//cAls := CriaTrab(aCampos) 			//Função CriaTrab descontinuada, adicionado o oTable no lugar
	oTable := FWTemporaryTable():New("R11") //adicionado\Ajustado
	oTable:SetFields(aCampos)				//adicionado\Ajustado
	oTable:AddIndex("01",{"DTREF","CODINT","DEST"})
	oTable:Create()							//adicionado\Ajustado
	cAls := oTable:GetRealName()			//adicionado\Ajustado
	//dbUseArea(.T.,"TOPCONN",cAls,"R11") 	//adicionado o driver TOPCONN \Ajustado
	//IndRegua("R11",cAls,"DTREF+CODINT+DEST")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Registro de Nota Fiscal de Aquisição/ Produto Local - R12 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aCampos	:= {}
	cAls	:= ""
	AADD(aCampos,{"DTREF"       ,"C"	,006,0})
	AADD(aCampos,{"CNPJFOR"     ,"N"	,014,0})
	AADD(aCampos,{"SERIE"       ,"C"	,005,0})
	AADD(aCampos,{"NF"   		,"C"	,TamSX3("F2_DOC")[1],0})
	AADD(aCampos,{"NF2"   		,"C"	,TamSX3("F2_DOC")[1],0})
	AADD(aCampos,{"NRITEMNOTA" 	,"N"	,003,0})
	AADD(aCampos,{"EMISSAO"  	,"N"	,008,0})
	AADD(aCampos,{"CFOP"    	,"N"	,004,0})
	AADD(aCampos,{"DL288"   	,"C"	,001,0})
	AADD(aCampos,{"OBSOLE"		,"C"	,001,0})
	AADD(aCampos,{"QUANT"		,"N"	,014,5})
	AADD(aCampos,{"VLUNIT"	    ,"N"	,020,7})
	AADD(aCampos,{"VLOBSOLE"	,"N"	,015,2})

	//cAls := CriaTrab(aCampos) 			//Função CriaTrab descontinuada, adicionado o oTable no lugar
	oTable := FWTemporaryTable():New("R12") //adicionado\Ajustado
	oTable:SetFields(aCampos)				//adicionado\Ajustado
	oTable:AddIndex("01",{"DTREF","NF2","SERIE"})
	oTable:Create()							//adicionado\Ajustado
	cAls := oTable:GetRealName()			//adicionado\Ajustado
	//dbUseArea(.T.,"TOPCONN",cAls,"R12") 	//adicionado o driver TOPCONN \Ajustado
	//IndRegua("R12",cAls,"DTREF+NF2+SERIE")


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Registro DI/Produto Local - R13³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aCampos	:= {}
	cAls	:= ""
	AADD(aCampos,{"DTREF"   	,"C"	,006,0})
	AADD(aCampos,{"NDI"			,"C"	,010,0})
	AADD(aCampos,{"NDIANT"		,"C"	,015,0})
	AADD(aCampos,{"NADICAO"		,"C"	,003,0})
	AADD(aCampos,{"NITEMAD"		,"C"	,002,0})
	AADD(aCampos,{"DL288"		,"C"	,001,0})
	AADD(aCampos,{"OBSOLE"		,"C"	,001,0})
	AADD(aCampos,{"QUANT"		,"N"	,014,5})
	AADD(aCampos,{"VUNIT"		,"N"	,020,7})
	AADD(aCampos,{"MOEDANEG"	,"N"	,003,0})
	AADD(aCampos,{"VFRETE"	 	,"N"	,020,7})
	AADD(aCampos,{"MOEDFRETE" 	,"N"	,003,0})
	AADD(aCampos,{"VSEGURO"		,"N"	,020,7})
	AADD(aCampos,{"MOEDSEG"		,"N"	,003,0})
	AADD(aCampos,{"VTOBSOL"		,"N"	,015,2})
	AADD(aCampos,{"SUSPPISCOF"	,"C"	,001,0})

	//cAls := CriaTrab(aCampos) 			//Função CriaTrab descontinuada, adicionado o oTable no lugar
	oTable := FWTemporaryTable():New("R13") //adicionado\Ajustado
	oTable:SetFields(aCampos)				//adicionado\Ajustado
	oTable:AddIndex("01",{"DTREF"})
	oTable:Create()							//adicionado\Ajustado
	cAls := oTable:GetRealName()			//adicionado\Ajustado
	//dbUseArea(.T.,"TOPCONN",cAls,"R13") 	//adicionado o driver TOPCONN \Ajustado
	//IndRegua("R13",cAls,"DTREF")


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Registro DSI/ Produto Local - R14 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aCampos	:= {}
	cAls	:= ""
	AADD(aCampos,{"DTREF"		,"C"	,006,0})
	AADD(aCampos,{"NDSI"     	,"N"	,010,0})
	AADD(aCampos,{"NDSIANT"		,"N"	,015,0})
	AADD(aCampos,{"NRBEM"  		,"N"	,003,0})
	AADD(aCampos,{"QUANT" 		,"N"	,014,5})
	AADD(aCampos,{"VUNIT"   	,"N"	,020,7})
	AADD(aCampos,{"MOEDNEG"    	,"N"	,003,0})
	AADD(aCampos,{"VLFRETE"   	,"N"	,020,7})
	AADD(aCampos,{"MOEDFRETE"	,"N"	,003,0})
	AADD(aCampos,{"VSEGURO"		,"N"	,020,7})
	AADD(aCampos,{"MOEDSEG"	    ,"N"	,003,0})
	AADD(aCampos,{"SUSPPISCOF"	,"C"	,001,0})

	//cAls := CriaTrab(aCampos) 			//Função CriaTrab descontinuada, adicionado o oTable no lugar
	oTable := FWTemporaryTable():New("R14") //adicionado\Ajustado
	oTable:SetFields(aCampos)				//adicionado\Ajustado
	oTable:AddIndex("01",{"DTREF"})
	oTable:Create()							//adicionado\Ajustado
	cAls := oTable:GetRealName()			//adicionado\Ajustado
	//dbUseArea(.T.,"TOPCONN",cAls,"R14") 	//adicionado o driver TOPCONN \Ajustado
	//IndRegua("R14",cAls,"DTREF")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Registro Produto Local da DCI Mensal/PI com PPB - R21³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	aCampos	:= {}
	cAls	:= ""
	AADD(aCampos,{"DTREF"   ,"C"	,006,0})
	AADD(aCampos,{"NRITEM"  ,"N"	,003,0})
	AADD(aCampos,{"CDDEST"  ,"C"	,001,0})
	AADD(aCampos,{"DCRE"    ,"N"    ,010,0})
	AADD(aCampos,{"CDPROD"  ,"C"	,015,0}) //Codigo interno do Produto
	AADD(aCampos,{"DCR "    ,"N"	,009,0})
	AADD(aCampos,{"CDESC"   ,"C"	,045,0}) //Descricao do Produto
	AADD(aCampos,{"VUNDOL" 	,"N"	,020,7}) // Valor Unitario do produto em dolar
	AADD(aCampos,{"CREDUCAO","N"	,005,2})// Coeficiente de Reducao do produto
	AADD(aCampos,{"QTDPROD"	,"N"	,014,0})
	AADD(aCampos,{"QUANT"	,"N"	,014,5})
	AADD(aCampos,{"UNIMED"	,"C"	,020,0})
	AADD(aCampos,{"VPIS"	,"N"	,020,7}) //Valor PIS/PASEP a ser recolhido
	AADD(aCampos,{"VCOFINS"	,"N"	,020,7})

	//cAls := CriaTrab(aCampos) 			//Função CriaTrab descontinuada, adicionado o oTable no lugar
	oTable := FWTemporaryTable():New("R21") //adicionado\Ajustado
	oTable:SetFields(aCampos)				//adicionado\Ajustado
	oTable:AddIndex("01",{"DTREF","CDPROD","CDDEST"})
	oTable:Create()							//adicionado\Ajustado
	cAls := oTable:GetRealName()			//adicionado\Ajustado
	//dbUseArea(.T.,"TOPCONN",cAls,"R21") 	//adicionado o driver TOPCONN \Ajustado
	//IndRegua("R21",cAls,"DTREF+CDPROD+CDDEST")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Registro Produto Local da DCI Mensal/PI sem PPB - R31³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aCampos	:= {}
	cAls	:= ""
	AADD(aCampos,{"DTREF"   ,"C"	,006,0})
	AADD(aCampos,{"NFITEM"  ,"N"	,003,0})
	AADD(aCampos,{"CDPROD"  ,"C"	,015,0}) //Codigo interno do Produto
	AADD(aCampos,{"CDESC"   ,"C"	,045,0}) //Descricao do Produto
	AADD(aCampos,{"UNIMED"  ,"C"    ,020,0}) //Unidade de Medida
	AADD(aCampos,{"DNCM"    ,"N"	,008,0})
	AADD(aCampos,{"QUANT"	,"N"	,014,0})
	AADD(aCampos,{"VALUNIT" ,"N"	,020,0})
	AADD(aCampos,{"DEST"	,"C"	,001,0}) //Locasl de destino (1 - Amazonia Ocidental)
	AADD(aCampos,{"DESTINO"	,"N"	,001,0}) //Locasl de destino (1 - Amazonia Ocidental)
	AADD(aCampos,{"QDEST"	,"N"	,014,5}) //Se Destino=1 informar a quantidade internada do produto, senao preencher com zeros
	AADD(aCampos,{"DESTINO2","N"	,001,0}) //Local de Destino (2 - Demais Regioes)
	AADD(aCampos,{"QDEST2"	,"N"	,014,5}) //Se Destino=2, informar a quantidade internada do produto, senao preencher com zeros
	AADD(aCampos,{"DESTINO3","N"	,001,0}) //Local de Destino (3 - ALC situada dentro da Amazonia Ocidental)
	AADD(aCampos,{"QDEST3"	,"N"	,014,5}) //Se Destino=3, informar a quantidade internada do produto, senao preencher com zeros
	AADD(aCampos,{"DESTINO4","N"	,001,0}) //Local de Destino (4 - ALC situada fora da Amazonia Ocidental)
	AADD(aCampos,{"QDEST4"	,"N"	,014,5}) //Se Destino=4, informar a quantidade internada do produto, senao preencher com zeros

	//cAls := CriaTrab(aCampos) 			//Função CriaTrab descontinuada, adicionado o oTable no lugar
	oTable := FWTemporaryTable():New("R31") //adicionado\Ajustado
	oTable:SetFields(aCampos)				//adicionado\Ajustado
	oTable:AddIndex("01",{"DTREF","CDPROD","DEST"})
	oTable:Create()							//adicionado\Ajustado
	cAls := oTable:GetRealName()			//adicionado\Ajustado
	//dbUseArea(.T.,"TOPCONN",cAls,"R31") 	//adicionado o driver TOPCONN \Ajustado
	//IndRegua("R31",cAls,"DTREF+CDPROD+DEST")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Registro Matriz Produto/Insumo do Item da DCI Mensal - R32³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	aCampos	:= {}
	cAls	:= ""
	AADD(aCampos,{"DTREF"   ,"C"	,006,0})
	AADD(aCampos,{"FILLER1" ,"N"	,003,0})
	AADD(aCampos,{"CDPROD"  ,"C"	,015,0}) //Codigo interno do Produto
	AADD(aCampos,{"CDISUM"  ,"C"	,015,0}) //Codigo interno do Insumo
	AADD(aCampos,{"CDNCM"   ,"C"	,008,0})
	AADD(aCampos,{"DNCM"    ,"C"	,045,0}) //Descricao Insumo
	AADD(aCampos,{"UNIMED"  ,"C"    ,020,0}) //Unidade de Medida
	AADD(aCampos,{"QTINSUM"	,"N"	,014,5}) //Qtde do Insumo

	//cAls := CriaTrab(aCampos) 			//Função CriaTrab descontinuada, adicionado o oTable no lugar
	oTable := FWTemporaryTable():New("R32") //adicionado\Ajustado
	oTable:SetFields(aCampos)				//adicionado\Ajustado
	oTable:AddIndex("01",{"DTREF","CDPROD"})
	oTable:Create()							//adicionado\Ajustado
	cAls := oTable:GetRealName()			//adicionado\Ajustado
	//dbUseArea(.T.,"TOPCONN",cAls,"R32") 	//adicionado o driver TOPCONN \Ajustado
	//IndRegua("R32",cAls,"DTREF+CDPROD")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Registro Insumo do Produto Local - R33 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aCampos	:= {}
	cAls	:= ""
	AADD(aCampos,{"DTREF"   ,"C"	,006,0})
	AADD(aCampos,{"FILLER1" ,"N"	,003,0})
	AADD(aCampos,{"CDISUM"  ,"C"	,015,0}) //Codigo interno do Insumo
	AADD(aCampos,{"QTOTINS" ,"N"	,014,5}) //Qtde total do Insumo
	AADD(aCampos,{"LOCDEST" ,"N"	,001,0}) //Local de Destino ,de cada Local informado do Reg 31
	AADD(aCampos,{"TXTEC"   ,"C"    ,253,0}) //Divergencia TEC
	AADD(aCampos,{"ALIQTEC"	,"N"	,005,2}) //Divergencia de Aliquota TEC
	AADD(aCampos,{"TXIPI"   ,"C"    ,253,0}) //Divergencia IPI
	AADD(aCampos,{"ALIQIPI"	,"N"	,005,2}) //Divergencia de Aliquota IPI
	AADD(aCampos,{"QTINSD"  ,"N" 	,014,5}) //Qtde total do Insumo internado para o Local de Destino

	//cAls := CriaTrab(aCampos) 			//Função CriaTrab descontinuada, adicionado o oTable no lugar
	oTable := FWTemporaryTable():New("R33") //adicionado\Ajustado
	oTable:SetFields(aCampos)				//adicionado\Ajustado
	oTable:AddIndex("01",{"DTREF","CDISUM"})
	oTable:Create()							//adicionado\Ajustado
	cAls := oTable:GetRealName()			//adicionado\Ajustado
	//dbUseArea(.T.,"TOPCONN",cAls,"R33") 	//adicionado o driver TOPCONN \Ajustado
	//IndRegua("R33",cAls,"DTREF+CDISUM")



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Registro NF/Insumo do Produto Local - R34³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aCampos	:= {}
	cAls	:= ""
	AADD(aCampos,{"DTREF"       ,"C"	,006,0})
	AADD(aCampos,{"CNPJFOR"     ,"N"	,014,0})
	AADD(aCampos,{"SERIE"       ,"C"	,005,0})
	AADD(aCampos,{"NF"   		,"C"	,TamSX3("F2_DOC")[1],0})
	AADD(aCampos,{"NF2"   		,"C"	,TamSX3("F2_DOC")[1],0})
	AADD(aCampos,{"NRITEMNOTA" 	,"N"	,003,0})
	AADD(aCampos,{"EMISSAO"  	,"N"	,008,0})
	AADD(aCampos,{"CFOP"    	,"N"	,004,0})
	AADD(aCampos,{"DL288"   	,"C"	,001,0})
	AADD(aCampos,{"QTINSUMO"	,"N"	,014,5})
	AADD(aCampos,{"VLUNIT"	    ,"N"	,020,7}) //Valor Unitario Insumo
	AADD(aCampos,{"CDISUM"      ,"C"	,015,0}) //Codigo interno do Insumo
	AADD(aCampos,{"LOCDEST"     ,"N"	,001,0}) //Local de Destino ,de cada Local informado do Reg 33

	//cAls := CriaTrab(aCampos) 			//Função CriaTrab descontinuada, adicionado o oTable no lugar
	oTable := FWTemporaryTable():New("R34") //adicionado\Ajustado
	oTable:SetFields(aCampos)				//adicionado\Ajustado
	oTable:AddIndex("01",{"DTREF","NF2","SERIE"})
	oTable:Create()							//adicionado\Ajustado
	cAls := oTable:GetRealName()			//adicionado\Ajustado
	//dbUseArea(.T.,"TOPCONN",cAls,"R34") 	//adicionado o driver TOPCONN \Ajustado
	//IndRegua("R34",cAls,"DTREF+NF2+SERIE")


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Registro DI/Produto Local - R35³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aCampos	:= {}
	cAls	:= ""
	AADD(aCampos,{"DTREF"   	,"C"	,006,0})
	AADD(aCampos,{"NDI"			,"N"	,010,0})
	AADD(aCampos,{"NDIANT"		,"N"	,015,0})
	AADD(aCampos,{"NADICAO"		,"N"	,003,0})
	AADD(aCampos,{"NITEMAD"		,"N"	,002,0})
	AADD(aCampos,{"DL288"		,"C"	,001,0})
	AADD(aCampos,{"QUANT"		,"N"	,014,5})
	AADD(aCampos,{"VUNIT"		,"N"	,020,7})
	AADD(aCampos,{"MOEDANEG"	,"N"	,003,0})
	AADD(aCampos,{"VFRETE"	 	,"N"	,020,7})
	AADD(aCampos,{"MOEDFRETE" 	,"N"	,003,0})
	AADD(aCampos,{"VSEGURO"		,"N"	,020,7})
	AADD(aCampos,{"MOEDSEG"		,"N"	,003,0})
	AADD(aCampos,{"CDISUM"      ,"C"	,015,0}) //Codigo interno do Insumo
	AADD(aCampos,{"LOCDEST"     ,"N"	,001,0}) //Local de Destino ,de cada Local informado do Reg 33
	AADD(aCampos,{"SUSPPISCOF"	,"C"	,001,0})

	//cAls := CriaTrab(aCampos) 			//Função CriaTrab descontinuada, adicionado o oTable no lugar
	oTable := FWTemporaryTable():New("R35") //adicionado\Ajustado
	oTable:SetFields(aCampos)				//adicionado\Ajustado
	oTable:AddIndex("01",{"DTREF"})
	oTable:Create()							//adicionado\Ajustado
	cAls := oTable:GetRealName()			//adicionado\Ajustado
	//dbUseArea(.T.,"TOPCONN",cAls,"R35") 	//adicionado o driver TOPCONN \Ajustado
	//IndRegua("R35",cAls,"DTREF")


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Registro DSI/ Produto Local - R36 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aCampos	:= {}
	cAls	:= ""
	AADD(aCampos,{"DTREF"		,"C"	,006,0})
	AADD(aCampos,{"NDSI"     	,"N"	,010,0})
	AADD(aCampos,{"NDSIANT"		,"N"	,015,0})
	AADD(aCampos,{"NRBEM"  		,"N"	,003,0})
	AADD(aCampos,{"QUANT" 		,"N"	,014,5})
	AADD(aCampos,{"CDISUM"      ,"C"	,015,0}) //Codigo interno do Insumo
	AADD(aCampos,{"LOCDEST"     ,"N"	,001,0}) //Local de Destino ,de cada Local informado do Reg 33
	AADD(aCampos,{"VUNIT"   	,"N"	,020,7})
	AADD(aCampos,{"MOEDNEG"    	,"N"	,003,0})
	AADD(aCampos,{"VLFRETE"   	,"N"	,020,7})
	AADD(aCampos,{"MOEDFRETE"	,"N"	,003,0})
	AADD(aCampos,{"VSEGURO"		,"N"	,020,7})
	AADD(aCampos,{"MOEDSEG"	    ,"N"	,003,0})
	AADD(aCampos,{"SUSPPISCOF"	,"C"	,001,0})

	//cAls := CriaTrab(aCampos) 			//Função CriaTrab descontinuada, adicionado o oTable no lugar
	oTable := FWTemporaryTable():New("R36") //adicionado\Ajustado
	oTable:SetFields(aCampos)				//adicionado\Ajustado
	oTable:AddIndex("01",{"DTREF"})
	oTable:Create()							//adicionado\Ajustado
	cAls := oTable:GetRealName()			//adicionado\Ajustado
	//dbUseArea(.T.,"TOPCONN",cAls,"R36") 	//adicionado o driver TOPCONN \Ajustado
	//IndRegua("R36",cAls,"DTREF")


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Registro Produto Local da DCI Mensal/PI sem PPB - R41³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aCampos	:= {}
	cAls	:= ""
	AADD(aCampos,{"DTREF"   ,"C"	,006,0})
	AADD(aCampos,{"NFITEM"  ,"N"	,003,0})
	AADD(aCampos,{"CDNCM"   ,"C"	,008,0})
	AADD(aCampos,{"CDPROD"  ,"C"	,015,0}) //Codigo interno do Produto
	AADD(aCampos,{"CDESC"    ,"C"	,045,0}) //Descricao do Produto
	AADD(aCampos,{"UNIMED"  ,"C"    ,020,0}) //Unidade de Medida
	AADD(aCampos,{"QTDUNI"	,"N"	,014,0})
	AADD(aCampos,{"QTDNCM"  ,"N"	,014,0})
	AADD(aCampos,{"VUNIT"   ,"N"	,020,0})
	AADD(aCampos,{"VTOTUN"  ,"N"	,015,2})
	AADD(aCampos,{"QTPROD"  ,"N"	,014,5}) //Qtde total do produto na unidade comercializada
	AADD(aCampos,{"QTPRODE" ,"N"	,014,5}) //Qtde total do produto na unidade de estatistica do NCM

	//cAls := CriaTrab(aCampos) 			//Função CriaTrab descontinuada, adicionado o oTable no lugar
	oTable := FWTemporaryTable():New("R41") //adicionado\Ajustado
	oTable:SetFields(aCampos)				//adicionado\Ajustado
	oTable:AddIndex("01",{"DTREF","CDPROD"})
	oTable:Create()							//adicionado\Ajustado
	cAls := oTable:GetRealName()			//adicionado\Ajustado
	//dbUseArea(.T.,"TOPCONN",cAls,"R41") 	//adicionado o driver TOPCONN \Ajustado
	//IndRegua("R41",cAls,"DTREF+CDPROD")

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³MontPainel³ Autor ³Sueli C. dos Santos    ³ Data ³25.05.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Preparacao do wizard para auxilio das informacoes necessa-  ³±±
±±³          ³ rias na composicao do meio-magnetico.                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³aWizard -> Array contendo as informacoes do wizard.         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function MontPainel(lIndiv)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Declaracao das variaveis³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Local aTxtPre 		:= {}
	Local aPaineis 		:= {}
	Local cTitObj1		:= ""
	Local cTitObj2		:= ""
	Local nPos		:= 0
	Local lRet		:= .F.

	Default	lIndiv		:= .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³            CUIDADO AO INCLUIR NOVO CAMPO NA WIZARD                  ³
//³                                                                     ³
//³Ao incluir nova posição da Wizard, avaliar se deve aparecer tanto na ³
//³DCI - Mensal quanto na DCI - Individual, e se a nova posição não     ³
//³altera as já existentes em ambas as opções.                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	If !lIndiv
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Monta wizard com as perguntas necessarias³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		AADD(aTxtPre,"Processamento da DCI Mensal - ZFM")
		AADD(aTxtPre,"")
		AADD(aTxtPre,"Preencha Corretamente as Informações Solicitadas.")
		AADD(aTxtPre,"Informações Necessarias para o Preenchimento Automático da                DCI-Mensal - ZFM.")

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Painel com as informacoes necessarias   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		aAdd(aPaineis,{})
		nPos :=	Len(aPaineis)
		aAdd(aPaineis[nPos],"Processamento da DCI Mensal")
		aAdd(aPaineis[nPos],"Dados de Identificação dos Registros DCI Mensal.")
		aAdd(aPaineis[nPos],{})

	Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Monta wizard com as perguntas necessarias³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		AADD(aTxtPre,"Processamento da DCI Individual - ZFM")
		AADD(aTxtPre,"")
		AADD(aTxtPre,"Preencha Corretamente as Informações Solicitadas.")
		AADD(aTxtPre,"Informações Necessarias para o Preenchimento Automático da                DCI-Individual - ZFM.")

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Painel com as informacoes necessarias   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		aAdd(aPaineis,{})
		nPos :=	Len(aPaineis)
		aAdd(aPaineis[nPos],"Processamento da DCI Individual")
		aAdd(aPaineis[nPos],"Dados de Identificação dos Registros DCI Individual.")
		aAdd(aPaineis[nPos],{})
	EndIf

	cTitObj1 :=	"Numero do Banco ?" 		//Cfp[1][01]
	cTitObj2 :=	"Numero da Agencia ?"   	//Cfp[1][02]
	aAdd(aPaineis[nPos][3],{1,cTitObj1,,,,,,})
	aAdd(aPaineis[nPos][3],{1,cTitObj2,,,,,,})
	aAdd(aPaineis[nPos][3],{2, ,"XXX", 1,,,,3})
	aAdd(aPaineis[nPos][3],{2, ,"XXXX", 1,,,,4})
	aAdd(aPaineis[nPos][3],{0,"",,,,,,})
	aAdd(aPaineis[nPos][3],{0,"",,,,,,})

	cTitObj1 :=	"Numero da Conta Corrente ?" //Cfp[1][03]
	cTitObj2 :=	"Tipo de Documento de Entrada do PE?"
	aAdd(aPaineis[nPos][3],{1,cTitObj1,,,,,,})
	aAdd(aPaineis[nPos][3],{1,cTitObj2,,,,,,})
	aAdd(aPaineis[nPos][3],{2, ,"XXXXXXXXXXXXXXXXXXX", 1,,,,19})
	aAdd(aPaineis[nPos][3],{3,,,,,{"1-Nota Fiscal","2-Documento de Importação","3-Documento Simplificado de Importação"},,})
	aAdd(aPaineis[nPos][3],{0,"",,,,,,})
	aAdd(aPaineis[nPos][3],{0,"",,,,,,})

	cTitObj1 :=	"Tipo de Documento de Entrada do Insumo ?" //Cfp[1][03]
	cTitObj2 :=	""
	aAdd(aPaineis[nPos][3],{1,cTitObj1,,,,,,})
	aAdd(aPaineis[nPos][3],{1,cTitObj2,,,,,,})
	aAdd(aPaineis[nPos][3],{3,,,,,{"1-Nota Fiscal","2-Documento de Importação","3-Documento Simplificado de Importação"},,})
	aAdd(aPaineis[nPos][3],{0, ,"", ,,,,})
	aAdd(aPaineis[nPos][3],{0,"",,,,,,})
	aAdd(aPaineis[nPos][3],{0,"",,,,,,})

	If !lIndiv
		aAdd(aPaineis,{})
		nPos :=	Len(aPaineis)
		aAdd(aPaineis[nPos],"Processamento da DCI Mensal")
		aAdd(aPaineis[nPos],"Dados de Identificação da Versão DCI Mensal.")
		aAdd(aPaineis[nPos],{})
	Else
		aAdd(aPaineis,{})
		nPos :=	Len(aPaineis)
		aAdd(aPaineis[nPos],"Processamento da DCI Individual")
		aAdd(aPaineis[nPos],"Dados de Identificação da Versão DCI Individual.")
		aAdd(aPaineis[nPos],{})
	EndIf

	cTitObj1 := "Versão da DCI(XX.XX):"       //Cfp[2][01]
	cTitObj2 := "NR DCI A RETIFICAR"          //Cfp[2][02]
	aAdd(aPaineis[nPos][3],{1,cTitObj1,,,,,,})
	aAdd(aPaineis[nPos][3],{1,cTitObj2,,,,,,})
	aAdd(aPaineis[nPos][3],{2, ,"XXXXX", 1,,,,5})
	aAdd(aPaineis[nPos][3],{2, ,Replicate("X",10), 1,,,,10})
	aAdd(aPaineis[nPos][3],{0,"",,,,,,})
	aAdd(aPaineis[nPos][3],{0,"",,,,,,})

	cTitObj1 := "VL MULTA DIF II(PE)"       //Cfp[2][03]
	cTitObj2 := "VL JUROS DIF II(PE)"       //Cfp[2][04]
	aAdd(aPaineis[nPos][3],{1,cTitObj1,,,,,,})
	aAdd(aPaineis[nPos][3],{1,cTitObj2,,,,,,})
	aAdd(aPaineis[nPos][3],{2, ,Replicate("X",15), 1,,,,15})
	aAdd(aPaineis[nPos][3],{2, ,Replicate("X",15), 1,,,,15})
	aAdd(aPaineis[nPos][3],{0,"",,,,,,})
	aAdd(aPaineis[nPos][3],{0,"",,,,,,})

	cTitObj1 := "VL DIF II(PE)"       //Cfp[2][05]
	cTitObj2 := ""
	aAdd(aPaineis[nPos][3],{1,cTitObj1,,,,,,})
	aAdd(aPaineis[nPos][3],{1,cTitObj2,,,,,,})
	aAdd(aPaineis[nPos][3],{2, ,Replicate("X",17), 1,,,,17})
	aAdd(aPaineis[nPos][3],{0, ,"", ,,,,})
	aAdd(aPaineis[nPos][3],{0,"",,,,,,})
	aAdd(aPaineis[nPos][3],{0,"",,,,,,})

	If lIndiv
		aAdd(aPaineis,{})
		nPos :=	Len(aPaineis)
		aAdd(aPaineis[nPos],"Processamento da DCI Individual")
		aAdd(aPaineis[nPos],"Preencha as informações da Nota Fiscal")
		aAdd(aPaineis[nPos],{})

		cTitObj1 := "Data"       //Cfp[3][01]
		aAdd(aPaineis[nPos][3],{1,cTitObj1,,,,,,})
		aAdd(aPaineis[nPos][3],{0,"",,,,,,})
		aAdd(aPaineis[nPos][3],{2, ,"@!", 3,,,,TAMSX3("A1_COD")[1]})
		aAdd(aPaineis[nPos][3],{0,"",,,,,,})
		aAdd(aPaineis[nPos][3],{0,"",,,,,,})
		aAdd(aPaineis[nPos][3],{0,"",,,,,,})

		cTitObj1 := "Nota Fiscal"       //Cfp[3][03]
		cTitObj2 := "Série"
		aAdd(aPaineis[nPos][3],{1,cTitObj1,,,,,,})
		aAdd(aPaineis[nPos][3],{1,cTitObj2,,,,,,})
		aAdd(aPaineis[nPos][3],{2, ,"@!", 1,,,,9})
		aAdd(aPaineis[nPos][3],{2, ,"@!", 1,,,,3})
		aAdd(aPaineis[nPos][3],{0,"",,,,,,})
		aAdd(aPaineis[nPos][3],{0,"",,,,,,})

		cTitObj1 := "Cliente/Fornecedor"       //Cfp[3][05]
		cTitObj2 := "Loja"
		aAdd(aPaineis[nPos][3],{1,cTitObj1,,,,,,})
		aAdd(aPaineis[nPos][3],{1,cTitObj2,,,,,,})
		aAdd(aPaineis[nPos][3],{2, ,"@!", 1,,,,TamSX3("A1_COD")[1]})
		aAdd(aPaineis[nPos][3],{2, ,"@!", 1,,,,TamSX3("A1_LOJA")[1]})

	EndIf

	If !lIndiv
		lRet := xMagWizard(aTxtPre,aPaineis,"DCIMENSAL")
	Else
		lRet := xMagWizard(aTxtPre,aPaineis,"DCIINDIVI")
	EndIf

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFunction  ³HeaderMensal    ºAutor  ³Sueli C. Santos     º Data ³  26/05/2006 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Header Mensal.                 							  º±±
±±º          ³Contem informacoes sobre o contribuinte e informacoes geraisº±±
±±º          ³sobre o documento fiscal. R00 							  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ DCIMensal                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function HeaderMensal(lIndiv)
	Default	lIndiv := .F.

	RecLock("R00",.T.)
	R00->DTREF	    := Val(SUBSTR(DTOS(dDtIni),1,6))
	R00->CNPJINT	:= Val(SM0->M0_CGC)
	R00->VERS       := Alltrim(aCfp[2][01])

	If lIndiv
		R00->NRINSES	:= Val(SM0->M0_INSC)
		R00->NFISCAL    := Alltrim(aCfp[3][02])
		R00->SERIE      := Alltrim(aCfp[3][03])
	EndIf

	MSUnlock()

	RecLock("R03",.T.)
	R03->NRDCI   := Val(aCfp[2][02])
	R03->NRRET   := 0
	R03->VDIFPE  := Val(aCfp[2][05])
	R03->VMDIFPE := Val(aCfp[2][03])
	R03->VJDIFPE := Val(aCfp[2][04])
	R03->VIPIPE  := 0
	R03->VMIPIPE := 0
	R03->VJIPIPE := 0
	R03->VPISPE  := 0
	R03->VMPISPE := 0
	R03->VJPISPE := 0
	R03->VCOFPE  := 0
	R03->VMCOFPE := 0
	R03->VJCOFPE := 0
	R03->VPPB    := 0
	R03->VMPPB   := 0
	R03->VJPPB   := 0
	R03->VPISPPB := 0
	R03->VMPISPPB:= 0
	R03->VJPISPPB:= 0
	R03->VCOFPPB := 0
	R03->VMCOFPPB:= 0
	R03->VJCOFPPB:= 0
	R03->VPI     := 0
	R03->VMPI    := 0
	R03->VJPI    := 0
	R03->VIPIPI  := 0
	R03->VMIPIPI := 0
	R03->VJIPIPI := 0
	R03->VPISPI  := 0
	R03->VMPISPI := 0
	R03->VJPISPI := 0
	R03->VCOFPI  := 0
	R03->VMCOFPI := 0
	R03->VJCOFPI := 0
	MSUnlock()
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFunction  |DadosMensais ºAutor  ³Sueli C. Santos  º Data ³  26/05/2006 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Header Mensal.                 							  º±±
±±º          ³Contem informacoes sobre o contribuinte e informacoes geraisº±±
±±º          ³sobre o documento fiscal. R01 							  º±±
±±º          ³sobre o documento fiscal. R01 							  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ DCIMensal                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function DadosMensais(lIndiv, cAliasSF3, cCNPJ, cPessoa)
	Local cDestino	:= SuperGetMv("MV_ESTADO",.F.,"")

	Default	lIndiv 		:= .F.
	Default cAliasSF3 	:= ""


	RecLock("R01",.T.)
	R01->DTREF	    :=	Val(SUBSTR(DTOS(dDtIni),1,6))
	R01->CNPJINT	:= Val(SM0->M0_CGC)
	R01->NBCO       := Val(Alltrim(aCfp[1][01]))
	R01->NAG        := Val(Alltrim(aCfp[1][02]))
	R01->NCC        := Alltrim(aCfp[1][03])

	If lIndiv .And. !Empty(cAliasSF3)

		If Substr((cAliasSF3)->F3_CFO,1,1)>="5"
			cDestino := (cAliasSF3)->F3_ESTADO
		EndIf

		R01->NRINSES        := Val(SM0->M0_INSC)
		R01->SERIE        	:= Alltrim(aCfp[3][03])
		R01->NFISCAL        := Alltrim(aCfp[3][02])
		R01->DTEMISS        := Alltrim(aCfp[3][01])
		R01->DTSAIDA        := Alltrim(aCfp[3][01])
		R01->CODCFOP        := Alltrim( (cAliasSF3)->F3_CFO )
		R01->TPPESSOA       := Alltrim( cPessoa )
		R01->CPFCNPJ       	:= Alltrim( cCNPJ )
		R01->UFDEST        	:= Alltrim( cDestino )
		R01->INTERNAC		:= Iif( cDestino$"AC/AP/AM/RO/RR","S","N"  )
	EndIf

	MSUnlock()

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFunction  |Dcigat	   ºAutor  ³Natalia Antonucciº Data ³  06/07/2011 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funçõa que verifica se os campos NR-DCRE e NR-DCR do produtoº±±
±±º	         ³estão preenchidos.									   	  º±±
±±º          ³cCond = Descrição do campo onde esta chamando a Função      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ DCIMensal                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Dcigat(cCond)

	Default cCond := ""

	If cCond == "DCR"
		If !Empty(M->B1_DCRE) .and. !Empty(M->B1_DCR)
			If MsgYesNo("Campo NR-DCRE esta preenchido dejesa apagar?","ATENCAO!!!")
				M->B1_DCRE := " "
			Endif
		Endif
	EndIf

	If cCond == "DCRE"
		If !Empty(M->B1_DCR) .and. !Empty(M->B1_DCRE)
			If MsgYesNo("Campo NR-DCR esta preenchido dejesa apagar?","ATENCAO!!!")
				M->B1_DCR := " "
			Endif
		Endif
	EndIF

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GeraExpl  ºAutor  ³Cristiano Pereira   º Data ³  24/07/08  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Gera Explosão da Estrutura conforme parâmetro inoformado    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

STATIC lRet:= .t.
Static Function GeraExpl(cProduto,nQuantPai,nNivel,cOpcionais,nQtdBase)

	local nReg,nQuantItem := 0
	local nPrintNivel := " "
	Local aObserv   := {}
	local nx := 0
	Local aAreaSB1:={}
	Local linha
	Private lNegEstr := GETMV("MV_NEGESTR")
	Private _nNecess := 0

	DbSelectArea("SG1")
	While !Eof() .And. SG1->G1_FILIAL+SG1->G1_COD == xFilial("SG1")+cProduto

		nReg    := Recno()
		Conout("1:"+cProduto)
		Conout("2:"+cvaltochar(nQuantPai))
		Conout("3:"+cvaltochar(nNivel))
		Conout("4:"+cOpcionais)
		Conout("5:"+cvaltochar(nQtdBase))
		nQuantItem := ExplEstr(nQuantPai,,)
		DbSelectArea("SG1")
		If lNegEstr .Or. (!lNegEstr) .and. SG1->G1_FIM >= DDATABASE .And. SG1->G1_INI <= DDATABASE //.And. nQuantItem > 0 )

		//-- Divide a Observa‡„o em Sub-Arrays com 45 posi‡”es
			aObserv := {}
			For nX := 1 to MlCount(AllTrim(G1_OBSERV),45)
				aAdd(aObserv, MemoLine(AllTrim(G1_OBSERV),45,nX))
			Next nX

		//nPrintNivel:=IIF(nNivel>17,17,nNivel-2)
			DbSelectArea("SB1")
			DbSetOrder(1)
			DbSeek(xfilial("SB1")+SG1->G1_COMP)


			If lRet
				If (nNivel-1) == 1
					_aQtd := {}

					If SG1->G1_PERDA > 0
						_nNecess := ROUND((SG1->G1_QUANT * 1)*(SG1->G1_PERDA/100)+(SG1->G1_QUANT * 1),9)
						AADD(_aEstrut2,{IIF(nNivel>17,17,nNivel-1),cProduto,SG1->G1_COMP,_nNecess,SG1->G1_PERDA,.f.})
						AADD(_aQtd,{cProduto,SG1->G1_COMP,_nNecess,nNivel,.f.})
					Else
						_nNecess := SG1->G1_QUANT
						AADD(_aEstrut2,{IIF(nNivel>17,17,nNivel-1),cProduto,SG1->G1_COMP,_nNecess,SG1->G1_PERDA,.f.})
						AADD(_aQtd,{cProduto,SG1->G1_COMP,_nNecess,nNivel,.f.})
					Endif
				Else
					If SG1->G1_PERDA > 0

						_nQuant := 0
						lVer := .f.
						for linha := 1 to len(_aQtd)
							If cProduto == _aQtd[linha,2] .and. nNivel-1 <> 2
								If nQtdBase == _aQtd[linha,3]
									lVer := .t.
								Else
									_nQuant := _aQtd[linha,3]
								Endif
							ElseIf cProduto == _aQtd[linha,2] .and. nNivel-1 == 2
								If nQtdBase == _aQtd[linha,3]
									lVer := .t.
								Else
									_nQuant := _aQtd[linha,3]
								Endif

							Endif
						Next linha
						If !lVer .AND. _nQuant > 0
							AADD(_aEstrut2,{IIF(nNivel>17,17,nNivel-1),cProduto,SG1->G1_COMP,(_nQuant*SG1->G1_QUANT)*(SG1->G1_PERDA/100)+(_nQuant*SG1->G1_QUANT) ,SG1->G1_PERDA,.f.})
							AADD(_aQtd,{cProduto,SG1->G1_COMP,(_nQuant*SG1->G1_QUANT)*(SG1->G1_PERDA/100)+(_nQuant*SG1->G1_QUANT),nNivel,.f.})
						Else
						//AADD(_aEstrut2,{IIF(nNivel>17,17,nNivel-1),cProduto,SG1->G1_COMP,ROUND(nQtdBase*(SG1->G1_PERDA/100)+nQtdBase,9) ,SG1->G1_PERDA,.f.})
							AADD(_aEstrut2,{IIF(nNivel>17,17,nNivel-1),cProduto,SG1->G1_COMP,ROUND(nQtdBase*(SG1->G1_QUANT+(SG1->G1_QUANT*((SG1->G1_PERDA/(100-SG1->G1_PERDA))))),9) ,SG1->G1_PERDA,.f.})
							AADD(_aQtd,{cProduto,SG1->G1_COMP,ROUND(nQtdBase*(SG1->G1_PERDA/100)+nQtdBase,9),nNivel,.f.})
						Endif
					Else
						_nQuant := 0
						lVer := .f.
						for linha := 1 to len(_aQtd)
							If cProduto == _aQtd[linha,2] .and. nNivel-1 <> 2
								If nQtdBase == _aQtd[linha,3]
									lVer := .t.
								Else
									_nQuant := _aQtd[linha,3]
								Endif
							ElseIf cProduto == _aQtd[linha,2] .and. nNivel-1 == 2
								If nQtdBase == _aQtd[linha,3]
									lVer := .t.
								Else
									_nQuant := _aQtd[linha,3]
								Endif

							Endif
						Next linha
						If !lVer .AND. _nQuant > 0
							AADD(_aEstrut2,{IIF(nNivel>17,17,nNivel-1),cProduto,SG1->G1_COMP,_nQuant*SG1->G1_QUANT,SG1->G1_PERDA,.f.})
							AADD(_aQtd,{cProduto,SG1->G1_COMP,_nQuant*SG1->G1_QUANT,nNivel,.f.})
						Else
						//##########################################################
						//Manutencao : Quantidade da Mao de obra gerando errado    #
						//28/05/2010                                               #
						//##########################################################
							If SubStr(SG1->G1_COMP,1,3) <> "MOD"
								AADD(_aEstrut2,{IIF(nNivel>17,17,nNivel-1),cProduto,SG1->G1_COMP,nQuantItem,SG1->G1_PERDA,.f.}) //nQtdBase Cristiano 27/11/2009
							Else
								AADD(_aEstrut2,{IIF(nNivel>17,17,nNivel-1),cProduto,SG1->G1_COMP,SG1->G1_QUANT,SG1->G1_PERDA,.f.}) //Cristiano 27/11/2009
							Endif
						//AADD(_aEstrut2,{IIF(nNivel>17,17,nNivel-1),cProduto,SG1->G1_COMP,SG1->G1_QUANT,SG1->G1_PERDA,.f.})
						//Alterado devido a diferenca no calculo da quant. necessaria que esta calculando errado.
							AADD(_aQtd,{cProduto,SG1->G1_COMP,nQuantItem,nNivel,.f.})

						Endif
					Endif
				Endif
			Else

				If (nNivel-1) == 1
					_aQtd := {}
					If SG1->G1_PERDA > 0
						_nNecess := ROUND((SG1->G1_QUANT * 1)*(SG1->G1_PERDA/100)+(SG1->G1_QUANT * 1),9)
						AADD(_aEstrut2,{IIF(nNivel>17,17,nNivel-1),cProduto,SG1->G1_COMP,_nNecess,SG1->G1_PERDA,.f.})
						AADD(_aQtd,{cProduto,SG1->G1_COMP,_nNecess,nNivel,.f.})
					Else
						_nNecess := SG1->G1_QUANT
						AADD(_aEstrut2,{IIF(nNivel>17,17,nNivel-1),cProduto,SG1->G1_COMP,_nNecess,SG1->G1_PERDA,.f.})
						AADD(_aQtd,{cProduto,SG1->G1_COMP,_nNecess,nNivel,.f.})
					Endif
				Else
					If SG1->G1_PERDA > 0

						_nQuant := 0
						lVer := .f.
						for linha := 1 to len(_aQtd)
							If cProduto == _aQtd[linha,2] .and. nNivel-1 <> 2
								If nQtdBase == _aQtd[linha,3]
									lVer := .t.
								Else
									_nQuant := _aQtd[linha,3]
								Endif
							ElseIf cProduto == _aQtd[linha,2] .and. nNivel-1 == 2
								If nQtdBase == _aQtd[linha,3]
									lVer := .t.
								Else
									_nQuant := _aQtd[linha,3]
								Endif

							Endif
						Next linha

						If !lVer .AND. _nQuant > 0
							AADD(_aEstrut2,{IIF(nNivel>17,17,nNivel-1),cProduto,SG1->G1_COMP,ROUND((_nQuant*SG1->G1_QUANT)*(SG1->G1_PERDA/100)+(_nQuant*SG1->G1_QUANT),9) ,SG1->G1_PERDA,.f.})
							AADD(_aQtd,{cProduto,SG1->G1_COMP,ROUND((nQtdBase*SG1->G1_QUANT)*(SG1->G1_PERDA/100)+(_nQuant*SG1->G1_QUANT),9),nNivel,.f.})
						Else
							AADD(_aEstrut2,{IIF(nNivel>17,17,nNivel-1),cProduto,SG1->G1_COMP,ROUND((nQtdBase*SG1->G1_QUANT)*(SG1->G1_PERDA/100)+(nQtdBase*SG1->G1_QUANT),9) ,SG1->G1_PERDA,.f.})
							AADD(_aQtd,{cProduto,SG1->G1_COMP,ROUND((nQtdBase*SG1->G1_QUANT)*(SG1->G1_PERDA/100)+(nQtdBase*SG1->G1_QUANT),9),nNivel,.f.})

						Endif
					Else

						_nQuant := 0
						lVer := .f.
						for linha := 1 to len(_aQtd)
							If cProduto == _aQtd[linha,2] .and. nNivel-1 <> 2
								If nQtdBase == _aQtd[linha,3]
									lVer := .t.
								Else
									_nQuant := _aQtd[linha,3]
								Endif
							ElseIf cProduto == _aQtd[linha,2] .and. nNivel-1 == 2
								If nQtdBase == _aQtd[linha,3]
									lVer := .t.
								Else
									_nQuant := _aQtd[linha,3]
								Endif

							Endif
						Next linha


						If !lVer .AND. _nQuant > 0
							AADD(_aEstrut2,{IIF(nNivel>17,17,nNivel-1),cProduto,SG1->G1_COMP,_nQuant*SG1->G1_QUANT,SG1->G1_PERDA,.f.})
							AADD(_aQtd,{cProduto,SG1->G1_COMP,_nQuant*SG1->G1_QUANT,nNivel,.f.})
						Else
							AADD(_aEstrut2,{IIF(nNivel>17,17,nNivel-1),cProduto,SG1->G1_COMP,nQtdBase*SG1->G1_QUANT,SG1->G1_PERDA,.f.})
							AADD(_aQtd,{cProduto,SG1->G1_COMP,nQtdBase*SG1->G1_QUANT,nNivel,.f.})

						Endif
					Endif

				Endif
			Endif

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se existe sub-estrutura                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			DbSelectArea("SG1")
			DbSeek(xFilial("SG1")+SG1->G1_COMP)

			dbSelectArea("SB1")
			DbSetOrder(1)
			If DbSeek(xFilial("SB1")+SG1->G1_COD)
				If Found()
					lRet := .t.

					If (nNivel-1) == 1
				/*
				Conout("1A"+SG1->G1_COD)
				Conout("2A"+cValtochar((nQuantItem)))
				Conout("3A"+cValtochar(nNivel+1))
				Conout("4A"+cOpcionais)
				Conout("5A"+cValtochar(nNivel+1))
				Conout("6A"+cValtochar(ROUND(SG1->G1_QUANT*_nNecess,9)))
				Conout("7A"+cValtochar(SG1->G1_PERDA))
				Conout("8A"+SG1->G1_COMP)
				*/
						GeraExpl(SG1->G1_COD,nQuantItem,nNivel+1,cOpcionais,ROUND(SG1->G1_QUANT*_nNecess,9),SG1->G1_PERDA)
					Endif
				Else
				/*
				Conout("1B"+SG1->G1_COD)
				Conout("2B"+cValtochar((nQuantItem)))
				Conout("3B"+cValtochar(nNivel+1))
				Conout("4B"+cOpcionais)
				Conout("5B"+cValtochar(nNivel+1))
				Conout("6B"+cValtochar(ROUND(SG1->G1_QUANT*_nNecess,9)))
				Conout("7B"+cValtochar(SG1->G1_PERDA))
				Conout("8B"+SG1->G1_COMP)
				*/
					GeraExpl(SG1->G1_COD,nQuantItem,nNivel+1,cOpcionais,ROUND(SG1->G1_QUANT*nQtdBase,9),SG1->G1_PERDA)

				Endif
			Else
				lRet := .f.
			EndIf
			DbGoto(nReg)
		EndIf
		DbSkip()

	End


Return(_aEstrut2)

