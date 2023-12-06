#Include "Protheus.ch"
#Include "FWMvcDef.CH"
#include "topconn.ch"

#INCLUDE "FINA050.CH"
#INCLUDE "DBINFO.CH"
#INCLUDE "MSMGADD.CH"
#INCLUDE "FWADAPTEREAI.CH"
#INCLUDE "XMLXFUN.CH"

#Define CR chr(13)+ chr(10)
#Define ALIASM		"SE2" //Alias Master
#Define MDLTITLE	"Aprovação Titulos a Pagar"
#Define MDLDATA 	"MDLSTFIN004"
#Define MDLMASTER	"SE2_MASTER"

/*/{Protheus.doc} STFIN004

Tela para liberação de Titulos Financeiros Contas a Pagar
Chamado 006559
@type function
@author Everson Santana
@since 10/12/18
@version Protheus 12 - Financeiro
/*/

User Function STFIN004()

	Local _oBrowse 		:= FWMBrowse():New()
	Local _cQuery 		:= ""
	Local _cQuery1 		:= ""
	Local _cAlias		:= "QRY"
	Local _cAlias1		:= "QRY1"
	Local _FinAprov 	:= GetMv('ST_FINAPRO',,.f.) //Parametro para bloquear a rotina de aprovação de Titulos
	Local _lCont 		:= .F.

	Private _cMDLTITLE	:= "Aprovação Titulos a Pagar"
	Private cPictHist
	Private CLOTE		:= ""
	Private lAltera		:= .F.
	Private dVencReaAnt	:= cTod('')
	Private LF050AUTO	:= .T.
	Private nValDig 	:= 0
	PRIVATE aDadosImp 	:= Array(3)
	Private nMoeda
	Private _UsrClas 	:= GetMv('ST_USRCLAS',,'000000/000279')
	Private _AprFin  	:= GetMv('ST_APRFIN',,'000000/001036')
	Private _cGPEUSR 	:= GetMv('ST_GPEUSR',,'000722')//Usuario aprovador do RH
	Private _cEICUSR 	:= GetMv('ST_EICUSR',,'000722')//Usuario aprovador do SigaEic/Eec
	Private _cFISUSR 	:= GetMv('ST_FISUSR',,'000722')//Usuario aprovador do Fiscal

	Private cBancoAdt 	:= PADR(GetMv('ST_FINBCO',,'341'),TamSX3("A6_COD")[1])
	Private cAgenciaAdt := PADR(GetMv('ST_FINAGN',,'8712'),TamSX3("A6_AGENCIA")[1])
	Private cNumCon		:= PADR(GetMv('ST_FINCTA',,'105116'),TamSX3("A6_NUMCON")[1])
	Private cChequeAdt	:= Space(TamSX3("E5_NUMCHEQ")[1])
	Private cHistor 	:= Space(TamSX3("E5_HISTOR")[1])
	Private cBenef 		:= Space(TamSX3("E5_BENEF")[1])

	If _FinAprov

		_oBrowse:SetAlias(ALIASM)

		If __cUserId $ _UsrClas

			SE2->(dbSetFilter({|| SE2->E2_XBLQ = '4' },'SE2->E2_XBLQ = "4" '))
			_lCont := .T.
			_cMDLTITLE := "Classificação de Titulos"

		ElseIf __cUserId $ _AprFin

			SE2->(dbSetFilter({|| ( (SE2->E2_XBLQ == '1'.AND. SE2->E2_XAPROV = __cUserId) .OR. ( SE2->E2_XBLQ == '6' .AND. SE2->E2_XAPROV = __cUserId) .OR. SE2->E2_XBLQ = '5' )  }, ' ( (SE2->E2_XBLQ == "1" .AND. SE2->E2_XAPROV = __cUserId) .OR. (SE2->E2_XBLQ == "6" .AND. SE2->E2_XAPROV = __cUserId) .OR. SE2->E2_XBLQ = "5" ) '))

			_lCont := .T.
			_cMDLTITLE := "Aprovação Titulos a Pagar"

		ElseIf __cUserId $ _cGPEUSR .OR. __cUserId $_cEICUSR .OR. __cUserId $ _cFISUSR

			SE2->(dbSetFilter({|| (SE2->E2_XAPROV = __cUserId .AND. (SE2->E2_XBLQ == '1' .OR. SE2->E2_XBLQ == '6') ) },' SE2->E2_XAPROV = __cUserId .AND. (SE2->E2_XBLQ == "1" .OR. SE2->E2_XBLQ == "6") '))

			//SE2->(dbSetFilter({|| SE2->E2_XBLQ = '1' .AND. SE2->E2_XAPROV = __cUserId },'SE2->E2_XBLQ = "1"  .AND. SE2->E2_XAPROV = __cUserId '))
			_lCont := .T.
			_cMDLTITLE := "Aprovação Titulos a Pagar"
		Else
			_cQuery := " SELECT * FROM "+RetSqlName("Z42")+" Z42 WHERE Z42_USER = '"+__cUserId+"' AND D_E_L_E_T_ = ' ' "

			If !Empty(Select(_cAlias))
				DbSelectArea(_cAlias)
				(_cAlias)->(dbCloseArea())
			Endif

			dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cAlias,.T.,.T.)

			dbSelectArea(_cAlias)
			(_cAlias)->(dbGoTop())

			If (_cAlias)->(Z42_USER) = __cUserId
				SE2->(dbSetFilter({|| SE2->E2_USRINC = __cUserId  },' SE2->E2_USRINC = __cUserId ' ))

				_lCont := .T.
				_cMDLTITLE := "Solicitação Financeiro"
			EndIf

			_cQuery1 := " SELECT * FROM "+RetSqlName("Z41")+" Z41 WHERE Z41_APRO = '"+__cUserId+"' AND D_E_L_E_T_ = ' ' "

			If !Empty(Select(_cAlias1))
				DbSelectArea(_cAlias1)
				(_cAlias1)->(dbCloseArea())
			Endif

			dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

			dbSelectArea(_cAlias1)
			(_cAlias1)->(dbGoTop())

			If (_cAlias1)->(Z41_APRO) = __cUserId

				SE2->(dbSetFilter({|| (SE2->E2_XAPROV = __cUserId .AND. (SE2->E2_XBLQ == '1' .OR. SE2->E2_XBLQ == '6') ) },' SE2->E2_XAPROV = __cUserId .AND. (SE2->E2_XBLQ == "1" .OR. SE2->E2_XBLQ == "6") '))

				_lCont := .T.
				_cMDLTITLE := "Aprovação Titulos a Pagar"

			EndIf

			If !_lCont

				MsgAlert("Seu usuário não está vinculado a um aprovador."+CR+CR+" Solicite o cadastro junto ao Financeiro. ","STFIN004")

				SE2->(dbSetFilter({|| SE2->E2_USRINC = __cUserId  },' SE2->E2_USRINC = __cUserId ' ))

			EndIf
		EndIF

		//Legendas do Browse
		_oBrowse:AddLegend( "E2_XBLQ == ' '", "BR_VERDE"		, "Titulo Aprovado"  )
		_oBrowse:AddLegend( "E2_XBLQ == '1'", "BR_PINK"			, "Titulo Aguardando Aprovação"  )
		_oBrowse:AddLegend( "E2_XBLQ == '2'", "BR_VERMELHO"  	, "Titulo Rejeitado" )
		_oBrowse:AddLegend( "E2_XBLQ == '3'", "BR_VERDE_ESCURO"	, "Titulo Aprovado" )
		_oBrowse:AddLegend( "E2_XBLQ == '4'", "BR_MARRON_OCEAN" , "Titulo Aguardando Classificacão" )
		_oBrowse:AddLegend( "E2_XBLQ == '5'", "BR_AZUL_CLARO"  	, "Titulo Aguardando Aprovação do Financeiro" )
		_oBrowse:AddLegend( "E2_XBLQ == '6'", "BR_PRETO_0"  	, "Titulo Aguardando Aprovação Multas/Juros" )

		_oBrowse:SetDescription(_cMDLTITLE)
		_oBrowse:Activate()

	Else

		MsgAlert("Processo desativado."+CR+CR+" Verifique com o Admistrador do Sistema. ","STFIN004")

	EndIf

