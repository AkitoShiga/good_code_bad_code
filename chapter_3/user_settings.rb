class UserSettings
  def initialize; end

  # この関数を使って設定が正しく読み込まれるまで、他の関数をよばない事
  # 正しく設定が読み込まれたらtrueを返す
  # @params[File] location
  # @return[Boolean] 設定が正しく読み込まれたか?
  def load_settings; end

  # init()は、他の関数よりも先に呼ばなければならない
  # ただし、先にload_settings()を呼び出して設定を読み込むこと
  def init; end

  # ユーザーが選択したUIの色を返す、もしくはユーザーが色を選択していない場合や
  # 設定を読み込んでいない、あるいは初期化していない場合はnullを返す
  def get_ui_color; end
  #  nil の戻り値は下記が考えられる
  #    1. ユーザーが色を選択していない
  #    2. クラスを完全に初期化していない
end

# このコードの明確な部分
#   1. get_ui_colorはユーザーの選択したUIの色返すが、nilを返す場合もある。コメントを読まなければ意味は明確にはならない
#   2. load_settingsはファイルを受け取り真偽値を返す
# 不明瞭な部分
#  1. 一連の呼び出しを実施する必要がある
#   load_settings() -> trueならinit()で暮らすが使えるようになる
#   load_settings() -> falseだったら他のメソッドは呼び出すべきでない
#   get_ui_color()はnilを返すのに2つの理由がある
#     ユーザーが色を選択していないか
#     クラスをまだセットアップしていないか

# 潜在的にバグを生むコード
DEFAULT_UI_COLOR = '呼び出し側で定義されたデフォルトの色'

# @params[UserSettings] user_settings
def set_ui_color(user_settings)
  chosen_color = user_settings.get_ui_color
  if chosen_color.nil?
    # ユーザーが色を選択していない場合を想定しているが、色を選択したがuser_settingsが不正だった場合も起こり得る
    ui.set_color(DEFAULT_UI_COLOR)
  else
    ui.set_color(chosen_color)
  end
end
