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
±±³Fun‡…o    ³ STCSTO01 ³ Autor ³ Cristiano Pereira     ³ Data ³ 20/12/03 ³±±
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
User function STCSTO01()


	local cLibQt
	local cCSS := ""
	public _cGrpDe  := Space(4),oGruDe
	public _cGrpAt  := Space(4),oGruAt
	public _cProdDe  := Space(15),oProDe
	public _cProdAt  := Space(15),oProAt
	public _dRedDe   := Ctod(Space(8)),oRefDe
	public _dRedAt   := Ctod(Space(8)),oRefAt
	public _cModRef  := Ctod(Space(8)),oModRef
	public _cMP      := Space(15),oMP
	private aComps	:= {"Analítico","Sintético"}
	private aPart	:= {"Sim","Não"}
	private aFiltr	:= {"Sim","Não"}
	private nObj  := 0
	private nPart := 0
	private cFitr
	private nFitr
	nPart :="Não"

	/*
    private aMainBrowse := { {.T.,'CLIENTE 001','RUA CLIENTE 001',111.11},;
                         {.F.,'CLIENTE 002','RUA CLIENTE 002',222.22},;
                         {.T.,'CLIENTE 003','RUA CLIENTE 003',333.33} }*/


// Captura versao da LIB do Qt no qual este SmartClient fon compilado
	GetRemoteType(@cLibQt)

	aScreenRes := getScreenRes()
	DEFINE DIALOG oDlg TITLE "Simulação do custo com base no preço de compra MP " + cLibQt FROM 0,0 TO aScreenRes[2]-350,aScreenRes[1]-150 PIXEL
 

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
   
    oGruDe := TGet():New( 18,55,{|u| If(PCount()==0,_cGrpDe,_cGrpDe:=u)},pnTop, 50, 25,,, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,"SBM",,,,,,)
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

	oProAt:= TGet():New( 18,495,{|u| If(PCount()==0,_cProdAt,_cProdAt:=u)},pnTop, 80, 25,,, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,"SB1",,,,,,)
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



	 @ 054,003   SAY OemToAnsi("Ref. Anterior: ")   SIZE 060,010    OF  oDlg PIXEL FONT oFont2
   
    oRefDe := TGet():New( 54,55,{|u| If(PCount()==0,_dRedDe,_dRedDe:=u)},pnTop, 60, 25,,, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,"SBM",,,,,,)
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

	 oRefDe:SetCss(cCSS)


    
	@ 054,160   SAY OemToAnsi("Ref. Atual: ")   SIZE 060,010    OF  oDlg PIXEL FONT oFont2
   
    oRefAt := TGet():New( 54,230,{|u| If(PCount()==0,_dRedAt,_dRedAt:=u)},pnTop, 60, 25,,, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,,,,,,)
	
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

	 oRefAt:SetCss(cCSS)



	@ 054,300  SAY OemToAnsi("Ref MOD: ")   SIZE 060,010    OF  oDlg PIXEL FONT oFont2

	oModRef:= TGet():New( 54,345,{|u| If(PCount()==0,_cModRef,_cModRef:=u)},pnTop, 60, 25,,, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,,,,,,)
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

	 oModRef:SetCss(cCSS)



	 @ 054,435 SAY OemToAnsi("Matéria Prima: ")   SIZE 060,010    OF  oDlg PIXEL FONT oFont2

	oMP:= TGet():New( 54,495,{|u| If(PCount()==0,_cMP,_cMP:=u)},pnTop, 80, 25,,, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,"SB1",,,,,,)
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

	 oMP:SetCss(cCSS)


	TSay():New(90,003,{||'Tipo:'},pnTop,,oFont2,,,,.T.,,,90,16)
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


	TSay():New(90,420,{||'Particiona Processamento MP:'},pnTop,,oFont2,,,,.T.,,,90,16)
	cPart := TComboBox():New(90,495,{|u|If(PCount()==0,nPart,nPart:=u)},aPart,100, 010, pnTop,,{|o| .T.},,0, 16777215,.T.,,,.F.,,.F.,,, ,"cPart" )
    cPart:disable()
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
	cPart:SetCss(cCSS)

   

   TSay():New(130,420,{||'Filtra pelo produto:'},pnTop,,oFont2,,,,.T.,,,90,16)
	cFitr := TComboBox():New(130,495,{|u|If(PCount()==0,nFitr,nFitr:=u)},aFiltr,100, 010, pnTop,,{|o| .t.},, 0, 16777215,.T.,,,.F.,,.F.,,, ,"cFitr" )

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
	cFitr:SetCss(cCSS)

 

    bProcess := TButton():New( 160, 380, "Processar Sem Arquivo", pnTop, {|| Processa({|lEnd| U_STCST01A()  },"Explosão da Estrutura arquivo","Simulação custo matéria prima",.T.)}, 100, 025,,oFont2,.F.,.T.,.F.,,.F.,,,.F. )
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


	bProcess1 := TButton():New( 126, 0230, "Processar com Arquivo MP", pnTop, {|| U_STCST01W()}, 100, 025,,oFont2,.F.,.T.,.F.,,.F.,,,.F. )
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


    bProcess1:SetCss(cCSS)


	bProcess1 := TButton():New( 160, 0230, "Processar com Arquivo PA", pnTop, {|| U_STCST01Y()}, 100, 025,,oFont2,.F.,.T.,.F.,,.F.,,,.F. )
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


    bProcess1:SetCss(cCSS)


    bProcess2 := TButton():New( 160, 0070, "Sair", pnTop, {|| oDlg:End() }, 100, 025,,oFont2,.F.,.T.,.F.,,.F.,,,.F. )
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
	



    // Sppliter ocupara toda tela
	
	/*	spDiv := TSplitter():New( 01,01,oDlg,260,184,1) // Orientacao Vertical
		spDiv:setCSS("QSplitter::handle:vertical{background-color: #0080FF; height: 4px;}")
		spDiv:align := CONTROL_ALIGN_ALLCLIENT


    // Painel superior
	pnTop := TPanel():New(0,0,,spDiv,,,,,,60,60)

	oMainBrowse := TCBrowse():New( 60,4,600,145,, {'Codigo','Nome','Valor'},{20,50,50,50}, pnTop,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )
	
	oMainBrowse:SetArray(aMainBrowse)
	oMainBrowse:bLine := {||{ aMainBrowse[oMainBrowse:nAt,02],;
		aMainBrowse[oMainBrowse:nAt,03],;
		Transform(aMainBrowse[oMainBrowse:nAT,04],'@E 99,999,999,999.99') } }*/




	oDlg:Activate()


return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ STCSTO01 ³ Autor ³ Cristiano Pereira     ³ Data ³ 20/12/03 ³±±
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

User Function STCST01A()

	Local _aEstru := {}
	Local _aCpyEs := {}
	Local _cQryG1 := ""
	Local _nBloco
	Local _nLimite := 0
	Local _nProc   := 0

	If Empty(_dRedDe)
		MsgInfo("Por favor, Informe a data de refência anterior.","Atenção")
		return
	Endif

	If Empty(_dRedAt)
		MsgInfo("Por favor, Informe a data de refência atual.","Atenção")
		return
	Endif


	If Empty(_cModRef)
		MsgInfo("Por favor, Informe a data de refência da MOD.","Atenção")
		return
	Endif

	If Empty(nObj)
		MsgInfo("Por favor, Informe o tipo do processamento.","Atenção")
		return
	Endif

	If !Empty(_cMP) .And. Empty(nPart)

		MsgInfo("Por favor, Informe se o processamento, será particionado..","Atenção")
		return

	Endif


	If SubStr(nPart,1,1)=="S" .And. !Empty(_cMP)

		If Select("TG1") > 0
			DbSelectArea("TG1")
			DbCloSeArea()
		Endif

		_cQryG1 := " SELECT	B1_FILIAL,B1_COD,G1_COD "
		_cQryG1 += " FROM "+RetSqlName("SB1")+" SB1 "
		_cQryG1 += " JOIN "+RetSqlName("SG1")+" SG1 "
		_cQryG1 += " ON	G1_FILIAL = '"+xFilial("SG1")+"' AND     "
		_cQryG1 += "	G1_COMP   = B1_COD               AND     "
		_cQryG1 += " 	SG1.D_E_L_E_T_ <> '*'                    "
		_cQryG1 += " WHERE	B1_FILIAL = '"+xFilial("SB1")+"' AND "
		_cQryG1 += " 		B1_COD   = '"+LTrim(RTrim(_cMP))+"'  AND  "
		_cQryG1 += " 		SB1.D_E_L_E_T_ <> '*'                AND  "
		_cQryG1 += " NOT EXISTS    (                                  "
		_cQryG1 += "                 SELECT SG1.G1_COD            "
		_cQryG1 += "                 FROM "+RetSqlName("SG1")+" SG1   "
		_cQryG1 += "                 WHERE SG1.G1_FILIAL ='"+xFilial("SG1")+"'  AND "
		_cQryG1 += "                       SG1.D_E_L_E_T_ <> '*'                AND "
		_cQryG1 += "                       SG1.G1_COD=SB1.B1_COD         )          "


		_cQryG1 += " GROUP BY B1_FILIAL,B1_COD,G1_COD            "
		_cQryG1 += " ORDER BY G1_COD                             "

		TCQUERY  _cQryG1 NEW ALIAS "TG1"

		_nBloco := 0
		DbEval({|| _nBloco++  })

		ProcRegua(_nBloco)
		DbSelectArea("TG1")
		DbGotop()
		While !TG1->(EOF())

			If  _nLimite<=400

				IncProc("Registro:"+ Str(_nProc)+" de "+Str(_nBloco)+" Produto "+TG1->G1_COD)
				If SB1->(dbSeek(xFilial("SB1")+TG1->G1_COD))
					MStru(@_aEstru,TG1->G1_COD,TG1->B1_COD,0,0)
				Endif

				If _nLimite==400
					Processa({|lEnd| u_STCSTAB(_aEstru)  },"Processando registros da estrutura para gerar a planilha excel","Aguarde...",.T.)
					_nLimite:=0
					_aEstru := {}
				Endif
			Endif
			_nLimite++
			_nProc++
			TG1->(DbSkip())
		Enddo

	Else
		Processa( {|lEnd| _aCpyEs :=	u_STKCSTA(@_aEstru) },"Explosão da Estrutura","Simulação custo matéria prima",.T.)

		If Empty(_cGrpAt) .And. Empty(_cProdAt) .And. Empty(_cMP)
			Processa({|lEnd| u_STCSTAB(_aCpyEs)  },"Processando registros da estrutura para gerar a planilha excel","Aguarde...",.T.)
		Else
			Processa({|lEnd| u_STCSTAG(_aCpyEs)  },"Processando registros da estrutura para gerar a planilha excel","Aguarde...",.T.)
		Endif
	Endif
return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ STCSTO01 ³ Autor ³ Cristiano Pereira     ³ Data ³ 20/12/03 ³±±
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

User Function STCST01H()

	Local _aEstru := {}
	Local _aCpyEs := {}


	If Empty(_cModRef)
		MsgInfo("Por favor, Informe a data de refência da MOD.","Atenção")
		return
	Endif

	If Empty(nObj)
		MsgInfo("Por favor, Informe o tipo do processamento.","Atenção")
		return
	Endif

	Processa({|lEnd| _aCpyEs :=	u_STCSTHA(@_aEstru)   },"Explosão da Estrutura arquivo","Simulação custo matéria prima",.T.)
	Processa({|lEnd| u_STCSTAB(_aCpyEs)  },"Processando registros da estrutua para gerar a planilha excel","Aguarde...",.T.)


return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ STCST01W ³ Autor ³ Cristiano Pereira     ³ Data ³ 20/12/03 ³±±
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

User Function STCST01W()

	Local _aEstru := {}
	Local _aCpyEs := {}
	Local _aMp    := {}


	If Empty(_cModRef)
		MsgInfo("Por favor, Informe a data de refência da MOD.","Atenção")
		return
	Endif

	If Empty(nObj)
		MsgInfo("Por favor, Informe o tipo do processamento.","Atenção")
		return
	Endif

	Processa({|lEnd| _aCpyEs :=	u_STCSTWA(@_aEstru,@_aMp)   },"Explosão da Estrutura arquivo","Simulação custo matéria prima",.T.)
	Processa({|lEnd| u_STCSTWB(_aCpyEs,_aMp)  },"Processando registros da estrutua para gerar a planilha excel","Aguarde...",.T.)


return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ STCSTWA ³ Autor ³ Cristiano Pereira     ³ Data ³ 20/12/03 ³±±
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
User function STCSTWA(_aEstru,_aMp)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declara variaveis.														 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Local aTxt    := {}						//Array com os campos enviados no TXT.
	Local nHandle := 0						//Handle do arquivo texto.
	Local cArqImp := ""						//Arquivo Txt a ser lido.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posiciona areas.														 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	SG1->(dbSetOrder(1))  //CNPJ do Fornecedor

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Busca o arquivo para leitura.											 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cArqImp := cGetFile("Arquivo .CSV |*.CSV","Selecione o Arquivo CSV",0,"",.T.,GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE)
	If (nHandle := FT_FUse(cArqImp))== -1
		MsgInfo("Erro ao tentar abrir arquivo.","Atenção")
		Return
	EndIf

	Processa({|lEnd| LeTXT(aTxt,@_aEstru,@_aMp)},"Aguarde, lendo arquivo de acumulados...")

return(_aEstru)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ IMPFORN   ºAutor ³Cristiano Pereira           º Data ³  28/01/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Le o Txt e carrega os dados.				                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MP8                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function LeTXT(aTxt,_aEstru,_aMp)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declara variaveis.														 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Local cLinha  := ""						//Linha do arquivo texto a ser tratada.
	Local nReg    := 0

	FT_FGOTOP()
	aTxt := {}
	While !FT_FEOF()
		nReg++
		IncProc("Registro:"+ Str(nReg))
		cLinha := FT_FREADLN()

		cLinha := Upper(NoAcento(AnsiToOem(cLinha)))
		AADD(aTxt,{})
		While At(";",cLinha) > 0
			aAdd(aTxt[Len(aTxt)],AllTrim(Substr(cLinha,1,At(";",cLinha)-1)))
			cLinha := StrTran(Substr(cLinha,At(";",cLinha)+1,Len(cLinha)-At(";",cLinha)),'"','')
		EndDo
		cLinha := StrTran(Substr(cLinha,1,Len(cLinha)),',','.')
		aAdd(aTxt[Len(aTxt)],AllTrim(StrTran(Substr(cLinha,1,Len(cLinha)),'"','')))
		FT_FSKIP()
	EndDo
	GravaMP(aTxt,@_aEstru,@_aMp)
	FT_FUSE()

