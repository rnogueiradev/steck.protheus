#INCLUDE "PROTHEUS.CH" 
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "COLORS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ STCOM023     ºAutor  ³Joao Rinaldi    º Data ³  12/02/2016 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função desenvolvida para que os aprovadores possam analisarº±±
±±º          ³ as solicitações de compras                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Steck Industria Eletrica Ltda.                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºChamado   ³ 002612 - Automatizar Solicitação de Compras                º±±
±±ºSolic.    ³ Juliana Queiroz - Depto. Compras                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±± 20210701011385															±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function STCOM023()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Declaração das Variáveis
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Local aArea1    := GetArea()
	Local aArea2    := SC1->(GetArea())
	Local aArea3    := SY1->(GetArea())
	Local _cAlias1  := "SC1"
	Local _cFiltro  := ""
	Local _aParamBox:= {}
	Local _aRet1    := {}
	Local lContinua := .T.
	Private cTitle  := "Definição do Comprador"
	Private cMarca  := ''
	Private _cCID   := "MARK023"
	Private _cSSID  := "STCOM023"
	Private aRotina := MenuDef(_cSSID)
	Private oMark
	Private cCompST := ''

	_cQuery1 := " MERGE INTO "+RetSqlName("SC1")+" C1
	_cQuery1 += " USING (
	_cQuery1 += " SELECT C1.R_E_C_N_O_ RECSC1, MAX(C8_NUM) C8_NUM
	_cQuery1 += " FROM "+RetSqlName("SC1")+" C1
	_cQuery1 += " LEFT JOIN "+RetSqlName("SC8")+" C8
	_cQuery1 += " ON C8_FILIAL=C1_FILIAL AND C8_NUMSC=C1_NUM AND C8_ITEMSC=C1_ITEM
	_cQuery1 += " WHERE C1.D_E_L_E_T_=' ' AND C1_COTACAO=' ' AND C8.D_E_L_E_T_=' '
	_cQuery1 += " GROUP BY C1.R_E_C_N_O_
	_cQuery1 += " ORDER BY C1.R_E_C_N_O_
	_cQuery1 += " ) XXX
	_cQuery1 += " ON (C1.R_E_C_N_O_=XXX.RECSC1)
	_cQuery1 += " WHEN MATCHED THEN UPDATE SET
	_cQuery1 += " C1_COTACAO=XXX.C8_NUM
	
	TcSqlExec(_cQuery1)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Validação de acesso a rotina apenas para compradores cadastrados
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DbSelectArea("SY1")
	SY1->(DbSetOrder(3))//Y1_FILIAL+Y1_USER
	SY1->(DbGoTop())
	If !DbSeek(xFilial("SY1")+__cUserId)
		Aviso(cTitle; //01 - cTitulo - Título da janela
		,"Usuário sem permissão para a rotina "+cTitle+"."+ Chr(10) + Chr(13) +;
		CHR(10)+CHR(13)+;
		"Ação não permitida."+CHR(10)+CHR(13)+;
		CHR(10)+CHR(13)+;
		"Favor Verificar.",; //02 - cMsg - Texto a ser apresentado na janela.
		{"OK"};                          //03 - aBotoes - Array com as opções dos botões.
		,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
		,;                               //05 - cText - Titulo da Descrição (Dentro da Janela)
		,;                               //06 - nRotAutDefault - Opção padrão usada pela rotina automática
		,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
		,.F.;                            //08 - lEdit - Determina se permite a edição do campo memo
		,;                               //09 - nTimer - Tempo para exibição da mensagem em segundos.
		,;                               //10 - nOpcPadrao - Opção padrão apresentada na mensagem.
		)
		Return
	Endif

	DbSelectArea("SX6")
	SX6->(DbSetOrder(1))
	SX6->(DbGoTop())
	If !(SX6->(DbSeek("  "+"ST_DEFCOMP")))
	/* Removido\Ajustado - Não executa mais RecLock na X6. Criação/alteração de dados deve ser feita apenas pelo módulo Configurador ou pela rotina de atualização de versão.
		SX6->(RecLock("SX6",.T.))
		SX6->X6_FIL       := ""
		SX6->X6_VAR       := "ST_DEFCOMP"
		SX6->X6_TIPO      := "C"
		SX6->X6_DESCRIC   := "Código do Usuário Comprador que está utilizando a "
		SX6->X6_DSCSPA    := "Código do Usuário Comprador que está utilizando a "
		SX6->X6_DSCENG    := "Código do Usuário Comprador que está utilizando a "
		SX6->X6_DESC1     := "Rotina 'Define Comprador' (STCOM023) e que não    "
		SX6->X6_DSCSPA1   := "Rotina 'Define Comprador' (STCOM023) e que não    "
		SX6->X6_DSCENG1   := "Rotina 'Define Comprador' (STCOM023) e que não    "
		SX6->X6_DESC2     := "permitirá acesso de um novo Comprador             "
		SX6->X6_DSCSPA2   := "permitirá acesso de um novo Comprador             "
		SX6->X6_DSCENG2   := "permitirá acesso de um novo Comprador             "
		SX6->X6_CONTEUD   := __cUserId
		SX6->X6_CONTSPA   := __cUserId
		SX6->X6_CONTENG   := __cUserId
		SX6->(MsUnLock())*/
	EndIf

	If SX6->(!Eof())
		If SimpleLock()
		/* Removido\Ajustado - Não executa mais RecLock na X6. Criação/alteração de dados deve ser feita apenas pelo módulo Configurador ou pela rotina de atualização de versão.
			SX6->(RecLock("SX6",.F.))
			SX6->X6_CONTEUD   := __cUserId
			SX6->X6_CONTSPA   := __cUserId
			SX6->X6_CONTENG   := __cUserId
			SX6->(MsUnLock())
			SX6->(RecLock("SX6",.F.))*/
			lContinua	:= .T.
		Else
			lContinua	:= .F.
		EndIf
	EndIf

	If lContinua
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Tela para que o usuário selecione o comprador em que o mesmo irá analisar as SC
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aAdd(_aParamBox,{1,"Código do Comprador",Space(TamSX3("Y1_COD")[1]+TamSX3("Y1_COD")[2]),"@!",'.T.','SY1','.T.',40,.F.})
		ParamBox(_aParamBox,"Selecione o Comprador",@_aRet1)//,,,.T.,,500)
		
		
		If !Len(_aRet1) > 0
			Return
		Else
			cCompST := _aRet1[1]
			//_cFiltro := "(C1_ZSTATUS == '3' .Or. C1_ZSTATUS == '5')"; //Chamado 007247 - Richard
			//Emerson Holanda 29/08/23 - Ajuste no filtro, incluida a regra se o C1_COTACAO ESTIVER IGUAL A IMPORT
			_cFiltro := "C1_ZSTATUS == '3' "; //
			+ " .And. C1_CODCOMP == '"+cCompST+"' ";
			+ " .And. ( EMPTY(C1_COTACAO) .OR. C1_COTACAO == 'IMPORT' ) ";
			+ " .And. EMPTY(C1_PEDIDO) ";
			+ " .And. EMPTY(C1_QUJE) "; //C1_ZSTATUS
			//Inibida a linha de baixo por Emerson Holanda 30/08/23
			//+  " .OR. (  C1_IMPORT == 'S'  .AND. C1_ZSTATUS == '3'  .And. C1_CODCOMP == '"+cCompST+"' .AND. EMPTY(C1_COTACAO) .And. EMPTY(C1_PEDIDO)  .And. EMPTY(C1_QUJE) ) "    //Chamado 007540

		Endif

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Construção básica de um Browse
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		oMark  := FWMarkBrowse():New()
		cMarca := oMark:Mark()

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Definição da tabela que será exibida na Browse utilizando o método SetAlias
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		oMark:SetAlias(_cAlias1)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Definição da utilização de Mark Browse na construção da tela
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		oMark:SetFieldMark("C1_ZMARKBR")
		//oMark:SetMark(cMarca,_cAlias1,"C1_ZMARKBR")
		oMark:SetAfterMark({||U_STCOM024(1)})
		//oMark:SetSemaphore(.T.)
		oMark:SetAllMark({|| U_STCOM024(2)})//SetAllMark não funciona quando a classe SetSemaphore estiver ativa
		oMark:SetWalkThru(.F.)
		oMark:SetAmbiente(.F.)
		oMark:SetUseFilter(.T.)

		//oMark:SetParam({|| RecarSel()})
		//oMark:SetBackColor(000250154)
		//oMark:SetClrAlterRow(135206235)
		//oMark:SetForeColor(255255255)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Definição do título que será exibido como método SetDescription
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		oMark:SetDescription(cTitle)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Definição do filtro ao browse
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		oMark:SetFilterDefault( _cFiltro )

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Definição das legendas do browse
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		oMark:AddLegend("C1_ZSTATUS=='3'" ,"GREEN"           ,"Aprovado pelo Gestor")
		oMark:AddLegend("C1_ZSTATUS=='5'" ,"CANCEL_CHILD_15" ,"Rejeitado por Compras")
		//oMark:AddLegend("C1_ZSTATUS=='6'" ,"OK_15"           ,"Analisado por Compras")

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Desliga a exibição dos detalhes
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		oMark:DisableDetails()

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Ativação da classe
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		oMark:Activate()

	Else
		Aviso(cTitle; //01 - cTitulo - Título da janela
		,"A Rotina '"+cTitle+"' está sendo utilizada pelo usuário "+UsrRetName(GetMv("ST_DEFCOMP"))+"."+ Chr(10) + Chr(13) +;
		CHR(10)+CHR(13)+;
		"Você não conseguirá acessar a rotina enquanto o usuário estiver utilizando a rotina.",; //02 - cMsg - Texto a ser apresentado na janela.
		{"OK"};                          //03 - aBotoes - Array com as opções dos botões.
		,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
		,;                               //05 - cText - Titulo da Descrição (Dentro da Janela)
		,;                               //06 - nRotAutDefault - Opção padrão usada pela rotina automática
		,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
		,.F.;                            //08 - lEdit - Determina se permite a edição do campo memo
		,;                               //09 - nTimer - Tempo para exibição da mensagem em segundos.
		,;                               //10 - nOpcPadrao - Opção padrão apresentada na mensagem.
		)
	Endif

	RestArea(aArea3)
	RestArea(aArea2)
	RestArea(aArea1)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MenuDef      ºAutor  ³Joao Rinaldi    º Data ³  10/12/2015 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ A função MenuDef define as opções (Menu) que estarão       º±±
