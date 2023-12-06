#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±∫Programa  RSTFAT32     ∫Autor  ≥Giovani Zago    ∫ Data ≥  17/03/14     ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥  Relatorio PV C/FALTA			                          ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ Steck                                                      ∫±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/
/*************************************************************
<<< ALTERA«√O >>> 
AÁ„o...........: Incluir taratamento para a Empresa 11 - NEWCO
...............: A loja do cliente 033467 agora È "06"
...............: O Tipo de OperaÁ„o utilizada agora nos pedidos de venda È "01" venda anteriormente era "94" TransferÍncia.
Desenvolvedor..: Marcelo Klopfer Leme - SIGAMAT
Data...........: 26/01/2021
Chamado........: 20220112000947 - VIRADA APOEMA NEWCO DISTRIBUIDORA
*************************************************************/

User Function RSTFAT32()

	Local   oReport
	Private cPerg 		  := "RFAT32"
	Private cTime       := Time()
	Private cHora       := Substr(cTime, 1, 2)
	Private cMinutos    := Substr(cTime, 4, 2)
	Private cSegundos   := Substr(cTime, 7, 2)
	Private cAliasLif   := cPerg + cHora + cMinutos + cSegundos
	Private lXlsHeader  := .F.
	Private lXmlEndRow  := .F.
	Private cPergTit 	  := cAliasLif

	Return() //Desativado pois ser· usado somente o RSTFATDB

	PutSx1(cPerg, "01", "Da Data:" 				,"Da Data: ?" 			 	,"Da Data: ?" 			 	,"mv_ch1" ,"D",8,0,0	,"G","",''    ,"","","mv_par01","","","","","","","","","","","","","","","","")
	PutSx1(cPerg, "02", "Ate Data:" 			,"Ate Data: ?" 			 	,"Ate Data: ?" 		 		,"mv_ch2" ,"D",8,0,0	,"G","",''    ,"","","mv_par02","","","","","","","","","","","","","","","","")
	PutSx1(cPerg, "03", "Do Produto:" 			,"Do Produto: ?"		 	,"Do Produto: ?" 		 	,"mv_ch3" ,"C",15,0,0	,"G","",'SB1',"","","mv_par03","","","","","","","","","","","","","","","","")
	PutSx1(cPerg, "04", "Tipo  :"				,"Tipo   :"				 	,"Tipo    :"        	 	,"mv_ch4" ,"N",1,0,0	,"C","",''    ,'','',"mv_par04","Cabecalho+Itens","","","","Itens","","","","CabeÁalho","","","","","","")
	PutSx1(cPerg, "05", "Do Grupo:" 			,"Do Grupo: ?" 			 	,"Do Grupo: ?" 		 		,"mv_ch5" ,"C",4,0,0	,"G","",'SBM' ,"","","mv_par05","","","","","","","","","","","","","","","","")
	PutSx1(cPerg, "06", "Desconsiderar Grupos:"	,"Desconsiderar Grupos:"	,"Desconsiderar Grupos:"	,"mv_ch6" ,"C",20,0,0	,"G","",''   ,"","","mv_par06","","","","","","","","","","","","","","","","")
	PutSx1(cPerg, "07", "Tipo de Frete:"		,"Tipo de Frete:"		 	,"Tipo de Frete:"			, "mv_ch7","C",1,0,0	,"G","",''   ,"","","mv_par07","Cif","","","","Fob","","","","Ambos","","","","","","","")

	oReport	:= ReportDef()
	oReport:PrintDialog()

Return

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±∫Programa  ReportDef    ∫Autor  ≥Giovani Zago    ∫ Data ≥  21/02/14     ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥  Relatorio GRUPO DE CLIENTE				                  ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ Steck                                                      ∫±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/

Static Function ReportDef()

	Local oReport
	Local oSection

	oReport := TReport():New(cPergTit,"RELAT”RIO Analise P.V.",cPerg,{|oReport| ReportPrint(oReport)},"Este programa ir· imprimir um relatÛrio de Analise P.V.")

	Pergunte(cPerg,.F.)

	oSection := TRSection():New(oReport,"Analise P.V.",{"SC5"})

Return oReport

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±∫Programa  ReportPrint  ∫Autor  ≥Giovani Zago    ∫ Data ≥  21/02/14     ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥  Relatorio GRUPO DE CLIENTE				                  ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ Steck                                                      ∫±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/

