#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWMVCDEF.CH"

/*====================================================================================\
|Programa  | M410FSQL       | Autor | RENATO.OLIVEIRA           | Data | 03/02/2020   |
|=====================================================================================|
|Descrição | 													                      |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function M410FSQL()

	Local _cFiltro := ""

	If !__cUserId $ GetMv("M410FSQL",,"001221#001393#001227#001404")   //Andrea Castro 1227 /// Andriana Campos 1393 // diana.Carvajal 1394
		DbSelectArea("SA3")
		SA3->(DbSetOrder(7))
	
		If SA3->(DbSeek(xFilial("SA3") + __cUserId))
			_cFiltro := " C5_VEND1 == '" + SA3->A3_COD + "' .Or. Posicione('SA1',1,xFilial('SA1')+C5_CLIENTE+C5_LOJACLI,'A1_VEND') == '" + SA3->A3_COD + "'
		Else
			_cFiltro := " C5_XUSRINC == '" + __cUserId + "'"
			MsgAlert("Atencion. Usuario no es un vendedor...")
		EndIf
	Endif

Return(_cFiltro)
