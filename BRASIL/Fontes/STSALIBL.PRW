#include 'Protheus.ch'
#include 'RwMake.ch'

/*====================================================================================\
|Programa  | STSALIBL        | Autor | GIOVANI.ZAGO              | Data | 01/02/2013  |
|=====================================================================================|
|Descrição |  STSALIBL     												              |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STSALIBL                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
User Function STSALIBL()
	*-----------------------------*
	
	Local aArea         := GetArea()
	Local lRet          := .T.
	Local _nPosItem     := aScan(aHeader, { |x| Alltrim(x[2]) == "C6_ITEM"    })
	Local _nPosProd     := aScan(aHeader, { |x| Alltrim(x[2]) == "C6_PRODUTO" })
	Local _nPosLoc      := aScan(aHeader, { |x| Alltrim(x[2]) == "C6_LOCAL"   })
	Local _nPosQtdVen	:= aScan(aHeader, { |x| Alltrim(x[2]) == "C6_QTDVEN"  })
	Local _nPosOper	    := aScan(aHeader, { |x| Alltrim(x[2]) == "C6_OPER"    })
	Local _nVaPed       := 0
	Local _cOper        := GetMv("ST_IBLTRAN",,'88,89,94')
	Local i := 0
	
	If ( Type("l410Auto") == "U" .OR. !l410Auto )  .and. !IsInCallSteck("U_STFAT15")
		
		For i:= 1 To Len(Acols)
			If !aCols[i,Len(aHeader)+1]
				If aCols[i,_nPosOper]  $ _cOper
					
					_nVaPed:=	u_versaldo(aCols[i,_nPosProd])
					
					If  aCols[i,_nPosQtdVen] > _nVaPed .And. aCols[n,_nPosLoc] $ "01#03"
						lRet:= .F.
						MSGINFO('Quantidade nao disponivel Item: '+aCols[i,_nPosItem] +' Produto: '+aCols[i,_nPosProd] +' Disponivel: '+cvaltochar(_nVaPed))
					EndIf
				EndIf
			EndIf
		Next i
	EndIf
	Restarea(aArea)
Return(lRet)

