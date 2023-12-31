#INCLUDE "PROTHEUS.CH"
#include 'FWMVCDEF.ch'

/*====================================================================================\
|Programa  | STSX5REEM       | Autor | GIOVANI.ZAGO             | Data | 19/05/2017 |
|=====================================================================================|
|Sintaxe   | STSX5REEM                                                              |
|=====================================================================================|
|Uso       | Especifico Steck                                                         |
|=====================================================================================|
|........................................Hist�rico....................................|
\====================================================================================
*/
User Function STSX5REEM()
	
	//������������������������������������������������������������������������Ŀ
	//�Declara��o das Vari�veis
	//��������������������������������������������������������������������������
	Local aArea1    := GetArea()
	Local aArea2    := SX5->(GetArea())
	Local _cAlias1  := "SX5"
	Local _cFiltro  := "X5_TABELA == 'ZY'"
	Private cTitle  := "Politica de Reembolso"
	Private cChaveAux := ""
	Private _cGrp   := '000000/000645/'
	Private _cCID   := "MODREEM"
	Private _cSSID  := "STSX5REEM"
	Private aRotina := MenuDef(_cSSID)
	Private oBrowse
 
	
	DbSelectArea("SX5")
	SX5->(DbSetOrder(1))//X5_FILIAL+X5_TABELA+X5_CHAVE
	SX5->(DbGoTop())
	If !DbSeek(xFilial("SX5")+'ZY')
		/* Removido\Ajustado - N�o executa mais RecLock na X5. Cria��o/altera��o de dados deve ser feita apenas pelo m�dulo Configurador ou pela rotina de atualiza��o de vers�o.
		RecLock("SX5",.T.)
		SX5->X5_FILIAL   := xFilial("SX5")
		SX5->X5_TABELA   := 'ZY'
		SX5->X5_CHAVE    := '8'
		SX5->X5_DESCRI   :=  '0.73'
		SX5->X5_DESCSPA  :=  '0.73'
		SX5->X5_DESCENG  :=  '0.73'
		SX5->(MsUnLock())*/
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
	//oBrowse:AddLegend("ZH_STATUS=='1'" ,"BLUE"  ,"Inativo")
	//oBrowse:AddLegend("ZH_STATUS=='2'" ,"GREEN" ,"Ativo")
	//oBrowse:AddLegend("ZH_STATUS=='3'" ,"RED"   ,"Bloqueado")'
	//oBrowse:AddLegend("ZH_STATUS=='4'" ,"BLACK" ,"Substituto")
	
	//������������������������������������������������������������������������Ŀ
	//�Desliga a exibi��o dos detalhes
	//��������������������������������������������������������������������������
	oBrowse:DisableDetails()
	
	//������������������������������������������������������������������������Ŀ
	//�Ativa��o da classe
	//��������������������������������������������������������������������������
	oBrowse:Activate()
	
	RestArea(aArea2)
	RestArea(aArea1)
	
Return



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MenuDef      �Autor  �Joao Rinaldi    � Data �  14/12/2015 ���
�������������������������������������������������������������������������͹��
���Desc.     � A fun��o MenuDef define as op��es (Menu) que estar�o       ���
���          � dispon�veis ao usu�rio                                     ���
�������������������������������������������������������������������������͹��
���Uso       � Steck Industria Eletrica Ltda.                             ���
�������������������������������������������������������������������������ͼ��
���Rotina    � STSX5REEM.prw                                               ���
���Nome      � Cadastro de Motivos de Rejei��o de Solicita��o de Compras  ���
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
		ADD OPTION aRotina TITLE "Visualizar"   ACTION "VIEWDEF."+_cSSID OPERATION 2  ACCESS 0
		ADD OPTION aRotina TITLE "Incluir"      ACTION "VIEWDEF."+_cSSID OPERATION 3  ACCESS 0
		ADD OPTION aRotina TITLE "Alterar"      ACTION "VIEWDEF."+_cSSID OPERATION 4  ACCESS 0
		ADD OPTION aRotina TITLE "Excluir"      ACTION "VIEWDEF."+_cSSID OPERATION 5  ACCESS 0
		//ADD OPTION aRotina TITLE "Imprimir"     ACTION "VIEWDEF."+_cSSID OPERATION 8  ACCESS 0
		//ADD OPTION aRotina TITLE "Copiar"       ACTION "VIEWDEF."+_cSSID OPERATION 9  ACCESS 0
		//ADD OPTION aRotina TITLE "Excluir"      ACTION "U_STCOM015()"    OPERATION 8  ACCESS 0
		
	Endif
