#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "FWMVCDEF.CH"




/*/{Protheus.doc} STCTBR30
description
Aprovação de lançamentos manuais contábeis
@type function
@version  
@author Cristiano Pereira
@since 21/04/2021
@return return_type, return_description
/*/
USER FUNCTION STCTBR30()

	Local aParam       := {}
	Local aRetParam    := {}
	Local bVlid        := {|| VldPar() }

	Private oMark
	Private cCondicao      := ""
	Private cData          := CriaVar("CT2_DATA")
	Private cLote          := CriaVar("CT2_LOTE")
	Private cFil1          := '01'
	Private cFil2          := '99'
	Private _dDataDe  := Ctod(Space(8))
	Private _dDataAt  := Ctod(Space(8))


	If  !(cusername $ getmv('ST_APCTBN1')) .And. !(cusername $ getmv('ST_APCTBN2'))
		MsgInfo("Aprovador sem acesso.","Atenção")
		return
	Endif



	//MsgInfo("Em desenvolvimento","Atenção!")
	//Return

	aAdd(aParam, {1, "Data de", _dDataDe,  ,,,, 50, .T.})
	aAdd(aParam, {1, "Data ate",_dDataAt,  ,,,, 50, .T.})

	if !ParamBox(aParam, "Informe os parâmetros", @aRetParam,bVlid,,,,,,, .F., .F.)
		Return
	Endif

	_dDataDe    := MV_PAR01
	_dDataAt   :=  MV_PAR02

	dbSelectArea("CT2")
	dbSetOrder(1)

	cCondicao += " DTOS(CT2_DATA) >= '"+Dtos(_dDataDe )  +"'.And. DTOS(CT2_DATA) <= '"+Dtos(_dDataAt)+"' "

	If  (cusername $ getmv('ST_APCTBN1'))
		cCondicao += " .And. CT2_XRESP1 ==' '  .and. CT2_XRESP2 ==' ' "
	Endif

 	If  (cusername $ getmv('ST_APCTBN1'))
		cCondicao += " .And. CT2_VALOR >= "+cValTochar(getmv('ST_APCTVL1'))+""  "
	Endif

	If  (cusername $ getmv('ST_APCTBN2'))
		cCondicao += " .And. CT2_VALOR >= "+CValTochar(getmv('ST_APCTVL2'))+"  "
	Endif



	If  (cusername $ getmv('ST_APCTBN2'))
		cCondicao += " .And. CT2_XRESP1 <> ' ' .and. CT2_XRESP2 ==' ' "
	Endif

	//Criando o MarkBrow
	oMark := FWMarkBrowse():New()
	oMark:SetAlias('CT2')

	//Setando semáforo, descrição e campo de mark
	oMark:SetSemaphore(.F.)
	oMark:SetDescription('Seleção de movimentos contábeis.')
	oMark:SetFieldMark( 'CT2_XOK' )
	oMark:SetAllMark( {|| FWMsgRun(,{|| SelectAll()},,"Selecionando Registros, aguarde!") })
	oMark:AddFilter("Filtrando títulos conforme parametros informado", cCondicao, .T., .T.)

	//Setando Legenda
	oMark:AddLegend( "CT2_XRESP1 == '' .and. CT2_XRESP2 =='' ", "GREEN",	"Não aprovado")
	oMark:AddLegend( "CT2_XRESP1 <> '' .and. CT2_XRESP2 =='' ", "BLUE",	"Aprovado Nível I")
	oMark:AddLegend( "CT2_XRESP1 <> '' .and. CT2_XRESP2 <>'' ", "BLUE",	"Aprovado Nível II")

	//Ativando a janela
	oMark:Activate()

Return NIL

/*/{Protheus.doc} VldPar
description
Validação do Parambox
@type function
@version  
@author Cristiano Pereira
@since 13/04/2021
@return return_type, return_description
/*/
Static Function VldPar()
	Local lRET := .T.

	if Empty(MV_PAR01)
		lRET := .F.
		MsgInfo("Informe data inicial para o processamento..", "Atenção!")
	endif
	if Empty(MV_PAR02)
		lRET := .F.
		MsgInfo("Informe data final para o processamento..", "Atenção!")
	endif

