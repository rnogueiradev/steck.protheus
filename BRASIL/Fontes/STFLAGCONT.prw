#Include 'Protheus.ch'
#Include 'RwMake.ch'
#Define CR	Chr(13) + Chr(10)

/*/{Protheus.doc} STFLAGCONT
(long_description)
@type  Static Function
@author GIOVANI.ZAGO
@since 05/09/2014
@version version
@param param_name, param_type, param_descr
@return return_var, return_type, return_description
@example
(examples)
@see (links_or_references)
/*/

User Function STFLAGCONT()  //    u_STFLAGCONT()

Local _aArea  		:= GetArea()
Local _cUser    	:= GetMv("ST_FLAGCON",,'000000')+'/000000'
Local aParamBox 	:= {}
Private aRet		:= {}
Private aVetor		:= {}
Private cPerg       := 'STFLAGCONT'
Private cTime       := Time()
Private cHora       := SUBSTR(cTime, 1, 2)
Private cMinutos    := SUBSTR(cTime, 4, 2)
Private cSegundos   := SUBSTR(cTime, 7, 2)
Private cAliasLif   := cPerg+cHora+ cMinutos+cSegundos
Private cAliasPed   := cPerg+cHora+ cMinutos+cSegundos
Private cAliasSal   := cPerg+cHora+ cMinutos+cSegundos
Private aSize    	:= MsAdvSize(.F.)
Private lMark   	:=  .F.
Private aSbfLoc		:= {}
Private lSaida  	:= .F.
Private aCpoEnch	:= {}
Private nOpcA		:= 0
Private oOk	   		:= LoadBitmap( GetResources(), "LBOK" )
Private oNo	   		:= LoadBitmap( GetResources(), "LBNO" )
Private oChk
Private lRetorno    := .F.
Private lChk	 	:= .F.
Private oLbx
Private oLbxz
Private lInverte 	:= .F.
Private nContLin 	:= 0
Private lLote    	:= .F.
Private oDlg
Private oDlgx
Private oList
Private _nQtd   	:= 0
Private  _nMeta 	:= 0
Private oVlrSelec
Private nVlrSelec 	:= 0
Private oMarcAll
Private lMarcAll    := .T.
Private oMarked	 	:= LoadBitmap(GetResources(),'LBOK')
Private oNoMarked	:= LoadBitmap(GetResources(),'LBNO')
Private oMeta
Private oPesc
Private aTam     	:= {}
Private cPesc    	:= ''
Private _cSerIbl 	:= Iif(cFilAnt == '01', '001', '001')
Private bFiltraBrw
Private AFILBRW    	:= {}
Private _cEndeStxx  := 'Endereços(SBF): '
Private _xCodTran   := GetMv("ST_TRANBRA",,'000012')
Private lAtualiz	:= .F.

aTam		:= TamSX3("F2_DOC")
cPesc  		:= Space(aTam[1])
cCondicao 	:= "F2_FILIAL == '" + xFilial("SF2") + "' "
aFilBrw		:=	{'SF2',cCondicao}

If __cUserId $ _cUser
	If MsgYesNo("Esta Rotina tem Por Finalidade Limpar as Flags Para Reprocessamento.....!!!!!" + CR + CR + "Deseja Continuar ?")
		aAdd(aParamBox,{2,"Tipo:",1, {' ',"1-Faturamento","2-Contas à Receber", "3-Contas à Pagar","4-Movitação Bancaria","5-Compras"}, 70,'.T.',.T.})
		aAdd(aParamBox,{1,"Data de:" ,dDatabase,"99/99/9999","","","",70,.F.})
		aAdd(aParamBox,{1,"Data Ate:",dDatabase,"99/99/9999","","","",70,.F.})
		If  ParamBox(aParamBox,"Parametros",@aRet,,,,,,,,.F.)
			If Valtype(aRet[1]) <> 'N' .And. aRet[1] <> ' '
				If aRet[3] >= aRet[2]
					Processa({|| STQUERY()},'Selecionando Registros')
					Processa({|| CompMemory()},'Compondo Retorno')
					If Len(aVetor) > 0
						MonTaSlec()    // monta a tela
					Else
						MsgInfo("Não Existe Notas Disponiveis !!!!!")
					EndIf
				Else
					MsgInfo("Data Incorreta....!!!!!")
				EndIf
			EndIf
		EndIf
	EndIf
