#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

#Define CR chr(13)+chr(10)
/*====================================================================================\
|Programa  | STONEVOICE       | Autor | GIOVANI.ZAGO             | Data | 22/09/2014  |
|=====================================================================================|
|Descrição |   STONEVOICE  Pesquisa ONE VOICE - 2018                                  |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | STONEVOICE                                                               |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
User Function STOV2018()   //  u_STOV2017() 
	*-----------------------------*
	//-- Dimensoes padroes
	Local aSize     := MsAdvSize(, .F., 400)
	Local aInfo 	:= {aSize[1],aSize[2],aSize[3],aSize[4]-12, 1, 1 }
	Local aObjects 	:= {{100, 100,.T.,.T. }}
	Local aPosObj 	:= MsObjSize( aInfo, aObjects,.T. )
	Local nOpca		:= 0
	Private _cRar := SPACE(30)
	Private cCadastro := "ONE VOICE"
	Private oDlg
	Private oDlg1
	Private oOk	   	   := LoadBitmap( GetResources(), "LBOK" )
	Private oNo	   	   := LoadBitmap( GetResources(), "LBNO" )

	//	Private oChk1
	//	Private oChk2
	//	Private oChk3
	//	Private oChk4
	//	Private oChk5
	//	Private oChk6
	//	Private oChk7
	//	Private oChk8
	//	Private oChk9
	//	Private oChk10
	//	Private oChk11
	//	Private oChk12
	//	Private oChk13
	//	Private oChk14
	//	Private oChk15
	//	Private oChk16
	//	Private oChk17
	//	Private oChk18
	//	Private oChk19
	//	Private oChk20
	//	Private oChk21
	//	Private oChk22
	//	Private oChk23
	//	Private oChk24
	//	Private oChk25

	//	Private lChk1 	   := .t.
	Private lChk2 	   := .f.
	Private lChk3 	   := .t.
	//	Private lChk4 	   := .f.
	//	Private lChk5 	   := .f.
	//	Private lChk6 	   := .f.
	//	Private lChk7 	   := .f.
	//	Private lChk8 	   := .f.
	//	Private lChk9 	   := .f.
	//	Private lChk10 	   := .f.
	//	Private lChk11 	   := .f.
	//	Private lChk12 	   := .f.
	//	Private lChk13 	   := .f.
	//	Private lChk14 	   := .f.
	//	Private lChk15 	   := .f.
	//	Private lChk16 	   := .f.
	//	Private lChk17 	   := .f.
	//	Private lChk18 	   := .f.
	//	Private lChk19 	   := .f.
	//	Private lChk20 	   := .f.
	//	Private lChk21 	   := .f.
	//	Private lChk22 	   := .f.
	//	Private lChk23 	   := .f.
	//	Private lChk24 	   := .f.
	//	Private lChk25 	   := .f.

	If ! ( __CUSERID $ GetMv("ST_ONEVOI",,'000000') + '000000' )
		PPC->(DbSetOrder(3))
		If PPC->(DbSeek(xFilial("PPC")+StrZero(Year(dDataBase),4)+__CUSERID))
			MsgAlert("Olá " + cUserName + ", pesquisa já respondida este ano.")
			Return
		EndIf
	EndIf

	Define FONT oFontN  NAME "Arial"
	Define FONT oFontB  NAME "Arial" BOLD

	Private oFontN  	:= TFont():New("Arial",9,15,.T.,.T.,5,.T.,5,.T.,.F.)
	Private oFontB 	    := TFont():New("Arial",9,18,.T.,.T.,5,.T.,5,.T.,.F.)

	Private oBmp

	Private cStat01     := space(25)
	Private oStat01
	Private cStat02     := space(25)
	Private oStat02
	Private cStat03     := space(25)
	Private oStat03
	Private cStat04     := space(25)
	Private oStat04
	Private cStat05     := space(25)
	Private oStat05
	Private cStat06     := space(25)
	Private oStat06
	Private cStat07     := space(25)
	Private oStat07
	Private cStat08     := space(25)
	Private oStat08
	Private cStat09     := space(25)
	Private oStat09
	Private cStat10     := space(25)
	Private oStat10
	Private cStat11     := space(25)
	Private oStat11
	Private cStat12     := space(25)
	Private oStat12
	Private cStat13     := space(25)
	Private oStat13
	Private cStat14     := space(25)
	Private oStat14
	Private cStat15     := space(25)
	Private oStat15
	Private cStat16     := space(25)
	Private oStat16

	//	Private cStat17     := space(1)
	//	Private oStat17

	Private cDesc       := space(400)
	Private oDesc
	Private _nlin       :=0
	Private _nlin7      :=10
	Private _nlin12     :=15
	Private bOk     := {|| VldInfos(),nOpca:=1, oDlg:End() }
	Private bCancel := {|| oDlg:End() }
	Private   oBtnOk, oBtnCancel

	/*
	If !(__CUSERID $ GetMv("ST_ONEVOI",,'000000')+'')
	MsgInfo("Pesquisa Encerrada")
	return()
	EndIf
	*/
	If !STFINATOT()
		MsgInfo("Departamento não Escolhido")
		return()
	EndIf
	If Empty(Alltrim(_cRar))
		MsgInfo("Departamento não Escolhido")
		return()
	EndIf

	DEFINE MSDIALOG oDlg TITLE cCadastro FROM 0,0 TO aSize[6]+400,aSize[5]-30   of GetWndDefault() Pixel
	EnchoiceBar(oDlg,{|| nOpca := 1,oDlg:End() },{||oDlg:End()},,)

	@ 010, 563 BITMAP oBmp SIZE 090, 205 OF oDlg FILENAME "\bmp\teckinho.bmp" NOBORDER PIXEL
	//@ 001, 300  BITMAP oBmp SIZE 070, 015 OF oDlg FILENAME "\bmp\logo.bmp" NOBORDER PIXEL

	//	@ 001,001  To 170,167   PIXEL of oDlg
	//	@ 001,001  To 038,167   PIXEL of oDlg
	//	@ 001,001  To 106,167   PIXEL of oDlg

	/*------------------------------------------------------------------------------------------------------
	//---------------- Richard 27/10/17 - Excluidas as perguntas de Sexo, Idade, Tempo Steck
	//------------------------------------------------------------------------------------------------------
	@  002,005 	Say "1. Por favor, indique seu sexo:" PIXEL of oDlg  FONT oFontB COLOR CLR_RED

	oChk2 := TCheckBox():Create( oDlg,{|u| If(PCount()>0,lChk2:=u,lChk2) },012,005,"Feminino",100,210,,,,,,,,.T.,,,)
	oChk2:cVariable 		:= "lChk2"
	oChk2:blClicked  		:= {|| RefreOne(2) }

	oChk3 := TCheckBox():Create( oDlg,{|u| If(PCount()>0,lChk3:=u,lChk3) },021,005,"Masculino",100,210,,,,,,,,.T.,,,)
	oChk3:cVariable 		:= "lChk3"
	oChk3:blClicked  		:= {|| RefreOne(3) }

	@  040,005 	Say "2. Qual é a sua idade:" PIXEL of oDlg  FONT oFontB COLOR CLR_RED

	oChk4 := TCheckBox():Create( oDlg,{|u| If(PCount()>0,lChk4:=u,lChk4) },050,005,"19 anos ou menos",100,210,,,,,,,,.T.,,,)
	oChk4:cVariable 		:= "lChk4"
	oChk4:blClicked  		:= {|| RefreOne(4) }

	oChk5 := TCheckBox():Create( oDlg,{|u| If(PCount()>0,lChk5:=u,lChk5) },059,005,"20 a 29 anos",100,210,,,,,,,,.T.,,,)
	oChk5:cVariable 		:= "lChk5"
	oChk5:blClicked  		:= {|| RefreOne(5) }

	oChk6 := TCheckBox():Create( oDlg,{|u| If(PCount()>0,lChk6:=u,lChk6) },068,005,"30 a 39 anos",100,210,,,,,,,,.T.,,,)
	oChk6:cVariable 		:= "lChk6"
	oChk6:blClicked  		:= {|| RefreOne(6) }

	oChk7 := TCheckBox():Create( oDlg,{|u| If(PCount()>0,lChk7:=u,lChk7) },077,005,"40 a 49 anos",100,210,,,,,,,,.T.,,,)
	oChk7:cVariable 		:= "lChk7"
	oChk7:blClicked  		:= {|| RefreOne(7) }

	oChk8 := TCheckBox():Create( oDlg,{|u| If(PCount()>0,lChk8:=u,lChk8) },086,005,"50 a 59 anos",100,210,,,,,,,,.T.,,,)
	oChk8:cVariable 		:= "lChk8"
	oChk8:blClicked  		:= {|| RefreOne(8) }

	oChk9 := TCheckBox():Create( oDlg,{|u| If(PCount()>0,lChk9:=u,lChk9) },095,005,"60 anos ou mais",100,210,,,,,,,,.T.,,,)
	oChk9:cVariable 		:= "lChk9"
	oChk9:blClicked  		:= {|| RefreOne(9) }


	@  106,005 	Say "3. Quanto tempo você trabalha na Steck:" PIXEL of oDlg  FONT oFontB COLOR CLR_RED

	oChk10 := TCheckBox():Create( oDlg,{|u| If(PCount()>0,lChk10:=u,lChk10) },117,005,"Menos de 1 ano" ,100,210,,,,,,,,.T.,,,)
	oChk10:cVariable 		:= "oChk10"
	oChk10:blClicked  		:= {|| RefreOne(10) }

	oChk11 := TCheckBox():Create( oDlg,{|u| If(PCount()>0,lChk11:=u,lChk11) },126,005,"1 a 5 anos",100,210,,,,,,,,.T.,,,)
	oChk11:cVariable 		:= "lChk11"
	oChk11:blClicked  		:= {|| RefreOne(11) }

	oChk12 := TCheckBox():Create( oDlg,{|u| If(PCount()>0,lChk12:=u,lChk12) },135,005,"6 a 10 anos",100,210,,,,,,,,.T.,,,)
	oChk12:cVariable 		:= "lChk12"
	oChk12:blClicked  		:= {|| RefreOne(12) }

	oChk13 := TCheckBox():Create( oDlg,{|u| If(PCount()>0,lChk13:=u,lChk13) },144,005,"11 a 15 anos",100,210,,,,,,,,.T.,,,)
	oChk13:cVariable 		:= "lChk13"
	oChk13:blClicked  		:= {|| RefreOne(13) }

	oChk14 := TCheckBox():Create( oDlg,{|u| If(PCount()>0,lChk14:=u,lChk14) },153,005,"16 a 20 anos",100,210,,,,,,,,.T.,,,)
	oChk14:cVariable 		:= "lChk14"
	oChk14:blClicked  		:= {|| RefreOne(14) }

	oChk15 := TCheckBox():Create( oDlg,{|u| If(PCount()>0,lChk15:=u,lChk15) },162,005,"Mais de 20 anos",100,210,,,,,,,,.T.,,,)
	oChk15:cVariable 		:= "lChk15"
	oChk15:blClicked  		:= {|| RefreOne(15) }
	//------------------------------------------------------------------------------------------------------------------------*/

	/*
	//solicitação ariadne 02/06/2016
	@  173,005 	Say "6. Caso a sua nota seja menor que 7,   " PIXEL of oDlg  FONT oFontB COLOR CLR_RED
	@  180,005 	Say "por favor, nos informe quais área     "  PIXEL of oDlg  FONT oFontB COLOR CLR_RED
	@  187,005 	Say "nós devemos melhorar                  " PIXEL of oDlg  FONT oFontB COLOR CLR_RED
	//@  194,005 	Say "as áreas que devemos melhorar." PIXEL of oDlg  FONT oFontB COLOR CLR_RED

	oChk16 := TCheckBox():Create( oDlg,{|u| If(PCount()>0,lChk16:=u,lChk16) },288,005,"Crescimento da Carreira" ,100,210,,,,,,,,.T.,,,)
	oChk16:cVariable 		:= "oChk16"
	//oChk16:blClicked  		:= {|| RefreOne(16) }

	oChk17 := TCheckBox():Create( oDlg,{|u| If(PCount()>0,lChk17:=u,lChk17) },207,005,"Comunicações" ,100,210,,,,,,,,.T.,,,)
	oChk17:cVariable 		:= "oChk17"
	//oChk17:blClicked  		:= {|| RefreOne(17) }

	oChk18 := TCheckBox():Create( oDlg,{|u| If(PCount()>0,lChk18:=u,lChk18) },216,005,"Valores da Empresa" ,100,210,,,,,,,,.T.,,,)
	oChk18:cVariable 		:= "oChk18"
	//oChk18:blClicked  		:= {|| RefreOne(18) }

	oChk19 := TCheckBox():Create( oDlg,{|u| If(PCount()>0,lChk19:=u,lChk19) },225,005,"Liderança" ,100,210,,,,,,,,.T.,,,)
	oChk19:cVariable 		:= "oChk19"
	//oChk19:blClicked  		:= {|| RefreOne(19) }

	oChk20 := TCheckBox():Create( oDlg,{|u| If(PCount()>0,lChk20:=u,lChk20) },234,005,"Meu Trabalho" ,100,210,,,,,,,,.T.,,,)
	oChk20:cVariable 		:= "oChk20"
	//oChk20:blClicked  		:= {|| RefreOne(20) }

	oChk21 := TCheckBox():Create( oDlg,{|u| If(PCount()>0,lChk21:=u,lChk21) },243,005,"Processos/Políticas/Procedimentos" ,100,210,,,,,,,,.T.,,,)
	oChk21:cVariable 		:= "oChk21"
	//oChk21:blClicked  		:= {|| RefreOne(21) }

	oChk22 := TCheckBox():Create( oDlg,{|u| If(PCount()>0,lChk22:=u,lChk22) },252,005,"Segurança" ,100,210,,,,,,,,.T.,,,)
	oChk22:cVariable 		:= "oChk22"
	//oChk22:blClicked  		:= {|| RefreOne(22) }

	oChk23 := TCheckBox():Create( oDlg,{|u| If(PCount()>0,lChk23:=u,lChk23) },261,005,"Pessoal" ,100,210,,,,,,,,.T.,,,)
	oChk23:cVariable 		:= "oChk23"
	//oChk23:blClicked  		:= {|| RefreOne(23) }

	oChk24 := TCheckBox():Create( oDlg,{|u| If(PCount()>0,lChk24:=u,lChk24) },270,005,"Estratégia" ,100,210,,,,,,,,.T.,,,)
	oChk24:cVariable 		:= "oChk24"
	//oChk24:blClicked  		:= {|| RefreOne(24) }

	oChk25 := TCheckBox():Create( oDlg,{|u| If(PCount()>0,lChk25:=u,lChk25) },279,005,"Equilíbrio entre Trabalho/Vida Pessoal" ,100,210,,,,,,,,.T.,,,)
	oChk25:cVariable 		:= "oChk25"
	//oChk25:blClicked  		:= {|| RefreOne(25) }
	*/

	//solicitação ariadne 02/06/2016
	//@ 207,005 	Say "Especifique " PIXEL of oDlg  FONT oFontn
	//@ 217,005 MSGET oDesc 	Var cDesc when .f.	SIZE 150, 09 OF oDlg PIXEL

	@  035,005 	Say "1. Por favor, indique seu sexo:" PIXEL of oDlg  FONT oFontB COLOR CLR_RED

	oChk2 := TCheckBox():Create( oDlg,{|u| If(PCount()>0,lChk2:=u,lChk2) },045,005,"Feminino",100,210,,,,,,,,.T.,,,)
	oChk2:cVariable 		:= "lChk2"
	oChk2:blClicked  		:= {|| RefreOne(2) }

	oChk3 := TCheckBox():Create( oDlg,{|u| If(PCount()>0,lChk3:=u,lChk3) },055,005,"Masculino",100,210,,,,,,,,.T.,,,)
	oChk3:cVariable 		:= "lChk3"
	oChk3:blClicked  		:= {|| RefreOne(3) }

	_nlin := 70
	@ _nlin,005 	Say "2. Por favor, indique até que ponto você concorda com cada uma das seguintes declarações " PIXEL of oDlg  FONT oFontB COLOR CLR_RED
	_nlin+= _nlin7
	@ _nlin,005 	Say "   sobre o que significa pra você trabalhar na Steck." PIXEL of oDlg  FONT oFontB COLOR CLR_RED
	_nlin+= _nlin7 + _nlin12

	@ _nlin,005 	Say "3. Meu superior imediato fornece feedback que ajuda a melhorar o meu desempenho." PIXEL of oDlg  FONT oFontN		//"Meu gerente fornece feedback que me ajuda a melhorar meu desempenho."
	_nlin+= _nlin7
	@ _nlin,005  ComboBox oStat01 VAR cStat01 ITEMS {' ','1-Concordo Totalmente','2-Concordo','3-Concordo Parcialmente','4-Discordo','5-Discordo Totalmente'} Of oDlg PIXEL SIZE 85,10
	_nlin+= _nlin12

	@ _nlin,005 	Say "4. As ferramentas e os recursos fornecidos permitem que eu seja o mais produtivo possível." PIXEL of oDlg  FONT oFontN
	_nlin+= _nlin7
	@ _nlin,005  ComboBox oStat02 VAR cStat02 ITEMS {' ','1-Concordo Totalmente','2-Concordo','3-Concordo Parcialmente','4-Discordo','5-Discordo Totalmente'} Of oDlg PIXEL SIZE 85,10
	_nlin+= _nlin12

	@ _nlin,005 	Say "5. Eu acho que a colaboração entre as equipes e as entidades está indo bem." PIXEL of oDlg  FONT oFontN
	_nlin+= _nlin7
	@ _nlin,005  ComboBox oStat03 VAR cStat03 ITEMS {' ','1-Concordo Totalmente','2-Concordo','3-Concordo Parcialmente','4-Discordo','5-Discordo Totalmente'} Of oDlg PIXEL SIZE 85,10
	_nlin+= _nlin12

	//@ _nlin,005 	Say "As oportunidades de desenvolvimento e aprendizado me ajudam a construir habilidades valiosas." PIXEL of oDlg  FONT oFontN
	@ _nlin,005 	Say "6. Eu posso aprender e crescer pessoalmente e profissionalmente na Steck." PIXEL of oDlg  FONT oFontN
	_nlin+= _nlin7
	@ _nlin,005  ComboBox oStat04 VAR cStat04 ITEMS {' ','1-Concordo Totalmente','2-Concordo','3-Concordo Parcialmente','4-Discordo','5-Discordo Totalmente'} Of oDlg PIXEL SIZE 85,10
	_nlin+= _nlin12

	//@ _nlin,005 	Say "Eu sinto que esta organização valoriza a diversidade (por exemplo, idade, sexo, etnia, língua, educação, ideias e perspectivas)." PIXEL of oDlg  FONT oFontN
	@ _nlin,005 	Say "7. Nós temos um ambiente de trabalho que é aberto e aceita as diferenças individuais." PIXEL of oDlg  FONT oFontN
	_nlin+= _nlin7
	@ _nlin,005  ComboBox oStat05 VAR cStat05 ITEMS {' ','1-Concordo Totalmente','2-Concordo','3-Concordo Parcialmente','4-Discordo','5-Discordo Totalmente'} Of oDlg PIXEL SIZE 85,10
	_nlin+= _nlin12

	@ _nlin,005 	Say "8. Minha organização cuida ativamente do bem-estar de seus funcionários." PIXEL of oDlg  FONT oFontN
	_nlin+= _nlin7
	@ _nlin,005  ComboBox oStat06 VAR cStat06 ITEMS {' ','1-Concordo Totalmente','2-Concordo','3-Concordo Parcialmente','4-Discordo','5-Discordo Totalmente'} Of oDlg PIXEL SIZE 85,10
	_nlin+= _nlin12

	@ _nlin,005 	Say "9. Eu não hesitaria em recomendar a Steck para um amigo a procura de emprego." PIXEL of oDlg  FONT oFontN
	_nlin+= _nlin7
	@ _nlin,005  ComboBox oStat07 VAR cStat07 ITEMS {' ','1-Concordo Totalmente','2-Concordo','3-Concordo Parcialmente','4-Discordo','5-Discordo Totalmente'} Of oDlg PIXEL SIZE 85,10
	_nlin+= _nlin12

	@ _nlin,005 	Say "10. Quando tenho oportunidade, conto aos outros coisas boas sobre como é trabalhar aqui." PIXEL of oDlg  FONT oFontN
	_nlin+= _nlin7
	@ _nlin,005  ComboBox oStat08 VAR cStat08 ITEMS {' ','1-Concordo Totalmente','2-Concordo','3-Concordo Parcialmente','4-Discordo','5-Discordo Totalmente'} Of oDlg PIXEL SIZE 85,10
	_nlin+= _nlin12

	@ _nlin,005 	Say "11. Eu raramente penso em deixar a Steck para trabalhar em outro lugar." PIXEL of oDlg  FONT oFontN
	_nlin+= _nlin7
	@ _nlin,005  ComboBox oStat09 VAR cStat09 ITEMS {' ','1-Concordo Totalmente','2-Concordo','3-Concordo Parcialmente','4-Discordo','5-Discordo Totalmente'} Of oDlg PIXEL SIZE 85,10
	_nlin+= _nlin12

	@ _nlin,005 	Say "12. Seria preciso muito para me convencer a deixar a Steck." PIXEL of oDlg  FONT oFontN
	_nlin+= _nlin7
	@ _nlin,005  ComboBox oStat10 VAR cStat10 ITEMS {' ','1-Concordo Totalmente','2-Concordo','3-Concordo Parcialmente','4-Discordo','5-Discordo Totalmente'} Of oDlg PIXEL SIZE 85,10
	_nlin+= _nlin12

	@ _nlin,005 	Say "13. A Steck me motiva a contribuir mais do que normalmente é necessário para concluir o meu trabalho." PIXEL of oDlg  FONT oFontN
	_nlin+= _nlin7
	@ _nlin,005  ComboBox oStat11 VAR cStat11 ITEMS {' ','1-Concordo Totalmente','2-Concordo','3-Concordo Parcialmente','4-Discordo','5-Discordo Totalmente'} Of oDlg PIXEL SIZE 85,10
	_nlin+= _nlin12

	@ _nlin,005 	Say "14. A Steck me inspira a fazer o meu melhor trabalho todos os dias." PIXEL of oDlg  FONT oFontN
	_nlin+= _nlin7
	@ _nlin,005  ComboBox oStat12 VAR cStat12 ITEMS {' ','1-Concordo Totalmente','2-Concordo','3-Concordo Parcialmente','4-Discordo','5-Discordo Totalmente'} Of oDlg PIXEL SIZE 85,10
	_nlin+= _nlin12

	@ _nlin,005 	Say "15. Na Steck, estamos sempre em busca de melhores formas de atender aos nossos clientes." PIXEL of oDlg  FONT oFontN
	_nlin+= _nlin7
	@ _nlin,005  ComboBox oStat13 VAR cStat13 ITEMS {' ','1-Concordo Totalmente','2-Concordo','3-Concordo Parcialmente','4-Discordo','5-Discordo Totalmente'} Of oDlg PIXEL SIZE 85,10
	_nlin+= _nlin12

	@ _nlin,005 	Say "16. Recebo reconhecimento adequado (além do meu salário e benefícios) pelas minhas contribuições e realizações." PIXEL of oDlg  FONT oFontN
	_nlin+= _nlin7
	@ _nlin,005  ComboBox oStat14 VAR cStat14 ITEMS {' ','1-Concordo Totalmente','2-Concordo','3-Concordo Parcialmente','4-Discordo','5-Discordo Totalmente'} Of oDlg PIXEL SIZE 85,10
	_nlin+= _nlin12

	@ _nlin,005 	Say "17. Você está ciente que planos de ação são definidos em sua organização após a aplicação da pesquisa OneVoice?" PIXEL of oDlg  FONT oFontN
	_nlin+= _nlin7
	@ _nlin,005  ComboBox oStat15 VAR cStat15 ITEMS {' ','S-Sim','N-Não'} Of oDlg PIXEL SIZE 85,10
	_nlin+= _nlin12

	@ _nlin,005 	Say "18. Os planos de ação da pesquisa OneVoice tiveram um impacto positivo em meu engajamento?" PIXEL of oDlg  FONT oFontN
	_nlin+= _nlin7
	@ _nlin,005  ComboBox oStat16 VAR cStat16 ITEMS {' ','S-Sim','N-Não'} Of oDlg PIXEL SIZE 85,10

	_nlin+= _nlin7
	@ 001,001  To _nlin+3,560   PIXEL of oDlg
	_nlin+= _nlin7

	/*
	//solicitação ariadne 02/06/2016
	@ _nlin,005 	Say '5. Você recomendaria aos seus amigos a Steck como um bom lugar para trabalhar? ' PIXEL of oDlg  FONT oFontB  COLOR CLR_RED
	_nlin+= _nlin7
	@ _nlin,005 	Say 'Numa escala de 0 a 10, onde 0 significa "Muito Dificilmente" e 10 significa  "Muito Provavelmente".' PIXEL of oDlg  FONT oFontN
	_nlin+= _nlin12
	@ _nlin,005  ComboBox oStat17 VAR cStat17 ITEMS {' ','0','1','2','3','4','5','6','7','8','9','10'} Of oDlg PIXEL SIZE 85,10
	*/

	//	@ 001,168  To _nlin+13,600   PIXEL of oDlg
	//	@ 001,001  To _nlin+13,167   PIXEL of oDlg
	//	_nlin+= _nlin12

	//DEFINE SBUTTON oBtnOk     FROM _nlin,246 TYPE 1 ACTION Eval(bOk) ENABLE OF oDlg
	//DEFINE SBUTTON oBtnCancel FROM _nlin,278 TYPE 2 ACTION Eval(bCancel) ENABLE OF oDlg

	ACTIVATE MSDIALOG oDlg //ON INIT EnchoiceBar(oDlg,{|| nOpca := 1,oDlg:End() },{||oDlg:End()},,)

	// se a opcao for encerrar executa a rotina.
	If nOpca == 1

		If __CUSERID $ GetMv("ST_ONEVOI",,'000000')+'000000'
			Processa( {|| STGRVMIX() }, "Aguarde...", "Gravando Pesquisa...",.F.)
			MsgInfo("Obrigado Pela Sua Participação....!!!!!")
		Else

			Dbselectarea("PPC")
			PPC->(DbSetorder(3))
			If  PPC->(DbSeek(xFilial('PPC')+Strzero(Year(dDataBase),4)+__CUSERID))		//"2016"
				MsgInfo("Obrigado Pela Sua Participação....!!!!!")
			Else
				Processa( {|| STGRVMIX() }, "Aguarde...", "Gravando Pesquisa...",.F.)
				MsgInfo("Obrigado Pela Sua Participação....!!!!!")
			EndIf

		EndIf
	EndIf

