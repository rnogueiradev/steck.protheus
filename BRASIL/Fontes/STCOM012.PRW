#INCLUDE "PROTHEUS.CH"
#include 'FWMVCDEF.ch'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � STCOM012     �Autor  �Joao Rinaldi    � Data �  15/12/2015 ���
�������������������������������������������������������������������������͹��
���Desc.     � Cadastro para vinculo de Aprovadores com Solicitantes      ���
���          � de Compras                                                 ���
���          � Tela desenvolvida em MVC Modelo 3                          ���
���          � Obrigat�rio o uso de 2 tabelas                             ���
�������������������������������������������������������������������������͹��
���Fun��es   � ModelDef: Cont�m a regra de negocio                        ���
���          � ViewDef: Cont�m a interface                                ���
���          � MenuDef: Op��es do menu (aRotina)                          ���
���          � IniPad: Inicializador Padr�o                               ���
���          � VldAcess: Valida��o de Acesso                              ���
���          � VldTOK: Valida��o na Confirma��o                           ���
���          � GrvTOK: Valida��o ap�s a Confirma��o                       ���
���          � StQuery1: Query 1 do relat�rio                             ���
���          � STCOM013: Sequ�ncial do Item                               ���
�������������������������������������������������������������������������͹��
���Uso       � Steck Industria Eletrica Ltda.                             ���
�������������������������������������������������������������������������͹��
���Chamado   � 002612 - Automatizar Solicita��o de Compras                ���
���Solic.    � Juliana Queiroz - Depto. Compras                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function STCOM012()
	
	//������������������������������������������������������������������������Ŀ
	//�Declara��o das Vari�veis
	//��������������������������������������������������������������������������
	Local _cAlias1  := "SZH"
	Local _cFiltro  := ""
	Local _cUser    := ""
	Private cTitle  := "Aprovador x Solicitantes"
	Private _cCID   := "MOD3012"
	Private _cSSID  := "STCOM012"
	Private aRotina := MenuDef(_cSSID)
	Private oBrowse
	
	//������������������������������������������������������������������������Ŀ
	//�Valida��o de acesso a rotina do aprovador principal e/ou substituto
	//��������������������������������������������������������������������������
	_cUser := U_STCOM021()
	
	If Empty(_cUser) //Ajustado a logico do aprovador chamado 004436 Robson Mazzarotto
		Return
	elseif len(_cUser) = 12
		_cUser := Substr(_cUser,1,6)
		_cFiltro := "ZH_APROVP == '"+_cUser+"'"
	Elseif len(_cUser) = 6  
		if _cUser == __cUserId
		_cUser := Substr(_cUser,1,6)
		_cFiltro := "ZH_APROVP == '"+_cUser+"'"
		else
		_cUser := ""		
	   _cFiltro := "ZH_APROVP == '"+_cUser+"'"
	   endif
	Endif
	
		
	//������������������������������������������������������������������������Ŀ
	//�Constru��o b�sica de um Browse
	//��������������������������������������������������������������������������
	oBrowse := FWMBrowse():New()
	
	//������������������������������������������������������������������������Ŀ
	//�Defini��o da tabela que ser� exibida na Browse utilizando o m�todo SetAlias
	//��������������������������������������������������������������������������
	oBrowse:SetAlias(_cAlias1)
	

	oBrowse:SetWalkThru(.F.)
	oBrowse:SetAmbiente(.F.)
	oBrowse:SetUseFilter(.T.)	
	//������������������������������������������������������������������������Ŀ
	//�Defini��o do t�tulo que ser� exibido como m�todo SetDescription
	//��������������������������������������������������������������������������
	oBrowse:SetDescription(cTitle)
	
	//������������������������������������������������������������������������Ŀ
	//�Defini��o do filtro ao browse
	//��������������������������������������������������������������������������
	oBrowse:SetFilterDefault( _cFiltro )
	
	//������������������������������������������������������������������������Ŀ
	//�Defini��o das legendas do browse
	//��������������������������������������������������������������������������
	oBrowse:AddLegend("!EMPTY(ZH_APROVP).And. Empty(ZH_DTFIMAP)"                                    ,"RED" ,"Bloqueado")
	oBrowse:AddLegend("!EMPTY(ZH_APROVP) .And. ZH_DTFIMAP < dDatabase"                              ,"BLUE"  ,"Inativo")
	oBrowse:AddLegend("!EMPTY(ZH_APROVP).And. ZH_DTFIMAP >= dDatabase .And. ZH_DTFIMAS < dDatabase" ,"GREEN"  ,"Ativo")
	oBrowse:AddLegend("!EMPTY(ZH_APROVS).And. ZH_DTFIMAS >= dDatabase .And. ZH_DTFIMAP >= dDatabase","BLACK" ,"Substituto")
	
	//������������������������������������������������������������������������Ŀ
	//�Desliga a exibi��o dos detalhes
	//��������������������������������������������������������������������������
	oBrowse:DisableDetails()
	
	//������������������������������������������������������������������������Ŀ
	//�Ativa��o da classe
	//��������������������������������������������������������������������������
	oBrowse:Activate()
	
Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MenuDef      �Autor  �Joao Rinaldi    � Data �  15/12/2015 ���
�������������������������������������������������������������������������͹��
���Desc.     � A fun��o MenuDef define as op��es (Menu) que estar�o       ���
���          � dispon�veis ao usu�rio                                     ���
�������������������������������������������������������������������������͹��
���Uso       � Steck Industria Eletrica Ltda.                             ���
�������������������������������������������������������������������������ͼ��
���Rotina    � STCOM010.prw                                               ���
���Nome      � Cadastro de Aprovadores de Solicita��o de Compras          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function MenuDef(_cSSID)
	
	Local _cProgram := ALLTRIM(UPPER(funname()))
	Local aRotina   := {}
	
	If !Empty(_cProgram)
		//������������������������������������������������������������������������Ŀ
		//�Op��es padr�es do MVC
		// 1 para Pesquisar
		// 2 para Visualizar
		// 3 para Incluir
		// 4 para Alterar
		// 5 para Excluir
		// 6 para Imprimir
		// 7 para Copiar
		// 8 Op��es Customizadas
		//��������������������������������������������������������������������������
		ADD OPTION aRotina TITLE "Pesquisar"    ACTION "PESQBRW"         OPERATION 1  ACCESS 0
		ADD OPTION aRotina TITLE "Visualizar"   ACTION "VIEWDEF.STCOM012" OPERATION 2  ACCESS 0
		ADD OPTION aRotina TITLE "Alterar"      ACTION "VIEWDEF.STCOM012" OPERATION 4  ACCESS 0
		
	Endif