Return aRotina

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � ModelDef     �Autor  �Joao Rinaldi    � Data �  14/12/2015 ���
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
���Rotina    � STSX5REEM.prw                                               ���
���Nome      � Cadastro de Motivos de Rejei��o de Solicita��o de Compras  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ModelDef()
	
	Local oStruCabec := FWFormStruct(1, "SX5")// Constru��o de estrutura de dados
	Local oModel
	Local _cTitulo   := "Motivos de Rejei��o de Solicita��o de Compras"
	Local _cCabec    := "Dados do Aprovador"
	Local _cItens    := "Rela��o de Centro de Custo"
	Local _aRel      := {}

	
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
	oStruCabec:SetProperty('X5_TABELA' , MODEL_FIELD_INIT,{||'ZY'} )
	
	//������������������������������������������������������������������������Ŀ
	//� Abaixo irei bloquear/liberar os campos para edi��o
	//��������������������������������������������������������������������������
	oStruCabec:SetProperty('X5_TABELA' , MODEL_FIELD_WHEN,{|| .F. })
	
	//������������������������������������������������������������������������Ŀ
	//� Podemos usar as fun��es INCLUI ou ALTERA Ou usar a propriedade GetOperation que captura a opera��o que est� sendo executada
	//��������������������������������������������������������������������������
	oStruCabec:SetProperty('X5_CHAVE'  , MODEL_FIELD_WHEN,{|| INCLUI })
	//oStruCabec:SetProperty("X5_CHAVE"  , MODEL_FIELD_WHEN,{|oModel| oModel:GetOperation()== 3 })
	
	//������������������������������������������������������������������������Ŀ
	//� Adiciona ao modelo uma estrutura de formul�rio de edi��o por campo
	//��������������������������������������������������������������������������
	oModel:AddFields("CABECALHO", /*cOwner*/, oStruCabec)
	
	//������������������������������������������������������������������������Ŀ
	//� Fazendo o relacionamento entre o Cabe�alho e Item
	//��������������������������������������������������������������������������
	//aAdd(_aRel, {'X5_FILIAL' , 'X5_FILIAL'} )
	//aAdd(_aRel, {'X5_TABELA' , 'X5_TABELA'} )
	
	//������������������������������������������������������������������������Ŀ
	//� Fazendo o relacionamento entre os compomentes do model
	//��������������������������������������������������������������������������
	//oModel:SetRelation('ITENS', _aRel, SZI->(IndexKey(2))) //IndexKey -> quero a ordena��o e depois filtrado
	//oModel:SetRelation('ITENS', _aRel, 'ZI_FILIAL+ZI_ITEM') //IndexKey -> quero a ordena��o e depois filtrado
	
	//������������������������������������������������������������������������Ŀ
	//� Fazendo a valida��o para n�o permitir linha duplicada
	//��������������������������������������������������������������������������
	//oModel:GetModel('ITENS'):SetUniqueLine({"ZI_CC"})  //N�o repetir informa��es ou combina��es {"CAMPO1","CAMPO2","CAMPOX"}
	
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
	//oModel:GetModel("ITENS"):SetDescription(_cItens)
	
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
���Programa  � ViewDef      �Autor  �Joao Rinaldi    � Data �  14/12/2015 ���
�������������������������������������������������������������������������͹��
���Desc.     � A fun��o ViewDef define como o ser� a interface e portanto ���
���          � como o usu�rio interage com o modelo de dados (Model)      ���
���          � recebendo os dados informados pelo usu�rio, fornecendo     ���
���          � ao modelo de dados (definido na ModelDef) e apresentando   ���
���          � o resultado.                                               ���
�������������������������������������������������������������������������͹��
���Uso       � Steck Industria Eletrica Ltda.                             ���
�������������������������������������������������������������������������ͼ��
���Rotina    � STSX5REEM.prw                                               ���
���Nome      � Cadastro de Motivos de Rejei��o de Solicita��o de Compras  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ViewDef()
	
	Local oStruCabec := FWFormStruct(2, "SX5")
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
	oStruCabec:RemoveField( 'X5_DESCENG' )
	oStruCabec:RemoveField( 'X5_DESCSPA' )
	
	//������������������������������������������������������������������������Ŀ
	//� Adicionando os campos do cabe�alho e o grid dos itens
	//��������������������������������������������������������������������������
	oView:AddField("VIEW_CABEC", oStruCabec, "CABECALHO")
	//oView:AddGrid ("VIEW_ITENS", oStruItens, "ITENS")
	
	//������������������������������������������������������������������������Ŀ
	//� Criar um "box" horizontal para receber algum elemento da view e Setando o dimensionamento de tamanho
	//��������������������������������������������������������������������������
	oView:CreateHorizontalBox("SUPERIOR", 100)
	//oView:CreateHorizontalBox("INFERIOR", 60)
	
	//������������������������������������������������������������������������Ŀ
	//� Amarrando a view com as box
	//��������������������������������������������������������������������������
	oView:SetOwnerView("VIEW_CABEC", "SUPERIOR")
	//oView:SetOwnerView("VIEW_ITENS", "INFERIOR")
	
	//������������������������������������������������������������������������Ŀ
	//� For�a o fechamento da janela na confirma��o
	//��������������������������������������������������������������������������
	oView:SetCloseOnOk({||.T.})
	
	//������������������������������������������������������������������������Ŀ
	//� Habilitando t�tulo
	//��������������������������������������������������������������������������
	oView:EnableTitleView("VIEW_CABEC")
	//oView:EnableTitleView("VIEW_ITENS")
	
