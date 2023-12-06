#include 'Protheus.ch'
#include 'RwMake.ch'

/*====================================================================================\
|Programa  | MA410LEG         | Autor | RENATO.OLIVEIRA          | Data | 06/08/2018  |
|=====================================================================================|
|Descrição |  Alterar legenda do pedido de venda                                      |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function MA410LEG()

	Local _nX
	Local _aLegenda := {}
	/*
	For _nX:=1 To Len(PARAMIXB)
		AADD(_aLegenda,{PARAMIXB[_nX][1],PARAMIXB[_nX][2]})
	Next
	*/

	AADD(_aLegenda,{"ENABLE"		,"Pedido de venta abierto"})
	AADD(_aLegenda,{"DISABLE"		,"Pedido de venta facturado"})
	AADD(_aLegenda,{"BR_AMARELO"	,"Pedido de venta aprobado"})
	AADD(_aLegenda,{"BR_AZUL"		,"Pedido de venta bloquedo por regra"})
	AADD(_aLegenda,{"BR_LARANJA"	,"Pedido de venta bloquedo por verba"})
	AADD(_aLegenda,{"BR_CINZA"		,"Pedido de venta remitido"})
	AADD(_aLegenda,{"BR_MARROM"		,"Pedido de venta en analice financieira"})
	AADD(_aLegenda,{"BR_BRANCO"		,"Pedido de venta rechazado"})

Return(_aLegenda)

/*====================================================================================\
|Programa  | MA410COR         | Autor | RENATO.OLIVEIRA          | Data | 06/08/2018  |
|=====================================================================================|
|Descrição |  Alterar legenda do pedido de venda                                      |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function MA410COR()

	Local _nX
	Local _aCores := {}

	Local _aCores 	:=	{	{ "Empty(C5_LIBEROK).And.Empty(C5_NOTA) .And. Empty(C5_BLQ)"		,	'ENABLE'		},;		//Pedido de venta Abierto
							{ "!Empty(C5_NOTA).Or.C5_LIBEROK=='E' .And. Empty(C5_BLQ)"			,	'DISABLE'		},;		//Pedido de venta facturado
							{ "!Empty(C5_LIBEROK).And.Empty(C5_NOTA).And. Empty(C5_BLQ) .And. Empty(C5_XSTAFIN) "		,	'BR_AMARELO'	},;		//Pedido de venta aprobado
							{ "C5_BLQ == '1'"													,	'BR_AZUL'		},;		//Pedido Bloquedo por regra
							{ "C5_BLQ == '2'"													,	'BR_LARANJA'	},;		//Pedido Bloquedo por verba
							{ "AllTrim(C5_NOTA)=='REMITO' "										,	'BR_CINZA'		},;     //Pedido de venta remitido
							{ "!Empty(C5_LIBEROK) .And. Empty(C5_NOTA) .And. C5_XSTAFIN=='B' ",	'BR_MARROM'		},;		//Pedido de venta en analice financieira
							{ "!Empty(C5_LIBEROK) .And. Empty(C5_NOTA) .And. C5_XSTAFIN=='R' ",	'BR_BRANCO'		}}		//Pedido de venta rechazado

/*
	For _nX:=1 To Len(PARAMIXB)
		If AllTrim(PARAMIXB[_nX][2])=="BR_AMARELO"
			AADD(_aCores,{PARAMIXB[_nX][1]+" .And. Empty(C5_XSTAFIN)","BR_AMARELO"})
		Else
			AADD(_aCores,{PARAMIXB[_nX][1],PARAMIXB[_nX][2]})
		EndIf
	Next

	AADD(_aCores,{"!Empty(C5_LIBEROK) .And. Empty(C5_NOTA) .And. !Empty(C5_XSTAFIN)","BR_MARROM"})
*/

Return(_aCores)