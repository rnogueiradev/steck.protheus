#Include "Protheus.ch"
#Include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �STVLDSGG  �Autor  �Renato Nogueira     � Data �  16/09/13   ���
�������������������������������������������������������������������������͹��
���Desc.     �Valida��o utilizada para verificar se o componente possui   ���
���          �cadastro de estrutura na SGG                                ���
�������������������������������������������������������������������������͹��
���Uso       � Steck                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function STVLDSGG(cProduto)

Local aArea     := GetArea()
Local aAreaSGG  := SGG->(GetArea())
Local cQuery 	:= ""
Local cAlias 	:= "QRYTEMP"
Local lRet		:= .T.

DbSelectArea("SB1")
DbSetOrder(1)
DbSeek(xFilial("SB1")+cProduto)

If SB1->B1_CLAPROD=="F"
	
	cQuery	:= " SELECT COUNT(*) CONTADOR "
	cQuery  += " FROM " +RetSqlName("SGG")+ " GG "
	cQuery  += " WHERE GG.D_E_L_E_T_=' ' AND GG_COD='"+cProduto+"' "
	
	If !Empty(Select(cAlias))
		DbSelectArea(cAlias)
		(cAlias)->(dbCloseArea())
	Endif
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)
	
	dbSelectArea(cAlias)
	(cAlias)->(dbGoTop())
	
	If (cAlias)->(CONTADOR)=0
		lRet := .F.
		MsgInfo("Aten��o, esse produto � fabricado e n�o possui estrutura cadastrada","Erro")
	EndIf
	
EndIf

RestArea(aAreaSGG)
RestArea(aArea)

Return(lRet)