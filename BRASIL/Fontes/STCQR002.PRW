#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTCQR001  บAutor  ณMicrosiga           บ Data ณ  09/16/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function STCQR001

Local oReport

cperg 	 := "ESTTRI0001"

oReport		:= ReportDef()
oReport		:PrintDialog()


Return

Static Function ReportDef()

Local oReport
Local oSection

ValidPerg()

oReport := TReport():New("STCQR001","RELATำRIO INDICADORES STECK",CPERG,{|oReport| ReportPrint(oReport)},"Este programa irแ imprimir um relat๓rio de indicadores STECK ")


pergunte(cperg ,.F.)

oSection := TRSection():New(oReport,"PRODS",{"TRB"})

TRCell():New(oSection,"DT_LANC"		,"TRB","Data Lanc"		,					,8)
TRCell():New(oSection,"ORD_PROD"	,"TRB","Ord.Producao"	,					,12)
TRCell():New(oSection,"PRODUTO"		,"TRB","Produto"		,	 				,15)
TRCell():New(oSection,"QTDE_OP"		,"TRB","Quant. OP"		,'@E 999,999,999'	,15)
TRCell():New(oSection,"OPERACAO"	,"TRB","Operacao"		,					,4)
TRCell():New(oSection,"RI"			,"TRB","RI"     		,					,6)
TRCell():New(oSection,"CT_CUSTO"	,"TRB","C.Custo"		,					,10)
TRCell():New(oSection,"GRUPO_MAQ"	,"TRB","Grupo Maquina"  ,					,6)
TRCell():New(oSection,"MAQUINA"		,"TRB","Recurso"		,					,6)
TRCell():New(oSection,"OCORRENCIA"	,"TRB","Ocorrencia" 	,					,6)
TRCell():New(oSection,"TOH"			,"TRB","T.O.H."			,                  	,15)
TRCell():New(oSection,"PECAS_BOAS"	,"TRB","Quant. Boas"	,'@E 99,999,999.999'	,15)
TRCell():New(oSection,"PECAS_PERD"	,"TRB","Quant. Perda"	,'@E 99,999,999.999'	,15)
TRCell():New(oSection,"TS_PREP"		,"TRB","Setup"			,'@E 99,999,999.999'	,15)
TRCell():New(oSection,"HORAS_ROTEIRO","TRB","pcs P/ Rota" 	,'@E 99,999,999.999'	,15)
TRCell():New(oSection,"TEMPO_PADRAO","TRB","Tempo P/ Rota" 	,'@E 99,999,999.999'	,15)
TRCell():New(oSection,"MP_CONSUM"	,"TRB","M.Prima Consumo",						,15)
//TRCell():New(oSection,"MP_PERDA"	,"TRB","M.Prima Perda"	,						,15)
//TRCell():New(oSection,"MP_REFUGO"	,"TRB","M.Prima Refugo" ,						,15)
TRCell():New(oSection,"MOT_REFUGO"	,"TRB","Motivo Refugo"	,						,15)

oSection:SetHeaderSection(.T.)

Return oReport

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTCQR001  บAutor  ณMicrosiga           บ Data ณ  06/26/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ReportPrint(oReport)

Local oSection	:= oReport:Section(1)

_cQuery := "SELECT "
_cQuery += "PP2_FILIAL   AS FILIAL ,"
_cQuery += "'PP2'   AS ORIGEM ,"
_cQuery += "PP2_DTINI    AS DT_LANC,"
_cQuery += "PP2_CODIGO 		 AS ORD_PROD,"
_cQuery += "C2_PRODUTO   AS PRODUTO,"
_cQuery += "C2_QUANT     AS QTDE_OP,"
_cQuery += "PP2_OPER     AS OPERACAO,"
_cQuery += "PP2_OPERAD     AS RI,"
_cQuery += "H1_CCUSTO    AS CT_CUSTO,"
_cQuery += "G2_LINHAPR   AS GRUPO_MAQ,"
_cQuery += "PP2_RECURS    AS MAQUINA,"
_cQuery += "'PR'		 AS OCORRENCIA,"

