#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  STfat99    ºAutor  ³Donizeti Lopes      º Data ³  20/12/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Gatilho nos Campos UB_QUANT Seq.003 e C6_QTDVEN SEQ. 001	  º±±
±±º          ³Conforme Item 1.2 da Mit044                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ STECK                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function STfat99()
	
	Local 	lRet := .T.
	Local	nAliqICM	,nValICms	,nAliqIPI,nValIPI	:= 0
	Local	nValICMSST	,nValPis	,nValCof  			:= 0
	
	Local	nPQuant			:= Ascan(aHeader,{|x| AllTrim(Upper(x[2]))	== "C6_QTDVEN"})				// Posicao da Quantidade
	Local	nPValICMS		:= Ascan(aHeader,{|x| AllTrim(Upper(x[2]))	== "C6_ZVALICM"})			// Posicao do Valor do ICMS
	Local	nPAliqICM  		:= Ascan(aHeader,{|x| AllTrim(Upper(x[2]))	== "C6_ZPICMS"})			// Posicao do Aliq. ICMS
	Local	nPValICMSST		:= Ascan(aHeader,{|x| AllTrim(Upper(x[2]))	== "C6_ZVALIST"})			// Posicao do Valor do ICMS ST
	Local	nPValIPI		:= Ascan(aHeader,{|x| AllTrim(Upper(x[2]))	== "C6_ZVALIPI"})			// Posicao do Valor do IPI
	Local	nPValLiq		:= Ascan(aHeader,{|x| AllTrim(Upper(x[2]))	== "C6_ZVALLIQ"})			// Posicao do Valor do Liquido
	Local	nPProduto		:= Ascan(aHeader,{|x| AllTrim(Upper(x[2]))	== "C6_PRODUTO"})			// Posicao do Produto
	Local   _nPosTotItem    := aScan(aHeader,{|x| AllTrim(Upper(x[2]))  == "C6_VALOR"})
	Local   _nPosXVALACR    := aScan(aHeader,{|x| AllTrim(Upper(x[2]))  == "C6_XVALACR"})
	
	
	
	Local   nCnt
	
	Local	_nTotPed		:= 0
	Local 	cProd			:=  aCols[n][nPProduto]
	Local   nValCmp , nValDif 							:= 0
	
	IF !empty(cProd)
		
		nAliqICM 	:= noround(MaFisRet(n,'IT_ALIQICM',5,2)  )
		nValICms	:= noround(MaFisRet(n,'IT_VALICM',14,2)  )
		
		nAliqIPI 	:= noround(MaFisRet(n,"IT_ALIQIPI",5,2)  )
		nValIPI 	:= noround(MaFisRet(n,"IT_VALIPI",14,2)  )
		
		nValICMSST 	:= noround(MaFisRet(n,'IT_VALSOL',14,2)  )
		
		nValPis		:= noround(MaFisRet(n,"IT_VALPS2",14,2)  )
		nValCof		:= noround(MaFisRet(n,"IT_VALCF2",14,2)  )
		
		//DIFAL
		nValCmp 	:= noround(MaFisRet(n,"IT_VALCMP",14,2)  )
		nValDif 	:= noround(MaFisRet(n,"IT_DIFAL",14,2)  )
		//Retornar Valores Unitários
		
		nQuant := noround(aCols[n][nPQuant])
		
		aCols[n][nPValICMS]		:=  round(nValICMS 	/ nQuant      ,2)
		aCols[n][nPAliqICM]		:=	nAliqICM
		aCols[n][nPValICMSST]	:=  round(nValICMSST	/ nQuant   ,2   )
		aCols[n][nPValIPI] 		:=  round(nValIPI		/ nQuant   ,2   )
		aCols[n][nPValLiq]		:=  round(aCols[n][_nPosTotItem]  - nValICMS  - aCols[n][_nPosXVALACR] - nValPis - nValCof - (nValCmp) - (nValDif),2)
		
		
		For nCnt := 1 To Len(aCols)
			If !aCols[nCnt,Len(aHeader)+1]
				_nTotPed+= aCols[nCnt][nPValLiq]
			EndIf
		NEXT
		M->C5_ZVALLIQ  :=   _nTotPed //// Item 2.5 MIT 044
		
		
		Return nAliqICM
	Endif
	
Return

