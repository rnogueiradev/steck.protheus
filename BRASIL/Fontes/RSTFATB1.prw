#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  RSTFATB1   ºAutor  ³Robson Mazzarotto º Data ³  24/04/17     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Relatorio de previsão de vendas								 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ STECK                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*-----------------------------*
User Function RSTFATB1()
*-----------------------------*
	Local   oReport
	Private cPerg 		:= "RFATB1"
	Private cTime        := Time()
	Private cHora        := SUBSTR(cTime, 1, 2)
	Private cMinutos    	:= SUBSTR(cTime, 4, 2)
	Private cSegundos   	:= SUBSTR(cTime, 7, 2)
	Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos
	Private lXlsHeader   := .f.
	Private lXmlEndRow   := .f.
	Private cPergTit 		:= cAliasLif


	PutSx1(cPerg, "01", "Codigo de:" 	,"Codigo de:" 	 ,"Codigo de:" 		,"mv_ch1","C",15,0,0,"G","","SB1" ,"","","mv_par01","","","","","","","","","","","","","","","","")
	PutSx1(cPerg, "02", "Codigo ate:" 	,"Codigo ate:" 	 ,"Codigo ate:" 		,"mv_ch2","C",15,0,0,"G","","SB1" ,"","","mv_par02","","","","","","","","","","","","","","","","")
	PutSx1(cPerg, "03", "Grupo de:"	,"Grupo de:"	    ,"Grupo de:"	,"mv_ch3","C",03,0,0,"G","","SBM","","" ,"mv_par03","","","","","","","","","","","","","","","","")
	PutSx1(cPerg, "04", "Grupo ate:"	,"Grupo ate:"	    ,"Grupo ate:"	,"mv_ch4","C",03,0,0,"G","","SBM","","" ,"mv_par04","","","","","","","","","","","","","","","","")
	PutSx1(cPerg, "05", "Origem de:","Origem de:"	,"Origem de:"		,"mv_ch5","N",01,0,0,"C","","","","" ,"mv_par05","","","","","","","","","","","","","","","","")
	//PutSx1(cPerg, "06", "Origem ate:","Origem ate:"	,"Origem ate:"		,"mv_ch6","C",10,0,0,"G","","S0","","" ,"mv_par06","","","","","","","","","","","","","","","","")
	//PutSx1(cPerg, "07", "Prazo de:"    ,"Prazo de:"   	,"Prazo de:"		    ,"mv_ch7","D",08,0,0,"G","","","","" ,"mv_par07","","","","","","","","","","","","","","","","")
	//PutSx1(cPerg, "08", "Prazo ate:"    ,"Prazo ate:"   	,"Prazo ate:"		    ,"mv_ch8","D",08,0,0,"G","","","","" ,"mv_par08","","","","","","","","","","","","","","","","")
	//PutSx1(cPerg, "09", "Status de:"    ,"Status de:"   	,"Status de:"		    ,"mv_ch9","C",01,0,0,"G","","","","" ,"mv_par09","","","","","","","","","","","","","","","","")
	//PutSx1(cPerg, "10", "Status ate:"   ,"Status ate:"  	,"Status ate:"	    ,"mv_ch10","C",01,0,0,"G","","","","" ,"mv_par10","","","","","","","","","","","","","","","","")
	
		
	oReport		:= ReportDef()
	oReport:PrintDialog()

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ReportDef    ºAutor  ³Robson Mazzarottoº Data ³  24/04/17    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Relatorio previsão de vendas									º±±
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

	oReport := TReport():New(cPergTit,"Relatório previsão de vendas",cPerg,{|oReport| ReportPrint(oReport)},"Este programa irá imprimir um relatório previsão de vendas")

	Pergunte(cPerg,.F.)

	oSection := TRSection():New(oReport,"Previsão de vendas",{"SB1"})


TRCell():New(oSection,"01",,"CODIGO"		,,30,.F.,)
TRCell():New(oSection,"02",,"DESCRI" 		,,60,.F.,)
TRCell():New(oSection,"03",,"GRUPO" 		,,30,.F.,)
TRCell():New(oSection,"04",,"DESCGRP"     ,,30,.F.,)
TRCell():New(oSection,"05",,"BLOQ"			,,30,.F.,)
TRCell():New(oSection,"06",,"DESAT"		,,30,.F.,)
TRCell():New(oSection,"07",,"FMR"			,,30,.F.,)
TRCell():New(oSection,"08",,"MEDIA_04"		,,30,.F.,)
TRCell():New(oSection,"09",,"MEDIA_02"		,,30,.F.,)
TRCell():New(oSection,"10",,"ESTOQUE"		,,30,.F.,)
TRCell():New(oSection,"11",,"PREVEN"		,,30,.F.,)
TRCell():New(oSection,"12",,"ORIG"	 		,,30,.F.,)
TRCell():New(oSection,"13",,"XOBS"			,,30,.F.,)
TRCell():New(oSection,"14",,"FORNEC"		,,30,.F.,)
TRCell():New(oSection,"15",,"AGRUPAMENTO"	,,50,.F.,)


	oSection:SetHeaderSection(.t.)
	oSection:Setnofilter("QI5")

