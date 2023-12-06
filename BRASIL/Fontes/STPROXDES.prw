#Include 'Protheus.ch'

User Function STPROXDES()


Local cProxDes := ""
Local nProxDes := 0

if INCLUI

cProxDes := GetMv( "ST_PROXDES") 
nProxDes := VAL(substr(cProxDes,4,5))
nProxDes := nProxDes + 1

cProxDes := substr(cProxDes,1,3)+alltrim(str(nProxDes))

Endif

Return (cProxDes)

