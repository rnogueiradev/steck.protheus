/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัอออออออออออออออออออออออหออออออัออออออออออปฑฑ
ฑฑบPrograma  ณ STCTE001 บ Autor ณ RVG      				บ Data ณ 11/01/14 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯอออออออออออออออออออออออสออออออฯออออออออออนฑฑ
ฑฑบDescricao ณ Leitura e Importacao Arquivo XML para gera็ใo de Nota - CTEบฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ STECK                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

//-- Ponto de Entrada para incluir botใo na Pr้-Nota de Entrada

#INCLUDE "PROTHEUS.CH"
#include "RWMAKE.ch"
#include "Colors.ch"
#include "Font.ch"
#Include "HBUTTON.CH"
#include "Topconn.ch"

User Function STCTE001()
	
	If ApMsgYesNo("Deseja importar os arquivos XML CT-e (S/N)?")
		
		Processa({||STCTE01A(),"Processando... " })
		
		MsgAlert("Processo Finalizado!")
		
	Endif
	
Return

Static Function STCTE01A()
	
	Local aTipo			:= {'N','B','D'}
	Local cFile 		:= Space(10)
	Local nX			:= 0
	Private cTipo		:= "CTE"
	Private CPERG   	:= "NOTAXML"
	Private Caminho 	:= "\System\XmlNfe\"
	Private _cMarca		:= GetMark()
	Private aFields		:= {}
	Private cArq		:= ""
	Private aFields2	:= {}
	Private cArq2		:= ""
	Private lPcNfe		:= GETMV("MV_PCNFE")
	Private oglFont		:= TFont ():New(,,-11,.T.,.T.,5,.T.,5,.F.,.F.)
	Private _nVlMarcs	:=0
	Private  oSay
	Private _Chave_NFE	:= " "
	Private _nopcao		:= 0
	Private _cDir		:= ""
	Private _aDiretorio	:= {}
	Private cFile		:= ""
	Private _aLogs		:= {}
	
	PutMV("MV_PCNFE",.f.)
	
	nTipo := 1
	
	/*
	cCodBar := Space(100)
	
	DEFINE MSDIALOG _oPT00005 FROM  50, 050 TO 400,500 TITLE OemToAnsi('Busca de XML de CTE') PIXEL
	
	@ 135,110 Button OemToAnsi("Arquivo") Size 036,016 Action (GetArq(@cCodBar),_nopcao:=1,_oPT00005:End())
	@ 135,160 Button OemToAnsi("Sair")   Size 036,016 Action (_nopcao:=0,_oPT00005:End())
	
	Activate Dialog _oPT00005 CENTERED
	
	MV_PAR01 := nTipo
	
	cArqFret := cCodBar
	
	if _nopcao == 0
		exit
	endif
	*/
	
	_cDir := GetArq(_cDir)
	
	//Carrega listagem de arquivos para leitura
	_aDiretorio := Directory(Alltrim(_cDir)+"*.XML")
	_aDirProc   :=  Alltrim(_cDir)+"processados\"
	
	if !ExistDir(_aDirProc)
		MakeDir(_aDirProc)
	Endif
	
	//Checa se existem arquivos para importacao
	If Len(_aDiretorio)<=0
		lContinua := .F.
		lEmptyFolder:=.T.
		ApMsgStop(OemtoAnsi("Nใo hแ arquivos para importar."),OemtoAnsi("Atencao!!!"))
		Return()
	Endif
	
	ProcRegua(Len(_aDiretorio))
	
	
	For nX :=1 To Len(_aDiretorio)
		
		cFile := _aDiretorio[nX,1]
		
		IncProc("CTE: "+cFile)
		
		cArqFret := _cDir+cFile
		cArqProc := _aDirProc+cFile
		
		If !File(cArqFret) .and. !Empty(cArqFret)
			MsgAlert("Arquivo "+cArqFret+" nใo encontrado no Local de Origem Indicado!")
			PutMV("MV_PCNFE",lPcNfe)
			Return
		Endif
		
		aDados := {}
		
		//	msaguarde({||LeDados(aDados, @cTipo)},"Importando CTE...")
		
		LeDados(aDados, @cTipo)
		
		//	msaguarde({||GrDados(aDados, '','','' )},"Gravando CTE...")
		GrDados(aDados, '','','' )
		
	Next nX
	
	FPlOG()
	
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณChk_File  บAutor  ณ                    บ Data ณ             บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณChamado pelo grupo de perguntas EESTR1			          บฑฑ
ฑฑบ          ณVerifica se o arquivo em &cVar_MV (MV_PAR06..NN) existe.    บฑฑ
ฑฑบ          ณSe nใo existir abre janela de busca e atribui valor a       บฑฑ
ฑฑบ          ณvariavel Retorna .T.										  บฑฑ
ฑฑบ          ณSe usuแrio cancelar retorna .F.							  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณTexto da Janela		                                      บฑฑ
ฑฑบ          ณVariavel entre aspas.                                       บฑฑ
ฑฑบ          ณEx.: Chk_File("Arquivo Destino","mv_par06")                 บฑฑ
ฑฑบ          ณVerificaSeExiste? Logico - Verifica se arquivo existe ou    บฑฑ
ฑฑบ          ณnao - Indicado para utilizar quando o arquivo eh novo.      บฑฑ
ฑฑบ          ณEx. Arqs. Saida.                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function 02Chk_F(cTxt, cVar_MV, lChkExiste)
	Local lExiste := File(&cVar_MV)
	Local cTipo := "Arquivos XML   (*.XML)  | *.XML | Todos os Arquivos (*.*)    | *.* "
	Local cArquivo := ""
	
	//Verifica se arquivo nใo existe
	If lExiste == .F. .or. !lChkExiste
		cArquivo := cGetFile( cTipo,OemToAnsi(cTxt))
		If !Empty(cArquivo)
			lExiste := .T.
			&cVar_Mv := cArquivo
		Endif
	Endif
