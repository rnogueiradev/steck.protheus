#include 'Protheus.ch'
#include 'RwMake.ch'

/*====================================================================================\
|Programa  | STPEDLOCAL       | Autor | GIOVANI.ZAGO             | Data | 19/04/2013  |
|=====================================================================================|
|Descrição |  WHEN DO C6_LOCALIZ                                                      |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STPEDLOCAL                                                               |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
User Function STPEDLOCAL()
*-----------------------------*
Local aArea         := GetArea()
Local lRet          := .F.
Local _nPosOper	    := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_OPER"})      	// PRC COND
Local _cOpeTran     := GetMv('ST_OPERTRAN',,'94')//TIPO DE OPERAÇÃO transferencia  ....utiliza preço de custo sb2

If ( Type("l410Auto") == "U" .OR. !l410Auto )
	If  aCols[n,_nPosOper] $ _cOpeTran   .Or. !Empty(Alltrim(M->C5_XTRONF)) .Or. cFilAnt=="05"
		lRet          := .T.
	EndIf
	
EndIf
Return(lRet)

/*====================================================================================\
|Programa  | STPEDLOCAL       | Autor | GIOVANI.ZAGO             | Data | 19/04/2013  |
|=====================================================================================|
|Descrição |  WHEN DO C6_LOCALIZ                                                      |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STCAMWHEM                                                               |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
User Function STCAMWHEM()
*-----------------------------*
Local aArea         := GetArea()
Local lRet          := .T.
Local _Lmomat       := IsInCallSteck("TMKA271") .Or. IsInCallSteck("TMKA380") .or. IsInCallSteck("U_STFSVE46")
Local _nPosCamp    := aScan(aHeader, { |x| Alltrim(x[2]) == IIF(  _Lmomat,"UB_XCAMPA"    ,"C6_XCAMPA"  	)   })
  
If ( Type("l410Auto") == "U" .OR. !l410Auto )
	If  aCols[n,_nPosCamp] <> 0
		lRet          := .F.
	EndIf
EndIf
Return(lRet)

//iif(__cuserid $ '000000/000231',u_STCAMWHEM(),.t.)
