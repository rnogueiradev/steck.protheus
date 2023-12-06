#Include 'Protheus.ch'


/*====================================================================================\
|Programa  | TK271SQL         | Autor | GIOVANI.ZAGO             | Data | 01/11/2018  |
|=====================================================================================|
|Descrição |   P.E. TK271SQL Filtro por Vendedor	                                  |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | TK271SQL                                                                 |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
User Function TK271SQL(_cAlias)
*-----------------------------* 
	Local _cFiltro := " "
	Default _cAlias  := ParamIxb[1]


	If _cAlias == "SUA"
	//	_cFiltro:= u_STTMK361()
	EndIf

Return _cFiltro


 
 *-----------------------------*
User Function TK271FIL( cAlias )
*-----------------------------*
	Local cFiltro := ''

	If cAlias == 'SUA'
		cFiltro:= u_XSTTMK361()
	EndIf

Return (cFiltro)

  
*-----------------------------*
User Function XSTTMK361( cFiltro )
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
			_cXCodVen361:=SA3->A3_COD
			_xWhenVend     := .F.
			cFiltro := 'SUA->UA_VEND == "'+ SA3->A3_COD + '"'
			SA1->(dbSetFilter({|| SA1->A1_VEND == _cXCodVen361},"SA1->A1_VEND == _cXCodVen361"))
		EndIf
	EndIf

Return (cFiltro)

 
