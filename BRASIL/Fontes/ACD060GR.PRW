#Include "Protheus.ch"
#Include "rwmake.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ACD060GR	ºAutor  ³Renato Nogueira     º Data ³  29/07/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Programa para disparar mensagem após o endereçamento		    º±±
±±º          ³							  		  	 				           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametro ³ Nil	                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºRetorno   ³ Nil		  										              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function ACD060GR()

Local _aArea     := GetArea()
Local _cQuery 	:= ""
Local _cAlias 	:= "QRYTEMP"
	
	If cEmpAnt=="03" .And. AllTrim(SDB->DB_LOCAL)==AllTrim(GetMv("ST_LOCESC")) //Chamado 002266
	
	_cQuery  := "  SELECT B1_COD,  NVL(SUM(C6_QTDVEN-C6_QTDENT),0)- "
	_cQuery  += " (SELECT NVL(SUM(ZZU_QTDE),0) "
	_cQuery  += " FROM "+RetSqlName("ZZU")+" ZU "
	_cQuery  += " LEFT JOIN ZZT030 ZT  ON ZT.ZZT_FILIAL=ZU.ZZU_FILIAL AND ZT.ZZT_NUMEMB=ZU.ZZU_NUMEMB AND ZZU_VIRTUA <> 'N'  " //Chamado 007618
	_cQuery  += " WHERE ZU.D_E_L_E_T_=' ' AND ZT.D_E_L_E_T_=' ' "
	_cQuery  += " AND ZZT_STATUS IN ('1','2') AND ZZU_PRODUT='"+SB1->B1_COD+"')  AS SALDO "
	_cQuery  += " FROM "+RetSqlName("SB1")+" B1 "
	_cQuery  += " LEFT JOIN "+RetSqlName("SC6")+" C6 "
	_cQuery  += " ON C6.C6_PRODUTO=B1.B1_COD AND C6.D_E_L_E_T_=' '  AND C6_BLQ=' ' AND C6_OPER='"+AllTrim(GetMv("ST_LOCESC"))+"' "
	_cQuery  += " LEFT JOIN "+RetSqlName("SC5")+" C5 "
	_cQuery  += " ON C5.C5_FILIAL=C6.C6_FILIAL AND C5.C5_NUM=C6.C6_NUM   AND C5.C5_CLIENTE=C6.C6_CLI "
	_cQuery  += " AND C5.C5_LOJACLI=C6.C6_LOJA AND C5.D_E_L_E_T_=' ' "
	_cQuery  += " AND C5_EMISSAO>='20141215'  WHERE B1.D_E_L_E_T_=' ' AND B1_COD='"+SB1->B1_COD+"' "
	_cQuery  += " GROUP BY B1_COD "
	
	If !Empty(Select(_cAlias))
		DbSelectArea(_cAlias)
		(_cAlias)->(dbCloseArea())
	Endif
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cAlias,.T.,.T.)
	
	dbSelectArea(_cAlias)
	(_cAlias)->(dbGoTop())
	
	If (_cAlias)->(!Eof())
	VTALERT("PRODUTO: "+AllTrim(SB1->B1_COD)+" QTDE ABERTA EM PEDIDO: "+CVALTOCHAR((_cAlias)->SALDO);
	+" | QTDE ENDERECADA: "+CVALTOCHAR(SDB->DB_QUANT))
	EndIf
	
	EndIf

RestArea(_aArea)

Return() 