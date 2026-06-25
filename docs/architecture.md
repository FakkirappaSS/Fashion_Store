# 📐 FashionStore - System Architecture & Design Documentation

This documentation provides an architect-level overview of the `FashionStore` application. It includes system architecture flowcharts, database schemas, class relationships, sequence diagrams for key user journeys, and controller-to-data-access-object mappings.

---

## 1. MVC & System Architecture

The application adheres to the standard **Model-View-Controller (MVC)** architectural pattern. It decouples the presentation layer from the database operations and request handling.

```mermaid
flowchart TD
    subgraph View_Layer ["View Layer (Client Browser / JSP)"]
        JSP["JSP Templates (HTML, CSS, JS, JSTL)"]
    end

    subgraph Controller_Layer ["Controller Layer (Jakarta Servlets & Filters)"]
        Filter["AuthFilter (Session Interception)"]
        Servlet["Jakarta Servlets (Request Handlers)"]
    end

    subgraph Model_DAO_Layer ["Model & DAO Layer (Business & Data Access)"]
        Model["Java Models / Entities (Plain Objects)"]
        DAO["DataAccessObjects (SQL Operations)"]
    end

    subgraph Database_Layer ["Database Layer (MySQL cloud hosting)"]
        DB[("MySQL Database (Aiven.io)")]
    end

    JSP -- "1. HTTP Request (GET/POST)" --> Filter
    Filter -- "2. Validated Request" --> Servlet
    Servlet -- "3. Invokes CRUD Methods" --> DAO
    DAO -- "4. SQL Query (HikariCP)" --> DB
    DB -- "5. Result Sets" --> DAO
    DAO -- "6. Instantiates / Populates" --> Model
    Servlet -- "7. Binds Entities to Request/Session" --> JSP
    JSP -- "8. Dynamic HTML Response" --> JSP
```

### Components Breakdown:
*   **View Layer (`/src/main/webapp`)**: Serves user interfaces using JSP templates. Utilizes JSTL (`jakarta.tags`) for loop renderings, formatting, and structural checks. Style rules are managed in static CSS, and DOM interactions/validations in JavaScript.
*   **Controller Layer (`com.fashionstore.controller` & `com.fashionstore.filter`)**:
    *   `AuthFilter`: Intercepts protected URI patterns (e.g., checkout, profile, cart, order-details) to ensure a user is logged in, redirecting to `/login` if unauthenticated.
    *   `Servlets`: Coordinate requests, inspect HTTP headers and session states, instantiate/call DAOs, and direct page transitions using forwards or redirects.
*   **Model Layer (`com.fashionstore.model`)**: Simple Java beans (Plain Old Java Objects - POJOs) mapping directly to database table rows, containing only fields, getters, setters, and constructors.
*   **DAO Layer (`com.fashionstore.dao`)**: Encapsulates raw JDBC SQL statements. Interacts with the database connection pool (`DBConnection`) to query data, execute updates, and map relational database rows to Model objects.

---

## 2. Class Diagram

The following diagram illustrates the relationship between the Java Model entities, their corresponding Data Access Objects (DAOs), and database connection utilities.

