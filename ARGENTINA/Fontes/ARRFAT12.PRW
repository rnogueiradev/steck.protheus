#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "AP5MAIL.CH"
#Include "TOPCONN.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"

/*/{Protheus.doc} ARRFAT12
Complemiento del Prospects
@type function
@author Jose C. Frasson
@since 	06/05/2020
@version Protheus 12 - Faturamento
@history ,Ticket 20191211000031 ,
/*/

User Function ARRFAT12()

	LOCAL   n 			:= 0
	Local aArea  		:= GetArea()
	Private cEmailFor	:= ""
	PRIVATE oPrint
	PRIVATE _cNomeCom   := SM0->M0_NOMECOM
	PRIVATE _cEndereco  := SM0->M0_ENDENT
	PRIVATE cCep        := SM0->M0_CEPENT
	PRIVATE cCidade     := SM0->M0_CIDENT
	PRIVATE cBairro     := SM0->M0_BAIRENT
	PRIVATE cEstado     := SM0->M0_ESTENT
	PRIVATE cCNPJ       := SM0->M0_CGC
	PRIVATE cTelefone   := SM0->M0_TEL
	PRIVATE cFax        := SM0->M0_FAX
	PRIVATE cIe         := Alltrim(SM0->M0_INSC)
	PRIVATE	titulo		:= "Env�o de E-Mail - Steck Electric S.A. - Prospeect N� " + SUS->US_COD
	PRIVATE cStartPath 	:= '\arquivos\InvoiceArg\'
	PRIVATE _cPath		:= GetSrvProfString("RootPath","")
	PRIVATE _cNomePdf   :=''
	Private _cDirRel    := Getmv("MV_RELT",,'C:\ARQUIVOS_PROTHEUS\')
	Private _lxRet      := .T.

	DbSelectArea("SUS")

	Processa({|lEnd|xMontaRel()})

	RestArea(aArea)
Return Nil

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � MontaRel � Autor � Jose C. Frasson       						� Data �06/05/2020  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Impressao DO RELATORIO                                     ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico Steck                                           ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function xMontaRel()

	Local lRet := .f.
	Local _lCont := .f.

	If SUS->(eof())

		msgstop("Propspect no Encontrado !!! Comprobar !!! " )

	else

		//_lCont := RRFATMPa(SUS->US_COD,SUS->US_LOJA)

		_cNomePdf	:= cEmpAnt + "_PROSPECT_" + SUS->US_COD
		oPrint		:= fwmsprinter():New( _cNomePdf , 6      ,.F.             , '\arquivos\InvoiceArg\'  ,.T.			,  ,  ,  ,  .f.,  ,.f.,.f. )
		oPrint:SetLandScape() 
		oPrint:SetMargin(60,60,60,60)
		oPrint:setPaperSize(9)

		cEmailFor 	:= ""

		xImpress()

		// Indique o caminho onde ser� gravado o PDF
		FERASE(cStartPath + _cNomePdf + ".pdf")
		oPrint:cPathPDF	:= cStartPath
		oPrint:Print()

		If ExistDir(_cDirRel)
			_lxRet := .T.
		Else
			If MakeDir(_cDirRel) == 0
				MakeDir(_cDirRel)
				Aviso("Creacion de carpetas","Se ha creado en esa computadora una carpeta para que las cotizaciones emitidas all� sean guardadas despu�s de la impresi�n ... !!!"+CHR(10)+CHR(13)+;
				CHR(10)+CHR(13)+;
				"Sigue la ruta del directorio creado:"+CHR(10)+CHR(13)+;
				CHR(10)+CHR(13)+;
				_cDirRel,;
				{"OK"},3)
				_lxRet := .T.
			Else
				Aviso("Error en la creaci�n de carpetas","Para guardar el Pedido de Venta en cuesti�n es necesario que una carpeta sea creada en ese ordenador ... !!!"+CHR(10)+CHR(13)+;
				CHR(10)+CHR(13)+;
				"Por favor, p�ngase en contacto con el TI para que la creaci�n de la carpeta se realice ... !!!:"+CHR(10)+CHR(13)+;
				CHR(10)+CHR(13)+;
				"No ser� posible realizar la apertura del Pedido de Venta en archivo PDF y consecuentemente no ser� enviado v�a e-mail al cliente ... !!!",;
				{"OK"},3)
				_lxRet := .F.
			Endif
		Endif

		If _lxRet
			FERASE(_cDirRel + "\" + _cNomePdf + ".pdf")
			CpyS2T(cStartPath + _cNomePdf + '.pdf',_cDirRel + "\",.T.) // COPIA ARQUIVO PARA MAQUINA DO USU�RIO
			ShellExecute("open",_cDirRel + "\" + _cNomePdf + '.pdf', "", "", 1)
			/*
			If MsgBox("Enviar correo electr�nico al cliente?","Env�o de E-Mail","YESNO")

			lRet := U__x2lChkMail() // Abre tela Para Digitar Manualmente E-Mails

			If lRet
			Processa({|lEnd| xBrEnvMail(oPrint,"Presupuesto: "+ SCJ->CJ_NUM,{"Presupuesto: "+ SCJ->CJ_NUM},cEmailFor,"",{},10)},titulo)
			EndIf

			Endif
			*/
		Endif
	EndIf 

Return nil


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � xImpress � Autor � Jose C. Frasson       						� Data �06/05/2020 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Impressao do Relat�rio                                     ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico Steck                                           ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function xImpress()

	Local 	i 			:= 0
	Local oBrush
	Local nLineLength 	:= 95
	Local nTabSize 		:= 3
	Local lWrap 		:= .T.
	Local _nTotVlr		:= 0
	Local _nTotQtd		:= 0
	Local cCodUser 		:= RetCodUsr() //Retorna o Codigo do Usuario
	Local cNamUser 		:= UsrFullName( cCodUser ) +" - "+UsrRetMail ( cCodUser )//Retorna o nome do usuario
	Local _cUsrInc 		:= ""//UsrFullName( SCJ->CJ_XUSRINC )+" - "+DtoC(SCJ->CJ_EMISSAO) // Chamado 008811 - Everson Santana
	Local nLines1 		:= 0
	Local nCurrentLine 	:= 0
	Local _aTpDesc 		:= {}
	Private _nLin 		:= 4000

	aBmp := "STECK.BMP"

	oFont2n := TFont():New("Times New Roman",,10,,.T.,,,,,.F. )
	oFont5  := TFont():New("Arial",9,5 ,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont6  := TFont():New("Arial",9,6 ,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont8  := TFont():New("Arial",9,8 ,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont9  := TFont():New("Arial",9,9 ,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont10 := TFont():New("Arial",9,10,.T.,.F.,5,.T.,5,.T.,.F.)
	oFont10n:= TFont():New("Arial",9,10,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont11 := TFont():New("Arial",9,11,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont12 := TFont():New("Arial",9,12,.T.,.T.,5,.T.,5,.T.,.F.)
	oFont12s:= TFont():New("Arial",9,12,.T.,.T.,5,.T.,5,.T.,.T.)

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

	_npagina := 0
	_aItRed	:= {}
	Dbselectarea("SM0")

	oPrint:StartPage() 
	xCabPros()

	_nLin +=5

	oPrint:Line (_nLin, 315,_nLin,500)
	_nLin+=15

/*
	If _nLin > 600
		_nLin+=05
		oPrint:Say  (_nLin,020, "* * *   C O N T I N � A    * * *",oFont12)
		oPrint:EndPage()     // Finaliza a p�gina
		oPrint:StartPage()     // INICIALIZA a p�gina
		xCabPros()
	Endif
*/

	oPrint:EndPage()     // Finaliza a p�gina

Return()

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
��������������������������������������������������������������������������"��
���Programa  �xCabPros   �Autor  � Everson Santana    � Data � 31/07/13    ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Steck                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function xCabPros()

	Local _aTpDesc 	:= {}
	Local _nPos	 	:= 0
	Local nLin 		:= 150

	//oPrint:Box(045,005,610,800)

	If File(aBmp)
		oPrint:SayBitmap(050,040,aBmp,105,050 )
	EndIf

	oPrint:Say  (nLin,0010, u_xMyRetCpo("US_COD") 				+ ": " + SUS->US_COD, oFont12)
	oPrint:Say  (nLin,0095, u_xMyRetCpo("US_NOME") 				+ ": " + SUS->US_NOME, oFont12)
	oPrint:Say  (nLin,0400, u_xMyRetCpo("US_XCDCONT") 			+ ": " + SUS->US_XCDCONT, oFont12)
	oPrint:Say  (nLin,0490, POSICIONE("SU5",1,XFILIAL("SU5") 	+ SUS->US_XCDCONT, "U5_CONTAT"), oFont12)
	oPrint:Say  (nLin,0700, u_xMyRetCpo("US_XTELCTO") 	+ ": " 	+ SUS->US_XTELCTO, oFont12)

	nLin += 15
	oPrint:Say  (nLin,0010, u_xMyRetCpo("US_END")	+ ": " + SUS->US_END, oFont12) 
	nLin += 15
	oPrint:Say  (nLin,0010, u_xMyRetCpo("US_EMAIL") 	+ ": " + SUS->US_EMAIL, oFont12) 

	nLin += 30
	oPrint:Say  (nLin,0010, "Conoces la Marca?", oFont12) 
	oPrint:Say  (nLin,0130, IIF(SUS->US_XCMP01 = "S", "SI","NO"),oFont14n) 

	nLin += 15
	oPrint:Say  (nLin,0010, "Trabajas en la Marca?", oFont12) 
	oPrint:Say  (nLin,0130, IIF(SUS->US_XCMP02 = "S", "SI","NO"),oFont14n) 

	nLin += 15
	oPrint:Say  (nLin,0010, "Tienes publicidad?", oFont12) 
	oPrint:Say  (nLin,0130, IIF(SUS->US_XCMP03 = "S", "SI","NO"),oFont14n) 

	nLin += 15
	oPrint:Say  (nLin,0010, "Con que lineas trabajas?", oFont12) 
	oPrint:Say  (nLin,0130, SUS->US_XCMP04,oFont12) 

	nLin += 15
	oPrint:Box(nLin,0010,nLin + 335,0370)
	oPrint:Box(nLin,0380,nLin + 335,0800)

	// Linhas Verticais
	oPrint:Box(nLin,0105,nLin + 335,0105)
	oPrint:Box(nLin,0165,nLin + 335,0165)
	oPrint:Box(nLin,0245,nLin + 335,0245)
	oPrint:Box(nLin,0315,nLin + 335,0315)

	nLin += 15
	oPrint:Say  (nLin,0010, "     PRODUCTOS    ", oFont12)
	oPrint:Say  (nLin,0105, "    MARCA     ", oFont12) 
	oPrint:Say  (nLin,0175, "   DIRECTO    ", oFont12) 
	oPrint:Say  (nLin,0245, "  MAYORISTA   ", oFont12) 
	oPrint:Say  (nLin,0315, "    CUAL?     ", oFont12) 

	oPrint:Say  (nLin,0390, "OBSERVACIONES ", oFont12) 	

	nLin += 10
	oPrint:Box(nLin,0010,nLin,0370)
	oPrint:Box(nLin,0380,nLin,0800)

	nLin += 10
	oPrint:Say  (nLin+2,0012, "TABLEROS", oFont12) 
	oPrint:Say  (nLin,0382, SUS->US_XCMP09, oFont5) // Char 200  

	oPrint:Say  (nLin+2,0106, SUS->US_XCMP05, oFont6) // Char 100 
	oPrint:Say  (nLin+2,0168, SUS->US_XCMP06, oFont6) // Char 100 
	oPrint:Say  (nLin+2,0246, SUS->US_XCMP07, oFont6) // Char 100 
	oPrint:Say  (nLin+2,0318, SUS->US_XCMP08, oFont6) // Char 100  

	nLin += 10
	oPrint:Box(nLin,0010,nLin,0370)
	oPrint:Box(nLin,0380,nLin,0800)

	nLin += 10
	oPrint:Say  (nLin+2,0012, "CAJAS DE PASO", oFont12) 
	oPrint:Say  (nLin+2,0106, SUS->US_XCMP10, oFont6) // Char 100 
	oPrint:Say  (nLin+2,0168, SUS->US_XCMP11, oFont6) // Char 100 
	oPrint:Say  (nLin+2,0246, SUS->US_XCMP12, oFont6) // Char 100 
	oPrint:Say  (nLin+2,0318, SUS->US_XCMP13, oFont6) // Char 100  
	oPrint:Say  (nLin+2,0382, SUS->US_XCMP14, oFont6) // Char 200  

	nLin += 10
	oPrint:Box(nLin,0010,nLin,0370)
	oPrint:Box(nLin,0380,nLin,0800)

	nLin += 10
	oPrint:Say  (nLin+2,0012, "TERMICAS", oFont12) 
	oPrint:Say  (nLin+2,0106, SUS->US_XCMP15, oFont6) // Char 100 
	oPrint:Say  (nLin+2,0168, SUS->US_XCMP16, oFont6) // Char 100 
	oPrint:Say  (nLin+2,0246, SUS->US_XCMP17, oFont6) // Char 100 
	oPrint:Say  (nLin+2,0318, SUS->US_XCMP18, oFont6) // Char 100  
	oPrint:Say  (nLin+2,0382, SUS->US_XCMP19, oFont6) // Char 200  

	nLin += 10
	oPrint:Box(nLin,0010,nLin,0370)
	oPrint:Box(nLin,0380,nLin,0800)

	nLin += 10
	oPrint:Say  (nLin+2,0012, "DIFERENCIALES", oFont12) 
	oPrint:Say  (nLin+2,0106, SUS->US_XCMP20, oFont6) // Char 100 
	oPrint:Say  (nLin+2,0168, SUS->US_XCMP21, oFont6) // Char 100 
	oPrint:Say  (nLin+2,0246, SUS->US_XCMP22, oFont6) // Char 100 
	oPrint:Say  (nLin+2,0318, SUS->US_XCMP23, oFont6) // Char 100  
	oPrint:Say  (nLin+2,0382, SUS->US_XCMP24, oFont6) // Char 200  

	nLin += 10
	oPrint:Box(nLin,0010,nLin,0370)
	oPrint:Box(nLin,0380,nLin,0800)

	nLin += 10
	oPrint:Say  (nLin+2,0012, "PEINES", oFont12) 
	oPrint:Say  (nLin+2,0106, SUS->US_XCMP25, oFont6) // Char 100 
	oPrint:Say  (nLin+2,0168, SUS->US_XCMP26, oFont6) // Char 100 
	oPrint:Say  (nLin+2,0246, SUS->US_XCMP27, oFont6) // Char 100 
	oPrint:Say  (nLin+2,0318, SUS->US_XCMP28, oFont6) // Char 100  
	oPrint:Say  (nLin+2,0382, SUS->US_XCMP29, oFont6) // Char 200  

	nLin += 10
	oPrint:Box(nLin,0010,nLin,0370)
	oPrint:Box(nLin,0380,nLin,0800)

	nLin += 10
	oPrint:Say  (nLin+2,0012, "CONTACTORES", oFont12) 
	oPrint:Say  (nLin+2,0106, SUS->US_XCMP30, oFont6) // Char 100 
	oPrint:Say  (nLin+2,0168, SUS->US_XCMP31, oFont6) // Char 100 
	oPrint:Say  (nLin+2,0246, SUS->US_XCMP32, oFont6) // Char 100 
	oPrint:Say  (nLin+2,0318, SUS->US_XCMP33, oFont6) // Char 100  
	oPrint:Say  (nLin+2,0382, SUS->US_XCMP34, oFont6) // Char 200  

	nLin += 10
	oPrint:Box(nLin,0010,nLin,0370)
	oPrint:Box(nLin,0380,nLin,0800)

	nLin += 10                                      
	oPrint:Say  (nLin+2,0012, "PULSADORES", oFont12) 
	oPrint:Say  (nLin+2,0106, SUS->US_XCMP35, oFont6) // Char 100 
	oPrint:Say  (nLin+2,0168, SUS->US_XCMP36, oFont6) // Char 100 
	oPrint:Say  (nLin+2,0246, SUS->US_XCMP37, oFont6) // Char 100 
	oPrint:Say  (nLin+2,0318, SUS->US_XCMP38, oFont6) // Char 100  
	oPrint:Say  (nLin+2,0382, SUS->US_XCMP39, oFont6) // Char 200  

	nLin += 10
	oPrint:Box(nLin,0010,nLin,0370)
	oPrint:Box(nLin,0380,nLin,0800)

	nLin += 10
	oPrint:Say  (nLin+2,0012, "RELEVOS", oFont12) 
	oPrint:Say  (nLin+2,0106, SUS->US_XCMP40, oFont6) // Char 100 
	oPrint:Say  (nLin+2,0168, SUS->US_XCMP41, oFont6) // Char 100 
	oPrint:Say  (nLin+2,0246, SUS->US_XCMP42, oFont6) // Char 100 
	oPrint:Say  (nLin+2,0318, SUS->US_XCMP43, oFont6) // Char 100  
	oPrint:Say  (nLin+2,0382, SUS->US_XCMP44, oFont6) // Char 200  

	nLin += 10
	oPrint:Box(nLin,0010,nLin,0370)
	oPrint:Box(nLin,0380,nLin,0800)

	nLin += 10
	oPrint:Say  (nLin+2,0012, "TOMAS Y FICHAS", oFont12) 

	nLin += 08
	oPrint:Say  (nLin,0106, SUS->US_XCMP45, oFont6) // Char 100 
	oPrint:Say  (nLin,0168, SUS->US_XCMP46, oFont6) // Char 100 
	oPrint:Say  (nLin,0246, SUS->US_XCMP47, oFont6) // Char 100 
	oPrint:Say  (nLin,0318, SUS->US_XCMP48, oFont6) // Char 100  
	oPrint:Say  (nLin,0382, SUS->US_XCMP49, oFont6) // Char 200  

	nLin += 02
	oPrint:Say  (nLin,0012, "INDUSTRIALES", oFont12) 

	nLin += 10
	oPrint:Box(nLin,0010,nLin,0370)
	oPrint:Box(nLin,0380,nLin,0800)

	nLin += 10
	oPrint:Say  (nLin+2,0012, "PRENSA CABLES", oFont12) 
	oPrint:Say  (nLin+2,0106, SUS->US_XCMP50, oFont6) // Char 100 
	oPrint:Say  (nLin+2,0168, SUS->US_XCMP51, oFont6) // Char 100 
	oPrint:Say  (nLin+2,0246, SUS->US_XCMP52, oFont6) // Char 100 
	oPrint:Say  (nLin+2,0318, SUS->US_XCMP53, oFont6) // Char 100  
	oPrint:Say  (nLin+2,0382, SUS->US_XCMP54, oFont6) // Char 200  

	nLin += 10
	oPrint:Box(nLin,0010,nLin,0370)
	oPrint:Box(nLin,0380,nLin,0800)

	nLin += 20
	oPrint:Box(nLin,0010,nLin,0370)
	oPrint:Box(nLin,0380,nLin,0800)

	nLin += 20
	oPrint:Box(nLin,0010,nLin,0370)
	oPrint:Box(nLin,0380,nLin,0800)

	nLin += 20
	oPrint:Box(nLin,0010,nLin,0370)
	oPrint:Box(nLin,0380,nLin,0800)

	nLin += 20
	oPrint:Box(nLin,0010,nLin,0370)
	oPrint:Box(nLin,0380,nLin,0800)


Return()

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �xBrEnvMail� Autor � Everson Santana       � Data �31/07/13  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Envio Do Orcamento/Cotacao por e-mail automaticamente      ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico Steck                                           ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function xBrEnvMail(oGraphic,cAssunto,aTexto,cTo,cCC,aTabela,nEspacos)

	Local cMailConta	:= GETMV("MV_RELACNT")
	Local cMailServer	:= GETMV("MV_RELSERV")
	Local cMailSenha	:= GETMV("MV_RELPSW")
	Local lAuth 		:= GetMv("MV_RELAUTH",,.F.)

	Local lOk			:= .F.
	Local cMensagem
	Local nx			:= 0
	Local lBmp := !( oGraphic == NIL )
	Local  nWidth := 0
	Local cError
	local _aAttach := {}//'c:\six0101.dbf'
	Local _cCaminho:=cStartPath
	Local _nIni:=1
	Local _nFim:=100

	aadd( _aAttach  ,_cNomePdf+'.pdf')

	If Empty(cCC)
	EndIf

	aTexto   := IIF( aTexto == NIL,{},aTexto )
	aTabela  := IIF( aTabela == NIL,{},aTabela)
	nEspacos := IIF( nEspacos == NIL, 10, nEspacos )

	cMensagem := '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//PT">'
	cMensagem += '<HTML><HEAD>'
	cMensagem += '<META content="text/html; charset=iso-8859-1" http-equiv=Content-Type>'
	cMensagem += '<META content="MSHTML 5.00.2920.0" name=GENERATOR></HEAD>'
	cMensagem += '<BODY aLink=#ff0000 bgColor=#ffffff link=#0000ee text=#000000 '
	cMensagem += 'vLink=#551a8b><B>'

	cMensagem += "<br><font Face='CALIBRI' >" + "Prospect enviado autom�ticamente por el sistema PROTHEUS" + "</font></br>"
	cMensagem += "<br><font Face='CALIBRI' >" + "Enviado por: " + UsrFullName(RetCodUsr()) + "</font></br>"
	//cMensagem += "<br><font Face='CALIBRI' >" + "ATENCI�N! No responda este correo. Reenv�e su respuesta a la siguiente direcci�n: ventas.ar@steckgroup.com" + "</font></br>"
	cMensagem += "<br><font Face='CALIBRI' >" + "Prospect n�: " + SUS->US_COD + "</font></br>"

	_cMesCorp:= StMSg()
	cMensagem += "<br><div align='left'><font Face='CALIBRI' >"+ strtran(_cMesCorp,'.',".</FONT>  </br></div>   </tr></table></br><div align='left'><font Face='CALIBRI' > ")    +'</FONT></div>'
	cMensagem:=STRTRAN(cMensagem,'ZZZZ','.')
	cMensagem:=STRTRAN(cMensagem,'AAAA',"</FONT></br>  </div>   </tr></table>  <div align='left'><br><font Face='CALIBRI' >")
	cMensagem += '</B>'
	cMensagem += '<BR>&nbsp;</BR>'

	cMensagem += "</CENTER>"
	cMensagem += '</body>'

	ProcRegua(8)

	IncProc()
	IncProc("Conectando servidor...")

	// Envia e-mail com os dados necessarios

	If  !(u_ARMAILTES(cEmailFor,cCopia,titulo,cMensagem,_aAttach,_cCaminho)  )
		MsgInfo("Correo no enviado.....!!!!!")
	EndIf

Return lOk

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �_x2lChkMail� Autor � Everson Santana      � Data �31/07/13  ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Caixa De Texto Para Digita��o De E-Mail Opcional.          ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico Steck                                           ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
/*
User Function _x2lChkMail()

//Variaveis Locais da Funcao
Local oEdit1
Local _lRet		:= .f.

cEMailFor 		:= cEMailFor+Space(200)

// Variaveis Private da Funcao
Private _oDlg				// Dialog Principal
Private INCLUI := .F.	// (na Enchoice) .T. Traz registro para Inclusao / .F. Traz registro para Alteracao/Visualizacao

DEFINE MSDIALOG _oDlg TITLE OemtoAnsi("Env�o autom�tico de correo electr�nico") FROM C(330),C(243) TO C(449),C(721) PIXEL


// Cria Componentes Padroes do Sistema
@ C(008),C(009) Say "Enviar correo electr�nico al cliente que aparece a continuaci�n? (Separar por ';')" Size C(147),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
@ C(021),C(010) MsGet oEdit1 Var cEMailFor Size C(218),C(009) COLOR CLR_BLACK PIXEL OF _oDlg Picture "@S60"
@ C(044),C(137) Button OemtoAnsi("Enviar") Size C(037),C(012) PIXEL OF _oDlg	Action Eval( { || _lRet:= .t. , _oDlg:End() }  )
@ C(044),C(185) Button OemtoAnsi("Anular") Size C(037),C(012) PIXEL OF _oDlg	Action(_oDlg:End())


ACTIVATE MSDIALOG _oDlg CENTERED

Return(_lRet)
*/
/*������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������Ŀ��
���Programa   �   C()      � Autor � Everson Santana       � Data �31/07/13  ���
����������������������������������������������������������������������������Ĵ��
���Descricao  � Funcao responsavel por manter o Layout independente da       ���
���           � resolu��o horizontal do Monitor do Usuario.                  ���
����������������������������������������������������������������������������Ĵ��
���Uso        � Especifico Steck                                             ���
�����������������������������������������������������������������������������ٱ�
��������������������������������������������������������������������������������
������������������������������������������������������������������������������*/

Static Function xC(nTam)
	Local nHRes	:=	oMainWnd:nClientWidth	//Resolucao horizontal do monitor
	Do Case
		Case nHRes == 640	//Resolucao 640x480
		nTam *= 0.8
		Case nHRes == 800	//Resolucao 800x600
		nTam *= 1
		OtherWise			//Resolucao 1024x768 e acima
		nTam *= 1.28
	EndCase
	If "MP8" $ oApp:cVersion
		//���������������������������Ŀ
		//�Tratamento para tema "Flat"�
		//�����������������������������
		If (Alltrim(GetTheme()) == "FLAT").Or. SetMdiChild()
			nTam *= 0.90
		EndIf
	EndIf
Return Int(nTam)

Static Function StMSg()
	Local _cText:= "Estimado cliente, Gracias por requerir nuestra cotizaci�n. Si desea realizar consultas acerca de este presupuesto, no dude en comunicarse con nosotros.-"+;
	" (La existencia/stock de los materiales cotizados, queda supeditado a su venta previa)"+;
	" Muchas gracias. Cordiales saludos.-"

Return  (alltrim(_cText))

User Function xMyRetCpo(cCampo,nPais)
Local cRet 		:= ""
Default nPais	:= 2

	SX3->(DbSetOrder(2))

	If SX3->(DbSeek(cCampo))
		
		Do Case 
			Case nPais = 1
				cRet := Alltrim((SX3->X3_TITULO))
			Case nPais = 2
				cRet := Alltrim((SX3->X3_TITSPA))
			Case nPais = 3
				cRet := Alltrim((SX3->X3_TITENG))
		EndCase 

	EndIf 

Return(cRet)