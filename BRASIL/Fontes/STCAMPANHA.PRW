#include 'Protheus.ch'
#include 'RwMake.ch'

/*====================================================================================\
|Programa  | STCAMPANHA       | Autor | GIOVANI.ZAGO             | Data | 27/10/2014  |
|=====================================================================================|
|Descrição |  STCAMPANHA    cadastro de campanha de vendas                            |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STCAMPANHA                                                               |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
User Function STCAMPANHA()//STCAMCLI()
	*-----------------------------*
	Local aArea          := GetArea()
	Local aCores2        := {	;
	{ "PPD_STATUS <> '3' .and. PPD_FIM >= DDATABASE", "ENABLE"  },;
	{ "PPD_STATUS <> '3'  .and. PPD_FIM < DDATABASE", "BR_PRETO" },;
	{ "PPD_STATUS == '3'","DISABLE" } }
	Private cCadastro	 := "Campanha de Vendas x Cliente"
	Private cAlias1:= "PPD"
	Private cAlias2:= "PPE"
	Private cAlias3:= "PPG"
	Private aRotina := {;
	{ "Pesquisar"  			 , "PesqBrw" 							, 0 , 1 },;
	{ "Visualizar" 			 , "U_STCAMTEL" 						, 0 , 2 },;
	{ "Campanha x Cliente"   , "U_STCAMTEL" 						, 0 , 3 },;
	{ "Campanha x Prod/Grupo", "U_STCAMPRO" 						, 0 , 4 },;
	{ "Incluir Campanha"     ,'AxInclui(cAlias1,RecNo(),3,,,,,,,)'	, 0 , 5 },;
	{ "Alterar Campanha"     ,'AxAltera(cAlias1,RecNo(),3,,,,,,,)'	, 0 , 6 },;
	{ "Cancelar Campanha"    , "U_STCANCAM" 						, 0 , 7 },;
	{ "Legenda"    			 , "U_STCAMLEG" 						, 0 , 8 }}

	Private _cUserCam  := GetMv("ST_USECAM",,"000000")+"/000000"
	If !(__cUserId $ _cUserCam)
		MsgInfo("Usuario Sem Acesso")
		Return()
	EndIf
	DbSelectArea("PPD")
	PPD->(DbSetOrder(1))

	mBrowse( 7, 4,20,74,"PPD",,,,,,aCores2)

	Restarea(aArea)
	PutMV("ST_USRCAM1",' ')
	Return()

	/*====================================================================================\
	|Programa  | STCAMTEL         | Autor | GIOVANI.ZAGO             | Data | 27/10/2014  |
	|=====================================================================================|
	|Descrição |  STCAMTEL      cadastro de campanha de vendas                            |
	|          |                                                                          |
	|          |                                                                          |
	|=====================================================================================|
	|Sintaxe   | STCAMTEL                                                                 |
	|=====================================================================================|
	|Uso       | Especifico STECK                                                         |
	|=====================================================================================|
	|........................................Histórico....................................|
	\====================================================================================*/
	*-----------------------------*
User Function STCAMTEL( cAlias, nReg, nOpc )
	*-----------------------------*
	Local i:=0
	Local cLinok := "U_XSTLIN()"
	Local cTudook := "u_md3tudok"
	Local nOpce := 2
	Local nOpcg := nopc
	Local cFieldok := "allwaystrue"
	Local lVirtual := .T.
	Local nLinhas := 9999
	Local nFreeze := 0
	Local lRet := .T.
	Private aCols := {}
	Private aHeader := {}
	Private aCpoEnchoice := {}
	Private aAltEnchoice := {}
	Private aAlt := {}
	Private aButtons := {}
	Private _cUserCamp := GetMv("ST_USRCAM1",," ")
	Private oEnchoice, oGetDados

	aAdd(aButtons,{"PMSSETAUP",{|| STFILCOL('1')  },"Localizar"  ,"Localizar"})

	If !Empty(Alltrim(_cUserCamp))
		MsgInfo("Bloqueado pelo Usuario: "+Alltrim(_cUserCamp))
		Return()
	Else
		PutMV("ST_USRCAM1",cUserName)
	EndIf

	If nOpc = 3
		nOpc := 4
	ElseIf nOpc = 5
		nOpc := 3
	ElseIf nOpc = 6
		nOpc := 5
	EndIf
	nOpcg := nopc
	If nOpc == 4
		If PPD_STATUS = '3' .Or. PPD_FIM < DDATABASE
			MsgInfo("Campanha Cancelada/Encerrada não é possivel Alterar")
			Return()
		EndIf
	EndIf

	Regtomemory(cAlias1,(nOpc==3))
	Regtomemory(cAlias2,(nOpc==3))
	CriaHeader()
	CriaCols(nOpc)
	lRet:=stmod3(cCadastro,cAlias1,cAlias2,aCpoEnchoice,cLinok,cTudook,nOpce,;
	nOpcg,cFieldok,lVirtual,nLinhas,aAltenchoice,nFreeze, aButtons)

	If lRet
		//Se opcao for inclusão


		If nOpc == 3

			If MsgYesNo("Confirma gravação dos dados ?",cCadastro)

				Processa({||Grvdados()},cCadastro,"Gravando os dados, aguarde...")

			EndIf


			//Se opção for alteração


		elseIf nOpc == 4

			If MsgYesNo("Confirma alteração dos dados ?", cCadastro)

				Processa({||Altdados()},cCadastro,"Alterando os dados, aguarde...")

			EndIf

			//Se opção for exclusão


		elseIf nOpc == 5

			If MsgYesNo("Confirma exclusão dos dados ?", cCadastro)

				Processa({||Excluidados()},cCadastro,"Excluindo os dados, aguarde...")

			EndIf

		EndIf

	else

		RollbackSx8()

	EndIf
	PutMV("ST_USRCAM1",' ')
	return

	/*====================================================================================\
	|Programa  | CriaHeader       | Autor | GIOVANI.ZAGO             | Data | 27/10/2014  |
	|=====================================================================================|
	|Descrição |  CriaHeader    cadastro de campanha de vendas                            |
	|          |                                                                          |
	|          |                                                                          |
	|=====================================================================================|
	|Sintaxe   | CriaHeader                                                               |
	|=====================================================================================|
	|Uso       | Especifico STECK                                                         |
	|=====================================================================================|
	|........................................Histórico....................................|
	\====================================================================================*/
	*-----------------------------*
