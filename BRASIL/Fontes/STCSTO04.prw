#include "TOTVS.CH"
#Include "Tbiconn.ch"
#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "FiveWin.ch"
#Include "Topconn.ch"
#Include "Colors.ch"
#include "Rwmake.CH"

#define BR Chr(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ STCSTO04 ³ Autor ³ Cristiano Pereira     ³ Data ³ 20/12/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Simulação do custo em partes                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³13/09/04³      ³ ACERTO ULTIMO PRECO DE COMPRA - RETIRADO ³±±
±±³            ³        ³      ³ PIS/COFINS                               ³±±
±±³            ³        ³      ³                                          ³±±
±±³            ³30/06/05³      ³ ACERTO EXPLOSAO DA ESTRUTURA INCLUIDO    ³±±
±±³            ³        ³      ³ FUNCAO ExplEstr(nQUANTPAI)*tempstru[a,4] ³±±
±±³            ³        ³      ³                                          ³±±
±±³            ³        ³      ³                                          ³±±
±±³            ³        ³      ³                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User function STCSTO04()


	local cLibQt
	local cCSS := ""
	public _cGrpDe  := Space(4),oGruDe
	public _cGrpAt  := Space(4),oGruAt
	public _cProdDe  := Space(15),oProDe
	public _cProdAt  := Space(15),oProAt
	private aComps	:= {"Analítico","Sintético"}
	private nObj  := 0



	// Captura versao da LIB do Qt no qual este SmartClient fon compilado
	GetRemoteType(@cLibQt)

	aScreenRes := getScreenRes()
	DEFINE DIALOG oDlg TITLE "Custo em partes" + cLibQt FROM 0,0 TO aScreenRes[2]-300,aScreenRes[1]-100 PIXEL


	DEFINE FONT oFont1 NAME "Arial" SIZE 0,-11 BOLD
	DEFINE FONT oFont2 NAME "Arial" SIZE 0,-14 BOLD
	DEFINE FONT oFont3 NAME "Arial" SIZE 0,-11 BOLD
	DEFINE FONT oFont5 NAME "Arial Black" SIZE 0,-25 BOLD



	spDiv := TSplitter():New( 01,01,oDlg,260,184,1) // Orientacao Vertical
	spDiv:setCSS("QSplitter::handle:vertical{background-color: #0080FF; height: 4px;}")
	spDiv:align := CONTROL_ALIGN_ALLCLIENT


	// Painel superior
	pnTop := TPanel():New(0,0,,spDiv,,,,,,60,60)

	@ 018,003   SAY OemToAnsi("Grupo De: ")   SIZE 060,010    OF  oDlg PIXEL FONT oFont2

	oGruDe := TGet():New( 18,55,{|u| If(PCount() ==0,_cGrpDe,_cGrpDe:=u)},pnTop, 50, 25,,, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,"SBM",,,,,,)
	//@ 018,055 Get _cGrpDe Object oSol When  .T. Size 050,50 Picture "@!"  F3 "SBD"

	cCSS +=	 BR+"QLineEdit {";
		+BR+"  color: #0F243E; /*Cor da fonte*/";
		+BR+"  font-size: 14px; /*Tamanho da fonte*/";
		+BR+"  min-height: 40px; /*Largura minima*/";
		+BR+"  border: 2px solid #17365D; /*Cor da borda*/";
		+BR+"  border-radius: 10px; /*Arredondamento da borda*/";
		+BR+"  padding: 0 8px; /*Especo (margem)*/";
		+BR+"  background: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1,";
		+BR+"                 stop: 0 #548DD4, stop: 1 #B8CCE4); /*Cor de fundo*/";
		+BR+"  selection-background-color: #E36C09; /*Cor de fundo quando selecionado*/";
		+BR+"}"

	oGruDe:SetCss(cCSS)


	@ 018,160  SAY OemToAnsi("Grupo Até: ")   SIZE 060,010    OF  oDlg PIXEL FONT oFont2

	oGruAt := TGet():New( 18,230,{|u| If(PCount()==0,_cGrpAt,_cGrpAt:=u)},pnTop, 50, 25,,, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,"SBM",,,,,,)
	//@ 018,055 Get _cGrpDe Object oSol When  .T. Size 050,50 Picture "@!"  F3 "SBD"

	cCSS +=	 BR+"QLineEdit {";
		+BR+"  color: #0F243E; /*Cor da fonte*/";
		+BR+"  font-size: 14px; /*Tamanho da fonte*/";
		+BR+"  min-height: 40px; /*Largura minima*/";
		+BR+"  border: 2px solid #17365D; /*Cor da borda*/";
		+BR+"  border-radius: 10px; /*Arredondamento da borda*/";
		+BR+"  padding: 0 8px; /*Especo (margem)*/";
		+BR+"  background: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1,";
		+BR+"                 stop: 0 #548DD4, stop: 1 #B8CCE4); /*Cor de fundo*/";
		+BR+"  selection-background-color: #E36C09; /*Cor de fundo quando selecionado*/";
		+BR+"}"

	oGruAt:SetCss(cCSS)


	@ 018,300  SAY OemToAnsi("Produto De: ")   SIZE 060,010    OF  oDlg PIXEL FONT oFont2

	oProDe:= TGet():New( 18,345,{|u| If(PCount()==0,_cProdDe,_cProdDe:=u)},pnTop, 80, 25,,, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,"SB1",,,,,,)
	//@ 018,055 Get _cGrpDe Object oSol When  .T. Size 050,50 Picture "@!"  F3 "SBD"

	cCSS +=	 BR+"QLineEdit {";
		+BR+"  color: #0F243E; /*Cor da fonte*/";
		+BR+"  font-size: 14px; /*Tamanho da fonte*/";
		+BR+"  min-height: 40px; /*Largura minima*/";
		+BR+"  border: 2px solid #17365D; /*Cor da borda*/";
		+BR+"  border-radius: 10px; /*Arredondamento da borda*/";
		+BR+"  padding: 0 8px; /*Especo (margem)*/";
		+BR+"  background: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1,";
		+BR+"                 stop: 0 #548DD4, stop: 1 #B8CCE4); /*Cor de fundo*/";
		+BR+"  selection-background-color: #E36C09; /*Cor de fundo quando selecionado*/";
		+BR+"}"

	oProDe:SetCss(cCSS)


	@ 018,435 SAY OemToAnsi("Produto Até: ")   SIZE 060,010    OF  oDlg PIXEL FONT oFont2

	oProAt:= TGet():New( 18,520,{|u| If(PCount()==0,_cProdAt,_cProdAt:=u)},pnTop, 80, 25,,, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,"SB1",,,,,,)
	//@ 018,055 Get _cGrpDe Object oSol When  .T. Size 050,50 Picture "@!"  F3 "SBD"

	cCSS +=	 BR+"QLineEdit {";
		+BR+"  color: #0F243E; /*Cor da fonte*/";
		+BR+"  font-size: 14px; /*Tamanho da fonte*/";
		+BR+"  min-height: 40px; /*Largura minima*/";
		+BR+"  border: 2px solid #17365D; /*Cor da borda*/";
		+BR+"  border-radius: 10px; /*Arredondamento da borda*/";
		+BR+"  padding: 0 8px; /*Especo (margem)*/";
		+BR+"  background: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1,";
		+BR+"                 stop: 0 #548DD4, stop: 1 #B8CCE4); /*Cor de fundo*/";
		+BR+"  selection-background-color: #E36C09; /*Cor de fundo quando selecionado*/";
		+BR+"}"

	oProAt:SetCss(cCSS)




	TSay():New(090,003,{||'Tipo:'},pnTop,,oFont2,,,,.T.,,,90,16)
	cbObj := TComboBox():New(90,55,{|u|If(PCount()==0,nObj,nObj:=u)},aComps,100, 010, pnTop,,{|o| .t.},, 0, 16777215,.T.,,,.F.,,.F.,,, ,"nObj" )

	cCSS +=	 BR+"QComboBox {";
		+BR+"  font-family:  Calibri,Lucida,Verdana; /*nome da fonte*/";
		+BR+"  font-size: 14pt; /*tamanho da fonte*/";
		+BR+"  border-radius: 6px; /*arredondamento da borda*/";
		+BR+"";
		+BR+"  /*cor de fundo*/";
		+BR+"  background: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1,stop: 0 #FDEADA, stop: 1 #FAC08F);";
		+BR+"  border: 1px solid #E36C09; /*borda*/";
		+BR+"  color: #974806; /*cor da fonte*/";
		+BR+"  padding: 1px; /*espacamento (margin)*/";
		+BR+"  min-height: 26px; /*altura minima*/";
		+BR+"}";
		+BR+"/*Itens da lista*/";
		+BR+"QComboBox QAbstractItemView {";
		+BR+"  border: 2px solid #974806; /*Borda do container de itens*/";
		+BR+"  /*Cor de fundo do item tambem aceita degrade*/";
		+BR+"  selection-background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1,stop: 0 #FDEADA, stop: 1 #FAC08F); ";
		+BR+"  height: 26px; /*Altura do item*/";
		+BR+"}";
		+BR+"/* Acoes ao pressionar o drop-down */ ";
		+BR+"QComboBox:on {";
		+BR+"   /*cor de fundo*/";
		+BR+"   background: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1,stop: 0 #FAC08F, stop: 1 #FDEADA);";
		+BR+"}";
		+BR+"/* Caracteristicas do botao drop-drown */";
		+BR+"QComboBox::drop-down {";
		+BR+"  width: 30px; /*largura*/";
		+BR+"  border: 1px solid #974806; /*borda*/";
		+BR+"  border-top-right-radius: 3px; /*arredondamento superior direito*/";
		+BR+"  border-bottom-right-radius: 3px; /*arredondamento inferior direito*/";
		+BR+"}";
		+BR+"/* Imagem do botao drop-down */";
		+BR+"QComboBox::down-arrow {";
		+BR+"  padding: 0px 5px 0px 5px; /*margem*/";
		+BR+"  image: url('C:/garbage/combo.png');  /*imagem do botao drop-down*/";
		+BR+"  width: 20px; /*largura*/";
		+BR+"  height: 20px; /*altura*/";
		+BR+"}"

	//cbObj:setCSS("QComboBox{font-size: 12px;}")
	cbObj:SetCss(cCSS)



	bProcess := TButton():New( 160, 120, "Simular", pnTop, {|| Processa({|lEnd| U_STCST04A()  },"Explodindo custo em partes, dos produtos","Aguarde enquanto o processamento é realizado...",.T.)}, 100, 025,,oFont2,.F.,.T.,.F.,,.F.,,,.F. )
	cCSS +=	 BR+"QPushButton {";
		+BR+"  color: #FFFFFF; /*Cor da fonte*/";
		+BR+"  border: 2px solid #494429; /*Cor da borda*/";
		+BR+"  border-radius: 6px; /*Arrerondamento da borda*/";
		+BR+"  background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1,";
		+BR+"                                    stop: 0 #804000, stop: 1 #FAC08F); /*Cor de fundo*/";
		+BR+"  min-width: 80px; /*Largura minima*/";
		+BR+"}";
		+BR+"/* Acoes quando pressionado botao, aqui mudo a cor de fundo */";
		+BR+"QPushButton:pressed {";
		+BR+"  background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1,";
		+BR+"                                    stop: 0 #FAC08F, stop: 1 #804000);";
		+BR+"}"


	bProcess:SetCss(cCSS)


	bProcess2 := TButton():New( 160, 380, "Sair", pnTop, {|| oDlg:End() }, 100, 025,,oFont2,.F.,.T.,.F.,,.F.,,,.F. )
	cCSS +=	 BR+"QPushButton {";
		+BR+"  color: #FFFFFF; /*Cor da fonte*/";
		+BR+"  border: 2px solid #494429; /*Cor da borda*/";
		+BR+"  border-radius: 6px; /*Arrerondamento da borda*/";
		+BR+"  background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1,";
		+BR+"                                    stop: 0 #804000, stop: 1 #FAC08F); /*Cor de fundo*/";
		+BR+"  min-width: 80px; /*Largura minima*/";
		+BR+"}";
		+BR+"/* Acoes quando pressionado botao, aqui mudo a cor de fundo */";
		+BR+"QPushButton:pressed {";
		+BR+"  background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1,";
		+BR+"                                    stop: 0 #FAC08F, stop: 1 #804000);";
		+BR+"}"


	bProcess2:SetCss(cCSS)
	oDlg:Activate()