Static Function ReportPrint(oReport)

	Local oSection		:= oReport:Section(1)
	Local oSection1		:= oReport:Section(1)
	Local aDados[2]
	Local aDados1[99]
	Local _cNum     	:= ' '
	Local _nGetCond     :=  GetMv("ST_VALMIN",,400)
	Local _cLoja		:= ""
	Local cFrete		:= ""

	TRCell():New(oSection,"PEDIDO"            ,,"PEDIDO"           ,,6,.F.,)
	TRCell():New(oSection,"COD"           	  ,,"COD"          	   ,,6,.F.,)	
	TRCell():New(oSection,"CLIENTE"           ,,"CLIENTE"          ,,25,.F.,)
	TRCell():New(oSection,"EMISSAO"           ,,"EMISSAO"          ,,20,.F.,)
	TRCell():New(oSection,"COND"              ,,"COND"             ,,6,.F.,)
	If Mv_Par04 == 2
		TRCell():New(oSection,"ITEM"          ,,"ITEM"              ,,3,.F.,)
		TRCell():New(oSection,"PRODUTO"       ,,"PRODUTO"           ,,15,.F.,)
		TRCell():New(oSection,"DESCRI"        ,,"DESCRI"           	,,30,.F.,)
		TRCell():New(oSection,"GRUPO"         ,,"GRUPO"             ,,25,.F.,)
		TRCell():New(oSection,"ORIGEM"        ,,"ORIGEM"            ,,2,.F.,)
		TRCell():New(oSection,"SLDPV"         ,,"SALDO PV"          ,"@E 99,999,999.99",14)
		TRCell():New(oSection,"TPPRO"         ,,"TP.Produto"       	,,15,.F.,)  // Chamado 008808 Felipe Souza 14/01/19
		TRCell():New(oSection,"DT_ENTR1"      ,,"DT_ENTR1"          ,,20,.F.,)
		TRCell():New(oSection,"DT_ENTR2"      ,,"DT_ENTR2(Compromisso)",,20,.F.,)
		TRCell():New(oSection,"DT_ENTR+" 	  ,,"Entrega Final"     ,,20,.F.,)
		TRCell():New(oSection,"ORDEM" 	      ,,"Ordem Cliente"     ,,20,.F.,)
		// Ticket 20210426006680 - Incluir pedido do cliente relatÛrio pv com falta - Eduardo Sigamat - Inicio
		TRCell():New(oSection,"NUM_PED_COM"   ,,"NUM_PED_COM"      	,,6,.F.,)
		TRCell():New(oSection,"ITEM_PED_COM"  ,,"ITEM_PED_COM"     	,,3,.F.,)
		// Ticket 20210426006680 - Incluir pedido do cliente relatÛrio pv com falta - Eduardo Sigamat - Fim
		TRCell():New(oSection,"QTDVEN"        ,,"QTD.VEN."          ,"@E 99,999,999.99",14)  
		TRCell():New(oSection,"QTDENT"        ,,"QTD.ENT."          ,"@E 99,999,999.99",14) 
		TRCell():New(oSection,"OBSPED" 	      ,,"Obs.Ped."      	,,20,.F.,) 
		TRCell():New(oSection,"FINANCEIRO" 	  ,,"FINANCEIRO"      	,,20,.F.,) 		
	EndIf
	TRCell():New(oSection,"VEND1A"           ,,"VEND1_COD"         ,,25,.F.,)
	TRCell():New(oSection,"VEND1B"           ,,"VEND1_NOME"        ,,25,.F.,)
	TRCell():New(oSection,"VEND1"            ,,"VEND1"             ,,25,.F.,)
	TRCell():New(oSection,"VEND2"            ,,"VEND2"             ,,25,.F.,)
	TRCell():New(oSection,"ENTREGA"          ,,"ENTREGA"           ,,15,.F.,)
	TRCell():New(oSection,"TIPO"             ,,"TIPO"              ,,15,.F.,)
	TRCell():New(oSection,"FRETE"        	 ,,"FRETE"         	   ,,15,.F.,)
	TRCell():New(oSection,"FORPAD"        	 ,,"FORN PADRAO"       ,,6,.F.,) //Chamado 007059 - Everson Santana 19.03.18
	TRCell():New(oSection,"FORLOJ"        	 ,,"LOJA FORN PADRAO"  ,,2,.F.,) //Chamado 007130 - Everson Santana 19.03.18
	TRCell():New(oSection,"FORNOME"       	 ,,"NOME FORN PADRAO"  ,,30,.F.,) //Chamado 007130 - Everson Santana 19.03.18
	TRCell():New(oSection,"REFATURAMENTO"    ,,"REFATURAMENTO"     ,,15,.F.,)
	TRCell():New(oSection,"TRANSPORTADORA"   ,,"TRANSPORTADORA"    ,,9,.F.,)
	TRCell():New(oSection,"COMERCIAL"        ,,"COMERCIAL"         ,,15,.F.,)
	TRCell():New(oSection,"MINIMO"           ,,"MINIMO"            ,,15,.F.,)
	TRCell():New(oSection,"OS"               ,,"OS"                ,,15,.F.,)
	TRCell():New(oSection,"DE"               ,,"DE"                ,,20,.F.,)
	TRCell():New(oSection,"ATE"              ,,"ATE"               ,,20,.F.,)
	If Mv_Par04 == 2
		TRCell():New(oSection,"FALTA"        ,,"Vlr.FALTA"         ,"@E 99,999,999.99",14)
		TRCell():New(oSection,"RESERVA"      ,,"Vlr.RESERVA"       ,"@E 99,999,999.99",14)
		TRCell():New(oSection,"QUANT"        ,,"Qtd.FALTA"         ,"@E 99,999,999.99",14)
		TRCell():New(oSection,"A1_RESERVA"   ,,"Qtd.Reserva"       ,"@E 99,999,999.99",14)
		TRCell():New(oSection,"A2_SLD_MMG"   ,,"Qtde MMG SP"       ,"@E 99,999,999.99",14)
		TRCell():New(oSection,"A2_SLD_MAO"   ,,"Qtde MMG MAO"      ,"@E 99,999,999.99",14)
		TRCell():New(oSection,"A3_ENDERECAR" ,,"Qtde EndereÁar CD" ,"@E 99,999,999.99",14)
		TRCell():New(oSection,"LIBDES"       ,,"LIB DES"           ,,10,.F.,)
		TRCell():New(oSection,"DATAMAIOR"    ,,"MAIOR DATA"        ,,10,.F.,)
	EndIf
	TRCell():New(oSection,"TOTAL"            ,,"TOTAL P.V."        ,"@E 99,999,999.99",14)
	TRCell():New(oSection,"TOTAL_FALTA"      ,,"TOTAL_FALTA"       ,"@E 99,999,999.99",14)
	TRCell():New(oSection,"%RESERVADO"       ,,"%RESERVADO"        ,"@E 99,999,999.99",14)
	TRCell():New(oSection,"XALERTF"          ,,"OBSER"             ,"@!",40)
	TRCell():New(oSection,"OPER"             ,,"Tp Oper"           ,,2,.F.,)
	oSection:SetHeaderSection(.T.)
	oSection:Setnofilter("SC5")
	oSection1:Cell("PEDIDO")             :SetBlock( { || aDados1[01] } )
	If Mv_Par04 = 2
		oSection1:Cell("ITEM")           :SetBlock( { || aDados1[02] } )
		oSection1:Cell("PRODUTO")        :SetBlock( { || aDados1[03] } )
		oSection1:Cell("DESCRI")     	 :SetBlock( { || aDados1[49] } )
		oSection1:Cell("GRUPO")          :SetBlock( { || aDados1[19] } )
		oSection1:Cell("ORIGEM")         :SetBlock( { || aDados1[25] } )
		oSection1:Cell("SLDPV")          :SetBlock( { || aDados1[26] } )
		oSection1:Cell("LIBDES")         :SetBlock( { || aDados1[27] } )
		oSection1:Cell("DATAMAIOR")      :SetBlock( { || aDados1[33] } )
		oSection1:Cell("DT_ENTR1")       :SetBlock( { || aDados1[39] } )
		oSection1:Cell("DT_ENTR2")       :SetBlock( { || aDados1[40] } )
		oSection1:Cell("DT_ENTR+")       :SetBlock( { || aDados1[41] } )
		oSection1:Cell("ORDEM")          :SetBlock( { || aDados1[42] } )
		// Ticket 20210426006680 - Incluir pedido do cliente relatÛrio pv com falta - Eduardo Sigamat - Inicio
		oSection1:Cell("NUM_PED_COM")    :SetBlock( { || aDados1[50] } )
		oSection1:Cell("ITEM_PED_COM")   :SetBlock( { || aDados1[51] } )
		// Ticket 20210426006680 - Incluir pedido do cliente relatÛrio pv com falta - Eduardo Sigamat - Fim
		oSection1:Cell("QTDVEN")         :SetBlock( { || aDados1[43] } )
		oSection1:Cell("QTDENT")         :SetBlock( { || aDados1[44] } )
		oSection1:Cell("OBSPED")         :SetBlock( { || aDados1[45] } )
		oSection1:Cell("FINANCEIRO")     :SetBlock( { || aDados1[48] } ) 
	EndIf
	oSection1:Cell("VEND1A")              :SetBlock( { || aDados1[46] } )
	oSection1:Cell("VEND1B")              :SetBlock( { || aDados1[47] } )
	oSection1:Cell("VEND1")              :SetBlock( { || aDados1[04] } )
	oSection1:Cell("VEND2")              :SetBlock( { || aDados1[05] } )
	oSection1:Cell("ENTREGA")            :SetBlock( { || aDados1[06] } )
	oSection1:Cell("TIPO")               :SetBlock( { || aDados1[07] } )
	oSection1:Cell("FRETE")              :SetBlock( { || aDados1[52] } )
	oSection1:Cell("REFATURAMENTO")      :SetBlock( { || aDados1[08] } )
	oSection1:Cell("TRANSPORTADORA")     :SetBlock( { || aDados1[09] } )
	oSection1:Cell("COMERCIAL")          :SetBlock( { || aDados1[10] } )
	oSection1:Cell("DE")                 :SetBlock( { || aDados1[11] } )
	oSection1:Cell("ATE")                :SetBlock( { || aDados1[12] } )
	If Mv_Par04 = 2
		oSection1:Cell("FALTA")           :SetBlock( { || aDados1[13] } )
		oSection1:Cell("RESERVA")         :SetBlock( { || aDados1[14] } )
		oSection1:Cell("QUANT")           :SetBlock( { || aDados1[17] } )
		oSection1:Cell("A1_RESERVA")      :SetBlock( { || aDados1[28] } )
		oSection1:Cell("A2_SLD_MMG")      :SetBlock( { || aDados1[29] } )
		oSection1:Cell("A2_SLD_MAO")      :SetBlock( { || aDados1[32] } )
		oSection1:Cell("TPPRO")           :SetBlock( { || aDados1[38] } )  // Chamado 008808 Felipe Souza 14/01/19
		oSection1:Cell("A3_ENDERECAR")    :SetBlock( { || aDados1[30] } )	
	EndIf
	oSection1:Cell("TOTAL")               :SetBlock( { || aDados1[15] } )
	oSection1:Cell("TOTAL_FALTA")         :SetBlock( { || aDados1[16] } )
	oSection1:Cell("MINIMO")              :SetBlock( { || aDados1[18] } )
	oSection1:Cell("OS")                  :SetBlock( { || aDados1[20] } )
	oSection1:Cell("%RESERVADO")          :SetBlock( { || aDados1[21] } )
	oSection1:Cell("EMISSAO")             :SetBlock( { || aDados1[22] } )
	oSection1:Cell("COND")                :SetBlock( { || aDados1[23] } )
	oSection1:Cell("FORPAD")         	   :SetBlock( { || aDados1[34] } )//Chamado 007059 - Everson Santana 19.03.18
	oSection1:Cell("FORLOJ")         	   :SetBlock( { || aDados1[35] } )//Chamado 007130 - Everson Santana 19.03.18
	oSection1:Cell("FORNOME")         	   :SetBlock( { || aDados1[36] } )//Chamado 007130 - Everson Santana 19.03.18
	oSection1:Cell("CLIENTE")             :SetBlock( { || aDados1[24] } )
	oSection1:Cell("XALERTF")             :SetBlock( { || aDados1[25] } )
	oSection1:Cell("OPER")                :SetBlock( { || aDados1[31] } )
	oSection1:Cell("COD")                 :SetBlock( { || aDados1[37] } )
	oReport:SetTitle("Analise P.V.")// Titulo do relatÛrio

	oReport:SetMeter(0)
	aFill(aDados,Nil)
	aFill(aDados1,Nil)
	oSection:Init()

	Processa({|| StQuery( ) },"Compondo Relatorio")

	dbSelectArea(cAliasLif)
	(cAliasLif)->( dbGoTop() )
	If Select(cAliasLif) > 0
		While (cAliasLif)->( !Eof() )
			If Mv_Par04 == 1
				If _cNum <> (cAliasLif)->C5_NUM
					aDados1[01]	:= '  '
					oSection1:PrintLine()
					aFill(aDados1,nil)
					aDados1[01]	:=  (cAliasLif)->C5_NUM
					aDados1[37] :=  (cAliasLif)->COD  // Giovani
					aDados1[24] :=  (cAliasLif)->CLIENTE  // Jefferson
					aDados1[25] :=  (cAliasLif)->XALERTF
					aDados1[22]	:=  (cAliasLif)->EMISSAO
					aDados1[31]	:=  (cAliasLif)->OPER
					aDados1[38]	:=  (cAliasLif)->TPPRO     // Chamado 008808 Felipe Souza 14/01/19
					aDados1[04]	:=  (cAliasLif)->VEND01
					aDados1[46]	:=  (cAliasLif)->VEND01A
					aDados1[47]	:=  (cAliasLif)->VEND01B
					aDados1[05]	:=  (cAliasLif)->VEND02
					aDados1[06]	:=  (cAliasLif)->ENTREGA
					aDados1[07]	:=  (cAliasLif)->TIPO
					If Mv_Par07 == 1
						cFrete := "Cif"
					ElseIf Mv_Par07 == 2
						cFrete := "Fob"
					ElseIf Mv_Par07 == 3
						If (cAliasLif)->C5_TPFRETE == "C"
							cFrete := "Cif"
						ElseIf (cAliasLif)->C5_TPFRETE == "F"
							cFrete := "Fob"
						EndIf
					EndIf
					aDados1[52]	:=  cFrete
					aDados1[08]	:=  (cAliasLif)->REFATURAMENTO
					aDados1[09]	:=  (cAliasLif)->TRANSPORTADORA
					aDados1[10]	:=  (cAliasLif)->COMERCIAL
					aDados1[11]	:=  (cAliasLif)->DE
					aDados1[12]	:=  (cAliasLif)->ATE
					//	aDados1[14]	:=  (cAliasLif)->RESERVA
					aDados1[15]	:=  (cAliasLif)->TOTAL
					aDados1[16]	:=  (cAliasLif)->TOTAL_FALTA
					//	aDados1[17]	:=  (cAliasLif)->TOTAL_RESERVA
					If (cAliasLif)->PARCELA_RESERVADA < _nGetCond     .And. ALLTRIM((cAliasLif)->OS) = '5'
						aDados1[18]	:=  'Bloqueado'
					Else
						aDados1[18]	:=  'Liberado'
					EndIf
					aDados1[18]	:= (cAliasLif)->C5_XBLQFMI
					If Alltrim((cAliasLif)->OS) = '5'
						aDados1[20]	:=  'SEM OS'
					ElseIf Alltrim((cAliasLif)->OS) = '4'
						aDados1[20]	:=  'Embal.Final.'
					Else
						aDados1[20]	:=  'Em SeparaÁ„o'
					EndIf
					aDados1[21]	:= IIf( 100-(( aDados1[16]/aDados1[15]) *100 ) < 0, 0, 100-(( aDados1[16]/aDados1[15]) *100 ))
					aDados1[23]	:=  (cAliasLif)->COND
					If	Mv_Par04 = 1
						oSection1:PrintLine()
						aFill(aDados1,Nil)
						aDados1[09]	:= 'Item: ' + (cAliasLif)->C6_ITEM
						aDados1[10]	:= (cAliasLif)->C6_PRODUTO
						aDados1[08]	:= (cAliasLif)->GRUPO
						aDados1[15]	:= (cAliasLif)->FALTA
						aDados1[16]	:= (cAliasLif)->QUANT
						aDados1[34]	:= (cAliasLif)->FORPAD
						_cLoja :=  Posicione("SA2", 1, xFilial("SA2") + (cAliasLif)->FORPAD, "A2_LOJA")
						aDados1[35]	:= _cLoja
						aDados1[36]	:= Posicione("SA2", 1, xFilial("SA2") + (cAliasLif)->FORPAD + _cLoja, "A2_NOME")
						//aDados1[28]	:=  (cAliasLif)->A1_RESERVA_QUANT
					EndIf
				Else
					If	Mv_Par04 = 1
						aDados1[09]	:= 'Item: ' + (cAliasLif)->C6_ITEM
						aDados1[10]	:= (cAliasLif)->C6_PRODUTO
						aDados1[08]	:= (cAliasLif)->GRUPO
						aDados1[15]	:= (cAliasLif)->FALTA
						aDados1[16]	:= (cAliasLif)->QUANT
						aDados1[34]	:= (cAliasLif)->FORPAD
						_cLoja :=  Posicione("SA2", 1, xFilial("SA2") + (cAliasLif)->FORPAD, "A2_LOJA")
						aDados1[35]	:= _cLoja
						aDados1[36]	:= Posicione("SA2", 1, xFilial("SA2") + (cAliasLif)->FORPAD, "A2_NOME")
						//aDados1[28]	:=  (cAliasLif)->A1_RESERVA_QUANT
					EndIf
				EndIf
				oSection1:PrintLine()
				aFill(aDados1,nil)
			ElseIf Mv_Par04 = 2
				aDados1[01]	:=  (cAliasLif)->C5_NUM
				aDados1[50]	:=  (cAliasLif)->C6_NUMPCOM
				aDados1[51]	:=  (cAliasLif)->C6_ITEMPC
				aDados1[37] :=  (cAliasLif)->COD  // Giovani
				aDados1[24] :=  (cAliasLif)->CLIENTE  // Jefferson
				aDados1[25] :=  (cAliasLif)->XALERTF
				aDados1[22]	:=  (cAliasLif)->EMISSAO
				aDados1[31]	:=  (cAliasLif)->OPER
				aDados1[02]	:=  (cAliasLif)->C6_ITEM
				aDados1[03]	:=  (cAliasLif)->C6_PRODUTO
				aDados1[49]	:= (cAliasLif)->DESCRI
				aDados1[04]	:=  (cAliasLif)->VEND01
				aDados1[46]	:=  (cAliasLif)->VEND01A
				aDados1[47]	:=  (cAliasLif)->VEND01B
				aDados1[05]	:=  (cAliasLif)->VEND02
				aDados1[06]	:=  (cAliasLif)->ENTREGA
				aDados1[07]	:=  (cAliasLif)->TIPO
				If Mv_Par07 == 1
					cFrete := "Cif"
				ElseIf Mv_Par07 == 2
					cFrete := "Fob"
				ElseIf Mv_Par07 == 3
					If (cAliasLif)->C5_TPFRETE == "C"
						cFrete := "Cif"
					ElseIf (cAliasLif)->C5_TPFRETE == "F"
						cFrete := "Fob"
					EndIf
				EndIf
				aDados1[52]	:=  cFrete
				aDados1[08]	:=  (cAliasLif)->REFATURAMENTO
				aDados1[09]	:=  (cAliasLif)->TRANSPORTADORA
				aDados1[10]	:=  (cAliasLif)->COMERCIAL
				aDados1[11]	:=  (cAliasLif)->DE
				aDados1[12]	:=  STOD((cAliasLif)->ATE)
				aDados1[13]	:=  (cAliasLif)->FALTA
				aDados1[14]	:=  (cAliasLif)->RESERVA
				aDados1[15]	:=  (cAliasLif)->TOTAL
				aDados1[16]	:=  (cAliasLif)->TOTAL_FALTA
				aDados1[17]	:=  (cAliasLif)->QUANT
				aDados1[28]	:=  Iif((cAliasLif)->A1_RESERVA<0,0,(cAliasLif)->A1_RESERVA)
				aDados1[29]	:=  (cAliasLif)->A2_SLD_MMG
				aDados1[32]	:=  (cAliasLif)->A2_SLD_MAO
				aDados1[30]	:=  (cAliasLif)->A3_ENDERECAR
				aDados1[19]	:=  (cAliasLif)->GRUPO
				aDados1[25]	:=  (cAliasLif)->ORIGEM
				aDados1[34]	:=  (cAliasLif)->FORPAD
				aDados1[38]	:=  (cAliasLif)->TPPRO   // Chamado 008808 Felipe Souza 14/01/19				
				_cLoja := Posicione("SA2", 1, xFilial("SA2") + (cAliasLif)->FORPAD, "A2_LOJA")
				aDados1[35]	:=  _cLoja
				aDados1[36]	:=   Posicione("SA2", 1, xFilial("SA2") + (cAliasLif)->FORPAD, "A2_NOME")
				aDados1[26]	:=  (cAliasLif)->SLDPV
				aDados1[27]	:=  StoD((cAliasLif)->LIBDES)
				If aDados1[12] > aDados1[27] // CHAMADO 005614 - Robson Mazzarotto.
					aDados1[33]	:=  aDados1[12]
				Else
					aDados1[33]	:=  aDados1[27]
				EndIf
				If (cAliasLif)->PARCELA_RESERVADA < _nGetCond .And. Alltrim((cAliasLif)->OS) = '5'
					aDados1[18]	:=  'Bloqueado'
				Else
					aDados1[18]	:=  'Liberado'
				EndIf
				aDados1[18]	:= (cAliasLif)->C5_XBLQFMI
				If Alltrim((cAliasLif)->OS) = '5'
					aDados1[20]	:=  'SEM OS'
				ElseIf Alltrim((cAliasLif)->OS) = '4'
					aDados1[20]	:=  'Embal.Final.'
				Else
					aDados1[20]	:=  'Em SeparaÁ„o'
				EndIf
				aDados1[21]	:=  IIf( 100-(( aDados1[16]/aDados1[15]) *100 ) <0 ,0, 100-(( aDados1[16]/aDados1[15]) *100 ))
				aDados1[23]	:=  (cAliasLif)->COND
				aDados1[39]	:=  (cAliasLif)->DT_ENTR1  
				aDados1[40]	:=  (cAliasLif)->DT_ENTR2  
				aDados1[41]	:=  (cAliasLif)->DT_ENTR  
				aDados1[42]	:=  (cAliasLif)->ORDEM
				// Ticket 20210426006680 - Incluir pedido do cliente relatÛrio pv com falta - Eduardo Sigamat - Inicio
				aDados1[50]	:=  (cAliasLif)->C6_NUMPCOM
				aDados1[51]	:=  (cAliasLif)->C6_ITEMPC 	 
				// Ticket 20210426006680 - Incluir pedido do cliente relatÛrio pv com falta - Eduardo Sigamat - Fim
				aDados1[43]	:=  (cAliasLif)->QTDVEN
				aDados1[44]	:=  Iif((cAliasLif)->QTDENT<0,0,(cAliasLif)->QTDENT) 
				aDados1[45]	:=  (cAliasLif)->OBSPED
				aDados1[48]	:=  (cAliasLif)->FINANCEIRO
				oSection1:PrintLine()
				aFill(aDados1,Nil)
			Else
				If _cNum <> (cAliasLif)->C5_NUM
					aDados1[01]	:=  (cAliasLif)->C5_NUM
					aDados1[50]	:=  (cAliasLif)->C6_NUMPCOM
					aDados1[51]	:=  (cAliasLif)->C6_ITEMPC
					aDados1[37] :=  (cAliasLif)->COD  // Giovani
					aDados1[24] :=  (cAliasLif)->CLIENTE  // Jefferson
					aDados1[25] :=  (cAliasLif)->XALERTF
					aDados1[22]	:=  (cAliasLif)->EMISSAO
					aDados1[31]	:=  (cAliasLif)->OPER
					aDados1[38]	:=  (cAliasLif)->TPPRO // Chamado 008808 Felipe Souza 14/01/19
					aDados1[04]	:=  (cAliasLif)->VEND01
					aDados1[46]	:=  (cAliasLif)->VEND01A
					aDados1[47]	:=  (cAliasLif)->VEND01B
					aDados1[05]	:=  (cAliasLif)->VEND02
					aDados1[06]	:=  (cAliasLif)->ENTREGA
					aDados1[07]	:=  (cAliasLif)->TIPO
					If Mv_Par07 == 1
						cFrete := "Cif"
					ElseIf Mv_Par07 == 2
						cFrete := "Fob"
					ElseIf Mv_Par07 == 3
						If (cAliasLif)->C5_TPFRETE == "C"
							cFrete := "Cif"
						ElseIf (cAliasLif)->C5_TPFRETE == "F"
							cFrete := "Fob"
						EndIf
					EndIf
					aDados1[52]	:=  cFrete
					aDados1[08]	:=  (cAliasLif)->REFATURAMENTO
					aDados1[09]	:=  (cAliasLif)->TRANSPORTADORA
					aDados1[10]	:=  (cAliasLif)->COMERCIAL
					aDados1[11]	:=  (cAliasLif)->DE
					aDados1[12]	:=  StoD((cAliasLif)->ATE)
					//	aDados1[14]	:=  (cAliasLif)->RESERVA
					aDados1[15]	:=  (cAliasLif)->TOTAL
					aDados1[16]	:=  (cAliasLif)->TOTAL_FALTA
					//	aDados1[17]	:=  (cAliasLif)->TOTAL_RESERVA
					If (cAliasLif)->PARCELA_RESERVADA < _nGetCond .And. Alltrim((cAliasLif)->OS) = '5'
						aDados1[18]	:=  'Bloqueado'
					Else
						aDados1[18]	:=  'Liberado'
					EndIf
						aDados1[18] := (cAliasLif)->C5_XBLQFMI
					If 		Alltrim((cAliasLif)->OS) = '5'
						aDados1[20]	:=  'SEM OS'
					ElseIf Alltrim((cAliasLif)->OS) = '4'
						aDados1[20]	:=  'Embal.Final.'
					Else
						aDados1[20]	:=  'Em SeparaÁ„o'
					EndIf
					aDados1[21]	:=  IIf( 100-(( aDados1[16]/aDados1[15]) *100 ) <0 ,0, 100-(( aDados1[16]/aDados1[15]) *100 ))
					aDados1[23]	:=  (cAliasLif)->COND
					aDados1[38]	:=  (cAliasLif)->COND

					oSection1:PrintLine()
					aFill(aDados1,Nil)
				EndIf
			EndIf
			_cNum := (cAliasLif)->C5_NUM
			(cAliasLif)->( dbskip() )
		End
	EndIf

	oReport:SkipLine()

