User Function EICAP100()

	Local lRet := .T.
	Local cParam := If(Type("PARAMIXB") == "A", ParamIxb[1],ParamIxb)
	Local _dDtBx	:= Ctod("\\")
	
	If cParam == "ANTES_ESTORNO_BAIXA"
	
	_dDtBx := POSICIONE("SE2", 1, xFilial("SE2") + TRB->WB_PREFIXO+TRB->WB_NUMDUP+TRB->WB_PARCELA+TRB->WB_TIPOTIT, "E2_BAIXA")
	
	If _dDtBx <> DDATABASE .And. !Empty(_dDtBx)
	 MsgAlert("A data da baixa é diferente da data base do sistema. "+ Chr(13) + Chr(10)+" Verifique com o Financeiro!", "Atenção ")
	 lRet := .F.
	EndIf
	
	EndIf
	
Return lRet
