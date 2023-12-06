#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"
#Define CR chr(13)+chr(10) 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  RSTFATCS     ºAutor  ³Giovani Zago    º Data ³  27/08/19     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Relatorio  COMEX - Exportação                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RSTFATCS()

	Local   oReport
	Private cPerg 			:= "RFATCS"
	Private cTime           := Time()
	Private cHora           := SUBSTR(cTime, 1, 2)
	Private cMinutos    	:= SUBSTR(cTime, 4, 2)
	Private cSegundos   	:= SUBSTR(cTime, 7, 2)
	Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos
	Private lXlsHeader      := .f.
	Private lXmlEndRow      := .f.
	Private cPergTit 		:= cAliasLif

	U_STPutSx1( cPerg, "01","Data de:" 		   			,"MV_PAR01","mv_ch1","D",08,0,"G",,""  		,"@!")
	U_STPutSx1( cPerg, "02","Data ate:"					,"MV_PAR02","mv_ch2","D",08,0,"G",,""  		,"@!")

	oReport		:= ReportDef()

	oReport:PrintDialog()

Return

Static Function ReportDef()

	Local oReport
	Local oSection

	oReport := TReport():New(cPergTit,"RELATÓRIO Exportação",cPerg,{|oReport| ReportPrint(oReport)},"Este programa irá imprimir um relatório da Exportação.")

	Pergunte(cPerg,.F.)

	oSection := TRSection():New(oReport,"Exportação",{"SC5"})

	TRCell():New(oSection,"38",,"PV Protheus"				,,06,.F.,)
	TRCell():New(oSection,"01",,"EXP/Invoice"				,,06,.F.,)
	TRCell():New(oSection,"02",,"Importador"				,,06,.F.,)
	TRCell():New(oSection,"03",,"Consignatario" 			,,06,.F.,)
	TRCell():New(oSection,"04",,"País" 						,,06,.F.,)
	TRCell():New(oSection,"05",,"Unidade Origem"			,,06,.F.,)
	TRCell():New(oSection,"06",,"Unidade Requisitante" 		,,06,.F.,)
	TRCell():New(oSection,"07",,"Data do pedido"			,,06,.F.,)
	TRCell():New(oSection,"08",,"Incoterm"					,,06,.F.,)
	TRCell():New(oSection,"09",,"Modal"						,,06,.F.,)
	TRCell():New(oSection,"10",,"Data da Fatura" 			,,06,.F.,)
	TRCell():New(oSection,"11",,"Peso Liquido (KG)" 		,"@E 99,999,999.999",14)
	TRCell():New(oSection,"12",,"Peso Bruto (KG)"			,"@E 99,999,999.999",14)
	TRCell():New(oSection,"13",,"Cubagem (m³)" 				,"@E 99,999,999.999",14)
	TRCell():New(oSection,"14",,"Quantidade de Volumes"		,"@E 99,999,999",14)
	TRCell():New(oSection,"15",,"Tipo de embalagem "		,,06,.F.,)	 
	TRCell():New(oSection,"16",,"Equipamento "				,,06,.F.,)
	TRCell():New(oSection,"17",,"Quantidade de caixas"		,"@E 99,999,999",14)
	TRCell():New(oSection,"18",,"Moeda" 					,,06,.F.,)
	TRCell():New(oSection,"19",,"Valor da Fatura FOB (USD)" ,"@E 99,999,999.99",14)
	TRCell():New(oSection,"20",,"Frete (USD)"				,"@E 99,999,999.99",14)
	TRCell():New(oSection,"21",,"Seguro (USD)" 				,"@E 99,999,999.99",14)
	TRCell():New(oSection,"22",,"Desconto (USD)"			,"@E 99,999,999.99",14)
	TRCell():New(oSection,"23",,"Valor Total da Fatura(USD)","@E 99,999,999.99",14)
	TRCell():New(oSection,"24",,"Condição de Pagamento da Fatura",,06,.F.,)
	TRCell():New(oSection,"25",,"Condição de Pagamento da Fatura - Dias",,06,.F.,)
	TRCell():New(oSection,"26",,"Transportadora" 				,,30,.F.,)
	TRCell():New(oSection,"27",,"Nº NF"						,,06,.F.,)
	TRCell():New(oSection,"28",,"Data NF " 					,,06,.F.,)
	TRCell():New(oSection,"29",," Valor NF  " 				,"@E 99,999,999.99",14)
	TRCell():New(oSection,"30",,"Taxa de Conversão"			,"@E 99,999,999.9999",14)
	TRCell():New(oSection,"31",,"DRE / DUE"					,,06,.F.,)
	TRCell():New(oSection,"32",,"Data Averbação" 			,,06,.F.,)
	TRCell():New(oSection,"33",,"ETD" 						,,06,.F.,)
	TRCell():New(oSection,"34",,"ETA"						,,06,.F.,)
	TRCell():New(oSection,"35",,"SISCOSERV" 				,,06,.F.,)
	TRCell():New(oSection,"36",,"Nº do Conhecimento"		,,06,.F.,)
	TRCell():New(oSection,"37",,"Data do Conhecimento"		,,06,.F.,) 

	oSection:SetHeaderSection(.t.)
	oSection:Setnofilter("SW9")

