# Pawpal – Pet Adoption and Donation App 📱


---

# 🐾 PawPal

**PawPal** is  a **Flutter-based mobile application** designed for pet adoption, donation, and help/rescue reporting.
It uses a **RESTful PHP** backend hosted on **JomHosting (cPanel)** with a **MySQL database**.

---

## 📌 Table of Contents

1. 📱[Project Overview](#project-overview)
2. 🚀[Features](#features)
3. 🛠[Tech Stack](#tech-stack)
4. 🔧[Project Setup](#project-setup)
5. 📂[Folder Structure](#folder-structure)
6. ⚙️[API Usage](#api-usage)
7. ❗[Notes](#notes)

---

## 📱 Project Overview

PawPal allows users to:

* Submit pets for adoption, donation, or report help/rescue pets
* Search based on pet name and filter based on pet type
* Edit or delete own published pet information
* Apply for pet adoption request
* Approve or reject the adoption based on their decision
* Make donation for the needed help
* View donation history
* View and edit profile
* Top up their wallets

The app communicates with a **PHP backed API hosted online**, making it suitable for real deployment.

---

## 🚀 Features

### **1. Pet Management**

* Add pets with name, type, gender, age, category, health, description, images, and location
* Upload a maximum of 3 images per pet
* Associate pets with user accounts

### **2. Adoption Request**

* Show the pet owner and adopter details
* Complete the adoption request form with house type, has owned pet before, and reason
* View the status of the adoption request
* Approve or reject by the poster or the pet owner

### **3. Donation**

* Make donation by selecting the donation types which are **Food**, **Medical**, and **Money**
* Complete the donation form with the selected donation type, the amount to donate, and description

### **4. Donation History**

* View the donation history with pet name, recipient/donor, date, and amount

### **5. Profile**

* View the profile
* Edit name, phone, and image avatar

### **6. Top Up**

* Top up the money in the wallet

---

## 🛠 Tech Stack

|        Layer        |            Technology          |
| ------------------- | -------------------------------|
| Frontend            | Flutter (Dart)                 |
| Backend             | PHP (REST API)                 |
| Database            | MySQL (phpMyAdmin)             |
| Hosting             | cPanel (JomHosting)            |
| API Format          | JSON                           |
| Image Storage       | Server file system             |

---

## 🔧 Project Setup

### **1. Requirements**

* Fultter
* JomHosting
* MySQL 
* Billplz sandbox

### **2. Installation**

1. Clone or copy this whole project and paste it into any folder you want:

```
git clone https://github.com/Bakkien/pawpal.git
cd pawpal
flutter pub get
flutter run
```

2. Upload backend files
  1. Login to *cPanel*
  2. Open *File Manager*
  3. Go to `public_html/`
  4. Upload the `server/` folder contents:
   ```
   public_html/pawpal/server/
   ```

3. Create MySQL database
   1. Open *MySQL Databases* in *cPanel*
   2. Create:
     * Database: `pawpal_db`
     * User + Password
   3. Assign user to database with **ALL PRIVILEGES**

4. Import database
   1. Rename `canortxw_pawpal_db` to `cpanel_pawpal_db`
   2. Open *phpMyAdmin*
   3. Import SQL file `pawpal_db.sql`

5. Configure database connection in **dbconnect.php**:

```php
$servername = "localhost";
$username   = "cpanel_db_user";
$password   = "cpanel_db_password";
$dbname     = "cpanel_db_name";
```

6. Update `lib/myconfig.dart` with your domain.

```dart
// replace with your domain
static const String server = "YOUR_DOMAIN"; 
```

7. Update `server/api/payment.dart` and `server/api/payment_update.dart` with your api key, collection id, and xkey. To get these, you are required to get from `https://sso.billplz-sandbox.com/`

```payment.php
// replace with your api key and collection id
$api_key = 'YOUR_API_KEY';
$collection_id = 'YOUR_COLLECTION_ID';
```

```payment_update.php
// replace with your xkey
$xkey = 'YOUR_X_KEY';
```

8. Ensure all plugins are installed and configured based on the platform

`pubspec.yaml`
```
http: ^1.5.0
shared_preferences: ^2.3.2
geolocator: ^14.0.2
geocoding: ^4.0.0
image_picker: ^1.2.1
image_cropper: ^11.0.0
intl: ^0.20.2
webview_flutter: ^4.13.0
```

`android/src/main/AndroidManifest.xml`
```
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_BACKGROUND_LOCATION" />
/...
<activity
  android:name="com.yalantis.ucrop.UCropActivity"
  android:screenOrientation="portrait"
  android:theme="@style/Theme.AppCompat.Light.NoActionBar"/>
```

---

## 📁 Folder Structure

```
pawpal/
│
├── server/
│   ├── api/
│       ├── dbconnect.php
│       ├── submit_pet.php
│       ├── get_my_pets.php
│       └── ...
│   ├── uploads/
│        ├── pet/
|        |   └──(saved pet images)
│        ├── profile
|            └──(saved user profile images)
```

---

## ⚙️ API Usage

| Endpoint                 | Method | Parameters        | Description                 |
| ------------------------ | ------ | ----------------- | ----------------------------|
| `/delete_pet.php`        | POST   | `userid`, `petid` |Delete a pet record belonging to the specified user from the system. |
| `/get_my_adoptions.php`  | GET    | `userid`          |Retrieves all adoption request made by the specified user. |
| `/get_my_donations.php`  | GET    | `userid`          |Retrieves all donation records made by the specified user. |
| `/get_my_pets.php`       | GET    | `search`, `filter` |Retrieves a list of pets based on search keywords and filter criteria. |
| `/get_user_details.php`  | GET    | `userid`          |Retrieves profile information of a specific user. |
| `/login_user.php`        | POST   | `email`, `password` |Authenticates a user using email and password and returns user details upon success. |
| `/payment.php`           | GET    | `email`, `phone`, `name`, `money`, `userid` |Initiates a payment process for donations made by a user. |
| `/payment_update.php`    | GET    | `email`, `phone`, `name`, `money`, `userid` |Updates the payment status after a successful transaction. |
| `/register_user.php`     | POST   | `name`, `email`, `password`, `phone` |Registers a new user account in the system. |
| `/submit_adoption_request.php` | POST   | `petid`, `userid`, `houseType`, `owned`, `reason`, `status` |Submits an adoption request for a selected pet. |
| `/submit_donation.php`   | POST   | `petid`, `userid`, `donationType`, `amount`, `description` |Submits a donation record related to a pet. |
| `/submit_pet.php`        | POST   | `userid`, `petname`, `pettype`, `gender`, `age`, `category`, `health`, `description`, `latitude`, `longitude`, `images` |Adds a new pet with complete details and multiple images to the system. |
| `/update_adoption.php`   | POST   | `adoption_id`, `pet_id`, `status` |Updates the status of an adoption request (e.g., approve or reject). |
| `/update_pet.php`        | POST   | `petid`, `userid`, `petname`, `pettype`, `gender`, `age`, `category`, `health`, `description`, `latitude`, `longitude`, `images` |Updates existing pet information and images. |
| `/update_profile.php`    | POST   | `userid`, `username`, `uesrphone`, `useravatar` |Updates the user’s profile information including name, phone number, and avatar image. |

---

# ❗ Notes

* Ensure **HTTPS** is enable in cPanel
* API URLs must match your hosting domain
* All uploaded images are stored inside:

  ```
  /server/api/uploads/pet/pet_<id>_<index>.png
  /server/api/uploads/profile/user_<id>.png
  ```
* `image_paths` in database is stored as **JSON array**.

---
