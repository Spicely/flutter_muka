import 'package:flutter/material.dart';

import 'package:flutter_muka/flutter_muka.dart';

class LoadingButton extends StatefulWidget {
  final Future<void> Function()? onPressed;

  final ButtonStyle? style;

  final Widget? child;

  final Widget? loading;

  const LoadingButton({
    Key? key,
    required this.onPressed,
    this.style,
    required this.child,
    this.loading,
  }) : super(key: key);

  @override
  State<LoadingButton> createState() => _LoadingButtonState();
}

class _LoadingButtonState extends State<LoadingButton> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    MukaLoadingButtonTheme loadingButtonTheme = MukaConfig.config.loadingButtonTheme;
    return ElevatedButton(
      style: widget.style,
      onPressed: widget.onPressed == null
          ? null
          : isLoading
              ? null
              : _handleLoading,
      child: isLoading ? widget.loading ?? loadingButtonTheme.loadingWidget(context) : widget.child,
    );
  }

  void _handleLoading() {
    setState(() {
      isLoading = true;
    });
    Utils.exceptionCapture(() async {
      await widget.onPressed!();
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }, dioError: (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
      MukaConfig.config.exceptionCapture.dioError(e);
    }, error: (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
      MukaConfig.config.exceptionCapture.error(e);
    });
  }
}
