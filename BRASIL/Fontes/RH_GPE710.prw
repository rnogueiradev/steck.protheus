#include "protheus.ch"
#include "RH_GPE710.CH"

// data da ultima atualizacao realizada
#define CMP_LAST_UPDATED "00/00/0000"				// Indique aqui a data da ultima alteracao (15/05/2007)


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³UpdGPE710 ³ Autor ³ Adilson Silva         ³Data ³ 11.05.07  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Atualizacao dos dicionarios para rotina de Controle de     ³±±
±±³          ³ Acessos.                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ UpdGPE710 - Para execucao a partir do Remote               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SigaGPE                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function UpdGPE710()

PRIVATE cMessage
PRIVATE aArqUpd  := {}
PRIVATE aREOPEN  := {} 
PRIVATE aFathers := {}
PRIVATE aMenus   := {}

Private cArqEmp     := "SIGAMAT.EMP"
Private nModulo     := 09
Private __cInterNet := Nil

#IFDEF TOP
	TCInternal(5,'*OFF') //-- Desliga Refresh no Lock do Top
#ENDIF

Set Dele On

//--ABERTURA DO SIGAMAT
OpenSm0()
DbGoTop()

lHistorico 	:=   MsgYesNo("Deseja efetuar a atualizacao do Dicionario v." + CMP_LAST_UPDATED + "? Esta rotina deve ser utilizada em modo exclusivo ! Faca um backup dos dicionarios e da Base de Dados antes da atualizacao para eventuais falhas de atualizacao !", "Atenção") 
lEmpenho	:= .F.
lAtuMnu		:= .F.

DEFINE WINDOW oMainWnd FROM 0,0 TO 0,40 TITLE "Atualizacao do dicionario para rotina do Controle de Acessos"
	
ACTIVATE WINDOW oMainWnd ON INIT If(lHistorico,(ProcGpe({|lEnd| Compatibiliza(@lEnd)},"Processando","Aguarde , processando preparacao dos arquivos",.F.) , oMainWnd:End()),oMainWnd:End()) 
																		

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³COMPATIBILIZA³ Autor ³ Mauro	              ³ Data ³16/01/06  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Programa de atualizacao de ambiente Dicionarios de dados      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Compatibilizador de dicionarios                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function COMPATIBILIZA()

Local nOpca      := 0
Local cCodEmp	 := "!!"

PRIVATE cMessage
PRIVATE aArqUpd  := {}
PRIVATE aREOPEN  := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Digite uma mensagem informativa para o usuario a respeito do que sera executado a seguir. Os  ³
//³ STR0002 e STR0003 foram reservados para isso                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cMens := OemToAnsi(STR0011) + Chr(13) + OemToAnsi(STR0001) + Chr(13) + OemToAnsi(STR0002) + Chr(13) + OemToAnsi(STR0003) + Chr(13) + OemToAnsi(STR0004)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ So continua se conseguir abrir o SX2 como exclusivo                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Aviso(OemToAnsi(STR0005) + CMP_LAST_UPDATED, cMens,{OemToAnsi(STR0006),OemToAnsi(STR0007)},3) == 1 //.And. OpenSX2Excl(cArqSx2,cIndSx2)
	ProcGpe({|lEnd| 	CMPProc(@lEnd)},;
						OemToAnsi(STR0008),;
						OemToAnsi(STR0009),;
						.F.)
EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³CMPProc   ³ Autor ³Generico               ³ Data ³   / /    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao de processamento da gravacao dos arquivos           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Processamento do Compatibilizador                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CMPProc(lEnd)

Local cTexto   		:= ""
Local cFile    		:= ""
Local cMask    		:= STR0010
Local nRecno   		:= 0
Local nCont    		:=0
Local nX			:= 0
Local cCOdEmp		:= "!!"

Private aEmpresas	:= {}
PRIVATE aMsgErr	 	:= {}

//--Carrega array com as Empresas do SIGAMAT
dbSelectArea("SM0")
dbGoTop()
While ! Eof()
	If cCodEmp # SM0->M0_CODIGO
		cCodEmp := SM0->M0_CODIGO
		//--Verificacao da existencia dos dicionarios para a Empresa
		If  ! RpcChkSxs( SM0->M0_CODIGO , @aMsgErr , .F. )
			If Aviso(OemToAnsi(STR0011),OemToAnsi(STR0046+cCodEmp+chr(13)+chr(10)+aMsgErr[1][2]),{OemToAnsi(STR0047),OemToAnsi(STR0007)},3) == 2 
				Return
			Else
				cTexto += Replicate("-",128) + CHR(13) + CHR(10)
				cTexto += OemToAnsi(STR0013) + SM0->M0_CODIGO + OemToAnsi(STR0014) + SM0->M0_CODFIL + "-" + SM0->M0_NOME + CHR(13) + CHR(10)
				cTexto += OemToAnsi("Não Atualizado") + CHR(13) + CHR(10)
				SM0->(dbSkip())
				Loop
			Endif	  
			aMsgErr	 := {}
			aAdd(aEmpresas,{SM0->M0_CODIGO,SM0->M0_CODFIL})
			
			RpcSetType(2)
			RpcSetEnv(SM0->M0_CODIGO, SM0->M0_CODFIL)
			RpcClearEnv()
			OpenSm0Excl()
		Endif	
		//--Verifica a Abertura dos dicionarios exclusivo		
		
		aAdd(aEmpresas,{SM0->M0_CODIGO,SM0->M0_CODFIL,SM0->(Recno())})
		
	Endif	
	SM0->(dbSkip())
Enddo	

