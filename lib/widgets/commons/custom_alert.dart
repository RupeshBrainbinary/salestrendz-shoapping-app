import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoppingapp/utils/commons/export_basic_file.dart';

void openDialog(
  context, {
  List<String> offer,
  List<String> startTime,
  List<String> endTime,
}) {
  int index = 0;
  showDialog(
      context: context,
      builder: (context) => AlertDialog(
            contentPadding: EdgeInsets.zero,
            content:
                Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 18),
                  Text(
                    "Offers",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).primaryColor),
                  ),
                  SizedBox(height: 18),
                  Container(
                    height: 1.3,
                    color: Theme.of(context).primaryColor,
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 25, 20, 0),
                    child: offer == null || offer.length == 0
                        ? Container(
                            height: 60,
                            width: Get.width * 0.5,
                            child: Text(
                              "No offer available",
                              style: TextStyle(fontSize: 15),
                            ),
                            alignment: Alignment.center,
                          )
                        : Column(
                            children: offer.map<Widget>((e) {
                              String start;
                              String end;
                              if (startTime != null && startTime.length != 0) {
                                start = startTime[index].split(' ').first;
                                end = endTime[index].split(' ').first;
                              }
                              index++;
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "$index. ",
                                        style: TextStyle(
                                          fontSize: startTime != null &&
                                                  startTime.length != 0
                                              ? 14
                                              : 13,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          e,
                                          style: TextStyle(
                                            fontSize: startTime != null &&
                                                    startTime.length != 0
                                                ? 14
                                                : 13,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  (startTime != null && startTime.length != 0)
                                      ? Row(
                                          children: [
                                            Text(
                                              "$index. ",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            Text(
                                              start,
                                              style: TextStyle(fontSize: 12),
                                            ),
                                            Text(
                                              "  to  ",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            Text(
                                              end,
                                              style: TextStyle(fontSize: 12),
                                            ),
                                          ],
                                        )
                                      : SizedBox(),
                                ],
                              );
                            }).toList(),
                          ),
                  ),
                  SizedBox(height: 35),
                ],
              ),
            ),
          ));
}

// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
//
// class CustomAlertDialog extends StatelessWidget {
//   /// Creates an alert dialog.
//   ///
//   /// Typically used in conjunction with [showDialog].
//   ///
//   /// The [contentPadding] must not be null. The [titlePadding] defaults to
//   /// null, which implies a default that depends on the values of the other
//   /// properties. See the documentation of [titlePadding] for details.
//   const CustomAlertDialog({
//     Key key,
//     this.title,
//     this.titlePadding,
//     this.content,
//     this.contentPadding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 24.0),
//     this.actions,
//     this.semanticLabel,
//   })  : assert(contentPadding != null),
//         super(key: key);
//
//   /// The (optional) title of the dialog is displayed in a large font at the top
//   /// of the dialog.
//   ///
//   /// Typically a [Text] widget.
//   final Widget title;
//
//   /// Padding around the title.
//   ///
//   /// If there is no title, no padding will be provided. Otherwise, this padding
//   /// is used.
//   ///
//   /// This property defaults to providing 24 pixels on the top, left, and right
//   /// of the title. If the [content] is not null, then no bottom padding is
//   /// provided (but see [contentPadding]). If it _is_ null, then an extra 20
//   /// pixels of bottom padding is added to separate the [title] from the
//   /// [actions].
//   final EdgeInsetsGeometry titlePadding;
//
//   /// The (optional) content of the dialog is displayed in the center of the
//   /// dialog in a lighter font.
//   ///
//   /// Typically, this is a [ListView] containing the contents of the dialog.
//   /// Using a [ListView] ensures that the contents can scroll if they are too
//   /// big to fit on the display.
//   final Widget content;
//
//   /// Padding around the content.
//   ///
//   /// If there is no content, no padding will be provided. Otherwise, padding of
//   /// 20 pixels is provided above the content to separate the content from the
//   /// title, and padding of 24 pixels is provided on the left, right, and bottom
//   /// to separate the content from the other edges of the dialog.
//   final EdgeInsetsGeometry contentPadding;
//
//   /// The (optional) set of actions that are displayed at the bottom of the
//   /// dialog.
//   ///
//   /// Typically this is a list of [FlatButton] widgets.
//   ///
//   /// These widgets will be wrapped in a [ButtonBar], which introduces 8 pixels
//   /// of padding on each side.
//   ///
//   /// If the [title] is not null but the [content] _is_ null, then an extra 20
//   /// pixels of padding is added above the [ButtonBar] to separate the [title]
//   /// from the [actions].
//   final List<Widget> actions;
//
//   /// The semantic label of the dialog used by accessibility frameworks to
//   /// announce screen transitions when the dialog is opened and closed.
//   ///
//   /// If this label is not provided, a semantic label will be infered from the
//   /// [title] if it is not null.  If there is no title, the label will be taken
//   /// from [MaterialLocalizations.alertDialogLabel].
//   ///
//   /// See also:
//   ///
//   ///  * [SemanticsConfiguration.isRouteName], for a description of how this
//   ///    value is used.
//   final String semanticLabel;
//
//   @override
//   Widget build(BuildContext context) {
//     final List<Widget> children = <Widget>[];
//     String label = semanticLabel;
//
//     if (title != null) {
//       children.add(new Padding(
//         padding: titlePadding ??
//             new EdgeInsets.fromLTRB(
//                 24.0, 24.0, 24.0, content == null ? 20.0 : 0.0),
//         child: new DefaultTextStyle(
//           style: TextStyle(fontWeight: FontWeight.w600),
//           child: new Semantics(child: title, namesRoute: true),
//         ),
//       ));
//     } else {
//       switch (defaultTargetPlatform) {
//         case TargetPlatform.iOS:
//           label = semanticLabel;
//           break;
//         case TargetPlatform.android:
//         case TargetPlatform.fuchsia:
//           label = semanticLabel ??
//               MaterialLocalizations.of(context)?.alertDialogLabel;
//       }
//     }
//
//     if (content != null) {
//       children.add(new Flexible(
//         child: new Padding(
//           padding: contentPadding,
//           child: new DefaultTextStyle(
//             style: TextStyle(fontSize: 12),
//             child: content,
//           ),
//         ),
//       ));
//     }
//
// //    if (actions != null) {
// //      children.add(new ButtonTheme.bar(
// //        child: new ButtonBar(
// //          children: actions,
// //        ),
// //      ));
// //    }
//
//     Widget dialogChild = new IntrinsicWidth(
//       child: new Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: children,
//       ),
//     );
//
//     if (label != null)
//       dialogChild =
//           new Semantics(namesRoute: true, label: label, child: dialogChild);
//
//     return new Dialog(child: dialogChild);
//   }
// }
//
// /// An option used in a [SimpleDialog].
// ///
// /// A simple dialog offers the user a choice between several options. This
// /// widget is commonly used to represent each of the options. If the user
// /// selects this option, the widget will call the [onPressed] callback, which
// /// typically uses [Navigator.pop] to close the dialog.
// ///
// /// The padding on a [SimpleDialogOption] is configured to combine with the
// /// default [SimpleDialog.contentPadding] so that each option ends up 8 pixels
// /// from the other vertically, with 20 pixels of spacing between the dialog's
// /// title and the first option, and 24 pixels of spacing between the last option
// /// and the bottom of the dialog.
// ///
// /// ## Sample code
// ///
// /// ```dart
// /// new SimpleDialogOption(
// ///   onPressed: () { Navigator.pop(context, Department.treasury); },
// ///   child: const Text('Treasury department'),
// /// )
// /// ```
// ///
// /// See also:
// ///
// ///  * [SimpleDialog], for a dialog in which to use this widget.
// ///  * [showDialog], which actually displays the dialog and returns its result.
// ///  * [FlatButton], which are commonly used as actions in other kinds of
// ///    dialogs, such as [AlertDialog]s.
// ///  * <https://material.google.com/components/dialogs.html#dialogs-simple-dialogs>
// class SimpleDialogOption extends StatelessWidget {
//   /// Creates an option for a [SimpleDialog].
//   const SimpleDialogOption({
//     Key key,
//     this.onPressed,
//     this.child,
//   }) : super(key: key);
//
//   /// The callback that is called when this option is selected.
//   ///
//   /// If this is set to null, the option cannot be selected.
//   ///
//   /// When used in a [SimpleDialog], this will typically call [Navigator.pop]
//   /// with a value for [showDialog] to complete its future with.
//   final VoidCallback onPressed;
//
//   /// The widget below this widget in the tree.
//   ///
//   /// Typically a [Text] widget.
//   final Widget child;
//
//   @override
//   Widget build(BuildContext context) {
//     return new InkWell(
//       onTap: onPressed,
//       child: new Padding(
//           padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
//           child: child),
//     );
//   }
// }
//
// /// A simple material design dialog.
// ///
// /// A simple dialog offers the user a choice between several options. A simple
// /// dialog has an optional title that is displayed above the choices.
// ///
// /// Choices are normally represented using [SimpleDialogOption] widgets. If
// /// other widgets are used, see [contentPadding] for notes regarding the
// /// conventions for obtaining the spacing expected by Material Design.
// ///
// /// For dialogs that inform the user about a situation, consider using an
// /// [AlertDialog].
// ///
// /// Typically passed as the child widget to [showDialog], which displays the
// /// dialog.
// ///
// /// ## Sample code
// ///
// /// In this example, the user is asked to select between two options. These
// /// options are represented as an enum. The [showDialog] method here returns
// /// a [Future] that completes to a value of that enum. If the user cancels
// /// the dialog (e.g. by hitting the back button on Android, or tapping on the
// /// mask behind the dialog) then the future completes with the null value.
// ///
// /// The return value in this example is used as the index for a switch statement.
// /// One advantage of using an enum as the return value and then using that to
// /// drive a switch statement is that the analyzer will flag any switch statement
// /// that doesn't mention every value in the enum.
// ///
// /// ```dart
// /// Future<Null> _askedToLead() async {
// ///   switch (await showDialog<Department>(
// ///     context: context,
// ///     builder: (BuildContext context) {
// ///       return new SimpleDialog(
// ///         title: const Text('Select assignment'),
// ///         children: <Widget>[
// ///           new SimpleDialogOption(
// ///             onPressed: () { Navigator.pop(context, Department.treasury); },
// ///             child: const Text('Treasury department'),
// ///           ),
// ///           new SimpleDialogOption(
// ///             onPressed: () { Navigator.pop(context, Department.state); },
// ///             child: const Text('State department'),
// ///           ),
// ///         ],
// ///       );
// ///     }
// ///   )) {
// ///     case Department.treasury:
// ///       // Let's go.
// ///       // ...
// ///     break;
// ///     case Department.state:
// ///       // ...
// ///     break;
// ///   }
// /// }
// /// ```
// ///
// /// See also:
// ///
// ///  * [SimpleDialogOption], which are options used in this type of dialog.
// ///  * [AlertDialog], for dialogs that have a row of buttons below the body.
// ///  * [Dialog], on which [SimpleDialog] and [AlertDialog] are based.
// ///  * [showDialog], which actually displays the dialog and returns its result.
// ///  * <https://material.google.com/components/dialogs.html#dialogs-simple-dialogs>
