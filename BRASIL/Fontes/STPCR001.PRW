#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.CH"
#INCLUDE "FWPRINTSETUP.CH"
#INCLUDE "RPTDEF.CH"


Static oFont07	:= TFont():New("Arial",,05,,.F.,,,,.T.,.F.)
Static oFont07N	:= TFont():New("Arial",,05,,.T.,,,,.T.,.F.)
Static oFont08	:= TFont():New("Arial",,08,,.F.,,,,.T.,.F.)
Static oFont08N	:= TFont():New("Arial",,08,,.T.,,,,.T.,.F.)
Static oFont09	:= TFont():New("Arial",,08,,.F.,,,,.T.,.F.)
Static oFont09N	:= TFont():New("Arial",,08,,.T.,,,,.T.,.F.)
Static oFont10	:= TFont():New("Arial",,10,,.F.,,,,.T.,.F.)
Static oFont10N	:= TFont():New("Arial",,10,,.T.,,,,.T.,.F.)
Static oFont11	:= TFont():New("Arial",,11,,.F.,,,,.T.,.F.)
Static oFont11N	:= TFont():New("Arial",,11,,.T.,,,,.T.,.F.)
Static oFont12	:= TFont():New("Arial",,12,,.F.,,,,.T.,.F.)
Static oFont12N	:= TFont():New("Arial",,12,,.T.,,,,.T.,.F.)
Static oFont16 	:= TFont():New("Arial",,16,,.F.,,,,.T.,.F.)
Static oFont16N	:= TFont():New("Arial",,16,,.T.,,,,.T.,.F.)
Static oFont18 	:= TFont():New("Arial",,18,,.F.,,,,.T.,.F.)
Static oFont18N	:= TFont():New("Arial",,18,,.T.,,,,.T.,.F.)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STPCR001  ºAutor  ³Everaldo Gallo      º Data ³  15/03/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Impressao da Ordem de producao.                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP - PCP - STECK                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function STPCR001() //U_STPCR001()

	Private cAlias1   := GetNextAlias()
	Private cAlias2   := GetNextAlias()
	Private cAlias3   := GetNextAlias()
	Private cAlias4   := GetNextAlias()
	Private aDados1   := {}
	Private cPerg     := "STPCR001"
	Private cTime     := Time()
	Private cHora     := SUBSTR(cTime, 1, 2)
	Private cMinutos  := SUBSTR(cTime, 4, 2)
	Private cSegundos := SUBSTR(cTime, 7, 2)
	Private cAliasLif := cPerg+cHora+cMinutos+cSegundos
	Private wnrel     := cAliasLif

	public titulo  := "ORDEM DE PRODUCAO"
	public cString := "SC2"
	//public wnrel   :="PCRL001"
	public cDesc   := "Este programa ira imprimir a Rela‡„o das Ordens de Produ‡„o"
	//public aOrd    :={"Por Numero","Por Produto","Por Centro de Custo","Por Prazo de Entrega"}
	public tamanho := "P"
	public aReturn  := {"Zebrado",1,"Administracao", 1, 2, 1, "",1 }	//"Zebrado"###"Administracao"
	//public cPerg    :="MTR820"
	public nLastKey := 0

	public cCabec1 := SM0->M0_NOME+"        O R D E M   D E   P R O D U C A O       NRO :"
	public cCabec5 := "CODIGO     DESCRICAO COMPONENTES                            QUANTIDADE|UM|AL|SEQ"

	public  _cPedido  := SPACE(6)
	public  _cCliente := SPACE(6)
	public  _cLoja    := SPACE(2)
	public  _mOpc     := space(7)
	public  _mCodOpc  := space(15)
	public  _mUlcod   := space(15)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica as perguntas selecionadas                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	//-------cGrupo  ,cOrdem,cPergunt                 ,cPergSpa                   ,cPergEng                     ,cVar        ,cTipo ,nTamanho,nDecimal,nPreSel,cGSC,cValid,cF3   ,cGrpSXG,cPyme,cVar01        ,cDef01            ,cDefSpa1,cDefEng1,cCnt01               ,cDef02             ,cDefSpa2	,cDefEng2,cDef03         ,cDefSpa3,cDefEng3,cDef04                ,cDefSpa4,cDefEng4,cDef05,cDefSpa5,cDefEng5,aHelpPor,aHelpEng,aHelpSpa,cHelp
	PutSx1(cPerg   ,"01"  ,"Da O.P. :?"             ,"Da O.P. :?"               ,"Da O.P. :?"                 ,"mv_ch1"    ,"C"   ,13      , 0      , 0     ,"G" ,""    ,"SC2" ,""     ,"S"  ,"mv_par01"    ,""                ,""      ,""      ,Space(13)            ,""                 ,""        ,""      ,""             ,""      ,""      ,""                    ,""      ,""      ,""    ,""      ,"")
	PutSx1(cPerg   ,"02"  ,"Até O.P. :?"            ,"Até O.P. :"               ,"Até O.P. :"                 ,"mv_ch2"    ,"C"   ,13      , 0      , 0     ,"G" ,""    ,"SC2" ,""     ,"S"  ,"mv_par02"    ,""                ,""      ,""      ,Replicate("Z",13)    ,""                 ,""        ,""      ,""             ,""      ,""      ,""                    ,""      ,""      ,""    ,""      ,"")
	PutSx1(cPerg   ,"03"  ,"Emissão De: ?"          ,"Emissão De: ?"            ,"Emissão De: ?"              ,"mv_ch3"    ,"D"   ,08      ,0       ,0      ,"G" ,""    ,''    ,""     ,""   ,"mv_par03"    ,""                ,""      ,""      ,Dtoc(dDatabase-30)   ,""                 ,""        ,""      ,""             ,""      ,""      ,""                    ,""      ,""      ,""    ,""      ,"")
	PutSx1(cPerg   ,"04"  ,"Emissão Até: ?"         ,"Emissão Até: ?"           ,"Emissão Até: ?"             ,"mv_ch4"    ,"D"   ,08      ,0       ,0      ,"G" ,""    ,''    ,""     ,""   ,"mv_par04"    ,""                ,""      ,""      ,Dtoc(dDatabase)      ,""                 ,""        ,""      ,""             ,""      ,""      ,""                    ,""      ,""      ,""    ,""      ,"")

	//pergunte("MTR820",.F.)
	Pergunte(cPerg,.F.)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis utilizadas para parametros                         ³
	//³ mv_par01            // Da OP                                 ³
	//³ mv_par02            // Ate a OP                              ³
	//³ mv_par03            // Da data                               ³
	//³ mv_par04            // Ate a data                            ³
	//³ mv_par05            // Imprime roteiro de operacoes          ³
	//³ mv_par06            // Imprime codigo de barras              ³
	//³ mv_par07            // Imprime Nome Cientifico               ³
	//³ mv_par08            // Imprime Op Encerrada                  ³
	//³ mv_par09            // Impr. por Ordem de                    ³
	//³ mv_par10            // Impr. OP's Firmes, Previstas ou Ambas ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !ChkFile("SH8",.F.)
		Help(" ",1,"SH8EmUso")
		Return
	Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Envia controle para a funcao SETPRINT                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc,"","",.F.,,,Tamanho)

	If nLastKey == 27
		dbSelectArea("SC2")
		Return
	Endif

	SetDefault(aReturn,cString)

	If nLastKey = 27
		dbSelectArea("SC2")
		Return
	Endif

	RptStatus({|lEnd| R820Imp(@lEnd,wnRel,titulo,tamanho)},titulo)

