#Include "Protheus.ch"
#Include "FWMvcDef.CH"
#include "topconn.ch"

/*/{Protheus.doc} STCQ001

Complemento de Produtos CQ

@since 02/12/19
@version Protheus 12 - CQ

@history , ,

@type function
@author Everson Santana

/*/

User Function STCQ001()

Local   cAlias    := "Z62" 
Private cCadastro := OemToAnsi("Complemento de Produtos CQ")
Private aRotina   := {  { "Pesquisar"   ,"AxPesqui"      ,0,1},; 
                      	{ "Visualizar" ,"AxVisual"    	 ,0,2},; 
                        { "Incluir"     ,"AxInclui"      ,0,3},; 
                        { "Alterar"     ,"AxAltera"      ,0,4},; 
                        { "Excluir"     ,"AxDeleta"      ,0,5}} 

dbSelectArea(cAlias)
dbSetOrder(1)

//abre a tela de manutenção 

MBrowse(,,,,cAlias,,,,,,)
Return
