#INCLUDE "TOTVS.CH"

/*====================================================================================\
|Programa  | TK271COR        | Autor | RENATO.NOGUEIRA           | Data | 27/01/2016  |
|=====================================================================================|
|Descrição |  Alteração de legenda dos orçamentos                                     |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 			                                                                 |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function TK271COR()

	Local _aArea	:= GetArea()

	Local aCores := {}

	If TkGetTipoAte() == "2" //Televendas

		aCores    := { {' SUA->UA_XBLOQ=="3" '		,'BR_PRETO'    },;
			{' (!EMPTY(SUA->UA_NUMSC5) .AND. EMPTY(SUA->UA_EMISNF)) ' 	, 'BR_VERDE'   },;
			{' (EMPTY(SUA->UA_NUMSC5) .AND. SUA->UA_XBLOQ<>"3") ' 	,'BR_AZUL'    }/*{' SUA->UA_NUM=="002266" ' 	,'BR_MARRON'  },;*/,;
			{' !EMPTY(SUA->UA_EMISNF)'	,'BR_VERMELHO'  }}
	            	
	EndIf

	RestArea(_aArea)

Return(aCores)