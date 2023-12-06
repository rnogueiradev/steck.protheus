#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "Rwmake.ch"
#INCLUDE "TopConn.ch"


/*/{Protheus.doc} RSTFAPDI
(Relatório de PDI)

@author jefferson.carlos
@since 09/09/2019
@version 1.0
@return ${return}, ${return_description}
*

/*/

User Function RSTFAPDI()

	Local   oReport
	Private cPerg 		:= "RFAPDI"
	Private cTime        := Time()
	Private cHora        := SUBSTR(cTime, 1, 2)
	Private cMinutos    	:= SUBSTR(cTime, 4, 2)
	Private cSegundos   	:= SUBSTR(cTime, 7, 2)
	Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos
	Private lXlsHeader   := .F.
	Private lXmlEndRow   := .F.
	Private cPergTit 		:= cAliasLif


	//xPutSx1(cPerg, "01", "Ano de?"	,"Ano de?" 	,"Ano de?" 	,"MV_CH1","C",4,0,0,"G","",'' 			,"","","MV_PAR01","","","","","","","","","","","","","","","","")
	//xPutSx1(cPerg, "02", "Ano ate?"	,"Ano ate?"	,"Ano ate?"	,"MV_CH2","C",4,0,0,"G","",'' 			,"","","MV_PAR02","","","","","","","","","","","","","","","","")


	oReport		:= ReportDef()
	oReport:PrintDialog()

Return



/*/{Protheus.doc} RSTFAPDI
(Relatório de PDI)

@author jefferson.carlos
@since 09/09/2019
@version 1.0

/*/