Return lRET

/*/{Protheus.doc} AprAuto
description
Rotina que realizará a baixa
@type function
@version  
@author Cristiano Pereira
@since 07/04/2021
@return return_type, return_description
/*/
Static Function AprAuto(nOPC)

	// Função para tratamento da troca de Filial
	MdEmpFil(cEmpAnt, CT2->CT2_FILORI)

	Begin Transaction


		If  cusername $ getmv('ST_APCTBN1')
			If Reclock("CT2",.F.)
				CT2->CT2_XRESP1:= cusername
				CT2->CT2_XNOME1:= UsrRetName(RetCodUsr())
				CT2->CT2_XDATAP:= DDATABASE
				CT2->CT2_XHORA1:= Time()
			Endif
		ElseIf cusername $ getmv('ST_APCTBN2')
			If Reclock("CT2",.F.)
				CT2->CT2_XRESP2:= cusername
				CT2->CT2_XNOME2:= UsrRetName(RetCodUsr())
				CT2->CT2_XDATAP2:= DDATABASE
				CT2->CT2_XHORA2:= Time()
			Endif
		Endif

	End Transaction

Return


/*/{Protheus.doc} MdEmpFil
description
Rotina para troca de filial
@type function
@version  
@author Cristiano Pereira
@since 07/04/2021
@param cEmp, character, param_description
@param cFil, character, param_description
@return return_type, return_description
/*/
Static Function MdEmpFil(cEmp,cFil)

	Local aSM0Area 	:= {}
	Local cPosicao	:= ""
	Local cEnvLog	:= ""
	// Local bError	:= ErrorBlock( { |oError| U_xTrataError( oError,@cEnvLog ) } )// Salva bloco de c?igo do tratamento de erro
	Local cEmpAux	:= ""
	Local cFilAux	:= ""
	Local aArea     := GetArea()

	Begin Sequence
		If Select("SX2") == 0
			dbCloseAll()
			// RpcClearEnv()
			RESET ENVIRONMENT
			RpcSetType(3)
			PREPARE ENVIRONMENT EMPRESA cEmp FILIAL cFil TABLES "CT2","CTK","CV3"
			// RpcSetEnv(cEmp,cFil)
		EndIf
		// Armazena dados da empresa antes da mudar?
		cEmpAux		:= cEmpAnt
		cFilAux		:= cFilAnt
		aSM0Area	:= SM0->(GetArea())
		// Faz a mudança para a nova empresa
		If SM0->(dbSeek(cEmp + cFil))
			cEmpAnt		:= cEmp
			cFilAnt		:= cFil
			cPosicao	:= "OK"
			cDescFil    := SM0->M0_FILIAL
		Else
			cPosicao	:= "ERRO: Não foi possíel posicionar na empresa " + cEmp + " filial " + cFil
			SM0->(RestArea(aSM0Area))
		EndIf
	End Sequence

	//ErrorBlock(bError)

	If !Empty(cEnvLog)
		cPosicao := "ERRO: "+cEnvLog
	EndIf

	RestArea( aArea )

Return ({cPosicao,aSM0Area,cEmpAux,cFilAux})



/*/{Protheus.doc} MenuDef
description
Adicionando Menu
@type function
@version  
@author Cristiano Pereira
@since 07/04/2021
@return return_type, return_description
/*/
Static Function MenuDef()
	Local aRotina := {}

	//Criação das opções
	//ADD OPTION aRotina TITLE 'Visualizar' ACTION 'u_EVVISUA' OPERATION 2 ACCESS 0
	//ADD OPTION aRotina TITLE 'Alterar'    ACTION 'VIEWDEF.EVModel' OPERATION 4 ACCESS 0
	ADD OPTION aRotina TITLE 'Aprovar'     ACTION 'u_STCT30A(3)'     OPERATION 2 ACCESS 0
	//ADD OPTION aRotina TITLE 'Legenda'    ACTION 'u_zMod1Leg'      OPERATION 2 ACCESS 0

Return aRotina


