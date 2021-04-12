class ConvertNumberToChinese {
  // 大写数字
  static List<String> NUMBERS = [
    "",
    "一",
    "二",
    "三",
    "四",
    "五",
    "六",
    "七",
    "八",
    "九",
    "十"
  ];

  // 整数部分的单位
  static List<String> IUNIT = [
    "",
    "十",
    "百",
    "千",
    "万",
    "十",
    "百",
    "千",
    "亿",
    "十",
    "百",
    "千",
    "万",
    "十",
    "百",
    "千"
  ];

  //转成中文的大写金额
  static String toChinese(String str) {
    if (str == "0" || str == "0.00") {
      return "零";
    }
    // 去掉","
    str = str.replaceAll(",", "");
    // 整数部分数字
    String integerStr;
    // 小数部分数字
    String decimalStr;

    // 初始化：分离整数部分和小数部分
    if (str.indexOf(".") > 0) {
      integerStr = str.substring(0, str.indexOf("."));
      decimalStr = str.substring(str.indexOf(".") + 1);
    } else if (str.indexOf(".") == 0) {
      integerStr = "";
      decimalStr = str.substring(1);
    } else {
      integerStr = str;
      decimalStr = "";
    }

    // 超出计算能力，直接返回
    if (integerStr.length > IUNIT.length) {
      print(str + "：超出计算能力");
      return str;
    }

    // 整数部分数字
    var integers = toIntArray(integerStr);
    // 返回最终的大写金额
    return getChineseInteger(integers);
  }

  // 将字符串转为int数组
  static List<int> toIntArray(String number) {
    List<int> array = [];
    if (array.length > number.length) {
      throw new Exception("数组越界异常");
    } else {
      for (int i = 0; i < number.length; i++) {
        array.insert(i, int.parse(number.substring(i, i + 1)));
      }
      return array;
    }
  }

  // 判断当前整数部分是否已经是达到【万】
  static bool isWanYuan(String integerStr) {
    int length = integerStr.length;
    if (length > 4) {
      String subInteger = "";
      if (length > 8) {
        subInteger = integerStr.substring(length - 8, length - 4);
      } else {
        subInteger = integerStr.substring(0, length - 4);
      }
      return int.parse(subInteger) > 0;
    } else {
      return false;
    }
  }

  // 将数字转为中午呢
  static String getChineseInteger(var integers) {
    StringBuffer chineseInteger = new StringBuffer("");
    int length = integers.length;
    for (int i = 0; i < length; i++) {
      String key = "";
      if (integers[i] == 0) {
        // 万（亿）
        if ((length - i) == 13)
          key = IUNIT[4];
        else if ((length - i) == 9) {
          // 亿
          key = IUNIT[8];
        } else if ((length - i) == 5) {
          // 万
          key = IUNIT[4];
        } else if ((length - i) == 1) {
          key = IUNIT[0];
        }
        if ((length - i) > 1 && integers[i + 1] != 0) {
          key += NUMBERS[0];
        }
      }
      chineseInteger.write(integers[i] == 0
          ? key
          : (NUMBERS[integers[i]] + IUNIT[length - i - 1]));
    }
    return chineseInteger.toString();
  }
}
