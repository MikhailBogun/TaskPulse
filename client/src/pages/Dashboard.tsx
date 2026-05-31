import { useEffect, useState } from 'react'
import {
  BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, Legend, ResponsiveContainer,
} from 'recharts'
import { dashboardApi } from '@/api/dashboard'
import { useAuthStore } from '@/store/authStore'
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'
import { Badge } from '@/components/ui/badge'
import type { DashboardEntry } from '@/types'

export default function Dashboard() {
  const user = useAuthStore((s) => s.user)
  const [data, setData] = useState<DashboardEntry[]>([])
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    dashboardApi.get().then(setData).finally(() => setLoading(false))
  }, [])

  const totalSuccess = data.reduce((sum, d) => sum + d.success_count, 0)
  const totalFailed = data.reduce((sum, d) => sum + d.failed_count, 0)
  const avgDuration = data.length
    ? (data.reduce((sum, d) => sum + d.avg_duration_seconds, 0) / data.length).toFixed(2)
    : '0'

  const chartData = [...new Map(data.map((d) => [d.day, d])).values()]
    .slice(0, 14)
    .reverse()
    .map((d) => ({ date: d.day, success: d.success_count, failed: d.failed_count }))

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <h1 className="text-2xl font-semibold">Dashboard</h1>
        {user && (
          <Badge variant={user.plan === 'enterprise' ? 'default' : user.plan === 'pro' ? 'success' : 'warning'} className="capitalize">
            {user.plan} plan
          </Badge>
        )}
      </div>

      {/* Stats row */}
      <div className="grid grid-cols-3 gap-4">
        <Card>
          <CardHeader className="pb-2">
            <CardTitle className="text-sm font-medium text-muted-foreground">Successful Tasks</CardTitle>
          </CardHeader>
          <CardContent>
            <p className="text-3xl font-bold text-green-600">{totalSuccess}</p>
            <p className="text-xs text-muted-foreground">last 30 days</p>
          </CardContent>
        </Card>
        <Card>
          <CardHeader className="pb-2">
            <CardTitle className="text-sm font-medium text-muted-foreground">Failed Tasks</CardTitle>
          </CardHeader>
          <CardContent>
            <p className="text-3xl font-bold text-destructive">{totalFailed}</p>
            <p className="text-xs text-muted-foreground">last 30 days</p>
          </CardContent>
        </Card>
        <Card>
          <CardHeader className="pb-2">
            <CardTitle className="text-sm font-medium text-muted-foreground">Avg Duration</CardTitle>
          </CardHeader>
          <CardContent>
            <p className="text-3xl font-bold">{avgDuration}s</p>
            <p className="text-xs text-muted-foreground">per task execution</p>
          </CardContent>
        </Card>
      </div>

      {/* Chart */}
      <Card>
        <CardHeader>
          <CardTitle>Task Executions (last 14 days)</CardTitle>
        </CardHeader>
        <CardContent>
          {loading ? (
            <div className="flex h-64 items-center justify-center text-muted-foreground">Loading chart...</div>
          ) : (
            <ResponsiveContainer width="100%" height={280}>
              <BarChart data={chartData} margin={{ top: 5, right: 20, bottom: 5, left: 0 }}>
                <CartesianGrid strokeDasharray="3 3" className="stroke-muted" />
                <XAxis dataKey="date" tick={{ fontSize: 12 }} />
                <YAxis tick={{ fontSize: 12 }} />
                <Tooltip />
                <Legend />
                <Bar dataKey="success" name="Success" fill="#22c55e" radius={[4, 4, 0, 0]} />
                <Bar dataKey="failed" name="Failed" fill="#ef4444" radius={[4, 4, 0, 0]} />
              </BarChart>
            </ResponsiveContainer>
          )}
        </CardContent>
      </Card>
    </div>
  )
}
