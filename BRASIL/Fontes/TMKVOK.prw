#INCLUDE "PROTHEUS.CH"
#INCLUDE "FILEIO.CH"
#INCLUDE "APWEBSRV.CH"
#include 'RwMake.ch'
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TMKVOK    ºAutor  ³Microsiga           º Data ³  02/03/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de Entrada apos a gravacao do orcamento do TELEVENDAS º±±
±±º          ³TMKA273D                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function TMKVOK()

	U_STFSVE43()

Return



User Function TMKLINOK()

	Local _nPosIpc  := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "UB_ITEMPC" })
	Local _nPosNpc  := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "UB_NUMPCOM" })
	Local _lRet		:= .T.

	If M->UA_OPER=="1"
		If !(Empty(Alltrim(acols[n][_nPosIpc]))) .Or. !(Empty(Alltrim(acols[n][_nPosNpc])))
			If   Empty(Alltrim(acols[n][_nPosIpc]))  .Or.  Empty(Alltrim(acols[n][_nPosNpc]))
				MsgInfo("Os campos Ordem de Compra e Item precisao estar ambos preenchidos.....!!!!")
				_lRet := .F.
				Return (_lRet)
			EndIf
		EndIf
	EndIf



Return (_lRet)



User Function TKEVALI()

	Local _nPosIpc  := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "UB_ITEMPC" })
	Local _nPosNpc  := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "UB_NUMPCOM" })
	Local _lRet		:= .T.

	If M->UA_OPER=="1"
		If !(Empty(Alltrim(acols[n][_nPosIpc]))) .Or. !(Empty(Alltrim(acols[n][_nPosNpc])))
			If   Empty(Alltrim(acols[n][_nPosIpc]))  .Or.  Empty(Alltrim(acols[n][_nPosNpc]))
				MsgInfo("Os campos Ordem de Compra e Item precisao estar ambos preenchidos.....!!!!")
				_lRet := .F.
				Return (_lRet)
			EndIf
		EndIf
	EndIf



Return (_lRet)


