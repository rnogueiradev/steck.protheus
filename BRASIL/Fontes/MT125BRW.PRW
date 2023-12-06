#INCLUDE "PROTHEUS.CH"

/*/Protheus.doc MT125BRW
@(long_description) Inclusão do botão no aRotina para o Tracking do Contrato de Parceria
@type Function MT125BRW
@author Eduardo Pereira - Sigamat
@since 09/02/2021
@version 12.1.25
see (links_or_references) https://tdn.totvs.com/pages/releaseview.action?pageId=6085489
/*/

User Function MT125BRW()

aAdd( aRotina, {"Tracking Contrato Parceria", "U_STBRTRCK()", 0, 2, 0, Nil} )
aAdd( aRotina,{ "Anexar Documento","U_STAnexoV('SC3', 'ContratoParceria', {'C3_FILIAL','C3_USER','NOUSER'},,SC3->C3_NUM)", 0, 4, 0, Nil })     // Valdemir Rabelo Ticket: 20210623010642 - 29/06/2021

Return aRotina