Return(_aEstru)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ GravaMP  ºAutor ³Cristiano Pereira    Data ³  28/01/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Grava os dados lidos			                  			  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MP8                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GravaMP(aTxt,_aEstru,_aMp)

	Local nX    	  := 0
	Local _cQryG1 :=  ""
	//Private lMsErroAuto := .F.
	Private aCabec   := {}


	For nX := 1 to Len(aTxt)
		AADD(_aMp,{aTxt[nX,1],Val(StrTran(aTxt[nX,2],",",".")),Val(StrTran(aTxt[nX,3],",",".")),aTxt[nX,4]})
	Next nx


	If Select("TG1") > 0
		DbSelectArea("TG1")
		DbCloSeArea()
	Endif
	//_cQryG1 += " 		RTRIM(B1_TIPO) IN ('PA')                AND    "
	_cQryG1 := " SELECT	B1_FILIAL,B1_COD,G1_COD "
	_cQryG1 += " FROM "+RetSqlName("SB1")+" SB1 "
	_cQryG1 += " JOIN "+RetSqlName("SG1")+" SG1 "
	_cQryG1 += " ON	G1_FILIAL = '"+xFilial("SG1")+"' AND     "
	_cQryG1 += "	G1_COD   = B1_COD               AND     "
	_cQryG1 += " 	SG1.D_E_L_E_T_ <> '*'                    "
	_cQryG1 += " WHERE	B1_FILIAL = '"+xFilial("SB1")+"' AND "
	_cQryG1 += "        LTRIM(RTRIM(B1_TIPO))='PA'              AND "

	If SubStr(nFitr,1,1)=="S"
		_cQryG1 += "        LTRIM(RTRIM(B1_XINFMP)) ='S'     AND    "
	Endif

	_cQryG1 += " 		SB1.D_E_L_E_T_ <> '*'                "

	_cQryG1 += " GROUP BY B1_FILIAL,B1_COD,G1_COD            "

	_cQryG1 += " ORDER BY G1_COD                             "

	TCQUERY  _cQryG1 NEW ALIAS "TG1"

	_nRec := 0
	DbEval({|| _nRec++  })


	DbSelectArea("TG1")
	DbGotop()
	While !TG1->(EOF())
		_lProcess := .T.
		If SB1->(dbSeek(xFilial("SB1")+TG1->G1_COD))
			MStruPai(@_aEstru,TG1->G1_COD,TG1->B1_COD)
		Endif
		TG1->(DbSkip())
	Enddo




Return(_aEstru)




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ STCSTO01 ³ Autor ³ Cristiano Pereira     ³ Data ³ 20/12/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Explosão da estrutrura                                     ³±±
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
User Function STKCSTA(_aEstru)


	Local    _cQryG1 :=  ""
	Local    nReg:=0
	public  _lProcess := .T.



	If  Empty(nPart)
		MsgInfo("Por favor, Informe se o processamento, será particionado..","Atenção")
		return
	Endif

	If SubStr(_cProdAt,1,3)=="ZZZ" .Or. SubStr(_cGrpAt,1,3)=="ZZZ"


		If Select("TG1") > 0
			DbSelectArea("TG1")
			DbCloSeArea()
		Endif
		//_cQryG1 += " 		RTRIM(B1_TIPO) IN ('PA')                AND    "
		_cQryG1 := " SELECT	B1_FILIAL,B1_COD,G1_COD "
		_cQryG1 += " FROM "+RetSqlName("SB1")+" SB1 "
		_cQryG1 += " JOIN "+RetSqlName("SG1")+" SG1 "
		_cQryG1 += " ON	G1_FILIAL = '"+xFilial("SG1")+"' AND     "
		_cQryG1 += "	G1_COD   = B1_COD               AND     "
		_cQryG1 += " 	SG1.D_E_L_E_T_ <> '*'                    "
		_cQryG1 += " WHERE	B1_FILIAL = '"+xFilial("SB1")+"' AND "
		_cQryG1 += "        LTRIM(RTRIM(B1_TIPO))='PA'              AND "

		If SubStr(nFitr,1,1)=="S"
			_cQryG1 += "        LTRIM(RTRIM(B1_XINFMP)) ='S'     AND    "
		Endif

		_cQryG1 += " 		SB1.D_E_L_E_T_ <> '*'                "

		_cQryG1 += " GROUP BY B1_FILIAL,B1_COD,G1_COD            "

		_cQryG1 += " ORDER BY G1_COD                             "

		TCQUERY  _cQryG1 NEW ALIAS "TG1"

		_nRec := 0
		DbEval({|| _nRec++  })


		DbSelectArea("TG1")
		DbGotop()
		While !TG1->(EOF())
			_lProcess := .T.
			If SB1->(dbSeek(xFilial("SB1")+TG1->G1_COD))

				MStruPai(@_aEstru,TG1->G1_COD,TG1->B1_COD)

			Endif
			TG1->(DbSkip())
		Enddo



	ElseIf Empty(_cProdAt) .aND. Empty(_cGrpAt) .aND. !Empty(_cMP)

		If Select("TG1") > 0
			DbSelectArea("TG1")
			DbCloSeArea()
		Endif
		//_cQryG1 += " 		RTRIM(B1_TIPO) IN ('PA')                AND    "
		_cQryG1 := " SELECT	B1_FILIAL,B1_COD,G1_COD "
		_cQryG1 += " FROM "+RetSqlName("SB1")+" SB1 "
		_cQryG1 += " JOIN "+RetSqlName("SG1")+" SG1 "
		_cQryG1 += " ON	G1_FILIAL = '"+xFilial("SG1")+"' AND     "
		_cQryG1 += "	G1_COD   = B1_COD               AND     "
		_cQryG1 += " 	SG1.D_E_L_E_T_ <> '*'                    "
		_cQryG1 += " WHERE	B1_FILIAL = '"+xFilial("SB1")+"' AND "
		_cQryG1 += "        LTRIM(RTRIM(B1_TIPO))='PA'              AND "

		If SubStr(nFitr,1,1)=="S"
			_cQryG1 += "        LTRIM(RTRIM(B1_XINFMP)) ='S'     AND    "
		Endif

		_cQryG1 += " 		SB1.D_E_L_E_T_ <> '*'                "

		_cQryG1 += " GROUP BY B1_FILIAL,B1_COD,G1_COD            "

		_cQryG1 += " ORDER BY G1_COD                             "

		TCQUERY  _cQryG1 NEW ALIAS "TG1"

		_nRec := 0
		DbEval({|| _nRec++  })


		DbSelectArea("TG1")
		DbGotop()
		While !TG1->(EOF())
			_lProcess := .T.
			If SB1->(dbSeek(xFilial("SB1")+TG1->G1_COD))

				MStruPai(@_aEstru,TG1->G1_COD,TG1->B1_COD)

			Endif
			TG1->(DbSkip())
		Enddo


	ElseIf !Empty(_cProdAt) //Explosão pelo Pai


		If Select("TG1") > 0
			DbSelectArea("TG1")
			DbCloSeArea()
		Endif

		_cQryG1 := " SELECT	B1_FILIAL,B1_COD,G1_COD "
		_cQryG1 += " FROM "+RetSqlName("SB1")+" SB1 "
		_cQryG1 += " JOIN "+RetSqlName("SG1")+" SG1 "
		_cQryG1 += " ON	G1_FILIAL = '"+xFilial("SG1")+"' AND     "
		_cQryG1 += "	G1_COD   = B1_COD               AND     "
		_cQryG1 += " 	SG1.D_E_L_E_T_ <> '*'                    "
		_cQryG1 += " WHERE	B1_FILIAL = '"+xFilial("SB1")+"' AND "
		_cQryG1 += " 		B1_COD   >= '"+lTrim(RTrim(_cProdDe))+"'  AND B1_COD   <= '"+lTrim(RTrim(_cProdAt))+"' AND  RTRIM(B1_TIPO) IN ('PA')            AND    "
		If SubStr(nFitr,1,1)=="S"
			_cQryG1 += "        LTRIM(RTRIM(B1_XINFMP)) ='S'     AND    "
		Endif
		_cQryG1 += " 		SB1.D_E_L_E_T_ <> '*'                "

		_cQryG1 += " GROUP BY B1_FILIAL,B1_COD,G1_COD            "

		_cQryG1 += " ORDER BY G1_COD                             "

		TCQUERY  _cQryG1 NEW ALIAS "TG1"

		_nRec := 0
		DbEval({|| _nRec++  })


		DbSelectArea("TG1")
		DbGotop()
		While !TG1->(EOF())
			_lProcess := .T.
			If SB1->(dbSeek(xFilial("SB1")+TG1->G1_COD))

				MStruPai(@_aEstru,TG1->G1_COD,TG1->B1_COD)

			Endif
			TG1->(DbSkip())
		Enddo

	ElseIf !Empty(_cGrpAt)//Explosão pelo Pai

		If Select("TG1") > 0
			DbSelectArea("TG1")
			DbCloSeArea()
		Endif

		_cQryG1 := " SELECT	B1_FILIAL,B1_COD,G1_COD "
		_cQryG1 += " FROM "+RetSqlName("SB1")+" SB1 "
		_cQryG1 += " JOIN "+RetSqlName("SG1")+" SG1 "
		_cQryG1 += " ON	G1_FILIAL = '"+xFilial("SG1")+"' AND     "
		_cQryG1 += "	G1_COD   = B1_COD               AND     "
		_cQryG1 += " 	SG1.D_E_L_E_T_ <> '*'                    "
		_cQryG1 += " WHERE	B1_FILIAL = '"+xFilial("SB1")+"' AND "
		_cQryG1 += " 		B1_GRUPO  >= '"+lTrim(RTrim(_cGrpDe))+"'  AND B1_GRUPO  <= '"+lTrim(RTrim(_cGrpAt))+"' AND  RTRIM(B1_TIPO) IN ('PA')            AND    "
		If SubStr(nFitr,1,1)=="S"
			_cQryG1 += "        LTRIM(RTRIM(B1_XINFMP)) ='S'     AND    "
		Endif
		_cQryG1 += " 		SB1.D_E_L_E_T_ <> '*'                "
		_cQryG1 += " GROUP BY B1_FILIAL,B1_COD,G1_COD            "

		_cQryG1 += " ORDER BY G1_COD                             "

		TCQUERY  _cQryG1 NEW ALIAS "TG1"

		_nRec := 0
		DbEval({|| _nRec++  })


		DbSelectArea("TG1")
		DbGotop()

		While !TG1->(EOF())
			_lProcess := .T.
			If SB1->(dbSeek(xFilial("SB1")+TG1->G1_COD))

				MStruPai(@_aEstru,TG1->G1_COD,TG1->B1_COD)

			Endif
			TG1->(DbSkip())
		Enddo


	Else //Explosão pela Materia Prima

		If Select("TG1") > 0
			DbSelectArea("TG1")
			DbCloSeArea()
		Endif

		_cQryG1 := " SELECT	B1_FILIAL,B1_COD,G1_COD "
		_cQryG1 += " FROM "+RetSqlName("SB1")+" SB1 "
		_cQryG1 += " JOIN "+RetSqlName("SG1")+" SG1 "
		_cQryG1 += " ON	G1_FILIAL = '"+xFilial("SG1")+"' AND     "
		_cQryG1 += "	G1_COMP   = B1_COD               AND     "
		_cQryG1 += " 	SG1.D_E_L_E_T_ <> '*'                    "
		_cQryG1 += " WHERE	B1_FILIAL = '"+xFilial("SB1")+"' AND "
		_cQryG1 += " 		B1_COD   = '"+LTrim(RTrim(_cMP))+"'  AND  "
		_cQryG1 += " 		SB1.D_E_L_E_T_ <> '*'              AND  "
		_cQryG1 += " NOT EXISTS    (                                  "
		_cQryG1 += "                 SELECT SG1.G1_COD            "
		_cQryG1 += "                 FROM "+RetSqlName("SG1")+" SG1   "
		_cQryG1 += "                 WHERE SG1.G1_FILIAL ='"+xFilial("SG1")+"'  AND "
		_cQryG1 += "                       SG1.D_E_L_E_T_ <> '*'                AND "
		_cQryG1 += "                       SG1.G1_COD=SB1.B1_COD         )      "


		_cQryG1 += " GROUP BY B1_FILIAL,B1_COD,G1_COD            "
		_cQryG1 += " ORDER BY G1_COD                             "

		TCQUERY  _cQryG1 NEW ALIAS "TG1"

		_nRec := 0
		DbEval({|| _nRec++  })

		ProcRegua(_nRec)
		DbSelectArea("TG1")
		DbGotop()
		While !TG1->(EOF())

			IncProc("Registro:"+ Str(nReg)+" de "+Str(_nRec)+" Produto "+TG1->G1_COD)
			If SB1->(dbSeek(xFilial("SB1")+TG1->G1_COD))

				MStru(@_aEstru,TG1->G1_COD,TG1->B1_COD,0,0)

			Endif
			nReg++
			TG1->(DbSkip())
		Enddo


	Endif


