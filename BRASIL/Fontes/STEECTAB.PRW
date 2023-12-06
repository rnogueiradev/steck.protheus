#Include "Protheus.ch"

#DEFINE CR    chr(13)+chr(10)

/*/{Protheus.doc} u_STEECTAB

Garilhas a Tabela de Preço para o EEC

@type function
@author Everson Santana
@since 30/12/20
@version Protheus 12 - SIGAEEC

@history ,Ticket 20210122001213 ,

/*/
//M->EE7_IMPORT,M->EE7_IMLOJA,M->EE8_COD_I
User Function STEECTAB(cImport,cImpLoja,cImpCod)

Local nRet := 0
Local aArea := GetArea()

nRet := Posicione("DA1",1,xFilial("DA1")+Posicione("SA1",1,xFilial("SA1")+cImport+cImpLoja,"A1_XTABEEC")+cImpCod,"DA1_PRCVEN")                                  

If nRet = 0
    MsgInfo("Tabela de Preço não informada no cadastro do cliente: "+cImport+" Loja: "+cImpLoja+CR+CR+;
             "Por favor preencha o campo Tabela EEC no Cadastro de Clientes."   )
EndIf 

RestArea(aArea)

Return(nRet)