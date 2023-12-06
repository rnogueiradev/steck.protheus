#Include "Protheus.ch" 
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบPrograma  RSTFAT91     บAutor  ณRenato Nogueira บ Data ณ  24/08/15     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRelat๓rio de pv com falta - exporta็ใo	                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
/*
<<< Altera็ใo >>>
Chamados.: 20210910018585 / 20211116024577
Descri็ใo: Inclusใo do campo EE8_XPOCLI "N๚mero do PO do Cliente"
Analista.: Marcelo Klopfer Leme - SIGAMAT
Data.....: 30/09/2021

*/
User Function RSTFAT91()
	Local   oReport
	Private cPerg 			:= "RFAT91"
	Private cTime           := Time()
	Private cHora           := Substr(cTime, 1, 2)
	Private cMinutos    	:= Substr(cTime, 4, 2)
	Private cSegundos   	:= Substr(cTime, 7, 2)
	Private cAliasLif   	:= cPerg + cHora + cMinutos + cSegundos
	Private lXlsHeader      := .F.
	Private lXmlEndRow      := .F.
	Private cPergTit 		:= cAliasLif

	PutSx1(cPerg, "01", "Da Emissao:"	,"Da Emissao:"	 ,"Da Emissao:"		,"mv_ch1","D" ,08 ,0 ,0 , "G" ,"" ,""	 ,"" ,""  ,"mv_par01",""         ,"" ,"" ,"" ,""      	 ,"" ,"" ,""      ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"")
	PutSx1(cPerg, "02", "At้ a Emissao:","At้ a Emissao:","At้ a Emissao:" 	,"mv_ch2","D" ,08 ,0 ,0 , "G" ,"" ,""	 ,"" ,""  ,"mv_par02",""         ,"" ,"" ,"" ,""      	 ,"" ,"" ,""      ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"")
	PutSx1(cPerg, "03", "Produto de:"	,"Produto de:"	 ,"Produto de:" 	,"mv_ch3","C" ,15 ,0 ,0 , "G" ,"" ,"SB1" ,"" ,""  ,"mv_par03",""         ,"" ,"" ,"" ,""      	 ,"" ,"" ,""      ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"")
	PutSx1(cPerg, "04", "Produto ate:"	,"Produto ate:"	 ,"Produto ate:" 	,"mv_ch4","C" ,15 ,0 ,0 , "G" ,"" ,"SB1" ,"" ,""  ,"mv_par04",""         ,"" ,"" ,"" ,""      	 ,"" ,"" ,""      ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"")
	PutSx1(cPerg, "05", "Cr้dito: ?"	,"Cr้dito: ?"	 ,"Cr้dito: ?" 		,"mv_ch5","C" ,1  ,0 ,0 , "C" ,"" ,""	 ,"" ,"S" ,"mv_par05","Bloqueado","" ,"" ,"" ,"Liberado" ,"" ,"" ,"Ambos" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"" ,"")

	oReport	:= ReportDef()
	oReport:PrintDialog()

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบPrograma  ReportDef    บAutor  ณGiovani Zago    บ Data ณ  04/07/15     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relatorio MMG 							                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function ReportDef()

	Local oReport
	Local oSection

	oReport := TReport():New(cPergTit,"RELATำRIO PV COM FALTA - EX",cPerg,{|oReport| ReportPrint(oReport)},"Este programa irแ imprimir um relat๓rio de pv com falta de exporta็ใo")

	Pergunte(cPerg,.F.)

	oSection := TRSection():New(oReport,"SC6",{"SC6"})

	TRCell():New(oSection,"1_FILIAL"		,,"FILIAL"			,,02,.F.,)
	TRCell():New(oSection,"2_PEDIDO"		,,"PEDIDO"			,,09,.F.,)
	TRCell():New(oSection,"3_NOME"			,,"CLIENTE"			,,40,.F.,)
	TRCell():New(oSection,"21_FORPAD"   ,,"FORN PADRAO"     ,,6,.F.,) //Chamado 007059 - Everson Santana 19.03.18	
	TRCell():New(oSection,"4_EMISSAO"		,,"EMISSAO"			,,10,.F.,)
	TRCell():New(oSection,"5_ITEM"			,,"ITEM"			,,02,.F.,)
	TRCell():New(oSection,"6_COD"				,,"CODIGO"			,,15,.F.,)
	TRCell():New(oSection,"7_DESC"			,,"DESCRICAO"		,,50,.F.,)
	TRCell():New(oSection,"8_CLAPROD"		,,"CLASSIFICACAO"	,,1,.F.,)
	TRCell():New(oSection,"9_SLDPV"			,,"SALDO PV"		,"@E 99,999,999.99",14)
	TRCell():New(oSection,"10_QTDFAL"		,,"QTDE FALTA"		,"@E 99,999,999.99",14)
	TRCell():New(oSection,"11_VLRFAT"		,,"VALOR FALTA"		,"@E 99,999,999.99",14)
	TRCell():New(oSection,"12_TOTFAT"		,,"TOTAL FALTA"		,"@E 99,999,999.99",14)
	TRCell():New(oSection,"13_QTDRES"		,,"QTDE RESERV"		,"@E 99,999,999.99",14)
	TRCell():New(oSection,"14_VLRRES"		,,"VALOR RESERV"	,"@E 99,999,999.99",14)
	TRCell():New(oSection,"15_TOTRES"		,,"TOTAL RESERV"	,"@E 99,999,999.99",14)
	TRCell():New(oSection,"16_PERRES"		,,"PERC RESERV"		,"@E 99,999,999.99",14)
	TRCell():New(oSection,"17_ENTREG"		,,"ENTREGA"			,,10,.F.,)
	TRCell():New(oSection,"18_ENTREG2"		,,"ENTREGA2"		,,10,.F.,)
	//TRCell():New(oSection,"18_ENTREG2"		,,"ENTREGA2"			,,10,.F.,)
	//TRCell():New(oSection,"18_ENTREG2"		,,"ENTREGA2"			,,10,.F.,)
	TRCell():New(oSection,"19_SLD_MMG"   ,,"Qtde MMG SP"     ,"@E 99,999,999.99",14)
	TRCell():New(oSection,"20_SLD_MAO"   ,,"Qtde MMG MAO"    ,"@E 99,999,999.99",14)
	TRCell():New(oSection,"22_POCLI"     ,,"P.O. Cliente"    ,"@!",15)
	
	
	oSection:SetHeaderSection(.t.)
	oSection:Setnofilter("SC6")

