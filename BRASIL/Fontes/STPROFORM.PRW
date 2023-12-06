#include 'Protheus.ch'
#INCLUDE "PROTHEUS.CH" 
#include 'RwMake.ch'
#include 'Totvs.ch'
#include "TBICONN.CH"
#INCLUDE "TOPCONN.CH"

/*====================================================================================\
|Programa  | STPROFORM        | Autor | GIOVANI.ZAGO             | Data | 27/10/2014  |
|=====================================================================================|
|Descri็ใo |  STPROFORM     cadastro de PRO-FORMA                                     |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STPROFORM                                                                |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Hist๓rico....................................|
\====================================================================================*/
/****************************************
	A็ใo.........: Inibir a valida็ใo da quantidade quando o pedido vier da proforma
	Desenvolvedora: Flแvia Rocha - SIGAMAT
	Data.........: 13/01/2022
	Chamados.....: 20220107000524
****************************************/



*-----------------------------*
User Function STPROFORM()//  U_STPROFORM()
	*-----------------------------*
	Local aArea          := GetArea()
	Local aCores2        := {	;
	{ "PPJ_APROVA = '2'  .and. PPJ_CANCEL <> '1' "	, "ENABLE"   },;
	{ "PPJ_APROVA = '1'  .and. PPJ_CANCEL <> '1' "	, "BR_PRETO" },;
	{ "PPJ_CANCEL = '1' "							,"DISABLE" 	 } }
	Private cCadastro	 := "Pro-Forma"
	Private cAlias1:= "PPJ"
	Private cAlias2:= "PPL"
	Private cAlias3:= " "
	Private aRotina := {;
	{ "Pesquisar"  			 , "PesqBrw" 							, 0 , 1 },;
	{ "Visualizar" 			 , "U_STFORTEL" 						, 0 , 2 },;
	{ "Incluir"   		 	 , "U_STFORTEL" 						, 0 , 3 },;
	{ "Alterar"   		 	 , "U_STFORTEL" 						, 0 , 4 },;
	{ "Cancelar "    		 , "U_STCANFOR" 						, 0 , 5 },;
	{ "Legenda"    			 , "U_STFORLEG" 						, 0 , 6 },;
	{ "Imprimir"   			 , "U_RSTFAT78" 						, 0 , 7 },;
	{ "Gerar pedido" 		 , "U_STPEDPRO" 						, 0 , 8 },;
	{ "Alterar pedido"		 , "U_STPEDALT" 						, 0 , 9 },;
	{ "Tela markup" 		 , "U_STMKPPPL(.T.)" 						, 0 , 10},;
	{ "Tela markup cliente"	 , "U_RSTFATA4()" 						, 0 , 11},;
	{ "Liberar ProForma"	 , "U_STPROF01()" 						, 0 , 12},;
	{ "Zerar pesos"	 		, "U_STPROF02()" 						, 0 , 12}}

	Private _cUserCam  := GetMv("ST_USEPRO",,"000000")+"/000000"
	//U_STZ1B(Upper(cCadastro))//Giovani Zago Log de Acesso 27/03/2017
	Public EEK_SEQ := '  '
	Public EEK_EMB := '  '
	If !(__cUserId $ _cUserCam)
		MsgInfo("Usuario Sem Acesso")  //FR VOLTAR
		Return()		//FR voltar
	EndIf

	nModulo := 29
	cModulo := "EEC"

	DbSelectArea(cAlias1)
	(cAlias1)->(DbSetOrder(1))

	mBrowse( 7, 4,20,74,cAlias1,,,,,,aCores2)

	Restarea(aArea)
	Return()

	/*====================================================================================\
	|Programa  | STFORTEL         | Autor | GIOVANI.ZAGO             | Data | 27/10/2014  |
	|=====================================================================================|
	|Descri็ใo |  STFORTEL      cadastro de campanha de vendas                            |
	|          |                                                                          |
	|          |                                                                          |
	|=====================================================================================|
	|Sintaxe   | STFORTEL                                                                 |
	|=====================================================================================|
	|Uso       | Especifico STECK                                                         |
	|=====================================================================================|
	|........................................Hist๓rico....................................|
	\====================================================================================*/
	*-----------------------------*
User Function STFORTEL( cAlias, nReg, nOpc )
	*-----------------------------*
	Local i			:=0
	Local nOpca		:=0
	Local cLinok 		:= "U_FORLIN()"
	Local cTudook 	:= "u_ForTudOk"
	Local nOpce 		:= 2
	Local nOpcg 		:= nopc
	Local cFieldok 	:= "allwaystrue"
	Local lVirtual 	:= .T.
	Local nLinhas 	:= 9999
	Local nFreeze 	:= 0
	Local aButtons  	:= {}
	Local aCordW    	:= {}
	Local nSizeHeader	:= 300
	Local lRet 			:= .T.
	Local aObjects	:= {}
	Local aInfo		:= {}
	Local aPosObj	:= {}
	Local aSize		:= MsAdvSize()
	Private aCols 	:= {}
	Private aHeader 	:= {}
	Private acpos   	:= {}
	Private aCpoEnchoice 	:= {}
	Private aAltEnchoice 	:= {}
	Private aAlt 			:= {}
	Private _cUserCamp 		:= GetMv("ST_USRCAM1",," ")
	Private oTotal
	Private nTotal := 0
	Public INCLUI   := .F.
	Public ALTERA   := .F.

	If nOpc = 3
		INCLUI   := .T.
	ElseIf nOpc = 4
		ALTERA   := .T.
	EndIf

	nOpcg := nopc
	If nOpc == 4
		If PPJ_CANCEL = '3'
			MsgInfo("Pro-Forma Cancelada/Encerrada nใo ้ possivel Alterar")
			Return()
		EndIf
	EndIf

	Regtomemory('PPJ',(nOpc==3))
	Regtomemory('PPL',(nOpc==3))
	CriaHeader()
	CriaCols(nOpc)
	//lRet:=Modelo3(cCadastro,cAlias1,cAlias2,aCpoEnchoice,cLinok,cTudook,nOpce,;
	//	nOpcg,cFieldok,lVirtual,nLinhas,aAltenchoice,nFreeze,aButtons, ,nSizeHeader)

	AAdd( aObjects, { 100, 450, .T., .T. } )
	AAdd( aObjects, { 200, 200, .T., .T. } )
	aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 5, 5 }
	aPosObj := MsObjSize( aInfo, aObjects,.T.)

	acpos:={'PPL_PRODUT','PPL_QUANT' ,'PPL_PRCVEN', 'PPL_TOTAL', 'PPL_ACRESC', 'PPL_DECRES'}
	DEFINE MSDIALOG oDlg TITLE cCadastro FROM aSize[7],00 TO aSize[6],aSize[5] OF oMainWnd PIXEL

	EnChoice( 'PPJ' ,PPJ->(Recno()), nOpc , , , , aCpoEnchoice, aPosObj[1], aAltEnchoice, 3 )
	oGetDados:=MSNewGetDados():New (aPosObj[2,1], aPosObj[2,2] , aPosObj[2,3], aPosObj[2,4]-215,GD_INSERT + GD_UPDATE + GD_DELETE,cLinOk,cTudoOk	,"+PPL_ITEM"	,acpos	,0,99999,,Len(aCols),,,	aHeader,aCols)

	@ aPosObj[2,1]+020,aPosObj[2,4]-200 say "TOTAL:"   Of odlg Pixel
	@ aPosObj[2,1]+020,aPosObj[2,4]-160 msget oTotal Var nTotal picture "@E 999,999,999.99" when .f. size 55,013  Of odlg Pixel

	ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,{|| nOpca := 1,aCols:=oGetDados:aCols,oDlg:End() },{||oDlg:End()},,aButtons)

	If nOpca = 1
		//Se opcao for inclusใo

		If nOpc == 3

			If MsgYesNo("Confirma grava็ใo dos dados ?",cCadastro)

				Processa({||Grvdados()},cCadastro,"Gravando os dados, aguarde...")
				PPJ->(ConfirmSX8())

				If !U_STMKPPPL(.F.)

					PPJ->(RecLock("PPJ",.F.))
					PPJ->PPJ_STATUS := "B"
					PPJ->(MsUnLock())

					MsgAlert("Essa proforma foi bloqueada, favor solicitar a libera็ใo!")

				EndIf

			EndIf

			//Se op็ใo for altera็ใo

		elseIf nOpc == 4

			If MsgYesNo("Confirma altera็ใo dos dados ?", cCadastro)

				Processa({||Altdados()},cCadastro,"Alterando os dados, aguarde...")

				If !U_STMKPPPL(.F.)

					PPJ->(RecLock("PPJ",.F.))
					PPJ->PPJ_STATUS := "B"
					PPJ->(MsUnLock())

					MsgAlert("Essa proforma foi bloqueada, favor solicitar a libera็ใo!")

				EndIf

			EndIf

			//Se op็ใo for exclusใo

		elseIf nOpc == 5

			If MsgYesNo("Confirma exclusใo dos dados ?", cCadastro)

				Processa({||Excluidados()},cCadastro,"Excluindo os dados, aguarde...")

			EndIf

		EndIf

	else

		If nOpc == 3 //Rollback somente de for inclusใo

			RollbackSx8()

		EndIf

	EndIf

	return

	/*====================================================================================\
	|Programa  | CriaHeader       | Autor | GIOVANI.ZAGO             | Data | 27/10/2014  |
	|=====================================================================================|
	|Descri็ใo |  CriaHeader    cadastro de campanha de vendas                            |
	|          |                                                                          |
	|          |                                                                          |
	|=====================================================================================|
	|Sintaxe   | CriaHeader                                                               |
	|=====================================================================================|
	|Uso       | Especifico STECK                                                         |
	|=====================================================================================|
	|........................................Hist๓rico....................................|
	\====================================================================================*/
	*-----------------------------*
