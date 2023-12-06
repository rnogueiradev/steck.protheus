#Include "Protheus.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ STESTF01() บAutor  ณ Vitor Merguizo   บ Data ณ  28/01/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina para atualiza็ใo do custo das MOD's a partir do valorบฑฑ
ฑฑบDesc.     ณinformado pelo usuแrio                                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Steck                                                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function STESTF01()

	Local aSays		:= {}
	Local aButtons	:= {}

	Private cCadastro 	:= OemToAnsi("Atualiza็ใo do Custo de MOD")
	Private cPerg 		:= "STESTF01"
	Private aHeader 	:= {}
	Private aCols		:= {}
	Private cTabela		:= ""
	Private oGetDados1
	Private nOpcao 		:= 0

	// Funcao para criacao de perguntas da rotina.
	Ajusta()

	Pergunte(cPerg,.t.)

	AAdd(aSays,"Este programa tem como objetivo trazer em tela os totais")
	AAdd(aSays,"de MODs requisitados a partir do parametro selecionado.")
	AAdd(aSays,"Em seguida ira atualizar o custo destes movimentos com ")
	AAdd(aSays,"os custos informados.")

	AAdd(aButtons,{ 5,.T.,{|| Pergunte(cPerg,.t.) } } )
	AAdd(aButtons,{ 1,.T.,{|| IIF(fConfMark(),FechaBatch(),nOpcao := 0) } } )
	AAdd(aButtons,{ 2,.T.,{|| FechaBatch() } } )

	FormBatch(cCadastro,aSays,aButtons)

	If nOpcao == 1
		// Funcao para buscar os produtos de acordo com o parametro selecionado
		MsgRun("Aguarde filtrando os dados de acordo com parametros informados","Aguarde",{ || fGeraSQL() })

		// se nใo existir informacao no acols, nao apresenta tela
		If Empty(aCols)
			ApMsgStop("Nao existe informacao para o filtro selecionado em parametros","Verifique")
		Else
			fTelaFim()	// Tela para informacao dos itens a serem utilizados.
		EndIf
	EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfGeraSQL  บAutor  ณVitor Merguizo      บ Data ณ  11/07/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao para buscar os dados de acordo com os parametros     บฑฑ
