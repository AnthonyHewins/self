module CkeditorHelpers
  def fill_in_editor(locator="body", text)
    page.execute_script("window.CKEDITORS['#{locator}'].data.set('#{text}');")
  end

  def random_fill_in(value, locator:  "body")
    val = value || FFaker::BaconIpsum.characters(500)
    page.execute_script("window.CKEDITORS['#{locator}'].data.set('#{val}');")
  end
end
