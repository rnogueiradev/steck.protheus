#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "TOPCONN.CH"

/*====================================================================================\
|Programa  | STIMP110        | Autor | RENATO.OLIVEIRA           | Data | 17/06/2022  |
|=====================================================================================|
|Descri��o | 													                      |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | 		                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Hist�rico....................................|
\====================================================================================*/

User Function STIMP110()

	Local _aDados := {}
	Local _nX
	Local cCodEan    := "789"
	Local cCodEmp    := ""
	Local cSequen    := ""
	Local cCodBar    := " "
	Local cNewCodBar := " "
	Private cArquivo := ""

	RpcSetType( 3 )
	RpcSetEnv("11","01",,,"FAT")

	cCodEmp    := GetMv("MV_XCODEMP")
	cSequen    := GetMv("MV_XSEQBAR")// Sequencial utilizado na geracao do  codigo de barras

	AADD(_aDados,'SN3005')
	AADD(_aDados,'SN3007')
	AADD(_aDados,'S3504B')
	AADD(_aDados,'SN3504')
	AADD(_aDados,'S3504DJ')
	AADD(_aDados,'SN4604')
	AADD(_aDados,'S4804')
	AADD(_aDados,'SN4804')
	AADD(_aDados,'SN5002')
	AADD(_aDados,'SN4805')
	AADD(_aDados,'SN5004')
	AADD(_aDados,'SN5202')
	AADD(_aDados,'SN5502')
	AADD(_aDados,'SN5504')
	AADD(_aDados,'S3244T')
	AADD(_aDados,'SN3245')
	AADD(_aDados,'SN4542')
	AADD(_aDados,'S3842')
	AADD(_aDados,'SN4642')
	AADD(_aDados,'SN4845')
	AADD(_aDados,'SN5042')
	AADD(_aDados,'SN5044')
	AADD(_aDados,'SN5045')
	AADD(_aDados,'SN4842')
	AADD(_aDados,'S4844')
	AADD(_aDados,'SN4844')
	AADD(_aDados,'SN5542')
	AADD(_aDados,'SN5544')
	AADD(_aDados,'SN5642')
	AADD(_aDados,'S5844')
	AADD(_aDados,'SN5644')
	AADD(_aDados,'SN5645')
	AADD(_aDados,'SN5242')
	AADD(_aDados,'SN5244')
	AADD(_aDados,'S4056BM')
	AADD(_aDados,'S3856')
	AADD(_aDados,'S3859')
	AADD(_aDados,'SN5656')
	AADD(_aDados,'SN5659')
	AADD(_aDados,'S4854')
	AADD(_aDados,'S5257')
	AADD(_aDados,'SN4856')
	AADD(_aDados,'SN5654')
	AADD(_aDados,'SN3876')
	AADD(_aDados,'SN4572')
	AADD(_aDados,'SN4076BM')
	AADD(_aDados,'S3874')
	AADD(_aDados,'SN4874')
	AADD(_aDados,'S4874')
	AADD(_aDados,'SN4672')
	AADD(_aDados,'S4677')
	AADD(_aDados,'SN5674')
	AADD(_aDados,'SN5272')
	AADD(_aDados,'SN5572')
	AADD(_aDados,'SN5574')
	AADD(_aDados,'SN5672')
	AADD(_aDados,'S5277')
	AADD(_aDados,'S5874')
	AADD(_aDados,'S5875')
	AADD(_aDados,'S3809B')
	AADD(_aDados,'S3007W')
	AADD(_aDados,'S3602W')
	AADD(_aDados,'S4804W')
	AADD(_aDados,'S4809B')
	AADD(_aDados,'SS5006DR')
	AADD(_aDados,'S3532W')
	AADD(_aDados,'S4632W')
	AADD(_aDados,'S3642W')
	AADD(_aDados,'S3035W')
	AADD(_aDados,'S3539W')
	AADD(_aDados,'S4232W')
	AADD(_aDados,'S4835W')
	AADD(_aDados,'S3632W')
	AADD(_aDados,'S3232W')
	AADD(_aDados,'S3639W')
	AADD(_aDados,'S4532W')
	AADD(_aDados,'S3235W')
	AADD(_aDados,'SN4249W')
	AADD(_aDados,'S3672W')
	AADD(_aDados,'S4652')
	AADD(_aDados,'SN5045W')
	AADD(_aDados,'S4844W')
	AADD(_aDados,'S4854W')
	AADD(_aDados,'S3077W')
	AADD(_aDados,'S3652W')
	AADD(_aDados,'S4872W')
	AADD(_aDados,'S4874W')
	AADD(_aDados,'TU450V')
	AADD(_aDados,'TU2100V')
	AADD(_aDados,'TU250V')
	AADD(_aDados,'S4509DJ2')
	AADD(_aDados,'S4506D59')
	AADD(_aDados,'S4279BM')
	AADD(_aDados,'SS4006DR')
	AADD(_aDados,'S18120841')
	AADD(_aDados,'S18240050')
	AADD(_aDados,'S188P0108')
	AADD(_aDados,'S188P0111')
	AADD(_aDados,'S4053166')
	AADD(_aDados,'S4005620')
	AADD(_aDados,'S4005621')
	AADD(_aDados,'S63300007')
	AADD(_aDados,'S4805B')
	AADD(_aDados,'S4243WNQ')
	AADD(_aDados,'S4207W')
	AADD(_aDados,'S4975W')
	AADD(_aDados,'S3006BM')
	AADD(_aDados,'S3072WNQ')
	AADD(_aDados,'S3002WNQ')
	AADD(_aDados,'S4971WNQ')
	AADD(_aDados,'S4951WNQ')
	AADD(_aDados,'S4205WNQ')
	AADD(_aDados,'S4275WNQ')
	AADD(_aDados,'S31000500')
	AADD(_aDados,'S3246WNQ')
	AADD(_aDados,'S5806')
	AADD(_aDados,'SST978S')
	AADD(_aDados,'S188MD896')
	AADD(_aDados,'SPL00521I')
	AADD(_aDados,'S4806DD')
	AADD(_aDados,'S23100785')
	AADD(_aDados,'S4677W')
	AADD(_aDados,'S30400567')
	AADD(_aDados,'S4236WNQ')
	AADD(_aDados,'S3245WNQ')
	AADD(_aDados,'S3275WNQ')
	AADD(_aDados,'S23106615')
	AADD(_aDados,'S4657')
	AADD(_aDados,'SN3845')
	AADD(_aDados,'S5809B')
	AADD(_aDados,'SN4277')
	AADD(_aDados,'S48011B')
	AADD(_aDados,'S58011B')
	AADD(_aDados,'S188P0283')
	AADD(_aDados,'N4277W')
	AADD(_aDados,'N3055')
	AADD(_aDados,'N3255')
	AADD(_aDados,'SN5604')
	AADD(_aDados,'S4549WNQ')
	AADD(_aDados,'S4579WNQ')
	AADD(_aDados,'SN4579WNQ')
	AADD(_aDados,'SS4209DR')
	AADD(_aDados,'N50011')
	AADD(_aDados,'N50011')
	AADD(_aDados,'N40011')
	AADD(_aDados,'N40011')
	AADD(_aDados,'N50711')
	AADD(_aDados,'N50711')
	AADD(_aDados,'N52711')
	AADD(_aDados,'N52711')
	AADD(_aDados,'N52011')
	AADD(_aDados,'N52011')
	AADD(_aDados,'N50411')
	AADD(_aDados,'N40711')
	AADD(_aDados,'N40711')
	AADD(_aDados,'S*4203D')
	AADD(_aDados,'N3252W')
	AADD(_aDados,'N3047')
	AADD(_aDados,'SA3506B')
	AADD(_aDados,'SPTE2')
	AADD(_aDados,'SDAM40')
	AADD(_aDados,'S3256WNQ')
	AADD(_aDados,'SPL00531I')
	AADD(_aDados,'S5677W')
	AADD(_aDados,'N3572')
	AADD(_aDados,'S5859W')
	AADD(_aDados,'S5805B')
	AADD(_aDados,'S18122223')
	AADD(_aDados,'TAR416E')
	AADD(_aDados,'SCM123020')
	AADD(_aDados,'S4506D101')
	AADD(_aDados,'QUA4544B')
	AADD(_aDados,'QUA5544DJ')
	AADD(_aDados,'QUA4544DJ')
	AADD(_aDados,'S94700283')
	AADD(_aDados,'TA463BQM')
	AADD(_aDados,'SCM249785')
	AADD(_aDados,'S4253WNQ')
	AADD(_aDados,'S4273W')
	AADD(_aDados,'S756P')
	AADD(_aDados,'S3079WNQ')
	AADD(_aDados,'SN3044W')
	AADD(_aDados,'SN3074W')
	AADD(_aDados,'S66201853')
	AADD(_aDados,'TZ33D2V')
	AADD(_aDados,'S86201931')
	AADD(_aDados,'SCMA00006')
	AADD(_aDados,'SCMA00015')
	AADD(_aDados,'SCMA00025')
	AADD(_aDados,'S12512027')
	AADD(_aDados,'S10512119')
	AADD(_aDados,'S12512028')
	AADD(_aDados,'S14515004')
	AADD(_aDados,'S12512029')
	AADD(_aDados,'S12512030')
	AADD(_aDados,'SN4545W')
	AADD(_aDados,'SS40011B')
	AADD(_aDados,'S10620734')
	AADD(_aDados,'S48011BWMR')
	AADD(_aDados,'S5805BWMR')
	AADD(_aDados,'S58011BWMR')
	AADD(_aDados,'S3806DD')
	AADD(_aDados,'S3804DD')
	AADD(_aDados,'S4805DD')
	AADD(_aDados,'S4809DD')
	AADD(_aDados,'S5805DD')
	AADD(_aDados,'S5806DDR')
	AADD(_aDados,'S4809RWMR')
	AADD(_aDados,'S3806RWMR')
	AADD(_aDados,'S48011RWMR')
	AADD(_aDados,'SA4506DDJ')
	AADD(_aDados,'S4609DD')
	AADD(_aDados,'SA45011DDJ')
	AADD(_aDados,'S3604DD')
	AADD(_aDados,'S5609DD')
	AADD(_aDados,'S48011DD')
	AADD(_aDados,'S58011DD')
	AADD(_aDados,'S3804DWMR')
	AADD(_aDados,'S4806DWMR')
	AADD(_aDados,'S4805DWMR')
	AADD(_aDados,'S5805DWMR')
	AADD(_aDados,'S58011DWMR')
	AADD(_aDados,'S3806BWMR')
	AADD(_aDados,'S4243T')
	AADD(_aDados,'SS4009DR')
	AADD(_aDados,'SS3009DR')
	AADD(_aDados,'SS4207B')
	AADD(_aDados,'SS52011D')
	AADD(_aDados,'SS50011D')
	AADD(_aDados,'SS4007DR')
	AADD(_aDados,'SS4203DR')
	AADD(_aDados,'S3242T')
	AADD(_aDados,'S45011DJ')
	AADD(_aDados,'SS5007DR')
	AADD(_aDados,'SS40011DR')
	AADD(_aDados,'SS5207DR')
	AADD(_aDados,'SS5209DR')
	AADD(_aDados,'SA55011DDJ')
	AADD(_aDados,'S3609DD')
	AADD(_aDados,'S5606DD')
	AADD(_aDados,'S5806DD')
	AADD(_aDados,'S3809DWMR')
	AADD(_aDados,'S3806DWMR')
	AADD(_aDados,'S55011DJ')
	AADD(_aDados,'SS50011DR')
	AADD(_aDados,'SS52011DR')
	AADD(_aDados,'S4809DWMR')
	AADD(_aDados,'S5806DWMR')
	AADD(_aDados,'S5809DWMR')
	AADD(_aDados,'S4809BWMR')
	AADD(_aDados,'S3809BWMR')
	AADD(_aDados,'S4805BWMR')
	AADD(_aDados,'SS42011DR')
	AADD(_aDados,'SS4207DR')
	AADD(_aDados,'S48011DWMR')
	AADD(_aDados,'S3804BWMR')
	AADD(_aDados,'S5806BWMR')
	AADD(_aDados,'S5809BWMR')
	AADD(_aDados,'S48011DDR')
	AADD(_aDados,'S58011DDR')
	AADD(_aDados,'S3809RWMR')
	AADD(_aDados,'S5809DD')
	AADD(_aDados,'S3804RWMR')
	AADD(_aDados,'S4805RWMR')
	AADD(_aDados,'S5806RWMR')
	AADD(_aDados,'S5809RWMR')
	AADD(_aDados,'S5805RWMR')
	AADD(_aDados,'S58011RWMR')
	AADD(_aDados,'S4542W')
	AADD(_aDados,'S4842W')
	AADD(_aDados,'SN01310BR')
	AADD(_aDados,'S4806DDR')
	AADD(_aDados,'SKIT24POW')
	AADD(_aDados,'SN07311BR')
	AADD(_aDados,'SN4006BM')
	AADD(_aDados,'S4552W')
	AADD(_aDados,'S4652W')
	AADD(_aDados,'S4852W')
	AADD(_aDados,'S4506DAB')
	AADD(_aDados,'S4602W')
	AADD(_aDados,'S61050037')
	AADD(_aDados,'SCV8POB')
	AADD(_aDados,'S4802W')
	AADD(_aDados,'S3243W')
	AADD(_aDados,'N5055W')
	AADD(_aDados,'SA4509DDJ')
	AADD(_aDados,'S3804DDR')
	AADD(_aDados,'S3806DDR')
	AADD(_aDados,'S3809DDR')
	AADD(_aDados,'S4809DDR')
	AADD(_aDados,'SPTE1')
	AADD(_aDados,'S4805DDR')
	AADD(_aDados,'S4803BCST')
	AADD(_aDados,'S5809DDR')
	AADD(_aDados,'S5805DDR')
	AADD(_aDados,'S4806RWMR')
	AADD(_aDados,'S4273WNQ')

	DbSelectArea("SB1")

	For _nX:=1 To Len(_aDados)

		If SB1->(DbSeek(xFilial("SB1")+_aDados[_nX]))
			If EMPTY(SB1->B1_CODBAR)
					cCodBar    := cCodEan + cCodEmp + cSequen
					cNewCodBar := cCodBar + EanDigito(cCodBar)// Funcao padrao do sistema que calculo digito do codigo de barras

					PutMv("MV_XSEQBAR",Soma1(cSequen))

					SB1->(Reclock("SB1"))
					SB1->B1_CODBAR := cNewCodBar
					SB1->(MsUnlock())

			EndIf
		EndIf

	Next

Return()