```mermaid
classDiagram
    class DBConnection {
        -HikariDataSource dataSource
        -DBConnection instance
        +getInstance() DBConnection
        +getConnection() Connection
    }
    
    class User {
        +int userId
        +String fullName
        +String email
        +String phone
        +String password
        +String gender
        +String address
    }
    
    class Category {
        +int categoryId
        +String categoryName
        +String description
        +boolean isActive
    }

    class Product {
        +int productId
        +int categoryId
        +String productName
        +String description
        +BigDecimal discountPercent
        +String imageUrl
        +boolean isActive
        +BigDecimal unitPrice
        +String categoryName
        +List~ProductVariant~ variants
    }

    class ProductVariant {
        +int productSizeId
        +int productId
        +String sizeLabel
        +int stockQuantity
        +String skuCode
        +boolean isAvailable
    }

    class Cart {
        +int cartId
        +int userId
        +Timestamp createdAt
        +Timestamp updatedAt
        +List~CartItem~ items
    }

    class CartItem {
        +int cartItemId
        +int cartId
        +int productId
        +String sizeLabel
        +int quantity
        +BigDecimal unitPrice
        +Timestamp addedAt
        +Product product
    }

    class Order {
        +int orderId
        +int userId
        +Timestamp orderDate
        +BigDecimal totalAmount
        +String paymentMethod
        +String orderStatus
        +String deliveryAddress
        +List~OrderItem~ orderItems
    }

    class OrderItem {
        +int orderItemId
        +int orderId
        +int productId
        +String productName
        +int quantity
        +BigDecimal unitPrice
        +BigDecimal subtotal
        +String sizeLabel
    }

    class UserDAO {
        +registerUser(User) boolean
        +getUserByEmail(String) User
        +updateUserProfile(User) boolean
    }

    class ProductDAO {
        +getAllActiveProducts() List~Product~
        +getProductById(int) Product
        +getProductsByCategory(int) List~Product~
        +searchProducts(String) List~Product~
    }

    class ProductVariantDAO {
        +getVariantsByProductId(int) List~ProductVariant~
        +decreaseStock(int, String, int) boolean
    }

    class CartDAO {
        +getCartByUserId(int) Cart
        +createCartForUser(int) Cart
        +clearCart(int) boolean
    }

    class CartItemDAO {
        +addItemToCart(CartItem) boolean
        +getItemsByCartId(int) List~CartItem~
        +updateItemQuantity(int, int) boolean
        +removeItem(int) boolean
    }

    class OrderDAO {
        +createOrder(Order) int
        +getOrdersByUserId(int) List~Order~
        +getOrderById(int) Order
    }

    class OrderItemDAO {
        +addOrderItems(List~OrderItem~) boolean
        +getItemsByOrderId(int) List~OrderItem~
    }

    class WishlistDAO {
        +addProductToWishlist(int, int) boolean
        +removeProductFromWishlist(int, int) boolean
        +checkIfInWishlist(int, int) boolean
        +getWishlistProductIds(int) Set~Integer~
        +getUserWishlist(int) List~Product~
    }

    Product "1" *-- "many" ProductVariant
    Product "many" --> "1" Category
    Cart "1" *-- "many" CartItem
    CartItem "1" --> "1" Product
    Order "1" *-- "many" OrderItem

    UserDAO ..> User : "manages"
    ProductDAO ..> Product : "manages"
    ProductVariantDAO ..> ProductVariant : "manages"
    CartDAO ..> Cart : "manages"
    CartItemDAO ..> CartItem : "manages"
    OrderDAO ..> Order : "manages"
    OrderItemDAO ..> OrderItem : "manages"
    WishlistDAO ..> Product : "fetches"

    UserDAO ..> DBConnection : "uses"
    ProductDAO ..> DBConnection : "uses"
    ProductVariantDAO ..> DBConnection : "uses"
    CartDAO ..> DBConnection : "uses"
    CartItemDAO ..> DBConnection : "uses"
    OrderDAO ..> DBConnection : "uses"
    OrderItemDAO ..> DBConnection : "uses"
    WishlistDAO ..> DBConnection : "uses"
```

---

## 3. End-to-End Sequence Diagrams

### Flow A: User Registration & Authentication
This sequence traces a user registering a new profile, hashing their password using Blowfish (`BCrypt`), and then logging in to create a server session.

```mermaid
sequenceDiagram
    autonumber
    actor Customer as Client (Browser)
    participant RegServlet as RegisterServlet
    participant LogServlet as LoginServlet
    participant UserDAO as UserDAO
    participant PassUtil as PasswordUtil
    participant DB as MySQL Database

    Note over Customer, DB: User Registration
    Customer->>RegServlet: POST /register (fullName, email, password, phone, gender, address)
    RegServlet->>UserDAO: getUserByEmail(email)
    UserDAO->>DB: SELECT * FROM users WHERE email = ?
    DB-->>UserDAO: [No record found]
    UserDAO-->>RegServlet: null
    RegServlet->>PassUtil: hashPassword(password)
    PassUtil-->>RegServlet: hashedPassword
    RegServlet->>UserDAO: registerUser(newUserObject)
    UserDAO->>DB: INSERT INTO users (full_name, email, phone, password, gender, address) VALUES (?,?,?,?,?,?)
    DB-->>UserDAO: 1 row affected
    UserDAO-->>RegServlet: true
    RegServlet-->>Customer: Redirect to /login (with registration success message)

    Note over Customer, DB: User Log In
    Customer->>LogServlet: POST /login (email, password)
    LogServlet->>UserDAO: getUserByEmail(email)
    UserDAO->>DB: SELECT * FROM users WHERE email = ?
    DB-->>UserDAO: User record (including hashedPassword)
    UserDAO-->>LogServlet: userObject
    LogServlet->>PassUtil: checkPassword(password, userObject.password)
    PassUtil-->>LogServlet: true (match confirmed)
    LogServlet->>LogServlet: Create HttpSession, setAttribute("user", userObject)
    LogServlet-->>Customer: Redirect to /home (session active)
```

