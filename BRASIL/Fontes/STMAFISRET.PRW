#INCLUDE "RWMAKE.CH"
#Include "TOPCONN.CH"

/*====================================================================================\
|Programa  | STMAFISRET       | Autor | GIOVANI.ZAGO             | Data | 14/01/2013  |
|=====================================================================================|
|Descrição |  STMAFISRET                                                              |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STMAFISRET                                                               |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
User Function STMAFISRET()
	*-----------------------------*
	Local _nPosPrv  := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_PRCVEN"})     // Preco de venda
	Local _nPosPDesc:= aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_DESCONT"})    // Percentual do desconto
	Local _nPosVDesc:= aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_VALDESC"})    // Valor do Desconto
	Local _nPosQtd  := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_QTDVEN"})     // Quantidade
	Local _nPosTot  := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_VALOR"})      // Valor total
	Local _nPosUnt  := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_XPRCLIS"})     // Preço LISTA
	Local _nPosList := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_PRUNIT"})     // Preço Unitário
	Local _nPosProd  := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_PRODUTO"})    // Codigo do produto
	Local _nValAcre  := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_XVALACR"})     	// Valor Acrescimo Financeiro
	Local _nPosTes  := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_TES"})     	// Valor Acrescimo Financeiro  _nPosTes
	
	Local	nPValICMS		:= Ascan(aHeader,{|x| AllTrim(Upper(x[2]))	== "C6_ZVALICM"})			// Posicao do Valor do ICMS
	Local	nPAliqICM  		:= Ascan(aHeader,{|x| AllTrim(Upper(x[2]))	== "C6_ZPICMS"})			// Posicao do Aliq. ICMS
	Local	nPValICMSST		:= Ascan(aHeader,{|x| AllTrim(Upper(x[2]))	== "C6_ZVALIST"})			// Posicao do Valor do ICMS ST
	Local	nPValIPI		:= Ascan(aHeader,{|x| AllTrim(Upper(x[2]))	== "C6_ZVALIPI"})			// Posicao do Valor do IPI
	Local	nPValLiq		:= Ascan(aHeader,{|x| AllTrim(Upper(x[2]))	== "C6_ZVALLIQ"})			// Posicao do Valor do Liquido
	Local	nPosIpi		    := Ascan(aHeader,{|x| AllTrim(Upper(x[2]))	== "C6_ZIPI"})
	Local	nPosMark	    := Ascan(aHeader,{|x| AllTrim(Upper(x[2]))	== "C6_ZMARKUP"})
	Local   _nTotPed 		:= 0
	Local	nAliqICM 		:= 0
	Local	nValICms		:= 0
	Local   nCnt 			:= 0
	Local	nAliqIPI 		:= 0
	Local	nValIPI 		:= 0
	Local	nValICMSST 		:= 0
	Local	nValPis			:= 0
	Local	nValCof			:= 0
	Local   nValCmp 		:= 0
	Local   nValDif 		:= 0
	
	MaFisSave()
	MaFisEnd()
	MaFisIni(Iif(Empty(M->C5_CLIENT),M->C5_CLIENTE,M->C5_CLIENT),;// 1-Codigo Cliente/Fornecedor
	M->C5_LOJAENT,;		// 2-Loja do Cliente/Fornecedor
	IIf(M->C5_TIPO$'DB',"F","C"),;				// 3-C:Cliente , F:Fornecedor
	M->C5_TIPO,;				// 4-Tipo da NF
	M->C5_TIPOCLI,;		// 5-Tipo do Cliente/Fornecedor
	Nil,;
		Nil,;
		Nil,;
		Nil,;
		"MATA461")
	// 10-Nome da rotina que esta utilizando a funcao
	MaFisAdd(aCols[n,_nPosProd],;                                                     // 1-Codigo do Produto ( Obrigatorio )
	aCols[n,_nPosTes],;                                                                           // 2-Codigo do TES ( Opcional )
	aCols[n,_nPosQtd],;                                                           // 3-Quantidade ( Obrigatorio )
	aCols[n,_nPosPrv],;                                                            // 4-Preco Unitario ( Obrigatorio )
	0,;                // 5-Valor do Desconto ( Opcional )
	,;                                                                                                                             // 6-Numero da NF Original ( Devolucao/Benef )
	,;                                                                                                                             // 7-Serie da NF Original ( Devolucao/Benef )
	,;                                                                                          // 8-RecNo da NF Original no arq SD1/SD2
	0,;                                                                                                           // 9-Valor do Frete do Item ( Opcional )
	0,;                                                                                                           // 10-Valor da Despesa do item ( Opcional )
	0,;                                                                           // 11-Valor do Seguro do item ( Opcional )
	0,;                                                                                                           // 12-Valor do Frete Autonomo ( Opcional )
	aCols[n,_nPosTot],;// 13-Valor da Mercadoria ( Obrigatorio )
	0,;                                                                                                           // 14-Valor da Embalagem ( Opiconal )
	0,;                                                                                           // 15-RecNo do SB1
	0)                                                                                                            // 16-RecNo do SF4
	
	
	
	nAliqICM 	:= round(MaFisRet(1,'IT_ALIQICM',5,2) ,2 )
	nValICms	:= round(MaFisRet(1,'IT_VALICM',14,2) ,2 )
	
	nAliqIPI 	:= round(MaFisRet(1,"IT_ALIQIPI",5,2) ,2 )
	nValIPI 	:= round(MaFisRet(1,"IT_VALIPI",14,2) ,2 )
	
	nValICMSST 	:= round(MaFisRet(1,'IT_VALSOL',14,2) ,2 )
	
	nValPis		:= round(MaFisRet(1,"IT_VALPS2",14,2) ,2 )
	nValCof		:= round(MaFisRet(1,"IT_VALCF2",14,2) ,2 )
	
	//DIFAL
	nValCmp 	:= noround(MaFisRet(1,"IT_VALCMP",14,2)  )
	nValDif 	:= noround(MaFisRet(1,"IT_DIFAL",14,2)  )
	
	
	
	//	nBaseori := nBaseicm/(SF4->F4_BASEICM/100)
	mafisend()
	
	
	//Retornar Valores Unitários
	
	nQuant := noround(aCols[n][_nPosQtd])
	
	aCols[n][nPValICMS]		:=  round(nValICMS 	/ nQuant      ,2)
	aCols[n][nPAliqICM]		:=	nAliqICM
	aCols[n][nPValICMSST]	:=  round(nValICMSST	/ nQuant   ,2   )
	aCols[n][nPValIPI] 		:=  round(nValIPI		/ nQuant   ,2   )
	//aCols[n][nPValLiq]		:=  round(aCols[n][_nPosTot]  - (nValICMS)  - aCols[n][_nValAcre] - (nValPis) - (nValCof),2)
	aCols[n][nPValLiq]		:=  round(aCols[n][_nPosTot]  - (nValICMS)  - (nValPis) - (nValCof) - (nValCmp) - (nValDif),2)   //giovani.zago 30/0413  valor liquido sem o acrescimo financeiro
	aCols[n][nPosIpi]		:= 	 nAliqIPI
	
	For nCnt := 1 To Len(aCols)
		If !aCols[nCnt,Len(aHeader)+1]
			_nTotPed  +=  aCols[nCnt][nPValLiq]
		EndIf
		//Giovani Zago Markup  31/07/13
		dbSelectArea("SB1")
		SB1->(dbSetOrder(1))
		If SB1->(DbSeek(xFilial("SB1")+aCols[nCnt][_nPosProd]))
			aCols[nCnt][nPosMark] :=  	ROUND(	 (  (	aCols[nCnt][nPValLiq] /aCols[nCnt][_nPosQtd])/ Iif(UPPER(ALLTRIM(SB1->B1_CLAPROD)) = 'C',SB1->B1_XPCSTK,U_SaldoMarkup())) -1,2)
		EndIf
	NEXT
	M->C5_ZVALLIQ  :=   _nTotPed //// Item 2.5 MIT 044
	
	
	
Return

/*====================================================================================\
|Programa  | STFATMAFIS       | Autor | GIOVANI.ZAGO             | Data | 14/01/2013  |
|=====================================================================================|
|Descrição |  STFATMAFIS                                                              |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STFATMAFIS                                                               |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
User Function STFATMAFIS()
	*-----------------------------*
	Local _nPosPrv  := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_PRCVEN"})     // Preco de venda
	Local _nPosPDesc:= aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_DESCONT"})    // Percentual do desconto
	Local _nPosVDesc:= aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_VALDESC"})    // Valor do Desconto
	Local _nPosQtd  := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_QTDVEN"})     // Quantidade
	Local _nPosTot  := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_VALOR"})      // Valor total
	Local _nPosUnt  := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_XPRCLIS"})     // Preço LISTA
	Local _nPosList := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_PRUNIT"})     // Preço Unitário
	Local _nPosProd  := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_PRODUTO"})    // Codigo do produto
	Local _nValAcre  := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_XVALACR"})     	// Valor Acrescimo Financeiro
	Local _nPosTes  := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_TES"})     	// Valor Acrescimo Financeiro  _nPosTes
	
	Local	nPValICMS		:= Ascan(aHeader,{|x| AllTrim(Upper(x[2]))	== "C6_ZVALICM"})			// Posicao do Valor do ICMS
	Local	nPAliqICM  		:= Ascan(aHeader,{|x| AllTrim(Upper(x[2]))	== "C6_ZPICMS"})			// Posicao do Aliq. ICMS
	Local	nPValICMSST		:= Ascan(aHeader,{|x| AllTrim(Upper(x[2]))	== "C6_ZVALIST"})			// Posicao do Valor do ICMS ST
	Local	nPValIPI		:= Ascan(aHeader,{|x| AllTrim(Upper(x[2]))	== "C6_ZVALIPI"})			// Posicao do Valor do IPI
	Local	nPValLiq		:= Ascan(aHeader,{|x| AllTrim(Upper(x[2]))	== "C6_ZVALLIQ"})			// Posicao do Valor do Liquido
	Local _nTotPed := 0
	Local	nAliqICM := 0
	Local	nValICms:= 0
	Local nCnt := 0
	Local	nAliqIPI := 0
	Local	nValIPI := 0
	
	Local	nValICMSST := 0
	
	Local	nValPis	:= 0
	Local	nValCof	:= 0
	
	MaFisSave()
	MaFisEnd()
	MaFisIni(Iif(Empty(M->C5_CLIENT),M->C5_CLIENTE,M->C5_CLIENT),;// 1-Codigo Cliente/Fornecedor
	M->C5_LOJAENT,;		// 2-Loja do Cliente/Fornecedor
	IIf(M->C5_TIPO$'DB',"F","C"),;				// 3-C:Cliente , F:Fornecedor
	M->C5_TIPO,;				// 4-Tipo da NF
	M->C5_TIPOCLI,;		// 5-Tipo do Cliente/Fornecedor
	Nil,;
		Nil,;
		Nil,;
		Nil,;
		"MATA461")
	MaFisAdd(aCols[n,_nPosProd],;                                                     // 1-Codigo do Produto ( Obrigatorio )
	aCols[n,_nPosTes],;                                                                           // 2-Codigo do TES ( Opcional )
	1,;                                                           // 3-Quantidade ( Obrigatorio )
	aCols[n,_nPosPrv],;                                                            // 4-Preco Unitario ( Obrigatorio )
	0,;                // 5-Valor do Desconto ( Opcional )
	,;                                                                                                                             // 6-Numero da NF Original ( Devolucao/Benef )
	,;                                                                                                                             // 7-Serie da NF Original ( Devolucao/Benef )
	,;                                                                                          // 8-RecNo da NF Original no arq SD1/SD2
	0,;                                                                                                           // 9-Valor do Frete do Item ( Opcional )
	0,;                                                                                                           // 10-Valor da Despesa do item ( Opcional )
	0,;                                                                           // 11-Valor do Seguro do item ( Opcional )
	0,;                                                                                                           // 12-Valor do Frete Autonomo ( Opcional )
	aCols[n,_nPosPrv],;// 13-Valor da Mercadoria ( Obrigatorio )
	0,;                                                                                                           // 14-Valor da Embalagem ( Opiconal )
	0,;                                                                                           // 15-RecNo do SB1
	0)                                                                                                            // 16-RecNo do SF4
	
	
	nAliqICM 	:= round(MaFisRet(1,'IT_ALIQICM',5,2) ,2 )
	
	mafisend()
	
	
	
Return  (nAliqICM)

/*====================================================================================\
|Programa  | STRELMAFIS       | Autor | GIOVANI.ZAGO             | Data | 14/01/2013  |
|=====================================================================================|
|Descrição |  STRELMAFIS                                                              |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STRELMAFIS                                                               |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
User Function STRELMAFIS()
	*-----------------------------*
	Local _nPosPrv  := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "UB_VRUNIT"})     // Preco de venda
	Local _nPosProd  := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "UB_PRODUTO"})    // Codigo do produto
	Local _nPosTes  := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "UB_TES"})     	// Valor Acrescimo Financeiro  _nPosTes
	Local _nTotPed := 0
	Local	nAliqICM := 0
	Local	nValICms:= 0
	Local nCnt := 0
	Local	nAliqIPI := 0
	Local	nValIPI := 0
	
	Local	nValICMSST := 0
	
	Local	nValPis	:= 0
	Local	nValCof	:= 0
	
	MaFisSave()
	MaFisEnd()
	MaFisIni(SUA->UA_CLIENTE,;// 1-Codigo Cliente/Fornecedor
	SUA->UA_LOJA,;		// 2-Loja do Cliente/Fornecedor
	"C",;				// 3-C:Cliente , F:Fornecedor
	M->UA_XTIPO,;				// 4-Tipo da NF
	Posicione("sa1",1,xFilial("SA1")+M->UA_CLIENTE+M->UA_LOJA,"A1_TIPO"),;		// 5-Tipo do Cliente/Fornecedor
	Nil,;
		Nil,;
		Nil,;
		Nil,;
		"MATA461")
	MaFisAdd(aCols[n,_nPosProd],;                                                     // 1-Codigo do Produto ( Obrigatorio )
	aCols[n,_nPosTes],;                                                                           // 2-Codigo do TES ( Opcional )
	1,;                                                           // 3-Quantidade ( Obrigatorio )
	aCols[n,_nPosPrv],;                                                            // 4-Preco Unitario ( Obrigatorio )
	0,;                // 5-Valor do Desconto ( Opcional )
	,;                                                                                                                             // 6-Numero da NF Original ( Devolucao/Benef )
	,;                                                                                                                             // 7-Serie da NF Original ( Devolucao/Benef )
	,;                                                                                          // 8-RecNo da NF Original no arq SD1/SD2
	0,;                                                                                                           // 9-Valor do Frete do Item ( Opcional )
	0,;                                                                                                           // 10-Valor da Despesa do item ( Opcional )
	0,;                                                                           // 11-Valor do Seguro do item ( Opcional )
	0,;                                                                                                           // 12-Valor do Frete Autonomo ( Opcional )
	aCols[n,_nPosPrv],;// 13-Valor da Mercadoria ( Obrigatorio )
	0,;                                                                                                           // 14-Valor da Embalagem ( Opiconal )
	0,;                                                                                           // 15-RecNo do SB1
	0)                                                                                                            // 16-RecNo do SF4
	
	
	
	nAliqICM 	:= round(MaFisRet(1,'IT_ALIQICM',5,2) ,2 )
	nValICms	:= round(MaFisRet(1,'IT_VALICM',14,2) ,2 )
	
	nAliqIPI 	:= round(MaFisRet(1,"IT_ALIQIPI",5,2) ,2 )
	nValIPI 	:= round(MaFisRet(1,"IT_VALIPI",14,2) ,2 )
	
	nValICMSST 	:= round(MaFisRet(1,'IT_VALSOL',14,2) ,2 )
	
	nValPis		:= round(MaFisRet(1,"IT_VALPS2",14,2) ,2 )
	nValCof		:= round(MaFisRet(1,"IT_VALCF2",14,2) ,2 )
	
	mafisend()
	
	
	
Return  ({nValIPI,nValICMSST})



/*====================================================================================\
|Programa  | SaldoMarkup         | Autor | GIOVANI.ZAGO          | Data | 14/01/2013  |
|=====================================================================================|
|Descrição |  Retorna saldo do sb2(custo)                                             |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | SaldoMarkup                                                              |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

*---------------------------*
User Function SaldoMarkup()
	*---------------------------*
	Local _aArea	:= GetArea()
	Local cAliasLif  := 'TMPMARKUP'
	Local cQuery     := ' '
	Local  _nQut    := 0
	Local  _nVal    := 0
	Local  _nCust    := 0
	
	
	cQuery := " SELECT B2_COD, B2_LOCAL,B2_FILIAL,B2_QATU,B2_VATU1 ,B2_CMFIM1
	cQuery += " FROM "+RetSqlName("SB2")+" SB2 "
	cQuery += " WHERE SB2.D_E_L_E_T_ = ' '
	cQuery += " AND   SB2.B2_COD   = '"+SB1->B1_COD+"'"
	cQuery += " AND   SB2.B2_LOCAL = '"+SB1->B1_LOCPAD+"'"
	cQuery += " AND   SB2.B2_FILIAL= '"+xFilial("SB2")+"'"
	cQuery += " ORDER BY SB2.R_E_C_N_O_
	
	
	
	cQuery := ChangeQuery(cQuery)
	
	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf
	
	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)
	dbSelectArea(cAliasLif)
	If  Select(cAliasLif) > 0
		(cAliasLif)->(dbgotop())
		While (cAliasLif)->(!Eof())
			
			_nQut 	:= (cAliasLif)->B2_QATU
			_nVal	:= (cAliasLif)->B2_VATU1
			_nCust  := (cAliasLif)->B2_CMFIM1
			
			(cAliasLif)->(DbSkip())
		End
	EndIf
	
	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf
	
	RestArea(_aArea)
Return(round(_nCust,2))

