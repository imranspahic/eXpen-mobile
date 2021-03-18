import 'package:expen/providers/profileNotifier.dart';
import 'package:expen/utils/fieldDivider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SettingsProfileInformation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final profileNotifier = Provider.of<ProfileNotifier>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            child: Image.asset("assets/images/logo_coin_removed.png"),
          ),
          FieldDivider(
            isHorizontal: true,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(profileNotifier.userData["username"]),
              Text(profileNotifier.userData["email"]),
              Text(DateFormat("dd.MM.yyyy").format(profileNotifier.userData["createdAt"]))
            ],
          )
        ],
      ),
    );
  }
}
