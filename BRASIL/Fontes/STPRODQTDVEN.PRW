#include 'Protheus.ch'
#include 'RwMake.ch'

/*====================================================================================\
|Programa  | STPRODQTDVEN     | Autor | GIOVANI.ZAGO             | Data | 19/04/2013  |
|=====================================================================================|
|Descrição |  WHEN DO C6_PRODUTO  ; UB_PRODUTO                                        |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STPRODQTDVEN                                                             |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
User Function STPRODQTDVEN()
*-----------------------------*
Local aArea         := GetArea()
Local lRet          := .F.
Local _Lmomat       := IsInCallSteck("TMKA271") .Or. IsInCallSteck("TMKA380") .or. IsInCallSteck("U_STFSVE46")
Local _nPosProd     := aScan(aHeader, { |x| Alltrim(x[2]) == IIF(  _Lmomat,"UB_PRODUTO"    ,"C6_PRODUTO"  	)   })
Local _nPosQtd      := aScan(aHeader, { |x| Alltrim(x[2]) == IIF(  _Lmomat,"UB_QUANT"    ,"C6_QTDVEN"   	)   })
Local _nPosTabe     := aScan(aHeader, { |x| Alltrim(x[2]) == IIF(  _Lmomat,"UB_XTABELA"    ,"C6_QTDVEN"   	)   })  
If ( Type("l410Auto") == "U" .OR. !l410Auto ) 
If _Lmomat 
	If  Empty(Alltrim(aCols[n,_nPosProd] ))  .Or. !Empty(Alltrim(aCols[n,_nPosTabe] )) 
		lRet          := .T.
		//aCols[n,_nPosTabe] := ' ' SE TECLAR ESC TAVA LIBERANDO SEM VALIDAR GIOVANI ZAGO 25/09/15
	EndIf 
Else
	If  Empty(Alltrim(aCols[n,_nPosProd] ))
		lRet          := .T.
	EndIf 
EndIf
EndIf
Return(lRet)


