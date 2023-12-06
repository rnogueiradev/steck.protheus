#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"

/*/{Protheus.doc} STCOM080
@name STCOM080
@type User Function
@desc ajustes compras
@author Renato Nogueira
@since 17/05/2018
/*/

User Function STCOM080()

	Local cNewEmp 	:= "01"
	Local cNewFil	:= "01"

	RpcSetType( 3 )
	RpcSetEnv( cNewEmp, cNewFil,,,"FAT")

	If !LockByName("STCOM080",.F.,.F.,.T.)
		ConOut("[STCOM080]["+ FWTimeStamp(2) +"] - Já existe uma sessão em processamento.")
		Return()
	EndIf

	ConOut(CRLF + "[STCOM080]["+ FWTimeStamp(2) +"] Inicio do processamento.")

	SM0->(DBGoTop())
	While SM0->(!Eof())
		If SM0->M0_CODIGO$"01#03"
			ConOut(CRLF + "[STCOM080]["+ FWTimeStamp(2) +"] Inicio do processamento da empresa "+SM0->(M0_CODIGO+M0_CODFIL))
			StartJob("U_STCOM081",GetEnvServer(),.T.,SM0->M0_CODIGO,SM0->M0_CODFIL)
			ConOut(CRLF + "[STCOM080]["+ FWTimeStamp(2) +"] Fim do processamento da empresa "+SM0->(M0_CODIGO+M0_CODFIL))
		EndIf
		SM0->(DbSkip())
	EndDo

	ConOut("[STCOM080]["+ FWTimeStamp(2) +"] Fim do processamento")

	UnLockByName("STCOM080",.F.,.F.,.T.)

	Reset Environment

Return

/*/{Protheus.doc} STCOM081
@name STCOM081
@type User Function
@desc processar
@author Renato Nogueira
@since 17/05/2018
/*/

