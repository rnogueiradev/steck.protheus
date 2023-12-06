#INCLUDE "PROTHEUS.CH"
#INCLUDE "FILEIO.CH"
#INCLUDE "APWEBSRV.CH"
#include 'RwMake.ch'
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
#Define CR chr(13)+chr(10)
#DEFINE Cr chr(13)+chr(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTRHWF	บAutor  ณGiovani Zago     บ Data ณ  02/08/17      บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณWF RH														  บฑฑ
ฑฑบ          ณ   													      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametro ณ Nenhum                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑบRetorno   ณ Nenhum                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function STRHWF01( )
	
	
	Local cAliasSuper:= 'STRHWF01'
	Local cQuery     := ' '
	Local _aMsg 	 := {}
	Local _cDat      := ' '
	
	RpcSetType( 3 )
	RpcSetEnv("01","02",,,"FAT")
	
	_cDat:= Tira1(SUBSTR(dTOs(DATE()),1,6))
	
	If SubStr(_cDat,5,2)= '01'
		_cDat:= Tira1(SUBSTR(dTOs(DATE()),1,4))+'12'
	EndIf
	
	cQuery := "  SELECT
	cQuery += "  'SP'
	cQuery += '  "EMPRESA",
	cQuery += "  AT_NAME
	cQuery += '  "USUARIO",
	cQuery += "  AT_TIME
	cQuery += '  "HORA",
	cQuery += "   SUBSTR(AT_DATE,7,2)||'/'|| SUBSTR(AT_DATE,5,2)||'/'|| SUBSTR(AT_DATE,1,4)  
	cQuery += '  "DATA",
	cQuery += "  AT_TABLE
	cQuery += '  "TABELA",
	cQuery += "  AT_FIELD
	cQuery += '  "CAMPO",
	cQuery += "  AT_CONTENT
	cQuery += '  "DE",
	cQuery += "  AT_NEWCONT
	cQuery += '  "xPARA",
	cQuery += "  RA_FILIAL
	cQuery += '  "FILIAL",
	cQuery += "  RA_MAT
	cQuery += '  "MATRICULA",
	cQuery += "  RA_NOME
	cQuery += '  "FUNCIONARIO"
	cQuery += "  FROM VWAUDIT_TRAIL@ODBADT
	cQuery += "  INNER JOIN(SELECT * FROM SRA010)SRA
	cQuery += "  ON SRA.D_E_L_E_T_ = ' '
	cQuery += "  AND SRA.R_E_C_N_O_ = AT_RECID
	cQuery += "  WHERE    AT_TABLE LIKE 'SRA010%'
	cQuery += "  AND AT_FIELD LIKE 'RA_SALARIO%'
	cQuery += "  AND SUBSTR(AT_date,1,6)  = '"+_cDat+"'
	//cQuery += "  AND SUBSTR(AT_date,1,6)  > '201705'
	cQuery += "  UNION
	cQuery += "  SELECT
	cQuery += "  'AM'
	cQuery += '  "EMPRESA",
	cQuery += "  AT_NAME
	cQuery += '  "USUARIO",
	cQuery += "  AT_TIME
	cQuery += '  "HORA",
	cQuery += "    SUBSTR(AT_DATE,7,2)||'/'|| SUBSTR(AT_DATE,5,2)||'/'|| SUBSTR(AT_DATE,1,4)  
	cQuery += '  "DATA",
	cQuery += "  AT_TABLE
	cQuery += '  "TABELA",
	cQuery += "  AT_FIELD
	cQuery += '  "CAMPO",
	cQuery += "  AT_CONTENT
	cQuery += '  "DE",
	cQuery += "  AT_NEWCONT
	cQuery += '  "xPARA",
	cQuery += "  RA_FILIAL
	cQuery += '  "FILIAL",
	cQuery += "  RA_MAT
	cQuery += '  "MATRICULA",
	cQuery += "  RA_NOME
	cQuery += '  "FUNCIONARIO"
	cQuery += "  FROM VWAUDIT_TRAIL@ODBADT
	cQuery += "  INNER JOIN(SELECT * FROM SRA030)SRA
	cQuery += "  ON SRA.D_E_L_E_T_ = ' '
	cQuery += "  AND SRA.R_E_C_N_O_ = AT_RECID
	cQuery += "  WHERE    AT_TABLE LIKE 'SRA030%'
	cQuery += "  AND AT_FIELD LIKE 'RA_SALARIO%'
	cQuery += "  AND SUBSTR(AT_date,1,6)  = '"+_cDat+"'
	//cQuery += "  AND SUBSTR(AT_date,1,6)  > '201705'
	
	cQuery := ChangeQuery(cQuery)
	
	If Select(cAliasSuper) > 0
		(cAliasSuper)->(dbCloseArea())
	EndIf
	
	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasSuper)
	
	
	
	dbSelectArea(cAliasSuper)
	(cAliasSuper)->(dbgotop())
	If  Select(cAliasSuper) > 0
		aadd(_aMsg,{"EMPRESA","USUARIO","HORA","DATA","TABELA","CAMPO","DE","PARA","FILIAL","MATRICULA","FUNCIONARIO"}  )
		
		While 	(cAliasSuper)->(!Eof())
			
			aadd(_aMsg,{(cAliasSuper)->EMPRESA,(cAliasSuper)->USUARIO,(cAliasSuper)->HORA,(cAliasSuper)->DATA,(cAliasSuper)->TABELA,(cAliasSuper)->CAMPO,   Transform(Val((cAliasSuper)->DE),"@E 999,999,999.99")  , Transform(Val((cAliasSuper)->xPARA),"@E 999,999,999.99") ,(cAliasSuper)->FILIAL,(cAliasSuper)->MATRICULA,(cAliasSuper)->FUNCIONARIO}  )
			
			(cAliasSuper)->(dbskip())
			
		End
	EndIf
	
	If Len(_aMsg) > 1
		STWFRH(_aMsg)
	EndIf
	
	
	Reset Environment