Return Nil
/*
Define o menu da rotina
*/
Static Function MenuDef()

	Local _aRotina 	:= {}
	Local _cQuery 	:= ""
	Local _cQuery1 	:= ""
	Local _cAlias	:= "QRY"
	Local _cAlias1	:= "QRY1"
	Local _lAprov	:= .F.

	//³ Carrega funcao Pergunte									     ³
	//If !lF050Auto
	SetKey (VK_F12,{|a,b| AcessaPerg("FIN050",.T.)})
	//Endif

	pergunte("FIN050",.F.)

	Private _UsrClas := GetMv('ST_USRCLAS',,'000000/000279')
	Private _AprFin  := GetMv('ST_APRFIN',,'000000/001036')
	Private _cGPEUSR := GetMv('ST_GPEUSR',,'000722')//Usuario aprovador do RH
	Private _cEICUSR := GetMv('ST_EICUSR',,'000722')//Usuario aprovador do SigaEic/Eec
	Private _cFISUSR := GetMv('ST_FISUSR',,'000722')//Usuario aprovador do Fiscal

	/*>> Everson Santana - 10/12/2018
	OPERATION
	1 - Pesquisa
	2 - Visualizar
	3 - Incluir
	4 - Alterar
	5 - Exclui
	<<*/

	ADD OPTION _aRotina TITLE "Pesquisar"   ACTION "PesqBrw"         	OPERATION 1 ACCESS 0
	ADD OPTION _aRotina TITLE "Visualizar"  ACTION "VIEWDEF.STFIN004" 	OPERATION 2 ACCESS 0

	If __cUserId $ _UsrClas //>>Validações dos Classificadores

		ADD OPTION _aRotina TITLE "Classificar" ACTION "VIEWDEF.STFIN004" 	OPERATION 4 ACCESS 0
		ADD OPTION _aRotina TITLE "Rejeitar"    ACTION "U_FIN004E()" 		OPERATION 4 ACCESS 0

	Else

		//>>Validações dos Solicitantes
		_cQuery := " SELECT * FROM "+RetSqlName("Z42")+" Z42 WHERE Z42_USER = '"+__cUserId+"' AND D_E_L_E_T_ = ' ' "

		If !Empty(Select(_cAlias))
			DbSelectArea(_cAlias)
			(_cAlias)->(dbCloseArea())
		Endif

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cAlias,.T.,.T.)

		dbSelectArea(_cAlias)
		(_cAlias)->(dbGoTop())

		While !EOF()

			If (_cAlias)->(Z42_USER) = __cUserId

				ADD OPTION _aRotina TITLE "Incluir" 	ACTION "VIEWDEF.STFIN004" 	OPERATION 3 ACCESS 0
				ADD OPTION _aRotina TITLE "Alterar" 	ACTION "VIEWDEF.STFIN004"	OPERATION 4 ACCESS 0
				ADD OPTION _aRotina TITLE "Excluir" 	ACTION "VIEWDEF.STFIN004"	OPERATION 5 ACCESS 0

			EndIf

			(_cAlias)->(DbSkip())

		End

		//>>Validações dos Aprovadores
		_cQuery1 := " SELECT * FROM "+RetSqlName("Z41")+" Z41 WHERE Z41_APRO = '"+__cUserId+"' AND D_E_L_E_T_ = ' ' "

		If !Empty(Select(_cAlias1))
			DbSelectArea(_cAlias1)
			(_cAlias1)->(dbCloseArea())
		Endif

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

		dbSelectArea(_cAlias1)
		(_cAlias1)->(dbGoTop())

		While !EOF()

			If (_cAlias1)->(Z41_APRO) = __cUserId //.OR. __cUserId $ _AprFin

				_lAprov := .t.

				//ADD OPTION _aRotina TITLE "Aprovar"    ACTION "U_FIN004A('3')" 		OPERATION 4 ACCESS 0
				//ADD OPTION _aRotina TITLE "Rejeitar"   ACTION "U_FIN004A('2')" 		OPERATION 4 ACCESS 0

			EndIf

			(_cAlias1)->(DbSkip())

		End
		//<<
	EndIf

	If _lAprov .OR. __cUserId $ _AprFin .OR. __cUserId $ _cGPEUSR .OR. __cUserId $_cEICUSR .OR. __cUserId $ _cFISUSR

		ADD OPTION _aRotina TITLE "Aprovar"    ACTION "U_FIN004A('3')" 		OPERATION 4 ACCESS 0
		ADD OPTION _aRotina TITLE "Rejeitar"   ACTION "U_FIN004A('2')" 		OPERATION 4 ACCESS 0
		ADD OPTION _aRotina TITLE "Incluir"    ACTION "VIEWDEF.STFIN004" 	OPERATION 3 ACCESS 0
		ADD OPTION _aRotina TITLE "Alterar"    ACTION "VIEWDEF.STFIN004"	OPERATION 4 ACCESS 0
		ADD OPTION _aRotina TITLE "Excluir"    ACTION "VIEWDEF.STFIN004"	OPERATION 5 ACCESS 0

	EndIf

	ADD OPTION _aRotina TITLE "Anexos"     ACTION "U_FIN004C(.T.)" 	    OPERATION 4 ACCESS 0

Return _aRotina
/*
Define o modelo da rotina
*/
Static Function ModelDef()
	Local _oStrutMaster	:= FWFormStruct(1, ALIASM, /**/, /*lViewUsado*/)
	Local _oModel 		:= MPFormModel():New(MDLDATA, /*bPreValidacao*/, /*bPost*/,/*bCommit*/, /*bCancel*/)
	Local _bPosVal		:= { |_oModel| u_FIN004D( _oModel ) }
	Local _bPreVal		:= { |_oModel| u_FIN004H( _oModel ) }
	Local _bCommit		:= { |_oModel| u_FIN004F( _oModel ) }
	Local _cQuery 		:= ""
	Local _cAlias		:= "QRY"
	Local _Xn			:= 0

	Private	aCampos 	:= {}
	Private cLote

	//Instancia do Objeto de Modelo de Dados Ponto de entrada
	//>> Ponto de Entrada - Everson Santana
	_oModel	:=	MpFormModel():New("PESTFIN004",_bPreVal /*Pre-Validacao*/,_bPosVal/*Pos-Validacao*/,_bCommit/*Commit*/,/*Cancel*/)
	//<<
	/*
	dbSelectArea("SX3")
	dbSetOrder(1)
	MsSeek("SE2")
	While !Eof() .And. SX3->X3_ARQUIVO == "SE2

	AADD(aCampos,{SX3->X3_TITULO,SX3->X3_DESCRIC,SX3->X3_CAMPO,SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_WHEN,SX3->X3_CBOX,SX3->X3_OBRIGAT,SX3->X3_RELACAO})	//11

	dbSkip()
	EndDo

	For _Xn := 1 to len(aCampos)

	_oStrutMaster:AddField( ;
	AllTrim(aCampos[_Xn][01]) , 		;// [01] C Titulo do campo X3_TITULO
	AllTrim('') , 						;// [02] C ToolTip do campo X3_DESCRIC
	aCampos[_Xn][03] , 					;// [03] C identificador (ID) do Field X3_CAMPO
	aCampos[_Xn][04] , 					;// [04] C Tipo do campo X3_TIPO
	aCampos[_Xn][05] , 					;// [05] N Tamanho do campo X3_TAMANHO
	aCampos[_Xn][06] , 					;// [06] N Decimal do campo X3_DECIMAL
	{|| aCampos[_Xn][07] },				;// [07] B Code-block de validação do campo X3_VALID
	{|| aCampos[_Xn][08] } , 			;// [08] B Code-block de validação When do campo X3_WHEN
	NIL , 								;// [09] A Lista de valores permitido do campo X3_CBOX
	.T. , 								;// [10] L Indica se o campo tem preenchimento obrigatório X3_OBRIGAT
	{||}, 								;// [11] B Code-block de inicializacao do campo X3_RELACAO
	NIL , 								;// [12] L Indica se trata de um campo chave X3_
	.T. , 								;// [13] L Indica se o campo pode receber valor em uma operação de update.
	.T.									;
	)

	Next
	*/
	_oStrutMaster:setProperty('*'	,MODEL_FIELD_WHEN,{|| .F.})

	If __cUserId $ _UsrClas
		_oStrutMaster:setProperty('E2_PREFIXO'	,MODEL_FIELD_WHEN,{|| .T.})   // Valdemir Rabelo 22/02/2022 - Chamado: 20220214003637
		_oStrutMaster:setProperty('E2_FORNECE'	,MODEL_FIELD_WHEN,{|| .F.})
		_oStrutMaster:setProperty('E2_VALOR'	,MODEL_FIELD_WHEN,{|| .F.})
		_oStrutMaster:setProperty('E2_VLCRUZ'	,MODEL_FIELD_WHEN,{|| .F.})
		_oStrutMaster:setProperty('E2_VENCTO'	,MODEL_FIELD_WHEN,{|| .F.})

		_oStrutMaster:setProperty('E2_TIPO'		,MODEL_FIELD_NOUPD,{|| .T.})
		_oStrutMaster:setProperty('E2_TIPO'		,MODEL_FIELD_WHEN,{|| .T.})
		_oStrutMaster:setProperty('E2_HIST'		,MODEL_FIELD_WHEN,{|| .T.})
		_oStrutMaster:setProperty('E2_VENCREA'	,MODEL_FIELD_WHEN,{|| .T.})
		_oStrutMaster:setProperty('E2_NATUREZ'	,MODEL_FIELD_WHEN,{|| .T.})
		//_oStrutMaster:setProperty('E2_RATEIO'	,MODEL_FIELD_WHEN,{|| F050RatDes(2)                                               })
		_oStrutMaster:setProperty('E2_CCD'		,MODEL_FIELD_WHEN,{|| .T.})
		_oStrutMaster:setProperty('E2_CCC'		,MODEL_FIELD_WHEN,{|| .T.})
	Else
		_cQuery := " SELECT * FROM "+RetSqlName("Z42")+" Z42 WHERE Z42_USER = '"+__cUserId+"' AND D_E_L_E_T_ = ' ' "

		If !Empty(Select(_cAlias))
			DbSelectArea(_cAlias)
			(_cAlias)->(dbCloseArea())
		Endif

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cAlias,.T.,.T.)

		dbSelectArea(_cAlias)
		(_cAlias)->(dbGoTop())

		If !Empty((_cAlias)->(Z42_USER))

			_oStrutMaster:setProperty('E2_HIST'		,MODEL_FIELD_WHEN,{|| .T.})
			_oStrutMaster:setProperty('E2_NATUREZ'	,MODEL_FIELD_WHEN,{|| .T.})
			_oStrutMaster:setProperty('E2_VENCREA'	,MODEL_FIELD_WHEN,{|| .T.})
			//_oStrutMaster:setProperty('E2_PREFIXO'	,MODEL_FIELD_WHEN,{|| VldPRFWhen(_oModel) })   // Valdemir Rabelo 22/02/2022 - Chamado: 20220214003637
			_oStrutMaster:setProperty('E2_PREFIXO'	,MODEL_FIELD_WHEN,{|| .T. })   // Valdemir Rabelo 22/02/2022 - Chamado: 20220214003637
			_oStrutMaster:setProperty('E2_NUM'		,MODEL_FIELD_WHEN,{|| .T.})
			_oStrutMaster:setProperty('E2_PARCELA'	,MODEL_FIELD_WHEN,{|| .T.})
			_oStrutMaster:setProperty('E2_TIPO'		,MODEL_FIELD_WHEN,{|| .T.})
			_oStrutMaster:setProperty('E2_FORNECE'	,MODEL_FIELD_WHEN,{|| .T.})
			_oStrutMaster:setProperty('E2_LOJA'		,MODEL_FIELD_WHEN,{|| .T.})
			_oStrutMaster:setProperty('E2_EMISSAO'	,MODEL_FIELD_WHEN,{|| .T.})
			_oStrutMaster:setProperty('E2_VENCTO'	,MODEL_FIELD_WHEN,{|| .T.})
			_oStrutMaster:setProperty('E2_VALOR'	,MODEL_FIELD_WHEN,{|| .T.})
			_oStrutMaster:setProperty('E2_CCD'		,MODEL_FIELD_WHEN,{|| .T.})
			_oStrutMaster:setProperty('E2_CCC'		,MODEL_FIELD_WHEN,{|| .T.})
			_oStrutMaster:setProperty('E2_RATEIO'	,MODEL_FIELD_WHEN,{|| .T.})

			//_oStrutMaster:setProperty('E2_RATEIO'	,MODEL_FIELD_VALID,{||IIf( Alltrim(_oModel:GetValue(MDLMASTER,"E2_RATEIO")) = "S", u_FIN004I() ,.T.)})
			_oStrutMaster:setProperty('E2_TIPO'		,MODEL_FIELD_VALID,{||Iif( Alltrim(_oModel:GetValue(MDLMASTER,"E2_TIPO")) $ "PA",u_FIN004G(),.T.)})
		EndIF
	EndIf

	_oModel:AddFields(MDLMASTER, /*cOwner*/, _oStrutMaster, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/)
	_oModel:GetModel(MDLMASTER):SetDescription("Aprovação")
	_oModel:SetDescription(MDLTITLE)
	_oModel:SetPrimaryKey({ "E2_FILIAL"})

