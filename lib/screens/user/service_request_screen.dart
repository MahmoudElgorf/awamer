import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../../widgets/chat_screen_widgets/chat_form.dart';

class ServiceRequestScreen extends StatefulWidget {
  final String serviceName;
  final String imageAsset;
  final String? providerId;

  const ServiceRequestScreen({
    super.key,
    required this.serviceName,
    required this.imageAsset,
    required this.providerId,
  });

  @override
  State<ServiceRequestScreen> createState() => _ServiceRequestScreenState();
}

class _ServiceRequestScreenState extends State<ServiceRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _descriptionController = TextEditingController();
  XFile? _selectedImage;
  late String _userId;
  late String _userEmail;
  String? _providerFullName;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    _userId = user?.uid ?? '';
    _userEmail = user?.email ?? '';
    _loadUserData();
    if (widget.providerId != null) {
      _loadProviderName();
    }
  }

  Future<void> _loadUserData() async {
    final snapshot =
    await FirebaseFirestore.instance.collection('users').doc(_userId).get();
    if (snapshot.exists) {
      final data = snapshot.data()!;
      final firstName = data['firstName'] ?? '';
      final lastName = data['lastName'] ?? '';
      _nameController.text = '$firstName $lastName';
      _phoneController.text = data['phone'] ?? '';
      _addressController.text = data['address'] ?? '';
    }
  }

  Future<void> _loadProviderName() async {
    if (widget.providerId == null) return;
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.providerId)
        .get();
    if (snapshot.exists) {
      final data = snapshot.data()!;
      final firstName = data['firstName'] ?? '';
      final lastName = data['lastName'] ?? '';
      setState(() {
        _providerFullName = '$firstName $lastName';
      });
    }
  }

  Future<void> _sendRequest() async {
    if (!_formKey.currentState!.validate()) return;

    final nameParts = _nameController.text.trim().split(' ');
    final firstName = nameParts.isNotEmpty ? nameParts.first : '';
    final lastName =
    nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

    final requestId = const Uuid().v4();
    String? imageUrl;

    if (_selectedImage != null) {
      final ref = FirebaseStorage.instance
          .ref()
          .child('requests/${widget.providerId}/$requestId.jpg');

      final metadata = SettableMetadata(customMetadata: {
        'userId': _userId,
      });

      await ref.putData(await _selectedImage!.readAsBytes(), metadata);
      imageUrl = await ref.getDownloadURL();
    }

    final requestData = {
      'requestId': requestId,
      'userId': _userId,
      'userEmail': _userEmail,
      'providerId': widget.providerId,
      'service': widget.serviceName,
      'firstName': firstName,
      'lastName': lastName,
      'phone': _phoneController.text.trim(),
      'address': _addressController.text.trim(),
      'description': _descriptionController.text.trim(),
      'imageUrl': imageUrl,
      'status': 'pending',
      'timestamp': FieldValue.serverTimestamp(),
    };

    await FirebaseFirestore.instance
        .collection('requests')
        .doc(requestId)
        .set(requestData);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم إرسال الطلب بنجاح'),backgroundColor: Colors.green,),

    );
    Navigator.pop(context);
  }

  void _onImagePicked(XFile? image) {
    setState(() {
      _selectedImage = image;
    });
  }

  String _getServiceType() {
    final name = widget.serviceName.toLowerCase();
    if (name.contains('doctor')) return 'Doctors';
    if (name.contains('delivery')) return 'Delivery';
    if (name.contains('pharmacy')) return 'Pharmacies';
    if (name.contains('store')) return 'Stores';
    if (name.contains('restaurant')) return 'Restaurants';
    return 'Other';
  }

  @override
  Widget build(BuildContext context) {
    final serviceType = _getServiceType();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(_providerFullName ?? widget.serviceName),
        backgroundColor: const Color(0xFF4C9581),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ChatForm(
            serviceType: serviceType,
            nameController: _nameController,
            phoneController: _phoneController,
            addressController: _addressController,
            descriptionController: _descriptionController,
            onImagePicked: _onImagePicked,
            selectedImage: _selectedImage,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _sendRequest,
        icon: const Icon(Icons.send, color: Colors.white),
        label: const Text("إرسال الطلب", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF4C9581),
      ),
    );
  }
}
