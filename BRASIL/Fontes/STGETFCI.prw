#Include "Protheus.ch"
#Include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �STGETFCI  �Autor  �Renato Nogueira     � Data �  01/10/13   ���
�������������������������������������������������������������������������͹��
���Desc.     �Fun��o para retornar o FCI do produto em quest�o			  ���
���          �															  ���
���          �					     								      ���
�������������������������������������������������������������������������͹��
���Uso       � Steck                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function STGETFCI(cProduto)

Local aArea     := GetArea()
Local cQuery 	:= ""
Local cAlias 	:= "QRYTEMP"

	cQuery	:= " SELECT CFD_COD CODIGO, MAX(R_E_C_N_O_) CFDRECNO "
	cQuery  += " FROM " +RetSqlName("CFD")+ " CFD "
	cQuery  += " WHERE CFD_COD='"+cProduto+"' AND CFD.D_E_L_E_T_= ' ' AND CFD_FILIAL = ' ' "
	cQuery  += " GROUP BY CFD_COD "
	
	If !Empty(Select(cAlias))
		DbSelectArea(cAlias)
		(cAlias)->(dbCloseArea())
	Endif
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)
	
	dbSelectArea(cAlias)
	(cAlias)->(dbGoTop())
	
	DbSelectArea("CFD")
	DbGoTop()
	DbGoTo((cAlias)->CFDRECNO)
	
    cFciCod	:= CFD->CFD_FCICOD
	
	If !Empty(Select(cAlias))
		DbSelectArea(cAlias)
		(cAlias)->(dbCloseArea())
	Endif
	

RestArea(aArea)

Return(cFciCod)