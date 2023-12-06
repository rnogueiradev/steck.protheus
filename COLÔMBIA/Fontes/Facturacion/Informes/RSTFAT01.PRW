#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*====================================================================================\
|Programa  | RSTFAT01         | Autor | RENATO.OLIVEIRA          | Data | 04/02/2020  |
|=====================================================================================|
|Descri็ใo |  Relat๓rio de picking				                                      |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Hist๓rico....................................|
\====================================================================================*/

User Function RSTFAT01()

	Local   oReport
	Private cPerg 			:= "RFAT01"
	Private cTime           := Time()
	Private cHora           := SUBSTR(cTime, 1, 2)
	Private cMinutos    	:= SUBSTR(cTime, 4, 2)
	Private cSegundos   	:= SUBSTR(cTime, 7, 2)
	Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos
	Private lXlsHeader      := .f.
	Private lXmlEndRow      := .f.
	Private cPergTit 		:= cAliasLif
	
	VALIDPERG(cPerg)

	oReport		:= ReportDef()
	oReport:PrintDialog()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ReportDef    บAutor  ณGiovani Zago    บ Data ณ  21/02/14     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relatorio de Pedidos Aptos a Faturar
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ReportDef()

	Local oReport
	Local oSection

	oReport := TReport():New(cPergTit,"Informe de picking",cPerg,{|oReport| ReportPrint(oReport)},"Este programa imprimirแ un informe de picking")

	Pergunte(cPerg,.F.)

	oSection := TRSection():New(oReport,"Picking",{"SF2"})

	TRCell():New(oSection,"01"	  	,,"Pedido"				,,TamSx3("D2_PEDIDO")[1],.F.,,,,,,,.T.)
	
	TRCell():New(oSection,"13"  	,,"Id comfiar"			,,TamSx3("F2_UUID")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection,"14"  	,,"Direccion"			,,TamSx3("C5_XENDENT")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection,"15"  	,,"Ciudad Entrega"		,,TamSx3("C5_XMUN")[1],.F.,,,,,,,.T.)
	
	TRCell():New(oSection,"02"  	,,"Factura"				,,TamSx3("D2_DOC")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection,"03"	  	,,"Serie"				,,TamSx3("D2_SERIE")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection,"12"  	,,"Emissใo"				,,TamSx3("F2_EMISSAO")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection,"04"		,,"Cliente"				,,TamSx3("D2_CLIENTE")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection,"05"	  	,,"Tienda"				,,TamSx3("D2_LOJA")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection,"06"  	,,"Nombre"	   			,,TamSx3("A1_NOME")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection,"07"		,,"Artํculo"			,,TamSx3("D2_ITEM")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection,"08"  	,,"C๓digo"				,,TamSx3("D2_COD")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection,"09"		,,"Descripci๓n padron"	,,TamSx3("B1_DESC")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection,"10"  	,,"Descripci๓n fabrica"	,,TamSx3("B1_XDESCFB")[1],.F.,,,,,,,.T.)
	TRCell():New(oSection,"11"      ,,"Cantidad"			,,TamSx3("D2_QUANT")[1],.F.,,,,,,,.T.)

	oSection:SetHeaderSection(.t.)
	oSection:Setnofilter("SF2")

Return oReport
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ReportPrint  บAutor  ณGiovani Zago    บ Data ณ  21/02/14     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relatorio GRUPO DE CLIENTE				                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ReportPrint(oReport)

	Local oSection	:= oReport:Section(1)
	Local oSection1	:= oReport:Section(1)
	Local nX		:= 0
	Local cQuery 	:= ""
	Local cAlias 	:= "QRYTEMP0"
	Local aDados[2]
	Local aDados1[99]
	Local _cSta 	:= ''
	Local nValFat := 0

	oSection1:Cell("01"):SetBlock( { || aDados1[01] } )
	oSection1:Cell("02"):SetBlock( { || aDados1[02] } )
	oSection1:Cell("03"):SetBlock( { || aDados1[03] } )
	oSection1:Cell("04"):SetBlock( { || aDados1[04] } )
	oSection1:Cell("05"):SetBlock( { || aDados1[05] } )
	oSection1:Cell("06"):SetBlock( { || aDados1[06] } )
	oSection1:Cell("07"):SetBlock( { || aDados1[07] } )
	oSection1:Cell("08"):SetBlock( { || aDados1[08] } )
	oSection1:Cell("09"):SetBlock( { || aDados1[09] } )
	oSection1:Cell("10"):SetBlock( { || aDados1[10] } )
	oSection1:Cell("11"):SetBlock( { || aDados1[11] } )
	oSection1:Cell("12"):SetBlock( { || aDados1[12] } )

	oSection1:Cell("13"):SetBlock( { || aDados1[13] } )
	oSection1:Cell("14"):SetBlock( { || aDados1[14] } )
	oSection1:Cell("15"):SetBlock( { || aDados1[15] } )

	oReport:SetTitle("Informe de picking")// Titulo do relat๓rio

	oReport:SetMeter(0)
	aFill(aDados,nil)
	aFill(aDados1,nil)
	oSection:Init()

	Processa({|| StQuery( ) },"Procesamiento")

	DbSelectArea(cAliasLif)
	(cAliasLif)->(DbGoTop())
	If  Select(cAliasLif) > 0

		While 	(cAliasLif)->(!Eof())

			aDados1[01]	:=	(cAliasLif)->D2_PEDIDO
			aDados1[02]	:= 	(cAliasLif)->D2_DOC
			aDados1[03]	:=  (cAliasLif)->D2_SERIE
			aDados1[04]	:= 	(cAliasLif)->D2_CLIENTE
			aDados1[05]	:=  (cAliasLif)->D2_LOJA
			aDados1[06]	:=	(cAliasLif)->A1_NOME
			aDados1[07]	:= 	(cAliasLif)->D2_ITEM
			aDados1[08]	:=  (cAliasLif)->B1_COD
			aDados1[09]	:= 	(cAliasLif)->B1_DESC
			aDados1[10]	:=  (cAliasLif)->B1_XDESCFB
			aDados1[11]	:=	(cAliasLif)->D2_QUANT
			aDados1[12]	:=	DTOC(STOD((cAliasLif)->F2_EMISSAO))

			aDados1[13]	:=	(cAliasLif)->F2_UUID
			aDados1[14]	:=	(cAliasLif)->C5_XENDENT
			aDados1[15]	:=	(cAliasLif)->C5_XMUN

			oSection1:PrintLine()
			aFill(aDados1,nil)

			(cAliasLif)->(dbskip())

		End

	EndIf

	oReport:SkipLine()

