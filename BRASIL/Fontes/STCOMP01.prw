#Include 'Protheus.ch'
#Include 'TopConn.ch'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'TBICONN.CH'


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STCOMP01  º Autor ³ João Victor        º Data ³  20/10/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Tela para a realização de consulta padrão específica de    º±±
±±º          ³ produtos para a Rotina de Solicitação de Compras do módulo º±±
±±º          ³ Compras (02) executada via query e chamada pela consulta   º±±
±±º          ³ SB1COM                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Steck Industria Eletrica Ltda.                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function STCOMP01()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local oPanel
Local aPars        := {}
Local cVar	       := Upper( Alltrim( ReadVar() ) )
Local cConteudo    := Space(15)
Local cCodigo      := ""
Local nPosList     := 0
Local lOk		   := .T.
Local cFiltro      := ""
Private aCodrel    := {}
Private aCodrel2   := {}
Private cExpressao := Upper(Space(30))
Private cCodigo    := Space(5)
Private cOpcPesq   := ""
Private oListBox


If cVar == "M->C1_PRODUTO"
	lOk       := .F.
	//cConteudo := &(ReadVar())
	STCOMP03()
	aCodrel2 := aClone(aCodrel)
	DEFINE MSDIALOG oDlgCons FROM 0,0 TO 400,900 TITLE "Pesquisa de Produtos Personalizada Steck Indústria Elétrica Ltda." PIXEL

	@ 20,100 MSGET cExpressao                                                     SIZE 100, 7 OF oPanel PIXEL Valid STCOMP04()	
	@ 10, 10 SAY   "Tipo de Pesquisa: "                                           SIZE 100, 7 OF oPanel PIXEL
	@ 20, 10 COMBOBOX cOpcPesq ITEMS {"Descrição de Produto","Código de Produto"} SIZE 70,10 PIXEL OF oPanel
	@ 10,100 SAY   "Informe a Expressão da Pesquisa: "                            SIZE 100, 7 OF oPanel PIXEL
	@ 35,100 SAY   "Exemplo de Pesquisa para Descrição de Produto -> PARAF%MM%60" SIZE 200, 7 OF oPanel PIXEL
	@ 45, 05 LISTBOX oListBox VAR nPosLbx FIELDS HEADER "Código","Descrição do Produto","Descrição do Grupo de Produto","Qtde. Estoque","Saldo em PC","Unidade de Medida","Tipo de Produto" SIZE 440,150 OF oDlgCons PIXEL NOSCROLL

	oListBox:SetArray(aCodRel)
	oListBox:bLine := { ||{aCodRel[oListBox:nAT][1],;
	aCodRel[oListBox:nAT][2],;
	aCodRel[oListBox:nAT][3],;
	aCodRel[oListBox:nAT][4],;
	aCodRel[oListBox:nAT][5],;
	aCodRel[oListBox:nAT][6],;
	aCodRel[oListBox:nAT][7]}}
	oListBox:bLDblClick := { ||Eval(oConf:bAction), oDlgCons:End()}
	//	oListBox:Align := CONTROL_ALIGN_ALLCLIENT // Retorno da pesquisa em tela cheia
	oListBox:Refresh()
	
	@ 20,800 BUTTON oConf Prompt "Confirmar" SIZE 45 ,10   FONT oDlgCons:oFont ACTION (lOk:=.T.,cCodigo:=aCodRel[oListBox:nAT][1],oDlgCons:End())  OF oDlgCons PIXEL
	//	@ 20,200 BUTTON oCanc Prompt "Cancelar"  SIZE 45 ,10   FONT oDlgCons:oFont ACTION (lOk:=.F.,oDlgCons:End())  OF oDlgCons PIXEL
	
	oListBox:Refresh()
	
	ACTIVATE MSDIALOG oDlgCons CENTERED
	
	If lOk
		M->C1_PRODUTO := cCodigo
	Else
		M->C1_PRODUTO := cConteudo
	EndIf
EndIf

Return lOk

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STCOMP02  º Autor ³ João Victor        º Data ³  20/10/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Retorno para consulta padrao especifica acima              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Steck Industria Eletrica Ltda.                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function STCOMP02()

Return (M->C1_PRODUTO)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STCOMP03  º Autor ³ João Victor        º Data ³  20/10/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Execução da query e montagem no array para a consulta      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Steck Industria Eletrica Ltda.                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function STCOMP03(cFiltro)

