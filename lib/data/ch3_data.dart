import 'package:flutter/material.dart';
import '../models/chapter.dart';
import '../models/content_block.dart';
import '../theme/app_theme.dart';

const chapter3 = Chapter(
  number: 3,
  title: '実験計画法',
  subtitle: '一元・二元配置・直交配列・田口メソッド',
  color: AppColors.ch3,
  icon: Icons.science,
  blocks: [
    TextBlock(text: '3.1 実験計画法の基本原理', style: BlockStyle.heading2),
    TextBlock(
      text: '実験計画法（DOE: Design of Experiments）は、実験の目的を最も効率的に達成するための実験の組み立て方・解析方法の体系である。R.A.フィッシャーが農業実験から発展させた。3つの基本原理「反復・無作為化・局所管理」の理解が1級では不可欠。',
      style: BlockStyle.body,
    ),
    PointBlock(
      title: '実験計画法の3原理',
      points: [
        '反復（Replication）：同じ実験条件で複数回繰り返す → 誤差分散の推定・検出力向上',
        '無作為化（Randomization）：実験順序・割り付けをランダムに → 系統誤差の排除',
        '局所管理（Local Control）：ブロック分けにより既知の変動要因を制御 → 誤差分散の低減',
      ],
    ),
    TextBlock(text: '3.2 一元配置実験（一因子実験）', style: BlockStyle.heading2),
    TextBlock(
      text: '一因子の水準の違いが特性値に与える影響を解析する。分散分析（ANOVA）により、因子の効果を誤差より大きいかどうか F 検定で判断する。',
      style: BlockStyle.body,
    ),
    FormulaBlock(
      label: '一元配置の分散分析（平方和の分解）',
      formula: 'ST = SA + Se\nST = ΣΣ(xᵢⱼ - x̄)²\nSA = Σnᵢ(x̄ᵢ - x̄)²\nSe = ΣΣ(xᵢⱼ - x̄ᵢ)²',
      explanation: 'ST：総平方和、SA：因子Aの平方和、Se：誤差平方和。自由度：φT=N-1, φA=a-1, φe=N-a（a:水準数, N:総実験数）',
    ),
    TableBlock(
      title: '一元配置 分散分析表',
      headers: ['要因', '平方和S', '自由度φ', '分散V', 'F₀', 'F(φA,φe;0.05)'],
      rows: [
        ['因子A', 'SA', 'a-1', 'VA=SA/φA', 'VA/Ve', '（表参照）'],
        ['誤差e', 'Se', 'N-a', 'Ve=Se/φe', '—', '—'],
        ['計', 'ST', 'N-1', '—', '—', '—'],
      ],
    ),
    ExampleBlock(
      id: '3-1',
      question: '3水準（A₁, A₂, A₃）各4反復の一元配置実験で以下の結果を得た。\nA₁: 12, 15, 11, 14（合計52）\nA₂: 18, 20, 17, 19（合計74）\nA₃: 10, 13, 12, 11（合計46）\n分散分析表を作成し、有意水準5%で因子Aの効果を検定せよ。F(2,9;0.05)=4.26',
      hint: '修正項 CT = T²/N��T：全デ���タ和、N：総データ数）を最初に計算する。',
      answer: 'T=52+74+46=172, N=12, CT=172²/12=2464.33\nST=(12²+15²+…+11²)-CT = 2584-2464.33 = 119.67\nSA=(52²+74²+46²)/4-CT = (2704+5476+2116)/4-2464.33 = 2574-2464.33 = 109.67\nSe=ST-SA=10.00\n分散分析表：VA=109.67/2=54.84, Ve=10.00/9=1.111\nF₀=54.84/1.111=49.4 > F(2,9;0.05)=4.26 → A は有意（**）',
      explanation: '修正項 CT の計算を忘れずに。F₀が棄却値を大幅に超えるので因子Aの効果は非常に大きい。水準間の差は多重比較（Tukey法など）で詳細検討。',
    ),
    TextBlock(text: '3.3 二元配置実験（繰り返しあり・なし）', style: BlockStyle.heading2),
    TextBlock(
      text: '2つの因子A・BとそれらのAの交互作用ABの効果を同時に解析する。繰り返しがある場合のみ交互作用を誤差から分離できる。繰り返しなしの場合は交互作用を誤差と混合して扱う（または交互作用なしと仮定）。',
      style: BlockStyle.body,
    ),
    FormulaBlock(
      label: '二元配置（繰り返しあり）��平方和分解',
      formula: 'ST = SA + SB + SAB + Se\nSAB = SR - SA - SB  （SR：主効果除去後の残差から）\nSe = ST - SR',
      explanation: 'a:因子Aの水準数、b:因子Bの水準数、r:繰り返し数、N=a×b×r',
    ),
    ChartBlock(
      chartType: ChartType.anovaTwoWay,
      config: {
        'title': '二元配置実験の交互作用プロット',
        'factor_a_levels': ['A₁', 'A₂', 'A₃'],
        'factor_b_levels': ['B₁', 'B₂'],
      },
    ),
    ExampleBlock(
      id: '3-2',
      question: '因子A（3水準）× 因子B（2水準）、繰り返し2回の二元配置実験（N=12）。SA=45.2, SB=18.6, ST=82.4 で、交互作用 SAB=8.1 であった。分散分析表を完成させ、有意水準5%で各要因の有意性を判定せよ。F(2,6;0.05)=5.14, F(1,6;0.05)=5.99',
      answer: 'Se=ST-SA-SB-SAB=82.4-45.2-18.6-8.1=10.5\nφA=2, φB=1, φAB=2, φe=6\nVA=22.6, VB=18.6, VAB=4.05, Ve=1.75\nFA=22.6/1.75=12.9 > 5.14 → A有意\nFB=18.6/1.75=10.6 > 5.99 → B有意\nFAB=4.05/1.75=2.31 < 5.14 → A×B交互作用は非有意',
      explanation: '交互作用が���有意なので、AとBの主効果は独立に解釈できる。交互作用が有意な場合は主効果の単純な解釈が困難になる。',
    ),
    TextBlock(text: '3.4 直交配列実験（直交表法）', style: BlockStyle.heading2),
    TextBlock(
      text: '多くの因子を少ない実験回数で効率よく調べるための手法。L8（2⁷）・L9（3⁴）・L18（2¹×3⁷）などの直交配列表を使用する。田口玄一がよ��体系化したパラメータ設計（ロバスト設計）への発展が1級頻出。',
      style: BlockStyle.body,
    ),
    TableBlock(
      title: 'L8直交配列表（2水準7因子）',
      headers: ['実験No.', '列1', '列2', '列3(1×2)', '列4', '列5(1×4)', '列6(2×4)', '列7'],
      rows: [
        ['1', '1', '1', '1', '1', '1', '1', '1'],
        ['2', '1', '1', '1', '2', '2', '2', '2'],
        ['3', '1', '2', '2', '1', '1', '2', '2'],
        ['4', '1', '2', '2', '2', '2', '1', '1'],
        ['5', '2', '1', '2', '1', '2', '1', '2'],
        ['6', '2', '1', '2', '2', '1', '2', '1'],
        ['7', '2', '2', '1', '1', '2', '2', '1'],
        ['8', '2', '2', '1', '2', '1', '1', '2'],
      ],
    ),
    PointBlock(
      title: 'SN比（信号対雑音比）：田口メソッドの核心',
      points: [
        '望目特性：SN比 = 10 × log(μ²/σ²) [dB]',
        '望大特性：SN比 = -10 × log(Σ(1/yᵢ²)/n)',
        '望小特性：SN比 = -10 × log(Σyᵢ²/n)',
        'SN比が大きいほど、ばらつきに強く安定した条件',
        'パラメータ設計：SN比最大の条件 × 感度調整で目標値に合わせる',
      ],
    ),
    ExampleBlock(
      id: '3-3',
      question: 'L9���交配列（3水準3因子）でA・B・Cを割り付け、SN比を求めた結果、A水準別SN比：A₁=18.2, A₂=20.5, A₃=17.8。最適水準はどれか。また SN比の改善量（A₁→A₂望目）は何dBか。',
      answer: '最適水準：A₂（SN比最大=20.5dB）\n改善量：20.5-18.2=2.3dB\n実測ばらつきへの折算：10^(2.3/10)=1.70倍の改善（分散比）',
      explanation: 'SN比は対数スケールなので、差が改善量。3dBは約2倍の改善に相当する。実験では各水準のSN比を���較し、最大を最適条件とする。',
    ),
    TextBlock(text: '3.5 応答曲面法（RSM）', style: BlockStyle.heading2),
    TextBlock(
      text: '応答曲面法（RSM: Response Surface Methodology）は、実験領域内の最適点を探索する手法。1次モデルで方向を定め、最急上昇法で移動し、最適値付近で2次モデル（中心複合計��・Box-Behnken計画）を当てはめ、最適点を数値的に求める。',
      style: BlockStyle.body,
    ),
    PointBlock(
      title: '実験計画法まとめ（1級頻出）',
      points: [
        '一元配置：F₀=VA/Ve、有意なら水準効果あり',
        '二元配置（繰り返しあり）：交互作用を独立推定できる',
        '直交配列：多因子を少ない試験で効率的に解析',
        '田口メソッド：SN比でばらつきへの強さ（ロバスト性）を評価',
        'RSM：最適点の探索・プロセス最適化に活用',
        '分割実験：実験の難しい因子（全体区・部分区）を分けて計画',
      ],
    ),
  ],
);
