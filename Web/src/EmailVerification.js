import React, { useState } from 'react';
import './EmailVerification.css';

const EmailVerification = ({ email, onVerificationSuccess, onBackToSignup }) => {
  const [verificationCode, setVerificationCode] = useState('');
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState('');
  const [success, setSuccess] = useState('');

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError('');
    setSuccess('');
    setIsLoading(true);

    // Validation
    if (!verificationCode) {
      setError('Please enter the verification code');
      setIsLoading(false);
      return;
    }

    if (verificationCode.length < 6) {
      setError('Verification code should be 6 characters');
      setIsLoading(false);
      return;
    }

    try {
      const response = await fetch('http://localhost:5000/api/auth/verify-email', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          email: email,
          code: verificationCode,
        }),
      });

      const data = await response.json();

      if (response.ok && data.success) {
        setSuccess('Email verified successfully! Redirecting...');
        setVerificationCode('');
        setTimeout(() => {
          localStorage.setItem('user', JSON.stringify(data.user));
          localStorage.setItem('authToken', data.token || email);
          onVerificationSuccess(data.user);
        }, 1500);
      } else {
        setError(data.message || 'Verification failed. Please check the code and try again.');
      }
    } catch (err) {
      setError('Network error. Please check your connection and try again.');
      console.error('Verification error:', err);
    } finally {
      setIsLoading(false);
    }
  };

  const handleResendCode = async () => {
    setError('');
    setSuccess('');
    setIsLoading(true);

    try {
      const response = await fetch('http://localhost:5000/api/auth/resend-verification', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ email: email }),
      });

      const data = await response.json();

      if (response.ok) {
        setSuccess('Verification code sent to your email');
      } else {
        setError(data.message || 'Failed to resend code. Please try again.');
      }
    } catch (err) {
      setError('Network error. Please check your connection and try again.');
      console.error('Resend error:', err);
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <div className="verification-container">
      <div className="verification-card">
        <h2>Verify Your Email</h2>
        <p className="subtitle">
          We sent a verification code to <strong>{email}</strong>
        </p>

        {error && <div className="alert alert-error">{error}</div>}
        {success && <div className="alert alert-success">{success}</div>}

        <form onSubmit={handleSubmit}>
          <div className="form-group">
            <label htmlFor="code">Verification Code</label>
            <input
              type="text"
              id="code"
              placeholder="Enter 6-character code"
              value={verificationCode}
              onChange={(e) => setVerificationCode(e.target.value.toUpperCase())}
              disabled={isLoading}
              maxLength="6"
            />
            <small>Check your email for the verification code</small>
          </div>

          <button
            type="submit"
            className="btn-submit"
            disabled={isLoading}
          >
            {isLoading ? 'Verifying...' : 'Verify Email'}
          </button>
        </form>

        <div className="verification-footer">
          <p>
            Didn't receive the code?{' '}
            <button
              type="button"
              className="link-button"
              onClick={handleResendCode}
              disabled={isLoading}
            >
              Resend Code
            </button>
          </p>
          <p>
            <button
              type="button"
              className="link-button"
              onClick={onBackToSignup}
              disabled={isLoading}
            >
              Back to Sign Up
            </button>
          </p>
        </div>
      </div>
    </div>
  );
};

export default EmailVerification;
