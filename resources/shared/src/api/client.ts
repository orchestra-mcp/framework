import axios from 'axios';

/**
 * Shared Axios instance for the Orchestra API.
 * All platform apps import this and can override baseURL as needed.
 */
export const apiClient = axios.create({
  baseURL: '/api',
  headers: {
    'Content-Type': 'application/json',
  },
  timeout: 10_000,
});
