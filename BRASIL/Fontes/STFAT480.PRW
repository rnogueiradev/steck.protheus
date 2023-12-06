#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWMVCDEF.CH"

/*====================================================================================\
|Programa  | STFAT480        | Autor | RENATO.OLIVEIRA           | Data | 15/09/2020  |
|=====================================================================================|
|Descrição |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STFAT480()

	Local _nPosOPER := aScan(aHeader, { |x| Alltrim(x[2]) == "C6_OPER"   })
	Local _nPosProd := aScan(aHeader, { |x| Alltrim(x[2]) == "C6_PRODUTO"   })
	Local _nPosQtdV := aScan(aHeader, { |x| Alltrim(x[2]) == "C6_QTDVEN"   })
	Local _nPosLocal:= aScan(aHeader, { |x| Alltrim(x[2]) == "C6_LOCAL"   })

	_cLocal := aCols[n,_nPosLocal]

	//DbSelectArea("SB1")
	//SB1->(DbSetOrder(1))
	//If SB1->(DbSeek(xFilial("SB1")+aCols[nAt,_nPosProd]))
		If _nPosOPER>0
			If AllTrim(aCols[n,_nPosOPER]) $ "94"
				CriaSb2(aCols[n,_nPosProd],"15")
				_cLocal := "15"
			EndIf
		EndIf
	//EndIf

Return(_cLocal)