Return NIL

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ R820Imp  ³ Autor ³ Waldemiro L. Lustosa  ³ Data ³ 13.11.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Chamada do Relat¢rio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR820			                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function R820Imp(lEnd,wnRel,titulo,tamanho)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Define Variaveis                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	public CbCont,cabec1,cabec2
	public limite := 132
	public nQuant := 1
	public nomeprog   := "PCRL001"
	public nTipo      := 18
	public cProduto   := SPACE(LEN(SC2->C2_PRODUTO))
	public _cProdpai  := SPACE(LEN(SC2->C2_PRODUTO))
	public cQtd
	public cIndSC2 := CriaTrab(NIL,.F.), nIndSC2
	public aArray   :={}
	public li := 80
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cbtxt    := SPACE(10)
	cbcont   := 0
	m_pag    := 1

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta os Cabecalhos                                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cabec1 := ""
	cabec2 := ""

	dbSelectArea("SC2")
	DBSETORDER(1)
	SET SOFTSEEK ON
	DBSEEK(XFILIAL("SC2") + MV_PAR01)
	SET SOFTSEEK OFF

	SetRegua(VAL(SUBSTR(MV_PAR02,1,6)) - VAL(SUBSTR(MV_PAR01,1,6)))

	While !Eof() .AND. C2_FILIAL+C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD <= xFilial()+mv_par02

		_mOpc:=substr(sc2->c2_opc,1,7)
		_mCodOpc := space(15)
		_mPadEst := {}
		_mQtdEst := {}

		dbSelectArea("SC2")

		IF lEnd
			@ Prow()+1,001 PSay "CANCELADO PELO OPERADOR"
			Exit
		EndIF

		IncRegua()

		If C2_FILIAL+C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD < xFilial()+mv_par01 .or. C2_FILIAL+C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD > xFilial()+mv_par02
			dbSkip()
			Loop
		EndIf

		If  C2_EMISSAO < mv_par03 .Or. C2_EMISSAO > mv_par04
			dbSkip()
			Loop
		Endif


		/*
		If !(Empty(C2_DATRF)) .And. mv_par08 == 2
		dbSkip()
		Loop
		Endif
		*/
		_nImpr := C2_XNIMPR+1

		Reclock("SC2",.f.)
		C2_XNIMPR := _nImpr
		Msunlock()

		_cProduto  := SC2->C2_PRODUTO
		_cPedido  := SC2->C2_PEDIDO

		dbSelectArea("SB1")
		dbSeek(xFilial("SB1")+_cProduto)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Adiciona o primeiro elemento da estrutura , ou seja , o Pai  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		// imprime controle de preparacao e Formula


		_NPAG:=1


		IMPFORMULA()

		//_NPAG++

		//IMPREQUIS("01")

		//_NPAG++
		//IMPREQUIS("03")

		_NPAG++

		IMP_PROCS()

		If !(cEmpAnt=="03")
			ImpDefe()
		EndIf

		_NPAG++

		// Valdemir Rabelo - Ticket: 20200715004231
		if cEmpAnt=='03'
			if MsgYesNo("Deseja emitir Continuação Ordem Produção?","Atenção!")
			   ImpCntOP()
			endif 
		Endif 

		/*/
		IMPRQMAT("01","ESTOQUE")
		IMPRQMAT("03","EXPEDICAO")
		IMPRQMAT("90","CONSUMO")
		/*/
		dbSelectArea("SC2")
		dbSkip()

	EndDO

	dbSelectArea("SH8")
	dbCloseArea()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Retira o SH8 da variavel cFopened ref. a abertura no MNU     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ClosFile("SH8")

	dbSelectArea("SC2")
	If aReturn[8] == 4
		RetIndex("SC2")
		Ferase(cIndSC2+OrdBagExt())
	EndIf
	Set Filter To
	dbSetOrder(1)

	If aReturn[5] = 1
		Set Printer TO
		dbCommitall()
		ourspool(wnrel)
	Endif

	MS_FLUSH()

Return NIL


/*/
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³ Fun‡…o   ³IMP_FORMUL³ Autor ³ EVERALDO GALLO        ³ Data ³ 28/06/03 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³ Descri‡…o³                                                            ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³ Sintaxe  ³                                                            ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Parametros³                                                            ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³ Uso      ³ Ordem de Producao - PCP - STECK                             ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/


STATIC FUNCTION IMPFORMULA
	Local _nI     := 0
	Local _nX     := 0
	Local _nY     := 0
	Local _nZ     := 0
	Local _cDescr := ''
	Local _cUm    := ''
	Local _cTipo  := ''
	Local _lRet   := .T.

	LI:=77

	STQUERY4 ()

	For _nI := 1 to Len(aDados1)

		If LI > 60

			LI:=1
			@ LI,65 PSAY alltrim(str(_nImpr))+"a impressao"

			LI+=2
			@ LI,0 PSAY "STECK  -  ORDEM DE PRODUÇÃO                   DATA: "+dtoc(ddatabase)+"  "+substr(time(),1,5)+"  PAG.: "+ strzero(_NPAG,2)
			LI+=2
			@ LI,0 PSAY "      ********************* FICHA DE ACOMPANHAMENTO *********************"
			LI+=2
			@ LI,0 PSAY "Ordem de Produção: "+SC2->C2_NUM+"|"+SC2->C2_ITEM+"|"+SC2->C2_SEQUEN+" - Qtde: "+ALLTRIM(TRANSFORM(SC2->C2_QUANT,"@e 999,999.99"))
			LI++
			@ LI,0 PSAY "Data Inicio .: "+DTOC(SC2->C2_DATPRI)+" - Data Entrega: "+DTOC(SC2->C2_DATPRF)
			LI++
			@ LI,0 PSAY "Produto .....: "+SC2->C2_PRODUTO + SUBSTR(SB1->B1_DESC,1,50)
			LI++
			@ LI,0 PSAY "Desenho......:" + SB1->B1_XDESENH
			LI++
			@ LI,0 PSAY "Observacoes..: "+SC2->C2_OBS
			LI++
			@ LI,0 PSAY "Obs.Rota ....: "
			LI+=1

			//@ LI,0     PSAY "                             SISTEMA DA QUALIDADE                              "
			LI+=1          //          1         2         3         4         5         6         7         8
			//012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
			@ LI+=1,0 PSAY " ******************************  COMPONENTES  *********************************"
			@ LI+=1,0 PSAY " Produto    Descrição do Produto                 UM  TP  Qtd Requis  Qtd Reserv"
			@ LI+=1,0 PSAY " =========  ==================================== ==  ==  ==========  =========="
		Endif

		If aDados1[_nI][1] = "Direto" .And. Empty(aDados1[_nI][13])

			For _nY := 1 to Len (aDados1)
				If aDados1[_nY][1] = "Direto"
					aDados1[_nY][13] := 'X'
				Endif
			Next _nY

			@ LI+=1,0 PSAY " ******************************************************************************"
			@ LI+=1,0 PSAY " Direto -> Solicitação Automática via autorização do PCP"
			@ LI+=1,0 PSAY " =========  ==================================== ==  ==  ==========  =========="


		ElseIf aDados1[_nI][1] = "Indireto" .And. Empty(aDados1[_nI][13])

			For _nZ := 1 to Len (aDados1)
				If aDados1[_nZ][1] = "Indireto"
					aDados1[_nZ][13] := 'X'
				Endif
			Next _nZ
			@ LI+=1,0 PSAY " ******************************************************************************"
			@ LI+=1,0 PSAY " Indireto -> Solicitação ao Armazém com Transferência do 01 para 90"
			@ LI+=1,0 PSAY " =========  ==================================== ==  ==  ==========  =========="


		ElseIf aDados1[_nI][1] = "Consumo" .And. Empty(aDados1[_nI][13])

			For _nX := 1 to Len (aDados1)
				If aDados1[_nX][1] = "Consumo"
					aDados1[_nX][13] := 'X'
				Endif
			Next _nX
			@ LI+=1,0 PSAY " ******************************************************************************"
			@ LI+=1,0 PSAY " Itens de Consumo -> Solicitação ao Armazém com Baixa pelo Centro de Custo"
			@ LI+=1,0 PSAY " =========  ==================================== ==  ==  ==========  =========="

		Endif

		If aDados1[_nI][1] = "Consumo" .And. aDados1[_nI][12] = 'S'
			Dbselectarea("SG1")
			SG1->(DbSetOrder(1))//G1_FILIAL+G1_COMP+G1_COD
			SG1->(DbGoTop())
			If DbSeek(xFilial('SG1')+aDados1[_nI][3])
				_lRet := .T.
				@ LI+=1,1  PSAY Alltrim(SG1->G1_COMP)
				@ LI,57    PSAY (SG1->G1_QUANT*SC2->C2_QUANT)  PICTURE "@E 999999.999"
				Dbselectarea("SB1")
				SB1->(DbSetOrder(1))//B1_FILIAL+B1_COD
				SB1->(DbGoTop())
				If DbSeek(xFilial('SB1')+aDados1[_nI][3])
					_cDescr := Alltrim(SB1->B1_DESC)
					_cUm    := SB1->B1_UM
					_cTipo  := SB1->B1_TIPO
					@ LI,12    PSAY Alltrim(SUBSTR(_cDescr,1,35))
					@ LI,49    PSAY _cUm
					@ LI,53    PSAY _cTipo

				Endif
			Else
				@ LI+=1,1  PSAY "Produto "+Alltrim(aDados1[_nI][3])+" está como Fantasma, porém não possui componente na estrutra"
				_lRet := .F.
			Endif

		Else
			@ LI+=1,1  PSAY Alltrim(aDados1[_nI][3])
			@ LI,12    PSAY Alltrim(SUBSTR(aDados1[_nI][4],1,35))
			@ LI,49    PSAY aDados1[_nI][7]
			@ LI,53    PSAY aDados1[_nI][5]
			@ LI,57    PSAY aDados1[_nI][8]  PICTURE "@E 999999.999"
		Endif

		If aDados1[_nI][1] = "Direto"
			@ LI,69    PSAY aDados1[_nI][9]  PICTURE "@E 999999.999"
		ElseIf !(_lRet)

		Else
			@ LI,69    PSAY "__________"
		Endif

	Next _nI

	aDados1 := {}
	// Thiago Godinho - Alteração conforme chamado 004050
	LI+=2

	@ LI+=1,0 PSAY " ------------------------------------------------------ "
	@ LI+=1,0 PSAY "!  TURNO   !  DATA  !   QUANT  ! RI RESP  ! ASSINATURA !"
	@ LI+=1,0 PSAY "!----------!--------!----------!----------!------------!"
	@ LI+=1,0 PSAY "!          !        !          !          !   		  	       !"
	@ LI+=1,0 PSAY "!----------!--------!----------!----------!------------!"
	@ LI+=1,0 PSAY "!          !        !          !          !            !"
	@ LI+=1,0 PSAY "!----------!--------!----------!----------!------------!"
	@ LI+=1,0 PSAY "!          !        !          !          !			  	          !"
	@ LI+=1,0 PSAY "!----------!--------!----------!----------!------------!"
	@ LI+=1,0 PSAY "!          !        !          !          !            !"
	@ LI+=1,0 PSAY "!----------!--------!----------!----------!------------!"
	@ LI+=1,0 PSAY "!          !        !          !          !            !"
	@ LI+=1,0 PSAY "!----------!--------!----------!----------!------------!"
	@ LI+=1,0 PSAY "!          !        !          !          !            !"
	@ LI+=1,0 PSAY "!----------!--------!----------!----------!------------!"
	@ LI+=1,0 PSAY "!          !        !          !          !            !"
	@ LI+=1,0 PSAY "!----------!--------!----------!----------!------------!"
	@ LI+=1,0 PSAY "!          !        !          !          !            !"
	@ LI+=1,0 PSAY "!----------!--------!----------!----------!------------!"
	@ LI+=1,0 PSAY "!          !        !          !          !            !"
	@ LI+=1,0 PSAY "!----------!--------!----------!----------!------------!"
	@ LI+=1,0 PSAY "!          !        !          !          !            !"
	@ LI+=1,0 PSAY "!----------!--------!----------!----------!------------!"



	@ LI+=1,0 PSAY " -----------------------------------!"
	@ LI+=1,0 PSAY "!META HORA:                         !"
	@ LI+=1,0 PSAY "!                                   !"
	@ LI+=1,0 PSAY "!                                   !"
	@ LI+=1,0 PSAY "!CICLO:                             !"
	@ LI+=1,0 PSAY "!                                   !"
	@ LI+=1,0 PSAY "!                                   !"
	@ LI+=1,0 PSAY "!CAVIDADE:                          !"
	@ LI+=1,0 PSAY "!                                   !"
	@ LI+=1,0 PSAY "!                                   !"
	@ LI+=1,0 PSAY "!ASS LÍDER:_________________________!"
	@ LI+=1,0 PSAY "!                                   !"
	@ LI+=1,0 PSAY "!                                   !"
	@ LI+=1,0 PSAY " -----------------------------------!"


RETURN

/*/
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³ Fun‡…o   ³IMP_PROCS ³ Autor ³ EVERALDO GALLO        ³ Data ³ 28/06/03 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³ Descri‡…o³                                                            ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³ Sintaxe  ³                                                            ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Parametros³                                                            ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³ Uso      ³ Ordem de Producao - PCP - STECK                            ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/


