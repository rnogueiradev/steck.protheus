#Include "Totvs.ch"

/*/{Protheus.doc} CH_L_ATR
@author Ihorran Milholi
@since 17/05/2021
@version 1.0
/*/

/*
CAMPOS PARA RETORNO DA QUERY
CATEGORIA
CODIGO
NOME
*/

User Function CH_L_ATR(nParamDias)

Local cQuery := ""

cQuery += " SELECT QRY.*
cQuery += "     ,row_number() over (order by QRY.FILIAL, QRY.CODIGO) linha_tabela"
cQuery += " FROM (

cQuery += " SELECT"
cQuery += " 	ACU.ACU_FILIAL  FILIAL,"
cQuery += "     ACU.ACU_COD  CATEGORIA," 
cQuery += "     '000001'+'-'+ ACU.ACU_COD CODIGO,"
cQuery += "     'VOLTAGEM' NOME,"
cQuery += "     'variacao' TIPO"
cQuery += " FROM "+RetSqlName("ACU")+" ACU"
cQuery += " WHERE"
cQuery += "     ACU.ACU_FILIAL   = '"+xFilial("ACU")+"'"
cQuery += " AND	ACU.D_E_L_E_T_  = ''"
cQuery += " AND	ACU.ACU_YIDWEB  <> ''"

cQuery += " UNION ALL"

cQuery += " SELECT"
cQuery += " 	ACU.ACU_FILIAL  FILIAL,"
cQuery += "     ACU.ACU_COD  CATEGORIA," 
cQuery += "     '000002'+'-'+ ACU.ACU_COD CODIGO,"
cQuery += "     'COR' NOME,"
cQuery += "     'variacao' TIPO"
cQuery += " FROM "+RetSqlName("ACU")+" ACU"
cQuery += " WHERE"
cQuery += "     ACU.ACU_FILIAL   = '"+xFilial("ACU")+"'"
cQuery += " AND	ACU.D_E_L_E_T_  = ''"
cQuery += " AND	ACU.ACU_YIDWEB  <> ''"

cQuery += " UNION ALL"

cQuery += " SELECT"
cQuery += " 	ACU.ACU_FILIAL  FILIAL,"
cQuery += "     ACU.ACU_COD  CATEGORIA," 
cQuery += "     '000003'+'-'+ ACU.ACU_COD CODIGO,"
cQuery += "     'TAMANHO' NOME,"
cQuery += "     'variacao' TIPO"
cQuery += " FROM "+RetSqlName("ACU")+" ACU"
cQuery += " WHERE"
cQuery += "     ACU.ACU_FILIAL   = '"+xFilial("ACU")+"'"
cQuery += " AND	ACU.D_E_L_E_T_  = ''"
cQuery += " AND	ACU.ACU_YIDWEB  <> ''"

cQuery += " UNION ALL"

cQuery += " SELECT"
cQuery += " 	ACU.ACU_FILIAL  FILIAL,"
cQuery += "     ACU.ACU_COD  CATEGORIA," 
cQuery += "     '000004'+'-'+ ACU.ACU_COD CODIGO,"
cQuery += "     'COR_DA_LUZ' NOME,"
cQuery += "     'variacao' TIPO"
cQuery += " FROM "+RetSqlName("ACU")+" ACU"
cQuery += " WHERE"
cQuery += "     ACU.ACU_FILIAL   = '"+xFilial("ACU")+"'"
cQuery += " AND	ACU.D_E_L_E_T_  = ''"
cQuery += " AND	ACU.ACU_YIDWEB  <> ''"

cQuery += " ) QRY " 

Return cQuery
