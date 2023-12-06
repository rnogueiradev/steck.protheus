#INCLUDE "RWMAKE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ IMPSG1   บAutor  ณErnani Forastieri   บ Data ณ  10/10/03   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Rotina para importacao de ESTRUTURAS DE PRODUTOS       a   บฑฑ
ฑฑบ          ณ a partir de arquivo texto com layout pre definido          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function ImpSG1()
Local aSay    := {}
Local aButton := {}
Local nOpc    := 0
Local cTitulo := ""
Local cDesc1  := "Este rotina ira fazer a importacao do cadastros de Estruturas"
Local cDesc2  := ""
Private _cArquivo := ""
Private cPerg := ""   
Private cPai := ""   
Private cComp := ""   

/*
CriaSX1()
Pergunte(cPerg, .F.)
*/

aAdd( aSay, cDesc1 )
aAdd( aSay, cDesc2 )

aAdd( aButton, { 5, .T., {|| _cArquivo := SelArq()    }} )
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
Local _aVetCab := {}
Local _aVetCpos:= {}
Local _aVetHpos:= {}
Local _aVetItens:= {}
Local _nNumCposCab := 0
Local _nNumCposItem := 0
Local _nCt := 0
Local _nNumHposItem := 0
LOCAL _cFileLog
Local _cPath := ""
Local i, _nHdl
Local _cBuffer := ""
Local _nTamLin := 234 //  Tamanho  + chr(13) + chr(10)

If !File(_cArquivo)
	MSGBOX("Arquivo de importacao nao encontrado", "", "ERRO")
	Return NIL
EndIF

//				|	Campo	   |Tipo|Col.Ini |Tamanho |Dec|Importa ou nao } //	Descricao do Produto
aAdd( _aDadCab, { "G1_FILIAL",	"C", 01,		2,		0, .T. } ) // Filial 					Obrigatorio //1
aAdd( _aDadCab, { "G1_COD",		"C", 03,		15,		0, .T. } ) // PRODUTO PAI 				Obrigatorio //2
aAdd( _aDadCab, { "G1_COMP",	"C", 18,		15,		0, .T. } ) // PRODUTO COMPONENTE		Obrigatorio //3
aAdd( _aDadCab, { "G1_TRT",		"C", 33,		03,		0, .T. } ) // SEQUENCIA                            //4
aAdd( _aDadCab, { "G1_QUANT",	"N", 36,		08,		6, .T. } ) // QUANTIDADE				Obrigatorio //5
aAdd( _aDadCab, { "G1_INI",		"D", 45,		08,		0, .T. } ) // DT INICIAL COMPONENTE 	Obrigatorio //6
aAdd( _aDadCab, { "G1_FIM",		"D", 53,		08,		0, .T. } ) // DT FINAL COMPONENTE		Obrigatorio //7
//aAdd( _aDadCab, { "G1_REVIS",	"N", 61,		01,		0, .T. } ) // FIXA = V                             //8
aAdd( _aDadCab, { "G1_OPC",		"C", 61,		03,		0, .T. } ) //                                      //9

//01S1006          3540222604     0011        01012010311220500
_nNumCposCab  := LEN(_aDadCab)

AutoGrLog("-------------------------------------")
AutoGrLog("INICIANDO O LOG - IMPORTACAO DE CLIENTES")
AutoGrLog("-------------------------------------")
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

_nHdl := FOpen(_cArquivo, 0)

If _nHdl < 0
	ApMsgStop('Problemas na abertura do arquivo de importa็ใo', 'ATENวรO' )
	return NIL
EndIf

fSeek( _nHdl, 0, 0)

_nBtLidos := fRead( _nHdl, @_cBuffer, _nTamLin) //FT_FREADLN()

FT_FUSE(_cArquivo)
FT_FGOTOP()
ProcRegua(FT_FLASTREC())

While _nBtLidos >= _nTamLin //!FT_FEOF()
	_nCt++
	
	IncProc("Processando ...")
	
	_aVetCab := {}
	
	For i:=1 to _nNumCposCab
		
		If _aDadCab[i][6]    // T
			_xDado := SUBS(_cBuffer, _aDadCab[i][3], _aDadCab[i][4])
			
			If     _aDadCab[i][2] == "C"
				
				_xDado := _xDado
				
			ElseIf _aDadCab[i][2] == "N"
				
				_xDado := VAL(_xDado)
				
			ElseIf _aDadCab[i][2] == "D"
				
				_xDado := CTOD(SUBS(_xDado, 1, 2)+"/"+SUBS(_xDado, 3, 2)+"/"+SUBS(_xDado, 5, 4))
				
			EndIf
			
			aAdd(_aVetCab, {_aDadCab[i][1], _xDado, NIL} )
			
		EndIf
		
	Next
	
	_aVetCpos := {}
	_aVetHpos := {}
	
	aAdd(_aVetItens, _aVetCpos)
	
	cPai 	:= _aVetCab[2][2]
	cComp 	:= _aVetCab[3][2]
	
	DbSelectArea("SG1")
	dbSetOrder(2)
	DbGoTop()

	
	_nBtLidos := fRead( _nHdl, @_cBuffer, _nTamLin) //  _cBuffer := FT_FREADLN()
	
	if substr(_cBuffer,61,3) == '001' .and. _aVetCab[8][2] == '001' // ve se variou o opcional
	    _lopcinal := .f.
	else
	    _lopcinal := .t.
	
	endif
	
	If ! MsSeek(xFilial("SG1") + _aVetCab[3][2] + _aVetCab[2][2] )
		
		Reclock("SG1",.T.)
		SG1->G1_FILIAL 	:= xFilial("SG1") // "01"
		SG1->G1_COD     := _aVetCab[2][2]
		SG1->G1_COMP    := _aVetCab[3][2]
		SG1->G1_TRT    	:= _aVetCab[4][2]
		SG1->G1_QUANT	:= _aVetCab[5][2]
//		SG1->G1_PERDA   := _aVetCab[6][2]
		SG1->G1_INI		:= ctod("01/01/2001") //_aVetCab[7][2]
		SG1->G1_FIM 	:= ctod("31/12/2049") //_aVetCab[8][2]  // ctod
		SG1->G1_OBSERV	:= DTOC(DDATABASE)
		SG1->G1_FIXVAR	:= "V"
		SG1->G1_VLCOMPE := "N"
		SG1->G1_DESEN  	:= _aVetCab[4][2]
	//	SG1->G1_REVIS  	:= _aVetCab[8][2]
	    if _lopcinal
			SG1->G1_GROPC   := "001"
			SG1->G1_OPC		:=_aVetCab[8][2]
	    Endif
		MSUNLOCK()
		
	Endif
	
//	_nBtLidos := fRead( _nHdl, @_cBuffer, _nTamLin) //  _cBuffer := FT_FREADLN()
	
EndDo

_cFileLog := "SG1.LOG" //NomeAutoLog()

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

/////////////////////////////////////////////////////////////////////////////
