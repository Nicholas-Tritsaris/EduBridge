import React, { useState, useEffect } from 'react';
import Login from './Login';
import Signup from './Signup';
import EmailVerification from './EmailVerification';
import Dashboard from './Dashboard';
import './App.css';

const App = () => {
  const [screen, setScreen] = useState('login');
  const [user, setUser] = useState(null);
  const [email, setEmail] = useState('');

  // Check if user is logged in on app load
  useEffect(() => {
    const storedUser = localStorage.getItem('user');
    if (storedUser) {
      try {
        setUser(JSON.parse(storedUser));
        setScreen('dashboard');
      } catch (err) {
        console.error('Error parsing stored user:', err);
      }
    }
  }, []);

  const handleSwitchToLogin = () => {
    setScreen('login');
    setEmail('');
  };

  const handleSwitchToSignup = () => {
    setScreen('signup');
    setEmail('');
  };

  const handleSignupSuccess = (signupEmail) => {
    setEmail(signupEmail);
    setScreen('verification');
  };

  const handleVerificationSuccess = (userData) => {
    setUser(userData);
    setScreen('dashboard');
  };

  const handleLoginSuccess = (userData) => {
    setUser(userData);
    setScreen('dashboard');
  };

  const handleLogout = () => {
    localStorage.removeItem('user');
    localStorage.removeItem('authToken');
    setUser(null);
    setEmail('');
    setScreen('login');
  };

  return (
    <div className="app-container">
      {screen === 'login' && (
        <Login onSwitchToSignup={handleSwitchToSignup} onLoginSuccess={handleLoginSuccess} />
      )}
      {screen === 'signup' && (
        <Signup onSwitchToLogin={handleSwitchToLogin} onSignupSuccess={handleSignupSuccess} />
      )}
      {screen === 'verification' && (
        <EmailVerification
          email={email}
          onVerificationSuccess={handleVerificationSuccess}
          onBackToSignup={handleSwitchToSignup}
        />
      )}
      {screen === 'dashboard' && user && (
        <Dashboard user={user} onLogout={handleLogout} />
      )}
    </div>
  );
};

export default App;