Return


Static Function RefreOne(nOpcx,cCod)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Realiza o controle dos flags³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	Do Case

		Case nOpcx == 2
		lChk2 	:= .T.
		lChk3 	:= .F.
		Case nOpcx == 3
		lChk2 	:= .F.
		lChk3 	:= .T.
		Case nOpcx == 4
		lChk4 	:= .T.
		lChk5 	:= .F.
		lChk6	:= .F.
		lChk7	:= .F.
		lChk8	:= .F.
		lChk9	:= .F.
		Case nOpcx == 5
		lChk4 	:= .F.
		lChk5 	:= .T.
		lChk6	:= .F.
		lChk7	:= .F.
		lChk8	:= .F.
		lChk9	:= .F.
		Case nOpcx == 6
		lChk4 	:= .F.
		lChk5 	:= .F.
		lChk6	:= .T.
		lChk7	:= .F.
		lChk8	:= .F.
		lChk9	:= .F.
		Case nOpcx == 7
		lChk4 	:= .F.
		lChk5 	:= .F.
		lChk6	:= .F.
		lChk7	:= .T.
		lChk8	:= .F.
		lChk9	:= .F.
		Case nOpcx == 8
		lChk4 	:= .F.
		lChk5 	:= .F.
		lChk6	:= .F.
		lChk7	:= .F.
		lChk8	:= .T.
		lChk9	:= .F.
		Case nOpcx == 9
		lChk4 	:= .F.
		lChk5 	:= .F.
		lChk6	:= .F.
		lChk7	:= .F.
		lChk8	:= .F.
		lChk9	:= .T.
		Case nOpcx == 10
		lChk10 	:= .T.
		lChk11	:= .F.
		lChk12	:= .F.
		lChk13	:= .F.
		lChk14	:= .F.
		lChk15	:= .F.
		Case nOpcx == 11
		lChk10 	:= .F.
		lChk11	:= .T.
		lChk12	:= .F.
		lChk13	:= .F.
		lChk14	:= .F.
		lChk15	:= .F.
		Case nOpcx == 12
		lChk10 	:= .F.
		lChk11	:= .F.
		lChk12	:= .T.
		lChk13	:= .F.
		lChk14	:= .F.
		lChk15	:= .F.
		Case nOpcx == 13
		lChk10 	:= .F.
		lChk11	:= .F.
		lChk12	:= .F.
		lChk13	:= .T.
		lChk14	:= .F.
		lChk15	:= .F.
		Case nOpcx == 14
		lChk10 	:= .F.
		lChk11	:= .F.
		lChk12	:= .F.
		lChk13	:= .F.
		lChk14	:= .T.
		lChk15	:= .F.
		Case nOpcx == 15
		lChk10 	:= .F.
		lChk11	:= .F.
		lChk12	:= .F.
		lChk13	:= .F.
		lChk14	:= .F.
		lChk15	:= .T.
		Case nOpcx == 16
		lChk16 	:= !lChk16
		lChk17 	:= lChk17
		lChk18	:= lChk18
		lChk19	:= lChk19
		lChk20	:= lChk20
		lChk21	:= lChk21
		lChk22	:= lChk22
		lChk23	:= lChk23
		lChk24	:= lChk24
		lChk25	:= lChk25
		Case nOpcx == 17
		lChk16 	:= lChk16
		lChk17 	:= !lChk17
		lChk18	:= lChk18
		lChk19	:= lChk19
		lChk20	:= lChk20
		lChk21	:= lChk21
		lChk22	:= lChk22
		lChk23	:= lChk23
		lChk24	:= lChk24
		lChk25	:= lChk25
		Case nOpcx == 18
		lChk16 	:= lChk16
		lChk17 	:= lChk17
		lChk18	:= !lChk18
		lChk19	:= lChk19
		lChk20	:= lChk20
		lChk21	:= lChk21
		lChk22	:= lChk22
		lChk23	:= lChk23
		lChk24	:= lChk24
		lChk25	:= lChk25
		Case nOpcx == 19
		lChk16 	:= lChk16
		lChk17 	:= lChk17
		lChk18	:= lChk18
		lChk19	:= !lChk19
		lChk20	:= lChk20
		lChk21	:= lChk21
		lChk22	:= lChk22
		lChk23	:= lChk23
		lChk24	:= lChk24
		lChk25	:= lChk25
		Case nOpcx == 20
		lChk16 	:= lChk16
		lChk17 	:= lChk17
		lChk18	:= lChk18
		lChk19	:= lChk19
		lChk20	:= !lChk20
		lChk21	:= lChk21
		lChk22	:= lChk22
		lChk23	:= lChk23
		lChk24	:= lChk24
		lChk25	:= lChk25
		Case nOpcx == 21
		lChk16 	:= lChk16
		lChk17 	:= lChk17
		lChk18	:= lChk18
		lChk19	:= lChk19
		lChk20	:= lChk20
		lChk21	:= !lChk21
		lChk22	:= lChk22
		lChk23	:= lChk23
		lChk24	:= lChk24
		lChk25	:= lChk25
		Case nOpcx == 22
		lChk16 	:= lChk16
		lChk17 	:= lChk17
		lChk18	:= lChk18
		lChk19	:= lChk19
		lChk20	:= lChk20
		lChk21	:= lChk21
		lChk22	:= !lChk22
		lChk23	:= lChk23
		lChk24	:= lChk24
		lChk25	:= lChk25
		Case nOpcx == 23
		lChk16 	:= lChk16
		lChk17 	:= lChk17
		lChk18	:= lChk18
		lChk19	:= lChk19
		lChk20	:= lChk20
		lChk21	:= lChk21
		lChk22	:= lChk22
		lChk23	:= !lChk23
		lChk24	:= lChk24
		lChk25	:= lChk25
		Case nOpcx == 24
		lChk16 	:= lChk16
		lChk17 	:= lChk17
		lChk18	:= lChk18
		lChk19	:= lChk19
		lChk20	:= lChk20
		lChk21	:= lChk21
		lChk22	:= lChk22
		lChk23	:= lChk23
		lChk24	:= !lChk24
		lChk25	:= lChk25
		Case nOpcx == 25
		lChk16 	:= lChk16
		lChk17 	:= lChk17
		lChk18	:= lChk18
		lChk19	:= lChk19
		lChk20	:= lChk20
		lChk21	:= lChk21
		lChk22	:= lChk22
		lChk23	:= lChk23
		lChk24	:= lChk24
		lChk25	:= !lChk25
	End Case

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Atualiza os objetos graficos³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	oDlg  :Refresh()

