#Include 'Protheus.ch'

/*/{Protheus.doc} PMA311IN
Função para verificar se existem check-list pendentes durante o apontamento de avanço fisico.
@author Robson Mazzarotto
@since 17/13/2017
@version 1.0
/*/


User Function PMA311IN()

Local aArea    := GetArea()
Local cRet     := .T.
Local cCheck   := .F.

dbSelectArea("AJO")
dbSetOrder(1)
dbGoTop()

IF dbSeek(xFilial("AJO")+AF9->AF9_PROJET+AF9->AF9_REVISA+AF9->AF9_TAREFA)

while !EOF() .AND. AJO->AJO_PROJET+AJO->AJO_REVISA+AJO->AJO_TAREFA == AF9->AF9_PROJET+AF9->AF9_REVISA+AF9->AF9_TAREFA

if EMPTY(AJO->AJO_INI)

cCheck := .T.

Endif

dbSkip()
Enddo

if cCheck
	MsgAlert("Esta Tarefa possui Check List pendente, favor verificar")
Endif

Endif

RestArea(aArea)
Return (cRet)
