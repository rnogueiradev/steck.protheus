User Function AtuSE1()

DbSelectArea("SE1")  
DbSetOrder(1)
SE1->(dbGoTop())

While !SE1->(EOF())
	
	RecLock("SE1",.F.)
	SE1->E1_VENCREA := DataValida(SE1->E1_VENCREA)
	MsUnlock()		
	SE1->(DbSkip())  
	
EndDo

	MsgAlert("Finalizou!")                                                  

Return