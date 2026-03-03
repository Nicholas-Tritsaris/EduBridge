// Linux/src/screens/DashboardScreen.js
import React from 'react';
import '../styles/DashboardScreen.css';

function DashboardScreen({ user, onLogout }) {
  const features = [
    { icon: '📚', title: 'Classrooms', description: 'Create and manage classrooms' },
    { icon: '📝', title: 'Assignments', description: 'Create and track assignments' },
    { icon: '💬', title: 'Messaging', description: 'Communicate with students' },
    { icon: '📊', title: 'Analytics', description: 'Track student progress' },
  ];

  const gettingStartedSteps = [
    'Create your first classroom',
    'Add students to the classroom',
    'Create assignments for students',
    'Monitor student progress through analytics',
  ];

  return (
    <div className="dashboard-screen">
      <header className="dashboard-header">
        <div className="header-content">
          <h1>Welcome! 👋</h1>
          <p>{user?.email}</p>
        </div>
        <button className="logout-button" onClick={onLogout}>
          Logout
        </button>
      </header>

      <div className="dashboard-content">
        <section className="features-section">
          <h2>Available Features</h2>
          <div className="features-grid">
            {features.map((feature, index) => (
              <div key={index} className="feature-card">
                <div className="feature-icon">{feature.icon}</div>
                <div className="feature-content">
                  <h3>{feature.title}</h3>
                  <p>{feature.description}</p>
                </div>
              </div>
            ))}
          </div>
        </section>

        <section className="stats-section">
          <h2>Quick Stats</h2>
          <div className="stats-grid">
            <div className="stat-card">
              <div className="stat-number">5</div>
              <div className="stat-label">Classrooms</div>
            </div>
            <div className="stat-card">
              <div className="stat-number">12</div>
              <div className="stat-label">Assignments</div>
            </div>
            <div className="stat-card">
              <div className="stat-number">48</div>
              <div className="stat-label">Messages</div>
            </div>
          </div>
        </section>

        <section className="getting-started-section">
          <h2>Getting Started</h2>
          <ol className="steps-list">
            {gettingStartedSteps.map((step, index) => (
              <li key={index}>{step}</li>
            ))}
          </ol>
        </section>

        <section className="account-info-section">
          <h2>Account Information</h2>
          <div className="info-card">
            <div className="info-row">
              <span className="info-label">Email:</span>
              <span className="info-value">{user?.email}</span>
            </div>
            <div className="info-row">
              <span className="info-label">Verification Status:</span>
              <span className="info-value verification-badge">
                {user?.verified ? '✓ Verified' : 'Pending'}
              </span>
            </div>
          </div>
        </section>
      </div>
    </div>
  );
}

export default DashboardScreen;
