require 'test_helper'
require 'helpers/api_helper'

class ApiTest < ActionDispatch::IntegrationTest
  
  include ApiHelper
  
  CONTENT_TYPES.each_pair do |content_type, content_type_str|
    define_method("test_update_#{content_type}".to_sym) do
      update_content_type_test(content_type, content_type_str)
    end
    define_method("test_create_#{content_type}".to_sym) do
      create_content_type_test(content_type, content_type_str)
    end
    define_method("test_delete_#{content_type}".to_sym) do
      delete_content_type_with_query_test(content_type, content_type_str)
    end
  end
  
  def update_content_type_test(content_type, content_type_str)
    test_model = TestModel.create(name: 'test_model')
    
    body_obj = {
        name: 'rename_test_model'
    }
    
    put "/universal_api/TestModel/#{test_model.id}",
      body_obj.send("to_#{content_type}"),
      {
        "Accept" => content_type_str,
        "CONTENT_TYPE" => content_type_str
      }
    assert @response.ok?, @response.inspect
    
    response_body = @response.body
    res = send("parse_response_#{content_type}", response_body)
    
    real_res = ActiveRecord::Base.connection.select_all(TestModel.where(id: test_model.id).to_sql)
    
    check_response_data(res, real_res)
    
    test_model.destroy
  end
  
  def create_content_type_test(content_type, content_type_str)
    body_obj = {
      name: 'test_model'
    }
    
    post "/universal_api/TestModel",
      body_obj.send("to_#{content_type}"),
      {
        "Accept" => content_type_str,
        "CONTENT_TYPE" => content_type_str
      }
    assert @response.ok?, @response.inspect
    
    response_body = @response.body
    res = send("parse_response_#{content_type}", response_body)
    
    real_res = ActiveRecord::Base.connection.select_all(TestModel.where(name: body_obj[:name]).to_sql)
    
    check_response_data(res, real_res)
    
    TestModel.where(name: body_obj[:name]).first.destroy
  end
  
  def delete_content_type_with_query_test(content_type, content_type_str)
    test_model = TestModel.create(name: 'test_model')
    
    delete "/universal_api/TestModel/#{test_model.id}",
      nil,
      {
        "Accept" => content_type_str,
        "CONTENT_TYPE" => content_type_str
      }
    
    assert_equal @response.status, 204, @response.inspect
    
    real_res = ActiveRecord::Base.connection.select_all(TestModel.where(id: test_model.id).to_sql)
    
    assert_empty real_res, real_res.inspect
    
    test_model.destroy
  end
end
