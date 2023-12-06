#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWMVCDEF.CH"

/*====================================================================================\
|Programa  | STFAT490        | Autor | RENATO.OLIVEIRA           | Data | 15/09/2020  |
|=====================================================================================|
|Descrição |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STFAT490()

	Local _cQuery1 := ""
	Local _cAlias1 := ""

	RpcSetType( 3 )
	RpcSetEnv("01","02",,,"FAT")

	If !LockByName("STFAT490",.F.,.F.,.T.)
		ConOut("[STFAT490]["+ FWTimeStamp(2) +"] - Já existe uma sessão em processamento.")
		Return()
	EndIf

	ConOut(CRLF + "[STFAT490]["+ FWTimeStamp(2) +"] Inicio do processamento.")

	_cAlias1 := GetNextAlias()

	DbSelectArea("SC6")
	SC6->(DbSetOrder(1))

	DbSelectArea("SUB")
	SUB->(DbSetOrder(1))

	_cQuery1 := " SELECT C5_FILIAL, C5_NUM, C5_EMISSAO, UB_ITEM, C6_ITEM, C6_ZNCM, UB_ZNCM, C6.R_E_C_N_O_ RECSC6, UB.R_E_C_N_O_ RECSUB
	_cQuery1 += " FROM "+RetSqlName("SUA")+" UA
	_cQuery1 += " LEFT JOIN "+RetSqlName("SUB")+" UB
	_cQuery1 += " ON UB_FILIAL=UA_FILIAL AND UB_NUM=UA_NUM
	_cQuery1 += " LEFT JOIN "+RetSqlName("SC5")+" C5
	_cQuery1 += " ON C5_FILIAL=UA_FILIAL AND UA_NUMSC5=C5_NUM
	_cQuery1 += " LEFT JOIN "+RetSqlName("SC6")+" C6
	_cQuery1 += " ON C6_FILIAL=UA_FILIAL AND C6_NUM=UA_NUMSC5 AND C6_ITEM=UB_ITEMPV
	_cQuery1 += " WHERE C5.D_E_L_E_T_=' ' AND UA.D_E_L_E_T_=' ' AND C6.D_E_L_E_T_=' ' AND UB.D_E_L_E_T_=' ' 
	_cQuery1 += " AND UA_FILIAL='"+cFilAnt+"' AND C6_OPER=' ' AND UB_OPER<>' ' 

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	While (_cAlias1)->(!Eof())

		SC6->(DbGoTo((_cAlias1)->RECSC6))
		SUB->(DbGoTo((_cAlias1)->RECSUB))
	
		If SC6->(!Eof()) .And. SUB->(!Eof())

			SC6->(RecLock("SC6",.F.))
			SC6->C6_ZVALICM	:= SUB->UB_ZVALICM			// Valor do ICMS
			SC6->C6_ZVALIPI	:= SUB->UB_ZVALIPI			// Valor do IPI
			SC6->C6_ZVALIST	:= SUB->UB_ZVALIST			// Valor do ICMS ST
			SC6->C6_ZPICMS	:= SUB->UB_ZPICMS			// Aliq. ICMS
			SC6->C6_ZVALLIQ	:= SUB->UB_ZVALLIQ			// Valor do Liquido
			SC6->C6_COMIS1  := SUB->UB_XCOMIS1			//SUB->UB_XCOMIS1  //PORCENTAGEM DE COMISSAO VEND1
			SC6->C6_XVALCOM := SUB->UB_XVCOMS1			//SUB->UB_XVCOMS1  //VALOR COMISSAO VEND1
			SC6->C6_COMIS2  := SUB->UB_XCOMIS2			//SUB->UB_XCOMIS2  //PORCENTAGEM DE COMISSAO VEND1
			SC6->C6_XORDEM  := SUB->UB_XORDEM			//SUB->UB_XORDEM   //ORDEM DE COMPRA DO CLIENTE
			SC6->C6_XPORDEC := SUB->UB_XPORDEC			//SUB->UB_XPORDEC  //PORCENTAGEM DE DESCONTO ADICIONAL
			SC6->C6_XVALDES := SUB->UB_XVALDES			//SUB->UB_XVALDES	//VALOR DE DESCONTO ADICIONAL
			SC6->C6_XACREPO := SUB->UB_XACREPO			//SUB->UB_XACREPO	//PORCENTAGEM DE ACRESCIMO ADICIONAL
			SC6->C6_XACREVA := SUB->UB_XACREVA			//SUB->UB_XACREVA  //VALOR DE ACRESCIMO ADICIONAL
			SC6->C6_XVALACR := SUB->UB_XVALACR			//SUB->UB_XVALACR	//VALOR DE ACRESCIMO CONDIÇÃO DE PAGAMENTO
			SC6->C6_XPORACR := SUB->UB_XACRECP			//SUB->UB_XACRECP	//PORCENTAGEM DE ACRESCIMO CONDIÇÃO DE PAGAMENTO
			SC6->C6_XPRCLIS := SUB->UB_PRCTAB			//SUB->UB_PRCTAB   //GRAVA PREÇO DE LISTA CUSTOMIZADO
			SC6->C6_PRUNIT  := SUB->UB_VRUNIT			//SUB->UB_VRUNIT  //GRAVA PREÇO DE LISTA COM O PREÇO DE VENDA( NAO GERAR DESCONTO )
			//SC6->C6_DESCONT := 0
			//SC6->C6_VALDESC := 0
			SC6->C6_OPER    := SUB->UB_OPER			//SUB->UB_OPER
			SC6->C6_XTABPRC := SUB->UB_XTABPRC
			SC6->C6_XCUSTO  := SUB->UB_XCUSTO
			SC6->C6_XCAMPA  := SUB->UB_XCAMPA //22/12/14 GIOVANI ZAGO
			SC6->C6_ZNCM    := SUB->UB_ZNCM			//SUB->UB_ZNCM
			SC6->C6_ZIPI   	:= SUB->UB_ZIPI			//SUB->UB_ZIPI
			SC6->C6_ZB2QATU	:= SUB->UB_ZB2QATU			//SUB->UB_ZB2QATU
			SC6->C6_ZMARKUP	:= SUB->UB_ZMARKUP			//SUB->UB_ZMARKUP
			SC6->C6_ZMOTBLO	:= SUB->UB_XBLQITE			//SUB->UB_XBLQITE
			SC6->C6_XPRCCON := SUB->UB_XPRCCON			//SUB->UB_XPRCCON
			SC6->C6_QTDLIB  := SUB->UB_QUANT			//SUB->UB_QUANT
			SC6->C6_QTDEMP  := SUB->UB_QUANT			//SUB->UB_QUANT
			SC6->C6_UM  	:= SUB->UB_UM			//SUB->UB_UM
			SC6->C6_ZPRCTAB := SUB->UB_ZPRCTAB			//SUB->UB_ZPRCTAB
			SC6->C6_XULTPRC := SUB->UB_XULTPRC			//SUB->UB_XULTPRC
			SC6->C6_ZLULT   := SUB->UB_ZLULT			//SUB->UB_ZLULT
			SC6->C6_ZRESERV := Posicione("PA2",4,xFilial("PA2")+xFilial("SC6")+SC6->C6_NUM+SC6->C6_ITEM,"PA2_QUANT")
			SC6->C6_ITEMPC  := SUB->UB_XITEMPC          // Item do pedido cliente     inserido Jefferson
			SC6->C6_NUMPCOM := SUB->UB_XNUMPCO          // Numero do pedido cliente   inserido Jefferson
			SC6->C6_ENTRE1  := SUB->UB_DTENTRE// DATA DE ENTRGA
			SC6->C6_FCICOD	:= U_STGETFCI(SUB->UB_PRODUTO) //Renato - Adicionar FCI no pedido
			SC6->C6_ZPRCPSC := SUB->UB_ZPRCPSC
			SC6->(Msunlock("SC6"))
	
		EndIf
	
		(_cAlias1)->(DbSkip())
	EndDo

	UnLockByName("STFAT490",.F.,.F.,.T.)
	
	ConOut("[STFAT490]["+ FWTimeStamp(2) +"] Fim do processamento")

	Reset Environment

Return()
