#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  RSTFATA6     บAutor  ณRENATO.NOGUEIRA บ Data ณ  27/10/15     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relatorio de or็amentos 				              	    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*-----------------------------*
User Function RSTFATA6()
	*-----------------------------*
	Local   oReport
	Private cPerg 		:= "RFATA6"
	Private cTime        := Time()
	Private cHora        := SUBSTR(cTime, 1, 2)
	Private cMinutos    	:= SUBSTR(cTime, 4, 2)
	Private cSegundos   	:= SUBSTR(cTime, 7, 2)
	Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos
	Private lXlsHeader   := .F.
	Private lXmlEndRow   := .F.
	Private cPergTit 		:= cAliasLif


	PutSx1(cPerg, "01", "Vendedor  de:  " ,"Vendedor de:  " ,"Vendedor de:  " ,"mv_ch1","C" ,06 ,0 ,0 ,"G","" , 'SA3' ,"","","mv_par01","","","","","","","","","","","","","","","","")
	PutSx1(cPerg, "02", "Vendedor Ate:  " ,"Vendedor Ate: " ,"Vendedor Ate: " ,"mv_ch2","C" ,06 ,0 ,0 ,"G","" , 'SA3' ,"","","mv_par02","","","","","","","","","","","","","","","","")
	PutSx1(cPerg, "03", "Da Emissao:    " ,"Da Emissao:   " ,"Da Emissao:" ,"mv_ch3","D" ,08 ,0 ,0 ,"G","" ,"" ,"","","mv_par03","","","","","","","","","","","","","","","","")
	PutSx1(cPerg, "04", "At้ a Emissao: " ,"At้ a Emissao:" ,"At้ a Emissao:" ,"mv_ch4","D" ,08 ,0 ,0 ,"G","" ,"" ,"","","mv_par04","","","","","","","","","","","","","","","","")
	PutSx1(cPerg, "05", "Analํtico(A) Sintetico(S)","Analํtico(A) Sintetico(S)","Analํtico(A) Sintetico(S)","mv_ch5","C" ,1 ,0 ,0 ,"G","" ,"" ,"","","mv_par05","","","","","","","","","","","","","","","","")
	PutSx1(cPerg, "06", "Supervisor de: " ,"Vendedor de:  " ,"Vendedor de:  " ,"mv_ch1","C" ,06 ,0 ,0 ,"G","" , 'SA3' ,"","","mv_par01","","","","","","","","","","","","","","","","")
	PutSx1(cPerg, "07", "Supervisor Ate:" ,"Vendedor Ate: " ,"Vendedor Ate: " ,"mv_ch2","C" ,06 ,0 ,0 ,"G","" , 'SA3' ,"","","mv_par02","","","","","","","","","","","","","","","","")


	oReport:= ReportDef()
	oReport:PrintDialog()

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ReportDef    บAutor  ณGiovani Zago    บ Data ณ  04/07/15     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relatorio MMG 							                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*-----------------------------*
Static Function ReportDef()
	*-----------------------------*
	Local oReport
	Local oSection

	oReport := TReport():New(cPergTit,"RELATำRIO de or็amentos",cPerg,{|oReport| ReportPrint(oReport)},"Este programa irแ imprimir um relat๓rio para anแlise dos or็amentos")

	Pergunte(cPerg,.T.)

	oSection := TRSection():New(oReport,"Relat๓rio de or็amentos",{"SUA"})

	If MV_PAR05=="S"

		TRCell():New(oSection,"01",,"VENDEDOR"				,,06,.F.,)
		TRCell():New(oSection,"02",,"NOME"					,,40,.F.,)
		TRCell():New(oSection,"03",,"VALOR" 				,"@E 99,999,999.99",14)
		TRCell():New(oSection,"04",,"ORCAMENTOS" 			,"@E 99,999,999.99",14)
		TRCell():New(oSection,"05",,"VIROU PEDIDO"			,"@E 99,999,999.99",14)
		TRCell():New(oSection,"12",,"VLR VP" 				,"@E 99,999,999.99",14)
		TRCell():New(oSection,"06",,"CANCELADOS"			,"@E 99,999,999.99",14)
		TRCell():New(oSection,"13",,"VVL CAN" 				,"@E 99,999,999.99",14)
		TRCell():New(oSection,"07",,"ABERTOS"				,"@E 99,999,999.99",14)
		TRCell():New(oSection,"14",,"VVL ABER" 				,"@E 99,999,999.99",14)
		TRCell():New(oSection,"08",,"TOTAL INTERAวีES"		,"@E 99,999,999.99",14)
		TRCell():New(oSection,"09",,"SEM INTERAวรO"			,"@E 99,999,999.99",14)
		TRCell():New(oSection,"10",,"VENCIDAS"				,"@E 99,999,999.99",14)
		TRCell():New(oSection,"11",,"A VENCER"				,"@E 99,999,999.99",14)

	Else

		TRCell():New(oSection,"01",,"FILIAL"				,,02,.F.,)
		TRCell():New(oSection,"02",,"ORวAMENTO"				,,06,.F.,)
		TRCell():New(oSection,"03",,"EMISSAO"				,,20,.F.,)
		TRCell():New(oSection,"04",,"CLIENTE" 				,,10,.F.,)
		TRCell():New(oSection,"05",,"LOJA"	    			,,02,.F.,)
		TRCell():New(oSection,"06",,"NOME"					,,40,.F.,)
		TRCell():New(oSection,"07",,"VALOR"					,"@E 99,999,999.99",14)
		TRCell():New(oSection,"08",,"VIROU PEDIDO?"			,,03,.F.,)
		TRCell():New(oSection,"09",,"CANCELADO?"			,,03,.F.,)
		TRCell():New(oSection,"10",,"EM ABERTO?"			,,03,.F.,)
		TRCell():New(oSection,"11",,"OPERADOR"				,,10,.F.,)
		TRCell():New(oSection,"12",,"NOME OPERADOR"			,,50,.F.,)
		TRCell():New(oSection,"13",,"VENDEDOR"				,,10,.F.,)
		TRCell():New(oSection,"14",,"NOME VENDEDOR"			,,50,.F.,)

		TRCell():New(oSection,"15",,"SUPERVISOR"			,,10,.F.,)
		TRCell():New(oSection,"16",,"NOME SUPERVISOR"		,,50,.F.,)


		TRCell():New(oSection,"17",,"TOTA INTERAวีES"		,"@E 99,999,999.99",14)
		TRCell():New(oSection,"18",,"INTERAGIU?"			,,03,.F.,)
		TRCell():New(oSection,"19",,"VENCIDA?"				,,03,.F.,)
		TRCell():New(oSection,"20",,"A VENCER?"				,,03,.F.,)
		TRCell():New(oSection,"21",,"MOTIVO"				,,30,.F.,)
		TRCell():New(oSection,"22",,"OBS"					,,30,.F.,)
		TRCell():New(oSection,"23",,"PEDIDO"				,,30,.F.,)
		TRCell():New(oSection,"24",,"NOTA"					,,30,.F.,)


	EndIf

	oSection:SetHeaderSection(.t.)
	oSection:Setnofilter("SUA")

