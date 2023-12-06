#Include "Protheus.ch"
#Include "Topconn.ch"
#Include "TbiConn.ch"
#Include "TbiCode.ch"
#Include "Rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTJOBRET  บAutor  ณEverson Santana 	 บ Data ณ  27/02/18  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Enviar WorkFlow so itens com retrabalho        			   บฑฑ
ฑฑบ          ณ 										                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Steck                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function STJOBRET()

	Local _cHtml  	:= ""
	Local _cQuery		:= ""
	Local _cTemp		:= ""
	Local _cCopia   	:= ""
	Local _cAssunto 	:= "Retrabalho X PA1 "
	Local cMsg	    	:= ""
	Local _aAttach  	:= {}
	Local _cCaminho 	:= ''
	Local _cEmail		:= ""
	Local _nX 			:= 0
	Local _nCont		:= 0
	Local _nLin
	Local cFuncSent		:= "STJOBRET" 

	Private _aRetab:={}
	AaDd(_aRetab,{"PEDIDO",'PRODUTO','ENDEREวO', 'QUANTIDADE' })

	RpcSetType(3)
	RpcSetEnv("01", "02",,'FAT')

	_cTemp  := GetNextAlias()
	_cQuery := " SELECT SBF.BF_LOCAL,SBF.BF_PRODUTO,SBF.BF_LOCALIZ,NVL(SUM(SBF.BF_QUANT),0) SALDO " + CHR(13) + CHR(10)
	_cQuery += " FROM 																" + CHR(13) + CHR(10)
	_cQuery += 		RetSqlName("SBF") + " SBF										" + CHR(13) + CHR(10)
	_cQuery += " WHERE SBF.BF_LOCAL = '10'	 				 						" + CHR(13) + CHR(10)
	_cQuery += " 	AND SBF.BF_QUANT > 0  											" + CHR(13) + CHR(10)
	_cQuery += " 	AND SBF.BF_FILIAL = '02' 										" + CHR(13) + CHR(10)
	_cQuery += " 	AND SBF.D_E_L_E_T_ = ' '  										" + CHR(13) + CHR(10)
	_cQuery += " GROUP BY SBF.BF_LOCAL,SBF.BF_PRODUTO,SBF.BF_LOCALIZ				" + CHR(13) + CHR(10)
	_cQuery += " ORDER BY SBF.BF_LOCALIZ											" + CHR(13) + CHR(10)
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cTemp,.T.,.T.)
	dbSelectArea(_cTemp)
	dbGotop()

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

	cMsg += '<TR BgColor=#B0E2FF>'
	cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">Armaz้m </Font></B></TD>'
	cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">Produto </Font></B></TD>'
	cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">Endere็o </Font></B></TD>'
	cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">Quantidade </Font></B></TD>'
	cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">PA1</Font></B></TD>'
	cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">Data Entrada </Font></B></TD>'

	While !Eof()

		cMsg += '<TR BgColor=#FFFFFF>'
		cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + (_cTemp)->BF_LOCAL + ' </Font></TD>'
		cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + (_cTemp)->BF_PRODUTO + ' </Font></TD>'
		cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + (_cTemp)->BF_LOCALIZ + ' </Font></TD>'
		cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + TransForm((_cTemp)->SALDO,"@E 99,999,999,999.99") + ' </Font></TD>'
		cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + VerPa1((_cTemp)->BF_PRODUTO,"02") + ' </Font></TD>'
		cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + VerDtEnt("02",(_cTemp)->BF_LOCAL,(_cTemp)->BF_LOCALIZ ,(_cTemp)->BF_PRODUTO) + ' </Font></TD>'

		dbSelectArea(_cTemp)
		dbSkip()
	End

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

	dbSelectArea(_cTemp)
	(_cTemp)->(dbCloseArea())

	_cEmail		:= GetMv("ST_STJOBRE",,"everson.santana@steck.com.br")

	If !U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,_cCaminho)
		VtAlert("Problemas no envio de email!")
	EndIf

	RpcClearEnv()

Return

/*

cVar(Filial )
cVar1(Local)
cVar2(Localiza็ใo)
cVar3(Produto) 
*/

Static Function VerDtEnt(cVar,cVar1,cVar2,cVar3)

	Local _cQuery1		:= ""
	Local _cTemp1		:= ""
	Local _dRet			
	
	_cTemp1  	:= GetNextAlias()
	_cQuery1	:= " SELECT MAX(SDB.DB_DATA) DTENT  FROM "+RetSqlName("SDB")+" SDB "+ CHR(13) + CHR(10)
	_cQuery1	+= "         WHERE SDB.DB_FILIAL = '"+cVar+"'	"+ CHR(13) + CHR(10)
	_cQuery1	+= "         AND DB_LOCAL = '"+cVar1+"'	        "+ CHR(13) + CHR(10)
	_cQuery1	+= "          AND DB_LOCALIZ = '"+cVar2+"'		"+ CHR(13) + CHR(10)
	_cQuery1	+= "         AND DB_PRODUTO = '"+cVar3+"'		"+ CHR(13) + CHR(10)
	_cQuery1	+= "         AND SDB.D_E_L_E_T_ = ' ' 			"+ CHR(13) + CHR(10)

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cTemp1,.T.,.T.)
			
	_dRet := Dtoc(stod((_cTemp1)->DTENT))
	
Return(_dRet)


/*

cVar(Produto )
cVar1(Filial)
*/

Static Function VerPa1(cVar,cVar1)

	Local _cQuery2		:= ""
	Local _cTemp2		:= ""
	Local _nRet			:= 0			
	
	_cTemp2  	:= GetNextAlias()
	_cQuery2	:= " SELECT SUM(PA1_QUANT) PA1  FROM "+RetSqlName("PA1")+" PA1 	"+ CHR(13) + CHR(10)
	_cQuery2	+= "         WHERE PA1.PA1_FILIAL = '"+cVar1+"'					"+ CHR(13) + CHR(10)
	_cQuery2	+= "         AND PA1.PA1_CODPRO = '"+cVar+"'					"+ CHR(13) + CHR(10)
	_cQuery2	+= "    	 AND PA1.PA1_TIPO = '1'								"+ CHR(13) + CHR(10)
	_cQuery2	+= "         AND PA1.D_E_L_E_T_ = ' ' 							"+ CHR(13) + CHR(10)

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery2),_cTemp2,.T.,.T.)
			
	_nRet := TransForm((_cTemp2)->PA1 ,"@E 99,999,999,999.99")
	
Return(_nRet)

