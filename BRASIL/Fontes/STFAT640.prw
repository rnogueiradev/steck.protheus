#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSTFAT640  บAutor  ณAntonio Cordeiro    บ Data ณ  08/11/23   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Importar CSV para atualizar vendedor ou nota fiscal        บฑฑ
ฑฑบ          ณ 						                 			          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function STFAT640()


Private cPerg			:= "STFAT640"
Private aPergunt	:= {}

If ! __cuserid $ GetMv("ST_ALTVENNF",,'001694/002030')
	MsgInfo("Usuario sem acesso nesta rotina ")
	Return()
EndIf


cPerg		:= Padr(cPerg,Len(SX1->X1_GRUPO))
cPerg		:= Padr("STFAT640",Len(SX1->X1_GRUPO))
Aadd(aPergunt,{cPerg	,"01","Importar CSV - Alt.Vendedor: ","mv_ch1","N",01,00,"C","","mv_par01","Pedido","Nota","","","","",""})

ValidSX1(aPergunt)

IF !Pergunte(cPerg,.t.)
   Return()
ELSE 
   U_FAT640CS()
ENDIF


Return(.T.)


/*====================================================================================\
|Programa  | FAT640CS     | Autor | ANTONIO CORDEIRO             | Data | 08/11/2023  |
|=====================================================================================|
|Descri็ใo | ROTINA PARA IMPORTAR CSV E ATUALIZAR CAMPOS C5_VEND1/F2_VEND1                                      |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Hist๓rico....................................|
\====================================================================================*/

User Function FAT640CS()

Processa({|| ValCsv() },"","Valida CSV..")

Return()

// Valida CSV. 

