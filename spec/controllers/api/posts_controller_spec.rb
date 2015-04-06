require 'rails_helper'

RSpec.describe Api::PostsController, type: :controller do
  describe "GET #index" do
    before(:each) do
      FactoryGirl.create(:post, updated_at: 1.week.ago)
      FactoryGirl.create(:another_post, updated_at: 1.day.ago)
      get :index, format: :json
      @posts = JSON.parse(response.body, symbolize_names: true)[:posts]
    end

    it "returns correct number of posts" do
      expect(@posts.count).to eql 2
    end

    it "returns posts in descending order (newest first)" do
      expect(@posts.first[:updated_at]).to be > @posts.last[:updated_at]
    end

    it "returns correct post data" do
      expect(@posts.first.keys).to match_array([:id, :title, :author_name, :author_city, :images, :updated_at])
    end

    it "returns success status" do
      expect(response).to have_http_status(200)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new post in the system" do
        new_post = FactoryGirl.attributes_for(:post)
        new_post[:user] = { id: new_post[:user][:id] }
        post :create, post: new_post, format: :json

        expect(Post.count).to eq 1
        expect(response).to have_http_status(201)
      end
    end

    context "with invalid params" do
      it "returns error message" do
        invalid_post = FactoryGirl.attributes_for(:post).tap {|p| p.delete(:title) } # leave out the title
        invalid_post[:user] = { id: invalid_post[:user][:id] }
        post :create, post: invalid_post, format: :json

        err_resp = JSON.parse(response.body, symbolize_names: true)
        expect(err_resp).to have_key(:errors)
        expect(err_resp[:errors][:title]).to include "can't be blank"
        expect(response).to have_http_status(422)
      end
    end
  end

  describe "GET #show" do
    it "returns single post data" do
      p = FactoryGirl.create :post
      get :show, id: p.id, format: :json
      show_response = JSON.parse(response.body, symbolize_names: true)[:post]
      expect(show_response).to_not be_nil
      expect(show_response).to have_key(:id)
      expect(show_response[:id]).to eql Post.first.id
      expect(response).to have_http_status(200)
    end
  end

  describe "PUT #update" do
    before(:each) do
      FactoryGirl.create(:post)
    end
    let(:p) { Post.first }

    context "with valid params" do      
      it "updates a post in the system" do
        put :update, { id: p.id, post: { title: "foo" } }, format: :json # update the title
        expect(response.body).to_not be_nil
        expect(response).to have_http_status(200)
        expect(Post.first.title).to eq "foo"
      end
    end

    context "with invalid params:" do      
      it "returns error message on invalid post id" do
        put :update, {id: 999, post: {title: "foo"}}, format: :json
        err_resp = JSON.parse(response.body, symbolize_names: true)
        expect(err_resp).to have_key(:errors)
        expect(err_resp[:errors][:id]).to include "Couldn't find Post with 'id'=999"
        expect(response).to have_http_status(422)
      end

      it "returns error message on blank title" do
        put :update, {id: p.id, post: {title: ""}}, format: :json
        err_resp = JSON.parse(response.body, symbolize_names: true)
        expect(err_resp).to have_key(:errors)
        expect(err_resp[:errors][:title]).to include "can't be blank"
        expect(response).to have_http_status(422)
      end
    end
  end

  describe "DELETE #destroy" do
    it "deletes the post" do
      FactoryGirl.create(:post)
      expect(Post.count).to eq 1
      delete :destroy, id: Post.first.id, format: :json
      expect(Post.count).to eq 0
      expect(response).to have_http_status(204)
    end

    it "returns error if id is invalid" do
      FactoryGirl.create(:post)
      expect(Post.count).to eq 1
      delete :destroy, id: 999, format: :json
      expect(Post.count).to eq 1
      err_resp = JSON.parse(response.body, symbolize_names: true)
      expect(err_resp[:errors][:id]).to include "Couldn't find Post with 'id'=999"
      expect(response).to have_http_status(422)
    end
  end
end