_cQuery += "   ' '   AS TOH,"

_cQuery += "PP2_HRINI AS HR_INI, "
_cQuery += "PP2_HRFIM AS HR_FIM, "
_cQuery += "PP2_DTINI AS DT_INI, "
_cQuery += "PP2_DTFIM AS DT_FIM, "
/*/

_cQuery += "    ((( TO_DATE(SUBSTR(PP2_DTFIM,7,2) || '/' || SUBSTR(PP2_DTFIM,5,2) || '/' || SUBSTR(PP2_DTFIM,1,4) || ' ' || PP2_HRFIM || ':00' ,   'DD/MM/YYYY HH24:MI:SS')  - TO_DATE(SUBSTR(PP2_DTINI,7,2) || '/' || SUBSTR(PP2_DTINI,5,2) || '/' || SUBSTR(PP2_DTINI,1,4) || ' ' || PP2_HRINI || ':00' ,   'DD/MM/YYYY HH24:MI:SS') ) * 15 ) * 96) AS TIME_PAS, "

_cQuery += "  ( SELECT SUM(((( TO_DATE(SUBSTR(PP2_DTFIM,7,2) || '/' || SUBSTR(PP2_DTFIM,5,2) || '/' || SUBSTR(PP2_DTFIM,1,4) || ' ' || PP2_HRFIM || ':00' ,   'DD/MM/YYYY HH24:MI:SS')  - TO_DATE(SUBSTR(PP2_DTINI,7,2) || '/' || SUBSTR(PP2_DTINI,5,2) || '/' || SUBSTR(PP2_DTINI,1,4) || ' ' || PP2_HRINI || ':00' ,   'DD/MM/YYYY HH24:MI:SS') ) * 15 ) * 96))  
_cQuery += "           FROM "+RETSQLNAME("PP2")+" PP2X WHERE PP2X.PP2_CODIGO = PP2.PP2_CODIGO AND PP2X.PP2_OPER = PP2.PP2_OPER AND D_E_L_E_T_ = ' ' "
             
_cQuery += " 		 AND PP2_HRINI <> '00:0 ' "
_cQuery += "         AND SUBSTR(PP2_HRINI,1,2)  BETWEEN '00' AND '23' "       
_cQuery += "         AND SUBSTR(PP2_HRINI,4,2)  BETWEEN '00' AND '59' " 	 
_cQuery += "         AND SUBSTR(PP2_DTINI,1,4)  = '2013' "      
_cQuery += "         AND SUBSTR(PP2_DTINI,7,2)  <> '  ' "     

_cQuery += " 		 AND PP2_HRFIM <> '00:0 ' "
_cQuery += "         AND SUBSTR(PP2_HRFIM,1,2)  BETWEEN '00' AND '23' "
_cQuery += "         AND SUBSTR(PP2_HRFIM,4,2)  BETWEEN '00' AND '59'  "
_cQuery += "         AND SUBSTR(PP2_DTFIM,1,4)  = '2013'      
_cQuery += "         AND SUBSTR(PP2_DTFIM,7,2)  <> '  '  "    

_cQuery += ") AS TIME_TOTAL  , 
/*/
_cQuery += "   0    AS TIME_PAS,"
_cQuery += "   0    AS TIME_TOTAL,"
 
