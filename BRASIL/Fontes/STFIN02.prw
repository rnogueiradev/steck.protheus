#include "protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � STFIN02() �Autor  � Vitor Merguizo   � Data �  08/07/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina para detalhamento das atividades de consultoria     ���
���Desc.     �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Steck                                                      ���
�������������������������������������������������������������������������͹��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function STFIN02()

Private cCadastro := "Lista de Atividades - Consultoria"
Private aRotina := { {"Pesquisar","AxPesqui",0,1},;
                     {"Visualizar","AxVisual",0,2},;
                     {"Incluir","AxInclui",0,3},;
                     {"Alterar","AxAltera",0,4},;
                     {"Excluir","AxDeleta",0,5}}
Private cString := "SZZ"

dbSelectArea(cString)
dbSetOrder(1)

mBrowse(6,1,22,75,cString)

Return