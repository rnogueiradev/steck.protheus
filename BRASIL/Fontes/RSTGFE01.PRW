#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RSTGFE01    ºAutor  ³Richard N. Cabral   º Data ³  08/05/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relatorio completo do frete embarcador                       º±±
±±º          ³                                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*-----------------------------*
User Function RSTGFE01()				//U_RSTGFE01()
*-----------------------------*
	Local   oReport
	Private cPerg			:= "RSTGFE01"
	Private cTime			:= Time()
	Private cHora			:= SUBSTR(cTime, 1, 2)
	Private cMinutos		:= SUBSTR(cTime, 4, 2)
	Private cSegundos		:= SUBSTR(cTime, 7, 2)
	Private cAliasLif		:= cPerg+cHora+cMinutos+cSegundos
	Private lXlsHeader		:= .f.
	Private lXmlEndRow		:= .f.
	Private cPergTit		:= cAliasLif
	Private aTPDF			:= {"1=Normal","2=Complementar Valor","3=Complementar Imposto","4=Reentrega","5=Devolucao","6=Redespacho","7=Servico"}
	Private aSit			:= {"1=Recebido","2=Bloqueado","3=Aprov.Sistema","4=Aprov.Usuario"}                                                                          
	Private aTomad			:= {"0=Remetente","1=Expedidor","2=Recebedor","3=Destinatário"}                                                                          
	Private aSitFisc		:= {"1=Nao Enviado","2=Pendente","3=Rejeitado","4=Atualizado","5=Pendente Desatualizacao","6=Nao se Aplica"}                                     
	Private aSitRec			:= {"1=Nao Enviado","2=Pendente","3=Rejeitado","4=Atualizado","5=Pendente Desatualizacao","6=Nao se Aplica"}                                     
	Private aTpFrete		:= {"TRT","TDE","SEGURO FLUVIAL","TAS","SUFRAMA","TSB","GRIS"}
	Private aVlFrete		:= {0,0,0,0,0,0,0}
	Private nTxCofins		:= GetMv("MV_TXCOFIN",,7.60)
	Private nTxPis			:= GetMv("MV_TXPIS"	 ,,1.65)

	U_STPutSx1( cPerg, "01","Data Emissão de?" 		   		,"MV_PAR01","mv_ch1","D",08,0,"G",,""  		,"@!")
	U_STPutSx1( cPerg, "02","Data Emissão ate?"				,"MV_PAR02","mv_ch2","D",08,0,"G",,""  		,"@!")
	U_STPutSx1( cPerg, "03","Transp de:"    			  	,"MV_PAR03","mv_ch3","C",06,0,"G",,"SA4"	,"@!")
	U_STPutSx1( cPerg, "04","Transp Até:"   			  	,"MV_PAR04","mv_ch4","C",06,0,"G",,"SA4"	,"@!")

	oReport		:= ReportDef()
	oReport:PrintDialog()

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ReportDef   ºAutor  ³Richard N. Cabral   º Data ³  08/05/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relatorio completo do frete embarcador                       º±±
±±º          ³                                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*-----------------------------*
Static Function ReportDef()
*-----------------------------*
	Local oReport
	Local oSection

	oReport := TReport():New(cPergTit,"Relatório Completo de Frete Embarcador",cPerg,{|oReport| ReportPrint(oReport)},"Este programa irá imprimir um relatório completo de frete embarcador")

	Pergunte(cPerg,.F.)

	oSection := TRSection():New(oReport,"SF2",{"SF2"})

	TRCell():New(oSection,"F2_FILIAL"		,,"FILIAL"				,,02,.F.,)					//01
	TRCell():New(oSection,"F2_DOC"			,,"DOCUMENTO"			,,09,.F.,)					//02
	TRCell():New(oSection,"F2_SERIE"		,,"SERIE"				,,03,.F.,)					//03
	TRCell():New(oSection,"F2_CLIENTE"		,,"CLIENTE"				,,06,.F.,)					//04
	TRCell():New(oSection,"F2_LOJA"			,,"LOJA"				,,02,.F.,)					//05
	TRCell():New(oSection,"A1_NOME"			,,"NOME"				,,40,.F.,)					//06
	TRCell():New(oSection,"F2_EMISSAO"		,,"EMISSAO"				,,10,.F.,)					//07
	TRCell():New(oSection,"F2_EST"			,,"UF DESTINO"			,,02,.F.,)					//08
	TRCell():New(oSection,"F2_VALBRUT"		,,"VAL BRUTO"			,"@E 99,999,999.99",14)		//09
	TRCell():New(oSection,"F2_VALICM"		,,"VAL ICMS"			,"@E 99,999,999.99",14)		//10
	TRCell():New(oSection,"F2_BASEICM"		,,"BASE ICMS"			,"@E 99,999,999.99",14)		//11
	TRCell():New(oSection,"F2_VALIPI"		,,"VAL IPI"				,"@E 99,999,999.99",14)		//12
	TRCell():New(oSection,"F2_BASEIPI"		,,"BASE IPI"			,"@E 99,999,999.99",14)		//13
	TRCell():New(oSection,"F2_VALMERC"		,,"VAL LIQUIDO"			,"@E 99,999,999.99",14)		//14
	TRCell():New(oSection,"F2_VOLUME1"		,,"VOLUMES"				,"@E 99,999,999.99",14)		//15
	TRCell():New(oSection,"F2_PLIQUI"		,,"PESO LIQ"			,"@E 99,999,999.99",14)		//16
	TRCell():New(oSection,"F2_PBRUTO"		,,"PESO BRUT"			,"@E 99,999,999.99",14)		//17
	TRCell():New(oSection,"F2_TRANSP"		,,"TRANSPORTADORA"		,,06,.F.,)					//18
	TRCell():New(oSection,"A4_NOME"			,,"NOME TRANSP"			,,40,.F.,)					//19
	TRCell():New(oSection,"F2_CHVNFE"		,,"CHAVE NFE"			,,44,.F.,)					//20
	TRCell():New(oSection,"F2_XCODROM"		,,"COD ROMANEIO"		,,10,.F.,)					//21
	TRCell():New(oSection,"F2_XCUBAGE"		,,"CUBAGEM TOTAL"		,,20,.F.,)					//22
	TRCell():New(oSection,"F2_XCEP"			,,"CEP ENTREGA"			,,10,.F.,)					//23
	TRCell():New(oSection,"F2_XCIDADE"		,,"CIDADE ENTREGA"		,,20,.F.,)					//24
	TRCell():New(oSection,"F2_XOBSROM"		,,"OBSERV ROMANEIO"		,,80,.F.,)					//25
	TRCell():New(oSection,"PEDIDO"			,,"PEDIDO VENDA"		,,10,.F.,)					//26
	TRCell():New(oSection,"OS"				,,"OS"					,,10,.F.,)					//27
	TRCell():New(oSection,"STATUSX"			,,"STATUS PEDIDO"		,,10,.F.,)					//28
	TRCell():New(oSection,"GW3_NRDF"		,,"DOCUM FRETE"			,,10,.F.,)					//29
	TRCell():New(oSection,"GW3_CDESP"		,,"ESPECIE"				,,05,.F.,)					//30
	TRCell():New(oSection,"GW3_DTEMIS"		,,"DATA DOCTO FRETE"	,,10,.F.,)					//31
	TRCell():New(oSection,"CTE"				,,"CTE"					,,44,.F.,)					//32
	TRCell():New(oSection,"VLRFRETE"		,,"FRETE SISTEMA"		,"@E 99,999,999.99",14)		//33
	TRCell():New(oSection,"TPDF"			,,"TIPO"				,,20,.F.,)					//34
	TRCell():New(oSection,"GW3_DTENT"		,,"DATA ENTRADA"		,,10,.F.,)					//35
	TRCell():New(oSection,"GW3_SIT"			,,"SITUACAO"			,,20,.F.,)					//36
	TRCell():New(oSection,"GW3_USUIMP"		,,"USUARIO ENTRADA"		,,50,.F.,)					//37
	TRCell():New(oSection,"REMETENTE"		,,"NOME REMETENTE"		,,40,.F.,)					//38
	TRCell():New(oSection,"DESTINATARIO"	,,"NOME DESTINATARIO"	,,40,.F.,)					//39
	TRCell():New(oSection,"VLRDOC"			,,"VALOR CT-E"			,"@E 99,999,999.99",14)		//40
	TRCell():New(oSection,"GW3_TAXAS"		,,"TAXAS"				,"@E 99,999,999.99",14)		//41
	TRCell():New(oSection,"GW3_FRPESO"		,,"FRETE PESO"			,"@E 99,999,999.99",14)		//42
	TRCell():New(oSection,"GW3_FRVAL"		,,"FRETE VALOR"			,"@E 99,999,999.99",14)		//43
	TRCell():New(oSection,"GW3_PEDAG"		,,"VALOR PEDAGIO"		,"@E 99,999,999.99",14)		//44
	TRCell():New(oSection,"GW3_PDGFRT"		,,"PEDAGIO FRETE"		,,05,.F.,)					//45
	TRCell():New(oSection,"GW3_ICMPDG"		,,"PEDAGIO ICMS"		,,05,.F.,)					//46
	TRCell():New(oSection,"GW3_PDGPIS"		,,"PEDAGIO PIS/CF"		,,05,.F.,)					//47
	TRCell():New(oSection,"TRT"				,,"TRT"					,"@E 99,999,999.99",14)		//48
	TRCell():New(oSection,"TDE"				,,"TDE"					,"@E 99,999,999.99",14)		//49
	TRCell():New(oSection,"SEG_FLUVIAL"		,,"SEGURO FLUVIAL"		,"@E 99,999,999.99",14)		//50
	TRCell():New(oSection,"TAS"				,,"TAS"					,"@E 99,999,999.99",14)		//51
	TRCell():New(oSection,"SUFRAMA"			,,"SUFRAMA"				,"@E 99,999,999.99",14)		//52
	TRCell():New(oSection,"TSB"				,,"TSB"					,"@E 99,999,999.99",14)		//53
	TRCell():New(oSection,"GRIS"			,,"GRIS"				,"@E 99,999,999.99",14)		//54
	TRCell():New(oSection,"GW3_PESOD"		,,"PESO DECLARADO"		,"@E 99,999,999.99",14)		//55
	TRCell():New(oSection,"FRETE_LIQ"		,,"FRETE LIQUIDO"		,"@E 99,999,999.99",14)		//56
	TRCell():New(oSection,"TP_FRETE"		,,"TIPO FRETE CTE"		,,20,.F.,)					//57
	TRCell():New(oSection,"GW3_QTDCS"		,,"QTDE DOCTO"			,"@E 99,999,999.99",14)		//58
	TRCell():New(oSection,"GW3_QTVOL"		,,"QTDE VOLUME"			,"@E 99,999,999.99",14)		//59
	TRCell():New(oSection,"GW3_PESOR"		,,"PESO AFERIDO"		,"@E 99,999,999.99",14)		//60
	TRCell():New(oSection,"GW3_VLCARG"		,,"VALOR CARGA"			,"@E 99,999,999.99",14)		//61
	TRCell():New(oSection,"GW3_BASIMP"		,,"BASE IMPOSTO"		,"@E 99,999,999.99",14)		//62
	TRCell():New(oSection,"GW3_PCIMP"		,,"ALIQ IMPOSTO"		,"@E 99,999,999.99",14)		//63
	TRCell():New(oSection,"GW3_VLIMP"		,,"VALOR ICMS"			,"@E 99,999,999.99",14)		//64
	TRCell():New(oSection,"F2_EST2"			,,"ESTADO"				,,05,.F.,)					//65
	TRCell():New(oSection,"MOTAPR"			,,"MOTIVO APROV"		,,200,.F.,)					//66
	TRCell():New(oSection,"FRETENF"			,,"FRETE NF"			,,05,.F.,)					//67
	TRCell():New(oSection,"GW3_DTBLQ"		,,"DATA BLOQUEIO"		,,10,.F.,)					//68
	TRCell():New(oSection,"GW3_USUBLQ"		,,"USUARIO BLOQUEIO"	,,50,.F.,)					//69
	TRCell():New(oSection,"DTAPR"			,,"DATA APROVACAO"		,,10,.F.,)					//70
	TRCell():New(oSection,"USUAPR"			,,"USUARIO APROVACAO"	,,50,.F.,)					//71
	TRCell():New(oSection,"GW3_EMIFAT"		,,"EMISSAO FATURA"		,,14,.F.,)					//72
	TRCell():New(oSection,"GW3_SERFAT"		,,"SERIE FATURA"		,,05,.F.,)					//73
	TRCell():New(oSection,"GW3_NRFAT"		,,"NRO FATURA"			,,16,.F.,)					//74
	TRCell():New(oSection,"GW3_DTEMFA"		,,"DT EMISSAO FATURA"	,,10,.F.,)					//75
	TRCell():New(oSection,"GW3_FILFAT"		,,"FILIAL FATURA"		,,05,.F.,)					//76
	TRCell():New(oSection,"GW3_SITFIS"		,,"SITUACAO FISCAL"		,,20,.F.,)					//77
	TRCell():New(oSection,"D1_DTDIGIT"		,,"DATA RECEBIM"		,,10,.F.,)					//78
	TRCell():New(oSection,"GW3_SITREC"		,,"SIT RECEB"			,,20,.F.,)					//79
	TRCell():New(oSection,"GW6_DTVENC"		,,"DATA VENC FATURA"	,,10,.F.,)					//80
	TRCell():New(oSection,"GW6_DTEMIS"		,,"DATA ENVIO FINANC"	,,10,.F.,)					//81
	TRCell():New(oSection,"D1_EMISSAO"		,,"DATA LANC FISCAL"	,,10,.F.,)					//82
	TRCell():New(oSection,"INTEG_FINANC"	,,"INTEG.FINANC"		,,10,.F.,)					//83
	TRCell():New(oSection,"PIS"				,,"VALOR PIS"			,"@E 99,999,999.99",14)		//84
	TRCell():New(oSection,"COFINS"			,,"VALOR COFINS"		,"@E 99,999,999.99",14)		//85

	oSection:SetHeaderSection(.t.)
	oSection:Setnofilter("SF2")

