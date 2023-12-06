#INCLUDE "PROTHEUS.CH"

/*/{Protheus.doc} STCADCONC
description
Cadastro de Concorrentes - // Valdemir Rabelo 23/10/2020 Ticket 20201022009332
@type function
@version 
@author Valdemir Jose
@since 23/10/2020
@return return_type, return_description
/*/
USER FUNCTION STCADCONC()
    Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
    Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.

    Private cString := "ZA1"

    AxCadastro(cString,"Cadastro de Concorrentes",cVldExc,cVldAlt)

RETURN