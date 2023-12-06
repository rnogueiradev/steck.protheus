#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �STCADOFL  �Autor  �Renato Nogueira     � Data �  13/05/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Tela para manuten��o de cadastros de prazos de oferta       ���
���          �logistica                                                   ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function STCADOFL()

Private cCadastro := "Cadastro de prazos para OL"
Private cAlias := "ZZO"
Private aRotina := {{ "Pesquisar"  , "PesqBrw" ,  0 , 1 },;
{ "Visualizar" , "AxVisual" , 0 , 2 },;
{ "Incluir"    , "AxInclui" , 0 , 3 },;
{ "Alterar"    , "U_XXAltera()" , 0 , 4 },;
{ "Excluir"    , "AxDeleta" , 0 , 5 }}

dbSelectArea(cAlias)
dbSetOrder(1)

mBrowse(,,,,cAlias)

Return()

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �XXALTERA  �Autor  �Renato Nogueira     � Data �  13/05/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Tela para manuten��o de cadastros de prazos de oferta       ���
���          �logistica                                                   ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function XXAltera()

Local _nOpc			:=	""
Local _nAntPrazo	:= 	0
Local _nNewPrazo	:=	0
Local _lAlterou		:= .F.

_nAntPrazo	:= ZZO->ZZO_PRAZO

_nOpc := AxAltera("ZZO",ZZO->(Recno()),4,,,,,)

_nNewPrazo	:= ZZO->ZZO_PRAZO

_lAlterou	:= _nAntPrazo<>_nNewPrazo

If _nOpc=1 .And. _lAlterou //Confirmou a altera��o e alterou prazo
	
	Processa({||STATUOFL(ZZO->ZZO_CODIGO,_nNewPrazo)},"Aguarde, atualizando produtos ...")
	
EndIf

Return()

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �STATUOFL  �Autor  �Renato Nogueira     � Data �  13/05/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Tela para manuten��o de cadastros de prazos de oferta       ���
���          �logistica                                                   ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function STATUOFL(_cCodigo,_nNewPrazo)

Local _cQuery		:=	""
Local _cAlias 		:= 	"QRYTEMP"

ProcRegua(4) // Numero de registros a processar

IncProc()

_cQuery	:= " SELECT R_E_C_N_O_ REGISTRO "
_cQuery += " FROM "+RetSqlName("SB1")+" B1 "
_cQuery += " WHERE B1.D_E_L_E_T_=' ' AND B1_ZCODOL = '"+_cCodigo+"' "

If !Empty(Select(cAlias))
	DbSelectArea(cAlias)
	(cAlias)->(dbCloseArea())
Endif

dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cAlias,.T.,.T.)

dbSelectArea(_cAlias)
(_cAlias)->(dbGoTop())

DbSelectArea("SB1")
SB1->(DbSetOrder(1))

While !(_cAlias)->(Eof())
	
	SB1->(DbGoTop())
	SB1->(DbGoTo((_cAlias)->REGISTRO))
	
	If SB1->(!Eof())
		
		SB1->(RecLock("SB1",.F.))
		SB1->B1_XOFLOG	:= _nNewPrazo
		SB1->(MsUnLock())
		
	EndIf                
	
	(_cAlias)->(DbSkip())
	
EndDo

IncProc()
IncProc()
IncProc()

MsgInfo("Produtos atualizados com novo prazo!")

Return()