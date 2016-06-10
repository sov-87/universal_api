require 'test_helper'
require 'helpers/api_helper'
require 'ransack'
require 'will_paginate'

class ApiIndexTest < ActionDispatch::IntegrationTest
  
  include ApiHelper
  
  INDEX_TEST_CASES = {
    simple: {
      params: {
        q: {
          name_cont: 'test',
          s: 'name'
        },
        select: ['name'],
        limit: 5
      },
      sql: TestModel.limit(5).order(:name).ransack({ name_cont: 'test' }).result.select('id, name').to_sql
    },
    pagination: {
      params: {
        page: 1,
        q: { s: 'name' }
      },
      sql: TestModel.limit(WillPaginate.per_page).order(:name).to_sql
    }
  }
  
  CONTENT_TYPES.each_pair do |content_type, content_type_str|
    INDEX_TEST_CASES.each_pair do |test_case, data|
      define_method("test_#{test_case}_#{content_type}".to_sym) do
        get "/universal_api/TestModel",
          data[:params],
          {
            "Accept" => content_type_str,
            "CONTENT_TYPE" => content_type_str
          }
        assert @response.ok?, @response.inspect
        
        response_body = @response.body
        res = send("parse_response_#{content_type}", response_body)
        
        check_response_data(res, ActiveRecord::Base.connection.select_all(data[:sql]))
      end
    end
  end
end
