#include 'Protheus.ch'
#include 'FWMVCDEF.ch'
#Define CR chr(13)+chr(10)
/*====================================================================================\
|Programa  | STSTREKA         | Autor | GIOVANI.ZAGO             | Data | 11/07/2019  |
|=====================================================================================|
|Descri��o |  STSTREKA    Monta tela de manuten��o do STREKA                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STSTREKA                                                                 |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Hist�rico....................................|
\====================================================================================*/
*-----------------------------*
User Function STSTREKA()
	Local cAlias  := "Z36"
	Local cTitle  := "Gera��o de Embarque"
	Local oBrowse := FWMBrowse():New()
	
	Private aRotina := MenuDef()
	oBrowse:SetAlias(cAlias)
	oBrowse:SetDescription(cTitle)
	//oBrowse:AddLegend("Z36_STATUS=='1'", "GREEN" ,"Aberto")
	//oBrowse:AddLegend("Z36_STATUS=='2'", "BLUE","Fechado")
	//oBrowse:AddLegend("Z36_STATUS=='3'", "RED"  ,"Finalizado")
	
	oBrowse:Activate()
	
Return NIL

// ------------------------------------------------------------------------------------------ //
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MenuDef    �Autor  �Giovani Zago       � Data �  07/10/2015 ���
�������������������������������������������������������������������������͹��
���Desc.     �Fun��o para gerar os bot�es da rotina de Embarque           ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Steck Industria Eletrica Ltda.                             ���
�������������������������������������������������������������������������ͼ��
���Rotina    � STSTREKA.prw                                               ���
���Nome      � Gera��o de Embarque                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function MenuDef()
	
	Local aRotina := {}
	
	ADD OPTION aRotina TITLE "Pesquisar"            ACTION "PESQBRW"          OPERATION 1  ACCESS 0
	ADD OPTION aRotina TITLE "Visualizar"           ACTION "VIEWDEF.STSTREKA" OPERATION 2  ACCESS 0
	ADD OPTION aRotina TITLE "Incluir"              ACTION "VIEWDEF.STSTREKA" OPERATION 3  ACCESS 0
	ADD OPTION aRotina TITLE "Alterar"              ACTION "VIEWDEF.STSTREKA" OPERATION 4  ACCESS 0
	ADD OPTION aRotina TITLE "Excluir"              ACTION "VIEWDEF.STSTREKA" OPERATION 5  ACCESS 0
	ADD OPTION aRotina TITLE "Imprimir"             ACTION "VIEWDEF.STSTREKA" OPERATION 6  ACCESS 0
	ADD OPTION aRotina TITLE "Cad.Concorrente"       ACTION "u_xSTSTREKA()" OPERATION 2  ACCESS 0  

	
Return aRotina

// ------------------------------------------------------------------------------------------ //
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ModelDef   �Autor  �Giovani Zago       � Data �  07/10/2015 ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Steck Industria Eletrica Ltda.                             ���
�������������������������������������������������������������������������ͼ��
���Rotina    � STSTREKA.prw                                               ���
���Nome      � Gera��o de Embarque                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ModelDef()
	
	Local oStruZ36 := FWFormStruct(1, "Z36")
	Local oStruZ37 := FWFormStruct(1, "Z37")
	Local oModel   := MPFormModel():New("M3M")
	
	
	
	oModel:AddFields("Z36MASTER", /*cOwner*/, oStruZ36)
	oModel:AddGrid("Z37DETAIL", "Z36MASTER", oStruZ37,{|oX,Line,Acao| U_STRLINOK(oX,Line,Acao)},/**/,/*bLinePost*/,/*bPre*/,/*bPost*/,/*bLoad*/)
	oModel:SetRelation("Z37DETAIL", {{'Z37_FILIAL', 'xFilial("Z37")'}, {"Z37_COD", "Z36_COD"}}, 'Z37_FILIAL+Z37_COD+Z37_CONCO+Z37_CODCOC')
	oModel:SetDescription("STREKA")
	oModel:GetModel("Z36MASTER"):SetDescription("STECK")
	oModel:GetModel("Z37DETAIL"):SetDescription("CONCORRENTES")
	oModel:SetPrimaryKey({"Z36_FILIAL", "Z36_COD"})
	
	
	oModel:SetActivate( {|oMod| EMBVAR(oMod)} )
	oModel:SetVldActivate ( { |oMod| EMBVAR2( oMod ) } )
	