Return _oModel
/*
Define a view da rotina
*/
Static Function ViewDef()

	Local _oStrutMaster 	:= FWFormStruct(2, ALIASM, /**/)
	Local _oModel   	 	:= FWLoadModel("STFIN004")
	Local _oView		 	:= FWFormView():New()

	_oView:SetModel(_oModel)
	_oView:AddField("VIEW_MASTER", _oStrutMaster, MDLMASTER)

	_oView:AddUserButton("Anexo","",{|_oView| U_FIN004C(.T.)})
	//_oView:AddUserButton("PA","",{|_oView| U_FIN004F(_oModel)})

Return _oView

/*

Rotina para atualizar o status do titulo

_nVar = 1;Bloqueado;2 Rejeitado,Vazio Liberado
aAprova = 1pos=recno
cObsRep = observações
cRefError = caso deu algum erro de processamento

*/

User Function FIN004A(_nVar, aAprova, cObsRep, cRefError)
	Local _nTipo  	:= ""
	Local _cEmail  	:= "Eduardo.santos@steck.com.br;jussara.silva@steck.com.br;lilia.lima@steck.com.br;eric.lopes@steck.com.br"
	Local _cCopia	:= UsrRetMail(SE2->E2_USRINC)
	Local _cMsgSave := ""
	Local _cMsgJur	:= ""
	Local lOk 		:= .F.
	Local _lTela    := .T.
	Local _nX       := 0

	private oDlg
	private oBtn1,oBtn2,oBtn3,oDlg
	private _Motivo := Space(60)

	If !IsInCallStack("U_ZAPVAT1P")
		aAprova := {}
		AADD(aAprova,{0})
	EndIf

	For _nX:=1 To Len(aAprova)

		If IsInCallStack("U_ZAPVAT1P")
			_lTela := .F.
			SE2->(DbGoTo(aAprova[_nX][1]))
			_nVar := cValToChar(_nVar)
		EndIf

		If _nVar == "2"

			If _lTela

				DEFINE MSDIALOG oDlg FROM 50,100 TO 200,630 TITLE "Rejeitar Pagamento" PIXEL
				@ 06,020 SAY "Informe o Motivo da Rejeição:" SIZE 122,9 Of oDlg PIXEL
				@ 30,008 SAY "Motivo:" SIZE 22,9 Of oDlg PIXEL
				@ 30,040 MSGET _Motivo SIZE 220,10 Of oDlg PIXEL
				@ 50,170 BUTTON oBut1 PROMPT "&Ok"       SIZE 44,12 Of oDlg PIXEl Action (lOk:=.T.,oDlg:End())
				@ 50,220 BUTTON oBut2 PROMPT "&Cancela"  SIZE 44,12 Of oDlg PIXEl Action (lOk:=.F.,oDlg:End())

				ACTIVATE MSDIALOG oDlg

				If lOk
					If Empty(_Motivo)
						Help(NIL, NIL, "HELP", NIL, 'Campo de preenchimento Obrigatorio..', 1, 0, NIL, NIL, NIL, NIL, NIL, {'Informe o Motivo da Rejeição'})
						_nTipo := ""
					Else
						_nTipo := "2" //Rejeitado
					EndIf
				EndIf

			Else

				lOk:=.T.
				_Motivo := cObsRep
				_nTipo := "2" //Rejeitado

			EndIf

		ElseIf _nVar == "3"
			If AllTrim(SE2->E2_PREFIXO) $ GetMv("STFIN00401",,"GPE") //Não vai para classificação, aprova direto (20230215001853)
				_nTipo := "3" //Aprovado
			Else
				_nTipo := "4" //Enviar para Classificação
			EndIf
		EndIf

		If !Empty(_nTipo)
			RecLock("SE2", .F.)

			If Alltrim(SE2->E2_TIPO) $ "PA" .AND. !SE2->E2_XBLQ $ "5" .and. !_nTipo $ "2"
				SE2->E2_XBLQ := "5" //Se for PA apos aprovação do responsavel envia para aprovação do financeiro.
			Else
				If  SE2->E2_XBLQ == "6" //Se for bloqueio de Multas e Juros não será enviado para Classificação.
					SE2->E2_XBLQ := " "
					_cMsgJur	 := "(Multas/Juros)"
				Else
					If Alltrim(SE2->E2_ORIGEM) $ "GPEM670#SIGAEIC#SIGAEEC#FISA001#MATA952#MATA953#MATA996#STGERGUI" // Não envia para Classificação
						SE2->E2_XBLQ := " "
						_cMsgJur	 := "(Integração)"
					Else
						SE2->E2_XBLQ := _nTipo
						If AllTrim(SE2->E2_PREFIXO) $ GetMv("STFIN00401",,"GPE") //Não vai para classificação, aprova direto (20230215001853)
							SE2->E2_XBLQ := ""
						EndIf
					EndIf
				EndIF
			EndIf

			If _nTipo == "2"
				_cMsgSave += "===================================" +CR
				_cMsgSave += "Titulo Rejeitado por. " +CR
				_cMsgSave += "Usuário: "+cUserName+CR
				_cMsgSave += "Em: "+DTOC(DDATABASE)+" "+TIME()+CR
				_cMsgSave += "Motivo: "+_Motivo

				If SE2->E2_XBLQ == "6" //Bloqueado por Multas/Juros
					_cMsgSave += "Multas: "+TransForm(SE2->E2_XMULTA,"@E 999,999,999.99")+" Juros: "+Transform(SE2->E2_XJUROS,"@E 999,999,999.99")+" Tarifa: "+Transform(SE2->E2_XTARIFA,"@E 999,999,999.99")

					SE2->E2_XJUROS 	:= 0
					SE2->E2_XTARIFA	:= 0
					SE2->E2_XMULTA 	:= 0
					SE2->E2_ACRESC	:= 0
					SE2->E2_XBLQ 	:= "1"
				EndIf

				SE2->E2_XLOG  		:= _cMsgSave+ CR +SE2->E2_XLOG

				FIN004B("Titulo Rejeitado para Pagamento.", _cEmail, _cCopia, _Motivo, cUserName )

			ElseIf _nTipo == "4"

				If Alltrim(SE2->E2_TIPO) $ "PA" .AND.  SE2->E2_XBLQ $ "5" .and. !_nTipo $ "2"

					If _lTela
						MsgAlert("Titulo Aprovado para Pagamento."+CR+CR+"Enviado para Aprovação do Financeiro.","Atenção")
					EndIf

					_cMsgSave += "===================================" +CR
					_cMsgSave += "Titulo Aprovado por. " +CR
					_cMsgSave += "Usuário: "+cUserName+CR
					_cMsgSave += "Enviado para Aprovação do Financeiro. " +CR
					_cMsgSave += "Em: "+DTOC(DDATABASE)+" "+TIME()+CR

					SE2->E2_XLOG  := _cMsgSave + CR +SE2->E2_XLOG

					FIN004B("Titulo Aguardando Aprovação do Financeiro", _cEmail, _cCopia, "", cUserName)

				Else

					If _lTela
						MsgAlert("Titulo Aprovado para Pagamento. "+_cMsgJur,"Atenção")
					EndIf

					_cMsgSave += "===================================" +CR
					_cMsgSave += "Titulo Aprovado por. "+_cMsgJur +CR
					_cMsgSave += "Usuário: "+cUserName+CR
					_cMsgSave += "Em: "+DTOC(DDATABASE)+" "+TIME()+CR

					SE2->E2_XLOG  := _cMsgSave + CR +SE2->E2_XLOG

					FIN004B("Titulo Aprovado para Pagamento."+_cMsgJur, _cEmail, _cCopia, "", cUserName )

					_cEmail += ";eric.lopes@se.com; adriana.toni@se.com;giovanna.santos@se.com;eduardo.brambilla@se.com;marcelo.avelino@steck.com.br;juliete.vieira@steck.com.br;eric.lopes@steck.com.br" //Ticket 20210519008214 //Ticket 20210519008213

					FIN004B("Titulo Aguardando Classificacao", _cEmail, _cCopia, "", cUserName)

				EndIf
			EndIF

			SE2->(MsUnlock())
			SE2->(DbCommit())

		EndIf

	Next

Return

/*
Rotina para enviar e-mail

*/

Static Function FIN004B(_cAssunto,_cEmail,_cCopia,_Motivo,cUserName )
	Local aArea 	:= GetArea()
	Local _cFrom   	:= "protheus@steck.com.br"
	Local cFuncSent	:= "FIN004B"
	Local i        	:= 0
	Local cArq     	:= ""
	Local cMsg     	:= ""
	Local _nLin
	Local cAttach  	:= ' '
	Local _cEmaSup 	:= ' '
	Local _nCam    	:= 0
	Local _aMsg    	:={}

	Aadd( _aMsg , { "Numero: "          , SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA } )
	Aadd( _aMsg , { "Nome: "    		, SE2->E2_NOMFOR } )
	Aadd( _aMsg , { "Valor: "    		, transform((SE2->E2_VALOR)	,"@E 999,999,999.99")  } )
	Aadd( _aMsg , { "Emissao: "    		, dtoc(SE2->E2_EMISSAO) } )
	Aadd( _aMsg , { "Vencto Real : "    , dtoc(SE2->E2_VENCREA) } )
	Aadd( _aMsg , { "Data: "    		, dtoc(dDataBase) } )
	Aadd( _aMsg , { "Hora: "    		, time() } )
	Aadd( _aMsg , { "Incluido por: "    , USRRETNAME(SE2->E2_USRINC) } )
	Aadd( _aMsg , { "Historico: "    	, Alltrim(SE2->E2_HIST) } )

	If !Empty(_Motivo)
		Aadd( _aMsg , { "Titulo Rejeitado por: ", cUserName } )
		Aadd( _aMsg , { "Motivo: "    			, _Motivo } )
	Else
		Aadd( _aMsg , { "Titulo Aprovado por: ", cUserName } )
	EndIf

	If ( Type("l410Auto") == "U" .OR. !l410Auto )

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Definicao do cabecalho do email                                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cMsg := ""
		cMsg += '<html>'
		cMsg += '<head>'
		cMsg += '<title>' + _cAssunto + " - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title>'
		cMsg += '</head>'
		cMsg += '<body>'
		cMsg += '<p>ATENÇÃO:"
		cMsg += '<br><br>'
		cMsg += '-É de responsabilidade do(a) solicitante acompanhar a aprovação do Gestor para que o título fique disponível para o pagamento em tempo hábil.'
		cMsg += '<br><br>'
		cMsg += 'Despesas Comex / RH:    Os títulos aprovados após as 12:00hs do dia do vencimento serão reprogramados automaticamente para o próximo dia útil.'
		cMsg += '<br><br>'
		cMsg += 'Fornecedores Nacionais:   Os títulos aprovados após as 12:00hs do dia do vencimento serão reprogramados automaticamente para a próxima data do calendário de pagamentos Steck (dia 05, 15 ou 25).'
		cMsg += '</p>'
		cMsg += '<br><br>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
		cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>' + _cAssunto +" - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+ '</FONT> </Caption>'

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Definicao do texto/detalhe do email                                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		For _nLin := 1 to Len(_aMsg)
			If (_nLin/2) == Int( _nLin/2 )
				cMsg += '<TR BgColor=#B0E2FF>'
			Else
				cMsg += '<TR BgColor=#FFFFFF>'
			EndIf

			cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></B></TD>'
			cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></TD>'
		Next

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Definicao do rodape do email                                                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		cMsg += '</Table>'
		cMsg += '<P>'
		cMsg += '<Table align="center">'
		cMsg += '<tr>'
		cMsg += '<td colspan="10" align="center"><font color="red" size="3">Mensagem enviada automaticamente pelo sistema PROTHEUS - <font color="red" size="1">('+cFuncSent+')</td>'
		cMsg += '</tr>'
		cMsg += '</Table>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		cMsg += '</body>'
		cMsg += '</html>'

		U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg)

	EndIf
	RestArea(aArea)

