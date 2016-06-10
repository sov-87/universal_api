require 'active_support/concern'

module UniversalApi
  module Controller
    extend ActiveSupport::Concern
    
    def index
      @res = @model_class
      @res = @res.page(params[:page].to_i) if params[:page]
      @res = @res.limit(params[:limit] ? params[:limit].to_i : UniversalApi.page_size) unless params[:limitless]
      select_list = permitted_select_values
      @res = @res.select(select_list) if select_list
      @res = @res.ransack(q_ransack).result    
    end
    
    def show
    end
    
    def create
      invalid_resource!(@res) unless @res = @model_class.create!(permitted_params)
    end
    
    def update
      invalid_resource!(@res) unless @res.update!(permitted_params)
      @res.reload
    end
    
    def destroy
      @res.destroy
      raise @res.errors[:base].to_s unless @res.errors[:base].empty?
      respond_to do |format|
        format.any(:html) { render nothing: true, status: 204 }
        format.any(:xml, :json) { render request.format.to_sym => { success: true }, status: 204 }
      end
    end
    
    protected
      # Используем параметр q_defaults для передачи значений по-умолчанию, чтобы они не затирали значения в q
      # Use parameter q_defaults for transferring defaults without interferring with values in q
      def q_ransack
        q_defaults = params[:q_defaults] || {}
        q_defaults.merge(params[:q] || {})
      end
    
      def permitted_select_values
        if params[:select]
          case params[:select]
          when String
            permitted_select_value params[:select]
          when Array
            [@model_class.primary_key] + params[:select].map { |field| permitted_select_value field }.compact
          end
        end
      end
      
      def permitted_select_value field
        @select_fields ||= @model_class.column_names + extra_select_values
        (@select_fields.include? field) ? field : nil
      end
      
      def extra_select_values
        []
      end
      
      def permitted_params
        respond_to do |format|
          format.json do
            params.permit![_wrapper_options.name]
            params[_wrapper_options.name].extract! @model_class.primary_key
            params[_wrapper_options.name]
          end
          format.xml do
            data = Hash.from_xml(request.body.read).first[1]
            data.delete @model_class.primary_key
            data
          end
        end
      end
      
      def get_model_name
        params[:model_name] || controller_name.classify
      end
      
      def prepare_model
        model_name = get_model_name
        
        raise "Model class not present" if model_name.nil? || model_name.strip == ""
        
        @model_class = model_name.constantize
        
        raise "Model class is not ActiveRecord" unless @model_class < ActiveRecord::Base
      end
      
      def find_record
        where_params = {}
        
        raise ActionController::ParameterMissing unless params[:id]
        
        params[:id].split(',').each do |param_pair|
          v, k = param_pair.split("=").reverse
          where_params[(k || "id").to_sym] = v
        end
        
        @res = @model_class.where(where_params).first
        
        raise ActiveRecord::RecordNotFound unless @res
      end
  end
end