STATIC FUNCTION IMP_PROCS

	DBSELECTAREA("SG2")
	DbSetOrder(1)
	DBSEEK(XFILIAL("SG2")+SC2->C2_PRODUTO + SC2->C2_ROTEIRO )

	DO WHILE !EOF()  .AND.  SG2->G2_PRODUTO = SC2->C2_PRODUTO .And. SG2->G2_CODIGO == SC2->C2_ROTEIRO
		LI:=1
		impRota()
		_NPAG++
		DBSELECTAREA("SG2")
		DBSKIP()
	ENDDO
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STPCR001  ºAutor  ³Microsiga           º Data ³  03/15/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static function impRota
	//Local cCodBar := SC2->C2_NUM+"#"+SC2->C2_ITEM+"#"+SC2->C2_SEQUEN+"#"+SG2->G2_OPERAC
	Local cCodBar := AllTrim(SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+"|"+SG2->G2_OPERAC+"|"+SG2->G2_RECURSO)
	Local oPr     := ReturnPrtObj()
	Local nTmpTot := (SC2->C2_QUANT / SG2->G2_LOTEPAD) 		// Valdemir Rabelo 19/08/2020 Chamado:  20200624003316
	LOCAL cTempo  := Substr(Alltrim(Str(nTmpTot)),1,At(".",Alltrim(Str(nTmpTot)))+2)

	if At(".",Alltrim(Str(nTmpTot))) > 0
		cTempo := Substr(Alltrim(Str(nTmpTot)),1,At(".",Alltrim(Str(nTmpTot)))+2)
		cTempo := Left(cTempo, At(".",cTempo) )+cValToChar(Val(Right(cTempo, 2)) * 0.60)
		cTempo := PadL(StrTran(cTempo, ".",":")+":00",12)
	else
		cTempo  := PadL(Alltrim(Str(nTmpTot))+":00:00",12)
	endif

	LI:=1
	@ LI,65 PSAY alltrim(str(_nImpr))+"a impressao"


	li:=2
	@ LI,0 PSAY "STECK  -  ORDEM DE PRODUÇÃO                   DATA: "+dtoc(ddatabase)+"  "+substr(time(),1,5)+"  PAG.: "+ strzero(_NPAG,2)
	LI+=2
	@ LI,0 PSAY "Ordem de Produção: "+SC2->C2_NUM+"|"+SC2->C2_ITEM+"|"+SC2->C2_SEQUEN+" - Data Entrega: "+DTOC(SC2->C2_DATPRF)+" - Qtde: "+ALLTRIM(TRANSFORM(SC2->C2_QUANT,"@e 999,999.99"))
	LI++
	@ LI,0 PSAY "Produto .....: "+SC2->C2_PRODUTO + substr(Posicione("SB1",1,xFilial("SB1")+SC2->C2_PRODUTO,"B1_DESC"),1,50)
	LI++
	@ LI,0  PSAY "Cod.Vendas ..: "
	@ LI,36 PSAY "Data Inicio: "+DTOC(SC2->C2_DATPRI)
	LI++
	@ LI,0 PSAY "Observacoes..: "+SC2->C2_OBS
	//           1         2         3         4         5         6         7
	LI++        //  01234567890123456789012345678901234567890123456789012345678901234567890123456789
	//@ LI+=2,0 PSAY "                                SISTEMA DA QUALIDADE"
	@ LI+=1,0 PSAY "-------------------------------------------------------------------------------"
	@ LI+=1,0 PSAY "Oper. Centro Grupo Num.                                   ------- Tempo -------"
	@ LI+=1,0 PSAY "      Custo  Maq.  Maq.           Descricao               Preparacao  Producao "
	@ LI+=1,0 PSAY "----- ------ ----- ---- --------------------------------- ---------- ----------"

	dbSelectArea("SH1")
	dbSetorder(1)
	dbSeek(xFilial("SH1")+SG2->G2_RECURSO)
	dbSelectArea("SG2")

	@ LI+=1,0 	PSAY SG2->G2_OPERAC
	@ LI,6    	PSAY substr(SH1->H1_CCUSTO,1,6)
	@ LI,13    	PSAY SH1->H1_LINHAPR
	@ LI,19    	PSAY SG2->G2_RECURSO
	@ LI,26    	PSAY SG2->G2_DESCRI
	@ LI,58    	PSAY TRANSFORM(SG2->G2_SETUP,"@e 99999.9999")
	@ LI,70    	PSAY TRANSFORM(SG2->G2_TEMPAD,"@e 99999.9999")

	@ LI+=1,45 	PSAY "Pecas/Hora"
	@ LI,70    	PSAY TRANSFORM(SG2->G2_LOTEPAD,"@e 999,999.99")
	@ LI+=1,45 	PSAY "Tempo Prod.Total"
	@ LI,68    	PSAY cTempo							// Valdemir Rabelo 19/08/2020 Chamado:  20200624003316

	// Adicionando código de barra - Valdemir Rabelo 19/08/2020
	MSBAR4("CODE128" , /*LI+=2*/ 4 , /*55*/ 05 ,cCodBar,oPr,NIL,NIL,NIL,7,1,.T.,NIL,NIL)

	if cEmpAnt != "01"    // Valdemir Rabelo 11/04/2022 - Chamado: 20220321006211
		@ LI+=2,0 PSAY " Plano Inspecao    : " + SG2->G2_XPLINS
		@ LI+=1,0 PSAY " Ficha Pr. Maquina : " + SG2->G2_XPRMAQ
		@ LI+=1,0 PSAY " Inst.Trabalho ... : " + SG2->G2_XINSTR
		@ LI+=1,0 PSAY " Ferram./Cavidades : "
	Endif 
	@ LI+=1,0 PSAY " Desenho ......... : " + SB1->B1_XDESENH
	//          1         2         3         4         5         6         7         8
	//012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
	@ LI+=2,0 PSAY " ------------------------- No. Lote da Materia Prima------------------------- "
	@ LI+=1,0 PSAY "!                   !                   !                   !                !"
	@ LI+=1,0 PSAY "!-------------------!-------------------!-------------------!----------------!"
	@ LI+=1,0 PSAY "!                   !                   !                   !                !"
	@ LI+=1,0 PSAY " ---------------------------------------------------------------------------- "
	@ LI+=1,0 PSAY "                                                                              "
	@ LI+=1,0 PSAY " --------------------------------  H o r a s  ------------------------------- "
	@ LI+=1,0 PSAY "! Operador !  Data  ! H.Inicio !   H.Fim  ! Qt.Prod. ! Qt.Refugo !  Motivo   !"
	@ LI+=1,0 PSAY "!----------!--------!----------!----------!----------!-----------!-----------!"
	@ LI+=1,0 PSAY "!          !        !          !          !          !           !           !"
	@ LI+=1,0 PSAY "!----------!--------!----------!----------!----------!-----------!-----------!"
	@ LI+=1,0 PSAY "!          !        !          !          !          !           !           !"
	@ LI+=1,0 PSAY "!----------!--------!----------!----------!----------!-----------!-----------!"
	@ LI+=1,0 PSAY "!          !        !          !          !          !           !           !"
	@ LI+=1,0 PSAY "!----------!--------!----------!----------!----------!-----------!-----------!"
	@ LI+=1,0 PSAY "!          !        !          !          !          !           !           !"
	@ LI+=1,0 PSAY "!----------!--------!----------!----------!----------!-----------!-----------!"
	@ LI+=1,0 PSAY "!          !        !          !          !          !           !           !"
	@ LI+=1,0 PSAY "!----------!--------!----------!----------!----------!-----------!-----------!"
	@ LI+=1,0 PSAY "!          !        !          !          !          !           !           !"
	@ LI+=1,0 PSAY "!----------!--------!----------!----------!----------!-----------!-----------!"
	@ LI+=1,0 PSAY "!          !        !          !          !          !           !           !"
	@ LI+=1,0 PSAY "!----------!--------!----------!----------!----------!-----------!-----------!"
	@ LI+=1,0 PSAY "!          !        !          !          !          !           !           !"
	@ LI+=1,0 PSAY "!----------!--------!----------!----------!----------!-----------!-----------!"
	@ LI+=1,0 PSAY "!          !        !          !          !          !           !           !"
	@ LI+=1,0 PSAY "!----------!--------!----------!----------!----------!-----------!-----------!"
	@ LI+=1,0 PSAY "!          !        !          !          !          !           !           !"
	@ LI+=1,0 PSAY "!----------!--------!----------!----------!----------!-----------!-----------!"
	@ LI+=1,0 PSAY "!          !        !          !          !          !           !           !"
	@ LI+=1,0 PSAY "!----------!--------!----------!----------!----------!-----------!-----------!"
	@ LI+=1,0 PSAY "!          !        !          !          !          !           !           !"
	@ LI+=1,0 PSAY "!----------!--------!----------!----------!----------!-----------!-----------!"
	@ LI+=1,0 PSAY "!          !        !          !          !          !           !           !"
	@ LI+=1,0 PSAY "!----------!--------!----------!----------!----------!-----------!-----------!"
	@ LI+=1,0 PSAY "!          !        !          !          !          !           !           !"
	@ LI+=1,0 PSAY "!----------!--------!----------!----------!----------!-----------!-----------!"
	@ LI+=1,0 PSAY "!                                                                            !"
	@ LI+=1,0 PSAY "!  Equipamento Medição _____________________________________________________ !"
	@ LI+=1,0 PSAY "!                                                                            !"
	@ LI+=1,0 PSAY " ----------------------------------------------------------------------------"

