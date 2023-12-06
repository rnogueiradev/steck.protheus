#Include "Protheus.CH"
#include "fwmvcdef.ch"
#include "topconn.ch"
#INCLUDE "FWPRINTSETUP.CH"
#INCLUDE "RPTDEF.CH"

#DEFINE CSSBOTAO	"QPushButton { color: #024670; "+;
"    border-image: url(rpo:fwstd_btn_nml.png) 3 3 3 3 stretch; "+;
"    border-top-width: 3px; "+;
"    border-left-width: 3px; "+;
"    border-right-width: 3px; "+;
"    border-bottom-width: 3px }"+;
"QPushButton:pressed {	color: #FFFFFF; "+;
"    border-image: url(rpo:fwstd_btn_prd.png) 3 3 3 3 stretch; "+;
"    border-top-width: 3px; "+;
"    border-left-width: 3px; "+;
"    border-right-width: 3px; "+;
"    border-bottom-width: 3px }"

Static oFont07	:= TFont():New("Arial",,05,,.F.,,,,.T.,.F.)
Static oFont07N	:= TFont():New("Arial",,05,,.T.,,,,.T.,.F.)
Static oFont08	:= TFont():New("Arial",,08,,.F.,,,,.T.,.F.)
Static oFont08N	:= TFont():New("Arial",,08,,.T.,,,,.T.,.F.)
Static oFont09	:= TFont():New("Arial",,08,,.F.,,,,.T.,.F.)
Static oFont09N	:= TFont():New("Arial",,08,,.T.,,,,.T.,.F.)
Static oFont10	:= TFont():New("Arial",,10,,.F.,,,,.T.,.F.)
Static oFont10N	:= TFont():New("Arial",,10,,.T.,,,,.T.,.F.)
Static oFont11	:= TFont():New("Arial",,11,,.F.,,,,.T.,.F.)
Static oFont11N	:= TFont():New("Arial",,11,,.T.,,,,.T.,.F.)
Static oFont12	:= TFont():New("Arial",,12,,.F.,,,,.T.,.F.)
Static oFont12N	:= TFont():New("Arial",,12,,.T.,,,,.T.,.F.)
Static oFont16 	:= TFont():New("Arial",,16,,.F.,,,,.T.,.F.)
Static oFont16N	:= TFont():New("Arial",,16,,.T.,,,,.T.,.F.)

Static nClrVerd := RGB(035,142,035)
Static nClrVerm := RGB(217,017,027)
Static nClrBran := RGB(255,255,255)

Static _cServerDir := ""
Static _cMsgInclui := "Só pode ser anexado, após ter gravado o PAA"+CRLF+"Se não foi gravado, não existe numero de PAA para anexar o documento."

/*/{Protheus.doc} User Function STCPAA02
    (long_description)
    Analise de Amostra - PAA
    @author user
    Valdemir Rabelo - SigaMat
    @since 30/07/2019
    u_STCPAA02()
/*/
User Function STCPAA02()
    Local oBrowse
    Local cGerentes := SuperGetMV("ST_PAAGER",.f.,"000009/000084/001024/000402/000294")            // Valdemir Rabelo 05/09/2019
    PRIVATE cTitulo := "Pedido de Análise Amostra - PAA"

    DbSelectArea("Z45")
	DbSelectArea("Z46")

	Z45->(DbSetOrder(1))

	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias("Z45")					// Alias da tabela utilizada
	oBrowse:SetMenuDef("STCPAA02")				// Nome do fonte onde esta a função MenuDef
	oBrowse:SetDescription(cTitulo)
    oBrowse:SetAmbiente(.F.)
    oBrowse:SetWalkThru(.F.)

    if !(__cUserID $ cGerentes)      // Valdemir Rabelo 05/09/2019
        //oBrowse:AddFilter( < cFilter>, < cExpAdvPL>, [ lNoCheck], [ lSelected], [ cAlias], [ lFilterAsk], [ aFilParser], [ cID] )
        oBrowse:AddFilter("Usuarios Permitidos","Z45->Z45_SOLICI=='"+__cUserID+"'.OR. U_VLDZ46('"+__cUserID+"')",.T.,.T.)
    Endif

    oBrowse:AddLegend( "Z45_STATUS == 'P'", "YELLOW", "Em Validação" )
    oBrowse:AddLegend( "Z45_STATUS == 'A'", "BLUE",   "Aguardando Próxima Aprovação" )
    oBrowse:AddLegend( "Z45_STATUS == 'G'", "ORANGE",  "Aguardando Encerramento" )
    oBrowse:AddLegend( "Z45_STATUS == 'E' .and. ALLTRIM(Z45_AGUARD)=='A P R O V A D O'"  , "GREEN",  "Processo Concluído Aprovado" )
    oBrowse:AddLegend( "Z45_STATUS == 'E' .and. ALLTRIM(Z45_AGUARD)=='R E P R O V A D O'", "RED",    "Processo Concluído Reprovado" )

    oBrowse:Activate()

Return


Static Function MenuDef()
	Local aRotina := {}
	//-------------------------------------------------------
	// Adiciona botões do browse
	//-------------------------------------------------------
	ADD OPTION aRotina TITLE 'Pesquisar'        ACTION "AxPesqui"      	  OPERATION 1 ACCESS 0 //"Pesquisar"###"AxPesqui"
	ADD OPTION aRotina TITLE "Visualizar"       ACTION "u_STCPA02I(2)"    OPERATION 2 ACCESS 0 //"Visualizar"
	ADD OPTION aRotina TITLE "Incluir"          ACTION "u_STCPA02I(3)"    OPERATION 3 ACCESS 0 //"Incluir"
	ADD OPTION aRotina TITLE "Validar"          ACTION "u_STCPA02I(4)"    OPERATION 4 ACCESS 0 //"Aprovar"
	ADD OPTION aRotina TITLE "Encerrar"         ACTION "u_STCPA02I(5)"    OPERATION 4 ACCESS 0 //"Encerrar"
	ADD OPTION aRotina TITLE "Alterar"          ACTION "u_STCPA02I(7)"    OPERATION 4 ACCESS 0 //"Alterar"
	ADD OPTION aRotina TITLE "Excluir"          ACTION "u_STCPA02E()"     OPERATION 4 ACCESS 0 //"Excluir"
    ADD OPTION aRotina TITLE "Imprime Analise"  ACTION "u_STCPAIMP()"     OPERATION 6 ACCESS 0 //"Imprimir"
    ADD OPTION aRotina TITLE "Legenda"          ACTION "u_STCPAA2L()"     OPERATION 6 ACCESS 0 //"Legenda"
    ADD OPTION aRotina TITLE "Abrir Anexos"     ACTION "u_STCPAA2A()"     OPERATION 6 ACCESS 0 //"Abrir Anexos"

Return aRotina


/*/{Protheus.doc} User Function STCPAA2L
    (long_description)
    Monta Legenda
    @author user
    Valdemir Rabelo - SigaMat
    @since 30/07/2019
/*/
User Function STCPAA2L()
	Local aLegenda := {}

	//Monta as cores
	AADD(aLegenda,{"BR_AMARELO",    "Em Validação"  })
	AADD(aLegenda,{"BR_AZUL",       "Aguardando Próxima Aprovação"})
    AADD(aLegenda,{"BR_LARANJA",    "Aguardando Encerramento"})
    AADD(aLegenda,{"BR_VERDE",      "Concluído e aprovado"})
    AADD(aLegenda,{"BR_VERMELHO",   "Concluído e reprovado"})

	BrwLegenda("STATUS ANALISE", , aLegenda)
Return


/*/{Protheus.doc} User Function STCPA02I
    (long_description)
    Cria Sub tela para inclusão
    @author user
    Valdemir Rabelo - SigaMat
    @since 31/07/2019
    CallMOd2Obj() - Retorna o Objeto da GetDados
/*/
User Function STCPA02I(pnOPC)
    Local _cTitulo		:= cTitulo
    Local _lRetMod2Ok	:= .F.
    Local _nx			:= 0
    Local _lAchou		:= .F.
    Local _aCpoCab		:= {}
    Local _aCpoRod		:= {}
    Local _aCoord		:= {}
    Local _aTamWnd		:= {}
    Local _cLinhaOk 	:= ".T."
    Local _cTudoOk  	:= "u_VLDTudo()"
    Local _nRecno		:= 0
    Local _nOrder		:= Z45->( IndexOrd() )
    Local _cAlias       := "Z46"
    Local _nOPCGRID     := if( (pnOPC >=3 .and. pnOPC <=4) .or. pnOPC <=7, 4, 2)
    Local cSolPAA       := SuperGetMV("FS_SOLPAA",.F.,"000138/000000")
    Local cPerDepApr    := ""
    Local bF4           := {|| TeclaF4(n) }
    Local aButtons      := {}

	Private _cPath      := GetSrvProfString("RootPath","")
	Private _cStartPath := "\arquivos\PAA\"
    Private _nOpcX      := pnOPC
    Private _aGetSD     := {'Z46_APROVA','Z46_ACLOTE','Z46_COMENT','Z46_RESPON'}
    Private _bWhile		:= { || xFilial("Z46") == Z45->Z45_FILIAL .and. _cCONTRO == Z46->Z46_CONTRO  }
    Private _cCONTRO	:= If( _nOpcX == 3, getNumPrx(), Z45->Z45_CONTRO )
    Private _cSOLICI    := If( _nOpcX == 3, CriaVar("Z45_SOLICI" ), Z45->Z45_SOLICI )
    Private _cNOMSOL    := If( _nOpcX == 3, Space( Len( Z45->Z45_NOMSOL ) ), Z45->Z45_NOMSOL )
    Private _cDEPTO     := If( _nOpcX == 3, Space( Len( Z45->Z45_DEPTO ) ), Z45->Z45_DEPTO )
    Private _cDATA      := If( _nOpcX == 3, dDatabase, Z45->Z45_DATA )
    Private _cPRODUT    := If( _nOpcX == 3, Space( Len( Z45->Z45_PRODUT ) ), Z45->Z45_PRODUT )
    Private _cQTDE      := If( _nOpcX == 3, CriaVar("Z45_QTDE",.T.), Z45->Z45_QTDE )
    Private _cAPLICA    := If( _nOpcX == 3, CriaVar("Z45_APLICA",.T.), Z45->Z45_APLICA )
    Private _cCLASSI    := If( _nOpcX == 3, CriaVar("Z45_CLASSI"), Z45->Z45_CLASSI )
    Private _cFORNED    := If( _nOpcX == 3, CriaVar("Z45_FORNED",.T.), Z45->Z45_FORNED )
    PRIVATE _cLOJAFO    := If( _nOpcX == 3, CriaVar("Z45_LOJAFO",.T.), Z45->Z45_LOJAFO )
    Private _cNOMFOR    := If( _nOpcX == 3, CriaVar("Z45_NOMFOR",.T.), Z45->Z45_NOMFOR )
    Private _cFORNMN    := If( _nOpcX == 3, CriaVar("Z45_FORNED",.T.), Z45->Z45_FORNMN )            // Valdemir Rabelo 04/09/2019
    PRIVATE _cLOJAMN    := If( _nOpcX == 3, CriaVar("Z45_LOJAFO",.T.), Z45->Z45_LOJAMN )
    Private _cNOMFMN    := If( _nOpcX == 3, CriaVar("Z45_NOMFOR",.T.), Z45->Z45_NOMFMN )
    Private _cMOTIVO    := If( _nOpcX == 3, space(100)/*CriaVar("Z45_MOTIVO",.T.)*/, if(Empty(Z45->Z45_MOTIVO),Space(100), Alltrim(Z45->Z45_MOTIVO)) )
    Private _oObj       := nil
    Private aHeader 	:= {}
    Private aCols   	:= {}
    Private aRotina     := {}
    Private _cCpoExc	:= Padr( "Z46_MARKSL"+","+"Z46_ORDEM",10) + "," + Padr( "Z46_FILIAL",10 ) + Padr( "Z46_CONTRO", 10 ) 	/*	Campo que nao devera aparecer na Getdados mesmo estando marcado como 'browse' no SX3 sempre com tamanho 10 */

    dbSelectArea( "Z1A" )
    dbSetOrder(1)
    dbSelectArea( "Z47" )
    dbSetOrder(1)
    dbSelectArea( "Z46" )
    dbSetOrder( 1 )

    INCLUI := (_nOpcX==3)

    IF INCLUI
       _cSOLICI := __cUserID
        if VLDSOL() 
            if !u_VLDGER(_cSOLICI)       
               MsgInfo("Erro")
            Endif
        Endif
    Endif

    // Permissão de aprovação por Departamento
    if _nOpcX == 4
       cPerDepApr := GetDepto(Z45->Z45_AGUARD)
       if Empty(cPerDepApr) .or. (Left(Z45->Z45_AGUARD,10)=="Aguardando")
          cPerDepApr += cSolPAA
       Endif
    endif
    
    aAdd( aRotina, { "Anexar" ,"U_STSF4()", 0, 2 } )

    If !INCLUI
        // Valida acesso
        if (Z45->Z45_STATUS=="E") .AND. (_nOpcX==4)
            FWMsgRun(, {|| Sleep(3000)},"Informação","Não pode aprovar, registro já encerrado")
            Return
        elseif (Z45->Z45_STATUS=="E") .AND. (_nOpcX==5 .or. _nOpcX==7)
            FWMsgRun(, {|| Sleep(3000)},"Informação","Registro já encerrado [ "+DTOC(Z45->Z45_DATENC)+" ]")
            Return
        elseif (Z45->Z45_STATUS=="G") .AND. (_nOpcX==4 .or. _nOpcX==7)
            FWMsgRun(, {|| Sleep(3000)},"Informação","Registro aguardando encerramento, aprovação encerrada")
            Return
        elseif (Z45->Z45_STATUS == 'A') .and. (_nOpcX==7)
            FWMsgRun(, {|| Sleep(3000)},"Informação","Registro já com aprovações não pode ser alterado")
            Return
        elseif (Z45->Z45_STATUS=="P") .AND. (_nOpcX==5)
            FWMsgRun(, {|| Sleep(3000)},"Informação","Registro sem aprovação não pode ser encerrado")
            Return
        elseif  (!(__cUserID $ Z45->Z45_SOLICI) ) .AND. (_nOpcX==7 .or. _nOpcX==5)
            cMsgOPC := if(_nOpcX==7,"alterações","encerramentos")
            FWMsgRun(, {|| Sleep(3000)},"Informação","Usuario não permitido para realizar "+cMsgOPC)
            Return
        elseif  (!(__cUserID $ cPerDepApr) ) .AND. (_nOpcX==4)
            FWMsgRun(, {|| Sleep(3000)},"Informação","Usuario sem permissão p/ aprovações Depto.:"+Alltrim(Z45->Z45_AGUARD))
            Return
        endif
        // Posiciona Registros
        dbSeek( xFilial( "Z46" ) + _cCONTRO )
        _nRecno:= Z45->( Recno())
        Z47->( dbSetOrder(1))
        Z47->( dbSeek(XFilial('Z47')+_cSOLICI))
        //_cDEPTO := Z47->Z47_DEPTO
    Endif

    // Carrega aHeader do Alias a ser usado na Getdados
    aHeader := CargaHeader( _cAlias, _cCpoExc )

    If _nOpcX == 3
        aCols := CarIncCols( _cAlias, aHeader, "", 4, _cCpoExc )
    else
        aCols := CargaCols( aHeader, _cAlias, 1, xFilial( "Z46" ) + _cCONTRO, _bWhile, _cCpoExc )
    ENDIF

    // Monta Cabeçalho
    MntCabec(@_aCpoCab)

    // Coordenadas
    _aCoord := { C(203), C(005), C(118), C(315) }
    _aTamWnd:= { C(100), C(100), C(400), C(750) }
    
    AAdd(aButtons, { "F10_AMAR" ,{||Eval(bF4)}, "Anexar", "Anexar Documentos"} )

    /*
        Exibe tela estilo modelo2. Parametros:

        cTitulo  = Titulo da Janela
        aC       =  Array com campos do Cabecalho
        aR       =  Array com campos do Rodape
        aCGD     =  Array com coordenadas da Getdados
        nOpcx    =  Modo de Operacao
        cLineOk  =  Validacao da linha do Getdados
        cAllOk   =  Validacao de toda Getdados
        aGetSD   =  Array com gets editaveis
        bF4      =  Bloco de codigo para tecla F4
        cIniCpos =  String com nome dos campos que devem ser inicializados ao teclar seta para baixo
        lDelGetD =  Determina se as linhas da Getdados podem ser deletadas ou nao.
    */

    _lRetMod2Ok := Modelo2( _cTitulo, _aCpoCab , _aCpoRod, _aCoord, _nOPCGRID, _cLinhaOk, _cTudoOk,_aGetSD, bF4, "", 9999, _aTamWnd,,.T.,aButtons )

    If _lRetMod2Ok

        Begin Transaction
            // Realiza a gravação / atualização
            grvZ4546()

        End Transaction

        if _nOpcX != 5
            // Verifico e disparo o workflow seguindo a ordem
            MsgRun("Aguarde, Enviando e-mail para o responsável do departamento","Informação", {|| VerifFW()})
        endif

        dbSelectArea( "Z45" )
        dbGoto( _nRecno )
        IF INCLUI
            _cCONTRO := getNumPrx()
            RollBackSX8()
        Endif

    Endif

    Z45->( dbSetOrder( _nOrder ) )

