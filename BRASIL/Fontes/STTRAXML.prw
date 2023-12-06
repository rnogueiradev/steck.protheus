#INCLUDE "PROTHEUS.CH"
#Include "Rwmake.ch"
#Include "TopConn.ch"
#INCLUDE "TBICONN.CH"
#include "TOTVS.CH"
#INCLUDE "FILEIO.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "TOPCONN.CH"
/*====================================================================================\
|Programa  | STTRAXML           | Autor | GIOVANI.ZAGO          | Data | 16/07/2019   |
|=====================================================================================|
|Descrição | transfere xml da maquina local para o servidor		                      |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STTRAXML	                                                              |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

*-------------------------------*
User function STTRAXML()
	*-------------------------------*
	Local cDiretorio:= 'C:\arquivos_protheus\XML_CTE\'
	Local aDirXml	:= {}
	Local cNomeArq	:= ' '  
	Local _cSerDir	:= '\arquivos\XML_CTE\CTE\'
	Local t := 0 
	//PREPARE ENVIRONMENT EMPRESA '01' FILIAL '02'

	If !(ExistDir(cDiretorio))
		MakeDir(cDiretorio)
	EndIf
	If ExistDir(cDiretorio) 
		If MsgYesNo('Deseja Transferir os Xmls ?')
			aDirXml := DIRECTORY(cDiretorio + "*.XML" )
			For t:=1  To Len(aDirXml)
				cNomeArq := aDirXml[t][1]
				CpyT2S(cDiretorio   + cNomeArq,_cSerDir  ,.T.)
				FERASE(cDiretorio   + cNomeArq)   
			Next t
			MsgAlert('Finalizado')
		EndIf
	EndIf

Return()

Static Function MenuDef(_cSSID)


	Local aRotina   := {}


//	ADD OPTION aRotina TITLE "Invert.Sel."   ACTION "U_MARK01(.F.)"   OPERATION 8  ACCESS 0
//	ADD OPTION aRotina TITLE "Confirma"      ACTION "U_MARK02()"   OPERATION 8  ACCESS 0
	ADD OPTION aRotina TITLE "Confirma"      ACTION "U_DFConf()"   OPERATION 8  ACCESS 0

	Return aRotina




	*-------------------------------*
User function DFAPRO()
	*-------------------------------*
	Local _cAprov	:= GetMv("ST_DFAPRO",,"000000/000645/000415/")
	Local aArea		:= GetArea()
	Local cMotAprov := ' '
	Local lSaida	:= .T.
	Local _cAlias1  := "GW3"
	Local _cFiltro  := ""
	Local _cUser    := ""

Local lMarcaAll := .F.

	Private cTitle  := "Aprovação Documento de Frete"
	Private cMarca  := ''
	Private _cCID   := "MARKDF"
	Private _cSSID  := "STTRAXML"
	Private aRotina := MenuDef(_cSSID)
	Private oMark

Private cMark := GetMark()
Private aMarcados := {}

/*
	If !(__cuserid $ _cAprov)
		MsgInfo("Usuario não Habilitado")
	EndIf
*/

	_cFiltro += " GW3_SIT = '2'"

oMark := FWMarkBrowse():New()
oMark:SetAlias(_cAlias1)
oMark:SetFieldMark("GW3_XOK")
oMark:SetAfterMark( { || Marcar() } )
//oMark:SetAllMark( { || lMarcaAll := IIf(lMarcaAll,.F.,.T.), MarcarAll(lMarcaAll), oMark:Refresh(.T.)  } )
oMark:SetAllMark( { || MarcarAll(), oMark:Refresh(.T.)  } )
oMark:SetUseFilter(.T.)
oMark:SetDescription(cTitle)
oMark:SetFilterDefault( _cFiltro )  

	oMark:DisableDetails() 
	oMark:Activate()

	RestArea(aArea)
Return()


User Function DFConf
Local aArea		:= GetArea()
Local GW3aArea	
Local cMotAprov := space(200)
Local lSaida	:= .F.

Local nX := 0

While !lSaida
	Define msDialog oDlg Title "Motivo" From 10,10 TO 20,65 Style DS_MODALFRAME
		@ 000,001 Say "Descrição do motivo: " Pixel Of oDlg
		@ 010,003 MsGet cMotAprov valid !empty(cMotAprov) size 200,10 Picture "@!" pixel OF oDlg
		DEFINE SBUTTON FROM 50,20 TYPE 1 ACTION IF(!empty(cMotAprov),(nOpcao:=1,lSaida:=.T.,oDlg:End()),msgInfo("Motivo em Branco","Atenção")) ENABLE OF oDlg
		Activate dialog oDlg centered
	End

	If nOpcao == 1
		For nX := 1 To Len(aMarcados)
			If aMarcados[nX] > 0
				GW3->(DbGoTo(aMarcados[nX]))
				RecLock("GW3",.F.)
				GW3->GW3_MOTAPR := cMotAprov
				GW3->GW3_USUAPR := cUserName
				GW3->GW3_SIT    := "4"
				GW3->GW3_DTAPR  := DDATABASE
				GW3->GW3_HRAPR  := Time()
				GW3->GW3_XOK 	:= '  '
				GW3->(MsUnLock())
			EndIf
		Next nX
		MsgInfo("Aprovação Finalizada....!!!!!")
	EndIf
	RestArea(aArea)
Return

Static Function MarcarAll
Local aArea := GetArea()
Local nPos := 0

