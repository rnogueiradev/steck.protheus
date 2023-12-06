#include 'Protheus.ch'
#include 'RwMake.ch'

/*/{Protheus.doc} F300FLT
(Ponto de Entrada para não baixar o PA no retorno bancário)

@author jefferson.carlos
@since 25/04/2018
@version 1.0
@return ${return}, ${return_description}

/*/

User Function F300FLT

Local _lRet := .T.

If SE2->E2_TIPO$"PA"
     DbSkip()
    _lRet := .F.     
Endif

return  _lRet
