#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWMVCDEF.CH"

/*====================================================================================\
|Programa  | STEST010        | Autor | RENATO.OLIVEIRA           | Data | 21/12/2018  |
|=====================================================================================|
|Descrição | Rotina para controlar as arrumações do estoque                           |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|Chamado 008250																		  |
|........................................Histórico....................................|
\====================================================================================*/

User Function STEST010()

	Local oBrowse
	Private aRotina 	:= MenuDef()

	oBrowse1 := FWmBrowse():New()
	oBrowse1:SetDescription("Controle de arrumação de estoque")
	oBrowse1:SetAlias("Z21")

	oBrowse1:AddLegend("Z21->Z21_STATUS=='1'"	,"WHITE"		,"Endereço adequado")
	oBrowse1:AddLegend("Z21->Z21_STATUS=='2'"	,"GREEN"		,"Aprovado auditor")
	oBrowse1:AddLegend("Z21->Z21_STATUS=='3'"	,"GRAY"			,"Reprovado auditor")
	oBrowse1:AddLegend("Z21->Z21_STATUS=='4'"	,"YELLOW"		,"Endereço c/ divergência de itens")
	oBrowse1:AddLegend("Z21->Z21_STATUS=='5'"	,"PINK"			,"Divergência auditada")
	oBrowse1:AddLegend("Z21->Z21_STATUS=='6'"	,"RED"			,"Endereço c/ produtos a mais")

	oBrowse1:SetUseCursor(.F.)

	oBrowse1:Activate()

Return()

/*/{Protheus.doc} MenuDef
@name MenuDef
@type Static Function
@desc monta menu principal
@author Renato Nogueira
@since 09/01/2017
/*/

Static Function MenuDef()

	Local aRotina := {}

	ADD OPTION aRotina TITLE 'Pesquisar'  				ACTION "AxPesqui"        	OPERATION 1  ACCESS 0
	ADD OPTION aRotina TITLE "Visualizar" 				ACTION "VIEWDEF.STEST010" 	OPERATION 2  ACCESS 0
	ADD OPTION aRotina TITLE "Aprovar/Reprovar"    		ACTION "U_STEST011()" 		OPERATION 10  ACCESS 0
	ADD OPTION aRotina TITLE "Alocar operador"    		ACTION "U_STEST012()" 		OPERATION 3  ACCESS 0

Return aRotina

/*/{Protheus.doc} ModelDef
@name ModelDef
@type Static Function
@desc montar model do mvc
@author Renato Nogueira
@since 12/09/2016
/*/

Static Function ModelDef()

	Local oModel
	Local oStr1:= FWFormStruct(1,'Z21')
	Local _aRel	:= {}

	oModel := MPFormModel():New("MOD03XFORM",{|oModel|VLDALT(oModel)},{|oModel|TUDOOK(oModel)},{|oModel|GrvTOK(oModel)})

	oModel:SetDescription('Main')

	oModel:addFields('FIELD1',,oStr1,)

	oModel:SetPrimaryKey({})

	oModel:getModel('FIELD1'):SetDescription('Cabeçalho')

Return oModel

/*/{Protheus.doc} ViewDef
@name ViewDef
@type Static Function
@desc montar view do mvc
@author Renato Nogueira
@since 12/09/2016
/*/

Static Function ViewDef()

	Local oView:= NIL
	Local oStr1:= FWFormStruct(2, 'Z21')
	Local oModel     := FWLoadModel("STEST010")

	oView := FWFormView():New()
	oView:SetModel(oModel)

	oView:AddField('FORM1' , oStr1,'FIELD1' )

	oView:CreateHorizontalBox( 'BOXFORM1', 100)

	oView:SetOwnerView('FORM1','BOXFORM1')

	oView:EnableTitleView('FORM1','Cabeçalho')

	oView:EnableControlBar(.T.)

	oView:SetCloseOnOk({|| .T.})

Return oView

/*/{Protheus.doc} VLDALT
@name VLDALT
@type Static Function
@desc validar alteração do pedido
@author Renato Nogueira
@since 12/09/2016
/*/

Static Function VLDALT(oModel)

	Local _lRet				:= .T.
	Local nOp         		:= oModel:GetOperation()

Return(_lRet)

/*/{Protheus.doc} TUDOOK
@name TUDOOK
@type Static Function
@desc validar tudo ok do pedido
@author Renato Nogueira
@since 12/09/2016
/*/

