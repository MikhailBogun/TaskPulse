import { useState } from 'react'
import { Check, ExternalLink } from 'lucide-react'
import { subscriptionsApi } from '@/api/subscriptions'
import { useAuthStore } from '@/store/authStore'
import { Button } from '@/components/ui/button'
import { Card, CardContent, CardDescription, CardFooter, CardHeader, CardTitle } from '@/components/ui/card'
import { Badge } from '@/components/ui/badge'
import { cn } from '@/lib/utils'

const plans = [
  {
    id: 'free' as const,
    name: 'Free',
    price: '$0',
    period: 'forever',
    features: ['10 tasks', '3 categories', 'Basic monitoring', 'Email notifications'],
    highlight: false,
  },
  {
    id: 'pro' as const,
    name: 'Pro',
    price: '$19',
    period: '/month',
    features: ['100 tasks', '20 categories', 'GitHub integration', 'Crypto alerts', 'Telegram & Slack', 'Priority support'],
    highlight: true,
  },
  {
    id: 'enterprise' as const,
    name: 'Enterprise',
    price: '$99',
    period: '/month',
    features: ['Unlimited tasks', 'Unlimited categories', 'All Pro features', 'Metered billing', 'SLA guarantee', 'Dedicated support'],
    highlight: false,
  },
]

export default function Billing() {
  const user = useAuthStore((s) => s.user)
  const [loading, setLoading] = useState<string | null>(null)

  const handleUpgrade = async (plan: 'pro' | 'enterprise') => {
    setLoading(plan)
    try {
      const { checkout_url } = await subscriptionsApi.createCheckout(plan)
      window.location.href = checkout_url
    } finally {
      setLoading(null)
    }
  }

  const handlePortal = async () => {
    setLoading('portal')
    try {
      const { portal_url } = await subscriptionsApi.createPortal()
      window.open(portal_url, '_blank')
    } finally {
      setLoading(null)
    }
  }

  const currentPlan = user?.plan ?? 'free'

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-semibold">Billing</h1>
          <p className="text-sm text-muted-foreground mt-1">
            Current plan:{' '}
            <span className="font-medium capitalize text-foreground">{currentPlan}</span>
            {user?.trial_ends_at && currentPlan === 'trial' && (
              <> &mdash; trial ends {new Date(user.trial_ends_at).toLocaleDateString()}</>
            )}
          </p>
        </div>
        {(currentPlan === 'pro' || currentPlan === 'enterprise') && (
          <Button variant="outline" onClick={handlePortal} loading={loading === 'portal'}>
            <ExternalLink className="mr-2 h-4 w-4" />
            Manage subscription
          </Button>
        )}
      </div>

      <div className="grid grid-cols-3 gap-6">
        {plans.map((plan) => {
          const isCurrent = currentPlan === plan.id || (currentPlan === 'trial' && plan.id === 'pro')
          return (
            <Card
              key={plan.id}
              className={cn(
                'relative flex flex-col',
                plan.highlight && 'border-primary shadow-md',
              )}
            >
              {plan.highlight && (
                <div className="absolute -top-3 left-1/2 -translate-x-1/2">
                  <Badge className="px-3 py-0.5">Most popular</Badge>
                </div>
              )}
              <CardHeader>
                <CardTitle>{plan.name}</CardTitle>
                <CardDescription>
                  <span className="text-3xl font-bold text-foreground">{plan.price}</span>
                  <span className="text-muted-foreground">{plan.period}</span>
                </CardDescription>
              </CardHeader>
              <CardContent className="flex-1">
                <ul className="space-y-2">
                  {plan.features.map((f) => (
                    <li key={f} className="flex items-center gap-2 text-sm">
                      <Check className="h-4 w-4 text-green-500 flex-shrink-0" />
                      {f}
                    </li>
                  ))}
                </ul>
              </CardContent>
              <CardFooter>
                {isCurrent ? (
                  <Button className="w-full" variant="outline" disabled>
                    Current plan
                  </Button>
                ) : plan.id === 'free' ? (
                  <Button className="w-full" variant="outline" disabled>
                    Downgrade
                  </Button>
                ) : (
                  <Button
                    className="w-full"
                    variant={plan.highlight ? 'default' : 'outline'}
                    loading={loading === plan.id}
                    onClick={() => handleUpgrade(plan.id)}
                  >
                    Upgrade to {plan.name}
                  </Button>
                )}
              </CardFooter>
            </Card>
          )
        })}
      </div>
    </div>
  )
}
