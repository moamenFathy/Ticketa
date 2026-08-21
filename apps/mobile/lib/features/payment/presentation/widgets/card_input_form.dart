import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ticketa/core/theme/app_colors.dart';

enum _CardBrand { visa, mastercard, amex, discover, unknown }

class CardInputForm extends StatefulWidget {
  const CardInputForm({super.key});

  @override
  State<CardInputForm> createState() => CardInputFormState();
}

class CardInputFormState extends State<CardInputForm> {
  final _formKey = GlobalKey<FormState>();
  final _numberCtrl = TextEditingController();
  final _expiryCtrl = TextEditingController();
  final _cvvCtrl = TextEditingController();
  final _holderCtrl = TextEditingController();

  _CardBrand _brand = _CardBrand.unknown;
  bool _submitAttempted = false;
  final Map<String, bool> _touched = {};

  bool _shouldValidate(String key) =>
      _submitAttempted || _touched[key] == true;

  void _markTouched(String key) {
    if (_touched[key] != true) {
      setState(() => _touched[key] = true);
    }
  }

  bool validateAll() {
    _submitAttempted = true;
    return _formKey.currentState?.validate() ?? false;
  }

  @override
  void dispose() {
    _numberCtrl.dispose();
    _expiryCtrl.dispose();
    _cvvCtrl.dispose();
    _holderCtrl.dispose();
    super.dispose();
  }

  _CardBrand get _brandOf =>
      _detectBrand(_numberCtrl.text.replaceAll(RegExp(r'\D'), ''));

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
            blurRadius: 15,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            _buildField(
              fieldKey: 'number',
              label: 'Card Number',
              controller: _numberCtrl,
              hint: 'XXXX XXXX XXXX XXXX',
              icon: Icons.payment_rounded,
              keyboard: TextInputType.number,
              inputFormatters: [_CardNumberFormatter(_detectBrand)],
              onChanged: () {
                final brand = _brandOf;
                if (brand != _brand) {
                  setState(() => _brand = brand);
                  _cvvCtrl.text = _cvvCtrl.text.replaceAll(RegExp(r'\D'), '');
                }
              },
              validator: _validateCardNumber,
              suffix: _CardBrandBadge(brand: _brand),
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildField(
                    fieldKey: 'expiry',
                    label: 'Expiry Date',
                    controller: _expiryCtrl,
                    hint: 'MM/YY',
                    icon: Icons.calendar_today_rounded,
                    keyboard: TextInputType.datetime,
                    inputFormatters: [_ExpiryFormatter()],
                    validator: _validateExpiry,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildField(
                    fieldKey: 'cvv',
                    label: 'CVV',
                    controller: _cvvCtrl,
                    hint: 'XXX',
                    icon: Icons.lock_outline_rounded,
                    keyboard: TextInputType.number,
                    inputFormatters: [_CvvFormatter(() => _brandOf)],
                    validator: _validateCvv,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildField(
              fieldKey: 'holder',
              label: 'Card Holder',
              controller: _holderCtrl,
              hint: 'FULL NAME',
              icon: Icons.person_outline_rounded,
              keyboard: TextInputType.name,
              textCapitalization: TextCapitalization.characters,
              validator: _validateHolder,
            ),
          ],
        ),
      ),
    );
  }

  String? _validateCardNumber(String? value) {
    final digits = value?.replaceAll(RegExp(r'\D'), '') ?? '';
    if (!_shouldValidate('number')) return null;
    if (digits.isEmpty) return 'Card number is required';
    if (_brand == _CardBrand.amex && digits.length != 15) {
      return 'Amex cards have 15 digits';
    }
    if (digits.length != 16) {
      return 'Card must have 16 digits';
    }
    if (!_luhnValid(digits)) return 'Invalid card number';
    return null;
  }

  String? _validateExpiry(String? value) {
    final clean = value?.replaceAll(RegExp(r'\D'), '') ?? '';
    if (!_shouldValidate('expiry')) return null;
    if (clean.length != 4) return 'Use MM/YY';
    final month = int.tryParse(clean.substring(0, 2)) ?? 0;
    final year = 2000 + (int.tryParse(clean.substring(2)) ?? 0);
    if (month < 1 || month > 12) return 'Invalid month';
    final now = DateTime.now();
    if (year < now.year || (year == now.year && month < now.month)) {
      return 'Card is expired';
    }
    return null;
  }

  String? _validateCvv(String? value) {
    final clean = value?.replaceAll(RegExp(r'\D'), '') ?? '';
    if (!_shouldValidate('cvv')) return null;
    final expected = _brand == _CardBrand.amex ? 4 : 3;
    if (clean.isEmpty) return 'CVV is required';
    if (clean.length != expected) {
      return _brand == _CardBrand.amex ? '4 digits' : '3 digits';
    }
    return null;
  }

  String? _validateHolder(String? value) {
    final name = value?.trim() ?? '';
    if (!_shouldValidate('holder')) return null;
    if (name.isEmpty) return 'Name is required';
    if (name.length < 3) return 'Enter full name';
    return null;
  }

  Widget _buildField({
    required String fieldKey,
    required String label,
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required TextInputType keyboard,
    required String? Function(String?) validator,
    List<TextInputFormatter> inputFormatters = const [],
    VoidCallback? onChanged,
    Widget? suffix,
    TextCapitalization textCapitalization = TextCapitalization.none,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.5),
              fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboard,
          textCapitalization: textCapitalization,
          inputFormatters: inputFormatters,
          onChanged: (_) {
            onChanged?.call();
            _markTouched(fieldKey);
          },
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(fontWeight: FontWeight.bold, letterSpacing: 0.5),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.15)),
            prefixIcon: Icon(icon,
                size: 18, color: AppColors.warmOrange.withValues(alpha: 0.6)),
            suffixIcon: suffix,
            suffixIconConstraints:
                const BoxConstraints(minWidth: 48, minHeight: 32),
            filled: true,
            fillColor:
                Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.05),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.08)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide:
                  BorderSide(color: AppColors.warmOrange, width: 1.6),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.red.shade400, width: 1.2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.red.shade400, width: 1.6),
            ),
            errorStyle: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Colors.red.shade300, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}