Return .T.


Static Function STGRVMIX()

	Dbselectarea("PPC")

	PPC->(RecLock("PPC",.T.))
	PPC->PPC_EMP	:= cEmpAnt
	PPC->PPC_ANO	:= Strzero(Year(dDataBase),4)				//'2017'
	PPC->PPC_01 	:= IIf(lChk2,'F','M')
	//	PPC->PPC_02 	:= IIF(lChk4,'1',IIF(lChk5,'2',IIF(lChk6,'3',IIF(lChk7,'4',IIF(lChk8,'5',IIF(lChk9,'6','0') ) ) ) ) )
	//	PPC->PPC_03 	:= IIF(lChk10,'1',IIF(lChk11,'2',IIF(lChk12,'3',IIF(lChk13,'4',IIF(lChk14,'5',IIF(lChk15,'6','0') ) ) ) ) )
	PPC->PPC_04 	:=  cStat01
	PPC->PPC_05 	:=  cStat02
	PPC->PPC_06 	:=  cStat03
	PPC->PPC_07 	:=  cStat04
	PPC->PPC_08 	:=  cStat05
	PPC->PPC_09 	:=  cStat06
	PPC->PPC_10 	:=  cStat07
	PPC->PPC_11 	:=  cStat08
	PPC->PPC_12 	:=  cStat09
	PPC->PPC_13 	:=  cStat10
	PPC->PPC_14 	:=  cStat11
	PPC->PPC_15 	:=  cStat12
	//	PPC->PPC_16 	:=  Iif(Empty(cStat17),8,VAL(cStat17))
	//	PPC->PPC_17 	:=  IIF(lChk16,'1/',' ')+IIF(lChk17,'2/',' ')+IIF(lChk18,'3/',' ')+IIF(lChk19,'4/',' ')+IIF(lChk20,'5/',' ')+IIF(lChk21,'6/',' ')+IIF(lChk22,'7/',' ')+IIF(lChk23,'8/',' ')+IIF(lChk24,'9/',' ')+IIF(lChk25,'10/',' ')
	//	PPC->PPC_18 	:=  cDesc
	PPC->PPC_19 	:=  _cRar
	PPC->PPC_20 	:=  cStat13
	PPC->PPC_21 	:=  cStat14
	PPC->PPC_22 	:=  cStat15
	PPC->PPC_23 	:=  cStat16
	PPC->PPC_REG 	:= __CUSERID
	PPC->(MsUnlock())
	PPC->( DbCommit() )

	Return()

	*---------------------------------------------------*