ฑฑบ          ณselecionados pelo usuario.                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Steck                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fGeraSQL()

	Local cQuery	:= ""
	Local cAlias	:= "QRYSD3"
	Local cAlia1	:= "QRYCQ2"
	Local cAlia2	:= "QRYCQ4"
	Local cAlia3	:= "QRYSD4"
	Local _nTotMes  := 0
	Local _nQtdMes  := 0
	Local _nATotMes := 0
	Local _nAQtdMes  := 0
	Local _nVTotMes := 0
	Local _nVQtdMes  := 0



	//Obtem os dados dos Movimentos
	cQuery := " SELECT D3_COD,B1_TIPO,B1_DESC,SUM(CASE WHEN D3_TM > '500' THEN D3_CUSTO1 ELSE D3_CUSTO1*-1 END)/SUM(CASE WHEN D3_TM > '500' THEN D3_QUANT ELSE D3_QUANT*-1 END)D3_CM1,SUM(CASE WHEN D3_TM > '500' THEN D3_QUANT ELSE D3_QUANT*-1 END)D3_QUANT,SUM(CASE WHEN D3_TM > '500' THEN D3_CUSTO1 ELSE D3_CUSTO1*-1 END)D3_CUSTO1 "
	cQuery += " FROM "+RetSqlName("SD3")+" SD3 "
	cQuery += " INNER JOIN "+RetSqlName("SB1")+" SB1 ON B1_FILIAL = ' ' AND B1_COD = D3_COD AND SB1.D_E_L_E_T_= ' ' "
	cQuery += " WHERE "
	cQuery += " D3_FILIAL BETWEEN '  ' AND 'ZZ' AND                   "
	cQuery += " SUBSTR(D3_COD,1,3)='MOD' AND "
	cQuery += " D3_ESTORNO <> 'S' AND "
	cQuery += " SUBSTR(D3_EMISSAO,1,6)='"+StrZero(mv_par02,4,0)+StrZero(mv_par01,2,0)+"' AND "
	cQuery += " SD3.D_E_L_E_T_= ' ' "
	cQuery += " GROUP BY D3_COD,B1_TIPO,B1_DESC "
	cQuery += " ORDER BY D3_COD "

	cQuery := ChangeQuery(cQuery)

	//Verifica se o Alias esta aberto
	If Select(cAlias) > 0
		DbSelectArea(cAlias)
		(cAlias)->(DbCloseArea())
	EndIf

	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),cAlias, .F., .T.)

	TCSetField(cAlias,"B2_CM1"	 ,"N", 16, 6 )
	TCSetField(cAlias,"D3_QUANT" ,"N", 16, 2 )
	TCSetField(cAlias,"D3_CUSTO1","N", 16, 2 )

	dbSelectArea(cAlias)
	(cAlias)->(DbGoTop())

	aHeader := {}
	aCols	:= {}

	aAdd(aHeader,{"Produto",		"XX_CODIGO"	,"@!",Len(SB1->B1_COD)	,0,"","€€€€€€€€€€€€€€€","C","","","","",".T."})
	aAdd(aHeader,{"Tipo",		"XX_TIPO"	,"@!",Len(SB1->B1_COD)	,0,"","€€€€€€€€€€€€€€€","C","","","","",".T."})
	aAdd(aHeader,{"Descricao",		"XX_DESC"	,"@!",Len(SB1->B1_DESC)	,0,"","€€€€€€€€€€€€€€€","C","","","","",".T."})
	aAdd(aHeader,{"Custo Medio",	"XX_CM1"	,"@E 99,999,999,999.99",9	,2,"","€€€€€€€€€€€€€€€","N","","","","",".T."})
	aAdd(aHeader,{"Quantidade",		"XX_QUANT"	,"@E 99,999,999,999.99",9		,2,"","€€€€€€€€€€€€€€€","N","","","","",".T."})
	aAdd(aHeader,{"Custo Total",	"XX_CUSTO1"	,"@E 99,999,999,999.99",9		,2,"U_fCalcCM1()","€€€€€€€€€€€€€€€","N","","","","",".T."})
	aAdd(aHeader,{"           ",	"XX_QUEBRA"	,"@!",9,2,"","","C","","","","",".T."})
	aAdd(aHeader,{"Custo Medio",	"AXX_CM1"	,"@E 99,999,999,999.99",9	,2,"","€€€€€€€€€€€€€€€","N","","","","",".T."})
	aAdd(aHeader,{"Quantidade",		"AXX_QUANT"	,"@E 99,999,999,999.99",9		,2,"","€€€€€€€€€€€€€€€","N","","","","",".T."})
	aAdd(aHeader,{"Custo Total",	"AXX_CUSTO1"	,"@E 99,999,999,999.99",9		,2,"U_fCalcCM1()","€€€€€€€€€€€€€€€","N","","","","",".T."})
	aAdd(aHeader,{"           ",	"AXX_QUEBRA"	,"@!",9,2,"","","C","","","","",".T."})
	aAdd(aHeader,{"Custo Medio",	"VXX_CUSTO1"	,"@E 99,999,999,999.99",9		,2,"","€€€€€€€€€€€€€€€","N","","","","",".T."})
	aAdd(aHeader,{"Quantidade",		"VXX_QUANT"	,"@E 99,999,999,999.99",9		,2,"","€€€€€€€€€€€€€€€","N","","","","",".T."})
	aAdd(aHeader,{"Custo Total",	"VXX_CM1"	,"@E 99,999,999,999.99",9	,2,"","€€€€€€€€€€€€€€€","N","","","","",".T."})
	aAdd(aHeader,{"          ",	"VXX_QUEBRA"	,"@!",9,2,"","","C","","","","",".T."})


	aAdd(aCols,Array(len(aHeader)+1))

	aCols[Len(aCols),07]	:=     "<-- "+RTRIM(MesExtenso( mv_par01 ))
	aCols[Len(aCols),11]	:=     "<-- "+RTRIM(MesExtenso( mv_par01-1 ))
	aCols[Len(aCols),15]    :=     "<-- "+" VARIAวรO "

	While (cAlias)->(!Eof())
		aAdd(aCols,Array(len(aHeader)+1))

		//Mes atual
		aCols[Len(aCols),01] 	:= (cAlias)->D3_COD
		aCols[Len(aCols),02]	:= (cAlias)->B1_TIPO
		aCols[Len(aCols),03]	:= (cAlias)->B1_DESC
		aCols[Len(aCols),05]	:= (cAlias)->D3_QUANT


		//Obtem os dados dos movimentos contแbeis mes atual
		cQuery := " SELECT SUM(CQ2.CQ2_DEBITO) AS DEBITO,      "
		cQuery += " SUM(CQ2.CQ2_CREDIT) AS CREDIT              "
		cQuery += " FROM "+RetSqlName("CQ2")+" CQ2             "
		cQuery += " WHERE CQ2.CQ2_CONTA >= '4                   '                                      AND "
		cQuery += "       CQ2.CQ2_CONTA <= '59999999999999999999'                                      AND "
		cQuery += "       CQ2.CQ2_CCUSTO ='"+RTrim(SUBSTR((cAlias)->D3_COD,4,15))+"'                   AND "
		cQuery += "       SUBSTR(CQ2.CQ2_DATA,1,4)='"+StrZero(mv_par02,4,0)+"'            AND "
		cQuery += "       SUBSTR(CQ2.CQ2_DATA,5,2)='"+StrZero(mv_par01,2,0)+"'              AND "
		cQuery += "       CQ2.CQ2_MOEDA='01'                         AND "
		cQuery += "       CQ2.CQ2_TPSALD='1'                         AND "
		cQuery += "       CQ2.CQ2_CONTA NOT IN ('550101001')         AND "
		cQuery += "       CQ2.D_E_L_E_T_ <>'*'

		cQuery := ChangeQuery(cQuery)

		//Verifica se o Alias esta aberto
		If Select(cAlia1) > 0
			DbSelectArea(cAlia1)
			(cAlia1)->(DbCloseArea())
		EndIf

		dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),cAlia1, .F., .T.)


		aCols[Len(aCols),06]	:= (cAlia1)->DEBITO- (cAlia1)->CREDIT
		aCols[Len(aCols),04]	:= ((cAlia1)->DEBITO- (cAlia1)->CREDIT)/ (cAlias)->D3_QUANT


		//Obtem os dados dos Movimentos ESTOQUE ANTERIOR
		cQuery := " SELECT D3_COD,B1_TIPO,B1_DESC,SUM(CASE WHEN D3_TM > '500' THEN D3_CUSTO1 ELSE D3_CUSTO1*-1 END)/SUM(CASE WHEN D3_TM > '500' THEN D3_QUANT ELSE D3_QUANT*-1 END)D3_CM1,SUM(CASE WHEN D3_TM > '500' THEN D3_QUANT ELSE D3_QUANT*-1 END)D3_QUANT,SUM(CASE WHEN D3_TM > '500' THEN D3_CUSTO1 ELSE D3_CUSTO1*-1 END)D3_CUSTO1 "
		cQuery += " FROM "+RetSqlName("SD3")+" SD3 "
		cQuery += " INNER JOIN "+RetSqlName("SB1")+" SB1 ON B1_FILIAL = ' ' AND B1_COD = D3_COD AND SB1.D_E_L_E_T_= ' ' "
		cQuery += " WHERE "
		cQuery += " D3_FILIAL BETWEEN '  ' AND 'ZZ' AND                   "
		cQuery += " D3_COD='"+(cAlias)->D3_COD+"' AND "
		cQuery += " D3_ESTORNO <> 'S' AND "

		If StrZero(mv_par01,2,0)=='01'
			cQuery += "       SUBSTR(SD3.D3_EMISSAO,1,4)='"+StrZero(mv_par02-1,4,0)+"'            AND "
			cQuery += "       SUBSTR(SD3.D3_EMISSAO,5,2)='12'                                     AND "
		Else
			cQuery += "       SUBSTR(SD3.D3_EMISSAO,1,4)='"+StrZero(mv_par02,4,0)+"'             AND "
			cQuery += "       SUBSTR(SD3.D3_EMISSAO,5,2)='"+StrZero(mv_par01-1,2,0)+"'            AND "
		Endif
		cQuery += " SD3.D_E_L_E_T_= ' ' "
		cQuery += " GROUP BY D3_COD,B1_TIPO,B1_DESC "
		cQuery += " ORDER BY D3_COD "

		cQuery := ChangeQuery(cQuery)

		//Verifica se o Alias esta aberto
		If Select(cAlia3) > 0
			DbSelectArea(cAlia3)
			(cAlia3)->(DbCloseArea())
		EndIf

		dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),cAlia3, .F., .T.)

		TCSetField(cAlia3,"B2_CM1"	 ,"N", 16, 6 )
		TCSetField(cAlia3,"D3_QUANT" ,"N", 16, 2 )
		TCSetField(cAlia3,"D3_CUSTO1","N", 16, 2 )

		dbSelectArea(cAlia3)
		(cAlia3)->(DbGoTop())



		//Obtem os dados dos movimentos contแbeis mes anterior
		cQuery := " SELECT SUM(CQ2.CQ2_DEBITO) AS DEBITO,      "
		cQuery += " SUM(CQ2.CQ2_CREDIT) AS CREDIT              "
		cQuery += " FROM "+RetSqlName("CQ2")+" CQ2             "
		cQuery += " WHERE CQ2.CQ2_CONTA >= '4                   '                                      AND "
		cQuery += "       CQ2.CQ2_CONTA <= '59999999999999999999'                                      AND "
		cQuery += "       CQ2.CQ2_CCUSTO ='"+RTrim(SUBSTR((cAlias)->D3_COD,4,15))+"'                   AND "

		If StrZero(mv_par01,2,0)=='01'
			cQuery += "       SUBSTR(CQ2.CQ2_DATA,1,4)='"+StrZero(mv_par02-1,4,0)+"'            AND "
			cQuery += "       SUBSTR(CQ2.CQ2_DATA,5,2)='12'              AND "
		Else
			cQuery += "       SUBSTR(CQ2.CQ2_DATA,1,4)='"+StrZero(mv_par02,4,0)+"'            AND "
			cQuery += "       SUBSTR(CQ2.CQ2_DATA,5,2)='"+StrZero(mv_par01-1,2,0)+"'              AND "
		Endif

		cQuery += "       CQ2.CQ2_MOEDA='01'                         AND "
		cQuery += "       CQ2.CQ2_TPSALD='1'                         AND "
		cQuery += "       CQ2.CQ2_CONTA NOT IN ('550101001')         AND "
		cQuery += "       CQ2.D_E_L_E_T_ <>'*'

		cQuery := ChangeQuery(cQuery)

		//Verifica se o Alias esta aberto
		If Select(cAlia2) > 0
			DbSelectArea(cAlia2)
			(cAlia2)->(DbCloseArea())
		EndIf

		dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),cAlia2, .F., .T.)
		aCols[Len(aCols),09]	:= (cAlia3)->D3_QUANT
		aCols[Len(aCols),08]	:=  ((cAlia2)->DEBITO- (cAlia2)->CREDIT)/aCols[Len(aCols),09]
		aCols[Len(aCols),10]	:= (cAlia2)->DEBITO- (cAlia2)->CREDIT
		//Mes Anterior


		aCols[Len(aCols),14]    := ((cAlia1)->DEBITO- (cAlia1)->CREDIT)-((cAlia2)->DEBITO- (cAlia2)->CREDIT)

		aCols[Len(aCols),13]   := (cAlias)->D3_QUANT - (cAlia3)->D3_QUANT

		aCols[Len(aCols),12]   := aCols[Len(aCols),04]-aCols[Len(aCols),8]

		aCols[Len(aCols),Len(aHeader)+1] := .f.

		If  (cAlias)->D3_COD<>'MOD120121'
			_nTotMes += aCols[Len(aCols),06]
			_nQtdMes += aCols[Len(aCols),05]
			_nAQtdMes+= aCols[Len(aCols),09]
			_nATotMes+=aCols[Len(aCols),10]
			_nVQtdMes+=aCols[Len(aCols),13]
			_nVTotMes +=aCols[Len(aCols),14]

		Endif

		(cAlias)->(DbSkip())
	EndDo

	aAdd(aCols,Array(len(aHeader)+1))
	aCols[Len(aCols),01] := "TOTAL "
	aCols[Len(aCols),05] := _nQtdMes
	aCols[Len(aCols),06] := _nTotMes
	aCols[Len(aCols),04] :=  _nTotMes/_nQtdMes

	aCols[Len(aCols),09] := _nAQtdMes
	aCols[Len(aCols),10] := _nATotMes
	aCols[Len(aCols),08] := _nATotMes/_nAQtdMes
	aCols[Len(aCols),13] := _nVQtdMes
	aCols[Len(aCols),12] := (_nTotMes/_nQtdMes)-(_nATotMes/_nAQtdMes)
	aCols[Len(aCols),14] := _nVTotMes



	(cAlias)->(DbCloseArea())

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfTelaFim  บAutor  ณVitor Merguizo      บ Data ณ  11/07/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao da tela de atualiza็ใo do custo MOD.                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Steck                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fTelaFim()

	Private cCadastro := "Custo M้dio para atualiza็ใo das MOD's"

	If Len(aCols) == 0
		aAdd(aCols,Array(len(aHeader)+1))
	EndIf

	nStyle := GD_UPDATE+GD_DELETE

	aObjects := {}

	aSize := MsAdvSize()
	AAdd( aObjects, { 100, 100 , .T., .T. } )
	aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 5, 5 }
	aPosObj 	:= MsObjSize( aInfo, aObjects,.T.)
	nOpca		:= 0
	acpos		:= {"XX_CUSTO1"}
	aButtons	:= {}

	DEFINE MSDIALOG oDlg TITLE cCadastro From aSize[7],0 To aSize[6],aSize[5] of oMainWnd PIXEL

	oGetDados1 := MsNewGetDados():New(aPosObj[1,1],aPosObj[1,2],aPosObj[1,3],aPosObj[1,4],nStyle,"AllWaysTrue","AllWaysTrue","",acpos,/*freeze*/,999,/*fieldok*/,/*superdel*/,/*delok*/,oDlg,aHeader,aCols)

	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| iif(fConfPrc(),(nOpca := 1,oDlg:End()),nOpca := 0) },{||oDlg:End()},,aButtons)

	// se a opcao for encerrar executa a rotina.
	If nOpca == 1
		// Gravacao dos precos.
		Processa({|| fGrvPrc()})
		ApMsgInfo("Atualiza็ใo do Custo MOD concluida com sucesso !!!","Termino")

	EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfConfPrc  บAutor  ณVitor Merguizo      บ Data ณ  11/07/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao para confirmacao da atualiza็ใo do Custo MOD.        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Steck                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fConfPrc()

	Local _lRet := .F.

	If ApMsgYesNo("Confirma Atualiza็ใo do Custo MOD?","Confirmar")
		_lRet := .T.
	EndIf