Return oReport

Static Function ReportPrint(oReport)

	Local oSection	:= oReport:Section(1)
	Local oSection1	:= oReport:Section(1)
	Local nT1		:= 0
	Local nT2		:= 0
	Local cQuery 	:= ""
	Local aDados[2]
	Local aDados1[99]
	Local _cObs		:= ""
	oSection1:Cell('38')      :SetBlock( { || aDados1[38] } )
	oSection1:Cell('01')      :SetBlock( { || aDados1[01] } )
	oSection1:Cell('02')      :SetBlock( { || aDados1[02] } )
	oSection1:Cell('03')      :SetBlock( { || aDados1[03] } )
	oSection1:Cell('04')      :SetBlock( { || aDados1[04] } )
	oSection1:Cell('05')      :SetBlock( { || aDados1[05] } )
	oSection1:Cell('06')      :SetBlock( { || aDados1[06] } )
	oSection1:Cell('07')      :SetBlock( { || aDados1[07] } )
	oSection1:Cell('08')      :SetBlock( { || aDados1[08] } )
	oSection1:Cell('09')      :SetBlock( { || aDados1[09] } )
	oSection1:Cell('10')      :SetBlock( { || aDados1[10] } )
	oSection1:Cell('11')      :SetBlock( { || aDados1[11] } )
	oSection1:Cell('12')      :SetBlock( { || aDados1[12] } )
	oSection1:Cell('13')      :SetBlock( { || aDados1[13] } )
	oSection1:Cell('14')      :SetBlock( { || aDados1[14] } )
	oSection1:Cell('15')      :SetBlock( { || aDados1[15] } )
	oSection1:Cell('16')      :SetBlock( { || aDados1[16] } )
	oSection1:Cell('17')      :SetBlock( { || aDados1[17] } )
	oSection1:Cell('18')      :SetBlock( { || aDados1[18] } )
	oSection1:Cell('19')      :SetBlock( { || aDados1[19] } )
	oSection1:Cell('20')      :SetBlock( { || aDados1[20] } )
	oSection1:Cell('21')      :SetBlock( { || aDados1[21] } )
	oSection1:Cell('22')      :SetBlock( { || aDados1[22] } )
	oSection1:Cell('23')      :SetBlock( { || aDados1[23] } )
	oSection1:Cell('24')      :SetBlock( { || aDados1[24] } )
	oSection1:Cell('25')      :SetBlock( { || aDados1[25] } )
	oSection1:Cell('26')      :SetBlock( { || aDados1[26] } )
	oSection1:Cell('27')      :SetBlock( { || aDados1[27] } )
	oSection1:Cell('28')      :SetBlock( { || aDados1[28] } )
	oSection1:Cell('29')      :SetBlock( { || aDados1[29] } )
	oSection1:Cell('30')      :SetBlock( { || aDados1[30] } )
	oSection1:Cell('31')      :SetBlock( { || aDados1[31] } )
	oSection1:Cell('32')      :SetBlock( { || aDados1[32] } )
	oSection1:Cell('33')      :SetBlock( { || aDados1[33] } )
	oSection1:Cell('34')      :SetBlock( { || aDados1[34] } )
	oSection1:Cell('35')      :SetBlock( { || aDados1[35] } )
	oSection1:Cell('36')      :SetBlock( { || aDados1[36] } )
	oSection1:Cell('37')      :SetBlock( { || aDados1[37] } )


	oReport:SetTitle("Exportação")// Titulo do relatório

	oReport:SetMeter(0)
	aFill(aDados,nil)
	aFill(aDados1,nil)
	oSection:Init()

	Processa({|| StQuery( ) },"Compondo Relatorio")

	dbSelectArea(cAliasLif)
	(cAliasLif)->(dbgotop())
	If  Select(cAliasLif) > 0

		While 	(cAliasLif)->(!Eof())

			aDados1[01]	:= (cAliasLif)->EEC_NRINVO
			aDados1[02]	:= (cAliasLif)->EEC_IMPODE
			aDados1[03]	:=  POSICIONE("SA1",1,XFILIAL("SA1")+(cAliasLif)->EEC_CONSIG+(cAliasLif)->EEC_COLOJA,"A1_NOME")                                                         
			aDados1[04] :=  Posicione("SYA",1,xFilial("SYA")+(cAliasLif)->EEC_PAISET ,"YA_DESCR") 
			aDados1[05] := (cAliasLif)->F2_UFORIG
			aDados1[06] := (cAliasLif)->F2_FILIAL
			aDados1[07] := (cAliasLif)->EE7_DTPEDI
			aDados1[08] := (cAliasLif)->EEC_INCOTE
			aDados1[09] :=  Posicione("SYQ",1,xFilial('SYQ')+(cAliasLif)->EEC_VIA,"YQ_COD_DI")                                                                                              
			aDados1[10] := (cAliasLif)->EEC_DTINVO
			aDados1[11] := (cAliasLif)->F2_PLIQUI
			aDados1[12] := (cAliasLif)->F2_PBRUTO
			aDados1[13] := (cAliasLif)->EX9_XCUB
			aDados1[14] := (cAliasLif)->F2_VOLUME1
			aDados1[15] := (cAliasLif)->F2_ESPECI1
			aDados1[16] := (cAliasLif)->EQUIPAMENTO
			aDados1[17] := (cAliasLif)->EX9_XTOT
			aDados1[18] := (cAliasLif)->EEC_MOEDA
			aDados1[19] := (cAliasLif)->EEC_TOTFOB
			aDados1[20] := (cAliasLif)->EEC_FRPREV
			aDados1[21] := (cAliasLif)->EEC_SEGPRE
			aDados1[22] := (cAliasLif)->EEC_DESCON
			aDados1[23] := (cAliasLif)->EEC_TOTLIQ
			//>>Ticket 20201001008219 - Everson Santana - 01.10.2020
			If !Empty((cAliasLif)->EEC_CONDPA)

				DbSelectArea("SYP")
				SYP->(DbSetOrder(1))
				SYP->(DbGoTop())
				SYP->(DbSeek(xFilial("SYP")+(cAliasLif)->EEC_CONDPA))

				While SYP->(!Eof()) .And. SYP->YP_CHAVE==(cAliasLif)->EEC_CONDPA
					_cObs += StrTran(SYP->YP_TEXTO,"\13\10","")
					SYP->(DbSkip())
				EndDo

			EndIf
			aDados1[24] := _cObs
			//aDados1[24] := MSMM( Posicione("SY6",1,xFilial('SY6')+(cAliasLif)->EEC_CONDPA,"Y6_DESC_P"),48)

			//<<Ticket 20201001008219

			
			aDados1[25] := Alltrim(StrTran(Posicione("SE4",1,xFilial("SE4")+(cAliasLif)->F2_COND,"E4_DESCRI"),"DDL",""))  
			aDados1[26] := Alltrim(Posicione("SA4",1,xFilial("SA4")+(cAliasLif)->F2_TRANSP,"A4_NOME")) 
			aDados1[27] := (cAliasLif)->F2_DOC
			aDados1[28] := (cAliasLif)->F2_EMISSAO
			aDados1[29] := (cAliasLif)->F2_VALBRUT
			aDados1[30] := (cAliasLif)->TX
			aDados1[31] := (cAliasLif)->EEC_NRODUE
			aDados1[32] := dTOC(STOD((cAliasLif)->EEC_DTDUE))
			aDados1[33] := dTOC(STOD((cAliasLif)->EEC_DTEMBA ))
			aDados1[34] := dTOC(STOD((cAliasLif)->EEC_ETADES ))
			aDados1[35] := (cAliasLif)->SISCOSERV 
			aDados1[36] := (cAliasLif)->EEC_NRCONH 
			aDados1[37] := dTOC(STOD((cAliasLif)->EEC_DTCONH ))
			aDados1[38] := (cAliasLif)->D2_PEDIDO

			oSection1:PrintLine()
			aFill(aDados1,nil)

			(cAliasLif)->(dbskip())

		End

	EndIf
	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	oReport:SkipLine()

