	///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | MBrowse_Ax.prw       | AUTOR | Fernando Jose  DATA | 10/12/2009 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Manutencao em comissoes produto / Grupo                         |//
//+-----------------------------------------------------------------------------+//
//| MANUTENCAO DESDE SUA CRIACAO                                                |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////

/*
+------------------------------------------------------------------------------
| Par�metros dos Ax...()
+------------------------------------------------------------------------------
| AxVisual(cAlias,nReg,nOpc,aAcho,nColMens,cMensagem,cFunc,aButtons)
| AxAltera(cAlias,nReg,nOpc,aAcho,aCpos,nColMens,cMensagem,cTudoOk,cTransact,cFunc,aButtons)
| AxInclui(cAlias,nReg,nOpc,aAcho,cFunc,aCpos,cTudoOk,lF3,cTransact,aButtons)
| AxDeleta(cAlias,nReg,nOpc,cTransact,aCpos,aButtons)
+------------------------------------------------------------------------------
| Func      - Fun��o chamado antes de montar a tela - nenhum retorno esperado
| cTudoOk   - Ao clicar no Ok, esperado .T. ou .F.
| cTransact - Fun��o chamado depois da grava��o dos dados - nenhum retorno esperado
| aAcho     - Campos visiveis
| aCpos     - Campos alteraveis
| aButtons  - {{"BMP",{||UserFunc()},"LegendaMouse"}}
| nColMens  - Parametro invalido
| cMensagem - Parametro invalido
| lF3       - Parametro invalido
+------------------------------------------------------------------------------

+------------------------------------------------------------------------------
| Par�metros do mBrowse()
+------------------------------------------------------------------------------
| mBrowse( uPar1, uPar2, uPar3, uPar4, cAlias, aFixos, cCpo, uPar5, cFunc, ;
|          nPadrao, aCores, cExpIni, cExpFim, nCongela )
+------------------------------------------------------------------------------
| uPar1....: N�o obrigat�rio, par�metros reservado
| uPar2....: N�o obrigat�rio, par�metros reservado
| uPar3....: N�o obrigat�rio, par�metros reservado
| uPar4....: N�o obrigat�rio, par�metros reservado
| cAlias...: Alias do arquivo a ser visualizado no browse
| aFixos...: Contendo os nomes dos campos fixos pr�-definidos pelo programador,
|            obrigando a exibi��o de uma ou mais colunas
|            Ex.: aFixos := {{ "??_COD",  Space(6) },;
|                            { "??_LOJA", Space(2) },;
|                            { "??_NOME", Space(30) }}
| cCpo.....: Campo a ser validado se est� vazio ou n�o para exibi��o do bitmap de status
| uPar5....: N�o obrigat�rio, par�metros reservado
| cFunc....: Fun��o que retornar� um valor l�gico para exibi��o do bitmap de status
| nPadrao..: N�mero da rotina a ser executada quando for efetuado um duplo clique 
|            em um registros do browse. Caso n�o seja informado o padr�o ser� executada 
|            visualiza��o ou pesquisa
| aCores...: Este vetor possui duas dimens�es, a primeira � a fun��o de valida��o 
|            para exibi��o do bitmap de status, e a segunda o bitmap a ser exibido
|            Ex.: aCores := {{ "??_STATUS == ' ', "BR_VERMELHO" },;
|                            { "??_STATUS == 'S', "BR_VERDE"    },;
|                            { "??_STATUS == 'N', "BR_AMARELO"  }}
| cExpIni..: Fun��o que retorna o conte�do inicial do filtro baseada na chave de �ndice selecionada
| cExpFim..: Fun��o que retorna o conte�do final do filtro baseada na chave de �ndice selecionada
| nCongela.: Coluna a ser congelado no browse
+------------------------------------------------------------------------------
*/

#include "protheus.ch"

User Function CadSZ3()

Private cAlias := "SZ3"
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
//|           | Ativa o menu no bot�o                                           |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
Static Function AtivaMenu()
Local oWnd
oWnd := GetWndDefault()
oMenu:Activate(395,41,oWnd)
//oMenu:Activate(270,25,oWnd)
Return
