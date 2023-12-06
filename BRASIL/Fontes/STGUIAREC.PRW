#include 'Protheus.ch'
#include 'RwMake.ch'
#include "tbiconn.ch"
#INCLUDE "RPTDEF.CH"

/*====================================================================================\
|Programa  | STGUIAREC         | Autor | GIOVANI.ZAGO            | Data | 16/01/2014  |
|=====================================================================================|
|Descrição |  STGUIAREC     atualiza SF2 apos gravação da N.F.                        |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STGUIAREC                                                                |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
User Function STGUIAREC()
	*-----------------------------*
	Local _xAlias    := GetArea()
	Local _xAliasSF2 := SF2->(GetArea())
	Local _cEstGuia  := GetMv("ST_ESTGUIA",,"AL/CE/MT/PE/AP/DF/SE/RJ/ES/MS") //estados onde tem de mandar a guia
	Local _lGuia     := GetMv("ST_GUIATEL",,.T.)//INDICA SE USA TELA DE APROVAÇÃO
	Local aVetor     := {}
	Local _xEstGuia  := GetMv("ST_XESTGUI",,"AC/AL/AM/AP/CE/DF/ES/MA/MT/MS/PA/PB/PE/PI/RN/RJ/RO/RR/SE/TO/") //estados onde tem de mandar a guia
	Local _nDifal    := 0
	Local _nFECAP    := 0
	If  SF2->F2_ICMSRET > 0 .And. SF2->F2_EST $ _cEstGuia
		
		
		SF2->(RecLock("SF2",.F.))
		SF2->F2_XGUIA  := '1'
		SF2->(MsUnlock())
		SF2->(DbCommit())
		//gera financeiro
		
		If ! _lGuia
			
			aadd(aVetor ,{;
				"FIN",;
				padr(alltrim(SF2->F2_EST+Right( AllTrim( SF2->F2_DOC ) , 5 )),9,' ') ,;
				"TX "	,;
				"ESTADO",;
				"00",;
				dDataBase,;
				dDataBase,;
				DataValida(dDataBase),;
				SF2->F2_ICMSRET,;
				SF2->F2_ICMSRET,;
				"23002     ",;
				"ICMS ST REF A NF "+Right( AllTrim( SF2->F2_DOC ) , 5 )+" UF "+SF2->F2_EST	 ,;
				"Titulo Gerado por Rotina Automatica. Usuario: "+cusername+" - Data: "+dtoc(date())+" - Hora: "+Time() ,;
				SF2->(RECNO()),;
				' ',;
				'3'})
			
			
			Processa({|| u_STRECGUIA(aVetor)},'Gerando Titulo(Guia de Recolhimento')
		EndIf
		
		DbSelectArea("SD2")
		SD2->(DbSetOrder(3))
		If SD2->(DbSeek(xFilial("SD2")+SF2->(F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA)))
			While SD2->(!EOF()) .and. SD2->(D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA) == xFilial("SD2")+SF2->(F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA)
				_nFECAP+= 	SD2->D2_VFCPDIF
				SD2->(DbSkip())
			End
			
			If _nFECAP > 0
				aadd(aVetor ,{;
					"FIN",;
					padr(alltrim(SF2->F2_EST+Right( AllTrim( SF2->F2_DOC ) , 5 )),9,' ') ,;
					"TX "	,;
					"ESTADO",;
					"00",;
					dDataBase,;
					dDataBase,;
					DataValida(dDataBase),;
					_nFECAP,;
					_nFECAP,;
					"23002     ",;
					"ICMS ST REF A NF "+Right( AllTrim( SF2->F2_DOC ) , 5 )+" UF "+SF2->F2_EST	 ,;
					"Titulo Gerado por Rotina Automatica. Usuario: "+cusername+" - Data: "+dtoc(date())+" - Hora: "+Time() ,;
					SF2->(RECNO()),;
					' ',;
					'B'})
				_nFECAP := 0
				Processa({|| u_STRECGUIA(aVetor)},'Gerando Titulo(Guia de Recolhimento')
				
			EndIf
		EndIf
		
		
		
	EndIf
	
	
	DbSelectArea("SF3")
	SF3->(DbSetOrder(5))
	If SF3->(DbSeek( SF2->(F2_FILIAL+F2_SERIE+F2_DOC+F2_CLIENTE+F2_LOJA) ))
		
		If  SF2->F2_ICMSRET = 0 .And.   SF3->F3_DIFAL <> 0  .And. SF2->F2_EST $ _xEstGuia
			
			SF2->(RecLock("SF2",.F.))
			SF2->F2_XGUIA  := '1'
			SF2->(MsUnlock())
			SF2->(DbCommit())
			//gera financeiro
			
			If ! _lGuia
				_nDifal:= U_StDifal(SF2->(F2_FILIAL+F2_SERIE+F2_DOC+F2_CLIENTE+F2_LOJA))
				If _nDifal > 0
					aadd(aVetor ,{;
						"FIN",;
						padr(alltrim(SF2->F2_EST+Right( AllTrim( SF2->F2_DOC ) , 5 )),9,' ') ,;
						"TX "	,;
						"ESTADO",;
						"00",;
						dDataBase,;
						dDataBase,;
						DataValida(dDataBase),;
						_nDifal,;
						_nDifal,;
						"23002     ",;
						"ICMS DIFER. ALIQUOTA REF A NF "+Right( AllTrim( SF2->F2_DOC ) , 5 )+" UF "+SF2->F2_EST	 ,;
						"Titulo Gerado por Rotina Automatica. Usuario: "+cusername+" - Data: "+dtoc(date())+" - Hora: "+Time() ,;
						SF2->(RECNO()),;
						'Emenda Constitucional nº 87/2015 (EC 87015)',;
						'C'})
					
					
					Processa({|| u_STRECGUIA(aVetor)},'Gerando Titulo(Guia de Recolhimento')
				EndIf
			EndIf
		EndIf
	EndIf
	RestArea(_xAliasSF2)
	RestArea(_xAlias)
Return()

/*====================================================================================\
|Programa  | STRECGUIA         | Autor | GIOVANI.ZAGO            | Data | 16/01/2014  |
|=====================================================================================|
|Descrição |  STRECGUIA     Grava SE2 apos gravação da N.F.,  caso tenha guia de      |
|          |  recolhimento                                                            |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STRECGUIA                                                                |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
User Function STRECGUIA(_aSe2)
	*-----------------------------*
	Local k
	Local aVetor := {}
	Local aErros := {}
	Local cLinha := ''
	Local cErros := ''
	Local nY :=0
	Local aErroExe:= {}
	Local _cDecret := ''
	Local cCRLF		:= CHR(13) + CHR(10)
	Local _cDecret := ''
	Private lMsErroAuto := .F.
	
	DbSelectArea("SE2")
	ProcRegua(len(_aSe2)) // Numero de registros a processar
	
	IncProc()
	For k:=1 To Len(_aSe2)
		IncProc()
		
		
		dbselectarea("SE2")
		SE2->(dbSetOrder(1))
		If !(SE2->(DbSeek(Xfilial("SE2")  +_aSe2[ k,01 ]+_aSe2[ k,02 ]+'   '+_aSe2[ k,03 ]+_aSe2[ k,04 ]+_aSe2[ k,05 ]  ) ))
			
			
			aVetor := {	{"E2_PREFIXO"	,_aSe2[ k,01 ] ,Nil},;
				{"E2_NUM"					,_aSe2[ k,02 ] ,Nil},;
				{"E2_TIPO"					,_aSe2[ k,03 ] ,Nil},;
				{"E2_FORNECE"				,_aSe2[ k,04 ] ,Nil},;
				{"E2_LOJA"					,_aSe2[ k,05 ] ,Nil},;
				{"E2_EMISSAO"				,_aSe2[ k,06 ] ,Nil},;
				{"E2_VENCTO"				,_aSe2[ k,07 ] ,Nil},;
				{"E2_VENCREA"				,_aSe2[ k,08 ] ,Nil},;
				{"E2_VALOR"					,_aSe2[ k,09 ] ,Nil},;
				{"E2_VLCRUZ"				,_aSe2[ k,10 ] ,Nil},;
				{"E2_NATUREZ"				,_aSe2[ k,11 ] ,Nil},;
				{"E2_HIST"					,_aSe2[ k,12 ] ,Nil},;
				{"E2_BASEISS"				,_aSe2[ k,09 ] ,Nil},;
				{"E2_BASEINS"				,_aSe2[ k,09 ] ,Nil},;
				{"E2_BASECOF"				,_aSe2[ k,09 ] ,Nil},;
				{"E2_BASEPIS"				,_aSe2[ k,09 ] ,Nil},;
				{"E2_BASECSL"				,_aSe2[ k,09 ] ,Nil},;
				{"E2_ORIGEM"				,"STGERGUI"    ,Nil},;
				{"E2_XGUIA"					,_aSe2[ k,13 ] ,Nil}}
			
			MSExecAuto({|x,y| Fina050(x,y)},aVetor,3)
			aVetor := {}
			
			If lMsErroAuto
				aErros 	:= GetAutoGRLog()
				For nY := 1 To Len(aErros)
					cLinha := aErros[nY]
					cErros += cLinha + cCRLF
					AADD(aErroExec, cLinha)
				Next
			Else
				DbSelectArea("SF2")
				SF2->(DbGoTo(_aSe2[k,14 ]))
				If _aSe2[k,14 ]   = SF2->(RECNO())
					SF2->(RecLock("SF2",.F.))
					SF2->F2_XGUIA  := '3'
					SF2->F2_XPRFGUI := _aSe2[ k,01 ]//Chamado 006590 - Everson Santana - 26/09/18
					SF2->(MsUnlock())
					SF2->(DbCommit())
				EndIf
				
				
				If Alltrim(SF2->F2_EST) = 'DF'
					_cDecret := 'DECRETO No. 33.999/2012'
				ElseIf Alltrim(SF2->F2_EST) = 'GO'
					_cDecret := 'DECRETO No. 7528/2011'
				ElseIf Alltrim(SF2->F2_EST) = 'PR'
					_cDecret := 'DECRETO No. 3949/2012'
				ElseIf Alltrim(SF2->F2_EST) = 'SE'
					_cDecret := 'DECRETO Nº 28.199/2011'
				ElseIf Alltrim(SF2->F2_EST) = 'BA'
					_cDecret := 'DECRETO No.14242/2012'
				ElseIf Alltrim(SF2->F2_EST) = 'AL'
					_cDecret := 'DECRETO No. 23.180/2012'
				ElseIf Alltrim(SF2->F2_EST) = 'MG'
					_cDecret := 'DECRETO No. 46.137/2013'
				ElseIf Alltrim(SF2->F2_EST) = 'PE'
					_cDecret := 'DECRETO No.  35.678/2010'
				ElseIf Alltrim(SF2->F2_EST) = 'RS'
					_cDecret := 'DECRETO No.  46.576/2009'
				ElseIf Alltrim(SF2->F2_EST) = 'AP'
					_cDecret := 'DECRETO No.  4046/2011'
				ElseIf Alltrim(SF2->F2_EST) = 'SC'
					_cDecret := 'DECRETO No.  3174/2010'
				EndIf
				_cCodSt:='100099'
				If !(Empty(Alltrim(	_aSe2[k,15 ] )))
					If _aSe2[k,16 ] = 'B'
						_cDecret := 'EMEN.CONSTIT.Nº87/2015(EC 8701)'
						//_cCodSt  := '100129'
						_cCodSt  := '100102' //DIFAL
					Else
						_cDecret := _aSe2[k,15 ]
						_cCodSt  :='100129'
					EndIf
				EndIf
				
				
				
				SF6->(RecLock("SF6",.T.))
				
				SF6->F6_FILIAL :=  xFilial("SF6")
				SF6->F6_NUMERO := _aSe2[ k,02 ]
				SF6->F6_EST    :=  SF2->F2_EST
				SF6->F6_TIPOIMP:=  IiF(_aSe2[k,16 ] = '3','3','B')
				SF6->F6_VALOR  := _aSe2[ k,09 ]
				SF6->F6_INSC   :=  SM0->M0_INSC
				SF6->F6_DTARREC:= DATE()
				SF6->F6_DTVENC := DATE()
				SF6->F6_MESREF := VAL(SUBSTR(DTOS(DATE()),5,2) )
				SF6->F6_ANOREF := VAL(SUBSTR(DTOS(DATE()),1,4) )
				SF6->F6_NUMCONV:= _cDecret
				SF6->F6_DOC    := SF2->F2_DOC
				SF6->F6_SERIE  := SF2->F2_SERIE
				SF6->F6_CLIFOR := SF2->F2_CLIENTE
				SF6->F6_LOJA   := SF2->F2_LOJA
				SF6->F6_OPERNF := '2'
				SF6->F6_DTPAGTO:= DATE()
				SF6->F6_REF    := '1'
				SF6->F6_CODPROD:= 46
				SF6->F6_CODREC := _cCodSt
				SF6->F6_PROCESS:= '2'
				SF6->F6_OBSERV := _aSe2[ k,01 ]
				
				
				If AllTrim(_aSe2[ k,01 ]) == "DIF"
					SF6->F6_COBREC  := "003"
				ElseIf AllTrim(_aSe2[ k,01 ]) == "FEC"
					SF6->F6_COBREC  := "006"
				Endif
				
				If SF2->F2_EST = 'MT' .And. _cCodSt =="100099"
					SF6->F6_DETRECE:= '000022'
				ElseIf SF2->F2_EST = 'MT' .And. _cCodSt =="100102"
					SF6->F6_DETRECE:= '000055'
				EndIf
				
				SF6->(MsUnlock())
				SF6->(DbCommit())
				
				
			EndIf
		EndIf
	Next k
Return()



User Function xSTARON()
	lOCAL I := 0
	lOCAL j := 0
	Private _aAr01 := {}
	Private _aAr02 := {}
	Private _Type01
	Private _Type02
	
	//PREPARE ENVIRONMENT EMPRESA '01' FILIAL '02'
	
	Aadd(_aAr02,{'GIOVANI','RONALDO'})
	Aadd(_aAr01,{'ROBERTO' })
	Aadd(_aAr01,{ 'CARLOS' })
	Aadd(_aAr01,{ _aAr02})
	
	For i:=1 To Len(_aAr01)
		_Type01 := _aAr01[i,1]
		If valType(_Type01) = 'A'
			_Type02 := _Type01
			For j:=1 To Len(_Type02)
				If _aAr01[i][1][j][1] = 'GIOVANI'
					MsgInfo("giovani na posição: _aAr01 [1] ["+cvaltochar(i)+"] [1] ["+cvaltochar(j)+"]" )
				EndIf
			Next j
		EndIf
		_Type01 := nil
		_Type02 := nil
	Next i
	
Return()



