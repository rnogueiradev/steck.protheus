#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"

/*/{Protheus.doc} M130PROC
@name M130PROC
@type User Function
@desc filtro para gerar cotações
@author Renato Nogueira
@since 25/02/2019
/*/

User Function M130PROC()

	Local _cFiltro := ""

	_cFiltro += " C1_FILIAL||C1_NUM||C1_ITEM NOT IN
	_cFiltro += " (
	_cFiltro += " SELECT C8_FILIAL||C8_NUMSC||C8_ITEMSC FROM "+RetSqlName("SC8")+" C8 WHERE C8.D_E_L_E_T_=' '
	_cFiltro += " AND C8_FILIAL='"+xFilial("SC1")+"'
	_cFiltro += " )

Return(_cFiltro)