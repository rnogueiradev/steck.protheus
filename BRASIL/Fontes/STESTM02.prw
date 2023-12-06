#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTESTM02  บAutor  ณMicrosiga           บ Data ณ  17/06/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function STESTM02(_ljob)

Default _lJob := .t.

if !_ljob
	Ajusta()
	
	if pergunte("STESR00201",.t.)
		
		if !MV_PAR01 $ '01--02--03--04--05--06//07--08--09--10--11--12'
			MsgStop("Somente Meses de 01 a 12 ใo validos !!! Verifique !!!")
			Return
		endif
		
		if val(mv_par02) > year(dDatabase)+10 .or. val(mv_par02) < year(dDatabase)-10
			MsgStop("Ano invalido !!! Verifique !!!")
			Return
		endif
		
		MsgRun("Reprocessando Medias",,{|| RunAcerto(_ljob)})
		
	endif
else
	_cData :=  dtos((ctod("01/"+ substr(dtoc(ddatabase),4))-1))
	
	MV_PAR01 := substr(_cData,5,2)
	MV_PAR02 := substr(_cData,1,4)
	
		ConOut(Repl("-",80))
		ConOut("")
		ConOut('Inicio da operacao da STESTM02 ')
		ConOut("")
		ConOut(Repl("-",80))
	
	RunAcerto(_ljob)
	
endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTESTM02  บAutor  ณMicrosiga           บ Data ณ  17/06/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function RunAcerto(_ljob)
Local  _nCount :=  0
_cDtFim := LastDay(ctod("01/"+strzero(val(mv_par01),2)+"/"+mv_par02) )
_cDtIni := ctod("01/"+strzero(val(mv_par01),2)+"/"+mv_par02)


//EXCLUINDO TABELA TEMPORARIA
cQuery := "DROP TABLE CONS_MEDIO"

nErrQry := TCSqlExec( cQuery )

_cMsg:="Processamento de Medias:  " +  substr(dtoc(_cDtIni),4) + chr(13)+chr(10) + chr(13)+chr(10)
_cMsg+="Periodo: " + mv_par01 + "/" + mv_par02 +chr(13)+chr(10)
_cMsg+="Inicio: " + dtoc(date()) + " " + time()  +chr(13)+chr(10)
Begin Transaction

// CRIANDO TABELA TEMPORARIA DE MEDIA DO MES
cQuery := "CREATE TABLE CONS_MEDIO "
cQuery += " AS "
cQuery += " SELECT FILIAL,CODIGO,SUM(CONSUMO) AS CONSUMO, PERIODO  FROM  "
cQuery += " ( "
cQuery += " SELECT D2_FILIAL AS FILIAL ,D2_COD AS CODIGO,SUM(D2_QUANT-D2_QTDEDEV) AS CONSUMO, SUBSTR(D2_EMISSAO,1,6) PERIODO  FROM "+ RetSqlName("SD2")
cQuery += "                  LEFT JOIN "+ RetSqlName("SF4") + " ON F4_FILIAL = '  ' AND F4_CODIGO = D2_TES "
cQuery += "                   WHERE  D2_EMISSAO BETWEEN '"+DTOS(_cDtIni)+"' AND '"+DTOS(_cDtFim)+"' AND SD2010.D_E_L_E_T_ = ' '  AND SF4010.D_E_L_E_T_ = ' '  AND  F4_ESTOQUE = 'S'   AND  F4_DUPLIC = 'S'  "
cQuery += " GROUP BY D2_FILIAL,D2_COD,SUBSTR(D2_EMISSAO,1,6)  "
cQuery += " UNION ALL "
cQuery += " SELECT D3_FILIAL AS FILIAL,D3_COD AS CODIGO,SUM(D3_QUANT) AS CONSUMO,   SUBSTR(D3_EMISSAO,1,6) AS PERIODO "
cQuery += " FROM "+ RetSqlName("SD3") + " WHERE D3_EMISSAO BETWEEN '"+DTOS(_cDtIni)+"' AND '"+DTOS(_cDtFim)+"' "
cQuery += " AND D_E_L_E_T_ = ' '  AND D3_OP <> ' ' AND D3_CF  LIKE 'RE%' AND D3_ESTORNO = ' '  "
cQuery += " GROUP BY D3_FILIAL,D3_COD,SUBSTR(D3_EMISSAO,1,6)  "
cQuery += " ) DDDD "
cQuery += " GROUP BY FILIAL,CODIGO, PERIODO "
cQuery += " ORDER BY FILIAL,CODIGO, PERIODO "

