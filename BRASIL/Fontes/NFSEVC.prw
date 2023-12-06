#INCLUDE "PROTHEUS.CH" 

User Function NFSEVC()
Local aAreaSM0   := SM0->(GETAREA())
msginfo("Nfs-e Araxa Mod.: Governa")

/* 11/05/23 - Alterar a l�gica do programa para utilizar as API padr�es de leitura do metadados 
e remover o uso de qualquer API de manipula��o do metadados.
Toda e qualquer manipula��o de dados deve ser feita apenas pelo m�dulo Configurador
 ou pela rotina de atualiza��o de vers�o.*/

/* Removido 11/05/23 - N�o executa mais Recklock na SM0 - Nova tabela SYS_COMPANY
dbSelectArea("SM0")
SM0->(RecLock("SM0",.F.))
SM0->M0_CODMUN := "3148004"
SM0->(MsUnLock())
*/
FISA022()
/* Removido 11/05/23 - N�o executa mais Recklock na SM0 - Nova tabela SYS_COMPANY
dbSelectArea("SM0")
SM0->(RecLock("SM0",.F.))
SM0->M0_CODMUN := "3104007"
SM0->(MsUnLock())
*/

RestArea(aAreaSM0)

msginfo("finalizado")
RETURN()
