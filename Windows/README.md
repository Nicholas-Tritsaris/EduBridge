# EduBridge Windows Application

A native Windows desktop application for EduBridge, built in C++ with Win32 API.

## Features

- **User Authentication**: Login and signup with email verification
- **Server Integration**: Communicates with the EduBridge backend server
- **Modern UI**: Clean and intuitive Windows interface
- **Cross-Version Support**: Compatible with Windows 10 and later

## Requirements

- Visual Studio 2019 or later
- Windows 10 SDK or later
- C++ 17 or later
- vcpkg for JSON library (jsoncpp)

## Build Instructions

### Option 1: Using Visual Studio

1. Open `EduBridge.Windows.sln` in Visual Studio 2022
2. Install jsoncpp via vcpkg:
   ```
   vcpkg install jsoncpp:x64-windows
   ```
3. Build the project (Ctrl+Shift+B)
4. Run the application (F5)

### Option 2: Command Line

```bash
cd Windows
cmake -B build
cmake --build build
```

## Project Structure

```
Windows/
├── src/
│   ├── main.cpp              # Application entry point
│   ├── HttpClient.h/cpp      # HTTP communication for server integration
│   ├── LoginWindow.h/cpp     # Login screen UI and logic
│   ├── SignupWindow.h/cpp    # Signup screen UI and logic
│   └── AuthScreen.js         # (Legacy - to be removed)
├── EduBridge.Windows.vcxproj # Visual Studio project file
└── EduBridge.Windows.sln     # Solution file
```

## Dependencies

- **WinHTTP**: Built-in Windows API for HTTP requests
- **jsoncpp**: For JSON parsing and serialization
- **Win32 API**: For UI creation and window management

## Connection

The application connects to the EduBridge backend server running on:
- **Default**: `http://localhost:5000`
- **Fallback**: `http://127.0.0.1:5000`

## API Endpoints Used

- `POST /api/auth/login` - User login
- `POST /api/auth/signup` - User registration
- `POST /api/auth/verify-email` - Email verification
- `POST /api/auth/resend-verification` - Resend verification code

## License

Part of the EduBridge project.
