#INCLUDE "MATR260.CH"
#INCLUDE "PROTHEUS.CH"
#Include "TOPCONN.CH"

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � MATR260  � Autor � Marcos V. Ferreira    � Data � 16/06/06 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Posicao dos Estoques                                       ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.             ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   � BOPS �  Motivo da Alteracao                     ���
�������������������������������������������������������������������������Ĵ��
���            �        �      �                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/

User Function MATR260A()
	Local oReport
	Local nTamLOC      := TamSX3("B2_LOCAL")[1]
	Private cALL_LOC   := Replicate('*', nTamLOC)
	Private cALL_Empty := Replicate(' ', nTamLOC)
	Private cALL_ZZ    := Replicate('Z', nTamLOC)
	Private aSB1Ite    := {}
	Private lFirst	   := .T.
                                                                          
	aSB1Ite	:= TAMSX3("B1_CODITE")

	AjustaSX1()

	If FindFunction("TRepInUse") .And. TRepInUse()
	//������������������������������������������������������������������������Ŀ
	//�Interface de impressao                                                  �
	//��������������������������������������������������������������������������
		oReport:= ReportDef()
		oReport:PrintDialog()
	Else
		MATR260R3()
	EndIf

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportDef � Autor �Marcos V. Ferreira     � Data �16/06/06  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �A funcao estatica ReportDef devera ser criada para todos os ���
���          �relatorios que poderao ser agendados pelo usuario.          ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR260			                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ReportDef()
	Local lVersao	:= (VAL(GetVersao(.F.)) == 11 .And. GetRpoRelease() >= "R6" .Or. VAL(GetVersao(.F.))  > 11)
	Local aOrdem    := {OemToAnsi(STR0005),OemToAnsi(STR0006),OemToAnsi(STR0007),OemToAnsi(STR0008),OemToAnsi(STR0009)}    //" Por Codigo         "###" Por Tipo           "###" Por Descricao     "###" Por Grupo        "###" Por Almoxarifado   "
	Local cAliasTRB := CriaTrab( nil,.F. )
	Local aSizeQT	:= TamSX3("B2_QATU")
	Local aSizeVL	:= TamSX3("B2_VATU1")
	Local aSizeLZ   := If(lVersao,TamSX3("NNR_DESCRI"),TamSX3("B2_LOCALIZ"))
	Local cPictQT   := PesqPict("SB2","B2_QATU")
	Local cPictVL   := PesqPict("SB2","B2_VATU1")
	Local cPictLZ   := If(lVersao,PesqPict("NNR","NNR_DESCRI"),PesqPict("SB2","B2_LOCALIZ"))
	Local oSection

	Private lVeic    := Upper(GetMV("MV_VEICULO"))=="S"

	oReport:= TReport():New("MATR260",STR0001,"MTR260",,)

//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                           �
//����������������������������������������������������������������
//���������������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                                �
//� mv_par01     // Aglutina por: Almoxarifado / Filial / Empresa       �
//� mv_par02     // Filial de                                           �
//� mv_par03     // Filial ate                                          �
//� mv_par04     // almoxarifado de                                     �
//� mv_par05     // almoxarifado ate                                    �
//� mv_par06     // codigo de                                           �
//� mv_par07     // codigo ate                                          �
//� mv_par08     // tipo de                                             �
//� mv_par09     // tipo ate                                            �
//� mv_par10     // grupo de                                            �
//� mv_par11     // grupo ate                                           �
//� mv_par12     // descricao de                                        �
//� mv_par13     // descricao ate                                       �
//� mv_par14     // imprime produtos: Todos /Positivos /Negativos       �
//� mv_par15     // Saldo a considerar : Atual / Fechamento / Movimento |
//� mv_par16     // Qual Moeda (1 a 5)                                  �
//� mv_par17     // Aglutina por UM ?(S)im (N)ao                        �
//� mv_par18     // Lista itens zerados ? (S)im (N)ao                   �
//� mv_par19     // Imprimir o Valor ? Custo / Custo Std / Ult Prc Compr�
//� mv_par20     // Data de Referencia                                  �
//� mv_par21     // Lista valores zerados ? (S)im (N)ao                 �
//� mv_par22     // QTDE na 2a. U.M. ? (S)im (N)ao                      �
//� mv_par23     // Imprime descricao do Armazem ? (S)im (N)ao          �
//�����������������������������������������������������������������������
	Pergunte(oReport:uParam,.F.)

//������������������������������������������������������������������������Ŀ
//�Criacao do componente de impressao                                      �
//�                                                                        �
//�TReport():New                                                           �
//�ExpC1 : Nome do relatorio                                               �
//�ExpC2 : Titulo                                                          �
//�ExpC3 : Pergunte                                                        �
//�ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  �
//�ExpC5 : Descricao                                                       �
//�                                                                        �
//�������������������������������������������������������������������������� 
	oSection := TRSection():New(oReport,STR0053,{"SB2","SB1","SB2"},aOrdem) //"Saldos em Estoque"
	MontaTrab(oReport,oSection:GetOrder(),cAliasTRB,oSection,.T.)
	oReport:= TReport():New("MATR260",STR0001,"MTR260", {|oReport| ReportPrint(oreport,aOrdem,cAliasTRB)},STR0002+" "+STR0003+" "+STR0004) //"Relacao da Posicao do Estoque"
	If TamSX3("B1_COD")[1] > 15
		oReport:SetLandscape()
	EndIf

