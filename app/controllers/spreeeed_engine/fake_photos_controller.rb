module SpreeeedEngine
  class FakePhotosController < SpreeeedEngine::ApplicationController

    include EngineRouteController

    def setup_global_variables
      @klass             ||= SpreeeedEngine::FakePhoto
      super
      @datatable_columns = [:owner, :caption, :asset, :content_type, :width, :height, :size]
      @datatable_default_sortable_cols = [[:content_type, 'ASC']]
      @datatable_searchable_cols = [:content_type]
    end

  end
end