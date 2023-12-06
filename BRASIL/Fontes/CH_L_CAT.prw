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
    
User Function CH_L_CAT(nParamDias)

Local cQuery := ""

cQuery += " SELECT"
cQuery += "     Z92.Z92_CODGRP     CODIGO," 
cQuery += "     REPLACE(Z92.Z92_DSCGRP,'/','-')    NOME,"
//cQuery += "     ACU.ACU_CODPAI  CATEGORIAPAI,"
cQuery += "     row_number() over (order by Z92.Z92_FILIAL, Z92.Z92_CODGRP) linha_tabela"

cQuery += " FROM "+RetSqlName("Z92")+" Z92"

cQuery += " WHERE"
cQuery += "     Z92.Z92_FILIAL   = '"+xFilial("Z92")+"'"
cQuery += " AND	Z92.D_E_L_E_T_  <> '*'"
//cQuery += " AND	SBM.BM_GRUPO = '000'"
//cQuery += " AND	ACU.ACU_YIDWEB  <> ''"

Return cQuery
