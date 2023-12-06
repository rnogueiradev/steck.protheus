#include 'protheus.ch'
#include 'parmtype.ch'

User Function LocxPE17()
	Local nPos2 := 0
	
    If ISINCALLSTACK("MATA465N")
    	If SX2->X2_CHAVE == "SD1"
    		nPos2 := aScan(aHeader,{|x| AllTrim(x[2]) = "D1_VALDESC"})
    		aCols[n][nPos2] := 0
    	EndIf
    EndIf
Return(.T.)


User Function LocxPE26()
//ALERT("PE: LocxPE(26)")	
Return(.T.)

User Function LocxPE27()
//ALERT("PE: LocxPE(27)")	
Return(.T.)