Static Function CriaHeader()
	*-----------------------------*
	aHeader:= {}

	aCpoEnchoice := {}

	aAltEnchoice :={}

	dbselectarea("SX3")
	dbsetorder(1)
	dbseek(cAlias2)

	while ! eof() .and. x3_arquivo == cAlias2

		If x3uso(x3_usado) .and. cnivel >= x3_nivel

			aAdd(aHeader,{trim(x3_titulo),;
			x3_campo,;
			x3_picture,;
			x3_tamanho,;
			x3_decimal,;
			x3_valid,;
			x3_usado,;
			x3_tipo,;
			x3_arquivo,;
			x3_context})

		EndIf

		dbskip()

	enddo

	dbseek(cAlias1)

	while ! eof() .and. x3_arquivo == cAlias1

		If x3uso(x3_usado) .and. cnivel >= x3_nivel
			If Alltrim(x3_campo) $	"PPD_FILIAL/PPD_NUM/PPD_INI/PPD_FIM/PPD_DESCRI"
				aAdd(aCpoEnchoice,x3_campo)

				aAdd(aAltEnchoice,x3_campo)
			EndIf
		EndIf

		dbskip()

	enddo

	return

	/*====================================================================================\
	|Programa  | CriaCols         | Autor | GIOVANI.ZAGO             | Data | 27/10/2014  |
	|=====================================================================================|
	|Descrição |  CriaCols      cadastro de campanha de vendas                            |
	|          |                                                                          |
	|          |                                                                          |
	|=====================================================================================|
	|Sintaxe   | CriaCols                                                                 |
	|=====================================================================================|
	|Uso       | Especifico STECK                                                         |
	|=====================================================================================|
	|........................................Histórico....................................|
	\====================================================================================*/
	*-----------------------------*
Static function CriaCols(nOpc)
	*-----------------------------*
	Local nQtdcpo := 0
	Local i:= 0
	Local nCols := 0

	nQtdcpo := len(aHeader)

	aCols:= {}

	aAlt := {}

	If nOpc == 3

		aAdd(aCols,array(nQtdcpo+1))

		for i := 1 to nQtdcpo

			aCols[1,i] := Criavar(aHeader[i,2])

		next i

		aCols[1,nQtdcpo+1] := .F.

	else

		dbselectarea(cAlias2)

		dbsetorder(1)

		dbseek(xfilial(cAlias2)+(cAlias1)->PPD_NUM)

		while .not. eof() .and. (cAlias2)->PPE_filial == xfilial(cAlias2) .and. (cAlias2)->PPE_NUM==(cAlias1)->PPD_NUM

			aAdd(aCols,array(nQtdcpo+1))

			nCols++

			for i:= 1 to nQtdcpo

				If aHeader[i,10] <> "V"

					aCols[nCols,i] := Fieldget(Fieldpos(aHeader[i,2]))

				else

					aCols[nCols,i] := Criavar(aHeader[i,2],.T.)

				EndIf

			next i

			aCols[nCols,nQtdcpo+1] := .F.

			aAdd(aAlt,Recno())

			dbselectarea(cAlias2)

			dbskip()

		enddo

	EndIf

	return

	/*====================================================================================\
	|Programa  | GrvDados         | Autor | GIOVANI.ZAGO             | Data | 27/10/2014  |
	|=====================================================================================|
	|Descrição |  GrvDados      cadastro de campanha de vendas                            |
	|          |                                                                          |
	|          |                                                                          |
	|=====================================================================================|
	|Sintaxe   | GrvDados                                                                 |
	|=====================================================================================|
	|Uso       | Especifico STECK                                                         |
	|=====================================================================================|
	|........................................Histórico....................................|
	\====================================================================================*/
	*-----------------------------*
Static Function GrvDados()
	*-----------------------------*
	Local bcampo := {|nfield| field(nfield) }
	Local i:= 0
	Local y:= 0
	Local nItem :=0

	procregua(len(aCols)+fCount())

	dbselectarea(cAlias1)

	Reclock(cAlias1,.T.)

	for i:= 1 to fcount()

		incproc()

		If "FILIAL" $ fieldname(i)

			Fieldput(i,xfilial(cAlias1))

		else

			Fieldput(i,M->&(EVAL(BCAMPO,i)))

		EndIf

	next

	Msunlock()

	dbselectarea(cAlias2)

	dbsetorder(1)

	for i:=1 to len(aCols)

		incproc()

		If .not. aCols[i,len(aHeader)+1]

			Reclock(cAlias2,.T.)

			for y:= 1 to len(aHeader)

				Fieldput(Fieldpos(trim(aHeader[y,2])),aCols[i,y])

			next

			nItem++

			(cAlias2)->PPE_filial := xfilial(cAlias2)

			(cAlias2)->PPE_NUM := (cAlias1)->PPD_NUM

			//	(cAlias2)->z3_item := strzero(nItem,2,0)

			Msunlock()
			STCAMMAIL('','',cusername,dtoc(date()),time(),Alltrim(Posicione("SA3",1,xFilial("SA3")+PPE->PPE_SUPER  ,"A3_EMAIL")))
		EndIf

	next

	return
	/*====================================================================================\
	|Programa  | Altdados         | Autor | GIOVANI.ZAGO             | Data | 27/10/2014  |
	|=====================================================================================|
	|Descrição |  Altdados      cadastro de campanha de vendas                            |
	|          |                                                                          |
	|          |                                                                          |
	|=====================================================================================|
	|Sintaxe   | Altdados                                                                 |
	|=====================================================================================|
	|Uso       | Especifico STECK                                                         |
	|=====================================================================================|
	|........................................Histórico....................................|
	\====================================================================================*/
	*-----------------------------*
