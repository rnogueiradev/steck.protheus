#INCLUDE "PROTHEUS.CH" 

User Function NFSEVC()
Local aAreaSM0   := SM0->(GETAREA())
msginfo("Nfs-e Araxa Mod.: Governa")

/* 11/05/23 - Alterar a lógica do programa para utilizar as API padrões de leitura do metadados 
e remover o uso de qualquer API de manipulação do metadados.
Toda e qualquer manipulação de dados deve ser feita apenas pelo módulo Configurador
 ou pela rotina de atualização de versão.*/

/* Removido 11/05/23 - Não executa mais Recklock na SM0 - Nova tabela SYS_COMPANY
dbSelectArea("SM0")
SM0->(RecLock("SM0",.F.))
SM0->M0_CODMUN := "3148004"
SM0->(MsUnLock())
*/
FISA022()
/* Removido 11/05/23 - Não executa mais Recklock na SM0 - Nova tabela SYS_COMPANY
dbSelectArea("SM0")
SM0->(RecLock("SM0",.F.))
SM0->M0_CODMUN := "3104007"
SM0->(MsUnLock())
*/

RestArea(aAreaSM0)

msginfo("finalizado")
RETURN()
