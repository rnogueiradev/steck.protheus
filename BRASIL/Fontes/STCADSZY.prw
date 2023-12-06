#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTCADSZY   บAutor  ณRenato Nogueira    บ Data ณ  24/11/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Tela para cadastro de observa็๕es expedi็ใo    	          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/      

User Function STCADSZY()

Private cCadastro := "Cadastro de observa็๕es"
Private cAlias := "SZY"
Private aRotina := {{ "Pesquisar"  , "PesqBrw" ,  0 , 1 },;
					{ "Visualizar" , "AxVisual" , 0 , 2 },;
					{ "Incluir"    , "AxInclui" , 0 , 3 },;
					{ "Alterar"    , "AxAltera" , 0 , 4 },;
					{ "Excluir"    , "AxDeleta" , 0 , 5 }}

dbSelectArea(cAlias)
dbSetOrder(1)       

mBrowse(,,,,cAlias)

Return()



User Function STCADZ1V()

Private cCadastro := "Cadastro de observa็๕es"
Private cAlias := "Z1V"
Private aRotina := {{ "Pesquisar"  , "PesqBrw" ,  0 , 1 },;
					{ "Visualizar" , "AxVisual" , 0 , 2 },;
					{ "Incluir"    , "AxInclui" , 0 , 3 },;
					{ "Alterar"    , "AxAltera" , 0 , 4 },;
					{ "Excluir"    , "AxDeleta" , 0 , 5 }}

dbSelectArea(cAlias)
dbSetOrder(1)       

mBrowse(,,,,cAlias)

Return()