Static Function Altdados()
	*-----------------------------*
	Local bcampo := { |nfield| field(nfield) }
	Local i:= 0
	Local y:= 0
	Local nitem := 0

	procregua(len(aCols)+fCount())

	dbselectarea(cAlias1)

	Reclock(cAlias1,.F.)

	for i:= 1 to fcount()

		incproc()

		If "FILIAL" $ fieldname(i)

			Fieldput(i,xfilial(cAlias1))

		else

			Fieldput(i,M->&(EVAL(BCAMPO,i)))

		EndIf

	next i

	Msunlock()

	dbselectarea(cAlias2)

	dbsetorder(1)

	nItem := len(aAlt)+1

	for i:=1 to len(aCols)

		If i<=len(aAlt)

			dbgoto(aAlt[i])

			Reclock(cAlias2,.F.)

			If aCols[i,len(aHeader)+1]

				DbDelete()

			else

				for y:= 1 to len(aHeader)

					Fieldput(Fieldpos(trim(aHeader[y,2])),aCols[i,y])

				next y

			EndIf

			Msunlock()

		else

			If ! aCols[i,len(aHeader)+1]

				Reclock(cAlias2,.T.)

				for y:= 1 to len(aHeader)

					Fieldput(Fieldpos(trim(aHeader[y,2])),aCols[i,y])

				next y

				(cAlias2)->PPE_filial := xfilial(calias2)

				(cAlias2)->PPE_NUM := (cAlias1)->PPD_NUM

				//	(cAlias2)->z3_item := strzero(nItem,2,0)

				Msunlock()
				STCAMMAIL('','',cusername,dtoc(date()),time(),Alltrim(Posicione("SA3",1,xFilial("SA3")+PPE->PPE_SUPER  ,"A3_EMAIL")))

				nItem++

			EndIf

		EndIf

	next i

	return

	//&nbsp;

	/*====================================================================================\
	|Programa  | Excluidados      | Autor | GIOVANI.ZAGO             | Data | 27/10/2014  |
	|=====================================================================================|
	|Descrição |  Excluidados   cadastro de campanha de vendas                            |
	|          |                                                                          |
	|          |                                                                          |
	|=====================================================================================|
	|Sintaxe   | Excluidados                                                              |
	|=====================================================================================|
	|Uso       | Especifico STECK                                                         |
	|=====================================================================================|
	|........................................Histórico....................................|
	\====================================================================================*/
	*-----------------------------*
Static Function Excluidados()
	*-----------------------------*
	procregua(len(aCols)+1)

	dbselectarea(cAlias2)

	dbsetorder(1)

	dbseek(xfilial(cAlias2)+(cAlias1)->PPD_NUM)

	do while .not. eof() .and. (cAlias2)->PPE_FILIAL == xfilial(cAlias2) .and. (cAlias2)->PPE_NUM==(cAlias1)->PPD_NUM

		incproc()

		Reclock(cAlias2,.F.)

		DbDelete()

		Msunlock()

		dbskip()

	enddo

	dbselectarea(cAlias1)

	dbsetorder(1)

	incproc()

	Reclock(cAlias1,.F.)

	DbDelete()

	Msunlock()

	return

	/*====================================================================================\
	|Programa  | Md3TudOk         | Autor | GIOVANI.ZAGO             | Data | 27/10/2014  |
	|=====================================================================================|
	|Descrição |  Md3TudOk      cadastro de campanha de vendas                            |
	|          |                                                                          |
	|          |                                                                          |
	|=====================================================================================|
	|Sintaxe   | Md3TudOk                                                                 |
	|=====================================================================================|
	|Uso       | Especifico STECK                                                         |
	|=====================================================================================|
	|........................................Histórico....................................|
	\====================================================================================*/
	*-----------------------------*
User function Md3TudOk()
	*-----------------------------*
	Local lRet:= .T.

	Local i:=0

	Local nDel :=0

	for i:=1 to len(aCols)

		If aCols[i,len(aHeader)+1]

			nDel++

		EndIf

	next

	If nDel == len(aCols)

		Msginfo("Para excluir todos os itens, utilize a opção Cancelar",cCadastro)

		lRet := .F.

	EndIf

	return(lRet)

	/*====================================================================================\
	|Programa  | STCAMLEG         | Autor | GIOVANI.ZAGO             | Data | 27/10/2014  |
	|=====================================================================================|
	|Descrição |  STCAMLEG      cadastro de campanha de vendas                            |
	|          |                                                                          |
	|          |                                                                          |
	|=====================================================================================|
	|Sintaxe   | STCAMLEG                                                                 |
	|=====================================================================================|
	|Uso       | EspecIfico STECK                                                         |
	|=====================================================================================|
	|........................................Histórico....................................|
	\====================================================================================*/
	*-----------------------------*
