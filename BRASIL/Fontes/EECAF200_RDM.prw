User Function EECAF200()

	Local lRet := .T.
	Local cParam := If(Type("PARAMIXB") == "A", ParamIxb[1],ParamIxb)
	Local _dDtBx	:= Ctod("\\")

	If cParam == "PE_VALIDA" 

		If nTipoDet = 98

			If TMP->EEQ_TIPO = "R"
				_dDtBx := POSICIONE("SE1", 2, xFilial("SE1") + TMP->EEQ_IMPORT+TMP->EEQ_IMLOJA+"EEC"+TMP->EEQ_FINNUM, "E1_BAIXA")
			Else
				_dDtBx := POSICIONE("SE2", 6, xFilial("SE2") + TMP->EEQ_FORN+TMP->EEQ_FOLOJA+"EEC"+TMP->EEQ_FINNUM, "E2_BAIXA")
			EndIF
			
			If _dDtBx <> DDATABASE .And. !Empty(_dDtBx)
				MsgAlert("A data da baixa é diferente da data base do sistema. "+ Chr(13) + Chr(10)+" Verifique com o Financeiro!", "Atenção ")
				lRet := .F.
			EndIf

		EndIf

	EndIf

Return lRet