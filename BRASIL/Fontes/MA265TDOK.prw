#Include 'Protheus.ch'

/*/{Protheus.doc} MA265TDOK
Ponto de entrada para validar se o produto pode ser endereçado, estando em processo de inventario rotativo.
Chamado 001223 - Robson Mazzarotto
@author Robson Mazzarotto
@since 20/04/2017
@version 1.0
/*/

User Function MA265TDOK()

	Local lRet := .T.
	Local aArea    := GetArea()

	dbSelectArea("CBA")
	CBA->(dbSetOrder(4))
	CBA->(dbGoTop())
	If CBA->(dbSeek(xFilial("CBA")+SDA->DA_PRODUTO+"1"+SDA->DA_LOCAL))
			
		while CBA->(!eof()) .and. SDA->DA_PRODUTO == CBA->CBA_PROD .AND. CBA->CBA_XROTAT = "1" .AND. SDA->DA_LOCAL == CBA->CBA_LOCAL
			
			if CBA->CBA_STATUS $ "1/2/3/4"
			
				MSGALERT("Este item está em inventario rotativo e não pode ser endereçado!")
				Return .F.
				lRet := .F.
				
			elseif CBA->CBA_STATUS = "5"
				     
				dbSelectArea("SB7")
				SB7->(dbSetOrder(3))
				SB7->(dbGoTop())
				If SB7->(dbSeek(xFilial("SB7")+CBA->CBA_CODINV))
				    
					if SB7->B7_STATUS = "1"
						MSGALERT("Este item está em inventario rotativo e não pode ser endereçado!")
						Return .F.
						lRet := .F.
				     
					endif
				     
				endif
					
			endif
			
			
			CBA->(dbSkip())
		end
							
	Endif

	RestArea(aArea)
Return lRet