Static Function ReportDef()

	Local oReport
	Local oSection

	oReport := TReport():New(cPergTit,"Relatório de PDI",cPerg,{|oReport| ReportPrint(oReport)},"Este programa imprimirá as informações PDI")

	Pergunte(cPerg,.T.)

	oSection := TRSection():New(oReport,"Relatório de PDI",{"MOV"})



	TRCell():New(oSection,"01",,"FILIAL"					,,TamSx3("PH1_FILIAL")[1]	,.F.,,,,,,,.T.)
	TRCell():New(oSection,"02",,"ANO"						,,TamSx3("PH1_ANO")[1]		,.F.,,,,,,,.T.)
	TRCell():New(oSection,"03",,"NOME"						,,TamSx3("PH1_NOME")[1]		,.F.,,,,,,,.T.)
	TRCell():New(oSection,"04",,"SETOR"					    ,,TamSx3("PH1_SETOR")[1]	,.F.,,,,,,,.T.)
	TRCell():New(oSection,"05",,"RESUMO"					,,TamSx3("PH3_DESV")[1]		,.F.,,,,,,,.T.)
	TRCell():New(oSection,"06",,"CARGO_ALMEJADO"			,,TamSx3("PH3_PDI03")[1]	,.F.,,,,,,,.T.)
	TRCell():New(oSection,"07",,"DISPONIBILIDADE"			,,20                    	,.F.,,,,,,,.T.)
	TRCell():New(oSection,"08",,"PONTOS FORTES"				,,TamSx3("PH3_PDI05")[1]	,.F.,,,,,,,.T.)
	TRCell():New(oSection,"09",,"PONTOS A DESENV."			,,TamSx3("PH3_PDI06")[1]	,.F.,,,,,,,.T.)
	TRCell():New(oSection,"10",," META 01"				,,TamSx3("PH3_PDI07")[1]	,.F.,,,,,,,.T.)
	TRCell():New(oSection,"11",,"DESCRICAO DA META 01"			,,TamSx3("PH3_PDI08")[1]	,.F.,,,,,,,.T.)
	TRCell():New(oSection,"12",,"DT INIC. META 01"			,,TamSx3("PH3_PDI09")[1]	,.F.,,,,,,,.T.)
	TRCell():New(oSection,"13",,"DT FIM META 01" 			,,TamSx3("PH3_PDI10")[1]	,.F.,,,,,,,.T.)
	TRCell():New(oSection,"14",,"CATEGORIA META 01"	,,TamSx3("PH3_PDI11")[1]	,.F.,,,,,,,.T.)
	TRCell():New(oSection,"15",,"META 02"				,,TamSx3("PH3_PDI12")[1]	,.F.,,,,,,,.T.)
	TRCell():New(oSection,"16",,"DESCRICAO DA META 02"			,,TamSx3("PH3_PDI13")[1]	,.F.,,,,,,,.T.)
	TRCell():New(oSection,"17",,"DT INIC. META 02"			,,TamSx3("PH3_PDI14")[1]	,.F.,,,,,,,.T.)
	TRCell():New(oSection,"18",,"DT FIM META 02" 			,,TamSx3("PH3_PDI15")[1]	,.F.,,,,,,,.T.)
	TRCell():New(oSection,"19",,"CATEGORIA META 02"	,,TamSx3("PH3_PDI16")[1]	,.F.,,,,,,,.T.)
	TRCell():New(oSection,"20",,"META 03"				,,TamSx3("PH3_PDI17")[1]	,.F.,,,,,,,.T.)
	TRCell():New(oSection,"21",,"DESCRICAO DA META 03"			,,TamSx3("PH3_PDI18")[1]	,.F.,,,,,,,.T.)
	TRCell():New(oSection,"22",,"DT INIC. META 03"			,,TamSx3("PH3_PDI19")[1]	,.F.,,,,,,,.T.)
	TRCell():New(oSection,"23",,"DT FIM META 03" 			,,TamSx3("PH3_PDI20")[1]	,.F.,,,,,,,.T.)
	TRCell():New(oSection,"24",,"CATEGORIA META 03"	,,TamSx3("PH3_PDI21")[1]	,.F.,,,,,,,.T.)
	TRCell():New(oSection,"25",,"META 04"				,,TamSx3("PH3_PDI22")[1]	,.F.,,,,,,,.T.)
	TRCell():New(oSection,"26",,"DESCRICAO DA META 04"			,,TamSx3("PH3_PDI23")[1]	,.F.,,,,,,,.T.)
	TRCell():New(oSection,"27",,"DT INIC. META 04"			,,TamSx3("PH3_PDI24")[1]	,.F.,,,,,,,.T.)
	TRCell():New(oSection,"28",,"DT FIM META 04" 			,,TamSx3("PH3_PDI25")[1]	,.F.,,,,,,,.T.)
	TRCell():New(oSection,"29",,"CATEGORIA META 04"	,,TamSx3("PH3_PDI26")[1]	,.F.,,,,,,,.T.)
	TRCell():New(oSection,"30",,"META 05"				,,TamSx3("PH3_PDI27")[1]	,.F.,,,,,,,.T.)
	TRCell():New(oSection,"31",,"DESCRICAO DA META 05"			,,TamSx3("PH3_PDI28")[1]	,.F.,,,,,,,.T.)
	TRCell():New(oSection,"32",,"DT INIC. META 05"			,,TamSx3("PH3_PDI29")[1]	,.F.,,,,,,,.T.)
	TRCell():New(oSection,"33",,"DT FIM META 05" 			,,TamSx3("PH3_PDI30")[1]	,.F.,,,,,,,.T.)
	TRCell():New(oSection,"34",,"CATEGORIA META 05"	,,TamSx3("PH3_PDI31")[1]	,.F.,,,,,,,.T.)
	TRCell():New(oSection,"35",,"INFORMACOES ADICIONAIS"	,,TamSx3("PH3_PDI32")[1]	,.F.,,,,,,,.T.)




	oSection:SetHeaderSection(.t.)
	oSection:Setnofilter("MOV")

Return oReport


/*/{Protheus.doc} RSTFAPDI
(Relatório de PDI)

@author jefferson.carlos
@since 09/09/2019
@version 1.0

/*/



