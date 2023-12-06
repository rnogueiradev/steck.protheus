#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "Rwmake.ch"
#INCLUDE "TopConn.ch"


/*/{Protheus.doc} ARRFAT06
(Relatório de comissão de vendedores)

@author jefferson.carlos
@since 24/10/2018
@version 1.0
@return ${return}, ${return_description}

/*/

User Function ARRFAT06()
	
	Local   oReport
	Private cPerg 		:= "ARFAT06"
	Private cTime        := Time()
	Private cHora        := SUBSTR(cTime, 1, 2)
	Private cMinutos    	:= SUBSTR(cTime, 4, 2)
	Private cSegundos   	:= SUBSTR(cTime, 7, 2)
	Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos
	Private lXlsHeader   := .F.
	Private lXmlEndRow   := .F.
	Private cPergTit 		:= cAliasLif
	
	
	PutSx1(cPerg, "01", "De fecha:"	,"De fecha:"	,"De fecha:"			,"mv_ch1","D"   	,08      	,0     ,0     ,"G",""    ,""	 	,"","","mv_par01","","","","","","","","","","","","","","","","")
	PutSx1(cPerg, "02", "A fecha:"		,"A fecha:"		,"A fecha:"				,"mv_ch2","D"   	,08      	,0     ,0     ,"G",""    ,""	 	,"","","mv_par02","","","","","","","","","","","","","","","","")
	
	
	oReport		:= ReportDef()
	oReport:PrintDialog()
	
Return



/*/{Protheus.doc} ARRFAT06
(Relatório de comissão de vendedores)

@author jefferson.carlos
@since 24/10/2018
@version 1.0

/*/


Static Function ReportDef()
	
	Local oReport
	Local oSection
	
	oReport := TReport():New(cPergTit,"Informe de comisiones",cPerg,{|oReport| ReportPrint(oReport)},"Este programa imprimirá un informe de comisiones")
	
	Pergunte(cPerg,.T.)
	
	oSection := TRSection():New(oReport,"Informe de comisiones",{"MOV"})
	
	
	
	TRCell():New(oSection,"01",,"TIPO	"			,,05,.F.,)
	TRCell():New(oSection,"02",,"FACTURA"			,,12,.F.,)
	TRCell():New(oSection,"03",,"SERIE" 			,,01,.F.,)
	TRCell():New(oSection,"04",,"CLIENTE" 			,,06,.F.,)
	TRCell():New(oSection,"05",,"LOJA" 				,,02,.F.,)
	TRCell():New(oSection,"06",,"NOMBRE"  			,,15,.F.,)
	TRCell():New(oSection,"07",,"EMISSION" 			,,08,.F.,)
	TRCell():New(oSection,"08",,"PRODUTO" 	    	,,15,.F.,)
	TRCell():New(oSection,"09",,"GRUPO"				,,08,.F.,)
	TRCell():New(oSection,"10",,"% COMISION"		,,04,.F.,)
	TRCell():New(oSection,"11",,"TOTAL"				,,12,.F.,)
	TRCell():New(oSection,"12",,"VAOR COMISION"		,,12,.F.,)
	TRCell():New(oSection,"13",,"VENDEDOR"			,,06,.F.,)
	
	
	
	oSection:SetHeaderSection(.t.)
	oSection:Setnofilter("MOV")
	
Return oReport


