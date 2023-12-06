#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

#DEFINE CR    chr(13)+chr(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STWFR8A   ºAutor  ³Richard N Cabral    º Data ³  16/03/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relatorio Variaveis de Comissoes - RH                       º±±
±±º          ³                                                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Caso seja necessario alterar as regras deste relatorio	   º±±
±±			   Por favo alterar tambem no RSTFAT21.prw e RSTFAT18.prw      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

_cVar := Codigo do Vendedor

*/
*-----------------------------*
User Function STWFR8A(_cVar)
	*-----------------------------*
	Local nX	:= 0
	Local nDev	:= 0
	Local nPosPerc := 0
	Local nVend		:= 0
	Private cPerg 			:= "STGPE004"
	Private cTime           := Time()
	Private cHora           := SUBSTR(cTime, 1, 2)
	Private cMinutos    	:= SUBSTR(cTime, 4, 2)
	Private cSegundos   	:= SUBSTR(cTime, 7, 2)
	Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos
	Private cPergTit 		:= cAliasLif
	Private aDevol			:= {}
	Private aGrProd			:= {}
	Private aTabPerc		:= {}
	Private nMinAting		:= GetMv("ST_MINATG",,60)
	Private nMaxAting		:= GetMv("ST_MAXATG",,140)
	Private nMinAtingI		:= GetMv("ST_MINATGI",,70)
	Private nMaxAtingI		:= GetMv("ST_MAXATGI",,130)
	Private aVend			:= {}
	Private aVendMeta		:= {}
	Private nPosVend		:= 0
	Private nColVal			:= Len(aGrProd) * 4 + 14
	Private aDados[99]

	MontaTab()

	Devol()

	Processa({|| StQuery() },"Compondo Relatorio")

	DbSelectArea(cAliasLif)
	(cAliasLif)->(DbGoTop())
	If  Select(cAliasLif) > 0

		aVend := {}
		nFatur	:= 0
		cVendBase := ""
		Do While (cAliasLif)->(!Eof())

			nPosVend := aScan(aVend,{|x| x[2] = (cAliasLif)->F2_VEND1})
			cVendBase := (cAliasLif)->F2_VEND1
			If Empty(nPosVend)
				aAdd(aVend,{"",(cAliasLif)->F2_VEND1,"","",Array(nColVal)})
				nPosVend := Len(aVend)
				For nX := 5 to Len(aVend[nPosVend,5])
					aVend[nPosVend,5,nX] := 0
				Next nX
			EndIf

			If aScan(aVendMeta,aVend[nPosVend,2]) = 0
				Aadd(aVendMeta,aVend[nPosVend,2])

				ApuraMeta(aVend[nPosVend,2])

			EndIf

			//>>Realizado

			If (cAliasLif)->TPVEND1 = "I" // (cAliasLif)->F2_VEND1 = (cAliasLif)->F2_VEND2 .AND. (cAliasLif)->TPVEND1 = "I"
				aVend[nPosVend,5,06] += (cAliasLif)->FATUR_INTERNO //nFatur
				aVend[nPosVend,5,10] += (cAliasLif)->FATUR_EXTERNO //nFatur
				aVend[nPosVend,5,14] += (cAliasLif)->CAPTACAO //nFatur
			Else
				aVend[nPosVend,5,10] += (cAliasLif)->FATUR_EXTERNO //nFatur
			EndIf
			//<< Realizado
			(cAliasLif)->(dbskip())
		EndDo

		(cAliasLif)->(dbCloseArea())


		For nDev := 1 to Len(aDevol)

			nPosVd := aScan(aVend,{|x| x[2] = aDevol[nDev,1]})

			If ! Empty(nPosVd)

				If SubStr(aVend[nPosVd,2],1,1) == "I"
					aVend[nPosVd,5,06] -= aDevol[nDev,2]
				Else
					aVend[nPosVd,5,10] -= aDevol[nDev,2]
				EndIf
			EndIf
		Next nDev

		SA3->(DbSetOrder(1))
		For nVend := 1 to Len(aVend)
			SA3->(DbSeek(xFilial("SA3")+aVend[nVend,2]))

			nMinAting := 0
			nMaxAting := 0

			aVend[nVend,1] :=  SA3->A3_XSEGVEN
			aVend[nVend,2] :=  SA3->A3_COD
			aVend[nVend,3] :=  SA3->A3_NUMRA
			aVend[nVend,4] :=  SA3->A3_NOME

			If aVend[nVend,1] $ "IN#in#In#iN"

				nMinAting	:= GetMv("ST_MINATGI",,70)
				nMaxAting	:= GetMv("ST_MAXATGI",,130)
			Else

				nMinAting	:= GetMv("ST_MINATG",,60)
				nMaxAting	:= GetMv("ST_MAXATG",,140)

			EndIF

			If aVend[nVend,5,06] > 0 .And. aVend[nVend,5,05] > 0
				aVend[nVend,5,07] := Round(aVend[nVend,5,06] / aVend[nVend,5,05] * 100,0)

				If aVend[nVend,5,07] >= nMinAting
					nPosPerc := aScan(aTabPerc,{|x| x[1] = aVend[nVend,1] .And. x[3] = "I" .And. x[4] = " " .And. x[5] >= Min(aVend[nVend,5,07],nMaxAting) })
					If ! Empty(nPosPerc)
						aVend[nVend,5,08] := aTabPerc[nPosPerc,6]
						aVend[nVend,5,Len(aVend[nVend,5])] += If(aTabPerc[nPosPerc,6] < 0,0,aTabPerc[nPosPerc,6])
					EndIf
				EndIf

			EndIf

			If aVend[nVend,5,10] > 0 .And. aVend[nVend,5,09] > 0
				aVend[nVend,5,11] :=  Round(aVend[nVend,5,10] / aVend[nVend,5,09] * 100,0)
				If aVend[nVend,5,11] >= nMinAting
					nPosPerc := aScan(aTabPerc,{|x| x[1] = aVend[nVend,1] .And. x[3] = "E" .And. x[4] = " " .And. x[5] >= Min(aVend[nVend,5,11],nMaxAting) })
					If ! Empty(nPosPerc)
						aVend[nVend,5,12] := aTabPerc[nPosPerc,6]
						aVend[nVend,5,Len(aVend[nVend,5])] += If(aTabPerc[nPosPerc,6] < 0 ,0 , aTabPerc[nPosPerc,6] )
					EndIf
				EndIf
			EndIf

		Next nVend

		aSort(aVend,,,{ |x,y| x[1] + x[4] < y[1] + y[4] })
		lFirst := .T.
		nSegm := ""
		For nVend := 1 to Len(aVend)

			If ! Empty(aVend[nVend,1])

				If aVend[nVend,2] == _cVar

					For nX := 1 to Len(aVend[nVend,5])
						aDados[nX]	:=  If(nX <= 4, aVend[nVend,nX],If(aVend[nVend,5,nX]<0,0,aVend[nVend,5,nX]))
					Next nX

				EndIf
			EndIf

		Next nVend

	EndIf

	Return aDados

	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
	±±ºPrograma  ³StQuery   ºAutor  ³Richard N Cabral    º Data ³  28/11/17    º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºDesc.     ³ Relatorio Variaveis de Comissoes - RH                       º±±
	±±º          ³                                                             º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºUso       ³ AP                                                          º±±
	±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	*/
	*-----------------------------*