Local cAlias	:= getNextAlias()
Local cQuery	:= ""
Local cLike 	:= ""
Local aMatriz   := {}
Local lRet      := .T.

/*
cLike	:= Alltrim(cExpressao)
aMatriz := Strtokarr(cLike,"%")

If cOpcPesq = "Descrição de Produto"
	If Len (aMatriz) > 6
		Aviso("Pesquisa de Produtos", "Muitos argumentos para a pesquisa...!!!"+chr(13)+chr(10)+;
		chr(13)+chr(10)+;
		"A pesquisa de produtos não será realizada...!!!",;
		{"Ok"})
		lRet := .F.
		cExpressao := Space(30)
		cFiltro := ""
	ElseIF Len(aMatriz) == 1
		cFiltro := "AND B1_DESC LIKE '%" + aMatriz[1] + "%'"
		
	ElseIf Len(aMatriz) == 2
		cFiltro := "AND B1_DESC LIKE '%" + aMatriz[1] + "%'" +;
		"AND B1_DESC LIKE '%" + aMatriz[2] + "%'"
		
	ElseIf Len(aMatriz) == 3
		cFiltro := "AND B1_DESC LIKE '%" + aMatriz[1] + "%'" +;
		"AND B1_DESC LIKE '%" + aMatriz[2] + "%'" +;
		"AND B1_DESC LIKE '%" + aMatriz[3] + "%'"
		
	ElseIf Len(aMatriz) == 4
		cFiltro := "AND B1_DESC LIKE '%" + aMatriz[1] + "%'" +;
		"AND B1_DESC LIKE '%" + aMatriz[2] + "%'" +;
		"AND B1_DESC LIKE '%" + aMatriz[3] + "%'" +;
		"AND B1_DESC LIKE '%" + aMatriz[4] + "%'"
		
	ElseIf Len(aMatriz) == 5
		cFiltro := "AND B1_DESC LIKE '%" + aMatriz[1] + "%'" +;
		"AND B1_DESC LIKE '%" + aMatriz[2] + "%'" +;
		"AND B1_DESC LIKE '%" + aMatriz[3] + "%'" +;
		"AND B1_DESC LIKE '%" + aMatriz[4] + "%'" +;
		"AND B1_DESC LIKE '%" + aMatriz[5] + "%'"
		
	ElseIf Len(aMatriz) == 6
		cFiltro := "AND B1_DESC LIKE '%" + aMatriz[1] + "%'" +;
		"AND B1_DESC LIKE '%" + aMatriz[2] + "%'" +;
		"AND B1_DESC LIKE '%" + aMatriz[3] + "%'" +;
		"AND B1_DESC LIKE '%" + aMatriz[4] + "%'" +;
		"AND B1_DESC LIKE '%" + aMatriz[5] + "%'" +;
		"AND B1_DESC LIKE '%" + aMatriz[6] + "%'"
	Endif
	
ElseIf cOpcPesq = "Código de Produto"
	If Len (aMatriz) > 6
		Aviso("Pesquisa de Produtos", "Muitos argumentos para a pesquisa...!!!"+chr(13)+chr(10)+;
		chr(13)+chr(10)+;
		"A pesquisa de produtos não será realizada...!!!",;
		{"Ok"})
		lRet := .F.
		cExpressao := Space(30)
		cFiltro := ""
	ElseIF Len(aMatriz) == 1
		cFiltro := "AND B1_COD LIKE '%" + aMatriz[1] + "%'"
		
	ElseIf Len(aMatriz) == 2
		cFiltro := "AND B1_COD LIKE '%" + aMatriz[1] + "%'" +;
		"AND B1_COD LIKE '%" + aMatriz[2] + "%'"
		
	ElseIf Len(aMatriz) == 3
		cFiltro := "AND B1_COD LIKE '%" + aMatriz[1] + "%'" +;
		"AND B1_COD LIKE '%" + aMatriz[2] + "%'" +;
		"AND B1_COD LIKE '%" + aMatriz[3] + "%'"
		
	ElseIf Len(aMatriz) == 4
		cFiltro := "AND B1_COD LIKE '%" + aMatriz[1] + "%'" +;
		"AND B1_COD LIKE '%" + aMatriz[2] + "%'" +;
		"AND B1_COD LIKE '%" + aMatriz[3] + "%'" +;
		"AND B1_COD LIKE '%" + aMatriz[4] + "%'"
		
	ElseIf Len(aMatriz) == 5
		cFiltro := "AND B1_COD LIKE '%" + aMatriz[1] + "%'" +;
		"AND B1_COD LIKE '%" + aMatriz[2] + "%'" +;
		"AND B1_COD LIKE '%" + aMatriz[3] + "%'" +;
		"AND B1_COD LIKE '%" + aMatriz[4] + "%'" +;
		"AND B1_COD LIKE '%" + aMatriz[5] + "%'"
		
	ElseIf Len(aMatriz) == 6
		cFiltro := "AND B1_COD LIKE '%" + aMatriz[1] + "%'" +;
		"AND B1_COD LIKE '%" + aMatriz[2] + "%'" +;
		"AND B1_COD LIKE '%" + aMatriz[3] + "%'" +;
		"AND B1_COD LIKE '%" + aMatriz[4] + "%'" +;
		"AND B1_COD LIKE '%" + aMatriz[5] + "%'" +;
		"AND B1_COD LIKE '%" + aMatriz[6] + "%'"
	Endif
Endif
*/

