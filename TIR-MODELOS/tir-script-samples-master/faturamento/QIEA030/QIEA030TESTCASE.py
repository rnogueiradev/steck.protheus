from tir import Webapp
import unittest

class QIEA030(unittest.TestCase):

	@classmethod
	def setUpClass(inst):
		inst.oHelper = Webapp()
		inst.oHelper.Setup('sigamdi','25/05/2023','11','01','05')
		#inst.oHelper.Program('MATA030')
		inst.oHelper.SetLateralMenu("Atualizações > Cadastros > Unidades de Medida")
	
	def test_QIEA030_001(self):

		cValor = 'AD'
		
		self.oHelper.SetButton('Confirmar')
		self.oHelper.SetButton('Incluir')
		self.oHelper.SetValue('AH_UNIMED',cValor)
		self.oHelper.SetValue('AH_UMRES','TESTE')
		self.oHelper.SetButton('Confirmar')
		self.oHelper.SetButton('Fechar')
		self.oHelper.SearchBrowse(cValor, key=1, index=True)
		self.oHelper.SetButton('Visualizar')
		self.oHelper.CheckResult('AH_UNIMED',cValor)
		self.oHelper.SetButton('Fechar')

		#self.oHelper.SetValue("UB_PRODUTO", "N3076", grid=True)
		#self.oHelper.SetValue("UB_QUANT", "1", grid=True)
		#self.oHelper.LoadGrid()

		self.oHelper.AssertTrue()

	@classmethod
	def tearDownClass(inst):
		inst.oHelper.TearDown()

if __name__ == '__main__':
	unittest.main()