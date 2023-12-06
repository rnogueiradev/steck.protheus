#INCLUDE "PROTHEUS.CH"

/*/{Protheus.doc} STORC001
description
Cadastro de prazo de orçamentos
chamado: 20200806005285
@type function
@version 
@author Valdemir Jose
@since 26/08/2020
@return return_type, return_description
/*/
USER FUNCTION STORC001()
    Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
    Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock. 

    Private cString := "PE4"

    dbSelectArea(cString)
    dbSetOrder(1)

    AxCadastro(cString,"CADASTRO DE PRAZOS DE ORCAMENTO",cVldExc,cVldAlt)

RETURN