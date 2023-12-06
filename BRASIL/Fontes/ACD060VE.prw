#Include 'Protheus.ch'

/*/{Protheus.doc} ACD060VE
Ponto de entrada no ACD para validar o endereçamento.
@author Robson Mazzarotto
@since 20/07/2017
@version 1.0
/*/


User Function ACD060VE()

	Local _cArea  := getarea()
	Local lRet    := .T.
				
		dbSelectArea("CBA")
		DbOrderNickName("STINVROT2")
		dbGotop()
		
		IF dbSeek(xFilial("CBA")+cArmEti+cProd+cEndereco)
		
			while !EOF() .and. CBA->CBA_LOCAL+CBA->CBA_PROD+CBA->CBA_LOCALI ==  cArmEti+cProd+cEndereco 
		
				IF CBA->CBA_STATUS >= "1" .and. CBA->CBA_STATUS < "5"
				VTAlert("Este produto nao poder ser enderecado pois esta em inventario rotativo !!!","Aviso",.T.,3000,2)
				VTKeyBoard(chr(20))
				lRet := .F.	
				Endif
							
			dbSkip()
			End
	
		Endif
	
	
	RestArea(_cArea)
Return lRet