Return aRotina
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � ModelDef     �Autor  �Joao Rinaldi    � Data �  15/12/2015 ���
�������������������������������������������������������������������������͹��
���Desc.     � A fun��o ModelDef define a regra de neg�cios propriamente  ���
���          � dita onde s�o definidas:                                   ���
���          � 1) Todas as entidades (tabelas) que far�o parte do modelo  ���
���          � de dados (Model)                                           ���
���          � 2) Regras de depend�ncia entre as entidades                ���
���          � 3) Valida��es (de campos e aplica��o)                      ���
���          � 4) Persist�ncia dos dados (grava��o)                       ���
�������������������������������������������������������������������������͹��
���Uso       � Steck Industria Eletrica Ltda.                             ���
�������������������������������������������������������������������������ͼ��
���Rotina    � STCOM010.prw                                               ���
���Nome      � Cadastro de Aprovadores de Solicita��o de Compras          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ModelDef()
	
	Local oStruCabec := FWFormStruct(1, "SZH")// Constru��o de estrutura de dados
	Local oStruItens := FWFormStruct(1, "SZJ")// Constru��o de estrutura de dados
	Local oModel
	Local _cTitulo   := "Aprovador x Solicitantes"
	Local _cCabec    := "Dados do Aprovador"
	Local _cItens    := "Rela��o de Solicitantes"
	Local _aRel      := {}
	Local aAux1      := CreateTrigger(1)
	
	//������������������������������������������������������������������������Ŀ
	//� Executo os gatilhos sem a utiliza��o do arquivo SX7.
	//��������������������������������������������������������������������������
	oStruItens:AddTrigger( ;
		aAux1[1] , ;// [01] Id do campo de origem
	aAux1[2] , ;// [02] Id do campo de destino
	aAux1[3] , ;// [03] Bloco de codigo de valida��o da execu��o do gatilho
	aAux1[4] )  // [04] Bloco de codigo de execu��o do gatilho
	
	
	//������������������������������������������������������������������������Ŀ
	//� Cria o objeto do Modelo de Dados
	//� Irie usar uma fun��o VldTOK que ser� acionada quando eu clicar no bot�o "Confirmar"
	//� Irie usar uma fun��o GrvTOK que ser� acionada ap�s a confirma��o do bot�o "Confirmar"
	//��������������������������������������������������������������������������
	oModel := MPFormModel():New(_cCID  , /*bPreValidacao*/ ,  { | oModel | VldTOK( oModel ) }  ,  { | oModel | GrvTOK( oModel ) }  , /*bCancel*/ )
	//        MPFORMMODEL():New(<cID>  ,  <bPre >          , <bPost >                          , <bCommit >                        , <bCancel >)
	//������������������������������������������������������������������������Ŀ
	//� Abaixo irei iniciar o campo X5_TABELA com o conteudo da sub-tabela
	//��������������������������������������������������������������������������
	//oStruCabec:SetProperty('X5_TABELA' , MODEL_FIELD_INIT,{||'21'} )
	
	//������������������������������������������������������������������������Ŀ
	//� Abaixo irei bloquear/liberar os campos para edi��o
	//��������������������������������������������������������������������������
	oStruCabec:SetProperty('ZH_FILIAL'  , MODEL_FIELD_WHEN,{|| .F. })
	oStruCabec:SetProperty('ZH_APROVP'  , MODEL_FIELD_WHEN,{|| .F. })
	oStruCabec:SetProperty('ZH_DTINIAP' , MODEL_FIELD_WHEN,{|| .F. })
	oStruCabec:SetProperty('ZH_DTINIAP' , MODEL_FIELD_WHEN,{|| .F. })
	oStruCabec:SetProperty('ZH_DTFIMAP' , MODEL_FIELD_WHEN,{|| .F. })
	oStruCabec:SetProperty('ZH_STATUS'  , MODEL_FIELD_WHEN,{|| .F. })
	oStruCabec:SetProperty('ZH_APROVS'  , MODEL_FIELD_WHEN,{|| .T. })
	oStruCabec:SetProperty('ZH_DTINIAS' , MODEL_FIELD_WHEN,{|| .T. })
	oStruCabec:SetProperty('ZH_DTFIMAS' , MODEL_FIELD_WHEN,{|| .T. })
	//������������������������������������������������������������������������Ŀ
	//� Podemos usar as fun��es INCLUI ou ALTERA
	//��������������������������������������������������������������������������
	//oStruCabec:SetProperty('X5_CHAVE'  , MODEL_FIELD_WHEN,{|| INCLUI })
	
	//������������������������������������������������������������������������Ŀ
	//� Ou usar a propriedade GetOperation que captura a opera��o que est� sendo executada
	//��������������������������������������������������������������������������
	//oStruCabec:SetProperty("X5_CHAVE"  , MODEL_FIELD_WHEN,{|oModel| oModel:GetOperation()== 3 })
	
	//������������������������������������������������������������������������Ŀ
	//� Adiciona ao modelo uma estrutura de formul�rio de edi��o por campo
	//��������������������������������������������������������������������������
	oModel:AddFields("CABECALHO", /*cOwner*/, oStruCabec)
	oModel:AddGrid("ITENS","CABECALHO", oStruItens)//,{|oX,Line,Acao| U_STEMBLINOK(oX,Line,Acao)},/**/,/*bLinePost*/,/*bPre*/,/*bPost*/,/*bLoad*/)
	
	//������������������������������������������������������������������������Ŀ
	//� Fazendo o relacionamento entre o Cabe�alho e Item
	//��������������������������������������������������������������������������
	aAdd(_aRel, {'ZJ_FILIAL' , 'ZH_FILIAL'} )
	aAdd(_aRel, {'ZJ_APROVP' , 'ZH_APROVP'} )
	
	//������������������������������������������������������������������������Ŀ
	//� Fazendo o relacionamento entre os compomentes do model
	//��������������������������������������������������������������������������
	oModel:SetRelation('ITENS', _aRel, SZJ->(IndexKey(2))) //IndexKey -> quero a ordena��o e depois filtrado
	//oModel:SetRelation('ITENS', _aRel, 'ZI_FILIAL+ZI_ITEM') //IndexKey -> quero a ordena��o e depois filtrado
	
	//������������������������������������������������������������������������Ŀ
	//� Fazendo a valida��o para n�o permitir linha duplicada
	//��������������������������������������������������������������������������
	oModel:GetModel('ITENS'):SetUniqueLine({"ZJ_SOLICIT"})  //N�o repetir informa��es ou combina��es {"CAMPO1","CAMPO2","CAMPOX"}
	
	//������������������������������������������������������������������������Ŀ
	//� Define a chave primaria utilizada pelo modelo
	//��������������������������������������������������������������������������
	oModel:SetPrimaryKey({})
	//oModel:SetPrimaryKey({"ZI_CC"})
	
	//������������������������������������������������������������������������Ŀ
	//� Adiciona a descricao do Componente do Modelo de Dados
	//��������������������������������������������������������������������������
	oModel:SetDescription(_cTitulo)
	oModel:GetModel("CABECALHO"):SetDescription(_cCabec)
	oModel:GetModel("ITENS"):SetDescription(_cItens)
	oModel:GetModel("ITENS"):lUseCols := .T.

	//������������������������������������������������������������������������Ŀ
	//� Valida��o para inicializador padr�o
	//��������������������������������������������������������������������������
	oModel:SetActivate( {|oMod| IniPad(oMod)} )
	
	//������������������������������������������������������������������������Ŀ
	//� Valida��o da ativa��o do modelo
	//��������������������������������������������������������������������������
	oModel:SetVldActivate ( { |oMod| VldAcess( oMod ) } )
	
