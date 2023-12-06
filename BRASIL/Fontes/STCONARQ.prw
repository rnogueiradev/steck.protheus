#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMBROWSE.CH"
#INCLUDE "FWMVCDEF.CH"

/*/{Protheus.doc} STCONARQ

Arquivo de Configura��o CNAB

@type function
@author Everson Santana
@since 04/02/19
@version Protheus 12 - Financeiro

@history , ,

/*/

/*Iniciando sua fun��o*/
User Function STCONARQ()

PRIVATE cCadastro  := "Conf. Arg. SISPAG"

PRIVATE aRotina     := {}


AxCadastro("Z26", OemToAnsi(cCadastro))

Return 