Else
	MsgInfo("Usuario Não Autorizado....!!!!!")
EndIf

RestArea(_aArea)

Return

/*/{Protheus.doc} STQUERY
(long_description) Executa select mediante os parametros
@type  Static Function
@author GIOVANI.ZAGO
@since 13/03/2013
@version version
@param param_name, param_type, param_descr
@return return_var, return_type, return_description
@example
(examples)
@see (links_or_references)
/*/

Static Function STQUERY()

Local cQuery := ''

If Substr(aRet[1],1,1) == '1'
	cQuery := " SELECT
	cQuery += " F2_DOC
	cQuery += ' "DOC" ,
	cQuery += " 'SF2'
	cQuery += ' "TAB" ,
	cQuery += " SF2.R_E_C_N_O_
	cQuery += ' "REC" ,
	cQuery += " F2_SERIE
	cQuery += ' "SERIE"  ,
	cQuery += "  SUBSTR( F2_EMISSAO,7,2)||'/'|| SUBSTR( F2_EMISSAO,5,2)||'/'|| SUBSTR( F2_EMISSAO,1,4)
	cQuery += ' "EMISSAO"
	cQuery += "  FROM "+RetSqlName('SF2')+" SF2 "
	cQuery += "  WHERE SF2.F2_DTLANC <> ' ' "
	cQuery += "  	AND (SF2.F2_DUPL <> '         ' "
	cQuery += "  	OR SF2.F2_EST = 'EX' )    "
	cQuery += "  	AND SF2.D_E_L_E_T_ = ' ' "
	cQuery += "  	AND SF2.F2_EMISSAO BETWEEN '" + Dtos(aRet[2]) + "' AND '" + DtoS(aRet[3]) + "' "
ElseIf Substr(aRet[1],1,1) == '2'
	cQuery += "  	SELECT
	cQuery += "  SE1.E1_NUM
	cQuery += '  "DOC",
	cQuery += "  SE1.E1_PREFIXO
	cQuery += ' "SERIE"  ,
	cQuery += " 'SE1'
	cQuery += ' "TAB" ,
	cQuery += " SE1.R_E_C_N_O_
	cQuery += ' "REC" ,
	cQuery += "  SUBSTR( E1_EMISSAO,7,2)||'/'|| SUBSTR( E1_EMISSAO,5,2)||'/'|| SUBSTR( E1_EMISSAO,1,4)
	cQuery += ' "EMISSAO"
	cQuery += "  FROM "+RetSqlName('SE1')+" SE1 "
	cQuery += "  WHERE SE1.D_E_L_E_T_ = ' '
	cQuery += "  	AND SE1.E1_EMISSAO BETWEEN   '"+DtoS(aRet[2])+"' AND '"+DtoS(aRet[3])+"'
	cQuery += "  	AND SE1.E1_LA <> ' '
ElseIf Substr(aRet[1],1,1) == '3'
	cQuery += "  	SELECT
	cQuery += "  SE2.E2_NUM
	cQuery += '  "DOC",
	cQuery += "  SE2.E2_PREFIXO
	cQuery += ' "SERIE"  ,
	cQuery += " 'SE2'
	cQuery += ' "TAB" ,
	cQuery += " SE2.R_E_C_N_O_
	cQuery += ' "REC" ,
	cQuery += "  SUBSTR( E2_EMISSAO,7,2)||'/'|| SUBSTR( E2_EMISSAO,5,2)||'/'|| SUBSTR( E2_EMISSAO,1,4)
	cQuery += ' "EMISSAO"
	cQuery += "  FROM "+RetSqlName('SE2')+" SE2 "
	cQuery += "  WHERE SE2.D_E_L_E_T_ = ' '
	cQuery += "  	AND ( (SE2.E2_PREFIXO NOT IN ('CMA','CMI') AND SE2.E2_EMISSAO BETWEEN '"+DtoS(aRet[2])+"' AND '"+DtoS(aRet[3])+"') "
	cQuery += "  	OR (SE2.E2_PREFIXO IN ('CMA','CMI') AND SE2.E2_EMIS1 BETWEEN '"+DtoS(aRet[2])+"' AND '"+DtoS(aRet[3])+"') ) " //Chamado 003125 - Não estava vindo títulos CMA e CMI
	cQuery += "  	AND SE2.E2_LA <> ' '