Return oModel

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � ViewDef      �Autor  �Joao Rinaldi    � Data �  15/12/2015 ���
�������������������������������������������������������������������������͹��
���Desc.     � A fun��o ViewDef define como o ser� a interface e portanto ���
���          � como o usu�rio interage com o modelo de dados (Model)      ���
���          � recebendo os dados informados pelo usu�rio, fornecendo     ���
���          � ao modelo de dados (definido na ModelDef) e apresentando   ���
���          � o resultado.                                               ���
�������������������������������������������������������������������������͹��
���Uso       � Steck Industria Eletrica Ltda.                             ���
�������������������������������������������������������������������������ͼ��
���Rotina    � STCOM010.prw                                               ���
���Nome      � Cadastro de Aprovadores de Solicita��o de Compras          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ViewDef()
	
	Local oStruCabec := FWFormStruct(2, "SZH")
	Local oStruItens := FWFormStruct(2, "SZJ")
	Local oModel     := FWLoadModel(_cSSID)
	Local oView
	
	//������������������������������������������������������������������������Ŀ
	//� Cria o objeto de View
	//��������������������������������������������������������������������������
	oView := FWFormView():New()
	oView:SetModel(oModel)
	
	//������������������������������������������������������������������������Ŀ
	//� Remove os campos que n�o ir�o aparecer
	//��������������������������������������������������������������������������
	//oStruCabec:RemoveField("ZH_CC")
	oStruCabec:RemoveField("ZH_FILIAL")
	oStruItens:RemoveField("ZJ_FILIAL")
	oStruItens:RemoveField("ZJ_APROVP")
	
	//������������������������������������������������������������������������Ŀ
	//� Adicionando os campos do cabe�alho e o grid dos itens
	//��������������������������������������������������������������������������
	oView:AddField("VIEW_CABEC", oStruCabec, "CABECALHO")
	oView:AddGrid ("VIEW_ITENS", oStruItens, "ITENS")
	
	//������������������������������������������������������������������������Ŀ
	//� Criar um "box" horizontal para receber algum elemento da view e Setando o dimensionamento de tamanho
	//��������������������������������������������������������������������������
	oView:CreateHorizontalBox("SUPERIOR", 40)
	oView:CreateHorizontalBox("INFERIOR", 60)
	
	//������������������������������������������������������������������������Ŀ
	//� Amarrando a view com as box
	//��������������������������������������������������������������������������
	oView:SetOwnerView("VIEW_CABEC", "SUPERIOR")
	oView:SetOwnerView("VIEW_ITENS", "INFERIOR")
	
	//������������������������������������������������������������������������Ŀ
	//� For�a o fechamento da janela na confirma��o
	//��������������������������������������������������������������������������
	oView:SetCloseOnOk({||.T.})
	
	//������������������������������������������������������������������������Ŀ
	//� Habilitando t�tulo
	//��������������������������������������������������������������������������
	oView:EnableTitleView("VIEW_CABEC")
	oView:EnableTitleView("VIEW_ITENS")
	
