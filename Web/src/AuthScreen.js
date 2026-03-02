// Web Login & Signup Page
import React, { useState } from 'react';
import axios from 'axios';
import './AuthScreen.css';

const AuthScreen = () => {
  const [isLogin, setIsLogin] = useState(true);
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');
  const [verificationCode, setVerificationCode] = useState('');
  const [isVerifying, setIsVerifying] = useState(false);
  const [error, setError] = useState('');
  const [success, setSuccess] = useState('');

  const handleSignup = async () => {
    setError('');
    setSuccess('');
    if (password !== confirmPassword) {
      setError('Passwords do not match');
      return;
    }
    try {
      await axios.post('http://localhost:5000/api/auth/signup', {
        email,
        password,
      });
      setSuccess('Verification email sent. Please check your inbox.');
      setIsVerifying(true);
    } catch (error) {
      setError(error.response?.data?.message || 'Signup failed');
    }
  };

  const handleLogin = async () => {
    setError('');
    setSuccess('');
    try {
      const response = await axios.post('http://localhost:5000/api/auth/login', {
        email,
        password,
      });
      setSuccess('Logged in successfully');
      // Store token and navigate to dashboard
    } catch (error) {
      setError(error.response?.data?.message || 'Login failed');
    }
  };

  const handleVerifyEmail = async () => {
    setError('');
    setSuccess('');
    try {
      await axios.post('http://localhost:5000/api/auth/verify-email', {
        email,
        code: verificationCode,
      });
      setSuccess('Email verified! You can now log in.');
      setIsLogin(true);
      setIsVerifying(false);
    } catch (error) {
      setError(error.response?.data?.message || 'Verification failed');
    }
  };

  return (
    <div className="auth-container">
      <div className="auth-card">
        <h1 className="auth-title">EduBridge</h1>
        
        {error && <div className="alert alert-error">{error}</div>}
        {success && <div className="alert alert-success">{success}</div>}

        {!isVerifying ? (
          <>
            <input
              type="email"
              className="auth-input"
              placeholder="Email"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
            />
            <input
              type="password"
              className="auth-input"
              placeholder="Password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
            />
            
            {!isLogin && (
              <input
                type="password"
                className="auth-input"
                placeholder="Confirm Password"
                value={confirmPassword}
                onChange={(e) => setConfirmPassword(e.target.value)}
              />
            )}
            
            <button
              className="auth-button"
              onClick={isLogin ? handleLogin : handleSignup}
            >
              {isLogin ? 'Login' : 'Sign Up'}
            </button>
            
            <button
              className="auth-toggle"
              onClick={() => setIsLogin(!isLogin)}
            >
              {isLogin ? 'Don\'t have an account? Sign Up' : 'Already have an account? Login'}
            </button>
          </>
        ) : (
          <>
            <p className="verification-text">
              Enter the verification code sent to {email}
            </p>
            <input
              type="text"
              className="auth-input"
              placeholder="Verification Code"
              value={verificationCode}
              onChange={(e) => setVerificationCode(e.target.value)}
            />
            <button className="auth-button" onClick={handleVerifyEmail}>
              Verify Email
            </button>
          </>
        )}
      </div>
    </div>
  );
};

export default AuthScreen;