#include "totvs.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �STVLDPCS	�Autor  �Renato Nogueira     � Data �  08/07/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �Fun��o utilizada segregar os acessos de inclus�o/altera��o  ���
���          �nos pedido de compras				    				      ���
�������������������������������������������������������������������������͹��
���Parametro � Nenhum                                                     ���
�������������������������������������������������������������������������ͼ��
���Retorno   � Nenhum                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function STVLDPCS()
	
	Local _aArea	:= GetArea()
	Local _lRet		:= .F.
	Local _aGrupos
	Local cQuery1 	:= ""
	Local cAlias1 	:= "QRYTEMP"
	Local _cRegras	:= ""
	If cEmpAnt = '03'
		Return(.T.)
	EndIf
	//	Adicionado para chamada Faturamento Beneficiamento - Valdemir Rabelo 26/07/2019
	if IsInCallStack( "U_STGerPC" ) .Or. IsInCallStack( "U_STCOM251" ) .Or. IsInCallStack( "U_STCOM260" ) .Or. IsInCallStack( "U_STDISTC7" ) .Or. IsInCallStack( "U_STMAOC7" )
		Return .T.
	ENDIF
		
	DbSelectArea("SA2")
	SA2->(DbSetOrder(1))
	SA2->(DbGoTop())
	If !SA2->(DbSeek(xFilial("SA2")+CA120FORN+CA120LOJ))
		MsgAlert("Fornecedor n�o encontrado, verifique!")
		Return(.F.)
	EndIf
	
	PswOrder(1)
	If PswSeek(__cUserId,.T.)
		_aGrupos	:= PswRet()
	EndIf
	
	cQuery1	 := " SELECT * "
	cQuery1  += " FROM " +RetSqlName("SZC")+ " ZC "
	cQuery1  += " WHERE ZC.D_E_L_E_T_=' ' AND ZC_GRUPOS LIKE '%"+_aGrupos[1][10][1]+"%' "
	
	If !Empty(Select(cAlias1))
		DbSelectArea(cAlias1)
		(cAlias1)->(dbCloseArea())
	Endif
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery1),cAlias1,.T.,.T.)
	
	dbSelectArea(cAlias1)
	(cAlias1)->(dbGoTop())
	
	While (cAlias1)->(!Eof())
		
		_cRegras	+= AllTrim((cAlias1)->ZC_CODIGO)+"#"
		
		(cAlias1)->(DbSkip())
		
	EndDo
	
	If Empty(_cRegras)
		MsgAlert("Aten��o, usu�rio sem acesso para efetuar manuten��es em pedidos de compra, verifique!")
	 			Return(.F.)
		 
	EndIf
	If "000001" $ _cRegras //Regra 1 - Acesso completo
		Return(.T.)
	EndIf
	
	If "000002" $ _cRegras .And. AllTrim(SA2->A2_CGC)=="06048486000114" .And. cEmpAnt=="01" //Regra 2 - Somente Steck MAO
		Return(.T.)
	EndIf
	
	If "000003" $ _cRegras .And. AllTrim(SA2->A2_EST)=="EX" //Regra 3 - Somente fornecedores estrangeiros
		Return(.T.)
	EndIf
	
	If "000004" $ _cRegras .And. AllTrim(SA2->A2_CGC) $ "06048486000114#05890658000130#05890658000210#05890658000482" //Regra 4 - Qualquer Steck
		Return(.T.)
	EndIf
	
	If !_lRet
		MsgAlert("Aten��o, voc� n�o tem acesso para efetuar essa manuten��o no pedido de compra, verifique!")
	EndIf
	
	RestArea(_aArea)
	
Return(_lRet)
