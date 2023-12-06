#Include "Protheus.ch"

/*/{Protheus.doc} STzExcelXML
Classe para manipular e gerar arquivos XML do Excel
@author Atilio
@since 28/05/2015
@version 1.0
	@example
	//... Come�o do Exemplo ...
	oExcelXml := STzExcelXML():New(.F.)									//Inst�ncia o Objeto
	oExcelXml:SetOrigem("\xmls\teste_sb1.xml")						//Indica o caminho do arquivo Origem (que ser� aberto e clonado)
	oExcelXml:SetDestino(GetTempPath()+"yTst02.xml")					//Indica o caminho do arquivo Destino (que ser� gerado)
	oExcelXML:CopyTo("C:\TOTVS\copia.xml")								//Adiciona caminho de c�pia que ser� gerado ao montar o arquivo
	oExcelXML:AddExpression("#SB1-B1_COD", SB1->B1_COD)				//Adiciona express�o que ser� substitu�da
	oExcelXML:AddExpression("#SB1-B1_DESC", SB1->B1_DESC)			//Adiciona express�o que ser� substitu�da
	oExcelXML:AddExpression("#SB1-B1_TIPO", SB1->B1_TIPO)			//Adiciona express�o que ser� substitu�da
	oExcelXML:AddTabExcel("#TABELA_SB1", "SB1")						//Adiciona tabela din�mica
	oExcelXML:MountFile()												//Monta o arquivo
	oExcelXML:ViewSO()													//Abre o .xml conforme configura��o do Sistema Operacional,
																			// ou seja, se tiver Linux + LibreOffice ele ir� abrir
	//oExcelXML:View()													//Utilizar apenas se n�o for utilizado o m�todo ViewSO
																			// pois dessa forma � for�ado a abrir pelo Excel
	oExcelXml:Destroy(.F.)												//Destr�i os atributos do objeto
	oExcelXml:ShowMessage("")											//Testa demonstra��o de mensagem em branco
	//... Fim do Exemplo ...
	@see http://terminaldeinformacao.com/advpl/
/*/

Class STzExcelXML
	//Atributos
	Data cArqOrig
	Data cArqDest
	Data aExpre
	Data aTabelas
	Data aAreas
	Data aConOrig
	Data aConDest
	Data cArqCopy
	Data lShowMsg

	//M�todos
	Method New() CONSTRUCTOR
	Method SetOrigem()
	Method SetDestino()
	Method AddExpression()
	Method AddTabExcel()
	Method MountFile()
	Method CopyTo()
	Method View()
	Method ViewSO()
	Method Destroy()
	Method ShowMessage()
	Method RestAreaExcel()
EndClass

/*/{Protheus.doc} New
Construtor da classe STzExcelXML
@author Atilio
@since 28/05/2015
@version 1.0
	@param lShowAlerts, L�gico, Define se ser� mostrado alertas ou n�o nas chamadas dos m�todos
	@example
	oExcelXml := STzExcelXML:New(.T.)
/*/

Method New(lShowAlerts) Class STzExcelXML
	Default lShowAlerts := .F.

	//Definindo os atributos
	::cArqOrig	:= ""
	::cArqDest	:= ""
	::aTabelas	:= {}
	::aAreas	:= {}
	::aExpre	:= {}
	::aConOrig	:= {}
	::aConDest	:= {}
	::cArqCopy	:= ""
	::lShowMsg	:= lShowAlerts
Return Self

/*/{Protheus.doc} SetOrigem
Define o arquivo xml de origem que ser� lido
@author Atilio
@since 28/05/2015
@version 1.0
	@param cOrigem, Caracter, Arquivo origem a ser lido
	@return lRet, Retorna se foi poss�vel setar o arquivo de Origem
	@example
	oExcelXml:SetOrigem("\xmls\teste_1.xml")
/*/

