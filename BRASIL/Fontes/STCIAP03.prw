#Include "Protheus.ch"
#Include "RwMake.ch"
#Include "TbiConn.ch"
#INCLUDE  "TOPCONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STCIAP03  º Autor ³ Everson Santana   º Data ³   05/11/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Gerar Nota Fiscal de Credito CIAP                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³                                                            º±±
±±º          ³                                                            º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function STCIAP03()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	Private cString
	Private cPerg  := "STCIAP03"+Space(02)
/* Removido - 18/05/2023 - Não executa mais Recklock na X1 - Criar/alterar perguntas no configurador
	DbSelectArea("SX1")

	If ! DbSeek(cPerg+"01",.t.)
		Reclock("SX1",.t.)
		SX1->X1_GRUPO   := cPerg
		SX1->X1_ORDEM   := "01"
		SX1->X1_PERGUNT := "Da Data "
		SX1->X1_VARIAVL := "mv_ch1"
		SX1->X1_TIPO    := "D"
		SX1->X1_TAMANHO := 08
		SX1->X1_DECIMAL := 0
		SX1->X1_PRESEL  := 0
		SX1->X1_GSC     := "G"
		SX1->X1_VALID   := ""
		SX1->X1_VAR01   := "mv_par01"
		SX1->X1_DEF01   := ""
	EndIf

	If ! DbSeek(cPerg+"02",.t.)
		Reclock("SX1",.t.)
		SX1->X1_GRUPO   := cPerg
		SX1->X1_ORDEM   := "02"
		SX1->X1_PERGUNT := "Ate Data "
		SX1->X1_VARIAVL := "mv_ch2"
		SX1->X1_TIPO    := "D"
		SX1->X1_TAMANHO := 08
		SX1->X1_DECIMAL := 0
		SX1->X1_PRESEL  := 0
		SX1->X1_GSC     := "G"
		SX1->X1_VALID   := ""
		SX1->X1_VAR01   := "mv_par02"
		SX1->X1_DEF01   := ""
	EndIf*/

// Solicita paramentros para impressao do relatorio
	If !Pergunte(cPerg,.T.)
		Return
	Else
		Processa( {|| STCIAP03A()} ,"Selecionando Registros..................." )
	Endif

Return


/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
	±±ºFun‡„o    ³ STCIAP03Aº Autor ³ Everson Santana    º Data ³  05/11/2020 º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºDescri‡„o ³                                                            º±±
	±±º          ³                                                            º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºUso       ³                                                            º±±
	±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function  STCIAP03A()

	Local _cQrySFA := ""

	Local aCab := {}
	Local aItem := {}
	Local aItens := {}
	Local aItensRat := {}
	Local aCodRet := {}
	Local nOpc := 3
	Local cNum := ""
	Local nI := 0
	Local nX := 0
	Local nReg := 1
	Local _cLoja := ""
	Local _cNFCIAP := GETMV('ST_NFCIAP')
	Local _cMesAtu := Subs(Dtos(MV_PAR01),1,6)

	Private lMsErroAuto := .F.
	Private lMsHelpAuto := .T.

	If ! cEmpAnt $ "01#11"

		MsgAlert("Esta rotina é so para São Paulo, verifique a empresa.","Atenção")
		Return

	EndIf

	If Alltrim(_cNFCIAP) == Alltrim(_cMesAtu)

		MsgAlert("Para este periodo já existe uma Nota Fiscal CIAP gerada. Mes: "+_cNFCIAP,"ST_NFCIAP")
		Return

	Endif

// Fecha arquivo temporario
	If Select("TSFA") > 0
		DbSelectArea("TSFA")
		dbclosearea()
	Endif

