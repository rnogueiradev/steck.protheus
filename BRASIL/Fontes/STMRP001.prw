#include "rwmake.ch"
#include "Font.ch"
#include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออ)ออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณABRESC    บAutor  ณMicrosiga           บ Data ณ  04/01/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function STMRP001
	Local _nCount
	
	Private cCadastro := OemToAnsi("Programa de MRP")
	
	PRIVATE aRotina	:= {	{"Gera SC","u_STSCGera",0,4,0,.f.	} }
	
	OpenMrp()// Abre os Arquivos
	
	DbselectArea('SHA')
	aStruct := SHA->(dbStruct())
	cNomeArq:= CriaTrab("",.F.)
	cIndex  := cNomeArq
	AAdd( aStruct, {"HA_DESCRI"	,"C", 40, 0} )
	AAdd( aStruct, {"HA_GRUPO"	,"C", 4 , 0} )
	AAdd( aStruct, {"HA_OK"		,"C", 2 , 0} )
	AAdd( aStruct, {"HA_CUSTO"	,"N",14 , 4} )
	AAdd( aStruct, {"HA_FORNECE","C",20 , 0} )
	AAdd( aStruct, {"HA_BLOQ"   ,"C",3 , 0} )
	dbCreate( cNomeArq, aStruct, "TOPCONN" ) 	// adicionado o driver TOPCONN \Ajustado
	USE &cNomeArq	Alias Trb  NEW  VIA TOPCONN // adicionado o driver TOPCONN \Ajustado
	dbSelectArea("TRB")
	IndRegua("TRB",cIndex,"HA_FILIAL+HA_GRUPO+HA_PRODUTO+HA_TIPO",,, "Selecionando Registros..." )
	dbSetIndex( cNomeArq +OrdBagExt())
	_cCampo := ""
	
	_aPeriodos :={}
	_aPols     :={}
	nTipo :=  1
	aPeriodos :=aDatas := _calcPER(1)
	_nData := 1
	
	For _nCount :=1 to len(aStruct)
		IF "HA_PER"  $ aStruct[_nCount,1]
			_cCampo+= ALLTRIM(aStruct[_nCount,1])+"+"
			aadd(_aPeriodos,{ALLTRIM(aStruct[_nCount,1]),aDatas[_nData]},{})
			//	AADD(_aPolS ,{ aStruct[_nCount,1], "",dtoc(aDatas[_nData]) , "@E 99999,999.99"  })
			_nData++
			
			
		else
			//AADD(_aPolS ,{  aStruct[_nCount,1], "",aStruct[_nCount,1] ,  })
		endif
		
	Next _nCount
	
	AADD(_aPolS ,{  'HA_OK', ,"" ,  })
	AADD(_aPolS ,{  'HA_PRODUTO', ,"Produto" ,  })
	AADD(_aPolS ,{  'HA_DESCRI' ,  ,"Descricao" ,  })
	AADD(_aPolS ,{  'HA_BLOQ'   ,  ,"Bloqueio" ,  })
	AADD(_aPolS ,{  'HA_FORNECE',  ,"Fornecedor" ,  })
	AADD(_aPolS ,{  'HA_GRUPO'  ,  ,"Grupo" ,  })
	AADD(_aPolS ,{  'HA_TIPO'   ,   ,"Tipo" ,  })
	
	For _nCount :=1 to len(_aPeriodos)
		
		AADD(_aPolS ,{ _aPeriodos[_nCount,1], "",dtoc(_aPeriodos[_nCount,2]),"@E 99999,999.99"  })
		
	Next _nCount
	AADD(_aPolS ,{  'HA_CUSTO' ,   ,"Custo" ,  "@E 99999,999.9999" })
	
	_cCampo+="0"
	
	Dbselectarea("SHA")
	dbGotop()
	//Dbseek("6")
	
	Do While !eof()
		if SHA->ha_tipo == '6' .and. &(_cCampo) > 0
			DbselectArea('SB1')
			DBSETORDER(1)
			Dbseek(xfilial("SB1")+SHA->HA_Produto)
			
			DbselectArea('SA2')
			DBSETORDER(1)
			Dbseek(xfilial("SA2")+SB1->B1_PROC+SB1->B1_LOJPROC)
			
			dbSelectArea("TRB")
			Reclock("TRB",.T.)
			Replace HA_FILIAL  With SHA->HA_FILIAL
			Replace HA_PRODUTO With SHA->HA_Produto
			Replace HA_BLOQ    with IIF(SB1->B1_MSBLQL=='1','Sim',' ')
			Replace HA_OPC     With SHA->HA_Opc
			Replace HA_REVISAO With SHA->HA_Revisao
			Replace HA_NIVEL   With SHA->HA_Nivel
			Replace HA_TIPO    With SHA->HA_TIPO
			Replace HA_TEXTO   With SHA->HA_TEXTO
			Replace	HA_NUMMRP  With SHA->HA_NUMMRP
			For _nCount := 1 to len(_aPeriodos)
				&(_aPeriodos[_nCount,1]) := SHA->(&(_aPeriodos[_nCount,1]))
			Next _nCount
			Replace HA_TIPO    With SHA->HA_TIPO
			Replace HA_GRUPO   With SB1->B1_GRUPO
			Replace HA_DESCRI  With SB1->B1_DESC
			Replace HA_CUSTO   With SB1->B1_CUSTD
			Replace HA_FORNECE With SA2->A2_NREDUZ
			Replace HA_OK      With '  '
			MsUnlock()
		Endif
		Dbselectarea("SHA")
		Dbskip()
		
	Enddo
	
	
	dbGoTop()
	cMarca   	:= GetMark()
	lAllMark    := .f.
	MarkBrow("TRB","HA_OK","",_aPolS,,cMarca,"U_STMRP01a(@lAllMark)",,,,)
	
	
	
	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
	ฑฑณFuno    ณSTMRP01a  ณ Autor ณRVG                    ณ Data ณ13.04.2014ณฑฑ
	ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
	ฑฑณDescrio ณ Marca / Desmarca todos os registros.                       ณฑฑ
	ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
	ฑฑณSintaxe   ณ STMRP001(ExpL1)                                            ณฑฑ
	ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
	ฑฑณParametrosณ ExpL1 - Controla se Marca/Desmarca todos os registros      ณฑฑ
	ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
	ฑฑณRetorno   ณ Nil                                                        ณฑฑ
	ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	*/
