import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'matrix_helper.dart';

class App extends ConsumerWidget {
  const App({Key? key}) : super(key: key);

  static final StateProvider<List<List<int>>> _matrix =
      StateProvider<List<List<int>>>((_) => <List<int>>[]);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            children: <Widget>[
              _buildField(ref),
              const SizedBox(height: 20),
              _buildGrid(context, ref),
              const SizedBox(height: 20),
              _buildInfoIslands(context, ref),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(WidgetRef ref) {
    return TextField(
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Longitud de la matriz',
        counterText: '',
        helperText: 'Solo se acepta un número de 0 a 9',
      ),
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly,
      ],
      onChanged: (String value) {
        final int intValue = int.parse(value != '' ? value : '0');
        final List<List<int>> matrix = List<List<int>>.generate(intValue, (_) {
          return List<int>.generate(intValue, (_) {
            final Random random = Random();
            return random.nextInt(2);
          });
        });

        ref.read(_matrix.notifier).state = matrix;
      },
      maxLength: 1,
    );
  }

  Widget _buildGrid(BuildContext context, WidgetRef ref) {
    final List<List<int>> matrix = ref.watch(_matrix);
    final int matrixLength = matrix.length;

    if (matrix.isEmpty) {
      return const SizedBox.shrink();
    }

    return AspectRatio(
      aspectRatio: 1,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: matrixLength,
        ),
        itemBuilder: (_, int index) {
          final int x = (index / matrixLength).floor();
          final int y = index % matrixLength;

          return GestureDetector(
            onTap: () {
              matrix[x][y] = matrix[x][y] == 1 ? 0 : 1;
              ref.read(_matrix.notifier).state = <List<int>>[];
              ref.read(_matrix.notifier).state = matrix;
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: .5),
                color: (matrix[x][y] == 1) ? Colors.green : Colors.blue,
              ),
              child: Center(
                child: Text(
                  matrix[x][y].toString(),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ),
          );
        },
        itemCount: matrixLength * matrixLength,
      ),
    );
  }

  Widget _buildInfoIslands(BuildContext context, WidgetRef ref) {
    final List<List<int>> matrix = ref.watch(_matrix);

    if (matrix.isEmpty) {
      return const SizedBox.shrink();
    }

    // Utiliza el helper del script para calcular las islas
    final int quantityIslands = MatrixHelper.getIslands(matrix);

    return Text(
      'Hay $quantityIslands islas',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.headline4!.copyWith(
            fontWeight: FontWeight.w300,
          ),
    );
  }
}