_cQuery += " (SELECT SUM(D3_QUANT) FROM "+RETSQLNAME("SD3")+" WHERE D3_EMISSAO >=  '"+dtos(MV_PAR01) + "'  AND D3_CF LIKE 'PR%' AND D_E_L_E_T_ = ' ' AND D3_OP = PP2_CODIGO ) AS PECAS_BOAS,    "
_cQuery += "0  AS PECAS_PERD,"
_cQuery += "0  AS TEMPO_PADRAO,"
_cQuery += "G2_SETUP    AS TS_PREP,"
_cQuery += "G2_TEMPAD   AS TS_PROD,"
_cQuery += "G2_LOTEPAD  AS HORAS_ROTEIRO,"
_cQuery += "'             ' AS MP_CONSUM,"
_cQuery += "'             ' AS MP_PERDA,"
_cQuery += "'             ' AS MP_REFUGO,"
_cQuery += "'             ' AS MOT_REFUGO "
_cQuery += " FROM "
_cQuery += RETSQLNAME("PP2")+" PP2, "
_cQuery += RETSQLNAME("SG2")+" SG2, "
_cQuery += RETSQLNAME("SH1")+" SH1, "
_cQuery += RETSQLNAME("SB1")+" SB1, "
_cQuery += RETSQLNAME("SC2")+" SC2 "
_cQuery += " WHERE "
_cQuery	+= 		"PP2.D_E_L_E_T_ = ' ' AND "
_cQuery	+= 		"SG2.D_E_L_E_T_ = ' ' AND "
_cQuery	+= 		"SH1.D_E_L_E_T_ = ' ' AND "
_cQuery	+= 		"SB1.D_E_L_E_T_ = ' ' AND "
_cQuery	+= 		"SC2.D_E_L_E_T_ = ' ' AND "
_cQuery	+= 		"SC2.C2_PRODUTO = SB1.B1_COD AND "
_cQuery	+= 		"PP2.PP2_CODIGO BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' AND "
_cQuery	+= 		"PP2.PP2_DTINI  BETWEEN  '"+dtos(MV_PAR01)+"' AND '"+dtos(MV_PAR02)+"' AND "
_cQuery	+= 		"SC2.C2_PRODUTO BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' AND "
_cQuery	+= 		"SUBSTR(PP2.PP2_CODIGO,1,6) = SC2.C2_NUM AND "
_cQuery	+= 		"SUBSTR(PP2.PP2_CODIGO,7,2) = SC2.C2_ITEM  AND "
_cQuery	+= 		"SUBSTR(PP2.PP2_CODIGO,9,3) = SC2.C2_SEQUEN AND "
_cQuery	+= 		"SC2.C2_PRODUTO  = SB1.B1_COD 		AND "
_cQuery	+= 		"SC2.C2_PRODUTO  = SG2.G2_PRODUTO 	AND "
_cQuery	+= 		"SC2.C2_ROTEIRO  = SG2.G2_CODIGO 	AND "
_cQuery	+= 		"PP2.PP2_OPER 	 = SG2.G2_OPERAC 	AND "
_cQuery	+= 		"PP2.PP2_RECURS  = SH1.H1_CODIGO 	AND "
_cQuery	+= 		"PP2.PP2_FILIAL  = SH1.H1_FILIAL  	AND "
_cQuery	+= 		"PP2.PP2_HRINI  <> ' '    	AND "
_cQuery	+= 		"PP2.PP2_HRFIM  <> ' '    	AND "
_cQuery	+= 		"PP2.PP2_FILIAL = '"+xFILIAL("PP2")+"' 	AND "
_cQuery	+= 		"SC2.C2_FILIAL = '"+xFILIAL("SC2")+"' 	AND "
_cQuery	+= 		"PP2.PP2_OPERAD  BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"' AND "
_cQuery	+= 		"SH1.H1_CCUSTO   BETWEEN '"+MV_PAR09+"' AND '"+MV_PAR10+"' AND "
_cQuery	+= 		"SG2.G2_RECURSO  BETWEEN '"+MV_PAR11+"' AND '"+MV_PAR12+"' AND "
_cQuery	+= 		"SG2.G2_CTRAB    BETWEEN '"+MV_PAR13+"' AND '"+MV_PAR14+"' AND "
_cQuery	+= 		"SG2.G2_LOTEPAD <> 0 "
     

_cQuery	+= 		" UNION ALL "


_cQuery += "SELECT "
_cQuery += "PP3_FILIAL   AS FILIAL ,"
_cQuery += "'PP3'   AS ORIGEM ,"
_cQuery += "PP3_DTINI    AS DT_LANC,"
_cQuery += "PP3_CODIGO 	 AS ORD_PROD,"
_cQuery += "C2_PRODUTO   AS PRODUTO,"
_cQuery += "C2_QUANT     AS QTDE_OP,"
_cQuery += "PP3_OPER     AS OPERACAO,"
_cQuery += "PP3_OPERAD   AS RI,"
_cQuery += "H1_CCUSTO    AS CT_CUSTO,"
_cQuery += "G2_LINHAPR   AS GRUPO_MAQ,"
_cQuery += "PP3_RECURS   AS MAQUINA,"
_cQuery += "PP3_MOTIVO	 AS OCORRENCIA, "