GPProcRegua(SM0->(RecCount())*8)

FOR nX := 1 TO Len(aEmpresas)
           
	dbSelectArea("SM0")
	dbGoTo(aEmpresas[nx,3])
	
	RpcSetType(2)
	RpcSetEnv(SM0->M0_CODIGO, SM0->M0_CODFIL)
	cTexto += Replicate("-",128) + CHR(13) + CHR(10)
	cTexto += OemToAnsi(STR0013) + SM0->M0_CODIGO + OemToAnsi(STR0014) + SM0->M0_CODFIL + "-" + SM0->M0_NOME + CHR(13) + CHR(10)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza as perguntes de relatorios	                                                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	GPIncProc(OemToAnsi(STR0015))
	cTexto += CMPAtuSX1()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza o dicionario de arquivos  	                                                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	GPIncProc(OemToAnsi(STR0016))
	cTexto += CMPAtuSX2()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza o dicionario de dados     	                                                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	GPIncProc(OemToAnsi(STR0017))
	cTexto += CMPAtuSX3()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza tabelas padrao            	                                                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	GPIncProc(OemToAnsi(STR0018))
	CMPAtuSX5()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza os parametros             	                                                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	GPIncProc(OemToAnsi(STR0019))
	cTexto += CMPAtuSX6()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza os gatilhos            	                                                       	  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	GPIncProc(OemToAnsi(STR0020))
	CMPAtuSX7()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza os folders de cadastro      	                                                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	GPIncProc(OemToAnsi(STR0021))
	CMPAtuSXA()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza as consultas padrao         	                                                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	GPIncProc(OemToAnsi(STR0022))
	CMPAtuSXB()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza os relacionamentos        	                                                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	GPIncProc(OemToAnsi(STR0045))
	CMPAtuSX9()

	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza os indices                 	                                                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	GPIncProc(OemToAnsi(STR0023)) //
	cTexto += CMPAtuSIX()

	__SetX31Mode(.F.)
	For nCont := 1 To Len(aArqUpd)
		GPIncProc(OemToAnsi(STR0024)+"["+aArqUpd[nCont]+"]")
		If Select(aArqUpd[nCont])>0
			dbSelecTArea(aArqUpd[nCont])
			dbCloseArea()
		EndIf
		X31UpdTable(aArqUpd[nCont])
		If __GetX31Error()
			Alert(__GetX31Trace())
			Aviso(OemToAnsi(STR0011),OemToAnsi(STR0025)+ aArqUpd[nCont] + OemToAnsi(STR0026),{OemToAnsi(STR0027)},2)
			cTexto += OemToAnsi(STR0025)+aArqUpd[nCont] +CHR(13)+CHR(10)
		EndIf
	Next nCont		

	RpcClearEnv()
	OpenSm0Excl()
Next nX

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Utilize o trecho abaixo para atualizar dados na base de dados do cliente.                     ³
//³ Troque o nome da funcao UPDXXX pela sua funcao de atualizacao de dados.                       ³
//³ No CMP.CH digite um texto explicativo no STR0028 para o usuario                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*cAlias := "SR2"												// Digite aqui o alias do arquivo a ser tratado
aAlias	:= {"SR2"}

FOR nX := 1 TO Len(aEmpresas)
           
	dbSelectArea("SM0")
	dbGoTo(aEmpresas[nx,3])

	RpcSetEnv(SM0->M0_CODIGO, SM0->M0_CODFIL,,,,, {cAlias})
	
	Processa({|| CMPZap(aAlias)},OemToAnsi(STR0028))

	RpcClearEnv()
	OpenSm0Excl()

Next nX
  */


cTexto := OemToAnsi(STR0029)+CHR(13)+CHR(10)+cTexto
__cFileLog := MemoWrite(Criatrab(,.f.)+".LOG",cTexto)

DEFINE FONT oFont NAME "Mono AS" SIZE 5,12   //6,15
DEFINE MSDIALOG oDlg TITLE OemToAnsi(STR0030) From 3,0 to 390,560 PIXEL
@ 5,5 GET oMemo  VAR cTexto MEMO SIZE 200,145 OF oDlg PIXEL 
oMemo:bRClicked := {||AllwaysTrue()}
oMemo:oFont:=oFont

DEFINE SBUTTON  FROM 153,175 TYPE 1 ACTION oDlg:End() ENABLE OF oDlg PIXEL //Apaga
DEFINE SBUTTON  FROM 153,145 TYPE 13 ACTION (cFile:=cGetFile(cMask,""),If(cFile="",.t.,MemoWrite(cFile,cTexto))) ENABLE OF oDlg PIXEL


ACTIVATE MSDIALOG oDlg CENTER


Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³CMPAtuSIX ³ Autor ³Generico               ³ Data ³   / /    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao de processamento da gravacao do SIX                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Processamento do Compatibilizador                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CMPAtuSIX()

Local aIndices  := {}
Local cTexto 	:= ''
Local lSIX   	:= .F.
Local lNew   	:= .F.
Local aSIX   	:= {}
Local aEstrut	:= {}
Local i      	:= 0
Local j      	:= 0
Local cAlias 	:= ''

