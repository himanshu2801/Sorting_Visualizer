import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Visualizer",
      theme: ThemeData(primarySwatch: Colors.green),
      home: _SortingVisualizer(),
    );
  }
}

class _SortingVisualizer extends StatefulWidget {
  @override
  __SortingVisualizerState createState() => __SortingVisualizerState();
}

class __SortingVisualizerState extends State<_SortingVisualizer> {
  bool isAlgorithmRunning;
  StreamController<List<int>> streamController;
  Stream<List<int>> _stream;
  List<int> arr = [];
  int size = 300;
  _bubbleSortVisualiser() async {
    for (int i = 0; i < arr.length; i++) {
      for (int j = 0; j < arr.length - i - 1; ++j) {
        if (arr[j] > arr[j + 1]) {
          int temp = arr[j];
          arr[j] = arr[j + 1];
          arr[j + 1] = temp;
        }
        await Future.delayed(Duration(microseconds: 2));
        streamController.add(arr);
      }
    }
  }

  _selectionSortVisualiser() async {
    print('Selection sort visualiser called');
    List<int> selectArr = List.from(arr);
    int minIndex, temp;

    for (int i = 0; i < selectArr.length - 1; i++) {
      minIndex = i;
      for (int j = i + 1; j < selectArr.length; j++) {
        if (selectArr[j] < selectArr[minIndex]) {
          minIndex = j;
        }
      }

      temp = selectArr[i];
      selectArr[i] = selectArr[minIndex];
      selectArr[minIndex] = temp;

      await Future.delayed(const Duration(milliseconds: 5), () {
        setState(() {
          arr = List.from(selectArr);
        });
      });
    }
  }

  _insertionSortVisualiser() async {
    print('Insertion sort visualiser called');
    List<int> insertArr = List.from(arr);
    int key, j;

    for (int i = 1; i < insertArr.length; i++) {
      key = insertArr[i];
      j = i - 1;

      while (j >= 0 && insertArr[j] > key) {
        insertArr[j + 1] = insertArr[j];
        j = j - 1;
      }
      insertArr[j + 1] = key;
      await Future.delayed(const Duration(milliseconds: 5), () {
        setState(() {
          arr = List.from(insertArr);
        });
      });
    }
  }

  _quickSortVisualiser(List<int> quickArr, int low, int high) async {
    print('Quick sort visualiser called');
    int pivot;
    if (low < high) {
      pivot = await _partition(arr, low, high);
      await _quickSortVisualiser(quickArr, low, pivot - 1); // Before pi
      await _quickSortVisualiser(quickArr, pivot + 1, high); // After pi
    }
  }

  Future<int> _partition(List<int> quickArr, int low, int high) async {
    int pivot = quickArr[high];
    int i = (low - 1);
    int temp;
    for (int j = low; j <= high - 1; j++) {
      if (quickArr[j] < pivot) {
        i++;
        temp = quickArr[i];
        quickArr[i] = quickArr[j];
        quickArr[j] = temp;
        await _updateArrayWithDelay(quickArr);
      }
    }
    temp = quickArr[i + 1];
    quickArr[i + 1] = quickArr[high];
    quickArr[high] = temp;
    await _updateArrayWithDelay(quickArr);
    return (i + 1);
  }

  _mergeSortVisualiser(List<int> mergeArr, int low, int high) async {
    print('Merge Sort called');
    print('Array size is : "${mergeArr.length}"');
    if (low < high) {
      int mid = (low + (high - low) / 2).toInt();
      await _mergeSortVisualiser(mergeArr, low, mid);
      await _mergeSortVisualiser(mergeArr, mid + 1, high);
      _updateArrayWithDelay(mergeArr);
      await merge(mergeArr, low, mid, high);
    }
  }

  merge(List<int> mergeArr, int low, int mid, int high) async {
    int i, j, k;
    int n1 = mid - low + 1;
    int n2 = high - mid;
    List<int> L = [], R = [];

    for (i = 0; i < n1; i++) L.add(mergeArr[low + i]);
    for (j = 0; j < n2; j++) R.add(mergeArr[mid + 1 + j]);

    i = 0;
    j = 0;
    k = low;
    while (i < n1 && j < n2) {
      if (L[i] <= R[j]) {
        mergeArr[k] = L[i];
        i++;
      } else {
        mergeArr[k] = R[j];
        j++;
      }
      await _updateArrayWithDelay(mergeArr);
      k++;
    }

    while (i < n1) {
      mergeArr[k] = L[i];
      i++;
      k++;
    }

    while (j < n2) {
      mergeArr[k] = R[j];
      j++;
      k++;
    }
  }

  _heapSortVisualiser(List<int> heapArr) async {
    int n = heapArr.length;
    for (int i = n ~/ 2 - 1; i >= 0; i--) await heapify(heapArr, n, i);
    for (int i = n - 1; i >= 0; i--) {
      int temp = heapArr[0];
      heapArr[0] = heapArr[i];
      heapArr[i] = temp;
      await _updateArrayWithDelay(heapArr);
      await heapify(heapArr, i, 0);
    }
  }

  heapify(List<int> heapArr, int n, int i) async {
    int largest = i;
    int l = 2 * i + 1;
    int r = 2 * i + 2;
    if (l < n && heapArr[l] > heapArr[largest]) largest = l;
    if (r < n && heapArr[r] > heapArr[largest]) largest = r;
    if (largest != i) {
      int swap = heapArr[i];
      heapArr[i] = heapArr[largest];
      heapArr[largest] = swap;
      await _updateArrayWithDelay(heapArr);
      await heapify(heapArr, n, largest);
    }
  }