Static Function CriaHeader()
	*-----------------------------*
	aHeader:= {}

	aCpoEnchoice := {}

	aAltEnchoice :={}

	dbselectarea("SX3")
	SX3->(dbsetorder(1))
	SX3->(dbseek('PPL'))

	while !SX3->( eof()) .and. x3_arquivo == 'PPL'

		If x3uso(x3_usado) .and. cnivel >= x3_nivel

			aAdd(aHeader,{ Trim(X3Titulo()), ;
			alltrim(SX3->X3_CAMPO), ;
			SX3->X3_PICTURE , ;
			SX3->X3_TAMANHO , ;
			SX3->X3_DECIMAL , ;
			SX3->X3_VALID   , ;
			SX3->X3_USADO   , ;
			SX3->X3_TIPO    , ;
			SX3->X3_F3,;
			SX3->X3_CONTEXT ,;
			SX3->X3_CBOX,;
			SX3->X3_RELACAO } )

		EndIf

		dbskip()

	enddo

	dbselectarea("SX3")
	SX3->(dbsetorder(1))
	SX3->(dbseek('PPJ'))
	while ! SX3->(eof()) .and. x3_arquivo == 'PPJ'

		If x3uso(x3_usado) .and. cnivel >= x3_nivel
			If !(Alltrim(x3_campo) $	"PPJ_CANCEL/PPJ_APROVA")
				aAdd(aCpoEnchoice,x3_campo)

				aAdd(aAltEnchoice,x3_campo)
			EndIf

		EndIf
		SX3->(dbskip())

	enddo

	return

	/*====================================================================================\
	|Programa  | CriaCols         | Autor | GIOVANI.ZAGO             | Data | 27/10/2014  |
	|=====================================================================================|
	|Descri็ใo |  CriaCols      cadastro de campanha de vendas                            |
	|          |                                                                          |
	|          |                                                                          |
	|=====================================================================================|
	|Sintaxe   | CriaCols                                                                 |
	|=====================================================================================|
	|Uso       | Especifico STECK                                                         |
	|=====================================================================================|
	|........................................Hist๓rico....................................|
	\====================================================================================*/
	*-----------------------------*
Static function CriaCols(nOpc)
	*-----------------------------*
	Local nQtdcpo := 0
	Local i:= 0
	Local nCols := 0
	Local _nPosSaldo	:= Ascan(aHeader,{|x| AllTrim(x[2]) == "PPL_SLDATU" })
	Local _nPosProd		:= Ascan(aHeader,{|x| AllTrim(x[2]) == "PPL_PRODUT" })

	nQtdcpo := len(aHeader)

	aCols:= {}

	aAlt := {}

	If nOpc == 3

		aAdd(aCols,array(nQtdcpo+1))

		for i := 1 to nQtdcpo

			aCols[1,i] := Criavar(aHeader[i,2])

		next i
		aCols[1,1]:= M->PPJ_NUM
		aCols[1,2]:= '001'
		aCols[1,nQtdcpo+1] := .F.

	else

		dbselectarea(cAlias2)

		dbsetorder(1)

		dbseek(xfilial(cAlias2)+(cAlias1)->PPJ_NUM)

		while .not. eof() .And. (cAlias2)->PPL_filial == xfilial(cAlias2) .And. (cAlias2)->PPL_NUM == (cAlias1)->PPJ_NUM

			aAdd(aCols,array(nQtdcpo+1))

			nCols++

			for i:= 1 to nQtdcpo

				If aHeader[i,10] <> "V"

					aCols[nCols,i] := Fieldget(Fieldpos(aHeader[i,2]))

					If i==_nPosSaldo
						aCols[nCols,i]	:= U_STSLDPPL(aCols[nCols,_nPosProd])
					EndIf

				else

					aCols[nCols,i] := Criavar(aHeader[i,2],.T.)

				EndIf

			next i

			nTotal +=(cAlias2)->PPL_TOTAL
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
	|Descri็ใo |  GrvDados      cadastro de campanha de vendas                            |
	|          |                                                                          |
	|          |                                                                          |
	|=====================================================================================|
	|Sintaxe   | GrvDados                                                                 |
	|=====================================================================================|
	|Uso       | Especifico STECK                                                         |
	|=====================================================================================|
	|........................................Hist๓rico....................................|
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
	PPJ->PPJ_APROVA:='1'
	PPJ->PPJ_CANCEL:='2'
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

			(cAlias2)->PPL_filial := xfilial(cAlias2)

			(cAlias2)->PPL_NUM := (cAlias1)->PPJ_NUM

			//	(cAlias2)->z3_item := strzero(nItem,2,0)

			Msunlock()
			
		EndIf

	next

	DbSelectArea("PPL")
	PPL->(DbSetOrder(1))
	PPL->(DbGoTop())
	If PPL->(DbSeek(xFilial("PPJ")+PPJ->PPJ_NUM))

		While PPL->(!Eof()) .And. PPJ->(PPJ_FILIAL+PPJ_NUM)==PPL->(PPL_FILIAL+PPL_NUM)

			If Empty(PPL->PPL_SEQUEN)
				PPL->(RecLock("PPL",.F.))
				PPL->PPL_SEQUEN	:= GETSEQUEN()
				PPL->(MsUnLock())
			EndIf

			PPL->(DbSkip())
		EndDo

	EndIf

	return
	/*====================================================================================\
	|Programa  | Altdados         | Autor | GIOVANI.ZAGO             | Data | 27/10/2014  |
	|=====================================================================================|
	|Descri็ใo |  Altdados      cadastro de campanha de vendas                            |
	|          |                                                                          |
	|          |                                                                          |
	|=====================================================================================|
	|Sintaxe   | Altdados                                                                 |
	|=====================================================================================|
	|Uso       | Especifico STECK                                                         |
	|=====================================================================================|
	|........................................Hist๓rico....................................|
	\====================================================================================*/
	*-----------------------------*
Static Function Altdados()
	*-----------------------------*
	Local bcampo := { |nfield| field(nfield) }
	Local i:= 0
	Local y:= 0
	Local nitem := 0
	Local _nPosNum	:= Ascan(aHeader,{|x| AllTrim(x[2]) == "PPL_NUM"  })
	Local _nPosItem	:= Ascan(aHeader,{|x| AllTrim(x[2]) == "PPL_ITEM" })

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
	PPJ->PPJ_APROVA:='1'
	PPJ->PPJ_CANCEL:='2'
	Msunlock()

	dbselectarea(cAlias2)

	dbsetorder(1)

	nItem := len(aAlt)+1

	for i:=1 to len(aCols)

		If i<=len(aAlt)

			//dbgoto(aAlt[i])
			DbSeek(xFilial("PPL")+aCols[i][_nPosNum]+aCols[i][_nPosItem])

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

				(cAlias2)->PPL_filial := xfilial(calias2)

				(cAlias2)->PPL_NUM := (cAlias1)->PPJ_NUM

				//	(cAlias2)->z3_item := strzero(nItem,2,0)

				Msunlock()
				

				nItem++

			EndIf

		EndIf

	next i

	DbSelectArea("PPL")
	PPL->(DbSetOrder(1))
	PPL->(DbGoTop())
	If PPL->(DbSeek(xFilial("PPJ")+PPJ->PPJ_NUM))

		While PPL->(!Eof()) .And. PPJ->(PPJ_FILIAL+PPJ_NUM)==PPL->(PPL_FILIAL+PPL_NUM)

			If Empty(PPL->PPL_SEQUEN)
				PPL->(RecLock("PPL",.F.))
				PPL->PPL_SEQUEN	:= GETSEQUEN()
				PPL->(MsUnLock())
			EndIf

			PPL->(DbSkip())
		EndDo

	EndIf

	return

	//&nbsp;

	/*====================================================================================\
	|Programa  | Excluidados      | Autor | GIOVANI.ZAGO             | Data | 27/10/2014  |
	|=====================================================================================|
	|Descri็ใo |  Excluidados   cadastro de campanha de vendas                            |
	|          |                                                                          |
	|          |                                                                          |
	|=====================================================================================|
	|Sintaxe   | Excluidados                                                              |
	|=====================================================================================|
	|Uso       | Especifico STECK                                                         |
	|=====================================================================================|
	|........................................Hist๓rico....................................|
	\====================================================================================*/
	*-----------------------------*