Return oReport

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ReportPrint ºAutor  ³Richard N. Cabral   º Data ³  08/05/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relatorio MMG                                                º±±
±±º          ³                                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*------------------------------------*
Static Function ReportPrint(oReport)
*------------------------------------*
	Local oSection	:= oReport:Section(1)
	Local oSection1	:= oReport:Section(1)
	Local nX		:= 0
	Local aDados[2]
	Local aDados1[99]

	oSection1:Cell('F2_FILIAL')  		:SetBlock( { || aDados1[01] } )
	oSection1:Cell('F2_DOC')  			:SetBlock( { || aDados1[02] } )
	oSection1:Cell('F2_SERIE') 			:SetBlock( { || aDados1[03] } )
	oSection1:Cell('F2_CLIENTE')  		:SetBlock( { || aDados1[04] } )
	oSection1:Cell('F2_LOJA') 			:SetBlock( { || aDados1[05] } )
	oSection1:Cell('A1_NOME')  			:SetBlock( { || aDados1[06] } )
	oSection1:Cell('F2_EMISSAO')  		:SetBlock( { || aDados1[07] } )
	oSection1:Cell('F2_EST') 	 		:SetBlock( { || aDados1[08] } )
	oSection1:Cell('F2_VALBRUT')  		:SetBlock( { || aDados1[09] } )
	oSection1:Cell('F2_VALICM')  		:SetBlock( { || aDados1[10] } )
	oSection1:Cell('F2_BASEICM')  		:SetBlock( { || aDados1[11] } )
	oSection1:Cell('F2_VALIPI')  		:SetBlock( { || aDados1[12] } )
	oSection1:Cell('F2_BASEIPI')  		:SetBlock( { || aDados1[13] } )
	oSection1:Cell('F2_VALMERC') 		:SetBlock( { || aDados1[14] } )
	oSection1:Cell('F2_VOLUME1')  		:SetBlock( { || aDados1[15] } )
	oSection1:Cell('F2_PLIQUI') 		:SetBlock( { || aDados1[16] } )
	oSection1:Cell('F2_PBRUTO') 		:SetBlock( { || aDados1[17] } )
	oSection1:Cell('F2_TRANSP') 		:SetBlock( { || aDados1[18] } )
	oSection1:Cell('A4_NOME') 			:SetBlock( { || aDados1[19] } )
	oSection1:Cell('F2_CHVNFE') 		:SetBlock( { || aDados1[20] } )
	oSection1:Cell('F2_XCODROM') 		:SetBlock( { || aDados1[21] } )
	oSection1:Cell('F2_XCUBAGE') 		:SetBlock( { || aDados1[22] } )
	oSection1:Cell('F2_XCEP') 			:SetBlock( { || aDados1[23] } )
	oSection1:Cell('F2_XCIDADE') 		:SetBlock( { || aDados1[24] } )
	oSection1:Cell('F2_XOBSROM') 		:SetBlock( { || aDados1[25] } )
	oSection1:Cell('PEDIDO') 			:SetBlock( { || aDados1[26] } )
	oSection1:Cell('OS') 				:SetBlock( { || aDados1[27] } )
	oSection1:Cell('STATUSX')	 		:SetBlock( { || aDados1[28] } )
	oSection1:Cell('GW3_NRDF')	 		:SetBlock( { || aDados1[29] } )
	oSection1:Cell('GW3_CDESP')	 		:SetBlock( { || aDados1[30] } )
	oSection1:Cell('GW3_DTEMIS')		:SetBlock( { || aDados1[31] } )
	oSection1:Cell('CTE')				:SetBlock( { || aDados1[32] } )
	oSection1:Cell('VLRFRETE')			:SetBlock( { || aDados1[33] } )
	oSection1:Cell('TPDF') 				:SetBlock( { || aDados1[34] } )
	oSection1:Cell('GW3_DTENT') 		:SetBlock( { || aDados1[35] } )
	oSection1:Cell('GW3_SIT')			:SetBlock( { || aDados1[36] } )
	oSection1:Cell('GW3_USUIMP') 		:SetBlock( { || aDados1[37] } )
	oSection1:Cell('REMETENTE') 		:SetBlock( { || aDados1[38] } )
	oSection1:Cell('DESTINATARIO') 		:SetBlock( { || aDados1[39] } )
	oSection1:Cell('VLRDOC') 			:SetBlock( { || aDados1[40] } )
	oSection1:Cell('GW3_TAXAS') 		:SetBlock( { || aDados1[41] } )
	oSection1:Cell('GW3_FRPESO') 		:SetBlock( { || aDados1[42] } )
	oSection1:Cell('GW3_FRVAL') 		:SetBlock( { || aDados1[43] } )
	oSection1:Cell('GW3_PEDAG') 		:SetBlock( { || aDados1[44] } )
	oSection1:Cell('GW3_PDGFRT') 		:SetBlock( { || aDados1[45] } )
	oSection1:Cell('GW3_ICMPDG') 		:SetBlock( { || aDados1[46] } )
	oSection1:Cell('GW3_PDGPIS') 		:SetBlock( { || aDados1[47] } )
	oSection1:Cell('TRT') 				:SetBlock( { || aDados1[48] } )
	oSection1:Cell('TDE')		 		:SetBlock( { || aDados1[49] } )
	oSection1:Cell('SEG_FLUVIAL') 		:SetBlock( { || aDados1[50] } )
	oSection1:Cell('TAS') 				:SetBlock( { || aDados1[51] } )
	oSection1:Cell('SUFRAMA') 			:SetBlock( { || aDados1[52] } )
	oSection1:Cell('TSB')		 		:SetBlock( { || aDados1[53] } )
	oSection1:Cell('GRIS')		 		:SetBlock( { || aDados1[54] } )
	oSection1:Cell('GW3_PESOD') 		:SetBlock( { || aDados1[55] } )
	oSection1:Cell('FRETE_LIQ') 		:SetBlock( { || aDados1[56] } )
	oSection1:Cell('TP_FRETE')	 		:SetBlock( { || aDados1[57] } )
	oSection1:Cell('GW3_QTDCS') 		:SetBlock( { || aDados1[58] } )
	oSection1:Cell('GW3_QTVOL') 		:SetBlock( { || aDados1[59] } )
	oSection1:Cell('GW3_PESOR') 		:SetBlock( { || aDados1[60] } )
	oSection1:Cell('GW3_VLCARG') 		:SetBlock( { || aDados1[61] } )
	oSection1:Cell('GW3_BASIMP') 		:SetBlock( { || aDados1[62] } )
	oSection1:Cell('GW3_PCIMP') 		:SetBlock( { || aDados1[63] } )
	oSection1:Cell('GW3_VLIMP') 		:SetBlock( { || aDados1[64] } )
	oSection1:Cell('F2_EST2') 			:SetBlock( { || aDados1[65] } )
	oSection1:Cell('MOTAPR') 			:SetBlock( { || aDados1[66] } )
	oSection1:Cell('FRETENF') 			:SetBlock( { || aDados1[67] } )
	oSection1:Cell('GW3_DTBLQ') 		:SetBlock( { || aDados1[68] } )
	oSection1:Cell('GW3_USUBLQ') 		:SetBlock( { || aDados1[69] } )
	oSection1:Cell('DTAPR') 			:SetBlock( { || aDados1[70] } )
	oSection1:Cell('USUAPR')	 		:SetBlock( { || aDados1[71] } )
	oSection1:Cell('GW3_EMIFAT') 		:SetBlock( { || aDados1[72] } )
	oSection1:Cell('GW3_SERFAT') 		:SetBlock( { || aDados1[73] } )
	oSection1:Cell('GW3_NRFAT') 		:SetBlock( { || aDados1[74] } )
	oSection1:Cell('GW3_DTEMFA') 		:SetBlock( { || aDados1[75] } )
	oSection1:Cell('GW3_FILFAT') 		:SetBlock( { || aDados1[76] } )
	oSection1:Cell('GW3_SITFIS') 		:SetBlock( { || aDados1[77] } )
	oSection1:Cell('D1_DTDIGIT') 		:SetBlock( { || aDados1[78] } )			//GW3_DTREC
	oSection1:Cell('GW3_SITREC') 		:SetBlock( { || aDados1[79] } )
	oSection1:Cell('GW6_DTVENC') 		:SetBlock( { || aDados1[80] } )
	oSection1:Cell('GW6_DTEMIS') 		:SetBlock( { || aDados1[81] } )
	oSection1:Cell('D1_EMISSAO') 		:SetBlock( { || aDados1[82] } )
	oSection1:Cell('INTEG_FINANC') 		:SetBlock( { || aDados1[83] } )
	oSection1:Cell('PIS')		 		:SetBlock( { || aDados1[84] } )
	oSection1:Cell('COFINS') 			:SetBlock( { || aDados1[85] } )

	oReport:SetTitle("SF2")// Titulo do relatório

	oReport:SetMeter(0)
	aFill(aDados,nil)
	aFill(aDados1,nil)
	oSection:Init()

	Processa({|| StQuery() },"Compondo Relatorio")

	GWI->(DbSetOrder(1))
	
	DbSelectArea(cAliasLif)
	(cAliasLif)->(DbGoTop())

	If  Select(cAliasLif) > 0
	
		Do While (cAliasLif)->(!Eof())

			aVlFrete := {0,0,0,0,0,0,0}
			
			GWI->(DbSeek((cAliasLif)->F2_FILIAL + (cAliasLif)->GWI_NRCALC))
			
			Do While GWI->GWI_FILIAL + GWI->GWI_NRCALC = (cAliasLif)->F2_FILIAL + (cAliasLif)->GWI_NRCALC .And. ! GWI->(Eof())
				nPosTpFrete := aScan(aTpFrete,{|x| x = Alltrim(GWI->GWI_CDCOMP)})
				If ! Empty(nPosTpFret)
					aVlFrete[nPosTpFrete] += GWI->GWI_VLFRET
				EndIf
				GWI->(DbSkip())
			EndDo 

			nPosTPDF	:= aScan(aTPDF		, {|x| Substr(x,1,1) == (cAliasLif)->GW3_TPDF	})
			nPosSit		:= aScan(aSit 		, {|x| Substr(x,1,1) == (cAliasLif)->GW3_SIT	})
			nPosSitFisc	:= aScan(aSitFisc	, {|x| Substr(x,1,1) == (cAliasLif)->GW3_SITFIS	})
			nPosSitRec	:= aScan(aSitRec	, {|x| Substr(x,1,1) == (cAliasLif)->GW3_SITREC	})
			nPosTomad	:= aScan(aTomad		, {|x| Substr(x,1,1) == (cAliasLif)->GW3_TOMAD	})

			aDados1[01]	:=  (cAliasLif)->F2_FILIAL
			aDados1[02]	:=  (cAliasLif)->F2_DOC
			aDados1[03]	:=  (cAliasLif)->F2_SERIE
			aDados1[04]	:=  (cAliasLif)->F2_CLIENTE
			aDados1[05]	:=  (cAliasLif)->F2_LOJA
			aDados1[06]	:=  (cAliasLif)->A1_NOME
			aDados1[07]	:=	DTOC(STOD((cAliasLif)->F2_EMISSAO))
			aDados1[08]	:= 	(cAliasLif)->F2_EST
			aDados1[09]	:= 	(cAliasLif)->F2_VALBRUT
			aDados1[10]	:= 	(cAliasLif)->F2_VALICM
			aDados1[11]	:= 	(cAliasLif)->F2_BASEICM
			aDados1[12]	:= 	(cAliasLif)->F2_VALIPI
			aDados1[13]	:= 	(cAliasLif)->F2_BASEIPI
			aDados1[14]	:= 	(cAliasLif)->F2_VALMERC
			aDados1[15]	:=	(cAliasLif)->F2_VOLUME1
			aDados1[16]	:=	(cAliasLif)->F2_PLIQUI
			aDados1[17]	:=	(cAliasLif)->F2_PBRUTO
			aDados1[18]	:=	(cAliasLif)->F2_TRANSP
			aDados1[19]	:=	(cAliasLif)->A4_NOME
			aDados1[20]	:=	(cAliasLif)->F2_CHVNFE
			aDados1[21]	:=	(cAliasLif)->F2_XCODROM
			aDados1[22]	:=	(cAliasLif)->F2_XCUBAGE
			aDados1[23]	:=	(cAliasLif)->F2_XCEP
			aDados1[24]	:=	(cAliasLif)->F2_XCIDADE
			aDados1[25]	:=	(cAliasLif)->F2_XOBSROM
			aDados1[26]	:=	(cAliasLif)->PEDIDO
			aDados1[27]	:=	(cAliasLif)->OS
			aDados1[28]	:=	(cAliasLif)->STATUSX
			aDados1[29]	:=	(cAliasLif)->GW3_NRDF
			aDados1[30]	:=	(cAliasLif)->GW3_CDESP
			aDados1[31]	:=	DTOC(STOD((cAliasLif)->GW3_DTEMIS))
			aDados1[32]	:=	(cAliasLif)->CTE
			aDados1[33]	:=	(cAliasLif)->VLRFRETE
			aDados1[34]	:=	IF(Empty(nPosTPDF)," ",Substr(aTPDF[nPosTPDF],3))
			aDados1[35]	:=	DTOC(STOD((cAliasLif)->GW3_DTENT))
			aDados1[36]	:=	IF(Empty(nPosSit)," ",Substr(aSit[nPosSit],3))
			aDados1[37]	:=	(cAliasLif)->GW3_USUIMP
			aDados1[38]	:=	(cAliasLif)->REMETENTE
			aDados1[39]	:=	(cAliasLif)->DESTINATARIO
			aDados1[40]	:=	(cAliasLif)->VLRDOC
			aDados1[41]	:=	(cAliasLif)->GW3_TAXAS
			aDados1[42]	:=	(cAliasLif)->GW3_FRPESO
			aDados1[43]	:=	(cAliasLif)->GW3_FRVAL
			aDados1[44]	:=	(cAliasLif)->GW3_PEDAG
			aDados1[45]	:=	If((cAliasLif)->GW3_PDGFRT = "1","Sim","Não")			//1=Sim;2=Nao
			aDados1[46]	:=	If((cAliasLif)->GW3_ICMPDG = "1","Sim","Não")			//1=Sim;2=Nao
			aDados1[47]	:=	If((cAliasLif)->GW3_PDGPIS = "1","Sim","Não")			//1=Sim;2=Nao
			aDados1[48]	:=	aVlFrete[1]
			aDados1[49]	:=	aVlFrete[2]
			aDados1[50]	:=	aVlFrete[3]
			aDados1[51]	:=	aVlFrete[4]
			aDados1[52]	:=	aVlFrete[5]
			aDados1[53]	:=	aVlFrete[6]
			aDados1[54]	:=	aVlFrete[7]
			aDados1[55]	:=	(cAliasLif)->GW3_PESOD
			aDados1[56]	:=	(cAliasLif)->VLRDOC - (cAliasLif)->GW3_VLIMP - ( (cAliasLif)->VLRDOC * nTxPis / 100 ) - ( (cAliasLif)->VLRDOC * nTxCofins / 100 )			//(cAliasLif)->D1_TOTAL - (cAliasLif)->D1_VALICM - (cAliasLif)->PIS - (cAliasLif)->COFINS		//(cAliasLif)->VLRDOC - (cAliasLif)->GW3_VLIMP 
			aDados1[57]	:=	IF(Empty(nPosTomad)," ",Substr(aTomad[nPosTomad],3))
			aDados1[58]	:=	(cAliasLif)->GW3_QTDCS
			aDados1[59]	:=	(cAliasLif)->GW3_QTVOL
			aDados1[60]	:=	(cAliasLif)->GW3_PESOR
			aDados1[61]	:=	(cAliasLif)->GW3_VLCARG
			aDados1[62]	:=	(cAliasLif)->GW3_BASIMP
			aDados1[63]	:=	(cAliasLif)->GW3_PCIMP
			aDados1[64]	:=	(cAliasLif)->GW3_VLIMP
			aDados1[65]	:=	(cAliasLif)->F2_EST
			aDados1[66]	:=	(cAliasLif)->MOTAPR
			aDados1[67]	:=	IIf((cAliasLif)->F2_TPFRETE=="C","CIF",IIf((cAliasLif)->F2_TPFRETE=="F","FOB",(cAliasLif)->F2_TPFRETE))
			aDados1[68]	:=	DTOC(STOD((cAliasLif)->GW3_DTBLQ))
			aDados1[69]	:=	(cAliasLif)->GW3_USUBLQ
			aDados1[70]	:=	DTOC(STOD((cAliasLif)->DTAPR))
			aDados1[71]	:=	(cAliasLif)->USUAPR
			aDados1[72]	:=	(cAliasLif)->GW3_EMIFAT
			aDados1[73]	:=	(cAliasLif)->GW3_SERFAT
			aDados1[74]	:=	(cAliasLif)->GW3_NRFAT
			aDados1[75]	:=	DTOC(STOD((cAliasLif)->GW3_DTEMFA))
			aDados1[76]	:=	(cAliasLif)->GW3_FILFAT
			aDados1[77]	:=	IF(Empty(nPosSitFisc)," ",Substr(aSitFisc[nPosSitFisc],3))
			aDados1[78]	:=	DTOC(STOD((cAliasLif)->D1_DTDIGIT))
			aDados1[79]	:=	IF(Empty(nPosSitRec)," ",Substr(aSitRec[nPosSitRec],3))
			aDados1[80]	:=	DTOC(STOD((cAliasLif)->GW6_DTVENC))
			aDados1[81]	:=	DTOC(STOD((cAliasLif)->GW6_DTEMIS))
			aDados1[82]	:=	DTOC(STOD((cAliasLif)->D1_EMISSAO))
			aDados1[83]	:=	If(Empty((cAliasLif)->GW6_NRFAT),"Não","Sim")
			aDados1[84]	:=	(cAliasLif)->VLRDOC * nTxPis / 100							//(cAliasLif)->PIS
			aDados1[85]	:=	(cAliasLif)->VLRDOC * nTxCofins / 100						//(cAliasLif)->COFINS

			oSection1:PrintLine()
			aFill(aDados1,nil)
			(cAliasLif)->(dbskip())
		EndDo
	
		oSection1:PrintLine()
		aFill(aDados1,nil)
	
		(cAliasLif)->(dbCloseArea())
	EndIf
	oReport:SkipLine()
