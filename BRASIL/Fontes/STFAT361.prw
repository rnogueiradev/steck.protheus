#include 'Protheus.ch'
#include 'RwMake.ch'

/*====================================================================================\
|Programa  | STFAT361         | Autor | GIOVANI.ZAGO             | Data | 24/01/2013  |
|=====================================================================================|
|Descrição |   STFAT361      Filtro por Vendedor	                                  |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STFAT361                                                                 |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
User Function STFAT361()
*-----------------------------*

Local _cCod    := __cuserid
Public _cXCodVen361   := ' '

DbSelectArea('SA1')
DbSelectArea('SA3')
SA3->(DbSetOrder(7))
If SA3->(dbSeek(xFilial('SA3')+_cCod))
	If SA3->A3_TPVEND <> 'I'
	        _cXCodVen361:=SA3->A3_COD
			SC5->(dbSetFilter({|| (SC5->C5_VEND1 ==  _cXCodVen361 .or. SC5->C5_VEND3 ==  _cXCodVen361 .or. SC5->C5_VEND4 ==  _cXCodVen361 .or. SC5->C5_VEND5 ==  _cXCodVen361)}," (SC5->C5_VEND1 ==  _cXCodVen361 .or. SC5->C5_VEND3 ==  _cXCodVen361 .or. SC5->C5_VEND4 ==  _cXCodVen361 .or. SC5->C5_VEND5 ==  _cXCodVen361) "))
			SA1->(dbSetFilter({|| SA1->A1_VEND == _cXCodVen361},"SA1->A1_VEND == _cXCodVen361"))
	EndIf
EndIf


Return ()