Static Function Excluidados()
	*-----------------------------*
	procregua(len(aCols)+1)

	dbselectarea(cAlias2)

	dbsetorder(1)

	dbseek(xfilial(cAlias2)+(cAlias1)->PPJ_NUM)

	do while .not. eof() .and. (cAlias2)->PPL_FILIAL == xfilial(cAlias2) .and. (cAlias2)->PPL_NUM ==(cAlias1)->PPJ_NUM

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
	|Descri็ใo |  Md3TudOk      cadastro de campanha de vendas                            |
	|          |                                                                          |
	|          |                                                                          |
	|=====================================================================================|
	|Sintaxe   | Md3TudOk                                                                 |
	|=====================================================================================|
	|Uso       | Especifico STECK                                                         |
	|=====================================================================================|
	|........................................Hist๓rico....................................|
	\====================================================================================*/
	*-----------------------------*
User function ForTudOk()
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

		Msginfo("Para excluir todos os itens, utilize a op็ใo Cancelar",cCadastro)

		lRet := .F.

	EndIf

	If Empty(PPJ->PPJ_XB2B)
		lRet	:= .F.
		MsgAlert("Favor preencher o campo B2B")
	EndIf

	return(lRet)

	/*====================================================================================\
	|Programa  | STCAMLEG         | Autor | GIOVANI.ZAGO             | Data | 27/10/2014  |
	|=====================================================================================|
	|Descri็ใo |  STCAMLEG      cadastro de campanha de vendas                            |
	|          |                                                                          |
	|          |                                                                          |
	|=====================================================================================|
	|Sintaxe   | STCAMLEG                                                                 |
	|=====================================================================================|
	|Uso       | EspecIfico STECK                                                         |
	|=====================================================================================|
	|........................................Hist๓rico....................................|
	\====================================================================================*/
	*-----------------------------*
User Function STFORLEG()
	*-----------------------------*
	Local aCorDesc
	aCorDesc := {  ;
	{ "ENABLE"	,	"Liberado" 	},;
	{ "BR_PRETO",	"Bloqueado" },;
	{ "DISABLE"	,	"Cancelado" }}
	BrwLegenda( "Legenda", "Status", aCorDesc )
	Return

	/*====================================================================================\
	|Programa  | STCANCAM         | Autor | GIOVANI.ZAGO             | Data | 27/10/2014  |
	|=====================================================================================|
	|Descri็ใo |  STCANCAM      cadastro de campanha de vendas                            |
	|          |                                                                          |
	|          |                                                                          |
	|=====================================================================================|
	|Sintaxe   | STCANCAM                                                                 |
	|=====================================================================================|
	|Uso       | EspecIfico STECK                                                         |
	|=====================================================================================|
	|........................................Hist๓rico....................................|
	\====================================================================================*/
	*-----------------------------*
User Function STCANFOR()
	*-----------------------------*
	Private _cUserCam  := GetMv("ST_USEPRO",,"000000")+"/000000"
	If !(__cUserId $ _cUserCam)
		MsgInfo("Usuario Sem Acesso")
		Return()
	EndIf
	If MsgYesNo("Deseja Cancelar Esta Pr๓-Forma?")

		PPJ->(RecLock("PPJ",.F.))
		PPJ->PPJ_HISTOR  	:= PPJ->PPJ_HISTOR +  "ITEM CANCELADO EM: " + DTOC(DDATABASE) + "-" + TIME() + " POR: "+ cUserName + chr(13) + chr(10)+REPLICATE("-",80) + chr(13) + chr(10)
		PPJ->PPJ_CANCEL := '1'
		PPJ->(Msunlock("PPJ"))
		PPJ->( DbCommit() )

	EndIf
	Return

	/*====================================================================================\
	|Programa  | STCANCAM         | Autor | GIOVANI.ZAGO             | Data | 27/10/2014  |
	|=====================================================================================|
	|Descri็ใo |  STCANCAM      cadastro de campanha de vendas                            |
	|          |                                                                          |
	|          |                                                                          |
	|=====================================================================================|
	|Sintaxe   | STCANCAM                                                                 |
	|=====================================================================================|
	|Uso       | EspecIfico STECK                                                         |
	|=====================================================================================|
	|........................................Hist๓rico....................................|
	\====================================================================================*/
	*-----------------------------*
User Function STVLFOR()
	*-----------------------------*

	//	M->PPD_LOG  	:= "ITEM INCLUIDO EM: " + DTOC(DDATABASE) + "-" + TIME() + " POR: "+ cUserName + chr(13) + chr(10)+REPLICATE("-",80) + chr(13) + chr(10)
	
	Return (.T.)

	/*====================================================================================\
	|Programa  | STCAMMAIL        | Autor | GIOVANI.ZAGO             | Data | 14/08/2014  |
	|=====================================================================================|
	|Descri็ใo | STCAMMAIL                                                                |
	|          |                                                                          |
	|          |                                                                          |
	|=====================================================================================|
	|Sintaxe   | STCAMMAIL                                                                |
	|=====================================================================================|
	|Uso       | EspecIfico STECK                                                         |
	|=====================================================================================|
	|........................................Hist๓rico....................................|
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
	Local _cCopia  := ""
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
		Aadd( _aMsg , { "Cliente : "    	, PPJ->PPJ_CLIENT+'/'+PPJ->PPJ_LOJA+' - '+PPJ->PPJ_NOME  } )
		Aadd( _aMsg , { "Dt.Inicio   : "    , Dtoc(M->PPD_INI   ) } )
		Aadd( _aMsg , { "Dt.Fim   : "    	, Dtoc(M->PPD_FIM) } )
		//	Aadd( _aMsg , { "%Desconto  : "    	, TRANSFORM(M->PPD_DESCON,"@E  99.99")  } )
		Aadd( _aMsg , { "Dt. Inclusใo: "    , _cDat  } )
		Aadd( _aMsg , { "Usuario: "    		, _cName } )
		Aadd( _aMsg , { "Hora: "    		, _cHora } )

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Definicao do cabecalho do email                                             ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
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
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Definicao do texto/detalhe do email                                         ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
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
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Definicao do rodape do email                                                ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
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

		U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,cAttach)

	EndIf
	RestArea(aArea)
Return()

User Function FORLIN ()
	Local _lRet := .t.
	Local i:= 1
	If !aCols[n,len(aHeader)+1]
		If  Empty(Alltrim(aCols[n,3] ))
			_lRet := .F.
			MsgInfo("Digite um Produto...!!!")
		EndIf
	EndIf
	For i:=1 to len(aCols)

		If !aCols[n,len(aHeader)+1] .AND. !aCols[i,len(aHeader)+1]
			If  aCols[i,3] = aCols[n,3]  .And. n <> i  .and. _lRet
				_lRet := .F.
				MsgInfo("Produto jแ Cadastrado...!!!!")
			EndIf
		EndIf

	next

Return(_lRet)

User Function STPROSX7 (_cCamp)
	Local _lRet := .F.
	Local i:= 1
	nTotal:=0
	If _cCamp = '1'
		aCols[n,7] := round(aCols[n,5]*aCols[n,6],2)
	Else
		aCols[n,6] := round(aCols[n,7]/aCols[n,5],2)
		aCols[n,7] := round(aCols[n,5]*aCols[n,6],2)
	EndIf

	For i:=1 to len(aCols)

		If  !aCols[i,len(aHeader)+1]

			nTotal+=aCols[i,7]

		EndIf

	next
	OTotal:Refresh()
	oDlg:Refresh()

Return(_lRet)

/*====================================================================================\
|Programa  | STPEDPRO         | Autor | RENATO.NOGUEIRA          | Data | 13/08/2015  |
|=====================================================================================|
|Descri็ใo |  STPEDPRO     Gera็ใo de pedido de venda                                 |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STPEDPRO                                                                 |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Hist๓rico....................................|
\====================================================================================*/

