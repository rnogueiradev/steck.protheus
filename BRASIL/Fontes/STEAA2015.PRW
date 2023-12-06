#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    STEAA2015    Autor ³ Giovani.Zago       º Data ³  03/12/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ EAA 2015							                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
*----------------------------------------*
User Function STEAA2015()
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
	Local k		:= 0
	Private cCadastro := "EAA - Entrevista Anual de Avaliação 2015"
	Private oDlg
	Private oLbx
	Private aVetor     := {}
	Private aVetor2    := {}
	Private _CVETOR3    := 'Atividades Chave   |  PERGUNTA: '
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
	Private _aComb			:= {' ','1-N/A - Não se aplica','2-Não Realizou','3-Realizou Parcialmente','4-Realizou','5-Realizou e Melhorou o Processo'}
	Private	cMemo   		:= ' '
	Private oMemo
	Private	cMemo1   		:= ' '
	Private oMemo1
	Private	_cCurso    		:= Space(120)
	Private  _oCurso
	Private	_cCurso1   		:= Space(120)
	Private  _oCurso1
	Private	_cCurso2   		:= Space(120)
	Private  _oCurso2
	Private _auser := {}
	Private oComb
	Private  _cRar := ' '
	Public  _cMat := ' '
	
	UserArray()
	CarrVetor()
	For k:=1 To Len(aVetor)
		aadd(aVetor2,' ')
	Next k
	
	StQuery( )
	
	If Empty(ALltrim(_cMat))
		MsgInfo("Usuario nao cadastrado como Avaliador...!!!!!")
		return()
	EndIf
	Define MSDialog oDlg Title cCadastro From aSize[7],000 To aSize[6],aSize[5] of GetWndDefault() Pixel

	@ 005,010 SAY "Nome"                                 SIZE 040,10 PIXEL OF oDlg FONT oFontN
	@ 005,040 MSGET _oNome   VAR _cNome Picture "@!"     SIZE 090,10 PIXEL OF oDlg F3 "SRA06"   VALID (GetNome(_cNome))

	@ 016,010 SAY "Cargo"                                 SIZE 040,10 PIXEL OF oDlg FONT oFontN
	@ 016,040 MSGET _oCargo   VAR _cCargo Picture "@!"     SIZE 090,10 PIXEL OF oDlg WHEN .F.

	@ 027,010 SAY "Depar."                                 SIZE 040,10 PIXEL OF oDlg FONT oFontN
	@ 027,040 MSGET _oDepar   VAR _cDepar Picture "@!"     SIZE 090,10 PIXEL OF oDlg WHEN .F.

	@ 005,140 SAY "Admissão"                                 SIZE 040,10 PIXEL OF oDlg FONT oFontN
	@ 005,190 MSGET _oAdmi   VAR _dAdmi       SIZE 090,10 PIXEL OF oDlg WHEN .F.

	@ 016,140 SAY "Avaliação"                                 SIZE 040,10 PIXEL OF oDlg FONT oFontN
	@ 016,190 MSGET _oAval   VAR _dAval      SIZE 090,10 PIXEL OF oDlg WHEN .F.

	@ 027,140 SAY "Avaliador"                                 SIZE 040,10 PIXEL OF oDlg FONT oFontN
	@ 027,190 MSGET _oSuper   VAR _cSuper Picture "@!"     SIZE 090,10 PIXEL OF oDlg WHEN .F.

	@ 040,001  To 260,350   PIXEL of oDlg
	@ 040,001  To 66,050   PIXEL of oDlg
	@ 100,001  To 260,350   PIXEL of oDlg
	@ 040,001  To 66,350   PIXEL of oDlg
	@ 170,001  To 260,350   PIXEL of oDlg
	
	@ 046,006  SAY (cvaltochar(_nPerg)+'/'+ cvaltochar(Len(aVetor)))PIXEL FONT oFontN OF  oDlg
	@ 046,055  SAY _cVetor3 PIXEL FONT oFontN OF  oDlg SIZE 150,15
	
	@ 066,006  SAY aVetor[_nPerg]	PIXEL FONT oFontN OF  oDlg
 
	@ 101,055  SAY  "RESPOSTA:" PIXEL FONT oFontN OF  oDlg
	@ 122,055 ComboBox oBox VAR _cRar  ITEMS  _aComb Of oDlg PIXEL SIZE 85,10 Valid RetAr()
 
	@ 05,355  SAY "Comentario Funcionario:" PIXEL FONT oFontN OF  oDlg
	oMemo	:= tMultiget():New(020,355,{|u|if(Pcount()>0,cMemo:=u,cMemo)},oDlg,300,100,,,,,,.T.)
	
	@ 125,355  SAY "Comentario Avaliador:" PIXEL FONT oFontN OF  oDlg
	oMemo1	:= tMultiget():New(140,355,{|u|if(Pcount()>0,cMemo1:=u,cMemo1)},oDlg,300,100,,,,,,.T.)
 

	@ 145,055 Button "&Voltar"    size 50,15  action Avan('1') Pixel of oDlg
	@ 145,105 Button "&Avançar"   size 50,15  action Avan('2') Pixel of oDlg


	@ 180,010 SAY "LNT - Levantamento de Necessidade de Treinamento Técnico e/ou Comportamental "  PIXEL OF oDlg FONT oFontN
	@ 195,010 SAY "1 - " SIZE 10,10 PIXEL OF oDlg FONT oFontN
	@ 195,040 MSGET _oCurso   VAR _cCurso Picture "@!"     SIZE 160,10 PIXEL OF oDlg
	@ 206,010 SAY "2 - " SIZE 10,10 PIXEL OF oDlg FONT oFontN
	@ 206,040 MSGET _oCurso1   VAR _cCurso1 Picture "@!"     SIZE 160,10 PIXEL OF oDlg
	@ 217,010 SAY "3 - " SIZE 10,10 PIXEL OF oDlg FONT oFontN
	@ 217,040 MSGET _oCurso2   VAR _cCurso2 Picture "@!"     SIZE 160,10 PIXEL OF oDlg

	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| nOpca := 1,oDlg:End() },{||oDlg:End()},,aButtons)