Return oView


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � IniPad       �Autor  �Joao Rinaldi    � Data �  14/12/2015 ���
�������������������������������������������������������������������������͹��
���Desc.     � A fun��o IniPad define os campos e conte�dos a serem       ���
���          � exibidos como Inicializador Padr�o                         ���
�������������������������������������������������������������������������͹��
���Uso       � Steck Industria Eletrica Ltda.                             ���
�������������������������������������������������������������������������ͼ��
���Rotina    � STSX5REEM.prw                                               ���
���Nome      � Cadastro de Motivos de Rejei��o de Solicita��o de Compras  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function IniPad(oModel)
	
	Local lIni := .T.
	/*
	Local nOp  := oModel:GetOperation()
	
	If nOp == MODEL_OPERATION_INSERT //C�pia tamb�m � reconhecida como inser��o
		
		oModel:SetValue("ITENS", "ZI_ITEM" , '001')
		
	EndIf
	*/
Return lIni

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � VldAcess     �Autor  �Joao Rinaldi    � Data �  14/12/2015 ���
�������������������������������������������������������������������������͹��
���Desc.     � A fun��o Acess define as permiss�es de acesso a rotina     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Steck Industria Eletrica Ltda.                             ���
�������������������������������������������������������������������������ͼ��
���Rotina    � STSX5REEM.prw                                               ���
���Nome      � Cadastro de Motivos de Rejei��o de Solicita��o de Compras  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function VldAcess(oModel)
	
	Local lAcess    := .T.
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
	