Static Function STFINATOT()
	*---------------------------------------------------*

	Local oDlgEmail
	//Local _nVal       :=  0
	Local lSaida      	:= .F.
	Local lRev     		:= .F.
	Local nOpca       	:=  0
	Local obox

	//--- Anterior
	//Local _aComb      	:= {' ',;
	//	'Copa/Limpeza/Portaria/Recepção',;
	//	'Engenharias/Qualidade',;
	//	'Fábrica – Manaus',;
	//	'Fábrica - São Paulo',;
	//	'Financeiro/Exportação',;
	//	'Logística/Compras/Comex/Expedição',;
	//	'Vendas/Marketing',;
	//	'RH/SESMT/TI'}

	Local _aComb      	:= {' ',;
	'Financeiro/Contabilidade',;
	'Recursos Humanos/SESMT',;
	'Portaria/Recepção/Limpeza',;
	'Marketing',;
	'Fábrica - Manaus',;
	'Fábrica - São Paulo',;
	'Exportação',;
	'TI',;
	'Vendas',;
	'Expedição/Transporte/Logística/Comex/Compras',;
	'Engenharia/Qualidade/PCP'}

	Do While !lSaida
		nOpcao := 0
		DEFINE MSDIALOG oDlgEmail TITLE OemToAnsi("Escolha um Departamento") From  1,0 To 80,350 Pixel OF oMainWnd

		@ 02,04 SAY "Departamento: " PIXEL OF oDlgEmail
		@ 12,04 ComboBox obox VAR _cRar  ITEMS  _aComb Of oDlgEmail PIXEL SIZE 110,10
		@ 11,125 Button "Ok"      Size 28,13 Action iif(!(Empty(Alltrim(_cRar))),Eval({||lSaida:=.T.,nOpca:=1,oDlgEmail:End()}),msginfo("Escolha seu Departamento"))  Pixel

		ACTIVATE MSDIALOG oDlgEmail CENTERED
	EndDo
	If !(Empty(Alltrim(_cRar)))
		lRev := .t.
	EndIf

Return(lRev)

Static Function VldInfos()

Return(.F.)