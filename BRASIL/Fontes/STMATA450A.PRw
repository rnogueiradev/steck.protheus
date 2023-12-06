#INCLUDE "MATA450.CH"
#INCLUDE "PROTHEUS.CH"
//Posicoes do array aSaldos
#DEFINE _LIMCREDM 1,1
#DEFINE _LIMCRED  1,2
#DEFINE _SALDUPM  2,1
#DEFINE _SALDUP   2,2
#DEFINE _SALPEDLM 3,1
#DEFINE _SALPEDL  3,2
#DEFINE _MCOMPRAM 4,1
#DEFINE _MCOMPRA  4,2
#DEFINE _SALDOLCM 5,1
#DEFINE _SALDOLC  5,2
#DEFINE _MAIDUPLM 6,1
#DEFINE _MAIDUPL  6,2
#DEFINE _ITATUM   7,1
#DEFINE _ITATU    7,2
#DEFINE _PEDATUM  8,1
#DEFINE _PEDATU   8,2
#DEFINE _SALPEDM  9,1
#DEFINE _SALPED   9,2
#DEFINE _VALATRM  10,1
#DEFINE _VALATR   10,2
#DEFINE _LCFINM   11,1
#DEFINE _LCFIN    11,2
#DEFINE _SALFINM  12,1
#DEFINE _SALFIN   12,2

#DEFINE _STRASALDOS 12,2

#DEFINE BR_LC      01
#DEFINE BR_LCFIN   02
#DEFINE BR_SALDUP  03
#DEFINE BR_SALDUPM 04
#DEFINE BR_SALFIN  05
#DEFINE BR_SALFINM 06
#DEFINE BR_SALPED  07
#DEFINE BR_SALPEDB 08
#DEFINE BR_SALPEDL 09
#DEFINE BR_MCOMPRA 10
#DEFINE BR_MAIDUPL 11
#DEFINE BR_MSALDO  12
#DEFINE BR_PAGATR  13
#DEFINE BR_NROPAG  14
#DEFINE BR_METR    15
#DEFINE BR_TITPROT 16
#DEFINE BR_DTULTIT 17
#DEFINE BR_CHQDEVO 18
#DEFINE BR_DTULCHQ 19
#DEFINE BR_PRICOM  20
#DEFINE BR_ULTCOM  21
#DEFINE BR_ULTVIS  22
#DEFINE BR_NROCOM  23

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³MATA450A  ³ Autor ³ Eduardo Riera         ³ Data ³28.01.2002³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Programa de Analise de Credito / Cliente                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ PROGRAMADOR  ³ DATA   ³ BOPS ³  MOTIVO DA ALTERACAO                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³        ³      ³                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function STMATA450A()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Define Variaveis                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Local aArea       := GetArea()
	Local aBrowse     := {}
	Local cAliasTRB   := ""
	Local cNomeTRB    := ""
	Local cAliasPed   := ""
	Local cNomePed    := ""
	Local aUsRotina   := {}

	PRIVATE cCadastro := OemToAnsi(STR0061) //"Analise de Credito - (Cliente)"
	PRIVATE b450Pcli := {|lEnd,lCria| U_STMa450PCli(@cAliasTRB,@cNomeTrb,@aBrowse,lEnd,lCria,@cAliasPed,@cNomePed)}
	PRIVATE aRotina   := MenuDef()

	If VerSenha(136)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Ponto de entrada para adicao ao menu de rotinas feitas pelo usuario     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If ExistBlock("M450AROT")
			aUsRotina := ExecBlock("M450AROT",.F.,.F.)
			If ValType(aUsRotina) == "A"
				AEval(aUsRotina, {|x| AAdd( aRotina, x )})
			EndIf
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Montagem da tabela temporaria                                   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Processa(b450PCli,,,.T.)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Interface da tabela temporaria                                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		mBrowse( 7, 4,20,74,"TRB",aBrowse)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Restaura a integridade da rotina                                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea(cAliasTRB)
		dbCloseArea()
		Ferase(cNomeTrb+OrdBagExt())
		Ferase(cNomeTrb+GetDbExtension())

		dbSelectArea(cAliasPed)
		dbCloseArea()
		Ferase(cNomePed+OrdBagExt())
		Ferase(cNomePed+GetDbExtension())
	Else
		HELP(" ",1,"SEMPERM")
	Endif
	dbSelectArea("SA1")
	RestArea(aArea)
