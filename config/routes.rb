UniversalApi::Engine.routes.draw do
  
  scope "/:model_name", controller: 'universal_api' do
    get '/', action: 'index'
    get '/:id', action: 'show'
    post '/', action: 'create'
    put '/:id', action: 'update'
    delete '/:id', action: 'destroy'
  end
end
