#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออป ฑฑ
ฑฑบPrograma  ณRFATA03   บ Autor ณ Felipe Munhoes	 บ Data ณ  12/03/09   บ ฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออน ฑฑ
ฑฑบDescricao ณ Importacao do arquivo texto com pedidos de venda validad0. บ ฑฑ
ฑฑบ          ณ                                                            บ ฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออน ฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function RFATM03()

Local aSays 		:= {}
Local aButtons 		:= {}
Private cCadastro	:= "Ajuste de Parametros"
Private cArquivo	:= ""
Private cPerg		:= "FATA01    "

ValidPerg()
//tela de perguntas
If !Pergunte(cPerg,.T.)
	Return
Endif

cArquivo := Alltrim(GETMV("MV_X_IMP"))+mv_par01 //Nome e Caminho da garavacao do arquivo texto. Alltrim(GETMV("MV_X_IMP"))+

//MONTA INTERFACE.
AADD(aSays,"Rotina para gera็ใo de arquivo texto dos Pedidos de Venda " )
AADD(aButtons, { 5,.T.,{|| Pergunte(cPerg,.T. ) } } )//Verificar nome de pergunta
AADD(aButtons, { 1,.T.,{|| Processa({|| OkGeraTxt() },"Processando...") ,FechaBatch() }} )
AADD(aButtons, { 2,.T.,{|| FechaBatch() }} )
//Processa({|| RunCont() },"Processando...")

FormBatch( cCadastro, aSays, aButtons )

Return // Return da tela de processamento.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณOkGeraTxt บAutor  ณFelipe Munhoes  	 บ Data ณ  13/03/2009 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Esta funcao e a principal de geracao do arquivo de texto   บฑฑ
ฑฑบ          ณ para importacao dos dados no caminho escolhodo na tela     บฑฑ
ฑฑบ          ณ de parametros.                                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP7                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function OkGeraTxt()

Local aRegs 		:= {}
Local aConteudo  	:= {}
Local i
Local nLinha    	:= 0
Local aSC5			:= {}
Local aSC6			:= {}
Local aLinha		:= {}
Local cMen			:= ""
Local _zz           := 0
Local _Erroval      := .f.
Local _Campos       := {}
Local cSeqLog		:= "000"
Local oTable //adicionado\Ajustado
Local cAlias //adicionado\Ajustado

Private aMen		:= {}
Private nTamlin
Private cBuffer		:= ""
Private nBytes
Private	_cDirLog    := ""
Private cPedido		:= ""
Private cDataFlex	:= ""
Private cCliente	:= ""
Private cTipoPd		:= ""
Private lAuto 		:= .F.
Private	nErro		:= 0
Private	lMsErroAuto := .F.
// Arqtrab
Private _NomSC5     := ""
Private _NomSC6     := ""
Private _EstSC5     := {}
Private _EstSC6     := {}
Private _Conta      := 0
Private _Hora       := ""
Private _RegTRB     := 0
Private _Inicio     := ""
Private _Fim        := ""
Private _Observ     := ""
Private _ErroTot    := .f.