return(_aEstru)


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
Static Function MStru(_aEstru,cProduto,_cMMP,_nCAnt,_nCAtu)

	Local nReg := 0
	Local aAreaAtu := GetArea()
	Local aAreaSG1 := SG1->(GetArea())
	Local aAreaSB1 := SB1->(GetArea())
	Local i
	Private  nEstru := 0
	Private aEstru := {}
	Private nProp  := 0



	dbSelectArea("SG1")
	dbSetOrder(2)
	If !dbSeek(xFilial("SG1")+cProduto)


		If Select("TD3") > 0
			DbSelectArea("TD3")
			DbCloseArea()
		Endif

		_cQry :=  " SELECT SUM(SD3.D3_QUANT ) AS QUANT                  "
		_cQry +=  " FROM "+RetSqlName("SD3")+" SD3                      "
		_cQry +=  " WHERE  "
		_cQry +=  "       SD3.D_E_L_E_T_ <> '*'                     AND "
		_cQry +=  "       SD3.D3_EMISSAO>='"+Dtos(msdate()-365)+"'  AND "
		_cQry +=  "       SD3.D3_ESTORNO <> 'S'                     AND "
		_cQry +=  "       SUBSTR(SD3.D3_CF,1,2) ='PR'               AND "
		_cQry +=  "       SD3.D3_COD   ='"+cProduto+"'                  "


		TCQUERY  _cQry  NEW ALIAS "TD3"

		_nRec := 0
		DbEval({|| _nRec++  })

		DbSelectArea("TD3")
		DbGotop()


		If Select("TD2") > 0
			DbSelectArea("TD2")
			DbCloseArea()
		Endif

		_cQry :=  " SELECT SUM(SD2.D2_QUANT ) AS QUANT                 "
		_cQry +=  " FROM "+RetSqlName("SD2")+" SD2                      "
		_cQry +=  " WHERE SD2.D2_FILIAL ='"+xFilial("SD2")+"'       AND "
		_cQry +=  "       SD2.D_E_L_E_T_ <> '*'                     AND "
		_cQry +=  "       SD2.D2_EMISSAO>='"+Dtos(msdate()-365)+"'  AND "
		_cQry +=  "       SD2.D2_COD ='"+cProduto+"'                    "


		TCQUERY  _cQry  NEW ALIAS "TD2"

		_nRec := 0
		DbEval({|| _nRec++  })

		DbSelectArea("TD2")
		DbGotop()

		If TD3->QUANT > 0
			AADD(_aEstru,{cProduto,SG1->G1_COMP,"001",0,_cMMP,_nCAnt,_nCAtu})
		ElseIf TD2->QUANT > 0
			AADD(_aEstru,{cProduto,SG1->G1_COMP,"001",0,_cMMP,_nCAnt,_nCAtu})
		Endif

	Endif


	While !Eof() .And. SG1->G1_FILIAL+SG1->G1_COMP == xFilial("SG1")+cProduto

		nReg := Recno()

		DbSelectArea("SB1")
		DbSetOrder(1)
		If DbSeek(xFilial("SB1")+cProduto)

			If Select("TD3") > 0
				DbSelectArea("TD3")
				DbCloseArea()
			Endif

			_cQry :=  " SELECT SUM(SD3.D3_QUANT ) AS QUANT                  "
			_cQry +=  " FROM "+RetSqlName("SD3")+" SD3                      "
			_cQry +=  " WHERE "
			_cQry +=  "       SD3.D_E_L_E_T_ <> '*'                     AND "
			_cQry +=  "       SD3.D3_EMISSAO>='"+Dtos(msdate()-365)+"'  AND "
			_cQry +=  "       SD3.D3_ESTORNO <> 'S'                     AND "
			_cQry +=  "       SUBSTR(SD3.D3_CF,1,2) ='PR'               AND "
			_cQry +=  "       SD3.D3_COD   ='"+cProduto+"'                  "


			TCQUERY  _cQry  NEW ALIAS "TD3"

			_nRec := 0
			DbEval({|| _nRec++  })

			DbSelectArea("TD3")
			DbGotop()


			If Select("TD2") > 0
				DbSelectArea("TD2")
				DbCloseArea()
			Endif

			_cQry :=  " SELECT SUM(SD2.D2_QUANT ) AS QUANT                  "
			_cQry +=  " FROM "+RetSqlName("SD2")+" SD2                      "
			_cQry +=  " WHERE SD2.D2_FILIAL ='"+xFilial("SD2")+"'       AND "
			_cQry +=  "       SD2.D_E_L_E_T_ <> '*'                     AND "
			_cQry +=  "       SD2.D2_EMISSAO>='"+Dtos(msdate()-365)+"'  AND "
			_cQry +=  "       SD2.D2_COD ='"+cProduto+"'                    "


			TCQUERY  _cQry  NEW ALIAS "TD2"

			_nRec := 0
			DbEval({|| _nRec++  })

			DbSelectArea("TD2")
			DbGotop()

			If TD3->QUANT > 0

				nEstru := 0
				aEstru := {}
				_nProp  := 0

				aEstru := Estrut(cProduto,1)

				For i:=1 to len(aEstru)

					DbSelectArea("SG1")
					DbSetOrder(1)
					If DbSeek(xFilial("SG1")+aEstru[i,2]+aEstru[i,3])
						If  (dDataBase >= SG1->G1_INI .And. dDataBase <= SG1->G1_FIM)
							If aEstru[i,3]==_cMMP
								_nProp += SG1->G1_QUANT
							Endif
						Endif
					Endif
				Next

				AADD(_aEstru,{cProduto,SG1->G1_COMP,SG1->G1_TRT, _nProp,_cMMP,_nCAnt,_nCAtu})

			ElseIf TD2->QUANT > 0

				nEstru := 0
				aEstru := {}
				_nProp  := 0

				aEstru := Estrut(cProduto,1)

				For i:=1 to len(aEstru)

					DbSelectArea("SG1")
					DbSetOrder(1)
					If DbSeek(xFilial("SG1")+aEstru[i,2]+aEstru[i,3])
						If  (dDataBase >= SG1->G1_INI .And. dDataBase <= SG1->G1_FIM)
							If aEstru[i,3]==_cMMP
								_nProp += SG1->G1_QUANT
							Endif
						Endif
					Endif
				Next

				AADD(_aEstru,{cProduto,SG1->G1_COMP,SG1->G1_TRT, _nProp,_cMMP,_nCAnt,_nCAtu})
			Endif

		Endif

		If  MR400REV(SG1->G1_COD,SG1->G1_REVINI,SG1->G1_REVFIM)
			If  (dDataBase >= SG1->G1_INI .And. dDataBase <= SG1->G1_FIM)

				dbSelectArea("SB1")
				dbSeek(xFilial("SB1")+SG1->G1_COD)
			Endif
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se existe sub-estrutura                ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea("SG1")
			dbSeek(xFilial("SG1")+SG1->G1_COMP+SG1->G1_COD)
			IF Found()
				MStru(_aEstru,SG1->G1_COD,_cMMP,_nCAnt,_nCAtu)
			EndIf
		EndIf

		dbGoto(nReg)
		dbSkip()

	EndDo

	RestArea(aAreaSB1)
	RestArea(aAreaSG1)
	RestArea(aAreaAtu)

Return Nil

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

Static Function MStruPai(_aEstru,cProduto,_cMMP)


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
±±³Fun‡…o    ³ STCSTAB³ Autor ³ Ricardo Berti         ³ Data ³17/05/2006³±±
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
User function STCSTAB(_aEstru)

	Local _aCabec   := {}
	Local aDados    := {}
	Local linha
	Local _cMOD     := " "
	Local _aCampos  := {}
	Local _nReg     := 0
	Local _aMOD     := {}
	Local i



	_aCabec := {"PRODUTO PAI","COMPONENTE","DESCRIÇÃO","QUANTIDADE","CUSTO MP","CUSTO MÉDIO","TOTAL","VOLUME APONTADO","-------","PRODUTO PAI","COMPONENTE","DESCRIÇÃO","QUANTIDADE","CUSTO MP","CUSTO MÉDIO","TOTAL","VOLUME APONTADO"}

	_aCampos:= {  ;
		{"FILIAL" ,"C",02,0 } ,;
		{"PAI" ,"C",15,0  } ,;
		{"COMP" ,"C",15,0 } ,;
		{"SEQ" ,"C",03,0  } ,;
		{"QTD"  ,"N",15,6 } ,;
		{"MP","C",15,0    },;
		{"PRCAN","N",14,5 },;
		{"PRCAT","N",14,5}}

	// Fecha arquivo temporario
	If Select("TRB") > 0
		DbSelectArea("TRB")
		DbCLoseArea()
	Endif

	_cArq := CriaTrab(_aCampos,.t.)
	dbUseArea(.T.,,_cArq,"TRB",.F.,.F.)

	_cIndTrb  := CriaTrab(Nil,.F.)
	_cChave1  := "FILIAL+PAI+MP"
	IndRegua("TRB",_cIndTrb,_cChave1,,,)

	ProcRegua(RecCount())

	_aEstru := aSort(_aEstru,,,{|x,y| x[1] < y[1] })

	for linha:=1 to len(_aEstru)


		_nReg   := _nReg  + 1


		IncProc("Inicializando processo , para a geração do arquivo excel:"+ Str(_nReg))

		DbSelectArea("TRB")
		DbSetOrder(1)
		If !DbSeek(xFilial("SD3")+_aEstru[linha,1]+_aEstru[linha,5])
			If Reclock("TRB",.t.)
				TRB->FILIAL:= xFilial("SD3")
				TRB->PAI := _aEstru[linha,1]
				TRB->COMP := _aEstru[linha,2]
				TRB->SEQ := _aEstru[linha,3]
				TRB->QTD := _aEstru[linha,4]
				TRB->MP := _aEstru[linha,5]
				TRB->PRCAN := _aEstru[linha,6]
				TRB->PRCAT := _aEstru[linha,7]
				MsUnlock()
			Endif
		Endif



	Next linha



	aAdd(aDados, {;
		"",;
		"",;
		"REFERÊNCIA "+Dtoc(_dRedDe),;
		"",;
		'',;
		'',;
		'',;
		'',;
		'',;
		'',;
		'',;
		"REFERÊNCIA "+Dtoc(_dRedAt),;
		'',;
		'',;
		'',;
		'',;
		'';
		})


	DbSelectArea("TRB")
	DbGoTop()

	_nReg := 0
	ProcRegua(RecCount())
	While !TRB->(EOF())


		_nReg   := _nReg  + 1


		IncProc("Geração do arquivo excel, em andamento..:"+ Str(_nReg))

		_cPai  :=TRB->PAI
		_cMOD  := ""
		_nPai  := 0

		While _cPai  ==TRB->PAI


			DbSelectArea("SG1")
			DbSetOrder(1)
			If DbSeek(xFilial("SG1")+TRB->PAI)

				DbSelectArea("SB1")
				DbSetOrder(1)
				If DbSeek(xFilial("SB1")+TRB->PAI) .And. SB1->B1_TIPO="PA"

					DbSelectArea("SB1")
					DbSetOrder(1)
					DbSeek(xFilial("SB1")+TRB->PAI)

					If _nPai <=0

						aAdd(aDados, {;
							TRB->PAI,;
							"",;
							Posicione("SB1",1,xFilial("SB1")+TRB->PAI,"B1_DESC"),;
							1,;
							'',;
							u_STCSTAC(TRB->PAI,_dRedDe,1),;
							Transform(1*u_STCSTAJ(TRB->PAI,_dRedDe,1,3,_aEstru), "@E 9999,9999.99999999" ) ,;
							STCSTAE(TRB->PAI,''),;
							'-----------',;
							TRB->PAI,;
							'',;
							Posicione("SB1",1,xFilial("SB1")+TRB->PAI,"B1_DESC"),;
							1,;
							'',;
							u_STCSTAC(TRB->PAI,_dRedAt,1),;
							Transform(1*u_STCSTAJ(TRB->PAI,_dRedAt,1,4,_aEstru), "@E 9999,9999.99999999" ),;
							STCSTAE(TRB->PAI,'');
							})
						_nPai++
					Endif

					If SubStr(nObj,1,1)=="A"

						DbSelectArea("SB1")
						DbSetOrder(1)
						DbSeek(xFilial("SB1")+TRB->MP)

						DbSelectArea("SG1")
						DbSetOrder(1)
						DbSeek(xFilial("SG1")+TRB->PAI+TRB->MP)


						aAdd(aDados, {;
							"",;
							TRB->MP,;
							Posicione("SB1",1,xFilial("SB1")+TRB->MP,"B1_DESC"),;
							TRB->QTD,;
							'',;
							Transform(IIf(TRB->PRCAN<=0,u_STCSTAC(TRB->MP,_dRedDe,2),TRB->PRCAN),"@E 9999,9999.99999999"),;
							Transform(TRB->QTD*IIf(TRB->PRCAN<=0,u_STCSTAC(TRB->MP,_dRedDe,2,3),TRB->PRCAN),"@E 9999,9999.99999999"),;
							0,;
							'',;
							TRB->MP,;
							Posicione("SB1",1,xFilial("SB1")+TRB->MP,"B1_DESC"),;
							'',;
							TRB->QTD,;
							'',;
							Transform(IIf(TRB->PRCAT<=0,u_STCSTAC(TRB->MP,_dRedAt,2),TRB->PRCAT),"@E 9999,9999.99999999"),;
							Transform(TRB->QTD*IIf(TRB->PRCAT<=0,u_STCSTAC(TRB->MP,_dRedAt,2,4),TRB->PRCAT), "@E 9999,9999.99999999" ),;
							0})

					Endif

				Endif
			Endif

			DbSelectArea("TRB")
			DbSkip()
		Enddo


		nEstru := 0
		aEstru := {}
		_aMOD     := {}




		aEstru := Estrut(_cPai ,1)
		aEstru := aSort(aEstru,,,{|x,y| x[2] < y[2] })

		u_STCSTAM(@_aMOD,_cPai,1)

		For i:=1 to len(aEstru)

			If aEstru[i,1]==1

				DbSelectArea("SG1")
				DbSetOrder(1)
				If DbSeek(xFilial("SG1")+aEstru[i,2]+aEstru[i,3])
					If  (dDataBase >= SG1->G1_INI .And. dDataBase <= SG1->G1_FIM)
						DbSelectArea("SB1")
						If DbSeek(xFilial("SB1")+aEstru[i,3])  .And. !(RTrim(SB1->B1_COD)==RTrim(_cPai))
							u_STCSTAM(@_aMOD,aEstru[i,3],aEstru[i,4])
						Endif
					Endif
				Endif

			Else

				DbSelectArea("SG1")
				DbSetOrder(1)
				If DbSeek(xFilial("SG1")+aEstru[i,2]+aEstru[i,3])
					If  (dDataBase >= SG1->G1_INI .And. dDataBase <= SG1->G1_FIM)
						DbSelectArea("SB1")
						If DbSeek(xFilial("SB1")+aEstru[i,3])  .And. !(RTrim(SB1->B1_COD)==RTrim(_cPai))
							u_STCSTAM(@_aMOD,aEstru[i,3],aEstru[i,4])
						Endif
					Endif
				Endif
			Endif

		Next

		For linha:=1 to len(_aMOD)

			aAdd(aDados, {;
				"",;
				_aMOD[linha,1],;
				Posicione("SB1",1,xFilial("SB1")+_aMOD[linha,1],"B1_DESC"),;
				Transform(_aMOD[linha,2],"@E 9999,9999.99999999" ),;
				'',;
				u_STCSTAD(_aMOD[linha,1],_cModRef),;
				Transform(_aMOD[linha,2]*u_STCSTAD(_aMOD[linha,1],_cModRef), "@E 9999,9999.99999999" ),;
				0,;
				'',;
				_aMOD[linha,1],;
				Posicione("SB1",1,xFilial("SB1")+_aMOD[linha,1],"B1_DESC"),;
				'',;
				Transform(_aMOD[linha,2],"@E 9999,9999.99999999" ),;
				'',;
				u_STCSTAD(_aMOD[linha,1],_cModRef),;
				Transform(_aMOD[linha,2]*u_STCSTAD(_aMOD[linha,1],_cModRef), "@E 9999,9999.99999999" ),;
				0;
				})

		Next linha

		aAdd(aDados, {;
			"",;
			"",;
			"",;
			"",;
			'',;
			'',;
			'',;
			'',;
			'',;
			'',;
			'',;
			'',;
			'',;
			'',;
			'',;
			'',;
			'';
			})
	Enddo

	//###############################
	//Elimina arquivo de trabalho   #
	//###############################
	FERASE(_cArq+".DBF")
	FERASE(_cArq+".IDX")


	if Len(aDados) > 0
		FWMsgRun(,{|| ExpotMsExcel(_aCabec, aDados) },,"Aguarde, montando planilha")
	Endif

