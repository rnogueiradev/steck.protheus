#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "Fileio.ch"
#include "Totvs.ch"
#Include 'FwMVCDef.ch'

#Define CENVSRV   AllTrim(Upper(GetEnvServer()))
#define INCLUSAO 3
#define ALTERACAO 4


#xCommand @ <nRow>, <nCol> GET <uVar> ;
[ OBJECT <oGet> ];
[ <dlg: OF, WINDOW, DIALOG> <oWnd> ] ;
[ PICTURE <cPict> ] ;
[ VALID <ValidFunc> ] ;
[ F3 <cF3> ];
[ <color:COLOR,COLORS> <nClrFore> [,<nClrBack>] ] ;
[ SIZE <nWidth>, <nHeight> ]  ;
[ FONT <oFont> ] ;
[ <design: DESIGN> ] ;
[ CURSOR <oCursor> ] ;
[ <pixel: PIXEL> ] ;
[ MESSAGE <cMsg> ] ;
[ <update: UPDATE> ] ;
[ WHEN <uWhen> ] ;
[ <lCenter: CENTER, CENTERED> ] ;
[ <lRight: RIGHT> ] ;
[ ON CHANGE <uChange> ] ;
[ <readonly: READONLY, NO MODIFY> ] ;
[ <pass: PASSWORD> ] ;
[ <lNoBorder: NO BORDER, NOBORDER> ] ;
[ <help:HELPID, HELP ID> <nHelpId> ] ;
;
=> [ <oGet> := ] TGet():New( <nRow>, <nCol>, bSETGET(<uVar>), [<oWnd>], <nWidth>,;
<nHeight>, <cPict>, <{ValidFunc}>, <nClrFore>, <nClrBack>, <oFont>,;
<.design.>, <oCursor>, <.pixel.>, <cMsg>, <.update.>, <{uWhen}>,;
<.lCenter.>, <.lRight.>, [\{|nKey, nFlags, Self| <uChange>\}], <.readonly.>,;
<.pass.> , [<cF3>],<(uVar)>,,[<.lNoBorder.>], [<nHelpId>])

User Function STFAT701(lJob1)
/*/f/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
<Descricao> : Filtro principal do browse.
<Data> : 27/07/2023
<Parametros> : Nenhum
<Retorno> : Nenhum
<Processo> :
<Tipo> (Menu,Trigger,Validacao,Ponto de Entrada,Genericas,Especificas ) : M
<Autor> :Antonio Cordeiro de Moura
<Obs> :
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
*/

Local _cLockBy  := ""
Local cRet      := ""
Local cArqTemp  :=""

Private oBrowse      
Private cCadastro    := ""
Private cNomTmp      := ""
Private cAliasTmp    := ""
Private _aRotina     := {}
Private aCampos      := {}
Private cPerg			:= "STFAT701"
Private aPergunt	   := {}
Private aProc        :={}

Default lJob1        :=.F.

IF SELECT("SX2") == 0  .OR. lJob1 
   lJob1:=.T.
   RpcClearEnv()
   RpcSetType(3)
   RpcSetEnv("11","01",,,"FAT")	

   cArqTemp:=U_FAT701FIL(' ')
   IF SELECT(cArqTemp)>0
      dbSelectArea(cArqTemp)
      Dbgotop()
      While ! Eof()
         IF !EMPTY((cArqTemp)->C5_CLIENTE)
            cRet:=U_FAT701P((cArqTemp)->C5_CLIENTE,(cArqTemp)->C5_LOJACLI,(cArqTemp)->C5_VEND1,(cArqTemp)->C5_TRANSP,(cArqTemp)->C5_CONDPAG,(cArqTemp)->C5_FILIAL,.T.)
            IF !Empty(cRet)
               AADD(aProc,{(cArqTemp)->C5_FILIAL,(cArqTemp)->C5_CLIENTE,(cArqTemp)->C5_LOJACLI,(cArqTemp)->C5_VEND1,(cArqTemp)->C5_TRANSP,(cArqTemp)->C5_CONDPAG,(cArqTemp)->TOTAL,(cArqTemp)->TOTAL3,cRet})
            ENDIF 
            dbSelectArea(cArqTemp)
            (cArqTemp)->(DBSKIP())
         ENDIF   
      Enddo 
      dbSelectArea(cArqTemp)
      DBCLOSEAREA()
   ENDIF
   
   IF SELECT(cArqTemp)>0
      dbSelectArea(cArqTemp)
      DBCLOSEAREA()
   ENDIF      

   U_FAT701HTM(aProc) // Envia HTML caso tenha registros pendente. 
   
   Return()   
ENDIF      

oBrowse      := FWmBrowse():New()
cCadastro    := "Pedidos aptos a consolidaÁ„o"
cNomTmp      := ""
cAliasTmp    := GetNextAlias()
_aRotina     := MenuDef()
aCampos      := {}
cPerg			:= "STFAT701"
aPergunt	   := {}
aProc        :={}


cPerg		:= Padr("STFAT701",Len(SX1->X1_GRUPO))
Aadd(aPergunt,{cPerg	,"01","Cliente","mv_ch1","C",06,00,"G","","mv_par01","","","","","","SA1",""})
ValidSX1(aPergunt)

AADD(aCampos,{'Filial'     ,'C5_FILIAL'   ,'C','@!'         , ,02,0})
AADD(aCampos,{'Cod.Cliente','C5_CLIENTE'  ,'C','@!'         , ,06,0})
AADD(aCampos,{'Loja'       ,'C5_LOJACLI'  ,'C','@!'         , ,02,0})
AADD(aCampos,{'Nome'       ,'A1_NREDUZ'   ,'C','@!'         , ,40,0})
AADD(aCampos,{'Vendedor'   ,'C5_VEND1'    ,'C','@!'         , ,06,0})
AADD(aCampos,{'Transp'     ,'C5_TRANSP'   ,'C','@!'         , ,06,0})
AADD(aCampos,{'Cond.Pagto' ,'C5_CONDPAG'  ,'C','@!'         , ,03,0})
AADD(aCampos,{'xTipo'      ,'C5_XTIPO'    ,'C','@!'         , ,01,0})
AADD(aCampos,{'xTipf'      ,'C5_XTIPF'    ,'C','@!'         , ,01,0})
AADD(aCampos,{'Tot.Pedidos','TOTAL'       ,'N','@E 999'        ,0,8,0})
AADD(aCampos,{'Vl.Total'   ,'TOTAL3'      ,'N','@E 999,999,999.99',0,15,2})

