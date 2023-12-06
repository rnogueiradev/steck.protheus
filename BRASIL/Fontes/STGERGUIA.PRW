#include "Protheus.ch" 
#include "RwMake.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "TopConn.CH"
#INCLUDE "FILEIO.CH"
#INCLUDE "FWMVCDEF.CH"
#DEFINE CR    chr(13)+chr(10)

Static oLbx

/*====================================================================================\
|Programa  | STGERGUIA      | Autor | GIOVANI.ZAGO               | Data | 09/08/2013  |
|=====================================================================================|
|Descrição | Gera FINANCEIRO E GUIAS DE RECOLHIMENTO								  |
|          |       												                      |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STGERGUIA                                                                |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*---------------------------------------------------*
User Function STGERGUIA()   //STGERGUIA
	*---------------------------------------------------*
	Private cPerg       := 'TELSE2'
	Private cTime       := Time()
	Private cHora       := SUBSTR(cTime, 1, 2)
	Private cMinutos    := SUBSTR(cTime, 4, 2)
	Private cSegundos   := SUBSTR(cTime, 7, 2)
	Private cAliasLif   := cPerg+cHora+ cMinutos+cSegundos
	Private cAliasPed   := cPerg+cHora+ cMinutos+cSegundos
	Private cAliasSal   := cPerg+cHora+ cMinutos+cSegundos
	Private aSize    	:= MsAdvSize(.F.)
	Private lMark   	:=  .F.
	Private aVetor 		:= {}
	Private aSbfLoc		:= {}
	Private lSaida  	:= .F.
	Private aCpoEnch	:= {}
	Private nOpcA		:= 0
	Private oOk	   		:= LoadBitmap( GetResources(), "LBOK" )
	Private oNo	   		:= LoadBitmap( GetResources(), "LBNO" )
	Private oChk
	Private lRetorno    := .F.
	Private lChk	 	:= .F.
	Private aVetor	 	:= {}
	//Private oLbx
	Private oLbxz
	Private lInverte 	:= .F.
	Private nContLin 	:= 0
	Private lLote    	:= .F.
	Private oDlg
	Private oDlgx
	Private oList
	Private _nQtd   	:= 0
	Private  _nMeta 	:= 0
	Private oVlrSelec
	Private nVlrSelec 	:= 0
	Private oMarcAll
	Private lMarcAll    	:= .T.
	Private oMarked	 := LoadBitmap(GetResources(),'LBOK')
	Private oNoMarked:= LoadBitmap(GetResources(),'LBNO')
	Private oMeta
	Private oPesc
	Private aTam     := {}
	Private cPesc    := ''
	Private _cSerIbl := IIF(CFILANT='01','001','001')
	Private bFiltraBrw
	Private AFILBRW    := {}
	Private _cEndeStxx  := 'Notas(SF2): '
	Private _cUserAut  :=GetMv('ST_TELGUIA',,'000000')
	aTam   := TamSX3("F2_DOC")
	cPesc  := space(aTam[1])
	cCondicao := "F2_FILIAL=='"+xFilial("SF2")+"'"
	aFilBrw		:=	{'SF2',cCondicao}
	
	If __cUserId $ _cUserAut
		
		Processa({|| 	STQUERY()},'Selecionando Notas')
		
		Processa({|| 	CompMemory()},'Compondo Notas')
		
		If len(aVetor) > 0
			MonTaSlec() // monta a tela
		Else
			MsgInfo("Não Existem Notas Disponiveis!!!!!")
		EndIf
	Else
		MsgInfo("Usuario sem Acesso!!!!")
		
	EndIf
Return()

/*====================================================================================\
|Programa  | STQUERY          | Autor | GIOVANI.ZAGO             | Data | 13/03/2013  |
|=====================================================================================|
|Descrição |   Executa select mediante os parametros                                  |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STQUERY                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
Static Function STQUERY()
	*-----------------------------*
	Local cQuery     := ''
	
	DbSelectArea("SF2")
	SF2->(DbSetOrder(1))
	
	
	cQuery := " SELECT
	cQuery += " *
	cQuery += " FROM "+RetSqlName('SF2')+" SF2 "
	cQuery += " WHERE  SF2.D_E_L_E_T_   = ' '
	cQuery += " AND SF2.F2_XGUIA     = '1'  "//autorizada = faturada
	cQuery += " AND SF2.F2_FILIAL ='"+xFilial("SF2")+"'"
	
	cQuery := ChangeQuery(cQuery)
	
	DbCommitAll()
	If Select(cAliasLif)	 > 0
		(cAliasLif)->(dbCloseArea())
	EndIf
	
	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif,.T.,.T.)
	
	
Return()


/*====================================================================================\
|Programa  | CompMemory       | Autor | GIOVANI.ZAGO             | Data | 13/08/2013  |
|=====================================================================================|
|Descrição |    crio o avetor                                                         |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | CompMemory                                                               |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
Static Function CompMemory()
	*-----------------------------*
	aVetor := {}
	dbSelectArea(cAliasLif)
	(cAliasLif)->(dbGoTop())
	ProcRegua(RecCount()) // Numero de registros a processar
	
	While !(cAliasLif)->(Eof())
		_nQtd++
		IncProc()
		DbSelectArea("SF2")
		SF2->(dbSetOrder(1))
		SF2->(DbSeek(xFilial("SF2")+ (cAliasLif)->F2_DOC+(cAliasLif)->F2_SERIE ))
		aadd(aVetor ,{ lMark ,; 		//01
		(cAliasLif)->F2_DOC		 ,;		//02   nota
		(cAliasLif)->F2_SERIE		 ,;	//03   serie
		(cAliasLif)->F2_VALBRUT		 ,;	//04   valor bruto
		(cAliasLif)->F2_ICMSRET		 ,;	//05   valor GUIA ICMS/ST
		(cAliasLif)->F2_CLIENTE		 ,;	//06   CLIENTE
		(cAliasLif)->F2_LOJA		 ,;	//07   LOJA
		UPPER(ALLTRIM(	Posicione("SA1",1,xFilial("SA1")+	(cAliasLif)->F2_CLIENTE+(cAliasLif)->F2_LOJA,"A1_NOME")))		 ,;	//08   NOME
		(cAliasLif)->F2_EST		 ,;		//09   ESTADO
		SF2->(RECNO())		 ,;			//10   RECNO
		})
		
		(cAliasLif)->(dbSkip())
	End
	If Len(aVetor) = 0
		aadd(aVetor ,{ lMark ,; //01
		''		 ,;				//02   nota
		''		 ,;				//03   serie
		0		 ,;				//04   valor bruto
		0		 ,;				//05   valor GUIA ICMS/ST
		''		 ,;				//06   CLIENTE
		''		 ,;				//07   LOJA
		''		 ,;				//08   NOME
		''		 ,;				//09   ESTADO
		0		 ,;				//10   RECNO
		})
	EndIf
	if oLbx != nil
	   AtuGrid()  // Chamado:20220113001019 - Valdemir Rabelo 11/02/2022
	endif 
Return()

/*====================================================================================\
|Programa  | MonTaSlec        | Autor | GIOVANI.ZAGO             | Data | 13/08/2013  |
|=====================================================================================|
|Descrição |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | MonTaSlec                                                                |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
Static Function MonTaSlec()
	*-----------------------------*
	
	Local aButtons := {{"LBTIK",{|| PedStx()} ,"Gerar Financeiro"}}
	Local nAjustaTela := 30
	
	Do While !lSaida
		nOpcao := 0
		
		Define msDialog odlg title "Gerar Financeiro" From 0,0 To aSize[6]-15,aSize[5]-15  PIXEL OF oMainWnd //from 178,181 to 590,1100 pixel
		
		cLinOk    :="AllwaysTrue()"
		cTudoOk   :="AllwaysTrue()"//'STxGRV()'
		aCpoEnchoice:={'NOUSER'}
		aAltEnchoice := {}
		
		Private Altera:=.t.,Inclui:=.t.,lRefresh:=.t.,aTELA:=Array(0,0),aGets:=Array(0),;
			bCampo:={|nCPO|Field(nCPO)},nPosAnt:=9999,nColAnt:=9999
		Private cSavScrVT,cSavScrVP,cSavScrHT,cSavScrHP,CurLen,nPosAtu:=0
		
		@ 010 + nAjustaTela,010 say "Quantidade( Notas ):"   Of odlg Pixel
		@ 010 + nAjustaTela,080 msget  _nQtd picture "@E 999,999" when .f. size 55,013  Of odlg Pixel
		@ 025 + nAjustaTela,010 say "Selecionados:"   Of odlg Pixel
		@ 025 + nAjustaTela,080 msget  oVlrSelec Var _nMeta picture "@E 999,999" when .f. size 55,013 	 Of odlg Pixel
		
		@ 025 + nAjustaTela,200 say "Pesquisar:"   Of odlg Pixel
		@ 025 + nAjustaTela,240 msget  oPesc Var cPesc   when .t. size 35,013   valid (fpesc(cPesc))	 Of odlg Pixel
		
		//Cria a listbox
		@ 060 + nAjustaTela,000 listbox oLbx fields header " ", "Notas",'Serie',"Valor NF","ICMS/ST","Cliente","Loja","Nome","Estado",'RECNO'  size  aSize[3]-05,255 - nAjustaTela of oDlg pixel on dbLclick(edlista(oLbx:nat,oVlrSelec))
		
		AtuGrid()
		
		//	@ aSize[4]-28 ,005 CHECKBOX oChk VAR lChk PROMPT "Marca/Desmarca" SIZE 60,007 PIXEL OF oDlg on CLICK(aEval(aVetor,{|x| x[1]:=lChk}),fMarca(),oLbx:Refresh())
		
		
		ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg, {||nOpca:=1,lSaida:=.t.,oDlg:End()}	,{|| nOpca := 0,lSaida:=.t.,oDlg:End()},,aButtons)
		
	End
	If nOpca =1
		//If MSGYESNO("Deseja Gerar o Pedido de Transferencia Com os Endereços Selecionados ?")
		//Processa({|| 	GeraPed()},'Gerando Pedido .......')
		//EndIf
	EndIf
Return()


/*====================================================================================\
|Programa  | fMarca           | Autor | GIOVANI.ZAGO             | Data | 13/08/2013  |
|=====================================================================================|
|Descrição |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | fMarca                                                                   |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
Static Function PedStx()
	*-----------------------------*
	
	If MSGYESNO("Deseja Gerar as Notas Selecionados ?")
		Processa({|| 	GeraPed()},'Gerar Financeiro.......')
	EndIf
	
	STQUERY()
	aVetor:= {}
	_nQtd := 0
	_nMeta:= 0
	Processa({|| 	CompMemory()},'Atualizando Notas.....')
		
	oVlrSelec:Refresh()
	//oLbx:Refresh()
	oDlg:Refresh()
	oDlg:End()
	
Return()


/*====================================================================================\
|Programa  | fMarca           | Autor | GIOVANI.ZAGO             | Data | 13/08/2013  |
|=====================================================================================|
|Descrição |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | fMarca                                                                   |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
Static Function fMarca()
	*-----------------------------*
	local b
	
	_nMeta:=0
	
	for b:= 1 to Len(aVetor)
		
		If aVetor[oLbx:nAt,1]
			_nMeta++
		EndIf
		
	next b
	
	oVlrSelec:Refresh()
	oLbx:Refresh()
	oDlg:Refresh()
	
Return( .t. )


/*====================================================================================\
|Programa  | fpesc            | Autor | GIOVANI.ZAGO             | Data | 13/08/2013  |
|=====================================================================================|
|Descrição |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | fpesc                                                                    |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
Static Function fpesc(_cXPesc)
	*-----------------------------*
	local b
	Local _lRex := .f.
	
	If !(Empty(Alltrim(_cXPesc)))
		for b:= 1 to Len(aVetor)
			
			If UPPER(ALLTRIM(aVetor[b,2]))   =  UPPER(ALLTRIM(_cXPesc) )
				_lRex:= .T.
			EndIf
			
		next b
		
	Else
		_lRex:= .T.
	EndIf
	If _lRex .And. !(Empty(Alltrim(_cXPesc)))
		oLbx:nAt:= aScan(aVetor, {|x| Upper(AllTrim(x[2])) == UPPER(Alltrim(_cXPesc))})
	EndIf
	oLbx:Refresh()
	oDlg:Refresh()
	opesc:Refresh()
Return( _lRex )

/*====================================================================================\
|Programa  | EdLista          | Autor | GIOVANI.ZAGO             | Data | 13/08/2013  |
|=====================================================================================|
|Descrição |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | EdLista                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
Static Function EdLista()
	*-----------------------------*
	Local b
	
	_nMeta:=0
	aVetor[oLbx:nAt,1]	:= !aVetor[oLbx:nAt,1]
	
	for b:= 1 to Len(aVetor)
		
		If aVetor[b,1]
			_nMeta++
		EndIf
		
	next b
	
	oVlrSelec:Refresh()
	oLbx:Refresh()
	oDlg:Refresh()
Return ()
/*====================================================================================\
|Programa  | GeraPed          | Autor | GIOVANI.ZAGO             | Data | 13/08/2013  |
|=====================================================================================|
|Descrição |   msexecauto                                                             |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | GeraPed                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
Static Function GeraPed( )
	*-----------------------------*
	Local axVetor := {}
	Local _nDifal := 0
	Local _nFECAP := 0
	Local K := 0
	
	For k:=1 To Len(aVetor)
		If aVetor[k,1]	 .And. aVetor[k,10 ] <> 0
			DbSelectArea("SF2")
			SF2->(DbGoTo(aVetor[k,10 ]))
			If aVetor[k,10 ]   = SF2->(RECNO())
				
				DbSelectArea("SF3")
				SF3->(DbSetOrder(5))
				If SF3->(DbSeek( SF2->(F2_FILIAL+F2_SERIE+F2_DOC+F2_CLIENTE+F2_LOJA) ))
					If  SF2->F2_ICMSRET = 0 .And.   SF3->F3_DIFAL <> 0
												
						_nDifal:= U_StDifal(SF2->(F2_FILIAL+F2_SERIE+F2_DOC+F2_CLIENTE+F2_LOJA))
						
						If _nDifal > 0
							aadd(axVetor ,{;
								"DIF",;
								padr(alltrim(SF2->F2_EST+Right( AllTrim( SF2->F2_DOC ) , 6 )),9,' ') ,;
								"TX "	,;
								"ESTADO",;
								"00",;
								dDataBase,;
								dDataBase,;
								DataValida(dDataBase),;
								_nDifal,;
								_nDifal,;
								"23002     ",;
								"ICMS DIFER. ALIQUOTA REF A NF "+Right( AllTrim( SF2->F2_DOC ) , 6 )+" UF "+SF2->F2_EST	 ,;
								"Titulo Gerado por Rotina Automatica. Usuario: "+cusername+" - Data: "+dtoc(date())+" - Hora: "+Time() ,;
								SF2->(RECNO()),;
								'Emen.Constit.nº87/2015(EC 87015)',;
								'B'})
						EndIf
						
						
						DbSelectArea("SD2")
						SD2->(DbSetOrder(3))
						
						If SD2->(DbSeek(xFilial("SD2")+SF2->(F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA)))
							While SD2->(!EOF()) .and. SD2->(D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA) == xFilial("SD2")+SF2->(F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA)
								_nFECAP+= 	SD2->D2_VFCPDIF
								SD2->(DbSkip())
							End
							
							If _nFECAP > 0
								aadd(axVetor ,{;
									"FEC",;
									padr(alltrim(SF2->F2_EST+Right( AllTrim( SF2->F2_DOC ) , 6 )),9,' ') ,;
									"TX "	,;
									"ESTADO",;
									"00",;
									dDataBase,;
									dDataBase,;
									DataValida(dDataBase),;
									_nFECAP,;
									_nFECAP,;
									"23002     ",;
									"ICMS FCP DIFAL REF A NF "+Right( AllTrim( SF2->F2_DOC ) , 6 )+" UF "+SF2->F2_EST	 ,;
									"Titulo Gerado por Rotina Automatica. Usuario: "+cusername+" - Data: "+dtoc(date())+" - Hora: "+Time() ,;
									SF2->(RECNO()),;
									' ',;
									'B'})
								_nFECAP := 0
								
							EndIf
						EndIf
						
					EndIf
				EndIf
				
				
				If  SF2->F2_ICMSRET <> 0
					aadd(axVetor ,{;
						"FIN",;
						padr(alltrim(SF2->F2_EST+Right( AllTrim( SF2->F2_DOC ) , 6 )),9,' ') ,;
						"TX "	,;
						"ESTADO",;
						"00",;
						dDataBase,;
						dDataBase,;
						DataValida(dDataBase),;
						SF2->F2_ICMSRET,;
						SF2->F2_ICMSRET,;
						"23002     ",;
						"ICMS ST REF A NF "+Right( AllTrim( SF2->F2_DOC ) , 6 )+" UF "+SF2->F2_EST	 ,;
						"Titulo Gerado por Rotina Automatica. Usuario: "+cusername+" - Data: "+dtoc(date())+" - Hora: "+Time() ,;
						SF2->(RECNO()),;
						' ',;
						'3'})
					
					DbSelectArea("SD2")
					SD2->(DbSetOrder(3))
					
					If SD2->(DbSeek(xFilial("SD2")+SF2->(F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA)))
						While SD2->(!EOF()) .and. SD2->(D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA) == xFilial("SD2")+SF2->(F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA)
							_nFECAP+= 	SD2->D2_VFCPDIF
							SD2->(DbSkip())
						End
						
						If _nFECAP > 0
							aadd(axVetor ,{;
								"FEC",;
								padr(alltrim(SF2->F2_EST+Right( AllTrim( SF2->F2_DOC ) , 6 )),9,' ') ,;
								"TX "	,;
								"ESTADO",;
								"00",;
								dDataBase,;
								dDataBase,;
								DataValida(dDataBase),;
								_nFECAP,;
								_nFECAP,;
								"23002     ",;
								"ICMS FCP DIFAL REF A NF "+Right( AllTrim( SF2->F2_DOC ) , 6 )+" UF "+SF2->F2_EST	 ,;
								"Titulo Gerado por Rotina Automatica. Usuario: "+cusername+" - Data: "+dtoc(date())+" - Hora: "+Time() ,;
								SF2->(RECNO()),;
								' ',;
								'B'})
							_nFECAP := 0
							Processa({|| u_STRECGUIA(aVetor)},'Gerando Titulo(Guia de Recolhimento')
						EndIf
					EndIf
				EndIf
			EndIf
		EndIf
	Next k
	Processa({|| u_STRECGUIA(axVetor)},'Gerando Titulo(Guia de Recolhimento)')
Return ()



/*====================================================================================\
|Programa  | STFAT35B            | Autor | GIOVANI.ZAGO          | Data | 14/01/2013  |
|=====================================================================================|
|Descrição |  Troca de Vendedor                                                       |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STFAT35B                                                                 |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
User Function STLIMGUIA()
	u_LibBlqNF()
Return()

/*/{Protheus.doc} xLibBloq
@description
Rotina que fará a liberação
Ticket: 20210318004396
 
