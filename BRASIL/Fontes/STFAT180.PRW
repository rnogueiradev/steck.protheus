#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWMVCDEF.CH"

/*====================================================================================\
|Programa  | STFAT180        | Autor | RENATO.OLIVEIRA           | Data | 14/08/2019  |
|=====================================================================================|
|Descrição | Tela para manutenção das rotas TNT			                              |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STFAT180()

	Local oBrowse
	Private aRotina 	:= MenuDef()

	DbSelectArea("SZV")
	SZV->(DbSetOrder(1))

	oBrowse1 := FWmBrowse():New()
	oBrowse1:SetDescription("Tabela de rotas TNT")
	oBrowse1:SetAlias("SZV")

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

	ADD OPTION aRotina TITLE "Pesquisar"  				ACTION "AxPesqui"        	OPERATION 1  ACCESS 0
	ADD OPTION aRotina TITLE "Visualizar" 				ACTION "VIEWDEF.STFAT180" 	OPERATION 2  ACCESS 0
	ADD OPTION aRotina TITLE "Alterar"    				ACTION "VIEWDEF.STFAT180" 	OPERATION 4  ACCESS 0
	ADD OPTION aRotina TITLE "Excluir"    				ACTION "VIEWDEF.STFAT180" 	OPERATION 5  ACCESS 0
	ADD OPTION aRotina TITLE "Incluir"    				ACTION "VIEWDEF.STFAT180" 	OPERATION 3  ACCESS 0
	ADD OPTION aRotina TITLE "Log"	    				ACTION "U_STFAT181()" 		OPERATION 2  ACCESS 0

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
	Local oStr1:= FWFormStruct(1,'SZV')
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
	Local oStr1:= FWFormStruct(2, 'SZV')
	Local oModel     := FWLoadModel("STFAT180")

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

/*====================================================================================\
|Programa  | STFAT181        | Autor | RENATO.OLIVEIRA           | Data | 09/09/2019  |
|=====================================================================================|
|Descrição | Tela para visualizar log de alterações		                              |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STFAT181()

	Local _cQuery1 		:= ""
	Local _cAlias1 		:= GetNextAlias()
	Local aCols	   		:= {}
	Local aHeader  		:= {}
	Local lSaida   		:= .T.
	Local aSize	   		:= MsAdvSize(.F.)
	Local aCampoEdit	:= {}
	Local oWindow
	Local nY
	//oFontWin
	aHead				:= {}
	bOk 				:= {||(	lSaida:=.f., lConfirma:=.T.,oWindow:End()) }
	bCancel 	    	:= {||(	lSaida:=.f.,oWindow:End()) }
	aButtons	    	:= {}
	//oGet

	Aadd(aHeader,{"Nome" 			, "AT_NAME" 	  , "@!" 				,    20    ,      0 ,"",   	,"C" 	,""		,"R"		,""})
	Aadd(aHeader,{"Data" 			, "AT_DATE" 	  , "@D" 				,    10    ,      0 ,"",   	,"D" 	,""		,"R"		,""})
	Aadd(aHeader,{"Hora" 			, "AT_TIME" 	  , "@!" 				,    08    ,      0 ,"",   	,"C" 	,""		,"R"		,""})
	Aadd(aHeader,{"Operação" 		, "AT_OP" 	  	  , "@!" 				,    01    ,      0 ,"",   	,"C" 	,""		,"R"		,""})
	Aadd(aHeader,{"Campo" 			, "AT_FIELD" 	  , "@!" 				,    10    ,      0 ,"",   	,"C" 	,""		,"R"		,""})
	Aadd(aHeader,{"Conteúdo antigo" , "AT_CONTENT" 	  , "@!" 				,    100   ,      0 ,"",   	,"C" 	,""		,"R"		,""})
	Aadd(aHeader,{"Conteúdo novo" 	, "AT_NEWCONT" 	  , "@!" 				,    100   ,      0 ,"",   	,"C" 	,""		,"R"		,""})

	_cQuery1 := " SELECT AT_NAME, AT_TIME, AT_DATE, AT_OP, AT_FIELD, AT_CONTENT, AT_NEWCONT
	_cQuery1 += " FROM AUDIT_TRAIL@ODBADT
	_cQuery1 += " WHERE AT_TABLE LIKE '%SZV%' AND AT_RECID="+cValToChar(SZV->(Recno()))
	_cQuery1 += " ORDER BY AT_DATE, AT_TIME

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	While (_cAlias1)->(!Eof())

		AADD(aCols,Array(Len(aHeader)+1))

		For nY := 1 To Len(aHeader)

			DO CASE

				CASE AllTrim(aHeader[nY][2]) ==  "AT_NAME"
				aCols[Len(aCols)][nY] := (_cAlias1)->AT_NAME
				CASE AllTrim(aHeader[nY][2]) ==  "AT_TIME"
				aCols[Len(aCols)][nY] := (_cAlias1)->AT_TIME
				CASE AllTrim(aHeader[nY][2]) ==  "AT_DATE"
				aCols[Len(aCols)][nY] := DTOC(STOD((_cAlias1)->AT_DATE))
				CASE AllTrim(aHeader[nY][2]) ==  "AT_OP"
				aCols[Len(aCols)][nY] := (_cAlias1)->AT_OP
				CASE AllTrim(aHeader[nY][2]) ==  "AT_FIELD"
				aCols[Len(aCols)][nY] := (_cAlias1)->AT_FIELD
				CASE AllTrim(aHeader[nY][2]) ==  "AT_CONTENT"
				aCols[Len(aCols)][nY] := (_cAlias1)->AT_CONTENT
				CASE AllTrim(aHeader[nY][2]) ==  "AT_NEWCONT"
				aCols[Len(aCols)][nY] := (_cAlias1)->AT_NEWCONT

			ENDCASE

		Next

		aCols[Len(aCols)][Len(aHeader)+1] := .F.

		(_cAlias1)->(DbSkip())
	EndDo

	While lSaida
		DEFINE MSDIALOG oWindow FROM 0,0 TO 300,800 TITLE Alltrim(OemToAnsi("Histórico de alterações")) Pixel //430,531
		oGet	:= MsNewGetDados():New(030,000,oWindow:nClientHeight/2-5,oWindow:nClientWidth/2-5, GD_UPDATE ,"AllWaysTrue()","AllWaysTrue()",,aCampoEdit,,Len(aCols),,, ,oWindow, aHeader, aCols )
		ACTIVATE MSDIALOG oWindow CENTERED ON INIT EnchoiceBar(oWindow,bOk,bCancel,,aButtons)
	EndDo

Return()