Method SetOrigem(cOrigem) Class STzExcelXML
	Local lRet			:= .T.
	Local cMensagem	:= ""
	
	//Se n�o for arquivo XML
	If SubStr(cOrigem, Len(Alltrim(cOrigem))-3, Len(Alltrim(cOrigem))) != ".xml"
		lRet := .F.
		cMensagem :=	"[STzExcelXML][004] Arquivo de ORIGEM com extens�o inv�lida! "+;
						"Verificar! - SetOrigem('"+cOrigem+"') - "+dToC(dDataBase)+" "+Time()
		
	//Se o arquivo de origem existir, atualiza atributo
	ElseIf File(cOrigem)
		//Se no xml, encontrar a defini��o que � XML de Planilhas do Excel, arquivo OK
		If '<?mso-application progid="Excel.Sheet"?>' $ MemoRead(cOrigem)
			::cArqOrig	:= cOrigem
			
		//Sen�o, retorna erro
		Else
			lRet := .F.
			cMensagem :=	"[STzExcelXML][002] Arquivo de ORIGEM inv�lido! "+;
							"Verificar! - SetOrigem('"+cOrigem+"') - "+dToC(dDataBase)+" "+Time()
		EndIf
	
	//Sen�o, retorna erro
	Else
		lRet := .F.
		cMensagem :=	"[STzExcelXML][001] Arquivo de ORIGEM n�o foi encontrado! "+;
						"Verificar! - SetOrigem('"+cOrigem+"') - "+dToC(dDataBase)+" "+Time()
	EndIf
	
	//Mostrando mensagem caso tenha
	Self:ShowMessage(cMensagem)
Return lRet

/*/{Protheus.doc} SetDestino
Define o arquivo xml de destino que ser� gerado
@author Atilio
@since 23/06/2015
@version 1.0
	@param cDestino, Caracter, Arquivo que ser� gerado
	@param lSobrepoe, L�gico, Define se o arquivo ser� sobreposto (se j� existir)
	@return lRet, Retorna se foi poss�vel setar o arquivo de Destino
	@example
	oExcelXml:SetDestino("C:\Teste\teste.xml")
/*/

Method SetDestino(cDestino, lSobrepoe) Class STzExcelXML
	Local lRet			:= .T.
	Local cMensagem	:= ""
	Default lSobrepoe	:= .T.
	
	//Se n�o for arquivo XML
	If SubStr(cDestino, Len(Alltrim(cDestino))-3, Len(Alltrim(cDestino))) != ".xml"
		lRet := .F.
		cMensagem :=	"[STzExcelXML][005] Arquivo de DESTINO com extens�o inv�lida! "+;
						"Verificar! - SetDestino('"+cDestino+"') - "+dToC(dDataBase)+" "+Time()
						
	//Se n�o tiver em branco
	ElseIf !Empty(cDestino)
		::cArqDest	:= cDestino
		
		//Se o arquivo de Destino existir, atualiza atributo
		If File(cDestino)
			cMensagem :=	"[STzExcelXML][003] Arquivo de Destino j� existe! "+;
							"Verificar! - SetDestino('"+cDestino+"') - "+dToC(dDataBase)+" "+Time()
			
			//Se for para sobrepor, exclui o arquivo destino
			If lSobrepoe
				FErase(cDestino)
			EndIf
		EndIf
	EndIf
	
	//Mostrando mensagem caso tenha
	Self:ShowMessage(cMensagem)
Return lRet

/*/{Protheus.doc} AddExpression
Adiciona uma express�o para ser substitu�da dentro do arquivo
@author Atilio
@since 29/07/2015
@version 1.0
	@param cExpressao, Caracter, Express�o que ser� buscada dentro do arquivo xml
	@param xConteudo, Vari�vel, Conte�do que ir� substituir a express�o encontrada
	@example
	oExcelXML:AddExpression("#SB1-B1_COD", "Ok ok...")
/*/

Method AddExpression(cExpressao, xConteudo) Class STzExcelXML
	Local cMensagem	:= ""
	
	//Se tiver express�o
	If !Empty(cExpressao) .And. !("TABELA" $ cExpressao)
		aAdd(::aExpre, {cExpressao, xConteudo})
	
	//Sen�o
	Else
		cMensagem :=	"[STzExcelXML][013] Express�o em branco ou inv�lida n�o pode ser adicionada! "+;
						"Verificar! - AddExpression() - "+dToC(dDataBase)+" "+Time()+"... cExpressao: "+cExpressao+";"
	EndIf
	
	//Mostrando mensagem caso tenha
	Self:ShowMessage(cMensagem)