MemoWrit("ESTM02_1.SQL",cQuery) //Gravei a Query em TXT p/Testes

lRet := .t.

nErrQry := TCSqlExec( cQuery )
If nErrQry <> 0
	if !_ljob
		MsgAlert('Erro no UPDATE: ' + AllTrim(Str(nErrQry)),'ATENวรO')
	else
		ConOut(Repl("-",80))
		ConOut("")
		ConOut('Erro no UPDATE: ' + AllTrim(Str(nErrQry)))
		ConOut("")
		ConOut(Repl("-",80))
	endif
	lRet := .F.
EndIf
End Transaction


If lRet
	
	Begin Transaction
	
	// ATUALIZANDO MEDIA DO MES
	
	cQuery := "	UPDATE "+ RetSqlName("SB3")
	cQuery += "	SET B3_Q"+strzero(val(mv_par01),2)+" =  NVL(( SELECT CONSUMO FROM CONS_MEDIO CONS  WHERE SB3010.B3_FILIAL = CONS.FILIAL AND SB3010.B3_COD  = CONS.CODIGO),0) "
	nErrQry := TCSqlExec( cQuery )
	If nErrQry <> 0
		if !_ljob
			MsgAlert('Erro no UPDATE: ' + AllTrim(Str(nErrQry)),'ATENวรO')
		else
			ConOut(Repl("-",80))
			ConOut("")
			ConOut('Erro no UPDATE: ' + AllTrim(Str(nErrQry)))
			ConOut("")
			ConOut(Repl("-",80))
		endif
		
		lRet := .F.
	EndIf
	End Transaction
	
	
	MemoWrit("ESTM02_2.SQL",cQuery) //Gravei a Query em TXT p/Testes
	
	// AJUSTANDO MEDIA GLOBAL
	
	If lRet
		
		_cPer02 :=  substr(dtos(_cDtFim-(32*1)),1,6)+"01"
		_cPer03 :=  substr(dtos(_cDtFim-(32*2)),1,6)+"01"
		_cPer04 :=  substr(dtos(_cDtFim-(32*3)),1,6)+"01"
		_cPer05 :=  substr(dtos(_cDtFim-(32*4)),1,6)+"01"
		_cPer06 :=  substr(dtos(_cDtFim-(32*5)),1,6)+"01"
		_cPer07 :=  substr(dtos(_cDtFim-(32*6)),1,6)+"01"
		_cPer08 :=  substr(dtos(_cDtFim-(32*7)),1,6)+"01"
		_cPer09 :=  substr(dtos(_cDtFim-(32*8)),1,6)+"01"
		_cPer10 :=  substr(dtos(_cDtFim-(32*9)),1,6)+"01"
		_cPer11 :=  substr(dtos(_cDtFim-(32*10)),1,6)+"01"
		_cPer12 :=  substr(dtos(_cDtFim-(32*11)),1,6)+"01"
		
		_cMeses := ''
		
		cQuery := "	UPDATE "+ RetSqlName("SB3")+chr(13)+chr(10)
		cQuery += "	SET B3_MEDIA = "+chr(13)+chr(10)
		For _nCount := 1 to 12
			if val(mv_par01)+1 <> _nCount
				_cMeses += 'B3_Q'+STRZERO(_nCount,2)+iif(_nCount<> 12,'+','')
			Endif
		Next _nCount
		
		cQuery += " ROUND(("+_cMeses+")/ "+chr(13)+chr(10)
		
		cQuery += " (   " +chr(13)+chr(10)
		cQuery += " CASE WHEN  (SELECT B1_DATREF FROM "+ RetSqlName("SB1")+" SB1 WHERE   B1_COD = B3_COD AND SB1.D_E_L_E_T_ = ' ' ) <= '"+_cPer02+"'  THEN  1 ELSE 0 END +"+chr(13)+chr(10)
		cQuery += " CASE WHEN  (SELECT B1_DATREF FROM "+ RetSqlName("SB1")+" SB1 WHERE   B1_COD = B3_COD AND SB1.D_E_L_E_T_ = ' ' ) <= '"+_cPer03+"'  THEN  1 ELSE 0 END +"+chr(13)+chr(10)
		cQuery += " CASE WHEN  (SELECT B1_DATREF FROM "+ RetSqlName("SB1")+" SB1 WHERE   B1_COD = B3_COD AND SB1.D_E_L_E_T_ = ' ' ) <= '"+_cPer04+"'  THEN  1 ELSE 0 END +"+chr(13)+chr(10)
		cQuery += " CASE WHEN  (SELECT B1_DATREF FROM "+ RetSqlName("SB1")+" SB1 WHERE   B1_COD = B3_COD AND SB1.D_E_L_E_T_ = ' ' ) <= '"+_cPer05+"'  THEN  1 ELSE 0 END +"+chr(13)+chr(10)
		cQuery += " CASE WHEN  (SELECT B1_DATREF FROM "+ RetSqlName("SB1")+" SB1 WHERE   B1_COD = B3_COD AND SB1.D_E_L_E_T_ = ' ' ) <= '"+_cPer06+"'  THEN  1 ELSE 0 END +"+chr(13)+chr(10)
		cQuery += " CASE WHEN  (SELECT B1_DATREF FROM "+ RetSqlName("SB1")+" SB1 WHERE   B1_COD = B3_COD AND SB1.D_E_L_E_T_ = ' ' ) <= '"+_cPer07+"'  THEN  1 ELSE 0 END +"+chr(13)+chr(10)
		cQuery += " CASE WHEN  (SELECT B1_DATREF FROM "+ RetSqlName("SB1")+" SB1 WHERE   B1_COD = B3_COD AND SB1.D_E_L_E_T_ = ' ' ) <= '"+_cPer08+"'  THEN  1 ELSE 0 END +"+chr(13)+chr(10)
		cQuery += " CASE WHEN  (SELECT B1_DATREF FROM "+ RetSqlName("SB1")+" SB1 WHERE   B1_COD = B3_COD AND SB1.D_E_L_E_T_ = ' ' ) <= '"+_cPer09+"'  THEN  1 ELSE 0 END +"+chr(13)+chr(10)
		cQuery += " CASE WHEN  (SELECT B1_DATREF FROM "+ RetSqlName("SB1")+" SB1 WHERE   B1_COD = B3_COD AND SB1.D_E_L_E_T_ = ' ' ) <= '"+_cPer10+"'  THEN  1 ELSE 0 END +"+chr(13)+chr(10)
		cQuery += " CASE WHEN  (SELECT B1_DATREF FROM "+ RetSqlName("SB1")+" SB1 WHERE   B1_COD = B3_COD AND SB1.D_E_L_E_T_ = ' ' ) <= '"+_cPer11+"'  THEN  1 ELSE 0 END +"+chr(13)+chr(10)
		cQuery += " CASE WHEN  (SELECT B1_DATREF FROM "+ RetSqlName("SB1")+" SB1 WHERE   B1_COD = B3_COD AND SB1.D_E_L_E_T_ = ' ' ) <= '"+_cPer12+"'  THEN  1 ELSE 0 END )"+chr(13)+chr(10)
		cQuery += " ,2)" +chr(13)+chr(10)
		
		cQuery += " WHERE "+chr(13)+chr(10)
		cQuery += " (" +chr(13)+chr(10)
		cQuery += " CASE WHEN  (SELECT B1_DATREF FROM "+ RetSqlName("SB1")+" SB1 WHERE   B1_COD = B3_COD AND SB1.D_E_L_E_T_ = ' ' ) <= '"+_cPer02+"'  THEN  1 ELSE 0 END +"+chr(13)+chr(10)
		cQuery += " CASE WHEN  (SELECT B1_DATREF FROM "+ RetSqlName("SB1")+" SB1 WHERE   B1_COD = B3_COD AND SB1.D_E_L_E_T_ = ' ' ) <= '"+_cPer03+"'  THEN  1 ELSE 0 END +"+chr(13)+chr(10)
		cQuery += " CASE WHEN  (SELECT B1_DATREF FROM "+ RetSqlName("SB1")+" SB1 WHERE   B1_COD = B3_COD AND SB1.D_E_L_E_T_ = ' ' ) <= '"+_cPer04+"'  THEN  1 ELSE 0 END +"+chr(13)+chr(10)
		cQuery += " CASE WHEN  (SELECT B1_DATREF FROM "+ RetSqlName("SB1")+" SB1 WHERE   B1_COD = B3_COD AND SB1.D_E_L_E_T_ = ' ' ) <= '"+_cPer05+"'  THEN  1 ELSE 0 END +"+chr(13)+chr(10)
		cQuery += " CASE WHEN  (SELECT B1_DATREF FROM "+ RetSqlName("SB1")+" SB1 WHERE   B1_COD = B3_COD AND SB1.D_E_L_E_T_ = ' ' ) <= '"+_cPer06+"'  THEN  1 ELSE 0 END +"+chr(13)+chr(10)
		cQuery += " CASE WHEN  (SELECT B1_DATREF FROM "+ RetSqlName("SB1")+" SB1 WHERE   B1_COD = B3_COD AND SB1.D_E_L_E_T_ = ' ' ) <= '"+_cPer07+"'  THEN  1 ELSE 0 END +"+chr(13)+chr(10)
		cQuery += " CASE WHEN  (SELECT B1_DATREF FROM "+ RetSqlName("SB1")+" SB1 WHERE   B1_COD = B3_COD AND SB1.D_E_L_E_T_ = ' ' ) <= '"+_cPer08+"'  THEN  1 ELSE 0 END +"+chr(13)+chr(10)
		cQuery += " CASE WHEN  (SELECT B1_DATREF FROM "+ RetSqlName("SB1")+" SB1 WHERE   B1_COD = B3_COD AND SB1.D_E_L_E_T_ = ' ' ) <= '"+_cPer09+"'  THEN  1 ELSE 0 END +"+chr(13)+chr(10)
		cQuery += " CASE WHEN  (SELECT B1_DATREF FROM "+ RetSqlName("SB1")+" SB1 WHERE   B1_COD = B3_COD AND SB1.D_E_L_E_T_ = ' ' ) <= '"+_cPer10+"'  THEN  1 ELSE 0 END +"+chr(13)+chr(10)
		cQuery += " CASE WHEN  (SELECT B1_DATREF FROM "+ RetSqlName("SB1")+" SB1 WHERE   B1_COD = B3_COD AND SB1.D_E_L_E_T_ = ' ' ) <= '"+_cPer11+"'  THEN  1 ELSE 0 END +"+chr(13)+chr(10)
		cQuery += " CASE WHEN  (SELECT B1_DATREF FROM "+ RetSqlName("SB1")+" SB1 WHERE   B1_COD = B3_COD AND SB1.D_E_L_E_T_ = ' ' ) <= '"+_cPer12+"'  THEN  1 ELSE 0 END )"+chr(13)+chr(10)
		cQuery += "   > 0 "+chr(13)+chr(10)
		
		
		MemoWrit("ESTM02_3.SQL",cQuery) //Gravei a Query em TXT p/Testes
		
		Begin Transaction
		
		nErrQry := TCSqlExec( cQuery )
		If nErrQry <> 0
			if !_ljob
				MsgAlert('Erro no UPDATE: ' + AllTrim(Str(nErrQry)),'ATENวรO')
			else
				ConOut(Repl("-",80))
				ConOut("")
				ConOut('Erro no UPDATE: ' + AllTrim(Str(nErrQry)))
				ConOut("")
				ConOut(Repl("-",80))
			endif
			lRet := .F.
		EndIf
		
		End Transaction
		
	Endif
	
	_cMsg+="Fim: " + dtoc(date()) + " " + time()  +chr(13)+chr(10)
	
Endif

if !_ljob
	
	MsgAlert(_cMSg)
	
else
	ConOut(Repl("-",80))
	ConOut("")
	ConOut(_cMSg)
	ConOut("")
	ConOut(Repl("-",80))
	
		
	MemoWrit("ESTM02.LOG",_cMSg) //Gravei a Query em TXT p/Testes
		
endif

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o	 ณAjusta    ณ Autor ณ RVG  					ณ Data ณ 13/06/2014	     	ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Insere novas perguntas na tabela SX1 a Ajusta o Picture dos valores	ณฑฑ
ฑฑณ          ณ no SX3                                                           	ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณSintaxe e ณ 																		ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Ajusta()

Local aPergs 	:= {}

Aadd(aPergs,{"Mes ?                        ","Mes ?                        ","Mes ?                        ","mv_ch1","C",2,0,0,"G",""                    ,"mv_par01","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","","","S","",""})
Aadd(aPergs,{"Ano  ?                       ","Ano ?        				   ","Ano ?               		   ","mv_ch2","C",4,0,0,"G",""                    ,"mv_par02","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","","","S","",""})

//AjustaSx1("STESR00201",aPergs)

Return
