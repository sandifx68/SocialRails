require 'rails_helper'

RSpec.describe Message, type: :model do
  describe '#formatted_time' do
    let!(:sender) { create(:user) }
    let!(:receiver) { create(:user) }
    let!(:friendship) { create(:friendship, user: sender, friend: receiver) }

    it 'returns HH:MM for messages created today' do
      now = Time.zone.parse('2025-09-29 14:07')
      created = Time.zone.parse('2025-09-29 09:05')
      msg = create(:message, from: sender, to: receiver, created_at: created)
      expect(msg.formatted_time(now: now)).to eq('09:05')
    end

    it 'returns "Yesterday" for messages created yesterday' do
      now = Time.zone.parse('2025-09-29 10:00')
      created = Time.zone.parse('2025-09-28 23:59')
      msg = create(:message, from: sender, to: receiver, created_at: created)
      expect(msg.formatted_time(now: now)).to eq('Yesterday')
    end

    it 'returns weekday name for messages within the last week (2-6 days ago)' do
      now = Time.zone.parse('2025-09-29 10:00')
      created = now - 3.days
      msg = create(:message, from: sender, to: receiver, created_at: created)
      expect(msg.formatted_time(now: now)).to eq(created.strftime('%A'))
    end

    it 'returns YYYY-MM-DD for messages 6+ days ago' do
      now = Time.zone.parse('2025-09-29 10:00')
      created = now - 7.days
      msg = create(:message, from: sender, to: receiver, created_at: created)
      expect(msg.formatted_time(now: now)).to eq(created.strftime('%d-%m-%Y'))
    end
  end
end
