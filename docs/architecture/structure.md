## Project Structure

```txt
UrComputer/
  apps/
    mobile/
      lib/
        main.dart
        app.dart
        theme/
          app_theme.dart
        router/
          app_router.dart
        features/
          home/
            home_screen.dart
            widgets/
                home_banner.dart
          products/
            products_screen.dart
          favorites/
            favorites_screen.dart
          cart/
            cart_screen.dart
          booking/
            booking_screen.dart
          settings/
            settings_screen.dart
        widgets/
          main_shell.dart
```
## 2. Folder Explanation

### `main.dart`

This is the entry point of the app.

Flutter starts from this file.

```dart
void main() {
  runApp(const UrComputerApp());
}
```

Do not put screens, UI design, or business logic inside `main.dart`.

---

### `app.dart`

This file contains the main app widget.

It connects:

- `MaterialApp`
- Theme
- Router
- App title

Example:

```dart
MaterialApp.router(
  title: 'UrComputer',
  theme: AppTheme.lightTheme,
  darkTheme: AppTheme.darkTheme,
  routerConfig: appRouter,
);
```

---

### `theme/`

This folder contains the app design system.

Use it for:

- App colors
- Light theme
- Dark theme
- Text styles
- Button styles
- Card styles

Example:

```txt
theme/
  app_colors.dart
  app_theme.dart
  app_text_styles.dart
```

Do not use random colors directly inside screens.  
If a color is reused, put it in `app_colors.dart`.

---

### `router/`

This folder contains navigation setup.

Example:

```txt
router/
  app_router.dart
```

Current routes:

```txt
/           -> HomeScreen
/products   -> ProductsScreen
/favorites  -> FavoritesScreen
/cart       -> CartScreen
/booking    -> BookingScreen
/settings   -> SettingsScreen
```

Keep main navigation logic inside `app_router.dart`.

---

### `features/`

This folder contains the main screens of the app.

Each feature represents one app area.

Example:

```txt
features/
  home/
  products/
  favorites/
  cart/
  booking/
  settings/
```

Example:

```txt
features/products/
  products_screen.dart
  product_detail_screen.dart
```

If a feature has many small UI parts, create a `widgets/` folder inside that feature.

Example:

```txt
features/home/
  home_screen.dart
  widgets/
    home_banner.dart
    category_section.dart
```

Rule:

```txt
Widget used only by Home
→ features/home/widgets/
```

---

### `widgets/`

This folder contains reusable widgets used by many screens.

Example:

```txt
widgets/
  main_shell.dart
  app_button.dart
  app_card.dart
  product_card.dart
  section_header.dart
  rating_stars.dart
  empty_state.dart
  loading_view.dart
```

Rule:

```txt
Reusable in many screens
→ widgets/

Used by one feature only
→ features/feature_name/widgets/
```

---

### `models/`

This folder contains plain Dart data classes.

A model describes what the data looks like.

Example:

```txt
models/
  product.dart
  category.dart
  branch.dart
  review.dart
  booking.dart
  pc_part.dart
```

Example product JSON:

```json
{
  "id": "1",
  "name": "Lenovo Legion 5",
  "price": 1200,
  "brand": "Lenovo"
}
```

Example Dart model:

```dart
class Product {
  final String id;
  final String name;
  final double price;
  final String brand;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.brand,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'].toString(),
      name: json['name'],
      price: (json['price'] as num).toDouble(),
      brand: json['brand'],
    );
  }
}
```

Do not pass raw JSON directly into the UI.

Bad:

```dart
Text(product['name'])
```

Good:

```dart
Text(product.name)
```

---

### `data/`

This folder handles where data comes from.

For now, data comes from local mock JSON files.

Example:

```txt
data/
  mock_repository.dart
```

The repository loads data from:

```txt
assets/mock/
```

Example:

```dart
class MockRepository {
  Future<List<Product>> getProducts() async {
    final jsonString = await rootBundle.loadString('assets/mock/products.json');
    final List data = jsonDecode(jsonString);

    return data.map((item) => Product.fromJson(item)).toList();
  }
}
```

Screens should not load JSON files directly.  
Screens should get data through `MockRepository`.

---

### `state/`

This folder contains app state using Provider or ChangeNotifier.

State means data that can change while the app is running.

Example:

```txt
state/
  favorites_provider.dart
  cart_provider.dart
  booking_provider.dart
  pc_builder_provider.dart
```

Examples:

```txt
Favorites state
→ user taps heart
→ product is added/removed
→ UI updates

Cart state
→ user adds item to cart
→ total price updates

Booking state
→ user selects date/time
→ booking summary updates
```

Example:

```dart
class FavoritesProvider extends ChangeNotifier {
  final List<String> _favoriteProductIds = [];

  List<String> get favoriteProductIds => _favoriteProductIds;

  void toggleFavorite(String productId) {
    if (_favoriteProductIds.contains(productId)) {
      _favoriteProductIds.remove(productId);
    } else {
      _favoriteProductIds.add(productId);
    }

    notifyListeners();
  }
}
```

Do not use random global variables for data that changes.

---

### `utils/`

This folder contains small reusable helper functions.

Example:

```txt
utils/
  currency_formatter.dart
  date_formatter.dart
  validators.dart
```

Example:

```dart
String formatPrice(double price) {
  return '\$${price.toStringAsFixed(2)}';
}
```

Use `utils/` for small helper logic such as:

- Format price
- Format date
- Validate form fields
- Calculate discount

---

### `assets/`

This folder stores non-code files.

```txt
assets/
  images/
  icons/
  mock/
```

#### `assets/images/`

Use this for app images.

Example:

```txt
assets/images/laptop_banner.png
```

Use in Flutter:

```dart
Image.asset('assets/images/laptop_banner.png')
```

#### `assets/icons/`

Use this for custom icons.

Example:

```txt
assets/icons/cpu.svg
assets/icons/gpu.svg
```

#### `assets/mock/`

Use this for fake local data.

Example:

```txt
assets/mock/
  products.json
  categories.json
  branches.json
  reviews.json
  pc_parts.json
```

Do not hard-code long product lists inside screens.  
Put mock data inside JSON files.

---


Use this guide when deciding where to put a file.

| File Type | Put It In |
|---|---|
| Screen | `features/feature_name/` |
| Reusable widget | `widgets/` |
| Widget used by one feature only | `features/feature_name/widgets/` |
| App colors/theme | `theme/` |
| Navigation route | `router/` |
| Data class | `models/` |
| JSON loading/API logic | `data/` |
| Provider/ChangeNotifier | `state/` |
| Helper function | `utils/` |
| Images | `assets/images/` |
| Icons | `assets/icons/` |
| Mock JSON | `assets/mock/` |

---