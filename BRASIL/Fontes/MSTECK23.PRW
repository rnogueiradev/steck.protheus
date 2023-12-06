/**************************************** 
Fonte........: MSTECK23
Ação.........: Importar da planilha CSV as novas datas de entregas dos POs
Desenvolvedor: Marcelo Klopfer Leme
Data.........: 21/10/2022
Chamado......: 20220928018282 - Oferta Logística
ESTRUTURA DA PLANILHA
1 - ZA6_PO
2 - ZA6_PROD
3 - ZA6_SEQPO
4 - ZA6_QUANT
5 - ZA6_DATA
****************************************/
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE 'RWMAKE.CH'

USER FUNCTION MSTECK23()
	PRIVATE oArqImp
	PRIVATE cArqImp := SPACE(100)
	PRIVATE oBtArq
	PRIVATE oBtOk
	PRIVATE oBtSair
	PRIVATE oGroup1
	PRIVATE clExtensao := "CSV"
	PRIVATE clNomeArq  := "*"
	PRIVATE aVetor := {}
	PRIVATE aVetAux := {}
	PRIVATE aCampos := {}
	PRIVATE cSeqAtu := SuperGetMV("ST_SEQZA6",.F.,1)
	PRIVATE lprocessa:=.T.
	
	STATIC oDlg

	DEFINE MSDIALOG oDlg TITLE "Importação de Arquivos" FROM 000, 000  TO 210, 370 PIXEL
  @ 020, 015 SAY "Informe o arquivo a importar:" SIZE 083, 007 OF oDlg PIXEL
 	@ 040, 005 MSGET oArqImp VAR cArqImp SIZE 173, 010 OF oDlg PIXEL WHEN .F.
	@ 060, 005 BUTTON oBtArq  PROMPT "Arquivo"   SIZE 040, 015 OF oDlg ACTION(FARQEX()) PIXEL
	@ 060, 073 BUTTON oBtOk   PROMPT "Confirmar" SIZE 040, 015 OF oDlg ACTION(IIF(EMPTY(cArqImp),MsgAlert("Selecione um arquivo!","Atenção"),(MSTECK23A(),oDlg:End()))) PIXEL
	@ 060, 137 BUTTON oBtSair PROMPT "Sair"      SIZE 040, 015 OF oDlg ACTION(oDlg:End()) PIXEL

	ACTIVATE MSDIALOG oDlg CENTERED

RETURN()

STATIC FUNCTION MSTECK23A()

	PROCESSA({|| MSTECK23B()}, "Validando Dados ...","Aguarde!",.F.)
    
	IF lProcessa 
	   IF MsgYesno('Validação finalizada !!! Confirma importação ? ')
	      IF LEN(aVetor) > 0
		     PROCESSA({|| MSTECK23C()}, "Gravando dados...","Aguarde!",.F.)
	      ENDIF
	   ENDIF 	  
	ENDIF   

RETURN()

STATIC FUNCTION MSTECK23B()
	LOCAL clLinha		:= ""
	LOCAL nlCont		:= 0
	LOCAL nlTotLin	:= 0
	LOCAL nLast     := 0

	FT_FUSE(cArqImp)
	FT_FGOTOP()

	nlTotLin := FT_FLASTREC()
	PROCREGUA( nlTotLin+1 )
	FT_FGOTOP()

	aVetor := {}
	WHILE !FT_FEOF()
		clLinha := FT_FREADLN()
		aVetAux := {}
		aVetAux := Separa(clLinha,";",.T.)
		IF !aVetAux[1] $ "PO#"
			cPed1:=STRZERO(VAL(aVetAux[1]),6)
			SC7->(DBSETORDER(1))
			IF ! SC7->(DBSEEK(XFILIAL('SC7')+cPed1))
			   IF ! MsgYesno('Pedido : '+aVetAux[1]+' Não encontrado ref. linha: '+alltrim(str(nlCont+1,9))+CHR(13)+CHR(10)+CHR(13)+CHR(10)+' Continua o Processamento ? ') 
			      lProcessa:=.F.
				  MsgAlert('Processamento abortado')
				  Return()
			   ENDIF 	  
			ELSE
               cCod1:=ALLTRIM(aVetAux[2])+SPACE(15-LEN(ALLTRIM(aVetAux[2])))
			   SB1->(DBSETORDER(1))
			   IF ! SB1->(DBSEEK(XFILIAL('SB1')+cCod1))
			      IF ! MsgYesNo('Codigo do Produto: '+aVetAux[2]+' não encontrado ref linha: '+alltrim(str(nlCont+1,9))+CHR(13)+CHR(10)+CHR(13)+CHR(10)+' Continua o Processamento ? ') 
				     lProcessa:=.F.
					 MsgAlert('Processamento abortado')
					 Return()
				  ENDIF	 
               ENDIF 
			ENDIF
			AADD(aVetor,aVetAux)
		ENDIF
		nlCont++
		IncProc("Carregando Informações..."+Alltrim(Str(nlTotLin))+"/"+Alltrim(Str(nlCont))+" - "+ Alltrim(Str((nlCont/nlTotLin)*100,3))+"%")
		FT_FSKIP()
	ENDDO

	FT_FUSE()