Fontes envolvidos no chamado
--------------------------------
SF2460I
STFATROM
STGERGUIA
STFATJOB
--------------------------------
Criado campo: F2_XPIN - C - 1

@type function
@version  
@author Valdemir Jose
@since 04/06/2021
@return return_type, return_description
u_LibBlqNF
/*/
User Function LibBlqNF()
	//Declarar variáveis locais
	Local aAreaSF2 := GetArea()
	Local oColumn
	Local nX
	Local lMarcar  := .F.
	Local aSeek    := getSeek()
	Local bKeyF12  := {||  oBrowse:SetInvert(.F.), oBrowse:Refresh(), oBrowse:GoTop(.T.)} //Programar a tecla F12
	//Declarar variáveis privadas
	Private cArqTrb   := ""
	Private oBrowse   := Nil
	Private cCadastro := "Liberação de Notas"
	Private aRotina   := Menudef() 				//Se for criar menus via MenuDef

	//Agora iremos usar a classe FWMarkBrowse
	Processa( {|| AbreTmpQry() },"Informativo","Filtrando dados de liberação")
	oBrowse:= FWMarkBrowse():New()
	oBrowse:SetDescription(cCadastro) 		//Titulo da Janela
	oBrowse:SetParam(bKeyF12) 				// Seta tecla F12
	oBrowse:SetAlias("TRB") 				//Indica o alias da tabela que será utilizada no Browse
	oBrowse:SetFieldMark("TR_OK") 			//Indica o campo que deverá ser atualizado com a marca no registro
	oBrowse:oBrowse:SetDBFFilter(.T.)
	oBrowse:oBrowse:SetUseFilter(.T.) 		//Habilita a utilização do filtro no Browse
	oBrowse:oBrowse:SetFixedBrowse(.T.)
	oBrowse:SetWalkThru(.F.) 				//Habilita a utilização da funcionalidade Walk-Thru no Browse
	oBrowse:SetAmbiente(.T.) 				//Habilita a utilização da funcionalidade Ambiente no Browse
	oBrowse:SetTemporary() 					//Indica que o Browse utiliza tabela temporária
	oBrowse:oBrowse:SetSeek(.T.,aSeek) 		//Habilita a utilização da pesquisa de registros no Browse
	oBrowse:oBrowse:SetFilterDefault("") 	//Indica o filtro padrão do Browse

	//Permite adicionar legendas no Browse
	//oBrowse:AddLegend("TR_ST=='N'","GREEN"     ,"Usuários Liberados")
	//oBrowse:AddLegend("TR_ST=='S'","RED"       ,"Usuários Bloqueados")

	//Adiciona uma coluna no Browse em tempo de execução
	oBrowse:SetColumns(LbBlqTit("TR_TIPOL","Tipo Lib" ,02,"@!",1,010,0))
	oBrowse:SetColumns(LbBlqTit("TR_NOTA" ,"Nota" 	  ,03,"@!",1,010,0))
	oBrowse:SetColumns(LbBlqTit("TR_SERIE","Serie" 	  ,04,"@!",1,005,0))
	oBrowse:SetColumns(LbBlqTit("TR_EMISS","Emissão"  ,05,"@!",1,010,0))
	oBrowse:SetColumns(LbBlqTit("TR_CLIEN","Cliente"  ,06,"@!",1,010,0))
	oBrowse:SetColumns(LbBlqTit("TR_LOJA" ,"Loja" 	  ,07,"@!",1,005,0))
	oBrowse:SetColumns(LbBlqTit("TR_NOME" ,"Nome" 	  ,08,"@!",1,040,0))
	oBrowse:SetColumns(LbBlqTit("TR_CIDAD","Cidade"   ,09,"@!",1,020,0))
	oBrowse:SetColumns(LbBlqTit("TR_ESTAD","Estado"   ,10,"@!",1,005,0))
	oBrowse:SetColumns(LbBlqTit("TR_VALOR","Valor"    ,11,"@E 999,999,999.99",2,20,0))

	//Adiciona botoes na janela
	oBrowse:AddButton("Processar"    , { || u_xProces2()},,,, .F., 2 )
//        oBrowse:AddButton("Detalhes"     , { || MsgRun('Coletando dados de usuário(s)','Relatório',{|| U_RCFG0005() }) },,,, .F., 2 )
//        oBrowse:AddButton("Legenda"      , { || MCFG006LEG()},,,, .F., 2 )

	//Indica o Code-Block executado no clique do header da coluna de marca/desmarca
	oBrowse:bAllMark := { || FWMsgRun(,{|| LbInvert(oBrowse:Mark(), lMarcar := !lMarcar )},"Informativo","Aguarde, Selecionando registros"), oBrowse:Refresh(.T.)  }

	//Método de ativação da classe
	oBrowse:Activate()

	oBrowse:oBrowse:Setfocus() //Seta o foco na grade

	If !Empty(cArqTrb)
		Ferase(cArqTrb+GetDBExtension())
		Ferase(cArqTrb+OrdBagExt())
		cArqTrb := ""
		TRB->(DbCloseArea())
	Endif

	RestArea( aAreaSF2 )

Return



/*/{Protheus.doc} AbreTmpQry
description
Rotina para montar dados
@type function
@version  
@author Valdemir Jose
@since 04/06/2021
@return return_type, return_description
/*/
Static Function AbreTmpQry()
	Local cRET     := getNextAlias()
	Local cQry     := ""
	Local cEST     := ""
	Local cCid     := ""
	Local bBlock   := {|| MntTab() }
	Local cTipoLib := ""
	Local nTotReg  := 0
	Local aEstCid  := {;
		{'Rio Preto da Eva','AM'},;
		{'Manaus','AM'},;
		{'Presidente Figueiredo','AM'},;
		{'Tabatinga','AM'},;
		{'Boa Vista','RR'},;
		{'Bonfim','RR'},;
		{'Pacaraima','RR'},;
		{'Macapa','AP'},;
		{'Santana','AP'},;
		{'Cruzeiro do Sul','AC'},;
		{'Brasileia','AC'},;
		{'Epitaciolandia','AC'},;
		{'Guajara-mirim','RO'}}

	aEval(aEstCid, {|X| cEST += Upper(X[2]+",") })
	aEval(aEstCid, {|X| cCid += UPPER(X[1]+",") })
	cEST := Substr(cEST,1,Len(cEST)-1)
	cCid := Substr(cCid,1,Len(cCid)-1)
	Eval(bBlock)

	cQry := "SELECT " + CRLF
	cQry += "    SA1.A1_NOME NOME, SA1.A1_MUN MUNIC, SA1.A1_EST ESTADO, SF2.R_E_C_N_O_ REG  " + CRLF
	cQry += "FROM " + RETSQLNAME("SF2") + " SF2 " + CRLF
	cQry += "INNER JOIN " + RETSQLNAME('SA1') + " SA1 " + CRLF
	cQry += "ON SA1.A1_COD=SF2.F2_CLIENTE AND SA1.A1_LOJA=SF2.F2_LOJA AND SA1.D_E_L_E_T_ = ' ' " + CRLF
	cQry += "WHERE SF2.D_E_L_E_T_ = ' ' " + CRLF
	cQry += " AND F2_FILIAL='" + XFILIAL("SF2") + "' " + CRLF
	cQry += " AND ((F2_XDECLA='S'" + CRLF
	cQry += " OR F2_XPIN='S'"  + CRLF
	cQry += " OR F2_XGUIA IN('1','3') ) ) " + CRLF
	//cQry += " OR (SA1.A1_EST IN "+FORMATIN(cEST,",")+" " + CRLF
	//cQry += " AND  SA1.A1_MUN IN "+FORMATIN(cCid,",")+" ))"
	cQry += "ORDER BY F2_DOC, F2_SERIE, F2_EMISSAO" + CRLF

	IF SELECT(cRET) > 0
		(cRET)->( dbCloseArea() )
	ENDIF

	CursorWait()

	tcQuery cQry New Alias (cRET)
	dbSelectArea(cRET)
	count to nTotReg

	ProcRegua( nTotReg )
	(cRET)->( dbGotop() )
	ProcessMessages()

	While (cRET)->( !Eof() )
		incproc()
		cTipoLib := ""
		SF2->( dbGoto((cRET)->REG) )

		// Verifico em quais situação a nota se enquadra
		if !Empty(SF2->F2_XGUIA)
			cTipoLib += "GUIA"
		endif
		if !Empty(SF2->F2_XDECLA)
			IF !EMPTY(cTipoLib) .and. (Right(Alltrim(cTipoLib),1) !="/")
				cTipoLib += "/"
			ENDIF
			cTipoLib += "DECLA"
		endif
		if (SF2->F2_XPIN=="S")
			IF !EMPTY(cTipoLib) .and. (Right(Alltrim(cTipoLib),1) !="/")
				cTipoLib += "/"
			ENDIF
			cTipoLib += "PIN"
		endif

		RecLock("TRB",.t.)
		TRB->TR_OK    := " "
		TRB->TR_TIPOL := cTipoLib
		TRB->TR_NOTA  := SF2->F2_DOC
		TRB->TR_SERIE := SF2->F2_SERIE
		TRB->TR_EMISS := SF2->F2_EMISSAO
		TRB->TR_CLIEN := SF2->F2_CLIENTE
		TRB->TR_LOJA  := SF2->F2_LOJA
		TRB->TR_NOME  := (cRET)->NOME
		TRB->TR_CIDAD := (cRET)->MUNIC
		TRB->TR_ESTAD := (cRET)->ESTADO
		TRB->TR_VALOR := SF2->F2_VALBRUT
		TRB->TR_RECNO := (cRET)->REG
		MsUnLock()

		(cRET)->( dbSkip() )
	EndDo

	CursorArrow()

Return

/*/{Protheus.doc} MntTab
description
Rotina para Montar Tabela Temporaria
@type function
@version  
@author Valdemir Jose
@since 04/06/2021
@return return_type, return_description
/*/
Static Function MntTab()
	Local aCampos  := {}
	Local aColumns := {}
	Local cArqTrb
	Local cIndice1 := ""
	Local cIndice2 := ""
	Local cIndice3 := ""
	Local cIndice4 := ""

	//Criar a tabela temporária
	AAdd(aCampos,{"TR_OK"   ,"C",002,0})      // Este campo será usado para marcar/desmarcar
	AAdd(aCampos,{"TR_TIPOL","C",014,0})      // Tipo Guia/Declaração/PIN
	AAdd(aCampos,{"TR_NOTA" ,"C",009,0})
	AAdd(aCampos,{"TR_SERIE","C",003,0})
	AAdd(aCampos,{"TR_EMISS","D",010,0})
	AAdd(aCampos,{"TR_CLIEN","C",006,0})
	AAdd(aCampos,{"TR_LOJA" ,"C",002,0})
	AAdd(aCampos,{"TR_NOME" ,"C",050,0})
	AAdd(aCampos,{"TR_CIDAD","C",050,0})
	AAdd(aCampos,{"TR_ESTAD","C",002,0})
	AAdd(aCampos,{"TR_VALOR","N",014,2})
	AAdd(aCampos,{"TR_RECNO","N",014,0})

	If (Select("TRB") <> 0)
		dbSelectArea("TRB")
		TRB->(dbCloseArea())
	Endif

	cArqTrb := CriaTrab(aCampos,.T.)

	//Criar indices
	cIndice1 := Alltrim(CriaTrab(,.F.))
	cIndice2 := cIndice1
	cIndice1 := Left(cIndice1,5) + Right(cIndice1,2) + "A"
	cIndice2 := Left(cIndice2,5) + Right(cIndice2,2) + "B"

	//Se indice existir excluir
	If File(cIndice1+OrdBagExt())
		FErase(cIndice1+OrdBagExt())
	EndIf
	If File(cIndice2+OrdBagExt())
		FErase(cIndice2+OrdBagExt())
	EndIf

	dbUseArea(.T.,,cArqTrb,"TRB",Nil,.F.)

	IndRegua("TRB", cIndice1, "TR_NOTA+TR_SERIE" ,,, "Indice Nota+Serie...")
	IndRegua("TRB", cIndice2, "TR_NOME",,, "Indice Nome...")

	dbClearIndex()
	dbSetIndex(cIndice1+OrdBagExt())
	dbSetIndex(cIndice2+OrdBagExt())

Return





User Function StDifal(_cQuer)

	Local cQuery     := ''
	Local cAliasLif  := 'DIFAL'
	Local _nRet       := 0

	cQuery := " SELECT SUM(F3_DIFAL)
	cQuery += ' "DIFAL"
	// Valdemir rabelo Ticket: 20220113001019 18/01/2022
	cQuery += " FROM "+RetSqlName("SF3")+" " + CRLF

	cQuery += " WHERE  F3_FILIAL||F3_SERIE||F3_NFISCAL||F3_CLIEFOR||F3_LOJA = '"+_cQuer+"'
	cQuery += " AND D_E_L_E_T_ = ' '



	cQuery := ChangeQuery(cQuery)


	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif,.T.,.T.)

	dbSelectArea(cAliasLif)
	(cAliasLif)->(dbgotop())
	If  Select(cAliasLif) > 0

		_nRet:= (cAliasLif)->DIFAL

	EndIf

Return(_nRet)

/*/{Protheus.doc} LbBlqTit
description
Rotina para criar as colunas do grid
@type function
@version  
@author Valdemir Jose
@since 04/06/2021
@param cCampo, character, param_description
@param cTitulo, character, param_description
@param nArrData, numeric, param_description
@param cPicture, character, param_description
@param nAlign, numeric, param_description
@param nSize, numeric, param_description
@param nDecimal, numeric, param_description
@return return_type, return_description
/*/
Static Function LbBlqTit(cCampo,cTitulo,nArrData,cPicture,nAlign,nSize,nDecimal)
	Local aColumn
	Local bData     := {||}
	Default nAlign     := 1
	Default nSize     := 20
	Default nDecimal:= 0
	Default nArrData:= 0

	If nArrData > 0
		bData := &("{||" + cCampo +"}") //&("{||oBrowse:DataArray[oBrowse:At(),"+STR(nArrData)+"]}")
	EndIf

    /* Array da coluna
    [n][01] Título da coluna
    [n][02] Code-Block de carga dos dados
    [n][03] Tipo de dados
    [n][04] Máscara
    [n][05] Alinhamento (0=Centralizado, 1=Esquerda ou 2=Direita)
    [n][06] Tamanho
    [n][07] Decimal
    [n][08] Indica se permite a edição
    [n][09] Code-Block de validação da coluna após a edição
    [n][10] Indica se exibe imagem
    [n][11] Code-Block de execução do duplo clique
    [n][12] Variável a ser utilizada na edição (ReadVar)
    [n][13] Code-Block de execução do clique no header
    [n][14] Indica se a coluna está deletada
    [n][15] Indica se a coluna será exibida nos detalhes do Browse
    [n][16] Opções de carga dos dados (Ex: 1=Sim, 2=Não)
    */
	aColumn := {cTitulo,bData,,cPicture,nAlign,nSize,nDecimal,.F.,{||.T.},.F.,{||.T.},NIL,{||.T.},.F.,.F.,{}}
