#Include 'Protheus.ch'

User Function PMA200GRV()

Local aArea := GetArea()

IF M->AF8_FASE = "02" .and. AF8->AF8_FASE = "01" 

dbSelectArea("ZIR")
dbSetOrder(2)
dbGotop()

	if dbSeek(xFilial("ZIR")+AF8->AF8_PROJET)

			while !EOF() .AND. ZIR->ZIR_PROJET == AF8->AF8_PROJET

			RecLock('AFW',.T.)
 			AFW_RECURS := ZIR->ZIR_RECURS
			AFW_PROJET := ZIR->ZIR_PROJET 
			AFW_TAREFA := ZIR->ZIR_TAREFA
			AFW_DATA   := ZIR->ZIR_DATA 
			AFW_HORA   := ZIR->ZIR_HORA
			AFW->(MsUnLock())
			
			RecLock('ZIR',.F.)
			DbDelete()
			MsUnlock()
			dbSkip()		
			End

	Endif

Endif

RestArea( aArea )

Return .T.