±±º          ³ disponíveis ao usuário                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Steck Industria Eletrica Ltda.                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºRotina    ³ STCOM010.prw                                               º±±
±±ºNome      ³ Cadastro de Aprovadores de Solicitação de Compras          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MenuDef(_cSSID)

	Local _cProgram := ALLTRIM(UPPER(funname()))
	Local aRotina   := {}

	If !Empty(_cProgram)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Opções padrões do MVC
		// 1 para Pesquisar
		// 2 para Visualizar
		// 3 para Incluir
		// 4 para Alterar
		// 5 para Excluir
		// 6 para Imprimir
		// 7 para Copiar
		// 8 Opções Customizadas
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		ADD OPTION aRotina TITLE "Pesquisar"      ACTION "PESQBRW"         OPERATION 1  ACCESS 0
		ADD OPTION aRotina TITLE "Visualizar"     ACTION "VIEWDEF.STCOM023" OPERATION 2  ACCESS 0
		ADD OPTION aRotina TITLE "Transfere para:"ACTION "U_STCOM024(3)"   OPERATION 8  ACCESS 0
		ADD OPTION aRotina TITLE "Rejeitar"       ACTION "U_STCOM024(4)"   OPERATION 8  ACCESS 0
		ADD OPTION aRotina TITLE "Enviar Cotação" ACTION "U_STCOM024(5)"   OPERATION 8  ACCESS 0
		ADD OPTION aRotina TITLE "Anexar Docs"    ACTION "U_STCOM016(SC1->C1_NUM)"  OPERATION 8  ACCESS 0

	Endif