ElseIf Substr(aRet[1],1,1) == '4'
	cQuery += "  SELECT
	cQuery += "  SE5.E5_NUMERO
	cQuery += '  "DOC",
	cQuery += "  SE5.E5_PREFIXO
	cQuery += ' "SERIE"  ,
	cQuery += " 'SE5'
	cQuery += ' "TAB" ,
	cQuery += " SE5.R_E_C_N_O_
	cQuery += ' "REC" ,
	cQuery += "  SUBSTR( E5_DATA,7,2)||'/'|| SUBSTR( E5_DATA,5,2)||'/'|| SUBSTR( E5_DATA,1,4)
	cQuery += ' "EMISSAO"
	cQuery += "  FROM "+RetSqlName('SE5')+" SE5 "
	cQuery += "  WHERE SE5.D_E_L_E_T_ = ' '
	cQuery += "  	AND SE5.E5_DATA  BETWEEN   '" + DtoS(aRet[2]) + "' AND '" + DtoS(aRet[3]) + "'
	cQuery += "  	AND SE5.E5_LA <> ' '

ElseIf Substr(aRet[1],1,1) == '5'
	cQuery := " SELECT
	cQuery += " F1_DOC
	cQuery += ' "DOC" ,
	cQuery += " 'SF1'
	cQuery += ' "TAB" ,
	cQuery += " SF1.R_E_C_N_O_
	cQuery += ' "REC" ,
	cQuery += " F1_SERIE
	cQuery += ' "SERIE"  ,
	cQuery += "  SUBSTR( F1_EMISSAO,7,2)||'/'|| SUBSTR( F1_EMISSAO,5,2)||'/'|| SUBSTR( F1_EMISSAO,1,4)
	cQuery += ' "EMISSAO"
	cQuery += "  FROM " + RetSqlName('SF1') + " SF1 "
	cQuery += "  WHERE SF1.F1_DTLANC <> ' '   "
		cQuery += "  	AND (SF1.F1_DUPL <> '         ' "
	cQuery += "  	OR SF1.F1_EST = 'EX' )    "
	cQuery += "  	AND SF1.D_E_L_E_T_ = ' ' "
	//cQuery += "  AND SF1.F1_EMISSAO BETWEEN '"+Dtos(aRet[2])+"' AND '"+Dtos(aRet[3])+"'
	cQuery += "  	AND SF1.F1_DTDIGIT BETWEEN '"+DtoS(aRet[2])+"' AND '" + DtoS(aRet[3]) + "' "//Chamado 003248 Para considerar as Notas que Foram lançadas dentro do mês
EndIf

cQuery := ChangeQuery(cQuery)

dbCommitAll()
If Select(cAliasLif) > 0
	(cAliasLif)->( dbCloseArea() )
EndIf

dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif,.T.,.T.)

Return

/*/{Protheus.doc} CompMemory
(long_description) Crio o aVetor
@type  Static Function
@author GIOVANI.ZAGO
@since 13/03/2013
@version version
@param param_name, param_type, param_descr
@return return_var, return_type, return_description
@example
(examples)
@see (links_or_references)
/*/

Static Function CompMemory()

dbSelectArea(cAliasLif)
(cAliasLif)->( dbGoTop() )
ProcRegua(RecCount()) // Numero de registros a processar

While (cAliasLif)->( !Eof() )
	_nQtd++
	_nMeta++
	IncProc()
	aAdd(aVetor ,{ .T. 			,; //01
	(cAliasLif)->DOC		 	,; //02   DOC
	(cAliasLif)->SERIE		 	,; //03   SERIE
	(cAliasLif)->EMISSAO		,; //04   EMISSAO
	(cAliasLif)->REC   ,;
	(cAliasLif)->TAB	})
	(cAliasLif)->( dbSkip() )
End

Return

