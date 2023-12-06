#Include 'Protheus.ch'

/*/{Protheus.doc} A260INI
Ponto de entrada para validar a transferencia.
@author Robson Mazzarotto
@since 20/07/2017
@version 1.0
/*/

User Function A260INI()

Local _cArea  := getarea()
Local lRet    := .T.
			
		dbSelectArea("CBA")
		DbOrderNickName("STINVROT2")
		dbGotop()
		
		//IF dbSeek(xFilial("CBA")+M->D3_LOCAL+M->D3_COD+M->D3_LOCALIZ)
		IF dbSeek(xFilial("CBA")+cLocOrig + cCodOrig + cLoclzOrig)
	
			while !EOF() .and. CBA->CBA_LOCAL+CBA->CBA_PROD+CBA->CBA_LOCALI ==  cLocOrig + cCodOrig + cLoclzOrig //M->D3_LOCAL+M->D3_COD+M->D3_LOCALIZ 
		
				IF CBA->CBA_STATUS >= "1" .and. CBA->CBA_STATUS < "5"
				MSGAlert("Este produto não poder ser endereçado pois está em inventario rotativo !!!")
				lRet := .F.	
				Endif
							
			dbSkip()
			End
	
		Endif
	
	RestArea(_cArea)

Return lRet







