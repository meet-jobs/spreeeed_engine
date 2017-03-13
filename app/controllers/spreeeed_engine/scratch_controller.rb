module SpreeeedEngine
  class ScratchController < SpreeeedEngine::ApplicationController

    def hello
      render text: 'Hello World'
    end

    def index

    end

    skip_before_filter :"authenticate_#{SpreeeedEngine.devise_auth_resource}!", :setup_global_variables, only: [:typeahead_data]
    def typeahead_data
      fake_data = {
        options: FakeObject.all.collect(&:name)
      }
      respond_to do |format|
        format.json { render json: fake_data }
      end

    end

  end
end