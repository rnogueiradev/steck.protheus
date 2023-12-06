#INCLUDE "PROTHEUS.CH"

/*/{Protheus.doc} User Function MA650BUT
    (long_description)
    Ponto de Entrada para adicionar novo botão na tela principal
    @author user
        VALDEMIR RABELO (SIGAMAT)
    @since 16/10/2019
    @example
    (examples)
/*/
User Function MA650BUT()
    AAdd(aRotina,{"Enc.sem movimento", "u_STPCPENC", 0 , 4, 0, Nil})
RETURN(aRotina)