return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ STCSTO04 ³ Autor ³ Cristiano Pereira     ³ Data ³ 20/12/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relacao Valorizada de estruturas                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³13/09/04³      ³ ACERTO ULTIMO PRECO DE COMPRA - RETIRADO ³±±
±±³            ³        ³      ³ PIS/COFINS                               ³±±
±±³            ³        ³      ³                                          ³±±
±±³            ³30/06/05³      ³ ACERTO EXPLOSAO DA ESTRUTURA INCLUIDO    ³±±
±±³            ³        ³      ³ FUNCAO ExplEstr(nQUANTPAI)*tempstru[a,4] ³±±
±±³            ³        ³      ³                                          ³±±
±±³            ³        ³      ³                                          ³±±
±±³            ³        ³      ³                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User function STCST04A()

	Local _nli,_nlic,_nl1
	Local _aEstru := {}
	Local _lCus := .f.
	Local  _cQryG1 := ""
	Local aDados    := {}
	Local  _nlMP    :=0
	Private _aMOD :={}
	Private _aCabec := {"PRODUTO","CUSTO PAI","CUSTO MP","DVC LABOR","DVC OTHERS","MBC DEPRECIATION", "MBC OTHERS","QUANTIDADE"}
	Private _cQry   := ""
	Private _cQuery := ""
	Private _cQryB9 := ""
	Private _nCusto := 0
	Private _nCustMP := 0
	Private _nCusBN  := 0
	Private _lProcess
	Private _lCuFech   := .T.
	Private _aMP     := {}
	Private _aTMZ    := {}
	Private _cPrdPai :=""
	Private _ldet    := .t.




	If Select("TG1") > 0
		DbSelectArea("TG1")
		DbCloSeArea()
	Endif

	If !Empty(_cProdAt)

		_cQryG1 := " SELECT	B1_FILIAL,B1_COD,G1_COD "
		_cQryG1 += " FROM "+RetSqlName("SB1")+" SB1 "
		_cQryG1 += " JOIN "+RetSqlName("SG1")+" SG1 "
		_cQryG1 += " ON	G1_FILIAL = '"+xFilial("SG1")+"' AND     "
		_cQryG1 += "	G1_COD   = B1_COD               AND     "
		_cQryG1 += " 	SG1.D_E_L_E_T_ <> '*'                    "
		_cQryG1 += " WHERE	B1_FILIAL = '"+xFilial("SB1")+"' AND "
		_cQryG1 += " 		B1_COD   >= '"+_cProdDe+"'  AND B1_COD   <= '"+_cProdAt+"' AND  RTRIM(B1_TIPO) IN ('PA')   AND             "

		If Rtrim(_cProdDe)<>Rtrim(_cProdAt)
		_cQryG1 += "        LTRIM(RTRIM(B1_XINFMP)) ='S'     AND    "
		Endif

		_cQryG1 += " 		SB1.D_E_L_E_T_ <> '*'                "

		_cQryG1 += " GROUP BY B1_FILIAL,B1_COD,G1_COD            "

		_cQryG1 += " ORDER BY G1_COD                             "

		TCQUERY  _cQryG1 NEW ALIAS "TG1"

	ElseIf !Empty(_cGrpAt)

		_cQryG1 := " SELECT	B1_FILIAL,B1_COD,G1_COD "
		_cQryG1 += " FROM "+RetSqlName("SB1")+" SB1 "
		_cQryG1 += " JOIN "+RetSqlName("SG1")+" SG1 "
		_cQryG1 += " ON	G1_FILIAL = '"+xFilial("SG1")+"' AND     "
		_cQryG1 += "	G1_COD   = B1_COD               AND     "
		_cQryG1 += " 	SG1.D_E_L_E_T_ <> '*'                    "
		_cQryG1 += " WHERE	B1_FILIAL = '"+xFilial("SB1")+"' AND "
		_cQryG1 += " 		B1_GRUPO   >= '"+_cGrpDe+"'  AND B1_GRUPO   <= '"+_cGrpAt+"'  AND             "
		_cQryG1 += "        LTRIM(RTRIM(B1_XINFMP)) ='S'     AND    "
		_cQryG1 += " 		SB1.D_E_L_E_T_ <> '*'                "
		_cQryG1 += " GROUP BY B1_FILIAL,B1_COD,G1_COD            "

		_cQryG1 += " ORDER BY G1_COD                             "

		TCQUERY  _cQryG1 NEW ALIAS "TG1"
	Endif

	_nRec := 0
	DbEval({|| _nRec++  })

	DbSelectArea("TG1")
	DbGotop()
	While !TG1->(EOF())

		_lProcess:= .T.

		If SB1->(dbSeek(xFilial("SB1")+TG1->G1_COD))
			u_STCS04B(@_aMOD,TG1->G1_COD,1)
		Endif

		MEplxPai(@_aEstru,TG1->G1_COD,TG1->B1_COD)

		TG1->(DbSkip())
	Enddo

	//##########################################
	//Montagem da estrutura
	//##########################################

	For _nli:=1 to len(_aMOD)

		_nCusto   := 0
		_nCustMP  := 0
		_nCusBN   := 0

		_aMP     := {}
		_aTMZ    := {}

			//##########################################
			//Montagem da estrutura
			//##########################################

			If Select("TZY") > 0
				DbSelectArea("TZY")
				DbCloSeArea()
			Endif

			_cQry := " SELECT ZRY.*                                                           "
			_cQry += " FROM "+RetSqlName("ZRY")+" ZRY                                         "
			_cQry += " WHERE ZRY.ZRY_FILIAL ='"+xFilial("ZRY")+"'                              AND "
			_cQry += "       ZRY.D_E_L_E_T_ <> '*'                                             AND "
			_cQry += "       SUBSTR(ZRY.ZRY_DATA,5,2) <= '"+ltrim(Rtrim(SubStr(Dtos(ddatabase),5,2)))+"'            AND "
			_cQry += "       SUBSTR(ZRY.ZRY_DATA,1,4)  <= '"+ltrim(Rtrim(SubStr(Dtos(ddatabase),1,4)))+"'            AND "
			_cQry += "       ZRY_CC   = '"+SubStr(_aMOD[_nli,1],4,6)+"'                           "
			_cQry += " ORDER BY ZRY.ZRY_DATA DESC     "

			TCQUERY _cQry NEW ALIAS "TZY"

			_nRec := 0
			DbEval({|| _nRec++  })


			DbSelecTArea("TZY")
			DbGotop()


		If _cPrdPai<>_aMOD[_nli,3]
			_ldet := .t.
			_cPrdPai := _aMOD[_nli,3]

			If _nli > 1
				AADD(aDados,{,,,,,,,})
			Endif
		Endif


		If _ldet  //Arranque do detalhamento somente 1 vez

			//Custo Pai
			For _nl1 := 1 to len(_aEstru)


				If  Rtrim(_aMOD[_nli,3]) == Rtrim(_aEstru[_nl1,1])

					DbSelectArea("SB1")
					DbSetOrder(1)
					If DbSeek(xFilial("SB1")+_aEstru[_nl1,1])

						If rtrim(SB1->B1_TIPO) $ "PA|PI"

							If Select("SD1TMP") > 0
								DbSelectArea("SD1TMP")
								DbCloSeArea()
							Endif


							_cQuery    := " "
							_cQuery    += " SELECT SUM(D1_CUSTO) AS CUSTO, SUM(D1_QUANT) AS QUANT "
							_cQuery    += " FROM "+RETSQLNAME("SD1")+" SD1 , "+RetSqlName("SF1")+" SF1 "
							_cQuery    += " WHERE SD1.D1_FILIAL  BETWEEN '  ' AND 'ZZ' "
							_cQuery    += " AND D1_DTDIGIT   <=  '"+dtos(ddatabase)+"' "
							_cQuery    += " AND SD1.D1_TIPO      = 'N'"
							_cQuery    += " AND SD1.D1_TES <> '   '   "
							_cQuery    += " AND SD1.D1_COD       = '"+_aEstru[_nl1,1]+"' "
							_cQuery    += " AND SD1.D_E_L_E_T_ = ' ' "
							_cQuery    += " AND SF1.F1_FILIAL = D1_FILIAL "
							_cQuery    += " AND SF1.F1_SERIE  = D1_SERIE  "
							_cQuery    += " AND SF1.F1_DOC    = D1_DOC    "
							_cQuery    += " AND SF1.F1_FORNECE = D1_FORNECE "
							_cQuery    += " AND SF1.F1_LOJA    = D1_LOJA    "
							_cQuery    += " AND SF1.F1_DUPL    = D1_DOC     "
							_cQuery    += " AND SD1.D1_CUSTO > 0            "
							_cQuery    += " AND SF1.D_E_L_E_T_ <> '*'       "
							_cQuery    += " AND SD1.R_E_C_N_O_ = ( SELECT MAX(SD.R_E_C_N_O_) FROM "+RetSqlName("SD1")+" SD, "+RetSqlName("SF4")+" F4 "+" WHERE  SD.D1_COD='"+_aEstru[_nl1,1]+"' AND SD.D1_CUSTO > 0 AND SD.D_E_L_E_T_ <> '*' AND SD.D1_DTDIGIT   <=  '"+dtos(ddatabase)+"' AND SD.D1_TIPO      = 'N'  AND  SD.D1_TES <> '   '  AND SD.D1_TES=F4.F4_CODIGO AND F4.D_E_L_E_T_<>'*' AND F4.F4_DUPLIC='S' ) "



							TCQUERY _cQuery NEW ALIAS "SD1TMP"

							TCSETFIELD("SD1TMP","D1_CUSTO"  ,"N",13,2)
							TCSETFIELD("SD1TMP","D1_QUANT"  ,"N",13,2)

							DbSelectArea("SD1TMP")
							DbGotop()


							If SD1TMP->QUANT>0
								_nCusto := SD1TMP->CUSTO/ SD1TMP->QUANT
							Else

								If Select("TB9")>0
									DbSelectArea("TB9")
									DbCloSeArea()
								Endif

								_cQryB9:= " SELECT SB9.B9_VINI1,SB9.B9_QINI,SB9.B9_CM1            "
								_cQryB9+= " FROM "+RetSqlName("SB9")+" SB9             "
								_cQryB9+= " WHERE SB9.D_E_L_E_T_ <> '*'                   AND  "
								_cQryB9+= "       SB9.B9_DATA <='"+dtos(ddatabase)+"'     AND  "
								_cQryB9+= "       SB9.B9_COD ='"+_aEstru[_nl1,1]+"'       AND  "
								_cQryB9+= "       SB9.B9_CM1 > 0                          AND "


								_cQryB9+= " SB9.R_E_C_N_O_ IN (   "

								_cQryB9+= "  SELECT MAX(R_E_C_N_O_) "
								_cQryB9+= " FROM "+RetSqlName("SB9")+" SB9             "
								_cQryB9+= "  WHERE SB9.D_E_L_E_T_ <> '*'           AND "
								_cQryB9+= "       SB9.B9_DATA <='"+dtos(ddatabase)+"' AND  "
								_cQryB9+= " SB9.B9_COD ='"+_aEstru[_nl1,1]+"'       AND "
								_cQryB9+= " SB9.B9_CM1 > 0  ) "

								TCQUERY _cQryB9 NEW ALIAS "TB9"

								_nRec := 0
								DbEval({|| _nRec++  })

								DbSelectArea("TB9")
								DbGotop()
								If _nRec > 0
									_nCusto := TB9->B9_CM1
								Endif
							Endif

						Endif
					Endif
				Endif

			Next _nl1


			For _nl1 := 1 to len(_aEstru)


				If  Rtrim(_aMOD[_nli,3]) == Rtrim(_aEstru[_nl1,1])

					DbSelectArea("SB1")
					DbSetOrder(1)
					If DbSeek(xFilial("SB1")+_aEstru[_nl1,2])

						If rtrim(SB1->B1_TIPO) $ "MP|ME|EM|IC|PI"


							DbSelectArea("SG1")
							DbSetOrder(1)
							If !DbSeek(xFilial("SG1")+_aEstru[_nl1,2])

								If Select("SD1TMP") > 0
									DbSelectArea("SD1TMP")
									DbCloSeArea()
								Endif

								_cQuery    := " "
								_cQuery    += " SELECT SUM(D1_CUSTO) AS CUSTO, SUM(D1_QUANT) AS QUANT "
								_cQuery    += " FROM "+RETSQLNAME("SD1")+" SD1 , "+RetSqlName("SF1")+" SF1 "
								_cQuery    += " WHERE SD1.D1_FILIAL  BETWEEN '  ' AND 'ZZ' "
								_cQuery    += " AND D1_DTDIGIT   <=  '"+dtos(ddatabase)+"' "
								_cQuery    += " AND SD1.D1_TIPO      = 'N'"
								_cQuery    += " AND SD1.D1_TES <> '   '   "
								_cQuery    += " AND SD1.D1_COD       = '"+_aEstru[_nl1,2]+"' "
								_cQuery    += " AND SD1.D_E_L_E_T_ = ' ' "
								_cQuery    += " AND SF1.F1_FILIAL = D1_FILIAL "
								_cQuery    += " AND SF1.F1_SERIE  = D1_SERIE  "
								_cQuery    += " AND SF1.F1_DOC    = D1_DOC    "
								_cQuery    += " AND SF1.F1_FORNECE = D1_FORNECE "
								_cQuery    += " AND SF1.F1_LOJA    = D1_LOJA    "
								_cQuery    += " AND SF1.F1_DUPL    = D1_DOC     "
								_cQuery    += " AND SD1.D1_CUSTO > 0            "
								_cQuery    += " AND SF1.D_E_L_E_T_ <> '*'       "
								_cQuery    += " AND SD1.R_E_C_N_O_ = ( SELECT MAX(SD.R_E_C_N_O_) FROM "+RetSqlName("SD1")+" SD, "+RetSqlName("SF4")+" F4 "+" WHERE  SD.D1_COD='"+_aEstru[_nl1,2]+"' AND SD.D1_CUSTO > 0 AND SD.D_E_L_E_T_ <> '*' AND SD.D1_DTDIGIT   <=  '"+dtos(ddatabase)+"' AND SD.D1_TIPO      = 'N'  AND  SD.D1_TES <> '   '  AND SD.D1_TES=F4.F4_CODIGO AND F4.D_E_L_E_T_<>'*' AND F4.F4_DUPLIC='S' ) "



								TCQUERY _cQuery NEW ALIAS "SD1TMP"

								TCSETFIELD("SD1TMP","D1_CUSTO"  ,"N",13,2)
								TCSETFIELD("SD1TMP","D1_QUANT"  ,"N",13,2)

								DbSelectArea("SD1TMP")
								DbGotop()


								If SD1TMP->QUANT>0 .And. !_lCuFech
									_nCustMP += (SD1TMP->CUSTO/ SD1TMP->QUANT)*_aEstru[_nl1,4]
									//Recarrega Filhos
									AADD(_aMP,{"",(SD1TMP->CUSTO/ SD1TMP->QUANT)*_aEstru[_nl1,4],_aEstru[_nl1,1],_aEstru[_nl1,2],2,_aEstru[_nl1,4]})
								Else

									If Select("TB9")>0
										DbSelectArea("TB9")
										DbCloSeArea()
									Endif

									_cQryB9:= " SELECT SB9.B9_VINI1,SB9.B9_QINI,SB9.B9_CM1           "
									_cQryB9+= " FROM "+RetSqlName("SB9")+" SB9             "
									_cQryB9+= " WHERE SB9.D_E_L_E_T_ <> '*'           AND  "
									_cQryB9+= "       SB9.B9_DATA <='"+dtos(ddatabase)+"' AND  "
									_cQryB9+= "       SB9.B9_COD ='"+_aEstru[_nl1,2]+"'       AND  "
									_cQryB9+= "       SB9.B9_CM1 > 0   AND "


									_cQryB9+= " SB9.R_E_C_N_O_ IN (   "

									_cQryB9+= "  SELECT MAX(R_E_C_N_O_) "
									_cQryB9+= " FROM "+RetSqlName("SB9")+" SB9             "
									_cQryB9+= "  WHERE SB9.D_E_L_E_T_ <> '*'           AND "
									_cQryB9+= "       SB9.B9_DATA <='"+dtos(ddatabase)+"' AND  "
									_cQryB9+= " SB9.B9_COD ='"+_aEstru[_nl1,2]+"'       AND "
									_cQryB9+= " SB9.B9_CM1 > 0  ) "

									TCQUERY _cQryB9 NEW ALIAS "TB9"

									_nRec := 0
									DbEval({|| _nRec++  })

									DbSelectArea("TB9")
									DbGotop()

									If _nRec > 0
										_nCustMP+= TB9->B9_CM1*_aEstru[_nl1,4]
										//Recarrega Filhos
										AADD(_aMP,{"",TB9->B9_CM1*_aEstru[_nl1,4],_aEstru[_nl1,1],_aEstru[_nl1,2],2,_aEstru[_nl1,4]})
									Endif
								Endif
							Endif
						Endif
					Endif

				Endif
			Next _nl1



			For _nl1 := 1 to len(_aEstru)


				If Rtrim(_aMOD[_nli,3]) == Rtrim(_aEstru[_nl1,1])

					DbSelectArea("SB1")
					DbSetOrder(1)
					If DbSeek(xFilial("SB1")+_aEstru[_nl1,2])

						If rtrim(SB1->B1_TIPO) $ "BN|"

							If Select("SD1TMP") > 0
								DbSelectArea("SD1TMP")
								DbCloSeArea()
							Endif

							_cQuery    := " "
							_cQuery    += " SELECT SUM(D1_CUSTO) AS CUSTO, SUM(D1_QUANT) AS QUANT "
							_cQuery    += " FROM "+RETSQLNAME("SD1")+" SD1 , "+RetSqlName("SF1")+" SF1 "
							_cQuery    += " WHERE SD1.D1_FILIAL  BETWEEN '  ' AND 'ZZ' "
							_cQuery    += " AND D1_DTDIGIT   <=  '"+dtos(ddatabase)+"' "
							_cQuery    += " AND SD1.D1_TIPO      = 'N'"
							_cQuery    += " AND SD1.D1_TES <> '   '   "
							_cQuery    += " AND SD1.D1_COD       = '"+_aEstru[_nl1,2]+"' "
							_cQuery    += " AND SD1.D_E_L_E_T_ = ' ' "
							_cQuery    += " AND SF1.F1_FILIAL = D1_FILIAL "
							_cQuery    += " AND SF1.F1_SERIE  = D1_SERIE  "
							_cQuery    += " AND SF1.F1_DOC    = D1_DOC    "
							_cQuery    += " AND SF1.F1_FORNECE = D1_FORNECE "
							_cQuery    += " AND SF1.F1_LOJA    = D1_LOJA    "
							_cQuery    += " AND SF1.F1_DUPL    = D1_DOC     "
							_cQuery    += " AND SD1.D1_CUSTO > 0            "
							_cQuery    += " AND SF1.D_E_L_E_T_ <> '*'       "
							_cQuery    += " AND SD1.R_E_C_N_O_ = ( SELECT MAX(SD.R_E_C_N_O_) FROM "+RetSqlName("SD1")+" SD, "+RetSqlName("SF4")+" F4 "+" WHERE  SD.D1_COD='"+_aEstru[_nl1,2]+"' AND SD.D1_CUSTO > 0 AND SD.D_E_L_E_T_ <> '*' AND SD.D1_DTDIGIT   <=  '"+dtos(ddatabase)+"' AND SD.D1_TIPO      = 'N'  AND  SD.D1_TES <> '   '  AND SD.D1_TES=F4.F4_CODIGO AND F4.D_E_L_E_T_<>'*' AND F4.F4_DUPLIC='S' ) "



							TCQUERY _cQuery NEW ALIAS "SD1TMP"

							TCSETFIELD("SD1TMP","D1_CUSTO"  ,"N",13,2)
							TCSETFIELD("SD1TMP","D1_QUANT"  ,"N",13,2)

							DbSelectArea("SD1TMP")
							DbGotop()


							If SD1TMP->QUANT>0 .And. !_lCuFech
								//_nCusBN += (SD1TMP->CUSTO/ SD1TMP->QUANT)*_aEstru[_nl1,4]
								_nCustMP +=(SD1TMP->CUSTO/ SD1TMP->QUANT)*_aEstru[_nl1,4]
								_nCusBN += 0
                                AADD(_aMP,{"",(SD1TMP->CUSTO/ SD1TMP->QUANT)*_aEstru[_nl1,4],_aEstru[_nl1,1],_aEstru[_nl1,2],2,_aEstru[_nl1,4]})
							Else

								If Select("TB9")>0
									DbSelectArea("TB9")
									DbCloSeArea()
								Endif

								_cQryB9:= " SELECT SB9.B9_VINI1,SB9.B9_QINI,SB9.B9_CM1           "
								_cQryB9+= " FROM "+RetSqlName("SB9")+" SB9             "
								_cQryB9+= " WHERE SB9.D_E_L_E_T_ <> '*'           AND  "
								_cQryB9+= "       SB9.B9_DATA <='"+dtos(ddatabase)+"'     AND  "
								_cQryB9+= "       SB9.B9_COD ='"+_aEstru[_nl1,2]+"'       AND  "
								_cQryB9+= "       SB9.B9_CM1 > 0                          AND "


								_cQryB9+= " SB9.R_E_C_N_O_ IN (   "

								_cQryB9+= "  SELECT MAX(R_E_C_N_O_) "
								_cQryB9+= " FROM "+RetSqlName("SB9")+" SB9             "
								_cQryB9+= "  WHERE SB9.D_E_L_E_T_ <> '*'              AND "
								_cQryB9+= "       SB9.B9_DATA <='"+dtos(ddatabase)+"' AND  "
								_cQryB9+= " SB9.B9_COD ='"+_aEstru[_nl1,2]+"'         AND "
								_cQryB9+= " SB9.B9_CM1 > 0  ) "

								TCQUERY _cQryB9 NEW ALIAS "TB9"

								_nRec := 0
								DbEval({|| _nRec++  })

								DbSelectArea("TB9")
								DbGotop()
								If _nRec > 0
									//_nCusBN+= (TB9->B9_VINI1/TB9->B9_QINI)*_aEstru[_nl1,4]
									_nCustMP +=TB9->B9_CM1*_aEstru[_nl1,4]
									_nCusBN += 0
                                    AADD(_aMP,{"",TB9->B9_CM1*_aEstru[_nl1,4],_aEstru[_nl1,1],_aEstru[_nl1,2],2,_aEstru[_nl1,4]})
								Endif
							Endif
						Endif
					Endif

				Endif
			Next _nl1
		Endif


		If SubStr(nObj,1,1)<>"A"
			_lCus := .F.

			For _nlic:=1 to len(aDados)


				If Rtrim(aDados[_nlic,1]) ==RTrim(_aMOD[_nli,3])

					_lCus := .T.
					aDados[_nlic,2]+=_nCusto
					aDados[_nlic,3]+=_nCustMP
					aDados[_nlic,4]+=_aMOD[_nli,2]*TZY->ZRY_DVLA
					aDados[_nlic,5]+=_aMOD[_nli,2]*TZY->ZRY_DVOT
					aDados[_nlic,6]+=_aMOD[_nli,2]*TZY->ZRY_MBDEPR
					aDados[_nlic,7]+=_aMOD[_nli,2]*TZY->ZRY_MBOT
					aDados[_nlic,8]+=0

				Endif

			Next _nlic

			If !_lCus
                 
				AADD(aDados,{_aMOD[_nli,3],_nCusto,_nCustMP,_aMOD[_nli,2]*TZY->ZRY_DVLA,_aMOD[_nli,2]*TZY->ZRY_DVOT,_aMOD[_nli,2]*TZY->ZRY_MBDEPR,_aMOD[_nli,2]*TZY->ZRY_MBOT,0})


				For _nlMP:=1 to len(_aMP)
					If _aMP[_nlMP,3]==_aMOD[_nli,3]
						AADD(aDados,{_aMP[_nlMP,4],0,_aMP[_nlMP,2],0,0,0,0,_aMP[_nlMP,6]})
					Endif
				Next _nlMP


				AADD(aDados,{_aMOD[_nli,1],0,0,_aMOD[_nli,2]*TZY->ZRY_DVLA,_aMOD[_nli,2]*TZY->ZRY_DVOT,_aMOD[_nli,2]*TZY->ZRY_MBDEPR,_aMOD[_nli,2]*TZY->ZRY_MBOT,_aMOD[_nli,2]})



				//_aTMZ := u_STCS04Z(_aMOD[_nli,3],1)

				//For _nlMP:=1 to len(_aTMZ)
				//	AADD(aDados,{_aTMZ[_nlMP,1],0,_aTMZ[_nlMP,2],0,0,0,0,0,0})
				//Next _nlMP

			else
				AADD(aDados,{_aMOD[_nli,1],0,0,_aMOD[_nli,2]*TZY->ZRY_DVLA,_aMOD[_nli,2]*TZY->ZRY_DVOT,_aMOD[_nli,2]*TZY->ZRY_MBDEPR,_aMOD[_nli,2]*TZY->ZRY_MBOT,_aMOD[_nli,2]})
			Endif
		else

			_lCus := .F.

			For _nlic:=1 to len(aDados)


				If aDados[_nlic,1]== _aMOD[_nli,3]

					_lCus := .T.
					aDados[_nlic,2]+=_nCusto
					aDados[_nlic,3]+=_nCustMP
					aDados[_nlic,4]+=_aMOD[_nli,2]*TZY->ZRY_DVLA
					aDados[_nlic,5]+=_aMOD[_nli,2]*TZY->ZRY_DVOT
					aDados[_nlic,6]+=_aMOD[_nli,2]*TZY->ZRY_MBDEPR
					aDados[_nlic,7]+=_aMOD[_nli,2]*TZY->ZRY_MBOT
					aDados[_nlic,8]+=0
				Endif

			Next _nlic

			If !_lCus
				AADD(aDados,{_aMOD[_nli,3],_nCusto,_nCustMP,_aMOD[_nli,2]*TZY->ZRY_DVLA,_aMOD[_nli,2]*TZY->ZRY_DVOT,_aMOD[_nli,2]*TZY->ZRY_MBDEPR,_aMOD[_nli,2]*TZY->ZRY_MBOT,0})
			Endif

			If _ldet
				For _nlMP:=1 to len(_aMP)
					If _aMP[_nlMP,3]==_aMOD[_nli,3]
						AADD(aDados,{_aMP[_nlMP,4],0,_aMP[_nlMP,2],0,0,0,0,_aMP[_nlMP,6]})
					Endif
				Next _nlMP

			Endif

			AADD(aDados,{_aMOD[_nli,1],0,0,_aMOD[_nli,2]*TZY->ZRY_DVLA,_aMOD[_nli,2]*TZY->ZRY_DVOT,_aMOD[_nli,2]*TZY->ZRY_MBDEPR,_aMOD[_nli,2]*TZY->ZRY_MBOT,_aMOD[_nli,2]})

			If _ldet

				//_aTMZ := u_STCS04Z(_aMOD[_nli,3],1)
				//For _nlMP:=1 to len(_aTMZ)
				//	AADD(aDados,{_aTMZ[_nlMP,1],0,_aTMZ[_nlMP,2],0,0,0,0,0,0})
				//Next _nlMP
				_ldet := .F.
			Endif
		Endif

	Next _nli




	if Len(aDados) > 0
		FWMsgRun(,{|| ExpotMsExcel(_aCabec,aDados) },,"Aguarde, montando planilha")
	Endif


