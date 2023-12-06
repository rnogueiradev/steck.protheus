#Include 'Protheus.ch'

User Function MT340B2()

Local aArea     := GetArea()

		dbSelectArea("SBE")
		dbSetOrder(1)
		dbGotop()
		
		IF dbSeek(xFilial("SBE")+SB7->B7_LOCAL+SB7->B7_LOCALIZ)
	
			IF !EMPTY(SBE->BE_DTINV)
				RecLock('SBE',.F.)
				SBE->BE_DTINV := CTOD("  /  /  ")
				SBE->(MsUnLock())
			ENDIF	
	
		ENDIF


RestArea(aArea)

Return





Return

