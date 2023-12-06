#Include "Totvs.ch"

/*/{Protheus.doc} CH_PEDLIB
@author Ihorran Milholi
@since 17/05/2021
@version 1.0
/*/

User Function CH_PEDLIB(oPedido)

SC5->(dbSetOrder(1))
If SC5->(dbSeek(xFilial("SC5")+oPedido['codigoErp']))
    //Realiza estorno de liberação de estoque e credito      
    SC9->(dbSetOrder(1))
    If SC9->(dbSeek(xFilial('SC9')+SC5->C5_NUM))
        While SC9->(!Eof()) .and. xFilial('SC9')+SC5->C5_NUM == SC9->C9_FILIAL+SC9->C9_PEDIDO
            If Empty(SC9->C9_NFISCAL)
                SC6->(dbSetOrder(1))
                SC6->(dbSeek(xFilial("SC6")+SC9->C9_PEDIDO+SC9->C9_ITEM))                                           
                Begin Transaction
                    SC9->(a460Estorna())
                End Transaction
            EndIf
            SC9->(dbSkip())
        EndDo    
    EndIf
    //rotina de liberacao manual
    SC6->(dbSetOrder(1))
    If SC6->(dbSeek(xFilial('SC6')+SC5->C5_NUM))
        While SC6->(!Eof()) .and. xFilial('SC6')+SC5->C5_NUM == SC6->C6_FILIAL+SC6->C6_NUM
            MaLibDoFat(SC6->(RecNo()),SC6->C6_QTDVEN-SC6->C6_QTDENT,.T.,.T.,.F.,.F.,.T.,.T.,NIL,NIL,NIL,NIL,NIL,0)
            MaLiberOk({SC6->C6_NUM},.F.)
            MsUnLockall()
            dbcommitall()
            SC6->(dbSkip())
        EndDo
    EndIf
EndIf

Return 
