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
    dictionary[:no_html].each {|field| strict_cleanup_and_parse record, field}
    dictionary[:html].each {|field| html_cleanup_and_parse record, field}
  end

  def strict_cleanup_and_parse(record, field)
    tokens = trim_and_tokenize record, field
    return if tokens.nil?
    strict_parser tokens, field, record
  end

  def html_cleanup_and_parse(record, field)
    tokens = trim_and_tokenize record, field
    return if tokens.nil?
    html_parser tokens, field, record
  end

  def trim_and_tokenize(record, field)
    return nil if just_whitespace?(record, field)
    tokens = record.send(field).split(KATEX_DELIMITER)
    tokens.length == 1 ? nil : tokens
  end
  
  def just_whitespace?(record, field)
    val = record.send(field)
    if val.blank?
      record.send "#{field}=", nil
      return true
    else
      record.send "#{field}=", val.strip
      return false
    end
  end

  def html_parser(tokens, field, record)
    tokens.each_with_index do |text, i|
      tokens[i] = Katex.render(text) if i.odd?
    end
    record.send "#{field}_katex=", tokens.join('')
  end

  def strict_parser(tokens, field, record)
    tokens.each_with_index do |text, i|
      tokens[i] = i.odd? ? Katex.render(text) : strip_tags(text)
    end
    record.send "#{field}_katex=", tokens.join('')
  end
end
