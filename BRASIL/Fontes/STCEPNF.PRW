#include 'Protheus.ch'
#include 'RwMake.ch'

/*====================================================================================\
|Programa  | STCEPNF          | Autor | GIOVANI.ZAGO             | Data | 26/05/2014  |
|=====================================================================================|
|Descri��o |   Valida cep de entrega, vendedor preenche o endere�o e esquecia do cep  |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STCEPNF                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Hist�rico....................................|
\=====================================================================================
*/
*-----------------------------*
User Function STCEPNF()
*-----------------------------*
Local _lRetx    := .T.
Private _Lmomat := IsInCallSteck("TMKA271") .Or. IsInCallSteck("TMKA380") .or. IsInCallSteck("U_STFSVE46")
Private _cEst   := IiF(_Lmomat ,"M->UA_ESTE","M->C5_ZESTE")
Private _cCep   := IiF(_Lmomat ,"M->UA_CEPE","M->C5_ZCEPE")
Private _cMun   := IiF(_Lmomat ,"M->UA_MUNE","M->C5_ZMUNE")
Private _cBai   := IiF(_Lmomat ,"M->UA_BAIRROE","M->C5_ZBAIRRE")
Private _cEnd   := IiF(_Lmomat ,"M->UA_ENDENT","M->C5_ZENDENT")


If ( Type("l410Auto") == "U" .OR. !l410Auto )
	
	If ( /*!Empty(Alltrim(&_cEst))  .Or. */ !Empty(Alltrim(&_cCep))  .Or. !Empty(Alltrim(&_cMun))  .Or. !Empty(Alltrim(&_cBai))  .Or. !Empty(Alltrim(&_cEnd))  )
		Do Case
			/*
			Case   Empty(Alltrim(&_cEst))
			MsgInfo("Aten��o Preencha o Estado de Entrega")
			_lRetx    := .F.
			*/
			Case   Empty(Alltrim(&_cCep)) 
				MsgInfo("Aten��o Preencha o Cep de Entrega")
				_lRetx    := .F.
			Case   Empty(Alltrim(&_cMun))
				MsgInfo("Aten��o Preencha o Municipio de Entrega")
				_lRetx    := .F.
			Case   Empty(Alltrim(&_cBai))
				MsgInfo("Aten��o Preencha o Bairro de Entrega")
				_lRetx    := .F.
			Case   Empty(Alltrim(&_cEnd))
				MsgInfo("Aten��o Preencha o Endere�o de Entrega")
				_lRetx    := .F.
		Endcase
	EndIf
EndIf
Return (_lRetx)