User Function STPEDPRO()

	Local aCabec			:= {}
	Local _cVend2			:= ""
	Local _nQtdItem			:= 0
	Local _nPreco			:= 0
	Local _cX				:= "     0"
	Local _cItem			:= ""
	Local _nSaldo			:= 0
	Local _nValLiqPrd		:= 0
	Local _nValLiqTot		:= 0
	Local _aAreaSA1			:= {}
	Local _aItens			:= {}
	Local _cCfop			:= ""
	Local _cVia				:= ""
	Local _cTipTra			:= ""
	Local _cEmail  			:= GetMv("ST_EMLPROF")
	Local _cCopia  			:= ""
	Local _cAssunto			:= ""
	Local cMsg	   			:= ""
	Local cAttach  			:= ''
	Local _aAttach 			:= {}
	Local _cCaminho 		:= ''
	Local _aEmail			:= {}
	Local cEE7PEDFAT		:= ""
	Private lMsErroAuto  	:= .F.
	Private lMsHelpAuto  	:= .T.
	Private cZConsumo		:= ""
	Private nAliqICM		:= 0
	Private nValICms		:= 0
	Private nAliqIPI		:= 0
	Private nValIPI			:= 0
	Private nValICMSST		:= 0
	Private nValPis			:= 0
	Private nValCof			:= 0
	Private cC5XTipo    	:= ""

	If !Empty(PPJ->PPJ_PEDVEN)
		MsgAlert("Pedido jแ gerado para esta proforma")
		Return
	EndIf

	If Empty(PPJ->PPJ_XB2B)
		MsgAlert("Favor preencher o campo B2B")
		Return
	EndIf

	If Empty(PPJ->PPJ_XAMOST)
		MsgAlert("Favor preencher o campo amostra")
		Return
	EndIf

	DbSelectArea("SA1")
	SA1->(DbSetOrder(1))
	SA1->(DbGoTop())
	If !SA1->(DbSeek(xFilial("SA1")+PPJ->(PPJ_CLIENT+PPJ_LOJA)))
		MsgAlert("Aten็ใo, cliente nใo encontrado, verifique!")
		Return
	EndIf

	_aAreaSA1	:= SA1->(GetArea())

	If AllTrim(PPJ->PPJ_STATUS)=="B"
		MsgAlert("Proforma bloqueada, solicite a libera็ใo caso queira continuar!")
		Return()
	EndIf

	Do Case
		Case PPJ->PPJ_MODAL=="1"
		_cVia		:= "7 "
		_cTipTra	:= "3"
		Case PPJ->PPJ_MODAL=="2"
		_cVia		:= "01"
		_cTipTra	:= "3"
		Case PPJ->PPJ_MODAL=="3"
		_cVia		:= "03"
		_cTipTra	:= "3"
		Case PPJ->PPJ_MODAL=="4"
		_cVia		:= "02"
		_cTipTra	:= "2"
	EndCase

	aAdd(aCabec, {"EE7_IMPORT"	,PPJ->PPJ_CLIENT													,Nil})
	aAdd(aCabec, {"EE7_IMLOJA"	,PPJ->PPJ_LOJA														,Nil})
	aAdd(aCabec, {"EE7_FORN"	,"005764"															,Nil})
	aAdd(aCabec, {"EE7_FOLOJA"	,"02"																,Nil})
	aAdd(aCabec, {"EE7_IDIOMA"	,PPJ->PPJ_IDIOMA													,Nil})
	aAdd(aCabec, {"EE7_CONDPA"	,PPJ->PPJ_CONDPA													,Nil})
	aAdd(aCabec, {"EE7_MPGEXP"	,Posicione("SY6",1,xFilial("SY6")+PPJ->PPJ_CONDPA,"Y6_MDPGEXP")	 	,Nil})
	aAdd(aCabec, {"EE7_INCOTE"	,PPJ->PPJ_INCOTE													,Nil})
	aAdd(aCabec, {"EE7_MOEDA"	,PPJ->PPJ_XMOEDA													,Nil})
	aAdd(aCabec, {"EE7_FRPPCC"	,Posicione("SYJ",1,xFilial("SYJ")+PPJ->PPJ_INCOTE,"YJ_FRPPCC")		,Nil})
	aAdd(aCabec, {"EE7_VIA"		,_cVia   															,Nil})
	aAdd(aCabec, {"EE7_ORIGEM"	,PPJ->PPJ_ORIGEM													,Nil})
	aAdd(aCabec, {"EE7_DEST"	,PPJ->PPJ_DEST  													,Nil})
	aAdd(aCabec, {"EE7_TIPTRA"	,Posicione("SYR",2,xFilial("SYR")+PADR(_cVia,2)+PPJ->(PPJ_DEST+PPJ_ORIGEM),"YR_TIPTRAN")															,Nil})
	aAdd(aCabec, {"EE7_PAISET"	,SA1->A1_PAIS														,Nil})
	//aAdd(aCabec, {"EE7_XTIPO"	,"1"																,Nil})  //FR - 10/01/2022 - TICKET #20220107000524
	aAdd(aCabec, {"EE7_AMOSTR"	,PPJ->PPJ_XAMOST													,Nil})
	aAdd(aCabec, {"EE7_REFIMP"	,PPJ->PPJ_XREFIM													,Nil})
	aAdd(aCabec, {"EE7_XSEQUE"	,PPJ->PPJ_XSEQUE													,Nil})
	aAdd(aCabec, {"EE7_XTIPO"	,PPJ->PPJ_ENTREG													,Nil})  //FR - 10/01/2022 - TICKET #20220107000524
	//aAdd(aCabec, {"C5_XTIPO"	,PPJ->PPJ_ENTREG													,Nil})  //FR - 10/01/2022 - TICKET #20220107000524
	cC5XTipo    := PPJ->PPJ_ENTREG
	

	If PPJ->PPJ_XB2B=="S"
		aAdd(aCabec, {"EE7_TIPO"	,"4"															,Nil})
	EndIf

	DbSelectArea("PPL")
	PPL->(DbSetOrder(1))
	PPL->(DbGoTop())
	PPL->(DbSeek(xFilial("PPL")+PPJ->PPJ_NUM))

	While PPL->(!Eof()) .And. PPJ->(PPJ_FILIAL+PPJ_NUM)==PPL->(PPL_FILIAL+PPL_NUM)

		DbSelectArea("SB1")
		SB1->(DbSetOrder(1))
		SB1->(DbGoTop())
		SB1->(DbSeek(xFilial("SB1")+PPL->PPL_PRODUT))

		Aadd(_aItens ,{	{"EE8_SEQUEN"	,PPL->PPL_SEQUEN													,Nil},;
		{"EE8_COD_I"					,PPL->PPL_PRODUT													,Nil},;
		{"EE8_FORN"   					,"005764"															,Nil},;
		{"EE8_FOLOJA"					,"02"																,Nil},;
		{"EE8_SLDINI"					,PPL->PPL_QUANT														,Nil},;
		{"EE8_EMBAL1"					,"S850LI"															,Nil},;
		{"EE8_PSLQUN"					,IIf(SB1->B1_PESO>0,SB1->B1_PESO,1)									,Nil},;
		{"EE8_QE"						,IIf(SB1->B1_QE>0,SB1->B1_QE,1)										,Nil},;
		{"EE8_TES"						,IIf(PPJ->PPJ_XEXPS="1","857",IIf(SB1->B1_CLAPROD="F","676","728"))	,Nil},;
		{"EE8_CF"						,IIf(PPJ->PPJ_XEXPS="1","7949",IIf(PPJ->PPJ_XAMOST="1","7949",IIf(SB1->B1_CLAPROD="F","7101","7102")))									,Nil},;
		{"EE8_PRECO"					,PPL->PPL_PRCVEN													,Nil}})

		AADD(_aEmail,{PPL->PPL_SEQUEN,;
		PPL->PPL_PRODUT,;
		AllTrim(SB1->B1_DESC),;
		PPL->PPL_QUANT,;
		PPL->PPL_PRCVEN})

		PPL->(DbSkip())

	EndDo

	ALERTAS(PPJ->PPJ_NUM)

	//Begin Transaction
	lMsErroAuto	:= .F.
	MsExecAuto({|x, y, z| EECAP100(x, y, z)}, aCabec, _aItens,3)
	//End Transaction

	If lMsErroAuto
		MostraErro()
		DisarmTransaction()
		EE7->(RollBackSX8())
	Else
		EE7->(ConfirmSX8())

		PPJ->(RecLock("PPJ",.F.))
		PPJ->PPJ_PEDVEN	:= EE7->EE7_PEDIDO
		PPJ->(MsUnLock())

		cMsg	:= LISTARITENS(_aEmail)
		_cAssunto	:= "[WFPROTHEUS] Proforma: "+PPJ->PPJ_NUM+" gerou o pedido: "+AllTrim(PPJ->PPJ_PEDVEN)+" (inclusใo)"
		
		//MsgAlert("Pedido "+Alltrim(EE7->EE7_PEDFAT)+" incluido com sucesso!")
		/****************************************
		A็ใo.........: Melhorar a msg aviso ao final da gera็ใo, pois estava mostrando vazio o pedido de venda qdo nใo houve gera็ใo
		Desenvolvedora: Flแvia Rocha - SIGAMAT
		Data.........: 13/01/2022 
		Chamados.....: 20220107000524
		****************************************/
		cEE7PEDFAT  := Alltrim(EE7->EE7_PEDFAT)

		If Empty(cEE7PEDFAT)			
			cEE7PEDFAT := "---"			
		Endif

		MsgAlert("Pedido "+ Alltrim(cEE7PEDFAT)+" incluido com sucesso!") 

		If !U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,_cCaminho)
			MsgAlert("Problemas no envio de email!")
		EndIf

	EndIf