Static Function ValCsv() 

	Local cLinha     := ""
	Local lPrim      := .T.
	Local aCampos    := {}
	Local aDados     := {}
	Local aProc      := {}
	Local lErro      :=.F.
	Local cErro      :=""
	Local nx         :=0
	Local lContinua  :=.T.
    Local cVend      :=""
	Private q        :=""
    Private z        :=""
    Private aErro    := {}
    Private cArquivo :=""
	Private nP       :=0
    Private cAltera  :=""



	cArquivo := cGetFile("Arquivos CSV (*.CSV) |*.CSV*| ","Selecione o Arquivo",,,.T.,GETF_LOCALHARD+GETF_LOCALFLOPPY)
	cArquivo := AllTrim(cArquivo)


	If !File(cArquivo)
		MsgStop("O arquivo " +cArquivo+ " nใo foi encontrado. A importa็ใo serแ abortada!","[AEST901] - ATENCAO")
		Return()
	EndIf

    nP:=AT(',',cArquivo)
    cVarFile := cFileChgx:=1

    nP:=AT('.',cArquivo)

    _cArquivo:=substr(cArquivo,1,nP-1)+"_log"+Substr(cArquivo,nP,len(cArquivo)+4)

    z := fcreate(alltrim(_cArquivo))

	oFT   := fT():New()
	oFT:ft_fUse( cArquivo )

	_nX := 0

	FT_FUSE(cArquivo)
	ProcRegua(FT_FLASTREC()) 
	FT_FGOTOP()  

	While !( oFT:ft_fEof() )
		IncProc(' Validando Registros ...')
		_nX++
		cLinha := oFT:ft_fReadLn()

		If lPrim
			aCampos := Separa(cLinha,";",.T.)
			lPrim := .F.
            For nx:=1 to len(aCampos)
                q+=ALLTRIM(aCampos[nx])+'";'
            next 
            IF MV_PAR01==1
               q+='  '+'";'
			ENDIF
			q+='Log'+'";'
            q+=chr(13)+chr(10)
            fwrite(z,q,len(q))
		Else
			cErro:=""
			AADD(aDados,Separa(cLinha,";",.T.))
		    nx:=len(aDados)

	        aDados[nx,1] := PADL(AllTrim(aDados[nx,1]),TAMSX3("C5_FILIAL")[1],"0")
		    IF MV_PAR01==1 // Vendedor 
			   aDados[nx,2] := PADL(AllTrim(aDados[nx,2]),TAMSX3("C5_NUM")[1],"0")   // Pedido 
			   aDados[nx,3] := PADL(AllTrim(aDados[nx,3]),TAMSX3("C5_VEND1")[1],"0") // Vendedor 
			ELSE //  NOTA    
			   aDados[nx,2] := PADL(AllTrim(aDados[nx,2]),TAMSX3("F2_DOC")[1],"0")   
			   //aDados[nx,3] := PADL(AllTrim(aDados[nx,3]),TAMSX3("F2_SERIE")[1],"0")
               aDados[nx,4] := PADL(AllTrim(aDados[nx,4]),TAMSX3("F2_VEND1")[1],"0")
			ENDIF   
            //Valida chave 
			IF MV_PAR01==1
			   
			   SC5->(DBSETORDER(1))
			   IF !SC5->(DBSEEK(aDados[nx,1]+aDados[nx,2]))
			      cErro+='Pedido informado: '+aDados[nx,2]+' nใo localizado/ '
			   ELSE 
			      //Valida se esta totalmente faturado 
				  IF 'X' $ SC5->C5_NOTA // eliminado residuo 
				     cErro+='Pedido informado: '+aDados[nx,2]+' Residuo Eliminado / '
				  ELSEIF FatTot(SC5->C5_FILIAL,SC5->C5_NUM)
					 cErro+='Pedido informado: '+aDados[nx,2]+' Totalmente faturado - alterar via nota fiscal/ '
				  ELSE 
				     cVend:=SC5->C5_VEND1
				  ENDIF	 
			   ENDIF

			   SA3->(DBSETORDER(1))
			   IF !SA3->(DBSEEK(XFILIAL('SA3')+aDados[nx,3]))
			      cErro+=' / Vendedor informado: '+aDados[nx,3]+' nใo localizado/ '
			   ENDIF
            
			ELSE 

			   SF2->(DBSETORDER(1))
			   IF !SF2->(DBSEEK(aDados[nx,1]+aDados[nx,2]+aDados[nx,3]))
			      cErro+='Nota fiscal Informada: '+aDados[nx,2]+'/'+aDados[nx,3]+' nใo localizada/ '
			   ELSE 
			      cVend:=SF2->F2_VEND1
			   ENDIF

			   SA3->(DBSETORDER(1))
			   IF !SA3->(DBSEEK(XFILIAL('SA3')+aDados[nx,4]))
			      cErro+=' / Vendedor informado: '+aDados[nx,4]+' nใo localizado/ '
			   ENDIF

			ENDIF

			if !Empty(cErro)
			   lErro:=.T.
               IF MV_PAR01==1
			      GravaLog(aDados[nx,1],aDados[nx,2],aDados[nx,3],'',cErro)
			   ELSE 
                  GravaLog(aDados[nx,1],aDados[nx,2],aDados[nx,3],aDados[nx,4],cErro) 
			   ENDIF	  
			else 
			   cAltera:=""
			   IF MV_PAR01==1
			      IF cVend==aDados[nx,3]
				     cAltera:='Mesmo vendedor altera็ใo nใo necessแria "
				  ELSE 
				     cAltera:='Vendedor de: '+cVend+' Vendedor para: '+aDados[nx,3]
					 aadd(aProc,{aDados[nx,1],aDados[nx,2],aDados[nx,3],''})
			      ENDIF   
				  GravaLog(aDados[nx,1],aDados[nx,2],aDados[nx,3],'',cAltera)
			   ELSE 
			      IF cVend==aDados[nx,4]
				     cAltera:='Mesmo vendedor altera็ใo nใo necessแria "
				  ELSE 
				     cAltera:='Vendedor de: '+cVend+' Vendedor para: '+aDados[nx,4]
					 aadd(aProc,{aDados[nx,1],aDados[nx,2],aDados[nx,3],aDados[nx,4]})
			      ENDIF   
				  GravaLog(aDados[nx,1],aDados[nx,2],aDados[nx,3],aDados[nx,4],cAltera)
			   ENDIF	  
			endif   
		EndIf

		oFT:ft_fSkip()
	End While

    fclose(z)
    incproc("Abrindo os dados em Excel.....")

    If !ApOleClient( 'MsExcel' )
       MsgAlert( 'MsExcel nใo instalado')
	   Return
    else
	   oExcel1 := MsExcel():New()
	   oExcel1:WorkBooks:Open(alltrim(_cArquivo))
	   oExcel1:SetVisible(.T.)
    EndIf

    oFT:ft_fUse()

    if lErro
	   If Msgyesno('Houve erro na anแlise do CSV  - Continua ?...')
          lContinua:=.T.
	   ELSE 
	      lContinua:=.F.
	   ENDIF 
    ELSE 
	   If Msgyesno('CSV OK - Continua ?...')
          lContinua:=.T.
       ELSE 
	      lContinua:=.F.
	   ENDIF 
    ENDIF	   

 	IF lContinua    
	   oFT:ft_fUse()
       aSort(aProc, , , {|x,y| x[1]+x[2] < y[1]+y[2] } ) 
	   IF LEN(aProc)>0
	      AtuDados(aProc)
	   ELSE 
          FWAlertSuccess('Sem dados para processar!! ')
	   ENDIF

	   //For i:=1 to Len(aDados)  //ler linhas da array
	   //Next i
	   FT_FUSE()
    ENDIF 

	FWAlertSuccess('Finalizado com Sucesso!! ')

Return()



Static Function AtuDados(aDados)

Processa({|| RunProc(aDados) },"","Atualizando Regisros")

Return()


Static Function RunProc(aDados1)

Local cFilAtu:=""
Local lRet   :=.F.
Local nx:=0



cFilAtu:=cFilAnt


ProcRegua(len(aDados1))


IF MV_PAR01==1 // Atualiza Pedido 
   DbSelectArea("SC5")
   DBSETORDER(1)
ELSE 
   DbSelectArea("SC5")
   DBSETORDER(1)
ENDIF



