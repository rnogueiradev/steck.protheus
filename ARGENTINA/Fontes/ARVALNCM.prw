#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"

/*/{Protheus.doc} u_ARVALNCM()

CONFIGURACION DE CAMPOS CERTIFICADO / VENCIMIENTO EN FICHA DE STOCK

@type function
@author Everson Santana
@since 12/07/2019
@version Protheus 12 - Estoque/Custos

@history ,Ticket 20190702000051 ,

/*/

User Function ARVALNCM(_cCampo)

	Local _lRet    		:= .F.
	Default _cCampo 	:= ""

	If Empty(_cCampo)
		_cCampo := PADR(StrTran(ReadVar(),"M->",""),10)
	Else
		_cCampo := PADR(_cCampo,10)
	EndIf

	If INCLUI .OR. ALTERA

		If Alltrim(_cCampo) $ "B1_XSEGURI"

			If &(UPPER("M->"+_cCampo)) = "1"
				_lRet := .T.
			Else

				If &(UPPER("M->"+_cCampo)) = "2"

					_lRet := .T.

				Else

					_lRet := .F.

				EndIf

			EndIF
		EndIf

		If Alltrim(_cCampo) $ "B1_XCERT"

			If !Empty(&(UPPER("M->"+_cCampo)))

				If &(UPPER("M->B1_XSEGURI")) = "2"

					If Alltrim(&(UPPER("M->"+_cCampo))) $ "NO TENEMOS"
						_lRet := .f.
					Else
						_lRet := .T.
					EndIF
				Else
					If Alltrim(&(UPPER("M->"+_cCampo))) $ "EXCEPCION"
						_lRet := .f.
					Else
						_lRet := .T.
					EndIF
				EndIf
			Else
				_lRet := .F.
			EndIF
		EndIf

	EndIf

Return(_lRet)