Return

User Function VLDTudo()
    Local lRET    := .T.
    Local nTotLin := 0

    lRET := (!Empty(_cCONTRO)) .and. (!Empty(_cSOLICI)) .and. (!Empty(_cDEPTO)) .and. (!Empty(_cDATA)) .and.;
            (!Empty(_cPRODUT)) .and. (!Empty(_cQTDE))   .and. (!Empty(_cAPLICA)) .and. (!Empty(_cNOMFOR))

    if !lRET
        MsgRun("Existe campos obrigatórios a serem preenchido, verifique!","Informação", {|| sleep(3000)})
    else
        aEVAL(aCols, {|X| if( !Empty(X[1]),nTotLin++,0) })
        lRet := (nTotLin > 0)
        if !lRET
            MsgRun("Não foi informado nenhum departamento, por favor verifique!","Informação", {|| sleep(3000)})
        endif
    Endif

Return lRET

/*/{Protheus.doc} User Function MntCabec
    (long_description)
    Monta Cabecalho
    @author user
    Valdemir Rabelo - SigaMat
    @since 31/07/2019
/*/
Static Function MntCabec(_aCpoCab)

    /*
    Array para get no cabecalho da Tela estilo modelo2. Parametros:
    aC[n,1] =  Nome da Variavel Ex.:"cCliente"
    aC[n,2] =  Array com coordenadas do Get [x,y], em Windows estao em PIXEL
    aC[n,3] =  Titulo do Campo
    aC[n,4] =  Picture
    aC[n,5] =  Nome da funcao para validacao do campo
    aC[n,6] =  F3
    aC[n,7] =  Se campo e' editavel .t. se nao .f.
    */
    AADD( _aCpoCab,{ "_cCONTRO"   	,{ C(15), C(010) } , OemToAnsi("Nro.Controle")	, "@E 999999999", '.T.'	,""	, .F.})
    AADD( _aCpoCab,{ "_cSOLICI"   	,{ C(15), C(130) } , OemToAnsi("Solicitante")	, "@!"    , "", ""	, .F.})
    AADD( _aCpoCab,{ "_cNOMSOL" 	,{ C(15), C(230) } , OemToAnsi("Nome Solic")    , "@!"    , , ,.F.})

    AADD( _aCpoCab,{ "_cDEPTO"   	,{ C(30), C(010) } , OemToAnsi("Depto.")	    , "@!"    , "NAOVAZIO() .and. u_VLDGER('_cDEPTO')"	,""	  , .F.})
    AADD( _aCpoCab,{ "_cDATA"   	,{ C(30), C(130) } , OemToAnsi("Data")	        , "@D 99/99/9999", "u_VLDGER('_cDATA')"	,""	  , If( _nOpcX == 3, .T., .F. )})
    AADD( _aCpoCab,{ "_cPRODUT"   	,{ C(30), C(230) } , OemToAnsi("Produto")       , "@!"    , "NAOVAZIO( ) .and. u_VLDGER('_cPRODUT')"	,""	  , If( _nOpcX == 3 .or. _nOpcX == 7, .T., .F. )})

    AADD( _aCpoCab,{ "_cQTDE"   	,{ C(45), C(010) } , OemToAnsi("Quantidade")    , "@E 999999999", "u_VLDGER('_cQTDE')"	,""	  , If( _nOpcX == 3 .or. _nOpcX == 7, .T., .F. )})
    AADD( _aCpoCab,{ "_cAPLICA"   	,{ C(45), C(130) } , OemToAnsi("Aplicar em")    , "@!"    , "NAOVAZIO() .and. u_VLDGER('_cAPLICA')"	,""	  , If( _nOpcX == 3 .or. _nOpcX == 7, .T., .F. )})
    AADD( _aCpoCab,{ "_cCLASSI"   	,{ C(45), C(380) } , OemToAnsi("Classificar")   , "@!"    , 'NAOVAZIO()'	,""	  , .F. })

    AADD( _aCpoCab,{ "_cFORNED"   	,{ C(60), C(010) } , OemToAnsi("Fornec. SP")    , "@!"    , "u_VLDFOR('_cFORNED')", "SA2", If( _nOpcX == 3 .or. _nOpcX == 7, .T., .F. )})
    AADD( _aCpoCab,{ "_cLOJAFO"   	,{ C(60), C(090) } , OemToAnsi("Loja")          , "@!"    , , , If( _nOpcX == 3, .T., .F. )})
    AADD( _aCpoCab,{ "_cNOMFOR"   	,{ C(60), C(130) } , OemToAnsi("Nome Fornedor") , "@!"    , ''	,""   ,If( _nOpcX == 3 .or. _nOpcX == 7, .T., .F. )})

    AADD( _aCpoCab,{ "_cFORNMN"   	,{ C(75), C(010) } , OemToAnsi("Fornec. MN")    , "@!"    , "u_VLDFOR('_cFORNMN')", "SA2MN", If( _nOpcX == 3 .or. _nOpcX == 7, .T., .F. )})
    AADD( _aCpoCab,{ "_cLOJAMN"   	,{ C(75), C(090) } , OemToAnsi("Loja")          , "@!"    , , , If( _nOpcX == 3, .T., .F. )})
    AADD( _aCpoCab,{ "_cNOMFMN"   	,{ C(75), C(130) } , OemToAnsi("Nome Fornedor") , "@!"    , ''	,""   ,If( _nOpcX == 3 .or. _nOpcX == 7, .T., .F. )})

    AADD( _aCpoCab,{ "_cMOTIVO"   	,{ C(90), C(010) } , OemToAnsi("Motivo")        , "@!"    , 'U_VLDNOM()'	,""   ,If( _nOpcX == 3 .or. _nOpcX == 7, .T., .F. )})

Return


/*/{Protheus.doc} User Function MntCabec
    (long_description)
    retorna Array com cabecalho para os itens
    @author user
    Valdemir Rabelo - SigaMat
    @since 31/07/2019
/*/
Static Function CargaHeader( _cAlias, _cCpoExc )
Local _aHeader 	:= {}
Local _nUsado	:= 0
//_oObj := CallMod2Obj()
//_oObj:oBrowse:lUseDefaultColors := .F.
//_oObj:SetBlkBackColor({|| GETDCLR(_oObj:nAt,8421376)})

dbSelectArea( "SX3" )
dbSetOrder(1)
dbSeek( _cAlias )

While !Eof() .and. X3_ARQUIVO == _cAlias

	If X3USO( X3_USADO ) .and. cNivel >= X3_NIVEL .and. !( X3_CAMPO $ _cCpoExc )
		_nUsado++
		AADD( _aHeader, { 	Trim( X3Titulo() ),;
		               		X3_CAMPO    ,;
		               		X3_PICTURE  ,;
		               		X3_TAMANHO  ,;
		               		X3_DECIMAL  ,;
		               		X3_VALID    ,;
		               		X3_USADO    ,;
		               		X3_TIPO     ,;
		               		X3_ARQUIVO  ,;
		               		X3_CONTEXT  } )
	Endif

	dbSkip()

Enddo

Return( _aHeader )


/*/{Protheus.doc} User Function CarIncCols
    (long_description)
    Rotina que carrega a variavel array aCols com valores iniciais na
    Inclusão de Registro
    @author user
    Valdemir Rabelo - SigaMat
    @since 31/07/2019
/*/
Static Function CarIncCols( _cAlias, _aHeader, _cCpoItem, _nTamCpoItem, _cCpoExc )
Local _aArea			:= GetArea()
Local _nUsado			:= 0
Local _aCols			:= {}

Default _cCpoItem		:= ""
Default _nTamCpoItem	:= 3

dbSelectArea( "SX3" )
dbSeek( _cAlias )
aAdd( _aCols, Array( Len( _aHeader ) +1 ) )

Do While !Eof() .and. X3_ARQUIVO == _cAlias

	If X3USO( X3_USADO ) .and. cNivel >= X3_NIVEL .and. !( X3_CAMPO $ _cCpoExc )

		_nUsado++
		If X3_TIPO == "C"
			If Trim(aHeader[_nUsado][2]) == _cCpoItem
				_aCols[ 1, _nUsado ] := StrZero( 1, _nTamCpoItem )
			Else
				_aCols[ 1, _nUsado ] := Space( X3_TAMANHO )
			Endif
		Elseif X3_TIPO == "N"
			_aCols[ 1, _nUsado ] := 0
		Elseif X3_TIPO == "D"
			_aCols[ 1, _nUsado ] := dDataBase
		Elseif X3_TIPO == "M"
			_aCols[ 1, _nUsado ] := CriaVar( AllTrim( X3_CAMPO ) )
		Else
			_aCols[ 1, _nUsado ] := .F.
		Endif
		If X3_CONTEXT == "V"
			_aCols[ 1, _nUsado ] := CriaVar( AllTrim( X3_CAMPO ) )
		Endif

	Endif

	dbSkip()

Enddo

_aCols[ 1, _nUsado +1 ] := .F.

RestArea( _aArea )

Return( _aCols )


/*/{Protheus.doc} User Function CargaCols
    (long_description)
    Rotina para carregar os dados de um determinado alias ( baseado no
    Header ) para a Getdados usada ( alteracao, exclusao, visual )
    @author user
    Valdemir Rabelo - SigaMat
    @since 31/07/2019
/*/
Static Function CargaCols( _aHeader, _cAlias, _nIndice, _cChave, _bWhile, _cCpoExc  )
Local _aArea	:= GetArea()
Local _nUsado	:= 0
Local _nCnt		:= 0
Local _aCols	:= {}
Local _cDepto   := ""

aAreaZ47 := GetArea()
_cDepto  := ""
dbSelectArea("Z47")
dbSetOrder(1)
lRET := dbSeek(XFilial("Z47")+__cUserID)
cNomRes := Z47->Z47_NOMUSU
Z47->( dbEVal({ || _cDepto += Left(Z47_DEPTO,15), if(!Empty(_cDepto),_cDepto += "/",nil) },,{ || !Eof() .and. Z47_USUARI==__cUserID }))
RestArea( aAreaZ47)

dbSelectArea( _cAlias )
dbSetOrder( _nIndice )
dbSeek( _cChave )

Do While Eval( _bWhile )

	aAdd( _aCols, Array( Len( _aHeader ) +2 ) )
	_nCnt++
	_nUsado := 0
	dbSelectArea( "SX3" )
	dbSeek( _cAlias )

	Do While !Eof() .and. X3_ARQUIVO == _cAlias


		If X3USO( X3_USADO ) .and. cNivel >= X3_NIVEL .and. !( Alltrim(X3_CAMPO) $ _cCpoExc )
			_nUsado++
			_cVarTemp := _cAlias + "->" + ( X3_CAMPO )
			If X3_CONTEXT # "V"
				_aCols[ _nCnt, _nUsado ] := &_cVarTemp
			Elseif X3_CONTEXT == "V" .and. !Empty(SX3->X3_INIBRW)
				_aCols[ _nCnt, _nUsado ] := Eval( &( "{|| " + _cAlias + "->(" + SX3->X3_INIBRW + ") }" ) )
            Endif
            if (X3_CAMPO=="Z46_RESPON") .and. Empty(&_cVarTemp)  // Adicionado 03/09/2019
                // Verifica se o usuário logado, faz parte do departamento
                If SX3->X3_CONTEXT # "V"
                    if lRET .and. (Left(alltrim(_aCols[_nCnt, 1]),15) $ _cDepto) .and. !Empty(_aCols[_nCnt][GDFieldPos("Z46_RECEBI")])
                        _aCols[ _nCnt, _nUsado ] := __cUserID
                    Endif
                Endif
            Endif
        Endif

		DBSkip()

    Enddo
    if !Empty(_aCols[_nCnt][GDFieldPos("Z46_RESPON")]) .and. Empty(_aCols[_nCnt][GDFieldPos("Z46_NOMRES")]) .and. !Empty(_aCols[_nCnt][GDFieldPos("Z46_RECEBI")])
        _aCols[_nCnt][GDFieldPos("Z46_NOMRES")] := cNomRes
    Endif

	_aCols[ _nCnt, Len(_aCols[_nCnt])-1 ] := (_cAlias)->Z46_ORDEM
	_aCols[ _nCnt, Len(_aCols[_nCnt]) ]   := .F.
	dbSelectArea( _cAlias )
	dbSkip()

Enddo

aSort(_aCols,,,{|X,Y| X[ Len(_aCols[1])-1] < Y[Len(_aCols[1])-1] })

RestArea( _aArea )

Return( _aCols )

/*/{Protheus.doc} User Function VLDSOL
    (long_description)
    Valida Solicitante
    @author user
    Valdemir Rabelo - SigaMat
    @since 31/07/2019
/*/
Static Function VLDSOL()
    Local lRET := .T.
    Local nPos := 0
    Local aUsr := FWSFALLUSERS()

    nPos := aScan(aUsr, {|x| x[2]==_cSolici }) 
    lRET := (nPos > 0)
    if lRET
        _cNomSol := UsrRetName(_cSolici)
        _cDEPTO := aUsr[nPos][6] //Z47->Z47_DEPTO
    else
        MsgRun("Usuário não localizado","Atenção!",{|| sleep(3000)})
    endif

return lRET


/*/{Protheus.doc} User Function VLDFOR
    (long_description)
    Valida Fornecedor
    Header ) para a Getdados usada ( alteracao, exclusao, visual )
    @author user
    Valdemir Rabelo - SigaMat
    @since 31/07/2019
/*/
User Function VLDFOR(pcCampo)
    Local lRET  := .F.
    Local cNome := if(pcCampo=="_cFORNED","_cNomFor","_cNomFMN")
    Local cLoja := if(pcCampo=="_cFORNED","_cLojaFor","_cLojaMN")
    Local aDados:= if( (pcCampo != "_cFORNED") .and. !Empty(&(pcCampo)),RetForMN(&(pcCampo)),{} )

    if !Empty(&pcCampo)
        if (pcCampo=="_cFORNED")
            &(cNome) := Posicione("SA2",1,xFilial("SA2")+&(pcCampo),"A2_NOME")
            &(cLoja) := Posicione("SA2",1,xFilial("SA2")+&(pcCampo),"A2_LOJA")
        else
            if !Empty(aDados)
                &(cNome) := aDados[1]
                &(cLoja) := aDados[2]
            endif
        endif
        lRET := (!Empty(&(cNome)))
    Endif

    if !lRET
        if !Empty(&(pcCampo))
            MsgRun("Fornecedor não encontrado","Atenção!",{|| sleep(3000)})
        endif
        &(pcCampo) := Space(6)
    else
       // SelEnvdo()
    endif
    GetDRefresh()

return .t.

User Function VLDNOM()
    SelEnvdo()
    GetDRefresh()
Return .T.


