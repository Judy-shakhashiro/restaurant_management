import 'package:flutter/material.dart';
import 'package:flutter_application_restaurant/core/static/global_lotti.dart';
import 'package:get/get.dart';
import '../controller/faq_controller.dart';
import '../model/faq_model.dart';

class FaqItem extends StatefulWidget {
  final Faq faq;

  const FaqItem({super.key, required this.faq});

  @override
  State<FaqItem> createState() => _FaqItemState();
}

class _FaqItemState extends State<FaqItem> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _heightFactor;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _heightFactor = _controller.drive(CurveTween(curve: Curves.easeInCubic));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: <Widget>[
          InkWell(
            onTap: _handleTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.faq.question,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  RotationTransition(
                    turns: Tween<double>(begin: 0.0, end: 0.5).animate(_controller),
                    child: const Icon(
                      Icons.keyboard_arrow_down,
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return ClipRect(
                child: Align(
                  alignment: Alignment.topCenter,
                  heightFactor: _heightFactor.value,
                  child: child,
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Text(
                widget.faq.answer,
                textAlign: TextAlign.start,
                style: const TextStyle(
                  fontSize: 14,

                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FaqView extends StatelessWidget {
  const FaqView({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the FaqController.
    final FaqController faqController = Get.put(FaqController());

    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5), // Light gray background
      appBar: AppBar(
        title: const Text(
          'FAQs',
        ),
 elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              faqController.fetchFaqs();
            },
          ),
        ],
      ),
      // Obx widget is a simple reactive builder that listens to an Rx variable.
      body: Obx(() {
        // Check for loading state.
        if (faqController.isLoading.value) {
          return MyLottiLoading();
        }

        if (faqController.errorMessage.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 48),
                const SizedBox(height: 16),
                Text(
                  faqController.errorMessage.value,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                ),
                const SizedBox(height: 16),
                // Add a button to manually retry fetching data.
                ElevatedButton.icon(
                  onPressed: () => faqController.fetchFaqs(),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Try Again'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE74C3C), 
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
              ],
            ),
          );
        }

        // Check if the list of FAQs is empty.
        if (faqController.faqs.isEmpty) {
          return MyLottiNodata();
        }

        // Wrap the ListView in a RefreshIndicator for pull-to-refresh functionality.
        return RefreshIndicator(
          onRefresh: () => faqController.fetchFaqs(),
          color:  Colors.deepOrange,
          child: ListView.builder(
            itemCount: faqController.faqs.length,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            itemBuilder: (context, index) {
              final faq = faqController.faqs[index];
              return FaqItem(faq: faq);
            },
          ),
        );
      }),
    );
  }
}
