#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "AP5MAIL.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ STQETXT  ºAutor  ³RVG Solcuoes        º Data ³  06/08/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function STQEIFT
Local aArea		:= GetArea()
Local aPC1Area	:= PC1->(GetArea())

If !Empty(QEK->QEK_XFATEC)
	
	PC1->(DbSetOrder(1)) //PC1_FILIAL+PC1_NUMERO+PC1_NOTAE+PC1_SERIEE
	If PC1->(DbSeek(xFilial("PC1")+substr(QEK->QEK_XFATEC,1,6)))
		
		cTexto := PC1->PC1_TXTOPF

		_IMPRIME()
		
	Endif 
	
Endif

RestArea(aPC1Area)
RestArea(aArea)

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ STFTR001 ³ Autor ³ RGV Solucoes          ³ Data ³14/Jul/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DAS FATECS                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico Steck                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static  Function _IMPRIME()


PRIVATE oPrint

oPrint:= TMSPrinter():New( "FATEC" )
oPrint:SetPortrait() // ou SetLandscape()

dbselectarea("SA1")
MsSeek(Xfilial("SA1")  + PC1->PC1_CODCLI + PC1->PC1_LOJA )

impress()

oPrint:Preview()     // Visualiza antes de imprimir

Return nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  Impress ³ Autor ³ RGV Solucoes          ³ Data ³07/Fev/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASER DO ITAU COM CODIGO DE BARRAS     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Impress()

LOCAL 	oBrush
LOCAL 	_nCount 

Private _nLin := 4000

aBmp := "STECK.BMP"

//Parâmetros de TFont.New()
//1.Nome da Fonte (Windows)
//3.Tamanho em Pixels
//5.Bold (T/F)
oFont2n := TFont():New("Times New Roman",,10,,.T.,,,,,.F. )
oFont8  := TFont():New("Arial",9,8 ,.T.,.F.,5,.T.,5,.T.,.F.)
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
oFont28 := TFont():New("Arial",9,28,.T.,.T.,5,.T.,5,.T.,.F.)

oBrush := TBrush():New("",4)

_ntotal 	:= 0
_ntotipi 	:= 0
_ntoticmsst := 0
_npagina 	:= 0
_aItRed		:= {}

if _nLin > 2600
	if _npagina <> 0 
		_npagina++
	    EndPage()
	Endif
	oPrint:StartPage()     // INICIALIZA a página
	_nLin := CabFatec()
endif
	
oPrint:Say  (_nLin,0100,"Observacoes"	 						,oFont13n )

cQuery	:=	" SELECT YP_TEXTO"
cQuery  +=	" FROM " + RetSqlName("SYP") + " YP "
cQuery	+=	" WHERE "
cQuery	+=	" YP_FILIAL = '"+xFilial("SYP")+"' "
cQuery	+=	" AND YP_CHAVE = '"+PC1->PC1_CODOBS+"' "
cQuery	+=	" AND YP_CAMPO = 'PC1_CODOBS' "
cQuery	+=	" AND YP.D_E_L_E_T_ <> '*' "
cQuery	+=	" ORDER BY YP_FILIAL,YP_CHAVE,YP_SEQ "
cQuery	:= ChangeQuery(cQuery)
DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TRB1', .F., .T.)
TRB1->(DbGotop())
While TRB1->(!Eof())
	oPrint:Say  (_nLin+=50,0100, TRB1->YP_TEXTO 									,oFont13n)
	
	if _nLin > 3000
		oPrint:Say  (3130,800, "* * *   C O N T I N U A    * * *",oFont16n)
		oPrint:EndPage()     // Finaliza a página
		CabFatec()
		oPrint:StartPage()     // INICIALIZA a página
	endif  
	
	TRB1->(DbSkip())
End

DbSelectArea("TRB1")
DbcloseArea()

oPrint:Line (_nLin+=60, 090,_nLin,2300)

oPrint:Say(_nLin+=10,0100,"Observacoes para Fatec"	 											,oFont13n )
_ctexto  := PC1->PC1_TXTOPF
_nlinhas := mlcount(_ctexto,80)

for _ncount:= 1 to _nlinhas
	
	_nlin+=60

	oPrint:Say  (_nlin ,0100, memoline(_ctexto,80,_ncount),oFont13N)

	if _nLin > 3000
		oPrint:Say  (3130,800, "* * *   C O N T I N U A    * * *",oFont16n)
		oPrint:EndPage()     // Finaliza a página
		CabFatec()
		oPrint:StartPage()     // INICIALIZA a página
	endif