/*/{Protheus.doc} User Function VLDGER
    (long_description)
    Valida os campos cabeçalho
    @author user
    Valdemir Rabelo - SigaMat
    @since 31/07/2019
/*/
User Function VLDGER(pCampo)
    Local lRet := .T.

    if (pCampo=="_cAPLICA")
        SelClassif()
    endif

Return .T.


/*/{Protheus.doc}  Function SelClassif
    (long_description)
    Interface de Seleção da Classificação Produto
    @author user
    Valdemir Rabelo - SigaMat
    @since 31/07/2019
/*/
Static Function SelClassif()
    Local oBotao
    Local oList
    Local aVetor := {}
    Local nList  := 1
    Static oDlg

    // Opções para Seleção
    aAdd(aVetor, {'F','Fabricado'})
    aAdd(aVetor, {'C','Comprado'})
    aAdd(aVetor, {'I','Importado'})

    DEFINE MSDIALOG oDlg TITLE "Selecione a Classificação" FROM 000, 000  TO 240, 270 COLORS 0, 16777215 PIXEL

        @ 005, 006 LISTBOX oList VAR nList FIELDS Header "Codigo","Descrição" SIZE 120, 081 OF oDlg PIXEL  ON dblClick( Clicado(oList, aVetor), oDlg:End() )
        @ 096, 045 BUTTON oBotao PROMPT "OK" SIZE 037, 012 OF oDlg ACTION (Clicado(oList, aVetor), oDlg:End()) PIXEL
        oList:SetArray(aVetor)
        oList:bLine := {|| { aVetor[oList:nAt,1], aVetor[oList:nAt,2] }}

      ACTIVATE MSDIALOG oDlg CENTERED

Return

/*/{Protheus.doc}  Function Clicado
    (long_description)
    Evento ao dar duplo clique na selação
    @author user
    Valdemir Rabelo - SigaMat
    @since 31/07/2019
/*/
static Function Clicado(oList, aVetor)
    _cCLASSI := aVetor[oList:nAt,2]
Return




/*/{Protheus.doc}  Function SelEnvdo
    (long_description)
    Interface para seleção dos departamentos
    @author user
    Valdemir Rabelo - SigaMat
    @since 31/07/2019
/*/
Static Function SelEnvdo()
    Local oBotao
    Local oList
    Local oChk
    Local lChk   := .F.
    Local nList  := 1
    Local aVetor := {}
    Static oDlg
    Private oOk	 := LoadBitmap(GetResources(),"LBOK")
    Private oNo	 := LoadBitmap(GetResources(),"LBNO")

    SetKey(VK_F5, {|| DLCEBALT(aVetor,oList)} )

    MntDeto(@aVetor)

    DEFINE MSDIALOG oDlg TITLE "Selecione os Envolvidos" FROM 000, 000  TO 250, 430 COLORS 0, 16777215 PIXEL

        @ 005, 006 LISTBOX oList VAR nList FIELDS Header "","Departamento","Ordem" alPixel(.F.) SIZE 210, 90 OF oDlg PIXEL  ON dblClick( IIF( aVetor[oList:nAt,4] != "EGI",aVetor[oList:nAt,1] := !aVetor[oList:nAt,1], aVetor[oList:nAt,1] :=.T.), HabGer(@aVetor),oList:DrawSelect() )
        @ 100, 006 CHECKBOX oChk    VAR lChk    Prompt "Marca/Desmarca"    SIZE 60,007 PIXEL Of oDlg On Click(aEval(aVetor,{|x| x[1] := lChk, HabGer(@aVetor) }),oList:Refresh())
        @ 100, 190 Say  "F5-Editar"    SIZE 60,007 PIXEL Of oDlg COLOR CLR_HRED

        @ 108, 095 BUTTON oBotao PROMPT "OK" SIZE 037, 012 OF oDlg ACTION ConfOK(oDlg, aVetor) PIXEL
        oList:SetArray(aVetor)
        oList:bLine := {|| { Iif(aVetor[oList:nAt,1],oOk,oNo), aVetor[oList:nAt,2], aVetor[oList:nAt,3] }}
    ACTIVATE MSDIALOG oDlg CENTERED

    SetKey(VK_RETURN, {|| NIL } )

Return aVetor

/*/{Protheus.doc}  Function HabGer
    (long_description)
    Valida Seleção de Gerente
    @author user
    Valdemir Rabelo - SigaMat
    @since 31/07/2019
/*/
Static Function HabGer(aVetor)
    //aEval(aVetor, {|X| iif(X[4]=="EGI", X[1] := .T.,) })
Return



/*/{Protheus.doc}  Function ConfOK
    (long_description)
Evento do botão OK - após seleção
    @author user
    Valdemir Rabelo - SigaMat
    @since 31/07/2019
/*/
Static Function ConfOK(oDlg, aVetor)
   Local nSel    := nTotLin := 0
   Local lExiste := .T.
   Local nUltLin
   Local nx
    // Verifico se foi selecionado algum registro
   aEval(aVetor, {|X| if(X[1],nSel++,nil) })

   if Len(aVetor)==0
      MsgRun("Não foi cadastrado usuários e seus departamentos. Por favor, verifique...","Atenção!", {|| sleep(3000)})
        oDlg:End()
   elseif nSel == 0
      MsgRun("Não foi selecionado nenhum registro. ","Atenção!", {|| sleep(3000)})
   else
      // Ajusta a ordem em caso de ter sido alterado pelo usuário
      asort(aVetor,,, {|X,y| X[3] < Y[3]})
      lExiste := .f.
      // Valida se foi selecionado algum gerente - pcp - Leandro Godoy Ticket 20220610011941
      
     aEval(aVetor, {|X| if(X[1] .and. Left(X[2],3)=="PLA", lExiste := .T., NIL) })
      if !lExiste
            MsgRun("É obrigatório selecionar o PCP. Por favor, verifique. ","Atenção!", {|| sleep(3000)})
         Return
      endif
      nTotLin := 0
      aEVAL(aCols, {|X| if( !Empty(X[1]),nTotLin++,0) })
      if (nTotLin > 0)
         lExiste := MSGNOYES("Deseja atualizar os dados existentes?","Atenção!")
         if lExiste
            AEVAL( aCols, {|X| X[Len(aCols[1])] := .T. } )    // Deleto todos os registros
         endif
      else
        aCols := {}
      Endif

      if lExiste
         // Alimento o registro
         For nX := 1 to Len(aVetor)
            if aVetor[nX][1]
                aAdd(aCols, Array(Len(aHeader)+2) )
                nUltLin := Len(aCols)
                aCols[nUltLin][01] := aVetor[nX][2]
                aCols[nUltLin][02] := CriaVar(aHeader[2][2])
                aCols[nUltLin][03] := CriaVar(aHeader[3][2])
                aCols[nUltLin][04] := CriaVar(aHeader[4][2])
                aCols[nUltLin][05] := CriaVar(aHeader[5][2],.T.)
                aCols[nUltLin][06] := CriaVar(aHeader[6][2])
                aCols[nUltLin][07] := CriaVar(aHeader[7][2])
                aCols[nUltLin][08] := CriaVar(aHeader[8][2],.T.)
                aCols[nUltLin][09] := "N"
                aCols[nUltLin][10] := aVetor[nX][3]
                aCols[nUltLin][11] := .F.
            endif
         Next
      Endif
      oDlg:End()
      GetDRefresh()
   endif

Return

/*/{Protheus.doc}  Function MntDeto
    (long_description)
    Monta os departamentos
    @author user
    Valdemir Rabelo - SigaMat
    @since 31/07/2019
/*/

Static Function MntDeto(aVetor)
    Local aArea  := GetArea()
    Local nConta := 17
	Local nPos	 := 0
	Local nX
    dbSelectArea("SX5")
    dbSetOrder(1)
    dbSeek(XFilial("SX5")+'Z3')
    // Opções para Seleção - Alteração Leandro Godoy - 20220628012957
    aAdd(aVetor, {.f.,'' ,01,'EGP'})
    aAdd(aVetor, {.f.,'' ,02,'CQF'})
    aAdd(aVetor, {.f.,'' ,03,'COM'})
    aAdd(aVetor, {.f.,'' ,04,'CQL'})
    aAdd(aVetor, {.f.,'' ,05,'ENP'})
    aAdd(aVetor, {.f.,'' ,06,'PCP'})
    aAdd(aVetor, {.f.,'' ,07,'PRD'})
    aAdd(aVetor, {.f.,'' ,08,'SEG'})
    aAdd(aVetor, {.f.,'' ,09,'CMX'})
    aAdd(aVetor, {.f.,'' ,10,'EGP-M'})
    aAdd(aVetor, {.f.,'' ,11,'CQF-M'})
    aAdd(aVetor, {.f.,'' ,12,'COM-M'})
    aAdd(aVetor, {.f.,'' ,13,'CQL-M'})
    aAdd(aVetor, {.f.,'' ,14,'ENP-M'})
    aAdd(aVetor, {.f.,'' ,15,'PCP-M'})
    aAdd(aVetor, {.f.,'' ,16,'PRD-M'})
    aAdd(aVetor, {.f.,'' ,17,'SEG-M'})
    


    While !Eof() .and. SX5->X5_TABELA=='Z3'
        IF !(ALLTRIM(SX5->X5_CHAVE) $ "GCM/GLO/GMK")
            nPos := aScan(aVetor, {|X| ALLTRIM(X[4]) == ALLTRIM(SX5->X5_CHAVE) })
            IF nPos > 0
                aVetor[nPos][2] := SX5->X5_DESCRI
            Else
                aAdd(aVetor, {.f.,SX5->X5_DESCRI, nConta,StrZero(nConta,3)})
                nPos := Len(aVetor)
                nConta++
            Endif
            /*    Removido por mudança no processo 06/09/2019
            if aVetor[nPos][4]=="EGI"
                aVetor[nPos][1] := .T.
            endif
            */
        endif
        dbSkip()
    EndDo

    // Se existe registro, marco os que existirem

    if Len(aCols) > 0
        nTam := TamSX3("Z46_DEPTO")[1]
        For nX := 1 to Len(aCols)
            IF !aCols[nX][Len(aCols[nX])]
                nPos := aScan(aVetor, { |X| Left(alltrim(X[2]),nTam)==Left(alltrim(aCols[nX][1]),nTam) })
                if nPos > 0
                aVetor[nPos][1] := .T.
                endif
            Endif
        Next
     Endif

    RestArea( aArea )

Return

/*/{Protheus.doc}  Function DLCEBALT
    (long_description)
    Evento para editar celular
    @author user
    Valdemir Rabelo - SigaMat
    @since 31/07/2019
/*/
Static Function DLCEBALT(aWBrowse1,oWBrowse1)
	Local _Campo := aWBrowse1[oWBrowse1:nAt][3]
	lEditCell( @aWBrowse1, oWBrowse1, "@E 99", 3 )

    oWBrowse1:Refresh()
Return


/*/{Protheus.doc}  Function grvZ4546
    (long_description)
    Grava e controla as tabelas
    @author user
    Valdemir Rabelo - SigaMat
    @since 31/07/2019
/*/
Static Function grvZ4546(paCols)
    Local nX      := 0
    Local nAberto := 0
    Local nOpcLote:= 0
    Local aAreaZ  := GetArea()
    Local lInclui := .F.
    Local cAguard := ""
    Local cAddLot := ""

    IF !INCLUI
        aEval(aCols, {|X| iif(X[GDFieldPos("Z46_APROVA")]=="N" .and. (Z45->Z45_STATUS $ "P/A") .and. X[Len(aCols[1])]==.F., nAberto++,0) })
        IF !( nAberto <= LEN(aCols) .and. nAberto > 0 )
           nAberto := 0
        Endif
    Else
        _cCONTRO := GetSxeNum("Z45", "Z45_CONTRO")
        ConfirmSX8()
    ENDIF

    // Atualizo o Cabecalho
    dbSelectArea("Z45")
    dbSetOrder(1)
    lInclui := (!dbSeek(xFilial("Z45")+_cCONTRO))

    if _nOpcX == 5

        aEVal(aCols, {|X| if(X[GDFieldPos("Z46_ACLOTE")]="S" .and. X[Len(aCols[1])]==.F., nX++, nil) } )
        if nX > 0
            nOpcLote := Aviso( "Acompanha Lote", 'Deseja iniciar o Lote com base nos registros marcados?', { "Sim", "Não" } )
            If nOpcLote == 1
                cAddLot := "X"
            Endif
        Endif

    endif

    RecLock("Z45", lInclui)
    if lInclui
        Z45->Z45_FILIAL := XFILIAL("Z45")
        Z45->Z45_CONTRO := _cCONTRO
        Z45->Z45_STATUS := "P"
    endif
    Z45->Z45_SOLICI := _cSOLICI
    Z45->Z45_NOMSOL := _cNOMSOL
    Z45->Z45_DEPTO  := _cDEPTO
    Z45->Z45_DATA   := _cDATA
    Z45->Z45_PRODUT := _cPRODUT
    Z45->Z45_QTDE   := _cQTDE
    Z45->Z45_APLICA := _cAPLICA
    Z45->Z45_CLASSI := _cCLASSI
    Z45->Z45_FORNED := _cFORNED
    Z45->Z45_LOJAFO := _cLOJAFO
    Z45->Z45_NOMFOR := _cNOMFOR
    Z45->Z45_FORNMN := _cFORNMN   // 04/09/2019
    Z45->Z45_LOJAMN := _cLOJAMN
    Z45->Z45_NOMFMN := _cNOMFMN
    Z45->Z45_MOTIVO := _cMOTIVO
    if _nOpcX==5 // Aguardando Encerramento
        Z45->Z45_STATUS := "E"
        Z45->Z45_DATENC := dDATABASE
        Z45->Z45_ADDLOT := cAddLot
        Z45->Z45_AGUARD := gVLDAPROV()
        //IF(aCols[ LEN(aCOLS) ][GDFieldPos("Z46_APROVA")]=='A', "A P R O V A D O","R E P R O V A D O")   //"Processo Encerrado"
    endif
    Z45->( MsUnlock() )
    Z45->( dbCommit() )

    // Inicio a Atualização dos Aprovadores
    dbSelectArea("Z46")
    dbSetOrder(1)

    For nX := 1 to Len(aCols)
        lInclui := (!dbSeek(xFilial("Z46")+_cCONTRO+aCols[nX][1]))
        if !aCols[nX][Len(aCols[nX])]   // Verifico se está deletado
            RecLock('Z46',lInclui)
            if lInclui
                Z46->Z46_FILIAL := XFILIAL('Z46')
                Z46->Z46_CONTRO := _cCONTRO
                Z46->Z46_DEPTO  := aCols[nX][GDFieldPos("Z46_DEPTO")]
                Z46->Z46_ENVMAI := "N"
                Z46->Z46_ORDEM  := aCols[nX][Len(aCols[nX])-1]
            endif
            //Z46->Z46_RECEBI := aCols[nX][GDFieldPos("Z46_RECEBI")]
            Z46->Z46_APROVA := aCols[nX][GDFieldPos("Z46_APROVA")]
            Z46->Z46_COMENT := aCols[nX][GDFieldPos("Z46_COMENT")]
            Z46->Z46_RESPON := aCols[nX][GDFieldPos("Z46_RESPON")]
            Z46->Z46_NOMRES := aCols[nX][GDFieldPos("Z46_NOMRES")]
            Z46->Z46_DATAPR := aCols[nX][GDFieldPos("Z46_DATAPR")]
            Z46->Z46_ACLOTE := aCols[nX][GDFieldPos("Z46_ACLOTE")]
            Z46->( MsUnlock() )
            //
            if (inclui .and. nX==1)
                cAguard := ALLTRIM(aCols[nX][GDFieldPos("Z46_DEPTO")])
            endif
        else
            if !lInclui
                RecLock('Z46',lInclui)
                Z46->( dbDelete() )
                Z46->( MsUnlock() )
            Endif
        Endif
    Next

    // Atualiza Cabeçalho
    if lInclui
        RecLock("Z45",.f.)
        Z45->Z45_AGUARD := cAguard
        Z45->( MsUnlock() )
        Z45->( dbCommit() )
    Endif
    dbCommitAll()

    RestArea( aAreaZ )