/*/{Protheus.doc} MonTaSlec
(long_description) Crio o aVetor
@type  Static Function
@author GIOVANI.ZAGO
@since 13/03/2013
@version version
@param param_name, param_type, param_descr
@return return_var, return_type, return_description
@example
(examples)
@see (links_or_references)
/*/

Static Function MonTaSlec()

Local aButtons := {}	//{{"LBTIK",{|| PedStx()} ,"Gerar Etiqueta"}}

Do While !lSaida
	nOpcao := 0	
	Define MsDialog odlg title "Etiqueta" From 0,0 To aSize[6]-15,aSize[5]-15  PIXEL OF oMainWnd //from 178,181 to 590,1100 pixel
	cLinOk    		:= "AllwaysTrue()"
	cTudoOk   		:= "AllwaysTrue()"//'STxGRV()'
	aCpoEnchoice	:= {'NOUSER'}
	aAltEnchoice 	:= {}
	
	Private Altera := .T., Inclui := .T., lRefresh := .T., aTELA := Array(0,0), aGets := Array(0), bCampo := {|nCPO|Field(nCPO)}, nPosAnt := 9999, nColAnt := 9999
	Private cSavScrVT, cSavScrVP, cSavScrHT, cSavScrHP, CurLen, nPosAtu := 0
	
	@ 035,010 say "Quantidade( Notas ):"   Of odlg Pixel
	@ 035,080 msget  _nQtd picture "@E 999,999" when .f. size 55,013  Of odlg Pixel
	@ 055,010 say "Selecionados:"   Of odlg Pixel
	@ 055,080 msget  oVlrSelec Var _nMeta picture "@E 999,999" When .F. size 55,013 Of odlg Pixel
	@ 055,200 say "Pesquisar:"   Of odlg Pixel
	@ 055,240 msget  oPesc Var cPesc   when .T. size 35,013   Valid(fpesc(cPesc))	Of odlg Pixel
	
	//Cria a listbox
	@ 075,003 listbox oLbx fields header " ", "Doc.",'Serie',"Emissao",'Rec.','Tab','.'  size  aSize[3]-10,217 of oDlg pixel on dbLclick(Edlista(oLbx:nat,oVlrSelec))
	
	oLbx:SetArray( aVetor )
	oLbx:bLine := {|| {Iif(	aVetor[oLbx:nAt,1],oOk,oNo),;	// Marca e Desmarca
							aVetor[oLbx:nAt,2],;			// Numero do Documento
							aVetor[oLbx:nAt,3],;			// Serie
							aVetor[oLbx:nAt,4],;			// Emissao
							aVetor[oLbx:nAt,5],;			// Rec.
							aVetor[oLbx:nAt,6],;			// Tabela
							}}
	
	//	@ aSize[4]-28 ,005 CHECKBOX oChk VAR lChk PROMPT "Marca/Desmarca" SIZE 60,007 PIXEL OF oDlg on CLICK(aEval(aVetor,{|x| x[1]:=lChk}),fMarca(),oLbx:Refresh())
		
	ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg, {||nOpca := 1, lSaida := .T., oDlg:End()}	,{|| nOpca := 0, lSaida := .T., oDlg:End()},,aButtons)	
End

If nOpca == 1
	If MsgYesNo("Deseja Limpar as Flags Selecionadas ?")
		Processa({|| GeraPed()},'Limpando Flags .......')	
		FLAGMAIL('','',cUserName,DtoC(Date()),Time(),'')
	EndIf
ElseIf nOpca == 0
	MsgInfo("Operação Cancelada....!!!!")
EndIf

If lAtualiz
	MsgInfo("Operação Concluida com sucesso....!!!!")
EndIf

Return

/*/{Protheus.doc} PedStx
(long_description) Gera Etiquetas das Notas Fiscais
@type  Static Function
@author GIOVANI.ZAGO
@since 13/03/2013
@version version
@param param_name, param_type, param_descr
@return return_var, return_type, return_description
@example
(examples)
@see (links_or_references)
/*/

Static Function PedStx()

If MsgYesNo("Deseja Gerar Etiquetas das Notas Selecionadas ?")
	Processa({|| 	GeraPed()},'Gerando Etiqueta .......')
EndIf

STQUERY()

aVetor := {}
_nQtd  := 0
_nMeta := 0

