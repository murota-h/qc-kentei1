import 'package:flutter/material.dart';
import '../models/chapter.dart';
import '../models/content_block.dart';
import '../theme/app_theme.dart';

const chapter4 = Chapter(
  number: 4,
  title: '多変量解析',
  subtitle: '重回帰・主成分分析・判別・クラスター',
  color: AppColors.ch4,
  icon: Icons.scatter_plot,
  blocks: [
    TextBlock(text: '4.1 重回帰分析', style: BlockStyle.heading2),
    TextBlock(
      text: '複数の説明変数 x₁, x₂, …, xₚ から目的変数 y を予測するモデルを構築する。1級では変数選択（ステップワイズ法・AIC）・多重共線性（VIF）・残差診断まで扱う。',
      style: BlockStyle.body,
    ),
    FormulaBlock(
      label: '重回帰モデルと最小二乗推定',
      formula: 'y = β₀ + β₁x₁ + β₂x₂ + … + βₚxₚ + ε\nβ̂ = (XᵀX)⁻¹Xᵀy',
      explanation: 'β̂：最小二乗推定量（行列表現）。ε：誤差項 ~ N(0, σ²)',
    ),
    FormulaBlock(
      label: '自由度調整済み決定係数',
      formula: 'R̄² = 1 - (1-R²)×(n-1)/(n-p-1)',
      explanation: 'R²：決定係数、n：サンプルサイズ、p：説明変数の数。変数増加でR²は必ず上がるが、R̄²は有効な変数のみ増加で改善。',
    ),
    PointBlock(
      title: '多重共線性の診断と対処',
      points: [
        'VIF（分散拡大係数）= 1/(1-Rⱼ²)（VIF > 10 で多重共線性の疑い）',
        '相関行列の確認：説明変数間の相関が高い（|r| > 0.8）場合は警戒',
        '対処法1：主成分回帰（相関のない主成分を説明変数に使用）',
        '対処法2：リッジ回帰（正則化項を加えて推定を安定化）',
        '対処法3：片方の変数を削除（専門的知識に基づく）',
      ],
    ),
    ChartBlock(
      chartType: ChartType.regressionMultiple,
      config: {'title': '重回帰分析（残差プロット付き）'},
    ),
    ExampleBlock(
      id: '4-1',
      question: 'n=30 で重回帰分析（p=3変数）を行い R²=0.82 を得た。自由度調整済み R̄² を計算せよ。またこの回帰式を全体として有意かどうか F 検定の F₀ 値を計算せよ。F(3,26;0.05)=2.98',
      answer: 'R̄² = 1-(1-0.82)×29/26 = 1-0.18×1.115 = 1-0.201 = 0.799\nF₀ = (R²/p)/((1-R²)/(n-p-1)) = (0.82/3)/(0.18/26) = 0.2733/0.00692 = 39.5 > 2.98 → 有意',
      explanation: 'F検定は回帰式全体の有意性を判断。個別の t 検定は各変数の有意性を判断。R²=0.82 の意味：yの変動の82%をモデルで説明できる。',
    ),
    TextBlock(text: '4.2 主成分分析（PCA）', style: BlockStyle.heading2),
    TextBlock(
      text: '多変量データを少数の「主成分」に縮約し、情報の損失を最小化しつつ次元を削減する手法。相関行列（または分散共分散行列）の固有値・固有ベクトルを計算することが本質。',
      style: BlockStyle.body,
    ),
    FormulaBlock(
      label: '主成分の定義',
      formula: 'Z₁ = a₁₁x₁ + a₁₂x₂ + … + a₁ₚxₚ\n寄与率 = λ₁/Σλᵢ（λ：固有値）\n累積寄与率 = Σ(k番目まで)λᵢ/Σλᵢ',
      explanation: 'a：固有ベクトル（主成分係数）、λ：固有値（その主成分の情報量）。第1主成分 Z₁ の分散が最大。',
    ),
    ChartBlock(
      chartType: ChartType.pcaBiplot,
      config: {'title': '主成分分析バイプロット'},
    ),
    PointBlock(
      title: 'PCAの実施手順と解釈（1級）',
      points: [
        '① データの標準化（スケールが異なる変数が混在する場合）',
        '② 相関行列の固有値・固有ベクトルを計算',
        '③ 寄与率（各主成分が説明する情報の割合）（固有値/総固有値）',
        '④ 累積寄与率70〜80%以上を目安に主成分数を決定',
        '⑤ バイプロット：スコア（サンプルの位置）とローディング（変数の向き）を同時表示',
        '⑥ 因子負荷量（ローディング）の解釈で主成分に名前をつける',
      ],
    ),
    TextBlock(text: '4.3 判別分析', style: BlockStyle.heading2),
    TextBlock(
      text: '所属グループが既知のデータから判別関数を作成し、新しいサンプルがどのグループに属するかを判断する。フィッシャーの線形判別分析（LDA）が基本。マハラノビス距離との関係が重要。',
      style: BlockStyle.body,
    ),
    FormulaBlock(
      label: 'マハラノビス距離',
      formula: 'D² = (x - μ)ᵀ Σ⁻¹ (x - μ)',
      explanation: 'Σ：共分散行列、μ：グループ平均。ユークリッド距離と異なり、変数間の相関と分散を考慮。',
    ),
    TextBlock(text: '4.4 クラスター分析', style: BlockStyle.heading2),
    TextBlock(
      text: 'グループ構造が未知のデータを類似度（距離）に基づいてクラスターに分類する。階層的クラスタリング（ウォード法・群平均法）と非階層的クラスタリング（k-means法）が主要手法。',
      style: BlockStyle.body,
    ),
    TableBlock(
      title: 'クラスター分析の手法比較',
      headers: ['手法', '特徴', '長所', '注意点'],
      rows: [
        ['ウォード法', '群内分散最小化', 'コンパクトなクラスター', 'データ数増大で計算量増'],
        ['群平均法', '平均距離で結合', 'バランスが良い', '外れ値に比較的強い'],
        ['k-means法', '重心への距離最小化', '大データ対応可', 'k（クラスター数）を予め指定'],
      ],
    ),
    ExampleBlock(
      id: '4-2',
      question: '主成分分析で得られた固有値が λ₁=3.8, λ₂=1.4, λ₃=0.5, λ₄=0.3（p=4変数）の場合、第1主成分・第2主成分の寄与率と累積寄与率を求めよ。また何主成分まで採用すべきか、固有値1以上ルールで判断せよ。',
      answer: '総固有値=3.8+1.4+0.5+0.3=6.0\n第1主成分寄与率=3.8/6.0=63.3%\n第2主成分寄与率=1.4/6.0=23.3%\n累積寄与率=63.3+23.3=86.6%\n固有値>1 の主成分：λ₁=3.8>1, λ₂=1.4>1 → 第2主成分まで採用',
      explanation: '固有値1以上ルール（カイザールール）：標準化データでは1変数あたりの情報量=1なので、固有値1以上の主成分が「情報を持つ」目安。累積寄与率とあわせて判断。',
    ),
  ],
);
