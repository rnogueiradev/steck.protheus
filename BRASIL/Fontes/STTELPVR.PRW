#Include "Protheus.ch"
#Include "Totvs.ch"

/*/Protheus.doc STTELPVL
(long_description) Tela de Consulta de Pedido conforme leitura de CSV para gravacao dos motivos de rejeições
@author user Eduardo Pereira
@since 18/11/2020
@version 12.1.27
/*/

User Function STTELPVR()

Local cDir     := cGetFile("Arquivo CSV|*.csv|"          ,;	//[ cMascara], 
                	"Selecao de Arquivos"					   ,; //[ cTitulo], 
                    0											   ,; //[ nMascpadrao], 
                    ""											   ,; //[ cDirinicial], 
                    .F.											   ,; //[ lSalvar], 
                    GETF_LOCALHARD  + GETF_NETWORKDRIVE	,; //[ nOpcoes], 
              	      .T.									 	    ) //[ lArvore]
Local cLinha   := ""
Local lPrim    := .T.
Local nLin     := 0
Local aCampos  := {}
Local aDados   := {}
Local aVetor   := {}
Local i        := 0
Local cVar     := Nil
Local oDlg     := Nil
Local cTitulo  := "Consulta de Pedidos Rejeitados"
Local oOk      := LoadBitmap( GetResources(), "LBOK" )   //CHECKED    //LBOK  //LBTIK
Local oNo      := LoadBitmap( GetResources(), "LBNO" )   //UNCHECKED  //LBNO
Local oChk     := Nil
Private lMark  := .T.
Private oLbx   := Nil
Private aErro  := {}
Private cCaminho 	:= ""
Private cArquivo	:= ""

