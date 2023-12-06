#Include "Protheus.ch"
#Include "RWMake.ch"

/*/Protheus.doc MT122BRW
(long_description)
type User Function
@author Eduardo Pereira - Sigamat
@since 12/03/2021
@version 12.1.25
see (links_or_references) https://tdn.totvs.com/pages/viewpage.action?pageId=51249546
/*/

User Function MT122BRW()

aAdd(aRotina,{ "Imprimir P.C","U_RSTFAT92()", 0, 4, 0, Nil })
aAdd(aRotina,{ "Anexar Documento","U_STAnexoV('SC7', 'AutorizacaoEntrega', {'C7_FILIAL','C7_USER','NOUSER'},,SC7->C7_NUM)", 0, 4, 0, Nil })     // Valdemir Rabelo Ticket: 20210623010642 - 29/06/2021

Return aRotina