Return oView

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � IniPad       �Autor  �Joao Rinaldi    � Data �  15/12/2015 ���
�������������������������������������������������������������������������͹��
���Desc.     � A fun��o IniPad define os campos e conte�dos a serem       ���
���          � exibidos como Inicializador Padr�o                         ���
�������������������������������������������������������������������������͹��
���Uso       � Steck Industria Eletrica Ltda.                             ���
�������������������������������������������������������������������������ͼ��
���Rotina    � STCOM010.prw                                               ���
���Nome      � Cadastro de Aprovadores de Solicita��o de Compras          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function IniPad(oModel)
	
	Local nOp := oModel:GetOperation()
	
	If nOp == MODEL_OPERATION_INSERT //C�pia tamb�m � reconhecida como inser��o
		
		oModel:SetValue("ITENS", "ZJ_ITEM" , '001')
		
	EndIf
	
Return (.T.)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � VldAcess     �Autor  �Joao Rinaldi    � Data �  15/12/2015 ���
�������������������������������������������������������������������������͹��
���Desc.     � A fun��o Acess define as permiss�es de acesso a rotina     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Steck Industria Eletrica Ltda.                             ���
�������������������������������������������������������������������������ͼ��
���Rotina    � STCOM010.prw                                               ���
���Nome      � Cadastro de Aprovadores de Solicita��o de Compras          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function VldAcess(oModel)
	
	Local lAcess    := .T.
	/*Local nOp      := oModel:GetOperation()
	
	Local _cGrp    := '000000/000209/000122/000091'
	Local _aGrupos := {}
	
	//������������������������������������������������������������������������Ŀ
	//� Valida��o de Grupo de Usu�rio para acesso aos bot�es da rotina
	//��������������������������������������������������������������������������
	PswOrder(1)
	If PswSeek(__cUserId,.T.)
		_aGrupos  := PswRet()
	Endif
	
	If !(_aGrupos[1][10][1] $ _cGrp)
		Help( ,, 'Help',, "Usu�rio sem permiss�o para a rotina de "+cTitle+".";
			+CHR(10)+CHR(13)+;
			"A��o n�o permitida.";
			+CHR(10)+CHR(13)+;
			"Favor Verificar.",;
			1, 0 )
		lAcess := .F.
	EndIf
	*/