Return oReport

Static Function StQuery()

	Local cQuery      := ' '

	cQuery += CR+ "    SELECT  D2_PEDIDO,EEC_COLOJA,
	cQuery += CR+ "    EEC_NRINVO,EEC_IMPODE,	EEC_CONSIG,	EEC_PAISET,	F2_UFORIG,	F2_FILIAL,	SUBSTR(EE7_DTPEDI,7,2)||'/'||SUBSTR(EE7_DTPEDI,5,2)||'/'||SUBSTR(EE7_DTPEDI,1,4)          AS EE7_DTPEDI,    	EEC_INCOTE,	EEC_VIA,SUBSTR(EEC_DTINVO,7,2)||'/'||SUBSTR(EEC_DTINVO,5,2)||'/'||SUBSTR(EEC_DTINVO,1,4)          AS EEC_DTINVO,    
	cQuery += CR+ "    F2_PLIQUI,	F2_PBRUTO,	EX9_XCUB,	F2_VOLUME1,	F2_ESPECI1,	EEC_ONTHEP as EQUIPAMENTO,	EX9_XTOT,	EEC_MOEDA,	EEC_TOTFOB,	
	cQuery += CR+ "    EEC_FRPREV,	EEC_SEGPRE,	EEC_DESCON,	EEC_TOTLIQ,	EEC_CONDPA,	F2_COND,F2_TRANSP ,	F2_DOC,SUBSTR(F2_EMISSAO,7,2)||'/'||SUBSTR(F2_EMISSAO,5,2)||'/'||SUBSTR(F2_EMISSAO,1,4)          AS F2_EMISSAO,	 	F2_VALBRUT,
	cQuery += CR+ "    ROUND(F2_VALBRUT/EEC_TOTPED,4) as TX,	EEC_NRODUE,	EEC_DTDUE,	EEC_DTEMBA,	EEC_ETADES, EEC_XSIS as SISCOSERV,	EEC_NRCONH,	EEC_DTCONH
	cQuery += CR+ "    FROM "+RetSqlName("SF2")+" SF2
	cQuery += CR+ "    INNER JOIN(SELECT * FROM "+RetSqlName("SD2")+") SD2
	cQuery += CR+ "    ON SD2.D_E_L_E_T_ = ' '
	cQuery += CR+ "    AND D2_FILIAL = F2_FILIAL
	cQuery += CR+ "    AND D2_DOC = F2_DOC
	cQuery += CR+ "    AND D2_SERIE = F2_SERIE
	cQuery += CR+ "    AND D2_ITEM = '01'
	cQuery += CR+ "    INNER JOIN(SELECT * FROM "+RetSqlName("EE7")+") EE7
	cQuery += CR+ "    ON EE7.D_E_L_E_T_ = ' '
	cQuery += CR+ "    AND EE7_FILIAL = F2_FILIAL
	cQuery += CR+ "    AND EE7_PEDFAT = D2_PEDIDO
	cQuery += CR+ "    INNER JOIN(SELECT * FROM "+RetSqlName("EEC")+") EEC
	cQuery += CR+ "    ON EEC.D_E_L_E_T_ = ' '
	cQuery += CR+ "    AND EEC_FILIAL = F2_FILIAL
	//cQuery += CR+ "    AND EEC_PEDREF = EE7_PEDIDO
	cQuery += CR+ "    AND EEC_AMOSTR = '2'
	cQuery += CR+ "    AND EEC_PREEMB = D2_PREEMB
	cQuery += CR+ "    INNER JOIN(SELECT * FROM "+RetSqlName("EX9")+") EX9
	cQuery += CR+ "    ON EX9.D_E_L_E_T_ = ' '
	cQuery += CR+ "    AND EX9_FILIAL = F2_FILIAL
	cQuery += CR+ "    AND TRIM(EX9_PREEMB) = TRIM(EEC_PREEMB)
	cQuery += CR+ "    WHERE SF2.D_E_L_E_T_ = ' '
	If cEmpAnt = '01' 
	    // Adicionado filial 05 - Valdemir Rabelo Ticket: 20210701011291 01/07/2021
		cQuery += CR+ "    AND F2_FILIAL IN ('02','05')
	Else
		cQuery += CR+ "    AND F2_FILIAL = '01'
	End
	cQuery += CR+ "    AND F2_EST = 'EX'
	cQuery += CR+ "    AND F2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"'

	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

Return()

