import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_messenger/common/extension/custom_theme_extension.dart';
import 'package:whatsapp_messenger/common/models/user_model.dart';
import 'package:whatsapp_messenger/common/utils/coloors.dart';
import 'package:whatsapp_messenger/common/widgets/custom_icon_button.dart';
import 'package:whatsapp_messenger/feature/contact/controllers/contacts_controller.dart';

class ContactPage extends ConsumerWidget {
  const ContactPage({Key? key}) : super(key: key);

  shareSmsLink(phoneNumber) async {
    Uri sms = Uri.parse(
        "sms:$phoneNumber?body=Let's chat on WhatsApp Me! It's a fast, simple and secure app we call each other for free. Get it at https://whatsappme.com/dl/");
    if (await launchUrl(sms)) {
    } else {}
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Column(
          children: [
            const Text(
              "Select contact",
              style: TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 3),
            ref.watch(contactControllerProvider).when(
              data: (allContacts) {
                return Text(
                  "${allContacts[0].length} contact${allContacts[0].length == 1 ? "" : "s"}",
                  style: const TextStyle(fontSize: 13),
                );
              },
              error: (e, t) {
                return const SizedBox();
              },
              loading: () {
                return const Text(
                  "counting",
                  style: TextStyle(fontSize: 12),
                );
              },
            ),
          ],
        ),
        actions: [
          CustomIconButton(onTap: () {}, icon: Icons.search),
          CustomIconButton(onTap: () {}, icon: Icons.more_vert),
        ],
      ),
      body: ref.watch(contactControllerProvider).when(
        data: (allContacts) {
          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: allContacts[0].length + allContacts[1].length,
            itemBuilder: (context, index) {
              late UserModel firebaseContacts;
              late UserModel phoneContacts;

              if (index < allContacts[0].length) {
                firebaseContacts = allContacts[0][index];
              } else {
                phoneContacts = allContacts[1][index - allContacts[0].length];
              }

              return index < allContacts[0].length
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (index == 0)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            child: Text(
                              "Contacts on WhatsApp Me",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: context.theme.greyColor,
                              ),
                            ),
                          ),
                        ListTile(
                          onTap: () => shareSmsLink(phoneContacts.phoneNumber),
                          contentPadding: const EdgeInsets.only(
                            left: 20,
                            right: 10,
                            top: 0,
                            bottom: 0,
                          ),
                          dense: true,
                          leading: CircleAvatar(
                            backgroundColor: context.theme.greyColor!.withOpacity(0.3),
                            radius: 20,
                            backgroundImage: firebaseContacts.profileImageUrl.isNotEmpty ? NetworkImage(firebaseContacts.profileImageUrl) : null,
                            child: firebaseContacts.profileImageUrl.isEmpty
                                ? const Icon(
                                    Icons.person,
                                    size: 30,
                                    color: Colors.white,
                                  )
                                : null,
                          ),
                          title: Text(
                            firebaseContacts.userName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: Text(
                            "Hey There! Iḿ using WhatsApp Me",
                            style: TextStyle(
                              color: context.theme.greyColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (index == allContacts[0].length)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            child: Text(
                              "Contacts on WhatsApp Me",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: context.theme.greyColor,
                              ),
                            ),
                          ),
                        ListTile(
                          contentPadding: const EdgeInsets.only(
                            left: 20,
                            right: 10,
                            top: 0,
                            bottom: 0,
                          ),
                          dense: true,
                          leading: CircleAvatar(
                            backgroundColor: context.theme.greyColor!.withOpacity(0.3),
                            radius: 20,
                            child: const Icon(
                              Icons.person,
                              color: Colors.white,
                            ),
                          ),
                          title: Text(
                            phoneContacts.userName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: Text(
                            "Hey There! Iḿ using WhatsApp Me",
                            style: TextStyle(
                              color: context.theme.greyColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          trailing: TextButton(
                            onPressed: () => shareSmsLink(phoneContacts.phoneNumber),
                            style: TextButton.styleFrom(
                              foregroundColor: Coloors.greenDark,
                            ),
                            child: const Text("Invite"),
                          ),
                        ),
                      ],
                    );
            },
          );
        },
        error: (e, t) {
          return null;
        },
        loading: () {
          return Center(
            child: CircularProgressIndicator(
              color: context.theme.authAppBarTextColor,
            ),
          );
        },
      ),
    );
  }
}
