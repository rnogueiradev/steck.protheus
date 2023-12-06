#include "PROTHEUS.CH"
#INCLUDE "APVT100.CH"
#include 'TOPCONN.CH'
 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ACD175SOL³ Autor ³ FABRICA DE SOFTWARE    	 								  ³ Data ³ 09/11/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ PE apos no inicio do embarque 				                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Tipo Array																						³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Cliente   ³ Especifico cliente Steck  													 			 		³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function ACD175SOL()

	Local aAreaSF2
	Local aAreaPD1
	Local aAreaPD2

	Local cPlaca   		:= Space(08)
	Local aTelaPlc
	Local cQuery   		:= ""
	Local cAlias   		:= "QRYTEMP"
	Local lContinua		:= .F.
	Public bkey02
	
	bkey02 := VTSetKey(02,{|| U_STXLIMPR()},"Zera romaneio")

	cQuery := " SELECT DISTINCT C9_ORDSEP ORDSEP "
	cQuery += " FROM "+RetSqlName("PD2")+" PD2 "
	cQuery += " LEFT JOIN "+RetSqlName("SC9")+" C9 "
	cQuery += " ON PD2_FILIAL=C9_FILIAL AND PD2_NFS=C9_NFISCAL "
	cQuery += " WHERE PD2.D_E_L_E_T_=' ' AND C9.D_E_L_E_T_=' ' AND PD2_CODROM='"+_cRomaneio+"' "

	If !Empty(Select(cAlias))
		DbSelectArea(cAlias)
		(cAlias)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

	dbSelectArea(cAlias)
	(cAlias)->(dbGoTop())

	While (cAlias)->(!Eof())

		If AllTrim(CB7->CB7_ORDSEP)==AllTrim((cAlias)->ORDSEP)
			lContinua	:= .T.
		EndIf
		
		(cAlias)->(DbSkip())

	EndDo

	If !lContinua
		VTALERT("OS "+AllTrim(CB7->CB7_ORDSEP)+" nao encontrada no romaneio "+_cRomaneio+", verifique")
		Return .f.
	EndIf

	If Empty(CB7->CB7_NOTA)
		VtAlert("Ordem de Separacao nao faturada!",	"Atencao",.t.,4000)
		Return .f.
	Endif

	aAreaSF2 := SF2->(GetArea())
	SF2->(DbSetOrder(1))
	If ! SF2->(DbSeek(xFilial("SF2")+CB7->(CB7_NOTA+CB7_SERIE)))
		VtAlert("Nota fiscal não encontrada!",	"Atencao",.t.,4000)
		RestArea(aAreaSF2)
		Return .f.
	EndIf
	If Empty(SF2->F2_XCODROM)
		VtAlert("Nota fiscal sem romaneio!",	"Atencao",.t.,4000)
		RestArea(aAreaSF2)
		Return .f.
	Endif

	aAreaPD1 := PD1->(GetArea())
	PD1->(DbSetOrder(1))
	If !PD1->(DbSeek(xFilial("PD1")+SF2->(F2_XCODROM+F2_DOC+F2_SERIE)))
		VtAlert("Nota fiscal sem romaneio!",	"Atencao",.t.,4000)
		RestArea(aAreaPD1)
		RestArea(aAreaSF2)
		Return .F.
	Endif

	If Empty(CB7->CB7_XDIEB)
		CB7->(RecLock("CB7"))
		CB7->CB7_XDIEB := Date()
		CB7->CB7_XHIEB := Time()
		CB7->(MsUnLock())
	EndIf


	If Empty(PD1->PD1_PLACA)
		aTelaPlc := VTSave()
		VtClearBuffer()
		While .t.
			cPlaca := Space(08)
			VTClear()
			@ 00,00 VTSay "Informe a"
			@ 01,00 VTSay "Placa:"
			@ 02,00 VTGet cPlaca Picture "@!" Valid !Empty(cPlaca)
			VTRead
		
			If VtLastkey() == 27
				If VTYesNo("Necessario registrar a Placa, Deseja continuar? ",".:ATENCAO:.",.T.)
					Loop
				Endif
				Return .f.
			EndIf
			If !VTYesNo("Confirma a placa: " + cPlaca + " ?",".:ATENCAO:.",.T.)
				Loop
			Endif
			Exit
		Enddo
		VtRestore(,,,,aTelaPlc)
		PD1->(RecLock("PD1",.F.))
		PD1->PD1_STATUS:= "1"
		PD1->PD1_PLACA := cPlaca
		PD1->(MsUnlock())
	Endif

	aAreaPD2 := PD2->(GetArea())
	PD2->(DbSetOrder(1))
	If !PD2->(DbSeek(xFilial("PD2")+SF2->(F2_XCODROM+F2_DOC+F2_SERIE)))
		VtAlert("Nota fiscal sem romaneio!, Verifique PD2",	"Atencao",.t.,4000)
		RestArea(aAreaSF2)
		RestArea(aAreaPD2)
		Return .F.
	Endif
	IF (PD1->PD1_STATUS == '2')    // Valdemir Rabelo 15/01/2021
		//VtAlert("Romaneio ja Finalizado!, Por favor verifique.",	"Atencao",.t.,4000)
		If !VTYesNo("Romaneio ja finalizado. Deseja reabri-lo?","Atenção!",.T.) 
			RestArea(aAreaSF2)
			RestArea(aAreaPD2)
			Return .F.
		endif 
	ENDIF 
	Begin Transaction
		PD2->(RecLock("PD2",.F.))
		PD2->PD2_STATUS := "1"
		PD2->(MsUnlock())
		U_STFSF60C(PD2->PD2_CODROM) //Atualiza informacoes do Romaneio (pesos, quantidades volumes e status)
	End Transaction
	
	VTSetKey(02,bkey02)

	RestArea(aAreaSF2)
	RestArea(aAreaPD2)
Return .T. 
