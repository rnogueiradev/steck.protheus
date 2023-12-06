#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "Rwmake.ch"
#INCLUDE "TopConn.ch"

/*/{Protheus.doc} RSTFATCA.PRW
(Relatório de Horas Abonadas)

@author jefferson.carlos
@since 07/02/2019
@version 1.0
@return ${return}, ${return_description}

/*/


User Function RSTFATCA()

	Local   oReport
	Private cPerg 		:= " "
	Private cTime        := Time()
	Private cHora        := SUBSTR(cTime, 1, 2)
	Private cMinutos    	:= SUBSTR(cTime, 4, 2)
	Private cSegundos   	:= SUBSTR(cTime, 7, 2)
	Private cAliasLif   	:= cHora+ cMinutos+cSegundos
	Private lXlsHeader   := .F.
	Private lXmlEndRow   := .F.
	Private cPergTit 		:= cAliasLif
	
	
	//	U_STPutSx1( cPerg, "01","Departamento De ?" 			 	,"MV_PAR01","mv_ch1","C",09,0,"G",,"SQB"  		,"@!")
	//U_STPutSx1( cPerg, "02","Departamento Até ?"				,"MV_PAR02","mv_ch2","C",09,0,"G",,"SQB"  		,"@!")
	
	
	oReport		:= ReportDef()
	oReport:PrintDialog()
	
Return

/*/{Protheus.doc} RSTFATCA
(Relatório de Horas Abonadas)

@author jefferson.carlos
@since 07/02/2019
@version 1.0

/*/


Static Function ReportDef()
	
	Local oReport
	Local oSection
	
	oReport := TReport():New(cPergTit,"Relatório de Horas Abonadas", ,{|oReport| ReportPrint(oReport)},"Este programa fará a impressão dos Departamentos")
	
	
	
	
	oSection := TRSection():New(oReport,"Relatório de Horas Abonadas",{"MOV"})
	
	
	
	TRCell():New(oSection,"01",,"FILIAL	"			,,02,.F.,)
	TRCell():New(oSection,"02",,"MATRICULA"			,,06,.F.,)
	TRCell():New(oSection,"03",,"NOME" 				,,30,.F.,)
	TRCell():New(oSection,"04",,"DATA" 				,,08,.F.,)
	TRCell():New(oSection,"05",,"VERBA" 			,,03,.F.,)
	TRCell():New(oSection,"06",,"HORAS APONTADAS"  	,,04,.F.,)
	TRCell():New(oSection,"07",,"ABONO"	            ,,03,.F.,)
	TRCell():New(oSection,"08",,"DESC. ABONO" 	   	,,30,.F.,)
	TRCell():New(oSection,"09",,"HORAS ABONO"		,,04,.F.,)
	TRCell():New(oSection,"10",,"C.CUSTO"			,,08,.F.,)
	TRCell():New(oSection,"11",,"DESC.C.CUSTO"		,,30,.F.,)
	
	
	oSection:SetHeaderSection(.t.)
	oSection:Setnofilter("MOV")
	
Return oReport


/*/{Protheus.doc} RSTFATCA
(Relatório de Horas Abonadas)

@author jefferson.carlos
@since 07/02/2019
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
	
	
	
	
	
	oReport:SetTitle("MOV")// Titulo do relatório
	
	oReport:SetMeter(0)
	aFill(aDados,nil)
	aFill(aDados1,nil)
	oSection:Init()
	
	
	Processa({|| StQuery(  ) },"Compondo Relatorio")
	
	DbSelectArea(cAliasLif)
	(cAliasLif)->(DbGoTop())
	If  Select(cAliasLif) > 0
		
		While 	(cAliasLif)->(!Eof())
			
						
			aDados1[01]	:=  (cAliasLif)->FILIAL
			aDados1[02]	:=  (cAliasLif)->MATRICULA
			aDados1[03]	:=  (cAliasLif)->NOME
			aDados1[04]	:=  DTOC(STOD((cAliasLif)->DATA))
			aDados1[05]	:= 	(cAliasLif)->COD_VERBA
			aDados1[06]	:= 	(cAliasLif)->HORAS_APONT
			aDados1[07]	:=  (cAliasLif)->COD_ABONO
			aDados1[08]	:= (cAliasLif)->DESC_ABONO
			aDados1[09]	:= 	(cAliasLif)->HORAS_ABONO
			aDados1[10]	:= (cAliasLif)->CC
			aDados1[11]	:= (cAliasLif)->DESC_CC
			
				
			
			
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




/*/{Protheus.doc} RSTFATCA.PRW
(Gera Consulta no Banco de Dados)

@author jefferson.carlos
@since 07/02/2019
@version 1.0

/*/


Static Function StQuery(_ccod)


	Local cQuery1     := ' '
	
	
	
	cQuery1+= " SELECT RA_FILIAL AS FILIAL,PC_MAT AS Matricula,RA_NOME AS Nome,SUBSTR(PC_DATA,7,8)|| '/'|| SUBSTR(PC_DATA,5,2)|| '/'|| SUBSTR(PC_DATA,1,4) AS DATA,PC_PD AS Cod_Verba,PC_QUANTC AS Horas_Apont,"
	cQuery1+= " PC_ABONO AS Cod_Abono,P6_Desc AS Desc_Abono,PC_QTABONO AS Horas_Abono,PC_CC AS CC,CTT_DESC01 AS Desc_CC "
	cQuery1+= " FROM "+RetSqlName("SPC")+" SPC "
	cQuery1+= " INNER JOIN "+RetSqlName("SRA")+" SRA"
	cQuery1+= " ON RA_FILIAL=PC_FILIAL "
	cQuery1+= " AND RA_MAT=PC_MAT "
	cQuery1+= " INNER JOIN " +RetSqlName("CTT")+" CTT "
	cQuery1+= " ON CTT_CUSTO=PC_CC "
	cQuery1+= " INNER JOIN " +RetSqlName("SRV")+" SRV "
	cQuery1+= " ON RV_COD=PC_PD "
	cQuery1+= " INNER JOIN " +RetSqlName("SP6")+ " SP6 "
	cQuery1+= " ON P6_CODIGO=PC_ABONO "
	cQuery1+= " WHERE PC_ABONO <> ' ' "
	cQuery1+= " ORDER BY RA_FILIAL,RA_MAT "
	
	
	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery1),cAliasLif)

Return()
	
	
	
	