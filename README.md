# Pawpal– Pet Adoption and Donation App


---

# 🐾 PawPal

**PawPal** is  created using **Flutter Code** as frontend,  **PHP (XAMPP)** as backend, and connects to **MySQL** to manage users, pets, and images.

---

## 📌 Table of Contents

1. [Project Setup](#project-setup)
2. [Folder Structure](#folder-structure)
3. [API Endpoints](#api-endpoints)
4. [Submit Pet API](#submit-pet-api)
5. [Sample JSON Request](#sample-json-request)
6. [Response Format](#response-format)

---

## 🚀 Project Setup

### **1. Requirements**

* XAMPP 
* MySQL 
* Flutter  

### **2. Installation**

1. Clone or copy this whole project and paste it here:

   ```
   /xammp/htdocs/pawpal/
   ```

2. Import the database:

   * Open **XAMMP**
   * Start *Apache* and *MySQL*
   * Click *Admin* at *MySQL* side to open *phpMyAdmin*
   * Create a database: **pawpal_db**
   * Import the SQL file in server->pawpal_db.sql

3. Configure database connection in **dbconnect.php**:

```php
<?php
    $servername = "localhost";
    $username = "root";
    $password = "";
    $dbname = "pawpal_db";

    // Create connection
    $conn = new mysqli($servername, $username, $password, $dbname);

    // Check connection
    if ($conn->connect_error) {
        die("Connection failed: " . $conn->connect_error);
    }
?>
```

4. Ensure this folder exists for image uploads:

```
pawpal/server/api/uploads/
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
│        └── (saved pet images)
│       
```

---

5. Ensure all plugins are installed and configured based on the platform

**pubspec.yaml**
```
http: ^1.5.0
shared_preferences: ^2.3.2
geolocator: ^14.0.2
geocoding: ^4.0.0
image_picker: ^1.2.1
image_cropper: ^11.0.0
intl: ^0.20.2
url_launcher: ^6.3.2
```

**android/src/main/AndroidManifest.xml**
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
## 🔌 API Endpoints

| Endpoint                      | Method | Description                                       |
| ----------------------------- | ------ | --------------------------------------------------|
| `/server/api/submit_pet.php`  | POST   | Add new pet with multiple images and information  |
| `/server/api/get_my_pets.php` | GET    | Retrieve all pets and related user info           |


---

# 😺 Submit Pet API

### **URL**

```
POST /pawpal/server/api/submit_pet.php
```


### **Required Fields**

| Field         | Type                | Description                             |
| ------------- | ------------------- | ----------------------------------------|
| `userid`      | int                 | ID of user                              |
| `petname`     | string              | Pet name                                |
| `pettype`     | string              | Pet type (dog, cat, rabbit, other)      |
| `category`    | string              | Category (adopt, lost, donate)          |
| `description` | string              | Pet description                         |
| `latitude`    | string              | Pet location latitude                   |
| `longitude`   | string              | Pet location longitude                  |
| `images`      | JSON array (base64) | List of base64 image strings            |

---

## 📤 Sample JSON Request (Flutter)

```dart
{
  "userid": "12",
  "name": "Doggie",
  "type": "Dog",
  "category": "Donation Request",
  "latitude": "6.4591117",
  "longitude": "100.5022967",
  "description": "He is injured, please help me!",
  "images": [
      "97BORw0KGgoAAAANSUhEUgAABk...",
      "97BORw0KGgzDAsdsadadsAAABBB..."
  ]
}
```

Flutter encoding example:

```dart
http.post(
  Uri.parse("${Myconfig.server}/pawpal/server/api/submit_pet.php"),
  body ： {
  "userid": userId,
  "petname": petName,
  "pettype": petType,
  "category": category,
  "description": description,
  "latitude": lat,
  "longitude": lng,
  "images": jsonEncode(base64ImagesList),
};
```

---

## 🟢 Sample Success Response

```json
{
  "success": true,
  "message": "Pet submitted successfully"
}
```

## 🔴 Sample Error Response

```json
{
  "success": false,
  "message": "Pet not added"
}
```

---

# 📝 Notes

* All uploaded images are stored inside:

  ```
  /server/api/uploads/pet_<id>_<index>.png
  ```
* `image_paths` in database is stored as **JSON array**.

---
