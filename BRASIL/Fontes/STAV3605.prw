#Include "Protheus.ch"
#Include "FWMvcDef.CH"
#include "topconn.ch"
#Include 'FWEditPanel.ch'

/*/{Protheus.doc} STAV3605

Cadastros de Participantes Avaliação 360

@type function
@author Everson Santana
@since 07/08/17
@version Protheus 12 - Gestão de Pessoal

@history , ,

/*/

User Function STAV3605()

	/*
	If Z33->Z33_STATUS = "1" 

	_lRet := .F.
	Help(NIL, NIL, "Avaliação 360", NIL, "Participante avaliado.", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Selecione outro participante"})

	Else
	*/

	If  Val(Z33->Z33_ANO) <= Val(getmv("ST_ULAV360",,"2020"))

		Help(NIL, NIL, "HELP", NIL, 'Período encerrado..', 1, 0, NIL, NIL, NIL, NIL, NIL, {'Selecione outro período'})
		Return
	Else
		
	FWExecView("Avaliar Colaborador","STAV3605",4,,{|| .T.})

	EndIf

Return

Static Function ModelDef()

	Local oModel
	Local oStr := getModelStruct()

	oModel := MPFormModel():New('MLDNOZ33',,,{|oModel| Commit(oModel) })

	oModel:SetDescription('Avaliar')

	oModel:AddFields("MASTZ33",,oStr,,,{||})

	oModel:getModel("MASTZ33"):SetDescription("DADOS")
	oModel:SetPrimaryKey({})

Return oModel

static function getModelStruct()
	Local oStruct := FWFormModelStruct():New()
	Local _cQry := ""
	Local nTam	:= 0
	Local nLineLength 	:= 95
	Local nTabSize 		:= 3
	Local lWrap 		:= .T.
	Local nCurrentLine	:= 0
	Local nLines1 := 0
	Local nCurrentLine1 := 0

	oStruct:AddField("NOME","NOME", "NOME", 'C',40, 0, { || , .T. }, ,{}, .F., , .F., .F., .F., , )
	oStruct:setProperty('NOME'	,MODEL_FIELD_WHEN,{|| .F.})

	oStruct:AddField("ANO","ANO", "ANO", 'C',05, 0, { || , .T. }, ,{}, .F., , .F., .F., .F., , )
	oStruct:setProperty('ANO'	,MODEL_FIELD_WHEN,{|| .F.})

	If Select("TRD") > 0
		TRD->(DbCloseArea())
	Endif

	_cQry := " "
	_cQry += " SELECT * FROM "+RetSqlName("SQO") "
	_cQry += " WHERE  QO_ATIVO = '1' "
	_cQry += " AND D_E_L_E_T_ = ' ' "

	TcQuery _cQry New Alias "TRD"

	TRD->(dbGoTop())

	While !EOF()

		nLines1 := MLCOUNT(POSICIONE("SQO", 1, xFilial("SQO") +TRD->QO_QUESTAO  , "QO_QUEST"), nLineLength, nTabSize, lWrap)

		FOR nCurrentLine := 1 TO nLines1

			xText1 := MEMOLINE(Alltrim(POSICIONE("SQO", 1, xFilial("SQO") +TRD->QO_QUESTAO  , "QO_QUEST")), nLineLength, nCurrentLine, nTabSize, lWrap)

		NEXT

		nTam := Len(xText1)

		If TRD->QO_TIPOOBJ = "1"

			oStruct:AddField(Alltrim(xText1),Alltrim(xText1), TRD->QO_QUESTAO+Alltrim(TRD->QO_TIPOOBJ), 'C',nTam, 0, { || , .T. }, ,{}, .F., , .F., .F., .F., , )

		ElseIf TRD->QO_TIPOOBJ = "3"

			oStruct:AddField(Alltrim(xText1),Alltrim(xText1), TRD->QO_QUESTAO+Alltrim(TRD->QO_TIPOOBJ), 'M',nTam, 0, { || , .T. }, ,{}, .F., , .F., .F., .F., , )

		EndIf
		TRD->(dbSkip())

	End

return oStruct

