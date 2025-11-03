import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../core/theme/app_colors.dart';
import '../../../models/invoice_model.dart';
import '../../../models/transaction_model.dart';

class InvoiceReceiptScreen extends StatefulWidget {
  final InvoiceModel invoice;
  final TransactionModel? transaction;

  const InvoiceReceiptScreen({
    super.key,
    required this.invoice,
    this.transaction,
  });

  @override
  State<InvoiceReceiptScreen> createState() => _InvoiceReceiptScreenState();
}

class _InvoiceReceiptScreenState extends State<InvoiceReceiptScreen> {
  @override
  Widget build(BuildContext context) {
    final invoice = widget.invoice;
    final transaction = widget.transaction;
    final isSuccess = transaction?.isSuccessful ?? false;

    return Scaffold(
      appBar: AppBar(
        title: const Text('الإيصال'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            // Status Icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: isSuccess
                    ? AppColors.success.withOpacity(0.1)
                    : AppColors.error.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isSuccess ? Icons.check_circle : Icons.error,
                size: 50,
                color: isSuccess ? AppColors.success : AppColors.error,
              ),
            ),
            const SizedBox(height: 20),
            // Status Text
            Text(
              isSuccess ? 'تم الدفع بنجاح' : 'فشل الدفع',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isSuccess ? AppColors.success : AppColors.error,
              ),
            ),
            if (isSuccess) ...[
              const SizedBox(height: 8),
              Text(
                _getSuccessMessage(widget.invoice.registrationStatus),
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
            const SizedBox(height: 32),
            // Receipt Card
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: AppColors.border, width: 1),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.receipt,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'تفاصيل الإيصال',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Divider(height: 1),
                    const SizedBox(height: 16),
                    // Invoice Number
                    _ReceiptRow(
                      icon: Icons.numbers,
                      label: 'رقم الفاتورة',
                      value: invoice.invoiceNumber,
                    ),
                    const SizedBox(height: 12),
                    // Entity Title
                    _ReceiptRow(
                      icon: Icons.event,
                      label: 'المؤتمر/الدورة',
                      value: invoice.entityTitle,
                    ),
                    const SizedBox(height: 12),
                    // Amount
                    _ReceiptRow(
                      icon: Icons.attach_money,
                      label: 'المبلغ',
                      value: invoice.formattedAmount,
                      valueStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Issue Date
                    _ReceiptRow(
                      icon: Icons.calendar_today,
                      label: 'تاريخ الإصدار',
                      value: _formatDate(invoice.issueDate),
                    ),
                    if (invoice.dueDate != null) ...[
                      const SizedBox(height: 12),
                      _ReceiptRow(
                        icon: Icons.event_busy,
                        label: 'تاريخ الاستحقاق',
                        value: _formatDate(invoice.dueDate!),
                      ),
                    ],
                    // Transaction Details if exists
                    if (transaction != null) ...[
                      const SizedBox(height: 16),
                      const Divider(height: 1),
                      const SizedBox(height: 16),
                      const Text(
                        'تفاصيل المعاملة',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Transaction ID
                      _ReceiptRow(
                        icon: Icons.tag,
                        label: 'رقم المعاملة',
                        value: transaction.id,
                      ),
                      const SizedBox(height: 12),
                      // Gateway
                      _ReceiptRow(
                        icon: Icons.account_balance_wallet,
                        label: 'بوابة الدفع',
                        value: transaction.gatewayName,
                      ),
                      const SizedBox(height: 12),
                      // Payment Method
                      _ReceiptRow(
                        icon: Icons.payment,
                        label: 'طريقة الدفع',
                        value: transaction.paymentMethodAr,
                      ),
                      const SizedBox(height: 12),
                      // Transaction Date
                      _ReceiptRow(
                        icon: Icons.access_time,
                        label: 'تاريخ المعاملة',
                        value: _formatDateTime(transaction.timestampInitiated),
                      ),
                      if (transaction.timestampCompleted != null) ...[
                        const SizedBox(height: 12),
                        _ReceiptRow(
                          icon: Icons.done_all,
                          label: 'تاريخ الإتمام',
                          value: _formatDateTime(transaction.timestampCompleted!),
                        ),
                      ],
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Action Buttons
            if (isSuccess) ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _exportToPdf(context),
                  icon: const Icon(Icons.picture_as_pdf),
                  label: const Text('تحميل PDF'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _shareReceipt(context),
                      icon: const Icon(Icons.share),
                      label: const Text('مشاركة'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.surface,
                        foregroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: const BorderSide(color: AppColors.primary),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _printReceipt(context),
                      icon: const Icon(Icons.print),
                      label: const Text('طباعة'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.surface,
                        foregroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: const BorderSide(color: AppColors.primary),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                icon: const Icon(Icons.home),
                label: const Text('العودة للرئيسية'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.surface,
                  foregroundColor: AppColors.textPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(color: AppColors.border),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatDateTime(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  /// Get success message based on registration status
  String _getSuccessMessage(String? registrationStatus) {
    if (registrationStatus == 'WAITING_LIST') {
      return 'تم إضافة طلبك لقائمة الانتظار';
    } else if (registrationStatus == 'ACTIVE_PARTICIPANT') {
      return 'أنت الآن مشارك نشط';
    } else {
      return 'تم استلام الدفع بنجاح';
    }
  }

  /// Share receipt as text
  Future<void> _shareReceipt(BuildContext context) async {
    try {
      final receiptText = _buildReceiptText();
      await Share.share(
        receiptText,
        subject: 'إيصال الدفع - ${widget.invoice.invoiceNumber}',
      );
    } catch (e) {
      debugPrint('❌ Error sharing receipt: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('فشل في مشاركة الإيصال'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  /// Print receipt
  Future<void> _printReceipt(BuildContext context) async {
    try {
      // Generate PDF for printing
      final pdf = await _generatePdf();
      
      // Use Printing.layoutPdf to show print dialog
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf,
        name: 'إيصال_الدفع_${widget.invoice.invoiceNumber}.pdf',
      );
    } catch (e) {
      debugPrint('❌ Error printing receipt: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('فشل في طباعة الإيصال'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  /// Build receipt text for sharing/printing
  String _buildReceiptText() {
    final buffer = StringBuffer();
    final invoice = widget.invoice;
    final transaction = widget.transaction;
    
    buffer.writeln('═══════════════════════════════════════');
    buffer.writeln('         إيصال دفع');
    buffer.writeln('═══════════════════════════════════════');
    buffer.writeln('');
    
    // Invoice info
    buffer.writeln('رقم الفاتورة: ${invoice.invoiceNumber}');
    buffer.writeln('المؤتمر/الدورة: ${invoice.entityTitle}');
    buffer.writeln('المبلغ: ${invoice.formattedAmount}');
    buffer.writeln('تاريخ الإصدار: ${_formatDate(invoice.issueDate)}');
    
    if (invoice.dueDate != null) {
      buffer.writeln('تاريخ الاستحقاق: ${_formatDate(invoice.dueDate!)}');
    }
    
    // Transaction info if exists
    if (transaction != null) {
      buffer.writeln('');
      buffer.writeln('───────────────────────────────────────');
      buffer.writeln('تفاصيل المعاملة');
      buffer.writeln('───────────────────────────────────────');
      buffer.writeln('رقم المعاملة: ${transaction.id}');
      buffer.writeln('بوابة الدفع: ${transaction.gatewayName}');
      buffer.writeln('طريقة الدفع: ${transaction.paymentMethodAr}');
      buffer.writeln('تاريخ المعاملة: ${_formatDateTime(transaction.timestampInitiated)}');
      
      if (transaction.timestampCompleted != null) {
        buffer.writeln('تاريخ الإتمام: ${_formatDateTime(transaction.timestampCompleted!)}');
      }
    }
    
    buffer.writeln('');
    buffer.writeln('═══════════════════════════════════════');
    buffer.writeln('شكراً لاستخدامك خدماتنا');
    buffer.writeln('═══════════════════════════════════════');
    
    return buffer.toString();
  }

  /// Export receipt to PDF
  Future<void> _exportToPdf(BuildContext context) async {
    try {
      // Generate PDF
      final pdf = await _generatePdf();
      
      // Share PDF
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf,
        name: 'إيصال_الدفع_${widget.invoice.invoiceNumber}.pdf',
      );
    } catch (e) {
      debugPrint('❌ Error generating PDF: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('فشل في تصدير PDF'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  /// Generate PDF document
  Future<Uint8List> _generatePdf() async {
    final pdf = pw.Document();
    final invoice = widget.invoice;
    final transaction = widget.transaction;
    
    // Load Arabic fonts - Try NotoSansArabic first for better Arabic support
    pw.Font arabicFont;
    pw.Font arabicFontBold;
    
    try {
      // Try loading NotoSansArabic first (better Unicode support)
      final notoSansData = await rootBundle.load('assets/fonts/NotoSansArabic-Regular.ttf');
      arabicFont = pw.Font.ttf(notoSansData);
      arabicFontBold = pw.Font.ttf(notoSansData); // Use same font for bold, or load Cairo-Bold
      
      // Try to load Cairo-Bold for better bold text
      try {
        final cairoBoldData = await rootBundle.load('assets/fonts/Cairo/Cairo-Bold.ttf');
        arabicFontBold = pw.Font.ttf(cairoBoldData);
      } catch (e) {
        // Fallback to NotoSansArabic if Cairo-Bold fails
        debugPrint('⚠️ Could not load Cairo-Bold, using NotoSansArabic for bold: $e');
      }
    } catch (e) {
      // Fallback to Cairo if NotoSansArabic fails
      debugPrint('⚠️ Could not load NotoSansArabic, falling back to Cairo: $e');
      final cairoData = await rootBundle.load('assets/fonts/Cairo/Cairo-Regular.ttf');
      arabicFont = pw.Font.ttf(cairoData);
      try {
        final cairoBoldData = await rootBundle.load('assets/fonts/Cairo/Cairo-Bold.ttf');
        arabicFontBold = pw.Font.ttf(cairoBoldData);
      } catch (e2) {
        arabicFontBold = arabicFont;
      }
    }
    
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              // Header
              pw.Center(
                child: pw.Text(
                  'إيصال دفع',
                  style: pw.TextStyle(
                    font: arabicFontBold,
                    fontSize: 28,
                    fontWeight: pw.FontWeight.bold,
                  ),
                  textDirection: pw.TextDirection.rtl,
                ),
              ),
              pw.SizedBox(height: 30),
              
              // Receipt Card
              pw.Container(
                padding: const pw.EdgeInsets.all(24),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.grey400, width: 1),
                  borderRadius: pw.BorderRadius.circular(10),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    // Title
                    pw.Row(
                      children: [
                        pw.Icon(pw.IconData(0xe263), size: 24, color: PdfColors.blue900),
                        pw.SizedBox(width: 12),
                        pw.Text(
                          'تفاصيل الإيصال',
                          style: pw.TextStyle(
                            font: arabicFontBold,
                            fontSize: 18,
                            fontWeight: pw.FontWeight.bold,
                          ),
                          textDirection: pw.TextDirection.rtl,
                        ),
                      ],
                    ),
                    pw.Divider(color: PdfColors.grey300, height: 30),
                    
                    // Invoice Number
                    _buildPdfRow('رقم الفاتورة', invoice.invoiceNumber, arabicFont),
                    pw.SizedBox(height: 12),
                    
                    // Entity Title
                    _buildPdfRow('المؤتمر/الدورة', invoice.entityTitle, arabicFont),
                    pw.SizedBox(height: 12),
                    
                    // Amount
                    _buildPdfRow(
                      'المبلغ',
                      invoice.formattedAmount,
                      arabicFont,
                      isHighlighted: true,
                    ),
                    pw.SizedBox(height: 12),
                    
                    // Issue Date
                    _buildPdfRow('تاريخ الإصدار', _formatDate(invoice.issueDate), arabicFont),
                    
                    // Due Date if exists
                    if (invoice.dueDate != null) ...[
                      pw.SizedBox(height: 12),
                      _buildPdfRow('تاريخ الاستحقاق', _formatDate(invoice.dueDate!), arabicFont),
                    ],
                    
                    // Transaction Details if exists
                    if (transaction != null) ...[
                      pw.SizedBox(height: 20),
                      pw.Divider(color: PdfColors.grey300, height: 20),
                      pw.Text(
                        'تفاصيل المعاملة',
                        style: pw.TextStyle(
                          font: arabicFontBold,
                          fontSize: 16,
                          fontWeight: pw.FontWeight.bold,
                        ),
                        textDirection: pw.TextDirection.rtl,
                      ),
                      pw.SizedBox(height: 12),
                      
                      // Transaction ID
                      _buildPdfRow('رقم المعاملة', transaction.id, arabicFont),
                      pw.SizedBox(height: 12),
                      
                      // Gateway
                      _buildPdfRow('بوابة الدفع', transaction.gatewayName, arabicFont),
                      pw.SizedBox(height: 12),
                      
                      // Payment Method
                      _buildPdfRow('طريقة الدفع', transaction.paymentMethodAr, arabicFont),
                      pw.SizedBox(height: 12),
                      
                      // Transaction Date
                      _buildPdfRow('تاريخ المعاملة', _formatDateTime(transaction.timestampInitiated), arabicFont),
                      
                      // Completion Date if exists
                      if (transaction.timestampCompleted != null) ...[
                        pw.SizedBox(height: 12),
                        _buildPdfRow('تاريخ الإتمام', _formatDateTime(transaction.timestampCompleted!), arabicFont),
                      ],
                    ],
                  ],
                ),
              ),
              
              pw.Spacer(),
              
              // Footer
              pw.Center(
                child: pw.Text(
                  'شكراً لاستخدامك خدماتنا',
                  style: pw.TextStyle(
                    font: arabicFont,
                    fontSize: 14,
                    color: PdfColors.grey700,
                  ),
                  textDirection: pw.TextDirection.rtl,
                ),
              ),
            ],
          );
        },
      ),
    );
    
    return pdf.save();
  }

  /// Build a PDF row with label and value
  pw.Widget _buildPdfRow(String label, String value, pw.Font font, {bool isHighlighted = false}) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      textDirection: pw.TextDirection.rtl,
      children: [
        pw.Text(
          '$label:',
          style: pw.TextStyle(
            font: font,
            fontSize: 14,
            color: PdfColors.grey700,
          ),
          textDirection: pw.TextDirection.rtl,
        ),
        pw.Text(
          value,
          style: pw.TextStyle(
            font: font,
            fontSize: isHighlighted ? 16 : 14,
            fontWeight: isHighlighted ? pw.FontWeight.bold : pw.FontWeight.normal,
            color: isHighlighted ? PdfColors.blue900 : PdfColors.black,
          ),
          textDirection: pw.TextDirection.rtl,
        ),
      ],
    );
  }
}

class _ReceiptRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final TextStyle? valueStyle;

  const _ReceiptRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.textSecondary),
        const SizedBox(width: 12),
        Text(
          '$label:',
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        const Spacer(),
        Flexible(
          child: Text(
            value,
            style: valueStyle ??
                const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}

