import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:next_meet/core/theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key, required this.profile});

  final Map<String, dynamic> profile;

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  static const _fields = {
    'full_name': 'Full name',
    'phone': 'Phone',
    'occupation': 'Occupation',
    'organization': 'Organization',
    'location': 'City or region',
    'website_url': 'Website URL',
    'bio': 'Bio',
    'linkedin_url': 'LinkedIn URL',
    'instagram_url': 'Instagram URL',
  };

  final _form = GlobalKey<FormState>();
  late final Map<String, TextEditingController> _controllers;
  Uint8List? _photo;
  bool _picking = false;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _controllers = {
      for (final key in _fields.keys)
        key: TextEditingController(text: widget.profile[key] as String?),
    };
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _message(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  Future<void> _pickPhoto() async {
    if (_picking || _saving) return;
    setState(() => _picking = true);
    try {
      final image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      if (image == null || !mounted) return;
      if (await image.length() > 5 * 1024 * 1024) {
        _message('Choose an image under 5 MB.');
        return;
      }
      final bytes = await image.readAsBytes();
      if (_imageType(bytes) == null) {
        _message('Choose a JPG, PNG, or WebP image.');
        return;
      }
      if (mounted) setState(() => _photo = bytes);
    } catch (_) {
      _message('Could not open the selected image.');
    } finally {
      if (mounted) setState(() => _picking = false);
    }
  }

  (String, String)? _imageType(Uint8List bytes) {
    if (bytes.length < 12) return null;
    if (bytes[0] == 255 && bytes[1] == 216 && bytes[2] == 255) {
      return ('jpg', 'image/jpeg');
    }
    if (bytes[0] == 137 && String.fromCharCodes(bytes.sublist(1, 4)) == 'PNG') {
      return ('png', 'image/png');
    }
    if (String.fromCharCodes(bytes.sublist(0, 4)) == 'RIFF' &&
        String.fromCharCodes(bytes.sublist(8, 12)) == 'WEBP') {
      return ('webp', 'image/webp');
    }
    return null;
  }

  Future<void> _save() async {
    if (_saving || _picking || !_form.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    final client = Supabase.instance.client;
    final user = client.auth.currentUser;
    if (user == null || user.id != widget.profile['id']) {
      _message('Sign in again to edit your profile.');
      return;
    }

    setState(() => _saving = true);
    try {
      final changes = <String, dynamic>{
        for (final entry in _controllers.entries)
          entry.key: entry.value.text.trim().isEmpty ? null : entry.value.text.trim(),
        'updated_at': DateTime.now().toUtc().toIso8601String(),
      };
      final photo = _photo;
      if (photo != null) {
        final (extension, contentType) = _imageType(photo)!;
        final stamp = DateTime.now().microsecondsSinceEpoch;
        final path = 'user profile photos/${user.id}/$stamp.$extension';
        final bucket = client.storage.from('profile-photos');
        await bucket.uploadBinary(path, photo, fileOptions: FileOptions(
          contentType: contentType,
        ));
        changes['avatar_url'] = bucket.getPublicUrl(path);
      }

      final saved = await client.from('profiles').update(changes)
          .eq('id', user.id).select().single();
      if (mounted) Navigator.of(context).pop(saved);
    } catch (error) {
      debugPrint('Profile save failed: $error');
      _message('Could not save your profile. Check your connection and try again.');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final url = (widget.profile['avatar_url'] as String? ?? '').trim();
    final photo = _photo;
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Form(
              key: _form,
              child: ListView(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: AppColors.secondaryDark,
                      foregroundImage: photo != null
                          ? MemoryImage(photo)
                          : url.isEmpty ? null : NetworkImage(url),
                      child: const Icon(Icons.person_outline, color: AppColors.gold, size: 42),
                    ),
                  ),
                  Center(
                    child: TextButton.icon(
                      onPressed: _saving || _picking ? null : _pickPhoto,
                      icon: const Icon(Icons.add_a_photo_outlined),
                      label: Text(_picking ? 'Opening gallery…' : 'Change profile photo'),
                    ),
                  ),
                  const SizedBox(height: 10),
                  _section('Personal information', [
                    _field('full_name', Icons.person_outline),
                    TextFormField(
                      initialValue: widget.profile['email'] as String?,
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email_outlined),
                        suffixIcon: Icon(Icons.lock_outline, size: 18),
                      ),
                    ),
                    _field('phone', Icons.phone_outlined, type: TextInputType.phone),
                    _field('bio', Icons.notes, lines: 3),
                  ]),
                  _section('Other details (optional)', [
                    _field('occupation', Icons.work_outline),
                    _field('organization', Icons.apartment_outlined),
                    _field('location', Icons.place_outlined),
                    _field('website_url', Icons.public, type: TextInputType.url),
                  ]),
                  _section('Social links', [
                    _field('linkedin_url', Icons.link, type: TextInputType.url),
                    _field('instagram_url', Icons.link, type: TextInputType.url),
                  ]),
                  FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.gold,
                      foregroundColor: Colors.black,
                      minimumSize: const Size.fromHeight(52),
                    ),
                    onPressed: _saving || _picking ? null : _save,
                    icon: _saving
                        ? const SizedBox.square(dimension: 18, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.check),
                    label: Text(_saving ? 'Saving…' : 'Save changes'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _section(String title, List<Widget> fields) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title, style: const TextStyle(
            color: AppColors.gold, fontSize: 16, fontWeight: FontWeight.w600,
          )),
          for (final field in fields)
            Padding(padding: const EdgeInsets.only(top: 12), child: field),
        ],
      ),
    );
  }

  Widget _field(String key, IconData icon, {TextInputType? type, int lines = 1}) {
    return TextFormField(
      controller: _controllers[key],
      readOnly: _saving,
      keyboardType: type,
      maxLines: lines,
      decoration: InputDecoration(labelText: _fields[key], prefixIcon: Icon(icon)),
      validator: (value) {
        final text = value?.trim() ?? '';
        if (key == 'full_name' && text.isEmpty) return 'Enter your name.';
        if (type == TextInputType.url && text.isNotEmpty) {
          final uri = Uri.tryParse(text);
          if (uri == null || !['http', 'https'].contains(uri.scheme) || uri.host.isEmpty) {
            return 'Enter a full link starting with https://.';
          }
        }
        return null;
      },
    );
  }
}
