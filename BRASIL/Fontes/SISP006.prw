#include "rwmake.ch"  
#include "protheus.ch"

/*
����������������������������������������������������������������������������������������
SISP006 -> Utilizada para Verificacao e retorno de dados referente a FINALIDADE DOC E 
STATUS FUNCION�RIO a ser utilizado na geracao do ITAUPAG.PAG ( SISPAG )
����������������������������������������������������������������������������������������
			13/01/2012 - Marcelo Araujo Dente - marcelo.dente@totvs.com.br
����������������������������������������������������������������������������������������
*/



User Function SISP006()
// SEA->EA_TIPO="30" - Pagamento Funcionario
IF (SEA->EA_TIPO == "30")

	_cReturn6 :="21" //Efetivo Privado                     
Else

	_cReturn6 := "01" //Credito em Conta                                             
Endif
Return(_cReturn6)