Return {aColumn}

/*/{Protheus.doc} LbInvert
Rotina  para marcar/desmarcar todos os registros do grid
description
@type function
@version  
@author Valdemir Jose
@since 04/06/2021
@param cMarca, character, param_description
@param lMarcar, logical, param_description
@return return_type, return_description
/*/
Static Function LbInvert(cMarca, lMarcar)
	Local cAlias := 'TRB'
	Local aArea  := (cAlias)->( GetArea() )

	dbSelectArea(cAlias)
	(cAlias)->( dbGoTop() )
	While !(cAlias)->( Eof() )
		RecLock( (cAlias), .F. )
		(cAlias)->TR_OK := IIf( lMarcar, cMarca, '  ' )
		MsUnlock()
		(cAlias)->( dbSkip() )
	EndDo

	RestArea( aArea )

Return .T.



/*/{Protheus.doc} MenuDef
description
Rotina para criar os botões
@type function
@version  
@author Valdemir Jose
@since 04/06/2021
@return return_type, return_description
/*/
Static Function MenuDef()
	Local aRot := {}

	ADD OPTION aRot TITLE "Processar" ACTION "U_xProces2()"  OPERATION 6 ACCESS 0
	//ADD OPTION aRot TITLE "Detalhes"         ACTION "MsgRun('Coletando dados de usuário(s)','Relatório',{|| U_RCFG0005() })"  OPERATION 6 ACCESS 0
	//ADD OPTION aRot TITLE "Legenda"         ACTION ""  OPERATION 6 ACCESS 0