Return()


User Function FIN004C(_lT)

	//ÃšÃ„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Â¿
	//Â³Declaração das Variáveis
	//Ã€Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã™
	Local aArea       := GetArea()
	Local aArea1      := SE2->(GetArea())

	Local n           := 0
	Local lSaida      := .f.
	Local nOpcao      := 0
	Local oDxlg
	Local _cAne01     := ''
	Local _cAne02     := ''
	Local _cAne03     := ''
	Local _cAne04     := ''
	Local _cAne05     := ''
	Local _nLin       := 000
	Local cSolicit	  := Alltrim(SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA)
	Local _Indice	  := SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA
	Private _cPath      := GetSrvProfString("RootPath","")
	Private _cStartPath := "\arquivos\ContasPagar\"
	Private _cEmp       := ""+cEmpAnt+"\"
	Private _cFil       := ""+SE2->E2_FILIAL+"\"
	Private _cNUm       := ""+cSolicit+"\"
	Private _cServerDir   := ''
	Default _lT := .f.
	If !_lT
		If Inclui
			MsgInfo("Anexo so pode ser incluido apos a Gravação do Titulo...!!!!")
			Return()
		EndIf
	EndIf
	//ÃšÃ„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Â¿
	//Â³ Criação das pastas para salvar os anexos das SolicitaÃ§Ãµes de Compras no Servidor
	//Ã€Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã™
	_cServerDir += (_cStartPath)
	If MakeDir (_cServerDir) == 0
		MakeDir(_cServerDir)
	Endif

	_cServerDir += _cEmp
	If MakeDir (_cServerDir) == 0
		MakeDir(_cServerDir)
	Endif

	_cServerDir += _cFil
	If MakeDir (_cServerDir) == 0
		MakeDir(_cServerDir)
	Endif

	_cServerDir += _cNUm
	If MakeDir (_cServerDir) == 0
		MakeDir(_cServerDir)
	Endif

	If ExistDir(_cServerDir)

		If Len(Directory(_cServerDir+Strzero(1,6)+".mzp")) = 1
			_cAne01 := Strzero(1,6)+".mzp"
		Else
			_cAne01 := space(90)
		Endif

		If Len(Directory(_cServerDir+Strzero(2,6)+".mzp")) = 1
			_cAne02 := Strzero(2,6)+".mzp"
		Else
			_cAne02 := space(90)
		Endif

		If Len(Directory(_cServerDir+Strzero(3,6)+".mzp")) = 1
			_cAne03 := Strzero(3,6)+".mzp"
		Else
			_cAne03 := space(90)
		Endif

		If Len(Directory(_cServerDir+Strzero(4,6)+".mzp")) = 1
			_cAne04 := Strzero(4,6)+".mzp"
		Else
			_cAne04 := space(90)
		Endif

		If Len(Directory(_cServerDir+Strzero(5,6)+".mzp")) = 1
			_cAne05 := Strzero(5,6)+".mzp"
		Else
			_cAne05 := space(90)
		Endif

		DbSelectArea("SE2")
		SE2->(DbSetOrder(1))
		If SE2->(DbSeek(xFilial("SE2")+_Indice))
			dDtEmiss   := SE2->E2_EMISSAO
			cNameSolic := USRRETNAME(__cUserId)

			Do While !lSaida
				nOpcao := 0

				Define msDialog oDxlg Title "Selecione os Anexos " From 10,10 TO 450,600 Pixel
				_nLin := 005
				@ _nLin,010 say "Filial" COLOR CLR_BLACK  Of oDxlg Pixel
				@ _nLin,040 get xFilial("SE2") when .f. size 050,08  Of oDxlg Pixel

				@ _nLin,110 say "Data SC" COLOR CLR_BLACK   Of oDxlg Pixel
				@ _nLin,140 get  dDtEmiss  when .f. size 090,08  Of oDxlg Pixel

				_nLin := _nLin + 10
				@ _nLin,010 say "NÂº SC" COLOR CLR_BLACK    Of oDxlg Pixel
				@ _nLin,040 get cSolicit  when .f. size 050,08  Of oDxlg Pixel

				@ _nLin,110 say "Solicitante" COLOR CLR_BLACK   Of oDxlg Pixel
				@ _nLin,140 get  cNameSolic  when .f. size 090,08  Of oDxlg Pixel

				_nLin := _nLin + 20
				@ _nLin,010 Say "Anexo - 01"   COLOR CLR_HBLUE  Of oDxlg Pixel
				_nLin := _nLin + 10
				@ _nLin,010 get _cAne01     when .f.   size 165,08  Of oDxlg Pixel
				@ _nLin,180 BUTTON 'Anexar'  SIZE 30,10 ACTION (_cAne01:=SaveAnexo(1,_cAne01,_Indice)) Of oDxlg Pixel
				@ _nLin,210 BUTTON 'Deletar' SIZE 30,10 ACTION (_cAne01:=DelAnexo (1,_cAne01,_Indice)) Of oDxlg Pixel
				@ _nLin,240 BUTTON 'Abrir'   SIZE 30,10 ACTION (_cAne01:=OpenAnexo(1,_cAne01,cSolicit)) Of oDxlg Pixel

				_nLin := _nLin + 20
				@ _nLin,010 Say "Anexo - 02"   COLOR CLR_HBLUE  Of oDxlg Pixel
				_nLin := _nLin + 10
				@ _nLin,010 get _cAne02     when .f.   size 165,08  Of oDxlg Pixel
				@ _nLin,180 BUTTON 'Anexar'  SIZE 30,10 ACTION (_cAne02:=SaveAnexo(2,_cAne02,_Indice)) Of oDxlg Pixel
				@ _nLin,210 BUTTON 'Deletar' SIZE 30,10 ACTION (_cAne02:=DelAnexo (2,_cAne02,_Indice)) Of oDxlg Pixel
				@ _nLin,240 BUTTON 'Abrir'   SIZE 30,10 ACTION (_cAne02:=OpenAnexo(2,_cAne02,_Indice)) Of oDxlg Pixel

				_nLin := _nLin + 20
				@ _nLin,010 Say "Anexo - 03"   COLOR CLR_HBLUE  Of oDxlg Pixel
				_nLin := _nLin + 10
				@ _nLin,010 get _cAne03     when .f.   size 165,08  Of oDxlg Pixel
				@ _nLin,180 BUTTON 'Anexar'  SIZE 30,10 ACTION (_cAne03:=SaveAnexo(3,_cAne03,_Indice)) Of oDxlg Pixel
				@ _nLin,210 BUTTON 'Deletar' SIZE 30,10 ACTION (_cAne03:=DelAnexo (3,_cAne03,_Indice)) Of oDxlg Pixel
				@ _nLin,240 BUTTON 'Abrir'   SIZE 30,10 ACTION (_cAne03:=OpenAnexo(3,_cAne03,_Indice)) Of oDxlg Pixel

				_nLin := _nLin + 20
				@ _nLin,010 Say "Anexo - 04"   COLOR CLR_HBLUE  Of oDxlg Pixel
				_nLin := _nLin + 10
				@ _nLin,010 get _cAne04     when .f.   size 165,08  Of oDxlg Pixel
				@ _nLin,180 BUTTON 'Anexar'  SIZE 30,10 ACTION (_cAne04:=SaveAnexo(4,_cAne04,_Indice)) Of oDxlg Pixel
				@ _nLin,210 BUTTON 'Deletar' SIZE 30,10 ACTION (_cAne04:=DelAnexo (4,_cAne04,_Indice)) Of oDxlg Pixel
				@ _nLin,240 BUTTON 'Abrir'   SIZE 30,10 ACTION (_cAne04:=OpenAnexo(4,_cAne04,_Indice)) Of oDxlg Pixel

				_nLin := _nLin + 20
				@ _nLin,010 Say "Anexo - 05"   COLOR CLR_HBLUE  Of oDxlg Pixel
				_nLin := _nLin + 10
				@ _nLin,010 get _cAne05     when .f.   size 165,08  Of oDxlg Pixel
				@ _nLin,180 BUTTON 'Anexar'  SIZE 30,10 ACTION (_cAne05:=SaveAnexo(5,_cAne05,_Indice)) Of oDxlg Pixel
				@ _nLin,210 BUTTON 'Deletar' SIZE 30,10 ACTION (_cAne05:=DelAnexo (5,_cAne05,_Indice)) Of oDxlg Pixel
				@ _nLin,240 BUTTON 'Abrir'   SIZE 30,10 ACTION (_cAne05:=OpenAnexo(5,_cAne05,_Indice)) Of oDxlg Pixel

				_nLin := _nLin + 20

				DEFINE SBUTTON FROM _nLin,130 TYPE 1 ACTION (lSaida:=.T.,nOpcao:=1,oDxlg:End()) ENABLE OF oDxlg
				//DEFINE SBUTTON FROM 200,160 TYPE 2 ACTION (lSaida:=.T.,nOpcao:=2,oDxlg:End()) ENABLE OF oDxlg

				Activate dialog oDxlg centered

			EndDo

		EndIf

	Endif

	RestArea(aArea1)
	RestArea(aArea)

