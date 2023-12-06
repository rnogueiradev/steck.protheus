#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTGPE009   บAutor  ณRichard N Cabral    บ Data ณ  16/03/18   บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Relatorio Variaveis de Comissoes - RH                       บฑฑ
ฑฑบ          ณ                                                             บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Caso seja necessario alterar as regras deste relatorio	   บฑฑ
ฑฑ			   Por favo alterar tambem no RSTFAT21.prw e RSTFAT18.prw      บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*-----------------------------*
User Function STGPE009()		//U_STGPE009()
	*-----------------------------*
	Local   oReport
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

	U_STPutSx1( cPerg, "01","M๊s/Ano:","MV_PAR01","mv_ch1","C",06,0,"G","U_GP04MAno(MV_PAR01)","","@R 99/9999")

	Pergunte(cPerg,.F.)

	//BuscaGrp()

	oReport	:= ReportDef()
	oReport:PrintDialog()

	Return

	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	ฑฑษออออออออออัอออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
	ฑฑบPrograma  ณReportDef  บAutor  ณRichard N Cabral    บ Data ณ  16/03/18   บฑฑ
	ฑฑฬออออออออออุอออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
	ฑฑบDesc.     ณ Relatorio Variaveis de Comissoes - RH                       บฑฑ
	ฑฑบ          ณ                                                             บฑฑ
	ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
	ฑฑบUso       ณ AP                                                          บฑฑ
	ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
	*/
	*-----------------------------*
Static Function ReportDef()
	*-----------------------------*
	Local oReport
	Local oSection2
	Local nGrp		:= 0

	oReport := TReport():New(cPergTit,"Relatorio de Variแveis de Comiss๕es - RH",cPerg,{|oReport| ReportPrint(oReport)},"Este programa irแ imprimir o relat๓rio de Variแveis de Comiss๕es - RH")

	oSection1 := TRSection():New(oReport,"Segmentos",{cAliasLif})
	TRCell():New(oSection1,"SEGMENTO"					,,"Segmento Vendedor"		,"@!"					,30,.F.,)

	oSection1:SetHeaderSection(.T.)
	oSection1:SetHeaderBreak(.T.)

	oSection2 := TRSection():New(oSection1,"Comiss๕es",{cAliasLif})
	TRCell():New(oSection2,"VENDEDOR"					,,"Vendedor"					,"@!"					,06,.F.,)
	TRCell():New(oSection2,"MATRICUL"					,,"Matricula"					,"@!"					,06,.F.,)
	TRCell():New(oSection2,"NOME"						,,"Nome Vendedor"				,"@!"					,30,.F.,)

	TRCell():New(oSection2,"METAFATINT"					,,"Meta Fatur.Interno"			,"@E 999,999,999.99"	,20,.F.,)
	TRCell():New(oSection2,"REALFATINT"					,,"Realizado Fatur.Interno"		,"@E 999,999,999.99"	,20,.F.,)
	TRCell():New(oSection2,"PCATFATINT"					,,"% Atingido Fatur.Interno"	,"@E 999,999,999.99"	,20,.F.,)
	TRCell():New(oSection2,"PCCMFATINT"					,,"% Comissใo Fatur.Interno"	,"@E 999,999,999.99"	,20,.F.,)

	TRCell():New(oSection2,"METAFATEXT"					,,"Meta Fatur.Externo"			,"@E 999,999,999.99"	,20,.F.,)
	TRCell():New(oSection2,"REALFATEXT"					,,"Realizado Fatur.Externo"		,"@E 999,999,999.99"	,20,.F.,)
	TRCell():New(oSection2,"PCATFATEXT"					,,"% Atingido Fatur.Externo"	,"@E 999,999,999.99"	,20,.F.,)
	TRCell():New(oSection2,"PCCMFATEXT"					,,"% Comissใo Fatur.Externo"	,"@E 999,999,999.99"	,20,.F.,)
	TRCell():New(oSection2,"PERCTOTAL"					,,"% Comissใo Total"			,"@E 999,999,999.99"	,20,.F.,)

	Return oReport
	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	ฑฑษออออออออออัอออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
	ฑฑบPrograma  ณReportPrintบAutor  ณRichard N Cabral    บ Data ณ  16/03/18   บฑฑ
	ฑฑฬออออออออออุอออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
	ฑฑบDesc.     ณ Relatorio Variaveis de Comissoes - RH                       บฑฑ
	ฑฑบ          ณ                                                             บฑฑ
	ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
	ฑฑบUso       ณ AP                                                          บฑฑ
	ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
	*/
	*------------------------------------*
