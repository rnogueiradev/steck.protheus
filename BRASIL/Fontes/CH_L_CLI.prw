/*/{Protheus.doc} CH_L_CLI
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

User Function CH_L_CLI(nParamDias)

Local cQuery := ""

cQuery += " SELECT"
cQuery += "     SA1.A1_COD      CODIGOERP,"    
cQuery += "     SA1.A1_NOME     NOME,"
cQuery += "     SA1.A1_CGC      CNPJ,"
cQuery += "     SA1.A1_INSCR    INSCRICAOESTADUAL,"
cQuery += "     SA1.A1_END      ENDERECO,"
cQuery += "     SA1.A1_BAIRRO   BAIRRO,"
cQuery += "     SA1.A1_CEP      CEP,"
cQuery += "     SA1.A1_MUN      CIDADE,"
cQuery += "     SA1.A1_EST      ESTADO,"
cQuery += "     SA1.A1_COMPLEM  COMPLEMENTO,"
cQuery += "     SA1.A1_TEL      FONE,"
cQuery += "     CASE WHEN SA1.A1_NREDUZ = '' THEN SA1.A1_NOME ELSE SA1.A1_NREDUZ END FANTASIA,"
cQuery += "     row_number() over (order by SA1.A1_FILIAL, SA1.A1_COD) linha_tabela"

cQuery += " FROM  "+RetSqlName("SA1")+" SA1"

cQuery += " WHERE"
cQuery += " SA1.D_E_L_E_T_  <> '*'"
cQuery += " AND	SA1.A1_COD = '000001'"
//cQuery += "     SA1.A1_FILIAL   <> '*'"
//cQuery += " AND	LEN(SA1.A1_CGC) = 14"

Return cQuery
