import { useEffect, useState } from 'react'
import { Plus, Trash2, Play } from 'lucide-react'
import { tasksApi } from '@/api/tasks'
import { Button } from '@/components/ui/button'
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'
import { Badge } from '@/components/ui/badge'
import type { Task, TaskStatus } from '@/types'

const statusVariant: Record<TaskStatus, 'secondary' | 'warning' | 'success' | 'destructive'> = {
  pending: 'secondary',
  running: 'warning',
  success: 'success',
  failed: 'destructive',
}

export default function Tasks() {
  const [tasks, setTasks] = useState<Task[]>([])
  const [loading, setLoading] = useState(true)

  const loadTasks = () => {
    setLoading(true)
    tasksApi.list().then(setTasks).finally(() => setLoading(false))
  }

  useEffect(() => { loadTasks() }, [])

  const handleDelete = async (id: number) => {
    await tasksApi.destroy(id)
    setTasks((prev) => prev.filter((t) => t.id !== id))
  }

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <h1 className="text-2xl font-semibold">Tasks</h1>
        <Button size="sm">
          <Plus className="mr-2 h-4 w-4" />
          New Task
        </Button>
      </div>

      {loading ? (
        <div className="text-muted-foreground text-sm">Loading tasks...</div>
      ) : tasks.length === 0 ? (
        <Card>
          <CardContent className="flex flex-col items-center py-16 gap-3">
            <p className="text-muted-foreground">No tasks yet. Create your first task to get started.</p>
            <Button size="sm"><Plus className="mr-2 h-4 w-4" />New Task</Button>
          </CardContent>
        </Card>
      ) : (
        <div className="space-y-3">
          {tasks.map((task) => (
            <Card key={task.id}>
              <CardHeader className="py-3">
                <div className="flex items-center justify-between">
                  <div className="flex items-center gap-3">
                    <CardTitle className="text-base">{task.name}</CardTitle>
                    {task.category && (
                      <span
                        className="rounded-full px-2 py-0.5 text-xs font-medium text-white"
                        style={{ backgroundColor: task.category.color }}
                      >
                        {task.category.name}
                      </span>
                    )}
                    <Badge variant={statusVariant[task.status]} className="capitalize">
                      {task.status}
                    </Badge>
                  </div>
                  <div className="flex items-center gap-2">
                    <Button variant="ghost" size="icon" title="Run now">
                      <Play className="h-4 w-4" />
                    </Button>
                    <Button
                      variant="ghost"
                      size="icon"
                      className="text-destructive hover:text-destructive"
                      onClick={() => handleDelete(task.id)}
                    >
                      <Trash2 className="h-4 w-4" />
                    </Button>
                  </div>
                </div>
                {task.description && (
                  <p className="text-sm text-muted-foreground mt-1">{task.description}</p>
                )}
                {task.last_run_at && (
                  <p className="text-xs text-muted-foreground mt-1">
                    Last run: {new Date(task.last_run_at).toLocaleString()}
                  </p>
                )}
              </CardHeader>
            </Card>
          ))}
        </div>
      )}
    </div>
  )
}