For nx:=1 to len(aDados1)
  IncProc('Processando Registros!!')
  //cFilAnt:=aDados1[nx,1]
  IF MV_PAR01==1 // Atualiza Pedido 
     IF SC5->(DBSEEK(aDados1[nx,1]+aDados1[nx,2]))
        SC5->(RECLOCK('SC5',.F.))
        SC5->C5_VEND1:=aDados1[nx,3]
        SC5->(MSUNLOCK('SC5'))
     ENDIF
  ELSE 	 
     IF SF2->(DBSEEK(aDados1[nx,1]+aDados1[nx,2]+aDados1[nx,3]))
        SF2->(RECLOCK('SF2',.F.))
        SF2->F2_VEND1:=aDados1[nx,4]
        SF2->(MSUNLOCK('SF2'))
     ENDIF
  ENDIF

Next 

Return(lRet)

Static Function GravaLog(cCpo1,cCpo2,cCpo3,cCpo4,cMotivo)

q := CHR(160)+cCpo1+';';fwrite(z,q,len(q))
q := CHR(160)+cCpo2+';';fwrite(z,q,len(q))
q := CHR(160)+cCpo3+';';fwrite(z,q,len(q))
q := CHR(160)+cCpo4+';';fwrite(z,q,len(q))
q := CHR(160)+cMotivo+';';fwrite(z,q,len(q))  
q := chr(13)+chr(10);fwrite(z,q,len(q))
q:=''

Return()


Static Function GravaProc(cFil,cPed,cMotivo,cObs)

q := CHR(160)+cFil+';';fwrite(z,q,len(q))
q := CHR(160)+cPed+';';fwrite(z,q,len(q))
q := CHR(160)+cMotivo+';';fwrite(z,q,len(q))
q := CHR(160)+cObs+';';fwrite(z,q,len(q))  
q := chr(13)+chr(10);fwrite(z,q,len(q))
q:=''

Return()







/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ ValidSX1 บAutor  ณBruno Daniel Borges บ Data ณ  22/06/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao que valida as perguntas do SX1 e cria os novos regis-บฑฑ
ฑฑบ          ณtros                                                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ T4F                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ValidSX1(aPergunt)
Local aAreaBKP := GetArea()
Local cGrpPerg := ""
Local lTipLocl := .T.
Local i

dbSelectArea("SX1")
SX1->(dbSetOrder(1))
SX1->(dbGoTop())

If Len(aPergunt) <= 0
	Return(Nil)
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณValida as perguntas do usuarioณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cGrpPerg := aPergunt[1,1]
For i := 1 To Len(aPergunt)
	lTipLocl := !SX1->(dbSeek(cGrpPerg+aPergunt[i,2]))
	SX1->(RecLock("SX1",lTipLocl))
	SX1->X1_GRUPO		:= cGrpPerg
	SX1->X1_ORDEM		:= aPergunt[i,2]
	SX1->X1_PERGUNT		:= aPergunt[i,3]
	SX1->X1_PERSPA		:= aPergunt[i,3]
	SX1->X1_PERENG		:= aPergunt[i,3]
	SX1->X1_VARIAVL		:= aPergunt[i,4]
	SX1->X1_TIPO		:= aPergunt[i,5]
	SX1->X1_TAMANHO		:= aPergunt[i,6]
	SX1->X1_DECIMAL		:= aPergunt[i,7]
	SX1->X1_GSC			:= aPergunt[i,8]
	SX1->X1_VALID		:= aPergunt[i,09]
	SX1->X1_VAR01		:= aPergunt[i,10]
	SX1->X1_DEF01		:= aPergunt[i,11]
	SX1->X1_DEF02		:= aPergunt[i,12]
	SX1->X1_DEF03		:= aPergunt[i,13]
	SX1->X1_DEF04		:= aPergunt[i,14]
	SX1->X1_DEF05		:= aPergunt[i,15]
	SX1->X1_F3			:= aPergunt[i,16]
	SX1->X1_PICTURE		:= aPergunt[i,17]
	SX1->(MsUnlock())
Next i

RestArea(aAreaBKP)

Return(Nil)






/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ fattot บAutor   ณAntonio Cordeiro     บ Data ณ  22/06/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao para ver se o pedido esta totalmente faturado       -บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ T4F                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function FatTot(cFil,cNum)

Local lRet   :=.F.
Local cAlias :=""
Local cQuery :=""

cAlias := GetNextAlias()

 cQuery += " SELECT C6_NUM "
 cQuery += " FROM  "+RETSQLNAME('SC6')+" SC6 "
 cQuery += "  WHERE C6_FILIAL = '"+cFil+"' "
 cQuery += "    AND C6_NUM    = '"+cNum+"' " 
 cQuery += "    AND C6_BLQ <> 'R' "
 cQuery += "    AND C6_QTDENT < C6_QTDVEN "
 cQuery += "    AND SC6.D_E_L_E_T_ = '  ' "
 
 DbUseArea(.T.,'TOPCONN',TCGENQRY(,,cQuery),cAlias,.T.,.T.)
 IF (cAlias)->(Eof())
    lRet:=.T.
 ENDIF	

Return(lRet)