RETURN

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STPCR001  ºAutor  ³Microsiga           º Data ³  03/15/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ImpDefe()
	LI:=1
	@ LI,65 PSAY alltrim(str(_nImpr))+"a impressao"


	li:=2
	@ LI,0 PSAY "STECK  -  ORDEM DE PRODUÇÃO                   DATA: "+dtoc(ddatabase)+"  "+substr(time(),1,5)+"  PAG.: "+ strzero(_NPAG,2)
	LI+=2
	@ LI,0 PSAY "      *****************  APONTAMENTO DE DEFEITOS  ***********************"
	LI+=2
	@ LI,0 PSAY "Ordem de Produção: "+SC2->C2_NUM+"|"+SC2->C2_ITEM+"|"+SC2->C2_SEQUEN+" - Data Entrega: "+DTOC(SC2->C2_DATPRF)+" - Qtde: "+ALLTRIM(TRANSFORM(SC2->C2_QUANT,"@e 999,999.99"))
	LI++
	@ LI,0 PSAY "Produto .....: "+SC2->C2_PRODUTO + substr(Posicione("SB1",1,xFilial("SB1")+SC2->C2_PRODUTO,"B1_DESC"),1,50)
	LI++
	@ LI,0 PSAY "Data Inicio..: "+DTOC(SC2->C2_DATPRI)
	LI++

	// Alterado o layout abaixo conforme chamado 005475 - Robson Mazzarotto
	@ LI+=1,0 PSAY " ------------------------------------------------------------------------------"
	@ LI+=1,0 PSAY "!    Codigo     ! Data   ! Tipo ! Quantid. !  Lote        ! Arm.Des.! Observ.  !"
	@ LI+=1,0 PSAY "!               ! Ocorr. ! Def. ! Afetada  !              !         !          !"
	@ LI+=1,0 PSAY "!---------------!--------!------!----------!--------------!---------!----------!"
	@ LI+=1,0 PSAY "!               !        !      !          !              !         !          !"
	@ LI+=1,0 PSAY "!---------------!--------!------!----------!--------------!---------!----------!"
	@ LI+=1,0 PSAY "!               !        !      !          !              !         !          !"
	@ LI+=1,0 PSAY "!---------------!--------!------!----------!--------------!---------!----------!"
	@ LI+=1,0 PSAY "!               !        !      !          !              !         !          !"
	@ LI+=1,0 PSAY "!---------------!--------!------!----------!--------------!---------!----------!"
	@ LI+=1,0 PSAY "!               !        !      !          !              !         !          !"
	@ LI+=1,0 PSAY "!---------------!--------!------!----------!--------------!---------!----------!"
	@ LI+=1,0 PSAY "!               !        !      !          !              !         !          !"
	@ LI+=1,0 PSAY "!---------------!--------!------!----------!--------------!---------!----------!"
	@ LI+=1,0 PSAY "!               !        !      !          !              !         !          !"
	@ LI+=1,0 PSAY "!---------------!--------!------!----------!--------------!---------!----------!"
	@ LI+=1,0 PSAY "!               !        !      !          !              !         !          !"
	@ LI+=1,0 PSAY "!---------------!--------!------!----------!--------------!---------!----------!"
	@ LI+=1,0 PSAY "!               !        !      !          !              !         !          !"
	@ LI+=1,0 PSAY "!---------------!--------!------!----------!--------------!---------!----------!"
	@ LI+=1,0 PSAY "!               !        !      !          !              !         !          !"
	@ LI+=1,0 PSAY "!---------------!--------!------!----------!--------------!---------!----------!"
	@ LI+=1,0 PSAY "!               !        !      !          !              !         !          !"
	@ LI+=1,0 PSAY "!---------------!--------!------!----------!--------------!---------!----------!"
	@ LI+=1,0 PSAY "!               !        !      !          !              !         !          !"
	@ LI+=1,0 PSAY "!---------------!--------!------!----------!--------------!---------!----------!"
	@ LI+=1,0 PSAY "!               !        !      !          !              !         !          !"
	@ LI+=1,0 PSAY "!---------------!--------!------!----------!--------------!---------!----------!"
	@ LI+=1,0 PSAY "!               !        !      !          !              !         !          !"
	@ LI+=1,0 PSAY "!---------------!--------!------!----------!--------------!---------!----------!"
	@ LI+=1,0 PSAY "!               !        !      !          !              !         !          !"
	@ LI+=1,0 PSAY "!---------------!--------!------!----------!--------------!---------!----------!"
	@ LI+=1,0 PSAY "!               !        !      !          !              !         !          !"
	@ LI+=1,0 PSAY " ------------------------------------------------------------------------------"

	// Comentado a linhas abaixo conforme chamado 005475 - Robson Mazzarotto

	/*
	@ LI+=2,0 PSAY "                            PROVIDENCIA IMEDIATA                               "
	@ LI+=1,0 PSAY " ------------------------------------------------------------------------------"
	@ LI+=1,0 PSAY " SU-SUCATEAR    RE-RETRABALHAR    SE-SEGREGAR    TR-TROCAR    UT-UTILIZAR T/Q  "
	@ LI+=1,0 PSAY " ------------------------------------------------------------------------------"

	@ LI+=2,0 PSAY "                           LOCAL DE RETRABALHO                                 "
	@ LI+=1,0 PSAY " ------------------------------------------------------------------------------"
	@ LI+=1,0 PSAY " BMO-BANC.MONT.      BRE-BANC.RETRAB.       ALM-ALMOXAR.       INJ-INJETORA    "
	@ LI+=1,0 PSAY " ------------------------------------------------------------------------------"
	*/
	if cEmpAnt != "01"   // Valdemir Rabelo 11/04/2022 - Chamado: 20220321006211
		@ LI+=2,0 PSAY "                             TIPOS DE DEFEITO                                  "
		@ LI+=1,0 PSAY " ------------------------------------------------------------------------------"
		@ LI+=1,0 PSAY " 10 - DEFORMACOES          17 - PECA QUEBRADICA       23 - PECA SUJA           "
		@ LI+=1,0 PSAY " 11 - MANCHAS              18 - NAO MONTA             24 - PECA INCORRETA      "
		@ LI+=1,0 PSAY " 12 - REBARBAS             19 - NAO FUNCIONA          25 - ROSCA ESPANANDO     "
		@ LI+=1,0 PSAY " 13 - RISCOS               20 - PECAS MISTURADAS      26 - MONTAGEM INCORRETA  "
		@ LI+=1,0 PSAY " 14 - FALHA INJECAO        21 - DIMENSION.INCORRETO   27 - PECA QUEBRADA       "
		@ LI+=1,0 PSAY " 15 - EMPENAMENTO          22 - PECAS COM CAVACO      28 - OUTROS              "
		@ LI+=1,0 PSAY " 16 - FORA DE TONALIDADE                                                       "
		@ LI+=1,0 PSAY " ------------------------------------------------------------------------------"
	Endif 
