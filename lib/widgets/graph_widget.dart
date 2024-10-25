import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';

// Pie
class PieGraphWidget extends StatefulWidget {
  final List<double> data;

  const PieGraphWidget({super.key, required this.data});

  @override
  State<PieGraphWidget> createState() => _PieGraphWidgetState();
}

class _PieGraphWidgetState extends State<PieGraphWidget> {
  @override
  Widget build(BuildContext context) {
    List<Series<double, num>> series = [
      Series<double, int>(
        id: 'Sales',
        domainFn: (value, index) => index ?? 0,
        measureFn: (value, _) => value,
        data: widget.data,
        strokeWidthPxFn: (_, __) => 4,
      )
    ];

    return PieChart(series);
  }
}

// Lines
class LinesGraphWidget extends StatefulWidget {
  final List<double> data;

  const LinesGraphWidget({super.key, required this.data});

  @override
  State<LinesGraphWidget> createState() => _GraphWidgetState();
}

class _GraphWidgetState extends State<LinesGraphWidget> {
  _onSelectionChanged(SelectionModel model) {
    final selectedDatum = model.selectedDatum;

    var time;
    final measures = <String, double>{};

    if (selectedDatum.isNotEmpty) {
      time = selectedDatum.first.datum;
      for (var datumPair in selectedDatum) {
        measures[datumPair.series.displayName ?? 'Unknown'] = datumPair.datum;
      }
    }

    print(time);
    print(measures);
  }

  @override
  Widget build(BuildContext context) {
    List<Series<double, num>> series = [
      Series<double, int>(
        id: 'Sales',
        colorFn: (_, __) => MaterialPalette.blue.shadeDefault,
        domainFn: (value, index) => index ?? 0,
        measureFn: (value, _) => value,
        data: widget.data,
        strokeWidthPxFn: (_, __) => 4,
      )
    ];

    return LineChart(
      series,
      animate: false,
      selectionModels: [
        SelectionModelConfig(
          type: SelectionModelType.info,
          changedListener: _onSelectionChanged,
        )
      ],
      domainAxis: const NumericAxisSpec(
        tickProviderSpec: StaticNumericTickProviderSpec([
          TickSpec(0, label: '01'),
          TickSpec(4, label: '05'),
          TickSpec(9, label: '10'),
          TickSpec(14, label: '15'),
          TickSpec(19, label: '20'),
          TickSpec(24, label: '25'),
          TickSpec(29, label: '30'),
        ]),
      ),
      primaryMeasureAxis: const NumericAxisSpec(
        tickProviderSpec: BasicNumericTickProviderSpec(
          desiredTickCount: 4,
        ),
      ),
    );
  }
}