Static Function StQuery()
	*-----------------------------*

	Local cQuery := ' '
	Local _dRef			:= date()
	Local cDtIni := Substr(Dtos(_dRef),1,4)+Substr(Dtos(_dRef),5,2)+"01"
	Local cDtFim := DtoS(LastDay(StoD(cDtIni)))

	cQuery := " SELECT * FROM ( " + CR
	cQuery += " SELECT  SA3.A3_COD AS F2_VEND1, " + CR
	cQuery += "         SA3.A3_XSEGVEN, " + CR
	cQuery += " 		SA3.A3_TPVEND TPVEND1, " + CR
	cQuery += "         SUM(CASE WHEN SF2.F2_VEND1 <> SF2.F2_VEND2 THEN SF2.F2_VALBRUT -SF2.F2_VALICM-SF2.F2_VALIMP5-SF2.F2_VALIMP6 ELSE 0 END)	AS FATUR_EXTERNO, " + CR
	cQuery += "         COALESCE(    (SELECT SUM(SD2.D2_TOTAL-SD2.D2_VALICM-SD2.D2_VALIMP5-SD2.D2_VALIMP6-D2_DIFAL-D2_ICMSCOM) AS TOTAL         " + CR
	cQuery += "                             FROM  "+RetSqlName("SF2")+" SF2 " + CR
	cQuery += "                             INNER JOIN(SELECT * FROM "+ RetSqlName("SD2")+" ) SD2 " + CR
	cQuery += "                                 ON        SD2.D_E_L_E_T_ <> '*'        " + CR
	cQuery += "                                 AND SD2.D2_FILIAL = SF2.F2_FILIAL        " + CR
	cQuery += "                                 AND SD2.D2_DOC = SF2.F2_DOC         " + CR
	cQuery += "                                 AND SD2.D2_SERIE = SF2.F2_SERIE        " + CR
	cQuery += "                                 AND SD2.D2_CF IN('5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5403','5501','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6501','6502','7101','7102') 	   " + CR
	cQuery += "                                 WHERE F2_EMISSAO BETWEEN '" + cDtIni + "' AND '" + cDtFim + "'         " + CR
	cQuery += "                                     AND SF2.D_E_L_E_T_ <> '*'        " + CR
	cQuery += "                 AND SF2.F2_VEND1 = SA3.A3_COD        " + CR
	cQuery += "                 AND EXISTS            " + CR
	cQuery += "                     (SELECT * FROM "+RetSqlName("SC6")+" SC6            " + CR
	cQuery += "                             WHERE  SC6.C6_NUM = SD2.D2_PEDIDO            " + CR
	cQuery += "                             AND SC6.C6_FILIAL = SD2.D2_FILIAL            AND SC6.D_E_L_E_T_ <> '*' )  ),0) AS FATUR_INTERNO, " + CR

	cQuery += " ROUND( COALESCE( " + CR
    cQuery += "       (SELECT " + CR
    cQuery += "               SUM(CASE WHEN C6_BLQ = 'R' THEN (C6_ZVALLIQ/C6_QTDVEN)*C6_QTDENT ELSE C6_ZVALLIQ END) AS VALOR " + CR
    cQuery += "               FROM "+RetSqlName("SC6")+" SC6 " + CR
    cQuery += "                   INNER JOIN (SELECT * FROM "+RetSqlName("SB1")+" ) SB1 ON SB1.D_E_L_E_T_ = ' ' AND SB1.B1_COD = SC6.C6_PRODUTO AND SB1.B1_FILIAL = '  ' " + CR
    cQuery += "                   INNER JOIN (SELECT *  FROM  "+RetSqlName("SC5")+" )SC5 ON SC5.D_E_L_E_T_ = ' ' AND SC5.C5_NUM = SC6.C6_NUM AND SC5.C5_FILIAL = SC6.C6_FILIAL AND SC5.C5_EMISSAO BETWEEN '" + cDtIni + "' AND '" + cDtFim + "' " + CR
    cQuery += "                   INNER JOIN(SELECT * FROM "+RetSqlName("SA1")+" ) SA1 ON SA1.D_E_L_E_T_ = ' ' AND SA1.A1_COD = SC5.C5_CLIENTE AND SA1.A1_LOJA = SC5.C5_LOJACLI AND SA1.A1_FILIAL = '  ' " + CR
    cQuery += "                   LEFT JOIN (SELECT *  FROM "+RetSqlName("PC1")+" )PC1 ON C6_NUM = PC1.PC1_PEDREP AND PC1.D_E_L_E_T_ = ' ' " + CR
    cQuery += "                   INNER JOIN (SELECT * FROM "+RetSqlName("SF4")+" ) SF4 ON SC6.C6_TES = SF4.F4_CODIGO AND SF4.D_E_L_E_T_ = ' ' AND SF4.F4_DUPLIC = 'S' " + CR
    cQuery += "               WHERE  SC6.D_E_L_E_T_ = ' ' " + CR
    cQuery += "                   AND SC6.C6_FILIAL = '02' " + CR
    cQuery += "                   AND SC5.C5_TIPO = 'N' " + CR
    cQuery += "                   AND SA1.A1_GRPVEN <> 'ST' " + CR
    cQuery += "                   AND SA1.A1_EST <> 'EX' " + CR
    cQuery += "                   AND PC1.PC1_PEDREP IS NULL " + CR
    cQuery += "                   AND SC5.C5_VEND2 = SA3.A3_COD ),0),2) AS CAPTACAO " + CR

	cQuery += " FROM SF2010 SF2  " + CR
	cQuery += "     INNER JOIN(SELECT * FROM "+RetSqlName("SA1")+") SA1 " + CR
	cQuery += "         ON SA1.D_E_L_E_T_   <> '*' " + CR
	cQuery += "             AND SA1.A1_COD = SF2.F2_CLIENTE " + CR
	cQuery += "             AND SA1.A1_LOJA = SF2.F2_LOJA " + CR
	cQuery += "             AND SA1.A1_FILIAL = ' ' " + CR
	cQuery += "             AND SA1.A1_CGC NOT IN  ('05890658000130','05890658000210','05890658000300','05890658000482','06048486000114','06048486000114','30708667761') " + CR
	cQuery += "     INNER JOIN(SELECT * FROM "+RetSqlName("SA3")+" )SA3  " + CR
	cQuery += "         ON SA3.A3_FILIAL = '  ' " + CR
	cQuery += "             AND SA3.D_E_L_E_T_ <> '*'  " + CR
	cQuery += "             AND (SA3.A3_COD = SF2.F2_VEND1  OR   SA3.A3_COD = SF2.F2_VEND2) " + CR
	cQuery += "             AND SA3.A3_TPVEND = 'I' " + CR
	cQuery += "         WHERE F2_EMISSAO BETWEEN '" + cDtIni + "' AND '" + cDtFim + "' " + CR
	cQuery += "             AND SF2.D_E_L_E_T_ <> '*'  " + CR
	cQuery += "             AND EXISTS ( SELECT * FROM "+RetSqlName("SD2")+" SD2  " + CR
	cQuery += "         INNER JOIN (SELECT * FROM "+RetSqlName("SF4")+" )SF4  " + CR
	cQuery += "             ON  SD2.D2_TES = SF4.F4_CODIGO  " + CR
	cQuery += "                 AND SF4.D_E_L_E_T_ <> '*'  " + CR
	cQuery += "                 AND SD2.D2_CF IN('5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5403','5501','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6501','6502','7101','7102') " + CR
	cQuery += "     WHERE SD2.D2_DOC = SF2.F2_DOC " + CR
	cQuery += "         AND SD2.D2_SERIE = SF2.F2_SERIE " + CR
	cQuery += "         AND SD2.D_E_L_E_T_ <>'*'  AND SD2.D2_FILIAL = SF2.F2_FILIAL ) " + CR
	cQuery += " GROUP BY SA3.A3_COD , A3_XSEGVEN,A3_TPVEND  " + CR
	cQuery += " ORDER BY SA3.A3_COD ) TMP " + CR

	cQuery += " UNION" + CR

	cQuery += " SELECT * FROM ( " + CR
	cQuery += " SELECT F2_VEND1, " + CR
	cQuery += "  SA31.A3_XSEGVEN, " + CR
	cQuery += "  SA31.A3_TPVEND TPVEND1, " + CR
	cQuery += "  SUM(SD2.D2_TOTAL-SD2.D2_VALICM-SD2.D2_VALIMP5-SD2.D2_VALIMP6-SD2.D2_DIFAL-SD2.D2_ICMSCOM) FATUR_INTERNO, " + CR
	cQuery += "  SUM(SD2.D2_TOTAL-SD2.D2_VALICM-SD2.D2_VALIMP5-SD2.D2_VALIMP6-SD2.D2_DIFAL-SD2.D2_ICMSCOM) FATUR_EXTERNO," + CR

	cQuery += " ROUND( COALESCE( " + CR
    cQuery += "       (SELECT " + CR
    cQuery += "               SUM(CASE WHEN C6_BLQ = 'R' THEN (C6_ZVALLIQ/C6_QTDVEN)*C6_QTDENT ELSE C6_ZVALLIQ END) AS VALOR " + CR
    cQuery += "               FROM "+RetSqlName("SC6")+" SC6 " + CR
    cQuery += "                   INNER JOIN (SELECT * FROM "+RetSqlName("SB1")+" ) SB1 ON SB1.D_E_L_E_T_ = ' ' AND SB1.B1_COD = SC6.C6_PRODUTO AND SB1.B1_FILIAL = '  ' " + CR
    cQuery += "                   INNER JOIN (SELECT *  FROM  "+RetSqlName("SC5")+" )SC5 ON SC5.D_E_L_E_T_ = ' ' AND SC5.C5_NUM = SC6.C6_NUM AND SC5.C5_FILIAL = SC6.C6_FILIAL AND SC5.C5_EMISSAO BETWEEN '" + cDtIni + "' AND '" + cDtFim + "' " + CR
    cQuery += "                   INNER JOIN(SELECT * FROM "+RetSqlName("SA1")+" ) SA1 ON SA1.D_E_L_E_T_ = ' ' AND SA1.A1_COD = SC5.C5_CLIENTE AND SA1.A1_LOJA = SC5.C5_LOJACLI AND SA1.A1_FILIAL = '  ' " + CR
    cQuery += "                   LEFT JOIN (SELECT *  FROM "+RetSqlName("PC1")+" )PC1 ON C6_NUM = PC1.PC1_PEDREP AND PC1.D_E_L_E_T_ = ' ' " + CR
    cQuery += "                   INNER JOIN (SELECT * FROM "+RetSqlName("SF4")+" ) SF4 ON SC6.C6_TES = SF4.F4_CODIGO AND SF4.D_E_L_E_T_ = ' ' AND SF4.F4_DUPLIC = 'S' " + CR
    cQuery += "               WHERE  SC6.D_E_L_E_T_ = ' ' " + CR
    cQuery += "                   AND SC6.C6_FILIAL = '02' " + CR
    cQuery += "                   AND SC5.C5_TIPO = 'N' " + CR
    cQuery += "                   AND SA1.A1_GRPVEN <> 'ST' " + CR
    cQuery += "                   AND SA1.A1_EST <> 'EX' " + CR
    cQuery += "                   AND PC1.PC1_PEDREP IS NULL " + CR
    cQuery += "                   AND SC5.C5_VEND1 = SF2.F2_VEND1 ),0),2) AS CAPTACAO " + CR

	cQuery += "  FROM SD2010 SD2 " + CR
	cQuery += "  LEFT JOIN "+RetSqlName("SF2")+" SF2  ON SD2.D2_FILIAL  = SF2.F2_FILIAL AND SD2.D2_DOC = SF2.F2_DOC AND SD2.D2_SERIE = SF2.F2_SERIE AND SF2.D_E_L_E_T_ = ' ' " + CR
	cQuery += "  LEFT JOIN "+RetSqlName("SB1")+" SB1  ON SB1.B1_FILIAL  = '  ' AND SB1.B1_COD = SD2.D2_COD AND SB1.D_E_L_E_T_ = ' ' " + CR
	cQuery += "  INNER JOIN "+RetSqlName("SBM")+" SBM  ON SBM.BM_FILIAL  = ' ' AND SBM.BM_GRUPO = SB1.B1_GRUPO AND SBM.BM_XAGRUP <> ' ' AND SBM.D_E_L_E_T_ = ' ' " + CR
	cQuery += "  LEFT JOIN "+RetSqlName("SA1")+" SA1  ON SA1.A1_FILIAL  = '  ' AND SA1.A1_COD = SF2.F2_CLIENTE AND SA1.A1_LOJA = SF2.F2_LOJA AND SA1.D_E_L_E_T_ = ' '  " + CR
	cQuery += "  LEFT JOIN "+RetSqlName("SA3")+" SA31 ON SA31.A3_FILIAL = '  ' AND SA31.A3_COD = SF2.F2_VEND1 AND SA31.D_E_L_E_T_   = ' ' " + CR
	cQuery += "  WHERE F2_EMISSAO BETWEEN '" + cDtIni + "' AND '" + cDtFim + "' " + CR
	cQuery += "  AND SA1.A1_CGC NOT IN ('05890658000130','05890658000210','05890658000300','05890658000482','06048486000114','06048486000114','30708667761')  " + CR
	cQuery += "  AND SD2.D2_CF IN('5101' , '5102' , '5109' , '5116' , '5117' , '5118' , '5119' , '5122' , '5123' , '5401' , '5403' , '5501' , '5502' , '6101' , '6102' , '6107' , '6108' , '6109' , '6110' , '6111' , '6114' , '6116' , '6117' , '6118' , '6119' , '6122' , '6123' , '6401' , '6403' , '6501' , '6502' , '7101' , '7102')  " + CR
	cQuery += "  AND SA31.A3_XSEGVEN <> 'IN' " + CR
	cQuery += "  AND SD2.D_E_L_E_T_ = ' ' " + CR
	cQuery += "  GROUP BY F2_VEND1,A3_XSEGVEN,A3_TPVEND " + CR
	cQuery += " ORDER BY F2_VEND1) TMP1 " + CR

	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

