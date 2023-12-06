#include 'Protheus.ch'
#include 'RwMake.ch'
#INCLUDE "TBICONN.CH"
#INCLUDE "FWMVCDEF.CH" 

User Function CHKEXEC() // ponto de entrada apos o carregamento do sx3
Local _aArea        := GetArea()
Local _lRet      	:= .T.
Local _cFuncao     	:= SubStr(ParamIXB, 1, At('(',ParamIXB)-1 )

U_STZ1B(Upper("C"),"Rotina ",_cFuncao)  //Giovani Zago Log de Acesso 27/03/2017
	
RestArea(_aArea)
Return(_lRet)