  List<int> _generate() {
    arr = [];
    for (int i = 0; i < size; ++i) {
      arr.add(Random().nextInt(size));
    }

    streamController.add(arr);
    return arr;
  }

  @override
  void initState() {
    super.initState();
    streamController = StreamController<List<int>>();
    _stream = streamController.stream;
    _generate();
    isAlgorithmRunning = false;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Visualizer'),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 0.0, 10, 0.0),
              child: IgnorePointer(
                ignoring: isAlgorithmRunning,
                child: DropdownButton<String>(
                  icon: Icon(
                    Icons.arrow_drop_down_circle,
                    color: Colors.white,
                    size: 30,
                  ),
                  onChanged: (dynamic choice) async {
                    List<int> sorted = List.from(arr);
                    sorted.sort();
                    if (listEquals(arr, sorted)) {
                      _showCenterToast("It is already sorted !");
                      return;
                    }
                    switch (choice) {
                      case 'Bubble Sort':
                        _Algorithmrunningstate(true);
                        await _bubbleSortVisualiser();
                        _Algorithmrunningstate(false);
                        _showCenterToast('Bubble Sort completed');
                        break;
                      case 'Selection Sort':
                        _Algorithmrunningstate(true);
                        await _selectionSortVisualiser();
                        _Algorithmrunningstate(false);
                        _showCenterToast('Selection Sort completed');
                        break;
                      case 'Insertion Sort':
                        _Algorithmrunningstate(true);
                        await _insertionSortVisualiser();
                        _Algorithmrunningstate(false);
                        _showCenterToast("Insertion Sort completed");

                        break;
                      case 'Quick Sort':
                        _Algorithmrunningstate(true);
                        await _quickSortVisualiser(arr, 0, arr.length - 1);
                        _Algorithmrunningstate(false);
                        _showCenterToast("Quick Sort completed");
                        break;
                      case 'Merge Sort':
                        _Algorithmrunningstate(true);
                        await _mergeSortVisualiser(arr, 0, arr.length - 1);
                        _Algorithmrunningstate(false);
                        _showCenterToast("Merge Sort completed");
                        break;
                      case 'Heap Sort':
                        _Algorithmrunningstate(true);
                        await _heapSortVisualiser(arr);
                        _Algorithmrunningstate(false);
                        _showCenterToast("Heap Sort completed");
                        break;
                    }
                  },
                  hint: Center(
                    child: Text(
                      "Sorting Algo",
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                          fontSize: 25),
                    ),
                  ),
                  items: <String>[
                    'Bubble Sort',
                    'Selection Sort',
                    'Insertion Sort',
                    'Quick Sort',
                    'Merge Sort',
                    'Heap Sort',
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.w500),
                      ),
                    );
                  }).toList(),
                  iconSize: 40,
                ),
              ),
            )
          ],
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 4.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              FloatingActionButton(
                backgroundColor: Colors.blueAccent,
                onPressed: () {
                  if (isAlgorithmRunning) {
                    Fluttertoast.showToast(
                        msg: "Algorithm is running !",
                        gravity: ToastGravity.CENTER,
                        backgroundColor: Colors.blueAccent,
                        textColor: Colors.white,
                        toastLength: Toast.LENGTH_SHORT);
                    return;
                  }
                  setState(() {
                    arr = _generate();
                  });
                },
                child: Icon(
                  Icons.refresh,
                  size: 40,
                  color: Colors.white,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: Text(
                  'Generate Array',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: Container(
          width: double.infinity,
          child: StreamBuilder<Object>(
              stream: _stream,
              builder: (context, snapshot) {
                int count = 0;
                return Row(
                  children: arr.map((int num) {
                    count++;
                    return CustomPaint(
                      painter: BarPainter(
                        width: MediaQuery.of(context).size.width / size,
                        value: num,
                        index: count,
                      ),
                    );
                  }).toList(),
                );
              }),
        ),
      ),
    );
  }

  void _Algorithmrunningstate(bool state) {
    setState(() {
      isAlgorithmRunning = state;
    });
  }

  _updateArrayWithDelay(List<int> Arr) async {
    await Future.delayed(const Duration(milliseconds: 5), () {
      setState(() {
        arr = List.from(Arr);
      });
    });
  }
}

class BarPainter extends CustomPainter {
  final double width;
  final int value;
  final int index;

  BarPainter({this.width, this.value, this.index});
  @override
  void paint(Canvas canvas, Size size) {
    Paint p = Paint();
    if (this.value < 300 * .10) {
      p.color = Color(0xFFFFEBEE);
    } else if (this.value < 300 * .20) {
      p.color = Color(0xFFFFCDD2);
    } else if (this.value < 300 * .30) {
      p.color = Color(0xFFEF9A9A);
    } else if (this.value < 300 * .40) {
      p.color = Color(0xFFE57373);
    } else if (this.value < 300 * .50) {
      p.color = Color(0xFFEF5350);
    } else if (this.value < 300 * .60) {
      p.color = Color(0xFFF44336);
    } else if (this.value < 300 * .70) {
      p.color = Color(0xFFE53935);
    } else if (this.value < 300 * .80) {
      p.color = Color(0xFFD32F2F);
    } else if (this.value < 300 * .90) {
      p.color = Color(0xFFC62828);
    } else {
      p.color = Color(0xFFB71C1C);
    }
    p.strokeCap = StrokeCap.round;
    p.strokeWidth = 4.0;
    canvas.drawLine(Offset(index * width, 0),
        Offset(index * width, 300 + value.ceilToDouble()), p);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

_showCenterToast(String msg) {
  Fluttertoast.showToast(
    msg: msg,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: Colors.greenAccent,
    textColor: Colors.black,
  );
}
