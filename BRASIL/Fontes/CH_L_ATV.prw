#Include "Totvs.ch"

/*/{Protheus.doc} CH_L_ATV
@author Ihorran Milholi
@since 17/05/2021
@version 1.0
/*/

/*
CAMPOS PARA RETORNO DA QUERY
CATEGORIA
ATRIBUTO
CODIGO
NOME
*/

User Function CH_L_ATV(nParamDias)

Local cQuery := ""

//SELECT DISTINCT Z06_CODVAR, Z06_VARIAC FROM Z06010 WHERE D_E_L_E_T_ = ' ' ORDER BY Z06_CODVAR


cQuery += " SELECT QRY.*
cQuery += "     ,row_number() over (order by QRY.CATEGORIA_NOME) linha_tabela"
cQuery += " FROM (

cQuery += " SELECT "
cQuery += "     ACU.ACU_DESC CATEGORIA_NOME," 
cQuery += "     'VOLTAGEM'  ATRIBUTO_NOME,"
cQuery += "     Z06_VARIAC  CODIGO,"
cQuery += "     Z06_VARIAC  NOME"
//cQuery += "     row_number() over (order by ACU.ACU_FILIAL, ACU.ACU_DESC) linha_tabela"
cQuery += " FROM "+RetSqlName("ACU")+" ACU"
cQuery += " INNER JOIN Z06010 Z06 ON Z06.D_E_L_E_T_ = ' ' AND Z06.Z06_CODVAR = '000001' 
cQuery += " WHERE"
cQuery += "     ACU.ACU_FILIAL   = '"+xFilial("ACU")+"'"
cQuery += " AND	ACU.D_E_L_E_T_  = ''"
cQuery += " AND	ACU.ACU_YIDWEB  <> ''"
cQuery += " GROUP BY ACU.ACU_FILIAL, ACU.ACU_DESC, Z06.Z06_CODVAR, Z06_VARIAC"

cQuery += " UNION ALL"

cQuery += " SELECT "
cQuery += "     ACU.ACU_DESC CATEGORIA_NOME," 
cQuery += "     'COR'  ATRIBUTO_NOME,"
cQuery += "     Z06_VARIAC  CODIGO,"
cQuery += "     Z06_VARIAC  NOME"
//cQuery += "     row_number() over (order by ACU.ACU_FILIAL, ACU.ACU_DESC) linha_tabela"
cQuery += " FROM "+RetSqlName("ACU")+" ACU"
cQuery += " INNER JOIN Z06010 Z06 ON Z06.D_E_L_E_T_ = ' ' AND Z06.Z06_CODVAR = '000002' 
cQuery += " WHERE"
cQuery += "     ACU.ACU_FILIAL   = '"+xFilial("ACU")+"'"
cQuery += " AND	ACU.D_E_L_E_T_  = ''"
cQuery += " AND	ACU.ACU_YIDWEB  <> ''"
cQuery += " GROUP BY ACU.ACU_FILIAL, ACU.ACU_DESC, Z06.Z06_CODVAR, Z06_VARIAC"

cQuery += " UNION ALL"

cQuery += " SELECT "
cQuery += "     ACU.ACU_DESC CATEGORIA_NOME," 
cQuery += "     'TAMANHO'  ATRIBUTO_NOME,"
cQuery += "     Z06_VARIAC  CODIGO,"
cQuery += "     Z06_VARIAC  NOME"
//cQuery += "     row_number() over (order by ACU.ACU_FILIAL, ACU.ACU_DESC) linha_tabela"
cQuery += " FROM "+RetSqlName("ACU")+" ACU"
cQuery += " INNER JOIN Z06010 Z06 ON Z06.D_E_L_E_T_ = ' ' AND Z06.Z06_CODVAR = '000003' 
cQuery += " WHERE"
cQuery += "     ACU.ACU_FILIAL   = '"+xFilial("ACU")+"'"
cQuery += " AND	ACU.D_E_L_E_T_  = ''"
cQuery += " AND	ACU.ACU_YIDWEB  <> ''"
cQuery += " GROUP BY ACU.ACU_FILIAL, ACU.ACU_DESC, Z06.Z06_CODVAR, Z06_VARIAC"

cQuery += " UNION ALL"

cQuery += " SELECT "
cQuery += "     ACU.ACU_DESC CATEGORIA_NOME," 
cQuery += "     'COR_DA_LUZ'  ATRIBUTO_NOME,"
cQuery += "     Z06_VARIAC  CODIGO,"
cQuery += "     Z06_VARIAC  NOME"
//cQuery += "     row_number() over (order by ACU.ACU_FILIAL, ACU.ACU_DESC) linha_tabela"
cQuery += " FROM "+RetSqlName("ACU")+" ACU"
cQuery += " INNER JOIN Z06010 Z06 ON Z06.D_E_L_E_T_ = ' ' AND Z06.Z06_CODVAR = '000004' 
cQuery += " WHERE"
cQuery += "     ACU.ACU_FILIAL   = '"+xFilial("ACU")+"'"
cQuery += " AND	ACU.D_E_L_E_T_  = ''"
cQuery += " AND	ACU.ACU_YIDWEB  <> ''"
cQuery += " GROUP BY ACU.ACU_FILIAL, ACU.ACU_DESC, Z06.Z06_CODVAR, Z06_VARIAC"

cQuery += " ) QRY " 

Return cQuery

