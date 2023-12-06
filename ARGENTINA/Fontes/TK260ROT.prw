#INCLUDE 'PROTHEUS.CH'
#INCLUDE "TOPCONN.CH"

/*/{Protheus.doc} TK260ROT
Menu Outras Acoes Prospect
@type function
@author Jose C. Frasson
@since 	06/05/2020
@version Protheus 12 - Faturamento
@history ,Ticket 20191211000031 ,
/*/

User Function TK260ROT()
Local aRotina := {}

aAdd(aRotina,{"Comp.Prospect","u_ARRFAT12", 0, Len(aRotina)+1, 0, .F. })

Return(aRotina)