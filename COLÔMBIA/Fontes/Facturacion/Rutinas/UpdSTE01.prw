#Include 'TOTVS.ch'
#INCLUDE "TopConn.ch"
#INCLUDE "stdwin.ch"
#INCLUDE "RPTDEF.CH"
#INCLUDE "TBICONN.CH"
// Rutina utrilizada para actualizar en masivo campos de las tablas SA1, SB1, DA1
// Utilizando un archivo CSV.
User function UPDSTE01
    Local aArea			:= GetArea()
    Local aTablas   := {}
    Local aActuali  := {}
    Local aTabUpd   := {}
    Local lProc     := .F.
    Local cCamb     := ""
    Local cArchivo  := ""
    Private nLar3   :=0
    Private nLar4   :=0
    Private cTipo   :=""
    DBSelectArea("SA1")
    DBSelectArea("SB1")
    DBSelectArea("DA1")
	// Ejemplo: Archivo CSV debe tener encabezado Así
	// SA1;A1_FILIAL;A1_COD;A1_LOJA;A1_EMAIL
	// Datos Así
	// ;;19461122;01;refrielectricosyesmaltados@hotmail.com
	// ;;52297517;01;electro_pena@hotmail.com
	// ;;80733569;01;comprasfe@electricosla36.com
	
    aAdd(aTablas,{'SA1','A1_FILIAL','A1_COD','A1_LOJA'          ,{'A1_COND','A1_TABELA','A1_ENDENT', 'A1_DESC', 'A1_LC', 'A1_CEP', 'A1_BAIRRO', 'A1_EMAIL', 'A1_RISCO' },1})  //A1_FILIAL+A1_COD+A1_LOJA
    aAdd(aTablas,{'SB1','B1_FILIAL','B1_COD',''                 ,{'B1_PRV1','B1_DESC','B1_PESO','B1_TIPCAR','B1_CODBAR'},1}) // B1_FILIAL+B1_COD
    aAdd(aTablas,{'DA1','DA1_FILIAL','DA1_CODTAB','DA1_CODPRO'  ,{'DA1_PRCVEN'},1})  //DA1_FILIAL+DA1_CODTAB+DA1_CODPRO+DA1_INDLOT+DA1_ITEM

    cArchivo:=fCargaArchivo()
    IF EMPTY(cArchivo)
        Return .T.
    EndIf
    aActuali:=ReadUpd1(cArchivo)
    _valida(@aTablas,@aActuali,@lProc,@aTabUpd)

    If lproc
        _actual(aTabUpd,aActuali)
    Else
        Alert("Archivo no fue procesado, campos no encontrado")
    EndIf

    RestArea(aArea)
Return .t.

Static function _valida(aTablas,aActuali,lProc,aTabUpd)
    Local aArea	   := GetArea()
    Local nX       :=0
    Local nY       :=0
    //Local aTamano  := {}
    If len(aActuali)>=2
        For nX:=1 to  len(aTablas)
            if aActuali[1][1]==aTablas[nX][1]
                If aTablas[nX][2]==aActuali[1][2] .and. aTablas[nX][3]==aActuali[1][3] .and. aTablas[nX][4]==aActuali[1][4]
                    For nY:=1 to Len(aTablas[nX][5])
                        If aTablas[nX][5][nY]==aActuali[1][5]
                            aAdd(aTabUpd,{/* 1 Tabla*/aTablas[nX][1],/*2 Filial*/aTablas[nX][2],/*3 Codigo*/aTablas[nX][3],/*4 Codigo2*/aTablas[nX][4],/*5 Campo*/aTablas[nX][5][nY],/*6 Indice*/aTablas[nX][6]})
                            DBSelectArea("SX3")
                            DBSetOrder(2)
                            dbSeek(aTablas[nX][3]);nLar3:=SX3->X3_TAMANHO
                            dbSeek(aTablas[nX][5][nY]);cTipo:=SX3->X3_TIPO
                            IF !Empty(aTablas[nX][4])
                                dbSeek(aTablas[nX][4]);nLar4:=SX3->X3_TAMANHO
                            else
                                nLar4:=0
                            endIf
                            lProc:=.T.
                        EndIF
                    Next
                EndIf
            EndIF
        Next
    EndIf
    SX3->(dbCloseArea())
    RestArea(aArea)
Return 

