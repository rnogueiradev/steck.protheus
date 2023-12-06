#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWMVCDEF.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ CALLCHGXNU ºAutor³ Jonathan Schmidt AlvesºData ³21/01/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ P.E. na entrada de qualquer modulo para carregar o menu do º±±
±±º          ³ usuario para o modulo escolhido.                           º±±
±±º          ³                                                            º±±
±±º          ³ PARAMIXB[01] Codigo de Usuario                             º±±
±±º          ³ PARAMIXB[02] Codigo da Empresa                             º±±
±±º          ³ PARAMIXB[03] Codigo da Filial                              º±±
±±º          ³ PARAMIXB[04] Numero do módulo                              º±±
±±º          ³ PARAMIXB[05] Nome do Menu                                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRevisao   ³                 ³Jonathan Schmidt Alves º Data ³21/01/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function CALLCHGXNU()

    Local cArqMenu  := AllTrim(PARAMIXB[05])

	//cArqMenu := StartJob("U_STTEC001",GetEnvServer(),.T.,cArqMenu,__cUserID)

Return(cArqMenu)

/*====================================================================================\
|Programa  | STTEC001        | Autor | RENATO.OLIVEIRA           | Data | 16/02/2021  |
|=====================================================================================|
|Descrição |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
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
