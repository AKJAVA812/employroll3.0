import 'package:flutter/material.dart';
import 'package:er_flutter_project/themes/empThemes.dart';

class RequisitionTypeTabs extends StatelessWidget {
  const RequisitionTypeTabs({
    super.key,
    required this.currentIndex,
    required this.onChanged,
  });

  final int currentIndex;
  final ValueChanged<int> onChanged;

  static const _labels = ['Attendance', 'Leave', 'OD', 'WFH'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Container(
        width: double.infinity,
        height: 38,
        decoration: BoxDecoration(
          color: Mythemes.greyishade,
          borderRadius: BorderRadius.circular(8),
        ),
        clipBehavior: Clip.antiAlias,
        child: Row(
          children: List.generate(_labels.length, (index) {
            final selected = currentIndex == index;
            return Expanded(
              child: InkWell(
                onTap: selected ? null : () => onChanged(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  height: 38,
                  alignment: Alignment.center,
                  color: selected ? Mythemes.lightBluishColor : Colors.transparent,
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      _labels[index],
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 12,
                        color: selected ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