User Function STMRP01a(lAllMark)
	
	If lAllMark
		_xCampo := '  '
	Else
		_xCampo := cMarca
	EndIf
	lAllMark := !lAllMark
	_cRecno := recno()
	DbGotop()
	Do while !eof()
		
		RecLock('TRB',.f.)
		HA_OK :=  _xCampo
		MsUnlock()
		
		Dbskip()
		
	Enddo
	
	Dbgoto(_cRecno)
	
	
	
	MarkBRefresh()
	
Return nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณABRESC    บAutor  ณMicrosiga           บ Data ณ  04/01/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function OpenMrp()
	
	Local lRet 		:= .T.
	Local cDrive 	:= "CTREECDX"
	Local cExt		:= ".cdx"
	Local cPath		:= ""
	Local cArqSH5	:= ""
	Local cArqSHA	:= ""
	Local cNameIdx	:= ""
	LOCAL aArea     := GetArea()
	
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Cria semaforo para controle de exclusividade da operacao     ณ
	//ณ Somente na chamada em job nao testa essa exclusividade       ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	dbSelectArea("SX2")
	dbSeek("SH")
	
	cPath:=AllTrim(X2_PATH)+'\'+AllTrim(cFilAnt)+'\'
	
	If EXISTDIR(cPath)
		//-- Define o nome do arquivo SH5
		cArqSH5 := REtArq(cDrive,cPath+"SH5"+Substr(cNumEmp,1,2)+"0",.t.)
		
		//-- Define o nome do arquivo SHA
		cArqSHA := REtArq(cDrive,cPath+"SHA"+Substr(cNumEmp,1,2)+"0",.t.)
	Else
		MakeDir(cPath)
		If EXISTDIR(cPath)
			//-- Define o nome do arquivo SH5
			cArqSH5 := REtArq(cDrive,cPath+"SH5"+Substr(cNumEmp,1,2)+"0",.t.)
			
			//-- Define o nome do arquivo SHA
			cArqSHA := REtArq(cDrive,cPath+"SHA"+Substr(cNumEmp,1,2)+"0",.t.)
		EndIf
	EndIf
	
	
	//-- Abre o arquivo SH5
	If MSFile(cArqSH5,,cDrive)
		dbUseArea( .T. ,cDrive,cArqSH5, "SH5", .T. , .F. )
		
		
		cNameIdx := FileNoExt(cArqSH5)
		
		//-- Checa a existencia do indice permanente para tabela SH5, e cria se nao existir
		
		dbClearIndex()
		dbSetIndex( cNameIdx+cExt )
		
		//-- Abre tabelas em modo compartilhado
		If MSFile(cArqSHA,,cDrive)
			dbUseArea( .T.,cDrive, cArqSHA, "SHA", .T., .F. )
			
			cNameIdx := FileNoExt(cArqSHA)
			
			//-- Checa a existencia do indice permanente para tabela SHA, e cria se nao existir
			dbClearIndex()
			dbSetIndex( cNameIdx+cExt )
			
		Endif
		
	Endif
	
