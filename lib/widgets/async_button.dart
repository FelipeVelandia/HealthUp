import 'package:flutter/material.dart';

class AsyncButton extends StatefulWidget {
  const AsyncButton({super.key, required this.onPressed, required this.child});
  final Future<void> Function() onPressed;
  final Widget child;

  @override
  State<AsyncButton> createState() => _AsyncButtonState();
}

class _AsyncButtonState extends State<AsyncButton> {
  bool _isLoading = false;

  Future<void> _handleButtonPress() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await widget.onPressed();
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: _isLoading ? null : _handleButtonPress,
      child: _isLoading
          ? const SizedBox(
              height: 20, width: 20, child: CircularProgressIndicator())
          : widget.child,
    );
  }
}