Return()



Static Function SaveAnexo(_nSave,_cFile,cSolicit)

	Local _cSave := ''
	Local _lRet     := .T.
	Local _cLocArq  := ''
	Local _cDir     := ''
	Local _cArq     := ''
	Local cExtensao := ''
	Local nTamOrig  := ''
	Local nMB       := 1024
	Local nTamMax   := 2
	Local cMascara  := "Todos os arquivos"
	Local cTitulo   := "Escolha o arquivo"
	Local nMascpad  := 0
	Local cDirini   := "c:\"
	Local lSalvar   := .T. /*.F. = Salva || .T. = Abre*/
	Local lArvore   := .F. /*.T. = apresenta o árvore do servidor || .F. = não apresenta*/
	Local _cMsgSave := ""
	Local aArea1    := GetArea()
	Local aArea2    := SE2->(GetArea())

	//Local nOpcoes   := GETF_LOCALHARD
	// OpÃ§Ãµes permitidas
	//GETF_NOCHANGEDIR    // Impede que o diretorio definido seja mudado
	//GETF_LOCALFLOPPY    // Mostra arquivos do drive de Disquete
	//GETF_LOCALHARD      // Mostra arquivos dos Drives locais como HD e CD/DVD
	//GETF_NETWORKDRIVE   // Mostra pastas compartilhadas da rede
	//GETF_RETDIRECTORY   // Retorna apenas o diretÃ³rio e não o nome do arquivo

	_cLocArq  := cGetFile( cMascara, cTitulo, nMascpad, cDirIni, lSalvar,, lArvore)

	If !(Empty(_cLocArq))
		nTamOrig := Directory(_cLocArq)[1,2]
		If (nTamOrig/nMB) > (nMB*nTamMax)
			Aviso("Tamanho do Arquivo Superior ao Permitido"; //01 - cTitulo - TÃ­tulo da janela
			,"O Arquivo '"+_cArq+"' tem que ter tamanho máximo de "+cValtoChar(nTamMax)+"MB."+ Chr(10) + Chr(13) +;
				CHR(10)+CHR(13)+;
				"Ação não permitida.",; //02 - cMsg - Texto a ser apresentado na janela.
			{"OK"};                          //03 - aBotoes - Array com as opÃ§Ãµes dos botÃµes.
			,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
			,;                               //05 - cText - Titulo da Descrição (Dentro da Janela)
			,;                               //06 - nRotAutDefault - Opção padrão usada pela rotina automática
			,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
			,.F.;                            //08 - lEdit - Determina se permite a edição do campo memo
			,;                               //09 - nTimer - Tempo para exibição da mensagem em segundos.
			,;                               //10 - nOpcPadrao - Opção padrão apresentada na mensagem.
			)
			Return
		EndIf

		If Len(Directory(_cServerDir+Strzero(_nSave,6)+".mzp")) = 1
			_lRet := MsgYesNo("Já existe um arquivo anexado."+ Chr(10) + Chr(13) +" Deseja sobrepor o arquivo existente ???","Atenção")
		Endif

		If _lRet

			_cLocArq  := Alltrim(_cLocArq)
			_cDir     := SUBSTR(_cLocArq, 1                      ,RAT( "\"   , _cLocArq ))
			_cArq     := SUBSTR(_cLocArq, RAT( "\"   , _cLocArq ),Len(_cLocArq))
			_cArq     := StrTran(_cArq,"\","")
			cExtensao := SUBSTR(_cLocArq,Rat(".",_cLocArq),Len(_cLocArq))

			If At(".",cExtensao) == 1

				_cSave := Strzero(_nSave,6)

				//ÃšÃ„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„?Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Â¿
				//Â³ Copio o arquivo original da máquina do usuário para o servidor
				//Ã€Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã™
				lSucess   := __CopyFile(_cLocArq,_cServerDir+_cSave+cExtensao)

				If lSucess

					//ÃšÃ„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Â¿
					//Â³ Realizo a compactação do arquivo para a extensão .mzp
					//Ã€Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã™
					MsCompress((_cServerDir+_cSave+cExtensao),(_cServerDir+_cSave+".mzp"))

					//ÃšÃ„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Â¿
					//Â³ Apago o arquivo original do servidor
					//Ã€Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã™
					Ferase( _cServerDir+_cSave+cExtensao)
					Aviso("Anexar Arquivo"; //01 - cTitulo - TÃ­tulo da janela
					,"O Arquivo '"+_cArq+"' foi anexado com sucesso.",; //02 - cMsg - Texto a ser apresentado na janela.
					{"OK"};                          //03 - aBotoes - Array com as opÃ§Ãµes dos botÃµes.
					,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
					,;                               //05 - cText - Titulo da Descrição (Dentro da Janela)
					,;                               //06 - nRotAutDefault - Opção padrão usada pela rotina automática
					,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
					,.F.;                            //08 - lEdit - Determina se permite a edição do campo memo
					,;                               //09 - nTimer - Tempo para exibição da mensagem em segundos.
					,;                               //10 - nOpcPadrao - Opção padrão apresentada na mensagem.
					)
					_cSave += ".mzp"
					_cMsgSave += "===================================" +CHR(13)+CHR(10)
					_cMsgSave += "Documento "+Alltrim(_cArq)+" anexado com sucesso por: " +CHR(13)+CHR(10)
					_cMsgSave += "Usuário: "+cUserName+CHR(13)+CHR(10)
					_cMsgSave += "Em: "+DTOC(DDATABASE)+" "+TIME()+CHR(13)+CHR(10)
					dbSelectArea("SE2")
					SE2->(dbGoTop())
					While SE2->(!EOF()) .And. cSolicit = SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA) .And. SE2->E2_FILIAL = xfilial("SE2")
						RecLock("SE2", .F.)
						SE2->E2_XLOG    :=  _cMsgSave   + CHR(13)+ CHR(10) + SE2->E2_XLOG
						SE2->(MsUnlock())
						SE2->( dbSkip() )
					End
				Else
					_cSave := ''
					Aviso("Problema ao Anexar Arquivo"; //01 - cTitulo - TÃ­tulo da janela
					,"O Arquivo '"+_cArq+"' não foi anexado."+ Chr(10) + Chr(13) +;
						CHR(10)+CHR(13)+;
						"Favor verificar com o TI.",; //02 - cMsg - Texto a ser apresentado na janela.
					{"OK"};                          //03 - aBotoes - Array com as opÃ§Ãµes dos botÃµes.
					,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
					,;                               //05 - cText - Titulo da Descrição (Dentro da Janela)
					,;                               //06 - nRotAutDefault - Opção padrão usada pela rotina automática
					,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
					,.F.;                            //08 - lEdit - Determina se permite a edição do campo memo
					,;                               //09 - nTimer - Tempo para exibição da mensagem em segundos.
					,;                               //10 - nOpcPadrao - Opção padrão apresentada na mensagem.
					)
				EndIf
			Else
				Aviso("Problema com Extensão do Anexo"; //01 - cTitulo - TÃ­tulo da janela
				,"A Extensão "+cExtensao+" Ã© inválida para anexar junto ao reembolso."+ Chr(10) + Chr(13) +;
					CHR(10)+CHR(13)+;
					"Ação não permitida.",; //02 - cMsg - Texto a ser apresentado na janela.
				{"OK"};                          //03 - aBotoes - Array com as opÃ§Ãµes dos botÃµes.
				,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
				,;                               //05 - cText - Titulo da Descrição (Dentro da Janela)
				,;                               //06 - nRotAutDefault - Opção padrão usada pela rotina automática
				,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
				,.F.;                            //08 - lEdit - Determina se permite a edição do campo memo
				,;                               //09 - nTimer - Tempo para exibição da mensagem em segundos.
				,;                               //10 - nOpcPadrao - Opção padrão apresentada na mensagem.
				)
			Endif
		Else
			_cSave := _cFile
		Endif

	Else
		_cSave := _cFile
		Aviso("Anexar Arquivo"; //01 - cTitulo - TÃ­tulo da janela
		,"Nenhum Arquivo foi selecionado para ser anexado.",; //02 - cMsg - Texto a ser apresentado na janela.
		{"OK"};                          //03 - aBotoes - Array com as opÃ§Ãµes dos botÃµes.
		,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
		,;                               //05 - cText - Titulo da Descrição (Dentro da Janela)
		,;                               //06 - nRotAutDefault - Opção padrão usada pela rotina automática
		,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
		,.F.;                            //08 - lEdit - Determina se permite a edição do campo memo
		,;                               //09 - nTimer - Tempo para exibição da mensagem em segundos.
		,;                               //10 - nOpcPadrao - Opção padrão apresentada na mensagem.
		)
	Endif

	RestArea(aArea2)
	RestArea(aArea1)

Return(_cSave)

Static Function DelAnexo(_nDel,_cFile,cSolicit)

	Local _cDelete := ''
	Local _lRet    := .T.
	Local _cMsgDel := ""
	Local aArea1   := GetArea()
	Local aArea2   := SE2->(GetArea())

	If Len(Directory(_cServerDir+_cFile)) = 1
		_lRet := MsgYesNo("Deseja deletar o Arquivo ??? "+ Chr(10) + Chr(13) +" Uma vez confirmada essa ação o arquivo não ficará mais disponÃ­vel para consulta.","Atenção")
	Else
		_lRet := .F.
		Aviso("Deletar Anexo"; //01 - cTitulo - TÃ­tulo da janela
		,"Não existe nenhum Arquivo para ser deletado."+ Chr(10) + Chr(13) +;
			CHR(10)+CHR(13)+;
			"Ação não permitida.",; //02 - cMsg - Texto a ser apresentado na janela.
		{"OK"};                          //03 - aBotoes - Array com as opÃ§Ãµes dos botÃµes.
		,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
		,;                               //05 - cText - Titulo da Descrição (Dentro da Janela)
		,;                               //06 - nRotAutDefault - Opção padrão usada pela rotina automática
		,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
		,.F.;                            //08 - lEdit - Determina se permite a edição do campo memo
		,;                               //09 - nTimer - Tempo para exibição da mensagem em segundos.
		,;                               //10 - nOpcPadrao - Opção padrão apresentada na mensagem.
		)
	Endif

	If _lRet
		Ferase( _cServerDir+_cFile)
		_cDelete := ''
		_cMsgDel += "===================================" +CHR(13)+CHR(10)
		_cMsgDel += "Documento "+Alltrim(_cFile)+" deletado com sucesso por: " +CHR(13)+CHR(10)
		_cMsgDel += "Usuário: "+cUserName+CHR(13)+CHR(10)
		_cMsgDel += "Em: "+DTOC(DDATABASE)+" "+TIME()+CHR(13)+CHR(10)
		dbSelectArea("SE2")
		SE2->(dbGoTop())
		While SE2->(!EOF()) .And. cSolicit = SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA) .And. SE2->E2_FILIAL = xfilial("SE2")
			RecLock("SE2", .F.)
			SE2->E2_XLOG   :=  _cMsgDel   + CHR(13)+ CHR(10) + SE2->E2_XLOG
			SE2->(MsUnlock())
			SE2->( dbSkip() )
		End
	Else
		_cDelete := _cFile
	Endif

	RestArea(aArea2)
	RestArea(aArea1)

Return (_cDelete)

Static Function OpenAnexo(_nOpen,_cFile,cSolicit)

	Local _cOpen      := ''
	Local cZipFile    := ''
	Local _cSaveArq   := "C:\ARQUIVOS_PROTHEUS\"
	Local _cLocalDir  := ''
	Local _cStartPath := "arquivos\"
	Local _cStartPath1 := "ContasPagar\"
	Local _lUnzip     := .T.

	//ÃšÃ„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Â¿
	//Â³ Criação das pastas para salvar os anexos das SolicitaÃ§Ãµes de Compras na máquina Local do usuário
	//Ã€Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã™
	_cLocalDir += (_cSaveArq)
	If MakeDir (_cLocalDir) == 0
		MakeDir(_cLocalDir)
	Endif

	_cLocalDir += (_cStartPath)
	If MakeDir (_cLocalDir) == 0
		MakeDir(_cLocalDir)
	Endif

	_cLocalDir += (_cStartPath1)
	If MakeDir (_cLocalDir) == 0
		MakeDir(_cLocalDir)
	Endif

	_cLocalDir += _cEmp
	If MakeDir (_cLocalDir) == 0
		MakeDir(_cLocalDir)
	Endif

	_cLocalDir += _cFil
	If MakeDir (_cLocalDir) == 0
		MakeDir(_cLocalDir)
	Endif

	_cLocalDir += _cNUm
	If MakeDir (_cLocalDir) == 0
		MakeDir(_cLocalDir)
	Endif

	If ExistDir(_cLocalDir)
		_cOpen   := Strzero(_nOpen,6)+".mzp"
		cZipFile := _cServerDir+_cOpen
		If Len(Directory(cZipFile)) = 1
			CpyS2T  ( cZipFile , _cLocalDir, .T. )
			_lUnzip := MsDecomp( _cLocalDir+_cOpen , _cLocalDir )
			If _lUnzip
				Ferase  ( _cLocalDir+_cOpen)
				ShellExecute("open", _cLocalDir, "", "", 1)
			Else
				Aviso("Erro para Descompactar Anexo"; //01 - cTitulo - TÃ­tulo da janela
				,"Houve erro para Descompactar o Anexo."+ Chr(10) + Chr(13) +;
					CHR(10)+CHR(13)+;
					"Favor entrar em contato com o TI.",; //02 - cMsg - Texto a ser apresentado na janela.
				{"OK"};                          //03 - aBotoes - Array com as opÃ§Ãµes dos botÃµes.
				,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
				,;                               //05 - cText - Titulo da Descrição (Dentro da Janela)
				,;                               //06 - nRotAutDefault - Opção padrão usada pela rotina automática
				,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
				,.F.;                            //08 - lEdit - Determina se permite a edição do campo memo
				,;                               //09 - nTimer - Tempo para exibição da mensagem em segundos.
				,;                               //10 - nOpcPadrao - Opção padrão apresentada na mensagem.
				)
			Endif
		Else
			_cOpen  := _cFile
			Aviso("Anexo inválido"; //01 - cTitulo - TÃ­tulo da janela
			,"Não existe nenhum anexo no Protheus para ser aberto."+ Chr(10) + Chr(13) +;
				CHR(10)+CHR(13)+;
				"Ação não permitida.",; //02 - cMsg - Texto a ser apresentado na janela.
			{"OK"};                          //03 - aBotoes - Array com as opÃ§Ãµes dos botÃµes.
			,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
			,;                               //05 - cText - Titulo da Descrição (Dentro da Janela)
			,;                               //06 - nRotAutDefault - Opção padrão usada pela rotina automática
			,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
			,.F.;                            //08 - lEdit - Determina se permite a edição do campo memo
			,;                               //09 - nTimer - Tempo para exibição da mensagem em segundos.
			,;                               //10 - nOpcPadrao - Opção padrão apresentada na mensagem.
			)
		Endif
	Else
		Aviso("Erro ao Salvar Anexo"; //01 - cTitulo - TÃ­tulo da janela
		,"Houve erro ao Salvar o Anexo."+ Chr(10) + Chr(13) +;
			CHR(10)+CHR(13)+;
			"Favor entrar em contato com o TI.",; //02 - cMsg - Texto a ser apresentado na janela.
		{"OK"};                          //03 - aBotoes - Array com as opÃ§Ãµes dos botÃµes.
		,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
		,;                               //05 - cText - Titulo da Descrição (Dentro da Janela)
		,;                               //06 - nRotAutDefault - Opção padrão usada pela rotina automática
		,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
		,.F.;                            //08 - lEdit - Determina se permite a edição do campo memo
		,;                               //09 - nTimer - Tempo para exibição da mensagem em segundos.
		,;                               //10 - nOpcPadrao - Opção padrão apresentada na mensagem.
		)
	Endif

Return (_cOpen)

User Function FIN004D(_oModel)
	Local nOperation	:= _oModel:GetOperation()
	Local lRet 			:= .T.
	Local _cMsgSave 	:= ""
	Local cMsg			:= ""
	Local _nLin
	Local cAttach  		:= ' '
	Local _cEmaSup 		:= ' '
	Local _aMsg			:= {}
	Local _lClas		:= .F.
	Local _cAssunto 	:= "Solicitação de Aprovação Contas a Pagar"
	Local _cEmail  		:= UsrRetMail(_oModel:GetValue(MDLMASTER,"E2_XAPROV"))
	Local _cCopia		:= UsrRetMail(SE2->E2_USRINC)
	Local cFuncSent		:= "FIN004D"
	Local _cQuery		:= ""
	Local _cAlias		:= "QRY"
	Local _lOK			:= .f.

	Private cPictHist

	If nOperation == MODEL_OPERATION_UPDATE

		If __cUserId $ _UsrClas

			/*
			If SE2->E2_TIPO $ "PA"
			lRet 	:= .F.

			EndIf
			*/

			If Empty(_oModel:GetValue(MDLMASTER,"E2_NATUREZ"))
				Help(NIL, NIL, "HELP", NIL, 'Campo Natureza é Obrigatorio..', 1, 0, NIL, NIL, NIL, NIL, NIL, {'Informe a Natureza'})

				lRet 	:= .F.
			EndiF

			If _oModel:GetValue(MDLMASTER,"E2_VENCREA") < dDatabase
				Help(NIL, NIL, "HELP", NIL, 'A data de vencimento não pode ser menor que a data atual!', 1, 0, NIL, NIL, NIL, NIL, NIL, {'Verifique a Data de Vencimento.'})

				lRet 	:= .F.
			EndiF

			If lRet
				If MsgYesNo("Confirma a Classificação do Titulo?","Atencao")
					_lClas:= .T.
				Else
					_lClas:= .F.
				Endif

				If _lClas

					If SE2->E2_XBLQ = "4"

						SE2->E2_XBLQ 		:= "" //SE2->E2_XBLQ
						//SE2->E2_TIPO 		:= SE2->E2_XTPORI
						//M->E2_XTPORI 	:= SE2->E2_XTPORI
						SE2->E2_PREFIXO := M->E2_PREFIXO

						_cMsgSave += "===================================" +CR
						_cMsgSave += "Titulo Classificado por. " +CR
						_cMsgSave += "Usuário: "+cUserName+CR
						_cMsgSave += "Em: "+DTOC(DDATABASE)+" "+TIME()+CR

						SE2->E2_XLOG  := _cMsgSave + CR +SE2->E2_XLOG

						_lCont := .F.

					EndIf

				EndIf
			EndIf

		EndIf

		If _oModel:GetValue(MDLMASTER,"E2_XBLQ") == "2" //Titulo Rejeitado
			_cMsgSave += "===================================" +CR
			_cMsgSave += "Titulo Alterado por. " +CR
			_cMsgSave += "Usuário: "+cUserName+CR
			_cMsgSave += "Em: "+DTOC(DDATABASE)+" "+TIME()+CR

			_oModel:loadValue(MDLMASTER,'E2_XBLQ','1')
			_oModel:loadValue(MDLMASTER,'E2_XLOG',_cMsgSave +_oModel:GetValue(MDLMASTER,"E2_XLOG"))

			Aadd( _aMsg , { "Numero: "          , Alltrim(_oModel:GetValue(MDLMASTER,"E2_PREFIXO"))+Alltrim(_oModel:GetValue(MDLMASTER,"E2_NUM"))+Alltrim(_oModel:GetValue(MDLMASTER,"E2_PARCELA")) } )
			Aadd( _aMsg , { "Nome: "    		, _oModel:GetValue(MDLMASTER,"E2_NOMFOR") } )
			Aadd( _aMsg , { "Valor: "    		, transform((_oModel:GetValue(MDLMASTER,"E2_VALOR") )	,"@E 999,999,999.99")  } )
			Aadd( _aMsg , { "Emissao: "    		, dtoc(_oModel:GetValue(MDLMASTER,"E2_EMISSAO")) } )
			Aadd( _aMsg , { "Vencto Real : "    , dtoc(_oModel:GetValue(MDLMASTER,"E2_VENCREA")) } )
			Aadd( _aMsg , { "Data: "    		, dtoc(dDataBase) } )
			Aadd( _aMsg , { "Hora: "    		, time() } )
			Aadd( _aMsg , { "Historico: "    	, Alltrim(_oModel:GetValue(MDLMASTER,"E2_HIST") ) } )

			If ( Type("l410Auto") == "U" .OR. !l410Auto )

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Definicao do cabecalho do email                                             ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

				cMsg := ""
				cMsg += '<html>'
				cMsg += '<head>'
				cMsg += '<title>' + _cAssunto + " - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title>'
				cMsg += '</head>'
				cMsg += '<body>'
				cMsg += '<p>ATENÇÃO:"
				cMsg += '<br><br>'
				cMsg += '-É de responsabilidade do(a) solicitante acompanhar a aprovação do Gestor para que o título fique disponível para o pagamento em tempo hábil.'
				cMsg += '<br><br>'
				cMsg += 'Despesas Comex / RH:    Os títulos aprovados após as 12:00hs do dia do vencimento serão reprogramados automaticamente para o próximo dia útil.'
				cMsg += '<br><br>'
				cMsg += 'Fornecedores Nacionais:   Os títulos aprovados após as 12:00hs do dia do vencimento serão reprogramados automaticamente para a próxima data do calendário de pagamentos Steck (dia 05, 15 ou 25).'
				cMsg += '</p>'
				cMsg += '<br><br>'
				cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
				cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
				cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>' + _cAssunto +" - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+ '</FONT> </Caption>'

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Definicao do texto/detalhe do email                                         ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

				For _nLin := 1 to Len(_aMsg)
					If (_nLin/2) == Int( _nLin/2 )
						cMsg += '<TR BgColor=#B0E2FF>'
					Else
						cMsg += '<TR BgColor=#FFFFFF>'
					EndIf

					cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></B></TD>'
					cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></TD>'
				Next

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Definicao do rodape do email                                                ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

				cMsg += '</Table>'
				cMsg += '<P>'
				cMsg += '<Table align="center">'
				cMsg += '<tr>'
				cMsg += '<td colspan="10" align="center"><font color="red" size="3">Mensagem enviada automaticamente pelo sistema PROTHEUS - <font color="red" size="1">('+cFuncSent+')</td>'
				cMsg += '</tr>'
				cMsg += '</Table>'
				cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
				cMsg += '</body>'
				cMsg += '</html>'

				U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg)

			EndIf

		EndIF

	ElseIf nOperation == MODEL_OPERATION_INSERT

		/*
		_cMsgSave += "===================================" +CR
		_cMsgSave += "Titulo Incluido por. " +CR
		_cMsgSave += "Usuário: "+cUserName+CR
		_cMsgSave += "Em: "+DTOC(DDATABASE)+" "+TIME()+CR

		//_oModel:loadValue(MDLMASTER,'E2_XBLQ','1')
		_oModel:loadValue(MDLMASTER,'E2_XLOG',_cMsgSave)
		//_oModel:loadValue(MDLMASTER,'E2_BAIXA',CTOD("//"))
		//_oModel:loadValue(MDLMASTER,'E2_EMIS1',dDataBase)
		//_oModel:loadValue(MDLMASTER,'E2_SALDO',_oModel:GetValue(MDLMASTER,"E2_VALOR"))
		*/

	ElseIf nOperation == MODEL_OPERATION_DELETE

		//>>Validações dos Solicitantes
		_cQuery := " SELECT * FROM "+RetSqlName("Z42")+" Z42 WHERE Z42_USER = '"+__cUserId+"' AND D_E_L_E_T_ = ' ' "

		If !Empty(Select(_cAlias))
			DbSelectArea(_cAlias)
			(_cAlias)->(dbCloseArea())
		Endif

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cAlias,.T.,.T.)

		dbSelectArea(_cAlias)
		(_cAlias)->(dbGoTop())

		While !EOF()

			If (_cAlias)->(Z42_USER) = __cUserId

				If Empty(_oModel:GetValue(MDLMASTER,"E2_XBLQ"))

					Help(NIL, NIL, "HELP", NIL, 'Titulo já Classificado não será possivel exclui-lo!', 1, 0, NIL, NIL, NIL, NIL, NIL, {'Entre em contato com o Financeiro.'})

					lRet := .f.

				EndIf

			EndIf

			(_cAlias)->(DbSkip())

		End
		//<<

	EndIf

Return lRet

User Function FIN004E(_oModel)

	Local _nTipo  	:= ""
	Local _cEmail  	:= "Eduardo.santos@steck.com.br;jussara.silva@steck.com.br;lilia.lima@steck.com.br;eric.lopes@steck.com.br"
	Local _cCopia	:= UsrRetMail(SE2->E2_USRINC)
	Local _cMsgSave := ""
	Local _cMsgJur	:= ""
	Local lOk := .F.

	private oDlg
	private oBtn1,oBtn2,oBtn3,oDlg
	private _Motivo := Space(60)


	DEFINE MSDIALOG oDlg FROM 50,100 TO 200,630 TITLE "Rejeitar Classificação" PIXEL
	@ 06,020 SAY "Informe o Motivo da Rejeição:" SIZE 122,9 Of oDlg PIXEL
	@ 30,008 SAY "Motivo:" SIZE 22,9 Of oDlg PIXEL
	@ 30,040 MSGET _Motivo SIZE 220,10 Of oDlg PIXEL
	@ 50,170 BUTTON oBut1 PROMPT "&Ok"       SIZE 44,12 Of oDlg PIXEl Action (lOk:=.T.,oDlg:End())
	@ 50,220 BUTTON oBut2 PROMPT "&Cancela"  SIZE 44,12 Of oDlg PIXEl Action (lOk:=.F.,oDlg:End())

	ACTIVATE MSDIALOG oDlg

	If lOk

		If Empty(_Motivo)

			Help(NIL, NIL, "HELP", NIL, 'Campo de preenchimento Obrigatorio..', 1, 0, NIL, NIL, NIL, NIL, NIL, {'Informe o Motivo da Rejeição'})

		Else

			_cMsgSave += "===================================" +CR
			_cMsgSave += "Titulo Rejeitado na Classificacao por: " +CR
			_cMsgSave += "Usuário: "+cUserName+CR
			_cMsgSave += "Em: "+DTOC(DDATABASE)+" "+TIME()+CR
			_cMsgSave += "Motivo: "+_Motivo

			RecLock("SE2", .F.)

			SE2->E2_XLOG  := _cMsgSave+ CR +SE2->E2_XLOG
			SE2->E2_XBLQ  := "2"

			SE2->(MsUnlock())

			SE2->(DbCommit())

			FIN004B("Titulo Rejeitado na Classificacao"+_cMsgJur, _cEmail, _cCopia, _Motivo, cUserName)

		EndIf

	EndIf

Return

User Function FIN004F(_oModel)

	Local _aMsg     := {}
	Local oModel1	:= FWModelActive()
	Local oView1		:= FWViewActive()
	Local cHist 	:= oModel1:GetValue(MDLMASTER,"E2_HIST")
	Local E2_NUM 	:= oModel1:GetValue(MDLMASTER,"E2_NUM")
	Local E2_PREFIXO 	:= oModel1:GetValue(MDLMASTER,"E2_PREFIXO")
	Local E2_TIPO 	:= oModel1:GetValue(MDLMASTER,"E2_TIPO")
	Local E2_PARCELA 	:= oModel1:GetValue(MDLMASTER,"E2_PARCELA")
	Local E2_FORNECE 	:= oModel1:GetValue(MDLMASTER,"E2_FORNECE")
	Local E2_LOJA 	:= oModel1:GetValue(MDLMASTER,"E2_LOJA")
	Local E2_NOMFOR 	:= oModel1:GetValue(MDLMASTER,"E2_NOMFOR")
	Local E2_EMISSAO 	:= oModel1:GetValue(MDLMASTER,"E2_EMISSAO")
	Local E2_EMIS1 	:= oModel1:GetValue(MDLMASTER,"E2_EMIS1")
	Local E2_VENCTO 	:= oModel1:GetValue(MDLMASTER,"E2_VENCTO")
	Local E2_VENCREA 	:= oModel1:GetValue(MDLMASTER,"E2_VENCREA")
	Local E2_VALOR 	:= oModel1:GetValue(MDLMASTER,"E2_VALOR")
	Local E2_VLCRUZ 	:= oModel1:GetValue(MDLMASTER,"E2_VLCRUZ")
	Local E2_NATUREZ 	:= oModel1:GetValue(MDLMASTER,"E2_NATUREZ")
	Local E2_HIST 	:= oModel1:GetValue(MDLMASTER,"E2_HIST")
	Local E2_PORTADO 	:= oModel1:GetValue(MDLMASTER,"E2_PORTADO")
	Local E2_CONTAD 	:= oModel1:GetValue(MDLMASTER,"E2_CONTAD")
	Local E2_CCD 	:= oModel1:GetValue(MDLMASTER,"E2_CCD")
	Local E2_BCOPAG 	:= oModel1:GetValue(MDLMASTER,"E2_BCOPAG")
	Local E2_RATEIO 	:= oModel1:GetValue(MDLMASTER,"E2_RATEIO")
	Local nOperation := _oModel:GetOperation()
	Local lRet 		:= .T.
	Local aVetor	:={}
	Local _nLin     := 0 
	Local _cAssunto 	:= "Solicitação de Aprovação Contas a Pagar"
	Local _cEmail  		:= UsrRetMail(oModel1:GetValue(MDLMASTER,"E2_XAPROV"))
	Local _cCopia		:= UsrRetMail(oModel1:GetValue(MDLMASTER,"E2_USRINC"))
	Local cFuncSent		:= "FIN004D"
	Private lMsErroAuto := .F.

	If nOperation == MODEL_OPERATION_INSERT //MODEL_OPERATION_UPDATE ////


		If len(Rtrim(E2_NUM))<9
			E2_NUM:=  Replicate( "0", 9-len(Rtrim(E2_NUM)))+Rtrim(E2_NUM)
		Endif


		aVetor := {	{"E2_PREFIXO"				, E2_PREFIXO 	,Nil},;
			{"E2_NUM"					, E2_NUM			,Nil},;
			{"E2_TIPO"					, E2_TIPO 		,Nil},;
			{"E2_PARCELA"				, E2_PARCELA		,Nil},;
			{"E2_FORNECE"				, E2_FORNECE		,Nil},;
			{"E2_LOJA"					, E2_LOJA		,Nil},;
			{"E2_NOMFOR"				, E2_NOMFOR		,Nil},;
			{"E2_EMISSAO"				, E2_EMISSAO		,Nil},;
			{"E2_EMIS1"					, E2_EMIS1		,Nil},;
			{"E2_VENCTO"				, E2_VENCTO		,Nil},;
			{"E2_VENCREA"				, E2_VENCREA		,Nil},;
			{"E2_VALOR"					, E2_VALOR		,Nil},;
			{"E2_VLCRUZ"				, E2_VLCRUZ		,Nil},;
			{"E2_NATUREZ"				, E2_NATUREZ 	,Nil},;
			{"E2_HIST"					, E2_HIST		,Nil},;
			{"E2_PORTADO"				, E2_PORTADO 	,Nil},;
			{"E2_CONTAD"    			, E2_CONTAD		,Nil},;
			{"E2_CCD"					, E2_CCD			,Nil},;
			{"E2_BCOPAG"				, E2_BCOPAG 		,Nil},;
			{"AUTBANCO"					, @cBancoAdt 		,Nil},;
			{"AUTAGENCIA"				, @cAgenciaAdt		,Nil},;
			{"AUTCONTA"					, @cNumCon 			,Nil}}

		If INCLUI  .And. E2_VALOR>0 .AND.  FUnName()=="STFIN004"//Ticket 20220712013797/20220713013850

			If Empty(E2_PREFIXO)
				lRet := .F.
				FWAlertWarning("Prefixo , deverá ser informado..CMA/FIN","Atenção")
			Endif

			//If  Empty(M->E2_CCD)  .And. M->E2_RATEIO == "N"
			If E2_PREFIXO$"CMA" .And. Empty(E2_CCD)  .And. E2_RATEIO == "N"

				lRet := .F.
				FWAlertWarning( "Informe o centro de custo.","Atenção")
				//MsgInfo("Informe o centro de custo.","Atenção")
			Endif

			If  Empty(E2_HIST)
				lRet := .F.
				FWAlertWarning("Informe o HISTÓRICO para o título, detalhado..","Atenção")
			Endif


		Endif

		If !lRet
			Return lRet
		Endif

		MsgRun(OemToAnsi("Gerando registros no Contas a Pagar..." ),,{||MsExecAuto( { |x,y,z| FINA050(x,y,z)}, aVetor,, 3)})
		//MsgRun(OemToAnsi("Gerando registros no Contas a Pagar..." ),,{|| FINA050(aVetor,3)})

		If lMsErroAuto
			MsgInfo("Erro na geração do titulo ...!!!!!")
			MostraErro()
			lRet := .F.
		Else

			Aadd( _aMsg , { "Numero: "          	, Alltrim(E2_PREFIXO)+Alltrim(E2_NUM)+Alltrim(E2_PARCELA) } )
			Aadd( _aMsg , { "Nome: "    			, E2_NOMFOR } )
			Aadd( _aMsg , { "Valor: "    			, transform(E2_VALOR	,"@E 999,999,999.99")  } )
			Aadd( _aMsg , { "Emissao: "    			, dtoc(E2_EMISSAO) } )
			Aadd( _aMsg , { "Vencto Real : "    	, dtoc(E2_VENCREA) } )
			Aadd( _aMsg , { "Data: "    			, dtoc(dDataBase) } )
			Aadd( _aMsg , { "Hora: "    			, time() } )
			Aadd( _aMsg , { "Titulo Incluido por: " , cUserName } )
			Aadd( _aMsg , { "Historico: "    		, Alltrim(E2_HIST ) } )

			If ( Type("l410Auto") == "U" .OR. !l410Auto )

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Definicao do cabecalho do email                                             ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				cMsg := ""
				cMsg += '<html>'
				cMsg += '<head>'
				cMsg += '<title>' + _cAssunto + " - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title>'
				cMsg += '</head>'
				cMsg += '<body>'
				cMsg += '<p>ATENÇÃO:"
				cMsg += '<br><br>'
				cMsg += '-É de responsabilidade do(a) solicitante acompanhar a aprovação do Gestor para que o título fique disponível para o pagamento em tempo hábil.'
				cMsg += '<br><br>'
				cMsg += 'Despesas Comex / RH:    Os títulos aprovados após as 12:00hs do dia do vencimento serão reprogramados automaticamente para o próximo dia útil.'
				cMsg += '<br><br>'
				cMsg += 'Fornecedores Nacionais:   Os títulos aprovados após as 12:00hs do dia do vencimento serão reprogramados automaticamente para a próxima data do calendário de pagamentos Steck (dia 05, 15 ou 25).'
				cMsg += '</p>'
				cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
				cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
				cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>' + _cAssunto +" - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+ '</FONT> </Caption>'
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Definicao do texto/detalhe do email                                         ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				For _nLin := 1 to Len(_aMsg)
					If (_nLin/2) == Int( _nLin/2 )
						cMsg += '<TR BgColor=#B0E2FF>'
					Else
						cMsg += '<TR BgColor=#FFFFFF>'
					EndIf

					cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></B></TD>'
					cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></TD>'

				Next

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Definicao do rodape do email                                                ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				cMsg += '</Table>'
				cMsg += '<P>'
				cMsg += '<Table align="center">'
				cMsg += '<tr>'
				cMsg += '<td colspan="10" align="center"><font color="red" size="3">Mensagem enviada automaticamente pelo sistema PROTHEUS - <font color="red" size="1">('+cFuncSent+')</td>'
				cMsg += '</tr>'
				cMsg += '</Table>'
				cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
				cMsg += '</body>'
				cMsg += '</html>'

				U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg)

			EndIf

			U_FIN004C(.T.)
		EndIf

	EndIf