Return()


*------------------------------------------------------------------*
Static Function STWFRH(_aMsg)
	*------------------------------------------------------------------*
	
	Local aArea 	:= GetArea()
	Local _cFrom   := "protheus@steck.com.br"
	Local _cAssunto:= 'Log. de Altera็ใo RH-Salario'
	Local cFuncSent:= "STWFRH"
	//Local _aMsg    :={}
	Local i        := 0
	Local cArq     := ""
	Local cMsg     := ""
	Local _nLin
	Local _cCopia  :=''
	Local cAttach  := ' '
	Local _cEmaSup := ' '
	Local _nCam    := 0
	Local _cEmail  :=  "  karina.callegari@steck.com.br  "
	
	Dbselectarea('SB1')
	SB1->(dbsetorder(1))
	
	If ( Type("l410Auto") == "U" .OR. !l410Auto )
		
		
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Definicao do cabecalho do email                                             ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		cMsg := ""
		cMsg += '<html>'
		cMsg += '<head>'
		cMsg += '<title>' + _cAssunto + " - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title>'
		cMsg += '</head>'
		cMsg += '<body>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
		cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>' + _cAssunto +" - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+ '</FONT> </Caption>'
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Definicao do texto/detalhe do email                                         ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		For _nLin := 1 to Len(_aMsg)
			If (_nLin/2) == Int( _nLin/2 )
				cMsg += '<TR BgColor=#B0E2FF>'
			Else
				cMsg += '<TR BgColor=#FFFFFF>'
			EndIf
			If _nLin = 1
				
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,3] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,4] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,5] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,6] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,7] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,8] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,9] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,10] + ' </Font></B></TD>'
				cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,11] + ' </Font></B></TD>'
				
				
			Else
				
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,3] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,4] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,5] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,6] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,7] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,8] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,9] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,10] + ' </Font></TD>'
				cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,11] + ' </Font></TD>'
			EndIf
			
		Next
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Definicao do rodape do email                                                ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		cMsg += '</Table>'
		cMsg += '<P>'
		cMsg += '<Table align="center">'
		cMsg += '<tr>'
		cMsg += '<td colspan="10" align="center"><font color="red" size="3">E-mail gerado em: '+ Dtoc(date())+'-'+ Time()+'  - <font color="red" size="1">('+cFuncSent+')</td>'
		cMsg += '</tr>'
		cMsg += '</Table>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		cMsg += '</body>'
		cMsg += '</html>'
		
		
		U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg)
		
		
	EndIf
	RestArea(aArea)
Return()




