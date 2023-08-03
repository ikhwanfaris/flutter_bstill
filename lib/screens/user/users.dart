// import 'package:flutter/material.dart';
// import 'package:music_streaming_admin_panel/helper/common_import.dart';
// import 'package:music_streaming_admin_panel/helper/responsive.dart';
//
// class Users extends StatefulWidget {
//   AccountStatusType statusType;
//
//   Users({Key? key, required this.statusType}) : super(key: key);
//
//   @override
//   _UsersState createState() => _UsersState();
// }
//
// class _UsersState extends State<Users> {
//   TextEditingController search = TextEditingController();
//   List<UserModel> users = [];
//   firebase_manager manager = firebase_manager();
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     getAllUsers();
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppTheme.singleton.primaryBackgroundColor,
//       body: SizedBox(
//         height: double.infinity,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(
//               height: 20,
//             ),
//             Row(
//               children: [
//                 Text(
//                   '${users.length} artists',
//                   style: TextStyles.body.lightColor.bold,
//                 ),
//                 const Spacer(),
//                 Expanded(
//                   child: InputField(
//                     controller: search,
//                     hintText: AppLocalizations.of(context)?.searchArtist,
//                   ).shadow(),
//                 ),
//                 const SizedBox(width: 10,),
//                 SizedBox(
//                     width: 80,
//                     child: FilledButtonType1(
//                         text: AppLocalizations.of(context)?.add, onPress: () {}))
//               ],
//             ),
//             const Divider(
//               height: 50,
//             ),
//             Expanded(
//               child: GridView.builder(
//                 shrinkWrap: true,
//                 padding: EdgeInsets.zero,
//                 itemCount: users.length,
//                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                     childAspectRatio: Responsive.isDesktop(context) ? 0.85 : Responsive.isTablet(context) ? 0.8 : 0.7,
//                     crossAxisCount: Responsive.isDesktop(context) ? 5 : Responsive.isTablet(context) ? 3 : 2),
//                 itemBuilder: (BuildContext context, int index) {
//                   return UserTile(user: users[index]);
//                 },
//               ),
//             ),
//           ],
//         ),
//       ).hp(50),
//     );
//   }
//
//   getAllUsers(){
//     manager.getAllUsers().then((result) {
//       users = result;
//       setState(() {});
//     });
//   }
// }
//
// class UserTile extends StatelessWidget {
//   UserModel user;
//
//   UserTile({Key? key, required this.user}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Image.network(
//           user.picture,
//           height: 150,
//           width: 150,
//           fit: BoxFit.cover,
//         ).round(5),
//         const SizedBox(height: 10),
//         Text(user.name, style: TextStyles.title.bold),
//       ],
//     ).round(5);
//   }
// }
