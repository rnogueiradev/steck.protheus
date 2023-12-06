#include "protheus.ch" 
#include "parmtype.ch"
#include "topconn.ch"
 
 /*/{Protheus.doc} STZCA
Rotina para manutenção nas regras de aprovação de descontos. 
@author	Antonio Moura
@since	02/06/2023

/*/
User Function STZAC()

Private cString := "ZAC"

dbSelectArea(cString)
dbSetOrder(1)

AxCadastro(cString,"Regra de Aprovação de Desconto",".T.",".T.")


Return ()
