import 'package:flutter/material.dart';
import 'package:music_streaming_mobile/helper/common_import.dart';

class InfoData {
  final String title;
  final String description;

  const InfoData({required this.title, required this.description});
}

class PrivacyPolicy extends StatelessWidget {
  final List<InfoData> termsData = const [
    InfoData(
        title: 'Title1',
        description:
            'Description 1 To avail the Service as a validly registered user in accordance with the terms of this Agreement, you may need to register on our website and/or on the Software through any means, which may involve (without limitation), setting up a profile, connecting To avail the Service as a validly registered user in accordance with the terms of this Agreement , you may need to register on our website and/or on the Software through any means, which may involve (without limitation), setting up a profile, connecting'),
    InfoData(
        title: 'Title1',
        description:
            'Description 1 To avail the Service as a validly registered user in accordance with the terms of this Agreement, you may need to register on our website and/or on the Software through any means, which may involve (without limitation), setting up a profile, connecting To avail the Service as a validly registered user in accordance with the terms of this Agreement , you may need to register on our website and/or on the Software through any means, which may involve (without limitation), setting up a profile, connecting'),
    InfoData(
        title: 'Title1',
        description:
            'Description 1 To avail the Service as a validly registered user in accordance with the terms of this Agreement, you may need to register on our website and/or on the Software through any means, which may involve (without limitation), setting up a profile, connecting To avail the Service as a validly registered user in accordance with the terms of this Agreement , you may need to register on our website and/or on the Software through any means, which may involve (without limitation), setting up a profile, connecting'),
    InfoData(
        title: 'Title1',
        description:
            'Description 1 To avail the Service as a validly registered user in accordance with the terms of this Agreement, you may need to register on our website and/or on the Software through any means, which may involve (without limitation), setting up a profile, connecting To avail the Service as a validly registered user in accordance with the terms of this Agreement , you may need to register on our website and/or on the Software through any means, which may involve (without limitation), setting up a profile, connecting'),
    InfoData(
        title: 'Title1',
        description:
            'Description 1 To avail the Service as a validly registered user in accordance with the terms of this Agreement, you may need to register on our website and/or on the Software through any means, which may involve (without limitation), setting up a profile, connecting To avail the Service as a validly registered user in accordance with the terms of this Agreement , you may need to register on our website and/or on the Software through any means, which may involve (without limitation), setting up a profile, connecting')
  ];

  const PrivacyPolicy({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/bg-m-3.png'),
          // opacity: 0.7,
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        //backgroundColor: AppTheme.singleton.primaryBackgroundColor,
        appBar: BackNavigationBar(
          title: AppLocalizations.of(context)?.privacyPolicy,
          backTapHandler: () {
            context.pop();
          },
        ),
        body: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (InfoData data in termsData)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.title,
                    style: const TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    data.description,
                    style: const TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 25,
                  )
                ],
              ),
          ],
        ).hP16),
      ),
    );
  }
}
