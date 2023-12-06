#Include 'Protheus.ch'

User Function PM200FAS()

Local aArea := GetArea()

dbSelectArea("AFW")
dbSetOrder(2)
dbGotop()

IF AF8->AF8_FASE  = "02"

	if dbSeek(xFilial("AFW")+AF8->AF8_PROJET)


		If	MsgYesNo("Este projeto possui apontamentos pendentes, confirma a alteração de fase?")
	
				while !EOF() .AND. AFW->AFW_PROJET == AF8->AF8_PROJET

				RecLock('ZIR',.T.)
				ZIR_RECURS := AFW->AFW_RECURS
				ZIR_PROJET := AFW->AFW_PROJET
				ZIR_TAREFA := AFW->AFW_TAREFA
				ZIR_DATA   := AFW->AFW_DATA
				ZIR_HORA   := AFW->AFW_HORA
				ZIR->(MsUnLock())
							
				RecLock('AFW',.F.)
				DbDelete()
				MsUnlock()
				dbSkip()
				End

			MsgAlert("Pronto, a fase do projeto já pode ser alterada!")
		
		
		Endif
	
	Endif

Endif

RestArea( aArea )

Return 