// se a opcao for encerrar executa a rotina.
	If nOpca == 1
	
		DbSelectArea("PPM")
		PPM->(DbSetOrder(2))
		PPM->(DbGoTop())
		PPM->(DbSeek('  '+PADR(_cSuper,30)+_cMat2))
	
		If PPM->(Eof())
	
			PPM->(RecLock("PPM",.T.))
	
			PPM->PPM_FILIAL	:= '  '
			PPM->PPM_01		:= _cNome
			PPM->PPM_02		:= _cCargo
			PPM->PPM_03		:= _cDepar
			PPM->PPM_04		:= _cSuper
			PPM->PPM_05		:= _dAdmi
			PPM->PPM_06		:= _dAval
			PPM->PPM_MAT	:= _cMat2
	
			PPM->PPM_CURSO1	:= _cCurso
			PPM->PPM_CURSO2	:= _cCurso1
			PPM->PPM_CURSO3	:= _cCurso2
	
			PPM->PPM_07	:= cMemo
			PPM->PPM_08	:= cMemo1
	
			PPM->PPM_09	:= aVetor2[1]
			PPM->PPM_10	:= aVetor2[2]
			PPM->PPM_11	:= aVetor2[3]
			PPM->PPM_12	:= aVetor2[4]
			PPM->PPM_13	:= aVetor2[5]
			PPM->PPM_14	:= aVetor2[6]
			PPM->PPM_15	:= aVetor2[7]
			PPM->PPM_16	:= aVetor2[8]
			PPM->PPM_17	:= aVetor2[9]
			PPM->PPM_18	:= aVetor2[10]
			PPM->PPM_19	:= aVetor2[11]
			PPM->PPM_20	:= aVetor2[12]
			PPM->PPM_21	:= aVetor2[13]
			PPM->PPM_22	:= aVetor2[14]
			PPM->PPM_23	:= aVetor2[15]
			PPM->PPM_24	:= aVetor2[16]
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
	Local _aRet :={}

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
	
	If _nPerg <= 4
		_aComb:= {' ','1-N/A - Não se aplica','2-Não Realizou','3-Realizou Parcialmente','4-Realizou','5-Realizou e Melhorou o Processo'}
		_cVetor3:='Atividades Chave   |  PERGUNTA: '
	ElseIf _nPerg <= 25
		_aComb:={' ','1-N/A - Não se aplica','2-Não possui','3-Básico','4-Intermediário','5-Avançado'}
		_cVetor3:='Conhecimentos      |  PERGUNTA: '
	Else
		_aComb:={' ','1-N/A - Não se aplica','2-Não possui','3-Bom','4-Ótimo','5-Excelente'}
		_cVetor3:='Habilidades        |  PERGUNTA: '
	EndIf
	_cRar:= aVetor2[_nPerg]

	ObjectMethod(oBox,"SetItems(_aComb)")
	_cRar:= aVetor2[_nPerg]
	oDlg:Refresh()
	//oComb:Refresh()
	oBox:Refresh()
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
	PPM->(DbSeek('  '+PADR(_cSuper,30)+_cMat2))
	
	If PPM->(!Eof())
		_lRe := .F.
		MsgAlert("Já existe uma pesquisa com esse avaliador/avaliado")
	EndIF
	
 
	_oNome:Refresh()
	_oCargo:Refresh()
	_oDepar:Refresh()
	_oAdmi:Refresh()
	_oSuper:Refresh()
	oDlg:Refresh()
