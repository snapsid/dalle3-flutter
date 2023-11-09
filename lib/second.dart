import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MySecond extends StatefulWidget {
  const MySecond({Key? key}) : super(key: key);

  @override
  State<MySecond> createState() => _MySecondState();
}

class _MySecondState extends State<MySecond> {
  var apiKey1="your_api_key";
  TextEditingController controller = TextEditingController();
  var imageUrl='';
  bool isLoading = false;
  void generateImage(prompt) async {
    setState(() {
      isLoading = true; // Start loading
    });
    final apiKey = apiKey1; // Replace with your actual API key
    final uri = Uri.parse('https://api.openai.com/v1/images/generations');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey'
    };
    final body = jsonEncode({
      'model': 'dall-e-3',
      'prompt': '$prompt',
      'size': '1024x1024',
      'quality': 'standard',
      'n': 1,
    });

    try {
      final response = await http.post(uri, headers: headers, body: body);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final image_url = responseData['data'][0]['url'];
        print('Image URL: $image_url');

        setState(() {
          imageUrl = image_url;
          isLoading = false;
        });
      } else {
        print('Failed to generate image: ${response.body}');
        setState(() {
          isLoading = false; // Stop loading even if there's an error
        });
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false; // Stop loading on exception
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: Container(
        margin: EdgeInsets.all(20),
        child: Stack(
          children: [
            Container(
              child: Column(
                children: [
                  SizedBox(height: 40,),
                  Text("Create With AI !", style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 40
                  ),),
                  SizedBox(
                    height: 30,
                  ),
                  isLoading ? CircularProgressIndicator() :
                  imageUrl!='' ?ClipRRect(
                    borderRadius: BorderRadius.circular(20), // Adjust the radius for more or less rounded corners
                    child: Image.network(
                      imageUrl,
                      width: 400,
                      height: 400,
                      fit: BoxFit.cover, // This is optional, for how the image should be fitted into the box
                    ),
                  ) : Container(),
                ],
              ),
            ),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextField(
                    controller: controller,
                    maxLines: 6,
                    style: TextStyle(
                        color: Colors.white
                    ),
                    decoration: InputDecoration(
                        filled: true, // Enables the fill color of the text field
                        fillColor: Colors.grey.shade800,
                        hintText: "Enter description of the image",
                        hintStyle: TextStyle(
                            color: Colors.white60// Sets the hint text color to white
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        )
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0), // Curves the button edges
                          ),),
                        onPressed: (){
                          if (!isLoading) { // Prevent multiple presses
                            generateImage(controller.text);
                          }
                        }, child: Text(isLoading ? "Generating..." : "Generate Image", style: TextStyle(
                        fontSize: 19
                    ),)),
                  ),
                  SizedBox(height: 30,)

                ],
              ),
            )

          ],
        ),
      ),
    );
  }
}
