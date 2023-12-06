#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  |STUNICOM  ºAutor  ³João Victor         º Data ³  23/10/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função que retorna se o produto é Unicom (especial) ou não º±±
±±º          ³ de acordo com parâmetros enviados pelo PCP SP em 22/10/2015º±±
±±º          ³ Regras válidas apenas para a empresa 01 - Steck Indústria  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Steck Industria Eletrica Ltda.                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*-----------------------------*
User Function STUNICOM(_cCod)
*-----------------------------*
	Local _lUnicom       := .F.
	Local _cQuery1       := ''
	Local _cGrp1         := "('039','041','042','047','100','110','999')"
	Local _cGrp2         := "('000')"
	Local _cExc1         := "BM"
	Local _cExc2         := "BM1"
	Private cPerg 		:= "UNICOM"
	Private cTime        := Time()
	Private cHora        := SUBSTR(cTime, 1, 2)
	Private cMinutos    	:= SUBSTR(cTime, 4, 2)
	Private cSegundos   	:= SUBSTR(cTime, 7, 2)
	Private cAliasLif   	:= cPerg+cHora+cMinutos+cSegundos
	Private _cAlias1     := cAliasLif
	
	If cEmpAnt == '01'//STECK SAO PAULO
		_cQuery1 := " SELECT
		_cQuery1 += " B1_COD   AS A1_CODIGO
		_cQuery1 += ",B1_DESC  AS A2_DESCRICAO
		_cQuery1 += ",B1_GRUPO AS A3_GRUPO

		_cQuery1 += ",CASE WHEN B1_GRUPO IN "+_cGrp1"
		_cQuery1 += " OR
		_cQuery1 += " (B1_GRUPO IN "+_cGrp2"
		_cQuery1 += " AND SUBSTR(B1_COD,LENGTH(TRIM(B1_COD))-1,2) = '"+_cExc1+"'
		_cQuery1 += " OR  SUBSTR(B1_COD,LENGTH(TRIM(B1_COD))-2,3) = '"+_cExc2+"')
	
		_cQuery1 += " THEN 'UNICOM' ELSE
		_cQuery1 += " 'LINHA' END AS A4_DESCGRUPO

		_cQuery1 += " FROM "+RetSqlName("SB1")+" SB1"
		_cQuery1 += " WHERE SB1.D_E_L_E_T_ = ' '
		_cQuery1 += " AND B1_COD    = '"+_cCod+"' "
		_cQuery1 += " AND B1_FILIAL = '"+xFilial("SB1")+"'"

		_cQuery1 := ChangeQuery(_cQuery1)

		If Select(_cAlias1) > 0
			(_cAlias1)->(dbCloseArea())
		EndIf

		dbUseArea(.T.,'TOPCONN',TcGenQry(,,_cQuery1),_cAlias1)

		DbSelectArea(_cAlias1)
		(_cAlias1)->(DbGoTop())
		If  Select(_cAlias1) > 0
			While 	(_cAlias1)->(!Eof())
				If Alltrim((_cAlias1)->A4_DESCGRUPO) = 'UNICOM'
					_lUnicom := .T.
				ElseIf Alltrim((_cAlias1)->A4_DESCGRUPO) = 'LINHA'
					_lUnicom := .F.
				Else
					_lUnicom := .F.
				Endif
				(_cAlias1)->(dbskip())
			End
			(_cAlias1)->(dbCloseArea())
		Endif
	Endif

Return (_lUnicom)