static function _actual(aTabUpd,aActuali)
    Local nX       := 0
    Local cSearch  := ""
    Local cDataTable:= aTabUpd[1][1]
    Local xDato
    Local cLog:= ""
    Local oDlg
    Local oMemo
    IF cDataTable=="SA1"
        DBSelectArea("SA1")
    ElseIf cDataTable=="SB1"
        DBSelectArea("SB1")
    ElseIf cDataTable=="DA1"
        DBSelectArea("DA1")
    EndIf

    //nArea:=Select(aTabUpd[1][1])
    //DBSelectArea(nArea)
    DBSetOrder(aTabUpd[1][6])
    cLog:="Tabla"+";"+"Filial"+";"+"CampoClave1"+";"+"CampoClave2"+";"+"CampoActualizar"+";"
    cLog+=cDataTable+";"+aActuali[1][2]+";"+aActuali[1][3]+";"+aActuali[1][4]+";"+aTabUpd[1][5]+";"+";"
    FOR nX:=2 to len(aActuali)
        cSearch:=SUBSTR(aActuali[nX][3]+SPACE(nLar3),1,nLar3)+IIF(nLar4==0,"", SUBSTR(aActuali[nX][4]+SPACE(nLar4),1,nLar4) )
        IF !empty(cSearch) .and. MsSeek(xFilial(cDataTable)+cSearch,.T.)
            xDato:=&(cDataTable+"->"+aTabUpd[1][5])
            RecLock(cDataTable,.F.)
            if cTipo=='N'
                cCamb:=cDataTable+"->"+aTabUpd[1][5]+":="+aActuali[nX][5]
                cLog+= ";"+aActuali[nX][2]+";"+aActuali[nX][3]+";"+aActuali[nX][4]+";"+aTabUpd[1][5]+";"+cValToChar(xDato)+";"+aActuali[nX][5]
                &(cCamb)
            Elseif cTipo=='C'
                cCamb:=cDataTable+"->"+aTabUpd[1][5]+":='"+aActuali[nX][5]+"'"
                cLog+= ";"+aActuali[nX][2]+";"+aActuali[nX][3]+";"+aActuali[nX][4]+";"+aTabUpd[1][5]+";"+cValToChar(xDato)+";"+aActuali[nX][5]
                 &(cCamb)
            EndIf
          MsUnlock()
        EndIf
    Next
    DEFINE MSDIALOG oDlg TITLE "Bitacora de Procesamiento" FROM 0,0 TO 555,950 PIXEL
    @ 005, 005 GET oMemo VAR cLog MEMO SIZE 460, 250 OF oDlg PIXEL
    @ 260, 400 Button "SALIR" Size 035, 015 PIXEL OF oDlg Action oDlg:End()
    ACTIVATE MSDIALOG oDlg CENTERED
Return .t.

Static function ReadUpd1(cArchivo)
	Local nTimer	:= seconds()
	Local cLine 	:= ''
	Local cLinha	:= ""
	Local nLines 	:= 0
	Local nLinTXT	:= 0
	Local aDados	:= {}
	Local oTXTFile
	Local nX		:= 0
	Private aErro	:= {}

    oTXTFile := ZFWReadAXL():New(cArchivo)
    If !oTXTFile:Open()
        MsgStop("El archivo " +alltrim(cArchivo) + " no pudo ser abierto. La importación será abortada!","[ARCHLOAD] - ATENCION")
        aAdd(aMsgLog,{LogErrorSI,"ImporPV",'['+alltrim(cArchivo)+']','No se pudo abrir'})
        lFileOk:=.F.
        Return
    Endif

    While oTXTFile:ReadLine(@cLine)
        nLines++
    Enddo

    oTXTFile:Close()

    ProcRegua(nLines++)

    oTXTFile := ZFWReadAXL():New(cArchivo)
    oTXTFile:Open()
    cLine:=""
    While oTXTFile:ReadLine(@cLinha)
        IncProc("Leyendo arquivo texto, revisando estructura")
        nLinTXT += 1
        If !EMPTY(ALLTRIM(cLinha))
            AADD(aDados,Separa(cLinha,";",.T.)) // separa los campos y agrega un campos al final que es el mombre del archivo
        EndIf
    Enddo
    oTXTFile:Close()
	lFileOk:= .T.
Return aDados


Static Function fCargaArchivo()

Local cFile 		:= ""
Local cTitulo1  	:= "Seleccione Archivo"
Local cExtens   	:= "Archivo | *.csv"


cFile := cGetFile(cExtens,cTitulo1,,,.T.)

If File( cFile )
 return cFile
EndIf

Return ""

// https://siga0984.wordpress.com/2015/10/18/acelerando-o-advpl-lendo-arquivos-txt/
//-----------------
/* ======================================================================
 Classe ZFWReadAXL
 Autor Júlio Wittwer
 Data 17/10/2015
 Descrição Método de leitura de arquivo TXT
 Permite com alto desempenho a leitura de arquivos TXT
 utilizando o identificador de quebra de linha definido
 ====================================================================== */
#define DEFAULT_FILE_BUFFER 4096
CLASS ZFWReadAXL FROM LONGNAMECLASS
	DATA nHnd as Integer
	DATA cFName as String
	DATA cFSep as String
	DATA nFerror as Integer
	DATA nOsError as Integer
	DATA cFerrorStr as String
	DATA nFSize as Integer
	DATA nFReaded as Integer
	DATA nFBuffer as Integer
	DATA _Buffer as Array
	DATA _PosBuffer as Integer
	DATA _Resto as String

	// Metodos Pubicos
	METHOD New()
	METHOD Open()
	METHOD Close()
	METHOD GetFSize()
	METHOD GetError()
	METHOD GetOSError()
	METHOD GetErrorStr()
	METHOD ReadLine()

	// Metodos privados
	METHOD _CleanLastErr()
	METHOD _SetError()
	METHOD _SetOSError()
