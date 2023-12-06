#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"
#include "tbiconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � STTRIB01 �Autor  �Cristiano Pereira   � Data �  24/08/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �C�digo de tributa��o AM                                     ���
���          �                                                            ���
���          |                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���          �Especifico Steck Industria                                 ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
*/

User Function STTRIB01()

	Local aSays			:= {}
	Local aButtons 		:= {}
	Local nOpca 		:= 0
	Local cCadastro		:= " C�digo de tributa��o AM "

	AADD(aSays,"Classifica��o do c�digo de tributa��o AM ")
	AADD(aSays," ")
	AADD(aSays,"")
	AADD(aSays,"")
	AADD(aSays,"")
	AADD(aSays,"VERSAO 1.0 ")
	AADD(aSays,"Especifico Steck Industria")
	AADD(aButtons, { 1,.T.,{|o| nOpca:= 1,o:oWnd:End() } } )
	AADD(aButtons, { 2,.T.,{|o| o:oWnd:End() }} )

	FormBatch( cCadastro , aSays , aButtons )

	If nOpca==1 .And. Substr(cNumEmp,01,02)=="03"
		Processa( { || STTRI01A() } , "Processando Classifica��o de tributa��o Manaus..." )
        MsgInfo("Processamento finalizado com sucesso..","Aten��o")
    Else
        MsgInfo("Rotina dispon�vel somente para AM..","Aten��o")
	Endif




return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � STTRI01A �Autor  �Cristiano Pereira   � Data �  24/08/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Inicio do processamento                                     ���
���          �                                                            ���
���          |                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���          �Especifico Steck Industria                                  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
*/
Static Function STTRI01A()


	Local _cQryB5 := ""

	If Select ("TSB5") > 0
		dbSelectArea("TSB5")
		dbCloseArea()
	Endif


	_cQryB5 := " SELECT SB5.B5_FILIAL AS FILIAL,        "
	_cQryB5 += "        SB5.B5_COD    AS PRODUTO        "


	_cQryB5 += " FROM "+RetSqlName("SB5")+" SB5, "+RetSqlName("SB1")+" SB1 "

	_cQryB5 += " WHERE SB5.D_E_L_E_T_ <> '*'         AND "
	_cQryB5 += "       SB5.B5_CODTRAM ='    '        AND "
    _cQryB5 += "       SB5.B5_COD=SB1.B1_COD         AND "
    _cQryB5 += "       SB1.D_E_L_E_T_ <> '*'             "


	TCQUERY _cQryB5  NEW ALIAS "TSB5"


	_nRec := 0
	DbEval({|| _nRec++  })

	DbSelectArea("TSB5")
	DbGotop()

	While !TSB5->(EOF())
        
       DbSelectArea("SB5")
       DbSetOrder(1)
       If DbSeek(xFilial("SB5")+TSB5->PRODUTO)

	       DbSelectArea("SB1")
		   DbSetOrder(1)
		   If DbSeek(xFilial("SB1")+TSB5->PRODUTO)

		      If Rtrim(SB1->B1_TIPO)=="PA" .Or. Rtrim(SB1->B1_TIPO)=="PI"
                 If Reclock("SB5",.F.)
                       SB5->B5_CODTRAM:="N003" 
                    MsUnlock()
                 Endif 
			  Endif

			  If Rtrim(SB1->B1_TIPO)=="ME"
                 If Reclock("SB5",.F.)
                       SB5->B5_CODTRAM:="A012" 
                    MsUnlock()
                 Endif 
			  Endif

			Endif
       Endif

		DbSelectArea("TSB5")
		DbSkip()
	Enddo

 

return