Static Function ReportPrint(oReport)

	Local oSection	:= oReport:Section(1)
	Local oSection1	:= oReport:Section(1)
	Local nX		:= 0
	Local aDados[2]
	Local aDados1[99]

	oSection1:Cell("01") :SetBlock( { || aDados1[01] } )
	oSection1:Cell("02") :SetBlock( { || aDados1[02] } )
	oSection1:Cell("03") :SetBlock( { || aDados1[03] } )
	oSection1:Cell("04") :SetBlock( { || aDados1[04] } )
	oSection1:Cell("05") :SetBlock( { || aDados1[05] } )
	oSection1:Cell("06") :SetBlock( { || aDados1[06] } )
	oSection1:Cell("07") :SetBlock( { || aDados1[07] } )
	oSection1:Cell("08") :SetBlock( { || aDados1[08] } )
	oSection1:Cell("09") :SetBlock( { || aDados1[09] } )
	oSection1:Cell("10") :SetBlock( { || aDados1[10] } )
	oSection1:Cell("11") :SetBlock( { || aDados1[11] } )
	oSection1:Cell("12") :SetBlock( { || aDados1[12] } )
	oSection1:Cell("13") :SetBlock( { || aDados1[13] } )
	oSection1:Cell("14") :SetBlock( { || aDados1[14] } )
	oSection1:Cell("15") :SetBlock( { || aDados1[15] } )
	oSection1:Cell("16") :SetBlock( { || aDados1[16] } )
	oSection1:Cell("17") :SetBlock( { || aDados1[17] } )
	oSection1:Cell("18") :SetBlock( { || aDados1[18] } )
	oSection1:Cell("19") :SetBlock( { || aDados1[19] } )
	oSection1:Cell("20") :SetBlock( { || aDados1[20] } )
	oSection1:Cell("21") :SetBlock( { || aDados1[21] } )
	oSection1:Cell("22") :SetBlock( { || aDados1[22] } )
	oSection1:Cell("23") :SetBlock( { || aDados1[23] } )
	oSection1:Cell("24") :SetBlock( { || aDados1[24] } )
	oSection1:Cell("25") :SetBlock( { || aDados1[25] } )
	oSection1:Cell("26") :SetBlock( { || aDados1[26] } )
	oSection1:Cell("27") :SetBlock( { || aDados1[27] } )
	oSection1:Cell("28") :SetBlock( { || aDados1[28] } )
	oSection1:Cell("29") :SetBlock( { || aDados1[29] } )
	oSection1:Cell("30") :SetBlock( { || aDados1[30] } )
	oSection1:Cell("31") :SetBlock( { || aDados1[31] } )
	oSection1:Cell("32") :SetBlock( { || aDados1[32] } )
	oSection1:Cell("33") :SetBlock( { || aDados1[33] } )
	oSection1:Cell("34") :SetBlock( { || aDados1[34] } )
	oSection1:Cell("35") :SetBlock( { || aDados1[35] } )



	oReport:SetTitle("MOV")// Titulo do relatório

	oReport:SetMeter(0)
	aFill(aDados,nil)
	aFill(aDados1,nil)
	oSection:Init()


	Processa({|| StQuery(  ) },"Compondo Informes")

	DbSelectArea(cAliasLif)
	(cAliasLif)->(DbGoTop())
	If  Select(cAliasLif) > 0

		While 	(cAliasLif)->(!Eof())


			aDados1[01]:= (cAliasLif)->FILIAL
			aDados1[02]:= (cAliasLif)->ANO
			aDados1[03]:= (cAliasLif)->NOME
			aDados1[04]:= (cAliasLif)->SETOR
			aDados1[05]:= (cAliasLif)->RESUMO
			aDados1[06]:= (cAliasLif)->CARGO_ALMEJADO
			aDados1[07]:= (cAliasLif)->DISP
			aDados1[08]:= (cAliasLif)->PTS_FORTES
			aDados1[09]:= (cAliasLif)->PTS_DESENVOLVER
			aDados1[10]:= (cAliasLif)->MET01
			aDados1[11]:= (cAliasLif)->DESCMET01
			aDados1[12]:= DTOC(STOD((cAliasLif)->DTIMET01))  
			aDados1[13]:= DTOC(STOD((cAliasLif)->DTFMET01)) 
			aDados1[14]:= (cAliasLif)->DISP01		
			aDados1[15]:= (cAliasLif)->MET02
			aDados1[16]:= (cAliasLif)->DESCMET02
			aDados1[17]:= DTOC(STOD((cAliasLif)->DTIMET02))
			aDados1[18]:= DTOC(STOD((cAliasLif)->DTFMET02))
			aDados1[19]:= (cAliasLif)->DISP02		
			aDados1[20]:= (cAliasLif)->MET03
			aDados1[21]:= (cAliasLif)->DESCMET03
			aDados1[22]:= DTOC(STOD((cAliasLif)->DTIMET03))
			aDados1[23]:= DTOC(STOD((cAliasLif)->DTFMET03))
			aDados1[24]:= (cAliasLif)->DISP03		
			aDados1[25]:= (cAliasLif)->MET04
			aDados1[26]:= (cAliasLif)->DESCMET04
			aDados1[27]:= DTOC(STOD((cAliasLif)->DTIMET04))
			aDados1[28]:= DTOC(STOD((cAliasLif)->DTFMET04))
			aDados1[29]:= (cAliasLif)->DISP04		
			aDados1[30]:= (cAliasLif)->MET05
			aDados1[31]:= (cAliasLif)->DESCMET05
			aDados1[32]:= DTOC(STOD((cAliasLif)->DTIMET05))
			aDados1[33]:= DTOC(STOD((cAliasLif)->DTFMET05))
			aDados1[34]:= (cAliasLif)->DISP05
			aDados1[35]:= (cAliasLif)->INFORMACOES_ADICIONAIS




			oSection1:PrintLine()
			aFill(aDados1,nil)
			(cAliasLif)->(dbskip())
		End

		oSection1:PrintLine()
		aFill(aDados1,nil)

		(cAliasLif)->(dbCloseArea())
	EndIf
	oReport:SkipLine()
