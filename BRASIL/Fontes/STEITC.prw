#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

/*====================================================================================\
|Programa  | STEITC          | Autor | Jefferson Carlos             | Dat | 08/03/2016  |
|=====================================================================================|
|Descriï¿½ï¿½o |  Tela Obras ITC          				                                      |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STEITC                                                                 |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histï¿½rico....................................|
\==========================	==========================================================*/

User Function STEITC()		//U_STEITC()

	Local oBrowse
	Local _cQuery1	:= ""
	Local _cAlias1  := GetNextAlias()
	Local cUsrAces  := SuperGetMV("ST_USRAITC",.F.,"001177")				// Valdemir Rabelo 08/10/2019

	Private aRotina := MenuDef()
	Private cUsExITC := Getmv("ST_EXITC",,"000000/000645/000314/000294/000251/")

	DbSelectArea("ZZ5")
	ZZ5->(DbSetOrder(1))

	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias("ZZ5")                        // Alias da tabela utilizada
	oBrowse:SetDescription("Cadastro de Obras ITC")      	   // Descriï¿½ï¿½o do browse
	oBrowse:SetUseCursor(.F.)
	oBrowse:AddLegend( "ZZ5_STATUS=='O'", "GREEN", "Aguardando Visita" )
	oBrowse:AddLegend( "ZZ5_STATUS=='1'", "YELLOW","Somente Terreno" )
	oBrowse:AddLegend( "ZZ5_STATUS=='2'", "ORANGE","Limpando Terreno" )
	oBrowse:AddLegend( "ZZ5_STATUS=='3'", "BLUE",  "Stand" )
	oBrowse:AddLegend( "ZZ5_STATUS=='4'", "GRAY",  "Fundação" )
	oBrowse:AddLegend( "ZZ5_STATUS=='5'", "BROWN", "Em Construção" )
	oBrowse:AddLegend( "ZZ5_STATUS=='6'", "BLACK", "Obra Parada" )
	oBrowse:AddLegend( "ZZ5_STATUS=='7'", "PINK",  "Obra Pronta" )
	oBrowse:AddLegend( "ZZ5_STATUS=='8'", "WHITE", "Outros" )
	oBrowse:AddLegend( "ZZ5_STATUS=='9'", "RED",   "Encerrado" )

	If Substr(Posicione("SA3",7,xFilial("SA3")+__cUserId,"A3_COD"),1,1)$"S#G"

		_cVends := ""

		_cQuery1 := " SELECT A3_COD
		_cQuery1 += " FROM "+RetSqlName("SA3")+" A3
		_cQuery1 += " WHERE A3.D_E_L_E_T_=' ' AND A3_XSUPINT='"+Posicione("SA3",7,xFilial("SA3")+__cUserId,"A3_COD")+"'

		If !Empty(Select(_cAlias1))
			DbSelectArea(_cAlias1)
			(_cAlias1)->(dbCloseArea())
		Endif

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

		dbSelectArea(_cAlias1)
		(_cAlias1)->(dbGoTop())

		While (_cAlias1)->(!Eof())
			_cVends += (_cAlias1)->A3_COD+"#"
			(_cAlias1)->(DbSkip())
		EndDo

		if !(__cUserId $ cUsrAces)      // Valdemir Rabelo - 08/10/2019
			oBrowse:SetFilterDefault( "ZZ5->ZZ5_AREA $ '" + _cVends +"'" )
		endif

	Else
		if !(__cUserId $ cUsrAces)      // Valdemir Rabelo - 08/10/2019
			oBrowse:SetFilterDefault( "ZZ5->ZZ5_AREA='"+Posicione("SA3",7,xFilial("SA3")+__cUserId,"A3_COD")+"'" )
		endif
	EndIf

	oBrowse:Activate()

Return

