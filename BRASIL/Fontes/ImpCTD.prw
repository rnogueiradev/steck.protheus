#INCLUDE "RWMAKE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ IMPCTD   บAutor  ณErnani Forastieri   บ Data ณ  10/10/03   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Rotina para importacao de Ativo Fixo usando MSExecAuto a   บฑฑ
ฑฑบ          ณ a partir de arquivo texto com layout pre definido          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function ImpCTD()
	Local aSay    := {}
	Local aButton := {}
	Local nOpc    := 0
	Local cTitulo := ""
	Local cDesc1  := "Este rotina ira fazer a importacao do cadastros Itens Contabeis"
	Local cDesc2  := ""
	Private _cArquivo := ""
	Private cPerg := ""
	
	/*
	CriaSX1()
	Pergunte(cPerg, .F.)
	*/
	
	aAdd( aSay, cDesc1 )
	aAdd( aSay, cDesc2 )
	
	aAdd( aButton, { 5, .T., {|| _cArquivo := SelArq()   }} )
	aAdd( aButton, { 1, .T., {|| nOpc := 1, FechaBatch() }} )
	aAdd( aButton, { 2, .T., {|| FechaBatch()            }} )
	
	FormBatch( cTitulo, aSay, aButton )
	
	If nOpc <> 1
		Return Nil
	Endif
	
	Processa( {|lEnd| RunProc(@lEnd)}, "Aguarde...", "Executando rotina.", .T. )
	
Return Nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ RUNPROC  บAutor  ณErnani Forastieri   บ Data ณ  10/10/03   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Rotina de processamento                                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function RunProc(lEnd)
	
	Local _aDadCab  := {}
	Local _aDadItens := {}
	Local _aDadHist  := {}
	Local _aVetCpos:= {}
	Local _aVetHpos:= {}
	Local _aVetItens:= {}
	Local _nNumCposCab := 0
	Local _nNumCposItem := 0
	Local _nCt := 0
	Local _nNumHposItem := 0
	Local _cFileLog
	Local _cPath := "c:\import\"
	Local i, _nHdl
	Local _cBuffer := ""
	Local _nTamLin := 234 //  Tamanho  + chr(13) + chr(10)
	PRIVATE _aVetCab := {}
	
	If !File(_cArquivo)
		MSGBOX("Arquivo de importacao nao encontrado", "", "ERRO")
		Return NIL
	EndIF
	
	//				|	Campo	   |Tipo|Col.Ini |Tamanho |Dec|Importa ou nao } //	Descricao do Produto
	//aAdd( _aDadCab, { "A1_FILIAL","C", 01,		2,		0, .T. } ) // Filial
	aAdd( _aDadCab, { "CTD_ITEM",	"C", 01,		9,		0, .T. } ) // Codigo 					Obrigatorio
	aAdd( _aDadCab, { "CTD_CLASSE",	"C", 10,		1,		0, .T. } ) // Loja 						Obrigatorio
	aAdd( _aDadCab, { "CTD_DESC01",	"C", 11,		40,		0, .T. } ) // Fisica/Jurid.
	aAdd( _aDadCab, { "CTD_BLOQ",	"C", 51,		1,		0, .T. } ) // Nome						Obrigatorio
	aAdd( _aDadCab, { "CTD_CLOBRG",	"C", 62,		1,		0, .T. } ) // N Fantasia				Obrigatorio
	aAdd( _aDadCab, { "CTD_ACCLVL",	"C", 63,		1,		0, .T. } ) // Tipo - ex. F=Cons. Final 	Obrigatorio
	aAdd( _aDadCab, { "CTD_resto",	"C", 64,		169,		0, .T. } ) // Tipo - ex. F=Cons. Final 	Obrigatorio
	
	
	_nNumCposCab  := LEN(_aDadCab)
	
	AutoGrLog("----------------------------------------")
	AutoGrLog("INICIANDO O LOG - IMPORTACAO DE IT VALOR")
	AutoGrLog("----------------------------------------")
	AutoGrLog("ARQUIVO............: "+_cArquivo)
	AutoGrLog("DATABASE...........: "+Dtoc(dDataBase))
	AutoGrLog("DATA...............: "+Dtoc(MsDate()))
	AutoGrLog("HORA...............: "+Time())
	AutoGrLog("ENVIRONMENT........: "+GetEnvServer())
	AutoGrLog("PATCH..............: "+GetSrvProfString("Startpath", ""))
	AutoGrLog("ROOT...............: "+GetSrvProfString("SourcePath", ""))
	AutoGrLog("VERSรO.............: "+GetVersao())
	AutoGrLog("MำDULO.............: "+"SIGA"+cModulo)
	AutoGrLog("EMPRESA / FILIAL...: "+SM0->M0_CODIGO+"/"+SM0->M0_CODFIL)
	AutoGrLog("NOME EMPRESA.......: "+Capital(Trim(SM0->M0_NOME)))
	AutoGrLog("NOME FILIAL........: "+Capital(Trim(SM0->M0_FILIAL)))
	AutoGrLog("USUมRIO............: "+SubStr(cUsuario, 7, 15))
	AutoGrLog("-------------------------------------")
	AutoGrLog(" ")
	
	_nHdl := FOpen(_cArquivo, 0) //     FT_FUSE(_cArquivo)
	
	If _nHdl < 0
		ApMsgStop('Problemas na abertura do arquivo de importa็ใo', 'ATENวรO' )
		return NIL
	EndIf
	
	fSeek( _nHdl, 0, 0) //FT_FGOTOP()
	
	_nBtLidos := fRead( _nHdl, @_cBuffer, _nTamLin) //FT_FREADLN()
	
	While _nBtLidos >= _nTamLin //!FT_FEOF()
		_nCt++
		
		IncProc("Processando ...")
		
		_aVetCab := {}
		
		For i:=1 to _nNumCposCab
			
			If _aDadCab[i][6]    // T
				_xDado := SUBS(_cBuffer, _aDadCab[i][3], _aDadCab[i][4])
				
				
				If     _aDadCab[i][2] == "C"
					
					If ALLTRIM( _aDadCab[i][1] ) != "CTD_ITEM"
						
						_xDado := ALLTRIM(_xDado)
						
					Endif
					
				ElseIf _aDadCab[i][2] == "N"
					
					_xDado := VAL(_xDado)
					
				ElseIf _aDadCab[i][2] == "D"
					
					_xDado := CTOD(SUBS(_xDado, 1, 2)+"/"+SUBS(_xDado, 3, 2)+"/"+SUBS(_xDado, 5, 2))
					
				EndIf
				
				
				aAdd(_aVetCab, {_aDadCab[i][1], _xDado, NIL} )
				
			EndIf
			
		Next
		
		_aVetCpos := {}
		_aVetHpos := {}
		
		aAdd(_aVetItens, _aVetCpos)
		
		SX3->( dbSetOrder( 1 ) )
		
		lMsErroAuto := .F.
		U_GRAVACTD()
		//	MSExecAuto({|x, y| MATA030(x, y)}, _aVetCab, 3)
		
		If lMsErroAuto
			AutoGrLog(Str(_nCt, 5)+" "+SUBS(_cBuffer, 1, 50 )+" Nao gerado ")
			AutoGrLog(REPLICATE("=", 50))
			DisarmTransaction()
		Endif
		
		//    If ! lMsErroAuto
		//	Endif
		
		_nBtLidos := fRead( _nHdl, @_cBuffer, _nTamLin) //  _cBuffer := FT_FREADLN()
		
	EndDo
	
	_cFileLog := "CTD.LOG" //NomeAutoLog()
	
	If _cFileLog <> ""
		MostraErro(_cPath, _cFileLog)
	Endif
	
	FClose(_nHdl) //FT_FUSE()
	
	MsgInfo("Processo Finalizado")
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ SELARQ   บAutor  ณErnani Forastieri   บ Data ณ  10/10/03   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Rotina auxiliar para selecao do arquivo texto              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function SelArq()
	Private _cExtens   := "Arquivo Texto (*.TXT) |*.TXT|"
	_cRet := cGetFile(_cExtens, "Selecione o Arquivo", , , .T., GETF_NETWORKDRIVE+GETF_LOCALFLOPPY+GETF_LOCALHARD)
	_cRet := ALLTRIM(_cRet)