Static Function ReportPrint(oReport)
	*------------------------------------*

	Local oSection1 := oReport:Section(1)
	Local oSection2 := oReport:Section(1):Section(1)
	Local nX		:= 0
	Local nDev		:= 0
	Local aDados[99]
	Local nSeqGrp	:= 13
	Local nGrp		:= 0
	Local nVend		:= 0
	Local nColVal	:= Len(aGrProd) * 4 + 13
	Local nFatur	:= 0
	Local nGrupProd := 0

	oSection1:Cell("SEGMENTO")  :SetBlock( { || aDados[01] } )	//01
	oSection2:Cell("VENDEDOR")  :SetBlock( { || aDados[02] } )	//02
	oSection2:Cell("MATRICUL")  :SetBlock( { || aDados[03] } )	//03
	oSection2:Cell("NOME")      :SetBlock( { || aDados[04] } )	//04

	oSection2:Cell("METAFATINT"):SetBlock( { || aDados[05] } )	//05
	oSection2:Cell("REALFATINT"):SetBlock( { || aDados[06] } )	//06
	oSection2:Cell("PCATFATINT"):SetBlock( { || aDados[07] } )	//07
	oSection2:Cell("PCCMFATINT"):SetBlock( { || aDados[08] } )	//08

	oSection2:Cell("METAFATEXT"):SetBlock( { || aDados[09] } )	//09
	oSection2:Cell("REALFATEXT"):SetBlock( { || aDados[10] } )	//10
	oSection2:Cell("PCATFATEXT"):SetBlock( { || aDados[11] } )	//11
	oSection2:Cell("PCCMFATEXT"):SetBlock( { || aDados[12] } )	//12
	oSection2:Cell("PERCTOTAL"):SetBlock( { || aDados[13] } )

	oReport:SetTitle("Variแveis de Comiss๕es - RH")

	oReport:SetMeter(0)
	aFill(aDados,nil)

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


				/*
				If ! Empty(aDevol[nDev,3])
					nPosAgrup := aScan(aGrProd, {|x| x[1] = aDevol[nDev,3] })
					aVend[nPosVd,5,10+(4*nPosAgrup)] -= If(aDevol[nDev,4]<0,0,aDevol[nDev,4])
				EndIf
				*/
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

			//------------ Tirar quando entrar em producao e todos os vendedores estiverem cadastrados em seus segmentos -----------//
			/*
			If Empty(aVend[nVend,1])
			aVend[nVend,1] :=  "IN"
			EndIf
			*/
			//aSort(aTabPerc)
			/*
			For nGrupProd := 1 to Len(aGrProd)
				If aVend[nVend,5,10+(4*nGrupProd)] > 0 .And. aVend[nVend,5,09+(4*nGrupProd)] > 0
					aVend[nVend,5,11+(4*nGrupProd)] :=  Round(aVend[nVend,5,10+(4*nGrupProd)] / aVend[nVend,5,09+(4*nGrupProd)] * 100,0)
					// Checa se o % Atingimente eh maior que o minimo "60" e acha na tabela com o maximo "140"
					If aVend[nVend,5,11+(4*nGrupProd)] >= nMinAting
						nPosPerc := aScan(aTabPerc,{|x| x[1] = aVend[nVend,1] .And. x[3] = "E" .And. x[4] = aGrProd[nGrupProd,1] .And. x[5] >= Min(aVend[nVend,5,11+(4*nGrupProd)],nMaxAting) })
						If ! Empty(nPosPerc)
							aVend[nVend,5,12+(4*nGrupProd)] := aTabPerc[nPosPerc,6]
							aVend[nVend,5,Len(aVend[nVend,5])] += If(aTabPerc[nPosPerc,6]<0,0,aTabPerc[nPosPerc,6])
						EndIf
					EndIf
				EndIf
				//aVend[nVend,5,09] += aVend[nVend,5,09+(4*nGrupProd)]

			Next nGrupProd
			*/

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
		//aSort(aVend,,,{ |x,y| x[4] < y[4] })
		lFirst := .T.
		nSegm := ""
		For nVend := 1 to Len(aVend)

			If ! Empty(aVend[nVend,1])

				For nX := 1 to Len(aVend[nVend,5])
					aDados[nX]	:=  If(nX <= 4, aVend[nVend,nX],If(aVend[nVend,5,nX]<0,0,aVend[nVend,5,nX]))
				Next nX

				If aVend[nVend,1] <> nSegm
					If lFirst
						lFirst := .F.
					Else
						oSection2:Finish()
					EndIf
					aDados[1] := aDados[1] // + " - " + Posicione("SX5",1,xFilial("SX5")+"Z8"+aDados[1],"X5_DESCRI")
					oSection1:Init()
					oSection1:PrintLine()
					oSection1:Finish()
					nSegm := aVend[nVend,1]
				EndIf

				oSection2:Init()
				oSection2:PrintLine()

				aFill(aDados,nil)

			EndIf

		Next nVend

	EndIf

	oReport:SkipLine()

	Return oReport

	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออปฑฑ
	ฑฑบPrograma  ณStQuery   บAutor  ณRichard N Cabral    บ Data ณ  28/11/17    บฑฑ
	ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออนฑฑ
	ฑฑบDesc.     ณ Relatorio Variaveis de Comissoes - RH                       บฑฑ
	ฑฑบ          ณ                                                             บฑฑ
	ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
	ฑฑบUso       ณ AP                                                          บฑฑ
	ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
	*/
	*-----------------------------*
