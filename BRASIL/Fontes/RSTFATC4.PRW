#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*====================================================================================\
|Programa  | RSTFATC4        | Autor | RENATO.OLIVEIRA           | Data | 29/10/2018  |
|=====================================================================================|
|Descrição | RELATORIO REEMBOLSO	  	                                              |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
|Chamado 008384 																	  |
\====================================================================================*/

User Function RSTFATC4()

	Local   oReport
	Private cPerg 			:= "RFATC4"
	Private cTime           := Time()
	Private cHora           := SUBSTR(cTime, 1, 2)
	Private cMinutos    	:= SUBSTR(cTime, 4, 2)
	Private cSegundos   	:= SUBSTR(cTime, 7, 2)
	Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos
	Private lXlsHeader      := .f.
	Private lXmlEndRow      := .f.
	Private cPergTit 		:= cAliasLif

	oReport:=ReportDef()
	oReport:PrintDialog()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ReportDef ºAutor  ³				     º Data ³  	          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  								                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ReportDef()

	Local oReport
	Local oSection

	oReport := TReport():New(cPergTit,"Relatório de reembolso",cPerg,{|oReport| ReportPrint(oReport)},"Este programa irá imprimir um relatório de reembolso")

	Pergunte(cPerg,.F.)

	oSection := TRSection():New(oReport,"Relatório de reembolso",{"Z1O"})

	TRCell():New(oSection,"01"	  			 ,,"NUMERO"			,,TamSx3("Z1O_COD")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection,"02"	  			 ,,"EMISSAO"		,,10,.F.,,,,,,,.T.)
	TRCell():New(oSection,"03"  			 ,,"SOLICITANTE"	,,TamSx3("Z1O_USER")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection,"10"  			 ,,"NOME SOLIC"		,,TamSx3("Z1O_NOME")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection,"11"  			 ,,"COD FORNE"		,,TamSx3("A2_COD")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection,"04"  			 ,,"BANCO"			,,TamSx3("Z1O_BANCO")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection,"05" 			 	 ,,"NOME BANCO"		,,15,.F.,,,,,,,.T.)
	TRCell():New(oSection,"06"  			 ,,"AGENCIA"		,,TamSx3("Z1O_AGENCI")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection,"07"  			 ,,"CONTA"			,,TamSx3("Z1O_CONTA")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection,"08"  			 ,,"OBS"			,,30,.F.,,,.T.,,,,.T.)
	TRCell():New(oSection,"09" 			 	 ,,"TOTAL" 			,,TamSx3("Z1O_TOTAL")[1],.F.,,,,,,,.T.)

	oSection:SetHeaderSection(.t.)
	oSection:Setnofilter("Z1O")

Return oReport

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ReportPrinºAutor  ³				     º Data ³  	          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  								                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ReportPrint(oReport)

	Local oSection1	:= oReport:Section(1)
	Local nX		:= 0
	Local cQuery 	:= ""
	Local cAlias 	:= "QRYTEMP0"
	Local aDados1[99]
	Local _cSta 	:= ''
	Local _aArea	:= {}

	oSection1:Cell("01")    			:SetBlock( { || aDados1[01] } )
	oSection1:Cell("02")  				:SetBlock( { || aDados1[02] } )
	oSection1:Cell("03")  				:SetBlock( { || aDados1[03] } )
	oSection1:Cell("04")  				:SetBlock( { || aDados1[04] } )
	oSection1:Cell("05")  				:SetBlock( { || aDados1[05] } )
	oSection1:Cell("06")  				:SetBlock( { || aDados1[06] } )
	oSection1:Cell("07")  				:SetBlock( { || aDados1[07] } )
	oSection1:Cell("08")  				:SetBlock( { || aDados1[08] } )
	oSection1:Cell("09")  				:SetBlock( { || aDados1[09] } )
	oSection1:Cell("10")  				:SetBlock( { || aDados1[10] } )
	oSection1:Cell("11")  				:SetBlock( { || aDados1[11] } )

	oReport:SetTitle("Relatório reembolso")// Titulo do relatório

	oReport:SetMeter(0)
	aFill(aDados1,nil)
	oSection1:Init()

	Processa({|| StQuery( ) },"Compondo Relatorio")

	DbSelectArea(cAliasLif)
	(cAliasLif)->(DbGoTop())

	DbSelectArea("Z1O")

	If  Select(cAliasLif) > 0

		While 	(cAliasLif)->(!Eof())

			Z1O->(DbGoTo((cAliasLif)->R_E_C_N_O_))

			aDados1[01]	:=	(cAliasLif)->Z1O_COD
			aDados1[02]	:= 	DTOC(STOD((cAliasLif)->Z1O_EMISSA))
			aDados1[03]	:= 	(cAliasLif)->Z1O_USER
			aDados1[04]	:=  (cAliasLif)->Z1O_BANCO
			aDados1[05]	:=	(cAliasLif)->Z1O_NBANCO
			aDados1[06]	:=	(cAliasLif)->Z1O_AGENCI
			aDados1[07]	:=	(cAliasLif)->Z1O_CONTA
			aDados1[08]	:=	Z1O->Z1O_OBS
			aDados1[09]	:=	(cAliasLif)->Z1O_TOTAL
			aDados1[10]	:=	(cAliasLif)->Z1O_NOME
			aDados1[11]	:=	(cAliasLif)->A2_COD

			oSection1:PrintLine()
			aFill(aDados1,nil)

			(cAliasLif)->(dbskip())
		EndDo

	EndIf

	oReport:SkipLine()

Return oReport

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³StQuery	ºAutor  ³				     º Data ³  	          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  								                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function StQuery()

	Local cQuery     := ' '
	Local cSituacao  := mv_par01
	Local nReg

	cQuery := " SELECT Z1O.*, 
	cQuery += " (
	cQuery += " SELECT NVL(MAX(A2_COD),' ') FROM "+RetSqlName("SRA")+" RA LEFT JOIN "+RetSqlName("SA2")+" A2
	cQuery += " ON A2_CGC=RA_CIC
	cQuery += " WHERE RA.D_E_L_E_T_=' ' AND A2.D_E_L_E_T_=' ' AND RA_XUSRCFG=Z1O_USER
	cQuery += " ) A2_COD
	cQuery += " FROM "+RetSqlName("Z1O")+" Z1O
	cQuery += " WHERE Z1O.D_E_L_E_T_=' ' AND Z1O_COD='"+Z1O->Z1O_COD+"'

	cQuery := ChangeQuery(cQuery)

	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

Return()