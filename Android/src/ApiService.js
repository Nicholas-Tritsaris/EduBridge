// Android/src/ApiService.js
import axios from 'axios';

const API_BASE_URL = 'http://input ip here:5000'; // Change to your server IP

export const apiClient = axios.create({
  baseURL: API_BASE_URL,
  timeout: 10000,
  headers: {
    'Content-Type': 'application/json',
  },
});

export const authApi = {
  signup: (email, password) => {
    return apiClient.post('/api/auth/signup', {
      email,
      password,
    });
  },

  login: (email, password) => {
    return apiClient.post('/api/auth/login', {
      email,
      password,
    });
  },

  verifyEmail: (email, code) => {
    return apiClient.post('/api/auth/verify-email', {
      email,
      code,
    });
  },

  resendVerification: (email) => {
    return apiClient.post('/api/auth/resend-verification', {
      email,
    });
  },
};

export const classroomApi = {
  getClassrooms: () => {
    return apiClient.get('/api/classrooms');
  },

  createClassroom: (name, description) => {
    return apiClient.post('/api/classrooms', {
      name,
      description,
    });
  },
};

export const assignmentApi = {
  getAssignments: () => {
    return apiClient.get('/api/assignments');
  },

  createAssignment: (title, description, dueDate) => {
    return apiClient.post('/api/assignments', {
      title,
      description,
      dueDate,
    });
  },
};

export const messageApi = {
  getMessages: () => {
    return apiClient.get('/api/messages');
  },

  sendMessage: (recipientId, message) => {
    return apiClient.post('/api/messages', {
      recipientId,
      message,
    });
  },
};
