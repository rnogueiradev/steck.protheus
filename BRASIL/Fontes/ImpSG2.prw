#INCLUDE "RWMAKE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ IMPSG2   บAutor  ณErnani Forastieri   บ Data ณ  10/10/03   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Rotina para importacao de Roteiros de Producao         a   บฑฑ
ฑฑบ          ณ a partir de arquivo texto com layout pre definido          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function ImpSG2()
Local aSay    := {}
Local aButton := {}
Local nOpc    := 0
Local cTitulo := ""
Local cDesc1  := "Este rotina ira fazer a importacao do cadastros dos Roteiros de Producao"
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
aAdd( _aDadCab, { "G2_FILIAL",	"C", 01,		02,		0, .T. } ) //1
aAdd( _aDadCab, { "G2_CODIGO",	"C", 03,		02,		0, .T. } ) //2
aAdd( _aDadCab, { "G2_PRODUTO",	"C", 05,		15,		0, .T. } ) //3
aAdd( _aDadCab, { "G2_OPERAC",	"C", 20,		02,		0, .T. } ) //4
aAdd( _aDadCab, { "G2_DESCRI",	"C", 22,		40,		0, .T. } ) //5
aAdd( _aDadCab, { "G2_MAOOBRA",	"N", 62,		02,		0, .T. } ) //6
aAdd( _aDadCab, { "G2_LOTEPAD",	"N", 64,		06,		0, .T. } ) //7
aAdd( _aDadCab, { "G2_TEMPAD",	"C", 75,		05,		0, .T. } ) //8
aAdd( _aDadCab, { "G2_SETUP",	"C", 82,		05,		0, .T. } ) //9
aAdd( _aDadCab, { "G2_CTRAB",	"C", 87,		06,		0, .T. } ) //10
aAdd( _aDadCab, { "G2_RECURSO",	"C", 93,		06,		0, .T. } ) //11

//
_nNumCposCab  := LEN(_aDadCab)

AutoGrLog("--------------------------------------")
AutoGrLog("INICIANDO O LOG - Roteiros de Producao")
AutoGrLog("--------------------------------------")
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
				
				//_xDado := StrTran(_xDado, ",", "")
				
				//_xDado := VAL(_xDado) / (10 ^_aDadCab[i][5])
				
				_xDado := VAL(_xDado)
				
			ElseIf _aDadCab[i][2] == "D"
				
				//	_xDado := CTOD(SUBS(_xDado, 7, 2)+"/"+SUBS(_xDado, 5, 2)+"/"+SUBS(_xDado, 3, 2))
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
	
	DbSelectArea("SG2")
	dbSetOrder(1)
	DbGoTop()


	If ! MsSeek(xFilial("SG2") + _aVetCab[3][2] + _aVetCab[2][2] + _aVetCab[4][2] )
		
		Reclock("SG2",.T.)
		SG2->G2_FILIAL 	:= _aVetCab[1][2] //xFilial("SG1") // "01"
		SG2->G2_CODIGO  := _aVetCab[2][2]
		SG2->G2_PRODUTO := _aVetCab[3][2]
		SG2->G2_OPERAC  := _aVetCab[4][2]
		SG2->G2_DESCRI	:= _aVetCab[5][2]
		SG2->G2_MAOOBRA := SUPERVAL(_aVetCab[6][2])
		SG2->G2_LOTEPAD := SUPERVAL(_aVetCab[7][2])  
		SG2->G2_TEMPAD 	:= SUPERVAL(Substr(_aVetCab[8][2],1,3)+"."+Substr(_aVetCab[8][2],4,2))  
		SG2->G2_SETUP	:= SUPERVAL(Substr(_aVetCab[9][2],1,3)+"."+Substr(_aVetCab[9][2],4,2))
		SG2->G2_CTRAB  := _aVetCab[10][2]
		SG2->G2_RECURSO	:= _aVetCab[11][2]
		MSUNLOCK()

	Endif
	
	_nBtLidos := fRead( _nHdl, @_cBuffer, _nTamLin) //  _cBuffer := FT_FREADLN()
	
EndDo

_cFileLog := "SG2.LOG" //NomeAutoLog()

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
