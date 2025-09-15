import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:cloud_functions/cloud_functions.dart';

class StripeService {
  // Initialize in main: Stripe.publishableKey = 'pk_...';
  // This example expects a server-side endpoint (Cloud Function) that creates PaymentIntent and returns client_secret.
  final _functions = FirebaseFunctions.instance;

  Future<void> init() async {
    // Optionally set Stripe options: Stripe.publishableKey = ...
  }

  Future<void> payWithCard({required String clientSecret}) async {
    // Confirm payment with PaymentSheet or PaymentIntent
    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: clientSecret,
        merchantDisplayName: 'Demo Shop',
      ),
    );
    await Stripe.instance.presentPaymentSheet();
  }

  // Example: Call cloud function to create PaymentIntent
  Future<String> createPaymentIntentOnServer(
    int amountCents,
    String currency,
  ) async {
    final callable = _functions.httpsCallable('createPaymentIntent');
    final res = await callable.call({
      'amount': amountCents,
      'currency': currency,
    });
    return res.data['clientSecret'] as String;
  }
}
