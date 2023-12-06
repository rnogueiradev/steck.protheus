#Include "Totvs.ch"

/*/{Protheus.doc} CH_L_PIMG
@author Ihorran Milholi
@since 17/05/2021
@version 1.0
/*/

/*
*/
    
User Function CH_L_PIMG(nParamDias)

Local cQuery := ""

cQuery += " SELECT"
cQuery += "     Z01.Z01_PRODUT  PRODUTO,"
cQuery += "     Z01.Z01_URL     URL,"
cQuery += "     row_number() over (partition by Z01.Z01_FILIAL,Z01.Z01_PRODUT order by Z01.Z01_FILIAL,Z01.Z01_PRODUT,Z01.Z01_URL) ORDEM,"
cQuery += "     row_number() over (order by Z01.Z01_FILIAL,Z01.Z01_PRODUT,Z01.Z01_URL) linha_tabela"

cQuery += " FROM "+RetSqlName("Z01")+" Z01"

cQuery += " WHERE"
cQuery += "     Z01.Z01_FILIAL  = '"+xFilial("Z01")+"'"
cQuery += " AND	Z01.D_E_L_E_T_  = ''"

Return cQuery
