#INCLUDE "Protheus.ch"

User Function FA070CA4()

Local _lRet := .t.

If SE1->E1_BAIXA <> DDATABASE 

_lRet := MSGYESNO("A data da baixa � diferente da data base do sistema. "+ Chr(13) + Chr(10)+" Deseja continuar?", "Aten��o ") 

EndIf

Return _lRet