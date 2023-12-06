#Include "Protheus.ch"
#Include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT450FIM  ºAutor  ³Renato Nogueira     º Data ³  19/05/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada após liberação manual financeira por pedidoº±±
±±º          ³					                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ Pedido                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºRetorno	 ³ Nulo	                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ ÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MT450FIM()
	
	Local _aArea     := GetArea()
	
	U_STOFERLG(SC5->C5_FILIAL,SC5->C5_NUM,.T.) //Carregar informações da oferta  logística - Renato Nogueira - 28/05/2014  
	
	DbSelectArea("SC6")
	SC6->(DbSetOrder(1))
	
	IF SC6->(DbSeek(xFilial("SC6")+SC5->C5_NUM ))
		
		While SC6->(!Eof()) .and. SC6->C6_FILIAL = xFilial("SC6") .And. SC6->C6_NUM = SC5->C5_NUM
			U_STLOGFIN(SC6->C6_FILIAL,SC6->C6_NUM,SC6->C6_ITEM,SC6->C6_PRODUTO,SC6->C6_CLI,SC6->C6_LOJA,SC6->C6_PRCVEN,SC6->C6_QTDVEN,.T.,.F.)
			u_LOGJORPED("SC9","3",SC6->C6_PRODUTO,SC6->C6_ITEM,SC6->C6_NUM,"","Liberacao financeira")
			SC6->(DbSkip())
		End
		
	EndIf
	
	If Empty(Alltrim(SC5->C5_PEDEXP))
		_cc5Mail := Alltrim(Posicione("SA3",1,xFilial("SA3")+SC5->C5_VEND2,"A3_EMAIL"))+" ; "+Alltrim(Posicione("SA3",1,xFilial("SA3")+SC5->C5_VEND1,"A3_EMAIL"))+" ; "+Alltrim(Posicione("SA3",1,xFilial("SA3")+(Alltrim(Posicione("SA3",1,xFilial("SA3")+SC5->C5_VEND1,"A3_SUPER"))),"A3_EMAIL"))
	Else
		_cc5Mail := GetMv("ST_EXMAIL",,'' )
	EndIf
	
	u_StLibFinMail(' ','Liberação',cusername,dtoc(date()),time(),_cc5Mail,'Liberação')
	
	RestArea(_aArea)
	
Return()
