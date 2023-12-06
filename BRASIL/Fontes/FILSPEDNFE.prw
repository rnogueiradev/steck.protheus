#include "Protheus.ch"

User Function FILSPEDNFE(PARAMIXB)
Local cRet := cCondicao

If Substr(MV_PAR01,1,1) == '3'
    cRet := cCondicao + "OR F2_FIMP = 'D' " 
EndIf

Return cRet