Return()

Static Function BuscaGrp()

	Local _cQueryGrp	:= ' '
	Local _cAliasGrp	:= GetNextAlias()

	_cQueryGrp := ""
	_cQueryGrp += " SELECT X5_CHAVE CODIGO, X5_DESCRI DESCRICAO FROM " + RetSqlName("SX5") + " SX5 " + CRLF
	_cQueryGrp += " WHERE X5_FILIAL = '" + xFilial("SX5") + "' " + CRLF
	_cQueryGrp += " AND X5_TABELA = 'Z9' " + CRLF
	_cQueryGrp += " AND SX5.D_E_L_E_T_ = ' ' " + CRLF
	_cQueryGrp += " ORDER BY X5_CHAVE " + CRLF
	_cQueryGrp := ChangeQuery(_cQueryGrp)

	TCQUERY _cQueryGrp NEW ALIAS (_cAliasGrp)

	(_cAliasGrp)->(DbGoTop())

	Do While ! (_cAliasGrp)->(Eof())
		aAdd(aGrProd,{Alltrim((_cAliasGrp)->CODIGO),(_cAliasGrp)->DESCRICAO})
		(_cAliasGrp)->(DbSkip())
	EndDo

	(_cAliasGrp)->(DbCloseArea())

Return

Static Function Devol()

	Local _cQueryDev	:= ' '
	Local _cAliasDev	:= GetNextAlias()
	Local cDtIni		:= Substr(Dtos(date()),1,4)+Substr(Dtos(date()),5,2)+"01"
	Local cDtFim		:= DtoS(LastDay(StoD(cDtIni)))

	_cQueryDev := ""
	_cQueryDev += " SELECT F2_VEND1,  SUM(D1_TOTAL - D1_VALIMP5 - D1_VALIMP6 - D1_VALICM) DEVOL FROM ( " + CRLF
	_cQueryDev += " SELECT D2_FILIAL, F2_VEND1, D2_DOC, D2_SERIE, D2_ITEM, D2_COD, D2_EMISSAO, D2_TOTAL, D2_QUANT, D1_EMISSAO, D1_ITEMORI, D1_COD, D1_NFORI, D1_SERIORI, D1_QUANT, D1_TOTAL, D1_VALIMP5, D1_VALIMP6, D1_VALICM " + CRLF
	_cQueryDev += " FROM " + RetSqlName("SD1") + " SD1 " + CRLF
	_cQueryDev += " LEFT OUTER JOIN " + RetSqlName("SD2") + " SD2 " + CRLF
	_cQueryDev += " ON D1_FILIAL = D2_FILIAL  " + CRLF
	_cQueryDev += " AND D2_DOC = D1_NFORI  " + CRLF
	_cQueryDev += " AND D2_SERIE = D1_SERIORI  " + CRLF
	_cQueryDev += " AND D2_ITEM = D1_ITEMORI  " + CRLF
	_cQueryDev += " AND D1_EMISSAO BETWEEN '" + cDtIni + "' AND '" + cDtFim + "' " + CRLF
	_cQueryDev += " AND SD2.D_E_L_E_T_ = ' ' " + CRLF
	_cQueryDev += " INNER JOIN " + RetSqlName("SF2") + " SF2 ON SD2.D2_FILIAL = SF2.F2_FILIAL AND SD2.D2_DOC = SF2.F2_DOC AND SD2.D2_SERIE = SF2.F2_SERIE AND SF2.D_E_L_E_T_ = ' ' " + CRLF
	_cQueryDev += " WHERE (SD1.D1_FILIAL = '01' OR SD1.D1_FILIAL = '02') " + CRLF
	_cQueryDev += " AND D1_TIPO = 'D' " + CRLF
	_cQueryDev += " AND SD1.D1_CF IN ('1201','1202','1410','1411','2201','2202','2410','2411','2203','1918','2918','3201','3202','3211','2204') " + CRLF
	_cQueryDev += " AND SD1.D_E_L_E_T_ = ' '  " + CRLF
	_cQueryDev += " ) TAB " + CRLF
	_cQueryDev += " GROUP BY F2_VEND1 " + CRLF
	_cQueryDev += " ORDER BY F2_VEND1 " + CRLF

	TCQUERY _cQueryDev NEW ALIAS (_cAliasDev)

	(_cAliasDev)->(DbGoTop())

	Do While ! (_cAliasDev)->(Eof())
		aAdd(aDevol,{Alltrim((_cAliasDev)->F2_VEND1),(_cAliasDev)->DEVOL})
		(_cAliasDev)->(DbSkip())
	EndDo

	(_cAliasDev)->(DbCloseArea())

