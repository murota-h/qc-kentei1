import 'package:flutter/material.dart';
import '../models/chapter.dart';
import '../models/content_block.dart';
import '../theme/app_theme.dart';

const chapter2 = Chapter(
  number: 2,
  title: '統計的方法の基礎（上級）',
  subtitle: 'F分布・推定・検定・相関回帰',
  color: AppColors.ch2,
  icon: Icons.functions,
  blocks: [
    TextBlock(text: '2.1 確率分布の上級理論', style: BlockStyle.heading2),
    TextBlock(
      text: '1級ではF分布・二項分布・ポアソン分布・指数分布・ワイブル分布まで扱う。各分布の導出・相互関係・期待値・分散の計算が必要。',
      style: BlockStyle.body,
    ),
    FormulaBlock(
      label: 'F分布の定義',
      formula: 'F = (χ²₁/φ₁) / (χ²₂/φ₂)',
      explanation: 'χ²₁：自由度φ₁のカイ二乗変数、χ²₂：自由度φ₂のカイ二乗変数。2つの独立��カイ二乗分布の比から導出される。',
    ),
    ChartBlock(
      chartType: ChartType.fDistribution,
      config: {'title': 'F分布（自由度 φ₁, φ₂）'},
    ),
    PointBlock(
      title: '主要確率分布の関係（1級必須）',
      points: [
        '正規分布 N(0,1) の2乗 → χ²(1)（自由度1のカイ二乗）',
        'χ²(φ)/φ と独立な χ²(φ₂)/φ₂ の比 → F(φ₁, φ₂)',
        'N(0,1)/√(χ²(φ)/φ) → t(φ)（t分布）',
        't(φ)² = F(1, φ)（t分布とF分布の関係）',
        '指数分布はワイブル分布（m=1）の特殊ケース',
      ],
    ),
    ChartBlock(
      chartType: ChartType.chiSquare,
      config: {'title': 'カイ二乗分布（自由度 ν）'},
    ),
    TextBlock(text: '2.2 点推定・区間推定（上級）', style: BlockStyle.heading2),
    TextBlock(
      text: '点推定では推定���の「不偏性・一致性・有効性・十分性」の4性質を理解する必要がある。区間推定では比平均・比分散・比比率の信頼区間に加え、2標本問題（差の推定）まで扱う。',
      style: BlockStyle.body,
    ),
    FormulaBlock(
      label: '2標本の比平均差の信頼区間（等分散の場合）',
      formula: '(x̄₁ - x̄₂) ± t(φ, α/2) × Sp × √(1/n₁ + 1/n₂)',
      explanation: 'Sp：プールした標準偏差 = √{(S₁+S₂)/(φ₁+φ₂)}, φ = n₁+n₂-2',
    ),
    FormulaBlock(
      label: '推定量の不偏性',
      formula: 'E[θ̂] = θ',
      explanation: '推定量の期待値が真の母数に一致するとき、θ̂は不偏推定量という。標本分散 S² = Σ(xᵢ-x̄)²/(n-1) は σ² の不偏推定量。',
    ),
    ExampleBlock(
      id: '2-1',
      question: 'A工場（n₁=16, x̄₁=50.2, S₁=8.4）とB工場（n₂=21, x̄₂=47.8, S₂=10.2）の製品強度について、等分散を仮定して比平均差の95%信頼区間を求めよ。ただし t(35, 0.025)=2.030 とする。',
      hint: 'プール分散 Sp² = (S₁+S₂)/(φ₁+φ₂) で計算。S₁は Σ(xᵢ-x̄)²（偏差平方和）であることに注意。',
      answer: 'φ₁=15, φ₂=20\nSp²=(8.4×15+10.2×20)/35 = (126+204)/35 = 9.429, Sp=3.071\n(50.2-47.8) ± 2.030 × 3.071 × √(1/16+1/21)\n= 2.4 ± 2.030 × 3.071 × 0.333\n= 2.4 ± 2.076\n→ 95%信頼区間: [0.324, 4.476]',
      explanation: '等分散の2標本t検定は頻出。S₁が偏差平方和（Σ(xᵢ-x̄)²）か、不偏分散（÷n-1）かを問題文で必ず確認すること。',
    ),
    TextBlock(text: '2.3 仮説検定の理論（上��）', style: BlockStyle.heading2),
    TextBlock(
      text: '1級では���出力（1-β）・OC曲線・第1種・第2種の誤りの関係を深く理解する必要がある。また検定の多重性（ボンフェローニ補正など）も扱う。',
      style: BlockStyle.body,
    ),
    TableBlock(
      title: '第1種・第2種誤りと検出力',
      headers: ['', 'H₀が真', 'H₀が偽'],
      rows: [
        ['H₀を棄却', '第1種誤り（α）', '正解（検出力 1-β）'],
        ['H₀を採択', '正解（1-α）', '第2種誤り（β）'],
      ],
    ),
    FormulaBlock(
      label: '検出力と必要サンプルサイズ',
      formula: 'n ≥ (z_α/2 + z_β)² × σ² / δ²',
      explanation: 'δ：検出したい差の大きさ、z_α/2：上側α/2点、z_β：上側β点。片側検定では z_α を使用。',
    ),
    ExampleBlock(
      id: '2-2',
      question: '比平均の差 δ=2.0 を検出したい。σ=5.0 とする。α=0.05（両側）、β=0.10（検出力90%）のとき必要なサンプルサイズ n を求めよ。z₀.₀₂₅=1.960, z₀.₁₀=1.282 とする。',
      answer: 'n ≥ (1.960+1.282)² × 5² / 2²\n= (3.242)² × 25 / 4\n= 10.511 × 25 / 4\n= 65.7\n→ n = 66（切り上げ）',
      explanation: 'サンプルサイズ計算は実務で重要。δ（検出すべき差）が小さいほど��またσが大きいほど n が���大する。',
    ),
    ChartBlock(
      chartType: ChartType.ocCurveAdvanced,
      config: {'title': 'OC曲線（検出力曲線）'},
    ),
    TextBlock(text: '2.4 相関分析・回帰（上級）', style: BlockStyle.heading2),
    TextBlock(
      text: '1級では相関係数の検定・信頼区間（フィッシャーのz変換）、回帰係数の信頼区間、予測区���と信頼区間の違いまで要求される。',
      style: BlockStyle.body,
    ),
    FormulaBlock(
      label: 'フィッシャーのz変換（相関係数の検定）',
      formula: 'z = (1/2) × ln[(1+r)/(1-r)] ~ N(ρz, 1/(n-3))',
      explanation: 'r：標本相関係数、n：サンプルサイズ。z変換することで正規分布に近似できる。',
    ),
    ExampleBlock(
      id: '2-3',
      question: 'n=28 のデータから r=0.65 を得た。比相関係数 ρ=0 を帰無仮説として、有意水準5%（両側）で検定せよ。t(26, 0.025)=2.056 とする。',
      hint: 'ρ=0 の検定に��� t = r√(n-2)/√(1-r²) を使用する。',
      answer: 't = 0.65 × √26 / √(1-0.4225)\n= 0.65 × 5.099 / √0.5775\n= 3.314 / 0.760\n= 4.36\n|t|=4.36 > t(26,0.025)=2.056 → H₀棄却\n→ 有意水準5%で相関���認められる。',
      explanation: 'ρ=0 の検定はt検定で行う。r²（決定係数）を確認すること（0.65²=0.423、説明力42%）。',
    ),
    PointBlock(
      title: '1級統計まとめ（必須公式）',
      points: [
        '不偏分散��V = Σ(xᵢ-x̄)²/(n-1)',
        'プール分散：Sp² = (S₁+S₂)/(n₁+n₂-2)',
        '2標本t統計量（等分散）：t = (x̄₁-x̄₂)/(Sp×√(1/n₁+1/n₂))',
        '相関係数検定：t = r√(n-2)/√(1-r²), 自由度 n-2',
        '回帰係数の検定：t = b₁/s(b₁), 自由度 n-2',
        'フィッシャーz変換：z = (1/2)ln[(1+r)/(1-r)]',
      ],
    ),
  ],
);
