#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  RSTFATAZ   ºAutor  ³Robson Mazzarotto º Data ³  06/04/17     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Relatorio de tarefas em Execução de Acao Corretiva x Acoesº±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*-----------------------------*
User Function RSTFATAZ()
*-----------------------------*
	Local   oReport
	Private cPerg 			:= "RFATAZ"
	Private cTime           := Time()
	Private cHora           := SUBSTR(cTime, 1, 2)
	Private cMinutos    	:= SUBSTR(cTime, 4, 2)
	Private cSegundos   	:= SUBSTR(cTime, 7, 2)
	Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos
	Private lXlsHeader      := .f.
	Private lXmlEndRow      := .f.
	Private cPergTit 		:= cAliasLif


	PutSx1(cPerg, "01", "Codigo de:" 	,"Codigo de:" 	 ,"Codigo de:" 		,"mv_ch1","C",15,0,0,"G","","QI5" ,"","","mv_par01","","","","","","","","","","","","","","","","")
	PutSx1(cPerg, "02", "Codigo ate:" 	,"Codigo ate:" 	 ,"Codigo ate:" 		,"mv_ch2","C",15,0,0,"G","","QI5" ,"","","mv_par02","","","","","","","","","","","","","","","","")
	PutSx1(cPerg, "03", "Tipo Ação de:"	,"Tipo Ação de:"	    ,"Tipo Ação de:"	,"mv_ch3","C",02,0,0,"G","","QIK","","" ,"mv_par03","","","","","","","","","","","","","","","","")
	PutSx1(cPerg, "04", "Tipo Ação ate:"	,"Tipo Ação ate:"	    ,"Tipo Ação ate:"	,"mv_ch4","C",02,0,0,"G","","QIK","","" ,"mv_par04","","","","","","","","","","","","","","","","")
	PutSx1(cPerg, "05", "Mat Usr Resp de:","Mat Usr Resp de:"	,"Mat Usr Resp de:"		,"mv_ch5","C",10,0,0,"G","","QDE","","" ,"mv_par05","","","","","","","","","","","","","","","","")
	PutSx1(cPerg, "06", "Mat Usr Resp ate:","Mat Usr Resp ate:"	,"Mat Usr Resp ate:"		,"mv_ch6","C",10,0,0,"G","","QDE","","" ,"mv_par06","","","","","","","","","","","","","","","","")
	PutSx1(cPerg, "07", "Prazo de:"    ,"Prazo de:"   	,"Prazo de:"		    ,"mv_ch7","D",08,0,0,"G","","","","" ,"mv_par07","","","","","","","","","","","","","","","","")
	PutSx1(cPerg, "08", "Prazo ate:"    ,"Prazo ate:"   	,"Prazo ate:"		    ,"mv_ch8","D",08,0,0,"G","","","","" ,"mv_par08","","","","","","","","","","","","","","","","")
	PutSx1(cPerg, "09", "Status de:"    ,"Status de:"   	,"Status de:"		    ,"mv_ch9","C",01,0,0,"G","","","","" ,"mv_par09","","","","","","","","","","","","","","","","")
	PutSx1(cPerg, "10", "Status ate:"   ,"Status ate:"  	,"Status ate:"	    ,"mv_ch10","C",01,0,0,"G","","","","" ,"mv_par10","","","","","","","","","","","","","","","","")
	
		
	oReport		:= ReportDef()
	oReport:PrintDialog()

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ReportDef    ºAutor  ³Robson Mazzarottoº Data ³  06/04/17    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Relatorio de tarefas em Execução de Acao Corretiva x Acoesº±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*-----------------------------*
Static Function ReportDef()
*-----------------------------*
	Local oReport
	Local oSection

	oReport := TReport():New(cPergTit,"Relatório Acao Corretiva x Acoes",cPerg,{|oReport| ReportPrint(oReport)},"Este programa irá imprimir um relatório das tarefas em Execução dos projetos")

	Pergunte(cPerg,.F.)

	oSection := TRSection():New(oReport,"Acao Corretiva x Acoes",{"QI5"})