Return

Static Function MontaTab()

	Local _cQueryPer	:= ' '
	Local _cAliasPer	:= GetNextAlias()
	Local cDtIni		:= Substr(Dtos(date()),1,4)+Substr(Dtos(date()),5,2)+"01"

	_cQueryPer := ""
	_cQueryPer += " SELECT * FROM " + RetSqlName("SZG") + " SZG " + CRLF
	_cQueryPer += " INNER JOIN " + RetSqlName("SZL") + " SZL ON ZL_FILIAL = '" + xFilial("SZL") + "' AND SZL.ZL_CODTAB = SZG.ZG_CODTAB AND SZL.D_E_L_E_T_ = ' ' " + CRLF
	_cQueryPer += " WHERE ZG_FILIAL = '" + xFilial("SZG") + "' " + CRLF
	_cQueryPer += " AND ZL_VIGDE <= '" + cDtIni + "' " + CRLF
	_cQueryPer += " AND ZL_VIGATE >= '" + cDtIni + "' " + CRLF
	_cQueryPer += " AND SZG.D_E_L_E_T_ = ' ' " + CRLF
	_cQueryPer += " ORDER BY ZG_CODTAB, ZG_TPFAT, ZG_LINHA, ZG_PCATIG " + CRLF
	_cQueryPer := ChangeQuery(_cQueryPer)

	TCQUERY _cQueryPer NEW ALIAS (_cAliasPer)

	(_cAliasPer)->(DbGoTop())

	Do While ! (_cAliasPer)->(Eof())
		aAdd(aTabPerc,{(_cAliasPer)->ZL_SEGMVD,(_cAliasPer)->ZG_CODTAB,(_cAliasPer)->ZG_TPFAT,(_cAliasPer)->ZG_LINHA,(_cAliasPer)->ZG_PCATIG,(_cAliasPer)->ZG_PERCCOM})
		(_cAliasPer)->(DbSkip())
	EndDo

	(_cAliasPer)->(DbCloseArea())

