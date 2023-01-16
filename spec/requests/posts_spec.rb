require "rails_helper"
require "byebug"

RSpec.describe "Posts check", type: :request do
  #Listar posts
  describe "GET /post without data" do
    it "When DB is empty, it should return an empty object with status 200" do
      get "/posts"
      payload = JSON.parse(response.body)
      expect(payload).to be_empty
      expect(response).to have_http_status(200)
    end
  end
  describe "GET /posts" do
  #create_list is a method from factory_bot
  #create_list(name, amount, *traits_and_overrides, &block) ⇒ Array
  let!(:posts) { create_list(:post, 10, published: true) }
    it "With data in the DB, it should return all the posts" do
      get "/posts"
      payload = JSON.parse(response.body)
      expect(response).to have_http_status(200)
      expect(payload.size).to eq(posts.size)
    end
  end
  describe "GET /post/{id}" do
    let!(:post) { create(:post) }

    it "it should return one post" do
      get "/posts/#{post.id}"
      payload = JSON.parse(response.body)
      expect(payload).to_not be_empty
      expect(payload['id']).to eq(post.id)
      expect(payload['title']).to eq(post.title)
      expect(payload['content']).to eq(post.content)
      expect(payload['published']).to eq(post.published)
      expect(payload['author']["name"]).to eq(post.user.name)
      expect(payload['author']["email"]).to eq(post.user.email)
      expect(payload['author']["id"]).to eq(post.user.id)
      expect(response).to have_http_status(200)
    end
  end

  #Crear posts
  describe "POST /post" do
    let!(:test_user) {create(:user)}
    it "Should create a post" do
      req_payload = {
        post: {
          title: 'Titulo',
          content: 'Content',
          published: false,
          user_id: test_user.id 
        }
      }

      post "/posts", params: req_payload
      payload = JSON.parse(response.body)
      expect(payload).to_not be_empty
      expect(payload["id"]).to_not be_nil
      expect(response).to have_http_status(:created)
    end

    it "should return error on invalid post" do
      req_payload = {
        post: {
          content: 'Content',
          published: false,
          user_id: test_user.id
        }
      }

      post "/posts", params: req_payload
      payload = JSON.parse(response.body)
      expect(payload).to_not be_empty
      expect(payload["error"]).to_not be_empty
      expect(response).to have_http_status(:unprocessable_entity)
      
    end
  end

  describe "PUT /post/{id}" do
    let!(:article) {create(:post)}
    it "Should edit a post" do
      req_payload = {
        post: {
          title: 'Titulo',
          content: 'Content',
          published: false
        }
      }

      put "/posts/#{article.id}", params: req_payload
      payload = JSON.parse(response.body)
      expect(payload).to_not be_empty
      expect(payload["id"]).to eq(article.id)
      expect(payload["title"]).to eq(req_payload[:post][:title])
      expect(response).to have_http_status(:ok)
      
    end

    it "should return error on invalid put" do
      req_payload = {
        post: {
          title: nil,
          content: nil,
          published: false
        }
      }

      put "/posts/#{article.id}", params: req_payload
      payload = JSON.parse(response.body)
      expect(payload).to_not be_empty
      expect(payload["error"]).to_not be_empty
      expect(response).to have_http_status(:unprocessable_entity)
      
    end
  end
  
end
