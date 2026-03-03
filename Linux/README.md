# Linux EduBridge App - Electron + React

A cross-platform desktop application for EduBridge running on Linux using Electron and React.

## Features

- **Desktop Application**: Built with Electron for Linux compatibility
- **React Framework**: Modern UI using React 18
- **User Authentication**: Full signup, login, and email verification flow
- **RESTful API Integration**: Communicates with Node.js backend server
- **User Dashboard**: Access to classrooms, assignments, messaging, and analytics
- **Professional UI**: Gradient design with responsive components
- **Error Handling**: Comprehensive validation and network error management

## Architecture

### Application Files

1. **main.js** (60 lines)
   - Electron main process entry point
   - Window creation and lifecycle management
   - Menu bar setup with File, Edit, View options
   - Dev tools integration
   - IPC preload configuration

2. **preload.js** (10 lines)
   - Security bridge between main and renderer processes
   - Context isolation for safe API exposure
   - Electron version information exposure

3. **App.js** (80+ lines)
   - Main React application container
   - Screen state management (login, signup, verification, dashboard)
   - localStorage integration for auth persistence
   - Navigation between screens

4. **App.css** (200+ lines)
   - Global styling and animations
   - Form components styling
   - Button styles (primary, secondary)
   - Status message styling
   - Loading indicator animations
   - Gradient backgrounds and transitions

5. **ApiService.js** (60 lines)
   - Axios HTTP client configured for backend
   - authApi methods: signup, login, verifyEmail, resendVerification
   - Placeholder APIs: classroomApi, assignmentApi, messageApi
   - Centralized API configuration

6. **LoginScreen.js** (120+ lines)
   - Email and password input fields
   - Form validation with error display
   - Sign in button with loading state
   - Link to signup screen
   - Error and success status display

7. **SignupScreen.js** (150+ lines)
   - Three input fields: email, password, confirm password
   - Password strength validation (min 6 characters)
   - Password confirmation matching
   - Signup button with loading state
   - Back button to login

8. **EmailVerificationScreen.js** (140+ lines)
   - 6-character code entry field
   - Auto-uppercase formatting
   - Resend verification code button
   - Back to signup button
   - Loading states for both verify and resend actions

9. **DashboardScreen.js** (150+ lines)
   - Welcome header with user email
   - Logout button
   - Features section with 4 cards (Classrooms, Assignments, Messaging, Analytics)
   - Quick stats section with 3 stat cards
   - Getting started section with 4 numbered steps
   - Account info display with verification status

10. **AuthScreen.css** (10 lines)
    - Styling specific to auth forms
    - Max-width constraints for centered layout

11. **DashboardScreen.css** (250+ lines)
    - Full dashboard layout styling
    - Header with gradient background
    - Feature cards with hover effects
    - Stats grid with gradient styling
    - Steps list with numbered styling
    - Info cards with verification badge
    - Responsive grid layouts

### Directory Structure

```
Linux/
├── src/
│   ├── main.js                (Electron main process)
│   ├── preload.js             (Security bridge)
│   ├── index.js               (React entry)
│   ├── index.css              (Global styles)
│   ├── App.js                 (Main container)
│   ├── App.css                (App styles)
│   ├── ApiService.js          (API client)
│   ├── screens/
│   │   ├── LoginScreen.js
│   │   ├── SignupScreen.js
│   │   ├── EmailVerificationScreen.js
│   │   └── DashboardScreen.js
│   └── styles/
│       ├── AuthScreen.css
│       └── DashboardScreen.css
├── public/
│   └── index.html
├── package.json
├── .gitignore
└── README.md
```

## API Integration

**Base URL**: `http://localhost:5000`

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

### UserData
- `email: string` - User's email address
- `verified: boolean` - Email verification status

### AuthResponse
- `success: boolean` - Operation success indicator
- `message: string` - Response message
- `token: string` - Authentication token
- `user: UserData` - User information

## Development Setup

### Prerequisites
- Node.js 14.0 or higher
- npm or yarn

### Installation

```bash
cd Linux
npm install
```

### Running Development

Development mode with both React dev server and Electron:

```bash
npm run dev
```

This will:
1. Start React development server on http://localhost:3000
2. Launch Electron application connected to React dev server

### Building for Production

```bash
npm run build
npm run dist
```

This creates:
- AppImage for universal Linux
- .deb package for Debian-based distributions

## UI Design

### Color Scheme
- **Primary Gradient**: #667eea to #764ba2
- **Primary Color**: #667eea
- **Secondary Color**: #764ba2
- **Background**: White (#ffffff)
- **Text Dark**: #333333
- **Text Light**: #999999
- **Border**: #e0e0e0

### Components

**Form Inputs**
- Rounded borders with 2px outline
- Focus state with color change
- Placeholder text in light gray
- Full width on smaller screens

**Buttons**
- Primary: Gradient background with white text
- Secondary: Transparent with gradient border
- Disabled state with reduced opacity
- Hover effects with shadow and lift

**Status Messages**
- Success: Green background with darker text
- Error: Red background with darker text
- Info: Blue background with darker text
- Centered alignment

## Features Implemented

### Authentication Flow
✅ User signup with email and password
✅ Password validation (min 6 characters)
✅ Password confirmation matching
✅ Email verification with 6-character code
✅ Resend verification code
✅ User login
✅ localStorage integration for session persistence
✅ Logout functionality

### User Interface
✅ Professional gradient design
✅ Responsive layouts
✅ Form validation and error display
✅ Loading indicators
✅ Smooth animations and transitions
✅ Feature cards with icons
✅ Statistics dashboard
✅ Getting started guide

### Error Handling
✅ Email format validation
✅ Password strength requirements
✅ Network error handling
✅ API error messages
✅ User-friendly error display

## Configuration

### API Base URL
Update the `API_BASE_URL` in `src/ApiService.js` to match your server:

```javascript
const API_BASE_URL = 'http://localhost:5000';
```

### Electron Configuration
Edit `package.json` to customize:
- Application name
- Version
- Author
- Build configurations

## Future Enhancements

- Classroom management interface
- Assignment creation and submission
- Real-time messaging
- Student progress analytics
- File upload functionality
- Dark mode theme
- Offline support with data sync
- System tray integration
- Keyboard shortcuts
- Multi-language support

## Troubleshooting

### Application won't start
- Ensure Node.js is installed: `node --version`
- Clear node_modules and reinstall: `rm -rf node_modules && npm install`
- Check if port 3000 is available

### App can't connect to server
- Verify backend server is running on http://localhost:5000
- Check firewall settings
- Ensure API_BASE_URL is correctly configured

### Build issues
- Clear build cache: `rm -rf build dist`
- Reinstall dependencies: `npm install`
- Check npm version: `npm --version` (should be 6+)

## Performance Optimization

- React code splitting for faster initial load
- Lazy loading of screens
- CSS minification in production
- Electron native preload for security
- Context isolation for process safety

## Security Considerations

- Context isolation enabled
- No Node integration in renderer
- Preload script for safe API exposure
- No eval or dynamic code execution
- Secure authentication token storage via localStorage
- HTTPS recommended for production deployment

## License

EduBridge Linux App © 2024

## Support

For issues or feature requests, please contact the development team.
