#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "Rwmake.ch"
#INCLUDE "TopConn.ch"

/*/{Protheus.doc} RSTFATC3.PRW
(Relatório de Departamento Recursos Humanos)

@author jefferson.carlos
@since 06/11/2018
@version 1.0
@return ${return}, ${return_description}

/*/


User Function RSTFATC3()

Local   oReport
	Private cPerg 		:= "TFATC3"
	Private cTime        := Time()
	Private cHora        := SUBSTR(cTime, 1, 2)
	Private cMinutos    	:= SUBSTR(cTime, 4, 2)
	Private cSegundos   	:= SUBSTR(cTime, 7, 2)
	Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos
	Private lXlsHeader   := .F.
	Private lXmlEndRow   := .F.
	Private cPergTit 		:= cAliasLif
	
	
	
	
	U_STPutSx1( cPerg, "01","Departamento De ?" 			 	,"MV_PAR01","mv_ch1","C",09,0,"G",,"SQB"  		,"@!")
	U_STPutSx1( cPerg, "02","Departamento Até ?"				,"MV_PAR02","mv_ch2","C",09,0,"G",,"SQB"  		,"@!")
	
	
	oReport		:= ReportDef()
	oReport:PrintDialog()
	
Return

/*/{Protheus.doc} RSTFATC3
(Relatório de Departamento Recursos Humanos)

@author jefferson.carlos
@since 06/11/2018
@version 1.0

/*/


Static Function ReportDef()
	
	Local oReport
	Local oSection
	
	oReport := TReport():New(cPergTit,"Relatório de Departamento",cPerg,{|oReport| ReportPrint(oReport)},"Este programa fará a impressão dos Departamentos")
	
	Pergunte(cPerg,.T.)
	
	oSection := TRSection():New(oReport,"Relatório de Departamento",{"MOV"})
	
	
	
	TRCell():New(oSection,"01",,"FILIAL	"			,,02,.F.,)
	TRCell():New(oSection,"02",,"MATRICULA"			,,06,.F.,)
	TRCell():New(oSection,"03",,"NOME" 				,,30,.F.,)
	TRCell():New(oSection,"04",,"RG" 				,,12,.F.,)
	TRCell():New(oSection,"05",,"CPF" 				,,11,.F.,)
	TRCell():New(oSection,"06",,"SEXO"  			,,01,.F.,)
	TRCell():New(oSection,"07",,"DATA NASCIMENTO"	,,08,.F.,)
	TRCell():New(oSection,"08",,"MUNICIPIO" 	   	,,15,.F.,)
	TRCell():New(oSection,"09",,"ESTADO"			,,02,.F.,)
	TRCell():New(oSection,"10",,"ADMISSAO"			,,08,.F.,)
	TRCell():New(oSection,"11",,"CODIGO DEPARTAMENTO"	,,09,.F.,)
	TRCell():New(oSection,"12",,"DESCRICAO DEPARTAMENTO"	,,20,.F.,)
	TRCell():New(oSection,"13",,"CODIGO C.CUSTO"			,,06,.F.,)
	TRCell():New(oSection,"14",,"DESCRICAO C.CUSTO"			,,15,.F.,)
	
	
	
	
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
	oSection1:Cell("14") :SetBlock( { || aDados1[14] } )
	
	
	
	
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
			
						
			aDados1[01]	:=  (cAliasLif)->FILIAL
			aDados1[02]	:=  (cAliasLif)->MATRICULA
			aDados1[03]	:=  (cAliasLif)->NOME
			aDados1[04]	:=  (cAliasLif)->RG
			aDados1[05]	:= 	(cAliasLif)->CFP
			aDados1[06]	:= 	(cAliasLif)->SEXO
			aDados1[07]	:=  DTOC(STOD((cAliasLif)->DATA_NASC))			
			aDados1[08]	:= (cAliasLif)->MUNICIPIO
			aDados1[09]	:= 	(cAliasLif)->ESTADO
			aDados1[10]	:= DTOC(STOD((cAliasLif)->ADMISSAO))
			aDados1[11]	:= (cAliasLif)->COD_DEPTO
			aDados1[12]	:= (cAliasLif)->DESC_DEPTO
			aDados1[13]	:= (cAliasLif)->COD_CUSTO
			aDados1[14]	:= (cAliasLif)->DESC_CCUSTO
			
				
			
			
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
	
	cQuery1+= "	SELECT RA_FILIAL AS FILIAL, RA_MAT AS MATRICULA, RA_NOME AS NOME, RA_RG AS RG,RA_CIC AS CFP,RA_SEXO AS SEXO,RA_NASC AS DATA_NASC,RA_MUNICIP AS MUNICIPIO,"
	cQuery1+= " RA_ESTADO AS ESTADO,RA_ADMISSA AS ADMISSAO,RA_DEPTO AS COD_DEPTO,QB_DESCRIC AS DESC_DEPTO, CTT_CUSTO AS COD_CUSTO, "
	cQuery1+= " CTT_DESC01 AS DESC_CCUSTO, RA_SALARIO AS SAL "
	cQuery1+= " FROM "+RetSqlName("SRA")+" RA "
	cQuery1+= " LEFT JOIN " +RetSqlName("SQB")+" QB "
	cQuery1+= " ON QB_DEPTO=RA_DEPTO "
	cQuery1+= " INNER JOIN " +RetSqlName("CTT")+" TT "
	cQuery1+= " ON CTT_CUSTO=RA_CC "
	cQuery1+= " WHERE RA_SITFOLH=' ' "
	cQuery1+= " AND RA.D_E_L_E_T_=' ' "
	cQuery1+= " ORDER BY FILIAL "
	
	
	
	
	
	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery1),cAliasLif)

Return()
	
	
	
	
	

