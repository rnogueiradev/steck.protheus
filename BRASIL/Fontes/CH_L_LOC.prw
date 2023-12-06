#Include "Totvs.ch"

/*/{Protheus.doc} CH_L_LOC
@author Ihorran Milholi
@since 17/05/2021
@version 1.0
/*/

/*
CAMPOS PARA RETORNO DA QUERY
CODIGO
NOME
*/
    
User Function CH_L_LOC(nParamDias)

Local cQuery := ""

cQuery += " SELECT"
cQuery += "     NNR.NNR_CODIGO  CODIGO," 
cQuery += "     NNR.NNR_DESCRI  NOME,"
cQuery += "     'sim'           PADRAO,"
cQuery += "     'ativo'         STATUS,"
cQuery += "     row_number() over (order by NNR.NNR_FILIAL, NNR.NNR_CODIGO) linha_tabela"

cQuery += " FROM "+RetSqlName("NNR")+" NNR"

cQuery += " WHERE"
cQuery += "     NNR.NNR_FILIAL  = '"+xFilial("NNR")+"'"
cQuery += " AND	NNR.NNR_CODIGO  = '03'"
cQuery += " AND	NNR.D_E_L_E_T_  <> '*'"

Return cQuery