Processa({|| 	CompMemory()},'Atualizando Notas.....')

oVlrSelec:Refresh()
oLbx:Refresh()
oDlg:Refresh()
oDlg:End()

Return

/*/{Protheus.doc} fMarca
(long_description) Marca ou Desmarca
@type  Static Function
@author GIOVANI.ZAGO
@since 13/03/2013
@version version
@param param_name, param_type, param_descr
@return return_var, return_type, return_description
@example
(examples)
@see (links_or_references)
/*/

Static Function fMarca()

Local b

_nMeta := 0

For b:= 1 to Len(aVetor)	
	If aVetor[oLbx:nAt,1]
		_nMeta++
	EndIf
Next b

oVlrSelec:Refresh()
oLbx:Refresh()
oDlg:Refresh()

Return .T.

/*/{Protheus.doc} fpesc
(long_description) 
@type  Static Function
@author GIOVANI.ZAGO
@since 13/03/2013
@version version
@param param_name, param_type, param_descr
@return return_var, return_type, return_description
@example
(examples)
@see (links_or_references)
/*/

Static Function fpesc(_cXPesc)

Local b
Local _lRex := .F.

If !(Empty(Alltrim(_cXPesc)))
	For b := 1 to Len(aVetor)
		If Upper(Alltrim(aVetor[b,2])) == Upper(Alltrim(_cXPesc))
			_lRex:= .T.
		EndIf
	Next b
Else
	_lRex:= .T.
EndIf

If _lRex .And. !(Empty(Alltrim(_cXPesc)))
	oLbx:nAt:= aScan(aVetor, {|x| Upper(AllTrim(x[2])) == Upper(Alltrim(_cXPesc))})
EndIf

oLbx:Refresh()
oDlg:Refresh()
opesc:Refresh()

Return _lRex

/*/{Protheus.doc} EdLista
(long_description) 
@type  Static Function
@author GIOVANI.ZAGO
@since 13/03/2013
@version version
@param param_name, param_type, param_descr
@return return_var, return_type, return_description
@example
(examples)
@see (links_or_references)
/*/

Static Function EdLista()

Local b

_nMeta := 0
aVetor[oLbx:nAt,1] := !aVetor[oLbx:nAt,1]

For b := 1 to Len(aVetor)
	If aVetor[b,1]
		_nMeta++
	EndIf
Next b

oVlrSelec:Refresh()
oLbx:Refresh()
oDlg:Refresh()

Return

/*/{Protheus.doc} GeraPed
(long_description) Limpas as Flags
@type  Static Function
@author GIOVANI.ZAGO
@since 13/03/2013
@version version
@param param_name, param_type, param_descr
@return return_var, return_type, return_description
@example
(examples)
@see (links_or_references)
/*/

Static Function GeraPed( )

Local b

For b := 1 To Len(aVetor)
	If aVetor[b,1]
		If aVetor[b,6] = 'SF2'
			dbSelectArea('SF2')
			dbGoTo(aVetor[b,5])
			If SF2->( Recno() ) == aVetor[b,5]
				SF2->( RecLock('SF2',.F.) )
				SF2->F2_DTLANC := CtoD('  /  /    ')
				SF2->( MsUnlock() )
				SF2->( dbCommit() )	
				lAtualiz := .T.			
			EndIf
		ElseIf aVetor[b,6] == 'SE1'
			dbSelectArea('SE1')
			dbGoTo(aVetor[b,5])
			If SE1->( Recno() ) == aVetor[b,5]
				SE1->( RecLock('SE1',.F.) )
				SE1->E1_LA := ' '
				SE1->( MsUnlock() )
				SE1->( dbCommit() )
				lAtualiz := .T.
			EndIf
		ElseIf aVetor[b,6] == 'SE2'
			dbSelectArea('SE2')
			dbGoTo(aVetor[b,5])
			If SE2->( Recno()) == aVetor[b,5]
				SE2->( RecLock('SE2',.F.) )
				SE2->E2_LA := ' '
				SE2->( MsUnlock() )
				SE2->( dbCommit() )
				lAtualiz := .T.
			EndIf
		ElseIf aVetor[b,6] == 'SE5'
			dbSelectArea('SE5')
			dbGoTo(aVetor[b,5])
			If SE5->( Recno() ) == aVetor[b,5]
				SE5->( RecLock('SE5',.F.) )
				SE5->E5_LA   := ' '
				SE5->E5_X_AG := ' '
				SE5->( MsUnlock() )
				SE5->( dbCommit() )
				lAtualiz := .T.
			EndIf
		ElseIf aVetor[b,6] == 'SF1'
			dbSelectArea('SF1')
			dbGoTo(aVetor[b,5])
			If SF1->( Recno()) == aVetor[b,5]
				SF1->( RecLock('SF1',.F.) )
				SF1->F1_DTLANC := CtoD('  /  /    ')
				SF1->( MsUnlock() )
				SF1->( dbCommit() )
				lAtualiz := .T.
			EndIf
		EndIf
	EndIf
