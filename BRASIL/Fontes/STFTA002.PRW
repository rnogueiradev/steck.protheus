
#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTFTA002  บAutor  ณFlexProjects        บ Data ณ  21/02/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function STFTA002
	
	IF !EMPTY(SCJ->CJ_XUNICOM)
		IF SCJ->CJ_STATUS<>"A"
			MsgStop("Este Processo nao esta completo !!! impossivel encerrar !!! ")
		Else
			IF 	a415Visual("SCJ",SCJ->(RecNo()),2) .AND. MsgYesno("Confirma Liberacao de Orcamento para Vendas")
				
				_nTotGeral := 0
				Dbselectarea('SCK')
				SCK->(dbsetorder(1))
				Dbseek(xfilial("SCK") + SCJ->CJ_NUM )
				Do while !eof() .and. SCJ->CJ_NUM == SCK->CK_NUM
					_nTotGeral +=SCK->CK_VALOR
					Dbskip()
					
				Enddo
				
				_nTotGeral +=SCJ->CJ_XVLRMOD
				_nTotGeral += (_nTotGeral*(SCJ->CJ_XMARGEM/100))
				
				Dbselectarea('PP8')
				PP8->(dbsetorder(1))
				if Dbseek(xfilial("PP8") + SCJ->CJ_XUNICOM )
					RecLock("PP8",.F.)
					PP8->PP8_PRORC   := _nTotGeral
					PP8->PP8_REVDES  := SCJ->CJ_XREVISA
					PP8->PP8_PRCOM   := _nTotGeral
					PP8->PP8_HIST 	 := PP8->PP8_HIST +  "ORCAMENTO CONCLUIDO EM: " + DTOC(DDATABASE) + "-" + TIME() + " POR: "+ cUserName + chr(13) + chr(10)+REPLICATE("-",80) + chr(13) + chr(10)
					PP8->PP8_STATUS  := "O"
					PP8->PP8_DTORC   := DDATABASE
					PP8->PP8_USORC   := CUSERNAME
					MSUNLOCK()
				Endif
				
				_ltodos := .t.
				
				Dbselectarea('PP8')
				PP8->(dbsetorder(1))
				Dbseek(xfilial("PP8") + SUBSTR(SCJ->CJ_XUNICOM,1,6) )
				Do While !eof() .and. SUBSTR(SCJ->CJ_XUNICOM,1,6)  ==  PP8_CODIGO
					if PP8_STATUS <> 'O' .OR. PP8_PRCOM == 0
						_ltodos := .f.
					endif
					Dbskip()
				Enddo
				
				if _lTodos
					
					_ml_fimorc()
					
				endif
				
			Endif
		Endif
	Else
		MsgStop("Este Processo nao pertence a Unicom !!! Opcao invalida !!! ")
	Endif
	
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTFTA002  บAutor  ณMicrosiga           บ Data ณ  08/09/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static function _ml_fimorc
	
	
	Local aArea 	:= GetArea()
	Local _cFrom   := "protheus@steck.com.br"//Lower(Alltrim(Posicione("SU7",1,xFilial("SU7")+SC5->C5_OPERADO,"U7_EMAIL")))
	Local _cAssunto:= "Liberacao Unicom para Orcamento"
	Local cFuncSent:= "StLibFinMail"
	Local _aMsg    :={}
	Local i        := 0
	Local cArq     := ""
	Local cMsg     := ""
	Local _nLin
	
	Local _cEmail  := supergetmv("ST_UNCVDAS",," ")+";"+Alltrim(Posicione("SA3",1,xFilial("SA3")+SCJ->CJ_XVEND  ,"A3_EMAIL"))
	
	Aadd( _aMsg , { "UNICOM Num: "      , SUBSTR(SCJ->CJ_XUNICOM,1,6) } )
	Aadd( _aMsg , { "Ocorrencia: "    	, "Conclusao de Orcamento"  } )
	Aadd( _aMsg , { "Data: "    		, dtoc(dDataBase) } )
	Aadd( _aMsg , { "Hora: "    		, time() } )
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Definicao do cabecalho do email                                             ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cMsg := ""
	cMsg += '<html>'
	cMsg += '<head>'
	cMsg += '<title> Unicom' +SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title>'
	cMsg += '</head>'
	cMsg += '<body>'
	//cMsg += '<Img Src="C:/AP5/SIGAADV/LGRL01.BMP"><BR>'
	cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
	cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
	cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>' + _cAssunto +" - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+ '</FONT> </Caption>'
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Definicao do texto/detalhe do email                                         ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	For _nLin := 1 to Len(_aMsg)
		IF (_nLin/2) == Int( _nLin/2 )
			cMsg += '<TR BgColor=#B0E2FF>'
		Else
			cMsg += '<TR BgColor=#FFFFFF>'
		EndIF
		cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></B></TD>'
		cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></TD>'
		cMsg += '</TR>'
	Next
	cMsg += '<tr>'
	
	cMsg += '</tr>'
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Definicao do rodape do email                                                ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cMsg += '</Table>'
	cMsg += '<P>'
	cMsg += '<Table align="center">'
	cMsg += '<tr>'
	cMsg += '<td colspan="10" align="center"><font color="red" size="3">E-mail gerado em: '+ Dtoc(date())+'-'+ Time()+'  - <font color="red" size="1">(UNICOM)</td>'
	cMsg += '</tr>'
	cMsg += '</Table>'
	cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
	cMsg += '</body>'
	cMsg += '</html>'
	
	
	U_STMAILTES(_cEmail, "", _cAssunto, cMsg , "")
	
