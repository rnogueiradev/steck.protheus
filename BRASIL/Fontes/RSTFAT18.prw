#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  RSTFAT18     ºAutor  ³Giovani Zago    º Data ³  04/11/13     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Relatorio Metas					                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Caso seja necessario alterar as regras deste relatorio	  º±±
±±			   Por favo alterar tambem no STGPE009.prw					  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RSTFAT18()

	Local   oReport
	Local _cSupe    		:= GetMv("ST_SUPE18",,"000000/000645/")
	Private cPerg 			:= ""
	Private cTime           := Time()
	Private cHora           := SUBSTR(cTime, 1, 2)
	Private cMinutos    	:= SUBSTR(cTime, 4, 2)
	Private cSegundos   	:= SUBSTR(cTime, 7, 2)
	Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos
	Private lXlsHeader      := .f.
	Private lXmlEndRow      := .f.
	Private cPergTit 		:= "RFAT18"+cAliasLif
	Private lret            := .T.
	Private _cVenTp			:= ""
	Private _aVend          := {}
	Private _aVend2         := {}
	Private _lGeren         := .F.
	Private _lSuper         := .F.
	Private aCombo          := {}
	Private aRet            := {}
	Private aParamBox 		:= {}
	aCombo := {"Analitico","Sintetico"}

	AADD(aParamBox,{2,"Selecione o Tipo",,aCombo,50,"",.T.})

	If ParamBox(aParamBox,"Parâmetros...",@aRet)

		If aRet[1] == "Analitico"
			U_RSTFAT69()
			RETURN()
		EndIf

		DbSelectArea('SA3')
		SA3->(DbSetOrder(7))
		If SA3->(dbSeek(xFilial('SA3')+RetCodUsr())) .And. !(RetCodUsr() $ _cSupe)

			If SA3->A3_TPVEND == 'I'
				If Empty(Alltrim(SA3->A3_SUPER)) .Or. Empty(Alltrim(SA3->A3_GEREN))   //so entra se for gerente ou supervisor vera qualquer usuario
					cPerg 			:= "RFA18G"

				Else  // Interno so vera apenas seu codigo e os clientes amarrados a ele

					If SA3->A3_CODUSR == __cUserId

						cPerg 			:= "RFA18I"
						_cVenTp         := SA3->A3_COD

						SA3->(dbSetFilter({|| SA3->A3_COD == _cVenTp},"SA3->A3_COD == _cVenTp"))

					Else

						MSGSTOP( "Este não é o seu codigo de vendedor!!!", "Atenção" )

					EndIf

				EndIf
			Else // extreno vera apenas o seu codigo e os clientes amarrados a ele

				cPerg 			:= "RFA18I"
				_cVenTp         := SA3->A3_COD
				SA3->(dbSetFilter({|| SA3->A3_COD == _cVenTp},"SA3->A3_COD == _cVenTp"))

			EndIf
		ElseIf  RetCodUsr() $ _cSupe
			cPerg 			:= "RFA18G"
		Else
			msgInfo(' Usuario Não cadastrado como vendedor !!!!')
			lret:= .f.
			//cPerg 			:= "RFA18G"
		EndIf

		PutSx1( cPerg, "01","Relatorio:"		,"","","mv_ch1","C",1,0,0,"C","","","","","mv_par01","2-SINTETICO","","","","2-SINTETICO","","","","","","","","","","","")
		PutSx1( cPerg, "02","Vendedor:"			,"","","mv_ch2","C",6,0,0,"G","(existcpo('SA3',mv_par02)  .Or. Empty(mv_par02))","SA3","","","mv_par02","","","","","","","","","","","","","","","","")
		PutSx1( cPerg, "03","Mês de:" 			,"","","mv_ch3","C",2,0,0,"G","",""	,"","","mv_par03","","","","","","","","","","","","","","","","")
		PutSx1( cPerg, "04","Ano de:"   		,"","","mv_ch4","C",4,0,0,"G","",""	,"","","mv_par04","","","","","","","","","","","","","","","","")
		PutSx1( cPerg, "05","Mês Até:"      	,"","","mv_ch5","C",2,0,0,"G","",""	,"","","mv_par05","","","","","","","","","","","","","","","","")
		PutSx1( cPerg, "06","Ano Até:"   		,"","","mv_ch6","C",4,0,0,"G","",""	,"","","mv_par06","","","","","","","","","","","","","","","","")
		PutSx1( cPerg, "07","Data de:"				,"","","mv_ch7","D",8,0,0,"G","","","","","mv_par07","","","","","","","","","","","","","","","","")
		PutSx1( cPerg, "08","Data Até"				,"","","mv_ch8","D",8,0,0,"G","","","","","mv_par08","","","","","","","","","","","","","","","","")

		cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos

		If 	lret

			oReport		:= ReportDef()
			oReport:PrintDialog()
		EndIf
		SA3->(DbClearFilter())
	EndIf
Return

Static Function ReportDef()
	Local oReport
	Local oSection1
	//Local oSection2
	Local _cSec2 := 'oSection'


	oReport := TReport():New(cPergTit,"Relatorio de Metas",cPerg,{|oReport| ReportPrint(oReport)},"Este relatorio ira imprimir um relatório de Metas.")



	Pergunte(cPerg,.F.)
	oSection1 := TRSection():New(oReport,"Metas - Geral",{"SC5"})

	TRCell():New(oSection1,"Grupo"			,,"Grupo"		,,4,.F.,)
	TRCell():New(oSection1,"Descricao" 		,,"Descricao"	,,50,.F.,)
	TRCell():New(oSection1,"Objetivo"   	,,"Objetivo"   	,"@E 999,999,999.99",15)
	TRCell():New(oSection1,"Qtd_Objet"   	,,"Qtd_Objet"   ,"@E 999,999,999.99",15)
	TRCell():New(oSection1,"Captacao"   	,,"Captacao"   	,"@E 999,999,999.99",15)
	TRCell():New(oSection1,"Qtd_Capt"   	,,"Qtd_Capt"   	,"@E 999,999,999.99",15)
	TRCell():New(oSection1,"%Captacao"   	,,"%Captacao"   ,"@E 999,999,999.99",15)
	TRCell():New(oSection1,"Faturado"     	,,"Faturado"    ,"@E 999,999,999.99",15)
	TRCell():New(oSection1,"Qtd_Fatu"     	,,"Qtd_Fatu"    ,"@E 999,999,999.99",15)
	TRCell():New(oSection1,"%Faturado"   	,,"%Faturado"   ,"@E 999,999,999.99",15)


	Return oReport


Return oReport

