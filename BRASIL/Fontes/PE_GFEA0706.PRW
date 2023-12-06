#INCLUDE "FWMVCDEF.CH" 
#include "totvs.ch"

user function GFEA0706

    local aRotinas  := PARAMIXB[1]

    aadd(aRotinas, {"Aglut.Tit.Pagar", "U_STF00101()",0,11,0, nil, nil, nil})

return(aRotinas)
