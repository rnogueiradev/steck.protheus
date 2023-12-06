#include 'Protheus.ch'
#include 'RwMake.ch'

/*====================================================================================\
|Programa  | STGAP09A         | Autor | GIOVANI.ZAGO             | Data | 14/02/2013  |
|=====================================================================================|
|Descrição |  Gap 09                                                                  |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STGAP09A                                                                 |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
User Function STGAP09A()
*-----------------------------*
	Local aArea         := GetArea()

  
	SC5->C5_XORDEM    := SUA->UA_XORDEM  //ORDEM DE COMPRA
	SC5->C5_TIPOCLI   := SUA->UA_XTIPO   //TIPO DE CLIENTE (SOLIDARIO,CONS.FINAL,....))
	SC5->C5_VEND1     := SUA->UA_VEND    //VENDEDOR 1
	SC5->C5_VEND2     := SUA->UA_VEND2   //VENDEDOR 2
	SC5->C5_XHISVEN   := SUA->UA_XHISVEN //HISTORICO
	SC5->C5_CONDPAG   := SUA->UA_XCONDPG //COND. PAG.
	SC5->C5_ZCONDPG   := SUA->UA_XCONDPG //COND. PAG.
	SC5->C5_TRANSP    := SUA->UA_TRANSP  //TRANP
	SC5->C5_ZCONSUM   := SUA->UA_ZCONSUM //CONSUMO
	SC5->C5_LIBEROK   := 'S'//SUA->UA_ZCONSUM //CONSUMO
	SC5->C5_TIPLIB    := '1'
	SC5->C5_TPCARGA   := '2'

	DbSelectArea('SC6')
	SC6->( DbSetOrder(1) )
	If SC6->( DbSeek(xFilial('SC6') + SC5->C5_NUM) )
	
		Do While SC6->(!EOF()) .And. SC6->C6_FILIAL == xFilial('SC6') .And. SC6->C6_NUM == SC5->C5_NUM
		
			DbSelectArea('SUB')
			SUB->( DbSetOrder(1) )
			If SUB->( DbSeek(xFilial('SUB')+SC5->C5_ZORCAME+SC6->C6_ITEM+SC6->C6_PRODUTO) )
			
			
				SC6->( RecLock('SC6',.F.) )
			 
				SC6->C6_COMIS1  := SUB->UB_XCOMIS1  //PORCENTAGEM DE COMISSAO VEND1
				SC6->C6_XVALCOM := SUB->UB_XVCOMS1  //VALOR COMISSAO VEND1
				SC6->C6_COMIS2  := SUB->UB_XCOMIS2  //PORCENTAGEM DE COMISSAO VEND1
				SC6->C6_XORDEM  := SUB->UB_XORDEM   //ORDEM DE COMPRA DO CLIENTE
				SC6->C6_XPORDEC := SUB->UB_XPORDEC  //PORCENTAGEM DE DESCONTO ADICIONAL
				SC6->C6_XVALDES := SUB->UB_XVALDES	//VALOR DE DESCONTO ADICIONAL
				SC6->C6_XACREPO := SUB->UB_XACREPO	//PORCENTAGEM DE ACRESCIMO ADICIONAL
				SC6->C6_XACREVA := SUB->UB_XACREVA  //VALOR DE ACRESCIMO ADICIONAL
				SC6->C6_XVALACR := SUB->UB_XVALACR	//VALOR DE ACRESCIMO CONDIÇÃO DE PAGAMENTO
				SC6->C6_XPORACR := SUB->UB_XACRECP	//PORCENTAGEM DE ACRESCIMO CONDIÇÃO DE PAGAMENTO
				SC6->C6_XPRCLIS := SUB->UB_PRCTAB   //GRAVA PREÇO DE LISTA CUSTOMIZADO
				SC6->C6_PRUNIT  := SUB->UB_VRUNIT  //GRAVA PREÇO DE LISTA COM O PREÇO DE VENDA( NAO GERAR DESCONTO )
				SC6->C6_DESCONT := 0
				SC6->C6_VALDESC := 0
				SC6->C6_OPER    := SUB->UB_OPER
			
				If Empty(SC6->C6_OPER) .And. SC5->C5_TIPOCLI<>"X" //Renato Nogueira - Verificação do erro de tipo de operação não gravada
					MsgAlert("Atenção, o tipo de operação não será gravado, não feche essa tela e entre em contato com o TI imediatamente, obrigado!STGAP09A")
					MsgAlert("Atenção, o tipo de operação não será gravado, não feche essa tela e entre em contato com o TI imediatamente, obrigado!STGAP09A")
					MsgAlert("Atenção, o tipo de operação não será gravado, não feche essa tela e entre em contato com o TI imediatamente, obrigado!STGAP09A")
				EndIf
			
				SC6->C6_ZNCM    := SUB->UB_ZNCM
				SC6->C6_ZIPI   	:= SUB->UB_ZIPI
				SC6->C6_ZB2QATU	:= SUB->UB_ZB2QATU
				SC6->C6_ZMARKUP	:= SUB->UB_ZMARKUP
				SC6->C6_ZMOTBLO	:= SUB->UB_XBLQITE
				SC6->C6_XPRCCON := SUB->UB_XPRCCON
				SC6->C6_QTDLIB  := SUB->UB_QUANT
				SC6->C6_QTDEMP  := SUB->UB_QUANT
				SC6->C6_UM  	:= SUB->UB_UM
				SC6->C6_ZPRCTAB := SUB->UB_ZPRCTAB
				SC6->C6_XULTPRC := SUB->UB_XULTPRC
				SC6->C6_ZLULT   := SUB->UB_ZLULT
				SC6->C6_ZRESERV :=  Posicione("PA2",4,xFilial("PA2")+xFilial("SC6")+SC6->C6_NUM+SC6->C6_ITEM,"PA2_QUANT")
				           

				SC6->(MsUnlock())
				SC6->(DbCommit())
				nRecno:= SC6->(RecNo())
				MaLibDoFat(SC6->(RecNo()),SC6->C6_QTDLIB,.T.,.T.,.T.,.T.,.T.,.T.,NIL,NIL,NIL,NIL,NIL,0)
				MaLiberOk({SC6->C6_NUM},.F.)
				MsUnLockall()
				SC6->(DbGoto(nRecno))
			EndIf
			SC6->( DbSkip())
		EndDo
	EndIf
	Restarea(aArea)
Return()