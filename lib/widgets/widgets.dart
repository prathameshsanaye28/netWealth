// lib/widgets/filter_sheet.dart
import 'package:flutter/material.dart';
import 'package:netwealth_vjti/models/professional.dart';

class FilterSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Filter Matches',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          SizedBox(height: 16),
          // Add your filter options here
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Apply Filters'),
          ),
        ],
      ),
    );
  }
}

// lib/widgets/empty_matches_view.dart
class EmptyMatchesView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_outline, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'No matches found',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Text(
            'Try adjusting your filters or updating your profile',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class ProfileEditor extends StatefulWidget {
  final Professional profile;
  final Function(Professional) onSave;

  const ProfileEditor({
    Key? key,
    required this.profile,
    required this.onSave,
  }) : super(key: key);

  @override
  _ProfileEditorState createState() => _ProfileEditorState();
}

class _ProfileEditorState extends State<ProfileEditor> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.profile.name);
    emailController = TextEditingController(text: widget.profile.email);
    phoneController = TextEditingController(text: widget.profile.phone);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: nameController,
          decoration: InputDecoration(labelText: 'Name'),
        ),
        SizedBox(height: 16),
        TextField(
          controller: emailController,
          decoration: InputDecoration(labelText: 'Email'),
        ),
        SizedBox(height: 16),
        TextField(
          controller: phoneController,
          decoration: InputDecoration(labelText: 'Phone'),
        ),
        SizedBox(height: 24),
        ElevatedButton(
          onPressed: _saveProfile,
          child: Text('Save Profile'),
        ),
      ],
    );
  }

  void _saveProfile() {
    final updatedProfile = Professional(
      id: widget.profile.id,
      name: nameController.text,
      email: emailController.text,
      phone: phoneController.text,
      jurisdiction: widget.profile.jurisdiction,
      yearsExperience: widget.profile.yearsExperience,
      technicalSkills: widget.profile.technicalSkills,
      regulatoryExpertise: widget.profile.regulatoryExpertise,
      financialStandards: widget.profile.financialStandards,
      industryFocus: widget.profile.industryFocus,
    );
    widget.onSave(updatedProfile);
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }
}


class ProfessionalDetails extends StatelessWidget {
  final Professional professional;

  const ProfessionalDetails({
    Key? key,
    required this.professional,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            professional.name ?? 'No Name',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          SizedBox(height: 8),
          Text(
            '${professional.jurisdiction} • ${professional.yearsExperience}y exp',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          SizedBox(height: 16),
          _buildSection('Technical Skills', professional.technicalSkills),
          _buildSection('Regulatory Expertise', professional.regulatoryExpertise),
          _buildSection('Financial Standards', professional.financialStandards),
          _buildSection('Industry Focus', professional.industryFocus),
          SizedBox(height: 16),
          if (professional.email != null)
            ListTile(
              leading: Icon(Icons.email),
              title: Text(professional.email!),
            ),
          if (professional.phone != null)
            ListTile(
              leading: Icon(Icons.phone),
              title: Text(professional.phone!),
            ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<String> items) {
    if (items.isEmpty) return SizedBox.shrink();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        SizedBox(height: 4),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: items.map((item) => Chip(label: Text(item))).toList(),
        ),
        SizedBox(height: 16),
      ],
    );
  }
}