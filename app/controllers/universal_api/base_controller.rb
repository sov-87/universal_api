module UniversalApi
  class BaseController < UniversalApi::ApplicationController
    include UniversalApi::Controller
    
    before_action :prepare_model, only: [:index, :show, :create, :update, :destroy]
    before_action :find_record, only: [:show, :update, :destroy]
  end
end
