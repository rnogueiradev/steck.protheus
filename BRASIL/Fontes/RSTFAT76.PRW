#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  RSTFAT56     ºAutor  ³Giovani Zago    º Data ³  29/09/14     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Relatorio ONE VOICE - 2015/2016    		                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*-----------------------------*
User Function RSTFAT76()			//U_RSTFAT76()
*-----------------------------*
Local   oReport
Private cPerg 			:= "RFAT76"
Private cTime           := Time()
Private cHora           := SUBSTR(cTime, 1, 2)
Private cMinutos    	:= SUBSTR(cTime, 4, 2)
Private cSegundos   	:= SUBSTR(cTime, 7, 2)
Private cAliasLif   	:= cPerg+cHora+cMinutos+cSegundos
//Private lXlsHeader      := .f.
//Private lXmlEndRow      := .f.
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

//TRCell():New(oSection,"01",,"SEXO"								,,15,.F.,)
//TRCell():New(oSection,"02",,"IDADE"								,,35,.F.,)
//TRCell():New(oSection,"03",,"TEMPO DE TRABALHO"					,,05,.F.,)
TRCell():New(oSection,"01",,"Empresa"												,,02,.F.,)
TRCell():New(oSection,"02",,"Ano"													,,04,.F.,)
TRCell():New(oSection,"03",,"Departamento"											,,20,.F.,)
TRCell():New(oSection,"04",,"Meu superior imediato fornece feedback"				,,35,.F.,)
TRCell():New(oSection,"05",,"As ferramentas e os recursos"							,,35,.F.,)
TRCell():New(oSection,"06",,"A colaboração entre as equipes e as entidades"			,,35,.F.,)
TRCell():New(oSection,"07",,"As oportunidades de desenvolvimento e aprendizado"		,,35,.F.,)
TRCell():New(oSection,"08",,"A organização valoriza a diversidade"					,,35,.F.,)
TRCell():New(oSection,"09",,"Minha organização cuida ativamente do bem-estar"		,,35,.F.,)
TRCell():New(oSection,"10",,"Eu não hesitaria em recomendar a Steck"				,,35,.F.,)
TRCell():New(oSection,"11",,"Quando tenho oportunidade, conto aos outros "			,,35,.F.,)
TRCell():New(oSection,"12",,"Eu raramente penso em deixar a Steck"					,,35,.F.,)
TRCell():New(oSection,"13",,"Seria preciso muito mais para me convencer"			,,35,.F.,)
TRCell():New(oSection,"14",,"A steck me motiva a contribuir"						,,35,.F.,)
TRCell():New(oSection,"15",,"A steck me inspira a fazer o meu melhor"				,,35,.F.,)
TRCell():New(oSection,"16",,"Na Steck, estamos sempre em busca de melhores formas"	,,35,.F.,)
TRCell():New(oSection,"17",,"Recebo reconhecimento adequado"						,,35,.F.,)
TRCell():New(oSection,"18",,"Você está ciente que os planos de ação"				,,10,.F.,)
TRCell():New(oSection,"19",,"Os planos de ação da pesquisa OneVoice"				,,10,.F.,)
TRCell():New(oSection,"20",,"SEXO"													,,15,.F.,)
TRCell():New(oSection,"21",,"Auto declara-se como "									,,15,.F.,)
TRCell():New(oSection,"22",,"Descreva um momento que fez você sentir orgulho em trabalhar na Steck "									,,254,.F.,)

/*
TRCell():New(oSection,"19",,"numa escala de 0 a 10 "			,"@E 99,999,999.99",14)
TRCell():New(oSection,"20",,"Crescimento da Carreira"			,,35,.F.,)
TRCell():New(oSection,"21",,"Comunicações"						,,05,.F.,)
TRCell():New(oSection,"22",,"Valores da Empresa "				,,15,.F.,)
TRCell():New(oSection,"23",,"Liderança"							,,35,.F.,)
TRCell():New(oSection,"24",,"Meu Trabalho"						,,05,.F.,)
TRCell():New(oSection,"25",,"Processos/Políticas/Procedi"		,,15,.F.,)
TRCell():New(oSection,"26",,"Segurança"							,,35,.F.,)
TRCell():New(oSection,"27",,"Pessoal"							,,05,.F.,)
TRCell():New(oSection,"28",,"Estratégia"						,,15,.F.,)
TRCell():New(oSection,"29",,"Equilíbrio Trabalho/Pessoal"		,,35,.F.,)
TRCell():New(oSection,"30",,"outros"							,,05,.F.,)
*/
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
oSection1:Cell("15") :SetBlock( { || aDados1[15] } )
oSection1:Cell("16") :SetBlock( { || aDados1[16] } )
oSection1:Cell("17") :SetBlock( { || aDados1[17] } )
oSection1:Cell("18") :SetBlock( { || aDados1[18] } )
oSection1:Cell("19") :SetBlock( { || aDados1[19] } )
oSection1:Cell("20") :SetBlock( { || aDados1[20] } )
oSection1:Cell("21") :SetBlock( { || aDados1[21] } )
oSection1:Cell("22") :SetBlock( { || aDados1[22] } )

