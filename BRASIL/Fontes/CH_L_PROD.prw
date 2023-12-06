#Include "Totvs.ch"

/*/{Protheus.doc} CH_L_PROD
@author Ihorran Milholi
@since 17/05/2021
@version 1.0
/*/

/*
*/
    
User Function CH_L_PROD(nParamDias)

Local cQuery := ""

cQuery := " SELECT 
cQuery += "     SB1.B1_COD                  CODIGO," 
cQuery += "     SB1.B1_COD                  CODIGOERP," 
cQuery += "     SB5.B5_CEME                 NOME,"
cQuery += "     CASE WHEN B1_XCODSE = 'S' THEN '0001' ELSE '0002' END MARCA,"
cQuery += "     SB1.B1_POSIPI               NCM,"
cQuery += "     SB1.B1_CODGTIN              CODIGOUNIVERSAL,"
cQuery += "     SB1.B1_ORIGEM               ORIGEM,"
cQuery += "     SB1.B1_PESO                 PESO,
cQuery += "     SB5.B5_ECLARGU              LARGURA,
cQuery += "     3                           GARANTIA,
cQuery += "     'MESES CONTRA DEFEITO DE FABRICACAO' TEXTOGARANTIA,
cQuery += "     SB5.B5_ECPROFU              PROFUNDIDADE,
cQuery += "     SB5.B5_ECCOMP               ALTURA,
cQuery += "     Z92_CODGRP                 CATEGORIA,
cQuery += "     CASE WHEN SB1.B1_MSBLQL = '2' THEN 'ativo' ELSE 'inativo' END STATUS,"
cQuery += "		DA1.DA1_PRCVEN PRECO,"
cQuery += "     row_number() over (order by SB1.B1_FILIAL, SB1.B1_COD) linha_tabela"

cQuery += " FROM "+ RetSqlName("SB1")+" SB1 "
cQuery += "	LEFT JOIN "+ RetSqlName("SBM")+" BM ON BM_GRUPO=B1_GRUPO AND BM.D_E_L_E_T_=' ' 
cQuery += " LEFT JOIN "+ RetSqlName("SB5")+" SB5 ON B5_FILIAL = '"+XFILIAL("SB5")+ "' AND SB5.D_E_L_E_T_ <> '*' AND B5_COD = B1_COD "
cQuery += " LEFT JOIN "+ RetSqlName("Z92")+" Z92 ON Z92_CODGRP= BM_XAGRUP2 AND Z92.D_E_L_E_T_=' ' 
cQuery += " INNER JOIN "+RetSqlName("DA1")+" DA1 ON DA1.DA1_FILIAL = '"+xFilial("DA1")+"' AND DA1.D_E_L_E_T_ <> '*' AND SB1.B1_COD = DA1.DA1_CODPRO AND DA1.DA1_CODTAB = '001'"

cQuery += " WHERE"
cQuery += "     SB1.D_E_L_E_T_  <> '*'"
cQuery += "     AND B1_FILIAL = '"+xFilial("SB1")+"'"  
cQuery += "     AND B1_MSBLQL <> '1'"
cQuery += " AND DA1_PRCVEN > 0 AND B1_TIPO = 'PA' AND B1_XDESAT <> '2'

Return cQuery