cCaminho := Substr(cDir,1,RAt("\",cDir))	// Apenas o caminho onde se encontra o xls

cArquivo := RetFileName(cDir) + ".csv"	// Apenas o arquivo csv

If !File(cCaminho + cArquivo)
	MsgStop("O arquivo " + cCaminho + cArquivo + " não foi encontrado. A importação será abortada!","[STTELPVR] - ATENCAO")
	Return
EndIf
 
FT_FUSE(cCaminho + cArquivo)
ProcRegua(FT_FLASTREC())
FT_FGOTOP()

While !FT_FEOF()
	IncProc("Lendo arquivo texto...")
	cLinha := FT_FREADLN()
	If lPrim
		aCampos := Separa(cLinha,";",.T.)
		lPrim := .F.
	Else
		aAdd(aDados,Separa(cLinha,";",.T.))
	EndIf 
	FT_FSKIP()
End

// Monta a tela para usuario visualizar consulta
If Len( aDados ) == 0
   Aviso( cTitulo, "Nao existe registro no arquivo a consultar", {"Ok"} )
   Return
EndIf

For i := 1 to Len(aDados)
   SC5->( dbSetOrder(1) ) // C5_FILIAL + C5_NUM
   If SC5->( dbSeek( Substr(aDados[i,2],1,2) + Substr(aDados[i,2],3,6)) )
      cNomCli := Posicione("SA1", 1, xFilial("SA1") + SC5->C5_CLIENTE, "A1_NOME")
      cMotRej := aDados[i,3]
      If SC5->C5_CLIENTE == PadL(aDados[i,1],6,"0")
         aAdd( aVetor, { lMark, SC5->C5_FILIAL, SC5->C5_NUM, SC5->C5_CLIENTE, SC5->C5_LOJACLI, cNomCli, SC5->C5_EMISSAO, cMotRej } )
         nLin++
      Else
         ApMsgInfo("Código do Cliente do arquivo: " + Alltrim(aDados[i,1]),"[STTELPVR] - SUCESSO")
      EndIf
   EndIf
Next i

// Monta a tela para usuario visualizar consulta
If Len( aVetor ) == 0
   Aviso( cTitulo, "Nao existe Pedidos a consultar", {"Ok"} )
   Return
EndIf

DEFINE MSDIALOG oDlg TITLE cTitulo FROM 0,0 TO 500 ,750 PIXEL
oFWLMain := FWLayer():New()
oFWLMain:Init( oDlg, .T. )
oFWLMain:AddCollumn( "Col01", 100, .T.,"LineSup" )
oFWLMain:AddWindow( "Col01", "Win01", cTitulo, 100, .F., .F.,/*bAction*/,"LineSup",/*bGotFocus*/)
oWin1 := oFWLMain:GetWinPanel('Col01','Win01',"LineSup" )
@ 05,05 LISTBOX oLbx VAR cVar FIELDS HEADER " ", "Filial", "Nro Pedido", "Cliente", "Loja", "Nome", "Dt. Emissao", "Motivo Rejeição" SIZE 359,192 OF oWin1 PIXEL ON dblClick(aVetor[oLbx:nAt,1] := !aVetor[oLbx:nAt,1],oLbx:Refresh())
oLbx:SetArray( aVetor )
oLbx:bLine := {|| {Iif(aVetor[oLbx:nAt,1],oOk,oNo),;  // Marca e Desmarca
                       aVetor[oLbx:nAt,2],;           // Filial
                       aVetor[oLbx:nAt,3],;           // Numero do Pedido
                       aVetor[oLbx:nAt,4],;           // Cliente
                       aVetor[oLbx:nAt,5],;           // Loja
                       aVetor[oLbx:nAt,6],;           // Nome do Cliente
                       aVetor[oLbx:nAt,7],;           // Data de Emissao
                       aVetor[oLbx:nAt,8]}}           // Motivo da Rejeição
// Para marcar e desmarcar todos existem duas opçoes, acompanhe...
If oChk <> Nil
   @ 205,10 CHECKBOX oChk VAR lMark PROMPT "Marca/Desmarca" SIZE 60,007 PIXEL OF oWin1 ON Click(Iif(lMark,Marca(lMark),Marca(lMark)))
EndIf
@ 205,10 CHECKBOX oChk VAR lMark PROMPT "Marca/Desmarca" SIZE 60,007 PIXEL OF oWin1 ON Click(aEval(aVetor,{|x| x[1] := lMark}),oLbx:Refresh())
// Botoes
oBtnPesq := TButton():New( 200, 250,"Gravar Rejeições",oWin1,{||MsgRun("Selecionando dados, aguarde...",,{||If(MsgYesNo("Deseja gravar o(s) motivo(s) de rejeiçõe(s) de todo(s) o(s) " + Alltrim(Str(nLin)) + " Pedido(s)?", "Confirma?"),Processa( {|lEnd| GrvMotRj(@aVetor) }, "Analisando o arquivo..."),oDlg:End()),oDlg:End()})},060,016,,,,.T.,,"",,,,.F. )
oBtnPesq:SetCss(SetCssImg("","Primary"))
oBtnPesq := TButton():New( 200, 319,"Sair",oWin1,{||oDlg:End()},045,016,,,,.T.,,"",,,,.F. )
oBtnPesq:SetCss(SetCssImg("","Danger"))
ACTIVATE MSDIALOG oDlg CENTER

FT_FUSE()

Return

/*/Protheus.doc Marca(lMarca)
(long_description) Marca e Desmarca
@author user Eduardo Pereira - Sigamat
@since 26/10/2020
@version 12.1.27
/*/

Static Function Marca(lMarca)

Local i := 0

For i := 1 To Len(aVetor)
   aVetor[i][1] := lMarca
Next i

oLbx:Refresh()

Return

/*/Protheus.doc SetCssImg
(long_description) Funcao para setar CSS e Imagem nos Botoes
@author user Eduardo Pereira
@since 27/10/2020
@version 12.1.27
/*/

Static Function SetCssImg(cImg,cTipo)

Local cCssRet	:= ""
Default cImg	:= "rpo:yoko_sair.png"
Default cTipo	:= "Botao Branco"

If cTipo == "Primary"  
	cCssRet := "QPushButton {"  
	cCssRet += " color:#fff;background-color:#007bff;border-color:#007bff "
	cCssRet += "}"
EndIf

If cTipo == "Danger"  
	cCssRet := "QPushButton {"  
	cCssRet += " color:#fff;background-color:#dc3545;border-color:#dc3545 "
	cCssRet += "}"
EndIf

Return cCssRet

/*/Protheus.doc GrvMotRj
(long_description) Faz a gravação dos motivos das rejeiçoes dos Pedido de Vendas selecionados na tela
@author user Eduardo Silva
@since 18/11/2020
@version 12.1.27
/*/

Static Function GrvMotRj(aVetor)

Local aArea     := GetArea()
Local aAreaC5   := SC5->( GetArea() )
Local aAreaC6   := SC6->( GetArea() )
Local i         := 0
Local cVendNew  := ""
Local _cc5Mail  := ""

ProcRegua(Len(aVetor))

Begin Transaction
	For i := 1 to Len(aVetor)
      If aVetor[i][1] == .T.
         IncProc("Gravando motivo de rejeição do Pedido..." + aVetor[i,3])
         SC5->( dbSetOrder(1) ) // C5_FILIAL + C5_NUM
         If SC5->( dbSeek( aVetor[i,2] + aVetor[i,3]) )
            RecLock("SC5",.F.)
            SC5->C5_ZMOTREJ := Alltrim(aVetor[i,8])
            MsUnLock()
         EndIf
         cVendNew := Alltrim(SC5->C5_ZMOTREJ)
         If Empty(Alltrim(SC5->C5_PEDEXP))
            _cc5Mail := Alltrim(Posicione("SA3",1,xFilial("SA3") + SC5->C5_VEND2,"A3_EMAIL")) + " ; " + Alltrim(Posicione("SA3",1,xFilial("SA3")+SC5->C5_VEND1,"A3_EMAIL")) + " ; " + Alltrim(Posicione("SA3",1,xFilial("SA3") + (Alltrim(Posicione("SA3",1,xFilial("SA3") + SC5->C5_VEND1,"A3_SUPER"))),"A3_EMAIL"))
         Else
            _cc5Mail := GetMV("ST_EXMAIL",,'')
         EndIf
         u_StLibFinMail(Alltrim(cVendNew),'Rejeição',cUsername,DtoC(Date()),Time(),_cc5Mail,'Rejeição')
      EndIf
	Next i
End Transaction

RestArea(aAreaC6)
RestArea(aAreaC5)
RestArea(aArea)

ApMsgInfo("Gravação do motivo da rejeição do(s) Pedido(s) concluída com sucesso!","[STTELPVR] - SUCESSO")
 
Return
