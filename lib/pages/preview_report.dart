import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oxon_app/models/concern.dart';
import 'package:oxon_app/theme/app_theme.dart';
import 'package:oxon_app/widgets/custom_appbar.dart';
import 'package:oxon_app/widgets/custom_drawer.dart';
import '../models/concern.dart';
import 'package:http/src/response.dart';
import 'package:oauth1/oauth1.dart' as oauth1;

class PreviewReport extends StatefulWidget {
  const PreviewReport({Key? key}) : super(key: key);

  static const routeName = '/preview-report';

  @override
  _PreviewReportState createState() => _PreviewReportState();
}

class _PreviewReportState extends State<PreviewReport> {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Concern;
    final description = args.description;
    final issueType = args.issueType;
    final image_by_user = args.image;

    return SafeArea(
        child: Scaffold(
      backgroundColor: AppTheme.colors.oxonGreen,
      drawer: CustomDrawer(),
      appBar: CustomAppBar(context, "Preview Your Report"),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image:
                        Image.asset('assets/images/products_pg_bg.png').image,
                    fit: BoxFit.cover)),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Name :",
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.w300),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          "Aikagra",
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.w300),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text(
                          "Mobile No. :",
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.w300),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          "99*******",
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.w300),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text(
                          "Twitter :",
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.w300),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          "@*******",
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.w300),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text(
                          "Issue :",
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.w300),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          issueType,
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.w300),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text(
                          "Location :",
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.w300),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          "XXXXXXXXX",
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.w300),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Description :",
                      style: TextStyle(
                          fontSize: 28,
                          color: Colors.white,
                          fontWeight: FontWeight.w700),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        description,
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.w200),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Photo Uploaded :",
                      style: TextStyle(
                          fontSize: 28,
                          color: Colors.white,
                          fontWeight: FontWeight.w700),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                        height: 200,
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        //child: Image.file(File(image_by_user.toString()))
                    ),
                    Text(
                      "*Note: A Twitter post will be uploaded on your handle with this report tagging the involved authorities.",
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.w100),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints.tightFor(
                            width: 250, height: 60),
                        child: ElevatedButton(
                          onPressed: () {
                            post_tweet();
                          },
                          child: Text(
                            'Confirm',
                            style: TextStyle(
                                fontSize: 30,
                                color: Colors.green[900],
                                fontWeight: FontWeight.bold),
                          ),
                          style: ElevatedButton.styleFrom(
                              primary: Colors.green[50],
                              shape: new RoundedRectangleBorder(
                                  borderRadius:
                                      new BorderRadius.circular(35.0))),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints.tightFor(
                            width: 250, height: 60),
                        child: ElevatedButton(
                          onPressed: () {},
                          child: Text(
                            'Share via...',
                            style: TextStyle(
                                fontSize: 30,
                                color: Colors.green[900],
                                fontWeight: FontWeight.bold),
                          ),
                          style: ElevatedButton.styleFrom(
                              primary: Colors.green[50],
                              shape: new RoundedRectangleBorder(
                                  borderRadius:
                                      new BorderRadius.circular(35.0))),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints.tightFor(
                            width: 250, height: 60),
                        child: ElevatedButton(
                          onPressed: () {},
                          child: Text(
                            'Go back',
                            style: TextStyle(
                                fontSize: 25,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          style: ElevatedButton.styleFrom(
                              side: BorderSide(color: Colors.white, width: 2),
                              primary: Color.fromARGB(255, 34, 90, 0),
                              shape: new RoundedRectangleBorder(
                                  borderRadius:
                                      new BorderRadius.circular(35.0))),
                        ),
                      ),
                    ),
                  ],
                )),
          )
        ],
      ),
    )
    );
  }
  void post_tweet() {
    // define platform (server)
    final oauth1.Platform platform = oauth1.Platform(
        'https://api.twitter.com/oauth/request_token', // temporary credentials request
        'https://api.twitter.com/oauth/authorize', // resource owner authorization
        'https://api.twitter.com/oauth/access_token', // token credentials request
        oauth1.SignatureMethods.hmacSha1 // signature method
    );

    // define client credentials (consumer keys)
    const String apiKey = '5s4o3m6dwOWHOfQJCD4EU1V9E';
    const String apiSecret = 'qnFEFjacNFYUx8nDh8OURUdtgItsMmnk78IhnXgyfv8AcljXch';
    final oauth1.ClientCredentials clientCredentials =
    oauth1.ClientCredentials(apiKey, apiSecret);

    // create Authorization object with client credentials and platform definition
    final oauth1.Authorization auth =
    oauth1.Authorization(clientCredentials, platform);

    // request temporary credentials (request tokens)
    auth
        .requestTemporaryCredentials('oob')
        .then((oauth1.AuthorizationResponse res) {
      // redirect to authorization page
      print('Open with your browser:'
          '${auth.getResourceOwnerAuthorizationURI(res.credentials.token)}');

      // get verifier (PIN)
      stdout.write('PIN: ');
      final String verifier = stdin.readLineSync() ?? '';

      // request token credentials (access tokens)
      return auth.requestTokenCredentials(res.credentials, verifier);
    }).then((oauth1.AuthorizationResponse res) {
      // yeah, you got token credentials
      // create Client object
      final oauth1.Client client = oauth1.Client(
          platform.signatureMethod, clientCredentials, res.credentials);

      // now you can access to protected resources via client
      client
          .post(Uri.parse(
          'https://api.twitter.com/2/tweets')
          ,body:{
            "text" : "hello!!"
          }
      )
          .then((Response res) {
        print(res.body);
      });

      // NOTE: you can get optional values from AuthorizationResponse object
      print('Your screen name is ' + res.optionalParameters['screen_name']!);
    }
    );
  }

}
