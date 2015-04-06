require 'rails_helper'

RSpec.describe Api::CommentsController, type: :controller do
  describe "GET #index" do
    before(:each) do
      p = FactoryGirl.create(:post)
      3.times { FactoryGirl.create(:comment, post: p) }
      p.comments.each { |c| rand(1..5).times { FactoryGirl.create(:comment, post: p, parent: c) } }
      get :index, {post_id: p.id}, format: :json
      @comments = JSON.parse(response.body, symbolize_names: true)[:comments]
    end

    it "returns correct number of comments for each thread" do
      expect(@comments.count).to eql 3
      @comments.each {|c| expect(1..5).to cover(c[:comments].count) }
    end

    it "returns comments in ascending order (newest at the bottom)" do
      expect(@comments.first[:updated_at]).to be < @comments.last[:updated_at]
    end

    it "returns success status" do
      expect(response).to have_http_status(200)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new comment on a post" do
        FactoryGirl.create(:post)
        FactoryGirl.create(:user)
        p = Post.first
        u = User.first

        new_comment = FactoryGirl.attributes_for(:comment)
        new_comment[:post] = { id: p.id }
        new_comment[:user] = { id: u.id }
        post :create, comment: new_comment, format: :json

        c = Comment.first
        expect(c).to_not be_nil
        expect(Comment.count).to eq 1
        expect(c.post.id).to eq p.id
        expect(c.user.id).to eq u.id
        expect(response).to have_http_status(201)
      end

      it "creates a new comment under an existing comment on a post" do
        c = FactoryGirl.create(:comment)
        nested_comment = FactoryGirl.attributes_for(:comment)
        nested_comment[:post] = { id: c.post.id }
        nested_comment[:user] = { id: c.user.id }
        nested_comment[:parent] = { id: c.id}
        post :create, comment: nested_comment, format: :json

        expect(Comment.count).to eq 2
        expect(c.post.comments.count).to eq 1
        expect(c.post.comments.first.comments.count).to eq 1
      end
    end

    context "with invalid params" do
      it "returns error message" do
        invalid_comment = FactoryGirl.attributes_for(:comment).tap {|p| p.delete(:content) } # leave out the comment
        invalid_comment[:post] = { id: invalid_comment[:post][:id] }
        invalid_comment[:user] = { id: invalid_comment[:user][:id] }
        post :create, comment: invalid_comment, format: :json

        err_resp = JSON.parse(response.body, symbolize_names: true)
        expect(err_resp).to have_key(:errors)
        expect(err_resp[:errors][:content]).to include "can't be blank"
        expect(response).to have_http_status(422)
      end
    end
  end

  describe "DELETE #destroy" do
    before(:each) do
      root = FactoryGirl.create(:comment)
      mid_lev = [].tap {|arr| 3.times {arr.push(FactoryGirl.create(:comment, parent: root, post: root.post))}}
      root.comments = mid_lev
      mid_lev.each {|ml| ml.comments = [FactoryGirl.create(:comment, parent: ml, post: ml.post)]}
    end
    let(:root) { Post.first.comments.first }

    it "deletes a root comment and all its child/nested comments" do
      expect(Comment.count).to eq 7
      delete :destroy, id: root.id, format: :json
      expect(Comment.count).to eq 0
      expect(response).to have_http_status(204)
    end

    it "deletes a mid-level comment and any comments nested below it" do
      expect(Comment.count).to eq 7
      delete :destroy, id: root.comments[1].id, format: :json
      expect(Comment.count).to eq 5
      expect(response).to have_http_status(204)
    end

    it "deletes a leaf/bottom-level comment (and nothing else)" do
      expect(Comment.count).to eq 7
      delete :destroy, id: root.comments[2].comments.first.id, format: :json
      expect(Comment.count).to eq 6
      expect(response).to have_http_status(204)
    end

    it "returns an error if the comment id does not exist" do
      expect(Comment.count).to eq 7
      delete :destroy, id: 999, format: :json
      expect(Comment.count).to eq 7
      err_resp = JSON.parse(response.body, symbolize_names: true)
      expect(err_resp[:errors][:id]).to include "Couldn't find Comment with 'id'=999"
      expect(response).to have_http_status(422)
    end
  end
end
