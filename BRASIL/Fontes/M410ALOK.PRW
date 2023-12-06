#include 'Protheus.ch'
#include 'RwMake.ch'

/*====================================================================================\
|Programa  | M410ALOK         | Autor | GIOVANI.ZAGO             | Data | 17/01/2013  |
|=====================================================================================|
|Descrição |   P.E. M410ALOK						                                  |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | M410ALOK                                                                 |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
User Function M410ALOK()
LOCAL  cCliDist 	:= SuperGetMV("ST_CLIDIST",.F.,"03346706")
*-----------------------------*
local lRet:= .T.
If ( Type("l410Auto") == "U" .OR. !l410Auto )

	/***************************************************************************************************************************************
	<<Alteração>>
	Ação......: Não permitir alterar um pedido de venda do cliente a STECK - Distribuidora código "033467"
	Analista..: Marcelo Klopfer Leme - SIGAMAT
	Data......: 29/09/2022
	Chamado...:  20220928018282
	***************************************************************************************************************************************/
	IF ( Type("l410Auto") == "U" .OR. !l410Auto )
		IF ALTERA = .T. .AND. SC5->C5_CLIENTE+SC5->C5_LOJACLI = ALLTRIM(cCliDist) .AND. cEmpAnt $ ("03/01") .AND. SC5->C5_TIPO = "N"
			MSGALERT("Pedidos de Venda para a Distribuidora não pode ser alterado!")
			RETURN .F.
		ENDIF	
	ENDIF	

	If !Empty(Alltrim(SC5->C5_XHISVEN))
	   //	msginfo("Pedido com Troca de Vendedores !!!!!")  //Giovani Zago desabilitado solicitação tati e viviane melhorias protheus 18/07/13
	EndIf
	If 	SC5->C5_XRATEI1 <> 0   .or. ;
		SC5->C5_XRATEI3 <> 0   .or. ;
		SC5->C5_XRATEI4 <> 0   .or. ;
		SC5->C5_XRATEI5 <> 0   .or. ;
		SC5->C5_XVALRA1 <> 0   .or. ;
		SC5->C5_XVALRA3 <> 0   .or. ;
		SC5->C5_XVALRA4 <> 0   .or. ;
		SC5->C5_XVALRA5 <> 0
		lRet:= .F.
		
		DbSelectArea('SA3')
		SA3->(DbSetOrder(7))
		If SA3->(dbSeek(xFilial('SA3')+__cuserid))
			If Empty(SA3->A3_SUPER)   .Or. Empty(SA3->A3_GEREN)
				If	msgyesno("Pedido Possui Rateio de Comissão Deseja Alterar ?")
					lRet:= .T.
					SC5->(RecLock("SC5",.F.))
					SC5->C5_VEND3   :=  ''
					SC5->C5_VEND4   :=  ''
					SC5->C5_VEND5   :=  ''
					SC5->C5_XRATEI1 :=  0
					SC5->C5_XRATEI3 :=  0
					SC5->C5_XRATEI4 :=  0
					SC5->C5_XRATEI5 :=  0
					SC5->C5_XVALRA1 :=  0
					SC5->C5_XVALRA3 :=  0
					SC5->C5_XVALRA4 :=  0
					SC5->C5_XVALRA5 :=  0
					SC5->(Msunlock("SC5"))
					SC5->( DbCommit() )  
					DbSelectArea("SC6")
					SC6->(DbSetOrder(1))
					If SC6->(DbSeek(xFilial("SC6")+SC5->C5_NUM))
						While SC6->C6_NUM == SC5->C5_NUM
							SC6->(RecLock("SC6",.F.))
							SC6->C6_COMIS1 :=0
							SC6->C6_COMIS3 :=0
							SC6->C6_COMIS4 :=0
							SC6->C6_COMIS5 :=0
							SC6->C6_XVALCOM:=0
							SC6->(Msunlock("SC6"))
							SC6->( DbCommit() )  
							SC6->(DbSkip())
						Enddo
						SC6->(DbCloseArea())
					EndIf
				EndIf
			Else
				msginfo("Pedido Possui Rateio de Vendedores")
			EndIf
		EndIf
	EndIf
EndIf
Return ( lRet )
