import 'package:flutter/material.dart';
import '../models/chapter.dart';
import '../models/content_block.dart';
import '../theme/app_theme.dart';

const chapter7 = Chapter(
  number: 7,
  title: 'プロセス管理・工程能力（上級）',
  subtitle: '管理図・工程能力指数・CUSUM・EWMA',
  color: AppColors.ch7,
  icon: Icons.show_chart,
  blocks: [
    TextBlock(text: '7.1 管理図の理論と種類', style: BlockStyle.heading2),
    TextBlock(
      text: 'シューハートの管理図は、工程が統計的管理状態にあるかどうかを監視するツールである。1級では管理限界の導出・管理図の設計・ARL（平均ラン長）・CUSUM・EWMA管理図まで要求される。',
      style: BlockStyle.body,
    ),
    FormulaBlock(
      label: '管理図の管理限界（3σ法）',
      formula: 'UCL = μ + 3σ/√n\nCL  = μ\nLCL = μ - 3σ/√n',
      explanation: '管理限界は母数既知（Phase I）または推定値を使用（Phase II）。3σ法は α=0.0027（両側）の警報率に相当。',
    ),
    ChartBlock(
      chartType: ChartType.controlChartAdvanced,
      config: {'title': 'X̄-R管理図とCUSUM管理図'},
    ),
    PointBlock(
      title: '管理図の種類と用途',
      points: [
        'X̄-R管理図：計量値・小サンプル（n=2〜10）の工程管理（最も普及）',
        'X̄-s管理図：n≥10 の場合、s（標準偏差）の方が R より効率的',
        'X-Rs管理図（I-MR）：n=1 の個別値管理（化学プロセス等）',
        'p管理図：不良率管理（サンプルサイズ変動対応可）',
        'np管理図：不良数管理（サンプルサイズ一定）',
        'c管理図：欠点数管理（ポアソン分布）',
        'u管理図：単位あたり欠点数（サンプルサイズ変動対応）',
      ],
    ),
    TextBlock(text: '7.2 ARL（平均ラン長）と管理図の検出力', style: BlockStyle.heading2),
    TextBlock(
      text: 'ARL（Average Run Length）は、工程変化を検出するまでの平均サンプル数。管理状態では ARL₀=370（3σ管理図）、シフトが大きいほど ARL₁は小さくなる（早く検出）。',
      style: BlockStyle.body,
    ),
    FormulaBlock(
      label: 'ARLの計算',
      formula: 'ARL₀ = 1/α（管理状態での平均ラン長）\n3σ管理図：α=0.0027 → ARL₀ = 1/0.0027 ≈ 370\nARL₁ = 1/（検出確率）（異常状態）',
      explanation: 'ARL₀が大きいほど誤警報が少ない。ARL₁が小さいほど異常を早く検出。この2つはトレードオフ。',
    ),
    ExampleBlock(
      id: '7-1',
      question: '3σ管理図（n=5）で工程平均が 1.5σ シフトしたとき、1サンプルで検出できる確率（検出力）を求めよ。シフト後 μ+3σ/√n = μ+3×1/√5 = 元 UCL に相当する上側確率を z 変換で計算。z = (UCL - 新μ)/(σ/√n) = (3-1.5×√5)/1 = 3-3.354 = -0.354 → P(z>-0.354) とする。Φ(0.354)=0.638',
      answer: 'z = (3/√n の管理限界 - シフト量) を変換\nシフト = 1.5σ, 管理限界 = 3σ/√5 = 1.342σ\nz = (1.342 - 1.5×√5) / 1 = ... 実際には\nP = 1 - Φ(3 - 1.5√5) = 1 - Φ(3-3.354) = 1 - Φ(-0.354) = Φ(0.354) = 0.638\n検出確率 ≈ 63.8%\nARL₁ = 1/0.638 ≈ 1.57（約2サンプルで検出）',
      explanation: 'シフトが大きいほど検出確率が高く ARL₁ が小さい。n を大きくしても検出力が向上する。',
    ),
    TextBlock(text: '7.3 CUSUM管理図（累積和管理図）', style: BlockStyle.heading2),
    TextBlock(
      text: 'CUSUM（Cumulative Sum）管理図は、工程平均の小さなシフトを検出するのに優れた管理図。シューハート管理図では見逃しやすい 1〜2σ のシフトを早期に発見できる。V-mask または上下 CUSUM の2形式がある。',
      style: BlockStyle.body,
    ),
    FormulaBlock(
      label: 'CUSUM統計量の計算',
      formula: 'Cᵢ⁺ = max[0, Cᵢ₋₁⁺ + (xᵢ - μ₀ - k)]\nCᵢ⁻ = max[0, Cᵢ₋₁⁻ - (xᵢ - μ₀ + k)]\n警報：Cᵢ⁺ > h または Cᵢ⁻ > h',
      explanation: 'k：参照値（スラック値）= δ/2（検出したいシフト量の半分）。h：決定限界（通常 h=4〜5σ）。',
    ),
    TextBlock(text: '7.4 EWMA管理図', style: BlockStyle.heading2),
    TextBlock(
      text: 'EWMA（Exponentially Weighted Moving Average）管理図は、過去の観測値に指数的に減衰する重みをかけた移動平均で工程を監視する。λ（平滑化係数）が小さいほど過去データを重視し、小さなシフト検出に有効。',
      style: BlockStyle.body,
    ),
    FormulaBlock(
      label: 'EWMA統計量と管理限界',
      formula: 'Zᵢ = λxᵢ + (1-λ)Zᵢ₋₁\nUCL/LCL = μ₀ ± L×σ×√[λ/(2-λ)×(1-(1-λ)^(2i))]',
      explanation: 'λ：平滑化係数（0<λ≤1）、L：管理幅係数（通常 L=3）。λ=1のとき Shewhart管理図と同等。',
    ),
    TextBlock(text: '7.5 工程能力指数（上級）', style: BlockStyle.heading2),
    TextBlock(
      text: '工程能力指数は工程の品質能力を定量化する指標。1級では Cp・Cpk に加え、非正規工程の能力指数（パーセンタイル法・変換法）や長期・短期能力（Pp・Ppk）の区別が重要。',
      style: BlockStyle.body,
    ),
    FormulaBlock(
      label: '工程能力指数（Cp・Cpk）',
      formula: 'Cp = (USL - LSL) / 6σ\nCpk = min[(USL-μ)/3σ, (μ-LSL)/3σ]\nCpu = (USL-μ)/3σ, Cpl = (μ-LSL)/3σ',
      explanation: 'Cp は工程のばらつきのみ評価（中心が規格中心と仮定）。Cpk は偏り込みで評価。Cpk<Cp のとき偏りあり。',
    ),
    TableBlock(
      title: '工程能力の判定基準',
      headers: ['Cpk値', '不良率（両側正規）', '判定', '対応'],
      rows: [
        ['≥ 1.67', '< 0.0001%', '非常に優秀', '余裕あり・コスト低減検討'],
        ['1.33〜1.67', '< 0.006%', '十分', '現状維持'],
        ['1.00〜1.33', '< 0.27%', 'やや不足', '改善推奨'],
        ['< 1.00', '> 0.27%', '不足', '早急に改善'],
      ],
    ),
    FormulaBlock(
      label: '長期能力指数（Pp・Ppk）',
      formula: 'Pp = (USL-LSL) / 6s（長期標準偏差 s を使用）\nPpk = min[(USL-x̄)/3s, (x̄-LSL)/3s]\nCpk/Ppk の比 ≈ 短期/長期能力比',
      explanation: 'Cp/Cpk は管理図の σ̂（短期変動）を使用。Pp/Ppk は全データの s を使用（長期変動込）。通常 Cpk > Ppk。',
    ),
    ExampleBlock(
      id: '7-2',
      question: '規格：50±5（LSL=45, USL=55）、工程：x̄=51.5, σ=1.5 のとき、Cp と Cpk を求め工程能力を評価せよ。',
      answer: 'Cp = (55-45)/(6×1.5) = 10/9 = 1.11\nCpu = (55-51.5)/(3×1.5) = 3.5/4.5 = 0.778\nCpl = (51.5-45)/(3×1.5) = 6.5/4.5 = 1.444\nCpk = min(0.778, 1.444) = 0.778\n評価：Cp=1.11（ばらつき自体は問題なし）だが Cpk=0.778（< 1.0）→工程が上限側に偏り、不足',
      explanation: 'Cp と Cpk の乖離が大きいほど工程が偏っている。この場合は工程平均を規格中心（50）へ移動する調整が最優先。',
    ),
    PointBlock(
      title: 'プロセス管理まとめ（1級必須）',
      points: [
        'ARL₀（管理状態）≈ 370（3σ管理図）：誤警報は370サンプルに1回',
        'CUSUM・EWMA：小さいシフト（1〜2σ）の早期検出に有効',
        'Cp = 1.33 以上が日本の実務標準目標値',
        'Cpk < 1.0 → 不良が発生している（改善必須）',
        '長期能力 Ppk < 短期能力 Cpk → 工程ドリフト・シフトが発生している証拠',
        '非正規工程の能力指数は JIS Z 8101 でパーセンタイル法が規定',
      ],
    ),
  ],
);