Return(.T.)

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³Ma450PCli ³ Autor ³ Eduardo Riera         ³ Data ³27.07.2000 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Rotina de montagem do arquivo de trabalho para a liberacao de³±±
±±³          ³credito por cliente                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: Alias da tabela temporaria (inicializado na rotina)   ³±±
±±³          ³ExpC2: Nome fisico do arquivo temporario (idem ao anterior)  ³±±
±±³          ³ExpA3: Array com os dados a serem exibidos na MBrowse        ³±±
±±³          ³       [1] Titulo da coluna a ser exibida                    ³±±
±±³          ³       [2] Nome do campo                                     ³±±
±±³          ³       [3] Tipo do campo                                     ³±±
±±³          ³       [4] Tamanho do campo                                  ³±±
±±³          ³       [6] Decimal do campo                                  ³±±
±±³          ³       [7] Picture do campo                                  ³±±
±±³          ³ExpL5: Controle de finalizacao do usuario                    ³±±
±±³          ³ExpL6: Indica se o arquivo temporario deve ser criado        ³±±
±±³          ³ExpC7: Alias da tabela temporaria (inicializado na rotina)   ³±±
±±³          ³ExpC8: Nome fisico do arquivo temporario (idem ao anterior)  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                       ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Esta rotina tem como objetivo criar e atualizar o arquivo    ³±±
±±³          ³temporario a ser exibido para processamento da liberacao de  ³±±
±±³          ³credito por cliente.                                         ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ MATA450A                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function STMa450PCli(cAliasTrb,cNomeTrb,aBrowse,lEnd,lCria,cAliasPed,cNomePed)

	Local aArea     := GetArea()
	Local aStruSA1  := {}
	Local AStruSC5  := {}
	Local cQuery    := ""
	Local cAliasSA1 := "SA1"
	Local cAliasSC5 := "SC5"
	Local cAliasSC9 := "SC9"
	Local cNomeSC9  := CriaTrab(,.F.)
	Local lQuery    := .F.
	Local lEmpresa  := FWModeAccess("SA1",3)=="C"
	Local nX        := 0

	DEFAULT cAliasTRB := ""
	DEFAULT cNomeTrb  := ""
	DEFAULT aBrowse   := {}
	DEFAULT lCria     := .T.
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Cria os arquivos de trabalho                                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SX3")
	dbSetOrder(1)
	MsSeek("SA1")
	While !Eof() .And. SX3->X3_ARQUIVO == "SA1"
		If (SX3->X3_BROWSE == "S" .Or. AllTrim(SX3->X3_CAMPO)$"A1_COD,A1_LOJA,A1_NOME") .And.;
		SX3->X3_CONTEXT <> "V"
			aadd(aStruSA1,{ SX3->X3_CAMPO, SX3->X3_TIPO, SX3->X3_TAMANHO, SX3->X3_DECIMAL })
			aadd(aBrowse,{X3TITULO(),SX3->X3_CAMPO,SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_PICTURE})
		EndIf
		dbSelectArea("SX3")
		dbSkip()
	EndDo
	aadd(aStruSC5,{"C5_VALOR","N",18,2})
	dbSelectArea("SX3")
	dbSetOrder(1)
	MsSeek("SC5")

	While !Eof() .And. SX3->X3_ARQUIVO == "SC5"
		If (SX3->X3_BROWSE == "S" .Or. AllTrim(SX3->X3_CAMPO)$"C5_FILIAL,C5_CLIENTE,C5_LOJACLI")   .And.   ;
		SX3->X3_CONTEXT <> "V"

			aadd(aStruSC5,{ SX3->X3_CAMPO, SX3->X3_TIPO, SX3->X3_TAMANHO, SX3->X3_DECIMAL })

		EndIf
		dbSelectArea("SX3")
		dbSkip()
	EndDo
	aadd(aStruSC5,{"C5_FLAG","L",1,0})

	If lCria
		If Select("TRB") >= 1
			TRB->(DbCloseArea())
		EndIf
		cAliasTRB := "TRB"
		cNomeTrb  := CriaTrab(aStruSA1,.T.)
		dbUseArea(.T.,__LocalDrive,cNomeTrb,cAliasTrb,.F.,.F.)
		IndRegua(cAliasTrb,cNomeTrb,"A1_COD+A1_LOJA")

		If Select("PED") >= 1
			PED->(DbCloseArea())
		EndIf
		cAliasPed := "PED"
		cNomePed  := CriaTrab(aStruSC5,.T.)
		dbUseArea(.T.,__LocalDrive,cNomePed,cAliasPed,.F.,.F.)
		IndRegua(cAliasPed,cNomePed,"C5_CLIENTE+C5_LOJACLI+C5_NUM")
	Else
		dbSelectArea(cAliasTRB)
		Pack

		dbSelectArea(cAliasPed)
		Zap
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Preenche o arquivo temporario                                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	#IFDEF TOP
	cAliasSC5 := "Ma450PCli"
	cAliasSC9 := "Ma450PCli"
	cAliasSA1 := "Ma450PCli"

	lQuery    := .T.

	cQuery    := "SELECT SC9.C9_CLIENTE,SC9.C9_LOJA"
	For nX := 1 To Len(aStruSA1)
		cQuery += ",SA1."+aStruSA1[nX][1]+" "
	Next nX
	For nX := 1 To Len(AStruSC5)
		If AStruSC5[nX][1]<>"C5_FLAG" .And. AStruSC5[nX][1]<>"C5_VALOR"
			cQuery += ",SC5."+AStruSC5[nX][1]+" "
		EndIf
	Next nX
	cQuery += ",SC5.C5_MOEDA,SC9.C9_PEDIDO,SC9.C9_PRCVEN,SC9.C9_QTDLIB,SA1.A1_MOEDALC "
	cQuery += "FROM "+RetSqlName("SC9")+" SC9, "
	cQuery += RetSqlName("SA1")+" SA1, "
	cQuery += RetSqlName("SC5")+" SC5  "
	cQuery += "WHERE "
	If !lEmpresa
		cQuery    += "SC9.C9_FILIAL = '"+xFilial("SC9")+"' AND "
	EndIf
	cQuery += "SC9.C9_BLCRED<>'"+Repl(" ",Len(SC9->C9_BLCRED))+"' AND "
	cQuery += "SC9.C9_BLCRED<>'10' AND "
	cQuery += "SC9.C9_BLCRED<>'ZZ' AND "
	cQuery += "SC9.C9_BLCRED<>'09' AND "
	cQuery += "SC9.D_E_L_E_T_=' ' AND "
	cQuery += "SA1.A1_FILIAL='"+xFilial("SA1")+"' AND "
	cQuery += "SA1.A1_COD = SC9.C9_CLIENTE AND "
	cQuery += "SA1.A1_LOJA = SC9.C9_LOJA AND "
	cQuery += "SA1.D_E_L_E_T_=' ' AND "
	If !lEmpresa
		cQuery += "SC5.C5_FILIAL='"+xFilial("SC5")+"' AND "
	Else
		cQuery += "SC5.C5_FILIAL=SC9.C9_FILIAL AND "
	EndIf
	cQuery += "SC5.C5_NUM=SC9.C9_PEDIDO AND "
	cQuery += "SC5.D_E_L_E_T_=' ' "

	If ExistBlock("M450ABRW")
		cQuery := ExecBlock('M450ABRW',.F.,.F.,{ cQuery })
	EndIf


	cQuery += "ORDER BY SC9.C9_CLIENTE,SC9.C9_LOJA,SC9.C9_PEDIDO,SC9.C9_ITEM "
	cQuery := ChangeQuery(cQuery)

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSC9,.T.,.T.)

	For nX := 1 To Len(aStruSA1)
		If aStruSA1[nX][2]<>"C"
			TcSetField(cAliasSC9,aStruSA1[nX][1],aStruSA1[nX][2],aStruSA1[nX][3],aStruSA1[nX][4])
		EndIf
	Next nX

	For nX := 1 To Len(aStruSC5)
		If aStruSC5[nX][2]<>"C"
			TcSetField(cAliasSC9,aStruSC5[nX][1],aStruSC5[nX][2],aStruSC5[nX][3],aStruSC5[nX][4])
		EndIf
	Next nX

	#ELSE
	cAliasSC9 := "MATA450A"
	ChkFile("SC9",.F.,cAliasSC9)
	If !lEmpresa
		cQuery := "C9_FILIAL=='"+xFilial("SC9")+"' .AND. "
	EndIf
	cQuery += "C9_BLCRED<>'  ' .AND. "
	cQuery += "C9_BLCRED<>'10' .AND. "
	cQuery += "C9_BLCRED<>'ZZ' .AND. "
	cQuery += "C9_BLCRED<>'09'"

	dbSelectArea(cAliasSC9)
	IndRegua(cAliasSC9,cNomeSC9,"C9_FILIAL+C9_CLIENTE+C9_LOJA",,cQuery)
	#ENDIF
	dbSelectArea(cAliasSC9)
	ProcRegua((cAliasSC9)->(LastRec()))
	While !Eof()
		If !lQuery
			dbSelectArea("SA1")
			dbSetOrder(1)
			MsSeek(xFilial("SA1")+(cAliasSC9)->C9_CLIENTE+(cAliasSC9)->C9_LOJA)

			dbSelectArea("SC5")
			dbSetOrder(1)
			MsSeek(OsFilial("SC5",(cAliasSC9)->C9_FILIAL)+(cAliasSC9)->C9_PEDIDO)
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Verifica se o cliente ja foi incluido                           ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea(cAliasTRB)
		dbSetOrder(1)
		If !MsSeek((cAliasSC9)->C9_CLIENTE+(cAliasSC9)->C9_LOJA)
			RecLock(cAliasTRB,.T.)
			For nX := 1 To FCount()
				If (cAliasSA1)->(FieldPos((cAliasTRB)->(FieldName(nX))))<>0
					FieldPut(nX,(cAliasSA1)->(FieldGet(FieldPos((cAliasTRB)->(FieldName(nX))))))
				EndIf
			Next nX
			MsUnLock()
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Verifica se o pedido ja foi incluido                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea(cAliasPed)
		If !MsSeek((cAliasSC9)->C9_CLIENTE+(cAliasSC9)->C9_LOJA+(cAliasSC9)->C9_PEDIDO)
			RecLock(cAliasPed,.T.)
			For nX := 1 To FCount()
				If (cAliasSC5)->(FieldPos((cAliasPed)->(FieldName(nX))))<>0
					FieldPut(nX,(cAliasSC5)->(FieldGet(FieldPos((cAliasPed)->(FieldName(nX))))))
				EndIf
			Next nX
			(cAliasPed)->C5_FLAG := .F.
			MsUnLock()
		EndIf
		RecLock(cAliasPed,.F.)
		(cAliasPed)->C5_VALOR += xMoeda(A410Arred((cAliasSC9)->C9_PRCVEN*(cAliasSC9)->C9_QTDLIB,"C6_VALOR"),(cAliasSC5)->C5_MOEDA,IIf((cAliasSA1)->A1_MOEDALC>0,(cAliasSA1)->A1_MOEDALC,Val(SuperGetMv("MV_MCUSTO"))))
		MsUnlock()
		If lEnd
			Exit
		EndIf
		IncProc()
		dbSelectArea(cAliasSC9)
		dbSkip()
	EndDo
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Restaura a integridade da rotina                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea(cAliasSC9)
	dbCloseArea()
	Ferase(cNomeSC9+OrdBagExt())
	Ferase(cNomeTrb+GetDbExtension())
	dbSelectArea("SC9")
	RestArea(aArea)
