#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWMVCDEF.CH"

/*���������������������������������������������������������������������������
���Programa  � MA020ROT � Autor � Renato Oliveira      � Data �17/02/2020 ���
�������������������������������������������������������������������������͹��
���Desc.     � P.E. na rotina MATA020 (Cadastro de Fornecedores) para a   ���
���          � inclusao de novos itens no menu aRotina.                   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � SCHNEIDER                                                  ���
���������������������������������������������������������������������������*/

User Function MA020ROT()
Local aButtons := {}
aAdd(aButtons, { "Atualizar dados", "u_STREPSA2()", 0, 10 })

// Integracao Thomson
aAdd(aButtons, { "# Integ Thomson", "u_WsGnrc00('PKG_SFW_PARCEIRO.PRC_PARCEIRO',                       '13',                    'P',        'PRD',          2)"   , 0, 9, 0, .F. })
Return aButtons

/*���������������������������������������������������������������������������
���Programa  � STREPSA2 � Autor � Renato Oliveira      � Data �17/02/2020 ���
�������������������������������������������������������������������������͹��
���Desc.     � Atualizar dados fornecedor.                                ���
���          �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � SCHNEIDER                                                  ���
���������������������������������������������������������������������������*/

User Function STREPSA2()
FWExecView("Atualizar dados fornecedor","STCOM200", 4, Nil, { || .T. })
Return