return




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MR400Stru³ Autor ³ Ricardo Berti         ³ Data ³17/05/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Explode os niveis da Estrutura de Baixo para Cima          ³±±
±±³          ³                                                       	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ MR400Stru(ExpO1,ExpC1)	                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpO1 = obj report   		                              ³±±
±±³          ³ ExpC1 = Cod. do produto 		                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum				 		                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR400.PRX (R4)                                    		  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

Static Function MEplxPai(_aEstru,cProduto,_cMMP)


	Local aAreaAtu := GetArea()
	Local aAreaSG1 := SG1->(GetArea())
	Local aAreaSB1 := SB1->(GetArea())
	Local i

	nEstru := 0
	aEstru := {}
	aEstru := Estrut(cProduto,1)

	If !(aEstru[1,5]=="000")
		aEstru := aSort(aEstru,,,{|x,y| x[5] < y[5] .And.  x[1] < y[1]  })
	Endif

	For i := 1 to len(aEstru)

		If  _lProcess
			DbSelectArea("SG1")
			DbSetOrder(1)
			If DbSeek(xFilial("SG1")+aEstru[i,2]+aEstru[i,3])
				If  (dDataBase >= SG1->G1_INI .And. dDataBase <= SG1->G1_FIM)
					DbSelectArea("SB1")
					DbSetOrder(1)
					If DbSeek(xFilial("SB1")+aEstru[i,2]) .And. SB1->B1_TIPO=="PA"
						DbSelectArea("SB1")
						DbSetOrder(1)
						If  i=1
							AADD(_aEstru,{cProduto,aEstru[i,3],aEstru[i,5],SG1->G1_QUANT,aEstru[i,3],"Pai"})
						ElseIf DbSeek(xFilial("SB1")+aEstru[i,3])
							DbSelectArea("SG1")
							DbSetOrder(1)
							If !DbSeek(xFilial("SG1")+aEstru[i,3])
								If aEstru[i,1]==1
									DbSelectArea("SG1")
									DbSetOrder(1)
									If DbSeek(xFilial("SG1")+aEstru[i,2]+aEstru[i,3])
										AADD(_aEstru,{cProduto,aEstru[i,3],aEstru[i,5],SG1->G1_QUANT,aEstru[i,3],"Filhos"})
									Endif
								Else
									AADD(_aEstru,{cProduto,aEstru[i,3],aEstru[i,5],aEstru[i,4],aEstru[i,3],"Filhos"})
								Endif
							Endif
						Endif
					Else
						If  i=1
							AADD(_aEstru,{cProduto,aEstru[i,3],aEstru[i,5],SG1->G1_QUANT,aEstru[i,3],"Pai"})
						Else

							DbSelectArea("SG1")
							DbSetOrder(1)
							If !DbSeek(xFilial("SG1")+aEstru[i,3])

								DbSelectArea("SB1")
								DbSetOrder(1)
								If DbSeek(xFilial("SB1")+aEstru[i,3])
									If aEstru[i,1]==1
										DbSelectArea("SG1")
										DbSetOrder(1)
										If DbSeek(xFilial("SG1")+aEstru[i,2]+aEstru[i,3])
											AADD(_aEstru,{cProduto,aEstru[i,3],aEstru[i,5],SG1->G1_QUANT,aEstru[i,3],"Filhos"})
										Endif
									Else
										AADD(_aEstru,{cProduto,aEstru[i,3],aEstru[i,5],aEstru[i,4],aEstru[i,3],"Filhos"})
									Endif
								Endif
							Endif
						Endif

					Endif
				Else
					If  i=1
						AADD(_aEstru,{cProduto,aEstru[i,3],aEstru[i,5],SG1->G1_QUANT,aEstru[i,3],"Pai"})
					Endif
				Endif
			Endif
		Endif
	Next i

	_lProcess := .F.
	RestArea(aAreaSB1)
	RestArea(aAreaSG1)
	RestArea(aAreaAtu)

