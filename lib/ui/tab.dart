import 'package:flutter/material.dart';

class TabUI extends StatefulWidget {
  final List<Widget>? tabs;
  final List<Widget>? children;

  TabUI({
    Key? key,
    @required this.tabs,
    @required this.children,
  }) : super(key: key);

  @override
  _TabUIState createState() => _TabUIState();
}

enum ChangeBodyDirection {
  Left,
  Right,
}

class _TabUIState extends State<TabUI> with TickerProviderStateMixin {
  /// アクティブインジケーターの画面左側からのオフセット
  double _indicatorOffset = 0;

  /// アクティブインジケーターの幅
  double _indicatorWidth = 0;

  void _calculateIndicatorMeta() {
    final size = MediaQuery.of(context).size;
    _indicatorWidth = size.width / widget.tabs!.length;
  }

  /// 現在選択されているタブのインデックス
  int _currentTabIndex = 0;

  /// アクティブインジケーターのアニメーション開始地点
  double _indicatorStartPosition = 0;

  /// アクティブインジケーターのアニメーション終了地点
  double _indicatorEndPosition = 0;

  /// アクティブインジケーターのアニメーションコントローラー
  AnimationController? _indicatorAnimationController;

  /// アクティブインジケーターのアニメーションカーブ
  Animation<double>? _indicatorAnimation;

  /// コンテンツ部分のアニメーションコントローラー
  AnimationController? _tabBodyAnimationController;

  /// コンテンツ部分のアニメーションカーブ
  Animation<double>? _tabBodyAnimation;

  /// コンテンツのアニメーション開始地点
  Offset? _tabBodyOffsetStart;

  /// コンテンツのアニメーション終了地点
  Offset? _tabBodyOffsetEnd;

  /// アニメーション中のコンテンツの位置
  Offset? _tabBodyOffset = const Offset(0, 0);

  /// コンテンツ部分に表示するWidget
  Widget? _tabBody;

  @override
  void initState() {
    /// `AnimationController`を初期化します。
    _indicatorAnimationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this)

      /// `AnimationController.forward()`がコールされた際に実行されるリスナーを設定します。
      ..addListener(() => setState(() {
            /// 設定されたアクティブインジケーターのアニメーション終了地点、開始地点から、移動距離を求めます。
            final distance = _indicatorEndPosition - _indicatorStartPosition;

            /// `Animation.value`は`AnimationController`の現在の時間位置(t)に対応するアニメーションカーブの値(x)です。
            /// 上記で算出した移動距離とアニメーションカーブを掛け合わせることで、なめらかにオフセットを変化させます。
            /// 参考: https://api.flutter.dev/flutter/animation/Curves/fastOutSlowIn-constant.html
            _indicatorOffset =
                _indicatorStartPosition + distance * _indicatorAnimation!.value;
          }));