User Function STCAMLEG()
	*-----------------------------*
	Local aCorDesc
	aCorDesc := {  ;
	{ "ENABLE"	,	"Ativo" 	},;
	{ "BR_PRETO",	"Encerrado" },;
	{ "DISABLE"	,	"Cancelado" }}
	BrwLegenda( "Legenda", "Status", aCorDesc )
	Return


	/*====================================================================================\
	|Programa  | STCANCAM         | Autor | GIOVANI.ZAGO             | Data | 27/10/2014  |
	|=====================================================================================|
	|Descrição |  STCANCAM      cadastro de campanha de vendas                            |
	|          |                                                                          |
	|          |                                                                          |
	|=====================================================================================|
	|Sintaxe   | STCANCAM                                                                 |
	|=====================================================================================|
	|Uso       | EspecIfico STECK                                                         |
	|=====================================================================================|
	|........................................Histórico....................................|
	\====================================================================================*/
	*-----------------------------*
User Function STCANCAM()
	*-----------------------------*
	Private _cUserCam  := GetMv("ST_USECAM",,"000000")+"/000000"
	If !(__cUserId $ _cUserCam)
		MsgInfo("Usuario Sem Acesso")
		Return()
	EndIf
	If MsgYesNo("Deseja Cancelar Este Item da Campanha de Vendas?")

		PPD->(RecLock("PPD",.F.))
		PPD->PPD_LOG  	:= PPD->PPD_LOG +  "ITEM CANCELADO EM: " + DTOC(DDATABASE) + "-" + TIME() + " POR: "+ cUserName + chr(13) + chr(10)+REPLICATE("-",80) + chr(13) + chr(10)
		PPD->PPD_STATUS := '3'
		PPD->(Msunlock("PPD"))
		PPD->( DbCommit() )

	EndIf
	Return



	/*====================================================================================\
	|Programa  | STCANCAM         | Autor | GIOVANI.ZAGO             | Data | 27/10/2014  |
	|=====================================================================================|
	|Descrição |  STCANCAM      cadastro de campanha de vendas                            |
	|          |                                                                          |
	|          |                                                                          |
	|=====================================================================================|
	|Sintaxe   | STCANCAM                                                                 |
	|=====================================================================================|
	|Uso       | EspecIfico STECK                                                         |
	|=====================================================================================|
	|........................................Histórico....................................|
	\====================================================================================*/
	*-----------------------------*
User Function STVLCAM()
	*-----------------------------*


	M->PPD_LOG  	:= "ITEM INCLUIDO EM: " + DTOC(DDATABASE) + "-" + TIME() + " POR: "+ cUserName + chr(13) + chr(10)+REPLICATE("-",80) + chr(13) + chr(10)
	STCAMMAIL('','',cusername,dtoc(date()),time(),GetMv("ST_CAMMAIL",,""))
	Return (.T.)

	/*====================================================================================\
	|Programa  | STCAMMAIL        | Autor | GIOVANI.ZAGO             | Data | 14/08/2014  |
	|=====================================================================================|
	|Descrição | STCAMMAIL                                                                |
	|          |                                                                          |
	|          |                                                                          |
	|=====================================================================================|
	|Sintaxe   | STCAMMAIL                                                                |
	|=====================================================================================|
	|Uso       | EspecIfico STECK                                                         |
	|=====================================================================================|
	|........................................Histórico....................................|
	\====================================================================================*/
	*------------------------------------------------------------------*
