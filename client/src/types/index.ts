export type Plan = 'free' | 'trial' | 'pro' | 'enterprise'

export interface PlanLimits {
  tasks: number
  categories: number
}

export interface User {
  id: number
  email: string
  plan: Plan
  confirmed_at: string | null
  trial_ends_at: string | null
  grace_period_ends_at: string | null
  active_subscription: boolean
  plan_limits: PlanLimits
  created_at: string
}

export interface Category {
  id: number
  name: string
  color: string
  created_at: string
}

export type TaskStatus = 'pending' | 'running' | 'success' | 'failed'

export interface Task {
  id: number
  name: string
  description: string | null
  status: TaskStatus
  scheduled_at: string | null
  last_run_at: string | null
  category: Category | null
  created_at: string
  updated_at: string
}

export interface AlertRule {
  id: number
  name: string
  rule_type: 'crypto' | 'github'
  condition: 'below' | 'above'
  threshold: string
  notification_channel: 'telegram' | 'slack'
  active: boolean
  last_triggered_at: string | null
  created_at: string
}

export interface DashboardEntry {
  day: string
  category: string
  success_count: number
  failed_count: number
  avg_duration_seconds: number
  daily_running_total: number
}

export interface ApiError {
  error?: string
  errors?: string[]
}
