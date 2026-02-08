import 'package:flutter/material.dart';

class TermsAndConditionsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TermsAndConditionsScreen(),
    );
  }
}

class TermsAndConditionsScreen extends StatelessWidget {
  @override
  static var _txtCustomHead = TextStyle(
    color: Colors.black87,
    fontSize: 18.0,
    fontWeight: FontWeight.w700,
    fontFamily: "Gotik",
  );

  static var _txtCustomSub = TextStyle(
    color: Colors.black38,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    fontFamily: "Gotik",
  );

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0.0,
        backgroundColor: Colors.deepPurple[50],
        elevation: 0.0,
      ),
      body: Stack(
        children: [
          AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              'Privacy Policy',
              style: TextStyle(color: Colors.white),
            ),
          ),
          Center(
            child: Container(
              // margin: EdgeInsets.all(16),
              // padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: Column(
                    children: [
                     
                      Text(
                        'Terms & Conditions',
                        style: TextStyle(
                            fontFamily: 'Sofia',
                            fontSize: 23,
                            fontWeight: FontWeight.w900),
                      ),
                       Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text('January 1, 2024',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 10.0,
                              fontWeight: FontWeight.w700,
                              fontFamily: "Lemon",
                            )),
                      ),
                       Text(
                        '     Welcome to LookRanks! \n These Terms and Conditions are intended to provide you with a clear understanding of how we gather, utilize, and safeguard your personal information. By utilizing the App, you signify your agreement to the principles delineated in this policy.',
                        style: _txtCustomSub,
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Data Sources',
                            style: _txtCustomHead,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        '     We collect data from the following sources: \n User Input: Information is collected when you register, use the App, or interact with its features. Device Information: Device data is automatically collected to enhance your experience. Purpose of Data Collection \nWe collect data for the following purposes:\n1.To provide you with App functionality.\n2.To personalize your experience and offer relevant content.\n3.To improve the App and its features.\n4.To conduct analytics for performance and user insights.\n',
                        style: _txtCustomSub,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'User Consent',
                            style: _txtCustomHead,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        '     By using the App, you provide consent for the collection and use of your personal information in accordance with this Privacy Policy.',
                        style: _txtCustomSub,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Information Use',
                            style: _txtCustomHead,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        '     We use the collected data for the following purposes:\n To provide and enhance the functionality of the App.\n1.To personalize your experience within the App.\n2.To conduct analytics and improve our services.\n3.To communicate with you, including responding to inquiries and providing updates.\n',
                        style: _txtCustomSub,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Third-Party Services',
                            style: _txtCustomHead,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        '     We may use third-party services, such as advertising networks and analytics tools, which may collect data as governed by their respective privacy policies. Links to these policies are provided where applicable.',
                        style: _txtCustomSub,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Data Sharing',
                            style: _txtCustomHead,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        '     We may share your data with third parties for purposes such as advertising and analytics. However, we do not share personal information in a way that would allow direct identification.',
                        style: _txtCustomSub,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Data Security',
                            style: _txtCustomHead,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        '     We take measures to protect your data from unauthorized access or breaches, including encryption and secure storage.',
                        style: _txtCustomSub,
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Data Retention',
                            style: _txtCustomHead,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        '     We retain your data for as long as necessary for the purposes outlined in this Privacy Policy or as required by law.',
                        style: _txtCustomSub,
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'User Rights',
                            style: _txtCustomHead,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        '     You have the right to access, correct, or delete your information. For inquiries or requests regarding your data, please contact us at lookranks@gmail.com .',
                        style: _txtCustomSub,
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Policy Changes',
                            style: _txtCustomHead,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        '     This Privacy Policy may be updated. We will notify you of changes through the App. Your continued use of the App following policy changes constitutes acceptance.',
                        style: _txtCustomSub,
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Contact Information',
                            style: _txtCustomHead,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        '    If you have questions or concerns about this Privacy Policy, please contact us at contact@lookranks.com.',
                        style: _txtCustomSub,
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Legal Requirements',
                            style: _txtCustomHead,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        '    We comply with applicable data protection laws and regulations.',
                        style: _txtCustomSub,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Consent and Age Restrictions',
                            style: _txtCustomHead,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        '    The App is not intended for children under a certain age. Parental consent may be required as necessary by law.',
                        style: _txtCustomSub,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Cookies and Tracking',
                            style: _txtCustomHead,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        '    The App uses cookies and tracking technologies for analytics and app functionality.',
                        style: _txtCustomSub,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Location Data',
                            style: _txtCustomHead,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        '    The App may collect location data for specific features and functionalities.',
                        style: _txtCustomSub,
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Data Transfer',
                            style: _txtCustomHead,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        '    User data may be transferred internationally, subject to data protection safeguards.',
                        style: _txtCustomSub,
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Opt-Out',
                            style: _txtCustomHead,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        '    Users may have the option to opt out of certain data collection and sharing practices. Please refer to the App settings for more information.',
                        style: _txtCustomSub,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Limitation of Liability',
                            style: _txtCustomHead,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        '    Our liability is limited to the amount paid by the user, if any.We are not liable for damages from app use or user content.',
                        style: _txtCustomSub,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Termination',
                            style: _txtCustomHead,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        '    We may terminate user accounts for policy violations.Users will receive warnings or notices before termination.',
                        style: _txtCustomSub,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Intellectual Property',
                            style: _txtCustomHead,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        '    Users must respect intellectual property rights, refraining from uploading infringing content.',
                        style: _txtCustomSub,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Legal Jurisdiction',
                            style: _txtCustomHead,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        '    This Privacy Policy is governed by the laws',
                        style: _txtCustomSub,
                      ),
                      SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