// Selecionar notas  fiscais de entrada
	_cQrySFA := " SELECT SUM(FA_VALOR) FA_VALOR "
	_cQrySFA += " FROM "+RetSqlName("SFA")+" SFA, "+RetSqlName("SF9")+" SF9 "
	_cQrySFA += " WHERE FA_FILIAL = '"+xFilial("SFA")+"' AND SFA.FA_FILIAL = SF9.F9_FILIAL AND SFA.D_E_L_E_T_ <> '*' AND FA_MOTIVO = ' ' AND FA_DATA >= '"+Dtos(MV_PAR01)+ "' AND FA_DATA <= '"+Dtos(MV_PAR02)+ "' AND FA_CODIGO = F9_CODIGO AND SF9.D_E_L_E_T_ <> '*' "

	TCQUERY _cQrySFA NEW ALIAS "TSFA "

	TCSETFIELD("TSFA","	FA_DATA" ,"D",08,0)

	Conout("Inicio: " + Time())

	If cEmpAnt=="11"
		_cForn := "070878"
		_cLoja := "01"
	Else
		If cFilAnt == "01"
			_cLoja := "01" // STECK MATRIZ
		ElseIf cFilAnt == "02"
			_cLoja := "02" // STECK FILIAL 02
		ElseIf cFilAnt == "03"
			_cLoja := "04" // STECK FILIAL 03
		ElseIf cFilAnt == "04"
			_cLoja := "03" // STECK FILIAL 04
		ElseIf cFilAnt == "05"
			_cLoja := "05" // STECK FILIAL 05
		EndIf
		_cForn := "005764" 
	EndIf

	If Empty(_cLoja)
		MsgAlert("Filial não Habilitada para emissão de Nota fiscal CIAP ","Atenção")
		Return
	EndIf

	cNum := NxtSX5Nota("001") //GetSxeNum("SF1","F1_DOC")

//Cabeçalho
	aadd(aCab,{"F1_TIPO" 	,"I" ,NIL})
	aadd(aCab,{"F1_FORMUL" 	,"S" ,NIL})
	aadd(aCab,{"F1_EMISSAO" ,DDATABASE ,NIL})
	aadd(aCab,{"F1_DTDIGIT" ,DDATABASE ,NIL})
	aadd(aCab,{"F1_FORNECE" ,_cForn ,NIL})
	aadd(aCab,{"F1_LOJA" 	,_cLoja ,NIL})
	aadd(aCab,{"F1_ESPECIE" ,"SPED" ,NIL})
	aadd(aCab,{"F1_COND" 	,"" ,NIL})
	aadd(aCab,{"F1_DESPESA" , 0 ,NIL})
	aadd(aCab,{"F1_DESCONT" , 0 ,Nil})
	aadd(aCab,{"F1_SEGURO" 	, 0 ,Nil})
	aadd(aCab,{"F1_FRETE" 	, 0 ,Nil})
	aadd(aCab,{"F1_MOEDA" 	, 1 ,Nil})
	aadd(aCab,{"F1_TXMOEDA" , 1 ,Nil})
	aadd(aCab,{"F1_STATUS" 	, "A" ,Nil})
	aadd(aCab,{"F1_DOC" 	,cNum ,NIL})
	aadd(aCab,{"F1_SERIE" 	,"001" ,NIL})

//Itens
	For nX := 1 To 1
		aItem := {}
		aadd(aItem,{"D1_ITEM" 	,StrZero(nX,4) ,NIL})
		aadd(aItem,{"D1_COD" 	,PadR("ATIVO CREDITO  ",TamSx3("D1_COD")[1]) ,NIL})
		aadd(aItem,{"D1_UM" 	,"UN" ,NIL})
		aadd(aItem,{"D1_LOCAL" 	,"01" ,NIL})
		aadd(aItem,{"D1_VUNIT" 	,TSFA->FA_VALOR ,NIL})
		aadd(aItem,{"D1_TOTAL" 	,TSFA->FA_VALOR ,NIL})
		aadd(aItem,{"D1_TES" 	,"067" ,NIL})
		aadd(aItem,{"D1_RATEIO" ,"2" ,NIL})
		aadd(aItem,{"D1_NFORI"  ,"000000000" ,NIL})
		aadd(aItem,{"D1_SERIORI"  ,"000" ,NIL})
		aAdd(aItens,aItem)

		//aadd(aItem,{"D1_QUANT" 	,0 ,NIL})

	Next nX

//3-Inclusão / 4-Classificação / 5-Exclusão
	MSExecAuto({|x,y,z,a,b| MATA103(x,y,z,,,,,a,,,b)},aCab,aItens,nOpc,aItensRat,aCodRet)

	If !lMsErroAuto
		ConOut(" Incluido NF: " + cNum)
		PutMv("ST_NFCIAP",_cMesAtu)
		MsgAlert("Nota Fiscal Gerada com Sucesso!! "+cNum,"Atenção")
	Else
		MostraErro()

		ConOut("Erro na inclusao!")
	EndIf

	ConOut("Fim: " + Time())

Return
