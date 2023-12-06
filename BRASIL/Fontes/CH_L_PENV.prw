#Include "Totvs.ch"

/*/{Protheus.doc} CH_L_PENV
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
    
User Function CH_L_PENV(nParamDias,cCodigoErp)

Local cQuery := ""
//valores default
Default cCodigoErp := ""

cQuery += " SELECT  SC6.C6_NOTA     DOCUMENTO_NUMERO,"
cQuery += "         SC6.C6_SERIE    DOCUMENTO_SERIE," 
cQuery += "         SC5.C5_XRASTPV  RASTREAMENTO,"
cQuery += "         ISNULL(SA4.A4_CGC,'')   TRANSPORTADORA_CNPJ,"
cQuery += "         ISNULL(SA4.A4_NOME,'')  TRANSPORTADORA_NOME,"
cQuery += "         SUBSTRING(SF2.F2_EMISSAO,1,4)+'-'+SUBSTRING(SF2.F2_EMISSAO,5,2)+'-'+SUBSTRING(SF2.F2_EMISSAO,7,2)+'T00:00:00.000-03:00'  DATAENVIO,"
cQuery += "         row_number() over (order by SC6.C6_FILIAL, SC6.C6_NOTA, SC6.C6_SERIE) linha_tabela"

cQuery += " FROM "+RetSqlName("SC6")+" SC6"

cQuery += "     INNER JOIN "+RetSqlName("SC5")+" SC5 ON SC5.C5_FILIAL   = SC6.C6_FILIAL"
cQuery += "                                         AND SC5.C5_NUM      = SC6.C6_NUM"
cQuery += "                                         AND SC5.D_E_L_E_T_  = ''"

cQuery += "     INNER JOIN "+RetSqlName("SF2")+" SF2 ON SF2.F2_FILIAL   = SC6.C6_FILIAL"
cQuery += "                                         AND SF2.F2_DOC      = SC6.C6_NOTA"
cQuery += "                                         AND SF2.F2_SERIE    = SC6.C6_SERIE"
cQuery += "                                         AND SF2.D_E_L_E_T_  = ''"

cQuery += "     LEFT JOIN "+RetSqlName("SA4")+" SA4 ON  SA4.A4_FILIAL   = ''"
cQuery += "                                         AND SA4.A4_COD      = SF2.F2_TRANSP"
cQuery += "                                         AND SA4.D_E_L_E_T_  = ''"

cQuery += " WHERE   SC6.D_E_L_E_T_  = ''"
cQuery += "     AND SC5.C5_EMISSAO >= '"+dtos(DaySub(dDatabase,nParamDias))+"'"
//verifica se existe filtro de codigo do pedido
if (!Empty(cCodigoErp))
    cQuery += " AND SC6.C6_NUM = '"+AllTrim(cCodigoErp)+"'"
endif

cQuery += " GROUP BY    SC6.C6_FILIAL,"
cQuery += "             SC6.C6_NOTA," 
cQuery += "             SC6.C6_SERIE," 
cQuery += "             SC5.C5_XRASTPV," 
cQuery += "             SF2.F2_EMISSAO,"
cQuery += "             ISNULL(SA4.A4_CGC,''),"
cQuery += "             ISNULL(SA4.A4_NOME,'')"

Return cQuery
