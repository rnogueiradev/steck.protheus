import unittest

from QIEA030TESTCASE import QIEA030

suite = unittest.TestSuite()

suite.addTest(QIEA030('test_QIEA030_001'))

runner = unittest.TextTestRunner(verbosity=2)
runner.run(suite)