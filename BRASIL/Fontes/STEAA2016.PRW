#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    STEAA2015    Autor ³ Giovani.Zago       º Data ³  03/12/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ EAA 20?15							                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
*----------------------------------------*
User Function STEAA06()		//U_STEAA06()
	*----------------------------------------*
	//-- Dimensoes padroes
	Local aSize     := MsAdvSize(, .F., 400)
	Local aInfo 	:= {aSize[1],aSize[2],aSize[3],aSize[4]-12, 1, 1 }
	Local aObjects 	:= {{100, 100,.T.,.T. }}
	Local aPosObj 	:= MsObjSize( aInfo, aObjects,.T. )
	Local nStyle 	:= GD_INSERT+GD_DELETE+GD_UPDATE
	Local nOpca		:= 0
	Local acpos		:= {"XX_QTDD2","XX_COD"}
	Local aButtons	:= {}
	Local _nX		:= 0
	Local k			:= 0
	Local cAjLin	:= 30
	Local _cQuery1  := ""
	Local _cAlias1  := GetNextAlias()

	Private _cAno		:= Getmv("ST_ANOEAA",,'2020')
	Private cCadastro	:= "EAA - Entrevista Anual de Avaliação " + _cAno
	Private oDlg
	Private oLbx
	Private aVetor     := {}
	Private aVetor2    := {}
	Private _CVETOR3    := 'O Cliente em Primeiro Lugar     '
	Private oOk	   		:= LoadBitmap( GetResources(), "LBOK" )
	Private oNo	   		:= LoadBitmap( GetResources(), "LBNO" )
	Private _cPesq	   		:= Space(15)
	Private _oPesq
	Private _cVetor	   		:= ''
	Define FONT oFontN  NAME "Arial"
	Define FONT oFontB  NAME "Arial" BOLD
	Private oFontN  	:= TFont():New("Arial",9,25,.T.,.T.,5,.T.,5,.T.,.F.)
	Private oFontB 	    := TFont():New("Arial",9,50,.T.,.T.,5,.T.,5,.T.,.F.)
	Private _nPerg      := 1
	Private _cNome	   		:= Space(50)
	Private _oNome
	Private _cCargo	   		:= Space(20)
	Private _oCargo
	Private _cDepar	   		:= Space(20)
	Private _oDepar
	Private _dAdmi	   		:= ctod('  /  /    ')
	Private _oAdmi
	Private _dAval	   		:= dDataBase
	Private _oAval
	Private _cSuper	   		:= Space(20)
	Private _cMat2	   		:= ""
	Private _oSuper
	Private _cBox	   		:= ' '
	Private _oBox
	Private _aComb			:= {' ','1-Fortaleza','2-Área de Desenvolvimento'}
	Private	cMemo   		:= ' '
	Private oMemo
	Private	cMemo1   		:= ' '
	Private	cMemo2   		:= ' '
	Private oMemo1
	Private	_cCurso1    		:= Space(120)
	Private  _oCurso1
	Private	_cCurso2   		:= Space(120)
	Private  _oCurso2
	Private	_cCurso3   		:= Space(120)
	Private  _oCurso3
	Private	_cCurso4   		:= Space(120)
	Private  _oCurso4
	Private	_cCurso5   		:= Space(120)
	Private  _oCurso5
	Private _auser := {}
	Private oComb
	Private _aComb1		:= {' ','1-Alta Performance','2-Performance','3-Competente','4-Baixa Performance'}
	Private  _cRar := ' '
	Private  _cNota := ' '
	Private  _cSra := ' '

	Public  _cMat := ' '

	SRASP()

	//	UserArray()
	CarrVetor()
	For k:=1 To Len(aVetor)
		aadd(aVetor2,' ')
	Next k

	//StQuery( )

	_cQuery1 := " SELECT COUNT(*) QTD
	_cQuery1 += " FROM "+RetSqlName("SRA")+" RA
	_cQuery1 += " WHERE RA.D_E_L_E_T_=' ' AND RA_FILIAL='"+xFilial("SRA")+"'
	_cQuery1 += " AND RA_XUSRSUP='"+__cUserId+"'

	If !Empty(Select(_cAlias1))
		DbSelectArea(_cAlias1)
		(_cAlias1)->(dbCloseArea())
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

	dbSelectArea(_cAlias1)
	(_cAlias1)->(dbGoTop())

	If (_cAlias1)->QTD<=0
		//If Empty(ALltrim(_cMat))
		MsgInfo("Usuario nao cadastrado como Avaliador...!!!!!")
		return()
	EndIf
	//_cMat := ' '
	Define MSDialog oDlg Title cCadastro From aSize[7],000 To aSize[6],aSize[5] of GetWndDefault() Pixel

	@ 005+cAjLin,010 SAY "Nome"                                 SIZE 040,10 PIXEL OF oDlg FONT oFontN
	@ 005+cAjLin,040 MSGET _oNome   VAR _cNome Picture "@!"     SIZE 090,10 PIXEL OF oDlg F3 "SRA07"   VALID (GetNome(_cNome))

	@ 016+cAjLin,010 SAY "Cargo"                                SIZE 040,10 PIXEL OF oDlg FONT oFontN
	@ 016+cAjLin,040 MSGET _oCargo   VAR _cCargo Picture "@!"   SIZE 090,10 PIXEL OF oDlg WHEN .F.

	@ 027+cAjLin,010 SAY "Depar."                               SIZE 040,10 PIXEL OF oDlg FONT oFontN
	@ 027+cAjLin,040 MSGET _oDepar   VAR _cDepar Picture "@!"   SIZE 090,10 PIXEL OF oDlg WHEN .F.

	@ 005+cAjLin,140 SAY "Admissão"                             SIZE 040,10 PIXEL OF oDlg FONT oFontN
	@ 005+cAjLin,190 MSGET _oAdmi   VAR _dAdmi                  SIZE 090,10 PIXEL OF oDlg WHEN .F.

	@ 016+cAjLin,140 SAY "Avaliação"                            SIZE 040,10 PIXEL OF oDlg FONT oFontN
	@ 016+cAjLin,190 MSGET _oAval   VAR _dAval                  SIZE 090,10 PIXEL OF oDlg WHEN .F.

	@ 027+cAjLin,140 SAY "Avaliador"                            SIZE 040,10 PIXEL OF oDlg FONT oFontN
	@ 027+cAjLin,190 MSGET _oSuper   VAR _cSuper Picture "@!"   SIZE 090,10 PIXEL OF oDlg WHEN .F.

	@ 040+cAjLin,001  To 260+cAjLin,350   PIXEL of oDlg
	@ 040+cAjLin,001  To 066+cAjLin,050   PIXEL of oDlg
	@ 105+cAjLin,001  To 260+cAjLin,350   PIXEL of oDlg
	@ 040+cAjLin,001  To 066+cAjLin,350   PIXEL of oDlg
	@ 170+cAjLin,001  To 260+cAjLin,350   PIXEL of oDlg

	@ 046+cAjLin,006  SAY (cvaltochar(_nPerg)+'/'+ cvaltochar(Len(aVetor)))PIXEL FONT oFontN OF  oDlg
	@ 046+cAjLin,055  SAY _cVetor3 PIXEL FONT oFontN OF  oDlg SIZE 150,15

	@ 066+cAjLin,006  SAY SubStr(aVetor[_nPerg],001,75)	PIXEL FONT oFontN OF  oDlg
	@ 077+cAjLin,006  SAY SubStr(aVetor[_nPerg],076,75)	PIXEL FONT oFontN OF  oDlg
	@ 088+cAjLin,006  SAY SubStr(aVetor[_nPerg],151,75)	PIXEL FONT oFontN OF  oDlg

	@ 108+cAjLin,115  SAY  "RESPOSTA:" PIXEL FONT oFontN OF  oDlg
	@ 122+cAjLin,115 ComboBox oBox VAR _cRar  ITEMS  _aComb Of oDlg PIXEL SIZE 85,10 Valid RetAr()

	@ 180+cAjLin,10  SAY "Comentario Funcionario:" PIXEL FONT oFontN OF  oDlg
	oMemo	:= tMultiget():New(195+cAjLin,011,{|u|if(Pcount()>0,cMemo:=u,cMemo)},oDlg,300,50,,,,,,.T.)

	@ 10+cAjLin,355  SAY "Pontos Positivos:" PIXEL FONT oFontN OF  oDlg
	oMemo1	:= tMultiget():New(25+cAjLin,355,{|u|if(Pcount()>0,cMemo1:=u,cMemo1)},oDlg,300,50,,,,,,.T.)

	@ 85+cAjLin,355  SAY "Pontos de Melhorias:" PIXEL FONT oFontN OF  oDlg
	oMemo2	:= tMultiget():New(105+cAjLin,355,{|u|if(Pcount()>0,cMemo2:=u,cMemo2)},oDlg,300,50,,,,,,.T.)

	@ 180+cAjLin,355  SAY "Avaliação Geral" PIXEL FONT oFontN OF  oDlg
	@ 195+cAjLin,355  SAY "Nota:" PIXEL FONT oFontN OF  oDlg
	@ 215+cAjLin,385 ComboBox oBox1 VAR _cNota  ITEMS  _aComb1 Of oDlg PIXEL SIZE 85,10 Valid RetAr()

	//If _nPerg<11
	@ 145+cAjLin,165 Button "&Avançar"   size 50,15  action Avan('2') Pixel of oDlg
	//EndIf
	//If _nPerg>1
	@ 145+cAjLin,115 Button "&Voltar"    size 50,15  action Avan('1') Pixel of oDlg
	//EndIf

	//	@ 180+cAjLin,010 SAY "Plano de Desenvolvimento "  PIXEL OF oDlg FONT oFontN
	//	@ 195+cAjLin,010 SAY "1 - " SIZE 10,10 PIXEL OF oDlg FONT oFontN
	//	@ 195+cAjLin,040 MSGET _oCurso1   VAR _cCurso1 Picture "@!"     SIZE 160,10 PIXEL OF oDlg
	//	@ 206+cAjLin,010 SAY "2 - " SIZE 10,10 PIXEL OF oDlg FONT oFontN
	//	@ 206+cAjLin,040 MSGET _oCurso2   VAR _cCurso2 Picture "@!"     SIZE 160,10 PIXEL OF oDlg
	//	@ 217+cAjLin,010 SAY "3 - " SIZE 10,10 PIXEL OF oDlg FONT oFontN
	//	@ 217+cAjLin,040 MSGET _oCurso3   VAR _cCurso3 Picture "@!"     SIZE 160,10 PIXEL OF oDlg
	//	@ 228+cAjLin,010 SAY "4 - " SIZE 10,10 PIXEL OF oDlg FONT oFontN
	//	@ 228+cAjLin,040 MSGET _oCurso4   VAR _cCurso4 Picture "@!"     SIZE 160,10 PIXEL OF oDlg
	//	@ 239+cAjLin,010 SAY "5 - " SIZE 10,10 PIXEL OF oDlg FONT oFontN
	//	@ 239+cAjLin,040 MSGET _oCurso5   VAR _cCurso5 Picture "@!"     SIZE 160,10 PIXEL OF oDlg

	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||IIf(U_XEAATOK(), (nOpca := 1,oDlg:End()),nOpca:=0) },{||oDlg:End()},,aButtons)

	// se a opcao for encerrar executa a rotina.
	If nOpca == 1

		DbSelectArea("PPM")
		PPM->(DbSetOrder(2))
		PPM->(DbGoTop())
		PPM->(DbSeek(xFilial("PPM") + _cAno + PADR(_cSuper,30) + _cMat2))

		If PPM->(Eof())

			PPM->(RecLock("PPM",.T.))

			PPM->PPM_FILIAL	:= xFilial("PPM")
			PPM->PPM_ANO	:= _cAno
			PPM->PPM_01		:= _cNome
			PPM->PPM_02		:= _cCargo
			PPM->PPM_03		:= _cDepar
			PPM->PPM_04		:= _cSuper
			PPM->PPM_05		:= _dAdmi
			PPM->PPM_06		:= _dAval
			PPM->PPM_MAT	:= _cMat2

			PPM->PPM_CURSO1	:= _cCurso1
			PPM->PPM_CURSO2	:= _cCurso2
			PPM->PPM_CURSO3	:= _cCurso3
			PPM->PPM_CURSO4	:= _cCurso4
			PPM->PPM_CURSO5	:= _cCurso5

			PPM->PPM_07	:= cMemo
			PPM->PPM_08	:= cMemo1

			PPM->PPM_NOTA := _cNota

			PPM->PPM_09	:= aVetor2[1]
			PPM->PPM_10	:= aVetor2[2]
			PPM->PPM_11	:= aVetor2[3]
			PPM->PPM_12	:= aVetor2[4]
			PPM->PPM_13	:= aVetor2[5]
			//	PPM->PPM_14	:= aVetor2[6]
			//	PPM->PPM_15	:= aVetor2[7]
			//	PPM->PPM_16	:= aVetor2[8]
			//	PPM->PPM_17	:= aVetor2[9]
			//	PPM->PPM_18	:= aVetor2[10]
			//PPM->PPM_19	:= aVetor2[11]
			/*
			PPM->PPM_20	:= aVetor2[12]
			PPM->PPM_21	:= aVetor2[13]
			PPM->PPM_22	:= aVetor2[14]
			PPM->PPM_23	:= aVetor2[15]
			PPM->PPM_24	:= aVetor2[16]
			/*
			PPM->PPM_25	:= aVetor2[17]
			PPM->PPM_26	:= aVetor2[18]
			PPM->PPM_27	:= aVetor2[19]
			PPM->PPM_28	:= aVetor2[20]
			PPM->PPM_29	:= aVetor2[21]
			PPM->PPM_30	:= aVetor2[22]
			PPM->PPM_31	:= aVetor2[23]
			PPM->PPM_32	:= aVetor2[24]
			PPM->PPM_33	:= aVetor2[25]
			PPM->PPM_34	:= aVetor2[26]
			PPM->PPM_35	:= aVetor2[27]
			PPM->PPM_36	:= aVetor2[28]
			PPM->PPM_37	:= aVetor2[29]
			PPM->PPM_38	:= aVetor2[30]
			PPM->PPM_39	:= aVetor2[31]
			PPM->PPM_40	:= aVetor2[32]
			PPM->PPM_41	:= aVetor2[33]
			PPM->PPM_42	:= aVetor2[34]
			PPM->PPM_43	:= aVetor2[35]
			PPM->PPM_44	:= aVetor2[36]
			PPM->PPM_45	:= aVetor2[37]
			*/
			PPM->PPM_46	:= cMemo2


			If xFilial("PPM") $ ('02#03#04#05')
				PPM->PPM_EMP:= "01"
			ElseIf xFilial("PPM") $ ('01')
				PPM->PPM_EMP:= "03"
			EndIf

			PPM->(MsUnLock())

			MsgInfo("Gravação finalizada")

		Else

			MsgAlert("Já existe uma pesquisa com esse avaliador/avaliado")

		EndIf

	EndIf

	SRA->(DbClearFilter())
