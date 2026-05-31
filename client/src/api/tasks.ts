import apiClient from './client'
import type { Task } from '@/types'

export const tasksApi = {
  list: async (page = 1) => {
    const res = await apiClient.get<{ tasks: Task[] }>('/tasks', { params: { page } })
    return res.data.tasks
  },

  get: async (id: number) => {
    const res = await apiClient.get<Task>(`/tasks/${id}`)
    return res.data
  },

  create: async (data: Partial<Task> & { name: string }) => {
    const res = await apiClient.post<Task>('/tasks', { task: data })
    return res.data
  },

  update: async (id: number, data: Partial<Task>) => {
    const res = await apiClient.patch<Task>(`/tasks/${id}`, { task: data })
    return res.data
  },

  destroy: async (id: number) => {
    await apiClient.delete(`/tasks/${id}`)
  },
}
