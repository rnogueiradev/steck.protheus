#INCLUDE "PROTHEUS.CH"
#include 'RwMake.ch'
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTTMKG01  บAutor  ณDonizeti Lopes      บ Data ณ  20/12/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณGatilho nos Campos UB_QUANT Seq.003 e C6_QTDVEN SEQ. 001	  บฑฑ
ฑฑบ          ณConforme Item 1.2 da Mit044                                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ STECK                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
/****************************************
<<<< ALTERAวรO >>>>
A็ใo.........: Quando ้ informado um desconto no item, este valor nใo estแ sendo aplicado nos impostos.
.............: Corrigir os campos para que o valor correto seja o Valor Unitแrio - Desconto
Desenvolvedor: Marcelo Klopfer Leme - SIGAMAT
Data.........: 10/01/2022
Chamados.....: 20220110000690
****************************************/
USER FUNCTION STTMKG01(cOpc)
LOCAL nCnt
LOCAL lRet := .T.
LOCAL aArea	:= GetArea()
LOCAL _nStIc := 0
LOCAL _nTotPed     := 0
LOCAL nPQuant      := aScan(aHeader,{|x| ALLTRIM(Upper(x[2]))	== "UB_QUANT"   })	// Posicao da Quantidade
LOCAL nPosMark     := aScan(aHeader,{|x| ALLTRIM(Upper(x[2]))	== "UB_ZMARKUP" })
LOCAL _nPosTes     := aScan(aHeader,{|x| ALLTRIM(Upper(x[2])) == "UB_TES"     })
LOCAL nPValIPI     := aScan(aHeader,{|x| ALLTRIM(Upper(x[2]))	== "UB_ZVALIPI" })	// Posicao do Valor do IPI
LOCAL nPValLiq     := aScan(aHeader,{|x| ALLTRIM(Upper(x[2]))	== "UB_ZVALLIQ" })	// Posicao do Valor do Liquido
LOCAL nPValICMS    := aScan(aHeader,{|x| ALLTRIM(Upper(x[2]))	== "UB_ZVALICM" })	// Posicao do Valor do ICMS
LOCAL _nPosUnit    := aScan(aHeader,{|x| ALLTRIM(Upper(x[2])) == "UB_VRUNIT"  })
LOCAL nPAliqICM    := aScan(aHeader,{|x| ALLTRIM(Upper(x[2]))	== "UB_ZPICMS"  })	// Posicao do Aliq. ICMS
LOCAL nPProduto    := aScan(aHeader,{|x| ALLTRIM(Upper(x[2]))	== "UB_PRODUTO" })	// Posicao do Produto
LOCAL _nPosZipi    := aScan(aHeader,{|x| ALLTRIM(Upper(x[2])) == "UB_ZIPI"    })
LOCAL nPValICMSST  := aScan(aHeader,{|x| ALLTRIM(Upper(x[2]))	== "UB_ZVALIST" })	// Posicao do Valor do ICMS ST
LOCAL _nPosXVALACR := aScan(aHeader,{|x| ALLTRIM(Upper(x[2])) == "UB_XVALACR" })
LOCAL _nPosTotItem := aScan(aHeader,{|x| ALLTRIM(Upper(x[2])) == "UB_VLRITEM" })	
LOCAL nAliqICM,nValICms,nAliqIPI,nValIPI,nValICMSST,nValPis,nValCof,nValCmp,nValDif := 0
LOCAL cProd	:=  aCols[n][nPProduto]

	IF !empty(cProd)

		aCols[n][nPValICMSST]	:= 0
		nQuant := noround(aCols[n][nPQuant])
		MaFisRef("IT_QUANT","TK273",nQuant)

		/****************************************
		<<<< ALTERAวรO >>>>
		A็ใo.........: Estou trocando a chamada do total e passando o cแlculo de quantidade * valor unitแrio 
		Desenvolvedor: Marcelo Klopfer Leme - SIGAMAT
		Data.........: 10/01/2022
		Chamados.....: 20220110000690
		///MaFisRef("IT_VALMERC","TK273",aCols[n,_nPosTotItem])
		****************************************/
		MaFisRef("IT_VALMERC","TK273",(nQuant * aCols[n][_nPosUnit]))

		nAliqICM 	:= noround(MaFisRet(n,'IT_ALIQICM', 5,2))
		nValICms	:= noround(MaFisRet(n,'IT_VALICM' ,14,2))

		nAliqIPI 	:= noround(MaFisRet(n,"IT_ALIQIPI", 5,2))
		nValIPI 	:= noround(MaFisRet(n,"IT_VALIPI" ,14,2))
		//DIFAL
		nValCmp 	:= noround(MaFisRet(n,"IT_VALCMP",14,2))
		nValDif 	:= noround(MaFisRet(n,"IT_DIFAL" ,14,2))
		
		//ICMS ST Giovani Zago 23/04/15 *********************************************************************************
		If nQuant = 1 .And. GetMv("ST_TMKG01",,.F.)
			_nStIc := aCols[n,_nPosTotItem]
			MaFisRef("IT_QUANT","TK273",10)

			/****************************************
			<<<< ALTERAวรO >>>>
			A็ใo.........: Estou trocando a chamada do total e passando o cแlculo de quantidade * valor unitแrio 
			Desenvolvedor: Marcelo Klopfer Leme - SIGAMAT
			Data.........: 10/01/2022
			Chamados.....: 20220110000690
			////MaFisRef("IT_VALMERC","TK273",(aCols[n,_nPosTotItem]*10))
			****************************************/
			MaFisRef("IT_VALMERC","TK273",((nQuant * aCols[n][_nPosUnit]) * 10))
			nValICMSST 	:= (noround(MaFisRet(n,'IT_VALSOL',14,3)  ) / 10)

			MaFisRef("IT_QUANT","TK273",1)
			MaFisRef("IT_VALMERC","TK273",_nStIc)

		Else

			nValICMSST 	:= noround(MaFisRet(n,'IT_VALSOL',14,3)  )

		EndIf

		If GetMv("ST_FISMAE",,.F.)
			MaColsToFis(aHeader	, aCols	, 	, "TK273"	,.T.		)
		EndIf
		nValPis		:= noround(MaFisRet(n,"IT_VALPS2",14,2)  )
		nValCof		:= noround(MaFisRet(n,"IT_VALCF2",14,2)  )

		//Retornar Valores Unitแrios
		aCols[n][nPValICMS]		:=  round(nValICMS 	/ nQuant      ,2)
		aCols[n][nPAliqICM]		:=	nAliqICM
		aCols[n][nPValICMSST]	:=  round(nValICMSST	/ nQuant   ,2   )
		aCols[n][nPValIPI] 		:=  round(nValIPI		/ nQuant   ,2   )
		//	aCols[n][nPValLiq]		:=  round(aCols[n][_nPosTotItem]  - nValICMS  - aCols[n][_nPosXVALACR] - nValPis - nValCof,2)
		aCols[n][nPValLiq]		:=  round(aCols[n][_nPosTotItem]  - nValICMS   - nValPis - nValCof - nValCmp - nValDif,2)  //giovani.zago 30/04/13 tira o valor do acrescimo
		aCols[n][_nPosZipi]		:= 	nAliqIPI

		For nCnt := 1 To Len(aCols)
			If !aCols[nCnt,Len(aHeader)+1]
				_nTotPed+= aCols[nCnt][nPValLiq]
			EndIf
			/*	
			//Giovani Zago Markup  31/07/13
			dbSelectArea("SB1")
			SB1->(dbSetOrder(1))
			If SB1->(DbSeek(xFilial("SB1")+aCols[nCnt][nPProduto]))
			aCols[nCnt][nPosMark] :=  	ROUND( (  (	aCols[nCnt][nPValLiq] /aCols[nCnt][nPQuant])/ Iif(UPPER(ALLTRIM(SB1->B1_CLAPROD)) = 'C',SB1->B1_XPCSTK,U_SaldoMarkup())) -1 ,2)
			EndIf
			*/
			aCols[nCnt][nPosMark] := 	ROUND( (  aCols[n][nPValLiq]/ nQuant /U_STCUSTO(aCols[n][nPProduto])    ),2)


		NEXT
		M->UA_ZVALLIQ  :=   _nTotPed //// Item 2.5 MIT 044
		Tk273Trigger()
		//	_oDlgDefault := GetWndDefault()
		//	aEval(_oDlgDefault:aControls,{|x| x:Refresh()})
		Tk273FRefresh()
		Tk273TlvImp()


		Return nAliqICM
	Endif

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTTMKVAL   บAutor  ณJoao Rinaldi       บ Data ณ  22/09/2015 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo para atualizar o valor lํquido do cabe็alho da      บฑฑ
ฑฑบ          ณ cota็ใo, campo(UA_ZVALLIQ) a partir do vlr lํquido do acolsบฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Steck Industria Eletrica Ltda.                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑบRotina    ณ TK271BOK.prw                                               บฑฑ
ฑฑบNome      ณ Ponto de Entrada chamado no botใo "OK" da barra de         บฑฑ
ฑฑบ          ณ ferramentas da tela de atendimento do Call Center, antes   บฑฑ
ฑฑบ          ณ da fun็ใo de grava็ใo.                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function STTMKVAL()

	Local 	lRet := .T.
	Local	nAliqICM	,nValICms	,nAliqIPI,nValIPI	:= 0
	Local	nValICMSST	,nValPis	,nValCof  			:= 0

	Local	nPQuant			:= Ascan(aHeader,{|x| ALLTRIM(Upper(x[2]))	== "UB_QUANT"})				// Posicao da Quantidade
	Local	nPValICMS		:= Ascan(aHeader,{|x| ALLTRIM(Upper(x[2]))	== "UB_ZVALICM"})			// Posicao do Valor do ICMS
	Local	nPAliqICM  		:= Ascan(aHeader,{|x| ALLTRIM(Upper(x[2]))	== "UB_ZPICMS"})			// Posicao do Aliq. ICMS
	Local	nPValICMSST		:= Ascan(aHeader,{|x| ALLTRIM(Upper(x[2]))	== "UB_ZVALIST"})			// Posicao do Valor do ICMS ST
	Local	nPValIPI		:= Ascan(aHeader,{|x| ALLTRIM(Upper(x[2]))	== "UB_ZVALIPI"})			// Posicao do Valor do IPI
	Local	nPValLiq		:= Ascan(aHeader,{|x| ALLTRIM(Upper(x[2]))	== "UB_ZVALLIQ"})			// Posicao do Valor do Liquido
	Local	nPProduto		:= Ascan(aHeader,{|x| ALLTRIM(Upper(x[2]))	== "UB_PRODUTO"})			// Posicao do Produto
	Local   _nPosTotItem    := aScan(aHeader,{|x| ALLTRIM(Upper(x[2]))  == "UB_VLRITEM"})
	Local   _nPosXVALACR    := aScan(aHeader,{|x| ALLTRIM(Upper(x[2]))  == "UB_XVALACR"})
	Local   _nPosZipi       := aScan(aHeader,{|x| ALLTRIM(Upper(x[2]))  == "UB_ZIPI"})
	Local   _nPosTes        := aScan(aHeader,{|x| ALLTRIM(Upper(x[2]))  == "UB_TES"})
	Local   _nPosUnit        := aScan(aHeader,{|x| ALLTRIM(Upper(x[2]))  == "UB_VRUNIT"})

	Local   nCnt
	Local	nPosMark	    := Ascan(aHeader,{|x| ALLTRIM(Upper(x[2]))	== "UB_ZMARKUP"})
	Local	_nTotPed		:= 0
	Local 	cProd			:=  aCols[n][nPProduto]
	Local	_nStIc		:= 0
	Local aArea		:= GetArea()

	For nCnt := 1 To Len(aCols)
		If !aCols[nCnt,Len(aHeader)+1]
			_nTotPed+= aCols[nCnt][nPValLiq]
		EndIf
	Next

	M->UA_ZVALLIQ  :=   _nTotPed

	RestArea(aArea)
Return lRet




//giovani zago fiscal sf7 excessao fiscal erro no call center
User Function MAEXCEFISC()

	Local _aRet   := {}
	Local _aPar01 := PARAMIXB[1]
	Local _aPar02 := PARAMIXB[2]
	Local _nX 	  := 0

	If GetMv("ST_FISMAE",,.F.) .And. Altera .And. M->UA_ZCONSUM = '1' .And. SA1->A1_TIPO = 'F'
		For _nX:=1 To Len(_aPar01)

			If _nX = 4 .Or. _nX = 5 .Or. _nX = 7
				Aadd(_aRet," ")
			ElseIf _nX = 3 .Or. _nX = 6  
				Aadd(_aRet,0)
			Else
				Aadd(_aRet,_aPar01[_nX])
			EndIf


		Next _nX
	EndIf
Return (_aRet)


