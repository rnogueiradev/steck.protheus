#Include "Protheus.ch"
#Include "Totvs.ch"
#Include "TopConn.ch"
#Include "TBIConn.ch"

/*/Protheus.doc STBRTRCK
@(long_description) Tela de Tracking com todas as informações do Contrato de Parceria
@type Function STBRTRCK
@author Eduardo Pereira - Sigamat
@since 05/01/2021
@version 12.1.25
/*/

User Function STBRTRCK()

Local aVetor   := {}
Local oDlg
Local oLbx
Local cTitulo  := "Tracking do Contrato de Parceria"
Local cQrySC7  := ""
Local oNroCP
Local oNumCP
Local cNumCP   := SC3->C3_NUM
Local oDatCP
Local oDataCP
Local cDataCP  := SC3->C3_EMISSAO
Local oQtdeC3
Local oQtdSC3
Local cQtdSC3  := SC3->C3_QUANT

If Select("TMPCPTCK") > 0
   TMPCPTCK->( dbCloseArea() )
EndIf
cQrySC7 := " SELECT C7_NUMSC, C7_DATPRF, C7_PRODUTO, C7_QUANT, C7_PRECO, C7_NUM, D1_DOC, D1_SERIE, D1_EMISSAO FROM " + RetSQLName("SC7") + " SC7 "
cQrySC7 += " LEFT JOIN " + RetSQLName("SD1") + " SD1 "
cQrySC7 += " ON SD1.D1_FILIAL = SC7.C7_FILIAL AND SD1.D1_PEDIDO = SC7.C7_NUM AND SD1.D_E_L_E_T_ = ' ' "
cQrySC7 += " WHERE SC7.D_E_L_E_T_ = ' ' "
cQrySC7 += "    AND SC7.C7_TIPO = '2' "
cQrySC7 += "    AND SC7.C7_NUMSC = '" + SC3->C3_NUM + "' "
dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQrySC7),"TMPCPTCK")

While TMPCPTCK->( !Eof() )
   aAdd( aVetor, {  TMPCPTCK->C7_NUMSC          ,; // 1. Nro Autorização de Entrega
                    StoD(TMPCPTCK->C7_DATPRF)   ,; // 2. Data de Entrega
                    TMPCPTCK->C7_PRODUTO        ,; // 3. Produto
                    Alltrim(Posicione("SB1", 1, xFilial("SB1") + TMPCPTCK->C7_PRODUTO, "B1_DESC"))   ,; // 4. Desc. Produto
                    Alltrim(Transform(TMPCPTCK->C7_QUANT,"@E 999,999,999.99"))         ,; // 5. Quantidade
                    Alltrim(Transform(TMPCPTCK->C7_PRECO,"@E 99,999,999.99999999"))    ,; // 6. Preco
                    TMPCPTCK->C7_NUM            ,; // 7. Nro do Pedido
                    TMPCPTCK->D1_DOC            ,; // 8. Documento
                    TMPCPTCK->D1_SERIE          ,; // 9. Serie
                    StoD(TMPCPTCK->D1_EMISSAO)  }) // 10. Data de Emissao da NF
	TMPCPTCK->( dbSkip() )
End

If Len(aVetor) == 0
	MsgAlert("Não existe Autorização de Entrega para esse Contrato!!!","T R A C K I N G")
	Return
EndIf

// Monta a tela para usuário visualizar consulta.
DEFINE MSDIALOG oDlg TITLE cTitulo FROM 0,0 TO 400,993 PIXEL
   oFWLMain := FWLayer():New()
   oFWLMain:Init( oDlg, .T. )
   oFWLMain:AddCollumn( "Col01", 100, .T.,"LineSup" )
   oFWLMain:AddWindow( "Col01", "Win01", cTitulo, 100, .F., .F.,/*bAction*/,"LineSup",/*bGotFocus*/)
   oWin1 := oFWLMain:GetWinPanel('Col01','Win01',"LineSup" )
   // Nro do Contrato
   @ 036, 012 SAY oNroCP PROMPT "Nro do Contrato" SIZE 040, 007 OF oDlg COLORS 0, 16777215 PIXEL
   @ 035, 057 MSGET oNumCP VAR cNumCP When .F. SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL
   // Data de Emissão
   @ 036, 190 SAY oDatCP PROMPT "Data de Emissão" SIZE 040, 007 OF oDlg COLORS 0, 16777215 PIXEL
   @ 035, 240 MSGET oDataCP VAR cDataCP When .F. SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL
   // Quantidade Total do Contrato de Parceria
   @ 036, 360 SAY oQtdeC3 PROMPT "Qtde Orig. Contrato" SIZE 050, 007 OF oDlg COLORS 0, 16777215 PIXEL
   @ 035, 420 MSGET oQtdSC3 VAR cQtdSC3 When .F. SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL
   // Primeira opção para montar o listbox.
   @ 025,005 LISTBOX oLbx FIELDS HEADER "Nro Aut. Entrega", "Data Entrega", "Produto", "Desc. Produto", "Qtde", "Preço", "AE / N.Pedido", "Nota Fiscal", "Série", "Data NF" SIZE 480,118 OF oWin1 PIXEL
   oLbx:SetArray( aVetor )
   oLbx:bLine := {||{aVetor[oLbx:nAt,1],;
                     aVetor[oLbx:nAt,2],;
                     aVetor[oLbx:nAt,3],;
                     aVetor[oLbx:nAt,4],;
                     aVetor[oLbx:nAt,5],;
                     aVetor[oLbx:nAt,6],;
                     aVetor[oLbx:nAt,7],;
                     aVetor[oLbx:nAt,8],;
                     aVetor[oLbx:nAt,9],;
                     aVetor[oLbx:nAt,10]}}
oBtnPesq := TButton():New( 148, 435,"Sair",oWin1,{||oDlg:End()},050,016,,,,.T.,,"",,,,.F. )
oBtnPesq:SetCss(SetCssImg("","Danger"))
ACTIVATE MSDIALOG oDlg CENTER

Return

/*/{Protheus.doc} SetCssImg
@(long_description) Funcao para setar CSS e Imagem nos Botoes
@type Function SetCssImg
@author Eduardo Silva
@since 27/10/2020
@version 12.1.25
/*/

Static Function SetCssImg(cImg,cTipo)

Local cCssRet	:= ""
Default cImg	:= "rpo:yoko_sair.png"
Default cTipo	:= "Botao Branco"

If cTipo == "Danger"  
	cCssRet := "QPushButton {"  
	cCssRet += " color:#fff;background-color:#dc3545;border-color:#dc3545 "
	cCssRet += "}"
EndIf

Return cCssRet
