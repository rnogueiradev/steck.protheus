#Include "Protheus.ch"
#Include "FWMvcDef.CH"
#include "topconn.ch"

#Define CR chr(13)+ chr(10)
#Define ALIASM		"Z32" //Alias Master
#Define MDLTITLE	"FEEDBACK 360º"
#Define MDLDATA 	"MDLAV360"
#Define MDLMASTER	"Z32_MASTER"

/*/{Protheus.doc} STAV360

Cadastros de Participantes FEEDBACK 360

@since 07/08/17
@version Protheus 12 - Gestão de Pessoal

@history , ,

@type function
@author Everson Santana

/*/

User Function STAV360()

	Local _oBrowse := FWMBrowse():New()
	//Local lRet := .T.
	Private _UserRh := GetMv('ST_STAV360',,'000000/001036/000975/000915/000952')

	If !__cUserId $ _UserRh

		//lRet := .F.
		Help( ,, 'Help',, 'Você não tem permissão para acessar está rotina' +;
			CRLF +CRLF + 'Verifique com RH! ', 1, 0 )

		Return

	EndIf

	_oBrowse:SetAlias(ALIASM)
	_oBrowse:SetDescription(MDLTITLE)

	//Legendas do Browse
	//_oBrowse:AddLegend( "ZJ_STATUS == '1'", "GREEN", "Periodo Aberto"  )
	//_oBrowse:AddLegend( "ZJ_STATUS == '2'", "RED"  , "Periodo Fechado" )

	_oBrowse:Activate()

Return Nil
/*
Define o menu da rotina
*/
Static Function MenuDef()

	Local _aRotina := {}

	/*>> Everson Santana - 08/08/2017
	OPERATION
	1 - Pesquisa
	2 - Visualizar
	3 - Incluir
	4 - Alterar
	5 - Exclui
	<<*/

	ADD OPTION _aRotina TITLE "Pesquisar"  		ACTION "PesqBrw"         	OPERATION 1 ACCESS 0
	ADD OPTION _aRotina TITLE "Visualizar" 		ACTION "VIEWDEF.STAV360" 	OPERATION 2 ACCESS 0
	ADD OPTION _aRotina TITLE "Incluir"    		ACTION "VIEWDEF.STAV360"	OPERATION 3 ACCESS 0
	ADD OPTION _aRotina TITLE "Alterar"    		ACTION "VIEWDEF.STAV360"	OPERATION 4 ACCESS 0
	ADD OPTION _aRotina TITLE "Excluir"    		ACTION "VIEWDEF.STAV360" 	OPERATION 5 ACCESS 0
	ADD OPTION _aRotina TITLE "Gerar FeedBack"  ACTION 'U_STAV360c' 		OPERATION 3 ACCESS 0
	ADD OPTION _aRotina TITLE "Avaliar"    		ACTION "U_CMVC_08" 			OPERATION 4 ACCESS 0

Return _aRotina
/*
Define o modelo da rotina
*/
Static Function ModelDef()

	Local _oStrutMaster	:= FWFormStruct(1, ALIASM, /**/, /*lViewUsado*/)
	Local _oModel 		:= MPFormModel():New(MDLDATA, /*bPreValidacao*/, /*bPost*/,/*bCommit*/, /*bCancel*/)
	Local bPosVal1 		:= { |_oModel| STAV3602b( _oModel ) }

	//Instancia do Objeto de Modelo de Dados Ponto de entrada
	//>> Ponto de Entrada
	_oModel	:=	MpFormModel():New("PESTAV360",/*Pre-Validacao*/,bPosVal1/*Pos-Validacao*/,/*Commit*/,/*Cancel*/)
	//<<

	_oModel:AddFields(MDLMASTER, /*cOwner*/, _oStrutMaster, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/)
	_oModel:GetModel(MDLMASTER):SetDescription("FEEDBACK 360ª - Participante")
	_oModel:SetDescription(MDLTITLE)
	_oModel:SetPrimaryKey({ "Z32_FILIAL","Z32_ANO","Z32_XEMP","Z32_XFILIA", "Z32_MAT"})


Return _oModel
/*
Define a view da rotina
*/
Static Function ViewDef()

	Local _oStrutMaster 	:= FWFormStruct(2, ALIASM, /**/)
	Local _oModel   	 	:= FWLoadModel("STAV360")
	Local _oView		 	:= FWFormView():New()

	_oView:SetModel(_oModel)
	_oView:AddField("VIEW_MASTER", _oStrutMaster, MDLMASTER)
	_oView:SetCloseOnOk({|| .T.})


