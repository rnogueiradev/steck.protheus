#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"

/*====================================================================================\
|Programa  | MT170FIM        | Autor | RENATO.OLIVEIRA           | Data | 26/11/2018  |
|=====================================================================================|
|Descrição | PE AO FINAL DA GERACAO DAS SCS POR PONTO DE PEDIDO                       |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function MT170FIM()

	Local aScs 	:= PARAMIXB[1]
	Local nX 	:= 0
	//>> Ticket  20190911000019 - Everson Santana - 18.09.2019
	Local oDlg, oGet

	Private _cMot 		:= Space(6)
	Private _cCusto 	:= Space(10)
	Private nOpca		:= 0

	DEFINE MSDIALOG oDlg TITLE "Informe o Motivo e o Centro de Custos" From 200,200 To 380,500 OF oMainWnd PIXEL

	@ 010,020 SAY "Informe o Motivo e o Centro de Custos" OF oDlg PIXEL

	@ 030,020 SAY "Motivo:" OF oDlg PIXEL
	@ 030,075 MSGET _cMot   Picture PesqPict("SC1","C1_MOTIVO") F3 "SZ1" When .t. OF oDlg PIXEL SIZE 60,10 RIGHT
	@ 045,020 SAY "Centro de Custo:" OF oDlg PIXEL
	@ 045,075 MSGET _cCusto  Picture PesqPict("SC1","C1_CC") F3 "CTT" When .t. OF oDlg PIXEL SIZE 60,10 RIGHT

	@ 065,075 BUTTON "Confirmar" SIZE 030, 015 PIXEL OF oDlg ACTION (nOpca := 1, oDlg:End())
	@ 065,115 BUTTON "Cancelar" SIZE 030, 015 PIXEL OF oDlg ACTION (nOpca := 0, oDlg:End())

	ACTIVATE MSDIALOG oDlg

	If nOpcA == 1

		//<< Ticket  20190911000019 - Everson Santana - 18.09.2019

		DbSelectArea("SC1")
		SC1->(DbSetOrder(1))

		For nX:= 1 To Len(aScs)

			If SC1->(DbSeek(xFilial("SC1")+aScs[nX,2]))

				While SC1->(!Eof()) .And. SC1->(C1_FILIAL+C1_NUM)==xFilial("SC1")+aScs[nX,2]

					SC1->(RecLock("SC1",.F.))
					SC1->C1_MOTIVO  := _cMot
					SC1->C1_CC		:= _cCusto
					SC1->C1_ZAPROV 	:= GetMv("ST_APRPPE",,"000084")
					SC1->C1_ZSTATUS := "1"
					SC1->C1_LOCAL 	:= Posicione("SB1",1,xFilial("SB1")+SC1->C1_PRODUTO,"B1_LOCPAD") //Ticket  20190911000019 - Everson Santana - 18.09.2019
					SC1->C1_DATPRF 	:= Date()+10
					SC1->(MsUnlock())

					SC1->(DbSkip())
				EndDo

			Endif

		Next

	EndIf

Return()