---

### Flow B: Catalog Navigation & Wishlist Operations
This sequence explains how product searches are queried, variants are resolved, and items are toggled in and out of the wishlist database table.

```mermaid
sequenceDiagram
    autonumber
    actor Customer as Client (Browser)
    participant ProdServlet as ProductServlet
    participant DetServlet as ProductDetailsServlet
    participant WishServlet as ToggleWishlistServlet
    participant ProdDAO as ProductDAO
    participant VarDAO as ProductVariantDAO
    participant WishDAO as WishlistDAO
    participant DB as MySQL Database

    Note over Customer, DB: Product Listing & Filter
    Customer->>ProdServlet: GET /products?category=2 (Ethnic Wear)
    ProdServlet->>ProdDAO: getProductsByCategory(2)
    ProdDAO->>DB: SELECT p.*, c.category_name FROM products p JOIN categories c... WHERE p.category_id = 2 AND p.is_active = true
    DB-->>ProdDAO: List of Products
    ProdDAO-->>ProdServlet: List<Product>
    ProdServlet-->>Customer: Render products.jsp

    Note over Customer, DB: View Product Details & Sizes
    Customer->>DetServlet: GET /product-details?id=12
    DetServlet->>ProdDAO: getProductById(12)
    ProdDAO->>DB: SELECT p.*, c.category_name FROM products p JOIN categories c... WHERE p.product_id = 12
    DB-->>ProdDAO: Product details
    ProdDAO-->>DetServlet: Product object
    DetServlet->>VarDAO: getVariantsByProductId(12)
    VarDAO->>DB: SELECT * FROM product_sizes WHERE product_id = 12
    DB-->>VarDAO: List of Variants (Sizes & Stock status)
    VarDAO-->>DetServlet: List<ProductVariant>
    DetServlet-->>Customer: Render product-details.jsp (with size dropdown)

    Note over Customer, DB: Toggle Wishlist Icon
    Customer->>WishServlet: POST /toggle-wishlist (productId=12, action=add)
    WishServlet->>WishDAO: checkIfInWishlist(userId, 12)
    WishDAO->>DB: SELECT 1 FROM wishlist WHERE user_id = ? AND product_id = ?
    DB-->>WishDAO: [No record]
    WishDAO-->>WishServlet: false
    WishServlet->>WishDAO: addProductToWishlist(userId, 12)
    WishDAO->>DB: INSERT INTO wishlist (user_id, product_id) VALUES (?, ?)
    DB-->>WishDAO: 1 row affected
    WishDAO-->>WishServlet: true
    WishServlet-->>Customer: Redirect back to referring page (Wishlist state updated)
```

---

### Flow C: Shopping Cart & Dynamic Pricing Validation
This flow details cart updates, specifically demonstrating how the catalog price is fetched dynamically from the `products` table on load to ensure that cart values are always up to date.