    /// `AnimationController`の状態変化に伴うアニメーションカーブを作成します。
    _indicatorAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: _indicatorAnimationController!,
            curve: Curves.fastOutSlowIn));

    /// コンテンツ部分のアニメーションコントローラーを初期化
    _tabBodyAnimationController = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this)

      /// `AnimationController.forward()`がコールされた際に実行されるリスナーを設定します。
      ..addListener(() => setState(() {
            /// タブUIの時と同様、設定された開始地点、終了地点から
            /// コンテンツ部分のオフセットをなめらかに変化させます。
            _tabBodyOffset = Offset.lerp(_tabBodyOffsetStart, _tabBodyOffsetEnd,
                _tabBodyAnimation!.value);
          }));

    /// `AnimationController`の状態変化に伴うアニメーションカーブを作成します。
    _tabBodyAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: _tabBodyAnimationController!, curve: Curves.fastOutSlowIn));

    _changeTabIndex(0);

    super.initState();
  }

  @override
  void dispose() {
    _indicatorAnimationController!.dispose();
    _tabBodyAnimationController!.dispose();

    super.dispose();
  }

  void _changeTabIndex(int index) {
    final ChangeBodyDirection direction = _currentTabIndex <= index
        ? ChangeBodyDirection.Right
        : ChangeBodyDirection.Left;

    /// アクティブインジケーターのアニメーション開始地点を計算します。
    _indicatorStartPosition = _currentTabIndex * _indicatorWidth;

    /// 現在選択されているタブのインデックスを保存します。
    _currentTabIndex = index;

    /// アクティブインジケーターのアニメーション終了地点を計算します。
    _indicatorEndPosition = _currentTabIndex * _indicatorWidth;

    /// アニメーションを初期フレームから再生します。
    _indicatorAnimationController!.forward(from: 0.0);

    /// コンテンツ部分を変更します。
    _changeBody(direction);
  }

  void _changeBody(ChangeBodyDirection direction) {
    _tabBodyOffsetEnd = Offset(0, 0);

    switch (direction) {
      case ChangeBodyDirection.Right:
        _tabBodyOffsetStart = Offset(-100, 0);
        break;
      case ChangeBodyDirection.Left:
        _tabBodyOffsetStart = Offset(100, 0);
        break;
    }

    /// スライドアウトアニメーションを再生します。
    _tabBodyAnimationController!.reverse(from: 1.0).then((_) {
      switch (direction) {
        case ChangeBodyDirection.Right:
          _tabBodyOffsetStart = Offset(100, 0);
          break;
        case ChangeBodyDirection.Left:
          _tabBodyOffsetStart = Offset(-100, 0);
          break;
      }

      /// スライドインアニメーションを再生します。
      _tabBodyAnimationController!.forward(from: 0.0);

      setState(() {
        /// コンテンツの内容を新しいものに差し替えます。
        _tabBody = widget.children![_currentTabIndex];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _calculateIndicatorMeta();
    return _buildChild();
  }

  Widget _buildChild() {
    return Stack(
      children: <Widget>[
        _buildMenus(),
        _buildInactiveIndicator(),
        _buildActiveIndicator(),
        _buildBody(),
      ],
    );
  }

  Widget _buildMenus() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 50,
        width: double.infinity,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: _buildTabs(),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildTabs() {
    final tabs = <Widget>[];
    widget.tabs!.asMap().forEach((index, tab) {
      tabs.add(Expanded(
        child: GestureDetector(
          child: Container(
            color: Colors.transparent,
            child: tab,
          ),
          onTap: () {
            /// タブがタップされた際にタブ切り替処理を実行します。
            _changeTabIndex(index);
          },
        ),
      ));
    });

    return tabs;
  }

  Widget _buildInactiveIndicator() {
    final List<Widget> indicators = [];

    widget.tabs!.forEach((_) {
      indicators.add(
        Expanded(
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Container(
                height: 3,
                decoration: BoxDecoration(
                  color: Colors.black38,
                  borderRadius: BorderRadius.circular(2.5),
                ),
              )),
        ),
      );
    });

    return Positioned(
      top: 46,
      left: 0,
      right: 0,
      child: Row(
        children: indicators,
      ),
    );
  }

  Widget _buildActiveIndicator() {
    final double horizontalPadding = 2;

    return Positioned(
      top: 46,
      left: _indicatorOffset,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: Container(
          height: 3,
          width: _indicatorWidth - (horizontalPadding * 2),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(2.5),
              boxShadow: [
                BoxShadow(
                    color: Colors.black12,
                    blurRadius: 2,
                    spreadRadius: 0,
                    offset: const Offset(0, 1)),
              ]),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Positioned(
      top: 50,
      left: 0,
      right: 0,
      bottom: 0,
      child: FadeTransition(
        opacity: _tabBodyAnimation!,
        child: Transform(
          transform: Matrix4.translationValues(
              _tabBodyOffset!.dx, _tabBodyOffset!.dy, 0.0),
          child: Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Container(
              color: Colors.transparent,
              child: _tabBody,
            ),
          ),
        ),
      ),
    );
  }
}
