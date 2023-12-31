import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../Authentication/auth.dart';
import '../Widgets/PopUpBox.dart';
import 'Login.dart';

//Errors in Validation
class Registration extends StatefulWidget {
  final Function onTap;
  Registration({required this.onTap});
  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final _formKey = GlobalKey<FormState>();
  final Auth _auth = Auth();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String name = '';
  String email = '';
  String phoneNumber = '';
  String password = '';
  String confirm = '';
  bool isLoading = false;
  void pressed() {
    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => LoginCustomer(
                  onTap: widget.onTap,
                )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Registration',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            letterSpacing: 1,
          ),
        ),
        centerTitle: true,
      ),
      body:Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              const CircleAvatar(
                backgroundImage: AssetImage('assets/logo2.png'),
                radius: 125,
              ),
              const SizedBox(
                height: 20,
              ),
              //Name
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: TextFormField(
                  // key: _formKey,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                    hintText: 'Name',
                  ),
                  enableSuggestions: true,
                  validator: (value) {
                    if (name.isEmpty) {
                      return 'Enter your name';
                    } else {
                      return null;
                    }
                  },
                  onChanged: (value) {
                    setState(() {
                      name = value;
                    });
                  },
                ),
              ),
        
              const SizedBox(
                height: 20,
              ),
        
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: TextFormField(
                  // key: _formKey,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                    hintText: 'Email',
                  ),
                  enableSuggestions: true,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (email.isEmpty || !email.contains('@')) {
                      return 'Enter your Email';
                    } else {
                      return null;
                    }
                  },
                  onChanged: (value) {
                    setState(() {
                      email = value;
                    });
                  },
                ),
              ),
        
              const SizedBox(
                height: 20,
              ),
        
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: TextFormField(
                  // key: _formKey,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                    hintText: 'Phone Number',
                  ),
                  keyboardType: TextInputType.phone,
                  enableSuggestions: true,
                  validator: (value) {
                    if (phoneNumber.isEmpty) {
                      return 'Enter your Mobile Number';
                    } else if (phoneNumber.length != 10) {
                      return 'Enter correct Mobile Number';
                    } else {
                      return null;
                    }
                  },
                  onChanged: (value) {
                    setState(() {
                      phoneNumber = value;
                    });
                  },
                ),
              ),
        
              const SizedBox(
                height: 20,
              ),
        
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: TextFormField(
                  keyboardType:TextInputType.visiblePassword,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                    hintText: 'Password',
                    
                  ),
                  enableSuggestions: true,
                  validator: (value) {
                    if (password.isEmpty) {
                      return 'Enter a password';
                    } else if (password.length < 8) {
                      return 'Password too short';
                    } else {
                      return null;
                    }
                  },
                  onChanged: (value) {
                    setState(() {
                      password = value;
                    });
                  },
                ),
              ),
        
              const SizedBox(
                height: 20,
              ),
        
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: TextFormField(
                  keyboardType:TextInputType.visiblePassword,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                    hintText: 'Confirm Password',
                  ),
                  enableSuggestions: true,
                  validator: (value) {
                    if (confirm.isEmpty) {
                      return 'Please enter password again';
                    } else if (confirm != password) {
                      return "Password doesn't matched";
                    } else {
                      return null;
                    }
                  },
                  onChanged: (value) {
                    setState(() {
                      confirm = value;
                    });
                  },
                ),
              ),
        
              const SizedBox(
                height: 20,
              ),
        
              ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        isLoading = true;
                      });
                      dynamic result = await _auth.registerWithEmailAndPassword(
                          email, password);
                      if (result != null) {
                        print(result);
                        try {
                          // Reference to the Firestore collection "users"
                          CollectionReference usersCollection =
                              FirebaseFirestore.instance.collection('users');
        
                          // Create a new document in the "users" collection with the user's UID as the document ID
                          await usersCollection.doc(email).set({
                            'Name': name,
                            'Email': email,
                            'Phone Number': phoneNumber,
                            // Add other user details as needed
                          });
                          await FirebaseFirestore.instance
                              .collection('InvoiceNumber')
                              .doc(email)
                              .collection('OrderNums')
                              .doc('currentNumber')
                              .set({'number': 0});
                        } catch (e) {
                          print('Error adding user details to Database: $e');
                          // Handle the error appropriately
                        }
                        setState(() {
                          isLoading = false;
                        });
                        // ignore: use_build_context_synchronously
                        showDialog(
                            context: context,
                            builder: ((context) {
                              return PopUpBox(
                                  'Registration Successful', 'Congrats', () {
                                pressed();
                              });
                            }));
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                  ),
                  child: isLoading?const Stack(children: [Text('Register'),CircularProgressIndicator()],): const Text('Register'))
            ],
          ),
        ),
      ),
    );
  }
}
