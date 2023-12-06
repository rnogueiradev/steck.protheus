#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRSTFAT64  บAutor  ณRenato Nogueira     บ Data ณ  18/02/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relat๓rio de libera็๕es financeiras                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ  Financeir                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿

<<<< ALTERAวรO >>>>
A็ใo.........: Corre็ใo na Query que estava chumbado a tabela para empresa 010 sendo que agora a empres a้ a 110
Desenvolvedor: Marcelo Klopfer Leme - SIGAMAT
Data.........: 11/01/2022
Chamados.....: 20220110000704

<<<< ALTERAวรO >>>>
A็ใo.........: Adequar o relat๓rio para exibir os novos campos "Dt. Emissใo do pedido Venda" e "Hora Emissใo Pedido Venda"
Campos: ZA_DTEMI , ZA_HREMI
Desenvolvedora: Flแvia Rocha - SIGAMAT
Data.........: 09/11/2022
Chamados.....: 20220622012634


*************************************************************************((*/
*-----------------------------*
User Function RSTFAT64()
*-----------------------------*
Local   oReport
Private cPerg 			:= "RFAT64"
Private cTime           := Time()
Private cHora           := SUBSTR(cTime, 1, 2)
Private cMinutos    	:= SUBSTR(cTime, 4, 2)
Private cSegundos   	:= SUBSTR(cTime, 7, 2)
Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos
Private lXlsHeader      := .f.
Private lXmlEndRow      := .f.
Private cPergTit 		:= cAliasLif

PutSx1(cPerg, "01", "Emissao de:" 					,"Emissao de: ?" 	,"Emissao de: ?"	,"mv_ch1","D",8,0,0,"G","",''    	 ,"","","mv_par03","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "02", "Emissao ate:" 					,"Emissao ate: ?" 	,"Emissao ate: ?"	,"mv_ch2","D",8,0,0,"G","",''    	 ,"","","mv_par04","","","","","","","","","","","","","","","","")

oReport		:= ReportDef()
oReport:PrintDialog()

FreeObj(oReport)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณReportDef บAutor  ณRenato Nogueira     บ Data ณ  22/07/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  								                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*-----------------------------*
Static Function ReportDef()
*-----------------------------*
Local oReport
Local oSection

oReport := TReport():New(cPergTit,"Relat๓rio de libera็ใo financeira",cPerg,{|oReport| ReportPrint(oReport)},"Este programa irแ imprimir um relat๓rio de libera็๕es financeiras")

Pergunte(cPerg,.F.)

oSection := TRSection():New(oReport,"Libera็๕es",{"SC6"})

	TRCell():New(oSection,"FILIAL"	  			 ,,"FILIAL"					,"@!"			   		,2  ,.F.,)
	TRCell():New(oSection,"PEDIDO"			 	 ,,"PEDIDO"					,"@!" 			   		,6  ,.F.,)
	TRCell():New(oSection,"ITEM"				 ,,"ITEM"					,"@!" 			  		,2  ,.F.,)
	TRCell():New(oSection,"PRODUTO"				 ,,"PRODUTO"				,"@!"				  	,15 ,.F.,)
	TRCell():New(oSection,"VALOR"				 ,,"VALOR"					,"@E 999,999,999.99" ,12 ,.F.,)
	TRCell():New(oSection,"CLIENTE"				 ,,"CLIENTE"				,"@!"				  	,6  ,.F.,)
	TRCell():New(oSection,"LOJA"				 ,,"LOJA"					,"@!"				  	,2  ,.F.,)
	TRCell():New(oSection,"STATUS"				 ,,"STATUS"					,"@!"				  	,10 ,.F.,)
	TRCell():New(oSection,"TIPO"				 ,,"TIPO"					,"@!"				  	,10 ,.F.,)
	TRCell():New(oSection,"STETP"				 ,,"STATUS/TIPO"			,"@!"				  	,21 ,.F.,)
	TRCell():New(oSection,"DATA"				 ,,"DATA"					,"@!"				  	,10 ,.F.,)
	TRCell():New(oSection,"HORA"				 ,,"HORA"					,"@!"				  	,8  ,.F.,)
	TRCell():New(oSection,"USUARIO"				 ,,"USUARIO"				,"@!"				  	,30 ,.F.,)
	TRCell():New(oSection,"DTEMI"				 ,,"DT.EMISSAO"				,"@!"				  	,10 ,.F.,)
	TRCell():New(oSection,"HREMI"			 	 ,,"HR.EMISSAO"				,"@!"				  	,8  ,.F.,)

oSection:SetHeaderSection(.t.)
oSection:Setnofilter("SC6")

Return oReport

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma  ณReportPrintบAutor  ณRenato Nogueira     บ Data ณ  22/07/14  บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออนฑฑ
ฑฑบDesc.     ณ  								                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*------------------------------------*
Static Function ReportPrint(oReport)
*------------------------------------*
Local oSection	:= oReport:Section(1)
Local oSection1	:= oReport:Section(1)
Local nX		:= 0
Local cQuery 	:= ""
Local cAlias 	:= "QRYTEMP0"
Local aDados1[15]
Local cCodOpe	:= ""
Local lImprime	:= .F.
Local cHoraFim	:= ""
Local cOrdSep	:= ""         
Local nHours
Local nMinuts
Local nSeconds

	oSection1:Cell("FILIAL")    			:SetBlock( { || aDados1[01] } )
	oSection1:Cell("PEDIDO")  				:SetBlock( { || aDados1[02] } )
	oSection1:Cell("ITEM")  				:SetBlock( { || aDados1[03] } )
	oSection1:Cell("PRODUTO")				:SetBlock( { || aDados1[04] } )
	oSection1:Cell("VALOR")		  			:SetBlock( { || aDados1[05] } )
	oSection1:Cell("CLIENTE")				:SetBlock( { || aDados1[06] } )
	oSection1:Cell("LOJA")	  				:SetBlock( { || aDados1[07] } )
	oSection1:Cell("STATUS")	  			:SetBlock( { || aDados1[08] } )
	oSection1:Cell("TIPO")	  				:SetBlock( { || aDados1[09] } )
	oSection1:Cell("DATA")	  				:SetBlock( { || aDados1[10] } )
	oSection1:Cell("HORA")	  				:SetBlock( { || aDados1[11] } )
	oSection1:Cell("USUARIO")	  			:SetBlock( { || aDados1[12] } )
	oSection1:Cell("STETP")	  				:SetBlock( { || aDados1[13] } )
	oSection1:Cell("DTEMI")					:SetBlock( { || aDados1[14] } )
	oSection1:Cell("HREMI")	  				:SetBlock( { || aDados1[15] } )
	
oReport:SetTitle("Libera็ใo")// Titulo do relat๓rio

oReport:SetMeter(0)
aFill(aDados1,nil)
oSection:Init()

	Processa({|| StQuery() },"Compondo Relatorio")
	
	DbSelectArea(cAliasLif)
	(cAliasLif)->(DbGoTop())
	
	If  Select(cAliasLif) > 0
		
		While (cAliasLif)->(!Eof())
			
			aDados1[01]	:=	(cAliasLif)->FILIAL
			aDados1[02]	:= 	(cAliasLif)->PEDIDO
			aDados1[03]	:=  (cAliasLif)->ITEM
			aDados1[04]	:= 	(cAliasLif)->PRODUTO
			aDados1[05]	:=  (cAliasLif)->VALOR
			aDados1[06]	:=	(cAliasLif)->CLIENTE
			aDados1[07]	:= 	(cAliasLif)->LOJA
			aDados1[08]	:=  IIF(AllTrim((cAliasLif)->STATUS)=="L","LIBERADO","REJEITADO")
			aDados1[09]	:=  IIF(AllTrim((cAliasLif)->TIPO)=="A","AUTOMATICO","MANUAL")
			aDados1[10]	:= 	DTOC(STOD((cAliasLif)->DATA))
			aDados1[11]	:= 	(cAliasLif)->HORA
			aDados1[12]	:= 	(cAliasLif)->USUARIO
			aDados1[13]	:= 	aDados1[08]+"/"+aDados1[09]
			aDados1[14]	:= 	DTOC(STOD((cAliasLif)->DTEMI))
			aDados1[15]	:= 	(cAliasLif)->HREMI
			
			oSection1:PrintLine()
			aFill(aDados1,nil)
			
			(cAliasLif)->(dbskip())
			
		EndDo

		oReport:SkipLine()
		
	EndIf
	
Return oReport

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  StQuery      บAutor  ณRenato Nogueira บ Data ณ  21/02/14     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relatorio COMISSAO				                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function StQuery()
Local cQuery     := ' '

/********************************************
<<<< ALTERAวรO >>>>
A็ใo.........: Corre็ใo na Query que estava chumbado a tabela para empresa 010 sendo que agora a empres a้ a 110
Desenvolvedor: Marcelo Klopfer Leme - SIGAMAT
Data.........: 11/01/2022
Chamados.....: 20220110000704
********************************************/

cQuery := "SELECT ZA_FILIAL FILIAL, ZA_PEDIDO PEDIDO, ZA_ITEM ITEM,ZA_PRODUTO PRODUTO, "+CRLF
cQuery += "ZA_CLIENTE CLIENTE, ZA_LOJA LOJA, ZA_STATUS STATUS, ZA_APROV TIPO, ZA_USUARIO USUARIO, " +CRLF
cQuery += "MAX(ZA_QTDVEN * ZA_PRCVEN) AS VALOR, SUBSTR(MAX(ZA_DATA || ZA_HORA),1,8) DATA, SUBSTR(MAX(ZA_DATA || ZA_HORA),9,8) HORA "+CRLF

//FR- 09/11/2022 - Implementar campo data e hora da emissใo do pedido
cQuery += ", NVL(ZA_DTEMI, ' ') AS DTEMI "	+CRLF +CRLF

cQuery += ", NVL(ZA_HREMI, ' ' ) AS HREMI "	+CRLF +CRLF

//FR- 09/11/2022 - Implementar campo data e hora da emissใo do pedido

cQuery += "FROM " + RetSqlName("SZA") + " ZA "
cquery += "WHERE ZA.D_E_L_E_T_= ' ' AND ZA_DATA BETWEEN '" + DTOS(mv_par01) + "' AND '" + DTOS(mv_par02) + "' AND ZA_DATA >= '20150312' "+CRLF
cquery += "AND ZA.ZA_DTEMI <> ' ' AND ZA.ZA_HREMI <> ' ' "+ CRLF
cQuery += "GROUP BY ZA_FILIAL, ZA_PEDIDO, ZA_ITEM,ZA_PRODUTO,ZA_CLIENTE,ZA_LOJA,ZA_STATUS,ZA_APROV,ZA_USUARIO "+CRLF
cQuery += ", ZA_DTEMI , ZA_HREMI "  //FR- 09/11/2022 - Implementar campo data e hora da emissใo do pedido
cQuery += "ORDER BY ZA_FILIAL, ZA_PEDIDO, ZA_ITEM "

MemoWrite("C:\TEMP\RSTFAT64.TXT" , cQuery )
cQuery := ChangeQuery(cQuery)

If Select(cAliasLif) > 0
	(cAliasLif)->(dbCloseArea())
EndIf

dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

Return()
