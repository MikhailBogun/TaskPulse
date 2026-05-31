import apiClient from './client'
import type { User } from '@/types'

export const authApi = {
  login: async (email: string, password: string) => {
    const res = await apiClient.post<{ user: User; token: string }>(
      '/auth/login',
      { user: { email, password } },
    )
    return res.data
  },

  register: async (email: string, password: string, password_confirmation: string) => {
    const res = await apiClient.post<{ user: User; message: string }>(
      '/auth/register',
      { user: { email, password, password_confirmation } },
    )
    return res.data
  },

  logout: async () => {
    await apiClient.delete('/auth/logout')
  },

  me: async () => {
    const res = await apiClient.get<User>('/auth/me')
    return res.data
  },
}
