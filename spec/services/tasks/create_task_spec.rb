require 'rails_helper'

RSpec.describe Tasks::CreateTask, type: :service do
  describe '.call' do
    let(:user) { create(:user, plan: :pro) }
    let(:valid_params) { { name: 'Monitor GitHub', description: 'Check open issues' } }

    it 'creates a task for the user' do
      expect {
        described_class.call(user: user, params: valid_params)
      }.to change(user.tasks, :count).by(1)
    end

    it 'returns the created task' do
      task = described_class.call(user: user, params: valid_params)
      expect(task).to be_a(Task)
      expect(task.name).to eq('Monitor GitHub')
    end

    context 'when plan limit is reached' do
      before do
        create_list(:task, 10, user: user.tap { |u| u.update!(plan: :free) })
      end

      it 'raises ActiveRecord::RecordInvalid' do
        user.reload
        expect {
          described_class.call(user: user, params: valid_params)
        }.to raise_error(ActiveRecord::RecordInvalid, /Task limit reached/)
      end
    end
  end
end
