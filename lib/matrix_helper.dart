import 'dart:convert';

import './matrix_mapper.dart';

class MatrixHelper {
  static int getIslands(List<List<int>> data) {
    /// Se realiza esto para evitar modificar los datos de donde se consuma el
    /// helper
    final List<dynamic> dataJson = json.decode(json.encode(data));
    final List<List<int>> matrix = MatrixMapper.fromJson(dataJson);
    return _countIslands(matrix);
  }

  // Obtiene la cantidad de islas
  static int _countIslands(List<List<int>> matrix) {
    int quantity = 0;

    // Para calcular el número de columnas obtiene la longitud de la primer
    // lista de la matrix
    final int columnsNumber = matrix[0].length;

    // Recorre la matriz completa
    for (int numberList = 0; numberList < matrix.length; numberList++) {
      // Un ciclo que dara la vuelta la cantidad de columnas que tiene la matriz
      for (int numberColumn = 0; numberColumn < columnsNumber; numberColumn++) {
        // Si el valor de la celda es diferente a uno, pasa a la siguiente
        // vuelta del ciclo de la cantidad de columnas
        if (matrix[numberList][numberColumn] != 1) {
          continue;
        }

        _arrangeIslandCoordinates(
          matrix: matrix,
          numberList: numberList,
          numberColumn: numberColumn,
          adjacentDirectionH: numberList,
          adjacentDirectionV: numberColumn,
        );

        quantity++;
      }
    }

    return quantity;
  }

  /// Valida según una posición de un elemento de una lista de la matriz los
  /// elementos abyacentes o adyacentes y diagonales
  ///
  /// [matrix]
  /// [numberList] Posición de la lista de la matriz
  /// [numberColumn] Número de la columna de la lista de la matriz
  /// [adjacentDirectionH] Dirección a la cual buscara el abyacente (horizontal)
  /// [adjacentDirectionV] Dirección a la cual buscara el abyacente (vertical)
  static void _arrangeIslandCoordinates({
    required List<List<int>> matrix,
    required int numberList,
    required int numberColumn,
    required int adjacentDirectionH,
    required int adjacentDirectionV,
  }) {
    /// Para calcular el número de columnas obtiene la longitud de la primer
    /// lista de la matrix
    final int columnsNumber = matrix[0].length;

    if (adjacentDirectionH < 0 ||
        adjacentDirectionH >= matrix.length ||
        adjacentDirectionV < 0 ||
        adjacentDirectionV >= columnsNumber ||
        matrix[adjacentDirectionH][adjacentDirectionV] <= 0) {
      /// Evita que el método inicial (_countIslands) termine la vuelta del
      /// ciclo de las columnas, para no incrementar una isla en el contador
      return;
    }

    /// Si el elemento de la matriz ya fue recorrido lo convierte en "-1" para
    /// ignorarlo en las siguientes vueltas del ciclo
    matrix[adjacentDirectionH][adjacentDirectionV] *= -1;

    /// Recorre la cantidad de veces que se le indique en el tipo de busqueda,
    /// así según "TypeSearch..." buscara solo abyacentes o también diagonales
    for (int searchNumber = 0;
        searchNumber < TypeSearch.adjacent.value;
        searchNumber++) {
      _arrangeIslandCoordinates(
        matrix: matrix,
        numberList: numberList,
        numberColumn: numberColumn,
        adjacentDirectionH: adjacentDirectionH + _directions[searchNumber][0],
        adjacentDirectionV: adjacentDirectionV + _directions[searchNumber][1],
      );
    }
  }

  /// Lista de direcciones que utilizara para buscar si a los alrededores de una
  /// coordenada hay una coordenada valor valido
  static final List<List<int>> _directions = <List<int>>[
    // Coordenadas para buscar abyacentes
    <int>[0, -1],
    <int>[-1, 0],
    <int>[0, 1],
    <int>[1, 0],
    // Coordenadas para buscar diagonales
    <int>[-1, 1],
    <int>[-1, -1],
    <int>[1, -1],
    <int>[1, 1],
  ];
}

enum TypeSearch { adjacent, diagonals }

extension TypeSearchExt on TypeSearch {
  int get value {
    int response;

    switch (this) {
      case TypeSearch.adjacent:
        response = 4;
        break;
      case TypeSearch.diagonals:
        response = 8;
        break;
    }

    return response;
  }
}
