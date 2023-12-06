#Include "Totvs.ch"

/*/{Protheus.doc} CH_L_PPAI
@author Ihorran Milholi
@since 17/05/2021
@version 1.0
/*/

/*
*/
    
User Function CH_L_PPAI(nParamDias)

Local cQuery := ""



cQuery += " SELECT "
cQuery += "     Z06.Z06_CODIGO||'-PAI'              CODIGO," 
cQuery += "     Z06.Z06_CODIGO||'-PAI'              CODIGOERP," 
cQuery += "     SUBSTR(SB1.B1_DESC,1,15)            NOME,"
cQuery += "     SB1.B1_YMARCA                       MARCA,"
//cQuery += "     Z11_MODELO                  MODELO,"
//cQuery += "     SB1.B1_POSIPI               NCM,"
//cQuery += "     SB1.B1_CODBAR               CODIGOUNIVERSAL,"
cQuery += "     SB1.B1_ORIGEM               ORIGEM,"
//cQuery += "     SB5.B5_PESO                 PESO,
//cQuery += "     SB5.B5_ECLARGU*100          LARGURA,
//cQuery += "     SB5.B5_ECCOMP*100           PROFUNDIDADE,
//cQuery += "     SB5.B5_ECPROFU*100          ALTURA,
//cQuery += "     ISNULL(CONVERT(VARCHAR(8000),CONVERT(VARBINARY(8000),[SB5].[B5_ECAPRES])),'') DESCRICAO,
cQuery += "     ACU.ACU_COD  CATEGORIA,
cQuery += "     3             GARANTIA,
cQuery += "     'MESES CONTRA DEFEITO DE FABRICACAO' TEXTOGARANTIA,
cQuery += "     'virtual' TIPO,"
cQuery += "     CASE WHEN SB1.B1_MSBLQL = '1' THEN 'inativo' ELSE 'ativo' END STATUS,"
cQuery += "     999999.99 PRECO,"
cQuery += "     row_number() over (order by Z06.Z06_FILIAL, Z06.Z06_CODIGO) linha_tabela"

cQuery += " FROM "+RetSqlName("Z06")+" Z06"
cQuery += " INNER JOIN "+ RetSqlName("SB1")+" SB1 ON B1_FILIAL = '"+XFILIAL("SB1")+ "' AND SB1.D_E_L_E_T_ <> '*' AND Z06.Z06_PRODUT = B1_COD AND B1_MSBLQL <> '1' AND B1_YMARCA <> ' '"
cQuery += " LEFT JOIN "+ RetSqlName("ACV")+" ACV ON ACV_FILIAL = '"+XFILIAL("ACV")+ "' AND ACV.D_E_L_E_T_ <> '*' AND ACV.ACV_CODPRO = Z06.Z06_PRODUT"
cQuery += " LEFT JOIN "+ RetSqlName("ACU")+" ACU ON ACU_FILIAL = '"+XFILIAL("ACU")+ "' AND ACU.D_E_L_E_T_ <> '*' AND ACU.ACU_COD = ACV.ACV_CATEGO AND ACU.ACU_MSBLQL <> '1' "
//cQuery += " LEFT JOIN "+ RetSqlName("Z11")+" Z11 ON Z11_FILIAL = '"+XFILIAL("Z11")+ "' AND Z11.D_E_L_E_T_ <> '*' AND Z11_CODIGO = B1_YMODELO "	
//cQuery += "     INNER JOIN "+RetSqlName("DA1")+" DA1 ON DA1.DA1_FILIAL = '"+xFilial("DA1")+"' AND DA1.D_E_L_E_T_ <> '*' AND SB1.B1_COD = DA1.DA1_CODPRO AND DA1.DA1_CODTAB = '017'"
//cQuery += " LEFT JOIN "+ RetSqlName("SB5")+" SB5 ON B5_FILIAL = '"+XFILIAL("SB5")+ "' AND SB5.D_E_L_E_T_ <> '*' AND B5_COD = Z06.Z06_PRODUT "

cQuery += " WHERE"
cQuery += "     Z06.D_E_L_E_T_ <> '*'"
cQuery += "     AND Z06.Z06_FILIAL   = '"+xFilial("Z06")+"'"
cQuery += "     AND Z06_CODVAR <> ' ' "
cQuery += "     AND B1_YSITE IN ('S','V') AND B1_MSBLQL <> '1'
//cQuery += "     AND B1_COD = '067455'
cQuery += " GROUP BY " 
cQuery += "     Z06.Z06_FILIAL, Z06.Z06_CODIGO,"
cQuery += "     SUBSTR(SB1.B1_DESC,1,15), SB1.B1_MSBLQL, SB1.B1_YMARCA, SB1.B1_ORIGEM, "
cQuery += "     ACU.ACU_COD "

Return cQuery
