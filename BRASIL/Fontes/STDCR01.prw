#INCLUDE "PROTHEUS.CH"

User Function STDCR01()

Local aItens	:= {}
Local nX		:= 0
Local aArea		:=  GetArea()
Local cTitulo	:=	"Instrucoes Normativas - Personalizada"
Local cMsg1		:=	"Este programa gera arquivo pr‚-formatado dos lan‡amentos fiscais"
Local cMsg2		:=	"para entrega as Secretarias da Receita Federal, atendendo ao lay-out"
Local cMsg3		:=	"das Instrucoes Normativas. Dever  ser executado em modo mono-usu rio."
Local nOpcA		:= 0
Local nTotReg   := 0
Local cPerg		:= "MTA950"
Local cNorma	:= ""
Local cDir      := ""
Local cVar      := ""
Local cFilBack  := cFilAnt
Local nForFilial:= 0
Local cMsg      := ""
Local cNewFile  := ""
Local cDrive    := ""
Local cExt      := ""
Local cDirRec	:= ""
Local nProcFil	:= 0
Local aProcFil	:= {.F.,cFilAnt}
Local aTrab		:=	{}

Private cDest
Private dDmainc
Private dDmaFin
Private nMoedTit := 1
Private cNrLivro
Private nMes
Private nAno
Private aReturn    := {}
Private aFilsCalc  := {}
Private lExitPFil  := .F.
Private lImprime	:= .F.

FormBatch(cTitulo,{OemToAnsi(cMsg1),OemToAnsi(cMsg2),OemToAnsi(cMsg3)},;
{ { 1,.T.,{|o| nOpcA := 1,o:oWnd:End()}},;
{ 2,.T.,{|o| nOpca := 2,o:oWnd:End()}}})

If ( nOpcA==1 )
     
    
   
	
	//AADD(aItens,{'N4203WT        ','Portaria Interministerial 046/2009'})
	//AADD(aItens,{'S3206B         ','Portaria Interministerial 046/2009'})
	//AADD(aItens,{'S3206D         ','Portaria Interministerial 046/2009'}) 
	
	
	AADD(aItens,{'S4206DZ        ','Portaria Interministerial 046/2009'})
	AADD(aItens,{'S5209D         ','Portaria Interministerial 046/2009'})
	AADD(aItens,{'SS4209DZ       ','Portaria Interministerial 046/2009'})
	
	
	/*
	AADD(aItens,{'S4205B         ','Portaria Interministerial 046/2009'})
	AADD(aItens,{'S4206B         ','Portaria Interministerial 046/2009'})
	AADD(aItens,{'S4209B         ','Portaria Interministerial 046/2009'})
	AADD(aItens,{'S4209D         ','Portaria Interministerial 046/2009'})
	AADD(aItens,{'S5206B         ','Portaria Interministerial 046/2009'})
	AADD(aItens,{'S5206D         ','Portaria Interministerial 046/2009'})
	AADD(aItens,{'S5246T         ','Portaria Interministerial 046/2009'})
	AADD(aItens,{'SS3004B        ','Portaria Interministerial 046/2009'})
	AADD(aItens,{'SS3006B        ','Portaria Interministerial 046/2009'})
	AADD(aItens,{'SS3206B        ','Portaria Interministerial 046/2009'})
	AADD(aItens,{'SS3206D        ','Portaria Interministerial 046/2009'})
	AADD(aItens,{'SS4009B        ','Portaria Interministerial 046/2009'})
	AADD(aItens,{'SS4203B        ','Portaria Interministerial 046/2009'})
	AADD(aItens,{'SS4203B2       ','Portaria Interministerial 046/2009'})
	AADD(aItens,{'SS4203D        ','Portaria Interministerial 046/2009'})
	AADD(aItens,{'SS4206B        ','Portaria Interministerial 046/2009'})
	AADD(aItens,{'SS4206D        ','Portaria Interministerial 046/2009'})
	AADD(aItens,{'SS4209D        ','Portaria Interministerial 046/2009'})
	AADD(aItens,{'SS5206D        ','Portaria Interministerial 046/2009'})

	*/
	
	For nX := 1 to Len(aItens)
		cNorma   := "STDCRE.INI"
		cDest    := "DCR"+aItens[nX][1]+".TXT"
		cDir     := "C:\TEMP\"
		dDmainc  := CTOD("01/01/2013")
		dDmaFin  := CTOD("31/12/2013")
		dDataIni := CTOD("01/01/2013")
		dDataFim := CTOD("31/12/2013")
		nProcFil := 2
		
		MV_PAR01 := CTOD("30/11/2013") //Data de Processamento
		MV_PAR02 := CTOD("31/12/2013") //Data de Validade
		MV_PAR03 := "   " //Revisão
		MV_PAR04 := aItens[nX][1] //Produto
		MV_PAR05 := "27939356895" // CPF
		MV_PAR06 := aItens[nX][2] // PPB
		MV_PAR07 := 1 //Tipo de Coeficiente de Reducao
		MV_PAR08 := 1 //Tipo do DCR-E
		MV_PAR09 := 0 //No. DCR-E Anterior
		MV_PAR10 := 0 //No. Processo Retificador
		MV_PAR11 := 2 //Moeda de Conversao dos Valores
		MV_PAR12 := 0 //Salarios/Ordenados
		MV_PAR13 := 0 //Encargos Sociais/Trabalhistas
		MV_PAR14 := "0001" //Modelo
		
		cNewFile := cDir + cDest
		
		SplitPath(cNewFile,@cDrive,@cDir,@cDest,@cExt)
		
		cDir := cDrive + cDir
		cDest+= cExt
		
		cDirRec := cDir
		aProcFil := {.F.,cFilAnt}
		
		Makedir(cDirRec)
		
		dbSelectArea("SX3")
		dbSetOrder(1)
		Processa({||ProcNorma(cNorma,cDest,cDirRec,aProcFil,@aTrab)})
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Reabre os Arquivos do Modulo desprezando os abertos pela Normativa      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbCloseAll()
		OpenFile(cEmpAnt)
		
		If Type("lExitPFil")=="L" .And. lExitPFil
			DirRemove(cDirRec)
			Exit
		EndIf
		
	Next nX
	
EndIf

MsgAlert("Processo Finalizado!")

Return