Return oReport

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  StQuery      บAutor  ณGiovani Zago    บ Data ณ  21/02/14     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relatorio GRUPO DE CLIENTE				                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function StQuery()

	Local cQuery     := ' '

	cQuery := " SELECT D2_PEDIDO, D2_DOC, D2_SERIE, D2_CLIENTE, D2_LOJA, A1_NOME, D2_ITEM, B1_COD, B1_DESC, B1_XDESCFB, D2_QUANT
	cQuery += " ,F2_EMISSAO, F2_UUID, C5_XENDENT, C5_XMUN
	cQuery += " FROM "+RetSqlName("SF2")+" F2
	cQuery += " LEFT JOIN "+RetSqlName("SD2")+" D2
	cQuery += " ON D2_FILIAL=F2_FILIAL AND D2_DOC=F2_DOC AND D2_SERIE=F2_SERIE AND D2_CLIENTE=F2_CLIENTE AND D2_LOJA=F2_LOJA
	cQuery += " LEFT JOIN "+RetSqlName("SB1")+" B1
	cQuery += " ON B1_COD=D2_COD
	cQuery += " LEFT JOIN "+RetSqlName("SA1")+" A1
	cQuery += " ON A1_COD=D2_CLIENTE AND A1_LOJA=D2_LOJA
	cQuery += " LEFT JOIN "+RetSqlName("SC5")+" C5
	cQuery += " ON C5_FILIAL=D2_FILIAL AND C5_NUM=D2_PEDIDO
	cQuery += " WHERE F2.D_E_L_E_T_=' ' AND D2.D_E_L_E_T_=' ' AND B1.D_E_L_E_T_=' ' AND A1.D_E_L_E_T_=' ' AND C5.D_E_L_E_T_=' ' 
	cQuery += " AND F2_FILIAL='"+xFilial("SF2")+"'
	cQuery += " AND F2_DOC BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'
	cQuery += " AND F2_SERIE BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"'
	cQuery += " AND F2_CLIENTE BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"'
	cQuery += " AND F2_LOJA BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"'
	cQuery += " AND F2_EMISSAO BETWEEN '"+DTOS(MV_PAR09)+"' AND '"+DTOS(MV_PAR10)+"'
	cQuery += " ORDER BY D2_DOC, D2_ITEM

	cQuery := ChangeQuery(cQuery)

	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

Return()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ VALIDAR PERGUNTAS NO ARQUIVO SX1                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
STATIC FUNCTION VALIDPERG(cPerg)
LOCAL sAlias := Alias()
LOCAL aRegs  := {}
LOCAL i,j

DBSELECTAREA("SX1")
DBSETORDER(1)
cPerg := PADR(cPerg, 10)

AADD(aRegs,{cPerg,"01","Fact de?"     ,"Fact de?"     ,"Fact de?"     ,"MV_CH1","C",13,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02","Fact ate?"    ,"Fact ate?"    ,"Fact ate?"    ,"MV_CH2","C",13,0,0,"G","","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"03","Serie de?"    ,"Serie de?"    ,"Serie de?"    ,"MV_CH3","C",03,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"04","Serie ate?"   ,"Serie ate?"   ,"Serie ate?"   ,"MV_CH4","C",03,0,0,"G","","MV_PAR04","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"05","Cliente de?"  ,"Cliente de?"  ,"Cliente de?"  ,"MV_CH5","C",06,0,0,"G","","MV_PAR05","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"06","Cliente ate?" ,"Cliente ate?" ,"Cliente ate?" ,"MV_CH6","C",06,0,0,"G","","MV_PAR06","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"07","Loja de?"     ,"Loja de?"     ,"Loja de?"     ,"MV_CH7","C",02,0,0,"G","","MV_PAR07","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"08","Loja ate?"    ,"Loja ate?"    ,"Loja ate?"    ,"MV_CH9","C",02,0,0,"G","","MV_PAR08","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"09","Data de?"     ,"Data de?"     ,"Data de?"     ,"MV_CH0","D",10,0,0,"G","","MV_PAR09","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"10","Data ate?"    ,"Data ate?"    ,"Data ate?"    ,"MV_CHA","D",10,0,0,"G","","MV_PAR10","","","","","","","","","","","","","","","","","","","","","","","","","",""})

FOR i:=1 TO LEN(aRegs)
	cRegistro := cPerg+aRegs[i,2]
	IF !DBSEEK(cRegistro)
		RecLock("SX1",.T.)
		FOR j:=1 TO FCOUNT()
			IF j <= LEN(aRegs[i])
				FieldPut(j,aRegs[i,j])
			ENDIF
		NEXT
		MsUnlock()
	ENDIF
NEXT

DBSELECTAREA(sAlias)
RETURN