Return()

/*====================================================================================\
|Programa  | STMKPPPL         | Autor | RENATO.NOGUEIRA          | Data | 13/08/2015  |
|=====================================================================================|
|Descri็ใo |  STPEDPRO     Gera็ใo de pedido de venda                                 |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STPEDPRO                                                                 |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Hist๓rico....................................|
\====================================================================================*/

User Function STMKPPPL(_lTela)

	Local _aRet 		:= {}
	Local _aParamBox 	:= {}
	Local aCampoEdit	:= {}
	Local lSaida 		:= .T.
	Local _aCols		:= {}
	Local bOk 			:= {||(	lSaida:=.f., lConfirma:=.T.,oDlg:End()) }
	Local bCancel		:= {||(	lSaida:=.f.,oDlg:End()) }
	Local aButtons	:= {}
	Local oGet
	Local _aStruTrb 	:= {} //estrutura do temporario
	Local oDlg
	Local _lCriou
	Local oOk   	   	:= LoadBitmap( GetResources(), "LBOK" )
	Local oNo	      	:= LoadBitmap( GetResources(), "LBNO" )
	Local oLbx
	Local nValCusto		:= 0
	Local _n01		:= 0
	Local _n02		:= 0
	Local nY := 1
	Local _lRet := .T.
	Default _lTela := .T.

	AADD(_aStruTrb,{"Item"		,"ITEM"		,"@!"					,03, ,,,"C","","R",})
	AADD(_aStruTrb,{"Produto"	,"PRODUTO"	,"@!"					,15, ,,,"C","","R",})
	AADD(_aStruTrb,{"Descri็ใo"	,"DESCRI"	,"@!"					,50, ,,,"C","","R",})
	AADD(_aStruTrb,{"QUANTIDADE","QUANT"	,"@E 99,999,999,999.99"	,14,2,,,"N","","R",})
	AADD(_aStruTrb,{"Pre็o"		,"PRECO"	,"@E 99,999,999,999.99"	,14,2,,,"N","","R",})
	AADD(_aStruTrb,{"Custo"		,"CUSTO"	,"@E 99,999,999,999.99"	,14,2,,,"N","","R",})
	AADD(_aStruTrb,{"Taxa"		,"TAXA"		,"@E 99,999,999.99999"	,14,5,,,"N","","R",})
	AADD(_aStruTrb,{"Markup"	,"MARKUP"	,"@E 99,999,999,999.99"	,14,2,,,"N","","R",})
	AADD(_aStruTrb,{"Prc.Tot."	,"PRC.TOT"	,"@E 99,999,999,999.99"	,14,2,,,"N","","R",})
	AADD(_aStruTrb,{"Cus.Tot"	,"CUSTO.TOT","@E 99,999,999,999.99"	,14,2,,,"N","","R",})

	cQuery := " SELECT PPL_ITEM ITEM, PPL_PRODUT PRODUTO, B1_DESC DESCRI, PPL_PRCVEN PRECO, B1_XCUSCHI CUSTO ,PPL_QUANT QUANT "
	cQuery += " FROM "+RetSqlName("PPL")+" PPL "
	cQuery += " LEFT JOIN "+RetSqlName("SB1")+" B1 "
	cQuery += " ON PPL_PRODUT=B1_COD "
	cQuery += " WHERE PPL.D_E_L_E_T_=' ' AND B1.D_E_L_E_T_=' ' AND PPL_NUM='"+PPJ->PPJ_NUM+"' "
	cQuery += " ORDER BY PPL_ITEM "

	AADD(_aParamBox,{1,"Taxa",0,"@E 99,999,999.99999","","","",0,.T.})

	If !_lTela
		MV_PAR01 := 1
	Else
		If !ParamBox(_aParamBox,"Taxa",@_aRet,,,.T.,,500)
			Return()
		EndIf
	EndIf

	cAlias :=	GetNextAlias()
	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAlias)

	While (cAlias)->(!Eof())

		AADD(_aCols,Array(Len(_aStruTrb)+1))

		nValCusto	:=	Iif((cAlias)->CUSTO>0,(cAlias)->CUSTO,U_STCUSTO((cAlias)->PRODUTO)/MV_PAR01)

		For nY := 1 To Len(_aStruTrb)

			DO CASE
				CASE AllTrim(_aStruTrb[nY][2]) =  "ITEM"
				_aCols[Len(_aCols)][nY] := (cAlias)->ITEM
				CASE AllTrim(_aStruTrb[nY][2]) =  "PRODUTO"
				_aCols[Len(_aCols)][nY] := (cAlias)->PRODUTO
				CASE AllTrim(_aStruTrb[nY][2]) =  "DESC"
				_aCols[Len(_aCols)][nY] := (cAlias)->DESCRI
				CASE AllTrim(_aStruTrb[nY][2]) =  "PRECO"
				_aCols[Len(_aCols)][nY] := (cAlias)->PRECO
				CASE AllTrim(_aStruTrb[nY][2]) =  "QUANT"
				_aCols[Len(_aCols)][nY] := (cAlias)->QUANT
				CASE AllTrim(_aStruTrb[nY][2]) =  "PRC.TOT"
				_aCols[Len(_aCols)][nY] := (cAlias)->PRECO*(cAlias)->QUANT
				CASE AllTrim(_aStruTrb[nY][2]) =  "CUSTO.TOT"
				_aCols[Len(_aCols)][nY] := nValCusto*(cAlias)->QUANT
				CASE AllTrim(_aStruTrb[nY][2]) =  "CUSTO"
				_aCols[Len(_aCols)][nY] := nValCusto
				CASE AllTrim(_aStruTrb[nY][2]) =  "TAXA"
				_aCols[Len(_aCols)][nY] := MV_PAR01
				CASE AllTrim(_aStruTrb[nY][2]) =  "MARKUP"
				_aCols[Len(_aCols)][nY] := ((cAlias)->PRECO-nValCusto)/nValCusto

				_n01+=(cAlias)->PRECO * (cAlias)->QUANT
				_n02+= nValCusto * (cAlias)->QUANT
			ENDCASE

		Next

		_aCols[Len(_aCols)][Len(_aStruTrb)+1] := .F.

		(cAlias)->(DbSkip())
	EndDo
	AADD(_aCols,Array(Len(_aStruTrb)+1))

	_nMarkTot := (_n01-_n02)/_n02

	If _nMarkTot<0.45
		_lRet := .F.
	EndIf

	_aCols[Len(_aCols)][02] := 'Total'
	_aCols[Len(_aCols)][08] := _nMarkTot
	_aCols[Len(_aCols)][09] :=  _n01
	_aCols[Len(_aCols)][10] :=  _n02
	_aCols[Len(_aCols)][Len(_aStruTrb)+1] := .F.

	aCampoEdit := {"OK"}

	If _lTela
		While lSaida
			DEFINE MSDIALOG oDlg FROM 0,0 TO 900,1430/*500,1200*/ TITLE Alltrim(OemToAnsi('Markup')) Pixel //430,531

			oGet	:= MsNewGetDados():New( 30,  2,  450,710, /*GD_UPDATE*/ ,"AllWaysTrue()","AllWaysTrue()",,aCampoEdit,,Len(_aCols),,, ,oDlg, _aStruTrb, _aCols )
			//MsNewGetDados():SetEditLine (.T.)

			ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,bOk,bCancel,,aButtons)
		End
	EndIf

