#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  RSTFATCM     ºAutor  ³Giovani Zago    º Data ³  27/08/19     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Relatorio  Analise de verbas RH		                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RSTFATCM()


	Local   oReport
	Private cPerg 			:= "RFATCM"
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
	//U_STPutSx1( cPerg, "03","Verba?"					,"MV_PAR03","mv_ch3","C",03,0,"G",,"SRV"  	,"@!")
	//U_STPutSx1( cPerg, "04","Filial?"					,"MV_PAR04","mv_ch4","C",02,0,"G",,""  		,"@!")



	If ! (__cuserid $ GetMv("ST_FATCK",,'000975')+'/000000/000645')
		MsgInfo("Usuario sem acesso, RSTFATCM ")
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

	oSection := TRSection():New(oReport,"PROVENTOS - "+ Iif(cempant='01','São Paulo','Manaus'),{"SC5"})
	TRCell():New(oSection,"VERBA"	    ,,"VERBA"		,,6,.F.,)
	TRCell():New(oSection,"DESC_VERBA"	,,"DESC."	    ,,25,.F.,) 

	oSection1 := TRSection():New(oReport,"DESCONTOS - "+ Iif(cempant='01','São Paulo','Manaus'),{"SC5"})
	TRCell():New(oSection1,"VERBA"	    ,,"VERBA"		,,6,.F.,)
	TRCell():New(oSection1,"DESC_VERBA"	,,"DESC."	    ,,25,.F.,) 

	oSection2 := TRSection():New(oReport,"BASES - "+ Iif(cempant='01','São Paulo','Manaus'),{"SC5"})
	TRCell():New(oSection2,"VERBA"	    ,,"VERBA"		,,6,.F.,)
	TRCell():New(oSection2,"DESC_VERBA"	,,"DESC."	    ,,25,.F.,)
	//TRCell():New(oSection2,"VARIACAOH"  ,,"V.HORA","@E 99,999,999.99",14) 


	oSection:SetHeaderSection(.t.)
	oSection:Setnofilter("SRA")
	oSection1:SetHeaderSection(.t.)
	oSection1:Setnofilter("SRA")
	oSection2:SetHeaderSection(.t.)
	oSection2:Setnofilter("SRA")


Return oReport

