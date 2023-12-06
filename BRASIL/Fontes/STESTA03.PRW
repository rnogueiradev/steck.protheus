
#include "rwmake.ch"

User Function STESTA03()
	
	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
	ฑฑบPrograma  ณSTESTA001 บAutor  ณMicrosiga           บ Data ณ  16/07/14   บฑฑ
	ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
	ฑฑบDesc.     ณ                                                            บฑฑ
	ฑฑบ          ณ                                                            บฑฑ
	ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
	ฑฑบUso       ณ AP                                                         บฑฑ
	ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
	*/
	
	
	
	DbSelectArea("SX1")
	DbSetOrder(1)
	
	if !DbSeek("ACTFILMOT1")
		/* Removido - 18/05/2023 - Nใo executa mais Recklock na X1 - Criar/alterar perguntas no configurador
		RecLock("SX1",.T.)
		SX1->X1_GRUPO  := "ACTFILMOT1"
		SX1->X1_ORDEM  := "01"
		SX1->X1_PERGUNT:= "Data Fechamento?"
		SX1->X1_VARIAVL:= "mv_ch1"
		SX1->X1_TIPO   := "D"
		SX1->X1_TAMANHO:= 8
		SX1->X1_VAR01  := "MV_PAR01"
		SX1->X1_GSC    := "G"
		MsUnlock()
		*/
	Endif
	
	IF Pergunte("ACTFILMOT1",.T.)
		if msgyesno("Confima execucao dos lancamentos ?")
			Processa({|| ImPorta() },"Processando...")
		endif
		
	Endif
	
Return


