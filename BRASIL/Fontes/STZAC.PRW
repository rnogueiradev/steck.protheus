#include "protheus.ch" 
#include "parmtype.ch"
#include "topconn.ch"
 
 /*/{Protheus.doc} STZCA
Rotina para manuten��o nas regras de aprova��o de descontos. 
@author	Antonio Moura
@since	02/06/2023

/*/
User Function STZAC()

Private cString := "ZAC"

dbSelectArea(cString)
dbSetOrder(1)

AxCadastro(cString,"Regra de Aprova��o de Desconto",".T.",".T.")


Return ()
