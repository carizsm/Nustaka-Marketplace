import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart'; // Pastikan baris ini tidak dikomentari
import '../../models/user.dart';
import '../../services/api_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ubah Profil Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF8CAC2B), // hijau seperti di screenshot
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF8CAC2B),
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      home: const UbahProfilPage(),
    );
  }
}

class UbahProfilPage extends StatefulWidget {
  const UbahProfilPage({Key? key}) : super(key: key);

  @override
  State<UbahProfilPage> createState() => _UbahProfilPageState();
}

class _UbahProfilPageState extends State<UbahProfilPage> {
  final ApiService apiService = ApiService();
  User? user;
  bool isLoading = true;
  String? errorMessage;

  String editedUsername = '';
  String editedBio = '';
  String editedEmail = '';
  String editedPhoneNumber = '';
  String editedGender = '';
  DateTime? editedBirthDate;
  String editedAddress = '';

  @override
  void initState() {
    super.initState();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    try {
      final data = await apiService.getProfile();
      setState(() {
        user = data;
        editedUsername = data.username ?? '';
        editedBio = data.bio ?? '';
        editedEmail = data.email ?? '';
        editedPhoneNumber = data.phoneNumber ?? '';
        editedGender = data.gender ?? '';
        editedBirthDate = data.birthDate;
        editedAddress = data.address ?? '';
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  // Dialog edit text
  Future<void> _editTextField({
    required String title,
    required String initialValue,
    required ValueChanged<String> onChanged,
    String? hintText,
    TextInputType? keyboardType,
  }) async {
    final controller = TextEditingController(text: initialValue);
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Ubah $title'),
        content: TextField(
          controller: controller,
          autofocus: true,
          keyboardType: keyboardType,
          decoration: InputDecoration(hintText: hintText ?? title),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              onChanged(controller.text.trim());
              Navigator.pop(context);
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  // Dialog pilih gender
  Future<void> _editGender() async {
    String? selected = editedGender;
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pilih Jenis Kelamin'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              value: 'male',
              groupValue: selected,
              title: const Text('Pria'),
              onChanged: (val) {
                setState(() => editedGender = val ?? ''); // Handle null case for safety
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              value: 'female',
              groupValue: selected,
              title: const Text('Wanita'),
              onChanged: (val) {
                setState(() => editedGender = val ?? ''); // Handle null case for safety
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  // Dialog pilih tanggal lahir
  Future<void> _editBirthDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: editedBirthDate ?? DateTime(2000, 1, 1),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      helpText: 'Pilih Tanggal Lahir',
    );
    if (picked != null) {
      setState(() => editedBirthDate = picked);
    }
  }

  Future<void> _pickAndUploadAvatar() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (picked == null) return;

    setState(() => isLoading = true);
    try {
      final updatedUser = await apiService.updateAvatar(File(picked.path));
      setState(() {
        user = updatedUser;
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Foto profil berhasil diperbarui')),
      );
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memperbarui foto profil: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Ubah Profil'),
      ),
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : errorMessage != null
                ? Center(
                    child: Text(
                      'Gagal memuat profil:\n$errorMessage',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red),
                    ),
                  )
                : user == null
                    ? const Center(child: Text('Profil tidak ditemukan'))
                    : LayoutBuilder(
                        builder: (context, constraints) {
                          return SingleChildScrollView(
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                minHeight: constraints.maxHeight,
                              ),
                              child: IntrinsicHeight(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    // Foto Profil
                                    Container(
                                      color: Colors.white,
                                      padding: const EdgeInsets.symmetric(vertical: 24),
                                      alignment: Alignment.center,
                                      child: Column(
                                        children: [
                                          CircleAvatar(
                                            radius: 48,
                                            backgroundColor: Colors.grey.shade300,
                                            backgroundImage: (user?.profilePictureUrl != null && user!.profilePictureUrl!.isNotEmpty)
                                                ? NetworkImage(user!.profilePictureUrl!)
                                                : null,
                                            child: (user?.profilePictureUrl == null || user!.profilePictureUrl!.isEmpty)
                                                ? Icon(
                                                    Icons.person_outline,
                                                    size: 48,
                                                    color: Colors.grey.shade600,
                                                  )
                                                : null,
                                          ),
                                          const SizedBox(height: 12),
                                          GestureDetector(
                                            onTap: isLoading ? null : _pickAndUploadAvatar,
                                            child: Text(
                                              'Ubah Foto Profil',
                                              style: TextStyle(
                                                color: const Color(0xFF8CAC2B),
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                decoration: TextDecoration.underline,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Divider(height: 1),

                                    // Info Profil
                                    Container(
                                      color: Colors.white,
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Info Profil',
                                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                          ),
                                          const SizedBox(height: 16),
                                          _buildFieldRow(
                                            label: 'Nama',
                                            value: user?.name ?? '',
                                            placeholder: '',
                                            canEdit: false,
                                            onTap: () {},
                                          ),
                                          const SizedBox(height: 8),
                                          _buildFieldRow(
                                            label: 'Username',
                                            value: editedUsername.isNotEmpty
                                                ? editedUsername
                                                : (user?.username ?? ''),
                                            placeholder: 'Tambah username',
                                            canEdit: true,
                                            onTap: () async {
                                              await _editTextField(
                                                title: 'Username',
                                                initialValue: editedUsername.isNotEmpty
                                                    ? editedUsername
                                                    : (user?.username ?? ''),
                                                onChanged: (val) => setState(() => editedUsername = val),
                                              );
                                            },
                                          ),
                                          const SizedBox(height: 8),
                                          _buildFieldRow(
                                            label: 'Bio',
                                            value: editedBio.isNotEmpty
                                                ? editedBio
                                                : (user?.bio ?? ''),
                                            placeholder: 'Tulis bio tentangmu',
                                            canEdit: true,
                                            onTap: () async {
                                              await _editTextField(
                                                title: 'Bio',
                                                initialValue: editedBio.isNotEmpty
                                                    ? editedBio
                                                    : (user?.bio ?? ''),
                                                onChanged: (val) => setState(() => editedBio = val),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Divider(height: 1),

                                    // Info Pribadi
                                    Container(
                                      color: Colors.white,
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Info Pribadi',
                                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                          ),
                                          const SizedBox(height: 16),
                                          _buildFieldRow(
                                            label: 'User ID',
                                            value: user?.id ?? '',
                                            placeholder: '',
                                            canEdit: false,
                                            onTap: () {},
                                          ),
                                          const SizedBox(height: 8),
                                          _buildFieldRow(
                                            label: 'E-mail',
                                            value: editedEmail.isNotEmpty
                                                ? editedEmail
                                                : (user?.email ?? ''),
                                            placeholder: 'Tambah E-mail',
                                            canEdit: true,
                                            onTap: () async {
                                              await _editTextField(
                                                title: 'E-mail',
                                                initialValue: editedEmail.isNotEmpty
                                                    ? editedEmail
                                                    : (user?.email ?? ''),
                                                keyboardType: TextInputType.emailAddress,
                                                onChanged: (val) => setState(() => editedEmail = val),
                                              );
                                            },
                                          ),
                                          const SizedBox(height: 8),
                                          _buildFieldRow(
                                            label: 'Nomor HP',
                                            value: editedPhoneNumber.isNotEmpty
                                                ? editedPhoneNumber
                                                : (user?.phoneNumber ?? ''),
                                            placeholder: 'Tambah nomor HP',
                                            canEdit: true,
                                            onTap: () async {
                                              await _editTextField(
                                                title: 'Nomor HP',
                                                initialValue: editedPhoneNumber.isNotEmpty
                                                    ? editedPhoneNumber
                                                    : (user?.phoneNumber ?? ''),
                                                keyboardType: TextInputType.phone,
                                                onChanged: (val) => setState(() => editedPhoneNumber = val),
                                              );
                                            },
                                          ),
                                          const SizedBox(height: 8),
                                          _buildFieldRow(
                                            label: 'Jenis Kelamin',
                                            value: (editedGender.isNotEmpty
                                                    ? editedGender
                                                    : (user?.gender ?? '')) ==
                                                    'male'
                                                ? 'Pria'
                                                : (editedGender.isNotEmpty
                                                        ? editedGender
                                                        : (user?.gender ?? '')) ==
                                                    'female'
                                                ? 'Wanita'
                                                : '',
                                            placeholder: 'Pilih jenis kelamin',
                                            canEdit: true,
                                            onTap: () async {
                                              await _editGender();
                                            },
                                          ),
                                          const SizedBox(height: 8),
                                          _buildFieldRow(
                                            label: 'Tanggal Lahir',
                                            value: (editedBirthDate ?? user?.birthDate) != null
                                                ? _formatDate(editedBirthDate ?? user!.birthDate!)
                                                : '',
                                            placeholder: 'Tambah tanggal lahir',
                                            canEdit: true,
                                            onTap: () async {
                                              await _editBirthDate();
                                            },
                                          ),
                                          const SizedBox(height: 8),
                                          _buildFieldRow(
                                            label: 'Alamat',
                                            value: editedAddress.isNotEmpty
                                                ? editedAddress
                                                : (user?.address ?? ''),
                                            placeholder: 'Tambah alamat',
                                            canEdit: true,
                                            onTap: () async {
                                              await _editTextField(
                                                title: 'Alamat',
                                                initialValue: editedAddress.isNotEmpty
                                                    ? editedAddress
                                                    : (user?.address ?? ''),
                                                onChanged: (val) => setState(() => editedAddress = val),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Divider(height: 1),

                                    const SizedBox(height: 24),

                                    // Tombol aksi bawah
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: OutlinedButton(
                                              onPressed: () async {
                                                try {
                                                  setState(() => isLoading = true);
                                                  await apiService.logout();
                                                  setState(() => isLoading = false);
                                                  if (mounted) {
                                                    Navigator.of(context).popUntil((route) => route.isFirst);
                                                  }
                                                } catch (e) {
                                                  setState(() => isLoading = false);
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(content: Text('Gagal logout: $e')),
                                                  );
                                                }
                                              },
                                              style: OutlinedButton.styleFrom(
                                                side: const BorderSide(
                                                  color: Color(0xFFB74D0E),
                                                  width: 2,
                                                ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                                padding: const EdgeInsets.symmetric(vertical: 14),
                                              ),
                                              child: const Text(
                                                'Keluar',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  color: Color(0xFFB74D0E),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: ElevatedButton(
                                              onPressed: isLoading
                                                  ? null
                                                  : () async {
                                                      setState(() => isLoading = true);
                                                      try {
                                                        final updatedUser = await apiService.updateProfile(
                                                          username: editedUsername,
                                                          bio: editedBio,
                                                          email: editedEmail,
                                                          phoneNumber: editedPhoneNumber,
                                                          gender: editedGender,
                                                          birthDate: editedBirthDate,
                                                          address: editedAddress,
                                                        );
                                                        setState(() {
                                                          // Perbarui user dan field editable dengan data baru dari server
                                                          user = updatedUser;
                                                          editedUsername = updatedUser.username ?? '';
                                                          editedBio = updatedUser.bio ?? '';
                                                          editedEmail = updatedUser.email ?? '';
                                                          editedPhoneNumber = updatedUser.phoneNumber ?? '';
                                                          editedGender = updatedUser.gender ?? '';
                                                          editedBirthDate = updatedUser.birthDate;
                                                          editedAddress = updatedUser.address ?? '';
                                                          isLoading = false;
                                                        });
                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                          const SnackBar(content: Text('Profil berhasil diperbarui')),
                                                        );
                                                      } catch (e) {
                                                        setState(() => isLoading = false);
                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                          SnackBar(content: Text('Gagal memperbarui profil: $e')),
                                                        );
                                                      }
                                                    },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Color(0xFF8CAC2B),
                                                foregroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                                padding: const EdgeInsets.symmetric(vertical: 14),
                                              ),
                                              child: isLoading
                                                  ? const SizedBox(
                                                      width: 18,
                                                      height: 18,
                                                      child: CircularProgressIndicator(
                                                        color: Colors.white,
                                                        strokeWidth: 2,
                                                      ),
                                                    )
                                                  : const Text(
                                                      'Simpan',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
      ),
    );
  }

  Widget _buildFieldRow({
    required String label,
    required String value,
    required String placeholder,
    required bool canEdit,
    required VoidCallback onTap,
  }) {
    final bool hasValue = value.trim().isNotEmpty;
    return InkWell(
      onTap: canEdit ? onTap : null,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            SizedBox(
              width: 100,
              child: Text(
                label,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                ),
              ),
            ),
            Expanded(
              child: Text(
                hasValue ? value : placeholder,
                style: TextStyle(
                  color: hasValue ? Colors.black87 : Colors.grey.shade400,
                  fontSize: 14,
                  fontWeight: hasValue ? FontWeight.w500 : FontWeight.normal,
                ),
              ),
            ),
            if (canEdit)
              Icon(
                Icons.chevron_right,
                color: Colors.grey.shade400,
              ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    try {
      return "${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}";
    } catch (_) {
      return '';
    }
  }
}