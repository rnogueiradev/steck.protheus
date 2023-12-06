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
| Parâmetros dos Ax...()
+------------------------------------------------------------------------------
| AxVisual(cAlias,nReg,nOpc,aAcho,nColMens,cMensagem,cFunc,aButtons)
| AxAltera(cAlias,nReg,nOpc,aAcho,aCpos,nColMens,cMensagem,cTudoOk,cTransact,cFunc,aButtons)
| AxInclui(cAlias,nReg,nOpc,aAcho,cFunc,aCpos,cTudoOk,lF3,cTransact,aButtons)
| AxDeleta(cAlias,nReg,nOpc,cTransact,aCpos,aButtons)
+------------------------------------------------------------------------------
| Func      - Função chamado antes de montar a tela - nenhum retorno esperado
| cTudoOk   - Ao clicar no Ok, esperado .T. ou .F.
| cTransact - Função chamado depois da gravação dos dados - nenhum retorno esperado
| aAcho     - Campos visiveis
| aCpos     - Campos alteraveis
| aButtons  - {{"BMP",{||UserFunc()},"LegendaMouse"}}
| nColMens  - Parametro invalido
| cMensagem - Parametro invalido
| lF3       - Parametro invalido
+------------------------------------------------------------------------------

+------------------------------------------------------------------------------
| Parâmetros do mBrowse()
+------------------------------------------------------------------------------
| mBrowse( uPar1, uPar2, uPar3, uPar4, cAlias, aFixos, cCpo, uPar5, cFunc, ;
|          nPadrao, aCores, cExpIni, cExpFim, nCongela )
+------------------------------------------------------------------------------
| uPar1....: Não obrigatório, parâmetros reservado
| uPar2....: Não obrigatório, parâmetros reservado
| uPar3....: Não obrigatório, parâmetros reservado
| uPar4....: Não obrigatório, parâmetros reservado
| cAlias...: Alias do arquivo a ser visualizado no browse
| aFixos...: Contendo os nomes dos campos fixos pré-definidos pelo programador,
|            obrigando a exibição de uma ou mais colunas
|            Ex.: aFixos := {{ "??_COD",  Space(6) },;
|                            { "??_LOJA", Space(2) },;
|                            { "??_NOME", Space(30) }}
| cCpo.....: Campo a ser validado se está vazio ou não para exibição do bitmap de status
| uPar5....: Não obrigatório, parâmetros reservado
| cFunc....: Função que retornará um valor lógico para exibição do bitmap de status
| nPadrao..: Número da rotina a ser executada quando for efetuado um duplo clique 
|            em um registros do browse. Caso não seja informado o padrão será executada 
|            visualização ou pesquisa
| aCores...: Este vetor possui duas dimensões, a primeira é a função de validação 
|            para exibição do bitmap de status, e a segunda o bitmap a ser exibido
|            Ex.: aCores := {{ "??_STATUS == ' ', "BR_VERMELHO" },;
|                            { "??_STATUS == 'S', "BR_VERDE"    },;
|                            { "??_STATUS == 'N', "BR_AMARELO"  }}
| cExpIni..: Função que retorna o conteúdo inicial do filtro baseada na chave de índice selecionada
| cExpFim..: Função que retorna o conteúdo final do filtro baseada na chave de índice selecionada
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
//|           | Ativa o menu no botão                                           |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
Static Function AtivaMenu()
Local oWnd
oWnd := GetWndDefault()
oMenu:Activate(395,41,oWnd)
//oMenu:Activate(270,25,oWnd)
Return
