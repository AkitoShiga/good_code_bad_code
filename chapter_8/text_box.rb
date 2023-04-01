
# UI内の要素を表し、render_textはこの要素内にあるテキストをUIに表示する
class TextBox

  # @param[String] text
  # @param[Font] font
  # @param[Float] font_size
  # @param[Float] line_height
  # @param[Color] text_color
  def render_text(text, font, font_size, line_height, text_color)
  end
end

# テキストスタイルに関連する値の情報源
class UiSettings
  # @return[Font]
  def get_font; end

  # @return[Float]
  def get_font_size; end

  # @return[Float]
  def get_line_height; end

  # @return[Color]
  def get_text_color; end
end

# UiSettingsから読み取った情報をTextBoxにわたす
class UserInterface

  # @param[TextBox] message_box
  # @param[UiSettings] ui_settings
  def initialize(message_box, ui_settings)
    @message_box = message_box
    @ui_settings = ui_settings
  end

  # @param[String] message
  def display_message(message)
    # TextBox#render_textに変更があった場合、ここも変更しなければいけなくなる
    message_box.render_text(
      message,
      ui_settings.get_font,
      ui_settings.get_font_size,
      ui_settings.get_line_height,
      ui_settings.get_text_color
    )
  end

  private

  attr_reader :message_box, :ui_settings
end

# UserInterfaceはUiSettingsからTextBoxへの配達員のようなもの
# 設定の詳細には関心がない
# 実装に関係がない部分が依存してしまっている

# 関連データをオブジェクトまたはクラスにグループ化することで解決する

# テキストのUIに関する個々の情報をカプセル化する
class TextOption

  # @param[Font] font
  # @param[Float] font_size
  # @param[Float] line_height
  # @param[Color] text_color
  def initialize(font, font_size, line_height, text_color)
    @font = font
    @font_size = font_size
    @line_height = line_height
    @text_color = text_color
  end

  # @return[Font]
  def get_font; end

  # @return[Float]
  def get_font_size; end

  # @return[Float]
  def get_line_height; end

  # @return[Color]
  def get_text_color; end


  private

  attr_reader :font,
              :font_size,
              :line_height,
              :text_color
end

class UiSettings

  # @param[TextOptions] text_options
  def initialize(text_options)
    @text_options = text_options
  end

  # @return[TextOption]
  def get_text_style
    @text_options
  end
end

class UserInterface

  def display_message(message)
    message_box.render_text(message, ui_settings.get_text_style)
  end

  private

  attr_reader :message_box, :ui_settings
end


# 様々なデータが互いに関連しあい、個々のデータのみが必要なシナリオがない場合、カプセル化することは理にかなっている