#include "rwmake.ch"
#include "protheus.ch"

/*/{Protheus.doc} MT120TEL

Incluir campo Observação

@type function
@author Everson Santana
@since 16/01/19
@version Protheus 12 - Compras

@history ,Chamado 008697 ,

/*/
User Function MT120TEL()
	Local aArea     := GetArea()
	Local oDlg      := PARAMIXB[1] 
	Local aPosGet   := PARAMIXB[2]
	Local nOpcx     := PARAMIXB[4]
	Local nRecPC    := PARAMIXB[5]
	Local lEdit     := IIF(nOpcx == 3 .Or. nOpcx == 4 .Or. nOpcx ==  9, .T., .F.) //Somente será editável, na Inclusão, Alteração e Cópia
	Local oXObsAux
	Public cXObsAux := ""
	If FWIsInCallStack("U_ARCOM010")
			//Rotina de importação de planilha nao passar na validação ARCOM010
			RestArea(aArea)
			Return		
	EndIf

	//Define o conteúdo para os campos
	SC7->(DbGoTo(nRecPC))
	If nOpcx == 3
		cXObsAux := CriaVar("C7_OBS",.F.)
	Else
		cXObsAux := SC7->C7_OBS
	EndIf

	//Criando na janela o campo OBS
	@ 050, aPosGet[1,08] + 104 SAY Alltrim(RetTitle("C7_OBS")) OF oDlg PIXEL SIZE 050,006
	@ 049, aPosGet[1,09] + 075 MSGET oXObsAux VAR cXObsAux SIZE 100, 006 OF oDlg COLORS 0, 16777215  PIXEL
	oXObsAux:bHelp := {|| ShowHelpCpo( "C7_OBS", {GetHlpSoluc("C7_OBS")[1]}, 5  )}

	//Se não houver edição, desabilita os gets
	If !lEdit
		oXObsAux:lActive := .F.
	EndIf

	RestArea(aArea)
Return

/*--------------------------------------------------------------------------------------------------------------*
| P.E.:  MTA120G2                                                                                              |
| Desc:  Ponto de Entrada para gravar informações no pedido de compra a cada item (usado junto com MT120TEL)   |
| Link:  http://tdn.totvs.com/pages/releaseview.action?pageId=6085572                                          |
*--------------------------------------------------------------------------------------------------------------*/

User Function MTA120G2()

	Local aArea := GetArea()
	DEFAULT cXObsAux := ""

	If FWIsInCallStack("U_ARCOM010")
			//Rotina de importação de planilha nao passar na validação ARCOM010
			RestArea(aArea)
			Return		
	EndIf

	//Atualiza a descrição, com a variável pública criada no ponto de entrada MT120TEL
	SC7->C7_OBS := cXObsAux

	RestArea(aArea)
Return