Return(_lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfGrvPrc   บAutor  ณVitor Merguizo      บ Data ณ  23/07/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao de atualiza็ใo do custo.                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Steck                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fGrvPrc()

	Local _nZ		:= 0
	Local aArea 	:= GetArea()
	Local cQueryUpd	:= ""
	Local nPosPrd	:= aScan(aHeader,{|x| Alltrim(x[2]) == "XX_CODIGO"})
	Local nPosCm1	:= aScan(aHeader,{|x| Alltrim(x[2]) == "XX_CM1"})

	ProcRegua(Len(oGetDados1:aCols))

	For _nZ := 1 To Len(oGetDados1:aCols)
		If !oGetDados1:aCols[_nZ,Len(aHeader)+1]

			If !ValType(oGetDados1:aCols[_nZ,nPosPrd])=="C"
				Loop
			EndIf

			IncProc("Atualizando o custo do Produto " + oGetDados1:aCols[_nZ,nPosPrd])
			cQueryUpd := " UPDATE "+RetSqlName("SD3")+" SET "
			cQueryUpd += " D3_CUSTO1 = D3_QUANT*"+cValToChar(oGetDados1:aCols[_nZ,nPosCm1])
			cQueryUpd += " WHERE D3_COD = '"+oGetDados1:aCols[_nZ,nPosPrd]+"' AND "
			cQueryUpd += " D3_FILIAL BETWEEN '  ' AND 'ZZ' AND "
			cQueryUpd += " SUBSTR(D3_COD,1,3)='MOD' AND "
			cQueryUpd += " SUBSTR(D3_EMISSAO,1,6)='"+StrZero(mv_par02,4,0)+StrZero(mv_par01,2,0)+"' AND "
			cQueryUpd += " D_E_L_E_T_= ' ' "

			TcSqlExec(cQueryUpd)

			cQueryUpd := " UPDATE "+RetSqlName("SB2")+" SET "
			cQueryUpd += " B2_CM1 = "+cValToChar(oGetDados1:aCols[_nZ,nPosCm1])+" , B2_CMFIM1 = "+cValToChar(oGetDados1:aCols[_nZ,nPosCm1])
			cQueryUpd += " WHERE B2_COD = '"+oGetDados1:aCols[_nZ,nPosPrd]+"' AND "
			cQueryUpd += " B2_FILIAL BETWEEN '  ' AND 'ZZ' AND "
			cQueryUpd += " SUBSTR(B2_COD,1,3)='MOD' AND "
			cQueryUpd += " D_E_L_E_T_= ' ' "

			TcSqlExec(cQueryUpd)

		Else
			IncProc("...")
		EndIf

	Next

	If mv_par03 = 1
		cQueryUpd := " UPDATE "+RetSqlName("SD3")+" SET "
		cQueryUpd += " D3_CF = 'RE1' "
		cQueryUpd += " WHERE "
		cQueryUpd += " D3_FILIAL BETWEEN '  ' AND 'ZZ' AND "
		cQueryUpd += " D3_CF = 'RE2' AND "
		cQueryUpd += " D3_OP <> ' ' AND "
		cQueryUpd += " SUBSTR(D3_EMISSAO,1,6)='"+StrZero(mv_par02,4,0)+StrZero(mv_par01,2,0)+"' AND "
		cQueryUpd += " D_E_L_E_T_= ' ' "

		TcSqlExec(cQueryUpd)
	EndIf

	RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfCalcM001 บAutor  ณAdriano Luis Brandaoบ Data ณ  27/07/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao para recalculo e validacao da digitacao do usuario   บฑฑ
ฑฑบ          ณsobre os precos e margens.                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Steck                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function fCalcCM1()

	Local lRet		:= .T.
	Local nCusto	:= 0
	Local nCm1		:= 0
	Local nQuant	:= 0
	Local nPosQtd	:= aScan(aHeader,{|x| Alltrim(x[2]) == "XX_QUANT"})
	Local nPosCm1	:= aScan(aHeader,{|x| Alltrim(x[2]) == "XX_CM1"})
	Local nPosCusto	:= aScan(aHeader,{|x| Alltrim(x[2]) == "XX_CUSTO1"})

	nCusto	:= M->XX_CUSTO1
	nQuant	:= GdFieldGet("XX_QUANT")
	nCm1	:= IIF(nCusto>0,nCusto/nQuant,0)

	//Atualiza Custo 1
	oGetDados1:aCols[n,nPosCm1]	:= nCm1
	M->XX_CM1	:= nCm1

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfConfMark บAutor  ณVitor Merguizo      บ Data ณ  11/07/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao para validacao                                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Steck                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fConfMark()

	nOpcao := 1

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o	 ณAjusta    ณ Autor ณ Vitor Merguizo		  ณ Data ณ 11/07/2013		ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Insere novas perguntas na tabela SX1 a Ajusta o Picture dos valores	ณฑฑ
ฑฑณ          ณ no SX3                                                           	ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณSintaxe e ณ 																		ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Ajusta()

	Local aPergs 	:= {}

	Aadd(aPergs,{"Mes ?                          ","Mes ?                         ","Mes ?                         ","mv_ch1","N",2,0,0,"G","NaoVazio().and.MV_PAR01<=12","mv_par01","               ","               ","               ","","","               ","               ","               ","","","","","","","","","","","","","","","","","","S","",""})
	Aadd(aPergs,{"Ano ?             	         ","Ano ?             	          ","Ano ?                         ","mv_ch2","N",4,0,0,"G","NaoVazio().and.MV_PAR02<=2100.and.MV_PAR02>2000","mv_par02","               ","               ","               ","","","               ","               ","               ","","","","","","","","","","","","","","","","","","S","",""})
	Aadd(aPergs,{"Altera Mov. RE2 para RE1?      ","Altera Mov. RE2 para RE1?     ","Altera Mov. RE2 para RE1?     ","mv_ch3","N",1,0,2,"C",""                    ,"mv_par03","Sim            ","Si             ","Yes            ","","","Nao            ","No             ","No             ","","","","","","","","","","","","","","","","","","S","",""})

	//AjustaSx1(cPerg,aPergs)

Return