class Message < ApplicationRecord
  belongs_to :from, class_name: "User"
  belongs_to :to, class_name: "User"

  validates :text, presence: true

  # Provide an application-level default; DB enforces NOT NULL
  attribute :seen, :boolean, default: false

  # Returns a human-friendly timestamp based on recency:
  # - Today: 24h time (HH:MM)
  # - Yesterday: "Yesterday"
  # - Within the last week: weekday name (e.g., "Monday")
  # - 7+ days ago: ISO date (YYYY-MM-DD)
  # 'now' is injectable for testing and defaults to Time.zone.now.
  def formatted_time(now: Time.zone.now)
    t = created_at.in_time_zone
    today = now.to_date
    date = t.to_date

    if date == today
      t.strftime("%H:%M")
    elsif date == today - 1
      "Yesterday"
    elsif date >= today - 6 && date <= today - 2
      t.strftime("%A")
    else
      t.strftime("%d-%m-%Y")
    end
  end

  def formatted_text(current_user)
    if self.from == current_user
      "You: #{self.text}"
    else
      self.text
    end
  end
end
