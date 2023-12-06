#INCLUDE "PROTHEUS.CH"
#INCLUDE "FILEIO.CH"
#INCLUDE "APWEBSRV.CH"
#include 'RwMake.ch'
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
#Define CR chr(13)+chr(10)
#DEFINE Cr chr(13)+chr(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³XGFEA050	ºAutor  ³Giovani Zago     º Data ³  16/05/19      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³WF 														  º±±
±±º          ³   													      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametro ³ Nenhum                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºRetorno   ³ Nenhum                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function XGFEA050()

	Local _aRotina:={}

	aAdd(_aRotina,{ "Desvincular Documento de Carga", "U_X050DES", 0 , 2, 0, Nil})
	//aAdd(_aRotina,{ "Desvincular Romaneio", "U_Z050DES", 0 , 2, 0, Nil})

Return _aRotina





User Function Z050DES()


	Local cVendNew    := space(8)
	Local cVendNew2   := space(8)

	DEFINE MSDIALOG oDlgEmail TITLE OemToAnsi("Escolha o Romaneio") From 1,0 To 16,25 OF oMainWnd

	@ 05,04 SAY "Romaneio de:" PIXEL OF oDlgEmail
	@ 15,04 MSGet cVendNew 	F3 'GWN'	  Size 35,012  PIXEL OF oDlgEmail Valid(existcpo("GWN",cVendNew)  )


	@ 05+40,04 SAY "Romaneio Ate:" PIXEL OF oDlgEmail
	@ 15+40,04 MSGet cVendNew2 	F3 'GWN'	  Size 35,012  PIXEL OF oDlgEmail Valid (existcpo("GWN",cVendNew2)  )

	@ 053+40, 05 Button "Ok"      Size 28,12 Action Eval({||nOpca:=1,oDlgEmail:End()})  Pixel
	@ 053+40, 67 Button "Cancela" Size 28,12 Action Eval({||nOpca:=2,oDlgEmail:End()})  Pixel


	nOpca:=0

	ACTIVATE MSDIALOG oDlgEmail CENTERED

	If nOpca == 1




		MsgInfo("Cuidado......!!!!!!!!!!!!")






		dbSelectArea("GWN")
		GWN->( dbSetOrder(1) )
		If GWN->( dbSeek('02'+ cVendNew))
		//MsgInfo("SEEK......!!!!!!!!!!!!")
			While !GWN->( Eof() ) .And. '02' == GWN->GWN_FILIAL 
				If GWN->GWN_NRROM >= cVendNew .And. GWN->GWN_NRROM <= cVendNew2

					dbSelectArea("GW1")
					GW1->( dbSetOrder(9) )
					GW1->( dbSeek(xFilial("GW1") + GWN->GWN_NRROM))
					While !GW1->( Eof() ) .And. xFilial("GW1") == GW1->GW1_FILIAL .And. GW1->GW1_NRROM == GWN->GWN_NRROM


						dbSelectArea("GW4")
						GW4->( dbSetOrder(2))
						If GW4->(dbSeek(xFilial("GW4")+ GW1->GW1_EMISDC + GW1->GW1_SERDC + GW1->GW1_NRDC))
							//If MsgYesNo("Deseja Desvincular o Documento de Carga do Documento de Frete?......!!!!")
								GW4->(RecLock("GW4",.F.))
								GW4->(DbDelete())
								GW4->(MsUnlock())
								GW4->( DbCommit())
								//reabrir romaneio
								GFEA050REA(.T.)


								//(lValid, lOcor) Função para eliminar os Cálculos do Documento de Carga  Requere que o Documento de Carga já esteja posicionado(GW1).
								//GFEA44DELC(.t.,.f.)

								dbSelectArea("GWH")
								GWH->( dbSetOrder(2) )
								GWH->( dbSeek(xFilial("GWH") + GW1->GW1_CDTPDC + GW1->GW1_EMISDC + GW1->GW1_SERDC + GW1->GW1_NRDC) )
								While !GWH->( Eof() ) .And. GWH->GWH_FILIAL == xFilial("GWH") .And. GWH->GWH_EMISDC == GW1->GW1_EMISDC ;
								.And. GWH->GWH_SERDC == GW1->GW1_SERDC .And. GWH->GWH_NRDC == GW1->GW1_NRDC

									dbSelectArea("GWF")
									GWF->( dbSetOrder(1) )
									If GWF->( dbSeek(xFilial("GWF") + GWH->GWH_NRCALC) )


										GFEDelCalc(GWH->GWH_NRCALC)

									EndIf

									GWH->( dbSkip() )
								EndDo


								// Elimina do Documento de Carga o Romaneio

								GW1->(RecLock("GW1",.F.))
								GW1->GW1_CALCAT	:= " "
								GW1->GW1_NRROM 	:= " "
								GW1->GW1_SIT 	:= "3" // Liberado
								GW1->(MsUnlock())
								GW1->( DbCommit() )

								GW1->(RecLock("GWN",.F.))
								//GWN->GWN_CALC   := "4" // Romaneio necessita recálculo
								GWN->GWN_MTCALC := "Um Documento de Carga relacionado ao Romaneio foi excluído."
								GWN->GWN_DTCALC := CToD("  /  /    ")
								GWN->GWN_HRCALC := ""
								GWN->(MsUnlock())
								GWN->( DbCommit() )


							//	MsgInfo("Concluido....!!!!")
						//	EndIf


						EndIf
						GW1->( dbSkip())
					End

				EndIf
				GWN->( dbSkip())
			End

		EndIf


