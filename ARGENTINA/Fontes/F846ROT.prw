#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"

User Function F846ROT()

Local aRot := PARAMIXB[1]

aRot[2, 2] := "U_FINA840()" 

//aadd(aRotina,{'Bot�n Nuevo','Aviso("Atenci�n","Prueba de bot�n",{"OK"},2)' , 0 , 3,0,NIL})

Return(aRot)