Return



/*/
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³ Fun‡…o   ³IMP_FORMUL³ Autor ³ EVERALDO GALLO        ³ Data ³ 28/06/03 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³ Descri‡…o³                                                            ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³ Sintaxe  ³                                                            ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Parametros³                                                            ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³ Uso      ³ Ordem de Producao - PCP - STECK                             ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/
/*

STATIC FUNCTION IMPREQUIS(_cLocal)
LI:=1
@ LI,65 PSAY alltrim(str(_nImpr))+"a impressao"

LI:=2
@ LI,0 PSAY "STECK  -  ORDEM DE SERVICO                   DATA: "+dtoc(ddatabase)+"  "+substr(time(),1,5)+"  PAG.: "+ strzero(_NPAG,2)
LI+=2
@ LI,0 PSAY "REQUISICAO DE COMPONENTES  # : "+SC2->(C2_NUM+C2_ITEM+C2_SEQUEN)+"  -  " +  iif(_cLocal=='01',"ALMOXARIFADO","EXPEDICAO")
LI+=2
@ LI,0 PSAY "Ordem Servico: "+SC2->(C2_NUM+C2_ITEM+C2_SEQUEN)+"     Data Entrega: "+DTOC(SC2->C2_DATPRI)+"         Qtde: "+ALLTRIM(TRANSFORM(SC2->C2_QUANT,"@e 999,999.99"))
LI++
@ LI,0 PSAY "Produto .....: "+SC2->C2_PRODUTO + SUBSTR(SB1->B1_DESC,1,50)
LI++
@ LI,0 PSAY "Desenho......:" +SB1->B1_XDESENH
LI++
@ LI,0 PSAY "Observacoes..: "+SC2->C2_OBS
LI++
@ LI,0 PSAY "Obs.Rota ....: "
LI+=2

@ LI,0 PSAY "                                SISTEMA DA QUALIDADE"
LI+=2     //              1          2         3         4         5        6         7
//              012345678901234567890123456789012345678901234567890123456789012345678901234567
@ LI+=1,0 PSAY "------------------------------------------------- -------- Quantidade ---------"
@ LI+=1,0 PSAY "Componente           Descricao        UM  Local.   Requis.   Reserv.  Atendida "
@ LI+=1,0 PSAY "----------- ------------------------- -- -------- --------- --------- ---------"

@ LI+=1,0 PSAY "          ****  Aplicacao : " +SC2->(C2_NUM+C2_ITEM+C2_SEQUEN)

DBSELECTAREA("SD4")
DBSETORDER(2)
DBSEEK(XFILIAL("SD4")+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN)
	DO WHILE (SUBSTR(SD4->D4_OP,1,11) = SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN) .AND. !EOF()
		IF LI > 58
_NPAG++
LI:=2
@ LI,0 PSAY "STECK  -  ORDEM DE SERVICO                   DATA: "+dtoc(ddatabase)+"  "+substr(time(),1,5)+"  PAG.: "+ strzero(_NPAG,2)
LI+=2
@ LI,0 PSAY "REQUISICAO DE COMPONENTES  # : "+SC2->(C2_NUM+C2_ITEM+C2_SEQUEN)+"  -  " +  iif(_cLocal=='01',"ALMOXARIFADO","EXPEDICAO")
LI+=2
@ LI,0 PSAY "Ordem Servico: "+SC2->(C2_NUM+C2_ITEM+C2_SEQUEN)+"     Data Entrega: "+DTOC(SC2->C2_DATPRI)+"         Qtde: "+ALLTRIM(TRANSFORM(SC2->C2_QUANT,"@e 999,999.99"))
LI++
@ LI,0 PSAY "Produto .....: "+SC2->C2_PRODUTO + SUBSTR(SB1->B1_DESC,1,50)
LI++
@ LI,0 PSAY "Desenho......:" + SB1->B1_XDESENH
LI++
@ LI,0 PSAY "Observacoes..: "+ SC2->C2_OBS
LI++
@ LI,0 PSAY "Obs.Rota ....: "
LI+=2

@ LI,0 PSAY "                                SISTEMA DA QUALIDADE"
LI+=2     //              1          2         3         4         5        6         7
//              012345678901234567890123456789012345678901234567890123456789012345678901234567
@ LI+=1,0 PSAY "------------------------------------------------- -------- Quantidade ---------"
@ LI+=1,0 PSAY "Componente           Descricao        UM  Local.   Requis.   Reserv.  Atendida "
@ LI+=1,0 PSAY "----------- ------------------------- -- -------- --------- --------- ---------"

@ LI+=1,0 PSAY "          ****  Aplicacao : " +SC2->(C2_NUM+C2_ITEM+C2_SEQUEN)

		ENDIF
DBSELECTAREA("SB1")
DBSEEK(XFILIAL("SB1")+SD4->D4_COD)

		IF SB1->B1_LOCPAD == _cLocal
@ LI+=1,0   PSAY  SUBSTR(SD4->D4_COD,1,11)
@ LI,12    PSAY SUBsTR(SB1->B1_dESC,1,25)
@ LI,38  PSAY  SB1->B1_UM
@ LI,41  PSAY  SD4->D4_LOCAL
@ LI,50  PSAY  SD4->D4_QUANT PICTURE "@e 999999.99"
Dbselectarea("PA2")
DbSetOrder(2)
Dbseek(xfilial("PA2")+"2"+SUBSTR(SD4->D4_OP,1,11)+SD4->D4_COD)
			IF Eof()
@ LI,60  PSAY  "_________"
			Else
@ LI,60  PSAY  PA2->PA2_QUANT PICTURE "@e 999999.99"
			Endif
@ LI,70  PSAY  "_________"
		ENDIF
DBSELECTAREA("SD4")
DBSKIP()


	ENDDO

DBSELECTAREA("SB1")
DBSEEK(XFILIAL("SB1")+SC2->C2_PRODUTO)

RETURN
*/