Return


/*/{Protheus.doc}  Function getNumPrx
    (long_description)
    Gera o proximo numero
    @author user
    Valdemir Rabelo - SigaMat
    @since 31/07/2019
/*/
Static Function getNumPrx()
    Local nRET     := 0

    nRET := GetSxeNum("Z45", "Z45_CONTRO")
    RollbackSX8()

Return nRET


/*/{Protheus.doc}  Function VerifFW
    (long_description)
    Verifica Workflow
    @author user
    Valdemir Rabelo - SigaMat
    @since 31/07/2019
/*/
Static Function VerifFW()
    Local nLin       := 0
    Local aAreaVerif := GetArea()
    Local cUsuEnv    := ""
    Local cEmailEnv  := ""
    Local cGerPrinc  := SuperGetMV("FS_GERPRIN",.F.,"EGI")
    Local cDeptoX5   := ""
    Local nSelec     := 0
    Local nAberto    := 0
    Local nPos       := 0

    Z47->( dbSetOrder(3) )
    // Verificar quem será o proximo a receber o WF
    For nLin := 1 to Len(aCols)
        // Localizo o Departamento
        lAchou := Z47->( dbSeek(xFilial("Z47")+LEFT(Alltrim(aCols[nLin][GDFieldPos("Z46_DEPTO")]),TAMSX3('Z47_DEPTO')[1]) ) )
        // Localiza Aprovador
        lZ46   := Z46->( dbSeek(xFilial("Z46")+_cCONTRO+aCols[nLin][1]) )
        //
        if (Empty(aCols[nLin][GDFieldPos("Z46_RESPON")]) .and. (aCols[nLin][GDFieldPos("Z46_ENVMAI")] == "N")) .OR.;
            (Empty(aCols[nLin][GDFieldPos("Z46_RESPON")]) .and. (aCols[nLin][GDFieldPos("Z46_ENVMAI")] == "S"))

            IF ((aCols[nLin][GDFieldPos("Z46_APROVA")]=="N") .and. (aCols[nLin][GDFieldPos("Z46_ENVMAI")] == "S"))
               IF !MSGNOYES("Deseja Reenviar e-mail para departamento <b>"+Alltrim(aCols[nLin][GDFieldPos("Z46_DEPTO")])+"</b>?", "Informação" )
                  Exit
               ENDIF
            ENDIF
           // Localizo o usuário pelo Departamento
           if !lAchou
              MsgRun("Departamento não encontrado","Atenção", {|| sleep(3000)})
              exit
           else
             if _nOpcX != 5
                cUsuEnv   := Z47->Z47_USUARI
                cEmailEnv := GMailDep(Z47->Z47_DEPTO)
                EMailPAA(cUsuEnv, cEmailEnv, aCols[nLin])
                // Posiciono para atualizar tabela
                if lZ46
                    RecLock("Z46",.F.)
                    Z46->Z46_ENVMAI := "S"
                    Z46->Z46_RECEBI := dDATABASE
                    MsUnlock()
                    RecLock("Z45",.F.)
                    Z45->Z45_AGUARD := ALLTRIM(aCols[nLin][GDFieldPos("Z46_DEPTO")])
                    MsUnlock()
                Endif
                Exit
             endif
           ENDIF
        ELSEIF (!Empty(aCols[nLin][GDFieldPos("Z46_RESPON")]) .and. (aCols[nLin][GDFieldPos("Z46_ENVMAI")] == "S"))
           // Localizo o usuário pelo Departamento
           if !lAchou
              MsgRun("Departamento não encontrado","Atenção", {|| sleep(3000)})
              exit
           else
                if _nOpcX != 5
                    cDeptoX5  := GetSX5(Z47->Z47_DEPTO)
                    if (alltrim(cDeptoX5) $ alltrim(cGerPrinc))
                        // atualizo marcando que foi enviado e-mail
                        if lZ46
                            cEmailEnv :=""
                            // Verifico se foi marcado mais algum Gerente
                            if EMPTY(Z46->Z46_MARKSL)
                                RECLOCK("Z46", .F.)
                                Z46->Z46_MARKSL := "X"
                                MSUNLOCK()
                                //
                                aEnvOutr := OPCENV()
                                aEval(aEnvOutr, {|X| if(X[1], nSelec++,nil)} )
                                if nSelec > 0
                                    GrvOPC(aEnvOutr)
                                else
                                    cUsuEnv   := Z47->Z47_USUARI
                                    cEmailEnv := GMailDep(cDeptoX5)
                                    EMailPAA(cUsuEnv, cEmailEnv, aCols[nLin])
                                endif
                                Exit
                            Endif
                        Endif
                    endif
                endif
           ENDIF
        ENDIF
    Next
    nTotCol := 0
    aEval(aCols, {|X| if(X[Len(aCols[1])]==.F., nTotCol++,0) })
    // Analiso o Status conforme leitura
    aEval(aCols, {|X| iif(X[GDFieldPos("Z46_APROVA")]=="N" .and. (Z45->Z45_STATUS $ "P/A") .and. X[Len(aCols[1])]==.F., nAberto++,0) })
    IF !( nAberto <= nTotCol .and. nAberto > 0 )
        nAberto := 0
    Endif

    RecLock("Z45",.F.)
    if (nAberto >= 1 .and. nAberto < nTotCol)
        Z45->Z45_STATUS := "A"
    elseif (nAberto == nTotCol)
        Z45->Z45_STATUS := "P"
    else
        Z45->Z45_STATUS := "G"
        Z45->Z45_AGUARD := "Aguardando Solicitante Encerrar"
    endif
    MsUnlock()

    // Disparo e-mail ao solicitante
    if nAberto=0
        nPos      := Len(aCols)
        cUsuEnv   := Z45->Z45_SOLICI
        cEmailEnv := UsrRetMail(cUsuEnv)
        EMailPAA(cUsuEnv, cEmailEnv, aCols[nPos])
    Endif

    RestArea( aAreaVerif )
Return

/*/{Protheus.doc}  Function GrvOPC
    (long_description)
    Cria aprovadores adicionais
    @author user
    Valdemir Rabelo - SigaMat
    @since 31/07/2019
/*/
Static Function GrvOPC(paEnvOutr)
    Local aVetor := {}
    Local nX     := 0
    Local lAchou := .F.
    Local lZ46   := .F.

    // Preparo Array com Aprovadores adicionais
    For nX := 1 to Len(paEnvOutr)
        if paEnvOutr[nX][1]
           if nX == 1
              aAdd(aVetor, {.T., 'LOGISTICA',50,'GLO'})
           elseif nX ==2
              aAdd(aVetor, {.T., 'MARKETING',51,'GMK'})
           else
              aAdd(aVetor, {.T., 'COMERCIAL',51,'GCM'})
            endif
        endif
    Next

    // Alimento aCols com registros adicionais
    For nX := 1 to Len(aVetor)
        if aVetor[nX][1]
            aAdd(aCols, Array(Len(aHeader)+2) )
            nUltLin := Len(aCols)
            aCols[nUltLin][01] := aVetor[nX][2]
            aCols[nUltLin][02] := CriaVar(aHeader[2][2])
            aCols[nUltLin][03] := CriaVar(aHeader[3][2])
            aCols[nUltLin][04] := CriaVar(aHeader[4][2])
            aCols[nUltLin][05] := CriaVar(aHeader[5][2],.T.)
            aCols[nUltLin][06] := CriaVar(aHeader[6][2])
            aCols[nUltLin][07] := CriaVar(aHeader[7][2])
            aCols[nUltLin][08] := CriaVar(aHeader[8][2],.T.)
            aCols[nUltLin][09] := "N"
            aCols[nUltLin][10] := aVetor[nX][3]
            aCols[nUltLin][11] := .F.
        endif
    Next

    // Atualizo Novos Dados no Grid
    For nX := 1 to Len(aCols)
        lInclui := Z46->( (!dbSeek(xFilial("Z46")+_cCONTRO+aCols[nX][1])) )
        if !aCols[nX][Len(aCols[nX])]   // Verifico se está deletado
            RecLock('Z46',lInclui)
            if lInclui
                Z46->Z46_FILIAL := XFILIAL('Z46')
                Z46->Z46_CONTRO := Z45->Z45_CONTRO
                Z46->Z46_DEPTO  := aCols[nX][GDFieldPos("Z46_DEPTO")]
                Z46->Z46_ENVMAI := "N"
                Z46->Z46_ORDEM  := aCols[nX][Len(aCols[nX])-1]
            endif
            Z46->Z46_APROVA := aCols[nX][GDFieldPos("Z46_APROVA")]
            Z46->Z46_COMENT := aCols[nX][GDFieldPos("Z46_COMENT")]
            Z46->Z46_RESPON := aCols[nX][GDFieldPos("Z46_RESPON")]
            Z46->Z46_NOMRES := aCols[nX][GDFieldPos("Z46_NOMRES")]
            Z46->Z46_DATAPR := aCols[nX][GDFieldPos("Z46_DATAPR")]
            Z46->Z46_ACLOTE := aCols[nX][GDFieldPos("Z46_ACLOTE")]
            Z46->( MsUnlock() )
        else
            if !lInclui
                RecLock('Z46',lInclui)
                Z46->( dbDelete() )
                Z46->( MsUnlock() )
            Endif
        Endif
    Next
    GetDRefresh()
    // Localizo Proximo Envio
    nPos := aScan(aCols, { |X| Empty(X[GDFieldPos("Z46_RESPON")]) .and.  (X[GDFieldPos("Z46_ENVMAI")] == "N")} )
    if nPos > 0
        Z47->( dbSetOrder(3) )
        // Localizo o Departamento
        lAchou := Z47->( dbSeek(xFilial("Z47")+LEFT(Alltrim(aCols[nPos][GDFieldPos("Z46_DEPTO")]),TAMSX3('Z47_DEPTO')[1]) ) )
        // Localiza Aprovador
        lZ46   := Z46->( dbSeek(xFilial("Z46")+Z45->Z45_CONTRO+aCols[nPos][1]) )
        // Envio e-mail ao proximo Depto
        cUsuEnv   := Z47->Z47_USUARI
        cEmailEnv := GMailDep(Z47->Z47_DEPTO)
        EMailPAA(cUsuEnv, cEmailEnv, aCols[nPos])
        if lZ46
            // Atualizo os dados
            RecLock("Z46",.F.)
            Z46->Z46_ENVMAI := "S"
            Z46->Z46_RECEBI := dDATABASE
            MsUnlock()
            RecLock("Z45",.F.)
            Z45->Z45_AGUARD := ALLTRIM(aCols[nPos][GDFieldPos("Z46_DEPTO")])
            MsUnlock()
        Endif
    endif

Return

/*/{Protheus.doc}  Function EMailPAA
    (long_description)
    Prepara Envio de E-mail
    @author user
    Valdemir Rabelo - SigaMat
    @since 31/07/2019
/*/
Static Function EMailPAA(pcUsuEnv, pemail, paCols)
	Local lResult			:= .F.
	Local cAccount		:= SuperGetMV( "MV_RELAUSR",, ""  ) // Conta dominio 	Ex.: Teste@email.com.br
	Local cPassword		:= SuperGetMV( "MV_RELAPSW",,  ""  ) // Pass da conta 	Ex.: Teste123
	Local cServer		:= SuperGetMV( "MV_RELSERV",, ""  ) // Smtp do dominio	Ex.: smtp.email.com.br
	Local cFrom   		:= pemail                           // E-mail do usuário solicitante
	Local cCC   		:= SuperGetMV( "ST_MAILREJ",, ""  ) // "gerente01@email.com.br"
	Local lRelauth  	:= SuperGetMv( "MV_RELAUTH",, .T. ) // Utiliza autenticação
	Local cBody			:= STPAAMntMsg(paCols)
	local lAut			:= .F.
    Local cSubject		:= "Pedido Nº " + cValtoChar(Z45->Z45_CONTRO) + "  Analise PAA - Aguardando: " + ALLTRIM(Z45->Z45_AGUARD)

	U_STMAILTES(cFrom, cCC, cSubject, cBody,{},"")

Return


/*
	Autor		:	Valdemir Rabelo
	Data		:	29/07/2019
	Descrição	:	Prepara o corpo do e-mail
*/
Static Function STPAAMntMsg(paCols )
	Local cMsg      := ""
	Local cCaminho	:= ""
	Local nVlTot    := 0
    Local _aMsg     := {}
    Local cAcao     := if(paCols[GDFieldPos("Z46_APROVA")]=="A","APROVADO",if(paCols[GDFieldPos("Z46_APROVA")]=="R", "REPROVADO","AGUARDANDO APROVAÇÃO"))
    Local _cAssunto := 'Pedido de Analise PAA ( '+cAcao+' )'
    Local cFornced  := cLojaFor := cNomeFor := ""
    Local nX
    Local _nLin
    // VALDEMIR 04/09/1970
    if Empty(Z45->Z45_FORNED)
        cFornced  := Z45->Z45_FORNMN
        cLojaFor  := Z45->Z45_LOJAMN
        cNomeFor  := Z45->Z45_NOMFMN
    else
        cFornced  := Z45->Z45_FORNED
        cLojaFor  := Z45->Z45_LOJAFO
        cNomeFor  := Z45->Z45_NOMFOR
    endif
	Aadd( _aMsg , { "Numero Controle: " , cValtoChar(Z45->Z45_CONTRO) } )
	Aadd( _aMsg , { "Solicitante: "     , Z45->Z45_SOLICI } )
	Aadd( _aMsg , { "Nome Solicitante: ", Z45->Z45_NOMSOL } )
	Aadd( _aMsg , { "Departamento: "	, Z45->Z45_DEPTO   } )
	Aadd( _aMsg , { "Data: "    		, dtoc(Z45->Z45_DATA) } )
	Aadd( _aMsg , { "Produto: "    		, Z45->Z45_PRODUT } )
    Aadd( _aMsg , { "Quantidade: " 		, cValtoChar(Z45->Z45_QTDE)   } )
    Aadd( _aMsg , { "Classif.Produto:"  , Z45->Z45_CLASSI})
    Aadd( _aMsg , { "Fornecedor:"       , cFornced } )
    Aadd( _aMsg , { "Loja:"             , cLojaFor } )
    Aadd( _aMsg , { "Nome Fornecedor:"  , cNomeFor } )
    Aadd( _aMsg , { " "                 , '' } )
    Aadd( _aMsg , { " "                 , '' } )
    // Apresenta as ações tomadas dos departamentos
    For nX := 1 to Len(aCols)
       if !Empty(aCols[nX][GDFieldPos("Z46_NOMRES")])
            cAcao  := if(aCols[nX][GDFieldPos("Z46_APROVA")]=="A","APROVADO",if(aCols[nX][GDFieldPos("Z46_APROVA")]=="R", "REPROVADO","AGUARDANDO APROVAÇÃO"))
            Aadd( _aMsg , { "Departamento: "    , aCols[nX][GDFieldPos("Z46_DEPTO")] } )
            Aadd( _aMsg , { "Responsável: "     , aCols[nX][GDFieldPos("Z46_NOMRES")] } )
            Aadd( _aMsg , { "STATUS"            , cAcao } )
            Aadd( _aMsg , { "Observação : "     , aCols[nX][GDFieldPos("Z46_COMENT")] } )
        Endif
    Next

	//A Definicao do cabecalho do email
	cMsg := ""
	cMsg += '<html>'
	cMsg += '<head>'
	cMsg += '<title>' + _cAssunto + " - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title>'
	cMsg += '</head>'
	cMsg += '<body>'
	cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
	cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
	cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>' + _cAssunto +" - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+ '</FONT> </Caption>'
	
    //A Definicao do texto/detalhe do email
	For _nLin := 1 to Len(_aMsg)
		
        If (_nLin/2) == Int( _nLin/2 )
			cMsg += '<TR BgColor=#B0E2FF>'
		Else
			cMsg += '<TR BgColor=#FFFFFF>'
		EndIf

		cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></B></TD>'
		cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></TD>'

	Next

	//A Definicao do rodape do email
	cMsg += '</Table>'
	cMsg += '<P>'
	cMsg += '<Table align="center">'
	cMsg += '<tr>'
	cMsg += '<td colspan="10" align="center"><font color="red" size="3">Mensagem enviada automaticamente pelo sistema PROTHEUS - <font color="red" size="1"></td>'
	cMsg += '</tr>'
	cMsg += '</Table>'
	cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
	cMsg += '</body>'
	cMsg += '</html>'

