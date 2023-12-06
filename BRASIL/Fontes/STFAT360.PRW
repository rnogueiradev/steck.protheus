#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWMVCDEF.CH"

/*====================================================================================\
|Programa  | STFAT360        | Autor | RENATO.OLIVEIRA           | Data | 17/02/2020  |
|=====================================================================================|
|Descrição | 													                      |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STFAT360()

	Local oBrowse
	Private aRotina := MenuDef()

	DbSelectArea("ZH3")
	ZH3->(DbSetOrder(1))

	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias("ZH3")                        // Alias da tabela utilizada
	oBrowse:SetDescription("Cadastro vencimentos por cliente")      	   // Descrição do browse
	oBrowse:SetUseCursor(.F.)
	oBrowse:Activate()

Return

/*/{Protheus.doc} MenuDef
@name MenuDef
@type Static Function
@desc monta menu principal
@author Renato Nogueira
@since 12/09/2016
/*/

Static Function MenuDef()

	Local aRotina := {}

	ADD OPTION aRotina TITLE 'Pesquisar'  							ACTION "AxPesqui"        	OPERATION 1  ACCESS 0 //"Pesquisar"
	ADD OPTION aRotina TITLE "Visualizar" 							ACTION "VIEWDEF.STFAT360" 	OPERATION 2  ACCESS 0 //"Visualizar"
	ADD OPTION aRotina TITLE "Alterar"    							ACTION "VIEWDEF.STFAT360" 	OPERATION 4  ACCESS 0 //"Alterar"
	ADD OPTION aRotina TITLE "Excluir"    							ACTION "VIEWDEF.STFAT360"	OPERATION 5  ACCESS 0 //"Excluir"
	ADD OPTION aRotina TITLE "Incluir"    							ACTION "VIEWDEF.STFAT360"	OPERATION 3  ACCESS 0 //"Incluir"

Return aRotina

/*/{Protheus.doc} ModelDef
@name ModelDef
@type Static Function
@desc monta model do mvc
@author Renato Nogueira
@since 12/09/2016
/*/

Static Function ModelDef()

	Local oModel
	Local oStr1:= FWFormStruct(1,'ZH3')
	Local _aRel	:= {}
	Local _aRel1	:= {}

	oModel := MPFormModel():New("MOD03XFORM",{|oModel|VLDALT(oModel)},{|oModel|TUDOOK(oModel)},{|oModel|GrvTOK(oModel)})

	oModel:SetDescription('Main')

	oModel:addFields('FIELD1',,oStr1,)
	oModel:SetPrimaryKey({})
	oModel:getModel('FIELD1'):SetDescription('Regras')

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
	Local oStr1:= FWFormStruct(2, 'ZH3')
	Local oModel     := FWLoadModel("STFAT360")

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
@desc realiZP gravação dos dados
@author Renato Nogueira
@since 12/09/2016
/*/

Static Function GrvTOK( oModel )

	Local lGrv				:= .T.
	Local nOp        		:= oModel:GetOperation()

	Begin Transaction
		FWFormCommit( oModel )
	End Transaction

Return lGrv

/*/{Protheus.doc} STFAT362
@name STFAT362
@type User Function
@desc atualizar dados titulo a receber
@author Renato Nogueira
@since 23/03/2020
/*/

User Function STFAT362()

	Local _aAreaSE1 := SE1->(GetArea())
	Local _cQuery1  := ""
	Local _cAlias1  := GetNextAlias()

	DbSelectArea("ZH3")
	ZH3->(DbSetOrder(1))
	If !ZH3->(DbSeek(xFilial("ZH3")+SE1->(E1_CLIENTE+E1_LOJA)))
		If !ZH3->(DbSeek(xFilial("ZH3")+SE1->(E1_CLIENTE)))
			Return
		EndIf
	EndIf

	_cQuery1 := " SELECT E1.R_E_C_N_O_ SE1REC
	_cQuery1 += " FROM "+RetSqlName("SE1")+" E1
	_cQuery1 += " WHERE E1.D_E_L_E_T_=' ' AND E1_FILIAL='"+SF2->F2_FILIAL+"'
	_cQuery1 += " AND E1_PREFIXO='"+SF2->F2_SERIE+"' AND E1_NUM='"+SF2->F2_DOC+"'
	_cQuery1 += " AND E1_TIPO='NF'

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	While (_cAlias1)->(!Eof())

		SE1->(DbGoTo((_cAlias1)->SE1REC))
		If SE1->(!Eof())

			SE1->(RecLock("SE1",.F.))

			Do Case

				Case AllTrim(ZH3->ZH3_OPCAO)=="1"

				_sData := SubStr(SE1->E1_VENCREA,1,6)
				_sData := _sData+PADR(cValToChar(ZH3->ZH3_OPC1),2,"0")
				SE1->E1_VENCREA := STOD(_sData)

				Case AllTrim(ZH3->ZH3_OPCAO)=="2"

				_nDia := Dow(SE1->E1_VENCREA)
				_cData := SE1->E1_VENCREA

				If !(_nDia==Val(ZH3->ZH3_OPC2))
					While .T.
						_cData := DaySum(_cData,1)
						_nDia  := Dow(_cData)
						If (_nDia==Val(ZH3->ZH3_OPC2))
							SE1->E1_VENCREA := _cData
							Exit
						EndIf
					EndDo
				EndIf

				Case AllTrim(ZH3->ZH3_OPCAO)=="3"

				SE1->E1_VENCREA := DaySum(SE1->E1_VENCREA,ZH3->ZH3_OPC3)

			EndCase

			SE1->(MsUnLock())

		EndIf

		(_cAlias1)->(DbSkip())
	EndDo

	RestArea(_aAreaSE1)

Return()