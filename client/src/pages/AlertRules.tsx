import { useEffect, useState } from 'react'
import { Plus } from 'lucide-react'
import apiClient from '@/api/client'
import { Button } from '@/components/ui/button'
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'
import { Badge } from '@/components/ui/badge'
import type { AlertRule } from '@/types'

export default function AlertRules() {
  const [rules, setRules] = useState<AlertRule[]>([])
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    apiClient.get<{ alert_rules: AlertRule[] }>('/alert_rules')
      .then((r) => setRules(r.data.alert_rules))
      .finally(() => setLoading(false))
  }, [])

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <h1 className="text-2xl font-semibold">Alert Rules</h1>
        <Button size="sm">
          <Plus className="mr-2 h-4 w-4" />
          New Rule
        </Button>
      </div>

      {loading ? (
        <div className="text-muted-foreground text-sm">Loading rules...</div>
      ) : rules.length === 0 ? (
        <Card>
          <CardContent className="flex flex-col items-center py-16 gap-3">
            <p className="text-muted-foreground">No alert rules yet. Set up an alert to get notified automatically.</p>
            <Button size="sm"><Plus className="mr-2 h-4 w-4" />New Rule</Button>
          </CardContent>
        </Card>
      ) : (
        <div className="space-y-3">
          {rules.map((rule) => (
            <Card key={rule.id}>
              <CardHeader className="py-3">
                <div className="flex items-center justify-between">
                  <div className="flex items-center gap-3">
                    <CardTitle className="text-base">{rule.name}</CardTitle>
                    <Badge variant="secondary" className="capitalize">{rule.rule_type}</Badge>
                    <Badge variant={rule.active ? 'success' : 'secondary'}>
                      {rule.active ? 'Active' : 'Inactive'}
                    </Badge>
                  </div>
                  <p className="text-sm text-muted-foreground capitalize">
                    {rule.condition} {rule.threshold} &rarr; {rule.notification_channel}
                  </p>
                </div>
              </CardHeader>
            </Card>
          ))}
        </div>
      )}
    </div>
  )
}