Return(Aclone(aRot))


User Function xProces2
	Processa( {|| xProcess()},"Aguarde","Processando Registros...")
	Processa( {|| AbreTmpQry() },"Informativo","Atualizando Dados")
Return

/*/{Protheus.doc} getSeek
description
Rotina que irá retornar o seek
@type function
@version  
@author Valdemir Jose
@since 04/06/2021
@return return_type, return_description
/*/
Static Function getSeek()
	Local aRET := {}

	aAdd(aRET,{"Nota+Serie"    ,{{"","C",012,0,"Nota+Serie"    ,"@!"}} } )
	aAdd(aRET,{"Nome"          ,{{"","C",050,0,"Nome"    ,"@!"}} } )

Return aRET

/*/{Protheus.doc} xProcess
description
Rotina que fará o processamento
@type function
@version  
@author Valdemir Jose
@since 04/06/2021
@return return_type, return_description
/*/
Static Function xProcess()
	Local nTotReg := 0
	Local aAreaT  := GetArea()

	DbSelectArea("SF2")
	SF2->(DbSetOrder(1))
	dbSelectArea("TRB")
	count to nTotReg

	ProcRegua( nTotReg )
	ProcessMessages()
	TRB->( dbGotop() )
	While TRB->(! Eof() )
		IncProc()
		if !Empty(TRB->TR_OK)
			SF2->( dbGoto(TRB->TR_RECNO) )
			SF2->(RecLock("SF2",.F.))
			SF2->F2_XGUIA  := ""
			SF2->F2_XDECLA := ""
			SF2->F2_XPIN   := ""
			SF2->(MsUnlock())
			SF2->(DbCommit())
		Endif
		TRB->( dbSkip() )
	EndDo

	RestArea( aAreaT )

Return

/*/{Protheus.doc} AtuGrid
Rotina para Atualizar o Grid
Chamado:20220113001019
@type function
@version  25
@author Valdemir Rabelo
@since 11/02/2022
@return variant, Nil
/*/
Static Function AtuGrid()

	oLbx:SetArray( aVetor )
	oLbx:bLine := {|| {Iif(	aVetor[oLbx:nAt,1],oOk,oNo),;
							aVetor[oLbx:nAt,2],;
							aVetor[oLbx:nAt,3],;
							aVetor[oLbx:nAt,4],;
							aVetor[oLbx:nAt,5],;
							aVetor[oLbx:nAt,6],;
							aVetor[oLbx:nAt,7],;
							aVetor[oLbx:nAt,8],;
							aVetor[oLbx:nAt,9],;
							aVetor[oLbx:nAt,10]	}}
    oLbx:Refresh()
Return 
