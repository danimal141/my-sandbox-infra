# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'HealthCheck' do
  before do
    driven_by(:rack_test)
  end

  it 'ブラウザテストを実行する' do
    visit '/ops/heartbeat'
    expect(page).to have_content 'heartbeat:ok'
  end
end
