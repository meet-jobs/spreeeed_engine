module SpreeeedEngine
  class ScratchController < SpreeeedEngine::ApplicationController

    def hello
      render text: 'Hello World'
    end

    def index

    end

    skip_before_action :"authenticate_#{SpreeeedEngine.devise_auth_resource}!", :set_active_record_config, :set_datatables_config, only: [:typeahead_data]
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