#Include "Protheus.ch"
#Include "Rwmake.ch"

/*/{Protheus.doc} User Function MA261IN
    (long_description)
    Ponto de Entrada para Carregar o campo customizado
    @author user
    Valdemir Rabelo - SigaMat
    @since 22/10/2019
/*/
User Function MA261IN
    Local nPosCampo := aScan(aHeader, {|x| AllTrim(Upper(x[2]))=='D3_XUSUSOL' })
    
    if nPosCampo > 0
        SD3->(DbSkip(-1))
        aCols[Len(aCols),nPosCampo]    := SD3->D3_XUSUSOL
        SD3->(DbSkip())

        // ajuste para nao ocorrer erro
        Asize(acols[Len(aCols)], Len(aHeader)+1)
        aCols[Len(aCols), Len(aHeader)+1] := .f.         
    endif

Return