Return oReport
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ReportPrint  บAutor  ณGiovani Zago    บ Data ณ  04/07/15     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relatorio MMG 							                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*------------------------------------*
Static Function ReportPrint(oReport)
	*------------------------------------*
	Local oSection	:= oReport:Section(1)
	Local oSection1	:= oReport:Section(1)
	Local aDados[2]
	Local aDados1[99]
	Local _n01:= 0
	Local _n02:= 0
	Local _n03:= 0
	Local _n04:= 0
	Local _n05:= 0
	Local _n06:= 0
	Local _nv01:= 0
	Local _nv02:= 0
	Local _nv03:= 0
	Local _nv04:= 0
	Local _nv05:= 0
	Local _nv06:= 0



	If MV_PAR05=="S"

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

	Else

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
	EndIf


	oReport:SetTitle("SUA")// Titulo do relat๓rio

	oReport:SetMeter(0)
	aFill(aDados,nil)
	aFill(aDados1,nil)
	oSection:Init()


	Processa({|| StQuery(  ) },"Compondo Relatorio")

	DbSelectArea(cAliasLif)
	(cAliasLif)->(DbGoTop())
	If  Select(cAliasLif) > 0

		While 	(cAliasLif)->(!Eof())

			If MV_PAR05=="S"

				aDados1[01]	:=  (cAliasLif)->VENDEDOR
				aDados1[02]	:=  (cAliasLif)->NOME
				aDados1[03]	:=  (cAliasLif)->VALOR
				//aDados1[04]	:=  (cAliasLif)->ORCAMENTOS
				aDados1[04]	:=  (cAliasLif)->VIROUPED + (cAliasLif)->CANCELADOS +  (cAliasLif)->ABERTAS
				aDados1[05]	:=  (cAliasLif)->VIROUPED
				aDados1[06]	:=	(cAliasLif)->CANCELADOS
				aDados1[07]	:= 	(cAliasLif)->ABERTAS
				aDados1[08]	:= 	(cAliasLif)->INTERACOES
				aDados1[09]	:= 	(cAliasLif)->SEMINTERACOES
				aDados1[10]	:= 	(cAliasLif)->VENCIDAS
				aDados1[11]	:= 	(cAliasLif)->AVENCER
				aDados1[12]	:= 	(cAliasLif)->VLRVP
				aDados1[13]	:= 	(cAliasLif)->VVLCAN
				aDados1[14]	:= 	(cAliasLif)->VVLABER

			Else

				aDados1[01]	:=	(cAliasLif)->UA_FILIAL
				aDados1[02]	:=	(cAliasLif)->UA_NUM
				aDados1[03]	:= 	stod((cAliasLif)->EMISSA)
				aDados1[04]	:=	(cAliasLif)->UA_CLIENTE
				aDados1[05]	:=	(cAliasLif)->UA_LOJA
				aDados1[06]	:=	(cAliasLif)->A1_NOME
				aDados1[07]	:=	(cAliasLif)->VALORNET
				aDados1[08]	:= 	IIf((cAliasLif)->VIROUPEDIDO==1	,"SIM","NรO")
				aDados1[09]	:= 	IIf((cAliasLif)->CANCELADO==1		,"SIM","NรO")
				aDados1[10]	:= 	IIf((cAliasLif)->ABERTA==1		,"SIM","NรO")
				aDados1[11]	:= 	(cAliasLif)->OPERADOR
				aDados1[12]	:= 	Posicione("SU7",1,xFilial("SU7")+(cAliasLif)->OPERADOR,"U7_NOME")
				aDados1[13]	:= 	(cAliasLif)->VENDEDOR
				aDados1[14]	:= 	Posicione("SA3",1,xFilial("SA3")+(cAliasLif)->VENDEDOR,"A3_NOME")
				aDados1[15]	:= 	Posicione("SA3",1,xFilial("SA3")+(cAliasLif)->VENDEDOR,"A3_SUPER")
				aDados1[16]	:= 	Posicione("SA3",1,xFilial("SA3")+aDados1[15],"A3_NOME")
				aDados1[17]	:= 	(cAliasLif)->INTERACOES
				aDados1[18]	:= 	IIf((cAliasLif)->SEMINTERACAO==1 .And. (cAliasLif)->ABERTA==1,"NรO","")
				aDados1[19]	:= 	IIf((cAliasLif)->VENCIDA==1		,"SIM","NรO")
				aDados1[20]	:=	IIf((cAliasLif)->AVENCER==1		,"SIM","NรO")

				_cRet:= ' '
				If SUBSTR((cAliasLif)->MOTIVO,6,1) = '1'
					_cRet:='1=SOMENTE CUSTO'
					_n01++
					_nv01+=  (cAliasLif)->VALORNET
				ElseIf SUBSTR((cAliasLif)->MOTIVO,6,1) = '2'
					_cRet:='2=OUTRO'
					_n02++
					_nv02+=  (cAliasLif)->VALORNET
				ElseIf SUBSTR((cAliasLif)->MOTIVO,6,1) = '3'
					_cRet:='3=ITENS INCL. PEDIDO'
					_n03++
					_nv03+=  (cAliasLif)->VALORNET
				ElseIf SUBSTR((cAliasLif)->MOTIVO,6,1) = '4'
					_cRet:='4=COMP NO DISTRI'
					_n04++
					_nv04+=  (cAliasLif)->VALORNET
				ElseIf SUBSTR((cAliasLif)->MOTIVO,6,1) = '5'
					_cRet:='5=PERD CONCORRE'
					_n05++
					_nv05+=  (cAliasLif)->VALORNET
				ElseIf SUBSTR((cAliasLif)->MOTIVO,6,1) = '6'
					_cRet:='6=PERDEU COT'
					_n06++
					_nv06+=  (cAliasLif)->VALORNET
				ElseIf SUBSTR((cAliasLif)->MOTIVO,6,1) = '7'
					_cRet:='7=CANC MASSA'
				ElseIf SUBSTR((cAliasLif)->MOTIVO,6,1) = '8'
					_cRet:='8=COBRAR NOVAMEN'
				ElseIf (cAliasLif)->MOTIVO = 'SUP'
					_cRet:='SUP'
				ElseIf (cAliasLif)->MOTIVO = 'NF.'
					_cRet:='NF.'


				EndIf

				IF empty(_cRet)
					If (cAliasLif)->STATUS = '1'
						_cRet:='1=SOMENTE CUSTO'
						_n01++
						_nv01+=  (cAliasLif)->VALORNET
					ElseIf (cAliasLif)->STATUS = '2'
						_cRet:='2=OUTRO'
						_n02++
						_nv02+=  (cAliasLif)->VALORNET
					ElseIf (cAliasLif)->STATUS = '3'
						_cRet:='3=ITENS INCL. PEDIDO'
						_n03++
						_nv03+=  (cAliasLif)->VALORNET
					ElseIf (cAliasLif)->STATUS = '4'
						_cRet:='4=COMP NO DISTRI'
						_n04++
						_nv04+=  (cAliasLif)->VALORNET
					ElseIf (cAliasLif)->STATUS = '5'
						_cRet:='5=PERD CONCORRE'
						_n05++
						_nv05+=  (cAliasLif)->VALORNET
					ElseIf (cAliasLif)->STATUS = '6'
						_cRet:='6=PERDEU COT'
						_n06++
						_nv06+=  (cAliasLif)->VALORNET
					ElseIf (cAliasLif)->STATUS = '7'
						_cRet:='7=CANC MASSA'
					ElseIf (cAliasLif)->STATUS = '8'
						_cRet:='8=COBRAR NOVAMEN'
					EndIf


				Endif


				aDados1[21]	:= 	_cRet
				aDados1[22]	:= 	(cAliasLif)->OBS
				aDados1[23]	:= 	(cAliasLif)->NUMSC5
				aDados1[24]	:= 	(cAliasLif)->NOTA



			EndIf

			oSection1:PrintLine()
			aFill(aDados1,nil)
			(cAliasLif)->(dbskip())
		End

		oSection1:PrintLine()
		aFill(aDados1,nil)


		If MV_PAR05=="A"
			oSection1:PrintLine()
			aFill(aDados1,nil)
			oSection1:PrintLine()
			aFill(aDados1,nil)

			aDados1[04]	:=	'Totais'
			aDados1[05]	:=	''
			//aDados1[06] := 0

			oSection1:PrintLine()
			aFill(aDados1,nil)
			aDados1[04]	:= '1=SOMENTE CUSTO'
			aDados1[05]	:= cvaltochar(_n01)
			aDados1[06] :=  _nv01

			oSection1:PrintLine()
			aFill(aDados1,nil)
			aDados1[04]	:= '2=OUTRO'
			aDados1[05]	:=  cvaltochar(_n02)
			aDados1[06] := _nv02

			oSection1:PrintLine()
			aFill(aDados1,nil)
			aDados1[04]	:= '3=ITENS INCL. PEDIDO'
			aDados1[05]	:=  cvaltochar(_n03)
			aDados1[06] :=  _nv03

			oSection1:PrintLine()
			aFill(aDados1,nil)
			aDados1[04]	:= '4=COMP NO DISTRI'
			aDados1[05]	:=  cvaltochar(_n04)
			aDados1[06] :=  _nv04

			oSection1:PrintLine()
			aFill(aDados1,nil)
			aDados1[04]	:= '5=PERD CONCORRE'
			aDados1[05]	:=  cvaltochar(_n05)
			aDados1[06] :=  _nv05

			oSection1:PrintLine()
			aFill(aDados1,nil)
			aDados1[04]	:= '6=PERDEU COT'
			aDados1[05]	:=  cvaltochar(_n06)
			aDados1[06] :=  _nv06
			oSection1:PrintLine()
			aFill(aDados1,nil)

		EndIf


		(cAliasLif)->(dbCloseArea())
	EndIf
	oReport:SkipLine()
