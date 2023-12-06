#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"

/*/{Protheus.doc} MT120FIX
@name MT120FIX
@type User Function
@desc ajustar campos do browse do pedido de compra
@author Renato Nogueira
@since 17/05/2018
/*/

User Function MT120FIX()

	Local _aCampos := {}

	AADD(_aCampos,{"Número","C7_NUM"})
	AADD(_aCampos,{"Data Emissão","C7_EMISSAO"})
	AADD(_aCampos,{"Fornecedor","C7_FORNECE"})
	AADD(_aCampos,{"WF Ok?","C7_XENV"})
	AADD(_aCampos,{"Visualizado?","C7_XVIS"})

Return(_aCampos)