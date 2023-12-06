#Include 'Protheus.ch'

User Function MT150END()

	Local nOp 		:= PARAMIXB[1]

	if nOp = 5

		dbSelectARea("SC1")
		dbSetOrder(1)
		dbGoTop()

		if dbSeek(xFilial("SC1")+SC8->C8_NUMSC+SC8->C8_ITEMSC)

			RecLock('SC1', .F.)
			SC1->C1_COTACAO := ""
			SC1->C1_PEDIDO	:= ""
			SC1->C1_ITEMPED	:= ""
			SC1->C1_FORNECE  	:= ""
			SC1->C1_LOJA      := ""
			SC1->C1_QUJE      := 0
			SC1->(MsUnlock())

		Endif

	Endif

Return Nil