Return oReport


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  StQuery      บAutor  ณGiovani Zago    บ Data ณ  04/07/15     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relatorio MMG 							                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*-----------------------------*
Static Function StQuery(_ccod)
	*-----------------------------*

	Local cQuery     := ' '

	If MV_PAR05=="S"
		cQuery := " SELECT VENDEDOR, NVL(A3_NOME,' ') NOME, SUM(VALORNET) VALOR, SUM(CONTADOR) ORCAMENTOS,
		cQuery += " SUM(PEDIDO) VLRVP, SUM(CANCEL) VVLCAN, SUM(ABERT) VVLABER, "
		cQuery += " SUM(VIROUPEDIDO) VIROUPED, SUM(CANCELADO) CANCELADOS, SUM(ABERTA) ABERTAS, "
		cQuery += " SUM(INTERACOES) INTERACOES, SUM(SEMINTERACAO) SEMINTERACOES, SUM(VENCIDA) VENCIDAS, "
		cQuery += " SUM(AVENCER) AVENCER "
		cQuery += " FROM ( "
	EndIf
	cQuery += " SELECT UA_FILIAL, UA_NUM, UA_CLIENTE, UA_LOJA, A1_NOME, UA_ZVALLIQ VALORNET, 1 CONTADOR, UA_EMISSAO EMISSA, UA_OPERADO OPERADOR,"
	//Chamado 003863 - Robson Mazzarotto
	cQuery += " (CASE WHEN UA_NUMSC5<>' ' THEN UA_ZVALLIQ ELSE 0 END) PEDIDO, "
	cQuery += " (CASE WHEN UA_XBLOQ='3'   THEN UA_ZVALLIQ ELSE 0 END) CANCEL, "
	cQuery += " (CASE WHEN UA_XBLOQ IN ('1','2') AND UA_NUMSC5=' ' THEN UA_ZVALLIQ ELSE 0 END) ABERT, "

	cQuery += " (CASE WHEN UA_NUMSC5<>' ' THEN 1 ELSE 0 END) VIROUPEDIDO, "
	cQuery += " (CASE WHEN UA_XBLOQ='3' THEN 1 ELSE 0 END) CANCELADO, "
	cQuery += " (CASE WHEN UA_XBLOQ IN ('1','2') AND UA_NUMSC5=' ' THEN 1 ELSE 0 END) ABERTA, "
	//cQuery += " (CASE WHEN UA_VEND<>' ' AND UA_VEND2=' ' THEN UA_VEND WHEN UA_VEND<>' ' AND UA_VEND2<>' ' THEN UA_VEND2 END) VENDEDOR, "
	//cQuery += " UA_VEND2 VENDEDOR, "
	cQuery += " UA_VEND VENDEDOR, " //Alterado para gerar sempre o Vendedor, Conforme solicitado pela Janaina - Everson Santana 02.04.18
	cQuery += " (SELECT COUNT(*) FROM "+RetSqlName("ZZY")+" ZZY WHERE ZZY.D_E_L_E_T_=' ' AND ZZY_FILIAL=UA.UA_FILIAL AND ZZY_NUM=UA.UA_NUM) INTERACOES, "
	cQuery += " (CASE WHEN (UA.UA_XBLOQ='3' OR UA.UA_NUMSC5<>' ') THEN 0 WHEN (SELECT COUNT(*) FROM "+RetSqlName("ZZY")+" ZZY WHERE ZZY.D_E_L_E_T_=' ' AND ZZY_FILIAL=UA.UA_FILIAL AND ZZY_NUM=UA.UA_NUM AND UA_XBLOQ IN ('1','2') AND UA_NUMSC5=' ')=0 THEN 1 ELSE 0 END) SEMINTERACAO, "
	cQuery += " (CASE WHEN (SELECT MAX(ZZY_RETORN) FROM "+RetSqlName("ZZY")+" ZZY WHERE ZZY.D_E_L_E_T_=' ' AND ZZY_FILIAL=UA.UA_FILIAL AND ZZY_NUM=UA.UA_NUM AND ZZY_MOTIVO='8')<'"+DTOS(Date())+"' THEN 1 ELSE 0 END) VENCIDA, "
	/*
	cQuery += " (CASE WHEN NVL((SELECT NVL(ZZY_MOTIVO,' ') FROM "+RetSqlName("ZZY")+" ZZY WHERE ZZY.D_E_L_E_T_=' ' AND ZZY_FILIAL=UA.UA_FILIAL AND ZZY_NUM=UA.UA_NUM AND ZZY.R_E_C_N_O_ =
	cQuery += " (SELECT MAX(R_E_C_N_O_) FROM ZZY010 TZY WHERE TZY.D_E_L_E_T_=' ' AND TZY.ZZY_FILIAL=UA.UA_FILIAL AND TZY.ZZY_NUM=UA.UA_NUM)
	cQuery += "  ),' ') <> ' ' THEN (SELECT NVL(ZZY_MOTIVO,' ') FROM "+RetSqlName("ZZY")+" ZZY WHERE ZZY.D_E_L_E_T_=' ' AND ZZY_FILIAL=UA.UA_FILIAL AND ZZY_NUM=UA.UA_NUM AND ZZY.R_E_C_N_O_ =
	cQuery += " (SELECT MAX(R_E_C_N_O_) FROM ZZY010 TZY WHERE TZY.D_E_L_E_T_=' ' AND TZY.ZZY_FILIAL=UA.UA_FILIAL AND TZY.ZZY_NUM=UA.UA_NUM)
	cQuery += " ) ELSE ' ' END) MOTIVO, "
	*/

	cQuery += " UA_XCODMCA MOTIVO, UA_STATUS STATUS, UA_NUMSC5 NUMSC5, UA_DOC NOTA," // Solicitado pela Janaina Paixใo para buscar os motivos pela tabela SUA.

	cQuery += " (CASE WHEN NVL((SELECT NVL(ZZY_OBS,' ') FROM "+RetSqlName("ZZY")+" ZZY WHERE ZZY.D_E_L_E_T_=' ' AND ZZY_FILIAL=UA.UA_FILIAL AND ZZY_NUM=UA.UA_NUM AND ZZY.R_E_C_N_O_ =
	cQuery += " (SELECT MAX(R_E_C_N_O_) FROM UDBP12.ZZY010 TZY WHERE TZY.D_E_L_E_T_=' ' AND TZY.ZZY_FILIAL=UA.UA_FILIAL AND TZY.ZZY_NUM=UA.UA_NUM)  "             // Valdemir Rabelo 02/05/2022 - Ticket: 20220405007368
	cQuery += "  ),' ') <> ' ' THEN (SELECT NVL(ZZY_OBS,' ') FROM "+RetSqlName("ZZY")+" ZZY WHERE ZZY.D_E_L_E_T_=' ' AND ZZY_FILIAL=UA.UA_FILIAL AND ZZY_NUM=UA.UA_NUM AND ZZY.R_E_C_N_O_ =
	cQuery += " (SELECT MAX(R_E_C_N_O_) FROM UDBP12.ZZY010 TZY WHERE TZY.D_E_L_E_T_=' ' AND TZY.ZZY_FILIAL=UA.UA_FILIAL AND TZY.ZZY_NUM=UA.UA_NUM)  "             // Valdemir Rabelo 02/05/2022 - Ticket: 20220405007368                    
	cQuery += " ) ELSE ' ' END) OBS, "

	cQuery += " (CASE WHEN (SELECT MAX(ZZY_RETORN) FROM "+RetSqlName("ZZY")+" ZZY WHERE ZZY.D_E_L_E_T_=' ' AND ZZY_FILIAL=UA.UA_FILIAL AND ZZY_NUM=UA.UA_NUM AND ZZY_MOTIVO='8')>='"+DTOS(Date())+"' THEN 1 ELSE 0 END) AVENCER "
	cQuery += " FROM "+RetSqlName("SUA")+" UA "
	cQuery += " LEFT JOIN "+RetSqlName("SA1")+" A1 "
	cQuery += " ON A1.A1_COD=UA.UA_CLIENTE AND A1.A1_LOJA=UA.UA_LOJA "

	cQuery += " INNER JOIN(SELECT * FROM UDBP12.SA3010 ) SA3 "        // Valdemir Rabelo 02/05/2022 - Ticket: 20220405007368
	cQuery += " ON SA3.D_E_L_E_T_ = ' '
	//cQuery += " AND (CASE WHEN UA_VEND<>' ' AND UA_VEND2=' ' THEN UA_VEND WHEN UA_VEND<>' ' AND UA_VEND2<>' ' THEN UA_VEND2 END)  "
	//cQuery += " AND UA_VEND2 "
	cQuery += " AND UA_VEND " //Alterado para gerar sempre o Vendedor, Conforme solicitado pela Janaina - Everson Santana 02.04.18
	cQuery += " = A3_COD AND A3_SUPER
	cQuery += " BETWEEN '"+MV_PAR06+"' AND '"+MV_PAR07+"' "

	cQuery += " WHERE UA.D_E_L_E_T_=' ' AND A1.D_E_L_E_T_=' ' AND UA_EMISSAO BETWEEN '"+DTOS(MV_PAR03)+"' AND '"+DTOS(MV_PAR04)+"' "
	cQuery += " AND (CASE WHEN UA_VEND <> ' ' AND UA_VEND2 = ' ' THEN UA_VEND WHEN UA_VEND <> ' ' AND UA_VEND2 <> ' ' THEN UA_VEND END)  "//Alterado para gerar sempre o Vendedor, Conforme solicitado pela Janaina - Everson Santana 02.04.18
	cQuery += " BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "

	cQuery += " ORDER BY VENDEDOR, UA_FILIAL, UA_NUM "
	If MV_PAR05=="S"
		cQuery += " ) AAA "
		cQuery += " LEFT JOIN "+RetSqlName("SA3")+" A3 "
		cQuery += " ON A3.A3_COD=VENDEDOR AND A3.D_E_L_E_T_=' ' "
		cQuery += " GROUP BY VENDEDOR, A3_NOME "
	EndIf

	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

Return()
