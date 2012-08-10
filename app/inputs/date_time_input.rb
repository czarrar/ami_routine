class DateTimeInput < SimpleForm::Inputs::DateTimeInput
  def input
    add_autocomplete!
    @builder.text_field(attribute_name, input_html_options.merge(datetime_options(object.send(attribute_name))))
  end

  def label_target
    attribute_name
  end

  private

    def datetime_options(value = nil)
      return {} if value.nil?

      current_locale = I18n.locale
      I18n.locale = :en

      result = []
      result.push(I18n.localize(value, { :format => "%a %d %b %Y" })) if input_type =~ /date/
      if input_type =~ /time/
        hours_format = options[:"24hours"] ? "%H:%M" : "%I:%M %p"
        result.push(I18n.localize(value, { :format => hours_format }))
      end

      I18n.locale = current_locale

      { :value => result.join(', ').html_safe }
    end

    def has_required?
      options[:required]
    end

    def add_autocomplete!
      input_html_options[:autocomplete] ||= 'off'
    end
end