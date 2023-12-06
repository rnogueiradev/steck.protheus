#INCLUDE "TOTVS.CH" 
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TBICODE.CH"
#INCLUDE "JSON.CH"
#INCLUDE "SHASH.CH"
#INCLUDE "AARRAY.CH"
#INCLUDE "RESTFUL.CH"
#INCLUDE "FWMVCDEF.CH"

USER FUNCTION MSTECK27()
	PRIVATE aTitles1 := { "Pedido de Compra "+SC7->C7_NUM}
	PRIVATE aTitles2 := { "Ação" }
	PRIVATE aPages   := {}
	PRIVATE aPosGet1 := {}
	PRIVATE aBrowse  := {}
	PRIVATE oBrowse
	PRIVATE oFolder1
	PRIVATE oFolder2
	PRIVATE oSize1
	PRIVATE oOk       := LoadBitmap( GetResources(), "LBOK" )
	PRIVATE oNo       := LoadBitmap( GetResources(), "LBNO" )
	PRIVATE oCheckBox
	PRIVATE lCheckBox := .F.
	PRIVATE oBtOK
	PRIVATE oBtSair
	PRIVATE dEmissao := "Data de Emissão: "+DTOC(SC7->C7_EMISSAO)
	PRIVATE cFornece := "Fornecedor: "+ALLTRIM(SC7->C7_FORNECE)+"-"+ALLTRIM(SC7->C7_LOJA)+" "+POSICIONE("SA2",1,XFILIAL("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA,"A2_NOME")

//// Verifica se o Pedido é para as Indústrias 
	IF !SC7->C7_FORNECE $ '005866/005764'
		MSGALERT("Eliminação de resíduo somente para os pedidos de compras para as indústrias ")
	ENDIF

//// Monta o vetor
	MSTECK27A(aBrowse)

//// Calcula as dimensoes dos objetos
	oSize1 := FwDefSize():New( .T. ) // Com enchoicebar
	oSize1:lLateral  := .F.  // Calculo vertical
	oSize1:AddObject( "FOLDER1",100, 150, .T., .T. )
	oSize1:AddObject( "FOLDER2",100, 080, .T., .F. )
	oSize1:Process()

// Desenha a dialog
	DEFINE MSDIALOG oDlg TITLE "Pedido de Compra" FROM oSize1:aWindSize[1],oSize1:aWindSize[2] TO oSize1:aWindSize[3],oSize1:aWindSize[4] PIXEL

// Monta o Objeto Folder
	oFolder1:=TFolder():New( oSize1:GetDimension("FOLDER1","LININI"),oSize1:GetDimension("FOLDER1","COLINI"),aTitles1,aPages,oDlg,,,,.T.,.T.,oSize1:GetDimension("FOLDER1","XSIZE"),oSize1:GetDimension("FOLDER1","YSIZE"))
// Cria a dimensão das getdados, diminuindo um pouco da área do folder 
	aPosGet1 := { oSize1:GetDimension("FOLDER1","LININI"),oSize1:GetDimension("FOLDER1","COLINI"),oSize1:GetDimension("FOLDER1","XSIZE")-7,oSize1:GetDimension("FOLDER1","YSIZE")-19}

	oFolder2:=TFolder():New( oSize1:GetDimension("FOLDER2","LININI"),oSize1:GetDimension("FOLDER2","COLINI"),aTitles2,aPages,oDlg,,,,.T.,.T.,oSize1:GetDimension("FOLDER2","XSIZE"),oSize1:GetDimension("FOLDER2","YSIZE"))

	@ 007, 006 SAY dEmissao   SIZE 300, 007 OF oFolder2:aDialogs[1] PIXEL
	@ 020, 006 SAY cFornece   SIZE 300, 007 OF oFolder2:aDialogs[1] PIXEL
	@ 040, 006 CHECKBOX oCheckBox VAR lCheckBox PROMPT "Marcar/Desmarcar Todos" SIZE 075, 008 OF oFolder2:aDialogs[1] ON CLICK(Iif(lCheckBox,Marca(lCheckBox),Marca(lCheckBox))) PIXEL
	@ 040, 106 BUTTON oBtOK    PROMPT "Confirmar" SIZE 040, 012 OF oFolder2:aDialogs[1] ACTION(IIF(MSTECK27B()=.T.,oDlg:End(),"")) PIXEL
	@ 040, 176 BUTTON oBtSair  PROMPT "Fechar"    SIZE 040, 012 OF oFolder2:aDialogs[1] ACTION(oDlg:End()) PIXEL

	oBrowse := TWBrowse():New( aPosGet1[1] ,aPosGet1[2],aPosGet1[3],aPosGet1[4],,{'','Pedido','Item','Produto','Descrição','Quantidade','Entregue','Saldo','Filial Ind.','PV. Ind.','PV. Item','Reg. SC7','Reg. SC6'},{10,50,50,50,200,50,50,50,50,20,20},oFolder1:aDialogs[1],,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )
	oBrowse:SetArray(aBrowse)
	oBrowse:AddColumn( TCColumn():New(""           ,{||IIF(aBrowse[oBrowse:nAt,01],oOk,oNo)},"",,,"CENTER",10,.T.,.T.,,,,.F.,))
	oBrowse:AddColumn( TCColumn():New("Pedido     ",{|| aBrowse[oBrowse:nAt,02]},"@!",,,"LEFT",50,.F.,.T.,,,,.F.,))
	oBrowse:AddColumn( TCColumn():New("Item       ",{|| aBrowse[oBrowse:nAt,03]},"@!",,,"LEFT",50,.F.,.T.,,,,.F.,))
	oBrowse:AddColumn( TCColumn():New("Produto    ",{|| aBrowse[oBrowse:nAt,04]},"@!",,,"LEFT",50,.F.,.T.,,,,.F.,))
	oBrowse:AddColumn( TCColumn():New("Descrição  ",{|| aBrowse[oBrowse:nAt,05]},"@!",,,"LEFT",200,.F.,.T.,,,,.F.,))
	oBrowse:AddColumn( TCColumn():New("Quantidade ",{|| aBrowse[oBrowse:nAt,06]},"@E 99,999,999.99",,,"RIGTH",50,.F.,.T.,,,,.F.,))
	oBrowse:AddColumn( TCColumn():New("Entregue   ",{|| aBrowse[oBrowse:nAt,07]},"@E 99,999,999.99",,,"RIGTH",50,.F.,.T.,,,,.F.,))
	oBrowse:AddColumn( TCColumn():New("Saldo      ",{|| aBrowse[oBrowse:nAt,08]},"@E 99,999,999.99",,,"RIGTH",50,.F.,.T.,,,,.F.,))
	oBrowse:AddColumn( TCColumn():New("Filial Ind.",{|| aBrowse[oBrowse:nAt,09]},"@!",,,"LEFT",50,.F.,.T.,,,,.F.,))
	oBrowse:AddColumn( TCColumn():New("PV. Ind.   ",{|| aBrowse[oBrowse:nAt,10]},"@!",,,"LEFT",50,.F.,.T.,,,,.F.,))
	oBrowse:AddColumn( TCColumn():New("PV. Item   ",{|| aBrowse[oBrowse:nAt,11]},"@!",,,"LEFT",50,.F.,.T.,,,,.F.,))
	oBrowse:AddColumn( TCColumn():New("Reg. SC7   ",{|| aBrowse[oBrowse:nAt,12]},"@E 9999999",,,"RIGTH",20,.F.,.T.,,,,.F.,))
	oBrowse:AddColumn( TCColumn():New("Reg. SC6   ",{|| aBrowse[oBrowse:nAt,13]},"@E 9999999",,,"RIGTH",20,.F.,.T.,,,,.F.,))

	oFolder2:Align := CONTROL_ALIGN_BOTTOM
	oFolder1:Align := CONTROL_ALIGN_ALLCLIENT
// Troca a imagem no duplo click do mouse
	oBrowse:bLDblClick := {|| aBrowse[oBrowse:nAt][1] := !aBrowse[oBrowse:nAt][1],oBrowse:DrawSelect()}
	oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
	ACTIVATE MSDIALOG oDlg CENTERED

RETURN

/*
Rotina para Marcar  / Desmarcar todos os registros
*/
STATIC FUNCTION MARCA(lMarca)
	LOCAL i := 0

	FOR i := 1 TO LEN(aBrowse)
		aBrowse[i][1] := lMarca
	NEXT i

	oBrowse:Refresh()
RETURN

/*
Carrega todos os registros
*/

STATIC FUNCTION MSTECK27A(aBrowse)
	LOCAL cQuery   := ""

	cQuery := "SELECT C7.C7_NUM,C7.C7_ITEM,C7.C7_PRODUTO,C7.C7_DESCRI,C7.C7_QUANT,C7.C7_QUJE,C7.C7_QUANT - C7.C7_QUJE SALDO,C7.R_E_C_N_O_ AS SC7REC, "
	cQuery += "NVL(C6.C6_NUM, ' ') C6_NUM,NVL(C6.C6_ITEM, ' ') C6_ITEM,NVL(C6.R_E_C_N_O_,0) AS SC6REC, "
	cQuery += "NVL(CASE WHEN C7.C7_FORNECE = '005764' THEN 'GUARAREMA' WHEN C7.C7_FORNECE = '005866' THEN 'MANAUS' END, ' ') FILIAL "
	cQuery += "FROM "+RetSqlName("SC7")+" C7 "
//// Filial Guararema
	IF SC7->C7_FORNECE = "005764"
		cQuery += "LEFT JOIN "+AllTrim(GetMv("STALIASIND"))+".SC6010 C6 ON C6.D_E_L_E_T_ = ' ' AND C6.C6_NUMPCOM = C7.C7_NUM AND C6.C6_ITEMPC = C7.C7_ITEM "
//// Filial Manaus
	ELSEIF SC7->C7_FORNECE = "005866"
		cQuery += "LEFT JOIN "+AllTrim(GetMv("STALIASIND"))+".SC6030 C6 ON C6.D_E_L_E_T_ = ' ' AND C6.C6_NUMPCOM = C7.C7_NUM AND C6.C6_ITEMPC = C7.C7_ITEM "
	ENDIF
	cQuery += "WHERE C7.D_E_L_E_T_ = ' ' "
	cQuery += "AND C7.C7_QUANT - C7.C7_QUJE > 0 "
	cQuery += "AND C7.C7_NUM = '"+SC7->C7_NUM+"' "
	cQuery += "AND C7.C7_RESIDUO = ' '  "
	cQuery += "AND C7.C7_PO_EIC = ' ' "
	cQuery += "ORDER BY C7.C7_NUM, C7.C7_ITEM "
	DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TSC7', .F., .T.)

	WHILE TSC7->(!EOF())
		AADD(aBrowse,{.F.,TSC7->C7_NUM,TSC7->C7_ITEM,TSC7->C7_PRODUTO,TSC7->C7_DESCRI,TSC7->C7_QUANT,TSC7->C7_QUJE,TSC7->SALDO,TSC7->FILIAL,TSC7->C6_NUM,TSC7->C6_ITEM,TSC7->SC7REC,TSC7->SC6REC})
		TSC7->(DBSKIP())
	ENDDO

	IF LEN(aBrowse) = 0
		AADD(aBrowse,{.F.,"","","","",0,0,0,"","","",0,0})
	ENDIF
	TSC7->(DBCLOSEAREA())

RETURN aBrowse

STATIC FUNCTION MSTECK27B()
	LOCAL i := 0
	LOCAL lRet := .T.
	LOCAL aVetorPC := {}
	LOCAL aVetorPV := {}
	LOCAL lContinua := .T.
	LOCAL _nX := 0

//// Carrega somente os itens selecionados para o Pedido de Compra
	FOR i := 1 TO LEN(aBrowse)
		IF aBrowse[i,1] = .T. .AND. !EMPTY(aBrowse[i,02])
			IF aBrowse[i,13] > 0
				IF aBrowse[i,09] = "GUARAREMA"
					AADD(aVetorPV,{'01','05',aBrowse[i,10],aBrowse[i,13],aBrowse[i,12],aBrowse[i,11]})
				ELSEIF aBrowse[i,09] = "MANAUS"
					AADD(aVetorPV,{'03', '01',aBrowse[i,10],aBrowse[i,13],aBrowse[i,12],aBrowse[i,11]})
				ENDIF
			ENDIF
		ENDIF
	NEXT

	IF LEN(aVetorPV) > 0

		IF MSGYESNO("Deseja eliminar o resíduo dos registros selecionados?")

			For _nX:=1 To Len(aVetorPV)

    /*
    Posiciona na SC5 da Indústria para efetuar algumas validações prévias
    */
	 
				IF aVetorPV[_nX,1]+aVetorPV[_nX,2]=="0105"
					cQuery := "SELECT * FROM "+AllTrim(GetMv("STALIASIND"))+".SC5010 C5
					cQuery += " LEFT JOIN "+AllTrim(GetMv("STALIASIND"))+".SC6010 C6
					cQuery += " ON C5_FILIAL=C6_FILIAL AND C5_NUM=C6_NUM
					cQuery += " WHERE C5.D_E_L_E_T_=' ' AND C6.D_E_L_E_T_=' '
				ELSEIF aVetorPV[_nX,1]+aVetorPV[_nX,2]=="0301"
					cQuery := "SELECT * FROM "+AllTrim(GetMv("STALIASIND"))+".SC5030 C5 "
					//cQuery += " LEFT JOIN "+AllTrim(GetMv("STALIASIND"))+".SC6010 C6 20230921011899 não encontrava o registro, pois, estava com o banco incorreto
					cQuery += " LEFT JOIN "+AllTrim(GetMv("STALIASIND"))+".SC6030 C6 
					cQuery += " ON C5_FILIAL=C6_FILIAL AND C5_NUM=C6_NUM
					cQuery += " WHERE C5.D_E_L_E_T_=' ' AND C6.D_E_L_E_T_=' '
				ENDIF
				cQuery += " AND C5.C5_NUM = '"+aVetorPV[_nX,3]+"' "
				cQuery += " AND C6.R_E_C_N_O_= '"+cValtochar(aVetorPV[_nX,4])+"' " // 20230921011899 Realizado inclusão, pois, estava posicionando no registro incorreto				
				DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TSC5', .F., .T.)

				//// Pedido de Venda Faturado Totalmente
				IF TSC5->C5_ZFATBLQ = '1' .AND. lContinua = .T.
					lContinua := .F.
					MSGALERT("Pedido de Venda Faturado Totalmente na Indústria."+CHR(10)+CHR(13)+;
						"Não será possível eliminar o resíduo deste pedido de compra.")
				ENDIF

				//// Pedido de Venda Eliminado por Resíduo
				IF ('XXXX' $ TSC5->C5_NOTA) .AND. (TSC5->C5_ZFATBLQ $ '1/2') .AND. lContinua = .T.
					lContinua:=.F.
					MSGALERT("Pedido de Venda Eliminado por Resíduo na Indústria."+CHR(10)+CHR(13)+;
						"Não será possível eliminar o resíduo deste pedido de compra.")
				ENDIF

				//// Pedido de Venda Cancelado
				IF TSC5->(C6_QTDVEN-C6_QTDENT)<=0 .AND. lContinua = .T.
					lContinua:=.F.
					MSGALERT("Pedido de Venda totalmente faturado na Indústria."+CHR(10)+CHR(13)+;
						"Não será possível eliminar o resíduo deste pedido de compra.")
				ENDIF
				TSC5->(DBCLOSEAREA())

			Next

			IF lContinua = .T.
				IF LEN(aVetorPV) > 0
					PROCESSA({|| MSTECK27D(aVetorPV)}, "Aguarde a eliminação dos resíduos","Aguarde!",.F.)
				ENDIF
			ENDIF
		ENDIF
	ELSE
		MSGALERT("Nenhum registro selecionado!")
		lRet := .F.
	ENDIF
RETURN lRet

/*
Chama a rotina de Eliminação de Resíduo do Pedido de Venda da Industria
*/
STATIC FUNCTION MSTECK27D(aVetorPV)
	LOCAL i := 0
	LOCAL cJson  := '""
	LOCAL nlCont := 0
	LOCAL cAlias := GetArea()
	LOCAL cUsrNam := SUPERGETMV("STWEB70N",,"rest.interno")
	LOCAL cPasswd := SUPERGETMV("STWEB70P",,"steck@22")
	LOCAL cToken  := Encode64(cUsrNam + ":" + cPasswd)
	LOCAL aHeader := {}
	LOCAL nNaoProc:= 0
	LOCAL aRefImp
	LOCAL lRet1   :=.F.

	DbSelectArea("PA1")
	PA1->(DbSetOrder(2)) //PA1_FILIAL+PA1_TIPO+PA1_DOC+PA1_CODPRO

	PROCREGUA(LEN(aVetorPV))

	FOR i := 1 TO LEN(aVetorPV)

		IncProc()

		cJson := '{'
		cJson += '"EMPRESA":"'+ALLTRIM(aVetorPV[1,1])+'",'
		cJson += '"FILIAL":"'+ALLTRIM(aVetorPV[1,2])+'",'
		cJson += '"PEDIDO":"'+ALLTRIM(aVetorPV[1,3])+'",'
		cJson += '"ITENS":'
		cJson += '['
		cJson += '{'
		cJson += '"RECNO":"'+ALLTRIM(STR(aVetorPV[i,4]))+'"'
		cJson += '}'
		cJson += ']'
		cJson += '}'

//// Declara a variável
		oJson := NIL
		oRet  := NIL

//// Conexao conforme a empresa destino onde o Pedido de Venda deve ser incluido
		IF aVetorPV[1,1]+aVetorPV[1,2] == "0105"
			cUrl := SuperGetMv("STWEB07301", .F., "http://rest-p12.steck.com.br:9998/rest")
		ELSEIF aVetorPV[1,1]+aVetorPV[1,2] == "0301"
			cUrl := SuperGetMv("STWEB07305", .F., "http://rest-p12.steck.com.br:9998/rest")
		ENDIF
//// Montagem do Header
		AADD(aHeader, 'Content-Type: application/json')
		AADD(aHeader, 'Authorization: Basic '+cToken)
		AADD(aHeader, 'Tenantid: '+aVetorPV[1,1]+','+aVetorPV[1,2])

//// Montagem do Objeto
		oJson := FWRest():New(cUrl)
		oJson:SetPath("/EliminaResInd")
		oJson:SetPostParams( cJson )

		Begin Transaction

			cQuery := "SELECT Z96.Z96_PA1DOC, Z96.Z96_QTDATE, Z96.R_E_C_N_O_ AS Z96REC FROM "+RetSqlName("Z96")+" Z96 WHERE Z96.D_E_L_E_T_ = ' ' AND Z96.Z96_EMPFIL = '"+aVetorPV[i,1]+aVetorPV[i,2]+"' "
			cQuery += "AND Z96.Z96_PVIND = '"+aVetorPV[i,3]+"' AND Z96.Z96_ITPVIN = '"+aVetorPV[i,6]+"' "
			DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TZ96', .F., .T.)
            /*
            Elimina os lançamentos da tabela Z96
            */  
			WHILE TZ96->(!EOF())
				Z96->(DBSETORDER(1))
				Z96->(DBGOTO(TZ96->Z96REC))
				Z96->(RECLOCK("Z96",.F.))
				Z96->(DBDELETE())
				Z96->(MSUNLOCK())

                /*
                Posiciona nos Pedidos de Venda de Clientes e limpa a data de Entrega 2
                */
				SC6->(DBSETORDER(1))
				IF SC6->(DBSEEK(XFILIAL("SC6")+AllTrim(TZ96->Z96_PA1DOC)))
					SC6->(RECLOCK("SC6",.F.))
					SC6->C6_ZENTRE2 := STOD("")
					SC6->(MSUNLOCK())
				ENDIF

				If PA1->(MsSeek(xFilial("PA1")+"1"+TZ96->Z96_PA1DOC))
					PA1->(RecLock("PA1",.F.))
					PA1->PA1_SALDO +=  TZ96->Z96_QTDATE
					PA1->(MsUnLock())
				EndIf

				TZ96->(DBSKIP())
			ENDDO
			TZ96->(DBCLOSEAREA())

			SC7->(DBGOTO(aVetorPV[i,5]))
			MA235ElRes(nNaoProc,aRefImp)

			If AllTrim(SC7->C7_RESIDUO)=="S" // Se deu certo a eliminação aqui na origem chama o destino.
				IF oJson:Post(aHeader, cJson ) // .T.=Sucesso
					lRet1 := FWJsonDeserialize(oJson:GetResult(),@oRet) // Retorno do processamento
					IF !lRet1
						DisarmTransaction()
						MsgAlert("Atenção, problema ao eliminar resíduo via WebService ref. PC "+SC7->C7_NUM+" item "+SC7->C7_ITEM+" este processo não será concluído, favor verifique!")
					ENDIF
				ELSE
					DisarmTransaction()
					//MSGALERT(oJson:GetLastError())
					MsgAlert("Atenção, problema ao eliminar resíduo via WebService ref. PC "+SC7->C7_NUM+" item "+SC7->C7_ITEM+" este processo não será concluído, favor verifique! "+oJson:GetLastError())
				ENDIF
			ELSE
				DisarmTransaction()
				MsgAlert("Atenção, problema ao eliminar resíduo deste item PC "+SC7->C7_NUM+" item "+SC7->C7_ITEM+" este processo não será concluído, favor verifique!")
			ENDIF
		End Transaction
	NEXT
	RestArea(cAlias)
RETURN()