if !Pergunte(cPerg,.t.)
   Return()
ENDIF   

MsgRun("Selecionando Registros...",,{|| AbreTMP() })

oBrowse:AddLegend("  TOTAL =2  " ,"GREEN"   ,"2 Pedidos")  //
oBrowse:AddLegend("  TOTAL >2 " ,"YELLOW"   ,"Mais q 2 pedidos ")  //
oBrowse:AddLegend(".T."         ,"White"  ,"Outros")

oBrowse:SetAlias(cAliasTmp)
oBrowse:SetDescription(cCadastro)
oBrowse:SetFields(aCampos)
oBrowse:SetSeek(.T.,NIL)

_cLockBy  := "STFAT701"

IF !LockByName(_cLockBy,.F.,.F.,.T.)
	MsgBox('Processa ja esta sendo executado em outra seÁ„o !!! ')
	RETURN()
ENDIF

oBrowse:Activate()

dbSelectArea(cAliasTmp)
dbCloseArea()
fErase(cNomTmp+GetDbExtension())
fErase(cNomTmp+OrdBagExt())

UnLockByName(_cLockBy,.F.,.F.,.T.)

Return nil



Static Function MenuDef()
Local _aRotina := {}

ADD OPTION _aRotina Title 'Filtrar'            Action 'U_FAT70101' OPERATION 3 ACCESS 0    //
ADD OPTION _aRotina Title 'Juntar Pedidos'     Action 'U_FAT70102' OPERATION 3 ACCESS 0    //
ADD OPTION _aRotina Title 'Processar Reservas' Action 'U_FAT70103' OPERATION 3 ACCESS 0    //
ADD OPTION _aRotina Title 'Legenda'            Action 'U_FAT70199' OPERATION 3 ACCESS 0   //


Return _aRotina



Static Function AbreTMP(nTipo)


/*/f/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
<Descricao> : Abertura do arquivo tempor·rio
<Data> : 21/03/2017
<Parametros> : aRotina
<Retorno> : Nenhum
<Processo> :
<Tipo> (Menu,Trigger,Validacao,Ponto de Entrada,Genericas,Especificas ) : E
<Autor> :Antonio Cordeiro Moura.
<Obs> :
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
*/

Local nValorMin := SuperGetMV("ST_VALMINA",.F.,300)
Local cArqsql   :=""

cCadastro    := "Pedidos aptos a AglutinaÁ„o"  //+iif(mv_par03==1,'008810','008850')
oBrowse:SetDescription(cCadastro)
oBrowse:Refresh(.T.)


If !Empty(cNomTmp)
	dbSelectArea(cAliasTmp)
	dbCloseArea()
	fErase(cNomTmp+GetDbExtension())
	fErase(cNomTmp+OrdBagExt())
Else
	cNomTmp := CriaTrab(,.F.)
Endif

cArqSql:=U_FAT701FIL(MV_PAR01)

dbSelectArea(cArqSql)
Dbgotop()
Copy to &cNomTmp
dbUseArea(.T.,,cNomTmp,cAliasTmp,.F.,.F.)
DbSelectArea(cAliasTmp)

Return()


/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥ ValidSX1 ∫Autor  ≥Bruno Daniel Borges ∫ Data ≥  22/06/05   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥Funcao que valida as perguntas do SX1 e cria os novos regis-∫±±
±±∫          ≥tros                                                        ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ T4F                                                        ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
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

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥Valida as perguntas do usuario≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
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



/*/f/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
<Descricao> : Filtro principal do browse.
<Data> : 21/03/2017
<Parametros> : Nenhum
<Retorno> : Nenhum
<Processo> :
<Tipo> (Menu,Trigger,Validacao,Ponto de Entrada,Genericas,Especificas ) : M
<Autor> :Antonio Cordeiro de Moura
<Obs> :
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
*/

User Function FAT70101()

if Pergunte(cPerg,.T.)
   MsgRun("Selecionando Registros...",,{|| AbreTMP() })
endif   


Return()


/*/f/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
<Descricao> : Alterar pedido e eliminar residuo na origem. 
<Data> : 21/03/2017
<Parametros> : Nenhum
<Retorno> : Nenhum
<Processo> :
<Tipo> (Menu,Trigger,Validacao,Ponto de Entrada,Genericas,Especificas ) : M
<Autor> :Antonio Cordeiro de Moura
<Obs> :
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
*/

User Function FAT70102()

cCliente:=(cAliasTmp)->C5_CLIENTE  
cLojaCli:=(cAliasTmp)->C5_LOJACLI 
cVend1  :=(cAliasTmp)->C5_VEND1
cTransp :=(cAliasTmp)->C5_TRANSP 
cCondPag:=(cAliasTmp)->C5_CONDPAG  
cFil1   :=(cAliasTmp)->C5_FILIAL

Processa({|| U_FAT701P(cCliente,cLojaCli,cVend1,cTransp,cCondPag,cFil1,.F.) },"","Processando Pedidos... Aguarde!!!")

Return()
                             
User Function FAT701P(_cCliente,_cLojaCli,_cVend1,_cTransp,_cCondPag,_cFil1,lJob)

Local NX        :=0
Local NY        :=0
Local cTipoCli  :=""
Local cNaturez  :=""
Local cOrdem    :=""
Local nMaxItem  :=""
Local lContinua :=.T.
Local aAreaSX3  :=SX3->(GETAREA())
Local _cErro    :=""

Private aItemNovo:={}
Private aCab     :={} 
Private aItens   :={}   
Private aTodos   :={}
Private aLinha   :={}
Private lMSErroAuto:=.F.
Private cCampos :=""
Private aCampos1 :={}
Private aOrdem   :={}
Private cMenNota :=""

cCampos:="/C6_ITEM/C6_PRODUTO/C6_QTDVEN/C6_QTDVEN/C6_QTDLIB/C6_UM/C6_PRUNIT/C6_PRCVEN/C6_LOCAL/C6_TES	/C6_OPER/C6_ENTREG/C6_NUM/C6_PEDCLI/C6_VALOR/C6_XORDEM/C6_ZENTRE2/C6_ENTRE1/C6_OP/C6_XOPER/C6_XDTINSE/C6_XPEDORI/C6_XITEORI/C6_NUMPCOM/C6_ITEMPC/"
SX3->(DBSETORDER(1))
IF SX3->(DBSEEK('SC6'))
   WHILE ! SX3->(EOF()) .AND. SX3->X3_ARQUIVO=='SC6'
      IF ALLTRIM(SX3->X3_CAMPO) $ cCampos 
          AADD(aCampos1,ALLTRIM(SX3->X3_CAMPO))
      ENDIF   
      SX3->(DBSKIP())  
     ENDDO