class _CardBrandBadge extends StatelessWidget {
  const _CardBrandBadge({required this.brand});

  final _CardBrand brand;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (brand) {
      _CardBrand.visa => ('VISA', const Color(0xFF1A1F71)),
      _CardBrand.mastercard => ('MASTERCARD', const Color(0xFFEB001B)),
      _CardBrand.amex => ('AMEX', const Color(0xFF2E77BC)),
      _CardBrand.discover => ('DISCOVER', const Color(0xFFF68121)),
      _CardBrand.unknown => ('CARD', Colors.grey),
    };

    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: Container(
          key: ValueKey(label),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 9,
              fontWeight: FontWeight.w900,
              fontStyle: FontStyle.italic,
              letterSpacing: 0.4,
            ),
          ),
        ),
      ),
    );
  }
}

_CardBrand _detectBrand(String digits) {
  if (digits.startsWith('4')) return _CardBrand.visa;
  if (digits.startsWith('34') || digits.startsWith('37')) {
    return _CardBrand.amex;
  }
  if (RegExp(r'^5[1-5]|^2[2-7]').hasMatch(digits)) return _CardBrand.mastercard;
  if (digits.startsWith('60') || digits.startsWith('65')) {
    return _CardBrand.discover;
  }
  return _CardBrand.unknown;
}

bool _luhnValid(String digits) {
  var sum = 0;
  var alternate = false;
  for (var i = digits.length - 1; i >= 0; i--) {
    var d = digits.codeUnitAt(i) - 48;
    if (alternate) {
      d *= 2;
      if (d > 9) d -= 9;
    }
    sum += d;
    alternate = !alternate;
  }
  return sum % 10 == 0;
}

class _CardNumberFormatter extends TextInputFormatter {
  final _CardBrand Function(String) _brandOf;

  _CardNumberFormatter(this._brandOf);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    final brand = _brandOf(digits);
    final maxLen = switch (brand) {
      _CardBrand.amex => 15,
      _CardBrand.visa => 16,
      _ => 16,
    };
    final limited =
        digits.length > maxLen ? digits.substring(0, maxLen) : digits;
    final text = _group(limited, brand).join(' ');
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }

  static List<String> _group(String digits, _CardBrand brand) {
    if (brand == _CardBrand.amex) {
      return [
        if (digits.length > 4) digits.substring(0, 4) else digits,
        if (digits.length > 4 && digits.length <= 10)
          digits.substring(4)
        else if (digits.length > 4)
          digits.substring(4, 10),
        if (digits.length > 10) digits.substring(10),
      ];
    }
    return digits
        .split('')
        .fold<List<String>>([''], (groups, c) {
          if (groups.last.length < 4) {
            groups.last += c;
          } else {
            groups.add(c);
          }
          return groups;
        })
        .where((g) => g.isNotEmpty)
        .toList();
  }
}

class _ExpiryFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    final limited = digits.length > 4 ? digits.substring(0, 4) : digits;
    final text = limited.length >= 3
        ? '${limited.substring(0, 2)}/${limited.substring(2)}'
        : limited;
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}

class _CvvFormatter extends TextInputFormatter {
  final _CardBrand Function() _brandOf;

  _CvvFormatter(this._brandOf);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    final maxLen = _brandOf() == _CardBrand.amex ? 4 : 3;
    final limited = digits.length > maxLen ? digits.substring(0, maxLen) : digits;
    return TextEditingValue(
      text: limited,
      selection: TextSelection.collapsed(offset: limited.length),
    );
  }
}