return

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
	Local cTable     := "SIMULAÇÃO CUSTO MÉDIO MATÉRIA PRIMA"
	Local oFwMsEx    := FWMsExcel():New()
	Private aAlgn := {1,1,1,1,1,1,1,1,1, 3,2,1,1,1,1,1,1}      // Alinhamento da coluna ( 1-Left,2-Center,3-Right )
	Private aForm := {1,1,1,1,1,2,1,1,1, 1,1,1,1,2,1,1,1}      // Codigo de formatação ( 1-General,2-Number,3-Monetário,4-DateTime )

	cWorkSheet := "Registros Gerados"

	oFwMsEx:AddWorkSheet( cWorkSheet )
	oFwMsEx:SetTitleSizeFont(17)
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


// ---------+-------------------+--------------------------------------------------
// Projeto  : IF DO BRASIL
// Autor    : Cristiano Pereira - SIGAMAT
// Modulo   : SIGAGPE
// Função   : ExpotMsExcel
// Descrição: Gera Planilha Excel.
// Retorno  : Nenhum.
// ---------+-------------------+--------------------------------------------------
// Data     | Autor             | Descricao
// ---------+-------------------+--------------------------------------------------
// 19/03/20 | Cristiano Pereira   | Desenvolvimento da rotina.
// ---------+-------------------+--------------------------------------------------
User Function STCSTAC(_cPrd,_dPer,_nNivel,_ndt)


	Local i
	Local _cQryB9  := ""
	Local _nRec

	_nCusto  := 0

	If _nNivel ==2

		If Select("SD1TMP") > 0
			DbSelectArea("SD1TMP")
			DbCloSeArea()
		Endif


		_cQuery    := " "
		_cQuery    += " SELECT SUM(D1_CUSTO) AS CUSTO, SUM(D1_QUANT) AS QUANT "
		_cQuery    += " FROM "+RETSQLNAME("SD1")+" SD1 , "+RetSqlName("SF1")+" SF1 "
		_cQuery    += " WHERE SD1.D1_FILIAL  BETWEEN '  ' AND 'ZZ' "
		//_cQuery    += " AND D1_DTDIGIT   BETWEEN '"+SubStr(dtos(_dPer),1,6)+"01"+"' AND '"+dtos(_dPer)+"' "
		_cQuery    += " AND D1_DTDIGIT   <=  '"+dtos(_dPer)+"' "
		_cQuery    += " AND SD1.D1_TIPO      = 'N'"
		_cQuery    += " AND SD1.D1_TES <> '   '   "
		_cQuery    += " AND SD1.D1_COD       = '"+_cPrd+"' "
		_cQuery    += " AND SD1.D_E_L_E_T_ = ' ' "
		_cQuery    += " AND SF1.F1_FILIAL = D1_FILIAL "
		_cQuery    += " AND SF1.F1_SERIE  = D1_SERIE  "
		_cQuery    += " AND SF1.F1_DOC    = D1_DOC    "
		_cQuery    += " AND SF1.F1_DUPL = SD1.D1_DOC  "
		_cQuery    += " AND SF1.F1_FORNECE = D1_FORNECE "
		_cQuery    += " AND SF1.F1_LOJA    = D1_LOJA    "
		_cQuery    += " AND SD1.D1_CUSTO > 0            "
		_cQuery    += " AND SF1.D_E_L_E_T_ <> '*'       "
		_cQuery    += " AND SD1.R_E_C_N_O_ = ( SELECT MAX(SD.R_E_C_N_O_) FROM "+RetSqlName("SD1")+" SD, "+RetSqlName("SF4")+" F4 "+" WHERE SD.D1_COD='"+_cPrd+"' AND SD.D1_CUSTO > 0 AND SD.D_E_L_E_T_ <> '*' AND SD.D1_DTDIGIT   <=  '"+dtos(_dPer)+"' AND SD.D1_TIPO      = 'N'  AND  SD.D1_TES <> '   '  AND SD.D1_TES=F4.F4_CODIGO AND F4.D_E_L_E_T_<>'*' AND F4.F4_DUPLIC='S') "



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

			_cQryB9:= " SELECT SB9.B9_VINI1,SB9.B9_QINI            "
			_cQryB9+= " FROM "+RetSqlName("SB9")+" SB9             "
			_cQryB9+= " WHERE SB9.D_E_L_E_T_ <> '*'           AND  "
			_cQryB9+= "       SB9.B9_DATA <='"+dtos(_dPer)+"' AND  "
			_cQryB9+= "       SB9.B9_COD ='"+_cPrd+"'        AND  "
			_cQryB9+= "       SB9.B9_QINI > 0 AND SB9.B9_VINI1 > 0 AND "

			_cQryB9+= " SB9.R_E_C_N_O_ IN (   "

			_cQryB9+= "  SELECT MAX(R_E_C_N_O_) "
			_cQryB9+= " FROM "+RetSqlName("SB9")+" SB9             "
			_cQryB9+= "  WHERE SB9.D_E_L_E_T_ <> '*'           AND "
			_cQryB9+= "       SB9.B9_DATA <='"+dtos(_dPer)+"' AND  "
			_cQryB9+= " SB9.B9_COD ='"+_cPrd+"'       AND "
			_cQryB9+= " SB9.B9_QINI > 0 AND SB9.B9_VINI1 > 0 ) "

			TCQUERY _cQryB9 NEW ALIAS "TB9"

			_nRec := 0
			DbEval({|| _nRec++  })

			DbSelectArea("TB9")
			DbGotop()
			If _nRec > 0
				_nCusto := TB9->B9_VINI1/TB9->B9_QINI
			Endif


		Endif



	Endif


	If _nNivel ==1//Explode custo do PAI

		nEstru := 0
		aEstru := {}
		_nProp  := 0

		aEstru := Estrut(_cPrd,1)

		For i:=1 to len(aEstru)


			DbSelectArea("SG1")
			DbSetOrder(1)
			If DbSeek(xFilial("SG1")+aEstru[i,2]+aEstru[i,3])
				If  (dDataBase >= SG1->G1_INI .And. dDataBase <= SG1->G1_FIM)

					DbSelectArea("SB1")
					DbSetOrder(1)
					If DbSeek(xFilial("SB1")+aEstru[i,3])

						DbSelectArea("SG1")
						DbSetOrder(1)
						If !DbSeek(xFilial("SG1")+aEstru[i,3])


							If Select("SD1TMP") > 0
								DbSelectArea("SD1TMP")
								DbCloSeArea()
							Endif



							_cQuery    := " "
							_cQuery    += " SELECT SUM(D1_CUSTO) AS CUSTO, SUM(D1_QUANT) AS QUANT "
							_cQuery    += " FROM "+RETSQLNAME("SD1")+" SD1 , "+RetSqlName("SF1")+" SF1 "
							_cQuery    += " WHERE SD1.D1_FILIAL  BETWEEN '  ' AND 'ZZ' "
							//_cQuery    += " AND D1_DTDIGIT   BETWEEN '"+SubStr(dtos(_dPer),1,6)+"01"+"' AND '"+dtos(_dPer)+"' "

							If !Empty(_dPer)
								_cQuery    += " AND D1_DTDIGIT   <=  '"+dtos(_dPer)+"' "
							Else
								_cQuery    += " AND D1_DTDIGIT   <=  '"+dtos(msdate())+"' "
							Endif
							_cQuery    += " AND SD1.D1_TIPO      = 'N'"
							_cQuery    += " AND SD1.D1_TES <> '   '   "
							_cQuery    += " AND SD1.D1_COD       = '"+aEstru[i,3]+"' "
							_cQuery    += " AND SD1.D_E_L_E_T_ = ' ' "
							_cQuery    += " AND SF1.F1_FILIAL = D1_FILIAL "
							_cQuery    += " AND SF1.F1_SERIE  = D1_SERIE  "
							_cQuery    += " AND SF1.F1_DOC    = D1_DOC    "
							_cQuery    += " AND SF1.F1_FORNECE = D1_FORNECE "
							_cQuery    += " AND SF1.F1_LOJA    = D1_LOJA    "
							_cQuery    += " AND SF1.F1_DUPL     = D1_DOC    "
							_cQuery    += " AND SD1.D1_CUSTO > 0            "
							_cQuery    += " AND SF1.D_E_L_E_T_ <> '*'       "
							_cQuery    += " AND SD1.R_E_C_N_O_ = ( SELECT MAX(SD.R_E_C_N_O_) FROM "+RetSqlName("SD1")+" SD, "+RetSqlName("SF4")+" F4 "+" WHERE  SD.D1_COD='"+aEstru[i,3]+"' AND SD.D1_CUSTO > 0 AND SD.D_E_L_E_T_ <> '*' AND SD.D1_DTDIGIT   <=  '"+Iif(!Empty(_dPer),dtos(_dPer),dtos(msdate()))+"' AND SD.D1_TIPO      = 'N'  AND  SD.D1_TES <> '   ' AND SD.D1_TES=F4.F4_CODIGO AND F4.D_E_L_E_T_<>'*' AND F4.F4_DUPLIC='S' ) "



							TCQUERY _cQuery NEW ALIAS "SD1TMP"

							TCSETFIELD("SD1TMP","D1_CUSTO"  ,"N",13,2)
							TCSETFIELD("SD1TMP","D1_QUANT"  ,"N",13,2)

							DbSelectArea("SD1TMP")
							DbGotop()


							If SD1TMP->QUANT>0
								_nCusto += SD1TMP->CUSTO/ SD1TMP->QUANT
							Else

								If Select("TB9")>0
									DbSelectArea("TB9")
									DbCloSeArea()
								Endif

								_cQryB9:= " SELECT SB9.B9_VINI1,SB9.B9_QINI            "
								_cQryB9+= " FROM "+RetSqlName("SB9")+" SB9             "
								_cQryB9+= " WHERE SB9.D_E_L_E_T_ <> '*'           AND  "
								_cQryB9+= "       SB9.B9_DATA <='"+dtos(_dPer)+"' AND  "

								If !Empty(_dPer)
									_cQryB9+= "       SB9.B9_DATA <='"+dtos(_dPer)+"' AND  "
								Else
									_cQryB9   += " SB9.B9_DATA   <=  '"+dtos(msdate())+"' AND "
								Endif

								_cQryB9+= "       SB9.B9_COD ='"+aEstru[i,3]+"'        AND  "
								_cQryB9+= "       SB9.B9_QINI > 0 AND SB9.B9_VINI1 > 0    AND "


								_cQryB9+= " SB9.R_E_C_N_O_ IN (   "

								_cQryB9+= "  SELECT MAX(R_E_C_N_O_) "
								_cQryB9+= " FROM "+RetSqlName("SB9")+" SB9             "
								_cQryB9+= "  WHERE SB9.D_E_L_E_T_ <> '*'           AND "
								If !Empty(_dPer)
									_cQryB9+= "       SB9.B9_DATA <='"+dtos(_dPer)+"' AND  "
								Else
									_cQryB9   += " SB9.B9_DATA   <=  '"+dtos(msdate())+"' AND "
								Endif
								_cQryB9+= " SB9.B9_COD ='"+aEstru[i,3]+"'      AND "
								_cQryB9+= " SB9.B9_QINI > 0 AND SB9.B9_VINI1 > 0 ) "



								TCQUERY _cQryB9 NEW ALIAS "TB9"

								_nRec := 0
								DbEval({|| _nRec++  })

								DbSelectArea("TB9")
								DbGotop()
								If _nRec > 0
									_nCusto := TB9->B9_VINI1/TB9->B9_QINI
								Endif


							Endif


						Endif
					Endif
				Endif
			Endif
		Next i

	Endif

    /*

    //Busca movimentaçao do estoque
	If _nCusto <=0

		If Select("SD3TMP") > 0
			DbSelectArea("SD3TMP")
			DbCloSeArea()
		Endif


		_cQuery    := " "
		_cQuery    += " SELECT SUM(D3_CUSTO1) AS CUSTO,SUM(D3_QUANT) AS QUANT "
		_cQuery    += " FROM "+RETSQLNAME("SD3")
		_cQuery    += " WHERE D3_FILIAL  BETWEEN '  ' AND 'ZZ' "
		_cQuery    += " AND D3_EMISSAO   BETWEEN '"+SubStr(dtos(_dPer),1,6)+"01"+"' AND '"+dtos(_dPer)+"' "
		_cQuery    += " AND D3_COD       = '"+_cPrd+"' "

		If _nNivel ==2
			_cQuery    += " AND SUBSTR(D3_CF,1,2)='DE'     "
		ElseIf _nNivel ==1
			_cQuery    += " AND SUBSTR(D3_CF,1,2)='PR'     "
		Endif
		_cQuery    += " AND D3_ESTORNO <>'S'      "
		_cQuery    += " AND D_E_L_E_T_ = ' ' "


		TCQUERY _cQuery NEW ALIAS "SD3TMP"

		TCSETFIELD("SD3TMP","D3_CUSTO1"  ,"N",13,2)
		TCSETFIELD("SD3TMP","D3_QUANT"  ,"N",13,2)

		DbSelectArea("SD3TMP")
		DbGotop()

		If SD3TMP->QUANT>0
			_nCusto := SD3TMP->CUSTO/ SD3TMP->QUANT
		Endif

		DbSelectArea("SD3TMP")
		DbCloseArea("SD3TMP")



	Endif


//Busca o custo do fechamento do estoque
	If _nCusto <=0

		If Select("SB9TMP") > 0
			DbSelectArea("SB9TMP")
			DbCloSeArea()
		Endif


		_cQuery    := " "
		_cQuery    += " SELECT SUM(B9_VINI1) VINI, SUM(B9_QINI) QINI "
		_cQuery    += " FROM "+RETSQLNAME("SB9")
		_cQuery    += " WHERE B9_FILIAL  BETWEEN '  ' AND 'ZZ' "
		_cQuery    += " AND B9_DATA  BETWEEN '"+SubStr(dtos(_dPer),1,6)+"01"+"' AND '"+dtos(_dPer)+"' "
		_cQuery    += " AND B9_COD       = '"+_cPrd+"' "
		_cQuery    += " AND D_E_L_E_T_ = ' ' "
		_cQuery    += " ORDER BY B9_COD "

		TCQUERY _cQuery NEW ALIAS "SB9TMP"

		TCSETFIELD("SB9TMP","B9_VINI1"  ,"N",13,2)
		TCSETFIELD("SB9TMP","B9_QINI"  ,"N",13,2)

		DbSelectArea("SB9TMP")
		DbGotop()

		If SB9TMP->QINI>0
			_nCusto := SB9TMP->VINI / SB9TMP->QINI
		Endif

		DbSelectArea("SB9TMP")
		DbCloseArea("SB9TMP")
	Endif

*/


