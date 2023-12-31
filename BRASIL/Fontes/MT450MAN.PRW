#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWMVCDEF.CH"

/*====================================================================================\
|Programa  | MT450MAN        | Autor | RENATO.OLIVEIRA           | Data | 24/06/2020  |
|=====================================================================================|
|Descri��o | 													                      |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Hist�rico....................................|
\====================================================================================*/

User Function MT450MAN()

 	Local aArea := GetArea()
    Local aAreaC9 	:= SC9->(GetArea())
    Local lRet 		:= .T.
    
    DbSelectArea("SC5")
    SC5->(DbSetOrder(1))
    If SC5->(DbSeek(SC9->(C9_FILIAL+C9_PEDIDO)))
    	If AllTrim(SC5->C5_CONDPAG)=="501" .And. !AllTrim(SC5->C5_XLIBAVI)=="S"
    		If !MsgYesNo("Aten��o, pedido a vista sem libera��o comercial, deseja continuar?")
    			lRet := .F.
    		EndIf
    	EndIf
    EndIf
 
    RestArea(aAreaC9)
    RestArea(aArea)
    
Return lRet