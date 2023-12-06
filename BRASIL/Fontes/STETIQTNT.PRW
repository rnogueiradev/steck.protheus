#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
 
#include "tbiconn.ch"
#include "ap5mail.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    STETIQTNT  บ Autor ณ Giovani.Zago       บ Data ณ  03/12/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ rGera etiqueta TNT                                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
*----------------------------------------*
User Function STETIQTNT(_cNote,_cSeriousPD2)  //u_stetiqtnt('000092001','001')
	*----------------------------------------*
	Local i := 0
	Private _xCodTran       := GetMv("ST_TRANTNT",,'000012')
	Private cPerg       	:= "TNT"
	Private cTime           := Time()
	Private cHora           := SUBSTR(cTime, 1, 2)
	Private cMinutos    	:= SUBSTR(cTime, 4, 2)
	Private cSegundos   	:= SUBSTR(cTime, 7, 2)
	Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos
	Private	nRotaEnt   		:= ""
	Private	nSgFilOrig 		:= ""
	Private	nClassif   		:= ""
	Private	nSequen    		:= ""
	
	dbSelectArea("SF2")
	
	SF2->(DbSetOrder(1))
	If SF2->(DbSeek( xFilial("SF2") + _cNote + _cSeriousPD2))
		If SF2->F2_TRANSP == _xCodTran
			StQuery( _cNote , _cSeriousPD2)
			dbSelectArea(cAliasLif)
			(cAliasLif)->(dbgotop())
			If  Select(cAliasLif) > 0
				
				While 	(cAliasLif)->(!Eof())
					
					If 	(cAliasLif)->F2_VOLUME1 > 0
						ImpBras()
					EndIf
					(cAliasLif)->(dbskip())
				End
			EndIf
		EndIf
	EndIf
	
Return



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    StQuery    บ Autor ณ Giovani.Zago       บ Data ณ  24/07/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Query seleciona notas de acordo com o numero do romaneio   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
*----------------------------------------*
Static Function StQuery( _cNote , _cSeriousPD2)
	*----------------------------------------*
	Local cQuery     := ' '
	
	cQuery := 'SELECT A1_NOME,A1_MUN    ,A1_EST ,A1_CGC   ,A1_CEP, A1_NREDUZ, F2_VOLUME1,  F2_DOC, F2_SERIE, D2_PEDIDO,  D2_ITEM, F2_TRANSP,  C5_ZENDENT , C5_ZBAIRRE  , C5_ZMUNE , C5_ZESTE , C5_ZCEPE , F2_TPFRETE
	cQuery += " FROM " + RetSQLName("SA1")+', '+ RetSQLName("SF2")+', '+ RetSQLName("SD2")+', '+ RetSQLName("SC5")
	cQuery += " WHERE F2_DOC = '" + _cNote + "'"
	cQuery += " AND F2_SERIE = '" + _cSeriousPD2 + "'"
	cQuery += " AND F2_CLIENTE = A1_COD"
	cQuery += " AND F2_LOJA = A1_LOJA"
	cQuery += " AND F2_DOC = D2_DOC"
	cQuery += " AND F2_SERIE = D2_SERIE"
	cQuery += " AND F2_FILIAL = '" + xFilial('SF2') + "'"
	cQuery += " AND D2_FILIAL = '" + xFilial('SD2') + "'"
	cQuery += " AND C5_FILIAL = '" + xFilial('SC5') + "'"
	cQuery += " AND F2_TRANSP  = '"+_xCodTran+"'"
	cQuery += " AND C5_NUM = D2_PEDIDO"
	cQuery += " AND D2_ITEM = '01'"
	cQuery += " AND " + RetSQLName("SA1")+".D_E_L_E_T_ <> '*'"
	cQuery += " AND " + RetSQLName("SF2")+".D_E_L_E_T_ <> '*'"
	cQuery += " AND " + RetSQLName("SD2")+".D_E_L_E_T_ <> '*'"
	cQuery += " AND " + RetSQLName("SC5")+".D_E_L_E_T_ <> '*'"
	cQuery += "ORDER BY F2_DOC, F2_SERIE"
	
	
	cQuery := ChangeQuery(cQuery)
	
	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf
	
	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)
	
