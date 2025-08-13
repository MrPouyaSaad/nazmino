import 'package:equatable/equatable.dart';

class Transaction extends Equatable {
  final String? id;
  final String title;
  final double amount;
  final bool isInCome;
  final int categoryId;
  final DateTime date;
  final bool isDeleting;

  const Transaction(
    this.id,
    this.title,
    this.amount,
    this.isInCome,
    this.categoryId,
    this.date, {
    this.isDeleting = false,
  });

  Transaction copyWith({
    String? id,
    String? title,
    double? amount,
    bool? isInCome,
    int? categoryId,
    DateTime? date,
    bool? isLoading,
  }) {
    return Transaction(
      id ?? this.id,
      title ?? this.title,
      amount ?? this.amount,
      isInCome ?? this.isInCome,
      categoryId ?? this.categoryId,
      date ?? this.date,
      isDeleting: isLoading ?? isDeleting,
    );
  }

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      json['id'].toString(),
      json['title'],
      _toDouble(json['amount']),
      _toBool(json['type']),
      json['category_id'],
      json['date'] != null
          ? DateTime.parse(json['date'].toString())
          : DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    amount,
    isInCome,
    categoryId,
    date,
    isDeleting,
  ];
}

double _toDouble(dynamic value) {
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.parse(value);
  throw Exception('Cannot convert $value to double');
}

bool _toBool(dynamic value) {
  if (value is bool) return value;
  if (value is String) return value == 'expense' ? false : true;
  if (value is int) return value == 0 ? false : true;
  return false;
}
