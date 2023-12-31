#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �STEMBAM7   �Autor  �Joao Rinaldi       � Data �  28/09/2015 ���
�������������������������������������������������������������������������͹��
���Desc.     �Fun��o chamada pelo ponto de entrada M410LIOK para validar  ���
���          �as opera��es de transfer�ncias entre filias STECK           ���
�������������������������������������������������������������������������͹��
���Uso       � Steck Industria Eletrica Ltda.                             ���
�������������������������������������������������������������������������ͼ��
���Rotina    � MATA410.PRX                                                ���
���Nome      � Pedido de Venda                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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

	//������������������������������������������������������������������������Ŀ
	//�Valida��o de Grupo de Usu�rio para acesso aos bot�es da rotina de Embarque
	//��������������������������������������������������������������������������
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
			MSGALERT( "Usu�rio sem acesso a incluir Pedido de Venda na Opera��o '"+(acols[n][_nPosOper])+"' na Empresa "+cEmpAnt+" e na Filial "+cFilAnt+" ...!!!"+ Chr(10) + Chr(13) +;
				Chr(10) + Chr(13) +;
				"Favor verificar suas permiss�es de acesso...!!!"+ Chr(10) + Chr(13)+;
				Chr(10) + Chr(13) +;
				"Ser� necess�rio gerar um novo Pedido de Venda para inclus�o do produto "+(acols[n][_nPosProd])+"...!!!"+ Chr(10) + Chr(13),;
				"Usu�rio sem Acesso")
			_lRet := .F.
			Return (_lRet)
		Endif
		If !(aCols[n][Len(aCols[n])])
			If (acols[n][_nPosOper]) $ _cOper
				//Chamado 002899
				If !(_lSchneider)
					If (Substr((acols[n][_nPosProd]),1,1) = "E" .OR. Substr((acols[n][_nPosProd]),1,1) = "U")
						MSGALERT( "A Opera��o '"+(acols[n][_nPosOper])+"' n�o permite inclus�o de produto de c�digo '"+Substr((acols[n][_nPosProd]),1,1)+"'...!!!"+ Chr(10) + Chr(13) +;
							Chr(10) + Chr(13) +;
							"Favor verificar a opera��o correta para essa finalidade...!!!"+ Chr(10) + Chr(13)+;
							Chr(10) + Chr(13) +;
							"Ser� necess�rio gerar um novo Pedido de Venda para inclus�o de produto de c�digo '"+Substr((acols[n][_nPosProd]),1,1)+"'...!!!"+ Chr(10) + Chr(13),;
							"C�digo '"+Substr((acols[n][_nPosProd]),1,1)+"' na Opera��o '"+(acols[n][_nPosOper])+"'")
						_lRet := .F.
					//Chamado 002899
					ElseIf (_cTipo = 'IC')
						MSGALERT( "A Opera��o '"+(acols[n][_nPosOper])+"' n�o permite inclus�o de produto do tipo '"+_cTipo+"'...!!!"+ Chr(10) + Chr(13) +;
							Chr(10) + Chr(13) +;
							"Favor verificar a opera��o correta para essa finalidade...!!!"+ Chr(10) + Chr(13)+;
							Chr(10) + Chr(13) +;
							"Ser� necess�rio gerar um novo Pedido de Venda para inclus�o de produto do tipo '"+_cTipo+"'...!!!"+ Chr(10) + Chr(13),;
							"Tipo '"+_cTipo+"' na Opera��o '"+(acols[n][_nPosOper])+"'")
						_lRet := .F.
					Endif
				Endif
			ElseIf (acols[n][_nPosOper]) = '48' .And. cEmpAnt == '01'//STECK SAO PAULO
				//Chamado 002899
				//If (_cTipo = 'IC')
				If !((Substr((acols[n][_nPosProd]),1,1) = "E" .OR. Substr((acols[n][_nPosProd]),1,1) = "U") .Or. (_cTipo = 'IC'))
				//Else
					MSGALERT( "A Opera��o '"+(acols[n][_nPosOper])+"' � destina para produtos de C�digo 'E' e/ou C�digo 'U' e/ou do Tipo 'IC' (Itens de Consumo)...!!!"+ Chr(10) + Chr(13) +;
						Chr(10) + Chr(13) +;
						"Favor verificar a opera��o correta para essa finalidade...!!!"+ Chr(10) + Chr(13)+;
						Chr(10) + Chr(13) +;
						"Ser� necess�rio gerar um novo Pedido de Venda para inclus�o do produto "+(acols[n][_nPosProd])+"...!!!"+ Chr(10) + Chr(13),;
						"C�digo 'E' e/ou C�digo 'U' e/ou do Tipo 'IC' (Itens de Consumo) na Opera��o '"+(acols[n][_nPosOper])+"'")
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
