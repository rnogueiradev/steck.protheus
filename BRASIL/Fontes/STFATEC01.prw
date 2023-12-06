#include 'Protheus.ch'
#include 'FWMVCDEF.ch'
#Define CR chr(13)+chr(10)
/*====================================================================================\
|Programa  | STFATEC01         | Autor | GIOVANI.ZAGO             | Data | 04/05/2015  |
|=====================================================================================|
|Descri็ใo |  STFATEC01    Monta tela de manuten็ใo do embarque                        |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STFATEC01                                                                 |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Hist๓rico....................................|
\====================================================================================*/
*-----------------------------*
User Function STFATEC01()
	Local cAlias  := "SZ9"
	Local cTitle  := "Fatec-XML"
	Local oBrowse := FWMBrowse():New()	
	Private aRotina := MenuDef() 
		DbSelectArea("SZ9")
	SZ9->(dbSetFilter({|| SZ9->SZ9_C14 <> ' ' },"SZ9->Z9_C14 <> ' ' "))
	oBrowse:SetAlias(cAlias)
	oBrowse:SetDescription(cTitle)
	oBrowse:AddLegend("Empty( SZ9->Z9_C15)", "GREEN" ,"Aberto")
	oBrowse:AddLegend("!(Empty( SZ9->Z9_C15))", "RED"  ,"Finalizado")
	
	oBrowse:Activate()
	
	 
	
Return NIL

// ------------------------------------------------------------------------------------------ //
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMenuDef    บAutor  ณGiovani Zago       บ Data ณ  07/10/2015 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo para gerar os bot๕es da rotina de Embarque           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Steck Industria Eletrica Ltda.                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑบRotina    ณ STFATEC01.prw                                               บฑฑ
ฑฑบNome      ณ Gera็ใo de Embarque                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function MenuDef()
	
	Local aRotina := {}
	
	ADD OPTION aRotina TITLE "Pesquisar"            ACTION "PESQBRW"           OPERATION 1  ACCESS 0
	ADD OPTION aRotina TITLE "Visualizar"           ACTION "VIEWDEF.STFATEC01" OPERATION 2  ACCESS 0
	ADD OPTION aRotina TITLE "Incluir"              ACTION "VIEWDEF.STFATEC01" OPERATION 3  ACCESS 0
	ADD OPTION aRotina TITLE "Alterar"              ACTION "VIEWDEF.STFATEC01" OPERATION 4  ACCESS 0
	ADD OPTION aRotina TITLE "Excluir"              ACTION "VIEWDEF.STFATEC01" OPERATION 5  ACCESS 0
	ADD OPTION aRotina TITLE "Imprimir"             ACTION "VIEWDEF.STFATEC01" OPERATION 6  ACCESS 0
	ADD OPTION aRotina TITLE "Fechar"               ACTION "U_STOPCEMP('1')"  OPERATION 7  ACCESS 0
	ADD OPTION aRotina TITLE "Reabrir"              ACTION "U_STOPCEMP('2')"  OPERATION 8  ACCESS 0
	ADD OPTION aRotina TITLE "Gerar NF"             ACTION "U_STOPCEMP('3')"  OPERATION 9  ACCESS 0
	ADD OPTION aRotina TITLE "Confer๊ncia Embarque" ACTION "U_STOPCEMP('4')"  OPERATION 10 ACCESS 0
	ADD OPTION aRotina TITLE "Totalizador Embarque" ACTION "U_STOPCEMP('5')"  OPERATION 11 ACCESS 0
	ADD OPTION aRotina TITLE "Anแlise de Produto"   ACTION "U_STOPCEMP('6')"  OPERATION 12 ACCESS 0
	If   __cUserId $ GetMv("ST_C9ERRO",,'000000')+'000000/000645'
		ADD OPTION aRotina TITLE "Ajusta NF c\ Erro."   ACTION "U_C9ERRO( )"  OPERATION 12 ACCESS 0
	EndIf
	
Return aRotina

