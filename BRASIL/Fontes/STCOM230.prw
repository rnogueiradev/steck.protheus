#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"

/*====================================================================================\
|Programa  | STCOM230        | Autor | RENATO.OLIVEIRA           | Data | 20/09/2020  |
|=====================================================================================|
|Descrição | Consultar multiplos PC					                                  |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STCOM230()

	Local lSaida   		:= .T.
	Local aSize	   		:= MsAdvSize(.F.,.F.)
	Local aCampoEdit		:= {}
	Local nY := 0
	Private	_oWindow,;
	oFontWin,;
	_aHead				:= {},;
	_bOk 				:= {||(	lSaida:=.f., lConfirma:=.T.,_oWindow:End()) },;
	_bCancel 	    	:= {||(	lSaida:=.f.,_oWindow:End()) },;
	_aButtons	    	:= {},;
	_oGet,;
	_oGet2
	Private _aHeader		:= {}
	Private _aCols		:= {}

	Aadd(_aHeader,{"Pedido"			,"01"		,"@!"						,TamSx3("ZZS_PEDCOM")[1],0,"",,"C","R"})
	Aadd(_aHeader,{"Item PC"		,"02"		,"@!"						,TamSx3("ZZS_ITEMPC")[1],0,"",,"C","R"})
	Aadd(_aHeader,{"Item NF"		,"03"		,"@!"						,TamSx3("ZZS_ITEMNF")[1],0,"",,"C","R"})
	Aadd(_aHeader,{"Qtd NF"			,"04"		,"@E"						,TamSx3("ZZS_QTDNF")[1],0,"",,"N","R"})
	Aadd(_aHeader,{"Qtd PC"			,"05"		,"@E"						,TamSx3("ZZS_QTDPC")[1],0,"",,"N","R"})
	Aadd(_aHeader,{"Qtd Sub"		,"06"		,"@E"						,TamSx3("ZZS_QTDSUB")[1],0,"",,"N","R"})

	DbSelectArea("ZZS")
	ZZS->(DbSetOrder(1))
	ZZS->(DbGoTop())
	If !ZZS->(DbSeek(SF1->(F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA)))
		MsgAlert("Não foram encontrados multiplos PCs para essa NF")
		Return
	EndIf

	_aCols		:= {}

	While ZZS->(!Eof()) .And. ZZS->(ZZS_FILIAL+ZZS_NF+ZZS_SERIE+ZZS_FORNEC+ZZS_LOJA)==;
	SF1->(F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA)

	AADD(_aCols,Array(Len(_aHeader)+1))

		For nY := 1 To Len(_aHeader)

			DO CASE

			CASE AllTrim(_aHeader[nY][2]) =  "01"
				_aCols[Len(_aCols)][nY] := ZZS->ZZS_PEDCOM
			CASE AllTrim(_aHeader[nY][2]) =  "02"
				_aCols[Len(_aCols)][nY] := ZZS->ZZS_ITEMPC
			CASE AllTrim(_aHeader[nY][2]) =  "03"
				_aCols[Len(_aCols)][nY] := ZZS->ZZS_ITEMNF
			CASE AllTrim(_aHeader[nY][2]) =  "04"
				_aCols[Len(_aCols)][nY] := ZZS->ZZS_QTDNF
			CASE AllTrim(_aHeader[nY][2]) =  "05"
				_aCols[Len(_aCols)][nY] := ZZS->ZZS_QTDPC
			CASE AllTrim(_aHeader[nY][2]) =  "06"
				_aCols[Len(_aCols)][nY] := ZZS->ZZS_QTDSUB

			ENDCASE

		Next

		_aCols[Len(_aCols)][Len(_aHeader)+1] := .F.

		ZZS->(DbSkip())
	EndDo

	DEFINE MSDIALOG _oWindow FROM 0,0 TO 400,1000/*500,1200*/ TITLE Alltrim(OemToAnsi('Múltiplos PC')) Pixel //430,531
	_oGet	:= MsNewGetDados():New(35,0,_oWindow:nClientHeight/2-20,_oWindow:nClientWidth/2-5,,"AllWaysTrue()","AllWaysTrue()",,aCampoEdit,,Len(_aCols),,, ,_oWindow,_aHeader,_aCols)
	_oGet:SetArray(_aCols)
	_oWindow:Refresh()
	_oGet:Refresh()
	ACTIVATE MSDIALOG _oWindow CENTERED ON INIT EnchoiceBar(_oWindow,_bOk,_bCancel,,_aButtons)

Return()
