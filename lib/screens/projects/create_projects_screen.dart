import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CreateProjectScreen extends StatefulWidget {
  final String creatorId;

  CreateProjectScreen({required this.creatorId});

  @override
  _CreateProjectScreenState createState() => _CreateProjectScreenState();
}

class _CreateProjectScreenState extends State<CreateProjectScreen> {
  final _formKey = GlobalKey<FormState>();

  String _title = '';
  String _description = '';
  String _detailedDescription = '';
  List<String> _skillsRequired = [];
  List<String> _milestones = [];
  bool _isOpenForFeedback = false;
  bool _isJobApplicationOpen = false;
  Map<String, dynamic>? _jobApplication; // Placeholder for jobApplication
  DateTime? _startDate;
  DateTime? _endDate;
  Map<String, String> _userRoles = {};
  List<String> _joinRequests = [];
  List<String> _feedbackComments = [];
  String _jurisdiction = '';
  int _yearsExperienceRequired = 0;
  List<String> _technicalSkills = [];
  List<String> _regulatoryExpertise = [];
  List<String> _financialStandards = [];
  List<String> _industryFocus = [];

  // Controllers for multi-input fields
  final _skillsController = TextEditingController();
  final _milestonesController = TextEditingController();
  final _technicalSkillsController = TextEditingController();
  final _regulatoryExpertiseController = TextEditingController();
  final _financialStandardsController = TextEditingController();
  final _industryFocusController = TextEditingController();
  final _jurisdictionController = TextEditingController();
  final _feedbackCommentsController = TextEditingController();
  final _joinRequestsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Project'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextField('Project Title', Icons.title, (value) {
                  _title = value!;
                }),
                _buildTextField('Project Description', Icons.description,
                    (value) {
                  _description = value!;
                }, maxLines: 4),
                _buildTextField('Detailed Description', Icons.article, (value) {
                  _detailedDescription = value!;
                }, maxLines: null),
                _buildMultiInputField(
                    'Skills Required', _skillsRequired, _skillsController),
                _buildMultiInputField(
                    'Milestones', _milestones, _milestonesController),
                _buildDateSelectors(),
                SizedBox(
                  height: 16,
                ),
                _buildTextField('Jurisdiction', Icons.public, (value) {
                  _jurisdiction = value!;
                }),
                _buildTextField(
                    'Years of Experience Required', Icons.access_time, (value) {
                  _yearsExperienceRequired = int.tryParse(value!) ?? 0;
                }, inputType: TextInputType.number),
                _buildMultiInputField('Technical Skills', _technicalSkills,
                    _technicalSkillsController),
                _buildMultiInputField('Regulatory Expertise',
                    _regulatoryExpertise, _regulatoryExpertiseController),
                _buildMultiInputField('Financial Standards',
                    _financialStandards, _financialStandardsController),
                _buildMultiInputField(
                    'Industry Focus', _industryFocus, _industryFocusController),
                _buildMultiInputField('Feedback Comments', _feedbackComments,
                    _feedbackCommentsController),
                _buildMultiInputField(
                    'Join Requests', _joinRequests, _joinRequestsController),
                _buildSwitch('Open for Feedback', _isOpenForFeedback, (value) {
                  setState(() {
                    _isOpenForFeedback = value;
                  });
                }),
                _buildSwitch('Job Application Open', _isJobApplicationOpen,
                    (value) {
                  setState(() {
                    _isJobApplicationOpen = value;
                  });
                }),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _saveProject,
                  child: Text('Create Project'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label, IconData icon, FormFieldSetter<String> onSaved,
      {int? maxLines = 1, TextInputType inputType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          prefixIcon: Icon(icon),
        ),
        onSaved: onSaved,
        keyboardType: inputType,
        maxLines: maxLines,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildMultiInputField(
      String label, List<String> list, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: controller,
            decoration: InputDecoration(
              labelText: '$label (comma separated)',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              list.clear();
              list.addAll(value.split(',').map((e) => e.trim()));
            },
          ),
          SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: list
                .map((item) => Chip(
                      label: Text(item),
                      onDeleted: () {
                        setState(() {
                          list.remove(item);
                          controller.text = list.join(', ');
                        });
                      },
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelectors() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () => _pickDate(true),
            child: Text(_startDate == null
                ? 'Select Start Date'
                : DateFormat('dd/MM/yyyy').format(_startDate!)),
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: () => _pickDate(false),
            child: Text(_endDate == null
                ? 'Select End Date'
                : DateFormat('dd/MM/yyyy').format(_endDate!)),
          ),
        ),
      ],
    );
  }

  Widget _buildSwitch(String label, bool value, ValueChanged<bool> onChanged) {
    return SwitchListTile(
      title: Text(label),
      value: value,
      onChanged: onChanged,
    );
  }

  Future<void> _pickDate(bool isStartDate) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: isStartDate
          ? (_startDate ?? DateTime.now())
          : (_endDate ?? DateTime.now()),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (selectedDate != null) {
      setState(() {
        if (isStartDate) {
          _startDate = selectedDate;
        } else {
          _endDate = selectedDate;
        }
      });
    }
  }

  void _saveProject() async {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Generate a new document ID for the project
      final projectId =
          FirebaseFirestore.instance.collection('projects').doc().id;

      final project = {
        'projectId': projectId, // Include the generated project ID
        'title': _title,
        'description': _description,
        'detailedDescription': _detailedDescription,
        'creatorId': widget.creatorId,
        'skillsRequired': _skillsRequired,
        'milestones': _milestones,
        'isOpenForFeedback': _isOpenForFeedback,
        'isJobApplicationOpen': _isJobApplicationOpen,
        'jobApplication': _isJobApplicationOpen ? _jobApplication : null,
        'startDate':
            _startDate != null ? Timestamp.fromDate(_startDate!) : null,
        'endDate': _endDate != null ? Timestamp.fromDate(_endDate!) : null,
        'userRoles': _userRoles,
        'joinRequests': _joinRequests,
        'feedbackComments': _isOpenForFeedback ? _feedbackComments : null,
        'jurisdiction': _jurisdiction,
        'yearsExperienceRequired': _yearsExperienceRequired,
        'technicalSkills': _technicalSkills,
        'regulatoryExpertise': _regulatoryExpertise,
        'financialStandards': _financialStandards,
        'industryFocus': _industryFocus,
      };

      try {
        // Use the generated ID to create the document
        await _firestore.collection('projects').doc(projectId).set(project);

        // Show a success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Project created successfully!')),
        );

        // Navigate back to the previous screen
        Navigator.pop(context);
      } catch (e) {
        // Show an error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error creating project: $e')),
        );
      }
    }
  }
}
