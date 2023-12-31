#include "protheus.ch"
#include "rwmake.ch"
#include "tbiconn.ch"
#include "ap5mail.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �STJOBB1M	�Autor  �Renato Nogueira     � Data �  09/05/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Job utilizado para importar informa��es de custo do produto ���
���          �(importa��o manual)				    				      ���
�������������������������������������������������������������������������͹��
���Parametro � Nenhum                                                     ���
�������������������������������������������������������������������������ͼ��
���Retorno   � Nenhum                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function STJOBB1M()

Private cWorkFlow	:= "N"
Private cWCodEmp    := cEmpAnt
Private cWCodFil    := cFilAnt

U_STJOBB1E()     

Return()

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �STJOBB1A	�Autor  �Renato Nogueira     � Data �  09/05/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Job utilizado para importar informa��es de custo do produto ���
���          �(importa��o via job)				    				      ���
�������������������������������������������������������������������������͹��
���Parametro � Nenhum                                                     ���
�������������������������������������������������������������������������ͼ��
���Retorno   � Nenhum                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function STJOBB1A()

Private cWorkFlow	:= "S"
Private cWCodEmp    := "01"
Private cWCodFil    := "01"

U_STJOBB1E()     

Return()

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �STJOBB1E	�Autor  �Renato Nogueira     � Data �  09/05/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Job utilizado para importar informa��es de custo do produto ���
���          �									    				      ���
�������������������������������������������������������������������������͹��
���Parametro � Nenhum                                                     ���
�������������������������������������������������������������������������ͼ��
���Retorno   � Nenhum                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function STJOBB1E()

Local aArea	:= GetArea()
Local cArqAuto 	:= "sb1_"+DTOS(date())+".txt"
Local cArqManu	:= ""
Local cDir	  	:= GetSrvProfString("startpath","")+"Importacao\SP\"
Local aSay    	:= {}
Local aButton 	:= {}
Local nOpc    	:= 0
Local cTitulo 	:= ""
Local cDesc1  	:= "Esta rotina ira fazer a importacao dos custos dos produtos"
Local cDesc2  	:= ""
Local nStatus1	:= 0

Return() //desabilitei giovani zago 16/02/17

If cWorkFlow == "S" //Importa��o via job

	PREPARE ENVIRONMENT EMPRESA cWCodEmp FILIAL cWCodFil  TABLES "SB1"
	
	If GETMV("ST_LJOBB1") //Verificar se est� rodando
		Return
	EndIf

	PUTMV("ST_LJOBB1",.T.)
	
	ConOut("------------------------")
	ConOut("Iniciando Ambiente " )
	ConOut("------------------------")
	
	If !File(cDir+cArqAuto)
		ConOut("O arquivo " +cDir+cArqAuto + " n�o foi encontrado. A importa��o ser� abortada!")
		PUTMV("ST_LJOBB1",.F.)
		Return
	EndIf
	
	LerArq(cDir+cArqAuto)
	
Else //Importa��o manual
	
	aAdd( aSay, cDesc1 )
	aAdd( aSay, cDesc2 )
	
	aAdd( aButton, { 5, .T., {|| cArqManu := SelArq()    }} )
	aAdd( aButton, { 1, .T., {|| nOpc := 1, FechaBatch() }} )
	aAdd( aButton, { 2, .T., {|| FechaBatch()            }} )
	
	FormBatch( cTitulo, aSay, aButton )
	
	If nOpc <> 1
		Return Nil
	Endif
	
	If !File(cArqManu)
		MsgInfo("Arquivo de importacao nao encontrado, verifique!")
		PUTMV("ST_LJOBB1",.F.)
		Return
	EndIF
	
	Processa({||LerArq(cArqManu),"Processando... "})
	
EndIf

If cWorkFlow == "S"
	ConOut("------------------------")
	ConOut("Fim do Processamento " )
	ConOut("------------------------")
	
	FT_FUSE()
	 
	nStatus1	:= frename(cDir+cArqAuto,cDir+"PROCESSADOS\sb1_"+DTOS(date())+"_OK.txt")
	
	IF nStatus1 == -1
		ConOut('Falha na opera��o 1 : FError '+str(ferror(),4))
	Endif
	
	PUTMV("ST_LJOBB1",.F.)
	
Else
	MsgInfo("Fim do processamento!")
EndIf

RestArea(aArea)

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �LERARQ	�Autor  �Renato Nogueira     � Data �  09/05/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Job utilizado para importar informa��es de custo do produto ���
���          �									    				      ���
�������������������������������������������������������������������������͹��
���Parametro � cArquivo			                                          ���
�������������������������������������������������������������������������ͼ��
���Retorno   � Nenhum                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function LERARQ(_cArquivo)

