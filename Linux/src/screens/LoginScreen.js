// Linux/src/screens/LoginScreen.js
import React, { useState } from 'react';
import { authApi } from '../ApiService';
import '../styles/AuthScreen.css';

function LoginScreen({ onLoginSuccess, onNavigateToSignup }) {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [errors, setErrors] = useState({});
  const [status, setStatus] = useState('');
  const [loading, setLoading] = useState(false);

  const validateEmail = (email) => {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return emailRegex.test(email);
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    const newErrors = {};

    if (!email) {
      newErrors.email = 'Email is required';
    } else if (!validateEmail(email)) {
      newErrors.email = 'Invalid email address';
    }

    if (!password) {
      newErrors.password = 'Password is required';
    } else if (password.length < 6) {
      newErrors.password = 'Password must be at least 6 characters';
    }

    if (Object.keys(newErrors).length > 0) {
      setErrors(newErrors);
      return;
    }

    setLoading(true);
    setStatus('');

    try {
      const response = await authApi.login(email, password);
      if (response.data.success) {
        setErrors({});
        setStatus('success');
        onLoginSuccess(response.data.user, response.data.token);
      } else {
        setStatus('error');
        setErrors({ submit: response.data.message });
      }
    } catch (error) {
      setStatus('error');
      setErrors({ submit: error.response?.data?.message || 'Network error' });
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="screen auth-screen">
      <h1 className="screen-title">Welcome Back</h1>
      <p className="screen-subtitle">Sign in to EduBridge</p>

      <form onSubmit={handleSubmit}>
        <div className="form-group">
          <label className="form-label">Email Address</label>
          <input
            type="email"
            className="form-input"
            placeholder="your@email.com"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
          />
          {errors.email && <div className="error-message">{errors.email}</div>}
        </div>

        <div className="form-group">
          <label className="form-label">Password</label>
          <input
            type="password"
            className="form-input"
            placeholder="••••••••"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
          />
          {errors.password && <div className="error-message">{errors.password}</div>}
        </div>

        <button
          type="submit"
          className="button button-primary"
          disabled={loading}
        >
          {loading ? 'Signing in...' : 'Sign In'}
        </button>
      </form>

      <button className="button button-secondary" onClick={onNavigateToSignup}>
        Create New Account
      </button>

      {errors.submit && (
        <div className="status-message status-error">{errors.submit}</div>
      )}

      {status === 'success' && (
        <div className="status-message status-success">
          Login successful! Redirecting...
        </div>
      )}
    </div>
  );
}

export default LoginScreen;