Static Function ReportPrint(oReport)

	Local oSection	:= oReport:Section(1)
	Local oSection1	:= oReport:Section(2)
	Local oSection2	:= oReport:Section(3)
	Local n001		:= 0
	Local n002		:= 0
	Local n003		:= 0
	Local n004		:= 0
	Local n101		:= 0
	Local n102		:= 0
	Local n103		:= 0
	Local n104		:= 0
	Local n201		:= 0
	Local n202		:= 0
	Local n203		:= 0
	Local n204		:= 0
	Local aDados [99]
	Local aDados1[99]
	Local aDados2[99]

	TRCell():New(oSection,"DATA_010"  	,, 'H/'+SUBSTR(MesExtenso(MV_PAR01),1,5)+'/'+Substr(dTos(MV_PAR01),1,4)	,"@E 99,999,999.99",14)
	TRCell():New(oSection,"DATA_011"  	,, 'V/'+SUBSTR(MesExtenso(MV_PAR01),1,5)+'/'+Substr(dTos(MV_PAR01),1,4)	,"@E 99,999,999.99",14)
	TRCell():New(oSection,"DATA_020"  	,, 'H/'+SUBSTR(MesExtenso(MV_PAR02),1,5)+'/'+Substr(dTos(MV_PAR02),1,4)	,"@E 99,999,999.99",14)
	TRCell():New(oSection,"DATA_021"  	,, 'V/'+SUBSTR(MesExtenso(MV_PAR02),1,5)+'/'+Substr(dTos(MV_PAR02),1,4)	,"@E 99,999,999.99",14)
	TRCell():New(oSection,"VARIACAOH"  	,,"V.HORA","@E 99,999,999.99",14)
	TRCell():New(oSection,"VARIACAOV"  	,,"V.VALOR","@E 99,999,999.99",14)

	TRCell():New(oSection1,"DATA_010"  	,, 'H/'+SUBSTR(MesExtenso(MV_PAR01),1,5)+'/'+Substr(dTos(MV_PAR01),1,4)	,"@E 99,999,999.99",14)
	TRCell():New(oSection1,"DATA_011"  	,, 'V/'+SUBSTR(MesExtenso(MV_PAR01),1,5)+'/'+Substr(dTos(MV_PAR01),1,4)	,"@E 99,999,999.99",14)
	TRCell():New(oSection1,"DATA_020"  	,, 'H/'+SUBSTR(MesExtenso(MV_PAR02),1,5)+'/'+Substr(dTos(MV_PAR02),1,4)	,"@E 99,999,999.99",14)
	TRCell():New(oSection1,"DATA_021"  	,, 'V/'+SUBSTR(MesExtenso(MV_PAR02),1,5)+'/'+Substr(dTos(MV_PAR02),1,4)	,"@E 99,999,999.99",14)
	TRCell():New(oSection1,"VARIACAOH"  ,,"V.HORA","@E 99,999,999.99",14)
	TRCell():New(oSection1,"VARIACAOV"  ,,"V.VALOR","@E 99,999,999.99",14)

	//TRCell():New(oSection2,"DATA_010"  	,, 'H/'+SUBSTR(MesExtenso(MV_PAR01),1,5)+'/'+Substr(dTos(MV_PAR01),1,4)	,"@E 99,999,999.99",14)
	TRCell():New(oSection2,"DATA_011"  	,, 'V/'+SUBSTR(MesExtenso(MV_PAR01),1,5)+'/'+Substr(dTos(MV_PAR01),1,4)	,"@E 99,999,999.99",14)
	//TRCell():New(oSection2,"DATA_020"  	,, 'H/'+SUBSTR(MesExtenso(MV_PAR02),1,5)+'/'+Substr(dTos(MV_PAR02),1,4)	,"@E 99,999,999.99",14)
	TRCell():New(oSection2,"DATA_021"  	,, 'V/'+SUBSTR(MesExtenso(MV_PAR02),1,5)+'/'+Substr(dTos(MV_PAR02),1,4)	,"@E 99,999,999.99",14)
	TRCell():New(oSection2,"VARIACAOV"  ,,"V.VALOR","@E 99,999,999.99",14)



	oSection:Cell("VERBA")      :SetBlock( { || aDados[01] } )
	oSection:Cell("DESC_VERBA")	:SetBlock( { || aDados[02] } )
	oSection:Cell("DATA_010")  	:SetBlock( { || aDados[03] } ) 
	oSection:Cell("DATA_011")   :SetBlock( { || aDados[04] } )
	oSection:Cell("DATA_020")	:SetBlock( { || aDados[05] } )
	oSection:Cell("DATA_021")  	:SetBlock( { || aDados[06] } ) 
	oSection:Cell("VARIACAOH")  :SetBlock( { || aDados[07] } )
	oSection:Cell("VARIACAOV")	:SetBlock( { || aDados[08] } )

	oSection1:Cell("VERBA")      :SetBlock( { || aDados1[01] } )
	oSection1:Cell("DESC_VERBA") :SetBlock( { || aDados1[02] } )
	oSection1:Cell("DATA_010")   :SetBlock( { || aDados1[03] } ) 
	oSection1:Cell("DATA_011")   :SetBlock( { || aDados1[04] } )
	oSection1:Cell("DATA_020")	 :SetBlock( { || aDados1[05] } )
	oSection1:Cell("DATA_021")   :SetBlock( { || aDados1[06] } ) 
	oSection1:Cell("VARIACAOH")  :SetBlock( { || aDados1[07] } )
	oSection1:Cell("VARIACAOV")	 :SetBlock( { || aDados1[08] } )

	oSection2:Cell("VERBA")      :SetBlock( { || aDados2[01] } )
	oSection2:Cell("DESC_VERBA") :SetBlock( { || aDados2[02] } )
	//oSection2:Cell("DATA_010")   :SetBlock( { || aDados2[03] } ) 
	oSection2:Cell("DATA_011")   :SetBlock( { || aDados2[04] } )
	//oSection2:Cell("DATA_020")	 :SetBlock( { || aDados2[05] } )
	oSection2:Cell("DATA_021")   :SetBlock( { || aDados2[06] } ) 
	//oSection2:Cell("VARIACAOH")  :SetBlock( { || aDados2[07] } )
	oSection2:Cell("VARIACAOV")	 :SetBlock( { || aDados2[08] } )

	oSection:Cell("VERBA")			:SetBorder("TOP",,,)
	oSection:Cell("DESC_VERBA")		:SetBorder("TOP",,,)
	oSection:Cell("DATA_010")		:SetBorder("TOP",,,)
	oSection:Cell("DATA_011")		:SetBorder("TOP",,,)
	oSection:Cell("DATA_020")		:SetBorder("TOP",,,)
	oSection:Cell("DATA_021")		:SetBorder("TOP",,,)
	oSection:Cell("VARIACAOH")		:SetBorder("TOP",,,)
	oSection:Cell("VARIACAOV")		:SetBorder("TOP",,,)

	oSection1:Cell("VERBA")			:SetBorder("TOP",,,)
	oSection1:Cell("DESC_VERBA")	:SetBorder("TOP",,,)
	oSection1:Cell("DATA_010")		:SetBorder("TOP",,,)
	oSection1:Cell("DATA_011")		:SetBorder("TOP",,,)
	oSection1:Cell("DATA_020")		:SetBorder("TOP",,,)
	oSection1:Cell("DATA_021")		:SetBorder("TOP",,,)
	oSection1:Cell("VARIACAOH")		:SetBorder("TOP",,,)
	oSection1:Cell("VARIACAOV")		:SetBorder("TOP",,,)

	oSection2:Cell("VERBA")			:SetBorder("TOP",,,)
	oSection2:Cell("DESC_VERBA")	:SetBorder("TOP",,,)
	//oSection2:Cell("DATA_010")		:SetBorder("TOP",,,)
	oSection2:Cell("DATA_011")		:SetBorder("TOP",,,)
	//oSection2:Cell("DATA_020")		:SetBorder("TOP",,,)
	oSection2:Cell("DATA_021")		:SetBorder("TOP",,,)
	//oSection2:Cell("VARIACAOH")		:SetBorder("TOP",,,)
	oSection2:Cell("VARIACAOV")		:SetBorder("TOP",,,)


	oReport:SetTitle("Variação de Verbas RH - "+ Iif(cempant='01','São Paulo','Manaus'))// Titulo do relatório

	oReport:SetMeter(0)

	aFill(aDados,nil)
	oSection:Init()


	aFill(aDados1,nil)
	oSection1:Init()

	aFill(aDados2,nil)
	oSection2:Init()

	Processa({|| StQuery( ) },"Compondo Relatorio...")

	dbSelectArea(cAliasLif)
	(cAliasLif)->(dbgotop())
	If  Select(cAliasLif) > 0

		While 	(cAliasLif)->(!Eof())
			If ((cAliasLif)->SRD_ANTERIOR+(cAliasLif)->SRD_ATUAL+(cAliasLif)->SRC_ATUAL) > 0

				If (cAliasLif)->RV_TIPOCOD = '1'
					aDados[01]	:= 	(cAliasLif)->RV_COD
					aDados[02]	:=  Alltrim((cAliasLif)->RV_DESC)
					aDados[03]	:=	(cAliasLif)->SRD_ANT_HR
					aDados[04]	:= 	(cAliasLif)->SRD_ANTERIOR
					If (cAliasLif)->SRC_ATUAL >0 
						aDados[05]	:=  (cAliasLif)->SRC_ATUAL_HR
						aDados[06]	:=	(cAliasLif)->SRC_ATUAL
					Else
						aDados[05]	:=  (cAliasLif)->SRD_ATUAL_HR
						aDados[06]	:=	(cAliasLif)->SRD_ATUAL
					EndIf

					aDados[07]	:= 	aDados[03]-aDados[05]
					aDados[08]	:=  aDados[04]-aDados[06]

					n001+= aDados[3]
					n002+= aDados[4]
					n003+= aDados[5]
					n004+= aDados[6]


					oSection:PrintLine()
					aFill(aDados,nil)
				ElseIf (cAliasLif)->RV_TIPOCOD = '2'
					aDados1[01]	:= 	(cAliasLif)->RV_COD
					aDados1[02]	:=  Alltrim((cAliasLif)->RV_DESC)
					aDados1[03]	:=	(cAliasLif)->SRD_ANT_HR
					aDados1[04]	:= 	(cAliasLif)->SRD_ANTERIOR
					If (cAliasLif)->SRC_ATUAL >0 
						aDados1[05]	:=  (cAliasLif)->SRC_ATUAL_HR
						aDados1[06]	:=	(cAliasLif)->SRC_ATUAL
					Else
						aDados1[05]	:=  (cAliasLif)->SRD_ATUAL_HR
						aDados1[06]	:=	(cAliasLif)->SRD_ATUAL
					EndIf

					aDados1[07]	:= 	aDados1[03]-aDados1[05]
					aDados1[08]	:=  aDados1[04]-aDados1[06]

					n101+= aDados1[3]
					n102+= aDados1[4]
					n103+= aDados1[5]
					n104+= aDados1[6]

					oSection1:PrintLine()
					aFill(aDados1,nil)
				Else 
					aDados2[01]	:= 	(cAliasLif)->RV_COD
					aDados2[02]	:=  Alltrim((cAliasLif)->RV_DESC)
					aDados2[03]	:=	0
					aDados2[04]	:= 	(cAliasLif)->SRD_ANTERIOR
					If (cAliasLif)->SRC_ATUAL >0 
						aDados2[05]	:=  0
						aDados2[06]	:=	(cAliasLif)->SRC_ATUAL
					Else
						aDados2[05]	:=  (cAliasLif)->SRD_ATUAL_HR
						aDados2[06]	:=	(cAliasLif)->SRD_ATUAL
					EndIf

					aDados2[07]	:= 	aDados2[03]-aDados2[05]
					aDados2[08]	:=  aDados2[04]-aDados2[06]

					n201+= aDados2[3]
					n202+= aDados2[4]
					n203+= aDados2[5]
					n204+= aDados2[6]
				
					oSection2:PrintLine()
					aFill(aDados2,nil)
				EndIf			

			EndIf
			(cAliasLif)->(dbskip())

		End

		If n002>0 .Or. n004>0
			aDados[02]	:= 'TOTAL:'
			aDados[03]	:= n001
			aDados[04]	:= n002
			aDados[05]	:= n003
			aDados[06]	:= n004
			aDados[07]	:= aDados[03]-aDados[05]
			aDados[08]	:= aDados[04]-aDados[06]

			oSection:PrintLine()
			aFill(aDados,nil)

			aDados[01]	:= 'Ass.:'
			oSection:PrintLine()
			aFill(aDados,nil)

			aDados[01]	:= 'Data:'
			oSection:PrintLine()
			aFill(aDados,nil)
		EndIf



		If n102>0 .Or. n104>0
			aDados1[02]	:= 'TOTAL:'
			aDados1[03]	:= n101
			aDados1[04]	:= n102
			aDados1[05]	:= n103
			aDados1[06]	:= n104
			aDados1[07]	:= aDados1[03]-aDados1[05]
			aDados1[08]	:= aDados1[04]-aDados1[06]

			oSection1:PrintLine()
			aFill(aDados1,nil)

			aDados1[01]	:= 'Ass.:'
			oSection1:PrintLine()
			aFill(aDados1,nil)

			aDados1[01]	:= 'Data:'
			oSection1:PrintLine()
			aFill(aDados1,nil)
		EndIf	

		If n202>0 .Or. n204>0
			aDados2[02]	:= 'TOTAL:'
			aDados2[03]	:= n201
			aDados2[04]	:= n202
			aDados2[05]	:= n203
			aDados2[06]	:= n204
			aDados2[07]	:= aDados2[03]-aDados2[05]
			aDados2[08]	:= aDados2[04]-aDados2[06]

			oSection1:PrintLine()
			aFill(aDados2,nil)

			aDados2[01]	:= 'Ass.:'
			oSection1:PrintLine()
			aFill(aDados2,nil)

			aDados2[01]	:= 'Data:'
			oSection1:PrintLine()
			aFill(aDados2,nil)
		EndIf	

	EndIf
	oReport:SkipLine()

