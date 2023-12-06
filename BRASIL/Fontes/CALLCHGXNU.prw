#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWMVCDEF.CH"

/*���������������������������������������������������������������������������
���Programa  � CALLCHGXNU �Autor� Jonathan Schmidt Alves�Data �21/01/2021 ���
�������������������������������������������������������������������������͹��
���Desc.     � P.E. na entrada de qualquer modulo para carregar o menu do ���
���          � usuario para o modulo escolhido.                           ���
���          �                                                            ���
���          � PARAMIXB[01] Codigo de Usuario                             ���
���          � PARAMIXB[02] Codigo da Empresa                             ���
���          � PARAMIXB[03] Codigo da Filial                              ���
���          � PARAMIXB[04] Numero do m�dulo                              ���
���          � PARAMIXB[05] Nome do Menu                                  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Revisao   �                 �Jonathan Schmidt Alves � Data �21/01/2021 ���
�������������������������������������������������������������������������͹��
���Uso       � SCHNEIDER                                                  ���
���������������������������������������������������������������������������*/

User Function CALLCHGXNU()

    Local cArqMenu  := AllTrim(PARAMIXB[05])

	//cArqMenu := StartJob("U_STTEC001",GetEnvServer(),.T.,cArqMenu,__cUserID)

Return(cArqMenu)

/*====================================================================================\
|Programa  | STTEC001        | Autor | RENATO.OLIVEIRA           | Data | 16/02/2021  |
|=====================================================================================|
|Descri��o |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Hist�rico....................................|
\====================================================================================*/

User Function STTEC001(cArqMenu,cUsuario)

	Local _cQuery1 	:= ""
	Local _cAlias1  := ""
	Local cCodPer   := ""

	RpcSetType( 3 )
	RpcSetEnv("01","01",,,"COM")

	_cAlias1  := GetNextAlias()

	If !("CFG" $ cArqMenu) // Modulo configurador continua o padrao

        _cQuery1 := " SELECT *
        _cQuery1 += " FROM "+RetSqlName("ZG2")+" ZG2
        _cQuery1 += " WHERE ZG2.D_E_L_E_T_=' ' AND ZG2_CODUSR='"+cUsuario+"'

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
    
		If !Empty(cCodPer) // Perfil do usuario identificado no ZG2
			If File("\MENUS_ZG1\" + cCodPer + ".XNU") // Menu existe
                cArqMenu := "\MENUS_ZG1\" + cCodPer + ".XNU"
			EndIf
		EndIf

	EndIf

Return(cArqMenu)