Static Function MenuDef()

	Local aRotina := {}

	//ADD OPTION aRotina TITLE 'Importar'  				ACTION "U_IMPITC"        	OPERATION 1  ACCESS 0 //"Importacao"
	ADD OPTION aRotina TITLE "Visualizar" 				ACTION "VIEWDEF.STEITC"  	OPERATION 2  ACCESS 0 //"Visualizar"
	ADD OPTION aRotina TITLE "Alterar"    				ACTION "VIEWDEF.STEITC" 	OPERATION 4  ACCESS 0 //"Alterar"
	//	ADD OPTION aRotina TITLE "Excluir"    				ACTION "VIEWDEF.STEITC"		OPERATION 5  ACCESS 0 //"Excluir"
	ADD OPTION aRotina TITLE "Excluir"    				ACTION 'u_STEITCEXC' 		OPERATION 5  ACCESS 0 //"Excluir"
	ADD OPTION aRotina TITLE "Incluir"    				ACTION "VIEWDEF.STEITC"		OPERATION 3  ACCESS 0 //"Incluir"
	ADD OPTION aRotina TITLE "Imprimir"   				ACTION "U_RSTFAITC" 		OPERATION 8  ACCESS 0 //"Imprimir"

Return aRotina

Static Function ModelDef()

	Local oModel
	//Local oFieldModel := oModel:GetModel("FIELD1")
	Local oStr1       := FWFormStruct(1,'ZZ5')

	oModel := MPFormModel():New('MOD03STEITC',,,{|oModel|GrvTOK(oModel)})
	oModel:SetDescription('Main')
	oModel:addFields('FIELD1',,oStr1,,)
	oModel:SetPrimaryKey({ 'ZZ5_FILIAL', 'ZZ5_COD' })
	oModel:getModel('FIELD1'):SetDescription('Cabeçalho')

Return oModel

Static Function ViewDef()

	Local oView
	Local oModel := ModelDef()
	Local oStr1:= FWFormStruct(2, 'ZZ5')

	oView := FWFormView():New()

	oView:SetModel(oModel)
	oView:AddField('FORM1' , oStr1,'FIELD1' )
	oView:CreateHorizontalBox( 'BOXFORM1', 100)
	oView:SetOwnerView('FORM1','BOXFORM1')

Return oView

//-------------------------------------------------------------------
/*/{Protheus.doc} STEITCEXC

Exclusï¿½o do Processo de Obra ITC

@author Richard N Cabral - 01/12/17
/*/
//-------------------------------------------------------------------
User Function STEITCEXC()

	Local oModel := Nil
	Local oView	 := Nil

	//-------------------------------------------------------------------------------------------------
	// Tela ITC
	//  - Validar exclusï¿½o se estiver cï¿½digo vendedor
	//  - Validar exclusï¿½o se estiver Encerrado - ZZ5_STATUS=='9'
	//  - Criar parï¿½metro que autoriza exclusï¿½o mesmo com vendedor
	//-------------------------------------------------------------------------------------------------

	If ZZ5->ZZ5_STATUS == '9'
		MsgAlert("Obra ITC encerrada. Não pode excluir.","Atenção")
		Return
	EndIf

	If ! Empty(ZZ5->ZZ5_AREA)
		If ! (__cUserId $ cUsExITC)
			MsgAlert("Obra ITC com vendedor. Não pode excluir.","Atenção")
			Return
		EndIf
	EndIf

	oModel := FWLoadModel( 'STEITC' )
	oView  := FWLoadView ( 'STEITC' )

	oModel:SetOperation( MODEL_OPERATION_DELETE )
	oModel:Activate()

	oExecView := FWViewExec():New()
	oExecView:SetTitle( "Exclusão de Obra ITC" )
	oExecView:SetView( oView )
	oExecView:SetModal(.F.)
	oExecView:SetOperation( MODEL_OPERATION_DELETE )
	oExecView:SetModel( oModel )
	oExecView:SetCloseOnOK({|| .T.})
	oExecView:OpenView( .F. )

Return

/*/{Protheus.doc} GrvTOK
@name GrvTOK
@type Static Function
@desc realiZP gravaï¿½ï¿½o dos dados
@author Renato Nogueira
@since 12/09/2016
/*/

Static Function GrvTOK( oModel )

	Local lGrv				:= .T.
	Local nOp        		:= oModel:GetOperation()

	Begin Transaction
		FWFormCommit( oModel )
	End Transaction

	U_STEITC01(nOp)