Return lRet

User Function FIN004G()

	Local _lRet := .T.
	Local nOpca 	:= 0

	Private nMoedAux	:= 1

	//---------------------------------------------------------------
	// Mostra Get do Banco de Entrada
	//---------------------------------------------------------------
	nOpca := 0
	DEFINE MSDIALOG oDlg FROM 10, 5 TO 26, 60 TITLE OemToAnsi("Local de Entrada") //"Local de Entrada"
	@	.3,1 TO 07.3,26 OF oDlg
	// BANCO
	@	1.0,2 	Say OemToAnsi("Banco : ") //"Banco : "

	@	1.0,8  	MSGET oBcoAdt 			VAR cBancoAdt F3 "SA6" 	//Valid Iif(SA6->A6_BLOCKED <> '2', MsgAlert("Conta Bloqueada para Movimentações."),.T.) //CarregaSa6(@cBancoAdt,,,,,,, @nMoedAux ) HASBUTTON //.And. FaPrNumChq(cBancoAdt,cAgenciaAdt,cNumCon,@oChqAdt,@cChequeAdt)

	// AGENCIA
	@	2.0,2 	Say OemToAnsi("Agência : ") //"Agência : "
	@	2.0,8 	MSGET cAgenciaAdt 								//Valid CarregaSa6(@cBancoAdt,@cAgenciaAdt) .And. FaPrNumChq(cBancoAdt,cAgenciaAdt,cNumCon,@oChqAdt,@cChequeAdt)
	// CONTA
	@	3.0,2 	Say OemToAnsi("Conta : ") //"Conta : "
	@	3.0,8 	MSGET cNumCon 									//Valid If(CarregaSa6(@cBancoAdt,@cAgenciaAdt,@cNumCon,,,.T.),FaPrNumChq(cBancoAdt,cAgenciaAdt,cNumCon,@oChqAdt,@cChequeAdt),oBcoAdt:SetFocus())
	// NUMERO CHEQUE

	@	4.0,2 	Say OemToAnsi("Núm Cheque:") //"Núm Cheque:"
	@	4.0,8 	MSGET oChqAdt 			VAR cChequeAdt 			When (	mv_par05 == 1 .And. substr(cBancoAdt,1,2)!="CX" .And. !(cBancoAdt$GEtMV("MV_CARTEIR")) .And. cPaisLoc <> "EQU") ;
		Valid fa050Cheque(cBancoAdt,cAgenciaAdt,cNumCon,cChequeAdt,Iif(cPaisLoc $ "ARG",.F.,.T.))
	// HISTORICO
	@	5.0,2 	Say OemToAnsi("Historico :    ") //"Historico :    "
	@	5.0,8 	MSGET cHistor		Picture cPictHist	SIZE 135, 10 OF oDlg
	// BENEFICIARIO
	@	6.0,2 	Say OemToAnsi("Beneficiario : ") //"Beneficiario : "
	@	6.0,8 	MSGET cBenef		Picture "@S40"		SIZE 135, 10 OF oDlg
	*/

	DbSelectArea("SA6")
	DbSetOrder(1)
	DbGotop()
	DbSeek(xFilial("SA6")+cBancoAdt+cAgenciaAdt+cNumCon)

	bAction := {||	nOpca:=1,Iif(!Empty(cBancoAdt) , Iif(SA6->A6_BLOCKED <> '2', MsgAlert("Conta Bloqueada para Movimentações."),oDlg:End()) ,nOpca:=0)}

	DEFINE SBUTTON FROM 105,180.1 TYPE 1 ACTION ( Eval(bAction) ) ENABLE OF oDlg
	ACTIVATE MSDIALOG oDlg CENTERED

	IF nOpca != 0

		If nMoeda<>Nil .and. cPaisLoc != "BRA"
			nMoeda   := Max(IIf(Type("SA6->A6_MOEDAP")=="U",SA6->A6_MOEDA,If(SA6->A6_MOEDAP>0,SA6->A6_MOEDAP,SA6->A6_MOEDA)),1)
		Endif

		//Coloca no campo Moeda a moeda referente ao banco escolhido
		SA6->(DBSETORDER(1))
		IF SA6->(DBSEEK(xFILIAL("SA6")+cBancoAdt+cAgenciaAdt+cNumCon))

			nMoedAux := IIf(SA6->A6_MOEDA <> 0, SA6->A6_MOEDA, 1)

		ENDIF

		If cPaisLoc == "BRA"
			M->E2_MOEDA := nMoedAux
		EndIf

	EndIf

Return(_lRet)

User Function FIN004H(_oModel)

	Local nOperation := _oModel:GetOperation()
	Local lRet 		:= .T.
	Local aVetor	:={}

	Private lMsErroAuto := .F.

	If nOperation == MODEL_OPERATION_UPDATE

		If Empty(M->E2_XBLQ)
			Help(NIL, NIL, "HELP", NIL, 'Titulo aprovado pelo Gestor..', 1, 0, NIL, NIL, NIL, NIL, NIL, {'Não será possivel altera-lo.'})
			lRet := .F.
		EndIf

	EndIf

Return lRet

/*/{Protheus.doc} VldPRFWhen
VALIDA PREFIXO
Chamado: 20220214003637
@type function
@version  12.1.25
@author Valdemir Rabelo
@since 22/02/2022
@param oModel, object, Objeto
@return variant, Lógico
/*/
Static Function VldPRFWhen(oModel)
	Local lRET := .t.
	Local oModWhen := oModel:GetModel( MDLMASTER )      // Valdemir Rabelo 18/03/2022 - Ticket: 20220318006051

	lRET := (LEFT(UPPER(oModWhen:GetValue("E2_ORIGEM")),3) == "FIN")

Return lRET
