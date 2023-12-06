/*/{Protheus.doc} CH_L_TRA
@author Ihorran Milholi
@since 17/05/2021
@version 1.0
/*/

/*
CAMPOS PARA RETORNO DA QUERY
NOME
CNPJ
FANTASIA
INSCRICAOESTADUAL
ENDERECO
BAIRRO
NUMERO
COMPLEMENTO
CEP
CIDADE
ESTADO
FONE
FAX
EMAIL
*/

User Function CH_L_TRA(nParamDias)

Local cQuery := ""

cQuery += " SELECT"
cQuery += "     SA4.A4_COD  CODIGO,"    
cQuery += "     SA4.A4_NOME NOME,"
cQuery += "     SA4.A4_CGC CNPJ,"
cQuery += "     SA4.A4_NOME FANTASIA,"
//cQuery += "     CASE WHEN SA4.A4_NREDUZ = '' THEN SA4.A4_NOME ELSE SA4.A4_NREDUZ END FANTASIA,"
cQuery += "     SA4.A4_INSEST as INSCRICAOESTADUAL,"
cQuery += "     SA4.A4_END ENDERECO,"
cQuery += "     SA4.A4_BAIRRO BAIRRO,"
cQuery += "     SA4.A4_CEP CEP,"
cQuery += "     SA4.A4_MUN CIDADE,"
cQuery += "     SA4.A4_EST ESTADO,"
cQuery += "     SA4.A4_COMPLEM COMPLEMENTO,"
cQuery += "     SA4.A4_TEL FONE,"
//cQuery += "     SA4.A4_EMAIL EMAIL,"
cQuery += "     row_number() over (order by SA4.A4_FILIAL, SA4.A4_COD) linha_tabela"

cQuery += " FROM "+RetSqlName("SA4")+" SA4"

cQuery += " WHERE"
cQuery += "     SA4.A4_FILIAL   = '"+xFilial("SA4")+"'"
cQuery += " AND	LENGTH(SA4.A4_CGC) = 14"
cQuery += " AND	SA4.D_E_L_E_T_  <> '*'"
cQuery += " AND SA4.A4_COD = '000001'"

Return cQuery
