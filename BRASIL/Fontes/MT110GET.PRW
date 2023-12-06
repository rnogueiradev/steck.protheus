#INCLUDE "PROTHEUS.CH"

User Function MT110GET()

	Local aPosObj	:= PARAMIXB[1]
	Local nOpcx		:= PARAMIXB[2]
	Local _nX 		:= 0
	Local nPosItem	:= aScan(aHeader,{|x| Trim(x[2])=="C1_ITEM"})
	Local nPosPed	:= aScan(aHeader,{|x| Trim(x[2])=="C1_XPED"})
	Local nPosPrz	:= aScan(aHeader,{|x| Trim(x[2])=="C1_XPRZENT"})

	nPercAum := 20
	nAumCab	:= Int(aPosObj[1,3] * nPercAum / 100)
	aPosObj[1,3] += nAumCab
	aPosObj[2,1] += nAumCab

	If cEmpAnt=="03"
		For _nX:=1 To Len(aCols)
			aCols[_nX][nPosPed] := U_STCOM170("C1_XPED",aCols[_nX][nPosItem])
			aCols[_nX][nPosPrz] := U_STCOM170("C1_XDTENT",aCols[_nX][nPosItem])
		Next
	EndIf

Return(aPosObj) 