//��������������������������������������������������������������Ŀ
//� Criacao da Sessao 1                                          �
//���������������������������������������������������������������� 
	oSection := TRSection():New(oReport,STR0053,{"SB2","SB1",cAliasTRB},aOrdem) //"Saldos em Estoque"
	oSection:SetTotalInLine(.F.)

	TRCell():New(oSection,'B1_COD'		,'SB1',STR0036,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection,'B1_TIPO'		,'SB1',STR0037,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection,'B1_GRUPO'	,'SB1',STR0038,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection,'B1_DESC'		,'SB1',STR0039,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection,'B1_UM'		,'SB1',STR0040,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection,'B1_SEGUM'	,'SB1',STR0040,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection,'B2_FILIAL'	,'SB2',STR0041,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection,'B2_LOCAL'	,'SB2',STR0042,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)

	TRCell():New(oSection,'QUANT'		,cAliasTRB,STR0043+CRLF+STR0044,cPictQT						   ,aSizeQT[1],/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT")
	TRCell():New(oSection,'QUANTR'		,cAliasTRB,STR0045+CRLF+STR0046,cPictQT						   ,aSizeQT[1],/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT")
	TRCell():New(oSection,'DISPON'		,cAliasTRB,STR0047+CRLF+STR0048,cPictQT						   ,aSizeQT[1],/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT")
	TRCell():New(oSection,'VALOR'		,cAliasTRB,STR0049+CRLF+STR0044,If(cPaisLoc=="CHI",'',cPictVL),aSizeVL[1],/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT")
	TRCell():New(oSection,'VALORR'		,cAliasTRB,STR0049+CRLF+STR0050,If(cPaisLoc=="CHI",'',cPictVL),17/*aSizeVL[1]*/,/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT")
	TRCell():New(oSection,'DESCARM'		,cAliasTRB,STR0051+CRLF+STR0052,cPictLZ						    ,aSizeLZ[1],/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection,'ULTCOMP'		,cAliasTRB,"Ult. Compra"	,cPictLZ					    	,aSizeLZ[1],/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection,'ULTPROD'		,cAliasTRB,"Ult. Produ��o"	,cPictLZ					    	,aSizeLZ[1],/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection,'ULTVEND'		,cAliasTRB,"Ult. Venda"		,cPictLZ				    		,aSizeLZ[1],/*lPixel*/,/*{|| code-block de impressao }*/)

	oSection:SetHeaderPage()
	oSection:SetNoFilter(cAliasTRB)

Return(oReport)


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportPrint � Autor �Marcos V. Ferreira   � Data �16/06/06  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �A funcao estatica ReportPrint devera ser criada para todos  ���
���          �os relatorios que poderao ser agendados pelo usuario.       ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpO1: Objeto Report do Relatorio                           ���
���          �ExpA2: Array com as ordem do relatorio                      ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR260			                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ReportPrint(oReport,aOrdem,cAliasTRB)

	Local oSection   := oReport:Section(1)
	Local nOrdem     := oSection:GetOrder()
	Local aRegs      := {}
	Local cCodAnt    := ""
	Local lRet       := .T.
	Local oBreak01
	Local oBreak02
	Local oBreak03

//��������������������������������������������������������������Ŀ
//� Variaveis Private                                            |
//����������������������������������������������������������������
	Private lVeic    := Upper(GetMV("MV_VEICULO"))=="S"
//Private aSB1Ite := {}
//��������������������������������������������������������������Ŀ
//� Verifica se utiliza custo unificado por Empresa/Filial       �
//����������������������������������������������������������������
	Private lCusUnif := IIf(FindFunction("A330CusFil"),A330CusFil(),SuperGetMV('MV_CUSFIL',.F.))
	Private nDec     := MsDecimais(mv_par16)

//��������������������������������������������������������������Ŀ
//� Definicao do titulo do relatorio                             |
//����������������������������������������������������������������
	oReport:SetTitle(oReport:Title()+" - ("+AllTrim(aOrdem[oSection:GetOrder()])+" - "+AllTrim(GetMv("MV_SIMB"+Ltrim(Str(mv_par16))))+")")

//��������������������������������������������������������������Ŀ
//� Ajustar o SX1 para SIGAVEI, SIGAPEC e SIGAOFI                �
//����������������������������������������������������������������
	aSB1Ite	:= TAMSX3("B1_CODITE")

//��������������������������������������������������������������Ŀ
//� Definicao da linha de SubTotal                               |
//����������������������������������������������������������������
	If StrZero(nOrdem,1) $ "245"
		If nOrdem == 2
		//-- SubtTotal por Tipo
			oBreak01 := TRBreak():New(oSection,oSection:Cell("B1_TIPO"),STR0016+" "+STR0017,.F.)
		ElseIf nOrdem == 4
		//-- SubtTotal por Grupo
			oBreak01 := TRBreak():New(oSection,oSection:Cell("B1_GRUPO"),STR0016+" "+STR0018,.F.)
		ElseIf nOrdem == 5
		//-- SubtTotal por Armazem
			oBreak01 := TRBreak():New(oSection,oSection:Cell("B2_LOCAL"),STR0033,.F.)
		EndIf
		TRFunction():New(oSection:Cell('QUANT'	),NIL,"SUM",oBreak01,/*Titulo*/,/*cPicture*/,/*uFormula*/,.F.,.F.)
		TRFunction():New(oSection:Cell('QUANTR'	),NIL,"SUM",oBreak01,/*Titulo*/,/*cPicture*/,/*uFormula*/,.F.,.F.)
		TRFunction():New(oSection:Cell('DISPON'	),NIL,"SUM",oBreak01,/*Titulo*/,/*cPicture*/,/*uFormula*/,.F.,.F.)
		TRFunction():New(oSection:Cell('VALOR'	),NIL,"SUM",oBreak01,/*Titulo*/,/*cPicture*/,/*uFormula*/,.F.,.F.)
		TRFunction():New(oSection:Cell('VALORR'	),NIL,"SUM",oBreak01,/*Titulo*/,/*cPicture*/,/*uFormula*/,.F.,.F.)
	EndIf

//��������������������������������������������������������������Ŀ
//� Definicao da linha de SubTotal da Unidade de Medida          |
//����������������������������������������������������������������
	If mv_par17 == 1
		If mv_par22 == 1 //-- SubTotal pela 2a.U.M.
			oBreak02 := TRBreak():New(oSection,oSection:Cell("B1_SEGUM"),STR0019,.F.)
		Else //-- SubTotal pela 1a. U.M.
			oBreak02 := TRBreak():New(oSection,oSection:Cell("B1_UM"),STR0019,.F.)
		EndIf
		TRFunction():New(oSection:Cell('QUANT'	),NIL,"SUM",oBreak02,/*Titulo*/,/*cPicture*/,/*uFormula*/,.F.,.F.)
		TRFunction():New(oSection:Cell('QUANTR'	),NIL,"SUM",oBreak02,/*Titulo*/,/*cPicture*/,/*uFormula*/,.F.,.F.)
		TRFunction():New(oSection:Cell('DISPON'	),NIL,"SUM",oBreak02,/*Titulo*/,/*cPicture*/,/*uFormula*/,.F.,.F.)
		TRFunction():New(oSection:Cell('VALOR'	),NIL,"SUM",oBreak02,/*Titulo*/,/*cPicture*/,/*uFormula*/,.F.,.F.)
		TRFunction():New(oSection:Cell('VALORR'	),NIL,"SUM",oBreak02,/*Titulo*/,/*cPicture*/,/*uFormula*/,.F.,.F.)
	EndIf

//��������������������������������������������������������������Ŀ
//� Definicao da linha de Total Geral                            |
//����������������������������������������������������������������
	TRFunction():New(oSection:Cell('QUANT'	),NIL,"SUM",/*oBreak*/,/*Titulo*/,/*cPicture*/,/*uFormula*/,.T.,.F.)
	TRFunction():New(oSection:Cell('QUANTR'	),NIL,"SUM",/*oBreak*/,/*Titulo*/,/*cPicture*/,/*uFormula*/,.T.,.F.)
	TRFunction():New(oSection:Cell('DISPON'	),NIL,"SUM",/*oBreak*/,/*Titulo*/,/*cPicture*/,/*uFormula*/,.T.,.F.)
	TRFunction():New(oSection:Cell('VALOR'	),NIL,"SUM",/*oBreak*/,/*Titulo*/,/*cPicture*/,/*uFormula*/,.T.,.F.)
	TRFunction():New(oSection:Cell('VALORR'	),NIL,"SUM",/*oBreak*/,/*Titulo*/,/*cPicture*/,/*uFormula*/,.T.,.F.)

//���������������������������������������������������������������Ŀ
//�	Visualizar a coluna B1_UM ou B1_SEGUM conforme parametrizacao |
//�����������������������������������������������������������������
	If mv_par22 == 1
		oSection:Cell('B1_UM'):Disable()
	Else
		oSection:Cell('B1_SEGUM'):Disable()
	EndIf

//���������������������������������������������������������������Ŀ
//�	Visualizar "Descricao do Armazem" conforme parametrizacao     |
//�����������������������������������������������������������������
	If mv_par23 != 1
		oSection:Cell('DESCARM'):Disable()
	EndIf
//��������������������������������������������������������������Ŀ
//� Ajusta as perguntas para Custo Unificado                     |
//����������������������������������������������������������������
	If lCusUnif
		MA260PergU()
	EndIf

//��������������������������������������������������������������Ŀ
//� Ajusta as perguntas para Custo Unificado                     |
//����������������������������������������������������������������
	If lCusUnif .And. ((mv_par01==1) .Or. !(mv_par04==cALL_LOC) .Or. !(mv_par05==cALL_LOC) .Or. nOrdem==5)
		If Aviso(STR0024,STR0025+CHR(10)+CHR(13)+STR0029+CHR(10)+CHR(13)+STR0026+CHR(10)+CHR(13)+STR0027+CHR(10)+CHR(13)+STR0028+CHR(10)+CHR(13)+STR0030,{STR0031,STR0032}) == 2
			lRet := .F.
		EndIf
	EndIf

	If lRet

		If mv_par04 == cALL_LOC
			mv_par04 := cALL_Empty
		EndIf

		If mv_par05 == cALL_LOC
			mv_par05 := cALL_ZZ
		EndIf

	//��������������������������������������������������������������Ŀ
	//� Ajusta parametro de configuracao da Moeda                    |
	//����������������������������������������������������������������
		mv_par16 := If( ((mv_par16 < 1) .Or. (mv_par16 > 5)),1,mv_par16 )

	//��������������������������������������������������������������Ŀ
	//� Monta arquivo de trabalho                                    |
	//����������������������������������������������������������������

		MontaTrab(oReport,nOrdem,cAliasTRB,oSection,.F.)
	
	//��������������������������������������������������������������Ŀ
	//�	Processando Impressao                                        |
	//����������������������������������������������������������������
		oSection:aUserFilter := {}

		dbSelectArea( cAliasTRB )
		dbGoTop()
		oReport:SetMeter(LastRec())

	//��������������������������������������������������������������Ŀ
	//�	Posiciona nas tabelas SB1 e SB2                              |
	//����������������������������������������������������������������
		TRPosition():New(oSection,"SB1",1,{|| If(mv_par01==3 .And. FWModeAccess("SB1") == "E" .And. FWModeAccess("SB2") == "E",(cAliasTRB)->FILIAL+(cAliasTRB)->CODIGO,xFilial("SB1")+(cAliasTRB)->CODIGO)})
		TRPosition():New(oSection,"SB2",1,{|| (cAliasTRB)->FILIAL+(cAliasTRB)->CODIGO+(cAliasTRB)->LOCAL})

	//��������������������������������������������������������������Ŀ
	//�	Aglutina por Armazem/Filial/Empresa                          |
	//����������������������������������������������������������������
		If mv_par01 == 2
			If !(nOrdem == 5)
				oSection:Cell("B2_LOCAL"):SetValue(cALL_LOC)
			EndIf
		ElseIf mv_par01 == 3
			oSection:Cell("B2_FILIAL"):SetValue(Replicate("*",FWSizeFilial()))
			If !(nOrdem == 5)
				oSection:Cell("B2_LOCAL"):SetValue(cALL_LOC)
			EndIf
		EndIf

		oSection:Init()
		cCodAnt  := ""
		While !oReport:Cancel() .And. !Eof()

			oReport:IncMeter()
	
			If ( (mv_par14 == 1) .Or. ((mv_par14 == 2) .And. (QtdComp(FIELD->QUANT) >= QtdComp(0)) ) .Or. ;
					( (mv_par14 == 3) .And. (QtdComp(FIELD->QUANT) < QtdComp(0)) ) )

			//��������������������������������������������������������������Ŀ
			//�	Validacao para Custo Unificado com Qtde. Zerada              |
			//����������������������������������������������������������������
				If lCusUnif
					If (mv_par18==2) .And. (QtdComp(FIELD->QUANT)==QtdComp(0))
						dbSkip()
						Loop
					EndIf
				EndIf

				If (cAliasTRB)->CODIGO == cCodAnt
					oSection:Cell('B1_COD'		):Hide()
					oSection:Cell('B1_TIPO'		):Hide()
					oSection:Cell('B1_GRUPO'	):Hide()
					oSection:Cell('B1_DESC'		):Hide()
					If mv_par22 == 1
						oSection:Cell('B1_SEGUM'):Hide()
					Else
						oSection:Cell('B1_UM'	):Hide()
					EndIf
				Else
					oSection:Cell('B1_COD'		):Show()
					oSection:Cell('B1_TIPO'		):Show()
					oSection:Cell('B1_GRUPO'	):Show()
					oSection:Cell('B1_DESC'		):Show()
					If mv_par22 == 1
						oSection:Cell('B1_SEGUM'):Show()
					Else
						oSection:Cell('B1_UM'	):Show()
					EndIf
				EndIf
			
				oSection:PrintLine()
	
				cCodAnt := (cAliasTRB)->CODIGO
			EndIf
			dbSkip()
		EndDo

		oSection:Finish()

	//��������������������������������������������������������������Ŀ
	//�	Apagando arquivo de trabalho temporario                      |
	//����������������������������������������������������������������
		dbSelectArea( cAliasTRB )
		dbCloseArea()
		FErase( cAliasTRB+GetDBExtension() )
		FErase( cAliasTRB+OrdBagExt() )

	EndIf

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �MontaTrab | Autor � Marcos V. Ferreira    � Data � 16/06/06 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Preparacao do Arquivo de Trabalho p/ Relatorio             ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR260                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function MontaTrab(oReport,nOrdem,cAliasTRB,oSection,lVisualiz)
	Local cWhere	:= ""
	Local cWhereB1  := ""
	Local cWhereNNR := ""
	Local cIndxKEY	:= ""
	Local aSizeQT	:= TamSX3( "B2_QATU" )
	Local aSizeVL	:= TamSX3( "B2_VATU1")
	Local aSaldo	:= {}
	Local nQuant	:= 0
	Local nValor	:= 0
	Local nQuantR	:= 0
	Local nValorR	:= 0
	Local cFilOK	:= cFilAnt
	Local cAliasSB1	:= "SB1"
	Local lVersao	:= (VAL(GetVersao(.F.)) == 11 .And. GetRpoRelease() >= "R6" .Or. VAL(GetVersao(.F.))  > 11)
	Local lExcl		:= .F.
	Local lAglutLoc := .F.
	Local lAglutFil := .F.
	Local lAchou    := .F.
	Local cSeek     := ""
	Local cAliasSB2 := "SB2"
	Local cUM    	:= If(mv_par22 == 1,"SEGUM ","UM    ")
	Local aCampos 	:= {	{ "FILIAL"	,"C",FWSizeFilial(),00 },;
		{ "CODIGO"	,"C",TamSX3("B1_COD")[1],00 },;
		{ "LOCAL "	,"C",TamSX3("B2_LOCAL")[1],00 },;
		{ "TIPO "	,"C",02	,00 },;
		{ "GRUPO "	,"C",04	,00 },;
		{ "DESCRI"	,"C",TamSX3("B1_DESC")[1]	,00 },;
		{ cUM     	,"C",02	,00 },;
		{ "VALORR"	,"N",17	, 5 },;
		{ "QUANTR"	,"N",aSizeQT[ 1 ]+1	, aSizeQT[ 2 ] },;
		{ "VALOR "	,"N",aSizeVL[ 1 ]+1	, aSizeVL[ 2 ] },;
		{ "QUANT "	,"N",aSizeQT[ 1 ]+1	, aSizeQT[ 2 ] },;
		{ "DESCARM"	,"C",15	,00 },;
		{ "ULTCOMP"	,"D",10	,00 },;
		{ "ULTPROD"	,"D",10	,00 },;
		{ "ULTVEND"	,"D",10	,00 },;
		{ "DISPON"	,"N",aSizeQT[ 1 ]+1	, aSizeQT[ 2 ] };
		}

	Local cFilUser := oSection:GetAdvplExp()
	Local dDataRef
	Local aStrucSB1 := SB1->(dbStruct())
	Local aStrucSB2 := SB2->(dbStruct())
	Local nX

	Local cULTCOMP
	Local cULTPROD
	Local cULTVEND
	
	Local aLastQuery
	
	#IFNDEF TOP
		Local cIndSB1	:= ""
		Local nIndex	:= 0
		Local cFiltro   := ""
	#ENDIF
	Local XSB1 := SB1->(XFILIAL("SB1"))
	Local XSB2 := SB2->(XFILIAL("SB2"))

//>> Chamado 006643

	Local _cQuery	:= ""
	Local _cLocal	:= ""

	If Select( "TRB" ) > 0
		TRB->(dbCloseArea())
	EndIf

	_cQuery := " SELECT * FROM "+RetSqlName("NNR")+" NNR "
	_cQuery += " WHERE D_E_L_E_T_ = '' "
	
	_cQuery := ChangeQuery(_cQuery)
	
	dbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), "TRB", .F., .T.)

	DbSelectArea("TRB")
	DbGotop()

	//_cLocal := "'98'"

	While !EOF()
	
		If Empty(_cLocal)
			_cLocal := TRB->NNR_CODIGO+"'"
		Else
			_cLocal += ",'"+TRB->NNR_CODIGO+"'"
		EndIF
			
		DbSelectArea("TRB")
		DbSkip()
		
	End

	_cLocal += ",'98"
	
	//StrTran( _cLocal,  "" ) )
//<<

	Default lVisualiz:= .F.

	If !lFirst
		dbSelectArea( cAliasTRB )
		DBCLOSEAREA()
	else
		lfirst := .F.
	Endif
//��������������������������������������������������������������Ŀ
//�	Aglutina por Armazem/Filial/Empresa                          |
//����������������������������������������������������������������
	If mv_par01 == 2
		If !(nOrdem == 5)
			lAglutLoc := .T.
		EndIf
	ElseIf mv_par01 == 3
		lAglutFil := .T.
		If !(nOrdem == 5)
			lAglutLoc := .T.
		EndIf
	EndIf

	dDataRef := IIf(Empty(mv_par20),dDataBase,mv_par20)

//��������������������������������������������������������������Ŀ
//� Para SIGAVEI, SIGAPEC e SIGAOFI                              �
//����������������������������������������������������������������
	If !lVeic
		If (mv_par01 == 1)
			If (nOrdem == 5)
				cIndxKEY := "LOCAL"
			Else
				cIndxKEY := "FILIAL"
			EndIf
			Do Case
			Case (nOrdem == 1)
				If (mv_par17 == 1)
					cIndxKEY += "+" + cUM
				EndIf
				cIndxKEY += "+CODIGO+LOCAL"
			Case (nOrdem == 2)
				cIndxKEY += "+TIPO"
				If (mv_par17 == 1)
					cIndxKEY += "+" + cUM
				EndIf
				cIndxKEY += "+CODIGO+LOCAL"
			Case (nOrdem == 3)
				If (mv_par17 == 1)
					cIndxKEY += "+" + cUM
				EndIf
				cIndxKEY += "+DESCRI+CODIGO+LOCAL"
			Case (nOrdem == 4)
				cIndxKEY += "+GRUPO"
				If (mv_par17 == 1)
					cIndxKEY += "+" + cUM
				EndIf
				cIndxKEY += "+CODIGO+LOCAL"
			Case (nOrdem == 5)
				If (mv_par17 == 1)
					cIndxKEY += "+" + cUM
				EndIf
				cIndxKEY += "+CODIGO+FILIAL"
			OtherWise
				If (mv_par17 == 1)
					cIndxKEY += "+" + cUM
				EndIf
				cIndxKEY += "+CODIGO+LOCAL"
			EndCase
		Else //-- (mv_par01 == 1)
			If (nOrdem == 5)
				cIndxKEY := "LOCAL"
			Else
				cIndxKEY := ""
			EndIf

			Do Case
			Case (nOrdem == 1)
				If (mv_par17 == 1)
					cIndxKEY += (IIf(Empty(cIndxKEY),"","+")+ cUM)
				EndIf
				cIndxKEY += (IIf(Empty(cIndxKEY),"","+") + "CODIGO+FILIAL+LOCAL")
			Case (nOrdem == 2)
				cIndxKEY += (IIf(Empty(cIndxKEY),"","+") + "TIPO")
				If (mv_par17 == 1)
					cIndxKEY += (IIf(Empty(cIndxKEY),"","+")+ cUM)
				EndIf
				cIndxKEY += "+CODIGO+FILIAL+LOCAL"
			Case (nOrdem == 3)
				If (mv_par17 == 1)
					cIndxKEY += (IIf(Empty(cIndxKEY),"","+")+ cUM)
				EndIf
				cIndxKEY += (IIf(Empty(cIndxKEY),"","+") + "DESCRI+CODIGO+FILIAL+LOCAL")
			Case (nOrdem == 4)
				cIndxKEY += (IIf(Empty(cIndxKEY),"","+") + "GRUPO")
				If (mv_par17 == 1)
					cIndxKEY += (IIf(Empty(cIndxKEY),"","+")+ cUM)
				EndIf
				cIndxKEY += "+CODIGO+FILIAL+LOCAL"
			Case (nOrdem == 5)
				If (mv_par17 == 1)
					cIndxKEY += (IIf(Empty(cIndxKEY),"","+")+ cUM)
				EndIf
				cIndxKEY += (IIf(Empty(cIndxKEY),"","+") + "CODIGO+FILIAL")
			OtherWise
				If (mv_par17 == 1)
					cIndxKEY += (IIf(Empty(cIndxKEY),"","+")+ cUM)
				EndIf
				cIndxKEY += (IIf(Empty(cIndxKEY),"","+") + "CODIGO+LOCAL")
			EndCase
		EndIf
	Else
		aAdd(aCampos,{"CODITE","C",aSB1Ite[ 1 ],00})
		If (mv_par01 == 1) // ARMAZEN
			If (nOrdem == 5) // ALMOXARIFADO
				cIndxKEY := "LOCAL"
			Else
				cIndxKEY := "FILIAL"
			EndIf
			Do Case
			Case (nOrdem == 1)
				If (mv_par17 == 1)
					cIndxKEY += "+" + cUM
				EndIf
				cIndxKEY += "+CODITE+LOCAL"
			Case (nOrdem == 2)
				cIndxKEY += "+TIPO"
				If (mv_par17 == 1)
					cIndxKEY += "+" + cUM
				EndIf
				cIndxKEY += "+CODITE+LOCAL"
			Case (nOrdem == 3)
				If (mv_par17 == 1)
					cIndxKEY += "+" + cUM
				EndIf
				cIndxKEY += "+DESCRI+CODITE+LOCAL"
			Case (nOrdem == 4)
				cIndxKEY += "+GRUPO"
				If (mv_par17 == 1)
					cIndxKEY += "+" + cUM
				EndIf
				cIndxKEY += "+CODITE+LOCAL"
			Case (nOrdem == 5)
				If (mv_par17 == 1)
					cIndxKEY += "+" + cUM
				EndIf
				cIndxKEY += "+CODITE+FILIAL"
			OtherWise
				If (mv_par17 == 1)
					cIndxKEY += "+" + cUM
				EndIf
				cIndxKEY += "+CODITE+LOCAL"
			EndCase
		Else // FILIAL / EMPRESA
			If (nOrdem == 5) // ALMOXARIFADO
				cIndxKEY := "LOCAL"
			Else
				cIndxKEY := ""
			EndIf
			Do Case
			Case (nOrdem == 1) // CODIGO
				If (mv_par17 == 1)
					cIndxKEY += (IIf(Empty(cIndxKEY),"","+")+ cUM)
				EndIf
				cIndxKEY += (IIf(Empty(cIndxKEY),"","+") + "CODITE+FILIAL+LOCAL")
			Case (nOrdem == 2)
				cIndxKEY += (IIf(Empty(cIndxKEY),"","+") + "TIPO")
				If (mv_par17 == 1)
					cIndxKEY += (IIf(Empty(cIndxKEY),"","+")+ cUM)
				EndIf
				cIndxKEY += (IIf(Empty(cIndxKEY),"","+") + "CODITE+FILIAL+LOCAL")
			Case (nOrdem == 3)
				If (mv_par17 == 1)
					cIndxKEY += (IIf(Empty(cIndxKEY),"","+") + cUM)
				EndIf
				cIndxKEY += (IIf(Empty(cIndxKEY),"","+") + "DESCRI+CODITE+FILIAL+LOCAL")
			Case (nOrdem == 4)
				cIndxKEY += (IIf(Empty(cIndxKEY),"","+") + "GRUPO")
				If (mv_par17 == 1)
					cIndxKEY += (IIf(Empty(cIndxKEY),"","+") + cUM)
				EndIf
				cIndxKEY += (IIf(Empty(cIndxKEY),"","+") + "CODITE+FILIAL+LOCAL")
			Case (nOrdem == 5)
				If (mv_par17 == 1)
					cIndxKEY += (IIf(Empty(cIndxKEY),"","+") + cUM)
				EndIf
				cIndxKEY += (IIf(Empty(cIndxKEY),"","+") + "CODITE+FILIAL")
			OtherWise
				If (mv_par17 == 1)
					cIndxKEY += (IIf(Empty(cIndxKEY),"","+")+ cUM)
				EndIf
				cIndxKEY += (IIf(Empty(cIndxKEY),"","+") + "CODITE+LOCAL")
			EndCase
		EndIf
	EndIf

	dbSelectArea(0)
	dbCreate(cAliasTRB,aCampos)

	dbUseArea( .F.,,cAliasTRB,cAliasTRB,.F.,.F. )
	IndRegua(cAliasTRB,cAliasTRB,cIndxKEY,,,STR0013)   //"Organizando Arquivo..."

	If lVisualiz
		Return
	EndIf

	dbSelectArea("SB2")
	oReport:SetMeter(LastRec())

	#IFDEF TOP
		cSelect := "%"
		If !Empty(cFilUser)
			For nX := 1 To SB2->(FCount())
				cName := SB2->(FieldName(nX))
				If AllTrim( cName ) $ cFilUser
					If aStrucSB2[nX,2] <> "M"
						If !cName $ cSelect
							cSelect += ","+cName+" "
						Endif
					EndIf
				EndIf
			Next nX
			For nX := 1 To SB1->(FCount())
				cName := SB1->(FieldName(nX))
				If AllTrim( cName ) $ cFilUser
					If aStrucSB1[nX,2] <> "M"
						If !cName $ cSelect
							cSelect += ","+cName+" "
						Endif
					EndIf
				EndIf
			Next nX
		Endif
		cSelect += "%"
	//������������������������������������������������������������������������Ŀ
	//� Filtro adicional no clausula Where                                     |
	//��������������������������������������������������������������������������
		cWhere := "%"
		If lVeic
			cWhere += "SB1.B1_CODITE BETWEEN '" + mv_par06 + "' AND '" + mv_par07 + "' "
		Else
			cWhere += "SB1.B1_COD    BETWEEN '" + mv_par06 + "' AND '" + mv_par07 + "' "
		EndIf
		cWhere += "%"
	
		If lVersao
			cWhereB1 := "%"
			If mv_par01 <> 3
				cWhereB1 += ("   B1_FILIAL = '" + xSB1 + "'")
			Else
				If FWModeAccess("SB1") == "E" .And. FWModeAccess("SB2") == "E"
					cWhereB1 += " B1_FILIAL = B2_FILIAL"
				Else
					cWhereB1 += ("   B1_FILIAL = '" + xSB1 + "'")
				EndIf
			Endif
			cWhereB1 += "%"

			cWhereNNR := "%"
			If mv_par01 <> 3
				cWhereNNR += ("    NNR_FILIAL = '" + xFilial("NNR") + "'")
			Else
				If FWModeAccess("NNR") == "E" .And. FWModeAccess("SB2") == "E"
					cWhereNNR += "  NNR_FILIAL = B2_FILIAL"
				Else
					cWhereNNR += ("    NNR_FILIAL = '" + xFilial("NNR") + "'")
				EndIf
			Endif
			cWhereNNR += "%"
		Else
			cWhereB1 := "%"
			If mv_par01 <> 3
				cWhereB1 += ("   AND B1_FILIAL = '" + xSB1 + "'")
			Else
				If FWModeAccess("SB1") == "E" .And. FWModeAccess("SB2") == "E"
					cWhereB1 += " AND B1_FILIAL = B2_FILIAL"
				Else
					cWhereB1 += ("   AND B1_FILIAL = '" + xSB1 + "'")
				EndIf
			Endif
			cWhereB1 += "%"
		EndIf
	//������������������������������������������������������������������������Ŀ
	//�Transforma parametros Range em expressao SQL                            �
	//��������������������������������������������������������������������������
		MakeSqlExpr(oReport:uParam)

		cAliasSB2 := GetNextAlias()
		cAliasSB1 := cAliasSB2
	
		If lVersao
		//������������������������������������������������������������������������Ŀ
		//�Inicio do Embedded SQL                                                  �
		//��������������������������������������������������������������������������
			/*
			BeginSql Alias cAliasSB2
				SELECT B2_FILIAL, B2_LOCAL, B2_COD, B2_QATU, B2_QTSEGUM, B2_QFIM, B2_QFIM2, B2_VATU1, B2_VATU2,
				B2_VATU3, B2_VATU4, B2_VATU5, B2_VFIMFF1, B2_VFIMFF2, B2_VFIMFF3, B2_VFIMFF4, B2_VFIMFF5,
				B2_QEMP, B2_QEMP2, B2_QEMPPRE, B2_RESERVA, B2_RESERV2, B2_QEMPSA, B2_QEMPPRJ, B2_VFIM1,
				B2_QEMPPR2, B2_VFIM2, B2_VFIM3, B2_VFIM4, B2_VFIM5, B1_COD, B1_FILIAL, B1_TIPO, B1_GRUPO,
				B1_DESC, B1_GRUPO, B1_CUSTD, B1_UPRC, B1_MCUSTD, B1_SEGUM, B1_UM, B1_CODITE, NNR_DESCRI,
				B2_SALPPRE, B2_QEPRE2
				%Exp:cSelect%
		
				FROM %table:SB2% SB2,%table:SB1% SB1,%table:NNR% NNR
		
				WHERE SB2.B2_FILIAL BETWEEN %Exp:mv_par02% 	AND %Exp:mv_par03%
				AND SB2.B2_LOCAL BETWEEN %Exp:mv_par04% 	AND %Exp:mv_par05%
				AND SB2.B2_COD = SB1.B1_COD
					//AND SB2.B2_LOCAL = NNR.NNR_CODIGO
				AND SB2.B2_LOCAL IN (%Exp:_cLocal%)//Chamado 006643
				AND SB1.B1_GRUPO >= %Exp:mv_par10%
				AND SB1.B1_GRUPO <= %Exp:mv_par11%
				AND SB1.B1_DESC >= %Exp:mv_par12%
				AND SB1.B1_DESC  <= %Exp:mv_par13%
				AND SB1.B1_TIPO  BETWEEN %Exp:mv_par08% AND %Exp:mv_par09%
				AND %Exp:cWhereB1%
				AND %Exp:cWhereNNR%
				AND %Exp:cWhere%
				AND SB2.%NotDel%
				AND	 NNR.%NotDel%
				AND SB1.%NotDel%
			EndSql
			*/
			
			BeginSql Alias cAliasSB2
			
				SELECT B2_FILIAL, B2_LOCAL, B2_COD, B2_QATU, B2_QTSEGUM, B2_QFIM, B2_QFIM2, B2_VATU1, B2_VATU2,
				B2_VATU3, B2_VATU4, B2_VATU5, B2_VFIMFF1, B2_VFIMFF2, B2_VFIMFF3, B2_VFIMFF4, B2_VFIMFF5,
				B2_QEMP, B2_QEMP2, B2_QEMPPRE, B2_RESERVA, B2_RESERV2, B2_QEMPSA, B2_QEMPPRJ, B2_VFIM1,
				B2_QEMPPR2, B2_VFIM2, B2_VFIM3, B2_VFIM4, B2_VFIM5, B1_COD, B1_FILIAL, B1_TIPO, B1_GRUPO,
				B1_DESC, B1_GRUPO, B1_CUSTD, B1_UPRC, B1_MCUSTD, B1_SEGUM, B1_UM, B1_CODITE,B2_SALPPRE, B2_QEPRE2,
				(SELECT MAX(D1_DTDIGIT) DTCOM FROM %table:SD1% WHERE D1_COD = SB2.B2_COD AND D1_FILIAL = SB2.B2_FILIAL AND D_E_L_E_T_ = ' '  GROUP BY D1_COD) DTCOM,
				(SELECT MAX(D3_EMISSAO) DTPRD FROM %table:SD3% WHERE D3_COD = SB2.B2_COD AND D3_FILIAL = SB2.B2_FILIAL AND D3_CF = 'PR0' AND D_E_L_E_T_ = ' ' GROUP BY D3_COD) DTPRD,  
				(SELECT MAX(D2_EMISSAO) DTVEN FROM %table:SD2% WHERE D2_COD = SB2.B2_COD  AND D2_FILIAL = SB2.B2_FILIAL AND D_E_L_E_T_ = ' '  GROUP BY D2_COD) DTVEN     
				%Exp:cSelect%
		
				FROM %table:SB2% SB2,%table:SB1% SB1
		
				WHERE SB2.B2_FILIAL BETWEEN %Exp:mv_par02% 	AND %Exp:mv_par03%
				AND SB2.B2_LOCAL BETWEEN %Exp:mv_par04% 	AND %Exp:mv_par05%
				AND SB2.B2_COD = SB1.B1_COD
					//AND SB2.B2_LOCAL = NNR.NNR_CODIGO
				AND SB2.B2_LOCAL IN (%Exp:_cLocal%)//Chamado 006643
				AND SB1.B1_GRUPO >= %Exp:mv_par10%
				AND SB1.B1_GRUPO <= %Exp:mv_par11%
				AND SB1.B1_DESC >= %Exp:mv_par12%
				AND SB1.B1_DESC  <= %Exp:mv_par13%
				AND SB1.B1_TIPO  BETWEEN %Exp:mv_par08% AND %Exp:mv_par09%
				AND %Exp:cWhereB1%
				//AND %Exp:cWhereNNR%
				AND %Exp:cWhere%
				AND SB2.%NotDel%
				//AND	 NNR.%NotDel%
				AND SB1.%NotDel%
				
				//aLastQuery    := GetLastQuery()
				
			EndSql
			
		Else
		//������������������������������������������������������������������������Ŀ
		//�Inicio do Embedded SQL                                                  �
		//��������������������������������������������������������������������������
			BeginSql Alias cAliasSB2
				SELECT 	B2_FILIAL, B2_LOCAL, B2_COD, B2_QATU, B2_QTSEGUM, B2_QFIM, B2_QFIM2, B2_VATU1, B2_VATU2,
				B2_VATU3, B2_VATU4, B2_VATU5, B2_VFIMFF1, B2_VFIMFF2, B2_VFIMFF3, B2_VFIMFF4, B2_VFIMFF5,
				B2_QEMP, B2_QEMP2, B2_QEMPPRE, B2_RESERVA, B2_RESERV2, B2_QEMPSA, B2_QEMPPRJ, B2_VFIM1,
				B2_QEMPPR2, B2_VFIM2, B2_VFIM3, B2_VFIM4, B2_VFIM5, B1_COD, B1_FILIAL, B1_TIPO, B1_GRUPO,
				B1_DESC, B1_GRUPO, B1_CUSTD, B1_UPRC, B1_MCUSTD, B1_SEGUM, B1_UM, B1_CODITE, B2_LOCALIZ,
				B2_SALPPRE, B2_QEPRE2,
				(SELECT MAX(D1_DTDIGIT) DTCOM FROM %table:SD1% WHERE D1_COD = SB2.B2_COD AND D_E_L_E_T_ = ' '  GROUP BY D1_COD) DTCOM,
				(SELECT MAX(D3_EMISSAO) DTPRD FROM %table:SD3% WHERE D3_COD = SB2.B2_COD AND D3_CF = 'PR0' AND D_E_L_E_T_ = ' ' GROUP BY D3_COD) DTPRD,  
				(SELECT MAX(D2_EMISSAO) DTVEN FROM %table:SD2% WHERE D2_COD = SB2.B2_COD AND D_E_L_E_T_ = ' '  GROUP BY D2_COD) DTVEN     
				
				%Exp:cSelect%

				FROM %table:SB2% SB2,%table:SB1% SB1
	
				WHERE SB2.B2_FILIAL BETWEEN %Exp:mv_par02% 	AND %Exp:mv_par03% 					AND
				SB2.B2_LOCAL  BETWEEN %Exp:mv_par04% 	AND %Exp:mv_par05% 					AND
				SB2.%NotDel%							AND SB2.B2_COD = SB1.B1_COD
				%Exp:cWhereB1%                                                            AND
				SB1.%NotDel%					                                            AND
				SB1.B1_GRUPO  >= %Exp:mv_par10% 		AND SB1.B1_GRUPO <= %Exp:mv_par11%	AND
				SB1.B1_DESC   >= %Exp:mv_par12%		AND SB1.B1_DESC  <= %Exp:mv_par13%	AND
				SB1.B1_TIPO  BETWEEN %Exp:mv_par08%	AND %Exp:mv_par09%					AND
				%Exp:cWhere%

			EndSql
		EndIf
   	
	//��������������������������������������������������������������Ŀ
	//� Abertura do arquivo de trabalho                              |
	//����������������������������������������������������������������
		dbSelectArea( cAliasSB2 )

		For nX := 1 To Len(aStrucSB2)
			If ( aStrucSB2[nX][2] <> "C" .And. FieldPos(aStrucSB2[nX][1])<>0 )
				TcSetField(cAliasSB2,aStrucSB2[nX][1],aStrucSB2[nX][2],aStrucSB2[nX][3],aStrucSB2[nX][4])
			EndIf
		Next

	#ELSE
		dbSetOrder(1)

	//������������������������������������������������������������������������Ŀ
	//�Transforma parametros Range em expressao SQL                            �
	//��������������������������������������������������������������������������
		MakeAdvplExpr(oReport:uParam)

		cFiltro := "B2_FILIAL >= '" + mv_par02 + "' .AND. "
		cFiltro += "B2_FILIAL <= '" + mv_par03 + "' .AND. "

		If lVeic
			cFiltro += "B2_CODITE >= '"  + mv_par06 + "' .AND. "
			cFiltro += "B2_CODITE <= '"  + mv_par07 + "' .AND. "
		Else
			cFiltro += "B2_COD >= '"  + mv_par06 + "' .AND. "
			cFiltro += "B2_COD <= '"  + mv_par07 + "' .AND. "
		EndIf

		cFiltro += "B2_LOCAL  >= '" + mv_par04 + "' .AND. "
		cFiltro += "B2_LOCAL  <= '" + mv_par05 + "'"


		oSection:SetFilter(cFiltro,IndexKey())

		TRPosition():New(oSection,"SB1",1,{|| xFilial("SB1") + (cAliasSB2)->B2_COD})
	
	#ENDIF

	If xFilial("SB2") != Space(FwSizeFilial())
		lExcl := .T.
	EndIf

	dbSelectArea( cAliasSB2 )

	While !oReport:Cancel() .And. !Eof()

		If lExcl
			cFilAnt := (cAliasSB2)->B2_FILIAL
		EndIf

	//��������������������������������������������������������������Ŀ
	//� Considera filtro escolhido                                   �
	//����������������������������������������������������������������

		If !Empty(cFilUser)
			SB1->(dbSetOrder(1))
			SB1->(dbSeek( xFilial("SB1") + (cAliasSB2)->B2_COD) )
			If !(&(cFilUser))
				dbSkip()
				Loop
			EndIf
		EndIf
	
		oReport:IncMeter()
	
		Do Case
		Case (mv_par15 == 1)
			nQuant := If( mv_par22==1, ConvUM( (cAliasSB2)->B2_COD, (cAliasSB2)->B2_QATU, (cAliasSB2)->B2_QTSEGUM, 2 ), (cAliasSB2)->B2_QATU )
		Case (mv_par15 == 2)
			nQuant := If( mv_par22==1, ConvUM( (cAliasSB2)->B2_COD, (cAliasSB2)->B2_QFIM, (cAliasSB2)->B2_QFIM2, 2 ), (cAliasSB2)->B2_QFIM )
		Case (mv_par15 == 3)
			nQuant := (aSaldo := CalcEst( (cAliasSB2)->B2_COD,(cAliasSB2)->B2_LOCAL,dDataRef+1,(cAliasSB2)->B2_FILIAL ))[ If( mv_par22==1, 7, 1 ) ]
		Case (mv_par15 == 4)
			nQuant := If( mv_par22==1, ConvUM( (cAliasSB2)->B2_COD, (cAliasSB2)->B2_QFIM, (cAliasSB2)->B2_QFIM2, 2 ), (cAliasSB2)->B2_QFIM )
		Case (mv_par15 == 5)
			nQuant := (aSaldo := CalcEstFF( (cAliasSB2)->B2_COD,(cAliasSB2)->B2_LOCAL,dDataRef+1,(cAliasSB2)->B2_FILIAL ))[ If( mv_par22==1, 7, 1 ) ]
		EndCase
	
		#IFNDEF TOP
			dbSelectArea( cAliasSB1 )
			dbSetOrder(1)
			If (dbSeek( xFilial("SB1") + (cAliasSB2)->B2_COD) )
				If !(B1_GRUPO >= mv_par10 .And. B1_GRUPO <= mv_par11 .And. B1_DESC >= mv_par12 .And. B1_DESC <= mv_par13 .And. B1_TIPO >= mv_par08 .And. B1_TIPO <= mv_par09)
					dbSelectArea( cAliasSB2 )
					dbSkip()
					Loop
				EndIf
			EndIf
		#ENDIF
	
		dbSelectArea( cAliasSB1 )

		If (mv_par19 == 1)
			Do Case
			Case (mv_par15 == 1)
				nValor := (cAliasSB2)->(FieldGet( FieldPos( "B2_VATU"+Str( mv_par16,1 ) ) ))
			Case (mv_par15 == 2)
				nValor := (cAliasSB2)->(FieldGet( FieldPos( "B2_VFIM"+Str( mv_par16,1 ) ) ))
			Case (mv_par15 == 3)
				nValor := aSaldo[ 1+mv_par16 ]
			Case (mv_par15 == 4)
				nValor := (cAliasSB2)->(FieldGet( FieldPos( "B2_VFIMFF"+Str( mv_par16,1 ) ) ))
			Case (mv_par15 == 5)
				nValor := aSaldo[ 1+mv_par16 ]
			EndCase
		Else
		//�����������������������������������������������������������������Ŀ
		//� Converte valores para a moeda do relatorio (C.St. e U.Pr.Compra)�
		//�������������������������������������������������������������������
			Do Case
			Case (mv_par19 == 2)
				nValor := nQuant * xMoeda( RetFldProd((cAliasSB1)->B1_COD,"B1_CUSTD",cAliasSB1),Val( (cAliasSB1)->B1_MCUSTD ),mv_par16,dDataRef,4 )
			Case (mv_par19 == 3)  // Ult.Pr.Compra sempre na Moeda 1
				nValor := nQuant * xMoeda( RetFldProd((cAliasSB1)->B1_COD,"B1_UPRC" ,cAliasSB1),1,mv_par16,dDataRef,4 )
			EndCase
		EndIf
    
	//��������������������������������������������������������������Ŀ
	//� Verifica se devera ser impresso itens zerados                �
	//����������������������������������������������������������������
		If (mv_par18==2)  .And. (QtdComp(nQuant)==QtdComp(0))
			dbSelectArea( cAliasSB2 )
			dbSkip()
			Loop
		EndIf
				
	//��������������������������������������������������������������Ŀ
	//� Verifica se devera ser impresso valores zerados              �
	//����������������������������������������������������������������
		If (mv_par21==2) .And. (QtdComp(nValor)==QtdComp(0))
			dbSelectArea( cAliasSB2 )
			dbSkip()
			Loop
		EndIf

		If (mv_par22==1)
			nQuantR := (cAliasSB2)->B2_QEMP2 + AvalQtdPre("SB2",1,.T.,cAliasSB2) + (cAliasSB2)->B2_RESERV2  + ConvUM( (cAliasSB2)->B2_COD, (cAliasSB2)->B2_QEMPSA, 0, 2)+(cAliasSB2)->B2_QEMPPR2
		Else
			nQuantR := (cAliasSB2)->B2_QEMP + AvalQtdPre("SB2",1,NIL,cAliasSB2) + (cAliasSB2)->B2_RESERVA + (cAliasSB2)->B2_QEMPSA + (cAliasSB2)->B2_QEMPPRJ
		EndIf

		nValorR := (QtdComp(nValor) / QtdComp(nQuant)) * QtdComp(nQuantR)

	//���������������������������������������������������������������Ŀ
	//� Monta Chave de pesquisa para aglutinar Armazem/Filial/Empresa �
	//�����������������������������������������������������������������
		If lAglutLoc .Or. lAglutFil
			If (nOrdem == 5)
				cSeek := (cAliasSB2)->B2_LOCAL
			Else
				cSeek := ""
			EndIf
			Do Case
			Case (nOrdem == 1)
				If (mv_par17 == 1)
					cSeek += IIf(mv_par22==1,(cAliasSB1)->B1_SEGUM,(cAliasSB1)->B1_UM)
				EndIf
				cSeek += IIf(!lVeic,(cAliasSB2)->B2_COD,(cAliasSB2)->B1_CODITE)+IIf(lAglutFil,"",(cAliasSB2)->B2_FILIAL)+IIf(lAglutLoc,"",(cAliasSB2)->B2_LOCAL)
			Case (nOrdem == 2)
				cSeek += (cAliasSB1)->B1_TIPO
				If (mv_par17 == 1)
					cSeek += IIf(mv_par22==1,(cAliasSB1)->B1_SEGUM,(cAliasSB1)->B1_UM)
				EndIf
				cSeek += IIf(!lVeic,(cAliasSB2)->B2_COD,(cAliasSB2)->B1_CODITE)+IIf(lAglutFil,"",(cAliasSB2)->B2_FILIAL)+IIf(lAglutLoc,"",(cAliasSB2)->B2_LOCAL)
			Case (nOrdem == 3)
				If (mv_par17 == 1)
					cSeek += IIf(mv_par22==1,(cAliasSB1)->B1_SEGUM,(cAliasSB1)->B1_UM)
				EndIf
				cSeek += (cAliasSB1)->B1_DESC+IIf(!lVeic,(cAliasSB2)->B2_COD,(cAliasSB2)->B1_CODITE)+IIf(lAglutFil,"",(cAliasSB2)->B2_FILIAL)+IIf(lAglutLoc,"",(cAliasSB2)->B2_LOCAL)
			Case (nOrdem == 4)
				cSeek += (cAliasSB1)->B1_GRUPO
				If (mv_par17 == 1)
					cSeek += IIf(mv_par22==1,(cAliasSB1)->B1_SEGUM,(cAliasSB1)->B1_UM)
				EndIf
				cSeek += IIf(!lVeic,(cAliasSB2)->B2_COD,(cAliasSB2)->B1_CODITE)+IIf(lAglutFil,"",(cAliasSB2)->B2_FILIAL)+IIf(lAglutLoc,"",(cAliasSB2)->B2_LOCAL)
			Case (nOrdem == 5)
				If (mv_par17 == 1)
					cSeek += IIf(mv_par22==1,(cAliasSB1)->B1_SEGUM,(cAliasSB1)->B1_UM)
				EndIf
				cSeek += IIf(!lVeic,(cAliasSB2)->B2_COD,(cAliasSB2)->B1_CODITE)+IIf(lAglutFil,"",(cAliasSB2)->B2_FILIAL)
			OtherWise
				If (mv_par17 == 1)
					cSeek += IIf(mv_par22==1,(cAliasSB1)->B1_SEGUM,(cAliasSB1)->B1_UM)
				EndIf
				cSeek += IIf(!lVeic,(cAliasSB2)->B2_COD,(cAliasSB2)->B1_CODITE)+IIf(lAglutLoc,"",(cAliasSB2)->B2_LOCAL)
			EndCase
		EndIf

		dbSelectArea( cAliasTRB )
		If lAglutLoc .Or. lAglutFil
			lAchou := MsSeek(cSeek)
			RecLock(cAliasTRB,!lAchou)
		Else
			RecLock(cAliasTRB,.T.)
		EndIf
				
		FIELD->FILIAL := (cAliasSB2)->B2_FILIAL
		FIELD->CODIGO := (cAliasSB2)->B2_COD
		FIELD->LOCAL  := (cAliasSB2)->B2_LOCAL
		FIELD->TIPO   := (cAliasSB1)->B1_TIPO
		FIELD->GRUPO  := (cAliasSB1)->B1_GRUPO
		FIELD->DESCRI := (cAliasSB1)->B1_DESC
		If mv_par22 == 1
			FIELD->SEGUM  := (cAliasSB1)->B1_SEGUM
		Else
			FIELD->UM     := (cAliasSB1)->B1_UM
		EndIf
		FIELD->QUANTR += nQuantR
		FIELD->VALORR += Round(nValorR,nDec) //aqui
		FIELD->QUANT  += nQuant
		FIELD->VALOR  += Round(nValor,nDec)
		FIELD->DISPON += (nQuant - nQuantR)
		If lVeic
			FIELD->CODITE := (cAliasSB1)->B1_CODITE
		EndIf
		If mv_par23 == 1
			If lVersao
				FIELD->DESCARM := NNR->NNR_DESCRI
			Else
				FIELD->DESCARM := (cAliasSB2)->B2_LOCALIZ
			EndIf
		EndIf
				
		FIELD->ULTCOMP := Stod((cAliasSB2)->DTCOM) // Stod(VerDtCom((cAliasSB2)->B2_COD))
		 
		FIELD->ULTPROD := Stod((cAliasSB2)->DTPRD) // Stod(VerDtPrd((cAliasSB2)->B2_COD))
		
		FIELD->ULTVEND := Stod((cAliasSB2)->DTVEN) //Stod(VerDtVen((cAliasSB2)->B2_COD))
				 
		MsUnlock()
	
		dbSelectArea( cAliasSB2 )
		dbSkip()

	EndDo

	cFilAnt := cFilOk

//�������������������������������������������������������������������������������������Ŀ
//� Apaga os arquivos de trabalho, cancela os filtros e restabelece as ordens originais.|
//���������������������������������������������������������������������������������������
	#IFDEF TOP
		dbSelectArea(cAliasSB2)
		dbCloseArea()
		ChkFile("SB2",.F.)
	#ELSE
		dbSelectArea("SB1")
		RetIndex("SB1")
		Ferase(cIndSB1+OrdBagExt())
	#ENDIF

	dbSelectArea("SB1")
	dbClearFilter()

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �MATR260R3 � Autor � Eveli Morasco         � Data � 01/03/93 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Posicao dos Estoques                                       ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.             ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   � BOPS �  Motivo da Alteracao                     ���
�������������������������������������������������������������������������Ĵ��
���Marcelo Pim.�09/12/97�09827A�Ajuste da descricao p/ 30 caracteres.     ���
���Fernando J. �25/09/98�17720A� Corre��o no Salto de Linhas.             ���
���Fernando J. �02/12/98�18752A�A fun��o PesqPictQT foi substituida pela  ���
���            �        �      �PesqPict.                                 ���
���Fernando J. �21/12/98�18920A�Possibilitar filtragem pelo usuario.      ���
���Rodrigo Sart�08/02/99�META  �Avaliacao da qtd empenhada prevista.      ���
���Cesar       �30/03/99�XXXXXX�Manutencao na SetPrint()                  ���
���Patricia Sal�28/01/00�002121�Aumento da picture dos campos.            ���
���Jeremias    �09.02.00�Melhor�Validacao da comparacao dos valores e da  ���
���            �        �      �qtde quando do calculo do custo medio.    ���
���RicardoBerti�12/09/05�086108�Se Moeda#1 p/Cust.St.e U.P.Cp:usa xMoeda()���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/

Static Function MATR260R3()

//��������������������������������������������������������������Ŀ
//� Define Variaveis                                             �
//����������������������������������������������������������������

	Local Titulo   := STR0001	//"Relacao da Posicao do Estoque"
	Local wnrel    := "MATR260"
	Local cDesc1   := STR0002	//"Este relatorio emite a posicao dos saldos e empenhos de cada  produto"
	Local cDesc2   := STR0003	//"em estoque. Ele tambem mostrara' o saldo disponivel ,ou seja ,o saldo"
	Local cDesc3   := STR0004	//"subtraido dos empenhos."
	Local cString  := "SB1"
	Local aOrd     := {OemToAnsi(STR0005),OemToAnsi(STR0006),OemToAnsi(STR0007),OemToAnsi(STR0008),OemToAnsi(STR0009)}    //" Por Codigo         "###" Por Tipo           "###" Por Descricao     "###" Por Grupo        "###" Por Almoxarifado   "
	Local lEnd     := .F.
	Local Tamanho  := "M"
	Local aHelpPor := {},aHelpEng:={},aHelpSpa:={}
	Local aHelpP15 := {"Ao imprimir os itens sera considerado ","os saldos:","- Atual:       SB2->B2_VATU","- Fechamento:  SB2->B2_VFIM","- Movimento:   SD1,SD2,SD3,SB9","** O Empenho nao e retroativo, mesmo","quando selecionado por movimento sera","sempre baseado no saldo atual."}
	Local aHelpS15 := {"Al imprimir los itemes seran considerados","los saldos:","- Actual:  SB2->B2_VATU","- Cierre:  SB2->B2_VFIM","- Movimiento: SD1,SD2,SD3,SB9","**La reserva no es retroactiva,","aun cuando se seleccione por algun movimiento,","siempre se basara en el saldo actual."}
	Local aHelpE15 := {"At the moment the items are printed, it takes","in consideration the following balances:","- Current: SB2->B2_VATU","- Closing: SB2->B2_VFIM","- Movements: SD1,SD2,SD3,SB9","**Allocation is not retroactive,","even if the allocation is chosen by","movement, this will always be base on the","current balance."}

//��������������������������������������������������������������Ŀ
//� Variaveis tipo Local para SIGAVEI, SIGAPEC e SIGAOFI         �
//����������������������������������������������������������������
	Local aArea1	:= Getarea()
	Local nTamSX1   := Len(SX1->X1_GRUPO)

//��������������������������������������������������������������Ŀ
//� Variaveis tipo Private para SIGAVEI, SIGAPEC e SIGAOFI       �
//����������������������������������������������������������������
	Private lVeic   := Upper(GetMV("MV_VEICULO"))=="S"
	Private aSB1Cod := {}
	Private aSB1Ite := {}
	Private nCOL1	:= 0
	Private XSB1	:= SB1->(XFILIAL("SB1"))
	Private XSB2	:= SB2->(XFILIAL("SB2"))

//��������������������������������������������������������������Ŀ
//� Variaveis tipo Private padrao de todos os relatorios         �
//����������������������������������������������������������������
	Private aReturn  := {OemToAnsi(STR0010), 1,OemToAnsi(STR0011), 2, 2, 1, "",1 }   //"Zebrado"###"Administracao"
	Private nLastKey := 0 ,cPerg := "MTR260"
//��������������������������������������������������������������Ŀ
//� Verifica se utiliza custo unificado por Empresa/Filial       �
//����������������������������������������������������������������
	Private lCusUnif := IIf(FindFunction("A330CusFil"),A330CusFil(),SuperGetMV('MV_CUSFIL',.F.))

//�����������������������������������������������������������������Ŀ
//� Funcao utilizada para verificar a ultima versao dos fontes      �
//� SIGACUS.PRW, SIGACUSA.PRX e SIGACUSB.PRX, aplicados no rpo do   |
//| cliente, assim verificando a necessidade de uma atualizacao     |
//| nestes fontes. NAO REMOVER !!!							        �
//�������������������������������������������������������������������
	If !(FindFunction("SIGACUS_V") .and. SIGACUS_V() >= 20050512)
		Aviso("Atencao","Atualizar patch do programa SIGACUS.PRW !!!",{"Ok"})
		Return
	EndIf
	If !(FindFunction("SIGACUSA_V") .and. SIGACUSA_V() >= 20050512)
		Aviso("Atencao","Atualizar patch do programa SIGACUSA.PRX !!!",{"Ok"})
		Return
	EndIf
	If !(FindFunction("SIGACUSB_V") .and. SIGACUSB_V() >= 20050512)
		Aviso("Atencao","Atualizar patch do programa SIGACUSB.PRX !!!",{"Ok"})
		Return
	EndIf

//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                           �
//����������������������������������������������������������������
//���������������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                                �
//� mv_par01     // Aglutina por: Almoxarifado / Filial / Empresa       �
//� mv_par02     // Filial de       *                                   �
//� mv_par03     // Filial ate      *                                   �
//� mv_par04     // almoxarifado de *                                   �
//� mv_par05     // almoxarifado ate*                                   �
//� mv_par06     // codigo de       *                                   �
//� mv_par07     // codigo ate      *                                   �
//� mv_par08     // tipo de         *                                   �
//� mv_par09     // tipo ate        *                                   �
//� mv_par10     // grupo de        *                                   �
//� mv_par11     // grupo ate       *                                   �
//� mv_par12     // descricao de    *                                   �
//� mv_par13     // descricao ate   *                                   �
//� mv_par14     // imprime produtos: Todos /Positivos /Negativos       �
//� mv_par15     // Saldo a considerar : Atual / Fechamento / Movimento |
//� mv_par16     // Qual Moeda (1 a 5)                                  �
//� mv_par17     // Aglutina por UM ?(S)im (N)ao                        �
//� mv_par18     // Lista itens zerados ? (S)im (N)ao                   �
//� mv_par19     // Imprimir o Valor ? Custo / Custo Std / Ult Prc Compr�
//� mv_par20     // Data de Referencia                                  �
//� mv_par21     // Lista valores zerados ? (S)im (N)ao                 �
//� mv_par22     // QTDE na 2a. U.M. ? (S)im (N)ao                      �
//� mv_par23     // Imprime descricao do Armazem ? (S)im (N)ao          �
//�����������������������������������������������������������������������
	Aadd(aHelpPor, "Data de referencia para calculo do saldo" )
	Aadd(aHelpPor, "do produto quando utiliza saldo por     " )
	Aadd(aHelpPor, "movimento.                              " )
	Aadd(aHelpEng, "Reference date for product`s balances   " )
	Aadd(aHelpEng, "calculation, when using balance per     " )
	Aadd(aHelpEng, "transaction/movement.                   " )
	Aadd(aHelpSpa, "Fecha de referencia para calculo del    " )
	Aadd(aHelpSpa, "saldo del producto cuando usa saldo por " )
	Aadd(aHelpSpa, "movimiento.                             " )
	PutSx1("MTR260", "20","Data de Referencia  ","Data de Referencia  ","Reference Date           ","mv_chK","D",8,0,0,"G","","","","","mv_par20","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)
	PutSx1("MTR260","22","QTDE. na 2a. U.M. ?","CTD. EN 2a. U.M. ?","QTTY. in 2a. U.M. ?", "mv_chm", "N", 1, 0, 2,"C", "", "", "", "","mv_par22","Sim","Si","Yes", "","Nao","No","No", "", "", "", "", "", "", "", "", "", "", "", "", "")
	PutSX1Help("P.MTR26015.",aHelpP15,aHelpE15,aHelpS15)
	aHelpPor :={}
	aHelpEng :={}
	aHelpSpa :={}
	Aadd(aHelpPor,"Imprime descricao do Armazem. Sim ou Nao" )
	Aadd(aHelpEng,"Print warehouse description. Yes or No  " )
	Aadd(aHelpSpa,"Imprime descripcion del almacen. Si o No" )
	PutSx1("MTR260","23","Imprime descricao do Armazem ?","Imprime descripc. del almacen?","Print warehouse description ?","mv_chn","N",1,0,2,"C","","","","","mv_par23","Sim","Si","Yes","","Nao","No","No","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

//��������������������������������������������������������������Ŀ
//� Ajustar o SX1 para SIGAVEI, SIGAPEC e SIGAOFI                �
//����������������������������������������������������������������
	aSB1Cod	:= TAMSX3("B1_COD")
	aSB1Ite	:= TAMSX3("B1_CODITE")

	If lVEIC
		Tamanho := "G"
		nCol1	:= ABS(aSB1Cod[1] - aSB1Ite[1]) + 1 +  aSB1Cod[1]
		dbSelectArea("SX1")
		dbSetOrder(1)
		dbSeek(PADR(cPerg,nTamSX1))
		Do While SX1->X1_GRUPO == PADR(cPerg,nTamSX1) .And. !SX1->(Eof())
			If "PRODU" $ Upper(SX1->X1_PERGUNT) .And. Upper(SX1->X1_TIPO) == "C" .And. (SX1->X1_TAMANHO <> aSB1Ite[1] .Or. Upper(SX1->X1_F3) <> "VR4")
				Reclock("SX1",.F.)
				SX1->X1_TAMANHO := aSB1Ite[1]
				SX1->X1_F3 := "VR4"
				dbCommit()
				MsUnlock()
			EndIf
			dbSkip()
		EndDo
		dbCommitAll()
		RestArea(aArea1)
	Else
		dbSelectArea("SX1")
		dbSetOrder(1)
		dbSeek(PADR(cPerg,nTamSX1))
		Do While SX1->X1_GRUPO == PADR(cPerg,nTamSX1) .And. !SX1->(Eof())
			If "PRODU" $ Upper(SX1->X1_PERGUNT) .And. Upper(SX1->X1_TIPO) == "C" .And. (SX1->X1_TAMANHO <> aSB1Cod[1] .OR. UPPER(SX1->X1_F3) <> "SB1")
				Reclock("SX1",.F.)
				SX1->X1_TAMANHO := aSB1Cod[1]
				SX1->X1_F3 := "SB1"
				dbCommit()
				MsUnlock()
			EndIf
			dbSkip()
		EndDo
		dbCommitAll()
		RestArea(aArea1)
	EndIf

	Pergunte(cPerg,.F.)

	If mv_par23 == 1
		Tamanho := "G"
	Else
		Tamanho := "M"
	Endif

	If lCusUnif //-- Ajusta as perguntas para Custo Unificado
		MA260PergU()
	EndIf
//��������������������������������������������������������������Ŀ
//� Envia controle para a funcao SETPRINT                        �
//����������������������������������������������������������������

	wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,Tamanho)
	If nLastKey = 27
		dbClearFilter()
		Return
	Endif

	If lCusUnif .And. ((mv_par01==1).Or.!(mv_par04==cALL_LOC).Or.!(mv_par05==cALL_LOC).Or.aReturn[8]==5) //-- Ajusta as perguntas para Custo Unificado
		If Aviso(STR0024, STR0025+CHR(10)+CHR(13)+STR0029+CHR(10)+CHR(13)+STR0026+CHR(10)+CHR(13)+STR0027+CHR(10)+CHR(13)+STR0028+CHR(10)+CHR(13)+STR0030, {STR0031,STR0032}) == 2
			dbClearFilter()
			Return Nil
		EndIf
	EndIf

	If mv_par04 == cALL_LOC
		mv_par04 := cALL_Empty
	EndIf
	If mv_par05 == cALL_LOC
		mv_par05 := cALL_ZZ
	Endif

	SetDefault(aReturn,cString)
	If nLastKey = 27
		dbClearFilter()
		Return
	Endif

	mv_par16 := If( ((mv_par16 < 1) .Or. (mv_par16 > 5)),1,mv_par16 )
	Tipo     := IIf(aReturn[4]==1,15,18)

	If Type("NewHead")#"U"
		Titulo := (NewHead+" ("+AllTrim( aOrd[ aReturn[ 8 ] ] )+" - "+AllTrim(GetMv("MV_SIMB"+Ltrim(Str(mv_par16))))+")")
	Else
		Titulo += " ("+AllTrim( aOrd[ aReturn[ 8 ] ] )+" - "+AllTrim(GetMv("MV_SIMB"+Ltrim(Str(mv_par16))))+")"
	EndIf

	cFileTRB := ""
	RptStatus( { | lEnd | cFileTRB := r260Select( @lEnd ) },Titulo+STR0023 ) //": Preparacao..."

	If !Empty( cFileTRB )
		RptStatus({|lEnd| R260Imprime( @lEnd,cFileTRB,Titulo,wNRel,Tamanho,Tipo,aReturn[ 8 ] )},titulo)
	EndIf

Return NIL

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �R260SELECT� Autor � Ben-Hur M. Castilho   � Data � 20/11/96 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Preparacao do Arquivo de Trabalho p/ Relatorio             ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR260                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function R260Select( lEnd )
	Local cFileTRB	:= ""
	Local cIndxKEY	:= ""
	Local aSizeQT	:= TamSX3( "B2_QATU" )
	Local aSizeVL	:= TamSX3( "B2_VATU1")
	Local aSaldo	:= {}
	Local nQuant	:= 0
	Local nValor	:= 0
	Local nQuantR	:= 0
	Local nValorR	:= 0
	Local cFilOK	:= cFilAnt
	Local cAl1		:= "SB1"
	Local cAl2		:= "SB2"
	Local lVersao	:= (VAL(GetVersao(.F.)) == 11 .And. GetRpoRelease() >= "R6" .Or. VAL(GetVersao(.F.))  > 11)
	Local lExcl		:= .F.
	Local cIndSB1	:= ""
	Local nIndex	:= 0
	Local cUM    	:= If(mv_par22 == 1,"SEGUM ","UM    ")
	Local aCampos 	:= {	{ "FILIAL","C",02,00 },;
		{ "CODIGO","C",TamSX3("B1_COD")[1],00 },;
		{ "LOCAL ","C",TamSX3("B2_LOCAL")[1],00 },;
		{ "TIPO  ","C",02,00 },;
		{ "GRUPO ","C",04,00 },;
		{ "DESCRI","C",TamSX3("B1_DESC")[1],00 },;
		{ cUM     ,"C",02,00 },;
		{ "VALORR","N",17, 5 },;
		{ "QUANTR","N",aSizeQT[ 1 ]+1, aSizeQT[ 2 ] },;
		{ "VALOR ","N",aSizeVL[ 1 ]+1, aSizeVL[ 2 ] },;
		{ "QUANT ","N",aSizeQT[ 1 ]+1, aSizeQT[ 2 ] },;
		{ "DESCARM","C",15,00 },;
		{ "ULTCOMP","D",10,00 },;
		{ "ULTPROD","D",10,00 },;
		{ "ULTVEND","D",10,00 };
		}
	Local dDataRef
	Local lAglutLoc := .F.
	Local lAglutFil := .F.
	Local cSeek     := ""

	#IFDEF TOP
		Local aStruSB1	:= {}
		Local cName
		Local cQryAd	:= ""
		Local cQuery	:= ""
		Local nX
	#ENDIF


	Private nDec    := MsDecimais(mv_par16)

//��������������������������������������������������������������Ŀ
//�	Aglutina por Armazem/Filial/Empresa                          |
//����������������������������������������������������������������
	If mv_par01 == 2
		If !(aReturn[8] == 5)
			lAglutLoc := .T.
		EndIf
	ElseIf mv_par01 == 3
		lAglutFil := .T.
		If !(aReturn[8] == 5)
			lAglutLoc := .T.
		EndIf
	EndIf

	dDataRef := IIf(Empty(mv_par20),dDataBase,mv_par20)

//��������������������������������������������������������������Ŀ
//� Para SIGAVEI, SIGAPEC e SIGAOFI                              �
//����������������������������������������������������������������

	If !lVeic
		If (mv_par01 == 1)
			If (aReturn[ 8 ] == 5)
				cIndxKEY := "LOCAL"
			Else
				cIndxKEY := "FILIAL"
			EndIf
			Do Case
			Case (aReturn[ 8 ] == 1)
				If (mv_par17 == 1)
					cIndxKEY += "+" + cUM
				EndIf
				cIndxKEY += "+CODIGO+LOCAL"
			Case (aReturn[ 8 ] == 2)
				cIndxKEY += "+TIPO"
				If (mv_par17 == 1)
					cIndxKEY += "+" + cUM
				EndIf
				cIndxKEY += "+CODIGO+LOCAL"
			Case (aReturn[ 8 ] == 3)
				If (mv_par17 == 1)
					cIndxKEY += "+" + cUM
				EndIf
				cIndxKEY += "+DESCRI+CODIGO+LOCAL"
			Case (aReturn[ 8 ] == 4)
				cIndxKEY += "+GRUPO"
				If (mv_par17 == 1)
					cIndxKEY += "+" + cUM
				EndIf
				cIndxKEY += "+CODIGO+LOCAL"
			Case (aReturn[ 8 ] == 5)
				If (mv_par17 == 1)
					cIndxKEY += "+" + cUM
				EndIf
				cIndxKEY += "+CODIGO+FILIAL"
			OtherWise
				If (mv_par17 == 1)
					cIndxKEY += "+" + cUM
				EndIf
				cIndxKEY += "+CODIGO+LOCAL"
			EndCase
		Else // 	If (mv_par01 == 1)
			If (aReturn[ 8 ] == 5)
				cIndxKEY := "LOCAL"
			Else
				cIndxKEY := ""
			EndIf

			Do Case
			Case (aReturn[ 8 ] == 1)
				If (mv_par17 == 1)
					cIndxKEY += (iif(empty(cIndxKEY),"","+")+ cUM)
				EndIf
				cIndxKEY += (iif(empty(cIndxKEY),"","+") + "CODIGO+FILIAL+LOCAL")
			Case (aReturn[ 8 ] == 2)
				cIndxKEY += (iif(empty(cIndxKEY),"","+") + "TIPO")
				If (mv_par17 == 1)
					cIndxKEY += (iif(empty(cIndxKEY),"","+")+ cUM)
				EndIf
				cIndxKEY += "+CODIGO+FILIAL+LOCAL"
			Case (aReturn[ 8 ] == 3)
				If (mv_par17 == 1)
					cIndxKEY += (iif(empty(cIndxKEY),"","+")+ cUM)
				EndIf
				cIndxKEY += (iif(empty(cIndxKEY),"","+") + "DESCRI+CODIGO+FILIAL+LOCAL")
			Case (aReturn[ 8 ] == 4)
				cIndxKEY += (iif(empty(cIndxKEY),"","+") + "GRUPO")
				If (mv_par17 == 1)
					cIndxKEY += (iif(empty(cIndxKEY),"","+")+ cUM)
				EndIf
				cIndxKEY += "+CODIGO+FILIAL+LOCAL"
			Case (aReturn[ 8 ] == 5)
				If (mv_par17 == 1)
					cIndxKEY += (iif(empty(cIndxKEY),"","+")+ cUM)
				EndIf
				cIndxKEY += (iif(empty(cIndxKEY),"","+") + "CODIGO+FILIAL")
			OtherWise
				If (mv_par17 == 1)
					cIndxKEY += (iif(empty(cIndxKEY),"","+")+ cUM)
				EndIf
				cIndxKEY += (iif(empty(cIndxKEY),"","+") + "CODIGO+LOCAL")
			EndCase
		EndIf
	Else
		aAdd(aCampos,{"CODITE","C",aSB1Ite[ 1 ],00})
		If (mv_par01 == 1) // ARMAZEN
			If (aReturn[ 8 ] == 5) // ALMOXARIFADO
				cIndxKEY := "LOCAL"
			Else
				cIndxKEY := "FILIAL"
			EndIf
			Do Case
			Case (aReturn[ 8 ] == 1)
				If (mv_par17 == 1)
					cIndxKEY += "+" + cUM
				EndIf
				cIndxKEY += "+CODITE+LOCAL"
			Case (aReturn[ 8 ] == 2)
				cIndxKEY += "+TIPO"
				If (mv_par17 == 1)
					cIndxKEY += "+" + cUM
				EndIf
				cIndxKEY += "+CODITE+LOCAL"
			Case (aReturn[ 8 ] == 3)
				If (mv_par17 == 1)
					cIndxKEY += "+" + cUM
				EndIf
				cIndxKEY += "+DESCRI+CODITE+LOCAL"
			Case (aReturn[ 8 ] == 4)
				cIndxKEY += "+GRUPO"
				If (mv_par17 == 1)
					cIndxKEY += "+" + cUM
				EndIf
				cIndxKEY += "+CODITE+LOCAL"
			Case (aReturn[ 8 ] == 5)
				If (mv_par17 == 1)
					cIndxKEY += "+" + cUM
				EndIf
				cIndxKEY += "+CODITE+FILIAL"
			OtherWise
				If (mv_par17 == 1)
					cIndxKEY += "+" + cUM
				EndIf
				cIndxKEY += "+CODITE+LOCAL"
			EndCase
		Else // FILIAL / EMPRESA
			If (aReturn[ 8 ] == 5) // ALMOXARIFADO
				cIndxKEY := "LOCAL"
			Else
				cIndxKEY := ""
			EndIf
			Do Case
			Case (aReturn[ 8 ] == 1) // CODIGO
				If (mv_par17 == 1)
					cIndxKEY += (iif(empty(cIndxKEY),"","+")+ cUM)
				EndIf
				cIndxKEY += (iif(empty(cIndxKEY),"","+") + "CODITE+FILIAL+LOCAL")
			Case (aReturn[ 8 ] == 2)
				cIndxKEY += (iif(empty(cIndxKEY),"","+") + "TIPO")
				If (mv_par17 == 1)
					cIndxKEY += (iif(empty(cIndxKEY),"","+")+ cUM)
				EndIf
				cIndxKEY += (iif(empty(cIndxKEY),"","+") + "CODITE+FILIAL+LOCAL")
			Case (aReturn[ 8 ] == 3)
				If (mv_par17 == 1)
					cIndxKEY += (iif(empty(cIndxKEY),"","+") + cUM)
				EndIf
				cIndxKEY += (iif(empty(cIndxKEY),"","+") + "DESCRI+CODITE+FILIAL+LOCAL")
			Case (aReturn[ 8 ] == 4)
				cIndxKEY += (iif(empty(cIndxKEY),"","+") + "GRUPO")
				If (mv_par17 == 1)
					cIndxKEY += (iif(empty(cIndxKEY),"","+") + cUM)
				EndIf
				cIndxKEY += (iif(empty(cIndxKEY),"","+") + "CODITE+FILIAL+LOCAL")
			Case (aReturn[ 8 ] == 5)
				If (mv_par17 == 1)
					cIndxKEY += (iif(empty(cIndxKEY),"","+") + cUM)
				EndIf
				cIndxKEY += (iif(empty(cIndxKEY),"","+") + "CODITE+FILIAL")
			OtherWise
				If (mv_par17 == 1)
					cIndxKEY += (iif(empty(cIndxKEY),"","+")+ cUM)
				EndIf
				cIndxKEY += (iif(empty(cIndxKEY),"","+") + "CODITE+LOCAL")
			EndCase
		EndIf
	EndIf
	cFileTRB := CriaTrab( nil,.F. )

	dbSelectArea(0)
	DbCreate( cFileTRB,aCampos )

	dbUseArea( .F.,,cFileTRB,cFileTRB,.F.,.F. )
	IndRegua( cFileTRB,cFileTRB,cIndxKEY,,,OemToAnsi(STR0013))   //"Organizando Arquivo..."

	dbSelectArea( "SB2" )
	SetRegua(LastRec())

	#IFDEF TOP
		cQuery := "SELECT B2_FILIAL, B2_LOCAL, B2_COD, B2_QATU, B2_QTSEGUM, B2_QFIM, B2_QFIM2, B2_VATU1, B2_VATU2"
		cQuery += ", B2_VATU3, B2_VATU4, B2_VATU5"
		cQuery += ", B2_VFIMFF1, B2_VFIMFF2, B2_VFIMFF3, B2_VFIMFF4, B2_VFIMFF5, B2_QEMP, B2_QEMP2"
		cQuery += ", B2_QEMPPRE, B2_RESERVA, B2_RESERV2, B2_QEMPSA, B2_QEMPPRJ, B2_VFIM1, B2_QEMPPR2"
		cQuery += ", B2_VFIM2, B2_VFIM3, B2_VFIM4, B2_VFIM5, B1_COD, B1_FILIAL, B1_TIPO"
		cQuery += ", B1_GRUPO, B1_DESC, B1_GRUPO, B1_CUSTD, B1_UPRC, B2_SALPPRE, B2_QEPRE2"
		If mv_par19 == 2
			cQuery += ", B1_MCUSTD"
		EndIf
		If mv_par22 == 1
			cQuery += ", B1_SEGUM"
		Else
			cQuery += ", B1_UM"
		Endif
		if lVEIC
			cQuery += ", B1_CODITE"
		endif
		If mv_par23 == 1
			If lVersao
				cQuery += ", NNR_DESCRI"
			Else
				cQuery += ", B2_LOCALIZ"
			EndIf
		Endif

		aStruSB1 := SB1->(dbStruct())

		If !Empty(aReturn[7])
			For nX := 1 To SB1->(FCount())
				cName := SB1->(FieldName(nX))
				If AllTrim( cName ) $ aReturn[7]
					If aStruSB1[nX,2] <> "M"
						If !cName $ cQuery .And. !cName $ cQryAd
							cQryAd += ", " + cName
						EndIf
					EndIf
				EndIf
			Next nX
		EndIf

		cQuery += cQryAd
		If lVersao
			cQuery += (" FROM " + RetSqlName("SB2") + " B2, " + RetSqlName("SB1") + " B1, "+ RetSqlName("NNR") + " NNR")
		Else
			cQuery += (" FROM " + RetSqlName("SB2") + " B2, " + RetSqlName("SB1") + " B1")
		EndIf
		cQuery += (" WHERE B2_FILIAL BETWEEN '" + MV_PAR02 + "' AND '" + MV_PAR03 + "'")
		cQuery += ("   AND B2_LOCAL  BETWEEN '" + MV_PAR04 + "' AND '" + MV_PAR05 + "'")
		if lVEIC
			cQuery += ("   AND B1_CODITE   BETWEEN '" + MV_PAR06 + "' AND '" + MV_PAR07 + "'")
		ELSE
			cQuery += ("   AND B2_COD    BETWEEN '" + MV_PAR06 + "' AND '" + MV_PAR07 + "'")
		ENDIF
		cQuery +=  "   AND B2.D_E_L_E_T_ = ' '"
		cQuery +=  "   AND B2_COD = B1_COD"
		If lVersao
		//cQuery +=  "   AND B2_LOCAL = NNR_CODIGO "
			cQuery +=  "   AND B2_LOCAL IN("+_cLocal+") "
		EndIf
		If mv_par01 <> 3
			cQuery += ("   AND B1_FILIAL = '" + xSB1 + "'")
			If lVersao
				cQuery += ("   AND NNR_FILIAL = '" + xFilial("NNR") + "'")
			EndIf
		Else
			If FWModeAccess("SB1") == "E" .And. FWModeAccess("SB2") == "E"
				cQuery += " AND B1_FILIAL = B2_FILIAL"
			Else
				cQuery += ("   AND B1_FILIAL = '" + xSB1 + "'")
			EndIf
		
			If lVersao .And. FWModeAccess("NNR") == "E" .And. FWModeAccess("SB2") == "E"
				cQuery += " AND NNR_FILIAL = B2_FILIAL"
			ElseIf lVersao
				cQuery += ("   AND NNR_FILIAL = '" + xFilial("NNR") + "'")
			EndIf
		Endif
		cQuery +=  "   AND B1.D_E_L_E_T_ = ' '"
		If lVersao
			cQuery +=  "   AND NNR.D_E_L_E_T_ = ' '"
		EndIf
		cQuery += ("   AND B1_TIPO  between '" + MV_PAR08 + "' AND '" + MV_PAR09 + "'")
		cQuery += ("   AND B1_GRUPO between '" + MV_PAR10 + "' AND '" + MV_PAR11 + "'")
		cQuery += ("   AND B1_DESC  between '" + MV_PAR12 + "' AND '" + MV_PAR13 + "'")
	
		cAl1 := "xxSB2"
		cAl2 := "xxSB2"
		cQuery := ChangeQuery(cQuery)
	
		dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAl2, .F., .T.)

		aEval(SB2->(dbStruct()), {|x| If(x[2] <> "C" .And. FieldPos(x[1]) > 0, TcSetField(cAl2,x[1],x[2],x[3],x[4]),Nil)})
		aEval(SB1->(dbStruct()), {|x| If(x[2] <> "C" .And. FieldPos(x[1]) > 0, TcSetField(cAl2,x[1],x[2],x[3],x[4]),Nil)})
	#ELSE
		dbSetOrder(1)
		If lVEIC
			dbSeek(MV_PAR02,.T.)
		Else
			dbSeek(MV_PAR02+MV_PAR06+MV_PAR04,.T.)
		EndIf

	//��������������������������������������������������������������������������������������������������Ŀ
	//� Quando houver filtro do usuario sera aplicada a Indregua p/ otimizar performance em Ambiente CDX.|
	//����������������������������������������������������������������������������������������������������	
		If !Empty(aReturn[7])
			cIndSB1 := CriaTrab( Nil,.F. )
			dbSelectArea(cAl1)
			dbSetOrder(1)
			IndRegua(cAl1,cIndSB1,SB1->(IndexKey()),,aReturn[7])
			nIndex := RetIndex("SB1")
			dbSetIndex(cIndSB1+OrdBagExt())
			dbSetOrder(nIndex+1)
			dbGoTop()
		EndIf

	#ENDIF

	If xSB2 != "  "
		lExcl := .T.
	EndIf

	dbSelectArea( cAl2 )

	While !Eof()
		If lExcl
			cFilAnt := (cAl2)->B2_FILIAL
		EndIf

		IncRegua()
	
		If	( ( (cAl2)->B2_FILIAL >= MV_PAR02 ) .And. ( (cAl2)->B2_FILIAL <= MV_PAR03 ) )	.And. ;
				( ( (cAl2)->B2_Local  >= MV_PAR04 ) .And. ( (cAl2)->B2_Local  <= MV_PAR05 ) )	.And. ;
				(IIf( lVeic, .T. ,( (cAl2)->B2_COD >= mv_par06 ) .And. ( (cAl2)->B2_COD <= mv_par07 ) ) )
				
			#IFNDEF TOP
				dbSelectArea( cAl1 )
				dbSetOrder(nIndex+1)
				If (dbSeek( XSB1 + (cAl2)->B2_COD) )
					If (	(	((cAl1)->B1_TIPO  >= mv_par08 ) .And. ((cAl1)->B1_TIPO  <= mv_par09 )) .And. ;
							(	((cAl1)->B1_GRUPO >= mv_par10 ) .And. ((cAl1)->B1_GRUPO <= mv_par11 )) .And. ;
							(	((cAl1)->B1_DESC  >= mv_par12 ) .And. ((cAl1)->B1_DESC  <= mv_par13 )))
					#ELSE
						If (	(	((cAl1)->B1_TIPO  >= mv_par08 ) .And. ((cAl1)->B1_TIPO  <= mv_par09 )) .And. ;
								(	((cAl1)->B1_GRUPO >= mv_par10 ) .And. ((cAl1)->B1_GRUPO <= mv_par11 )) .And. ;
								(	((cAl1)->B1_DESC  >= mv_par12 ) .And. ((cAl1)->B1_DESC  <= mv_par13 )) .And. ;
								(	(!Empty(aReturn[7]) .And. &(aReturn[7]) ) .Or. Empty(aReturn[7]));
								)
						#ENDIF

						Do Case
						Case (mv_par15 == 1)
							nQuant := If( mv_par22==1, ConvUM( (cAl2)->B2_COD, (cAl2)->B2_QATU, (cAl2)->B2_QTSEGUM, 2 ), (cAl2)->B2_QATU )
						Case (mv_par15 == 2)
							nQuant := If( mv_par22==1, ConvUM( (cAl2)->B2_COD, (cAl2)->B2_QFIM, (cAl2)->B2_QFIM2, 2 ), (cAl2)->B2_QFIM )
						Case (mv_par15 == 3)
							nQuant := (aSaldo := CalcEst( (cAl2)->B2_COD,(cAl2)->B2_LOCAL,dDataRef+1,(cAl2)->B2_FILIAL ))[ If( mv_par22==1, 7, 1 ) ]
						Case (mv_par15 == 4)
							nQuant := If( mv_par22==1, ConvUM( (cAl2)->B2_COD, (cAl2)->B2_QFIM, (cAl2)->B2_QFIM2, 2 ), (cAl2)->B2_QFIM )
						Case (mv_par15 == 5)
							nQuant := (aSaldo := CalcEstFF( (cAl2)->B2_COD,(cAl2)->B2_LOCAL,dDataRef+1,(cAl2)->B2_FILIAL ))[ If( mv_par22==1, 7, 1 ) ]
						EndCase
				
						dbSelectArea( cAl1 )
					
						If (mv_par19 == 1)
							Do Case
							Case (mv_par15 == 1)
								nValor := (cAl2)->(FieldGet( FieldPos( "B2_VATU"+Str( mv_par16,1 ) ) ))
							Case (mv_par15 == 2)
								nValor := (cAl2)->(FieldGet( FieldPos( "B2_VFIM"+Str( mv_par16,1 ) ) ))
							Case (mv_par15 == 3)
								nValor := aSaldo[ 1+mv_par16 ]
							Case (mv_par15 == 4)
								nValor := (cAl2)->(FieldGet( FieldPos( "B2_VFIMFF"+Str( mv_par16,1 ) ) ))
							Case (mv_par15 == 5)
								nValor := aSaldo[ 1+mv_par16 ]
							EndCase
						Else
					//�����������������������������������������������������������������Ŀ
					//� Converte valores para a moeda do relatorio (C.St. e U.Pr.Compra)�
					//�������������������������������������������������������������������
							Do Case
							Case (mv_par19 == 2)
								nValor := nQuant * xMoeda( RetFldProd((cAL1)->B1_COD,"B1_CUSTD",cAL1),Val( (cAL1)->B1_MCUSTD ),mv_par16,dDataRef,4 )
							Case (mv_par19 == 3)  // Ult.Pr.Compra sempre na Moeda 1
								nValor := nQuant * xMoeda( RetFldProd((cAL1)->B1_COD,"B1_UPRC" ,cAL1),1,mv_par16,dDataRef,4 )
							EndCase
						EndIf
                
				//��������������������������������������������������������������Ŀ
				//� Verifica se devera ser impresso itens zerados                �
				//����������������������������������������������������������������
						If (mv_par18==2)  .And. (QtdComp(nQuant)==QtdComp(0))
							dbSelectArea( cAl2 )
							dbSkip()
							Loop
						EndIf
				
				//��������������������������������������������������������������Ŀ
				//� Verifica se devera ser impresso valores zerados              �
				//����������������������������������������������������������������
						If (mv_par21==2) .And. (QtdComp(nValor)==QtdComp(0))
							dbSelectArea( cAl2 )
							dbSkip()
							Loop
						EndIf
                
						If (mv_par22==1)
							nQuantR := (cAl2)->B2_QEMP2 + AvalQtdPre("SB2",1,.T.,cAl2) + (cAl2)->B2_RESERV2  + ConvUM( (cAl2)->B2_COD, (cAl2)->B2_QEMPSA, 0, 2)+(cAl2)->B2_QEMPPR2
						Else
							nQuantR := (cAl2)->B2_QEMP + AvalQtdPre("SB2",1,NIL,cAl2) + (cAl2)->B2_RESERVA + (cAl2)->B2_QEMPSA + (cAl2)->B2_QEMPPRJ
						EndIf

						nValorR := (QtdComp(nValor) / QtdComp(nQuant)) * QtdComp(nQuantR)

				//���������������������������������������������������������������Ŀ
				//� Monta Chave de pesquisa para aglutinar Armazem/Filial/Empresa �
				//�����������������������������������������������������������������
						If lAglutLoc .Or. lAglutFil
							If (aReturn[8] == 5)
								cSeek := (cAl2)->B2_LOCAL
							Else
								cSeek := ""
							EndIf
							Do Case
							Case (aReturn[8] == 1)
								If (mv_par17 == 1)
									cSeek += IIf(mv_par22==1,(cAl1)->B1_SEGUM,(cAl1)->B1_UM)
								EndIf
								cSeek += (cAl2)->B2_COD+IIf(lAglutFil,"",(cAl2)->B2_FILIAL)+IIf(lAglutLoc,"",(cAl2)->B2_LOCAL)
							Case (aReturn[8] == 2)
								cSeek += (cAl1)->B1_TIPO
								If (mv_par17 == 1)
									cSeek += IIf(mv_par22==1,(cAl1)->B1_SEGUM,(cAl1)->B1_UM)
								EndIf
								cSeek += (cAl2)->B2_COD+IIf(lAglutFil,"",(cAl2)->B2_FILIAL)+IIf(lAglutLoc,"",(cAl2)->B2_LOCAL)
							Case (aReturn[8] == 3)
								If (mv_par17 == 1)
									cSeek += IIf(mv_par22==1,(cAl1)->B1_SEGUM,(cAl1)->B1_UM)
								EndIf
								cSeek += (cAl1)->B1_DESC+(cAl2)->B2_COD+IIf(lAglutFil,"",(cAl2)->B2_FILIAL)+IIf(lAglutLoc,"",(cAl2)->B2_LOCAL)
							Case (aReturn[8] == 4)
								cSeek += (cAl1)->B1_GRUPO
								If (mv_par17 == 1)
									cSeek += IIf(mv_par22==1,(cAl1)->B1_SEGUM,(cAl1)->B1_UM)
								EndIf
								cSeek += (cAl2)->B2_COD+IIf(lAglutFil,"",(cAl2)->B2_FILIAL)+IIf(lAglutLoc,"",(cAl2)->B2_LOCAL)
							Case (aReturn[8] == 5)
								If (mv_par17 == 1)
									cSeek += IIf(mv_par22==1,(cAl1)->B1_SEGUM,(cAl1)->B1_UM)
								EndIf
								cSeek += (cAl2)->B2_COD+IIf(lAglutFil,"",(cAl2)->B2_FILIAL)
							OtherWise
								If (mv_par17 == 1)
									cSeek += IIf(mv_par22==1,(cAl1)->B1_SEGUM,(cAl1)->B1_UM)
								EndIf
								cSeek += (cAl2)->B2_COD+IIf(lAglutLoc,"",(cAl2)->B2_LOCAL)
							EndCase
						EndIf
				
						dbSelectArea( cFileTRB )
						If lAglutLoc .Or. lAglutFil
							lAchou := MsSeek(cSeek)
							RecLock(cFileTRB,!lAchou)
						Else
							RecLock(cFileTRB,.T.)
						EndIf

						FIELD->FILIAL := (cAl2)->B2_FILIAL
						FIELD->CODIGO := (cAl2)->B2_COD
						FIELD->LOCAL  := (cAl2)->B2_LOCAL
						FIELD->TIPO   := (cAl1)->B1_TIPO
						FIELD->GRUPO  := (cAl1)->B1_GRUPO
						FIELD->DESCRI := (cAl1)->B1_DESC
						If mv_par22 == 1
							FIELD->SEGUM  := (cAl1)->B1_SEGUM
						Else
							FIELD->UM     := (cAl1)->B1_UM
						EndIf
						FIELD->QUANTR += nQuantR
						FIELD->VALORR += Round(nValorR,nDec)
						FIELD->QUANT  += nQuant
						FIELD->VALOR  += Round(nValor,nDec)
						If lVEIC
							FIELD->CODITE := (cAl1)->B1_CODITE
						EndIf
						If mv_par23 == 1
							If lVersao
								FIELD->DESCARM := NNR->NNR_DESCRI
							Else
								FIELD->DESCARM := (cAl2)->B2_LOCALIZ
							EndIf
						EndIf
						cFileTRB->ULTCOMP := Stod((cAl2)->DTCOM) //Stod(VerDtCom((cAliasSB2)->B2_COD))
						cFileTRB->ULTPROD := Stod((cAl2)->DTPRD)//Stod(VerDtPrd((cAliasSB2)->B2_COD))
						cFileTRB->ULTVEND := Stod((cAl2)->DTVEN) //Stod(VerDtVen((cAliasSB2)->B2_COD))
					EndIf
					#IFNDEF TOP
					EndIf
				#ENDIF
				dbSelectArea( cAl2 )
			EndIf
	
			dbSkip()
		EndDo

		cFilAnt := cFilOk

//�������������������������������������������������������������������������������������Ŀ
//� Apaga os arquivos de trabalho, cancela os filtros e restabelece as ordens originais.|
//���������������������������������������������������������������������������������������
		#IFDEF TOP
			dbSelectArea(cAl2)
			dbCloseArea()
			ChkFIle("SB2",.F.)
		#ELSE
			dbSelectArea("SB1")
			RetIndex("SB1")
			Ferase(cIndSB1+OrdBagExt())
		#ENDIF

		dbSelectArea("SB1")
		dbClearFilter()

		Return( cFileTRB )

		/*/
		�����������������������������������������������������������������������������
		�����������������������������������������������������������������������������
		�������������������������������������������������������������������������Ŀ��
		���Fun��o    �R260IMPRIM� Autor � Ben-Hur M. Castilho   � Data � 20/11/96 ���
		�������������������������������������������������������������������������Ĵ��
		���Descri��o � Preparacao do Arquivo de Trabalho p/ Relatorio             ���
		�������������������������������������������������������������������������Ĵ��
		��� Uso      � MATR260                                                    ���
		��������������������������������������������������������������������������ٱ�
		�����������������������������������������������������������������������������
		�����������������������������������������������������������������������������
		/*/

	Static Function R260Imprime( lEnd,cFileTRB,cTitulo,wNRel,cTam,nTipo,nOrdem )

		#define DET_SIZE  14

		#define DET_CODE   1
		#define DET_TIPO   2
		#define DET_GRUP   3
		#define DET_DESC   4
		#define DET_UM     5
		#define DET_FL     6
		#define DET_ALMX   7
		#define DET_SALD   8
		#define DET_EMPN   9
		#define DET_DISP  10
		#define DET_VEST  11
		#define DET_VEMP  12
		#define DET_KEYV  13
		#define DET_DEAL  14

		#define ACM_SIZE   6

		#define ACM_CODE   1
		#define ACM_SALD   2
		#define ACM_EMPN   3
		#define ACM_DISP   4
		#define ACM_VEST   5
		#define ACM_VEMP   6

		Local	aPrnDET   := Nil
		Local	aTotORD   := Nil
		Local	aTotUM    := Nil
		Local	aTotUM1   := Nil
		Local	aTotAMZ   := Nil

		Local	cLPrnCd   := ""
		Local   cProd     := ""
		Local   cLocal	  := ""

		Local	lPrintCAB := .F.
		Local	lPrintDET := .F.
		Local	lPrintTOT := .F.
		Local	lPrintOUT := .F.
		Local	lPrintLIN := .F.

		Local	nTotValEst:=0
		Local	nTotValEmp:=0
		Local	nTotValSal:=0
		Local	nTotValRPR:=0
		Local	nTotValRes:=0

		Local cPicture	:= PesqPict("SB2", If( (mv_par15 == 1),"B2_QATU","B2_QFIM" ),14 )
		Local cPicVal	:= If(cPaisLoc== "CHI" ,'',PesqPict("SB2","B2_VATU"+If(mv_par22 == 1,"2","1") ,15))

//��������������������������������������������������������������Ŀ
//� Variaveis tipo Local para SIGAVEI, SIGAPEC e SIGAOFI         �
//����������������������������������������������������������������
		Local	lT		:= .F.
		Local	lT1		:= .F.
		Local	lT2		:= .F.
		Local	cArm0	:= alltrim(OemToAnsi(STR0009))
		Local	cArm1	:= ""
		Local	cArm2	:= ""
		Local	n2		:= Len(cArm0)
		Local	n1

		For	n1	:=	n2	To	1	Step	-1
		cArm2	:=	Substr(cArm0,n1,1)
		If cArm2 <> " "
			cArm1	:= cArm2 + cArm1
		Else
			Exit
		EndIf
	Next

	n1	:= 0
	If lVeic
		n1	:= 016
	EndIf

	Private	Li		:= 80
	M_Pag	:= 1

	cCab01 := OemToAnsi(STR0014)        //"CODIGO          TP GRUP DESCRICAO             UM FL ALM   SALDO       EMPENHO PARA     ESTOQUE      ___________V A L O R___________"
	cCab02 := OemToAnsi(STR0015)        //"                                                          EM ESTOQUE  REQ/PV/RESERVA   DISPONIVEL    EM ESTOQUE          EMPENHADO "
//  	                                   123456789012345 12 1234 123456789012345678901 12 12 12 999,999,999.99 999,999,999.99 9999,999,999.99 9999,999,999.99 9999,999,999.99
//      	                               0         1         2         3         4         5         6         7         8         9        10        11        12        13
//          	                           0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012

	If lVeic
		cCab01 := Substr(cCab01,1,aSB1Cod[1]) + Space(nCOL1) + Substr(cCab01,aSB1Cod[1]+1)
		cCab02 := Substr(cCab02,1,aSB1Cod[1]) + Space(nCOL1) + Substr(cCab02,aSB1Cod[1]+1)
	EndIf

	If mv_par23 == 1
		cCab01 += STR0034
		cCab02 += STR0035
	EndIf

	dbSelectArea( cFileTRB )
	dbGoTop()
	While !Eof()
	
		If	(LastKey() == 286) .OR. If(lEND==Nil,.F.,lEND) .OR. lAbortPrint
			Exit
		EndIf

		If (aPrnDET == nil)
		
			If lVEIC
				aPrnDET := Array( DET_SIZE + 1)
				aPrnDET[ DET_CODE ] := FIELD->CODITE
				aPrnDET[ DET_SIZE + 1 ] := FIELD->CODIGO
			Else
				aPrnDET := Array( DET_SIZE )
				aPrnDET[ DET_CODE ] := FIELD->CODIGO
			EndIf
			aPrnDET[ DET_TIPO ] := FIELD->TIPO
			aPrnDET[ DET_GRUP ] := FIELD->GRUPO
			aPrnDET[ DET_DESC ] := FIELD->DESCRI
			aPrnDET[ DET_UM   ] := If(mv_par22==1,FIELD->SEGUM,FIELD->UM)
			aPrnDET[ DET_FL   ] := ""
			aPrnDET[ DET_ALMX ] := ""
			aPrnDET[ DET_SALD ] := 0
			aPrnDET[ DET_EMPN ] := 0
			aPrnDET[ DET_DISP ] := 0
			aPrnDET[ DET_VEST ] := 0
			aPrnDET[ DET_VEMP ] := 0
			aPrnDET[ DET_DEAL ] := If(mv_par23==1,FIELD->DESCARM,"")
			aPrnDET[ DET_KEYV ] := ""
		EndIf
	
		If (mv_par17 == 1) .And. (aTotUM == Nil)
			aTotUM	:= { If(mv_par22==1,FIELD->SEGUM,FIELD->UM),0,0,0,0,0 }
		EndIf
		If (mv_par17 == 1) .And. (aTotUM1 == Nil)
			aTotUM1	:= { If(mv_par22==1,FIELD->SEGUM,FIELD->UM)+FIELD->LOCAL,0,0,0,0,0 }
		EndIf
	//SubTotal por Armazem
		If nOrdem == 5 .And. (aTotAMZ == Nil)
			aTotAMZ	:= { If(mv_par22==1,FIELD->SEGUM,FIELD->UM),0,0,0,0,0 }
		EndIf
	
		If (((nOrdem == 2) .Or. (nOrdem == 4)) .And. (aTotORD == Nil))
			aTotORD := { If( (nOrdem == 2),FIELD->TIPO,FIELD->GRUPO ),0,0,0,0,0 }
		EndIf
	
		Do Case
		Case (mv_par01 == 1)
			aPrnDET[ DET_FL   ] := FIELD->FILIAL
			aPrnDET[ DET_ALMX ] := FIELD->LOCAL
		Case ((mv_par01 == 2) .And. (aPrnDET[ DET_KEYV ] == ""))
			aPrnDET[ DET_FL   ] := FIELD->FILIAL
			aPrnDET[ DET_ALMX ] := If( (aReturn[ 8 ] == 5),FIELD->LOCAL,"**")
		Case ((mv_par01 == 3) .And. (aPrnDET[ DET_KEYV ] == ""))
			aPrnDET[ DET_FL   ] := "**"
			aPrnDET[ DET_ALMX ] := If( (aReturn[ 8 ] == 5),FIELD->LOCAL,"**")
		EndCase
	
		If	aPrnDET[ DET_KEYV ] == ""
			If lVeic
				Do Case
				Case (mv_par01 == 1)
					If (aReturn[ 8 ] == 5)
						If (mv_par17 == 1)
							aPrnDET[ DET_KEYV ] := FIELD->LOCAL+If(mv_par22==1,FIELD->SEGUM,FIELD->UM)+FIELD->CODITE+FIELD->FILIAL
						Else
							aPrnDET[ DET_KEYV ] := FIELD->LOCAL+FIELD->CODITE+FIELD->FILIAL
						EndIf
					Else
						If (mv_par17 == 1)
							aPrnDET[ DET_KEYV ] := If(mv_par22==1,FIELD->SEGUM,FIELD->UM)+FIELD->CODITE+FIELD->FILIAL+FIELD->LOCAL
						Else
							aPrnDET[ DET_KEYV ] := FIELD->CODITE+FIELD->FILIAL+FIELD->LOCAL
						EndIf
					EndIf
				Case (mv_par01 == 2)
					If (aReturn[ 8 ] == 5)
						If (mv_par17 == 1)
							aPrnDET[ DET_KEYV ] := FIELD->LOCAL+If(mv_par22==1,FIELD->SEGUM,FIELD->UM)+FIELD->CODITE+FIELD->FILIAL
						Else
							aPrnDET[ DET_KEYV ] := FIELD->LOCAL+FIELD->CODITE+FIELD->FILIAL
						EndIf
					Else
						If (mv_par17 == 1)
							aPrnDET[ DET_KEYV ] := If(mv_par22==1,FIELD->SEGUM,FIELD->UM)+FIELD->CODITE+FIELD->FILIAL
						Else
							aPrnDET[ DET_KEYV ] := FIELD->CODITE+FIELD->FILIAL
						EndIf
					EndIf
				Case (mv_par01 == 3)
					If (aReturn[ 8 ] == 5)
						If (mv_par17 == 1)
							aPrnDET[ DET_KEYV ] := FIELD->LOCAL+If(mv_par22==1,FIELD->SEGUM,FIELD->UM)+FIELD->CODITE
						Else
							aPrnDET[ DET_KEYV ] := FIELD->LOCAL+FIELD->CODITE
						EndIf
					Else
						If (mv_par17 == 1)
							aPrnDET[ DET_KEYV ] := If(mv_par22==1,FIELD->SEGUM,FIELD->UM)+FIELD->CODITE
						Else
							aPrnDET[ DET_KEYV ] := FIELD->CODITE
						EndIf
					EndIf
				EndCase
			Else
				Do Case
				Case (mv_par01 == 1)
					If (aReturn[ 8 ] == 5)
						If (mv_par17 == 1)
							aPrnDET[ DET_KEYV ] := FIELD->Local+If(mv_par22==1,FIELD->SEGUM,FIELD->UM)+FIELD->CODIGO+FIELD->FILIAL
						Else
							aPrnDET[ DET_KEYV ] := FIELD->Local+FIELD->CODIGO+FIELD->FILIAL
						EndIf
					Else
						If (mv_par17 == 1)
							aPrnDET[ DET_KEYV ] := If(mv_par22==1,FIELD->SEGUM,FIELD->UM)+FIELD->CODIGO+FIELD->FILIAL+FIELD->Local
						Else
							aPrnDET[ DET_KEYV ] := FIELD->CODIGO+FIELD->FILIAL+FIELD->Local
						EndIf
					EndIf
				Case (mv_par01 == 2)
					If (aReturn[ 8 ] == 5)
						If (mv_par17 == 1)
							aPrnDET[ DET_KEYV ] := FIELD->Local+If(mv_par22==1,FIELD->SEGUM,FIELD->UM)+FIELD->CODIGO+FIELD->FILIAL
						Else
							aPrnDET[ DET_KEYV ] := FIELD->Local+FIELD->CODIGO+FIELD->FILIAL
						EndIf
					Else
						If (mv_par17 == 1)
							aPrnDET[ DET_KEYV ] := If(mv_par22==1,FIELD->SEGUM,FIELD->UM)+FIELD->CODIGO+FIELD->FILIAL
						Else
							aPrnDET[ DET_KEYV ] := FIELD->CODIGO+FIELD->FILIAL
						EndIf
					EndIf
				Case (mv_par01 == 3)
					If (aReturn[ 8 ] == 5)
						If (mv_par17 == 1)
							aPrnDET[ DET_KEYV ] := FIELD->Local+If(mv_par22==1,FIELD->SEGUM,FIELD->UM)+FIELD->CODIGO
						Else
							aPrnDET[ DET_KEYV ] := FIELD->Local+FIELD->CODIGO
						EndIf
					Else
						If (mv_par17 == 1)
							aPrnDET[ DET_KEYV ] := If(mv_par22==1,FIELD->SEGUM,FIELD->UM)+FIELD->CODIGO
						Else
							aPrnDET[ DET_KEYV ] := FIELD->CODIGO
						EndIf
					EndIf
				EndCase
			EndIf
		EndIf
	
		cProd:= FIELD->CODIGO
		cLocal:= FIELD->LOCAL
		aPrnDET[ DET_SALD ] += FIELD->QUANT
		aPrnDET[ DET_EMPN ] += FIELD->QUANTR
		aPrnDET[ DET_DISP ] += (FIELD->QUANT-FIELD->QUANTR)
		aPrnDET[ DET_VEST ] += FIELD->VALOR
		aPrnDET[ DET_VEMP ] += FIELD->VALORR

		If ( (mv_par14 == 1)  .Or.;
				((mv_par14 == 2) .And.(QtdComp(aPrnDET[DET_SALD]) >= QtdComp(0))) .Or.;
				((mv_par14 == 3) .And.(QtdComp(aPrnDET[DET_SALD])  < QtdComp(0)))	)
		//Subtotal por Unidade de medida
			If (mv_par17 == 1)
			
				aTotUM[ ACM_SALD ] += FIELD->QUANT
				aTotUM[ ACM_EMPN ] += FIELD->QUANTR
				aTotUM[ ACM_DISP ] += (FIELD->QUANT-FIELD->QUANTR)
				aTotUM[ ACM_VEST ] += FIELD->VALOR
				aTotUM[ ACM_VEMP ] += FIELD->VALORR
			
				aTotUM1[ ACM_SALD ] += FIELD->QUANT
				aTotUM1[ ACM_EMPN ] += FIELD->QUANTR
				aTotUM1[ ACM_DISP ] += (FIELD->QUANT-FIELD->QUANTR)
				aTotUM1[ ACM_VEST ] += FIELD->VALOR
				aTotUM1[ ACM_VEMP ] += FIELD->VALORR
			EndIf
		//SubTotal por Armazem
			If nOrdem == 5
				aTotAMZ[ ACM_SALD ] += FIELD->QUANT
				aTotAMZ[ ACM_EMPN ] += FIELD->QUANTR
				aTotAMZ[ ACM_DISP ] += (FIELD->QUANT-FIELD->QUANTR)
				aTotAMZ[ ACM_VEST ] += FIELD->VALOR
				aTotAMZ[ ACM_VEMP ] += FIELD->VALORR
			EndIf
		
			If ((nOrdem == 2) .Or. (nOrdem == 4))
				aTotORD[ ACM_SALD ] += FIELD->QUANT
				aTotORD[ ACM_EMPN ] += FIELD->QUANTR
				aTotORD[ ACM_DISP ] += (FIELD->QUANT-FIELD->QUANTR)
				aTotORD[ ACM_VEST ] += FIELD->VALOR
				aTotORD[ ACM_VEMP ] += FIELD->VALORR
			EndIf
		EndIf
		dbSkip()
	
		If lVeic
			Do Case
			Case (mv_par01 == 1)
				If (aReturn[ 8 ] == 5)
					If (mv_par17 == 1)
						lPrintDET := !(aPrnDET[ DET_KEYV ] == FIELD->LOCAL+If(mv_par22==1,FIELD->SEGUM,FIELD->UM)+FIELD->CODITE+FIELD->FILIAL)
					Else
						lPrintDET := !(aPrnDET[ DET_KEYV ] == FIELD->LOCAL+FIELD->CODITE+FIELD->FILIAL)
					EndIf
				Else
					If (mv_par17 == 1)
						lPrintDET := !(aPrnDET[ DET_KEYV ] == If(mv_par22==1,FIELD->SEGUM,FIELD->UM)+FIELD->CODITE+FIELD->FILIAL+FIELD->LOCAL)
					Else
						lPrintDET := !(aPrnDET[ DET_KEYV ] == FIELD->CODITE+FIELD->FILIAL+FIELD->LOCAL)
					EndIf
				EndIf
			Case (mv_par01 == 2)
				If (aReturn[ 8 ] == 5)
					If (mv_par17 == 1)
						lPrintDET := !(aPrnDET[ DET_KEYV ] == FIELD->LOCAL+If(mv_par22==1,FIELD->SEGUM,FIELD->UM)+FIELD->CODITE+FIELD->FILIAL)
					Else
						lPrintDET := !(aPrnDET[ DET_KEYV ] == FIELD->LOCAL+FIELD->CODITE+FIELD->FILIAL)
					EndIf
				Else
					If (mv_par17 == 1)
						lPrintDET := !(aPrnDET[ DET_KEYV ] == If(mv_par22==1,FIELD->SEGUM,FIELD->UM)+FIELD->CODITE+FIELD->FILIAL)
					Else
						lPrintDET := !(aPrnDET[ DET_KEYV ] == FIELD->CODITE+FIELD->FILIAL)
					EndIf
				EndIf
			Case (mv_par01 == 3)
				If (aReturn[ 8 ] == 5)
					If (mv_par17 == 1)
						lPrintDET := !(aPrnDET[ DET_KEYV ] == FIELD->LOCAL+If(mv_par22==1,FIELD->SEGUM,FIELD->UM)+FIELD->CODITE)
					Else
						lPrintDET := !(aPrnDET[ DET_KEYV ] == FIELD->LOCAL+FIELD->CODITE)
					EndIf
				Else
					If (mv_par17 == 1)
						lPrintDET := !(aPrnDET[ DET_KEYV ] == If(mv_par22==1,FIELD->SEGUM,FIELD->UM)+FIELD->CODITE)
					Else
						lPrintDET := !(aPrnDET[ DET_KEYV ] == FIELD->CODITE)
					EndIf
				EndIf
			EndCase
		Else
			Do Case
			Case (mv_par01 == 1)
				If (aReturn[ 8 ] == 5)
					If (mv_par17 == 1)
						lPrintDET := !(aPrnDET[ DET_KEYV ] == FIELD->Local+If(mv_par22==1,FIELD->SEGUM,FIELD->UM)+FIELD->CODIGO+FIELD->FILIAL)
					Else
						lPrintDET := !(aPrnDET[ DET_KEYV ] == FIELD->Local+FIELD->CODIGO+FIELD->FILIAL)
					EndIf
				Else
					If (mv_par17 == 1)
						lPrintDET := !(aPrnDET[ DET_KEYV ] == If(mv_par22==1,FIELD->SEGUM,FIELD->UM)+FIELD->CODIGO+FIELD->FILIAL+FIELD->Local)
					Else
						lPrintDET := !(aPrnDET[ DET_KEYV ] == FIELD->CODIGO+FIELD->FILIAL+FIELD->Local)
					EndIf
				EndIf
			Case (mv_par01 == 2)
				If (aReturn[ 8 ] == 5)
					If (mv_par17 == 1)
						lPrintDET := !(aPrnDET[ DET_KEYV ] == FIELD->Local+If(mv_par22==1,FIELD->SEGUM,FIELD->UM)+FIELD->CODIGO+FIELD->FILIAL)
					Else
						lPrintDET := !(aPrnDET[ DET_KEYV ] == FIELD->Local+FIELD->CODIGO+FIELD->FILIAL)
					EndIf
				Else
					If (mv_par17 == 1)
						lPrintDET := !(aPrnDET[ DET_KEYV ] == If(mv_par22==1,FIELD->SEGUM,FIELD->UM)+FIELD->CODIGO+FIELD->FILIAL)
					Else
						lPrintDET := !(aPrnDET[ DET_KEYV ] == FIELD->CODIGO+FIELD->FILIAL)
					EndIf
				EndIf
			Case (mv_par01 == 3)
				If (aReturn[ 8 ] == 5)
					If (mv_par17 == 1)
						lPrintDET := !(aPrnDET[ DET_KEYV ] == FIELD->Local+If(mv_par22==1,FIELD->SEGUM,FIELD->UM)+FIELD->CODIGO)
					Else
						lPrintDET := !(aPrnDET[ DET_KEYV ] == FIELD->Local+FIELD->CODIGO)
					EndIf
				Else
					If (mv_par17 == 1)
						lPrintDET := !(aPrnDET[ DET_KEYV ] == If(mv_par22==1,FIELD->SEGUM,FIELD->UM)+FIELD->CODIGO)
					Else
						lPrintDET := !(aPrnDET[ DET_KEYV ] == FIELD->CODIGO)
					EndIf
				EndIf
			EndCase
		EndIf
	
		If ( (mv_par14 == 1)  .Or.;
				((mv_par14 == 2) .And.(QtdComp(aPrnDET[DET_SALD]) >= QtdComp(0))) .Or.;
				((mv_par14 == 3) .And.(QtdComp(aPrnDET[DET_SALD])  < QtdComp(0)))	)
	
		//��������������������������������������������������������������Ŀ
		//�	Validacao para Custo Unificado com Qtde. Zerada              |
		//����������������������������������������������������������������
			If lCusUnif .And. lPrintDET
				If (mv_par18==2) .And. (QtdComp(aPrnDET[DET_SALD])==QtdComp(0))
					aPrnDET := Nil
					Loop
				EndIf
			EndIf
		
		//��������������������������������������������������������������Ŀ
		//� Verifica se devera ser impresso valores zerados              �
		//����������������������������������������������������������������
			If (mv_par21==2) .And. (QtdComp(aPrnDET[DET_VEST])==QtdComp(0))
				aPrnDET := Nil
				Loop
			EndIf
	
			If lPrintDET
			
				If (Li > 56)
					Cabec( cTitulo,cCab01,cCab02,wNRel,cTam,nTipo )
				EndIf
			
				Do Case
				Case !(aPrnDET[ DET_CODE ] == cLPrnCd)
					cLPrnCd := aPrnDET[ DET_CODE ] ; lPrintCAB := .T.
				EndCase
			
				If lPrintCAB .Or. lPrintOUT
					If lVeic
						@ Li,000 PSay aPrnDET[ DET_CODE ] + " "+ aPrnDET[ DET_SIZE + 1 ]
					Else
						@ Li,000 PSay aPrnDET[ DET_CODE ]
					EndIf
	
					@ Li,016 + nCOL1 PSay aPrnDET[ DET_TIPO ]
					@ Li,019 + nCOL1 PSay aPrnDET[ DET_GRUP ]
					@ Li,024 + nCOL1 PSay aPrnDET[ DET_DESC ]
				
					lPrintCAB := .F. ; lPrintOUT := .F.
				EndIf
				Li++
				@ Li,046 + nCOL1 PSay aPrnDET[ DET_UM   ]
				@ Li,049 + nCOL1 PSay aPrnDET[ DET_FL   ]
				@ Li,052 + nCOL1 PSay aPrnDET[ DET_ALMX ]
	
				@ Li,054 + nCOL1 PSay aPrnDET[ DET_SALD ] Picture cPicture
				@ Li,070 + nCOL1 PSay aPrnDET[ DET_EMPN ] Picture cPicture
				@ Li,085 + nCOL1 PSay aPrnDET[ DET_DISP ] Picture cPicture
				@ Li,100 + nCOL1 PSay aPrnDET[ DET_VEST ] Picture cPicVal
				@ Li,117 + nCOL1 PSay aPrnDET[ DET_VEMP ] Picture cPicVal
				If mv_par23 == 1
					@ Li,136 + nCOL1 PSay aPrnDET[ DET_DEAL ]
				EndIf
			
				nTotValSal+=aPrnDET[ DET_SALD ]
				nTotValRpr+=aPrnDET[ DET_EMPN ]
				nTotValRes+=aPrnDET[ DET_DISP ]
				nTotValEst+=aPrnDET[ DET_VEST ]
				nTotValEmp+=aPrnDET[ DET_VEMP ]
			
				aPrnDET := Nil
			
				Li++
			EndIf
		Else
			aPrnDet := Nil
		EndIf

		Do Case
		Case (nOrdem <> 5) .And. ( (mv_par17 == 1) .And. (aTotUM[ ACM_CODE ] <> If(mv_par22==1,FIELD->SEGUM,FIELD->UM)))
			lPrintTOT := .T.
		Case (nOrdem == 5) .And. ( (mv_par17 == 1) .And. ((aTotUM1[ ACM_CODE ] <> If(mv_par22==1,FIELD->SEGUM,FIELD->UM)+FIELD->Local) .Or.;
				(aTotUM[ ACM_CODE ] <> If(mv_par22==1,FIELD->SEGUM,FIELD->UM)) ) ) .Or. nOrdem == 5
			lPrintTOT := .T.
		Case (( (nOrdem == 2) .Or. (nOrdem == 4) ) .And. !(aTotORD[ ACM_CODE ] == If( (nOrdem == 2),FIELD->TIPO,FIELD->GRUPO )))
			lPrintTOT := .T.
		EndCase

		If lPrintTOT
	
			lT		:= .F.	// IMPRIMIR E ZERAR aTotUM
			lT1		:= .F.	// IMPRIMIR E ZERAR aTotUM1
		
			If (mv_par17 == 1)
				If nORDEM <> 5 .AND. (aTotUM[ ACM_CODE ] <> If(mv_par22==1,FIELD->SEGUM,FIELD->UM))
					lT	:= .T. // IMPRIMIR E ZERAR aTotUM
				Else
					If nORDEM == 5
					// unidade diferente !
						If (aTotUM[ ACM_CODE ] <> If(mv_par22==1,FIELD->SEGUM,FIELD->UM))
							lT	:= .T. // IMPRIMIR E ZERAR aTotUM E aTotUM1.
							If lT2
								lT1	:= .T. // IMPRIMIR E ZERAR aTotUM1.
								lT2	:= .F. // SE TEM Q IMPRIMIR O aTotUM1.
							EndIf
						Else // unidade igual e local diferente !
							If (Substr(aTotUM1[ ACM_CODE ],LEN(aTotUM1[ ACM_CODE ])-1,2) <> FIELD->LOCAL)
								lT	:= .F. // NAO IMPRIMIR E ZERAR aTotUM.
								lT1	:= .T. // IMPRIMIR E ZERAR aTotUM1.
								If ! lT2
									lT2	:= .T.
								EndIf
							EndIf
						EndIf
					EndIf
				EndIf
			EndIf

			If lT .OR. lT1
				Li++
				If nORDEM <> 5
					@ Li,016 PSay OemToAnsi(STR0019)+aTotUM[ ACM_CODE ]   //"Total Unidade Medida : "
					@ Li,054 + nCOL1 PSay aTotUM[ ACM_SALD ] Picture cPicture
					@ Li,070 + nCOL1 PSay aTotUM[ ACM_EMPN ] Picture cPicture
					@ Li,085 + nCOL1 PSay aTotUM[ ACM_DISP ] Picture cPicture
					@ Li,100 + nCOL1 PSay aTotUM[ ACM_VEST ] Picture cPicVal
					@ Li,117 + nCOL1 PSay aTotUM[ ACM_VEMP ] Picture cPicVal
				
					aTotUM    := Nil
				Else
					If lT1
						@ Li,n1 PSay "Sub" + OemToAnsi(STR0019) ; //"SubTotal Unidade Medida : "
						+ SUBSTR(aTotUM1[ ACM_CODE ],1,LEN(aTotUM1[ ACM_CODE ])-2) ;
							+ " - " + cArm1 + " : " ;
							+ SUBSTR(aTotUM1[ ACM_CODE ],LEN(aTotUM1[ ACM_CODE ])-1,2)
						@ Li,054 + nCOL1 PSay aTotUM1[ ACM_SALD ] Picture cPicture
						@ Li,070 + nCOL1 PSay aTotUM1[ ACM_EMPN ] Picture cPicture
						@ Li,085 + nCOL1 PSay aTotUM1[ ACM_DISP ] Picture cPicture
						@ Li,100 + nCOL1 PSay aTotUM1[ ACM_VEST ] Picture cPicVal
						@ Li,117 + nCOL1 PSay aTotUM1[ ACM_VEMP ] Picture cPicVal

						aTotUM1	:= nil
						lT2		:= .T.
					EndIf
					If lT
						If lT1
							Li	+=	2
						EndIf
					
						@ Li,016 PSay OemToAnsi(STR0019)+aTotUM[ ACM_CODE ]   //"Total Unidade Medida : "
						@ Li,054 + nCOL1 PSay aTotUM[ ACM_SALD ] Picture cPicture
						@ Li,070 + nCOL1 PSay aTotUM[ ACM_EMPN ] Picture cPicture
						@ Li,085 + nCOL1 PSay aTotUM[ ACM_DISP ] Picture cPicture
						@ Li,100 + nCOL1 PSay aTotUM[ ACM_VEST ] Picture cPicVal
						@ Li,117 + nCOL1 PSay aTotUM[ ACM_VEMP ] Picture cPicVal
					
						aTotUM1	:= Nil
						aTotUM	:= Nil
						lT2		:= .F.
					EndIf
				EndIf
				Li++
			
				lPrintLIN := .T.
				lPrintTOT := .F. ; lPrintOUT := .T.
			EndIf

		//SubTotal por Armazem
			If nOrdem == 5 .And. cLocal != FIELD->LOCAL
				If nOrdem == 5
					@ Li,n1 PSay OemToAnsi(STR0033) ; //"SubTotal por Armazem: "
					+ SUBSTR(aTotAMZ[ ACM_CODE ],1,LEN(aTotAMZ[ ACM_CODE ])-2) + " - " + cArm1 + " : " ;
						+ cLocal
					@ Li,054 + nCOL1 PSay aTotAMZ[ ACM_SALD ] Picture cPicture
					@ Li,070 + nCOL1 PSay aTotAMZ[ ACM_EMPN ] Picture cPicture
					@ Li,085 + nCOL1 PSay aTotAMZ[ ACM_DISP ] Picture cPicture
					@ Li,100 + nCOL1 PSay aTotAMZ[ ACM_VEST ] Picture cPicVal
					@ Li,117 + nCOL1 PSay aTotAMZ[ ACM_VEMP ] Picture cPicVal
					Li++
			
					lPrintLIN := .T.
					lPrintTOT := .F.
					lPrintOUT := .T.
					lT2		  := .F.
					aTotAMZ   := Nil
				EndIf
			EndIf

			If (((nOrdem == 2) .Or. (nOrdem == 4)) .And. ;
					!(aTotORD[ ACM_CODE ] == If( (nOrdem == 2),FIELD->TIPO,FIELD->GRUPO )))
			
				Li++
			
				@ Li,016 PSay OemToAnsi(STR0016)+If( (nOrdem == 2),OemToAnsi(STR0017),OemToAnsi(STR0018))+" : "+aTotORD[ ACM_CODE ]   //"Total do "###"Tipo"###"Grupo"
				@ Li,054 + nCOL1 PSay aTotORD[ ACM_SALD ] Picture cPicture
				@ Li,070 + nCOL1 PSay aTotORD[ ACM_EMPN ] Picture cPicture
				@ Li,085 + nCOL1 PSay aTotORD[ ACM_DISP ] Picture cPicture
				@ Li,100 + nCOL1 PSay aTotORD[ ACM_VEST ] Picture cPicVal
				@ Li,117 + nCOL1 PSay aTotORD[ ACM_VEMP ] Picture cPicVal

				Li++
			
				aTotORD   := nil ; lPrintLIN := .T.
				lPrintTOT := .F. ; lPrintOUT := .T.
			EndIf
		
			If lPrintLIN
				Li++ ; lPrintLIN := .F.
			EndIf
		EndIf
	EndDo

	If nTotValSal + nTotValRPR + nTotValRes + nTotValEst + nTotValEmp # 0
		If Li > 56
			Cabec(cTitulo,cCab01,cCab02,wnRel,cTam,nTipo)
		EndIf
		Li += If(mv_par17#1,1,0)
		@ Li,016 PSay OemToAnsi(STR0020) // "Total Geral : "
		@ Li,054 + nCOL1 PSay nTotValSal Picture cPicture
		@ Li,070 + nCOL1 PSay nTotValRPR Picture cPicture
		@ Li,085 + nCOL1 PSay nTotValRes Picture cPicture
		@ Li,100 + nCOL1 PSay nTotValEst Picture cPicVal
		@ Li,117 + nCOL1 PSay nTotValEmp Picture cPicVal
	EndIf

	If (LastKey() == 286) .Or. If(lEnd==Nil,.F.,lEnd) .Or. lAbortPrint
		@ pRow()+1,00 PSay OemToAnsi(STR0021)     //"CANCELADO PELO OPERADOR."
	ElseIf !(RecCount()==0) //utilizado para nao Imprimir Pagina em Branco
		Roda( LastRec(), OemToAnsi(STR0022),cTam )    //"Registro(s) processado(s)"
	EndIf

	SET DEVICE TO SCREEN

	MS_FLUSH()

	If (aReturn[ 5 ] == 1)
		SET PRINTER TO
		OurSpool( wNRel )
	Endif

	dbSelectArea( cFileTRB )  ; DbCloseArea()
	FErase( cFileTRB+GetDBExtension() )
	FErase( cFileTRB+OrdBagExt() )

	dbSelectArea( "SB1" )

Return( Nil )
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MA260PergU�Autor  �Microsiga           � Data �  01/28/03   ���
�������������������������������������������������������������������������͹��
���Desc.     �Altera as Perguntas no SX1 para utilizacao do MV_CUSFIL     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function MA260PergU()

	Local aAreaAnt := GetArea()
	Local nTamSX1  := Len(SX1->X1_GRUPO)

	If lCusUnif //-- Ajusta as perguntas para Custo Unificado
		dbSelectArea('SX1')
		dbSetOrder(1)
		If dbSeek(PADR("MTR260",nTamSX1)+"01", .F.) .And. !(X1_PRESEL==2.Or.X1_PRESEL==3) //-- Aglutina por Filial
			RecLock('SX1', .F.)
			Replace X1_PRESEL With 2
			MsUnlock()
		EndIf
		If dbSeek(PADR("MTR260",nTamSX1)+"04", .F.) .And. !(X1_CNT01==cALL_LOC) //-- Armazem De **
			RecLock('SX1', .F.)
			Replace X1_CNT01 With cALL_LOC
			MsUnlock()
		EndIf
		If dbSeek(PADR("MTR260",nTamSX1)+"05", .F.) .And. !(X1_CNT01==cALL_LOC) //-- Armazem Ate **
			RecLock('SX1', .F.)
			Replace X1_CNT01 With cALL_LOC
			MsUnlock()
		EndIf
	EndIf

	RestArea(aAreaAnt)

Return Nil

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �AjustaSX1 �Autor  �Fernando J. Siquini � Data �  02/06/03   ���
�������������������������������������������������������������������������͹��
���Desc.     �Inclui a 21a pergunta do MTR260 no SX1 e inclui opcao de    ���
���          �custo FIFO no relatorio.                                    ���
�������������������������������������������������������������������������͹��
���Uso       � MATR260                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function AjustaSX1()

	Local nTamSX1 := Len(SX1->X1_GRUPO)
	Local cNome   := ""

	PutSx1('MTR260', '21' , 'Listar Prods C/ Valor Zerado ?', ;
		'Muestra Valores a Cero ?      ', ;
		'Show Zeroed Values ?          ', 'mv_chk', 'C', 1, 0, 2, 'C', '', '', '', '', 'mv_par21', ;
		'Sim' , ;
		'Si', ;
		'Yes', '', ;
		'Nao', ;
		'No', ;
		'No','','','','','','','','','', ;
		{'Determina se produtos que possuam o     ', ;
		'Custo apurado igual a ZERO devem ser    ', ;
		'impressos.                              '}, ;
		{'Defina si los productos con el coste   ', ;
		'calculado igual Cero tienen que ser    ', ;
		'impressos                              '}, ;
		{'Define if Products with Calculated Cost', ;
		'equal Zero have to be printed.         ', ;
		'                                       '})

// Inclui opcao para impressao do custo FIFO
	dbSelectArea("SX1")
	dbSetOrder(1)
	If dbSeek(PADR("MTR260",nTamSX1)+"15")
		Reclock("SX1",.F.)
		Replace X1_DEFSPA1 With "Actual"	       // Espanhol
		Replace X1_DEFENG1 With "Actual"	       // Ingles
		Replace X1_DEF04   With "Fechamento FIFO"  // Portugues
		Replace X1_DEFSPA4 With "Cierre FIFO"      // Espanhol
		Replace X1_DEFENG4 With "FIFO Closing"     // Ingles
		Replace X1_DEF05   With "Movimento FIFO"	 // Portugues
		Replace X1_DEFSPA5 With "Movimiento FIFO"  // Espanhol
		Replace X1_DEFENG5 With "FIFO Movement"    // Ingles
		MsUnlock()
	EndIf

// Ajusta o X1_VAR01 de todos os perguntes para MV_PARxx //
	dbSelectArea("SX1")
	dbSetOrder(1)
	dbSeek(PADR("MTR260",nTamSX1))
	Do While !Eof() .And. Upper(AllTrim(X1_GRUPO))=="MTR260"
		cNome:="MV_PAR"+X1_ORDEM
		If AllTrim(X1_VAR01)<>cNome
			Reclock("SX1",.F.)
			Replace X1_VAR01 With cNome
			MsUnlock()
		EndIf
		DbSkip()
	EndDo

Return Nil

/*
Verifico data da ultima venda
*/
Static Function VerDtVen(cVar)

	Local _cQry := ""
	Local _cRet := ""
	
	If Select("TRD") > 0
		TRD->(DbCloseArea())
	Endif

	_cQry := " "
	_cQry += " SELECT D2_COD,MAX(D2_EMISSAO) DTVEN FROM "+RetSqlName("SD2") "
	_cQry += " WHERE D2_COD = '" + cVar +"' "
	_cQry += " AND D_E_L_E_T_ = ' ' "
	_cQry += " GROUP BY D2_COD " 

	TcQuery _cQry New Alias "TRD"

	TRD->(dbGoTop())

	_cRet := TRD->DTVEN 
	
Return(_cRet)

/*
Verifico data da ultima produ��o
*/
Static Function VerDtPrd(cVar)

	Local _cQry := ""
	Local _cRet := ""
	
	If Select("TRD") > 0
		TRD->(DbCloseArea())
	Endif

	_cQry := " "
	_cQry += " SELECT D3_COD,MAX(D3_EMISSAO) DTPRD FROM "+RetSqlName("SD3") "
	_cQry += " WHERE D3_COD = '" + cVar +"' "
	_cQry += " AND D3_CF = 'PR0' "
	_cQry += " AND D_E_L_E_T_ = ' ' "
	_cQry += " GROUP BY D3_COD " 

	TcQuery _cQry New Alias "TRD"

	TRD->(dbGoTop())

	_cRet := TRD->DTPRD 

Return(_cRet)

/*
Verifico data da ultima compra
*/
Static Function VerDtCom(cVar)

	Local _cQry := ""
	Local _cRet := ""
	
	If Select("TRD") > 0
		TRD->(DbCloseArea())
	Endif

	_cQry := " "
	_cQry += " SELECT D1_COD,MAX(D1_DTDIGIT) DTCOM FROM "+RetSqlName("SD1") "
	_cQry += " WHERE D1_COD = '" + cVar +"' "
	_cQry += " AND D_E_L_E_T_ = ' ' "
	_cQry += " GROUP BY D1_COD " 

	TcQuery _cQry New Alias "TRD"

	TRD->(dbGoTop())

	_cRet := TRD->DTCOM 

Return(_cRet)