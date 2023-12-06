#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"

/*
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ?STINSFRE ³Autor  ?Renato Nogueira       ?Data ?8.08.2013 ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±?         ³Avalia a colocacao do tipo de frete   				       ³±?
±±?         ?                                                            ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ?Generico                                                    ³±?
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function STINSFRE(_cCliente,_cLoja,_cTipo)

	Local aArea     := GetArea()
	Local _lRet		:= .T.
	Local cFS_GRPSPVE	:= SuperGetMV("FS_GRPSPVE",,"")
	Local _aGrupos, _nPos
	Default	_cTipo	:= "N"

	PswOrder(1)
	If PswSeek(__cUserId,.T.)
		_aGrupos	:= PswRet()
	EndIf

	If ( Type("l410Auto") == "U" .OR. !l410Auto ) .And. _cTipo=="N"

		DbSelectArea("SA1")
		DbSetOrder(1)
		DbSeek(xFilial("SA1")+_cCliente+_cLoja)

		If !SA1->(Eof())

			If AllTrim(SA1->A1_TPFRET)=="C"

				_lRet	:= .T.

			ElseIf AllTrim(SA1->A1_TPFRET)=="F" .And. !SA1->A1_COD$"035444"  .And. !_aGrupos[1][10][1] $ cFS_GRPSPVE

				_lRet	:= .F.

			EndIf

		EndIf

	EndIf

	RestArea(aArea)

Return(_lRet)