next a    
_nlin+=60
_nini := _nlinhas := _nlin
oPrint:Line (_nlinhas, 090,_nlinhas,2300)
oPrint:Say(_nLin+10,0110,"Operador"	 			,oFont13n )
oPrint:Say(_nLin+10,0310,"Data"	 				,oFont13n )
oPrint:Say(_nLin+10,0510,"Hr.Inicio"	 			,oFont13n )
oPrint:Say(_nLin+10,0710,"Hr.Fim"	 				,oFont13n )
oPrint:Say(_nLin+10,0910,"Qtde OK"	 				,oFont13n )
oPrint:Say(_nLin+10,01110,"Qt.Refugo"	 		    ,oFont13n )
oPrint:Say(_nLin+10,01310,"Motivo"	 				,oFont13n )

oPrint:Line (_nlinhas+=60, 090,_nlinhas,2300)

Do While _nlinhas <= 2900 
     
 	_nlinhas+=60
     oPrint:Line (_nlinhas, 090,_nlinhas,2300)
Enddo

oPrint:Line (_nini, 300,_nlinhas,300)
oPrint:Line (_nini, 500,_nlinhas,500)
oPrint:Line (_nini, 700,_nlinhas,700)
oPrint:Line (_nini, 900,_nlinhas,900)
oPrint:Line (_nini, 1100,_nlinhas,1100)
oPrint:Line (_nini, 1300,_nlinhas,1300)

oPrint:Say(_nLinhas+10,0110,"Numero dos Lotes"	 				,oFont13n )

_nlinhas+=60
 oPrint:Line (_nlinhas, 090,_nlinhas,2300)
 oPrint:Line (_nlinhas+60, 090,_nlinhas+60,2300)
 oPrint:Line (_nlinhas+120, 090,_nlinhas+120,2300)

oPrint:Line (_nlinhas, 0450,_nlinhas+120,0450)
oPrint:Line (_nlinhas, 0800,_nlinhas+120,0800)
oPrint:Line (_nlinhas, 1150,_nlinhas+120,1150)
oPrint:Line (_nlinhas, 1500,_nlinhas+120,1500)
oPrint:Line (_nlinhas, 1850,_nlinhas+120,1850)
 
oPrint:EndPage()     // Finaliza a página

Return()




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CabFatec    ºAutor  ³ RGV Solucoes       º Data ³ 07/Fev/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function CabFatec
PRIVATE cNomeCom     := SM0->M0_NOMECOM
PRIVATE cEndereco    := SM0->M0_ENDENT
PRIVATE cCep         := SM0->M0_CEPENT
PRIVATE cCidade      := SM0->M0_CIDENT
PRIVATE cEstado      := SM0->M0_ESTENT
PRIVATE cCNPJ        := SM0->M0_CGC
PRIVATE cTelefone    := SM0->M0_TEL
PRIVATE cFax         := SM0->M0_FAX
PRIVATE cResponsavel := Alltrim(MV_PAR04)
PRIVATE cIe          := Alltrim(SM0->M0_INSC)

oPrint:box (0100  ,  0090 , 3150 ,2300 )

oPrint:Line (0350, 090,0350,2300)

If File(aBmp)
	oPrint:SayBitmap( 00120,0100,aBmp,0480,0140 )
EndIf

oPrint:Say  (0120,600,cNomeCom,oFont20 )
oPrint:Say  (0200,900,"F A T E C",oFont28 )

oPrint:Say  (0380,0100,"Cliente: "+ Capital(SA1->A1_NOME)											,oFont13n )
oPrint:Say  (0440,0100,"Cod.Cliente: "+ PC1->PC1_CODCLI +'-' +PC1->PC1_LOJA						,oFont13n )

oPrint:Line (0500, 090,0500,2300)

oPrint:Say  (0510,0100,"FATEC:   "  + QEK->QEK_XFATEC												,oFont13n )
oPrint:Say  (0510,0800,"Emissão: "	+ dtoc(PC1->PC1_DTOCOR)											,oFont13n )
oPrint:Say  (0570,0100,"Motivo:  "	+ PC1->PC1_MOTIVO +' - '+ ALLTRIM(POSICIONE("SX5",1,XFILIAL("SX5")+"SK" + PC1->PC1_MOTIVO,"X5DESCRI()"))  ,oFont13n )

oPrint:Line (630, 090,0630,2300) // Imprime Linha Fina
      
oPrint:Say  (0640,0100,"Produto: "	+ alltrim(QEK->QEK_PRODUT) +"-"+ ALLTRIM(Posicione('SB1',1,xFilial('SB1')+QEK->QEK_PRODUT,'B1_DESC'))											,oFont13n )
oPrint:Say  (0700,0100,"Nota Fsical: "	+ QEK->QEK_NTFISC											,oFont13n )
oPrint:Say  (0760,0100,"Lote: "	+ QEK->QEK_LOTE											,oFont13n )
oPrint:Say  (0820,0100,"Quantidade: "	+ QEK->QEK_TAMLOT 											,oFont13n )

oPrint:Line (900, 090,0900,2300) // Imprime Linha Fina
_nLin := 910

Return(_nLin)
 