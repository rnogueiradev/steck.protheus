#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  RSTFATB1   ºAutor  ³Robson Mazzarotto º Data ³  22/11/17     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Relatorio de contagem do Inventario Rotativo				 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*-----------------------------*
User Function RSTFATB7()
*-----------------------------*
	Local   oReport
	Private cPerg 			:= "RFATB7"
	Private cTime           := Time()
	Private cHora           := SUBSTR(cTime, 1, 2)
	Private cMinutos    	:= SUBSTR(cTime, 4, 2)
	Private cSegundos   	:= SUBSTR(cTime, 7, 2)
	Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos
	Private lXlsHeader      := .f.
	Private lXmlEndRow      := .f.
	Private cPergTit 		:= cAliasLif


	PutSx1(cPerg, "01", "Mestre de:" 	,"Mestre de:" 	 ,"Mestre de:" 		,"mv_ch1","C",09,0,0,"G","","CBA1" ,"","","mv_par01","","","","","","","","","","","","","","","","")
	PutSx1(cPerg, "02", "Mestre ate:" 	,"Mestre ate:" 	 ,"Mestre ate:" 		,"mv_ch2","C",09,0,0,"G","","CBA1" ,"","","mv_par02","","","","","","","","","","","","","","","","")

	oReport		:= ReportDef()
	oReport:PrintDialog()

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ReportDef    ºAutor  ³Robson Mazzarottoº Data ³  22/11/17    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Relatorio de contagem do Inventario Rotativo				º±±
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

	oReport := TReport():New(cPergTit,"Relatorio de contagem do Inventario Rotativo",cPerg,{|oReport| ReportPrint(oReport)},"Este programa irá imprimir a contagem do Inventario Rotativo")

	Pergunte(cPerg,.F.)

	oSection := TRSection():New(oReport,"Contagem do Inventario Rotativo",{"CBA"})


TRCell():New(oSection,"01",,"FILIAL"		,,10,.F.,)
TRCell():New(oSection,"02",,"INVENTARIO"	,,30,.F.,)
TRCell():New(oSection,"03",,"DATA" 		 	,,30,.F.,)
TRCell():New(oSection,"04",,"ARMAZEM" 	    ,,30,.F.,)
TRCell():New(oSection,"05",,"ENDERECO"	    ,,30,.F.,)
TRCell():New(oSection,"06",,"PRODUTO"		,,30,.F.,)
TRCell():New(oSection,"25",,"DESC PROD"		,,60,.F.,)
TRCell():New(oSection,"07",,"STATUS"		,,30,.F.,)
TRCell():New(oSection,"08",,"USER CT1"		,,30,.F.,)
TRCell():New(oSection,"09",,"NOME CT1"  	,,90,.F.,)
TRCell():New(oSection,"10",,"QTD 1 CONT."	,,30,.F.,)
TRCell():New(oSection,"11",,"USER CT2"		,,30,.F.,)
TRCell():New(oSection,"12",,"NOME CT2"		,,90,.F.,)
TRCell():New(oSection,"13",,"QTD 2 CONT."	,,30,.F.,)
TRCell():New(oSection,"14",,"USER CT3"		,,30,.F.,)
TRCell():New(oSection,"15",,"NOME CT3"		,,90,.F.,)
TRCell():New(oSection,"16",,"QTD 3 CONT."	,,30,.F.,)
TRCell():New(oSection,"17",,"CONTAGEM OK"	,,30,.F.,)
TRCell():New(oSection,"18",,"ROTATIVO" 		,,10,.F.,)
TRCell():New(oSection,"19",,"QTD ATU FOTO" 	,,30,.F.,)
TRCell():New(oSection,"20",,"QTD SEP FOTO" 	,,30,.F.,)
TRCell():New(oSection,"21",,"AJUSTE"		,,30,.F.,)
TRCell():New(oSection,"22",,"CUSTO 1a M."	,,60,.F.,)
TRCell():New(oSection,"23",,"CUSTO TOTAL AJUSTE"	,,60,.F.,)
TRCell():New(oSection,"24",,"Clas FRM"		,,03,.F.,)
TRCell():New(oSection,"26",,"BALANCA"		,,03,.F.,)

	oSection:SetHeaderSection(.t.)
	oSection:Setnofilter("CBA")