Return()
Static Function RetAr()
	aVetor2[_nPerg] :=  _cRar
Return(.T.)
Static Function Avan(_cOp)
	If _nPerg<=1 .And. _cOp = '1'
		MsgAlert("Impossível voltar")
		Return
	EndIf
	If _nPerg >= len(aVetor) .And. _cOp = '2'
		MsgAlert("Impossível avançar")
		Return
	EndIf

	If _cOp = '1'
		_nPerg--
	Else
		_nPerg++
	EndIf

	If _nPerg <= 1
		_nPerg:= 1
	EndIf
	If _nPerg >= len(aVetor)
		_nPerg:= len(aVetor)
	EndIf

	If _nPerg = 1
		_aComb			:= {' ','1-Fortaleza','2-Área de Desenvolvimento'}
		_cVetor3:='O Cliente em Primeiro Lugar     '
	ElseIf _nPerg = 2
		_aComb			:= {' ','1-Fortaleza','2-Área de Desenvolvimento'}
		_cVetor3:='Ser Disruptivo     '
	ElseIf _nPerg = 3
		_aComb			:= {' ','1-Fortaleza','2-Área de Desenvolvimento'}
		_cVetor3:='Abraçar o Diferente     '
	ElseIf _nPerg = 4
		_aComb			:= {' ','1-Fortaleza','2-Área de Desenvolvimento'}
		_cVetor3:='Aprender Todos os Dias     '
	ElseIf _nPerg = 5
		_aComb			:= {' ','1-Fortaleza','2-Área de Desenvolvimento'}
		_cVetor3:='Ser Dono do Negócio     '
		/*	ElseIf _nPerg = 6
		_aComb			:= {' ','1-Meta não alcançada','2-Meta parcialmente alcançada','3-Meta alcançada','4-Meta excedida','5-Meta constantemente excedida'}
		_cVetor3:='Diversidade/Respeito   |  '
		ElseIf _nPerg = 7
		_aComb			:= {' ','1-Meta não alcançada','2-Meta parcialmente alcançada','3-Meta alcançada','4-Meta excedida','5-Meta constantemente excedida'}
		_cVetor3:='Pessoas   |  '
		ElseIf _nPerg = 8
		_aComb			:= {' ','1-Meta não alcançada','2-Meta parcialmente alcançada','3-Meta alcançada','4-Meta excedida','5-Meta constantemente excedida'}
		_cVetor3:='Integridade e ética   |  '
		ElseIf _nPerg = 9
		_aComb			:= {' ','1-Meta não alcançada','2-Meta parcialmente alcançada','3-Meta alcançada','4-Meta excedida','5-Meta constantemente excedida'}
		_cVetor3:='Desafio/Challenge   |  '
		ElseIf _nPerg = 10
		_aComb			:= {' ','1-Meta não alcançada','2-Meta parcialmente alcançada','3-Meta alcançada','4-Meta excedida','5-Meta constantemente excedida'}
		_cVetor3:='Comprometimento/Commit   |  '
		ElseIf _nPerg = 11
		_aComb			:= {' ','1-Meta não alcançada','2-Meta parcialmente alcançada','3-Meta alcançada','4-Meta excedida','5-Meta constantemente excedida'}
		_cVetor3:='Segurança/Ergonomia   |  '
		*/
	EndIf
	_cRar:= aVetor2[_nPerg]

	ObjectMethod(oBox,"SetItems(_aComb)")
	ObjectMethod(oBox1,"SetItems(_aComb1)")
	_cRar:= aVetor2[_nPerg]
	oDlg:Refresh()
	//oComb:Refresh()
	oBox:Refresh()
	oBox1:Refresh()
	_cRar:= aVetor2[_nPerg]