/*
oSection1:Cell("20") :SetBlock( { || aDados1[20] } )
oSection1:Cell("21") :SetBlock( { || aDados1[21] } )
oSection1:Cell("22") :SetBlock( { || aDados1[22] } )
oSection1:Cell("23") :SetBlock( { || aDados1[23] } )
oSection1:Cell("24") :SetBlock( { || aDados1[24] } )
oSection1:Cell("25") :SetBlock( { || aDados1[25] } )
oSection1:Cell("26") :SetBlock( { || aDados1[26] } )
oSection1:Cell("27") :SetBlock( { || aDados1[27] } )
oSection1:Cell("28") :SetBlock( { || aDados1[28] } )
oSection1:Cell("29") :SetBlock( { || aDados1[29] } )
oSection1:Cell("30") :SetBlock( { || aDados1[30] } )
oSection1:Cell("31") :SetBlock( { || aDados1[31] } )
oSection1:Cell("32") :SetBlock( { || aDados1[32] } )
*/

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
		aDados1[21]	:= 	(cAliasLif)->PPC_COMO
		aDados1[22]	:= 	(cAliasLif)->PPC_DESC
/*
		aDados1[20]	:= 	(cAliasLif)->c20
		aDados1[21]	:= 	(cAliasLif)->c21
		aDados1[22]	:= 	(cAliasLif)->c22
		aDados1[23]	:= 	(cAliasLif)->c23
		aDados1[24]	:= 	(cAliasLif)->c24
		aDados1[25]	:= 	(cAliasLif)->c25
		aDados1[26]	:= 	(cAliasLif)->c26
		aDados1[27]	:= 	(cAliasLif)->c27
		aDados1[28]	:= 	(cAliasLif)->c28
		aDados1[29]	:= 	(cAliasLif)->c29
		aDados1[30]	:= 	(cAliasLif)->c30
		aDados1[31]	:= 	(cAliasLif)->c31
		aDados1[32]	:= 	(cAliasLif)->c32
*/

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
//cQuery += " CASE WHEN PPC.PPC_01  = 'F' THEN 'FEMININO'  ELSE CASE WHEN PPC.PPC_01  = 'M' THEN 'MASCULINO' ELSE ' 'END END  //2018
cQuery += " 	 CASE WHEN PPC.PPC_01  = '1' THEN '1-HOMEM'
cQuery += "	ELSE CASE WHEN PPC.PPC_01  = '2' THEN '2-MULHER'
cQuery += "	ELSE CASE WHEN PPC.PPC_01  = '3' THEN '3-Prefere não responder'
cQuery += " ELSE CASE WHEN PPC.PPC_01  = '4' THEN '4-Auto declara-se como' ELSE ' 'END END END END
cQuery += ' as "c20",
cQuery += " PPC_COMO,"
//cQuery += " CASE WHEN PPC.PPC_02  = '1' THEN '19 anos ou menos'
//cQuery += " ELSE CASE WHEN PPC.PPC_02  = '2' THEN '20 a 29 anos'
//cQuery += " ELSE CASE WHEN PPC.PPC_02  = '3' THEN '30 a 39 anos'
//cQuery += " ELSE CASE WHEN PPC.PPC_02  = '4' THEN '40 a 49 anos'
//cQuery += " ELSE CASE WHEN PPC.PPC_02  = '5' THEN '50 a 59 anos'
//cQuery += " ELSE CASE WHEN PPC.PPC_02  = '6' THEN '60 anos ou mais'
//cQuery += " ELSE ' ' END
//cQuery += " END END END END END
//cQuery += ' AS "c02"  ,
//cQuery += " CASE WHEN PPC.PPC_03  = '1' THEN 'Menos de 1 ano'
//cQuery += " ELSE CASE WHEN PPC.PPC_03  = '2' THEN '1 a 5 anos'
//cQuery += " ELSE CASE WHEN PPC.PPC_03  = '3' THEN '6 a 10 anos'
//cQuery += " ELSE CASE WHEN PPC.PPC_03  = '4' THEN '11 a 15 anos'
//cQuery += " ELSE CASE WHEN PPC.PPC_03  = '5' THEN '16 a 20 anos'
//cQuery += " ELSE CASE WHEN PPC.PPC_03  = '6' THEN 'Mais de 20 anos'
//cQuery += " ELSE ' ' END
//cQuery += " END END END END END
//cQuery += ' AS "c03"  ,

