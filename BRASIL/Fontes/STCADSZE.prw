#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �STCADSZD  �Autor  �Renato Nogueira     � Data �  22/07/2015 ���
�������������������������������������������������������������������������͹��
���Descricao � Cadastrar projetos suframa							      ���
���          � 						                 			          ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function STCADSZE()

Dbselectarea("SZE")

_cTitulo := "Cadastro de projetos suframa"
                                                                              
AxCadastro("SZE",_cTitulo)

Return .t.