//FUNCION PARA MANDAR IMPRIMIR EL PEDIDO DE VENTA AL FINALIZAR LA GRABACION

USER FUNCTION MT410INC
	_lRet := MsgYesNo("Desea Imprimir el Pedido?","Pedido de Venta ")
	IF _lRet
	    U_PEDVTA(1)		// Desde el Pedido de Venta
	Endif
Return    

//CUANDO ES UNA COPIA SE MANDARA IMPRIMIR POR EL PE 
User Function M410STTS()
/*
3 - Inclusión
4 - Alteración
5 - Exclusión
6 - Copia
7 - Devolucion de Compras
*/

Local _nOper := PARAMIXB[1]

If _nOper == 6 //Copia
	_lRet := MsgYesNo("Desea Imprimir el Pedido?","Pedido de Venta ")
	IF _lRet
	    U_PEDVTA(1)		// Desde el Pedido de Venta
	Endif
EndIf

Return Nil


