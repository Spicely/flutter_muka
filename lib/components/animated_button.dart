part of flutter_muka;

class AnimatedButton extends StatefulWidget {
  @override
  _AnimatedButtonState createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Text('1'),
      onPressed: () {},
    );
  }
}
