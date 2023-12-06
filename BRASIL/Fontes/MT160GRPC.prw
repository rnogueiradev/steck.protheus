#INCLUDE "PROTHEUS.CH"
///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | AVALCOT.prw    | AUTOR | Ricardo Posman     | DATA | 08/12/2007 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | PE na gravacao do Pedido de Compra para buscar Motivo de        |//
//|           | Compra indicado na Solicitacao de Compra                        |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////


User Function MT160GRPC()

Local lRet		:=.T.
Local _aArea	:=GetArea()
Local aAreaSc7	:=SC7->(GetArea())
Local aAreaSC1	:=SC1->(GetArea())
Local aAreaSC8	:=SC8->(GetArea())

DbSelectArea("SC7")

SC7->(RecLock("SC7",.F.))
SC7->C7_XPRCORC	:=	SC8->C8_XPRCORC
SC7->(MsUnLock())

//If Empty(SC7->C7_MOTIVO)
	DbSelectArea("SC1")
	DbSetOrder(1)
	If Dbseek(xFilial("SC1")+SC7->C7_NUMSC+SC7->C7_ITEMSC,.t.)
		If RecLock("SC7",.f.)
			SC7->C7_MOTIVO  := SC1->C1_MOTIVO 
			SC7->C7_COMPSTK := SC1->C1_COMPSTK
            SC7->C7_XVL2UM  := SC8->C8_XVL2UM    // JEFFERSON VER CAMPO DE VL DE SEG UM NO C8 E NO C7
			MsUnlock()
		Endif
	Endif
//Endif

DbSelectArea("SC7")
RestArea(_aArea)
   
Return(lRet)       

