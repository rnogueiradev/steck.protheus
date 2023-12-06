#include "Protheus.ch"

/*/{Protheus.doc} stFrFlCX
@description
Rotina para Fluxo Caixa de Fornecedores
@type function
@version  1.0
@author Valdemir Jose
@since 11/11/2021
/*/
User Function stFrFlCX
Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock. 

Private cString := "Z91"

dbSelectArea("Z91")
dbSetOrder(1)

AxCadastro(cString,"Cadastro - Fluxo Caixa de Fornecedores",cVldExc,cVldAlt)

Return
