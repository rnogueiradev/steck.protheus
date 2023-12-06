#INCLUDE "Topconn.ch"
#INCLUDE "Protheus.ch"

/*/{Protheus.doc} STFATG03

Calcular os dias para entrega conforme cadastro 
da tabela JC2

@type function
@author Everson Santana
@since 19/12/18
@version Protheus 12 - Faturamento

@history ,Chamado 008551 ,

/*/
//-------------------------------------------------------------------------------------------------------//
//Alterações efetuadas:
//FR - 10/02/2022 - Alteração - Adequação da query para considerar a empresa posicionada (estava fixo 01)
//-------------------------------------------------------------------------------------------------------//


User Function STFATG03(lFormula)

	Local _cQry := ""
	Local aArea 		:= GetArea()
	Local _lCall      	:= IsInCallSteck("TMKA271") .Or. IsInCallSteck("TMKA380") .or. IsInCallSteck("U_STFSVE46")
	Local _lPv        	:= IsInCallSteck("MATA410")
	Local _cCep 		:= " "
	Local _nDias		:= " "

	If Select("TRD") > 0
		TRD->(DbCloseArea())
	Endif

	If _lCall

		_cCep := SUA->UA_CEPE

		If Empty(_cCep)

			_cCep := POSICIONE("SA1", 1, xFilial("SA1") + SUA->UA_CLIENTE+SUA->UA_LOJA, "A1_CEP")

		EndIf

	ElseIF _lPv

		_cCep := SC5->C5_ZCEPE

		If Empty(_cCep)

			_cCep := POSICIONE("SA1", 1, xFilial("SA1") + SC5->C5_CLIENT+SC5->C5_LOJAENT, "A1_CEP")

		EndIf

		If Empty(_cCep)

			_cCep := POSICIONE("SA1", 1, xFilial("SA1") + SC5->C5_CLIENTE+SC5->C5_LOJA, "A1_CEP")

		EndIf


	EndIf

	//FR - 10/02/2022 - Alteração - Adequação da query para considerar a empresa posicionada (estava fixo 01)
	_cQry := " "
	_cQry += " SELECT JC2_XDIAS FROM " + RetSqlName("JC2") + ""
	_cQry += " WHERE JC2_CEP = '"+_cCep+"' "
	_cQry += " AND D_E_L_E_T_ = ' ' "
	MemoWrite("C:\TEMP\QRY_JC2.TXT" , _cQry)

	TcQuery _cQry New Alias "TRD"

	TRD->(dbGoTop())

	_nDias := TRD->JC2_XDIAS

	If lFormula == Nil  //Se Nil, chamada é dentro do Protheus, se Diferente de Nil, a chamada pode ser de api externa, nesse caso, não exibe alertas

		If Empty(_nDias)

			MsgAlert(" Cadastros não localizado para este CEP!!"," Atenção ")

		Else

			If Empty(_cCep)


				MsgAlert(" CEP não cadastra!!"," Atenção ")
			Else
				MsgInfo("Prazo para entrega: "+Alltrim(_nDias)+" Dias."," Informação ")
			EndIf

		EndIf

	Endif

	RestArea(aArea)

	If lFormula <> NIL  //lFormula indica que a chamada requer apenas que se retorne os dias
		Return Val(Alltrim(_nDias ))
	Endif

Return


/*
//-------------------------------------------------------------------------------------------------------//
//Função : STFATCC2 - Função que traz o prazo Transportadora diretamente da tabela CC2 (Municipios IBGE)
//Retorno: conteúdo do campo CC2_XTNT (Transit Time)
//Autoria: Flávia Rocha - Sigamat Consultoria
//-------------------------------------------------------------------------------------------------------//
*/