/*/{Protheus.doc} ARRFAT06
(Relatório de comissão de vendedores)

@author jefferson.carlos
@since 24/10/2018
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
			
						
			aDados1[01]	:=  (cAliasLif)->TIPO
			aDados1[02]	:=  (cAliasLif)->FACTURA
			aDados1[03]	:=  (cAliasLif)->SERIE
			aDados1[04]	:=  (cAliasLif)->CLIENTE
			aDados1[05]	:= 	(cAliasLif)->LOJA
			aDados1[06]	:= 	(cAliasLif)->NOMBRE
			aDados1[07]	:=  DTOC(STOD((cAliasLif)->EMISSION))			
			aDados1[08]	:= (cAliasLif)->PRODUTO
			aDados1[09]	:= 	(cAliasLif)->GRUPO
			aDados1[10]	:= (cAliasLif)->COMIS
			aDados1[11]	:= (cAliasLif)->TOTAL
			aDados1[12]	:= (cAliasLif)->COMISSAO
			aDados1[13]	:= (cAliasLif)->VENDEDOR
				
			
			
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


	Local cQuery1     := ' '
	
	cQuery1+= "	SELECT 'VENTA' AS TIPO,D2_DOC FACTURA,D2_SERIE SERIE,A1_COD CLIENTE,A1_LOJA LOJA,A1_NOME NOMBRE,"
	cQuery1+= " F2_EMISSAO EMISSION,D2_COD PRODUTO,D2_GRUPO GRUPO,D2_COMIS1 COMIS,D2_TOTAL TOTAL,ROUND(((D2_TOTAL/100)*D2_COMIS1),2) AS COMISSAO,F2_VEND1 VENDEDOR"
	cQuery1+= "	FROM "+RetSqlName("SD2")+" SD2 "
	cQuery1+= "	INNER JOIN(SELECT * FROM " + RetSqlName("SB1") + ")SB1 " 
	cQuery1+= " ON SB1.D_E_L_E_T_ = ' ' " 
	cQuery1+= " AND B1_COD = D2_COD "
	cQuery1+= " INNER JOIN(SELECT * FROM " + RetSqlName("SF2") + ")SF2 "
	cQuery1+= " ON SF2.D_E_L_E_T_ = ' ' " 
	cQuery1+= " AND F2_DOC = D2_DOC "
	cQuery1+= " AND F2_SERIE = D2_SERIE "
	cQuery1+= " INNER JOIN(SELECT * FROM " + RetSqlName("SF4") + ")SF4 "
	cQuery1+= " ON SF4.D_E_L_E_T_ = ' ' "
	cQuery1+= " AND F4_CODIGO = D2_TES "
	cQuery1+= " AND F4_DUPLIC = 'S' "
	cQuery1+= " INNER JOIN(SELECT * FROM " + RetSqlName("SA3") + ")SA3 "
	cQuery1+= " ON SA3.D_E_L_E_T_ = ' ' "
	cQuery1+= " AND A3_COD = F2_VEND1 "
	cQuery1+= " INNER JOIN(SELECT * FROM " + RetSqlName("SA1") + ")SA1 "
	cQuery1+= " ON SA1.D_E_L_E_T_ = ' ' "
	cQuery1+= " AND A1_COD = F2_CLIENTE "
	cQuery1+= " AND A1_LOJA = F2_LOJA "
	cQuery1+= " WHERE SD2.D_E_L_E_T_ = ' ' "
	cQuery1+= " AND D2_COMIS1 <> 0 "
	cQuery1+= " AND D2_SERIE <> 'R' "
	cQuery1+= " AND F2_EMISSAO BETWEEN '" + DTOS(MV_PAR01) + "' AND '" + DTOS(MV_PAR02) + "' "
	cQuery1+= " UNION "
	cQuery1+= " SELECT 'COBRA' AS TIPO,E1_NUM,E1_PREFIXO,A1_COD,A1_LOJA,A1_NOME,E5_DTDISPO,' ',' ',A3_XCOMISS,E5_VALOR,"
	cQuery1+= " ROUND(((E5_VALOR/100)*A3_XCOMISS),2) AS COMISSAO,A1_VEND "
	cQuery1+= " FROM "+RetSqlName("SE1")+" SE1"
	cQuery1+= " INNER JOIN(SELECT * FROM " + RetSqlName("SE5") + ")SE5 "
	cQuery1+= " ON SE5.D_E_L_E_T_ = ' ' "
	cQuery1+= " AND E5_NUMERO = E1_NUM "
	cQuery1+= " AND E5_PREFIXO = E1_PREFIXO "
	cQuery1+= " AND E5_PARCELA = E1_PARCELA "
	cQuery1+= " AND E5_DTDISPO BETWEEN '" + DTOS(MV_PAR01) + "' AND '" + DTOS(MV_PAR02) + "' "
	cQuery1+= " INNER JOIN(SELECT * FROM " + RetSqlName("SA1") + ")SA1 "
	cQuery1+= " ON SA1.D_E_L_E_T_ = ' ' "
	cQuery1+= " AND A1_COD = E1_CLIENTE "
	cQuery1+= " AND A1_LOJA = E1_LOJA "
	cQuery1+= " INNER JOIN(SELECT * FROM " + RetSqlName("SA3") + ")SA3 "
	cQuery1+= " ON SA3.D_E_L_E_T_ = ' ' "
	cQuery1+= " AND A3_COD = A1_VEND "
	cQuery1+= " AND A3_XCOMISS <> 0 "
	cQuery1+= " WHERE SE1.D_E_L_E_T_ = ' ' "
	cQuery1+= " AND E1_MOTIVO = 'NOR' "
	cQuery1+= " AND E1_TIPO IN ('FT','NF') "
	cQuery1+= " ORDER BY VENDEDOR,FACTURA  "	
	
	
	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery1),cAliasLif)

Return()
	
	
	
	
	
