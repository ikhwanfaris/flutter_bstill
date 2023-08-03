// import 'package:flutter/material.dart';
// import 'package:music_streaming_mobile/helper/common_import.dart';
//
// class SideMenu extends StatefulWidget {
//   Function(DataType) selectionHandler;
//
//   SideMenu({Key? key, required this.selectionHandler}) : super(key: key);
//
//   @override
//   _SideMenuState createState() => _SideMenuState();
// }
//
// class _SideMenuState extends State<SideMenu> {
//   late Function(DataType) selectionHandler;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     selectionHandler = widget.selectionHandler;
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       backgroundColor: AppTheme.singleton.secondaryBackgroundColor,
//       child: SingleChildScrollView(
//         child: Column(
//           children: [
//             DrawerHeader(
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Container(
//                       child: ThemeIconWidget(
//                         ThemeIcon.music,
//                         size: 40,
//                         color: AppTheme.singleton.lightColor,
//                       ).p8,
//                       color: AppTheme.singleton.themeColor,
//                     ).circular,
//                     const SizedBox(
//                       width: 10,
//                     ),
//                     Text(
//                       'Musicy',
//                       style: TextStyles.title.lightColor,
//                     )
//                   ],
//                 )),
//             DrawerlistItem(
//                 icon: ThemeIconWidget(ThemeIcon.home,
//                     color: AppTheme.singleton.subHeadingTextColor,
//                     size: 20),
//                 title: 'Dashboard')
//                 .ripple(() {
//               selectionHandler(DataType.dashboard);
//             }),
//             DrawerlistItemGroup(items: [
//               DrawerlistItem(
//                       icon: ThemeIconWidget(ThemeIcon.userGroup,
//                           color: AppTheme.singleton.subHeadingTextColor,
//                           size: 20),
//                       title: 'Artists')
//                   .ripple(() {
//                 selectionHandler(DataType.artists);
//               }),
//               DrawerlistItem(
//                       icon: ThemeIconWidget(ThemeIcon.playlists,
//                           color: AppTheme.singleton.subHeadingTextColor,
//                           size: 20),
//                       title: 'Add Artists')
//                   .ripple(() {
//                 selectionHandler(DataType.addArtists);
//               }),
//             ], title: "Artists"),
//             DrawerlistItemGroup(items: [
//               DrawerlistItem(
//                       icon: ThemeIconWidget(ThemeIcon.userGroup,
//                           color: AppTheme.singleton.subHeadingTextColor,
//                           size: 20),
//                       title: 'Albums')
//                   .ripple(() {
//                 selectionHandler(DataType.album);
//               }),
//               DrawerlistItem(
//                       icon: ThemeIconWidget(ThemeIcon.playlists,
//                           color: AppTheme.singleton.subHeadingTextColor,
//                           size: 20),
//                       title: 'Add album')
//                   .ripple(() {
//                 selectionHandler(DataType.addAlbum);
//               }),
//             ], title: "Albums"),
//             DrawerlistItemGroup(items: [
//               DrawerlistItem(
//                       icon: ThemeIconWidget(
//                         ThemeIcon.catgeories,
//                         color: AppTheme.singleton.subHeadingTextColor,
//                         size: 20,
//                       ),
//                       title: 'Categories')
//                   .ripple(() {
//                 selectionHandler(DataType.categories);
//               }),
//               DrawerlistItem(
//                       icon: ThemeIconWidget(ThemeIcon.playlists,
//                           color: AppTheme.singleton.subHeadingTextColor,
//                           size: 20),
//                       title: 'Add Category')
//                   .ripple(() {
//                 selectionHandler(DataType.addCategories);
//               }),
//             ], title: "Categories"),
//             DrawerlistItemGroup(items: [
//               DrawerlistItem(
//                       icon: ThemeIconWidget(ThemeIcon.music,
//                           color: AppTheme.singleton.subHeadingTextColor,
//                           size: 20),
//                       title: 'Songs')
//                   .ripple(() {
//                 selectionHandler(DataType.songs);
//               }),
//               DrawerlistItem(
//                       icon: ThemeIconWidget(ThemeIcon.addMusic,
//                           color: AppTheme.singleton.subHeadingTextColor,
//                           size: 20),
//                       title: 'Add song')
//                   .ripple(() {
//                 selectionHandler(DataType.addSong);
//               }),
//             ], title: "Songs"),
//             DrawerlistItemGroup(items: [
//               DrawerlistItem(
//                       icon: ThemeIconWidget(ThemeIcon.playlists,
//                           color: AppTheme.singleton.subHeadingTextColor,
//                           size: 20),
//                       title: 'Playlists')
//                   .ripple(() {
//                 selectionHandler(DataType.playlists);
//               }),
//               DrawerlistItem(
//                       icon: ThemeIconWidget(ThemeIcon.playlists,
//                           color: AppTheme.singleton.subHeadingTextColor,
//                           size: 20),
//                       title: 'Create playlist')
//                   .ripple(() {
//                 selectionHandler(DataType.addPlaylist);
//               })
//             ], title: "Playlist"),
//           ],
//         ),
//       ),
//     );
//   }
// }
