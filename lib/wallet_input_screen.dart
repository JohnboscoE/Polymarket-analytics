import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'analytic_provider.dart';
import 'constants.dart';

class WalletInputScreen extends StatefulWidget {
  const WalletInputScreen({super.key});

  @override
  State<WalletInputScreen> createState() => _WalletInputScreenState();
}

class _WalletInputScreenState extends State<WalletInputScreen> {
  final TextEditingController _controller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submitAddress(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final provider = Provider.of<AnalyticsProvider>(context, listen: false);
      String address = _controller.text.trim();

      provider.setWalletAddress(address);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 60),
            const Text(
              'View Your Portfolio',
              style: TextStyle(
                color: lightText,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Enter your Ethereum/Polygon wallet address (0x...) to fetch your open positions from Polymarket.',
              style: TextStyle(
                color: lightText.withOpacity(0.7),
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),

            // --- Address Input Field ---
            TextFormField(
              controller: _controller,
              style: const TextStyle(color: lightText),
              cursorColor: brandBlue,
              decoration: InputDecoration(
                labelText: 'Wallet Address (0x...)',
                labelStyle: TextStyle(color: lightText.withOpacity(0.8)),
                hintText: 'e.g., 0x937d...67fA',
                hintStyle: TextStyle(color: lightText.withOpacity(0.5)),
                filled: true,
                fillColor: cardSurface,
                prefixIcon: const Icon(Icons.account_balance_wallet, color: brandBlue),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: brandBlue, width: 2),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a wallet address.';
                }
                // Basic address format validation
                if (!value.startsWith('0x') || value.length < 42) {
                  return 'Please enter a valid Ethereum/Polygon address (must start with 0x and be 42 characters long).';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            // --- Submit Button ---
            ElevatedButton(
              onPressed: () => _submitAddress(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: brandBlue,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Fetch Portfolio',
                style: TextStyle(
                  color: lightText,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}