RETURN()
/*******************************
Cenários a serem tratados na importação da planilha
cenário 1 ---> Não existe o registro na ZA6, inclui somente na ZA6 e o job itá processar
cenário 2 ---> Nada é alterado no registro, PO / sequencia / quantidade / data não foram alterados (nesse caso é só colocar um loop e ir para o próximo)
cenário 3 ---> Somente a data foi alterada, neste caso deve alterar a ZA6, Z96 e SC6 correspondente sem alterar a PA1.
cenário 4 ---> Quantidade foi alterada para MAIOR, neste caso deve alterar somente a ZA6 e deixar o job fazer o trabalho.
cenário 5 ---> Quantidade foi alterada para MENOR, neste caso deve alterar a ZA6, remover a Z96, voltar saldo para PA1 e deixar o job refazer.
cenário 6 ---> Registro foi deletado, neste caso deve deletar a ZA6, remover Z96, voltar o saldo para PA1 e SC6 LIMPAR DATA C6_ZENTRE2 
*******************************/
STATIC FUNCTION MSTECK23C()
LOCAL i := 0
LOCAL nlTotLin := LEN(aVetor)
LOCAL lContinua := .T.
LOCAL cCodPro := ""
LOCAL cNumPO  := ""
LOCAL cNumIte := ""
LOCAL aVetor1 := {}
LOCAL cPed1   :=""
LOCAL cCod1   :=""

	DbSelectArea("SC7")
	SC7->(DbSetOrder(1)) //C7_FILIAL+C7_NUM+C7_ITEM+C7_SEQUEN

	DbSelectArea("Z96")
	Z96->(DbSetOrder(4))  //Z96_FILIAL+Z96_TIPREG+Z96_PROD+Z96_PEDCOM+Z96_ITECOM+Z96_SEQUEN

	PROCREGUA( nlTotLin+1 )
    cSeqAtu:=Strzero(cSeqAtu+1,5)
	
	Begin Transaction 

	FOR i := 1 TO LEN(aVetor)

		INCPROC("Atualizando registros..."+Alltrim(Str(nlTotLin))+"/"+Alltrim(Str(i))+" - "+ Alltrim(Str((i/nlTotLin)*100,3))+"%")

		/***************************
		Posição no Vetor
		1 - ZA6_PO
		2 - ZA6_PROD
		3 - ZA6_SEQPO
		4 - ZA6_QUANT
		5 - ZA6_DATA
		6 - ZA6_SEQPO
		***************************/
		//// Preenche com zeros a equerda o número do PO
		aVetor[i,1] := STRZERO(VAL(aVetor[i,1]),6)

		//// Preenche com zeros a equerda o item do PO
		aVetor[i,3] := STRZERO(VAL(aVetor[i,3]),4)

		//// Transforma de Caracter para numérico
		aVetor[i,4] := VAL(aVetor[i,4])

		//// Transforma de Caracter para Data
		aVetor[i,5] := CTOD(aVetor[i,5])

		//// Tratamento para o tamnho do campo do produto
		aVetor[i,2] := ALLTRIM(aVetor[i,2])+SPACE(15-LEN(ALLTRIM(aVetor[i,2])))

		//Validar pedido de compra e saldo
		SC7->(DbGoTop())
		If !SC7->(DbSeek(xFilial("SC7")+aVetor[i,1]+aVetor[i,3]))
			lContinua := .F.
		Else
			If !AllTrim(SC7->C7_PRODUTO)==AllTrim(aVetor[i,2])
				lContinua := .F.
			ElseIf SC7->(C7_QUANT-C7_QUJE)<=0
				lContinua := .F.
			EndIf
		EndIf

		/*******************************
		Cenário 1
		Não existe o registro na ZA6, inclui somente na ZA6 e o job itá processar
		**********************************/
		lContinua := .T.
		ZA6->(DBSETORDER(2)) 
		IF !ZA6->(DBSEEK(XFILIAL("ZA6")+aVetor[i,1]+aVetor[i,3]+aVetor[i,2]+aVetor[i,6]))
			IF aVetor[i,6] <> "S"
				RECLOCK("ZA6",.T.)
				ZA6->ZA6_FILIAL  := XFILIAL("ZA6")
				ZA6->ZA6_PO      := aVetor[i,1]
				ZA6->ZA6_PROD    := aVetor[i,2]
				ZA6->ZA6_ITEM    := aVetor[i,3]
				ZA6->ZA6_QUANT   := aVetor[i,4]
				ZA6->ZA6_DATA    := aVetor[i,5]
				ZA6->ZA6_SEQPO   := aVetor[i,6]
				ZA6->ZA6_CONSUM  := 0
				ZA6->(MSUNLOCK())
				lContinua := .F.
			ENDIF
		ENDIF


		/**********************************
		Validação do cenário 2
		Nada é alterado no registro, PO / sequencia / quantidade / data não foram alterados (nesse caso é só colocar um loop e ir para o próximo)
		**********************************/
		IF lContinua = .T.
			ZA6->(DBSETORDER(2)) 
			IF ZA6->(DBSEEK(XFILIAL("ZA6")+aVetor[i,1]+aVetor[i,3]+aVetor[i,2]+aVetor[i,6]))
				IF ZA6->ZA6_QUANT = aVetor[i,4] .AND. ZA6->ZA6_DATA = aVetor[i,5] .AND. aVetor[i,6] <> "S"
					//// A data e a Quantidade não foram alteradas então pula para o próximo registro
					lContinua := .F.
				ENDIF
			ELSE
				lContinua := .F.
			ENDIF
		ENDIF

		/**********************************
		Validação do cenário 3
		Já está posicionado no registro na validação do cenário 2
		Somente a data foi alterada, neste caso deve alterar a ZA6, Z96 e SC6 correspondente sem alterar a PA1.
		**********************************/
		IF lContinua = .T.
			IF ZA6->ZA6_DATA <> aVetor[i,5] .AND. ZA6->ZA6_QUANT = aVetor[i,4] .AND. aVetor[i,6] <> "S"
				RECLOCK("ZA6",.F.)
				ZA6->ZA6_DATA    := aVetor[i,5]
				ZA6->(MSUNLOCK())

				/**************************************
				Varre a tabela Z96  procurando todos os registros que pertencem número do PO / ITEM / SEQUEN.
				**************************************/
				Z96->(DbGoTop())
				IF Z96->(MsSeek(XFILIAL("Z96")+"PO"+ZA6->ZA6_PROD+ALLTRIM(ZA6->ZA6_PO)+ALLTRIM(ZA6->ZA6_ITEM)+PADR(ALLTRIM(ZA6->ZA6_SEQPO),4)))
					While Z96->(!Eof()) .And.;
					XFILIAL("Z96")+"PO"+ZA6->ZA6_PROD+ALLTRIM(ZA6->ZA6_PO)+ALLTRIM(ZA6->ZA6_ITEM)+PADR(ALLTRIM(ZA6->ZA6_SEQPO),4)==;
					Z96->(Z96_FILIAL+Z96_TIPREG+Z96_PROD+Z96_PEDCOM+Z96_ITECOM+Z96_SEQUEN)

						RECLOCK("Z96",.F.)
						Z96->Z96_DTPVIN := aVetor[i,5]
						Z96->(MSUNLOCK())
						
						SC6->(DBSETORDER(1))
						IF SC6->(MsSeek(xFilial("SC6")+SubStr(Z96->Z96_PA1DOC,1,8)))
							SC6->(RecLock("SC6",.F.))
							SC6->C6_ZENTRE2 := Z96->Z96_DTPVIN
							SC6->(MsUnLock())
						ENDIF

						Z96->(DbSkip())
					EndDo

				ENDIF
			
				lContinua := .F.
			ENDIF
		ENDIF

		/**********************************
		Validação do cenário 4
		Quantidade foi alterada para MAIOR sem alterar a Data, neste caso deve alterar somente a ZA6 e deixar o job fazer o trabalho.
		**********************************/
		IF lContinua = .T.
			IF aVetor[i,4] >= ZA6->ZA6_QUANT .AND. aVetor[i,5] = ZA6->ZA6_DATA .AND. aVetor[i,6] <> "S"

				RECLOCK("ZA6",.F.)
				ZA6->ZA6_QUANT := aVetor[i,4]
				ZA6->(MSUNLOCK())
				lContinua := .F.
			ENDIF
		ENDIF

		/**********************************
		Validação do cenário 5
		Quantidade foi alterada para MENOR, neste caso deve alterar a ZA6, remover a Z96, voltar saldo para PA1 e deixar o job refazer.
		**********************************/
		IF lContinua = .T.
			IF aVetor[i,4] < ZA6->ZA6_QUANT .AND. aVetor[i,6] <> "S"

				/*************************************
				Quando encontrar um registro na ZA6 altera as informações
				*************************************/
				RECLOCK("ZA6",.F.)
				ZA6->ZA6_FILIAL  := XFILIAL("ZA6")
				ZA6->ZA6_PO      := aVetor[i,1]
				ZA6->ZA6_PROD    := aVetor[i,2]
				ZA6->ZA6_ITEM    := aVetor[i,3]
				ZA6->ZA6_QUANT   := aVetor[i,4]
				ZA6->ZA6_DATA    := aVetor[i,5]
				ZA6->ZA6_SEQPO   := aVetor[i,6]
				ZA6->ZA6_CONSUM  := 0
				ZA6->(MSUNLOCK())

				/**************************************
				Varre a tabela Z96  procurando todos os registros que pertencem número do PO / ITEM / SEQUEN.
				**************************************/
				Z96->(DBSETORDER(4))
				IF Z96->(DBSEEK(XFILIAL("Z96")+"PO"+ZA6->ZA6_PROD+ALLTRIM(ZA6->ZA6_PO)+ALLTRIM(ZA6->ZA6_ITEM)+ALLTRIM(ZA6->ZA6_SEQPO)))
					WHILE Z96->(!EOF());
						.AND. ALLTRIM(Z96->Z96_PEDCOM) = ALLTRIM(ZA6->ZA6_PO   );
						.AND. ALLTRIM(Z96->Z96_ITECOM) = ALLTRIM(ZA6->ZA6_ITEM );
						.AND. ALLTRIM(Z96->Z96_SEQUEN) = ALLTRIM(ZA6->ZA6_SEQPO);
						.AND. ALLTRIM(Z96->Z96_PROD  ) = ALLTRIM(ZA6->ZA6_PROD );
						

						/**************************************
						Procura o registro correspondente na tabela PA1.
						Retorna o saldo da tabela PA1 com o mesmo valor da tabela Z96
						**************************************/
						PA1->(DBSETORDER(3))
						IF PA1->(DBSEEK(XFILIAL("PA1")+Z96->Z96_PA1DOC+Z96->Z96_PROD))
							RECLOCK("PA1",.F.)
							PA1->PA1_SALDO +=  Z96->Z96_QTDATE
							MSUNLOCK("PA1")
						ENDIF

						/**************************************
						Delta o registro da tabela Z96 pois será criado novamente na rotina MSTECK18
						**************************************/
						RECLOCK("Z96",.F.)
						Z96->(DBDELETE())
						Z96->(MSUNLOCK())

						Z96->(DBSKIP())
					ENDDO
				ENDIF
 				lContinua := .F.
			ENDIF
        ENDIF

		/**********************************
		Validação do cenário 6
		Registro foi deletado, neste caso deve voltar o saldo para PA1, SC6 equalizar a data C6_ZENTRE2 com a data C6_ENTRE1, deletar Z96 e deletar a ZA6
		**********************************/
		IF lContinua = .T.
			
		ENDIF
	   
	    // Atualiza o registo da ZA6 como processado para controlar o que vai excluir. 
        ZA6->(DBSETORDER(2)) 
        IF ZA6->(DBSEEK(XFILIAL("ZA6")+aVetor[i,1]+aVetor[i,3]+aVetor[i,2]+aVetor[i,6]))
		   ZA6->(RECLOCK('ZA6',.F.))
		   ZA6->ZA6_DTATU:=DDATABASE
		   ZA6->ZA6_HORA  :=TIME()
		   ZA6->ZA6_SEQATU:=cSeqAtu
		   ZA6->(MSUNLOCK('ZA6'))
		ENDIF   
	NEXT
    
	DBSELECTAREA('ZA6')
	DBGOTOP()
	While ! ZA6->(EOF())
		IF ZA6->ZA6_SEQATU<>cSeqAtu 
				Z96->(DBSETORDER(4))
				IF Z96->(DBSEEK(XFILIAL("Z96")+"PO"+ZA6->ZA6_PROD+ALLTRIM(ZA6->ZA6_PO)+ALLTRIM(ZA6->ZA6_ITEM)+ALLTRIM(ZA6->ZA6_SEQPO)))
					WHILE Z96->(!EOF());
						.AND. ALLTRIM(Z96->Z96_PEDCOM) = ALLTRIM(ZA6->ZA6_PO   );
						.AND. ALLTRIM(Z96->Z96_ITECOM) = ALLTRIM(ZA6->ZA6_ITEM );
						.AND. ALLTRIM(Z96->Z96_SEQUEN) = ALLTRIM(ZA6->ZA6_SEQPO);
						.AND. ALLTRIM(Z96->Z96_PROD  ) = ALLTRIM(ZA6->ZA6_PROD )
						

						/**************************************
						Procura o registro correspondente na tabela PA1.
						Retorna o saldo da tabela PA1 com o mesmo valor da tabela Z96
						**************************************/
						PA1->(DBSETORDER(3))
						IF PA1->(DBSEEK(XFILIAL("PA1")+Z96->Z96_PA1DOC+Z96->Z96_PROD))
							RECLOCK("PA1",.F.)
							PA1->PA1_SALDO +=  Z96->Z96_QTDATE
							MSUNLOCK("PA1")
						ENDIF

						/**************************************
						Deleta o registro da tabela Z96 pois será criado novamente na rotina MSTECK18
						**************************************/
						RECLOCK("Z96",.F.)
						Z96->(DBDELETE())
						Z96->(MSUNLOCK())

						Z96->(DBSKIP())
					ENDDO

					cCodPro := ZA6->ZA6_PROD
					cNumPO  := ALLTRIM(ZA6->ZA6_PO)
					cNumIte := ALLTRIM(ZA6->ZA6_ITEM)

					/**************************************
					Varre a tabela Z96  procurando o último registro da Z96 para este PO e grava a última data no 
					**************************************/
					Z96->(DBSETORDER(4))
					IF Z96->(DBSEEK(XFILIAL("Z96")+"PO"+cCodPro+cNumPO+cNumIte))
						WHILE Z96->(!EOF());
							.AND. ALLTRIM(Z96->Z96_PEDCOM) = ALLTRIM(ZA6->ZA6_PO   );
							.AND. ALLTRIM(Z96->Z96_ITECOM) = ALLTRIM(ZA6->ZA6_ITEM );
							.AND. ALLTRIM(Z96->Z96_PROD  ) = ALLTRIM(ZA6->ZA6_PROD )

							/**************************************
							Procura o registro correspondente na tabela PA1.
							Retorna o saldo da tabela PA1 com o mesmo valor da tabela Z96
							**************************************/
							PA1->(DBSETORDER(3))
							IF PA1->(DBSEEK(XFILIAL("PA1")+Z96->Z96_PA1DOC+Z96->Z96_PROD))

								SC6->(DBSETORDER(1))
								If SC6->(DbSeek(xFilial("SC6")+SubStr(PA1->PA1_DOC,1,8)))
									SC6->(RecLock("SC6",.F.))
									SC6->C6_ZENTRE2 := Z96->Z96_DTPVIN
									SC6->(MsUnLock())
								EndIf
							ENDIF
							Z96->(DBSKIP())
						ENDDO
					ENDIF
				ENDIF
				RECLOCK("ZA6",.F.)
				ZA6->(DBDELETE())
				ZA6->(MSUNLOCK())
        ENDIF
		ZA6->(DBSKIP())
	ENDDO 
    //ST_SEQZA6
	SX6->(DbSetOrder(1))
	IF SX6->(DbSeek("  " + "ST_SEQZA6"))
	   SX6->(RecLock("SX6",.F.))
	   SX6->X6_CONTEUD := ALLTRIM(STR(VAL(cSeqAtu)))
	   SX6->(MsUnLock())
	ENDIF   
	End Transaction 

RETURN


STATIC FUNCTION FARQEX()
	LOCAL clFile	:= ""

	clFile := TRIM(	cGetFile(	PADR("Arquivos " + clExtensao + "(" + clNomeArq + "." + Lower(clExtensao) + ")" , 27) +;
	"|" + clNomeArq + "." + clExtensao + "|","Selecione Diretorio e Arquivo", 0, "C:\" , .T., 49))

	cArqImp := clFile
	oArqImp:Refresh()
RETURN
