/// `FaqResponse` (already locale-resolved server-side, Section 22.2 pattern).
class Faq {
  const Faq({required this.id, required this.question, required this.answer, required this.status});

  final String id;
  final String question;
  final String answer;
  final String status;

  factory Faq.fromJson(Map<String, dynamic> json) => Faq(
        id: json['id'] as String,
        question: json['question'] as String? ?? '',
        answer: json['answer'] as String? ?? '',
        status: json['status'] as String? ?? 'published',
      );
}
