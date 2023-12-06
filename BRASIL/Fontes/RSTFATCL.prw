#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  RSTFATCL     ºAutor  ³Giovani Zago    º Data ³  27/08/19     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Relatorio  Analise de verbas RH		                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RSTFATCL()

	Local   oReport
	Private cPerg 			:= "RFATCL"
	Private cTime           := Time()
	Private cHora           := SUBSTR(cTime, 1, 2)
	Private cMinutos    	:= SUBSTR(cTime, 4, 2)
	Private cSegundos   	:= SUBSTR(cTime, 7, 2)
	Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos
	Private lXlsHeader      := .f.
	Private lXmlEndRow      := .f.
	Private cPergTit 		:= cAliasLif

	U_STPutSx1( cPerg, "01","Data 01?" 		   			,"MV_PAR01","mv_ch1","D",08,0,"G",,""  		,"@!")
	U_STPutSx1( cPerg, "02","Data 02?"					,"MV_PAR02","mv_ch2","D",08,0,"G",,""  		,"@!")
	U_STPutSx1( cPerg, "03","Verba?"					,"MV_PAR03","mv_ch3","C",03,0,"G",,"SRV"  	,"@!")
	U_STPutSx1( cPerg, "04","Filial?"					,"MV_PAR04","mv_ch4","C",02,0,"G",,""  		,"@!")



	If ! (__cuserid $ GetMv("ST_FATCK",,'000975')+'/000000/000645')
		MsgInfo("Usuario sem acesso, RSTFATCL ")
		Return()
	EndIf


	oReport		:= ReportDef()

	oReport:PrintDialog()

Return

Static Function ReportDef()

	Local oReport
	Local oSection

	oReport := TReport():New(cPergTit,"RELATÓRIO Variação de Verbas RH - "+ Iif(cempant='01','São Paulo','Manaus'),cPerg,{|oReport| ReportPrint(oReport)},"Este programa irá imprimir um relatório de Analise de Verbas RH.")

	Pergunte(cPerg,.F.)

	oSection := TRSection():New(oReport,"Variação de Verbas RH - "+ Iif(cempant='01','São Paulo','Manaus'),{"SC5"})


	TRCell():New(oSection,"FILIAL"	  	,,"FILIAL"		,,2,.F.,)
	TRCell():New(oSection,"MATRICULA"	,,"MATRICULA"	,,6,.F.,)
	TRCell():New(oSection,"NOME"	  	,,"NOME"		,,25,.F.,)
	TRCell():New(oSection,"ADMISSAO"	,,"ADMISSAO  ."	,,11,.F.,)
	TRCell():New(oSection,"DEMISSAO"	,,"DEMISSAO  ."	,,11,.F.,)
	TRCell():New(oSection,"CC"			,,"CC"			,,8,.F.,)
	TRCell():New(oSection,"DESC_CC"	  	,,"DESC_CC"		,,35,.F.,)
	TRCell():New(oSection,"VERBA"	    ,,"VERBA"		,,6,.F.,)
	TRCell():New(oSection,"DESC_VERBA"	,,"DESC."	    ,,25,.F.,) 
	oSection:SetHeaderSection(.t.)
	oSection:Setnofilter("SRA")

 

Return oReport