/*
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTESTA001 บAutor  ณMicrosiga           บ Data ณ  16/07/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Importa()
	
	Local _cData := substr(dtos(mv_par01),1,6)
	Local  nSD3 :=  0
	Local 	nCnt  := 0
	Local _nC := 0
	
	Begin Transaction
		
		_cQuery := "UPDATE "
		_cQuery += retsqlname("SD3") + "  SD3010 "
		_cQuery += "   SET D_E_L_E_T_ = '*',D3_XOBS='CANCELADO NOVO CM' "
		_cQuery += "   WHERE D3_COD  LIKE 'MOD%' "
		_cQuery += "             AND D3_ESTORNO = ' '  "
		_cQuery += "             AND D3_EMISSAO LIKE '"+_cData+"%' "
		_cQuery += "             AND SD3010.D_E_L_E_T_ = ' '  "
		
		nErrQry := TCSqlExec( _cQuery )
		
		If nErrQry <> 0
			DisarmTransaction()
			MsgAlert('Erro no UPDATE: ' + AllTrim(Str(nErrQry)),'ATENวรO')
			lRet := .F.
		EndIf
		
	End Transaction
	
	_cQuery := " SELECT G2_PRODUTO,H1_CCUSTO,B1_COD,B1_DESC,G2_LOTEPAD,G2_TEMPAD,G2_MAOOBRA, " //chamado 005318 - Robson Mazzarotto.
	
	_cQuery += "       CASE WHEN B1_DESC LIKE '%EXTERNO%' "
	
	_cQuery += "       THEN "
	_cQuery += "           ROUND(D3_QUANT,2) "
	_cQuery += "       ELSE    "
	_cQuery += "           CASE WHEN G2_TEMPAD >= 1 "
	_cQuery += "                THEN "
	_cQuery += "                    ROUND((D3_QUANT/(G2_LOTEPAD/(G2_TEMPAD*60*(CASE WHEN G2_MAOOBRA > 0 THEN G2_MAOOBRA ELSE 1 END) )))/60,2)   "
	_cQuery += "                ELSE "
	_cQuery += "                    ROUND((D3_QUANT/(G2_LOTEPAD/(CASE WHEN G2_TEMPAD > 0 THEN G2_TEMPAD ELSE 1 END*(CASE WHEN G2_MAOOBRA > 0 THEN G2_MAOOBRA ELSE 1 END)))),2) " //Vitor Merguizo 22/10/2015
	_cQuery += "            END "
	_cQuery += "       END "
	_cQuery += "       AS TEMPO  , "
	_cQuery += "       'OPER '||G2_OPERAC||' OP '||D3_OP||' '||D3_QUANT||' '||D3_UM   AS OBS,  "
	_cQuery += "       SD3010.*  "
	_cQuery += "       FROM " + retsqlname("SD3") + "  SD3010  "
	_cQuery += "       LEFT JOIN " + retsqlname("SG2") + " SG2010 ON D3_FILIAL = G2_FILIAL AND D3_COD = G2_PRODUTO AND G2_CODIGO = '01'  AND SG2010.D_E_L_E_T_ = ' ' "
	//_cQuery += "       LEFT JOIN " + retsqlname("SC2") + " SC2010 ON SUBSTR(D3_OP,1,6) = C2_NUM AND SC2010.D_E_L_E_T_ = ' ' " //chamado 005318 - Robson Mazzarotto.
	//_cQuery += "       LEFT JOIN " + retsqlname("SG2") + " SG2010 ON D3_FILIAL = G2_FILIAL AND D3_COD = G2_PRODUTO AND G2_CODIGO = C2_ROTEIRO AND SG2010.D_E_L_E_T_ = ' ' " //chamado 005318 - Robson Mazzarotto.
	_cQuery += "       LEFT JOIN " + retsqlname("SH1") + " SH1010 ON D3_FILIAL = H1_FILIAL AND H1_CODIGO = G2_RECURSO    AND SH1010.D_E_L_E_T_ = ' ' "
	_cQuery += "       LEFT JOIN " + retsqlname("SB1") + " SB1010 ON B1_FILIAL = ' ' AND B1_COD = 'MOD'||H1_CCUSTO "
	//_cQuery += "
	_cQuery += "       WHERE D3_CF  LIKE 'PR%' "
	_cQuery += "             AND D3_ESTORNO = ' ' "
	_cQuery += "             AND D3_EMISSAO LIKE '"+_cData+"%' "
	_cQuery += "             AND SD3010.D_E_L_E_T_ = ' ' "
	_cQuery += "             AND NVL(H1_CCUSTO,' ') <> ' ' "
	_cQuery += "             AND (G2_LOTEPAD/(CASE WHEN G2_TEMPAD > 0 THEN G2_TEMPAD ELSE 1 END*60)) > 0 "//Vitor Merguizo 22/10/2015
	
	cQuery := ChangeQuery(_cQuery)
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRB1",.T.,.T.)
	
	aStrucSD3 := SD3->(dbStruct())
	
	For nSD3 := 1 to Len(aStrucSD3)
		If aStrucSD3[nSD3,2] != 'C' .and.  FieldPos(aStrucSD3[nSD3][1]) > 0
			TCSetField("TRB1", aStrucSD3[nSD3,1], aStrucSD3[nSD3,2],aStrucSD3[nSD3,3],aStrucSD3[nSD3,4])
		EndIf
	Next nSD3
	
	
	DbSelectArea("TRB1")
	DbEval( {|| nCnt++ })              // Conta quantos sao os registros retornados pelo Select.
	
	ProcRegua(nCnt)
	
	DbSelectArea("TRB1")
	DbGoTop()
	While !EOF()
		IncProc("Prcessando Registros")
		RecLock("SD3",.t.)
		FOR _nC := 1 TO LEN(aStrucSD3)
			IF UPPER(ALLTRIM(aStrucSD3[_nC,1]))  <> 'D3_COD'
				&(aStrucSD3[_nC,1]) := TRB1->&(aStrucSD3[_nC,1])
			ENDIF
		Next _nC
		SD3->D3_COD 	 := TRB1->B1_COD
		SD3->D3_LOCAL 	 := '90'
		SD3->D3_XOBS 	 := TRB1->OBS
		SD3->D3_CF 		 := 'RE1'
		SD3->D3_CHAVE 	 := 'E0'
		SD3->D3_TM 		 := '999'
		SD3->D3_UM 		 := 'H'
		SD3->D3_TIPO   	 := 'MO'
		SD3->D3_QUANT    := TRB1->TEMPO
		SD3->D3_CUSTO1   := 0
		SD3->D3_CUSTO2   := 0
		SD3->D3_CUSTO3   := 0
		SD3->D3_CUSTO4   := 0
		SD3->D3_CUSTO5   := 0
		msunlock()
		DbSelectArea("TRB1")
		DbSkip()
		
	End
	
	DbSelectArea("TRB1")
	DbClosearea("TRB1")
	
	MsgBox("Importacao realizada com sucesso")
	
Return
