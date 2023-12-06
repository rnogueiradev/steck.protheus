#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTMKVFIM   บAutor  ณMicrosiga           บ Data ณ  01/27/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPonto de Entrada apos a gravacao do pedido de venda do      บฑฑ
ฑฑบ          ณorcamento do TELEVENDAS - TMKA273D                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
<<<< ALTERAวรO >>>>
A็ใo.........: Chamar a fun็ใo STTMKR3A - Gera็ใo de Or็amento em PDF.
.............: Estou incluindo este fonte ao final da rotina de or็amento pois no ambiente antigo
.............: era assim que teoricamente funcionava, mas apesar de compilar todos os fontes do prodjeto acrito que algum fonte
.............: tenha se perdido e nใo encontramos a chamada da impressใo original.
Desenvolvedor: Marcelo Klopfer Leme - SIGAMAT
Data.........: 13/12/2021
Chamados.....: 20220110000690
****************************************/
User Function TMKVFIM(cOrc,cPedido)
	//conout(time()+' - vfim ini')
	MsUnlockAll()
	U_STFSVE71(cOrc,cPedido) //Funcao para gravar status do pedido
	//conout(time()+' - vfim 71')
	MsUnlockAll()

	/*************************************************************
	<<< ALTERAวรO >>> 
	A็ใo...........: Nใo efetuar mais a reserva para a empresa 11 - Distribuidora somente quando o Tipo de Opera็ใo for "DIFERENTE" de "01"
	...............: A reserva irแ ser gerada atrav้s de um novo JOB
	Regra..........: Se o Tipo de Opera็ใo for "IGUAL A 01 NรO EFETUA A RESERVA" 
	...............: Se o Tipo de Opera็ใo for "DIFERENTE DE 01 EFETUA A RESERVA" 
	Desenvolvedor..: Marcelo Klopfer Leme - SIGAMAT
	Data...........: 29/04/2022
	Chamado........: 20220429009114 - OFERTA LOGISTICA
	*************************************************************/				
	IF cEmpAnt <> "11"
		U_STFSC10O(cPedido) //Funcao para gravar falta/reserva do pedido do call center
		MsUnlockAll()
	ELSEIF cEmpAnt = "11" .AND. SC6->C6_OPER <> "01"
		U_STFSC10O(cPedido) //Funcao para gravar falta/reserva do pedido do call center
		MsUnlockAll()
	ENDIF

	U_STVLDPED(cOrc,cPedido) //Funcao para se gravou tipo de operacao, falta e reserva 30/08/2013
	If Empty(Alltrim(cPedido))
		U_STDESALC(Inclui,Altera)//Giovani Zago 18/12/13 Al็ada Comercial
	EndIf
	

	/****************************************
	<<<< ALTERAวรO >>>>
	A็ใo.........: Verificar se foi informado o C๓digo do Contrato. 
	.............: Se existir contrato grava no pedido de venda o c๓digo do contrato
	Desenvolvedor: Marcelo Klopfer Leme - SIGAMAT
	Data.........: 28/02/2022
	Chamados.....: 20220210003369
	****************************************/
	If Fieldpos("UA_XCONTRA") > 0
		IF !EMPTY(SUA->UA_XCONTRA) .AND. !EMPTY(cPedido)
			RECLOCK("SC5",.F.)
			SC5->C5_XCONTRA := SUA->UA_XCONTRA
			SC5->(MSUNLOCK())
		ENDIF
	EndIf

	/****************************************
	<<<< ALTERAวรO >>>>
	A็ใo.........: Chamar a fun็ใo STTMKR3A - Gera็ใo de Or็amento em PDF.
	A็ใo.........: Chamar a fun็ใo RSTFAT09 - Gera็ใo de Pedido de Venda em PDF.
	.............: Estou incluindo este fonte ao final da rotina de or็amento pois no ambiente antigo
	.............: era assim que teoricamente funcionava, mas apesar de compilar todos os fontes do prodjeto acreito que algum fonte
	.............: tenha se perdido e nใo encontramos a chamada da impressใo original.
	Desenvolvedor: Marcelo Klopfer Leme - SIGAMAT
	Data.........: 23/02/2022
	Chamados.....: 20220209003290
	****************************************/

	If !IsInCallStack("INSEREPED") //Retirar chamada qdo vier do portal
		IF EMPTY(cPedido)
			U_RSTFAT11()
		ELSEIF !EMPTY(cPedido)
			U_RSTFAT09()
		ENDIF
	EndIf

Return