Return(.T.)

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³Ma450ClMan³ Autor ³ Eduardo Riera         ³ Data ³27.07.2000 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Interface da rotina de liberacao de credito manual por       ³±±
±±³          ³cliente                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: Alias da tabela temporaria                            ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                       ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Esta rotina tem como objetivo realizar a interface da libera-³±±
±±³          ³cao de credito por cliente e atualizar as tabela necessarias ³±±
±±³          ³conforme a liberacao/rejeicao efetuada.                      ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ MATA450A                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function ST3Ma450ClMan(cAliasTrb)

	Local aArea      := GetArea()
	Local aAreaSM0   := SM0->(GetArea())
	Local aAreaSC9   := SC9->(GetArea())
	Local aSize      := MsAdvSize( .F. )
	Local aObjects   := {}
	Local aInfo      := {}
	Local aPosObj    := {}
	Local aBrowse    := {}
	Local aValor     := Array(23)
	Local aRegSC6    := {}
	Local bWhile     := {|| !Eof()}
	Local bWhileSC9  := {|| !Eof()}
	Local nMCustoCL  := 0
	Local nMCustoCL2 := 0
	Local nMCusto    := 0
	Local nSaldoLC   := 0
	Local nIdealLC   := 0
	Local nOpcA      := 0
	Local nValAtraso := 0
	Local nTpLiber   := 1
	Local nVlrLiber  := 0
	Local nX         := 0
	Local cQuebra    := ""
	Local cTexto1    := ""
	Local cTexto2    := ""
	Local cMoeda1    := ""
	Local cMoedaLC   := ""
	Local cCodCli    := ""
	Local cSavFil    := cFilAnt
	Local cAliasSA1  := "SA1"
	Local cAliasSC5  := "SC5"
	Local cAliasSC9  := "SC9"
	Local cAliasPed  := "TMP"
	Local cNomePed   := ""
	Local cQuery     := ""
	Local cEmpresa   := ""
	Local lQuery     := .F.
	Local lSA1       := .F.
	Local lValido    := .F.
	Local lEnd       := .F.
	Local lContinua  := .T.
	Local lGestao	 := Iif( FWSizeFilial() > 2, .T., .F.)
	Local lPosicion  := .F.
	Local nTam		 := 0
	Local cEmpAtu	 := ""
	Local nSalvEmp   := 0

	Local oPanel
	Local oDlg
	Local oColuna
	Local oColuna1
	Local oColuna2
	Local oColuna3
	Local oColuna4
	Local oColuna5
	Local oColuna6
	Local oBrowse
	Local oGetDB
	Local oRadio
	Local oMsGet
	Local aButtons
	Local nPosBtn
	Local nQtBtn
	Local oBtn
	Local oMenu

	Private aHeader := {}
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Montagem do aheader                                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aadd(aHeader,{RetTitle("C6_VALOR"),"C5_VALOR",PesqPict("SC6","C6_VALOR",18,2),18,2,"","","N","TRB",""})
	dbSelectArea("SX3")
	dbSetOrder(1)
	MsSeek("SC5")
	While ( !Eof() .And. SX3->X3_ARQUIVO=="SC5" )
		If SX3->X3_BROWSE=="S" .Or. AllTrim(SX3->X3_CAMPO)=="C5_FILIAL" 
			If AllTrim(SX3->X3_CAMPO) <> "C5_ZCONDPG"   
				IF AllTrim(SX3->X3_CAMPO) = "C5_ZBLOQ" 
					aadd(aHeader,{"Cond. Pag.","C5_ZCONDPG",'@!',3,0,' ','€€€€€€€€€€€€€€ ','C'})
				EndIf
				AADD(aHeader,{ AllTrim(SX3->(X3Titulo())),;
				SX3->X3_CAMPO,;
				SX3->X3_PICTURE,;
				SX3->X3_TAMANHO,;
				SX3->X3_DECIMAL,;
				SX3->X3_VALID,;
				SX3->X3_USADO,;
				SX3->X3_TIPO,;
				SX3->X3_ARQUIVO,;
				SX3->X3_CONTEXT} )
			EndIf
		EndIf
		dbSelectArea("SX3")
		dbSkip()
	EndDo
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Posiciona registros                                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SA1")
	dbSetOrder(1)
	MsSeek(xFilial("SA1")+(cAliasTRB)->A1_COD+(cAliasTRB)->A1_LOJA)
	nMCusto   := Val(SuperGetMv("MV_MCUSTO"))
	nMCustoCL := IIf(SA1->A1_MOEDALC > 0,SA1->A1_MOEDALC,nMCusto)

	cMCusto   := " "+Pad(SuperGetMv("MV_SIMB"+AllTrim(STR(nMCusto))),4)
	cMoedaLC  := " "+Pad(SuperGetMv("MV_SIMB"+AllTrim(STR(nMCustoCL))),4)
	cMoeda1   := " "+Pad(SuperGetMv("MV_SIMB"+AllTrim(STR(1))),4)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Filtra os arquivo de pedidos para nao demonstrar outros dados       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cNomePed := CriaTrab(PED->(dbStruct()),.T.)
	dbUseArea(.T.,__localdrive,cNomePed,cAliasPed)
	dbSelectArea("PED")
	dbSetOrder(1)
	MsSeek((cAliasTRB)->A1_COD+(cAliasTRB)->A1_LOJA)
	While !Eof() .And. (cAliasTRB)->A1_COD == PED->C5_CLIENTE .And.;
	(cAliasTRB)->A1_LOJA == PED->C5_LOJACLI
		RecLock(cAliasPed,.T.)
		For nX := 1 To FCount()
			FieldPut(nX,PED->(FieldGet(nX)))
		Next nX
		MsUnLock()
		dbSelectArea("PED")
		dbSkip()
	EndDo
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Analisar o atraso de Todas as Filiais do Sistema                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aValor := AFill(aValor,0)
	aValor[BR_DTULTIT] := Ctod("")
	aValor[BR_DTULCHQ] := Ctod("")
	aValor[BR_PRICOM ] := Ctod("")
	aValor[BR_ULTCOM ] := Ctod("")
	aValor[BR_ULTVIS ] := Ctod("")

	If FWModeAccess("SA1",3)=="C"
		cEmpresa := cEmpAnt
		bWhile   := {|| !Eof() .And. SM0->M0_CODIGO == cEmpresa }
	Else
		cEmpresa := cEmpAnt+cFilAnt
		bWhile   := {|| !Eof() .And. SM0->M0_CODIGO+FWGETCODFILIAL == cEmpresa }
	EndIf
	nSalvEmp := SM0->(Recno())
	dbSelectArea("SM0")
	dbSetOrder(1)
	MsSeek(cEmpresa)
	While Eval(bWhile)
		If ( SuperGetMv("MV_CREDCLI")=="L" )
			nValAtraso += FtSomaAtr(FWGETCODFILIAL)
			If !lSA1
				aValor[BR_LC     ] += SA1->A1_LC
				aValor[BR_LCFIN  ] += SA1->A1_LCFIN
				aValor[BR_SALDUP ] += SA1->A1_SALDUP
				aValor[BR_SALDUPM] += SA1->A1_SALDUPM
				aValor[BR_SALFIN ] += SA1->A1_SALFIN
				aValor[BR_SALFINM] += SA1->A1_SALFINM
				aValor[BR_SALPED ] += SA1->A1_SALPED
				aValor[BR_SALPEDB] += SA1->A1_SALPEDB
				aValor[BR_SALPEDL] += SA1->A1_SALPEDL
				aValor[BR_MCOMPRA] := Max(SA1->A1_MCOMPRA,aValor[BR_MCOMPRA])
				aValor[BR_MAIDUPL] := Max(SA1->A1_MAIDUPL,aValor[BR_MAIDUPL])
				aValor[BR_MSALDO ] := Max(SA1->A1_MSALDO,aValor[BR_MSALDO ])
				aValor[BR_PAGATR ] += SA1->A1_PAGATR
				aValor[BR_NROPAG ] += SA1->A1_NROPAG
				aValor[BR_METR   ] := Max(SA1->A1_METR,aValor[BR_METR   ])
				aValor[BR_TITPROT] += SA1->A1_TITPROT
				aValor[BR_DTULTIT] := Max(SA1->A1_DTULTIT,aValor[BR_DTULTIT])
				aValor[BR_CHQDEVO] += SA1->A1_CHQDEVO
				aValor[BR_DTULCHQ] := Max(SA1->A1_DTULCHQ,aValor[BR_DTULCHQ])
				aValor[BR_PRICOM ] := Min(SA1->A1_PRICOM,aValor[BR_PRICOM ])
				aValor[BR_ULTCOM ] := Max(SA1->A1_ULTCOM,aValor[BR_ULTCOM ])
				aValor[BR_ULTVIS ] := Max(SA1->A1_ULTVIS,aValor[BR_ULTVIS ])
				aValor[BR_NROCOM]  += SA1->A1_NROCOM
			EndIf
		Else
			dbSelectArea("SA1")
			dbSetOrder(1)
			dbSeek(xFilial("SA1")+(cAliasTRB)->A1_COD)
			While ( !Eof() .And. xFilial("SA1")  == SA1->A1_FILIAL .And.;
			(cAliasTRB)->A1_COD == SA1->A1_COD )

				nMCustoCL2 := IIf(SA1->A1_MOEDALC > 0,SA1->A1_MOEDALC,nMCusto)

				nValAtraso += FtSomaAtr(FWGETCODFILIAL)

				If !lSA1
					aValor[BR_LC     ] += xMoeda(SA1->A1_LC,nMCustoCL2,nMCustoCL)
					aValor[BR_LCFIN  ] += xMoeda(SA1->A1_LCFIN,nMCustoCL2,nMCustoCL)
					aValor[BR_SALDUP ] += SA1->A1_SALDUP
					aValor[BR_SALDUPM] += xMoeda(SA1->A1_SALDUPM,nMCustoCL2,nMCustoCL)
					aValor[BR_SALFIN ] += SA1->A1_SALFIN
					aValor[BR_SALFINM] += xMoeda(SA1->A1_SALFINM,nMCustoCL2,nMCustoCL)
					aValor[BR_SALPED ] += xMoeda(SA1->A1_SALPED,nMCustoCL2,nMCustoCL)
					aValor[BR_SALPEDB] += xMoeda(SA1->A1_SALPEDB,nMCustoCL2,nMCustoCL)
					aValor[BR_SALPEDL] += xMoeda(SA1->A1_SALPEDL,nMCustoCL2,nMCustoCL)
					aValor[BR_MCOMPRA] := Max(xMoeda(SA1->A1_MCOMPRA,nMCustoCL2,nMCustoCL),aValor[BR_MCOMPRA])
					aValor[BR_MAIDUPL] := Max(xMoeda(SA1->A1_MAIDUPL,nMCustoCL2,nMCustoCL),aValor[BR_MAIDUPL])
					aValor[BR_MSALDO ] := Max(xMoeda(SA1->A1_MSALDO,nMCustoCL2,nMCustoCL),aValor[BR_MSALDO ])
					aValor[BR_PAGATR ] += xMoeda(SA1->A1_PAGATR,nMCustoCL2,nMCustoCL)
					aValor[BR_NROPAG ] += SA1->A1_NROPAG
					aValor[BR_METR   ] := Max(SA1->A1_METR,aValor[BR_METR   ])
					aValor[BR_TITPROT] += SA1->A1_TITPROT
					aValor[BR_DTULTIT] := Max(SA1->A1_DTULTIT,aValor[BR_DTULTIT])
					aValor[BR_CHQDEVO] += SA1->A1_CHQDEVO
					aValor[BR_DTULCHQ] := Max(SA1->A1_DTULCHQ,aValor[BR_DTULCHQ])
					aValor[BR_PRICOM ] := Min(SA1->A1_PRICOM,aValor[BR_PRICOM ])
					aValor[BR_ULTCOM ] := Max(SA1->A1_ULTCOM,aValor[BR_ULTCOM ])
					aValor[BR_ULTVIS ] := Max(SA1->A1_ULTVIS,aValor[BR_ULTVIS ])
					aValor[BR_NROCOM]  += SA1->A1_NROCOM
				EndIf
				dbSelectArea("SA1")
				dbSkip()
			EndDo
			dbSelectArea("SA1")
			dbSetOrder(1)
			MsSeek(xFilial("SA1")+(cAliasTRB)->A1_COD+(cAliasTRB)->A1_LOJA)
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atualiza os dados do SA1 apenas uma vez                        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		lSA1 := .T.

		If lGestao
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Verifica se Filial esta compartilhada e força posicionar na prox filial³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If FWModeAccess("SA1",3)=="C" .And. FWModeAccess("SE1",3)=="C"
				nTam := At("F",SM0->M0_LEIAUTE)-1
				//posiciona na prox un de neg
				cEmpAtu	:= SM0->M0_CODFIL
				While !EOF() .And. SubStr(SM0->M0_CODFIL,1,nTam)==SubStr(cEmpAtu,1,nTam)
					lPosicion:= .T.
					SM0->(dbSkip())
				EndDo
			EndIf
		Else
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Forca a saida quando o SE1 estiver compartilhado               ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If ( FWModeAccess("SE1",3)=="C" .Or. FWModeAccess("SA1",3)=="E")
				Exit
			EndIf
		EndIf
		dbSelectArea("SM0")
		If !lPosicion
			SM0->(dbSkip())
		EndIf
	EndDo

	dbSelectArea("SM0")
	dbGoto(nSalvEmp)

	dbSelectArea("SA1")
	dbSetOrder(1)
	dbSeek(xFilial("SA1")+(cAliasTRB)->A1_COD+(cAliasTRB)->A1_LOJA)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Montagem do cabecalho dos dados a serem analisados                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nSaldoLC  := aValor[BR_LC]-aValor[BR_SALDUPM]-aValor[BR_SALPEDL]
	nIdealLC  := Abs(Min(nSaldoLc - aValor[BR_SALPEDB],0))

	aadd(aBrowse,{"","","","","","",""})
	aBrowse[01][1] := RetTitle("A1_LC")
	aBrowse[01][2] := AllTrim(TransForm(xMoeda(aValor[BR_LC],nMCustoCl,1),X3Picture("A1_LC")))
	aBrowse[01][3] := AllTrim(TransForm(xMoeda(aValor[BR_LC],nMCustoCl,nMCusto),X3Picture("A1_LC")))
	aBrowse[01][4] := RetTitle("A1_LCFIN")
	aBrowse[01][5] := AllTrim(TransForm(xMoeda(aValor[BR_LCFIN],nMCustoCl,1),X3Picture("A1_LCFIN")))
	aBrowse[01][6] := AllTrim(TransForm(xMoeda(aValor[BR_LCFIN],nMCustoCl,nMCusto),X3Picture("A1_LCFIN")))

	aadd(aBrowse,{"","","","","","",""})
	aBrowse[02][1] := RetTitle("A1_SALDUP")
	aBrowse[02][2] := AllTrim(TransForm(aValor[BR_SALDUP],X3Picture("A1_SALDUP")))
	aBrowse[02][3] := AllTrim(TransForm(xMoeda(aValor[BR_SALDUPM],nMCustoCl,nMCusto),X3Picture("A1_SALDUPM")))
	aBrowse[02][4] := RetTitle("A1_SALFIN")
	aBrowse[02][5] := AllTrim(TransForm(aValor[BR_SALFIN],X3Picture("A1_SALFIN")))
	aBrowse[02][6] := AllTrim(TransForm(xMoeda(aValor[BR_SALFINM],nMCustoCl,nMCusto,dDataBase),X3Picture("A1_SALFIN")))

	aadd(aBrowse,{"","","",	"","","",""})
	aBrowse[03][1] := RetTitle("A1_SALPED")
	aBrowse[03][2] := AllTrim(TransForm(xMoeda(aValor[BR_SALPED],nMCustoCl,1),X3Picture("A1_SALPED")))
	aBrowse[03][3] := AllTrim(TransForm(xMoeda(aValor[BR_SALPED],nMCustoCl,nMCusto),X3Picture("A1_SALPED")))

	aadd(aBrowse,{"","","","","","",""})
	aBrowse[04][1] := RetTitle("A1_SALPEDB")
	aBrowse[04][2] := AllTrim(TransForm(xMoeda(aValor[BR_SALPEDB],nMCustoCl,1),X3Picture("A1_SALPEDB")))
	aBrowse[04][3] := AllTrim(TransForm(xMoeda(aValor[BR_SALPEDB],nMCustoCl,nMCusto),X3Picture("A1_SALPEDB")))

	aadd(aBrowse,{"","","","","","",""})
	aBrowse[05][1] := RetTitle("A1_SALPEDL")
	aBrowse[05][2] := AllTrim(TransForm(xMoeda(aValor[BR_SALPEDL],nMCustoCl,1),X3Picture("A1_SALPEDL")))
	aBrowse[05][3] := AllTrim(TransForm(xMoeda(aValor[BR_SALPEDL],nMCustoCl,nMCusto),X3Picture("A1_SALPEDL")))

	aadd(aBrowse,{"","","","","","",""}) //"Saldo Limite Credito"
	aBrowse[06][1] := OemToAnsi(STR0025)
	aBrowse[06][2] := AllTrim(TransForm(xMoeda(nSaldoLC,nMCustoCl,1),X3Picture("A1_LC")))
	aBrowse[06][3] := AllTrim(TransForm(xMoeda(nSaldoLC,nMCustoCl,nMCusto),X3Picture("A1_LC")))
	aBrowse[06][4] := OemToAnsi(STR0062) //"Adicional LC"
	aBrowse[06][5] := AllTrim(TransForm(xMoeda(nIdealLC,nMCustoCl,1),X3Picture("A1_LC")))
	aBrowse[06][6] := AllTrim(TransForm(xMoeda(nIdealLC,nMCustoCl,nMCusto),X3Picture("A1_LC")))

	aadd(aBrowse,{"","","","","","",""})

	aadd(aBrowse,{"","","","","","",""})
	aBrowse[08][1] := OemToAnsi(RetTitle("A1_MCOMPRA"))
	aBrowse[08][2] := AllTrim(TransForm(xMoeda(aValor[BR_MCOMPRA],nMCustoCl,1),X3Picture("A1_MCOMPRA")))
	aBrowse[08][3] := AllTrim(TransForm(xMoeda(aValor[BR_MCOMPRA],nMCustoCl,nMCusto),X3Picture("A1_MCOMPRA")))
	aBrowse[08][4] := OemToAnsi(RetTitle("A1_MAIDUPL"))
	aBrowse[08][5] := AllTrim(TransForm(xMoeda(aValor[BR_MAIDUPL],nMCustoCl,1),X3Picture("A1_MAIDUPL")))
	aBrowse[08][6] := AllTrim(TransForm(xMoeda(aValor[BR_MAIDUPL],nMCustoCl,nMCusto),X3Picture("A1_MAIDUPL")))

	aadd(aBrowse,{"","","","","","",""})
	aBrowse[09][1] := RetTitle("A1_MSALDO")
	aBrowse[09][2] := AllTrim(TransForm(xMoeda(aValor[BR_MSALDO],nMCustoCl,1),X3Picture("A1_MSALDO")))
	aBrowse[09][3] := AllTrim(TransForm(xMoeda(aValor[BR_MSALDO],nMCustoCl,nMCusto),X3Picture("A1_MSALDO")))
	aBrowse[09][4] := RetTitle("A1_PAGATR")
	aBrowse[09][5] := AllTrim(TransForm(xMoeda(aValor[BR_PAGATR],1,1),X3Picture("A1_PAGATR")))
	aBrowse[09][6] := AllTrim(TransForm(xMoeda(aValor[BR_PAGATR],1,nMCusto),X3Picture("A1_PAGATR")))

	aadd(aBrowse,{"","","","","","",""})
	aBrowse[10][1] := RetTitle("A1_NROCOM")
	aBrowse[10][2] := AllTrim(TransForm(aValor[BR_NROCOM],X3Picture("A1_NROCOM")))
	aBrowse[10][3] := ""
	aBrowse[10][4] := RetTitle("A1_NROPAG")
	aBrowse[10][5] := AllTrim(TransForm(aValor[BR_NROPAG],X3Picture("A1_NROPAG")))
	aBrowse[10][6] := ""

	aadd(aBrowse,{"","","","","","",""})
	aBrowse[11][1] := OemToAnsi(OemToAnsi(STR0032)) //Atraso atual
	aBrowse[11][2] := AllTrim(TransForm(nValAtraso,X3Picture("A1_MCOMPRA")))
	aBrowse[11][3] := AllTrim(TransForm(xMoeda(nValAtraso,1,nMCusto),X3Picture("A1_MCOMPRA")))
	aBrowse[11][4] := RetTitle("A1_METR")
	aBrowse[11][5] := AllTrim(TransForm(aValor[BR_METR],X3Picture("A1_METR")))
	aBrowse[11][6] := ""

	aadd(aBrowse,{"","","","","","",""})
	aBrowse[12][1] := RetTitle("A1_TITPROT")
	aBrowse[12][2] := AllTrim(TransForm(aValor[BR_TITPROT],X3Picture("A1_TITPROT")))
	aBrowse[12][3] := ""
	aBrowse[12][4] := RetTitle("A1_DTULTIT")
	aBrowse[12][5] := DtoC(aValor[BR_DTULTIT])
	aBrowse[12][6] := ""

	aadd(aBrowse,{"","","","","","",""})
	aBrowse[13][1] := RetTitle("A1_CHQDEVO")
	aBrowse[13][2] := AllTrim(TransForm(aValor[BR_CHQDEVO],X3Picture("A1_CHQDEVO")))
	aBrowse[13][3] := ""
	aBrowse[13][4] := RetTitle("A1_DTULCHQ")
	aBrowse[13][5] := Dtoc(aValor[BR_DTULCHQ])
	aBrowse[13][6] := ""

	aadd(aBrowse,{"","","","","","",""})
	aBrowse[14][1] := RetTitle("A1_PRICOM")
	aBrowse[14][2] := AllTrim(TransForm(aValor[BR_PRICOM],X3Picture("A1_PRICOM")))
	aBrowse[14][3] := ""
	aBrowse[14][4] := RetTitle("A1_ULTCOM")
	aBrowse[14][5] := Dtoc(aValor[BR_ULTCOM])
	aBrowse[14][6] := ""

	aadd(aBrowse,{"","","","","","",""})
	aBrowse[15][1] := RetTitle("A1_ULTVIS")
	aBrowse[15][2] := AllTrim(TransForm(aValor[BR_ULTVIS],X3Picture("A1_ULTVIS")))
	aBrowse[15][3] := ""

	IF (Existblock("M450TMAN"))
		If !(ExecBlock("M450TMAN",.F.,.F.))
			lContinua := .F.
		Endif
	Endif

	IF (Existblock("M450BRW"))
		aBrowse := ExecBlock("M450BRW",.F.,.F., {aBrowse})
	Endif

	If lContinua
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Calcula as coordenadas da interface                                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		AAdd( aObjects, { 100, 030, .T., .F.,.T. } )
		AAdd( aObjects, { 100, 090, .T., .T.,.T. } )
		AAdd( aObjects, { 100, 030, .T., .F.,.F. } )
		aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
		aPosObj := MsObjSize( aInfo, aObjects,.T.)

		SetEnch(,.F.) //Retira o Texto do aRotina
		DEFINE MSDIALOG oDlg TITLE STR0063 FROM aSize[7],0 TO aSize[6],aSize[5] OF oMainWnd PIXEL //"Analise de Credito - ( CLIENTE )"
		oFolder := TFolder():New(aPosObj[2,1],aPosObj[2,2],{STR0067,STR0068,STR0069},{"",""},oDlg,,,,.T.,.F.,aPosObj[2,3],aPosObj[2,4]) //"Analise"###"Pedidos"###"Condicoes"
		@ aPosObj[1,1],aPosObj[1,2] MSPANEL oPanel PROMPT "" SIZE aPosObj[1,3],aPosObj[1,4] OF oDlg CENTERED RAISED
		cTexto1 := AllTrim(RetTitle("C5_CLIENTE"))+"/"+AllTrim(RetTitle("C5_LOJACLI"))+": "+SA1->A1_COD+"/"+SA1->A1_LOJA+"  -  "+RetTitle("A1_NOME")+": "+SA1->A1_NOME
		@ 003,005 SAY cTexto1 SIZE aPosObj[1,3],010 OF oPanel PIXEL
		cTexto2 := AllTrim(RetTitle("A1_RISCO"))+": "+X3Combo("A1_RISCO",SA1->A1_RISCO)
		cTexto2 += "  -  "+RetTitle("A1_CLASSE")+": "+X3Combo("A1_CLASSE",SA1->A1_CLASSE)
		cTexto2 += "  -  "+RetTitle("A1_VENCLC")+": "+Dtoc(SA1->A1_VENCLC)
		@ 015,005 SAY cTexto2 SIZE aPosObj[1,3],009 OF oPanel PIXEL

		@ 005,005 TO aPosObj[2,4]-20,aPosObj[2,3]-10 OF oFolder:aDialogs[3] PIXEL
		@ 010,010 RADIO oRadio VAR nTpLiber 3D SIZE 080,011 PROMPT STR0070,STR0071+cMoedaLC OF oFolder:aDialogs[3] PIXEL ; //"Todos os Pedidos"###"Liberar o valor de"
		ON CLICK (IIf(oRadio:nOption==2,oMsGet:Enable(),oMsGet:Disable()),nVlrLiber:=IIf(oRadio:nOption==1,0,nVlrLiber),oMsGet:Refresh())
		@ 019,92 MSGET oMsGet VAR nVlrLiber PICTURE X3Picture("A1_LC") SIZE 060,009 OF oFolder:aDialogs[3] PIXEL VALID nVlrLiber >= 0

		oGetDb := MsGetDB():New(005,005,aPosObj[2,4]-20,aPosObj[2,3]-10,1,"AlwaysTrue","AlwaysTrue","",.F., , ,.F., ,cAliasPed,Nil,Nil,Nil,oFolder:aDialogs[2])

		oBrowse := TSBrowse():New(5,5,aPosObj[2,3]-10,aPosObj[2,4]-20,oFolder:aDialogs[1],,35,,1 )
		oBrowse:SetArray(aBrowse)

		oColuna:= TcColumn():New(OemToAnsi(STR0064)) //"Informacoes"
		oColuna:lNoLite := .F.
		oColuna:nWidth  := 60
		oColuna:nAlign  := 0
		oBrowse:AddColumn(oColuna)

		oColuna1 := TcColumn():New(OemToAnsi(cMoeda1))
		oColuna1:lNoLite := .T.
		oColuna1:nWidth  := 60
		oColuna1:nAlign  := 2
		oBrowse:AddColumn(oColuna1)

		oColuna2 := TcColumn():New(OemToAnsi(cMCusto))
		oColuna2:lNoLite := .T.
		oColuna2:nWidth  := 60
		oColuna2:nAlign  := 2
		oBrowse:AddColumn(oColuna2)

		oColuna3 := TcColumn():New(OemToAnsi(STR0064)) //"Informacoes"
		oColuna3:lNoLite := .T.
		oColuna3:nWidth  := 60
		oColuna3:nAlign  := 0
		oBrowse:AddColumn(oColuna3)

		oColuna4 := TcColumn():New(OemToAnsi(cMoeda1))
		oColuna4:lNoLite := .T.
		oColuna4:nWidth  := 60
		oColuna4:nAlign  := 2
		oBrowse:AddColumn(oColuna4)

		oColuna5 := TcColumn():New(OemToAnsi(cMCusto))
		oColuna5:lNoLite := .T.
		oColuna5:nWidth  := 60
		oColuna5:nAlign  := 2
		oBrowse:AddColumn(oColuna5)

		oColuna6 := TcColumn():New(OemToAnsi(""))
		oColuna6:lNoLite := .T.
		oColuna6:nWidth  := 2
		oColuna6:nAlign  := 0
		oBrowse:AddColumn(oColuna6)

		@ aPosObj[3,1],aPosObj[3,2] TO aPosObj[3,3],aPosObj[3,4] OF oDlg PIXEL
		@ aPosObj[3,1]+10,aPosObj[3,2]+010 BUTTON OemToAnsi(STR0010)  SIZE 40,12 FONT oDlg:oFont ACTION (a450F4con()) OF oDlg PIXEL //"Consulta"
		@ aPosObj[3,1]+10,aPosObj[3,2]+050 BUTTON OemToAnsi(STR0037)  SIZE 40,12 FONT oDlg:oFont ACTION (cCadastro:=OemToAnsi(STR0037),A030Visual("SA1",SA1->(RecNo()),1) ) OF oDlg PIXEL //"Cliente"
		@ aPosObj[3,1]+10,aPosObj[3,2]+090 BUTTON OemToAnsi(STR0065)  SIZE 40,12 FONT oDlg:oFont ACTION (nOpcA := 1,oDlg:End() ) OF oDlg PIXEL //"Libera"
		@ aPosObj[3,1]+10,aPosObj[3,2]+130 BUTTON OemToAnsi(STR0012)  SIZE 40,12 FONT oDlg:oFont ACTION (nOpcA := 3,oDlg:End() ) OF oDlg PIXEL //"Rejeita"
		@ aPosObj[3,1]+10,aPosObj[3,2]+170 BUTTON OemToAnsi(STR0066)  SIZE 40,12 FONT oDlg:oFont ACTION (oDlg:End() ) OF oDlg PIXEL //"Sair"

		If ExistBlock( "MT450ABT" )
			aButtons := ExecBlock( "MT450ABT",.F.,.F. )
			nPosBtn := aPosObj[3,2]+170+40
			oBtn := tButton():New(aPosObj[3,1]+10,nPosBtn,"...",oDlg,,40,12,,,,.T.)
			oMenu := TMenu():New(0,0,0,0,.T.)
			If ValType( aButtons ) = "A"
				For nQtBtn := 1 To Len(aButtons)
					oMenu:Add(TMenuItem():New(oDlg,aButtons[nQtBtn][1],,,,aButtons[nQtBtn][2],,,,,,,,,.T.))
				Next
				oBtn:SetPopupMenu( oMenu )
				oDlg:Refresh()
			EndIf
		Endif

		ACTIVATE DIALOG oDlg CENTERED ON INIT oMsGet:Disable()

		IF (Existblock("M450CMAN"))
			If !(ExecBlock("M450CMAN",.F.,.F.,{nOpcA}))
				nOpcA := 0
			Endif
		Endif

		If nOpcA <> 0
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Efetua a atualizacao da liberacao dos pedidos                           ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea("SM0")
			dbSeek(cEmpresa)
			While Eval(bWhile)
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Seleciona a filial correta                                             ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				cFilAnt := FWGETCODFILIAL
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica o tipo de Liberacao                                           ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If ( SuperGetMv("MV_CREDCLI")=="L" )
					bWhileSC9  := {|| !Eof() .And. cCodCli == (cAliasSC9)->C9_CLIENTE+(cAliasSC9)->C9_LOJA}
					cCodCli := (cAliasTRB)->A1_COD+(cAliasTRB)->A1_LOJA
				Else
					bWhileSC9  := {|| !Eof() .And. cCodCli == (cAliasSC9)->C9_CLIENTE }
					cCodCli := (cAliasTRB)->A1_COD
				EndIf
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Efetua a liberacao/rejeicao dos itens liberados                        ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				dbSelectArea("SC9")
				dbSetOrder(2)
				#IFDEF TOP
				lQuery    := .T.
				cAliasSC9 := "Ma450ClMan"
				cAliasSC5 := "Ma450ClMan"
				cAliasSA1 := "Ma450ClMan"

				cQuery := "SELECT SC9.C9_CLIENTE,SC9.C9_LOJA,SC9.C9_BLCRED,SC9.R_E_C_N_O_ SC9RECNO,SC6.R_E_C_N_O_ SC6RECNO,SC5.C5_TIPLIB,C9_PEDIDO, "
				cQuery += "SC9.C9_PRCVEN,SC9.C9_QTDLIB,SA1.A1_MOEDALC,SC5.C5_MOEDA "
				cQuery += "FROM "+RetSqlName("SC9")+" SC9, "
				cQuery += RetSqlName("SA1")+" SA1, "
				cQuery += RetSqlName("SC5")+" SC5, "
				cQuery += RetSqlName("SC6")+" SC6 "
				cQuery += "WHERE SC9.C9_FILIAL='"+xFilial("SC9")+"' AND "
				cQuery += "SC9.C9_CLIENTE='"+(cAliasTRB)->A1_COD+"' AND "
				If ( SuperGetMv("MV_CREDCLI")=="L" )
					cQuery += "SC9.C9_LOJA='"+(cAliasTRB)->A1_LOJA+"' AND "
				EndIf
				cQuery += "SC9.C9_BLCRED<>'  ' AND "
				cQuery += "SC9.C9_BLCRED<>'09' AND "
				cQuery += "SC9.C9_BLCRED<>'10' AND "
				cQuery += "SC9.C9_BLCRED<>'ZZ' AND "
				cQuery += "SC9.D_E_L_E_T_=' ' AND "
				cQuery += "SC5.C5_FILIAL='"+xFilial("SC5")+"' AND "
				cQuery += "SC5.C5_NUM=SC9.C9_PEDIDO AND "
				cQuery += "SC5.D_E_L_E_T_=' ' AND "
				cQuery += "SA1.A1_FILIAL='"+xFilial("SA1")+"' AND "
				cQuery += "SA1.A1_COD=SC5.C5_CLIENTE AND "
				cQuery += "SA1.A1_LOJA=SC5.C5_LOJACLI AND "
				cQuery += "SA1.D_E_L_E_T_=' ' AND "
				cQuery += "SC6.C6_FILIAL='"+xFilial("SC6")+"' AND "
				cQuery += "SC6.C6_NUM=SC9.C9_PEDIDO AND "
				cQuery += "SC6.C6_ITEM=SC9.C9_ITEM AND "
				cQuery += "SC6.C6_PRODUTO=SC9.C9_PRODUTO AND "
				cQuery += "SC6.D_E_L_E_T_=' ' "
				cQuery += "ORDER BY "+SqlOrder(SC9->(IndexKey()))

				cQuery := ChangeQuery(cQuery)

				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSC9,.T.,.T.)

				#ELSE
				MsSeek(xFilial("SC9")+cCodCli)
				#ENDIF
				While Eval(bWhileSC9)
					If !lQuery
						dbSelectArea("SC5")
						dbSetOrder(1)
						MsSeek(xFilial("SC5")+(cAliasSC9)->C9_PEDIDO)

						dbSelectArea("SA1")
						dbSetOrder(1)
						MsSeek(xFilial("SA1")+(cAliasSC5)->C5_CLIENTE+(cAliasSC5)->C5_LOJACLI)
					EndIf
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Verifica o tipo de pedido                                           ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If (cAliasSC5)->C5_TIPLIB == "1" .Or. nOpcA <> 1
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Verifica o tipo de Liberacao                                        ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If nTpLiber == 1
							lValido := .T.
						Else
							If xMoeda(A410Arred((cAliasSC9)->C9_PRCVEN*(cAliasSC9)->C9_QTDLIB,"C6_VALOR"),(cAliasSC5)->C5_MOEDA,IIf((cAliasSA1)->A1_MOEDALC>0,(cAliasSA1)->A1_MOEDALC,Val(SuperGetMv("MV_MCUSTO")))) <= nVlrLiber
								lValido := .T.
							Else
								lValido := .F.
							EndIf
						EndIf
						If lValido
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Posiciono registros                                                 ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							If lQuery
								SC9->(MsGoto((cAliasSC9)->SC9RECNO))
							EndIf
							If !Empty((cAliasSC9)->C9_BLCRED) .And. (cAliasSC9)->C9_BLCRED<>'09' .And. (cAliasSC9)->C9_BLCRED<>'10' .And. (cAliasSC9)->C9_BLCRED<>'ZZ'
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³ Efetua a liberacao ou estorno                                       ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								If ( nOpcA == 1 )
									SC9->(a450Grava(1,.T.,.F.))

									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									//³ Pontos de Entrada 				                                    ³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
									If (ExistTemplate("MTA450I"))
										ExecTemplate("MTA450I",.F.,.F.,{nOpca,dDataBase})
									EndIf

									If (ExistBlock("MTA450I"))
										ExecBlock("MTA450I",.F.,.F.,{nOpca,dDataBase})
									EndIf
								Else
									SC9->(a450Grava(2,.T.,.F.))
									If (ExistBlock("MTA450R"))
										ExecBlock("MTA450R",.F.,.F.)
									EndIf
								EndIf
								nVlrLiber -= xMoeda(A410Arred((cAliasSC9)->C9_PRCVEN*(cAliasSC9)->C9_QTDLIB,"C6_VALOR"),(cAliasSC5)->C5_MOEDA,IIf((cAliasSA1)->A1_MOEDALC>0,(cAliasSA1)->A1_MOEDALC,Val(SuperGetMv("MV_MCUSTO"))))
							EndIf
						EndIf
					Else
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Efetua a Liberacao por pedido                                       ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If !Empty((cAliasSC9)->C9_BLCRED) .And. (cAliasSC9)->C9_BLCRED<>'09' .And. (cAliasSC9)->C9_BLCRED<>'10' .And. (cAliasSC9)->C9_BLCRED<>'ZZ'
							If !lQuery
								dbSelectArea("SC6")
								dbSetOrder(1)
								MsSeek(xFilial("SC6")+(cAliasSC9)->C9_PEDIDO+(cAliasSC9)->C9_ITEM+(cAliasSC9)->C9_PRODUTO)
								aadd(aRegSC6,SC6->(RecNo()))
							Else
								aadd(aRegSC6,(cAliasSC9)->SC6RECNO)
							EndIf
						EndIf
					EndIf
					cQuebra := (cAliasSC9)->C9_PEDIDO
					dbSelectArea(cAliasSC9)
					dbSkip()
					If cQuebra <> (cAliasSC9)->C9_PEDIDO .Or. (cAliasSC9)->(Eof())
						If (cAliasSC9)->(Eof())
							lEnd := .T.
						Else
							lEnd := .F.
						EndIf
						If (ExistBlock("MTA450RP"))
							ExecBlock("MTA450RP",.F.,.F.,{ nOpca, cQuebra } )
						EndIf
						Begin Transaction
							If !Empty(aRegSC6)
								dbSelectArea("SC5")
								dbSetOrder(1)
								MsSeek(xFilial("SC5")+cQuebra)
								MaAvalSC5("SC5",3,.F.,.F.,,,,,,cQuebra,aRegSC6,.T.,nTpLiber<>1,@nVlrLiber)
							EndIf
							If (ExistBlock("MTA450CL"))
								ExecBlock("MTA450CL",.F.,.F.,{nOpca,aRegSC6})
							EndIf
						End Transaction
						aRegSC6 := {}
						dbSelectArea(cAliasSC9)
						If lEnd
							Exit
						EndIf
					EndIf
				EndDo
				If lQuery
					dbSelectArea(cAliasSC9)
					dbCloseArea()
					dbSelectArea("SC9")
					cAliasSC9 := "SC9"
				EndIf
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Forca a saida quando o SC9 estiver compartilhado               ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If ( FWModeAccess("SC9",3)=="C".Or. FWModeAccess("SA1",3)=="E" )
					Exit
				EndIf
				dbSelectArea("SM0")
				dbSkip()
			EndDo
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Retira o cliente do arquivo temporario                         ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			RecLock(cAliasTRB)
			dbDelete()
			MsUnLock()
		EndIf
	Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Restaura a integridade da rotina                                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea(cAliasPed)
	dbCloseArea()
	Ferase(cNomePed+OrdBagExt())
	Ferase(cNomePed+GetDbExtension())
	RestArea(aAreaSC9)
	RestArea(aAreaSM0)
	RestArea(aArea)
	cFilAnt := cSavFil