//INDICE ORDEM CHAVE DESCRICAO DESCSPA DESCENG PROPRI F3 NICKNAME

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Preencha a matriz aSIX com os indices a serem criados. Utilize a mesma ordem indicada na      ³
//³ matriz aEstrut                                                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (cPaisLoc == "BRA")
	aEstrut	 := {"INDICE","ORDEM","CHAVE","DESCRICAO","DESCSPA","DESCENG","PROPRI","F3","NICKNAME","SHOWPESQ"}
   aAdd(aSIX,{"RG3","1","RG3_FILIAL+RG3_EMP+RG3_FIL+RG3_PERIOD+RG3_SEMANA","Cod Empresa+Filial+Periodo+Semana","Cod.Empresa+Sucursal+Periodo+Semana","Company Code+Branch+Period+Week","S","","","S"})
   aAdd(aSIX,{"RG3","2","RG3_FILIAL+RG3_EMP+RG3_PERIOD+RG3_SEMANA+RG3_FIL","Cod Empresa+Periodo+Semana+Filial","Cod.Empresa+Periodo+Semana+Sucursal","Company Code+Period+Week+Branch","S","","","S"})
   //-- Apenas Alias cujos indices tiveram a chave modificada
   aAdd(aIndices, "   " )
Else
	aEstrut:= {"INDICE","ORDEM","CHAVE","DESCRICAO","DESCSPA","DESCENG","PROPRI","F3","NICKNAME"}
   //Aadd(aSIX,{})
   aAdd(aIndices, "" )
EndIf
	
dbSelectArea("SIX")
dbSetOrder( 1 )

For i:= 1 To Len(aSIX)
	If !Empty(aSIX[i,1])
		If !dbSeek(aSIX[i,1]+aSIX[i,2])
			lNew:= .T.
		Else
			lNew:= .F.
		EndIf
		
		If lNew.Or.UPPER(Alltrim(aSIX[i,3]))!=UPPER(AllTrim(CHAVE))
			aAdd(aArqUpd,aSIX[i,1])		
			lSIX := .T.
			If !(aSIX[i,1]$cAlias)
				cAlias += aSIX[i,1]+"/"
			EndIf
	
			RecLock("SIX",lNew)
			For j:=1 To Len(aSIX[i])
				If FieldPos(aEstrut[j])>0
					FieldPut(FieldPos(aEstrut[j]),aSIX[i,j])
				EndIf
			Next j
			dbCommit()        
			MsUnLock()
		EndIf
		
		GPIncProc(OemToAnsi(STR0031)) //
	EndIf
Next i

//-- Indices alterados deverao ser deletados ou dropados
For i:=1 to Len(aIndices)
    If !Empty( aIndices[ i ] )
	   //Elimina Arquivo de Indice que teve a chave modificada para recriá-lo ao reentrar no sistema
	   fDeleteInd( aIndices[ i ] )
	Endif
Next i	

If lSIX
	cTexto += OemToAnsi(STR0032)+cAlias+CHR(13)+CHR(10)
EndIf

Return cTexto


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³fDeleteInd³ Autor ³Equipe RH              ³ Data ³ 09/02/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Elimina Indices alterados do Alias passado                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Processamento do Compatibilizador                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fDeleteInd( cAlias )
Local cOldAlias	:= Alias()
Local lRet		:= .T.
Local cIndice	:= ''
Local cTopArq	:= ''
Local cQuery	:= ''
Local nOrdem	:= 1
Local cDriver	:= __cRDD

If ( Select(cAlias) > 0 )
	DbSelectArea(cAlias)
	DbCloseArea()
	If ( cAlias == cOldAlias )
		cOldAlias := ''
	EndIf
EndIf

DbSelectArea('SX2')
DbSetOrder( 1 )
If ( ! DbSeek(cAlias) )
	If ( ! Empty( cOldAlias ) )
		DbSelectArea(cOldAlias)
	EndIf
	Return(.F.)
EndIf

cIndice	 := RetArq( cDriver, AllTrim(SX2->X2_PATH) + AllTrim( SX2->X2_ARQUIVO ), .F. )

If ( cDriver == 'DBFCDX' )
	If ('CTREE' $ RealRdd() ) 
		If ( File( cIndice ) )
			lRet := CTDelFileIdxs( cIndice )
		EndIf
	Else 
		If ( File( cIndice ) )
			lRet:= MsErase( cIndice )	
		Endif	
	Endif
ElseIf ( cDriver == 'DBFCDX' .And. 'CTREE' $ RealRdd() ) .Or. ( cDriver == 'CTREECDX' )
	If ( File( cIndice ) )
		lRet := CTDelFileIdxs( cIndice )
	EndIf
ElseIf ( cDriver == 'BTVCDX' )
	If ( File( cIndice ) )
		lRet := BTVDropFileIdxs( cIndice ) 	
	EndIf
ElseIf ( cDriver == 'TOPCONN' )

	cTopArq	:= Upper(AllTrim(SX2->X2_ARQUIVO))
    
	DbSelectArea('SIX')
	DbSetOrder( 1 )
	DbSeek( cAlias )
    
	While ( ! Eof() ) .And. ( cAlias == SIX->INDICE )
		
      cIndice := cTopArq + AllTrim(Str(nOrdem))
		
		If ( TCCanOpen( cTopArq, cIndice ) )
        
			If ( TcSrvType() != 'AS/400' )
				If ( AllTrim( Upper( TcGetDb() ) ) == 'ORACLE' )
					cQuery := 'DROP INDEX ' + cIndice
				ElseIf ( AllTrim( Upper( TcGetDb() ) ) == 'POSTGRES' )
					cQuery := 'DROP INDEX ' + cIndice
				Else				
					cQuery := 'DROP INDEX ' + cTopArq + '.' + cIndice
				EndIf
				TcSqlExec( cQuery )  
			Else
				 lRet:=MsErase( cIndice )	
		    Endif
			
		Else
            lRet := .F.
		EndIf
		
		nOrdem ++
		DbSkip()
        
	End
	
	TcRefresh( cTopArq )

