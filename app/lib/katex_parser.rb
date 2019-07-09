class KatexParser
  include Singleton
  include ActionView::Helpers::SanitizeHelper

  KATEX_DELIMITER = '$$'

  ARTICLE_KATEX_FIELDS = {
    no_html: %i[title tldr],
    html: %i[body]
  }

  def before_save(record)
    case record
    when Article
      remove_whitespace_and_parse record, ARTICLE_KATEX_FIELDS
    else
      raise TypeError
    end
  end

  private
  def remove_whitespace_and_parse(record, dictionary)
    dictionary[:no_html].each {|field| before_save_tasks record, field, true}
    dictionary[:html].each {|field| before_save_tasks record, field, false}
  end

  def before_save_tasks(record, field, strict)
    record.send "#{field}=", whitespace_cleanup(record.send field)
    return if record.send(field).nil?
    parse_katex record, field, strict
  end

  def whitespace_cleanup(val)
    return nil if val.blank?
    val.strip
  end

  def parse_katex(record, field, strict)
    tokens = record.send(field).split(KATEX_DELIMITER)
    return if tokens.length == 1
    render(record, field, tokens, strict)
  end

  def render(record, field, tokens, strict)
    begin
      strict ? strict_parse(tokens) : html_parse(tokens)
      record.send("#{field}_katex=", tokens.join(''))
    rescue ExecJS::ProgramError
      record.errors.add(field, "Katex could not be parsed, check your $$ usage")
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
