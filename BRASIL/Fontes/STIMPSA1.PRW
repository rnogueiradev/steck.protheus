#include "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � STIMPSA1     �Autor  �Joao Rinaldi    � Data �  21/12/2015 ���
�������������������������������������������������������������������������͹��
���Desc.     � Programa desenvolvido para realizar a atualiza��o de       ���
���          � informa��es do Cadastro do Cliente chamada pelo ponto de   ���
���          � entrada MA030ROT.PRW                                       ���
�������������������������������������������������������������������������͹��
���Uso       � Steck Industria Eletrica Ltda.                             ���
�������������������������������������������������������������������������͹��
���Chamado   � 002260 - Atualiza��o de Cadastro                           ���
���Solic.    � Davi Souza - Depto. Finaiceiro                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function STIMPSA1 ()

	local c_patch_ori := space(100)
	local c_patch_log := space(100)
	local n_hdllog    :=  0
	Static a_filiais  := {}
	Private aLojaCli  := {}

	while sm0->(!eof()) .and. sm0->m0_codigo == cempant
	
		aadd ( a_filiais , sm0->m0_codfil )
		sm0->(dbskip())
	
	end
	sm0->(dbgotoP())

	if get_paramts(@c_patch_ori,@c_patch_log)
	
		n_hdllog := msfcreate( c_patch_log )
	
		//if  n_hdllog > 0
		
		Processa({||imparq_start( c_patch_ori, n_hdllog , a_filiais , c_patch_log ),"Processando... " })
		
		//endif
	endif

return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � get_paramts  �Autor  �Joao Rinaldi    � Data �  21/12/2015 ���
�������������������������������������������������������������������������͹��
���Desc.     � Programa desenvolvido para montagem da Tela para carregar  ���
���          � o arquivo .csv a ser importado                             ���
�������������������������������������������������������������������������͹��
���Uso       � Steck Industria Eletrica Ltda.                             ���
�������������������������������������������������������������������������͹��
���Chamado   � 002260 - Atualiza��o de Cadastro                           ���
���Solic.    � Davi Souza - Depto. Finaiceiro                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function get_paramts(c_patch_ori,c_patch_log)

	local abuttons     := {}
	local lget_paramts := .f.
	local oget1
	local oget2
	local ogroup1
	local ogroup2
	local odlg
	Local oSButton1
	Local oSButton2
	Local oButton1
	Local oButton2
	Local ogetpatchori
	Local ogetpatclog
	Local ogetpathbase

	define msdialog odlg title "Par�metros para execu��o" from 000, 000  to 180, 600 colors 0, 16777215 pixel

	@ 017, 005 group ogroup1 to 044, 242 prompt "Arquivo de Origem (.CSV)" of odlg color 0, 16777215 pixel
	@ 028, 009 msget ogetpatchori var c_patch_ori size 205, 010 of odlg colors 0, 16777215 pixel
	@ 028, 220 button obutton1 prompt "..." size 016, 009 of odlg pixel action helpfile(@lget_paramts,.t. , @c_patch_ori)
	@ 047, 005 group ogroup2 to 074, 242 prompt "Caminho do Log (.TXT)" of odlg color 0, 16777215 pixel
	@ 058, 009 msget ogetpatclog var c_patch_log size 205, 010 of odlg colors 0, 16777215 pixel
	@ 058, 220 button obutton2 prompt "..." size 016, 009 of odlg pixel action helpfile(@lget_paramts,.f., @c_patch_log)
	@ 077, 221 button obutton3 prompt "&OK" size 016, 009 of odlg pixel action vld_get_paramts( @lget_paramts , c_patch_ori , c_patch_log , @odlg)

	if !lget_paramts
		activate msdialog odlg centered
	endif