Return()

Static Function GetNome(_cxNome)
	Local _lRe := .T.

	DbSelectArea("SRA")
	SRA->(DbSetOrder(1))
	IF SRA->(DbSeek(xFilial("SRA")+Alltrim(_cxNome)))
		_cNome  :=  SRA->RA_NOME
		_cCargo :=  DesCarCC()
		_cDepar :=   fDesc(IF(CtbInUse() , "CTT" , "SI3"),SRA->RA_CC,IF(CtbInUse(), "CTT_DESC01" , "I3_DESC"),,SRA->RA_FILIAL)
		_dAdmi  :=  SRA->RA_ADMISSA
		_cSuper :=  CUSERNAME
		_cMat2	:=  SRA->RA_MAT
	Else
		_lRe := .F.
	EndIf

	DbSelectArea("PPM")
	PPM->(DbSetOrder(2))
	PPM->(DbGoTop())
	PPM->(DbSeek(xFilial("PPM") + _cAno + PADR(_cSuper,30) + _cMat2))

	If PPM->(!Eof())
		_lRe := .F.
		MsgAlert("Já existe uma pesquisa com esse avaliador/avaliado para o ano de " + _cAno)
	EndIF

	_oNome:Refresh()
	_oCargo:Refresh()
	_oDepar:Refresh()
	_oAdmi:Refresh()
	_oSuper:Refresh()
	oDlg:Refresh()
Return(_lRe)

Static Function CarrVetor()

	aVetor := {	'Vou além pelos nossos clientes. Antecipo necessidades,trabalho para surpreender e trabalho como apoio para que a equipe comercial atenda bem os nossos clientes',;
	'Inovo,penso rápido e ajo ainda mais rápido.',;
	'Inclusivos,acolhemos todas as pessoas,independente de crença,idade,etnia,gênero e de todas as diferenças, para que todos se sintam valorizados.',;
	'Curioso,sempre buscando aprender algo novo todos os dias.',;
	'Atuo como "dono" e faço o meu melhor,com integridade e honestidade.'}		//seus
	/*
	'Qualidade',;
	'Produtividade',;
	'Absenteísmo',;
	'Entrega no prazo',;
	'5S'}
	*/

Return()

User Function XEAATOK()

	Local _lRet	:= .T.
	Local _nX	:= 0

	For _nX:=1 To Len(aVetor2)

		If Empty(aVetor2[_nX])
			MsgAlert("Atenção, a pergunta "+CVALTOCHAR(_nX)+" não foi preenchida")
			_lRet	:= .F.
		EndIf
	Next

Return(_lRet)

