#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  RSTFAT56     ºAutor  ³Giovani Zago    º Data ³  29/09/14     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Relatorio ONE VOICE					                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*-----------------------------*
User Function RSTFAT56()
*-----------------------------*          
Local   oReport
Private cPerg 			:= "RFAT56"
Private cTime           := Time()
Private cHora           := SUBSTR(cTime, 1, 2)
Private cMinutos    	:= SUBSTR(cTime, 4, 2)
Private cSegundos   	:= SUBSTR(cTime, 7, 2)
Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos
Private lXlsHeader      := .f.
Private lXmlEndRow      := .f.
Private cPergTit 		:= cAliasLif


/*
PutSx1(cPerg, "01", "Tabela 01:" 		,"Da Data: ?" 		,"Da Data: ?" 		,"mv_ch1","C",3,0,0,"G","",'DA0'    ,"","","mv_par01","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "02", "Tabela 02:" 		,"Ate Data: ?" 		,"Ate Data: ?" 		,"mv_ch2","C",3,0,0,"G","",'DA0'    ,"","","mv_par02","","","","","","","","","","","","","","","","")

PutSx1(cPerg, "03", "Do Grupo:" 		,"Do Vendedor: ?" 	,"Do Vendedor: ?" 	,"mv_ch3","C", 5,0,0,"G","",'SBM' ,"","","mv_par03","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "04", "Ate Grupo:"  		,"Ate Vendedor: ?" 	,"Ate Vendedor: ?" 	,"mv_ch4","C", 5,0,0,"G","",'SBM' ,"","","mv_par04","","","","","","","","","","","","","","","","")
 
PutSx1(cPerg, "05", "Do Pedido:" 		,"Do Vendedor: ?" 	,"Do Vendedor: ?" 	,"mv_ch5","C", 6,0,0,"G","",'SC5' ,"","","mv_par05","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "06", "Ate Pedido:"  		,"Ate Vendedor: ?" 	,"Ate Vendedor: ?" 	,"mv_ch6","C", 6,0,0,"G","",'SC5' ,"","","mv_par06","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "07", "Da Emissão:" 		,"Do Vendedor: ?" 	,"Do Vendedor: ?" 	,"mv_ch7","D", 8,0,0,"G","",'' ,"","","mv_par07","","","","","","","","","","","","","","","","")
PutSx1(cPerg, "08", "Ate Emissão:"  	,"Ate Vendedor: ?" 	,"Ate Vendedor: ?" 	,"mv_ch8","D", 8,0,0,"G","",'' ,"","","mv_par08","","","","","","","","","","","","","","","","")
*/

oReport		:= ReportDef()
oReport:PrintDialog()

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ReportDef    ºAutor  ³Giovani Zago    º Data ³  21/02/14     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Relatorio ONE VOICE				                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*-----------------------------*
Static Function ReportDef()
*-----------------------------*
Local oReport
Local oSection

oReport := TReport():New(cPergTit,"RELATÓRIO ONE VOICE ",cPerg,{|oReport| ReportPrint(oReport)},"Este programa irá imprimir um relatório ONE VOICE ")

Pergunte(cPerg,.F.)

oSection := TRSection():New(oReport,"ONE VOICE ",{"PPC"})


