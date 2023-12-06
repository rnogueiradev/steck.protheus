#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} u_F087AF3()

Ponto de Entrada que permite numeracao automatica nos recibos

@type function
@author Jose C. Frasson
@since 08/06/2020
@version Protheus 12 - Faturamento

@history ,Ticket 20190624000060,

/*/

User Function F087AF3()
Local cAlias := "SA1"
	cRecibo := GETSXENUM("SEL","EL_RECIBO")
Return(cAlias)
