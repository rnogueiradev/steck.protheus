#include 'Protheus.ch'
#include 'RwMake.ch'

/*====================================================================================\
|Programa  | STQTDTES         | Autor | GIOVANI.ZAGO             | Data | 01/03/2013  |
|=====================================================================================|
|Descrição |   When c6_qtdven          		    	                                  |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STQTDTES           U_STQTDTES()                                          |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
User Function STQTDTES()
*-----------------------------*
Local _Lmomat   := IsInCallSteck("TMKA271") .Or. IsInCallSteck("TMKA380") .or. IsInCallSteck("U_STFSVE46")
Local _nPosTes  := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == IIF(  _Lmomat,"UB_TES"    ,"C6_TES"  	)   })
Local _lRet     := .T.
Local _nPosTabe     := aScan(aHeader, { |x| Alltrim(x[2]) == IIF(  _Lmomat,"UB_XTABELA"    ,"C6_QTDVEN"   	)   })

If ( Type("l410Auto") == "U" .OR. !l410Auto )
	
	If alltrim(aCols[n][_nPosTes]) = ''
		msginfo("Tes Em Branco, Preencha a Tes")
		_lRet    := .F.
	EndIf
	
	If _Lmomat
		If  !Empty(Alltrim(aCols[n,_nPosTabe] ))
			_lRet          := .F.
		EndIf     
		
	EndIf
EndIf
Return  (_lRet)

