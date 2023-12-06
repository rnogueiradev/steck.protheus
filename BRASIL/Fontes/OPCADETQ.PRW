#INCLUDE "PROTHEUS.CH"

/*/{Protheus.doc} OPCADETQ
description
  CADASTRO ETIQUETAS DE ABASTECIMENTO
@type function
@version 
@author Valdemir Jose
@since 20/07/2020
@return return_type, return_description
u_OPCADETQ
/*/
USER FUNCTION OPCADETQ()
    Local cTitulo := "Cadastro Abasteciemntos"
    AXCADASTRO("PE3",cTitulo)
RETURN