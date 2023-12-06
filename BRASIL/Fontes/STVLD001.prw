#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ STVLD001 บ Autor ณ RVG                บ Data ณ  27/08/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP11 - STECK                                               บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function STVLD001
	Local _lRet := .t.
	
	// cNFiscal	= numero da nota fiscal
	// cSerie 	= Serie da nota fiscal
	// cA100For	= codigo do fornecedor
	// cLoja	= loja do fornecedor
	
	if !empty(cNFiscal) .and. !empty(cSerie) .and. !empty(cA100For) .and. !empty(cLoja)
		
		DbSelectarea("SA2")
		Dbsetorder(1)
		Dbseek(xfilial("SA2")+cA100For+cLoja)
		
		if !eof()
			
			_cCodEmp := space(len(SM0->M0_CODIGO))
			_cCodFil := space(len(SM0->M0_CODFIL))
			If PesqCGC(SA2->A2_CGC,@_cCodEmp,@_cCodFil)
				
				_lRet := _checa_nf(SA2->A2_CGC,@_cCodEmp,@_cCodFil)
				
			Endif
			
		Endif
		
	endif
	
Return(_lRet)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ STVLD001 บ Autor ณ RVG                บ Data ณ  27/08/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP11 - STECK                                               บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/


Static Function PesqCGC(clCGC,_cCodEmp,_cCodFil)
	Local alAreaSM0
	Local aCodEmpFil:= {}
	Local _lRet := .f.
	
	dbSelectArea("SM0")
	alAreaSM0 := SM0->(GetArea())
	dbGoTop()
	Do While !eof() .and. !Empty(clCGC)
		If SM0->M0_CGC = clCGC
			
			_cCodEmp := SM0->M0_CODIGO
			_cCodFil:= SM0->M0_CODFIL
			
			_lRet := .t.
			exit
		Endif
		dbSkip()
	Enddo
	
	RestArea(alAreaSM0)
	
Return _lRet



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ STVLD001 บ Autor ณ RVG                บ Data ณ  27/08/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP11 - STECK                                               บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/


Static Function _checa_nf(clCGC,_cCodEmp,_cCodFil)
	
	Local _lRet := .f.
	
	cQuery    := " SELECT   * "
	cQuery    += " FROM     SD2"+ALLTRIM(_cCodEmp)+"0 SD2, SF2"+ALLTRIM(_cCodEmp)+"0 SF2"
	cQuery    += " WHERE    F2_DOC     = D2_DOC AND F2_SERIE = D2_SERIE  "
	cQuery    += "          AND (D2_FILIAL = '"+ _cCodFil +"')    		AND (D2_FILIAL = F2_FILIAL ) "
	cQuery    += "          AND (D2_DOC    = '"+cNFiscal+"')        	AND  (D2_SERIE = '"+cSerie+"')"
	cQuery    += "          AND (SD2.D_E_L_E_T_ <> '*' ) "
	cQuery    += "          AND (SF2.D_E_L_E_T_ <> '*' ) "
	cQuery    += "          ORDER BY D2_DOC,D2_SERIE,D2_ITEM"
	
	cQuery:= ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRB",.T.,.T.)
	
	TCSETFIELD("TRB","D2_QUANT"   ,"N",14,2)
	TCSETFIELD("TRB","D2_EMISSAO" ,"D",08,0)
	TCSETFIELD("TRB","D2_PRCVEN"  ,"N",18,6)
	TCSETFIELD("TRB","F2_BASEICM" ,"N",14,2)
	TCSETFIELD("TRB","F2_VALICM"  ,"N",14,2)
	TCSETFIELD("TRB","F2_BASEIPI" ,"N",14,2)
	TCSETFIELD("TRB","F2_VALIPI"  ,"N",14,2)
	TCSETFIELD("TRB","F2_VALMERC" ,"N",14,2)
	TCSETFIELD("TRB","F2_VALBRUT" ,"N",14,2)
	
	DbSelectArea("TRB")
	_nRec := 0
	DbEval({|| _nRec++  })
	
	DBGOTOP()
	
	if _nRec == 0
		
		_lRet := .f.
		
		MsgStop('Esta nota nao existe na Empresa/Filial de Origem, confirme os dados !!!')
		
	Else
		
		_lRet := .t.
		
		_Gera_Acols()
		
	endif
	
	Dbselectarea("TRB")
	DbClosearea("TRB")
	
Return  _lRet





/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ STVLD001 บ Autor ณ RVG                บ Data ณ  27/08/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP11 - STECK                                               บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function _Gera_Acols
	
	Local nPosTes  := ASCAN(aHeader, { |x| Alltrim(x[2]) == 'D1_TES' })
	Local nPosCod  := ASCAN(aHeader, { |x| Alltrim(x[2]) == 'D1_COD' })
	Local nPosQtd  := ASCAN(aHeader, { |x| Alltrim(x[2]) == 'D1_QUANT' })
	Local nPosTot  := ASCAN(aHeader, { |x| Alltrim(x[2]) == 'D1_TOTAL' })
	Local nPosUni  := ASCAN(aHeader, { |x| Alltrim(x[2]) == 'D1_VUNIT' })
	Local nPosIte  := ASCAN(aHeader, { |x| Alltrim(x[2]) == 'D1_ITEM' })
	Local nPosGAR  := ASCAN(aHeader, { |x| Alltrim(x[2]) == 'D1_GARANTI' })
	Local nPosRAT  := ASCAN(aHeader, { |x| Alltrim(x[2]) == 'D1_RATEIO' })
	Local nPosLoc  := ASCAN(aHeader, { |x| Alltrim(x[2]) == 'D1_LOCAL' })
	Local nX := 1
	acols := {}
	
	Dbselectarea("TRB")
	DbGotop()
	__nitem := 0
	Do while !eof()
		
		Dbselectarea("SB1")
		DbSetOrder(1)
		Dbseek(xfilial("SB1")+ TRB->D2_COD )
		
		Dbselectarea("TRB")
		
		__nitem++
		
		aadd(aCols,Array(Len(aHeader)+1))
		
		For nX := 1 To Len(aHeader)
			aCols[len(aCols)][nX] := CriaVar(aHeader[nX][2])
		Next nX
		
		aCols[len(aCols),nPosIte] := STRZERO(__nitem,LEN(SD1->D1_ITEM) )
		aCols[len(aCols),nPosCod] := TRB->D2_COD
		aCols[len(aCols),nPosQtd] := TRB->D2_QUANT
		aCols[len(aCols),nPosTot] := TRB->D2_TOTAL
		aCols[len(aCols),nPosUni] := TRB->D2_PRCVEN
		aCols[len(aCols)][Len(aHeader)+1] := .F.
		aCols[len(aCols),nPosLoc] := SB1->B1_LOCPAD
		
		Dbselectarea("TRB")
		DbSkip()
		
	Enddo
	
	
	
Return