return(_nCusto)



// ---------+-------------------+--------------------------------------------------
// Projeto  : IF DO BRASIL
// Autor    : Cristiano Pereira - SIGAMAT
// Modulo   : SIGAGPE
// Função   : ExpotMsExcel
// Descrição: Gera Planilha Excel.
// Retorno  : Nenhum.
// ---------+-------------------+--------------------------------------------------
// Data     | Autor             | Descricao
// ---------+-------------------+--------------------------------------------------
// 19/03/20 | Cristiano Pereira   | Desenvolvimento da rotina.
// ---------+-------------------+--------------------------------------------------
User Function STCSTAJ(_cPrd,_dPer,_nNivel,_ndt,_aEstru)

	Local _aMOD     :={}
	Local _nCPl     := 0
	Local _nVAnt    := 0
	Local _nVAtu    := 0
	Local i
	Local linha
	Local _nLin
	Local _cQryB9

	_nCusto  := 0

	If _nNivel ==2

		If Select("SD1TMP") > 0
			DbSelectArea("SD1TMP")
			DbCloSeArea()
		Endif


		_cQuery    := " "
		_cQuery    += " SELECT SUM(D1_CUSTO) AS CUSTO, SUM(D1_QUANT) AS QUANT "
		_cQuery    += " FROM "+RETSQLNAME("SD1")+" SD1 , "+RetSqlName("SF1")+" SF1 "
		_cQuery    += " WHERE SD1.D1_FILIAL  BETWEEN '  ' AND 'ZZ' "
		//_cQuery    += " AND D1_DTDIGIT   BETWEEN '"+SubStr(dtos(_dPer),1,6)+"01"+"' AND '"+dtos(_dPer)+"' "
		_cQuery    += " AND D1_DTDIGIT   <=  '"+dtos(_dPer)+"' "
		_cQuery    += " AND SD1.D1_TIPO      = 'N'"
		_cQuery    += " AND SD1.D1_TES <> '   '   "
		_cQuery    += " AND SD1.D1_COD       = '"+_cPrd+"' "
		_cQuery    += " AND SD1.D_E_L_E_T_ = ' ' "
		_cQuery    += " AND SF1.F1_FILIAL = D1_FILIAL "
		_cQuery    += " AND SF1.F1_SERIE  = D1_SERIE  "
		_cQuery    += " AND SF1.F1_DOC    = D1_DOC    "
		_cQuery    += " AND SF1.F1_FORNECE = D1_FORNECE "
		_cQuery    += " AND SF1.F1_LOJA    = D1_LOJA    "
		_cQuery    += " AND SF1.F1_DUPL    = D1_DOC     "
		_cQuery    += " AND SD1.D1_CUSTO > 0            "
		_cQuery    += " AND SF1.D_E_L_E_T_ <> '*'       "
		_cQuery    += " AND SD1.R_E_C_N_O_ = ( SELECT MAX(SD.R_E_C_N_O_) FROM "+RetSqlName("SD1")+" SD, "+RetSqlName("SF4")+" F4 "+" WHERE  SD.D1_COD='"+_cPrd+"' AND SD.D1_CUSTO > 0 AND SD.D_E_L_E_T_ <> '*' AND SD.D1_DTDIGIT   <=  '"+dtos(_dPer)+"' AND SD.D1_TIPO      = 'N'  AND  SD.D1_TES <> '   '  AND SD.D1_TES=F4.F4_CODIGO AND F4.D_E_L_E_T_<>'*' AND F4.F4_DUPLIC='S' ) "



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

			_cQryB9:= " SELECT SB9.B9_VINI1,SB9.B9_QINI            "
			_cQryB9+= " FROM "+RetSqlName("SB9")+" SB9             "
			_cQryB9+= " WHERE SB9.D_E_L_E_T_ <> '*'           AND  "
			_cQryB9+= "       SB9.B9_DATA <='"+dtos(_dPer)+"' AND  "
			_cQryB9+= "       SB9.B9_COD ='"+_cPrd+"'       AND  "
			_cQryB9+= "       SB9.B9_QINI > 0 AND SB9.B9_VINI1 > 0  AND "


			_cQryB9+= " SB9.R_E_C_N_O_ IN (   "

			_cQryB9+= "  SELECT MAX(R_E_C_N_O_) "
			_cQryB9+= " FROM "+RetSqlName("SB9")+" SB9             "
			_cQryB9+= "  WHERE SB9.D_E_L_E_T_ <> '*'           AND "
			_cQryB9+= "       SB9.B9_DATA <='"+dtos(_dPer)+"' AND  "
			_cQryB9+= " SB9.B9_COD ='"+_cPrd+"'       AND "
			_cQryB9+= " SB9.B9_QINI > 0 AND SB9.B9_VINI1 > 0 ) "

			TCQUERY _cQryB9 NEW ALIAS "TB9"

			_nRec := 0
			DbEval({|| _nRec++  })

			DbSelectArea("TB9")
			DbGotop()
			If _nRec > 0
				_nCusto := TB9->B9_VINI1/TB9->B9_QINI
			Endif

		Endif



	Endif


	If _nNivel ==1//Explode custo do PAI

		nEstru := 0
		aEstru := {}
		_nProp  := 0

		aEstru := Estrut(_cPrd,1)



		For i:=1 to len(aEstru)

			_nCPl     := 0
			DbSelectArea("SG1")
			DbSetOrder(1)
			If DbSeek(xFilial("SG1")+aEstru[i,2]+aEstru[i,3])
				If  (dDataBase >= SG1->G1_INI .And. dDataBase <= SG1->G1_FIM)

					DbSelectArea("SB1")
					DbSetOrder(1)
					If DbSeek(xFilial("SB1")+aEstru[i,3])

						DbSelectArea("SG1")
						DbSetOrder(1)
						If !DbSeek(xFilial("SG1")+aEstru[i,3])

							If Select("SD1TMP") > 0
								DbSelectArea("SD1TMP")
								DbCloSeArea()
							Endif


							_cQuery    := " "
							_cQuery    += " SELECT SUM(D1_CUSTO) AS CUSTO, SUM(D1_QUANT) AS QUANT "
							_cQuery    += " FROM "+RETSQLNAME("SD1")+" SD1 , "+RetSqlName("SF1")+" SF1 "
							_cQuery    += " WHERE SD1.D1_FILIAL  BETWEEN '  ' AND 'ZZ' "
							//_cQuery    += " AND D1_DTDIGIT   BETWEEN '"+SubStr(dtos(_dPer),1,6)+"01"+"' AND '"+dtos(_dPer)+"' "

							If !Empty(_cMP)

								If Rtrim(_cMP)==RTrim(aEstru[i,3])
									If !Empty(_dPer)
										_cQuery    += " AND D1_DTDIGIT   <=  '"+dtos(_dPer)+"' "
									Else
										_cQuery    += " AND D1_DTDIGIT   <=  '"+dtos(msdate())+"' "
									Endif
								Else

									If !Empty(_dPer)
										_cQuery    += " AND D1_DTDIGIT   <=  '"+dtos(_dRedAt)+"' "
									Else
										_cQuery    += " AND D1_DTDIGIT   <=  '"+dtos(msdate())+"' "
									Endif

								Endif
							Else
								If !Empty(_dPer)
									_cQuery    += " AND D1_DTDIGIT   <=  '"+dtos(_dPer)+"' "
								Else
									_cQuery    += " AND D1_DTDIGIT   <=  '"+dtos(msdate())+"' "
								Endif
							Endif

							_cQuery    += " AND SD1.D1_TIPO      = 'N'"
							_cQuery    += " AND SD1.D1_TES <> '   '   "
							_cQuery    += " AND SD1.D1_COD       = '"+aEstru[i,3]+"' "
							_cQuery    += " AND SD1.D_E_L_E_T_ = ' ' "
							_cQuery    += " AND SF1.F1_FILIAL = D1_FILIAL "
							_cQuery    += " AND SF1.F1_SERIE  = D1_SERIE  "
							_cQuery    += " AND SF1.F1_DOC    = D1_DOC    "
							_cQuery    += " AND SF1.F1_DUPL   = D1_DOC    "
							_cQuery    += " AND SF1.F1_FORNECE = D1_FORNECE "
							_cQuery    += " AND SF1.F1_LOJA    = D1_LOJA    "
							_cQuery    += " AND SD1.D1_CUSTO > 0            "
							_cQuery    += " AND SF1.D_E_L_E_T_ <> '*'       "

							If !Empty(_cMP)
								If Rtrim(_cMP)==RTrim(aEstru[i,3])
									_cQuery    += " AND SD1.R_E_C_N_O_ = ( SELECT MAX(SD.R_E_C_N_O_) FROM "+RetSqlName("SD1")+" SD, "+RetSqlName("SF4")+" F4 "+" WHERE  SD.D1_COD='"+aEstru[i,3]+"' AND SD.D1_CUSTO > 0 AND SD.D_E_L_E_T_ <> '*' AND SD.D1_DTDIGIT   <=  '"+Iif(!Empty(_dPer),dtos(_dPer),dtos(msdate()))+"' AND SD.D1_TIPO      = 'N'  AND  SD.D1_TES <> '   ' AND SD.D1_TES=F4.F4_CODIGO AND F4.D_E_L_E_T_<>'*' AND F4.F4_DUPLIC='S' ) "
								Else
									_cQuery    += " AND SD1.R_E_C_N_O_ = ( SELECT MAX(SD.R_E_C_N_O_) FROM "+RetSqlName("SD1")+" SD, "+RetSqlName("SF4")+" F4 "+" WHERE  SD.D1_COD='"+aEstru[i,3]+"' AND SD.D1_CUSTO > 0 AND SD.D_E_L_E_T_ <> '*' AND SD.D1_DTDIGIT   <=  '"+Iif(!Empty(_dPer),dtos(_dRedAt),dtos(msdate()))+"' AND SD.D1_TIPO      = 'N'  AND  SD.D1_TES <> '   ' AND SD.D1_TES=F4.F4_CODIGO AND F4.D_E_L_E_T_<>'*' AND F4.F4_DUPLIC='S' ) "
								Endif
							Else
								_cQuery    += " AND SD1.R_E_C_N_O_ = ( SELECT MAX(SD.R_E_C_N_O_) FROM "+RetSqlName("SD1")+" SD, "+RetSqlName("SF4")+" F4 "+" WHERE  SD.D1_COD='"+aEstru[i,3]+"' AND SD.D1_CUSTO > 0 AND SD.D_E_L_E_T_ <> '*' AND SD.D1_DTDIGIT   <=  '"+Iif(!Empty(_dPer),dtos(_dPer),dtos(msdate()))+"' AND SD.D1_TIPO      = 'N'  AND  SD.D1_TES <> '   '  AND SD.D1_TES=F4.F4_CODIGO AND F4.D_E_L_E_T_<>'*' AND F4.F4_DUPLIC='S' ) "
							Endif


							TCQUERY _cQuery NEW ALIAS "SD1TMP"

							TCSETFIELD("SD1TMP","D1_CUSTO"  ,"N",13,2)
							TCSETFIELD("SD1TMP","D1_QUANT"  ,"N",13,2)

							DbSelectArea("SD1TMP")
							DbGotop()

							//Busca custo da planilha de excel
							for linha:=1 to len(_aEstru)

								If ValType(_aEstru[linha,6])=="N"
									If _cPrd==_aEstru[linha,1] .And._aEstru[linha,2]==aEstru[i,3] .And. _aEstru[linha,6]>0
										If _ndt==3
											_nCPl := _aEstru[linha,6]

										ElseIf _ndt==4
											_nCPl := _aEstru[linha,7]

										Endif
									Endif
								Endif
							Next linha


							If Type("_aFiltro")!="U"

								_nVAnt    := 0
								_nVAtu    := 0

								for _nLin:=1 to len(_aFiltro)
									If RTrim(aEstru[i,3])==RTrim(_aFiltro[_nLin,4])
										_nVAnt:= _aFiltro[_nLin,2]
										_nVAtu:= _aFiltro[_nLin,3]
									Endif
								Next _nLin

								If _nVAnt>0 .Or. _nVAtu>0
									If aEstru[i,1]==1
										DbSelectArea("SG1")
										DbSetOrder(1)
										DbSeek(xFilial("SG1")+aEstru[i,2]+aEstru[i,3])
										If _ndt==3
											_nCusto +=  _nVAnt*SG1->G1_QUANT
										ElseIf _ndt==4
											_nCusto +=  _nVAtu*SG1->G1_QUANT
										Endif
									Else

										If _ndt==3
											_nCusto +=  _nVAnt*aEstru[i,4]
										ElseIf _ndt==4
											_nCusto +=  _nVAtu*aEstru[i,4]
										Endif


									Endif

								Else
									If  _nCPl > 0
										If aEstru[i,1]==1
											DbSelectArea("SG1")
											DbSetOrder(1)
											DbSeek(xFilial("SG1")+aEstru[i,2]+aEstru[i,3])
											_nCusto +=  _nCPl*SG1->G1_QUANT
										Else
											_nCusto +=  _nCPl*aEstru[i,4]
										Endif
									Else
										If SD1TMP->QUANT>0
											If aEstru[i,1]==1
												DbSelectArea("SG1")
												DbSetOrder(1)
												DbSeek(xFilial("SG1")+aEstru[i,2]+aEstru[i,3])
												_nCusto += (SD1TMP->CUSTO/SD1TMP->QUANT)*SG1->G1_QUANT
											Else
												_nCusto += (SD1TMP->CUSTO/SD1TMP->QUANT)*aEstru[i,4]
											Endif

										Else


											//Busca custo na SB9
											If Select("TB9")>0
												DbSelectArea("TB9")
												DbCloSeArea()
											Endif

											_cQryB9:= " SELECT SB9.B9_VINI1,SB9.B9_QINI            "
											_cQryB9+= " FROM "+RetSqlName("SB9")+" SB9             "
											_cQryB9+= " WHERE SB9.D_E_L_E_T_ <> '*'           AND  "


											If !Empty(_dPer)
												_cQryB9    += " SB9.B9_DATA   <=  '"+dtos(_dPer)+"'     AND "
											Else
												_cQryB9    += " SB9.B9_DATA   <=  '"+dtos(msdate())+"'  AND "
											Endif

											_cQryB9+= "       SB9.B9_COD ='"+aEstru[i,3]+"'        AND  "
											_cQryB9+= "       SB9.B9_QINI > 0 AND SB9.B9_VINI1 > 0  AND "



											_cQryB9+= " SB9.R_E_C_N_O_ IN (   "

											_cQryB9+= "  SELECT MAX(R_E_C_N_O_) "
											_cQryB9+= " FROM "+RetSqlName("SB9")+" SB9             "
											_cQryB9+= "  WHERE SB9.D_E_L_E_T_ <> '*'           AND "
											If !Empty(_dPer)
												_cQryB9+= "       SB9.B9_DATA <='"+dtos(_dPer)+"' AND  "
											Else
												_cQryB9   += " SB9.B9_DATA   <=  '"+dtos(msdate())+"' AND "
											Endif
											_cQryB9+= " SB9.B9_COD ='"+aEstru[i,3]+"'      AND "
											_cQryB9+= " SB9.B9_QINI > 0 AND SB9.B9_VINI1 > 0 ) "

											TCQUERY _cQryB9 NEW ALIAS "TB9"

											_nRec := 0
											DbEval({|| _nRec++  })

											DbSelectArea("TB9")
											DbGotop()
											If _nRec > 0


												If aEstru[i,1]==1
													DbSelectArea("SG1")
													DbSetOrder(1)
													DbSeek(xFilial("SG1")+aEstru[i,2]+aEstru[i,3])
													_nCusto += (TB9->B9_VINI1/TB9->B9_QINI)*SG1->G1_QUANT
												Else
													_nCusto += (TB9->B9_VINI1/TB9->B9_QINI)*aEstru[i,4]
												Endif
											Endif
										Endif
									Endif
								Endif


							ElseIf  _nCPl > 0
								If aEstru[i,1]==1
									DbSelectArea("SG1")
									DbSetOrder(1)
									DbSeek(xFilial("SG1")+aEstru[i,2]+aEstru[i,3])
									_nCusto +=  _nCPl*SG1->G1_QUANT
								Else
									_nCusto +=  _nCPl*aEstru[i,4]
								Endif
							Else
								If SD1TMP->QUANT>0
									If aEstru[i,1]==1
										DbSelectArea("SG1")
										DbSetOrder(1)
										DbSeek(xFilial("SG1")+aEstru[i,2]+aEstru[i,3])
										_nCusto += (SD1TMP->CUSTO/SD1TMP->QUANT)*SG1->G1_QUANT
									Else
										_nCusto += (SD1TMP->CUSTO/SD1TMP->QUANT)*aEstru[i,4]
									Endif
								Else

									//Busca custo na SB9
									If Select("TB9")>0
										DbSelectArea("TB9")
										DbCloSeArea()
									Endif

									_cQryB9:= " SELECT SB9.B9_VINI1,SB9.B9_QINI            "
									_cQryB9+= " FROM "+RetSqlName("SB9")+" SB9             "
									_cQryB9+= " WHERE SB9.D_E_L_E_T_ <> '*'           AND  "


									If !Empty(_dPer)
										_cQryB9    += " SB9.B9_DATA   <=  '"+dtos(_dPer)+"'     AND "
									Else
										_cQryB9    += " SB9.B9_DATA   <=  '"+dtos(msdate())+"'  AND "
									Endif

									_cQryB9+= "       SB9.B9_COD ='"+aEstru[i,3]+"'        AND  "
									_cQryB9+= "       SB9.B9_QINI > 0 AND SB9.B9_VINI1 > 0 AND "


									_cQryB9+= " SB9.R_E_C_N_O_ IN (   "

									_cQryB9+= "  SELECT MAX(R_E_C_N_O_) "
									_cQryB9+= " FROM "+RetSqlName("SB9")+" SB9             "
									_cQryB9+= "  WHERE SB9.D_E_L_E_T_ <> '*'           AND "

									If !Empty(_dPer)
										_cQryB9+= "       SB9.B9_DATA <='"+dtos(_dPer)+"' AND  "
									Else
										_cQryB9   += " SB9.B9_DATA   <=  '"+dtos(msdate())+"' AND "
									Endif
									_cQryB9+= " SB9.B9_COD ='"+aEstru[i,3]+"'      AND "
									_cQryB9+= " SB9.B9_QINI > 0 AND SB9.B9_VINI1 > 0 ) "

									TCQUERY _cQryB9 NEW ALIAS "TB9"

									_nRec := 0
									DbEval({|| _nRec++  })

									DbSelectArea("TB9")
									DbGotop()
									If _nRec > 0

										If aEstru[i,1]==1
											DbSelectArea("SG1")
											DbSetOrder(1)
											DbSeek(xFilial("SG1")+aEstru[i,2]+aEstru[i,3])
											_nCusto += (TB9->B9_VINI1/TB9->B9_QINI)*SG1->G1_QUANT
										Else
											_nCusto += (TB9->B9_VINI1/TB9->B9_QINI)*aEstru[i,4]
										Endif
									Endif
								Endif
							Endif
						Endif
					Endif
				Endif
			Endif
		Next i

		//Explode custo da MOD

		nEstru      := 0
		aEstru      := {}
		_cTmpMod    := ""
		_nRegMod    := 0
		_cTmpFil    := ""


		aEstru := Estrut(_cPrd,1)

		aEstru := aSort(aEstru,,,{|x,y| x[2] < y[2] })

		u_STCSTAM(@_aMOD,_cPrd,1)

		For i:=1 to len(aEstru)

			If aEstru[i,1]==1

				DbSelectArea("SG1")
				DbSetOrder(1)
				If DbSeek(xFilial("SG1")+aEstru[i,2]+aEstru[i,3])
					If  (dDataBase >= SG1->G1_INI .And. dDataBase <= SG1->G1_FIM)
						DbSelectArea("SB1")
						If DbSeek(xFilial("SB1")+aEstru[i,3])  .And. !(RTrim(SB1->B1_COD)==RTrim(_cPrd))
							u_STCSTAM(@_aMOD,aEstru[i,3],aEstru[i,4])
						Endif
					Endif
				Endif

			Else

				DbSelectArea("SG1")
				DbSetOrder(1)
				If DbSeek(xFilial("SG1")+aEstru[i,2]+aEstru[i,3])
					If  (dDataBase >= SG1->G1_INI .And. dDataBase <= SG1->G1_FIM)
						DbSelectArea("SB1")
						If DbSeek(xFilial("SB1")+aEstru[i,3])  .And. !(RTrim(SB1->B1_COD)==RTrim(_cPrd))
							u_STCSTAM(@_aMOD,aEstru[i,3],aEstru[i,4])
						Endif
					Endif
				Endif
			Endif
		Next



		For linha:=1 to len(_aMOD)
			_nCusto+=_aMOD[linha,2]*u_STCSTAD(_aMOD[linha,1],_cModRef)
		Next linha


	Endif

    /*

    //Busca movimentaçao do estoque
	If _nCusto <=0

		If Select("SD3TMP") > 0
			DbSelectArea("SD3TMP")
			DbCloSeArea()
		Endif


		_cQuery    := " "
		_cQuery    += " SELECT SUM(D3_CUSTO1) AS CUSTO,SUM(D3_QUANT) AS QUANT "
		_cQuery    += " FROM "+RETSQLNAME("SD3")
		_cQuery    += " WHERE D3_FILIAL  BETWEEN '  ' AND 'ZZ' "
		_cQuery    += " AND D3_EMISSAO   BETWEEN '"+SubStr(dtos(_dPer),1,6)+"01"+"' AND '"+dtos(_dPer)+"' "
		_cQuery    += " AND D3_COD       = '"+_cPrd+"' "

		If _nNivel ==2
			_cQuery    += " AND SUBSTR(D3_CF,1,2)='DE'     "
		ElseIf _nNivel ==1
			_cQuery    += " AND SUBSTR(D3_CF,1,2)='PR'     "
		Endif
		_cQuery    += " AND D3_ESTORNO <>'S'      "
		_cQuery    += " AND D_E_L_E_T_ = ' ' "


		TCQUERY _cQuery NEW ALIAS "SD3TMP"

		TCSETFIELD("SD3TMP","D3_CUSTO1"  ,"N",13,2)
		TCSETFIELD("SD3TMP","D3_QUANT"  ,"N",13,2)

		DbSelectArea("SD3TMP")
		DbGotop()

		If SD3TMP->QUANT>0
			_nCusto := SD3TMP->CUSTO/ SD3TMP->QUANT
		Endif

		DbSelectArea("SD3TMP")
		DbCloseArea("SD3TMP")



	Endif


//Busca o custo do fechamento do estoque
	If _nCusto <=0

		If Select("SB9TMP") > 0
			DbSelectArea("SB9TMP")
			DbCloSeArea()
		Endif


		_cQuery    := " "
		_cQuery    += " SELECT SUM(B9_VINI1) VINI, SUM(B9_QINI) QINI "
		_cQuery    += " FROM "+RETSQLNAME("SB9")
		_cQuery    += " WHERE B9_FILIAL  BETWEEN '  ' AND 'ZZ' "
		_cQuery    += " AND B9_DATA  BETWEEN '"+SubStr(dtos(_dPer),1,6)+"01"+"' AND '"+dtos(_dPer)+"' "
		_cQuery    += " AND B9_COD       = '"+_cPrd+"' "
		_cQuery    += " AND D_E_L_E_T_ = ' ' "
		_cQuery    += " ORDER BY B9_COD "

		TCQUERY _cQuery NEW ALIAS "SB9TMP"

		TCSETFIELD("SB9TMP","B9_VINI1"  ,"N",13,2)
		TCSETFIELD("SB9TMP","B9_QINI"  ,"N",13,2)

		DbSelectArea("SB9TMP")
		DbGotop()

		If SB9TMP->QINI>0
			_nCusto := SB9TMP->VINI / SB9TMP->QINI
		Endif

		DbSelectArea("SB9TMP")
		DbCloseArea("SB9TMP")
	Endif

*/


