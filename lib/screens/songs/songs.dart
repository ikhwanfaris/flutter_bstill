// import 'package:flutter/material.dart';
// import 'package:music_streaming_admin_panel/helper/common_import.dart';
//
// class AllSongs extends StatefulWidget {
//   const AllSongs({Key? key}) : super(key: key);
//
//   @override
//   _AllSongsState createState() => _AllSongsState();
// }
//
// class _AllSongsState extends State<AllSongs> {
//   TextEditingController search = TextEditingController();
//   TextEditingController categoryTf = TextEditingController();
//   TextEditingController artistTf = TextEditingController();
//
//   List<SongModel> songsToShow = [];
//
//   List<CategoryModel> categories = [];
//   CategoryModel? selectedCategory;
//
//   firebase_manager manager = firebase_manager();
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     getAllSongs();
//     getAllCategories();
//
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppTheme.singleton.primaryBackgroundColor,
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const SizedBox(height: 50,),
//           Row(
//             children: [
//               Expanded(flex: Responsive.isMobile(context) ? 6 : 1, child: categoryDropDown()),
//               const SizedBox(width: 20),
//               Expanded(flex: Responsive.isMobile(context) ? 6 : 1, child: artistDropDown()),
//               const Spacer(),
//             ],
//           ).hP25,
//           Expanded(child: songsWidget()),
//         ],
//       ),
//     );
//   }
//
//   Widget categoryDropDown() {
//     return SizedBox(
//       height: 100,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(AppLocalizations.of(context)?.selectCategory,
//               style: TextStyles.body.lightTitleColor),
//           const SizedBox(
//             height: 10,
//           ),
//           Expanded(
//             child: DropdownFiled(
//                 isDisabled: true,
//                 controller: categoryTf,
//                 showBorder: true,
//                 cornerRadius: 5,
//                 onEditingStart: () {
//                   showDialog(
//                     context: context,
//                     builder: (BuildContext context) =>
//                         SelectCategory(callback: (category) {
//                       categoryTf.text = category.name;
//                       setState(() {});
//                     }),
//                   );
//                 },
//                 onPress: () {
//                   showDialog(
//                     context: context,
//                     builder: (BuildContext context) =>
//                         SelectCategory(callback: (category) {
//                       categoryTf.text = category.name;
//                       setState(() {});
//                     }),
//                   );
//                 }),
//           )
//         ],
//       ),
//     );
//   }
//
//   Widget artistDropDown() {
//     return SizedBox(
//       height: 100,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(AppLocalizations.of(context)?.selectArtist,
//               style: TextStyles.body.lightTitleColor),
//           const SizedBox(
//             height: 10,
//           ),
//           Expanded(
//             child: DropdownFiled(
//                 isDisabled: true,
//                 controller: artistTf,
//                 showBorder: true,
//                 cornerRadius: 5,
//                 onEditingStart: () {
//                   showDialog(
//                     context: context,
//                     builder: (BuildContext context) =>
//                         SelectArtist(callback: (artist) {
//                       artistTf.text = artist.name;
//                       setState(() {});
//                     }),
//                   );
//                 },
//                 onPress: () {
//                   showDialog(
//                     context: context,
//                     builder: (BuildContext context) =>
//                         SelectArtist(callback: (artist) {
//                       artistTf.text = artist.name;
//                       setState(() {});
//                     }),
//                   );
//                 }),
//           )
//         ],
//       ),
//     );
//   }
//
//   Widget categoriesWidget() {
//     return Container(
//       color: AppTheme.singleton.primaryBackgroundColor.darken(),
//       child: ListView.separated(
//         itemCount: categories.length,
//         itemBuilder: (BuildContext ctx, int index) {
//           return selectedCategory == categories[index]
//               ? CategoryHorizontalTile(
//                   category: categories[index],
//                 ).shadow().ripple(() {
//                   selectedCategory = categories[index];
//                   setState(() {});
//                 })
//               : CategoryHorizontalTile(
//                   category: categories[index],
//                 ).ripple(() {
//                   selectedCategory = categories[index];
//                   setState(() {});
//                 });
//         },
//         separatorBuilder: (BuildContext ctx, int index) {
//           return const SizedBox(
//             height: 20,
//           );
//         },
//       ).p25,
//     );
//   }
//
//   Widget songsWidget() {
//     return Column(
//       children: [
//         Row(
//           children: [
//             Expanded(
//               flex: Responsive.isMobile(context) ? 6 : 2,
//               child: InputField(
//                 controller: search,
//                 hintText: AppLocalizations.of(context)?.searchSong,
//               ).shadow().setPadding(left: 25, right: 25, top: 25),
//             ),
//             const Spacer()
//           ],
//         ),
//         Expanded(
//           child: ListView.separated(
//             itemCount: songsToShow.length,
//             itemBuilder: (BuildContext ctx, int index) {
//               return SongTileWithArtistInfo(
//                 song: songsToShow[index],
//               );
//             },
//             separatorBuilder: (BuildContext ctx, int index) {
//               return const SizedBox(
//                 height: 20,
//               );
//             },
//           ).p25,
//         ),
//       ],
//     );
//   }
//
//   getAllSongs() {
//     manager.getAllSongs().then((result) {
//       songsToShow = result;
//       setState(() {});
//     });
//   }
//
//   getAllCategories() {
//     manager.getAllCategories().then((result) {
//       categories = result;
//       setState(() {});
//     });
//   }
// }
