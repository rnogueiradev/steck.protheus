#INCLUDE "PROTHEUS.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ GETMENUS  ºAutor ³Jonathan Schmidt Alvesº Data ³21/01/2021 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Customizacao para obter nivel de acesso do menu do usuario.º±±
±±º          ³ Importante: Quando o usuario estiver logando via SIGAMDI   º±±
±±º          ³ ha um tratamento diferente pois o Protheus nao consegue    º±±
±±º          ³ abrir a tabela ZG2 neste momento, por isso ha o ZG20101.DTCº±±
±±º          ³ na pasta system que deve ser atualizado de tempos em temposº±±
±±º          ³ Desta forma quando acesso por MDI os acessos estarao em diaº±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SCHNEIDER                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

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