Return Nil

/*/{Protheus.doc} AddTabExcel
Adiciona tabela que ser� substitu�da no arquivo xml
@author Atilio
@since 29/07/2015
@version 1.0
	@param cNomeTab, Caracter, Nome da Tabela que ser� procurada no arquivo xml
	@param cAliasTab, Caracter, Alias do Protheus que ir� substituir os dados da tabela
	@example
	oExcelXML:AddTabExcel("#TABELA_SC6", "SC6")
/*/

Method AddTabExcel(cNomeTab, cAliasTab) Class STzExcelXML
	Local cMensagem	:= ""
	
	//Se tiver express�o
	If !Empty(cNomeTab) .And. !((cAliasTab)->(EoF()))
		aAdd(::aTabelas, {cNomeTab, cAliasTab})
		aAdd(::aAreas,  {cAliasTab, GetArea(cAliasTab)})
	
	//Sen�o
	Else
		cMensagem :=	"[STzExcelXML][014] Tabela em branco n�o pode ser adicionada! "+;
						"Verificar! - AddTabExcel() - "+dToC(dDataBase)+" "+Time()
	EndIf
	
	//Mostrando mensagem caso tenha
	Self:ShowMessage(cMensagem)
Return Nil

/*/{Protheus.doc} MountFile
M�todo que monta o arquivo para gera��o e gera uma c�pia se tiver
@author Atilio
@since 29/07/2015
@version 1.0
	@example
	oExcelXML:MountFile()
/*/

