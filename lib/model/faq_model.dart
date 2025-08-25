import 'dart:convert';

// This file defines the data models for the FAQ API response.

// The `Faq` class represents a single FAQ item with its question and answer.
// The `fromJson` factory constructor is used to create a `Faq` object from a JSON map.
class Faq {
  final int id;
  final String question;
  final String answer;
  final String createdAt;

  Faq({
    required this.id,
    required this.question,
    required this.answer,
    required this.createdAt,
  });

  // Factory constructor to create a `Faq` instance from a JSON map.
  factory Faq.fromJson(Map<String, dynamic> json) {
    return Faq(
      id: json['id'],
      question: json['question'],
      answer: json['answer'],
      createdAt: json['created_at'],
    );
  }
}

// The `FaqsResponse` class represents the top-level structure of the API response.
// It contains the status, message, and a list of `Faq` objects.
// This helps in easily handling the entire JSON payload.
class FaqsResponse {
  final bool status;
  final int statusCode;
  final String message;
  final List<Faq> faqs;

  FaqsResponse({
    required this.status,
    required this.statusCode,
    required this.message,
    required this.faqs,
  });

  // Factory constructor to create a `FaqsResponse` instance from a JSON map.
  factory FaqsResponse.fromJson(Map<String, dynamic> json) {
    // Deserialize the list of FAQs from the 'faqs' key.
    // We map each JSON item in the list to a `Faq` object using `Faq.fromJson`.
    var faqsList = json['faqs'] as List;
    List<Faq> faqs = faqsList.map((i) => Faq.fromJson(i)).toList();

    return FaqsResponse(
      status: json['status'],
      statusCode: json['status_code'],
      message: json['message'],
      faqs: faqs,
    );
  }
}
