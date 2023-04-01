=begin
要件
 1.ファイルからデータを読み取る必要がある
 2.ファイルのカンマ区切りの内容を個々の文字列に分割する必要がある
 3.これらの各文字列を整数に解析する必要がある

最初の2つはCsvFileHandlerで解決出来る
CsvFileHandlerはFileValueReaderとFileValueWriteを実装している
FileValueReaderの機能のみが必要だが継承しているためにそのような形でインターフェースに依存できない
=end


class FileValueReader
  # @return[String]
  def get_next_value
    raise NotImplementedError
  end

  def close
    raise NotImplementedError
  end
end

class FileValueWriter

  # @param[String] value
  def write_value(value)
    raise NotImplementedError
  end

  def close
    raise NotImplementedError
  end
end

# カンマ区切りの値を含むファイルを読み書きするためのユーティリティ
class CsvFileHandler < FileValueReader, FileValueWriter

  # @param[File] file
  def initialize(file)
    @file = file
  end

  def get_next_value; end
  def write_value(value); end
  def close; end
end

class InitFileReader < CsvFileHandler
  def initialize(file)
    super(file)
  end

  def get_next_int
    get_next_value&.to_d # スーパークラスの実装を呼び出す
  end
end

# 継承はスーパークラスのすべてを継承するため、想定よりも多くの機能を公開してしまう可能性がある
# 抽象化レイヤーの汚染と実装の漏洩につながる

# InitFileReaderのクライアントがget_next_valueやwrite_valueを使用してしまった場合、
# 今後InitFileReaderクラスの実装を変更することが非常にむずかしくなる

# 要件が追加になった => セミコロン区切りのファイルも処理する
# セミコロン区切りのファイルから整数を読み取るのにSemicolonFileHandlerを使用する

# セミコロンで区切られた値を含むファイルを読み書きするためのユーティリティ
class SemicolonFileHandler < FileValueReader, FileValueWriter
  # @param[File] file
  def initialize(file)
    @file = file
  end
  def get_next_value;end
  def write_value(value); end
  def close; end
end

# CsvFileHandlerの代わりにSemicolonFileHandlerを利用することは、既存の機能が壊れるためできない
# こうなったらあたらしいInitFileReaderを作るしかない。 => SemicolonInitFileReader
# InitFileReaderのほぼ複製 => メンテナンスのオーバーヘッドとバグ発生の可能性を増加させるため、おすすめできない

  class SemicolonInitFileReader < SemicolonFileHandler
    def initialize(file)
      super(file)
    end

    def get_next_int
      get_next_value&.to_d # スーパークラスの実装を呼び出す
    end
  end


# コンポジション
class IntFileReader

  # @param[FileValueReader]
  def initialize(value_reader)
    @value_reader = value_reader
  end

  # @return[Integer]
  def get_next_int
    next_value = value_reader.get_next_value
    next_value.to_d
  end

  def close
    value_reader.close
  end

  private

  attr_reader :value_reader
end
