User Function A710FILALM()

Local ni
Local aRet     := {}
Local nTamNNR   := TamSX3("NNR_CODIGO")[1]

IF TYPE("_A711NNR")=='A'

    Aadd(aRet,SubStr(_MVSTECK08,1,nTamNNR) ) 

    For nI:=1 To Len(_A711NNR) 
        If _A711NNR[nI , 1]
            Aadd(aRet,SubStr(_A711NNR[nI , 2],1,nTamNNR) ) 
        EndIf
    Next

Endif

Return IIf(Empty(aRet),Nil,aRet)
