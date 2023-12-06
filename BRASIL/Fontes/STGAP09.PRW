#include 'Protheus.ch'
#include 'RwMake.ch'

/*====================================================================================\
|Programa  | STGAP09         | Autor | GIOVANI.ZAGO              | Data | 01/02/2013  |
|=====================================================================================|
|Descrição |  Validação do gatilho Produto do cliente ou ordem de compra              |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STGAP09                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
User Function STGAP09()
*-----------------------------*

Local aArea         := GetArea()
Local _Lmomat         := IsInCallSteck("TMKA271") .Or. IsInCallSteck("TMKA380") .or. IsInCallSteck("U_STFSVE46") 
Local _nPosXordem	:= aScan(aHeader, { |x| Alltrim(x[2]) == IIF( _Lmomat,"UB_XORDEM"	,"C6_XORDEM"   	)   })
Local _nPosProd     := aScan(aHeader, { |x| Alltrim(x[2]) == IIF( _Lmomat,"UB_PRODUTO"  ,"C6_PRODUTO"	)   })
Local _cOrdem       := ''

If ( Type("l410Auto") == "U" .OR. !l410Auto )
	
	If !_Lmomat
		If !aCols[n,Len(aHeader)+1]
			_cOrdem:=Posicione("SA7",1,xFilial("SA7")+M->C5_CLIENTE+M->C5_LOJACLI+aCols[n,_nPosProd],"A7_CODCLI")
		EndIf
	Else
		If !aCols[n,Len(aHeader)+1]
			_cOrdem:=Posicione("SA7",1,xFilial("SA7")+M->UA_CLIENTE+M->UA_LOJA+aCols[n,_nPosProd],"A7_CODCLI")
		EndIf
	EndIf
EndIf   
If _Lmomat
//Tk273Recalc(,,.T.) 
EndIf
Restarea(aArea)
Return(_cOrdem)

