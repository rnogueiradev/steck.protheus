#Include "Protheus.ch"
#Include "Totvs.ch"

/*/{Protheus.doc} STTELPVL
(long_description) Tela de Consulta de Pedido conforme leitura de CSV para liberacao
@type  Static Function
@author user Eduardo Pereira
@since 26/10/2020
@version version 12.1.27
@param param_name, param_type, param_descr
@return return_var, return_type, return_description
@example
(examples)
@see (links_or_references)
/*/

User Function STTELPVL()

Local cDir     := cGetFile("Arquivo CSV|*.csv|"       ,;	//[ cMascara], 
                	"Selecao de Arquivos"					,;  //[ cTitulo], 
                    0											,;  //[ nMascpadrao], 
                    ""											,;  //[ cDirinicial], 
                    .F.											,;  //[ lSalvar], 
                    GETF_LOCALHARD  + GETF_NETWORKDRIVE			,;  //[ nOpcoes], 
              	      .T.									 	 )  //[ lArvore]
//Local cArq     := "planlha para liberação do credito.csv"
Local cLinha   := ""
Local lPrim    := .T.
Local nLin     := 0
Local aCampos  := {}
Local aDados   := {}
Local aVetor   := {}
Local i        := 0
Local cVar     := Nil
Local oDlg     := Nil
Local cTitulo  := "Consulta Pedido de Venda"
Local oOk      := LoadBitmap( GetResources(), "LBOK" )   //CHECKED    //LBOK  //LBTIK
Local oNo      := LoadBitmap( GetResources(), "LBNO" )   //UNCHECKED  //LBNO
Local oChk     := Nil
Private lMark  := .T.
Private oLbx   := Nil
Private aErro  := {}
Private cCaminho 	:= ""
Private cArquivo	:= ""

