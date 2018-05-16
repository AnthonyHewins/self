module CkeditorHelpers
  def fill_in_editor(locator, text)
    page.execute_script("window.CKEDITORS['#{locator}'].data.set('#{text}');")
  end
end
