#Include "Totvs.ch"

/*/{Protheus.doc} CH_L_PCAN
@author Ihorran Milholi
@since 17/05/2021
@version 1.0
/*/

/*
CAMPOS PARA RETORNO DA QUERY
RASTREAMENTO
TRANSPORTADORA_CNPJ
TRANSPORRADORA_NOME
NUMERO
SERIE
*/

User Function CH_L_PCAN(nParamDias,cCodigoErp)

Local cQuery := ""
//valores default
Default cCodigoErp := ""

cQuery += " SELECT  QRY.C6_NUM  CODIGOERP,"
cQuery += "         row_number() over (order by QRY.C6_NUM) linha_tabela"

cQuery += " FROM ( "

cQuery += " SELECT  SC6.C6_NUM,"
cQuery += "         CASE WHEN SC6.C6_QTDENT = 0 AND SC6.C6_BLQ = 'R' THEN 1 ELSE 0 END BLQ,"
cQuery += "         1 ITEM "

cQuery += " FROM "+RetSqlName("SC6")+" SC6"

cQuery += "     INNER JOIN "+RetSqlName("SC5")+" SC5 ON SC5.C5_FILIAL   = SC6.C6_FILIAL"
cQuery += "                                         AND SC5.C5_NUM      = SC6.C6_NUM"
cQuery += "                                         AND SC5.D_E_L_E_T_  = ''"

cQuery += " WHERE   SC6.D_E_L_E_T_  = ''"
cQuery += "     AND SC5.C5_EMISSAO >= '"+dtos(DaySub(dDatabase,nParamDias))+"'"
//verifica se existe filtro de codigo do pedido
if (!Empty(cCodigoErp))
    cQuery += " AND SC6.C6_NUM = '"+AllTrim(cCodigoErp)+"'"
endif

cQuery += " ) QRY "
cQuery += " GROUP BY QRY.C6_NUM "
cQuery += " HAVING  SUM(QRY.BLQ) = SUM(QRY.ITEM) "

Return cQuery