Return (lAcess)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � VldTOK       �Autor  �Joao Rinaldi    � Data �  15/12/2015 ���
�������������������������������������������������������������������������͹��
���Desc.     � A fun��o VldTOK � acionada no bot�o Confirmar e valida     ���
���          � se as informa��es digitadas est�o corretas                 ���
�������������������������������������������������������������������������͹��
���Uso       � Steck Industria Eletrica Ltda.                             ���
�������������������������������������������������������������������������ͼ��
���Rotina    � STCOM010.prw                                               ���
���Nome      � Cadastro de Aprovadores de Solicita��o de Compras          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function VldTOK( oModel )
	
	//	Local nOp         := oModel:GetOperation()
	Local oModelCabec := oModel:GetModel( "CABECALHO" )
	Local cAPROVP     := oModelCabec:GetValue('ZH_APROVP')
	Local cLog        := oModelCabec:GetValue('ZH_LOG')
	Local oModelItens := oModel:GetModel( "ITENS" )
	Local _cSolicit   := ''
	Local lVld        := .T.
	Local _lAltItens  := .F.
	Local _cMsgItens  := ''
	Local _cSx3       := ''
	Local _nI
	Local _nJ
	Local _nK
	Local _cStatus    := ''
	
	//������������������������������������������������������������������������Ŀ
	//� Valida��o no preenchimento dos campos dos Itens
	//��������������������������������������������������������������������������
	For _nK := 1 To oModelItens:Length()
		oModelItens:GoLine( _nK )
		_cSolicit := oModelItens:GetValue('ZJ_SOLICIT')
		If !(oModelItens:IsDeleted())
			If _cSolicit == cAPROVP
				Help( ,, 'Help',, "O C�digo do "+Alltrim((RetTitle("ZH_APROVP")))+" '"+Alltrim(cAPROVP)+"' n�o pode ser utilizado como "+Alltrim((RetTitle("ZJ_SOLICIT")))+".";
					+CHR(10)+CHR(13)+;
					"O Cadastro n�o ser� efetivado.";
					+CHR(10)+CHR(13)+;
					"Favor Verificar.",;
					1, 0 )
				lVld := .F.
				Exit
			Endif
		Endif
	Next _nK
	
	//������������������������������������������������������������������������Ŀ
	//� An�lise das altera��es realizadas nos itens para atualiza��o do campo ZH_LOG
	//��������������������������������������������������������������������������
	If lVld
		_cMsgItens	+= "==================================="+CHR(13) +CHR(10)
		_cMsgItens	+= "Altera��es realizadas nos Itens (Solicitantes):"+CHR(13) +CHR(10)
		_cMsgItens	+= "Usu�rio: "+cUserName+CHR(13) +CHR(10)
		_cMsgItens	+= "Alterado em: "+DTOC(DDATABASE)+" "+TIME()+CHR(13) +CHR(10)
		_cMsgItens	+= "Campo | Descri��o | Status | Anterior | Novo "+CHR(13) +CHR(10)
		
		For _nI := 1 To oModelItens:Length()
			oModelItens:GoLine( _nI )
			
			SZJ->(DbGoto(oModelItens:GetdataID(_nI)))//Recno
			
			DbSelectArea("SX3")
			SX3->(DbGoTop())
			SX3->(DbSetOrder(1))
			SX3->(DbSeek("SZJ"))
			
			While SX3->(!Eof()) .And. AllTrim(SX3->X3_ARQUIVO)=="SZJ"
				If !((SX3->X3_CONTEXT) == 'V')
					_cSx3 := oModelItens:GetValue((SX3->X3_CAMPO))
					For _nJ := 1 to Len(oModelItens:Aheader)
						If (Alltrim(oModelItens:aHeader[_nJ][2]) == Alltrim(SX3->X3_CAMPO))
							If  !((oModelItens:aCols[_nI][_nJ])  ==  &("SZJ->"+SX3->X3_CAMPO)) .Or. (oModelItens:aCols[_nI][len(oModelItens:aCols[_nI])])//Conte�do
								
								DO CASE
								CASE (oModelItens:GetdataID(_nI)) = 0
									_cStatus := "Novo Registro: "
								CASE (oModelItens:aCols[_nI][len(oModelItens:aCols[_nI])])
									_cStatus := "Registro Deletado: "
								CASE !((oModelItens:aCols[_nI][_nJ])  ==  &("SZJ->"+SX3->X3_CAMPO))
									_cStatus := "Registro Alterado: "
								ENDCASE
								_cMsgItens		+= SX3->X3_CAMPO + " | " + Alltrim(RetTitle(SX3->X3_CAMPO)) + " | "
								DO CASE
								CASE AllTrim(SX3->X3_TIPO )=="C"
									_cMsgItens		+= _cStatus +" | "+ &("SZJ->"+SX3->X3_CAMPO)+" | "+(_cSx3)+CHR(13)+CHR(10)
								CASE AllTrim(SX3->X3_TIPO )=="N"
									_cMsgItens		+= _cStatus +" | "+ CVALTOCHAR(&("SZJ->"+SX3->X3_CAMPO))+" | "+CVALTOCHAR(_cSx3)+CHR(13)+CHR(10)
								CASE AllTrim(SX3->X3_TIPO )=="D"
									_cMsgItens		+= _cStatus +" | "+ DTOC(&("SZJ->"+SX3->X3_CAMPO))+" | "+DTOC(_cSx3)+CHR(13)+CHR(10)
								ENDCASE
								_lAltItens := .T.
							EndIf
						Endif
					Next _nJ
				Endif
				SX3->(DbSkip())
			EndDo
		Next _nI
		
		If !(_lAltItens)
			_cMsgItens := ''
		Endif
		
		If _lAltItens
			oModel:SetValue( 'CABECALHO', 'ZH_LOG', cLog +CHR(13)+CHR(10)+ _cMsgItens )
		EndIf
		
		
	Endif
	
	