Method MountFile() Class STzExcelXML
	Local aArea		:= GetArea()
	Local nAtual		:= 0
	Local cContAux	:= ""
	Local nExpre		:= 0
	Local nTabel		:= 0
	Local nHdl			:= 0
	Local cMensagem	:= ""
	Local lPula		:= .F.
	Local aAux			:= {}
	Local nLinExpand	:= 0
	Local cMaskAux      := ""
	Local nPosCam
	Local nPosAux
	Local nTst
	Local nAltLin
	
	//Abre o arquivo para uso
	Ft_FUse(::cArqOrig)
	
	//Indo ao topo e percorrendo os registros para gerar os dados originais
	Ft_FGoTop()
	While !Ft_FEoF()
		aAdd(::aConOrig, Ft_FReadLn())
		Ft_FSkip()
	EndDo
	Ft_FUse()
	
	//Agora ser� gerado o conte�do destino (substituindo as express�es)
	For nAtual := 1 To Len(::aConOrig)
		cContAux := ::aConOrig[nAtual]
		lPula := Iif(Chr(13)+Chr(10) $ cContAux, .T., .F.)
		
		//Procurando express�es e substituindo
		For nExpre := 1 To Len(::aExpre)
			//Se encontrou a express�o, substitui a express�o pelo conte�do
			If ::aExpre[nExpre][1] $ cContAux
				cTipoCamp1 := ValType(::aExpre[nExpre][2])
				
				//Se for Data
				If cTipoCamp1 == 'D'
					if xConteud != nil
						::aExpre[nExpre][2] := dToC(xConteud)
					endif
				
				//Sen�o se for num�rico
				ElseIf cTipoCamp1 == 'N'
					cContAux := StrTran(cContAux, 'Type="String"', 'Type="Number"')
					
					//Se a m�scara tiver em branco
					If Empty(cMaskAux)
						::aExpre[nExpre][2] := cValToChar(::aExpre[nExpre][2])
						
					//Sen�o, transforma o campo
					Else
						::aExpre[nExpre][2] := Alltrim(Transform(::aExpre[nExpre][2], cMaskAux))
					EndIf
					
				//Sen�o se for caracter
				ElseIf cTipoCamp1 == 'C'
					//Se tiver m�scara
					If !Empty(cMaskAux)
						::aExpre[nExpre][2] := Alltrim(Transform(::aExpre[nExpre][2], cMaskAux))
					EndIf
				
				//Sen�o
				Else
					::aExpre[nExpre][2] := cValToChar(::aExpre[nExpre][2])
				EndIf
				
				cContAux := StrTran(cContAux, ::aExpre[nExpre][1], ::aExpre[nExpre][2])
			EndIf
		Next
		
		//Pegando a linha que define a quantidade de linhas da tabela
		If "expandedrowcount" $ Lower(cContAux)
			nLinExpand := nAtual
		EndIf
		
		//Pegando linha ativa e deixando como 1
		If "activerow" $ Lower(cContAux)
			cTagAux := SubStr(cContAux, At('<ActiveRow>', cContAux), Len(cContAux))
			cTagAux := SubStr(cContAux, 1, At('</ActiveRow>', cContAux)-1)
			cContAux := StrTran(cContAux, cTagAux, "<ActiveRow>1")
		EndIf
		
		//Pegando coluna ativa e deixando como 1
		If "activecol" $ Lower(cContAux)
			cTagAux := SubStr(cContAux, At('<ActiveCol>', cContAux), Len(cContAux))
			cTagAux := SubStr(cContAux, 1, At('</ActiveCol>', cContAux)-1)
			cContAux := StrTran(cContAux, cTagAux, "<ActiveCol>1")
		EndIf

		//Adicionando no array de destino
		aAdd(aAux, cContAux + Iif(lPula, "", Chr(13)+Chr(10)))
	Next
	
	//Agora ser� gerado o conte�do destino (substituindo as tabelas / queries)
	lTabEnc := .F.
	cNomTab := ""
	cAliTab := ""
	cCampoNov := ""
	nPosIni := 0
	nPosCam := 0
	nPosAux := 0
	nPosFin := 0
	aTabAux := {}
	nAMais  := 0
	For nAtual := 1 To Len(aAux)
		//Procurando express�es e substituindo
		For nTabel := 1 To Len(::aTabelas)
			If ::aTabelas[nTabel][1] $ aAux[nAtual] .And. !lTabEnc
				lTabEnc := .T.
				cNomTab := ::aTabelas[nTabel][1]
				cAliTab := ::aTabelas[nTabel][2]
				nPosIni := nAtual
				nPosCam := 0
				nPosFin := 0
			EndIf
			
			//Encontrando o primeiro campo
			If "%"+cAliTab+"-" $ aAux[nAtual] .And. nPosCam == 0 .And. cAliTab == ::aTabelas[nTabel][2]
				aTabAux := {}
			
				//Procurando a se��o ROW para identificar a linha inicial
				For nPosCam := nAtual To 1 Step -1
					If "<ROW" $ Upper(aAux[nPosCam])
						Exit
					EndIf
				Next
				
				//Procurando o fim da se��o ROW para copiar as linhas que ser�o copiadas
				For nPosAux := nPosCam To Len(aAux)
					aAdd(aTabAux, aAux[nPosAux])
					If "</ROW>" $ Upper(aAux[nPosAux])
						Exit
					EndIf
				Next
				
			EndIf
			
			//Procurando o final da tabela
			If cNomTab+"_FIM" $ aAux[nAtual] .And. cAliTab == ::aTabelas[nTabel][2]
				lTabEnc := .F.
				nPosFin := nAtual
				nAtual  := nPosIni
			EndIf
		Next
		
		//Se tiver final, acontecer� o processamento
		If nPosFin != 0 .And. nPosCam != 0 .And. nPosCam < nPosFin
			//Substitui o in�cio da tabela
			aAux[nPosIni] := StrTran(aAux[nPosIni], cNomTab, "")
			lFirst := .T.
			nContAux := 1
			
			//Enquanto a tabela tiver registros
			While ! (cAliTab)->(EoF())
				//Adicionando nova linha
				If !lFirst
					For nTst := 0 To Len(aTabAux)-1
						aSize(aAux, Len(aAux)+1)
						aIns(aAux, nPosCam+nTst)
						aAux[nPosCam+nTst] := aTabAux[nTst+1]
					Next
					nAMais++
					nPosFin += Len(aTabAux)
					nContAux++
				EndIf
			
				For nPosAux := nPosCam To nPosCam+Len(aTabAux)
					//Se tiver campo
					If "%"+cAliTab+"-" $ aAux[nPosAux]
						//Verificando se veio de query ou tempor�ria
						lCampoQuery := .F.
						If "QRY" $ cAliTab .Or. "SQL" $ cAliTab .Or. "TMP" $ cAliTab .Or. Len(cAliTab) >= 4 
							lCampoQuery := .T.
						EndIf
						
						//Pegando dados do campo
						cCampoNov := SubStr(aAux[nPosAux], At("%", aAux[nPosAux])+1, Len(aAux[nPosAux]))
						cCampoNov := SubStr(cCampoNov, 1, RAt("%", cCampoNov)-1)
						cCampoNov := StrTran(cCampoNov, cAliTab+"-", "")
						cMaskAux  := Iif(lCampoQuery, fMascara(cCampoNov), PesqPict(cAliTab, cCampoNov))
						xConteud  := &(cAliTab+"->"+cCampoNov+"")
						cTipoCamp := &("ValType("+cAliTab+"->"+cCampoNov+")")
						
						//Se for Data
						If cTipoCamp == 'D'
							xConteud := dToC(xConteud)
						
						//Sen�o se for num�rico
						ElseIf cTipoCamp == 'N'
							aAux[nPosAux] := StrTran(aAux[nPosAux], 'Type="String"', 'Type="Number"')
							
							//Se a m�scara tiver em branco
							If Empty(cMaskAux)
								xConteud := cValToChar(xConteud)
								
							//Sen�o, transforma o campo
							Else
								xConteud := Alltrim(Transform(xConteud, cMaskAux))
							EndIf
							
						//Sen�o se for caracter
						ElseIf cTipoCamp == 'C'
							//Se tiver m�scara
							If !Empty(cMaskAux)
								xConteud := Alltrim(Transform(xConteud, cMaskAux))
							EndIf
						
						//Sen�o
						Else
							xConteud := cValToChar(xConteud)
						EndIf
						
						aAux[nPosAux] := StrTran(aAux[nPosAux], "%"+cAliTab+"-"+cCampoNov+"%", xConteud)
					EndIf
				Next
				nPosCam := nPosCam+Len(aTabAux)
			
				lFirst := .F.
				(cAliTab)->(DbSkip())
			EndDo
			
			//Substitui o final da tabela
			aAux[nPosFin] := StrTran(aAux[nPosFin], cNomTab+"_FIM", "")
			
			//Somente sair� do la�o, ap�s encontrar o <row>
			nAtual := nPosFin + 1
			While ! ("</ROW>" $ Upper(aAux[nAtual]))
				nAtual++
			EndDo
			
			//Agora percorre as linhas abaixo e altera o conte�do dos �ndices
			For nAltLin := nAtual To Len(aAux)
				//Se encontrar linha de �ndice
				If "row ss:index=" $ Lower(aAux[nAltLin])
					cIndexExc := SubStr(Lower(aAux[nAltLin]), At('row ss:index=', Lower(aAux[nAltLin])), Len(aAux[nAltLin]))
					cIndexExc := StrTran(cIndexExc, 'row ss:index="', 'row ss:index=')
					cIndexExc := SubStr(cIndexExc, 1, At('"', cIndexExc)-1)
					nOrigInd := Val(SubStr(cIndexExc, At('=', cIndexExc)+1, Len(cIndexExc)))
					aAux[nAltLin] := StrTran(aAux[nAltLin], 'Row ss:Index="'+cValToChar(nOrigInd)+'"', 'Row ss:Index="'+cValToChar(nOrigInd+nAMais)+'"')
				EndIf
			Next
			
			//Zerando dados da tabela
			lTabEnc := .F.
			cNomTab := ""
			cAliTab := ""
			nPosIni := 0
			nPosCam := 0
			nPosFin := 0
		EndIf
	Next
	
	//Se tiver linha de expandido, atualiza para n�o houver falha na gera��o do Excel
	If nLinExpand > 0
		cExpand := SubStr(aAux[nLinExpand], At('ExpandedRowCount', aAux[nLinExpand]), Len(aAux[nLinExpand]))
		cExpand := StrTran(cExpand, 'ExpandedRowCount="', 'ExpandedRowCount=')
		cExpand := SubStr(cExpand, 1, At('"', cExpand)-1)
		nOrigem := Val(SubStr(cExpand, At('=', cExpand)+1, Len(cExpand)))
		aAux[nLinExpand] := StrTran(aAux[nLinExpand], 'ExpandedRowCount="'+cValToChar(nOrigem)+'"', 'ExpandedRowCount="'+cValToChar(nOrigem+nAMais)+'"')
	EndIf
	
	//Clonando o conte�do
	::aConDest := aClone(aAux)
	
	//Gerando agora o arquivo destino
	FErase(::cArqDest)
	nHdl := FCreate(::cArqDest)
	
	//Gerando o conte�do
	For nAtual := 1 To Len(::aConDest)
		fWrite(nHdl, ::aConDest[nAtual])
	Next
	FClose(nHdl)
	
	//Se tiver que gerar c�pia
	If !Empty(::cArqCopy)
		__CopyFile(::cArqDest, ::cArqCopy)
	EndIf
	
	//Mostrando mensagem
	cMensagem :=	"[STzExcelXML][015] Processamento finalizado! "+;
					"Verificar! - MountFile() - "+dToC(dDataBase)+" "+Time()
	Self:ShowMessage(cMensagem)
	
	RestArea(aArea)
