#Include 'Protheus.ch'

User Function STTRAINV(_cLoc,_cLocali,cTipo)

Local aArea     := GetArea()

IF cTipo = "1"

		dbSelectArea("SBE")
		dbSetOrder(1)
		dbGotop()
		
		IF dbSeek(xFilial("SBE")+_cLoc+_cLocali)
	
			RecLock('SBE',.F.)
			SBE->BE_DTINV := DDATABASE
			SBE->(MsUnLock())
	
		ENDIF

ELSE

		dbSelectArea("SBE")
		dbSetOrder(1)
		dbGotop()
		
		IF dbSeek(xFilial("SBE")+_cLoc+_cLocali)
	
			RecLock('SBE',.F.)
			SBE->BE_DTINV := CTOD("  /  /  ")
			SBE->(MsUnLock())
	
		ENDIF

ENDIF

RestArea(aArea)

Return

