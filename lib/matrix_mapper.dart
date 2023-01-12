class MatrixMapper {
  static List<List<int>> fromJson(List<dynamic> data) {
    return <List<int>>[
      for (final List<dynamic> list in data)
        <int>[for (final dynamic number in list) number as int]
    ];
  }
}
