import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nutrialg_life/widgets/async_button.dart';
import 'package:nutrialg_life/widgets/title_text.dart';

enum StepType { begin, middle, end, single }

class FormStep extends StatelessWidget {
  const FormStep({
    super.key,
    required this.title,
    required this.subtitle,
    required this.children,
    this.type = StepType.single,
    this.next,
    this.back,
    this.send,
  });
  final String title;
  final String subtitle;
  final List<Widget> children;
  final StepType type;
  final void Function()? next;
  final void Function()? back;
  final Future<void> Function()? send;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TitleText(title: title),
        const SizedBox(height: 4),
        FractionallySizedBox(
          widthFactor: 0.9,
          child: Text(subtitle, textAlign: TextAlign.center),
        ),
        const SizedBox(height: 16),
        ...children,
        const Spacer(),
        FractionallySizedBox(
          widthFactor: 0.9,
          child: Row(
            mainAxisAlignment:
                (type == StepType.begin || type == StepType.single)
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.spaceBetween,
            children: [
              (type == StepType.middle || type == StepType.end)
                  ? IconButton.filledTonal(
                      onPressed: back,
                      icon: const Icon(FontAwesomeIcons.angleLeft),
                    )
                  : const SizedBox.shrink(),
              (type == StepType.middle || type == StepType.begin)
                  ? IconButton.filled(
                      onPressed: next,
                      icon: const Icon(FontAwesomeIcons.angleRight),
                    )
                  : AsyncButton(onPressed: send!, child: const Text("Enviar")),
            ],
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
