#INCLUDE "TOTVS.CH"
#INCLUDE "RWMAKE.CH"

/*/{Protheus.doc} MT094LBF
@name MT094LBF
@type User Function
@desc adicionar fun��es na rotina de libera��o de documentos
@author Renato Nogueira
@since 29/05/2018
/*/

User Function MT094LBF()

	Local lRet := .F. //N�o filtrar por filial

	SetKey( VK_F3, {|| MATR140(,,"1") })

Return(lRet)