Static Function ViewDef()
	Local oView
	Local oModel := ModelDef()
	Local oStr	:= getViewStruct()

	oStr:= getViewStruct()

	oView := FWFormView():New()
	oView:SetModel(oModel)

	oView:AddField('FORM1' , oStr,'MASTZ33' )
	//oView:AddField('FORM1', oStr )
	oView:CreateHorizontalBox( 'BOXFORM1', 80)

	oView:SetOwnerView('FORM1','BOXFORM1')

	oView:SetViewProperty('FORM1' , 'SETLAYOUT' , {FF_LAYOUT_VERT_DESCR_TOP,3} )

Return oView

static function getViewStruct()
	Local oStruct := FWFormViewStruct():New()
	Local _cQry := ""
	Local nTam	:= 0
	Local nSeq	:= 1
	Local nLineLength 	:= 150
	Local nTabSize 		:= 3
	Local lWrap 		:= .T.
	Local nCurrentLine	:= 0
	Local nLines1 := 0
	Local nCurrentLine1 := 0
	Local aMult			:= {}

	oStruct:AddGroup( 'GRUPO01', ''		, '', 1 )
	oStruct:AddGroup( 'GRUPO02', 'Unica Escolha'    , '', 2 )
	oStruct:AddGroup( 'GRUPO03', 'Dissertativa'    , '', 3 )

	oStruct:AddField( "NOME",Alltrim(Str(nSeq)),"Nome","Nome",, 'C' ,,,,.T.,,, {Z33->Z33_NOMFU} ,,,,, )
	oStruct:SetProperty( "NOME", MVC_VIEW_GROUP_NUMBER, 'GRUPO01' )
	nSeq +=1
	oStruct:AddField( "ANO",Alltrim(Str(nSeq)),"Ano","Ano",, 'C' ,,,,.T.,,, {Z33->Z33_ANO} ,,,,, )
	oStruct:SetProperty( "ANO", MVC_VIEW_GROUP_NUMBER, 'GRUPO01' )

	If Select("TRD") > 0
		TRD->(DbCloseArea())
	Endif

	_cQry := " "
	_cQry += " SELECT * FROM "+RetSqlName("SQO") "
	_cQry += " WHERE QO_ATIVO = '1' " "
	_cQry += " AND D_E_L_E_T_ = ' ' "

	TcQuery _cQry New Alias "TRD"

	TRD->(dbGoTop())

	While !EOF()

		nLines1 := MLCOUNT(POSICIONE("SQO", 1, xFilial("SQO") +TRD->QO_QUESTAO  , "QO_QUEST"), nLineLength, nTabSize, lWrap)

		FOR nCurrentLine := 1 TO nLines1

			xText1 := MEMOLINE(Alltrim(POSICIONE("SQO", 1, xFilial("SQO") +TRD->QO_QUESTAO  , "QO_QUEST")), nLineLength, nCurrentLine, nTabSize, lWrap)

		NEXT

		nTam := Len(xText1)

		nSeq +=1

		If TRD->QO_TIPOOBJ = "1"

			DbSelectArea("SQP")
			DbSetOrder(1)
			DbGotop()

			If DbSeek(xFilial("SQP")+TRD->QO_QUESTAO)

				aMult := {}
				AADD(aMult,"")

				While !EOF() .and.SQP->QP_QUESTAO == TRD->QO_QUESTAO

					AADD(aMult,Alltrim(Str(Val(SQP->QP_ALTERNA)))+"="+Alltrim(SQP->QP_DESCRIC))

					SQP->(dbSkip())

				End

			EndIf

			DbSelectArea("TRD")

			oStruct:AddField( TRD->QO_QUESTAO+Alltrim(TRD->QO_TIPOOBJ),Alltrim(Str(nSeq)),Alltrim(xText1),Alltrim(xText1),, 'C' ,,,,.T.,,, aMult ,,,,, )

			oStruct:SetProperty( TRD->QO_QUESTAO+Alltrim(TRD->QO_TIPOOBJ), MVC_VIEW_GROUP_NUMBER, 'GRUPO02' )

		ElseIf TRD->QO_TIPOOBJ = "3"

			DbSelectArea("TRD")

			oStruct:AddField( TRD->QO_QUESTAO+Alltrim(TRD->QO_TIPOOBJ),Alltrim(Str(nSeq)),Alltrim(xText1),Alltrim(xText1),, 'M' ,,,,.T.,,, {} ,,,,, )
			oStruct:SetProperty( TRD->QO_QUESTAO+Alltrim(TRD->QO_TIPOOBJ), MVC_VIEW_GROUP_NUMBER, 'GRUPO03' )

		EndIF

		TRD->(dbSkip())

	End