Return aRotina
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ModelDef     ºAutor  ³Joao Rinaldi    º Data ³  10/12/2015 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ A função ModelDef define a regra de negócios propriamente  º±±
±±º          ³ dita onde são definidas:                                   º±±
±±º          ³ 1) Todas as entidades (tabelas) que farão parte do modelo  º±±
±±º          ³ de dados (Model)                                           º±±
±±º          ³ 2) Regras de dependência entre as entidades                º±±
±±º          ³ 3) Validações (de campos e aplicação)                      º±±
±±º          ³ 4) Persistência dos dados (gravação)                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Steck Industria Eletrica Ltda.                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºRotina    ³ STCOM010.prw                                               º±±
±±ºNome      ³ Cadastro de Aprovadores de Solicitação de Compras          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ModelDef()

	Local oStruCabec := FWFormStruct(1, "SC1")// Construção de estrutura de dados
	Local oStruItens := FWFormStruct(1, "SC1")// Construção de estrutura de dados
	Local oModel
	Local _cTitulo   := "Análise de Solicitação de Compras"
	Local _cCabec    := "Solicitação de Compras"
	Local _cItens    := "Itens da Solicitação de Compras"
	Local _aRel      := {}

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria o objeto do Modelo de Dados
	//³ Irie usar uma função VldTOK que será acionada quando eu clicar no botão "Confirmar"
	//³ Irie usar uma função GrvTOK que será acionada após a confirmação do botão "Confirmar"
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oModel := MPFormModel():New(_cCID )// , /*bPreValidacao*/ ,  { | oModel | VldTOK( oModel ) }  ,  { | oModel | GrvTOK( oModel ) }  , /*bCancel*/ )
	//        MPFORMMODEL():New(<cID>  ,  <bPre >          , <bPost >                          , <bCommit >                        , <bCancel >)

	oStruCabec:AddField( "C1_SOLICIT",RetTitle("C1_SOLICIT"),"C1_SOLICIT",TamSx3("C1_SOLICIT")[3],TamSx3("C1_SOLICIT")[1],TamSx3("C1_SOLICIT")[2],       ,      ,        ,         ,      ,     ,       ,         ,  )
	oStruCabec:AddField( "C1_FILENT" ,RetTitle("C1_FILENT") ,"C1_FILENT" ,TamSx3("C1_FILENT")[3] ,TamSx3("C1_FILENT")[2] ,TamSx3("C1_FILENT")[2] ,       ,      ,        ,         ,      ,     ,       ,         ,  )
	//oStruCabec:AddField( cTitulo   , cTooltip             , cIdField   , cTipo                 ,nTamanho               ,nDecimal               , bValid, bWhen, aValues, lObrigat, bInit, lKey, lNoUpd, lVirtual, cValid)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Abaixo irei iniciar o campo X5_TABELA com o conteudo da sub-tabela
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//oStruCabec:SetProperty('X5_TABELA' , MODEL_FIELD_INIT,{||'21'} )

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Abaixo irei bloquear/liberar os campos para edição
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//oStruCabec:SetProperty('X5_TABELA' , MODEL_FIELD_WHEN,{|| .F. })

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Podemos usar as funções INCLUI ou ALTERA Ou usar a propriedade GetOperation que captura a operação que está sendo executada
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//oStruCabec:SetProperty('X5_CHAVE'  , MODEL_FIELD_WHEN,{|| INCLUI })
	//oStruCabec:SetProperty("X5_CHAVE"  , MODEL_FIELD_WHEN,{|oModel| oModel:GetOperation()== 3 })

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Adiciona ao modelo uma estrutura de formulário de edição por campo
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oModel:AddFields("CABECALHO", /*cOwner*/, oStruCabec)
	oModel:AddGrid("ITENS","CABECALHO", oStruItens)//,{|oX,Line,Acao| U_STEMBLINOK(oX,Line,Acao)},/**/,/*bLinePost*/,/*bPre*/,/*bPost*/,/*bLoad*/)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Fazendo o relacionamento entre o Cabeçalho e Item
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aAdd(_aRel, {'C1_FILIAL' , 'C1_FILIAL'} )
	aAdd(_aRel, {'C1_NUM'    , 'C1_NUM'} )

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Fazendo o relacionamento entre os compomentes do model
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oModel:SetRelation('ITENS', _aRel, SC1->(IndexKey(1))) //IndexKey -> quero a ordenação e depois filtrado
	//oModel:SetRelation('ITENS', _aRel, 'ZI_FILIAL+ZI_ITEM') //IndexKey -> quero a ordenação e depois filtrado

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Fazendo a validação para não permitir linha duplicada
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//oModel:GetModel('ITENS'):SetUniqueLine({"ZI_CC"})  //Não repetir informações ou combinações {"CAMPO1","CAMPO2","CAMPOX"}
	//oModel:GetModel("ITENS"):SetDelAllLine(.T.)
	//oModel:SetOptional("ITENS", .T. )

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Define a chave primaria utilizada pelo modelo
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oModel:SetPrimaryKey({})
	//oModel:SetPrimaryKey({"ZI_CC"})

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Adiciona a descricao do Componente do Modelo de Dados
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oModel:SetDescription(_cTitulo)
	oModel:GetModel("CABECALHO"):SetDescription(_cCabec)
	oModel:GetModel("ITENS"):SetDescription(_cItens)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Validação para inicializador padrão
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oModel:SetActivate( {|oMod| IniPad(oMod)} )

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Validação da ativação do modelo
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oModel:SetVldActivate ( { |oMod| VldAcess( oMod ) } )