Static Function  STCAMMAIL(_cObs,_cMot,_cName,_cDat,_cHora,_cEmail)
	*------------------------------------------------------------------*

	Local aArea 	:= GetArea()
	Local _cFrom   := "protheus@steck.com.br"//Lower(Alltrim(Posicione("SU7",1,xFilial("SU7")+SC5->C5_OPERADO,"U7_EMAIL")))
	Local _cAssunto:= 'Campanha de Vendas'
	Local cFuncSent:= "STCAMMAIL"
	Local _aMsg    :={}
	Local i        := 0
	Local cArq     := ""
	Local cMsg     := ""
	Local _nLin
	Local _cCopia  := ' '
	Local cAttach  := ''

	default _cEmail  := ""
	If __cUserId = '000000'
		_cEmail  := ""
		_cCopia  := " "
	EndIf

	If ( Type("l410Auto") == "U" .OR. !l410Auto )

		Aadd( _aMsg , { "Numero: "          , M->PPD_NUM    } )
		//	Aadd( _aMsg , { "Grp.Vendas : "  	,  M->PPD_GRPVEN+' - '+M->PPD_NGRPVE} )
		//	Aadd( _aMsg , { "Grp.Produto : "    , M->PPD_GRPPRO+' - '+M->PPD_NGRPPR} )
		//	Aadd( _aMsg , { "Produto : "    	, M->PPD_PRODUT+' - '+M->PPD_NPRODU} )
		Aadd( _aMsg , { "Cliente : "    	, PPE->PPE_CLIENT+'/'+PPE->PPE_LOJA+' - '+PPE->PPE_NOME  } )
		Aadd( _aMsg , { "Dt.Inicio   : "    , Dtoc(M->PPD_INI   ) } )
		Aadd( _aMsg , { "Dt.Fim   : "    	, Dtoc(M->PPD_FIM) } )
		//	Aadd( _aMsg , { "%Desconto  : "    	, TRANSFORM(M->PPD_DESCON,"@E  99.99")  } )
		Aadd( _aMsg , { "Dt. Inclusão: "    , _cDat  } )
		Aadd( _aMsg , { "Usuario: "    		, _cName } )
		Aadd( _aMsg , { "Hora: "    		, _cHora } )

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Definicao do cabecalho do email                                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cMsg := ""
		cMsg += '<html>'
		cMsg += '<head>'
		cMsg += '<title>' + _cAssunto + " - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title>'
		cMsg += '</head>'
		cMsg += '<body>'
		//cMsg += '<Img Src="C:/AP5/SIGAADV/LGRL01.BMP"><BR>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
		cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>' + _cAssunto +" - "+SM0->M0_NOME+"/"+SM0->M0_FILIAL+ '</FONT> </Caption>'
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Definicao do texto/detalhe do email                                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For _nLin := 1 to Len(_aMsg)
			If (_nLin/2) == Int( _nLin/2 )
				cMsg += '<TR BgColor=#B0E2FF>'
			Else
				cMsg += '<TR BgColor=#FFFFFF>'
			EndIf
			cMsg += '<TD><B><Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></B></TD>'
			cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></TD>'
			cMsg += '</TR>'
		Next
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Definicao do rodape do email                                                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cMsg += '</Table>'
		cMsg += '<P>'
		cMsg += '<Table align="center">'
		cMsg += '<tr>'
		cMsg += '<td colspan="10" align="center"><font color="red" size="3">E-mail gerado em: '+ Dtoc(date())+'-'+ Time()+'  - <font color="red" size="1">('+cFuncSent+')</td>'
		cMsg += '</tr>'
		cMsg += '</Table>'
		cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
		//cMsg += '<B><Font Color=#000000 Size="2" Face="Arial"> Atenciosamente </Font></B><BR>'
		//cMsg += '<B><Font Color=#000000 Size="2" Face="Arial">' + SM0->M0_NOMECOM + '</Font></B><BR>'
		//cMsg += '<Img Src="C:/AP5/SIGAADV/LGRL01.BMP">'
		cMsg += '</body>'
		cMsg += '</html>'


		If !(   U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,cAttach) )
			MsgInfo("Email não Enviado..!!!!")

		EndIf
	EndIf
	RestArea(aArea)
	Return()


	/*====================================================================================\
	|Programa  | STCAMPRO         | Autor | GIOVANI.ZAGO             | Data | 27/10/2014  |
	|=====================================================================================|
	|Descrição |  STCAMPRO      cadastro de campanha de vendas                            |
	|          |                                                                          |
	|          |                                                                          |
	|=====================================================================================|
	|Sintaxe   | STCAMPRO                                                                 |
	|=====================================================================================|
	|Uso       | Especifico STECK                                                         |
	|=====================================================================================|
	|........................................Histórico....................................|
	\====================================================================================*/
	*-----------------------------*
User Function STCAMPRO( cAlias, nReg, nOpc )
	*-----------------------------*
	Local i:=0
	Local cLinok :=  "U_XSTLIN2()"
	Local cTudook := "u_Xmd3tudok"
	Local nOpce := 2
	Local nOpcg := 4
	Local cFieldok := "allwaystrue"
	Local lVirtual := .T.
	Local nLinhas := 9999
	Local nFreeze := 0
	Local lRet := .T.
	Private aCols := {}
	Private aHeader := {}
	Private aCpoEnchoice := {}
	Private aAltEnchoice := {}
	Private aAlt := {}
	Private _cUserCamp := GetMv("ST_USRCAM2",," ")
	Private aButtons := {}
	Private oEnchoice, oGetDados

	aAdd(aButtons,{"PMSSETAUP",{|| STFILCOL('2')  },"Localizar"  ,"Localizar"})

	If !Empty(Alltrim(_cUserCamp))
		MsgInfo("Bloqueado pelo Usuario: "+Alltrim(_cUserCamp))
		Return()
	Else
		PutMV("ST_USRCAM2",cUserName)
	EndIf


	If nOpc = 3
		nOpc := 4
	ElseIf nOpc = 5
		nOpc := 3
	ElseIf nOpc = 6
		nOpc := 5
	EndIf
	nOpcg := nopc
	If nOpc == 4
		If PPD_STATUS = '3' .Or. PPD_FIM < DDATABASE
			MsgInfo("Campanha Cancelada/Encerrada não é possivel Alterar")
			Return()
		EndIf
	EndIf

	Regtomemory(cAlias1,(nOpc==3))
	Regtomemory(cAlias3,(nOpc==3))
	XCriaHeader()
	XCriaCols(nOpc)
	lRet:=STMOD3(cCadastro,cAlias1,cAlias3,aCpoEnchoice,cLinok,cTudook,nOpce,;
	nOpcg,cFieldok,lVirtual,nLinhas,aAltenchoice,nFreeze,aButtons)

	If lRet
		//Se opcao for inclusão


		If nOpc == 3

			If MsgYesNo("Confirma gravação dos dados ?",cCadastro)

				Processa({||XGrvdados()},cCadastro,"Gravando os dados, aguarde...")

			EndIf


			//Se opção for alteração


		elseIf nOpc == 4

			If MsgYesNo("Confirma alteração dos dados ?", cCadastro)

				Processa({||XAltdados()},cCadastro,"Alterando os dados, aguarde...")

			EndIf

			//Se opção for exclusão


		elseIf nOpc == 5

			If MsgYesNo("Confirma exclusão dos dados ?", cCadastro)

				Processa({||XExcluidados()},cCadastro,"Excluindo os dados, aguarde...")

			EndIf

		EndIf

	else

		RollbackSx8()

	EndIf
	PutMV("ST_USRCAM2",' ')
	return

	/*====================================================================================\
	|Programa  | CriaHeader       | Autor | GIOVANI.ZAGO             | Data | 27/10/2014  |
	|=====================================================================================|
	|Descrição |  CriaHeader    cadastro de campanha de vendas                            |
	|          |                                                                          |
	|          |                                                                          |
	|=====================================================================================|
	|Sintaxe   | CriaHeader                                                               |
	|=====================================================================================|
	|Uso       | Especifico STECK                                                         |
	|=====================================================================================|
	|........................................Histórico....................................|
	\====================================================================================*/
	*-----------------------------*