Return lVld

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � GrvTOK       �Autor  �Joao Rinaldi    � Data �  15/12/2015 ���
�������������������������������������������������������������������������͹��
���Desc.     � A fun��o GrvTOK � acionada ap�s a confirma��o do bot�o     ���
���          � Confirmar                                                  ���
�������������������������������������������������������������������������͹��
���Uso       � Steck Industria Eletrica Ltda.                             ���
�������������������������������������������������������������������������ͼ��
���Rotina    � STCOM010.prw                                               ���
���Nome      � Cadastro de Aprovadores de Solicita��o de Compras          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GrvTOK( oModel )
	
	Local lGrv        := .T.
	//Local oModelCabec := oModel:GetModel( "CABECALHO" )
	Local oModelItens := oModel:GetModel( "ITENS" )
	//Local cAPROVP     := oModelCabec:GetValue('ZH_APROVP')
	Local nOK
	
	FWFormCommit( oModel )
	
	//������������������������������������������������������������������������Ŀ
	//� Valida��o no preenchimento dos campos dos Itens
	//��������������������������������������������������������������������������
	For nOK := 1 To oModelItens:Length()
		oModelItens:GoLine( nOK )
		_cSolicit := oModelItens:GetValue('ZJ_SOLICIT')
		If !(oModelItens:IsDeleted())
			DbSelectArea("SAI")
			SAI->(DbSetOrder(2))//AI_FILIAL+AI_USER
			SAI->(DbGoTop())
			If !DbSeek(xFilial("SAI")+_cSolicit)
				RecLock("SAI",.T.)
				SAI->AI_FILIAL  := xFilial("SAI")
				SAI->AI_ITEM    := '01'
				SAI->AI_GRUPO   := '*'
				SAI->AI_PRODUTO := '*'
				SAI->AI_DOMINIO := 'I'
				SAI->AI_GRUPCOM := '000001'
				SAI->AI_USER    := _cSolicit
				SAI->AI_GRUSER  := '******'
				SAI->AI_QUANT   := 0
				SAI->(MsUnLock())
			Endif
		Endif
	Next nOK
	
