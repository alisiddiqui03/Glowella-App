# Glowella - Premium Skincare Application

Glowella is a high-end skincare application built for **MD Scents**, designed to provide a premium shopping experience for curated skincare products. The app features a mint-green aesthetic, high-contrast readability, and a seamless user journey from discovery to checkout.

## 🌟 Key Features

### 🛍️ Shopping Experience
- **Home Dashboard**: Clean, direct layout showing all predefined premium products right under the promotional banner. No horizontal scrolling, ensuring all products are instantly visible.
- **Product Details**: Premium image sliders (left-to-right), detailed descriptions, pricing, and an accessible "Add to Cart" sticky footer.
- **Cart Management**: Real-time cart updates with total calculations, leading smoothly to the checkout pipeline.

### 💳 Checkout & Loyalty
- **Flexible Payments**: 
  - **Bank Transfer**: Users receive an automatic **5% discount** for selecting Bank Transfer.
  - **Cash on Delivery (COD)**: 
    - **Karachi**: PKR 500 delivery charge.
    - **Outside Karachi**: PKR 350 delivery charge.
- **Loyalty Program**: Users earn points on every purchase, which can be redeemed for discounts during checkout.
- **Wallet System**: Integrated wallet for storing and applying rewards balance.
- **Address Management**: Users can save and edit their delivery address (Phone, Street, City, Postal Code) directly from their Profile, which auto-fills during checkout.

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
- **Styling**: Vanilla CSS-like theme implementation.

### UI/UX Standards
- **Premium eCommerce Feel**: Products are displayed in high-quality containers with shadow effects, out-of-stock badges, and full-width interactive buttons.
- **Accessibility**: Strict "Dark Text" policy for input fields on light backgrounds to ensure 100% readability.
- **Performance**: Optimized image loading using asset-based caching.

## 🚀 App Flows

1. **Authentication**: Role-based access (User/Admin) via Firebase Auth.
2. **Discovery**: Home Dashboard (Banner -> Products Grid) -> Product Detail (Image Slider -> Add to Cart).
3. **Checkout Pipeline**: Cart -> Checkout (Auto-filled Delivery Details -> Payment Method selection -> Real-time Summary with Delivery/Discounts applied) -> Order Confirmation.
4. **Profile Management**: Profile -> Saved Address editing -> Order History -> Wallet Status.

---
*Developed by Antigravity AI for MD Scents.*