Return oReport

Static Function StQuery()

	Local cQuery      := ' '
	
	cQuery := " SELECT * "
	cQuery += " FROM   	( "
    cQuery += "             SELECT	'SRD_ANT_HR' AS BASE ,
    cQuery += "                     SRV.RV_COD,
    cQuery += "                     SRV.RV_DESC,
    cQuery += "                     SRV.RV_TIPOCOD,
    cQuery += "                     Sum(RD_HORAS) SALDO
    cQuery += "             FROM "+RetSqlName("SRD")+" SRD
    cQuery += "             	LEFT JOIN "+RetSqlName("SRV")+" SRV
    cQuery += "             		ON SRV.RV_FILIAL = '"+xFilial("SRV")+"'
    cQuery += "             			AND SRV.RV_COD = SRD.RD_PD
    cQuery += "             			AND SRV.D_E_L_E_T_ = ' '
    cQuery += "             WHERE	SRD.D_E_L_E_T_ = ' '
    cQuery += "             		AND SRD.RD_PERIODO = '" + Substr(dTos(MV_PAR01),1,6) + "'
    cQuery += "             		AND SRD.RD_ROTEIR = 'FOL'
    cQuery += "             GROUP BY  SRV.RV_COD, SRV.RV_DESC, SRV.RV_TIPOCOD

    cQuery += "             UNION

    cQuery += "             SELECT	'SRD_ANTERIOR' AS BASE ,
    cQuery += "                     RV_COD,
    cQuery += "                     SRV.RV_DESC,
    cQuery += "                     SRV.RV_TIPOCOD,
    cQuery += "                     Sum(RD_VALOR) SALDO
    cQuery += "             FROM "+RetSqlName("SRD")+" SRD
    cQuery += "             	LEFT JOIN "+RetSqlName("SRV")+" SRV
    cQuery += "             		ON SRV.RV_FILIAL = '"+xFilial("SRV")+"'
    cQuery += "             			AND SRV.RV_COD = SRD.RD_PD
    cQuery += "             			AND SRV.D_E_L_E_T_ = ' '
    cQuery += "             WHERE	SRD.D_E_L_E_T_ = ' '
    cQuery += "             		AND SRD.RD_PERIODO = '" + Substr(dTos(MV_PAR01),1,6) + "'
	cQuery += "             		AND SRD.RD_ROTEIR = 'FOL'
    cQuery += "             GROUP BY  SRV.RV_COD, SRV.RV_DESC, SRV.RV_TIPOCOD

    cQuery += "             UNION

    cQuery += "             SELECT	'SRD_ATUAL_HR' AS BASE,
   	cQuery += "                     SRV.RV_COD,
    cQuery += "                     SRV.RV_DESC,
    cQuery += "                     SRV.RV_TIPOCOD,
    cQuery += "                     Sum(RD_HORAS) SALDO
    cQuery += "             FROM "+RetSqlName("SRD")+" SRD
    cQuery += "             	LEFT JOIN "+RetSqlName("SRV")+" SRV
    cQuery += "             		ON SRV.RV_FILIAL = '"+xFilial("SRV")+"'
    cQuery += "             			AND SRV.RV_COD = SRD.RD_PD
    cQuery += "             			AND SRV.D_E_L_E_T_ = ' '
    cQuery += "             WHERE 	SRD.D_E_L_E_T_ = ' '
    cQuery += "             		AND SRD.RD_PERIODO = '" + Substr(dTos(MV_PAR02),1,6) + "'
	cQuery += "             		AND SRD.RD_ROTEIR = 'FOL'
    cQuery += "             GROUP BY  SRV.RV_COD, SRV.RV_DESC, SRV.RV_TIPOCOD

    cQuery += "             UNION

    cQuery += "             SELECT	'SRD_ATUAL' AS BASE,
    cQuery += "                     SRV.RV_COD,
    cQuery += "                     SRV.RV_DESC,
    cQuery += "                     SRV.RV_TIPOCOD,
    cQuery += "                     Sum(RD_VALOR) SALDO
    cQuery += "             FROM "+RetSqlName("SRD")+" SRD
    cQuery += "             	LEFT JOIN "+RetSqlName("SRV")+" SRV
    cQuery += "             		ON SRV.RV_FILIAL = '"+xFilial("SRV")+"'
    cQuery += "             			AND SRV.RV_COD = SRD.RD_PD
    cQuery += "             			AND SRV.D_E_L_E_T_ = ' '
    cQuery += "             WHERE	SRD.D_E_L_E_T_ = ' '
    cQuery += "             		AND SRD.RD_PERIODO = '" + Substr(dTos(MV_PAR02),1,6) + "'
	cQuery += "             		AND SRD.RD_ROTEIR = 'FOL'
    cQuery += "             GROUP BY  SRV.RV_COD, SRV.RV_DESC, SRV.RV_TIPOCOD

    cQuery += "             UNION

    cQuery += "             SELECT	'SRC_ATUAL_HR' AS BASE,
    cQuery += "                     SRV.RV_COD,
    cQuery += "                     SRV.RV_DESC,
    cQuery += "                     SRV.RV_TIPOCOD,
    cQuery += "                     Sum(RC_HORAS) SALDO
    cQuery += "             FROM "+RetSqlName("SRC")+" SRC
    cQuery += "             	LEFT JOIN "+RetSqlName("SRV")+" SRV
    cQuery += "             		ON SRV.RV_FILIAL = '"+xFilial("SRV")+"'
    cQuery += "             			AND SRV.RV_COD = SRC.RC_PD
    cQuery += "             			AND SRV.D_E_L_E_T_ = ' '
    cQuery += "             WHERE	SRC.D_E_L_E_T_ = ' '
    cQuery += "             		AND SRC.RC_PERIODO = '" + Substr(dTos(MV_PAR02),1,6) + "'
	cQuery += "             		AND SRC.RC_ROTEIR = 'FOL'
    cQuery += "             GROUP BY  SRV.RV_COD, SRV.RV_DESC, SRV.RV_TIPOCOD

    cQuery += "             UNION

    cQuery += "             SELECT	'SRC_ATUAL' AS BASE,
    cQuery += "                     SRV.RV_COD,
    cQuery += "                     SRV.RV_DESC,
    cQuery += "                     SRV.RV_TIPOCOD,
    cQuery += "                     Sum(RC_VALOR) SALDO
    cQuery += "             FROM "+RetSqlName("SRC")+" SRC
    cQuery += "             	LEFT JOIN "+RetSqlName("SRV")+" SRV
    cQuery += "             		ON SRV.RV_FILIAL = '"+xFilial("SRV")+"'
    cQuery += "             			AND SRV.RV_COD = SRC.RC_PD
    cQuery += "             			AND SRV.D_E_L_E_T_ = ' '
    cQuery += "             WHERE	SRC.D_E_L_E_T_ = ' '
    cQuery += "             		AND SRC.RC_PERIODO = '" + Substr(dTos(MV_PAR02),1,6) + "'
	cQuery += "             		AND SRC.RC_ROTEIR = 'FOL'
    cQuery += "             GROUP BY  SRV.RV_COD, SRV.RV_DESC, SRV.RV_TIPOCOD
	
	cQuery += " 		) TMP 

	cQuery += " PIVOT( Sum(SALDO) FOR BASE IN('SRD_ANT_HR'   AS SRD_ANT_HR,
    cQuery += "                          'SRD_ANTERIOR' AS SRD_ANTERIOR,
    cQuery += "                          'SRD_ATUAL_HR' AS SRD_ATUAL_HR,
    cQuery += "                          'SRD_ATUAL'    AS SRD_ATUAL,
    cQuery += "                          'SRC_ATUAL_HR' AS SRC_ATUAL_HR,
    cQuery += "                          'SRC_ATUAL'    AS SRC_ATUAL ) )

	/*
	cQuery := " SELECT RV_COD, "
    cQuery += "   RV_DESC, "
    cQuery += "   RV_TIPOCOD, "
    cQuery += "   (SELECT Nvl(SUM(TMP.RD_HORAS), 0) "
    cQuery += "    FROM   (SELECT RD_PD, "
    cQuery += "                   RD_PERIODO, "
    cQuery += "                   SUM(RD_HORAS) RD_HORAS "
    cQuery += "            FROM   "+RetSqlName("SRD")+" SRD "
    cQuery += "            WHERE  SRD.D_E_L_E_T_ = ' ' "
    cQuery += "                   AND RD_PERIODO = '" + Substr(dTos(MV_PAR01),1,6) + "' "
    cQuery += "            GROUP  BY RD_PD, "
    cQuery += "                      RD_PERIODO) TMP "
    cQuery += "    WHERE  TMP.RD_PD = RV_COD) AS SRD_ANT_HR, "
    cQuery += "   (SELECT Nvl(SUM(TMP.RD_VALOR), 0) "
    cQuery += "    FROM   (SELECT RD_PD, "
    cQuery += "                   RD_PERIODO, "
    cQuery += "                   SUM(RD_VALOR) rd_valor "
    cQuery += "            FROM   "+RetSqlName("SRD")+" SRD "
    cQuery += "            WHERE  SRD.D_E_L_E_T_ = ' ' "
    cQuery += "                   AND RD_PERIODO = '" + Substr(dTos(MV_PAR01),1,6) + "' "
    cQuery += "            GROUP  BY RD_PD, "
    cQuery += "                      RD_PERIODO)TMP "
    cQuery += "    WHERE  TMP.RD_PD = RV_COD) AS SRD_ANTERIOR, "
    cQuery += "   (SELECT Nvl(SUM(TMP.RD_HORAS), 0) "
    cQuery += "    FROM   (SELECT RD_PD, "
    cQuery += "                   RD_PERIODO, "
    cQuery += "                   SUM(RD_HORAS) rd_horas "
    cQuery += "            FROM   "+RetSqlName("SRD")+" SRD "
    cQuery += "            WHERE  SRD.D_E_L_E_T_ = ' ' "
    cQuery += "                   AND RD_PERIODO = '" + Substr(dTos(MV_PAR02),1,6) + "' "
    cQuery += "            GROUP  BY RD_PD, "
    cQuery += "                      RD_PERIODO) TMP "
    cQuery += "    WHERE  TMP.RD_PD = RV_COD) AS SRD_ATUAL_HR, "
    cQuery += "   (SELECT Nvl(SUM(TMP.RD_VALOR), 0) "
    cQuery += "    FROM   (SELECT RD_PD, "
    cQuery += "                   RD_PERIODO, "
    cQuery += "                   SUM(RD_VALOR) rd_valor "
    cQuery += "            FROM   "+RetSqlName("SRD")+" SRD "
    cQuery += "            WHERE  SRD.D_E_L_E_T_ = ' ' "
    cQuery += "                   AND RD_PERIODO = '" + Substr(dTos(MV_PAR02),1,6) + "' "
    cQuery += "            GROUP  BY RD_PD, "
    cQuery += "                      RD_PERIODO)TMP "
    cQuery += "    WHERE  TMP.RD_PD = RV_COD) AS SRD_ATUAL, "
    cQuery += "   (SELECT Nvl(SUM(TMP.RC_HORAS), 0) "
    cQuery += "    FROM   (SELECT RC_PD, "
    cQuery += "                   RC_PERIODO, "
    cQuery += "                   SUM(RC_HORAS) rc_horas "
    cQuery += "            FROM   "+RetSqlName("SRC")+" SRC "
    cQuery += "            WHERE  SRC.D_E_L_E_T_ = ' ' "
    cQuery += "                   AND RC_PERIODO = '" + Substr(dTos(MV_PAR02),1,6) + "' "
    cQuery += "            GROUP  BY RC_PD, "
    cQuery += "                      RC_PERIODO) TMP "
    cQuery += "    WHERE  TMP.RC_PD = RV_COD) AS SRC_ATUAL_HR, "
    cQuery += "   (SELECT Nvl(SUM(TMP.RC_VALOR), 0) "
    cQuery += "    FROM   (SELECT RC_PD, "
    cQuery += "                   RC_PERIODO, "
    cQuery += "                   SUM(RC_VALOR) rc_valor "
    cQuery += "            FROM   "+RetSqlName("SRC")+" SRC "
    cQuery += "            WHERE  SRC.D_E_L_E_T_ = ' ' "
    cQuery += "                   AND RC_PERIODO = '" + Substr(dTos(MV_PAR02),1,6) + "' "
    cQuery += "            GROUP  BY RC_PD, "
    cQuery += "                      RC_PERIODO)TMP "
    cQuery += "    WHERE  TMP.RC_PD = RV_COD) AS SRC_ATUAL "
	cQuery += " FROM   SRV010 SRV "
	cQuery += " WHERE  SRV.D_E_L_E_T_ = ' ' "
    cQuery += "   AND RV_FILIAL = ' ' "
	//cQuery += " AND RV_TIPOCOD IN('2','4') "//Somente Verbas de Desconto
	*/
	/*
	cQuery := " SELECT 
	cQuery += " RV_COD,RV_DESC,RV_TIPOCOD,
	cQuery += " NVL((SELECT SUM(RD_HORAS ) FROM "+RetSqlName("SRD")+" SRD
	cQuery += " WHERE SRD.D_E_L_E_T_ = ' ' 
	cQuery += " AND RD_PD = RV_COD
	//cQuery += " AND SUBSTR(RD_DATPGT,1,6) = '" + Substr(dTos(MV_PAR01),1,6) + "'),0) AS  SRD_ANT_HR ,
	cQuery += " AND RD_PERIODO = '" + Substr(dTos(MV_PAR01),1,6) + "'),0) AS  SRD_ANT_HR ,

	cQuery += " NVL((SELECT SUM(RD_VALOR) FROM "+RetSqlName("SRD")+" SRD
	cQuery += " WHERE SRD.D_E_L_E_T_ = ' ' 
	cQuery += " AND RD_PD = RV_COD
	//cQuery += " AND SUBSTR(RD_DATPGT,1,6) = '" + Substr(dTos(MV_PAR01),1,6) + "'),0) AS  SRD_ANTERIOR ,
	cQuery += " AND RD_PERIODO = '" + Substr(dTos(MV_PAR01),1,6) + "'),0) AS  SRD_ANTERIOR ,

	cQuery += " NVL((SELECT SUM(RD_HORAS) FROM "+RetSqlName("SRD")+" SRD
	cQuery += " WHERE SRD.D_E_L_E_T_ = ' '  
	cQuery += " AND RD_PD = RV_COD
	//cQuery += " AND SUBSTR(RD_DATPGT,1,6) = '" + Substr(dTos(MV_PAR02),1,6) + "'),0) AS  SRD_ATUAL_HR ,
	cQuery += " AND RD_PERIODO = '" + Substr(dTos(MV_PAR02),1,6) + "'),0) AS  SRD_ATUAL_HR ,

	cQuery += " NVL((SELECT SUM(RD_VALOR) FROM "+RetSqlName("SRD")+" SRD
	cQuery += " WHERE SRD.D_E_L_E_T_ = ' '  
	cQuery += " AND RD_PD = RV_COD
	//cQuery += " AND SUBSTR(RD_DATPGT,1,6) = '" + Substr(dTos(MV_PAR02),1,6) + "'),0) AS  SRD_ATUAL ,
	cQuery += " AND RD_PERIODO = '" + Substr(dTos(MV_PAR02),1,6) + "'),0) AS  SRD_ATUAL ,

	cQuery += " NVL((SELECT SUM(RC_HORAS) FROM "+RetSqlName("SRC")+" SRC
	cQuery += " WHERE SRC.D_E_L_E_T_ = ' '  
	cQuery += " AND RC_PD = RV_COD
	//cQuery += " AND SUBSTR(RC_DATA  ,1,6) = '" + Substr(dTos(MV_PAR02),1,6) + "'),0) AS  SRC_ATUAL_HR,
	cQuery += " AND RC_PERIODO = '" + Substr(dTos(MV_PAR02),1,6) + "'),0) AS  SRC_ATUAL_HR,

	cQuery += " NVL((SELECT SUM(RC_VALOR) FROM "+RetSqlName("SRC")+" SRC
	cQuery += " WHERE SRC.D_E_L_E_T_ = ' '  
	cQuery += " AND RC_PD = RV_COD
	//cQuery += " AND SUBSTR(RC_DATA  ,1,6) = '" + Substr(dTos(MV_PAR02),1,6) + "'),0) AS  SRC_ATUAL 
	cQuery += " AND RC_PERIODO = '" + Substr(dTos(MV_PAR02),1,6) + "'),0) AS  SRC_ATUAL 

	cQuery += " FROM "+RetSqlName("SRV")+" SRV
	cQuery += " WHERE SRV.D_E_L_E_T_ =  ' '
	cQuery += " AND RV_FILIAL = ' ' 
	*/
	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

Return()