DbSelectArea("SX3")
DbSetOrder(1)
DbSeek("SC5")
AaDd(_EstSC5,{"OBSERV","C",200,0})
While !Eof() .and. SX3->X3_ARQUIVO == "SC5"
	
	If SX3->X3_TIPO $ "CDN"
		AaDd(_EstSC5,{SX3->X3_CAMPO,SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
	EndIf
	
	DbSelectArea("SX3")
	DbSkip()
End

DbSelectArea("SX3")
DbSetOrder(1)
DbSeek("SC6")
AaDd(_EstSC6,{"OBSERV","C",200,0})
While !Eof() .and. SX3->X3_ARQUIVO == "SC6"
	
	If SX3->X3_TIPO $ "CDN"
		AaDd(_EstSC6,{SX3->X3_CAMPO,SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
	EndIf
	
	DbSelectArea("SX3")
	DbSkip()
End

//-- Tratativa que verifica se a area TRB esta aberta, caso esteja fecha.
If Select("TRB") > 0
	dbSelectArea("TRB")
	dbCloseArea("TRB")
	oTable:Delete("TRB") //adicionado\Ajustado
EndIf    

oTable := FWTemporaryTable():New("TRB") //adicionado\Ajustado
//ณ Cria arquivo temporario para geracao de log de pedidos gerados
_aStru := {}
Aadd(_aStru,{"linha"		,"C",200,0})
//_cArqTRB  := CriaTrab(_aStru,.T.)		//Fun็ใo CriaTrab descontinuada, adicionado o oTable no lugar
oTable:SetFields(_aStru)				//adicionado\Ajustado
oTable:Create()							//adicionado\Ajustado
cAlias	 := oTable:GetAlias()			//adicionado\Ajustado
_cArqTRB := oTable:GetRealName()		//adicionado\Ajustado
dbUseArea(.T.,"TOPCONN",_cArqTRB,cAlias,.F.,.F.) //Alterado\Ajustado - Adicionado o driver "TOPCONN" - dbUseArea(.T.,__LocalDriver,_cArqTRB,"TRB",.F.,.F.)
dbSelectArea("TRB")
RecLock("TRB",.T.)
TRB->linha := "Pedidos gerados em "+DToC(ddatabase)
MsUnLock()
//////////////////////////////////////////////////////////////DbCloseArea("TRB")
// Cria os arquivos temporarios de importacao
_NomSC5     := CriaTrab(_EstSC5,.t.)
_NomSC6     := CriaTrab(_EstSC6,.t.)

DbUseArea(.t.,"TOPCONN",_NomSC5,"TRBSC5",.F.,.F.) //Alterado\Ajustado - Adicionado o driver "TOPCONN" - DbUseArea(.t.,__LocalDriver,_NomSC5,"TRBSC5",.F.,.F.)
Private _IndSC5 := CriaTrab(Nil,.f.)
DbSelectArea("TRBSC5")
IndRegua("TRBSC5",_IndSC5,"C5_FILIAL+C5_NUM",,,"Indexando Arquivo de Trabalho")
DbSetIndex(_IndSC5+OrdBagExt() )

DbUseArea(.t.,"TOPCONN",_NomSC6,"TRBSC6",.F.,.F.) //Alterado\Ajustado - Adicionado o driver "TOPCONN" - DbUseArea(.t.,__LocalDriver,_NomSC6,"TRBSC6",.F.,.F.)
DbSelectArea("TRBSC6")
Private _IndSC6 := CriaTrab(Nil,.f.)
IndRegua("TRBSC6",_IndSC6,"C6_FILIAL+C6_NUM+C6_ITEM+C6_PRODUTO",,,"Indexando Arquivo de Trabalho")
DbSetIndex(_IndSC6+OrdBagExt() )

// Valida็ใo da Exist๊ncia do Arquivo

If !File(cArquivo)
	MsgAlert("Aten็ใo, o arquivo nใo foi localizado!")
	Return .T.
EndIf

//	_cDirLog := "\Importacao\Log\"
_cDirLog := Alltrim(GETMV("MV_X_IMP"))+"log\
_Inicio := time()
FT_FUSE(cArquivo)  // Abertura do Arquivo Texto
FT_FGoTop()
ProcRegua(FT_FLastRec())
FT_FGoTop()
_Conta := 0
// Leitura do Arquivo Texto
While !FT_FEof()

	_Conta ++ 
	IncProc("Lendo arq. txt "+_NomSC5+"-"+_NomSC6+" " + STRZERO(_Conta,8)+" "+Substr(cBuffer,1,1) )
	
	cBuffer := FT_FReadLn()
	
	if Substr(cBuffer,1,1) == "C"
		
		aSC5 := {}
		aSC6 := {}
		                               	
		aSC5 := ;
		{{'C5_FILIAL',alltrim(Substr(cBuffer,2,2)),NIL},;
		{'C5_NUM'    ,alltrim(substr(cBuffer,4,6)),NIL},;
		{'C5_TIPO'   ,alltrim(substr(cBuffer,10,1)),NIL},;
		{'C5_CLIENTE',alltrim(substr(cBuffer,11,6)),NIL},;
		{'C5_LOJACLI',alltrim(substr(cBuffer,17,2)),NIL},;
		{'C5_CLIENT' ,alltrim(substr(cBuffer,11,6)),NIL},;
		{'C5_LOJAENT',alltrim(substr(cBuffer,17,2)),NIL},;
		{'C5_TRANSP' ,alltrim(substr(cBuffer,27,6)),NIL},;
		{'C5_TIPOCLI',alltrim(substr(cBuffer,33,1)),NIL},;
		{'C5_CONDPAG',alltrim(substr(cBuffer,34,3)),NIL},;
		{'C5_DESCFI' ,val(substr(CBuffer,37,5)),NIL},;
		{'C5_EMISSAO',CTOD(Substr(cBuffer,42,2)+"/"+Substr(cBuffer,44,2)+"/"+Substr(cBuffer,48,2)),NIL},;
		{'C5_TPFRETE',alltrim(substr(CBuffer,50,1)),NIL},;
		{'C5_FRETE'  ,val(substr(CBuffer,51,10)+"."+substr(Cbuffer,61,02)),NIL},; 
		{'C5_SEGURO' ,val(substr(CBuffer,63,12)),NIL},;
		{'C5_DESPESA',val(substr(CBuffer,75,14)),NIL},;
		{'C5_FRETAUT',val(substr(CBuffer,89,12)),NIL},;
		{'C5_MOEDA'  ,1,NIL},;
		{'C5_PESOL'  ,val(substr(CBuffer,101,11)),NIL},;
		{'C5_PBRUTO' ,val(substr(CBuffer,112,11)),NIL},;
		{'C5_VOLUME1',val(substr(CBuffer,123,5)),NIL},;
		{'C5_VOLUME2',val(substr(CBuffer,128,5)),NIL},;
		{'C5_VOLUME3',val(substr(CBuffer,133,5)),NIL},;
		{'C5_VOLUME4',val(substr(CBuffer,138,5)),NIL},;
		{'C5_ESPECI1',alltrim(substr(CBuffer,163,25)),NIL},;
		{'C5_ESPECI2',alltrim(substr(CBuffer,188,25)),NIL},;
		{'C5_ESPECI3',alltrim(substr(CBuffer,213,25)),NIL},;
		{'C5_ESPECI4',alltrim(substr(CBuffer,238,25)),NIL},;
		{'C5_ACRSFIN',val(substr(CBuffer,363,6)),NIL},;
		{'C5_MENNOTA',alltrim(substr(CBuffer,369,300)),NIL},;
		{'C5_MENPAD' ,alltrim(substr(CBuffer,969,3)),NIL},;
		{'C5_VEND1'  ,alltrim(substr(CBuffer,989,06)),NIL},;
		{'C5_VEND2'  ,alltrim(substr(CBuffer,995,06)),NIL},;
		{'C5_TIPLIB' ,"1",NIL},;
		{'C5_TPCARGA',"2",NIL},;
		{'C5_PARC1'  ,0.00,NIL},;
		{'C5_PARC2'  ,0.00,NIL},;
		{'C5_PARC3'  ,0.00,NIL},;
		{'C5_PARC4'  ,0.00,NIL},;
		{'C5_TXMOEDA',1.0000,NIL},;
		{'C5_DATA1'  ,CTOD(""),NIL},;
		{'C5_DATA2'  ,CTOD(""),NIL},;
		{'C5_DATA3'  ,CTOD(""),NIL},;
		{'C5_DATA4'  ,CTOD(""),NIL},;
		{'C5_GERAWMS',"1",NIL}}
		
		// Alimenta o arquivo de trabalho:
		DbSelectArea("TRBSC5")
		RecLock("TRBSC5",.T.)
		For _zz := 1 To Len(aSC5)
			FieldPut(FieldPos(aSC5[_ZZ,1]),aSC5[_ZZ,2])
		Next _zz
		MsUnLock()
		
		cPedido	  := aSC5[2][2]
		cTipoPd   := aSC5[3][2]
		cCliente  := aSC5[4][2]
		cDataFlex := aSC5[41][2]
		
		FT_FSKIP()				//Pula uma linha
		cBuffer := FT_FReadLn() // Leitura da proxima linha do arquivo texto
		
	Endif
	
	While Substr(cBuffer,1,1) == "I"

		_Conta ++ 

		IncProc("Lendo arq. txt "+_NomSC5+"-"+_NomSC6+" " + STRZERO(_Conta,8)+" "+Substr(cBuffer,1,1) )

		aLinha := {}
		aAdd(aLinha,{'C6_FILIAL',alltrim(substr(CBuffer,2,2)),NIL})
		aAdd(aLinha,{'C6_ITEM',alltrim(substr(CBuffer,5,2)),NIL})
		aAdd(aLinha,{'C6_PRODUTO',alltrim(substr(CBuffer,7,15)),NIL})
		aAdd(aLinha,{'C6_UM',alltrim(substr(CBuffer,22,2)),NIL})
		aAdd(aLinha,{'C6_QTDVEN',val(substr(CBuffer,24,7)+"."+substr(CBuffer,31,2)),NIL})      // ok
		aAdd(aLinha,{'C6_PRCVEN',val(substr(CBuffer,33,06)+"."+substr(CBuffer,39,05)),NIL})     // ok
		aAdd(aLinha,{'C6_VALOR',val(substr(CBuffer,44,10)+"."+substr(CBuffer,54,02)),NIL})		//ok
		aAdd(aLinha,{'C6_QTDLIB',val(substr(CBuffer,264,7)+"."+substr(CBuffer,271,2)),NIL})		// ok
		aAdd(aLinha,{'C6_TES',alltrim(substr(CBuffer,56,3)),NIL})								// ok	
		aAdd(aLinha,{'C6_LOCAL',"01",NIL})
		aAdd(aLinha,{'C6_CF',alltrim(substr(CBuffer,59,1)+substr(CBuffer,61,3)),NIL})			// ok
		aAdd(aLinha,{'C6_CLI',alltrim(substr(CBuffer,64,6)),NIL})                               // ok
		aAdd(aLinha,{'C6_DESCONT',val(substr(CBuffer,70,3)+"."+substr(CBuffer,73,2)),NIL})      // ok
		aAdd(aLinha,{'C6_VALDESC',val(substr(CBuffer,75,12)+"."+substr(CBuffer,87,02)),NIL})    // ok
		aAdd(aLinha,{'C6_ENTRE1',CTOD(Substr(cBuffer,89,2)+"/"+Substr(cBuffer,91,2)+"/"+Substr(cBuffer,95,2)),NIL})	//ok
		aAdd(aLinha,{'C6_LOJA',alltrim(substr(CBuffer,97,2)),NIL})        // ok
		aAdd(aLinha,{'C6_NUM',alltrim(substr(cBuffer,99,6)),NIL})     // ok
		aAdd(aLinha,{'C6_PEDCLI',alltrim(substr(CBuffer,105,20)),NIL})   //ok
		aAdd(aLinha,{'C6_DESCRI',alltrim(substr(CBuffer,125,30)),NIL})  // ok
		aAdd(aLinha,{'C6_NFORI',alltrim(substr(CBuffer,245,9)),NIL})  	// ok
		aAdd(aLinha,{'C6_SERIORI',alltrim(substr(CBuffer,254,3)),NIL})	// ok
		aAdd(aLinha,{'C6_ITEMORI',alltrim(substr(CBuffer,257,4)),NIL})	// ok
		aAdd(aLinha,{'C6_CLASFIS',alltrim(substr(CBuffer,261,3)),NIL})	// ok
		aAdd(aLinha,{'C6_PRUNIT',val(substr(CBuffer,33,06)+"."+substr(CBuffer,39,05)),NIL})  // ok VAL(substr(CBuffer,273,09)+"."+substr(CBuffer,282,02)),NIL})

 		aAdd(aLinha,{'C6_COMIS1',VAL(substr(CBuffer,285,02)+"."+substr(CBuffer,288,02)),NIL})
 		aAdd(aLinha,{'C6_COMIS2',VAL(substr(CBuffer,290,02)+"."+substr(CBuffer,293,02)),NIL})
 		
		aAdd(aLinha,{'C6_FRETIT',0.00,NIL})
		aAdd(aLinha,{'C6_TPOP',"F",NIL})




		aAdd(aSC6,aLinha)
		
		// Alimenta o arquivo de trabalho:
		DbSelectArea("TRBSC6")
		RecLock("TRBSC6",.T.)
		For _zz := 1 To Len(aLinha)
			FieldPut(FieldPos(aLinha[_zz,1]),aLinha[_zz,2])
		Next _zz
		MsUnLock()
		
		FT_FSKIP()				//Pula uma linha
		cBuffer := FT_FReadLn() // Leitura da proxima linha do arquivo texto
		
	EndDo
	
	
EndDo

_ErroVal  := .f.
_ErroTot  := .f.

DbSelectArea("TRBSC5")
ProcRegua(RecCount())
DbGoTop()
While !Eof()

    _RegTrb := TRBSC5->(Recno())
	IncProc("Grav. Ped.: "+TRBSC5->C5_NUM+" Reg."+Transform(_RegTrb,"@E 999,999,999") )
	
	_ErroVal  := .f.

	// Valida Pedido de Venda
	DbSelectArea("SC5")
	DbSetOrder(1)
	DbSeek(xfilial("SC5")+TRBSC5->C5_NUM)
	If !Eof()
	
		_ErroVal := .t.
		_ErroTot := .t.
		RecLock("TRBSC5",.F.)
		OBSERV  := " Pedido ja importado \"
		MsUnLock()
		
	EndIf

	// Valida Cliente
	DbSelectArea("SA1")
	DbSetOrder(1)
	DbSeek(xfilial("SA1")+TRBSC5->C5_CLIENTE+TRBSC5->C5_LOJACLI)
	If Eof()
	
		_ErroVal := .t.
		_ErroTot := .t.
		RecLock("TRBSC5",.F.)
		OBSERV  := " Cliente nao encontrado \"+TRBSC5->C5_CLIENTE+TRBSC5->C5_LOJACLI
		MsUnLock()
		
	EndIf
	
	// Valida Cliente de entrega
	DbSelectArea("SA1")
	DbSetOrder(1)
	DbSeek(xfilial("SA1")+TRBSC5->C5_CLIENT+TRBSC5->C5_LOJAENT)
	If Eof()

		_ErroVal := .t.
		_ErroTot := .t.
		RecLock("TRBSC5",.F.)
		OBSERV  := Trim(TRBSC5->OBSERV) + " Cliente de entrega nao encontrado \"+TRBSC5->C5_CLIENT+TRBSC5->C5_LOJAENT
		MsUnLock()
		
	EndIf
	
	// Valida Transportadora
	DbSelectArea("SA4")
	DbSetOrder(1)
	DbSeek(xfilial("SA4")+TRBSC5->C5_TRANSP)
	If Eof() .and. !Empty(TRBSC5->C5_TRANSP)

		_ErroVal := .t.
		_ErroTot := .t.
		็
		OBSERV  := Trim(TRBSC5->OBSERV) + " Transportadora nao encontrada \" +TRBSC5->C5_TRANSP
		MsUnLock()
		
	EndIf
	
	// Valida Condicao de pagamento
	DbSelectArea("SE4")
	DbSetOrder(1)
	DbSeek(xfilial("SE4")+TRBSC5->C5_CONDPAG)
	If Eof()

		_ErroVal := .t.
		_ErroTot := .t.
		
		RecLock("TRBSC5",.F.)
		OBSERV  := Trim(TRBSC5->OBSERV) + " Condicao de pagamento nao encontrada \"+TRBSC5->C5_CONDPAG
		MsUnLock()
		
	EndIf
	
	// Valida Formula de Mensagem padrao
	DbSelectArea("SM4")
	DbSetOrder(1)
	DbSeek(xfilial("SM4")+TRBSC5->C5_MENPAD)
	If Eof() .and. !Empty(TRBSC5->C5_MENPAD)

		_ErroVal := .t.
		_ErroTot := .t.
		
		RecLock("TRBSC5",.F.)
		OBSERV  := Trim(TRBSC5->OBSERV) + " Mensagem padrao(formula) nao encontrada \"+TRBSC5->C5_MENPAD
		MsUnLock()
		
	EndIf
	
	// Valida Vendedor Conforme combinado efetua apenas a valida็ใo do vendedor 1
	DbSelectArea("SA3")
	DbSetOrder(1)
	DbSeek(xfilial("SA3")+TRBSC5->C5_VEND1)
	If Eof() .and. !Empty(TRBSC5->C5_VEND1)

		_ErroVal := .t.
		_ErroTot := .t.
		
		RecLock("TRBSC5",.F.)
		OBSERV  := Trim(TRBSC5->OBSERV) + " Vendedor nao encontrado \"+TRBSC5->C5_VEND1
		MsUnLock()
		
	EndIf
	
	_Observ := Trim(TRBSC5->OBSERV)
	// Carrega Matriz do cabecalho de pedido de venda
	aSC5    := {}
	aSC6    := {}
	_Campos := {}
	
	AaDd(_Campos,{'C5_FILIAL' ,TRBSC5->C5_FILIAL ,NIL})
	AaDd(_Campos,{'C5_NUM'    ,TRBSC5->C5_NUM    ,NIL})
	AaDd(_Campos,{'C5_TIPO'   ,TRBSC5->C5_TIPO   ,NIL})
	AaDd(_Campos,{'C5_CLIENTE',TRBSC5->C5_CLIENTE,NIL})
	AaDd(_Campos,{'C5_LOJACLI',TRBSC5->C5_LOJACLI,NIL})
	AaDd(_Campos,{'C5_CLIENT' ,TRBSC5->C5_CLIENT ,NIL})
	AaDd(_Campos,{'C5_LOJAENT',TRBSC5->C5_LOJAENT,NIL})
	AaDd(_Campos,{'C5_TRANSP' ,TRBSC5->C5_TRANSP ,NIL})
	AaDd(_Campos,{'C5_TIPOCLI',TRBSC5->C5_TIPOCLI,NIL})
	AaDd(_Campos,{'C5_CONDPAG',TRBSC5->C5_CONDPAG,NIL})
	AaDd(_Campos,{'C5_DESCFI' ,TRBSC5->C5_DESCFI ,NIL})
	AaDd(_Campos,{'C5_EMISSAO',TRBSC5->C5_EMISSAO,NIL})
	AaDd(_Campos,{'C5_TPFRETE',TRBSC5->C5_TPFRETE,NIL})
	AaDd(_Campos,{'C5_FRETE'  ,TRBSC5->C5_FRETE  ,NIL})
	AaDd(_Campos,{'C5_SEGURO' ,TRBSC5->C5_SEGURO ,NIL})
	AaDd(_Campos,{'C5_DESPESA',TRBSC5->C5_DESPESA,NIL})
	AaDd(_Campos,{'C5_FRETAUT',TRBSC5->C5_FRETAUT,NIL})
	AaDd(_Campos,{'C5_MOEDA'  ,TRBSC5->C5_MOEDA  ,NIL})
	AaDd(_Campos,{'C5_PESOL'  ,TRBSC5->C5_PESOL  ,NIL})
	AaDd(_Campos,{'C5_PBRUTO' ,TRBSC5->C5_PBRUTO ,NIL})
	AaDd(_Campos,{'C5_VOLUME1',TRBSC5->C5_VOLUME1,NIL})
	AaDd(_Campos,{'C5_VOLUME2',TRBSC5->C5_VOLUME2,NIL})
	AaDd(_Campos,{'C5_VOLUME3',TRBSC5->C5_VOLUME3,NIL})
	AaDd(_Campos,{'C5_VOLUME4',TRBSC5->C5_VOLUME4,NIL})
	AaDd(_Campos,{'C5_ESPECI1',TRBSC5->C5_ESPECI1,NIL})
	AaDd(_Campos,{'C5_ESPECI2',TRBSC5->C5_ESPECI2,NIL})
	AaDd(_Campos,{'C5_ESPECI3',TRBSC5->C5_ESPECI3,NIL})
	AaDd(_Campos,{'C5_ESPECI4',TRBSC5->C5_ESPECI4,NIL})
	AaDd(_Campos,{'C5_ACRSFIN',TRBSC5->C5_ACRSFIN,NIL})
	AaDd(_Campos,{'C5_MENNOTA',TRBSC5->C5_MENNOTA,NIL})
	AaDd(_Campos,{'C5_MENPAD' ,TRBSC5->C5_MENPAD ,NIL})
	AaDd(_Campos,{'C5_VEND1'  ,TRBSC5->C5_VEND1  ,NIL})
	AaDd(_Campos,{'C5_VEND2'  ,TRBSC5->C5_VEND2  ,NIL})
	AaDd(_Campos,{'C5_TIPLIB' ,TRBSC5->C5_TIPLIB ,NIL})
	AaDd(_Campos,{'C5_TPCARGA',TRBSC5->C5_TPCARGA,NIL})
	AaDd(_Campos,{'C5_PARC1'  ,TRBSC5->C5_PARC1  ,NIL})
	AaDd(_Campos,{'C5_PARC2'  ,TRBSC5->C5_PARC2  ,NIL})
	AaDd(_Campos,{'C5_PARC3'  ,TRBSC5->C5_PARC3  ,NIL})
	AaDd(_Campos,{'C5_PARC4'  ,TRBSC5->C5_PARC4  ,NIL})
	AaDd(_Campos,{'C5_TXMOEDA',TRBSC5->C5_TXMOEDA,NIL})
	AaDd(_Campos,{'C5_DATA1'  ,TRBSC5->C5_DATA1  ,NIL})
	AaDd(_Campos,{'C5_DATA2'  ,TRBSC5->C5_DATA2  ,NIL})
	AaDd(_Campos,{'C5_DATA3'  ,TRBSC5->C5_DATA3  ,NIL})
	AaDd(_Campos,{'C5_DATA4'  ,TRBSC5->C5_DATA4  ,NIL})
	AaDd(_Campos,{'C5_GERAWMS',TRBSC5->C5_GERAWMS,NIL})
	
	aSC5 := _Campos
	//Aadd(aSC5,_Campos)

	cPedido	  := aSC5[ascan(aSC5, {|x| alltrim(upper(x[1])) == alltrim(UPPER("C5_NUM"    ))}),2]
	cTipoPd   := aSC5[ascan(aSC5, {|x| alltrim(upper(x[1])) == alltrim(UPPER("C5_TIPO"   ))}),2]
	cCliente  := aSC5[ascan(aSC5, {|x| alltrim(upper(x[1])) == alltrim(UPPER("C5_CLIENTE"))}),2]
	
	_Chave := TRBSC5->(C5_FILIAL+C5_NUM)
	
	DbSelectArea("TRBSC6")
	DbSeek(_Chave)
	While !Eof() .and. _Chave == TRBSC6->C6_FILIAL + TRBSC6->C6_NUM
		
		//Valida o Produto
		DbSelectArea("SB1")
		DbSetOrder(1)
		DbSeek(xFilial("SB1")+TRBSC6->C6_PRODUTO)
		If Eof()
			
			_ErroVal := .t.
			_ErroTot := .t.
			RecLock("TRBSC6",.F.)
			Observ := Trim(TRBSC6->OBSERV)+" Produto nao encontrado \"+TRBSC6->C6_PRODUTO
			MsUnLock()
			
		EndIf
		
		//Valida TES
		DbSelectArea("SF4")
		DbSetOrder(1)
		DbSeek(xFilial("SF4")+TRBSC6->C6_TES)
		If Eof()
			
			_ErroVal := .t.
			_ErroTot := .t.
			RecLock("TRBSC6",.F.)
			Observ := Trim(TRBSC6->OBSERV)+" TES nao encontrado \"+TRBSC6->C6_TES
			MsUnLock()
			
		EndIf
		
		aLinha := {}
		aAdd(aLinha,{'C6_FILIAL' ,TRBSC6->C6_FILIAL ,NIL})
		aAdd(aLinha,{'C6_ITEM'   ,TRBSC6->C6_ITEM   ,NIL})
		aAdd(aLinha,{'C6_PRODUTO',TRBSC6->C6_PRODUTO,NIL})
		aAdd(aLinha,{'C6_UM'     ,TRBSC6->C6_UM     ,NIL})
		aAdd(aLinha,{'C6_QTDVEN' ,TRBSC6->C6_QTDVEN ,NIL})
		aAdd(aLinha,{'C6_PRCVEN' ,TRBSC6->C6_PRCVEN ,NIL})
		aAdd(aLinha,{'C6_VALOR'  ,TRBSC6->C6_VALOR  ,NIL})
		aAdd(aLinha,{'C6_QTDLIB' ,TRBSC6->C6_QTDLIB ,NIL})
		aAdd(aLinha,{'C6_TES'    ,TRBSC6->C6_TES    ,NIL})
		aAdd(aLinha,{'C6_LOCAL'  ,TRBSC6->C6_LOCAL  ,NIL})
		aAdd(aLinha,{'C6_CF'     ,TRBSC6->C6_CF     ,NIL})
		aAdd(aLinha,{'C6_CLI'    ,TRBSC6->C6_CLI    ,NIL})
		aAdd(aLinha,{'C6_DESCONT',TRBSC6->C6_DESCONT,NIL})
		aAdd(aLinha,{'C6_VALDESC',TRBSC6->C6_VALDESC,NIL})
		aAdd(aLinha,{'C6_ENTRE1' ,iif(EMPTY(TRBSC6->C6_ENTRE1), TRBSC5->C5_EMISSAO ,TRBSC6->C6_ENTRE1) ,NIL})
		aAdd(aLinha,{'C6_LOJA'   ,TRBSC6->C6_LOJA   ,NIL})
		aAdd(aLinha,{'C6_NUM'    ,TRBSC6->C6_NUM    ,NIL})
		aAdd(aLinha,{'C6_PEDCLI' ,TRBSC6->C6_PEDCLI ,NIL})
		aAdd(aLinha,{'C6_DESCRI' ,TRBSC6->C6_DESCRI ,NIL})
		aAdd(aLinha,{'C6_NFORI'  ,TRBSC6->C6_NFORI  ,NIL})
		aAdd(aLinha,{'C6_SERIORI',TRBSC6->C6_SERIORI,NIL})
		aAdd(aLinha,{'C6_ITEMORI',TRBSC6->C6_ITEMORI,NIL})
		aAdd(aLinha,{'C6_CLASFIS',TRBSC6->C6_CLASFIS,NIL})
		aAdd(aLinha,{'C6_TPOP'   ,TRBSC6->C6_TPOP   ,NIL})
		aAdd(aLinha,{'C6_PRUNIT' ,TRBSC6->C6_PRUNIT ,NIL})

		aAdd(aLinha,{'C6_COMIS1' ,TRBSC6->C6_COMIS1 ,NIL})
		aAdd(aLinha,{'C6_COMIS2' ,TRBSC6->C6_COMIS2 ,NIL})

		aAdd(aSC6,aLinha)
		
		_Observ += trim(TRBSC6->OBSERV)
		
		DbSelectArea("TRBSC6")
		DbSkip()
	End
	
	DbSelectArea("TRBSC5")
	
	If _ErroVal

//		DbCloseArea("TRB")
		dbSelectArea("TRB")		
		RecLock("TRB",.T.)
		TRB->LINHA := " Ped: "+cPedido+" Cliente: "+cCliente+" - Ocorreram erros, consulte log.- 1 - "+_Observ
		MsUnLock()
		
	Else
	
		lMsErroAuto := .F.
		
		//Begin Transaction
		
		MsExecAuto({|x,y,z|Mata410(x,y,z)},aSC5,aSC6,3)
		
		If !lMsErroAuto //Pedido Gerado
			
////////////////////////////////////////			DbCloseArea("TRB")
			dbSelectArea("TRB")
			
			RecLock("TRB",.T.)                    ;
			//dbAppend()
			TRB->LINHA :=" Ped: "+cPedido+" Cliente: "+cCliente+" - Importado com sucesso.- 2 - "+_Observ
			MsUnLock("TRB") 
////////////////////////////////////////			DbCloseArea("TRB")
			dbSelectArea("TRB")
			
		Else //Problema na geracao do Pedido
			
		 //	DisarmTransaction()
			nErro++
			_ErroTot := .t.
			_hora := time()
			_Hora := substr(_Hora,1,2)+substr(_Hora,4,2)
			cSeqLog := Soma1(cSeqLog)
			//cArq       	:= "ErroDeGer_"+"Processado_em_"+DtoS(dDatabase)+"_as_"+Transform(_Hora,"@R 99999")
			cArq       	:= "ErroDeGer_"+"Processado_em_"+DtoS(dDatabase)+"_as_"+Transform(_Hora,"@R 99999") + "_SEQ_" + cSeqLog
			cFileLog 	:= (cArq+".log")
			MostraErro(_cDirLog,cFileLog) 
////////////////////////			DbCloseArea("TRB")
////////////////////////			dbSelectArea("TRB")
			RecLock("TRB",.T.)
			TRB->LINHA := " Ped: "+cPedido+" Cliente: "+cCliente+" - Ocorreram erros, consulte log.- 3 - Veja arquivo: "+cArq+".log"
			MsUnLock("TRB")
			//AADD(aMen,cMen)
			lAuto := .T.
/////////////////////////////////////			DbCloseArea("TRB")			
		Endif
		
		//End Transaction
		
	EndIf
	
	DbSelectArea("TRBSC5")
	DbSkip()
End

_Fim  := Time()
_hora := time()
_Hora := substr(_Hora,1,2)+substr(_Hora,4,2)
dbSelectArea("TRB")

_cArqRel := _cDirLog+"PedGer_"+"Proc_em_"+DtoS(dDatabase)+"_"+_Hora+".txt"      //PROTHEUS_DATA\ "_as_"+Transform(Time(),"@R 99999")+
COPY TO &_cArqReL SDF

DbSelectArea("TRBSC5")

_cArqRel := _cDirLog+"SC5_"+DtoS(dDatabase)+"_"+_Hora+".txt"      //PROTHEUS_DATA\ "_as_"+Transform(Time(),"@R 99999")+
COPY TO &_cArqReL SDF

DbCloseArea()

DbSelectArea("TRBSC6")

_cArqRel := _cDirLog+"SC6_"+DtoS(dDatabase)+"_"+_Hora+".txt"      //PROTHEUS_DATA\ "_as_"+Transform(Time(),"@R 99999")+
COPY TO &_cArqReL SDF

DbCloseArea()

If _ErroTot
	MsgStop("Ocorreram erros na gera็ใo do Pedido. Consulte Log. "+chr(10)+chr(13)+"(Tempo: Ini."+_Inicio+" / Fim."+_Fim+")")
Else
	MsgInfo("Pedidos importados com sucesso. Consulte Log. "+chr(10)+chr(13)+"(Tempo: Ini."+_Inicio+" / Fim."+_Fim+")")
EndIf

FT_FUSE()

u_Rel_Erro() //impressao do log.
//U_RELTST()

dbSelectArea("TRB")
DbCloseArea()

Return .T.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณRdmake    ณValidPerg ณAutor  ณFelipe Munhoes			ณData  ณ13/03/2009ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescriao ณCria Pergunta no SX1                                        ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณUso       ณnomeprog                                                    ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function ValidPerg()

Local aRegs := {}

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
aAdd(aRegs,{cPerg,"01","Caminho do Arq. Txt     ?"	        ,"Nombre y caminho del Archivo. Txt   ?"	,"Name From File and Path?    "	,"mv_ch1","C",70,00 ,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

lValidPerg( aRegs )

Return



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNOVO3     บ Autor ณ AP6 IDE            บ Data ณ  13/11/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Codigo gerado pelo AP6 IDE.                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

user Function Rel_Erro()


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

PRIVATE cDesc1         := "Este programa tem como objetivo imprimir relatorio "
PRIVATE cDesc2         := "de acordo com os parametros informados pelo usuario."
PRIVATE cDesc3         := ""
PRIVATE cPict          := ""
PRIVATE titulo       := "Detalhes da importa็ใo"
PRIVATE nLin         := 80
PRIVATE Cabec1       := " "
PRIVATE Cabec2       := " "
PRIVATE imprime      := .T.
PRIVATE aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := 220
Private tamanho          := "G"
Private nomeprog         := "IMPORT" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo            := 18
Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "IMPORT" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := "SA1"

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.t.)
//wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)
If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Processamento. RPTSTATUS monta janela com a regua de processamento. ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณRUNREPORT บ Autor ณ AP6 IDE            บ Data ณ  13/11/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem

Cabec1       := "Data de Importa็ใo       Pedido         Cliente   Status           Criticas importa็ao"
Cabec2       := " "

dbSelectArea("TRB")
DbGoTop()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ SETREGUA -> Indica quantos registros serao processados para a regua ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

SetRegua(RecCount())

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Impressao do cabecalho do relatorio. . .                            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
dbSelectArea("TRB")
DbGoTop()

While !Eof()
	
	If nLin > 55 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
//		Cabec(Titulo,Cabec1,"",NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif
	
	//log de nao importados.
	@nLin,000 PSAY TRB->LINHA
	nLin++
	
	DbSelectArea("TRB")
	DbSkip()
end              
///////////////////////////////	DbCloseArea("TRB")

SET DEVICE TO SCREEN

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Se impressao em disco, chama o gerenciador de impressao...          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return
