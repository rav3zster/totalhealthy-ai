import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({Key? key}) : super(key: key);

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for form fields
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  // Sample FAQ data
  final List<FAQItem> _faqItems = [
    FAQItem(
      question: "How do I reset my password?",
      answer:
      "To reset your password, go to the login screen and click 'Forgot Password.' You will receive an email with instructions on how to create a new password.",
    ),
    FAQItem(
      question: "How can I track my order?",
      answer:
      "Once your order has shipped, you will receive an email with tracking information. You can use that information to track your package on the carrier’s website.",
    ),
    FAQItem(
      question: "What payment methods do you accept?",
      answer:
      "We accept credit cards, debit cards, PayPal, and select digital wallets. Check our payment options page for more details.",
    ),
    FAQItem(
      question: "What is your return policy?",
      answer:
      "We offer a 30-day return policy. If you are not satisfied with your purchase, please contact our support team to initiate a return.",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // We have two tabs
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Need Help?'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Contact Us'),
              Tab(text: 'FAQ'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // 1. Contact Us Tab
            SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Contact Details
                  _buildContactDetailsCard(),
                  const SizedBox(height: 16.0),
                  // Contact Form
                  _buildContactForm(),
                ],
              ),
            ),

            // 2. FAQ Tab
            SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: _buildFAQList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Builds a card displaying contact details
  Widget _buildContactDetailsCard() {
    return Column(
      children: [
        Align(
          alignment: Alignment.center,
          child: Text(
            "Need Help?",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
        ),
        Text(
          "We're here to help! Check out our FAQ's or get in touch with us directly.",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      child: _buildDetailRow(
                          Icons.phone_outlined, 'Phone', '+1 (555) 123-4567'),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black12)),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                    width: 8,
                  ),
                  Expanded(
                    child: Container(
                      child: _buildDetailRow(
                          Icons.email_outlined, 'Email', 'support@example.com'),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black12)),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      child: _buildDetailRow(
                        Icons.location_on_outlined,
                        'Address',
                        '123 Business Ave\nSuite 100\nNew York, NY 10001',
                      ),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black12)),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                    width: 8,
                  ),
                  Expanded(
                    child: Container(
                      child: _buildDetailRow(
                        Icons.access_time_outlined,
                        'Hours',
                        'Mon-Fri: 9am - 6pm\nSat: 10am - 4pm\nSun: Closed',
                      ),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black12)),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  // Helper widget for each row of detail
  Widget _buildDetailRow(IconData iconData, String name, String text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(iconData),
        const SizedBox(height: 5),
        Text(
          name,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        Text(text),
      ],
    );
  }

  // Builds the contact form
  Widget _buildContactForm() {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                "Get in Touch",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                // First Name
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "First Name",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      SizedBox(height: 5), // Spacing between text and field
                      TextFormField(
                        controller: _firstNameController,
                        decoration: InputDecoration(
                          labelText: 'John',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            // Rounded border when not focused
                            borderSide: BorderSide(
                                color: Colors.grey), // Normal border color
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            // Rounded border when focused
                            borderSide: BorderSide(
                                color: Colors.grey,
                                width: 2), // Focused border color and width
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your first name';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 20), // Space between First Name and Last Name
                // Last Name
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Last Name",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 5),
                      TextFormField(
                        controller: _lastNameController,
                        decoration: InputDecoration(
                          labelText: 'Doe',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            // Rounded border when not focused
                            borderSide: BorderSide(
                                color: Colors.grey), // Normal border color
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            // Rounded border when focused
                            borderSide: BorderSide(
                                color: Colors.grey,
                                width: 2), // Focused border color and width
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your last name';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Text(
              "Email",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            // Email
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'john@example.com',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  // Rounded border when not focused
                  borderSide:
                  BorderSide(color: Colors.grey), // Normal border color
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  // Rounded border when focused
                  borderSide: BorderSide(
                      color: Colors.grey,
                      width: 2), // Focused border color and width
                ),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                // You can add more email validation here if needed
                return null;
              },
            ),
            const SizedBox(height: 16.0),
            Text(
              "Subject",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            // Subject
            TextFormField(
              controller: _subjectController,
              decoration: const InputDecoration(
                labelText: 'How can we help?',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  // Rounded border when not focused
                  borderSide:
                  BorderSide(color: Colors.grey), // Normal border color
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  // Rounded border when focused
                  borderSide: BorderSide(
                      color: Colors.grey,
                      width: 2), // Focused border color and width
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a subject';
                }
                return null;
              },
            ),
            const SizedBox(height: 16.0),
            // Message
            Text(
              "Message",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            TextFormField(
              controller: _messageController,
              decoration: const InputDecoration(
                labelText: 'Tell us more about your inquiry...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  // Rounded border when not focused
                  borderSide:
                  BorderSide(color: Colors.grey), // Normal border color
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  // Rounded border when focused
                  borderSide: BorderSide(
                      color: Colors.grey,
                      width: 2), // Focused border color and width
                ),
              ),
              maxLines: 5,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your message';
                }
                return null;
              },
            ),
            const SizedBox(height: 16.0),
            // Submit Button
            Container(
              width: MediaQuery.sizeOf(context).width,
              child: ElevatedButton.icon(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white),
                icon: const Icon(Icons.chat_bubble_outline),
                label: const Text('Send Message'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Form submission logic
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // For now, just print the values. In a real app, you’d send these to your backend or an API.
      print('First Name: ${_firstNameController.text}');
      print('Last Name: ${_lastNameController.text}');
      print('Email: ${_emailController.text}');
      print('Subject: ${_subjectController.text}');
      print('Message: ${_messageController.text}');

      // Clear fields after submission if you want
      _firstNameController.clear();
      _lastNameController.clear();
      _emailController.clear();
      _subjectController.clear();
      _messageController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Message sent successfully!')),
      );
    }
  }

  // Builds a list of ExpansionTiles for FAQ items
  List<Widget> _buildFAQList() {
    return _faqItems.map((faqItem) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.black,
          border: Border.all( // Add a border that stays constant
            color: Colors.white,
          ),
          borderRadius: BorderRadius.circular(4), // Optional: rounded corners for a smoother look
        ),
        child: ExpansionTile(
          shape: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
          title: Text(faqItem.question),
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(faqItem.answer),
            ),
          ],
          onExpansionChanged: (isExpanded) {
            // This can be used if you want to handle anything specific when expanded or collapsed
          },
        ),
      );
    }).toList();
  }
}

// Simple model class for FAQ items
class FAQItem {
  final String question;
  final String answer;

  FAQItem({required this.question, required this.answer});
}