Return oReport




/*/{Protheus.doc} ARRFAT06
(Gera Consulta no Banco de Dados)

@author jefferson.carlos
@since 24/10/2018
@version 1.0

/*/


Static Function StQuery(_ccod)




	Local cQuery1	:= ' '

	cQuery1+= "	SELECT	 "
	cQuery1+= "	PH1_FILIAL AS FILIAL,	 "
	cQuery1+= "	PH1_ANO AS ANO, PH1_USER AS CODUSER, PH1_NOME AS NOME, PH1_SETOR AS SETOR, 	 "
	cQuery1+= "	REPLACE(utl_raw.cast_to_varchar2(PH3.PH3_DESV),chr(10),' ') AS RESUMO,	 "
	cQuery1+= "	PH3_PDI03 AS CARGO_ALMEJADO, 	 
	cQuery1+= "	(CASE 
	cQuery1+= " WHEN PH3_PDI04 = '1' THEN 'CIDADE'
	cQuery1+= " WHEN PH3_PDI04 = '2' THEN 'ESTADO' 
	cQuery1+= " WHEN PH3_PDI04 = '3' THEN 'PAIS' 	
	cQuery1+= "	WHEN PH3_PDI04 = '4' THEN 'TODOS'
	cQuery1+= " WHEN PH3_PDI04 = '5' THEN 'NENHUM'
	cQuery1+= " WHEN PH3_PDI04 = ' ' THEN 'NAO INFORMADO' 
	cQuery1+= " END)AS DISP, 
	cQuery1+= "	PH3_PDI05 AS PTS_FORTES, PH3_PDI06 AS PTS_DESENVOLVER, 	 "
	cQuery1+= "	PH3_PDI07 AS MET01, 	 "
	cQuery1+= "	REPLACE(utl_raw.cast_to_varchar2(PH3.PH3_PDI08),chr(10),' ') AS DESCMET01,	 "
	cQuery1+= "	PH3_PDI09 AS DTIMET01, PH3_PDI10 AS DTFMET01,	 "
	cQuery1+= "	CASE WHEN PH3_PDI11 = '1' THEN 'FORMACAO' WHEN PH3_PDI11 = '2' THEN 'NETWORKING/EXPOSICAO' WHEN PH3_PDI11 = '3' THEN 'JOB ROTATION/APRENDIZAGEM' 	 "
	cQuery1+= "	WHEN PH3_PDI11 = '4' THEN 'COMPORTAMENTAL' WHEN PH3_PDI11 = '5' THEN 'OUTROS' ELSE 'NAO INFORMADO' END AS DISP01, 	 "
	cQuery1+= "	PH3_PDI12 AS MET02, 	 "
	cQuery1+= "	REPLACE(utl_raw.cast_to_varchar2(PH3.PH3_PDI13),chr(10),' ') AS DESCMET02,	 "
	cQuery1+= "	PH3_PDI14 AS DTIMET02, PH3_PDI15 AS DTFMET02,	 "
	cQuery1+= "	CASE WHEN PH3_PDI16 = '1' THEN 'FORMACAO' WHEN PH3_PDI16 = '2' THEN 'NETWORKING/EXPOSICAO' WHEN PH3_PDI16 = '3' THEN 'JOB ROTATION/APRENDIZAGEM' 	 "
	cQuery1+= "	WHEN PH3_PDI16 = '4' THEN 'COMPORTAMENTAL' WHEN PH3_PDI16 = '5' THEN 'OUTROS' ELSE 'NAO INFORMADO' END AS DISP02, 	 "
	cQuery1+= "	PH3_PDI17 AS MET03, 	 "
	cQuery1+= "	REPLACE(utl_raw.cast_to_varchar2(PH3.PH3_PDI18),chr(10),' ') AS DESCMET03,	 "
	cQuery1+= "	PH3_PDI19 AS DTIMET03, PH3_PDI20 AS DTFMET03,	 "
	cQuery1+= "	CASE WHEN PH3_PDI21 = '1' THEN 'FORMACAO' WHEN PH3_PDI21 = '2' THEN 'NETWORKING/EXPOSICAO' WHEN PH3_PDI21 = '3' THEN 'JOB ROTATION/APRENDIZAGEM' 	 "
	cQuery1+= "	WHEN PH3_PDI21 = '4' THEN 'COMPORTAMENTAL' WHEN PH3_PDI21 = '5' THEN 'OUTROS' ELSE 'NAO INFORMADO' END AS DISP03, 	 "
	cQuery1+= "	PH3_PDI22 AS MET04, 	 "
	cQuery1+= "	REPLACE(utl_raw.cast_to_varchar2(PH3.PH3_PDI23),chr(10),' ') AS DESCMET04,	 "
	cQuery1+= "	PH3_PDI24 AS DTIMET04, PH3_PDI25 AS DTFMET04,	 "
	cQuery1+= "	CASE WHEN PH3_PDI26 = '1' THEN 'FORMACAO' WHEN PH3_PDI26 = '2' THEN 'NETWORKING/EXPOSICAO' WHEN PH3_PDI26 = '3' THEN 'JOB ROTATION/APRENDIZAGEM' 	 "
	cQuery1+= "	WHEN PH3_PDI26 = '4' THEN 'COMPORTAMENTAL' WHEN PH3_PDI26 = '5' THEN 'OUTROS' ELSE 'NAO INFORMADO' END AS DISP04, 	 "
	cQuery1+= "	PH3_PDI27 AS MET05, 	 "
	cQuery1+= "	REPLACE(utl_raw.cast_to_varchar2(PH3.PH3_PDI28),chr(10),' ') AS DESCMET05,	 "
	cQuery1+= "	PH3_PDI29 AS DTIMET05, PH3_PDI30 AS DTFMET05,	 "
	cQuery1+= "	CASE WHEN PH3_PDI31 = '1' THEN 'FORMACAO' WHEN PH3_PDI31 = '2' THEN 'NETWORKING/EXPOSICAO' WHEN PH3_PDI31 = '3' THEN 'JOB ROTATION/APRENDIZAGEM' 	 "
	cQuery1+= "	WHEN PH3_PDI31 = '4' THEN 'COMPORTAMENTAL' WHEN PH3_PDI31 = '5' THEN 'OUTROS' ELSE 'NAO INFORMADO' END AS DISP05, 	 "
	cQuery1+= "	REPLACE(utl_raw.cast_to_varchar2(PH3.PH3_PDI32),chr(10),' ') AS INFORMACOES_ADICIONAIS	 "
	cQuery1+= "	FROM "+RetSqlName("PH1")+" PH1 "
	cQuery1+= "	INNER JOIN "+RetSqlName("PH3")+" PH3 "
	cQuery1+= " ON  PH1_ANO = PH3_ANO  "
	cQuery1+= "	AND PH1_USER = PH3_USERID AND PH3.D_E_L_E_T_ = ' ' 	 "
	cQuery1+= "	AND PH1.D_E_L_E_T_ = ' ' 	 "
	cQuery1+= " AND PH1_ANO BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' "


	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery1),cAliasLif)

Return()





