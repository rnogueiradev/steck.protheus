#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

Static __lOpened := .F.

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �STDELEND  �Autor  �Renato Nogueira     � Data �  06/03/2014 ���
�������������������������������������������������������������������������͹��
���Desc.     � Apagar endere�os com quantidade zerada na SBF              ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Par�metros� Nenhum                                                     ���
�������������������������������������������������������������������������ͼ��
���Retorno   � Nenhum                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function STDELEND()

Local cQuery 	:= ""
Local cAlias 	:= "QRYTEMP"
Local _cLog		:= ""

_cLog := "RELAT�RIO DE ENDERE�OS DELETADOS "+CHR(13) +CHR(10)

If MsgYesNo("Deseja apagar os endere�os com quantidade zerada da tabela de saldos por endere�o?")
	
	cQuery := " SELECT R_E_C_N_O_ REGISTRO "
	cQuery += " FROM "+RetSqlName("SBF")+ " BF "
	cQuery += " WHERE BF.D_E_L_E_T_=' ' AND BF_QUANT=0 AND BF_FILIAL='"+xFilial("SBF")+"' "
	
	If !Empty(Select(cAlias))
		DbSelectArea(cAlias)
		(cAlias)->(dbCloseArea())
	Endif
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)
	
	dbSelectArea(cAlias)
	(cAlias)->(dbGoTop())
	
	While (cAlias)->(!Eof())
		
		DbSelectArea("SBF")
		SBF->(DbGoTop())
		SBF->(DbGoTo((cAlias)->REGISTRO))
		
		If SBF->(!Eof()) .And. SBF->BF_QUANT=0
			
			SBF->(Reclock("SBF",.F.))
			SBF->(DbDelete())
			SBF->(MsUnlock())
			
			_cLog += SBF->BF_LOCALIZ+" "+SBF->BF_PRODUTO+" "+CVALTOCHAR(SBF->BF_QUANT)+CHR(13) +CHR(10)
			
			(cAlias)->(DbSkip())
			
		EndIf
		
	EndDo
	
	@ 000, 000 TO 230, 350 DIALOG oDlg TITLE 'Relat�rio de detalhamento '
	@ 005,005 Get _cLog Size 167,080 MEMO Object oMemo
	@ 92,135 BMPBUTTON TYPE 1 ACTION Close(oDlg)
	ACTIVATE DIALOG oDlg CENTERED
	
EndIf

Return