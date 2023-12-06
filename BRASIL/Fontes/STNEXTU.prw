#Include "Protheus.ch"
#Include "TopConn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �STNEXTU	�Autor  �Renato Nogueira     � Data �  23/10/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Fonte utilizado pegar o �ltimo c�digo U e incrementar mais 1���
���          �									  	 				      ���
�������������������������������������������������������������������������͹��
���Parametro � Nenhum                                                     ���
�������������������������������������������������������������������������ͼ��
���Retorno   � Nenhum 										              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function STNEXTU()

Local cQuery   		:= ""
Local cAlias   		:= "QRYTEMP"
Local aCods			:= {}
Local cNextCod		:= ""
Local nNextNum		:= 0
 
cQuery	:= " SELECT SUBSTR(B1_COD,2,99999999999999999999999999) SEQ "
//cQuery	+= " FROM "+RetSqlName("SB1")+" B1 "
cQuery	+= " FROM  SB1010 SB1 "
cQuery 	+= " WHERE SB1.D_E_L_E_T_=' ' AND B1_COD LIKE 'U%' "
cQuery 	+= " AND B1_MSBLQL <> 1 "
cQuery	+= " ORDER BY B1_COD " 

cQuery += "UNION ALL "
 
cQuery	:= " SELECT SUBSTR(B1_COD,2,99999999999999999999999999) SEQ "
//cQuery	+= " FROM "+RetSqlName("SB1")+" B1 "
cQuery	+= " FROM  SB1030 SB13 "
cQuery 	+= " WHERE SB13.D_E_L_E_T_=' ' AND B1_COD LIKE 'U%' "
cQuery 	+= " AND B1_MSBLQL <> 1 "
cQuery	+= " ORDER BY B1_COD " 


If !Empty(Select(cAlias))
	DbSelectArea(cAlias)
	(cAlias)->(dbCloseArea())
Endif

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

dbSelectArea(cAlias)
(cAlias)->(dbGoTop())

While (cAlias)->(!Eof())

AADD(aCods,{Val((cAlias)->SEQ)}) 

(cAlias)->(DbSkip())
EndDo  

ASort(aCods,,,{|x,y| (x[1]) < (y[1])})
   
nNextNum	:= (aCods[len(aCods)][1])+1
cNextCod	:= "U"+CVALTOCHAR(nNextNum)

msgalert("Pr�ximo c�digo Unicom " + cNextCod + " favor digit�-lo") 

M->B1_COD	:= cNextCod

Return() 