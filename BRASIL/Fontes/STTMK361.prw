#include 'Protheus.ch'
#include 'RwMake.ch'

/*====================================================================================\
|Programa  | STTMK361         | Autor | GIOVANI.ZAGO             | Data | 24/01/2013  |
|=====================================================================================|
|Descrição |   STTMK361      Filtro por Vendedor	                                  |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STTMK361                                                                 |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
User Function STTMK361( cFiltro )
*-----------------------------*
	Local _cCod           := __cuserid
	Local cFiltro         := ''
	Public _cXCodVen361   := ' '
	Public _xWhenVend     := .T.

	DbSelectArea('SA1')
	DbSelectArea('SA3')
	SA3->(DbSetOrder(7))
	If SA3->(dbSeek(xFilial('SA3')+_cCod))

		If SA3->A3_TPVEND <> 'I'
		
			If SA3->A3_TPVEND = 'R'
				_cXCodVen361:= SA3->A3_COD
				_xWhenVend  := .F.
				cFiltro 	:= " UA_VEND = '"+ SA3->A3_COD + "'"
				SA1->(dbSetFilter({|| SA1->A1_VEND == _cXCodVen361},"SA1->A1_VEND == _cXCodVen361"))
			ElseIf SA3->A3_TPVEND = 'E'			
				//cFiltro := " UA_CLIENTE||UA_LOJA IN (SELECT A1_COD||A1_LOJA   FROM SA1"+cEmpAnt+"0 SA1 WHERE SA1.D_E_L_E_T_ = ' ' AND A1_VEND = '"+SA3->A3_COD+"'         )"     //Expressão SQL
			    //cFiltro := " EXISTS  (SELECT *   FROM SA1"+cEmpAnt+"0 SA1 WHERE SA1.D_E_L_E_T_ = ' ' AND A1_COD = UA_CLIENTE  AND A1_LOJA = UA_LOJA  AND A1_VEND = '"+SA3->A3_COD+"'         )"     //Expressão SQL
			cFiltro 	:= " UA_VEND = '"+ SA3->A3_COD + "'"
			EndIf
		EndIf
	EndIf
	 

Return (cFiltro)
