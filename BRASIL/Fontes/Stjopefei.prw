#include "rwmake.ch"
#include "tbiconn.ch"
#include "ap5mail.ch"


/*====================================================================================\
|Programa  | StPA1PA2         | Autor | GIOVANI.ZAGO             | Data | 15/04/2013  |
|=====================================================================================|
|Descrição | StPA1PA2                                                                 |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | StPA1PA2                                                                 |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
User Function StPA1PA2(nRet)
*-----------------------------*
Local cNumPed                := ''//SC5->C5_NUM
Local aArea        := GetArea()
Local aSC6Area := SC6->(GetArea())
Local cItemPed  := ''
Local cProduto  := ''
Local nQtde           := 0
Local _aStped   := {}
Local i
Local _CPED                       := ''
Local _lRet                         := .F.


If nRet<>0
                _aStped:=aclone(GalloReserv(nRet))
Else
aadd(_aStped,'24589517')
aadd(_aStped,'24593625')
EndIf
For i:=1 To Len(_aStped)
                _CPED:= substr(_aStped[i] ,1,6)
                
                DbSelectArea("SC5")
                SC5->(DbSetOrder(1))
                If SC5->(DbSeek(xFilial('SC5')+_CPED))
                               DbSelectArea("SC6")
                               SC6->(DbSetOrder(1))
                               SC6->(DbSeek(xFilial('SC6')+ _aStped[i]))
                               Do While SC6->(!Eof()) .And. _aStped[i] = SC6->C6_NUM+SC6->C6_ITEM
                                               
                                               dbSelectArea("SC9")
                                               SC9->(  dbSetOrder(1) )
                                               If             SC9->(dbSeek(xFilial("SC9")+SC6->C6_NUM+SC6->C6_ITEM))  .and. Empty (SC9->C9_ORDSEP) .And. Empty(SC9->C9_NFISCAL)
                                                               
                                                               
                                                               
                                                               
                                                               If AvalTes(SC6->C6_TES,'S')
                                                                              cItemPed := SC6->C6_ITEM
                                                                              cProduto := SC6->C6_PRODUTO
                                                                              nQtde   := SC6->C6_QTDVEN-SC6->C6_QTDENT
                                                                              DbSelectArea("PA1")
                                                                              PA1->(DbSetOrder(2))
                                                                              If PA1->(DbSeek(xFilial('PA1')+"1"+_CPED+cItemPed))
                                                                                              Do While PA1->(!Eof()) .And. PA1->PA1_DOC = _CPED+cItemPed  .And. PA1->PA1_TIPO = '1'
                                                                                                              
                                                                                                              _lRet                     := .T.
                                                                                                              PA1->(DbSkip())
                                                                                              ENDDO
                                                                              EndIf
                                                                              
                                                                              DbSelectArea("PA2")
                                                                              PA2->(DbSetOrder(2))
                                                                              If PA2->(DbSeek(xFilial('PA2')+"1"+_CPED+cItemPed))
                                                                                              Do While PA2->(!Eof()) .And. PA2->PA2_DOC = _CPED+cItemPed  .And. PA2->PA2_TIPO = '1'
                                                                                                              
                                                                                                              _lRet                     := .T.
                                                                                                              
                                                                                                              PA2->(DbSkip())
                                                                                              ENDDO
                                                                              EndIf
                                                                              
                                                               EndIf
                                               EndIf
                                               
                                               SC6->(DbSkip())
                                               
                                               SC5->(U_STGrvSt(C5_NUM,C5_XTIPF=="2"))  // analisa e grava o status
                                               U_STPriSC5()  // grava prioridade
                               End
                EndIf
                
next i
Return()


/*====================================================================================\
|Programa  | GalloReserv        | Autor | GIOVANI.ZAGO             | Data | 22/01/2013  |
|=====================================================================================|
|Descrição | GalloReserv  JOB                                                                                                   |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | GalloReserv                                                                |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*

Static Function GalloReserv(nRet)

Local _aGallo:= {}

If nRet = 1 

aadd(_agallo,'AAAARY05')
aadd(_agallo,'24580418')
aadd(_agallo,'24586701')
aadd(_agallo,'24586702')
aadd(_agallo,'24586703')
aadd(_agallo,'24586704')
aadd(_agallo,'24586705')
aadd(_agallo,'24586706')
aadd(_agallo,'24586707')
aadd(_agallo,'24586708')
aadd(_agallo,'24586709')
aadd(_agallo,'24586711')
aadd(_agallo,'24586712')
aadd(_agallo,'24586713')
aadd(_agallo,'24586714')
aadd(_agallo,'24586715')
aadd(_agallo,'24586716')
aadd(_agallo,'24586717')
aadd(_agallo,'24586718')
aadd(_agallo,'24586719')
aadd(_agallo,'24586720')
aadd(_agallo,'24586721')
aadd(_agallo,'24586722')
aadd(_agallo,'24586723')
aadd(_agallo,'24586724')
aadd(_agallo,'24586725')
aadd(_agallo,'24586726')
aadd(_agallo,'24586728')
aadd(_agallo,'24586729')
aadd(_agallo,'24586730')
aadd(_agallo,'24586732')
aadd(_agallo,'24586919')
aadd(_agallo,'24589517')
aadd(_agallo,'24593625')
aadd(_agallo,'24595802')
aadd(_agallo,'24595803')
aadd(_agallo,'24595805')
aadd(_agallo,'24595806')
aadd(_agallo,'24595810')
aadd(_agallo,'24595811')
aadd(_agallo,'24595812')
aadd(_agallo,'24595813')
aadd(_agallo,'24595816')
aadd(_agallo,'24595817')
aadd(_agallo,'24595818')
aadd(_agallo,'24595819')
aadd(_agallo,'24595820')
aadd(_agallo,'24595821')
aadd(_agallo,'24595822')
aadd(_agallo,'24595823')
aadd(_agallo,'24595824')
aadd(_agallo,'24595826')
aadd(_agallo,'24595827')
aadd(_agallo,'24595831')
aadd(_agallo,'24595832')
aadd(_agallo,'24595833')
aadd(_agallo,'24595836')
aadd(_agallo,'24595837')
aadd(_agallo,'24595838')
aadd(_agallo,'24595842')
aadd(_agallo,'24595846')
aadd(_agallo,'24595847')
aadd(_agallo,'24595848')
aadd(_agallo,'24595851')
aadd(_agallo,'24595852')
aadd(_agallo,'24595854')
aadd(_agallo,'24595859')
aadd(_agallo,'24595860')
aadd(_agallo,'24595864')
aadd(_agallo,'24595865')
aadd(_agallo,'24595869')
aadd(_agallo,'24595870')
aadd(_agallo,'24595871')
aadd(_agallo,'24596601')
aadd(_agallo,'24598224')
aadd(_agallo,'24603141')
aadd(_agallo,'24610521')
aadd(_agallo,'24612017')
aadd(_agallo,'24612710')
aadd(_agallo,'24618401')
aadd(_agallo,'24618402')
aadd(_agallo,'24618403')
aadd(_agallo,'24619908')
aadd(_agallo,'24621615')
aadd(_agallo,'24623726')
aadd(_agallo,'24627101')
aadd(_agallo,'24627102')
aadd(_agallo,'24627103')
aadd(_agallo,'24627104')
aadd(_agallo,'24627105')
aadd(_agallo,'24627106')
aadd(_agallo,'24627107')
aadd(_agallo,'24627109')
aadd(_agallo,'24627111')
aadd(_agallo,'24627112')
aadd(_agallo,'24627114')
aadd(_agallo,'24627115')
aadd(_agallo,'24627116')
aadd(_agallo,'24627117')
aadd(_agallo,'24627118')
aadd(_agallo,'24627119')
aadd(_agallo,'24627122')
aadd(_agallo,'24627123')
aadd(_agallo,'24627124')
aadd(_agallo,'24627125')
aadd(_agallo,'24627126')
aadd(_agallo,'24627127')
aadd(_agallo,'24627129')
aadd(_agallo,'24632201')
aadd(_agallo,'24632202')
aadd(_agallo,'24632203')
aadd(_agallo,'24637861')
aadd(_agallo,'24638206')
aadd(_agallo,'24639101')
aadd(_agallo,'24640013')
aadd(_agallo,'24640502')
aadd(_agallo,'24641426')
aadd(_agallo,'24643101')
aadd(_agallo,'24645015')
aadd(_agallo,'24645642')
aadd(_agallo,'24648302')
aadd(_agallo,'24650509')
aadd(_agallo,'24651218')
aadd(_agallo,'24651219')
aadd(_agallo,'24651220')
aadd(_agallo,'24651221')
aadd(_agallo,'24651222')
aadd(_agallo,'24651223')
aadd(_agallo,'24651224')
aadd(_agallo,'24651225')
aadd(_agallo,'24651226')
aadd(_agallo,'24653119')
aadd(_agallo,'24653802')
aadd(_agallo,'24653803')
aadd(_agallo,'24657014')
aadd(_agallo,'24657313')
aadd(_agallo,'24657506')
aadd(_agallo,'24660814')
aadd(_agallo,'24665633')
aadd(_agallo,'24668747')
aadd(_agallo,'24670105')
aadd(_agallo,'24673026')
aadd(_agallo,'24673201')
aadd(_agallo,'24673425')
aadd(_agallo,'24678508')
aadd(_agallo,'24680301')
aadd(_agallo,'24680302')
aadd(_agallo,'24680303')
aadd(_agallo,'24680304')
aadd(_agallo,'24680305')
aadd(_agallo,'24680306')
aadd(_agallo,'24680307')
aadd(_agallo,'24680401')
aadd(_agallo,'24680402')
aadd(_agallo,'24680403')
aadd(_agallo,'24680404')
aadd(_agallo,'24680405')
aadd(_agallo,'24680407')
aadd(_agallo,'24680408')
aadd(_agallo,'24680409')
aadd(_agallo,'24680410')
aadd(_agallo,'24681993')
aadd(_agallo,'24682222')
aadd(_agallo,'24683801')
aadd(_agallo,'24683802')
aadd(_agallo,'24687515')
aadd(_agallo,'24688211')
aadd(_agallo,'24688409')
aadd(_agallo,'24692719')
aadd(_agallo,'24693536')

EndIf
Return(_aGallo)