Return oReport
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ReportPrint  ºAutor  ³Robson Mazzarottoº Data ³  06/04/17    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Relatorio de tarefas em Execução de Acao Corretiva x Acoesº±±
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
	oSection1:Cell("23") :SetBlock( { || aDados1[23] } )
	oSection1:Cell("24") :SetBlock( { || aDados1[24] } )
	oSection1:Cell("25") :SetBlock( { || aDados1[25] } )
	oSection1:Cell("26") :SetBlock( { || aDados1[26] } )

	oReport:SetTitle("Contagem do Inventario Rotativo")// Titulo do relatório

	oReport:SetMeter(0)
	aFill(aDados,nil)
	aFill(aDados1,nil)
	oSection:Init()


	Processa({|| StQuery(  ) },"Compondo Relatorio")

	DbSelectArea(cAliasLif)
	(cAliasLif)->(DbGoTop())
	If  Select(cAliasLif) > 0

		While 	(cAliasLif)->(!Eof())

			aDados1[01]	:=  (cAliasLif)->CBA_FILIAL
			aDados1[02]	:=  (cAliasLif)->CBA_CODINV
			aDados1[03]	:=  (cAliasLif)->PRAZO
			aDados1[04]	:=  (cAliasLif)->CBA_LOCAL
			aDados1[05]	:=  (cAliasLif)->CBA_LOCALI
			aDados1[06]	:=	(cAliasLif)->CBA_PROD

			IF (cAliasLif)->CBA_STATUS = "0"
			aDados1[07]	:= 	"Nao iniciado"
			ELSEIF (cAliasLif)->CBA_STATUS = "1"
			aDados1[07]	:= 	"Em andamento"
			ELSEIF (cAliasLif)->CBA_STATUS = "2"
			aDados1[07]	:= 	"Em Pausa"
			ELSEIF (cAliasLif)->CBA_STATUS = "3"
			aDados1[07]	:= 	"Contado"
			ELSEIF (cAliasLif)->CBA_STATUS = "4"
			aDados1[07]	:= 	"Finalizado"
			ELSEIF (cAliasLif)->CBA_STATUS = "5"
			aDados1[07]	:= 	"Processado"
			ELSEIF (cAliasLif)->CBA_STATUS = "6"
			aDados1[07]	:= 	"Com Problemas"
			ENDIF
			aDados1[08]	:= 	(cAliasLif)->CBA_XUSCT1
			aDados1[09]	:= 	ALLTRIM(USRRETNAME((cAliasLif)->CBA_XUSCT1))
			aDados1[10]	:= 	(cAliasLif)->CBA_XQTCT1
			aDados1[11]	:= 	(cAliasLif)->CBA_XUSCT2
			aDados1[12]	:= 	ALLTRIM(USRRETNAME((cAliasLif)->CBA_XUSCT2))
			aDados1[13]	:= 	(cAliasLif)->CBA_XQTCT2
			aDados1[14]	:= 	(cAliasLif)->CBA_XUSCT3
			aDados1[15]	:= 	ALLTRIM(USRRETNAME((cAliasLif)->CBA_XUSCT3))
			aDados1[16]	:= 	(cAliasLif)->CBA_XQTCT3
			aDados1[17]	:= 	(cAliasLif)->CBA_XQTOK
			aDados1[18]	:= 	(cAliasLif)->CBA_XROTAT
			aDados1[19]	:= 	(cAliasLif)->CBA_XQATU
			aDados1[20]	:= 	(cAliasLif)->CBA_XQSEP
			aDados1[21]	:= 	(cAliasLif)->CBA_XQTOK - (cAliasLif)->CBA_XQATU
			aDados1[22]	:= 	Posicione("SB2",1,xFilial('SB2')+(cAliasLif)->CBA_PROD,"B2_CMFIM1")
			aDados1[23]	:= 	aDados1[21] * aDados1[22]
			aDados1[24]	:= 	(cAliasLif)->B1_XFMR
			aDados1[25]	:= 	Posicione("SB1",1,xFilial('SB1')+(cAliasLif)->CBA_PROD,"B1_DESC")
			aDados1[26]	:= 	Iif((cAliasLif)->CBA_XBALAN = "1","SIM","NAO")

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


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  StQuery      ºAutor  ³Robson Mazzarottoº Data ³  06/04/17    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Relatorio de tarefas em Execução de Acao Corretiva x Acoesº±±
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
	cQuery += " CBA_FILIAL,
	cQuery += " CBA_CODINV,
	cQuery += " SUBSTR(CBA_DATA,7,2)||'/'|| SUBSTR(CBA_DATA,5,2)||'/'|| SUBSTR(CBA_DATA,1,4) AS PRAZO ,
	cQuery += " CBA_LOCAL,
	cQuery += " CBA_LOCALI,
	cQuery += " CBA_PROD,
	cQuery += " CBA_STATUS,
	cQuery += " CBA_XUSCT1,
	cQuery += " CBA_XQTCT1,
	cQuery += " CBA_XUSCT2,
	cQuery += " CBA_XQTCT2,
	cQuery += " CBA_XUSCT3,
	cQuery += " CBA_XQTCT3,
	cQuery += " CBA_XQTOK,
	cQuery += " CBA_XROTAT,
	cQuery += " CBA_XQATU,
	cQuery += " CBA_XQSEP,
	cQuery += " CBA_XBALAN,
	cQuery += " SB1.B1_XFMR

	cQuery += " FROM "+RetSqlName("CBA")+" CBA
	//>> Chamado 007849 - Everson Santana - 21/08/2018
	cQuery += " 	LEFT JOIN "+RetSqlName("SB1")+" SB1 "
	cQuery += "			ON SB1.B1_COD = CBA.CBA_PROD "
	cQuery += "			AND SB1.D_E_L_E_T_ = ' ' "
	//<<
	cQuery += " WHERE CBA.D_E_L_E_T_ = ' '
	cQuery += " AND CBA.CBA_CODINV BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'
	cQuery += " ORDER BY CBA_CODINV

	//cQuery += " AND QI5.QI5_TPACAO BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"'
	//cQuery += " AND QI5.QI5_MAT BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"'
	//cQuery += " AND QI5.QI5_PRAZO BETWEEN '"+Dtos(MV_PAR07)+"' AND '"+Dtos(MV_PAR08)+"'
	//cQuery += " AND QI5.QI5_STATUS BETWEEN '"+MV_PAR09+"' AND '"+MV_PAR10+"'


	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

Return()