Return cMsg


/*
	Autor		:	Valdemir Rabelo
	Data		:	01/08/2019
	Descrição	:	Valida Responsável
*/
User Function VLDRESPO(pUsuario)
    Local lRET     := .T.
    Local cDepto   := ""
    Local aAreaVLD := GetArea()

    dbSelectArea("Z47")
    dbSetOrder(1)
    lRET := dbSeek(XFilial("Z47")+pUsuario)
    if lRET
        Z47->( dbEVal({ || cDepto += left(Z47_DEPTO,15), if(!Empty(cDepto),cDepto += "/",nil) },,{ || !Eof() .and. Z47_USUARI==pUsuario }))
        lRET := (Left(aCols[n][GDFieldPos("Z46_DEPTO")],15) $ cDepto)
        if !lRET
            MsgRun("Usuario não faz parte deste departamento", "Atenção!", {|| sleep(3000)})
        endif
    else
        MsgRun("Usuario não cadastrado - (Z47)", "Atenção!", {|| sleep(3000)})
    endif

    RestArea( aAreaVLD)

Return lRET

/*
    Function    :   GetSX5
	Autor		:	Valdemir Rabelo
	Data		:	01/08/2019
	Descrição	:	Valida Responsável
*/
Static Function GetSX5(pZ47_DEPTO)
    Local cRET := ""
    Local cQry := ""

    cQry := "SELECT X5_CHAVE REG " + CRLF
    cQry += "FROM " + RETSQLNAME("SX5") + " SX5 " + CRLF
    cQry += "WHERE SX5.D_E_L_E_T_ = ' ' " + CRLF
    cQry += " AND SUBSTR(SX5.X5_DESCRI,1,15)='"+pZ47_DEPTO+"' " + CRLF
    if Select("TMPX5") > 0
        TMPX5->( dbCloseArea() )
    Endif
    TcQuery cQry new Alias "TMPX5"

    IF !EOF()
       cRET := TMPX5->REG
    ENDIF

    if Select("TMPX5") > 0
        TMPX5->( dbCloseArea() )
    Endif

Return cRET

/*
    Function    :   OPCENV
	Autor		:	Valdemir Rabelo
	Data		:	01/08/2019
	Descrição	:	Valida Responsável
*/
Static Function OPCENV()
    Local aParax    := {}
    Local _cMailSol := ""
    Local aRET      := {}
    Local aRETX     := {}
    Local cUsrMKT   := SuperGetMV("FS_USRMKT",.F.,"001024")
    Local cUsrLog   := SuperGetMV("FS_USRLOG",.F.,"000402")
    Local cUsrCom   := SuperGetMV("FS_USRCOM",.F.,"000294")
    /*
    5 - CheckBox ( linha inteira )
    [2] : Descrição
    [3] : Indicador Lógico contendo o inicial do Check
    [4] : Tamanho do Radio
    [5] : Validação
    [6] : Flag .T./.F. Parâmetro Obrigatório ?
    */
    aAdd(aParax,{5, "Logistica",     .f.,  50, '',.F.})
    aAdd(aParax,{5, "Marketing",     .f.,  50, '',.F.})
    aAdd(aParax,{5, "Comercial",     .f.,  50, '',.F.})

    If !ParamBox(aParax,"Parâmetros", @aRet,,,,,,,,.F.,.F.)
        Return aRETX
    EndIf
    aAdd(aRETX, {MV_PAR01, UsrRetName(cUSRMKT), UsrRetMail(cUSRMKT) })
    aAdd(aRETX, {MV_PAR02, UsrRetName(cUSRLOG), UsrRetMail(cUSRLOG) })
    aAdd(aRETX, {MV_PAR03, UsrRetName(cUSRCOM), UsrRetMail(cUSRCOM) })

Return aRETX


/*
    Function    :   STCPAIMP
	Autor		:	Valdemir Rabelo
	Data		:	05/08/2019
	Descrição	:	Imprimir
*/
user Function STCPAIMP()
    Processa({|| STCPIMP2()}, "Aguarde... Preparando Relatório")
Return

Static Function STCPIMP2()
    Local lAdjustToLegacy 	:= .F.
    Local lDisableSetup  	:= .T.
    Local cLocal            := "\spool"
    Private cLogoD          := GetSrvProfString("Startpath","") + "lgrl"+cEmpAnt+".bmp"
    Private oBshCClaro      := TBrush():New(,CLR_HGRAY) // Cinza Claro

    Private oPrinter

    MakeDir("C:\Temp")

    oPrinter := FWMSPrinter():New("STCPAIMP.PDF",IMP_PDF, lAdjustToLegacy,cLocal,lDisableSetup, , , , , , .F., .T. )

    if File("C:\Temp\STCPAIMP.PDF")
        FErase("C:\Temp\STCPAIMP.PDF")
    endif

    oPrinter:SetPortrait()
    oPrinter:SetResolution(72)
    oPrinter:SetPaperSize(DMPAPER_A4)	// A4 210mm x 297mm  620 x 876
    oPrinter:cPathPDF :="C:\Temp\"

    Processa( {|| InitProc() }, "Imprimindo Ficha de Analise, Aguarde...")

    oPrinter:Preview()

    FreeObj(oPrinter)
    oPrinter := Nil

Return

/*
    Autor       : Valdemir Rabelo
    Descrição   : Impressão da Ficha
    Data        : 05/08/2019
*/
Static Function InitProc()
    Local nLin    := 0050
    Local nCol	  := 0050
    Local cSIM    := cNAO := ""
    Local nConta  := 0
    Local nMaxLin := 750
    Local nMaxQdr := 600
    Private nPag  := 0

    Z46->( dbSetOrder(5) )
    Z46->( dbSeek(XFilial("Z46")+Z45->Z45_CONTROLE))
    Z46->( dbEVal( {|| nConta++},,{|| (!EOF() .and. Z46_FILIAL==XFILIAL("Z46") .AND. Z46_CONTRO==Z45->Z45_CONTROLE .AND. LEFT(Z46_DEPTO,9)=="SEGURANCA")}) )
    IF nConta > 0
       cSIM := "X"
    else
       cNAO := "X"
    Endif
    Z46->( dbSetOrder(5) )
    Z46->( dbGotop() )
    Z46->( dbSeek(XFilial("Z46")+Z45->Z45_CONTROLE))
    While Z46->( !Eof() .and. Z46->Z46_FILIAL==XFILIAL("Z46") .AND. Z46->Z46_CONTRO==Z45->Z45_CONTROLE )
        if (nLin==50) .or. (nLin > nMaxLin)
            IF nLin > nMaxLin
                oPrinter:EndPage()
                nLin := 50
            Endif
            Cabec01(@nLin,@nCol,cSIM,cNAO,nMaxQdr)
        Endif
        ImpDepto(@nLin,@nCol)
        Z46->( dbSkip() )
    EndDo
    ImpObser(@nLin,@nCol,nMaxLin)
    oPrinter:EndPage()
Return

/*
    Autor       : Valdemir Rabelo
    Descrição   : Impressão Linhas Observações
    Data        : 07/08/2019
*/
Static Function ImpObser(nLin, nCol, nMaxLin)
    Local nX      := 0
    Local nTotObs := (int((nMaxLin - nLin) / 18) * 2)-1

    IF nTotObs > 1
        oPrinter:Box(nLin-10, nCol-20,  nLin+08, nCol+490,"-4")         // Quadro Titulo de Analise Amostra
        oPrinter:FillRect({nLin-09, nCol-19, nLin+7, nCol+489 }, oBshCClaro)
        oPrinter:Say (nLin+2, nCol+185, "O B S E R V A Ç Ã O",oFont12)
        nLin += 35

        While nLin < nMaxLin
            oPrinter:Line(nLin-10, nCol+10, nLin-10, nCol+470)
            nLin += 18
        EndDo
    ENDIF

Return


/*
    Autor       : Valdemir Rabelo
    Descrição   : Impreme Cabeçalho
    Data        : 07/08/2019
*/
Static Function Cabec01(nLin,nCol, cSIM, cNAO,nMaxQdr)
    Local nConta := 0
    Local cFornced := cLojaFor := cNomeFor := cAnexo := cStatus := ""
    Local CorStatus
    nPag++
    // VALDEMIR 04/09/1970
    if Empty(Z45->Z45_FORNED)
        cFornced  := Z45->Z45_FORNMN
        cLojaFor  := Z45->Z45_LOJAMN
        cNomeFor  := Z45->Z45_NOMFMN
    else
        cFornced  := Z45->Z45_FORNED
        cLojaFor  := Z45->Z45_LOJAFO
        cNomeFor  := Z45->Z45_NOMFOR
    endif
    IF Z45_STATUS == 'E'
        cStatus:= ALLTRIM(Z45_AGUARD)
        if cStatus == "A P R O V A D O"
            CorStatus := nClrVerd
        else
            CorStatus := nClrVerm
        endif
    ELSE
        cStatus:= "EM ANALISE"
    ENDIF
    cAnexo := IF(!EMPTY(Z45->Z45_ANEXOS), "X", "")
    // Titulo e Logo
    oPrinter:StartPage()
    oPrinter:SayBitmap (nLin - 0020,nCol - 0020 ,cLogoD ,0088,0025)	// < nRow>, < nCol>, < cBitmap>, [ nWidth], [ nHeight]
    oPrinter:Say (nLin, nCol + 0100,"PEDIDO DE ANÁLISE DE AMOSTRA - PAA",oFont16N )
    oPrinter:Say (nLin, nCol + 0390,"Nº ",oFont16N )
    oPrinter:Say (nLin, nCol + 0410, Z45->Z45_CONTRO,oFont16 )
    nLin += 25
    oPrinter:Say (nLin-12, nCol + 0420,"Pagina: ",oFont10N )
    oPrinter:Say (nLin-12, nCol + 0457, StrZero(nPag,3),oFont10 )

    //Box ( < nRow>, < nCol>, < nBottom>, < nRight>, [ cPixel]
    // Dados Solicitante - 1º linha
    oPrinter:Box(nLin-10, nCol-20,  nLin+104, nCol,"-4")         // Quadro canto esquerdo para texto Vertical
    oPrinter:Box(nLin-10, nCol,     nLin+08, nCol+180,"-4")     // Quadro Nome
    oPrinter:Box(nLin-10, nCol+180, nLin+08, nCol+380,"-4")     // Quadro Depto
    oPrinter:Box(nLin-10, nCol+380, nLin+08, nCol+490,"-4")     // Quadro Data
    oPrinter:Say (nLin, nCol+10, "NOME: ",oFont12)
    oPrinter:Say (nLin, nCol+50, ALLTRIM(Z45->Z45_NOMSOL)+" - "+Z45->Z45_SOLICI,oFont12N)
    oPrinter:Say (nLin, nCol+185, "DEPTO: ",oFont12)
    oPrinter:Say (nLin, nCol+230, Z45->Z45_DEPTO,oFont12N)
    oPrinter:Say (nLin, nCol+390, "DATA: ",oFont12)
    oPrinter:Say (nLin, nCol+430, DTOC(Z45->Z45_DATA), oFont12N)
    nLin += 14
    // 2º linha
    oPrinter:Box(nLin-10, nCol, nLin+08, nCol+380,"-4")         // Quadro Produto
    oPrinter:Box(nLin-10, nCol+380, nLin+08, nCol+490,"-4")     // Quadro QTDE
    oPrinter:Say (nLin, nCol+10, "PROUDTO/SERVIÇO: ",oFont12)
    oPrinter:Say (nLin, nCol+110, ALLTRIM(Z45->Z45_PRODUT),oFont12N)
    oPrinter:Say (nLin, nCol+390, "QTDE: ",oFont12)
    oPrinter:Say (nLin, nCol+430, STR(Z45->Z45_QTDE), oFont12N)
    nLin += 14
    // 3º linha
    oPrinter:Box(nLin-10, nCol, nLin+08, nCol+490,"-4")         // Quadro MOTIVO
    oPrinter:Say (nLin, nCol+10, "MOTIVO: ",oFont12)
    oPrinter:Say (nLin, nCol+50, left(ALLTRIM(Z45->Z45_MOTIVO),100)  ,oFont12N)
    nLin += 14
    // 4º linha
    oPrinter:Box(nLin-10, nCol, nLin+08, nCol+300,"-4")             // Quadro APLICAR EM
    oPrinter:Box(nLin-10, nCol+300, nLin+08, nCol+490,"-4")         // Quadro CLASSIFICAÇÃO
    oPrinter:Say (nLin, nCol+10, "APLICAR EM: ",oFont12)
    oPrinter:Say (nLin, nCol+70, ALLTRIM(Z45->Z45_APLICA), oFont12N)
    oPrinter:Say (nLin, nCol+305, "CLASSIFICAÇÃO: ",oFont12)
    oPrinter:Say (nLin, nCol+390, Z45->Z45_CLASSI,oFont12N)
    nLin += 14
    // 5º linha
    oPrinter:Box(nLin-10, nCol, nLin+08, nCol+490,"-4")         // Quadro FORNECEDOR - SP
    oPrinter:Say (nLin, nCol+10, "FORNEC. SP: ",oFont12)
    oPrinter:Say (nLin, nCol+090, ALLTRIM(Z45->Z45_NOMFOR)+" - "+Z45->Z45_FORNED+Z45->Z45_LOJAFO,oFont12N)
    nLin += 14
    // 6º linha
    oPrinter:Box(nLin-10, nCol, nLin+08, nCol+490,"-4")         // Quadro FORNECEDOR - MANAUS
    oPrinter:Say (nLin, nCol+10, "FORNEC. MN: ",oFont12)
    oPrinter:Say (nLin, nCol+090, ALLTRIM(Z45->Z45_NOMFMN)+" - "+Z45->Z45_FORNMN+Z45->Z45_LOJAMN,oFont12N)
    nLin += 14
    //
    oPrinter:Say (nLin-10, nCol-7, "SOLICITANTE",oFont08,,,270)
    //
    cMsgSST1 := "NECESSITA ANÁLISE DO DEPTO DE SAÚDE E SEGURANÇA DO TRABALHO?   (Por exemplo, produtos quiímicos)"
    cMsgSST2 := "Se 'SIM', encaminhar o formulário para o depto. de SST para análise.         [ "+cSIM+" ] SIM      [ "+cNAO+" ] NÃO  "
    // 7º linha
    oPrinter:Box(nLin-10, nCol, nLin+16, nCol+490,"-4")         // Quadro MENSAGEM
    oPrinter:Say (nLin, nCol+10, cMsgSST1, oFont11)
    nLin += 13
    oPrinter:Say (nLin, nCol+10, cMsgSST2, oFont11)
    // 8º linha
    nLin += 13
    oPrinter:Box(nLin-10, nCol-20,  nLin+nMaxQdr, nCol+490,"-4")    // Quadro Titulo documento anexo
    oPrinter:Say (nLin, nCol+10, "Contém Documentos Anexo [     ] SIM      [      ] NÃO ",oFont12)
    nAju := 0
    nAju := if(!Empty(cAnexo),136,188)
    oPrinter:Say (nLin, nCol+nAju, "X",oFont12N)
    oPrinter:Say (nLin, nCol+300, "STATUS: ",oFont12)
    oPrinter:Say (nLin, nCol+350, cStatus,oFont12N,,CorStatus)
    nLin += 13
    oPrinter:Box(nLin-10, nCol-20,  nLin+nMaxQdr, nCol+490,"-4")    // Quadro Titulo de Analise Amostra
    oPrinter:Box(nLin-10, nCol-20,  nLin+08, nCol+490,"-4")         // Quadro Titulo de Analise Amostra
    oPrinter:FillRect({nLin-09, nCol-19, nLin+7, nCol+489 }, oBshCClaro)
    oPrinter:Say (nLin+2, nCol+185, "ANÁLISE DA AMOSTRA",oFont12)
    nLin += 17

