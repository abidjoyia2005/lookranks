import 'package:flutter/material.dart';

class privacy extends StatefulWidget {
  const privacy({super.key});

  @override
  State<privacy> createState() => _privacyState();
}

class _privacyState extends State<privacy> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:privacypage() ,
    );
  }
}

class privacypage extends StatefulWidget {
  const privacypage({super.key});

  @override
  State<privacypage> createState() => _privacypageState();
}

class _privacypageState extends State<privacypage> {
  @override
   static var _txtCustomHead = TextStyle(
    color: Colors.black87,
    fontSize: 18.0,
    fontWeight: FontWeight.w700,
    fontFamily: "Gotik",
  );
   static var _coscenter = TextStyle(fontFamily: 'Sofia', fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87);

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
                        'Privacy Policy',
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
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.start,
                      //   children: [
                      //     Text(
                      //       '   Introduction',
                      //       style: _txtCustomHead,
                      //     ),
                      //   ],
                      // ),
                      Text(
                        '     Welcome to LookRanks! \n This Privacy Policy is designed to help you understand how we collect, use, and protect your personal information. By using the App, you consent to the practices outlined in this policy.',
                        style: _txtCustomSub,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        ' Interpretation',
                        style: _txtCustomHead,
                      ),
                       Text(
                        '       Users can upload pictures for surveys, providing feedback and suggestions.',
                        style: _txtCustomSub,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                        Text(
                          ' Definitions',
                          style: _txtCustomHead,
                        ),
                      Text(
                        'For the purposes of this Privacy Policy:',
                        style: _txtCustomSub,
                      ),
                      Text('-> Account          ',style:_coscenter ),
                      Text(
                        'means a unique account created for You to access our Service or parts of our Service.',
                        style: _txtCustomSub,
                      ),
                      Text('-> Affiliate           ',style:_coscenter ),
                      Text(
                        'means an entity that controls, is controlled by or is under common control with a party, where "control" means ownership of 50% or more of the shares, equity interest or other securities entitled to vote for election of directors or other managing authority.',
                        style: _txtCustomSub,
                      ),
                      Text('-> Application           ',style:_coscenter ),
                      Text(
                        'refers to lookranks, the software program provided by the lookranks website.',
                        style: _txtCustomSub,
                      ),
                       Text('-> lookranks website          ',style:_coscenter ),
                      Text(
                        '(referred to as either "the lookranks website", "We", "Us" or "Our" in this Agreement) refers to lookranks.',
                        style: _txtCustomSub,
                      ),
                      Text('-> Country          ',style:_coscenter ),
                      Text(
                        'refers to: Punjab, Pakistan',
                        style: _txtCustomSub,
                      ),
                      Text('-> Device         ',style:_coscenter ),
                      Text(
                        'means any device that can access the Service such as a computer, a cellphone or a digital tablet.',
                        style: _txtCustomSub,
                      ),
                        Text('-> Personal Data         ',style:_coscenter ),
                      Text(
                        'is any information that relates to an identified or identifiable individual.',
                        style: _txtCustomSub,
                      ),
                       Text(
                        'means any device that can access the Service such as a computer, a cellphone or a digital tablet.',
                        style: _txtCustomSub,
                      ),
                        Text('-> Service         ',style:_coscenter ),
                      Text(
                        'refers to the Application',
                        style: _txtCustomSub,
                      ),
                      Text('-> Service Provider         ',style:_coscenter ),
                      Text(
                        'means any natural or legal person who processes the data on behalf of the lookranks website. It refers to third-party companies or individuals employed by the lookranks website to facilitate the Service, to provide the Service on behalf of the lookranks website, to perform services related to the Service or to assist the lookranks website in analyzing how the Service is used.',
                        style: _txtCustomSub,
                      ),
                      Text('-> Third-party Social Media Service        ',style:_coscenter ),
                      Text(
                        ' refers to any website or any social network website through which a User can log in or create an account to use the Service.',
                        style: _txtCustomSub,
                      ),
                      Text('-> Usage Data         ',style:_coscenter ),
                      Text(
                        ' refers to data collected automatically, either generated by the use of the Service or from the Service infrastructure itself (for example, the duration of a page visit).',
                        style: _txtCustomSub,
                      ),
                       Text('-> You        ',style:_coscenter ),
                      Text(
                        ' means the individual accessing or using the Service, or the lookranks website, or other legal entity on behalf of which such individual is accessing or using the Service, as applicable.',
                        style: _txtCustomSub,
                      ),
                      Text(
                        ' Types of Data Collected',
                        style: _txtCustomHead,
                      ),
                      Text('-> Personal Data        ',style:_coscenter ),
                      Text(
                        ' While using Our Service, We may ask You to provide Us with certain personally identifiable information that can be used to contact or identify You. Personally identifiable information may include, but is not limited to:\n ->Email address\n->First name and last name\n->Usage Data',
                        style: _txtCustomSub,
                      ),Text('-> Usage Data       ',style:_coscenter ),
                      Text(
                        ' Usage Data is collected automatically when using the Service.Usage Data may include information such as \n ->Your Device"s Internet Protocol address (e.g. IP address) \n ->browser type, browser version, the pages of our Service that You visit, \n->the time and date of Your visit, the time spent on those pages, unique device identifiers and other diagnostic data.\n When You access the Service by or through a mobile device, We may collect certain information automatically, including, but not limited to, the type of mobile device You use, Your mobile device unique ID, the IP address of Your mobile device, Your mobile operating system, the type of mobile Internet browser You use, unique device identifiers and other diagnostic data.We may also collect information that Your browser sends whenever You visit our Service or when You access the Service by or through a mobile device.',
                        style: _txtCustomSub,
                      ),Text('-> Information from Third-Party Social Media Services        ',style:_coscenter ),
                      Text(
                        ' The lookranks website allows You to create an account and log in to use the Service through the following Third-party Social Media Services: \n ->Google\n ->Facebook \n If You decide to register through or otherwise grant us access to a Third-Party Social Media Service, We may collect Personal data that is already associated with Your Third-Party Social Media Service"s account, such as Your name, Your email address, Your activities or Your contact list associated with that account.You may also have the option of sharing additional information with the lookranks website through Your Third-Party Social Media Service"s account. If You choose to provide such information and Personal Data, during registration or otherwise, You are giving the lookranks website permission to use, share, and store it in a manner consistent with this Privacy Policy.',
                        style: _txtCustomSub,
                      ),Text('-> Information Collected while Using the Application        ',style:_coscenter ),
                      Text(
                        ' While using Our Application, in order to provide features of Our Application, We may collect, with Your prior permission:\n ->Information regarding your location\n ->Pictures and other information from your Device"s camera and photo library \n ->Your age , gender, etc for survey of your post and make your post available for filter \n We use this information to provide features of Our Service, to improve and customize Our Service. The information may be uploaded to the lookranks website"s servers and/or a Service Provider"s server or it may be simply stored on Your device.You can enable or disable access to this information at any time, through Your Device settings.',
                        style: _txtCustomSub,
                      ),
                      Text(
                        ' Use of Your Personal Data',
                        style: _txtCustomHead,
                      ),
                      Text(
                        ' The lookranks website may use Personal Data for the following purposes:',
                        style: _txtCustomSub,
                      ),
                      Text('-> To provide and maintain our Service       ',style:_coscenter ),
                      Text(
                        ' including to monitor the usage of our Service.',
                        style: _txtCustomSub,
                      ),Text('-> To manage Your Account        ',style:_coscenter ),
                      Text(
                        '  to manage Your registration as a user of the Service. The Personal Data You provide can give You access to different functionalities of the Service that are available to You as a registered user.',
                        style: _txtCustomSub,
                      ),Text('-> For the performance of a contract       ',style:_coscenter ),
                      Text(
                        ' the development, compliance and undertaking of the purchase contract for the products, items or services You have purchased or of any other contract with Us through the Service.',
                        style: _txtCustomSub,
                      ),Text('-> To contact You        ',style:_coscenter ),
                      Text(
                        ' To contact You by email, telephone calls, SMS, or other equivalent forms of electronic communication, such as a mobile application"s push notifications regarding updates or informative communications related to the functionalities, products or contracted services, including the security updates, when necessary or reasonable for their implementation.',
                        style: _txtCustomSub,
                      ),Text('-> To provide You       ',style:_coscenter ),
                      Text(
                        ' with news, special offers and general information about other goods, services and events which we offer that are similar to those that you have already purchased or enquired about unless You have opted not to receive such information.To manage Your requests: To attend and manage Your requests to Us.',
                        style: _txtCustomSub,
                      ),Text('-> For business transfers        ',style:_coscenter ),
                      Text(
                        '  We may use Your information to evaluate or conduct a merger, divestiture, restructuring, reorganization, dissolution, or other sale or transfer of some or all of Our assets, whether as a going concern or as part of bankruptcy, liquidation, or similar proceeding, in which Personal Data held by Us about our Service users is among the assets transferred.',
                        style: _txtCustomSub,
                      ),Text('-> For other purposes        ',style:_coscenter ),
                      Text(
                        '  We may use Your information for other purposes, such as data analysis, identifying usage trends, determining the effectiveness of our promotional campaigns and to evaluate and improve our Service, products, services, marketing and your experience.We may share Your personal information in the following situations:',
                        style: _txtCustomSub,
                      ),Text('-> With Service Providers        ',style:_coscenter ),
                      Text(
                        ' We may share Your personal information with Service Providers to monitor and analyze the use of our Service, to contact You.',
                        style: _txtCustomSub,
                      ),Text('-> To manage Your requests        ',style:_coscenter ),
                      Text(
                        ' To attend and manage Your requests to Us',
                        style: _txtCustomSub,
                      ),
                      Text('-> With Affiliates       ',style:_coscenter ),
                      Text(
                        '  We may share Your information with Our affiliates, in which case we will require those affiliates to honor this Privacy Policy. Affiliates include Our parent lookranks website and any other subsidiaries, joint venture partners or other companies that We control or that are under common control with Us.',
                        style: _txtCustomSub,
                      ),
                      Text('-> With business partners        ',style:_coscenter ),
                      Text(
                        ' We may share Your information with Our business partners to offer You certain products, services or promotions.',
                        style: _txtCustomSub,
                      ),
                      Text('-> With other users       ',style:_coscenter ),
                      Text(
                        ' when You share personal information or otherwise interact in the public areas with other users, such information may be viewed by all users and may be publicly distributed outside. If You interact with other users or register through a Third-Party Social Media Service, Your contacts on the Third-Party Social Media Service may see Your name, profile, pictures and description of Your activity. Similarly, other users will be able to view descriptions of Your activity, communicate with You and view Your profile.',
                        style: _txtCustomSub,
                      ),
                      Text('-> With Your consent        ',style:_coscenter ),
                      Text(
                        ' We may disclose Your personal information for any other purpose with Your consent.',
                        style: _txtCustomSub,
                      ),

                      Text(
                        ' Retention of Your Personal Data',
                        style: _txtCustomHead,
                      ),
                      Text(
                        ' The lookranks website will retain Your Personal Data only for as long as is necessary for the purposes set out in this Privacy Policy. We will retain and use Your Personal Data to the extent necessary to comply with our legal obligations (for example, if we are required to retain your data to comply with applicable laws), resolve disputes, and enforce our legal agreements and policies.The lookranks website will also retain Usage Data for internal analysis purposes. Usage Data is generally retained for a shorter period of time, except when this data is used to strengthen the security or to improve the functionality of Our Service, or We are legally obligated to retain this data for longer time periods.',
                        style: _txtCustomSub,
                      ),
                      Text(
                        ' Transfer of Your Personal Data',
                        style: _txtCustomHead,
                      ),
                      Text(
                        ' Your information, including Personal Data, is processed at the lookranks website"s operating offices and in any other places where the parties involved in the processing are located. It means that this information may be transferred to — and maintained on — computers located outside of Your state, province, country or other governmental jurisdiction where the data protection laws may differ than those from Your jurisdiction.Your consent to this Privacy Policy followed by Your submission of such information represents Your agreement to that transfer.The lookranks website will take all steps reasonably necessary to ensure that Your data is treated securely and in accordance with this Privacy Policy and no transfer of Your Personal Data will take place to an organization or a country unless there are adequate controls in place including the security of Your data and other personal information.',
                        style: _txtCustomSub,
                      ),
                       Text(
                         ' Delete Your Personal Data',
                         style: _txtCustomHead,
                       ),
                       Text(
                        ' You have the right to delete or request that We assist in deleting the Personal Data that We have collected about You.Our Service may give You the ability to delete certain information about You from within the Service.',
                        style: _txtCustomSub,
                      ),
                       Text('-> To delete your post go to bottom bar and click on your post icon , there is a red color button named delete, by clicking on this button your post will be removed        ',style:_coscenter ),
                        Text('-> To remove your full account data, go to account icon on bottom bar ,there is a delete account button , by clicking on this button your full data login , post etc , all record will be removed         ',style:_coscenter ),
                        Text(
                        '              Note: by clicking on delete account button your data will be removed and will not be restored .',
                        style: _txtCustomSub,
                      ),
                      Text(
                        ' You may update, amend, or delete Your information at any time by signing in to Your Account, if you have one, and visiting the account settings section that allows you to manage Your personal information.\n You may also contact Us to request access to, correct, or delete any personal information that You have provided to Us.\nPlease note, however, that We may need to retain certain information when we have a legal obligation or lawful basis to do so.',
                        style: _txtCustomSub,
                      ),
                       Text(
                         ' Disclosure of Your Personal Data',
                         style: _txtCustomHead,
                       ),
                       Text('-> Business Transactions',style:_coscenter ),
                       Text(
                        ' If the website is involved in a merger, acquisition or asset sale, Your Personal Data may be transferred. We will provide notice before Your Personal Data is transferred and becomes subject to a different Privacy Policy.',
                        style: _txtCustomSub,
                      ),
                      Text('-> Law enforcement',style:_coscenter ),
                       Text(
                        ' Under certain circumstances, the lookranks website may be required to disclose Your Personal Data if required to do so by law or in response to valid requests by public authorities (e.g. a court or a government agency).',
                        style: _txtCustomSub,
                      ),
                      Text('-> Other legal requirements',style:_coscenter ),
                       Text(
                        ' The lookranks website may disclose Your Personal Data in the good faith belief that such action is necessary to: \n Comply with a legal obligation-> Protect and defend the rights or property of the lookranks website\n-> Prevent or investigate possible wrongdoing in connection with the Service\n-> Protect the personal safety of Users of the Service or the public\n-> Protect against legal liability',
                        style: _txtCustomSub,
                      ),
                      Text('-> Security of Your Personal Data',style:_coscenter ),
                       Text(
                        ' The security of Your Personal Data is important to Us, but remember that no method of transmission over the Internet, or method of electronic storage is 100% secure. While We strive to use commercially acceptable means to protect Your Personal Data, We cannot guarantee its absolute security.',
                        style: _txtCustomSub,
                      ),
                       Text(
                         " Children's Privacy",
                         style: _txtCustomHead,
                       ),
                       Text(
                        ' Our Service does not address anyone under the age of 13. \nWe do not knowingly collect personally identifiable information from anyone under the age of 13. If You are a parent or guardian and You are aware that Your child has provided Us with Personal Data, \nplease contact Us. If We become aware that We have collected Personal Data from anyone under the age of 13 without verification of parental consent, We take steps to remove that information from Our servers.\nIf We need to rely on consent as a legal basis for processing Your information and Your country requires consent from a parent, We may require Your parent"s consent before We collect and use that information.',
                        style: _txtCustomSub,
                      ),
                      Text(
                         " Links to Other Websites",
                         style: _txtCustomHead,
                       ),
                       Text(
                        ' Our Service may contain links to other websites that are not operated by Us. If You click on a third party link, You will be directed to that third party"s site. We strongly advise You to review the Privacy Policy of every site You visit.We have no control over and assume no responsibility for the content, privacy policies or practices of any third party sites or services.',
                        style: _txtCustomSub,
                      ),
                      Text(
                         " Changes to this Privacy Policy",
                         style: _txtCustomHead,
                       ),
                       Text(
                        ' We may update Our Privacy Policy from time to time. We will notify You of any changes by posting the new Privacy Policy on this page.We will let You know via email and/or a prominent notice on Our Service, prior to the change becoming effective and update the "Last updated" date at the top of this Privacy Policy.You are advised to review this Privacy Policy periodically for any changes. Changes to this Privacy Policy are effective when they are posted on this page.',                        style: _txtCustomSub,
                      ),
                      Text(
                         " Contact Us",
                         style: _txtCustomHead,
                       ),
                       Text(
                        ' If you have any questions about this Privacy Policy, You can contact us:\nBy email: contact@lookranks.com\nBy visiting this page on our website: https://lookranks.com/feedback/   \nYou can also visit our website for privacy:https://lookranks.com/privacy_policy/',
                        style: _txtCustomSub,
                      ),
                        













                     
                      // Text(
                      //       ' Automatically Collected Information',
                      //       style: _txtCustomHead,
                      //     ),
                      //      Text('-> Device Information',style: TextStyle(fontFamily: 'Sofia', fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black45),),
                      // Text(
                      //   '       We collect device information for the purpose of enhancing the user experience',
                      //   style: _txtCustomSub,
                      // ),
                      // Text('-> Usage Statistics ',style: TextStyle(fontFamily: 'Sofia', fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black45),),
                      // Text(
                      //   '       We gather non-personal identification information related to user interactions with the app.',
                      //   style: _txtCustomSub,
                      // ),
                      // Text(
                      //       ' Camera and Picture Permissions',
                      //       style: _txtCustomHead,
                      //     ),
                      //     Text(
                      //   '       The app requires camera and picture permissions to enable users to upload their pictures for surveys.',
                      //   style: _txtCustomSub,
                      // ),
                      
                      // SizedBox(
                      //   height: 10,
                      // ),

                      //  Text(
                      //       ' 2. How We Use Collected Information?',
                      //       style: _txtCustomHead,
                      //     ),
                      //       Text('-> Survey Creation',style: TextStyle(fontFamily: 'Sofia', fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black45),),
                      // Text(
                      //   '       To create and conduct surveys based on user-provided data.',
                      //   style: _txtCustomSub,
                      // ),
                      // Text('-> Community Interaction ',style: TextStyle(fontFamily: 'Sofia', fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black45),),
                      // Text(
                      //   '       Facilitating communication and feedback within the community.',
                      //   style: _txtCustomSub,
                      // ),
                      // Text('-> Beauty King and Queen Awards ',style: TextStyle(fontFamily: 'Sofia', fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black45),),
                      // Text(
                      //   '       determining winners based on our unique ranking formula.',
                      //   style: _txtCustomSub,
                      // ),
                      //  SizedBox(
                      //   height: 10,
                      // ),
                      //  Text(
                      //       ' 3. Information Protection',
                      //       style: _txtCustomHead,
                      //     ),
                      //       Text('-> Data Security',style: TextStyle(fontFamily: 'Sofia', fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black45),),
                      // Text(
                      //   '       We prioritize user data security with industry-standard measures.',
                      //   style: _txtCustomSub,
                      // ),
                      // Text('-> Third-Party Sharing ',style: TextStyle(fontFamily: 'Sofia', fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black45),),
                      // Text(
                      //   '       We do not share user data with third parties.',
                      //   style: _txtCustomSub,
                      // ),
                      //  SizedBox(
                      //   height: 10,
                      // ),
                      //  Text(
                      //       ' 4. Your Choices',
                      //       style: _txtCustomHead,
                      //     ),
                      //     Text('-> User Control ',style: TextStyle(fontFamily: 'Sofia', fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black45),),
                      // Text(
                      //   '       Users have the right to manage and  control their data within the app.',
                      //   style: _txtCustomSub,
                      // ),
                      //  SizedBox(
                      //   height: 10,
                      // ),
                      // Text(
                      //       ' 5. Account Deletions',
                      //       style: _txtCustomHead,
                      //     ),
                      //     Text('-> Account Deletion Process ',style: TextStyle(fontFamily: 'Sofia', fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black45),),
                      // Text(
                      //   '       Users can delete their accounts by clicking the "delete account" button within the app.',
                      //   style: _txtCustomSub,
                      // ),
                      // Text('-> Retention ',style: TextStyle(fontFamily: 'Sofia', fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black45),),
                      // Text(
                      //   '       Certain information may be retained for legal or auditing purposes, securely stored, and not used for other purposes.',
                      //   style: _txtCustomSub,
                      // ),
                      //  SizedBox(
                      //   height: 10,
                      // ),
                      //  Text(
                      //       '6. Contact Us',
                      //       style: _txtCustomHead,
                      //     ),
                      //      Text(
                      //   '       If you have any questions or concerns about account deletion, contact us at contact@lookranks.com.',
                      //   style: _txtCustomSub,
                      // ),
                      SizedBox(height: 15,),
                      ]
    )))))]));
  }
}