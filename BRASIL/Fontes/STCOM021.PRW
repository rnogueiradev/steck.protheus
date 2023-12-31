#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "COLORS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � STCOM021     �Autor  �Joao Rinaldi    � Data �  01/02/2016 ���
�������������������������������������������������������������������������͹��
���Desc.     � Fun��o desenvolvida para retornar o c�digo do aprovador da ���
���          � Solicita��o de Compra                                      ���
�������������������������������������������������������������������������͹��
���Uso       � Steck Industria Eletrica Ltda.                             ���
�������������������������������������������������������������������������͹��
���Chamado   � 002612 - Automatizar Solicita��o de Compras                ���
���Solic.    � Juliana Queiroz - Depto. Compras                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function STCOM021()
	
	//������������������������������������������������������������������������Ŀ
	//�Declara��o das Vari�veis
	//��������������������������������������������������������������������������
	Local cPerg      := "STCOM021"
	Local cTime      := Time()
	Local cHora      := SUBSTR(cTime, 1, 2)
	Local cMinutos   := SUBSTR(cTime, 4, 2)
	Local cSegundos  := SUBSTR(cTime, 7, 2)
	Local cAliasLif  := cPerg+cHora+cMinutos+cSegundos
	Local cAlias1    := cAliasLif
	Local cQuery1    := ""
	Local _aAprov    := {}
	Local _aItens    := {}
	Local _nI
	
	//������������������������������������������������������������������������Ŀ
	//�Vari�veis para montagem da Tela - MsNewGetDados
	//��������������������������������������������������������������������������
	Local _cTitulo     := "Rela��o de Aprovadores"
	Local aSize        := MsAdvSize(, .F., 400)
	Local aInfo        := {aSize[1],aSize[2],aSize[3],aSize[4]-12, 1, 1 }
	Local aObjects     := {{100, 100,.T.,.T. }}
	Local aPosObj      := MsObjSize( aInfo, aObjects,.T. )
	Local nStyle       := GD_INSERT+GD_DELETE+GD_UPDATE
	Local _aCamposEdit := {} //{"COR","D2_FILIAL","D2_DOC"}
	
	//������������������������������������������������������������������������Ŀ
	//�Vari�veis de A��o da MsNewGetDados
	//��������������������������������������������������������������������������
	Local _aButtons    := {}
	Local _bOk         := {|| (STTOK(@_aDados1,@oDlgCons))}
	Private _bCancel   := {|| oDlgCons:End() }
	
	//������������������������������������������������������������������������Ŀ
	//�Vari�veis de Objeto e Flag da MsNewGetDados
	//��������������������������������������������������������������������������
	Private oGetDados1
	Private oOk        := LoadBitmap( GetResources(), "LBOK" )//"MARCADO"
	Private oNo        := LoadBitmap( GetResources(), "LBNO" )//"DESMARCADO"
	
	//������������������������������������������������������������������������Ŀ
	//�Vari�vies do Cabe�alho e Itens da MsNewGetDados
	//��������������������������������������������������������������������������
	Private _aHeader   := {}
	Private _aDados1   := {}
		
	Private _cAprov    := ''	
	//������������������������������������������������������������������������Ŀ
	//�Tamanho de Fonte a ser exibida na Tela
	//��������������������������������������������������������������������������
	oFont13 := TFont():New("Arial",9,24,.T.,.F.,5,.T.,5,.T.,.F.)
	
	cQuery1 := "  SELECT
	cQuery1 += "  ZH_FILIAL
	cQuery1 += " ,ZH_APROVP
	cQuery1 += " ,SUBSTR( ZH_DTINIAP,7,2)||'/'|| SUBSTR( ZH_DTINIAP,5,2)||'/'|| SUBSTR( ZH_DTINIAP,1,4) AS ZH_DTINIAP
	cQuery1 += " ,SUBSTR( ZH_DTFIMAP,7,2)||'/'|| SUBSTR( ZH_DTFIMAP,5,2)||'/'|| SUBSTR( ZH_DTFIMAP,1,4) AS ZH_DTFIMAP
	cQuery1 += " ,ZH_APROVS
	cQuery1 += " ,SUBSTR( ZH_DTINIAS,7,2)||'/'|| SUBSTR( ZH_DTINIAS,5,2)||'/'|| SUBSTR( ZH_DTINIAS,1,4) AS ZH_DTINIAS
	cQuery1 += " ,SUBSTR( ZH_DTFIMAS,7,2)||'/'|| SUBSTR( ZH_DTFIMAS,5,2)||'/'|| SUBSTR( ZH_DTFIMAS,1,4) AS ZH_DTFIMAS
	cQuery1 += " FROM "+RetSqlName("SZH")+" SZH
	
	cQuery1 += " WHERE SZH.D_E_L_E_T_ = ' '
	
	cQuery1 += " AND ZH_APROVP = '"+__cUserId+"'
	cQuery1 += "  OR ZH_APROVS = '"+__cUserId+"'
	
	cQuery1 += " ORDER BY ZH_APROVP,ZH_APROVS
	
	If Select(cAlias1) > 0
		(cAlias1)->(dbCloseArea())
	EndIf
	
	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery1),cAlias1)
	
	DbSelectArea(cAlias1)
	(cAlias1)->(DbGoTop())
	If  Select(cAlias1) > 0
		While 	(cAlias1)->(!Eof())
			aAdd(_aAprov,{"LBNO",;
				((cAlias1)->ZH_APROVP),;
				USRRETNAME((cAlias1)->ZH_APROVP),;
				((cAlias1)->ZH_DTINIAP),;
				((cAlias1)->ZH_DTFIMAP),;
				((cAlias1)->ZH_APROVS),;
				USRRETNAME((cAlias1)->ZH_APROVS),;
				((cAlias1)->ZH_DTINIAS),;
				((cAlias1)->ZH_DTFIMAS),;
				Substr(U_STCOM022('1',((cAlias1)->ZH_APROVP)),1,1),;
				.F.})
			(cAlias1)->(dbskip())
		End
		(cAlias1)->(dbCloseArea())
	Endif
	
	If Len(_aAprov) > 0
		
		STaHeader()
		If Len(_aAprov) == 1
			
			nPosStatus := aScan(_aHeader,{|x| AllTrim(Upper(x[2]))=="ZH_STATUS"})
			nPosAprovp := aScan(_aHeader,{|x| AllTrim(Upper(x[2]))=="ZH_APROVP"})
			nPosAprovs := aScan(_aHeader,{|x| AllTrim(Upper(x[2]))=="ZH_APROVS"})
			cStatus    := ''
			
			If _aAprov[Len(_aAprov)][nPosStatus] $ '1/3' //Inativo/Bloqueado
				If _aAprov[Len(_aAprov)][nPosStatus] == '1'
					cStatus := 'Inativo'
				ElseIf _aAprov[Len(_aAprov)][nPosStatus] == '3'
					cStatus := 'Bloqueado'
				Endif
				
				Aviso("Sele��o de Aprovador"; //01 - cTitulo - T�tulo da janela
				,"O cadastro do aprovador "+Alltrim(USRRETNAME(_aAprov[Len(_aAprov)][nPosAprovp]))+" est� com o Status "+cStatus+"."+CHR(10)+CHR(13)+;
					CHR(10)+CHR(13)+;
					"Voc� n�o ter� acesso a rotina."+CHR(10)+CHR(13)+;
					CHR(10)+CHR(13)+;
					"Favor verificar o cadastro do aprovador junto ao departamento de Compras.",;//02 - cMsg - Texto a ser apresentado na janela.
				{"OK"};                          //03 - aBotoes - Array com as op��es dos bot�es.
				,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
				,;                               //05 - cText - Titulo da Descri��o (Dentro da Janela)
				,;                               //06 - nRotAutDefault - Op��o padr�o usada pela rotina autom�tica
				,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
				,.F.;                            //08 - lEdit - Determina se permite a edi��o do campo memo
				,;                               //09 - nTimer - Tempo para exibi��o da mensagem em segundos.
				,;                               //10 - nOpcPadrao - Op��o padr�o apresentada na mensagem.
				)
				_cAprov := ''
				
			ElseIf _aAprov[Len(_aAprov)][nPosStatus] $ '2'//Ativo
				_cAprov := _aAprov[Len(_aAprov)][nPosAprovp]
			ElseIf _aAprov[Len(_aAprov)][nPosStatus] $ '4'//Substituto //chamado 004436 Robson Mazzarotto
				_cAprov := _aAprov[Len(_aAprov)][nPosAprovp]+_aAprov[Len(_aAprov)][nPosAprovs]
			Endif
			
		ElseIf Len(_aAprov) > 1
			Define MSDialog oDlgCons Title _cTitulo From aSize[7],000 To aSize[6],aSize[5] of GetWndDefault() Pixel
			
			@ aPosObj[1,1]+2,aPosObj[1,2]+5 Say "Escolha o Aprovador" Of oDlgCons Pixel COLOR CLR_HBLUE FONT oFont13
			oGetDados1 := MsNewGetDados():New( aPosObj[1,1]+20      , aPosObj[1,2]+5                , aPosObj[1,3]     , aPosObj[1,4] ,              ,"AllWaysTrue","AllWaysTrue",""        , _aCamposEdit         ,/*freeze*/,999,/*fieldok*/,/*superdel*/,/*delok*/,oDlgCons,_aHeader,_aAprov)
			bDbClick := oGetDados1:oBrowse:bLDblClick
			oGetDados1:oBrowse:bldblClick := {|| STClick(@_aDados1) }
			//oGetDados1:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT//Tela Inteira
			oGetDados1:oBrowse:SetFocus()
			
			ACTIVATE MSDIALOG oDlgCons CENTERED ON INIT EnchoiceBar(oDlgCons, _bOk, _bCancel,,_aButtons)
		Endif
	Else
		Aviso("Sele��o de Aprovador"; //01 - cTitulo - T�tulo da janela
		,"O seu c�digo de usu�rio n�o est� cadastrado como Aprovador Principal ou como Aprovador Substituto."+CHR(10)+CHR(13)+;
			CHR(10)+CHR(13)+;
			"Voc� n�o ter� acesso a rotina."+CHR(10)+CHR(13)+;
			CHR(10)+CHR(13)+;
			"A��o n�o permitida.",;//02 - cMsg - Texto a ser apresentado na janela.
		{"OK"};                          //03 - aBotoes - Array com as op��es dos bot�es.
		,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
		,;                               //05 - cText - Titulo da Descri��o (Dentro da Janela)
		,;                               //06 - nRotAutDefault - Op��o padr�o usada pela rotina autom�tica
		,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
		,.F.;                            //08 - lEdit - Determina se permite a edi��o do campo memo
		,;                               //09 - nTimer - Tempo para exibi��o da mensagem em segundos.
		,;                               //10 - nOpcPadrao - Op��o padr�o apresentada na mensagem.
		)
	Endif
	
