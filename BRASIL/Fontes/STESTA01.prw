#include "Rwmake.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ STESTA01 ºAutor  ³ RVG Solucoes       º Data ³  08/03/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina para Bloquear a escolha de armazem errado           º±±
±±º          ³ incluir na validacao do usuario u_StVldLoc()               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function STESTA01

	Local _cLocal
	Local _cEmp := cempant
	Local _cFil := cfilant
			
	_cLocal := &(Readvar())
/*DbSelectArea("SX5")
DbSetOrder(1)
DbSeek(xFilial("SX5")+"90"+_cLocal)
if eof()
    MsgStop("Armazem nao existe!, Verifique !!! ")
    _lRet := .f.
else
	_lRet :=  .t.
Endif                         
*/
//>> Chamado 006883 - Everson Santana 14.02.18
	If _cEmp = '01' .and. _cFil = '04'

		If (_cLocal="01" .Or. _cLocal="03" .Or. _cLocal="90")
			_lRet := .T.
		Else
			MsgStop("Só é permitido cadastrar os armazéns 01, 03 ou 90 Verifique !!! ")
			_lRet := .F.
		EndIf

	Else
//<< Chamado 006883
 
		If _cEmp = '01' .and. _cFil = '05' // Zeca em 07/10/2020
			_lRet := .T.
		Else
			If (_cLocal="01" .Or. _cLocal="03")
				_lRet := .T.
			Else
				MsgStop("Só é permitido cadastrar os armazéns 01 ou 03 Verifique !!! ")
				_lRet := .F.
			EndIf
		EndIf
	EndIf
                                                              
Return _lret