cQuery := " SELECT   "
cQuery += " B1_COD,  "
cQuery += " B1_DESC, "
cQuery += " BM_DESC, "
cQuery += " B2_QATU, "
cQuery += " (SELECT SUM(C7_QUANT - C7_QUJE) FROM SC7010 C7 WHERE C7_PRODUTO = B1_COD AND C7.D_E_L_E_T_ <> '*' AND C7_FILIAL  = '" + xFilial("SC7") + "' ) AS COMPRAS,"
//cQuery += " B1_POSIPI AS COMPRAS, "
cQuery += " B1_TIPO, "
cQuery += " B1_UM    "

cQuery += " FROM " + RetSqlName("SB1") +" TB1 "

cQuery += " LEFT JOIN " + RetSqlName("SB2") +" TB2 "
cQuery += " ON  B1_COD           = B2_COD "
cQuery += " AND B1_LOCPAD        = B2_LOCAL "
cQuery += " AND B2_FILIAL        = '" + xFilial("SB2") + "'"
cQuery += " AND TB2.D_E_L_E_T_  <> '*' "

cQuery += " LEFT JOIN " + RetSqlName("SBM") +" TBM "
cQuery += " ON  B1_GRUPO         = BM_GRUPO "
cQuery += " AND BM_FILIAL        = '" + xFilial("SBM") + "'"
cQuery += " AND TBM.D_E_L_E_T_  <> '*' "

cQuery += " WHERE B1_MSBLQL     <> '1' "
cQuery += "   AND B1_FILIAL      = '" + xFilial("SB1") + "'"
cQuery += "   AND TB1.D_E_L_E_T_ = ' ' "
//cQuery += "   AND B1_GRUPO BETWEEN  '400' AND '998'"
cQuery += "   AND ROWNUM        <= 10"

//If !Empty(cFiltro)
//	cQuery +=  cFiltro
//EndIf

cQuery += " ORDER BY B1_DESC "

cQuery := ChangeQuery(cQuery)
DbUseArea(.T., "TOPCONN", TCGENQRY( , , cQuery), cAlias, .F., .T.)


While !(cAlias)->(Eof())
	Aadd(aCodrel,{	(cAlias)->B1_COD,;
	(cAlias)->B1_DESC,;
	(cAlias)->BM_DESC,;
	(cAlias)->B2_QATU,;
	(cAlias)->COMPRAS,;
	(cAlias)->B1_UM,;
	(cAlias)->B1_TIPO})
	
	(cAlias)->(dbSkip())
End

(cAlias)->(DbCloseArea())

Return(aCodrel)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STCOMP04  º Autor ³ João Victor        º Data ³  20/10/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Filtro para descrição de produtos                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Steck Industria Eletrica Ltda.                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function STCOMP04()

Local nI 		:= 0
Local lRet 	:= .T.
Local cExpAux	:= ""
Local nPos		:= 0

If Empty(cExpressao)
	aCodRel:= aClone(aCodRel2)
	oListBox:SetArray(aCodRel)
	oListBox:bLine := { ||{	aCodRel[oListBox:nAT][1],;
	aCodRel[oListBox:nAT][2],;
	aCodRel[oListBox:nAT][3],;
	aCodRel[oListBox:nAT][4],;
	aCodRel[oListBox:nAT][5],;
	aCodRel[oListBox:nAT][6],;
	aCodRel[oListBox:nAT][7]}}
	oListBox:Refresh()
	Return .T.
	//Else
Elseif !Empty(cExpressao)
	aCodrel := {}
	STCOMP05(cExpressao)
