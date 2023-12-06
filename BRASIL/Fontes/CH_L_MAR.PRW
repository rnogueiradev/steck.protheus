#Include "Totvs.ch"

/*/{Protheus.doc} CH_L_MAR
@author Ihorran Milholi
@since 17/05/2021
@version 1.0
/*/

/*
CAMPOS PARA RETORNO DA QUERY
CODIGO
NOME
COMPRADOR
*/

User Function CH_L_MAR(nParamDias)

Local cQuery := ""

cQuery += " SELECT"
cQuery += "     CODIGO," 
cQuery += "     NOME,"
cQuery += "     row_number() over (order by CODIGO) linha_tabela"

cQuery += " FROM ( "

cQuery += "     SELECT"
cQuery += "         Z09.Z09_CODIGO CODIGO," 
cQuery += "         Z09.Z09_MARCA NOME"

cQuery += "     FROM "+RetSqlName("Z09")+" Z09"

cQuery += "     WHERE"
cQuery += "         Z09.Z09_FILIAL   = '"+xFilial("Z09")+"'"
//cQuery += "     AND	Z09.Z09_CODIGO   <> ''"
cQuery += "     AND	Z09.D_E_L_E_T_  <> '*'"

cQuery += "     GROUP BY"
cQuery += "         Z09.Z09_CODIGO, Z09.Z09_MARCA"

cQuery += " ) QRY "

Return cQuery
