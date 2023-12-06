#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "AP5MAIL.CH"
#Include "TOPCONN.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ RSTFATAE     บAutor  ณJoao Rinaldi    บ Data ณ  03/03/2016 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo desenvolvida para realizar a impressใo grแfica das  บฑฑ
ฑฑบ          ณ Cota็ใo de Compra Steck                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Steck Industria Eletrica Ltda.                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบChamado   ณ 002103 - Layout Cota็ใo de Compra                          บฑฑ
ฑฑบSolic.    ณ Juliana Queiroz - Depto. Compras                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RSTFATAE(_aCotacao,cCompST,_cFilial)
	
	Local aArea   := GetArea()
	Local aArea1  := SC1->(GetArea())
	Local aArea2  := SA2->(GetArea())
	Local aArea3  := SE4->(GetArea())
	Local aArea4  := SY1->(GetArea())
	Local aArea5  := SM0->(GetArea())
	//Local   n     := 0
	
	Private cPerg 		:= "Cota็ใo de Compra "
	Private cTime        := Time()
	Private cHora        := SUBSTR(cTime, 1, 2)
	Private cMinutos    	:= SUBSTR(cTime, 4, 2)
	Private cSegundos   	:= SUBSTR(cTime, 7, 2)
	Private cAliasLif   	:= cPerg+cHora+cMinutos+cSegundos
	Private cAlias1      := cAliasLif
	
	Private oPrint
	
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	//ณ Variแveis para envio de E-Mail
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	Private cPara         := ""
	Private cCopia        := ""
	Private cCo           := Space(200)
	Private ctitulo       := "Envio de E-Mail - "
	Private cBmpName  	 := ''
	Private cStartPath 	 := '\arquivos\cotacao_compra\'//GetSrvProfString("Startpath","") +'orcamento\'
	Private _cPath		 := GetSrvProfString("RootPath","") //GetPvProfString( GetEnvServer(), "RootPath"	, "", GetAdv97() )
	Private _cNomePdf     :=''
	Private _lRet         := .T.
	Private _cDirRel      := Getmv("MV_RELT",,'C:\ARQUIVOS_PROTHEUS\')
	Private _lxRet        := .T.
	Private _aAttach      := {}
	Private _cCaminho     := cStartPath
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Variแveis do arquivo de empresas sigamat.emp
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	Private _cNomeCom    := ''//SM0->M0_NOMECOM
	Private _cEndereco   := ''//SM0->M0_ENDENT
	Private _cCep        := ''//SM0->M0_CEPENT
	Private _cCidade     := ''//SM0->M0_CIDENT
	Private _cEstado     := ''//SM0->M0_ESTENT
	Private _cBairro     := ''//SM0->M0_BAIRENT
	Private _cCNPJ       := ''//SM0->M0_CGC
	Private _cTelefone   := ''//SM0->M0_TEL
	Private _cFax        := ''//SM0->M0_FAX
	Private _cIe         := ''//SM0->M0_INSC
	Private _cCGC        := ''//SM0->M0_CGC
	Private cCident      := ''
	Private cCidcob      := ''
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Variแveis da Cota็ใo de Compra
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	Private cNumCot       := cAlias1
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Variแveis do Cadastro de Comprador
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	Private cComprador     := ''
	Private cTelComprador  := ''
	Private cFaxComprador  := ''
	Private cMailComprador := ''
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Cria็ใo das pastas para salvar os anexos
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If MakeDir (cStartPath) == 0
		MakeDir(cStartPath)
	Endif
	
	DbSelectArea("SY1")
	SY1->(DbGoTop())
	SY1->(DbSetOrder(1))
	If SY1->(DbSeek(xFilial("SY1")+ cCompST))
		cComprador     := SY1->Y1_NOME
		cTelComprador  := SY1->Y1_TEL
		cFaxComprador  := SY1->Y1_FAX
		cMailComprador := SY1->Y1_EMAIL
	Endif
	
	SM0->(dbSetOrder(1))
	nRecnoSM0 := SM0->(Recno())
	If SM0->(dbSeek(SUBS(cNumEmp,1,2)+_cFilial))
	 _cNomeCom    := SM0->M0_NOMECOM
	 _cEndereco   := SM0->M0_ENDENT
	 _cCep        := SM0->M0_CEPENT
	 _cCidade     := SM0->M0_CIDENT
	 _cEstado     := SM0->M0_ESTENT
	 _cBairro     := SM0->M0_BAIRENT
	 _cCNPJ       := SM0->M0_CGC
	 _cTelefone   := SM0->M0_TEL
	 _cFax        := SM0->M0_FAX
	 _cIe         := SM0->M0_INSC
	 _cCGC        := SM0->M0_CGC		
		
		//cCident := (Capital(Alltrim(SM0->M0_ENDENT))+"  "+Capital(Alltrim(SM0->M0_CIDENT))+"  - "+Alltrim(SM0->M0_ESTENT)+" - Cep: " + SUBSTR(SM0->M0_CEPENT,1,5)+"-"+SUBSTR(SM0->M0_CEPENT,6,3) )
		//cCidcob := (Capital(Alltrim(SM0->M0_ENDCOB))+"  "+Capital(Alltrim(SM0->M0_CIDCOB))+"  - "+Alltrim(SM0->M0_ESTCOB)+" - Cep: " + SUBSTR(SM0->M0_CEPCOB,1,5)+"-"+SUBSTR(SM0->M0_CEPCOB,6,3) )
	Endif

	ctitulo := ctitulo + cNumCot + " - " + _cNomeCom
	
	//Processa({|lEnd|GeraRel(_aCotacao,cCompST)})
	GeraRel(_aCotacao,cCompST)
	
	RestArea(aArea5)
	RestArea(aArea4)
	RestArea(aArea3)
	RestArea(aArea2)
	RestArea(aArea1)
	RestArea(aArea)
	
Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ GeraRel      บAutor  ณJoao Rinaldi    บ Data ณ  03/03/2016 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo que realiza a gera็ใo do Relat๓rio                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Steck Industria Eletrica Ltda.                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบChamado   ณ 002103 - Layout Pedido de Compras                          บฑฑ
ฑฑบSolic.    ณ Juliana Queiroz - Depto. Compras                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GeraRel(_aCotacao,cCompST)
	
	Local _nK
	
	If !(_lRet)
		Aviso("Cota็ใo de Compras"; //01 - cTitulo - Tํtulo da janela
		,"Cota็ใo de Compras nใo Encontrada."+ Chr(10) + Chr(13) +;
			CHR(10)+CHR(13)+;
			"Favor Verificar.",; //02 - cMsg - Texto a ser apresentado na janela.
		{"OK"};                          //03 - aBotoes - Array com as op็๕es dos bot๕es.
		,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
		,;                               //05 - cText - Titulo da Descri็ใo (Dentro da Janela)
		,;                               //06 - nRotAutDefault - Op็ใo padrใo usada pela rotina automแtica
		,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
		,.F.;                            //08 - lEdit - Determina se permite a edi็ใo do campo memo
		,;                               //09 - nTimer - Tempo para exibi็ใo da mensagem em segundos.
		,;                               //10 - nOpcPadrao - Op็ใo padrใo apresentada na mensagem.
		)
	Else
		_cNomePdf := cEmpAnt+" - "+cNumCot
		oPrint    := fwmsprinter():New( _cNomePdf , 6      ,.F.             , cStartPath  ,.T.			,  ,  ,  ,  .f.,  ,.f.,.f. )
		oPrint    :SetLandScape()     //SetPortrait() ou SetLandscape()
		oPrint    :SetMargin(60,60,60,60)
		oPrint    :setPaperSize(9)
		
		//Processa({||ImpItens(_aCotacao,cCompST)})
		Processa( {||ImpItens(_aCotacao,cCompST) }, "Aguarde.", ,.F.)
		//ImpItens(_aCotacao,cCompST)
		
		// Indique o caminho onde serแ gravado o PDF
		FERASE(cStartPath+_cNomePdf+".pdf")
		oPrint:cPathPDF := cStartPath
		oPrint:Print()
		
		If ExistDir(_cDirRel)
			_lxRet := .T.
		Else
			If MakeDir(_cDirRel) == 0
				MakeDir(_cDirRel)
				Aviso("Cria็ใo de Pasta","Fora criado nesse computador uma pasta para que as Cota็๕es de Compras emitidas lแ sejam salvos ap๓s a impressใo."+CHR(10)+CHR(13)+;
					CHR(10)+CHR(13)+;
					"Segue o caminho do diret๓rio criado:"+CHR(10)+CHR(13)+;
					CHR(10)+CHR(13)+;
					_cDirRel,;
					{"OK"},3)
				_lxRet := .T.
			Else
				Aviso("Erro na Cria็ใo de Pasta","Para salvar a Cota็ใo de Compra em questใo ้ necessแrio que uma pasta seja criada nesse computador."+CHR(10)+CHR(13)+;
					CHR(10)+CHR(13)+;
					"Favor entrar em contato com o TI para que a cria็ใo da pasta seja realizada.:"+CHR(10)+CHR(13)+;
					CHR(10)+CHR(13)+;
					"Nใo serแ possํvel realizar a abertura da Cota็ใo de Compra em arquivo PDF e consequentemente nใo serแ enviado via e-mail ao Fornecedor.",;
					{"OK"},3)
				_lxRet := .F.
			Endif
		Endif
		
		If _lxRet
			FERASE(_cDirRel+"\"+_cNomePdf+".pdf")
			CpyS2T(cStartPath+_cNomePdf+'.pdf',_cDirRel+"\",.T.) // COPIA ARQUIVO PARA MAQUINA DO USUมRIO
			ShellExecute("open",_cDirRel+_cNomePdf+'.pdf', "", "", 1)
			
			If MsgBox("Envia e-mail ao Fornecedor?","Envio de E-Mail","YESNO")
				
				If ChkMail() // Abre tela Para Digitar Manualmente E-Mails
					
					Processa({|lEnd| EnvMail(oPrint,"Cota็ใo de Compra: "+ cNumCot,{"Cota็ใo de Compra: "+ cNumCot},cPara,cCopia,{},10)},ctitulo)
					
				Endif
				
			Else
				aadd( _aAttach  ,_cNomePdf+'.pdf')
			Endif
			
		//	For _nK := 1 To Len(_aAttach)
		//  FERASE(cStartPath+_aAttach[_nK])//Apaga anexos do Servidor
		//	Next _nK
		Endif
		
	EndIf
	
Return nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ ImpItens     บAutor  ณJoao Rinaldi    บ Data ณ  03/03/2016 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo que realiza a impressใo dos itens e total do        บฑฑ
ฑฑบ          ณ relat๓rio                                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Steck Industria Eletrica Ltda.                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบChamado   ณ 002103 - Layout Pedido de Compras                          บฑฑ
ฑฑบSolic.    ณ Juliana Queiroz - Depto. Compras                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ImpItens(_aCotacao,cCompST)
	
	Local 	oBrush
	Local _ncount
	Local _nI
	
	Private _nLin    := 4000
	Private _nLin2   := 000
	Private _nCol    := 000
	Private _nTam    := 30
	Private nColFator:= 0.5
	Private nLinFator:= 0.25
	Private nColSpace:= 3
	Private nLinSpace:= 3
	
	aBmp := "steck-new-logo.png"
	aBmp2:= "steck-cota็ใo.png"
	
	//TFont():New( [ cName ], [ uPar2 ], [ nHeight ], [ uPar4 ], [ lBold ], [ uPar6 ], [ uPar7 ], [ uPar8 ], [ uPar9 ], [ lUnderline ], [ lItalic ] )
	oFont8  := TFont():New( "Arial"  , 0        , 8          , .T.      , .F.      , 0        , .T.      , 0        , .T.      , .F.           , .F.        )
	oFont2n := TFont():New("Times New Roman",,10,,.T.,,,,,.F. )
	oFont9  := TFont():New("Arial",9,9 ,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont10 := TFont():New("Arial",9,10,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont10n:= TFont():New("Arial",9,10,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont11 := TFont():New("Arial",9,11,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont12 := TFont():New("Arial",9,12,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont13 := TFont():New("Arial",9,13,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont13n:= TFont():New("Arial",9,13,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont14n:= TFont():New("Arial",9,14,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont15n:= TFont():New("Arial",9,15,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont16 := TFont():New("Arial",9,16,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont16n:= TFont():New("Arial",9,16,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont17 := TFont():New("Arial",9,17,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont17n:= TFont():New("Arial",9,17,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont20 := TFont():New("Arial",9,18,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont20n:= TFont():New("Arial",9,18,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont18 := TFont():New("Arial",9,18,.T.,.T.,5,.T.,5,.T.,.F.)
	
	oBrush := TBrush():New("",4)
	
	oPrint:StartPage()     // INICIALIZA a pแgina
	ImpCabec()
	
	ProcRegua(Len(_aCotacao))
	For _nI := 1 To Len(_aCotacao)
		IncProc("Imprimindo Produto: "+_aCotacao[_nI][3])
		QuebraPagina(_nLin)
		_nCol += 010
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Impressao dO N๚mero da SC
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		oPrint:Say  (_nLin,_nCol,_aCotacao[_nI][1] ,oFont8)
		_nCol += nColSpace+((oPrint:GetTextWidth( Replicate(" ",(TamSX3("C1_NUM")[1]+TamSX3("C1_NUM")[2])) , oFont8 ))*nColFator)
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Impressao do Item
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		oPrint:Say  (_nLin,_nCol,_aCotacao[_nI][2] ,oFont8)
		_nCol += nColSpace+((oPrint:GetTextWidth( Replicate(" ",(TamSX3("C1_ITEM")[1]+TamSX3("C1_ITEM")[2])) , oFont8 ))*nColFator)
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Impressao do C๓digo do Produto
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		oPrint:Say  (_nLin,_nCol,_aCotacao[_nI][3],oFont8)
		_nCol += nColSpace+((oPrint:GetTextWidth( Replicate(" ",(TamSX3("C1_PRODUTO")[1]+TamSX3("C1_PRODUTO")[2])) , oFont8 ))*nColFator)
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Impressao da Descri็ใo Produto - Campo Memo
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		_nCol2 := _nCol
		_nCol += nColSpace+((oPrint:GetTextWidth( Replicate(" ",_nTam) , oFont8 ))*nColFator)
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Impressao do C๓digo do Desenho
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		oPrint:Say  (_nLin,_nCol,_aCotacao[_nI][5],oFont8)
		_nCol += nColSpace+((oPrint:GetTextWidth( Replicate(" ",(TamSX3("B1_XDESENH")[1]+TamSX3("B1_XDESENH")[2])) , oFont8 ))*nColFator)
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Impressao do 1บ Unidade de Medida
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		oPrint:Say  (_nLin,_nCol,_aCotacao[_nI][6],oFont8)
		_nCol += nColSpace+((oPrint:GetTextWidth( "UM" , oFont8 ))*nColFator)
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Impressao do 2บ Unidade de Medida
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		oPrint:Say  (_nLin,_nCol,_aCotacao[_nI][7],oFont8)
		_nCol += nColSpace+((oPrint:GetTextWidth( "2a UM" , oFont8 ))*nColFator)
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Impressao da Quantidade na 1บ Unidade de Medida
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		oPrint:Say  (_nLin,_nCol,transform(_aCotacao[_nI][8],PesqPict("SC1","C1_QUANT") ),oFont8)
		_nCol += nColSpace+((oPrint:GetTextWidth( Replicate(" ",(TamSX3("C1_QUANT")[1]+TamSX3("C1_QUANT")[2])) , oFont8 ))*nColFator	)
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Impressao da Quantidade na 2บ Unidade de Medida
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		oPrint:Say  (_nLin,_nCol,transform(_aCotacao[_nI][9],PesqPict("SC1","C1_QTSEGUM")),oFont8)
		_nCol += nColSpace+((oPrint:GetTextWidth( Replicate(" ",(TamSX3("C1_QTSEGUM")[1]+TamSX3("C1_QTSEGUM")[2])) , oFont8 ))*nColFator)
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Impressao do Pre็o Unitแrio
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		oPrint:Say  (_nLin,_nCol,Replicate(_aCotacao[_nI][10],(TamSX3("C1_PRECO")[1]+TamSX3("C1_PRECO")[2])),oFont8)
		_nCol += 2+((oPrint:GetTextWidth( Replicate(" ",(TamSX3("C1_PRECO")[1]+TamSX3("C1_PRECO")[2])) , oFont8 ))*nColFator)
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Impressao da Alํqutota IPI
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		oPrint:Say  (_nLin,_nCol,Replicate(_aCotacao[_nI][11],(TamSX3("C7_IPI")[1]+TamSX3("C7_IPI")[2])),oFont8)
		_nCol += nColSpace+((oPrint:GetTextWidth( Replicate(" ",(TamSX3("C7_IPI")[1]+TamSX3("C7_IPI")[2])) , oFont8 ))*nColFator)
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Impressao da Data de Entrega
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		oPrint:Say  (_nLin,_nCol,_aCotacao[_nI][12],oFont8)
		_nCol += nColSpace+((oPrint:GetTextWidth( Replicate(" ",(TamSX3("C1_DATPRF")[1]+TamSX3("C1_DATPRF")[2]+2)) , oFont8 ))*nColFator)
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Impressao do Motivo de Compra
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		oPrint:Say  (_nLin,_nCol,_aCotacao[_nI][13],oFont8)
		_nCol += nColSpace+((oPrint:GetTextWidth( Replicate(" ",(TamSX3("C1_MOTIVO")[1]+TamSX3("C1_MOTIVO")[2])) , oFont8 ))*nColFator)
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Impressao da Descri็ใo Produto - Campo Memo
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		_nLin2     := _nLin
		_ctexto    := Alltrim(_aCotacao[_nI][4])
		_nlinhas   := mlcount(_ctexto,_nTam)
		for _ncount:= 1 to _nlinhas
			oPrint:Say  (_nLin2 ,_nCol2, memoline(_ctexto,_nTam,_ncount),oFont8)
			If _nCount <> _nLinhas
				_nLin2 += 10
				QuebraPagina(_nLin2)
			EndIf
		next _ncount
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Finaliza a Impressใo dos itens
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		
		If _nLin2 > _nLin
			_nLin := _nLin2 + 6+(oPrint:GetTextHeight("texto" , oFont8 ))*nLinFator
		Else
			_nLin += 6+(oPrint:GetTextHeight("texto" , oFont8 ))*nLinFator
			//_nLin += 10
		Endif
		
		_nCol := 000
		
		QuebraPagina(_nLin)
	Next _nI
	
	//_nLin += 10
	QuebraPagina(_nLin)
	oPrint:Line (_nLin, 005,_nLin,800) // Imprime Linha Fina
	
	cTexto  := "S๓ aceitaremos a Cota็ใo de Compras se nela constar Prazo de Entrega, Condi็ใo de Pagamento, Tipo e Valor de Frete e todas as informa็๕es relativas aos Impostos."
	cTexto1 := "Por favor cotar as marcas e modelos solicitados, caso nใo tenha informar opcional de forma clara."
	
	_nLin += 10
	QuebraPagina(_nLin)
	oPrint:Say  (_nLin,020, "NOTA: " + cTexto						,oFont10)
	
	_nLin += 10
	QuebraPagina(_nLin)
	oPrint:Say  (_nLin,020, cTexto1						,oFont10)
	
	_nLin += 10
	QuebraPagina(_nLin)
	oPrint:Line (_nLin, 005,_nLin,800) // Imprime Linha Fina
	
	_nLin += 10
	QuebraPagina(_nLin)
	
	oPrint:EndPage()     // Finaliza a pแgina
	
Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ ImpCabec     บAutor  ณJoao Rinaldi    บ Data ณ  03/03/2016 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo que realiza a impressใo do cabe็alho do relat๓rio   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Steck Industria Eletrica Ltda.                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบChamado   ณ 002103 - Layout Pedido de Compras                          บฑฑ
ฑฑบSolic.    ณ Juliana Queiroz - Depto. Compras                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ImpCabec ()
	
	_nLin := 000
	_nLin += 045
	oPrint:Box(_nLin,005,590,800)
	
	_nLin += 10
	If File(aBmp)
		oPrint:SayBitmap(_nLin+010,010,aBmp,100,030 )
	EndIf
	If File(aBmp2)
		oPrint:SayBitmap(_nLin,000,aBmp2,800,600 )
	EndIf
	_nLin += (oPrint:GetTextHeight("texto" , oFont10n ))*nLinFator
	//_nLin += 10
	oPrint:Say  (_nLin,120, _cNomeCom  ,oFont10n)
	
	_nLin += (oPrint:GetTextHeight("texto" , oFont10n ))*nLinFator
	//_nLin += 10
	oPrint:Say  (_nLin,120, Capital(Alltrim(_cEndereco)) + " - " +  Capital(Alltrim(_cBairro)) ,oFont10n)
	
	_nLin += (oPrint:GetTextHeight("texto" , oFont10n ))*nLinFator
	//_nLin += 10
	oPrint:Say  (_nLin,120,"Cep: "+ SUBSTR(_cCep,1,5)+"-"+SUBSTR(_cCep,6,3) +" - "+Capital(Alltrim(_cCidade)) +" - " + (Alltrim(_cEstado)) ,oFont10n)
	
	_nLin += (oPrint:GetTextHeight("texto" , oFont10n ))*nLinFator
	//_nLin += 10
	If cEmpAnt == "01"
		oPrint:Say  (_nLin,120,"TEL.: (011) 2248-7000 | FAX.: (011) 2248-7051",oFont10n)
	ElseIf cEmpAnt == "03"
		oPrint:Say  (_nLin,120,"TEL.: (092) 3614-8421 | FAX.: (092) 3614-8403",oFont10n)
	Endif
	
	_nLin += (oPrint:GetTextHeight("texto" , oFont10n ))*nLinFator
	//_nLin += 10
	oPrint:Say  (_nLin,120,"CNPJ: "  + Transform(_cCGC,PESQPICT("SA2","A2_CGC")) + " - I.E.: "+ _cIe   ,oFont10n)
	
	_nLin += (oPrint:GetTextHeight("texto" , oFont10n ))*nLinFator
	//_nLin += 10
	oPrint:Line (_nLin, 005,_nLin,800) // Imprime Linha Fina
	
	_nLin += 6+(oPrint:GetTextHeight("texto" , oFont10n ))*nLinFator
	//_nLin += 10
	oPrint:Say  (_nLin,020,"Cond. Pagto" 	       ,oFont10n)
	oPrint:Say  (_nLin,075,":"                   ,oFont10n)
	oPrint:Say  (_nLin,220,"Data Emissใo"			,oFont10n)
	oPrint:Say  (_nLin,290,": " + dtoc(DDataBase)	,oFont10n)
	
	_nLin += (oPrint:GetTextHeight("texto" , oFont10n ))*nLinFator
	//_nLin += 10
	oPrint:Say  (_nLin,020, "Tipo de Frete"         ,oFont10n)
	oPrint:Say  (_nLin,075, ":"                     ,oFont10n)
	oPrint:Say  (_nLin,220, "Data de Validade"      ,oFont10n)
	oPrint:Say  (_nLin,290, ": " + dtoc(Lastday(DDataBase+5,3))    ,oFont10n)
	
	_nLin += (oPrint:GetTextHeight("texto" , oFont10n ))*nLinFator
	//_nLin += 10
	oPrint:Say  (_nLin,020, "Valor de Frete"      ,oFont10n)
	oPrint:Say  (_nLin,075, ":"                   ,oFont10n)
	oPrint:Say  (_nLin,220, "Comprador"           ,oFont10n)
	oPrint:Say  (_nLin,290, ": "+Capital(Alltrim(cComprador)) + " - TEL.: " + Alltrim(cTelComprador) + " - FAX.: " + Alltrim(cFaxComprador) + " - E-MAIL.: " + Alltrim(cMailComprador) ,oFont10n)
	
	_nLin += (oPrint:GetTextHeight("texto" , oFont10n ))*nLinFator
	//_nLin += 10
	oPrint:Line (_nLin, 005,_nLin,800) // Imprime Linha Fina
	
	_nLin += 6+(oPrint:GetTextHeight("texto" , oFont10n ))*nLinFator
	//_nLin += 10
	nCol := 010
	oPrint:Say  (_nLin,nCol, RetTitle("C5_NUM")		    	,oFont8)
	nCol += nColSpace+((oPrint:GetTextWidth( Replicate(" ",(TamSX3("C1_NUM")[1]+TamSX3("C1_NUM")[2])) , oFont8 ))*nColFator)
	
	oPrint:Say  (_nLin,nCol, RetTitle("C7_ITEM")		    	,oFont8)
	nCol += nColSpace+((oPrint:GetTextWidth( Replicate(" ",(TamSX3("C1_ITEM")[1]+TamSX3("C1_ITEM")[2])) , oFont8 ))*nColFator)
	
	oPrint:Say  (_nLin,nCol, RetTitle("C1_PRODUTO")		    	,oFont8)
	nCol += nColSpace+((oPrint:GetTextWidth( Replicate(" ",(TamSX3("C1_PRODUTO")[1]+TamSX3("C1_PRODUTO")[2])) , oFont8 ))*nColFator)
	
	oPrint:Say  (_nLin,nCol, RetTitle("B1_XDESEXD")		    	,oFont8)
	nCol += nColSpace+((oPrint:GetTextWidth( Replicate(" ",_nTam) , oFont8 ))*nColFator)
	
	oPrint:Say  (_nLin,nCol, RetTitle("B1_XDESENH")		    	,oFont8)
	nCol += nColSpace+((oPrint:GetTextWidth( Replicate(" ",(TamSX3("B1_XDESENH")[1]+TamSX3("B1_XDESENH")[2])) , oFont8 ))*nColFator)
	
	oPrint:Say  (_nLin,nCol, "UM"			    	,oFont8)
	nCol += nColSpace+((oPrint:GetTextWidth( "UM"   , oFont8 ))*nColFator)
	
	oPrint:Say  (_nLin,nCol, "2a UM"		    	,oFont8)
	nCol += nColSpace+((oPrint:GetTextWidth( "2a UM" , oFont8 ))*nColFator)
	
	oPrint:Say  (_nLin,nCol, RetTitle("C1_QUANT")		    	,oFont8)
	nCol += nColSpace+((oPrint:GetTextWidth( Replicate(" ",(TamSX3("C1_QUANT")[1]+TamSX3("C1_QUANT")[2])) , oFont8 ))*nColFator)
	
	oPrint:Say  (_nLin,nCol, RetTitle("C1_QTSEGUM")		    	,oFont8)
	nCol += nColSpace+((oPrint:GetTextWidth( Replicate(" ",(TamSX3("C1_QTSEGUM")[1]+TamSX3("C1_QTSEGUM")[2])) , oFont8 ))*nColFator)
	
	oPrint:Say  (_nLin,nCol, RetTitle("C1_PRECO")		    	,oFont8)
	nCol += nColSpace+((oPrint:GetTextWidth( Replicate(" ",(TamSX3("C1_PRECO")[1]+TamSX3("C1_PRECO")[2])) , oFont8 ))*nColFator)
	
	oPrint:Say  (_nLin,nCol, RetTitle("C7_IPI")		    	,oFont8)
	nCol += nColSpace+((oPrint:GetTextWidth( Replicate(" ",(TamSX3("C7_IPI")[1]+TamSX3("C7_IPI")[2])) , oFont8 ))*nColFator)
	
	oPrint:Say  (_nLin,nCol, RetTitle("C7_DATPRF")		    	,oFont8)
	nCol += nColSpace+((oPrint:GetTextWidth( Replicate(" ",(TamSX3("C7_DATPRF")[1]+TamSX3("C7_DATPRF")[2]+2)) , oFont8 ))*nColFator)
	
	oPrint:Say  (_nLin,nCol, RetTitle("C1_MOTIVO")		    	,oFont8)
	nCol += nColSpace+((oPrint:GetTextWidth( Replicate(" ",(TamSX3("C1_MOTIVO")[1]+TamSX3("C1_MOTIVO")[2])) , oFont8 ))*nColFator)
	
	_nLin += (oPrint:GetTextHeight("texto" , oFont8 ))*nLinFator
	//_nLin += 10
	oPrint:Line (_nLin, 005,_nLin,800) // Imprime Linha Fina
	
	_nLin += 6+(oPrint:GetTextHeight("texto" , oFont8 ))*nLinFator
	//_nLin += 10
	_nLin2 := _nLin
	
Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ QuebraPagina บAutor  ณJoao Rinaldi    บ Data ณ  03/03/2016 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo que realiza a quebra de pแgina do relat๓rio         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Steck Industria Eletrica Ltda.                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบChamado   ณ 002103 - Layout Pedido de Compras                          บฑฑ
ฑฑบSolic.    ณ Juliana Queiroz - Depto. Compras                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function QuebraPagina(_nValor)
	
	If _nValor > 580
		_nValor := 590
		_nValor += 10
		oPrint:Say  (_nValor,020, "* * *   C O N T I N U A    * * *",oFont12)
		oPrint:EndPage()     // Finaliza a pแgina
		oPrint:StartPage()     // INICIALIZA a pแgina
		ImpCabec()
	Endif
	
Return(_nValor)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ EnvMail      บAutor  ณJoao Rinaldi    บ Data ณ  03/03/2016 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo que realiza o envio de e-mail                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Steck Industria Eletrica Ltda.                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบChamado   ณ 002103 - Layout Pedido de Compras                          บฑฑ
ฑฑบSolic.    ณ Juliana Queiroz - Depto. Compras                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function EnvMail(oGraphic,cAssunto,aTexto,cTo,cCC,aTabela,nEspacos)
	
	Local lOk       := .F.
	Local cMensagem
	
	aTexto   := IIF( aTexto == NIL,{},aTexto )
	aTabela  := IIF( aTabela == NIL,{},aTabela)
	nEspacos := IIF( nEspacos == NIL, 10, nEspacos )
	
	cMensagem := '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">'
	cMensagem += '<HTML><HEAD>'
	cMensagem += '<META content="text/html; charset=iso-8859-1" http-equiv=Content-Type>'
	cMensagem += '<META content="MSHTML 5.00.2920.0" name=GENERATOR></HEAD>'
	cMensagem += '<BODY aLink=#ff0000 bgColor=#ffffff link=#0000ee text=#000000 '
	cMensagem += 'vLink=#551a8b><B>'
	
	cMensagem += "<br><font Face='CALIBRI' >" + "Cota็ใo de Compra enviada automaticamente pelo sistema PROTHEUS." + "</font></br>"
	cMensagem += "<br><font Face='CALIBRI' >" + "Enviado por: " + UsrFullName(RetCodUsr()) + "</font></br>"
	cMensagem += "<br><font Face='CALIBRI' >" + "Por favor cotar em carater de Urg๊ncia." + "</font></br>"
	cMensagem += "<br><font Face='CALIBRI' >" + "ATENวรO!!! AO RESPONDER ESSE E-MAIL FAVOR COPIAR A TODOS OS ENVOLVIDOS NO MESMO!!!" + "</font></br>"
	//cMensagem += "<br><font Face='CALIBRI' >" + "Cota็ใo de Compra nบ: " + cNumCot + "</font></br>"
	
	_cMesCorp:= MsgAdic()
	cMensagem += "<br><div align='left'><font Face='CALIBRI' >"+ strtran(_cMesCorp,'.',".</FONT>  </br></div>   </tr></table></br><div align='left'><font Face='CALIBRI' > ")    +'</FONT></div>'
	cMensagem := STRTRAN(cMensagem,'ZZZZ','.')
	cMensagem := STRTRAN(cMensagem,'AAAA',"</FONT></br>  </div>   </tr></table>  <div align='left'><br><font Face='CALIBRI' >")
	cMensagem += '</B>'
	cMensagem += '<BR>&nbsp;</BR>'
	
	cMensagem += "</CENTER>"
	cMensagem += '</body>'
	
	ProcRegua(8)
	
	IncProc()
	IncProc("Conectando servidor...")
	
	If  !(	U_STMAILTES(cPara,cCopia,ctitulo,cMensagem,_aAttach,_cCaminho,cCo)  )
		Aviso("E-mail nใo enviado"; //01 - cTitulo - Tํtulo da janela
		,"Favor verificar se os e-mails abaixo sใo vแlidos:"+ Chr(10) + Chr(13) +;
			CHR(10)+CHR(13)+;
			"E-mail Para: "+ cPara+;
			CHR(10)+CHR(13)+;
			"E-mail C๓pia Oculta: "+cCo+;
			CHR(10)+CHR(13)+;
			"O E-mail nใo serแ enviado.",; //02 - cMsg - Texto a ser apresentado na janela.
		{"OK"};                          //03 - aBotoes - Array com as op็๕es dos bot๕es.
		,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
		,;                               //05 - cText - Titulo da Descri็ใo (Dentro da Janela)
		,;                               //06 - nRotAutDefault - Op็ใo padrใo usada pela rotina automแtica
		,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
		,.F.;                            //08 - lEdit - Determina se permite a edi็ใo do campo memo
		,;                               //09 - nTimer - Tempo para exibi็ใo da mensagem em segundos.
		,;                               //10 - nOpcPadrao - Op็ใo padrใo apresentada na mensagem.
		)
	EndIf
	
Return lOk

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ MsgAdic      บAutor  ณJoao Rinaldi    บ Data ณ  03/03/2016 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo que captura o texto que serแ utilizado para envio   บฑฑ
ฑฑบ          ณ no corpo de e-mail                                         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Steck Industria Eletrica Ltda.                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบChamado   ณ 002103 - Layout Pedido de Compras                          บฑฑ
ฑฑบSolic.    ณ Juliana Queiroz - Depto. Compras                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function MsgAdic()
	Local _cText:= ("")
	
	_cText := "Informamos que a partir de 14/03/2016 este serแ o novo layout das Cota็๕es de Compras STECK."
	
Return  (alltrim(_cText))

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ ChkMail      บAutor  ณJoao Rinaldi    บ Data ณ  03/03/2016 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo que realiza a caixa de texto para digita็ใo de      บฑฑ
ฑฑบ          ณ e-mail adicional                                           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Steck Industria Eletrica Ltda.                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบChamado   ณ 002103 - Layout Pedido de Compras                          บฑฑ
ฑฑบSolic.    ณ Juliana Queiroz - Depto. Compras                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ChkMail()
	
	Local oEdit1
	Local oEdit2
	Local _nOpca     := 0
	Local _lRet	   := .F.
	Local lSaida     := .F.
	Local _nK        := 0
	Local nTamOrig   := 0
	Local nMB        := 1024
	Local nTamMax    := 6
	Private _oDlg				// Dialog Principal
	
	cPara := cMailComprador + Space(200)
	
	Do While !lSaida
		DEFINE MSDIALOG _oDlg TITLE OemtoAnsi("Envio Automแtico de E-Mail") FROM C(330),C(243) TO C(449),C(721) PIXEL
		
		// Cria Componentes Padr๕es do Sistema
		@ C(005),C(009) Say "Envia e-mail para o Fornecedor listado abaixo? (Separar por ';')" Size C(147),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
		
		@ C(015),C(009) Say "Para:" Size C(147),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
		@ C(015),C(036) MsGet oEdit1 Var cPara  Size C(200),C(009) COLOR CLR_BLACK PIXEL OF _oDlg Picture "@S60"
		
		@ C(030),C(009) Say "C๓pia Oculta:" Size C(147),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
		@ C(030),C(036) MsGet oEdit2 Var cCo Size C(200),C(009) COLOR CLR_BLACK PIXEL OF _oDlg Picture "@S60"
		
		@ C(045),C(010) Button OemtoAnsi("Envia")      Size C(037),C(012) PIXEL OF _oDlg	ACTION Eval( { || _nOpca := 1, _lRet:= .T. , _oDlg:End() }  )
		@ C(045),C(060) Button OemtoAnsi("Cancela")    Size C(037),C(012) PIXEL OF _oDlg	ACTION Eval( { || _nOpca := 2, _lRet:= .F. , _oDlg:End() }  )
		@ C(045),C(110) Button OemtoAnsi("Anexar")     Size C(037),C(012) PIXEL OF _oDlg	ACTION SaveAnexo() Of _oDlg Pixel
		@ C(045),C(160) Button OemtoAnsi("Visualizar") Size C(037),C(012) PIXEL OF _oDlg	ACTION ViewAnexo() Of _oDlg Pixel
		
		ACTIVATE MSDIALOG _oDlg CENTERED
		
		If _nOpca == 1
			For _nK := 1 To Len(_aAttach)
				nTamOrig += (Directory(cStartPath+(_aAttach[_nK]))[1,2])
			Next _nK
			
			If (nTamOrig/nMB) > (nMB*nTamMax)
				Aviso("Tamanho dos Anexos Superior ao Permitido"; //01 - cTitulo - Tํtulo da janela
				,"Os Anexos possuem tamanho superior ao tamanho mแximo permitido de "+cValtoChar(nTamMax)+"MB."+ Chr(10) + Chr(13) +;
					CHR(10)+CHR(13)+;
					"Favor excluir anexos para que o e-mail possa ser enviado.",; //02 - cMsg - Texto a ser apresentado na janela.
				{"OK"};                          //03 - aBotoes - Array com as op็๕es dos bot๕es.
				,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
				,;                               //05 - cText - Titulo da Descri็ใo (Dentro da Janela)
				,;                               //06 - nRotAutDefault - Op็ใo padrใo usada pela rotina automแtica
				,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
				,.F.;                            //08 - lEdit - Determina se permite a edi็ใo do campo memo
				,;                               //09 - nTimer - Tempo para exibi็ใo da mensagem em segundos.
				,;                               //10 - nOpcPadrao - Op็ใo padrใo apresentada na mensagem.
				)
				nTamOrig := 0
				ViewAnexo()
			Else
				lSaida := .T.
				aadd( _aAttach  ,_cNomePdf+'.pdf')
			EndIf
		ElseIf _nOpca == 2
			lSaida := .T.
			aadd( _aAttach  ,_cNomePdf+'.pdf')
		Endif
	EndDo
	
	cPara := Alltrim(cPara)
	cCo   := Alltrim(cCo)
	
Return(_lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ SaveAnexo    บAutor  ณJoao Rinaldi    บ Data ณ  07/03/2016 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo desenvolvida para salvar anexo                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Steck Industria Eletrica Ltda.                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบChamado   ณ 002612 - Automatizar Solicita็ใo de Compras                บฑฑ
ฑฑบSolic.    ณ Juliana Queiroz - Depto. Compras                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function SaveAnexo()
	
	Local _cSave := ''
	Local _lRet     := .T.
	Local _cLocArq  := ''
	Local _cDir     := ''
	Local _cArq     := ''
	Local cExtensao := ''
	Local cMascara  := "Todos os arquivos"
	Local cTitulo   := "Escolha o arquivo"
	Local nMascpad  := 0
	Local cDirini   := "c:\"
	Local lSalvar   := .T. /*.F. = Salva || .T. = Abre*/
	Local lArvore   := .F. /*.T. = apresenta o แrvore do servidor || .F. = nใo apresenta*/
	Local _cMsgSave := ""
	Local aArea1    := GetArea()
	
	_cLocArq  := cGetFile( cMascara, cTitulo, nMascpad, cDirIni, lSalvar,, lArvore)
	
	If !(Empty(_cLocArq))
		_cLocArq  := Alltrim(_cLocArq)
		_cDir     := SUBSTR(_cLocArq, 1                      ,RAT( "\"   , _cLocArq ))
		_cArq     := SUBSTR(_cLocArq, RAT( "\"   , _cLocArq ),Len(_cLocArq))
		_cArq     := StrTran(_cArq,"\","")
		cExtensao := SUBSTR(_cLocArq,Rat(".",_cLocArq),Len(_cLocArq))
		
		If Len(Directory(cStartPath+_cArq)) = 1
			Aviso("Sele็ใo de Anexos"; //01 - cTitulo - Tํtulo da janela
			,"O Arquivo '"+_cArq+"' jแ foi anexado."+ Chr(10) + Chr(13)+;
				CHR(10)+CHR(13)+;
				"Favor selecionar um novo arquivo para ser anexado.",; //02 - cMsg - Texto a ser apresentado na janela.
			{"OK"};                          //03 - aBotoes - Array com as op็๕es dos bot๕es.
			,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
			,;                               //05 - cText - Titulo da Descri็ใo (Dentro da Janela)
			,;                               //06 - nRotAutDefault - Op็ใo padrใo usada pela rotina automแtica
			,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
			,.F.;                            //08 - lEdit - Determina se permite a edi็ใo do campo memo
			,;                               //09 - nTimer - Tempo para exibi็ใo da mensagem em segundos.
			,;                               //10 - nOpcPadrao - Op็ใo padrใo apresentada na mensagem.
			)
			
			Return
		Endif
		
		If At(".",cExtensao) == 1
			aadd( _aAttach  ,_cArq)
			
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Copio o arquivo original da mแquina do usuแrio para o servidor
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			lSucess   := __CopyFile(_cLocArq,cStartPath+_cArq)
			
			If !(lSucess)
				Aviso("Problema ao Anexar Arquivo"; //01 - cTitulo - Tํtulo da janela
				,"O Arquivo '"+_cArq+"' nใo foi anexado."+ Chr(10) + Chr(13) +;
					CHR(10)+CHR(13)+;
					"Favor verificar com o TI.",; //02 - cMsg - Texto a ser apresentado na janela.
				{"OK"};                          //03 - aBotoes - Array com as op็๕es dos bot๕es.
				,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
				,;                               //05 - cText - Titulo da Descri็ใo (Dentro da Janela)
				,;                               //06 - nRotAutDefault - Op็ใo padrใo usada pela rotina automแtica
				,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
				,.F.;                            //08 - lEdit - Determina se permite a edi็ใo do campo memo
				,;                               //09 - nTimer - Tempo para exibi็ใo da mensagem em segundos.
				,;                               //10 - nOpcPadrao - Op็ใo padrใo apresentada na mensagem.
				)
			EndIf
		Else
			Aviso("Problema com Extensใo do Anexo"; //01 - cTitulo - Tํtulo da janela
			,"A Extensใo "+cExtensao+" ้ invแlida para anexar junto a Solicita็ใo de Compras."+ Chr(10) + Chr(13) +;
				CHR(10)+CHR(13)+;
				"A็ใo nใo permitida.",; //02 - cMsg - Texto a ser apresentado na janela.
			{"OK"};                          //03 - aBotoes - Array com as op็๕es dos bot๕es.
			,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
			,;                               //05 - cText - Titulo da Descri็ใo (Dentro da Janela)
			,;                               //06 - nRotAutDefault - Op็ใo padrใo usada pela rotina automแtica
			,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
			,.F.;                            //08 - lEdit - Determina se permite a edi็ใo do campo memo
			,;                               //09 - nTimer - Tempo para exibi็ใo da mensagem em segundos.
			,;                               //10 - nOpcPadrao - Op็ใo padrใo apresentada na mensagem.
			)
		Endif
	Else
		Aviso("Anexar Arquivo"; //01 - cTitulo - Tํtulo da janela
		,"Nenhum Arquivo foi selecionado para ser anexado.",; //02 - cMsg - Texto a ser apresentado na janela.
		{"OK"};                          //03 - aBotoes - Array com as op็๕es dos bot๕es.
		,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
		,;                               //05 - cText - Titulo da Descri็ใo (Dentro da Janela)
		,;                               //06 - nRotAutDefault - Op็ใo padrใo usada pela rotina automแtica
		,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
		,.F.;                            //08 - lEdit - Determina se permite a edi็ใo do campo memo
		,;                               //09 - nTimer - Tempo para exibi็ใo da mensagem em segundos.
		,;                               //10 - nOpcPadrao - Op็ใo padrใo apresentada na mensagem.
		)
	Endif
	
	RestArea(aArea1)
	
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ ViewAnexo บAutor  ณJoao Rinaldi       บ Data ณ  07/03/2016 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo para que o comprador possa visualizar os arquivos   บฑฑ
ฑฑบ          ณ anexados e com a op็ใo de marcar os anexos que serใo       บฑฑ
ฑฑบ          ณ excluํdos                                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Steck Industria Eletrica Ltda.                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบChamado   ณ 002612 - Automatizar Solicita็ใo de Compras                บฑฑ
ฑฑบSolic.    ณ Juliana Queiroz - Depto. Compras                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ViewAnexo()
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณDeclara็ใo das Variแveis
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	Local _aAnexo    := {}
	Local _nJ
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณVariแveis para montagem da Tela - MsNewGetDados
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	Local _cTitulo     := "Rela็ใo de Anexos"
	Local aSize        := MsAdvSize(, .F., 400)
	Local aInfo        := {aSize[1],aSize[2],aSize[3],aSize[4]-12, 1, 1 }
	Local aObjects     := {{100, 100,.T.,.T. }}
	Local aPosObj      := MsObjSize( aInfo, aObjects,.T. )
	Local nStyle       := GD_INSERT+GD_DELETE+GD_UPDATE
	Local _aCamposEdit := {} //{"COR","D2_FILIAL","D2_DOC"}
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณVariแveis de A็ใo da MsNewGetDados
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	Local _aButtons    := {}
	Local _bOk         := {|| (STTOK(@_aAnexo,@oDlgCons))}
	Private _bCancel   := {|| oDlgCons:End() }
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณVariแveis de Objeto e Flag da MsNewGetDados
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	Private oGetDados1
	Private oOk        := LoadBitmap( GetResources(), "LBOK" )//"MARCADO"
	Private oNo        := LoadBitmap( GetResources(), "LBNO" )//"DESMARCADO"
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณVariแvies do Cabe็alho e Itens da MsNewGetDados
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	Private _aHeader   := {}
	//Private _aAnexo   := {}
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณTamanho de Fonte a ser exibida na Tela
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	oFont13 := TFont():New("Arial",9,24,.T.,.F.,5,.T.,5,.T.,.F.)
	
	If Len(_aAttach) >= 1
		For _nJ := 1 to Len (_aAttach)
			aAdd(_aAnexo,{"LBNO",;
				cValtoChar(_nJ),;
				_aAttach[_nJ],;
				CValtoCHar(Round(Directory(cStartPath+(_aAttach[_nJ]))[1,2]/1024,0)) + " KB",;
				.F.})
		Next _nJ
		STaHeader()
		
		Define MSDialog oDlgCons Title _cTitulo From aSize[7],000 To aSize[6],aSize[5] of GetWndDefault() Pixel
		
		@ aPosObj[1,1]+2,aPosObj[1,2]+5 Say "Marque os Arquivos que serใo excluํdos:" Of oDlgCons Pixel COLOR CLR_HBLUE FONT oFont13
		oGetDados1 := MsNewGetDados():New( aPosObj[1,1]+20      , aPosObj[1,2]+5                , aPosObj[1,3]     , aPosObj[1,4] ,              ,"AllWaysTrue","AllWaysTrue",""        , _aCamposEdit         ,/*freeze*/,999,/*fieldok*/,/*superdel*/,/*delok*/,oDlgCons,_aHeader,_aAnexo)
		bDbClick := oGetDados1:oBrowse:bLDblClick
		oGetDados1:oBrowse:bldblClick := {|| STClick(@_aAnexo) }
		oGetDados1:oBrowse:SetFocus()
		
		ACTIVATE MSDIALOG oDlgCons CENTERED ON INIT EnchoiceBar(oDlgCons, _bOk, _bCancel,,_aButtons)
		
	Else
		Aviso("Sele็ใo de Anexos"; //01 - cTitulo - Tํtulo da janela
		,"Nใo existe nenhum anexo a ser visualizado."+CHR(10)+CHR(13)+;
			CHR(10)+CHR(13)+;
			"",;//02 - cMsg - Texto a ser apresentado na janela.
		{"OK"};                          //03 - aBotoes - Array com as op็๕es dos bot๕es.
		,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
		,;                               //05 - cText - Titulo da Descri็ใo (Dentro da Janela)
		,;                               //06 - nRotAutDefault - Op็ใo padrใo usada pela rotina automแtica
		,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
		,.F.;                            //08 - lEdit - Determina se permite a edi็ใo do campo memo
		,;                               //09 - nTimer - Tempo para exibi็ใo da mensagem em segundos.
		,;                               //10 - nOpcPadrao - Op็ใo padrใo apresentada na mensagem.
		)
	Endif
	
Return _aAttach

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ STaHeader บAutor  ณJoao Rinaldi       บ Data ณ  07/03/2016 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo para retornar o aHeader                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Steck Industria Eletrica Ltda.                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบChamado   ณ 002612 - Automatizar Solicita็ใo de Compras                บฑฑ
ฑฑบSolic.    ณ Juliana Queiroz - Depto. Compras                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function STaHeader()
	
	//aAdd(_aHeader,{Tํtulo                 ,Campo         ,Picture                      ,Tamanho                  ,Decimal                   ,Valida็ใo,Reservado        ,Tipo                    ,Reservado,Reservado})
	Aadd(_aHeader,{"Flag"                   ,"XX_FLAG"     ,"@BMP"                       ,1                        ,0                         ,""       ,""               ,""                      ,"","","","",".T."})
	aAdd(_aHeader,{RetTitle("C7_ITEM")      ,"C7_ITEM"     ,PesqPict("SC7","C7_ITEM")    ,TamSx3("C7_ITEM")[1]     ,TamSx3("C7_ITEM")[2]      ,""       ,"€€€€€€€€€€€€€€€",TamSx3("C7_ITEM")[3]    ,"","","","",".T."})
	aAdd(_aHeader,{RetTitle("J4_NOMARQ")    ,"J4_NOMARQ"   ,PesqPict("SJ4","J4_NOMARQ")  ,TamSx3("J4_NOMARQ")[1]   ,TamSx3("J4_NOMARQ")[2]    ,""       ,"€€€€€€€€€€€€€€€",TamSx3("J4_NOMARQ")[3]  ,"","","","",".T."})
	aAdd(_aHeader,{"Tamanho do Arquivo"     ,"C1_QUANT"    ,"@999,999,999"               ,TamSx3("C1_QUANT")[1]    ,TamSx3("C1_QUANT")[2]     ,""       ,"€€€€€€€€€€€€€€€",TamSx3("C1_QUANT")[3]   ,"","","","",".T."})
	
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ STClick   บAutor  ณJoao Rinaldi       บ Data ณ  07/03/2016 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo para validar o Clique acionado pelo usuแrio na tela บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Steck Industria Eletrica Ltda.                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบChamado   ณ 002612 - Automatizar Solicita็ใo de Compras                บฑฑ
ฑฑบSolic.    ณ Juliana Queiroz - Depto. Compras                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function STClick(_aAnexo,oDlgCons)
	
	Local nPosFLAG := aScan(oGetDados1:aHeader,{|x| AllTrim(x[2]) == "XX_FLAG"})
	
	If oGetDados1:aCols[oGetDados1:nAt][nPosFLAG] == "LBNO" // DESMARCADO
		oGetDados1:aCols[oGetDados1:nAt][nPosFLAG] := "LBOK" // MARCADO
		oGetDados1:oBrowse:Refresh()
	Else
		oGetDados1:aCols[oGetDados1:nAt][nPosFLAG] := "LBNO" // DESMARCADO
		oGetDados1:oBrowse:Refresh()
	Endif
	
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ STTOK     บAutor  ณJoao Rinaldi       บ Data ณ  07/03/2016 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo para validar a Confirma็ใo das informa็๕es marcadas บฑฑ
ฑฑบ          ณ na tela pelo usuแrio                                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Steck Industria Eletrica Ltda.                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบChamado   ณ 002612 - Automatizar Solicita็ใo de Compras                บฑฑ
ฑฑบSolic.    ณ Juliana Queiroz - Depto. Compras                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function STTOK(_aAnexo)
	
	Local nPosFLAG   := aScan(oGetDados1:aHeader,{|x| AllTrim(x[2]) == "XX_FLAG"})
	Local nPosFile   := aScan(oGetDados1:aHeader,{|x| AllTrim(x[2]) == "J4_NOMARQ"})
	Local _nK
	Local cStatus    := ''
	Local _nAnexo    := 0
	Local cTexto1    := ''
	Local cTexto2    := ''
	
	For _nK := 1 to Len(oGetDados1:aCols)
		IF oGetDados1:aCols[_nK][nPosFLAG] == "LBOK" // MARCADO
			_nAnexo ++
		EndIf
	Next _nK
	
	If (_nAnexo > 0)
		If _nAnexo == 1
			cTexto1 := "Existe apenas" + cValtoChar(_nAnexo) + " Item Selecionado."
			cTexto2 := "Deseja excluir o anexo ?"
		Else
			cTexto1 := "Existem " + cValtoChar(_nAnexo) + " Itens Selecionados."
			cTexto2 := "Deseja excluir os anexos ?"
		Endif
		
		If MsgYesNo(cTexto1+ Chr(10) + Chr(13) +cTexto2,"Sele็ใo de Anexos")
			For _nK := 1 to Len(oGetDados1:aCols)
				IF oGetDados1:aCols[_nK][nPosFLAG] == "LBOK" // MARCADO
					FERASE(cStartPath+_aAttach[_nK])//Apaga anexos do Servidor
				EndIf
			Next _nK
			
			_aAttach := {}
			For _nK := 1 to Len(oGetDados1:aCols)
				IF !oGetDados1:aCols[_nK][nPosFLAG] == "LBOK" // MARCADO
					aadd( _aAttach  ,oGetDados1:aCols[_nK][nPosFile])
				EndIf
			Next _nK
		Endif
		
	Else
		Aviso("Sele็ใo de Anexos"; //01 - cTitulo - Tํtulo da janela
		,"Nenhum Arquivo foi Selecionado para ser excluํdo."+CHR(10)+CHR(13)+;
			CHR(10)+CHR(13)+;
			"",;                          //02 - cMsg - Texto a ser apresentado na janela.
		{"OK"};                          //03 - aBotoes - Array com as op็๕es dos bot๕es.
		,3;                              //04 - nSize - Tamanho da janela. Pode ser 1, 2 ou 3
		,;                               //05 - cText - Titulo da Descri็ใo (Dentro da Janela)
		,;                               //06 - nRotAutDefault - Op็ใo padrใo usada pela rotina automแtica
		,;                               //07 - cBitmap - Nome do bitmap a ser apresentado
		,.F.;                            //08 - lEdit - Determina se permite a edi็ใo do campo memo
		,;                               //09 - nTimer - Tempo para exibi็ใo da mensagem em segundos.
		,;                               //10 - nOpcPadrao - Op็ใo padrใo apresentada na mensagem.
		)
	Endif
	
Return oDlgCons:End()
