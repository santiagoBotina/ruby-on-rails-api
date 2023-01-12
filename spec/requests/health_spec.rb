require 'rails_helper'

RSpec.describe 'Health endpoint check', type: :request do
    describe "GET /health" do
        before { get '/health' }
        it 'Should return OK' do
            #Response viene ya que el tipo de prueba
            #es "request"
            payload = JSON.parse(response.body) 
            expect(payload).not_to be_empty  
            expect(payload['api']).to eq('OK')  
        end

        it 'Should return status code 200' do
            expect(response).to have_http_status(200)  
        end
    end
end