Return (lExiste .or. !lChkExiste)





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ STCTE001 บ Autor ณ RVG      	 	     บ Data ณ 11/01/14    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

static Function  StEmail(_cTitulo,_cEmail,_cArqx)
	*------------------------------------------------------------------*
	
	Local aArea 	:= GetArea()
	Local _cAssunto:= _cTitulo
	Local cFuncSent:= "StLibXML"
	Local _aMsg    :={}
	Local cMsg     := ""
	Local _nLin
	
	
	Aadd( _aMsg , { "NF Num: "          , SF1->F1_DOC } )
	Aadd( _aMsg , { "Data: "    		, dtoc(dDataBase) } )
	Aadd( _aMsg , { "Hora: "    		, time() } )
	Aadd( _aMsg , { "Status: "    		, "inclusao" } )
	Aadd( _aMsg , { "Chave: "    		, SF1->F1_CHVNFE } )
	Aadd( _aMsg , { "Forncedor: "  		, SA2->A2_COD+SA2->A2_LOJA + '-'+SA2->A2_NREDUZ } )
	Aadd( _aMsg , { "Usuario: " 	 	, cUserName } )
	
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
		IF (_nLin/2) == Int( _nLin/2 )
			cMsg += '<TR BgColor=#B0E2FF>'
		Else
			cMsg += '<TR BgColor=#FFFFFF>'
		EndIF
		cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></B></TD>'
		cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></TD>'
		cMsg += '</TR>'
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
	
	
	U_STMAILTES(_cEmail,_cAssunto,cMsg,_cArqx)
	
	RestArea(aArea)
Return()




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ STCTE001 บ Autor ณ RVG      	 	     บ Data ณ 11/01/14    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/




Static Function LeDados(aDados, cTipo)
	
	Local cLinha	:= ""
	Local cCNPJ := ""
	local nValNf := 0
