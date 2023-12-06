#INCLUDE "PROTHEUS.CH"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTTMKC01   บAutor  ณRenato Nogueira    บ Data ณ  23/01/13    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Tela para manuten็ใo de cadastros de classifica็๕es        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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
