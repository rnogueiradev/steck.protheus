#Include "Average.ch"

/*
Função          : EECPAE01()
Parâmetros      : Nenhum
Retorno         : .T. / .F.
Objetivo        : Excluir os dados da tabela ZZA quando o processo de embarque for excluido totalmente.
Autor           : Julio de Paula Paz
Data/Hora       : 27/08/2010 - 10:00
Obs.            : 
*/

User Function EECPAE01()
Local lRet
Local cParam := If(Type("ParamIxb")=="A",ParamIxb[1],ParamIxb)

Begin Sequence
   Do Case
      Case cParam == "EXCLUINDO TUDO"      
           ZZA->(DbSetOrder(4))
           ZZA->(DbSeek(xFilial("ZZA")+M->EEC_PREEMB))  
           Do While !ZZA->(Eof()) .And. ZZA->(ZZA_FILIAL+ZZA_PREEMB) == xFilial("ZZA")+M->EEC_PREEMB
              ZZA->(RecLock("ZZA",.F.))
              ZZA->(DbDelete())
              ZZA->(MsUnlock())
              ZZA->(DbSkip())
           EndDo
      
   EndCase

End Sequence

Return lRet