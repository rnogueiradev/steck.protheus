#include 'Protheus.ch'
#include 'RwMake.ch'
#Define CR chr(13)+chr(10)
/*====================================================================================\
|Programa  | STSBFSTELLA      | Autor | GIOVANI.ZAGO             | Data | 01/09/2014  |
|=====================================================================================|
|Descrição | STSBFSTELLA                                                              |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STSBFSTELLA                                                              |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
User Function STSBFSTELLA (_cProdStell,_cVersao)
*-----------------------------*
Local _nRet 	 := 0
Local cQuery     := ' '
Local cPerg 	 := "RFAT53"
Local cTime      := Time()
Local cHora      := SUBSTR(cTime, 1, 2)
Local cMinutos   := SUBSTR(cTime, 4, 2)
Local cSegundos  := SUBSTR(cTime, 7, 2)
Local cAliasLif  := cPerg+cHora+ cMinutos+cSegundos
Local _cEndStella := "'7H101A','7H101B','7H102A','7H102B','7H103A','7H103B','7H104A','7H104B','7H105A','7H105B','7H106A','7H106B','7H107A','7H107B','7H108A','7H108B','7H109A','7H109B','7H110A','7H110B','7H111A','7H111B','7H112A','7H112B','7H113A','7H113B','7H114A','7H114B','7H115A','7H115B','7H116A','7H116B','7H117A','7H117B','7H118A','7H118B','7H119A','7H119B','7H120A','7H120B','7H121A','7H121B','7H122A','7H122B','7H123A','7H123B','7H124A','7H124B','7H125A','7H125B','7H126A','7H126B','7H127A','7H127B','7H128A','7H128B','7H129A','7H129B','7H130A','7H130B','7H131A','7H131B','7H132A','7H132B','7H133A','7H133B','7H134A','7H134B','7H135A','7H135B','7H136A','7H136B','7H137A','7H137B','7H138A','7H138B','7H139A','7H139B','7H140A','7H140B','7H141A','7H141B','7H142A','7H142B'"//GetMv("ST_SBFSTE",,'')

Default _cVersao:='0'

If Substr(_cVersao,1,1) $ '1/2'
	
	cQuery := " SELECT
	cQuery += " NVL(SUM(SBF.BF_QUANT - SBF.BF_EMPENHO),0)
	cQuery += ' "QUANT"
	cQuery += " FROM "+RetSqlName("SBF")+"  SBF "
	cQuery += " WHERE   SBF.D_E_L_E_T_ = ' '
	cQuery += " AND     SBF.BF_FILIAL  =  '"+xFilial("SC6")+"'
	cQuery += " AND     SBF.BF_PRODUTO =  '"+_cProdStell+"'
	cQuery += " AND     SBF.BF_LOCAL   = '03'
	If _cVersao = '1'  .And. !Empty(Alltrim(_cEndStella))
		cQuery += " AND     SBF.BF_LOCALIZ  IN ("+_cEndStella+")
	ElseIf _cVersao = '2' .And. !Empty(Alltrim(_cEndStella))
		cQuery += " AND     SBF.BF_LOCALIZ  NOT IN ("+_cEndStella+")
	EndIf
	
	cQuery := ChangeQuery(cQuery)
	
	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf
	
	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)
	
	dbSelectArea(cAliasLif)
	If  Select(cAliasLif) > 0
		(cAliasLif)->(dbgotop())
		_nRet 	 := 	(cAliasLif)->QUANT
	EndIf
	
	
	
	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf
EndIf
Return(_nRet)