_cQuery += "   ' '    AS TOH,"

_cQuery += "PP3_HRINI AS HR_INI, "
_cQuery += "PP3_HRFIM AS HR_FIM, "
_cQuery += "PP3_DTINI AS DT_INI, "
_cQuery += "PP3_DTFIM AS DT_FIM, "
_cQuery += "   0    AS TIME_PAS,"
_cQuery += "   0    AS TIME_TOTAL,"

_cQuery += "0  AS PECAS_BOAS,"
_cQuery += "0  AS PECAS_PERD,"
_cQuery += "0  AS TEMPO_PADRAO,"

_cQuery += "G2_SETUP    AS TS_PREP,"
_cQuery += "G2_TEMPAD   AS TS_PROD,"
_cQuery += "G2_LOTEPAD  AS HORAS_ROTEIRO,"

_cQuery += "'             ' AS MP_CONSUM,"
_cQuery += "'             ' AS MP_PERDA,"
_cQuery += "'             ' AS MP_REFUGO,"
_cQuery += "'             ' AS MOT_REFUGO "

_cQuery += " FROM "
_cQuery += RETSQLNAME("PP3")+" PP3, "
_cQuery += RETSQLNAME("SG2")+" SG2, "
_cQuery += RETSQLNAME("SH1")+" SH1, "
_cQuery += RETSQLNAME("SB1")+" SB1, "
_cQuery += RETSQLNAME("SC2")+" SC2 "
_cQuery += " WHERE "
_cQuery	+= 		"PP3.D_E_L_E_T_ = ' ' AND "
_cQuery	+= 		"SG2.D_E_L_E_T_ = ' ' AND "
_cQuery	+= 		"SH1.D_E_L_E_T_ = ' ' AND "
_cQuery	+= 		"SB1.D_E_L_E_T_ = ' ' AND "
_cQuery	+= 		"SC2.D_E_L_E_T_ = ' ' AND "
_cQuery	+= 		"SC2.C2_PRODUTO = SB1.B1_COD AND "
_cQuery	+= 		"PP3.PP3_CODIGO BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' AND "
_cQuery	+= 		"PP3.PP3_DTINI  BETWEEN  '"+dtos(MV_PAR01)+"' AND '"+dtos(MV_PAR02)+"' AND "
_cQuery	+= 		"SC2.C2_PRODUTO BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' AND "
_cQuery	+= 		"SUBSTR(PP3.PP3_CODIGO,1,6) = SC2.C2_NUM AND "
_cQuery	+= 		"SUBSTR(PP3.PP3_CODIGO,7,2) = SC2.C2_ITEM  AND "
_cQuery	+= 		"SUBSTR(PP3.PP3_CODIGO,9,3) = SC2.C2_SEQUEN AND "
_cQuery	+= 		"SC2.C2_PRODUTO  = SB1.B1_COD 		AND "
_cQuery	+= 		"SC2.C2_ROTEIRO  = SG2.G2_CODIGO 	AND "
_cQuery	+= 		"SC2.C2_PRODUTO  = SG2.G2_PRODUTO 	AND "
_cQuery	+= 		"PP3.PP3_OPER 	 = SG2.G2_OPERAC 	AND "
_cQuery	+= 		"PP3.PP3_RECURS  = SH1.H1_CODIGO 	AND "
_cQuery	+= 		"PP3.PP3_FILIAL  = SH1.H1_FILIAL  	AND "
_cQuery	+= 		"PP3.PP3_HRINI  <> ' '    	AND "
_cQuery	+= 		"PP3.PP3_HRFIM  <> ' '    	AND "
_cQuery	+= 		"SC2.C2_FILIAL = '"+xFILIAL("SC2")+"' 	AND "
_cQuery	+= 		"PP3.PP3_FILIAL = '"+xFILIAL("PP3")+"' 	AND "
_cQuery	+= 		"SG2.G2_LOTEPAD <> 0 "

