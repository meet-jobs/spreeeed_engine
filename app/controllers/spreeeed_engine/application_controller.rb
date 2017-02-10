module SpreeeedEngine
  class ApplicationController < ActionController::Base
    include SpreeeedEngine::UtilityHelper
    include SpreeeedEngine::RoutesHelper

    include DatatableController

    protect_from_forgery with: :exception

    PER_PAGE = 20

    before_filter :"authenticate_#{SpreeeedEngine.devise_auth_resource}!", :setup_global_variables

    def setup_global_variables
      @klass             ||= NilClass
      # klass_name         = @klass.name
      @displayable_cols  = (klass_name == 'NilClass' ? [] : @klass.displayable_cols)
      @editable_cols     = (klass_name == 'NilClass' ? [] : @klass.editable_cols)
      @nested_cols       = (klass_name == 'NilClass' ? [] : @klass.nested_cols)
      @hidden_cols       = (klass_name == 'NilClass' ? [] : @klass.hidden_cols)
      @creatable         ||= true
      @editable          ||= true
      @deletable         ||= true

      # setup all datatable env
      @datatable_columns               ||= @klass.datatable_cols
      @datatable_searchable_cols       ||= @klass.datatable_searchable_cols
      @datatable_default_sortable_cols ||= @klass.datatable_default_sortable_cols
    end

    def index
      # retrieve the localization of column name
      @datatable_labels  = datatable_labels(@klass.new, @datatable_columns)

      # get all sortable datatable columns
      @datatable_sortable_columns = datatable_sortable_columns(@klass, @datatable_columns, @datatable_default_sortable_cols)

      # get all datatable instances
      per_page  = params[:iDisplayLength] || PER_PAGE
      page      = (params[:iDisplayStart].to_i / per_page.to_i) + 1

      proxy      = datatable_instances_proxy(@klass, @searchable_cols, @datatable_sortable_columns)
      @instances = datatable_instances(proxy, page, per_page)
      total      = datatable_instances_total(proxy)


      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: datatable_raws(@instances, @datatable_columns, total) }
      end
    end


    def new
      @object = @klass.new

      respond_to do |format|
        format.html # new.html.erb
        # format.json { render json: @object }
      end
    end

    def show
      @object = @klass.find(params[:id])

      respond_to do |format|
        format.html # show.html.erb
        # format.json { render json: @object }
      end
    end

    def edit
      @object = @klass.find(params[:id])
      respond_to do |format|
        format.html # edit.html.erb
        # format.json { render json: @object }
      end
    end

    def create
      @object = @klass.new(klass_params(@klass))

      respond_to do |format|
        if @object.save
          format.html { redirect_to object_path(@object), notice: "#{@klass.name} was successfully created." }
          # format.html { redirect_to [SpreeeedEngine.namespace.to_sym, @object], notice: "#{@klass.name} was successfully created." }
          # format.json { render json: @object, status: :created, location: @object }
        else
          format.html { render action: 'new' }
          # format.json { render json: @object.errors, status: :unprocessable_entity }
        end
      end
    end

    def update
      @object = @klass.find(params[:id])

      respond_to do |format|
        if @object.update_attributes(klass_params(@klass))
          # format.html { redirect_to [SpreeeedEngine.namespace.to_sym, @object], notice: "#{@klass_name} was successfully updated." }
          format.html { redirect_to object_path(@object), notice: "#{@klass_name} was successfully updated." }
          # format.json { head :no_content }
        else
          format.html { render action: 'edit' }
          # format.json { render json: @object.errors, status: :unprocessable_entity }
        end
      end
    end

    def destroy
      @object = @klass.find(params[:id])
      @object.destroy

      respond_to do |format|
        # format.html { redirect_to send("#{SpreeeedEngine.namespace}_#{@klass_name.underscore.pluralize}_url") }
        format.html { redirect_to objects_path }
        # format.json { head :no_content }
      end
    end


    private

    def klass_params(klass)
      nested_params = klass.nested_cols.collect { |name, class_name| {"#{name}_attributes".to_sym => class_name.constantize.editable_cols + [:id, :_destroy]} }
      params.require(klass.name.demodulize.underscore.to_sym).permit(klass.editable_cols + nested_params)
    end




  end
end
