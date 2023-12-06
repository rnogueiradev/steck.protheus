#include 'Protheus.ch'
#include 'RwMake.ch'

/*====================================================================================\
|Programa  | STTMKI3_7_1      | Autor | GIOVANI.ZAGO             | Data | 14/01/2013  |
|=====================================================================================|
|Descrição |  Validação da comissao                                                   |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STTMKI3_7_1                                                              |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
User Function STTMKI3_7_1(cFuncName)
	*-----------------------------*
	Local aArea         := GetArea()
	Local aAreaSB1      := SB1->(GetArea())
	Local lRet          := .F.
	Local _nPosTotItem  := aScan(aHeader, { |x| Alltrim(x[2]) == "UB_VLRITEM"   })
	Local _nPosPrcven   := aScan(aHeader, { |x| Alltrim(x[2]) == "UB_VRUNIT"    })
	Local _nPosQtdVen	:= aScan(aHeader, { |x| Alltrim(x[2]) == "UB_QUANT"     })
	Local _nPosProd     := aScan(aHeader, { |x| Alltrim(x[2]) == "UB_PRODUTO"   })
	Local _nPosComiss   := aScan(aHeader, { |x| Alltrim(x[2]) == "UB_XVCOMS1"   })
	Local _nPosCom1     := aScan(aHeader, { |x| Alltrim(x[2]) == "UB_XCOMIS1"   })
	Local _nPos2Com     := aScan(aHeader, { |x| Alltrim(x[2]) == "UB_XCOMIS2"   })
	Local _nValComiss   := 0
	Local i    := 0
	
	
	If !Empty(Alltrim(M->UA_VEND)) .and. cFuncName = '371B'
		
		For i:= 1 To Len(Acols)
			
			If !aCols[i,Len(aHeader)+1]
				aCols[i,_nPosCom1]   := u_ValPorComiss(aCols[i,_nPosProd],M->UA_VEND)     //atualiza a porcetagem da comissao por item
				aCols[i,_nPosComiss] := Round(((aCols[i,_nPosTotItem]*aCols[i,_nPosCom1])/100),2)//atualiza a comissao por item
				aCols[i,_nPos2Com]   :=	Posicione("SA3",1,xFilial("SA3")+M->UA_VEND2,"A3_COMIS")
			EndIf
		Next i
		
		
		// Atualiza totais da tela
		Tk273Trigger()
		Tk273FRefresh()
		Tk273TlvImp()
	EndIf
	Restarea(aAreaSB1)
	Restarea(aArea)
Return(lRet)