cQuery += ' PPC.PPC_EMP AS "c01",

cQuery += ' PPC.PPC_ANO AS "c02",

cQuery += ' PPC.PPC_19  AS "c03",

cQuery += "      CASE WHEN PPC.PPC_04  = '1' THEN '1-Concordo Totalmente'
cQuery += " ELSE CASE WHEN PPC.PPC_04  = '2' THEN '2-Concordo'
cQuery += " ELSE CASE WHEN PPC.PPC_04  = '3' THEN '3-Concordo Parcialmente'
cQuery += " ELSE CASE WHEN PPC.PPC_04  = '4' THEN '4-Discordo'
cQuery += " ELSE CASE WHEN PPC.PPC_04  = '5' THEN '5-Discordo Totalmente'
cQuery += " ELSE ' ' END END END END END
cQuery += ' AS "c04"  ,

cQuery += "      CASE WHEN PPC.PPC_05  = '1' THEN '1-Concordo Totalmente'
cQuery += " ELSE CASE WHEN PPC.PPC_05  = '2' THEN '2-Concordo'
cQuery += " ELSE CASE WHEN PPC.PPC_05  = '3' THEN '3-Concordo Parcialmente'
cQuery += " ELSE CASE WHEN PPC.PPC_05  = '4' THEN '4-Discordo'
cQuery += " ELSE CASE WHEN PPC.PPC_05  = '5' THEN '5-Discordo Totalmente'
cQuery += " ELSE ' ' END END END END END
cQuery += ' AS "c05" ,

cQuery += "      CASE WHEN PPC.PPC_06  = '1' THEN '1-Concordo Totalmente'
cQuery += " ELSE CASE WHEN PPC.PPC_06  = '2' THEN '2-Concordo'
cQuery += " ELSE CASE WHEN PPC.PPC_06  = '3' THEN '3-Concordo Parcialmente'
cQuery += " ELSE CASE WHEN PPC.PPC_06  = '4' THEN '4-Discordo'
cQuery += " ELSE CASE WHEN PPC.PPC_06  = '5' THEN '5-Discordo Totalmente'
cQuery += " ELSE ' ' END END END END END
cQuery += ' AS "c06"  ,

cQuery += "      CASE WHEN PPC.PPC_07  = '1' THEN '1-Concordo Totalmente'
cQuery += " ELSE CASE WHEN PPC.PPC_07  = '2' THEN '2-Concordo'
cQuery += " ELSE CASE WHEN PPC.PPC_07  = '3' THEN '3-Concordo Parcialmente'
cQuery += " ELSE CASE WHEN PPC.PPC_07  = '4' THEN '4-Discordo'
cQuery += " ELSE CASE WHEN PPC.PPC_07  = '5' THEN '5-Discordo Totalmente'
cQuery += " ELSE ' ' END END END END END
cQuery += ' AS "c07"   ,

cQuery += "      CASE WHEN PPC.PPC_08  = '1' THEN '1-Concordo Totalmente'
cQuery += " ELSE CASE WHEN PPC.PPC_08  = '2' THEN '2-Concordo'
cQuery += " ELSE CASE WHEN PPC.PPC_08  = '3' THEN '3-Concordo Parcialmente'
cQuery += " ELSE CASE WHEN PPC.PPC_08  = '4' THEN '4-Discordo'
cQuery += " ELSE CASE WHEN PPC.PPC_08  = '5' THEN '5-Discordo Totalmente'
cQuery += " ELSE ' ' END END END END END
cQuery += ' AS "c08"   ,

cQuery += "      CASE WHEN PPC.PPC_09  = '1' THEN '1-Concordo Totalmente'
cQuery += " ELSE CASE WHEN PPC.PPC_09  = '2' THEN '2-Concordo'
cQuery += " ELSE CASE WHEN PPC.PPC_09  = '3' THEN '3-Concordo Parcialmente'
cQuery += " ELSE CASE WHEN PPC.PPC_09  = '4' THEN '4-Discordo'
cQuery += " ELSE CASE WHEN PPC.PPC_09  = '5' THEN '5-Discordo Totalmente'
cQuery += " ELSE ' ' END END END END END
cQuery += ' AS "c09"   ,

