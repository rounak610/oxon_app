App Link - https://play.google.com/store/apps/details?id=com.oxonlife.oxon
# Using reusable objects:

- To use oxonGreen color- color:AppTheme.colors.oxonGreen
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


# Creating responsive UI:

- Whenever possible, use the textTheme of the custom AppTheme as it is already made responsive.
  Use it in this way-
  ```Text(
        "Guide The Way",
        style: Theme.of(context)
            .textTheme
            .headline3!
            .copyWith(color: AppTheme.colors.oxonGreen),
                    )```
- Update the project. Then run the app in your usual emulator.
- Note the output value of print("responsiveMultiplier value = $responsiveMultiplier"); 
  (called in size_config) code from the logcat
- Using this multiplier value, transform every value which is responsible for a responsive UI 
  (for e.g., size of images, button, text, etc.)
- Python code for transformation is:
  ```
  def calc(currentValue, responsiveMultiplier):
    newValue = currentValue / responsiveMultiplier
    print('%.2f' % (newValue))
  
  ```
- Use the newValue value to replace your values in this way:
    Suppose my margin value is this-
  ```
  margin: EdgeInsets.only(top: 80.0)
  ```
  And in my case, the result value is 11.71 (= 80 / responsiveMultiplier).
  Then I would replace 80 with '11.71 * SizeConfig.responsiveMultiplier', as shown below-
  
  ```
  margin: EdgeInsets.only(top: 11.71 * SizeConfig.responsiveMultiplier)
  ```
  #use LinearProgressIndicator whereever necessary. 
Whenever you want show some kind of loading in the app, Use:
  
Center(child: LinearProgressIndicator())

# Guidelines for collaborative code development on GitHub
- Ideally, master branch should contain the final, tried and tested, bug free code
- If you want to edit it, create a new branch (name the branch that gives information about it and should have 
contraction of your name. E.g. 'testing_maps_ved') from master branch. 
- Code, debug, resolve, etc. on this branch.
- When your development branch is bug free, and tried and tested, commit your changes. Then go to master branch.
Pull changes from remote to the master branch. Then merge the master and your development branch.
- In the merging process, all the conflicts should be resolved correctly. If you have any issues 
with which version of code is correct, consult the person who did the latest commit on the master branch. Only
after the conflicts are resolved, commit your changes and push it to the remote master branch.
