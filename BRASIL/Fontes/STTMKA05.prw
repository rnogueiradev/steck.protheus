#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STTMKA05     ºAutor  ³Renato Nogueira  º Data ³  02/06/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Fonte utilizado para restringir o uso de algumas condições  º±±
±±º          ³de pagamento					                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function STTMKA05(_cCondPag)

	Local aArea := GetArea()
	Local cFS_GRPSPVE	:= SuperGetMV("FS_GRPSPVE",,"")
	Local _aGrupos, _nPos
	Local _lRet	:= .T.
	Local _cTipo := ""

	If IsInCallStack("WSEXECUTE")
		Return(.T.)
	EndIf

	If   ( Type("l410Auto") == "U" .OR. !l410Auto )

		If IsInCallStack("U_STALTSC5")
			_cTipo := SC5->C5_TIPO
		Else
			_cTipo := M->C5_TIPO
		EndIf

		If AllTrim(_cTipo)=="B"
			Return(.T.)
		EndIf

		PswOrder(1)
		If PswSeek(__cUserId,.T.)
			_aGrupos	:= PswRet()
		EndIf

		If !IsInCallStack("EECAP100") //Verifica se não é chamado pelo EEC
			If  _aGrupos[1][10][1] $ cFS_GRPSPVE
				_lRet	:= .T.
			ElseIf !_aGrupos[1][10][1] $ cFS_GRPSPVE .And. !_cCondPag $ GetMv("ST_CONDPG",,"501#502#505#512#513#518#522#528#529#531#539#544#545#553#554#561#581#713")
				_lRet 	:= .F.
				MsgAlert("Essa condição de pagamento não pode ser utilizada, verifique as condições disponíveis na consulta!")
			EndIf
		EndIf

	EndIf

	restarea(aArea)

Return(_lRet)