Return Nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ STCS04B³ Autor ³ Ricardo Berti         ³ Data ³17/05/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Explode Custo da MOD                                       ³±±
±±³          ³                                                       	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ MR400Stru(ExpO1,ExpC1)	                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpO1 = obj report   		                              ³±±
±±³          ³ ExpC1 = Cod. do produto 		                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum				 		                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR400.PRX (R4)                                    		  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

User Function STCS04B(_aMOD,cProduto,_nQtd)

	Local cRoteiro  :=" "
	Local nQuant    := 1
	Local _nMvpar07 := 1
	Local aAreaSG2    :=SG2->(GetArea())
	Local aAreaSB1    :=SB1->(GetArea())
	Local aAreaSH1    :=SH1->(GetArea())
	Local i,_lgrava:= .t.
	Local nTmpMAO     := 0
	Local _nlin
	Local _c1VezRot   := ""
	Local _lEntra     := .T.
	Local _nlOp       :=0
	PRIVATE cTipoTemp	:=SuperGetMV("MV_TPHR")
	nEstru := 0
	_aAux := {}
	_aAux := Estrut(cProduto,1)
	_aOper := {}



	For _nlin:=1 to len(_aAux)

        If SubStr(Rtrim(_c1VezRot),1,5) <> SubStr(Rtrim(_aAux[_nlin,2]),1,5) .Or.;
		   SubStr(Rtrim(_c1VezRot),6,5) <> SubStr(Rtrim(_aAux[_nlin,2]),6,5) .Or.;
           SubStr(Rtrim(_c1VezRot),11,5) <> SubStr(Rtrim(_aAux[_nlin,2]),11,5)
	        _c1VezRot := _aAux[_nlin,2]
			_lEntra:= .t.

            
			For _nlOp:=1 to len(_aOper)
                 If _aOper[_nlOp,1]== _aAux[_nlin,2]
                     	_lEntra:= .f.
				 Endif
			Next _aOper

			If _lEntra
                  AADD(_aOper,{_aAux[_nlin,2]})
			Endif

		else
		    _lEntra:= .f.
		Endif

		dbSelectArea("SB1")
		dbSetOrder(1)
		If MsSeek(xFilial("SB1")+_aAux[_nlin,2])  .And. _lEntra

			cRoteiro:=SB1->B1_OPERPAD
	

			dbSelectArea("SG2")
			dbSetOrder(1)
			MsSeek(xFilial("SG2")+_aAux[_nlin,2]+If(Empty(cRoteiro),"01",cRoteiro))
			While !Eof() .And.	xFilial("SG2")+_aAux[_nlin,2]+If(Empty(cRoteiro),"01",cRoteiro) == G2_FILIAL+G2_PRODUTO+G2_CODIGO

				_lgrava:= .t.

                If _nlin==1
                nQuant := 1//_aAux[_nlin,4]
				Else
				nQuant := _aAux[_nlin-1,4]
                Endif
				dbSelectArea("SH1")
				dbSetorder(1)
				If MsSeek(xFilial("SH1")+SG2->G2_RECURSO)
					// Calcula Tempo de Dura  o baseado no Tipo de Operacao
					If SG2->G2_TPOPER $ " 1"
						// Valdemir Rabelo 13/05/2020
						if (cEmpAnt=="03") .and. (!EMPTY(SG2->G2_TPALOCF)) .and. SG2->G2_OPERAC=='10'
							nTmpMAO :=  (SG2->G2_TEMPAD / SG2->G2_LOTEPAD)
						endif
						nTemp := (nQuant * ( If(_nMvpar07  == 3,A690HoraCt(SG2->G2_SETUP) / IIf( SG2->G2_LOTEPAD == 0, 1, SG2->G2_LOTEPAD ), 0) + IIf( SG2->G2_TEMPAD == 0, 1,A690HoraCt(SG2->G2_TEMPAD)) / IIf( SG2->G2_LOTEPAD == 0, 1, SG2->G2_LOTEPAD ))+If(_nMvpar07 == 2, A690HoraCt(SG2->G2_SETUP), 0) )
						If SH1->H1_MAOOBRA # 0
							nTemp := nTemp / SH1->H1_MAOOBRA
						EndIf

					ElseIf SG2->G2_TPOPER == "4"
						nQuantAloc:=nQuant % IIf(SG2->G2_LOTEPAD == 0, 1, SG2->G2_LOTEPAD)
						nQuantAloc:=Int(nQuant)+If(nQuantAloc>0,IIf(SG2->G2_LOTEPAD == 0, 1, SG2->G2_LOTEPAD)-nQuantAloc,0)
						nTemp := nQuantAloc * ( IIf( SG2->G2_TEMPAD == 0, 1,A690HoraCt(SG2->G2_TEMPAD)) / IIf( SG2->G2_LOTEPAD == 0, 1, SG2->G2_LOTEPAD ) )
						If SH1->H1_MAOOBRA # 0
							nTemp := nTemp / SH1->H1_MAOOBRA
						EndIf
					ElseIf SG2->G2_TPOPER == "2" .Or. SG2->G2_TPOPER == "3"
						nTemp := IIf( SG2->G2_TEMPAD == 0 , 1 ,A690HoraCt(SG2->G2_TEMPAD) )
					EndIf
					cProdMod:=APrModRec(SH1->H1_CODIGO)
					// Valdemir Rabelo 13/05/2020
					if (cEmpAnt=="03") .and. ("120108" $ cProdMod) .and. (nTmpMAO > 0)
						nTemp := nTmpMAO
					endif
                   
					If ValType(_nQtd)<>"N"
						nTemp:=Round(nTemp*If(Empty(SG2->G2_MAOOBRA),1,SG2->G2_MAOOBRA),5)
					Else
						nTemp:=Round(_nQtd*nTemp*If(Empty(SG2->G2_MAOOBRA),1,SG2->G2_MAOOBRA),5)

					Endif

                    
					For i:= 1 to len(_aMOD)
						If  RTrim(_aMOD[i,1])==RTrim("MOD"+SH1->H1_CCUSTO) .And. Rtrim(cProduto)==RtRim(_aMOD[i,3])
							_lgrava:= .f.
							//_aMOD[i,2]+=nTemp*_aAux[_nlin,4]
							_aMOD[i,2]+=nTemp
						Endif
					Next i

					If _lgrava
						//AADD(_aMOD,{"MOD"+SH1->H1_CCUSTO,nTemp*_aAux[_nlin,4],cProduto,"",1})
						AADD(_aMOD,{"MOD"+SH1->H1_CCUSTO,nTemp,cProduto,"",1})
					Endif

				EndIf
				nTmpMAO := 0
				dbSelectArea("SG2")
				dbSkip()
			End
		EndIf

	Next _nlin


	RestArea(aAreaSG2)
	RestArea(aAreaSB1)
	RestArea(aAreaSH1)