Return _oView


Static Function STAV3602b(_oModel)

	Local lRet := .T.
	Local nOperation := _oModel:GetOperation()
	Local nLinhas 	:= 0
	Local nI := 0
	Local _cQry := ""
	Local _cAno 	:= ""
	Local _cUser	:= ""

	If nOperation = 5

		_cAno 	:= _oModel:GetValue(MDLMASTER,"Z32_ANO")
		_cUser 	:= _oModel:GetValue(MDLMASTER,"Z32_USER")

		If Select("TRD") > 0
			TRD->(DbCloseArea())
		Endif

		_cQry := " "
		_cQry += " SELECT *  FROM "+RetSqlName("Z33") "
		_cQry += " WHERE Z33_FILIAL = '"+xFilial("Z33")+" '  "
		_cQry += " AND Z33_ANO = '"+_cAno+"' "
		_cQry += " AND Z33_USER = '"+_cUser+"' "
		_cQry += " AND D_E_L_E_T_ = ' ' "

		TcQuery _cQry New Alias "TRD"

		TRD->(dbGoTop())

		If  !Empty(TRD->Z33_STATUS)
			lRet := .F.
			Help( ,, 'Help',, 'Este participante não poderá ser excluido..' +;
				CRLF + CRLF + 'Já existem avaliadores cadastrodos! ', 1, 0 )
		EndIf

	EndIf

Return lRet

User Function STAV360c()

	Local cFiltro		:= ""
	Local _aRet 			:= {}
	Local _aParamBox 		:= {}

	AADD(_aParamBox,{1,"Informe o Ano de Referência: ",Space(4) ,"",""," ","",0,.F.})

	If ParamBox(_aParamBox,"Gerar Carga",@_aRet,,,.T.,,500)
		cFiltro := _aRet[01]
	EndIf

	Processa({|| u_STAV360D(cFiltro) ,"Processando ..."})

Return

