#include "rwmake.ch"  
#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
SISP005 -> Utilizada para Verificacao e retorno de dados referente ao CNPJ/CGC a ser 
utilizado na geracao do ITAUPAG.PAG ( SISPAG )
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
			13/01/2012 - Marcelo Araujo Dente - marcelo.dente@totvs.com.br
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/



User Function SISP005()
// SEA->EA_TIPO="30" - Pagamento Funcionario
IF (SEA->EA_TIPO == "30")

	_cReturn5 :="000" + SRA->RA_CIC                    
Else

	_cReturn5 :=SUBST(SA2->A2_CGC,1,14)                                             
Endif
Return(_cReturn5)