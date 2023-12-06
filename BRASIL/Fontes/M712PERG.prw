User Function M712PERG()

Local aPerg := Paramixb[1]

IF TYPE("_MVSTECK11")=='N'
	//aPerg[08] := _MVSTECK08  // LOCAL DE
	//aPerg[09] := _MVSTECK09  // LOCAT ATE
	//aPerg[10] := _MVSTECK10  // GERA SC PREVISTA
	aPerg[11] := _MVSTECK11  // LIMPA SC/OP's PREVISTAS
	//aPerg[35] := _MVSTECK35  // MOSTRA TELA APOS CALCULO
	//aPerg[26] := _MVSTECK26  // CONSIDERA EST.SEGURANCA       
	//aPerg[23] := _MVSTECK23  // PV/PMP De  Documento                
	//aPerg[24] := _MVSTECK24  // MV_PAR24    ->  PV/PMP Ate Documento
	//aPerg[20] := _MVSTECK20  // Qtd. nossa Poder 3   1- Soma  2- Ignora
Endif

RETURN aPerg