Return oReport

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³StQuery     ºAutor  ³Richard N. Cabral   º Data ³  08/05/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relatorio completo do frete embarcador                       º±±
±±º          ³                                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*-----------------------------*
Static Function StQuery()
*-----------------------------*

	Local cQuery     := ' '

	cQuery := " SELECT EMB.*, F2_FILIAL, F2_DOC, F2_SERIE, F2_CLIENTE, F2_LOJA, A1_NOME, F2_EMISSAO, F2_VALBRUT, F2_VALMERC, F2_BASEICM, F2_VALICM, F2_BASEIPI, F2_VALIPI, F2_EST, F2_TPFRETE, " + CRLF
	cQuery += " F2_VOLUME1, F2_CHVNFE, F2_XCODROM, F2_XCUBAGE, F2_XCEP, F2_XCIDADE, F2_XOBSROM, F2_PLIQUI, F2_PBRUTO, F2_TRANSP, A4_NOME, GW1_TPFRET, " + CRLF
	cQuery += " GW3_CDESP, NVL(GW3_CTE,' ') CTE, GW3_DTEMIS, GW3_TPDF, GW3_DTENT, GW3_USUIMP, GW3_SITFIS, GW3_DTREC, GW3_SITREC, GW3_TOMAD, GW3_PESOD, " + CRLF
	cQuery += " GW3_TAXAS, GW3_FRPESO, GW3_FRVAL, GW3_PEDAG, GW3_PDGFRT, GW3_ICMPDG, GW3_PDGPIS, GW3_QTDCS, GW3_QTVOL, GW3_PESOR, GW3_VLPIS, GW3_VLCOF, " + CRLF
	cQuery += " GW3_VLCARG, GW3_BASIMP, GW3_PCIMP, GW3_VLIMP, GW3_DTBLQ, GW3_USUBLQ, GW3_EMIFAT, GW3_SERFAT, GW3_NRFAT, GW3_DTEMFA, GW3_FILFAT, " + CRLF
	cQuery += " GW1_CDTPDC, GW1_EMISDC, GW1_SERDC, GW1_NRDC, GW3_SERDF, GW3_NRDF, D1_SERIE, D1_DOC, D1_ITEM, D1_COD, " + CRLF 
	cQuery += " GW6_EMIFAT, GW6_SERFAT, GW6_NRFAT, GW6_DTEMIS, GW6_DTVENC, " + CRLF
	cQuery += " D1_VALCOF, D1_VALPIS, D1_VALICM, D1_TOTAL, D1_EMISSAO, D1_DTDIGIT, D1_VALIMP5 COFINS, D1_VALIMP6 PIS, " + CRLF
	cQuery += " NVL(GW3_VLDF,0) VLRDOC, NVL(GW3_USUAPR,' ') USUAPR, NVL(GW3_DTAPR,' ') DTAPR, GW3_SIT, NVL(utl_raw.cast_to_varchar2(dbms_lob.substr(GW3_MOTAPR, 2000, 1)),' ') MOTAPR, " + CRLF 
	cQuery += " GU3REM.GU3_NMEMIT REMETENTE, GU3DES.GU3_NMEMIT DESTINATARIO, " + CRLF
	cQuery += " GWI_NRCALC, NVL(SUM(GWI_VLFRET),0) VLRFRETE " + CRLF
	cQuery += " FROM " + RetSqlName("SF2") + " F2 " + CRLF
	cQuery += " LEFT JOIN " + RetSqlName("SA1") + " A1 ON A1_COD = F2_CLIENTE AND A1_LOJA = F2_LOJA " + CRLF
	cQuery += " LEFT JOIN " + RetSqlName("GW1") + " G1 ON GW1_FILIAL = F2_FILIAL AND GW1_SERDC = F2_SERIE AND GW1_NRDC = F2_DOC AND G1.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += " LEFT JOIN " + RetSqlName("GWH") + " GH ON GWH_FILIAL = GW1_FILIAL AND GW1_SERDC = GWH_SERDC AND GW1_NRDC = GWH_NRDC AND GH.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += " LEFT JOIN " + RetSqlName("GWI") + " GI ON GWH_FILIAL = GWI_FILIAL AND GWH_NRCALC = GWI_NRCALC AND GI.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += " LEFT JOIN " + RetSqlName("GW4") + " G4 ON GW1_FILIAL = GW4_FILIAL AND GW1_SERDC = GW4_SERDC AND GW1_NRDC = GW4_NRDC AND G4.D_E_L_E_T_ = ' ' " + CRLF 
	cQuery += " LEFT JOIN " + RetSqlName("GW3") + " G3 ON GW3_FILIAL = GW4_FILIAL AND GW3_CDESP = GW4_CDESP AND GW3_SERDF = GW4_SERDF AND GW3_NRDF = GW4_NRDF AND G3.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += " LEFT JOIN " + RetSqlName("GW6") + " G6 ON GW6_FILIAL = GW3_FILIAL AND GW6_EMIFAT = GW3_EMIFAT AND GW6_SERFAT = GW3_SERFAT AND GW6_NRFAT = GW3_NRFAT AND G6.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += " LEFT JOIN " + RetSqlName("SD1") + " D1 ON D1_FILIAL = GW3_FILIAL AND D1_SERIE = GW3_SERDF AND D1_DOC = GW3_NRDF AND D1_ITEM = '0001' AND D1_COD = 'FRETE' AND D1.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += " LEFT JOIN " + RetSqlName("SA4") + " A4 ON A4_COD=F2_TRANSP AND A4.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += " LEFT JOIN " + RetSqlName("GU3") + " GU3REM ON GU3REM.GU3_CDEMIT = GW3_CDREM  AND GU3REM.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += " LEFT JOIN " + RetSqlName("GU3") + " GU3DES ON GU3DES.GU3_CDEMIT = GW3_CDDEST AND GU3DES.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += " LEFT JOIN (SELECT SC5.C5_NUM PEDIDO, CB7.CB7_ORDSEP OS, SC5.C5_FILIAL FILIAL, " + CRLF
	cQuery += " CASE WHEN CB7.CB7_STATUS = '0' THEN '0-Inicio' ELSE " + CRLF
	cQuery += " CASE WHEN CB7.CB7_STATUS = '1' THEN '1-Separando' ELSE " + CRLF
	cQuery += " CASE WHEN CB7.CB7_STATUS = '2' THEN '2-Sep.Final' ELSE " + CRLF
	cQuery += " CASE WHEN CB7.CB7_STATUS = '3' THEN '3-Embalando' ELSE " + CRLF
	cQuery += " CASE WHEN CB7.CB7_STATUS = '4' THEN '4-Emb.Final' ELSE " + CRLF
	cQuery += " CASE WHEN CB7.CB7_STATUS = '8' THEN '8-Embarcado' ELSE " + CRLF
	cQuery += " CASE WHEN CB7.CB7_STATUS = '9' THEN '9-Embarque Finalizado' ELSE 'SEM NUMERACAO' END END END END END END END STATUSX, " + CRLF 
	cQuery += " CB7.CB7_NOTA NF " + CRLF
	cQuery += " FROM " + RetSqlName("SC5") + " SC5 " + CRLF
	cQuery += " INNER JOIN ( " + CRLF
	cQuery += " SELECT * " + CRLF
	cQuery += " FROM " + RetSqlName("CB7") + " ) CB7 ON CB7.D_E_L_E_T_ = ' ' " + CRLF 
	cQuery += " AND CB7_FILIAL = SC5.C5_FILIAL " + CRLF
	cQuery += " AND CB7_PEDIDO = SC5.C5_NUM " + CRLF
	cQuery += " AND CB7_ORDSEP  BETWEEN '      ' AND 'ZZZZZZ' " + CRLF
	cQuery += " AND CB7.CB7_FILIAL = '" + xFilial("CB7") +  "' " + CRLF
