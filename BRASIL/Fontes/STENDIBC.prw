#INCLUDE "Protheus.ch"
#INCLUDE "APVT100.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STENDIBC   ºAutor  ³Renato Nogueira     º Data ³  04/02/14  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ordem de separação X endereço - Coletor    		          º±±
±±º          ³					                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Steck                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function STENDIBC()

	Local _lRet	:= .T.
	Local _aEnd	:= {}
	Local _nX	:= 0
	Local _nY	:= 0
	Local _aOs  := {}
	Local _nTotOs := 0
	Local _nTotEnd	:= 0
	Private _cOS	:= space(35)
	Private _cEnd	:= space(10)

	While _lRet

		VTCLEAR

		@ 0,0 VTSAY Padc("Total de OSs: "+CVALTOCHAR(_nTotOs),VTMaxCol())
		@ 2,0 VTSAY Padc("Digite a OS",VTMaxCol())
		@ 3,0 VTSAY "OS:"
		@ 4,0 VTGET _cOS  PICTURE "@!" F3 "CB7" VALID VLDOS(_cOS)

		VTREAD

		If VTLASTKEY()==27
			If CBYesNo("Confirma saida?",".:AVISO:.",.t.)
				Return
			Endif
		Endif

		If Empty(_cOS)
			If Len(_aOs)==0
				VtAlert("Digite a OS")
			Else
				_lRet	:= .F.
			EndIf
		Else
			AADD(_aOs,_cOS)
			_nTotOs++
			_cOS := space(35)
			VTGetRefresh("_cOS")
			VTGetRefresh("_nTotOs")
		EndIf

	EndDo

	_lRet	:= .T.

	While _lRet

		VTCLEARBUFFER()
		VTCLEAR

		_cOS := ""

		For _nX:=1 To Len(_aOs)
			_cOS += _aOs[_nX]+"/"
		Next

		@ 2,0 VTSAY Padc("Digite o endereco",VTMaxCol())
		@ 3,0 VTSAY "Endereco:"
		@ 4,0 VTGET _cEnd PICTURE "@!" VALID VLDEND(_cEnd)

		VTREAD

		If VTLASTKEY()==27
			If CBYesNo("Confirma saida?",".:AVISO:.",.t.)
				Return
			Endif
		Endif

		AADD(_aEnd,_cEnd)
		_nTotEnd++
		//_cEnd := space(10)
		VTGetRefresh("_cEnd")
		VTGetRefresh("_nTotEnd")
		_lRet := .F.

	EndDo

	If Len(_aOs)>0 .And. Len(_aEnd)>0

		If CBYesNo("Confirma gravacao das OSs no endereco "+_cEnd+"?",".:AVISO:.",.t.)

			For _nX:= 1 to len(_aEnd)

				For _nY:=1 To Len(_aOs)

					DbSelectArea("SZ5")
					SZ5->(DbGoTop())
					SZ5->(DbSetOrder(1))
					SZ5->(DbSeek(xFilial("SZ5")+_aOs[_nY]+_aEnd[_nX]+DTOS(DDATABASE)))

					If SZ5->(Eof())

						SZ5->(Reclock("SZ5",.T.))
						SZ5->Z5_FILIAL	:= xFilial("SZ5")
						SZ5->Z5_ORDSEP	:= _aOs[_nY]
						SZ5->Z5_ENDEREC	:= _aEnd[_nX]
						SZ5->Z5_DTEMISS	:= DDATABASE
						SZ5->(Msunlock())

					Else
						//VtAlert("Atencao, o endereco: "+Alltrim(_aEnd[_nX])+" ja foi cadastrado nesta data")
					EndIf

				Next

			Next

			VtAlert("Processo finalizado!")

		Else

			VtAlert("Processo cancelado!")

		EndIf

	EndIf

Return

Static Function VLDEND(_cEndereco)

	Local _lRet := .T.

	_cEndereco := SubStr(_cEndereco,1,6)

	DbSelectArea("SZ6")
	SZ6->(DbSetOrder(1))
	If !SZ6->(DbSeek(xFilial("SZ6")+_cEndereco))
		_lRet := .F.
		VtAlert("Endereço não encontrado!")
		_cEnd := space(10)
	Else
		_cEnd := SZ6->Z6_ENDEREC
	EndIf

Return(_lRet)

Static Function VLDOS(_cOrdem)

	Local _lRet := .T.

	If Empty(_cOrdem)
		Return(.T.)
	EndIf

	_cOrdem := AllTrim(_cOrdem)

	If SubStr(_cOrdem,1,5) $ "02038" //Etiqueta TNT
		_cOrdem := SubStr(_cOrdem,10,6)
	ElseIF SubStr(_cOrdem,1,5) $ "70379" //BrasPress 
		_cOrdem := SubStr(_cOrdem,11,6)
	Else
		_cOrdem := SubStr(_cOrdem,1,6)
	EndIf

	/*
	If Len(_cOrdem)==33 //Etiqueta TNT
		_cOrdem := SubStr(_cOrdem,10,6)
	Else
		_cOrdem := SubStr(_cOrdem,1,6)
	EndIf
	*/

	DbSelectArea("CB7")
	CB7->(DbSetOrder(1))
	If !CB7->(DbSeek(xFilial("CB7")+_cOrdem))
		_lRet := .F.
		VtAlert("OS nao encontrada!")
		_cOS := space(35)
	Else
		_cOS := CB7->CB7_ORDSEP
	EndIf

Return(_lRet)