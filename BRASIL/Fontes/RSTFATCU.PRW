#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "Rwmake.ch"
#INCLUDE "TopConn.ch"

/*====================================================================================\
|Programa  | RSTFATCU        | Autor | RENATO.OLIVEIRA           | Data | 16/07/2020  |
|=====================================================================================|
|Descrição | Relatório de romaneio			                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function RSTFATCU()

	Local   oReport
	Private cPerg 			:= "RFATCU"
	Private cTime        	:= Time()
	Private cHora        	:= SUBSTR(cTime, 1, 2)
	Private cMinutos    	:= SUBSTR(cTime, 4, 2)
	Private cSegundos   	:= SUBSTR(cTime, 7, 2)
	Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos
	Private cPergTit 		:= cAliasLif

	U_STPutSx1( cPerg, "01","Dt emis de:" 		   			,"MV_PAR01","mv_ch1","D",08,0,"G",,""  		,"@!")
	U_STPutSx1( cPerg, "02","Dt emis ate:"					,"MV_PAR02","mv_ch2","D",08,0,"G",,""  		,"@!")
	U_STPutSx1( cPerg, "03","Dt ent de:" 		   			,"MV_PAR03","mv_ch3","D",08,0,"G",,""  		,"@!")
	U_STPutSx1( cPerg, "04","Dt ent ate:"					,"MV_PAR04","mv_ch4","D",08,0,"G",,""  		,"@!")

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
	Local oSection1
	Local oSection2

	oReport := TReport():New(cPergTit,"Relatório de romaneios",cPerg,{|oReport| ReportPrint(oReport)},"Este programa irá imprimir um relatório de romaneios")

	Pergunte(cPerg,.F.)

	oSection1 := TRSection():New(oReport,"Z51",{"Z51"})

	TRCell():New(oSection1,"01"	  			 ,,"Data de emissão"						,,TamSx3("PD1_DTEMIS")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection1,"02"	  			 ,,"Romaneio"								,,TamSx3("PD1_CODROM")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection1,"03"	  			 ,,"Motorista"								,,TamSx3("PD1_MOTORI")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection1,"04"	  			 ,,"Ajudante 1"								,,TamSx3("PD1_AJUDA1")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection1,"05"	  			 ,,"Ajudante 2"								,,TamSx3("PD1_AJUDA2")[1],.F.,,,,,,,.T.)
	
	TRCell():New(oSection1,"18"	  			 ,,"Placa"									,,TamSx3("PD1_PLACA")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection1,"19"	  			 ,,"Dt Entrega"								,,TamSx3("PD1_DTENT")[1],.F.,,,,,,,.T.)
	
	TRCell():New(oSection1,"06"	  			 ,,"KM Saida"								,,TamSx3("PD1_KMSAID")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection1,"07"	  			 ,,"KM Chegada"								,,TamSx3("PD1_KMCHEG")[1],.F.,,,,,,,.T.)
	
	TRCell():New(oSection1,"20"	  			 ,,"KM Rodado"								,,TamSx3("PD1_KMCHEG")[1],.F.,,,,,,,.T.)
	
	TRCell():New(oSection1,"08"	  			 ,,"Hora Saida"								,,TamSx3("PD1_HRSAID")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection1,"09"	  			 ,,"Hora Chegada"							,,TamSx3("PD1_HRCHEG")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection1,"10"	  			 ,,"Total Notas"							,,3,.F.,,,,,,,.T.)
	TRCell():New(oSection1,"11"	  			 ,,"Entregue"								,,3,.F.,,,,,,,.T.)
	TRCell():New(oSection1,"12"	  			 ,,"Retorno"								,,3,.F.,,,,,,,.T.)
	
	TRCell():New(oSection1,"21"	  			 ,,"1. Tempo insuficiente"					,,3,.F.,,,,,,,.T.)
	TRCell():New(oSection1,"22"	  			 ,,"2. Transp. mudou de end."				,,3,.F.,,,,,,,.T.)
	TRCell():New(oSection1,"23"	  			 ,,"3. Cliente com end incorreto"			,,3,.F.,,,,,,,.T.)
	TRCell():New(oSection1,"24"	  			 ,,"4. Recusa do cliente"					,,3,.F.,,,,,,,.T.)
	TRCell():New(oSection1,"25"	  			 ,,"5. Demora no recebimento"				,,3,.F.,,,,,,,.T.)
	TRCell():New(oSection1,"26"	  			 ,,"6. Outros"								,,3,.F.,,,,,,,.T.)
	
	TRCell():New(oSection1,"13"	  			 ,,"Rota principal"							,,TamSx3("PD1_XROTA")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection1,"14"	  			 ,,"Peso"									,,TamSx3("F2_PBRUTO")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection1,"15"	  			 ,,"Volumes"								,,TamSx3("F2_VOLUME1")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection1,"16"	  			 ,,"Valor total"							,,TamSx3("F2_VALBRUT")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection1,"17"	  			 ,,"Cubagem"								,,TamSx3("F2_VOLUME1")[1],.F.,,,,,,,.T.)

	oSection1:SetHeaderSection(.T.)
	oSection1:Setnofilter("PD1")

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
	Local aDados1[99]
	Local aDados2[99]
	Local _cQuery1  := ""
	Local _cAlias1  := GetNextAlias()

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

	oReport:SetTitle("Relatório de romaneio")// Titulo do relatório

	oReport:SetMeter(0)
	aFill(aDados1,nil)
	aFill(aDados2,nil)
	oSection1:Init()
	oSection2:Init()

	Processa({|| StQuery( ) },"Compondo Relatorio")

	DbSelectArea(cAliasLif)
	(cAliasLif)->(DbGoTop())

	If  Select(cAliasLif) > 0

		While 	(cAliasLif)->(!Eof())

			aDados1[01]	:= STOD((cAliasLif)->PD1_DTEMIS)
			aDados1[02]	:= (cAliasLif)->PD1_CODROM
			aDados1[03]	:= (cAliasLif)->PD1_MOTORI
			aDados1[04]	:= (cAliasLif)->PD1_AJUDA1
			aDados1[05]	:= (cAliasLif)->PD1_AJUDA2
			aDados1[06]	:= (cAliasLif)->PD1_KMSAID
			aDados1[07]	:= (cAliasLif)->PD1_KMCHEG
			aDados1[08]	:= SubStr((cAliasLif)->PD1_HRSAID,1,2)+":"+SubStr((cAliasLif)->PD1_HRSAID,3,2)
			aDados1[09]	:= SubStr((cAliasLif)->PD1_HRCHEG,1,2)+":"+SubStr((cAliasLif)->PD1_HRCHEG,3,2)
			aDados1[10]	:= (cAliasLif)->TOTNFS
			aDados1[11]	:= (cAliasLif)->TOTENT
			aDados1[12]	:= (cAliasLif)->TOTRET
			aDados1[13]	:= (cAliasLif)->PD1_XROTA							
			aDados1[14]	:= (cAliasLif)->PESO
			aDados1[15]	:= (cAliasLif)->VOLUME
			aDados1[16]	:= (cAliasLif)->VALOR
			aDados1[17]	:= (cAliasLif)->F2_XCUBAGE
			aDados1[18]	:= (cAliasLif)->PD1_PLACA
			aDados1[19]	:= STOD((cAliasLif)->PD1_DTENT)
			aDados1[20]	:= Val((cAliasLif)->PD1_KMCHEG)-Val((cAliasLif)->PD1_KMSAID)
			aDados1[21]	:= (cAliasLif)->MOT1
			aDados1[22]	:= (cAliasLif)->MOT2
			aDados1[23]	:= (cAliasLif)->MOT3
			aDados1[24]	:= (cAliasLif)->MOT4
			aDados1[25]	:= (cAliasLif)->MOT5
			aDados1[26]	:= (cAliasLif)->MOT6

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

	cQuery := " SELECT PD1_DTEMIS, PD1_CODROM, PD1_MOTORI, PD1_AJUDA1, PD1_AJUDA2, PD1_KMSAID, PD1_KMCHEG, PD1_HRSAID, PD1_HRCHEG, PD1_XROTA, PD1_PLACA, PD1_DTENT, 
	cQuery += " COUNT(PD2_NFS) TOTNFS,
	cQuery += " SUM(CASE WHEN PD2_STATUS='4' THEN 1 ELSE 0 END) TOTENT,
	cQuery += " SUM(CASE WHEN PD2_STATUS='5' THEN 1 ELSE 0 END) TOTRET,
	cQuery += " SUM(F2_PBRUTO) PESO,
	cQuery += " SUM(F2_VOLUME1) VOLUME,
	cQuery += " SUM(F2_VALBRUT) VALOR, SUM(F2_XCUBAGE) F2_XCUBAGE, 
	cQuery += " SUM(CASE WHEN SUBSTR(PD2_MOTIVO,1,1)='1' THEN 1 ELSE 0 END) MOT1,
	cQuery += " SUM(CASE WHEN SUBSTR(PD2_MOTIVO,1,1)='2' THEN 1 ELSE 0 END) MOT2,
	cQuery += " SUM(CASE WHEN SUBSTR(PD2_MOTIVO,1,1)='3' THEN 1 ELSE 0 END) MOT3,
	cQuery += " SUM(CASE WHEN SUBSTR(PD2_MOTIVO,1,1)='4' THEN 1 ELSE 0 END) MOT4,
	cQuery += " SUM(CASE WHEN SUBSTR(PD2_MOTIVO,1,1)='5' THEN 1 ELSE 0 END) MOT5,
	cQuery += " SUM(CASE WHEN SUBSTR(PD2_MOTIVO,1,1)='6' THEN 1 ELSE 0 END) MOT6
	cQuery += " FROM "+RetSqlName("PD1")+" PD1
	cQuery += " LEFT JOIN "+RetSqlName("PD2")+" PD2
	cQuery += " ON PD2_FILIAL=PD1_FILIAL AND PD2_CODROM=PD1_CODROM
	cQuery += " LEFT JOIN "+RetSqlName("SF2")+" F2
	cQuery += " ON F2_FILIAL=PD2_FILIAL AND F2_DOC=PD2_NFS AND F2_SERIE=PD2_SERIES AND F2_CLIENTE=PD2_CLIENT AND F2_LOJA=PD2_LOJCLI
	cQuery += " WHERE PD1.D_E_L_E_T_=' ' AND PD2.D_E_L_E_T_=' ' AND F2.D_E_L_E_T_=' ' 
	cQuery += " AND PD1_DTEMIS BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"'
	cQuery += " AND PD1_DTENT BETWEEN '"+DTOS(MV_PAR03)+"' AND '"+DTOS(MV_PAR04)+"'
	cQuery += " GROUP BY PD1_DTEMIS, PD1_CODROM, PD1_MOTORI, PD1_AJUDA1, PD1_AJUDA2, PD1_KMSAID, PD1_KMCHEG, PD1_HRSAID, PD1_HRCHEG, PD1_XROTA, PD1_PLACA, PD1_DTENT

	cQuery := ChangeQuery(cQuery)

	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

Return()