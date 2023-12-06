#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"

/*====================================================================================\
|Programa  | STGETSX3        | Autor | RENATO.OLIVEIRA           | Data | 16/01/2019  |
|=====================================================================================|
|Descrição | Tela para consultar campos							                  |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STGETSX3()

	Local aSize	   		:= MsAdvSize(.F.)
	Private _aHeader1	:= {}
	Private _aCols1		:= {}
	Private _oGet
	Private oWindow
	Private nAtGrid1	:= 1
	Private _lSaida 	:= .F.
	Private _cRetorno	:= ""
	Private _cUser		:= Space(40)

	Aadd(_aHeader1,{"Código"	,"CODIGO"	,"@!"	,03,0,"",,"C",""})
	Aadd(_aHeader1,{"Nome"		,"NOME"		,"@!"	,40,0,"",,"C",""})

	GETSX3()

	DEFINE MSDIALOG oWindow TITLE "Consulta de campos" FROM 000,000 TO aSize[6]/2,aSize[5]/2 TITLE Alltrim(OemToAnsi('Listagem de usuários')) Pixel //430,531

	@ 1,1 MSGET _cUser When .T. Size 100,7 VALID PESQSX3() PICTURE "@!" PIXEL OF oWindow

	_oGet	:= MsNewGetDados():New(15,0,oWindow:nClientHeight/2-15,oWindow:nClientWidth/2-1,,"AllWaysTrue()","AllWaysTrue()",,,,,,, ,oWindow,_aHeader1,_aCols1)
	_oGet:oBrowse:lUseDefaultColors := .F.
	_oGet:oBrowse:SetBlkBackColor({||RVGBkColor(_oGet:aCols,_oGet:nAt,_aHeader1)})
	_oGet:bChange := {||RVGAtGrid()}
	_oGet:SetArray(_aCols1)
	_oGet:oBrowse:bLDblClick := {||_lSaida:=.T.,oWindow:End()}

	ACTIVATE MSDIALOG oWindow CENTERED

	If _lSaida
		M->Z20_CAMPO := _oGet:aCols[_oGet:nAt][1]
	EndIf

Return(.T.)

/*/{Protheus.doc} GETSX3
@name GETSX3
@type Static Function
@desc retornar campos do sistema
@author Renato Nogueira
@since 01/08/2017
/*/

Static Function GETSX3()

	Local nY := 0

	DbSelectArea("SX3")
	SX3->(DbSetOrder(1))
	SX3->(DbGoTop())
	SX3->(DbSeek(SubStr(M->Z20_ROTINA,1,3)))

	While SX3->(!Eof()) .And. SX3->X3_ARQUIVO==SubStr(M->Z20_ROTINA,1,3)

		AADD(_aCols1,Array(Len(_aHeader1)+1))

		For nY := 1 To Len(_aHeader1)

			DO CASE
				CASE AllTrim(_aHeader1[nY][2]) =  "CODIGO"
				_aCols1[Len(_aCols1)][nY] := SX3->X3_CAMPO
				CASE AllTrim(_aHeader1[nY][2]) =  "NOME"
				_aCols1[Len(_aCols1)][nY] := SX3->X3_TITULO
			ENDCASE

		Next

		_aCols1[Len(_aCols1)][Len(_aHeader1)+1] := .F.

		SX3->(DbSkip())
	EndDo

	ASORT(_aCols1,,,{|x,y|x[1]<y[1]})

Return()

/*/{Protheus.doc} RVGBkColor
@name RVGBkColor
@type Static Function
@desc cor das linhas
@author Renato Nogueira
@since 04/09/2017
/*/

Static Function RVGBkColor(_aCols2,_nLinha,_aHeader4)

	Local nCor1 := CLR_WHITE	// Branco
	Local nCor2 := CLR_YELLOW	// Amarelo
	Local nRet  := nCor1

	If _oGet:nAt = nAtGrid1
		nRet := nCor2
	EndIf

Return(nRet)

/*/{Protheus.doc} RVGAtGrid
@name RVGAtGrid
@type Static Function
@desc cor das linhas
@author Renato Nogueira
@since 04/09/2017
/*/

Static Function RVGAtGrid()

	Local lRet 			:= .T.

	nAtGrid1 := _oGet:nAt
	_oGet:Refresh()

Return(lRet)

/*/{Protheus.doc} PESQSX3
@name PESQSX3
@type Static Function
@desc buscar campo
@author Renato Nogueira
@since 12/09/2016
/*/

Static Function PESQSX3()

	Local _lAchou	:= .F.
	Local _nX

	For _nX:=1 To Len(_aCols1)
		If UPPER(AllTrim(_cUser)) $ UPPER(AllTrim(_aCols1[_nX][1]))
			_oGet:GoTo(_nX)
			_oGet:nAt	:= _nX
			nAtGrid1 	:= _oGet:nAt
			_oGet:Refresh()
			Exit
		EndIf
	Next

Return(.T.)