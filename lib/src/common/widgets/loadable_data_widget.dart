import 'package:flutter/material.dart';

class LoadableDataWidget<T> extends StatefulWidget {
  final Future<T> Function() retrieveDataFunction;
  final Widget loadingWidget;
  final Widget errorWidget;
  final Widget Function(T) dataWidget;

  const LoadableDataWidget({
    Key? key,
    required this.retrieveDataFunction,
    required this.loadingWidget,
    required this.errorWidget,
    required this.dataWidget,
  }) : super(key: key);

  @override
  State<LoadableDataWidget<T>> createState() => _LoadableDataWidgetState<T>();
}

class _LoadableDataWidgetState<T> extends State<LoadableDataWidget<T>> {
  Future<T>? _modelFuture;

  @override
  void initState() {
    super.initState();
    _loadModel();
  }

  void _loadModel() {
    setState(() {
      _modelFuture = widget.retrieveDataFunction();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: _modelFuture,
      builder: (BuildContext context, AsyncSnapshot<T> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return widget.loadingWidget;
        } else if (snapshot.hasError) {
          return widget.errorWidget;
        } else {
          return widget.dataWidget(snapshot.data!);
        }
      },
    );
  }
}
