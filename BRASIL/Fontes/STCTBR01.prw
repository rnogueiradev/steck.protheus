#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STCTBR01	ºAutor  ³Renato Nogueira     º Data ³  25/11/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Relatório de produtos por nota 			    	          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function STCTBR01()

Local oReport        

PutSx1("STCTBR01", "01","Data de?"  ,"","","mv_ch1","D",8,0,0,"G","",		,"","","mv_par01","","","","","","","","","","","","","","","","")
PutSx1("STCTBR01", "02","Data ate?" ,"","","mv_ch2","D",8,0,0,"G","",		,"","","mv_par02","","","","","","","","","","","","","","","","")                   

oReport		:= ReportDef()
oReport		:PrintDialog()

Return

Static Function ReportDef()

Local oReport
Local oSection

oReport := TReport():New("STCTBR01","RELATÓRIO DE PRODUTOS POR NOTA","STCTBR01",{|oReport| ReportPrint(oReport)},"Este programa irá imprimir um relatório de produtos por nota fiscal.")

Pergunte("STCTBR01",.F.)

oSection := TRSection():New(oReport,"CADASTRO DOS PRODUTOS",{"SB1"})

TRCell():New(oSection,"CODIGO"    ,"SD2","CODIGO"        			,"@!",15)
TRCell():New(oSection,"DESC"      ,"SB1","DESCRIÇÃO"    	    	,"@!",50)
TRCell():New(oSection,"GRUPO"     ,"SB1","GRUPO" 				    ,"@!",4)
TRCell():New(oSection,"TIPO"      ,"SB1","TIPO" 				    ,"@!",2)
TRCell():New(oSection,"QUANT"     ,"SD2","QUANTIDADE"			    ,PesqPict("SD2","D2_QUANT",11),)
TRCell():New(oSection,"PRCVEN"    ,"SD2","PRECO VENDA"			    ,PesqPict("SD2","D2_PRCVEN",14),)
TRCell():New(oSection,"TOTAL"     ,"SD2","TOTAL"				    ,PesqPict("SD2","D2_TOTAL",14),)
TRCell():New(oSection,"IPIVAL"    ,"SD2","VAL IPI"				    ,PesqPict("SD2","D2_VALIPI",14),)
TRCell():New(oSection,"ICMSVAL"   ,"SD2","VAL ICMS"				    ,PesqPict("SD2","D2_VALIPI",14),)
TRCell():New(oSection,"TES"       ,"SD2","TES"					    ,"@!",3)
TRCell():New(oSection,"CFOP"      ,"SD2","CFOP"					    ,"@!",5)
TRCell():New(oSection,"CLIENTE"   ,"SD2","CLIENTE"				    ,"@!",6)
TRCell():New(oSection,"DOC"       ,"SD2","DOCUMENTO"			    ,"@!",9)
TRCell():New(oSection,"TP"        ,"SD2","TIPO"					    ,"@!",2)
TRCell():New(oSection,"DTEMIS"    ,"SD2","DATA DE EMISSÃO"		    ,"@!",10)
TRCell():New(oSection,"EST"       ,"SD2","ESTADO"					,"@!",2)
TRCell():New(oSection,"BASEICM"   ,"SD2","BASE ICMS"				,PesqPict("SD2","D2_BASEICM",16),)
TRCell():New(oSection,"BASIMP5"   ,"SD2","BASE IMP 5"				,PesqPict("SD2","D2_BASIMP5",14),)
TRCell():New(oSection,"BASIMP6"   ,"SD2","BASE IMP 6"				,PesqPict("SD2","D2_BASIMP6",14),)
TRCell():New(oSection,"VALIMP5"   ,"SD2","VALOR IMP 5"				,PesqPict("SD2","D2_VALIMP5",14),)
TRCell():New(oSection,"VALIMP6"   ,"SD2","VALOR IMP 6"				,PesqPict("SD2","D2_VALIMP6",14),)
TRCell():New(oSection,"ALQIMP5"   ,"SD2","ALIQ IMP 5"				,PesqPict("SD2","D2_ALQIMP5",6),)
TRCell():New(oSection,"ALQIMP6"   ,"SD2","ALIQ IMP 6"				,PesqPict("SD2","D2_ALQIMP6",6),)
TRCell():New(oSection,"TOTGERAL"  ,"SD2","TOTAL SEM IMPOSTOS"		,PesqPict("SD2","D2_TOTAL",14),)
TRCell():New(oSection,"RETICMS"   ,"SD2","ICMST RET"				,PesqPict("SD2","D2_ICMSRET",14),)
TRCell():New(oSection,"PRCTAB"    ,"SD2","PRECO TABELA"			    ,PesqPict("SD2","D2_PRUNIT",14),)
TRCell():New(oSection,"CUSTO"     ,"SD2","CUSTO"				    ,PesqPict("SD2","D2_CUSTO1",14),)

oSection:SetHeaderSection(.T.)
oSection:Setnofilter("SB1")
oSection:Setnofilter("SD2")

Return oReport

Static Function ReportPrint(oReport)

Local oSection	:= oReport:Section(1)
Local cQuery 	:= ""
Local cAlias 	:= "QRYTEMP"
Local aDados[27]
Local _aDados	:= {}

