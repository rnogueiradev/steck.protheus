
#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "STR.CH"
#DEFINE CR    chr(13)+chr(10)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    STTNTIMPORT  Autor � Giovani.Zago       � Data �  04/08/15   ���
�������������������������������������������������������������������������͹��
���Descri��o � TNT								                          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
*----------------------------------------*
User Function STTNTIMPORT()
	*----------------------------------------*
	
	Local oBrowse
	Private _cAlias	:= "ZZZ"
	Private _cRot	:= "STTNTIMPORT"
	Private _cTit	:= "Rotas TNT"
	Private aRotina := MenuDef()
	oBrowse:= FWMBrowse():New()
	oBrowse:SetAlias(_cAlias )			// Alias da tabela utilizada
	//oBrowse:SetMenuDef(_cRot)			// Nome do fonte onde esta a fun��o MenuDef
	oBrowse:SetDescription(_cTit)		// Descri��o do browse
	
	/*
	oBrowse:AddLegend("DTOS(ZZJ_DATA) >= '"+DTOs(DATE())+ "' .and. Empty(Alltrim(ZZJ_CANCEL))", "GREEN", "PRETO") //"Recebido"
	oBrowse:AddLegend("DTOS(ZZJ_DATA) < '"+DTOs(DATE()) + "' .and. Empty(Alltrim(ZZJ_CANCEL)) ", "RED"  , STR0003) //"Bloqueado"
	oBrowse:AddLegend("!Empty(Alltrim(ZZJ_CANCEL))", "BLUE" , STR0005) //"Aprovado pelo Usu�rio"
	
	// oBrowse:SetFilterDefault(" C7_QUANT > C7_QUJE .And. C7_RESIDUO == ' ' .And. C7_FILIAL = '02'" )
	*/
	oBrowse:Activate()
Return(Nil)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    MenuDef  	  Autor � Giovani.Zago       � Data �  04/08/15   ���
�������������������������������������������������������������������������͹��
���Descri��o � MenuDef							                          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
*------------------------*
Static Function MenuDef()
	*------------------------*
	
	Local aRotina := {}
	
	//-------------------------------------------------------
	// Adiciona bot�es do browse
	//-------------------------------------------------------
	ADD OPTION aRotina TITLE "Pesquisar"   	ACTION "AxPesqui"        	 OPERATION 1 ACCESS 0 //"Pesquisar"
	ADD OPTION aRotina TITLE "Visualizar"  	ACTION "VIEWDEF.STTNTIMPORT" OPERATION 2 ACCESS 0 //"Visualizar"
	ADD OPTION aRotina TITLE "Incluir"   	ACTION "VIEWDEF.STTNTIMPORT" OPERATION 3 ACCESS 0 //"Incluir"
	ADD OPTION aRotina TITLE "Alterar"   	ACTION "VIEWDEF.STTNTIMPORT" OPERATION 4 ACCESS 0 //"Alterar"
	ADD OPTION aRotina TITLE "Excluir"   	ACTION "VIEWDEF.STTNTIMPORT" OPERATION 5 ACCESS 0 //"Excluir"
	//ADD OPTION aRotina TITLE "Facilitador"  ACTION "VIEWDEF.STTNTIMPORT" OPERATION 6 ACCESS 0 //"Facilitador"
	//ADD OPTION aRotina TITLE "Ambiente"   	ACTION "VIEWDEF.STTNTIMPORT" OPERATION 7 ACCESS 0 //"Ambiente"
	ADD OPTION aRotina TITLE "Importar Rotas"   	ACTION "U_STZZZ()" 			 OPERATION 11 ACCESS 0 //"Importar"
	//ADD OPTION aRotina TITLE "Importar Rotas"   	ACTION "U_STZZZ()" 			 OPERATION 11 ACCESS 0 //"Importar"
	
