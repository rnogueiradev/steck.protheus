#include "protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ STFISF02 บAutor  ณ FlexProjects       บ Data ณ  12/28/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina para Atualizar a Base Reduzida do ICMS de Manaus    บฑฑ
ฑฑบ          ณ Conforme Solicita็ใo do Cliente                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Steck - P11                                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAltera็ใo ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function STFISF02()

	If !(cEmpAnt == '03')
		Alert("Empresa nใo autorizada a utilizar essa rotina")
		Return
	Endif
	Ajusta()
	
	If ApMsgYesNo("Atualiza a Base de ICMS das Notas de Entrada (S/N)?")
		pergunte("STFISF02",.F.)
		
		If pergunte("STFISF02",.T.)
			Processa({||ProcFISF02(),"Processando ..."})
		Endif
	Endif
	
	MsgAlert("Processamento finalizado.")
	
Return

Static Function ProcFISF02()
	
	Local cQuery1	:= ""
	
	ProcRegua(0)
	
	IncProc("Atualizando Campos CDA_BASE e CDA_VALOR ... ")
	
	cQuery1	:= "MERGE INTO "+RetSqlName("CDA")+" T1 USING ( "
	cQuery1	+= "SELECT CDA.R_E_C_N_O_ CDA_REC,CDA_FILIAL, CDA_CODLAN, CDA_TPMOVI, CDA_ESPECI, CDA_NUMERO, CDA_SERIE, CDA_CLIFOR, CDA_LOJA, CDA_NUMITE, CDA_BASE, CDA_ALIQ, CDA_VALOR, D1_DTDIGIT, D1_BASEICM, D1_PICM, D1_VALICM,D1_TES  "
	cQuery1	+= "FROM "+RetSqlName("CDA")+" CDA "
	cQuery1	+= "INNER JOIN "+RetSqlName("SD1")+" SD1 ON D1_FILIAL = CDA_FILIAL AND D1_DOC = CDA_NUMERO AND D1_SERIE = CDA_SERIE AND D1_FORNECE = CDA_CLIFOR AND D1_LOJA = CDA_LOJA AND D1_ITEM = CDA_NUMITE AND D1_COD <> 'FRETE ST       ' AND SD1.D_E_L_E_T_ = ' ' "
	cQuery1	+= "WHERE "
	cQuery1	+= "CDA_FILIAL = '01' AND "
	cQuery1	+= "CDA_TPMOVI = 'E' AND "
	cQuery1	+= "CDA_CODLAN IN ('AM53000001', 'AM55000003') AND "
	cQuery1	+= "D1_DTDIGIT BETWEEN '"+DTOS(mv_par01)+"' AND '"+DTOS(mv_par02)+"' AND "
	cQuery1	+= "CDA.D_E_L_E_T_ = ' ' "
	cQuery1	+= ")T2 ON (T1.R_E_C_N_O_ = T2.CDA_REC) "
	cQuery1	+= "WHEN MATCHED THEN "
	cQuery1	+= "UPDATE SET "
	cQuery1	+= "T1.CDA_BASE = CASE "
	cQuery1	+= "WHEN T1.CDA_CODLAN = 'AM53000001' AND D1_TES NOT IN ('398','408','410') THEN Round(T2.D1_BASEICM*"+cValToChar(mv_par03)+",2) "
	cQuery1	+= "WHEN T1.CDA_CODLAN = 'AM55000003' AND D1_TES NOT IN ('398','408','410') THEN Round(T2.D1_BASEICM*"+cValToChar(mv_par04)+",2) "
	cQuery1	+= "ELSE T2.D1_BASEICM END, "
	cQuery1	+= "T1.CDA_VALOR = ROUND((CASE "
	cQuery1	+= "WHEN T1.CDA_CODLAN = 'AM53000001' AND D1_TES NOT IN ('398','408','410') THEN Round(T2.D1_BASEICM*"+cValToChar(mv_par03)+",2) "
	cQuery1	+= "WHEN T1.CDA_CODLAN = 'AM55000003' AND D1_TES NOT IN ('398','408','410') THEN Round(T2.D1_BASEICM*"+cValToChar(mv_par04)+",2) "
	cQuery1	+= "ELSE T2.D1_BASEICM END)*CDA_ALIQ/100,2) "
	
	If TcSqlExec( cQuery1 )<0
		MsgStop("TCSQLError() " + TCSQLError())
	EndIf
	
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o	 ณAjusta    ณ Autor ณ Microsiga  	 		  ณ Data ณ 11/12/2006		ณฑฑ
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
	
	Aadd(aPergs,{"Data de?                     ","Data de?                     ","Data de?                     ","mv_ch1","D",08,0,0,"G",""                   ,"mv_par01","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","","","S","",""})
	Aadd(aPergs,{"Data ate ?                   ","Data ate ?                   ","Data ate ?                   ","mv_ch2","D",08,0,0,"G",""                   ,"mv_par02","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","","","S","",""})
	Aadd(aPergs,{"Fator Cod. AM53000001 ?      ","Fator Cod. AM53000001 ?      ","Fator Cod. AM53000001 ?      ","mv_ch3","N",06,4,0,"G",""                   ,"mv_par03","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","","","S","",""})
	Aadd(aPergs,{"Fator Cod. AM55000003 ?      ","Fator Cod. AM55000003 ?      ","Fator Cod. AM55000003 ?      ","mv_ch4","N",06,4,0,"G",""                   ,"mv_par04","              ","              ","              ","","","              ","              ","              ","","","","","","","","","","","","","","","","","","S","",""})
	
	//AjustaSx1("STFISF02",aPergs)
	
Return