Static Function StQuery()
	*-----------------------------*

	Local cQuery := ' '
	Local cDtIni := Substr(MV_PAR01,3,4)+Substr(MV_PAR01,1,2)+"01"
	Local cDtFim := DtoS(LastDay(StoD(cDtIni)))

	cQuery := " SELECT * FROM ( "
	cQuery += " SELECT  SA3.A3_COD AS F2_VEND1, "
	cQuery += "         SA3.A3_XSEGVEN, "
	cQuery += " 		SA3.A3_TPVEND TPVEND1, "
	cQuery += "         SUM(CASE WHEN SF2.F2_VEND1 <> SF2.F2_VEND2 THEN SF2.F2_VALBRUT -SF2.F2_VALICM-SF2.F2_VALIMP5-SF2.F2_VALIMP6 ELSE 0 END)	AS FATUR_EXTERNO, "
	cQuery += "         COALESCE(    (SELECT SUM(SD2.D2_TOTAL-SD2.D2_VALICM-SD2.D2_VALIMP5-SD2.D2_VALIMP6-D2_DIFAL-D2_ICMSCOM) AS TOTAL         "
	cQuery += "                             FROM  "+RetSqlName("SF2")+" SF2 "
	cQuery += "                             INNER JOIN(SELECT * FROM "+ RetSqlName("SD2")+" ) SD2 "
	cQuery += "                                 ON        SD2.D_E_L_E_T_ <> '*'        "
	cQuery += "                                 AND SD2.D2_FILIAL = SF2.F2_FILIAL        "
	cQuery += "                                 AND SD2.D2_DOC = SF2.F2_DOC         "
	cQuery += "                                 AND SD2.D2_SERIE = SF2.F2_SERIE        "
	cQuery += "                                 AND SD2.D2_CF IN('5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5403','5501','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6501','6502','7101','7102') 	   "
	cQuery += "                                 WHERE F2_EMISSAO BETWEEN '" + cDtIni + "' AND '" + cDtFim + "'         "
	cQuery += "                                     AND SF2.D_E_L_E_T_ <> '*'        "
	cQuery += "                 AND SF2.F2_VEND1 = SA3.A3_COD        "
	cQuery += "                 AND EXISTS            "
	cQuery += "                     (SELECT * FROM "+RetSqlName("SC6")+" SC6            "
	cQuery += "                             WHERE  SC6.C6_NUM = SD2.D2_PEDIDO            "
	cQuery += "                             AND SC6.C6_FILIAL = SD2.D2_FILIAL            AND SC6.D_E_L_E_T_ <> '*' )  ),0) AS FATUR_INTERNO "
	cQuery += " FROM SF2010 SF2  "
	cQuery += "     INNER JOIN(SELECT * FROM "+RetSqlName("SA1")+") SA1 "
	cQuery += "         ON SA1.D_E_L_E_T_   <> '*' "
	cQuery += "             AND SA1.A1_COD = SF2.F2_CLIENTE "
	cQuery += "             AND SA1.A1_LOJA = SF2.F2_LOJA "
	cQuery += "             AND SA1.A1_FILIAL = ' ' "
	cQuery += "             AND SA1.A1_CGC NOT IN  ('05890658000130','05890658000210','05890658000300','05890658000482','06048486000114','06048486000114','30708667761') "
	cQuery += "     INNER JOIN(SELECT * FROM "+RetSqlName("SA3")+" )SA3  "
	cQuery += "         ON SA3.A3_FILIAL = '  ' "
	cQuery += "             AND SA3.D_E_L_E_T_ <> '*'  "
	cQuery += "             AND (SA3.A3_COD = SF2.F2_VEND1  OR   SA3.A3_COD = SF2.F2_VEND2) "
	cQuery += "             AND SA3.A3_TPVEND = 'I' "
	cQuery += "         WHERE F2_EMISSAO BETWEEN '" + cDtIni + "' AND '" + cDtFim + "' "
	cQuery += "             AND SF2.D_E_L_E_T_ <> '*'  "
	cQuery += "             AND EXISTS ( SELECT * FROM "+RetSqlName("SD2")+" SD2  "
	cQuery += "         INNER JOIN (SELECT * FROM "+RetSqlName("SF4")+" )SF4  "
	cQuery += "             ON  SD2.D2_TES = SF4.F4_CODIGO  "
	cQuery += "                 AND SF4.D_E_L_E_T_ <> '*'  "
	cQuery += "                 AND SD2.D2_CF IN('5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5403','5501','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6501','6502','7101','7102') "
	cQuery += "     WHERE SD2.D2_DOC = SF2.F2_DOC "
	cQuery += "         AND SD2.D2_SERIE = SF2.F2_SERIE "
	cQuery += "         AND SD2.D_E_L_E_T_ <>'*'  AND SD2.D2_FILIAL = SF2.F2_FILIAL ) "
	cQuery += " GROUP BY SA3.A3_COD , A3_XSEGVEN,A3_TPVEND  "
	cQuery += " ORDER BY SA3.A3_COD ) TMP"

	cQuery += " UNION"

	cQuery += " SELECT * FROM ( "
	cQuery += " SELECT F2_VEND1, "
	cQuery += "  SA31.A3_XSEGVEN, "
	cQuery += "  SA31.A3_TPVEND TPVEND1, "
	cQuery += "  SUM(SD2.D2_TOTAL-SD2.D2_VALICM-SD2.D2_VALIMP5-SD2.D2_VALIMP6-SD2.D2_DIFAL-SD2.D2_ICMSCOM) FATUR_INTERNO, "
	cQuery += "  SUM(SD2.D2_TOTAL-SD2.D2_VALICM-SD2.D2_VALIMP5-SD2.D2_VALIMP6-SD2.D2_DIFAL-SD2.D2_ICMSCOM) FATUR_EXTERNO"
	cQuery += "  FROM SD2010 SD2 "
	cQuery += "  LEFT JOIN "+RetSqlName("SF2")+" SF2  ON SD2.D2_FILIAL  = SF2.F2_FILIAL AND SD2.D2_DOC = SF2.F2_DOC AND SD2.D2_SERIE = SF2.F2_SERIE AND SF2.D_E_L_E_T_ = ' ' "
	cQuery += "  LEFT JOIN "+RetSqlName("SB1")+" SB1  ON SB1.B1_FILIAL  = '  ' AND SB1.B1_COD = SD2.D2_COD AND SB1.D_E_L_E_T_ = ' ' "
	cQuery += "  INNER JOIN "+RetSqlName("SBM")+" SBM  ON SBM.BM_FILIAL  = ' ' AND SBM.BM_GRUPO = SB1.B1_GRUPO AND SBM.BM_XAGRUP <> ' ' AND SBM.D_E_L_E_T_ = ' ' "
	cQuery += "  LEFT JOIN "+RetSqlName("SA1")+" SA1  ON SA1.A1_FILIAL  = '  ' AND SA1.A1_COD = SF2.F2_CLIENTE AND SA1.A1_LOJA = SF2.F2_LOJA AND SA1.D_E_L_E_T_ = ' '  "
	cQuery += "  LEFT JOIN "+RetSqlName("SA3")+" SA31 ON SA31.A3_FILIAL = '  ' AND SA31.A3_COD = SF2.F2_VEND1 AND SA31.D_E_L_E_T_   = ' ' "
	cQuery += "  WHERE F2_EMISSAO BETWEEN '" + cDtIni + "' AND '" + cDtFim + "' "
	cQuery += "  AND SA1.A1_CGC NOT IN ('05890658000130','05890658000210','05890658000300','05890658000482','06048486000114','06048486000114','30708667761')  "
	cQuery += "  AND SD2.D2_CF IN('5101' , '5102' , '5109' , '5116' , '5117' , '5118' , '5119' , '5122' , '5123' , '5401' , '5403' , '5501' , '5502' , '6101' , '6102' , '6107' , '6108' , '6109' , '6110' , '6111' , '6114' , '6116' , '6117' , '6118' , '6119' , '6122' , '6123' , '6401' , '6403' , '6501' , '6502' , '7101' , '7102')  "
	cQuery += "  AND SA31.A3_XSEGVEN <> 'IN' "
	cQuery += "  AND SD2.D_E_L_E_T_ = ' ' "
	cQuery += "  GROUP BY F2_VEND1,A3_XSEGVEN,A3_TPVEND "
	cQuery += " ORDER BY F2_VEND1) TMP1 "

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
	Local cDtIni		:= Substr(MV_PAR01,3,4)+Substr(MV_PAR01,1,2)+"01"
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
	Local cDtIni		:= Substr(MV_PAR01,3,4)+Substr(MV_PAR01,1,2)+"01"

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