Return oModel

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ViewDef      ºAutor  ³Joao Rinaldi    º Data ³  10/12/2015 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ A função ViewDef define como o será a interface e portanto º±±
±±º          ³ como o usuário interage com o modelo de dados (Model)      º±±
±±º          ³ recebendo os dados informados pelo usuário, fornecendo     º±±
±±º          ³ ao modelo de dados (definido na ModelDef) e apresentando   º±±
±±º          ³ o resultado.                                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Steck Industria Eletrica Ltda.                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºRotina    ³ STCOM010.prw                                               º±±
±±ºNome      ³ Cadastro de Aprovadores de Solicitação de Compras          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ViewDef()

	Local oStruCabec := FWFormStruct(2, "SC1")
	Local oStruItens := FWFormStruct(2, "SC1")
	Local oModel     := FWLoadModel("STCOM023")
	Local oView

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria o objeto de View
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oView:= FWFormView():New()
	oView:SetModel(oModel)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Remove os campos que não irão aparecer
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oStruCabec:RemoveField("C1_ITEM")
	oStruCabec:RemoveField("C1_PRODUTO")
	oStruCabec:RemoveField("C1_UM")
	oStruCabec:RemoveField("C1_QUANT")
	oStruCabec:RemoveField("C1_SEGUM")
	oStruCabec:RemoveField("C1_MOTIVO")
	oStruCabec:RemoveField("C1_COMPSTK")
	oStruCabec:RemoveField("C1_QTSEGUM")
	oStruCabec:RemoveField("C1_DATPRF")
	oStruCabec:RemoveField("C1_LOCAL")
	oStruCabec:RemoveField("C1_OBS")
	oStruCabec:RemoveField("C1_OP")
	oStruCabec:RemoveField("C1_CC")
	oStruCabec:RemoveField("C1_CONTA")
	oStruCabec:RemoveField("C1_ITEMCTA")
	oStruCabec:RemoveField("C1_DESCRI")
	oStruCabec:RemoveField("C1_FORNECE")
	oStruCabec:RemoveField("C1_LOJA")
	oStruCabec:RemoveField("C1_IMPORT")
	//oStruCabec:RemoveField("C1_CODCOMP")
	oStruCabec:RemoveField("C1_CLASS")
	oStruCabec:RemoveField("C1_CLVL")
	oStruCabec:RemoveField("C1_PROJETO")
	oStruCabec:RemoveField("C1_SEQMRP")
	oStruCabec:RemoveField("C1_RESIDUO")
	oStruCabec:RemoveField("C1_QTDORIG")
	oStruCabec:RemoveField("C1_PRECO")
	oStruCabec:RemoveField("C1_TOTAL")
	oStruCabec:RemoveField("C1_PROJET")
	oStruCabec:RemoveField("C1_REVISA")
	oStruCabec:RemoveField("C1_TAREFA")
	oStruCabec:RemoveField("C1_TRT")
	oStruCabec:RemoveField("C1_ITEMGRD")
	oStruCabec:RemoveField("C1_GRADE")
	oStruCabec:RemoveField("C1_FABRICA")
	oStruCabec:RemoveField("C1_LOJFABR")
	oStruCabec:RemoveField("C1_FLAGGCT")
	oStruCabec:RemoveField("C1_ESTOQUE")
	oStruCabec:RemoveField("C1_PROGRAM")
	oStruCabec:RemoveField("C1_TPSC")
	oStruCabec:RemoveField("C1_MODAL")
	oStruCabec:RemoveField("C1_TPMOD")
	oStruCabec:RemoveField("C1_CODED")
	oStruCabec:RemoveField("C1_NUMPR")
	oStruCabec:RemoveField("C1_ORCAM")
	oStruCabec:RemoveField("C1_RATEIO")
	//oStruCabec:RemoveField("C1_XEMAIL")
	oStruCabec:RemoveField("C1_XPRC")
	oStruCabec:RemoveField("C1_XVLCOTU")
	oStruCabec:RemoveField("C1_XTOTCOT")
	oStruCabec:RemoveField("C1_ZAPROV")
	oStruCabec:RemoveField("C1_ZNOMEAP")
	oStruCabec:RemoveField("C1_ZSTATUS")
	oStruCabec:RemoveField("C1_ZMARKBR")

	oStruCabec:AddField( "C1_FILIAL" ,"01"    ,RetTitle("C1_FILIAL") ,RetTitle("C1_FILIAL") ,     ,TamSx3("C1_FILIAL")[3] ,        ,         ,        ,.F.        ,        ,       ,             ,             ,         ,         ,         ,.F.)
	oStruCabec:AddField( "C1_EMISSAO","03"    ,RetTitle("C1_EMISSAO"),RetTitle("C1_EMISSAO"),     ,TamSx3("C1_EMISSAO")[3],        ,         ,        ,.F.        ,        ,       ,             ,             ,         ,         ,         ,.F.)
	oStruCabec:AddField( "C1_SOLICIT","04"    ,RetTitle("C1_SOLICIT"),RetTitle("C1_SOLICIT"),     ,TamSx3("C1_SOLICIT")[3],        ,         ,        ,.F.        ,        ,       ,             ,             ,         ,         ,         ,.F.)
	oStruCabec:AddField( "C1_UNIDREQ","05"    ,RetTitle("C1_UNIDREQ"),RetTitle("C1_UNIDREQ"),     ,TamSx3("C1_UNIDREQ")[3],        ,         ,        ,.F.        ,        ,       ,             ,             ,         ,         ,         ,.F.)
	oStruCabec:AddField( "C1_FILENT" ,"06"    ,RetTitle("C1_FILENT") ,RetTitle("C1_FILENT") ,     ,TamSx3("C1_FILENT")[3] ,        ,         ,        ,.F.        ,        ,       ,             ,             ,         ,         ,         ,.F.)
	//oStruCabec:AddField(cIdField   ,cOrdem  ,cTitulo               ,cDescric              ,aHelp,cType                  ,cPicture, bPictVar, cLookUp, lCanChange, cFolder, cGroup, aComboValues, nMaxLenCombo, cIniBrow, lVirtual, cPictVar, lInsertLine )

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Adicionando os campos do cabeçalho e o grid dos itens
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oView:AddField("VIEW_CABEC", oStruCabec, "CABECALHO")
	oView:AddGrid ("VIEW_ITENS", oStruItens, "ITENS")

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Criar um "box" horizontal para receber algum elemento da view e Setando o dimensionamento de tamanho
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oView:CreateHorizontalBox("SUPERIOR", 25)
	oView:CreateHorizontalBox("INFERIOR", 75)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Amarrando a view com as box
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oView:SetOwnerView("VIEW_CABEC", "SUPERIOR")
	oView:SetOwnerView("VIEW_ITENS", "INFERIOR")

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Força o fechamento da janela na confirmação
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oView:SetCloseOnOk({||.T.})

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Habilitando título
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oView:EnableTitleView("VIEW_CABEC")
	oView:EnableTitleView("VIEW_ITENS")

