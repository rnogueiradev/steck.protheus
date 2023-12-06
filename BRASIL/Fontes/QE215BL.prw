#Include 'Protheus.ch'

/*/{Protheus.doc} QE215BL
Ponto de entrada para validar a qualidade.
@author Robson Mazzarotto
@since 20/07/2017
@version 1.0
/*/

User Function QE215BL()

Local _cArea  := getarea()
Local lRet    := .T.
				
		dbSelectArea("CBA")
		DbOrderNickName("STINVROT")
		dbGotop()
		
		IF dbSeek(xFilial("CBA")+M->QEK_PRODUT+"1")
		
			while !EOF() .and. CBA->CBA_PROD+CBA->CBA_XROTAT ==  M->QEK_PRODUT+"1" 
		
				IF CBA->CBA_STATUS >= "1" .and. CBA->CBA_STATUS < "5"
				MSGAlert("Este produto não poder ser liberado pois está em inventario rotativo !!!")
				lRet := .F.	
				Endif
						
			dbSkip()
			End
	
		Endif
	
	
	RestArea(_cArea)

Return lRet




		