Return(_lRet)

/*====================================================================================\
|Programa  | STPEDALT         | Autor | RENATO.NOGUEIRA          | Data | 13/08/2015  |
|=====================================================================================|
|Descri็ใo |  STPEDALT     Altera็ใo de pedido de venda                                 |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STPEDPRO                                                                 |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Hist๓rico....................................|
\====================================================================================*/

User Function STPEDALT()
	Local lRet	:= .T.
	Local aCabec	:= {}
	Local _aItens		:= {}
	Local _cEmail  				:= GetMv("ST_EMLPROF")
	Local _cCopia  				:= ""
	Local _cAssunto				:= ""
	Local cMsg	   					:= ""
	Local cAttach  				:= ''
	Local _aAttach 				:= {}
	Local _nX:=1
	Local _cCaminho 				:= ''
	Local _aEmail					:= {}
	Local _cQuery1	:= ""
	Local _cAlias1  := GetNextAlias()
	Private lMsErroAuto  := .F.
	Private lMsHelpAuto  := .T.

	If !(Empty(PPJ->PPJ_PEDVEN))

		DbSelectArea("EE7")
		EE7->(DbSetOrder(1))
		If EE7->(DbSeek(xFilial("EE7")+AvKey(PPJ->PPJ_PEDVEN,"EE7_PEDIDO")))

			DbSelectArea("SC9")
			SC9->(dbSetOrder(1))
			If	SC9->(dbSeek(xFilial("SC9")+EE7->EE7_PEDFAT))

				While !SC9->(Eof()) .And. EE7->EE7_FILIAL+EE7->EE7_PEDFAT == SC9->C9_FILIAL+SC9->C9_PEDIDO

					If !Empty(SC9->C9_ORDSEP)
						lRet	:= .F.
					EndIf

					SC9->(DbSkip())

				EndDo

				If lRet==.F.
					MsgAlert("Este pedido jแ possui ordem de separa็ใo amarrada e nใo pode ser alterado!")
					Return
				EndIf
			EndIf
		EndIf
	EndIf
	If !MsgYesNo("Deseja enviar a altera็ใo dessa proforma?")
		Return
	EndIf

	If Empty(PPJ->PPJ_PEDVEN)
		MsgAlert("Pedido ainda nใo gerado para esta proforma")
		Return
	EndIf

	If Empty(PPJ->PPJ_XB2B)
		MsgAlert("Favor preencher o campo B2B")
		Return
	EndIf

	If Empty(PPJ->PPJ_XAMOST)
		MsgAlert("Favor preencher o campo amostra")
		Return
	EndIf

	DbSelectArea("SA1")
	SA1->(DbSetOrder(1))
	SA1->(DbGoTop())
	If !SA1->(DbSeek(xFilial("SA1")+PPJ->(PPJ_CLIENT+PPJ_LOJA)))
		MsgAlert("Aten็ใo, cliente nใo encontrado, verifique!")
		Return
	EndIf

	_aAreaSA1	:= SA1->(GetArea())

	If AllTrim(PPJ->PPJ_STATUS)=="B"
		MsgAlert("Proforma bloqueada, solicite a libera็ใo caso queira continuar!")
		Return()
	EndIf

	Do Case
		Case PPJ->PPJ_MODAL=="1"
		_cVia		:= "7 "
		_cTipTra	:= "3"
		Case PPJ->PPJ_MODAL=="2"
		_cVia		:= "01"
		_cTipTra	:= "3"
		Case PPJ->PPJ_MODAL=="3"
		_cVia		:= "03"
		_cTipTra	:= "3"
		Case PPJ->PPJ_MODAL=="4"
		_cVia		:= "02"
		_cTipTra	:= "2"
	EndCase

	aAdd(aCabec, {"EE7_FILIAL"	,PPJ->PPJ_FILIAL													,Nil})
	aAdd(aCabec, {"EE7_PEDIDO"	,PPJ->PPJ_PEDVEN													,Nil})
	aAdd(aCabec, {"EE7_IMPORT"	,PPJ->PPJ_CLIENT													,Nil})
	aAdd(aCabec, {"EE7_IMLOJA"	,PPJ->PPJ_LOJA														,Nil})
	aAdd(aCabec, {"EE7_FORN"	,"005764"															,Nil})
	aAdd(aCabec, {"EE7_FOLOJA"	,"02"																,Nil})
	aAdd(aCabec, {"EE7_IDIOMA"	,PPJ->PPJ_IDIOMA													,Nil})
	aAdd(aCabec, {"EE7_CONDPA"	,PPJ->PPJ_CONDPA													,Nil})
	aAdd(aCabec, {"EE7_MPGEXP"	,Posicione("SY6",1,xFilial("SY6")+PPJ->PPJ_CONDPA,"Y6_MDPGEXP")	 	,Nil})
	aAdd(aCabec, {"EE7_INCOTE"	,PPJ->PPJ_INCOTE													,Nil})
	aAdd(aCabec, {"EE7_MOEDA"	,PPJ->PPJ_XMOEDA													,Nil})
	aAdd(aCabec, {"EE7_FRPPCC"	,Posicione("SYJ",1,xFilial("SYJ")+PPJ->PPJ_INCOTE,"YJ_FRPPCC")		,Nil})
	aAdd(aCabec, {"EE7_VIA"		,_cVia   															,Nil})
	aAdd(aCabec, {"EE7_ORIGEM"	,PPJ->PPJ_ORIGEM													,Nil})
	aAdd(aCabec, {"EE7_DEST"	,PPJ->PPJ_DEST  													,Nil})
	aAdd(aCabec, {"EE7_TIPTRA"	,Posicione("SYR",2,xFilial("SYR")+PADR(_cVia,2)+PPJ->(PPJ_DEST+PPJ_ORIGEM),"YR_TIPTRAN")															,Nil})
	aAdd(aCabec, {"EE7_PAISET"	,SA1->A1_PAIS														,Nil})
	aAdd(aCabec, {"EE7_XTIPO"	,"1"																,Nil})
	aAdd(aCabec, {"EE7_AMOSTR"	,PPJ->PPJ_XAMOST													,Nil})
	aAdd(aCabec, {"EE7_REFIMP"	,PPJ->PPJ_XREFIM													,Nil})
	//aAdd(aCabec, {"EE7_XSEQUE"	,PPJ->PPJ_XSEQUE													,Nil})

	If PPJ->PPJ_XB2B=="S"
		aAdd(aCabec, {"EE7_TIPO"	,"4"																,Nil})
	EndIf

	_nPLTotal := 0
	_nPBTotal := 0

	_cQuery1 := " SELECT PPL.*, PPL.D_E_L_E_T_ DELPPL
	_cQuery1 += " FROM "+RetSqlName("PPL")+" PPL
	_cQuery1 += " WHERE PPL_FILIAL='"+PPJ->PPJ_FILIAL+"' AND PPL_NUM='"+PPJ->PPJ_NUM+"'

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	_aItens := {}

	DbSelectArea("PPL")
	PPL->(DbSetOrder(1))
	PPL->(DbGoTop())
	PPL->(DbSeek(xFilial("PPL")+PPJ->PPJ_NUM))

	//While PPL->(!Eof()) .And. PPJ->(PPJ_FILIAL+PPJ_NUM)==PPL->(PPL_FILIAL+PPL_NUM)
	While (_cAlias1)->(!Eof())

		DbSelectArea("SB1")
		SB1->(DbSetOrder(1))
		SB1->(DbGoTop())
		SB1->(DbSeek(xFilial("SB1")+(_cAlias1)->PPL_PRODUT))

		_nPesLU 	:= IIf(SB1->B1_PESO>0	,Round(SB1->B1_PESO,2)	,1)
		_nPesLT 	:= _nPesLU*(_cAlias1)->PPL_QUANT
		_nPesBU 	:= IIf(SB1->B1_PESBRU>0	,Round(SB1->B1_PESBRU,2)	,1)
		_nPesBT 	:= _nPesBU*(_cAlias1)->PPL_QUANT
		_nQe   		:= IIf(SB1->B1_QE>0		,SB1->B1_QE		,1)

		DbSelectArea("EE8")
		EE8->(DbSetOrder(1))
		EE8->(DbGoTop())
		If EE8->(DbSeek(xFilial("EE8")+PPJ->PPJ_PEDVEN+(_cAlias1)->PPL_SEQUEN+(_cAlias1)->PPL_PRODUT))
			_nPesLU 	:= Round(EE8->EE8_PSLQUN,2)
			_nPesBU 	:= Round(EE8->EE8_PSBRUN,2)
			_nQe   		:= EE8->EE8_QE
		Else
			If AllTrim((_cAlias1)->DELPPL)=="*"
				(_cAlias1)->(DbSkip())
				Loop
			EndIf
		EndIf

		_cDeleta := "N"

		If AllTrim((_cAlias1)->DELPPL)=="*"
			_cDeleta := "S"
		EndIf

		Aadd(_aItens ,{{"EE8_SEQUEN"	,(_cAlias1)->PPL_SEQUEN				,Nil},;
		{"EE8_COD_I"					,(_cAlias1)->PPL_PRODUT				,Nil},;
		{"EE8_FORN"   					,"005764"							,Nil},;
		{"EE8_FOLOJA"					,"02"								,Nil},;
		{"EE8_SLDINI"					,(_cAlias1)->PPL_QUANT				,Nil},;
		{"EE8_EMBAL1"					,"S850LI"							,Nil},;
		{"EE8_UNIDAD"					,SB1->B1_UM							,Nil},;
		{"EE8_QE"						,_nQe								,Nil},;
		{"EE8_PRECO"					,(_cAlias1)->PPL_PRCVEN				,Nil},;
		{"EE8_PSLQUN"					,_nPesLU							,Nil},;
		{"EE8_PSLQTO"					,_nPesLT							,Nil},;
		{"EE8_PSBRUN"					,_nPesBU							,Nil},;
		{"EE8_PSBRTO"					,_nPesBT							,Nil},;
		{"LINPOS"						,"EE8_COD_I"						,AllTrim((_cAlias1)->PPL_SEQUEN)},;
		{"AUTDELETA"					,_cDeleta							,Nil}})

		AADD(_aEmail,{(_cAlias1)->PPL_SEQUEN,;
		(_cAlias1)->PPL_PRODUT,;
		AllTrim(SB1->B1_DESC),;
		(_cAlias1)->PPL_QUANT,;
		(_cAlias1)->PPL_PRCVEN})

		_nPLTotal += _nPesLT
		_nPBTotal += _nPesBT

		(_cAlias1)->(DbSkip())

	EndDo

	ALERTAS(PPJ->PPJ_NUM)

	//Begin Transaction
	lMsErroAuto	:= .F.
	MsExecAuto({|x, y, z| EECAP100(x, y, z)},aCabec,_aItens,4)
	//End Transaction

	If lMsErroAuto
		MostraErro()
	Else

		_cUpdate := " MERGE INTO EE8010 EE8
		_cUpdate += " USING (
		_cUpdate += " SELECT EE8.R_E_C_N_O_ RECEE8,
		_cUpdate += " (CASE WHEN B1_PESO=0 THEN 1 ELSE B1_PESO END) PESLIQ,
		_cUpdate += " (CASE WHEN B1_PESO=0 THEN 1 ELSE B1_PESBRU END) PESBRU,
		_cUpdate += " EE8_SLDATU QTD
		_cUpdate += " FROM "+RetSqlName("EE8")+" EE8
		_cUpdate += " LEFT JOIN "+RetSqlName("SB1")+" B1
		_cUpdate += " ON B1_COD=EE8_COD_I
		_cUpdate += " WHERE EE8.D_E_L_E_T_=' ' AND B1.D_E_L_E_T_=' ' AND EE8_FILIAL='"+xFilial("SC5")+"' AND EE8_PEDIDO='"+PPJ->PPJ_PEDVEN+"'
		_cUpdate += " ) XXX
		_cUpdate += " ON (EE8.R_E_C_N_O_=XXX.RECEE8)
		_cUpdate += " WHEN MATCHED THEN UPDATE SET
		_cUpdate += " EE8.EE8_PSLQUN=XXX.PESLIQ,
		_cUpdate += " EE8.EE8_PSLQTO=XXX.PESLIQ*EE8.EE8_SLDATU,
		_cUpdate += " EE8.EE8_PSBRUN=XXX.PESBRU,
		_cUpdate += " EE8.EE8_PSBRTO=XXX.PESBRU*EE8.EE8_SLDATU

		TcSqlExec(_cUpdate)

		DbSelectArea("EE7")
		EE7->(DbSetOrder(1))
		If EE7->(DbSeek(xFilial("EE7")+PPJ->PPJ_PEDVEN))

			EE7->(RecLock("EE7",.F.))
			EE7->EE7_PESLIQ	:= _nPLTotal
			EE7->EE7_PESBRU	:= _nPBTotal
			EE7->(MsUnLock())

			DbSelectArea("SC5")
			SC5->(DbSetOrder(1))
			If SC5->(DbSeek(EE7->(EE7_FILIAL+EE7_PEDFAT)))
				SC5->(RecLock("SC5",.F.))
				SC5->C5_PESOL 	:= _nPLTotal
				SC5->C5_PBRUTO	:= _nPBTotal
				SC5->(MsUnLock())
			EndIf
		EndIf

		cMsg	:= LISTARITENS(_aEmail)
		_cAssunto	:= "[WFPROTHEUS] Proforma: "+PPJ->PPJ_NUM+" gerou o pedido: "+AllTrim(PPJ->PPJ_PEDVEN)+" (altera็ใo) "
		MsgAlert("Pedido "+Alltrim(EE7->EE7_PEDFAT)+" alterado com sucesso!")
		If !U_STMAILTES(_cEmail, _cCopia, _cAssunto, cMsg,_aAttach,_cCaminho)
			MsgAlert("Problemas no envio de email!")
		EndIf
	EndIf

