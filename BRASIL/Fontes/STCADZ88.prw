#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"

/*************************************************************
Rotina.........: STALTZ88
Ação...........: Cadastro de e-Mail de WFs de EDis 
...............: Chamado pelo ponto de entrada MA030ROT
Desenvolvedor..: Marcelo Klopfer Leme - SIGAMAT
Data...........: 26/04/2022
Chamado........: 20220328006776
*************************************************************/				
USER FUNCTION  STALTZ88(pTipo)
  Local cChave      := iif(pTipo=="C","A1_COD","A2_COD")
  Local cAlias      := Alias()
	Local cFiltro     := "Z88_TIPO== '"+pTipo+"' .and. Z88_CODIGO=='"+(cAlias)->&(cChave)+"' "
  Local oBtSair
  Local oBtOk
  PRIVATE oCodCli
  PRIVATE cCodCli := IIF(pTipo=="C",SA1->A1_COD,SA2->A2_COD)
  PRIVATE oEmail
  PRIVATE cEmail := ""
  PRIVATE oCopia
  PRIVATE cCopia := ""
  PRIVATE lNovo := .T.
  Static oDlg

  /********************************
  tratamento específico para o cliente MRV
  ********************************/
  IF pTipo = "C" .AND. (Substr(AllTrim(SA1->A1_NOME),1,3) = 'MRV' .Or. Substr(AllTrim(SA1->A1_NREDUZ),1,3) = 'MRV')
  	cFiltro := "Z88_TIPO== 'C' .and. Z88_CODIGO=='MRV'"
		Z88->(DBSETORDER(1))
		IF Z88->(dbSeek(xFilial('Z88')+"C"+"MRV   " ))
			cCodCli := "MRV   "
      cEmail := Z88->Z88_EMAIL
			cCopia := Z88->Z88_COPIAE
      lNovo := .F.
		ENDIF

  ELSE
		Z88->( dbSetFilter( {|| &cFiltro}, cFiltro ) )

		IF Z88->( dbSeek(xFilial('Z88')+pTipo+(cAlias)->&(cChave)) )
			cCodCli := IIF(pTipo=="C",SA1->A1_COD,SA2->A2_COD)
      cEmail := Z88->Z88_EMAIL
			cCopia := Z88->Z88_COPIAE
      lNovo := .F.
		ENDIF 

	ENDIF

  DEFINE MSDIALOG oDlg TITLE "Cadastro de E-mails (WFs)" FROM 000, 000  TO 600, 600  PIXEL

    @ 010, 010 SAY "Cliente:" SIZE 021, 007 OF oDlg  PIXEL
    @ 008, 033 MSGET oCodCli VAR cCodCli SIZE 030, 010 OF oDlg  PIXEL WHEN .F.
    @ 027, 010 SAY "Relação de E-Mail:" SIZE 047, 007 OF oDlg  PIXEL
    @ 037, 010 GET oEmail VAR cEmail SIZE 277, 090 MEMO OF oDlg  PIXEL
		@ 140, 010 SAY "Relação de Cópia de E-Mail :" SIZE 071, 007 OF oDlg  PIXEL
    @ 150, 010 GET oCopia VAR cCopia SIZE 277, 090 MEMO OF oDlg  PIXEL
    @ 255, 065 BUTTON oBtOk   PROMPT "Confirma" SIZE 052, 018 OF oDlg ACTION(CGRAVA(pTipo),oDlg:End()) PIXEL
    @ 255, 157 BUTTON oBtSair PROMPT "Fechar"   SIZE 052, 018 OF oDlg ACTION(oDlg:End())PIXEL

  ACTIVATE MSDIALOG oDlg CENTERED
RETURN

STATIC FUNCTION CGRAVA(pTipo)
IF MSGYESNO("Confirma a gravação dos e-mails?")
  
  RECLOCK("Z88",lNovo)
  Z88->Z88_TIPO := pTipo
  Z88->Z88_CODIGO := cCodCli
  Z88->Z88_EMAIL  := cEmail
  Z88->Z88_COPIAE := cCopia
  Z88->(MSUNLOCK())
ENDIF

RETURN
