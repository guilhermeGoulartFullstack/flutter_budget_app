import 'package:app_emerson/components/animated_delete_button.component.dart';
import 'package:app_emerson/constants/AppColor.constant.dart';
import 'package:flutter/material.dart';

class CardSwitch extends StatefulWidget {
  const CardSwitch({
    super.key,
    required this.isEven,
    required this.deleteCallback,
    required this.updateCallback,
    required this.changeEditingCallback,
    required this.isEditing,
  });

  final bool isEven;
  final Function deleteCallback;
  final Function updateCallback;
  final Function changeEditingCallback;
  final bool isEditing;

  @override
  State<CardSwitch> createState() => _CardSwitchState();
}

class _CardSwitchState extends State<CardSwitch> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        widget.isEditing
            ? Row(
                children: [
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: IconButton(
                      icon: const Icon(Icons.check),
                      color: Colors.green,
                      onPressed: () async {
                        await widget.updateCallback();
                      },
                    ),
                  ),
                  AnimatedDeleteButton(
                    deleteCallback: () async {
                      await widget.deleteCallback();
                    },
                  )
                ],
              )
            : const SizedBox(
                height: 40,
                width: 40,
              ),
        Switch(
          value: widget.isEditing,
          activeColor: AppColors.secondaryColor,
          activeTrackColor:
              widget.isEven ? AppColors.primaryColor : Colors.white,
          inactiveThumbColor: AppColors.terciaryColor,
          inactiveTrackColor:
              widget.isEven ? AppColors.primaryColor : Colors.white,
          onChanged: (bool value) {
            widget.changeEditingCallback();
          },
        ),
      ],
    );
  }
}
