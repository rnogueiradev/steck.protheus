#Include 'Protheus.ch'

/*/{Protheus.doc} STMOTCOM
Fun��o para validar a permiss�o de colocar solicita��o de compras com o motivo APU por usuario.
@author Robson Mazzarotto
@since 18/07/2017
@version 1.0
/*/

User Function STMOTCOM()

Local aArea     := GetArea()
Local _STMOTCOM := SuperGetMV("ST_MOTCOM",.F.,"") // Chamado 005827 - Robson Mazzarotto

IF &(Readvar()) = "APU" 
	IF __cUserId $ _STMOTCOM 
		//OK
	ELSE
		MSGALERT("Us�ario n�o tem permiss�o para colocar este motivo de compras !")
		return .F. 
	ENDIF
ENDIF
RestArea(aArea)

Return .T.

