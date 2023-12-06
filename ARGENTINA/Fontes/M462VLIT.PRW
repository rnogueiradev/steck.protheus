#include 'Protheus.ch'
#include 'RwMake.ch'

/*====================================================================================\
|Programa  | M462VLIT         | Autor | GIOVANI.ZAGO             | Data | 18/07/2018  |
|=====================================================================================|
|Descrição |   Ponto de entrada remito tirar o desconto dos pedidos sc5 e sc9         |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | M462VLIT                                                                 |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\=====================================================================================
*/ 
*-----------------------------*
User Function M462VLIT()
*-----------------------------* 
	
	Local lRet := .T.
	Local cNum := Alltrim(SC5->C5_NUM)
	Local cQry := " "
	 
	cQry := " UPDATE SC6070 SC6 SET  C6_PRUNIT =  C6_PRCVEN ,C6_DESCONT = 0 , C6_VALOR = ROUND(C6_PRCVEN * C6_QTDVEN,2)   WHERE SC6.D_E_L_E_T_ = ' ' AND C6_NUM =  '"+cNum+" '   AND C6_FILIAL = '01'"
	TcSQLExec(cQry)
	cQry := " "
	
	Dbselectarea("SC6")
	SC6->(Dbsetorder(1))
	If SC6->(Dbseek(xfilial("SC6")+cNum))
		While !(SC6->(Eof())) .and.  cNum  = Alltrim(SC6->C6_NUM)

			cQry := " UPDATE SC9070 SC9 SET C9_PRCVEN = "+STRTRAN( CVALTOCHAR(SC6->C6_PRCVEN),',','.')+"  WHERE SC9.D_E_L_E_T_ = ' ' AND C9_PEDIDO =  '"+cNum+"'     AND C9_ITEM =  '"+SC6->C6_ITEM+"'     AND C9_FILIAL = '01'"
			TcSQLExec(cQry)
			cQry := " "
			SC6->(DbSkip())

		End
	EndIf
Return (lRet)