_cQuery	+= 		" UNION ALL "

_cQuery += "SELECT "            
_cQuery += "H6_FILIAL   AS FILIAL ,"
_cQuery += "'SH6'   AS ORIGEM ,"
_cQuery += "H6_DATAINI  AS DT_LANC,"
_cQuery += "H6_OP 		AS ORD_PROD,"
_cQuery += "H6_PRODUTO  AS PRODUTO,"
_cQuery += "0   AS QTDE_OP,"
_cQuery += "H6_OPERAC   AS OPERACAO,"
_cQuery += "H6_OPERADO  AS RI,"
_cQuery += "' '   AS CT_CUSTO,"      
_cQuery += "' '  AS GRUPO_MAQ,"
_cQuery += "H6_RECURSO  AS MAQUINA,"
_cQuery += "H6_MOTIVO     AS OCORRENCIA,"

_cQuery += " ' ' AS TOH , " //"(TO_NUMBER(SUBSTR(H6_TEMPO,1,3))    + (TO_NUMBER(SUBSTR(H6_TEMPO,5,2))/60 )  )  AS TOH, "

_cQuery += "H6_HORAINI AS HR_INI, "
_cQuery += "H6_HORAFIN AS HR_FIM, "
_cQuery += "H6_DATAINI AS DT_INI, "
_cQuery += "H6_HORAFIN AS DT_FIM, "
_cQuery += "   0    AS TIME_PAS,"
_cQuery += "   0    AS TIME_TOTAL,"

_cQuery += "0  AS PECAS_BOAS,"
_cQuery += "0  AS PECAS_PERD,"
_cQuery += "0  AS TEMPO_PADRAO,"       

_cQuery += "0    AS TS_PREP,"
_cQuery += "0    AS TS_PROD,"
_cQuery += "0    AS HORAS_ROTEIRO,"

_cQuery += "'             ' AS MP_CONSUM,"
_cQuery += "'             ' AS MP_PERDA,"
_cQuery += "'             ' AS MP_REFUGO,"	
_cQuery += "'             ' AS MOT_REFUGO "

_cQuery += " FROM "
_cQuery += RETSQLNAME("SH6")+" SH6 "
_cQuery += " WHERE "
_cQuery	+= 		"SH6.D_E_L_E_T_ = ' ' AND "
_cQuery	+= 		"SH6.H6_OP BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' AND "
_cQuery	+= 		"SH6.H6_DATAINI BETWEEN  '"+dtos(MV_PAR01)+"' AND '"+dtos(MV_PAR02)+"' AND "
_cQuery	+= 		"SH6.H6_FILIAL = '"+xFILIAL("SH6")+"' 	AND "
_cQuery	+= 		"SH6.H6_OP  = ' '  	  "
 
_cQuery	+= " ORDER BY  FILIAL, ORD_PROD ,  OPERACAO , MAQUINA "


MsAguarde({|| dbUseArea(.T.,"TOPCONN",TCGenQry(,,_cQuery),"TRB",.T.,.T.)},OemToAnsi("Seleccionado registros"))


DbSelectArea("TRB")     
TcSetField('TRB','QUANT_OP' 		,'N',18,4)
TcSetField('TRB','PECAS_BOAS' 		,'N',18,4)
TcSetField('TRB','PECAS_PERDAS' 	,'N',18,4)
TcSetField('TRB','TEMPO_PADRAO' 	,'N',18,4)
TcSetField('TRB','DT_LANC'  		,'D',08,0)
TcSetField('TRB','TS_PREP'  		,'N',18,4)
TcSetField('TRB','TS_PROD'  		,'N',18,4)
TcSetField('TRB','PECAS_HORA' 		,'N',18,4)
TcSetField('TRB','DT_FIM' 	 		,'D',08,0)
TcSetField('TRB','DT_INI'	  		,'D',08,0)

DbGoTop()

