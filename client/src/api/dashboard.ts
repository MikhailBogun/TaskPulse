import apiClient from './client'
import type { DashboardEntry } from '@/types'

export const dashboardApi = {
  get: async () => {
    const res = await apiClient.get<DashboardEntry[]>('/dashboard')
    return res.data
  },
}
