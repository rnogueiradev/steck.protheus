import unittest

from PROCESSOVENDATESTCASE import PROCESSOVENDA

suite = unittest.TestSuite()

suite.addTest(PROCESSOVENDA('test_TMKA271_001'))

runner = unittest.TextTestRunner(verbosity=2)
runner.run(suite)