//	local i  
	Local oXML			:= 0
	Local _CTEPROC	:= ""
	Local _CTE			:= ""
	Local _INFCTE		:= ""
	Local cCnpjBvx	:= ""
	Local oCTE       	:= 0 //oXML:_CTEPROC:_CTE:_INFCTE
	Local cNumConhe  	:= "" //strzero(val(oCTE:_IDE:_NCT:TEXT),9)
	Local cSerie 		:= ""//oCTE:_IDE:_SERIE:TEXT
	
	FT_FUSE(cArqFret)
	
	Begin Sequence
		
		FT_FGOTOP()
		
		aDados := {}
		
		
		cLinha := FT_FREADLN() // L๊ linha do arquivo texto
		
		if "<cteProc" $ cLinha
			
			cTipo := "CTE"
			FT_FUSE()
			
			cError :=""
			cWarning :=""
			
			nHdl    := fOpen(cArqFret,0)
			
			nTamFile := fSeek(nHdl,0,2)
			fSeek(nHdl,0,0)
			cBuffer  := Space(nTamFile)                // Variavel para criacao da linha do registro para leitura
			nBtLidos := fRead(nHdl,@cBuffer,nTamFile)  // Leitura  do arquivo XML
			fClose(nHdl)
			
			oXML := XmlParser(cBuffer,"_",@cError,@cWarning)  //carrega arquivo CT-e
			
			If Empty(oXml) .AND. "UTF-8" $ UPPER(cBuffer)
				cBuffer	:= EncodeUTF8( cBuffer )
				oXml	:= XmlParser( cBuffer, "_",@cError,@cWarning )
			EndIf
			
			//-- Erro na sintaxe do XML
			If Empty(oXML) .Or. !Empty(cError)
				cError := "ATENวAO -->> ERRO AO LER ARQUIVO: " + alltrim(cArqFret) + ", ERRO:" + AllTrim(cError)
				cTipo  := "ERROCTE"
			else
				
				
				oCTE        := oXML:_CTEPROC:_CTE:_INFCTE
				cCNPJ       := oCTE:_EMIT:_CNPJ:TEXT
				cNumConhe   := strzero(val(oCTE:_IDE:_NCT:TEXT),9)
				cSerie      := oCTE:_IDE:_SERIE:TEXT
				//cCnpjBvx 	:= "" //oCTE:_REM:_CNPJ:TEXT //Conforme Informado pela Veronica nem sempre o remetente ้ o tomador, para evitar erros na escrituracao considerar apenas a Tag de tomador
				cCnpjBvx 	:= oCTE:_REM:_CNPJ:TEXT 
				
				
				IF ALLTRIM(cCnpjBvx) <> ALLTRIM(SM0->M0_CGC)
					If Type("oCTE:_IDE:_TOMA4:_CNPJ") <> "U"
						cCnpjBvx := oCTE:_IDE:_TOMA4:_CNPJ:TEXT
					ElseIf Type("oCTE:_IDE:_TOMA04:_CNPJ") <> "U"
						cCnpjBvx := oCTE:_IDE:_TOMA04:_CNPJ:TEXT
					ElseIf Type("oCTE:_IDE:_TOMA04:_TOMA") <> "U"
						If oCTE:_IDE:_TOMA04:_TOMA:TEXT = '0'
							If Type("oCTE:_REM:_CNPJ") <> "U"
								cCnpjBvx := oCTE:_REM:_CNPJ:TEXT
							EndIf
						ElseIf oCTE:_IDE:_TOMA04:_TOMA:TEXT = '1'
							If Type("oCTE:_EXPED:_CNPJ") <> "U"
								cCnpjBvx := oCTE:_EXPED:_CNPJ:TEXT
							EndIf
						ElseIf oCTE:_IDE:_TOMA04:_TOMA:TEXT = '2'
							If Type("oCTE:_RECEB:_CNPJ") <> "U"
								cCnpjBvx := oCTE:_RECEB:_CNPJ:TEXT
							EndIf
						ElseIf oCTE:_IDE:_TOMA04:_TOMA:TEXT = '3'
							If Type("oCTE:_DEST:_CNPJ") <> "U"
								cCnpjBvx := oCTE:_DEST:_CNPJ:TEXT
							EndIf
						EndIf
					ElseIf Type("oCTE:_IDE:_TOMA03:_CNPJ") <> "U"
						cCnpjBvx := oCTE:_IDE:_TOMA03:_CNPJ:TEXT
					ElseIf Type("oCTE:_IDE:_TOMA03:_TOMA") <> "U"
						If oCTE:_IDE:_TOMA03:_TOMA:TEXT = '0'
							If Type("oCTE:_REM:_CNPJ") <> "U"
								cCnpjBvx := oCTE:_REM:_CNPJ:TEXT
							EndIf
						ElseIf oCTE:_IDE:_TOMA03:_TOMA:TEXT = '1'
							If Type("oCTE:_EXPED:_CNPJ") <> "U"
								cCnpjBvx := oCTE:_EXPED:_CNPJ:TEXT
							EndIf
						ElseIf oCTE:_IDE:_TOMA03:_TOMA:TEXT = '2'
							If Type("oCTE:_RECEB:_CNPJ") <> "U"
								cCnpjBvx := oCTE:_RECEB:_CNPJ:TEXT
							EndIf
						ElseIf oCTE:_IDE:_TOMA03:_TOMA:TEXT = '3'
							If Type("oCTE:_DEST:_CNPJ") <> "U"
								cCnpjBvx := oCTE:_DEST:_CNPJ:TEXT
							EndIf
						EndIf
					Else // Jefferson 
						cCnpjBvx := oCTE:_DEST:_CNPJ:TEXT
					Endif
				EndIf
			EndIf
			
			IF ALLTRIM(cCnpjBvx) <> ALLTRIM(SM0->M0_CGC)
				//			MsgStop('Conhecimento ' + cNumConhe  +' nใo pertence a esta empresa !!! ')
				aadd(_aLogs,{'ER', cArqFret , 'Conhecimento ' + cNumConhe  +' nใo pertence a esta empresa !!! ' })
				
			ELSE
				/*
				if alltrim(cSerie) == '0'
					cSerie      := '1'
				endif
				*/
				cTextoCompl := AllTrim(oCTE:_EMIT:_XNOME:TEXT) //razao social
				cCfop       := oCTE:_IDE:_CFOP:TEXT
				
				DbSelectArea("SA2")
				DbSetOrder(3)
				DbSeek(xFilial("SA2")+cCNPJ)
				
				IF !Found()
					//	msgstop("Fornecedor " + cCNPJ + " nao cadastrado !! ")
					aadd(_aLogs,{'ER', cArqFret , "Fornecedor " + cCNPJ + " nao cadastrado !! "  })
				else
					//informa็oes do fornecedor
					cCodFornecedor := SA2->A2_COD
					cLojaFornecedor:= SA2->A2_LOJA
					cNomeFornecedor:= SA2->A2_NOME
					cEstFornecedor := SA2->A2_EST
					
					if cEstFornecedor = 'SP'
						cCfop := '1'+substr(cCfop,2,4)
					else
						cCfop := '2'+substr(cCfop,2,4)
					endif
					
					cEmissao := strtran(left(oCTE:_IDE:_DHEMI:TEXT,10),"-","")
					nVlFrete := Val(oCTE:_VPREST:_VTPREST:TEXT)
					
					nBaseIcm := 0
					nAliqIcm := 0
					nVlIcms  := 0
					
					if Type("oCTE:_IMP:_ICMS:_ICMS00")  <> "U"
						oIcm := oCTE:_IMP:_ICMS:_ICMS00
					elseif Type("oCTE:_IMP:_ICMS:_ICMS20")  <> "U"
						oIcm := oCTE:_IMP:_ICMS:_ICMS20
					endif
					
					if Type("oIcm")  <> "U"
						nBaseIcm := val(oIcm:_VBC:TEXT)
						nAliqIcm := val(oIcm:_PICMS:TEXT)
						nVlIcms  := val(oIcm:_VICMS:TEXT)
					endif
					
					cSerNF := ""
					cNumNF := ""
					nValNf := 0
					cTransp:= ""
					
					//tomador servi็o
					cToma := "0"
					if Type("oCTE:_IDE:_TOMA03:_TOMA")  <> "U"
						cToma := oCTE:_IDE:_TOMA03:_TOMA:TEXT
					endif
					
					cSerNF := " "
					cNumNF := " "
					nValNf := 0
					
					if Type("oCTE:_REM:_INFNF:_SERIE")  <> "U"
						cSerNF := oCTE:_REM:_INFNF:_SERIE:TEXT
					Endif
					if Type("oCTE:_REM:_INFNF:NDOC")  <> "U"
						cNumNF := strzero(val(oCTE:_REM:_INFNF:_NDOC:TEXT),9)
					Endif
					if Type("oCTE:_REM:_INFNF:_VNF")  <> "U"
						nValNf := val(oCTE:_REM:_INFNF:_VNF:TEXT)
					ENDIF
					
					aAdd(aDados,{ , ,;  //empresa=1, filial=2
					cNumConhe, ;            //numero conhecimento -3
					cSerie,;              	         // serie -4
					stod(cEmissao),;			     //emissao -5
					cCodFornecedor,;			     //cod forn - 6
					cLojaFornecedor,;	             // loja forn - 7
					"CTE",;        	             // especie - 8
					cEstFornecedor,;                // uf - 9
					"FRETE",;                      // produto - 10
					"UN",;                         // un - 11
					1,;                             //qtd - 12
					nVlFrete,;                      // val uni -13
					nVlFrete,;                      // val total - 14
					nBaseIcm,;                         //  base icms -15
					nAliqIcm,;                        //  aliq icms  -16
					nVlIcms,;  					    	//  valor icms - 17
					"",;                           //  cc -18     (preenchido direto na gravacao)
					cCfop,;                         //
					cCNPJ,;                         // cnpj  -20
					cTextoCompl,;                  // texto compl. (razao) -21
					nValNf,;						// valor bruto nf 22
					0,; 							// valor frete NF 23
					cNumNF,;                        // NUM NF 24
					cSerNF,;						// Serie NF 25
					oXML:_CTEPROC:_PROTCTE:_INFPROT:_CHCTE:TEXT,;   //chave CT-e - 26
					oCTE:_IDE:_TPCTE:TEXT } )      //tipo CT-e - 27
					
					
				endif
			Endif
			//Endif  // Retirado por Jefferson 061113
		Else
			aadd(_aLogs,{'ER', cArqFret , "O Arquivo nใo ้ um CT-e!" } )
		Endif
		
	End Sequence
	FT_FUSE()