EndIf

If Len(aCodRel) > 0
	oListBox:SetArray(aCodRel)
	oListBox:bLine := { ||{	aCodRel[oListBox:nAT][1],;
	aCodRel[oListBox:nAT][2],;
	aCodRel[oListBox:nAT][3],;
	aCodRel[oListBox:nAT][4],;
	aCodRel[oListBox:nAT][5],;
	aCodRel[oListBox:nAT][6],;
	aCodRel[oListBox:nAT][7]}}
	oListBox:Refresh()
Else
	lRet := .F.
	aCodRel:= aClone(aCodRel2)
	ApMsgInfo("Não foi encontrado nenhum produto com a Expressão digitada")
EndIf

Return lRet




/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STCOMP05  º Autor ³ João Victor        º Data ³  20/10/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Filtro para descrição de produtos                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Steck Industria Eletrica Ltda.                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function STCOMP05(cFiltro)

Local cAlias	:= getNextAlias()
Local cQuery	:= ""
Local cLike 	:= ""
Local aMatriz   := {}
Local lRet      := .T.

cLike	:= Alltrim(cExpressao)
aMatriz := Strtokarr(cLike,"%")

If cOpcPesq = "Descrição de Produto"
	If Len (aMatriz) > 6
		Aviso("Pesquisa de Produtos", "Muitos argumentos para a pesquisa...!!!"+chr(13)+chr(10)+;
		chr(13)+chr(10)+;
		"A pesquisa de produtos não será realizada...!!!",;
		{"Ok"})
		lRet := .F.
		cExpressao := Space(30)
		cFiltro := ""
	ElseIF Len(aMatriz) == 1
		cFiltro := "AND B1_DESC LIKE '%" + aMatriz[1] + "%'"
		
	ElseIf Len(aMatriz) == 2
		cFiltro := "AND B1_DESC LIKE '%" + aMatriz[1] + "%'" +;
		"AND B1_DESC LIKE '%" + aMatriz[2] + "%'"
		
	ElseIf Len(aMatriz) == 3
		cFiltro := "AND B1_DESC LIKE '%" + aMatriz[1] + "%'" +;
		"AND B1_DESC LIKE '%" + aMatriz[2] + "%'" +;
		"AND B1_DESC LIKE '%" + aMatriz[3] + "%'"
		
	ElseIf Len(aMatriz) == 4
		cFiltro := "AND B1_DESC LIKE '%" + aMatriz[1] + "%'" +;
		"AND B1_DESC LIKE '%" + aMatriz[2] + "%'" +;
		"AND B1_DESC LIKE '%" + aMatriz[3] + "%'" +;
		"AND B1_DESC LIKE '%" + aMatriz[4] + "%'"
		
	ElseIf Len(aMatriz) == 5
		cFiltro := "AND B1_DESC LIKE '%" + aMatriz[1] + "%'" +;
		"AND B1_DESC LIKE '%" + aMatriz[2] + "%'" +;
		"AND B1_DESC LIKE '%" + aMatriz[3] + "%'" +;
		"AND B1_DESC LIKE '%" + aMatriz[4] + "%'" +;
		"AND B1_DESC LIKE '%" + aMatriz[5] + "%'"
		
	ElseIf Len(aMatriz) == 6
		cFiltro := "AND B1_DESC LIKE '%" + aMatriz[1] + "%'" +;
		"AND B1_DESC LIKE '%" + aMatriz[2] + "%'" +;
		"AND B1_DESC LIKE '%" + aMatriz[3] + "%'" +;
		"AND B1_DESC LIKE '%" + aMatriz[4] + "%'" +;
		"AND B1_DESC LIKE '%" + aMatriz[5] + "%'" +;
		"AND B1_DESC LIKE '%" + aMatriz[6] + "%'"
	Endif
	
