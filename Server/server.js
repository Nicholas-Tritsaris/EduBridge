// Import required modules
const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
const nodemailer = require('nodemailer');
const crypto = require('crypto');

// Initialize Express app
const app = express();
const PORT = process.env.PORT || 5000;

// Middleware
app.use(cors());
app.use(bodyParser.json());

// In-memory storage (replace with database in production)
const users = {};
const verificationCodes = {};

// Email transporter configuration (configure with your email service)
const transporter = nodemailer.createTransport({
  service: 'gmail',
  auth: {
    user: process.env.EMAIL_USER || 'your-email@gmail.com',
    pass: process.env.EMAIL_PASSWORD || 'your-app-password',
  },
});

// Helper function to generate verification code
const generateVerificationCode = () => {
  return crypto.randomBytes(3).toString('hex').toUpperCase();
};

// Helper function to send verification email
const sendVerificationEmail = async (email, code) => {
  const mailOptions = {
    from: process.env.EMAIL_USER || 'your-email@gmail.com',
    to: email,
    subject: 'EduBridge Email Verification',
    html: `
      <h1>Welcome to EduBridge!</h1>
      <p>Your verification code is: <strong>${code}</strong></p>
      <p>Please enter this code in the app to verify your email.</p>
    `,
  };

  try {
    await transporter.sendMail(mailOptions);
    console.log('Verification email sent to', email);
  } catch (error) {
    console.error('Failed to send email:', error);
  }
};

// Routes
app.get('/', (req, res) => {
  res.send('EduBridge Backend is running');
});

// Authentication Routes
app.post('/api/auth/signup', async (req, res) => {
  const { email, password } = req.body;

  // Validate input
  if (!email || !password) {
    return res.status(400).json({ success: false, message: 'Email and password are required' });
  }

  // Check if user already exists
  if (users[email]) {
    return res.status(400).json({ success: false, message: 'User already exists' });
  }

  // Create user (in production, hash the password)
  users[email] = {
    password,
    verified: false,
  };

  // Generate and send verification code
  const code = generateVerificationCode();
  verificationCodes[email] = code;
  await sendVerificationEmail(email, code);

  res.status(201).json({ success: true, message: 'User created. Verification email sent.' });
});

app.post('/api/auth/login', (req, res) => {
  const { email, password } = req.body;

  // Validate input
  if (!email || !password) {
    return res.status(400).json({ success: false, message: 'Email and password are required' });
  }

  // Check if user exists
  if (!users[email]) {
    return res.status(401).json({ success: false, message: 'Invalid email or password' });
  }

  // Check password (in production, compare hashed password)
  if (users[email].password !== password) {
    return res.status(401).json({ success: false, message: 'Invalid email or password' });
  }

  // Check if email is verified
  if (!users[email].verified) {
    return res.status(403).json({ success: false, message: 'Email not verified. Please check your email for verification code.' });
  }

  res.status(200).json({
    success: true,
    message: 'Login successful',
    token: 'jwt-token-here',
    user: { email: email, verified: true }
  });
});

app.post('/api/auth/verify-email', (req, res) => {
  const { email, code } = req.body;

  // Validate input
  if (!email || !code) {
    return res.status(400).json({ success: false, message: 'Email and code are required' });
  }

  // Check if verification code matches
  if (verificationCodes[email] !== code) {
    return res.status(400).json({ success: false, message: 'Invalid verification code' });
  }

  // Mark user as verified
  if (users[email]) {
    users[email].verified = true;
    delete verificationCodes[email];
    res.status(200).json({
      success: true,
      message: 'Email verified successfully',
      token: 'jwt-token-here',
      user: { email: email, verified: true }
    });
  } else {
    res.status(400).json({ success: false, message: 'User not found' });
  }
});

// Resend Verification Code
app.post('/api/auth/resend-verification', async (req, res) => {
  const { email } = req.body;

  // Validate input
  if (!email) {
    return res.status(400).json({ success: false, message: 'Email is required' });
  }

  // Check if user exists
  if (!users[email]) {
    return res.status(400).json({ success: false, message: 'User not found' });
  }

  // Generate and send new verification code
  const code = generateVerificationCode();
  verificationCodes[email] = code;
  await sendVerificationEmail(email, code);

  res.status(200).json({ success: true, message: 'Verification code sent to your email' });
});

// Classroom Routes
app.post('/api/classrooms', (req, res) => {
  // Logic to create a classroom
  res.status(201).send('Classroom created');
});

app.get('/api/classrooms', (req, res) => {
  // Logic to fetch classrooms
  res.status(200).send('Classrooms fetched');
});

// Assignment Routes
app.post('/api/assignments', (req, res) => {
  // Logic to create an assignment
  res.status(201).send('Assignment created');
});

app.get('/api/assignments', (req, res) => {
  // Logic to fetch assignments
  res.status(200).send('Assignments fetched');
});

// Messaging Routes
app.post('/api/messages', (req, res) => {
  // Logic to send a message
  res.status(201).send('Message sent');
});

app.get('/api/messages', (req, res) => {
  // Logic to fetch messages
  res.status(200).send('Messages fetched');
});

// Start server
app.listen(PORT, () => {
  console.log(`Server is running on http://localhost:${PORT}`);
});