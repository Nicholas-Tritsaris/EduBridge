// Linux/src/screens/EmailVerificationScreen.js
import React, { useState } from 'react';
import { authApi } from '../ApiService';
import '../styles/AuthScreen.css';

function EmailVerificationScreen({
  email,
  onVerificationSuccess,
  onNavigateToSignup,
}) {
  const [code, setCode] = useState('');
  const [errors, setErrors] = useState({});
  const [status, setStatus] = useState('');
  const [loading, setLoading] = useState(false);
  const [resendLoading, setResendLoading] = useState(false);

  const handleVerify = async (e) => {
    e.preventDefault();
    const newErrors = {};

    if (!code) {
      newErrors.code = 'Verification code is required';
    } else if (code.length !== 6) {
      newErrors.code = 'Code must be 6 characters';
    }

    if (Object.keys(newErrors).length > 0) {
      setErrors(newErrors);
      return;
    }

    setLoading(true);

    try {
      const response = await authApi.verifyEmail(email, code.toUpperCase());
      if (response.data.success) {
        setErrors({});
        onVerificationSuccess(response.data.user, response.data.token);
      } else {
        setStatus('error');
        setErrors({ code: response.data.message });
      }
    } catch (error) {
      setStatus('error');
      setErrors({ code: error.response?.data?.message || 'Network error' });
    } finally {
      setLoading(false);
    }
  };

  const handleResend = async () => {
    setResendLoading(true);

    try {
      const response = await authApi.resendVerification(email);
      if (response.data.success) {
        setStatus('info');
        setErrors({ info: 'Verification code sent to ' + email });
      } else {
        setStatus('error');
        setErrors({ submit: response.data.message });
      }
    } catch (error) {
      setStatus('error');
      setErrors({ submit: error.response?.data?.message || 'Network error' });
    } finally {
      setResendLoading(false);
    }
  };

  return (
    <div className="screen auth-screen">
      <h1 className="screen-title">Verify Email</h1>
      <p className="screen-subtitle">
        We sent a verification code to<br />
        {email}
      </p>

      <form onSubmit={handleVerify}>
        <div className="form-group">
          <label className="form-label">Verification Code</label>
          <input
            type="text"
            className="form-input"
            placeholder="Enter 6-character code"
            value={code}
            onChange={(e) => setCode(e.target.value.toUpperCase())}
            maxLength="6"
            style={{ textAlign: 'center', fontSize: '20px', letterSpacing: '2px' }}
          />
          {errors.code && <div className="error-message">{errors.code}</div>}
          <div className="help-text">Check your email for the code</div>
        </div>

        <button
          type="submit"
          className="button button-primary"
          disabled={loading}
        >
          {loading ? 'Verifying...' : 'Verify Email'}
        </button>
      </form>

      <button
        className="button button-secondary"
        onClick={handleResend}
        disabled={resendLoading}
      >
        {resendLoading ? 'Sending...' : 'Resend Code'}
      </button>

      <button
        className="button button-secondary"
        onClick={onNavigateToSignup}
      >
        Back to Sign Up
      </button>

      {errors.submit && (
        <div className="status-message status-error">{errors.submit}</div>
      )}

      {errors.info && (
        <div className="status-message status-info">{errors.info}</div>
      )}
    </div>
  );
}

export default EmailVerificationScreen;