User Function STCOM081(cNewEmp,cNewFil)

	Local _cQuery1 	:= ""
	Default cNewEmp := "01"
	Default cNewFil := "05"

	//Inicia outra Thread com outra empresa e filial
	RpcSetType( 3 )
	RpcSetEnv( cNewEmp, cNewFil,,,"FAT")

	//Atualizar cotações que não gravaram o pedido de compra gerado
	_cQuery1 := " MERGE INTO "+RetSqlName("SC8")+" XC8
	_cQuery1 += " USING (
	_cQuery1 += " SELECT C8.R_E_C_N_O_ RECSC8, MAX(C7_NUM) C7_NUM, MAX(C7_ITEM) C7_ITEM 
	_cQuery1 += " FROM "+RetSqlName("SC8")+" C8
	_cQuery1 += " LEFT JOIN "+RetSqlName("SC7")+" C7
	_cQuery1 += " ON C7_FILIAL=C8_FILIAL AND C7_NUMCOT=C8_NUM AND C7_FORNECE=C8_FORNECE AND C7_LOJA=C8_LOJA
	_cQuery1 += " AND C7_NUMSC=C8_NUMSC AND C7_ITEMSC=C8_ITEMSC AND C7_PRODUTO=C8_PRODUTO
	_cQuery1 += " WHERE C8.D_E_L_E_T_=' ' AND C7.D_E_L_E_T_=' '
	_cQuery1 += " AND C8_FILIAL='"+cFilAnt+"' AND C8_NUMPED=' '
	_cQuery1 += " GROUP BY C8.R_E_C_N_O_
	_cQuery1 += " ) XXX
	_cQuery1 += " ON (XC8.R_E_C_N_O_=XXX.RECSC8)
	_cQuery1 += " WHEN MATCHED THEN UPDATE SET
	_cQuery1 += " XC8.C8_NUMPED=XXX.C7_NUM, XC8.C8_ITEMPED=XXX.C7_ITEM
	_cQuery1 += " WHERE XC8.D_E_L_E_T_=' ' AND XC8.C8_FILIAL='"+cFilAnt+"' AND XC8.C8_NUMPED=' '

	nStatus := TcSqlExec(_cQuery1)
	If (nStatus < 0)
		ConOut(CRLF + "[STCOM080]["+ FWTimeStamp(2) +"] Erro query linha 83: "+TCSQLError())
	EndIf
	
	_cQuery1 := ""

	//Atualizar cotações que geraram pedido de compra e não matou o resíduo
	_cQuery1 := " MERGE INTO "+RetSqlName("SC8")+" XC8
	_cQuery1 += " USING (
	_cQuery1 += " SELECT XC8.R_E_C_N_O_ RECSC8
	_cQuery1 += " FROM "+RetSqlName("SC8")+" C8
	_cQuery1 += " LEFT JOIN "+RetSqlName("SC8")+" XC8
	_cQuery1 += " ON XC8.C8_FILIAL=C8.C8_FILIAL AND XC8.C8_NUM=C8.C8_NUM 
	//_cQuery1 += " AND XC8.C8_ITEM=C8.C8_ITEM 
	_cQuery1 += " AND C8.C8_QUANT=XC8.C8_QUANT
	_cQuery1 += " AND XC8.C8_PRODUTO=C8.C8_PRODUTO
	_cQuery1 += " AND XC8.C8_FORNECE||XC8.C8_LOJA<>C8.C8_FORNECE||C8.C8_LOJA AND XC8.D_E_L_E_T_=' '
	_cQuery1 += " WHERE C8.D_E_L_E_T_=' ' AND C8.C8_FILIAL='"+cFilAnt+"' AND C8.C8_NUMPED<>' ' AND C8.C8_ITEMPED<>' '
	_cQuery1 += " AND SUBSTR(C8.C8_NUMPED,1,1)<>'X' AND XC8.C8_NUMPED=' '
	_cQuery1 += " ) XXX
	_cQuery1 += " ON (XC8.R_E_C_N_O_=XXX.RECSC8)
	_cQuery1 += " WHEN MATCHED THEN UPDATE SET
	_cQuery1 += " XC8.C8_NUMPED='XXXXXX', XC8.C8_ITEMPED='XXXX'
	_cQuery1 += " WHERE XC8.D_E_L_E_T_=' ' AND XC8.C8_FILIAL='"+cFilAnt+"' AND XC8.C8_NUMPED=' '

	nStatus := TcSqlExec(_cQuery1)
	If (nStatus < 0)
		ConOut(CRLF + "[STCOM080]["+ FWTimeStamp(2) +"] Erro query linha 104: "+TCSQLError())
	EndIf
	
	_cQuery1 := ""

	//Pedidos sem descrição
	_cQuery1 := " MERGE INTO "+RetSqlName("SC7")+" SC7
	_cQuery1 += " USING (
	_cQuery1 += " SELECT C7_PRODUTO, C7.R_E_C_N_O_ RECSC7, B1_DESC, B1_UM
	_cQuery1 += " FROM "+RetSqlName("SC7")+" C7
	_cQuery1 += " LEFT JOIN "+RetSqlName("SB1")+" B1
	_cQuery1 += " ON B1_COD=C7_PRODUTO
	_cQuery1 += " WHERE C7.D_E_L_E_T_=' ' AND B1.D_E_L_E_T_=' ' AND C7_DESCRI=' ' ) XXX
	_cQuery1 += " ON (XXX.RECSC7=SC7.R_E_C_N_O_)
	_cQuery1 += " WHEN MATCHED THEN UPDATE SET
	_cQuery1 += " SC7.C7_DESCRI=SUBSTR(XXX.B1_DESC,1,40), SC7.C7_UM=XXX.B1_UM
	_cQuery1 += " WHERE SC7.D_E_L_E_T_=' ' AND C7_DESCRI=' '

	nStatus := TcSqlExec(_cQuery1)
	If (nStatus < 0)
		ConOut(CRLF + "[STCOM080]["+ FWTimeStamp(2) +"] Erro query linha 122: "+TCSQLError())
	EndIf
	
	_cQuery1 := ""

	//Carregar informações de comprador e motivo de compra na cotação
	_cQuery1 := " MERGE INTO "+RetSqlName("SC8")+" SC8
	_cQuery1 += " USING (
	_cQuery1 += " SELECT C8.R_E_C_N_O_ RECSC8, C1.R_E_C_N_O_ RECSC1, C8_XMOT, C8_XCODCOM, C8_XNOMCOM, C1_MOTIVO, C1_CODCOMP, Y1_NOME
	_cQuery1 += " FROM "+RetSqlName("SC8")+" C8
	_cQuery1 += " LEFT JOIN "+RetSqlName("SC1")+" C1
	_cQuery1 += " ON C1_FILIAL=C8_FILIAL AND C1_NUM=C8_NUMSC AND C1_ITEM=C8_ITEMSC
	_cQuery1 += " LEFT JOIN "+RetSqlName("SY1")+" Y1
	_cQuery1 += " ON Y1_COD=C1_CODCOMP
	_cQuery1 += " WHERE C8.D_E_L_E_T_=' ' AND C1.D_E_L_E_T_=' ' AND Y1.D_E_L_E_T_=' ' AND C8_XMOT=' '
	_cQuery1 += " ) XXX
	_cQuery1 += " ON (SC8.R_E_C_N_O_=XXX.RECSC8)
	_cQuery1 += " WHEN MATCHED THEN UPDATE SET
	_cQuery1 += " SC8.C8_XMOT=XXX.C1_MOTIVO, SC8.C8_XCODCOM=XXX.C1_CODCOMP, SC8.C8_XNOMCOM=XXX.Y1_NOME
	_cQuery1 += " WHERE SC8.D_E_L_E_T_=' ' AND C8_XMOT=' '

	nStatus := TcSqlExec(_cQuery1)
	If (nStatus < 0)
		ConOut(CRLF + "[STCOM080]["+ FWTimeStamp(2) +"] Erro query linha 143: "+TCSQLError())
	EndIf
	
	_cQuery1 := ""

	//Atualizar solicitações que não gravaram o pedido de compra gerado
	_cQuery1 := " MERGE INTO "+RetSqlName("SC1")+" C1
	_cQuery1 += " USING (
	_cQuery1 += " SELECT C1.R_E_C_N_O_ RECSC1, C1_FILIAL, C1_NUM, C1_ITEM, C1_QUJE, NVL(SUM(C7_QUANT),0) QTDPED
	_cQuery1 += " FROM "+RetSqlName("SC1")+" C1 
	_cQuery1 += " LEFT JOIN "+RetSqlName("SC7")+" C7
	_cQuery1 += " ON C1_FILIAL=C7_FILIAL AND C1_NUM=C7_NUMSC AND C1_ITEM=C7_ITEMSC AND C7.D_E_L_E_T_=' ' 
	_cQuery1 += " WHERE C1.D_E_L_E_T_=' ' AND C1_OBS <> 'XXX'
	_cQuery1 += " GROUP BY C1.R_E_C_N_O_,C1_FILIAL, C1_NUM, C1_ITEM, C1_QUJE
	_cQuery1 += " HAVING NVL(SUM(C7_QUANT),0)<>C1_QUJE
	_cQuery1 += " ORDER BY C1_FILIAL, C1_NUM, C1_ITEM
	_cQuery1 += " ) XXX
	_cQuery1 += " ON (XXX.RECSC1=C1.R_E_C_N_O_)
	_cQuery1 += " WHEN MATCHED THEN UPDATE SET
	_cQuery1 += " C1.C1_QUJE=XXX.QTDPED

	nStatus := TcSqlExec(_cQuery1)
	If (nStatus < 0)
		ConOut(CRLF + "[STCOM080]["+ FWTimeStamp(2) +"] Erro query linha 164: "+TCSQLError())
	EndIf
	
	_cQuery1 := ""

	//Atualizar quantidade entregue do pedido de compra
	_cQuery1 += " MERGE INTO "+RetSqlName("SC7")+" C7
	_cQuery1 += " USING (
	_cQuery1 += " SELECT *
	_cQuery1 += " FROM (
	_cQuery1 += " SELECT RECSC7, C7_FILIAL, C7_NUM, C7_ITEM, C7_QUJE, C7_QUANT, (CASE WHEN QTDENTD1+QTDENTZS>C7_QUJE THEN C7_QUANT ELSE QTDENTD1+QTDENTZS END) TOTALENT
	_cQuery1 += " FROM (
	_cQuery1 += " SELECT C7.R_E_C_N_O_ RECSC7, C7_FILIAL, C7_NUM, C7_ITEM, C7_QUJE, C7_QUANT, D1_QUANT QTDENTD1, NVL(SUM(ZZS_QTDSUB),0) QTDENTZS
	_cQuery1 += " FROM "+RetSqlName("SC7")+" C7
	_cQuery1 += " LEFT JOIN (
	_cQuery1 += " SELECT D1_FILIAL, D1_PEDIDO, D1_ITEMPC, SUM(D1_QUANT) D1_QUANT
	_cQuery1 += " FROM "+RetSqlName("SD1")+" D1
	_cQuery1 += " WHERE D1.D_E_L_E_T_=' ' AND D1_TES<>' ' 
	_cQuery1 += " GROUP BY D1_FILIAL, D1_PEDIDO, D1_ITEMPC
	_cQuery1 += " ) D1
	_cQuery1 += " ON D1_FILIAL=C7_FILIAL AND D1_PEDIDO=C7_NUM AND D1_ITEMPC=C7_ITEM
	_cQuery1 += " LEFT JOIN "+RetSqlName("ZZS")+" ZZS
	_cQuery1 += " ON ZZS_FILIAL=C7_FILIAL AND ZZS_PEDCOM=C7_NUM AND ZZS_ITEMPC=C7_ITEM AND ZZS.D_E_L_E_T_=' ' 
	_cQuery1 += " WHERE C7.D_E_L_E_T_=' '
	_cQuery1 += " GROUP BY C7.R_E_C_N_O_,C7_FILIAL, C7_NUM, C7_ITEM, C7_QUJE, C7_QUANT, D1_QUANT
	_cQuery1 += " ORDER BY C7_FILIAL, C7_NUM, C7_ITEM
	_cQuery1 += " ) ZZZ
	_cQuery1 += " ) WWW
	_cQuery1 += " WHERE C7_QUJE<>TOTALENT
	_cQuery1 += " ) XXX
	_cQuery1 += " ON (XXX.RECSC7=C7.R_E_C_N_O_)
	_cQuery1 += " WHEN MATCHED THEN UPDATE SET
	_cQuery1 += " C7.C7_QUJE=XXX.TOTALENT

	nStatus := TcSqlExec(_cQuery1)
	If (nStatus < 0)
		ConOut(CRLF + "[STCOM080]["+ FWTimeStamp(2) +"] Erro query linha 196: "+TCSQLError())
	EndIf
	
	_cQuery1 := ""

	//Atualizar entradas previstas
	If cEmpAnt=="01" //Somente SP
	
		_cQuery1 := " MERGE INTO "+RetSqlName("SB2")+" B2
		_cQuery1 += " USING (
		_cQuery1 += " SELECT PRODUTO, TOTAL, B2_SALPEDI, B2.R_E_C_N_O_ RECSB2
		_cQuery1 += " FROM (
		_cQuery1 += " SELECT PRODUTO, SUM(TOTAL) TOTAL
		_cQuery1 += " FROM (
		_cQuery1 += " SELECT PRODUTO, (CASE WHEN SALDOC1+SALDOC7+SALDOC2<0 THEN 0 ELSE SALDOC1+SALDOC7+SALDOC2 END) TOTAL
		_cQuery1 += " FROM (
		_cQuery1 += " SELECT C1_PRODUTO PRODUTO, SUM(C1_QUANT-C1_QUJE) SALDOC1, 0 SALDOC7, 0 SALDOC2
		_cQuery1 += " FROM "+RetSqlName("SC1")+" C1
		_cQuery1 += " WHERE C1.D_E_L_E_T_=' ' AND C1_FILIAL='05' AND C1_ZSTATUS<>'5' AND C1_RESIDUO=' ' AND C1_QUANT-C1_QUJE>=0
		_cQuery1 += " GROUP BY C1_PRODUTO
		_cQuery1 += " UNION
		_cQuery1 += " SELECT C7_PRODUTO PRODUTO, 0 SALDOC1 , SUM(C7_QUANT-C7_QUJE) SALDOC7, 0 SALDOC2
		_cQuery1 += " FROM "+RetSqlName("SC7")+" C7
		_cQuery1 += " WHERE C7.D_E_L_E_T_=' ' AND C7_FILIAL='05' AND C7_RESIDUO=' ' AND C7_QUANT-C7_QUJE>=0
		_cQuery1 += " GROUP BY C7_PRODUTO
		_cQuery1 += " UNION 
		_cQuery1 += " SELECT C2_PRODUTO, 0 SALDOC1 , 0 SALDOC7, SUM(C2_QUANT-C2_QUJE) SALDOC2
		_cQuery1 += " FROM "+RetSqlName("SC2")+" C2
		_cQuery1 += " WHERE C2.D_E_L_E_T_=' ' AND C2_FILIAL='05' AND C2_QUANT-C2_QUJE>=0
		_cQuery1 += " GROUP BY C2_PRODUTO
		_cQuery1 += " ) XXX
		_cQuery1 += " ) YYY
		_cQuery1 += " GROUP BY PRODUTO
		_cQuery1 += " ) ZZZ
		_cQuery1 += " LEFT JOIN "+RetSqlName("SB1")+" B1
		_cQuery1 += " ON B1_COD=PRODUTO 
		_cQuery1 += " LEFT JOIN "+RetSqlName("SB2")+" B2
		_cQuery1 += " ON B2_FILIAL='05' AND B2_COD=PRODUTO AND B2_LOCAL=B1_LOCPAD
		_cQuery1 += " WHERE B1.D_E_L_E_T_=' ' AND B2.D_E_L_E_T_=' ' AND B2_SALPEDI<>TOTAL
		_cQuery1 += " ORDER BY PRODUTO
		_cQuery1 += " ) WWW
		_cQuery1 += " ON (B2.R_E_C_N_O_=WWW.RECSB2)
		_cQuery1 += " WHEN MATCHED THEN UPDATE SET
		_cQuery1 += " B2_SALPEDI=TOTAL

		nStatus := TcSqlExec(_cQuery1)
		If (nStatus < 0)
			ConOut(CRLF + "[STCOM080]["+ FWTimeStamp(2) +"] Erro query linha 236: "+TCSQLError())
		EndIf
		
		_cQuery1 := ""

	EndIf

	Reset Environment

Return