TRCell():New(oSection,"01",,"SEXO"								,,15,.F.,)
TRCell():New(oSection,"02",,"IDADE"								,,35,.F.,)
TRCell():New(oSection,"03",,"TEMPO DE TRABALHO"					,,05,.F.,)
TRCell():New(oSection,"04",,"motiva a contribuir mais"			,,15,.F.,)
TRCell():New(oSection,"05",,"encontro o equilíbrio adequado "	,,35,.F.,)
TRCell():New(oSection,"06",,"inspira a dar o melhor"			,,05,.F.,)
TRCell():New(oSection,"07",,"relação entre objetivos"			,,15,.F.,)
TRCell():New(oSection,"08",,"Disponho de oportunidades"			,,35,.F.,)
TRCell():New(oSection,"09",,"dificilmentedeixa Steck"			,,05,.F.,)
TRCell():New(oSection,"10",,"Eu somente sairei da Steck"		,,15,.F.,)
TRCell():New(oSection,"11",,"Quando surge a oportunidade "		,,35,.F.,)
TRCell():New(oSection,"12",,"Meus colegas de trabalho"			,,05,.F.,)
TRCell():New(oSection,"13",,"superior me dá o feedback"			,,15,.F.,)
TRCell():New(oSection,"14",,"Penso que a cooperação"			,,35,.F.,)
TRCell():New(oSection,"15",,"Eu não hesitaria"					,,05,.F.,)
TRCell():New(oSection,"16",,"Você recomendaria a Steck "		,"@E 99,999,999.99",14)
TRCell():New(oSection,"17",,"Crescimento da Carreira"			,,35,.F.,)
TRCell():New(oSection,"18",,"Comunicações"						,,05,.F.,)
TRCell():New(oSection,"19",,"Valores da Empresa "				,,15,.F.,)
TRCell():New(oSection,"20",,"Liderança"							,,35,.F.,)
TRCell():New(oSection,"21",,"Meu Trabalho"						,,05,.F.,)
TRCell():New(oSection,"22",,"Processos/Políticas/Procedi"		,,15,.F.,)
TRCell():New(oSection,"23",,"Segurança"							,,35,.F.,)
TRCell():New(oSection,"24",,"Pessoal"							,,05,.F.,)
TRCell():New(oSection,"25",,"Estratégia"						,,15,.F.,)
TRCell():New(oSection,"26",,"Equilíbrio Trabalho/Pessoal"		,,35,.F.,)
TRCell():New(oSection,"27",,"outros"							,,05,.F.,)
TRCell():New(oSection,"28",,"Departamento"						,,35,.F.,) 




oSection:SetHeaderSection(.t.)
oSection:Setnofilter("PPC")

Return oReport
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ReportPrint  ºAutor  ³Giovani Zago    º Data ³  21/02/14     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Relatorio Produtos em transito	                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*------------------------------------*
Static Function ReportPrint(oReport)
*------------------------------------*
Local oSection	:= oReport:Section(1)
Local oSection1	:= oReport:Section(1)
Local nX		:= 0
Local cQuery 	:= ""
Local cAlias 	:= "QRYTEMP0"
Local aDados[2]
Local aDados1[99]
Local _cSta 	:= ''



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
oSection1:Cell("15") :SetBlock( { || aDados1[15] } )
oSection1:Cell("16") :SetBlock( { || aDados1[16] } )
oSection1:Cell("17") :SetBlock( { || aDados1[17] } )
oSection1:Cell("18") :SetBlock( { || aDados1[18] } )
oSection1:Cell("19") :SetBlock( { || aDados1[19] } )
oSection1:Cell("20") :SetBlock( { || aDados1[20] } )
oSection1:Cell("21") :SetBlock( { || aDados1[21] } )
oSection1:Cell("22") :SetBlock( { || aDados1[22] } )
oSection1:Cell("23") :SetBlock( { || aDados1[23] } )
oSection1:Cell("24") :SetBlock( { || aDados1[24] } )
oSection1:Cell("25") :SetBlock( { || aDados1[25] } )
oSection1:Cell("26") :SetBlock( { || aDados1[26] } )
oSection1:Cell("27") :SetBlock( { || aDados1[27] } )
oSection1:Cell("28") :SetBlock( { || aDados1[28] } )


oReport:SetTitle("ONE VOICE")// Titulo do relatório

oReport:SetMeter(0)
aFill(aDados,nil)
aFill(aDados1,nil)
oSection:Init()


Processa({|| StQuery(  ) },"Compondo Relatorio")

