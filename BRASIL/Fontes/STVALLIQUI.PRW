#INCLUDE "PROTHEUS.CH"

/*====================================================================================\
|Programa  | STVALLIQUI         | Autor | GIOVANI.ZAGO             | Data | 13/03/2013|
|=====================================================================================|
|Descrição | STVALLIQUI                                                               |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STVALLIQUI                                                               |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
User Function STVALLIQUI()
*-----------------------------*

//Local	nAliqICM	,nValICms	,nAliqIPI,nValIPI	:= 0
//Local	nValICMSST	,nValPis	,nValCof  			:= 0
	Local	nPValLiq		:= Ascan(aHeader,{|x| AllTrim(Upper(x[2]))	== "C6_ZVALLIQ"})			// Posicao do Valor do Liquido
	Local   _nPosTotItem    := aScan(aHeader,{|x| AllTrim(Upper(x[2]))  == "C6_VALOR"})
	Local   nCnt
	Local	_nTotPed		:= 0
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
	Local _nTotPed := 0
	Local	nAliqICM := 0
	Local	nValICms:= 0
	Local nCnt := 0
	Local	nAliqIPI := 0
	Local	nValIPI := 0
	
	Local	nValICMSST := 0
	
	Local	nValPis	:= 0
	Local	nValCof	:= 0
	Local   nValCmp , nValDif 							:= 0
	
	For nCnt := 1 To Len(aCols)
		If !aCols[nCnt,Len(aHeader)+1]
	
	
 
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
			MaFisAdd(aCols[nCnt,_nPosProd],;                                                     // 1-Codigo do Produto ( Obrigatorio )
			aCols[nCnt,_nPosTes],;                                                                           // 2-Codigo do TES ( Opcional )
			aCols[nCnt,_nPosQtd],;                                                           // 3-Quantidade ( Obrigatorio )
			aCols[nCnt,_nPosPrv],;                                                            // 4-Preco Unitario ( Obrigatorio )
			0,;                // 5-Valor do Desconto ( Opcional )
			,;                                                                                                                             // 6-Numero da NF Original ( Devolucao/Benef )
			,;                                                                                                                             // 7-Serie da NF Original ( Devolucao/Benef )
			,;                                                                                          // 8-RecNo da NF Original no arq SD1/SD2
			0,;                                                                                                           // 9-Valor do Frete do Item ( Opcional )
			0,;                                                                                                           // 10-Valor da Despesa do item ( Opcional )
			0,;                                                                           // 11-Valor do Seguro do item ( Opcional )
			0,;                                                                                                           // 12-Valor do Frete Autonomo ( Opcional )
			aCols[nCnt,_nPosTot],;// 13-Valor da Mercadoria ( Obrigatorio )
			0,;                                                                                                           // 14-Valor da Embalagem ( Opiconal )
			0,;                                                                                           // 15-RecNo do SB1
			0)                                                                                                            // 16-RecNo do SF4
	
   //	mafisend()

	
	
			nAliqICM 	:= noround(MaFisRet(1,'IT_ALIQICM',5,2)  )
			nValICms	:= noround(MaFisRet(1,'IT_VALICM',14,2)  )
		
			nAliqIPI 	:= noround(MaFisRet(1,"IT_ALIQIPI",5,2)  )
			nValIPI 	:= noround(MaFisRet(1,"IT_VALIPI",14,2)  )
		
			nValICMSST 	:= noround(MaFisRet(1,'IT_VALSOL',14,2)  )
		
			nValPis		:= noround(MaFisRet(1,"IT_VALPS2",14,2)  )
			nValCof		:= noround(MaFisRet(1,"IT_VALCF2",14,2)  )
		
			//DIFAL
			nValCmp 	:= noround(MaFisRet(1,"IT_VALCMP",14,2)  )
			nValDif 	:= noround(MaFisRet(1,"IT_DIFAL",14,2)  )
		
		
			nQuant := noround(aCols[nCnt][_nPosQtd])

			aCols[nCnt][nPValICMS]		:=  round(nValICMS 	/ nQuant      ,2)
			aCols[nCnt][nPAliqICM]		:=	nAliqICM
			aCols[nCnt][nPValICMSST]	:=  round(nValICMSST	/ nQuant   ,2   )
			aCols[nCnt][nPValIPI] 		:=  round(nValIPI		/ nQuant   ,2   )
			aCols[nCnt][nPValLiq]		:=  round(aCols[nCnt][_nPosTot]  - (nValICMS)  - (nValPis) - (nValCof) - (nValCmp) - (nValDif),2)
			aCols[nCnt][nPosIpi]		:= 	 nAliqIPI

			_nTotPed+= aCols[nCnt][nPValLiq]
		
			mafisend()
		EndIf
	NEXT nCnt
	M->C5_ZVALLIQ  :=   _nTotPed


Return



                                 