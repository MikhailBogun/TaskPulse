require 'rails_helper'

RSpec.describe User, type: :model do
  subject { build(:user) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
    it { is_expected.to validate_length_of(:password).is_at_least(8) }
  end

  describe 'associations' do
    it { is_expected.to have_many(:tasks).dependent(:destroy) }
    it { is_expected.to have_many(:categories).dependent(:destroy) }
    it { is_expected.to have_many(:alert_rules).dependent(:destroy) }
  end

  describe 'enums' do
    it { is_expected.to define_enum_for(:plan).with_values(free: 0, trial: 1, pro: 2, enterprise: 3) }
  end

  describe '#plan_limit' do
    it 'returns correct task limit for free plan' do
      user = build(:user, plan: :free)
      expect(user.plan_limit(:tasks)).to eq(10)
    end

    it 'returns infinity for enterprise plan' do
      user = build(:user, plan: :enterprise)
      expect(user.plan_limit(:tasks)).to eq(Float::INFINITY)
    end
  end

  describe '#trial_expired?' do
    it 'returns true when trial has ended' do
      user = build(:user, :trial_expired)
      expect(user.trial_expired?).to be true
    end

    it 'returns false when trial is active' do
      user = build(:user, :trial)
      expect(user.trial_expired?).to be false
    end
  end

  describe '#active_subscription?' do
    it 'returns true for pro users' do
      expect(build(:user, :pro).active_subscription?).to be true
    end

    it 'returns true for active trial' do
      expect(build(:user, :trial).active_subscription?).to be true
    end

    it 'returns false for expired trial' do
      expect(build(:user, :trial_expired).active_subscription?).to be false
    end
  end
end