Return cTipo





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ STCTE001 บ Autor ณ RVG      	 	     บ Data ณ 11/01/14    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


Static Function GrDados(aDados, cEmp, cFil, cTipo)
	
	Local n :=0
	Local aArea	:= GetArea()
	Local bError
	Local lError	:= .F.
	Local cErroEa	:= ''
	local cGravouData := ''
	local nCont := 0
	Local i
	
	Local	aCabec := {}
	Local	aItens := {}
	cAntConh := ''
	cAntNf := ''
	
	
	Begin Sequence
		
		for n := 1 to len(aDados)
			
			
			//Importa็ao do conhecimento para o sistema - (SF1-SD1)
			dbselectarea("SF1")
			DbSetOrder(1)
			DbGoTop()
			DbSeek(xFilial("SF1") + PadR(aDados[n,3],TamSx3("F1_DOC")[1]) + PadR(aDados[n,4],TamSx3("F1_SERIE")[1]) + PadR(aDados[n,6],TamSx3("F1_FORNECE")[1]) + Padr(aDados[n,7],TamsX3("F1_LOJA")[1]) + "N")
			
			IF !Found()
				
				
				aadd(aCabec,{"F1_TIPO"   ,"N"})
				aadd(aCabec,{"F1_FORMUL" ,"N"})
				aadd(aCabec,{"F1_DOC"    ,aDados[n,3]})
				aadd(aCabec,{"F1_SERIE"  ,aDados[n,4]})
				aadd(aCabec,{"F1_EMISSAO",aDados[n,5]})
				aadd(aCabec,{"F1_FORNECE",aDados[n,6]})
				aadd(aCabec,{"F1_LOJA"   ,aDados[n,7]})
				aadd(aCabec,{"F1_ESPECIE", "CTE"})
				aadd(aCabec,{"F1_EST",aDados[n,9]})
				aadd(aCabec,{"F1_COND","001"})
				
				aadd(aCabec,{"F1_TPFRETE",iif(empty(alltrim(aDados[n,24])),"F","C")})   //verificar se os CTE emitidos ref. coleta em cliente tb sใo CIF ou se sao FOB
				aadd(aCabec,{"F1_CHVNFE",aDados[n,26]})
				aadd(aCabec,{"F1_TPCTE",iif(aDados[n,27]=="0","N",iif(aDados[n,27]==1,"C","A"))})
				
				aLinha := {}
				aadd(aLinha,{"D1_COD",IIF(aDados[n,17]>0,"FRETE","FRETE SEM CRED"),Nil})
				aadd(aLinha,{"D1_UM" ,"UN",NIL})
				aadd(aLinha,{"D1_QUANT",aDados[n,12],Nil})
				aadd(aLinha,{"D1_VUNIT",aDados[n,13],Nil})
				aadd(aLinha,{"D1_TOTAL",aDados[n,14],Nil})
				aadd(aLinha,{"D1_TES",IIF(aDados[n,17]>0,"104","105"),Nil})
				aadd(aLinha,{"D1_CF",Substr(aDados[n,19],1,1)+"352",NIL})
				aAdd(aLinha,{"D1_BASEICM",aDados[n,15],Nil})
				aAdd(aLinha,{"D1_PICM",aDados[n,16],Nil})
				aAdd(aLinha,{"D1_VALICM",aDados[n,17],Nil})
				//
				aadd(aItens,aLinha)
				
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//|Inclusao                                            |
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				lMsHelpAuto := .T.
				lMsErroAuto := .F.
				
				MSExecAuto({|x,y,z| MATA140(x,y,z)},aCabec,aItens,3)
				
				
				If lMsErroAuto  //se der erro grava no arquivo de log.
					
					MostraErro()
					lMsErroAuto := .F.
					
				else
					
					
					aadd(_aLogs,{'OK', cArqFret ,"CTE " + aDados[n,3] + " importado com sucesso !!!" })
					MoveArq(cArqFret, cArqProc )
					
				EndIf
			Else
				
				aadd(_aLogs,{'ER', cArqFret ,"CTE " + aDados[n,3] + " ja importado !!!" })
				
				
			endif
			
			
		next
		
	End Sequence
	
	RestArea(aArea)
	
