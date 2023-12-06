#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"

/*/{Protheus.doc} STEDB1LE

Função para Edição do Campo B1_LE

@type function
@author Everson Santana
@since 22/02/19
@version Protheus 12 - Estoque/Custos

@history ,Chamado 009197 ,

/*/

User Function STEDB1LE()

	Local _lRet := .F.

	If SubString(SB1->B1_COD,1,1) $ 'U#E'

		_lRet := .T.

	Else

		If __cUserId $ GetMv("ST_USRALT2")

			_lRet := .T.

		Else

			_lRet := .F.
		EndIf

	EndIf 



Return(_lRet)