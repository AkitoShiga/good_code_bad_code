class RoadMap

  protected

  # @return[Array<Load>]
  def get_roads
    raise NotImplementedError
  end

  # @return[Array<Junction>]
  def  get_junctions
    raise NotImplementedError
  end
end

class Load; end
class Junction; end


class NorthAmericaRoadMap < RoadMap # RoadMapの潜在的な実装の一つ

  # @param[Hash]
  def initialize(*args)
    @roads = args.fetch(:roads, *Load.new).clone
    @junctions = args.fetch(:junctions, *Junction.new).clone
    # クラスがサーバーに接続して最新バージョンのマップを取得するか
    @use_online_version = args.fetch(:use_online_version, false)
    # 一年のうち特定の期間のみに通行出来る道路をマップにふくめるか
    @include_seasonal_roads = args.fetch(:include_seasonal_roads, false)
  end

  # @return[Array<Load>]
  def get_roads
    @roads
  end

  # @return[Array<Junction>]
  def  get_junctions
    @junctions
  end
end

class RoutePlanner

  def initialize
    # NorthAmericaRoadMapに依存している
    # RoadMapインターフェースの特定の実装のみへの依存関係を加えると、コードを別の実装で再構成できなくなる
    # ここでNewするということはNorthAmericaRoadMapの引数をここで用意しないとインスタンスを構築できないということになる
    # つまりNorthAmericaRoadMap固有の概念を処理しなければいけないということになる
    @road_map = NorthAmericaRoadMap.new
  end

  # @param[Numeric]
  # @param[Numeric]
  # @return[Route]
  def plan_route(start_point, end_point); end
end

# NorthAmericaRoadMapのプロパティ追加後

class RoutePlanner

  USE_ONLINE_MAP = true.freeze
  INCLUDE_SEASONAL_ROADS = false.freeze
  private_constant(:USE_ONLINE_MAP, :INCLUDE_SEASONAL_ROADS)

  def initialize(road_map)
    # 依存性が強くなってしまう
    @road_map = NorthAmericaRoadMap.new({ use_online_version: USE_ONLINE_MAP,
                                          include_seasonal_roads: INCLUDE_SEASONAL_ROADS })
  end

  # @param[Numeric]
  # @param[Numeric]
  # @return[Route]
  def plan_route(start_point, end_point); end
end

# 解決策DIの注入
class RoadPlanner

  def initialize(road_map)
    @road_map = road_map
  end

  # @param[Numeric]
  # @param[Numeric]
  # @return[Route]
  def plan_route(start_point, end_point); end

  private
  attr_reader :road_map
end

class EuropeRoadMap; end

europe_route_planner = RoutePlanner.new(EuropeRoadMap.new)
north_america_route_planner = RoutePlanner.new(NorthAmericaRoadMap.new(true, false))

# ただし、RoutePlannerクラスの構築が複雑になる
# ファクトリークラスを仕様する
class RoutePlannerFactory
  class << self

    # @return[RoutePlanner]
    def create_europe_route_planner
      RoutePlanner.new(EuropeRoadMap)
    end

    # @return[RoutePlanner]
    def create_default_north_america_route_planner
      RoutePlanner.new(NorthAmericaRoadMap.new(true, false))
    end
  end
end

# 常にDIの必要性を意識的に検討する
# DIが必要だとわかっている場合はDIが不可能なコードを書くことを避ける

# RoutePlannerと道路地図の例を実装する別の方法

# アンチパターン静的メソッド
# NorthAmericaRoadMapのget_roadsとget_junctionsを静的メソッドにする
class NorthAmericaRoadMap
  #######
  # 処理 #
  #######
  class << self
    def get_roads; end
    def get_junctions; end
  end
end

class RoutePlanner
  def initialize
    # DIによって依存性を解決することができたが、静的メソッドに依存することによって不可能となった => 静的粘着
    @roads = NorthAmericaRoadMap.get_roads
    @junctions = NorthAmericaRoadMap.get_junctions
  end
end
