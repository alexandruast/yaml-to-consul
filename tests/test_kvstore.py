# coding=utf-8

import sys
import os
import unittest
sys.path.insert(
    0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
)

import kvstore


class BasicTestSuite(unittest.TestCase):

    ClassIsSetup = False

    def setUp(self):
        import sys
        if not self.ClassIsSetup:
            print(sys.version)
            self.ClassIsSetup = True

    def test_to_entries_single(self):
        d_single_item = {"key": "value"}
        l_single_item_output = [{"key": "key", "value": "value"}]

        self.assertCountEqual(
            kvstore.to_entries(d_single_item), l_single_item_output
        )

    def test_to_entries_multi(self):
        d_multi_item = {
            "key1": "value1",
            "key2": "value2"
        }

        l_multi_item_output = [
            {"key": "key1", "value": "value1"},
            {"key": "key2", "value": "value2"}
        ]

        self.assertCountEqual(
            kvstore.to_entries(d_multi_item), l_multi_item_output
        )

    # def test_to_entries_exception_nested(self):
    #     d_nested_list = {
    #         "key": [
    #             "value1",
    #             "value2"
    #         ]
    #     }
    #
    #     d_nested_dict = {
    #         "key": {
    #             "key1": "value1",
    #             "key2": "value2"
    #         }
    #     }
    #
    #     with self.assertRaises(ValueError):
    #         kvstore.to_entries(d_nested_list)
    #     with self.assertRaises(ValueError):
    #         kvstore.to_entries(d_nested_dict)

    def test_is_valid_key_invalid(self):
        invalid_keys = [
            "/startswithslash",
            "endswithlash/",
            "/startswithslash/endswithslash/",
            "space path/key",
            "path/space key",
            "tab\tpath/key",
            "path/tab\tkey",
            ".startswithdot/key",
            "path/.startswithdot"
        ]

        for item in invalid_keys:
            self.assertFalse(kvstore.is_valid_key(item), msg="Item:{}".format(item))
        for char in "!@#$%^&*(){}[]=+`~\\|;'\",<>?":
            item = "path/contains{}char".format(char)
            self.assertFalse(kvstore.is_valid_key(item), msg="Item:{}".format(item))

    def test_is_valid_key_valid(self):

        valid_keys = [
            "this/path/is/valid",
            "this.path/is/valid",
            "this.path/is.valid",
            "this.path.is/valid",
            "this_path_is/valid",
            "_this_path_is/_valid",
            "this-path/is-valid"
        ]

        for item in valid_keys:
            self.assertTrue(kvstore.is_valid_key(item), msg="Item:{}".format(item))


if __name__ == '__main__':
    suite = unittest.TestLoader().loadTestsFromTestCase(BasicTestSuite)
    ret = not unittest.TextTestRunner(stream=sys.stdout, verbosity=2, buffer=True).run(suite).wasSuccessful()
    sys.exit(ret)