/*/
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³ Fun‡…o   ³IMP_FORMUL³ Autor ³ EVERALDO GALLO        ³ Data ³ 28/06/03 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³ Descri‡…o³                                                            ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³ Sintaxe  ³                                                            ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Parametros³                                                            ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³ Uso      ³ Ordem de Producao - PCP - STECK                             ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/

/*
STATIC FUNCTION IMPRQMAT(_cLocal,_cDescricao)
LI:=77
DBSELECTAREA("SD4")
DBSETORDER(2)
DBSEEK(XFILIAL("SD4")+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN)
	DO WHILE (SUBSTR(SD4->D4_OP,1,11) = SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN) .AND. !EOF()
DBSELECTAREA("SB1")
DBSEEK(XFILIAL("SB1")+SD4->D4_COD)

		IF SD4->D4_LOCAL == _cLocal

			if LI > 60

LI:=1
@ LI,65 PSAY alltrim(str(_nImpr))+"a impressao"

LI+=2
@ LI,0 PSAY "STECK  -  ORDEM DE SERVICO                   DATA: "+dtoc(ddatabase)+"  "+substr(time(),1,5)+"  PAG.: "+ strzero(_NPAG,2)
LI++
@ LI,0 PSAY    "=============================================================================="
LI++
@ LI,0 PSAY "    REQUISICAO DE MATERIAIS - " + _cLocal + " - " + _cDescricao
LI++
@ LI,0 PSAY    "=============================================================================="
LI++
@ LI,0 PSAY "Ordem Servico: "+SC2->(C2_NUM+C2_ITEM+C2_SEQUEN)+"     Data Entrega: "+DTOC(SC2->C2_DATPRI)+"         Qtde: "+ALLTRIM(TRANSFORM(SC2->C2_QUANT,"@e 999,999.99"))
LI++
@ LI,0 PSAY "Produto .....: "+SC2->C2_PRODUTO + SUBSTR(SB1->B1_DESC,1,50)
//LI+2
LI++
@ LI+=1,0 PSAY " ****************************  COMPONENTES  ***********************************"
@ LI+=1,0 PSAY " Produto                      Denominacao             UM  Empenhado    Entregue"
@ LI+=1,0 PSAY " ---------------- ----------------------------------- -- ----------- ----------"
//               12345678901234567890123456789012345678901234567890123456789012345678901234567890
//		                  1         2         3         4         5   67890
			Endif


@ LI+=1,1   PSAY  SUBSTR(SD4->D4_COD,1,15)
@ LI,17    PSAY SUBsTR(SB1->B1_dESC,1,35)

@ LI,54  PSAY  SB1->B1_UM
@ LI,58  PSAY  SD4->D4_QUANT PICTURE "@e 999999.999"
@ LI,70  PSAY  "__________"

		ENDIF

DBSELECTAREA("SD4")
DBSKIP()

	ENDDO

RETURN
*/

Static Function StQuery1()

	Local cQuery1     := ' '

	cQuery1 := " SELECT
	cQuery1 += " G1_COD AS CODIGO,
	cQuery1 += " G1_COMP AS COMPONENTE,
	cQuery1 += " B1_DESC AS DESCRICAO,
	cQuery1 += " B1_TIPO AS TIPO,
	cQuery1 += " B1_APROPRI AS APROPRIACAO,
	cQuery1 += " B1_UM AS UNIDADE_MEDIDA,
	cQuery1 += " G1_QUANT*C2_QUANT AS G1_QUANT_ESTRUTURA,
	cQuery1 += " D4_QUANT AS D4_EMPENHO,
	cQuery1 += " PA2_QUANT AS RESERVA,
	cQuery1 += " (C2_NUM||''||C2_ITEM||''||C2_SEQUEN) AS OP,
	cQuery1 += " B1_FANTASM AS FANTASMA

	cQuery1 += " FROM "+RetSqlName("SC2")+" SC2 "

	cQuery1 += " INNER JOIN "+RetSqlName("SG1")+" SG1 "
	cQuery1 += " ON SG1.D_E_L_E_T_ = ' '
	cQuery1 += " AND C2_PRODUTO = G1_COD

	cQuery1 += " LEFT JOIN "+RetSqlName("SD4")+" SD4 "
	cQuery1 += " ON SD4.D_E_L_E_T_ = ' '
	cQuery1 += " AND D4_OP = (C2_NUM||''||C2_ITEM||''||C2_SEQUEN)
	cQuery1 += " AND D4_COD = G1_COMP
	cQuery1 += " AND D4_FILIAL = C2_FILIAL

	cQuery1 += " INNER JOIN "+RetSqlName("SB1")+" SB1 "
	cQuery1 += " ON SB1.D_E_L_E_T_ = ' '
	cQuery1 += " AND B1_COD = G1_COMP
	cQuery1 += " AND B1_TIPO = 'IC'

	cQuery1 += " LEFT JOIN "+RetSqlName("PA2")+" PA2 "
	cQuery1 += " ON PA2.D_E_L_E_T_ = ' '
	cQuery1 += " AND PA2_DOC = (C2_NUM||''||C2_ITEM||''||C2_SEQUEN)
	cQuery1 += " AND PA2_CODPRO = G1_COMP
	cQuery1 += " AND PA2_FILRES = C2_FILIAL

	cQuery1 += " WHERE SC2.D_E_L_E_T_ = ' '
	cQuery1 += " AND C2_NUM    = '"+SC2->C2_NUM+"'
	cQuery1 += " AND C2_ITEM   = '"+SC2->C2_ITEM+"'
	cQuery1 += " AND C2_SEQUEN = '"+SC2->C2_SEQUEN+"'
	cQuery1 += " AND C2_EMISSAO BETWEEN '"+DTOS(mv_par03)+"' AND '"+DTOS(mv_par04)+"'

	cQuery1 += " ORDER BY SG1.R_E_C_N_O_, B1_TIPO, B1_APROPRI

	cQuery1 := ChangeQuery(cQuery1)

	If Select(cAlias1) > 0
		(cAlias1)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery1),cAlias1)