Return oReport
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ReportPrint  ºAutor  ³Robson Mazzarottoº Data ³  25/04/17    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Relatorio Relatório previsão de vendas						 º±±
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
	Local cCodAgr := ""
	
	cMes1	:= 	"B3_Q"+StrZero(Month(LastDay(dDataBase)-33),2)
	cMes2	:= 	"B3_Q"+StrZero(Month(LastDay(dDataBase)-66),2)
	cMes3	:= 	"B3_Q"+StrZero(Month(LastDay(dDataBase)-99),2)

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
	
	oReport:SetTitle("Relatório previsão de vendas")// Titulo do relatório

	oReport:SetMeter(0)
	aFill(aDados,nil)
	aFill(aDados1,nil)
	oSection:Init()


	Processa({|| StQuery(  ) },"Compondo Relatorio")

	DbSelectArea(cAliasLif)
	(cAliasLif)->(DbGoTop())
	If  Select(cAliasLif) > 0
	
		While 	(cAliasLif)->(!Eof())

			aDados1[01]	:=  (cAliasLif)->B1_COD
			aDados1[02]	:=  (cAliasLif)->B1_DESC
			aDados1[03]	:=  (cAliasLif)->B1_GRUPO
			aDados1[04]	:=  Posicione("SBM",1,xFilial("SBM")+(cAliasLif)->B1_GRUPO,"BM_DESC")
			if (cAliasLif)->B1_MSBLQL = "1"
			aDados1[05]	:=  "SIM"
			else
			aDados1[05]	:=  "NAO"
			endif
			IF (cAliasLif)->B1_XR01 = "1"
			aDados1[06]	:=	"ATIVADO"
			ELSE
			aDados1[06]	:=	"DESATIVADO"
			ENDIF
			aDados1[07]	:= 	(cAliasLif)->B1_XFMR
			Dbselectarea("SB3")
			dbGotop()
			IF dbSeek("04"+(cAliasLif)->B1_COD)
				aDados1[08]	:= (&cmes1+&cmes2 +&cmes3) / 3
			Endif
			Dbselectarea("SB3")
			dbGotop()
			IF dbSeek("02"+(cAliasLif)->B1_COD)
				aDados1[09]	:= (&cmes1+&cmes2 +&cmes3) / 3
			Endif
			aDados1[10]	:=  Posicione("SB2",1,xFilial("SB2")+(cAliasLif)->B1_COD+(cAliasLif)->B1_LOCPAD,"B2_QATU")
			aDados1[11]	:= 	(cAliasLif)->B1_XPREMES
			IF (cAliasLif)->B1_CLAPROD = "F"
			aDados1[12]	:= 	"FABRICADO"
			ELSEIF (cAliasLif)->B1_CLAPROD = "I"
			aDados1[12]	:= 	"IMPORTADO"
			ELSEIF (cAliasLif)->B1_CLAPROD = "C"
			aDados1[12]	:= 	"COMPRADO"
			ENDIF
			aDados1[13]	:= 	(cAliasLif)->B1_XOBSVEN
			aDados1[14]	:= 	(cAliasLif)->B1_PROC
			
			cCodAgr      	:= Posicione("SBM",1,xFilial("SBM")+(cAliasLif)->B1_GRUPO,"BM_XAGRUP")
			aDados1[15]	:= 	Posicione("SX5",1,xFilial("SX5")+"ZZ"+cCodAgr,"X5_DESCRI")
			
		
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
±±ºPrograma  StQuery      ºAutor  ³Robson Mazzarottoº Data ³  25/04/17    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Relatorio previsão de vendas									º±±
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
	cQuery += " B1_COD,
	cQuery += " B1_DESC,
	cQuery += " B1_GRUPO,
	cQuery += " B1_MSBLQL,
	cQuery += " B1_XR01,
	cQuery += " B1_XFMR,
	cQuery += " B1_XPREMES,
	cQuery += " B1_CLAPROD,
	cQuery += " B1_PROC,
	cQuery += " B1_LOCPAD,
	cQuery += " B1_XOBSVEN
	
	
	cQuery += " FROM "+RetSqlName("SB1")+" SB1

	cQuery += " WHERE SB1.D_E_L_E_T_ = ' '
	cQuery += " AND SB1.B1_COD BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'
	cQuery += " AND SB1.B1_GRUPO BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' 
	if mv_par05 = 1
	cQuery += " AND SB1.B1_CLAPROD = 'F' 
	elseif mv_par05 = 2
	cQuery += " AND SB1.B1_CLAPROD = 'I'  
	elseif mv_par05 = 3
	cQuery += " AND SB1.B1_CLAPROD = 'C'  
	endif
	
	
	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

Return()
 