Return oReport

/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±∫Programa  StQuery      ∫Autor  ≥Giovani Zago    ∫ Data ≥  21/02/14     ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥  Relatorio GRUPO DE CLIENTE				                  ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ Steck                                                      ∫±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/

Static Function StQuery()

	Local cQuery    := ' '
	Local _cVends   := ' '
	Local _cVenSt   := ' '

	cQuery := " SELECT
	cQuery += " 	SB1.B1_GRUPO||'-'||SUBSTR(SBM.BM_DESC,1,30) GRUPO,
	cQuery += " 	C5_NUM,
	cQuery += " 	C5_CONDPAG COND,
	CQuery += " 	C5_XNOME CLIENTE, 
	CQuery += " 	C5_CLIENTE COD,
	cQuery += " 	SB1.B1_XLIBDES LIBDES, 
	cQuery += " 	C5_XBLQFMI,
	cQuery += ' 	C5_XALERTF XALERTF,
	cQuery += " 	SUBSTR(SC5.C5_EMISSAO,7,2)||'/'|| SUBSTR(SC5.C5_EMISSAO,5,2)||'/'|| SUBSTR(SC5.C5_EMISSAO,1,4) EMISSAO,
	cQuery += " 	C6_OPER OPER,
	cQuery += " 	C6_XORDEM ORDEM,
	cQuery += " 	C6_DESCRI DESCRI,
	cQuery += " 	C6_QTDVEN QTDVEN,
	cQuery += " 	C6_QTDENT QTDENT,
	cQuery += " 	C5_ZOBS OBSPED,
 	cQuery += " 	SUBSTR(C6_ENTRE1,7,2)||'/'||SUBSTR(C6_ENTRE1,5,2)||'/'||SUBSTR(C6_ENTRE1,1,4) DT_ENTR1,
	cQuery += " 	SUBSTR(C6_ZENTRE2,7,2)||'/'||SUBSTR(C6_ZENTRE2,5,2)||'/'||SUBSTR(C6_ZENTRE2,1,4) DT_ENTR2,
	cQuery += " 	SUBSTR(C5_XDTEN,7,2)||'/'||SUBSTR(C5_XDTEN,5,2)||'/'||SUBSTR(C5_XDTEN,1,4) DT_ENTR,
 	cQuery += " 	C6_ITEM,
	cQuery += " 	C6_PRODUTO,
	cQuery += " 	NVL(SB1.B1_CLAPROD,'') ORIGEM,
	cQuery += " 	SB1.B1_PROC FORPAD,
	cQuery += " 	SB1.B1_TIPO TPPRO,
	// Ticket 20210426006680 - Incluir pedido do cliente relatÛrio pv com falta - Eduardo Sigamat - Inicio
	cQuery += " 	C6_NUMPCOM ,
	cQuery += " 	C6_ITEMPC ,
	// Ticket 20210426006680 - Incluir pedido do cliente relatÛrio pv com falta - Eduardo Sigamat - Fim
	// Ticket 20210223003001 - INCLUIR TIPO DE FRETE NO RELAT”RIO P.V CPM FALTA - Eduardo Sigamat - Inicio 
	cQuery += " 	C5_TPFRETE,
	// Ticket 20210223003001 - INCLUIR TIPO DE FRETE NO RELAT”RIO P.V CPM FALTA - Eduardo Sigamat - Fim
	cQuery += " 	SUM(NVL((SELECT ROUND(TC6.C6_QTDVEN - TC6.C6_QTDENT,2) 
	cQuery += " 			FROM " + RetSqlName("SC6") + " TC6  
	cQuery += " 			WHERE TC6.D_E_L_E_T_   = ' '
	cQuery += " 				AND TC6.C6_QTDVEN - TC6.C6_QTDENT > 0 
	cQuery += " 				AND SC5.C5_NUM = TC6.C6_NUM 
	cQuery += " 				AND SC6.C6_ITEM = TC6.C6_ITEM 
	cQuery += " 				AND SC5.C5_FILIAL = TC6.C6_FILIAL
	cQuery += " 				AND TC6.C6_BLQ <> 'R'),0) ) SLDPV,
	cQuery += " 	SC5.C5_VEND1 VEND01A,
	cQuery += "		SUBSTR(TA3.A3_NREDUZ,1,15) VEND01B,
	cQuery += " 	SC5.C5_VEND1||'-'||SUBSTR(TA3.A3_NREDUZ,1,15) VEND01,
	cQuery += " 	SC5.C5_VEND2||'-'||SUBSTR(SA3.A3_NREDUZ,1,15) VEND02,
	cQuery += " 	CASE WHEN SC5.C5_XTIPO = '1' THEN 'RETIRA' ELSE 'ENTREGA' END ENTREGA,
	cQuery += " 	CASE WHEN SC5.C5_XTIPF = '1' THEN 'TOTAL' ELSE 'PARCIAL' END TIPO,
	cQuery += " 	CASE WHEN SC5.C5_ZREFNF = '1' THEN 'BLOQUEADO' ELSE 'LIBERADO' END REFATURAMENTO,
	cQuery += " 	CASE WHEN  SC5.C5_TRANSP  = ' ' THEN 'EM BRANCO' ELSE 'PREENCHIDA' END TRANSPORTADORA,
	cQuery += " 	CASE WHEN SC5.C5_ZBLOQ = '1' THEN 'BLOQUEADO' ELSE 'LIBERADO' END COMERCIAL,
	cQuery += " 	SE4.PARCELA,
	cQuery += " 	SC5.C5_XDE||'/'||SC5.C5_XMDE||'/'||SC5.C5_XDANO DE,
	cQuery += " 	SC5.C5_XAANO||SC5.C5_XMATE||SC5.C5_XATE ATE,
	cQuery += " 	NVL(SUM( 
	cQuery += " 	CASE WHEN SC6.C6_CF IN("+AllTrim(GetMV("ST_CFOPVEN",,""))+") "
	cQuery += " 	THEN ROUND(PA1.PA1_QUANT,2) ELSE 0 END ),0) QUANT,
	// Chamado 003051
	//cQuery += " NVL(SUM(round((SC6.C6_ZVALLIQ/SC6.C6_QTDVEN)*PA1.PA1_QUANT,2)),0)
	cQuery += " 	NVL(SUM( "
	/*************************************************************
	<<< ALTERA«√O >>> 
	AÁ„o...........: Incluir taratamento para a Empresa 11 - NEWCO
	...............: Incluido tratamento para buscar as CFOPs do par‚metro especÌfico ST_CFOPVEN
	Desenvolvedor..: Marcelo Klopfer Leme - SIGAMAT
	Data...........: 09/02/2022
	Chamado........: 20220112000947 - VIRADA APOEMA NEWCO DISTRIBUIDORA
	cQuery += " 	CASE WHEN SC6.C6_CF IN ('5405','6404','5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5403','5501','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6501','6502','7101','7102') "
	*************************************************************/
	cQuery += " 	CASE WHEN SC6.C6_CF IN("+AllTrim(GetMV("ST_CFOPVEN",,""))+") "
	cQuery += " 	THEN ROUND((SC6.C6_ZVALLIQ/SC6.C6_QTDVEN)*PA1.PA1_QUANT,2) ELSE 0 END ),0) FALTA,
	// Chamado 003051
	//cQuery += " NVL(SUM(round((SC6.C6_ZVALLIQ/SC6.C6_QTDVEN)*TA2.PA2_QUANT,2)),0)
	cQuery += " 	NVL(SUM( "

	/*************************************************************
	<<< ALTERA«√O >>> 
	AÁ„o...........: Incluir taratamento para a Empresa 11 - NEWCO
	...............: Incluido tratamento para buscar as CFOPs do par‚metro especÌfico ST_CFOPVEN
	Desenvolvedor..: Marcelo Klopfer Leme - SIGAMAT
	Data...........: 09/02/2022
	Chamado........: 20220112000947 - VIRADA APOEMA NEWCO DISTRIBUIDORA
	cQuery += " 	CASE WHEN SC6.C6_CF IN ('5405','6404','5405','5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5403','5501','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6501','6502','7101','7102') "
	*************************************************************/
	cQuery += " 	CASE WHEN SC6.C6_CF IN("+AllTrim(GetMV("ST_CFOPVEN",,""))+") 
	cQuery += " 	THEN ROUND((SC6.C6_ZVALLIQ/SC6.C6_QTDVEN)*TA2.PA2_QUANT,2) ELSE 0 END ),0) RESERVA,
	cQuery += " 	SUM(NVL((SELECT SUM(ROUND((TC6.C6_ZVALLIQ/TC6.C6_QTDVEN)*(TC6.C6_QTDVEN - TC6.C6_QTDENT),2))
	cQuery += " 			FROM " + RetSqlName("SC6") + " TC6 "
	cQuery += " 			WHERE TC6.D_E_L_E_T_   = ' '
	cQuery += " 				AND TC6.C6_QTDVEN - TC6.C6_QTDENT > 0
	cQuery += " 				AND SC5.C5_NUM      = TC6.C6_NUM
	cQuery += " 				AND SC5.C5_FILIAL   = TC6.C6_FILIAL
	cQuery += " 				AND SC6.C6_BLQ <> 'R'
	cQuery += "					AND SC6.C6_CF IN("+AllTrim(GetMV("ST_CFOPVEN",,""))+") ),0) ) TOTAL,
	cQuery += " 	SUM(
	cQuery += " 	NVL((SELECT SUM(ROUND((PC6.C6_ZVALLIQ / PC6.C6_QTDVEN) * TA1.PA1_QUANT,2))
	cQuery += " 		FROM " + RetSqlName("SC6") + " PC6 "
	cQuery += " 		INNER JOIN(SELECT * FROM " + RetSqlName("PA1") + " ) TA1 "

	/*************************************************************
	<<< ALTERA«√O >>> 
	AÁ„o...........: Incluir taratamento para a Empresa 11 - NEWCO
	...............: A loja do cliente 033467 agora È "06"
	...............: O Tipo de OperaÁ„o utilizada agora nos pedidos de venda È "01" venda anteriormente era "94" TransferÍncia.
	Desenvolvedor..: Marcelo Klopfer Leme - SIGAMAT
	Data...........: 26/01/2021
	Chamado........: 20220112000947 - VIRADA APOEMA NEWCO DISTRIBUIDORA
	cQuery += " 		ON TA1.D_E_L_E_T_ = ' ' AND TA1.PA1_DOC = PC6.C6_NUM||PC6.C6_ITEM AND TA1.PA1_FILIAL = '02'
	*************************************************************/
	IF cEmpAnt <> "11"
		cQuery += " 		ON TA1.D_E_L_E_T_ = ' ' AND TA1.PA1_DOC = PC6.C6_NUM||PC6.C6_ITEM AND TA1.PA1_FILIAL = '02'
	ELSE 
		cQuery += " 		ON TA1.D_E_L_E_T_ = ' ' AND TA1.PA1_DOC = PC6.C6_NUM||PC6.C6_ITEM AND TA1.PA1_FILIAL = '01'
	ENDIF

	cQuery += " 		WHERE PC6.D_E_L_E_T_   = ' '
	cQuery += " 	    AND PC6.C6_CF IN("+AllTrim(GetMV("ST_CFOPVEN",,""))+") 
	cQuery += " 			AND PC6.C6_QTDVEN - PC6.C6_QTDENT > 0
	cQuery += " 			AND SC5.C5_NUM      = PC6.C6_NUM
	cQuery += " 			AND SC5.C5_FILIAL   = PC6.C6_FILIAL
	cQuery += " 			AND PC6.C6_BLQ <> 'R'),0)) TOTAL_FALTA,
	cQuery += " 	SUM(
	cQuery += "		NVL((SELECT SUM(round(XC6.C6_PRCVEN*PA2.PA2_QUANT,2))
	cQuery += " 		FROM " + RetSqlName("SC6") + " XC6 "
	cQuery += " 		INNER JOIN(SELECT * FROM " + RetSqlName("PA2") + " ) PA2 "
	cQuery += " 		ON PA2.D_E_L_E_T_ = ' ' AND PA2.PA2_DOC = XC6.C6_NUM||XC6.C6_ITEM AND PA2.PA2_FILIAL = ' '
	cQuery += " 		WHERE XC6.D_E_L_E_T_   = ' '
	cQuery += " 			AND XC6.C6_QTDVEN - XC6.C6_QTDENT > 0
	cQuery += " 			AND SC5.C5_NUM = XC6.C6_NUM
	cQuery += " 			AND SC5.C5_FILIAL = XC6.C6_FILIAL
	cQuery += " 			AND XC6.C6_BLQ <> 'R'
	cQuery += "				AND XC6.C6_CF IN("+AllTrim(GetMV("ST_CFOPVEN",,""))+") ),0)) TOTAL_RESERVA,
	cQuery += " 	(SUM(
	cQuery += " 	NVL((SELECT SUM(ROUND(XC6.C6_PRCVEN*PA2.PA2_QUANT,2))
	cQuery += " 		FROM " + RetSqlName("SC6") + " XC6 "
	cQuery += " 		INNER JOIN(SELECT * FROM " + RetSqlName("PA2") + " ) PA2 "
	cQuery += "			ON PA2.D_E_L_E_T_ = ' ' AND PA2.PA2_DOC = XC6.C6_NUM||XC6.C6_ITEM AND PA2.PA2_FILIAL = ' '
	cQuery += " 		WHERE XC6.D_E_L_E_T_   = ' '
	cQuery += " 			AND XC6.C6_QTDVEN - XC6.C6_QTDENT > 0
	cQuery += " 			AND SC5.C5_NUM      = XC6.C6_NUM
	cQuery += " 			AND SC5.C5_FILIAL   = XC6.C6_FILIAL
	cQuery += " 			AND XC6.C6_BLQ <> 'R'),0)) ) / SE4.PARCELA PARCELA_RESERVADA,
	cQuery += " 	NVL(  CB7_STATUS ,'5') OS,
	cQuery += " 	NVL(  BM_XAGRUP,' ') XAGRUP,
	//Chamado 002877 Abre
	cQuery += " 	NVL(SUM(
	cQuery += " 	CASE WHEN SC6.C6_CF IN("+AllTrim(GetMV("ST_CFOPVEN",,""))+") 
	cQuery += " 	THEN ROUND(TA2.PA2_QUANT,2) ELSE 0 END ),0) A1_RESERVA,
	cQuery += " 	(NVL((SELECT SUM(ROUND(MMG.C6_QTDVEN - MMG.C6_QTDENT,2)) 
	cQuery += "			FROM "+AllTrim(GetMv("STALIASIND"))+".SC6010 MMG
	cQuery += " 		WHERE MMG.D_E_L_E_T_ = ' '
	cQuery += " 			AND MMG.C6_QTDVEN - MMG.C6_QTDENT > 0
	cQuery += " 			AND MMG.C6_PRODUTO = SC6.C6_PRODUTO
	cQuery += " 			AND MMG.C6_FILIAL  = '05'
	cQuery += " 			AND MMG.C6_CLI     = '033467'

	/*************************************************************
	<<< ALTERA«√O >>> 
	AÁ„o...........: Incluir taratamento para a Empresa 11 - NEWCO
	...............: A loja do cliente 033467 agora È "06"
	...............: O Tipo de OperaÁ„o utilizada agora nos pedidos de venda È "01" venda anteriormente era "94" TransferÍncia.
	Desenvolvedor..: Marcelo Klopfer Leme - SIGAMAT
	Data...........: 26/01/2021
	Chamado........: 20220112000947 - VIRADA APOEMA NEWCO DISTRIBUIDORA
	*************************************************************/
	IF cEmpAnt <> "11"
		cQuery += " 			AND MMG.C6_LOJA    = '02'
		cQuery += " 			AND MMG.C6_OPER    = '94'
		cQuery += " 			AND MMG.C6_BLQ     <> 'R'),0) ) A2_SLD_MMG,
	ELSE
		cQuery += " 			AND MMG.C6_LOJA    = '06'
		cQuery += " 			AND MMG.C6_OPER    = '01'
		cQuery += " 			AND MMG.C6_BLQ     <> 'R'),0) ) A2_SLD_MMG,
	ENDIF
	//Chamado 002877 Fecha
	//Chamado 0024898 Abre - Robson Mazzarotto
	cQuery += " 	(NVL((SELECT SUM(ROUND(MAO.C6_QTDVEN - MAO.C6_QTDENT,2))
	cQuery += " 		FROM "+AllTrim(GetMv("STALIASIND"))+".SC6030 MAO
	cQuery += " 		WHERE MAO.D_E_L_E_T_ = ' '
	cQuery += " 			AND MAO.C6_QTDVEN - MAO.C6_QTDENT > 0
	cQuery += " 			AND MAO.C6_PRODUTO = SC6.C6_PRODUTO
	cQuery += " 			AND MAO.C6_FILIAL  = '01'
	cQuery += " 			AND MAO.C6_CLI     = '033467'

	/*************************************************************
	<<< ALTERA«√O >>> 
	AÁ„o...........: Incluir taratamento para a Empresa 11 - NEWCO
	...............: A loja do cliente 033467 agora È "06"
	Desenvolvedor..: Marcelo Klopfer Leme - SIGAMAT
	Data...........: 26/01/2021
	Chamado........: 20220112000947 - VIRADA APOEMA NEWCO DISTRIBUIDORA
	*************************************************************/
	IF cEmpAnt <> "11"
		cQuery += " 			AND MAO.C6_LOJA    = '02'
		cQuery += " 			AND MAO.C6_OPER    = '15'
		cQuery += " 			AND MAO.C6_BLQ     <> 'R'),0) ) A2_SLD_MAO,
	ELSE
		cQuery += " 			AND MAO.C6_LOJA    = '06'
		cQuery += " 			AND MAO.C6_OPER    = '15'
		cQuery += " 			AND MAO.C6_BLQ     <> 'R'),0) ) A2_SLD_MAO,
	ENDIF

	//Chamado 002877 Fecha
	cQuery += " 	CASE WHEN C9_BLCRED = '09' THEN 'REJEITADO' ELSE CASE WHEN C9_BLCRED IN ('01','02','04','05','06') THEN 'ANALISE' ELSE 'LIBERADO' END END   AS FINANCEIRO,
	cQuery += " 	(NVL((SELECT SUM(B2_QACLASS) 
	cQuery += " 		FROM " + RetSqlName("SB2") + " B2 "
	cQuery += " 		WHERE B2.D_E_L_E_T_ = ' ' 

	/*************************************************************
	<<< ALTERA«√O >>> 
	AÁ„o...........: Incluir taratamento para a Empresa 11 - NEWCO
	...............: A loja do cliente 033467 agora È "06"
	...............: O Tipo de OperaÁ„o utilizada agora nos pedidos de venda È "01" venda anteriormente era "94" TransferÍncia.
	Desenvolvedor..: Marcelo Klopfer Leme - SIGAMAT
	Data...........: 26/01/2021
	Chamado........: 20220112000947 - VIRADA APOEMA NEWCO DISTRIBUIDORA
	*************************************************************/
	IF cEmpAnt <> "11"
		cQuery += " 			AND B2.B2_FILIAL = '02' 
	ELSE
		cQuery += " 			AND B2.B2_FILIAL = '01' 
	ENDIF

	cQuery += " AND B2.B2_COD = SC6.C6_PRODUTO ),0)) AS A3_ENDERECAR
	cQuery += " FROM " + RetSqlName("SC5") + " SC5 "
	cQuery += " LEFT JOIN( SELECT * FROM " + RetSqlName("CB7") + " ) CB7 "
	cQuery += " ON CB7.CB7_PEDIDO = SC5.C5_NUM
	cQuery += " AND CB7.D_E_L_E_T_ = ' '
	cQuery += " AND CB7.CB7_STATUS IN ('0','1','2','3','4')
	cQuery += " AND CB7.CB7_NOTA = ' '
	cQuery += " AND CB7.CB7_FILIAL =  SC5.C5_FILIAL
	cQuery += " INNER JOIN (SELECT REGEXP_COUNT(E4_COND,',',1,'i') + 1 PARCELA, E4_CODIGO, E4_DESCRI, D_E_L_E_T_ FROM " + RetSqlName("SE4") + " ) SE4 ON SE4.E4_CODIGO = SC5.C5_CONDPAG AND SE4.D_E_L_E_T_ = ' '
	cQuery += " LEFT JOIN(SELECT * FROM " + RetSqlName("SC6") + " ) SC6 ON SC6.D_E_L_E_T_   = ' ' AND SC6.C6_QTDVEN - SC6.C6_QTDENT > 0	AND SC5.C5_NUM      = SC6.C6_NUM
	If !Empty(Alltrim(MV_PAR03))
		cQuery += " AND SC6.C6_PRODUTO BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR03 + "' "
	EndIf
	cQuery += " AND SC5.C5_FILIAL   = SC6.C6_FILIAL
	cQuery += " AND SC6.C6_BLQ <> 'R'
	cQuery += " LEFT JOIN ( SELECT * FROM "+RetSqlName("SC9")+" )SC9
	cQuery += " ON SC9.D_E_L_E_T_ = ' '
	cQuery += " AND SC6.C6_NUM = SC9.C9_PEDIDO
	cQuery += " AND SC6.C6_ITEM = SC9.C9_ITEM
	cQuery += " AND SC9.C9_SEQUEN = '01'
	cQuery += " AND SC6.C6_FILIAL = SC9.C9_FILIAL
	cQuery += " LEFT JOIN ( SELECT * FROM " + RetSqlName("SB1") + " )SB1 "
	cQuery += " ON SB1.D_E_L_E_T_ = ' '
	cQuery += " AND SB1.B1_COD    = SC6.C6_PRODUTO
	cQuery += " AND SB1.B1_FILIAL = '" + xFilial("SB1") + "' "
	cQuery += " LEFT JOIN ( SELECT * FROM " + RetSqlName("SBM") + " ) SBM "
	cQuery += " ON SBM.D_E_L_E_T_ = ' '
	cQuery += " AND SBM.BM_GRUPO = SB1.B1_GRUPO
	cQuery += " AND SBM.BM_FILIAL = '" + xFilial("SBM") + "' "
	cQuery += " LEFT JOIN(SELECT * FROM " + RetSqlName("PA1") + " ) PA1 "
	cQuery += " ON PA1.D_E_L_E_T_ = ' '
	cQuery += " 	AND PA1.PA1_DOC = SC6.C6_NUM||SC6.C6_ITEM

	/*************************************************************
	<<< ALTERA«√O >>> 
	AÁ„o...........: Incluir taratamento para a Empresa 11 - NEWCO
	...............: A loja do cliente 033467 agora È "06"
	...............: O Tipo de OperaÁ„o utilizada agora nos pedidos de venda È "01" venda anteriormente era "94" TransferÍncia.
	Desenvolvedor..: Marcelo Klopfer Leme - SIGAMAT
	Data...........: 26/01/2021
	Chamado........: 20220112000947 - VIRADA APOEMA NEWCO DISTRIBUIDORA
	*************************************************************/
	IF cEmpAnt <> "11"
		cQuery += " 	AND PA1.PA1_FILIAL = '02'
	ELSE
		cQuery += " 	AND PA1.PA1_FILIAL = '01'
	ENDIF

	cQuery += " LEFT JOIN(SELECT * FROM " + RetSqlName("PA2") + " ) TA2 "
	cQuery += " ON TA2.D_E_L_E_T_ = ' '
	cQuery += " 	AND TA2.PA2_DOC = SC6.C6_NUM||SC6.C6_ITEM
	cQuery += " 	AND TA2.PA2_FILIAL =  ' '
	cQuery += " INNER JOIN(SELECT * FROM " + RetSqlName("SA1") + " ) SA1 "
	cQuery += " ON SA1.D_E_L_E_T_ = ' '
	cQuery += " 	AND SA1.A1_COD = SC5.C5_CLIENTE
	cQuery += " 	AND SA1.A1_LOJA = SC5.C5_LOJACLI
	cQuery += " 	AND SA1.A1_FILIAL = '  '
	cQuery += " LEFT JOIN (SELECT * FROM " + RetSqlName("PC1") + " ) PC1 "
	cQuery += " ON SC5.C5_NUM = PC1.PC1_PEDREP
	cQuery += " 	AND PC1.D_E_L_E_T_ = ' '
	cQuery += " LEFT JOIN(SELECT * FROM " + RetSqlName("SA3") + " ) SA3 "
	cQuery += " ON SA3.D_E_L_E_T_   = ' '
	cQuery += " 	AND SA3.A3_COD = SC5.C5_VEND2
	cQuery += " 	AND SA3.A3_FILIAL = ' '
	cQuery += " LEFT JOIN(SELECT * FROM " + RetSqlName("SA3") + " ) TA3 "
	cQuery += " ON TA3.D_E_L_E_T_ = ' '
	cQuery += " 	AND TA3.A3_COD = SC5.C5_VEND1
	cQuery += " 	AND TA3.A3_FILIAL = ' '
	cQuery += " WHERE SC5.D_E_L_E_T_ = ' '

	/*************************************************************
	<<< ALTERA«√O >>> 
	AÁ„o...........: Incluir taratamento para a Empresa 11 - NEWCO
	...............: A loja do cliente 033467 agora È "06"
	...............: O Tipo de OperaÁ„o utilizada agora nos pedidos de venda È "01" venda anteriormente era "94" TransferÍncia.
	Desenvolvedor..: Marcelo Klopfer Leme - SIGAMAT
	Data...........: 26/01/2021
	Chamado........: 20220112000947 - VIRADA APOEMA NEWCO DISTRIBUIDORA
	*************************************************************/
	IF cEmpAnt <> "11"
		cQuery += " 	AND SC5.C5_FILIAL = '02'
	ELSE
		cQuery += " 	AND SC5.C5_FILIAL = '01'
	ENDIF
	dbSelectArea('SA3')
	SA3->( dbSetOrder(7) )
	If SA3->( dbSeek(xFilial('SA3') + __cUserId) )
		If  SA3->A3_TPVEND <> 'I'
			cQuery += "  AND ( SC5.C5_VEND1	= '" + 	SA3->A3_COD + "' Or  SC5.C5_VEND2	= '" + 	SA3->A3_COD + "' )
		ElseIf (SA3->A3_TPVEND = 'I'  .And. !(Empty(Alltrim(SA3->A3_SUPER))) .And. !(Empty(Alltrim(SA3->A3_GEREN))) ) .And. !(__cUserId $ GetMv("ST_SUPCORV",,"000380#000088#000391#000366#000378#000641"))
			_cVends := SA3->A3_COD
			_cVenSt := SA3->A3_COD
			SA3->( dbGoTop() )
			While SA3->( !Eof() )
				If SA3->A3_XCODINT = _cVenSt
					_cVends := _cVends + "','" + SA3->A3_COD
				EndIf
				SA3->( dbSkip() )
			End
			cQuery += "  AND ( SC5.C5_VEND1 In ( '" + _cVends + "') Or  SC5.C5_VEND2 In ( '" + 	_cVends + "') )
		EndIf
	EndIf
	cQuery += " 	AND SC5.C5_EMISSAO BETWEEN  '" + DtoS(MV_PAR01) + "' AND '" + DtoS(MV_PAR02) + "' "
	cQuery += " 	AND SC5.C5_NOTA NOT LIKE '%XXX%'
	cQuery += " 	AND SC5.C5_TIPO = 'N' "
	cQuery += " 	AND SC5.C5_XTRONF=' ' " //Chamado 003046 - Retirar troca de nota do relatÛrio
	cQuery += " 	AND SA1.A1_GRPVEN <> 'ST'
	cQuery += " 	AND SA1.A1_EST <> 'EX'
	//Chamado 002994 - retirar validaÁ„o para pedidos de FATEC
	//cQuery += " AND PC1.PC1_PEDREP IS NULL
	cQuery += " 	AND EXISTS (SELECT * FROM " + RetSqlName("SC6") + " SC6 "
	/*
	cQuery += " INNER JOIN (SELECT * FROM SF4010) SF4
	cQuery += " ON SC6.C6_TES = SF4.F4_CODIGO
	cQuery += " 	AND SF4.D_E_L_E_T_ = ' '
	cQuery += " 	AND SF4.F4_ESTOQUE = 'S'
	cQuery += " 	AND SF4.F4_FILIAL = '"+xFilial("SF4")+"'"
	*/
	cQuery += " 				WHERE SC6.C6_NUM = SC5.C5_NUM
	cQuery += " 					AND SC6.D_E_L_E_T_ = ' '
	//cQuery += " 				AND SC6.C6_OPER = '01'
	// Chamado 003051 - Deixar todos os cfops e zerar os valores das colunas
	//cQuery += " AND SC6.C6_CF  IN ('5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5403','5501','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6501','6502','7101','7102')
	cQuery += " 					AND SC6.C6_QTDVEN - SC6.C6_QTDENT > 0
	cQuery += " 					AND SC5.C5_FILIAL = SC6.C6_FILIAL
	If !Empty(Alltrim(MV_PAR03))
		cQuery += " 				AND SC6.C6_PRODUTO  BETWEEN  '" +  MV_PAR03  + "' AND '" +  MV_PAR03 + "' "
	EndIf
	cQuery += " 					AND SC6.C6_BLQ <> 'R')
	cQuery += " 	AND EXISTS (SELECT * FROM  " + RetSqlName("SC9") + " SC9 "
	cQuery += " 				WHERE SC9.C9_PEDIDO = SC5.C5_NUM
	cQuery += " 					AND SC9.D_E_L_E_T_ = ' '
	cQuery += " 					AND SC9.C9_BLCRED = ' '
	cQuery += " 					AND SC9.C9_FILIAL = SC5.C5_FILIAL )
	If !Empty(Alltrim(MV_PAR05))
		cQuery += " 	AND SB1.B1_GRUPO  BETWEEN  '" +  MV_PAR05  + "' AND '" +  MV_PAR05 + "' "
	EndIf
	// Ticket 20210309003845 - Incluir par‚metro no relatÛrio pv com falta - Eduardo Sigamat - 03.05.2021 - Inicio
	If !Empty(Alltrim(MV_PAR06))
		cQuery += " 	AND SB1.B1_GRUPO NOT IN " + FormatIn(Alltrim(MV_PAR06),',') +  " "
	EndIf
	// Ticket 20210309003845 - Incluir par‚metro no relatÛrio pv com falta - Eduardo Sigamat  - 03.05.2021 - Fim
	// Ticket 20210223003001 - INCLUIR TIPO DE FRETE NO RELAT”RIO P.V CPM FALTA - Eduardo Sigamat - 11.05.2021 - Inicio
	If MV_PAR07 == 1
		cQuery += " 	AND SC5.C5_TPFRETE = 'C' "
	ElseIf MV_PAR07 == 2
		cQuery += " 	AND SC5.C5_TPFRETE = 'F' "
	Else
		cQuery += " 	AND SC5.C5_TPFRETE IN ('C','F') "
	EndIf
	// Ticket 20210223003001 - INCLUIR TIPO DE FRETE NO RELAT”RIO P.V CPM FALTA - Eduardo Sigamat - 11.05.2021 - Fim
	// Ticket 20210426006680 - Incluir pedido do cliente relatÛrio pv com falta - Eduardo Sigamat - inclusao dos campos C6_NUMPCOM,C6_ITEMPC no Group By
	cQuery += " GROUP BY
	cQuery += " 	C5_NUM,SB1.B1_GRUPO||'-'||SUBSTR(SBM.BM_DESC,1,30)  ,C5_EMISSAO,C5_CONDPAG,B1_CLAPROD,B1_PROC,B1_TIPO,C6_NUMPCOM,C6_ITEMPC,C5_TPFRETE,C6_OPER,C6_XORDEM,C6_QTDVEN,
	cQuery += " 	C6_QTDENT,C5_ZOBS,C5_XDTEN,C9_BLCRED,C6_DESCRI,
	cQuery += " 	C6_ITEM,C6_PRODUTO,C5_XTIPF,C5_XTIPO,C5_ZREFNF,SC5.C5_ZBLOQ,C5_TRANSP,C5_VEND1,C5_VEND2,SA3.A3_NREDUZ,TA3.A3_NREDUZ,SE4.PARCELA,
	cQuery += " 	SC5.C5_XDE||'/'||SC5.C5_XMDE||'/'||SC5.C5_XDANO,C6_ENTRE1,C6_ZENTRE2,
	//cQuery += " 	SC5.C5_XATE||'/'||SC5.C5_XMATE||'/'||SC5.C5_XAANO ,CB7_STATUS ,BM_XAGRUP ,C5_XNOME, C5_XALERTF, SB1.B1_XLIBDES, C5_XBLQFMI
	cQuery += " 	SC5.C5_XAANO||SC5.C5_XMATE||SC5.C5_XATE ,CB7_STATUS ,BM_XAGRUP ,C5_XNOME,C5_CLIENTE, C5_XALERTF, SB1.B1_XLIBDES, C5_XBLQFMI
	cQuery += " ORDER BY
	cQuery += " 	C5_NUM,C6_ITEM,TOTAL,TOTAL_FALTA
	cQuery := ChangeQuery(cQuery)
	//SELECT SB1.B1_GRUPO||'-'||SUBSTR(SBM.BM_DESC,1,30) "GRUPO",C5_NUM,C6_ITEM,C6_PRODUTO,SC5.C5_VEND1||'-'||SUBSTR(TA3.A3_NREDUZ,1,15) "VEND01",SC5.C5_VEND2||'-'||SUBSTR(SA3.A3_NREDUZ,1,15) "VEND02",CASE WHEN SC5.C5_XTIPO = '1' THEN 'RETIRA' ELSE 'ENTREGA' END "ENTREGA",CASE WHEN SC5.C5_XTIPF = '1' THEN 'TOTAL' ELSE 'PARCIAL' END "TIPO",CASE WHEN SC5.C5_ZREFNF = '1' THEN 'BLOQUEADO' ELSE 'LIBERADO' END "REFATURAMENTO",CASE WHEN SC5.C5_TRANSP = ' ' THEN 'EM BRANCO' ELSE 'PREENCHIDA' END "TRANSPORTADORA",CASE WHEN SC5.C5_ZBLOQ = '1' THEN 'BLOQUEADO' ELSE 'LIBERADO' END "COMERCIAL",SE4.PARCELA,SC5.C5_XDE||'/'||SC5.C5_XMDE "DE",SC5.C5_XATE||'/'||SC5.C5_XMATE "ATE",COALESCE(SUM(ROUND(PA1.PA1_QUANT,2)),0) "QUANT",COALESCE(SUM(ROUND((SC6.C6_ZVALLIQ/SC6.C6_QTDVEN)*PA1.PA1_QUANT,2)),0) "FALTA",COALESCE(SUM(ROUND((SC6.C6_ZVALLIQ/SC6.C6_QTDVEN)*TA2.PA2_QUANT,2)),0) "RESERVA",SUM( COALESCE((SELECT SUM(ROUND((TC6.C6_ZVALLIQ/TC6.C6_QTDVEN)*(TC6.C6_QTDVEN - TC6.C6_QTDENT),2)) FROM SC6010 TC6 WHERE  TC6.D_E_L_E_T_ = ' ' AND TC6.C6_QTDVEN - TC6.C6_QTDENT > 0 AND SC5.C5_NUM = TC6.C6_NUM AND SC5.C5_FILIAL = TC6.C6_FILIAL AND SC6.C6_BLQ <> 'R'),0) ) "TOTAL",SUM( COALESCE((SELECT SUM(ROUND((PC6.C6_ZVALLIQ/PC6.C6_QTDVEN)*TA1.PA1_QUANT,2)) FROM SC6010 PC6 INNER JOIN(SELECT * FROM PA1010 ) TA1 ON TA1.D_E_L_E_T_ = ' ' AND TA1.PA1_DOC = PC6.C6_NUM||PC6.C6_ITEM AND TA1.PA1_FILIAL= '02'  WHERE  PC6.D_E_L_E_T_ = ' ' AND PC6.C6_QTDVEN - PC6.C6_QTDENT > 0 AND SC5.C5_NUM = PC6.C6_NUM AND SC5.C5_FILIAL = PC6.C6_FILIAL AND PC6.C6_BLQ <> 'R'),0) ) "TOTAL_FALTA",SUM( COALESCE((SELECT SUM(ROUND(XC6.C6_PRCVEN*PA2.PA2_QUANT,2)) FROM SC6010 XC6 INNER JOIN(SELECT * FROM PA2010 ) PA2 ON PA2.D_E_L_E_T_ = ' ' AND PA2.PA2_DOC = XC6.C6_NUM||XC6.C6_ITEM AND PA2.PA2_FILIAL= ' '  WHERE  XC6.D_E_L_E_T_ = ' ' AND XC6.C6_QTDVEN - XC6.C6_QTDENT > 0 AND SC5.C5_NUM = XC6.C6_NUM AND SC5.C5_FILIAL = XC6.C6_FILIAL AND XC6.C6_BLQ <> 'R'),0) ) "TOTAL_RESERVA",(SUM( COALESCE((SELECT SUM(ROUND(XC6.C6_PRCVEN*PA2.PA2_QUANT,2)) FROM SC6010 XC6 INNER JOIN(SELECT * FROM PA2010 ) PA2 ON PA2.D_E_L_E_T_ = ' ' AND PA2.PA2_DOC = XC6.C6_NUM||XC6.C6_ITEM AND PA2.PA2_FILIAL= ' '  WHERE  XC6.D_E_L_E_T_ = ' ' AND XC6.C6_QTDVEN - XC6.C6_QTDENT > 0 AND SC5.C5_NUM = XC6.C6_NUM AND SC5.C5_FILIAL = XC6.C6_FILIAL AND XC6.C6_BLQ <> 'R'),0) ) )/SE4.PARCELA "PARCELA_RESERVADA",COALESCE(CB7_STATUS,'0') "OS",COALESCE(BM_XAGRUP,' ') "XAGRUP" FROM SC5010 SC5 LEFT JOIN(SELECT * FROM CB7010 ) CB7 ON CB7.CB7_PEDIDO = SC5.C5_NUM AND CB7.D_E_L_E_T_ = ' ' AND CB7.CB7_STATUS IN ('1','2','3','4') AND CB7.CB7_NOTA = ' ' AND CB7.CB7_FILIAL = SC5.C5_FILIAL INNER JOIN (SELECT REGEXP_COUNT(E4_COND,',',1,'i')+1 "PARCELA",E4_CODIGO,E4_DESCRI,D_E_L_E_T_ FROM SE4010 ) SE4 ON SE4.E4_CODIGO = SC5.C5_CONDPAG AND SE4.D_E_L_E_T_ = ' ' LEFT JOIN(SELECT * FROM SC6010 ) SC6 ON SC6.D_E_L_E_T_ = ' ' AND SC6.C6_QTDVEN - SC6.C6_QTDENT > 0 AND SC5.C5_NUM = SC6.C6_NUM AND SC5.C5_FILIAL = SC6.C6_FILIAL AND SC6.C6_BLQ <> 'R' LEFT JOIN (SELECT * FROM SB1010 ) SB1 ON SB1.D_E_L_E_T_ = ' ' AND SB1.B1_COD = SC6.C6_PRODUTO AND SB1.B1_FILIAL = '  ' LEFT JOIN (SELECT * FROM SBM010 ) SBM ON SBM.D_E_L_E_T_ = ' ' AND SBM.BM_GRUPO = SB1.B1_GRUPO AND SBM.BM_FILIAL = '  ' LEFT JOIN(SELECT * FROM PA1010 ) PA1 ON PA1.D_E_L_E_T_ = ' ' AND PA1.PA1_DOC = SC6.C6_NUM||SC6.C6_ITEM AND PA1.PA1_FILIAL= '02' LEFT JOIN(SELECT * FROM PA2010 ) TA2 ON TA2.D_E_L_E_T_ = ' ' AND TA2.PA2_DOC = SC6.C6_NUM||SC6.C6_ITEM AND TA2.PA2_FILIAL= ' ' INNER JOIN(SELECT * FROM SA1010 ) SA1 ON SA1.D_E_L_E_T_ = ' ' AND SA1.A1_COD = SC5.C5_CLIENTE AND SA1.A1_LOJA = SC5.C5_LOJACLI AND SA1.A1_FILIAL = '  ' LEFT JOIN (SELECT * FROM PC1010 ) PC1 ON SC5.C5_NUM = PC1.PC1_PEDREP AND PC1.D_E_L_E_T_ = ' ' LEFT JOIN(SELECT * FROM SA3010 ) SA3 ON SA3.D_E_L_E_T_ = ' ' AND SA3.A3_COD = SC5.C5_VEND2 AND SA3.A3_FILIAL = ' ' LEFT JOIN(SELECT * FROM SA3010 ) TA3 ON TA3.D_E_L_E_T_ = ' ' AND TA3.A3_COD = SC5.C5_VEND1 AND TA3.A3_FILIAL = ' '
	//WHERE  SC5.D_E_L_E_T_ = ' ' AND SC5.C5_FILIAL = '02' AND SC5.C5_EMISSAO BETWEEN '20120101' AND '20150101' AND SC5.C5_NOTA NOT LIKE '%XXX%' AND SC5.C5_TIPO = 'N' AND SA1.A1_GRPVEN <> 'ST' AND SA1.A1_EST <> 'EX' AND PC1.PC1_PEDREP IS NULL AND EXISTS(SELECT * FROM SC6010 SC6 INNER JOIN (SELECT * FROM SF4010 )  SF4 ON SC6.C6_TES = SF4.F4_CODIGO AND SF4.D_E_L_E_T_ = ' ' AND SF4.F4_ESTOQUE = 'S' AND SF4.F4_FILIAL = '  '  WHERE  SC6.C6_NUM = SC5.C5_NUM AND SC6.D_E_L_E_T_ = ' ' AND SC6.C6_OPER = '01' AND SC6.C6_QTDVEN - SC6.C6_QTDENT > 0 AND SC5.C5_FILIAL = SC6.C6_FILIAL AND SC6.C6_BLQ <> 'R')  AND EXISTS (SELECT * FROM SC9010 SC9 WHERE  SC9.C9_PEDIDO = SC5.C5_NUM AND SC9.D_E_L_E_T_ = ' ' AND SC9.C9_BLCRED = ' ' AND SC9.C9_FILIAL = SC5.C5_FILIAL )  GROUP BY C5_NUM,SB1.B1_GRUPO||'-'||SUBSTR(SBM.BM_DESC,1,30) , C6_ITEM,C6_PRODUTO,C5_XTIPF,C5_XTIPO,C5_ZREFNF,SC5.C5_ZBLOQ,C5_TRANSP,C5_VEND1,C5_VEND2,SA3.A3_NREDUZ,TA3.A3_NREDUZ,SE4.PARCELA, SC5.C5_XDE||'/'||SC5.C5_XMDE, SC5.C5_XATE||'/'||SC5.C5_XMATE ,CB7_STATUS ,BM_XAGRUP  ORDER BY  C5_NUM, C6_ITEM,TOTAL,TOTAL_FALTA

	If Select(cAliasLif) > 0
		(cAliasLif)->( dbCloseArea() )
	EndIf
	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

Return
