/*
Função          : EECPEM36()
Parâmetros      : Nenhum
Retorno         : .T. / .F.
Objetivo        : Validar as alterações de quantidades no embarque. Não é permitido alterá-las quando
                  o processo de embarque é gerado sobre a rotina de embalagens da Steck.
Autor           : Julio de Paula Paz
Data/Hora       : 27/08/2010 - 10:00
Obs.            : 
*/

User Function EECPEM36()
Local lRet := .T.
Local aOrd := SaveOrd({"EE9","ZZA"})
Local nRegAtu := WorkIp->(Recno())
 
Begin Sequence
   If Type("aCampoVld") == "A"   // Esta condição indica que a função EECPEM36() está sendo chamada da função Ae100LinOk().
      ZZA->(DbSetOrder(4))
      EE9->(DbSetOrder(3))
      If ZZA->(DbSeek(xFilial("ZZA")+M->EEC_PREEMB))  
         WorkIp->(DbClearFilter())
         WorkIp->(DbGotop())
         Do While ! WorkIp->(Eof())
            If EE9->(DbSeek(xFilial("EE9")+WorkIp->(EE9_PREEMB+EE9_SEQEMB)))
               If WorkIp->EE9_SLDINI <> EE9->EE9_SLDINI .Or. Empty(WorkIp->WP_FLAG)
                  //lRet := .F.
                  lRet := .t.//giovani zago 01/06/2017 chamado arisla conferencia de nf
                  Exit
               EndIf
            Else
               lRet := .F.
               Exit
            EndIf
           
            WorkIp->(DbSkip())
         EndDo
                
         If ! lRet
            MsgInfo("Para processos gerados automaticamente, não é permitido alterar as quantidades, excluir ou incluir itens."+;
                    "Para alterar os itens deste processo, extorne-o completamente e crie um novo com os itens corretos.","Atenção")
         EndIf 
         WorkIP->(DbSetFilter({|| WP_FLAG == cMarca },"WP_FLAG =='"+cMarca+"'"))
         WorkIP->(dbGoTop())
      EndIf
   EndIf
End Sequence             

WorkIp->(DbGoTo(nRegAtu))
RestOrd(aOrd)

Return lRet