Return

Static Function ApuraMeta(cVendMeta)

	Local nPosAgrup := 0
	Local _cQry		:= ""
	Local _cMesAno	:= Substr(Dtos(date()),5,2)+Substr(Dtos(date()),1,4) //SubStr(Dtos(_dRef),5,2)+SubStr(Dtos(_dRef),1,4)
	Local _cMesIni	:= Val(SubStr(_cMesAno,1,2))-3
	Local _cMesFim	:= Val(SubStr(_cMesAno,1,2))-1
	Local _cAnoIni 	:= Val(SubStr(_cMesAno,3,4))
	Local _cAnoFim 	:= Val(SubStr(_cMesAno,3,4))


	If Substr(cVendMeta,1,1) == "I"  //Calcula Meta do Vendedor Interno conforme relatorio base RSFAT21

		If Val(SubStr(_cMesAno,1,2)) = 1

			_cMesIni := 10
			_cMesFim := 12
			_cAnoIni := _cAnoIni -1
			_cAnoFim := _cAnoFim -1

		ElseIf Val(SubStr(_cMesAno,1,2)) = 2

			_cMesIni := 11
			_cMesFim := 1
			_cAnoIni := _cAnoIni -1

		ElseIf Val(SubStr(_cMesAno,1,2)) = 3

			_cMesIni := 12
			_cMesFim := 2
			_cAnoIni := _cAnoIni -1

		EndIf

		_cQry		:= " SELECT MED.*,MED.EXTERNO/3 MEDEXT, MED.INTERNO/3 MEDINT FROM ( "
		_cQry		+= " SELECT SA3.A3_COD CODIGO,SA3.A3_NOME NOME, "
		_cQry		+= " 	SUM(CASE WHEN SF2.F2_VEND1 <> SF2.F2_VEND2 THEN SF2.F2_VALBRUT -SF2.F2_VALICM-SF2.F2_VALIMP5-SF2.F2_VALIMP6 ELSE 0 END) EXTERNO, "
		_cQry		+= " 	SUM(CASE WHEN SA3.A3_COD = SF2.F2_VEND1 THEN SF2.F2_VALBRUT -SF2.F2_VALICM-SF2.F2_VALIMP5-SF2.F2_VALIMP6 ELSE 0 END) INTERNO "
		_cQry		+= " FROM "+RetSqlName("SF2")+" SF2 "
		_cQry		+= " 	    INNER JOIN(SELECT * FROM "+RetSqlName("SA1")+" )  SA1 "
		_cQry		+= " 			ON SA1.D_E_L_E_T_ = ' ' "
		_cQry		+= " 			AND SA1.A1_COD = SF2.F2_CLIENTE "
		_cQry		+= " 			AND SA1.A1_LOJA = SF2.F2_LOJA "
		_cQry		+= " 			AND SA1.A1_FILIAL = '"+ xFilial("SA1") +"' "
		_cQry		+= " 			AND SA1.A1_CGC NOT IN ('05890658000130' , '05890658000210' , '05890658000300' , '05890658000482' , '06048486000114' , '06048486000114' , '30708667761') "
		_cQry		+= "	    INNER JOIN(SELECT *  FROM  "+RetSqlName("SA3")+" )SA3 "
		_cQry		+= "			ON SA3.A3_FILIAL = '  ' "
		_cQry		+= "			AND SA3.D_E_L_E_T_ = ' ' "
		_cQry		+= "			AND (SA3.A3_COD = SF2.F2_VEND1 OR SA3.A3_COD = SF2.F2_VEND2)  "
		_cQry		+= "			AND SA3.A3_TPVEND = 'I' "
		_cQry		+= "	WHERE  SubStr(F2_EMISSAO,1,6) BETWEEN '"+StrZero(_cAnoIni,4)+ StrZero(_cMesIni,2)+"' AND '"+StrZero(_cAnoFim,4)+StrZero(_cMesFim,2)+"' "
		_cQry		+= "		AND SF2.D_E_L_E_T_ = ' ' "
		_cQry		+= "		AND (SF2.F2_VEND1 = '"+cVendMeta+"' OR SF2.F2_VEND2 = '"+cVendMeta+"' ) "
		_cQry		+= "		AND EXISTS (SELECT * FROM "+RetSqlName("SD2")+" SD2 "
		_cQry		+= "						INNER JOIN (SELECT * FROM "+RetSqlName("SF4")+" ) SF4 "
		_cQry		+= "							ON SD2.D2_TES = SF4.F4_CODIGO "
		_cQry		+= "							AND SF4.D_E_L_E_T_ = ' ' "
		_cQry		+= "							AND SD2.D2_CF IN('5101' , '5102' , '5109' , '5116' , '5117' , '5118' , '5119' , '5122' , '5123' , '5401' , '5403' , '5501' , '5502' , '6101' , '6102' , '6107' , '6108' , '6109' , '6110' , '6111' , '6114' , '6116' , '6117' , '6118' , '6119' , '6122' , '6123' , '6401' , '6403' , '6501' , '6502' , '7101' , '7102') "
		_cQry		+= " WHERE  SD2.D2_DOC = SF2.F2_DOC "
		_cQry		+= "	AND SD2.D2_SERIE = SF2.F2_SERIE "
		_cQry		+= "	AND SD2.D_E_L_E_T_ = ' ' "
		_cQry		+= "	AND SD2.D2_FILIAL = SF2.F2_FILIAL )  "
		_cQry		+= " GROUP BY SA3.A3_COD , SA3.A3_NOME  ) MED "
		_cQry		+= " WHERE MED.CODIGO = '"+cVendMeta+"' "

		_cQry := ChangeQuery(_cQry)

		If Select("TRB") > 0
			TRB->(dbCloseArea())
		EndIf

		dbUseArea(.T.,'TOPCONN',TcGenQry(,,_cQry),"TRB")

		ZZD->(DbSetOrder(1))
		If ZZD->(DbSeek(xFilial("ZZD") + Substr(_cMesAno,1,2) + Substr(_cMesAno,3,4) + cVendMeta))

			Do While ZZD->ZZD_FILIAL + ZZD->ZZD_MES + ZZD->ZZD_ANO + ZZD->ZZD_VEND = xFilial("ZZD") + Substr(_cMesAno,1,2) + Substr(_cMesAno,3,4) + cVendMeta .And. ! ZZD->(Eof())

				aVend[nPosVend,5,05] += ZZD->ZZD_VALOR

				ZZD->(DbSkip())
			EndDo

		Else
			aVend[nPosVend,5,05] += Iif( TRB->MEDINT < 10000,10000,TRB->MEDINT)  //Interno
		EndIf

		aVend[nPosVend,5,09] += Iif( TRB->MEDEXT < 200000,200000,TRB->MEDEXT)  //Exteno

	Else

		ZZD->(DbSetOrder(1))
		ZZD->(DbSeek(xFilial("ZZD") + Substr(_cMesAno,1,2) + Substr(_cMesAno,3,4) + cVendMeta))

		Do While ! ZZD->(Eof()) .And. ZZD->ZZD_FILIAL + ZZD->ZZD_MES + ZZD->ZZD_ANO + ZZD->ZZD_VEND = xFilial("ZZD") + Substr(_cMesAno,1,2) + Substr(_cMesAno,3,4) + cVendMeta

			aVend[nPosVend,5,05] += ZZD->ZZD_VLRCAR //Meta Interno
			aVend[nPosVend,5,09] += ZZD->ZZD_VALOR// Meta Externo

			ZZD->(DbSkip())

		EndDo

	EndIf

Return