User Function STFATCC2(lFormula,_cRotina)

	Local _cQry := ""
	Local aArea 		:= GetArea()
	Local _lCall      	:= IsInCallSteck("TMKA271") .Or. IsInCallSteck("TMKA380") .or. IsInCallSteck("U_STFSVE46") .Or. IsInCallStack("GET")
	Local _lPv        	:= IsInCallSteck("MATA410")
	Local _nDias		:= " "
	Local _cCodmun      := " "
	Local _cMun			:= " "
	Local _cEst 		:= " "
	Local _lDtEnt       := IsInCallSteck("U_STREST11")
	Default _cRotina    := ""

	If _cRotina=="PEDIDO"
		_lPv := .T.
		_lCall := .F.
	EndIf

	If Select("TRD") > 0
		TRD->(DbCloseArea())
	Endif

	If _lCall

		_cCodmun := POSICIONE("SA1", 1, xFilial("SA1") + SUA->UA_CLIENTE+SUA->UA_LOJA, "A1_COD_MUN")
		_cMun    := POSICIONE("SA1", 1, xFilial("SA1") + SUA->UA_CLIENTE+SUA->UA_LOJA, "A1_MUN")
		_cEst    := POSICIONE("SA1", 1, xFilial("SA1") + SUA->UA_CLIENTE+SUA->UA_LOJA, "A1_EST")

	ElseIF _lPv

		_cCodmun := POSICIONE("SA1", 1, xFilial("SA1") + SC5->C5_CLIENT+SC5->C5_LOJAENT, "A1_COD_MUN")
		_cMun    := POSICIONE("SA1", 1, xFilial("SA1") + SC5->C5_CLIENT+SC5->C5_LOJAENT, "A1_MUN")
		_cEst    := POSICIONE("SA1", 1, xFilial("SA1") + SC5->C5_CLIENT+SC5->C5_LOJAENT, "A1_EST")

		If Empty(_cCodmun)
			_cCodmun := POSICIONE("SA1", 1, xFilial("SA1") + SC5->C5_CLIENTE+SC5->C5_LOJAENT, "A1_COD_MUN")
			_cMun    := POSICIONE("SA1", 1, xFilial("SA1") + SC5->C5_CLIENT+SC5->C5_LOJAENT, "A1_MUN")
			_cEst    := POSICIONE("SA1", 1, xFilial("SA1") + SC5->C5_CLIENT+SC5->C5_LOJAENT, "A1_EST")
		Endif

	ElseIF _lDtEnt

		_cCodmun := SA1->A1_COD_MUN
		_cMun    := SA1->A1_MUN
		_cEst    := SA1->A1_EST

	Else

		_cCodmun := POSICIONE("SA1", 1, xFilial("SA1") + SC5->C5_CLIENT+SC5->C5_LOJAENT, "A1_COD_MUN")
		_cMun    := POSICIONE("SA1", 1, xFilial("SA1") + SC5->C5_CLIENT+SC5->C5_LOJAENT, "A1_MUN")
		_cEst    := POSICIONE("SA1", 1, xFilial("SA1") + SC5->C5_CLIENT+SC5->C5_LOJAENT, "A1_EST")

		If Empty(_cCodmun)
			_cCodmun := POSICIONE("SA1", 1, xFilial("SA1") + SC5->C5_CLIENTE+SC5->C5_LOJAENT, "A1_COD_MUN")
			_cMun    := POSICIONE("SA1", 1, xFilial("SA1") + SC5->C5_CLIENT+SC5->C5_LOJAENT, "A1_MUN")
			_cEst    := POSICIONE("SA1", 1, xFilial("SA1") + SC5->C5_CLIENT+SC5->C5_LOJAENT, "A1_EST")
		Endif

	EndIf

	//FR - 10/02/2022 - Alteração - Adequação da query para considerar a empresa posicionada (estava fixo 01)
	_cQry := " "
	_cQry += " SELECT CC2_EST, CC2_CODMUN, CC2_MUN, CC2_XTNT FROM " + RetSqlName("CC2") + ""
	_cQry += " WHERE CC2_EST  = '"+ _cEst + "' "
	_cQry += " AND CC2_CODMUN = '" + _cCodmun + "' "
	_cQry += " AND D_E_L_E_T_ = ' ' "

	MemoWrite("C:\TEMP\QRY_CC2.TXT" , _cQry)

	TcQuery _cQry New Alias "TRD"

	TRD->(dbGoTop())

	_nDias := TRD->CC2_XTNT

	If lFormula == Nil  //Se Nil, chamada é dentro do Protheus, se Diferente de Nil, a chamada pode ser de api externa, nesse caso, não exibe alertas

		If Empty(_nDias)

			MsgAlert("Prazo Transportadora Não Localizado para este Município -> " + _cMun  ," Atenção ")

		Else

			If Empty(_cCodmun)

				MsgAlert(" Município Não Cadastrado !!"," Atenção ")

			Else
				MsgInfo("Prazo Transportadora Para Município: " + _cMun + " é: "+Alltrim(Str(_nDias))+" Dias."," Informação ")

			EndIf

		EndIf

	Endif

	RestArea(aArea)

	If lFormula <> NIL  //lFormula indica que a chamada requer apenas que se retorne os dias
		Return (_nDias )
	Endif

Return