Return()

/*====================================================================================\
|Programa  | GETSEQUEN         | Autor | RENATO.NOGUEIRA          | Data | 13/08/2015 |
|=====================================================================================|
|Descri็ใo |  GETSEQUEN     Altera็ใo de pedido de venda                              |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | GETSEQUEN                                                                |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Hist๓rico....................................|
\====================================================================================*/

Static Function GETSEQUEN()

	Local cQuery1 	:= ""
	Local cAlias1 	:= "QRYTEMP"
	Local _cItem		:= ""

	cQuery1	:= " SELECT SEQUENCIA FROM ( "
	cQuery1	+= " SELECT TO_NUMBER(TRIM(PPL_SEQUEN)) SEQUENCIA "
	cQuery1	+= " FROM " +RetSqlName("PPL") "
	cQuery1	+= " WHERE D_E_L_E_T_=' ' AND PPL_FILIAL='"+PPJ->PPJ_FILIAL+"' "
	cQuery1	+= " AND PPL_NUM='"+PPJ->PPJ_NUM+"' AND TRIM(PPL_SEQUEN)<>' ' "
	cQuery1	+= " ) ORDER BY SEQUENCIA DESC "

	If !Empty(Select(cAlias1))
		DbSelectArea(cAlias1)
		(cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery1),cAlias1,.T.,.T.)

	dbSelectArea(cAlias1)
	(cAlias1)->(dbGoTop())

	If (cAlias1)->(!Eof())
		_cItem	:= PADL(CVALTOCHAR(incrementa(CVALTOCHAR((cAlias1)->SEQUENCIA))),6," ")
	Else
		_cItem	:= PADL(1,6," ")
	EndIf

Return(_cItem)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLISTARITENS Autor ณRenato Nogueira     บ Data ณ  03/06/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณWebservice de integra็ใo dos pedidos de vendas			  บฑฑ
ฑฑบ          ณ	    							 	 				      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametro ณ Nenhum                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑบRetorno   ณ Nenhum                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function LISTARITENS(_aEmail)

	Local cFuncSent	:= "RetPedido"
	Local cMsg			:= ""
	Local _nLin := 1
	cMsg := ""
	cMsg += '<html>'
	cMsg += '<head>'
	cMsg += '<title>' +SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title>'
	cMsg += '</head>'
	cMsg += '<body>'
	cMsg += '<HR Width=85% Size=3 Align=Centered Color=Red> <P>'
	cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
	cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>'+SM0->M0_NOME+"/"+SM0->M0_FILIAL+ '</FONT> </Caption>'
	cMsg += '<TR><B><TD>ITEM</TD><TD>PRODUTO</TD><TD>DESCRIวรO</TD><TD>QUANTIDADE</TD><TD>PREวO</TD></B></TR>'

	For _nLin := 1 to Len(_aEmail)
		IF (_nLin/2) == Int( _nLin/2 )
			cMsg += '<TR BgColor=#B0E2FF>'
		Else
			cMsg += '<TR BgColor=#FFFFFF>'
		EndIF
		cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aEmail[_nLin,1] + ' </Font></TD>'
		cMsg += '<TD><Font Color=#000000 Size="2" Face="Arial">' + _aEmail[_nLin,2] + ' </Font></TD>'
		cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + _aEmail[_nLin,3] + ' </Font></TD>'
		cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + CVALTOCHAR(TRANSFORM(_aEmail[_nLin,4] ,"@E 99,999,999,999.99")) + ' </Font></TD>'
		cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + CVALTOCHAR(TRANSFORM(_aEmail[_nLin,5] ,"@E 99,999,999,999.99")) + ' </Font></TD>'
		cMsg += '</TR>'
	Next
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Definicao do rodape do email                                                ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
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

