#Include "Protheus.ch"
#Include "TopConn.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � STATF01    � Autor � Vitor Merguizo     � Data �  02/06/14 ���
�������������������������������������������������������������������������͹��
���Descricao � Fun��o Criada para retornar o proximo numero de Ativo      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function STATF01()

Local aArea		:= GetArea()
Local cQuery	:= ""
Local cAlias	:= GetNextAlias()
Local cRet 		:= "0000000000"

cQuery := "SELECT MAX(N1_CBASE) N1_CBASE FROM "+RetSqlName("SN1")+" SN1 WHERE N1_FILIAL <> '  ' AND D_E_L_E_T_= ' '"

dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),cAlias, .F., .T.)

TCSetField(cAlias,"N1_CBASE"	,"C",10,0 )

DbSelectArea(cAlias)
(cAlias)->(dbGoTop())
While (cAlias)->(!Eof())
	cRet := (cAlias)->N1_CBASE	
	(cAlias)->(dbSkip())
EndDo

cRet := SOMA1(cRet)
/* Removido\Ajustado - N�o executa mais RecLock na X6. Cria��o/altera��o de dados deve ser feita apenas pelo m�dulo Configurador ou pela rotina de atualiza��o de vers�o.
DbSelectArea("SX6")
SX6->(DbSetOrder(1))
If SX6->(DbSeek(xFilial("SX6")+"MV_CBASEAF"))
	RecLock("SX6",.F.)
	SX6->X6_CONTEUD := SX6->X6_CONTSPA := SX6->X6_CONTENG := SOMA1(cRet)
	MsUnlock()	
EndIf*/

If !Empty(Select(cAlias))
	DbSelectArea(cAlias)
	(cAlias)->(dbCloseArea())
Endif

RestArea(aArea)

Return(cRet)
