#Include "Protheus.ch"
#Include "FWMvcDef.CH"
#include "topconn.ch"
#Define CR chr(13)+ chr(10)

/*/{Protheus.doc} MTA160MNU

Ponto de entrada para limpar o flag do campo C8_XENVMAI

@type function
@author Everson Santana
@since 07/03/19
@version Protheus 12 - Compras

@history ,Chamado 009244 ,

/*/
User Function MTA160MNU()

	aadd(aRotina,{"Reenviar Cotação","U_STLIMPCOT",0,6,0,nil})

Return (aRotina)
