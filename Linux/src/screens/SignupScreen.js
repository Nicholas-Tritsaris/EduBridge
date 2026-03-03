// Linux/src/screens/SignupScreen.js
import React, { useState } from 'react';
import { authApi } from '../ApiService';
import '../styles/AuthScreen.css';

function SignupScreen({ onSignupSuccess, onNavigateToLogin }) {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');
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

    if (!confirmPassword) {
      newErrors.confirmPassword = 'Please confirm password';
    } else if (password !== confirmPassword) {
      newErrors.confirmPassword = 'Passwords do not match';
    }

    if (Object.keys(newErrors).length > 0) {
      setErrors(newErrors);
      return;
    }

    setLoading(true);
    setStatus('');

    try {
      const response = await authApi.signup(email, password);
      if (response.data.success) {
        setErrors({});
        setStatus('success');
        onSignupSuccess(email);
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
      <h1 className="screen-title">Create Account</h1>
      <p className="screen-subtitle">Join the learning revolution</p>

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
          <label className="form-label">Password (min 6 characters)</label>
          <input
            type="password"
            className="form-input"
            placeholder="••••••••"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
          />
          {errors.password && <div className="error-message">{errors.password}</div>}
        </div>

        <div className="form-group">
          <label className="form-label">Confirm Password</label>
          <input
            type="password"
            className="form-input"
            placeholder="••••••••"
            value={confirmPassword}
            onChange={(e) => setConfirmPassword(e.target.value)}
          />
          {errors.confirmPassword && (
            <div className="error-message">{errors.confirmPassword}</div>
          )}
        </div>

        <button
          type="submit"
          className="button button-primary"
          disabled={loading}
        >
          {loading ? 'Creating Account...' : 'Create Account'}
        </button>
      </form>

      <button className="button button-secondary" onClick={onNavigateToLogin}>
        Already have an account? Sign In
      </button>

      {errors.submit && (
        <div className="status-message status-error">{errors.submit}</div>
      )}

      {status === 'success' && (
        <div className="status-message status-success">
          Account created! Check your email for verification.
        </div>
      )}
    </div>
  );
}

export default SignupScreen;
