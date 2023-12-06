#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �STCADSZ2  �Autor  �Renato Nogueira     � Data �  07/11/13   ���
�������������������������������������������������������������������������͹��
���Descricao � Cadastrar representante x produto - comiss�es		      ���
���          � 						                 			          ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function STCADSZ2()

Local cST_USRCOMIS	:= SuperGetMV("ST_USRCOMIS",,"")

If __cUserId $ cST_USRCOMIS

Dbselectarea("SZ2")

_cTitulo := "Cadastro de representante x produto"
                                                                              
AxCadastro("SZ2",_cTitulo)

Else

MsgAlert("Usu�rio sem permiss�o para utilizar essa rotina")

EndIf

Return .t.