import 'package:flutter/material.dart';

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
    return ElevatedButton(
      style: widget.style,
      onPressed: widget.onPressed == null
          ? null
          : isLoading
              ? _handleLoading
              : null,
      child: widget.child,
    );
  }

  Future<void> _handleLoading() async {
    setState(() {
      isLoading = true;
    });
    await widget.onPressed!();
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }
}
