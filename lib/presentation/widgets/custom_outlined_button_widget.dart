import 'package:flutter/material.dart';

class CustomOutlinedButtonWidget extends StatelessWidget {
  const CustomOutlinedButtonWidget({
    super.key,
    required this.onPressed,
    required this.child,
    this.description,
    this.isOutlined = false
  });

  final void Function()? onPressed;
  final Widget? child;
  final String? description;
  final bool isOutlined;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
          fixedSize: Size(MediaQuery.of(context).size.width, 60),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                20
            ),
          ),
          side: BorderSide(
              color: isOutlined ? Theme.of(context).colorScheme.primary : Colors.transparent,
              width: 2
          ),
          backgroundColor: !isOutlined ? Theme.of(context).buttonTheme.colorScheme?.primary : Colors.transparent,
          foregroundColor: isOutlined ? Theme.of(context).buttonTheme.colorScheme?.primary : Theme.of(context).colorScheme.background,
          textStyle: const TextStyle(
              fontFamily: "montserrat",
              fontSize: 18
          )
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          child!,
          description != null ? Text(
              description ?? "",
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontFamily: "montserrat",
                  fontSize: 14
              )
          ) : Container()
        ],
      ),
    );
  }
}