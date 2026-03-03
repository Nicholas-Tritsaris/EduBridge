import React from 'react';
import './Dashboard.css';

const Dashboard = ({ user, onLogout }) => {
  return (
    <div className="dashboard-wrapper">
      <nav className="dashboard-nav">
        <div className="nav-container">
          <div className="nav-brand">
            <h1>EduBridge</h1>
          </div>
          <button className="logout-btn" onClick={onLogout}>
            Logout
          </button>
        </div>
      </nav>

      <div className="dashboard-main">
        <div className="dashboard-container">
          <div className="welcome-section">
            <h2>Welcome to EduBridge! 👋</h2>
            <p>Your account has been successfully created and verified.</p>
          </div>

          <div className="user-profile-section">
            <h3>Your Profile</h3>
            <div className="profile-card">
              <div className="profile-info">
                <label>Email Address:</label>
                <p>{user?.email || 'Not available'}</p>
              </div>
            </div>
          </div>

          <div className="features-section">
            <h3>Available Features</h3>
            <div className="features-grid">
              <div className="feature-item">
                <span className="feature-icon">📚</span>
                <h4>Classrooms</h4>
                <p>Create and manage your classrooms</p>
              </div>
              <div className="feature-item">
                <span className="feature-icon">📝</span>
                <h4>Assignments</h4>
                <p>Create and assign homework tasks</p>
              </div>
              <div className="feature-item">
                <span className="feature-icon">💬</span>
                <h4>Messaging</h4>
                <p>Communicate with students and teachers</p>
              </div>
              <div className="feature-item">
                <span className="feature-icon">📊</span>
                <h4>Analytics</h4>
                <p>Track progress and performance</p>
              </div>
            </div>
          </div>

          <div className="getting-started-section">
            <h3>Getting Started</h3>
            <div className="steps">
              <div className="step">
                <div className="step-number">1</div>
                <h4>Complete Your Profile</h4>
                <p>Add more information to your profile</p>
              </div>
              <div className="step">
                <div className="step-number">2</div>
                <h4>Create a Classroom</h4>
                <p>Set up your first classroom</p>
              </div>
              <div className="step">
                <div className="step-number">3</div>
                <h4>Invite Students</h4>
                <p>Invite students to join your classroom</p>
              </div>
              <div className="step">
                <div className="step-number">4</div>
                <h4>Create Content</h4>
                <p>Start creating assignments and resources</p>
              </div>
            </div>
          </div>

          <div className="info-section">
            <h3>Account Information</h3>
            <div className="info-grid">
              <div className="info-item">
                <label>Account Status:</label>
                <p className="status-badge verified">✓ Verified</p>
              </div>
              <div className="info-item">
                <label>Member Since:</label>
                <p>{new Date().toLocaleDateString()}</p>
              </div>
            </div>
          </div>
        </div>
      </div>

      <footer className="dashboard-footer">
        <p>&copy; 2026 EduBridge. All rights reserved.</p>
      </footer>
    </div>
  );
};

export default Dashboard;