User Function GP09MAno(cMesAno)
	Local lRet := .T.

	If ! ( Substr(cMesAno,1,2) >= "01" .And. Substr(cMesAno,1,2) <= "12" )
		MsgAlert("Mes/Ano invแlido")
		lRet := .F.
	Else
		If ! ( Substr(cMesAno,3,4) >= "2000" )
			MsgAlert("Mes/Ano invแlido")
			lRet := .F.
		EndIf
	EndIf

Return(lRet)

Static Function ApuraMeta(cVendMeta)

	Local nPosAgrup := 0
	Local _cQry		:= ""
	Local _cMesAno	:= MV_PAR01
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
		If ZZD->(DbSeek(xFilial("ZZD") + Substr(MV_PAR01,1,2) + Substr(MV_PAR01,3,4) + cVendMeta))

			Do While ZZD->ZZD_FILIAL + ZZD->ZZD_MES + ZZD->ZZD_ANO + ZZD->ZZD_VEND = xFilial("ZZD") + Substr(MV_PAR01,1,2) + Substr(MV_PAR01,3,4) + cVendMeta .And. ! ZZD->(Eof())

				/*
				SBM->(DbSetOrder(1))
				SBM->(DbSeek(xFilial("SBM")+ZZD->ZZD_GRUPO))

				If ! Empty(SBM->BM_XAGRUPR)
					nPosAgrup := aScan(aGrProd, {|x| x[1] = SBM->BM_XAGRUPR })
					If ! Empty(nPosAgrup)
						aVend[nPosVend,5,09+(4*nPosAgrup)] += ZZD->ZZD_VALOR
						aVend[nPosVend,5,09] += ZZD->ZZD_VALOR
					EndIf
				EndIf
				*/

				aVend[nPosVend,5,05] += ZZD->ZZD_VALOR

				ZZD->(DbSkip())
			EndDo

		Else
			aVend[nPosVend,5,05] += Iif( TRB->MEDINT < 10000,10000,TRB->MEDINT)  //Interno
		EndIf

		aVend[nPosVend,5,09] += Iif( TRB->MEDEXT < 200000,200000,TRB->MEDEXT)  //Exteno

	Else

		ZZD->(DbSetOrder(1))
		ZZD->(DbSeek(xFilial("ZZD") + Substr(MV_PAR01,1,2) + Substr(MV_PAR01,3,4) + cVendMeta))

		Do While ! ZZD->(Eof()) .And. ZZD->ZZD_FILIAL + ZZD->ZZD_MES + ZZD->ZZD_ANO + ZZD->ZZD_VEND = xFilial("ZZD") + Substr(MV_PAR01,1,2) + Substr(MV_PAR01,3,4) + cVendMeta

			/*
			SBM->(DbSetOrder(1))
			SBM->(DbSeek(xFilial("SBM")+ZZD->ZZD_GRUPO))

			If ! Empty(SBM->BM_XAGRUPR)
				nPosAgrup := aScan(aGrProd, {|x| x[1] = SBM->BM_XAGRUPR })
				If ! Empty(nPosAgrup)
					aVend[nPosVend,5,09+(4*nPosAgrup)] += ZZD->ZZD_VALOR
				EndIf
			EndIf
			*/
			aVend[nPosVend,5,05] += ZZD->ZZD_VLRCAR //Meta Interno
			aVend[nPosVend,5,09] += ZZD->ZZD_VALOR// Meta Externo

			ZZD->(DbSkip())

		EndDo

	EndIf

Return

//---------- Somente para teste ----------------------------------------------------------------------//
//cQuery += " AND (F2_VEND1 = 'I08092' OR  F2_VEND2 = 'I08092') " + CRLF
//cQuery += " AND F2_VEND1 = 'R00051' " + CRLF
//cQuery += " AND F2_VEND2 = 'I08092' " + CRLF
//cQuery += " AND B1_GRUPO = '160' " + CRLF
//----------------------------------------------------------------------------------------------------//
