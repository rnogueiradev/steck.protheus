#include 'Protheus.ch'
#include 'RwMake.ch'

/*====================================================================================\
|Programa  | STTRONF         | Autor | GIOVANI.ZAGO              | Data | 01/02/2013  |
|=====================================================================================|
|Descrição |  Valida o armazem para troca de nota						              |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STTRONF                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
User Function STTRONF()
	*-----------------------------*
	
	Local aArea         := GetArea()
	Local lRet          := .t.
	Local cMsg          := ''
	Local _cArmTroc     := GETMV('ST_ARMTROC',,'60')
	Local _nPosLocal    := aScan(aHeader, { |x| Alltrim(x[2]) == "C6_LOCAL"   })
	Local i := 0
	
	
	If ( Type("l410Auto") == "U" .OR. !l410Auto )  .and. !IsInCallSteck("U_STFAT15")
		
		If  M->C5_XTRONF = '1' .And. !('TNF' $ Alltrim(M->C5_ZMOTBLO))
			M->C5_ZBLOQ  := '1'
			M->C5_ZMOTBLO:= Alltrim(M->C5_ZMOTBLO)+'/TNF'
		Endif
		
		For i:= 1 To Len(Acols)
			If !aCols[i,Len(aHeader)+1]
				If 	!(aCols[i,_nPosLocal]  $ _cArmTroc)
					lRet:= .F.
								
				EndIf
			EndIf
		Next i
		If !lRet
			MsgInfo("Armazem Para Troca de Nota tem de ser o "+_cArmTroc)
		EndIf
		
		
	EndIf
Return(lRet)