return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ STCS04Z³ Autor ³ Ricardo Berti         ³ Data ³17/05/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Explode Custo da MOD                                       ³±±
±±³          ³                                                       	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ MR400Stru(ExpO1,ExpC1)	                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpO1 = obj report   		                              ³±±
±±³          ³ ExpC1 = Cod. do produto 		                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum				 		                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR400.PRX (R4)                                    		  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

User Function STCS04Z(cProduto,_nQtd)

	Local cRoteiro  :=" "
	Local nQuant    := 1
	Local _nMvpar07 := 1
	Local aAreaSG2    :=SG2->(GetArea())
	Local aAreaSB1    :=SB1->(GetArea())
	Local aAreaSH1    :=SH1->(GetArea())
	Local i,_lgrava:= .t.
	Local nTmpMAO     := 0
	PRIVATE cTipoTemp	:=SuperGetMV("MV_TPHR")
	nEstru := 0
	_aAux := {}
	_aAux := Estrut(cProduto)
	_aTMP:={}


	dbSelectArea("SB1")
	dbSetOrder(1)
	If MsSeek(xFilial("SB1")+cProduto)

		cRoteiro:=SB1->B1_OPERPAD

		dbSelectArea("SG2")
		dbSetOrder(1)
		MsSeek(xFilial("SG2")+cProduto+If(Empty(cRoteiro),"01",cRoteiro))
		While !Eof() .And.	xFilial("SG2")+cProduto+If(Empty(cRoteiro),"01",cRoteiro) == G2_FILIAL+G2_PRODUTO+G2_CODIGO

			_lgrava:= .t.

			dbSelectArea("SH1")
			dbSetorder(1)
			If MsSeek(xFilial("SH1")+SG2->G2_RECURSO)
				// Calcula Tempo de Dura  o baseado no Tipo de Operacao
				If SG2->G2_TPOPER $ " 1"
					// Valdemir Rabelo 13/05/2020
					if (cEmpAnt=="03") .and. (!EMPTY(SG2->G2_TPALOCF)) .and. SG2->G2_OPERAC=='10'
						nTmpMAO :=  (SG2->G2_TEMPAD / SG2->G2_LOTEPAD)
					endif
					nTemp := (nQuant * ( If(_nMvpar07  == 3,A690HoraCt(SG2->G2_SETUP) / IIf( SG2->G2_LOTEPAD == 0, 1, SG2->G2_LOTEPAD ), 0) + IIf( SG2->G2_TEMPAD == 0, 1,A690HoraCt(SG2->G2_TEMPAD)) / IIf( SG2->G2_LOTEPAD == 0, 1, SG2->G2_LOTEPAD ))+If(_nMvpar07 == 2, A690HoraCt(SG2->G2_SETUP), 0) )
					If SH1->H1_MAOOBRA # 0
						nTemp := nTemp / SH1->H1_MAOOBRA
					EndIf

				ElseIf SG2->G2_TPOPER == "4"
					nQuantAloc:=nQuant % IIf(SG2->G2_LOTEPAD == 0, 1, SG2->G2_LOTEPAD)
					nQuantAloc:=Int(nQuant)+If(nQuantAloc>0,IIf(SG2->G2_LOTEPAD == 0, 1, SG2->G2_LOTEPAD)-nQuantAloc,0)
					nTemp := nQuantAloc * ( IIf( SG2->G2_TEMPAD == 0, 1,A690HoraCt(SG2->G2_TEMPAD)) / IIf( SG2->G2_LOTEPAD == 0, 1, SG2->G2_LOTEPAD ) )
					If SH1->H1_MAOOBRA # 0
						nTemp := nTemp / SH1->H1_MAOOBRA
					EndIf
				ElseIf SG2->G2_TPOPER == "2" .Or. SG2->G2_TPOPER == "3"
					nTemp := IIf( SG2->G2_TEMPAD == 0 , 1 ,A690HoraCt(SG2->G2_TEMPAD) )
				EndIf
				cProdMod:=APrModRec(SH1->H1_CODIGO)
				// Valdemir Rabelo 13/05/2020
				if (cEmpAnt=="03") .and. ("120108" $ cProdMod) .and. (nTmpMAO > 0)
					nTemp := nTmpMAO
				endif

				If ValType(_nQtd)<>"N"
					nTemp:=Round(nTemp*If(Empty(SG2->G2_MAOOBRA),1,SG2->G2_MAOOBRA),5)
				Else
					nTemp:=Round(_nQtd*nTemp*If(Empty(SG2->G2_MAOOBRA),1,SG2->G2_MAOOBRA),5)
				Endif


				For i:= 1 to len(_aTMP)
					If  RTrim(_aTMP[i,1])==RTrim(SG2->G2_RECURSO)
						_lgrava:= .F.
						_aTMP[i,2]+=nTemp
					Endif
				Next i

				If _lgrava
					AADD(_aTMP,{SG2->G2_RECURSO,(SG2->G2_TEMPAD / SG2->G2_LOTEPAD),cProduto,"",1})
				Endif

			EndIf
			nTmpMAO := 0
			dbSelectArea("SG2")
			dbSkip()
		End
	EndIf


	RestArea(aAreaSG2)
	RestArea(aAreaSB1)
	RestArea(aAreaSH1)


