User Function AtuSE2()                   
Local I := 0

DbSelectArea("SE2")
DbSetOrder(1)
SE2->(dbGoTop())

While !SE2->(EOF())
	
	RecLock("SE2",.F.)
	SE2->E2_VENCREA := DataValida(SE2->E2_VENCREA)                      
	MsUnlock()
		
	SE2->(DbSkip())                               
EndDo                                             

	MsgALert("Finalizou")                              

Return                                             
