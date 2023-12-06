#INCLUDE "PROTHEUS.CH"


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �STTMKC01   �Autor  �Renato Nogueira    � Data �  23/01/13    ���
�������������������������������������������������������������������������͹��
���Desc.     � Tela para manuten��o de cadastros de classifica��es        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/      

User Function STTMKC02()

Private cCadastro := "Cadastro de letras - Clas. Fiscal"
Private cAlias := "SZ4"
Private aRotina := {{ "Pesquisar"  , "PesqBrw" ,  0 , 1 },;
					{ "Visualizar" , "AxVisual" , 0 , 2 },;
					{ "Incluir"    , "AxInclui" , 0 , 3 },;
					{ "Alterar"    , "AxAltera" , 0 , 4 },;
					{ "Excluir"    , "AxDeleta" , 0 , 5 }}

dbSelectArea(cAlias)
dbSetOrder(1)       

mBrowse(,,,,cAlias)

Return()



User Function STCADCB3()

Private cCadastro := "Embalagens Steck"
Private cAlias := "CB3"
Private aRotina := {{ "Pesquisar"  , "PesqBrw" ,  0 , 1 },;
					{ "Visualizar" , "AxVisual" , 0 , 2 },;
					{ "Incluir"    , "AxInclui" , 0 , 3 },;
					{ "Alterar"    , "AxAltera" , 0 , 4 },;
					{ "Excluir"    , "AxDeleta" , 0 , 5 }}

dbSelectArea(cAlias)
dbSetOrder(1)       

mBrowse(,,,,cAlias)

Return()
