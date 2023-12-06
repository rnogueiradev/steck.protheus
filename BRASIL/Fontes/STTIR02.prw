#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STTIR02	ºAutor  ³Renato Nogueira     º Data ³  11/03/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Relatório utilizado para detalhar o tempo de atendimento    º±±
±±º          ³dos chamados	                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function STTIR02()

Local oReport

PutSx1("STTIR02", "01","Chamado de?" ,"","","mv_ch1","C",6,0,0,"G","","SZ0","","","mv_par01","","","","","","","","","","","","","","","","")
PutSx1("STTIR02", "02","Chamado ate?","","","mv_ch2","C",6,0,0,"G","","SZ0","","","mv_par02","","","","","","","","","","","","","","","","")

oReport		:= ReportDef()
oReport		:PrintDialog()

Return

Static Function ReportDef()

Local oReport
Local oSection

oReport := TReport():New("STTIR02","RELATÓRIO DE CHAMADOS","STTIR02",{|oReport| ReportPrint(oReport)},"Este programa irá imprimir um relatório de tempo de atendimento dos chamados.")

Pergunte("STTIR02",.F.)

oSection := TRSection():New(oReport,"CHAMADOS",{"ZZF"})

TRCell():New(oSection,"CHAMADO"   	,"ZZF","CHAMADO"        							,"@!",6)
TRCell():New(oSection,"DESC"   		,"ZZF","DESCRICAO"       							,"@!",70)
TRCell():New(oSection,"SOLIC"   	,"ZZF","SOLICITANTE"       							,"@!",30)
TRCell():New(oSection,"ANALIST"   	,"ZZF","ANALISTA"       							,"@!",30)
TRCell():New(oSection,"STATUS"		,"ZZF","STATUS FINAL"    	    					,"@!",15)
TRCell():New(oSection,"DEPTO"  		,"ZZF","DEPARTAMENTO"    	    					,"@!",15)
TRCell():New(oSection,"12"  		,"ZZF","TEMPO APROVAÇÃO DO SUPERVISOR"    	    	,"@!",15)
TRCell():New(oSection,"23"  		,"ZZF","TEMPO APROVAÇÃO DO GESTOR DE TI"    	   	,"@!",15)
TRCell():New(oSection,"34"  		,"ZZF","TEMPO ATÉ COLOCAR EM DESENVOLVIMENTO"  	   	,"@!",15)
TRCell():New(oSection,"45"  		,"ZZF","TEMPO DE DESENVOLVIMENTO"		    	   	,"@!",15)
TRCell():New(oSection,"56"  		,"ZZF","TEMPO DE APROVAÇÃO DO USUÁRIO"	    	   	,"@!",15)
TRCell():New(oSection,"67"  		,"ZZF","TEMPO DE LIBERAÇAO PARA PRODUÇÃO"	    	,"@!",15)
TRCell():New(oSection,"78"  		,"ZZF","TEMPO DE ENCERRAMENTO"				    	,"@!",15)
TRCell():New(oSection,"DTOTAL" 		,"ZZF","TEMPO TOTAL (DIAS)"		    	    		,"@!",15)

oSection:SetHeaderSection(.T.)
oSection:Setnofilter("ZZF")

Return oReport

Static Function ReportPrint(oReport)

Local oSection	:= oReport:Section(1)
Local cQuery 	:= ""
Local cAlias 	:= "QRYTEMP"
Local aDados[11]
Local _aDados	:= {}
Local cStatus	:= cDesc	:= cSolic	:= cAnalist	:= ""

