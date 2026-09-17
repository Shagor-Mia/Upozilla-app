/// `ContactRevealResponse` from the rate-limited contact-reveal endpoints.
class ContactReveal {
  const ContactReveal({required this.sellerName, required this.phone});

  final String sellerName;
  final String phone;

  factory ContactReveal.fromJson(Map<String, dynamic> json) => ContactReveal(
        sellerName: json['seller_name'] as String? ?? '',
        phone: json['phone'] as String? ?? '',
      );
}