return(_aTMP)




// ---------+-------------------+--------------------------------------------------
// Projeto  : IF DO BRASIL
// Autor    : Valdemir Rabelo - SIGAMAT
// Modulo   : SIGAGPE
// Função   : ExpotMsExcel
// Descrição: Gera Planilha Excel.
// Retorno  : Nenhum.
// ---------+-------------------+--------------------------------------------------
// Data     | Autor             | Descricao
// ---------+-------------------+--------------------------------------------------
// 19/03/20 | Valdemir Rabelo   | Desenvolvimento da rotina.
// ---------+-------------------+--------------------------------------------------
Static Function ExpotMsExcel(paCabec1, paItens1)

	Local cArq       := ""
	Local cDirTmp    := GetTempPath()
	Local cWorkSheet := ""
	Local nC
	Local nL
	Local cTable     := "SIMULAÇÃO CUSTO EM PARTES"
	Local oFwMsEx    := FWMsExcel():New()
	Private aAlgn := {1,1,1,1,,1,1,1,1}      // Alinhamento da coluna ( 1-Left,2-Center,3-Right )
	Private aForm := {1,1,1,1,1,1,2,2}      // Codigo de formatação ( 1-General,2-Number,3-Monetário,4-DateTime )

	cWorkSheet := "Registros Gerados"

	oFwMsEx:AddWorkSheet( cWorkSheet )
	oFwMsEx:SetTitleSizeFont(8)
	oFwMsEx:AddTable( cWorkSheet, cTable )

	oFwMsEx:SetTitleBold(.T.)

	For nC := 1 to Len(paCabec1)
		oFwMsEx:AddColumn( cWorkSheet, cTable , paCabec1[nC] , aAlgn[nC], aForm[nC] )
	Next

	For nL := 1 to Len(paItens1)
		oFwMsEx:AddRow(cWorkSheet,cTable, paItens1[nL] )
	Next

	oFwMsEx:Activate()

	cArq := CriaTrab( NIL, .F. ) + ".xml"

	LjMsgRun( "Gerando Planilha, aguarde...", cTable, {|| oFwMsEx:GetXMLFile( cArq ) } )

	If __CopyFile( cArq, cDirTmp + cArq )
		IncProc("Carregando planilha")
		oExcelApp := MsExcel():New()
		oExcelApp:WorkBooks:Open( cDirTmp + cArq )
		oExcelApp:SetVisible(.T.)
		oExcelApp:Destroy()
	Else
		MsgInfo( "Arquivo não copiado para o diretório dos arquivos temporários do usuário." )
	Endif

Return


