#Include 'Protheus.ch'

/*/{Protheus.doc} F470ALLF

Ponto de entrada para trazer todas as filias no relatorio FINR470 - Extrato bancário.
@type function
 
@author Robson Mazzarotto
@since 03/02/2017
@version P11
 
@return lógico
/*/

User Function F470ALLF()

Local lAllfil := ParamIxb[1]

Return .T.

