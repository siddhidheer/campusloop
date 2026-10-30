import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/campus_theme.dart';

/// Modal dialog for verifying a 6-digit email One-Time Password (OTP).
/// Includes real-time 5-minute expiration countdown, 60-second resend cooldown,
/// and security feedback for incorrect attempts or expired codes.
class EmailOtpDialog extends StatefulWidget {
  final String email;
  final Future<void> Function(String otp) onVerify;
  final Future<String?> Function() onResend;

  const EmailOtpDialog({
    super.key,
    required this.email,
    required this.onVerify,
    required this.onResend,
  });

  static Future<bool?> show(
    BuildContext context, {
    required String email,
    required Future<void> Function(String otp) onVerify,
    required Future<String?> Function() onResend,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => EmailOtpDialog(
        email: email,
        onVerify: onVerify,
        onResend: onResend,
      ),
    );
  }

  @override
  State<EmailOtpDialog> createState() => _EmailOtpDialogState();
}

class _EmailOtpDialogState extends State<EmailOtpDialog> {
  final _otpController = TextEditingController();
  final _focusNode = FocusNode();

  // Expiration countdown (5 minutes = 300 seconds)
  int _expireSecondsRemaining = 300;
  Timer? _expireTimer;

  // Resend cooldown (60 seconds)
  int _resendCooldownSeconds = 60;
  Timer? _resendCooldownTimer;

  bool _isSubmitting = false;
  bool _isResending = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _startExpireTimer();
    _startResendTimer();
  }

  @override
  void dispose() {
    _expireTimer?.cancel();
    _resendCooldownTimer?.cancel();
    _otpController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _startExpireTimer() {
    _expireTimer?.cancel();
    _expireSecondsRemaining = 300;
    _expireTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        if (_expireSecondsRemaining > 0) {
          _expireSecondsRemaining--;
        } else {
          timer.cancel();
          _errorMessage =
              'Verification code has expired. Please tap "Resend Code".';
        }
      });
    });
  }

  void _startResendTimer() {
    _resendCooldownTimer?.cancel();
    _resendCooldownSeconds = 60;
    _resendCooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        if (_resendCooldownSeconds > 0) {
          _resendCooldownSeconds--;
        } else {
          timer.cancel();
        }
      });
    });
  }

  String _formatTimer(int totalSeconds) {
    final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  Future<void> _handleVerify() async {
    final code = _otpController.text.trim();
    if (code.length != 6) {
      setState(() => _errorMessage = 'Please enter the complete 6-digit code.');
      return;
    }

    if (_expireSecondsRemaining <= 0) {
      setState(() => _errorMessage =
          'Verification code has expired. Please request a new code.');
      return;
    }

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    try {
      await widget.onVerify(code);
      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
          _errorMessage = e.toString().replaceAll('Exception: ', '');
        });
      }
    }
  }

  Future<void> _handleResend() async {
    if (_resendCooldownSeconds > 0 || _isResending) return;

    setState(() {
      _isResending = true;
      _errorMessage = null;
    });

    try {
      final message = await widget.onResend();
      if (mounted) {
        setState(() {
          _isResending = false;
          _otpController.clear();
        });
        _startExpireTimer();
        _startResendTimer();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message ?? 'A new verification code has been sent!'),
            backgroundColor: CampusTheme.mint,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isResending = false;
          _errorMessage = e.toString().replaceAll('Exception: ', '');
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isExpired = _expireSecondsRemaining <= 0;

    return AlertDialog(
      backgroundColor: CampusTheme.darkCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(
          color: CampusTheme.deepTeal.withValues(alpha: 0.5),
          width: 1.2,
        ),
      ),
      contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
      content: SizedBox(
        width: 380,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Icon
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: CampusTheme.mint.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.mark_email_read_rounded,
                  color: CampusTheme.mint,
                  size: 32,
                ),
              ),
              const SizedBox(height: 16),

              // Title
              const Text(
                'Verify Your Gmail',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),

              // Subtitle
              Text(
                'Enter the 6-digit verification code sent to:',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  color: CampusTheme.textMuted,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: CampusTheme.darkCardLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  widget.email,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: CampusTheme.mint,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // OTP Input Field
              TextField(
                controller: _otpController,
                focusNode: _focusNode,
                autofocus: true,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                maxLength: 6,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 14,
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  counterText: '',
                  hintText: '••••••',
                  hintStyle: TextStyle(
                    color: Colors.white24,
                    letterSpacing: 14,
                  ),
                  filled: true,
                  fillColor: CampusTheme.darkCardLight,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: isExpired
                          ? CampusTheme.coral
                          : CampusTheme.primaryOrange,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(
                      color: CampusTheme.mint,
                      width: 2,
                    ),
                  ),
                ),
                onSubmitted: (_) => _handleVerify(),
              ),
              const SizedBox(height: 14),

              // Expiration Countdown
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.timer_outlined,
                    size: 16,
                    color: isExpired ? CampusTheme.coral : CampusTheme.mint,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    isExpired
                        ? 'Code expired'
                        : 'Expires in ${_formatTimer(_expireSecondsRemaining)}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isExpired
                          ? CampusTheme.coral
                          : CampusTheme.textMuted,
                    ),
                  ),
                ],
              ),

              // Error display
              if (_errorMessage != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: CampusTheme.coral.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: CampusTheme.coral.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline_rounded,
                          color: CampusTheme.coral, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(
                            color: CampusTheme.coral,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 18),

              // Resend code option
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Didn't receive the code? ",
                    style: TextStyle(
                      fontSize: 12,
                      color: CampusTheme.textMuted,
                    ),
                  ),
                  TextButton(
                    onPressed: (_resendCooldownSeconds == 0 && !_isResending)
                        ? _handleResend
                        : null,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      visualDensity: VisualDensity.compact,
                    ),
                    child: Text(
                      _resendCooldownSeconds > 0
                          ? 'Resend (${_resendCooldownSeconds}s)'
                          : 'Resend Code',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: _resendCooldownSeconds > 0
                            ? CampusTheme.textMuted
                            : CampusTheme.mint,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        side: BorderSide(
                          color: Colors.white.withValues(alpha: 0.2),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isSubmitting ? null : _handleVerify,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: CampusTheme.mint,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: _isSubmitting
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.black,
                              ),
                            )
                          : const Text(
                              'Verify',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
