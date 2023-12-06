#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"

#DEFINE CR    chr(13)+chr(10)

/*/{Protheus.doc} MT110TOK

Ponto de entrada para Solicitar Anexo quando o produto for "SERV" e o motivo de compras 
for diferente de "IND"

@type function
@author Everson Santana
@since 11/11/2019
@version Protheus 12 - Faturamento

@history ,Ticet 20191106000028,20210701011385

/*/

User Function  MT110TOK()

	Local nPosPrd	:= aScan(aHeader,{|x| AllTrim(x[2]) == 'C1_PRODUTO'})
	Local nPosMot  := aScan(aHeader,{|x| AllTrim(x[2]) == 'C1_MOTIVO'})
	Local lValido 	:= .T.
	Local lCont	  	:= .F.
	Local nX		:= 0

	Private cSolicit 	:= CA110NUM
	Private _cPath      := GetSrvProfString("RootPath","")
	Private _cStartPath := "arquivos\SC\"
	Private _cEmp       := ""+cEmpAnt+"\"
	Private _cFil       := ""+cFILaNT+"\"
	Private _cNUm       := ""+cSolicit+"\"
	Private _cServerDir := ''

	For  nX := 1 To Len (aCols)

		If "SERV" $ Alltrim(aCols[nX][nPosPrd])    
			If Alltrim(aCols[nX][nPosMot]) $ ("IND#PGM#CPM#CNP")
				lCont := .F.
			Else
				lCont := .T.
			EndIf
		EndIf 

	Next 

	If INCLUI .AND. lCont

		_cServerDir += (_cStartPath)
		If MakeDir (_cServerDir) == 0
			MakeDir(_cServerDir)
		Endif

		_cServerDir += _cEmp
		If MakeDir (_cServerDir) == 0
			MakeDir(_cServerDir)
		Endif

		_cServerDir += _cFil
		If MakeDir (_cServerDir) == 0
			MakeDir(_cServerDir)
		Endif

		_cServerDir += _cNUm
		If MakeDir (_cServerDir) == 0
			MakeDir(_cServerDir)
		Endif
		If !IsBlind()
			If ExistDir(_cServerDir)
				If  Altera .AND. lCont
					If !(Len(Directory(_cServerDir+Strzero(1,6)+".mzp")) = 1)
						MsgInfo("Atenção Solicitação não Pode ser Confirma !!!!!  "+CR+CR+"Falta anexar Documentos!!!")
						U_STCOM016(cSolicit)
					EndIf
					If !(Len(Directory(_cServerDir+Strzero(1,6)+".mzp")) = 1)
						lValido := .F.
						MsgInfo("Atenção Solicitação não Pode ser Confirma !!!!!  "+CR+CR+"Falta anexar Documentos!!!")
					EndIf
				ElseIf Inclui .AND. lCont
					U_STCOM016(cSolicit)
					If !(Len(Directory(_cServerDir+Strzero(1,6)+".mzp")) = 1)
						lValido := .F.
						MsgInfo("Atenção Solicitação não Pode ser Confirma !!!!!  "+CR+CR+"Falta anexar Documentos!!!")
					EndIf
				EndIf
			EndIf
		EndIf
	EndIf	


Return lValido