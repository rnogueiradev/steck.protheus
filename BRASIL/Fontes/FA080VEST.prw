#Include 'Protheus.ch'

User Function FA080VEST()

	Local lRet := .T.

	If SE2->E2_BAIXA <> DDATABASE

		lRet := MsgYesNo("A data da baixa é diferente da data base do sistema. "+ Chr(13) + Chr(10)+" Deseja continuar?", "Atenção ")

	EndIf

Return lRet