DbSelectArea(cAliasLif)
(cAliasLif)->(DbGoTop())
If  Select(cAliasLif) > 0
	
	While 	(cAliasLif)->(!Eof())
		
		
	 	aDados1[01]	:=	(cAliasLif)->c01
		aDados1[02]	:= 	(cAliasLif)->c02
		aDados1[03]	:=  (cAliasLif)->c03
		aDados1[04]	:=  (cAliasLif)->c04
		aDados1[05]	:=  (cAliasLif)->c05
		aDados1[06]	:=	(cAliasLif)->c06
		aDados1[07]	:= 	(cAliasLif)->c07
		aDados1[08]	:= 	(cAliasLif)->c08
		aDados1[09]	:= 	(cAliasLif)->c09
		aDados1[10]	:= 	(cAliasLif)->c10
		aDados1[11]	:= 	(cAliasLif)->c11
		aDados1[12]	:= 	(cAliasLif)->c12
		aDados1[13]	:= 	(cAliasLif)->c13
		aDados1[14]	:= 	(cAliasLif)->c14
		aDados1[15]	:= 	(cAliasLif)->c15
		aDados1[16]	:= 	(cAliasLif)->c16
		aDados1[17]	:= 	(cAliasLif)->c17
		aDados1[18]	:= 	(cAliasLif)->c18
		aDados1[19]	:= 	(cAliasLif)->c19
		aDados1[20]	:= 	(cAliasLif)->c20
		aDados1[21]	:= 	(cAliasLif)->c21
		aDados1[22]	:= 	(cAliasLif)->c22
		aDados1[23]	:= 	(cAliasLif)->c23
		aDados1[24]	:= 	(cAliasLif)->c24
		aDados1[25]	:= 	(cAliasLif)->c25
		aDados1[26]	:= 	(cAliasLif)->c26
		aDados1[27]	:= 	(cAliasLif)->c27		
		aDados1[28]	:= 	(cAliasLif)->c28	
		
		oSection1:PrintLine()
		aFill(aDados1,nil)
		(cAliasLif)->(dbskip())
	End
	(cAliasLif)->(dbCloseArea())
EndIf
oReport:SkipLine()
Return oReport


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  StQuery      ºAutor  ³Giovani Zago    º Data ³  21/02/14     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Relatorio COMISSAO				                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*-----------------------------*
Static Function StQuery(_ccod)
*-----------------------------*

Local cQuery     := ' '


