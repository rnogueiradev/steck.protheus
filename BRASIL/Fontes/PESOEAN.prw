#include 'protheus.ch'
#include 'parmtype.ch'

/*
||------------------------------------------------------------------------------------------||
||Autor: Eduardo Matias - 06/11/2018														||
||Descrição: Fonte utilizado para realizar calculo de peso dos campos B1_XPESCOL/B1_XPESMAS	||
||conforme regras passadas pela engenharia.													||
||------------------------------------------------------------------------------------------||
*/

User function PESOEAN(cTipo)

	Local nPeso		:=	0
	Local aAreaBk	:=	GetArea()

	Default cTipo	:=	""

	If !Inclui

		dbSelectArea("SB5")
		dbSetOrder(1)
		If dbSeek(xFilial("SB5")+M->B1_COD)

			dbSelectArea("CB3")
			dbSetOrder(1)

			If cTipo="EAN141" .And. dbSeek(xFilial("CB3")+M->B1_XEMBCOL)

				//(B5_EAN141 * B1_PESBRU) + CB3_PESO
				nPeso :=	(SB5->B5_EAN141 * M->B1_PESBRU) + CB3->CB3_PESO

			ElseIf cTipo="EAN142" .And. dbSeek(xFilial("CB3")+M->B1_XEMBMAS )

				//{[(B5_EAN142 / B5_EAN141) * PESO EAN141] + CB3_PESO}
				nPeso :=	((SB5->B5_EAN142 / SB5->B5_EAN141) * M->B1_XPESCOL) + CB3->CB3_PESO

			EndIf

		EndIf

	EndIf

	RestArea(aAreaBk)

Return(nPeso)