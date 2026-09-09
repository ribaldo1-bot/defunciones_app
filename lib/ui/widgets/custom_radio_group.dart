import 'package:flutter/material.dart';

class CustomRadioGroup<T> extends StatelessWidget {
  final List<T> values;
  final List<String> labels;
  final T? groupValue;
  final ValueChanged<T?> onChanged;
  final Axis direction;

  const CustomRadioGroup({
    super.key,
    required this.values,
    required this.labels,
    required this.groupValue,
    required this.onChanged,
    this.direction = Axis.vertical,
  });

  @override
  Widget build(BuildContext context) {
    assert(values.length == labels.length, 'Values and labels must have the same length');

    List<Widget> children = [];
    for (int i = 0; i < values.length; i++) {
      final value = values[i];
      final isSelected = value == groupValue;
      
      final item = InkWell(
        onTap: () => onChanged(value),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black87, width: 2),
                  borderRadius: BorderRadius.circular(4), // Cuadrado estilo checkbox
                  color: Colors.white,
                ),
                child: Center(
                  child: isSelected
                      ? const Text(
                          'X',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            height: 1.0,
                            color: Colors.black87,
                          ),
                        )
                      : null,
                ),
              ),
              const SizedBox(width: 8),
              Flexible(child: Text(labels[i])),
            ],
          ),
        ),
      );
      children.add(item);
    }

    if (direction == Axis.horizontal) {
      return Wrap(
        spacing: 16,
        children: children,
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      );
    }
  }
}