Return(cMsg)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณALERTAS     Autor ณRenato Nogueira     บ Data ณ  03/06/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAlertas de peso e descri็ใo em ingl๊s						  บฑฑ
ฑฑบ          ณ	    							 	 				      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametro ณ Nenhum                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑบRetorno   ณ Nenhum                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ALERTAS(_cNum)

	Local cQuery1 	:= ""
	Local cAlias1 	:= "QRYTEMP"
	Local _cLog		:= ""
	Local _lTem		:= .F.

	_cLog := "RELATำRIO DE PRODUTOS "+CHR(13) +CHR(10)+CHR(13) +CHR(10)
	_cLog += "PRODUTO | PESO | INGLสS | BLOQUEADO | DESATIVADO | OBSOLETO "

	cQuery1	:= " SELECT PPL_PRODUT PRODUTO, INGLES, PESO, BLOQUEADO, DESATIVADO, OBSOLETO "
	cQuery1	+= " FROM ( "
	cQuery1	+= " SELECT DISTINCT PPL_PRODUT "
	cQuery1	+= " ,CASE WHEN (SELECT B1_DESC_I FROM "+RetSqlName("SB1")+" B1 WHERE B1.D_E_L_E_T_=' ' AND B1.B1_COD=PPL.PPL_PRODUT)<>' ' THEN 'S' ELSE 'N' END INGLES "
	cQuery1 += " ,CASE WHEN (SELECT B1_PESO FROM "+RetSqlName("SB1")+" B1 WHERE B1.D_E_L_E_T_=' ' AND B1.B1_COD=PPL.PPL_PRODUT)>0 THEN 'S' ELSE 'N' END PESO "
	cQuery1 += " ,CASE WHEN (SELECT B1_MSBLQL FROM "+RetSqlName("SB1")+" B1 WHERE B1.D_E_L_E_T_=' ' AND B1.B1_COD=PPL.PPL_PRODUT)='1' THEN 'S' ELSE 'N' END BLOQUEADO "
	cQuery1 += " ,CASE WHEN (SELECT B1_XDESAT FROM "+RetSqlName("SB1")+" B1 WHERE B1.D_E_L_E_T_=' ' AND B1.B1_COD=PPL.PPL_PRODUT)='2' THEN 'S' ELSE 'N' END DESATIVADO "
	cQuery1 += " ,CASE WHEN (SELECT B1_XR01 FROM "+RetSqlName("SB1")+" B1 WHERE B1.D_E_L_E_T_=' ' AND B1.B1_COD=PPL.PPL_PRODUT)='1' THEN 'S' ELSE 'N' END OBSOLETO
	cQuery1 += " FROM "+RetSqlName("PPL")+" PPL "
	cQuery1 += " WHERE PPL.D_E_L_E_T_=' ' AND PPL_NUM='"+_cNum+"' "
	cQuery1 += " ) WHERE INGLES='N' OR PESO='N' OR BLOQUEADO='S' OR DESATIVADO='S' OR OBSOLETO='S' "

	If !Empty(Select(cAlias1))
		DbSelectArea(cAlias1)
		(cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery1),cAlias1,.T.,.T.)

	dbSelectArea(cAlias1)
	(cAlias1)->(dbGoTop())

	While (cAlias1)->(!Eof())

		_lTem := .T.

		_cLog += AllTrim((cAlias1)->PRODUTO)+" | "+IIf((cAlias1)->PESO=="S","SIM","NรO")+" | "+;
		IIf((cAlias1)->INGLES=="S","SIM","NรO")+" | "+IIf((cAlias1)->BLOQUEADO=="S","SIM","NรO")+" | "+;
		IIf((cAlias1)->DESATIVADO=="S","SIM","NรO")+" | "+IIf((cAlias1)->OBSOLETO=="S","SIM","NรO")+CHR(13) +CHR(10)

		(cAlias1)->(DbSkip())
	EndDo

	If _lTem

		@ 000, 000 TO 230, 350 DIALOG oDlg TITLE 'Relatorio de Inconsistencias '
		@ 005,005 Get _cLog Size 167,080 MEMO Object oMemo
		@ 92,135 BMPBUTTON TYPE 1 ACTION Close(oDlg)
		ACTIVATE DIALOG oDlg CENTERED

	EndIf

Return()

//-------------------------------------------------------------------
/*/{Protheus.doc} ProxNumOP

Gera sequancial para OP que serใo criadas

@author		Renan Rosแrio
@since		15/03/2019
@version	P12
@param
@return
@obs
/*/
//-------------------------------------------------------------------

User Function ProxNumSQ()

	Local aArea     := GetArea()
	Local cWhere 	:= ""
	Local cAliasTmp	:= GetNextAlias()
	Local cRet   	:= "D" + Soma1(StrZero(0, TamSx3("PPJ_XSEQUE")[1] - 1))

	//Condicional para a query
	cWhere := "% "
	cWhere += " PPJ_FILIAL = " + "'" + xFilial("PPJ") + "'"
	cWhere += " AND PPJ_XSEQUE LIKE 'D%'"
	cWhere += " AND PPJ.D_E_L_E_T_ = '' "
	cWhere += " %"

	//Executa a query
	BeginSql alias cAliasTmp
		SELECT
		MAX(PPJ_XSEQUE) PPJ_MAXNUMSQ
		FROM %table:PPJ% PPJ
		WHERE %exp:cWhere%
	EndSql

	//Posiciona no inicio do arquivo temporario
	(cAliasTmp)->(dbGoTop())

	//Inicia o processo de Logistica Reversa
	If (cAliasTmp)->(!EOF()) .And. !Empty((cAliasTmp)->PPJ_MAXNUMSQ)
		cRet := "D" + Soma1(SubStr((cAliasTmp)->PPJ_MAXNUMSQ, 2, Len((cAliasTmp)->PPJ_MAXNUMSQ))) //Incrementa o n๚mero da Sequencial encontrada
	EndIf

	//Fecha Alias temporario
	If Select(cAliasTmp) > 0
		(cAliasTmp)->(dbCloseArea())
	EndIf

	RestArea(aArea)

Return cRet

User Function STPROF01()

	If !(__cUserID $ AllTrim(GetMv("STPRO001",,"000010")))
		MsgAlert("Usuแrio sem acesso para realizar a libera็ใo!")
		Return
	EndIf

	If MsgYesNo("Confirma a libera็ใo da proforma "+PPJ->PPJ_NUM+"?")
		PPJ->(RecLock("PPJ",.F.))
		PPJ->PPJ_STATUS := ""
		PPJ->(MsUnLock())
		MsgAlert("Proforma liberada, obrigado!")
	EndIf

Return()

User Function STPROF02()
Local _cQuery 	:= ""
Local _cRef		:= ""

	If !(__cUserID $ AllTrim(GetMv("STPRO001",,"000010")))
		MsgAlert("Usuแrio sem acesso para realizar a libera็ใo!")
		Return
	EndIf

	If Empty(PPJ->PPJ_PEDVEN)
		MsgAlert("Pedido nใo foi gerado ainda, verifique")
		Return
	EndIf

	If MsgYesNo("Confirma zerar os pesos do pedido "+AllTrim(PPJ->PPJ_PEDVEN)+"?")
		//_cRef := FWInputBox("Por Favor, informe a Referencia:","")

		//If !Empty(_cRef)
		//	_cRef := Alltrim(_cRef)
			
			_cQuery := "UPDATE " + RetSqlName("EE8") + " EE8"
			_cQuery += " SET EE8_PSLQUN =0, EE8_PSLQTO =0, EE8_PSBRUN =0, EE8_PSBRTO =0"
			_cQuery += " WHERE EE8.D_E_L_E_T_= ' '"
			_cQuery += " AND EE8_FILIAL = '" + xFilial("EE8") + "'"
			_cQuery += " AND EE8_PEDIDO = '" + PPJ->PPJ_PEDVEN + "'"
			
			TcSqlExec(_cQuery)
			
			MsgAlert("Proforma ajustada. Verifique...")
		//EndIf

	EndIf

Return()
