#include 'Protheus.ch'
#include 'RwMake.ch'

/*====================================================================================\
|Programa  | STOPERFAT          | Autor | GIOVANI.ZAGO           | Data | 04/03/2013  |
|=====================================================================================|
|Descrição | STOPERFAT          VALID SX3 C6_OPER                                     |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STOPERFAT                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
User Function STOPERFAT()
*-----------------------------*
	Private aArea         := GetArea()
	Private lRet          := .F.
	Private _Lmomat       := IsInCallSteck("TMKA271") .Or. IsInCallSteck("TMKA380") .or. IsInCallSteck("U_STFSVE46")
	Private _nPosOper     := aScan(aHeader, { |x| Alltrim(x[2]) == IIF(  _Lmomat,"UB_OPER"    ,"C6_OPER"  	)   })

	If ( Type("l410Auto") == "U" .OR. !l410Auto )
		If n = 1
			If _Lmomat
				aCols[n,_nPosOper]:= '01'
		
				U_STGatilho(aHeader[_nPosOper][2],aCols[n,_nPosOper],n)
			EndIf
		ElseIf n >= 2
			aCols[n,_nPosOper]:= aCols[n-1,_nPosOper]
		
			U_STGatilho(aHeader[_nPosOper][2],aCols[n,_nPosOper],n)
		EndIf
	EndIf

	RestArea(aArea)
Return(lRet)

*-----------------------------*
User Function STOPERWHEN()
*-----------------------------*
	Private aArea         := GetArea()
	Private lRet          := .F.
	Private _Lmomat       := IsInCallSteck("TMKA271") .Or. IsInCallSteck("TMKA380") .or. IsInCallSteck("U_STFSVE46")
	Private _nPosOper     := aScan(aHeader, { |x| Alltrim(x[2]) == IIF(  _Lmomat,"UB_OPER"    ,"C6_OPER"  	)   })
	Private _nPosTes      := aScan(aHeader, { |x| Alltrim(x[2]) == IIF(  _Lmomat,"UB_TES"    ,"C6_TES"  	)   })
	Private _cOPERWHEN    := __cUserId //GetMv("ST_OPERWH",,"000000/000371")+ "/000000/000645"
    
	If ( Type("l410Auto") == "U" .OR. !l410Auto )
		If _Lmomat
			If  n = 1    .And. 	Empty(alltrim(aCols[n,_nPosTes])) .Or. __cUserId $ _cOPERWHEN .And. (n = 1 .or. n = 2)  
				lRet          := .T.
			EndIf
		Else
			If n = 1   .And. 	Empty(alltrim(aCols[n,_nPosTes]))
				lRet          := .T.
			EndIf
		EndIf
		
		
	EndIf

	RestArea(aArea)
Return(lRet)

//IIF(GETMV("ST_C6OPER",,.F.),U_STOPERER(),.T.)         


User Function STOPERER()
	Local _lReOper 			:= .T.
	Private _nPosOper     	:= aScan(aHeader, { |x| Alltrim(x[2]) == "C6_OPER"    })
	
	If GETMV("ST_C6OPER",,.F.)
		DbSelectArea('SA3')
		SA3->(DbSetOrder(7))
		If SA3->(dbSeek(xFilial('SA3')+__cUserId))
			If SA3->A3_TPVEND <> 'I'
				If !(alltrim(aCols[n,_nPosTes]) $ "12/13/19/20/21")
					MsgInfo("Usuario sem acesso para este tipo de Operação")
					_lReOper := .F.
				EndIf
			EndIf
		EndIf
	EndIf
	
Return(_lReOper)

                                                                          