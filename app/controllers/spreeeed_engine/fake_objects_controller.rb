module SpreeeedEngine
  class FakeObjectsController < SpreeeedEngine::ApplicationController

    include EngineRouteController

    def setup_global_variables
      @klass             ||= SpreeeedEngine::FakeObject
      super
      @datatable_columns = [:name, :email, :credit, :beginning_at, :published_state, :commentable]
      @datatable_default_sortable_cols = [[:name, 'ASC']]
      @datatable_searchable_cols = [:name]
    end

  end
end