Return oView

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ IniPad       ºAutor  ³Joao Rinaldi    º Data ³  10/12/2015 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ A função IniPad define os campos e conteúdos a serem       º±±
±±º          ³ exibidos como Inicializador Padrão                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Steck Industria Eletrica Ltda.                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºRotina    ³ STCOM010.prw                                               º±±
±±ºNome      ³ Cadastro de Aprovadores de Solicitação de Compras          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function IniPad(oModel)

	Local nOp  := oModel:GetOperation()
	Local lIni := .T.

	If nOp == MODEL_OPERATION_INSERT //Cópia também é reconhecida como inserção

		//oModel:SetValue("ITENS", "ZI_ITEM" , '001')

	EndIf

Return lIni

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ VldAcess     ºAutor  ³Joao Rinaldi    º Data ³  10/12/2015 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ A função Acess define as permissões de acesso a rotina     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Steck Industria Eletrica Ltda.                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºRotina    ³ STCOM010.prw                                               º±±
±±ºNome      ³ Cadastro de Aprovadores de Solicitação de Compras          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function VldAcess(oModel)

	Local lAcess   := .T.

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Validação de Grupo de Usuário para acesso aos botões da rotina
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DbSelectArea("SY1")
	SY1->(DbSetOrder(3))//Y1_FILIAL+Y1_USER
	SY1->(DbGoTop())
	If !DbSeek(xFilial("SY1")+__cUserId)
		Help( ,, 'Help',, "Usuário sem permissão para a rotina de "+cTitle+".";
		+CHR(10)+CHR(13)+;
		"Ação não permitida.";
		+CHR(10)+CHR(13)+;
		"Favor Verificar.",;
		1, 0 )
		lAcess := .F.
	Endif

Return (lAcess)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ VldTOK       ºAutor  ³Joao Rinaldi    º Data ³  10/12/2015 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ A função VldTOK é acionada no botão Confirmar e valida     º±±
±±º          ³ se as informações digitadas estão corretas                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Steck Industria Eletrica Ltda.                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºRotina    ³ STCOM010.prw                                               º±±
±±ºNome      ³ Cadastro de Aprovadores de Solicitação de Compras          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function VldTOK( oModel )

	Local lVld        := .T.

Return lVld

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ GrvTOK       ºAutor  ³Joao Rinaldi    º Data ³  10/12/2015 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ A função GrvTOK é acionada após a confirmação do botão     º±±
±±º          ³ Confirmar                                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Steck Industria Eletrica Ltda.                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºRotina    ³ STCOM010.prw                                               º±±
±±ºNome      ³ Cadastro de Aprovadores de Solicitação de Compras          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GrvTOK( oModel )

	Local lGrv        := .T.

