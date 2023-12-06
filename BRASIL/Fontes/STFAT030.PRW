#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWMVCDEF.CH"

/*====================================================================================\
|Programa  | STFAT030        | Autor | RENATO.OLIVEIRA           | Data | 11/10/2018  |
|=====================================================================================|
|Descrição | Gravar XML em FTP                                                        |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|Chamado 003058																		  |
|........................................Histórico....................................|
\====================================================================================*/

User Function STFAT030(_cChave)

	Local _cQuery1 := ""
	Local _cAlias1 := GetNextAlias()
	Local _cQuery2 := ""
	Local _cAlias2 := GetNextAlias()
	// Ticket 20210628010916 - XML Schneider - Eduardo Pereira Sigamat - 05.07.2021 - Inicio
	Local _cQuery3 := ""
	Local _cAlias3 := GetNextAlias()
	// Ticket 20210628010916 - XML Schneider - Eduardo Pereira Sigamat - 05.07.2021 - Fim
	Local nPorta   := 21
	Local _cIdEnt  := ""

	_cQuery2 := " SELECT ID_ENT
	_cQuery2 += " FROM SPED001 SPED
	_cQuery2 += " WHERE D_E_L_E_T_=' ' AND CNPJ='"+SM0->M0_CGC+"' AND PASSCERT<>' ' 

	If !Empty(Select(_cAlias2))
		DbSelectArea(_cAlias2)
		(_cAlias2)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery2),_cAlias2,.T.,.T.)

	dbSelectArea(_cAlias2)
	(_cAlias2)->(dbGoTop())

	If (_cAlias2)->(!Eof())	
		 _cIdEnt := (_cAlias2)->ID_ENT
	EndIf

	_cQuery1 := " SELECT R_E_C_N_O_
	_cQuery1 += " FROM SPED050 SPED
	_cQuery1 += " WHERE D_E_L_E_T_=' ' AND ID_ENT='"+_cIdEnt+"' AND DOC_CHV='"+_cChave+"'

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	// Ticket 20210628010916 - XML Schneider - Eduardo Pereira Sigamat - 05.07.2021 - Inicio
	_cQuery3 := " SELECT R_E_C_N_O_ RECSPD54
	_cQuery3 += " FROM SPED054 SPED
	_cQuery3 += " WHERE D_E_L_E_T_ = ' ' AND ID_ENT = '" + _cIdEnt + "' AND NFE_CHV = '" + _cChave + "'
	If !Empty(Select(_cAlias3))
		dbSelectArea(_cAlias3)
		(_cAlias3)->( dbCloseArea() )
	EndIf
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery3),_cAlias3,.T.,.T.)
	dbSelectArea(_cAlias3)
	(_cAlias3)->( dbGoTop() )
	If (_cAlias3)->( !Eof() )
		USE SPED054 ALIAS SPED054 SHARED NEW VIA "TOPCONN"
		SPED054->( dbGoTo((_cAlias3)->RECSPD54) )
		If SPED054->( !Eof() )
			cXmlProt := SPED054->XML_PROT
		EndIf
	EndIf
	SPED054->( dbCloseArea() )      // Valdemir Rabelo 23/07/2021 - Ticket: 20210705011711
	// Ticket 20210628010916 - XML Schneider - Eduardo Pereira Sigamat - 05.07.2021 - Fim

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	If (_cAlias1)->(!Eof())

		USE SPED050 ALIAS SPED050 SHARED NEW VIA "TOPCONN"

		SPED050->(DbGoTo((_cAlias1)->R_E_C_N_O_))

		If SPED050->(!Eof())

			_cXml := '<nfeProc xmlns="http://www.portalfiscal.inf.br/nfe" versao="4.00">'	// Ticket 20210628010916 - XML Schneider - Eduardo Pereira Sigamat - 05.07.2021
			_cXml += SPED050->XML_SIG
			_cXml += cXmlProt		// Ticket 20210628010916 - XML Schneider - Eduardo Pereira Sigamat - 05.07.2021
			_cXml += '</nfeProc>'	// Ticket 20210628010916 - XML Schneider - Eduardo Pereira Sigamat - 05.07.2021

			MakeDir("\arquivos\xml_nfe\"+cEmpAnt)

			nHandle := FCreate("\arquivos\xml_nfe\"+cEmpAnt+"\"+_cChave+".xml")
			FWrite(nHandle,_cXml)
			FClose(nHandle)
			
			If !IsInCallStack("U_STFAT040")
			
				cDir 	:= GetMv("ST_FTPPRC1",,"\arquivos\xml_nfe\"+cEmpAnt+"\"+_cChave+".xml")
				cServer	:= GetMv("ST_FTPPRC2",,"200.171.223.154")
				cUser	:= GetMv("ST_FTPPRC3",,"renato.oliveira")
				cPass	:= GetMv("ST_FTPPRC4",,"steck@2020")
				cDirFtp	:= GetMv("ST_FTPPRC5",,"/portalcliente/notas/")
				nPorta	:= GetMv("ST_FTPPRC6",,10019)				
	
				FTPConnect( cServer, nPorta, cUser, cPass )
				//FTPGetCurDir()
				FTPDirChange(cDirFtp)
	
				If FTPUpLoad(cDir,cDirFtp+_cChave+".xml")
					Conout('UpLoad Ok! ')
				Else
					Conout('Falha UpLoad!')
				EndIf
			
			EndIf

			SPED050->(DBCloseArea())

		EndIf

	EndIf

Return()
