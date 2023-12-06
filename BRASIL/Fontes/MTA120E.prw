#Include 'Protheus.ch'

/*/{Protheus.doc} MTA120E
Função para limpar as cotações após excluir o pedido de compra, chamado 005270.
No dia 16/03/17 existia o chamado 613007 na TOTVS sobre o padrão e não tinha sido respondido.
@author Robson Mazzarotto
@since 16/13/2017
@version 1.0
/*/

User Function MTA120E()

Local aArea     	:= GetArea()

dbSelectArea("SC8")
dbSetOrder(1)
dbGoTop()

if dbSeek(xFilial("SC8")+SC7->C7_NUMCOT)

	while !eof() .and. SC8->C8_NUM == SC7->C7_NUMCOT

		RecLock('SC8', .F.)
		SC8->C8_NUMPED  := ""
		SC8->C8_ITEMPED	:= ""
		SC8->(MsUnlock())

	dbSkip()
	Enddo

Endif

// ------- Valdemir Rabelo 03/06/2020
dbSelectArea("SC1")
dbSetOrder(6)
if dbSeek(xFilial("SC1")+SC7->C7_NUM+SC7->C7_ITEM)
	RecLock("SC1",.F.)
	SC1->C1_PEDIDO  := ""
	SC1->C1_ITEMPED := ""
	MsUnlock()
endif 
// ---------

RestArea(aArea)
	
Return