Return oReport

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบPrograma  ReportPrint  บAutor  ณGiovani Zago    บ Data ณ  04/07/15     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relatorio MMG 							                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function ReportPrint(oReport)

	Local oSection	:= oReport:Section(1)
	Local oSection1	:= oReport:Section(1)
	Local aDados[2]
	Local aDados1[99]

	oSection1:Cell('1_FILIAL')  :SetBlock( { || aDados1[01] } )
	oSection1:Cell('2_PEDIDO')  :SetBlock( { || aDados1[02] } )
	oSection1:Cell('3_NOME')  	:SetBlock( { || aDados1[03] } )
	oSection1:Cell('4_EMISSAO') :SetBlock( { || aDados1[04] } )
	oSection1:Cell('5_ITEM')  	:SetBlock( { || aDados1[05] } )
	oSection1:Cell('6_COD')  	:SetBlock( { || aDados1[06] } )
	oSection1:Cell('7_DESC')  	:SetBlock( { || aDados1[07] } )
	oSection1:Cell('8_CLAPROD') :SetBlock( { || aDados1[08] } )
	oSection1:Cell('9_SLDPV')  	:SetBlock( { || aDados1[09] } )
	oSection1:Cell('10_QTDFAL') :SetBlock( { || aDados1[10] } )
	oSection1:Cell('11_VLRFAT') :SetBlock( { || aDados1[11] } )
	oSection1:Cell('12_TOTFAT') :SetBlock( { || aDados1[12] } )
	oSection1:Cell('13_QTDRES') :SetBlock( { || aDados1[13] } )
	oSection1:Cell('14_VLRRES') :SetBlock( { || aDados1[14] } )
	oSection1:Cell('15_TOTRES') :SetBlock( { || aDados1[15] } )
	oSection1:Cell('16_PERRES') :SetBlock( { || aDados1[16] } )
	oSection1:Cell('17_ENTREG') :SetBlock( { || aDados1[17] } )
	oSection1:Cell('18_ENTREG2'):SetBlock( { || aDados1[18] } )
	oSection1:Cell('19_SLD_MMG'):SetBlock( { || aDados1[19] } )
	oSection1:Cell('20_SLD_MAO'):SetBlock( { || aDados1[20] } )
	oSection1:Cell('21_FORPAD') :SetBlock( { || aDados1[21] } )
	oSection1:Cell('22_POCLI') 	:SetBlock( { || aDados1[22] } )
	
	oReport:SetTitle("SC6")// Titulo do relat๓rio

	oReport:SetMeter(0)
	aFill(aDados,Nil)
	aFill(aDados1,Nil)
	oSection:Init()

	Processa({|| StQuery(  ) },"Compondo Relatorio")

	DbSelectArea(cAliasLif)
	(cAliasLif)->( dbGoTop() )
	If Select(cAliasLif) > 0
		While (cAliasLif)->( !Eof() )

			aDados1[01]	:=  (cAliasLif)->C6_FILIAL
			aDados1[02]	:=  (cAliasLif)->C6_NUM
			aDados1[03]	:=  (cAliasLif)->A1_NOME
			aDados1[04]	:=  DtoC(StoD((cAliasLif)->C5_EMISSAO))
			aDados1[05]	:=  (cAliasLif)->C6_ITEM
			aDados1[06]	:=	(cAliasLif)->C6_PRODUTO
			aDados1[07]	:= 	(cAliasLif)->B1_DESC
			aDados1[08]	:= 	(cAliasLif)->B1_CLAPROD
			aDados1[09]	:=	(cAliasLif)->SALDOPV
			aDados1[10]	:=	(cAliasLif)->QTDFALTA
			aDados1[11]	:=	(cAliasLif)->VLRFALTA
			aDados1[12]	:=	(cAliasLif)->TOTALFALTA
			aDados1[13]	:=	(cAliasLif)->QTDRES
			aDados1[14]	:=	(cAliasLif)->VLRRES
			aDados1[15]	:=	(cAliasLif)->TOTALRESERVA
			aDados1[16]	:=	(cAliasLif)->PERCRES
			aDados1[17]	:=	DtoC(StoD((cAliasLif)->C6_ENTRE1))
			aDados1[18]	:=	DtoC(StoD((cAliasLif)->C6_ZENTRE2))
			aDados1[19]	:=	(cAliasLif)->A2_SLD_MMG
			aDados1[20]	:=	(cAliasLif)->A2_SLD_MAO
			aDados1[21]	:=	(cAliasLif)->FORPAD

			aEE7 := GetArea()
			//// Posiciona na tabela EE7 para buscar o numero do PO
			DbSelectArea("EE8")
			dbSelectArea("EE7")
			EE7->(DBSETORDER(12))
			IF EE7->(DBSEEK((cAliasLif)->C6_FILIAL+(cAliasLif)->C6_NUM))
			  //// Posiciona nos itens do PO EE8 para encontrar o PO doi cliente
				EE8->(DBSETORDER(1))
				IF EE8->(DBSEEK(EE7->EE7_FILIAL+EE7->EE7_PEDIDO))
					WHILE EE8->(!EOF()) .AND. EE8->EE8_PEDIDO = EE7->EE7_PEDIDO
						IF LEN(ALLTRIM(EE8->EE8_SEQUEN)) <= 1
							IF "0"+ALLTRIM(EE8->EE8_SEQUEN) == (cAliasLif)->C6_ITEM
								aDados1[22] := EE8->EE8_XPOCLI
							ENDIF
						ELSE
							IF ALLTRIM(EE8->EE8_SEQUEN) == (cAliasLif)->C6_ITEM
								aDados1[22] := EE8->EE8_XPOCLI
							ENDIF
						ENDIF
						EE8->(DBSKIP())
					ENDDO
				ENDIF
			ENDIF
			RestArea( aEE7 )

			oSection1:PrintLine()
			aFill(aDados1,Nil)
			(cAliasLif)->( dbskip() )
		End
		oSection1:PrintLine()
		aFill(aDados1,Nil)
		(cAliasLif)->( dbCloseArea() )
	EndIf
	
	oReport:SkipLine()