Static Function XCriaHeader()
	*-----------------------------*
	aHeader:= {}

	aCpoEnchoice := {}

	aAltEnchoice :={}

	dbselectarea("SX3")

	dbsetorder(1)

	dbseek(cAlias3)

	while ! eof() .and. x3_arquivo == cAlias3

		If x3uso(x3_usado) .and. cnivel >= x3_nivel

			aAdd(aHeader,{trim(x3_titulo),;
			x3_campo,;
			x3_picture,;
			x3_tamanho,;
			x3_decimal,;
			x3_valid,;
			x3_usado,;
			x3_tipo,;
			x3_arquivo,;
			x3_context})

		EndIf

		dbskip()

	enddo

	dbseek(cAlias1)

	while ! eof() .and. x3_arquivo == cAlias1

		If x3uso(x3_usado) .and. cnivel >= x3_nivel
			If Alltrim(x3_campo) $	"PPD_FILIAL/PPD_NUM/PPD_INI/PPD_FIM/PPD_DESCRI"
				aAdd(aCpoEnchoice,x3_campo)

				aAdd(aAltEnchoice,x3_campo)
			EndIf
		EndIf

		dbskip()

	enddo

	return

	/*====================================================================================\
	|Programa  | CriaCols         | Autor | GIOVANI.ZAGO             | Data | 27/10/2014  |
	|=====================================================================================|
	|Descrição |  CriaCols      cadastro de campanha de vendas                            |
	|          |                                                                          |
	|          |                                                                          |
	|=====================================================================================|
	|Sintaxe   | CriaCols                                                                 |
	|=====================================================================================|
	|Uso       | Especifico STECK                                                         |
	|=====================================================================================|
	|........................................Histórico....................................|
	\====================================================================================*/
	*-----------------------------*
Static function XCriaCols(nOpc)
	*-----------------------------*
	Local nQtdcpo := 0
	Local i:= 0
	Local nCols := 0

	nQtdcpo := len(aHeader)

	aCols:= {}

	aAlt := {}

	If nOpc == 3

		aAdd(aCols,array(nQtdcpo+1))

		for i := 1 to nQtdcpo

			aCols[1,i] := Criavar(aHeader[i,2])

		next i

		aCols[1,nQtdcpo+1] := .F.

	else

		dbselectarea(cAlias3)

		dbsetorder(1)

		dbseek(xfilial(cAlias3)+(cAlias1)->PPD_NUM)

		while .not. eof() .and. (cAlias3)->PPG_filial == xfilial(cAlias3) .and. (cAlias3)->PPG_NUM==(cAlias1)->PPD_NUM

			aAdd(aCols,array(nQtdcpo+1))

			nCols++

			for i:= 1 to nQtdcpo

				If aHeader[i,10] <> "V"

					aCols[nCols,i] := Fieldget(Fieldpos(aHeader[i,2]))

				else

					aCols[nCols,i] := Criavar(aHeader[i,2],.T.)

				EndIf

			next i

			aCols[nCols,nQtdcpo+1] := .F.

			aAdd(aAlt,Recno())

			dbselectarea(cAlias3)

			dbskip()

		end

	EndIf
	nOrdem := aScan(aHeader,{|x| Trim(x[2])==('PPG_PROD')})
	aSort(aCols,,,{|x,y| x[nOrdem]<y[nOrdem]})
	return

	/*====================================================================================\
	|Programa  | GrvDados         | Autor | GIOVANI.ZAGO             | Data | 27/10/2014  |
	|=====================================================================================|
	|Descrição |  GrvDados      cadastro de campanha de vendas                            |
	|          |                                                                          |
	|          |                                                                          |
	|=====================================================================================|
	|Sintaxe   | GrvDados                                                                 |
	|=====================================================================================|
	|Uso       | Especifico STECK                                                         |
	|=====================================================================================|
	|........................................Histórico....................................|
	\====================================================================================*/
	*-----------------------------*
Static Function XGrvDados()
	*-----------------------------*
	Local bcampo := {|nfield| field(nfield) }
	Local i:= 0
	Local y:= 0
	Local nItem :=0

	procregua(len(aCols)+fCount())

	dbselectarea(cAlias1)

	Reclock(cAlias1,.T.)

	for i:= 1 to fcount()

		incproc()

		If "FILIAL" $ fieldname(i)

			Fieldput(i,xfilial(cAlias1))

		else

			Fieldput(i,M->&(EVAL(BCAMPO,i)))

		EndIf

	next

	Msunlock()

	dbselectarea(cAlias3)

	dbsetorder(1)

	for i:=1 to len(aCols)

		incproc()

		If .not. aCols[i,len(aHeader)+1]

			Reclock(cAlias3,.T.)

			for y:= 1 to len(aHeader)

				Fieldput(Fieldpos(trim(aHeader[y,2])),aCols[i,y])

			next

			nItem++

			(cAlias3)->PPG_filial := xfilial(cAlias3)

			(cAlias3)->PPG_NUM := (cAlias1)->PPD_NUM

			//	(cAlias3)->z3_item := strzero(nItem,2,0)

			Msunlock()
			
		EndIf

	next

	return
	/*====================================================================================\
	|Programa  | Altdados         | Autor | GIOVANI.ZAGO             | Data | 27/10/2014  |
	|=====================================================================================|
	|Descrição |  Altdados      cadastro de campanha de vendas                            |
	|          |                                                                          |
	|          |                                                                          |
	|=====================================================================================|
	|Sintaxe   | Altdados                                                                 |
	|=====================================================================================|
	|Uso       | Especifico STECK                                                         |
	|=====================================================================================|
	|........................................Histórico....................................|
	\====================================================================================*/
	*-----------------------------*