return(_nCusto)



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
User Function STCSTAD(_cPrd,_dPer)


	Local 	_nCusto  := 0
	Local cQuery	:= ""
	Local cAlias	:= "QRYSD3"
	Local _dPeriodo


	If !Empty(_dPer)
		_dPeriodo :=_dPer
	Else
		_dPeriodo := msdate()-32
	Endif

//Obtem os dados dos Movimentos
	cQuery := " SELECT SUM(D3_CUSTO1) AS CUSTO1,SUM(D3_QUANT) AS QUANT  "
	cQuery += " FROM "+RetSqlName("SD3")+" SD3 "
	cQuery += " INNER JOIN "+RetSqlName("SB1")+" SB1 ON B1_FILIAL = ' ' AND B1_COD = D3_COD AND SB1.D_E_L_E_T_= ' ' "
	cQuery += " WHERE "
	cQuery += " D3_FILIAL BETWEEN '  ' AND 'ZZ' AND                           "
	cQuery += " D3_COD ='"+_cPrd+"' AND                                       "
	cQuery += " D3_ESTORNO <> 'S' AND                                         "
	cQuery += " SUBSTR(D3_EMISSAO,1,6)='"+SubStr(Dtos(_dPeriodo),1,6)+"' AND  "
	cQuery += " SD3.D_E_L_E_T_= ' '                                           "


	cQuery := ChangeQuery(cQuery)

	//Verifica se o Alias esta aberto
	If Select(cAlias) > 0
		DbSelectArea(cAlias)
		(cAlias)->(DbCloseArea())
	EndIf

	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),cAlias, .F., .T.)


	TCSetField(cAlias,"B2_CM1"	 ,"N", 16, 6 )
	TCSetField(cAlias,"D3_QUANT" ,"N", 16, 2 )
	TCSetField(cAlias,"D3_CUSTO1","N", 16, 2 )

	dbSelectArea(cAlias)
	(cAlias)->(DbGoTop())

	If (cAlias)->QUANT > 0
		_nCusto 	:= (cAlias)->CUSTO1/(cAlias)->QUANT
	Endif


return(_nCusto)


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
Static Function STCSTAE(_cPrd,_dPer)


	Local 	_nVol  := 0
	Local 	_cQry	:= ""



	If Select("TD3") > 0
		DbSelectArea("TD3")
		DbCloseArea()
	Endif

	_cQry :=  " SELECT SUM(SD3.D3_QUANT ) AS QUANT                  "
	_cQry +=  " FROM "+RetSqlName("SD3")+" SD3                      "
	_cQry +=  " WHERE  "
	_cQry +=  "       SD3.D_E_L_E_T_ <> '*'                     AND "
	_cQry +=  "       SD3.D3_EMISSAO>='"+Dtos(msdate()-365)+"'  AND "
	_cQry +=  "       SD3.D3_ESTORNO <> 'S'                     AND "
	_cQry +=  "       SUBSTR(SD3.D3_CF,1,2) ='PR'               AND "
	_cQry +=  "       SD3.D3_COD   ='"+_cPrd+"'                  "


	TCQUERY  _cQry  NEW ALIAS "TD3"

	_nRec := 0
	DbEval({|| _nRec++  })

	DbSelectArea("TD3")
	DbGotop()

	_nVol := TD3->QUANT


