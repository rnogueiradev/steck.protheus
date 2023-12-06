#INCLUDE "PROTHEUS.CH"

/*/{Protheus.doc} User Function MA650LEG
    (long_description)
    Ponto de Entrada para adicionar Nova Legenda
    @author user
        VALDEMIR RABELO (SIGAMAT)
    @since 18/10/2019
    @example
    (examples)
/*/
User Function MA650LEG()

    Local aCorAux  := aClone(PARAMIXB[1])

    aadd(aCorAux,{'!Empty(C2_DATRF) .AND. !Empty(C2_XSTATSE)', 'BR_PINK', 'Encerrado s/ Movimento'})

Return aCorAux