cCaminho := Substr(cDir,1,RAt("\",cDir))	// Apenas o caminho onde se encontra o xls

cArquivo := RetFileName(cDir) +".csv"	// Apenas o arquivo csv

If !File(cCaminho + cArquivo)
	MsgStop("O arquivo " + cCaminho + cArquivo + " não foi encontrado. A importação será abortada!","[STTELPVL] - ATENCAO")
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
      If SC5->C5_CLIENTE == PadL(aDados[i,1],6,"0")
         aAdd( aVetor, { lMark, SC5->C5_FILIAL, SC5->C5_NUM, SC5->C5_CLIENTE, SC5->C5_LOJACLI, cNomCli, SC5->C5_EMISSAO } )
         nLin++
      Else
         ApMsgInfo("Código do Cliente do arquivo: " + Alltrim(aDados[i,1]),"[STTELPVL] - SUCESSO")
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
@ 05,05 LISTBOX oLbx VAR cVar FIELDS HEADER " ", "Filial", "Nro Pedido", "Cliente", "Loja", "Nome", "Dt. Emissao" SIZE 359,192 OF oWin1 PIXEL ON dblClick(aVetor[oLbx:nAt,1] := !aVetor[oLbx:nAt,1],oLbx:Refresh())
oLbx:SetArray( aVetor )
oLbx:bLine := {|| {Iif(aVetor[oLbx:nAt,1],oOk,oNo),;  // Marca e Desmarca
                       aVetor[oLbx:nAt,2],;           // Filial
                       aVetor[oLbx:nAt,3],;           // Numero do Pedido
                       aVetor[oLbx:nAt,4],;           // Cliente
                       aVetor[oLbx:nAt,5],;           // Loja
                       aVetor[oLbx:nAt,6],;           // Nome do Cliente
                       aVetor[oLbx:nAt,7]}}           // Data de Emissao
// Para marcar e desmarcar todos existem duas opçoes, acompanhe...
If oChk <> Nil
   @ 205,10 CHECKBOX oChk VAR lMark PROMPT "Marca/Desmarca" SIZE 60,007 PIXEL OF oWin1 ON Click(Iif(lMark,Marca(lMark),Marca(lMark)))
EndIf
@ 205,10 CHECKBOX oChk VAR lMark PROMPT "Marca/Desmarca" SIZE 60,007 PIXEL OF oWin1 ON Click(aEval(aVetor,{|x| x[1] := lMark}),oLbx:Refresh())
// Botoes
oBtnPesq := TButton():New( 200, 250,"Liberar Pedidos",oWin1,{||MsgRun("Selecionando dados, aguarde...",,{||If(MsgYesNo("Deseja liberar todos os " + Alltrim(Str(nLin)) + " Pedidos?", "Confirma?"),GeraLib(@aVetor),oDlg:End()),oDlg:End()})},060,016,,,,.T.,,"",,,,.F. )
oBtnPesq:SetCss(SetCssImg("","Primary"))
oBtnPesq := TButton():New( 200, 319,"Sair",oWin1,{||oDlg:End()},045,016,,,,.T.,,"",,,,.F. )
oBtnPesq:SetCss(SetCssImg("","Danger"))
ACTIVATE MSDIALOG oDlg CENTER

FT_FUSE()

Return

/*/{Protheus.doc} Marca(lMarca)
(long_description) Marca e Desmarca.
@type  Static Function
@author user
@since 26/10/2020
@version version 12.1.27
@param param_name, param_type, param_descr
@return return_var, return_type, return_description
@example
(examples)
@see (links_or_references)
/*/

Static Function Marca(lMarca)

Local i := 0

For i := 1 To Len(aVetor)
   aVetor[i][1] := lMarca
Next i

oLbx:Refresh()

Return

/*/{Protheus.doc} SetCssImg
(long_description) Funcao para setar CSS e Imagem nos Botoes
@type  Static Function
@author user Eduardo Silva
@since date 27.10.2020
@version version 12.1.27
@param param, param_type, param_descr
@return return, return_type, return_description
@example
(examples)
@see (links_or_references)
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

/*/{Protheus.doc} GeraLib
(long_description) Faz a liberacao dos Pedido de Vendas selecionados na tela
@type  Static Function
@author user Eduardo Silva
@since 03/11/2020
@version version 12.1.27
@param param_name, param_type, param_descr
@return return_var, return_type, return_description
@example
(examples)
@see (links_or_references)
/*/

Static Function GeraLib(aVetor)

Local aArea     := GetArea()
Local aAreaC5   := SC5->( GetArea() )
Local aAreaC6   := SC6->( GetArea() )
Local aAreaC9   := SC9->( GetArea() )
Local i         := 0
Local lLiber    := .F.

SC6->( dbSetOrder(1) )  // C6_FILIAL + C6_NUM + C6_ITEM + C6_PRODUTO
SC9->( dbSetOrder(1) )  // C9_FILIAL + C9_PEDIDO + C9_ITEM + C9_SEQUEN + C9_PRODUTO + C9_BLEST + C9_BLCRED

Begin Transaction
	ProcRegua(Len(aVetor))
	For i := 1 to Len(aVetor)
      If aVetor[i][1] == .T.
         IncProc("Liberação do Pedido..." + aVetor[i,3])         
         If SC6->( dbSeek(xFilial("SC6") + aVetor[i,3]) )
            While SC6->( !Eof() ) .And. SC6->C6_FILIAL + SC6->C6_NUM == FWxFilial("SC6") + aVetor[i,3]
               nRecSC6 := SC6->( Recno() )
               If	SC9->( dbSeek(xFilial("SC9") + SC6->C6_NUM + SC6->C6_ITEM) )
                  While SC9->( !Eof() ) .And. SC9->C9_PEDIDO == SC6->C6_NUM .And. SC9->C9_ITEM == SC6->C6_ITEM .And. SC9->C9_FILIAL == SC6->C6_FILIAL
                     If	Empty(SC9->C9_ORDSEP) .And. Empty(SC9->C9_NFISCAL) .And. !(SC9->C9_BLCRED $ "  /10")
                        a460estorna()
                        SC9->( dbSkip() )
                     Else
                        lLiber := .T.
                        SC9->( dbSkip() )
                        Loop
                     EndIf
                  End
               EndIf
               If !lLiber
                  MaLibDoFat(SC6->(RecNo()),SC6->C6_QTDVEN-SC6->C6_QTDENT,.T.,.F.,.F.,.F.,.T.,.T.,NIL,NIL,NIL,NIL,NIL,NIL,0)
                  MaLiberOk({SC6->C6_NUM},.F.)
               EndIf
               lLiber := .F.
               SC6->( dbGoto(nRecSC6) )
               SC6->( dbSkip() )
            End
         EndIf
         SC5->( dbSetOrder(1) )  // C5_FILIAL + C5_NUM
         If SC5->( dbSeek(xFilial("SC5") + aVetor[i,3]) )
            U_MT450FIM()
            Reclock("SC5",.F.)
            SC5->C5_ZMOTREJ   := ''
            SC5->C5_ZDTREJE   := CtoD('  /  /    ')
            SC5->C5_XHRLIB	   := DtoC(Date()) + " " + Time()
            SC5->C5_XUSRFIN	:= Alltrim(UsrRetName(__CUSERID))
            SC5->( MsUnLock() )
         EndIf
      EndIf
	Next i
End Transaction

RestArea(aAreaC9)
RestArea(aAreaC6)
RestArea(aAreaC5)
RestArea(aArea)

ApMsgInfo("Liberação do(s) Pedido(s) concluída com sucesso!","[STTELPVL] - SUCESSO")
 
Return
