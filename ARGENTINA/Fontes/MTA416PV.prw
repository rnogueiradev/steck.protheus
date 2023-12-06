#INCLUDE "Topconn.ch"
#INCLUDE "Protheus.ch"

/*/{Protheus.doc} MTA416PV

Punto de entrada para cargar la información de la orden de compra y las observaciones para el pedido.

@type function
@author Everson Santana
@since 14/06/18
@version Protheus 12 - Facturacion

@history , ,

/*/

User Function MTA416PV()

  M->C5_XORPC	:= SCJ->CJ_XORPC
  M->C5_XOBS	:= SCJ->CJ_XOBS
  M->C5_XNORC	:= SCJ->CJ_NUM
  M->C5_XUSRINC := SCJ->CJ_XUSRINC
  M->C5_XNOME 	:= Posicione("SA1",1,xFilial("SA1")+SCJ->CJ_CLIENTE+SCJ->CJ_LOJA,"A1_NOME") //Ticket 20190917000021 - Everson Santana - 18.09.2019

Return
