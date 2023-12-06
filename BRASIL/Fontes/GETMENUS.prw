#INCLUDE "PROTHEUS.CH"

/*���������������������������������������������������������������������������
���Programa  � GETMENUS  �Autor �Jonathan Schmidt Alves� Data �21/01/2021 ���
�������������������������������������������������������������������������͹��
���Desc.     � Customizacao para obter nivel de acesso do menu do usuario.���
���          � Importante: Quando o usuario estiver logando via SIGAMDI   ���
���          � ha um tratamento diferente pois o Protheus nao consegue    ���
���          � abrir a tabela ZG2 neste momento, por isso ha o ZG20101.DTC���
���          � na pasta system que deve ser atualizado de tempos em tempos���
���          � Desta forma quando acesso por MDI os acessos estarao em dia���
�������������������������������������������������������������������������͹��
���Uso       � SCHNEIDER                                                  ���
���������������������������������������������������������������������������*/

User Function GETMENUS(cCodUsr)

	Local cCodPer 	:= ""
	Local _cQuery1 	:= ""
	Local _cAlias1  := GetNextAlias()

	_cQuery1 := " SELECT *
	_cQuery1 += " FROM "+RetSqlName("ZG2")+" ZG2
	_cQuery1 += " WHERE ZG2.D_E_L_E_T_=' ' AND ZG2_CODUSR='"+__cUserId+"'

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	If (_cAlias1)->(!Eof())
		cCodPer := (_cAlias1)->ZG2_CODPER
	EndIf

Return(cCodPer)