//	cQuery += " AND CB7.CB7_DTEMIS BETWEEN '" + DTOS(MV_PAR01) + "' AND '" + DTOS(MV_PAR02) + "' " + CRLF
	cQuery += " WHERE SC5.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += " AND SC5.C5_FILIAL = '" + xFilial("SC5") +  "' " + CRLF
	cQuery += " AND SC5.C5_NUM  BETWEEN '      ' AND 'ZZZZZZ' " + CRLF
	cQuery += " ) EMB ON EMB.FILIAL = F2_FILIAL AND EMB.NF = F2_DOC " + CRLF
	cQuery += " WHERE F2.D_E_L_E_T_ = ' ' AND A1.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += " AND F2_EMISSAO BETWEEN '" + DTOS(MV_PAR01) + "' AND '" + DTOS(MV_PAR02) + "' " + CRLF
	cQuery += " AND F2_TRANSP BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' " + CRLF
	cQuery += " GROUP BY F2_FILIAL, F2_DOC, F2_SERIE, F2_CLIENTE, F2_LOJA, A1_NOME, F2_EMISSAO, F2_VALBRUT, F2_VALMERC, F2_BASEICM, F2_VALICM, F2_BASEIPI, F2_VALIPI, F2_EST, F2_TPFRETE, " + CRLF 
	cQuery += " F2_VOLUME1, F2_CHVNFE, F2_XCODROM, F2_XCUBAGE, F2_XCEP, F2_XCIDADE, F2_XOBSROM, F2_PLIQUI, F2_PBRUTO, F2_TRANSP, A4_NOME, GW1_TPFRET,  " + CRLF
	cQuery += " GW3_CDESP, GW3_CTE, GW3_NRFAT, GW3_DTEMIS, GW3_TPDF, GW3_DTENT, GW3_USUIMP, GW3_SITFIS, GW3_DTREC, GW3_SITREC, GW3_TOMAD, GW3_PESOD,  " + CRLF
	cQuery += " GW3_VLDF, GW3_TAXAS, GW3_FRPESO, GW3_FRVAL, GW3_PEDAG, GW3_PDGFRT, GW3_ICMPDG, GW3_PDGPIS, GW3_QTDCS, GW3_QTVOL, GW3_PESOR, GW3_VLPIS, GW3_VLCOF, " + CRLF
	cQuery += " GW3_VLCARG, GW3_BASIMP, GW3_PCIMP, GW3_VLIMP, GW3_DTBLQ, GW3_USUBLQ, GW3_EMIFAT, GW3_SERFAT, GW3_NRFAT, GW3_DTEMFA, GW3_FILFAT,  " + CRLF
	cQuery += " GW3_USUAPR, GW3_DTAPR, GW3_SIT, utl_raw.cast_to_varchar2(dbms_lob.substr(GW3_MOTAPR, 2000, 1)), GWI_NRCALC,  " + CRLF
	cQuery += " GW1_CDTPDC, GW1_EMISDC, GW1_SERDC, GW1_NRDC, GW3_SERDF, GW3_NRDF, D1_SERIE, D1_DOC, D1_ITEM, D1_COD, " + CRLF 
	cQuery += " GW6_EMIFAT, GW6_SERFAT, GW6_NRFAT, GW6_DTEMIS, GW6_DTVENC, " + CRLF
	cQuery += " D1_VALCOF, D1_VALPIS, D1_VALICM, D1_TOTAL, D1_EMISSAO, D1_DTDIGIT, D1_VALIMP5, D1_VALIMP6, " + CRLF
	cQuery += " GU3REM.GU3_NMEMIT, GU3DES.GU3_NMEMIT, EMB.PEDIDO, EMB.OS, EMB.FILIAL, EMB.STATUSX, EMB.NF " + CRLF 
	cQuery += " ORDER BY F2_DOC " + CRLF

	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

Return()