oSection:Cell("CHAMADO")  	:SetBlock( { || aDados[1] } ) 
oSection:Cell("DESC") 		:SetBlock( { || cDesc 	   } )
oSection:Cell("SOLIC") 		:SetBlock( { || cSolic 	   } )
oSection:Cell("ANALIST")	:SetBlock( { || cAnalist   } )
oSection:Cell("STATUS")   	:SetBlock( { || aDados[2] } )
oSection:Cell("DEPTO")  	:SetBlock( { || aDados[3] } )
oSection:Cell("12")  		:SetBlock( { || aDados[4] } )
oSection:Cell("23")  		:SetBlock( { || aDados[5] } )
oSection:Cell("34")  		:SetBlock( { || aDados[6] } )
oSection:Cell("45")  		:SetBlock( { || aDados[7] } )
oSection:Cell("56")  		:SetBlock( { || aDados[8] } )
oSection:Cell("67")  		:SetBlock( { || aDados[9] } )
oSection:Cell("78")  		:SetBlock( { || aDados[10] } )
oSection:Cell("DTOTAL") 	:SetBlock( { || aDados[11] } )

oReport:SetTitle("Lista de chamados")// Titulo do relatório

cQuery := " SELECT DISTINCT ZZF_NUM NUMERO, Z0_DESCRI DESCRICAO, Z0_USUARIO SOLIC, Z0_ANALIST ANALISTA, "
cQuery += " NVL((SELECT MAX(ZZF_DTSOLI) FROM ZZF010 WHERE D_E_L_E_T_=' ' AND ZZF_STATUS='1' AND ZZF_NUM=Z0_NUM GROUP BY ZZF_NUM),0) DTST1, "
cQuery += " NVL((SELECT MAX(ZZF_HRSOLI) FROM ZZF010 WHERE D_E_L_E_T_=' ' AND ZZF_STATUS='1' AND ZZF_NUM=Z0_NUM GROUP BY ZZF_NUM),0) HRST1, "
cQuery += " NVL((SELECT MAX(ZZF_DTSOLI) FROM ZZF010 WHERE D_E_L_E_T_=' ' AND ZZF_STATUS='2' AND ZZF_NUM=Z0_NUM GROUP BY ZZF_NUM),0) DTST2, "
cQuery += " NVL((SELECT MAX(ZZF_HRSOLI) FROM ZZF010 WHERE D_E_L_E_T_=' ' AND ZZF_STATUS='2' AND ZZF_NUM=Z0_NUM GROUP BY ZZF_NUM),0) HRST2, "
cQuery += " NVL((SELECT MAX(ZZF_DTSOLI) FROM ZZF010 WHERE D_E_L_E_T_=' ' AND ZZF_STATUS='3' AND ZZF_NUM=Z0_NUM GROUP BY ZZF_NUM),0) DTST3, "
cQuery += " NVL((SELECT MAX(ZZF_HRSOLI) FROM ZZF010 WHERE D_E_L_E_T_=' ' AND ZZF_STATUS='3' AND ZZF_NUM=Z0_NUM GROUP BY ZZF_NUM),0) HRST3, "
cQuery += " NVL((SELECT MAX(ZZF_DTSOLI) FROM ZZF010 WHERE D_E_L_E_T_=' ' AND ZZF_STATUS='4' AND ZZF_NUM=Z0_NUM GROUP BY ZZF_NUM),0) DTST4, "
cQuery += " NVL((SELECT MAX(ZZF_HRSOLI) FROM ZZF010 WHERE D_E_L_E_T_=' ' AND ZZF_STATUS='4' AND ZZF_NUM=Z0_NUM GROUP BY ZZF_NUM),0) HRST4, "
cQuery += " NVL((SELECT MAX(ZZF_DTSOLI) FROM ZZF010 WHERE D_E_L_E_T_=' ' AND ZZF_STATUS='5' AND ZZF_NUM=Z0_NUM GROUP BY ZZF_NUM),0) DTST5, "
cQuery += " NVL((SELECT MAX(ZZF_HRSOLI) FROM ZZF010 WHERE D_E_L_E_T_=' ' AND ZZF_STATUS='5' AND ZZF_NUM=Z0_NUM GROUP BY ZZF_NUM),0) HRST5, "
cQuery += " NVL((SELECT MAX(ZZF_DTSOLI) FROM ZZF010 WHERE D_E_L_E_T_=' ' AND ZZF_STATUS='6' AND ZZF_NUM=Z0_NUM GROUP BY ZZF_NUM),0) DTST6, "
cQuery += " NVL((SELECT MAX(ZZF_HRSOLI) FROM ZZF010 WHERE D_E_L_E_T_=' ' AND ZZF_STATUS='6' AND ZZF_NUM=Z0_NUM GROUP BY ZZF_NUM),0) HRST6, "
cQuery += " NVL((SELECT MAX(ZZF_DTSOLI) FROM ZZF010 WHERE D_E_L_E_T_=' ' AND ZZF_STATUS='7' AND ZZF_NUM=Z0_NUM GROUP BY ZZF_NUM),0) DTST7, "
cQuery += " NVL((SELECT MAX(ZZF_HRSOLI) FROM ZZF010 WHERE D_E_L_E_T_=' ' AND ZZF_STATUS='7' AND ZZF_NUM=Z0_NUM GROUP BY ZZF_NUM),0) HRST7, "
cQuery += " NVL((SELECT MAX(ZZF_DTSOLI) FROM ZZF010 WHERE D_E_L_E_T_=' ' AND ZZF_STATUS='8' AND ZZF_NUM=Z0_NUM GROUP BY ZZF_NUM),0) DTST8, "
cQuery += " NVL((SELECT MAX(ZZF_HRSOLI) FROM ZZF010 WHERE D_E_L_E_T_=' ' AND ZZF_STATUS='8' AND ZZF_NUM=Z0_NUM GROUP BY ZZF_NUM),0) HRST8, "
cQuery += " Z0_STATUS, Z0_MODULO DEPARTAMENTO "
cQuery += " FROM " +RetSqlName("SZ0")+ " Z0 "
cQuery += " INNER JOIN " +RetSqlName("ZZF")+ " ZF "
cQuery += " ON ZZF_FILIAL=Z0_FILIAL AND ZZF_NUM=Z0_NUM "
cQuery += " WHERE ZF.D_E_L_E_T_=' ' AND Z0.D_E_L_E_T_=' ' AND Z0_NUM BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
cQuery += " ORDER BY ZZF_NUM "

