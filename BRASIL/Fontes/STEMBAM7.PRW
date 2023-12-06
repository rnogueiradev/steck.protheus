#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STEMBAM7   ºAutor  ³Joao Rinaldi       º Data ³  28/09/2015 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função chamada pelo ponto de entrada M410LIOK para validar  º±±
±±º          ³as operações de transferências entre filias STECK           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Steck Industria Eletrica Ltda.                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºRotina    ³ MATA410.PRX                                                º±±
±±ºNome      ³ Pedido de Venda                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function STEMBAM7()

	Local _lRet        := .T.
	Local _nPosOper    := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_OPER" })
	Local _nPosProd    := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_PRODUTO" })
	Local _nPosLocal   := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_LOCAL" })

	Local _nPosIpc    := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_ITEMPC" })
	Local _nPosNpc   := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_NUMPCOM" })
 
	Local _cOper       := SuperGetMV("ST_OPEREMB",.F.,"15")
	Local _cGrp        := SuperGetMV("ST_GRPEMPV",.F.,"000000")
	Local _aGrupos     := {}
	Local _lSchneider  := .F.
	Local _cTipo       := ''

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Validação de Grupo de Usuário para acesso aos botões da rotina de Embarque
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	PswOrder(1)
	If PswSeek(__cUserId,.T.)
		_aGrupos  := PswRet()
	Endif


	If !(Empty(Alltrim(acols[n][_nPosIpc]))) .Or. !(Empty(Alltrim(acols[n][_nPosNpc])))
		If   Empty(Alltrim(acols[n][_nPosIpc]))  .Or.  Empty(Alltrim(acols[n][_nPosNpc])) 
			MsgInfo("Os campos Ordem de Compra e Item precisao estar ambos preenchidos.....!!!!")
			_lRet := .F.
			Return (_lRet)
		EndIf
	EndIf

	//Chamado 002899
	DbSelectarea("SZ7")//CODIFICACAO SCHNEIDER
	SZ7->(DbSetOrder(1))//Z7_FILIAL+Z7_COD
	SZ7->(DbGoTop())
	If SZ7->(DbSeek(xFilial("SZ7")+(acols[n][_nPosProd])))
		_lSchneider := .T.
	Endif

	DbSelectarea("SB1")//CADASTRO DE PRODUTOS
	SB1->(DbSetOrder(1))//B1_FILIAL+B1_COD
	SB1->(DbGoTop())
	If SB1->(DbSeek(xFilial("SB1")+(acols[n][_nPosProd])))
		_cTipo := SB1->B1_TIPO
	Endif

	If ( Type("l410Auto") == "U" .OR. !l410Auto )
		If !(_aGrupos[1][10][1] $ _cGrp) .And. cEmpAnt == '01' .And. cFilAnt == '04' .And. (acols[n][_nPosOper]) $ _cOper
			MSGALERT( "Usuário sem acesso a incluir Pedido de Venda na Operação '"+(acols[n][_nPosOper])+"' na Empresa "+cEmpAnt+" e na Filial "+cFilAnt+" ...!!!"+ Chr(10) + Chr(13) +;
				Chr(10) + Chr(13) +;
				"Favor verificar suas permissões de acesso...!!!"+ Chr(10) + Chr(13)+;
				Chr(10) + Chr(13) +;
				"Será necessário gerar um novo Pedido de Venda para inclusão do produto "+(acols[n][_nPosProd])+"...!!!"+ Chr(10) + Chr(13),;
				"Usuário sem Acesso")
			_lRet := .F.
			Return (_lRet)
		Endif
		If !(aCols[n][Len(aCols[n])])
			If (acols[n][_nPosOper]) $ _cOper
				//Chamado 002899
				If !(_lSchneider)
					If (Substr((acols[n][_nPosProd]),1,1) = "E" .OR. Substr((acols[n][_nPosProd]),1,1) = "U")
						MSGALERT( "A Operação '"+(acols[n][_nPosOper])+"' não permite inclusão de produto de código '"+Substr((acols[n][_nPosProd]),1,1)+"'...!!!"+ Chr(10) + Chr(13) +;
							Chr(10) + Chr(13) +;
							"Favor verificar a operação correta para essa finalidade...!!!"+ Chr(10) + Chr(13)+;
							Chr(10) + Chr(13) +;
							"Será necessário gerar um novo Pedido de Venda para inclusão de produto de código '"+Substr((acols[n][_nPosProd]),1,1)+"'...!!!"+ Chr(10) + Chr(13),;
							"Código '"+Substr((acols[n][_nPosProd]),1,1)+"' na Operação '"+(acols[n][_nPosOper])+"'")
						_lRet := .F.
					//Chamado 002899
					ElseIf (_cTipo = 'IC')
						MSGALERT( "A Operação '"+(acols[n][_nPosOper])+"' não permite inclusão de produto do tipo '"+_cTipo+"'...!!!"+ Chr(10) + Chr(13) +;
							Chr(10) + Chr(13) +;
							"Favor verificar a operação correta para essa finalidade...!!!"+ Chr(10) + Chr(13)+;
							Chr(10) + Chr(13) +;
							"Será necessário gerar um novo Pedido de Venda para inclusão de produto do tipo '"+_cTipo+"'...!!!"+ Chr(10) + Chr(13),;
							"Tipo '"+_cTipo+"' na Operação '"+(acols[n][_nPosOper])+"'")
						_lRet := .F.
					Endif
				Endif
			ElseIf (acols[n][_nPosOper]) = '48' .And. cEmpAnt == '01'//STECK SAO PAULO
				//Chamado 002899
				//If (_cTipo = 'IC')
				If !((Substr((acols[n][_nPosProd]),1,1) = "E" .OR. Substr((acols[n][_nPosProd]),1,1) = "U") .Or. (_cTipo = 'IC'))
				//Else
					MSGALERT( "A Operação '"+(acols[n][_nPosOper])+"' é destina para produtos de Código 'E' e/ou Código 'U' e/ou do Tipo 'IC' (Itens de Consumo)...!!!"+ Chr(10) + Chr(13) +;
						Chr(10) + Chr(13) +;
						"Favor verificar a operação correta para essa finalidade...!!!"+ Chr(10) + Chr(13)+;
						Chr(10) + Chr(13) +;
						"Será necessário gerar um novo Pedido de Venda para inclusão do produto "+(acols[n][_nPosProd])+"...!!!"+ Chr(10) + Chr(13),;
						"Código 'E' e/ou Código 'U' e/ou do Tipo 'IC' (Itens de Consumo) na Operação '"+(acols[n][_nPosOper])+"'")
					_lRet := .F.
				Endif
			Endif
		Endif

		//If (acols[n][_nPosOper]) $ _cOper .And. _lRet .And. !(aCols[n][Len(aCols[n])]) .And. cFilAnt == '04'
		//	(acols[n][_nPosLocal]) := SuperGetMV("ST_LOCESC",,"15")
		//	oGetDad:oBrowse:Refresh()
		//Endif

	EndIf

Return (_lRet)
