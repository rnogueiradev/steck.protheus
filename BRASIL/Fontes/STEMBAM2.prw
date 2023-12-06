#include 'Protheus.ch'
#include 'FWMVCDEF.ch'
#Define CR chr(13)+chr(10)
/*====================================================================================\
|Programa  | STEMBAM2         | Autor | GIOVANI.ZAGO             | Data | 04/05/2015  |
|=====================================================================================|
|Descri��o |  STEMBAM2    Monta tela de manuten��o do embarque                        |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STEMBAM2                                                                 |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Hist�rico....................................|
\====================================================================================*/
*-----------------------------*
User Function STEMBAM2()
	Local cAlias  := "ZZT"
	Local cTitle  := "Gera��o de Embarque"
	Local oBrowse := FWMBrowse():New()
	
	Private aRotina := MenuDef()
	//U_KILLSC915()Chamado 002701 - Desativado conforme orienta��o de Giovani 10/10/2015
	oBrowse:SetAlias(cAlias)
	oBrowse:SetDescription(cTitle)
	oBrowse:AddLegend("ZZT_STATUS=='1'", "GREEN" ,"Aberto")
	oBrowse:AddLegend("ZZT_STATUS=='2'", "BLUE","Fechado")
	oBrowse:AddLegend("ZZT_STATUS=='3'", "RED"  ,"Finalizado")
	
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
���Rotina    � STEMBAM2.prw                                               ���
���Nome      � Gera��o de Embarque                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function MenuDef()

	Local aRotina := {}

	ADD OPTION aRotina TITLE "Pesquisar"            ACTION "PESQBRW"          OPERATION 1  ACCESS 0
	ADD OPTION aRotina TITLE "Visualizar"           ACTION "VIEWDEF.STEMBAM2" OPERATION 2  ACCESS 0
	ADD OPTION aRotina TITLE "Incluir"              ACTION "VIEWDEF.STEMBAM2" OPERATION 3  ACCESS 0
	ADD OPTION aRotina TITLE "Alterar"              ACTION "VIEWDEF.STEMBAM2" OPERATION 4  ACCESS 0
	ADD OPTION aRotina TITLE "Excluir"              ACTION "VIEWDEF.STEMBAM2" OPERATION 5  ACCESS 0
	ADD OPTION aRotina TITLE "Imprimir"             ACTION "VIEWDEF.STEMBAM2" OPERATION 6  ACCESS 0
	ADD OPTION aRotina TITLE "Fechar"               ACTION "U_STOPCEMP('1')"  OPERATION 7  ACCESS 0
	ADD OPTION aRotina TITLE "Reabrir"              ACTION "U_STOPCEMP('2')"  OPERATION 8  ACCESS 0
	ADD OPTION aRotina TITLE "Gerar NF"             ACTION "U_STOPCEMP('3')"  OPERATION 9  ACCESS 0
	ADD OPTION aRotina TITLE "Confer�ncia Embarque" ACTION "U_STOPCEMP('4')"  OPERATION 10 ACCESS 0
	ADD OPTION aRotina TITLE "Totalizador Embarque" ACTION "U_STOPCEMP('5')"  OPERATION 11 ACCESS 0
	ADD OPTION aRotina TITLE "An�lise de Produto"   ACTION "U_STOPCEMP('6')"  OPERATION 12 ACCESS 0
	ADD OPTION aRotina TITLE "Rela��o de Embarque"  ACTION "U_STEMBAM8()"     OPERATION 12 ACCESS 0
	If   __cUserId $ GetMv("ST_C9ERRO",,'000000')+'000000/000645'
		ADD OPTION aRotina TITLE "Ajusta NF c\ Erro."   ACTION "U_C9ERRO( )"  OPERATION 12 ACCESS 0
	EndIf

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
���Rotina    � STEMBAM2.prw                                               ���
���Nome      � Gera��o de Embarque                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ModelDef()

	Local oStruZZT := FWFormStruct(1, "ZZT")
	Local oStruZZU := FWFormStruct(1, "ZZU")
	Local oModel   := MPFormModel():New("M3M")



	oModel:AddFields("ZZTMASTER", /*cOwner*/, oStruZZT)
	oModel:AddGrid("ZZUDETAIL", "ZZTMASTER", oStruZZU,{|oX,Line,Acao| U_STEMBLINOK(oX,Line,Acao)},/**/,/*bLinePost*/,/*bPre*/,/*bPost*/,/*bLoad*/)
	oModel:SetRelation("ZZUDETAIL", {{'ZZU_FILIAL', 'xFilial("ZZU")'}, {"ZZU_NUMEMB", "ZZT_NUMEMB"}}, 'ZZU_FILIAL+ZZU_PRODUT+ZZU_OP')
	oModel:SetDescription("Embarque AM")
	oModel:GetModel("ZZTMASTER"):SetDescription("EMBARQUE")
	oModel:GetModel("ZZUDETAIL"):SetDescription("ITENS")
	oModel:SetPrimaryKey({"ZZT_FILIAL", "ZZT_NUMEMB"})


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
���Rotina    � STEMBAM2.prw                                               ���
���Nome      � Gera��o de Embarque                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ViewDef()

	Local oStruZZT := FWFormStruct(2, "ZZT")
	Local oStruZZU := FWFormStruct(2, "ZZU")
	Local oModel   := FWLoadModel("STEMBAM2")
	Local oView    := NIL

	oStruZZT:RemoveField("ZZT_DTFIM")
	oStruZZT:RemoveField("ZZT_HRFIM")
	oStruZZT:RemoveField("ZZT_NUMPED")

	oStruZZU:RemoveField("ZZU_PEDIDO")
	oStruZZU:RemoveField("ZZU_ITEM")
	oStruZZU:RemoveField("ZZU_DTFIM")
	oStruZZU:RemoveField("ZZU_HRFIM")

	oView := FWFormView():New()

	oView:SetModel(oModel)
	oView:AddField("VIEW_ZZT", oStruZZT, "ZZTMASTER")
	oView:AddGrid("VIEW_ZZU", oStruZZU, "ZZUDETAIL")
	oView:CreateHorizontalBox("SUPERIOR", 50)
	oView:CreateHorizontalBox("INFERIOR", 50)
	oView:SetOwnerView("VIEW_ZZT", "SUPERIOR")
	oView:SetOwnerView("VIEW_ZZU", "INFERIOR")
	oView:EnableTitleView("VIEW_ZZT")
	oView:EnableTitleView("VIEW_ZZU")

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
���Rotina    � STEMBAM2.prw                                               ���
���Nome      � Gera��o de Embarque                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function EMBVAR(oModel)
	Local nOp := oModel:GetOperation()

	If nOp == MODEL_OPERATION_INSERT //C�pia tamb�m � reconhecida como inser��o

		oModel:SetValue("ZZTMASTER", "ZZT_DTEMIS" , DDATABASE)
		oModel:SetValue("ZZTMASTER", "ZZT_HRINI" , SubStr(TIME(), 1, 5))
		oModel:SetValue("ZZTMASTER", "ZZT_USERIN", cUserName)

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
���Rotina    � STEMBAM2.prw                                               ���
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
		ElseIf (nOp = MODEL_OPERATION_UPDATE  .Or. nOp = MODEL_OPERATION_DELETE ) .And. ZZT->ZZT_STATUS <> '1'
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


