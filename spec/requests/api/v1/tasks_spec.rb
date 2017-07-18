require 'rails_helper'

RSpec.describe 'Task API' do
  before { host! 'api.taskmanager.dev' }

  let!(:user) { create(:user) }
  let(:headers) do
    {
      'Accept' => 'application/vnd.taskmanager.v1',
      'Content-Type' => Mime[:json].to_s,
      'Authorization' => user.auth_token
    }
  end

  describe 'GET /tasks' do
    before do
      create_list(:task, 5, user_id: user.id)
      get '/tasks', params: {}, headers: headers
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end

    it 'returns 5 tasks from database' do
      expect(json_body[:tasks].count).to eq(5)
    end
  end

  describe 'GET /tasks/:id' do
    let(:task) { create(:task, user_id: user.id) }
    before do
      get "/tasks/#{task.id}", params: {}, headers: headers
    end

    context 'when the tasks exists' do
      it 'returns the task' do
        expect(json_body[:title]).to eq(task.title)
      end

      it 'returns status 200' do
        expect(response).to have_http_status(200)
      end
    end
  end

  describe 'POST /tasks' do
    before do
      post '/tasks', params: { task: task_params }.to_json, headers: headers
    end
    context 'when the request params are valid' do
      let(:task_params) { FactoryGirl.attributes_for(:task) }

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end

      it 'saves the task in the database' do
        expect(Task.find_by(title: task_params[:title])).not_to be_nil
      end

      it 'returns json data' do
        expect(json_body[:title]).to eq(task_params[:title])
      end

      it 'assigns the created task to the current user' do
        expect(json_body[:user_id]).to eq(user.id)
      end
    end

    # context 'when the request params are invalid' do
    #   let(:user_params) { attributes_for(:user, email: 'invalid_email') }
    #
    #   it 'return status code 422' do
    #     expect(response).to have_http_status(422)
    #   end
    #
    #   it 'return the json data for the errors' do
    #     expect(json_body).to have_key(:errors)
    #   end
    # end
  end
end
