#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �STCQA002  �Autor  �Everaldo Gallo      � Data �  05/11/13   ���
�������������������������������������������������������������������������͹��
���Descricao � Cadastro de tipos de Perda  - Especifico Steck            ���
���          � Arquivo SX5 - Tabela 43              			          ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function STCQA002

Dbselectarea("SX5")
Set Filter to x5_tabela = "43"
_cTitulo := "Cadastro de Tipos de Perda"
                                                                              
AxCadastro("SX5",_cTitulo)
               
Set Filter to

Return .t.