Return (_lRet)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �STFECEMB   �Autor  �Giovani Zago       � Data �  07/10/2015 ���
�������������������������������������������������������������������������͹��
���Desc.     �Fun��o para realizar o fechamento e reabertura do Embarque  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Steck Industria Eletrica Ltda.                             ���
�������������������������������������������������������������������������ͼ��
���Rotina    � STEMBAM2.prw                                               ���
���Nome      � Gera��o de Embarque                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function STFECEMB(_cOpt)

	If 	ZZT->ZZT_STATUS	<> "3"
		If _cOpt = '1'
			If	ZZT->ZZT_STATUS = "1"
				If MsgYesno("Deseja Fechar o Embarque ?")
					ZZT->(RecLock("ZZT",.F.))

					ZZT->ZZT_STATUS	:= "2"

					ZZT->(MsUnLock())

					ConfirmSX8()

				EndIf
			Else
				MsgInfo("Embarque J� Fechado")

			EndIf
		ElseIf _cOpt = '2'
			If MsgYesno("Deseja Reabrir o Embarque ?")
				ZZT->(RecLock("ZZT",.F.))

				ZZT->ZZT_STATUS	:= "1"

				ZZT->(MsUnLock())

				ConfirmSX8()
			EndIf
		EndIf

	Else
		MsgInfo("Embarque J� Finalizado")
	EndIf

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �STEMBLINOK �Autor  �Giovani Zago       � Data �  07/10/2015 ���
�������������������������������������������������������������������������͹��
���Desc.     �Fun��o para validar a linha da rotina de Embarque           ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Steck Industria Eletrica Ltda.                             ���
�������������������������������������������������������������������������ͼ��
���Rotina    � STEMBAM2.prw                                               ���
���Nome      � Gera��o de Embarque                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function STEMBLINOK(oModel,nLine,Acao)
	Local _lRem := .T.
	Local nI
	Local lFlag := .F.
	Local nProd		:= Ascan(oModel:aHeader,{|x| AllTrim(Upper(x[2]))=="ZZU_PRODUT"})
	Local nOp		:= Ascan(oModel:aHeader,{|x| AllTrim(Upper(x[2]))=="ZZU_OP"})

	If Acao <> 'DELETE'
		For nI := 1 To oModel:Length()
			oModel:GoLine( nI )
			//Chamado 002701 Abre
			If oModel:getLine() <>   nLine    .And. !(oModel:Acols[ oModel:getLine(),(Len(oModel:aHeader)+1)])      .And. _lRem
				If 	oModel:Acols[ oModel:getLine(),nProd] =   FwFldGet("ZZU_PRODUT",nLine) .And. 	oModel:Acols[ oModel:getLine(),nOp] =   FwFldGet("ZZU_OP",nLine)
					Help( ,, 'Help',, "Aten��o Produto/OP J� Cadastrados", 1, 0 )
					_lRem := .F.
				EndIf
			EndIf
			//Chamado 002701 Fecha
			oModel:GoLine( nI )
		Next nI
	EndIf
	oModel:GoLine( nLine )



