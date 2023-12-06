#INCLUDE "TOTVS.CH"

/*/{Protheus.doc} GFEA0442
@name GFEA0442
@type User Function
@desc adicionar rotina na tela de documento de carga
@author Renato Nogueira
@since 17/05/2018
/*/

User Function GFEA0442()

	Local aRotina := {}

	aRotina := { {"Bloq. Documento", "U_STGFEA01()", 0, 4} ,;
	{"Aprovar D.F.", "U_DFAPRO()", 0, 4} ,;
	{"Transferir Xmls", "U_STTRAXML()", 0, 4}}
	 

Return(aRotina)

/*/{Protheus.doc} STGFEA01
@name STGFEA01
@type User Function
@desc opção para bloquear documento de carga
@author Renato Nogueira
@since 17/05/2018
/*/

User Function STGFEA01()

	If !(__cUserId $ SuperGetMv("ST_GFEA01",.F.,"000010"))
		MsgAlert("Atenção, usuário sem acesso para utilizar essa opção, verifique!")
		Return
	EndIf

	If !MsgYesNo("Confirma o bloqueio manual do documento de carga "+AllTrim(GW1->GW1_NRDC)+"?")
		Return
	EndIf

	GW1->(RecLock("GW1",.F.))
	GW1->GW1_SIT := "2"
	GW1->(MsUnLock())

	MsgAlert("Documento bloqueado com sucesso, obrigado!")

Return()