Local _aDadCab  	:= {}
Local _aDados	 	:= {}
Local _nNumCposCab 	:= 0
Local _nCt 			:= 0
Local _cFileLog
Local _cPath 		:= ""
Local i, _nHdl
Local _cBuffer 		:= ""
Local _nTamLin 		:= 26 //  Tamanho  + chr(13) + chr(10)

If !File(_cArquivo)
	If cWorkFlow == "S"
		ConOut("Problemas na abertura do arquivo de importa��o")
	Else
		MsgAlert("Problemas na abertura do arquivo de importa��o")
	EndIf
	Return
EndIF

//				|	Campo	   |Tipo|Col.Ini |Tamanho |Dec|Importa ou nao } //	Descricao do Produto
aAdd( _aDadCab, { "B1_COD"	 ,	"C", 01,		15,		0, .T. } ) //1
aAdd( _aDadCab, { "B1_XPCSTK",	"N", 16,		10,		0, .T. } ) //2

_nNumCposCab  := LEN(_aDadCab)

_nHdl := FOpen(_cArquivo, 0)

If _nHdl < 0
	If cWorkFlow == "S"
		ConOut("Problemas na abertura do arquivo de importa��o")
	Else
		MsgAlert("Problemas na abertura do arquivo de importa��o")
	EndIf
	return NIL
EndIf

fSeek( _nHdl, 0, 0)

_nBtLidos := fRead( _nHdl, @_cBuffer, _nTamLin) //FT_FREADLN()

FT_FUSE(_cArquivo)
FT_FGOTOP()
FT_FLASTREC()
ProcRegua(FT_FLASTREC())

While _nBtLidos >= _nTamLin //!FT_FEOF()
	_nCt++
	
	//IncProc("Processando ...")
	
	_aVetCab := {}
	
	For i:=1 to _nNumCposCab
		
		If _aDadCab[i][6]    // T
			_xDado := SUBS(_cBuffer, _aDadCab[i][3], _aDadCab[i][4])
			If     _aDadCab[i][2] == "C"
				_xDado := _xDado
			ElseIf _aDadCab[i][2] == "N"
				_xDado := VAL(_xDado)
			ElseIf _aDadCab[i][2] == "D"
				_xDado := CTOD(SUBS(_xDado, 1, 2)+"/"+SUBS(_xDado, 3, 2)+"/"+SUBS(_xDado, 5, 4))
			EndIf
			aAdd(_aVetCab, {_aDadCab[i][1], _xDado, NIL} )
		EndIf
		
	Next
	
	AADD(_aDados,{_aVetCab[1][2],_aVetCab[2][2]})
	
	_nBtLidos := fRead( _nHdl, @_cBuffer, _nTamLin) //  _cBuffer := FT_FREADLN()
	
EndDo

FClose(_nHdl)

RunProc(_aDados)

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RUNPROC	�Autor  �Renato Nogueira     � Data �  09/05/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Job utilizado para importar informa��es de custo do produto ���
���          �									    				      ���
�������������������������������������������������������������������������͹��
���Parametro � aDados			                                          ���
�������������������������������������������������������������������������ͼ��
���Retorno   � Nenhum                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function RUNPROC(aDados)

Local nX	:= 0

For nX:=1 To Len(aDados)
	
	DbSelectArea("SB1")
	SB1->(DbSetOrder(1))
	SB1->(DbGoTop())
	SB1->(DbSeek(xFilial("SB1")+aDados[nX][1]))
	
	If SB1->(!Eof())
		SB1->(RecLock("SB1",.F.))
		SB1->B1_XPCSTK	:= 0//aDados[nX][2]//giovani zago 16/02/17
		SB1->B1_XDTCUST	:= DATE()
		SB1->(MsUnlock())
	EndIf
	
Next

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �SELARQ	�Autor  �Renato Nogueira     � Data �  09/05/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Job utilizado para importar informa��es de custo do produto ���
���          �									    				      ���
�������������������������������������������������������������������������͹��
���Parametro � aDados			                                          ���
�������������������������������������������������������������������������ͼ��
���Retorno   � Nenhum                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function SelArq()

Private _cExtens   := "Arquivo Texto (*.TXT) |*.TXT|"

_cRet := cGetFile(_cExtens, "Selecione o Arquivo", , , .T., GETF_NETWORKDRIVE+GETF_LOCALFLOPPY+GETF_LOCALHARD)
_cRet := ALLTRIM(_cRet)

Return _cRet