Return(_lRem)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �STOPCEMP   �Autor  �Joao Rinaldi       � Data �  07/10/2015 ���
�������������������������������������������������������������������������͹��
���Desc.     �Fun��o para validar acesso aos bot�es customizados da rotina���
���          �de Embarque                                                 ���
�������������������������������������������������������������������������͹��
���Uso       � Steck Industria Eletrica Ltda.                             ���
�������������������������������������������������������������������������ͼ��
���Rotina    � STEMBAM2.prw                                               ���
���Nome      � Gera��o de Embarque                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function STOPCEMP(_cOpt)

	Local _lRet    := .T.
	Local _cGrp    := SuperGetMV("ST_GRPEMB",,"000000")
	Local _aGrupos := {}

	//������������������������������������������������������������������������Ŀ
	//�Valida��o de Grupo de Usu�rio para acesso aos bot�es da rotina de Embarque
	//��������������������������������������������������������������������������
	PswOrder(1)
	If PswSeek(__cUserId,.T.)
		_aGrupos  := PswRet()
	Endif

	If (_aGrupos[1][10][1] $ _cGrp)
		//������������������������������������������������������������������������Ŀ
		//�Valida��o para Outras Op��es da Rotina de Embarque
		//��������������������������������������������������������������������������
		If _cOpt = '1'
			U_STFECEMB('1')
		ElseIf _cOpt = '2'
			U_STFECEMB('2')
		ElseIf _cOpt = '3'
			U_STEMBAM3()
		ElseIf _cOpt = '4'
			U_STEMBAM4()
		ElseIf _cOpt = '5'
			U_STEMBAM5()
		ElseIf _cOpt = '6'
			U_STEMBAM6()
		Else
			Help( ,, 'Help',, "Op��o n�o dispon�vel para a rotina de embarque...!!!";
				+CHR(10)+CHR(13)+;
				"A��o n�o permitida...!!!";
				+CHR(10)+CHR(13)+;
				"Favor Verificar...!!!",;
				1, 0 )
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