Static Function XAltdados()
	*-----------------------------*
	Local bcampo := { |nfield| field(nfield) }
	Local i:= 0
	Local y:= 0
	Local nitem := 0

	procregua(len(aCols)+fCount())

	dbselectarea(cAlias1)

	Reclock(cAlias1,.F.)

	for i:= 1 to fcount()

		incproc()

		If "FILIAL" $ fieldname(i)

			Fieldput(i,xfilial(cAlias1))

		else

			Fieldput(i,M->&(EVAL(BCAMPO,i)))

		EndIf

	next i

	Msunlock()

	dbselectarea(cAlias3)

	dbsetorder(1)

	nItem := len(aAlt)+1

	for i:=1 to len(aCols)

		If i<=len(aAlt)

			dbgoto(aAlt[i])

			Reclock(cAlias3,.F.)

			If aCols[i,len(aHeader)+1]

				DbDelete()

			else

				for y:= 1 to len(aHeader)

					Fieldput(Fieldpos(trim(aHeader[y,2])),aCols[i,y])

				next y

			EndIf

			Msunlock()

		else

			If ! aCols[i,len(aHeader)+1]

				Reclock(cAlias3,.T.)

				for y:= 1 to len(aHeader)

					Fieldput(Fieldpos(trim(aHeader[y,2])),aCols[i,y])

				next y

				(cAlias3)->PPG_filial := xfilial(cAlias3)

				(cAlias3)->PPG_NUM := (cAlias1)->PPD_NUM

				//	(cAlias3)->z3_item := strzero(nItem,2,0)

				Msunlock()

				nItem++

			EndIf

		EndIf

	next i

	return

	//&nbsp;

	/*====================================================================================\
	|Programa  | Excluidados      | Autor | GIOVANI.ZAGO             | Data | 27/10/2014  |
	|=====================================================================================|
	|Descrição |  Excluidados   cadastro de campanha de vendas                            |
	|          |                                                                          |
	|          |                                                                          |
	|=====================================================================================|
	|Sintaxe   | Excluidados                                                              |
	|=====================================================================================|
	|Uso       | Especifico STECK                                                         |
	|=====================================================================================|
	|........................................Histórico....................................|
	\====================================================================================*/
	*-----------------------------*
Static Function XExcluidados()
	*-----------------------------*
	procregua(len(aCols)+1)

	dbselectarea(cAlias3)

	dbsetorder(1)

	dbseek(xfilial(cAlias3)+(cAlias1)->PPD_NUM)

	do while .not. eof() .and. (cAlias3)->PPG_FILIAL == xfilial(cAlias3) .and. (cAlias3)->PPG_NUM==(cAlias1)->PPD_NUM

		incproc()

		Reclock(cAlias3,.F.)

		DbDelete()

		Msunlock()

		dbskip()

	enddo

	dbselectarea(cAlias1)

	dbsetorder(1)

	incproc()

	Reclock(cAlias1,.F.)

	DbDelete()

	Msunlock()

	return

	/*====================================================================================\
	|Programa  | Md3TudOk         | Autor | GIOVANI.ZAGO             | Data | 27/10/2014  |
	|=====================================================================================|
	|Descrição |  Md3TudOk      cadastro de campanha de vendas                            |
	|          |                                                                          |
	|          |                                                                          |
	|=====================================================================================|
	|Sintaxe   | Md3TudOk                                                                 |
	|=====================================================================================|
	|Uso       | Especifico STECK                                                         |
	|=====================================================================================|
	|........................................Histórico....................................|
	\====================================================================================*/
	*-----------------------------*
User function XMd3TudOk()
	*-----------------------------*
	Local lRet:= .T.

	Local i:=0

	Local nDel :=0

	for i:=1 to len(aCols)

		If aCols[i,len(aHeader)+1]

			nDel++

		EndIf

	next

	If nDel == len(aCols)

		Msginfo("Para excluir todos os itens, utilize a opção Cancelar",cCadastro)

		lRet := .F.

	EndIf

return(lRet)

User Function XSTLIN ()
	Local _lRet := .t.
	Local i		:= 0

	For i:=1 to len(aCols)

		If !aCols[n,len(aHeader)+1] .AND. !aCols[i,len(aHeader)+1]
			If aCols[i,2] = aCols[n,2]  .and. aCols[i,3] = aCols[n,3]  .And. n <> i  .and. _lRet
				_lRet := .F.
				MsgInfo("Cliente já Cadastrado")
			EndIf
		EndIf

	next i



Return(_lRet)


User Function XSTLIN2 ()
	Local _lRet := .t.
	Local i		:= 0

	For i:=1 to len(aCols)

		If !aCols[n,len(aHeader)+1]  .AND. !aCols[i,len(aHeader)+1]
			If  aCols[i,2] = aCols[n,2]  .and. aCols[i,4] = aCols[n,4]  .and. aCols[i,6] = aCols[n,6]  .And. n <> i .and. _lRet
				_lRet := .F.
				MsgInfo("Produto já Cadastrado")
			EndIf
		EndIf

	next i



Return(_lRet)