return oStruct

Static Function Commit(oModel)

	Local lRet := .T.
	Local _nX := 0
	Local _cQry := ""
	Local _lLock := .T. 

	For _nX:=1 To Len(oModel:AALLSUBMODELS[1]:ADATAMODEL[1])

		If oModel:AALLSUBMODELS[1]:ADATAMODEL[1][_nX][3] 

			DbSelectArea("Z34")
			DbSetOrder(2)//Z34_FILIAL+Z34_MAT+Z34_XEMPFU+Z34_XFILFU+Z34_ANO+Z34_QUESTA                                                                                                                )
			DbGotop()

			If !DbSeek(xFilial("Z34")+Z33->(Z33_MAT+Z33_XEMPFU+Z33_XFILFU+Z33_MATAVA+Alltrim(SubStr(oModel:AALLSUBMODELS[1]:ADATAMODEL[1][_nX][1],1,3))+Z33_ANO))
				_lLock := .T.
			Else
				_lLock := .F.
			EndIf 

			Z34->(RecLock("Z34", _lLock))

			Z34->Z34_FILIAL := xFilial("Z34")
			Z34->Z34_MAT 	:= Z33->Z33_MAT 												//Matricula do Avaliado
			Z34->Z34_NOMFUN	:= Z33->Z33_NOMFU 
			Z34->Z34_XEMPFU := Z33->Z33_XEMPFU
			Z34->Z34_XFILFU	:= Z33->Z33_XFILFU
			Z34->Z34_USER   := Z33->Z33_USER												//Usuario do Avaliado		
			Z34->Z34_MATAVA := Z33->Z33_MATAVA 												// Matricula do Avaliador
			Z34->Z34_XEMP	:= Z33->Z33_XEMP 												//Empresa do Avaliador
			Z34->Z34_XFILIA	:= Z33->Z33_XFILIA 												//Filial do Avaliador

			Z34->Z34_QUESTA	:= SubStr(oModel:AALLSUBMODELS[1]:ADATAMODEL[1][_nX][1],1,3) 	//Questão
			Z34->Z34_TIPOOB := SubStr(oModel:AALLSUBMODELS[1]:ADATAMODEL[1][_nX][1],4,1)	//Tipo do Objeto
			Z34->Z34_ANO  	:= Z33->Z33_ANO 												//Ano de Avaliação
			Z34->Z34_USRAVA := Z33->Z33_MATAVA 												//Usuario do Avaliador

			If SubStr(oModel:AALLSUBMODELS[1]:ADATAMODEL[1][_nX][1],4,1) = "1"
				Z34->Z34_RESTP1	:= oModel:AALLSUBMODELS[1]:ADATAMODEL[1][_nX][2]
			Else
				Z34->Z34_RESTP1	:= ""
			EndIf

			Z34->Z34_RESTP2 := ""

			If SubStr(oModel:AALLSUBMODELS[1]:ADATAMODEL[1][_nX][1],4,1) = "3"
				Z34->Z34_RESTP3 := oModel:AALLSUBMODELS[1]:ADATAMODEL[1][_nX][2]
			Else
				Z34->Z34_RESTP3 := ""
			EndIf

			Z34->(MsUnlock())

			_cQry := " "
			_cQry += " UPDATE Z33010 SET Z33_STATUS = '1',Z33_LEGEND = 'BR_VERMELHO' "
			_cQry += " WHERE Z33_XEMPFU = '"+Z33->Z33_XEMPFU+"'	"
			_cQry += "  AND Z33_XFILFU = '"+Z33->Z33_XFILFU+"'	" 
			_cQry += "  AND Z33_ANO = '"+Z33->Z33_ANO+"'  	" 
			_cQry += "  AND Z33_MAT = '"+Z33->Z33_MAT+"' 	" 
			_cQry += "	AND Z33_ITEM = '"+Z33->Z33_ITEM+"' 	"	
			_cQry += " 	AND D_E_L_E_T_ = ' ' 	"

			TCSqlExec(_cQry)

		EndIf

	Next _nX

Return lRet
