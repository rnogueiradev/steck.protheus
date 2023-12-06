#Include "Totvs.ch"

/*/{Protheus.doc} CH_L_PRDEMP
@author Ihorran Milholi
@since 17/05/2021
@version 1.0
/*/

/*
CAMPOS PARA RETORNO DA QUERY
CODIGO
NOME
*/
    
User Function CH_L_PRDEMP(nParamDias)

Local cQuery := ""

cQuery += " SELECT"   
cQuery += " 	SB1.B1_COD  PRODUTO,"
cQuery += " 	'11'||SB2.B2_FILIAL    EMPRESA_SIGLA,"
cQuery += " 	NNR.NNR_CODIGO  LOCAL,"
cQuery += "		(SB2.B2_QATU - SB2.B2_RESERVA) ESTOQUEATUAL,"

//cQuery += " 		(SELECT SUM(SALDO)	
//cQuery += " 		FROM (
//cQuery += " 			SELECT 
//cQuery += " 				TRUNC(MIN(SUM((B2_QATU-B2_RESERVA)/G1_QUANT)),0) SALDO  
//cQuery += " 			FROM 
//cQuery += " 				SG1010 SG1 
//cQuery += " 				INNER JOIN SB2010 SB2KIT ON SB2KIT.D_E_L_E_T_ <> '*' AND SB2KIT.B2_FILIAL IN ('03','06') AND SG1.G1_COMP = SB2KIT.B2_COD AND SB2KIT.B2_LOCAL = '01' 
//cQuery += " 			WHERE 
//cQuery += " 				SG1.D_E_L_E_T_ <> '*'
//cQuery += " 				AND SG1.G1_FILIAL IN ('06') 
//cQuery += " 				AND SG1.G1_COD = SB1.B1_COD
//cQuery += " 			GROUP BY SG1.G1_COMP
//cQuery += " 			UNION ALL
//cQuery += " 			SELECT 
//cQuery += " 				SUM(B2_QATU-B2_RESERVA) SALDO
//cQuery += " 			FROM 
//cQuery += " 				SB2010 SB2KIT 
//cQuery += " 			WHERE 
//cQuery += " 				SB2KIT.D_E_L_E_T_ <> '*' 
//cQuery += " 				AND SB2KIT.B2_FILIAL IN ('03','06') 
//cQuery += " 				AND SB2KIT.B2_COD = SB1.B1_COD
//cQuery += " 				AND SB2KIT.B2_LOCAL = '01') QRY) ESTOQUEATUAL,"
cQuery += "		DA1.DA1_PRCVEN CUSTO,"
cQuery += "		DA1.DA1_PRCVEN PRECO,"
cQuery += "		row_number() over (order by SB1.B1_FILIAL, SB1.B1_COD, NNR.NNR_CODIGO) linha_tabela"

cQuery += " FROM "+RetSqlName("SB1")+" SB1"

cQuery += "		INNER JOIN "+RetSqlName("NNR")+" NNR ON NNR.NNR_FILIAL  = '"+xFilial("NNR")+"' AND NNR.NNR_CODIGO  = '03' AND NNR.D_E_L_E_T_  <> '*'"
cQuery += "		LEFT JOIN "+RetSqlName("SB2")+" SB2 ON SB2.D_E_L_E_T_  <> '*' AND SB2.B2_FILIAL IN ('01') AND SB2.B2_COD = SB1.B1_COD AND SB2.B2_LOCAL = '03'
cQuery += "     INNER JOIN "+RetSqlName("DA1")+" DA1 ON DA1.DA1_FILIAL = '"+xFilial("DA1")+"' AND DA1.D_E_L_E_T_ <> '*' AND SB1.B1_COD = DA1.DA1_CODPRO AND DA1.DA1_CODTAB = '001'"

cQuery += " WHERE"
cQuery += "     SB1.D_E_L_E_T_  <> '*'"
cQuery += "     AND B1_FILIAL = '"+xFilial("SB1")+"'"  
//cQuery += "     AND B1_YSITE IN ('S','V') 
cQuery += "     AND B1_MSBLQL <> '1'"
//cQuery += "     AND B1_COD = 'S77256'
cQuery += "     AND DA1_PRCVEN > 0 AND B1_TIPO = 'PA' AND B1_XDESAT <> '2'

Return cQuery
