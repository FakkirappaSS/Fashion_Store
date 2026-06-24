# 🛍️ FashionStore - E-Commerce Web Application

FashionStore is a premium, fully responsive Java EE e-commerce web application designed for a seamless fashion shopping experience. Built using Jakarta Servlets, JSP (JavaServer Pages), JSTL, Maven, and MySQL, the app features dynamic products, real-time cart pricing, an interactive wishlist, checkout workflows, and order tracking.

---

## 🚀 Key Features

*   **🏡 Dynamic Homepage & Slider**: A gorgeous user interface featuring category-based navigation (Men Casuals, Ethnic Wear, Activewear, and Winter Collection) and custom-themed hero banners.
*   **💖 Active Wishlist Integration**: Users can bookmark their favorite items directly from product cards or detail pages. It persists in the database and updates state instantly across all views.
*   **🛒 Advanced Shopping Cart**: Real-time pricing tied directly to the database. Supports size selection and dynamically calculates subtotal and order totals.
*   **📐 Smart Size & Stock Selector**: Automatically hides/disables size selection for accessories or out-of-stock items, gracefully falling back to a compliant non-sized (`N/A`) option.
*   **💳 Checkout & Order Placement**: Full checkout pipeline with address capture and multi-mode payment options (Card, UPI, COD).
*   **📦 Order Tracking & History**: A dedicated view showing order history, status details (Pending/Delivered), and list of items purchased.

---

## 🛠️ Technology Stack

*   **Backend**: Java SE 17, Jakarta Servlet API 6.0, JSTL (Jakarta Standard Tag Library)
*   **Frontend**: HTML5, CSS3 (Vanilla), JavaScript (ES6), JSP
*   **Database**: MySQL 8.x
*   **Dependency Management & Build**: Apache Maven 3.x
*   **App Server**: Apache Tomcat 10.1.x

---

## 📂 Project Structure

```text
FashionStore/
├── src/
│   ├── main/
│   │   ├── java/                 # Java Servlets, DAOs, Models, and Utilities
│   │   │   └── com/fashionstore/
│   │   │       ├── controller/   # Web Servlets (Cart, Wishlist, Products, Orders)
│   │   │       ├── dao/          # Database Access Objects (CRUD Operations)
│   │   │       ├── filter/       # Authentication and Request Filters
│   │   │       ├── model/        # Database Entity Mapping Classes
│   │   │       └── util/         # DB Connection Helper (Singleton Class)
│   │   └── webapp/               # Web Assets and Views
│   │       ├── WEB-INF/
│   │       │   └── views/        # JSP templates (cart, products, checkout, etc.)
│   │       └── assets/           # Frontend Styles (CSS), JS, and Local Images
├── pom.xml                       # Maven Configuration file
└── README.md                     # Documentation
```

---

## 💻 Local Setup & Execution

### 1. Prerequisites
Ensure you have the following installed:
*   Java Development Kit (JDK 17 or higher)
*   MySQL Server (v8.0+)
*   Apache Maven
*   Apache Tomcat Server (v10.1+)

### 2. Database Configuration
1. Start your local MySQL database.
2. Create a schema named `fashionstore`:
   ```sql
   CREATE DATABASE fashionstore;
   ```
3. Set up the required tables (`users`, `categories`, `products`, `product_sizes`, `wishlist`, `orders`, `order_items`, `cart`, `cart_items`).
4. Update the DB credentials in `src/main/java/com/fashionstore/util/DBConnection.java` if they differ from the default (`root`/`root`):
   ```java
   private static final String URL = "jdbc:mysql://localhost:3306/fashionstore?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
   private static final String USER = "your_username";
   private static final String PASSWORD = "your_password";
   ```

### 3. Build the Application
Compile the project and package it into a `.war` archive using Maven:
```bash
mvn clean package -DskipTests
```
This builds `target/FashionStore.war`.

### 4. Deploy and Run
*   **Tomcat deployment**: Copy `target/FashionStore.war` to Tomcat's `webapps/` directory, and start Tomcat.
*   **Access the Web App**: Open your browser and navigate to `http://localhost:8080/FashionStore/`.

---

## 🌐 Deploying Live (Production Setup)

Follow these steps to deploy the application on a public production cloud environment:

### Step 1: Provision a Production Database
1. Launch a managed MySQL instance (such as **AWS RDS MySQL**, **Google Cloud SQL**, or a hosted database on **Aiven** / **PlanetScale**).
2. Connect to the cloud database using a MySQL client and run your SQL schema structure and seed data.
3. Update `DBConnection.java` inside the code with your production JDBC connection string, username, and password, or fetch them securely using Environment Variables:
   ```java
   private static final String URL = System.getenv("DB_URL");
   private static final String USER = System.getenv("DB_USER");
   private static final String PASSWORD = System.getenv("DB_PASSWORD");
   ```

### Step 2: Choose a Cloud Hosting Provider
You can host a Java WAR file using several different cloud hosting approaches:

#### Option A: Platform as a Service (PaaS) - Recommended for simplicity
*   **AWS Elastic Beanstalk**:
    1. Select the **Tomcat** platform environment.
    2. Upload the `target/FashionStore.war` file directly through the AWS Console.
    3. Configure Database connection credentials under Environment Properties.
*   **Render / Heroku / Railway**:
    1. Wrap the app with a Dockerfile running a Tomcat base image:
       ```dockerfile
       FROM tomcat:10.1-jdk17
       COPY target/FashionStore.war /usr/local/tomcat/webapps/ROOT.war
       EXPOSE 8080
       CMD ["catalina.sh", "run"]
       ```
    2. Connect your GitHub repository to the hosting platform and deploy it as a Web Service.

#### Option B: Virtual Private Server (VPS) - Self-Hosted
*   **DigitalOcean Droplet / AWS EC2 / Linode (Ubuntu Server)**:
    1. Install Java and Tomcat:
       ```bash
       sudo apt update
       sudo apt install openjdk-17-jdk tomcat10
       ```
    2. Copy your built `FashionStore.war` file to `/var/lib/tomcat10/webapps/ROOT.war`.
    3. Install and run MySQL locally on the VPS or link to your managed DB instance.
    4. Start Tomcat:
       ```bash
       sudo systemctl restart tomcat10
       ```

### Step 3: Domain & HTTPS Setup
1. Map your domain name (e.g., `www.yourstore.com`) to your server/load balancer IP address using DNS A/CNAME records.
2. Install SSL certificates (via **Let's Encrypt** / **Certbot** for Nginx/Tomcat VPS, or use cloud-provided certificates on AWS Elastic Beanstalk/PaaS) to ensure connections are secure over HTTPS.
