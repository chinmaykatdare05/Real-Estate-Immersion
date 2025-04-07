// ignore_for_file: library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentScreen extends StatefulWidget {
  final Map<String, dynamic> propertyData;

  const PaymentScreen({super.key, required this.propertyData});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  DateTimeRange? selectedDates;
  late double price;
  final String paymentUrl =
      'https://razorpay.com/payment-link/plink_PimhLgFELheop4';

  @override
  void initState() {
    super.initState();
    price =
        double.tryParse(widget.propertyData['Price']?.toString() ?? "0") ?? 0.0;
  }

  int getTotalNights() {
    if (selectedDates == null) return 0;
    return selectedDates!.duration.inDays;
  }

  double getDiscount() {
    int nights = getTotalNights();
    return nights < 30 ? 0.10 : 0.00;
  }

  double getSubtotal() {
    return price * getTotalNights();
  }

  double getDiscountAmount() {
    return getSubtotal() * getDiscount();
  }

  double getLongStayDiscount() {
    return getTotalNights() >= 40 ? getSubtotal() * 0.40 : 0;
  }

  double getPlatformFees() {
    double percentageFee = getSubtotal() * 0.005;
    return percentageFee < 20 ? percentageFee : 20;
  }

  double getTaxes() {
    if (getTotalNights() > 30) return 0;
    double taxableAmount =
        getSubtotal() - getDiscountAmount() - getLongStayDiscount();
    return taxableAmount * 0.18;
  }

  double getTotalAmount() {
    return getSubtotal() -
        getDiscountAmount() -
        getLongStayDiscount() +
        getTaxes() +
        getPlatformFees();
  }

  Future<void> _selectDates(BuildContext context) async {
    DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() {
        selectedDates = picked;
      });
    }
  }

  Future<void> _launchPayment() async {
    Uri uri = Uri.parse(paymentUrl);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $paymentUrl';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Payment")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDateSelectionSection(context),
              const SizedBox(height: 20),
              if (selectedDates != null) _buildPriceDetailsSection(),
              const Divider(),
              const SizedBox(height: 20),
              _buildCancellationPolicySection(),
              const SizedBox(height: 20),
              const Divider(),
              _buildGroundRulesSection(),
              const SizedBox(height: 20),
              const Divider(),
              _buildBookingRulesSection(),
              const SizedBox(height: 20),
              _buildConfirmButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateSelectionSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Dates',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _selectDates(context),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedDates == null
                      ? 'Choose your dates'
                      : '${selectedDates!.start.day}/${selectedDates!.start.month}/${selectedDates!.start.year} - ${selectedDates!.end.day}/${selectedDates!.end.month}/${selectedDates!.end.year}',
                  style: const TextStyle(fontSize: 16),
                ),
                const Icon(Icons.calendar_today, color: Colors.grey),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPriceDetailsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Price Details',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '₹${price.toStringAsFixed(2)} x ${getTotalNights()} nights',
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              '₹${getSubtotal().toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        if (getTotalNights() >= 60) ...[
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Long Stay Discount (40%)',
                style: TextStyle(
                    fontSize: 16, color: Color.fromARGB(255, 14, 16, 14)),
              ),
              Text(
                '- ₹${getLongStayDiscount().toStringAsFixed(2)}',
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green),
              ),
            ],
          ),
        ],
        if (getDiscount() > 0) ...[
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Additional Discount (${(getDiscount() * 100).toInt()}%)',
                style: const TextStyle(
                    fontSize: 16, color: Color.fromARGB(255, 11, 14, 11)),
              ),
              Text(
                '- ₹${getDiscountAmount().toStringAsFixed(2)}',
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green),
              ),
            ],
          ),
        ],
        const SizedBox(height: 8),
        if (getTotalNights() <= 30) ...[
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Taxes (18%)', style: TextStyle(fontSize: 16)),
              Text(
                '₹${getTaxes().toStringAsFixed(2)}',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
        if (getTotalNights() > 0) ...[
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Platform Fees (0.50% or ₹20)',
                style: TextStyle(
                    fontSize: 16, color: Color.fromARGB(255, 14, 14, 14)),
              ),
              Text(
                '₹${getPlatformFees().toStringAsFixed(2)}',
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 12, 10, 10)),
              ),
            ],
          ),
        ],
        const Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Total (INR)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              '₹${getTotalAmount().toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCancellationPolicySection() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Cancellation Policy',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text(
          'This reservation is non-refundable.',
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildGroundRulesSection() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ground Rules',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text(
          'We ask every guest to remember a few simple things about what makes a great guest:',
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 8),
        Text('• Follow the house rules', style: TextStyle(fontSize: 16)),
        Text('• Treat your Host’s home like your own',
            style: TextStyle(fontSize: 16)),
      ],
    );
  }

  Widget _buildBookingRulesSection() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Booking Rules',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),
        Text(
          '• If booking is above 30 days, 10% discount is applied.',
          style: TextStyle(fontSize: 16),
        ),
        Text(
          '• If booking is above 60 days, 15% discount is applied.',
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildConfirmButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          if (selectedDates == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Please select dates before proceeding.'),
              ),
            );
          } else {
            _launchPayment();
          }
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: const Color.fromARGB(255, 245, 31, 102),
        ),
        child: const Text(
          'Confirm and Pay',
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }
}
