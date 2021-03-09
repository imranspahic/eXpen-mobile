import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:expen/providers/categoryNotifier.dart';
import 'package:provider/provider.dart';

class PickCategoryImageService {
  pickCategoryImage(BuildContext context, GlobalKey<ScaffoldState> _scaffoldKey, CategoryModel category) async {
    final picker = ImagePicker();
    final slika = await picker.getImage(source: ImageSource.gallery);
    List<int> slikaBytes = await slika.readAsBytes();
    String slikaEncode = base64Encode(slikaBytes);

    if (slikaEncode.length > 970000) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.warning, color: Colors.red),
            SizedBox(width: 15),
            RichText(
                text: TextSpan(children: [
              TextSpan(
                text: 'Slika je veća od ',
              ),
              TextSpan(
                  text: '700KB',
                  style: TextStyle(
                      color: Colors.blue[300], fontWeight: FontWeight.bold)),
              TextSpan(text: ', izaberite drugu!')
            ])),
          ],
        ),
        duration: Duration(seconds: 4),
      ));
      return;
    } else {
      final katData = Provider.of<CategoryNotifier>(context, listen: false);
    
        katData.updateSlikuKategorije(slikaEncode, category.id);
    
    }
  }
}