return(_nVol)




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ STCSTAB³ Autor ³ Ricardo Berti         ³ Data ³17/05/2006³±±
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
User function STCSTAG(_aEstru)

	Local _aCabec   := {}
	Local aDados    := {}
	Local linha
	Local _cMOD     := " "
	Local _aCampos  := {}
	Local _nReg     := 0
	Local _cPai     :=""
	Local _nPai     := 0
	Local _aMOD     :={}
	Local _aFiltro  :={}
	Local _nlin     := 0
	Local _lEntra
	Local i

	_aCabec := {"PRODUTO PAI","COMPONENTE","DESCRIÇÃO","QUANTIDADE","CUSTO MP","CUSTO MÉDIO","TOTAL","VOLUME APONTADO","-------","PRODUTO PAI","COMPONENTE","DESCRIÇÃO","QUANTIDADE","CUSTO MP","CUSTO MÉDIO","TOTAL","VOLUME APONTADO"}

	_aCampos:= {  ;
		{"FILIAL" ,"C",02,0     } ,;
		{"PAI" ,"C",15,0    } ,;
		{"COMP" ,"C",15,0       } ,;
		{"SEQ" ,"C",03,0     } ,;
		{"QTD"  ,"N",15,6     } ,;
		{"MP","C",15,0          },;
		{"OBS","C",15,0          },;
		{"FILTRA","C",15,0          }}

	// Fecha arquivo temporario
	If Select("TRB") > 0
		DbSelectArea("TRB")
		DbCLoseArea()
	Endif

	_cArq := CriaTrab(_aCampos,.t.)
	dbUseArea(.T.,,_cArq,"TRB",.F.,.F.)

	_cIndTrb  := CriaTrab(Nil,.F.)
	_cChave1  := "FILIAL+PAI+COMP+SEQ"
	IndRegua("TRB",_cIndTrb,_cChave1,,,)


	_aEstru := aSort(_aEstru,,,{|x,y| x[1] < y[1] })

	ProcRegua(RecCount())


	//###########################
	// Reinderização do Array
	//###########################
	for linha:=1 to len(_aEstru)
		If Rtrim(_aEstru[linha,2])==Rtrim(_cMP)
			AADD(_aFiltro,{_aEstru[linha,1]})
		Endif
	Next linha



	for linha:=1 to len(_aEstru)

		_nReg   := _nReg  + 1
		_lEntra :=IIF(!Empty(_cMP),.F.,.T.)

		for _nLin:=1 to len(_aFiltro)
			If RTrim(_aEstru[linha,1])==RTrim(_aFiltro[_nLin,1])
				_lEntra :=.T.
			Endif
		Next _nLin

		IncProc("Inicializando processo , para a geração do arquivo excel:"+ Str(_nReg))


		If !Empty(_cMP)

			If  _lEntra

				DbSelectArea("TRB")
				DbSetOrder(1)

				If Reclock("TRB",.t.)
					TRB->FILIAL:= xFilial("SD3")
					TRB->PAI :=  _aEstru[linha,1]
					TRB->COMP := _aEstru[linha,2]
					TRB->SEQ := _aEstru[linha,3]
					TRB->QTD := _aEstru[linha,4]
					TRB->MP  := _aEstru[linha,2]
					TRB->OBS := _aEstru[linha,6]
					MsUnlock()
				Endif
			Endif

		Else

			DbSelectArea("TRB")
			DbSetOrder(1)

			If Reclock("TRB",.t.)
				TRB->FILIAL:= xFilial("SD3")
				TRB->PAI :=  _aEstru[linha,1]
				TRB->COMP := _aEstru[linha,2]
				TRB->SEQ := _aEstru[linha,3]
				TRB->QTD := _aEstru[linha,4]
				TRB->MP  := _aEstru[linha,2]
				TRB->OBS := _aEstru[linha,6]
				MsUnlock()
			Endif

		Endif



	Next linha






	aAdd(aDados, {;
		"",;
		"",;
		"REFERÊNCIA "+Dtoc(_dRedDe),;
		"",;
		'',;
		'',;
		'',;
		'',;
		'',;
		'',;
		'',;
		"REFERÊNCIA "+Dtoc(_dRedAt),;
		'',;
		'',;
		'',;
		'',;
		'';
		})


	DbSelectArea("TRB")
	DbGoTop()
	DbSetOrder(1)

	_nReg := 0
	ProcRegua(RecCount())
	While !TRB->(EOF())

		_cPai :=TRB->PAI
		_cMOD := ""
		_nPai  := 0


		While _cPai ==TRB->PAI


			IncProc("Geração do arquivo excel, em andamento..:"+ Str(_nReg))

			If RTrim(TRB->OBS)=="Pai" .And. _nPai ==0

				aAdd(aDados, {;
					TRB->PAI,;
					"",;
					Posicione("SB1",1,xFilial("SB1")+TRB->PAI,"B1_DESC"),;
					1,;
					'',;
					u_STCSTAC(TRB->PAI,_dRedDe,1),;
					Transform(1*u_STCSTAJ(TRB->PAI,_dRedDe,1,3,_aEstru), "@E 9999,9999.99999999" ) ,;
					STCSTAE(TRB->PAI,''),;
					'-----------',;
					TRB->PAI,;
					'',;
					Posicione("SB1",1,xFilial("SB1")+TRB->PAI,"B1_DESC"),;
					1,;
					'',;
					u_STCSTAC(TRB->PAI,_dRedAt,1),;
					Transform(1*u_STCSTAJ(TRB->PAI,_dRedAt,1,4,_aEstru), "@E 9999,9999.99999999" ),;
					STCSTAE(TRB->PAI,'');
					})


				_nPai++
			Endif


			If SubStr(nObj,1,1)=="A"

				DbSelectArea("SB1")
				DbSetOrder(1)
				If DbSeek(xFilial("SB1")+TRB->MP)

					DbSelectARea("SG1")
					DbSetOrder(1)
					If !DbSeek(xFilial("SG1")+TRB->MP)

						If !Empty(_cMP)

							If RTrim(TRB->MP)==RTrim(_cMP)
								aAdd(aDados, {;
									TRB->PAI,;
									TRB->MP,;
									Posicione("SB1",1,xFilial("SB1")+TRB->MP,"B1_DESC"),;
									TRB->QTD,;
									'',;
									u_STCSTAC(TRB->MP,_dRedDe,2),;
									Transform(TRB->QTD*u_STCSTAC(TRB->MP,_dRedDe,2,3), "@E 9999,9999.99999999" ),;
									0,;
									TRB->PAI,;
									TRB->MP,;
									Posicione("SB1",1,xFilial("SB1")+TRB->MP,"B1_DESC"),;
									'',;
									TRB->QTD,;
									'',;
									u_STCSTAC(TRB->MP,_dRedAt,2),;
									Transform(TRB->QTD*u_STCSTAC(TRB->MP,_dRedAt,2,4), "@E 9999,9999.99999999" ),;
									0;
									})
							Else

								aAdd(aDados, {;
									TRB->PAI,;
									TRB->MP,;
									Posicione("SB1",1,xFilial("SB1")+TRB->MP,"B1_DESC"),;
									TRB->QTD,;
									'',;
									u_STCSTAC(TRB->MP,_dRedAt,2),;
									Transform(TRB->QTD*u_STCSTAC(TRB->MP,_dRedAt,2,3), "@E 9999,9999.99999999" ),;
									0,;
									TRB->PAI,;
									TRB->MP,;
									Posicione("SB1",1,xFilial("SB1")+TRB->MP,"B1_DESC"),;
									'',;
									TRB->QTD,;
									'',;
									u_STCSTAC(TRB->MP,_dRedAt,2),;
									Transform(TRB->QTD*u_STCSTAC(TRB->MP,_dRedAt,2,4), "@E 9999,9999.99999999" ),;
									0;
									})

							Endif

						Else

							aAdd(aDados, {;
								TRB->PAI,;
								TRB->MP,;
								Posicione("SB1",1,xFilial("SB1")+TRB->MP,"B1_DESC"),;
								TRB->QTD,;
								'',;
								u_STCSTAC(TRB->MP,_dRedDe,2),;
								Transform(TRB->QTD*u_STCSTAC(TRB->MP,_dRedDe,2,3), "@E 9999,9999.99999999" ),;
								0,;
								TRB->PAI,;
								TRB->MP,;
								Posicione("SB1",1,xFilial("SB1")+TRB->MP,"B1_DESC"),;
								'',;
								TRB->QTD,;
								'',;
								u_STCSTAC(TRB->MP,_dRedAt,2),;
								Transform(TRB->QTD*u_STCSTAC(TRB->MP,_dRedAt,2,4), "@E 9999,9999.99999999" ),;
								0;
								})
						Endif
					Endif
				Endif
			Endif
			_nReg   := _nReg  + 1
			DbSelectArea("TRB")
			DbSkip()
		Enddo

		If SubStr(nObj,1,1)=="A"


			nEstru := 0
			aEstru := {}
			aEstru := Estrut(_cPai,1)
			_aMOD     :={}


			u_STCSTAM(@_aMOD,_cPai,1)

			aEstru := aSort(aEstru,,,{|x,y| x[2] < y[2] })

			For i:=1 to len(aEstru)


				If aEstru[i,1]==1

					DbSelectArea("SG1")
					DbSetOrder(1)
					If DbSeek(xFilial("SG1")+aEstru[i,2]+aEstru[i,3])
						If  (dDataBase >= SG1->G1_INI .And. dDataBase <= SG1->G1_FIM)
							DbSelectArea("SB1")
							If DbSeek(xFilial("SB1")+aEstru[i,3])  .And. !(RTrim(SB1->B1_COD)==RTrim(_cPai))
								u_STCSTAM(@_aMOD,aEstru[i,3],aEstru[i,4])
							Endif
						Endif
					Endif

				Else

					DbSelectArea("SG1")
					DbSetOrder(1)
					If DbSeek(xFilial("SG1")+aEstru[i,2]+aEstru[i,3])
						If  (dDataBase >= SG1->G1_INI .And. dDataBase <= SG1->G1_FIM)
							DbSelectArea("SB1")
							If DbSeek(xFilial("SB1")+aEstru[i,3])  .And. !(RTrim(SB1->B1_COD)==RTrim(_cPai))
								u_STCSTAM(@_aMOD,aEstru[i,3],aEstru[i,4])
							Endif
						Endif
					Endif
				Endif
			Next

			For linha:=1 to len(_aMOD)

				aAdd(aDados, {;
					"",;
					_aMOD[linha,1],;
					Posicione("SB1",1,xFilial("SB1")+_aMOD[linha,1],"B1_DESC"),;
					Transform(_aMOD[linha,2],"@E 9999,9999.99999999" ),;
					'',;
					u_STCSTAD(_aMOD[linha,1],_cModRef),;
					Transform(_aMOD[linha,2]*u_STCSTAD(_aMOD[linha,1],_cModRef), "@E 9999,9999.99999999" ),;
					0,;
					'',;
					_aMOD[linha,1],;
					Posicione("SB1",1,xFilial("SB1")+_aMOD[linha,1],"B1_DESC"),;
					'',;
					Transform(_aMOD[linha,2],"@E 9999,9999.99999999" ),;
					'',;
					u_STCSTAD(_aMOD[linha,1],_cModRef),;
					Transform(_aMOD[linha,2]*u_STCSTAD(_aMOD[linha,1],_cModRef), "@E 9999,9999.99999999" ),;
					0;
					})

			Next linha
		Endif


		aAdd(aDados, {;
			"",;
			"",;
			"",;
			"",;
			'',;
			'',;
			'',;
			'',;
			'',;
			'',;
			'',;
			'',;
			'',;
			'',;
			'',;
			'',;
			'';
			})


	Enddo

//###############################
//Elimina arquivo de trabalho   #
//###############################
	FERASE(_cArq+".DBF")
	FERASE(_cArq+".IDX")


	if Len(aDados) > 0
		FWMsgRun(,{|| ExpotMsExcel(_aCabec, aDados) },,"Aguarde, montando planilha")
	Endif

return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ STCSTAM³ Autor ³ Ricardo Berti         ³ Data ³17/05/2006³±±
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

User Function STCSTAM(_aMOD,cProduto,_nQtd)

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


				For i:= 1 to len(_aMOD)
					If  RTrim(_aMOD[i,1])==RTrim("MOD"+SH1->H1_CCUSTO)
						_lgrava:= .F.
						_aMOD[i,2]+=nTemp
					Endif
				Next i

				If _lgrava
					AADD(_aMOD,{"MOD"+SH1->H1_CCUSTO,nTemp})
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


return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ STCSTO01 ³ Autor ³ Cristiano Pereira     ³ Data ³ 20/12/03 ³±±
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

User Function STCST01Y()

	Local _aEstru := {}
	Local _aCpyEs := {}



	If Empty(_dRedDe)
		MsgInfo("Por favor, Informe a data de refência anterior.","Atenção")
		return
	Endif

	If Empty(_dRedAt)
		MsgInfo("Por favor, Informe a data de refência atual.","Atenção")
		return
	Endif


	If Empty(_cModRef)
		MsgInfo("Por favor, Informe a data de refência da MOD.","Atenção")
		return
	Endif

	If Empty(nObj)
		MsgInfo("Por favor, Informe o tipo do processamento.","Atenção")
		return
	Endif

	Processa({|lEnd| _aCpyEs :=	u_STCSTYA(@_aEstru) },"Explosão da Estrutura arquivo","Simulação custo matéria prima",.T.)
	Processa({|lEnd| u_STCSTAG(_aCpyEs)},"Processando registros da estrutua para gerar a planilha excel","Aguarde...",.T.)


return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ STCSTYA ³ Autor ³ Cristiano Pereira     ³ Data ³ 20/12/03 ³±±
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
User function STCSTYA(_aEstru)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declara variaveis.														 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Local aTxt    := {}						//Array com os campos enviados no TXT.
	Local nHandle := 0						//Handle do arquivo texto.
	Local cArqImp := ""						//Arquivo Txt a ser lido.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posiciona areas.														 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	SG1->(dbSetOrder(1))  //CNPJ do Fornecedor

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Busca o arquivo para leitura.											 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cArqImp := cGetFile("Arquivo .CSV |*.CSV","Selecione o Arquivo CSV",0,"",.T.,GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE)
	If (nHandle := FT_FUse(cArqImp))== -1
		MsgInfo("Erro ao tentar abrir arquivo.","Atenção")
		Return
	EndIf

	Processa({|lEnd| LeTXTPA(aTxt,@_aEstru)},"Aguarde, lendo arquivo de acumulados...")

return(_aEstru)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ IMPFORN   ºAutor ³Cristiano Pereira           º Data ³  28/01/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Le o Txt e carrega os dados.				                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MP8                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function LeTXTPA(aTxt,_aEstru)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declara variaveis.														 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Local cLinha  := ""						//Linha do arquivo texto a ser tratada.
	Local nReg    := 0

	FT_FGOTOP()
	aTxt := {}
	While !FT_FEOF()
		nReg++
		IncProc("Registro:"+ Str(nReg))
		cLinha := FT_FREADLN()

		cLinha := Upper(NoAcento(AnsiToOem(cLinha)))
		AADD(aTxt,{})
		While At(";",cLinha) > 0
			aAdd(aTxt[Len(aTxt)],AllTrim(Substr(cLinha,1,At(";",cLinha)-1)))
			cLinha := StrTran(Substr(cLinha,At(";",cLinha)+1,Len(cLinha)-At(";",cLinha)),'"','')
		EndDo
		cLinha := StrTran(Substr(cLinha,1,Len(cLinha)),',','.')
		aAdd(aTxt[Len(aTxt)],AllTrim(StrTran(Substr(cLinha,1,Len(cLinha)),'"','')))
		FT_FSKIP()
	EndDo
	GraPADados(aTxt,@_aEstru)
	FT_FUSE()