Static Function ReportPrint(oReport)

	Local oSection	:= oReport:Section(1)
	Local oSection1	:= oReport:Section(1)
	Local nT1		:= 0
	Local nT2		:= 0
	Local cQuery 	:= ""
	Local aDados[2]
	Local aDados1[99]

	TRCell():New(oSection,"DATA_01"  	,, SUBSTR(MesExtenso(MV_PAR01),1,5)+'/'+Substr(dTos(MV_PAR01),1,4)	,"@E 99,999,999.99",14)
	TRCell():New(oSection,"DATA_02"  	,, SUBSTR(MesExtenso(MV_PAR02),1,5)+'/'+Substr(dTos(MV_PAR02),1,4)	,"@E 99,999,999.99",14)
	TRCell():New(oSection,"VARIACAO"  	,,"VARIACAO","@E 99,999,999.99",14)


	oSection1:Cell("FILIAL")       	:SetBlock( { || aDados1[01] } )
	oSection1:Cell("MATRICULA")	  	:SetBlock( { || aDados1[02] } )
	oSection1:Cell("NOME")  	  	:SetBlock( { || aDados1[03] } ) 
	oSection1:Cell("ADMISSAO")      :SetBlock( { || aDados1[04] } )
	oSection1:Cell("DEMISSAO")	  	:SetBlock( { || aDados1[05] } )
	oSection1:Cell("CC")  	  		:SetBlock( { || aDados1[06] } ) 
	oSection1:Cell("DESC_CC")       :SetBlock( { || aDados1[07] } )
	oSection1:Cell("VERBA")	  		:SetBlock( { || aDados1[08] } )
	oSection1:Cell("DESC_VERBA")  	:SetBlock( { || aDados1[09] } ) 
	oSection1:Cell("DATA_01")       :SetBlock( { || aDados1[10] } )
	oSection1:Cell("DATA_02")	  	:SetBlock( { || aDados1[11] } )
	oSection1:Cell("VARIACAO")  	:SetBlock( { || aDados1[12] } ) 

	oSection1:Cell("FILIAL")	:SetBorder("TOP",,,)
	oSection1:Cell("MATRICULA")	:SetBorder("TOP",,,)
	oSection1:Cell("NOME")		:SetBorder("TOP",,,)
	oSection1:Cell("ADMISSAO")	:SetBorder("TOP",,,)
	oSection1:Cell("DEMISSAO")	:SetBorder("TOP",,,)
	oSection1:Cell("CC")		:SetBorder("TOP",,,)
	oSection1:Cell("DESC_CC")	:SetBorder("TOP",,,)
	oSection1:Cell("VERBA")		:SetBorder("TOP",,,)
	oSection1:Cell("DESC_VERBA"):SetBorder("TOP",,,)
	oSection1:Cell("DATA_01")	:SetBorder("TOP",,,)
	oSection1:Cell("DATA_02")	:SetBorder("TOP",,,)
	oSection1:Cell("VARIACAO")	:SetBorder("TOP",,,)

	/*
	oSection1:Cell("FILIAL")	:SetBorder("ALL",,,.T.)
	oSection1:Cell("MATRICULA")	:SetBorder("ALL",,,.T.)
	oSection1:Cell("NOME")		:SetBorder("ALL",,,.T.)
	oSection1:Cell("ADMISSAO")	:SetBorder("ALL",,,.T.)
	oSection1:Cell("DEMISSAO")	:SetBorder("ALL",,,.T.)
	oSection1:Cell("CC")		:SetBorder("ALL",,,.T.)
	oSection1:Cell("DESC_CC")	:SetBorder("ALL",,,.T.)
	oSection1:Cell("VERBA")		:SetBorder("ALL",,,.T.)
	oSection1:Cell("DESC_VERBA"):SetBorder("ALL",,,.T.)
	oSection1:Cell("DATA_01")	:SetBorder("ALL",,,.T.)
	oSection1:Cell("DATA_02")	:SetBorder("ALL",,,.T.)
	oSection1:Cell("VARIACAO")	:SetBorder("ALL",,,.T.)
	*/
	//U_RSTFATCL()                                                                                                                                                                                                                                                                                                                                                                                                    
	//oSection := TRCell():SetBorder( 5 , 5 ,   ,   )  
	//oSection1 := TRCell():SetBorder( 5 , 5 ,   ,   )  

	oReport:SetTitle("Variação de Verbas RH - "+ Iif(cempant='01','São Paulo','Manaus'))// Titulo do relatório

	oReport:SetMeter(0)
	aFill(aDados,nil)
	aFill(aDados1,nil)
	oSection:Init()




	Processa({|| StQuery( ) },"Compondo Relatorio")




	dbSelectArea(cAliasLif)
	(cAliasLif)->(dbgotop())
	If  Select(cAliasLif) > 0

		While 	(cAliasLif)->(!Eof())
			If ((cAliasLif)->SRD_ANTERIOR+(cAliasLif)->SRD_ATUAL+(cAliasLif)->SRC_ATUAL) > 0

				aDados1[01]	:= 	(cAliasLif)->RA_FILIAL
				aDados1[02]	:=  Alltrim((cAliasLif)->RA_MAT)
				aDados1[03]	:=	Alltrim((cAliasLif)->RA_NOME)
				aDados1[04]	:= 	Dtoc(Stod((cAliasLif)->RA_ADMISSA))
				aDados1[05]	:=  Dtoc(Stod((cAliasLif)->RA_DEMISSA))
				aDados1[06]	:=	(cAliasLif)->RA_CC
				aDados1[07]	:= 	(cAliasLif)->CC
				aDados1[08]	:=  Alltrim(MV_PAR03)
				aDados1[09]	:=	aLLTRIM((cAliasLif)->DESCRICAO)
				aDados1[10]	:= 	(cAliasLif)->SRD_ANTERIOR
				If (cAliasLif)->SRC_ATUAL >0 
					aDados1[11]	:=  (cAliasLif)->SRC_ATUAL
				Else
					aDados1[11]	:=  (cAliasLif)->SRD_ATUAL
				EndIf
				aDados1[12]	:=	aDados1[11]-aDados1[10]
				nT1+= aDados1[10]
				nT2+= aDados1[11]



				oSection1:PrintLine()
				aFill(aDados1,nil)
			EndIf
			(cAliasLif)->(dbskip())

		End

		If nT1>0 .Or. nT2>0
			aDados1[09]	:= 'TOTAL:'
			aDados1[10]	:= nT1
			aDados1[11]	:= nT2
			aDados1[12]	:= aDados1[11]-aDados1[10]

			oSection1:PrintLine()
			aFill(aDados1,nil)
		EndIf
		oSection1:PrintLine()
		aFill(aDados1,nil)
		oSection1:PrintLine()
		aFill(aDados1,nil)
		oSection1:PrintLine()
		aFill(aDados1,nil)
		aDados1[01]	:= 'Ass.:'
		oSection1:PrintLine()
		aFill(aDados1,nil)

		aDados1[01]	:= 'Data:'
		oSection1:PrintLine()
		aFill(aDados1,nil)

		aDados1[01]	:= ' '
		oSection1:PrintLine()
		aFill(aDados1,nil)

	EndIf



	oReport:SkipLine()