MsgInfo("Concluido....!!!!")

	EndIf
Return()



User Function X050DES()



	dbSelectArea("GWN")
	GWN->( dbSetOrder(1) )
	If GWN->( dbSeek(xFilial("GWN") + GWN->GWN_NRROM))

		dbSelectArea("GW1")
		GW1->( dbSetOrder(9) )
		GW1->( dbSeek(xFilial("GW1") + GWN->GWN_NRROM))
		While !GW1->( Eof() ) .And. xFilial("GW1") == GW1->GW1_FILIAL .And. GW1->GW1_NRROM == GWN->GWN_NRROM


			dbSelectArea("GW4")
			GW4->( dbSetOrder(2))
			If GW4->(dbSeek(xFilial("GW4")+ GW1->GW1_EMISDC + GW1->GW1_SERDC + GW1->GW1_NRDC))
				If MsgYesNo("Deseja Desvincular o Documento de Carga do Documento de Frete?......!!!!")
					GW4->(RecLock("GW4",.F.))
					GW4->(DbDelete())
					GW4->(MsUnlock())
					GW4->( DbCommit())
					//reabrir romaneio
					GFEA050REA(.T.)


					//(lValid, lOcor) Função para eliminar os Cálculos do Documento de Carga  Requere que o Documento de Carga já esteja posicionado(GW1).
					//GFEA44DELC(.t.,.f.)

					dbSelectArea("GWH")
					GWH->( dbSetOrder(2) )
					GWH->( dbSeek(xFilial("GWH") + GW1->GW1_CDTPDC + GW1->GW1_EMISDC + GW1->GW1_SERDC + GW1->GW1_NRDC) )
					While !GWH->( Eof() ) .And. GWH->GWH_FILIAL == xFilial("GWH") .And. GWH->GWH_EMISDC == GW1->GW1_EMISDC ;
					.And. GWH->GWH_SERDC == GW1->GW1_SERDC .And. GWH->GWH_NRDC == GW1->GW1_NRDC

						dbSelectArea("GWF")
						GWF->( dbSetOrder(1) )
						If GWF->( dbSeek(xFilial("GWF") + GWH->GWH_NRCALC) )


							GFEDelCalc(GWH->GWH_NRCALC)

						EndIf

						GWH->( dbSkip() )
					EndDo


					// Elimina do Documento de Carga o Romaneio

					GW1->(RecLock("GW1",.F.))
					GW1->GW1_CALCAT	:= " "
					GW1->GW1_NRROM 	:= " "
					GW1->GW1_SIT 	:= "3" // Liberado
					GW1->(MsUnlock())
					GW1->( DbCommit() )

					GW1->(RecLock("GWN",.F.))
					//GWN->GWN_CALC   := "4" // Romaneio necessita recálculo
					GWN->GWN_MTCALC := "Um Documento de Carga relacionado ao Romaneio foi excluído."
					GWN->GWN_DTCALC := CToD("  /  /    ")
					GWN->GWN_HRCALC := ""
					GWN->(MsUnlock())
					GWN->( DbCommit() )


					MsgInfo("Concluido....!!!!")
				EndIf


			EndIf
			GW1->( dbSkip())
		End

	EndIf




Return()




