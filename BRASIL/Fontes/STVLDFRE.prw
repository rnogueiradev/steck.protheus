#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"

/*
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ?STVLDFRE ³Autor  ?Renato Nogueira       ?Data ?8.08.2013 ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±?         ³Avalia a colocacao do tipo de frete   				       ³±?
±±?         ?                                                            ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ?Generico                                                    ³±?
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function STVLDFRE(_cTpFrete,_cCliente,_cLoja,_cTransp,_cTp)

	Local aArea     := GetArea()
	Local _lRet		:= .T.
	Local cFS_GRPSPVE	:= SuperGetMV("FS_GRPSPVE",,"")
	Local _aGrupos, _nPos

	PswOrder(1)
	If PswSeek(__cUserId,.T.)
		_aGrupos	:= PswRet()
	EndIf

	DbSelectArea("SA1")
	DbSetOrder(1)
	DbSeek(xFilial("SA1")+_cCliente+_cLoja)

	If ( Type("l410Auto") == "U" .OR. !l410Auto )

		If !SA1->(Eof())

			If !Empty(SA1->A1_TRANSP) .And. AllTrim(SA1->A1_TPFRET)=="C" .And. AllTrim(_cTpFrete)=="C"
				_lRet	:= .T.
			ElseIf (_cTransp=="004064" .And. _cTpFrete=="C") .OR. (_cTransp=="000163" .And. _cTpFrete=="C") //Chamado 002987 -- Valdemir Rabelo 20/05/2021 Ticket: 20200825006248 
				_lRet	:= .T.
			                                                             // (M->C5_TIPO <> "B")  - Adicionado por solicitação Rodrigo Ferreira 22/02/2022 - Chamado: 20220125001919
			ElseIf (!(_cTransp $"004064/000163") .And. _cTpFrete=="C") .and. (M->C5_TIPO <> "B")         //     Valdemir Rabelo 20/05/2021 Ticket: 20200825006248
				 MsgAlert("Tipo de Frete não permitido para transportadora informada")
				_lRet	:= .F.
			/*ElseIf (Empty(SA1->A1_TRANSP) .and. _cTransp !="004064") .And. AllTrim(_cTpFrete)<>"F" .And. !SA1->A1_COD$"035444" .And. !_aGrupos[1][10][1] $ cFS_GRPSPVE
				MsgAlert("Utilize o frete FOB")
				_lRet	:= .F.
				If _cTp = '1'
					M->UA_TPFRETE:= ' '
				EndIf
				*/
				/*
				ElseIf AllTrim(SA1->A1_TPFRET)=="C" .And. AllTrim(_cTpFrete)="F" .And. !SA1->A1_COD$"035444" .And. !_aGrupos[1][10][1] $ cFS_GRPSPVE
				MsgAlert("Utilize o frete CIF")
				_lRet	:= .F.
				If _cTp = '1'
				M->UA_TPFRETE:= ' '
				EndIf
				*/
			EndIf

		EndIf

	EndIf

	RestArea(aArea)

Return(_lRet)
