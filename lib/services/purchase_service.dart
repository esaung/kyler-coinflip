import 'dart:async';
import 'package:in_app_purchase/in_app_purchase.dart';
import '../constants/app_constants.dart';

/// Service for handling in-app purchases
///
/// Manages the premium upgrade purchase flow
class PurchaseService {
  final InAppPurchase _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;

  bool _isAvailable = false;
  List<ProductDetails> _products = [];
  bool _isPurchasePending = false;

  // Callbacks
  Function(bool success)? onPurchaseComplete;
  Function(String error)? onPurchaseError;

  /// Check if IAP is available
  bool get isAvailable => _isAvailable;

  /// Check if a purchase is pending
  bool get isPurchasePending => _isPurchasePending;

  /// Get the premium product details
  ProductDetails? get premiumProduct {
    try {
      return _products.firstWhere(
        (p) => p.id == AppConstants.premiumProductId,
      );
    } catch (e) {
      return null;
    }
  }

  /// Initialize the purchase service
  Future<void> initialize() async {
    _isAvailable = await _iap.isAvailable();

    if (!_isAvailable) {
      return;
    }

    // Listen for purchase updates
    _subscription = _iap.purchaseStream.listen(
      _handlePurchaseUpdates,
      onDone: _onDone,
      onError: _onError,
    );

    // Load products
    await _loadProducts();
  }

  /// Load available products
  Future<void> _loadProducts() async {
    final Set<String> ids = {AppConstants.premiumProductId};
    final ProductDetailsResponse response =
        await _iap.queryProductDetails(ids);

    if (response.error != null) {
      onPurchaseError?.call(response.error!.message);
      return;
    }

    if (response.notFoundIDs.isNotEmpty) {
      // Product not found - might not be configured in store
    }

    _products = response.productDetails;
  }

  /// Handle purchase updates
  void _handlePurchaseUpdates(List<PurchaseDetails> purchases) {
    for (final purchase in purchases) {
      _handlePurchase(purchase);
    }
  }

  /// Handle individual purchase
  Future<void> _handlePurchase(PurchaseDetails purchase) async {
    if (purchase.status == PurchaseStatus.pending) {
      _isPurchasePending = true;
    } else {
      _isPurchasePending = false;

      if (purchase.status == PurchaseStatus.error) {
        onPurchaseError?.call(purchase.error?.message ?? 'Purchase failed');
      } else if (purchase.status == PurchaseStatus.purchased ||
          purchase.status == PurchaseStatus.restored) {
        // Verify and deliver the purchase
        final bool valid = await _verifyPurchase(purchase);
        if (valid) {
          onPurchaseComplete?.call(true);
        } else {
          onPurchaseError?.call('Purchase verification failed');
        }
      }

      // Complete the purchase
      if (purchase.pendingCompletePurchase) {
        await _iap.completePurchase(purchase);
      }
    }
  }

  /// Verify purchase (in production, verify with your backend)
  Future<bool> _verifyPurchase(PurchaseDetails purchase) async {
    // In a production app, you should verify the purchase
    // with your backend server for security
    return purchase.productID == AppConstants.premiumProductId;
  }

  /// Purchase the premium upgrade
  Future<void> purchasePremium() async {
    if (!_isAvailable) {
      onPurchaseError?.call('In-app purchases not available');
      return;
    }

    final product = premiumProduct;
    if (product == null) {
      onPurchaseError?.call('Premium product not found');
      return;
    }

    final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);

    try {
      await _iap.buyNonConsumable(purchaseParam: purchaseParam);
    } catch (e) {
      onPurchaseError?.call('Purchase failed: $e');
    }
  }

  /// Restore previous purchases
  Future<void> restorePurchases() async {
    if (!_isAvailable) {
      onPurchaseError?.call('In-app purchases not available');
      return;
    }

    try {
      await _iap.restorePurchases();
    } catch (e) {
      onPurchaseError?.call('Restore failed: $e');
    }
  }

  void _onDone() {
    _subscription?.cancel();
  }

  void _onError(dynamic error) {
    onPurchaseError?.call('Purchase stream error: $error');
  }

  /// Dispose resources
  void dispose() {
    _subscription?.cancel();
  }
}