cQuery := " SELECT
cQuery += " CASE WHEN PPC.PPC_01  = 'F' THEN 'FEMININO'  ELSE CASE WHEN PPC.PPC_01  = 'M' THEN 'MASCULINO' ELSE ' 'END END
cQuery += ' as "c01",
cQuery += " CASE WHEN PPC.PPC_02  = '1' THEN '19 anos ou menos'
cQuery += " ELSE CASE WHEN PPC.PPC_02  = '2' THEN '20 a 29 anos'
cQuery += " ELSE CASE WHEN PPC.PPC_02  = '3' THEN '30 a 39 anos'
cQuery += " ELSE CASE WHEN PPC.PPC_02  = '4' THEN '40 a 49 anos'
cQuery += " ELSE CASE WHEN PPC.PPC_02  = '5' THEN '50 a 59 anos'
cQuery += " ELSE CASE WHEN PPC.PPC_02  = '6' THEN '60 anos ou mais'
cQuery += " ELSE ' ' END
cQuery += " END END END END END
cQuery += ' AS "c02"  ,
cQuery += " CASE WHEN PPC.PPC_03  = '1' THEN 'Menos de 1 ano'
cQuery += " ELSE CASE WHEN PPC.PPC_03  = '2' THEN '1 a 5 anos'
cQuery += " ELSE CASE WHEN PPC.PPC_03  = '3' THEN '6 a 10 anos'
cQuery += " ELSE CASE WHEN PPC.PPC_03  = '4' THEN '11 a 15 anos'
cQuery += " ELSE CASE WHEN PPC.PPC_03  = '5' THEN '16 a 20 anos'
cQuery += " ELSE CASE WHEN PPC.PPC_03  = '6' THEN 'Mais de 20 anos'
cQuery += " ELSE ' ' END
cQuery += " END END END END END
cQuery += ' AS "c03"  ,
cQuery += " CASE WHEN PPC.PPC_04  = '1' THEN '1-Concordo Totalmente'
cQuery += " ELSE CASE WHEN PPC.PPC_04  = '2' THEN '2-Concordo'
cQuery += " ELSE CASE WHEN PPC.PPC_04  = '3' THEN '3-Concordo Parcialmente'
cQuery += " ELSE CASE WHEN PPC.PPC_04  = '4' THEN '4-Discordo Parcialmente'
cQuery += " ELSE CASE WHEN PPC.PPC_04  = '5' THEN '5-Discordo'
cQuery += " ELSE CASE WHEN PPC.PPC_04  = '6' THEN '6-Discordo Totalmente'
cQuery += " ELSE ' ' END
cQuery += " END END END END END
cQuery += ' AS "c04"  ,
cQuery += " CASE WHEN PPC.PPC_05  = '1' THEN '1-Concordo Totalmente'
cQuery += " ELSE CASE WHEN PPC.PPC_05  = '2' THEN '2-Concordo'
cQuery += " ELSE CASE WHEN PPC.PPC_05 = '3' THEN '3-Concordo Parcialmente'
cQuery += " ELSE CASE WHEN PPC.PPC_05  = '4' THEN '4-Discordo Parcialmente'
cQuery += " ELSE CASE WHEN PPC.PPC_05  = '5' THEN '5-Discordo'
cQuery += " ELSE CASE WHEN PPC.PPC_05  = '6' THEN '6-Discordo Totalmente'
cQuery += " ELSE ' ' END
cQuery += " END END END END END
cQuery += ' AS "c05" ,
cQuery += " CASE WHEN      PPC.PPC_06  = '1' THEN '1-Concordo Totalmente'
cQuery += " ELSE CASE WHEN PPC.PPC_06  = '2' THEN '2-Concordo'
cQuery += " ELSE CASE WHEN PPC.PPC_06 = '3' THEN '3-Concordo Parcialmente'
cQuery += " ELSE CASE WHEN PPC.PPC_06  = '4' THEN '4-Discordo Parcialmente'
cQuery += " ELSE CASE WHEN PPC.PPC_06  = '5' THEN '5-Discordo'
cQuery += " ELSE CASE WHEN PPC.PPC_06  = '6' THEN '6-Discordo Totalmente'
cQuery += " ELSE ' ' END
cQuery += " END END END END END
cQuery += ' AS "c06"  ,
cQuery += " CASE WHEN      PPC.PPC_07  = '1' THEN '1-Concordo Totalmente'
cQuery += " ELSE CASE WHEN PPC.PPC_07  = '2' THEN '2-Concordo'
cQuery += " ELSE CASE WHEN PPC.PPC_07 = '3'  THEN '3-Concordo Parcialmente'
cQuery += " ELSE CASE WHEN PPC.PPC_07  = '4' THEN '4-Discordo Parcialmente'
cQuery += " ELSE CASE WHEN PPC.PPC_07  = '5' THEN '5-Discordo'
cQuery += " ELSE CASE WHEN PPC.PPC_07  = '6' THEN '6-Discordo Totalmente'
cQuery += " ELSE ' ' END
cQuery += " END END END END END
cQuery += ' AS "c07"   ,
cQuery += " CASE WHEN      PPC.PPC_08  = '1' THEN '1-Concordo Totalmente'
cQuery += " ELSE CASE WHEN PPC.PPC_08  = '2' THEN '2-Concordo'
cQuery += " ELSE CASE WHEN PPC.PPC_08 = '3'  THEN '3-Concordo Parcialmente'
cQuery += " ELSE CASE WHEN PPC.PPC_08  = '4' THEN '4-Discordo Parcialmente'
cQuery += " ELSE CASE WHEN PPC.PPC_08  = '5' THEN '5-Discordo'
cQuery += " ELSE CASE WHEN PPC.PPC_08  = '6' THEN '6-Discordo Totalmente'
cQuery += " ELSE ' ' END
cQuery += " END END END END END
cQuery += ' AS "c08"  ,
cQuery += " CASE WHEN      PPC.PPC_09  = '1' THEN '1-Concordo Totalmente'
cQuery += " ELSE CASE WHEN PPC.PPC_09  = '2' THEN '2-Concordo'
cQuery += " ELSE CASE WHEN PPC.PPC_09 = '3'  THEN '3-Concordo Parcialmente'
cQuery += " ELSE CASE WHEN PPC.PPC_09  = '4' THEN '4-Discordo Parcialmente'
cQuery += " ELSE CASE WHEN PPC.PPC_09  = '5' THEN '5-Discordo'
cQuery += " ELSE CASE WHEN PPC.PPC_09  = '6' THEN '6-Discordo Totalmente'
cQuery += " ELSE ' ' END
cQuery += " END END END END END
cQuery += ' AS "c09"  ,
cQuery += " CASE WHEN      PPC.PPC_10  = '1' THEN '1-Concordo Totalmente'
cQuery += " ELSE CASE WHEN PPC.PPC_10  = '2' THEN '2-Concordo'
cQuery += " ELSE CASE WHEN PPC.PPC_10 = '3'  THEN '3-Concordo Parcialmente'
cQuery += " ELSE CASE WHEN PPC.PPC_10  = '4' THEN '4-Discordo Parcialmente'
cQuery += " ELSE CASE WHEN PPC.PPC_10  = '5' THEN '5-Discordo'
cQuery += " ELSE CASE WHEN PPC.PPC_10  = '6' THEN '6-Discordo Totalmente'
cQuery += " ELSE ' ' END
cQuery += " END END END END END
cQuery += ' AS "c10"   ,
cQuery += " CASE WHEN      PPC.PPC_11  = '1' THEN '1-Concordo Totalmente'
cQuery += " ELSE CASE WHEN PPC.PPC_11  = '2' THEN '2-Concordo'
cQuery += " ELSE CASE WHEN PPC.PPC_11 = '3'  THEN '3-Concordo Parcialmente'
cQuery += " ELSE CASE WHEN PPC.PPC_11  = '4' THEN '4-Discordo Parcialmente'
cQuery += " ELSE CASE WHEN PPC.PPC_11  = '5' THEN '5-Discordo'
cQuery += " ELSE CASE WHEN PPC.PPC_11  = '6' THEN '6-Discordo Totalmente'
cQuery += " ELSE ' ' END
cQuery += " END END END END END
cQuery += ' AS "c11"  ,
cQuery += " CASE WHEN      PPC.PPC_12  = '1' THEN '1-Concordo Totalmente'
cQuery += " ELSE CASE WHEN PPC.PPC_12  = '2' THEN '2-Concordo'
cQuery += " ELSE CASE WHEN PPC.PPC_12 = '3'  THEN '3-Concordo Parcialmente'
cQuery += " ELSE CASE WHEN PPC.PPC_12  = '4' THEN '4-Discordo Parcialmente'
cQuery += " ELSE CASE WHEN PPC.PPC_12  = '5' THEN '5-Discordo'
cQuery += " ELSE CASE WHEN PPC.PPC_12  = '6' THEN '6-Discordo Totalmente'
cQuery += " ELSE ' ' END 
cQuery += " END END END END END
cQuery += ' AS "c12"  ,
cQuery += " CASE WHEN      PPC.PPC_13  = '1' THEN '1-Concordo Totalmente'
cQuery += " ELSE CASE WHEN PPC.PPC_13  = '2' THEN '2-Concordo'
cQuery += " ELSE CASE WHEN PPC.PPC_13  = '3'  THEN '3-Concordo Parcialmente'
cQuery += " ELSE CASE WHEN PPC.PPC_13  = '4' THEN '4-Discordo Parcialmente'
cQuery += " ELSE CASE WHEN PPC.PPC_13  = '5' THEN '5-Discordo'
cQuery += " ELSE CASE WHEN PPC.PPC_13  = '6' THEN '6-Discordo Totalmente'
cQuery += " ELSE ' ' END
cQuery += " END END END END END
cQuery += ' AS "c13"    ,
cQuery += " CASE WHEN      PPC.PPC_14  = '1' THEN '1-Concordo Totalmente'
cQuery += " ELSE CASE WHEN PPC.PPC_14  = '2' THEN '2-Concordo'
cQuery += " ELSE CASE WHEN PPC.PPC_14  = '3'  THEN '3-Concordo Parcialmente'
cQuery += " ELSE CASE WHEN PPC.PPC_14  = '4' THEN '4-Discordo Parcialmente'
cQuery += " ELSE CASE WHEN PPC.PPC_14  = '5' THEN '5-Discordo'
cQuery += " ELSE CASE WHEN PPC.PPC_14  = '6' THEN '6-Discordo Totalmente'
cQuery += " ELSE ' ' END
cQuery += " END END END END END
cQuery += ' AS "c14"    ,
cQuery += " CASE WHEN      PPC.PPC_15  = '1' THEN '1-Concordo Totalmente'
cQuery += " ELSE CASE WHEN PPC.PPC_15  = '2' THEN '2-Concordo'
cQuery += " ELSE CASE WHEN PPC.PPC_15  = '3'  THEN '3-Concordo Parcialmente'
cQuery += " ELSE CASE WHEN PPC.PPC_15  = '4' THEN '4-Discordo Parcialmente'
cQuery += " ELSE CASE WHEN PPC.PPC_15  = '5' THEN '5-Discordo'
cQuery += " ELSE CASE WHEN PPC.PPC_15  = '6' THEN '6-Discordo Totalmente'
cQuery += " ELSE ' ' END
cQuery += " END END END END END
cQuery += ' AS "c15"    ,
cQuery += " PPC.PPC_16
cQuery += ' AS "c16"    ,
cQuery += " CASE WHEN      PPC.PPC_17  like '%1/%' THEN 'Crescimento da Carreira'
cQuery += " ELSE ' ' END
cQuery += ' AS "c17"    ,
cQuery += " CASE WHEN PPC.PPC_17  like '%2/%' THEN 'Comunicações'
cQuery += " ELSE ' ' END
cQuery += ' AS "c18"    ,
cQuery += " CASE WHEN PPC.PPC_17  like '%3/%'  THEN 'Valores da Empresa'
cQuery += " ELSE ' ' END
cQuery += ' AS "c19"    ,
cQuery += " CASE WHEN PPC.PPC_17  like '%4/%' THEN 'Liderança'
cQuery += " ELSE ' ' END
cQuery += ' AS "c20"    ,
cQuery += " CASE WHEN PPC.PPC_17  like '%5/%' THEN 'Meu Trabalho'
cQuery += " ELSE ' ' END
cQuery += ' AS "c21"    ,
cQuery += " CASE WHEN PPC.PPC_17  like '%6/%' THEN 'Processos/Políticas/Procedimentos'
cQuery += " ELSE ' ' END
cQuery += ' AS "c22"    ,
cQuery += " CASE WHEN PPC.PPC_17  like '%7/%'  THEN 'Segurança'
cQuery += " ELSE ' ' END
cQuery += ' AS "c23"    ,
cQuery += " CASE WHEN PPC.PPC_17  like '%8/%' THEN 'Pessoal'
cQuery += " ELSE ' ' END
cQuery += ' AS "c24"    ,
cQuery += " CASE WHEN PPC.PPC_17  like'%9/%' THEN 'Estratégia'
cQuery += " ELSE ' ' END
cQuery += ' AS "c25"    , PPC.PPC_19 
cQuery += ' AS "c28" ,
cQuery += " CASE WHEN PPC.PPC_17  like '%10/%' THEN 'Equilíbrio entre Trabalho/Vida Pessoal'
cQuery += " ELSE ' ' END
cQuery += ' AS "c26"    
cQuery += " ,trim(UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(PPC_18, 3200,1)))
cQuery += ' AS "c27"
cQuery += " FROM "+RetSqlName("PPC")+" PPC "
cQuery += " WHERE PPC.D_E_L_E_T_ = ' '

//cQuery := ChangeQuery(cQuery)

If Select(cAliasLif) > 0
	(cAliasLif)->(dbCloseArea())
EndIf

dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

Return()