cQuery += "      CASE WHEN PPC.PPC_10  = '1' THEN '1-Concordo Totalmente'
cQuery += " ELSE CASE WHEN PPC.PPC_10  = '2' THEN '2-Concordo'
cQuery += " ELSE CASE WHEN PPC.PPC_10  = '3' THEN '3-Concordo Parcialmente'
cQuery += " ELSE CASE WHEN PPC.PPC_10  = '4' THEN '4-Discordo'
cQuery += " ELSE CASE WHEN PPC.PPC_10  = '5' THEN '5-Discordo Totalmente'
cQuery += " ELSE ' ' END END END END END
cQuery += ' AS "c10"   ,

cQuery += "      CASE WHEN PPC.PPC_11  = '1' THEN '1-Concordo Totalmente'
cQuery += " ELSE CASE WHEN PPC.PPC_11  = '2' THEN '2-Concordo'
cQuery += " ELSE CASE WHEN PPC.PPC_11  = '3' THEN '3-Concordo Parcialmente'
cQuery += " ELSE CASE WHEN PPC.PPC_11  = '4' THEN '4-Discordo'
cQuery += " ELSE CASE WHEN PPC.PPC_11  = '5' THEN '5-Discordo Totalmente'
cQuery += " ELSE ' ' END END END END END
cQuery += ' AS "c11"   ,

cQuery += "      CASE WHEN PPC.PPC_12  = '1' THEN '1-Concordo Totalmente'
cQuery += " ELSE CASE WHEN PPC.PPC_12  = '2' THEN '2-Concordo'
cQuery += " ELSE CASE WHEN PPC.PPC_12  = '3' THEN '3-Concordo Parcialmente'
cQuery += " ELSE CASE WHEN PPC.PPC_12  = '4' THEN '4-Discordo'
cQuery += " ELSE CASE WHEN PPC.PPC_12  = '5' THEN '5-Discordo Totalmente'
cQuery += " ELSE ' ' END END END END END
cQuery += ' AS "c12"   ,

cQuery += "      CASE WHEN PPC.PPC_13  = '1' THEN '1-Concordo Totalmente'
cQuery += " ELSE CASE WHEN PPC.PPC_13  = '2' THEN '2-Concordo'
cQuery += " ELSE CASE WHEN PPC.PPC_13  = '3' THEN '3-Concordo Parcialmente'
cQuery += " ELSE CASE WHEN PPC.PPC_13  = '4' THEN '4-Discordo'
cQuery += " ELSE CASE WHEN PPC.PPC_13  = '5' THEN '5-Discordo Totalmente'
cQuery += " ELSE ' ' END END END END END
cQuery += ' AS "c13"   ,

cQuery += "      CASE WHEN PPC.PPC_14  = '1' THEN '1-Concordo Totalmente'
cQuery += " ELSE CASE WHEN PPC.PPC_14  = '2' THEN '2-Concordo'
cQuery += " ELSE CASE WHEN PPC.PPC_14  = '3' THEN '3-Concordo Parcialmente'
cQuery += " ELSE CASE WHEN PPC.PPC_14  = '4' THEN '4-Discordo'
cQuery += " ELSE CASE WHEN PPC.PPC_14  = '5' THEN '5-Discordo Totalmente'
cQuery += " ELSE ' ' END END END END END
cQuery += ' AS "c14"   ,

cQuery += "      CASE WHEN PPC.PPC_15  = '1' THEN '1-Concordo Totalmente'
cQuery += " ELSE CASE WHEN PPC.PPC_15  = '2' THEN '2-Concordo'
cQuery += " ELSE CASE WHEN PPC.PPC_15  = '3' THEN '3-Concordo Parcialmente'
cQuery += " ELSE CASE WHEN PPC.PPC_15  = '4' THEN '4-Discordo'
cQuery += " ELSE CASE WHEN PPC.PPC_15  = '5' THEN '5-Discordo Totalmente'
cQuery += " ELSE ' ' END END END END END
cQuery += ' AS "c15"   ,