Return oReport



Static Function StQuery()

	Local cQuery      := ' '


	cQuery := " SELECT  RA_FILIAL,RA_MAT,RA_NOME,RA_ADMISSA,RA_DEMISSA,RA_CC, NVL(CTT_DESC01,' ') AS CC,
	cQuery += " NVL((SELECT TRIM(RV_DESC) FROM "+RetSqlName("SRV")+" SRV
	cQuery += " WHERE SRV.D_E_L_E_T_ =  ' '
	cQuery += " AND RV_FILIAL = ' ' 
	cQuery += " AND RV_COD =  '" +   MV_PAR03  + "'
	cQuery += " ),' ') AS DESCRICAO,
	cQuery += " NVL((SELECT RD_VALOR FROM "+RetSqlName("SRD")+" SRD
	cQuery += " WHERE SRD.D_E_L_E_T_ = ' ' 
	cQuery += " AND RD_FILIAL = SRA.RA_FILIAL
	cQuery += " AND RD_MAT = SRA.RA_MAT
	cQuery += " AND RD_PD = '" +   MV_PAR03  + "'
	cQuery += " AND SUBSTR(RD_DATPGT,1,6) = '" + Substr(dTos(MV_PAR01),1,6) + "'),0) AS  SRD_ANTERIOR ,

	cQuery += " NVL((SELECT RD_VALOR FROM "+RetSqlName("SRD")+" SRD
	cQuery += " WHERE SRD.D_E_L_E_T_ = ' ' 
	cQuery += " AND RD_FILIAL = SRA.RA_FILIAL
	cQuery += " AND RD_MAT = SRA.RA_MAT
	cQuery += " AND RD_PD = '" +   MV_PAR03  + "'
	cQuery += " AND SUBSTR(RD_DATPGT,1,6) = '" + Substr(dTos(MV_PAR02),1,6) + "'),0) AS  SRD_ATUAL ,

	cQuery += " NVL((SELECT RC_VALOR FROM "+RetSqlName("SRC")+" SRC
	cQuery += " WHERE SRC.D_E_L_E_T_ = ' ' 
	cQuery += " AND RC_FILIAL = SRA.RA_FILIAL
	cQuery += " AND RC_MAT = SRA.RA_MAT
	cQuery += " AND RC_PD = '" +   MV_PAR03  + "'
	cQuery += " AND SUBSTR(RC_DATA,1,6) = '" + Substr(dTos(MV_PAR02),1,6) + "'),0) AS  SRC_ATUAL 

	cQuery += " FROM "+RetSqlName("SRA")+" SRA

	cQuery += " LEFT JOIN(SELECT * FROM "+RetSqlName("CTT")+")CTT
	cQuery += " ON CTT.D_E_L_E_T_ = ' '
	cQuery += " AND CTT_CUSTO = RA_CC


	cQuery += " WHERE SRA.D_E_L_E_T_ = ' ' 
	If !(Empty(Alltrim(MV_PAR04)))
		cQuery += " AND RA_FILIAL = '" +   MV_PAR04  + "'
	EndIf


	cQuery += " ORDER BY RA_FILIAL,RA_NOME


	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

Return()

