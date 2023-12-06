#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"

/*====================================================================================\
|Programa  | STGETSX2        | Autor | RENATO.OLIVEIRA           | Data | 16/01/2019  |
|=====================================================================================|
|Descri��o | Tela para consultar tabelas							                  |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Hist�rico....................................|
\====================================================================================*/

User Function STGETSX2()

	Local aSize	   		:= MsAdvSize(.F.)
	Private _aHeader1	:= {}
	Private _aCols1		:= {}
	Private _oGet
	Private oWindow
	Private nAtGrid1	:= 1
	Private _lSaida 	:= .F.
	Private _cRetorno	:= ""
	Private _cUser		:= Space(40)

	Aadd(_aHeader1,{"C�digo"	,"CODIGO"	,"@!"	,03,0,"",,"C",""})
	Aadd(_aHeader1,{"Nome"		,"NOME"		,"@!"	,40,0,"",,"C",""})

	GETTABS()

	DEFINE MSDIALOG oWindow TITLE "Consulta de tabelas" FROM 000,000 TO aSize[6]/2,aSize[5]/2 TITLE Alltrim(OemToAnsi('Listagem de usu�rios')) Pixel //430,531

	@ 1,1 MSGET _cUser When .T. Size 100,7 VALID PESQSX2() PICTURE "@!" PIXEL OF oWindow

	_oGet	:= MsNewGetDados():New(15,0,oWindow:nClientHeight/2-15,oWindow:nClientWidth/2-1,,"AllWaysTrue()","AllWaysTrue()",,,,,,, ,oWindow,_aHeader1,_aCols1)
	_oGet:oBrowse:lUseDefaultColors := .F.
	_oGet:oBrowse:SetBlkBackColor({||RVGBkColor(_oGet:aCols,_oGet:nAt,_aHeader1)})
	_oGet:bChange := {||RVGAtGrid()}
	_oGet:SetArray(_aCols1)
	_oGet:oBrowse:bLDblClick := {||_lSaida:=.T.,oWindow:End()}

	ACTIVATE MSDIALOG oWindow CENTERED

	If _lSaida
		M->Z20_ROTINA := _oGet:aCols[_oGet:nAt][1]
	EndIf

Return(.T.)

/*/{Protheus.doc} GETTABS
@name GETTABS
@type Static Function
@desc retornar tabelas do sistema
@author Renato Nogueira
@since 01/08/2017
/*/

Static Function GETTABS()

	Local nY := 0

	DbSelectArea("SX2")
	SX2->(DbGoTop())

	While SX2->(!Eof())

		AADD(_aCols1,Array(Len(_aHeader1)+1))

		For nY := 1 To Len(_aHeader1)

			DO CASE
				CASE AllTrim(_aHeader1[nY][2]) =  "CODIGO"
				_aCols1[Len(_aCols1)][nY] := SX2->X2_CHAVE
				CASE AllTrim(_aHeader1[nY][2]) =  "NOME"
				_aCols1[Len(_aCols1)][nY] := SX2->X2_NOME
			ENDCASE

		Next

		_aCols1[Len(_aCols1)][Len(_aHeader1)+1] := .F.

		SX2->(DbSkip())
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

/*/{Protheus.doc} PESQSX2
@name PESQSX2
@type Static Function
@desc buscar tabela
@author Renato Nogueira
@since 12/09/2016
/*/

Static Function PESQSX2()

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