Return lGrv

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � STQUERY1     �Autor  �Joao Rinaldi    � Data �  15/12/2015 ���
�������������������������������������������������������������������������͹��
���Desc.     � A fun��o STQUERY1 � acionada pela fun��o VldTOK            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Steck Industria Eletrica Ltda.                             ���
�������������������������������������������������������������������������ͼ��
���Rotina    � STCOM010.prw                                               ���
���Nome      � Cadastro de Aprovadores de Solicita��o de Compras          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function STQUERY1()
	/*
	Local cPerg      := "STQUERY1"
	Local cTime      := Time()
	Local cHora      := SUBSTR(cTime, 1, 2)
	Local cMinutos   := SUBSTR(cTime, 4, 2)
	Local cSegundos  := SUBSTR(cTime, 7, 2)
	Local cAliasLif  := cPerg+cHora+cMinutos+cSegundos
	Local cAlias1    := cAliasLif
	Local cQuery1    := ' '
	*/
	Local lQuery     := .T.
	
	
Return lQuery

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � STCOM013     �Autor  �Joao Rinaldi    � Data �  15/12/2015 ���
�������������������������������������������������������������������������͹��
���Desc.     � A fun��o STCOM011 � acionada pelo campo X3_RELACAO do campo���
���          � ZJ_ITEM para gerar o sequ�ncial do item                    ���
�������������������������������������������������������������������������͹��
���Uso       � Steck Industria Eletrica Ltda.                             ���
�������������������������������������������������������������������������ͼ��
���Rotina    � STCOM010.prw                                               ���
���Nome      � Cadastro de Aprovadores de Solicita��o de Compras          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function STCOM013()
	
	Local _cItem	:= "000"
	Local _nItem	:= aScan(aHeader,{|w| AllTrim(w[2])=="ZJ_ITEM"})
	
	If n >= 1
		_cItem	:= aCols[n,_nItem]
	Endif
	
	_cItem	:= Soma1(_cItem,3)
	