Return oModel

// ------------------------------------------------------------------------------------------ //
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ViewDef    �Autor  �Giovani Zago       � Data �  07/10/2015 ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Steck Industria Eletrica Ltda.                             ���
�������������������������������������������������������������������������ͼ��
���Rotina    � STSTREKA.prw                                               ���
���Nome      � Gera��o de Embarque                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ViewDef()
	
	Local oStruZ36 := FWFormStruct(2, "Z36")
	Local oStruZ37 := FWFormStruct(2, "Z37")
	Local oModel   := FWLoadModel("STSTREKA")
	Local oView    := NIL
	
	//oStruZ36:RemoveField("Z36_DTFIM")
	//oStruZ36:RemoveField("Z36_HRFIM")
	//oStruZ36:RemoveField("Z36_NUMPED")
	
	//oStruZ37:RemoveField("Z37_PEDIDO")
	//oStruZ37:RemoveField("Z37_ITEM")
	//oStruZ37:RemoveField("Z37_DTFIM")
	//oStruZ37:RemoveField("Z37_HRFIM")
	
	oView := FWFormView():New()
	
	oView:SetModel(oModel)
	oView:AddField("VIEW_Z36", oStruZ36, "Z36MASTER")
	oView:AddGrid("VIEW_Z37", oStruZ37, "Z37DETAIL")
	oView:CreateHorizontalBox("SUPERIOR", 50)
	oView:CreateHorizontalBox("INFERIOR", 50)
	oView:SetOwnerView("VIEW_Z36", "SUPERIOR")
	oView:SetOwnerView("VIEW_Z37", "INFERIOR")
	oView:EnableTitleView("VIEW_Z36")
	oView:EnableTitleView("VIEW_Z37")
	
Return oView

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �EMBVAR     �Autor  �Giovani Zago       � Data �  07/10/2015 ���
�������������������������������������������������������������������������͹��
���Desc.     �Fun��o para gravar campos quando o usu�rio realizar         ���
���          �altera��o de Embarque                                       ���
�������������������������������������������������������������������������͹��
���Uso       � Steck Industria Eletrica Ltda.                             ���
�������������������������������������������������������������������������ͼ��
���Rotina    � STSTREKA.prw                                               ���
���Nome      � Gera��o de Embarque                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function EMBVAR(oModel)
	Local nOp := oModel:GetOperation()
	
	If nOp == MODEL_OPERATION_INSERT //C�pia tamb�m � reconhecida como inser��o
		
		//oModel:SetValue("Z36MASTER", "Z36_DTEMIS" , DDATABASE)
		//oModel:SetValue("Z36MASTER", "Z36_HRINI" , SubStr(TIME(), 1, 5))
		//oModel:SetValue("Z36MASTER", "Z36_USERIN", cUserName)
		
	EndIf
	