Static Function ReportPrint(oReport)

	Local oSection	  := oReport:Section(1)
	Local oSection1	  := oReport:Section(1)
	//Local oSection2	  := oReport:Section(2)
	Local nX		  := 0
	Local cQuery 	  := ""
	Local cAlias 	  := "QRYTEMP0"
	Local aDados[2]
	Local aDados1[10]
	Local aDados2[10]
	Local n01:=n02:=n03:=n04:=n05:=n06:=0
	Local nt01:=nt02:=nt03:=nt04:=nt05:=nt06:=0
	Local _cSec2  := ' '
	Local l:= 0
	If Mv_Par01 = 1   .And. Mv_Par02 = 'G00001'
		TRCell():New(oSection1,"Area"			,,"Area"		,,6,.F.,)
		TRCell():New(oSection1,"Nome" 		,,"Nome"	,,30,.F.,)
	EndIf

	oSection1:Cell("Grupo")       	:SetBlock( { || aDados1[01] } )
	oSection1:Cell("Descricao")		:SetBlock( { || aDados1[02] } )
	oSection1:Cell("Objetivo")		:SetBlock( { || aDados1[03] } )
	oSection1:Cell("Qtd_Objet"  )	:SetBlock( { || aDados1[04] } )
	oSection1:Cell("Captacao")		:SetBlock( { || aDados1[05] } )
	oSection1:Cell("Qtd_Capt")    	:SetBlock( { || aDados1[06] } )
	oSection1:Cell("%Captacao")    	:SetBlock( { || aDados1[07] } )
	oSection1:Cell("Faturado")		:SetBlock( { || aDados1[08] } )
	oSection1:Cell("Qtd_Fatu")    	:SetBlock( { || aDados1[09] } )
	oSection1:Cell("%Faturado")    	:SetBlock( { || aDados1[10] } )

	If Mv_Par01 = 1   .And. Mv_Par02 = 'G00001'
		oSection1:Cell("Area")    	:SetBlock( { || aDados1[11] } )
		oSection1:Cell("Nome")    	:SetBlock( { || aDados1[12] } )
	EndIf


	oReport:SetMeter(0)
	aFill(aDados,nil)
	aFill(aDados1,nil)




	//Processa({|| StQuery( ) },"Compondo Relatorio")

	If   Empty(Alltrim(_cVenTp))
		_aVend          := {}
		DbSelectArea('SA3')
		SA3->(DbSetOrder(1))
		If SA3->(dbSeek(xFilial('SA3')+Mv_Par02))


			If SA3->A3_TPVEND == 'I'
				If Empty(Alltrim(SA3->A3_SUPER)) .Or. Empty(Alltrim(SA3->A3_GEREN))   //so entra se for gerente ou supervisor vera qualquer usuario
					If Empty(Alltrim(SA3->A3_SUPER)) .And. !(Empty(Alltrim(SA3->A3_GEREN)))  //supervisor
						VendSTSuper(SA3->A3_COD)
						_lSuper    := .T.
					Else  // gerente
						VendSTGeren(SA3->A3_COD)
						_lGeren    := .T.
					EndIf

				Else  // Interno so vera apenas seu codigo e os clientes amarrados a ele
					_cVenTp   := SA3->A3_COD
				EndIf
			Else // extreno vera apenas o seu codigo e os clientes amarrados a ele
				_cVenTp       := SA3->A3_COD
			EndIf
		EndIf
	EndIf

	If __cuserid = '000000'
		VendSTGeren('G00001')
		_lGeren    := .T.

	EndIf


	If (_lGeren  .or. _lSuper) //gerencia/supervisao

		If len(_aVend) > 0
			For l:=1 to  len(_aVend)

				Processa({|| StVenQuery(_aVend[l,1]) },"Compondo Relatorio")
				oSection1:Init()
				oReport:SetMeter(RecCount())



				dbSelectArea(cAliasLif)
				(cAliasLif)->(dbgotop())
				If  Select(cAliasLif) > 0

					While 	(cAliasLif)->(!Eof())



						aFill(aDados1,nil)
						n01+=    (cAliasLif)->OBJETIVO
						n02+=	(cAliasLif)->QTD_OBJETIVO
						n03+=	(cAliasLif)->CAPTACAO
						n04+=	(cAliasLif)->QTD_CAPTACAO
						n05+=    (cAliasLif)->FATURAMENTO - (cAliasLif)->QTD_TOTAL
						n06+=    (cAliasLif)->QTD_FATURAMENTO - (cAliasLif)->QTD_DEV

						nt01+=    (cAliasLif)->OBJETIVO
						nt02+=	(cAliasLif)->QTD_OBJETIVO
						nt03+=	(cAliasLif)->CAPTACAO
						nt04+=	(cAliasLif)->QTD_CAPTACAO
						nt05+=    (cAliasLif)->FATURAMENTO - (cAliasLif)->QTD_TOTAL
						nt06+=    (cAliasLif)->QTD_FATURAMENTO - (cAliasLif)->QTD_DEV





						(cAliasLif)->(dbskip())

					End

					If Mv_Par01 = 1   .And. (	n01+n02+n03+n04+n05+n06 ) > 0
						//**************************** TOTAIS  ****************************************
						aDados1[01]	:=  _aVend[l,1]
						aDados1[02]	:=  _aVend[l,2]
						aDados1[03]	:=  n01
						aDados1[04]	:=  n02
						aDados1[05]	:=	n03
						aDados1[06]	:=  n04
						aDados1[07]	:=	(n03*100)/n01
						aDados1[08]	:=	n05
						aDados1[09]	:=	n06
						aDados1[10]	:=	(n05*100)/n01
						If Mv_Par01 = 1   .And. Mv_Par02 = 'G00001'
							aDados1[11]	:=	Alltrim(Posicione("SA3",1,xFilial("SA3")+_aVend[l,1]  ,"A3_SUPER"))
							aDados1[12]	:=	Alltrim(Posicione("SA3",1,xFilial("SA3")+aDados1[11]  ,"A3_NOME"))
						EndIf
						oSection1:PrintLine()
						aFill(aDados1,nil)

						//**************************************************************************

						n01:=n02:=n03:=n04:=n05:=n06:=0

						//	oReport:SkipLine()

						//	oSection1:Finish()
						//	oReport:IncMeter()
					Elseif Mv_Par01 = 2
						aFill(aDados1,nil)
						//**************************** TOTAIS  ****************************************
						aDados1[01]	:=  _aVend[l,1]
						aDados1[02]	:=  _aVend[l,2]
						aDados1[03]	:=  n01
						aDados1[04]	:=  n02
						aDados1[05]	:=	n03
						aDados1[06]	:=  n04
						aDados1[07]	:=	(n03*100)/n01
						aDados1[08]	:=	n05
						aDados1[09]	:=	n06
						aDados1[10]	:=	(n05*100)/n01

						oSection1:PrintLine()
						aFill(aDados1,nil)

						//**************************************************************************
						n01:=n02:=n03:=n04:=n05:=n06:=0
						//	oReport:SkipLine()

						//	oSection1:Finish()
						//	oReport:IncMeter()
					EndIf
				EndIf



			Next l
			iF Mv_Par01 = 2
				aFill(aDados1,nil)
				//**************************** TOTAIS  ****************************************
				aDados1[01]	:=  ''
				aDados1[02]	:=  'TOTAL'
				aDados1[03]	:=  nT01
				aDados1[04]	:=  nT02
				aDados1[05]	:=	nT03
				aDados1[06]	:=  nT04
				aDados1[07]	:=	(nT03*100)/nT01
				aDados1[08]	:=	nT05
				aDados1[09]	:=	nT06
				aDados1[10]	:=	(nT05*100)/nT01

				oSection1:PrintLine()
				aFill(aDados1,nil)

				//**************************************************************************
				n01:=n02:=n03:=n04:=n05:=n06:=0
				//	oReport:SkipLine()

				//	oSection1:Finish()
				//	oReport:IncMeter()
			EndIf


		EndIf
	Else
		Processa({|| StVenQuery(_cVenTp) },"Compondo Relatorio")
		oReport:SetMeter(RecCount())



		dbSelectArea(cAliasLif)
		(cAliasLif)->(dbgotop())
		If  Select(cAliasLif) > 0

			While 	(cAliasLif)->(!Eof())
				oSection1:Init()
				If Mv_Par01 = 1
					If      ((cAliasLif)->CAPTACAO+(cAliasLif)->FATURAMENTO+(cAliasLif)->OBJETIVO)  > 0
						aDados1[01]	:= 	(cAliasLif)->GRUPO
						aDados1[02]	:=  (cAliasLif)->DESCRICAO
						aDados1[03]	:=	(cAliasLif)->OBJETIVO
						aDados1[04]	:=	(cAliasLif)->QTD_OBJETIVO
						aDados1[05]	:=	(cAliasLif)->CAPTACAO
						aDados1[06]	:=	(cAliasLif)->QTD_CAPTACAO
						aDados1[07]	:=	((cAliasLif)->CAPTACAO*100)/(cAliasLif)->OBJETIVO
						aDados1[08]	:=	(cAliasLif)->FATURAMENTO- (cAliasLif)->QTD_TOTAL
						aDados1[09]	:=	(cAliasLif)->QTD_FATURAMENTO - (cAliasLif)->QTD_DEV
						aDados1[10]	:=	((cAliasLif)->FATURAMENTO*100)/(cAliasLif)->OBJETIVO

						oSection1:PrintLine()
					EndIf
				EndIf
				aFill(aDados1,nil)
				n01+=    (cAliasLif)->OBJETIVO
				n02+=	(cAliasLif)->QTD_OBJETIVO
				n03+=	(cAliasLif)->CAPTACAO
				n04+=	(cAliasLif)->QTD_CAPTACAO
				n05+=    (cAliasLif)->FATURAMENTO - (cAliasLif)->QTD_TOTAL
				n06+=    (cAliasLif)->QTD_FATURAMENTO- (cAliasLif)->QTD_DEV




				(cAliasLif)->(dbskip())

			End

			//**************************** TOTAIS  ****************************************
			aDados1[01]	:= ''
			aDados1[02]	:=  'TOTAL:
			aDados1[03]	:=  n01
			aDados1[04]	:=  n02
			aDados1[05]	:=	n03
			aDados1[06]	:=  n04
			aDados1[07]	:=	(n03*100)/n01
			aDados1[08]	:=	n05
			aDados1[09]	:=	n06
			aDados1[10]	:=	(n05*100)/n01

			oSection1:PrintLine()
			aFill(aDados1,nil)
			//**************************************************************************


		EndIf


		n01:=n02:=n03:=n04:=n05:=n06:=0
		oReport:SkipLine()

		oSection1:Finish()
		oReport:IncMeter()
		 
	EndIf

Return oReport






Static Function VendSTGeren(_cVenGere)
	Local cAliasSuper:= 'SUP01'
	Local cQuery     := ' '

	cQuery := "  SELECT A3_COD,A3_NOME
	cQuery += "  FROM  "+RetSqlName("SA3")+"  SA3 "
	cQuery += "  WHERE D_E_L_E_T_ = ' '
	cQuery += "  AND A3_GEREN = '"+_cVenGere+"'
	cQuery += "  AND A3_FILIAL = '"+xFilial("SA3")+"'"
	cQuery += "  AND A3_SUPER <> ' '
	//cQuery += "  AND SA3.A3_XBLQ    <> '1'

	cQuery := ChangeQuery(cQuery)

	If Select(cAliasSuper) > 0
		(cAliasSuper)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasSuper)



	dbSelectArea(cAliasSuper)
	(cAliasSuper)->(dbgotop())
	If  Select(cAliasSuper) > 0

		While 	(cAliasSuper)->(!Eof())

			aadd(_aVend,{(cAliasSuper)->A3_COD,(cAliasSuper)->A3_NOME}  )
			//	aadd(_aVend,{(cAliasSuper)->A3_NOME}  )
			(cAliasSuper)->(dbskip())

		End
	EndIf



Return()




Static Function VendSTSuper(_cVenGere)



	Local cAliasSuper:= 'SUP01'
	Local cQuery     := ' '

	cQuery := "  SELECT A3_COD,A3_NOME
	cQuery += "  FROM  "+RetSqlName("SA3")+"  SA3 "
	cQuery += "  WHERE D_E_L_E_T_ = ' '
	cQuery += "  AND A3_SUPER = '"+_cVenGere+"'
	cQuery += "  AND A3_FILIAL = '"+xFilial("SA3")+"'"
	//cQuery += "  AND SA3.A3_XBLQ    <> '1'


	cQuery := ChangeQuery(cQuery)

	If Select(cAliasSuper) > 0
		(cAliasSuper)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasSuper)



	dbSelectArea(cAliasSuper)
	(cAliasSuper)->(dbgotop())
	If  Select(cAliasSuper) > 0

		While 	(cAliasSuper)->(!Eof())

			aadd(_aVend,{(cAliasSuper)->A3_COD,(cAliasSuper)->A3_NOME}  )
			(cAliasSuper)->(dbskip())

		End
	EndIf

Return()


