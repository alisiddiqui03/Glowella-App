# Glowella - Premium Skincare Application

Glowella is a high-end skincare application built for **MD Scents**, designed to provide a premium shopping experience for curated skincare products. The app features a mint-green aesthetic, high-contrast readability, and a seamless user journey from discovery to checkout.

## 🌟 Key Features

### 🛍️ Shopping Experience
- **Home Dashboard**: Features a high-visibility "New Arrivals" slider and categorized collections.
- **Product Details**: Premium image sliders, detailed ingredient lists, and benefit callouts (e.g., Dermatologically Tested, Cruelty-Free).
- **Cart Management**: Real-time cart updates with automatic discount calculations.

### 💳 Checkout & Loyalty
- **Flexible Payments**: Supports Cash on Delivery (COD) and Bank Transfer with a dedicated bonus structure.
- **Loyalty Program**: Users earn points on every purchase, which can be redeemed for discounts.
- **Wallet System**: Integrated wallet for storing and applying rewards balance during checkout.

### 🧴 Featured Inventory
1. **Barrier Support Serum** (30ml) - Niacinamide + Zinc.
2. **Hydrating Cleanser** (120ml) - Glycerin + Glycolic Acid.
3. **Liquid Exfoliant** (100ml) - 7% Glycolic Acid Toner.
4. **Night Repair Complex** (50g) - Retinol + Collagen Peptides.
5. **Advanced Brightener** (50g) - Lucent Glow Cream with Alpha Arbutin.
6. **UV Protector** (50ml) - Sun Block SPF 60.
7. **Hydration Booster** (30ml) - Hyaluronic Acid Serum.

## 🛠️ Technical Infrastructure

### Core Stack
- **Framework**: Flutter with GetX for state management and routing.
- **Backend**: Firebase (Auth, Firestore, Storage).
- **Styling**: Vanilla CSS-like theme implementation with `Playfair Display` for branding.

### UI/UX Standards
- **Accessibility**: Strict "No White Text" policy for input fields on light backgrounds to ensure 100% readability.
- **Performance**: Optimized image loading using `CachedNetworkImage` and asset-based caching.

## 🚀 App Flows

1. **Authentication**: Role-based access (User/Admin) via Firebase Auth.
2. **Discovery**: Home -> Featured Products -> Product Detail -> Cart.
3. **Purchase**: Cart -> Checkout (Delivery Details -> Payment Method -> Order Summary) -> Order Confirmation.
4. **Management**: Profile -> Order History -> Loyalty Status.

---
*Developed by Antigravity AI for MD Scents.*
