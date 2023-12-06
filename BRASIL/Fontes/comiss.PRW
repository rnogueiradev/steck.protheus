#INCLUDE "RWMAKE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ IMPSE1   บAutor  ณErnani Forastieri   บ Data ณ  10/10/03   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Rotina para importacao de Contas Receber    MSExecAuto a   บฑฑ
ฑฑบ          ณ a partir de arquivo texto com layout pre definido          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function comiss()
Local aSay    := {}
Local aButton := {}
Local nOpc    := 0
Local cTitulo := ""
Local cDesc1  := "Este rotina ira fazer a importacao de Contas a Receber"
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
aAdd( _aDadCab, { "E3_FILIAL",	"C", 01,		02,		0, .T. } ) // Codigo 					Obrigatorio
aAdd( _aDadCab, { "E3_PREFIXO",	"C", 03,		03,		0, .T. } ) // Loja 						Obrigatorio
aAdd( _aDadCab, { "E3_NUM",		"C", 06,		09,		0, .T. } ) // Fisica/Jurid.
aAdd( _aDadCab, { "E3_PARCELA",	"C", 15,		01,		0, .T. } ) // Nome						Obrigatorio 
aAdd( _aDadCab, { "E3_CODCLI",	"C", 17,		06,		0, .T. } ) // N Fantasia				Obrigatorio
aAdd( _aDadCab, { "E3_LOJA",	"C", 23,		02,		0, .T. } ) // Tipo - ex. F=Cons. Final 	Obrigatorio 
aAdd( _aDadCab, { "E3_VEND", 	"C", 25,		06,		0, .T. } ) // Endereco 					Obrigatorio
aAdd( _aDadCab, { "E3_PORC",	"C", 31,		05,		0, .T. } ) // Estado 					Obrigatorio 
aAdd( _aDadCab, { "E3_BASE",	"C", 36,		17,		0, .T. } ) // Cพdigo do Municipio		Obrigatorio
aAdd( _aDadCab, { "E3_COMIS",	"C", 53,		17,		0, .T. } ) // Cพdigo do Municipio		Obrigatorio


_nNumCposCab  := LEN(_aDadCab)

AutoGrLog("----------------------------------------")
AutoGrLog("INICIANDO O LOG - IMPORTACAO DE RECEBER ")
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

            	If ALLTRIM( _aDadCab[i][1] ) != "E3_NUM"

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
	U_GRAvaSE3(_aVetCab[7][2],_aVetCab[5][2],_aVetCab[6][2],_aVetCab[2][2],_aVetCab[3][2],_aVetCab[4][2])
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

_cFileLog := "SE1.LOG" //NomeAutoLog()

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

User Function GRAvaSE3(cVend, cCli, cLoj, cPrf, cNum, cPar)
// +"NF "

DBSelectarea("SE3")
Dbsetorder(3)
      
//	IF Dbseek(xFilial("SE1") + _aVetCab[2][2]+" "+ _aVetCab[3][2]+ _aVetCab[4][2])        
	IF Dbseek(xFilial("SE3") + cVend+cCli+cLoj+cPrf+" "+ cNum+ cPar+"NF")        
	
		RecLock("SE3", .F.)

		SE3->E3_BASE	  := SUPERVAL(substr(_aVetCab[9][2],01,15)+"."+substr(_aVetCab[9][2],16,02))									   		
		SE3->E3_COMIS	  := SUPERVAL(substr(_aVetCab[10][2],01,15)+"."+substr(_aVetCab[10][2],16,02))
		SE3->E3_PORC	  := SUPERVAL(substr(_aVetCab[8][2],01,2)+"."+substr(_aVetCab[8][2],4,02))

		SE3->(msUnlock())	
	
	ENDIF

Return .t.
