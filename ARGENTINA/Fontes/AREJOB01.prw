#INCLUDE "Protheus.ch"
#INCLUDE "ParmType.ch"

//Constantes - Estrutura de dados para envio de emails
#DEFINE P_EML_FROM		1	//Conta SMTP
#DEFINE P_EML_USER 	2	//Usuario
#DEFINE P_EML_PWD 		3	//Senha
#DEFINE P_EML_SERV 	4	//Servidor
#DEFINE P_EML_PORT		5	//Porta
#DEFINE P_EML_AUTH 	6	//Autentica SMTP
#DEFINE P_EML_TLS 		7	//TLS
#DEFINE P_EML_TOUT 	8	//Timeout
#DEFINE P_EML_TO 		9	//Email destino
#DEFINE P_EML_SSL		10	//SSL

//--------------------------------------------------------------
/*/{Protheus.doc} AREJOB01
Rotina de job para envio de comunicados aos clientes de titulos
a pagar a vencer e vencidas.

@param[01] : Codigo de empresa (opcional)
@param[02] : Codigo da filial (opcional)

@return : Nenhum

@author  Pablo Gollan Carreras [RVG]
@since 14/02/2014
@revision
/*/
//--------------------------------------------------------------

User Function AREJOB01(cCdEmp,cCdFil)

	Local aTabs				:= {"SA1","SA3","SE1","SF2"}
	Local oFunc				:= rvgFun01():New()
	Local aEmpresa			:= {}
	Local aLstEmp			:= {}
	Local aLstEmpPr			:= {}
	Local cRotina			:= oFunc:RetFunName(.F.,.T.)
	Local bMens				:= {|x| ConOut(cRotina + x)}
	Local nPos				:= 0
	Local ni				:= 0
	Local nx				:= 0
	Local ny				:= 0
	Local nz				:= 0
	Local cEmpCon			:= ""
	Local cFilCon			:= ""
	Local aLCxCust			:= {"A1_XAVSAV","A1_XAVSDV","A1_XAVSEML","E1_XAVSAV","E1_XAVSDV","E1_XAVSDVN"}
	Local cAliasT			:= ""
	Local lOk				:= .T.
	Local cCpAt				:= ""
	Local nDias				:= 0
	Local nDiasRec			:= 0
	Local nMaxRec			:= 0
	Local aLxVencer			:= {}
	Local aLxAtraso			:= {}
	Local aLxAtrasoR		:= {}
	Local cTitulo			:= ""
	Local cMens				:= ""
	Local aMensIt			:= {}
	Local bForma01			:= {|x| Upper(AllTrim(x))}
	Local bForma02			:= {|x| Lower(RTrim(x))}
	Local bPosSE1			:= {|x| SE1->(dbGoTo(x)),SA1->(dbSeek(xFilial("SA1") + SE1->(E1_CLIENTE + E1_LOJA)))}
	Local cNomeCli			:= ""
	Local cEndEml			:= ""
	Local aCfgEml			:= {}
	Local aLCx01			:= {"E1_NUM","E1_EMISSAO","E1_VENCREA","E1_VALOR"}
	Local aLCx01E			:= {}
	Local aTMP				:= {}
	Local cHTML				:= ""
	Local lEnvOk			:= .F.
	Local cQry				:= ""
	Local aEmlDes			:= {}
	Local cEmlDes			:= ""
	Local cEmlDesR			:= ""
	Local cEmlCop			:= ""
	Local cLinkLogo			:= ""

	//PARAMTYPE 0	VAR cCdEmp		AS CHARACTER	OPTIONAL	DEFAULT "01"
	//PARAMTYPE 1	VAR cCdFil		AS CHARACTER	OPTIONAL	DEFAULT "02"

	DEFAULT cCdEmp := "07"
	DEFAULT cCdFil := "01"

	cCdEmp := Padr(cCdEmp,2)
	cCdFil := Padr(cCdFil,2)

	//------------------------
	//Validar tipo de acesso
	//------------------------
	If !oFunc:InJob()
		Eval(bMens,"Finalizado. Esta rotina somente pode ser executada via JOB.")
		oFunc:Finish()
		Return Nil
	Endif
	//---------------------------
	//Definir o formato da data
	//---------------------------
	__SetCentury("ON")
	_DFSET("dd/mm/yyyy","dd/mm/yy")
	//------------------------------------------
	//Carregar estrutura de empresas e filiais
	//------------------------------------------
	Eval(bMens,"Iniciado [" + DtoC(Date()) + Space(1) + Time() + "]")
	OpenSm0()
	aEmpresa := FWLoadSM0()
	//-------------------------------------
	//Validar empresa e filial informados
	//-------------------------------------
	If Empty(cCdEmp)
		aLstEmp := aClone(aEmpresa)
	Else
		For ni := 1 to Len(aEmpresa)
			If aEmpresa[ni][SM0_GRPEMP] == cCdEmp .AND. (Empty(cCdFil) .OR. aEmpresa[ni][SM0_CODFIL] == cCdFil)
				aAdd(aLstEmp,aClone(aEmpresa[ni]))
			Endif
		Next ni
		If Empty(aLstEmp)
			Eval(bMens,"Finalizado. Empresa [" + cCdEmp + "] nao consta na lista de empresas!")
		Endif
	Endif
	//--------------------------
	//Varrer lista de empresas
	//--------------------------
	For ni := 1 to Len(aLstEmp)
		cEmpCon := aLstEmp[ni][SM0_GRPEMP]
		cFilCon := aLstEmp[ni][SM0_CODFIL]
		lOk		:= .T.
		//-----------------------------------------------
		//Validar se a empresa esta autorizada para uso
		//-----------------------------------------------
		If ValType(aLstEmp[ni][SM0_EMPOK]) == "L" .AND. !aLstEmp[ni][SM0_EMPOK]
			Eval(bMens,"Empresa [" + cEmpCon + "-" + cFilCon + "] nao esta autorizada!")
			Loop
		Endif
		//-------------
		//Conexao RPC
		//-------------
		If  oFunc:SetRPCCon(cEmpCon,cFilCon," ")

			//-----------------------------------------------------
			//Validar se a empresa + filial esta liberada pra uso
			//(ApLib050) para evitar erro de execucao
			//-----------------------------------------------------
			If EmprOK(cEmpCon + cFilCon)

				cLinkLogo		:= AllTrim(SuperGetMv('ST_LOGMAIL', .F., "http://www.steck.com.br/ftp-steck/Logo%20Steck.jpg" ))
				cEmlCop			:=	AllTrim(SuperGetMv('ST_FMAILCP', .F., "" ))

				//------------------
				//Carregar tabelas
				//------------------
				lOk := oFunc:LoadTables(aTabs,.T.,.T.)
				//------------------------------
				//Estrutura da lista de campos
				//------------------------------
				aLCx01E := oFunc:ListaCampos("SE1",2,,7,aClone(aLCx01),,,.T.,.T.)
				//-------------------------------------------
				//Validar existencia dos campos necessarios
				//-------------------------------------------
				If lOk
					aEval(aLCxCust,{|x| cCpAt := x,IIf(Empty((FWTabPref(cCpAt))->(FieldPos(cCpAt))),;
						(lOk := .F.,Eval(bMens,"Campo necessario [" + cCpAt + "] nao existe!")),.F.)})
				Endif
				//---------------------------------
				//Levantar configuracoes de email
				//---------------------------------
				If Empty(cEndEml := SuperGetMV("MV_RELACNT",.F.,""))
					If Empty(cEndEml := SuperGetMV("MV_RELFROM",.F.,""))
						lOk := .F.
						Eval(bMens,"Email padrao para envio nao configurado!")
					Endif
				Endif
				If lOk .AND. Empty(aCfgEml := oFunc:GetMailConfig(.F.,.T.,RTrim(cEndEml)))
					lOk := .F.
					Eval(bMens,"Configuracoes de email nao puderam ser carregadas!")
				Endif
				//------------------------------------------------------------------
				//Se SE1 compartilhada validar se a empresa jah nao foi processada
				//------------------------------------------------------------------
				If lOk .AND. FWModeAccess("SE1") == "C" .AND. !Empty(aScan(aLstEmpPr,{|x| x == cEmpCon}))
					lOk := .F.
					Eval(bMens,"Tabela SE1 compartilhada e jah processada na empresa [" + cEmpCon + "]")
				Endif
				//-----------
				//Pesquisas
				//-----------
				If lOk
					cAliasT := GetNextAlias()
					aLxVencer	:= {}
					aLxAtraso	:= {}
					aLxAtrasoR	:= {}
					nDiasRec	:= GetMV("MV_XDIASAR",.F.,7)
					nMaxRec		:= GetMV("MV_XMAXAR",.F.,5)
					//--------------------------------
					//Pesquisa 01 - Titulos a vencer
					//--------------------------------
					BeginSQL Alias cAliasT
						COLUMN NUMREG	AS NUMERIC(14,0)
						%noParser%

						SELECT SE1.R_E_C_N_O_ AS NUMREG
						FROM %table:SE1% SE1
						WHERE SE1.%notDel%
						AND SE1.E1_FILIAL = %xFilial:SE1%
						AND SE1.E1_VENCREA >= %exp:MsDate()%
						AND SE1.E1_TIPO = %exp:"FT"%
						AND SE1.E1_SALDO > 0
						AND EXISTS (
						SELECT 1
						FROM %table:SA1% SA1
						WHERE SA1.%notDel%
						AND SA1.A1_FILIAL = %xFilial:SA1%
						AND SA1.A1_COD = SE1.E1_CLIENTE
						AND SA1.A1_LOJA = SE1.E1_LOJA
						AND SA1.A1_XAVSAV > 0
						AND SA1.A1_XAVSEML <> %exp:Space(TamSX3("A1_XAVSEML")[1])%
						)
					EndSQL
					Do While !(cAliasT)->(Eof())
						SE1->(dbGoTo((cAliasT)->NUMREG))
						If !SE1->(Eof())
							//Levantar dias para aviso antecipado
							nDias := Posicione("SA1",1,xFilial("SA1") + SE1->(E1_CLIENTE + E1_LOJA),"A1_XAVSAV")
							//Subtrair dias do aviso antecipado do vencimento e validar se a data encontrada eh menor ou igual a data atual
							If DaySub(SE1->E1_VENCREA,nDias) <= MsDate()
								//Validar se o aviso ja nao foi enviado
								If Empty(SE1->E1_XAVSAV)
									If Empty(nPos := aScan(aLxVencer,{|x| x[1] == SE1->(E1_CLIENTE + E1_LOJA)}))
										aAdd(aLxVencer,{SE1->(E1_CLIENTE + E1_LOJA),Array(0)})
										nPos := Len(aLxVencer)
									Endif
									aAdd(aLxVencer[nPos][2],SE1->(Recno()))
								Endif
							Endif
						Endif
						(cAliasT)->(dbSkip())
					EndDo
					(cAliasT)->(dbCloseArea())
					//----------------------------------------------
					//Pesquisa 02 - Titulos vencidos e Recorrentes
					//----------------------------------------------
					BeginSQL Alias cAliasT
						COLUMN NUMREG	AS NUMERIC(14,0)
						%noParser%

						SELECT SE1.R_E_C_N_O_ AS NUMREG
						FROM %table:SE1% SE1
						WHERE SE1.%notDel%
						AND SE1.E1_FILIAL = %xFilial:SE1%
						AND SE1.E1_VENCREA <= %exp:MsDate()%
						AND SE1.E1_TIPO = %exp:"FT"%
						AND SE1.E1_SALDO > 0
						AND EXISTS (
						SELECT 1
						FROM %table:SA1% SA1
						WHERE SA1.%notDel%
						AND SA1.A1_FILIAL = %xFilial:SA1%
						AND SA1.A1_COD = SE1.E1_CLIENTE
						AND SA1.A1_LOJA = SE1.E1_LOJA
						AND SA1.A1_XAVSDV > 0
						AND SA1.A1_XAVSEML <> %exp:Space(TamSX3("A1_XAVSEML")[1])%
						)
					EndSQL
					Do While !(cAliasT)->(Eof())
						SE1->(dbGoTo((cAliasT)->NUMREG))
						If !SE1->(Eof())
							//Levantar dias para aviso posterior
							nDias := Posicione("SA1",1,xFilial("SA1") + SE1->(E1_CLIENTE + E1_LOJA),"A1_XAVSDV")
							//Adicionar dias do aviso posterior do vencimento e validar se a data encontrada eh maior ou igual a data atual
							If DaySum(SE1->E1_VENCREA,nDias) <= MsDate()
								If Empty(SE1->E1_XAVSDV)
									If Empty(nPos := aScan(aLxAtraso,{|x| x[1] == SE1->(E1_CLIENTE + E1_LOJA)}))
										aAdd(aLxAtraso,{SE1->(E1_CLIENTE + E1_LOJA),Array(0)})
										nPos := Len(aLxAtraso)
									Endif
									aAdd(aLxAtraso[nPos][2],SE1->(Recno()))
								Else
									//Validar se o aviso recorrente deve ser enviado
									If SE1->E1_XAVSDVN <= nMaxRec .AND. DaySum(SE1->E1_XAVSDV,nDiasRec) = MsDate()
										If Empty(nPos := aScan(aLxAtrasoR,{|x| x[1] == SE1->(E1_CLIENTE + E1_LOJA)}))
											aAdd(aLxAtrasoR,{SE1->(E1_CLIENTE + E1_LOJA),Array(0)})
											nPos := Len(aLxAtrasoR)
										Endif
										aAdd(aLxAtrasoR[nPos][2],SE1->(Recno()))
									Endif
								Endif
							Endif
						Endif
						(cAliasT)->(dbSkip())
					EndDo
					(cAliasT)->(dbCloseArea())
					//-----------------------------
					//Envio 01 - Titulos a vencer
					//-----------------------------
					For nx := 1 to Len(aLxVencer)
						//Posicionar cliente no primeiro registro dele
						Eval(bPosSE1,aLxVencer[nx][2][1])
						cNomeCli := IIf(Empty(SA1->A1_NREDUZ),SA1->A1_NOME,SA1->A1_NREDUZ)
						//Titulo
						cTitulo := "Agenda Semanal - [" + Eval(bForma01,cNomeCli) + "]"
						//Mensagem
						cMens := "Estimado cliente: " + Eval(bForma01,cNomeCli) + Replicate(CRLF,2)
						cMens += "Para su comodidad informamos al pie las facturas con vencimiento en esta semana." + Replicate(CRLF,2)
						cMens += "Favor verificar en sus registros las facturas mencionadas en el presente correo." + Replicate(CRLF,2)
						cMens += "Caso hubiera alguna diferencia  en ellos  o necesite el reenvío de documentación, "
						cMens += "como si este mensaje no fue enviado al sector correspondiente, "
						cMens += "solicitamos tengan a bien entrar en contacto con carla.gimenez@steckgroup.com / romina.figueroa@steckgroup.com "
						cMens += "o  comuníquese telefónicamente al (011 )4201-1489."+ Replicate(CRLF,2)
						cMens += "Cordialmente," + Replicate(CRLF,2)
						cMens += "Depto. Financiero" + Replicate(CRLF,2)
						cMens += "STECK ELECTRIC S.A." + Replicate(CRLF,2)




						//Varrer todos os titulos do cliente
						aMensIt := {}
						For nz := 1 to Len(aLxVencer[nx][2])
							Eval(bPosSE1,aLxVencer[nx][2][nz])
							aTMP := Array(Len(aLCx01))
							For ny := 1 to Len(aLCx01)
								aTMP[ny] := SE1->&(aLCx01[ny])
							Next ny
							aAdd(aMensIt,aClone(aTMP))
						Next nz
						//Formatacao da mensagem
						cHTML := oFunc:HTMxMessage("Agenda Semanal",cLinkLogo,.T.,cMens,;
							{{aLCx01E,aMensIt,Eval(bForma01,FWFilRazSocial()),"Total de título(s) : " + cValToChar(Len(aLxVencer[nx][2]))}})
						//Envio da mensagem
						/*lEnvOk := oFunc:MailSend(	aCfgEml[P_EML_SSL],;
							aCfgEml[P_EML_TLS],;
							aCfgEml[P_EML_AUTH],;
							aCfgEml[P_EML_FROM],;
							Eval(bForma02,SA1->A1_XAVSEML),;
							,;
							,;
							cTitulo,;
							cHTML,;
							aCfgEml[P_EML_SERV],;
							aCfgEml[P_EML_PWD],;
							aCfgEml[P_EML_PORT],;
							aCfgEml[P_EML_USER],;
							aCfgEml[P_EML_TOUT],;
							.F.,;
							,;
							.T.)*/
						lEnvOk := U_STMAILTES(Eval(bForma02,SA1->A1_XAVSEML), cEmlCop, cTitulo, cHTML)

						//Gravacao do FLAG
						If lEnvOk
							Eval(bMens,"Email aviso a vencer [" + RTrim(Lower(SA1->A1_XAVSEML)) + "] enviado com sucesso!")
							For nz := 1 to Len(aLxVencer[nx][2])
								Eval(bPosSE1,aLxVencer[nx][2][nz])
								If RecLock("SE1",.F.)
									SE1->E1_XAVSAV	:= MsDate()
									SE1->(MsUnlock())
								Else
									//Caso a atualizacao nao seja possivel por RECLOCK gravar atraves do SQL
									cQry := "UPDATE " + RetSQLName("SE1") + " "
									cQry += "SET E1_XAVSAV = '" + DtoS(MsDate()) + "' "
									cQry += "WHERE R_E_C_N_O_ = " + cValToChar(aLxVencer[nx][2][nz])
									If TcSQLExec(cQry) < 0
										Eval(bMens,"Erro na atualizacao do SE1 no registro [" + cValToChar(aLxVencer[nx][2][nz]) + "] :")
										Eval(bMens,TcSQLError())
									Endif
								Endif
							Next nz
						Else
							Eval(bMens,"Email aviso a vencer [" + RTrim(Lower(SA1->A1_XAVSEML)) + "] nao foi enviado!")
						Endif
					Next nx
					//----------------------------------------
					//Envio 02 - Titulos vencidos - 1o aviso
					//----------------------------------------
					For nx := 1 to Len(aLxAtraso)
						//Posicionar cliente no primeiro registro dele
						Eval(bPosSE1,aLxAtraso[nx][2][1])
						aEmlDes		:= {}
						cEmlDes		:= Eval(bForma02,SA1->A1_XAVSEML)
						cNomeCli	:= IIf(Empty(SA1->A1_NREDUZ),SA1->A1_NOME,SA1->A1_NREDUZ)
						//Titulo
						cTitulo := "Agenda Semanal - [" + Eval(bForma01,cNomeCli) + "]"
						//Mensagem

							cMens := "Estimado cliente: " + Eval(bForma01,cNomeCli) + Replicate(CRLF,2)
						cMens += "Para su comodidad informamos al pie las facturas vencidos, hasta la fecha." + Replicate(CRLF,2)
						cMens += "Favor verificar en sus registros las facturas mencionadas en el presente correo." + Replicate(CRLF,2)
						cMens += "Caso hubiera alguna diferencia  en ellos  o necesite el reenvío de documentación, "
						cMens += "como si este mensaje no fue enviado al sector correspondiente, "
						cMens += "solicitamos tengan a bien entrar en contacto con carla.gimenez@steckgroup.com / romina.figueroa@steckgroup.com "
						cMens += "o  comuníquese telefónicamente al (011 )4201-1489."+ Replicate(CRLF,2)
						cMens += "Cordialmente," + Replicate(CRLF,2)
						cMens += "Depto. Financiero" + Replicate(CRLF,2)
						cMens += "STECK ELECTRIC S.A." + Replicate(CRLF,2)



						//Varrer todos os titulos do cliente
						aMensIt := {}
						For nz := 1 to Len(aLxAtraso[nx][2])
							Eval(bPosSE1,aLxAtraso[nx][2][nz])
							aTMP := Array(Len(aLCx01))
							For ny := 1 to Len(aLCx01)
								aTMP[ny] := SE1->&(aLCx01[ny])
							Next ny
							aAdd(aMensIt,aClone(aTMP))
							//Levantar o endereco do representantes
							If SF2->(dbSeek(xFilial("SF2") + PadR(SE1->E1_NUM,TamSX3("F2_DOC")[1]) + ;
									PadR(SE1->E1_PREFIXO,TamSX3("F2_SERIE")[1]) + SE1->(E1_CLIENTE + E1_LOJA)))

								For ny := 1 to 5
									cCpAt := "F2_VEND" + cValToChar(ny)
									If !Empty(SF2->(FieldPos(cCpAt))) .AND. !Empty(SF2->&(cCpAt))
										//Posicionar tabela de vendedores
										SA3->(dbSeek(xFilial("SA3") + SF2->&(cCpAt)))
										If SA3->(Found()) .AND. !Empty(SA3->A3_EMAIL) .AND. ;
												Empty(aScan(aEmlDes,{|x| x == Eval(bForma02,SA3->A3_EMAIL)}))

											aAdd(aEmlDes,Eval(bForma02,SA3->A3_EMAIL))
										Endif
									Endif
								Next ny
							Endif
						Next nz
						//Definir destinatarios - Representantes
						(cEmlDesR := "",aEval(aEmlDes,{|x| cEmlDesR += x + ";"}))
						//Formatacao da mensagem
						cHTML := oFunc:HTMxMessage("Agenda Semanal",cLinkLogo,.T.,cMens,;
							{{aLCx01E,aMensIt,Eval(bForma01,FWFilRazSocial()),"Total de título(s) : " + cValToChar(Len(aLxAtraso[nx][2]))}})
						//Envio da mensagem
						/*lEnvOk := oFunc:MailSend(	aCfgEml[P_EML_SSL],;
							aCfgEml[P_EML_TLS],;
							aCfgEml[P_EML_AUTH],;
							aCfgEml[P_EML_FROM],;
							cEmlDes,;
							/*CC*,;
							cEmlDesR,;
							cTitulo,;
							cHTML,;
							aCfgEml[P_EML_SERV],;
							aCfgEml[P_EML_PWD],;
							aCfgEml[P_EML_PORT],;
							aCfgEml[P_EML_USER],;
							aCfgEml[P_EML_TOUT],;
							.F./*lGeraArq*,;
							/*Anexo*,;
							.T./*Mostra Erro*)*/

						lEnvOk := U_STMAILTES(cEmlDes, cEmlCop, cTitulo, cHTML)
						//Gravacao do FLAG
						If lEnvOk
							Eval(bMens,"Email aviso atraso para [" + cEmlDes + "] enviado com sucesso!")
							For nz := 1 to Len(aLxAtraso[nx][2])
								Eval(bPosSE1,aLxAtraso[nx][2][nz])
								If RecLock("SE1",.F.)
									SE1->E1_XAVSDV	:= MsDate()
									SE1->(MsUnlock())
								Else
									//Caso a atualizacao nao seja possivel por RECLOCK gravar atraves do SQL
									cQry := "UPDATE " + RetSQLName("SE1") + " "
									cQry += "SET E1_XAVSDV = '" + DtoS(MsDate()) + "' "
									cQry += "WHERE R_E_C_N_O_ = " + cValToChar(aLxAtraso[nx][2][nz])
									If TcSQLExec(cQry) < 0
										Eval(bMens,"Erro na atualizacao do SE1 no registro [" + cValToChar(aLxAtraso[nx][2][nz]) + "] :")
										Eval(bMens,TcSQLError())
									Endif
								Endif
							Next nz
						Else
							Eval(bMens,"Email aviso atraso para [" + cEmlDes + "] nao foi enviado!")
						Endif
					Next nx
					//------------------------------------------------
					//Envio 03 - Titulos vencidos - Aviso recorrente
					//------------------------------------------------
					For nx := 1 to Len(aLxAtrasoR)
						//Posicionar cliente no primeiro registro dele
						Eval(bPosSE1,aLxAtrasoR[nx][2][1])
						aEmlDes		:= {}
						cEmlDes		:= Eval(bForma02,SA1->A1_XAVSEML)
						cNomeCli	:= IIf(Empty(SA1->A1_NREDUZ),SA1->A1_NOME,SA1->A1_NREDUZ)
						//Titulo
						cTitulo := "Agenda Semanal - [" + Eval(bForma01,cNomeCli) + "]"
						//Mensagem

								cMens := "Estimado cliente: " + Eval(bForma01,cNomeCli) + Replicate(CRLF,2)
						cMens += "Para su comodidad informamos al pie las facturas vencidos, hasta la fecha." + Replicate(CRLF,2)
						cMens += "Favor verificar en sus registros las facturas mencionadas en el presente correo." + Replicate(CRLF,2)
						cMens += "Caso hubiera alguna diferencia  en ellos  o necesite el reenvío de documentación, "
						cMens += "como si este mensaje no fue enviado al sector correspondiente, "
						cMens += "solicitamos tengan a bien entrar en contacto con carla.gimenez@steckgroup.com / romina.figueroa@steckgroup.com "
						cMens += "o  comuníquese telefónicamente al (011 )4201-1489."+ Replicate(CRLF,2)
						cMens += "Por favor, tenga en cuenta este aviso si ya ha regularizado los pagos."+ Replicate(CRLF,2)
						cMens += "Cordialmente," + Replicate(CRLF,2)
						cMens += "Depto. Financiero" + Replicate(CRLF,2)
						cMens += "STECK ELECTRIC S.A." + Replicate(CRLF,2)


						//Varrer todos os titulos do cliente
						aMensIt := {}
						For nz := 1 to Len(aLxAtrasoR[nx][2])
							Eval(bPosSE1,aLxAtrasoR[nx][2][nz])
							aTMP := Array(Len(aLCx01))
							For ny := 1 to Len(aLCx01)
								aTMP[ny] := SE1->&(aLCx01[ny])
							Next ny
							aAdd(aMensIt,aClone(aTMP))
							//Levantar o endereco do representantes
							If SF2->(dbSeek(xFilial("SF2") + PadR(SE1->E1_NUM,TamSX3("F2_DOC")[1]) + ;
									PadR(SE1->E1_PREFIXO,TamSX3("F2_SERIE")[1]) + SE1->(E1_CLIENTE + E1_LOJA)))

								For ny := 1 to 5
									cCpAt := "F2_VEND" + cValToChar(ny)
									If !Empty(SF2->(FieldPos(cCpAt))) .AND. !Empty(SF2->&(cCpAt))
										//Posicionar tabela de vendedores
										SA3->(dbSeek(xFilial("SA3") + SF2->&(cCpAt)))
										If SA3->(Found()) .AND. !Empty(SA3->A3_EMAIL) .AND. ;
												Empty(aScan(aEmlDes,{|x| x == Eval(bForma02,SA3->A3_EMAIL)}))

											aAdd(aEmlDes,Eval(bForma02,SA3->A3_EMAIL))
										Endif
									Endif
								Next ny
							Endif
						Next nz
						//Definir destinatarios
						(cEmlDesR := "",aEval(aEmlDes,{|x| cEmlDesR += x + ";"}))
						//Formatacao da mensagem
						cHTML := oFunc:HTMxMessage("Agenda Semanal",cLinkLogo,.T.,cMens,;
							{{aLCx01E,aMensIt,Eval(bForma01,FWFilRazSocial()),"Total de título(s) : " + cValToChar(Len(aLxAtrasoR[nx][2]))}})
						//Envio da mensagem
						/*lEnvOk := oFunc:MailSend(	aCfgEml[P_EML_SSL],;
							aCfgEml[P_EML_TLS],;
							aCfgEml[P_EML_AUTH],;
							aCfgEml[P_EML_FROM],;
							cEmlDes,;
							/*CC*,;
							cEmlDesR,;
							cTitulo,;
							cHTML,;
							aCfgEml[P_EML_SERV],;
							aCfgEml[P_EML_PWD],;
							aCfgEml[P_EML_PORT],;
							aCfgEml[P_EML_USER],;
							aCfgEml[P_EML_TOUT],;
							.F./*lGeraArq*,;
							/*Anexo*,;
							.T./*Mostra Erro*)*/
						lEnvOk := U_STMAILTES(cEmlDes, cEmlCop, cTitulo, cHTML)
						//Gravacao do FLAG
						If lEnvOk
							Eval(bMens,"Email aviso atraso (recorrente) para [" + cEmlDes + "] enviado com sucesso!")
							For nz := 1 to Len(aLxAtrasoR[nx][2])
								Eval(bPosSE1,aLxAtrasoR[nx][2][nz])
								If RecLock("SE1",.F.)
									SE1->E1_XAVSDV	:= MsDate()
									SE1->E1_XAVSDVN	+= 1
									SE1->(MsUnlock())
								Else
									//Caso a atualizacao nao seja possivel por RECLOCK gravar atraves do SQL
									cQry := "UPDATE " + RetSQLName("SE1") + " "
									cQry += "SET E1_XAVSDV = '" + DtoS(MsDate()) + "', "
									cQry += "	E1_XAVSDVN = " + cValToChar(SE1->E1_XAVSDVN	+ 1) + " "
									cQry += "WHERE R_E_C_N_O_ = " + cValToChar(aLxAtraso[nx][2][nz])
									If TcSQLExec(cQry) < 0
										Eval(bMens,"Erro na atualizacao do SE1 no registro [" + cValToChar(aLxAtraso[nx][2][nz]) + "] :")
										Eval(bMens,TcSQLError())
									Endif
								Endif
							Next nz
						Else
							Eval(bMens,"Email aviso atraso (recorrente) para [" + cEmlDes + "] nao foi enviado!")
						Endif
					Next nx
					//Adicionar empresa a lista de empresas processadas
					aAdd(aLstEmpPr,cEmpCon)
				Endif
			Else
				Eval(bMens,"Empresa [" + cEmpCon + "-" + cFilCon + "] nao liberada para o uso!")
			Endif
			If ni < Len(aLstEmp)
				RPCClearEnv()
			EndIf
		Else
			Eval(bMens,"Nao foi possivel estabelecer a conexao RPC [" + cEmpCon + "-" + cFilCon + "].")
		Endif
	Next ni

	Eval(bMens,"Finalizado [" + DtoC(Date()) + Space(1) + Time() + "]")
	conout("rvg01")
	oFunc:Finish()
	RPCClearEnv()
Return

Static Function Scheddef()

	Local aParam
	Local aOrd     := {OemToAnsi(" Por Codigo         "),OemToAnsi(" Alfabetica         ")}

	PutSx1("AREJOB01", "01","Empresa"	,"Empresa"	,"Empresa"	,"mv_ch1","C",2,0,0,"G","",''    ,"","","mv_par01","","","","","","","","","","","","","","","","")
	PutSx1("AREJOB01", "02","Filial"	,"Filial"	,"Filial"  	,"mv_ch2","C",2,0,0,"G","",''    ,"","","mv_par02","","","","","","","","","","","","","","","","")

	aParam := {"P","AREJOB01","SE1",aOrd,"Emp_Mail"}

Return aParam