Next b

Return

/*/{Protheus.doc} FLAGMAIL
(long_description) Monta o corpo do e-mail e chama a Função de envio
@type  Static Function
@author GIOVANI.ZAGO
@since 13/03/2013
@version version
@param param_name, param_type, param_descr
@return return_var, return_type, return_description
@example
(examples)
@see (links_or_references)
/*/

Static Function  FLAGMAIL(_cObs,_cMot,_cName,_cDat,_cHora,_cEmail)

Local aArea 	:= GetArea()
//Local _cFrom   	:= "protheus@steck.com.br"	//Lower(Alltrim(Posicione("SU7",1,xFilial("SU7")+SC5->C5_OPERADO,"U7_EMAIL")))
Local _cAssunto	:= "Limpeza de Flag: " + aRet[1]
Local cFuncSent	:= "FLAGMAIL"
Local _aMsg    	:= {}
Local cMsg     	:= ""
Local _nLin
Local _cCopia  	:= ''	
Local cAttach  	:= ''

_cEmail  := ""

If ( Type("l410Auto") == "U" .Or. !l410Auto )	
	aAdd( _aMsg , { "Data: "    , _cDat  } )
	aAdd( _aMsg , { "Usuario: " , _cName } )
	aAdd( _aMsg , { "Hora: "    , _cHora } )
	// Definicao do cabecalho do email
	cMsg := ""
	cMsg += '<html>'
	cMsg += '<head>'
	cMsg += '<title>' + _cAssunto + " - " + SM0->M0_NOME + "/" + SM0->M0_FILIAL + '</title>'
	cMsg += '</head>'
	cMsg += '<body>'
	//cMsg += '<Img Src="C:/AP5/SIGAADV/LGRL01.BMP"><BR>'
	cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
	cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
	cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>' + _cAssunto +" - " + SM0->M0_NOME + "/" + SM0->M0_FILIAL + '</FONT> </Caption>'
	// Definicao do texto/detalhe do email
	For _nLin := 1 to Len(_aMsg)
		If (_nLin/2) == Int( _nLin/2 )
			cMsg += '<TR BgColor=#B0E2FF>'
		Else
			cMsg += '<TR BgColor=#FFFFFF>'
		EndIf
		cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></B></TD>'
		cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></TD>'
		cMsg += '</TR>'
	Next
	For _nLin := 1 to Len(aVetor)
		If (_nLin/2) == Int( _nLin/2 )
			cMsg += '<TR BgColor=#B0E2FF>'
		Else
			cMsg += '<TR BgColor=#FFFFFF>'
		EndIf
		cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + aVetor[_nLin,2] + ' </Font></B></TD>'
		cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + aVetor[_nLin,3] + ' </Font></TD>'
		cMsg += '</TR>'
	Next
	// Definicao do rodape do email
	cMsg += '</Table>'
	cMsg += '<P>'
	cMsg += '<Table align="center">'
	cMsg += '<tr>'
	cMsg += '<td colspan="10" align="center"><font color="red" size="3">E-mail gerado em: ' + Dtoc(Date()) + '-' + Time() + '  - <font color="red" size="1">(' + cFuncSent + ')</td>'
	cMsg += '</tr>'
	cMsg += '</Table>'
	cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
	cMsg += '</body>'
	cMsg += '</html>'
	U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg, cAttach)  
EndIf

RestArea(aArea)

Return
