import 'package:flutter/material.dart';

ButtonStyle outlinedButtonStyle(BuildContext context) {
  return OutlinedButton.styleFrom(
    primary: Colors.black87,
    minimumSize: Size(1000, 52),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
    ),
  ).copyWith(
    side: MaterialStateProperty.resolveWith<BorderSide>(
          (Set<MaterialState> states) {
        if (states.contains(MaterialState.pressed))
          return BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 2,
          );
        return BorderSide(
          color: Colors.white,
          width: 2
        );
      },
    ),
  );
}

ButtonStyle outlinedButtonStyleRounder(BuildContext context) {
  return OutlinedButton.styleFrom(
    primary: Colors.black87,
    minimumSize: Size(1000, 52),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(32)),
    ),
  ).copyWith(
    side: MaterialStateProperty.resolveWith<BorderSide>(
          (Set<MaterialState> states) {
        if (states.contains(MaterialState.pressed))
          return BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 2,
          );
        return BorderSide(
          color: Colors.white,
          width: 2
        );
      },
    ),
  );
}

ButtonStyle SolidRoundButtonStyle() {
  return ElevatedButton.styleFrom(
      primary: Color.fromARGB(255, 34, 90, 0),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32.0)));
}

