#include 'Protheus.ch'
#include 'RwMake.ch'

/*====================================================================================\
|Programa  | STPROMOMAR       | Autor | GIOVANI.ZAGO             | Data | 30/10/2014  |
|=====================================================================================|
|Descrição | Verifica codigo de promoção		                                      |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STPROMOMAR                                                               |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
User Function STPROMOMAR()
	*-----------------------------*
	Local i:= 1
	Private aArea         := GetArea()
	Private lRet          := .T.
	Private _Lmomat       := IsInCallSteck("TMKA271") .Or. IsInCallSteck("TMKA380") .or. IsInCallSteck("U_STFSVE46")
	Private _nPosQtdVen	  := aScan(aHeader, { |x| Alltrim(x[2]) == IIF(  _Lmomat,"UB_QUANT"	  ,"C6_QTDVEN"  )   })
	Private _nPosProd     := aScan(aHeader, { |x| Alltrim(x[2]) == IIF(  _Lmomat,"UB_PRODUTO" ,"C6_PRODUTO"	)   })
	Private _nPosCfo   	  := aScan(aHeader, { |x| AllTrim(x[2]) == IIF(  _Lmomat,"UB_CF"      ,"C6_CF"     	)   })
	Private _nCod01       := 0
	Private _nCod02       := 0
	Private _nCod03       := 0
	
	If ( Type("l410Auto") == "U" .OR. !l410Auto )
		
		For i:= 1 To Len(Acols)
			If 	Alltrim(aCols[n,_nPosCfo]) $ "('5101','5102','5109','5116','5117','5118','5119','5122','5123','5401','5403','5501','5502','6101','6102','6107','6108','6109','6110','6111','6114','6116','6117','6118','6119','6122','6123','6401','6403','6501','6502','7101','7102')"
				If !aCols[i,Len(aHeader)+1]
					If 	Alltrim(aCols[n,_nPosProd]) = 'FCON1114'
						_nCod01:= 	aCols[n,_nPosQtdVen]
					ElseIf 	Alltrim(aCols[n,_nPosProd]) = 'DBCON1114'
						_nCod02:= 	aCols[n,_nPosQtdVen]
					ElseIf 	Alltrim(aCols[n,_nPosProd]) = 'CAKITD'
						_nCod03:= 	aCols[n,_nPosQtdVen]
					EndIf
				EndIf
			EndIf
		Next i
		If _nCod01+_nCod02 <> _nCod03
			MsgInfo(" Pedido/Orçamento que contenham o material promocional FCON1114 e/ou DBCON1114, obrigatoriamente deve conter o material CAKITD na mesma qtde dos itens anteriores para ser finalizado.")
			lRet:= .F.
		EndIf
	EndIf
	Restarea(aArea)
Return(lRet)
