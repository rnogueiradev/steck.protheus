#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³STCADSZ3  ºAutor  ³Renato Nogueira     º Data ³  07/11/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Cadastrar representante x grupos - comissões			      º±±
±±º          ³ 						                 			          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function STCADSZ3()

	Local cST_USRCOMIS	:= SuperGetMV("ST_USRCOMIS",,"")
	Local aRotAdic		:= {}
	Local bNoTTS  		:= {||WFPOSALT(.F.)}    

	aadd(aRotAdic,{ "Copiar","U_STCOPSZ3", 0 , 10 })
	aadd(aRotAdic,{ "Importar","U_IMPSZ3CS", 0 , 10 })
	aadd(aRotAdic,{ "Recalculo","U_RECSZ3", 0 , 10 })

	If __cUserId $ cST_USRCOMIS

		Dbselectarea("SZ3")

		_cTitulo := "Cadastro de representante x grupo

		AxCadastro("SZ3",_cTitulo,,,aRotAdic,,bNoTTS,,)

	Else

		MsgAlert("Usuário sem permissão para utilizar essa rotina")

	EndIf

Return(.T.)

/*====================================================================================\
|Programa  | STCOPSZ3        | Autor | RENATO.OLIVEIRA           | Data | 18/07/2018  |
|=====================================================================================|
|Descrição | ROTINA PARA COPIAR CADASTRO EXISTENTE	                                  |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function STCOPSZ3()

	Local _aParamBox 	:= {}
	Local _aRet 		:= {}
	Local _cQuery1 		:= ""
	Local _cAlias1		:= GetNextAlias()

	AADD(_aParamBox,{1,"Copiar de" ,SZ3->Z3_VENDEDO,"@!","","",".F.",50,.T.})
	AADD(_aParamBox,{1,"Copiar para" ,Space(6),"@!","ExistCpo('SA3')","SA3",".T.",50,.T.})

	If ParamBox(_aParamBox,"Copiar comissões",@_aRet,,,.T.,,500)

		If !MsgYesNo("Confirma cópia dos registros do vendedor "+SZ3->Z3_VENDEDO+" para o vendedor "+MV_PAR02+"?")
			Return
		EndIf

		DbSelectArea("SA3")
		SA3->(DbSetOrder(1))
		SA3->(DbGoTop())
		If !SA3->(DbSeek(xFilial("SA3")+MV_PAR02))
			MsgAlert("Vendedor de destino não encontrado, verifique!")
			Return
		EndIf

		_aArea := GetArea()

		_cQuery1 := " SELECT *
		_cQuery1 += " FROM "+RetSqlName("SZ3")+" Z3
		_cQuery1 += " WHERE Z3.D_E_L_E_T_=' ' AND Z3_VENDEDO='"+MV_PAR01+"'

		If !Empty(Select(_cAlias1))
			DbSelectArea(_cAlias1)
			(_cAlias1)->(dbCloseArea())
		Endif

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),_cAlias1,.T.,.T.)

		dbSelectArea(_cAlias1)
		(_cAlias1)->(dbGoTop())

		SZ3->(DbSetOrder(1))

		While (_cAlias1)->(!Eof())

			SZ3->(DbGoTop())
			If SZ3->(DbSeek(xFilial("SZ3")+MV_PAR02+(_cAlias1)->Z3_GRUPO))

				M->Z3_FILIAL	:= SZ3->Z3_FILIAL
				M->Z3_VENDEDO	:= SZ3->Z3_VENDEDO
				M->Z3_NOMVEND	:= SZ3->Z3_NOMVEND
				M->Z3_GRUPO		:= SZ3->Z3_GRUPO
				M->Z3_NOMGRUP	:= SZ3->Z3_NOMGRUP
				M->Z3_COMIS		:= SZ3->Z3_COMIS
				M->Z3_USERLGI	:= SZ3->Z3_USERLGI
				M->Z3_USERLGA	:= SZ3->Z3_USERLGA
				M->Z3_LOG		:= SZ3->Z3_LOG

				SZ3->(RecLock("SZ3",.F.))
				SZ3->Z3_COMIS	:= (_cAlias1)->Z3_COMIS
				SZ3->(MsUnLock())

			Else

				M->Z3_FILIAL	:= SZ3->Z3_FILIAL
				M->Z3_VENDEDO	:= SZ3->Z3_VENDEDO
				M->Z3_NOMVEND	:= SZ3->Z3_NOMVEND
				M->Z3_GRUPO		:= SZ3->Z3_GRUPO
				M->Z3_NOMGRUP	:= SZ3->Z3_NOMGRUP
				M->Z3_COMIS		:= SZ3->Z3_COMIS
				M->Z3_USERLGI	:= SZ3->Z3_USERLGI
				M->Z3_USERLGA	:= SZ3->Z3_USERLGA
				M->Z3_LOG		:= SZ3->Z3_LOG

				SZ3->(RecLock("SZ3",.T.))
				SZ3->Z3_VENDEDO := MV_PAR02
				SZ3->Z3_NOMVEND	:= SA3->A3_NOME
				SZ3->Z3_GRUPO 	:= (_cAlias1)->Z3_GRUPO
				SZ3->Z3_NOMGRUP := (_cAlias1)->Z3_NOMGRUP
				SZ3->Z3_COMIS	:= (_cAlias1)->Z3_COMIS
				SZ3->(MsUnLock())

			EndIf

			WFPOSALT(.T.)

			(_cAlias1)->(DbSkip())
		EndDo		

		RestArea(_aArea)

		MsgAlert("Cópia efetuada com sucesso, obrigado!")

	EndIf

Return

/*====================================================================================\
|Programa  | WFPOSALT        | Autor | RENATO.OLIVEIRA           | Data | 18/07/2018  |
|=====================================================================================|
|Descrição |                                                                          |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

Static Function WFPOSALT(_lInverte)

	Local _lAlterado 	:= .F.
	Local _cAssunto	 	:= ""

	_cMsg := ""
	_cMsg += '<html>'
	_cMsg += '<head>'
	_cMsg += '<title>' +SM0->M0_NOME+"/"+SM0->M0_FILIAL+'</title>'
	_cMsg += '</head>'
	_cMsg += '<body>'
	_cMsg += "Comissão do vendedor "+AllTrim(SZ3->Z3_NOMVEND)+" grupo "+AllTrim(SZ3->Z3_NOMGRUP)+" foi alterada conforme abaixo:<br><br>"

	_cMsg	+= "Usuário: "+cUserName+"<br>"
	_cMsg	+= "Alterado em: "+DTOC(DDATABASE)+" "+TIME()+"<br><br>"

	_cMsg 	+= "<table border='1'><tr>
	_cMsg	+= "<td><b>Campo</b></td><td><b>Anterior</b></td><td><b>Novo</b></td></tr>

	DbSelectArea("SX3")
	SX3->(DbGoTop())
	SX3->(DbSetOrder(1))
	SX3->(DbSeek("SZ3"))

	While SX3->(!Eof()) .And. AllTrim(SX3->X3_ARQUIVO)=="SZ3"

		If !(M->(&(SX3->X3_CAMPO)) == &("SZ3->"+SX3->X3_CAMPO))

			_cMsg		+= "<tr>
			_cMsg		+= "<td>"+AllTrim(SX3->X3_TITULO)+"</td>

			DO CASE
				CASE AllTrim(SX3->X3_TIPO )=="C"
				If _lInverte
					_cMsg		+= "<td>"+M->(&(SX3->X3_CAMPO))+"</td><td>"+&("SZ3->"+SX3->X3_CAMPO)+"</td>"
				Else
					_cMsg		+= "<td>"+&("SZ3->"+SX3->X3_CAMPO)+"</td><td>"+M->(&(SX3->X3_CAMPO))+"</td>"
				EndIf
				CASE AllTrim(SX3->X3_TIPO )=="N"
				If _lInverte
					_cMsg		+= "<td>"+CVALTOCHAR(M->(&(SX3->X3_CAMPO)))+"</td><td>"+CVALTOCHAR(&("SZ3->"+SX3->X3_CAMPO))+"</td>"
				Else
					_cMsg		+= "<td>"+CVALTOCHAR(&("SZ3->"+SX3->X3_CAMPO))+"</td><td>"+CVALTOCHAR(M->(&(SX3->X3_CAMPO)))+"</td>"
				EndIf
				CASE AllTrim(SX3->X3_TIPO )=="D"
				If _lInverte
					_cMsg		+= "<td>"+DTOC(M->(&(SX3->X3_CAMPO)))+"</td><td>"+DTOC(&("SZ3->"+SX3->X3_CAMPO))+"</td>"
				Else
					_cMsg		+= "<td>"+DTOC(&("SZ3->"+SX3->X3_CAMPO))+"</td><td>"+DTOC(M->(&(SX3->X3_CAMPO)))+"</td>"
				EndIf
			ENDCASE

			_lAlterado	:= .T.
		EndIf

		SX3->(DbSkip())

	EndDo

	_cMsg += '</table>'
	_cMsg += '</body>'
	_cMsg += '</html>'

	If _lAlterado

		_cEmail   := SuperGetMv("ST_CADSZ31",.F.,"")
		_cCopia	  := ""
		_cAssunto := "[PROTHEUS] - Comissão Cadastrada"
		_aAttach  := {}
		_cCaminho := ""

		 U_STMAILTES(_cEmail, _cCopia, _cAssunto, _cMsg,_aAttach,_cCaminho)
		 

	EndIf

Return(.T.)


/*====================================================================================\
|Programa  | IMPSZ3CS        | Autor | ANTONIO CORDEIRO          | Data | 27/10/2023  |
|=====================================================================================|
|Descrição | ROTINA PARA IMPORTAR CSV PARA A SZ3                                      |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/

User Function IMPSZ3CS()

Processa({|| ValCsv() },"","Valida CSV..")

Return()

// Valida CSV. 

Static Function ValCsv() 



	Local cLinha  := ""
	Local lPrim   := .T.
	Local aCampos := {}
	Local aDados  := {}
	Local aProc   := {}
	Local lErro    :=.F.
	Local cErro    :=""
	Local nx     :=0
	Local lContinua:=.T.
    Private q      :=""
    Private z      :=""
    Private aErro  := {}
    Private cArquivo:=""
	Private nP       :=0
    Private cAltera:=""



	cArquivo := cGetFile("Arquivos CSV (*.CSV) |*.CSV*| ","Selecione o Arquivo",,,.T.,GETF_LOCALHARD+GETF_LOCALFLOPPY)
	cArquivo := AllTrim(cArquivo)


	If !File(cArquivo)
		MsgStop("O arquivo " +cArquivo+ " não foi encontrado. A importação será abortada!","[AEST901] - ATENCAO")
		Return()
	EndIf

    nP:=AT(',',cArquivo)
    cVarFile := cFileChgx:=1

    nP:=AT('.',cArquivo)

    _cArquivo:=substr(cArquivo,1,nP-1)+"_log"+Substr(cArquivo,nP,len(cArquivo)+4)
    _cArqProc:=substr(cArquivo,1,nP-1)+"_proc"+Substr(cArquivo,nP,len(cArquivo)+4)

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
            q+='Log Erro'+'";'
            q+=chr(13)+chr(10)
            fwrite(z,q,len(q))
		Else
			cErro:=""
			AADD(aDados,Separa(cLinha,";",.T.))
		   nx:=len(aDados)

	       aDados[nx,1] := PADL(AllTrim(aDados[nx,1]),TAMSX3("Z3_VENDEDO")[1],"0")
		    aDados[nx,3] := STRZERO(VAL(aDados[nx,3]),3)
          aDados[nx,5] := VAL(REPLACE(aDados[nx,5],',','.'))
			
         //Valida se o vendedor existe 
			SA3->(DBSETORDER(1))
			IF !SA3->(DBSEEK(XFILIAL('SA3')+aDados[nx,1]))
			   cErro+='Vendedor: '+aDados[nx,1]+' não localizado/ '
			ENDIF

         //Valida se o grupo existe. 
			SBM->(DBSETORDER(1))
			IF !SBM->(DBSEEK(XFILIAL('SBM')+aDados[nx,3]))
			   cErro+='Grupo: '+aDados[nx,3]+' não localizado: '
			ENDIF
			if !Empty(cErro)
			   lErro:=.T.
            GravaLog(aDados[nx,1],aDados[nx,3],SZ3->Z3_COMIS,cErro,aDados[nx,2],aDados[nx,4])
			else 
            //Valida se o registro ja existe e exibe alteração 
			   cAltera:=""
            SZ3->(DBSETORDER(1))
			   IF SZ3->(DBSEEK(XFILIAL('SZ3')+aDados[nx,1]+aDados[nx,3]))
               IF SZ3->Z3_COMIS==aDados[nx,5]
                  cAltera:='Mesmo valor: '+str(aDados[nx,5])
               ELSE 
                  cAltera:='Novo valor: '+str(aDados[nx,5])
                  aadd(aProc,{aDados[nx,1],aDados[nx,2],aDados[nx,3],aDados[nx,4],aDados[nx,5]})
               ENDIF   
               GravaLog(aDados[nx,1],aDados[nx,3],SZ3->Z3_COMIS,' - OK - '+cAltera,aDados[nx,2],aDados[nx,4])
			   ELSE 
               cAltera:='Registro Novo '
               GravaLog(aDados[nx,1],aDados[nx,3],aDados[nx,5],' - OK - '+cAltera,aDados[nx,2],aDados[nx,4])
               aadd(aProc,{aDados[nx,1],aDados[nx,2],aDados[nx,3],aDados[nx,4],aDados[nx,5]})
            ENDIF   
			endif   
		EndIf

		oFT:ft_fSkip()
	End While

    fclose(z)
    incproc("Abrindo os dados em Excel.....")

    If !ApOleClient( 'MsExcel' )
       MsgAlert( 'MsExcel não instalado')
	   Return
    else
	   oExcel1 := MsExcel():New()
	   oExcel1:WorkBooks:Open(alltrim(_cArquivo))
	   oExcel1:SetVisible(.T.)
    EndIf

    oFT:ft_fUse()

    if lErro
	   If Msgyesno('Houve erro na análise do CSV  - Continua ?...')
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
	      ImpSZ3(aProc)
	   ELSE 
          FWAlertSuccess('Sem dados para processar!! ')
	   ENDIF

	   //For i:=1 to Len(aDados)  //ler linhas da array
	   //Next i
	   FT_FUSE()
    ENDIF 

	FWAlertSuccess('Finalizado com Sucesso!! ')

Return()



Static Function ImpSZ3(aDados)

Processa({|| RunProc(aDados) },"","Atualizando Regisros")

Return()


Static Function RunProc(aDados1)

Local cFilAtu:=""
Local lRet   :=.F.
Local nx:=0



cFilAtu:=cFilAnt

//_cArqProc:=substr(cArquivo,1,nP-1)+"_proc"+Substr(cArquivo,nP,len(cArquivo)+4)
//z := fcreate(alltrim(_cArqProc))

ProcRegua(len(aDados1))

//Grava cabeçalho
//GravaProc('FILIAL','PEDIDO','MOTIVO','RESULTADO')

For nx:=1 to len(aDados1)

  IncProc('Processando Registros!!')
  
  //cFilAnt:=aDados1[nx,1]
  DbSelectArea("SZ3")
  SZ3->(DbSetOrder(1))
  IF SZ3->(dbseek(XFILIAL('SZ3')+aDados1[nx,1]+aDados1[nx,3]))
     SZ3->(RECLOCK('SZ3',.F.))
     SZ3->Z3_COMIS:=aDados1[nx,5]
     SZ3->(MSUNLOCK('SZ3'))
  ELSE 
     SZ3->(RECLOCK('SZ3',.T.))
     SZ3->Z3_VENDEDO:=aDados1[nx,1]
     SZ3->Z3_NOMVEND:=posicione("SA3",1,XFILIAL("SA3")+aDados1[nx,1],"A3_NOME")
     SZ3->Z3_GRUPO  :=aDados1[nx,3] 
     SZ3->Z3_NOMGRUP:=posicione("SBM",1,XFILIAL("SBM")+aDados1[nx,1],"BM_DESC")
     SZ3->Z3_COMIS  :=aDados1[nx,5]
     SZ3->(MSUNLOCK('SZ3'))
  ENDIF
Next 

Return(lRet)



Static Function GravaLog(cVend,cGrupo,nComis,cMotivo,cNome,cDesGru)

q := CHR(160)+cVend+';';fwrite(z,q,len(q))
q := CHR(160)+cNome+';';fwrite(z,q,len(q))
q := CHR(160)+cGrupo+';';fwrite(z,q,len(q))
q := CHR(160)+cDesGru+';';fwrite(z,q,len(q))
q := CHR(160)+str(nComis)+';';fwrite(z,q,len(q))
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



/*====================================================================================\
|Programa  | RECSZ3          | Autor | ANTONIO CORDEIRO          | Data | 27/10/2023  |
|=====================================================================================|
|Descrição | ROTINA PARA RECALCULAR COMISSÕES                                         |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/


User Function RECSZ3()


Processa({|| ProcRecSz3() },"","Recalculando Comissões !!!  ")

Return()


Static Function ProcRecSz3()

Local cAlias       :=""
Local nTotReg      :=0
Local cQuery       :=""

Private cPerg			:= "RECSZ3X1"
Private aPergunt	:= {}

cPerg		:= Padr(cPerg,Len(SX1->X1_GRUPO))

cPerg		:= Padr("STFAT702",Len(SX1->X1_GRUPO))
Aadd(aPergunt,{cPerg	,"01","Ped.Emissão De:","mv_ch1","D",08,00,"G","","mv_par01","","","","","","",""})
Aadd(aPergunt,{cPerg	,"02","Ped.Emissão Ate:","mv_ch2","D",08,00,"G","","mv_par02","","","","","","",""})
Aadd(aPergunt,{cPerg	,"03","Nf.Emissão De:","mv_ch3","D",08,00,"G","","mv_par03","","","","","","",""})
Aadd(aPergunt,{cPerg	,"04","Nf.Emissão Ate::","mv_ch4","D",08,00,"G","","mv_par04","","","","","","",""})

ValidSX1(aPergunt)

IF !Pergunte(cPerg,.t.)
   Return()
ENDIF

// Seleciona os pedidos para atualização da comissão. 
IF !Empty(MV_PAR01) .and. !Empty(MV_PAR02)
   cAlias  :=GetNextAlias()
   cQuery +=" SELECT SC6.R_E_C_N_O_ RECSC6 ,SC5.C5_VEND1 ,SC5.C5_VEND2 " +CRLF
   cQuery +=" FROM "+RetSqlName("SC5")+ " SC5 " +CRLF
   cQuery +=" INNER JOIN "+RetSqlName("SC6")+ " SC6 ON SC6.C6_FILIAL = SC5.C5_FILIAL AND SC6.C6_NUM = SC5.C5_NUM AND SC6.D_E_L_E_T_ = ' ' "+CRLF
   cQuery +=" WHERE SC5.C5_FILIAL = '"+XFILIAL('SC5')+"' " +CRLF
   cQuery +=" AND SC5.C5_EMISSAO  >= '"+DTOS(MV_PAR01)+"' " +CRLF
   cQuery +=" AND SC5.C5_EMISSAO  <= '"+DTOS(MV_PAR02)+"' " +CRLF
   cQuery +=" AND SC5.D_E_L_E_T_ = ' ' "  +CRLF
   DbUseArea(.T.,'TOPCONN',TCGENQRY(,,cQuery),cAlias,.T.,.T.)
   count to nTotReg
   ProcRegua( nTotReg )
   (cAlias)->(DBGOTOP())
   While ! (cAlias)->(EOF())
      IncProc('Processando Registros')
	  SC6->(dbGoto((cAlias)->RECSC6))
	  IF SC6->(RECNO())==(cAlias)->RECSC6 // Achou registro 
         IF ! Empty((cAlias)->C5_VEND1)
            SC6->(RECLOCK('SC6',.F.))
			SC6->C6_COMIS1 :=u_ValPorComiss(SC6->C6_PRODUTO,(cAlias)->C5_VEND1)
            SC6->C6_XVALCOM:=Round(((SC6->C6_VALOR*SC6->C6_COMIS1)/100),2)//atualiza a comissao por item   
			IF Alltrim((cAlias)->C5_VEND1) = Alltrim((cAlias)->C5_VEND2)
				SC6->C6_COMIS2:=0
			Else
				SC6->C6_COMIS2 :=Posicione("SA3",1,xFilial("SA3")+(cAlias)->C5_VEND2,"A3_COMIS")
		    EndIf
			SC6->(MSUNLOCK())

		    SD2->(DBSETORDER(8))
            IF SD2->(DBSEEK(XFILIAL('SD2')+SC6->C6_NUM+SC6->C6_ITEM))
			   SD2->(RECLOCK('SD2',.F.)) 
			   SD2->D2_COMIS1:=SC6->C6_COMIS1
			   SD2->D2_COMIS2:=SC6->C6_COMIS2
			   SD2->(MSUNLOCK())
			ENDIF   
		 ENDIF
	  ENDIF
	  (cAlias)->(DBSKIP())
   ENDDO	  
ENDIF   



IF !Empty(MV_PAR03) .and. !Empty(MV_PAR04)
   cAlias  :=GetNextAlias()
   cQuery :=" SELECT SD2.R_E_C_N_O_ RECSD2 ,SC5.C5_VEND1 ,SC5.C5_VEND2 " +CRLF
   cQuery +=" FROM "+RetSqlName("SF2")+ " SF2 " +CRLF
   cQuery +=" INNER JOIN "+RetSqlName("SD2")+ " SD2 ON SD2.D2_FILIAL = SF2.F2_FILIAL AND SD2.D2_DOC = SF2.F2_DOC AND SD2.D2_SERIE=SF2.F2_SERIE AND SD2.D2_CLIENTE = SF2.F2_CLIENTE AND SD2.D2_LOJA = SF2.F2_LOJA  AND SD2.D_E_L_E_T_ = ' ' "+CRLF
   cQuery +=" INNER JOIN "+RetSqlName("SC5")+ " SC5 ON SC5.C5_FILIAL = SD2.D2_FILIAL AND SD2.D2_PEDIDO = SC5.C5_NUM AND SC5.D_E_L_E_T_ = ' ' "+CRLF
   cQuery +=" WHERE SF2.F2_FILIAL = '"+XFILIAL('SC5')+"' " +CRLF
   cQuery +=" AND SF2.F2_EMISSAO  >= '"+DTOS(MV_PAR03)+"' " +CRLF
   cQuery +=" AND SF2.F2_EMISSAO  <= '"+DTOS(MV_PAR04)+"' " +CRLF
   cQuery +=" AND SF2.D_E_L_E_T_ = ' ' "  +CRLF
   DbUseArea(.T.,'TOPCONN',TCGENQRY(,,cQuery),cAlias,.T.,.T.)
   count to nTotReg
   ProcRegua( nTotReg )
   (cAlias)->(DBGOTOP())
   While ! (cAlias)->(EOF())
      IncProc('Processando Registros')
	  SD2->(dbGoto((cAlias)->RECSD2))
	  IF SD2->(RECNO())==(cAlias)->RECSD2 // Achou registro 
         IF ! Empty((cAlias)->C5_VEND1)
            SD2->(RECLOCK('SD2',.F.))
			SD2->D2_COMIS1 :=u_ValPorComiss(SD2->D2_COD,(cAlias)->C5_VEND1)
			IF Alltrim((cAlias)->C5_VEND1) = Alltrim((cAlias)->C5_VEND2)
				SD2->D2_COMIS2:=0
			Else
				SD2->D2_COMIS2 :=Posicione("SA3",1,xFilial("SA3")+(cAlias)->C5_VEND2,"A3_COMIS")
		    EndIf
		    SD2->(MSUNLOCK('SD2'))
			SC6->(DBSETORDER(1))
            IF SC6->(DBSEEK(XFILIAL('SC6')+SD2->D2_PEDIDO+SD2->D2_ITEMPV+SD2->D2_COD))
			   SC6->(RECLOCK('SC6',.F.)) 
			   SC6->C6_COMIS1:=SD2->D2_COMIS1
			   SC6->C6_COMIS2:=SD2->D2_COMIS2
			   SC6->(MSUNLOCK('SC6'))
			ENDIF   
		 ENDIF
	  ENDIF
	  (cAlias)->(DBSKIP())
   ENDDO	  
ENDIF   


//Como fica este trecho. 	
/*/
	If cFuncName = 'MT410TOK'
		
		If ( M->C5_XVALRA3+M->C5_XVALRA4+M->C5_XVALRA5 ) <> _nValComiss-M->C5_XVALRA1   .And.  (M->C5_XVALRA3+M->C5_XVALRA4+M->C5_XVALRA5) <> 0
			msginfo('Valor do Rateio Divergente do Valor da Comissão, Ajuste o Rateio!!!!!!!!!!!!!!!!')
			lRet:=.F.
		EndIf
		
		If M->C5_XTIPF <> '1' .And.  (M->C5_XVALRA3+M->C5_XVALRA4+M->C5_XVALRA5) <> 0
			MSGINFO('Rateio Disponivél Apenas Para Tipo de Fatura TOTAL')
			lRet:=.F.
		EndIf
		
	EndIf
/*/	
	
Return()




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ValidSX1 ºAutor  ³Bruno Daniel Borges º Data ³  22/06/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao que valida as perguntas do SX1 e cria os novos regis-º±±
±±º          ³tros                                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ T4F                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Valida as perguntas do usuario³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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












