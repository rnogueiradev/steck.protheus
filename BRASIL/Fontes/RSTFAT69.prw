#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  RSTFAT69     ºAutor  ³Giovani Zago    º Data ³  03/06/15     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Relatorio Metas	P/ SUPERVISOR	                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RSTFAT69()

	Local   oReport
	Private cPerg 			:= "RFAT69"
	Private cTime           := Time()
	Private cHora           := SUBSTR(cTime, 1, 2)
	Private cMinutos    	:= SUBSTR(cTime, 4, 2)
	Private cSegundos   	:= SUBSTR(cTime, 7, 2)
	Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos
	Private lXlsHeader      := .f.
	Private lXmlEndRow      := .f.
	Private cPergTit 		:= cAliasLif
	Private lret            := .T.
	Private _cVenTp			:= ""
	Private _aVend          := {}
	Private _aVend2         := {}
	Private _lGeren         := .F.
	Private _lSuper         := .F.

	PutSx1( cPerg, "01","Relatorio:"		,"","","mv_ch1","C",1,0,0,"C","","","","","mv_par01","1-ANALITICO","","","","1-ANALITICO","","","","","","","","","","","")
	PutSx1( cPerg, "02","Vendedor:"			,"","","mv_ch2","C",6,0,0,"G","Empty(mv_par02) .OR. (existcpo('SA3',mv_par02))","SA3","","","mv_par02","","","","","","","","","","","","","","","","")
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
	Local aDados1[99]
	Local aDados2[10]
	Local n01:=n02:=n03:=n04:=n05:=n06:=0
	Local nt01:=nt02:=nt03:=nt04:=nt05:=nt06:=0
	Local _cSec2  := ' '
	Local l		:= 0
	Local _RSTFAT69	:= GetMv('ST_STFAT69',,'000391#000380#000378#000366#000294#000678#000645#000000#000231') //Parametro para informar o codigos dos supervisores e gerentes de vendas.

	If Mv_Par01 = 1
		TRCell():New(oSection1,"Area"		,,"Area"		,,6,.F.,)
		TRCell():New(oSection1,"Nome" 		,,"Supervisor"	,,30,.F.,)
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

	If Mv_Par01 = 1
		oSection1:Cell("Area")    	:SetBlock( { || aDados1[11] } )
		oSection1:Cell("Nome")    	:SetBlock( { || aDados1[12] } )
	EndIf


	oReport:SetMeter(0)
	aFill(aDados,nil)
	aFill(aDados1,nil)

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

					If SA3->A3_CODUSR == __cUserId

						_cVenTp   := SA3->A3_COD
						aadd(_aVend,{SA3->A3_COD,SA3->A3_NOME}  )

					ElseIf __cUserId $ _RSTFAT69

						_cVenTp   := SA3->A3_COD
						aadd(_aVend,{SA3->A3_COD,SA3->A3_NOME}  )


					Else

						MSGSTOP( "Este não é o seu codigo de vendedor!!!", "Atenção" )

					EndIf

				EndIf
			Else // extreno vera apenas o seu codigo e os clientes amarrados a ele
				_cVenTp       := SA3->A3_COD
				aadd(_aVend,{SA3->A3_COD,SA3->A3_NOME}  )
			EndIf
		EndIf
	EndIf

	If len(_aVend) > 0
		For l:=1 to  len(_aVend)

			//dbSelectArea("SBM") old
			//SBM->(dbgotop()) old

			//	While 	SBM->(!Eof()) old
			oSection1:Init()
			oReport:SetMeter(77)
			//If	SBM->BM_XAGRUP <> ' '

			Processa({|| StVenQuery(_aVend[l,1],SBM->BM_GRUPO) },"Compondo Relatorio")

			// old StVenQuery(_aVend[l,1],SBM->BM_GRUPO)

			dbSelectArea(cAliasLif)
			(cAliasLif)->(dbgotop())
			If  Select(cAliasLif) > 0

				While 	(cAliasLif)->(!Eof())

					aFill(aDados1,nil)
					n01+=   (cAliasLif)->OBJETIVO
					n02+=	(cAliasLif)->QTD_OBJETIVO
					n03+=	(cAliasLif)->CAPTACAO
					n04+=	(cAliasLif)->QTD_CAPTACAO
					n05+=   ((cAliasLif)->FATURAMENTO - (cAliasLif)->QTD_TOTAL)
					n06+=   (cAliasLif)->QTD_FATURAMENTO - (cAliasLif)->QTD_DEV


					//	(cAliasLif)->(dbskip()) old

					// End old

					If Mv_Par01 = 1   //.And. (	n01+n02+n03+n04+n05+n06 ) > 0
						//**************************** TOTAIS  ****************************************
						aDados1[01]	:=  (cAliasLif)->GRUPO //SBM->BM_GRUPO
						aDados1[02]	:=  (cAliasLif)->DESCRICAO //SBM->BM_DESC
						aDados1[03]	:=  n01
						aDados1[04]	:=  n02
						aDados1[05]	:=	n03
						aDados1[06]	:=  n04
						aDados1[07]	:=	(n03*100)/n01
						aDados1[08]	:=	n05
						aDados1[09]	:=	n06
						aDados1[10]	:=	(n05*100)/n01
						If Mv_Par01 = 1
							aDados1[11]	:=	 _aVend[l,1]
							aDados1[12]	:=	Alltrim(Posicione("SA3",1,xFilial("SA3")+_aVend[l,1] ,"A3_SUPER"))
						EndIf
						oSection1:PrintLine()
						aFill(aDados1,nil)

						//**************************************************************************

						n01:=n02:=n03:=n04:=n05:=n06:=0

					EndIf

					(cAliasLif)->(dbskip())

				End

			EndIf
			//EndIf
			oReport:IncMeter()


			//SBM->(dbskip()) old
			// End old

		Next l
	EndIf

	n01:=n02:=n03:=n04:=n05:=n06:=0
	oReport:SkipLine()

	oSection1:Finish()
	oReport:IncMeter()

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


Static Function StVenQuery(_cxven,_cGrp)

	Local cQuery     := ' '

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
	cQuery += '   "QTD_CAPTACAO",

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
	cQuery += '  "QTD_TOTAL"


	cQuery += "  FROM  "+RetSqlName("SBM")+"  SBM "
	cQuery += "  WHERE SBM.D_E_L_E_T_ = ' '
	//	cQuery += "  AND   SBM.BM_FILIAL  =  '"+xFilial("SBM")+"'   AND SBM.BM_GRUPO = '"+_cGrp+"'"
	cQuery += "  AND   SBM.BM_FILIAL  =  '"+xFilial("SBM")+"'   AND SBM.BM_XAGRUP <> ' ' " //Chamado 008219


	//cQuery := ChangeQuery(cQuery)

	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

Return()

/*
Verifico se é supervisor
*/
Static Function VerSuper(cVend)

	Local _cQry := ""
	Local _cRet := ""

	If Select("TRD") > 0
		TRD->(DbCloseArea())
	Endif

	_cQry := " "
	_cQry += " SELECT DISTINCT C5_CLIENT,C5_LOJAENT FROM "+RetSqlName("SC5") "
	_cQry += " WHERE C5_NUM = '" + StrTran(cPedido,",","") +"' "
	_cQry += " AND D_E_L_E_T_ = ' ' "

	TcQuery _cQry New Alias "TRD"

	TRD->(dbGoTop())

	_cRet := TRD->C5_CLIENT


Return(_cRet)


