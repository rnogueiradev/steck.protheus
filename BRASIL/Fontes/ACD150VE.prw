#Include 'Protheus.ch'

/*/{Protheus.doc} ACD150VE
Ponto de entrada no ACD para validar a transferencia.
@author Robson Mazzarotto
@since 20/07/2017
@version 1.0
/*/

User Function ACD150VE()

	Local _cArea  := getarea()
	Local lRet    := .T.
				
		dbSelectArea("CBA")
		DbOrderNickName("STINVROT3")
		dbGotop()
		
		IF dbSeek(xFilial("CBA")+cArmOri+cEndOri+"1")
		
			while !EOF() .and. CBA->CBA_LOCAL+CBA->CBA_LOCALI+"1" ==  cArmOri+cEndOri+"1" 
		
				IF CBA->CBA_STATUS >= "1" .and. CBA->CBA_STATUS < "5"
				VTAlert("Este produto nao poder ser transferido pois esta em inventario rotativo !!!","Aviso",.T.,3000,2)
				VTKeyBoard(chr(20))
				lRet := .F.	
				Endif
							
			dbSkip()
			End
	
		Endif
	
	
	RestArea(_cArea)
Return lRet