_nRec := 0
DbEval({|| _nRec++  })

DbGoTop()


oReport:SetTitle("Indicadores Steck")// Titulo do relat๓rio

oReport:SetMeter(_nRec)
oSection:Init()

While TRB->(!Eof())
	
	_cArea := getarea() 
	_nREc := Recno()
	OrdProd := TRB->ORD_PROD  
	OPERAC  := TRB->OPERACAO 
	IF TRB->ORIGEM = 'SH6'                                
		_nHoras :=    CalcTime(TRB->DT_INI,TRB->HR_INI,TRB->DT_INI,TRB->HR_FIM)
     ELSE
		_nHoras :=    CalcTime(TRB->DT_INI,TRB->HR_INI,TRB->DT_FIM,TRB->HR_FIM)
	ENDIF
	_nHoras := substr(_nHoras,2,5) 
    _xlminutos := val(substr(_nHoras,1,2)) *60  + val(substr(_nHoras,4,2)) / 60
	_xlminutos := round(_xlminutos,2)

	 IF TRB->OCORRENCIA = 'PR'
	
	    _GetTotal := _GetTotal(TRB->ORD_PROD,TRB->OPERACAO)
		_cMp := getMP(TRB->ORD_PROD)
		oSection:Cell("MP_CONSUM"):SetBlock( { || _cMp } )
        oSection:Cell("PECAS_BOAS"):SetBlock( { || trb->PECAS_BOAS*(_xlminutos/_GetTotal) } )
        oSection:Cell("HORAS_ROTEIRO"):SetBlock( { || (HORAS_ROTEIRO/60)*(_xlminutos ) } )
        oSection:Cell("TEMPO_PADRAO"):SetBlock( { || (trb->PECAS_BOAS*(_xlminutos/_GetTotal)) * (  TS_PROD / HORAS_ROTEIRO ) } )
         
	 Endif

	 IF TRB->OCORRENCIA <> '00'
        oSection:Cell("TS_PREP"):SetBlock( { ||  0 } )
     Else
        oSection:Cell("TS_PREP"):SetBlock( { ||  TRB->TS_PREP } )
     Endif
	
 	oSection:Cell("TOH"):SetBlock( { ||  _xLminutos/60  } )

	DbSelectArea("TRB")

	oSection:PrintLine()
	oReport:IncMeter()
	
	TRB->(DbSkip())
End

oSection:Finish()

