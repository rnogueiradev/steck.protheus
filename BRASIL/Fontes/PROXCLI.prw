#Include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � ProxCli �Autor:                           �Data � 01/04/03 ���
�������������������������������������������������������������������������͹��
���          �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function ProxCli()
Local NewCli, CodCli, strCodCli
Local aintTabASCII, i, intASC, intTab, bolVaiUm, strNovaString
Local cAliaAnte,nAreaAnte,nRegiAnte

cAliaAnte := Alias()
nAreaAnte := IndexOrd()
nRegiAnte := RecNo()

NewCli := Trim(SUBSTR(M->A1_CGC,1,8))
strCodLoja := "01"
dbSelectArea("SA1")                
dbSetOrder(3)
If dbSeek(xFilial("SA1")+NewCli,.t.)

	CodCli := SA1->A1_COD  
	
ELSE

	CodCli := GETSXENUM("SA1") 
Endif                      
        
dbSelectArea(cAliaAnte)
dbSetOrder(nAreaAnte)
dbGoTo(nRegiAnte)

Return(CodCli)