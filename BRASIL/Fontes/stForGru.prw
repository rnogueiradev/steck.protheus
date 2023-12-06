#include "Protheus.ch"

/*/{Protheus.doc} stForGru
@description
Rotina para Grupo de Fornecedores
@type function
@version  1.0
@author Valdemir Jose
@since 11/11/2021
/*/
User Function stForGru
Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock. 

Private cString := "Z90"

dbSelectArea("Z90")
dbSetOrder(1)

AxCadastro(cString,"Cadastro de Grupo Fornecedores",cVldExc,cVldAlt)

Return 