GW3->(DbGoTop())
Do While !GW3->(EOF())
	If GW3->GW3_SIT == "2"
		nPos := aScan(aMarcados, GW3->(RECNO()))
		If nPos == 0
			GW3->(DbGoTo(GW3->(RECNO())))
			RecLock("GW3",.F.)
			GW3->GW3_XOK := oMark:Mark()
			GW3->(MsUnlock())
			aAdd(aMarcados, GW3->(RECNO()))
		Else
			GW3->(DbGoTo(aMarcados[nPos]))
			RecLock("GW3",.F.)
			GW3->GW3_XOK := " "
			GW3->(MsUnlock())
			aMarcados[nPos] := 0
		EndIf
	EndIf
	GW3->(DbSkip())
EndDo

/*
//aSize(aMarcados,0)
If lMarcar
	GW3->(DbGoTop())
	Do While !GW3->(EOF())
		If GW3->GW3_SIT == "2"
			aAdd(aMarcados, GW3->(RECNO()))
			GW3->(DbSkip())
		EndIf
	EndDo
	oMark:AllMark()
Else
	aSize(aMarcados,0)
	oMark:AllMark()
EndIf
*/

RestArea(aArea)
Return


Static Function Marcar
Local aArea := GetArea()
Local nPos := 0

nPos := aScan(aMarcados, GW3->(RECNO()))

If nPos > 0
	If oMark:IsMark(oMark:Mark())
		aMarcados[nPos] := GW3->(RECNO())
	Else
		aMarcados[nPos] := 0
	EndIf
Else
	If oMark:IsMark(oMark:Mark())
		aAdd(aMarcados, GW3->(RECNO()))
	EndIf
EndIf

RestArea(aArea)
Return


User function MARK01(lOpc)
	If lOpc
		lMarcar := !lMarcar
	EndIf
//	oMark:GoTop()
	dbSelectArea("GW3")
	GW3->(dbGoTop())
	GW3->(dbSetOrder(7))
	If	GW3->(dbSeek(xFilial("GW3")+'2'))
		While GW3->(!Eof())
			If GW3->GW3_SIT = '2'
//				If oMark:IsMark()
				If lOpc
					If !lMarcar
						RecLock("GW3", .F.)
						GW3->GW3_XOK := '  '
						GW3->(MsUnlock())
//					ElseIf !oMark:IsMark()
					Else
						RecLock("GW3", .F.)
						GW3->GW3_XOK := oMark:Mark()
						GW3->(MsUnlock())
					EndIf
				Else
					If oMark:IsMark()
						RecLock("GW3", .F.)
						GW3->GW3_XOK := '  '
						GW3->(MsUnlock())
					Else
						RecLock("GW3", .F.)
						GW3->GW3_XOK := oMark:Mark()
						GW3->(MsUnlock())
					EndIf
				EndIf
			Endif
			GW3->(dbSkip())
		EndDo
	EndIf
Return()

User function MARK02()
	Local aArea		:= GetArea()
	Local GW3aArea	
	Local cMotAprov := space(200)
	Local lSaida	:= .F.

	While !lSaida

		Define msDialog oDlg Title "Motivo" From 10,10 TO 20,65 Style DS_MODALFRAME

		@ 000,001 Say "Descrição do motivo: " Pixel Of oDlg
		@ 010,003 MsGet cMotAprov valid !empty(cMotAprov) size 200,10 Picture "@!" pixel OF oDlg

		DEFINE SBUTTON FROM 50,20 TYPE 1 ACTION IF(!empty(cMotAprov),(nOpcao:=1,lSaida:=.T.,oDlg:End()),msgInfo("Motivo em Branco","Atenção")) ENABLE OF oDlg

		Activate dialog oDlg centered

	End


	oMark:GoTop()
	dbSelectArea("GW3")
	//GW3->(dbSetOrder(7))
	GW3->(dbGoTop())
	//If	GW3->(dbSeek(xFilial("GW3")+'2'))
		While GW3->(!Eof()) //.And. GW3->GW3_SIT = '2' .And. GW3->GW3_FILIAL = xFilial("GW3")
			If GW3->GW3_SIT = '2'
				If oMark:IsMark()
			
					RecLock("GW3",.F.)
					GW3->GW3_MOTAPR := cMotAprov
					GW3->GW3_USUAPR := cUserName
					GW3->GW3_SIT    := "4"
					GW3->GW3_DTAPR  := DDATABASE
					GW3->GW3_HRAPR  := Time()
					GW3->GW3_XOK 	:= '  '
					GW3->(MsUnLock())


				EndIf
			Endif
			GW3->(dbSkip())

		End
		MsgInfo("Aprovação Finalizada....!!!!!")
	//EndIf
	RestArea(aArea)
Return()

/*
User Function GRGW3()

GW3->(dbSelectArea("GW3"))
GW3->(dbSetOrder(7))
If	GW3->(dbSeek(xFilial("GW3")+'2'))

While !lSaida

Define msDialog oDlg Title "Motivo" From 10,10 TO 20,65 Style DS_MODALFRAME

@ 000,001 Say "Descrição do motivo: " Pixel Of oDlg
@ 010,003 MsGet cMotAprov valid !empty(cMotAprov) size 200,10 Picture "@!" pixel OF oDlg

DEFINE SBUTTON FROM 50,20 TYPE 1 ACTION IF(!empty(cMotAprov),(nOpcao:=1,lSaida:=.T.,oDlg:End()),msgInfo("Motivo em Branco","Atenção")) ENABLE OF oDlg

Activate dialog oDlg centered

End


While !(GW3->(eof())) .And. GW3->GW3_SIT = '2' .And. GW3->GW3_FILIAL = xFilial("GW3")

GFEA066OK(.T., , , , cMotAprov)

GW3->(dbSkip())
End
EndIf

EndIf

RestArea(aArea)

Return()
*/