DbSelectArea("TRB")
DbCloseArea()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณESTRL011  บAutor  ณMicrosiga           บ Data ณ  06/10/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ValidPerg()
Local i		:= 0
DbSelectArea("SX1")
DbSetOrder(1)
cPerg := PADR(cPerg,10)
aRegs:={}
aAdd(aRegs,{cPerg,"01","Da Data ?      		","","","MV_CH1","D", 8,0,0,"G","","mv_par01",""         ,"","","","",""         ,"","","","","","","","","","","","","","","","","","",""       ,"S","",""})
aAdd(aRegs,{cPerg,"02","Ate a Data ?   		","","","MV_CH2","D", 8,0,0,"G","","mv_par02",""         ,"","","","",""         ,"","","","","","","","","","","","","","","","","","",""       ,"S","",""})
aAdd(aRegs,{cPerg,"03","Do Produto ?      	","","","MV_CH3","C", 15,0,0,"G","","mv_par03",""         ,"","","","",""         ,"","","","","","","","","","","","","","","","","","","SB1"   ,"S","",""})
aAdd(aRegs,{cPerg,"04","Ate o produto ?   	","","","MV_CH4","C", 15,0,0,"G","","mv_par04",""         ,"","","","",""         ,"","","","","","","","","","","","","","","","","","","SB1"   ,"S","",""})
aAdd(aRegs,{cPerg,"05","Da OP ?      		","","","MV_CH5","C", 13,0,0,"G","","mv_par05",""         ,"","","","",""         ,"","","","","","","","","","","","","","","","","","","SC2"   ,"S","",""})
aAdd(aRegs,{cPerg,"06","Ate a OP ?  		","","","MV_CH6","C", 13,0,0,"G","","mv_par06",""         ,"","","","",""         ,"","","","","","","","","","","","","","","","","","","SC2"   ,"S","",""})
aAdd(aRegs,{cPerg,"07","Do RI ?      		","","","MV_CH7","C", 06,0,0,"G","","mv_par07",""         ,"","","","",""         ,"","","","","","","","","","","","","","","","","","","SRA"   ,"S","",""})
aAdd(aRegs,{cPerg,"08","Ate o RI ?  		","","","MV_CH8","C", 06,0,0,"G","","mv_par08",""         ,"","","","",""         ,"","","","","","","","","","","","","","","","","","","SRA"   ,"S","",""})
aAdd(aRegs,{cPerg,"09","Do C.Custo ?      	","","","MV_CH9","C", 10,0,0,"G","","mv_par09",""         ,"","","","",""         ,"","","","","","","","","","","","","","","","","","","CTT"   ,"S","",""})
aAdd(aRegs,{cPerg,"10","Ate o Custo ?  		","","","MV_CHA","C", 10,0,0,"G","","mv_par10",""         ,"","","","",""         ,"","","","","","","","","","","","","","","","","","","CTT"   ,"S","",""})
aAdd(aRegs,{cPerg,"11","Do Recurso ?      	","","","MV_CHB","C", 06,0,0,"G","","mv_par11",""         ,"","","","",""         ,"","","","","","","","","","","","","","","","","","","SH1"   ,"S","",""})
aAdd(aRegs,{cPerg,"12","Ate o Recurso  ?  	","","","MV_CHC","C", 06,0,0,"G","","mv_par12",""         ,"","","","",""         ,"","","","","","","","","","","","","","","","","","","SH1"   ,"S","",""})
aAdd(aRegs,{cPerg,"13","Do C.Trabalho  ?    ","","","MV_CHD","C", 06,0,0,"G","","mv_par13",""         ,"","","","",""         ,"","","","","","","","","","","","","","","","","","","SHB"   ,"S","",""})
aAdd(aRegs,{cPerg,"14","Ate C.Trabalho  ?  	","","","MV_CHE","C", 06,0,0,"G","","mv_par14",""         ,"","","","",""         ,"","","","","","","","","","","","","","","","","","","SHB"   ,"S","",""})
//            1    2     3                    4  5     6      7   8  9 10 11  12   13        14         15 16 17 18  19          20 21 22 23 24 25  26 27 28 29 30 31 32 33 34 35 36 37 38        39  40 41
 
For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		/* Removido - 18/05/2023 - Nใo executa mais Recklock na X1 - Criar/alterar perguntas no configurador
		Reclock("SX1",.t.)
		SX1->X1_GRUPO   := cPerg
		SX1->X1_ORDEM   := aRegs[i,2]
		SX1->X1_PERGUNT := aRegs[i,3]
		SX1->X1_VARIAVL := aRegs[i,6]
		SX1->X1_TIPO    := aRegs[i,7]
		SX1->X1_TAMANHO := aRegs[i,8]
		SX1->X1_DECIMAL := aRegs[i,9]
		SX1->X1_PRESEL  := aRegs[i,10]
		SX1->X1_GSC     := aRegs[i,11]
		SX1->X1_VALID   := ""
		SX1->X1_VAR01   := aRegs[i,13]
		SX1->X1_DEF01   := aRegs[i,14]
		SX1->X1_DEF02   := aRegs[i,19]
		SX1->X1_DEF03   := aRegs[i,24]
		SX1->X1_F3      := aRegs[i,38]
		MsUnlock()
		dbCommit()*/
	EndIf
Next

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTCQR001  บAutor  ณMicrosiga           บ Data ณ  06/11/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


Static Function ConvHora(cHora, cDe, cPara)


Local nTime    := Val(StrTran(cHora, ":", "."))
Local nHoras   := Int(nTime)
Local nMinutos := (nTime - nHoras)
Local lContinua:= .T.

If Empty(StrTran(cHora, ":", ""))
	lContinua := .F.
EndIf

