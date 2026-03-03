# iOS EduBridge App - Swift

A native iOS application for EduBridge built with Swift and UIKit.

## Features

- **Native iOS Development**: Built with Swift and UIKit
- **User Authentication**: Sign up, login, and email verification
- **RESTful API Integration**: Communicates with Node.js backend server
- **User Dashboard**: Access classrooms, assignments, messaging, and analytics
- **Error Handling**: Comprehensive network error handling and validation
- **Responsive UI**: Adaptive layouts for all iPhone sizes

## Architecture

### Application Files

1. **AppDelegate.swift** (50 lines)
   - Application entry point
   - Window setup and root view controller configuration

2. **SceneDelegate.swift** (30 lines)
   - Scene lifecycle management for modern iOS apps
   - Window scene setup and restoration

3. **ApiClient.swift** (150+ lines)
   - URLSession-based HTTP client
   - Auth endpoints: signup, login, verify-email, resend-verification
   - Response model decodable types
   - Error handling with custom error types

4. **LoginViewController.swift** (300+ lines)
   - UIViewController for user login
   - Email and password text fields with validation
   - Sign in button with loading indicator
   - Navigation to signup and dashboard screens
   - Responsive scrollable layout

5. **SignupViewController.swift** (350+ lines)
   - UIViewController for new account creation
   - 3 input fields: email, password, confirm password
   - Password validation (minimum 6 characters)
   - Password confirmation matching
   - Navigation to email verification on success
   - Styled form fields with error display

6. **EmailVerificationViewController.swift** (250+ lines)
   - Verification code entry screen
   - 6-character uppercase code input with auto-formatting
   - Resend code functionality
   - API integration with error handling
   - Success navigation to dashboard

7. **DashboardViewController.swift** (300+ lines)
   - Post-login user interface
   - Welcome message with user email
   - Feature cards grid (Classrooms, Assignments, Messaging, Analytics)
   - Scrollable content with sections
   - Logout button functionality
   - Card-based UI with icons and descriptions

## API Integration

**Base URL**: `http://192.168.1.100:5000` (configured for local development)

### Endpoints

- **POST /api/auth/signup**
  - Request: { email: string, password: string }
  - Response: { success: bool, message: string, token?: string, user?: UserData }

- **POST /api/auth/login**
  - Request: { email: string, password: string }
  - Response: { success: bool, message: string, token?: string, user?: UserData }

- **POST /api/auth/verify-email**
  - Request: { email: string, code: string }
  - Response: { success: bool, message: string, token?: string, user?: UserData }

- **POST /api/auth/resend-verification**
  - Request: { email: string }
  - Response: { success: bool, message: string }

## Data Models

### UserData (Codable)
- `email: String` - User's email address
- `verified: Bool` - Email verification status

### AuthResponse (Codable)
- `success: Bool` - Operation success indicator
- `message: String` - Response message
- `token: String?` - Authentication token
- `user: UserData?` - User information

### APIBaseResponse (Codable)
- `success: Bool` - Operation success
- `message: String` - Response message

## UI Features

### Typography and Colors
- **Primary Color**: #667eea (RGB: 102, 126, 234)
- **Secondary Color**: #764ba2 (RGB: 118, 75, 162)
- **Text Color**: Dark gray (#333333)
- **Border Color**: Light gray (#e0e0e0)

### Form Components
- Rounded text fields with 2pt borders
- Email keyboard type for email fields
- Secure text entry for password fields
- Uppercase keyboard for verification codes
- Loading indicators during API calls

### Navigation
- UINavigationController for screen transitions
- Push navigation on successful actions
- Pop navigation for back buttons
- Root view controller reset on logout

## Developer Setup

### Requirements
- Xcode 13.0+
- Swift 5.5+
- Minimum iOS Deployment Target: iOS 13.0
- Cocoapods (optional, for dependency management)

### Build and Run
1. Open `EduBridge.iOS.xcodeproj` in Xcode
2. Select your target device or simulator
3. Press Cmd+R to build and run

### Configuration
Update the `baseURL` in `ApiClient.swift` to match your server:
```swift
private let baseURL = "http://YOUR_SERVER_IP:5000"
```

## Network Error Handling

The app handles three types of errors:
- **Invalid URL**: Malformed API endpoints
- **Decoding Error**: Failed JSON parsing
- **Network Error**: Connection issues with detailed error messages

All errors are displayed to users via UIAlertController with helpful context.

## State Management

- UIViewController-based state management
- UIActivityIndicatorView for loading states
- Per-field error display in login/signup forms
- Navigation-based screen transitions
- Button enable/disable during API calls

## Validation

### Email Validation
- Standard email format validation via regex pattern

### Password Validation
- Minimum 6 characters requirement
- Password confirmation matching on signup
- Secure text entry for privacy

### Code Validation
- 6-character verification code required
- Uppercase formatting for code entry

## Future Enhancements

- HTTPS/SSL pinning for production
- Keychain integration for secure token storage
- Biometric authentication support
- Offline data caching
- Classroom and assignment features
- Real-time messaging
- Analytics dashboard

## Project Structure

```
iOS/
├── src/
│   ├── AppDelegate.swift
│   ├── SceneDelegate.swift
│   ├── ApiClient.swift
│   ├── LoginViewController.swift
│   ├── SignupViewController.swift
│   ├── EmailVerificationViewController.swift
│   └── DashboardViewController.swift
├── EduBridge.iOS.xcodeproj
├── Info.plist
└── README.md
```

## Notes

- All API communication uses JSON request/response format
- URLSession is used for HTTP requests (no external dependencies)
- UI is built programmatically with Auto Layout constraints
- No XIB files or Storyboards used for maximum flexibility
- Supports both UIKit lifecycle (AppDelegate) and SwiftUI lifecycle (SceneDelegate)

## License

EduBridge iOS App © 2024
