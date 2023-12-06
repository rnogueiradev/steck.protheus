#include "rwmake.ch"
#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
SISP000 -> Utilizada para Verificacao e retorno de dados referente ao Banco a ser utili-
zado na geracao do ITAUPAG.PAG ( SISPAG )
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
			13/01/2012 - Marcelo Araujo Dente - marcelo.dente@totvs.com.br
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/



User Function SISP000()
// SEA->EA_TIPO="30" - Pagamento Funcionario
IF (SEA->EA_TIPO == "30")

	_cReturn0 :=SUBSTR(SRA->RA_BCDEPSA,1,3)
Else
	//>> Chamado 006557 - Everson Santana 22.03.18 - Validar a Conta no Cadastro do Titulo
	If !Empty(SE2->E2_FORBCO)
		_cReturn0 :=Substr(SE2->E2_FORBCO,1,3)
	Else
	//<< Chamado 006557 - Everson Santana 22.03.18 - Validar a Conta no Cadastro do Titulo
		_cReturn0 :=Substr(SA2->A2_BANCO,1,3)
	EndIf

Endif
Return(_cReturn0)