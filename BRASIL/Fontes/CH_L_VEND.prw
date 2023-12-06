#Include "Totvs.ch"

/*/{Protheus.doc} CH_L_VEND
@author Ihorran Milholi
@since 17/05/2021
@version 1.0
/*/

/*
CAMPOS PARA RETORNO DA QUERY
CODIGO
NOME
*/
    
User Function CH_L_VEND(nParamDias)

Local cQuery := ""

cQuery += " SELECT"
cQuery += "     SA3.A3_COD  CODIGO," 
cQuery += "     SA3.A3_NOME NOME,"
cQuery += "     row_number() over (order by SA3.A3_FILIAL, SA3.A3_COD) linha_tabela"

cQuery += " FROM "+RetSqlName("SA3")+" SA3"

cQuery += " WHERE"
cQuery += "     SA3.A3_FILIAL   = '"+xFilial("SA3")+"'"
//cQuery += " AND	SUBSTR(SA3.A3_COD,1,2)  = 'LV'"
cQuery += " AND	SUBSTR(SA3.A3_COD,1,6)  = 'S00019'"
cQuery += " AND	SA3.D_E_L_E_T_  <> '*'"

Return cQuery
