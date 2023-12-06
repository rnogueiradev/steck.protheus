#Include "Protheus.ch"

/*/{Protheus.doc} MA125BUT
description
Ponto de Entrada para adicionar botão
Ticket: 20210623010642
@type function
@version  
@author Valdemir Jose
@since 29/06/2021
@return variant, return_description
/*/
User Function MA125BUT
	Local _aButtons := {}
	aAdd(_aButtons,{"xAnexo" ,{|| U_STAnexoV('SC3', 'ContratoParceria', {'C3_FILIAL','C3_USER','NOUSER'},,SC3->C3_NUM)}	,"Anexar Documento","Anexar Documento"})         // Valdemir Rabelo Ticket: 20210623010642 - 29/06/2021

Return(_aButtons)
