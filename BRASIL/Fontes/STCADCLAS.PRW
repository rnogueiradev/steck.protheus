#INCLUDE "PROTHEUS.CH"

/*/{Protheus.doc} STCADCLAS
description
   Rotina Cadastro de Classificação processos
@type function
@version 
@author Valdemir Jose
@since 16/06/2020
@return return_type, return_description
/*/
USER FUNCTION STCADCLAS()
    Local cST_CLASPRC  := SuperGetMV("ST_CLASPRC",,"001257")
    Local _cTitulo     := "Cadastro Classificação Processos"

    cST_CLASPRC += "#001246"

    //If __cUserId $ cST_CLASPRC
        Dbselectarea("Z77")     // Z75
        AxCadastro("Z77",_cTitulo)
    // Else
    //     MsgAlert("Usuário sem permissão para utilizar essa rotina")
    // EndIf

RETURN