Static Function  SRASP()
	Local _afunc := {}
	Local _nX	:= 0
	Local _cRet := ' '
	/*
	If cEmpAnt = '01'
	aadd(_afunc,{	'04',	'000202',	'000477',	})
	aadd(_afunc,{	'04',	'000210',	'000477',	})
	aadd(_afunc,{	'04',	'000426',	'000477',	})
	aadd(_afunc,{	'04',	'000207',	'000477',	})
	aadd(_afunc,{	'04',	'000213',	'000477',	})
	aadd(_afunc,{	'04',	'000205',	'000477',	})
	aadd(_afunc,{	'04',	'000214',	'000477',	})
	aadd(_afunc,{	'04',	'000204',	'000477',	})
	aadd(_afunc,{	'04',	'000215',	'000477',	})
	aadd(_afunc,{	'04',	'000413',	'000477',	})
	aadd(_afunc,{	'04',	'000422',	'000477',	})
	aadd(_afunc,{	'04',	'000216',	'000477',	})
	aadd(_afunc,{	'04',	'000209',	'000477',	})
	aadd(_afunc,{	'04',	'000211',	'000477',	})
	aadd(_afunc,{	'04',	'000212',	'000477',	})
	aadd(_afunc,{	'04',	'000431',	'000477',	})
	aadd(_afunc,{	'04',	'000208',	'000477',	})
	aadd(_afunc,{	'04',	'000203',	'000477',	})
	aadd(_afunc,{	'04',	'000377',	'000975',	})
	aadd(_afunc,{	'02',	'000153',	'000975',	})
	aadd(_afunc,{	'04',	'000376',	'000975',	})
	aadd(_afunc,{	'04',	'000419',	'000975',	})
	aadd(_afunc,{	'04',	'000194',	'000975',	})
	aadd(_afunc,{	'04',	'000201',	'000975',	})
	aadd(_afunc,{	'03',	'000100',	'000366',	})
	aadd(_afunc,{	'03',	'000165',	'000366',	})
	aadd(_afunc,{	'03',	'000117',	'000366',	})
	aadd(_afunc,{	'03',	'000338',	'000366',	})
	aadd(_afunc,{	'03',	'000380',	'000366',	})
	aadd(_afunc,{	'03',	'000364',	'000366',	})
	aadd(_afunc,{	'03',	'000329',	'000366',	})
	aadd(_afunc,{	'03',	'000343',	'000231',	})
	aadd(_afunc,{	'03',	'000261',	'000231',	})
	aadd(_afunc,{	'03',	'000351',	'000231',	})
	aadd(_afunc,{	'04',	'000340',	'000304',	})
	aadd(_afunc,{	'04',	'000396',	'000304',	})
	aadd(_afunc,{	'04',	'000342',	'000304',	})
	aadd(_afunc,{	'04',	'000345',	'000304',	})
	aadd(_afunc,{	'02',	'000063',	'000677',	})
	aadd(_afunc,{	'02',	'000064',	'000677',	})
	aadd(_afunc,{	'02',	'000061',	'000677',	})
	aadd(_afunc,{	'02',	'000138',	'000677',	})
	aadd(_afunc,{	'02',	'000049',	'000677',	})
	aadd(_afunc,{	'02',	'000142',	'000677',	})
	aadd(_afunc,{	'02',	'000144',	'000677',	})
	aadd(_afunc,{	'02',	'000102',	'000677',	})
	aadd(_afunc,{	'02',	'000160',	'000677',	})
	aadd(_afunc,{	'02',	'000119',	'000677',	})
	aadd(_afunc,{	'02',	'000150',	'000677',	})
	aadd(_afunc,{	'02',	'000151',	'000677',	})
	aadd(_afunc,{	'02',	'000149',	'000677',	})
	aadd(_afunc,{	'02',	'000161',	'000677',	})
	aadd(_afunc,{	'02',	'000109',	'000677',	})
	aadd(_afunc,{	'02',	'000066',	'000677',	})
	aadd(_afunc,{	'02',	'000122',	'000677',	})
	aadd(_afunc,{	'04',	'000244',	'000594',	})
	aadd(_afunc,{	'04',	'000256',	'000594',	})
	aadd(_afunc,{	'04',	'000250',	'000594',	})
	aadd(_afunc,{	'04',	'000243',	'000594',	})
	aadd(_afunc,{	'04',	'000418',	'000594',	})
	aadd(_afunc,{	'04',	'000264',	'000594',	})
	aadd(_afunc,{	'04',	'000242',	'000594',	})
	aadd(_afunc,{	'04',	'000238',	'000594',	})
	aadd(_afunc,{	'04',	'000233',	'000594',	})
	aadd(_afunc,{	'04',	'000252',	'000594',	})
	aadd(_afunc,{	'04',	'000417',	'000594',	})
	aadd(_afunc,{	'02',	'000127',	'000402',	})
	aadd(_afunc,{	'04',	'009416',	'000034',	})
	aadd(_afunc,{	'03',	'000385',	'000378',	})
	aadd(_afunc,{	'03',	'009427',	'000378',	})
	aadd(_afunc,{	'03',	'000363',	'000378',	})
	aadd(_afunc,{	'03',	'000288',	'000378',	})
	aadd(_afunc,{	'03',	'000341',	'000645',	})
	aadd(_afunc,{	'03',	'000136',	'000380',	})
	aadd(_afunc,{	'03',	'000349',	'000380',	})
	aadd(_afunc,{	'03',	'000353',	'000380',	})
	aadd(_afunc,{	'03',	'009425',	'000380',	})
	aadd(_afunc,{	'03',	'000289',	'000380',	})
	aadd(_afunc,{	'03',	'000388',	'000527',	})
	aadd(_afunc,{	'02',	'000014',	'000415',	})
	aadd(_afunc,{	'02',	'000094',	'000415',	})
	aadd(_afunc,{	'02',	'000026',	'000415',	})
	aadd(_afunc,{	'02',	'000037',	'000415',	})
	aadd(_afunc,{	'02',	'000024',	'000415',	})
	aadd(_afunc,{	'02',	'000031',	'000415',	})
	aadd(_afunc,{	'02',	'000089',	'000415',	})
	aadd(_afunc,{	'02',	'000137',	'000415',	})
	aadd(_afunc,{	'02',	'000092',	'000415',	})
	aadd(_afunc,{	'02',	'000018',	'000415',	})
	aadd(_afunc,{	'02',	'000043',	'000415',	})
	aadd(_afunc,{	'02',	'000159',	'000415',	})
	aadd(_afunc,{	'02',	'000015',	'000415',	})
	aadd(_afunc,{	'02',	'000117',	'000415',	})
	aadd(_afunc,{	'02',	'000012',	'000415',	})
	aadd(_afunc,{	'02',	'000128',	'000415',	})
	aadd(_afunc,{	'02',	'000086',	'000415',	})
	aadd(_afunc,{	'02',	'000083',	'000415',	})
	aadd(_afunc,{	'02',	'000082',	'000415',	})
	aadd(_afunc,{	'02',	'000143',	'000415',	})
	aadd(_afunc,{	'02',	'000115',	'000415',	})
	aadd(_afunc,{	'02',	'000016',	'000415',	})
	aadd(_afunc,{	'02',	'000004',	'000415',	})
	aadd(_afunc,{	'02',	'000009',	'000415',	})
	aadd(_afunc,{	'02',	'000162',	'000415',	})
	aadd(_afunc,{	'02',	'000017',	'000415',	})
	aadd(_afunc,{	'02',	'000020',	'000415',	})
	aadd(_afunc,{	'02',	'000129',	'000415',	})
	aadd(_afunc,{	'02',	'000032',	'000415',	})
	aadd(_afunc,{	'02',	'000019',	'000415',	})
	aadd(_afunc,{	'02',	'000006',	'000415',	})
	aadd(_afunc,{	'02',	'000097',	'000415',	})
	aadd(_afunc,{	'02',	'000008',	'000415',	})
	aadd(_afunc,{	'02',	'000130',	'000415',	})
	aadd(_afunc,{	'02',	'000132',	'000415',	})
	aadd(_afunc,{	'02',	'000038',	'000415',	})
	aadd(_afunc,{	'02',	'000131',	'000415',	})
	aadd(_afunc,{	'02',	'000062',	'000415',	})
	aadd(_afunc,{	'02',	'000145',	'000415',	})
	aadd(_afunc,{	'02',	'000121',	'000415',	})
	aadd(_afunc,{	'04',	'009417',	'000690',	})
	aadd(_afunc,{	'03',	'000383',	'000678',	})
	aadd(_afunc,{	'03',	'000107',	'000678',	})
	aadd(_afunc,{	'03',	'000313',	'000678',	})
	aadd(_afunc,{	'03',	'000304',	'000678',	})
	aadd(_afunc,{	'03',	'000354',	'000678',	})
	aadd(_afunc,{	'03',	'000204',	'000678',	})
	aadd(_afunc,{	'03',	'000321',	'000678',	})
	aadd(_afunc,{	'03',	'000376',	'000678',	})
	aadd(_afunc,{	'03',	'000375',	'000678',	})
	aadd(_afunc,{	'03',	'000348',	'000678',	})
	aadd(_afunc,{	'03',	'000119',	'000678',	})
	aadd(_afunc,{	'03',	'000187',	'000678',	})
	aadd(_afunc,{	'03',	'000300',	'000678',	})
	aadd(_afunc,{	'03',	'000366',	'000678',	})
	aadd(_afunc,{	'03',	'000334',	'000678',	})
	aadd(_afunc,{	'03',	'000141',	'000678',	})
	aadd(_afunc,{	'03',	'000389',	'000678',	})
	aadd(_afunc,{	'03',	'000367',	'000678',	})
	aadd(_afunc,{	'04',	'000175',	'001009',	})
	aadd(_afunc,{	'04',	'000189',	'001009',	})
	aadd(_afunc,{	'04',	'000173',	'001009',	})
	aadd(_afunc,{	'04',	'000178',	'001009',	})
	aadd(_afunc,{	'04',	'000176',	'001009',	})
	aadd(_afunc,{	'04',	'000369',	'001009',	})
	aadd(_afunc,{	'04',	'000180',	'001009',	})
	aadd(_afunc,{	'04',	'000195',	'001009',	})
	aadd(_afunc,{	'04',	'000179',	'001009',	})
	aadd(_afunc,{	'04',	'000182',	'001009',	})
	aadd(_afunc,{	'03',	'000299',	'000574',	})
	aadd(_afunc,{	'03',	'000390',	'000574',	})
	aadd(_afunc,{	'03',	'000340',	'000574',	})
	aadd(_afunc,{	'03',	'000382',	'000574',	})
	aadd(_afunc,{	'04',	'000261',	'000323',	})
	aadd(_afunc,{	'04',	'000425',	'000323',	})
	aadd(_afunc,{	'04',	'000280',	'000323',	})
	aadd(_afunc,{	'04',	'000389',	'000323',	})
	aadd(_afunc,{	'04',	'000415',	'000323',	})
	aadd(_afunc,{	'04',	'000307',	'000323',	})
	aadd(_afunc,{	'04',	'000282',	'000323',	})
	aadd(_afunc,{	'04',	'000281',	'000323',	})
	aadd(_afunc,{	'04',	'000275',	'000323',	})
	aadd(_afunc,{	'04',	'000435',	'000323',	})
	aadd(_afunc,{	'04',	'000237',	'000323',	})
	aadd(_afunc,{	'04',	'000429',	'000323',	})
	aadd(_afunc,{	'04',	'000259',	'000323',	})
	aadd(_afunc,{	'04',	'000428',	'000323',	})
	aadd(_afunc,{	'04',	'000269',	'000323',	})
	aadd(_afunc,{	'04',	'000283',	'000323',	})
	aadd(_afunc,{	'04',	'000284',	'000323',	})
	aadd(_afunc,{	'04',	'000241',	'000323',	})
	aadd(_afunc,{	'04',	'000274',	'000323',	})
	aadd(_afunc,{	'04',	'000414',	'000323',	})
	aadd(_afunc,{	'04',	'000278',	'000323',	})
	aadd(_afunc,{	'04',	'000427',	'000323',	})
	aadd(_afunc,{	'04',	'000279',	'000323',	})
	aadd(_afunc,{	'04',	'000266',	'000323',	})
	aadd(_afunc,{	'04',	'000257',	'000323',	})
	aadd(_afunc,{	'04',	'000436',	'000323',	})
	aadd(_afunc,{	'04',	'000424',	'000323',	})
	aadd(_afunc,{	'04',	'000403',	'000323',	})
	aadd(_afunc,{	'04',	'000287',	'000323',	})
	aadd(_afunc,{	'04',	'000239',	'000323',	})
	aadd(_afunc,{	'04',	'000430',	'000323',	})
	aadd(_afunc,{	'04',	'000400',	'000323',	})
	aadd(_afunc,{	'04',	'000286',	'000323',	})
	aadd(_afunc,{	'04',	'000236',	'000323',	})
	aadd(_afunc,{	'03',	'000384',	'001018',	})
	aadd(_afunc,{	'03',	'000346',	'001018',	})
	aadd(_afunc,{	'03',	'000379',	'001018',	})
	aadd(_afunc,{	'03',	'000306',	'001018',	})
	aadd(_afunc,{	'04',	'000222',	'000670',	})
	aadd(_afunc,{	'04',	'000226',	'000670',	})
	aadd(_afunc,{	'04',	'000224',	'000670',	})
	aadd(_afunc,{	'04',	'000378',	'000670',	})
	aadd(_afunc,{	'04',	'000220',	'000670',	})
	aadd(_afunc,{	'04',	'000416',	'000670',	})
	aadd(_afunc,{	'04',	'000221',	'000670',	})
	aadd(_afunc,{	'04',	'000225',	'000670',	})
	aadd(_afunc,{	'04',	'000231',	'000670',	})
	aadd(_afunc,{	'04',	'000362',	'000670',	})
	aadd(_afunc,{	'04',	'000229',	'000670',	})
	aadd(_afunc,{	'04',	'000232',	'000670',	})
	aadd(_afunc,{	'04',	'000223',	'000670',	})
	aadd(_afunc,{	'04',	'000196',	'000896',	})
	aadd(_afunc,{	'02',	'000085',	'000896',	})
	aadd(_afunc,{	'04',	'000197',	'000896',	})
	aadd(_afunc,{	'03',	'000029',	'000896',	})
	aadd(_afunc,{	'04',	'000390',	'000896',	})
	aadd(_afunc,{	'04',	'000434',	'000896',	})
	aadd(_afunc,{	'03',	'000339',	'000391',	})
	aadd(_afunc,{	'03',	'000358',	'000391',	})
	aadd(_afunc,{	'03',	'000342',	'000391',	})
	aadd(_afunc,{	'03',	'000335',	'000391',	})
	aadd(_afunc,{	'03',	'000357',	'000391',	})
	aadd(_afunc,{	'03',	'000325',	'000391',	})
	aadd(_afunc,{	'04',	'000245',	'000326',	})
	aadd(_afunc,{	'04',	'000265',	'000326',	})
	aadd(_afunc,{	'04',	'000258',	'000326',	})
	aadd(_afunc,{	'04',	'000295',	'000326',	})
	aadd(_afunc,{	'04',	'000270',	'000326',	})
	aadd(_afunc,{	'04',	'000297',	'000326',	})
	aadd(_afunc,{	'04',	'000299',	'000326',	})
	aadd(_afunc,{	'04',	'000296',	'000326',	})
	aadd(_afunc,{	'04',	'000289',	'000326',	})
	aadd(_afunc,{	'04',	'000292',	'000326',	})
	aadd(_afunc,{	'04',	'000384',	'000326',	})
	aadd(_afunc,{	'03',	'000243',	'000294',	})
	aadd(_afunc,{	'03',	'000281',	'000081',	})
	aadd(_afunc,{	'03',	'000297',	'000081',	})
	aadd(_afunc,{	'04',	'000354',	'000475',	})
	aadd(_afunc,{	'04',	'000352',	'000475',	})
	aadd(_afunc,{	'04',	'000348',	'000475',	})
	aadd(_afunc,{	'04',	'000350',	'000475',	})
	aadd(_afunc,{	'04',	'000346',	'000475',	})
	aadd(_afunc,{	'04',	'000353',	'000475',	})

	aadd(_afunc,{	'03',	'000328',	'000591',	}) //Karina - Luis

	aadd(_afunc,{	'03',	'000262',	'000294',	})
	aadd(_afunc,{	'04',	'000403',	'000594',	})
	aadd(_afunc,{	'04',	'000264',	'000326',	})

	Else
	aadd(_afunc,{	'01',	'002161',	'000020',	})
	aadd(_afunc,{	'01',	'002239',	'000527',	})
	aadd(_afunc,{	'01',	'002104',	'000586',	})
	aadd(_afunc,{	'01',	'002281',	'000586',	})
	aadd(_afunc,{	'01',	'000168',	'000586',	})
	aadd(_afunc,{	'01',	'002175',	'000586',	})
	aadd(_afunc,{	'01',	'009032',	'000645',	})
	aadd(_afunc,{	'01',	'000604',	'000692',	})
	aadd(_afunc,{	'01',	'001454',	'000692',	})
	aadd(_afunc,{	'01',	'002252',	'000692',	})
	aadd(_afunc,{	'01',	'000812',	'000692',	})
	aadd(_afunc,{	'01',	'001418',	'000692',	})
	aadd(_afunc,{	'01',	'000698',	'000692',	})
	aadd(_afunc,{	'01',	'002248',	'000692',	})
	aadd(_afunc,{	'01',	'002280',	'000692',	})
	aadd(_afunc,{	'01',	'002156',	'000692',	})
	aadd(_afunc,{	'01',	'002229',	'000739',	})
	aadd(_afunc,{	'01',	'002233',	'000739',	})
	aadd(_afunc,{	'01',	'001968',	'000739',	})
	aadd(_afunc,{	'01',	'000117',	'000739',	})
	aadd(_afunc,{	'01',	'001296',	'000739',	})
	aadd(_afunc,{	'01',	'002251',	'000739',	})
	aadd(_afunc,{	'01',	'000550',	'000739',	})
	aadd(_afunc,{	'01',	'002237',	'000739',	})
	aadd(_afunc,{	'01',	'002288',	'000739',	})
	aadd(_afunc,{	'01',	'000716',	'000739',	})
	aadd(_afunc,{	'01',	'000899',	'000739',	})
	aadd(_afunc,{	'01',	'00047',	'000739',	})
	aadd(_afunc,{	'01',	'000631',	'000739',	})
	aadd(_afunc,{	'01',	'001022',	'000739',	})
	aadd(_afunc,{	'01',	'002180',	'000739',	})
	aadd(_afunc,{	'01',	'001606',	'000739',	})
	aadd(_afunc,{	'01',	'000680',	'000739',	})
	aadd(_afunc,{	'01',	'001806',	'000739',	})
	aadd(_afunc,{	'01',	'002207',	'000739',	})
	aadd(_afunc,{	'01',	'002250',	'000739',	})
	aadd(_afunc,{	'01',	'000373',	'000739',	})
	aadd(_afunc,{	'01',	'000681',	'000739',	})
	aadd(_afunc,{	'01',	'002214',	'000741',	})
	aadd(_afunc,{	'01',	'001544',	'000741',	})
	aadd(_afunc,{	'01',	'001121',	'000741',	})
	aadd(_afunc,{	'01',	'002258',	'000741',	})
	aadd(_afunc,{	'01',	'002220',	'000741',	})
	aadd(_afunc,{	'01',	'002282',	'000741',	})
	aadd(_afunc,{	'01',	'001821',	'000741',	})
	aadd(_afunc,{	'01',	'002260',	'000741',	})
	aadd(_afunc,{	'01',	'001827',	'000741',	})
	aadd(_afunc,{	'01',	'001771',	'000741',	})
	aadd(_afunc,{	'01',	'001278',	'000741',	})
	aadd(_afunc,{	'01',	'001977',	'000741',	})
	aadd(_afunc,{	'01',	'001842',	'000741',	})
	aadd(_afunc,{	'01',	'002212',	'000741',	})
	aadd(_afunc,{	'01',	'002262',	'000741',	})
	aadd(_afunc,{	'01',	'002026',	'000741',	})
	aadd(_afunc,{	'01',	'001545',	'000741',	})
	aadd(_afunc,{	'01',	'002035',	'000741',	})
	aadd(_afunc,{	'01',	'002255',	'000741',	})
	aadd(_afunc,{	'01',	'001325',	'000741',	})
	aadd(_afunc,{	'01',	'002017',	'000741',	})
	aadd(_afunc,{	'01',	'002254',	'000741',	})
	aadd(_afunc,{	'01',	'001641',	'000741',	})
	aadd(_afunc,{	'01',	'002222',	'000741',	})
	aadd(_afunc,{	'01',	'001206',	'000741',	})
	aadd(_afunc,{	'01',	'002052',	'000741',	})
	aadd(_afunc,{	'01',	'002271',	'000741',	})
	aadd(_afunc,{	'01',	'002145',	'000741',	})
	aadd(_afunc,{	'01',	'002109',	'000741',	})
	aadd(_afunc,{	'01',	'000622',	'000741',	})
	aadd(_afunc,{	'01',	'002218',	'000741',	})
	aadd(_afunc,{	'01',	'002185',	'000741',	})
	aadd(_afunc,{	'01',	'002028',	'000741',	})
	aadd(_afunc,{	'01',	'001186',	'000741',	})
	aadd(_afunc,{	'01',	'002261',	'000741',	})
	aadd(_afunc,{	'01',	'001332',	'000741',	})
	aadd(_afunc,{	'01',	'002200',	'000741',	})
	aadd(_afunc,{	'01',	'002224',	'000741',	})
	aadd(_afunc,{	'01',	'002076',	'000741',	})
	aadd(_afunc,{	'01',	'001501',	'000741',	})
	aadd(_afunc,{	'01',	'001675',	'000741',	})
	aadd(_afunc,{	'01',	'002146',	'000741',	})
	aadd(_afunc,{	'01',	'002201',	'000741',	})
	aadd(_afunc,{	'01',	'000953',	'000741',	})
	aadd(_afunc,{	'01',	'000644',	'000741',	})
	aadd(_afunc,{	'01',	'001604',	'000741',	})
	aadd(_afunc,{	'01',	'001282',	'000741',	})
	aadd(_afunc,{	'01',	'001095',	'000741',	})
	aadd(_afunc,{	'01',	'001175',	'000741',	})
	aadd(_afunc,{	'01',	'001893',	'000741',	})
	aadd(_afunc,{	'01',	'001919',	'000741',	})
	aadd(_afunc,{	'01',	'001107',	'000741',	})
	aadd(_afunc,{	'01',	'001833',	'000741',	})
	aadd(_afunc,{	'01',	'001897',	'000741',	})
	aadd(_afunc,{	'01',	'001990',	'000741',	})
	aadd(_afunc,{	'01',	'002257',	'000741',	})
	aadd(_afunc,{	'01',	'001781',	'000741',	})
	aadd(_afunc,{	'01',	'001733',	'000741',	})
	aadd(_afunc,{	'01',	'002259',	'000741',	})
	aadd(_afunc,{	'01',	'002025',	'000741',	})
	aadd(_afunc,{	'01',	'002221',	'000741',	})
	aadd(_afunc,{	'01',	'001239',	'000741',	})
	aadd(_afunc,{	'01',	'002219',	'000741',	})
	aadd(_afunc,{	'01',	'001767',	'000741',	})
	aadd(_afunc,{	'01',	'001851',	'000741',	})
	aadd(_afunc,{	'01',	'001338',	'000741',	})
	aadd(_afunc,{	'01',	'001948',	'000741',	})
	aadd(_afunc,{	'01',	'002056',	'000741',	})
	aadd(_afunc,{	'01',	'002211',	'000741',	})
	aadd(_afunc,{	'01',	'001928',	'000741',	})
	aadd(_afunc,{	'01',	'001441',	'000741',	})
	aadd(_afunc,{	'01',	'002202',	'000741',	})
	aadd(_afunc,{	'01',	'001978',	'000741',	})
	aadd(_afunc,{	'01',	'001964',	'000741',	})
	aadd(_afunc,{	'01',	'002256',	'000741',	})
	aadd(_afunc,{	'01',	'002066',	'000741',	})
	aadd(_afunc,{	'01',	'002099',	'000741',	})
	aadd(_afunc,{	'01',	'002267',	'000911',	})
	aadd(_afunc,{	'01',	'002272',	'000911',	})
	aadd(_afunc,{	'01',	'000756',	'000911',	})
	aadd(_afunc,{	'01',	'002240',	'000911',	})
	aadd(_afunc,{	'01',	'001952',	'000911',	})
	aadd(_afunc,{	'01',	'002264',	'000911',	})
	aadd(_afunc,{	'01',	'001304',	'000911',	})
	aadd(_afunc,{	'01',	'002235',	'000911',	})
	aadd(_afunc,{	'01',	'002284',	'000911',	})
	aadd(_afunc,{	'01',	'001170',	'000911',	})
	aadd(_afunc,{	'01',	'001494',	'000911',	})
	aadd(_afunc,{	'01',	'000893',	'000911',	})
	aadd(_afunc,{	'01',	'002287',	'000911',	})
	aadd(_afunc,{	'01',	'002186',	'000911',	})
	aadd(_afunc,{	'01',	'002293',	'000911',	})
	aadd(_afunc,{	'01',	'002173',	'000911',	})
	aadd(_afunc,{	'01',	'002246',	'000911',	})
	aadd(_afunc,{	'01',	'000721',	'000911',	})
	aadd(_afunc,{	'01',	'001665',	'000911',	})
	aadd(_afunc,{	'01',	'002273',	'000911',	})
	aadd(_afunc,{	'01',	'002216',	'000911',	})
	aadd(_afunc,{	'01',	'001178',	'000911',	})
	aadd(_afunc,{	'01',	'000878',	'000911',	})
	aadd(_afunc,{	'01',	'002054',	'000911',	})
	aadd(_afunc,{	'01',	'002143',	'000911',	})
	aadd(_afunc,{	'01',	'002265',	'000911',	})
	aadd(_afunc,{	'01',	'002100',	'000911',	})
	aadd(_afunc,{	'01',	'002203',	'000911',	})
	aadd(_afunc,{	'01',	'001998',	'000911',	})
	aadd(_afunc,{	'01',	'000416',	'000911',	})
	aadd(_afunc,{	'01',	'002295',	'000911',	})
	aadd(_afunc,{	'01',	'000394',	'000911',	})
	aadd(_afunc,{	'01',	'000553',	'000911',	})
	aadd(_afunc,{	'01',	'000923',	'000911',	})
	aadd(_afunc,{	'01',	'001443',	'000911',	})
	aadd(_afunc,{	'01',	'001225',	'000911',	})
	aadd(_afunc,{	'01',	'002189',	'000911',	})
	aadd(_afunc,{	'01',	'001917',	'000911',	})
	aadd(_afunc,{	'01',	'001992',	'000911',	})
	aadd(_afunc,{	'01',	'002000',	'000911',	})
	aadd(_afunc,{	'01',	'002168',	'000911',	})
	aadd(_afunc,{	'01',	'000694',	'000911',	})
	aadd(_afunc,{	'01',	'001283',	'000911',	})
	aadd(_afunc,{	'01',	'001888',	'000911',	})
	aadd(_afunc,{	'01',	'002243',	'000911',	})
	aadd(_afunc,{	'01',	'002169',	'000911',	})
	aadd(_afunc,{	'01',	'001716',	'000911',	})
	aadd(_afunc,{	'01',	'001536',	'000911',	})
	aadd(_afunc,{	'01',	'000531',	'000911',	})
	aadd(_afunc,{	'01',	'000896',	'000911',	})
	aadd(_afunc,{	'01',	'002289',	'000911',	})
	aadd(_afunc,{	'01',	'001845',	'000911',	})
	aadd(_afunc,{	'01',	'002115',	'000911',	})
	aadd(_afunc,{	'01',	'001936',	'000911',	})
	aadd(_afunc,{	'01',	'002188',	'000911',	})
	aadd(_afunc,{	'01',	'002244',	'000911',	})
	aadd(_afunc,{	'01',	'001967',	'000911',	})
	aadd(_afunc,{	'01',	'002020',	'000911',	})
	aadd(_afunc,{	'01',	'001347',	'000911',	})
	aadd(_afunc,{	'01',	'001817',	'000911',	})
	aadd(_afunc,{	'01',	'002242',	'000911',	})
	aadd(_afunc,{	'01',	'001602',	'000911',	})
	aadd(_afunc,{	'01',	'002263',	'000911',	})
	aadd(_afunc,{	'01',	'001768',	'000911',	})
	aadd(_afunc,{	'01',	'002197',	'000911',	})
	aadd(_afunc,{	'01',	'000931',	'000911',	})
	aadd(_afunc,{	'01',	'002279',	'000911',	})
	aadd(_afunc,{	'01',	'002234',	'000911',	})
	aadd(_afunc,{	'01',	'000414',	'000911',	})
	aadd(_afunc,{	'01',	'001404',	'000911',	})
	aadd(_afunc,{	'01',	'002266',	'000911',	})
	aadd(_afunc,{	'01',	'002285',	'000911',	})
	aadd(_afunc,{	'01',	'001812',	'000911',	})
	aadd(_afunc,{	'01',	'002160',	'000911',	})
	aadd(_afunc,{	'01',	'001979',	'000911',	})
	aadd(_afunc,{	'01',	'002291',	'000911',	})
	aadd(_afunc,{	'01',	'000779',	'000911',	})
	aadd(_afunc,{	'01',	'002278',	'000911',	})
	aadd(_afunc,{	'01',	'002108',	'000911',	})
	aadd(_afunc,{	'01',	'002270',	'000911',	})
	aadd(_afunc,{	'01',	'001340',	'000911',	})
	aadd(_afunc,{	'01',	'002283',	'000911',	})
	aadd(_afunc,{	'01',	'001970',	'000911',	})
	aadd(_afunc,{	'01',	'001355',	'000911',	})
	aadd(_afunc,{	'01',	'002121',	'000911',	})
	aadd(_afunc,{	'01',	'001101',	'000911',	})
	aadd(_afunc,{	'01',	'001079',	'000911',	})
	aadd(_afunc,{	'01',	'002286',	'000911',	})
	aadd(_afunc,{	'01',	'001925',	'000911',	})
	aadd(_afunc,{	'01',	'001492',	'000911',	})
	aadd(_afunc,{	'01',	'002269',	'000911',	})
	aadd(_afunc,{	'01',	'001570',	'000911',	})
	aadd(_afunc,{	'01',	'001411',	'000911',	})
	aadd(_afunc,{	'01',	'001368',	'000911',	})
	aadd(_afunc,{	'01',	'000784',	'000911',	})
	aadd(_afunc,{	'01',	'001623',	'000911',	})
	aadd(_afunc,{	'01',	'001118',	'000911',	})
	aadd(_afunc,{	'01',	'002268',	'000911',	})
	aadd(_afunc,{	'01',	'002018',	'000911',	})
	aadd(_afunc,{	'01',	'001580',	'000911',	})
	aadd(_afunc,{	'01',	'001553',	'000911',	})
	aadd(_afunc,{	'01',	'002079',	'000911',	})
	aadd(_afunc,{	'01',	'00034',	'000911',	})
	aadd(_afunc,{	'01',	'002292',	'000911',	})
	aadd(_afunc,{	'01',	'001697',	'000911',	})
	aadd(_afunc,{	'01',	'001774',	'000911',	})
	aadd(_afunc,{	'01',	'002195',	'000911',	})
	aadd(_afunc,{	'01',	'002236',	'000911',	})
	aadd(_afunc,{	'01',	'002274',	'000911',	})
	aadd(_afunc,{	'01',	'002247',	'000911',	})
	aadd(_afunc,{	'01',	'000808',	'000911',	})
	aadd(_afunc,{	'01',	'000737',	'000911',	})
	aadd(_afunc,{	'01',	'001811',	'000911',	})
	aadd(_afunc,{	'01',	'009033',	'000911',	})
	aadd(_afunc,{	'01',	'000238',	'000911',	})
	aadd(_afunc,{	'01',	'000902',	'000911',	})
	aadd(_afunc,{	'01',	'001856',	'000911',	})
	aadd(_afunc,{	'01',	'001786',	'000911',	})
	aadd(_afunc,{	'01',	'002196',	'000911',	})
	aadd(_afunc,{	'01',	'002182',	'000911',	})
	aadd(_afunc,{	'01',	'001542',	'000911',	})
	aadd(_afunc,{	'01',	'001578',	'000911',	})
	aadd(_afunc,{	'01',	'001122',	'000915',	})
	aadd(_afunc,{	'01',	'002253',	'000915',	})
	aadd(_afunc,{	'01',	'002198',	'000915',	})
	aadd(_afunc,{	'01',	'002276',	'000915',	})
	aadd(_afunc,{	'01',	'001621',	'000915',	})
	aadd(_afunc,{	'01',	'002249',	'000915',	})
	aadd(_afunc,{	'01',	'001401',	'000915',	})
	aadd(_afunc,{	'01',	'001097',	'000915',	})
	aadd(_afunc,{	'01',	'000990',	'000915',	})
	aadd(_afunc,{	'01',	'001940',	'000915',	})
	aadd(_afunc,{	'01',	'002275',	'000915',	})
	aadd(_afunc,{	'01',	'000299',	'000915',	})
	aadd(_afunc,{	'01',	'000306',	'000915',	})
	aadd(_afunc,{	'01',	'002296',	'000915',	})
	aadd(_afunc,{	'01',	'001491',	'000915',	})
	aadd(_afunc,{	'01',	'001502',	'000915',	})
	aadd(_afunc,{	'01',	'001601',	'000915',	})
	aadd(_afunc,{	'01',	'001352',	'000915',	})
	aadd(_afunc,{	'01',	'001279',	'000915',	})
	aadd(_afunc,{	'01',	'002245',	'000915',	})
	aadd(_afunc,{	'01',	'002277',	'000915',	})
	aadd(_afunc,{	'01',	'001343',	'000915',	})
	aadd(_afunc,{	'01',	'001946',	'000915',	})
	aadd(_afunc,{	'01',	'002238',	'000915',	})
	aadd(_afunc,{	'01',	'001834',	'000915',	})
	aadd(_afunc,{	'01',	'002210',	'000915',	})
	aadd(_afunc,{	'01',	'002194',	'000915',	})
	aadd(_afunc,{	'01',	'00065',	'000915',	})
	aadd(_afunc,{	'01',	'001841',	'001101',	})
	aadd(_afunc,{	'01',	'002294',	'001102',	})

	EndIf
	*/
	DbSelectArea("SRA")
	SRA->(DbSetOrder(1))

	For _nX:=1 To Len(_afunc)

		If   _afunc[_nX,3] = __cuserid
			_cRet+= _afunc[_nX,1]+_afunc[_nX,2]+'/'
		EndIf

		If SRA->(DbSeek(_afunc[_nX][1]+_afunc[_nX][2]))
			SRA->(RecLock("SRA",.F.))
			SRA->RA_XUSRSUP := _afunc[_nX][3]
			SRA->(MsUnLock())
		EndIf

	Next _nX

	SRA->(dbSetFilter({|| SRA->RA_XUSRSUP  =  __cUserId }," SRA->RA_XUSRSUP  =  __cUserId "))
	/*
	If !(Empty(Alltrim(_cRet)))
	//_cMat:= _cRet
	//DbSelectArea("SRA")
	//SRA->(DbSetOrder(1))

	//SRA->(dbSetFilter({|| SRA->RA_FILIAL+SRA->RA_MAT  $  _cMat }," SRA->RA_FILIAL+SRA->RA_MAT  $  _cMat "))
	SRA->(dbSetFilter({|| SRA->RA_XUSRSUP  =  __cUserId }," SRA->RA_XUSRSUP  =  __cUserId "))
	Else
	MsgInfo("Usuario não Cadastrado como Avaliador!!!!!")
	EndIf
	_cRet:= ' '
	*/
Return()
