# Pinterest Clone – Pixel Perfect Flutter Implementation

A high-performance, visually accurate Pinterest clone built with Flutter. This project focuses on delivering a "pixel-perfect" UI, fluid animations, and a scalable architecture, utilizing the Pexels API for high-quality visual content.

## 🚀 Overview

This application is designed to mimic the core Pinterest experience. From the signature staggered grid layout to the intricate "Save" animations and smooth navigation transitions, every detail has been crafted to meet professional UI/UX standards.

### Key Features
* **Dynamic Staggered Feed:** Real-time image and video fetching using the Pexels API.
* **Advanced Search:** Integrated search functionality with curated collections.
* **Local Persistence:** User boards and saved pins are managed locally via **Hive**.
* **Complex Animations:** Custom-built save animations and transition effects (inspired by Pinterest’s micro-interactions).
* **Multi-Step Auth:** A polished onboarding flow including country picking, age verification, and secure password creation.

---

## 🏗 Architecture & Tech Stack

This project follows a **Clean Architecture** pattern to ensure separation of concerns and maintainability.

### Data Layer
* **Pexels API:** Primary source for high-resolution images, videos, and curated collections.
* **Dio:** Utilized for networking with custom interceptors and robust error handling.
* **Hive:** Light-weight and blazing-fast key-value database for local caching and user data.

### State Management
* **Provider:** Used for efficient, reactive state management across the app, ensuring the UI stays in sync with data changes without unnecessary rebuilds.

### Architecture Diagram
> *Following the structure provided in the project documentation (Data -> Repository -> Provider -> UI)*

---

## 🛠 Project Structure

```text
lib/
├── core/                # Constants, Themes, Global Keys, and API Services
├── data/                # Local Models (Hive) and Repository Implementations
├── presentation/        
│   ├── models/          # View Models for UI logic
│   ├── screens/         # Main application screens (Feed, Profile, Search)
│   ├── state_management/# Providers and Notifiers
│   ├── widgets/         # Reusable UI components (Tiles, Bottom Sheets, Shimmers)
│   └── services/        # Authentication and Auth Logic
└── reusable_element/    # Global reusable UI elements (Nav Bars, Loaders)