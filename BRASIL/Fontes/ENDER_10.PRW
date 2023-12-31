#INCLUDE "RWMAKE.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NOVO9     �Autor  �Microsiga           � Data �  09/16/13   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


USER FUNCTION ENDER_10

Processa({|| _cRecs := Local10()},'Endere�ando Local 10')

MsgStop("Enderecamento Conlcuido - " +  alltrim(str(_cRecs))+ " Processados" )

Return



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ENDER_10  �Autor  �Microsiga           � Data �  09/16/13   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

            
Static Function Local10 
 

cQuery	:= " SELECT  R_E_C_N_O_ AS REGISTRO  "
cQuery	+= " FROM "+RetSqlName("SDA")+" SDA      "
cQuery	+= " WHERE          "
cQuery	+= " DA_FILIAL =  '"+XFILIAL("SDA")+"'  
cQuery	+= " AND DA_LOCAL = '10'   
cQuery	+= " AND DA_SALDO > 0  " 
cQuery	+= " AND D_E_L_E_T_ = ' ' " 

cQuery	:= ChangeQuery(cQuery)

dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),"TSDA", .F., .T.)

TcSetField("TSDA","REGISTRO", 	"N",9	, 0 )
 
aHeader := {}
aCols	:= {}

DbSelectArea ("TSDA")
TSDA->(DbGoTop())
nCount:=0
dbeval({||nCount++})

ProcRegua(nCount) // Numero de registros a processar

 


Dbselectarea("TSDA")
dBGotop()

Do while !eof()

	IncProc()
	
	DbSelectArea("SDA")
	dbGoTo(TSDA->REGISTRO)

	DbSelectArea("SB2")
	DbSetOrder(1)
	MsSeek(xFilial("SB2") + SDA->DA_PRODUTO + SDA->DA_LOCAL)
	
	cLocaliz := "RETRABALHO"
	A100Distri(SDA->DA_PRODUTO,SDA->DA_LOCAL,SDA->DA_NUMSEQ,SDA->DA_DOC,Nil,Nil,Nil,cLocaliz,Nil,SDA->DA_SALDO,SDA->DA_LOTECTL,SDA->DA_NUMLOTE)
	
	Dbselectarea("TSDA")
	Dbskip()     

Enddo                 

Dbselectarea("TSDA")
DbClosearea("TSDA")
          

RestArea(_aArSB2)
         
Return(nCount)