Else
	If ( File(cIndice) )
		lRet := ( FErase( cIndice ) == 0 )
	EndIf
EndIf

If ( ! Empty( cOldAlias ) )
	DbSelectArea(cOldAlias)
EndIf

Return( lRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³CMPAtuSX1 ³ Autor ³Generico               ³ Data ³   / /    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao de processamento da gravacao do SX1                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Processamento do Compatibilizador                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CMPAtuSX1()

Local aSX1   := {}                                       
Local aEstrut:= {}
Local i      := 0
Local j      := 0
Local lSX1	 := .F.
Local cTexto := ''


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Preencha a matriz aSX1 com as perguntas a serem criadas. Utilize a mesma ordem indicada na    ³
//³ matriz aEstrut                                                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (cPaisLoc == "BRA")
	aEstrut := {"X1_GRUPO","X1_ORDEM","X1_PERGUNT","X1_PERSPA","X1_PERENG","X1_VARIAVL","X1_TIPO","X1_TAMANHO","X1_DECIMAL","X1_PRESEL","X1_GSC","X1_VALID","X1_VAR01","X1_DEF01","X1_DEFSPA1","X1_DEFENG1","X1_CNT01","X1_VAR02","X1_DEF02","X1_DEFSPA2","X1_DEFENG2","X1_CNT02","X1_VAR03","X1_DEF03","X1_DEFSPA3","X1_DEFENG3","X1_CNT03","X1_VAR04","X1_DEF04","X1_DEFSPA4","X1_DEFENG4","X1_CNT04","X1_VAR05","X1_DEF05","X1_DEFSPA5","X1_DEFENG5","X1_CNT05","X1_F3","X1_PYME","X1_GRPSXG","X1_HELP","X1_PICTURE","X1_IDFIL"}
Else
	aEstrut := {"X1_GRUPO","X1_ORDEM","X1_PERGUNT","X1_PERSPA","X1_PERENG","X1_VARIAVL","X1_TIPO","X1_TAMANHO","X1_DECIMAL","X1_PRESEL","X1_GSC","X1_VALID","X1_VAR01","X1_DEF01","X1_DEFSPA1","X1_DEFENG1","X1_CNT01","X1_VAR02","X1_DEF02","X1_DEFSPA2","X1_DEFENG2","X1_CNT02","X1_VAR03","X1_DEF03","X1_DEFSPA3","X1_DEFENG3","X1_CNT03","X1_VAR04","X1_DEF04","X1_DEFSPA4","X1_DEFENG4","X1_CNT04","X1_VAR05","X1_DEF05","X1_DEFSPA5","X1_DEFENG5","X1_CNT05","X1_F3","X1_PYME","X1_GRPSXG","X1_HELP","X1_PICTURE","X1_IDFIL"}
   //Aadd(aSX1,{})
EndIf

dbSelectArea("SX1")
dbSetOrder( 1 )
For i:= 1 To Len(aSX1)
	If !Empty(aSX1[i][1])
		If !dbSeek(aSX1[i,1]+aSX1[i,2])
			lSX1 := .T.
			RecLock("SX1",.T.)
	   
			For j:=1 To Len(aSX1[i])
				If !Empty(FieldName(FieldPos(aEstrut[j])))
					FieldPut(FieldPos(aEstrut[j]),aSX1[i,j])
				EndIf
			Next j
	  
			dbCommit()        
			MsUnLock()
			GPIncProc(OemToAnsi(STR0033))
		EndIf
	EndIf
Next i

If lSX1
	cTexto += OemToAnsi(STR0034)+CHR(13)+CHR(10)
EndIf

Return cTexto

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³CMPAtuSX2 ³ Autor ³Generico               ³ Data ³   / /    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao de processamento da gravacao do SX2                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Processamento do Compatibilizador                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CMPAtuSX2()

Local aSX2   := {}
Local aEstrut:= {}
Local i      := 0
Local j      := 0
Local cTexto := ''
Local lSX2	 := .F.
Local cAlias := ''
Local cPath
Local cNome

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Preencha a matriz aSXS com os arquivos a serem criadas. Utilize a mesma ordem indicada na     ³
//³ matriz aEstrut                                                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (cPaisLoc == "BRA")
	aEstrut := {"X2_CHAVE","X2_PATH","X2_ARQUIVO","X2_NOME","X2_NOMESPA","X2_NOMEENG","X2_ROTINA","X2_MODO","X2_DELET","X2_TTS","X2_UNICO","X2_PYME"}
   aAdd(aSx2,{"RG3","\DATA\","RG3990","Controle de Acesso","Control de Acceso","Access Control","","C",0,"","RG3_FILIAL+RG3_EMP+RG3_FIL+RG3_PERIOD+RG3_SEMANA","S"})
Else
	aEstrut := {"X2_CHAVE","X2_PATH","X2_ARQUIVO","X2_NOME","X2_NOMESPA","X2_NOMEENG","X2_DELET","X2_MODO","X2_TTS","X2_ROTINA","X2_UNICO","X2_PYME"}
   //aAdd(aSX2,{})		
EndIf

dbSelectArea("SX2")
dbSetOrder( 1 )
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ A partir de um registro do SX2, carrega informacoes para gravacao de novo registro: path, no. ³
//³ da empresa, modo de abertura. Neste exemplo, utilizou-se AF8.                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SX2->( dbSeek("SRA"))
cPath := SX2->X2_PATH
cNome := Substr(SX2->X2_ARQUIVO,4,5)
//cModo	:= SX2->X2_MODO

For i:= 1 To Len(aSX2)
	If !Empty(aSX2[i][1])
		If !dbSeek(aSX2[i,1])
			lSX2	:= .T.
			If !(aSX2[i,1]$cAlias)
				cAlias += aSX2[i,1]+"/"
			EndIf
			RecLock("SX2",.T.)
			For j:=1 To Len(aSX2[i])
				If FieldPos(aEstrut[j]) > 0
					FieldPut(FieldPos(aEstrut[j]),aSX2[i,j])
				EndIf
			Next j
			SX2->X2_PATH    := cPath
			SX2->X2_ARQUIVO := aSX2[i,1]+cNome
			//SX2->X2_MODO    := cModo
			dbCommit()
			MsUnLock()
			GPIncProc(OemToAnsi(STR0035))
		EndIf
	EndIf
Next i

Return cTexto

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³CMPAtuSX3 ³ Autor ³Generico               ³ Data ³   / /    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao de processamento da gravacao do SX3                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Processamento do Compatibilizador                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CMPAtuSX3()

Local aSX3   	:= {}
Local aEstrut	:= {}
Local i      	:= 0
Local j      	:= 0
Local lSX3	 	:= .F.
Local cTexto 	:= ''
Local cAlias 	:= ''   
//Local aHelpPor	:= {}
//Local aHelpEng	:= {}
//Local aHelpSpa	:= {}
//Local lUpdate	:= .T.  
//Local lCpoAnoBase:= .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Preencha a matriz aSX3 com os campos a serem criados. Utilize a mesma ordem indicada na       ³
//³ matriz aEstrut                                                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aEstrut := {"X3_ARQUIVO","X3_ORDEM","X3_CAMPO","X3_TIPO","X3_TAMANHO","X3_DECIMAL","X3_TITULO","X3_TITSPA","X3_TITENG","X3_DESCRIC","X3_DESCSPA","X3_DESCENG","X3_PICTURE","X3_VALID","X3_USADO","X3_RELACAO","X3_F3","X3_NIVEL","X3_RESERV","X3_CHECK","X3_TRIGGER","X3_PROPRI","X3_BROWSE","X3_VISUAL","X3_CONTEXT","X3_OBRIGAT","X3_VLDUSER","X3_CBOX","X3_CBOXSPA","X3_CBOXENG","X3_PICTVAR","X3_WHEN","X3_INIBRW","X3_GRPSXG","X3_FOLDER","X3_PYME","X3_CONDSQL","X3_CHKSQL"}

aAdd(aSx3,{"RG3","01","RG3_FILIAL","C",2,0,"Filial","Sucursal","Branch","Filial do Sistema","Sucursal","Branch of the System","@!","","€€€€€€€€€€€€€€€","","",1,"€€","","","","N","","","","","","","","","","","","","S","",""})
aAdd(aSx3,{"RG3","02","RG3_EMP","C",2,0,"Cod Empresa","Cod.Empresa","Company Code","Codigo da Empresa","Codigo de la Emp.","Company Code","@!","","€€€€€€€€€€€€€€ ","","",1,"þA","","","","S","V","R","","","","","","","","","","","S","",""})
aAdd(aSx3,{"RG3","03","RG3_FIL","C",2,0,"Filial","Sucursal","Branch","Filial","Sucursal","Branch of the System","@!","","€€€€€€€€€€€€€€ ","","",1,"þA","","","","S","V","R","","","","","","","","","","","S","",""})
aAdd(aSx3,{"RG3","04","RG3_DFIL","C",15,0,"Desc Filial","Des.Sucursal","Branch Descr","Descricao da Filial","Desc. de la Sucursal","Branch Description","@!","","€€€€€€€€€€€€€€ ","","",1,"þA","","","","S","V","V","","","","","","","","","","","S","",""})
aAdd(aSx3,{"RG3","05","RG3_PERIOD","C",6,0,"Periodo","Periodo","Period","Periodo","Periodo","Period","@R 99/9999","","€€€€€€€€€€€€€€ ","","",1,"þA","","","","S","V","R","","","","","","","","","","","S","",""})
aAdd(aSx3,{"RG3","06","RG3_SEMANA","C",2,0,"Semana","Semana","Week","Semana","Semana","Week","99","","€€€€€€€€€€€€€€ ","","",1,"þA","","","","S","V","R","","","","","","","","","","","S","",""})
aAdd(aSx3,{"RG3","07","RG3_DTBLOQ","D",8,0,"Dta Bloqueio","Fcha Bloqueo","Block Date","Data do Bloqueio","Fecha de Bloqueo","Block Date","","","€€€€€€€€€€€€€€ ","","",1,"þA","","","","S","A","R","","","","","","","","","","","S","",""})
aAdd(aSx3,{"RG3","08","RG3_BLQ131","D",8,0,"Bloq 1a Parc","Bloq 1a Cuot","13th 1st Blk","Data Bloqueio 1a Parc 13*","Fcha Bloq 1a Cuota Agnald","13th Sal.1st Instal.Block","","","€€€€€€€€€€€€€€ ","","",1,"þA","","","","S","A","R","","","","","","","","","","","S","",""})
aAdd(aSx3,{"RG3","09","RG3_BLQ132","D",8,0,"Bloq 2a Parc","Bloq 2a Cuot","13th 2st Blk","Data Bloqueio 2a Parc 13*","Fcha Bloq 2a Cuota Agnald","13th Sal.2st Instal.Block","","","€€€€€€€€€€€€€€ ","","",1,"þA","","","","S","A","R","","","","","","","","","","","S","",""})
aAdd(aSx3,{"RG3","10","RG3_USER1","C",6,0,"Usua Lib 01","Usua.Aut.01","User 01 Aut.","Usuario Liberado 01","Usuar.Autorizado 01","User 01 Authorised","999999","Vazio() .Or. UsrExist(M->RG3_USER1) .And. GP710Nome( Nil,.F.,'1' )","€€€€€€€€€€€€€€ ","","USR",1,"þA","","","","S","A","R","","","","","","","","","","","S","",""})
aAdd(aSx3,{"RG3","11","RG3_NUSER1","C",25,0,"Nome Usua 01","Nomb.Usua.01","User 01 Name","Nome do Usuario 01","Nombre Usuario 01","User 01 Name","","","€€€€€€€€€€€€€€ ","","",1,"þA","","","","S","V","V","","","","","","","","","","","S","",""})
aAdd(aSx3,{"RG3","12","RG3_USER2","C",6,0,"Usua Lib 02","Usua.Aut.02","User 02 Aut.","Usuario Liberado 02","Usuar.Autorizado 02","User 02 Authorised","999999","Vazio() .Or. UsrExist(M->RG3_USER2) .And. GP710Nome( Nil,.F.,'2' )","€€€€€€€€€€€€€€ ","","USR",1,"þA","","","","S","A","R","","","","","","","","","","","S","",""})
aAdd(aSx3,{"RG3","13","RG3_NUSER2","C",25,0,"Nome Usua 02","Nomb.Usua.02","User 02 Name","Nome do Usuario 02","Nombre Usuario 02","User 02 Name","","","€€€€€€€€€€€€€€ ","","",1,"þA","","","","S","V","V","","","","","","","","","","","S","",""})

dbSelectArea("SX3")
dbSetOrder( 2 )

For i:= 1 To Len(aSX3)
	If !Empty(aSX3[i][1])
		If !dbSeek(aSX3[i,3])	
			RecLock("SX3",.T.)
		Else	
			RecLock("SX3",.F.)
		Endif
		For j:=1 To Len(aSX3[i])		
			If FieldPos(aEstrut[j])>0
				FieldPut(FieldPos(aEstrut[j]),aSX3[i,j])
			EndIf
		Next j
		dbCommit()        
		MsUnLock()
		lSX3	:= .T.
		If !(aSX3[i,1]$cAlias)
			cAlias += aSX3[i,1]+"/"
			aAdd(aArqUpd,aSX3[i,1])
		EndIf
		GPIncProc(OemToAnsi(STR0036))
	EndIf
Next i

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Atualizar o Help.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*/
If ! lCpoAnoBase
	//Atualiza Help do campo RCT_SIND
	aHelpPor	:= {}
	aHelpEng	:= {}
	aHelpSpa	:= {}
	AADD(aHelpPor,'Neste campo deve ser selecionado ou ')
	AADD(aHelpPor,'informado o código do sindicato ')
	AADD(aHelpPor,'que foi efetuada a contribuição.')
	AADD(aHelpEng,'Neste campo deve ser selecionado ou ')
	AADD(aHelpEng,'informado o código do sindicato ')
	AADD(aHelpEng,'que foi efetuada a contribuição.')
	AADD(aHelpSpa,'Neste campo deve ser selecionado ou ')
	AADD(aHelpSpa,'informado o código do Sindicato ')
	AADD(aHelpSpa,'que foi efetuada a contribuição.')
	PutSX1Help("P"+"RCT_SIND"	,aHelpPor,aHelpEng,aHelpSpa,lUpDate)	 
	
Endif	

//Atualiza Help do campo "RCT_TPCONT"
aHelpPor	:= {}
aHelpEng	:= {}
aHelpSpa	:= {}
AADD(aHelpPor,'Neste campo deve ser informado o Tipo ')
AADD(aHelpPor,'de Contribuição Efetuada.')
AADD(aHelpPor,'1 = Associativa')
AADD(aHelpPor,'2 = Sindical')
AADD(aHelpPor,'3 = Assistencial')
AADD(aHelpPor,'4 = Confederativa')

PutSX1Help("P"+"RCT_TPCONT"	,aHelpPor,aHelpEng,aHelpSpa,.T.)	 
/*/

If lSX3
	cTexto := OemToAnsi(STR0037)+cAlias+CHR(13)+CHR(10)
EndIf

Return cTexto

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³CMPAtuSX5 ³ Autor ³Generico               ³ Data ³   / /    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao de processamento da gravacao do SX5                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Processamento do Compatibilizador                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CMPAtuSX5()

Local aSX5   := {}                                       
Local aEstrut:= {}
Local i      := 0
Local j      := 0
Local lSX5	 := .F.
              
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Preencha a matriz aSX5 com os campos a serem criados. Utilize a mesma ordem indicada na       ³
//³ matriz aEstrut                                                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (cPaisLoc == "BRA")
	aEstrut:= { "X5_FILIAL","X5_TABELA","X5_CHAVE","X5_DESCRI","X5_DESCSPA","X5_DESCENG"}
   //Aadd(aSX5,{})
Else
	aEstrut:= { "X5_FILIAL","X5_TABELA","X5_CHAVE","X5_DESCRI","X5_DESCSPA","X5_DESCENG"}
   //Aadd(aSX5,{})
EndIf

dbSelectArea("SX5")
dbSetOrder( 1 )
For i:= 1 To Len(aSX5)
	If !Empty(aSX5[i][2])
		If !dbSeek(aSX5[i,1]+aSX5[i,2]+aSX5[i,3])	
			lSX5	:= .T.
			RecLock("SX5",.T.)
	   
			For j:=1 To Len(aSX5[i])		
				If !Empty(FieldName(FieldPos(aEstrut[j])))
					FieldPut(FieldPos(aEstrut[j]),aSX5[i,j])
				EndIf
			Next j
			dbCommit()        
			MsUnLock()        
			
			GPIncProc(OemToAnsi(STR0038))
			
		EndIf
	EndIf
Next i

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³CMPAtuSX6 ³ Autor ³Generico               ³ Data ³   / /    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao de processamento da gravacao do SX6                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Processamento do Compatibilizador                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CMPAtuSX6()

Local aSX6   := {}                                       
Local aEstrut:= {}
Local i      := 0
Local j      := 0
Local lSX6	 := .F.
Local cTexto := ''
Local cAlias := ''
              
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Preencha a matriz aSX6 com os campos a serem criados. Utilize a mesma ordem indicada na       ³
//³ matriz aEstrut                                                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (cPaisLoc == "BRA")
	aEstrut:= { "X6_FIL","X6_VAR","X6_TIPO","X6_DESCRIC","X6_DSCSPA","X6_DSCENG","X6_DESC1","X6_DSCSPA1","X6_DSCENG1","X6_DESC2","X6_DSCSPA2","X6_DSCENG2","X6_CONTEUD","X6_CONTSPA","X6_CONTENG","X6_PROPRI","X6_PYME"}
	Aadd(aSX6,{xFilial("SX6"),"MV_BLOQSEM","C","Indique se a rotina de controle de acesso ira","Indique si la rutina de control de acceso validara","Indicate if the routine of access control will","validar a semana digitada","la semana digitada.","validate the week entered.","","","","N","N","N","S","S" })	
Else
	aEstrut:= { "X6_FIL","X6_VAR","X6_TIPO","X6_DESCRIC","X6_DSCSPA","X6_DSCENG","X6_DESC1","X6_DSCSPA1","X6_DSCENG1","X6_DESC2","X6_DSCSPA2","X6_DSCENG2","X6_CONTEUD","X6_CONTSPA","X6_CONTENG","X6_PROPRI","X6_PYME"}
   //Aadd(aSX6,{})					
EndIf

dbSelectArea("SX6")
dbSetOrder( 1 )
For i:= 1 To Len(aSX6)
	If !Empty(aSX6[i][2])
		If !dbSeek(aSX6[i,1]+aSX6[i,2])
			lSX6	:= .T.
			If !(aSX6[i,2]$cAlias)
				cAlias += aSX6[i,2]+"/"
			EndIf
			RecLock("SX6",.T.)
			For j:=1 To Len(aSX6[i])
				If !Empty(FieldName(FieldPos(aEstrut[j])))
					FieldPut(FieldPos(aEstrut[j]),aSX6[i,j])
				EndIf
			Next j
	  
			dbCommit()        
			MsUnLock()
			GPIncProc(OemToAnsi(STR0039))
		EndIf
	EndIf
Next i

If lSX6
	cTexto := OemToAnsi(STR0040)+cAlias+CHR(13)+CHR(10)
EndIf

Return cTexto

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³CMPAtuSX7 ³ Autor ³Generico               ³ Data ³   / /    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao de processamento da gravacao do SX7                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Processamento do Compatibilizador                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CMPAtuSX7()

Local aSX7    := {}
Local aEstrut := {}
Local i       := 0
Local j       := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Preencha a matriz aSX7 com os campos a serem criados. Utilize a mesma ordem indicada na       ³
//³ matriz aEstrut                                                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If (cPaisLoc == "BRA")
	aEstrut := {"X7_CAMPO","X7_SEQUENC","X7_REGRA","X7_CDOMIN","X7_TIPO","X7_SEEK","X7_ALIAS","X7_ORDEM","X7_CHAVE","X7_CONDIC","X7_PROPRI"}
   //Aadd(aSX7,{})	
Else
	aEstrut := {"X7_CAMPO","X7_SEQUENC","X7_REGRA","X7_CDOMIN","X7_TIPO","X7_SEEK","X7_ALIAS","X7_ORDEM","X7_CHAVE","X7_CONDIC","X7_PROPRI"}
   //Aadd(aSX7,{})	
EndIf                        

dbSelectArea("SX7")
dbSetOrder( 1 )
For i:= 1 To Len(aSX7)
	If !Empty(aSX7[i][1])
		If !dbSeek(aSX7[i,1]+aSX7[i,2])
			RecLock("SX7",.T.)
	   
			For j:=1 To Len(aSX7[i])		
				If !Empty(FieldName(FieldPos(aEstrut[j])))
					FieldPut(FieldPos(aEstrut[j]),aSX7[i,j])
				EndIf
			Next j
	  
			dbCommit()        
			MsUnLock()
			GPIncProc(OemToAnsi(STR0041))
		EndIf
	EndIf
Next i

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³CMPAtuSXA ³ Autor ³Generico               ³ Data ³   / /    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao de processamento da gravacao do SXA                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Processamento do Compatibilizador                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function CMPAtuSXA()

Local aSXA   := {}                                       
Local aEstrut:= {}
Local i      := 0
Local j      := 0
Local aSX3	 := {}
Local nCont		 := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Preencha a matriz aSXA com os campos a serem criados. Utilize a mesma ordem indicada na       ³
//³ matriz aEstrut                                                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (cPaisLoc == "BRA")
	aEstrut:= {"XA_ALIAS","XA_ORDEM","XA_DESCRIC","XA_DESCSPA","XA_DESCENG","XA_PROPRI"}
   //Aadd(aSXA,{})
Else
	aEstrut:= {"XA_ALIAS","XA_ORDEM","XA_DESCRIC","XA_DESCSPA","XA_DESCENG","XA_PROPRI"}
   //Aadd(aSXA,{})
EndIf	

dbSelectArea("SXA")
dbSetOrder( 1 )
For i:= 1 To Len(aSXA)
	If !Empty(aSXA[i][1])
		If !dbSeek(aSXA[i,1]+aSXA[i,2])
			RecLock("SXA",.T.)
			For j:=1 To Len(aSXA[i])		
				If !Empty(FieldName(FieldPos(aEstrut[j])))
					FieldPut(FieldPos(aEstrut[j]),aSXA[i,j])
				EndIf
			Next j
	  
			dbCommit()        
			MsUnLock()
			GPIncProc(OemToAnsi(STR0042))
		EndIf
	EndIf
Next i

aSX3 := {}
                
dbSelectArea("SX3")
dbSetOrder( 2 )
For nCont := 1 to Len(aSX3)
	If dbSeek(aSX3[nCont][1])
		RecLock("SX3",.F.)
		SX3->X3_FOLDER := aSX3[nCont][2]
		MsUnlock()
	EndIf
Next

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³CMPAtuSXB ³ Autor ³Generico               ³ Data ³   / /    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao de processamento da gravacao do SXB                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Processamento do Compatibilizador                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CMPAtuSXB()

Local aSXB   := {}                                       
Local aEstrut:= {}
Local i      := 0
Local j      := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Preencha a matriz aSXB com os campos a serem criados. Utilize a mesma ordem indicada na       ³
//³ matriz aEstrut                                                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (cPaisLoc == "BRA")
	aEstrut:= {"XB_ALIAS","XB_TIPO","XB_SEQ","XB_COLUNA","XB_DESCRI","XB_DESCSPA","XB_DESCENG","XB_CONTEM"}
   //Aadd(aSXB,{})
Else
	aEstrut:= {"XB_ALIAS","XB_TIPO","XB_SEQ","XB_COLUNA","XB_DESCRI","XB_DESCSPA","XB_DESCENG","XB_CONTEM"}
   //Aadd(aSXB,{})
EndIf	

dbSelectArea("SXB")
dbSetOrder( 1 )
For i:= 1 To Len(aSXB)
	If !Empty(aSXB[i][1])
		If !dbSeek(aSXB[i,1]+aSXB[i,2]+aSXB[i,3]+aSXB[i,4])	
			RecLock("SXB",.T.)
	   
			For j:=1 To Len(aSXB[i])		
				If !Empty(FieldName(FieldPos(aEstrut[j])))
					FieldPut(FieldPos(aEstrut[j]),aSXB[i,j])
				EndIf
			Next j
	  
			dbCommit()        
			MsUnLock()
			GPIncProc(OemToAnsi(STR0043))
		EndIf
	EndIf
Next i

Return(.T.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³CMPAtuSX9 ³ Autor ³Generico               ³ Data ³   / /    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao de processamento da gravacao do SX9                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Processamento do Compatibilizador                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CMPAtuSX9()

Local aSX9   := {}                                       
Local aEstrut:= {}
Local i      := 0
Local j      := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Preencha a matriz aSX9 com os relacionamentos a serem criados. Utilize a mesma ordem indicada na  ³
//³ matriz aEstrut                                                             		                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (cPaisLoc == "BRA")
	aEstrut := {"X9_DOM","X9_IDENT","X9_CDOM","X9_EXPDOM","X9_EXPCDOM","X9_PROPRI","X9_LIGDOM","X9_LIGCDOM","X9_CONDSQL","X9_USEFIL","X9_ENABLE"}
   //Aadd(aSx9,{})
Else
	aEstrut := {"X9_DOM","X9_IDENT","X9_CDOM","X9_EXPDOM","X9_EXPCDOM","X9_PROPRI","X9_LIGDOM","X9_LIGCDOM","X9_CONDSQL","X9_USEFIL","X9_ENABLE"}
   //Aadd(aSx9,{})
EndIf	

dbSelectArea("SX9")
dbSetOrder( 2 )

For i:= 1 To Len(aSX9)
	If !Empty(aSX9[i][1])
		If !dbSeek(aSX9[i,3]+aSX9[i,1] )	
			RecLock("SX9",.T.)
	   
			For j:=1 To Len(aSX9[i])		
				If !Empty(FieldName(FieldPos(aEstrut[j])))
					FieldPut(FieldPos(aEstrut[j]),aSX9[i,j])
				EndIf
			Next j
	  
			dbCommit()        
			MsUnLock()
			GPIncProc(OemToAnsi(STR0044))
		EndIf
	EndIf
Next i
Return(.T.)

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³CMPZAP	    ³ Autor ³ Generico              ³ Data ³  / /     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Limpar os Dados de uma deterinada Tabela		               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ aAlias      - Array com os Alias a ser Limpo				      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T., se a gravação foi bem sucedida                         ³±±
±±³          ³ .F., caso contrário                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/
/*/
Static Function CMPZap(aAlias)
Local nZ 	:= 0
Local lRet  := .T.


If Len(aAlias) > 0

	For nZ := 1 To Len(aAlias)
		dbSelectArea(aAlias[nz])   
		If Ma280Flock(aAliaS[nz])           // Abre Arquivo Exclusivo
			Zap                        // Limpa Arquivo              
		Else
			lRet := .F.	
		Endif	
		dbCloseArea()
	Next nZ
Endif
Return(lRet)		
/*/
                                                                                     