Static Function StVenQuery(_cxven)

	Local cQuery     := ' '
	If Mv_Par01 = 1
		cQuery += "  SELECT
		cQuery += '  SBM.BM_GRUPO "GRUPO",
		cQuery += '  SBM.BM_DESC  "DESCRICAO",

		cQuery += "  NVL((SELECT SUM(ZZD.ZZD_VALOR)
		cQuery += "  FROM "+RetSqlName("ZZD")+" ZZD "
		cQuery += "  WHERE ZZD.D_E_L_E_T_ = ' '
		cQuery += "  AND ZZD.ZZD_MES      BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR05+"'
		cQuery += "  AND ZZD.ZZD_ANO      BETWEEN '"+MV_PAR04+"' AND '"+MV_PAR06+"'
		cQuery += "  AND ZZD.ZZD_FILIAL   =  '"+xFilial("ZZD")+"'"
		cQuery += "  AND ZZD.ZZD_GRUPO    = SBM.BM_GRUPO
		cQuery += "  AND ZZD.ZZD_VEND   = '"+_cxven+"'
		cQuery += '   ),0) "OBJETIVO",

		cQuery += "  NVL((SELECT SUM(ZZD.ZZD_QTD)
		cQuery += "  FROM "+RetSqlName("ZZD")+" ZZD "
		cQuery += "  WHERE ZZD.D_E_L_E_T_ = ' '
		cQuery += "  AND ZZD.ZZD_MES      BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR05+"'
		cQuery += "  AND ZZD.ZZD_ANO      BETWEEN '"+MV_PAR04+"' AND '"+MV_PAR06+"'
		cQuery += "  AND ZZD.ZZD_FILIAL   = '"+xFilial("ZZD")+"'"
		cQuery += "  AND ZZD.ZZD_GRUPO    = SBM.BM_GRUPO
		cQuery += "  AND ZZD.ZZD_VEND   = '"+_cxven+"'
		cQuery += "   ),0)
		cQuery += '  "QTD_OBJETIVO" ,

		cQuery += "  ROUND(NVL((
		cQuery += "  SELECT
		cQuery += "  SUM(CASE WHEN C6_BLQ = 'R' THEN (C6_ZVALLIQ/C6_QTDVEN)*C6_QTDENT ELSE C6_ZVALLIQ END)
		cQuery += '  "VALOR"
		cQuery += "  FROM "+RetSqlName("SC6")+" SC6 "
		cQuery += "  INNER JOIN ( SELECT * FROM "+RetSqlName("SB1")+" )SB1 "
		cQuery += "  ON SB1.D_E_L_E_T_   = ' '
		cQuery += "  AND SB1.B1_COD    = SC6.C6_PRODUTO
		cQuery += "  AND SB1.B1_FILIAL = '"+xFilial("SB1")+"'"
		cQuery += "  INNER JOIN ( SELECT * FROM "+RetSqlName("SC5")+" )SC5 "
		cQuery += "  ON  SC5.D_E_L_E_T_   = ' '
		cQuery += "  AND SC5.C5_NUM      = SC6.C6_NUM
		cQuery += "  AND SC5.C5_FILIAL   = SC6.C6_FILIAL
		cQuery += "  AND SUBSTR(SC5.C5_EMISSAO,1,6) BETWEEN '"+MV_PAR04+MV_PAR03+"' AND '"+MV_PAR06+MV_PAR05+"'
		If !(Empty(Alltrim(DTOS(MV_PAR07)))) .And. !(Empty(Alltrim(DTOS(MV_PAR08))))
			cQuery += "  AND SC5.C5_EMISSAO BETWEEN '"+DTOS(MV_PAR07)+"' AND '"+DTOS(MV_PAR08)+"' "
		EndIf
		cQuery += "  INNER JOIN(SELECT * FROM "+RetSqlName("SA1")+" )SA1 "
		cQuery += "  ON SA1.D_E_L_E_T_   = ' '
		cQuery += "  AND SA1.A1_COD = SC5.C5_CLIENTE
		cQuery += "  AND SA1.A1_LOJA = SC5.C5_LOJACLI
		cQuery += "  AND SA1.A1_FILIAL = '"+xFilial("SA1")+"'"
		cQuery += "  LEFT JOIN (SELECT * FROM "+RetSqlName("PC1")+" )PC1 "
		cQuery += "  ON C6_NUM = PC1.PC1_PEDREP
		cQuery += "  AND PC1.D_E_L_E_T_ = ' '
		cQuery += "  INNER JOIN (SELECT * FROM "+RetSqlName("SF4")+" )SF4 "
		cQuery += "  ON SC6.C6_TES = SF4.F4_CODIGO
		cQuery += "  AND SF4.D_E_L_E_T_ = ' '
		cQuery += "  AND SF4.F4_DUPLIC = 'S'
		cQuery += "  WHERE SC6.D_E_L_E_T_   = ' '
		cQuery += "  AND SC6.C6_FILIAL = '"+xFilial("SC6")+"'"
		cQuery += "  AND SC5.C5_TIPO = 'N'
		cQuery += "  AND SA1.A1_GRPVEN <> 'ST'
		cQuery += "  AND SA1.A1_EST    <> 'EX'
		cQuery += "  AND SBM.BM_XAGRUP <> ' '
		cQuery += "  AND PC1.PC1_PEDREP IS NULL
		cQuery += "  AND SB1.B1_GRUPO  = SBM.BM_GRUPO
		cQuery += "  AND SC5.C5_VEND1 = '"+_cxven+"'
		cQuery += "  ),0),2)
		cQuery += " + "
		cQuery += "  ROUND(NVL((
		cQuery += "  SELECT
		cQuery += "  SUM(CASE WHEN C6_BLQ = 'R' THEN (C6_ZVALLIQ/C6_QTDVEN)*C6_QTDENT ELSE C6_ZVALLIQ END)
		cQuery += '  "VALOR"
		cQuery += "  FROM UDBP12.SC6030 SC6 "
		cQuery += "  INNER JOIN ( SELECT * FROM  UDBP12.SB1030 )SB1 "
		cQuery += "  ON SB1.D_E_L_E_T_   = ' '
		cQuery += "  AND SB1.B1_COD    = SC6.C6_PRODUTO
		cQuery += "  AND SB1.B1_FILIAL = '"+xFilial("SB1")+"'"
		cQuery += "  INNER JOIN ( SELECT * FROM UDBP12.SC5030 )SC5 "
		cQuery += "  ON  SC5.D_E_L_E_T_   = ' '
		cQuery += "  AND SC5.C5_NUM      = SC6.C6_NUM
		cQuery += "  AND SC5.C5_FILIAL   = SC6.C6_FILIAL
		cQuery += "  AND SUBSTR(SC5.C5_EMISSAO,1,6) BETWEEN '"+MV_PAR04+MV_PAR03+"' AND '"+MV_PAR06+MV_PAR05+"'
		If !(Empty(Alltrim(DTOS(MV_PAR07)))) .And. !(Empty(Alltrim(DTOS(MV_PAR08))))
			cQuery += "  AND SC5.C5_EMISSAO BETWEEN '"+DTOS(MV_PAR07)+"' AND '"+DTOS(MV_PAR08)+"' "
		EndIf
		cQuery += "  INNER JOIN(SELECT * FROM UDBP12.SA1030 )SA1 "
		cQuery += "  ON SA1.D_E_L_E_T_   = ' '
		cQuery += "  AND SA1.A1_COD = SC5.C5_CLIENTE
		cQuery += "  AND SA1.A1_LOJA = SC5.C5_LOJACLI
		cQuery += "  AND SA1.A1_FILIAL = '"+xFilial("SA1")+"'"
		cQuery += "  LEFT JOIN (SELECT * FROM UDBP12.PC1030 )PC1 "
		cQuery += "  ON C6_NUM = PC1.PC1_PEDREP
		cQuery += "  AND PC1.D_E_L_E_T_ = ' '
		cQuery += "  INNER JOIN (SELECT * FROM UDBP12.SF4030 )SF4 "
		cQuery += "  ON SC6.C6_TES = SF4.F4_CODIGO
		cQuery += "  AND SF4.D_E_L_E_T_ = ' '
		cQuery += "  AND SF4.F4_DUPLIC = 'S'
		cQuery += "  WHERE SC6.D_E_L_E_T_   = ' '
		cQuery += "  AND SC6.C6_FILIAL = '01'"
		cQuery += "  AND SC5.C5_TIPO = 'N'
		cQuery += "  AND SA1.A1_GRPVEN <> 'ST'
		cQuery += "  AND SA1.A1_EST    <> 'EX'
		cQuery += "  AND SBM.BM_XAGRUP <> ' '
		cQuery += "  AND PC1.PC1_PEDREP IS NULL
		cQuery += "  AND SB1.B1_GRUPO  = SBM.BM_GRUPO
		cQuery += "  AND SC5.C5_VEND1 = '"+_cxven+"'
		cQuery += "  ),0),2)
		cQuery += '   "CAPTACAO" ,

		cQuery += "  NVL((
		cQuery += "  SELECT
		cQuery += "  SUM(CASE WHEN C6_BLQ = 'R' THEN  C6_QTDENT ELSE C6_QTDVEN END)
		cQuery += '   "QTD"
		cQuery += "  FROM "+RetSqlName("SC6")+" SC6 "
		cQuery += "  INNER JOIN ( SELECT * FROM "+RetSqlName("SB1")+" )SB1 "
		cQuery += "  ON SB1.D_E_L_E_T_   = ' '
		cQuery += "  AND SB1.B1_COD    = SC6.C6_PRODUTO
		cQuery += "  AND SB1.B1_FILIAL = '"+xFilial("SB1")+"'"
		cQuery += "  INNER JOIN ( SELECT * FROM "+RetSqlName("SC5")+" )SC5 "
		cQuery += "  ON  SC5.D_E_L_E_T_   = ' '
		cQuery += "  AND SC5.C5_NUM      = SC6.C6_NUM
		cQuery += "  AND SC5.C5_FILIAL   = SC6.C6_FILIAL
		cQuery += "  AND SUBSTR(SC5.C5_EMISSAO,1,6)  BETWEEN '"+MV_PAR04+MV_PAR03+"' AND '"+MV_PAR06+MV_PAR05+"'
		If !(Empty(Alltrim(DTOS(MV_PAR07)))) .And. !(Empty(Alltrim(DTOS(MV_PAR08))))
			cQuery += "  AND SC5.C5_EMISSAO BETWEEN '"+DTOS(MV_PAR07)+"' AND '"+DTOS(MV_PAR08)+"' "
		EndIf
		cQuery += "  INNER JOIN(SELECT * FROM "+RetSqlName("SA1")+" )SA1 "
		cQuery += "  ON SA1.D_E_L_E_T_   = ' '
		cQuery += "  AND SA1.A1_COD = SC5.C5_CLIENTE
		cQuery += "  AND SA1.A1_LOJA = SC5.C5_LOJACLI
		cQuery += "  AND SA1.A1_FILIAL = '"+xFilial("SA1")+"'"
		cQuery += "  LEFT JOIN (SELECT * FROM "+RetSqlName("PC1")+" )PC1 "
		cQuery += "  ON C6_NUM = PC1.PC1_PEDREP
		cQuery += "  AND PC1.D_E_L_E_T_ = ' '
		cQuery += "  INNER JOIN (SELECT * FROM "+RetSqlName("SF4")+" )SF4 "
		cQuery += "  ON SC6.C6_TES = SF4.F4_CODIGO
		cQuery += "  AND SF4.D_E_L_E_T_ = ' '
		cQuery += "  AND SF4.F4_DUPLIC = 'S'
		cQuery += "  WHERE SC6.D_E_L_E_T_   = ' '
		cQuery += "  AND SC6.C6_FILIAL = '"+xFilial("SC6")+"'"
		cQuery += "  AND SC5.C5_TIPO = 'N'
		cQuery += "  AND SA1.A1_GRPVEN <> 'ST'
		cQuery += "  AND SA1.A1_EST    <> 'EX'
		cQuery += "  AND SBM.BM_XAGRUP <> ' '
		cQuery += "  AND PC1.PC1_PEDREP IS NULL
		cQuery += "  AND SB1.B1_GRUPO  = SBM.BM_GRUPO
		cQuery += "  AND SC5.C5_VEND1 = '"+_cxven+"'
		cQuery += "  ),0)
		cQuery += " + "
		cQuery += "  NVL((
		cQuery += "  SELECT
		cQuery += "  SUM(CASE WHEN C6_BLQ = 'R' THEN  C6_QTDENT ELSE C6_QTDVEN END)
		cQuery += '   "QTD"
		cQuery += "  FROM UDBP12.SC6030 SC6 "
		cQuery += "  INNER JOIN ( SELECT * FROM UDBP12.SB1030 )SB1 "
		cQuery += "  ON SB1.D_E_L_E_T_   = ' '
		cQuery += "  AND SB1.B1_COD    = SC6.C6_PRODUTO
		cQuery += "  AND SB1.B1_FILIAL = '"+xFilial("SB1")+"'"
		cQuery += "  INNER JOIN ( SELECT * FROM UDBP12.SC5030 )SC5 "
		cQuery += "  ON  SC5.D_E_L_E_T_   = ' '
		cQuery += "  AND SC5.C5_NUM      = SC6.C6_NUM
		cQuery += "  AND SC5.C5_FILIAL   = SC6.C6_FILIAL
		cQuery += "  AND SUBSTR(SC5.C5_EMISSAO,1,6)  BETWEEN '"+MV_PAR04+MV_PAR03+"' AND '"+MV_PAR06+MV_PAR05+"'
		If !(Empty(Alltrim(DTOS(MV_PAR07)))) .And. !(Empty(Alltrim(DTOS(MV_PAR08))))
			cQuery += "  AND SC5.C5_EMISSAO BETWEEN '"+DTOS(MV_PAR07)+"' AND '"+DTOS(MV_PAR08)+"' "
		EndIf
		cQuery += "  INNER JOIN(SELECT * FROM UDBP12.SA1030 )SA1 "
		cQuery += "  ON SA1.D_E_L_E_T_   = ' '
		cQuery += "  AND SA1.A1_COD = SC5.C5_CLIENTE
		cQuery += "  AND SA1.A1_LOJA = SC5.C5_LOJACLI
		cQuery += "  AND SA1.A1_FILIAL = '"+xFilial("SA1")+"'"
		cQuery += "  LEFT JOIN (SELECT * FROM UDBP12.PC1030 )PC1 "
		cQuery += "  ON C6_NUM = PC1.PC1_PEDREP
		cQuery += "  AND PC1.D_E_L_E_T_ = ' '
		cQuery += "  INNER JOIN (SELECT * FROM UDBP12.SF4030 )SF4 "
		cQuery += "  ON SC6.C6_TES = SF4.F4_CODIGO
		cQuery += "  AND SF4.D_E_L_E_T_ = ' '
		cQuery += "  AND SF4.F4_DUPLIC = 'S'
		cQuery += "  WHERE SC6.D_E_L_E_T_   = ' '
		cQuery += "  AND SC6.C6_FILIAL = '01'"
		cQuery += "  AND SC5.C5_TIPO = 'N'
		cQuery += "  AND SA1.A1_GRPVEN <> 'ST'
		cQuery += "  AND SA1.A1_EST    <> 'EX'
		cQuery += "  AND SBM.BM_XAGRUP <> ' '
		cQuery += "  AND PC1.PC1_PEDREP IS NULL
		cQuery += "  AND SB1.B1_GRUPO  = SBM.BM_GRUPO
		cQuery += "  AND SC5.C5_VEND1 = '"+_cxven+"'
		cQuery += "  ),0)
		cQuery += '   "QTD_CAPTACAO" ,

		cQuery += "  NVL((
		cQuery += "  SELECT
		cQuery += "   SUM( SD2.D2_TOTAL-SD2.D2_VALICM-SD2.D2_VALIMP5-SD2.D2_VALIMP6-D2_DIFAL-D2_ICMSCOM)
		cQuery += '  "TOTAL"
		cQuery += "  FROM "+RetSqlName("SF2")+"  SF2 "
		cQuery += "  INNER JOIN(SELECT * FROM "+RetSqlName("SD2")+" )SD2 "
		cQuery += "  ON SD2.D_E_L_E_T_ = ' '
		cQuery += "  AND SD2.D2_FILIAL = SF2.F2_FILIAL
		cQuery += "  AND SD2.D2_DOC = SF2.F2_DOC
		cQuery += "  AND SD2.D2_SERIE = SF2.F2_SERIE
		cQuery += "  AND SD2.D2_CF IN('5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5403','5501','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6501','6502','7101','7102')
		cQuery += "  INNER JOIN ( SELECT * FROM "+RetSqlName("SB1")+" )SB1 "
		cQuery += "  ON SB1.D_E_L_E_T_   = ' '
		cQuery += "  AND SB1.B1_COD    = SD2.D2_COD
		cQuery += "  AND SB1.B1_FILIAL = '"+xFilial("SB1")+"'"
		cQuery += "  WHERE SUBSTR(F2_EMISSAO,1,6) BETWEEN '"+MV_PAR04+MV_PAR03+"' AND '"+MV_PAR06+MV_PAR05+"'
		cQuery += "  AND SF2.D_E_L_E_T_ = ' '
		cQuery += "  AND SF2.F2_VEND1   = '"+_cxven+"'
		cQuery += "  AND SB1.B1_GRUPO  = SBM.BM_GRUPO
		cQuery += "  AND EXISTS(SELECT * FROM "+RetSqlName("SC6")+"  SC6"
		cQuery += "  WHERE SC6.C6_NUM = SD2.D2_PEDIDO
		//	cQuery += "  AND   SC6.C6_OPER = '01'
		cQuery += "  AND   SC6.C6_FILIAL = SD2.D2_FILIAL
		cQuery += "  AND SC6.D_E_L_E_T_ = ' ' )
		cQuery += "    ),0)
		cQuery += " + "
		cQuery += "  NVL((
		cQuery += "  SELECT
		cQuery += "   SUM( SD2.D2_TOTAL-SD2.D2_VALICM-SD2.D2_VALIMP5-SD2.D2_VALIMP6-D2_DIFAL-D2_ICMSCOM)
		cQuery += '  "TOTAL"
		cQuery += "  FROM UDBP12.SF2030  SF2 "
		cQuery += "  INNER JOIN(SELECT * FROM UDBP12.SD2030 )SD2 "
		cQuery += "  ON SD2.D_E_L_E_T_ = ' '
		cQuery += "  AND SD2.D2_FILIAL = SF2.F2_FILIAL
		cQuery += "  AND SD2.D2_DOC = SF2.F2_DOC
		cQuery += "  AND SD2.D2_SERIE = SF2.F2_SERIE
		cQuery += "  AND SD2.D2_CF IN('5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5403','5501','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6501','6502','7101','7102')
		cQuery += "  INNER JOIN ( SELECT * FROM UDBP12.SB1030 )SB1 "
		cQuery += "  ON SB1.D_E_L_E_T_   = ' '
		cQuery += "  AND SB1.B1_COD    = SD2.D2_COD
		cQuery += "  AND SB1.B1_FILIAL = '"+xFilial("SB1")+"'"
		cQuery += "  WHERE SUBSTR(F2_EMISSAO,1,6) BETWEEN '"+MV_PAR04+MV_PAR03+"' AND '"+MV_PAR06+MV_PAR05+"'
		cQuery += "  AND SF2.D_E_L_E_T_ = ' '
		cQuery += "  AND SF2.F2_VEND1   = '"+_cxven+"'
		cQuery += "  AND SB1.B1_GRUPO  = SBM.BM_GRUPO
		cQuery += "  AND EXISTS(SELECT * FROM UDBP12.SC6030  SC6"
		cQuery += "  WHERE SC6.C6_NUM = SD2.D2_PEDIDO
		//	cQuery += "  AND   SC6.C6_OPER = '01'
		cQuery += "  AND   SC6.C6_FILIAL = SD2.D2_FILIAL
		cQuery += "  AND SC6.D_E_L_E_T_ = ' ' )
		cQuery += "    ),0)
		cQuery += '  "FATURAMENTO",

		cQuery += "  NVL((
		cQuery += "  SELECT
		cQuery += "   SUM( SD2.D2_QUANT)
		cQuery += '  "QTD_TOTAL"
		cQuery += "  FROM "+RetSqlName("SF2")+"  SF2 "
		cQuery += "  INNER JOIN(SELECT * FROM "+RetSqlName("SD2")+" )SD2 "
		cQuery += "  ON SD2.D_E_L_E_T_ = ' '
		cQuery += "  AND SD2.D2_FILIAL = SF2.F2_FILIAL
		cQuery += "  AND SD2.D2_DOC = SF2.F2_DOC
		cQuery += "  AND SD2.D2_SERIE = SF2.F2_SERIE
		cQuery += " AND SD2.D2_CF IN('5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5403','5501','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6501','6502','7101','7102')
		/*
		cQuery += " INNER JOIN (SELECT * FROM "+RetSqlName("SF4")+" )SF4 "
		cQuery += " ON  SD2.D2_TES = SF4.F4_CODIGO
		cQuery += " AND SF4.D_E_L_E_T_ = ' '
		cQuery += " AND SF4.F4_DUPLIC = 'S'
		*/
		cQuery += "  INNER JOIN ( SELECT * FROM "+RetSqlName("SB1")+" )SB1 "
		cQuery += "  ON SB1.D_E_L_E_T_   = ' '
		cQuery += "  AND SB1.B1_COD    = SD2.D2_COD
		cQuery += "  AND SB1.B1_FILIAL =  '"+xFilial("SB1")+"'"
		cQuery += "  WHERE SUBSTR(F2_EMISSAO,1,6) BETWEEN '"+MV_PAR04+MV_PAR03+"' AND '"+MV_PAR06+MV_PAR05+"'
		cQuery += "  AND SF2.D_E_L_E_T_ = ' '
		cQuery += "  AND SF2.F2_VEND1   = '"+_cxven+"'
		cQuery += "  AND SB1.B1_GRUPO  = SBM.BM_GRUPO
		cQuery += "  AND EXISTS(SELECT * FROM "+RetSqlName("SC6")+"  SC6"
		cQuery += "  WHERE SC6.C6_NUM = SD2.D2_PEDIDO
		//	cQuery += "  AND   SC6.C6_OPER = '01'
		cQuery += "  AND   SC6.C6_FILIAL = SD2.D2_FILIAL
		cQuery += "  AND SC6.D_E_L_E_T_ = ' ' )
		cQuery += "  ),0)
		cQuery += " + "
		cQuery += "  NVL((
		cQuery += "  SELECT
		cQuery += "   SUM( SD2.D2_QUANT)
		cQuery += '  "QTD_TOTAL"
		cQuery += "  FROM UDBP12.SF2030  SF2 "
		cQuery += "  INNER JOIN(SELECT * FROM UDBP12.SD2030 )SD2 "
		cQuery += "  ON SD2.D_E_L_E_T_ = ' '
		cQuery += "  AND SD2.D2_FILIAL = SF2.F2_FILIAL
		cQuery += "  AND SD2.D2_DOC = SF2.F2_DOC
		cQuery += "  AND SD2.D2_SERIE = SF2.F2_SERIE
		cQuery += " AND SD2.D2_CF IN('5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5403','5501','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6501','6502','7101','7102')
		/*
		cQuery += " INNER JOIN (SELECT * FROM "+RetSqlName("SF4")+" )SF4 "
		cQuery += " ON  SD2.D2_TES = SF4.F4_CODIGO
		cQuery += " AND SF4.D_E_L_E_T_ = ' '
		cQuery += " AND SF4.F4_DUPLIC = 'S'
		*/
		cQuery += "  INNER JOIN ( SELECT * FROM UDBP12.SB1030 )SB1 "
		cQuery += "  ON SB1.D_E_L_E_T_   = ' '
		cQuery += "  AND SB1.B1_COD    = SD2.D2_COD
		cQuery += "  AND SB1.B1_FILIAL =  '"+xFilial("SB1")+"'"
		cQuery += "  WHERE SUBSTR(F2_EMISSAO,1,6) BETWEEN '"+MV_PAR04+MV_PAR03+"' AND '"+MV_PAR06+MV_PAR05+"'
		cQuery += "  AND SF2.D_E_L_E_T_ = ' '
		cQuery += "  AND SF2.F2_VEND1   = '"+_cxven+"'
		cQuery += "  AND SB1.B1_GRUPO  = SBM.BM_GRUPO
		cQuery += "  AND EXISTS(SELECT * FROM UDBP12.SC6030  SC6"
		cQuery += "  WHERE SC6.C6_NUM = SD2.D2_PEDIDO
		//	cQuery += "  AND   SC6.C6_OPER = '01'
		cQuery += "  AND   SC6.C6_FILIAL = SD2.D2_FILIAL
		cQuery += "  AND SC6.D_E_L_E_T_ = ' ' )
		cQuery += "  ),0)
		cQuery += '  "QTD_FATURAMENTO"

		cQuery += "   ,NVL((	SELECT NVL(SUM(D1_QUANT),0)
		cQuery += '	"TOTAL"
		cQuery += " FROM  "+RetSqlName("SD1")+"  SD1 "
		cQuery += " INNER JOIN(SELECT * FROM   "+RetSqlName("SA1")+" )SA1 "
		cQuery += " ON SA1.D_E_L_E_T_ = ' '
		cQuery += " AND SD1.D1_TIPO = 'D'
		cQuery += " AND SA1.A1_COD = SD1.D1_FORNECE
		cQuery += " AND SA1.A1_LOJA = SD1.D1_LOJA
		cQuery += " AND SA1.A1_FILIAL = '  '
		//cQuery += " AND SA1.A1_VEND   = '"+_cxven+"'
		cQuery += "  INNER JOIN ( SELECT * FROM "+RetSqlName("SB1")+" )SB1 "
		cQuery += "  ON SB1.D_E_L_E_T_   = ' '
		cQuery += "  AND SB1.B1_COD    = SD1.D1_COD
		cQuery += "  AND SB1.B1_FILIAL = '"+xFilial("SB1")+"'"
		cQuery += " 	INNER JOIN(SELECT * FROM "+RetSqlName("SF2")+" )SF2  ON SF2.D_E_L_E_T_ = ' ' AND SF2.F2_DOC = D1_NFORI AND SF2.F2_SERIE = D1_SERIORI AND SF2.F2_FILIAL = SD1.D1_FILIAL
		//	cQuery += "  AND SB1.B1_GRUPO  = SBM.BM_GRUPO
		cQuery += " WHERE  SD1.D_E_L_E_T_ = ' '
		cQuery += "  AND SF2.F2_VEND1   = '"+_cxven+"'
		cQuery += "  AND SB1.B1_GRUPO  = SBM.BM_GRUPO
		cQuery += " AND SD1.D1_CF IN ('1201','1202','1410','1411','2201','2202','2410','2411','2203','1918','2918','3201','3202','3211','2204')
		cQuery += " AND (SD1.D1_FILIAL = '02' OR SD1.D1_FILIAL = '01')
		cQuery += " AND SUBSTR(SD1.D1_EMISSAO,1,6) BETWEEN '"+MV_PAR04+MV_PAR03+"' AND '"+MV_PAR06+MV_PAR05+"'
		cQuery += "  ),0)
		cQuery += " + "
		cQuery += "   NVL((	SELECT NVL(SUM(D1_QUANT),0)
		cQuery += '	"TOTAL"
		cQuery += " FROM  UDBP12.SD1030  SD1 "
		cQuery += " INNER JOIN(SELECT * FROM   UDBP12.SA1030 )SA1 "
		cQuery += " ON SA1.D_E_L_E_T_ = ' '
		cQuery += " AND SD1.D1_TIPO = 'D'
		cQuery += " AND SA1.A1_COD = SD1.D1_FORNECE
		cQuery += " AND SA1.A1_LOJA = SD1.D1_LOJA
		cQuery += " AND SA1.A1_FILIAL = '  '
		//cQuery += " AND SA1.A1_VEND   = '"+_cxven+"'
		cQuery += "  INNER JOIN ( SELECT * FROM UDBP12.SB1030 )SB1 "
		cQuery += "  ON SB1.D_E_L_E_T_   = ' '
		cQuery += "  AND SB1.B1_COD    = SD1.D1_COD
		cQuery += "  AND SB1.B1_FILIAL = '"+xFilial("SB1")+"'"
		cQuery += " 	INNER JOIN(SELECT * FROM UDBP12.SF2030 )SF2  ON SF2.D_E_L_E_T_ = ' ' AND SF2.F2_DOC = D1_NFORI AND SF2.F2_SERIE = D1_SERIORI AND SF2.F2_FILIAL = SD1.D1_FILIAL
		//	cQuery += "  AND SB1.B1_GRUPO  = SBM.BM_GRUPO
		cQuery += " WHERE  SD1.D_E_L_E_T_ = ' '
		cQuery += "  AND SF2.F2_VEND1   = '"+_cxven+"'
		cQuery += "  AND SB1.B1_GRUPO  = SBM.BM_GRUPO
		cQuery += " AND SD1.D1_CF IN ('1201','1202','1410','1411','2201','2202','2410','2411','2203','1918','2918','3201','3202','3211','2204')
		cQuery += " AND (SD1.D1_FILIAL = '02' OR SD1.D1_FILIAL = '01')
		cQuery += " AND SUBSTR(SD1.D1_EMISSAO,1,6) BETWEEN '"+MV_PAR04+MV_PAR03+"' AND '"+MV_PAR06+MV_PAR05+"'
		cQuery += "  ),0)
		cQuery += '  "QTD_DEV"

		cQuery += "   ,NVL((	SELECT NVL(SUM(D1_TOTAL-SD1.D1_VALIMP5-SD1.D1_VALIMP6-SD1.D1_VALICM),0)
		cQuery += '	"TOTAL"
		cQuery += " FROM  "+RetSqlName("SD1")+"  SD1 "
		cQuery += " INNER JOIN(SELECT * FROM   "+RetSqlName("SA1")+" )SA1 "
		cQuery += " ON SA1.D_E_L_E_T_ = ' '
		cQuery += " AND SD1.D1_TIPO = 'D'
		cQuery += " AND SA1.A1_COD = SD1.D1_FORNECE
		cQuery += " AND SA1.A1_LOJA = SD1.D1_LOJA
		cQuery += " AND SA1.A1_FILIAL = '  '
		//cQuery += "  AND SA1.A1_VEND1   = '"+_cxven+"'
		cQuery += "  INNER JOIN ( SELECT * FROM "+RetSqlName("SB1")+" )SB1 "
		cQuery += "  ON SB1.D_E_L_E_T_   = ' '
		cQuery += "  AND SB1.B1_COD    = SD1.D1_COD
		cQuery += "  AND SB1.B1_FILIAL = '"+xFilial("SB1")+"'"
		cQuery += " 	INNER JOIN(SELECT * FROM "+RetSqlName("SF2")+" )SF2  ON SF2.D_E_L_E_T_ = ' ' AND SF2.F2_DOC = D1_NFORI AND SF2.F2_SERIE = D1_SERIORI AND SF2.F2_FILIAL = SD1.D1_FILIAL
		//	cQuery += "  AND SB1.B1_GRUPO  = SBM.BM_GRUPO
		cQuery += " WHERE  SD1.D_E_L_E_T_ = ' '
		cQuery += "  AND SF2.F2_VEND1   = '"+_cxven+"'
		cQuery += "  AND SB1.B1_GRUPO  = SBM.BM_GRUPO
		cQuery += " AND SD1.D1_CF IN ('1201','1202','1410','1411','2201','2202','2410','2411','2203','1918','2918','3201','3202','3211','2204')
		cQuery += " AND (SD1.D1_FILIAL = '02' OR SD1.D1_FILIAL = '01')
		cQuery += " AND SUBSTR(SD1.D1_EMISSAO,1,6) BETWEEN '"+MV_PAR04+MV_PAR03+"' AND '"+MV_PAR06+MV_PAR05+"'
		cQuery += "  ),0)
		cQuery += " + "
		cQuery += "   NVL((	SELECT NVL(SUM(D1_TOTAL-SD1.D1_VALIMP5-SD1.D1_VALIMP6-SD1.D1_VALICM),0)
		cQuery += '	"TOTAL"
		cQuery += " FROM  UDBP12.SD1030 SD1 "
		cQuery += " INNER JOIN(SELECT * FROM UDBP12.SA1030 )SA1 "
		cQuery += " ON SA1.D_E_L_E_T_ = ' '
		cQuery += " AND SD1.D1_TIPO = 'D'
		cQuery += " AND SA1.A1_COD = SD1.D1_FORNECE
		cQuery += " AND SA1.A1_LOJA = SD1.D1_LOJA
		cQuery += " AND SA1.A1_FILIAL = '  '
		//cQuery += "  AND SA1.A1_VEND1   = '"+_cxven+"'
		cQuery += "  INNER JOIN ( SELECT * FROM UDBP12.SB1030 )SB1 "
		cQuery += "  ON SB1.D_E_L_E_T_   = ' '
		cQuery += "  AND SB1.B1_COD    = SD1.D1_COD
		cQuery += "  AND SB1.B1_FILIAL = '"+xFilial("SB1")+"'"
		cQuery += " 	INNER JOIN(SELECT * FROM UDBP12.SF2030 )SF2  ON SF2.D_E_L_E_T_ = ' ' AND SF2.F2_DOC = D1_NFORI AND SF2.F2_SERIE = D1_SERIORI AND SF2.F2_FILIAL = SD1.D1_FILIAL
		//	cQuery += "  AND SB1.B1_GRUPO  = SBM.BM_GRUPO
		cQuery += " WHERE  SD1.D_E_L_E_T_ = ' '
		cQuery += "  AND SF2.F2_VEND1   = '"+_cxven+"'
		cQuery += "  AND SB1.B1_GRUPO  = SBM.BM_GRUPO
		cQuery += " AND SD1.D1_CF IN ('1201','1202','1410','1411','2201','2202','2410','2411','2203','1918','2918','3201','3202','3211','2204')
		cQuery += " AND (SD1.D1_FILIAL = '02' OR SD1.D1_FILIAL = '01')
		cQuery += " AND SUBSTR(SD1.D1_EMISSAO,1,6) BETWEEN '"+MV_PAR04+MV_PAR03+"' AND '"+MV_PAR06+MV_PAR05+"'
		cQuery += "  ),0)
		cQuery += '  "QTD_TOTAL"


		cQuery += "  FROM  "+RetSqlName("SBM")+"  SBM "
		cQuery += "  WHERE SBM.D_E_L_E_T_ = ' '
		cQuery += "  AND   SBM.BM_FILIAL  =  '"+xFilial("SBM")+"' and bm_xagrup <>  ' '

	ELse

		cQuery += "  SELECT


		cQuery += "  sum(NVL((SELECT SUM(ZZD.ZZD_VALOR)
		cQuery += "  FROM "+RetSqlName("ZZD")+" ZZD "
		cQuery += "  WHERE ZZD.D_E_L_E_T_ = ' '
		cQuery += "  AND ZZD.ZZD_MES      BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR05+"'
		cQuery += "  AND ZZD.ZZD_ANO      BETWEEN '"+MV_PAR04+"' AND '"+MV_PAR06+"'
		cQuery += "  AND ZZD.ZZD_FILIAL   =  '"+xFilial("ZZD")+"'"
		//cQuery += "  AND ZZD.ZZD_GRUPO    = SBM.BM_GRUPO
		cQuery += "  AND ZZD.ZZD_VEND   = SA3.A3_COD
		cQuery += '   ),0)) "OBJETIVO",

		cQuery += "  sum(NVL((SELECT SUM(ZZD.ZZD_QTD)
		cQuery += "  FROM "+RetSqlName("ZZD")+" ZZD "
		cQuery += "  WHERE ZZD.D_E_L_E_T_ = ' '
		cQuery += "  AND ZZD.ZZD_MES      BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR05+"'
		cQuery += "  AND ZZD.ZZD_ANO      BETWEEN '"+MV_PAR04+"' AND '"+MV_PAR06+"'
		cQuery += "  AND ZZD.ZZD_FILIAL   = '"+xFilial("ZZD")+"'"
		//cQuery += "  AND ZZD.ZZD_GRUPO    = SBM.BM_GRUPO
		cQuery += "  AND ZZD.ZZD_VEND   = SA3.A3_COD
		cQuery += "   ),0))
		cQuery += '  "QTD_OBJETIVO" ,

		cQuery += "  sum(ROUND(NVL((
		cQuery += "  SELECT
		cQuery += "  SUM(CASE WHEN C6_BLQ = 'R' THEN (C6_ZVALLIQ/C6_QTDVEN)*C6_QTDENT ELSE C6_ZVALLIQ END)
		cQuery += '  "VALOR"
		cQuery += "  FROM "+RetSqlName("SC6")+" SC6 "
		cQuery += "  INNER JOIN ( SELECT * FROM "+RetSqlName("SB1")+" )SB1 "
		cQuery += "  ON SB1.D_E_L_E_T_   = ' '
		cQuery += "  AND SB1.B1_COD    = SC6.C6_PRODUTO
		cQuery += "  AND SB1.B1_FILIAL = '"+xFilial("SB1")+"'"
		cQuery += "  INNER JOIN ( SELECT * FROM "+RetSqlName("SC5")+" )SC5 "
		cQuery += "  ON  SC5.D_E_L_E_T_   = ' '
		cQuery += "  AND SC5.C5_NUM      = SC6.C6_NUM
		cQuery += "  AND SC5.C5_FILIAL   = SC6.C6_FILIAL
		cQuery += "  AND SUBSTR(SC5.C5_EMISSAO,1,6) BETWEEN '"+MV_PAR04+MV_PAR03+"' AND '"+MV_PAR06+MV_PAR05+"'
		If !(Empty(Alltrim(DTOS(MV_PAR07)))) .And. !(Empty(Alltrim(DTOS(MV_PAR08))))
			cQuery += "  AND SC5.C5_EMISSAO BETWEEN '"+DTOS(MV_PAR07)+"' AND '"+DTOS(MV_PAR08)+"' "
		EndIf
		cQuery += "  INNER JOIN(SELECT * FROM "+RetSqlName("SA1")+" )SA1 "
		cQuery += "  ON SA1.D_E_L_E_T_   = ' '
		cQuery += "  AND SA1.A1_COD = SC5.C5_CLIENTE
		cQuery += "  AND SA1.A1_LOJA = SC5.C5_LOJACLI
		cQuery += "  AND SA1.A1_FILIAL = '"+xFilial("SA1")+"'"
		cQuery += "  LEFT JOIN (SELECT * FROM "+RetSqlName("PC1")+" )PC1 "
		cQuery += "  ON C6_NUM = PC1.PC1_PEDREP
		cQuery += "  AND PC1.D_E_L_E_T_ = ' '
		cQuery += "  INNER JOIN (SELECT * FROM "+RetSqlName("SF4")+" )SF4 "
		cQuery += "  ON SC6.C6_TES = SF4.F4_CODIGO
		cQuery += "  AND SF4.D_E_L_E_T_ = ' '
		cQuery += "  AND SF4.F4_DUPLIC = 'S'
		cQuery += "  WHERE SC6.D_E_L_E_T_   = ' '
		cQuery += "  AND SC6.C6_FILIAL = '"+xFilial("SC6")+"'"
		cQuery += "  AND SC5.C5_TIPO = 'N'
		cQuery += "  AND SA1.A1_GRPVEN <> 'ST'
		cQuery += "  AND SA1.A1_EST    <> 'EX'
		cQuery += "  AND SA1.A1_GRPVEN <> 'SC'
		//cQuery += "  AND SBM.BM_XAGRUP <> ' '
		cQuery += "  AND PC1.PC1_PEDREP IS NULL
		//cQuery += "  AND SB1.B1_GRUPO  = SBM.BM_GRUPO
		cQuery += "  AND SC5.C5_VEND1 = SA3.A3_COD
		cQuery += "  ),0),2))
		cQuery += " + "
		cQuery += "  sum(ROUND(NVL((
		cQuery += "  SELECT
		cQuery += "  SUM(CASE WHEN C6_BLQ = 'R' THEN (C6_ZVALLIQ/C6_QTDVEN)*C6_QTDENT ELSE C6_ZVALLIQ END)
		cQuery += '  "VALOR"
		cQuery += "  FROM UDBP12.SC6030 SC6 "
		cQuery += "  INNER JOIN ( SELECT * FROM UDBP12.SB1030 )SB1 "
		cQuery += "  ON SB1.D_E_L_E_T_   = ' '
		cQuery += "  AND SB1.B1_COD    = SC6.C6_PRODUTO
		cQuery += "  AND SB1.B1_FILIAL = '"+xFilial("SB1")+"'"
		cQuery += "  INNER JOIN ( SELECT * FROM UDBP12.SC5030 )SC5 "
		cQuery += "  ON  SC5.D_E_L_E_T_   = ' '
		cQuery += "  AND SC5.C5_NUM      = SC6.C6_NUM
		cQuery += "  AND SC5.C5_FILIAL   = SC6.C6_FILIAL
		cQuery += "  AND SUBSTR(SC5.C5_EMISSAO,1,6) BETWEEN '"+MV_PAR04+MV_PAR03+"' AND '"+MV_PAR06+MV_PAR05+"'
		If !(Empty(Alltrim(DTOS(MV_PAR07)))) .And. !(Empty(Alltrim(DTOS(MV_PAR08))))
			cQuery += "  AND SC5.C5_EMISSAO BETWEEN '"+DTOS(MV_PAR07)+"' AND '"+DTOS(MV_PAR08)+"' "
		EndIf
		cQuery += "  INNER JOIN(SELECT * FROM UDBP12.SA1030 )SA1 "
		cQuery += "  ON SA1.D_E_L_E_T_   = ' '
		cQuery += "  AND SA1.A1_COD = SC5.C5_CLIENTE
		cQuery += "  AND SA1.A1_LOJA = SC5.C5_LOJACLI
		cQuery += "  AND SA1.A1_FILIAL = '"+xFilial("SA1")+"'"
		cQuery += "  LEFT JOIN (SELECT * FROM UDBP12.PC1030 )PC1 "
		cQuery += "  ON C6_NUM = PC1.PC1_PEDREP
		cQuery += "  AND PC1.D_E_L_E_T_ = ' '
		cQuery += "  INNER JOIN (SELECT * FROM UDBP12.SF4030 )SF4 "
		cQuery += "  ON SC6.C6_TES = SF4.F4_CODIGO
		cQuery += "  AND SF4.D_E_L_E_T_ = ' '
		cQuery += "  AND SF4.F4_DUPLIC = 'S'
		cQuery += "  WHERE SC6.D_E_L_E_T_   = ' '
		cQuery += "  AND SC6.C6_FILIAL = '01' "
		cQuery += "  AND SC5.C5_TIPO = 'N'
		cQuery += "  AND SA1.A1_GRPVEN <> 'ST'
		cQuery += "  AND SA1.A1_EST    <> 'EX'
		cQuery += "  AND SA1.A1_GRPVEN <> 'SC'
		//cQuery += "  AND SBM.BM_XAGRUP <> ' '
		cQuery += "  AND PC1.PC1_PEDREP IS NULL
		//cQuery += "  AND SB1.B1_GRUPO  = SBM.BM_GRUPO
		cQuery += "  AND SC5.C5_VEND1 = SA3.A3_COD
		cQuery += "  ),0),2))
		cQuery += '   "CAPTACAO" ,

		cQuery += "  sum(NVL((
		cQuery += "  SELECT
		cQuery += "  SUM(CASE WHEN C6_BLQ = 'R' THEN  C6_QTDENT ELSE C6_QTDVEN END)
		cQuery += '   "QTD"
		cQuery += "  FROM "+RetSqlName("SC6")+" SC6 "
		cQuery += "  INNER JOIN ( SELECT * FROM "+RetSqlName("SB1")+" )SB1 "
		cQuery += "  ON SB1.D_E_L_E_T_   = ' '
		cQuery += "  AND SB1.B1_COD    = SC6.C6_PRODUTO
		cQuery += "  AND SB1.B1_FILIAL = '"+xFilial("SB1")+"'"
		cQuery += "  INNER JOIN ( SELECT * FROM "+RetSqlName("SC5")+" )SC5 "
		cQuery += "  ON  SC5.D_E_L_E_T_   = ' '
		cQuery += "  AND SC5.C5_NUM      = SC6.C6_NUM
		cQuery += "  AND SC5.C5_FILIAL   = SC6.C6_FILIAL
		cQuery += "  AND SUBSTR(SC5.C5_EMISSAO,1,6)  BETWEEN '"+MV_PAR04+MV_PAR03+"' AND '"+MV_PAR06+MV_PAR05+"'
		If !(Empty(Alltrim(DTOS(MV_PAR07)))) .And. !(Empty(Alltrim(DTOS(MV_PAR08))))
			cQuery += "  AND SC5.C5_EMISSAO BETWEEN '"+DTOS(MV_PAR07)+"' AND '"+DTOS(MV_PAR08)+"' "
		EndIf
		cQuery += "  INNER JOIN(SELECT * FROM "+RetSqlName("SA1")+" )SA1 "
		cQuery += "  ON SA1.D_E_L_E_T_   = ' '
		cQuery += "  AND SA1.A1_COD = SC5.C5_CLIENTE
		cQuery += "  AND SA1.A1_LOJA = SC5.C5_LOJACLI
		cQuery += "  AND SA1.A1_FILIAL = '"+xFilial("SA1")+"'"
		cQuery += "  LEFT JOIN (SELECT * FROM "+RetSqlName("PC1")+" )PC1 "
		cQuery += "  ON C6_NUM = PC1.PC1_PEDREP
		cQuery += "  AND PC1.D_E_L_E_T_ = ' '
		cQuery += "  INNER JOIN (SELECT * FROM "+RetSqlName("SF4")+" )SF4 "
		cQuery += "  ON SC6.C6_TES = SF4.F4_CODIGO
		cQuery += "  AND SF4.D_E_L_E_T_ = ' '
		cQuery += "  AND SF4.F4_DUPLIC = 'S'
		cQuery += "  WHERE SC6.D_E_L_E_T_   = ' '
		cQuery += "  AND SC6.C6_FILIAL = '"+xFilial("SC6")+"'"
		cQuery += "  AND SC5.C5_TIPO = 'N'
		cQuery += "  AND SA1.A1_GRPVEN <> 'ST'
		cQuery += "  AND SA1.A1_EST    <> 'EX'
		cQuery += "  AND SA1.A1_GRPVEN <> 'SC'
		//cQuery += "  AND SBM.BM_XAGRUP <> ' '
		cQuery += "  AND PC1.PC1_PEDREP IS NULL
		//cQuery += "  AND SB1.B1_GRUPO  = SBM.BM_GRUPO
		cQuery += "  AND SC5.C5_VEND1 = SA3.A3_COD
		cQuery += "  ),0))
		cQuery += " + "
		cQuery += "  sum(NVL((
		cQuery += "  SELECT
		cQuery += "  SUM(CASE WHEN C6_BLQ = 'R' THEN  C6_QTDENT ELSE C6_QTDVEN END)
		cQuery += '   "QTD"
		cQuery += "  FROM UDBP12.SC6030 SC6 "
		cQuery += "  INNER JOIN ( SELECT * FROM UDBP12.SB1030 )SB1 "
		cQuery += "  ON SB1.D_E_L_E_T_   = ' '
		cQuery += "  AND SB1.B1_COD    = SC6.C6_PRODUTO
		cQuery += "  AND SB1.B1_FILIAL = '"+xFilial("SB1")+"'"
		cQuery += "  INNER JOIN ( SELECT * FROM UDBP12.SC5030 )SC5 "
		cQuery += "  ON  SC5.D_E_L_E_T_   = ' '
		cQuery += "  AND SC5.C5_NUM      = SC6.C6_NUM
		cQuery += "  AND SC5.C5_FILIAL   = SC6.C6_FILIAL
		cQuery += "  AND SUBSTR(SC5.C5_EMISSAO,1,6)  BETWEEN '"+MV_PAR04+MV_PAR03+"' AND '"+MV_PAR06+MV_PAR05+"'
		If !(Empty(Alltrim(DTOS(MV_PAR07)))) .And. !(Empty(Alltrim(DTOS(MV_PAR08))))
			cQuery += "  AND SC5.C5_EMISSAO BETWEEN '"+DTOS(MV_PAR07)+"' AND '"+DTOS(MV_PAR08)+"' "
		EndIf
		cQuery += "  INNER JOIN(SELECT * FROM UDBP12.SA1030 )SA1 "
		cQuery += "  ON SA1.D_E_L_E_T_   = ' '
		cQuery += "  AND SA1.A1_COD = SC5.C5_CLIENTE
		cQuery += "  AND SA1.A1_LOJA = SC5.C5_LOJACLI
		cQuery += "  AND SA1.A1_FILIAL = '"+xFilial("SA1")+"'"
		cQuery += "  LEFT JOIN (SELECT * FROM UDBP12.PC1030 )PC1 "
		cQuery += "  ON C6_NUM = PC1.PC1_PEDREP
		cQuery += "  AND PC1.D_E_L_E_T_ = ' '
		cQuery += "  INNER JOIN (SELECT * FROM UDBP12.SF4030 )SF4 "
		cQuery += "  ON SC6.C6_TES = SF4.F4_CODIGO
		cQuery += "  AND SF4.D_E_L_E_T_ = ' '
		cQuery += "  AND SF4.F4_DUPLIC = 'S'
		cQuery += "  WHERE SC6.D_E_L_E_T_   = ' '
		cQuery += "  AND SC6.C6_FILIAL = '01'"
		cQuery += "  AND SC5.C5_TIPO = 'N'
		cQuery += "  AND SA1.A1_GRPVEN <> 'ST'
		cQuery += "  AND SA1.A1_EST    <> 'EX'
		cQuery += "  AND SA1.A1_GRPVEN <> 'SC'
		//cQuery += "  AND SBM.BM_XAGRUP <> ' '
		cQuery += "  AND PC1.PC1_PEDREP IS NULL
		//cQuery += "  AND SB1.B1_GRUPO  = SBM.BM_GRUPO
		cQuery += "  AND SC5.C5_VEND1 = SA3.A3_COD
		cQuery += "  ),0))
		cQuery += '   "QTD_CAPTACAO",

		cQuery += "  sum(NVL((
		cQuery += "  SELECT
		cQuery += "   SUM( SD2.D2_TOTAL-SD2.D2_VALICM-SD2.D2_VALIMP5-SD2.D2_VALIMP6-D2_DIFAL-D2_ICMSCOM)
		cQuery += '  "TOTAL"
		cQuery += "  FROM "+RetSqlName("SF2")+"  SF2 "
		cQuery += "  INNER JOIN(SELECT * FROM "+RetSqlName("SD2")+" )SD2 "
		cQuery += "  ON SD2.D_E_L_E_T_ = ' '
		cQuery += "  AND SD2.D2_FILIAL = SF2.F2_FILIAL
		cQuery += "  AND SD2.D2_DOC = SF2.F2_DOC
		cQuery += "  AND SD2.D2_SERIE = SF2.F2_SERIE
		cQuery += "  AND SD2.D2_CF IN('5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5403','5501','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6501','6502','7101','7102')
		cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("SA1")+" )SA1 "
		cQuery += " ON SA1.D_E_L_E_T_ = ' '
		cQuery += " AND SA1.A1_COD  = SD2.D2_CLIENTE
		cQuery += " AND SA1.A1_LOJA = SD2.D2_LOJA
		cQuery += " AND SA1.A1_FILIAL = '"+xFilial("SA1")+"'"
		cQuery += " AND SA1.A1_GRPVEN <> 'ST'
		cQuery += " AND SA1.A1_GRPVEN <> 'SC'
		cQuery += " AND SA1.A1_EST    <> 'EX'
		cQuery += "  INNER JOIN ( SELECT * FROM "+RetSqlName("SB1")+" )SB1 "
		cQuery += "  ON SB1.D_E_L_E_T_   = ' '
		cQuery += "  AND SB1.B1_COD    = SD2.D2_COD
		cQuery += "  AND SB1.B1_FILIAL = '"+xFilial("SB1")+"'"
		/*
		cQuery += " INNER JOIN (SELECT * FROM "+RetSqlName("SF4")+" )SF4 "
		cQuery += " ON  SD2.D2_TES = SF4.F4_CODIGO
		cQuery += " AND SF4.D_E_L_E_T_ = ' '
		cQuery += " AND SF4.F4_DUPLIC = 'S'
		*/
		cQuery += "  WHERE SUBSTR(F2_EMISSAO,1,6) BETWEEN '"+MV_PAR04+MV_PAR03+"' AND '"+MV_PAR06+MV_PAR05+"'
		cQuery += "  AND SF2.D_E_L_E_T_ = ' '
		cQuery += "  AND SF2.F2_VEND1   = SA3.A3_COD
		//cQuery += "  AND SB1.B1_GRUPO  = SBM.BM_GRUPO
		cQuery += "  AND EXISTS(SELECT * FROM "+RetSqlName("SC6")+"  SC6"
		cQuery += "  WHERE SC6.C6_NUM = SD2.D2_PEDIDO
		//	cQuery += "  AND   SC6.C6_OPER = '01'
		cQuery += "  AND   SC6.C6_FILIAL = SD2.D2_FILIAL
		cQuery += "  AND SC6.D_E_L_E_T_ = ' ' )
		cQuery += "    ),0))
		cQuery += " + "
		cQuery += "  sum(NVL((
		cQuery += "  SELECT
		cQuery += "   SUM( SD2.D2_TOTAL-SD2.D2_VALICM-SD2.D2_VALIMP5-SD2.D2_VALIMP6-D2_DIFAL-D2_ICMSCOM)
		cQuery += '  "TOTAL"
		cQuery += "  FROM UDBP12.SF2030 SF2 "
		cQuery += "  INNER JOIN(SELECT * FROM UDBP12.SD2030 )SD2 "
		cQuery += "  ON SD2.D_E_L_E_T_ = ' '
		cQuery += "  AND SD2.D2_FILIAL = SF2.F2_FILIAL
		cQuery += "  AND SD2.D2_DOC = SF2.F2_DOC
		cQuery += "  AND SD2.D2_SERIE = SF2.F2_SERIE
		cQuery += "  AND SD2.D2_CF IN('5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5403','5501','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6501','6502','7101','7102')
		cQuery += " INNER JOIN(SELECT * FROM UDBP12.SA1030 )SA1 "
		cQuery += " ON SA1.D_E_L_E_T_ = ' '
		cQuery += " AND SA1.A1_COD  = SD2.D2_CLIENTE
		cQuery += " AND SA1.A1_LOJA = SD2.D2_LOJA
		cQuery += " AND SA1.A1_FILIAL = '"+xFilial("SA1")+"'"
		cQuery += " AND SA1.A1_GRPVEN <> 'ST'
		cQuery += " AND SA1.A1_GRPVEN <> 'SC'
		cQuery += " AND SA1.A1_EST    <> 'EX'
		cQuery += "  INNER JOIN ( SELECT * FROM UDBP12.SB1030 )SB1 "
		cQuery += "  ON SB1.D_E_L_E_T_   = ' '
		cQuery += "  AND SB1.B1_COD    = SD2.D2_COD
		cQuery += "  AND SB1.B1_FILIAL = '"+xFilial("SB1")+"'"
		/*
		cQuery += " INNER JOIN (SELECT * FROM "+RetSqlName("SF4")+" )SF4 "
		cQuery += " ON  SD2.D2_TES = SF4.F4_CODIGO
		cQuery += " AND SF4.D_E_L_E_T_ = ' '
		cQuery += " AND SF4.F4_DUPLIC = 'S'
		*/
		cQuery += "  WHERE SUBSTR(F2_EMISSAO,1,6) BETWEEN '"+MV_PAR04+MV_PAR03+"' AND '"+MV_PAR06+MV_PAR05+"'
		cQuery += "  AND SF2.D_E_L_E_T_ = ' '
		cQuery += "  AND SF2.F2_VEND1   = SA3.A3_COD
		//cQuery += "  AND SB1.B1_GRUPO  = SBM.BM_GRUPO
		cQuery += "  AND EXISTS(SELECT * FROM UDBP12.SC6030 SC6"
		cQuery += "  WHERE SC6.C6_NUM = SD2.D2_PEDIDO
		//	cQuery += "  AND   SC6.C6_OPER = '01'
		cQuery += "  AND   SC6.C6_FILIAL = SD2.D2_FILIAL
		cQuery += "  AND SC6.D_E_L_E_T_ = ' ' )
		cQuery += "    ),0))
		cQuery += '  "FATURAMENTO",

		cQuery += "  sum(NVL((
		cQuery += "  SELECT
		cQuery += "   SUM( SD2.D2_QUANT)
		cQuery += '  "QTD_TOTAL"
		cQuery += "  FROM "+RetSqlName("SF2")+"  SF2 "
		cQuery += "  INNER JOIN(SELECT * FROM "+RetSqlName("SD2")+" )SD2 "
		cQuery += "  ON SD2.D_E_L_E_T_ = ' '
		cQuery += "  AND SD2.D2_FILIAL = SF2.F2_FILIAL
		cQuery += "  AND SD2.D2_DOC = SF2.F2_DOC
		cQuery += "  AND SD2.D2_SERIE = SF2.F2_SERIE
		cQuery += " AND SD2.D2_CF IN('5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5403','5501','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6501','6502','7101','7102')
		cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("SA1")+" )SA1 "
		cQuery += " ON SA1.D_E_L_E_T_ = ' '
		cQuery += " AND SA1.A1_COD  = SD2.D2_CLIENTE
		cQuery += " AND SA1.A1_LOJA = SD2.D2_LOJA
		cQuery += " AND SA1.A1_FILIAL = '"+xFilial("SA1")+"'"
		cQuery += " AND SA1.A1_GRPVEN <> 'ST'
		cQuery += " AND SA1.A1_GRPVEN <> 'SC'
		cQuery += " AND SA1.A1_EST    <> 'EX'
		cQuery += "  INNER JOIN ( SELECT * FROM "+RetSqlName("SB1")+" )SB1 "
		cQuery += "  ON SB1.D_E_L_E_T_   = ' '
		cQuery += "  AND SB1.B1_COD    = SD2.D2_COD
		cQuery += "  AND SB1.B1_FILIAL =  '"+xFilial("SB1")+"'"
		/*
		cQuery += " INNER JOIN (SELECT * FROM "+RetSqlName("SF4")+" )SF4 "
		cQuery += " ON  SD2.D2_TES = SF4.F4_CODIGO
		cQuery += " AND SF4.D_E_L_E_T_ = ' '
		cQuery += " AND SF4.F4_DUPLIC = 'S'
		*/
		cQuery += "  WHERE SUBSTR(F2_EMISSAO,1,6) BETWEEN '"+MV_PAR04+MV_PAR03+"' AND '"+MV_PAR06+MV_PAR05+"'
		cQuery += "  AND SF2.D_E_L_E_T_ = ' '
		cQuery += "  AND SF2.F2_VEND1   = SA3.A3_COD
		//cQuery += "  AND SB1.B1_GRUPO  = SBM.BM_GRUPO
		cQuery += "  AND EXISTS(SELECT * FROM "+RetSqlName("SC6")+"  SC6"
		cQuery += "  WHERE SC6.C6_NUM = SD2.D2_PEDIDO
		//	cQuery += "  AND   SC6.C6_OPER = '01'
		cQuery += "  AND   SC6.C6_FILIAL = SD2.D2_FILIAL
		cQuery += "  AND SC6.D_E_L_E_T_ = ' ' )
		cQuery += "  ),0))
		cQuery += " + "
		cQuery += "  sum(NVL((
		cQuery += "  SELECT
		cQuery += "   SUM( SD2.D2_QUANT)
		cQuery += '  "QTD_TOTAL"
		cQuery += "  FROM UDBP12.SF2030 SF2 "
		cQuery += "  INNER JOIN(SELECT * FROM UDBP12.SD2030 )SD2 "
		cQuery += "  ON SD2.D_E_L_E_T_ = ' '
		cQuery += "  AND SD2.D2_FILIAL = SF2.F2_FILIAL
		cQuery += "  AND SD2.D2_DOC = SF2.F2_DOC
		cQuery += "  AND SD2.D2_SERIE = SF2.F2_SERIE
		cQuery += " AND SD2.D2_CF IN('5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5403','5501','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6501','6502','7101','7102')
		cQuery += " INNER JOIN(SELECT * FROM UDBP12.SA1030 )SA1 "
		cQuery += " ON SA1.D_E_L_E_T_ = ' '
		cQuery += " AND SA1.A1_COD  = SD2.D2_CLIENTE
		cQuery += " AND SA1.A1_LOJA = SD2.D2_LOJA
		cQuery += " AND SA1.A1_FILIAL = '"+xFilial("SA1")+"'"
		cQuery += " AND SA1.A1_GRPVEN <> 'ST'
		cQuery += " AND SA1.A1_GRPVEN <> 'SC'
		cQuery += " AND SA1.A1_EST    <> 'EX'
		cQuery += "  INNER JOIN ( SELECT * FROM UDBP12.SB1030 )SB1 "
		cQuery += "  ON SB1.D_E_L_E_T_   = ' '
		cQuery += "  AND SB1.B1_COD    = SD2.D2_COD
		cQuery += "  AND SB1.B1_FILIAL =  '"+xFilial("SB1")+"'"
		/*
		cQuery += " INNER JOIN (SELECT * FROM "+RetSqlName("SF4")+" )SF4 "
		cQuery += " ON  SD2.D2_TES = SF4.F4_CODIGO
		cQuery += " AND SF4.D_E_L_E_T_ = ' '
		cQuery += " AND SF4.F4_DUPLIC = 'S'
		*/
		cQuery += "  WHERE SUBSTR(F2_EMISSAO,1,6) BETWEEN '"+MV_PAR04+MV_PAR03+"' AND '"+MV_PAR06+MV_PAR05+"'
		cQuery += "  AND SF2.D_E_L_E_T_ = ' '
		cQuery += "  AND SF2.F2_VEND1   = SA3.A3_COD
		//cQuery += "  AND SB1.B1_GRUPO  = SBM.BM_GRUPO
		cQuery += "  AND EXISTS(SELECT * FROM UDBP12.SC6030 SC6"
		cQuery += "  WHERE SC6.C6_NUM = SD2.D2_PEDIDO
		//	cQuery += "  AND   SC6.C6_OPER = '01'
		cQuery += "  AND   SC6.C6_FILIAL = SD2.D2_FILIAL
		cQuery += "  AND SC6.D_E_L_E_T_ = ' ' )
		cQuery += "  ),0))
		cQuery += '  "QTD_FATURAMENTO"

		cQuery += "   ,sum(NVL((	SELECT NVL(SUM(D1_QUANT),0)
		cQuery += '	"TOTAL"
		cQuery += " FROM  "+RetSqlName("SD1")+"  SD1 "
		cQuery += " INNER JOIN(SELECT * FROM   "+RetSqlName("SA1")+" )SA1 "
		cQuery += " ON SA1.D_E_L_E_T_ = ' '
		cQuery += " AND SD1.D1_TIPO = 'D'
		cQuery += " AND SA1.A1_COD = SD1.D1_FORNECE
		cQuery += " AND SA1.A1_LOJA = SD1.D1_LOJA
		cQuery += " AND SA1.A1_FILIAL = '  '
		//cQuery += "  AND SA1.A1_VEND   = '"+_cxven+"'
		cQuery += " 	INNER JOIN(SELECT * FROM "+RetSqlName("SF2")+" )SF2  ON SF2.D_E_L_E_T_ = ' ' AND SF2.F2_DOC = D1_NFORI AND SF2.F2_SERIE = D1_SERIORI AND SF2.F2_FILIAL = SD1.D1_FILIAL
		cQuery += " WHERE  SD1.D_E_L_E_T_ = ' '
		cQuery += "  AND SF2.F2_VEND1   = '"+_cxven+"'
		cQuery += " AND SD1.D1_CF IN ('1201','1202','1410','1411','2201','2202','2410','2411','2203','1918','2918','3201','3202','3211','2204')
		cQuery += " AND (SD1.D1_FILIAL = '02' OR SD1.D1_FILIAL = '01')
		cQuery += " AND SUBSTR(SD1.D1_EMISSAO,1,6) BETWEEN '"+MV_PAR04+MV_PAR03+"' AND '"+MV_PAR06+MV_PAR05+"'
		cQuery += "  ),0))
		cQuery += " + "
		cQuery += "   sum(NVL((	SELECT NVL(SUM(D1_QUANT),0)
		cQuery += '	"TOTAL"
		cQuery += " FROM  UDBP12.SD1030 SD1 "
		cQuery += " INNER JOIN(SELECT * FROM UDBP12.SA1030 )SA1 "
		cQuery += " ON SA1.D_E_L_E_T_ = ' '
		cQuery += " AND SD1.D1_TIPO = 'D'
		cQuery += " AND SA1.A1_COD = SD1.D1_FORNECE
		cQuery += " AND SA1.A1_LOJA = SD1.D1_LOJA
		cQuery += " AND SA1.A1_FILIAL = '  '
		//cQuery += "  AND SA1.A1_VEND   = '"+_cxven+"'
		cQuery += " 	INNER JOIN(SELECT * FROM UDBP12.SF2030 )SF2  ON SF2.D_E_L_E_T_ = ' ' AND SF2.F2_DOC = D1_NFORI AND SF2.F2_SERIE = D1_SERIORI AND SF2.F2_FILIAL = SD1.D1_FILIAL
		cQuery += " WHERE  SD1.D_E_L_E_T_ = ' '
		cQuery += "  AND SF2.F2_VEND1   = '"+_cxven+"'
		cQuery += " AND SD1.D1_CF IN ('1201','1202','1410','1411','2201','2202','2410','2411','2203','1918','2918','3201','3202','3211','2204')
		cQuery += " AND (SD1.D1_FILIAL = '02' OR SD1.D1_FILIAL = '01')
		cQuery += " AND SUBSTR(SD1.D1_EMISSAO,1,6) BETWEEN '"+MV_PAR04+MV_PAR03+"' AND '"+MV_PAR06+MV_PAR05+"'
		cQuery += "  ),0))
		cQuery += '  "QTD_DEV"

		cQuery += "   ,sum(NVL((	SELECT NVL(SUM(D1_TOTAL-SD1.D1_VALIMP5-SD1.D1_VALIMP6-SD1.D1_VALICM),0)
		cQuery += '	"TOTAL"
		cQuery += " FROM  "+RetSqlName("SD1")+"  SD1 "
		cQuery += " INNER JOIN(SELECT * FROM   "+RetSqlName("SA1")+" )SA1 "
		cQuery += " ON SA1.D_E_L_E_T_ = ' '
		cQuery += " AND SD1.D1_TIPO = 'D'
		cQuery += " AND SA1.A1_COD = SD1.D1_FORNECE
		cQuery += " AND SA1.A1_LOJA = SD1.D1_LOJA
		cQuery += " AND SA1.A1_FILIAL = '  '
		//cQuery += "  AND SA1.A1_VEND   = '"+_cxven+"'
		cQuery += " 	INNER JOIN(SELECT * FROM "+RetSqlName("SF2")+" )SF2  ON SF2.D_E_L_E_T_ = ' ' AND SF2.F2_DOC = D1_NFORI AND SF2.F2_SERIE = D1_SERIORI AND SF2.F2_FILIAL = SD1.D1_FILIAL
		cQuery += " WHERE  SD1.D_E_L_E_T_ = ' '
		cQuery += "  AND SF2.F2_VEND1   = '"+_cxven+"'
		cQuery += " AND SD1.D1_CF IN ('1201','1202','1410','1411','2201','2202','2410','2411','2203','1918','2918','3201','3202','3211','2204')
		cQuery += " AND (SD1.D1_FILIAL = '02' OR SD1.D1_FILIAL = '01')
		cQuery += " AND SUBSTR(SD1.D1_EMISSAO,1,6) BETWEEN '"+MV_PAR04+MV_PAR03+"' AND '"+MV_PAR06+MV_PAR05+"'
		cQuery += "  ),0))
		cQuery += " + "
		cQuery += "   sum(NVL((	SELECT NVL(SUM(D1_TOTAL-SD1.D1_VALIMP5-SD1.D1_VALIMP6-SD1.D1_VALICM),0)
		cQuery += '	"TOTAL"
		cQuery += " FROM UDBP12.SD1030 SD1 "
		cQuery += " INNER JOIN(SELECT * FROM UDBP12.SA1030 )SA1 "
		cQuery += " ON SA1.D_E_L_E_T_ = ' '
		cQuery += " AND SD1.D1_TIPO = 'D'
		cQuery += " AND SA1.A1_COD = SD1.D1_FORNECE
		cQuery += " AND SA1.A1_LOJA = SD1.D1_LOJA
		cQuery += " AND SA1.A1_FILIAL = '  '
		//cQuery += "  AND SA1.A1_VEND   = '"+_cxven+"'
		cQuery += " 	INNER JOIN(SELECT * FROM UDBP12.SF2030 )SF2  ON SF2.D_E_L_E_T_ = ' ' AND SF2.F2_DOC = D1_NFORI AND SF2.F2_SERIE = D1_SERIORI AND SF2.F2_FILIAL = SD1.D1_FILIAL
		cQuery += " WHERE  SD1.D_E_L_E_T_ = ' '
		cQuery += "  AND SF2.F2_VEND1   = '"+_cxven+"'
		cQuery += " AND SD1.D1_CF IN ('1201','1202','1410','1411','2201','2202','2410','2411','2203','1918','2918','3201','3202','3211','2204')
		cQuery += " AND (SD1.D1_FILIAL = '02' OR SD1.D1_FILIAL = '01')
		cQuery += " AND SUBSTR(SD1.D1_EMISSAO,1,6) BETWEEN '"+MV_PAR04+MV_PAR03+"' AND '"+MV_PAR06+MV_PAR05+"'
		cQuery += "  ),0))
		cQuery += '  "QTD_TOTAL"

		cQuery += "  FROM  "+RetSqlName("SA3")+"  SA3 "
		cQuery += "  WHERE SA3.D_E_L_E_T_ = ' '
		cQuery += "  AND   SA3.A3_FILIAL  =  '"+xFilial("SBM")+"'"
		cQuery += "  AND   SA3.A3_COD     = '"+_cxven+"'
		//	cQuery += "  AND   SA3.A3_XBLQ    <> '1'

	EndIf

	cQuery := ChangeQuery(cQuery)

	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

Return()