Return




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTFTA002  บAutor  ณMicrosiga           บ Data ณ  10/09/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

USER FUNCTION STFTA02B
	
	//SCJ->CJ_XUNICOM
	
	Local aPosObj   := {}
	Local aPosGet	:= {}
	Local aObjects  := {}
	Local aSize     := {}
	Local aArea     := GetArea()
	Local aTitles   := { }
	Local aMessage  := {}
	Local aHelp     := {}
	Local aFolder	:= {}
	Local aColsProd	:= {}
	Local aButtons  := {}
	Local aSize    := MsAdvSize()
	Local aObjects := {{  60, 100, .T., .T. }, { 100, 100, .T., .T. }  }
	
	Local aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
	Local aPosObj := MsObjSize( aInfo, aObjects )
	
	Local aPosGet := MsObjGetPos(aSize[3]-aSize[1],315,{{265,283}} )
	Local nGetLin := aPosObj[2,1] + 200
	Local _nfator := 25
	Local oOk		:= LoadBitmap( GetResources(), "CHECKED" )   //CHECKED    //LBOK  //LBTIK
	Local oNo		:= LoadBitmap( GetResources(), "UNCHECKED" ) //UNCHECKED  //LBNO
	Local  nSE5 := 0
	Local __ncount := 0
	Local bWhile    := {|| .T. }
	
	cCadastro := "Liberacao de Vendas "
	
	_cUnicom := SUBSTR(SCJ->CJ_XUNICOM,1,6)
	
	cQuery := ""
	cQuery += " SELECT  *     "
	cQuery += " FROM " + RetSqlName("SCJ")+" SCJ  "
	cQuery += " WHERE SCJ.CJ_FILIAL = '" + xFilial("SCJ") + "' "
	cQuery += " AND SUBSTR(SCJ.CJ_XUNICOM,1,6) = '" +  _cUnicom + "' "
	cQuery += " AND (SCJ.CJ_STATUS = 'A' or SCJ.CJ_STATUS = 'D') "
	cQuery += " AND SCJ.D_E_L_E_T_ = ' ' "
	cQuery := ChangeQuery(cQuery)
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRB",.T.,.T.)
	
	aStruPP7:= SCJ->(dbStruct())
	
	For nSE5 := 1 To Len(aStruPP7)
		If aStruPP7[nSE5][2] <> "C" .and.  FieldPos(aStruPP7[nSE5][1]) > 0
			TcSetField("TRB",aStruPP7[nSE5][1],aStruPP7[nSE5][2],aStruPP7[nSE5][3],aStruPP7[nSE5][4])
		EndIf
	Next nSE5
	
	aitens := {}
	Do While !eof()
		Dbselectarea('PP8')
		PP8->(dbsetorder(1))
		Dbseek(xfilial("PP8") + TRB->CJ_XUNICOM )
		
		Dbselectarea("TRB")
		
		// IF PP8->PP8_STATUS <> "O"
		
		aadd(aitens,{" ",CJ_NUM , CJ_XDSCUNC  })
		
		//ENDIF
		
		DbSkip()
		
	Enddo
	
	Dbselectarea("TRB")
	DbClosearea("TRB")
	
	if len(aitens) == 0
		MsgStop("Nao existem itens a serem Liberados para vendas !!!")
		Return
	Endif
	
	nOpcA := 0
	
	DEFINE MSDIALOG oDlg2 TITLE cCadastro From aSize[7],00 To aSize[6] , aSize[5] OF oMainWnd PIXEL
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Define as posicoes da Getdados a partir do folder    ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	nGd1 	:= 2
	nGd2 	:= 2
	nGd3 	:= aSize[3]-50  //aPosObj[2,3]*2//-aPosObj[2,2] // aPosObj[2,3]-aPosObj[2,1]-15
	nGd4 	:= aSize[4]  //aPosObj[2,4]-100 //aPosObj[2,4]-aPosObj[2,2]-4
	
	_atit_cab1:= 	{"","Item","Descricao" }
	
	oListBox2 := TWBrowse():New( aPosObj[1,1],aPosObj[2,2]+_nfator,nGd3,nGd4                              ,,_atit_cab1, ,oDlg2,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )
	
	oListBox2:AddColumn(TCColumn():New( " "  		   	    ,{|| iif(aItens[ oListBox2:nAt, 01 ] ='X',oOk,oNo)  }, "@c",nil,nil,nil,010,.T.,.T.,nil,nil,nil,.T.,nil))
	oListBox2:AddColumn(TCColumn():New( "Orcamento"  			,{|| aItens[ oListBox2:nAt, 02 ] },,,			,'LEFT',,.F.,.F.,,,,.F.,))
	oListBox2:AddColumn(TCColumn():New( "Descricao"  		,{|| aItens[ oListBox2:nAt, 03 ] },,,			,'LEFT',,.F.,.F.,,,,.F.,))
	
	oListBox2:SetArray(aitens)
	oListBox2:bLine 		:= {|| {	if(aItens[ oListBox2:nAt, 01 ] = 'X',oOk,oNo), aItens[ oListBox2:nAT, 02 ], aItens[ oListBox2:nAT, 03 ]   } }
	oListBox2:blDblClick 	:= {||  aItens[ oListBox2:nAt, 01 ] := if(aItens[ oListBox2:nAt, 01 ] = 'X',' ','X') ,oListBox2:refresh() }
	
	@ 030,2 BTNBMP oBtn1 RESOURCE "SELECTALL" 		SIZE 40,40 ACTION _mAll(1,aItens)  MESSAGE "Marca Todos "
	@ 065,2 BTNBMP oBtn2 RESOURCE "UNSELECTALL" 	SIZE 40,40 ACTION _mAll(2,aItens)  MESSAGE "Desmarca Todos "
	
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Ao confirmar, simula a mudanca de folder para atualizar os arrays necessarios ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	ACTIVATE MSDIALOG oDlg2 ON INIT EnchoiceBar(oDlg2, {||nOpcA := 1 ,oDlg2:End()} ,{||oDlg2:End()},, )
	
	If  nOpcA == 1
		
		For __ncount := 1 to len(aitens)
			
			if aItens[__ncount , 01 ] = 'X'
				
				Dbselectarea('SCJ')
				SCJ->(dbsetorder(1))
				if Dbseek(xfilial("SCJ") +aItens[__ncount , 02 ] )
					RecLock("SCJ",.F.)
					CJ_STATUS = 'X'
					Msunlock()
				Endif
				_nTotGeral := 0
				
				Dbselectarea('SCK')
				SCK->(dbsetorder(1))
				if Dbseek(xfilial("SCK") + SCJ->CJ_NUM )
					Do while !eof() .and. SCJ->CJ_NUM == SCK->CK_NUM
						_nTotGeral +=SCK->CK_VALOR
						Dbskip()
						
					Enddo
				Endif
				_nTotGeral +=SCJ->CJ_XVLRMOD
				_nTotGeral += (_nTotGeral*(SCJ->CJ_XMARGEM/100))
				
				Dbselectarea('PP8')
				PP8->(dbsetorder(1))
				if Dbseek(xfilial("PP8") + SCJ->CJ_XUNICOM )
					RecLock("PP8",.F.)
					PP8->PP8_PRORC   := _nTotGeral
					PP8->PP8_REVDES  := SCJ->CJ_XREVISA
					PP8->PP8_PRCOM   := _nTotGeral
					PP8->PP8_HIST 	 := PP8->PP8_HIST +  "ORCAMENTO CONCLUIDO EM: " + DTOC(DDATABASE) + "-" + TIME() + " POR: "+ cUserName + chr(13) + chr(10)+REPLICATE("-",80) + chr(13) + chr(10)
					PP8->PP8_STATUS  := "O"
					PP8->PP8_DTORC   := DDATABASE
					PP8->PP8_USORC   := CUSERNAME
					PP8->PP8_NTORC   := SCJ->CJ_OBSORC
					MSUNLOCK()
					
					Dbselectarea('PP7')
					PP7->(dbsetorder(1))
					if dbseek(xfilial("PP7")+PP8->PP8_CODIGO)
						RecLock("PP7",.F.)
						
						PP7->PP7_STATUS  := "5"
						PP7->PP7_TRAVA   := ' '
						MSUNLOCK()
					Endif
				Endif
				
			Endif
		Next __ncount
		
	Endif
	
	
	
	_ltodos := .t.
	/*
	Dbselectarea('PP8')
	PP8->(dbsetorder(1))
	Dbseek(xfilial("PP8") + _cUnicom )
	Do While !eof() .and. _cUnicom  ==  PP8_CODIGO
		if PP8_STATUS <> 'O' .OR. PP8_PRCOM == 0
			_ltodos := .f.
		endif
		Dbskip()
	Enddo
	*/
	if _lTodos
		
		_ml_fimorc()
		
	endif
	
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ_mAll     บAutor  ณ RVG Solcuoes       บ Data ณ  06/06/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function _mAll(_nTipo,aItens)
	
	Local _nCount
	For _nCount  := 1 to len(aitens)
		aItens[_nCount,1] := iif(_nTipo = 1,'X',' ')
	Next _nCount
	
	oListBox2:refresh()
	
Return


