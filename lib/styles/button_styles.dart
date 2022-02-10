import 'package:flutter/material.dart';
import 'package:oxon_app/size_config.dart';

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

ButtonStyle SolidRoundButtonStyle([minSize]) {
  return ElevatedButton.styleFrom(
    primary: Color.fromARGB(255, 223, 229, 215),
    minimumSize: minSize,//minSize != null ? minSize : null,
    // minimumSize: Size(146.32 * SizeConfig.textMultiplier, 7.61 * SizeConfig.textMultiplier),
    // minimumSize: Size(146.32 * SizeConfig.textMultiplier, 7.61 * SizeConfig.textMultiplier),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(32)),
    ),
  );
}

