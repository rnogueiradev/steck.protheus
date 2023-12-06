#Include 'Protheus.ch'
#include 'TOPCONN.CH'

/*/{Protheus.doc}MT905MNU
PE para adcionar opção de transferencia do CIAP

@author RVG Soluções
@since 14/07/2016
@version MP11
/*/

User Function MT905MNU()

//Adiciona a Nova Opção
	Aadd(aRotina,{ "Transferir Filial" ,"U_STCIAP02"  , 0 , 4 , 0 , NIL})

Return


/*/{Protheus.doc}MT905MNU
Rotina para transferencia do CIAP

@author RVG Soluções
@since 14/07/2016
@version MP11
/*/

User Function STCIAP02()

	Local aArea := GetArea()
	Local aCampos := {}
	Local cCampo := ""
	Local cPerg := "STCIAP02"
	Local nX := 0

	xCriaSX1(cPerg)

	If Pergunte(cPerg,.T.)

		If MsgYesNo("Confirma a Transferencia do Codigo: "+SF9->F9_CODIGO+" filial: "+SF9->F9_FILIAL+" para a Filial: "+MV_PAR01+"?")

			If SF9->F9_FILIAL<>MV_PAR01
				//Abre SX3
				DbSelectArea("SX3")
				SX3->(DbGoTop())
				SX3->(DbSetOrder(1))
				SX3->(DbSeek("SF9"))

				//Carrega Lista de Campos
				While SX3->(!Eof()) .And. AllTrim(SX3->X3_ARQUIVO)=="SF9"
	
					Aadd(aCampos, SX3->X3_CAMPO )
					SX3->(DbSkip())
	
				EndDo

				//Carrega a Tabela SF9
				RegToMemory( "SF9", .F., .T. )

				//Atualiza Campos da Memoria
				For nX := 1 To Len(aCampos)
					cCampo := aCampos[nX]
					M->&cCampo := SF9->&cCampo
				Next

				//Atualiza a Filial Nova
				M->F9_FILIAL := MV_PAR01

				Begin Transaction

					//Atualiza
					Reclock("SF9",.F.)
					SF9->F9_SLDPARC := 0
					MsUnlock()

					//Move o Codigo para nova Filial
					DbSelectArea("SF9")
					SF9->(DbSetOrder(1))
					SF9->(DbGoTop())
					If SF9->(DbSeek(M->(F9_FILIAL+F9_CODIGO)))
						Reclock("SF9",.F.)
					Else
						Reclock("SF9",.T.)
					EndIf
					//Atualiza Campos com dados Memoria
					For nX := 1 To Len(aCampos)
						cCampo := aCampos[nX]
						SF9->&cCampo := M->&cCampo
					Next
					//Altera Motivo -- Solicitado pela Veronica 28/07/2016
					If M->F9_MOTIVO = "3"
						SF9->F9_MOTIVO := " "
						SF9->F9_BXICMS := 0
						SF9->F9_ROTINA := "MATA905"
					EndIf
					MsUnlock()

				End Transaction

				MsgInfo("Processo Finalizado!")
			Else

				MsgAlet("Nova Filial é igual a anterior, verificar o parametro!")
	
			EndIf

		EndIf

	Else

		MsgAlert("Processo Cancelado!")

	EndIf

	RestArea(aArea)

Return


/*/{Protheus.doc}xCriaSX1
Cria perguntas no arquivo SX1

@author RVG Soluções
@since 14/07/2016
@version MP11
/*/
Static Function xCriaSX1(cPerg)
	
	PutSx1(cPerg,"01","Filial Destino?          ","Filial Destino?          ","Filial Destino?          ","mv_ch1","C",2							,0                  	,0,"G","",""	,"","","mv_par02","","","","","","","","","","","","","","","","",{"Informe a Filial de Destino para a Transferencia."}	,{}	,{})
	
Return
