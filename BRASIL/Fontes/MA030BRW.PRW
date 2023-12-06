#include 'Protheus.ch'
#include 'RwMake.ch'

/*====================================================================================\
|Programa  | MA030BRW         | Autor | GIOVANI.ZAGO             | Data | 24/01/2013  |
|=====================================================================================|
|Descrição |   MA030BRW      Filtro por Vendedor	                                  |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | MA030BRW                                                                 |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
User Function MA030BRW(  )
*-----------------------------*
Local _cCod   := __cuserid
Local cFiltra := '' 

If Type("_cDipVend") == "U"
	Public _cDipVend := ''
EndIf

DbSelectArea('SA3')
SA3->(DbSetOrder(7))
If SA3->(dbSeek(xFilial('SA3')+_cCod))
	If SA3->A3_TPVEND <> 'I'
		_cDipVend :=  SA3->A3_COD
		//	_cDipVend :=  " SA1->A1_VEND == '"+SA3->A3_COD +"' "
		SA1->(dbSetFilter({|| SA1->A1_VEND == _cDipVend},"SA1->A1_VEND == _cDipVend"))
		//cFiltra    := "SA1->A1_VEND == '"+_cDipVend+"' "
	EndIf
EndIf
Return()
