import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'news_model.dart';

class AddEditNewsScreen extends StatefulWidget {
  final News? news;

  const AddEditNewsScreen({super.key, this.news, required News});

  @override
  // ignore: library_private_types_in_public_api
  _AddEditNewsScreenState createState() => _AddEditNewsScreenState();
}

class _AddEditNewsScreenState extends State<AddEditNewsScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String _name;
  late int _age;
  late String _address;

  @override
  void initState() {
    super.initState();
    if (widget.news != null) {
      _name = widget.news!.name;
      _age = widget.news!.age;
      _address = widget.news!.address;
    } else {
      _name = '';
      _age = 0;
      _address = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.news != null ? 'Edit News' : 'Add News'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                initialValue: _name,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter name';
                  }
                  return null;
                },
                onSaved: (value) => _name = value!,
              ),
              TextFormField(
                initialValue: _age.toString(),
                decoration: const InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter age';
                  }
                  return null;
                },
                onSaved: (value) => _age = int.parse(value!),
              ),
              TextFormField(
                initialValue: _address,
                decoration: const InputDecoration(labelText: 'Address'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter address';
                  }
                  return null;
                },
                onSaved: (value) => _address = value!,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                child: const Text('Save'),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    CollectionReference newsCollection = FirebaseFirestore.instance.collection('news');
                    if (widget.news != null) {
                      // Update
                      await newsCollection.doc(widget.news!.id).update({
                        'name': _name,
                        'age': _age,
                        'address': _address,
                      });
                    } else {
                      // Create
                      await newsCollection.add({
                        'name': _name,
                        'age': _age,
                        'address': _address,
                      });
                    }
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
