# Using reusable objects:

- To use oxonGreen color- color:AppTheme.colors.oxonGree
- To create the standard rounded button- style: SolidRoundButtonStyle()
- To style text- style: Theme.of(context).textTheme.headline2
- T0 style text with different color- style: Theme.of(context).textTheme.headline2!.copyWith(color: AppTheme.colors.oxonGreen)

# Points to note:

- Every Scaffold should have its backgroundColor property set to AppTheme.colors.oxonGreen
- Make responsive UI using height: (MediaQuery.of(context).size.height) * <percent value of the screen to be occupied> like code. For e.g., height: (MediaQuery.of(context).size.height) * 0.4
- When using CustomAppBar, you don't need any action buttons on the left side of the title simply call CustomAppBar(context, <title>)
If you do need action buttons, call CustomAppBar(context, <title>, <list of widgets that will be rendered as action buttons>)
  
- Keep in mind that the screen resolution of user's phone could be different from that of your emulator. So, design accordingly.
- Extract and refactor codes which are reusable and keep it in separate file. And also document how to use it.

