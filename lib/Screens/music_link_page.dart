import 'dart:convert';
import 'package:converter_youtube/constants/padding.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:google_mobile_ads/google_mobile_ads.dart';

//Widgets
import '../widgets/build_snack_bar.dart';
import '../widgets/download_container.dart';
import '../widgets/input_field.dart';

class MusicLinkPage extends StatefulWidget {
  const MusicLinkPage({Key? key}) : super(key: key);

  @override
  State<MusicLinkPage> createState() => _MusicLinkPageState();
}

class _MusicLinkPageState extends State<MusicLinkPage> {
  TextEditingController textController = new TextEditingController();
  String title = '';
  List link = [];
  String jsonsDataString = '';
  var jsonData;
  InterstitialAd? _interstitialAd;

  //CONNECTİON
  Future<http.Response> fetchapi() async {
    var url = Uri.parse(
        "https://youtube-mp3-download1.p.rapidapi.com/dl?id=${textController.text.substring(17, 28)}");
    var response = await http.get(url, headers: {
      'X-RapidAPI-Key': '40ec6fbcfemshb5562115e05973bp18c723jsn175e4908806a',
      'X-RapidAPI-Host': 'youtube-mp3-download1.p.rapidapi.com'
    });

    if (response.statusCode == 200) {
      setState(() {
        final result = jsonDecode(response.body);
        //liste dynamic değer alıyor
        //result['link'] dynamic bir değer
        link.add(result['link']);
        print(link);
      });
    }
    print(response.body);

    jsonsDataString = response.body.toString();
    jsonData = jsonDecode(jsonsDataString);
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Padding(
          padding: ProjectDecorations.allPadding,
          child: Column(
            children: [
              InputField(textController: textController),
              TapMusicDownloadHandler(context),
            ],
          ),
        ),
      ),
    );
  }

  GestureDetector TapMusicDownloadHandler(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (textController.text.isEmpty || textController.text == ' ') {
          BuildSnackBar(
            context,
            'No music url',
            Colors.red,
            Colors.white,
          );
        } else {
          fetchapi();
          await LoadInterstitialAd(context);
          BuildSnackBar(
            context,
            'After the ad is closed, the download window will open..',
            Colors.green,
            Colors.white,
          );
        }
      },
      child: DownloadContainer(text: 'Music Download'),
    );
  }

  LoadInterstitialAd(BuildContext context) async {
    InterstitialAd.load(
        adUnitId: 'ca-app-pub-8924173754312904/3034082248',
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
            onAdLoaded: (ad) {
              this._interstitialAd = ad;
              _interstitialAd!.show();
              _interstitialAd!.fullScreenContentCallback =
                  FullScreenContentCallback(
                      onAdFailedToShowFullScreenContent: ((ad, error) {
                ad.dispose();
                _interstitialAd!.dispose();
              }), onAdDismissedFullScreenContent: (ad) async {
                ad.dispose();
                _interstitialAd!.dispose();
                if (await canLaunchUrl(Uri.parse(jsonData['link']))) {
                  await launch(jsonData['link']);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('There is a problem')));
                }
              });
            },
            onAdFailedToLoad: (LoadAdError error) {}));
  }
}