```mermaid
sequenceDiagram
    autonumber
    actor Customer as Client (Browser)
    participant CartServlet as CartServlet
    participant UpdateServlet as UpdateCartServlet
    participant CartDAO as CartDAO
    participant ItemDAO as CartItemDAO
    participant DB as MySQL Database

    Note over Customer, DB: Loading Cart (Dynamic Pricing)
    Customer->>CartServlet: GET /cart
    CartServlet->>CartDAO: getCartByUserId(userId)
    CartDAO->>DB: SELECT * FROM cart WHERE user_id = ?
    DB-->>CartDAO: Cart record
    CartDAO-->>CartServlet: Cart object
    CartServlet->>ItemDAO: getItemsByCartId(cartId)
    Note over ItemDAO, DB: SQL join with PRODUCTS table guarantees<br/>current catalog prices are fetched, not stale cart values.
    ItemDAO->>DB: SELECT ci.*, p.product_name, p.unit_price AS current_unit_price, p.image_url... FROM cart_items ci JOIN products p ON ci.product_id = p.product_id WHERE ci.cart_id = ?
    DB-->>ItemDAO: List of items with active prices
    ItemDAO-->>CartServlet: List<CartItem>
    CartServlet->>CartServlet: Sum (current_unit_price * quantity)
    CartServlet-->>Customer: Render cart.jsp (Correct, updated total displayed)

    Note over Customer, DB: Update Item Quantity
    Customer->>UpdateServlet: POST /update-cart (cartItemId=5, quantity=3)
    UpdateServlet->>ItemDAO: updateItemQuantity(5, 3)
    ItemDAO->>DB: UPDATE cart_items SET quantity = ?, added_at = CURRENT_TIMESTAMP WHERE cart_item_id = ?
    DB-->>ItemDAO: Success (1 row updated)
    ItemDAO-->>UpdateServlet: true
    UpdateServlet-->>Customer: Redirect to /cart (page refreshes to reflect new quantity and totals)
```

---

### Flow D: Checkout & Order Placement
This transaction handles checkout validation, inventory reduction (decrease stock per size variant), order writing, and cart clearing.

```mermaid
sequenceDiagram
    autonumber
    actor Customer as Client (Browser)
    participant PlaceServlet as PlaceOrderServlet
    participant CartDAO as CartDAO
    participant ItemDAO as CartItemDAO
    participant VarDAO as ProductVariantDAO
    participant OrderDAO as OrderDAO
    participant ItemDAOrder as OrderItemDAO
    participant DB as MySQL Database

    Customer->>PlaceServlet: POST /place-order (paymentMethod, deliveryAddress)
    PlaceServlet->>CartDAO: getCartByUserId(userId)
    CartDAO->>DB: SELECT * FROM cart WHERE user_id = ?
    DB-->>CartDAO: Cart record
    CartDAO-->>PlaceServlet: Cart object
    PlaceServlet->>ItemDAO: getItemsByCartId(cartId)
    ItemDAO->>DB: Fetch cart items joined with current product prices
    DB-->>ItemDAO: List<CartItem>
    ItemDAO-->>PlaceServlet: cartItems list
    
    Note over PlaceServlet: Compute totalAmount using current prices
    
    PlaceServlet->>OrderDAO: createOrder(orderObject)
    OrderDAO->>DB: INSERT INTO orders (user_id, total_amount, payment_method, order_status, delivery_address) VALUES (?,?,?,?,?)
    DB-->>OrderDAO: Success (Returns auto-incremented order_id)
    OrderDAO-->>PlaceServlet: orderId (e.g., 204)
    
    loop For each CartItem in cartItems
        PlaceServlet->>VarDAO: decreaseStock(productId, sizeLabel, quantity)
        VarDAO->>DB: UPDATE product_sizes SET stock_quantity = stock_quantity - ? WHERE product_id = ? AND size_label = ?
        DB-->>VarDAO: Success
        VarDAO-->>PlaceServlet: true
    end
    
    PlaceServlet->>ItemDAOrder: addOrderItems(orderItemsList)
    ItemDAOrder->>DB: Batch INSERT INTO order_items (order_id, product_id, quantity, unit_price, subtotal, size_label) VALUES (?,?,?,?,?,?)
    DB-->>ItemDAOrder: Success
    ItemDAOrder-->>PlaceServlet: true
    
    PlaceServlet->>CartDAO: clearCart(cartId)
    CartDAO->>DB: DELETE FROM cart_items WHERE cart_id = ?
    DB-->>CartDAO: Success
    CartDAO-->>PlaceServlet: true
    
    PlaceServlet-->>Customer: Redirect to /order-details?id=204&success=true (Order summary page)
```

---

## 4. Database Design & Model Mapping

### Entity-Relationship (ER) Diagram
The database consists of 9 core tables. The relationships are shown in the ER diagram below:

```mermaid
erDiagram
    USERS {
        int user_id PK
        varchar full_name
        varchar email UK
        varchar phone
        varchar password
        varchar gender
        varchar address
    }
    CATEGORIES {
        int category_id PK
        varchar category_name
        text description
        boolean is_active
    }
    PRODUCTS {
        int product_id PK
        int category_id FK
        varchar product_name
        text description
        decimal discount_percent
        varchar image_url
        boolean is_active
        decimal unit_price
    }
    PRODUCT_SIZES {
        int product_size_id PK
        int product_id FK
        varchar size_label
        int stock_quantity
        varchar sku_code
        boolean is_available
    }
    WISHLIST {
        int user_id PK, FK
        int product_id PK, FK
        timestamp added_date
    }
    CART {
        int cart_id PK
        int user_id FK
        timestamp created_at
        timestamp updated_at
    }
    CART_ITEMS {
        int cart_item_id PK
        int cart_id FK
        int product_id FK
        varchar size_label
        int quantity
        decimal unit_price
        timestamp added_at
    }
    ORDERS {
        int order_id PK
        int user_id FK
        timestamp order_date
        decimal total_amount
        varchar payment_method
        varchar order_status
        varchar delivery_address
    }
    ORDER_ITEMS {
        int order_item_id PK
        int order_id FK
        int product_id FK
        int quantity
        decimal unit_price
        decimal subtotal
        varchar size_label
    }

    USERS ||--o| CART : "owns"
    USERS ||--o{ ORDERS : "places"
    USERS ||--o{ WISHLIST : "favorites"
    CATEGORIES ||--o{ PRODUCTS : "groups"
    PRODUCTS ||--o{ PRODUCT_SIZES : "has sizes"
    PRODUCTS ||--o{ WISHLIST : "added to"
    CART ||--o{ CART_ITEMS : "contains"
    PRODUCTS ||--o{ CART_ITEMS : "referenced by"
    ORDERS ||--o{ ORDER_ITEMS : "has items"
    PRODUCTS ||--o{ ORDER_ITEMS : "referenced by"
```

### Relational Schema to Java Class Mapping

| Database Table | Column Name | Java Model Class | Property Name | Java Type | Description / Key Constraint |
|:---|:---|:---|:---|:---|:---|
| **`users`** | `user_id` | `User` | `userId` | `int` | Primary Key, Auto-increment |
| | `full_name` | | `fullName` | `String` | |
| | `email` | | `email` | `String` | Unique index, used for authentication |
| | `phone` | | `phone` | `String` | |
| | `password` | | `password` | `String` | BCrypt encrypted hash string |
| | `gender` | | `gender` | `String` | |
| | `address` | | `address` | `String` | Default delivery address |
| **`categories`** | `category_id` | `Category` | `categoryId` | `int` | Primary Key |
| | `category_name` | | `categoryName` | `String` | |
| | `description` | | `description` | `String` | |
| | `is_active` | | `isActive` | `boolean` | Status flag |
| **`products`** | `product_id` | `Product` | `productId` | `int` | Primary Key |
| | `category_id` | | `categoryId` | `int` | Foreign Key referencing `categories` |
| | `product_name` | | `productName` | `String` | |
| | `description` | | `description` | `String` | Product specifications |
| | `discount_percent`| | `discountPercent` | `BigDecimal` | Percentage discount |
| | `image_url` | | `imageUrl` | `String` | Path to image asset |
| | `is_active` | | `isActive` | `boolean` | Status flag |
| | `unit_price` | | `unitPrice` | `BigDecimal` | Current catalog unit price |
| **`product_sizes`** | `product_size_id` | `ProductVariant` | `productSizeId` | `int` | Primary Key |
| | `product_id` | | `productId` | `int` | Foreign Key referencing `products` |
| | `size_label` | | `sizeLabel` | `String` | Size code (e.g. S, M, L, XL, N/A) |
| | `stock_quantity` | | `stockQuantity` | `int` | Physical inventory count |
| | `sku_code` | | `skuCode` | `String` | Unique SKU identifier |
| | `is_available` | | `isAvailable` | `boolean` | Stock availability flag |
| **`cart`** | `cart_id` | `Cart` | `cartId` | `int` | Primary Key |
| | `user_id` | | `userId` | `int` | Foreign Key referencing `users` |
| | `created_at` | | `createdAt` | `Timestamp` | |
| | `updated_at` | | `updatedAt` | `Timestamp` | |
| **`cart_items`** | `cart_item_id` | `CartItem` | `cartItemId` | `int` | Primary Key |
| | `cart_id` | | `cartId` | `int` | Foreign Key referencing `cart` |
| | `product_id` | | `productId` | `int` | Foreign Key referencing `products` |
| | `size_label` | | `sizeLabel` | `String` | Mapped selected size |
| | `quantity` | | `quantity` | `int` | |
| | `unit_price` | | `unitPrice` | `BigDecimal` | Historical price at addition |
| | `added_at` | | `addedAt` | `Timestamp` | Timestamp of update |
| **`orders`** | `order_id` | `Order` | `orderId` | `int` | Primary Key |
| | `user_id` | | `userId` | `int` | Foreign Key referencing `users` |
| | `order_date` | | `orderDate` | `Timestamp` | Order placement timestamp |
| | `total_amount` | | `totalAmount` | `BigDecimal` | Sum total of the order items |
| | `payment_method` | | `paymentMethod` | `String` | COD, Card, or UPI |
| | `order_status` | | `orderStatus` | `String` | Pending, Shipped, Delivered |
| | `delivery_address`| | `deliveryAddress` | `String` | Explicit delivery address |
| **`order_items`** | `order_item_id` | `OrderItem` | `orderItemId` | `int` | Primary Key |
| | `order_id` | | `orderId` | `int` | Foreign Key referencing `orders` |
| | `product_id` | | `productId` | `int` | Foreign Key referencing `products` |
| | `quantity` | | `quantity` | `int` | |
| | `unit_price` | | `unitPrice` | `BigDecimal` | Purchase unit price |
| | `subtotal` | | `subtotal` | `BigDecimal` | `quantity` * `unit_price` |
| | `size_label` | | `sizeLabel` | `String` | Mapped size descriptor |

