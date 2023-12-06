#include 'Protheus.ch'
#include 'RwMake.ch'

/*====================================================================================\
|Programa  | STMATR540      | Autor | GIOVANI.ZAGO               | Data | 15/02/2013  |
|=====================================================================================|
|Descrição | Validação do sx1 do matr540, vendedor interno e externo                  |
|          | Filtro do sxB do matr540, vendedor interno e externo                     |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STMATR540                                                                |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

*---------------------------------------------------*
User Function STMATR540()
*---------------------------------------------------*

Local aArea      := GetArea()

If Pergunte("MTR540",.T.)
	
	DbSelectArea('SA3')
	SA3->(DbSetOrder(7))
	If SA3->(dbSeek(xFilial('SA3')+__cuserid))
		If SA3->A3_TPVEND <> 'I'  .And. (SA3->A3_COD <> MV_PAR04 .Or.  SA3->A3_COD <> MV_PAR05)
			msgInfo(alltrim(SA3->A3_NREDUZ)+'   Utilize Seu Codigo De Vendedor ( '+ SA3->A3_COD +' ) !!!!')
			Return(.T.)
		EndIf
	EndIf
	
	MATR540()
EndIf

Restarea(aArea)
Return()