Static Function TUDOOK(oModel)

	Local _lRet			:= .T.

Return(_lRet)

/*/{Protheus.doc} VLDLIN
@name VLDLIN
@type Static Function
@desc validar troca de linha do pedido
@author Renato Nogueira
@since 12/09/2016
/*/

Static Function VLDLIN(oModel,nLine)

	Local _lRet	:= .T.

Return(_lRet)

/*/{Protheus.doc} GrvTOK
@name GrvTOK
@type Static Function
@desc realiza gravação dos dados
@author Renato Nogueira
@since 12/09/2016
/*/

Static Function GrvTOK( oModel )

	Local lGrv				:= .T.
	Local nOp         := oModel:GetOperation()

	Begin Transaction
		FWFormCommit( oModel )
	End Transaction

Return lGrv

/*/{Protheus.doc} STEST011
@name STEST011
@type Static Function
@desc realiza auditoria
@author Renato Nogueira
@since 12/09/2016
/*/

User Function STEST011()

	Local _aRet 		:= {}
	Local _aParamBox 	:= {}

	DbSelectArea("CB1")
	CB1->(DbSetOrder(2))
	If !CB1->(DbSeek(xFilial("CB1")+__cUserId))
		VTALERT("Operador não cadastrado, verifique!")
		Return
	EndIf

	If AllTrim(CB1->CB1_CODOPE)==AllTrim(Z21->Z21_OPER)
		MsgAlert("Atenção, o auditor é igual ao operador, verifique!")
		Return
	EndIf

	//If !MsgYesNo("Confirma auditoria do registro?")
	//Return
	//EndIf

	_aOpc := {"Limpeza inadequada","Organização inadequada","Limpeza/Organização inadequada","Limpeza/Organização adequada"}

	AADD(_aParamBox,{3,"Status"		,,{"Aprovado","Reprovado"},70,"",.T.})
	AADD(_aParamBox,{3,"Obs."		,,_aOpc,100,"",.T.})
	AADD(_aParamBox,{1,"Obs.livre"	,Space(200),"@!","","",".T.",100,.F.})

	If ParamBox(_aParamBox,"Aprovação de arrumação",@_aRet)

		Z21->(RecLock("Z21",.F.))
		Z21->Z21_CODAUD := CB1->CB1_CODOPE
		Z21->Z21_NOMAUD := CB1->CB1_NOME
		Z21->Z21_DTAUD	:= Date()
		Z21->Z21_HRAUD	:= Time()

		If MV_PAR01==1 .And. Z21->Z21_STATUS=="1"
			Z21->Z21_STATUS := "2"
		ElseIf MV_PAR01==1 .And. Z21->Z21_STATUS $ "4#6"
			Z21->Z21_STATUS := "5"
		ElseIf MV_PAR01==2
			Z21->Z21_STATUS := "3"
		EndIf

		Do Case
			Case MV_PAR02==1
			Z21->Z21_OBS1	:= "Limpeza inadequada"
			Case MV_PAR02==2
			Z21->Z21_OBS1	:= "Organização inadequada"
			Case MV_PAR02==3
			Z21->Z21_OBS1	:= "Limpeza/Organização inadequada"
			Case MV_PAR02==4
			Z21->Z21_OBS1	:= "Limpeza/Organização adequada"
		EndCase

		Z21->Z21_OBS := MV_PAR03

		Z21->(MsUnLock())

	EndIf

Return()

/*/{Protheus.doc} STEST012
@name STEST012
@type Static Function
@desc alocar operador
@author Renato Nogueira
@since 12/09/2016
/*/

