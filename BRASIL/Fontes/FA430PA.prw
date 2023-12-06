#include 'Protheus.ch'
#include 'RwMake.ch'

/*/{Protheus.doc} FA430PA()
(Ponto de Entrada para não baixar o PA no retorno bancário)

@author cristiano.pereira
@since 25/04/2018
@version 1.0
@return ${return}, ${return_description}

/*/

User Function FA430PA()

Local _lRet := .T.

If RTRIM(SE2->E2_TIPO)$"PA"
    _lRet := .f.   
Endif

return(_lRet)
