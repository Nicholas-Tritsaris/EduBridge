// Linux/src/ApiService.js
import axios from 'axios';

const API_BASE_URL = 'http://input ip here:5000';

const api = axios.create({
  baseURL: API_BASE_URL,
  headers: {
    'Content-Type': 'application/json',
  },
});

export const authApi = {
  signup: (email, password) =>
    api.post('/api/auth/signup', { email, password }),
  login: (email, password) =>
    api.post('/api/auth/login', { email, password }),
  verifyEmail: (email, code) =>
    api.post('/api/auth/verify-email', { email, code }),
  resendVerification: (email) =>
    api.post('/api/auth/resend-verification', { email }),
};

export const classroomApi = {
  getAll: () => api.get('/api/classrooms'),
  getOne: (id) => api.get(`/api/classrooms/${id}`),
  create: (data) => api.post('/api/classrooms', data),
  update: (id, data) => api.put(`/api/classrooms/${id}`, data),
  delete: (id) => api.delete(`/api/classrooms/${id}`),
};

export const assignmentApi = {
  getAll: () => api.get('/api/assignments'),
  getOne: (id) => api.get(`/api/assignments/${id}`),
  create: (data) => api.post('/api/assignments', data),
  update: (id, data) => api.put(`/api/assignments/${id}`, data),
  delete: (id) => api.delete(`/api/assignments/${id}`),
};

export const messageApi = {
  getAll: () => api.get('/api/messages'),
  getOne: (id) => api.get(`/api/messages/${id}`),
  create: (data) => api.post('/api/messages', data),
  delete: (id) => api.delete(`/api/messages/${id}`),
};

export default api;