Return _cAprov

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � STaHeader �Autor  �Joao Rinaldi       � Data �  11/02/2016 ���
�������������������������������������������������������������������������͹��
���Desc.     � Fun��o para retornar o aHeader                             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Steck Industria Eletrica Ltda.                             ���
�������������������������������������������������������������������������͹��
���Chamado   � 002612 - Automatizar Solicita��o de Compras                ���
���Solic.    � Juliana Queiroz - Depto. Compras                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function STaHeader()
	
	//aAdd(_aHeader,{T�tulo                 ,Campo         ,Picture                      ,Tamanho                  ,Decimal                   ,Valida��o,Reservado        ,Tipo                    ,Reservado,Reservado})
	Aadd(_aHeader,{"Flag"                   ,"XX_FLAG"     ,"@BMP"                       ,1                        ,0                         ,""       ,""               ,""                      ,"","","","",".T."})
	aAdd(_aHeader,{RetTitle("ZH_APROVP")    ,"ZH_APROVP"   ,PesqPict("SZH","ZH_APROVP")  ,TamSx3("ZH_APROVP")[1]   ,TamSx3("ZH_APROVP")[2]    ,""       ,"���������������",TamSx3("ZH_APROVP")[3]  ,"","","","",".T."})
	aAdd(_aHeader,{RetTitle("ZH_NOMEAP")    ,"ZH_NOMEAP"   ,PesqPict("SZH","ZH_NOMEAP")  ,TamSx3("ZH_NOMEAP")[1]   ,TamSx3("ZH_NOMEAP")[2]    ,""       ,"���������������",TamSx3("ZH_NOMEAP")[3]  ,"","","","",".T."})
	aAdd(_aHeader,{RetTitle("ZH_DTINIAP")   ,"ZH_DTINIAP"  ,PesqPict("SZH","ZH_DTINIAP") ,TamSx3("ZH_DTINIAP")[1]  ,TamSx3("ZH_DTINIAP")[2]   ,""       ,"���������������",TamSx3("ZH_DTINIAP")[3] ,"","","","",".T."})
	aAdd(_aHeader,{RetTitle("ZH_DTFIMAP")   ,"ZH_DTFIMAP"  ,PesqPict("SZH","ZH_DTFIMAP") ,TamSx3("ZH_DTFIMAP")[1]  ,TamSx3("ZH_DTFIMAP")[2]   ,""       ,"���������������",TamSx3("ZH_DTFIMAP")[3] ,"","","","",".T."})
	aAdd(_aHeader,{RetTitle("ZH_APROVS")    ,"ZH_APROVS"   ,PesqPict("SZH","ZH_APROVS")  ,TamSx3("ZH_APROVS")[1]   ,TamSx3("ZH_APROVS")[2]    ,""       ,"���������������",TamSx3("ZH_APROVS")[3]  ,"","","","",".T."})
	aAdd(_aHeader,{RetTitle("ZH_NOMEAPS")   ,"ZH_NOMEAPS"  ,PesqPict("SZH","ZH_NOMEAPS") ,TamSx3("ZH_NOMEAPS")[1]  ,TamSx3("ZH_NOMEAPS")[2]   ,""       ,"���������������",TamSx3("ZH_NOMEAPS")[3] ,"","","","",".T."})
	aAdd(_aHeader,{RetTitle("ZH_DTINIAS")   ,"ZH_DTINIAS"  ,PesqPict("SZH","ZH_DTINIAS") ,TamSx3("ZH_DTINIAS")[1]  ,TamSx3("ZH_DTINIAS")[2]   ,""       ,"���������������",TamSx3("ZH_DTINIAS")[3] ,"","","","",".T."})
	aAdd(_aHeader,{RetTitle("ZH_DTFIMAS")   ,"ZH_DTFIMAS"  ,PesqPict("SZH","ZH_DTFIMAS") ,TamSx3("ZH_DTFIMAS")[1]  ,TamSx3("ZH_DTFIMAS")[2]   ,""       ,"���������������",TamSx3("ZH_DTFIMAS")[3] ,"","","","",".T."})
	aAdd(_aHeader,{RetTitle("ZH_STATUS")    ,"ZH_STATUS"   ,PesqPict("SZH","ZH_STATUS")  ,TamSx3("ZH_STATUS")[1]   ,TamSx3("ZH_STATUS")[2]    ,""       ,"���������������",TamSx3("ZH_STATUS")[3]  ,"","","","",".T."})
	
Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � STClick   �Autor  �Joao Rinaldi       � Data �  11/02/2016 ���
�������������������������������������������������������������������������͹��
���Desc.     � Fun��o para validar o Clique acionado pelo usu�rio na tela ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Steck Industria Eletrica Ltda.                             ���
�������������������������������������������������������������������������͹��
���Chamado   � 002612 - Automatizar Solicita��o de Compras                ���
���Solic.    � Juliana Queiroz - Depto. Compras                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function STClick(_aDados1,oDlgCons)
	
	Local nPosFLAG := aScan(oGetDados1:aHeader,{|x| AllTrim(x[2]) == "XX_FLAG"})
	Local _nJ		 := 0
	Local _nCount  := 0
	
	If oGetDados1:aCols[oGetDados1:nAt][nPosFLAG] == "LBNO" // DESMARCADO
		For _nJ := 1 to Len(oGetDados1:aCols)
			IF oGetDados1:aCols[_nJ][nPosFLAG] == "LBOK" // MARCADO
				_nCount ++
			EndIf
		Next _nJ
		
		If _nCount == 1
			Aviso("Sele��o de Aprovador"; //01 - cTitulo - T�tulo da janela
			,"Favor selecionar apenas um Aprovador."+CHR(10)+CHR(13)+;
				CHR(10)+CHR(13)+;
				"A��o n�o permitida.",;//02 - cMsg - Texto a ser apresentado na janela.
			{"OK"};                          //03 - aBotoes - Array com as op��es dos bot�es.
			,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
			,;                               //05 - cText - Titulo da Descri��o (Dentro da Janela)
			,;                               //06 - nRotAutDefault - Op��o padr�o usada pela rotina autom�tica
			,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
			,.F.;                            //08 - lEdit - Determina se permite a edi��o do campo memo
			,;                             //09 - nTimer - Tempo para exibi��o da mensagem em segundos.
			,;                               //10 - nOpcPadrao - Op��o padr�o apresentada na mensagem.
			)
		Else
			oGetDados1:aCols[oGetDados1:nAt][nPosFLAG] := "LBOK" // MARCADO
			oGetDados1:oBrowse:Refresh()
		EndIf
	Else
		oGetDados1:aCols[oGetDados1:nAt][nPosFLAG] := "LBNO" // DESMARCADO
		oGetDados1:oBrowse:Refresh()
	Endif
	
Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � STTOK     �Autor  �Joao Rinaldi       � Data �  11/02/2016 ���
�������������������������������������������������������������������������͹��
���Desc.     � Fun��o para validar a Confirma��o das informa��es marcadas ���
���          � na tela pelo usu�rio                                       ���
�������������������������������������������������������������������������͹��
���Uso       � Steck Industria Eletrica Ltda.                             ���
�������������������������������������������������������������������������͹��
���Chamado   � 002612 - Automatizar Solicita��o de Compras                ���
���Solic.    � Juliana Queiroz - Depto. Compras                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function STTOK(_aDados1)
	
	Local nPosFLAG   := aScan(oGetDados1:aHeader,{|x| AllTrim(x[2]) == "XX_FLAG"})
	Local nPosStatus := aScan(oGetDados1:aHeader,{|x| AllTrim(x[2]) == "ZH_STATUS"})
	Local nPosAprovp := aScan(oGetDados1:aHeader,{|x| AllTrim(x[2]) == "ZH_APROVP"})
	Local _nK
	Local _lRet      := .F.
	Local cStatus    := ''
	
	For _nK := 1 to Len(oGetDados1:aCols)
		IF oGetDados1:aCols[_nK][nPosFLAG] == "LBOK" // MARCADO
			_lRet := .T.
			Exit
		EndIf
	Next _nK
	
	If _lRet
		If oGetDados1:aCols[_nK][nPosStatus] $ '1/3' //Inativo/Bloqueado
			If oGetDados1:aCols[_nK][nPosStatus] == '1'
				cStatus := 'Inativo'
			ElseIf oGetDados1:aCols[_nK][nPosStatus] == '3'
				cStatus := 'Bloqueado'
			Endif
			Aviso("Sele��o de Aprovador"; //01 - cTitulo - T�tulo da janela
			,"O cadastro do aprovador "+Alltrim(USRRETNAME(oGetDados1:aCols[_nK][nPosAprovp]))+" est� com o Status "+cStatus+"."+CHR(10)+CHR(13)+;
				CHR(10)+CHR(13)+;
				"Voc� n�o ter� acesso a rotina."+CHR(10)+CHR(13)+;
				CHR(10)+CHR(13)+;
				"Favor verificar o cadastro do aprovador junto ao departamento de Compras.",;//02 - cMsg - Texto a ser apresentado na janela.
			{"OK"};                          //03 - aBotoes - Array com as op��es dos bot�es.
			,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
			,;                               //05 - cText - Titulo da Descri��o (Dentro da Janela)
			,;                               //06 - nRotAutDefault - Op��o padr�o usada pela rotina autom�tica
			,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
			,.F.;                            //08 - lEdit - Determina se permite a edi��o do campo memo
			,;                               //09 - nTimer - Tempo para exibi��o da mensagem em segundos.
			,;                               //10 - nOpcPadrao - Op��o padr�o apresentada na mensagem.
			)
			_cAprov := ''
			
		ElseIf oGetDados1:aCols[_nK][nPosStatus] $ '2'//Ativo/Substituto
			_cAprov := oGetDados1:aCols[_nK][nPosAprovp]
		ElseIf oGetDados1:aCols[_nK][nPosStatus] $ '4'//Ativo/Substituto
			_cAprov := oGetDados1:aCols[_nK][nPosAprovp] + __cUserId
			
		Endif
	Else
		Aviso("Sele��o de Aprovador"; //01 - cTitulo - T�tulo da janela
		,"Nenhuma Aprovador foi selecionado."+CHR(10)+CHR(13)+;
			CHR(10)+CHR(13)+;
			"",;                          //02 - cMsg - Texto a ser apresentado na janela.
		{"OK"};                          //03 - aBotoes - Array com as op��es dos bot�es.
		,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
		,;                               //05 - cText - Titulo da Descri��o (Dentro da Janela)
		,;                               //06 - nRotAutDefault - Op��o padr�o usada pela rotina autom�tica
		,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
		,.F.;                            //08 - lEdit - Determina se permite a edi��o do campo memo
		,;                               //09 - nTimer - Tempo para exibi��o da mensagem em segundos.
		,;                               //10 - nOpcPadrao - Op��o padr�o apresentada na mensagem.
		)
	Endif
	
Return oDlgCons:End()