Return

/*
    Autor       : Valdemir Rabelo
    Descrição   : Imprime Departamentos
    Data        : 07/08/2019
*/
Static Function ImpDepto(nLin,nCol)
    Local aComent := TrataM(ALLTRIM(Z46->Z46_COMENT), 050)
    Local nAprov  := if(Z46->Z46_APROVA=="A",239,if(Z46->Z46_APROVA=="R",339,0))
    Local cDepto  := Left(Z46->Z46_DEPTO,9)
    Local nTotLen := if(Len(aComent)=0,1,Len(aComent))
    Local nTLin   := (14*nTotLen)+8+28
    Local aAreaDp := GetArea()
    Local nComen  := 0
    Local nX

    if (cDepto=="CONTROLE") .OR. (ALLTRIM(Z46->Z46_DEPTO)=="CONTROLE QUALIDADE")
       cDepto := "QUALIDADE"
    ELSEIF (cDepto=="SEGURANCA") .OR. (ALLTRIM(Z46->Z46_DEPTO)=="SEGURANCA TRABALHO")
        cDepto := "SEGUR.TRAB"
    ELSEIF (cDepto=="PLAN.CONT") .OR. (ALLTRIM(Z46->Z46_DEPTO)=="PLAN.CONTROLE PRODUCAO")
        cDepto := "  P C P "
    ELSEIF (ALLTRIM(Z46->Z46_DEPTO)=="ENGENHARIA PROCESSOS")
        cDepto := "ENG PROC"
    ELSEIF (ALLTRIM(Z46->Z46_DEPTO)=="ENGENHARIA PRODUTOS")
        cDepto := "ENG PROD"
    Endif

    oPrinter:Box(nLin-10, nCol-20,  nLin+nTLin, nCol,"-4")         // Quando canto esquerdo para texto Vertical
    oPrinter:Box(nLin-10, nCol, nLin+nTLin, nCol+490,"-4")         // Quadro FORNECEDOR
    oPrinter:Say (nLin, nCol+10, "RECEBIDO EM: ",oFont12)
    oPrinter:Say (nLin, nCol+80, DTOC(Z46->Z46_RECEBI), oFont12N)
    oPrinter:Say (nLin, nCol+185,"[   ] APROVADO            [   ] REPROVADO",oFont12)
    if nAprov > 0
        oPrinter:Say (nLin, nAprov,"X",oFont12N)
    Endif
    nLin += 14
    oPrinter:Say (nLin+28, nCol-7, cDepto, oFont08,,,270)
    oPrinter:Say (nLin, nCol+10, "COMENTÁRIOS: ",oFont12)
    For nX := 1 to Len(aComent)
        if nX = 1
            nComen  := 90
        else
            nComen  := 20
        endif
        oPrinter:Say (nLin, nCol+nComen, aComent[nX], oFont12N)
        nLin += 14
    Next
    if Len(aComent) = 1
       nLin += 14
    elseif Len(aComent) = 0
       nLin += 28
    endif
    oPrinter:Say (nLin, nCol+300, "RESPONSÁVEL (NOME): ",oFont12)
    oPrinter:Say (nLin, nCol+410, Z46->Z46_NOMRES, oFont12N)
    RestArea( aAreaDp )
    nLin += (nTLin-35)
Return




/*/{Protheus.doc} TrataM
    Função Memo To Array, que quebra um texto em um array conforme número de colunas
@author Valdemir Rabelo
@since 15/08/2014
@version 1.0
	@param cTexto, Caracter, Texto que será quebrado (campo MEMO)
	@param nMaxCol, Numérico, Coluna máxima permitida de caracteres por linha
	@param cQuebra, Caracter, Quebra adicional, forçando a quebra de linha além do enter (por exemplo '<br>')
	@param lTiraBra, Lógico, Define se em toda linha será retirado os espaços em branco (Alltrim)
	@return nMaxLin, Número de linhas do array
	@example
	cCampoMemo := SB1->B1_X_TST
	nCol        := 200
	aDados      := TrataM(cCampoMemo, nCol)
	@obs Difere da MemoLine(), pois já retorna um Array pronto para impressão
/*/

Static Function TrataM(cTexto, nMaxCol, cQuebra, lTiraBra)
	Local aArea     := GetArea()
	Local aTexto    := {}
	Local aAux      := {}
	Local nAtu      := 0
	Default cTexto  := ''
	Default nMaxCol := 80
	Default cQuebra := ';'
	Default lTiraBra:= .T.

	//Quebrando o Array, conforme -Enter-
	aAux:= StrTokArr(cTexto,Chr(13))

	//Correndo o Array e retirando o tabulamento
	For nAtu:=1 TO Len(aAux)
		aAux[nAtu]:=StrTran(aAux[nAtu],Chr(10),'')
	Next

	//Correndo as linhas quebradas
	For nAtu:=1 To Len(aAux)

		//Se o tamanho de Texto, for maior que o número de colunas
		If (Len(aAux[nAtu]) > nMaxCol)

			//Enquanto o Tamanho for Maior
			While (Len(aAux[nAtu]) > nMaxCol)
				//Pegando a quebra conforme texto por parâmetro
				nUltPos:=RAt(cQuebra,SubStr(aAux[nAtu],1,nMaxCol))

				//Caso não tenha, a última posição será o último espaço em branco encontrado
				If nUltPos == 0
					nUltPos:=Rat(' ',SubStr(aAux[nAtu],1,nMaxCol))
				EndIf

				//Se não encontrar espaço em branco, a última posição será a coluna máxima
				If(nUltPos==0)
					nUltPos:=nMaxCol
				EndIf

				//Adicionando Parte da Sring (de 1 até a Úlima posição válida)
				aAdd(aTexto,SubStr(aAux[nAtu],1,nUltPos))

				//Quebrando o resto da String
				aAux[nAtu] := SubStr(aAux[nAtu], nUltPos+1, Len(aAux[nAtu]))
			EndDo

			//Adicionando o que sobrou
			aAdd(aTexto,aAux[nAtu])
		Else
			//Se for menor que o Máximo de colunas, adiciona o texto
			aAdd(aTexto,aAux[nAtu])
		EndIf
	Next

	//Se for para tirar os brancos
	If lTiraBra
		//Percorrendo as linhas do texto e aplica o AllTrim
		For nAtu:=1 To Len(aTexto)
			aTexto[nAtu] := Alltrim(aTexto[nAtu])
		Next
	EndIf

	RestArea(aArea)
Return aTexto


/*
    Autor       : Valdemir Rabelo
    Descrição   : Retorna Departamentos
    Data        : 09/08/2019
*/
Static Function GetDepto(pAGUARD)
    Local cRET     := ""
    Local aAreaZ47 := GetArea()

    dbSelectArea("Z47")
    dbSetOrder(3)
    dbSeek(XFilial("Z47")+LEFT(Alltrim(pAGUARD),TAMSX3("Z47_DEPTO")[1]) )
    While !Eof() .and. ( alltrim(Z47->Z47_DEPTO) $ LEFT(pAGUARD, LEN(ALLTRIM(Z47->Z47_DEPTO))) )
       if !Empty(cRET)
          cRET += "/"
       Endif
       cRET += Z47->Z47_USUARI
       dbSkip()
    EndDo

    RestArea( aAreaZ47 )

Return cRET


/*
    Autor       : Valdemir Rabelo
    Descrição   : Retorna Departamentos
    Data        : 09/08/2019
*/
Static Function GMailDep(pDepto)
    Local cRET     := ""
    Local aAreaZ47 := GetArea()

    dbSelectArea("Z47")
    dbSetOrder(3)
    dbSeek(XFilial("Z47")+LEFT(Alltrim(pDepto),TAMSX3("Z47_DEPTO")[1]) )
    While !Eof() .and. ( alltrim(Z47->Z47_DEPTO) $ LEFT(pDepto, LEN(ALLTRIM(Z47->Z47_DEPTO))) )
       if !Empty(cRET)
          cRET += ";"
       Endif
       cRET += UsrRetMail(Z47->Z47_USUARI)
       dbSkip()
    EndDo

    RestArea( aAreaZ47 )

Return cRET


//--------------------------------------------------------------
/*/{Protheus.doc} Function TeclaF4
Description
  Tela Controle de Anexos
@author Valdemir Rabelo - valdemir.rabelo@totvs.com.br
@since 12/08/2019
/*/
//--------------------------------------------------------------
Static Function TeclaF4(nLinAtu)
    Local oBtAbrir
    Local oBtAnexo
    Local oBtExcluir
    Local oBTSair
    Local oFCab := TFont():New("MS Sans Serif",,016,,.T.,,,,,.F.,.F.)
    Local oItem := TFont():New("MS Sans Serif",,016,,.T.,,,,,.F.,.F.)
    Local oGetDepto
    Local cGetDepto     := ""
    Local oGetNro
    Local cGetNro       := _cCONTRO
    Local oGetProduto
    Local cGetProduto   := _cPRODUT
    Local oGetSolic
    Local cGetSolic     := _cNOMSOL
    Local oListBox1
    Local aListBox      := {}
    Local nListBox1     := 1
    Local oPanel1
    Local oPanel2
    Local oPnl
    Local oSay1
    Local oSay2
    Local oSay3
    Local oSay4
    Static oDlgTela

    cGetDepto := aCols[nLinAtu][GDFieldPos("Z46_DEPTO")]

    // Verifico os documentos existentes no Departamento Selecionado
    aListBox      := GDocAnex(cGetDepto)


    DEFINE MSDIALOG oDlgTela TITLE "Controle Anexos" FROM 000, 000  TO 500, 590 COLORS 0, 16777215 PIXEL

    @ 002, 003 MSPANEL oPnl SIZE 289, 078 OF oDlgTela COLORS 0, 16574413 RAISED
    @ 012, 016 SAY oSay3 PROMPT "Nº PAA" SIZE 025, 007 OF oPnl COLORS 0, 16777215 PIXEL
    @ 011, 049 MSGET oGetNro VAR cGetNro SIZE 060, 010 OF oPnl COLORS 16711680, 16777215 FONT oFCab READONLY PIXEL
    @ 030, 015 SAY oSay4 PROMPT "Solicitante" SIZE 025, 007 OF oPnl COLORS 0, 16777215 PIXEL
    @ 026, 049 MSGET oGetSolic VAR cGetSolic SIZE 218, 010 OF oPnl COLORS 16711680, 16777215 FONT oFCab READONLY PIXEL
    @ 063, 016 SAY oSay1 PROMPT "Depto." SIZE 025, 007 OF oPnl COLORS 0, 16777215 PIXEL
    @ 061, 049 MSGET oGetDepto VAR cGetDepto SIZE 219, 010 OF oPnl COLORS 255, 16777215 FONT oItem READONLY PIXEL
    @ 043, 049 MSGET oGetProduto VAR cGetProduto SIZE 219, 010 OF oPnl FONT oItem READONLY PIXEL
    @ 046, 016 SAY oSay2 PROMPT "Produto" SIZE 025, 007 OF oPnl COLORS 0, 16777215 PIXEL
    @ 082, 003 MSPANEL oPanel1 SIZE 289, 122 OF oDlgTela COLORS 0, 16574413 RAISED
    @ 004, 005 LISTBOX oListBox1 VAR nListBox1 FIELDS Header "Anexos" alPixel(.F.) SIZE 282, 115 OF oPanel1  COLORS 0, 16777215 PIXEL  ON dblClick( oListbox1:DrawSelect() )
    @ 012, 112 BUTTON oBtAnxSol  PROMPT "Anexar"     SIZE 037, 012 OF oPnl ACTION AnexoSol(aListBox)                    PIXEL
    //@ 012, 149 BUTTON oBtAbrSol  PROMPT "Abrir"      SIZE 037, 012 OF oPnl ACTION OpenAnex(aListBox,oListBox1:nAt,.F.)  PIXEL
    //@ 012, 186 BUTTON oBtExcSol  PROMPT "Excluir"    SIZE 037, 012 OF oPnl ACTION DelAnex(aListBox,oListBox1:nAt,.f.)   PIXEL
    oListBox1:SetArray(aListBox)
    oListBox1:bLine := {|| { aListBox[oListBox1:nAt] }}

    @ 208, 003 MSPANEL oPanel2 SIZE 289, 039 OF oDlgTela COLORS 0, 16574413 RAISED
    @ 013, 245 BUTTON oBTSair       PROMPT "Sair"       SIZE 037, 014 OF oPanel2 ACTION oDlgTela:End()      PIXEL
    @ 013, 008 BUTTON oBtAnexo      PROMPT "Anexar"     SIZE 037, 014 OF oPanel2 ACTION Anexar(aListBox,.T.)    PIXEL
    @ 013, 047 BUTTON oBtExcluir    PROMPT "Excluir"    SIZE 037, 014 OF oPanel2 ACTION DelAnex(aListBox,oListBox1:nAt)           PIXEL
    @ 013, 087 BUTTON oBtAbrir      PROMPT "Abrir"      SIZE 037, 014 OF oPanel2 ACTION OpenAnex(aListBox,oListBox1:nAt,.T.)  PIXEL
    oBTSair:SetCSS(CSSBOTAO)
    oBTAnexo:SetCSS(CSSBOTAO)
    oBTExcluir:SetCSS(CSSBOTAO)
    oBTAbrir:SetCSS(CSSBOTAO)
    oBTSair:cToolTip    := "Volta para tela principal"
    oBTAnexo:cToolTip   := "Adiciona novo arquivo a lista"
    oBTExcluir:cToolTip := "Remove um arquivo da lista"
    oBTAbrir:cToolTip   := "Abre um arquivo selecionado"
    oBtAnxSol:cToolTip  := "Anexo Solicitante"
    //oBtAbrSol:cToolTip  := "Abre Anexo Solicitante"
    //oBtExcSol:cToolTip  := "Exclui Anexo Solicitante"
    oListBox1:SETFOCUS()

  ACTIVATE MSDIALOG oDlgTela CENTERED


Return


/*/{Protheus.doc} Function AnexoSol
Description
Salva arquivos anexo Solicitante
@author Valdemir Rabelo - valdemir.rabelo@totvs.com.br
@since 16/08/2019
/*/
Static Function AnexoSol(aListBox)
    Local cCaminAnt := _cServerDir
    
    _cServerDir := _cStartPath+_cContro+"\Solicitante\"

    if INCLUI
       apMsgInfo(_cMsgInclui,"Atenção!")
       Return .F.
    endif 

    if __cUserID != _cSOLICI
        FWMsgRun(, {|| Sleep(3000)},"Informação","Somente solicitante pode anexar arquivos neste botão")
        _cServerDir := cCaminAnt
        RETURN
    Endif
    Anexar(aListBox)
    _cServerDir := cCaminAnt
Return




//--------------------------------------------------------------
/*/{Protheus.doc} Function GDocAnex
Description
Carrega arquivos anexados
@author Valdemir Rabelo - valdemir.rabelo@totvs.com.br
@since 12/08/2019
/*/
//--------------------------------------------------------------
Static Function GDocAnex(cGetDepto)
    Local aRET          := {}
    Local aTMP          := {}
    Local aTMP1         := {}
    Local aTMP2         := {}
    Local aSizes        := {}
    Local cTMP          := ""
    Local nX

    _cStartPath := "\arquivos\PAA\"
    _cServerDir := ""

    //Criação das pastas para salvar os anexos das Solicitações de Analise
	_cServerDir += _cStartPath
	If MakeDir(_cServerDir) == 0
		MakeDir(_cServerDir)
	Endif

    _cServerDir += _cContro+"\"
    If MakeDir (_cServerDir) == 0
        MakeDir(_cServerDir)
    Endif

    _cDirSolic := _cServerDir
    _cServerDir += Alltrim(cGetDepto)+"\"
    If MakeDir(_cServerDir) == 0
        MakeDir(_cServerDir)
    Endif

    _cDirSolic += "Solicitante\"
    If MakeDir(_cDirSolic) == 0
        MakeDir(_cDirSolic)
    Endif

    // Busco conteudo do diretório
    aDir(_cServerDir+"*.*", aTMP1, aSizes)

    // Busco conteudo do diretório Solicitante
    aDir(_cDirSolic+"*.*", aTMP2, aSizes)

    if Len(aTMP1)+Len(aTMP2)==0
        aAdd(aTMP, "")
        aRET := aTMP
    else
        For nX := 1 to Len(aTMP1)
           cTMP := _cServerDir + aTMP1[nX]
           aAdd(aTMP, cTMP)
        Next
        For nX := 1 to Len(aTMP2)
            cTMP := _cDirSolic + aTMP2[nX]
            aAdd(aTMP, cTMP)
        Next

        aRET := aClone(aTMP)
    endif

