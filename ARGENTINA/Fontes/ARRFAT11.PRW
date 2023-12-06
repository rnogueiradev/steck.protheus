#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "Rwmake.ch"
#INCLUDE "TopConn.ch"


/*/{Protheus.doc} ARRFAT11
(Relatório de Separacion Realizadas)

@author jefferson.carlos
@since 18/10/2019
@version 1.0
@return ${return}, ${return_description}

/*/

User Function ARRFAT11()
	
	Local   oReport
	Private cPerg 		:= "ARFAT11"
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



/*/{Protheus.doc} ARRFAT11
(Relatório de Separacion Realizadas)

@author jefferson.carlos
@since 18/10/2019
@version 1.0

/*/


Static Function ReportDef()
	
	Local oReport
	Local oSection
	
	oReport := TReport():New(cPergTit,"Informe de comisiones",cPerg,{|oReport| ReportPrint(oReport)},"Este programa imprimirá un informe de comisiones")
	
	Pergunte(cPerg,.T.)
	
	oSection := TRSection():New(oReport,"Informe de comisiones",{"MOV"})
	
	
	
	TRCell():New(oSection,"01",,"REMITO	"			,,12,.F.,)
	TRCell():New(oSection,"02",,"ORDEM SEP."		,,06,.F.,)
	TRCell():New(oSection,"03",,"FECHA" 			,,08,.F.,)
	TRCell():New(oSection,"04",,"HORA" 				,,08,.F.,)
	TRCell():New(oSection,"05",,"OPERADORES" 		,,30,.F.,)
	TRCell():New(oSection,"06",,"STATUS SEPARACION" ,,15,.F.,)
	
	
	
	oSection:SetHeaderSection(.t.)
	oSection:Setnofilter("MOV")
	
Return oReport


/*/{Protheus.doc} ARRFAT11
(Relatório de Separacion Realizadas)

@author jefferson.carlos
@since 18/10/2019
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
			
						
			aDados1[01]	:=  (cAliasLif)->REMITO
			aDados1[02]	:=  (cAliasLif)->ORDSEP
			aDados1[03]	:=  DTOC(STOD((cAliasLif)->FECHA))
			aDados1[04]	:=  (cAliasLif)->HORA
			aDados1[05]	:= 	(cAliasLif)->OPER
			aDados1[06]	:= 	(cAliasLif)->STATUS
					
			
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




/*/{Protheus.doc} ARRFAT11
(Gera Consulta no Banco de Dados)

@author jefferson.carlos
@since 18/10/2019
@version 1.0

/*/


Static Function StQuery(_ccod)


	Local cQuery1     := ' '
	
	
	cQuery1+= " SELECT ZP_DOC REMITO, ZP_ORDSEP ORDSEP, ZP_DATA FECHA, ZP_HORA HORA,ZP_USER OPER,"
	cQuery1+= " (CASE WHEN ZP_STATUS = '0' THEN 'Lib. para separação' "
	cQuery1+= " WHEN ZP_STATUS = '1' THEN 'Em separação' "
	cQuery1+= " WHEN ZP_STATUS = '2' THEN 'Sep. finalizada' "
	cQuery1+= " WHEN ZP_STATUS = '3' THEN 'Emb. Finalizada' "
	cQuery1+= " WHEN ZP_STATUS = '4' THEN 'Despachado' END) as status "
	cQuery1+= " FROM "+RetSqlName ("SZP")+ " SZP "
	cQuery1+= " WHERE D_E_L_E_T_=' ' "
	cQuery1+= " AND ZP_DATA BETWEEN '" + DTOS(MV_PAR01) + "' AND '" + DTOS(MV_PAR02) + "' "
	cQuery1+= " ORDER BY ZP_DOC,ZP_HORA "
	
	
	
	
	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery1),cAliasLif)

Return()
	
	
	
	
	