ENDIF  

   SA1->(DBSETORDER(1))
   IF SA1->(DBSEEK(XFILIAL('SA1')+_cCliente+_cLojaCli))
      cTipoCli:=SA1->A1_TIPO
      cNaturez:=SA1->A1_NATUREZ
   
      aItens:={}
      aTodos:={}
      cOrdem:=""
      aTodos:=U_BuscaItens(_cFil1,_cCliente,_cLojaCli,_cVend1,_cTransp,_cCondPag)
      
      aSort(aTodos  ,,, { |x,y| y[2] > x[2]} )

      IF LEN(aTodos)>0 
         cPed1:=aTodos[1,2]
      ELSE 
         IF !lJob
            MsgBox('Os Itens n„o foram selecionados')
         ENDIF   
         return()
      ENDIF    

      nMaxItem:=U_SC6PRI(cFilant,cPed1)  // Insere os itens do pedido principal. 

      // insere os outros itens. 
      FOR NX:=1 TO LEN(aTodos)
        IF aTodos[NX,2]<>cPed1
           aLinha := {}
           
           SC5->(DBSETORDER(1))
           DBSELECTAREA('SC6')
           DBGOTO(aTodos[NX,1])
           IF ! SC6->(EOF())
              FOR NY :=1 to len(aCampos1)
                  IF ALLTRIM(aCampos1[NY])=='C6_ITEM'
                     nMaxItem:=Soma1(nMaxItem)
                     AADD(aItemNovo,nMaxItem)
                     aAdd(aLinha, {aCampos1[NY],nMaxItem, nil})
                  ELSEIF ALLTRIM(aCampos1[NY])=='C6_XDTINSE'
                     aAdd(aLinha, {aCampos1[NY],dDatabase, nil})
                  ELSEIF ALLTRIM(aCampos1[NY])=='C6_XPEDORI'
                     aAdd(aLinha, {aCampos1[NY],SC6->C6_NUM, nil})
                  ELSEIF ALLTRIM(aCampos1[NY])=='C6_XITEORI'
                     aAdd(aLinha, {aCampos1[NY],SC6->C6_ITEM, nil})
                  ELSE 
                     aAdd(aLinha, {aCampos1[NY],&(aCampos1[NY]), nil})
                  ENDIF   
              NEXT 
              IF SC5->(DBSEEK(SC6->C6_FILIAL+SC6->C6_NUM))
                 nposx:=aScan(aOrdem,{|x| AllTrim(x[1]) == ALLTRIM(SC5->C5_XORDEM) })
                 IF nPosx==0
                    AADD(aOrdem,{ALLTRIM(SC5->C5_XORDEM),strzero(nx,2)})
                 ELSE 
                    aOrdem[nPosx,2]:=aOrdem[nPosx,2]+'/'+strzero(nx,2)
                 ENDIF   
              ENDIF
           ENDIF
           aAdd(aItens,aLinha)
         ENDIF
      NEXT 

      // Carregar cabeÁalho  
      DBSELECTAREA('SC5')
      SC5->(DBSETORDER(1))
      IF DBSEEK(XFILIAL('SC5')+cPed1)
         aCab:={}

         aAdd(aCab, {"C5_NUM"     , SC5->C5_NUM        , Nil})
         aAdd(aCab, {"C5_TIPO"    , SC5->C5_TIPO       , Nil})
         aAdd(aCab, {"C5_CLIENTE" , SC5->C5_CLIENTE    , Nil})
         aAdd(aCab, {"C5_LOJACLI" , SC5->C5_LOJACLI    , Nil})
         aAdd(aCab, {"C5_LOJAENT" , SC5->C5_LOJAENT    , Nil})
         aAdd(aCab, {"C5_CONDPAG" , SC5->C5_CONDPAG    , Nil})
         aAdd(aCab, {"C5_ZCONDPG" , SC5->C5_ZCONDPG    , Nil})
         aAdd(aCab, {"C5_XTIPO"   , SC5->C5_XTIPO      , Nil})
         aAdd(aCab, {"C5_XTIPF"   , SC5->C5_XTIPF      , Nil})

      ENDIF
   ENDIF  

   lContinua:=.T. 

   IF !lJob 
      lContinua:=Visualiza(aCab,aItens)
   ENDIF   

   IF !lContinua
      RestArea(aAreaSX3)   
      Return()
   ENDIF   
      
   
   Begin Transaction 
  
   //Antes de fazer a alteraÁ„o elimina residuo dos pedidos a serem inseridos. 
   IF lContinua 
      FOR NX:=1 TO LEN(aTodos)
        IF aTodos[NX,2]<>cPed1
           DBSELECTAREA('SC6')
           DBGOTO(aTodos[NX,1])
           IF ! SC6->(EOF())
              IF ! U_ST700RES(SC6->C6_FILIAL,SC6->C6_NUM,SC6->C6_ITEM)
                 DisarmTransaction()
                 lContinua:=.F. 
                 EXIT
              ELSE 
                 DBSELECTAREA('SC6')
                 DBGOTO(aTodos[NX,1])
                 IF ! SC6->(EOF())
                    SC6->(RECLOCK('SC6'),.F.)
                    SC6->C6_ZPEDDES:='Eliminado por aglutinaÁ„o inserido no pedido: '+cPed1
                    SC6->(MSUNLOCK('SC6'))
                 ENDIF 
              ENDIF
           ENDIF      
        ELSE 
           DBSELECTAREA('SC6')
           DBGOTO(aTodos[NX,1])
           IF ! SC6->(EOF())
              RECLOCK('SC6',.F.)
              SC6->C6_XDTINSE:=dDatabase 
              MSUNLOCK('SC6')
           ENDIF   
        ENDIF   
      NEXT 
   ENDIF   
   
   //Efetua a alteraÁ„o do pedido.    
   IF lContinua 
      lMSErroAuto:=.F.
      MSExecAuto({|x,y,z|Mata410(x,y,z)},aCab,aItens,4)
      If lMSErroAuto
         DisarmTransaction()
	      IF lJob
            _cErro := MostraErro("\arquivos\logs\","STFAT701.log")
            Conout(" Falha no execauto MATA410 alteraÁ„o pedido rotina STFAT701-AglutinaÁ„o via Job - Pedido: "+_cCliente)
         ELSE 
            MostraErro()
            Conout(" Falha no execauto MATA410 alteraÁ„o pedido rotina STFAT701-AglutinaÁ„o painel ")
         ENDIF
         lContinua:=.F.
      ELSE // Ajusta dados para faturamento. 
         cMenNota:=""
         SC5->(DBSETORDER(1))
         FOR NX:=1 to LEN(aOrdem)
            IF aOrdem[NX,1]<> '  '
               cMenNota+='O.C:'+aOrdem[NX,1]+' It:'+aOrdem[NX,2]+'/ '
            ENDIF   
         NEXT
         cMenNota:=Substr(cMenNota,1,Len(cMenNota)-2)
         IF SC5->(DBSEEK(XFILIAL('SC5')+cPed1))
            SC5->(RECLOCK('SC5'),.F.)
            SC5->C5_XBLQFMI :='N'
            SC5->C5_XTIPF   :='2'
            SC5->C5_ZMENAGL :=ALLTRIM(cMenNota)
            SC5->(MSUNLOCK('SC5'))
         ENDIF    
         U_STGrvSt(SC5->C5_NUM,SC5->C5_XTIPF=="2")
      ENDIF
   ENDIF   
   
   // Estorna e libera os itens que ja estava no pedido. 
   IF lContinua 
      FOR NX:=1 TO LEN(aTodos)
         DBSELECTAREA('SC6')
         IF aTodos[NX,2]==cPed1 // item ja existe no pedido. 
            DBGOTO(aTodos[NX,1])      
            IF ! SC6->(EOF())
               DBSELECTAREA('SC9')
               SC9->(DBSETORDER(1))
               IF SC9->(DbSeek(SC6->C6_FILIAL+SC6->C6_NUM+SC6->C6_ITEM))
                  While ! SC9->(EOF()) .AND. SC9->C9_FILIAL = SC6->C6_FILIAL .AND.;
                      SC9->C9_PEDIDO = SC6->C6_NUM  .AND. SC9->C9_ITEM = SC6->C6_ITEM 
                      a460Estorna()
                      SC9->(DBSKIP())
                  Enddo             
                  MaLibDoFat(SC6->(Recno()),(SC6->C6_QTDVEN-SC6->C6_QTDENT),.T.,.T.,.F.,.T.,.F.,.F.,Nil,Nil,Nil,Nil,Nil,Nil)
                  // Gera nova reserva 
                  DBSELECTAREA('SC6')
                  DBGOTO(aTodos[NX,1])      
                  IF ! SC6->(EOF())
                     U_STReserva(SC6->C6_NUM+SC6->C6_ITEM,SC6->C6_PRODUTO,SC6->C6_QTDVEN-SC6->C6_QTDENT,"+",cFilant)
                  ENDIF   
               ENDIF
            ENDIF
         ENDIF
      NEXT       
   ENDIF   

   //Estona os itens ja inseridos. 
   IF lContinua 
      DBSELECTAREA('SC6')
      DBSETORDER(1)
      FOR NX:=1 TO LEN(aItemNovo)
         IF DBSEEK(XFILIAL('SC6')+cPed1+aItemNovo[NX] )
            DBSELECTAREA('SC9')
            SC9->(DBSETORDER(1))
            IF SC9->(DbSeek(SC6->C6_FILIAL+SC6->C6_NUM+SC6->C6_ITEM))
               While ! SC9->(EOF()) .AND. SC9->C9_FILIAL = SC6->C6_FILIAL .AND.;
                   SC9->C9_PEDIDO = SC6->C6_NUM  .AND. SC9->C9_ITEM = SC6->C6_ITEM 
                   a460Estorna()
                   SC9->(DBSKIP())
               Enddo             
               MaLibDoFat(SC6->(Recno()),(SC6->C6_QTDVEN-SC6->C6_QTDENT),.T.,.T.,.F.,.T.,.F.,.F.,Nil,Nil,Nil,Nil,Nil,Nil)
               
               // Gera nova reserva 
               DBSELECTAREA('SC6')
               DBSETORDER(1)
               IF DBSEEK(XFILIAL('SC6')+cPed1+aItemNovo[NX] )
                  U_STReserva(SC6->C6_NUM+SC6->C6_ITEM,SC6->C6_PRODUTO,SC6->C6_QTDVEN-SC6->C6_QTDENT,"+",cFilant)
               ENDIF   
            ENDIF
            DBSELECTAREA('SC6')
            DBSETORDER(1)
         ENDIF
      NEXT 
   ENDIF   

   End Transaction 
   
   IF ! lJob
      IF lContinua
         MsgBox('Pedido:'+cPed1+' Atualizado com Sucesso','AtenÁ„o','Info')
      ELSE 
         MsgBox('Pedido:'+cPed1+' Processamento nao efetuado','AtenÁ„o','Info')
      ENDIF   
   ENDIF

   RestArea(aAreaSX3)

Return(_cErro)


User Function FAT70199()

Local aLegenda := {}
aAdd(aLegenda,{"BR_VERDE"     ,"Ate 2 Pedidos"})
aAdd(aLegenda,{"BR_AMARELO"  ,"Mais que 2 pedidos"})
BrwLegenda(cCadastro, "Legenda", aLegenda)

Return Nil


User Function BuscaItens(Filial,Cliente,Loja,Vendedor,Transp,Condpag)

Local cAlias1 := GetNextAlias()
Local aItens1 :={}
Local cQuery  :={}


cQuery := " SELECT SC6.R_E_C_N_O_ RECNO ,SC5.C5_NUM,SC5.C5_XORDEM "
cQuery += " FROM "+RetSqlName("SC6")+" SC6 " +CRLF
cQuery += " INNER JOIN "+RetSqlName("SC5")+" SC5 ON SC5.C5_FILIAL = SC6.C6_FILIAL AND SC5.C5_NUM = SC6.C6_NUM AND SC5.D_E_L_E_T_ = ' ' "+CRLF
cQuery += " AND SC5.C5_EMISSAO >= '"+dtos(ddatabase-180)+"' "+CRLF
cQuery += " AND SC5.C5_CLIENTE = '"+Cliente+"' "+CRLF
cQuery += " AND SC5.C5_LOJACLI = '"+Loja+"' "+CRLF
cQuery += " AND SC5.C5_VEND1   = '"+Vendedor+"' "+CRLF
cQuery += " AND SC5.C5_TRANSP  = '"+Transp+"' "+CRLF
cQuery += " AND SC5.C5_CONDPAG = '"+Condpag+"' "+CRLF
cQuery += " INNER JOIN "+RetSqlName("PA2")+" PA2 ON PA2.PA2_FILRES = SC6.C6_FILIAL AND PA2.PA2_DOC = SC6.C6_NUM||SC6.C6_ITEM AND PA2.PA2_CODPRO = SC6.C6_PRODUTO AND PA2.D_E_L_E_T_ = ' ' "+CRLF
cQuery += " AND PA2.PA2_QUANT >= (SC6.C6_QTDVEN-SC6.C6_QTDENT ) "+CRLF
cQuery += " WHERE SC6.C6_FILIAL = '"+Filial+"' "+CRLF
cQuery += "   AND SC6.C6_CLI = '"+Cliente+"' "
cQuery += "   AND SC6.C6_LOJA= '"+Loja+"' "
cQuery += "   AND SC6.C6_QTDVEN>SC6.C6_QTDENT  "+CRLF
//cQuery += "   AND SC6.C6_ZENTRE2 <= '"+dtos(ddatabase)+"' "+CRLF
cQuery += "   AND SC6.C6_BLQ <> 'R' "+CRLF
cQuery += "   AND SC6.D_E_L_E_T_ = ' ' "+CRLF

DbUseArea(.T.,'TOPCONN',TCGENQRY(,,cQuery),cAlias1,.T.,.T.)
DBSELECTAREA(cAlias1)
(cAlias1)->(DBGOTOP())

While (cAlias1)->( ! Eof())
   aAdd(aItens1,{(cAlias1)->RECNO,(cAlias1)->C5_NUM ,(cAlias1)->C5_XORDEM})
   (cAlias1)->(DBSKIP())
ENDDO 

IF SELECT(cAlias1)>0
   DBSELECTAREA(cAlias1)
   DBCLOSEAREA()
ENDIF 

Return(aItens1)




User Function SC6PRI(cFil,cPedido)

   Local nx      :=0
   Local aItens1 :={}
   Local nMaxItem:=""
   Local nPosx   :=0

   PA2->(DBSETORDER(4))

   DBSELECTAREA('SC6') 
   SC6->(DBSETORDER(1)) 
   IF SC6->(DBSEEK(cFil+cPedido))
      While ! SC6->(EOF()) .AND. ;
          SC6->C6_FILIAL = cFil .AND. ;
          SC6->C6_NUM    = cPedido 
          aItens1 := {}
          FOR NX :=1 to len(aCampos1)
             aAdd(aItens1, {aCampos1[NX],&(aCampos1[NX]), nil})
          NEXT 
          
          aAdd(aItens, aItens1)
          //IF SC6->C6_ZENTRE2<=dDataBase
             IF PA2->(DBSEEK(XFILIAL('PA2')+SC6->C6_FILIAL+SC6->C6_NUM+SC6->C6_ITEM))
                IF PA2->PA2_QUANT>0

                   nposx:=aScan(aItens[1],{|x| AllTrim(x[1]) == 'C6_XDTINSE'})
                   IF nPosx<>0 .and. len(aItens)>0
                      aitens[len(aItens),nPosx,2]:=dDatabase 
                   ENDIF    

                   nposx:=aScan(aItens[1],{|x| AllTrim(x[1]) == 'C6_XPEDORI'})
                   IF nPosx<>0 .and. len(aItens)>0
                      aitens[len(aItens),nPosx,2]:='AGLUTI'
                   ENDIF    

                ENDIF   
             ENDIF   
          //ENDIF             
          
          
          nMaxItem:=IIF(SC6->C6_ITEM>nMaxItem,SC6->C6_ITEM,nMaxItem)
          SC6->(DBSKIP())        
      ENDDO
   ENDIF       

Return(nMaxItem)




User Function ST700RES(cFil,cNum,cItem)

	Local lContinua	:= .T.   
   Local lvalido   := .T. 
	
   //Primeiro estona a liberaÁ„o do item. 
   SC9->(DBSETORDER(1))
   IF SC9->(DbSeek(cFil+cNum+cItem))
      While ! SC9->(EOF()) .AND. SC9->C9_FILIAL = cFil .AND.;
         SC9->C9_PEDIDO = cNum .and. SC9->C9_ITEM == cItem
         a460Estorna()
         SC9->(DBSKIP())    
      ENDDO
   ENDIF    

   DbSelectArea("SC5")
	SC5->(DbSetOrder(1))
	IF SC5->(DbSeek(cFil+cNum))
   		dbSelectArea("SC6")
		   dbSetOrder(1)
		   IF MsSeek(SC5->C5_FILIAL+SC5->C5_NUM+cItem)
				//Chamado 001591 - Gravar data da eliminaÁ„o de resÌduo
				SC6->(RecLock("SC6",.F.))
				SC6->C6_QTDEMP 	 := 0
				SC6->C6_XDTRES   := Date()
				SC6->C6_XUSRRES  := __cUserId
				SC6->(MsUnlock())
				SC6->(DbCommit())
				dbSelectArea("PA1")
				PA1->(DbSetOrder(3))
				If PA1->(DbSeek(xFilial('PA1')+SC6->C6_NUM+SC6->C6_ITEM))
					PA1->(RecLock('PA1',.F.))
					PA1->PA1_OBS:="ELIMINA«√O DE RESIDUO "+cUserName+' - '+__cuserId+' - '+dTOc(date())  +' - '+TIME()
					PA1->(DbDelete())
					PA1->(MsUnlock())
				EndIf
				dbSelectArea("PA2")
				PA2->(DbSetOrder(3))
				If PA2->(DbSeek(xFilial('PA2')+SC6->C6_NUM+SC6->C6_ITEM))
					PA2->(RecLock('PA2',.F.))
					PA2->PA2_OBS:="ELIMINA«√O DE RESIDUO "+cUserName+' - '+__cuserId+' - '+dTOc(date())  +' - '+TIME()
					PA2->(DbDelete())
					PA2->(MsUnlock())
    			EndIf


				IF SDC->(DBSEEK(XFILIAL("SDC")+SC6->C6_PRODUTO+SC6->C6_LOCAL+"SC6"+SC6->C6_NUM+SC6->C6_ITEM))
					SDC->(reclock("SDC", .F.))
    				SDC->( dbdelete() )
					SDC->( msunlock() )
						SBF->(DBSETORDER(1))
						IF SBF->(DBSSEK(XFILIAL("SBF")+SDC->DC_LOCAL+SDC->DC_LOCALIZ+SDC->DC_PRODUTO))
							SBF->(RECKLOCK("SBF",.F.))
								SBF->BF_EMPENHO := SBF->BF_EMPENHO - SDC->DC_QUANT
							SBF->(MSUNLOCK())
						ENDIF
            ENDIF 

		  	  lValido  := .T.
			  If lValido .And. !Empty(SC5->C5_PEDEXP) .And. SuperGetMv("MV_EECFAT") // Integracao SIGAEEC
			     If FindFunction("EECZERASALDO")
					  lValido := EECZeraSaldo(,SC5->C5_PEDEXP,,.T.,SC5->C5_NUM)
				  Else
					  lValido := EECCancelPed(,SC5->C5_PEDEXP,,.T.,SC5->C5_NUM)
				  EndIf
 				ENDIF
            If lValido .And. (SC6->C6_QTDVEN - SC6->C6_QTDENT) > 0
				   MaResDoFat(,.T.,.F.)
				EndIf
				SC6->(MaLiberOk({SC5->C5_NUM},.T.))
		   EndIf
   ENDIF      

Return(lContinua)


Static Function Visualiza(aCab2,aItens2)

Local lRet:=.F.

Local aListBox :={}
Local lOpcoes  := .T.
Local cCod     :="" 
Local cCliente :=""
Local cNome    :="" 
Local cLoja    :=""
Local cPedido  :=""
Local nOpc     :=0
Local nx       :=0
Local nH       :=0
Local oOK      := LoadBitmap(GetResources(),'br_verde')
Local oNO      := LoadBitmap(GetResources(),'br_amarelo')
Local nPos     :=0
Local aCampos5 :={} 
Local aDados   :={}
Local cDescri  :=""
Local cNota   :=""
Local nQtdEnt :=0
Local nReserva:=0 

nPos:=aScan(aCab2,{|x| AllTrim(x[1]) == 'C5_CLIENTE'})
cCod:=ACAB2[NPOS,2]

nPos:=aScan(aCab2,{|x| AllTrim(x[1]) == 'C5_LOJACLI'})
cLoja:=ACAB2[NPOS,2]
cNome:=Posicione("SA1",1,xFilial("SA1")+cCod+cLoja,"A1_NOME")
cCliente:=cCod+' - '+cLoja+' - '+cNome

nPos:=aScan(aCab2,{|x| AllTrim(x[1]) == 'C5_NUM'})
cPedido:=ACAB2[NPOS,2]

AADD(aCampos5,{'C6_ITEM','C6_PRODUTO','C6_QTDVEN','C6_XPEDORI','C6_XITEORI'})

FOR NX:=1 TO Len(aItens2)
   lOpcoes  := .T.
       aDados  :={}
       cDescri :=""
       nQtdEnt :=0
       cNota   :=''
       FOR NH:=1 TO LEN(aCampos5[1])
           nPos:=aScan(aItens2[NX],{|x| AllTrim(x[1]) == aCampos5[1,NH]})
           IF nPos<>0 
              AADD(aDados,aItens[NX,Npos,2])
           ELSE 
              IF NH=3 
                 AADD(aDados,0)
              ELSE
                 AADD(aDados,'NAO ACHOU')
              ENDIF   
           ENDIF   
        NEXT 
        cNota   :=""
        nQtdEnt :=0
        nReserva:=0
        cDescri:=Posicione("SB1",1,xFilial("SB1")+aDados[2],"B1_DESC")
        SC6->(DBSETORDER(1))
        IF !EMPTY(aDados[4]) .AND. ALLTRIM(aDados[4])<>'AGLUTI'
           lOpcoes:=.F.
           IF SC6->(DBSEEK(XFILIAL('SC6')+aDados[4]+aDados[5]))
              cNota  :=SC6->C6_NOTA 
              nQtdEnt:=SC6->C6_QTDENT 
              PA2->(DBSETORDER(3))
              IF PA2->(DBSEEK(XFILIAL('PA2')+aDados[4]+aDados[5]))
                 nReserva:=PA2->PA2_QUANT 
              ENDIF   
           ENDIF 
        ELSE 
           lOpcoes:=.T.
           IF SC6->(DBSEEK(XFILIAL('SC6')+cPedido+aDados[1])) 
              cNota  :=SC6->C6_NOTA 
              nQtdEnt:=SC6->C6_QTDENT 
              PA2->(DBSETORDER(3))
              IF PA2->(DBSEEK(XFILIAL('PA2')+cPedido+aDados[1]))
                 nReserva:=PA2->PA2_QUANT 
              ENDIF   
           ENDIF
        ENDIF
        IF nReserva >0
           AADD(aListBox,{lOpcoes,aDados[1],aDados[2],aDados[3],cDescri,aDados[4],aDados[5],nQtdEnt,nReserva,cNota})
        ENDIF   
NEXT    


//DEFINE MSDIALOG oDlg1 TITLE 'Pedido Consolidado' FROM  175,020 TO 500,650 PIXEL OF oMainWnd
DEFINE MSDIALOG oDlg1 TITLE 'Pedido Consolidado' FROM  000,020 TO 500,1300 PIXEL OF oMainWnd
@ 012,010 Say "Pedido:" SIZE 50,9 PIXEL
@ 010,040 MSGET oNomeCli Var cPedido OF oDlg1 PIXEL SIZE 50,9 WHEN .F.

@ 012,100 Say "Cliente:" SIZE 50,9 PIXEL
@ 010,140 MSGET oNomeCli Var cCliente OF oDlg1 PIXEL SIZE 200,9 WHEN .F.


IF LEN(aListBox)>0

     @ 025,004 LISTBOX oListBox VAR cVar FIELDS HEADER	" "			,;
     "Item.",;
     "Codigo",;
     "Qtd",;
     "DescriÁ„o",;
     "Ped. Origem",;
     "Item Origem",;
     "Entregue",;
     "Reservado",;
     "Nota" SIZE 600,200 PIXEL of oDlg1 ;  //450
     //ON dblClick (aListBox:=DesTroca(oListBox:nAt,aListBox),oListBox:Refresh())
     oListBox:SetArray(aListBox)
     oListBox:bLine:={|| {If(aListBox[oListBox:nAt,1],oOk,oNo)  ,;
     aListBox[oListBox:nAt,2],;
     aListBox[oListBox:nAt,3],;
     Transform(aListBox[oListBox:nAt,4], "@E 9,999"),;
	  aListBox[oListBox:nAt,5],;
     aListBox[oListBox:nAt,6],;
     aListBox[oListBox:nAt,7],;
     Transform(aListBox[oListBox:nAt,8], "@E 9,999"),;
     Transform(aListBox[oListBox:nAt,9], "@E 9,999"),;
     aListBox[oListBox:nAt,10]}}
     

     DEFINE SBUTTON FROM 230,400 TYPE 1 Action (nOpc:=1,oDlg1:End()) ENABLE OF oDlg1
     DEFINE SBUTTON FROM 230,360 TYPE 2 Action (nOpc:=0,oDlg1:End()) ENABLE OF oDlg1
     ACTIVATE MSDIALOG oDlg1 Centered 

     IF nOpc==1
        lRet:=.T.
     ELSE 
        lRet:=.F.   
     ENDIF   
ELSE 
   MsgBox('N„o existe dados para aglutinar','AtenÁ„o','Info')
ENDIF   

Return(lRet)



/*/f/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
<Descricao> : Processa as reservas 
<Data> : 21/03/2017
<Parametros> : Nenhum
<Retorno> : Nenhum
<Processo> :
<Tipo> (Menu,Trigger,Validacao,Ponto de Entrada,Genericas,Especificas ) : M
<Autor> :Antonio Cordeiro de Moura
<Obs> :
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
*/
User Function FAT70103()

If MsgYesno('Confirma o processamento das Reservas? ')
   Processa({|| RunCont1() },"","Processando as Reservas... Aguarde!!!")
ENDIF   

Return()
                             
Static Function RunCont1()

aEmpFil:={}
aadd(aEmpFil,'11')
aadd(aEmpFil,'01')

U_MSTECK16(aEmpFil)

Return()
          

/*/f/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
<Descricao> : Seleciona Pedidos para AglutinaÁ„o
<Data> : 01/08/2023
<Parametros> : Nenhum
<Retorno> : Nenhum
<Processo> :
<Tipo> (Menu,Trigger,Validacao,Ponto de Entrada,Genericas,Especificas ) : M
<Autor> :Antonio Cordeiro de Moura
<Obs> :
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
*/          
User Function FAT701FIL(cCliente)

Local cQuery:=""
Local nValorMin := SuperGetMV("ST_VALMINA",.F.,300)
Local cListaOper:= SuperGetMV("ST_OPERAGL",.F.,"('01')")

Default cCliente:=""

cQuery := " SELECT * FROM  ( "
cQuery += " SELECT C5_FILIAL,C5_CLIENTE,C5_LOJACLI,C5_VEND1,C5_TRANSP,C5_CONDPAG,C5_XTIPO,C5_XTIPF,A1_NREDUZ,COUNT(*) TOTAL,SUM(TOTAL2) TOTAL3 "
cQuery += " FROM ( " +CRLF
cQuery += " SELECT SC5.C5_FILIAL, SC5.C5_CLIENTE,SC5.C5_LOJACLI,SC5.C5_VEND1,SC5.C5_TRANSP,SC5.C5_NUM,SC5.C5_CONDPAG,SC5.C5_XTIPO,SC5.C5_XTIPF,SC5.C5_NATUREZ,SA1.A1_NREDUZ,SUM((SC6.C6_QTDVEN-SC6.C6_QTDENT)*SC6.C6_PRCVEN) TOTAL2 " +CRLF
cQuery += " FROM "+AllTrim(GetMv("STALIASDIS"))+"."+RetSqlName("SC6")+" SC6 " +CRLF
cQuery += " INNER JOIN "+AllTrim(GetMv("STALIASDIS"))+"."+RetSqlName("SC5")+" SC5 ON SC5.C5_FILIAL = SC6.C6_FILIAL AND SC5.C5_NUM = SC6.C6_NUM AND SC5.D_E_L_E_T_ = ' ' "+CRLF
cQuery += " AND SC5.C5_EMISSAO >= '"+dtos(ddatabase-180)+"' "

// N„o Aglutinar Pedidos com; Data Programada / Alerta de Faturamento / Bloqueio e Faturamento 
cQuery += " AND SC5.C5_XDTENPR= '        ' AND SC5.C5_XALERTF='          ' AND SC5.C5_ZREFNF= ' ' "+CRLF

//--NAO AGLUTINAR QUANDO C5_ZBLOQ = '1'. // Justificativa:  H· situaÁıes de bloqueio em que o pedido reserva o item.
cQuery += " AND SC5.C5_ZBLOQ <> '1' "+CRLF

//Justificativa:  Existem pedidos especÌficos (containers)  que nao podem ser aglutinados.
cQuery += " AND SC5.C5_XAGLUTI <> 'N' "+CRLF

cQuery += " INNER JOIN "+AllTrim(GetMv("STALIASDIS"))+"."+RetSqlName("PA2")+" PA2 ON PA2.PA2_FILRES = SC6.C6_FILIAL AND PA2.PA2_DOC = SC6.C6_NUM||SC6.C6_ITEM AND PA2.PA2_CODPRO = SC6.C6_PRODUTO AND PA2.D_E_L_E_T_ = ' ' "+CRLF
cQuery += " AND PA2.PA2_QUANT >= (SC6.C6_QTDVEN-SC6.C6_QTDENT ) "+CRLF
cQuery += " INNER JOIN "+AllTrim(GetMv("STALIASDIS"))+"."+RetSqlName("SA1")+" SA1 ON SC5.C5_CLIENTE = SA1.A1_COD AND sc5.c5_lojacli = SA1.A1_LOJA AND SA1.D_E_L_E_T_ = ' ' "+CRLF
cQuery += " AND SA1.A1_XAGLUTI='S' "+CRLF
cQuery += " WHERE SC6.C6_FILIAL = '"+XFILIAL('SC6')+"' "
//cQuery += " AND SC6.C6_ZENTRE2 <= '"+dtos(ddatabase)+"' "+CRLF
cQuery += " AND SC6.C6_QTDVEN>SC6.C6_QTDENT "+CRLF
cQuery += " AND SC6.C6_BLQ <>'R' "+CRLF

// Aglutinar pedidos somente se o tipo de operaÁ„o estiver na lista abaixo par‚metro ST_OPERAGL
cQuery += " AND SC6.C6_OPER IN "+cListaOper
cQuery += " AND SC6.D_E_L_E_T_ = ' '  "+CRLF
IF !EMPTY(cCliente)
   cQuery += "   AND SC6.C6_CLI = '"+cCliente+"' "
ENDIF
cQuery += " GROUP BY  C5_FILIAL,C5_CLIENTE,C5_LOJACLI,C5_VEND1,C5_TRANSP,SC5.C5_NUM,SC5.C5_CONDPAG,SC5.C5_XTIPO,SC5.C5_XTIPF,SC5.C5_NATUREZ,SA1.A1_NREDUZ "+CRLF
cQuery += " ) "+CRLF
cQuery += " WHERE TOTAL2>0 "
cQuery += " GROUP BY C5_FILIAL,C5_CLIENTE,C5_LOJACLI,C5_VEND1,C5_TRANSP,C5_CONDPAG,C5_XTIPO,C5_XTIPF,A1_NREDUZ ) "+CRLF
cQuery += " WHERE TOTAL>1 AND TOTAL3 > '"+ALLTRIM(STR(nValorMin))+"' "
cQuery += " ORDER BY C5_FILIAL,A1_NREDUZ "
cArqSql := GetNextAlias()
dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),cArqSql, .T., .T.)