TRCell():New(oSection,"01",,"FILIAL"		,,10,.F.,)
TRCell():New(oSection,"02",,"CODIGO"		,,30,.F.,)
TRCell():New(oSection,"03",,"REVISAO" 		,,30,.F.,)
TRCell():New(oSection,"04",,"SEQUENCIA"   ,,30,.F.,)
TRCell():New(oSection,"05",,"TIPOACAO"	    ,,30,.F.,)
TRCell():New(oSection,"06",,"FILMAT"		,,10,.F.,)
TRCell():New(oSection,"07",,"MATRICUA"		,,30,.F.,)
TRCell():New(oSection,"08",,"PRAZO"		,,30,.F.,)
TRCell():New(oSection,"09",,"REALIZADO"	,,30,.F.,)
TRCell():New(oSection,"10",,"STATUS"		,,10,.F.,)
TRCell():New(oSection,"11",,"DESCRE"		,,90,.F.,)
TRCell():New(oSection,"12",,"DESCCO"		,,30,.F.,)

	oSection:SetHeaderSection(.t.)
	oSection:Setnofilter("QI5")

Return oReport
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ReportPrint  ºAutor  ³Robson Mazzarottoº Data ³  06/04/17    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Relatorio de tarefas em Execução de Acao Corretiva x Acoesº±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*------------------------------------*
Static Function ReportPrint(oReport)
*------------------------------------*
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

	oReport:SetTitle("Acao Corretiva x Acoes")// Titulo do relatório

	oReport:SetMeter(0)
	aFill(aDados,nil)
	aFill(aDados1,nil)
	oSection:Init()


	Processa({|| StQuery(  ) },"Compondo Relatorio")

	DbSelectArea(cAliasLif)
	(cAliasLif)->(DbGoTop())
	If  Select(cAliasLif) > 0
	
		While 	(cAliasLif)->(!Eof())

			aDados1[01]	:=  (cAliasLif)->QI5_FILIAL
			aDados1[02]	:=  (cAliasLif)->QI5_CODIGO
			aDados1[03]	:=  (cAliasLif)->QI5_REV
			aDados1[04]	:=  (cAliasLif)->QI5_SEQ
			aDados1[05]	:=  (cAliasLif)->QI5_TPACAO
			aDados1[06]	:=	(cAliasLif)->QI5_FILMAT
			aDados1[07]	:= 	(cAliasLif)->QI5_MAT
			aDados1[08]	:= 	(cAliasLif)->PRAZO
			aDados1[09]	:= 	(cAliasLif)->REALIZ
			aDados1[10]	:= 	(cAliasLif)->QI5_STATUS
			aDados1[11]	:= 	(cAliasLif)->QI5_DESCRE
			aDados1[12]	:= 	(cAliasLif)->QI5_DESCCO
								  	
		
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


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  StQuery      ºAutor  ³Robson Mazzarottoº Data ³  06/04/17    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Relatorio de tarefas em Execução de Acao Corretiva x Acoesº±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*-----------------------------*
Static Function StQuery(_ccod)
*-----------------------------*

	Local cQuery     := ' '


	cQuery := " SELECT
	cQuery += " QI5_FILIAL,
	cQuery += " QI5_CODIGO,
	cQuery += " QI5_REV,
	cQuery += " QI5_SEQ,
	cQuery += " QI5_TPACAO,
	cQuery += " QI5_FILMAT,
	cQuery += " QI5_MAT,
	cQuery += " SUBSTR(QI5_PRAZO,7,2)||'/'|| SUBSTR(QI5_PRAZO,5,2)||'/'|| SUBSTR(QI5_PRAZO,1,4) AS PRAZO ,
	cQuery += " SUBSTR(QI5_REALIZ,7,2)||'/'|| SUBSTR(QI5_REALIZ,5,2)||'/'|| SUBSTR(QI5_REALIZ,1,4) AS REALIZ ,
	cQuery += " QI5_STATUS,
	cQuery += " QI5_DESCRE,
	cQuery += " QI5_DESCCO
	
	cQuery += " FROM "+RetSqlName("QI5")+" QI5

	cQuery += " WHERE QI5.D_E_L_E_T_ = ' '
	cQuery += " AND QI5.QI5_CODIGO BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'
	cQuery += " AND QI5.QI5_TPACAO BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"'
	cQuery += " AND QI5.QI5_MAT BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"'
	cQuery += " AND QI5.QI5_PRAZO BETWEEN '"+Dtos(MV_PAR07)+"' AND '"+Dtos(MV_PAR08)+"'
	cQuery += " AND QI5.QI5_STATUS BETWEEN '"+MV_PAR09+"' AND '"+MV_PAR10+"'
	
	
	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

Return()
 