Return Nil

/*/{Protheus.doc} CopyTo
Define o nome do arquivo de c�pia que ser� gerado no MountFile
@author Atilio
@since 23/06/2015
@version 1.0
	@example oExcelXml:CopyTo("C:\testes\novo.xml")
/*/

Method CopyTo(cCopia) Class STzExcelXML
	Local cMensagem	:= ""
	Local nRet			:= 0
	Default cCopia	:= ""
	
	//Se tiver em branco a c�pia
	If Empty(cCopia)
		cMensagem :=	"[STzExcelXML][011] Caminho do arquivo em c�pia est� em branco! "+;
						"Verificar! - View() - "+dToC(dDataBase)+" "+Time()
	Else
		::cArqCopy := cCopia
	EndIf
	
	//Mostrando mensagem caso tenha
	Self:ShowMessage(cMensagem)
Return Nil

/*/{Protheus.doc} View
Abre o arquivo XML utilizando a classe padr�o do Protheus
@author Atilio
@since 23/06/2015
@version 1.0
	@example oExcelXml:View()
/*/

Method View() Class STzExcelXML
	Local cMensagem	:= ""
	Local nRet			:= 0
	Local cArquivo	:= ::cArqDest
	Local oExcelApp
	
	//Somente se tiver registro
	If Len(::aConDest) > 0
		//Abrindo o excel e abrindo o arquivo xml
		oExcelApp := MsExcel():New() 			//Abre uma nova conex�o com Excel
		oExcelApp:WorkBooks:Open(cArquivo) 	//Abre uma planilha
		oExcelApp:SetVisible(.T.) 				//Visualiza a planilha
		oExcelApp:Destroy()						//Encerra o processo do gerenciador de tarefas
		
	//Sen�o, mostra mensagem de erro
	Else
		cMensagem :=	"[STzExcelXML][010] Arquivo n�o pode ser aberto, utilize o m�todo MountFile() para montar os dados! "+;
						"Verificar! - View() - "+dToC(dDataBase)+" "+Time()
	EndIf
	
	//Mostrando mensagem caso tenha
	Self:ShowMessage(cMensagem)
