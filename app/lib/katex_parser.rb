require 'katex'

class KatexParser
  include ActionView::Helpers::SanitizeHelper

  KATEX_DELIMITER = '$$'

  def initialize(html:, no_html:)
    @html, @no_html = html, no_html
  end

  def before_save(record)
    @record = record
    @no_html.each {|field| tasks field, true}
    @html.each {|field| tasks field, false}
  end

  private
  def tasks(field, strict)
    return unless @record.send("#{field}_changed?")
    return unless remove_whitespace(field)
    parse_katex field, strict
  end

  def remove_whitespace(field)
    val = @record.send field
    @record.send("#{field}=", val.blank? ? nil : val.strip)
  end

  def parse_katex(field, strict)
    tokens = @record.send(field).split(KATEX_DELIMITER)
    return if tokens.length == 1
    render(field, tokens, strict)
  end

  def render(field, tokens, strict)
    begin
      strict ? strict_parse(tokens) : html_parse(tokens)
      @record.send("#{field}_katex=", tokens.join(''))
    rescue ExecJS::ProgramError
      @record.errors.add(field, "Katex could not be parsed, check your $$ usage")
    end
  end

  def strict_parse(tokens)
    tokens.each_with_index do |text, i|
      tokens[i] = i.odd? ? Katex.render(text) : strip_tags(text)
    end
  end

  def html_parse(tokens)
    tokens.each_with_index do |text, i|
      tokens[i] = Katex.render(text) if i.odd?
    end
  end
end
