import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class ShortenForm extends StatefulWidget {
  const ShortenForm({
    super.key,
  });

  @override
  State<ShortenForm> createState() => _ShortenFormState();
}

class _ShortenFormState extends State<ShortenForm> {
  String latestShort = "";
  String errorText = "";
  final TextEditingController _urlController = TextEditingController();

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  final List<String> oldShorts = [];
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Best URL Shortner!'),
        TextField(
          controller: _urlController,
        ),
        latestShort == ""
            ? const SizedBox(
                height: 60,
                width: double.infinity,
              )
            : SizedBox(
                height: 60,
                width: double.infinity,
                child: Row(
                  children: [
                    Text(latestShort),
                    IconButton(
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: latestShort));
                      },
                      icon: const Icon(Icons.copy),
                    )
                  ],
                ),
              ),
        errorText == ""
            ? const SizedBox(
                height: 60,
                width: double.infinity,
              )
            : SizedBox(
                height: 60,
                width: double.infinity,
                child: Text(
                  errorText,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
        ElevatedButton(
          onPressed: () async {
            if (_urlController.text.isEmpty) {
              setState(() {
                errorText = "Input cannot be empty";
              });
              return;
            }
            final result = await http.post(
              Uri(
                host: "localhost",
                port: 3000,
                scheme: "http",
                path: "shorten",
              ),
              body: jsonEncode(_urlController.text),
            );
            if (result.statusCode != 201) {
              errorText = "Something went wrong";
              return;
            }
            final rawShort = jsonDecode(result.body);
            setState(() {
              errorText = "";
              latestShort = rawShort["short"] as String;
              oldShorts.add(latestShort);
            });
          },
          child: const Text("Shorten"),
        ),
      ],
    );
  }
}