Return Nil


/*/{Protheus.doc} ViewSO
Abre o arquivo XML conforme prefer�ncias do Sistema Operacional
@author Atilio
@since 23/06/2015
@version 1.0
	@example oExcelXml:ViewSO()
/*/

Method ViewSO() Class STzExcelXML
	Local cMensagem	:= ""
	Local nRet			:= 0
	Local cAbsoluto	:= ::cArqDest
	Local cDiretorio	:= SubStr(cAbsoluto, 1, RAt("\",cAbsoluto))
	Local cArquivo	:= SubStr(cAbsoluto, RAt("\",cAbsoluto)+1, Len(cAbsoluto))
	
	//Somente se tiver registro
	If Len(::aConDest) > 0
		//Tentando abrir o objeto
		nRet := ShellExecute("open", cArquivo, "", cDiretorio, 1)
		
		//Se houver algum erro
		If nRet <= 32
			cMensagem :=	"[STzExcelXML][008] Arquivo n�o pode ser aberto! "+;
							"Verificar! - ViewSO() - "+dToC(dDataBase)+" "+Time()
		EndIf 
		
	//Sen�o, mostra mensagem de erro
	Else
		cMensagem :=	"[STzExcelXML][009] Arquivo n�o pode ser aberto, utilize o m�todo MountFile() para montar os dados! "+;
						"Verificar! - ViewSO() - "+dToC(dDataBase)+" "+Time()
	EndIf
	
	//Mostrando mensagem caso tenha
	Self:ShowMessage(cMensagem)
Return Nil

/*/{Protheus.doc} Destroy
M�todo que zera os atributos do objeto instanciando, caso ele seja reutilizado no fonte
@author Atilio
@since 23/06/2015
@version 1.0
	@param lShowAlerts, L�gico, Define se ser� mostrado alertas ou n�o nas chamadas dos m�todos
	@example oExcelXml:Destroy()
/*/

Method Destroy(lShowAlerts) Class STzExcelXML
	Local cMensagem := "[STzExcelXML][999] Objeto Destru�do com sucesso!"
	Default lShowAlerts := .F.

	//Restaurando as areas
	Self:RestAreaExcel()

	//Definindo os atributos
	::cArqOrig	:= ""
	::cArqDest	:= ""
	::aTabelas	:= {}
	::aAreas	:= {}
	::aExpre	:= {}
	::aConOrig	:= {}
	::aConDest	:= {}
	::cArqCopy	:= ""
	::lShowMsg	:= lShowAlerts

	//Mostrando mensagem caso tenha
	Self:ShowMessage(cMensagem)
Return Nil

/*/{Protheus.doc} ShowMessage
Mensagem que ser� mostrada
@author Atilio
@since 28/05/2015
@version 1.0
	@param cMensagem, Caracter, Mensagem que ser� mostrada ao usu�rio ou no console.log
/*/

Method ShowMessage(cMensagem) Class STzExcelXML
	Default cMensagem := ''

	//Se tiver mensagem de erro
	If !Empty(cMensagem)
	
		//Se mostra mensagem na tela
		If ::lShowMsg
			Aviso('Aten��o', cMensagem, {'OK'}, 03)
			
		//Sen�o apenas mostra mensagem no console.log
		Else
			ConOut(cMensagem)
			//Alert(cMensagem)
			//memowrite("evError.log",cMensagem)
		EndIf
	Endif
Return Nil

/*/{Protheus.doc} RestAreaExcel
M�todo que restaura as �reas armazenadas das tabelas utilizadas pela classe
@author Atilio
@since 01/08/2015
@version 1.0
/*/

Method RestAreaExcel() Class STzExcelXML
	Local nAux := 0
	Local aArea := GetArea()
	
	//Percorrendo as �reas guardadas
	For nAux := 1 To Len(::aAreas)
		RestArea(::aAreas[nAux][2])
	Next
	
	RestArea(aArea)
Return Nil

/*---------------------------------------------------------------------*
 | Func:  fMascara                                                     |
 | Autor: Daniel Atilio                                                |
 | Data:  31/07/2015                                                   |
 | Desc:  Fun��o que verifica se existe m�scara para determinado campo |
 *---------------------------------------------------------------------*/

Static Function fMascara(cCampo)
	Local cMask := ""
	Local cTab := SubStr(cCampo, 1, At('_', cCampo)-1)//AliasCpo(cCampo)
	
	//Se tiver tabela
	If !Empty(cTab) .And. Len(cTab) == 3
		cMask := PesqPict(cTab, cCampo)
	EndIf
Return cMask