Return(.T.)

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³A450ClAut ³ Rev.  ³ Eduardo Riera         ³ Data ³02.02.2002 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Rotina de interface da reavalicao de credito por cliente     ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                       ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                       ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Esta rotina realiza a interface com o usuario para a rotina  ³±±
±±³          ³de processamento da reavaliacao de credito.                  ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Materiais                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function ST2Ma450ClAut()

	Local aArea   := GetArea()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ mv_par01 Pedido de          ?                                 ³
	//³ mv_par02 Pedido ate         ?                                 ³
	//³ mv_par03 Cliente de         ?                                 ³
	//³ mv_par04 Cliente ate        ?                                 ³
	//³ mv_par05 Dta Liberacao de   ?                                 ³
	//³ mv_par06 Dta Liberacao ate  ?                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ( Pergunte("LIBAUT",.T.) )
		If MsgYesNo(OemToAnsi(STR0034),OemToAnsi(STR0035))       //"Confirma Libera‡„o Automatica dos Pedidos ?"###"Aten‡„o"
			Processa({|lEnd| Ma450Proces("SC9",.T.,.F.,@lEnd,FWModeAccess("SA1",3)=="C")},,,.T.)
			CloseBrowse()
		EndIf
	EndIf
	RestArea(aArea)
Return(Nil)

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³Ma450Psq  ³ Rev.  ³ Eduardo Riera         ³ Data ³02.02.2002 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Rotina de pesquisa da liberacao por cliente                  ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                       ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                       ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Esta rotina realiza a interface com o usuario para a pesquisa³±±
±±³          ³de clientes.                                                 ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Materiais                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function ST1Ma450Psq()

	Local xPesq    := Space(TamSx3("A1_COD")[1]+TamSx3("A1_LOJA")[1])
	Local nOpcA    := 0
	Local oDlg
	Local oBut1
	Local oBut2
	Local oBmp
	Local oPesq

	DEFINE MSDIALOG oDlg TITLE OemtoAnsi(STR0001)  FROM 09,0 TO 20,50 OF oMainWnd  //"Pesquisar"

	@ 000,000 BITMAP oBmp RESNAME "PROJETOAP" oF oDlg SIZE 30, 1000 NOBORDER WHEN .F. PIXEL ADJUST
	@ 014,035 SAY RetTitle("A1_COD")+"/"+RetTitle("A1_LOJA") of oDlg PIXEL
	@ 028,035 MSGET oPesq VAR xPesq Picture "@!" SIZE 153,010 Of oDlg PIXEL

	DEFINE SBUTTON oBut1 FROM 062, 130 TYPE 1 ACTION ( nOpca := 1, oDlg:End() ) ENABLE of oDlg
	DEFINE SBUTTON oBut2 FROM 062, 160 TYPE 2 ACTION ( nOpca := 0, oDlg:End() )  ENABLE of oDlg

	ACTIVATE MSDIALOG oDlg CENTERED

	If nOpcA == 1
		dbSelectArea("TRB")
		dbSetOrder(1)
		dbSeek(xPesq,.T.)
	EndIf
