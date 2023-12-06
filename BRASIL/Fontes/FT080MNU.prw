#include 'Protheus.ch'
#include 'FWMVCDEF.ch'
#Define CR chr(13)+chr(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFT080MNU บAutor  ณRenato Nogueira      บ Data ณ  13/07/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPonto de entrada para retirar op็๕es do menu de regra de    บฑฑ
ฑฑบ          ณdesconto                                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function FT080MNU()
	Local _cUser := GetMv("ST_FATA080",,"000000/000645/000231")
	
	aRotina	:= {}
	If __cuserid $ _cUser
		
		aRotina := {	{ "Pesquisar","AxPesqui"		,0,1,0,.F.},;	// "Pesquisar"
		{ "Visualizar","Ft080RDes"	,0,2,0,NIL},;	// "Visualizar"
		{ "Incluir",""		,0,3,0,NIL},;			// "Incluir"
		{ "Alterar","Ft080RDes"		,0,4,0,NIL},;	// "Alterar"
		{ "Excluir","Ft080RDes"		,0,5,0,NIL},;	// "Excluir"
		{ "Copiar","Ft080Copia"		,0,6,0,NIL}}	// "Copiar"
		
	Else
		aAdd(aRotina,{"Pesquisa"  	, "AxPesqui"    , 0 , 1, 0, .F.})
		aAdd(aRotina,{"Visualizar"  , "Ft080RDes"   , 0 , 2, 0,    })
	EndIf
Return()