Static Function STFILCOL(_cType)
	Local nOrdem := 0
	Local i		 := 0 
	Local nOrdem := 0
	Local aArea  := GetArea()
	Local oDlgEmail
	Local _cVal       :=  Space(15)
	Local lSaida      := .F.
	Local nOpca       :=  0

	While !lSaida
		nOpcao := 0
		DEFINE MSDIALOG oDlgEmail TITLE OemToAnsi("Localizador") From  1,0 To 080,240 Pixel OF oMainWnd

		@ 02,04 SAY "Codigo:" PIXEL OF oDlgEmail
		@ 12,04 MSGet _cVal  Size 55,013  PIXEL OF oDlgEmail
		@ 12,62 Button "Ok"      Size 28,13 Action Eval({||lSaida:=.T.,nOpca:=1,oDlgEmail:End()})  Pixel
		@ 12,92 Button "Cancelar" Size 28,13 Action Eval({||lSaida:=.T.,nOpca:=2,oDlgEmail:End()})  Pixel

		ACTIVATE MSDIALOG oDlgEmail CENTERED
	End

	If nOpca = 1

		If _cType = '1'
			nOrdem := aScan(aHeader,{|x| Trim(x[2])==("PPE_CLIENT")})
		Else
			nOrdem := aScan(aHeader,{|x| Trim(x[2])==("PPG_PROD")})
		EndIf


		For i:=1 to len(aCols)
			If  aCols[i,nOrdem] = Alltrim(_cVal)
				oGetDados:GoTo(i)
				Exit
			EndIf
		next i
	EndIf

return()



Static Function stmod3(cTitulo,cAlias1,cAlias2,aMyEncho,cLinOk,cTudoOk,nOpcE,nOpcG,cFieldOk,lVirtual,nLinhas,aAltEnchoice,nFreeze,aButtons,aCordW,nSizeHeader,aAlGetDad,cIniCpos,cSuperDel,cDelOk)
	Local lRet, nOpca := 0,cSaveMenuh,nReg:=(cAlias1)->(Recno()),oDlg
	Local nDlgHeight   
	Local nDlgWidth
	Local nDiffWidth := 0          
	Local nDiffHeight := 0 
	Local lMDI := .F.      
	Local lPlugin := .F.
	Local nTop := 32
	Local aSize := {}
	Local cTela := ""
	Local aCampos := {}
	Local aFieldFill := {}


	Private Altera:=.t.,Inclui:=.t.,lRefresh:=.t.,aTELA:=Array(0,0),aGets:=Array(0),bCampo:={|nCPO|Field(nCPO)},nPosAnt:=9999,nColAnt:=9999
	Private cSavScrVT,cSavScrVP,cSavScrHT,cSavScrHP,CurLen,nPosAtu:=0

	If IsPlugin() 
		lPlugin := .T.
	EndIf

	nOpcE := If(nOpcE==Nil,3,nOpcE)
	nOpcG := If(nOpcG==Nil,3,nOpcG)
	lVirtual := Iif(lVirtual==Nil,.F.,lVirtual)
	nLinhas:=Iif(nLinhas==Nil,99,nLinhas)

	Default cLinOk	 := "AllwaysTrue"
	Default cTudoOk	 := "AllwaysTrue"
	Default cFieldOk := "AllwaysTrue"

	If SetMDIChild()
		oMainWnd:ReadClientCoors()
		nDlgHeight := oMainWnd:nHeight
		nDlgWidth := oMainWnd:nWidth
		lMdi := .T.
		nDiffWidth := 2
		If lPlugin
			nDiffHeight := 25
		EndIf
	Else           
		If lPlugin
			nDlgHeight := oMainWnd:nHeight-55
			nDlgWidth	:= oMainWnd:nWidth-12
			nDiffHeight := 80
			nTop := 10
		Else		
			nDlgHeight := oMainWnd:nHeight-50
			nDlgWidth	:= oMainWnd:nWidth-27
		Endif
		nDiffWidth := 7
	EndIf

	Default aCordW := {nTop,000,nDlgHeight,nDlgWidth}
	Default nSizeHeader := 110

	Aadd(aSize,nSizeHeader)

	DEFINE MSDIALOG oDlg TITLE cTitulo From aCordW[1],aCordW[2] to aCordW[3],aCordW[4] Pixel of oMainWnd STYLE nOR( WS_VISIBLE, WS_POPUP )
	oDlg:lMaximized := .T.

	oEnchoice := Msmget():New(cAlias1,nReg,nOpcE,,,,aMyEncho,{13,1,(nSizeHeader/2)+13,If(lMdi, (oMainWnd:nWidth/2)-2,__DlgWidth(oDlg)-nDiffWidth)},aAltEnchoice,3,,,,oDlg,,lVirtual,,,,,,,,.F.)       

	oGetDados := MsGetDados():New((nSizeHeader/2)+13+2,1,(oMainWnd:nHeight/2)-nDiffHeight,oMainWnd:nWidth/2-nDiffWidth,nOpcG,cLinOk,cTudoOk,cIniCpos,.T.,aAlGetDad,nFreeze,,nLinhas,cFieldOk,cSuperDel,,cDelOk,oDlg)

	ACTIVATE MSDIALOG oDlg ON INIT (EnchoiceBar(oDlg,{||nOpca:=1,If(oGetDados:TudoOk(),If(!obrigatorio(aGets,aTela),nOpca := 0,oDlg:End()),nOpca := 0)},{||oDlg:End()},,aButtons),AlignObject(oDlg,{oEnchoice:oBox,oGetDados:oBrowse},1,,aSize))

	lRet:=(nOpca==1)
Return lRet