Return ( lRet )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณABRESC    บAutor  ณMicrosiga           บ Data ณ  04/02/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function _calcPER(nTipo)
	Local i, dInicio
	Local aRet:={}
	Local nPosAno, nTamAno, cForAno
	Local lConsSabDom:=Nil
	Pergunte("MTA712",.F.)
	lConsSabDom:=mv_par12 == 1
	If __SetCentury()
		nPosAno := 1
		nTamAno := 4
		cForAno := "ddmmyyyy"
	Else
		nPosAno := 3
		nTamAno := 2
		cForAno := "ddmmyy"
	EndIf
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Adiciona registro em array totalizador utilizado no TREE  ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	dbSelectArea("SH5")
	dbSetOrder(1)
	dbGotop()
	While !Eof()
		// Recupera parametrizacao gravada no ultimo processamento
		// A T E N C A O
		// Quando utilizado o processamento por periodos variaveis o sistema monta o array com
		// os periodos de maneira desordenada, por causa do indice do arquivo SH5
		// O array aRet ้ corrigido logo abaixo
		If H5_ALIAS == "PAR"
			nTipo       := H5_RECNO
			dInicio     := H5_DATAORI
			nPeriodos   := H5_QUANT
			If nTipo == 7
				AADD(aRet,DTOS(CTOD(Alltrim(H5_OPC))))
			EndIf
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ NUMERO DO MRP                                                ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			c711NumMRP:=H5_NUMMRP
		EndIf
		dbSkip()
	End
	
	//Somente para nTipo==7 (Periodos Diversos) re-ordena aRet
	//pois como o H5_OPC esta gravado a data como caracter ex:(09/10/05)
	//o arquivo esta indexado incorretamente (diferente de 20051009)
	If !Empty(aRet)
		ASort(aRet)
		For i:=1 To Len(aRet)
			aRet[i] := CTOD(Substr(aRet[i],7,2)+"/"+Substr(aRet[i],5,2)+"/"+Substr(aRet[i],1,4) )
		Next i
	EndIf
	
	If (nTipo == 2)                         // Semanal
		While Dow(dInicio)!=2
			dInicio--
		EndDo
	ElseIf (nTipo == 3) .or. (nTipo=4)      // Quinzenal ou Mensal
		dInicio:= CtoD("01"+Substr(Dtoc(dInicio),3),cForAno)
	ElseIf (nTipo == 5)                     // Trimestral
		If Month(dInicio) < 4
			dInicio := CtoD("01/01/"+Substr(DtoC(dInicio),7),cForAno)
		ElseIf (Month(dInicio) >= 4) .and. (Month(dInicio) < 7)
			dInicio := CtoD("01/04/"+Substr(DtoC(dInicio),7),cForAno)
		ElseIf (Month(dInicio) >= 7) .and. (Month(dInicio) < 10)
			dInicio := CtoD("01/07/"+Substr(DtoC(dInicio),7),cForAno)
		ElseIf (Month(dInicio) >=10)
			dInicio := CtoD("01/10/"+Substr(DtoC(dInicio),7),cForAno)
		EndIf
	ElseIf (nTipo == 6)                     // Semestral
		If Month(dInicio) <= 6
			dInicio := CtoD("01/01/"+Substr(DtoC(dInicio),7),cForAno)
		Else
			dInicio := CtoD("01/07/"+Substr(DtoC(dInicio),7),cForAno)
		EndIf
	EndIf
	If nTipo != 7
		For i := 1 to nPeriodos
			AADD(aRet,dInicio)
			If nTipo == 1
				dInicio ++
				While !lConsSabDom .And. ( DOW(dInicio) == 1 .or. DOW(dInicio) == 7 )
					dInicio++
				EndDo
			ElseIf nTipo == 2
				dInicio+=7
			ElseIf nTipo == 3
				dInicio := CtoD(If(Substr(DtoC(dInicio),1,2)="01","15"+Substr(DtoC(dInicio),3),;
					"01/"+If(Month(dInicio)+1<=12,StrZero(Month(dInicio)+1,2)+"/"+;
					SubStr(DtoC(dInicio),7),"01/"+Substr(Str(Year(dInicio)+1,4),nPosAno,nTamAno))),cForAno)
			ElseIf nTipo == 4
				dInicio := CtoD("01/"+If(Month(dInicio)+1<=12,StrZero(Month(dInicio)+1,2)+;
					"/"+Substr(Str(Year(dInicio),4),nPosAno,nTamAno),"01/"+Substr(Str(Year(dInicio)+1,4),nPosAno,nTamAno)),cForAno)
			ElseIf nTipo == 5
				dInicio := CtoD("01/"+If(Month(dInicio)+3<=12,StrZero(Month(dInicio)+3,2)+;
					"/"+Substr(Str(Year(dInicio),4),nPosAno,nTamAno),"01/"+Substr(Str(Year(dInicio)+1,4),nPosAno,nTamAno)),cForAno)
			ElseIf nTipo == 6
				dInicio := CtoD("01/"+If(Month(dInicio)+6<=12,StrZero(Month(dInicio)+6,2)+;
					"/"+Substr(Str(Year(dInicio),4),nPosAno,nTamAno),"01/"+Substr(Str(Year(dInicio)+1,4),nPosAno,nTamAno)),cForAno)
			EndIf
		Next i
	EndIf