User Function STEST012()

	Local aParambox		:= {}
	Local aRet			:= {}
	Local cOper			:= Space(TamSx3("CB1_CODOPE")[1])
	Local cLoc1d		:= Space(TamSx3("BE_LOCALIZ")[1])
	Local cLoc1a		:= Space(TamSx3("BE_LOCALIZ")[1])
	Local cLoc2d		:= Space(TamSx3("BE_LOCALIZ")[1])
	Local cLoc2a		:= Space(TamSx3("BE_LOCALIZ")[1])
	Local _cQuery1      := ""
	Local _cAlias1		:= "STEST012A"
	Local _aLocaliz		:= {}
	Local _lAchou		:= .F.
	Local _nX
	
	aAdd(aParamBox,{1,"Operador"		,cOper		,"@!","","CB1"	,""	,0,.T.})
	aAdd(aParamBox,{1,"Faixa 1 de:"		,cLoc1d		,"@!","","SBE"	,"" ,0,.T.})
	aAdd(aParamBox,{1,"Faixa 1 ate:"	,cLoc1a		,"@!","","SBE"	,"" ,0,.T.})
	aAdd(aParamBox,{1,"Faixa 2 de:"		,cLoc2d		,"@!","","SBE"	,"" ,0,.F.})
	aAdd(aParamBox,{1,"Faixa 2 ate:"	,cLoc2a		,"@!","","SBE"	,"" ,0,.F.})

	If !ParamBox(aParamBox,"Alocar operador",@aRet,,,,,,,,.f.)
		Return
	EndIf

	_cQuery1 := " SELECT BE_LOCALIZ
	_cQuery1 += " FROM "+RetSqlName("SBE")+" BE
	_cQuery1 += " WHERE BE.D_E_L_E_T_=' ' AND BE_LOCALIZ BETWEEN '"+MV_PAR02+"' AND '"+MV_PAR03+"'
	_cQuery1 += " AND BE_XBLOQ<>'S' AND BE_FILIAL='"+xFilial("Z43")+"'

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	While (_cAlias1)->(!Eof())

		_lAchou		:= .F.

		For _nX:=1 To Len(_aLocaliz)
			If AllTrim((_cAlias1)->BE_LOCALIZ)==AllTrim(_aLocaliz[_nX])
				_lAchou := .T.
			EndIf
		Next

		If !_lAchou
			AADD(_aLocaliz,(_cAlias1)->BE_LOCALIZ)
		EndIf

		(_cAlias1)->(DbSkip())
	EndDo

	If !Empty(MV_PAR04) .And. !Empty(MV_PAR05)

		_cQuery1 := " SELECT BE_LOCALIZ
		_cQuery1 += " FROM "+RetSqlName("SBE")+" BE
		_cQuery1 += " WHERE BE.D_E_L_E_T_=' ' AND BE_LOCALIZ BETWEEN '"+MV_PAR04+"' AND '"+MV_PAR05+"'
		_cQuery1 += " AND BE_XBLOQ<>'S' AND BE_FILIAL='"+xFilial("Z43")+"'

		If !Empty(Select(_cAlias1))
			DbSelectArea(_cAlias1)
			(_cAlias1)->(dbCloseArea())
		Endif

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

		dbSelectArea(_cAlias1)
		(_cAlias1)->(dbGoTop())

		While (_cAlias1)->(!Eof())

			_lAchou		:= .F.

			For _nX:=1 To Len(_aLocaliz)
				If AllTrim((_cAlias1)->BE_LOCALIZ)==AllTrim(_aLocaliz[_nX])
					_lAchou := .T.
				EndIf
			Next

			If !_lAchou
				AADD(_aLocaliz,(_cAlias1)->BE_LOCALIZ)
			EndIf

			(_cAlias1)->(DbSkip())
		EndDo

	EndIf

	If Len(_aLocaliz)==0
		MsgAlert("Nenhuma localização encontrada, revise os parâmetros digitados!")
		Return
	EndIf
	If !MsgYesNo("Atenção, serão geradas "+cValToChar(Len(_aLocaliz))+" localizações para esse operador, deseja continuar?")
		Return
	EndIf

	DbSelectArea("Z43")
	Z43->(DbSetOrder(1))

	//Zerar locais antigos do operador
	Z43->(DbSeek(xFilial("Z43")+MV_PAR01))
	While Z43->(!Eof()) .And. Z43->(Z43_FILIAL+Z43_OPER)==xFilial("Z43")+MV_PAR01
		Z43->(RecLock("Z43",.F.))
		Z43->(DbDelete())
		Z43->(MsUnLock())
		Z43->(DbSkip())
	EndDo

	For _nX:=1 To Len(_aLocaliz)

		If !Z43->(DbSeek(xFilial("Z43")+MV_PAR01+_aLocaliz[_nX]))
			Z43->(RecLock("Z43",.T.))
			Z43->Z43_FILIAL := xFilial("Z43")
			Z43->Z43_OPER	:= MV_PAR01
			Z43->Z43_LOCAL	:= _aLocaliz[_nX]
			Z43->(MsUnLock())
		EndIf

	Next

	MsgAlert("Cadastro de arrumações gerado com sucesso!")

Return()