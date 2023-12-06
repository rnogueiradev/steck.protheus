#include 'Protheus.ch'
#include 'RwMake.ch'

/*====================================================================================\
|Programa  | STPRODUPLI       | Autor | GIOVANI.ZAGO             | Data | 19/04/2013  |
|=====================================================================================|
|Descrição |  STPRODUPLI                                                              |
|          | Valida produto nao deixa duplicar produto no mesmo pedido ou orçamento   |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STPRODUPLI                                                               |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
User Function STPRODUPLI(_cProd)
	*-----------------------------*
	Local i:= 1
	Private aArea         := GetArea()
	Private lRet          := .T.
	Private _Lmomat       := IsInCallSteck("TMKA271") .Or. IsInCallSteck("TMKA380") .or. IsInCallSteck("U_STFSVE46")
	Private _nPosProd     := aScan(aHeader, { |x| Alltrim(x[2]) == Iif(  _Lmomat,"UB_PRODUTO" ,"C6_PRODUTO"	)   })
	Private _cOpeTran     := GetMv('ST_OPERTRAN',,'94')//TIPO DE OPERAÇÃO NAO ENTRA EM REGRAS COMERCIAIS  ....utiliza preço de custo sb2
	Private _nPosOper	    := aScan(aHeader, { |x| Alltrim(x[2]) == Iif(  _Lmomat,"UB_OPER" ,"C6_OPER"	)   })    	// OPER
	If ( Type("l410Auto") == "U" .OR. !l410Auto )
		If	 n > 1 .and.	!(aCols[n-1,_nPosOper]  $ _cOpeTran )
			For i:= 1 To Len(Acols)
				
				If i <> n
					If 	_cProd  =	aCols[i,_nPosProd]
						lRet:= .F.
					EndIf
				EndIf
				
			Next i
			
			If !lRet
				MsgInfo("Produto Já Digitado no Pedido: "+_cProd)
			EndIf
		EndIf
	EndIf
	Restarea(aArea)
Return(lRet)

