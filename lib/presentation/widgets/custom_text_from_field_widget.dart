import 'package:flutter/material.dart';

class CustomTextFromFieldWidget extends StatefulWidget {
  const CustomTextFromFieldWidget({
    super.key,
    required this.title,
    this.labelText,
    this.hintText,
    this.validator,
    this.prefixIcon,
    this.keyboardType = TextInputType.text,
    this.isObscureText = false
  });

  final String title;
  final bool isObscureText;
  final String? labelText;
  final String? hintText;
  final Icon? prefixIcon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  @override
  State<CustomTextFromFieldWidget> createState() => CustomTextFromFieldWidgetState();
}

class CustomTextFromFieldWidgetState extends State<CustomTextFromFieldWidget> {
  late final TextEditingController controller;

  bool _valid = false;

  @override
  void initState() {
    controller = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            width: double.infinity,
            margin: const EdgeInsets.only(left: 4, bottom: 8),
            child: Text(
              widget.title,
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.bodyLarge,
            )
        ),
        TextFormField(
          controller: controller,
          style: Theme.of(context).textTheme.bodyMedium,
          obscureText: widget.isObscureText,
          decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 20
              ),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2
                  ),
                  borderRadius: const BorderRadius.all(
                      Radius.circular(20)
                  )
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.secondary,
                    width: 2
                ),
                borderRadius: const BorderRadius.all(
                    Radius.circular(20)
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.error,
                    width: 2
                ),
                borderRadius: const BorderRadius.all(
                    Radius.circular(20)
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.onErrorContainer,
                    width: 2
                ),
                borderRadius: const BorderRadius.all(
                    Radius.circular(20)
                ),
              ),
              floatingLabelBehavior: FloatingLabelBehavior.never,
              prefixIcon: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: widget.prefixIcon
              ),
              suffixIcon: _valid ? Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Icon(Icons.check_circle_outline, size: 30, color: Theme.of(context).colorScheme.primary)
              ) : Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Icon(Icons.not_interested_rounded, size: 30, color: Theme.of(context).colorScheme.secondary.withOpacity(0.5))
              ),
              labelText: widget.labelText,
              hintText: widget.hintText,
              errorStyle: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontFamily: "montserrat",
                  fontSize: 18
              ),
              labelStyle: TextStyle(
                  color: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
                  fontFamily: "montserrat",
                  fontSize: 18
              ),
              hintStyle: TextStyle(
                  color: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
                  fontFamily: "montserrat",
                  fontSize: 18
              )
          ),
          onChanged: (value) {
            if (widget.validator == null) return;

            if (null == widget.validator!(value)) {
              setState(() {
                _valid = true;
              });
            } else {
              setState(() {
                _valid = false;
              });
            }
          },
          keyboardType: widget.keyboardType,
          validator: widget.validator,
        ),
      ],
    );
  }
}