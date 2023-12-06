#include "rwmake.ch"
#include "protheus.ch"

User Function MT120GET()

	Local aPosObj     := PARAMIXB[1]
	Local nOpcx       := PARAMIXB[2]

	//aPosObj := If(ValType(aPosObjPE:=ExecBlock("MT120GET",.F.,.F.,{aPosObj,nOpcx}))== "A",aPosObjPE,aPosObj)
	nPercAum := 15
	nAumCab	:= Int(aPosObj[1,3] * nPercAum / 100)
	aPosObj[1,3] += nAumCab
	aPosObj[2,1] += nAumCab

Return(aPosObj)

