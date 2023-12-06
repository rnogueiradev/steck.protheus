#INCLUDE "rwmake.ch"
#include "TOTVS.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"
#INCLUDE "PROTHEUS.CH"
#include "topconn.ch"

/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北赏屯屯屯屯脱屯屯屯屯屯送屯屯屯淹屯屯屯屯屯屯屯屯屯退屯屯屯淹屯屯屯屯屯屯槐�
北篜rograma 矼440SC9I   篈utor 砊hiago Rocco          � Data � 13/12/04   罕�
北掏屯屯屯屯拓屯屯屯屯屯释屯屯屯贤屯屯屯屯屯屯屯屯屯褪屯屯屯贤屯屯屯屯屯屯贡�
北篋esc.     � Acertando o Campo C9_ORDSEP                                罕�
北�          �                                                            罕�
北掏屯屯屯屯拓屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡�
北篣so       � Exclusivo Stek                                             罕� 
北篋esenvolvido       � FlexProject                                       罕�
北韧屯屯屯屯拖屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯急�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
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


