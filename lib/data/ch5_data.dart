import 'package:flutter/material.dart';
import '../models/chapter.dart';
import '../models/content_block.dart';
import '../theme/app_theme.dart';

const chapter5 = Chapter(
  number: 5,
  title: '信頼性工学',
  subtitle: 'ワイブル・バスタブ・FMEA・FTA・信頼性設計',
  color: AppColors.ch5,
  icon: Icons.verified_outlined,
  blocks: [
    TextBlock(text: '5.1 信頼性の基本概念', style: BlockStyle.heading2),
    TextBlock(
      text: '信頼性（Reliability）とは、アイテムが与えられた条件下で、規定の期間中、要求された機能を果たす能力である。1級では信頼性関数・故障率関数・平均故障寿命（MTTF）の計算と分布の選択まで問われる。',
      style: BlockStyle.body,
    ),
    FormulaBlock(
      label: '信頼性の基本関数',
      formula: 'R(t) = P(T > t) = 1 - F(t)\nλ(t) = f(t) / R(t) = -d[lnR(t)]/dt\nMTTF = ∫₀^∞ R(t) dt',
      explanation: 'R(t)：信頼度関数、F(t)：故障分布関数、λ(t)：故障率関数（ハザード関数）、f(t)：故障密度関数',
    ),
    TextBlock(text: '5.2 ワイブル分布と信頼性解析', style: BlockStyle.heading2),
    TextBlock(
      text: 'ワイブル分布は形状母数 m（ワイブル係数）と尺度母数 η によってさまざまな故障パターンを表現できる。m<1：初期故障（乳幼児死亡）、m=1：偶発故障（指数分布）、m>1：摩耗故障を表す。',
      style: BlockStyle.body,
    ),
    FormulaBlock(
      label: 'ワイブル分布の信頼性関数',
      formula: 'R(t) = exp[-(t/η)^m]\nλ(t) = (m/η)(t/η)^(m-1)\nMTTF = η × Γ(1 + 1/m)',
      explanation: 'm：形状母数（ワイブル係数）、η：尺度母数（特性寿命）、Γ：ガンマ関数。MTTF は η×Γ(1+1/m) で計算。',
    ),
    ChartBlock(
      chartType: ChartType.weibull,
      config: {'title': 'ワイブル確率紙（形状母数 m・尺度母数 η）'},
    ),
    ChartBlock(
      chartType: ChartType.reliabilityHazard,
      config: {'title': 'バスタブ曲線（ハザード関数 λ(t)）'},
    ),
    PointBlock(
      title: 'バスタブ曲線（浴槽曲線）の3段階',
      points: [
        '初期故障期（DFR: Decreasing Failure Rate）：m<1、設計・製造上の欠陥が原因',
        '偶発故障期（CFR: Constant Failure Rate）：m=1、ランダムな外的ストレスが原因',
        '摩耗故障期（IFR: Increasing Failure Rate）：m>1、材料劣化・疲労が原因',
        '初期故障対策：バーンイン（加速試験で弱品を排除）',
        '摩耗故障対策：予防保全（計画的な交換・オーバーホール）',
      ],
    ),
    ExampleBlock(
      id: '5-1',
      question: 'ワイブル分布で m=2.0, η=1000h のとき、t=500h での信頼度 R(500)、故障率 λ(500)、MTTF を計算せよ。Γ(1.5)=0.8862',
      answer: 'R(500) = exp[-(500/1000)²] = exp[-0.25] = 0.7788\nλ(500) = (2/1000)(500/1000)^1 = 0.002 × 0.5 = 0.001 [故障/h]\nMTTF = 1000 × Γ(1.5) = 1000 × 0.8862 = 886.2 h',
      explanation: 'm=2（摩耗故障型）。t が増えるとλ(t)が増大する。MTTF < η（特性寿命）は m>1 のとき常に成立。',
    ),
    TextBlock(text: '5.3 系の信頼性（直列・並列・冗長系）', style: BlockStyle.heading2),
    TextBlock(
      text: '複数のユニットで構成されるシステムの信頼度計算。直列系・並列系（冗長系）の組み合わせが1級での主題。k-out-of-n系（n個中k個以上動作で正常）も重要。',
      style: BlockStyle.body,
    ),
    FormulaBlock(
      label: '直列系・並列系の信頼度',
      formula: '直列系：Rs = R₁ × R₂ × … × Rₙ\n並列系：Rs = 1 - (1-R₁)(1-R₂)…(1-Rₙ)\nk-out-of-n：Rs = Σ[i=k to n] C(n,i) Rⁱ(1-R)^(n-i)',
      explanation: '並列系は冗長設計。すべてのユニットが故障したときにシステムが故障する。k-out-of-n は二項分布で計算。',
    ),
    TableBlock(
      title: '信頼度の組み合わせ計算例（R₁=R₂=0.9）',
      headers: ['構成', '計算式', '系信頼度'],
      rows: [
        ['2直列', '0.9 × 0.9', '0.81'],
        ['2並列', '1-(1-0.9)²', '0.99'],
        ['1-out-of-2', '同上（並列と同じ）', '0.99'],
        ['2-out-of-3', 'C(3,2)0.9²×0.1+C(3,3)0.9³', '0.972'],
      ],
    ),
    ExampleBlock(
      id: '5-2',
      question: '各ユニットの信頼度 R=0.8 で、3ユニット中2ユニット以上が正常動作すればシステムOKの「2-out-of-3系」の信頼度を計算せよ。',
      answer: 'Rs = C(3,2)×0.8²×0.2¹ + C(3,3)×0.8³×0.2⁰\n= 3×0.64×0.2 + 1×0.512×1\n= 0.384 + 0.512\n= 0.896',
      explanation: '2-out-of-3系は多数決システムとも呼ばれ、航空機の制御系などに使用。2並列（0.96）より低いが2直列（0.64）より高い。',
    ),
    TextBlock(text: '5.4 FMEA（故障モード影響解析）', style: BlockStyle.heading2),
    TextBlock(
      text: 'FMEA（Failure Mode and Effects Analysis）は、製品・プロセスの設計段階で想定される故障モードを洗い出し、その影響度・発生確率・検出困難度を評価してリスク優先数（RPN）を算出し、対策優先順位を決める手法。',
      style: BlockStyle.body,
    ),
    TableBlock(
      title: 'FMEAのRPN計算例',
      headers: ['故障モード', '影響度S', '発生頻度O', '検出困難度D', 'RPN=S×O×D', '優先度'],
      rows: [
        ['配線断線', '9', '3', '2', '54', '中'],
        ['コネクタ抜け', '8', '4', '6', '192', '高'],
        ['基板腐食', '7', '2', '8', '112', '中〜高'],
      ],
    ),
    PointBlock(
      title: 'FMEAの実施ポイント（1級）',
      points: [
        'RPN = S（Severity）× O（Occurrence）× D（Detection）',
        'RPN > 100〜125 などしきい値を設定して対策必須項目を決める',
        '設計FMEA（DFMEA）：製品設計の故障モード解析',
        'プロセスFMEA（PFMEA）：製造プロセスの故障モード解析',
        'FMEAの限界：複合故障・共通原因故障の把握にはFTAを併用',
      ],
    ),
    TextBlock(text: '5.5 FTA（故障の木解析）', style: BlockStyle.heading2),
    TextBlock(
      text: 'FTA（Fault Tree Analysis）は、トップ事象（望ましくない事象）から原因を木構造でトップダウンに分析し、基本事象の組み合わせ（ミニマルカットセット）を求める定性的・定量的解析手法。',
      style: BlockStyle.body,
    ),
    FormulaBlock(
      label: 'FTAのゲート論理と確率計算',
      formula: 'ANDゲート：P(A∩B) = P(A) × P(B)（独立の場合）\nORゲート：P(A∪B) = 1-(1-P(A))(1-P(B))',
      explanation: 'ANDゲート：すべての基本事象が同時発生でトップ事象発生 → 信頼性が上がる。ORゲート：いずれかの発生でトップ事象発生 → 信頼性が下がる。',
    ),
    PointBlock(
      title: 'ミニマルカットセットの求め方',
      points: [
        'カットセット：トップ事象を発生させる基本事象の集合',
        'ミニマルカットセット（MCS）：冗長な要素を除いた最小カットセット',
        'MCS の数が少なく要素数が少ないほど危険なシステム',
        'ブール代数（AND=積、OR=和）で代数的に求める',
        'FMEAとの違い：FTAは演繹的（トップダウン）、FMEAは帰納的（ボトムアップ）',
      ],
    ),
    ExampleBlock(
      id: '5-3',
      question: 'トップ事象Tが「OR(A, AND(B,C))」で表されるFTAにおいて、P(A)=0.01, P(B)=0.05, P(C)=0.02 のときトップ事象の確率を計算せよ。',
      answer: 'P(AND(B,C)) = 0.05 × 0.02 = 0.001\nP(T) = 1-(1-0.01)(1-0.001)\n= 1-0.99×0.999\n= 1-0.98901 = 0.01099\n≈ 0.011（1.1%）',
      explanation: 'ORゲートは並列系（どちらか発生でトップ）。ANDゲートは直列系と逆の意味を持ちトップ確率を下げる。P(A)単独の 0.01 が支配的。',
    ),
    TextBlock(text: '5.6 保全性・アベイラビリティ', style: BlockStyle.heading2),
    TextBlock(
      text: 'アベイラビリティ（稼働率）は、システムが要求された機能を実行できる状態にある時間の割合。MTBF（平均故障間隔）とMTTR（平均修復時間）から計算する。',
      style: BlockStyle.body,
    ),
    FormulaBlock(
      label: 'アベイラビリティの計算',
      formula: 'A = MTBF / (MTBF + MTTR)\nMTBF = 1/λ（指数分布の場合）\nMTTR = 1/μ（指数分布の場合）',
      explanation: 'A：稼働率（Availability）、MTBF：平均故障間隔、MTTR：平均修復時間、μ：修復率',
    ),
    ExampleBlock(
      id: '5-4',
      question: 'MTBF=1000h, MTTR=10h のシステムのアベイラビリティを計算せよ。また λ（故障率）と μ（修復率）を求めよ。',
      answer: 'A = 1000/(1000+10) = 1000/1010 = 0.9901（99.01%）\nλ = 1/MTBF = 1/1000 = 0.001 [故障/h]\nμ = 1/MTTR = 1/10 = 0.1 [修復/h]',
      explanation: '高いアベイラビリティを達成するには MTBF を大きく（壊れにくく）または MTTR を小さく（修復しやすく）する。どちらも設計で改善可能。',
    ),
    PointBlock(
      title: '信頼性工学まとめ（1級必須）',
      points: [
        'ワイブル分布：m<1（初期）, m=1（偶発）, m>1（摩耗）の判別',
        '直列系 Rs<min(Ri)、並列系 Rs>max(Ri)',
        'FMEA：RPN=S×O×D → 設計段階のリスク管理',
        'FTA：ミニマルカットセット → システムの弱点特定',
        'アベイラビリティ：MTBF/(MTBF+MTTR)',
        '信頼性試験（加速寿命試験・アレニウスモデル）も1級頻出',
      ],
    ),
  ],
);