Return (lAcess)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � VldTOK       �Autor  �Joao Rinaldi    � Data �  14/12/2015 ���
�������������������������������������������������������������������������͹��
���Desc.     � A fun��o VldTOK � acionada no bot�o Confirmar e valida     ���
���          � se as informa��es digitadas est�o corretas                 ���
�������������������������������������������������������������������������͹��
���Uso       � Steck Industria Eletrica Ltda.                             ���
�������������������������������������������������������������������������ͼ��
���Rotina    � STSX5REEM.prw                                               ���
���Nome      � Cadastro de Motivos de Rejei��o de Solicita��o de Compras  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function VldTOK( oModel )
	
	//Local nOp         := oModel:GetOperation()
	Local oModelCabec := oModel:GetModel( "CABECALHO" )
	Local cTABELA     := oModelCabec:GetValue('X5_TABELA')
	Local cCHAVE      := oModelCabec:GetValue('X5_CHAVE')
	Local cDESCRI     := oModelCabec:GetValue('X5_DESCRI')
	Local lVld        := .T.
	
	//������������������������������������������������������������������������Ŀ
	//� Valida��o no preenchimento dos campos do Cabe�alho
	//��������������������������������������������������������������������������
	If Empty(Alltrim(cDESCRI))
		Help( ,, 'Help',, "O Campo "+Alltrim((RetTitle("X5_DESCRI")))+" precisa ser preenchido.";
			+CHR(10)+CHR(13)+;
			"O Cadastro n�o ser� efetivado.";
			+CHR(10)+CHR(13)+;
			"Favor Verificar.",;
			1, 0 )
		lVld := .F.
		

		
	ElseIf !Empty(cCHAVE) .And. INCLUI
		DbSelectArea("SX5")
		SX5->(DbSetOrder(1))//X5_FILIAL+X5_TABELA+X5_CHAVE
		SX5->(DbGoTop())
		If DbSeek(xFilial("SX5")+cTABELA+cCHAVE)
			Help( ,, 'Help',, "O C�digo da "+Alltrim((RetTitle("X5_CHAVE")))+" j� est� cadastrado.";
				+CHR(10)+CHR(13)+;
				"O Cadastro n�o ser� efetivado.";
				+CHR(10)+CHR(13)+;
				"Favor Verificar.",;
				1, 0 )
			lVld := .F.
		Endif
	Endif
	
Return lVld

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � GrvTOK       �Autor  �Joao Rinaldi    � Data �  14/12/2015 ���
�������������������������������������������������������������������������͹��
���Desc.     � A fun��o GrvTOK � acionada ap�s a confirma��o do bot�o     ���
���          � Confirmar                                                  ���
�������������������������������������������������������������������������͹��
���Uso       � Steck Industria Eletrica Ltda.                             ���
�������������������������������������������������������������������������ͼ��
���Rotina    � STSX5REEM.prw                                               ���
���Nome      � Cadastro de Motivos de Rejei��o de Solicita��o de Compras  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GrvTOK( oModel )
	
	Local nOp         := oModel:GetOperation()
	Local lGrv        := .T.
	Local oModelCabec := oModel:GetModel( "CABECALHO" )
	Local cTABELA     := oModelCabec:GetValue('X5_TABELA')
	Local cCHAVE      := oModelCabec:GetValue('X5_CHAVE')
	Local cDESCRI     := oModelCabec:GetValue('X5_DESCRI')
	
	FWFormCommit( oModel )
	
	If cValtochar(nOp) $ '3/4'
		DbSelectArea("SX5")
		SX5->(DbSetOrder(1))//X5_FILIAL+X5_TABELA+X5_CHAVE
		SX5->(DbGoTop())
		If DbSeek(xFilial("SX5")+cTABELA+cCHAVE)
			/* Removido\Ajustado - N�o executa mais RecLock na X5. Cria��o/altera��o de dados deve ser feita apenas pelo m�dulo Configurador ou pela rotina de atualiza��o de vers�o.
			RecLock("SX5",.F.)
			SX5->X5_DESCSPA  := cDESCRI
			SX5->X5_DESCENG  := cDESCRI
			SX5->(MsUnLock())*/
		Endif
	Endif
	
Return lGrv
