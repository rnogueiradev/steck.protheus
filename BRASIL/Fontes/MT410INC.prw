#Include 'Protheus.ch'

/*/{Protheus.doc} MT410INC
Ponto de entrada para atualizar o bloqueio do financeiro para pedidos de transferencia entre filiais.
@author Robson Mazzarotto
@since 18/07/2017
@version 1.0
/*/

User Function MT410INC()

	Local aArea     := GetArea()
	Local _STCLITRA := SuperGetMV("ST_CLITRAN",.F.,"03346703") // Chamado 005430 - Robson Mazzarotto


	if SC5->C5_CLIENTE+SC5->C5_LOJACLI $ _STCLITRA

		RecLock("SC5",.F.)
		C5_ZFATBLQ:=""
		SC5->(MsUnLock())	

	Endif

	RestArea(aArea)

Return 

