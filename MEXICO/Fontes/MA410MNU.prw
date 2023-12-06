//agregar Opciones al Menu del Pedido de Ventas
USER FUNCTION MA410MNU
	Aadd(aRotina, { OemToAnsi("Imprimir Pedido"),"U_PEDVTA(1)"	,0,2,0 ,NIL})//"IMPRIMIR PEDIDO"
	aadd( aRotina, {"Importar CSV","U_FIMPCSVEXEC()",0,2,0,NIL} )	
Return