Return _cRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ GravaSA1 บAutor  ณErnani Forastieri   บ Data ณ  10/10/03   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Rotina auxiliar para selecao do arquivo texto              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function GravaCTD()
	
	
	DBSelectarea("CTD")
	Dbsetorder(1)
	
	
	IF !Dbseek(xFilial("CTD") + _aVetCab[1][2])
		
		RecLock("CTD", .T.)
		
		CTD->CTD_FILIAL	  := xFilial("CTD")									   		// Codigo 					Obrigatorio
		CTD->CTD_ITEM	  := _aVetCab[1][2] 										// Loja 						Obrigatorio
		CTD->CTD_CLASSE	  := _aVetCab[2][2] 										// Fisica/Jurid.
		CTD->CTD_DESC01	  := _aVetCab[3][2] 										// Nome						Obrigatorio
		CTD->CTD_BLOQ	  := _aVetCab[4][2] 										// N Fantasia				Obrigatorio
		CTD->CTD_DTEXIS	  := Ctod("01/01/1990") 										// N Fantasia				Obrigatorio
		CTD->CTD_ITLP     := _aVetCab[1][2] 										// Tipo - ex. F=Cons. Final 	Obrigatorio
		CTD->CTD_CLOBRG	  := _aVetCab[5][2] 										// Endereco 					Obrigatorio
		CTD->CTD_ACCLVL	  := _aVetCab[6][2] 										// Estado 					Obrigatorio
		CTD->(msUnlock())
		
		
		
	ENDIF
	
Return .t.
