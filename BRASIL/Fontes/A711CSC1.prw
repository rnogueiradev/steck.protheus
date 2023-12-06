#INCLUDE "TOTVS.CH"

#DEFINE DS_MODALFRAME 128

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³A711CSC1  ºAutor  ³Microsiga           º Data ³  03/25/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function A711CSC1()

	Local aRet 		:= PARAMIXB
	Local aRegistro := aClone(aDiversos)
	Local cMotivo   :=""
	Local nConta    := 0

	If cFilAnt=="04"

		// Verifico se a data informada faz parte da lista
		nConta := aScan(aRegistro, {|X| X[1]==dtoc(aRet[1][5][2]) })
		IF nConta > 0
			// Adicionado Valdemir Rabelo - 15/07/2019 - Quando entra aqui é uma linha por item
			cMotivo := if(Empty(aRegistro[nConta][3]),"MRP", aRegistro[nConta][3])
			AADD(aRet[1],{"C1_CC"		,"120208"  						,Nil})
			AADD(aRet[1],{"C1_TPSC"		,AllTrim(aRegistro[nConta][2])	,Nil})
			AADD(aRet[1],{"C1_MOTIVO"	,AllTrim(cMotivo) 				,Nil})
		Endif

	ENDIF

	IF (cFilAnt != "04") .OR. (nConta=0)

		AADD(aRet[1],{"C1_MOTIVO"	,"MRP"  	,Nil})
		AADD(aRet[1],{"C1_TPSC"		,"1"  		,Nil})

	EndIf

Return aRet