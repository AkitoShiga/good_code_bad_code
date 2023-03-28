# 巨大なクラス
class TextSummarizer
  IMPORTANCE_THRESHOLD = 'なにかの定数'

  # @params[String] text
  # @return[String] サマったテキスト
  # @param [Object] text
  def summarize_text(text)
    # 文章を段落に分割
    # 文章の文字列の重要度のスコア計算
    split_into_paragraphs(text)
      .filter{ |paragraph| calclate_importance(paragraph) >= IMPORTANCE_THRESHOLD }
      .join("\n\n")
  end

  private

  # @params[String] text
  # @return[Float]
  def calculate_importance(text)
    nouns = extract_important_nouns(paragraph)
    verbs = extract_important_verbs(paragraph)
    adjectives = extract_important_adjectives(paragraph)

    # 複雑な方程式
    imprtane_score
  end

  # @params[String] text
  # @return[Array]
  def extract_important_nouns(text)
  end

  # @params[String] text
  # @return[Array]
  def extract_important_verbs(text)
  end

  # @params[String] text
  # @return[Array]
  def extract_important_adjectives(text)
  end

  # @params[String] text
  # @return[Array]
  def split_paragraphs(text)
    paragraphs = [];
    start = detect_paragraph_start_offset(text, 0)

    while start != nil do
      break if detect_paragraph_end_offset(text, start).nil?
      paragraphs.add(text.sub_string(start, finish))
      start = detect_paragraph_start_offset(text, finish)
    end
    paragraphs
  end


  # @return[int]
  def detect_paragraph_start_offset(text, from_offset)
  end
end

=begin
コードが思ったほど読みやすくない
  * コードの分割とコードの抽出、コードのスコア計算といったたくさんの概念が入り乱れている
コードがモジュール化されていない
  * コードがモジュール化されていればスコアの計算アルゴリズムを変更することもできるのに
コードの再利用性が低い
  * split_into_paragraphsとか再利用できそうなのに
  * もしこのままパブリックにすると周りのクラスがこの関数に依存し始め、text_summarizerとしての機能の変更がしづらくなる
コードが汎用化されていない
  * 文章入力のみを対象にしている
  * 将来HTMLもサマりたいとなった場合に、対応できない
  * コードがモジュール化されていれば文章を段落に分割する機能とHTMLを段落に分ける機能を交換できる
適切にテストしにくい

多くの概念を扱いすぎている
=end

# 解決策 DIを用いる

class TextSummarizer

  # @params[ParagraphFinder] paragraph_finder
  # @params[ImportanceScorer] importance_scorer
  def initialize(paragraph_finder, importance_scorer)
    @paragraph_finder = paragraph_finder
    @importance_sorer = importance_scorer
  end

  # @return[TextSummarizer]
  def self.create_default
    # 呼び出し元からクラスのデフォルトのインスタンスを生成するのに便利な性的ファクトリー関数
    TextSummarizer.new(ParagraphFinder.new, TextImportanceScorer.new)
  end
end

class ParagraphFinder

  # @params[String] text
  # @return[String] サマったテキスト
  def summarize_text(text)
    # 文章を段落に分割
    # 文章の文字列の重要度のスコア計算
    pragraph_finder.find(text)
      .filter{ |paragraph| importance_socorer.is_important(paragraph) }
      .join("\n\n")
  end
end

class ParagraphFinder
  # @params[String] text
  # @return[Array]
  def find
    paragraphs = []
    start = detet_paragraph_start_offset(text, 0)

    while start != nil do
      break if detct_paragraph_end_offset(text, start).nil?

      paragraphs.add(text.sub_string(start, finish))
      start = detect_pargraph_start_offset(text, finish)
    end
    paragraphs
  end

  # @return[int]
  def detect_paragraph_start_offset(text, from_offset)
  end

  # @return[int]
  def detect_paragraph_end_offset(text, from_offset)
  end
end

class TextImportanceScorer
  IMPORTANCE_THRESHOLD = 'なにかの定数'

  # @params[String] text
  # @return[Boolean]
  def is_important(string)
    calucate_importance(text) >= IMPORTANCE_THRESHOLD
  end

  private

  # @params[String]
  # @return[Float]
  def calculate_importance(text)
    nouns = extract_important_nouns(text)
    verbs = extract_important_verbs(text)
    adjectives = extract_important_adjectives(text)

    # 複雑な方程式

    importance_score
  end

  private
  # @params[String] text
  # @return[Array]
  def extract_important_nouns(text)
  end

  # @params[String] text
  # @return[Array]
  def extract_important_verbs(text)
  end

  # @params[String] text
  # @return[Array]
  def extract_important_adjectives(text)
  end

end