Static Function StQuery2()

	Local cQuery2     := ' '

	cQuery2 := " SELECT
	cQuery2 += " C2_PRODUTO        AS CODIGO,
	cQuery2 += " D4_COD            AS COMPONENTE,
	cQuery2 += " B1_DESC           AS DESCRICAO,
	cQuery2 += " B1_TIPO           AS TIPO,
	cQuery2 += " B1_APROPRI        AS APROPRIACAO,
	cQuery2 += " B1_UM             AS UNIDADE_MEDIDA,
	cQuery2 += " D4_QTDEORI        AS G1_QUANT_ESTRUTURA,
	cQuery2 += " D4_QUANT          AS D4_EMPENHO,
	cQuery2 += " PA2_QUANT         AS RESERVA,
	cQuery2 += " (C2_NUM||''||C2_ITEM||''||C2_SEQUEN) AS OP,
	cQuery2 += " B1_FANTASM        AS FANTASMA

	cQuery2 += " FROM "+RetSqlName("SD4")+" SD4 "

	cQuery2 += " INNER JOIN "+RetSqlName("SC2")+" SC2 "
	cQuery2 += " ON SC2.D_E_L_E_T_ = ' '
	cQuery2 += " AND SUBSTR(D4_OP,1,6) = C2_NUM
	cQuery2 += " AND SUBSTR(D4_OP,7,2) = C2_ITEM
	cQuery2 += " AND SUBSTR(D4_OP,9,3) = C2_SEQUEN
	cQuery2 += " AND D4_FILIAL = C2_FILIAL
	cQuery2 += " AND C2_NUM    = '"+SC2->C2_NUM+"'
	cQuery2 += " AND C2_ITEM   = '"+SC2->C2_ITEM+"'
	cQuery2 += " AND C2_SEQUEN = '"+SC2->C2_SEQUEN+"'
	cQuery2 += " AND C2_EMISSAO BETWEEN '"+DTOS(mv_par03)+"' AND '"+DTOS(mv_par04)+"'

	cQuery2 += " LEFT JOIN "+RetSqlName("SG1")+" SG1 "
	cQuery2 += " ON SG1.D_E_L_E_T_ = ' '
	cQuery2 += " AND G1_COMP   = D4_COD
	cQuery2 += " AND G1_FILIAL = D4_FILIAL
	cQuery2 += " AND G1_COD    = C2_PRODUTO

	cQuery2 += " INNER JOIN "+RetSqlName("SB1")+" SB1 "
	cQuery2 += " ON SB1.D_E_L_E_T_ = ' '
	cQuery2 += " AND B1_COD = D4_COD
	cQuery2 += " AND B1_TIPO <> 'IC'
	cQuery2 += " AND B1_APROPRI = 'D'

	cQuery2 += " LEFT JOIN "+RetSqlName("PA2")+" PA2 "
	cQuery2 += " ON PA2.D_E_L_E_T_ = ' '
	cQuery2 += " AND SUBSTR( PA2_DOC,1,6) = C2_NUM
	cQuery2 += " AND SUBSTR( PA2_DOC,7,2) = C2_ITEM
	cQuery2 += " AND SUBSTR( PA2_DOC,9,3) = C2_SEQUEN
	cQuery2 += " AND PA2_CODPRO = D4_COD
	cQuery2 += " AND PA2_FILRES = D4_FILIAL

	cQuery2 += " WHERE SD4.D_E_L_E_T_ = ' '

	cQuery2 := ChangeQuery(cQuery2)

	If Select(cAlias2) > 0
		(cAlias2)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery2),cAlias2)




Static Function StQuery3()

	Local cQuery3     := ' '

	cQuery3 := " SELECT
	cQuery3 += " C2_PRODUTO        AS CODIGO,
	cQuery3 += " D4_COD            AS COMPONENTE,
	cQuery3 += " B1_DESC           AS DESCRICAO,
	cQuery3 += " B1_TIPO           AS TIPO,
	cQuery3 += " B1_APROPRI        AS APROPRIACAO,
	cQuery3 += " B1_UM             AS UNIDADE_MEDIDA,
	cQuery3 += " D4_QTDEORI        AS G1_QUANT_ESTRUTURA,
	cQuery3 += " D4_QUANT          AS D4_EMPENHO,
	cQuery3 += " PA2_QUANT         AS RESERVA,
	cQuery3 += " (C2_NUM||''||C2_ITEM||''||C2_SEQUEN) AS OP,
	cQuery3 += " B1_FANTASM        AS FANTASMA

	cQuery3 += " FROM "+RetSqlName("SD4")+" SD4 "

	cQuery3 += " INNER JOIN "+RetSqlName("SC2")+" SC2 "
	cQuery3 += " ON SC2.D_E_L_E_T_ = ' '
	cQuery3 += " AND SUBSTR(D4_OP,1,6) = C2_NUM
	cQuery3 += " AND SUBSTR(D4_OP,7,2) = C2_ITEM
	cQuery3 += " AND SUBSTR(D4_OP,9,3) = C2_SEQUEN
	cQuery3 += " AND D4_FILIAL = C2_FILIAL
	cQuery3 += " AND C2_NUM    = '"+SC2->C2_NUM+"'
	cQuery3 += " AND C2_ITEM   = '"+SC2->C2_ITEM+"'
	cQuery3 += " AND C2_SEQUEN = '"+SC2->C2_SEQUEN+"'
	cQuery3 += " AND C2_EMISSAO BETWEEN '"+DTOS(mv_par03)+"' AND '"+DTOS(mv_par04)+"'

	cQuery3 += " LEFT JOIN "+RetSqlName("SG1")+" SG1 "
	cQuery3 += " ON SG1.D_E_L_E_T_ = ' '
	cQuery3 += " AND G1_COMP   = D4_COD
	cQuery3 += " AND G1_FILIAL = D4_FILIAL
	cQuery3 += " AND G1_COD    = C2_PRODUTO

	cQuery3 += " INNER JOIN "+RetSqlName("SB1")+" SB1 "
	cQuery3 += " ON SB1.D_E_L_E_T_ = ' '
	cQuery3 += " AND B1_COD = D4_COD
	cQuery3 += " AND B1_TIPO <> 'IC'
	cQuery3 += " AND B1_APROPRI = 'I'

	cQuery3 += " LEFT JOIN "+RetSqlName("PA2")+" PA2 "
	cQuery3 += " ON PA2.D_E_L_E_T_ = ' '
	cQuery3 += " AND SUBSTR( PA2_DOC,1,6) = C2_NUM
	cQuery3 += " AND SUBSTR( PA2_DOC,7,2) = C2_ITEM
	cQuery3 += " AND SUBSTR( PA2_DOC,9,3) = C2_SEQUEN
	cQuery3 += " AND PA2_CODPRO = D4_COD
	cQuery3 += " AND PA2_FILRES = D4_FILIAL

	cQuery3 += " WHERE SD4.D_E_L_E_T_ = ' '

	cQuery3 := ChangeQuery(cQuery3)

	If Select(cAlias3) > 0
		(cAlias3)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery3),cAlias3)





