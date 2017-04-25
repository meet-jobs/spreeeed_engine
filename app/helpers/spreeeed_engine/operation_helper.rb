module SpreeeedEngine
  module OperationHelper

    def edit_label
      "<i class='fa fa-pencil'></i> #{t('edit')}".html_safe
    end

    def frontend_view_label
      "<i class='fa fa-eye'></i> #{t('frontend_view')}".html_safe
    end

    def destroy_label
      "<i class='fa fa-trash-o'></i> #{t('destroy')}".html_safe
    end

    def spinner
      classes = %w(bounce1 bounce2 bounce3)
      content_tag :div, class: 'spinner' do
        classes.collect{ |css| content_tag(:div, '', class: css) }.join.html_safe
      end
    end

  end
end