Return(cArqSql)




/*/f/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
<Descricao> : Gerar HTM com os itens pendente de aglutinaÁ„o. 
<Data> : 31/08/2023
<Parametros> : Nenhum
<Retorno> : Nenhum
<Processo> :
<Tipo> (Menu,Trigger,Validacao,Ponto de Entrada,Genericas,Especificas ) : M
<Autor> :Antonio Cordeiro de Moura
<Obs> :
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
*/

User Function FAT701HTM(aProc1)

LOCAL cArqTp:=""
LOCAL cMsg  :=""
LOCAL cMailTo := SuperGetMv("ST_MAILAGL",.f.,'')
LOCAL cCopia  := ""
LOCAL cAssun  := "Erro na AglutinaÁ„o nos pedidos"
LOCAL cAnexo  := ""
Local cNomeCli:=""
Local NX      :=0


cMsg := "<HTML> "
cMsg += "<HEAD> "
cMsg += "<TITLE> "
cMsg += " <img src='https://steck.com.br/assets/site/images/logo-steck.jpg?version=1.0.42' width='300' height='49'> </td> "
cMsg += "</TITLE> "
cMsg += "</HEAD> "
cMsg += " <br> <br>"

cMsg += " <table width='1000' border='2'> "
cMsg += " <tr> "
cMsg += " <td><div align='center'><font face='Verdana' size='1'><B>Lista dos Pedidos com erro na aglutinaÁ„o</B></font></div></td> "
cMsg += " </tr> "
cMsg += " </table> "

