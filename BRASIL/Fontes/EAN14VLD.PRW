#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"

/*====================================================================================\
|Programa  | EAN14VLD         | Autor | RENATO.NOGUEIRA          | Data | 05/11/2015  |
|=====================================================================================|
|Descrição | Fonte utilizado para fazer verificação dos códigos EAN14                 |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | EAN14VLD                 	                                              |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function EAN14VLD()

	Local _lRet		:= .T.
	Local _nX		:= 0
	Local _nResul	:= 0
	Private _Lmomat       := IsInCallSteck("TMKA271") .Or. IsInCallSteck("TMKA380") .or. IsInCallSteck("U_STFSVE46")
	Private _cQuant		  := IIF(  _Lmomat,"UB_QUANT" ,"C6_QTDVEN"	)
	Private _nPosQuant    := aScan(aHeader, { |x| Alltrim(x[2]) == _cQuant   })
	Private _cProd		  := IIF(  _Lmomat,"UB_PRODUTO" ,"C6_PRODUTO"	)
	Private _nPosProd     := aScan(aHeader, { |x| Alltrim(x[2]) == _cProd    })
	Private _cItem		  := IIF(  _Lmomat,"UB_ITEM" ,"C6_ITEM"	)
	Private _nPosItem     := aScan(aHeader, { |x| Alltrim(x[2]) == _cItem    })

//Verifica se todos os produtos tem EAN14 cadastrados
	For _nX:=1 To Len(aCols)
		
		If aCols[_nX][Len(aHeader)+1]
			Loop
		EndIf

		DbSelectArea("SB5")
		SB5->(DbSetOrder(1))
		SB5->(DbGoTop())
		If !SB5->(DbSeek(xFilial("SB5")+aCols[_nX][_nPosProd]))
			MsgAlert("Complemento de produto não encontrado para o código: "+AllTrim(aCols[_nX][_nPosProd]))
			Return(.F.)
		EndIf

		If SB5->B5_EAN141==0 .And.;
				SB5->B5_EAN142==0 .And.;
				SB5->B5_EAN143==0 .And.;
				SB5->B5_EAN144==0 .And.;
				SB5->B5_EAN145==0 .And.;
				SB5->B5_EAN146==0 .And.;
				SB5->B5_EAN147==0 .And.;
				SB5->B5_EAN148==0
			MsgAlert("EAN14 não encontrado para o código: "+AllTrim(aCols[_nX][_nPosProd]))
			Return(.F.)
		EndIf
		
		_lRet	:= .F.

		If SB5->B5_EAN141>0
			If (aCols[_nX,_nPosQuant]/SB5->B5_EAN141) - Round((aCols[_nX,_nPosQuant]/SB5->B5_EAN141),0)==0
				_lRet	:= .T.
			EndIf
		EndIf
		If SB5->B5_EAN142>0
			If (aCols[_nX,_nPosQuant]/SB5->B5_EAN142) - Round((aCols[_nX,_nPosQuant]/SB5->B5_EAN142),0)==0
				_lRet	:= .T.
			EndIf
		EndIf
		If SB5->B5_EAN143>0
			If (aCols[_nX,_nPosQuant]/SB5->B5_EAN143) - Round((aCols[_nX,_nPosQuant]/SB5->B5_EAN143),0)==0
				_lRet	:= .T.
			EndIf
		EndIf
		If SB5->B5_EAN144>0
			If (aCols[_nX,_nPosQuant]/SB5->B5_EAN144) - Round((aCols[_nX,_nPosQuant]/SB5->B5_EAN144),0)==0
				_lRet	:= .T.
			EndIf
		EndIf
		If SB5->B5_EAN145>0
			If (aCols[_nX,_nPosQuant]/SB5->B5_EAN145) - Round((aCols[_nX,_nPosQuant]/SB5->B5_EAN145),0)==0
				_lRet	:= .T.
			EndIf
		EndIf
		If SB5->B5_EAN146>0
			If (aCols[_nX,_nPosQuant]/SB5->B5_EAN146) - Round((aCols[_nX,_nPosQuant]/SB5->B5_EAN146),0)==0
				_lRet	:= .T.
			EndIf
		EndIf
		If SB5->B5_EAN147>0
			If (aCols[_nX,_nPosQuant]/SB5->B5_EAN147) - Round((aCols[_nX,_nPosQuant]/SB5->B5_EAN147),0)==0
				_lRet	:= .T.
			EndIf
		EndIf
		If SB5->B5_EAN148>0
			If (aCols[_nX,_nPosQuant]/SB5->B5_EAN148) - Round((aCols[_nX,_nPosQuant]/SB5->B5_EAN148),0)==0
				_lRet	:= .T.
			EndIf
		EndIf

		If !_lRet
			MsgAlert("Quantidade fora do multiplo de EAN14 para o item: "+aCols[_nX][_nPosItem]+" produto: "+AllTrim(aCols[_nX][_nPosProd]))
			Return(.F.)
		EndIf

	Next

Return(_lRet)