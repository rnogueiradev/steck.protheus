#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �STCADSOF   �Autor  �Renato Nogueira    � Data �  30/04/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Tela para manuten��o de cadastros de softwares	          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/      

User Function STCADSOF()

Private cCadastro := "Cadastro de softwares"
Private cAlias := "ZZM"
Private aRotina := {{ "Pesquisar"  , "PesqBrw" ,  0 , 1 },;
					{ "Visualizar" , "AxVisual" , 0 , 2 },;
					{ "Incluir"    , "AxInclui" , 0 , 3 },;
					{ "Alterar"    , "AxAltera" , 0 , 4 },;
					{ "Excluir"    , "AxDeleta" , 0 , 5 }}

dbSelectArea(cAlias)
dbSetOrder(1)       

mBrowse(,,,,cAlias)

Return()