/*/{@Protheus.doc} JobAjuC6
description
Rotina que fará o ajuste de campos de impostos
@type function
@version
@author Valdemir Rabelo
@since 21/01/2022
@return variant, return_description
/*/
#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

User Function JobAjuC6()
	Local cQry := ""

	RpcSetType(3)
	RpcSetEnv("11", "01",,'FAT')

	dbSelectArea("SC5")
	dbSetOrder(1)
	dbSelectArea("SC6")
	dbSetOrder(1)

	cQry := "SELECT R_E_C_N_O_ REG " + CRLF
	cQry += "FROM " + RetSqlName("SC6") + " C6 "  + CRLF
	cQry += "WHERE c6.D_E_L_E_T_ = ' ' " + CRLF
	cQry += " AND (C6.C6_ZVALLIQ = 0 OR C6_ZVALLIQ>C6_VALOR) " + CRLF
	cQry += " AND C6_VALOR>0 AND C6_OPER='01' " + CRLF

	if Select("tAju") > 0
		tAju->( dbCloseArea() )
	endif
	tcQuery cQry New alias "tAju"

	While tAju->(! Eof() )
		SC6->( dbGoto(tAju->REG) )
		if !LockByName("JobAjuC6", .T., .F.)
		   Conout("<JobAjuC6> Registro não consegue ser travado pelo semafaro Pedido: "+SC6->C6_NUM+" ITEM: "+SC6->C6_ITEM)
		   tAju->( dbSkip() )
		   Loop
		endif 

		SC5->( dbSeek(xFilial('SC5')+SC6->C6_NUM) )
		MaFisSave()
		MaFisEnd()
		MaFisIni(Iif(Empty(SC5->C5_CLIENT),SC5->C5_CLIENTE,SC5->C5_CLIENT),;	// 1-Codigo Cliente/Fornecedor
		SC5->C5_LOJAENT,; 														// 2-Loja do Cliente/Fornecedor
		IIf(SC5->C5_TIPO$ 'DB' ,"F","C"),; 										// 3-C:Cliente , F:Fornecedor
		SC5->C5_TIPO,; 															// 4-Tipo da NF
		SC5->C5_TIPOCLI,; 														// 5-Tipo do Cliente/Fornecedor
		Nil,;
			Nil,;
			Nil,;
			Nil,;
			"MATA461")

		MaFisAdd(SC6->C6_PRODUTO,;                                                     // 1-Codigo do Produto ( Obrigatorio )
		SC6->C6_TES,;                                                                  // 2-Codigo do TES ( Opcional )
		SC6->C6_QTDENT,;                                                               // 3-Quantidade ( Obrigatorio )
		SC6->C6_PRCVEN,;                                                               // 4-Preco Unitario ( Obrigatorio )
		0,;                                                                            // 5-Valor do Desconto ( Opcional )
		,;                                                                             // 6-Numero da NF Original ( Devolucao/Benef )
		,;                                                                             // 7-Serie da NF Original ( Devolucao/Benef )
		,;                                                                             // 8-RecNo da NF Original no arq SD1/SD2
		0,;                                                                            // 9-Valor do Frete do Item ( Opcional )
		0,;                                                                            // 10-Valor da Despesa do item ( Opcional )
		0,;                                                                            // 11-Valor do Seguro do item ( Opcional )
		0,;                                                                            // 12-Valor do Frete Autonomo ( Opcional )
		SC6->C6_VALOR,;														           // 13-Valor da Mercadoria ( Obrigatorio )
		0,;                                                                            // 14-Valor da Embalagem ( Opiconal )
		0,;                                                                            // 15-RecNo do SB1
		0)                                                                             // 16-RecNo do SF4

		nValICms := noround(MaFisRet(1,'IT_VALICM',14,2) )
		nValPis  := noround(MaFisRet(1,"IT_VALPS2",14,2) )
		nValCof  := noround(MaFisRet(1,"IT_VALCF2",14,2) )
		nValCmp  := noround(MaFisRet(1,"IT_VALCMP",14,2) )
		nValDif  := noround(MaFisRet(1,"IT_DIFAL" ,14,2) )
		nValLIQ  := round(SC6->C6_VALOR - (nValICMS) - (nValPis) - (nValCof) - (nValCmp) - (nValDif),2)

		RecLock('SC6',.F.)
		SC6->C6_ZVALLIQ := nValLIQ
		MsUnlock()
		
		//Desabilitando o semáforo
		UnlockByName("JobAjuC6", .T., .F., .F.)
		tAju->( dbSkip() )
	EndDo

	RpcClearEnv()

Return