Return lGrv

User Function STEITC01(_nOpcao)

	Local _cEmail 	:= ""
	Local _cCopia 	:= ""
	Local _cAssunto	:= ""
	Local _aAttach	:= {}
	Local _cCaminho := ""
	Local _cMsg		:= ""
	Local _aTpDesc	:= {}
	Local _nPos		:= 0
	
	DbSelectArea("SA1")
	SA1->(DbSetOrder(1))
	If !SA1->(DbSeek(xFilial("SA1")+ZZ5->(ZZ5_CLIENT+ZZ5_LOJA)))
		MsgAlert("Cliente não encontrado, o WF não será enviado!")
	EndIf
	
	//20200717004346
	If AllTrim(SA1->A1_GRPVEN) $ "R1/R2/R3/R4/R5/D1/D2/D3"
		Return()
	EndIf

	If !(SubStr(ZZ5->ZZ5_AREA,1,1))=="R"
		_cEmail := AllTrim(Posicione("SA3",1,xFilial("SA3")+ZZ5->ZZ5_AREA,"A3_EMAIL"))+";"
	EndIf
	
	_cEmail += AllTrim(Posicione("SA3",1,xFilial("SA3")+Posicione("SA3",1,xFilial("SA3")+ZZ5->ZZ5_AREA,"A3_SUPER"),"A3_EMAIL"))
	_cCopia	  := SuperGetMv("ST_EMLITC",,,"filipe.nascimento@steck.com.br")
	_cAssunto := "[WFPROTHEUS] - Acompanhamento de obras ITC"
	_aAttach  := {}
	_cCaminho := ""

	_aTpDesc  :=	RetSX3Box(GetSX3Cache("ZZ5_STATUS","X3_CBOX"),,,1)
	_nPos	  := aScan(_aTpDesc,{|x| AllTrim(x[2]) == ZZ5->ZZ5_STATUS})

	_cMsg := ""
	_cMsg += '<html>'
	_cMsg += '<head>'
	_cMsg += '<title>' +SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title>'
	_cMsg += '</head>'
	_cMsg += '<body>'
	_cMsg += "<table border='1'>
	_cMsg += "<tr><td colspan='2'><b>Código da obra:</b> "+ZZ5->ZZ5_COD+"</td></tr>
	_cMsg += "<tr><td><b>Nome</b></td><td>"+ZZ5->ZZ5_NOMEOB+"</td></tr>
	_cMsg += "<tr><td><b>Endereço</b></td><td>"+ZZ5->ZZ5_ENDERE+"</td></tr>
	if _nPos > 0
		_cMsg += "<tr><td><b>Status</b></td><td>"+_aTpDesc[_nPos][03]+"</td></tr>
	else
		_cMsg += "<tr><td><b>Status</b></td><td>0</td></tr>
	endif
	_cMsg += "<tr><td><b>Tipo</b></td><td>"+IIf(_nOpcao==3,"Inclusão","Alteração")+"</td></tr>
	_cMsg += "<tr><td><b>Estado</b></td><td>"+ZZ5->ZZ5_ESTADO+"</td></tr>
	_cMsg += "<tr><td><b>Visita</b></td><td>"+DTOC(ZZ5->ZZ5_DTVISI)+"</td></tr>
	// --------------- Adicionado Valdemir Rabelo 11/10/2019 ------------------------- // 21/10/2019 nomcli Valdemir Rabelo
	_cMsg += "<tr><td><b>Nº UNICON</b></td><td>"+ZZ5->ZZ5_CODORI+"</td></tr>
	_cMsg += "<tr><td><b>Cliente</b></td><td>"+ZZ5->ZZ5_NOMCLI+"</td></tr>
	// ---------------

	_cMsg += "<tr><td><b>Observaço</b></td><td>"+ZZ5->ZZ5_OBS+"</td></tr>
	//

	//20201014008789
	//If U_STMAILTES(_cEmail, _cCopia, _cAssunto, _cMsg ,_aAttach,_cCaminho)
	//	Conout("Problemas no envio de email!")
	//EndIf

Return()
