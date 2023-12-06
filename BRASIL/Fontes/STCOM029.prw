#INCLUDE 'PROTHEUS.CH'
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ STCOM029 บAutor  ณRichard N Cabral    บ Data ณ  20/02/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Bloquear Fornecedores sem Movimentacao nas tabelas         บฑฑ
ฑฑบ          ณ SC7/SC8/SF1/SE2/SE5/QEK nos ultimos 2 anos (x Meses)       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ STECK                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function STCOM029()			// U_STCOM029()

	Local nAno	:= 0
	Local nMes	:= 0
	Local nMesesBloq	:= GetMv("ST_MESBLQ",,24)

	Private cAnoMes	:= ""

	nAno := Year(dDataBase)
	nMes := Month(dDataBase)

	nMes -= nMesesBloq
	Do While nMes < 1
		nMes += 12
		nAno -= 1
	EndDo

	cAnoMes	:= StrZero(nAno,4) + StrZero(nMes,2)
	
	BloqForn()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ BloqForn บAutor  ณRichard N Cabral    บ Data ณ  20/02/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Bloquear Fornecedores sem Movimentacao nas tabelas         บฑฑ
ฑฑบ          ณ SC7/SC8/SF1/SE2/SE5/QEK nos ultimos 2 anos (x Meses)       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ STECK                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function BloqForn()
	Local cQuery	:= ""
	Local cLog		:= ""
	Local cMsg		:= ""

	SA2->(DbSetOrder(1))

	cQuery += " SELECT * FROM " + RetSqlName("SA2") + " SA2 " + CRLF
	cQuery += " WHERE A2_FILIAL = '" + xFilial("SA2") + "'  " + CRLF
	cQuery += " AND A2_MSBLQL <> '1' " + CRLF
	cQuery += " AND SA2.D_E_L_E_T_ = ' '  " + CRLF
	cQuery += " AND NOT EXISTS ( " + CRLF
	cQuery += " SELECT * FROM  " + CRLF
	cQuery += " (
	cQuery += " SELECT FORNEC, LOJA, MAX(ULTMOV) ULTMOV FROM " + CRLF 
	cQuery += " ( " + CRLF

	cQuery += " SELECT QEK_FORNEC FORNEC, QEK_LOJFOR LOJA, 'QEK' TABELA, MAX(QEK_DTENTR) ULTMOV " + CRLF 
	cQuery += " FROM " + RetSqlName("QEK") + " QEK " + CRLF
	cQuery += " WHERE QEK.D_E_L_E_T_ = ' ' " + CRLF 
	cQuery += " GROUP BY QEK_FORNEC, QEK_LOJFOR " + CRLF
	cQuery += " HAVING MAX(QEK_DTENTR) >= '" + cAnoMes + "' " + CRLF

	cQuery += " UNION ALL " + CRLF

	cQuery += " SELECT C7_FORNECE FORNEC, C7_LOJA LOJA, 'SC7' TABELA, MAX(C7_EMISSAO) ULTMOV " + CRLF 
	cQuery += " FROM " + RetSqlName("SC7") + " SC7 " + CRLF
	cQuery += " WHERE SC7.D_E_L_E_T_ = ' '  " + CRLF
	cQuery += " GROUP BY C7_FORNECE, C7_LOJA " + CRLF
	cQuery += " HAVING MAX(C7_EMISSAO) >= '" + cAnoMes + "' " + CRLF

	cQuery += " UNION ALL " + CRLF

	cQuery += " SELECT C8_FORNECE FORNEC, C8_LOJA LOJA, 'SC8' TABELA, MAX(C8_EMISSAO) ULTMOV " + CRLF 
	cQuery += " FROM " + RetSqlName("SC8") + " SC8 " + CRLF
	cQuery += " WHERE SC8.D_E_L_E_T_ = ' '  " + CRLF
	cQuery += " GROUP BY C8_FORNECE, C8_LOJA " + CRLF
	cQuery += " HAVING MAX(C8_EMISSAO) >= '" + cAnoMes + "' " + CRLF

	cQuery += " UNION ALL " + CRLF

	cQuery += " SELECT F1_FORNECE FORNEC, F1_LOJA LOJA, 'SF1' TABELA, MAX(F1_EMISSAO) ULTMOV " + CRLF 
	cQuery += " FROM " + RetSqlName("SF1") + " SF1 " + CRLF
	cQuery += " WHERE F1_TIPO = 'N' " + CRLF
	cQuery += " AND SF1.D_E_L_E_T_ = ' '  " + CRLF
	cQuery += " GROUP BY F1_FORNECE, F1_LOJA " + CRLF
	cQuery += " HAVING MAX(F1_EMISSAO) >= '" + cAnoMes + "' " + CRLF

	cQuery += " UNION ALL " + CRLF

	cQuery += " SELECT E2_FORNECE FORNEC, E2_LOJA LOJA, 'SE2' TABELA, MAX(E2_EMISSAO) ULTMOV " + CRLF 
	cQuery += " FROM " + RetSqlName("SE2") + " SE2 " + CRLF
	cQuery += " WHERE SE2.D_E_L_E_T_ = ' '  " + CRLF
	cQuery += " GROUP BY E2_FORNECE, E2_LOJA " + CRLF
	cQuery += " HAVING MAX(E2_EMISSAO) >= '" + cAnoMes + "' " + CRLF

	cQuery += " UNION ALL " + CRLF

	cQuery += " SELECT E5_CLIFOR FORNEC, E5_LOJA LOJA, 'SE5' TABELA, MAX(E5_DATA) ULTMOV " + CRLF 
	cQuery += " FROM " + RetSqlName("SE5") + " SE5 " + CRLF
	cQuery += " WHERE E5_RECPAG = 'P' " + CRLF
	cQuery += " AND E5_CLIFOR <> ' '  " + CRLF
	cQuery += " AND SE5.D_E_L_E_T_ = ' '  " + CRLF
	cQuery += " GROUP BY E5_CLIFOR, E5_LOJA " + CRLF
	cQuery += " HAVING MAX(E5_DATA) >= '" + cAnoMes + "' " + CRLF

	cQuery += " )  " + CRLF

	cQuery += " GROUP BY FORNEC, LOJA " + CRLF

	cQuery += " )  ATIVOS " + CRLF

	cQuery += " WHERE ATIVOS.FORNEC = SA2.A2_COD AND ATIVOS.LOJA = SA2.A2_LOJA " + CRLF

	cQuery += " ) " + CRLF

	TCQUERY cQuery NEW ALIAS "TMPBLOQ"
	
	TMPBLOQ->(DbGotop())

	Do While ! TMPBLOQ->(Eof())

		DBSelectArea("SA2")
		If SA2->(DbSeek(xFilial("SA2") + TMPBLOQ->A2_COD + TMPBLOQ->A2_LOJA))
			cLog := SA2->A2_XLOG
			cMsg := "Fornecedor Bloqueado Automaticamente pelo sistema" + CHR(13) + CHR(10) + "Data: " + DtoC(dDataBase) + " Hora: " + Time() 

			RecLock("SA2",.F.)
			SA2->A2_MSBLQL	:= "1"
			SA2->A2_XLOG	:= cMsg + CHR(13) + CHR(10) + cLog
			MsUnLock()

		EndIf
		DBSelectArea("TMPBLOQ")
		
		TMPBLOQ->(DbSkip())
	EndDo

	dbSelectArea("TMPBLOQ")
	dbCloseArea()

Return