RETURN aRET


//--------------------------------------------------------------
/*/{Protheus.doc} Function Anexar
Description
Rotina para anexar arquivo
@author Valdemir Rabelo - valdemir.rabelo@totvs.com.br
@since 12/08/2019
/*/
//--------------------------------------------------------------
Static Function Anexar(paListBox, lTrava)
    Local _cSave    := _cContro + "_" + Alltrim(aCols[n][GDFieldPos("Z46_DEPTO")])
    Local _lRet     := .T.
    Local _cLocArq  := ''
    Local _cDir     := ''
    Local _cArq     := ''
    Local cExtensao := ''
    Local nTamOrig  := ''
    Local nMB       := 1024
    Local nTamMax   := 2
    Local cMascara  := "Todos os arquivos"
    Local cTitulo   := "Escolha o arquivo"
    Local nMascpad  := 0
    Local cDirini   := "c:\"
    Local lSalvar   := .T. /*.F. = Salva || .T. = Abre*/
    Local lArvore   := .F. /*.T. = apresenta o Ã¡rvore do servidor || .F. = nÃ£o apresenta*/
    Local _cMsgSave := ""
    Local aArea1    := GetArea()
    Local aArea2    := PH1->(GetArea())
    Default lTrava  := .F.

    if INCLUI
       apMsgInfo(_cMsgInclui,"Atenção!")
       Return .F.
    endif 

    // Valida se o usuário tem permissão para anexar
    if __cUserID != _cSOLICI
        if !u_VLDRESPO(__cUserID)
        RETURN
        Endif
    elseif (__cUserID == _cSOLICI)  .and. lTrava .and. (alltrim(_cDepto) != Alltrim(aCols[n][1]))
        FWMsgRun(, {|| Sleep(3000)},"Informação","Solicitante não pode anexar em outro departamento.")
        RETURN
    Endif

    //Local nOpcoes   := GETF_LOCALHARD
    // OpÃƒÂ§ÃƒÂµes permitidas
    //GETF_NOCHANGEDIR    // Impede que o diretorio definido seja mudado
    //GETF_LOCALFLOPPY    // Mostra arquivos do drive de Disquete
    //GETF_LOCALHARD      // Mostra arquivos dos Drives locais como HD e CD/DVD
    //GETF_NETWORKDRIVE   // Mostra pastas compartilhadas da rede
    //GETF_RETDIRECTORY   // Retorna apenas o diretÃƒÂ³rio e nÃ£o o nome do arquivo

    _cLocArq  := cGetFile( cMascara, cTitulo, nMascpad, cDirIni, lSalvar,, lArvore)
    _cArqSalv := RETNOMEARQ(_cLocArq)
    _cArqSalv := Left(_cArqSalv,At('.',_cArqSalv)-1)

    If !(Empty(_cLocArq))
        nTamOrig := Directory(_cLocArq)[1,2]
        If (nTamOrig/nMB) > (nMB*nTamMax)
            Aviso("Tamanho do Arquivo Superior ao Permitido";       //01 - cTitulo - TÃƒÂ­tulo da janela
            ,"O Arquivo '"+_cArq+"' tem que ter tamanho máximo de "+cValtoChar(nTamMax)+"MB."+ Chr(10) + Chr(13) +;
            CHR(10)+CHR(13)+;
            "Ação não permitida.",;          //02 - cMsg - Texto a ser apresentado na janela.
            {"OK"};                          //03 - aBotoes - Array com as opÃƒÂ§ÃƒÂµes dos botÃƒÂµes.
            ,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
            ,;                               //05 - cText - Titulo da DescriÃ§Ã£o (Dentro da Janela)
            ,;                               //06 - nRotAutDefault - OpÃ§Ã£o padrÃ£o usada pela rotina automÃ¡tica
            ,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
            ,.F.;                            //08 - lEdit - Determina se permite a ediÃ§Ã£o do campo memo
            ,;                               //09 - nTimer - Tempo para exibiÃ§Ã£o da mensagem em segundos.
            ,;                               //10 - nOpcPadrao - OpÃ§Ã£o padrÃ£o apresentada na mensagem.
            )
            Return
        EndIf

        If Len(Directory(_cServerDir+_cArqSalv+".mzp")) = 1
            _lRet := MsgYesNo("Já existe um arquivo anexado."+ Chr(10) + Chr(13) +" Deseja sobrepor o arquivo existente ???","Atenção")
        Endif

        If _lRet

            _cLocArq  := Alltrim(_cLocArq)
            _cDir     := SUBSTR(_cLocArq, 1                      ,RAT( "\"   , _cLocArq ))
            _cArq     := SUBSTR(_cLocArq, RAT( "\"   , _cLocArq ),Len(_cLocArq))
            _cArq     := StrTran(_cArq,"\","")
            
            cExtensao := SUBSTR(_cLocArq,Rat(".",_cLocArq),Len(_cLocArq))

            If At(".",cExtensao) == 1

                //Copio o arquivo original da máquina do usuário para o servidor
                lSucess   := __CopyFile(_cLocArq, _cServerDir+_cArqSalv+cExtensao)

                If lSucess

                    //Realizo a compactação do arquivo para a extensão .mzp
                    MsCompress((_cServerDir+_cArqSalv+cExtensao),(_cServerDir+_cArqSalv+".mzp"))

                    //Apago o arquivo original do servidor
                    Ferase( _cServerDir+_cArqSalv+cExtensao)
                    Aviso("Anexar Arquivo";                             //01 - cTitulo - Tí­tulo da janela
                    ,"O Arquivo '"+_cArq+"' foi anexado com sucesso.",; //02 - cMsg - Texto a ser apresentado na janela.
                    {"OK"};                                             //03 - aBotoes - Array com as opç~ees dos botões.
                    ,3;                                                 //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
                    ,;                                                  //05 - cText - Titulo da Descrição (Dentro da Janela)
                    ,;                                                  //06 - nRotAutDefault - Opção padrão usada pela rotina automática
                    ,;                                                  //07 - cBitmap - Nome do bitmap a ser apresentado
                    ,.F.;                                               //08 - lEdit - Determina se permite a edição do campo memo
                    ,;                                                  //09 - nTimer - Tempo para exibição da mensagem em segundos.
                    ,;                                                  //10 - nOpcPadrao - Opção padrão apresentada na mensagem.
                    )
                    if Empty(paListBox[1])
                        paListBox := {}
                    endif

                    aAdd(paListBox, _cServerDir+_cArqSalv+cExtensao )

                    _cSave += ".mzp"
                    _cMsgSave += "===================================" +CHR(13)+CHR(10)
                    _cMsgSave += "Documento "+Alltrim(_cArq)+" anexado com sucesso por: " +CHR(13)+CHR(10)
                    _cMsgSave += "UsuÃ¡rio: "+cUserName+CHR(13)+CHR(10)
                    _cMsgSave += "Em: "+DTOC(DDATABASE)+" "+TIME()+CHR(13)+CHR(10)

                    // Marco que existe anexos
                    RecLock("Z45",.F.)
                    Z45->Z45_ANEXOS := "X"
                    MsUnlock()

                Else
                    _cSave := ''
                    Aviso("Problema ao Anexar Arquivo";     //01 - cTitulo - Tí­tulo da janela
                    ,"O Arquivo '"+_cArq+"' nÃ£o foi anexado."+ Chr(10) + Chr(13) +;
                    CHR(10)+CHR(13)+;
                    "Favor verificar com o TI.",;   //02 - cMsg - Texto a ser apresentado na janela.
                    {"OK"};                          //03 - aBotoes - Array com as opções dos botões.
                    ,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
                    ,;                               //05 - cText - Titulo da Descrição (Dentro da Janela)
                    ,;                               //06 - nRotAutDefault - Opção padrão usada pela rotina automÃ¡tica
                    ,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
                    ,.F.;                            //08 - lEdit - Determina se permite a edição do campo memo
                    ,;                               //09 - nTimer - Tempo para exibição da mensagem em segundos.
                    ,;                               //10 - nOpcPadrao - Opção padrão apresentada na mensagem.
                    )
                EndIf

            Else
                Aviso("Problema com Extensão do Anexo"; //01 - cTitulo - TÃƒÂ­tulo da janela
                ,"A Extensão "+cExtensao+" Ação inválida para anexar junto ao registro."+ Chr(10) + Chr(13) +;
                CHR(10)+CHR(13)+;
                "Ação não permitida.",; //02 - cMsg - Texto a ser apresentado na janela.
                {"OK"};                          //03 - aBotoes - Array com as opÃƒÂ§ÃƒÂµes dos botÃƒÂµes.
                ,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
                ,;                               //05 - cText - Titulo da DescriÃ§Ã£o (Dentro da Janela)
                ,;                               //06 - nRotAutDefault - OpÃ§Ã£o padrÃ£o usada pela rotina automÃ¡tica
                ,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
                ,.F.;                            //08 - lEdit - Determina se permite a ediÃ§Ã£o do campo memo
                ,;                               //09 - nTimer - Tempo para exibiÃ§Ã£o da mensagem em segundos.
                ,;                               //10 - nOpcPadrao - OpÃ§Ã£o padrÃ£o apresentada na mensagem.
                )
            Endif
        Endif

    Else
        Aviso("Anexar Arquivo";                                 //01 - cTitulo - TÃƒÂ­tulo da janela
        ,"Nenhum Arquivo foi selecionado para ser anexado.",;   //02 - cMsg - Texto a ser apresentado na janela.
        {"OK"};                                                 //03 - aBotoes - Array com as opÃƒÂ§ÃƒÂµes dos botÃƒÂµes.
        ,3;                                                     //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
        ,;                                                      //05 - cText - Titulo da DescriÃ§Ã£o (Dentro da Janela)
        ,;                                                      //06 - nRotAutDefault - OpÃ§Ã£o padrÃ£o usada pela rotina automÃ¡tica
        ,;                                                      //07 - cBitmap - Nome do bitmap a ser apresentado
        ,.F.;                                                   //08 - lEdit - Determina se permite a ediÃ§Ã£o do campo memo
        ,;                                                      //09 - nTimer - Tempo para exibiÃ§Ã£o da mensagem em segundos.
        ,;                                                      //10 - nOpcPadrao - OpÃ§Ã£o padrÃ£o apresentada na mensagem.
        )
    Endif

    RestArea(aArea2)
    RestArea(aArea1)

Return


//--------------------------------------------------------------
/*/{Protheus.doc} Function OpenAnex
Description
Rotina para anexar arquivo
@author Valdemir Rabelo - valdemir.rabelo@totvs.com.br
@since 12/08/2019
/*/
//--------------------------------------------------------------
Static Function OpenAnex(paListBox, pnLinAtu, lTrava)
    Local _cSaveArq   := "C:\ARQUIVOS_PROTHEUS"
    Local _cSaveArq2  := "\arquivos"
    Local _cSaveArq3  := "\PAA"
	Local _cOpen      := ''
	Local cZipFile    := ''
	Local _lUnzip     := .T.
    Local _cLocalDir  := ""   // Arquivo Posicionado
    Default paListBox := {}
    Default pnLinAtu  := 0
    Default lTrava    := .T.

    // Crio pasta local para ser descompactado o arquivo
    _cLocalDir += (_cSaveArq)
	If MakeDir (_cLocalDir) == 0
		MakeDir(_cLocalDir)
    Endif

    //Criação das pastas para salvar os anexos das Solicitações de Analise
	_cLocalDir += _cSaveArq2
	If MakeDir(_cLocalDir) == 0
		MakeDir(_cLocalDir)
	Endif

    _cLocalDir += _cSaveArq3
    If MakeDir(_cLocalDir) == 0
        MakeDir(_cLocalDir)
    Endif

    _cLocalDir += "\"+_cContro
    If MakeDir(_cLocalDir) == 0
        MakeDir(_cLocalDir)
    Endif

    MakeDir(_cLocalDir+"\Solicitante")
    /*
    if !lTrava
        cGetDepto := "\Solicitante"
    else
        cGetDepto := "\"+Alltrim(aCols[n][GDFieldPos("Z46_DEPTO")])
    endif
    */
    // Pegar Posição Departamento
    nPosFDep  := AT("\", Substr(paListBox[pnLinAtu],25,Len(paListBox[pnLinAtu]) ))
    cGetDepto := "\"+Substr(paListBox[pnLinAtu],25,nPosFDep-1)

    _cLocalDir += Alltrim(cGetDepto)+"\"
    If MakeDir(_cLocalDir) == 0
        MakeDir(_cLocalDir)
    Endif

    If ExistDir(_cLocalDir)
        cZipFile := paListBox[pnLinAtu]
        if !lTrava
            if !(Left(cZipFile,Len(Substr(_cLocalDir,21,Len(_cLocalDir)))) $ Substr(_cLocalDir,21,Len(_cLocalDir)))
                FWMsgRun(,{|| Sleep(3000)},"Atenção!","Selecione o arquivo correspondente ao solicitante")
                Return
            Endif
        Endif

        DescArq(cZipFile, _cLocalDir, .T.)

    Else
        Aviso("Erro ao Salvar Anexo"; //01 - cTitulo - TÃƒÂ­tulo da janela
        ,"Houve erro ao Salvar o Anexo."+ Chr(10) + Chr(13) +;
        CHR(10)+CHR(13)+;
        "Favor entrar em contato com o TI.",; //02 - cMsg - Texto a ser apresentado na janela.
        {"OK"};                          //03 - aBotoes - Array com as opÃƒÂ§ÃƒÂµes dos botÃƒÂµes.
        ,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
        ,;                               //05 - cText - Titulo da DescriÃ§Ã£o (Dentro da Janela)
        ,;                               //06 - nRotAutDefault - OpÃ§Ã£o padrÃ£o usada pela rotina automÃ¡tica
        ,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
        ,.F.;                            //08 - lEdit - Determina se permite a ediÃ§Ã£o do campo memo
        ,;                               //09 - nTimer - Tempo para exibiÃ§Ã£o da mensagem em segundos.
        ,;                               //10 - nOpcPadrao - OpÃ§Ã£o padrÃ£o apresentada na mensagem.
        )
    Endif



Return


//--------------------------------------------------------------
/*/{Protheus.doc} Function DelAnex
Description
Rotina para excluir anexo
@author Valdemir Rabelo - valdemir.rabelo@totvs.com.br
@since 12/08/2019
/*/
//--------------------------------------------------------------
Static Function DelAnex(paListBox,pnAt,lTrava)
    Local _cDelete := ''
    Local _lRet    := .T.
    Local _cMsgDel := ""
    Local aArea2   := GetArea()
    Local cArqSel  := if(Len(paListBox) > 0,paListBox[pnAt],"")
    Default lTrava := .F.

    if __cUserID != _cSolici
        // Valida se o usuário tem permissão para abrir documento
        if !u_VLDRESPO(__cUserID)
            RETURN
        Endif
    elseif (__cUserID == _cSolici) .and. lTrava .and. (alltrim(_cDepto) != Alltrim(aCols[n][1]))
        FWMsgRun(, {|| Sleep(3000)},"Informação","Solicitante deve usar o botão de abrir do cabaçalho.")
        RETURN
    endif

	If Len(Directory(cArqSel)) = 1
		_lRet := MsgYesNo("Deseja deletar o Arquivo ??? "+ Chr(10) + Chr(13) +" Uma vez confirmada essa ação o arquivo não ficará mais disponí­vel para consulta.","Atenção")
	Else
		_lRet := .F.
		Aviso("Deletar Anexo"; //01 - cTitulo - TÃƒÂ­tulo da janela
		,"Não existe nenhum Arquivo para ser deletado."+ Chr(10) + Chr(13) +;
		CHR(10)+CHR(13)+;
		"Ação não permitida.",; //02 - cMsg - Texto a ser apresentado na janela.
		{"OK"};                          //03 - aBotoes - Array com as opÃƒÂ§ÃƒÂµes dos botÃƒÂµes.
		,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
		,;                               //05 - cText - Titulo da DescriÃ§Ã£o (Dentro da Janela)
		,;                               //06 - nRotAutDefault - OpÃ§Ã£o padrÃ£o usada pela rotina automÃ¡tica
		,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
		,.F.;                            //08 - lEdit - Determina se permite a ediÃ§Ã£o do campo memo
		,;                               //09 - nTimer - Tempo para exibiÃ§Ã£o da mensagem em segundos.
		,;                               //10 - nOpcPadrao - OpÃ§Ã£o padrÃ£o apresentada na mensagem.
		)
	Endif

    If _lRet
        if File(cArqSel)
            Ferase( cArqSel )
            aDel(paListBox, pnAt)
            aSIZE( paListBox, Len(paListBox)-1 )

            _cDelete := ''
            _cMsgDel += "===================================" +CHR(13)+CHR(10)
            _cMsgDel += "Documento "+RetFileName(Alltrim(cArqSel))+" deletado com sucesso por: " +CHR(13)+CHR(10)
            _cMsgDel += "Usuário: "+cUserName+CHR(13)+CHR(10)
            _cMsgDel += "Em: "+DTOC(DDATABASE)+" "+TIME()+CHR(13)+CHR(10)
        endif
	Endif

	RestArea(aArea2)


Return

//--------------------------------------------------------------
/*/{Protheus.doc} Function VLDPAA02
Description
Rotina do linhaOK, faz validação referente ao usuário logado se
faz parte do departamento da linha que esta
@author Valdemir Rabelo - valdemir.rabelo@sigamat.com.br
@since 23/08/2019
/*/
//--------------------------------------------------------------
User Function VLDPAA02()
    Local lRET    := .T.
    Local cUsrTMP := ""
    Local cCampo  := ReadVar()

    cUsrTMP := GetDepto(aCols[n][1])

    if (right(cCampo,10)=="Z46_APROVA") .or. (right(cCampo,10)=="Z46_ACLOTE") .or. (right(cCampo,10)=="Z46_COMENT")  .or. (right(cCampo,10)=="Z46_RESPON")

        lRET := (__cUserID $ cUsrTMP)

        if !lRET
            FWMsgRun(,{|| sleep(3000)},"Atenção!","Usuário não faz parte deste departamento.")
        Endif

    Endif

Return lRET


/*/{Protheus.doc} Function STCPAA2A
Description
Rotina para abrir pasta com anexos referente ao departamento que está posicionado o registro
@author Valdemir Rabelo - valdemir.rabelo@sigamat.com.br
@since 03/09/2019
/*/
User Function STCPAA2A(lValida)
    Local _cSaveArq   := "C:\ARQUIVOS_PROTHEUS"
    Local _cSaveArq2  := "\arquivos"
    Local _cSaveArq3  := "\PAA"
    Local _cOpen      := ''
    Local cZipFile    := ''
    Local _lUnzip     := .T.
    Local _cLocalDir  := ""   // Arquivo Posicionado
    Local aArea       := GetArea()
    Local lRET        := .F.
    Local lExiste     := .F.
    Local nX
    Default lValida   := .F.

    _cContro := Z45->Z45_CONTRO

    dbSelectArea('Z46')
    dbSetOrder(1)
    dbSeek(xFilial('Z46')+_cContro)

    // -------------------- Crio pastas 'local' para ser descompactado o arquivo --------------------
    _cLocalDir += (_cSaveArq)
    If MakeDir (_cLocalDir) == 0
        MakeDir(_cLocalDir)
    Endif

    //Criação das pastas para salvar os anexos das Solicitações de Analise "LOCAL"
    _cLocalDir += _cSaveArq2
    If MakeDir(_cLocalDir) == 0
        MakeDir(_cLocalDir)
    Endif

    _cLocalDir += _cSaveArq3
    If MakeDir(_cLocalDir) == 0
        MakeDir(_cLocalDir)
    Endif

    _cLocalDir += "\"+_cContro
    If MakeDir(_cLocalDir) == 0
        MakeDir(_cLocalDir)
    Endif
    //---------------------------------------------------------------------------------------------------

    If ExistDir(_cLocalDir)
       While !Eof() .and. (_cContro == Z46->Z46_CONTRO)
            _cLocalTMP := _cLocalDir+"\"+Alltrim(Z46->Z46_DEPTO)+"\"
            If MakeDir(_cLocalTMP) == 0
                MakeDir(_cLocalTMP)
            Endif
            aLista   := GDocAnex(Z46->Z46_DEPTO)    // Busca por departamentos
            For nX := 1 to Len(aLista)
               if !Empty(aLista[nX])
                    cZipFile := aLista[nX]
                    DescArq(cZipFile, _cLocalTMP, .F.)
                    if !lExiste
                        lExiste := .T.
                    endif
               endif 
            Next
            _cLocalTMP := ""
           dbSkip()
        EndDo
        RecLock('Z45',.F.)
        Z45->Z45_ANEXOS := if(lExiste,"X","")
        MsUnlock()
    Else
        Aviso("Erro ao Salvar Anexo"; //01 - cTitulo - TÃƒÂ­tulo da janela
        ,"Houve erro ao Salvar o Anexo."+ Chr(10) + Chr(13) +;
        CHR(10)+CHR(13)+;
        "Favor entrar em contato com o TI.",; //02 - cMsg - Texto a ser apresentado na janela.
        {"OK"};                          //03 - aBotoes - Array com as opÃƒÂ§ÃƒÂµes dos botÃƒÂµes.
        ,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
        ,;                               //05 - cText - Titulo da DescriÃ§Ã£o (Dentro da Janela)
        ,;                               //06 - nRotAutDefault - OpÃ§Ã£o padrÃ£o usada pela rotina automÃ¡tica
        ,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
        ,.F.;                            //08 - lEdit - Determina se permite a ediÃ§Ã£o do campo memo
        ,;                               //09 - nTimer - Tempo para exibiÃ§Ã£o da mensagem em segundos.
        ,;                               //10 - nOpcPadrao - OpÃ§Ã£o padrÃ£o apresentada na mensagem.
        )
    Endif


    if !lValida
        winexec("explorer.exe "+_cLocalDir)
    endif

    RestArea( aArea )

Return



/*/{Protheus.doc} Function DescArq
Description
Rotina para Descompactar e criar a pasta onde ficará o arquivo
@author Valdemir Rabelo - valdemir.rabelo@sigamat.com.br
@since 03/09/2019
/*/
Static Function DescArq(cZipFile, _cLocalDir, lAbre)
    Local _lUnzip := .F.
    Default lAbre := .T.

    if Empty(cZipFile)
        Return .F.
    Endif

    If Len(Directory(cZipFile)) = 1
        CpyS2T  ( cZipFile , _cLocalDir, .T. )
        cArqZip := RETNOMEARQ(cZipFile)
        _cLocalDir := Left(_cLocalDir, Len(_cLocalDir)-1)
        _lUnzip := MsDecomp(_cLocalDir+"\"+cArqZip  , _cLocalDir )
        If _lUnzip
            Ferase  ( _cLocalDir+"\"+cArqZip )
            if lAbre
                ShellExecute("open", _cLocalDir, "", "", 1)
            endif
        Else
            Aviso("Erro para Descompactar Anexo"; //01 - cTitulo - TÃƒÂ­tulo da janela
            ,"Houve erro para Descompactar o Anexo."+ Chr(10) + Chr(13) +;
            CHR(10)+CHR(13)+;
            "Favor entrar em contato com o TI.",; //02 - cMsg - Texto a ser apresentado na janela.
            {"OK"};                          //03 - aBotoes - Array com as opÃƒÂ§ÃƒÂµes dos botÃƒÂµes.
            ,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
            ,;                               //05 - cText - Titulo da DescriÃ§Ã£o (Dentro da Janela)
            ,;                               //06 - nRotAutDefault - OpÃ§Ã£o padrÃ£o usada pela rotina automÃ¡tica
            ,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
            ,.F.;                            //08 - lEdit - Determina se permite a ediÃ§Ã£o do campo memo
            ,;                               //09 - nTimer - Tempo para exibiÃ§Ã£o da mensagem em segundos.
            ,;                               //10 - nOpcPadrao - OpÃ§Ã£o padrÃ£o apresentada na mensagem.
            )
        Endif
    Else
        Aviso("Anexo inválido"; //01 - cTitulo - TÃƒÂ­tulo da janela
        ,"Não existe nenhum anexo no Protheus para ser aberto."+ Chr(10) + Chr(13) +;
        CHR(10)+CHR(13)+;
        "Ação não permitida.",; //02 - cMsg - Texto a ser apresentado na janela.
        {"OK"};                          //03 - aBotoes - Array com as opÃƒÂ§ÃƒÂµes dos botÃƒÂµes.
        ,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
        ,;                               //05 - cText - Titulo da DescriÃ§Ã£o (Dentro da Janela)
        ,;                               //06 - nRotAutDefault - OpÃ§Ã£o padrÃ£o usada pela rotina automÃ¡tica
        ,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
        ,.F.;                            //08 - lEdit - Determina se permite a ediÃ§Ã£o do campo memo
        ,;                               //09 - nTimer - Tempo para exibiÃ§Ã£o da mensagem em segundos.
        ,;                               //10 - nOpcPadrao - OpÃ§Ã£o padrÃ£o apresentada na mensagem.
        )
    Endif

Return _lUnzip


/*/{Protheus.doc} User Function RETNOMEARQ
    (long_description)
    Retorna o nome do arquivo. Criado este pelo fato do padrão estar
    me retornando em branco
    @author user
    Valdemir Rabelo - SigaMat
    @since 03/09/2019
/*/
Static Function RETNOMEARQ(_pArquivo)
	Local _cRET := ""
    Local nX    := 0
    Local iSoma := 1

    FOR nX := LEN(_pArquivo) TO 1 step -1

      if Substr(_pArquivo, nX, 1) != "\"
      	cRET := Right(_pArquivo, iSoma)
      Else
        Return cRET
      Endif
      iSoma += 1

    NEXT


RETURN _cRET


/*/{Protheus.doc} User Function gVLDAPROV
    (long_description)
    Valida no encerramento se algum gerente reprovou a analise
    me retornando em branco
    @author user
    Valdemir Rabelo - SigaMat
    @since 04/09/2019
/*/
Static Function gVLDAPROV()
    Local cRET     := "A P R O V A D O"
    Local cDptoTMP := "GER INDUSTRIAL/MARKETING/LOGISTICA/COMERCIAL/PLANEJAMENTO CONTROLE PRODUCAO/COMPRAS"  //Leandro Godoy
    Local nX       := 0

    For nX := 1 to Len(aCols)
       if (alltrim(aCols[nX][1]) $ cDptoTMP)
            if (aCols[nX][GDFieldPos("Z46_APROVA")]=="R")
                cRET := "R E P R O V A D O"
                EXIT
            endif
        endif
    Next

Return cRET


/*/{Protheus.doc} User Function RetForMN
    (long_description)
    Retorna o nome do fornecedor da empresa de manaus
    @author user
    Valdemir Rabelo - SigaMat
    @since 04/09/2019
/*/
Static Function RetForMN(pcCampo)
    Local aRET  := {}
    Local aArea := GetArea()
    Local cQry  := ""

    cQry += "SELECT A2_COD, A2_NOME, A2_LOJA " + CRLF
    cQry += "FROM SA2030 SA2 " + CRLF
    cQry += "WHERE SA2.D_E_L_E_T_ = ' '    " + CRLF
    cQry += " AND A2_COD='" + pcCAMPO + "' " + CRLF
    cQrY += " AND A2_LOJA='01' " + CRLF
    if Select("TSA2") > 0
        TSA2->( dbCloseArea() )
    endif
    TcQuery cQry New Alias "TSA2"

    if !Eof()
        aRET := {TSA2->A2_NOME, TSA2->A2_LOJA}
    endif

    if Select("TSA2") > 0
        TSA2->( dbCloseArea() )
    endif

    RestArea( aArea )

Return aRET


/*/{Protheus.doc} User Function BSCFORMN
    (long_description)
    Retorna a seleção do registro do fornecedor de manus via F3
    @author user
    Valdemir Rabelo - SigaMat
    @since 04/09/2019
/*/
User Function BSCFORMN()
    Local aAreaF3 := GetArea()
    Local cQry    := ""
    Local nRetCol := 1			// Coluna que fará o retorno
    Local cAlias  := "SA2"
    Local aCampos := { {"Codigo","Nome"},;
                       {"A2_COD","A2_NOME"} }

    cQry += "SELECT A2_COD, A2_NOME, R_E_C_N_O_ REG " + CRLF
    cQry += "FROM SA2030 SA2 " + CRLF
    cQry += "WHERE SA2.D_E_L_E_T_ = ' '    " + CRLF
    cQry += "ORDER BY A2_COD               " + CRLF

    U_BUSCAF3(cAlias, aCampos, '', '', cQry, nRetCol)

    RestArea( aAreaF3 )

Return .T.


User Function VLDZ46(pUserID)
    Local lRET     := .F.
    Local aAreaZ46 := GetArea()
    Local _cDepto  := ""

    dbSelectArea('Z47')
    dbSetOrder(1)
    dbSeek(XFilial("Z47")+__cUserID)
    Z47->( dbEVal({ || _cDepto += Left(Z47_DEPTO,15), if(!Empty(_cDepto),_cDepto += "/",nil) },,{ || !Eof() .and. Z47_USUARI==__cUserID }))

    dbSelectArea("Z46")
    dbSetOrder(1)
    dbSeek(XFilial("Z46")+Z45->Z45_CONTRO)
    While !Eof() .and. (Z46->Z46_CONTRO==Z45->Z45_CONTRO)
      lRET := (LEFT(Z46->Z46_DEPTO,15) $ _cDepto)
      if lRET
        Exit
      endif
      dbSkip()
    EndDo

    RestArea( aAreaZ46)

Return lRET

User Function STSF4()
    
    if INCLUI
       apMsgInfo(_cMsgInclui,"Atenção!")
       Return .F.
    endif 

    TeclaF4(n)
Return 




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RETNOMEARQ  ºAutor  ³Valdemir José     º Data ³  12-08-08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Retorna o nome do Arquivo                                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GENERICO                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RETNOMEARQ(_pArquivo)
	Local _cRET := ""
    Local nX    := 0
    Local iSoma := 1
    
    FOR nX := LEN(_pArquivo) TO 1 step -1
      
      if Substr(_pArquivo, nX, 1) != "\"
      	cRET := Right(_pArquivo, iSoma)
      Else
       Return cRET
      Endif 	
      iSoma += 1
      
    NEXT
	    
	    
RETURN _cRET

/*/{Protheus.doc} User Function STCPA02E
    (long_description)
    Rotina que fará a exclusão do registro, caso não tenha aprovações
    @author user
    Valdemir Rabelo - SigaMat
    @since 14/10/2019
/*/
User Function STCPA02E()
    Local aAreaEX := GetArea()

    dbSelectArea("Z46")
    dbSetOrder(1)

    if !(Z45->Z45_STATUS $ "E/G/A")
       if MsgNoYes("Deseja realmente excluir o registro?")
          Z46->( dbSeek(xFilial('Z46')+Z45->Z45_CONTRO) )
          While Z46->( !Eof() .and. Z46_CONTRO==Z45->Z45_CONTRO )
             RecLock("Z46", .f.)
             Z46->( dbDelete() )
             MsUnlock()
             Z46->( dbSkip() )
          EndDo
          RecLock("Z45",.F.)
          Z45->( dbDelete() )
          MsUnlock()
       endif
    Else
       LjMsgRun("Registro não pode ser excluido, seu status atual não permite esta ação","Atenção!!!",{|| sleep(4000)})
    Endif

    RestArea( aAreaEX )

Return