Return()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ImpBras    บ Autor ณ Giovani.Zago       บ Data ณ  24/07/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ imprimi a etiqueta  da braspress                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
*-------------------------*
Static Function ImpBras()
	*-------------------------*
	Local cCmd
	Local cPortaImp := "LPT1"
	Local _cBarrasSt := ' '
	Local cPorta := "USB001"
	Local i := 0
	If   CB5SetImp('000012')
		
		
		
		For i:=1  To (cAliasLif)->F2_VOLUME1
			
			MSCBInfoEti("TNT","")
			MSCBBEGIN(1,6)
			//MSCBBOX(03,02,103,98,5)
			
			
			
			MSCBLineV(40,15,25,5)
			MSCBLineV(70,15,25,5)
			MSCBLineH(03,25,103,5,"B")
			
			MSCBBOX(03,16,10,19,20,"B")
			MSCBSAY(05,16.5,"NF:","N","0","020,013",.T.)
			MSCBSAY(05,19.5,   ALLTRIM(	(cAliasLif)->F2_DOC),"N","0","060,060")
			
			MSCBBOX(43,16,50,19,20,"B")
			MSCBSAY(45,16.5,"Ped:","N","0","020,013",.T.)
			MSCBSAY(50,20,   cvaltochar(	(cAliasLif)->D2_PEDIDO),"N","0","040,036")
			
			MSCBBOX(73,16,80,19,20,"B")
			MSCBSAY(75,16.5,"Vol:","N","0","020,013",.T.)
			MSCBSAY(80,20,   cvaltochar(i)+'/'+ cvaltochar(	(cAliasLif)->F2_VOLUME1),"N","0","040,036")
			
			
			//remetente
			MSCBLineH(03,33,103,5,"B")
			MSCBLineV(70,15,33,5)
			MSCBBOX(03,26,10,29,20,"B")
			MSCBSAY(05,26.5,"Rem:","N","0","020,013",.T.)
			MSCBSAY(05,29.5,   ALLTRIM(SM0->M0_NOMECOM),"N","0","035,026")
			
			//destinatario
			MSCBLineH(03,41,103,5,"B")
			MSCBLineV(70,15,41,5)
			MSCBBOX(03,34,10,37,20,"B")
			MSCBSAY(05,34.5,"Des:","N","0","020,013",.T.)
			MSCBSAY(05,37.5,   ALLTRIM(	(cAliasLif)->A1_NOME),"N","0","035,026")
			
			
			_cBarrasSt :=  SM0->M0_CGC+  substr(ALLTRIM( (cAliasLif)->F2_DOC),2,8)  + strzero(i,4)+ strzero((cAliasLif)->F2_VOLUME1,4)
			MSCBSAYBAR(05,52,_cBarrasSt   ,"N","MB07",26  ,.T.,.T.,.F.,"B",2,2,.F.)
			
			MSCBEND()
			
			
		Next i
		MSCBCLOSEPRINTER()
	EndIf
	
	
Return


*-------------------------*
User Function STCANAETI()   // U_STCANAETI()
	*-------------------------*
	 
	
	Local _cBarrasSt := ' '
	Local _cDesc	 := ' '
	Local cVendNew   :=  Space(15)
	
	
	PREPARE ENVIRONMENT EMPRESA '01' FILIAL '02'  TABLES "SB1"
	
	
	  _cBarrasSt := ' '
	  _cDesc	 := ' '
	  cVendNew   :=  Space(15)
	
	DEFINE MSDIALOG oDlgEmail TITLE OemToAnsi("Canaleta Etiqueta") From 1,0 To 16,25 OF oMainWnd
	
	@ 05,04 SAY "Codigo:" PIXEL OF oDlgEmail
	@ 15,04 MSGet cVendNew 	F3 'SB1'	  Size 70,012  PIXEL OF oDlgEmail Valid(  Empty(cVendNew) .Or. existcpo("SB1",cVendNew) )
	@ 35,04 SAY substr(Posicione("SB1",1,xFilial("SB1")+cVendNew,"B1_DESC"),1,30)  PIXEL OF oDlgEmail
	@ 55,04 SAY "Cod.Bar:  "+ Posicione("SB1",1,xFilial("SB1")+cVendNew,"B1_CODBAR")  PIXEL OF oDlgEmail
	
	@ 053+40, 05 Button "Ok"      Size 28,12 Action Eval({||nOpca:=1,oDlgEmail:End()})  Pixel
	@ 053+40, 67 Button "Cancela" Size 28,12 Action Eval({||nOpca:=2,oDlgEmail:End()})  Pixel
	
	
	nOpca:=0
	
	ACTIVATE MSDIALOG oDlgEmail CENTERED
	
	If nOpca == 1
		_cDesc	 := Alltrim(cVendNew)
		_cBarrasSt := Alltrim(Posicione("SB1",1,xFilial("SB1")+_cDesc,"B1_CODBAR"))
		
		If   CB5SetImp('000233')
			
			
			
			
			MSCBInfoEti("CAN","")
			MSCBBEGIN(1,6)
			//MSCBBOX(03,02,103,98,5)
			
			
			
			MSCBSAY(02,02,"STECK"  ,"B","0","020,20",.T.)
			MSCBSAY(06,02,_cDesc   ,"B","0","020,20",.T.)
			MSCBSAYBAR(02,10,_cBarrasSt   ,"B","MB04",4.5  ,.T.,.T.,.F.,"B",2,2,.F.)
			
			MSCBEND()
			
			
			
			MSCBCLOSEPRINTER()
			
			
		EndIf
			
		MSGINFO("IMPRIMIU")
	Endif
	
	
	
	
	
	
	
Return



