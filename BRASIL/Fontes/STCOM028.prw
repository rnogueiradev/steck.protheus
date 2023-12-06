#Include 'Protheus.ch'

User Function STCOM028()

	Local _aArea 		:= GetArea()
	Local _aAreaSD1		:= SD1->(GetArea())
	Local _aAreaSF1		:= SF1->(GetArea())
	Local _aAreaSC7		:= SC7->(GetArea())
	Local _lRet			:= .T.
	Local _nPosCod		:= aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D1_COD"})
	Local _nPosLocal	:= aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D1_LOCAL"})
	Local _nPosTES		:= aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D1_TES"})
	Local _nX		:= 0

	If _nPosCod < 1 .Or. _aArea[1] $ ("SC5/SF2")
		Return _lRet
	EndIf
	
	DbSelectArea("SF4")
	SF4->(DbSetOrder(1))

	For _nX:=1 To Len(aCols)

		dbSelectArea("CBA")
		DbOrderNickName("STINVROT")
		dbGotop()

		IF dbSeek(xFilial("CBA")+aCols[_nX][_nPosCod]+"1")

			while !EOF() .and. CBA->CBA_PROD+CBA->CBA_XROTAT ==  aCols[_nX][_nPosCod]+"1"

				IF CBA->CBA_STATUS >= "1" .and. CBA->CBA_STATUS < "5"
					MSGAlert("Esta nota fiscal não pode ser confirmada pois possui itens em inventario rotativo !!!")
					_lRet := .F.
				Endif

				dbSelectArea("CBA")
				dbSkip()
			End

		Endif
		//>> ticket 20200827006436 - Everson Santana - 28.08.2020
		If _lRet
			If aCols[_nX][_nPosLocal] $ "90"
				If SF4->(DbSeek(xFilial("SF4")+aCols[_nX][_nPosTES]))
					If AllTrim(SF4->F4_ESTOQUE)=="S"
						MSGAlert("Não é permitido dar entrada no Local 90, Altere o campo Local.")
						_lRet := .F.
						Exit
					EndIf
				EndIf
			EndIf

		EndIf
		//<< ticket 20200827006436
	Next

	RestArea(_aArea)
	RestArea(_aAreaSF1)
	RestArea(_aAreaSD1)

Return(_lRet)
