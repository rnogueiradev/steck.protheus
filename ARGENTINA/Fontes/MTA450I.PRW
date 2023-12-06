#INCLUDE "RWMAKE.CH"
#Include "Colors.ch"
#include 'Protheus.ch'

#Define CR chr(13)+chr(10)

/*/{Protheus.doc} MTA450I

Limpa flag do campo C5_XSTAFIN para controle de legenda

@type function
@author Everson Santana
@since 16/07/19
@version Protheus 12 - Faturamento

@history ,Ticket 20190712000006 ,

/*/

User Function MTA450I()

	Local cPedido     := SC9->C9_PEDIDO
	Local _cOpcao 	  := PARAMIXB[1]

	DbSelectArea("SC5")
	SC5->(DbSetOrder(1))
	If 	SC5->(DbSeek(xFilial("SC5")+cPedido))

		Reclock("SC5",.F.)

		SC5->C5_XSTAFIN  := ' '

		SC5->(MsUnLock())
		SC5->( DbCommit() )
	EndIf

Return()