---

## 5. Controller-to-DAO Mappings

This matrix maps each of the **17 HTTP Servlets** to the **DAO layers** they instantiate, execute, and retrieve data from.

| Controller / Servlet Name | URL Pattern | Associated DAO(s) | Primary Purpose / Operations |
|:---|:---|:---|:---|
| **`AddToCartServlet`** | `/add-to-cart` | `CartDAO`, `CartItemDAO` | Resolves cart record for user; adds item or updates quantity if duplicate |
| **`CartServlet`** | `/cart` | `CartDAO`, `CartItemDAO` | Retrieves cart and nested cart items (loads dynamic product price) for rendering |
| **`CheckoutServlet`** | `/checkout` | `CartDAO`, `CartItemDAO` | Loads delivery address details and final cart values to prepare order |
| **`HomeServlet`** | `/home` | `CategoryDAO`, `ProductDAO` | Loads core home page slider, category options, and popular collections |
| **`LoginServlet`** | `/login` | `UserDAO`, `WishlistDAO` | Verifies user credentials, hashes checks, and fetches initial user wishlist set |
| **`LogoutServlet`** | `/logout` | *None* | Invalidates the active HttpSession and logs user out |
| **`OrderDetailsServlet`**| `/order-details`| `OrderDAO`, `OrderItemDAO` | Fetches details of a specific order transaction, listing purchase items |
| **`OrdersServlet`** | `/my-orders` | `OrderDAO` | Lists all historical orders placed by the current user |
| **`PlaceOrderServlet`** | `/place-order` | `CartDAO`, `CartItemDAO`, `OrderDAO`, `OrderItemDAO`, `ProductVariantDAO` | Oversees order transaction processing: inserts orders, decrements size stock, writes order items, and flushes cart |
| **`ProductDetailsServlet`**| `/product-details`| `ProductDAO`, `ProductVariantDAO` | Loads main details and all related stock size variations for a product |
| **`ProductServlet`** | `/products` | `ProductDAO`, `CategoryDAO` | Lists products with active category filtering or textual search queries |
| **`ProfileServlet`** | `/profile` | `UserDAO` | Retrieves and updates user attributes (phone, address, full name) |
| **`RegisterServlet`** | `/register` | `UserDAO` | Validates email uniqueness, salts/hashes password, and writes user row |
| **`RemoveCartItemServlet`**| `/remove-cart-item`| `CartItemDAO` | Removes a specific item record from the database cart mapping |
| **`ToggleWishlistServlet`**| `/toggle-wishlist`| `WishlistDAO` | Adds or removes a user-product record link from the wishlist table |
| **`UpdateCartServlet`** | `/update-cart` | `CartItemDAO` | Modifies the quantity of a cart item or removes it if quantity is zero |
| **`WishlistServlet`** | `/wishlist` | `WishlistDAO` | Retrieves all product items favorited by the user for rendering |