Return(_lRe)

Static Function CarrVetor()

	aVetor     := {'Conhece a missão, visão e valores da Steck?',;
		'Participa de Palestras, treinamentos e programas referentes à Qualidade, Segurança do Trabalho e Medicina Ocupacional?',;
		'Segue as regras de Segurança determinadas para a área e a função?',;
		'Segue as regras do nosso código de ética e príncipios de responsabilidade?',;
		'Pratica o conceito do 5S?',;
		'Boas práticas de fabricação',;
		'Comando Lógico Programável',;
		'Ergonomia (Conhecimentos sobre a disciplina que estuda os seres humanos e o meio ambiente a sua volta, visando evitar lesões e otimizar um bem estar físico e mental)',;
		'Esquemas Elétricos e Eletrônicos',;
		'Fala outro idioma?',;
		'Informática: Pacote Office	',;
		'Informática: Protheus',;
		'Instrumentos de Medição (sabe utilizar e calibrar as ferramentas pertinentes às medições de produtos, suas aplicações e preservação)',;
		'Introdução ao Lean Manufactoring',;
		'Kaizen	',;
		'Kanban	',;
		'Leitura e Interpretação de Desenho Técnico',;
		'Manuseio de Produtos Químicos',;
		'Noções de combate à incêndio',;
		'Nossos Produtos',;
		'NR10 - Instalações e Serviços em Eletricidade',;
		'NR12 - Proteção de Máquinas e Equipamentos	',;
		'Operação de Empilhadeira',;
		'Operação de Pontes Rolantes	',;
		'Técnicas de Negociação	',;
		'Técnicos na área de atuação	',;
		'Relacionamento com Clientes Internos',;
		'Relacionamento com Clientes Externos',;
		'Criatividade	',;
		'Disciplina (horário)',;
		'Iniciativa	',;
		'Interesse em Aprendizado',;
		'Organização		',;
		'Orientação para o Resultado (comprometimento)',;
		'Polivalência (capacidade da pessoa ter multiplas funções)',;
		'Relacionamento Interpessoal (habilidade de se relacionar com outras pessoas garantindo que as rotinas de trabalho sejam realizadas)',;
		'Trabalho em Equipe (tem a capacidade de ser cooperativo e consciente do seu papel no contexto organizacional)';
		;//, tendo atitudes favoráveis no desenvolvimento de trabalhos em grupo, procurando manter relacionamento amigável e transparente que possibilite a troca de informações entre a equipe)';
		}




Return()



 




 

*----------------------------------------*
Static Function StQuery( )
*----------------------------------------*
	Local cQuery     := ' '
	 
	Local	_nMat := 0
	Local cAliasLif := 'srmat01'
 
 


	_nMat  		:= aScan(_auser, {|x| Upper(AllTrim(x[2])) == __cUserId})
	If _nMat > 0
	
		cQuery := " SELECT
		cQuery += " RA_MAT
		cQuery += " FROM "+ RetSQLName("SRA") +" SRA"
		cQuery += " INNER JOIN(SELECT * FROM "+ RetSQLName("SQB") +" )SQB"
		cQuery += " ON SQB.D_E_L_E_T_ = ' '
		cQuery += " AND SRA.RA_DEPTO = SQB.QB_DEPTO
		cQuery += " AND SQB.QB_MATRESP = '"+_auser[_nMat,1]+"' "
		cQuery += " WHERE  SRA.D_E_L_E_T_ = ' '
		cQuery += " AND  SQB.QB_MATRESP <> SRA.RA_MAT AND SRA.RA_SITFOLH <> 'D'

		cQuery := ChangeQuery(cQuery)

		If Select(cAliasLif) > 0
			(cAliasLif)->(dbCloseArea())
		EndIf

		dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

		dbSelectArea(cAliasLif)
		(cAliasLif)->(dbgotop())
		If  Select(cAliasLif) > 0
	
			While 	(cAliasLif)->(!Eof())
		
		
				_cMat	+=	(cAliasLif)->RA_MAT+'/'
	
		
				(cAliasLif)->(dbskip())
		
			End
	


			DbSelectArea("SRA")
			SRA->(DbSetOrder(1))
	
			SRA->(dbSetFilter({|| SRA->RA_MAT  $  _cMat }," SRA->RA_MAT $ _cMat "))
	
	
		EndIf
	EndIf
