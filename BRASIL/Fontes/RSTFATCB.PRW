#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "Rwmake.ch"
#INCLUDE "TopConn.ch"

/*====================================================================================\
|Programa  | RSTFATCB        | Autor | RENATO.OLIVEIRA           | Data | 13/02/2019  |
|=====================================================================================|
|Descrição | Relatório eaa/metas                                                      |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function RSTFATCB()

	Local   oReport
	Private cPerg 		:= "RFATCB"
	Private cTime        := Time()
	Private cHora        := SUBSTR(cTime, 1, 2)
	Private cMinutos    	:= SUBSTR(cTime, 4, 2)
	Private cSegundos   	:= SUBSTR(cTime, 7, 2)
	Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos
	Private lXlsHeader   := .F.
	Private lXmlEndRow   := .F.
	Private cPergTit 		:= cAliasLif

	xPutSx1(cPerg, "01", "Ano de:" 		,"Ano de: ?" 		,"Ano de: ?" 		,"mv_ch1","C",4,0,0,"G","",'' 		,"","","mv_par01","","","","","","","","","","","","","","","","")
	xPutSx1(cPerg, "02", "Ano ate:" 	,"Ano ate: ?" 		,"Ano ate: ?" 		,"mv_ch2","C",4,0,0,"G","",'' 		,"","","mv_par02","","","","","","","","","","","","","","","","")
	xPutSx1(cPerg, "03", "Usuario de:"	,"Usuario de: ?" 	,"Usuario de: ?" 	,"mv_ch3","C",6,0,0,"G","",'' 		,"","","mv_par03","","","","","","","","","","","","","","","","")
	xPutSx1(cPerg, "04", "Usuario ate:"	,"Usuario ate: ?" 	,"Usuario ate: ?" 	,"mv_ch4","C",6,0,0,"G","",'' 		,"","","mv_par04","","","","","","","","","","","","","","","","")
	xPutSx1(cPerg, "05", "Superior:"	,"Superior: ?" 		,"Superior: ?" 		,"mv_ch5","C",6,0,0,"G","",'' 	,"","","mv_par05","","","","","","","","","","","","","","","","")

	oReport		:= ReportDef()
	oReport:PrintDialog()

Return

/*====================================================================================\
|Programa  | ReportDef       | Autor | RENATO.OLIVEIRA           | Data | 13/02/2019  |
|=====================================================================================|
|Descrição |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

Static Function ReportDef()

	Local oReport
	Local oSection
	Local oSection2

	oReport := TReport():New(cPergTit,"Relatório de acompanhamento do EAA/Metas",cPerg,{|oReport| ReportPrint(oReport)},"Este programa irá imprimir um relatório de acompanhamento do EAA/Metas")

	Pergunte(cPerg,.F.)

	oSection := TRSection():New(oReport,"EAA/Metas",{"PH3"})

	TRCell():New(oSection,"01"	  			 ,,"Usuário"		,,06,.F.,,,,,,,.T.)
	TRCell():New(oSection,"47"	  			 ,,"Nome participante" 	,,50,.F.,,,,,,,.T.)
	TRCell():New(oSection,"48"	  			 ,,"Setor" 				,,50,.F.,,,,,,,.T.)
	TRCell():New(oSection,"49"	  			 ,,"Cargo" 				,,50,.F.,,,,,,,.T.)
	TRCell():New(oSection,"60"	  			 ,,"Supervisor"			,,50,.F.,,,,,,,.T.)
	TRCell():New(oSection,"02"	  			 ,,"Ano"			,,TamSx3("PH3_ANO")[1],.F.,,,,,,,.T.)

	TRCell():New(oSection,"03"	  			 ,,"Meta 1"			,,TamSx3("PH3_M1")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection,"04"	  			 ,,"Target 1"		,,TamSx3("PH3_T1")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection,"05"	  			 ,,"Mínimo 1"		,,TamSx3("PH3_MI1")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection,"06"	  			 ,,"Máximo 1"		,,TamSx3("PH3_MA1")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection,"51"	  			 ,,"Perf Part 1"	,,30,.F.,,,,,,,.T.)
	TRCell():New(oSection,"08"	  			 ,,"Obs Part 1"		,,TamSx3("PH3_OBSP1")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection,"50"	  			 ,,"Perf Aval 1"	,,30,.F.,,,,,,,.T.)
	TRCell():New(oSection,"07"	  			 ,,"Obs Aval 1"		,,TamSx3("PH3_OBSA1")[1],.F.,,,,,,,.T.)

	TRCell():New(oSection,"09"	  			 ,,"Meta 2"			,,TamSx3("PH3_M2")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection,"10"	  			 ,,"Target 2"		,,TamSx3("PH3_T2")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection,"11"	  			 ,,"Mínimo 2"		,,TamSx3("PH3_MI2")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection,"12"	  			 ,,"Máximo 2"		,,TamSx3("PH3_MA2")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection,"53"	  			 ,,"Perf Part 2"	,,30,.F.,,,,,,,.T.)
	TRCell():New(oSection,"14"	  			 ,,"Obs Part 2"		,,TamSx3("PH3_OBSP2")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection,"52"	  			 ,,"Perf Aval 2"	,,30,.F.,,,,,,,.T.)
	TRCell():New(oSection,"13"	  			 ,,"Obs Aval 2"		,,TamSx3("PH3_OBSA2")[1],.F.,,,,,,,.T.)

	TRCell():New(oSection,"15"	  			 ,,"Meta 3"			,,TamSx3("PH3_M3")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection,"16"	  			 ,,"Target 3"		,,TamSx3("PH3_T3")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection,"17"	  			 ,,"Mínimo 3"		,,TamSx3("PH3_MI3")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection,"18"	  			 ,,"Máximo 3"		,,TamSx3("PH3_MA3")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection,"55"	  			 ,,"Perf Part 3"	,,30,.F.,,,,,,,.T.)
	TRCell():New(oSection,"20"	  			 ,,"Obs Part 3"		,,TamSx3("PH3_OBSP3")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection,"54"	  			 ,,"Perf Aval 3"	,,30,.F.,,,,,,,.T.)
	TRCell():New(oSection,"19"	  			 ,,"Obs Aval 3"		,,TamSx3("PH3_OBSA3")[1],.F.,,,,,,,.T.)

	TRCell():New(oSection,"21"	  			 ,,"Meta 4"			,,TamSx3("PH3_M4")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection,"22"	  			 ,,"Target 4"		,,TamSx3("PH3_T4")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection,"23"	  			 ,,"Mínimo 4"		,,TamSx3("PH3_MI4")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection,"24"	  			 ,,"Máximo 4"		,,TamSx3("PH3_MA4")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection,"57"	  			 ,,"Perf Part 4"	,,30,.F.,,,,,,,.T.)
	TRCell():New(oSection,"26"	  			 ,,"Obs Part 4"		,,TamSx3("PH3_OBSP4")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection,"56"	  			 ,,"Perf Aval 4"	,,30,.F.,,,,,,,.T.)
	TRCell():New(oSection,"25"	  			 ,,"Obs Aval 4"		,,TamSx3("PH3_OBSA4")[1],.F.,,,,,,,.T.)

	TRCell():New(oSection,"27"	  			 ,,"Meta 5"			,,TamSx3("PH3_M5")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection,"28"	  			 ,,"Target 5"		,,TamSx3("PH3_T5")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection,"29"	  			 ,,"Mínimo 5"		,,TamSx3("PH3_MI5")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection,"30"	  			 ,,"Máximo 5"		,,TamSx3("PH3_MA5")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection,"59"	  			 ,,"Perf Part 5"	,,30,.F.,,,,,,,.T.)
	TRCell():New(oSection,"32"	  			 ,,"Obs Part 5"		,,TamSx3("PH3_OBSP5")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection,"58"	  			 ,,"Perf Aval 5"	,,30,.F.,,,,,,,.T.)
	TRCell():New(oSection,"31"	  			 ,,"Obs Aval 5"		,,TamSx3("PH3_OBSA5")[1],.F.,,,,,,,.T.)

	TRCell():New(oSection,"33"	  			 ,,"Part - Cliente 1" 			,,30,.F.,,,,,,,.T.)
	TRCell():New(oSection,"34"	  			 ,,"Part - Disruptivo" 			,,30,.F.,,,,,,,.T.)
	TRCell():New(oSection,"35"	  			 ,,"Part - Ser diverso"			,,30,.F.,,,,,,,.T.)
	TRCell():New(oSection,"36"	  			 ,,"Part - Aprendizagem"		,,30,.F.,,,,,,,.T.)
	TRCell():New(oSection,"37"	  			 ,,"Part - Age igual o dono" 	,,30,.F.,,,,,,,.T.)

	TRCell():New(oSection,"38"	  			 ,,"Avaliador - Cliente 1" 			,,30,.F.,,,,,,,.T.)
	TRCell():New(oSection,"39"	  			 ,,"Avaliador - Disruptivo" 		,,30,.F.,,,,,,,.T.)
	TRCell():New(oSection,"40"	  			 ,,"Avaliador - Ser diverso"		,,30,.F.,,,,,,,.T.)
	TRCell():New(oSection,"41"	  			 ,,"Avaliador - Aprendizagem"		,,30,.F.,,,,,,,.T.)
	TRCell():New(oSection,"42"	  			 ,,"Avaliador - Age igual o dono" 	,,30,.F.,,,,,,,.T.)

	TRCell():New(oSection,"43"	  			 ,,"Part - Comentários" 		,,10,.F.,,,,,,,.T.)
	TRCell():New(oSection,"44"	  			 ,,"Part - Avaliação" 	,,30,.F.,,,,,,,.T.)

	TRCell():New(oSection,"45"	  			 ,,"Avaliador - Comentários" 		,,10,.F.,,,,,,,.T.)
	TRCell():New(oSection,"46"	  			 ,,"Avaliador - Avaliação" 	,,30,.F.,,,,,,,.T.)

	oSection:SetHeaderSection(.T.)
	oSection:Setnofilter("PH3")

Return oReport

/*====================================================================================\
|Programa  | ReportPrint     | Autor | RENATO.OLIVEIRA           | Data | 13/02/2019  |
|=====================================================================================|
|Descrição |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

Static Function ReportPrint(oReport)

	Local oSection1	:= oReport:Section(1)
	Local oSection2	:= oReport:Section(2)
	Local nX		:= 0
	Local cQuery 	:= ""
	Local cAlias 	:= "QRYTEMP0"
	Local aDados1[99]
	Local aDados2[99]
	Local _cSta 	:= ''
	Local _aArea	:= {}
	Local _cAlias1 := GetNextAlias()
	Local _aLocais := {}
	Local _nX := 0

	oSection1:Cell('01')      :SetBlock( { || aDados1[01] } )
	oSection1:Cell('02')      :SetBlock( { || aDados1[02] } )
	oSection1:Cell('03')      :SetBlock( { || aDados1[03] } )
	oSection1:Cell('04')      :SetBlock( { || aDados1[04] } )
	oSection1:Cell('05')      :SetBlock( { || aDados1[05] } )
	oSection1:Cell('06')      :SetBlock( { || aDados1[06] } )
	oSection1:Cell('07')      :SetBlock( { || aDados1[07] } )
	oSection1:Cell('08')      :SetBlock( { || aDados1[08] } )
	oSection1:Cell('09')      :SetBlock( { || aDados1[09] } )
	oSection1:Cell('10')      :SetBlock( { || aDados1[10] } )
	oSection1:Cell('11')      :SetBlock( { || aDados1[11] } )
	oSection1:Cell('12')      :SetBlock( { || aDados1[12] } )
	oSection1:Cell('13')      :SetBlock( { || aDados1[13] } )
	oSection1:Cell('14')      :SetBlock( { || aDados1[14] } )
	oSection1:Cell('15')      :SetBlock( { || aDados1[15] } )
	oSection1:Cell('16')      :SetBlock( { || aDados1[16] } )
	oSection1:Cell('17')      :SetBlock( { || aDados1[17] } )
	oSection1:Cell('18')      :SetBlock( { || aDados1[18] } )
	oSection1:Cell('19')      :SetBlock( { || aDados1[19] } )
	oSection1:Cell('20')      :SetBlock( { || aDados1[20] } )
	oSection1:Cell('21')      :SetBlock( { || aDados1[21] } )
	oSection1:Cell('22')      :SetBlock( { || aDados1[22] } )
	oSection1:Cell('23')      :SetBlock( { || aDados1[23] } )
	oSection1:Cell('24')      :SetBlock( { || aDados1[24] } )
	oSection1:Cell('25')      :SetBlock( { || aDados1[25] } )
	oSection1:Cell('26')      :SetBlock( { || aDados1[26] } )
	oSection1:Cell('27')      :SetBlock( { || aDados1[27] } )
	oSection1:Cell('28')      :SetBlock( { || aDados1[28] } )
	oSection1:Cell('29')      :SetBlock( { || aDados1[29] } )
	oSection1:Cell('30')      :SetBlock( { || aDados1[30] } )
	oSection1:Cell('31')      :SetBlock( { || aDados1[31] } )
	oSection1:Cell('32')      :SetBlock( { || aDados1[32] } )
	oSection1:Cell('33')      :SetBlock( { || aDados1[33] } )
	oSection1:Cell('34')      :SetBlock( { || aDados1[34] } )
	oSection1:Cell('35')      :SetBlock( { || aDados1[35] } )
	oSection1:Cell('36')      :SetBlock( { || aDados1[36] } )
	oSection1:Cell('37')      :SetBlock( { || aDados1[37] } )
	oSection1:Cell('38')      :SetBlock( { || aDados1[38] } )
	oSection1:Cell('39')      :SetBlock( { || aDados1[39] } )
	oSection1:Cell('40')      :SetBlock( { || aDados1[40] } )
	oSection1:Cell('41')      :SetBlock( { || aDados1[41] } )
	oSection1:Cell('42')      :SetBlock( { || aDados1[42] } )
	oSection1:Cell('43')      :SetBlock( { || aDados1[43] } )
	oSection1:Cell('44')      :SetBlock( { || aDados1[44] } )
	oSection1:Cell('45')      :SetBlock( { || aDados1[45] } )
	oSection1:Cell('46')      :SetBlock( { || aDados1[46] } )
	oSection1:Cell('47')      :SetBlock( { || aDados1[47] } )
	oSection1:Cell('48')      :SetBlock( { || aDados1[48] } )
	oSection1:Cell('49')      :SetBlock( { || aDados1[49] } )
	oSection1:Cell('50')      :SetBlock( { || aDados1[50] } )
	oSection1:Cell('51')      :SetBlock( { || aDados1[51] } )
	oSection1:Cell('52')      :SetBlock( { || aDados1[52] } )
	oSection1:Cell('53')      :SetBlock( { || aDados1[53] } )
	oSection1:Cell('54')      :SetBlock( { || aDados1[54] } )
	oSection1:Cell('55')      :SetBlock( { || aDados1[55] } )
	oSection1:Cell('56')      :SetBlock( { || aDados1[56] } )
	oSection1:Cell('57')      :SetBlock( { || aDados1[57] } )
	oSection1:Cell('58')      :SetBlock( { || aDados1[58] } )
	oSection1:Cell('59')      :SetBlock( { || aDados1[59] } )
	oSection1:Cell('60')      :SetBlock( { || aDados1[60] } )

	oReport:SetTitle("Relatório do EAA/Metas")// Titulo do relatório

	oReport:SetMeter(0)
	aFill(aDados1,nil)
	oSection1:Init()

	Processa({|| StQuery( ) },"Compondo Relatorio")

	DbSelectArea(cAliasLif)
	(cAliasLif)->(DbGoTop())

	DbSelectArea("PH3")

	If  Select(cAliasLif) > 0

		While 	(cAliasLif)->(!Eof())

			PH3->(DbGoTo((cAliasLif)->RECPH3))

			aDados1[01]	:= (cAliasLif)->PH3_USERID
			aDados1[02]	:= (cAliasLif)->PH3_ANO
			aDados1[03]	:= PH3->PH3_M1
			aDados1[04] := PH3->PH3_T1
			aDados1[05] := PH3->PH3_MI1
			aDados1[06] := PH3->PH3_MA1
			aDados1[07] := PH3->PH3_OBSA1
			aDados1[08] := PH3->PH3_OBSP1
			aDados1[09] := PH3->PH3_M2
			aDados1[10] := PH3->PH3_T2
			aDados1[11] := PH3->PH3_MI2
			aDados1[12] := PH3->PH3_MA2
			aDados1[13] := PH3->PH3_OBSA1
			aDados1[14] := PH3->PH3_OBSA2
			aDados1[15] := PH3->PH3_M3
			aDados1[16] := PH3->PH3_T3
			aDados1[17] := PH3->PH3_MI3
			aDados1[18] := PH3->PH3_MA3
			aDados1[19] := PH3->PH3_OBSA3
			aDados1[20] := PH3->PH3_OBSP3
			aDados1[21] := PH3->PH3_M4
			aDados1[22] := PH3->PH3_T4
			aDados1[23] := PH3->PH3_MI4
			aDados1[24] := PH3->PH3_MA4
			aDados1[25] := PH3->PH3_OBSA4
			aDados1[26] := PH3->PH3_OBSP4
			aDados1[27] := PH3->PH3_M5
			aDados1[28] := PH3->PH3_T5
			aDados1[29] := PH3->PH3_MI5
			aDados1[30] := PH3->PH3_MA5
			aDados1[31] := PH3->PH3_OBSA5
			aDados1[32] := PH3->PH3_OBSP5
			aDados1[33] := GETSTATUS1(PH3->PH3_AC7)
			aDados1[34] := GETSTATUS1(PH3->PH3_AC8)
			aDados1[35] := GETSTATUS1(PH3->PH3_AC9)
			aDados1[36] := GETSTATUS1(PH3->PH3_AC10)
			aDados1[37] := GETSTATUS1(PH3->PH3_AC11)
			aDados1[38] := GETSTATUS1(PH3->PH3_PC7)
			aDados1[39] := GETSTATUS1(PH3->PH3_PC8)
			aDados1[40] := GETSTATUS1(PH3->PH3_PC9)
			aDados1[41] := GETSTATUS1(PH3->PH3_PC10)
			aDados1[42] := GETSTATUS1(PH3->PH3_PC11)
			aDados1[43] := PH3->PH3_COME02
			aDados1[44] := GETSTATUS2(PH3->PH3_AVPA)
			aDados1[45] := PH3->PH3_COME01
			aDados1[46] := GETSTATUS2(PH3->PH3_AVAV)
			aDados1[47] := (cAliasLif)->PH1_NOME
			aDados1[48] := (cAliasLif)->PH1_SETOR
			aDados1[49] := (cAliasLif)->PH1_CARGO

			aDados1[50] := GETSTATUS2(PH3->PH3_B1)
			aDados1[51] := GETSTATUS2(PH3->PH3_A1)
			aDados1[52] := GETSTATUS2(PH3->PH3_B2)
			aDados1[53] := GETSTATUS2(PH3->PH3_A2)
			aDados1[54] := GETSTATUS2(PH3->PH3_B3)
			aDados1[55] := GETSTATUS2(PH3->PH3_A3)
			aDados1[56] := GETSTATUS2(PH3->PH3_B4)
			aDados1[57] := GETSTATUS2(PH3->PH3_A4)
			aDados1[58] := GETSTATUS2(PH3->PH3_B5)
			aDados1[59] := GETSTATUS2(PH3->PH3_A5)

			aDados1[60] := UsrRetName((cAliasLif)->PH1_SUP)

			oSection1:PrintLine()
			aFill(aDados1,nil)

			(cAliasLif)->(dbskip())
		EndDo

	EndIf

	oSection1:Finish()

Return oReport

/*====================================================================================\
|Programa  | StQuery	     | Autor | RENATO.OLIVEIRA           | Data | 13/02/2019  |
|=====================================================================================|
|Descrição |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

Static Function StQuery()

	Local cQuery     := ' '
	Local nReg

	cQuery := " SELECT PH3.*, PH3.R_E_C_N_O_ RECPH3, PH1.*
	cQuery += " FROM "+RetSqlName("PH3")+" PH3
	cQuery += " LEFT JOIN "+RetSqlName("PH1")+" PH1
	cQuery += " ON PH1_ANO=PH3_ANO AND PH1_USER=PH3_USERID
	cQuery += " WHERE PH3.D_E_L_E_T_=' ' AND PH1.D_E_L_E_T_=' '
	cQuery += " AND PH3_ANO BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'
	cQuery += " AND PH3_USERID BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"'

	If !Empty(mv_par05)
		cQuery += " AND PH1_SUP='"+mv_par05+"'
	EndIf

	cQuery += " ORDER BY PH3_USERID, PH3_ANO

	cQuery := ChangeQuery(cQuery)

	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

Return()

/*====================================================================================\
|Programa  | xPutSx1	     | Autor | RENATO.OLIVEIRA           | Data | 13/02/2019  |
|=====================================================================================|
|Descrição |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

Static Function xPutSx1(cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng,cVar,;
	cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,;
	cF3, cGrpSxg,cPyme,;
	cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01,;
	cDef02,cDefSpa2,cDefEng2,;
	cDef03,cDefSpa3,cDefEng3,;
	cDef04,cDefSpa4,cDefEng4,;
	cDef05,cDefSpa5,cDefEng5,;
	aHelpPor,aHelpEng,aHelpSpa,cHelp)

	LOCAL aArea := GetArea()
	Local cKey
	Local lPort := .f.
	Local lSpa := .f.
	Local lIngl := .f.

	cKey := "P." + AllTrim( cGrupo ) + AllTrim( cOrdem ) + "."

	cPyme    := Iif( cPyme           == Nil, " ", cPyme          )
	cF3      := Iif( cF3           == NIl, " ", cF3          )
	cGrpSxg := Iif( cGrpSxg     == Nil, " ", cGrpSxg     )
	cCnt01   := Iif( cCnt01          == Nil, "" , cCnt01      )
	cHelp      := Iif( cHelp          == Nil, "" , cHelp          )

	dbSelectArea( "SX1" )
	dbSetOrder( 1 )

	// Ajusta o tamanho do grupo. Ajuste emergencial para validação dos fontes.
	// RFC - 15/03/2007
	cGrupo := PadR( cGrupo , Len( SX1->X1_GRUPO ) , " " )

	If !( DbSeek( cGrupo + cOrdem ))

		cPergunt:= If(! "?" $ cPergunt .And. ! Empty(cPergunt),Alltrim(cPergunt)+" ?",cPergunt)
		cPerSpa     := If(! "?" $ cPerSpa .And. ! Empty(cPerSpa) ,Alltrim(cPerSpa) +" ?",cPerSpa)
		cPerEng     := If(! "?" $ cPerEng .And. ! Empty(cPerEng) ,Alltrim(cPerEng) +" ?",cPerEng)
/* Removido - 12/05/2023 - Não executa mais Recklock na X1 - Criar/alterar perguntas no configurador
		Reclock( "SX1" , .T. )

		Replace X1_GRUPO   With cGrupo
		Replace X1_ORDEM   With cOrdem
		Replace X1_PERGUNT With cPergunt
		Replace X1_PERSPA With cPerSpa
		Replace X1_PERENG With cPerEng
		Replace X1_VARIAVL With cVar
		Replace X1_TIPO    With cTipo
		Replace X1_TAMANHO With nTamanho
		Replace X1_DECIMAL With nDecimal
		Replace X1_PRESEL With nPresel
		Replace X1_GSC     With cGSC
		Replace X1_VALID   With cValid

		Replace X1_VAR01   With cVar01

		Replace X1_F3      With cF3
		Replace X1_GRPSXG With cGrpSxg

		If Fieldpos("X1_PYME") > 0
			If cPyme != Nil
				Replace X1_PYME With cPyme
			Endif
		Endif

		Replace X1_CNT01   With cCnt01
		If cGSC == "C"               // Mult Escolha
			Replace X1_DEF01   With cDef01
			Replace X1_DEFSPA1 With cDefSpa1
			Replace X1_DEFENG1 With cDefEng1

			Replace X1_DEF02   With cDef02
			Replace X1_DEFSPA2 With cDefSpa2
			Replace X1_DEFENG2 With cDefEng2

			Replace X1_DEF03   With cDef03
			Replace X1_DEFSPA3 With cDefSpa3
			Replace X1_DEFENG3 With cDefEng3

			Replace X1_DEF04   With cDef04
			Replace X1_DEFSPA4 With cDefSpa4
			Replace X1_DEFENG4 With cDefEng4

			Replace X1_DEF05   With cDef05
			Replace X1_DEFSPA5 With cDefSpa5
			Replace X1_DEFENG5 With cDefEng5
		Endif

		Replace X1_HELP With cHelp

		PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

		MsUnlock()
	Else

		lPort := ! "?" $ X1_PERGUNT .And. ! Empty(SX1->X1_PERGUNT)
		lSpa := ! "?" $ X1_PERSPA .And. ! Empty(SX1->X1_PERSPA)
		lIngl := ! "?" $ X1_PERENG .And. ! Empty(SX1->X1_PERENG)

		If lPort .Or. lSpa .Or. lIngl
			RecLock("SX1",.F.)
			If lPort
				SX1->X1_PERGUNT:= Alltrim(SX1->X1_PERGUNT)+" ?"
			EndIf
			If lSpa
				SX1->X1_PERSPA := Alltrim(SX1->X1_PERSPA) +" ?"
			EndIf
			If lIngl
				SX1->X1_PERENG := Alltrim(SX1->X1_PERENG) +" ?"
			EndIf
			SX1->(MsUnLock())
		EndIf*/
	Endif

	RestArea( aArea )

Return

/*====================================================================================\
|Programa  | GETSTATUS1	     | Autor | RENATO.OLIVEIRA           | Data | 13/02/2019  |
|=====================================================================================|
|Descrição |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

Static Function GETSTATUS1(_cOpcao)

	Local _cDesc := ""

	_cOpcao := Alltrim(_cOpcao)

	If _cOpcao=="1"
		_cDesc := "Fortaleza"
	Else
		_cDesc := "Área de desenvolvimento"
	EndIf

Return(_cDesc)

/*====================================================================================\
|Programa  | GETSTATUS2	     | Autor | RENATO.OLIVEIRA           | Data | 13/02/2019  |
|=====================================================================================|
|Descrição |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

Static Function GETSTATUS2(_cOpcao)

	Local _cDesc := ""

	_cOpcao := AllTrim(_cOpcao)

	Do Case
		Case _cOpcao=="1"
		_cDesc := "Alta perfomance"
		Case _cOpcao=="2"
		_cDesc := "Perfomance"
		Case _cOpcao=="3"
		_cDesc := "Competente"
		Case _cOpcao=="4"
		_cDesc := "Baixa perfomance"
	EndCase

Return(_cDesc)