Return(_aEstru)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ GravaDados  ºAutor ³Cristiano Pereira    Data ³  28/01/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Grava os dados lidos			                  			  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MP8                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GraPADados(aTxt,_aEstru)

	Local nX    	  := 0
	Local _cQryG1 :=  ""
	//Private lMsErroAuto := .F.
	Private aCabec   := {}
	public  _lProcess := .T.

	For nX := 1 to Len(aTxt)


		If Select("TG1") > 0
			DbSelectArea("TG1")
			DbCloSeArea()
		Endif

		_cQryG1 := " SELECT	B1_FILIAL,B1_COD,G1_COD "
		_cQryG1 += " FROM "+RetSqlName("SB1")+" SB1 "
		_cQryG1 += " JOIN "+RetSqlName("SG1")+" SG1 "
		_cQryG1 += " ON	G1_FILIAL = '"+xFilial("SG1")+"' AND     "
		_cQryG1 += "	G1_COD   = B1_COD               AND     "
		_cQryG1 += " 	SG1.D_E_L_E_T_ <> '*'                    "
		_cQryG1 += " WHERE	B1_FILIAL = '"+xFilial("SB1")+"' AND "
		_cQryG1 += " 		B1_COD   = '"+aTxt[nX,1]+"'  AND  RTRIM(B1_TIPO) IN ('PA')   AND    "
		If SubStr(nFitr,1,1)=="S"
			_cQryG1 += "        LTRIM(RTRIM(B1_XINFMP)) ='S'     AND    "
		Endif
		_cQryG1 += " 		SB1.D_E_L_E_T_ <> '*'                                        "

		_cQryG1 += " GROUP BY B1_FILIAL,B1_COD,G1_COD  "

		_cQryG1 += " ORDER BY G1_COD                   "

		TCQUERY  _cQryG1 NEW ALIAS "TG1"

		_nRec := 0
		DbEval({|| _nRec++  })


		DbSelectArea("TG1")
		DbGotop()
		While !TG1->(EOF())
			_lProcess := .T.
			If SB1->(dbSeek(xFilial("SB1")+TG1->G1_COD))

				MStruPai(@_aEstru,TG1->G1_COD,TG1->B1_COD)

			Endif
			TG1->(DbSkip())
		Enddo

	Next nx

Return(_aEstru)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ STCSTWB³ Autor ³ Ricardo Berti         ³ Data ³17/05/2006³±±
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
User function STCSTWB(_aEstru,_aMp)

	Local _aCabec   := {}
	Local aDados    := {}
	Local linha
	Local _cMOD     := " "
	Local _aCampos  := {}
	Local _nReg     := 0
	Local _cPai     :=""
	Local _nPai     := 0
	Local _aMOD     :={}
	Local _nlin     := 0
	Local _lEntra
	Local _nli1n    := 0
	Local i
	Private _aFiltro  :={}
	Private _nCAnt:=_nCAtu:=0


	_aCabec := {"PRODUTO PAI","COMPONENTE","DESCRIÇÃO","QUANTIDADE","CUSTO MP","CUSTO MÉDIO","TOTAL","VOLUME APONTADO","-------","PRODUTO PAI","COMPONENTE","DESCRIÇÃO","QUANTIDADE","CUSTO MP","CUSTO MÉDIO","TOTAL","VOLUME APONTADO"}

	_aCampos:= {  ;
		{"FILIAL" ,"C",02,0     } ,;
		{"PAI" ,"C",15,0    } ,;
		{"COMP" ,"C",15,0       } ,;
		{"SEQ" ,"C",03,0     } ,;
		{"QTD"  ,"N",15,6     } ,;
		{"MP","C",15,0          },;
		{"OBS","C",15,0          },;
		{"FILTRA","C",15,0          }}

	// Fecha arquivo temporario
	If Select("TRB") > 0
		DbSelectArea("TRB")
		DbCLoseArea()
	Endif

	_cArq := CriaTrab(_aCampos,.t.)
	dbUseArea(.T.,,_cArq,"TRB",.F.,.F.)

	_cIndTrb  := CriaTrab(Nil,.F.)
	_cChave1  := "FILIAL+PAI+COMP+SEQ"
	IndRegua("TRB",_cIndTrb,_cChave1,,,)


	_aEstru := aSort(_aEstru,,,{|x,y| x[1] < y[1] })

	ProcRegua(RecCount())


	//###########################
	// Reinderização do Array
	//###########################
	for linha:=1 to len(_aEstru)
		For _nli1n:=1 to len(_aMp)

			If Rtrim(_aMp[_nli1n,4])=="VAZIO"
				If Rtrim(_aEstru[linha,2])==Rtrim(_aMp[_nli1n,1])
					AADD(_aFiltro,{_aEstru[linha,1],_aMp[_nli1n,2],_aMp[_nli1n,3],_aEstru[linha,2]})
				Endif
			Else
				If Rtrim(_aEstru[linha,1])==Rtrim(_aMp[_nli1n,4])
					If Rtrim(_aEstru[linha,2])==Rtrim(_aMp[_nli1n,1])
						AADD(_aFiltro,{_aEstru[linha,1],_aMp[_nli1n,2],_aMp[_nli1n,3],_aEstru[linha,2]})
					Endif
				Endif
			Endif
		Next _nli1n
	Next linha



	for linha:=1 to len(_aEstru)

		_nReg   := _nReg  + 1
		_lEntra :=.F.

		for _nLin:=1 to len(_aFiltro)
			If RTrim(_aEstru[linha,1])==RTrim(_aFiltro[_nLin,1])
				_lEntra :=.T.
			Endif
		Next _nLin

		IncProc("Inicializando processo , para a geração do arquivo excel:"+ Str(_nReg))


		If !Empty(_cMP)

			If  _lEntra

				DbSelectArea("TRB")
				DbSetOrder(1)

				If Reclock("TRB",.t.)
					TRB->FILIAL:= xFilial("SD3")
					TRB->PAI :=  _aEstru[linha,1]
					TRB->COMP := _aEstru[linha,2]
					TRB->SEQ := _aEstru[linha,3]
					TRB->QTD := _aEstru[linha,4]
					TRB->MP  := _aEstru[linha,2]
					TRB->OBS := _aEstru[linha,6]
					MsUnlock()
				Endif
			Endif

		Else

			If _lEntra

				DbSelectArea("TRB")
				DbSetOrder(1)

				If Reclock("TRB",.t.)
					TRB->FILIAL:= xFilial("SD3")
					TRB->PAI :=  _aEstru[linha,1]
					TRB->COMP := _aEstru[linha,2]
					TRB->SEQ := _aEstru[linha,3]
					TRB->QTD := _aEstru[linha,4]
					TRB->MP  := _aEstru[linha,2]
					TRB->OBS := _aEstru[linha,6]
					MsUnlock()
				Endif
			Endif

		Endif
	Next linha

	aAdd(aDados, {;
		"",;
		"",;
		"REFERÊNCIA "+Dtoc(_dRedDe),;
		"",;
		'',;
		'',;
		'',;
		'',;
		'',;
		'',;
		'',;
		"REFERÊNCIA "+Dtoc(_dRedAt),;
		'',;
		'',;
		'',;
		'',;
		'';
		})


	DbSelectArea("TRB")
	DbGoTop()
	DbSetOrder(1)

	_nReg := 0
	ProcRegua(RecCount())
	While !TRB->(EOF())

		_cPai :=TRB->PAI
		_cMOD := ""
		_nPai  := 0


		While _cPai ==TRB->PAI

			_nCAnt:=_nCAtu:=0


			for _nLin:=1 to len(_aFiltro)
				If RTrim(TRB->MP)==RTrim(_aFiltro[_nLin,4])
					_nCAnt:= _aFiltro[_nLin,2]
					_nCAtu:= _aFiltro[_nLin,3]
				Endif
			Next _nLin


			IncProc("Geração do arquivo excel, em andamento..:"+ Str(_nReg))

			If RTrim(TRB->OBS)=="Pai" .And. _nPai ==0

				aAdd(aDados, {;
					TRB->PAI,;
					"",;
					Posicione("SB1",1,xFilial("SB1")+TRB->PAI,"B1_DESC"),;
					1,;
					'',;
					u_STCSTAC(TRB->PAI,_dRedDe,1),;
					Transform(1*u_STCSTAJ(TRB->PAI,_dRedDe,1,3,_aEstru), "@E 9999,9999.99999999" ) ,;
					STCSTAE(TRB->PAI,''),;
					'-----------',;
					TRB->PAI,;
					'',;
					Posicione("SB1",1,xFilial("SB1")+TRB->PAI,"B1_DESC"),;
					1,;
					'',;
					u_STCSTAC(TRB->PAI,_dRedAt,1),;
					Transform(1*u_STCSTAJ(TRB->PAI,_dRedAt,1,4,_aEstru),"@E 9999,9999.99999999" ),;
					STCSTAE(TRB->PAI,'');
					})
				_nPai++
			Endif


			If SubStr(nObj,1,1)=="A"

				DbSelectArea("SB1")
				DbSetOrder(1)
				If DbSeek(xFilial("SB1")+TRB->MP)

					DbSelectARea("SG1")
					DbSetOrder(1)
					If !DbSeek(xFilial("SG1")+TRB->MP)

						If !Empty(_cMP)

							If RTrim(TRB->MP)==RTrim(_cMP)
								aAdd(aDados, {;
									TRB->PAI,;
									TRB->MP,;
									Posicione("SB1",1,xFilial("SB1")+TRB->MP,"B1_DESC"),;
									TRB->QTD,;
									'',;
									IIf(_nCAnt>0,_nCAnt,u_STCSTAC(TRB->MP,_dRedDe,2)),;
									Transform(TRB->QTD*If(_nCAnt>0,_nCAnt,u_STCSTAC(TRB->MP,_dRedDe,2,3)), "@E 9999,9999.99999999" ),;
									0,;
									TRB->PAI,;
									TRB->MP,;
									Posicione("SB1",1,xFilial("SB1")+TRB->MP,"B1_DESC"),;
									'',;
									TRB->QTD,;
									'',;
									IIf(_nCAtu>0,_nCAtu,u_STCSTAC(TRB->MP,_dRedAt,2)),;
									Transform(TRB->QTD*If(_nCAtu>0,_nCAtu,u_STCSTAC(TRB->MP,_dRedAt,2,4)), "@E 9999,9999.99999999"),;
									0;
									})
							Else

								aAdd(aDados, {;
									TRB->PAI,;
									TRB->MP,;
									Posicione("SB1",1,xFilial("SB1")+TRB->MP,"B1_DESC"),;
									TRB->QTD,;
									'',;
									IIF(_nCAtu>0,_nCAtu,u_STCSTAC(TRB->MP,_dRedAt,2)),;
									Transform(TRB->QTD*IIF(_nCAtu>0,_nCAtu,u_STCSTAC(TRB->MP,_dRedAt,2,3)), "@E 9999,9999.99999999" ),;
									0,;
									TRB->PAI,;
									TRB->MP,;
									Posicione("SB1",1,xFilial("SB1")+TRB->MP,"B1_DESC"),;
									'',;
									TRB->QTD,;
									'',;
									IIF(_nCAtu>0,_nCAtu,u_STCSTAC(TRB->MP,_dRedAt,2)),;
									Transform(TRB->QTD*IIF(_nCAtu>0,_nCAtu,u_STCSTAC(TRB->MP,_dRedAt,2,4)), "@E 9999,9999.99999999" ),;
									0;
									})

							Endif

						Else

							aAdd(aDados, {;
								TRB->PAI,;
								TRB->MP,;
								Posicione("SB1",1,xFilial("SB1")+TRB->MP,"B1_DESC"),;
								TRB->QTD,;
								'',;
								IIF(_nCAnt>0,_nCAnt,u_STCSTAC(TRB->MP,_dRedDe,2)),;
								Transform(TRB->QTD*IIF(_nCAnt>0,_nCAnt,u_STCSTAC(TRB->MP,_dRedDe,2,3)), "@E 9999,9999.99999999" ),;
								0,;
								TRB->PAI,;
								TRB->MP,;
								Posicione("SB1",1,xFilial("SB1")+TRB->MP,"B1_DESC"),;
								'',;
								TRB->QTD,;
								'',;
								IIF(_nCAtu>0,_nCAtu,u_STCSTAC(TRB->MP,_dRedAt,2)),;
								Transform(TRB->QTD*IIF(_nCAtu>0,_nCAtu,u_STCSTAC(TRB->MP,_dRedAt,2,4)), "@E 9999,9999.99999999" ),;
								0;
								})
						Endif
					Endif
				Endif
			Endif


			_nReg   := _nReg  + 1
			DbSelectArea("TRB")
			DbSkip()
		Enddo

		If SubStr(nObj,1,1)=="A"


			nEstru := 0
			aEstru := {}
			aEstru := Estrut(_cPai,1)
			_aMOD     :={}


			u_STCSTAM(@_aMOD,_cPai,1)

			aEstru := aSort(aEstru,,,{|x,y| x[2] < y[2] })

			For i:=1 to len(aEstru)


				If aEstru[i,1]==1

					DbSelectArea("SG1")
					DbSetOrder(1)
					If DbSeek(xFilial("SG1")+aEstru[i,2]+aEstru[i,3])
						If  (dDataBase >= SG1->G1_INI .And. dDataBase <= SG1->G1_FIM)
							DbSelectArea("SB1")
							If DbSeek(xFilial("SB1")+aEstru[i,3])  .And. !(RTrim(SB1->B1_COD)==RTrim(_cPai))
								u_STCSTAM(@_aMOD,aEstru[i,3],aEstru[i,4])
							Endif
						Endif
					Endif

				Else

					DbSelectArea("SG1")
					DbSetOrder(1)
					If DbSeek(xFilial("SG1")+aEstru[i,2]+aEstru[i,3])
						If  (dDataBase >= SG1->G1_INI .And. dDataBase <= SG1->G1_FIM)
							DbSelectArea("SB1")
							If DbSeek(xFilial("SB1")+aEstru[i,3])  .And. !(RTrim(SB1->B1_COD)==RTrim(_cPai))
								u_STCSTAM(@_aMOD,aEstru[i,3],aEstru[i,4])
							Endif
						Endif
					Endif
				Endif
			Next i

			For linha:=1 to len(_aMOD)

				aAdd(aDados, {;
					"",;
					_aMOD[linha,1],;
					Posicione("SB1",1,xFilial("SB1")+_aMOD[linha,1],"B1_DESC"),;
					Transform(_aMOD[linha,2],"@E 9999,9999.99999999" ),;
					'',;
					u_STCSTAD(_aMOD[linha,1],_cModRef),;
					Transform(_aMOD[linha,2]*u_STCSTAD(_aMOD[linha,1],_cModRef), "@E 9999,9999.99999999" ),;
					0,;
					'',;
					_aMOD[linha,1],;
					Posicione("SB1",1,xFilial("SB1")+_aMOD[linha,1],"B1_DESC"),;
					'',;
					Transform(_aMOD[linha,2],"@E 9999,9999.99999999" ),;
					'',;
					u_STCSTAD(_aMOD[linha,1],_cModRef),;
					Transform(_aMOD[linha,2]*u_STCSTAD(_aMOD[linha,1],_cModRef), "@E 9999,9999.99999999" ),;
					0;
					})

			Next linha
		Endif


		aAdd(aDados, {;
			"",;
			"",;
			"",;
			"",;
			'',;
			'',;
			'',;
			'',;
			'',;
			'',;
			'',;
			'',;
			'',;
			'',;
			'',;
			'',;
			'';
			})
	Enddo

//###############################
//Elimina arquivo de trabalho   #
//###############################
	FERASE(_cArq+".DBF")
	FERASE(_cArq+".IDX")


	if Len(aDados) > 0
		FWMsgRun(,{|| ExpotMsExcel(_aCabec, aDados) },,"Aguarde, montando planilha")
	Endif


return