User Function STAV360D(cFiltro)

	Local _cQry1	 	:= ""
	//Local cFiltro		:= ""
	//Local _aRet 			:= {}
	//Local _aParamBox 		:= {}

	//AADD(_aParamBox,{1,"Informe o Ano de Referência: ",Space(4) ,"",""," ","",0,.F.})

	//If ParamBox(_aParamBox,"Gerar Carga",@_aRet,,,.T.,,500)
	//	cFiltro := _aRet[01]
	//EndIf

	If !Empty(cFiltro)

		If  Val(cFiltro) <= Val(getmv("ST_ULAV360",,"2020"))

			Help(NIL, NIL, "HELP", NIL, 'Periodo encerrado..', 1, 0, NIL, NIL, NIL, NIL, NIL, {'Informe o Ano de Referência'})
			Return
		EndIf

		If Select("TRC") > 0
			TRC->(DbCloseArea())
		Endif

		/*
		_cQry1 := " "
		_cQry1 += " SELECT RA_FILIAL,RA_XEMP,RA_MAT,RA_XUSRCFG,RA_NOME,RA_CODFUNC,RA_DEPTO,RA_XMATSUP,RA_XUSRSUP,RA_ADMISSA,RA_XUSRSUP FROM SRA010 WHERE RA_XAV360 = '1' AND RA_DEMISSA = ' ' AND D_E_L_E_T_ = ' ' "
		_cQry1 += " UNION "
		_cQry1 += " SELECT RA_FILIAL,RA_XEMP,RA_MAT,RA_XUSRCFG,RA_NOME,RA_CODFUNC,RA_DEPTO,RA_XMATSUP,RA_XUSRSUP,RA_ADMISSA,RA_XUSRSUP FROM SRA030 WHERE RA_XAV360 = '1' AND RA_DEMISSA = ' ' AND D_E_L_E_T_ = ' ' "
		//_cQry1 += " UNION "
		//_cQry1 += " SELECT RA_MAT,RA_XUSRCFG,RA_NOME,RA_CODFUNC,RA_DEPTO,RA_XMATSUP,RA_XUSRSUP,RA_ADMISSA,RA_XUSRSUP FROM SRA070 WHERE RA_XAV360 = '1' AND D_E_L_E_T_ = ' ' "
		*/

		_cQry1 := " "
		_cQry1 += " SELECT * FROM (	" 
		_cQry1 += " SELECT "
		_cQry1 += "  SQB.QB_FILRESP RA_XFILSUP, "
		_cQry1 += "  SRASUP.RA_XEMPSUP RA_XEMPSUP, "
		_cQry1 += "  SQB.QB_MATRESP RA_XMATSUP, "
		_cQry1 += "  SRASUP.RA_XUSRCFG RA_XUSRSUP, "
		_cQry1 += "  SRASUP.RA_NOME RA_NOMESUP, "
		_cQry1 += "  SRA.RA_FILIAL, "
		_cQry1 += "  SRA.RA_XEMP,  "
		_cQry1 += "  SRA.RA_MAT, "
		_cQry1 += "  SRA.RA_XUSRCFG, "
		_cQry1 += "  SRA.RA_NOME, "
		_cQry1 += "  SRA.RA_CODFUNC,  "
		_cQry1 += "  SRJ.RJ_DESC, "
		_cQry1 += "  SRA.RA_DEPTO,  "
		_cQry1 += "  SQB.QB_DESCRIC, "
		_cQry1 += "  SRA.RA_ADMISSA "
		_cQry1 += " FROM   SRA010 SRA "
		_cQry1 += " LEFT JOIN SRJ010 SRJ "
		_cQry1 += "    ON SRJ.RJ_FILIAL = ' ' "
		_cQry1 += "        AND SRJ.RJ_FUNCAO = SRA.RA_CODFUNC "
		_cQry1 += "        AND SRJ.D_E_L_E_T_ = ' ' "
		_cQry1 += " LEFT JOIN SQB010 SQB "
		_cQry1 += "    ON SQB.QB_FILIAL = ' ' "
		_cQry1 += "        AND SQB.QB_DEPTO = SRA.RA_DEPTO "
		_cQry1 += "        AND Sqb.D_E_L_E_T_ = ' ' "
		_cQry1 += " LEFT JOIN SRA010 SRASUP "
		_cQry1 += "    ON SRASUP.RA_FILIAL = SQB.QB_FILRESP "
		_cQry1 += "        AND SRASUP.RA_MAT = SQB.QB_MATRESP "
		_cQry1 += "        AND SRASUP.D_E_L_E_T_ = ' ' "
		_cQry1 += " WHERE SRA.RA_XAV360 = '1' "
		_cQry1 += "   AND SRA.RA_DEMISSA = ' ' "
		_cQry1 += "   AND SRA.D_E_L_E_T_ = ' ' "
		_cQry1 += " AND SRA.RA_XEMP <> ' ' AND SRA.RA_FILIAL <> ' ' AND SRA.RA_MAT <> ' ' AND SRA.RA_XUSRCFG <> ' ' "

		_cQry1 += " UNION "

		_cQry1 += " SELECT "
		_cQry1 += "  SQB.QB_FILRESP RA_XFILSUP, "
		_cQry1 += "  SRASUP.RA_XEMPSUP RA_XEMPSUP, "
		_cQry1 += "  SQB.QB_MATRESP RA_XMATSUP, "
		_cQry1 += "  SRASUP.RA_XUSRCFG RA_XUSRSUP, "
		_cQry1 += "  SRASUP.RA_NOME RA_NOMESUP, "
		_cQry1 += "  SRA.RA_FILIAL, "
		_cQry1 += "  SRA.RA_XEMP,  "
		_cQry1 += "  SRA.RA_MAT, "
		_cQry1 += "  SRA.RA_XUSRCFG, "
		_cQry1 += "  SRA.RA_NOME, "
		_cQry1 += "  SRA.RA_CODFUNC,  "
		_cQry1 += "  SRJ.RJ_DESC, "
		_cQry1 += "  SRA.RA_DEPTO,  "
		_cQry1 += "  SQB.QB_DESCRIC, "
		_cQry1 += "  SRA.RA_ADMISSA "
		_cQry1 += " FROM   SRA030 SRA "
		_cQry1 += " LEFT JOIN SRJ030 SRJ "
		_cQry1 += "    ON SRJ.RJ_FILIAL = ' ' "
		_cQry1 += "        AND SRJ.RJ_FUNCAO = SRA.RA_CODFUNC "
		_cQry1 += "        AND SRJ.D_E_L_E_T_ = ' ' "
		_cQry1 += " LEFT JOIN SQB030 SQB "
		_cQry1 += "    ON SQB.QB_FILIAL = ' ' "
		_cQry1 += "        AND SQB.QB_DEPTO = SRA.RA_DEPTO "
		_cQry1 += "        AND SQB.D_E_L_E_T_ = ' ' "
		_cQry1 += " LEFT JOIN SRA030 SRASUP "
		_cQry1 += "    ON SRASUP.RA_FILIAL = SQB.QB_FILRESP "
		_cQry1 += "        AND SRASUP.RA_MAT = SQB.QB_MATRESP "
		_cQry1 += "        AND SRASUP.D_E_L_E_T_ = ' ' "
		_cQry1 += " WHERE SRA.RA_XAV360 = '1' "
		_cQry1 += "   AND SRA.RA_DEMISSA = ' ' "
		_cQry1 += "   AND SRA.D_E_L_E_T_ = ' ' 
		_cQry1 += " AND SRA.RA_XEMP <> ' ' AND SRA.RA_FILIAL <> ' ' AND SRA.RA_MAT <> ' ' AND SRA.RA_XUSRCFG <> ' ' "
		_cQry1 += " ) TEMP "

		_cQry1 += " ORDER BY RA_XEMP,RA_FILIAL,RA_MAT,RA_XUSRCFG "

		TcQuery _cQry1 New Alias "TRC"

		DbSelectArea("TRC")
		DbGotop()

		While !EOF()

			DbSelectArea("Z32")
			DbSetOrder(6)
			DbGotop()

			If !DbSeek(TRC->RA_XEMP+TRC->RA_FILIAL+TRC->RA_MAT+TRC->RA_XUSRCFG+Alltrim(cFiltro))

				Z32->(RecLock("Z32", .T.))

				Z32->Z32_FILIAL := xFilial("Z32")
				Z32->Z32_XEMP	:= TRC->RA_XEMP
				Z32->Z32_XFILIA	:= TRC->RA_FILIAL
				Z32->Z32_ANO	:= Alltrim(cFiltro)
				Z32->Z32_MAT    := TRC->RA_MAT
				Z32->Z32_USER  	:= TRC->RA_XUSRCFG
				Z32->Z32_NOME  	:= TRC->RA_NOME
				Z32->Z32_CARGO 	:= TRC->RJ_DESC //POSICIONE("SRJ", 1, xFilial("SRJ") + TRC->RA_CODFUNC, "RJ_DESC")
				Z32->Z32_SETOR 	:= TRC->QB_DESCRIC //POSICIONE("SQB", 1, xFilial("SQB") + TRC->RA_DEPTO, "QB_DESCRIC")
				Z32->Z32_SUP   	:= TRC->RA_XMATSUP
				Z32->Z32_SUPUSR	:= TRC->RA_XUSRSUP
				Z32->Z32_ADMISS := Stod(TRC->RA_ADMISSA)
				Z32->Z32_SUPNO   := UsrFullName(TRC->RA_XUSRSUP)

				Z32->(MsUnlock())
			Else

				Z32->(RecLock("Z32", .F.))

				Z32->Z32_FILIAL := xFilial("Z32")
				Z32->Z32_XEMP	:= TRC->RA_XEMP
				Z32->Z32_XFILIA	:= TRC->RA_FILIAL
				Z32->Z32_ANO	:= Alltrim(cFiltro)
				Z32->Z32_MAT    := TRC->RA_MAT
				Z32->Z32_USER  	:= TRC->RA_XUSRCFG
				Z32->Z32_NOME  	:= TRC->RA_NOME
				Z32->Z32_CARGO 	:= TRC->RJ_DESC //POSICIONE("SRJ", 1, xFilial("SRJ") + TRC->RA_CODFUNC, "RJ_DESC")
				Z32->Z32_SETOR 	:= TRC->QB_DESCRIC //POSICIONE("SQB", 1, xFilial("SQB") + TRC->RA_DEPTO, "QB_DESCRIC")
				Z32->Z32_SUP   	:= TRC->RA_XMATSUP
				Z32->Z32_SUPUSR	:= TRC->RA_XUSRSUP
				Z32->Z32_ADMISS := Stod(TRC->RA_ADMISSA)
				Z32->Z32_SUPNO   := UsrFullName(TRC->RA_XUSRSUP)

				Z32->(MsUnlock())

			EndIf

			DbSelectArea("TRC")
			DbSkip()

		End

	Else

		Help(NIL, NIL, "HELP", NIL, 'Campo de preenchimento Obrigatorio..', 1, 0, NIL, NIL, NIL, NIL, NIL, {'Informe o Ano de Referência'})

	EndIf

Return