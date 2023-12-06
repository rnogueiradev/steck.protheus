#include "protheus.ch"
#include "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ IMPINVENT º Autor ³Everaldo Gallo      º Data ³  22/12/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Importacao de lancamentos de inventarios                    º±±
±±º          ³                                                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGAEST - ADIS                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ImpInvt()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declara variaveis.														 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aTxt    := {}						//Array com os campos enviados no TXT.
Local nHandle := 0						//Handle do arquivo texto.
Local cArqImp := ""						//Arquivo Txt a ser lido.
Private _cErro  := ""
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posiciona areas.														 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SB2->(DbSetOrder(1))
SB1->(dbSetOrder(1))
SBE->(dbSetOrder(1))
SB7->(dbSetOrder(1))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Busca o arquivo para leitura.											 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cArqImp := cGetFile("Arquivo .CSV |*.CSV","Selecione o Arquivo CSV",0,"",.T.,GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE)
If (nHandle := FT_FUse(cArqImp))== -1
	MsgInfo("Erro ao tentar abrir arquivo.","Atenção")
	Return
EndIf

Processa({|lEnd| LeTXT(aTxt)},"Aguarde, lendo arquivo de Inventário...")

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ IMPINVENT º Autor ³Everaldo Gallo      º Data ³  22/12/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Importacao de lancamentos de inventarios                    º±±
±±º          ³                                                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGAEST - ADIS                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
Static Function LeTXT(aTxt)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declara variaveis.														 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cLinha  := ""						//Linha do arquivo texto a ser tratada.
Local nReg    := 0

FT_FGOTOP()
While !FT_FEOF()
	aTxt := {}
	nReg++
	IncProc("Registro:" + Str(nReg))
	cLinha := FT_FREADLN()
	cLinha := Upper(NoAcento(AnsiToOem(cLinha)))
	AADD(aTxt,{})
	While At(";",cLinha) > 0
		aAdd(aTxt[Len(aTxt)],AllTrim(Substr(cLinha,1,At(";",cLinha)-1)))
		cLinha := StrTran(Substr(cLinha,At(";",cLinha)+1,Len(cLinha)-At(";",cLinha)),',','.')
	EndDo
	aAdd(aTxt[Len(aTxt)],AllTrim(StrTran(Substr(cLinha,1,Len(cLinha)),'"','')))
	GravaDados(aTxt)
	FT_FSKIP()
EndDo
FT_FUSE()
    
if !empty(_cErro)                     

	@ 000, 000 TO 230, 350 DIALOG oDlg TITLE 'Relatorio de Inconsistencias '
	@ 005,005 Get _cErro Size 167,080 MEMO Object oMemo
	@ 92,135 BMPBUTTON TYPE 1 ACTION Close(oDlg)
	ACTIVATE DIALOG oDlg CENTERED

Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ IMPINVENT º Autor ³Everaldo Gallo      º Data ³  22/12/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Importacao de lancamentos de inventarios                    º±±
±±º          ³                                                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGAEST - ADIS                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
Static Function GravaDados(aTxt)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declara variaveis.														 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//Local nX    	  := 0
//Local nOpc		  := 3
//Local aInvent 	  := {}
Local lGrava 	  := .t.

Local cFilial 	  := substr(aTxt[1,1]+SPACE(TamSX3("B1_FILIAL")[1]),1,TamSX3("B1_FILIAL")[1])
Local cCodigo 	  := substr(aTxt[1,2]+SPACE(TamSX3("B1_COD")[1]),1,TamSX3("B1_COD")[1])
Local cEndereco	  := substr(aTxt[1,4]+SPACE(TamSX3("BE_LOCALIZ")[1]),1,TamSX3("BE_LOCALIZ")[1])
Local nQtdCont	  := val(aTxt[1,3])
Local cLocal 	  := substr(aTxt[1,5]+SPACE(TamSX3("BE_LOCAL")[1]),1,TamSX3("BE_LOCAL")[1])

DBSelectArea("SB1")

 
If !DBSeek(xFilial('SB1')+cCodigo)
	lGrava 	  := .f.
	_cErro 	  += Alltrim(cCodigo)+ " - Prod nao cadastrado"+ Chr(13)+ Chr(10)
	_LPRODUTO :=.F.                                                          
ELSE	
	_LPRODUTO :=.T.
	
Endif

DBSelectArea("SBE")
If !DBSeek(xFilial('SBE')+cLocal+cEndereco)
	lGrava 	  := .f.
	_cErro 	  += Alltrim(cLocal + " "+ cEndereco)+ " - Endereco nao cadastrado"+ Chr(13)+ Chr(10)
Endif

DBSelectArea("SB2")
If !DBSeek(xFilial('SB2')+cCodigo+cLocal)
	IF _LPRODUTO
		dbSelectArea("SB9")
		Dbsetorder(1)
		DbSeek(XFILIAL("SB9") + cCodigo + cLocal + "        " )
        if eof()
			RecLock("SB9",.t.)
			SB9->B9_FILIAL 	:= cFilial
			SB9->B9_COD		:= cCodigo
			SB9->B9_LOCAL	:= cLocal
			SB9->B9_DATA	:= stod("        ")
			SB9->B9_QINI 	:= 0
			SB9->B9_VINI1	:= 0
			MsUnlock()
	    endif
	 	RecLock("SB2",.t.)
		SB2->B2_FILIAL 	:= cFilial
		SB2->B2_COD		:= cCodigo
		SB2->B2_LOCAL	:= clocal
		SB2->B2_QATU 	:= 0
		SB2->B2_VATU1	:= 0
		MsUnlock()
	Endif

Endif 

if lGrava
	SB7->(dbSetOrder(1))
	If !SB7->(dbSeek(cFilial+DTOS(DDATABASE)+cCodigo+cLocal+cEndereco))
		DBSELECTAREA("SB7")
		RECLOCK("SB7",.T.)
		REPLACE B7_FILIAL     WITH cFilial
		REPLACE B7_COD        WITH cCodigo
		REPLACE B7_LOCAL      WITH cLocal
		REPLACE B7_LOCALIZ    WITH cEndereco
		//REPLACE B7_LOTECTL    WITH cLote
		REPLACE B7_QUANT      WITH nQtdCont
		REPLACE B7_DATA       WITH DDATABASE
		REPLACE B7_DOC        WITH "F"+SUBSTR(DTOS(DDATABASE),1,6)
		//REPLACE B7_TIPO    	  WITH SB1->B1_TIPO
	
	Else 
		RECLOCK("SB7",.F.)
	
		REPLACE B7_QUANT      WITH B7_QUANT+nQtdCont
	
	//	_cErro 	  += Alltrim(cCodigo + " "+ clocal+ " "+ cEndereco)+ " - Digitacao Duplicada"+ Chr(13)+ Chr(10)
	ENDIF
	MSUNLOCK()
	
Endif
                
Return