/*/{Protheus.doc} ModelDef
description
Criação do modelo de dados MVC 
@type function
@version  
@author Cristiano Pereira
@since 07/04/2021
@return return_type, return_description
/*/
//Static Function ModelDef()
//Return FWLoadModel('EVModel')



/*/{Protheus.doc} ViewDef
description
Criação da visão MVC
@type function
@version  
@author Cristiano Pereira
@since 07/04/2021
@return return_type, return_description
/*/
Static Function ViewDef()
Return FWLoadView('EVModel')

/*/{Protheus.doc} EVPROCES
description
Rotina que irá iniciar o processamento
@type function
@version  
@author Cristiano Pereira
@since 07/04/2021
@return return_type, return_description
/*/
User Function STCT30A(nOPC)
	CursorArrow()
	CursorWait()
	Processa({|| CTIniProc(nOPC) }, "Selecionado registros, por favor Aguarde.")
	CursorArrow()
Return


/*/{Protheus.doc} EVIniProc
description
Rotina que irá iniciar o processo
@type function
@version  
@author Cristiano Pereira
@since 07/04/2021
@return return_type, return_description
/*/
Static Function CTIniProc(nOPC)
	Local aArea     := GetArea()
	Local cMarca    := oMark:Mark()
	Local _cFilAnt  := cFilAnt
	Local nTotal    := 0
	Local aRegistro := {}
	Local cQry      := ""

	cQry := "SELECT A.R_E_C_N_O_ REG " + CRLF
	cQry += "FROM " + RETSQLNAME("CT2") + " A " + CRLF
	cQry += "WHERE A.D_E_L_E_T_ = ' ' " + CRLF
	cQry += " AND CT2_DATA >= '"+Dtos(_dDataDe)  +"'AND CT2_DATA <= '"+Dtos(_dDataAt)+"' " + CRLF
	cQry += " AND CT2_XOK='"+cMarca+"' " + CRLF

	If  cusername $ getmv('ST_APCTBN1')
		cQry += " AND CT2_XRESP1=' ' AND CT2_XRESP2=' ' " + CRLF
	ElseIf  cusername $ getmv('ST_APCTBN2')
		cQry += " AND CT2_XRESP1<>' ' AND CT2_XRESP2=' ' " + CRLF
	Endif

	IF SELECT("TCT2") > 0
		TCT2->( dbCloseArea() )
	ENDIF


	TcQuery cQry New Alias "TCT2"

	TCT2->( dbGotop() )
	TCT2->( dbEval({|| nTotal++ },,{|| !Eof()}) )
	ProcRegua( nTotal )
	TCT2->( dbGotop() )

	cMsg := "Aprovando"

	if (TCT2->(!EOF()))
		While (TCT2->(!EOF()))
			ProcessMessage()
			CT2->( DBGOTO( TCT2->REG ) )
			IncProc(cMsg+" Movimento: " + CT2->CT2_HIST)
			AprAuto(nOPC)
			TCT2->(DbSkip())
		EndDo
	Else
		FWMsgRun(,{|| Sleep(3000)},'Informação','Não foi selecionado nenhum registro, ou registros já foram aprovados')
		Return
	endif

	IF SELECT("TCT2") > 0
		TCT2->( dbCloseArea() )
	ENDIF

	//Restaurando área armazenada
	RestArea(aArea)

Return NIL

/*/{Protheus.doc} SelectAll
description
@type function
@version  
@author Cristiano Pereira
@since 07/04/2021
@return return_type, return_description
/*/
Static Function SelectAll()
	Local cMarca   := oMark:Mark()
	Local lInverte := oMark:IsInvert()

	CT2->(  dbGotop() )
	While CT2->( !Eof() )
		RecLock('CT2',.F.)
		if oMark:IsMark(cMarca)
			CT2->CT2_XOK := ''
		else
			CT2->CT2_XOK := cMarca
		Endif
		MsUnlock()
		CT2->( dbSkip() )
	EndDo
	CT2->( DBGOBOTTOM() )
	oMark:Refresh()
	CT2->(  dbGotop() )
	oMark:Refresh()

Return