If lContinua
	cPara := If(cPara == Nil, "N", cPara)
	
	If nMinutos >= .6 .And. cDe == "N"
		nHoras += 1
		nMinutos -= If(cPara == "N", .6, 1)
	EndIf
	
	If cDe == "N" .And. cPara == "C"
		nMinutos := nMinutos / .6
	ElseIf cDe == "C" .And. cPara == "N"
		nMinutos := nMinutos * .6
	EndIf
	cHora := StrZero(nHoras, At(":", cHora) - 1) + ":" + StrZero(nMinutos * 100, 2)
EndIf
Return(cHora)




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณ CalcTime ณ Autor ณ RVG Solucoes          ณ Data ณ 21/03/13 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Calcula tempo gasto na operacao                            ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CalcTime(_dDtIni,_CHrini,_dDtFim,_cHrFim)
Static cTpHr
Local cTime      :=""
Local nTempoCen  :=0
Local lUsaCalend := GetMV("MV_USACALE",, .T.)
Local cForHora   :=  "N"
Local nZeros     := At(":", PesqPict("SH6", "H6_TEMPO")) - 1
//Local lApsDrummer:= SuperGetMv("MV_APS",.F.,"")=="DRUMMER"

If cTpHr == Nil
	cTpHr := GetMv("MV_TPHR")
EndIf

If lUsaCalend
	If !Empty(PP2->PP2_RECURS)
		SH1->(dbSetOrder(1))
		If SH1->(dbSeek(xFilial("SH1")+PP2->PP2_RECURS))
			nTempoCen:=A680TimeCale(_dDtIni,A680ConvHora(_CHrini, cForHora),_dDtFim,A680ConvHora(_cHrFim, cForHora),PP2->PP2_RECURS)
			
		Else
			nTempoCen:=0
		EndIf
	EndIf
Else
	nTempoCen := A680Tempo(_dDtIni,A680ConvHora(_CHrini, cForHora),_dDtFim,A680ConvHora(_cHrFim, cForHora))
EndIf

cTime := StrZero(Int(nTempoCen), nZeros) + ":" + StrZero(Mod(nTempoCen, 1) * 100, 2)
cTime := A680ConvHora(cTime, "C", cForHora)

Return cTime


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTCQR001  บAutor  ณMicrosiga           บ Data ณ  09/16/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


Static Function GetMp(_cOp)
DbSelectArea("SD3")
DbSetOrder(1)      					// filial+op+cod+local
DbSeek (Xfilial("SD3")+_cOP )
_cmp := ""
_cVal := 0
Do While !Eof() .and.ALLTRIM(SD3->D3_OP) == ALLTRIM( _cOp )													//enquanto for a mesma OP
	
	If Substr(SD3->D3_CF,1,2) <> "PR"   .and. SD3->D3_TIPO = 'MP'
		IF SD3->D3_CUSTO1 > _cVal
		   _cVal:= SD3->D3_CUSTO1
		   _cMP := SD3->D3_COD
		Endif
	Endif
	DbSelectArea("SD3")
	SD3->(DbSkip())
	
EndDo

Return(_cMP )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTCQR001  บAutor  ณMicrosiga           บ Data ณ  09/20/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function _GetTotal(_cOp,_cOperacao)

Local _nHoras:= 0
Local _xMinutos := 0

 
DbSelectarea("PP2")
dbsetorder(1)

Dbseek(xfilial("PP2")+substr(_cOp,1,11))

do while !EOF() .and. substr(PP2->PP2_CODIGO,1,11) == substr(_cOp,1,11)
    
    if alltrim(PP2->PP2_OPER)    == ALLTRIM(_cOperacao)
		_nHoras := CalcTime(PP2->PP2_DTINI,PP2->PP2_HRINI,PP2->PP2_DTFIM,PP2->PP2_HRFIM)
  		_nHoras := substr(_nHoras,2,5) 
 	   _xminutos += val(substr(_nHoras,1,2)) *60  + val(substr(_nHoras,4,2)) 
	endif
	Dbskip()
Enddo
_xminutos := round(_xminutos,2)
Return  _xminutos