Return oReport

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบPrograma  StQuery      บAutor  ณGiovani Zago    บ Data ณ  04/07/15     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relatorio MMG 							                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function StQuery(_ccod)

	Local cQuery := ' '

	cQuery := " SELECT C6_FILIAL, C6_NUM, A1_NOME, C5_EMISSAO, C6_ITEM, C6_PRODUTO, B1_DESC, B1_CLAPROD,FORPAD, SALDOPV, " + CRLF
	cQuery += " QTDFALTA, VLRFALTA, QTDRES, VLRRES, C6_ENTRE1, C6_ZENTRE2, TOTALFALTA, TOTALRESERVA, "+ CRLF
	cQuery += " NVL(ROUND((CASE WHEN TOTALRESERVA>0 THEN (TOTALRESERVA/(TOTALFALTA+TOTALRESERVA)*100) ELSE 0 END),2),0) AS PERCRES,  "+ CRLF
	cQuery += " NVL(ROUND(A2_SLD_MMG,2),0) AS A2_SLD_MMG, "+ CRLF
	cQuery += " NVL(ROUND(A2_SLD_MAO,2),0) AS A2_SLD_MAO "+ CRLF
	cQuery += " FROM( "+ CRLF
	cQuery += " SELECT C6_FILIAL, C6_NUM, A1_NOME, C5_EMISSAO, C6_ITEM, C6_PRODUTO, B1_DESC, B1_CLAPROD, C6_QTDVEN-C6_QTDENT AS SALDOPV, B1_PROC AS FORPAD , "+ CRLF
	cQuery += " NVL(PA1.PA1_QUANT,0) QTDFALTA, NVL(ROUND(C6.C6_PRCVEN*PA1.PA1_QUANT,2),0) AS VLRFALTA, "+ CRLF
	cQuery += " NVL(PA2.PA2_QUANT,0) QTDRES, NVL(ROUND(C6.C6_PRCVEN*PA2.PA2_QUANT,2),0) AS VLRRES, C6_ENTRE1, C6_ZENTRE2, "+ CRLF
		
	cQuery += " (SELECT SUM(NVL(ROUND(XC6.C6_PRCVEN*XA1.PA1_QUANT,2),0)) "+ CRLF
	cQuery += " FROM " + RetSqlName("SC6") + " XC6 "+ CRLF
	cQuery += " LEFT JOIN " + RetSqlName("PA1") + " XA1 ON XC6.C6_FILIAL = XA1.PA1_FILIAL AND XC6.C6_NUM||XC6.C6_ITEM = XA1.PA1_DOC AND XA1.D_E_L_E_T_ = ' '  "+ CRLF
	cQuery += " WHERE XC6.D_E_L_E_T_ = ' ' "+ CRLF
	// Ticket 20210407005490 - Relat๓rio de PV com falta para itens Guararema e Manaus - Eduardo Sigamat - Inicio
	If cEmpAnt == "03"
		cQuery += " 	AND XC6.C6_FILIAL = '01' "+ CRLF
	Else
		cQuery += " 	AND XC6.C6_FILIAL IN ('01','02','05') "+ CRLF           // Valdemir Rabelo 11/05/2022 - Chamado: 20220425008711
	EndIf
	// Ticket 20210407005490 - Relat๓rio de PV com falta para itens Guararema e Manaus - Eduardo Sigamat - Fim
	cQuery += " 	AND XC6.C6_QTDVEN - XC6.C6_QTDENT > 0 "+ CRLF
	cQuery += " 	AND XC6.C6_BLQ = ' ' "+ CRLF
	cQuery += " 	AND XC6.C6_FILIAL = C5.C5_FILIAL "+ CRLF
	cQuery += " 	AND XC6.C6_NUM = C5.C5_NUM) AS TOTALFALTA, "+ CRLF
	
	cQuery += " (SELECT SUM(NVL(ROUND(ZC6.C6_PRCVEN*ZA2.PA2_QUANT,2),0)) "+ CRLF
	cQuery += " FROM " + RetSqlName("SC6") + " ZC6 "+ CRLF
	cQuery += " LEFT JOIN " + RetSqlName("PA2") + " ZA2 ON ZC6.C6_FILIAL = ZA2.PA2_FILRES AND ZC6.C6_NUM||ZC6.C6_ITEM = ZA2.PA2_DOC AND ZA2.D_E_L_E_T_ = ' '  "+ CRLF
	cQuery += " WHERE ZC6.D_E_L_E_T_ = ' ' "+ CRLF
	// Ticket 20210407005490 - Relat๓rio de PV com falta para itens Guararema e Manaus - Eduardo Sigamat - Inicio
	If cEmpAnt == "03"+ CRLF
		cQuery += " 	AND ZC6.C6_FILIAL = '01' "+ CRLF
	Else
		cQuery += " 	AND ZC6.C6_FILIAL IN ('01','02','05') "+ CRLF         // Valdemir Rabelo 11/05/2022 - Chamado: 20220425008711
	EndIf
	// Ticket 20210407005490 - Relat๓rio de PV com falta para itens Guararema e Manaus - Eduardo Sigamat - Fim
	cQuery += " 	AND ZC6.C6_QTDVEN - ZC6.C6_QTDENT > 0 "+ CRLF
	cQuery += " 	AND ZC6.C6_BLQ = ' '  "+ CRLF
	cQuery += " 	AND ZC6.C6_FILIAL = C5.C5_FILIAL "+ CRLF
	cQuery += " 	AND ZC6.C6_NUM = C5.C5_NUM) AS TOTALRESERVA, "+ CRLF
	//>> Chamado 006724
	cQuery += "                               ( "+ CRLF
    cQuery += "                            SELECT SUM(ROUND(MMG.C6_QTDVEN - MMG.C6_QTDENT,2)) "+ CRLF
    cQuery += "                                        FROM " + RetSqlName("SC6") + " MMG "+ CRLF
    cQuery += "                                        WHERE MMG.D_E_L_E_T_ = ' ' "+ CRLF
    cQuery += "                                            AND MMG.C6_QTDVEN - MMG.C6_QTDENT > 0 "+ CRLF
    cQuery += "                                            AND MMG.C6_PRODUTO = C6.C6_PRODUTO "+ CRLF
    cQuery += "                                            AND MMG.C6_FILIAL  = '04' "+ CRLF
    cQuery += "                                            AND MMG.C6_CLI     = '033467' "+ CRLF
    cQuery += "                                            AND MMG.C6_LOJA    = '02' "+ CRLF
    cQuery += "                                            AND MMG.C6_OPER    = '94' "+ CRLF
    cQuery += "                                            AND MMG.C6_BLQ     <> 'R' "+ CRLF
    cQuery += "                            )  AS A2_SLD_MMG, "+ CRLF
    cQuery += "                            ( "+ CRLF
    cQuery += "                            SELECT SUM(NVL(ROUND(MAO.C6_QTDVEN - MAO.C6_QTDENT,2),0)) "+ CRLF
    cQuery += "                                FROM "+AllTrim(GetMv("STTMKG0311",,"UDBD02"))+".SC6030 MAO "+ CRLF
    cQuery += "                                WHERE MAO.D_E_L_E_T_ = ' ' "+ CRLF
    cQuery += "                                AND MAO.C6_QTDVEN - MAO.C6_QTDENT > 0 "+ CRLF
    cQuery += "                                AND MAO.C6_PRODUTO = C6.C6_PRODUTO "+ CRLF
    cQuery += "                                AND MAO.C6_FILIAL  = '01' "+ CRLF
    cQuery += "                                AND MAO.C6_CLI     = '033467' "+ CRLF
    cQuery += "                                AND MAO.C6_LOJA    = '02' "+ CRLF
    cQuery += "                                AND MAO.C6_OPER    = '15' "+ CRLF
    cQuery += "                                AND MAO.C6_BLQ     <> 'R' "+ CRLF
    cQuery += "                        ) AS A2_SLD_MAO " + CRLF
	//<< Chamado 006724 	
	cQuery += " FROM " + RetSqlName("SC5") + " C5 "+ CRLF
	cQuery += " LEFT JOIN " + RetSqlName("SC6") + " C6 "+ CRLF
	cQuery += " ON C5.C5_FILIAL = C6.C6_FILIAL AND C5.C5_NUM = C6.C6_NUM AND C5.C5_CLIENTE = C6.C6_CLI AND C5.C5_LOJACLI = C6.C6_LOJA "+ CRLF
	cQuery += " LEFT JOIN " + RetSqlName("SB1") + " B1 "+ CRLF
	cQuery += " ON B1.B1_COD = C6.C6_PRODUTO "+ CRLF
	cQuery += " LEFT JOIN " + RetSqlName("SA1") + " A1 "+ CRLF
	cQuery += " ON A1.A1_COD = C5.C5_CLIENTE AND A1.A1_LOJA = C5.C5_LOJACLI "+ CRLF
	cQuery += " LEFT JOIN " + RetSqlName("PA1") + " PA1 "+ CRLF
	cQuery += " ON C6.C6_FILIAL = PA1.PA1_FILIAL AND C6.C6_NUM||C6.C6_ITEM = PA1.PA1_DOC AND PA1.D_E_L_E_T_ = ' '  "+ CRLF
	cQuery += " LEFT JOIN " + RetSqlName("PA2") + " PA2 "+ CRLF
	cQuery += " ON C6.C6_FILIAL = PA2.PA2_FILRES AND C6.C6_NUM||C6.C6_ITEM = PA2.PA2_DOC AND PA2.D_E_L_E_T_ = ' '  "+ CRLF
	cQuery += " WHERE C5.D_E_L_E_T_ = ' ' "+ CRLF
	cQuery += " 	AND C6.D_E_L_E_T_ = ' ' "+ CRLF
	cQuery += " 	AND B1.D_E_L_E_T_ = ' ' "+ CRLF
	cQuery += " 	AND A1.D_E_L_E_T_ = ' ' "+ CRLF
	cQuery += " 	AND A1_TIPO = 'X' "+ CRLF
	// Ticket 20210407005490 - Relat๓rio de PV com falta para itens Guararema e Manaus - Eduardo Sigamat - Inicio
	If cEmpAnt == "03"
		cQuery += " 	AND C5_FILIAL = '01' "+ CRLF
	Else
		cQuery += " 	AND C5_FILIAL IN ('01','02','05') "+ CRLF			 // Valdemir Rabelo 11/05/2022 - Chamado: 20220425008711
	EndIf
	// Ticket 20210407005490 - Relat๓rio de PV com falta para itens Guararema e Manaus - Eduardo Sigamat - Fim
	cQuery += " 	AND C6_QTDVEN - C6_QTDENT > 0 " + CRLF
	cQuery += " 	AND C6_BLQ = ' ' "+ CRLF
	cQuery += " 	AND C5_EMISSAO BETWEEN '" + DtoS(MV_PAR01) + "' AND '" + DtoS(MV_PAR02) + "' "+ CRLF
	cQuery += " 	AND B1_COD BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' "+ CRLF
	//Bloqueados no Cr้dito
	If MV_PAR05 == 1
		cQuery += " AND EXISTS (SELECT * FROM  " + RetSqlName("SC9") + " SC9 "+ CRLF
		cQuery += " 			WHERE SC9.C9_PEDIDO = C6_NUM "+ CRLF
		cQuery += " 				AND SC9.D_E_L_E_T_ = ' ' "+ CRLF
		cQuery += " 				AND SC9.C9_BLCRED IN ('01','04','05','06','09') "+ CRLF
		cQuery += " 				AND SC9.C9_FILIAL = C6_FILIAL ) "+ CRLF
	//Liberados no Cr้dito
	ElseIf MV_PAR05 == 2
		cQuery += " AND EXISTS (SELECT * FROM  " + RetSqlName("SC9") + " SC9 "+ CRLF
		cQuery += " 			WHERE SC9.C9_PEDIDO = C6_NUM "+ CRLF
		cQuery += " 				AND SC9.D_E_L_E_T_ = ' ' "+ CRLF
		cQuery += " 				AND SC9.C9_BLCRED = ' ' "+ CRLF
		cQuery += " 				AND SC9.C9_FILIAL = C6_FILIAL ) "+ CRLF
	EndIf
	cQuery += " ORDER BY C6_FILIAL, C6_NUM, C6_ITEM ) "+ CRLF
	If Select(cAliasLif) > 0
		(cAliasLif)->( dbCloseArea() )
	EndIf
	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

Return