Return { lError, cErroEa }


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ STCTE001 บ Autor ณ RVG      	 	     บ Data ณ 11/01/14    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


Static Function GetArq(cDirectory)
	cDirectory := cGetFile("*.xml","Importa็ใo de CT-e",0,cDirectory,.T.,GETF_LOCALHARD+GETF_RETDIRECTORY)
	//cFile:= cGetFile("*.xml","XML File",1,"C:\",.T.,GETF_LOCALHARD,.T.,.T.)    #P11@1213
	
Return cDirectory


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ STCTE001 บ Autor ณ RVG      	 	     บ Data ณ 11/01/14    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


Static Function MoveArq(cArqAtu,cArqOld)
	
	If File(cArqOld)
		FErase(cArqOld)
	EndIf
	__CopyFile( cArqAtu, cArqOld )
	FErase(cArqAtu)
Return .t.



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ STCTE001 บ Autor ณ RVG      	 	     บ Data ณ 11/01/14    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


Static Function FPlOG()
	
	Local aPosObj   := {}
	Local aPosGet	:= {}
	Local aObjects  := {}
	Local aSize     := {}
	Local aArea     := GetArea()
	
	
	Local cCadastro := "Log de importacao de CTE"
	Local cQuery    := ""
	
	Local nOpcA     := 0
	Local nGd1      := 0
	Local nGd2      := 0
	Local nGd3      := 0
	Local nGd4      := 0
	Local nGetLin   := 0
	Local nLoop     := 0
	Local nOpcGD	:= 0
	
	//Local oOk		:= LoadBitmap( GetResources(), "LBOK " )   //CHECKED    //LBOK  //LBTIK
	//Local oNo		:= LoadBitmap( GetResources(), "MSAVISO" ) //UNCHECKED  //LBNO
	Local 	oNo		:=	LoadBitmap( GetResources(), "icone_failure" )
	Local	oOk		:=	LoadBitmap( GetResources(), "icone_ok")
	
	PRIVATE aHEADER := {}
	PRIVATE aCOLS   := {}
	PRIVATE aHEADER1:= {}
	PRIVATE aCOLS1  := {}
	PRIVATE aGETS   := {}
	PRIVATE aTELA   := {}
	
	PRIVATE oGetDad1:= Nil
	PRIVATE oFolder	:= Nil
	PRIVATE aitens  := {}
	PRIVATE _cReturn:= .T.
	
	aSize    := MsAdvSize()
	
	aObjects := {}
	AAdd( aObjects, {  60, 100, .T., .T. } )
	AAdd( aObjects, { 100, 100, .T., .T. } )
	
	aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
	aPosObj := MsObjSize( aInfo, aObjects )
	
	aPosGet := MsObjGetPos(aSize[3]-aSize[1],315,{{265,283}} )
	nGetLin := aPosObj[2,1] + 200
	
	_nfator := 25
	
	DEFINE MSDIALOG oDlg TITLE cCadastro From aSize[7],00 To aSize[6] , aSize[5] OF oMainWnd PIXEL
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Define as posicoes da Getdados a partir do folder    ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	nGd1 	:= 2
	nGd2 	:= 2
	nGd3 	:= aSize[3]-50
	nGd4 	:= aSize[4]
	
	_atit_cab1:= 	{"Status","Arquivo","Log de Processamento" }
	
	oListBox2 := TWBrowse():New( aPosObj[1,1],aPosObj[2,2]+_nfator,nGd3,nGd4                              ,,_atit_cab1, ,oDlg,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )
	
	oListBox2:AddColumn(TCColumn():New( "Status "  		   	    ,{|| iif(_aLogs[ oListBox2:nAt, 01 ] ='OK',oOk,oNo)  }, "@c",nil,nil,nil,010,.T.,.T.,nil,nil,nil,.T.,nil))
	oListBox2:AddColumn(TCColumn():New( "Arquivo"  				,{|| _aLogs[ oListBox2:nAt, 02 ] },,,			,'LEFT',,.F.,.F.,,,,.F.,))
	oListBox2:AddColumn(TCColumn():New( "Log de Processamento"  ,{|| _aLogs[ oListBox2:nAt, 03 ] },,,			,'LEFT',,.F.,.F.,,,,.F.,))
	
	oListBox2:SetArray(_aLogs)
	oListBox2:bLine 		:= {|| {	if(_aLogs[ oListBox2:nAt, 01 ] = 'OK',oOk,oNo), _aLogs[ oListBox2:nAT, 02 ], _aLogs[ oListBox2:nAT, 03 ] } }
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Ao confirmar, simula a mudanca de folder para atualizar os arrays necessarios ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg, {||nOpcA := 1 ,oDlg:End()} ,{||oDlg:End()},, )
	
Return