cQuery += "      CASE WHEN PPC.PPC_20  = '1' THEN '1-Concordo Totalmente'
cQuery += " ELSE CASE WHEN PPC.PPC_20  = '2' THEN '2-Concordo'
cQuery += " ELSE CASE WHEN PPC.PPC_20  = '3' THEN '3-Concordo Parcialmente'
cQuery += " ELSE CASE WHEN PPC.PPC_20  = '4' THEN '4-Discordo'
cQuery += " ELSE CASE WHEN PPC.PPC_20  = '5' THEN '5-Discordo Totalmente'
cQuery += " ELSE ' ' END END END END END
cQuery += ' AS "c16"   ,

cQuery += "      CASE WHEN PPC.PPC_21  = '1' THEN '1-Concordo Totalmente'
cQuery += " ELSE CASE WHEN PPC.PPC_21  = '2' THEN '2-Concordo'
cQuery += " ELSE CASE WHEN PPC.PPC_21  = '3' THEN '3-Concordo Parcialmente'
cQuery += " ELSE CASE WHEN PPC.PPC_21  = '4' THEN '4-Discordo'
cQuery += " ELSE CASE WHEN PPC.PPC_21  = '5' THEN '5-Discordo Totalmente'
cQuery += " ELSE ' ' END END END END END
cQuery += ' AS "c17"   ,

cQuery += "      CASE WHEN PPC.PPC_22  = 'S' THEN 'S-Sim'
cQuery += " ELSE CASE WHEN PPC.PPC_22  = 'N' THEN 'N-Não'
cQuery += " ELSE ' ' END END
cQuery += ' AS "c18"   ,

cQuery += "      CASE WHEN PPC.PPC_23  = 'S' THEN 'S-Sim'
cQuery += " ELSE CASE WHEN PPC.PPC_23  = 'N' THEN 'N-Não'
cQuery += " ELSE ' ' END END
cQuery += ' AS "c19" ,
cQuery += " utl_raw.cast_to_varchar2(dbms_lob.substr(PPC_DESC)) PPC_DESC "

/*
cQuery += ' PPC.PPC_21 AS "c17", PPC.PPC_22 AS "c18",
cQuery += " PPC.PPC_16
cQuery += ' AS "c19",
cQuery += " CASE WHEN PPC.PPC_17  like '%1/%' THEN 'Crescimento da Carreira'
cQuery += " ELSE ' ' END
cQuery += ' AS "c20"    ,
cQuery += " CASE WHEN PPC.PPC_17  like '%2/%' THEN 'Comunicações'
cQuery += " ELSE ' ' END
cQuery += ' AS "c21"    ,
cQuery += " CASE WHEN PPC.PPC_17  like '%3/%'  THEN 'Valores da Empresa'
cQuery += " ELSE ' ' END
cQuery += ' AS "c22"    ,
cQuery += " CASE WHEN PPC.PPC_17  like '%4/%' THEN 'Liderança'
cQuery += " ELSE ' ' END
cQuery += ' AS "c23"    ,
cQuery += " CASE WHEN PPC.PPC_17  like '%5/%' THEN 'Meu Trabalho'
cQuery += " ELSE ' ' END
cQuery += ' AS "c24"    ,
cQuery += " CASE WHEN PPC.PPC_17  like '%6/%' THEN 'Processos/Políticas/Procedimentos'
cQuery += " ELSE ' ' END
cQuery += ' AS "c25"    ,
cQuery += " CASE WHEN PPC.PPC_17  like '%7/%'  THEN 'Segurança'
cQuery += " ELSE ' ' END
cQuery += ' AS "c26"    ,
cQuery += " CASE WHEN PPC.PPC_17  like '%8/%' THEN 'Pessoal'
cQuery += " ELSE ' ' END
cQuery += ' AS "c27"    ,
cQuery += " CASE WHEN PPC.PPC_17  like'%9/%' THEN 'Estratégia'
cQuery += " ELSE ' ' END
cQuery += ' AS "c28"    ,
cQuery += " CASE WHEN PPC.PPC_17  like '%10/%' THEN 'Equilíbrio entre Trabalho/Vida Pessoal'
cQuery += " ELSE ' ' END
cQuery += ' AS "c29",
cQuery += " trim(UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(PPC_18, 3200,1)))
cQuery += ' AS "c30"
*/

cQuery += " FROM " + RetSqlName("PPC") + " PPC "
cQuery += " WHERE PPC.D_E_L_E_T_ = ' ' AND PPC_ANO = '" + StrZero(Year(dDataBase),4) + "' "

//cQuery := ChangeQuery(cQuery)

If Select(cAliasLif) > 0
	(cAliasLif)->(dbCloseArea())
EndIf

dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

Return()


