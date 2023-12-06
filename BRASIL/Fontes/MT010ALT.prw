#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"

/*
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ MT010ALT      ³Autor  ³ Renato Nogueira  ³ Data ³06.08.2013 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Ponto de entrada após a alteração do produto			       ³±±
±±³          ³                                                             ³±±
±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MT010ALT()

	Local aArea     := GetArea()
	Local aAreaSB1  := SB1->(GetArea())
	Local cCodEan    := "789"
	Local cCodEmp    := GetMv("MV_XCODEMP") // 3401 Criar parametro para codigo da empresa.
	Local cSequen    := GetMv("MV_XSEQBAR")// Sequencial utilizado na geracao do  codigo de barras
	Local cCodBar    := " "
	Local cNewCodBar := " "
	If Inclui .or. Altera
		U_STGERSB5()	//Criar registro na tabela SB5 - Chamado 001141
	EndIf
	IF SB1->B1_XCRIACB == 'S'  .AND. EMPTY(SB1->B1_CODBAR)

		If MsgYesNo("Deseja criar o código de barras para o produto: "+SB1->B1_COD)

			cCodBar    := cCodEan + cCodEmp + cSequen
			cNewCodBar := cCodBar + EanDigito(cCodBar)// Funcao padrao do sistema que calculo digito do codigo de barras

			PutMv("MV_XSEQBAR",Soma1(cSequen))

			Dbselectarea("SB1")
			Reclock("SB1")
			SB1->B1_CODBAR := cNewCodBar
			MsUnlock()
			MsgStop("Este Produto recebeu o Codigo de Barras: "+cNewCodBar)

		EndIf

	Endif

	If !Empty(SB1->B1_CODBAR) .And. CODBARVAZIO() //Verifica sem tem código de barras na empresa corrente e na outra não
		If MSGYESNO("Deseja replicar o código de barras para a outra empresa?")
			ATUALIZACB()
		EndIf
	EndIf

	// Adicionado para atender o chamado 001362 - Robson Mazzarotto
	//Ajustado chamado 007120

	DbSelectArea("PP8")
	PP8->(DbSetOrder(2))
	PP8->(DbGoTop())

	If PP8->(DbSeek("02"+M->B1_COD))

		While PP8->(!Eof()) .And. Alltrim(PP8->PP8_PROD)==AllTrim(M->B1_COD)

			If !Empty(PP8->PP8_DTENG) .And. !(AllTrim(M->B1_XDESENH)==AllTrim(PP8->PP8_DESENH))
				PP8->(RecLock("PP8",.F.))
				PP8->PP8_DESENH	:= M->B1_XDESENH
				PP8->(MsUnlock())
			Endif

			PP8->(DbSkip())
		EndDo

	Endif

	If !(SB1->B1_XDESENH==M->B1_XDESENH)
		MsgAlert("Cadastro de desenho alterado! Substitua as cópias obsoletas pela revisão vigente.")
	EndIf

	RestArea(aAreaSB1)
	RestArea(aArea)

Return

/*
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ CODBARVAZIO  ³Autor  ³ Renato Nogueira  ³ Data ³06.08.2013 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Ponto de entrada após a alteração do produto			       ³±±
±±³          ³                                                             ³±±
±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function CODBARVAZIO()

	Local cQuery1 	:= ""
	Local cAlias1 	:= "QRYTEMP"
	Local _lRet		:= .F.

	cQuery1	 := " SELECT B1_CODBAR "
	If cEmpAnt=="01"
		cQuery1  += " FROM SB1030 B1 "
	ElseIf cEmpAnt=="03"
		cQuery1  += " FROM SB1010 B1 "
	Else 
		cQuery1  += " FROM " + RetSqlName("SB1") + " B1 "      // Valdemir Rabelo 05/01/2022 Ticket: 
	EndIf
	cQuery1  += " WHERE B1.D_E_L_E_T_=' ' AND B1_COD='"+SB1->B1_COD+"' "

	If !Empty(Select(cAlias1))
		DbSelectArea(cAlias1)
		(cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery1),cAlias1,.T.,.T.)

	dbSelectArea(cAlias1)
	(cAlias1)->(dbGoTop())

	If (cAlias1)->(!Eof())
		If Empty((cAlias1)->B1_CODBAR)
			_lRet	:= .T.
		EndIf
	EndIf

Return(_lRet)

/*
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ ATUALIZACB  ³Autor  ³ Renato Nogueira  ³ Data ³06.08.2013 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Ponto de entrada após a alteração do produto			       ³±±
±±³          ³                                                             ³±±
±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ATUALIZACB()

	Local _cQuery	:= ""
	Local nErrQry

	_cQuery := "UPDATE "
	If cEmpAnt=="01"
		_cQuery  += " SB1030 B1 "
	ElseIf cEmpAnt=="03"
		_cQuery  += " SB1010 B1 "
	EndIf
	_cQuery	+= " SET B1.B1_CODBAR='"+SB1->B1_CODBAR+"' "
	_cQuery  += " WHERE B1.D_E_L_E_T_=' ' AND B1_COD='"+SB1->B1_COD+"' "

	nErrQry := TCSqlExec( _cQuery )

	If nErrQry <> 0
		DisarmTransaction()
		MsgAlert('Erro no UPDATE: ' + AllTrim(Str(nErrQry)),'ATENÇÃO')
		lRet := .F.
	EndIf

Return()
