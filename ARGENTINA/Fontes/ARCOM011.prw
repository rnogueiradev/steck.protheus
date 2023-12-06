#Include "Rwmake.ch"
#Include "Topconn.ch"


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ARCOM011   �Autor  �Cristiano Pereira   � Data �  11/23/18  ���
�������������������������������������������������������������������������͹��
���Desc.     �Seleciona a conta cont�bil no cadastro de eventos           ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function ARCOM011()

Local cQuery := ""
Local _xRet   := ""
Local _xAtu   := ""
Local _nProd := aScan(aHeader,{|x| AllTrim(x[2]) == "D1_COD"	} )
Local _nCont := aScan(aHeader,{|x| AllTrim(x[2]) == "D1_CONTA"	} )


_xAtu :=  aCols[n,_nCont]



cQuery := " SELECT CQK.CQK_DEBITO AS DEBITO                  "
cQuery += " FROM "+RetSqlName("CQK")+" CQK                   "
cQuery += " WHERE CQK.CQK_FILIAL = '"+xFilial("CQK")+"'  AND "
cQuery += "       CQK.D_E_L_E_T_ <>'*'                   AND "
cQuery += "       CQK.CQK_XPROD='"+aCols[n,_nProd]+"'        AND "
cQuery += "       CQK.CQK_CCD='"+M->D1_CC+"'               "

cAlias := GetNextAlias()

//�������������������������������Ŀ
//� Fecha Alias se estiver em Uso �
//���������������������������������
If !Empty(Select(cAlias))
	DbSelectArea(cAlias)
	(cAlias)->(dbCloseArea())
Endif

//�������������������������������������������Ŀ
//� Monta Area de Trabalho executando a Query �
//���������������������������������������������
DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),cAlias,.T.,.T.)

DbSelectArea(cAlias)
(cAlias)->(dbGoTop())
If !(cAlias)->(Eof())
	_xRet := (cAlias)->DEBITO
Endif

If 	!Empty(_xRet)
	aCols[n,_nCont]:=_xRet
Endif


return(.T.)