Return lGrv

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ STCOM024     ºAutor  ³Joao Rinaldi    º Data ³  10/12/2015 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ A função STCOM024 é utilizada para realizar as marcações   º±±
±±º          ³ no Browse. Opções de _nFlag:                               º±±
±±º          ³ 1) Marcação Item a Item                                    º±±
±±º          ³ 2) Marcação de todos os Itens                              º±±
±±º          ³ 3) Aprova Itens Analisados                                 º±±
±±º          ³ 4) Rejeita Itens Analisados                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Steck Industria Eletrica Ltda.                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºRotina    ³ STCOM010.prw                                               º±±
±±ºNome      ³ Cadastro de Aprovadores de Solicitação de Compras          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function STCOM024(_nFlag)

	Local aArea      := GetArea()
	Local aArea1     := SC1->(GetArea())
	Local aArea2     := SX5->(GetArea())
	Local aArea3     := SY1->(GetArea())
	Local _nMark     := 0
	Local _nDesMark  := 0
	Local cTexto1    := ''
	Local cTexto2    := ''
	Local _cMsg      := ''
	Local _aParamBox := {}
	Local _aRet2     := {}

	Local _aItens    := {}
	Local _nOpc      := 5
	Local _cNumSC    := ''
	Local _cSolic    := ''
	Local _cFilial   := ''
	Local _aMotRej   := {}
	Local _cTabRej   := 'Z6'
	Local _cItem     := ''
	Local lSaida     := .F.
	Local cGetMotivo := Space(TamSx3("C1_OBS")[1]+TamSx3("C1_OBS")[2])
	Local nOpcao     := 0
	Local _aCotacao  := {}
	Local _lRet      := .T.

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ 1) Marcação Item a Item
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If _nFlag == 1
		If SC1->C1_ZSTATUS == '3'
			//RecLock("SC1", .F.)
			//SC1->C1_ZSTATUS := '6'
			//SC1->(MsUnlock())
			//ElseIf SC1->C1_ZSTATUS == '6'
			//RecLock("SC1", .F.)
			//SC1->C1_ZSTATUS := '3'
			//SC1->(MsUnlock())
		Else
			ApMsgInfo("Itens de Solicitações Aprovadas ou Rejeitadas não podem mais serem manipuladas.";
			+CHR(10)+CHR(13)+;
			"Ação não permitida.",;
			"Atenção." )
			RecLock("SC1", .F.)
			SC1->C1_ZMARKBR := '  '
			SC1->(MsUnlock())
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ 2) Marcação de todos os Itens
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ElseIf _nFlag == 2
		oMark:GoTop()
		dbSelectArea("SC1")
		SC1->(dbGoTop())
		While SC1->(!Eof())
			If SC1->C1_ZSTATUS == '3'
				If oMark:IsMark()
					_nDesMark ++
					RecLock("SC1", .F.)
					SC1->C1_ZMARKBR := '  '
					SC1->(MsUnlock())
				ElseIf !oMark:IsMark()
					_nMark ++
					RecLock("SC1", .F.)
					SC1->C1_ZMARKBR := oMark:Mark()
					SC1->(MsUnlock())
				EndIf
			Endif
			SC1->(dbSkip())

		EndDo
		ApMsgInfo("Processamento finalizado com sucesso.";
		+CHR(10)+CHR(13)+;
		"Registros Analisados: " + cValtoChar(_nMark);
		+CHR(10)+CHR(13)+;
		"Registros Pendentes: " + cValtoChar(_nDesMark),;
		"Resumo do Processamento" )

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ 3) Aprova Itens Analisados
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ElseIf _nFlag == 3
		oMark:GoTop()
		dbSelectArea("SC1")
		SC1->(dbGoTop())
		While SC1->(!Eof())
			If oMark:IsMark()// SC1->C1_ZSTATUS == '6'
				_nMark ++
			Endif
			SC1->( dbSkip() )
		End
		If (_nMark > 0)
			If _nMark == 1
				cTexto1 := "Existe apenas" + cValtoChar(_nMark) + " Item Analisado."
				cTexto2 := "Apenas " + cValtoChar(_nMark) + " Item continua com Status de Analisado."
			Else
				cTexto1 := "Existem " + cValtoChar(_nMark) + " Itens Analisados."
				cTexto2 := "Os " + cValtoChar(_nMark) + " Itens continuam com Status de Analisado."
			Endif

			aAdd(_aParamBox,{1,"Código do Comprador",Space(TamSX3("Y1_COD")[1]+TamSX3("Y1_COD")[2]),"@!",'.T.','SY1','.T.',40,.T.})
			ParamBox(_aParamBox,"Selecione o Comprador",@_aRet2)//,,,.T.,,500)
			If !Len(_aRet2) > 0
				ApMsgInfo(cTexto2,;
				"Definição do Comprador")
				Return
			Else
				DbSelectArea("SY1")
				SY1->(DbSetOrder(1))//Y1_FILIAL+Y1_COD
				SY1->(DbGoTop())
				If !DbSeek(xFilial("SY1")+_aRet2[1])
					ApMsgInfo("Código '"+(_aRet2[1])+"' de Aprovador Inválido.",;
					"Definição do Comprador")
					Return
				Else
					_cName := Alltrim(SY1->Y1_NOME)
				Endif
			Endif

			If ApMsgYesNo(cTexto1;
			+CHR(10)+CHR(13)+;
			"Deseja Confirmar a Transferência para o Comprador "+_cName+"?",;
			"Definição do Comprador")
				oMark:GoTop()
				dbSelectArea("SC1")
				SC1->(dbGoTop())
				While SC1->(!Eof())
					If oMark:IsMark()//SC1->C1_ZSTATUS == '6'
						_cMsg += "===================================" +CHR(13)+CHR(10)
						_cMsg += "Item de Solicitação de Compra com Definição de Comprador: " +CHR(13)+CHR(10)
						_cMsg += "Comprador: "+_cName +" | Código: '"+_aRet2[1]+"'" +CHR(13)+CHR(10)
						_cMsg += "Em: "+DTOC(DDATABASE)+" "+TIME()+CHR(13)+CHR(10)
						RecLock("SC1", .F.)
						SC1->C1_ZSTATUS := '3'
						//>>Chamado 006694
						SC1->C1_ZDTAPRO := DDATABASE
						SC1->C1_ZHRAPRO := TIME()
						//<<
						SC1->C1_ZLOG    := SC1->C1_ZLOG + CHR(13)+ CHR(10) + _cMsg
						SC1->C1_COMPSTK := _aRet2[1]
						SC1->C1_CODCOMP := _aRet2[1]
						SC1->(MsUnlock())
					Endif
					_cMsg    := ''
					SC1->( dbSkip() )
				End
			Else
				ApMsgInfo(cTexto2,;
				"Definição do Comprador")
			Endif
		Else
			ApMsgInfo("Não existem itens a serem transferidos.",;
			"Definição do Comprador")
		Endif

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ 4) Rejeita Itens Analisados
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ElseIf _nFlag == 4

		oMark:GoTop()
		dbSelectArea("SC1")
		SC1->(dbGoTop())
		While SC1->(!Eof())
			If oMark:IsMark()//SC1->C1_ZSTATUS == '6'
				_nMark ++
			Endif
			SC1->( dbSkip() )
		End
		If (_nMark > 0)
			If _nMark == 1
				cTexto1 := "Existe apenas" + cValtoChar(_nMark) + " Item Analisado	."
				cTexto2 := "Apenas " + cValtoChar(_nMark) + " Item continua com Status de Analisado."
			Else
				cTexto1 := "Existem " + cValtoChar(_nMark) + " Itens Analisados."
				cTexto2 := "Os " + cValtoChar(_nMark) + " Itens continuam com Status de Analisado."
			Endif

			aAdd(_aParamBox,{1,"Código do Comprador",Space(TamSX3("Y1_COD")[1]+TamSX3("Y1_COD")[2]),"@!",'.T.','SY1','.T.',40,.T.})
			ParamBox(_aParamBox,"Selecione o Comprador",@_aRet2)//,,,.T.,,500)
			If !Len(_aRet2) > 0
				ApMsgInfo(cTexto2,;
				"Definição do Comprador")
				Return
			Else
				DbSelectArea("SY1")
				SY1->(DbSetOrder(1))//Y1_FILIAL+Y1_COD
				SY1->(DbGoTop())
				If !DbSeek(xFilial("SY1")+_aRet2[1])
					ApMsgInfo("Código '"+(_aRet2[1])+"' de Aprovador Inválido.",;
					"Definição do Comprador")
					Return
				Else
					_cName := Alltrim(SY1->Y1_NOME)
					_cUser := SY1->Y1_USER
				Endif
			Endif

			If ApMsgYesNo(cTexto1;
			+CHR(10)+CHR(13)+;
			"Deseja Confirmar a Rejeição para o Comprador "+_cName+"?",;
			"Rejeição por Compras")

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Tela para que seja selecionado o motivo e texto livre para detalhar a Rejeição
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				aAdd(_aMotRej,' ')
				DbSelectArea("SX5")
				SX5->(dbSetOrder(1))
				SX5->(dbSeek(xFilial("SX5") + _cTabRej))
				Do While SX5->(!EOF()) .and. xFilial("SX5") = SX5->X5_FILIAL .And. SX5->X5_TABELA  = _cTabRej
					If  SX5->X5_CHAVE >= '000001' .And. SX5->X5_CHAVE <= '000500'
						AADD(_aMotRej,ALLTRIM(SX5->X5_CHAVE)+' - '+ALLTRIM(SX5->X5_DESCRI))
					EndIF
					SX5->(DbSkip())
				EndDo
				If Len(_aMotRej) > 1
					Do While !lSaida

						Define msDialog oDxlg Title "Informar Motivo da Rejeição" From 10,10 TO 250,400 Pixel

						@ 020,010 say "Observação da Rejeição:" COLOR CLR_HBLUE  Of oDxlg Pixel
						@ 030,010 get cGetMotivo  size 165,08  Of oDxlg Pixel

						@ 050,010 Say "Motivo da Rejeição:"   COLOR CLR_HBLUE  Of oDxlg Pixel
						@ 060,010 COMBOBOX _cItem ITEMS _aMotRej SIZE 165,08 Of oDxlg Pixel

						@ 090,085 Button "OK"    Size 28,12 Action Eval({||IF(!empty(alltrim(_cItem)),(lSaida:=.T.,oDxlg:End()),msgInfo("Motivo da Rejeição não preenchido","Atenção"))}) OF oDxlg Pixel

						Activate Dialog oDxlg Centered

					EndDo
				Else
					ApMsgInfo("O Departamento de Compras não cadastrou os Motivos de Rejeição."+ Chr(10) + Chr(13) +;
					CHR(10)+CHR(13)+;
					"Os Itens analisados não serão rejeitados.",;
					"Rejeição por Compras")
					Return
				Endif
				oMark:GoTop()
				dbSelectArea("SC1")
				SC1->(dbGoTop())

				Begin Transaction 

				While SC1->(!Eof())
					If oMark:IsMark()//SC1->C1_ZSTATUS == '6'
						_cMsg += "===================================" +CHR(13)+CHR(10)
						_cMsg += "Item de Solicitação de Compra Rejeitada pelo Comprador: " +CHR(13)+CHR(10)
						_cMsg += "Comprador: "+_cName +" | Código: '"+_aRet2[1]+"'" +CHR(13)+CHR(10)
						_cMsg += "Em: "+DTOC(DDATABASE)+" "+TIME()+CHR(13)+CHR(10)
						_cMsg += "Observação: "+cGetMotivo+CHR(13)+CHR(10)
						_cMsg += "Motivo de Rejeição: "+_cItem +CHR(13)+CHR(10)
						RecLock("SC1", .F.)
						SC1->C1_OBS     := Alltrim(SC1->C1_OBS) + " | " + Alltrim(cGetMotivo)
						SC1->C1_ZSTATUS := '5'
						SC1->C1_ZLOG    := SC1->C1_ZLOG + CHR(13)+ CHR(10) + _cMsg
						SC1->C1_ZMOTREJ := Substr(_cItem,1,6)
						SC1->C1_COMPSTK := _aRet2[1]
						SC1->C1_CODCOMP := _aRet2[1]
						SC1->C1_QUJE    := 0 //SC1->C1_QUANT chamado 008237 - Devido a quantidade de entrega esta preenchida não estamos conseguindo exlcuir a solicitação e esta causando problemas no MRP. - Everson Santana - 22/10/18

						//>> chamado 008237
						If SC1->C1_SEQMRP <> ' '
							SC1->C1_TPOP := 'P'
						EndIF
						//<<chamado 008237

						SC1->(MsUnlock())
						// Acrescentado atualizado do SB2 abaixo referente ao chamado 005150 - Robson Mazzarotto
						dbSelectArea("SB2")
						dbSetOrder(1)
						dbGoTop()
						if dbSeek(xFilial("SB2")+SC1->C1_PRODUTO+SC1->C1_LOCAL)
							RecLock("SB2",.F.)
							SB2->B2_SALPEDI  := SB2->B2_SALPEDI - SC1->C1_QUANT
							SB2->(MsUnlock())
						Endif

						_cZMot:= 'A'
						DbSelectArea("SX5")
						SX5->(dbSetOrder(1))
						SX5->(dbSeek(xFilial("SX5") + 'Z6'))
						Do While SX5->(!EOF()).and. xFilial("SX5") = SX5->X5_FILIAL .And. SX5->X5_TABELA  = _cTabRej
							If SX5->X5_CHAVE  = SC1->C1_ZMOTREJ
								_cZMot:= ALLTRIM(SX5->X5_CHAVE)+' - '+ALLTRIM(SX5->X5_DESCRI)
							EndIf
							SX5->(DbSkip())
						EndDo

						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Envio de e-mail por Solicitação de Compras
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If _nMark == 1
							_cNumSC := SC1->C1_NUM
							_cSolic := SC1->C1_USER
							aAdd(_aItens,{ (SC1->C1_ITEM),;
							(SC1->C1_PRODUTO),;
							(SC1->C1_DESCRI),;
							(SC1->C1_UM),;
							(SC1->C1_QUANT),;
							(SC1->C1_MOTIVO),;
							Posicione("CTT",1,xFilial("CTT")+(SC1->C1_CC),"CTT_DESC01"),;
							(SC1->C1_OBS),;
							_cZMot})
							Processa({||U_STCOM020(cusername,dtoc(date()),time(),_aItens,_cNumSC,_nOpc,_cUser,_cSolic),"Enviando E-mail." })
							_aItens := {}
						Else
							If Empty(_cNumSC)
								_cNumSC := SC1->C1_NUM
							Endif

							If (_cNumSC == SC1->C1_NUM)
								_cSolic := SC1->C1_USER
								aAdd(_aItens,{ (SC1->C1_ITEM),;
								(SC1->C1_PRODUTO),;
								(SC1->C1_DESCRI),;
								(SC1->C1_UM),;
								(SC1->C1_QUANT),;
								(SC1->C1_MOTIVO),;
								Posicione("CTT",1,xFilial("CTT")+(SC1->C1_CC),"CTT_DESC01"),;
								(SC1->C1_OBS),;
								_cZMot})
							Else
								Processa({||U_STCOM020(cusername,dtoc(date()),time(),_aItens,_cNumSC,_nOpc,_cUser,_cSolic),"Enviando E-mail." })
								_aItens := {}
								_cNumSC := SC1->C1_NUM
								_cSolic := SC1->C1_USER
								aAdd(_aItens,{ (SC1->C1_ITEM),;
								(SC1->C1_PRODUTO),;
								(SC1->C1_DESCRI),;
								(SC1->C1_UM),;
								(SC1->C1_QUANT),;
								(SC1->C1_MOTIVO),;
								Posicione("CTT",1,xFilial("CTT")+(SC1->C1_CC),"CTT_DESC01"),;
								(SC1->C1_OBS),;
								' '})
							Endif
						Endif
					Endif
					SC1->( dbSkip() )
					_cStatus := ''
					_cMsg    := ''
				End
				End Transaction
				If Len(_aItens) > 0
					Processa({||U_STCOM020(cusername,dtoc(date()),time(),_aItens,_cNumSC,_nOpc,_cUser,_cSolic),"Enviando E-mail." })
				Endif
			Else
				ApMsgInfo(cTexto2,;
				"Rejeição por Compras")
			Endif
		Else
			ApMsgInfo("Não existem itens a serem rejeitados.",;
			"Rejeição por Compras")
		Endif

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ 5) Envio de E-Mail para Cotação de Preços
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ElseIf _nFlag == 5
		oMark:GoTop()
		dbSelectArea("SC1")
		SC1->(dbGoTop())
		While SC1->(!Eof())
			If oMark:IsMark()//SC1->C1_ZSTATUS == '6'
				_nMark ++
			Endif
			SC1->( dbSkip() )
		End

		If (_nMark > 0)
			oMark:GoTop()
			dbSelectArea("SC1")
			SC1->(dbGoTop())
			While SC1->(!Eof())
				If oMark:IsMark()
					If Empty(_cFilial)
						_cFilial := SC1->C1_FILIAL
					Endif
					If _cFilial == SC1->C1_FILIAL
						If !Empty(SC1->C1_CODCOMP)
							_nMark ++
							aAdd(_aCotacao,{;
							(SC1->C1_NUM),;    //01 - Número da SC
							(SC1->C1_ITEM),;      //02 - Item da SC
							(SC1->C1_PRODUTO),;   //03 - Código do Produto
							Posicione("SB1",1,xFilial("SB1")+(SC1->C1_PRODUTO),"B1_XDESEXD"),;   //04 - Descrição Extendida
							Posicione("SB1",1,xFilial("SB1")+(SC1->C1_PRODUTO),"B1_XDESENH"),;   //05 - Desenho
							(SC1->C1_UM),;        //06 - Unidade de Medida
							(SC1->C1_SEGUM),;     //07 - 2ª Unidade de Medida
							(SC1->C1_QUANT),;     //08 - Quantidade
							(SC1->C1_QTSEGUM),;   //09 - Quantidade 2ª Unidade de Medida
							("_"),;               //10 - Preço Unitário
							("_"),;               //11 - Alíquota de IPI
							("        /        /"),;  //12 - Data de Entrega
							(SC1->C1_MOTIVO);     //13 - Motivo de Compra
							})
						Else
							_lRet := .F.
							ApMsgInfo("Existem itens marcados sem comprador definido."+ Chr(10) + Chr(13) +;
							CHR(10)+CHR(13)+;
							"Favor utilizar essa opção apenas quando houver comprador definido.",;
							"Enviar Cotação")
							Exit
						Endif
					Else
						_lRet := .F.
						ApMsgInfo("Existem itens marcados de filiais diferentes."+ Chr(10) + Chr(13) +;
						CHR(10)+CHR(13)+;
						"Favor marcar apenas itens da mesma Filial.",;
						"Enviar Cotação")
						Exit
					Endif
				Endif
				SC1->( dbSkip() )
			End
			IF _lRet
				U_RSTFATAE(_aCotacao,cCompST,_cFilial)
			Endif
		Else
			ApMsgInfo("Não existem itens marcados para serem enviados por E-mail.",;
			"Enviar Cotação")
		Endif
	Endif

	RestArea(aArea3)
	RestArea(aArea2)
	RestArea(aArea1)
	RestArea(aArea)
	oMark:Refresh()

Return
