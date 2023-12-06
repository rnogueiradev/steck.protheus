#include 'Protheus.ch'
#include 'RwMake.ch'

/*====================================================================================\
|Programa  | STSPCITY          | Autor | GIOVANI.ZAGO             | Data | 08/09/2015 |
|=====================================================================================|
|Descrição |   Valida cidade de entrga com transportadora steck						  |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STSPCITY                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\=====================================================================================
*/
*-----------------------------*
User Function STSPCITY(_cTransp,_cCity)
	*-----------------------------*
	Local _lRetx    := .T.
	Local k    := 0
	Local _aCity    := {}
	Local _cTrMv    := GetMv("ST_STETRAN",,"000001")
	Local _lReTrans := .F.

	/*
	AaDd(_aCity,{"3503901"})
	AaDd(_aCity,{"3505708"})
	AaDd(_aCity,{"3506607"})
	AaDd(_aCity,{"3509007"})
	AaDd(_aCity,{"3509205"})
	AaDd(_aCity,{"3510609"})
	AaDd(_aCity,{"3513009"})
	AaDd(_aCity,{"3513801"})
	AaDd(_aCity,{"3515004"})
	AaDd(_aCity,{"3515103"})
	AaDd(_aCity,{"3515707"})
	AaDd(_aCity,{"3516309"})
	AaDd(_aCity,{"3516408"})
	AaDd(_aCity,{"3518305"})
	AaDd(_aCity,{"3518800"})
	AaDd(_aCity,{"3522208"})
	AaDd(_aCity,{"3522505"})
	AaDd(_aCity,{"3523107"})
	AaDd(_aCity,{"3525003"})
	AaDd(_aCity,{"3528502"})
	AaDd(_aCity,{"3529401"})
	AaDd(_aCity,{"3530607"})
	AaDd(_aCity,{"3534401"})
	AaDd(_aCity,{"3539806"})
	AaDd(_aCity,{"3543303"})
	AaDd(_aCity,{"3544103"})
	AaDd(_aCity,{"3546801"})
	AaDd(_aCity,{"3547304"})
	AaDd(_aCity,{"3547809"})
	AaDd(_aCity,{"3548708"})
	AaDd(_aCity,{"3548807"})
	AaDd(_aCity,{"3549953"})
	AaDd(_aCity,{"3550308"})
	AaDd(_aCity,{"3552502"})
	AaDd(_aCity,{"3552809"})
	AaDd(_aCity,{"3556453"})
	*/
	AaDd(_aCity,{'3503901'})
	AaDd(_aCity,{'3505708'})
	AaDd(_aCity,{'3506607'})
	AaDd(_aCity,{'3509007'})
	AaDd(_aCity,{'3509205'})
	AaDd(_aCity,{'3510609'})
	AaDd(_aCity,{'3513009'})
	AaDd(_aCity,{'3513801'})
	AaDd(_aCity,{'3515004'})
	AaDd(_aCity,{'3515103'})
	AaDd(_aCity,{'3515707'})
	AaDd(_aCity,{'3516309'})
	AaDd(_aCity,{'3516408'})
	AaDd(_aCity,{'3518305'})
	AaDd(_aCity,{'3518800'})
	AaDd(_aCity,{'3522208'})
	AaDd(_aCity,{'3522505'})
	AaDd(_aCity,{'3523107'})
	AaDd(_aCity,{'3525003'})
	AaDd(_aCity,{'3528502'})
	AaDd(_aCity,{'3529401'})
	AaDd(_aCity,{'3530607'})
	AaDd(_aCity,{'3534401'})
	AaDd(_aCity,{'3539806'})
	AaDd(_aCity,{'3543303'})
	AaDd(_aCity,{'3544103'})
	AaDd(_aCity,{'3546801'})
	AaDd(_aCity,{'3547304'})
	AaDd(_aCity,{'3547809'})
	AaDd(_aCity,{'3548708'})
	AaDd(_aCity,{'3548807'})
	AaDd(_aCity,{'3549953'})
	AaDd(_aCity,{'3550308'})
	AaDd(_aCity,{'3552502'})
	AaDd(_aCity,{'3552809'})
	AaDd(_aCity,{'3556453'})


	If ( Type("l410Auto") == "U" .OR. !l410Auto )

		For k:= 1 To Len(_aCity)

			If _aCity[k,1] = '35'+ Alltrim(_cCity)
				_lReTrans := .T.
				If !(_cTransp $ _cTrMv)
					_lRetx    := .F.
					MsgInfo("Atenção p/ esta Cidade a Transportadora devera ser Steck....!!!!!!")
				EndIf
			EndIf
		Next k

		If !(_lReTrans) .And. (_cTransp $ _cTrMv)
			_lRetx    := .F.
			MsgInfo("Atenção p/ esta Cidade a Transportadora Não devera ser Steck....!!!!!!")
		EndIf
	EndIf



Return (_lRetx)



