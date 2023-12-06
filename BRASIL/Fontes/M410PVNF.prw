#Include 'Protheus.ch'

User Function M410PVNF()


	Local cStatus	:= SC5->C5_XPLAAPR
	Local lCont	:= .T.
	
	If !EMPTY(cStatus)
		Alert("Este pedido não pode ser faturado manualmente, pois trata-se de um pedido de remessa de beneficiamento!")
		lCont	:= .F.
	EndIf		


Return lCont

