#INCLUDE "Protheus.ch"

//-------------------------------------------------------------------
/*/{Protheus.doc} A103CLAS
description
    Ponto de Entrada para Manipular a coluna do armazem
@author  author
    Valdemir Rabelo - SigaMat
@since   date
    21/01/2020
@version version
/*/
//-------------------------------------------------------------------
User function A103CLAS()   
    Local cAliasSD1 := PARAMIXB[1]        //Customização do usuário.	
    Local nPosLocal := aScan(aHeader, {|X| ALLTRIM(X[2])=="D1_LOCAL"})	
    Local nPosProd  := aScan(aHeader, {|X| ALLTRIM(X[2])=="D1_COD"})	
    Local nX        := 0
    Local aArea103  := GetArea()

    if cFilant == "02"
        dbSelectArea("SA5")
        dbSetOrder(1)
        FOR nX := 1 to Len(aCols)
            if dbSeek(xFilial("SA5")+CA100FOR+cLOJA+aCOLS[nX][nPosProd])
               if !EMPTY(SA5->A5_XLOCAL)
                  aCols[nX][nPosLocal] := SA5->A5_XLOCAL
               Endif
            else
               Conout("Não encontrou registro na tabela [SA5] com a chave:"+CRLF+;
                     "Filial: "+xFilial("SA5")+CRLF+;
                     "Fornecedor: "+CA100FOR+CRLF+;
                     "Loja: "+cLOJA+CRLF+;
                     "Produto: "+aCOLS[nX][nPosProd] )
            Endif
        Next
    endif
    
    RestArea( aArea103 )

Return 