If !Empty(Select(cAlias))
	DbSelectArea(cAlias)
	(cAlias)->(dbCloseArea())
Endif

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

dbSelectArea(cAlias)
(cAlias)->(dbGoTop())

oReport:SetMeter(0)
aFill(aDados,nil)
oSection:Init()

While !(cAlias)->(Eof())
	
	DO CASE
		CASE (cAlias)->Z0_STATUS=="1"
			cStatus	:= "Aguardando Aprov. Superv."
		CASE (cAlias)->Z0_STATUS=="2"
			cStatus	:= "Aprovado Supervisor"
		CASE (cAlias)->Z0_STATUS=="3"
			cStatus	:= "Aprovado para desenvolvimento"
		CASE (cAlias)->Z0_STATUS=="4"
			cStatus	:= "Em desenvolvimento"
		CASE (cAlias)->Z0_STATUS=="5"
			cStatus	:= "Aguardando aceite usuário"
		CASE (cAlias)->Z0_STATUS=="6"
			cStatus	:= "Aprovado pelo usuário"
		CASE (cAlias)->Z0_STATUS=="7"
			cStatus	:= "Liberado p/ Amb. Produção"
		CASE (cAlias)->Z0_STATUS=="8"
			cStatus	:= "Chamado concluído"
		CASE (cAlias)->Z0_STATUS=="9"
			cStatus	:= "Chamado cancelado"
	ENDCASE
	
	DbSelectArea("SX5")
	SX5->(DbGotop())
	SX5->(DbSetOrder(1))
	SX5->(DbSeek(xFilial("SX5")+"ZX"+(cAlias)->DEPARTAMENTO))
	
	If (cAlias)->Z0_STATUS=="9"
		
		aDados[1]	:= (cAlias)->NUMERO
		cDesc   	:= (cAlias)->DESCRICAO
		cSolic     	:= (cAlias)->SOLIC
		cAnalist   	:= Alltrim(UsrRetName((cAlias)->ANALISTA))
		aDados[2]	:= cStatus
		aDados[3]	:= SX5->X5_DESCRI
		aDados[4]	:= aDados[5]	:= aDados[6]	:= aDados[7]	:= aDados[8]	:= aDados[9]	:= aDados[10]	:= ""
		aDados[11]	:= "CANCELADO"
		
	Else
		
		aDados[1]	:= (cAlias)->NUMERO
		cDesc   	:= (cAlias)->DESCRICAO
		cSolic     	:= (cAlias)->SOLIC
		cAnalist   	:= Alltrim(UsrRetName((cAlias)->ANALISTA))
		aDados[2]	:= cStatus
		aDados[3]	:= SX5->X5_DESCRI
		aDados[4]	:= cValToChar( DateDiffDay( STOD((cAlias)->DTST2) , STOD((cAlias)->DTST1) ) )+ " D " + SubStr(ElapTime((cAlias)->HRST1+":00",(cAlias)->HRST2+":00"),1,5) + " M"
		aDados[5]	:= cValToChar( DateDiffDay( STOD((cAlias)->DTST3) , STOD((cAlias)->DTST2) ) )+ " D " + SubStr(ElapTime((cAlias)->HRST2+":00",(cAlias)->HRST3+":00"),1,5) + " M"
		aDados[6]	:= cValToChar( DateDiffDay( STOD((cAlias)->DTST4) , STOD((cAlias)->DTST3) ) )+ " D " + SubStr(ElapTime((cAlias)->HRST3+":00",(cAlias)->HRST4+":00"),1,5) + " M"
		aDados[7]	:= cValToChar( DateDiffDay( STOD((cAlias)->DTST5) , STOD((cAlias)->DTST4) ) )+ " D " + SubStr(ElapTime((cAlias)->HRST4+":00",(cAlias)->HRST5+":00"),1,5) + " M"
		aDados[8]	:= cValToChar( DateDiffDay( STOD((cAlias)->DTST6) , STOD((cAlias)->DTST5) ) )+ " D " + SubStr(ElapTime((cAlias)->HRST5+":00",(cAlias)->HRST6+":00"),1,5) + " M"
		aDados[9]	:= cValToChar( DateDiffDay( STOD((cAlias)->DTST7) , STOD((cAlias)->DTST6) ) )+ " D " + SubStr(ElapTime((cAlias)->HRST6+":00",(cAlias)->HRST7+":00"),1,5) + " M"
		aDados[10]	:= cValToChar( DateDiffDay( STOD((cAlias)->DTST8) , STOD((cAlias)->DTST7) ) )+ " D " + SubStr(ElapTime((cAlias)->HRST7+":00",(cAlias)->HRST8+":00"),1,5) + " M"
		
		If AllTrim((cAlias)->DTST8)=="0"
			aDados[11]	:= "NAO CONCLUIDO"
		Else
			aDados[11]	:= cValToChar ( DateDiffDay( STOD((cAlias)->DTST8) , STOD((cAlias)->DTST1) ) )
		EndIf
		
		DO CASE
		CASE AllTrim((cAlias)->DTST2)=="0"
			aDados[4]	:= "0 D 00:00:00 M"
		CASE AllTrim((cAlias)->DTST3)=="0"
			aDados[5]	:= "0 D 00:00:00 M"
		CASE AllTrim((cAlias)->DTST4)=="0"
			aDados[6]	:= "0 D 00:00:00 M"
		CASE AllTrim((cAlias)->DTST5)=="0"
			aDados[7]	:= "0 D 00:00:00 M"
		CASE AllTrim((cAlias)->DTST6)=="0"
			aDados[8]	:= "0 D 00:00:00 M"
		CASE AllTrim((cAlias)->DTST7)=="0"
			aDados[9]	:= "0 D 00:00:00 M"
		CASE AllTrim((cAlias)->DTST8)=="0"
			aDados[10]	:= "0 D 00:00:00 M"
		END CASE
		
	EndIf
	
	oSection:PrintLine()
	aFill(aDados,nil)
	
	(cAlias)->(DbSkip())
	
EndDo

DbSelectArea(cAlias)
(cAlias)->(dbCloseArea())

Return oReport