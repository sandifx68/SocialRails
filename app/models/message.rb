class Message < ApplicationRecord
  belongs_to :from, class_name: "User"
  belongs_to :to, class_name: "User"

  validates :text, presence: true

  # Provide an application-level default; DB enforces NOT NULL
  attribute :seen, :boolean, default: false

  validate :between_friends

  def between_friends
    unless from.is_friends_with(to)
      errors.add("Messages can only be sent between friends.")
    end
  end

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

  def just_time_formatted
    t = created_at.in_time_zone
    t.strftime("%H:%M")
  end

  def formatted_text(current_user)
    if self.from == current_user
      "You: #{self.text}"
    else
      self.text
    end
  end

  # Helpers to group messages for chat transcript headers
  # Groups: :today, :yesterday, :weekday (last 7 days), :date (older)
  def chat_group_key(now: Time.zone.now)
    tz_now = now.in_time_zone
    date = created_at.in_time_zone.to_date
    today = tz_now.to_date

    if date == today
      [ :today, date ]
    elsif date == today - 1
      [ :yesterday, date ]
    elsif date >= today - 6 && date <= today - 2
      [ :weekday, date ]
    else
      [ :date, date ]
    end
  end

  def chat_group_label(now: Time.zone.now)
    type, _date = chat_group_key(now: now)
    t = created_at.in_time_zone
    case type
    when :today      then "Today"
    when :yesterday  then "Yesterday"
    when :weekday    then t.strftime("%A")
    else                   t.strftime("%d-%m-%Y")
    end
  end
end
