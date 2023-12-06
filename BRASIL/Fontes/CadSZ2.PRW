///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | MBrowse_Ax.prw       | AUTOR | Fernando Jose  DATA | 10/12/2009 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Manutencao em comissoes produto / Grupo                         |//
//+-----------------------------------------------------------------------------+//
//| MANUTENCAO DESDE SUA CRIACAO                                                |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////

#include "protheus.ch"

User Function CadSZ2()

Private cAlias := "SZ2"
Private aRotina   := {}                               	
Private aSubRotina := {}
Private lRefresh  := .T.
Private cCadastro := "Cadastro de Percentual de Comissao"

aAdd( aRotina, {"Pesquisar" ,"AxPesqui",0,1} )
aAdd( aRotina, {"Visualizar","AxVisual",0,2} )
aAdd( aRotina, {"Incluir"   ,'AxInclui(cAlias,RecNo(),3,,,,,,,)',0,3} )
aAdd( aRotina, {"Alterar"   ,'AxAltera(cAlias,RecNo(),4)',0,4} )
aAdd( aRotina, {"Copia Produto"   ,"CpProd()",0,5} )
aAdd( aRotina, {"Excluir"   ,"AxDeleta",0,6} )

dbSelectArea(cAlias)
dbSetOrder(1)

mBrowse(,,,,cAlias)

Return

///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | MBrowse_Ax.prw       | AUTOR | Robson Luiz  | DATA | 18/01/2004 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - mBrowDel()                                             |//
//|           | Fonte utilizado no curso oficina de programacao.                |//
//|           | Exclui o registro em questao                                    |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////

Static Function CpProd()




Return   


///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | MBrowse_Ax.prw       | AUTOR | Robson Luiz  | DATA | 18/01/2004 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - AtivaMenu()                                            |//
//|           | Fonte utilizado no curso oficina de programacao.                |//
//|           | Ativa o menu no botão                                           |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
Static Function AtivaMenu()
Local oWnd
oWnd := GetWndDefault()
oMenu:Activate(395,41,oWnd)
//oMenu:Activate(270,25,oWnd)
Return