Return(_lRet)


User Function C9ERRO( )

	Local _nRecSC9 		:= 0
	Local _cVersao := '20210617'
	Local _cNumEmb  := ZZT->ZZT_NUMEMB
	Local _nOpc	 := 0
	Local _oDlg
	Private cPerg       := 'C9ERRO'
	Private cTime       := Time()
	Private cHora       := SUBSTR(cTime, 1, 2)
	Private cMinutos    := SUBSTR(cTime, 4, 2)
	Private cSegundos   := SUBSTR(cTime, 7, 2)
	Private cAlias2	    := cPerg+cHora+cMinutos+cSegundos
	Private _oSay
	Private _oTGet
	Private _oTButCon
	Private _oTButFec

	If MsgYesno("ATEN��O ESTA OP��O SO DEVE SER UTILIZADA EM CASO DE ERRO DE NF DE EMBARQUE, A NF JA FOI ESTORNADA?")

		DEFINE MSDIALOG _oDlg TITLE "Informe o Numero do Embarque - "+_cVersao FROM 000, 000  TO 150, 330 COLORS 0, 16777215 PIXEL

		_oSay	:= TSay():New(010,010,{||'Num. Embarque:'},_oDlg,,,,,,.T.,,,060,20)
		_oTGet  := TGet():New(020,010,{| u | if( pCount() > 0,_cNumEmb := u, _cNumEmb ) },_oDlg,150,009,"@!",,0,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,_cNumEmb,,,, )

		_oTButCon:= TButton():New( 050, 070, "Confirmar" ,_oDlg,{|| _nOpc := 1,_oDlg:END()}, 40,15,,,.F.,.T.,.F.,,.F.,,,.F. )
		_oTButFec:= TButton():New( 050, 120, "Fechar",_oDlg,{|| _nOpc := 0,_oDlg:END()}, 40,15,,,.F.,.T.,.F.,,.F.,,,.F. )

		ACTIVATE MSDIALOG _oDlg CENTERED

		If _nOpc == 1 .AND. !Empty(_cNumEmb)

			cQuery:= ' '

			cQuery := " SELECT R_E_C_N_O_ AS
			cQuery += '  "XREC"
			cQuery += "  FROM "+RetSqlName("SC9")+" SC9 "
			cQuery += " WHERE SC9.D_E_L_E_T_ = ' '
			cQuery += " AND SC9.C9_NFISCAL = ' '
			cQuery += " AND SC9.C9_ORDSEP = ' '
			cquery += " AND SC9.C9_NUMEMB = '"+_cNumEmb+"'
			cQuery += " AND SC9.C9_LOCAL = '15'

			If Select(cAlias2) > 0
				(cAlias2)->(dbCloseArea())
			EndIf

			dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAlias2)

			If  Select(cAlias2) > 0
				(cAlias2)->(dbgotop())
				If MsgYesno("ATEN��O CONFIRMA A OPERA��O?")

					While !(cAlias2)->(Eof())
						_nRecSC9:= (cAlias2)->XREC
						DbSelectArea("SC9")
						SC9->(DbGoTo(_nRecSC9))

						If _nRecSC9  = SC9->(RECNO())
							SC9->(RecLock("SC9",.F.))
							SC9->C9_XOBSFIN := "U_C9ERRO() - " + CUSERNAME +' - '+ __cuserId + ' - ' + dTOc(date())  +' - '+TIME()
							SC9->(DbDelete())
							SC9->(MsUnlock())
							SC9->(DbCommit())
						EndIf

						(cAlias2)->(dbSkip())
					End
				EndIf
				MsgInfo("Opera��o Realizada com Sucesso.....!!!!!")
			EndIf
		else
		 MsgInfo("Informe o numero do Embarque!")	
		EndIf	
	EndIf
Return()