Return(.T.)

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³Ma450Refr ³Autor  ³ Eduardo Riera         ³ Data ³23.03.2006 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Rotina de refresh da rotina de liberacao de credito          ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                       ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                       ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Esta rotina realiza a interface com o usuario para a atualiza³±±
±±³          ³cao da interface de liberacao de credito                     ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Materiais                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function ST4Ma450Refr()

	MBrChgLoop(.F.)
	Processa({|lEnd| Eval(b450PCli,lEnd,.T.)},,,.T.)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³MenuDef   ³ Autor ³ Marco Bianchi         ³ Data ³01/09/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Utilizacao de menu Funcional                               ³±±
±±³          ³                                                            ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Array com opcoes da rotina.                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Parametros do array a Rotina:                               ³±±
±±³          ³1. Nome a aparecer no cabecalho                             ³±±
±±³          ³2. Nome da Rotina associada                                 ³±±
±±³          ³3. Reservado                                                ³±±
±±³          ³4. Tipo de Transa‡„o a ser efetuada:                        ³±±
±±³          ³    1 - Pesquisa e Posiciona em um Banco de Dados           ³±±
±±³          ³    2 - Simplesmente Mostra os Campos                       ³±±
±±³          ³    3 - Inclui registros no Bancos de Dados                 ³±±
±±³          ³    4 - Altera o registro corrente                          ³±±
±±³          ³    5 - Remove o registro corrente do Banco de Dados        ³±±
±±³          ³5. Nivel de acesso                                          ³±±
±±³          ³6. Habilita Menu Funcional                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function MenuDef()


	Private	aRotina := {	{STR0004	 ,"U_ST3Ma450ClMan"	, 0 , 0,0,NIL},;	// "Manual"
	{"Refresh","U_ST4Ma450Refr"	, 0 , 3,0,.F. }}	// "Refresh"

	/*
	Private	aRotina := {	{STR0001	 ,"U_ST1Ma450Psq"	, 0 , 1,0,.F.},;	// "Pesquisar"
	{STR0003	 ,"U_ST2Ma450ClAut"	, 0 , 0,0,NIL},;	// "Autom tica"
	{STR0004	 ,"U_ST3Ma450ClMan"	, 0 , 0,0,NIL},;	// "Manual"
	{"Refresh","U_ST4Ma450Refr"	, 0 , 3,0,.F. }}	// "Refresh"
	*/
	If ExistBlock("MA450MNU")
		ExecBlock("MA450MNU",.F.,.F.)
	EndIf

Return(aRotina)