Return aRotina

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    ModelDef	  Autor � Giovani.Zago       � Data �  04/08/15   ���
�������������������������������������������������������������������������͹��
���Descri��o � ModelDef							                          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
*-------------------------*
Static Function ModelDef()
	*-------------------------*
	
	Local oModel
	Local oStructZZJ := FWFormStruct(1,_cAlias)
	
	
	// cID     Identificador do modelo
	// bPre    Code-Block de pre-edi��o do formul�rio de edi��o. Indica se a edi��o esta liberada
	// bPost   Code-Block de valida��o do formul�rio de edi��o
	// bCommit Code-Block de persist�ncia do formul�rio de edi��o
	// bCancel Code-Block de cancelamento do formul�rio de edi��o
	oModel := MPFormModel():New("STTNTIMPORT", /*bPre*/, /*bPost*/, /*bCommit*/, /*bCancel*/)
	// cId          Identificador do modelo
	// cOwner       Identificador superior do modelo
	// oModelStruct Objeto com  a estrutura de dados
	// bPre         Code-Block de pr�-edi��o do formul�rio de edi��o. Indica se a edi��o esta liberada
	// bPost        Code-Block de valida��o do formul�rio de edi��o
	// bLoad        Code-Block de carga dos dados do formul�rio de edi��o
	oModel:AddFields("STTNTIMPORT_ZZZ", Nil, oStructZZJ,/*bPre*/,/*bPost*/,/*bLoad*/)
	oModel:SetPrimaryKey({"ZZZ_CEPINI", "ZZZ_CEPFIM"})
	
	
	
	
Return oModel


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    ViewDef 	  Autor � Giovani.Zago       � Data �  04/08/15   ���
�������������������������������������������������������������������������͹��
���Descri��o � ViewDef							                          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
*-------------------------*
Static Function ViewDef()
	*-------------------------*
	
	Local oModel := FWLoadModel("STTNTIMPORT")
	Local oView  := Nil
	
	oView := FWFormView():New()
	// Objeto do model a se associar a view.
	oView:SetModel(oModel)
	// cFormModelID - Representa o ID criado no Model que essa FormField ir� representar
	// oStruct - Objeto do model a se associar a view.
	// cLinkID - Representa o ID criado no Model ,S� � necess�ri o caso estamos mundando o ID no View.
	oView:AddField( "STTNTIMPORT_ZZZ" , FWFormStruct(2,_cAlias), /*cLinkID*/ )	//
	// cID		  	Id do Box a ser utilizado
	// nPercHeight  Valor da Altura do box( caso o lFixPixel seja .T. � a qtd de pixel exato)
	// cIdOwner 	Id do Box Vertical pai. Podemos fazer diversas cria��es uma dentro da outra.
	// lFixPixel	Determina que o valor passado no nPercHeight � na verdade a qtd de pixel a ser usada.
	// cIDFolder	Id da folder onde queremos criar o o box se passado esse valor, � necess�rio informar o cIDSheet
	// cIDSheet     Id da Sheet(Folha de dados) onde queremos criar o o box.
	oView:CreateHorizontalBox( "MASTER" , 100,/*cIDOwner*/,/*lFixPixel*/,/*cIDFolder*/,/*cIDSheet*/ )
	// Associa um View a um box
	oView:SetOwnerView( "STTNTIMPORT_ZZZ" , "MASTER" )
	
Return oView
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    STTNTIMPORT  Autor � Giovani.Zago       � Data �  04/08/15   ���
�������������������������������������������������������������������������͹��
���Descri��o � TNT								                          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
*----------------------*
User Function STZZZ()
	*----------------------*
	Processa({|| ExcluiZZZ()} ,"Excluindo Rotas", "")
	Processa({|| Importacao()},"Importando Rotas", "")
Return
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    Importacao   Autor � Giovani.Zago       � Data �  04/08/15   ���
�������������������������������������������������������������������������͹��
���Descri��o � TNT								                          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
*----------------------*
Static Function ExcluiZZZ()
	*----------------------*
	Local _nRezzz:= 0
	Local _nRetzz:= 0
	
	
	DbSelectArea("ZZZ")
	ZZZ->(DbGoTop())
	_nRezzz := RECCOUNT()
	ProcRegua(_nRezzz)
	
	While ZZZ->(!Eof())
		_nRetzz++
		IncProc(cValToChar(_nRezzz-_nRetzz))
		RecLock('ZZZ',.F.)
		ZZZ->ZZZ_MEMO  	:= "Excluido"+ CR + cUserName + CR + dToc(dDatabase) + CR + Time()+ CR + CR
		ZZZ->(DbDelete())
		ZZZ->( MsUnLock())
		ZZZ->( DbCommit())
		ZZZ->(DBSKIP())
	END
	
