require 'rails_helper'

RSpec.feature "Messages feature", type: :feature do
  let!(:user) { create(:user) }
  let!(:friend_1) { create(:user) }
  let!(:friend_2) { create(:user) }
  let!(:friend_3) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:friendship_1) { create(:friendship, user: user, friend: friend_1) }
  let!(:friendship_2) { create(:friendship, user: user, friend: friend_2) }
  let!(:friendship_3) { create(:friendship, user: user, friend: friend_3) }
  let(:message_1) { create(:message, from: friend_1, to: user, text: "Hey there!") }
  let(:message_2) { create(:message, from: friend_2, to: user, text: "I am a bit earlier", created_at: 1.hour.ago) }
  let(:message_3) { create(:message, from: user, to: friend_3, text: "Message from user to friend") }

  scenario "tells user to log in to see messages" do
    visit posts_path
    expect(page).to have_content("Login to see your messages!")
  end

  scenario "shows friends and only friends in the messages" do
    log_in_as(user)
    visit posts_path

    expect(page.find(:id, "message_list")).to have_content(friend_1.display_name)
    expect(page.find(:id, "message_list")).to have_content(friend_2.display_name)
    expect(page.find(:id, "message_list")).not_to have_content(other_user.display_name)
  end

  scenario "shows message or start chat if no messages" do
    message_received = message_1.text
    message_sent = message_3.text
    log_in_as(user)
    expect(page.find(:id, "#{friend_1.user_id}-chat")).to have_content(message_received)
    # Message 2 was not called, therefore friend_2 sent no messages
    expect(page.find(:id, "#{friend_2.user_id}-chat")).to have_content("Click to start a chat...")
    expect(page.find(:id, "#{friend_2.user_id}-chat")).to have_content(message_sent)
    expect(page.find(:id, "#{friend_2.user_id}-chat")).to have_content("You: #{message_sent}")
  end

  scenario "messages are sorted well" do
    message_1
    message_2
    log_in_as(user)
    messages_list = page.find(:id, "message_list").all("li")
    messages_times = messages_list.map { |li| li.find("div.align-self-stretch").text }

    first_time = Time.parse(messages_times[0])
    second_time = Time.parse(messages_times[1])
    expect(first_time).to be < second_time
  end

  scenario "messages are reciprocal" do
    message_1_text = message_1.text
    log_in_as(user)
    expect(page.find(:id, "#{friend_1.user_id}-chat")).to have_content(message_1_text)
    log_out

    log_in_as(friend_1)
    expect(page.find(:id, "#{user.user_id}-chat")).to have_content(message_1_text)
  end

  scenario "sent messages appear in real time", js: true do
    log_in_as(user)
    expect(page.find(:id, "chat-box")).not_to be_present
    friend_1_messages = page.find(:id, "#{friend_1.user_id}-chat")
    friend_1_messages.find(:css, "text-secondary").click
    expect(page.find(:id, "chat-box")).to have_content(friend_1.display_name)
    page.find(:id, "chat-box-input").set "Hi!"
    page.find(:id, "chat-box-send").click

    expect(page.find(:id, "chat-box-chat")).to have_content("Hi!")
  end

  scenario "received messages appear in the list in real time", js: true do
    log_in_as(user)
    friend_1_messages = page.find(:id, "#{friend_1.user_id}-chat")
    expect(friend_1_messages).not_to have_content(:id, "new-message")
    message_1
    expect(friend_1_messages).to have_content(:id, "new-message")
  end

  scenario "received messages appear in the chat in real time", js: true do
    log_in_as(user)
    friend_1_messages = page.find(:id, "#{friend_1.user_id}-chat")
    friend_1_messages.find(:css, "text-secondary").click
    message_1
    expect(page.find(:id, "chat-box")).to have_content(message_1.text)
  end
end
