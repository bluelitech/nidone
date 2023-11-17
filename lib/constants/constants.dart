class AlarmConst {
  static List<String> days = ['日', '月', '火', '水', '木', '金', '土'];
  static List<String> triggers = ['充電中', '指定した座標の近くにいる'];
  static Map<String, int> trigger = {
    'BATTERY': 0,
    'GPS': 1,
  };
  static Map<int, String> reason = {
    0: '充電中',
    1: '指定した座標の近くにいる',
  };
}