return (lget_paramts)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � helpfile     �Autor  �Joao Rinaldi    � Data �  21/12/2015 ���
�������������������������������������������������������������������������͹��
���Desc.     � Programa desenvolvido para informar o arquivo de origem e  ���
���          � arquivo destino                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Steck Industria Eletrica Ltda.                             ���
�������������������������������������������������������������������������͹��
���Chamado   � 002260 - Atualiza��o de Cadastro                           ���
���Solic.    � Davi Souza - Depto. Finaiceiro                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function helpfile(lget_paramts,lopenfile,cAdmArq)

	Local _cSaveArq      := Getmv("MV_RELT",,'C:\ARQUIVOS_PROTHEUS\')

	If MakeDir(_cSaveArq) == 0
		MakeDir(_cSaveArq)
	Endif
			
	if lopenfile
		cAdmArq := cGetFile("Arquivos CSV (*.CSV) |*.csv|";
			,"Selecione o Arquivo*",,_cSaveArq,.T.,,.F.,.F.)
	else
		cAdmArq := cGetFile("Arquivos TXT (*.TXT) |*.txt|";
			,"Salvar Como",,_cSaveArq,.F.,,.F.,.F.)
	endif

	IF empty(cAdmArq)
		lget_paramts := .f.
	else
		lget_paramts := .t.
	endif

	If !lopenfile .And. !Empty(Alltrim(cAdmArq))
		If !(".txt" $ cAdmArq)
			cAdmArq := cAdmArq+".txt"
		Endif
	Endif

return .t.

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � vld_get_paramts �Autor  �Joao Rinaldi � Data �  21/12/2015 ���
�������������������������������������������������������������������������͹��
���Desc.     � Programa desenvolvido para validar o arquivo de origem e   ���
���          � arquivo destino                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Steck Industria Eletrica Ltda.                             ���
�������������������������������������������������������������������������͹��
���Chamado   � 002260 - Atualiza��o de Cadastro                           ���
���Solic.    � Davi Souza - Depto. Finaiceiro                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function vld_get_paramts(lget_paramts,c_patch_ori,c_patch_log, odlg)

	lget_paramts := .t.

	if empty(c_patch_ori)
		aviso("imparq", "Informar caminho do arquivo de origem.",{"ok"})
		lget_paramts := .f.
	endif

	if empty(c_patch_log)
		aviso("imparq", "Informar caminho do arquivo de log.",{"ok"})
		lget_paramts := .f.
	endif

	IF lget_paramts
		odlg:END()
	END

return lget_paramts

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � imparq_start �Autor  �Joao Rinaldi    � Data �  21/12/2015 ���
�������������������������������������������������������������������������͹��
���Desc.     � Programa desenvolvido para realizar a leitura do arquivo   ���
���          � origem e realizar a atualiza��o no cadastro de Cliente     ���
�������������������������������������������������������������������������͹��
���Uso       � Steck Industria Eletrica Ltda.                             ���
�������������������������������������������������������������������������͹��
���Chamado   � 002260 - Atualiza��o de Cadastro                           ���
���Solic.    � Davi Souza - Depto. Finaiceiro                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function imparq_start( carqtxt , n_hdllog , a_filiais , c_patch_log )

	Local adados      := {}
	Local aCampos     := {}
	Local lPrim       := .T.
	Local c_cod       := criavar("A1_COD")
	Local c_loja      := criavar("A1_LOJA")
	Local c_xdtsera   := criavar("A1_XDTSERA")
	Local c_xdtcad    := criavar("A1_XDTCAD")
	Local c_risco     := criavar("A1_RISCO")
	Local c_lc        := criavar("A1_LC")
	Local c_venclc    := criavar("A1_VENCLC")
	Local c_xsegval   := criavar("A1_XSEGVAL")
	Local c_xhistor   := criavar("A1_XHISTOR")
	Local aSx3        := {}
	Local aInfo       := {}
	Local _cInfo1     := ''
	Local _cInfo2     := ''
	Local _cInfo3     := ''
	Local _cInfo4     := ''
	Local _cInfo5     := ''
	Local _cInfo6     := ''
	Local _cInfo7     := ''
	Local _cInfo8     := ''
	Local _cInfo9     := ''
	
	Local nAcao       := 0
	Local nQtde       := 0
	Local nTot1       := 0
	Local nTot2       := 0
	Local _nI
	Local _nJ
	Local _nK
	Local _nL
	
	ft_fuse(carqtxt)
	ProcRegua(FT_FLASTREC())// quantos registros ler
	ft_fgotop()

	while ( !ft_feof() )
	
		IncProc("Lendo arquivo texto...")
		
		clinha := ft_freadln()
	
		If lPrim
			aCampos := Separa(cLinha,";",.T.)
			aAdd(aSx3,{"A1_COD","A1_LOJA","A1_XDTSERA","A1_XDTCAD","A1_RISCO","A1_LC","A1_VENCLC","A1_XSEGVAL","A1_XHISTOR"})
			lPrim := .F.
		Else
			AADD(aDados,Separa(cLinha,";",.T.))
		EndIf

		ft_fskip()
	enddo

	For _nJ := 1 to Len(aCampos)
		IF !(aCampos[_nJ] == aSx3[1][_nJ])
			Aviso("Erro de Campo",;
				"O Campo '" + aCampos[_nJ] + "' digitado na planilha est� diferente do cadastro do Cliente ...!!! " + CHR(10)+CHR(13)+;
				CHR(10)+CHR(13)+;
				"O Processamento desse arquivo n�o ser� realizado ...!!! " + CHR(10)+CHR(13)+;
				CHR(10)+CHR(13),;
				{"OK"},3)
			Return
		Endif
	Next _nJ


	
	ProcRegua(Len(aDados))       //incrementa regua
	For _nI := 1 to Len(aDados)  //ler linhas da array
	
	//������������������������������������������������������������������������Ŀ
	//� Zero as vari�veis
	//��������������������������������������������������������������������������			
		aLojaCli := {}
		nQtde    := 0
		aInfo    := {}
	
		
		if len(adados[_nI]) != 9
			fwrite(n_hdllog,;
				"Formato da linha " + cvaltochar(_nI) + " � inv�lido !" + chr(9) + "As informa��es n�o ser�o atualizadas" + chr(9) + "Favor verificar...!!!";
				+ CRLF)
			ft_fskip()
			loop
		
		endif

		c_cod     := Strzero(Val(adados[_nI][1]),6)
		c_loja    := Strzero(Val(adados[_nI][2]),2)
		c_xdtsera := adados[_nI][3]
		c_xdtcad  := adados[_nI][4]
		c_risco   := adados[_nI][5]
		c_lc      := adados[_nI][6]
		c_venclc  := adados[_nI][7]
		c_xsegval := adados[_nI][8]
		c_xhistor := adados[_nI][9]
		
		aAdd(aInfo,{c_cod,c_loja,StrTran(c_xdtsera,"/",""),StrTran(c_xdtcad,"/",""),c_risco,c_lc,StrTran(c_venclc,"/",""),c_xsegval,c_xhistor})

		For _nL := 1 to Len(aCampos)
			IF Len(aInfo[1][_nL]) >  (TamSx3(aCampos[_nL])[1]+TamSx3(aCampos[_nL])[2]) .And. TamSx3(aCampos[_nL])[3] <> 'M' 
				Aviso("Erro de Tamanho de Campo",;
					"O Tamanho do Campo '" + aCampos[_nL] + "' digitado na planilha est� diferente do cadastro do Cliente ...!!! " + CHR(10)+CHR(13)+;
					CHR(10)+CHR(13)+;
					"O Processamento desse arquivo n�o ser� realizado ...!!! " + CHR(10)+CHR(13)+;
					CHR(10)+CHR(13),;
					{"OK"},3)
				Return
			Endif
		Next _nL

		STQUERY1(c_cod)
		For _nK := 1 to Len(aLojaCli)
			dbselectarea("SA1")
			SA1->(dbSetOrder(1))
			SA1->(DbGoTop())
			If dbseek( xFilial("SA1") + c_cod + aLojaCli[_nK][2])
				nQtde++
				_cInfo1 := SA1->A1_COD
				_cInfo2 := SA1->A1_LOJA
				_cInfo3 := SA1->A1_XDTSERA
				_cInfo4 := SA1->A1_XDTCAD
				_cInfo5 := SA1->A1_RISCO
				_cInfo6 := SA1->A1_LC
				_cInfo7 := SA1->A1_VENCLC
				_cInfo8 := SA1->A1_XSEGVAL
				_cInfo9 := SA1->A1_XHISTOR
				
				If nQtde == 1
					nTot1++
					SA1->(Reclock("SA1",.F.))
					SA1->A1_XDTSERA := cTod(c_xdtsera)
					SA1->A1_XDTCAD  := cTod(c_xdtcad)
					SA1->A1_RISCO   := c_risco
					SA1->A1_LC      := Val(c_lc)
					SA1->A1_VENCLC  := cTod(c_venclc)
					SA1->A1_XSEGVAL := Val(c_xsegval)
					SA1->A1_XHISTOR := SA1->A1_XHISTOR + CRLF + "Usu�rio: " + cUserName + " - Alterado em: " + DTOC(DDATABASE) + " " + TIME() + " - " +  c_xhistor
					SA1->(MsUnlock())
				Else
					nTot1++
					SA1->(Reclock("SA1",.F.))
					SA1->A1_XDTSERA := cTod(c_xdtsera)
					SA1->A1_XDTCAD  := cTod(c_xdtcad)
					SA1->A1_RISCO   := c_risco
					SA1->A1_LC      := 0
					SA1->A1_VENCLC  := cTod(c_venclc)
					SA1->A1_XSEGVAL := 0
					SA1->A1_XHISTOR := SA1->A1_XHISTOR + CRLF + "Usu�rio: " + cUserName + CHR(10)+CHR(13) + "Alterado em: " + DTOC(DDATABASE) + " " + TIME() + CHR(10)+CHR(13) +  c_xhistor
					SA1->(MsUnlock())
				Endif
			
				fwrite(n_hdllog ,;
					Alltrim(RetTitle("A1_COD"))+ " atualizado corretamente: " + Alltrim(RetTitle("A1_COD"))+"/"+ Alltrim(RetTitle("A1_LOJA")) +" -> "+ chr(9) + c_cod+"/"+aLojaCli[_nK][2];
					+ chr(9) + Alltrim(RetTitle("A1_XDTSERA"))   + " Antigo: -> " + DTOC(_cInfo3)       + chr(9) + Alltrim(RetTitle("A1_XDTSERA"))   + " Novo: -> " + c_xdtsera;
					+ chr(9) + Alltrim(RetTitle("A1_XDTCAD"))    + " Antigo: -> " + DTOC(_cInfo4)       + chr(9) + Alltrim(RetTitle("A1_XDTCAD"))    + " Novo: -> " + c_xdtcad;
					+ chr(9) + Alltrim(RetTitle("A1_RISCO"))     + " Antigo: -> " + _cInfo5             + chr(9) + Alltrim(RetTitle("A1_RISCO"))     + " Novo: -> " + c_risco;
					+ chr(9) + Alltrim(RetTitle("A1_LC"))        + " Antigo: -> " + cValtochar(_cInfo6) + chr(9) + Alltrim(RetTitle("A1_LC"))        + " Novo: -> " + Iif(nQtde==1,c_lc,'0');
					+ chr(9) + Alltrim(RetTitle("A1_VENCLC"))    + " Antigo: -> " + DTOC(_cInfo7)       + chr(9) + Alltrim(RetTitle("A1_VENCLC"))    + " Novo: -> " + c_venclc;
					+ chr(9) + Alltrim(RetTitle("A1_XSEGVAL"))   + " Antigo: -> " + cValtochar(_cInfo8) + chr(9) + Alltrim(RetTitle("A1_XSEGVAL"))   + " Novo: -> " + Iif(nQtde==1,c_lc,'0');
					+ chr(9) + Alltrim(RetTitle("A1_XHISTOR"))   + " Antigo: -> " + _cInfo9             + chr(9) + Alltrim(RetTitle("A1_XHISTOR"))   + " Novo: -> " + c_xhistor;
					+ CRLF  )
				ft_fskip()
				loop
			Else
				nTot2++
				fwrite(n_hdllog ,;
					Alltrim(RetTitle("A1_COD"))+ " n�o encontrado: " + Alltrim(RetTitle("A1_COD"))+"/"+ Alltrim(RetTitle("A1_LOJA")) +" -> "+ chr(9) + c_cod+"/"+aLojaCli[_nK][2];
					+ CRLF  )
				ft_fskip()
				loop
			endif

			ft_fuse()
			
		Next _nK
	Next _nI

	Aviso("Resumo do Processamento",;
		"Quantidade de Registros Atualizados Corretamente: " + Cvaltochar(nTot1) + CHR(10)+CHR(13)+;
		CHR(10)+CHR(13)+;
		"Quantidade de Registros N�o Atualizados: " + Cvaltochar(nTot2) + CHR(10)+CHR(13)+;
		CHR(10)+CHR(13),;
		{"OK"},3)

	nAcao:= Aviso("AVISO."," Visualizar LOG de Processamento ? ",{"&Sim","N�o"} )
	fclose(n_hdllog)
	
	if nAcao == 1
		shellexecute("open", c_patch_log, "", "", 1)
	endif


return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � STQUERY1     �Autor  �Joao Rinaldi    � Data �  21/12/2015 ���
�������������������������������������������������������������������������͹��
���Desc.     � Query do programa para retornar as lojas dispon�veis de    ���
���          � acordo com o c�digo do cliente passado como par�metro      ���
�������������������������������������������������������������������������͹��
���Uso       � Steck Industria Eletrica Ltda.                             ���
�������������������������������������������������������������������������͹��
���Chamado   � 002260 - Atualiza��o de Cadastro                           ���
���Solic.    � Davi Souza - Depto. Finaiceiro                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function STQUERY1(_cCod)

	Local cPerg      := "STIMPSA1"
	Local cTime      := Time()
	Local cHora      := SUBSTR(cTime, 1, 2)
	Local cMinutos   := SUBSTR(cTime, 4, 2)
	Local cSegundos  := SUBSTR(cTime, 7, 2)
	Local cAliasLif  := cPerg+cHora+cMinutos+cSegundos
	Local cAlias1    := cAliasLif
	Local cQuery1    := ' '

	cQuery1 := " SELECT
	cQuery1 += "  A1_COD  AS A1_COD
	cQuery1 += " ,A1_LOJA AS A1_LOJA
	cQuery1 += " FROM "+RetSqlName("SA1")+" SA1

	cQuery1 += " WHERE SA1.D_E_L_E_T_ = ' '
	cQuery1 += " AND A1_FILIAL  = '"+xFilial("SA1")+"'
	cQuery1 += " AND A1_COD     = '"+_cCod+"'
	cQuery1 += " ORDER BY A1_COD ,A1_LOJA

	If Select(cAlias1) > 0
		(cAlias1)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery1),cAlias1)

	DbSelectArea(cAlias1)
	(cAlias1)->(DbGoTop())
	If  Select(cAlias1) > 0
		While 	(cAlias1)->(!Eof())
			aAdd(aLojaCli, {(cAlias1)->A1_COD ,(cAlias1)->A1_LOJA })
			(cAlias1)->(dbskip())
		End
	Endif

Return aLojaCli