oSection:Cell("CODIGO")  	 :SetBlock( { || aDados[1] } )
oSection:Cell("DESC")    	 :SetBlock( { || aDados[2] } )
oSection:Cell("GRUPO")  	 :SetBlock( { || aDados[3] } )
oSection:Cell("TIPO")  	     :SetBlock( { || aDados[4] } )
oSection:Cell("QUANT")  	 :SetBlock( { || aDados[5] } )
oSection:Cell("PRCVEN")  	 :SetBlock( { || aDados[6] } )
oSection:Cell("TOTAL")  	 :SetBlock( { || aDados[7] } )
oSection:Cell("IPIVAL")  	 :SetBlock( { || aDados[8] } )
oSection:Cell("ICMSVAL")  	 :SetBlock( { || aDados[9] } )
oSection:Cell("TES")  		 :SetBlock( { || aDados[10] } )
oSection:Cell("CFOP")  	  	 :SetBlock( { || aDados[11] } )
oSection:Cell("CLIENTE")  	 :SetBlock( { || aDados[12] } )
oSection:Cell("DOC")  		 :SetBlock( { || aDados[13] } )
oSection:Cell("TP")  		 :SetBlock( { || aDados[14] } )
oSection:Cell("DTEMIS")  	 :SetBlock( { || aDados[15] } )
oSection:Cell("EST")  		 :SetBlock( { || aDados[16] } )
oSection:Cell("BASEICM")  	 :SetBlock( { || aDados[17] } )
oSection:Cell("BASIMP5") 	 :SetBlock( { || aDados[18] } )
oSection:Cell("BASIMP6") 	 :SetBlock( { || aDados[19] } )
oSection:Cell("VALIMP5") 	 :SetBlock( { || aDados[20] } )
oSection:Cell("VALIMP6") 	 :SetBlock( { || aDados[21] } )
oSection:Cell("ALQIMP5") 	 :SetBlock( { || aDados[22] } )
oSection:Cell("ALQIMP6") 	 :SetBlock( { || aDados[23] } )
oSection:Cell("TOTGERAL")	 :SetBlock( { || aDados[24] } )
oSection:Cell("RETICMS")	 :SetBlock( { || aDados[25] } )
oSection:Cell("PRCTAB")	 	 :SetBlock( { || aDados[26] } )
oSection:Cell("CUSTO")	 	 :SetBlock( { || aDados[27] } )

oReport:SetTitle("Lista de produtos por nota fiscal")// Titulo do relatório

cQuery := " SELECT D2_COD, B1_DESC, B1_GRUPO, B1_TIPO, D2_QUANT, D2_PRCVEN, D2_TOTAL, D2_VALIPI, D2_VALICM, D2_TES, D2_CF, "
cQuery += " D2_CLIENTE, D2_DOC, D2_TP, D2_EMISSAO , D2_EST, D2_BASEICM, D2_BASIMP5, D2_BASIMP6, D2_VALIMP5, D2_VALIMP6, D2_ALQIMP5, "
cQuery += " D2_ALQIMP6, D2_TOTAL-D2_VALIPI-D2_VALICM-D2_VALIMP5-D2_VALIMP6 TOTGERAL, D2_ICMSRET, D2_PRUNIT, D2_CUSTO1 "
cQuery += " FROM " +RetSqlName("SD2")+ " D2 "
cQuery += " LEFT JOIN " +RetSqlName("SB1")+ " B1 " 
cQuery += " ON D2_COD=B1_COD "
cQuery += " WHERE D2.D_E_L_E_T_=' ' AND B1.D_E_L_E_T_=' ' AND D2_EMISSAO BETWEEN '"+DTOS(mv_par01)+"' AND '"+DTOS(mv_par02)+"' "
cQuery += " ORDER BY D2_EMISSAO, D2_DOC, D2_COD "

If !Empty(Select(cAlias))
	DbSelectArea(cAlias)
	(cAlias)->(dbCloseArea())
Endif

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

oReport:SetMeter(0)
aFill(aDados,nil)
oSection:Init()

dbSelectArea(cAlias)
(cAlias)->(dbGoTop())

While !(cAlias)->(Eof())

	aDados[1]	:=	(cAlias)->D2_COD
	aDados[2]	:=	(cAlias)->B1_DESC
	aDados[3]	:=	(cAlias)->B1_GRUPO
	aDados[4]	:=	(cAlias)->B1_TIPO
	aDados[5]	:=	(cAlias)->D2_QUANT
	aDados[6]	:=	(cAlias)->D2_PRCVEN
	aDados[7]	:=	(cAlias)->D2_TOTAL
	aDados[8]	:=	(cAlias)->D2_VALIPI
	aDados[9]	:=	(cAlias)->D2_VALICM
	aDados[10]	:=	(cAlias)->D2_TES
	aDados[11]	:=	(cAlias)->D2_CF
	aDados[12]	:=	(cAlias)->D2_CLIENTE
	aDados[13]	:=	(cAlias)->D2_DOC
	aDados[14]	:=	(cAlias)->D2_TP
	aDados[15]	:=	STOD((cAlias)->D2_EMISSAO)
	aDados[16]	:=	(cAlias)->D2_EST
	aDados[17]	:=	(cAlias)->D2_BASEICM
	aDados[18]	:=	(cAlias)->D2_BASIMP5
	aDados[19]	:=	(cAlias)->D2_BASIMP6
	aDados[20]	:=	(cAlias)->D2_VALIMP5
	aDados[21]	:=	(cAlias)->D2_VALIMP6
	aDados[22]	:=	(cAlias)->D2_ALQIMP5
	aDados[23]	:=	(cAlias)->D2_ALQIMP6
	aDados[24]	:=	(cAlias)->TOTGERAL
	aDados[25]	:=	(cAlias)->D2_ICMSRET
	aDados[26]	:=  (cAlias)->D2_PRUNIT
	aDados[27]	:=	(cAlias)->D2_CUSTO1

	oSection:PrintLine()
	aFill(aDados,nil)

	(cAlias)->(DbSkip())
	
EndDo                    

DbSelectArea(cAlias)
(cAlias)->(dbCloseArea())

Return oReport