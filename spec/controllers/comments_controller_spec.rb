require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  describe 'as logged user' do
    let(:genre) { Genre.create(name: 'action') }
    let(:movie) { Movie.create(id: 1, title: 'Movie', description: "aaaaaa", genre: genre) }
    let(:user)  { User.create(id: 1, name: 'Test', email: 'test@example.com', password: 'password' ) }
    
    before do
      sign_in(user)
      user.confirm
    end

    describe 'POST create' do
      # it 'should have saved the comment' do
      #   expect { post :create, params: { 
      #     user_id: 1, 
      #     movie_id: 1, 
      #     content: "asdasdasd" 
      #   }}.to change{Comment.count}.by(1)
      # end
      
      it "should not save the comment" do
        expect { post :create, params: { 
          user_id: 1, 
          movie_id: nil, 
          content: "asdasdasd" 
        }}.to change{Comment.count}.by(0)
      end
    end
  end
end
