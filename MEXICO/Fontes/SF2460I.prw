//FUNCION PARA GRABAR DATOS DE PEDIDO DE VENTA A FACTURA
//STECK 20/01/2022  
User Function SF2460I()                
	Local _lPedidos := .F.
	Local _lRemito	:= .F.
	Local _cArea:= Getarea()
    IF FUNNAME()=="MATA468N" 
		Reclock("SF2",.F.)
		SF2->F2_FPAGO	:= SC5->C5_FPAGO
		SF2->F2_ORDENC	:= SC5->C5_ORDENC	
		Msunlock()
	Endif
	
    RestArea(_cArea)
Return
