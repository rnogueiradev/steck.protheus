#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"
#Define CR chr(13)+chr(10) 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  RSTFATCQ     ºAutor  ³Giovani Zago    º Data ³  27/08/19     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Relatorio  MKT - Pilhas  		                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RSTFATCQ()

	Local   oReport
	Private cPerg 			:= "RFATCQ"
	Private cTime           := Time()
	Private cHora           := SUBSTR(cTime, 1, 2)
	Private cMinutos    	:= SUBSTR(cTime, 4, 2)
	Private cSegundos   	:= SUBSTR(cTime, 7, 2)
	Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos
	Private lXlsHeader      := .f.
	Private lXmlEndRow      := .f.
	Private cPergTit 		:= cAliasLif

	U_STPutSx1( cPerg, "01","Data de?" 		   			,"MV_PAR01","mv_ch1","D",08,0,"G",,""  		,"@!")
	U_STPutSx1( cPerg, "02","Data ate?"					,"MV_PAR02","mv_ch2","D",08,0,"G",,""  		,"@!")

	oReport		:= ReportDef()

	oReport:PrintDialog()

Return

Static Function ReportDef()

	Local oReport
	Local oSection

	oReport := TReport():New(cPergTit,"RELATÓRIO MKT - Pilhas",cPerg,{|oReport| ReportPrint(oReport)},"Este programa irá imprimir um relatório da MKT - Pilhas.")

	Pergunte(cPerg,.F.)

	oSection := TRSection():New(oReport,"MKT - Pilhas",{"SC5"})


 	TRCell():New(oSection,"01",,"CLIENTE"		,,06,.F.,)
	TRCell():New(oSection,"02",,"LOJA"			,,06,.F.,)
	TRCell():New(oSection,"03",,"NOME" 			,,06,.F.,)
	TRCell():New(oSection,"04",,"ENDEREÇO" 		,,06,.F.,)
	TRCell():New(oSection,"05",,"TELEFONE"		,,06,.F.,)
	TRCell():New(oSection,"06",,"EMAIL" 		,,06,.F.,)
	TRCell():New(oSection,"07",,"PEDIDO"		,,06,.F.,)
	TRCell():New(oSection,"08",,"CIDADE"		,,06,.F.,)
	TRCell():New(oSection,"09",,"ESTADO"		,,06,.F.,)
	TRCell():New(oSection,"10",,"DDD"			,,06,.F.,)
	TRCell():New(oSection,"11",,"VENDEDOR"		,,06,.F.,)

	oSection:SetHeaderSection(.t.)
	oSection:Setnofilter("SF2")



Return oReport

Static Function ReportPrint(oReport)

	Local oSection	:= oReport:Section(1)
	Local oSection1	:= oReport:Section(1)
	Local nT1		:= 0
	Local nT2		:= 0
	Local cQuery 	:= ""
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

	oReport:SetTitle("MKT - Pilhas")// Titulo do relatório

	oReport:SetMeter(0)
	aFill(aDados,nil)
	aFill(aDados1,nil)
	oSection:Init()




	Processa({|| StQuery( ) },"Compondo Relatorio")




	dbSelectArea(cAliasLif)
	(cAliasLif)->(dbgotop())
	If  Select(cAliasLif) > 0

		While 	(cAliasLif)->(!Eof())


			aDados1[01]	:= 	(cAliasLif)->C6_CLI
			aDados1[02]	:=  (cAliasLif)->C6_LOJA
			aDados1[03]	:=	(cAliasLif)->A1_NOME
			aDados1[04]	:= 	(cAliasLif)->A1_END
			aDados1[05]	:=  (cAliasLif)->A1_TEL
			aDados1[06]	:=	(cAliasLif)->A1_EMAIL
			aDados1[07]	:= 	(cAliasLif)->C6_NUM
			aDados1[08]	:= 	(cAliasLif)->A1_MUN
			aDados1[09]	:= 	(cAliasLif)->A1_EST
			aDados1[10]	:= 	(cAliasLif)->A1_DDD
			aDados1[11]	:= 	(cAliasLif)->A1_VEND

			oSection1:PrintLine()
			aFill(aDados1,nil)

			(cAliasLif)->(dbskip())

		End


	EndIf



	oReport:SkipLine()




Return oReport



Static Function StQuery()

	Local cQuery      := ' '


	cQuery := " SELECT 
	cQuery += CR+ "   DISTINCT C6_CLI, C6_LOJA , A1_NOME, A1_END, A1_TEL, A1_EMAIL,C6_NUM
	cQuery += CR+ "   , A1_MUN, A1_EST, A1_DDD, A1_VEND
	cQuery += CR+ "   FROM SC6010 SC6
	cQuery += CR+ "   INNER JOIN(SELECT * FROM SC5010)SC5
	cQuery += CR+ "   ON SC5.D_E_L_E_T_  = ' '
	cQuery += CR+ "   AND C5_NUM = C6_NUM AND C5_FILIAL = C6_FILIAL AND C5_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"'
	cQuery += CR+ "   INNER JOIN(SELECT * FROM SA1010)SA1
	cQuery += CR+ "   ON SA1.D_E_L_E_T_  = ' '
	cQuery += CR+ "   AND A1_COD = C6_CLI
	cQuery += CR+ "   AND A1_LOJA = C6_LOJA
	cQuery += CR+ "   WHERE SC6.D_E_L_E_T_  = ' '
	cQuery += CR+ "   AND (SUBSTR(C6_PRODUTO,1,4) = 'PA15' OR SUBSTR(C6_PRODUTO,1,4) = 'PA09') 



	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

Return()