Return()
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    Importacao   Autor � Giovani.Zago       � Data �  04/08/15   ���
�������������������������������������������������������������������������͹��
���Descri��o � TNT								                          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
*----------------------*
Static Function Importacao()
	*----------------------*
	Local cDiretorio	:= '\arquivos\XML_CTE\TNT'
	Local nCountFiles   := 0
	Local _nLin   		:= 0
	Local _nLiz   		:= 0
	Local _aBuffer      := {}
	Local aDirImpor     := {}
	Local cNomeArq      := ' '
	Private GFEFile     := GFEXFILE():New()
	
	
	aDirImpor := DIRECTORY(cDiretorio + "\*.TXT" )
	
	// Verifica se existe arquivos no diret�rio informado
	If Len(aDirImpor) == 0
		MsgAlert("Nenhum arquivo encontrado no diret�rio " + cDiretorio, "Aviso")
		Return
	Endif
	
	For nCountFiles := 1 To Len(aDirImpor)
		cNomeArq  	:= aDirImpor[nCountFiles][1]
		
		GFEFile:Clear()
		GFEFile:Open(cDiretorio + "\" + cNomeArq)
		While !GFEFile:FEof()
			_nLin++
			GFEFile:FNext()
		EndDo
		
		ProcRegua(_nLin)
		GFEFile:Clear()
		GFEFile:Open(cDiretorio + "\" + cNomeArq)
		While !GFEFile:FEof()
			_nLiz++
			IncProc(cValToChar(_nLin-_nLiz))
			cBuffer := GFEFile:Line()
			_aBuffer:= StrToKarr(cBuffer,'|')
			
			
			
			
			DbSelectArea("ZZZ")
			RecLock("ZZZ", .T.)
			
			
			ZZZ->ZZZ_FILIAL := xFilial("ZZZ")
			ZZZ->ZZZ_CEPINI := _aBuffer[01]
			ZZZ->ZZZ_CEPFIM := _aBuffer[02]
			ZZZ->ZZZ_ORIG 	:= _aBuffer[03]
			ZZZ->ZZZ_CODORI := _aBuffer[04]
			ZZZ->ZZZ_DEST 	:= _aBuffer[05]
			ZZZ->ZZZ_CODDES := _aBuffer[06]
			ZZZ->ZZZ_FLX01 	:= Iif(ValType(_aBuffer[07])= 'C',_aBuffer[07],' ')
			ZZZ->ZZZ_FLX02 	:= Iif(ValType(_aBuffer[08])= 'C',_aBuffer[08],' ')
			ZZZ->ZZZ_FLX03 	:= Iif(ValType(_aBuffer[09])= 'C',_aBuffer[09],' ')
			ZZZ->ZZZ_FLX04 	:= Iif(ValType(_aBuffer[10])= 'C',_aBuffer[10],' ')
			ZZZ->ZZZ_FLX05 	:= Iif(ValType(_aBuffer[11])= 'C',_aBuffer[11],' ')
			ZZZ->ZZZ_BACK 	:= Iif(ValType(_aBuffer[12])= 'C',_aBuffer[12],' ')
			ZZZ->ZZZ_MEMO  	:= "Incluido"+ CR + cUserName + CR + dToc(dDatabase) + CR + Time()+ CR + CR
			
			MsUnLock(" ZZZ")
			
			
			GFEFile:FNext()
			
		EndDo
		_nLin:=0
		_nLiz:=0
		
	Next nCountFiles
	
	
	
	
Return()
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    STFTPTNT     Autor � Giovani.Zago       � Data �  04/08/15   ���
�������������������������������������������������������������������������͹��
���Descri��o � TNT								                          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
*-------------------------*
User Function STFTPTNT()
	*-------------------------*
	
	Local cServidor := '200.248.69.56'
	Local cLogin    := 'steck'
	Local _cSenha   := "sftpSteck"
	Local cOrigem   := ' '
	Local cDestino  := '\arquivos\XML_CTE\TNT'
	Local cArqs     := 'TXT'
	Local n :=0
	
	FTPDisconnect()
	If !FTPConnect( cServidor, ,cLogin, _cSenha )
		APMsgInfo( 'Falha na conex�o!' )
	Else
		If FTPDirChange(cOrigem)
			aArqs := FTPDIRECTORY( cArqs )
			nArqsCopy := Len(aArqs)
			If Len(aArqs) = 0
				APMsgInfo( 'Nenhum arquivo encontrado no site, verificar arquivos locais' )
			Else
				For n := 1 to Len(aArqs)
					If !FTPDOWNLOAD(cDestino+aArqs[n][1], aArqs[n][1] )
						APMsgInfo( 'Problemas ao copiar arquivo '+ aArqs[n][1] )
					Else
						If !FTPERASE( aArqs[n][1] )
							APMsgInfo('Problemas ao apagar o arquivo ' + aArqs[n][1] )
						EndIf
					EndIf
				Next
			EndIf
		EndIf
	EndIf
	
Return ()