Return (.T.)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �EMBVAR2    �Autor  �Giovani Zago       � Data �  07/10/2015 ���
�������������������������������������������������������������������������͹��
���Desc.     �Fun��o para validar acesso aos bot�es padr�es da rotina     ���
���          �de Embarque                                                 ���
�������������������������������������������������������������������������͹��
���Uso       � Steck Industria Eletrica Ltda.                             ���
�������������������������������������������������������������������������ͼ��
���Rotina    � STSTREKA.prw                                               ���
���Nome      � Gera��o de Embarque                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function EMBVAR2(oModel)
	Local _lRet    := .T.
	Local nOp      := oModel:GetOperation()
	Local _cGrp    := SuperGetMV("ST_GRPEMB",.F.,"000000")
	Local _aGrupos := {}
	/*
	//������������������������������������������������������������������������Ŀ
	//�Valida��o de Grupo de Usu�rio para acesso aos bot�es da rotina de Embarque
	//��������������������������������������������������������������������������
	PswOrder(1)
	If PswSeek(__cUserId,.T.)
		_aGrupos  := PswRet()
	Endif
	
	If (_aGrupos[1][10][1] $ _cGrp)
		//������������������������������������������������������������������������Ŀ
		//�Valida��o para 3-Inclus�o
		//��������������������������������������������������������������������������
		If nOp == 3
			Help( ,, 'Help',, "A Inclus�o de Embarque deve ser realizada pelo Coletor de Dados...!!!";
				+CHR(10)+CHR(13)+;
				"A��o n�o permitida...!!!";
				+CHR(10)+CHR(13)+;
				"Favor Verificar...!!!",;
				1, 0 )
			_lRet := .F.
			
			//������������������������������������������������������������������������Ŀ
			//�Valida��o para Altera��o em Embarque que est� com Status diferente de 1-Aberto
			//��������������������������������������������������������������������������
		ElseIf (nOp = MODEL_OPERATION_UPDATE  .Or. nOp = MODEL_OPERATION_DELETE ) .And. Z36->Z36_STATUS <> '1'
			Help( ,, 'Help',, "Opera��o cancelada, Reabra o Embarque...!!!", 1, 0 )
			_lRet := .F.
		Endif
	Else
		Help( ,, 'Help',, "Usu�rio sem permiss�o para a rotina de embarque...!!!";
			+CHR(10)+CHR(13)+;
			"A��o n�o permitida...!!!";
			+CHR(10)+CHR(13)+;
			"Favor Verificar...!!!",;
			1, 0 )
		_lRet := .F.
	EndIf
	
	*/
Return (_lRet)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �STRLINOK   �Autor  �Giovani Zago       � Data �  07/10/2015 ���
�������������������������������������������������������������������������͹��
���Desc.     �Fun��o para validar a linha da rotina do   streka           ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Steck Industria Eletrica Ltda.                             ���
�������������������������������������������������������������������������ͼ��
���Rotina    � STSTREKA.prw                                               ���
���Nome      � Gera��o do streka                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function STRLINOK(oModel,nLine,Acao)
	Local _lRem := .T.
	Local nI
	Local lFlag := .F.
	Local nProd		:= Ascan(oModel:aHeader,{|x| AllTrim(Upper(x[2]))=="Z37_CONCO"})
	Local nOp		:= Ascan(oModel:aHeader,{|x| AllTrim(Upper(x[2]))=="Z37_CODCOC"})
/*
	If Acao <> 'DELETE'
		For nI := 1 To oModel:Length()
			oModel:GoLine( nI )
			//Chamado 002701 Abre
			If oModel:getLine() <>   nLine    .And. !(oModel:Acols[ oModel:getLine(),(Len(oModel:aHeader)+1)])      .And. _lRem
				If 	oModel:Acols[ oModel:getLine(),nProd] =   FwFldGet("Z37_CONCO",nLine) .And. 	oModel:Acols[ oModel:getLine(),nOp] =   FwFldGet("Z37_CODCOC",nLine)
					Help( ,, 'Help',, "Aten��o Produto J� Cadastrados", 1, 0 )
					_lRem := .F.
				EndIf
			EndIf
			//Chamado 002701 Fecha
			oModel:GoLine( nI )
		Next nI
	EndIf
	oModel:GoLine( nLine )
	*/
	
	
Return(_lRem)


User Function STREKA()
	*-----------------------------*
	Local _cRet:= 'STECK' 

	DbSelectArea("SX5")
	SX5->(dbSetOrder(1))
	SX5->(dbSeek(xFilial("SX5") + '_G'))
	Do While SX5->(!EOF()) .and. xFilial("SX5") = SX5->X5_FILIAL .And. SX5->X5_TABELA  = '_G'
		_cRet+= ';'+ALLTRIM(SX5->X5_DESCRI)
		SX5->(DbSkip())
	EndDo

Return(_cRet)