Return()

Static Function UserArray()

	If cEmpAnt = '01'
	aadd(_auser,{'003319','000579'})
	aadd(_auser,{'002046','000067'})
	aadd(_auser,{'002839','000321'})
	aadd(_auser,{'000067','000076'})
	aadd(_auser,{'000157','000025'})
	aadd(_auser,{'000213','000600'})
 	aadd(_auser,{'000163','000251'})
	aadd(_auser,{'003319','000579'})
	aadd(_auser,{'000247','000644'})
	aadd(_auser,{'900000','000591'})
	aadd(_auser,{'003381','000707'})
	aadd(_auser,{'002271','000192'})
	aadd(_auser,{'002372','000190'})
	aadd(_auser,{'000197','000952'})
	aadd(_auser,{'000070','000415'})
	aadd(_auser,{'000169','000529'})
	aadd(_auser,{'002875','000480'})
	aadd(_auser,{'002481','000720'})
	aadd(_auser,{'001930','000586'})
	aadd(_auser,{'001841','000020'})
	aadd(_auser,{'000190','000483'})
	aadd(_auser,{'002107','000625'})
 	aadd(_auser,{'002104','000692'})
	aadd(_auser,{'000003','000355'})
 	aadd(_auser,{'000133','000202'})
	aadd(_auser,{'003361','000663'})
	aadd(_auser,{'001106','000477'})
	aadd(_auser,{'000069','000402'})
	aadd(_auser,{'003192','000304'})
	aadd(_auser,{'000173','000530'})
	aadd(_auser,{'000197','000952'})
	aadd(_auser,{'002700','000323'})
	aadd(_auser,{'000112','000392'})
	aadd(_auser,{'000203','000046'})
	aadd(_auser,{'001439','000039'})
	aadd(_auser,{'002378','000075'})
	aadd(_auser,{'001490','000084'})
	aadd(_auser,{'002046','000067'})
	aadd(_auser,{'003319','000579'})
 	aadd(_auser,{'002378','000075'})
	aadd(_auser,{'000246','000645'})
	aadd(_auser,{'000273','000722'})
	aadd(_auser,{'000159','000103'})
	aadd(_auser,{'000126','000722'})
	aadd(_auser,{'000051','000446'})
	aadd(_auser,{'002863','000594'})
	aadd(_auser,{'003210','000326'})
	aadd(_auser,{'001450','000670'})
	aadd(_auser,{'000142','000294'})
	aadd(_auser,{'000158','000314'})
	aadd(_auser,{'000230','000628'})
	aadd(_auser,{'000158','000314'})
	aadd(_auser,{'000230','000628'})
	aadd(_auser,{'000158','000314'})
	aadd(_auser,{'000244','000627'})
	aadd(_auser,{'000048','000170'})
	aadd(_auser,{'000047','000231'})
	aadd(_auser,{'000062','000315'})
	aadd(_auser,{'000000','000000'})
	aadd(_auser,{'000203','000046'})
	aadd(_auser,{'001690','000351'})
	aadd(_auser,{'000074','000088'})
	aadd(_auser,{'000088','000074'})
	aadd(_auser,{'000086','000041'})
	aadd(_auser,{'000041','000086'})
	aadd(_auser,{'900002','000592'})
	Else
	aadd(_auser,{'900005','000645'})
  
	aadd(_auser,{'900001','000952'})
	aadd(_auser,{'900003','000272'})
	aadd(_auser,{'900002','000103'})
	aadd(_auser,{'900004','000025'})
	aadd(_auser,{'900001','000272'})
	aadd(_auser,{'900006','000402'})
	
	
	EndIf

return()
 