Return(_cItem)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � CreateTrigger�Autor  �Joao Rinaldi    � Data �  20/01/2016 ���
�������������������������������������������������������������������������͹��
���Desc.     � A fun��o CreateTrigger executa os gatilhos sem a           ���
���          � utiliza��o do arquivo SX7.                                 ���
�������������������������������������������������������������������������͹��
���Uso       � Steck Industria Eletrica Ltda.                             ���
�������������������������������������������������������������������������ͼ��
���Rotina    � STCOM010.prw                                               ���
���Nome      � Cadastro de Aprovadores de Solicita��o de Compras          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function CreateTrigger(_nTrigger)
	
	Local aAux := {}
	
	If _nTrigger == 1
		aAux := FwStruTrigger(;
			"ZJ_SOLICIT",;            // Campo Dominio
		"ZJ_NOMESOL",;                // Campo de Contradominio
		"UsrRetName(M->ZJ_SOLICIT)",; // Regra de Preenchimento
		.F. ,;                        // Se posicionara ou nao antes da execucao do gatilhos
		"" ,;                         // Alias da tabela a ser posicionada
		0 ,;                          // Ordem da tabela a ser posicionada
		"" ,;                         // Chave de busca da tabela a ser posicionada
		NIL ,;                        // Condicao para execucao do gatilho
		"01" )                        // Sequencia do gatilho (usado para identificacao no caso de erro)
		
	Endif
	
Return aAux