Return aRet



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGERSCMRP  บAutor  ณMicrosiga           บ Data ณ  04/02/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function STSCGera
	
	Local aArea1      := GetArea()
	Local aArea2      := SC1->(GetArea())
	Local aArea3      := SZI->(GetArea())
	Local aArea4      := SZJ->(GetArea())
	Local aArea5      := SY1->(GetArea())
	Local _cCodComp   := ""
	Local _cAprov     := ""
	Local _cStatus    := ""
	Local _cNomeAp    := ""
	Local cPerg       := "'ERA02"
	Local _cCusto     := '115108'
	
	PutSx1( cPerg, "01","Perํodo de ?                  ","Perํodo de ?                  ","Perํodo de ?                  ","mv_ch1","D",08,0,0,"G","",""      ,"","","mv_par01")
	PutSx1( cPerg, "02","Perํodo At้ ?                 ","Perํodo At้ ?                 ","Perํodo At้ ?                 ","mv_ch2","D",08,0,0,"G","",""      ,"","","mv_par02")
	
	DbSelectArea("SY1")
	SY1->(DbSetOrder(3))//Y1_FILIAL+Y1_USER
	SY1->(DbGoTop())
	If DbSeek(xFilial("SY1")+__cUserId)
		_cCodComp := SY1->Y1_COD
		DbSelectArea("SZI")
		SZI->(DbSetOrder(3))//ZI_FILIAL+ZI_CC+ZI_APROVP
		SZI->(DbGoTop())
		If DbSeek(xFilial("SZI")+(_cCusto))
			_cAprov := SZI->ZI_APROVP
			DbSelectArea("SZJ")
			SZJ->(DbSetOrder(3))//ZJ_FILIAL+ZJ_SOLICIT+ZJ_APROVP
			SZJ->(DbGoTop())
			If DbSeek(xFilial("SZJ")+(__cUserId)+(_cAprov))
				_cStatus  := '3'
				_cNomeAp  := USRRETNAME(_cAprov)
			Else
				Aviso("Inclusใo de Solicita็ใo de Compras"; //01 - cTitulo - Tํtulo da janela
				,"O seu c๓digo de usuแrio nใo estแ vinculado com o " + Alltrim(RetTitle("C1_CC")) + " " + Alltrim(_cCusto) + "."+ Chr(10) + Chr(13) +;
					CHR(10)+CHR(13)+;
					"Voc๊ nใo poderแ confirmar o Item."+ Chr(10) + Chr(13) +;
					CHR(10)+CHR(13)+;
					"A็ใo nใo permitida.",; //02 - cMsg - Texto a ser apresentado na janela.
				{"OK"};                          //03 - aBotoes - Array com as op็๕es dos bot๕es.
				,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
				,;                               //05 - cText - Titulo da Descri็ใo (Dentro da Janela)
				,;                               //06 - nRotAutDefault - Op็ใo padrใo usada pela rotina automแtica
				,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
				,.F.;                            //08 - lEdit - Determina se permite a edi็ใo do campo memo
				,;                               //09 - nTimer - Tempo para exibi็ใo da mensagem em segundos.
				,;                               //10 - nOpcPadrao - Op็ใo padrใo apresentada na mensagem.
				)
				Return
			Endif
		Else
			Aviso("Inclusใo de Solicita็ใo de Compras"; //01 - cTitulo - Tํtulo da janela
			,"O " + Alltrim(RetTitle("C1_CC")) + " " + Alltrim(_cCusto) + " nใo foi cadastrado para utiliza็ใo."+ Chr(10) + Chr(13) +;
				CHR(10)+CHR(13)+;
				"Voc๊ nใo poderแ confirmar o Item."+ Chr(10) + Chr(13) +;
				CHR(10)+CHR(13)+;
				"A็ใo nใo permitida.",; //02 - cMsg - Texto a ser apresentado na janela.
			{"OK"};                          //03 - aBotoes - Array com as op็๕es dos bot๕es.
			,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
			,;                               //05 - cText - Titulo da Descri็ใo (Dentro da Janela)
			,;                               //06 - nRotAutDefault - Op็ใo padrใo usada pela rotina automแtica
			,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
			,.F.;                            //08 - lEdit - Determina se permite a edi็ใo do campo memo
			,;                               //09 - nTimer - Tempo para exibi็ใo da mensagem em segundos.
			,;                               //10 - nOpcPadrao - Op็ใo padrใo apresentada na mensagem.
			)
			Return
		Endif
	Else
		Aviso("Inclusใo de Solicita็ใo de Compras"; //01 - cTitulo - Tํtulo da janela
		,"Voc๊ nใo estแ cadastrado como Comprador."+ Chr(10) + Chr(13) +;
			CHR(10)+CHR(13)+;
			"A Solicita็ใo de Compras nใo serแ gerada."+ Chr(10) + Chr(13) +;
			CHR(10)+CHR(13)+;
			"A็ใo nใo permitida.",; //02 - cMsg - Texto a ser apresentado na janela.
		{"OK"};                          //03 - aBotoes - Array com as op็๕es dos bot๕es.
		,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
		,;                               //05 - cText - Titulo da Descri็ใo (Dentro da Janela)
		,;                               //06 - nRotAutDefault - Op็ใo padrใo usada pela rotina automแtica
		,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
		,.F.;                            //08 - lEdit - Determina se permite a edi็ใo do campo memo
		,;                               //09 - nTimer - Tempo para exibi็ใo da mensagem em segundos.
		,;                               //10 - nOpcPadrao - Op็ใo padrใo apresentada na mensagem.
		)
		Return
	Endif
	
	If Pergunte(cPerg,.t.)
		
		//Processa({|| ImGera() },"Processando Geracao de SC...")
		Processa({|| ImGera(_cCusto,_cCodComp,_cStatus,_cAprov,_cNomeAp) },"Processando Geracao de SC...")
		//Alert("opa")
	Endif
	
	RestArea(aArea5)
	RestArea(aArea4)
	RestArea(aArea3)
	RestArea(aArea2)
	RestArea(aArea1)
	
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGERSCMRP  บAutor  ณMicrosiga           บ Data ณ  04/02/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ImGera(_cCusto,_cCodComp,_cStatus,_cAprov,_cNomeAp)
	Local _cMsgMrp := ""
	Local _nCount := 0
	Local _nPer := 0
	PRIVATE lDiasHl 	:= (VAL(GetVersao(.F.)) == 11 .And. GetRpoRelease() >= "R6"  .Or.  VAL(GetVersao(.F.))  > 11) .AND. FindFunction("A710VerHl")
	PRIVATE lDiasHf 	:= (VAL(GetVersao(.F.)) == 11 .And. GetRpoRelease() >= "R6"  .Or.  VAL(GetVersao(.F.))  > 11) .AND. FindFunction("A710VerHf")
	PRIVATE aPergs711   := ARRAY(10)
	aPergs711[10] :=2
	_aSCsGerar := {}
	Dbselectarea("TRB")
	DbGotop()
	
	aContDt:= {}
	
	Do While !eof()
		
		If !empty(TRB->HA_OK) //==cMarca
			
			For _nCount := 1 to len(_aPeriodos)
				
				if _aperiodos[_nCount ,2 ] >= mv_par01 .and.  _aperiodos[_nCount ,2 ] <= mv_par02  .and. &(_aperiodos[_nCount ,1 ]) > 0
					aadd(_aSCsGerar , {_aperiodos[_nCount ,2 ],ha_produto,&(_aperiodos[_nCount ,1 ]),HA_NUMMRP } )
					
					nPos:= Ascan(aContDt,{|x| x[1] == _aperiodos[_nCount ,2 ] })
					if nPos == 0
						AADD(aContDt,{_aperiodos[_nCount ,2 ],_aperiodos[_nCount ,2 ]})
					Endif
					
				endif
				
				
			Next  _nCount
			Reclock('TRB',.f.)
			delete
			MsUnlock()
			
		endif
		Dbskip()
		
	Enddo
	
	_aSCsGerar := aSort(_aSCsGerar,,, { |x, y| dtos(x[1])+x[2] < dtos(Y[1])+y[2]   })
	
	aContDt := aSort(aContDt,,, { |x, y| dtos(x[1])  < dtos(Y[1])    })
	
	_aSCsGerar := MudaDT(_aSCsGerar , aContDt )
	
	_aSCsGerar := aSort(_aSCsGerar,,, { |x, y| dtos(x[1])+x[2] < dtos(Y[1])+y[2]   })
	
	aItem:={}
	
	if len(_aSCsGerar) > 0
		
		cItem := '0000'
		_cData := ctod('  /  /  ')
		For _nPer := 1 to len(_aSCsGerar)
			
			
			if _cData <> _aSCsGerar[_nPer,1]
				
				_cC1_NUM  := GETSX8NUM("SC1","C1_NUM")      // Numero da ultima Solicitacao de Compra
				
				ConfirmSX8()
				
				
				aItem:={}
				cItem := '0000'
				_cData := _aSCsGerar[_nPer,1]
				
			Endif
			
			
			cItem := sOMA1(cItem)
			DbSelectArea("SB1")
			Dbsetorder(1)
			Dbseek(xfilial("SB1")+_aSCsGerar[_nper,2])
			/*/
			aadd(aItem,{{"C1_ITEM"		,cItem							,Nil},; //Numero do Item
			{"C1_PRODUTO"  				,_aSCsGerar[_nper,2]			,Nil},; //Codigo do Produto
			{"C1_QUANT"  				,_aSCsGerar[_nper,3]     		,Nil},; //Quantidade
			{"C1_LOCAL"  				,SB1->B1_LOCPAD					,Nil},; //Armazem
			{"C1_DATPRF" 				,_aSCsGerar[_nper,1] 			,Nil},; //Data
			{"C1_TPOP"    				,"P"  	                        ,Nil},; // Tipo SC
			{"C1_CC"  					,SB1->B1_CC    					,Nil},; //Centro de Custos
			{"C1_OBS"  					,"Gerado Pelo MRP - "+ _aSCsGerar[_nper,4]		 	  	,Nil},;  //Observacao
			{"C1_MOTIVO"    			,"MRP"			 		   		,Nil},;  //Observacao
			{"AUTVLDCONT" 				,"N"							,Nil}})
			/*/
			_cMsgMrp += "===================================" +CHR(13)+CHR(10)
			_cMsgMrp += "Item de Solicita็ใo de Compra incluso e aprovado automaticamente pela Rotina MRP por: " +CHR(13)+CHR(10)
			_cMsgMrp += "Usuแrio: "+cUserName+CHR(13)+CHR(10)
			_cMsgMrp += "Em: "+DTOC(DDATABASE)+" "+TIME()+CHR(13)+CHR(10)
			dbSelectArea("SC1")
			RecLock("SC1",.T.)
			Replace C1_FILIAL  With xFilial("SC1"),;
				C1_NUM     With _cC1_NUM ,;
				C1_ITEM    With cItem,;
				C1_PRODUTO With SB1->B1_COD,;
				C1_DESCRI  With SB1->B1_DESC,;
				C1_UM      With SB1->B1_UM,;
				C1_SEGUM   With SB1->B1_SEGUM,;
				C1_LOCAL   With RetFldProd(SB1->B1_COD,"B1_LOCPAD"),;
				C1_CC      With SB1->B1_CC,;
				C1_FORNECE With SB1->B1_PROC,;
				C1_LOJA    With SB1->B1_LOJPROC,;
				C1_QUANT   With _aSCsGerar[_nper,3],;
				C1_QTSEGUM With ConvUm(SB1->B1_COD,_aSCsGerar[_nper,3],0,2),;
				C1_EMISSAO With dDataBase,;
				C1_DATPRF  With _aSCsGerar[_nper,1],;
				C1_SOLICIT WITH "MRP",;
				C1_IMPORT  With SB1->B1_IMPORT,;
				C1_TPOP    With  "F",;
				C1_USER    With __cUseriD,;
				C1_MOTIVO  With "MRP",;
				C1_CC      WITH _cCusto,;
				C1_ZSTATUS With _cStatus,;
				C1_ZAPROV  With _cAprov,;
				C1_COMPSTK With _cCodComp,;
				C1_CODCOMP With _cCodComp,;
				C1_ZLOG    With _cMsgMrp
			MsUnlock()
			_cMsgMrp := ""
		Next _nPer
		
	Endif
	MarkBRefresh()
	
Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGERSCMRP  บAutor  ณMicrosiga           บ Data ณ  04/11/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function  MudaDT(_aSCsGerar , aContDt )
	
	Local	oAlert		:=	LoadBitmap( GetResources(), "BR_AMARELO" )
	Local	oErro		:=	LoadBitmap( GetResources(), "BR_VERMELHO" )
	Local	oOk			:=	LoadBitmap( GetResources(), "BR_VERDE")
	Local	oVlrer		:=	LoadBitmap( GetResources(), "BR_AZUL")
	Local   _cTipoDoc   := '1'
	Local   lOk2:=.F.
	Local _nCount:= 0
	Private _aitens 		:= aContDt
	
	
	
	DEFINE FONT oBold NAME "Arial" SIZE 0, -12 BOLD
	DEFINE MSDIALOG oDlgx2 FROM 000,000  TO 300,400 TITLE OemToAnsi("Aglutinacao de Datas") Of oMainWnd PIXEL
	
	_atit_cab1	:= 	{"Data Original","Nova Data"}
	
	oListBox2 := TWBrowse():New(  2,2,197,95                              ,,_atit_cab1, ,oDlgx2,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )
	
	oListBox2:AddColumn(TCColumn():New( "Data Original"  			,{|| _aItens[ oListBox2:nAt, 01 ] },,,,'LEFT',,.F.,.F.,,,,.F.,))
	oListBox2:AddColumn(TCColumn():New( "Nova Data" 		 		,{|| _aItens[ oListBox2:nAt, 02 ] },,,,'LEFT',,.F.,.F.,,,,.F.,))
	
	oListBox2:SetArray(_aitens)
	oListBox2:bLine := {|| {	_aItens[ oListBox2:nAT, 01 ], _aItens[ oListBox2:nAT, 02 ],   } }
	oListBox2:blDblClick := {|| Alin_Dt(oListBox2:nAT),oListBox2:refresh() }
	
	ACTIVATE MSDIALOG oDlgx2 CENTERED  ON INIT EnchoiceBar(oDlgx2,{||(lOk2:=.T.,oDlgx2:End())},{||(lOk2:=.F.,oDlgx2:End())})
	if lok2
		
		_aNewSC := {}
		
		For _nCount := 1 to len(_aSCsGerar)
			
			nDt := aScan(_aItens,{|x| x[1] ==_aSCsGerar[_nCount,1] })
			
			nI := aScan(_aNewSC,{|x| x[1] == _aitens[nDt,2] .And. x[2] == _aSCsGerar[_nCount,2] })
			
			if nI == 0
				aadd(_aNewSC , {_aitens[nDt,2],_aSCsGerar[_nCount ,2 ],_aSCsGerar[_nCount ,3 ],_aSCsGerar[_nCount ,4 ] } )
			else
				_aNewSC [ni ,3 ]  += _aSCsGerar[_nCount ,3 ]
			endif
			
		Next _nCount
		
	Endif
	
	
	
Return _aNewSC

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGERSCMRP  บAutor  ณMicrosiga           บ Data ณ  04/11/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


Static Function  Alin_dt(_nLinhaAc)
	
	Local lOk:=.F.
	
	_dValor := _aitens[_nLinhaAC,2]
	
	DEFINE MSDIALOG oDlg FROM  140,000 TO 250,360 TITLE OemToAnsi("Alterar Data") PIXEL
	@ 010,013 SAY OemtoAnsi("Nova Data")   SIZE 24,7  OF oDlg PIXEL
	@ 008,035 MSGET _dValor    SIZE 50,09 OF oDlg PIXEL
	
	ACTIVATE MSDIALOG oDlg CENTER ON INIT EnchoiceBar(oDlg,{||(lOk:=.T.,oDlg:End())},{||(lOk:=.F.,oDlg:End())})
	
	If lOk
		
		_aitens[_nLinhaAC,2]  := _dValor
		
		oListBox2:Refresh()
		
	Endif
	
Return





