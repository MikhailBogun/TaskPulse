import apiClient from './client'

export const subscriptionsApi = {
  createCheckout: async (plan: 'pro' | 'enterprise') => {
    const res = await apiClient.post<{ checkout_url: string }>('/subscriptions/checkout', { plan })
    return res.data
  },

  createPortal: async () => {
    const res = await apiClient.post<{ portal_url: string }>('/subscriptions/portal')
    return res.data
  },
}