ENDCLASS

METHOD New( cFName , cFSep , nFBuffer ) CLASS ZFWReadAXL
	DEFAULT cFSep := CRLF
	DEFAULT nFBuffer := DEFAULT_FILE_BUFFER
	::nHnd := -1
	::cFName := cFName
	::cFSep := cFSep
	::_Buffer := {}
	::_Resto := ''
	::nFSize := 0
	::nFReaded := 0
	::nFerror := 0
	::nOsError := 0
	::cFerrorStr := ''
	::_PosBuffer := 0
	::nFBuffer := nFBuffer
Return self

METHOD Open( iFMode ) CLASS ZFWReadAXL
	DEFAULT iFMode := 0
	::_CleanLastErr()
	If ::nHnd != -1
		_SetError(-1,"Open Error - File already open")
		Return .F.
	Endif
	// Abre o arquivo
	::nHnd := FOpen( ::cFName , iFMode )
	If ::nHnd < 0
		_SetOSError(-2,"Open File Error (OS)",ferror())
		Return .F.
	Endif
	// Pega o tamanho do Arquivo
	::nFSize := fSeek(::nHnd,0,2)
	// Reposiciona no inicio do arquivo
	fSeek(::nHnd,0)
Return .T.

METHOD Close() CLASS ZFWReadAXL
	::_CleanLastErr()
	If ::nHnd == -1
		_SetError(-3,"Close Error - File already closed")
	Return .F.
	Endif
	// Close the file
	fClose(::nHnd)
	// Clean file read cache 
	aSize(::_Buffer,0)
	::_Resto := ''
	::nHnd := -1
	::nFSize := 0
	::nFReaded := 0
	::_PosBuffer := 0
Return .T.

METHOD ReadLine( /*@*/ cReadLine ) CLASS ZFWReadAXL
	Local cTmp := ''
	Local cBuffer
	Local nRPos
	Local nRead
	// Incrementa o contador da posição do Buffer
	::_PosBuffer++
	If ( ::_PosBuffer <= len(::_Buffer) )
		// A proxima linha já está no Buffer ...
		// recupera e retorna
		cReadLine := ::_Buffer[::_PosBuffer]
		Return .T.
	Endif

	If ( ::nFReaded < ::nFSize )
		// Nao tem linha no Buffer, mas ainda tem partes
		// do arquivo para ler. Lê mais um pedaço
		nRead := fRead(::nHnd , @cTmp, ::nFBuffer)
		if nRead < 0
			_SetOSError(-5,"Read File Error (OS)",ferror())
			Return .F.
		Endif
		// Soma a quantidade de bytes lida no acumulador
		::nFReaded += nRead
		// Considera no buffer de trabalho o resto
		// da ultima leituraa mais o que acabou de ser lido
		cBuffer := ::_Resto + cTmp
		// Determina a ultima quebra
		nRPos := Rat(::cFSep,cBuffer)
		If nRPos > 0
			// Pega o que sobrou apos a ultima quegra e guarda no resto
			::_Resto := substr(cBuffer , nRPos + len(::cFSep))
			// Isola o resto do buffer atual
			cBuffer := left(cBuffer , nRPos-1 )
		Else
			// Nao tem resto, o buffer será considerado inteiro
			// ( pode ser final de arquivo sem o ultimo separador )
			::_Resto := ''
		Endif
		// Limpa e Recria o array de cache
		// Por default linhas vazias são ignoradas
		// Reseta posicionamento de buffer para o primeiro elemento 
		// E Retorna a primeira linha do buffer 
		aSize(::_Buffer,0)
		::_Buffer := StrTokArr2( cBuffer , ::cFSep )
		::_PosBuffer := 1
		cReadLine := ::_Buffer[::_PosBuffer]
		Return .T.
	Endif
	// Chegou no final do arquivo ...
	::_SetError(-4,"File is in EOF")
Return .F.

METHOD GetError() CLASS ZFWReadAXL
Return ::nFerror

METHOD GetOSError() CLASS ZFWReadAXL
Return ::nOSError

METHOD GetErrorStr() CLASS ZFWReadAXL
Return ::cFerrorStr

METHOD GetFSize() CLASS ZFWReadAXL
Return ::nFSize

METHOD _SetError(nCode,cStr) CLASS ZFWReadAXL
	::nFerror := nCode
	::cFerrorStr := cStr
Return

METHOD _SetOSError(nCode,cStr,nOsError) CLASS ZFWReadAXL
	::nFerror := nCode
	::cFerrorStr := cStr
	::nOsError := nOsError
Return

METHOD _CleanLastErr() CLASS ZFWReadAXL
	::nFerror := 0
	::cFerrorStr := ''
	::nOsError := 0
Return
