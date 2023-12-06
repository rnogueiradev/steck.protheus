#Include "PROTHEUS.CH"
#Include "TOPCONN.CH"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STDCR04   ºAutor  ³Cristiano Pereira   º Data ³  05-09-14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function STDCR04()

Local aArea		:=  GetArea()
Local cTitulo	:=	"Instrucoes Normativas" //"Instrucoes Normativas"
Local cMsg1		:=	"Este programa gera arquivo pr‚-formatado dos lan‡amentos fiscais" //"Este programa gera arquivo pr‚-formatado dos lan‡amentos fiscais"
Local cMsg2		:=	"para entrega as Secretarias da Receita Federal, atendendo ao lay-out" //"para entrega as Secretarias da Receita Federal, atendendo ao lay-out"
Local cMsg3		:=	"das Instrucoes Normativas. Dever  ser executado em modo mono-usu rio."//"das Instrucoes Normativas. Dever  ser executado em modo mono-usu rio."
Local nOpcA		:= 0
Local nTotReg   := 0
Local cPerg		:= "STMTA950"
Local nOpcA     := 1
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
Local nX		:= 0
Local aTrab		:=	{}
// Normas habilitadas para consolidar por CNPJ completo (Gestão Corporativa)
Local cNorCon1	:= ''
// Normas habilitadas para consolidar por CNPJ+I.E. (Gestão Corporativa)
Local cNorCon2	:= 'DIMESC.INI/GIMDF.INI/GIMRN.INI/NORMA071.INI/DMA.INI/SIENRO.INI/VALPR05.INI/SEF.INI'
// Normas habilitadas para consolidar por CNPJ Raiz (Gestão Corporativa)
Local cNorCon3	:= 'DIEFCE.INI'
Local _cQrySB1  := " "
Local  _aPD     := {}
Local _nPD     


Private cDest
Private dDmainc
Private dDmaFin
Private nMoedTit := 1
Private cNrLivro
Private nMes
Private nAno
Private aReturn    := {}
Private aFilsCalc  := {}
Private aCodLido   := {} // Utilizado na rotina fFilManad (MatXMag) para avaliar os codigos da SRV que ja foram gravados no manad.txt





//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ`¿
//³Variavel "lExitPFil" utilizada para indicar ao processamento do MATA950 que a rotina irah       ³
//³   utilizar a pergunta "Seleciona Filiais" para algum tratamento especifico, porem nao havera a ³
//³   necessidade de criar pastas separadas para cada arquivo resultado. Um exemplo de utilizacao  ³
//³   deste tratamento eh a DAPIMG, onde utiliza a pergunta para consolidar os dados de todas as   ³
//³    filiais em um unico arquivo de resultado. Para se utilizar esta funcionalidade, basta       ³
//³     alterar no .INI o conteudo desta variavel para .T.                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ`Ù
Private lExitPFil  := .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Variavel "lExibeMsg" utilizada para determinar se a mensagem referente ao parametro que trata ³
//³o local de destino do arquivo gerado pela instrucao normativa devera ser exibida. Por default ³
//³a mensagem sera sempre exibida, caso desejar que a mensagem nao seja exibida, esta variavel   ³
//³devera ter seu conteudo alterado para ".F." no arquivo ".INI"                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private lExibeMsg  := .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem da Interface com o usuario                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Pergunte(cPerg,.T.)


cNorma   := AllTrim(MV_PAR03)+ ".INI"
cDest    := AllTrim(MV_PAR04)
cDir     := AllTrim(MV_PAR05)
dDmainc  := MV_PAR01
dDmaFin  := MV_PAR02
dDataIni := MV_PAR01
dDataFim := MV_PAR02
nProcFil := MV_PAR06



//FormBatch(cTitulo,{OemToAnsi(cMsg1),OemToAnsi(cMsg2),OemToAnsi(cMsg3)},;
//{ { 1,.T.,{|o| nOpcA := 1,o:oWnd:End()}},;
//{ 2,.T.,{|o| nOpca := 2,o:oWnd:End()}}})

If ( nOpcA==1 )
	
	//#########################################
	//Inicializa o processamento dos produtos #
	//#########################################
	
	If Select("TSB1") > 0
		DbSelectArea("TSB1")
		DbCloseArea()
	Endif
	
	_cQrySB1    := "  SELECT SB1.B1_COD AS PRODUTO "
	_cQrySB1    += "  FROM "+RetSqlName("SB1")+" SB1"
	_cQrySB1    += "  WHERE SB1.B1_FILIAL = '"+xFilial("SB1")+"'  AND "
	_cQrySB1    += "        SB1.D_E_L_E_T_ <> '*'                 AND "
	_cQrySB1    += "        SB1.B1_COD >= '"+MV_PAR07+"'          AND "
	_cQrySB1    += "        SB1.B1_COD <= '"+MV_PAR08+"'          AND "
	_cQrySB1    += "        SB1.B1_MSBLQL = '2'                    "
	
	TCQUERY  _cQrySB1 NEW ALIAS "TSB1"
	
	
	_nRec := 0
	DbEval({|| _nRec++  })
	
	//###############################
	//Inicializa aArray _aPD        #
	//###############################
	DbSelectARea("TSB1")
	DbGoTop()
	While !TSB1->(EOF())
			AADD(_aPD,{TSB1->PRODUTO,.f.})
		DbSelectArea("TSB1")
		DbSkip()
	Enddo
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Ajusta Perguntas SX1                                                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//AjustaSx1(cPerg)
	Pergunte("STDCRE",.T.)
	
	
	For _nPD := 1 to len(_aPD)	
		
		cNewFile := cDir + _aPD[_nPD,1]+".txt"
		
		
		dbSelectArea("SB1")
	    dbSetOrder(1)
	    If dbSeek(xFilial("SB1")+_aPD[_nPD,1])
      	  If !Empty(SB1->B1_ALTER)
		     MV_PAR04 := _aPD[_nPD,1]
		  Endif
		Endif  
		 
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
		
	Next _nPD
EndIf

RestArea(aArea)

MsgAlert("Processo Finalizado!")

Return
