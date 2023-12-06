#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "ParmType.ch"

/*====================================================================================\
|Programa  | TK271END        | Autor | GIOVANI.ZAGO             | Data | 18/02/2013   |
|=====================================================================================|
|Descricao |  Ponto de Entrada                                                        |
|          |  Executado no final da gravacao, ao dar o OK na tela de atendimento      |
|          |  e apos a gravacao da campanha (caso exista uma).                       |
|=====================================================================================|
|Sintaxe   | TK271END                                                                 |
|=====================================================================================|
|Uso       | Após gravar o orçaamento, gerar um arquivo .CSV dos itens                |
|          | codigo produto;                                                          |
|          | qtde;                                                                    |
|          | vlr unitario;                                                            |
|          | % desconto;                                                              |
|          | preço lista                                                              |
|          |                                                                          |
|          | Este arquivo .csv devera ser enviado via wf para o vendedor             |
|          | e seu superior                                                           |
|=====================================================================================|
|........................................HistÃ³rico...................................|
\====================================================================================*/
User Function TK271END()

Local cOrc      := SUA->UA_NUM
Local cVend     := SUA->UA_VEND
Local lEnvCSV   := .F.

Return

