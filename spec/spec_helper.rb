require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
  config.include FactoryBot::Syntax::Methods
  config.include Devise::Test::IntegrationHelpers, type: :request
end

# spec/models/user_spec.rb
require 'rails_helper'

RSpec.describe User, type: :model do
  it "is valid with valid attributes" do
    user = User.new(email: "test@example.com", password: "password")
    expect(user).to be_valid
  end

  it "is not valid without an email" do
    user = User.new(password: "password")
    expect(user).to_not be_valid
  end
end

# spec/models/post_spec.rb
require 'rails_helper'

RSpec.describe Post, type: :model do
  it "is valid with valid attributes" do
    user = User.create(email: "test@example.com", password: "password")
    post = Post.new(title: "Test Title", body: "Test Body", user: user)
    expect(post).to be_valid
  end

  it "is not valid without a title" do
    user = User.create(email: "test@example.com", password: "password")
    post = Post.new(body: "Test Body", user: user)
    expect(post).to_not be_valid
  end
end

# spec/requests/api/posts_spec.rb
require 'rails_helper'

RSpec.describe "Api::Posts", type: :request do
  let(:user) { User.create(email: "test@example.com", password: "password") }
  let(:valid_attributes) { { title: "Test Title", body: "Test Body" } }

  describe "GET /api/posts" do
    it "returns a success response" do
      Post.create! valid_attributes.merge(user: user)
      get api_posts_path
      expect(response).to be_successful
    end
  end

  describe "POST /api/posts" do
    it "creates a new Post" do
      sign_in user
      expect {
        post api_posts_path, params: { post: valid_attributes }
      }.to change(Post, :count).by(1)
    end
  end
end