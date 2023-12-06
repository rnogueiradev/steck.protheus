#include "TOPCONN.CH"
#include "RWMAKE.CH"

USER FUNCTION ACT_SBK


_cQuery := "SELECT SALDO_BK_3009.*,NVL(B9_QINI,0) AS SALDO_B9,NVL(BK_QINI,0) AS SALDO_BK  ,B9_LOCAL ,B9_DATA "
_cQuery += "FROM SALDO_BK_3009 "
_cQuery += "LEFT JOIN SB9010 ON B9_FILIAL = DB_FILIAL AND DB_PRODUTO = B9_COD AND B9_DATA = '20140930' AND B9_LOCAL = '98' AND SB9010.D_E_L_E_T_ = ' ' "
_cQuery += "LEFT JOIN SBK010 ON BK_FILIAL = DB_FILIAL AND DB_PRODUTO = BK_COD AND BK_DATA = '20140930' AND BK_LOCAL = '98' AND SBK010.D_E_L_E_T_ = ' ' "

TcQuery _cQuery New Alias "QR1"

TCSETFIELD("QR1","SALDO"   		,"N",	15,2)
TCSETFIELD("QR1","SALDO_BK"   	,"N",	15,2)
TCSETFIELD("QR1","SALDO_B9"   	,"N",	15,2)
TCSETFIELD("QR1","B9_DATA"		,"D")
                            

dbSelectArea("QR1")
dbGotop()


DBSELECTAREA("SBK")
DBSETORDER(1)

dbSelectArea("QR1")
Do While !eof()
	
	DBSELECTAREA("SBK")
	DBSEEK(QR1->DB_FILIAL+QR1->DB_PRODUTO+QR1->B9_LOCAL+QR1->DB_LOTECTL+QR1->DB_NUMLOTE+QR1->DB_LOCALIZ+QR1->DB_NUMSERI+DTOS(QR1->B9_DATA))
	
	
	If EOF()
		RecLock('SBK',.T.)
		Replace BK_FILIAL  With QR1->DB_FILIAL
		Replace BK_COD     With QR1->DB_PRODUTO
		Replace BK_LOCAL   With QR1->B9_LOCAL
		Replace BK_LOCALIZ With QR1->DB_LOCALIZ
		Replace BK_NUMSERI With QR1->DB_NUMSERI
		Replace BK_DATA    With  QR1->B9_DATA 
	Else
		RecLock('SBK',.F.)
	EndIf
	Replace BK_QINI    With QR1->SALDO
	Replace BK_QISEGUM With 987654321
	
	MsUnlock()
	
	dbSelectArea("QR1")
	Dbskip()
	
Enddo

dbSelectArea("QR1")
dbCloseArea("QR1")

MsgStop('Termino de processamento')

Return