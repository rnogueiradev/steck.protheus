
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTMATNAC  บAutor  ณMicrosiga           บ Data ณ  09/10/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Cria Registro no SB9 para os produtos de consumo que nใo   บฑฑ
ฑฑบ          ณ possuem / controlam saldo                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Steck                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function STMATNAC()

Local	cAlias 		:= "MATRIQRY"
Local	cQuery		:= ""

/*
cQuery := " SELECT B5_COD,B5_CODTRAM,B5_AMMULTO,B5_AMMULTS,B5_ZFMULTO,B5_ZFMULTS "
cQuery += " FROM "+RetSqlName("SB5")+" SB5 "
cQuery += " LEFT JOIN "+RetSqlName("SB9")+" SB9 ON B9_FILIAL = '01' AND B5_COD=B9_COD AND B9_DATA = '20130331' AND B9_LOCAL = '01' AND SB9.D_E_L_E_T_ = ' ' "
cQuery += " WHERE "
cQuery += " B9_COD IS NULL AND "
cQuery += " B5_CODTRAM <> ' ' AND "
cQuery += " SB5.D_E_L_E_T_ = ' ' "
  */

cQuery := " select SB9.R_E_C_N_O_ RECSB9 from SB9030 SB9  "
cQuery += " LEFT JOIN SB1030 SB1 ON B1_COD = B9_COD AND SB1.D_E_L_E_T_ = ' ' "
cQuery += " WHERE  "
cQuery += " B1_DESC LIKE '%DESATIVADO%' AND  "
cQuery += " B9_QINI = 0 AND "
cQuery += " B9_DATA = '20130331' AND "
cQuery += " B9_LOCAL = '01' AND "
cQuery += " SB9.D_E_L_E_T_ = ' ' "

cQuery	:= ChangeQuery(cQuery)

If !Empty(Select(cAlias))
	DbSelectArea(cAlias)
	(cAlias)->(dbCloseArea())
Endif
	
dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),cAlias, .F., .T.)
	
dbSelectArea(cAlias)
(cAlias)->(DbGoTop())
While (cAlias)->(!Eof())

/*	
	RecLock("SB9",.T.)
	SB9->B9_FILIAL	:= "01"
	SB9->B9_COD		:= (cAlias)->B5_COD
	SB9->B9_DATA	:= CTOD("31/03/2013")
	SB9->B9_LOCAL	:= "01"
	MsUnlock()
*/    
    
	DbSelectArea("SB9")
	DbGoTo((cAlias)->RECSB9)
	If SB9->B9_QINI = 0
		RecLock("SB9",.F.)
		dbDelete()
		MsUnlock()
	EndIf

	(cAlias)->(DbSkip())
End

If !Empty(Select(cAlias))
	DbSelectArea(cAlias)
	(cAlias)->(dbCloseArea())
Endif

MsgAlert("Processo Finalizado!")

Return