Static Function STQUERY4 ()

	StQuery2()
	DbSelectArea(cAlias2)
	(cAlias2)->(DbGoTop())
	If  Select(cAlias2) > 0

		While 	(cAlias2)->(!Eof())

			aAdd(aDados1,{"Direto",;              //01
			(cAlias2)->CODIGO,;               //02
			(cAlias2)->COMPONENTE,;           //03
			(cAlias2)->DESCRICAO,;            //04
			(cAlias2)->TIPO,;                 //05
			(cAlias2)->APROPRIACAO,;          //06
			(cAlias2)->UNIDADE_MEDIDA,;       //07
			(cAlias2)->G1_QUANT_ESTRUTURA,;   //08
			(cAlias2)->D4_EMPENHO,;           //09
			(cAlias2)->RESERVA,;              //10
			(cAlias2)->OP,;                   //11
			(cAlias2)->FANTASMA,;             //12
			""})                              //13

			(cAlias2)->(dbskip())
		End
		(cAlias2)->(dbCloseArea())
	Endif


	StQuery3()
	DbSelectArea(cAlias3)
	(cAlias3)->(DbGoTop())
	If  Select(cAlias3) > 0

		While 	(cAlias3)->(!Eof())

			aAdd(aDados1,{"Indireto",;            //01
			(cAlias3)->CODIGO,;               //02
			(cAlias3)->COMPONENTE,;           //03
			(cAlias3)->DESCRICAO,;            //04
			(cAlias3)->TIPO,;                 //05
			(cAlias3)->APROPRIACAO,;          //06
			(cAlias3)->UNIDADE_MEDIDA,;       //07
			(cAlias3)->G1_QUANT_ESTRUTURA,;   //08
			(cAlias3)->D4_EMPENHO,;           //09
			(cAlias3)->RESERVA,;              //10
			(cAlias3)->OP,;                   //11
			(cAlias3)->FANTASMA,;             //12
			""})                              //13

			(cAlias3)->(dbskip())
		End
		(cAlias3)->(dbCloseArea())
	Endif

	StQuery1()
	DbSelectArea(cAlias1)
	(cAlias1)->(DbGoTop())
	If  Select(cAlias1) > 0
		While !(cAlias1)->( Eof() )

			aAdd(aDados1,{"Consumo",;             //01
			(cAlias1)->CODIGO,;               //02
			(cAlias1)->COMPONENTE,;           //03
			(cAlias1)->DESCRICAO,;            //04
			(cAlias1)->TIPO,;                 //05
			(cAlias1)->APROPRIACAO,;          //06
			(cAlias1)->UNIDADE_MEDIDA,;       //07
			(cAlias1)->G1_QUANT_ESTRUTURA,;   //08
			(cAlias1)->D4_EMPENHO,;           //09
			(cAlias1)->RESERVA,;              //10
			(cAlias1)->OP,;                   //11
			(cAlias1)->FANTASMA,;             //12
			""})                              //13

			(cAlias1)->( dbSkip() )

		End

		(cAlias1)->( dbCloseArea() )
	Endif

Return


/*/{Protheus.doc} ImpCntOP
	description
	Rotina Imprimir Comtinuação Ordem Produção
	Ticket: 20200715004231
	@type function
	@version  
	@author Valdemir Jose
	@since 14/04/2021
	@return return_type, return_description
/*/
Static Function ImpCntOP()
   Local lAdjustToLegacy 	:= .F.
    Local lDisableSetup  	:= .T.
    Local cLocal            := "\spool"
    Private cLogoD          := GetSrvProfString("Startpath","") + "lgrl"+cEmpAnt+".bmp"
    Private oBshCClaro      := TBrush():New(,CLR_HGRAY) // Cinza Claro
    Private _cNUMOP         := ALLTRIM(SC2->(C2_FILIAL+C2_NUM+C2_ITEM+C2_SEQUEN))
    Private oPrinter

    MakeDir("C:\Temp")

    oPrinter := FWMSPrinter():New("OP_"+_cNUMOP+".PDF",IMP_PDF, lAdjustToLegacy,cLocal,lDisableSetup, , , , , , .F., .T. )

    if File("C:\Temp\"+"OP_"+_cNUMOP+".PDF")
        FErase("C:\Temp\"+"OP_"+_cNUMOP+".PDF")
    endif

    oPrinter:SetPortrait()
    oPrinter:SetResolution(72)
    oPrinter:SetPaperSize(DMPAPER_A4)	// A4 210mm x 297mm  620 x 876
    oPrinter:cPathPDF :="C:\Temp\"

    Processa( {|| InitProc() }, "Imprimindo Continuação OP: "+_cNUMOP+", Aguarde...")

    oPrinter:Preview()

    FreeObj(oPrinter)
    oPrinter := Nil

Return 

/*/{Protheus.doc} InitProc
description
Rotina Monta layOut para impressão 
@type function
@version  
@author Valdemir Jose
@since 14/04/2021
@return return_type, return_description
/*/
Static Function InitProc()
    Local nLin    := 0050
    Local nCol	  := 0040
    Local nConta  := 0
    Local nMaxLin := 750
    Local nMaxQdr := 600
    Private nPag  := 0

    // Titulo e Logo
    oPrinter:StartPage()
    oPrinter:SayBitmap (nLin - 0020,nCol - 0020 ,cLogoD ,0088,0025)	// < nRow>, < nCol>, < cBitmap>, [ nWidth], [ nHeight]
    oPrinter:Say (nLin, nCol + 0180,"Continuação Ordem de Produção", oFont18N )
    nLin += 35
	//oPrinter:Line(nLin, nCol+110, nLin, nCol+250)
    oPrinter:Say (nLin, nCol-010, "ORDEM DE PRODUÇÃO:  " + _cNUMOP,    oFont11)
	//oPrinter:Line(nLin, nCol+400, nLin, nCol+520)
    oPrinter:Say (nLin, nCol+285, "QUANTIDADE DO PEDIDO:  " + cValToChar(SC2->C2_QUANT), oFont11)
    nLin += 20
	//oPrinter:Line(nLin, nCol+110, nLin, nCol+250)
    oPrinter:Say (nLin, nCol-010, "CÓDIGO DO PRODUTO:  " + SC2->C2_PRODUTO,    oFont11)
    nLin += 25

    //oPrinter:Box(nLin-10, nCol-20,  nLin+104, nCol,"-4")         // Quadro canto esquerdo para texto Vertical
    
	oPrinter:Box(nLin-10, nCol-020, nLin+28, nCol+090,"-4")     // Quadro DATA
    oPrinter:Box(nLin-10, nCol+070, nLin+28, nCol+180,"-4")     // Quadro RI OPERADOR
    
	oPrinter:Box(nLin-10, nCol+160, nLin+06, nCol+280,"-4")

	oPrinter:Box(nLin+06, nCol+160, nLin+28, nCol+208,"-4")     // Quadro HORA INICIO
    oPrinter:Box(nLin+06, nCol+208, nLin+28, nCol+260,"-4")     // Quadro HORA FIM
    oPrinter:Box(nLin-10, nCol+260, nLin+28, nCol+370,"-4")     // Quadro QUANTIDADE PRODUZIDA
    oPrinter:Box(nLin-10, nCol+370, nLin+28, nCol+460,"-4")     // Quadro QUANTIDADE REFUGADA
    oPrinter:Box(nLin-10, nCol+460, nLin+28, nCol+550,"-4")     // Quadro MOTIVO

	oPrinter:Say (nLin, nCol+180, "FREQUENCIA",    oFont10N)
    nLin += 14
	oPrinter:Say (nLin,   nCol+10,  "DATA",        oFont10N)
	oPrinter:Say (nLin,   nCol+085, "RI OPERADOR", oFont10N)
	oPrinter:Say (nLin,   nCol+175, "HORA", 	   oFont10N)
	oPrinter:Say (nLin,   nCol+225, "HORA",        oFont10N)
	oPrinter:Say (nLin-5, nCol+285, "QUANTIDADE",  oFont10N)
	oPrinter:Say (nLin-5, nCol+383, "QUANTIDADE",  oFont10N)
	oPrinter:Say (nLin,   nCol+490, "MOTIVO",      oFont10N)
	nLin += 08
	oPrinter:Say (nLin,   nCol+175, "INICIO",    oFont10N)
	oPrinter:Say (nLin,   nCol+228, "FIM",       oFont10N)
	oPrinter:Say (nLin-5, nCol+288, "PRODUZIDA", oFont10N)
	oPrinter:Say (nLin-5, nCol+385, "REFUGADA",  oFont10N)
	nLin += 14

	FOR nConta := 1 TO 30
		oPrinter:Box(nLin-10, nCol-020, nLin+08, nCol+090,"-4")     // Quadro DATA
		oPrinter:Box(nLin-10, nCol+070, nLin+08, nCol+180,"-4")     // Quadro RI OPERADOR
		oPrinter:Box(nLin-10, nCol+160, nLin+08, nCol+208,"-4")     // Quadro HORA INICIO
		oPrinter:Box(nLin-10, nCol+208, nLin+08, nCol+260,"-4")     // Quadro HORA FIM
		oPrinter:Box(nLin-10, nCol+260, nLin+08, nCol+370,"-4")     // Quadro QUANTIDADE PRODUZIDA
		oPrinter:Box(nLin-10, nCol+370, nLin+08, nCol+460,"-4")     // Quadro QUANTIDADE REFUGADA
		oPrinter:Box(nLin-10, nCol+460, nLin+08, nCol+550,"-4")     // Quadro MOTIVO
		nLin += 14		
	NEXT 	
	oPrinter:EndPage()
Return 



User Function TstImp()
     dbSelectArea("SC2")
     ImpCntOP()
Return
