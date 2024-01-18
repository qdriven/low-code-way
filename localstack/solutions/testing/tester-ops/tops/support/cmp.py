# encoding: utf-8

class Differ:
    @staticmethod
    def cmp(expect_data, cmp_data):
        if isinstance(expect_data, dict):
            # 若为dict格式
            if not cmp_data or not isinstance(cmp_data, dict):
                return False
            for key in expect_data:
                cmp_key = key
                if cmp_key not in cmp_data:
                    if cmp_key.capitalize() not in cmp_data:
                        return False
                    else:
                        cmp_key = cmp_key.capitalize()
                if not Differ.cmp(expect_data[key], cmp_data[cmp_key]):
                    return False
            return True
        elif isinstance(expect_data, list):
            # 若为list格式
            if not cmp_data or not isinstance(cmp_data, list):
                return False

            if len(expect_data) > len(cmp_data):
                return False
            for src_list, dst_list in zip(sorted(expect_data), sorted(cmp_data)):
                if not Differ.cmp(src_list, dst_list):
                    return False
            return True
        else:
            if str(expect_data) != str(cmp_data):
                return False
            else:
                return True


if __name__ == '__main__':
    expected_data = {"error": 47001}
    cmp_data = {"error": '47001'}
    result = Differ.cmp(expected_data, cmp_data)
    print(result)
