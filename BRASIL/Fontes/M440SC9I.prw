#INCLUDE "rwmake.ch"
#include "TOTVS.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"
#INCLUDE "PROTHEUS.CH"
#include "topconn.ch"

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma ³M440SC9I   ºAutor ³Thiago Rocco          º Data ³ 13/12/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Acertando o Campo C9_ORDSEP                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Exclusivo Stek                                             º±± 
±±ºDesenvolvido       ³ FlexProject                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function M440SC9I()

Local aArea := GetArea()
Return() // giovani desabilitei 14/10/17
//Pego o campo ORDSEP
cQuery := " SELECT * "
cQuery += " FROM "+RetSqlName("SC9")+" "
cQuery += " WHERE C9_PEDIDO ='"+SC9->C9_PEDIDO+"' AND C9_NFISCAL <> '         ' AND C9_ORDSEP <> '      ' AND D_E_L_E_T_=' ' "

If SELECT("TRB") > 0
	TRB->(DbCloseArea())
Endif
TcQuery cQuery Alias "TRB" New

//ATUALIZO O NOVO REGISTRO 
cQuery1:= "UPDATE "+RetSqlName("SC9")+" SET C9_ORDSEP ='"+TRB->C9_ORDSEP+"' WHERE C9_PEDIDO ='"+SC9->C9_PEDIDO+"' AND D_E_L_E_T_=' '"
TcSqlExec(cQuery1)   

TRB->(DbCloseArea())
RestArea(aArea)
Return