//// Itens do Pedido de Venda
cMsg += " <table width='1000' border='2' cellspacing='0' cellpadding='0'> "
cMsg += "   <tr> "
cMsg += "    <td><div align='left'><font face='Verdana' size='1'>Filial</font></div></td> "
cMsg += "    <td><div align='left'><font face='Verdana' size='1'>Cliente</font></div></td> "
cMsg += "    <td><div align='left'><font face='Verdana' size='1'>Loja</font></div></td> "
cMsg += "    <td><div align='left'><font face='Verdana' size='1'>Nome</font></div></td> "
cMsg += "    <td><div align='left'><font face='Verdana' size='1'>Vendedor</font></div></td> "
cMsg += "    <td><div align='left'><font face='Verdana' size='1'>Transp</font></div></td> "
cMsg += "    <td><div align='left'><font face='Verdana' size='1'>Cond.Pagto</font></div></td> "
cMsg += "    <td><div align='left'><font face='Verdana' size='1'>Tot.Pedidos</font></div></td> "
cMsg += "    <td><div align='left'><font face='Verdana' size='1'>Vl.Total</font></div></td> "
cMsg += "    <td><div align='left'><font face='Verdana' size='1'>Erro</font></div></td> "
cMsg += "   </tr> "

IF LEN(aProc1)>0
   FOR NX:=1 TO LEN(aProc1)
      SA1->(DBSETORDER(1))
      IF SA1->(DBSEEK(XFILIAL('SA1')+aProc[NX,2]+aProc[NX,3]))
         cNomeCli:=SA1->A1_NREDUZ 
      ELSE 
         cNomeCli:=""
      ENDIF   
      cMsg += "   <tr> "

      cMsg += "    <td><div align='left'><font face='Verdana' size='1'>"+aProc[NX,1]+"</font></div></td> "
      cMsg += "    <td><div align='left'><font face='Verdana' size='1'>"+aProc[NX,2]+"</font></div></td> "
      cMsg += "    <td><div align='left'><font face='Verdana' size='1'>"+aProc[NX,3]+"</font></div></td> "
      cMsg += "    <td><div align='left'><font face='Verdana' size='1'>"+cNomeCli+"</font></div></td> "
      cMsg += "    <td><div align='left'><font face='Verdana' size='1'>"+aProc[NX,4]+"</font></div></td> "
      cMsg += "    <td><div align='left'><font face='Verdana' size='1'>"+aProc[NX,5]+"</font></div></td> "
      cMsg += "    <td><div align='left'><font face='Verdana' size='1'>"+aProc[NX,6]+"</font></div></td> "
      cMsg += "    <td><div align='left'><font face='Verdana' size='1'>"+ALLTRIM(STR(aProc[NX,7],8))+"</font></div></td> "
      cMsg += "    <td><div align='left'><font face='Verdana' size='1'>"+ALLTRIM(STR(aProc[NX,8],12,2))+"</font></div></td> "
      cMsg += "    <td><div align='left'><font face='Verdana' size='1'>"+aProc[NX,9]+"</font></div></td> "
      cMsg += "   </tr> "

   NEXT 
   cMsg += " </table> "
   cMsg += " <br> <br> "
   cMsg += "STFAT701.PRW"
   cMsg += "</HTML> "
   U_STMAILTES(cMailTo, cCopia, cAssun, cMsg, cAnexo)
ENDIF

Return()