ElseIf cOpcPesq = "Código de Produto"
	If Len (aMatriz) > 6
		Aviso("Pesquisa de Produtos", "Muitos argumentos para a pesquisa...!!!"+chr(13)+chr(10)+;
		chr(13)+chr(10)+;
		"A pesquisa de produtos não será realizada...!!!",;
		{"Ok"})
		lRet := .F.
		cExpressao := Space(30)
		cFiltro := ""
	ElseIF Len(aMatriz) == 1
		cFiltro := "AND B1_COD LIKE '%" + aMatriz[1] + "%'"
		
	ElseIf Len(aMatriz) == 2
		cFiltro := "AND B1_COD LIKE '%" + aMatriz[1] + "%'" +;
		"AND B1_COD LIKE '%" + aMatriz[2] + "%'"
		
	ElseIf Len(aMatriz) == 3
		cFiltro := "AND B1_COD LIKE '%" + aMatriz[1] + "%'" +;
		"AND B1_COD LIKE '%" + aMatriz[2] + "%'" +;
		"AND B1_COD LIKE '%" + aMatriz[3] + "%'"
		
	ElseIf Len(aMatriz) == 4
		cFiltro := "AND B1_COD LIKE '%" + aMatriz[1] + "%'" +;
		"AND B1_COD LIKE '%" + aMatriz[2] + "%'" +;
		"AND B1_COD LIKE '%" + aMatriz[3] + "%'" +;
		"AND B1_COD LIKE '%" + aMatriz[4] + "%'"
		
	ElseIf Len(aMatriz) == 5
		cFiltro := "AND B1_COD LIKE '%" + aMatriz[1] + "%'" +;
		"AND B1_COD LIKE '%" + aMatriz[2] + "%'" +;
		"AND B1_COD LIKE '%" + aMatriz[3] + "%'" +;
		"AND B1_COD LIKE '%" + aMatriz[4] + "%'" +;
		"AND B1_COD LIKE '%" + aMatriz[5] + "%'"
		
	ElseIf Len(aMatriz) == 6
		cFiltro := "AND B1_COD LIKE '%" + aMatriz[1] + "%'" +;
		"AND B1_COD LIKE '%" + aMatriz[2] + "%'" +;
		"AND B1_COD LIKE '%" + aMatriz[3] + "%'" +;
		"AND B1_COD LIKE '%" + aMatriz[4] + "%'" +;
		"AND B1_COD LIKE '%" + aMatriz[5] + "%'" +;
		"AND B1_COD LIKE '%" + aMatriz[6] + "%'"
	Endif
Endif

cQuery := " SELECT   "
cQuery += " B1_COD,  "
cQuery += " B1_DESC, "
cQuery += " BM_DESC, "
cQuery += " B2_QATU, "
cQuery += " (SELECT SUM(C7_QUANT - C7_QUJE) FROM SC7010 C7 WHERE C7_PRODUTO = B1_COD AND C7.D_E_L_E_T_ <> '*' AND C7_FILIAL  = '" + xFilial("SC7") + "' ) AS COMPRAS,"
//cQuery += " B1_POSIPI AS COMPRAS, "
cQuery += " B1_TIPO, "
cQuery += " B1_UM    "

cQuery += " FROM " + RetSqlName("SB1") +" TB1 "

cQuery += " LEFT JOIN " + RetSqlName("SB2") +" TB2 "
cQuery += " ON  B1_COD           = B2_COD "
cQuery += " AND B1_LOCPAD        = B2_LOCAL "
cQuery += " AND B2_FILIAL        = '" + xFilial("SB2") + "'"
cQuery += " AND TB2.D_E_L_E_T_  <> '*' "

cQuery += " LEFT JOIN " + RetSqlName("SBM") +" TBM "
cQuery += " ON  B1_GRUPO         = BM_GRUPO "
cQuery += " AND BM_FILIAL        = '" + xFilial("SBM") + "'"
cQuery += " AND TBM.D_E_L_E_T_  <> '*' "

cQuery += " WHERE B1_MSBLQL     <> '1' "
cQuery += "   AND B1_FILIAL      = '" + xFilial("SB1") + "'"
cQuery += "   AND TB1.D_E_L_E_T_ = ' ' "
//cQuery += "   AND B1_GRUPO BETWEEN  '400' AND '998'"
//cQuery += "   AND ROWNUM        <= 20"

If !Empty(cFiltro)
	cQuery +=  cFiltro
EndIf

cQuery += " ORDER BY B1_DESC "

cQuery := ChangeQuery(cQuery)
DbUseArea(.T., "TOPCONN", TCGENQRY( , , cQuery), cAlias, .F., .T.)

While !(cAlias)->(Eof())
	Aadd(aCodrel,{	(cAlias)->B1_COD,;
	(cAlias)->B1_DESC,;
	(cAlias)->BM_DESC,;
	(cAlias)->B2_QATU,;
	(cAlias)->COMPRAS,;
	(cAlias)->B1_UM,;
	(cAlias)->B1_TIPO})
	
	(cAlias)->(dbSkip())
End

(cAlias)->(DbCloseArea())

Return(aCodrel)
