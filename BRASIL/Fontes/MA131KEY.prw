#include "protheus.ch"
#include "rwmake.ch"
#include "tbiconn.ch"
#include "ap5mail.ch"
#Define CR chr(13)+chr(10)

User Function MA131KEY()

	Local cRet := ''
	Local cKey := ParamIXB[1] 

	cRet := cKey+'+C1_NUM+C1_ITEM'

Return cRet


