import 'package:flutter/material.dart';
import '../models/chapter.dart';
import '../models/content_block.dart';
import '../theme/app_theme.dart';

const chapter6 = Chapter(
  number: 6,
  title: '抜取検査・サンプリング（上級）',
  subtitle: 'OC曲線・計数・計量抜取・サンプリング理論',
  color: AppColors.ch6,
  icon: Icons.fact_check_outlined,
  blocks: [
    TextBlock(text: '6.1 抜取検査の概念と種類', style: BlockStyle.heading2),
    TextBlock(
      text: '抜取検査（Sampling Inspection）は、ロット全体を検査せずにサンプルで合否判定する手法。全数検査が困難・不経済な場合に使用する。1級では OC曲線の特性計算・生産者危険・消費者危険の定量的理解が要求される。',
      style: BlockStyle.body,
    ),
    PointBlock(
      title: '抜取検査の基本用語',
      points: [
        'AQL（Acceptable Quality Level）：合格品質水準 → 生産者側が保護される品質',
        'LTPD（Lot Tolerance Percent Defective）：ロット許容不良率 → 消費者側が保護される品質',
        '生産者危険（α）：良いロットが不合格になる確率（第1種誤り）通常 α=0.05',
        '消費者危険（β）：悪いロットが合格になる確率（第2種誤り）通常 β=0.10',
        'OC曲線（Operating Characteristic Curve）：不良率 p vs 合格確率 L(p) のグラフ',
      ],
    ),
    ChartBlock(
      chartType: ChartType.ocCurveAdvanced,
      config: {'title': 'OC曲線（サンプルサイズ n・合格判定個数 c）'},
    ),
    TextBlock(text: '6.2 計数抜取検査（二項・ポアソン近似）', style: BlockStyle.heading2),
    TextBlock(
      text: '不良品の個数で判定する計数抜取検査。ロットサイズ N が大きい場合、超幾何分布 → 二項分布 → ポアソン近似の順で計算を簡略化する。n が大きいとき二項 → 正規近似も使用。',
      style: BlockStyle.body,
    ),
    FormulaBlock(
      label: '計数抜取検査の合格確率（二項分布）',
      formula: 'L(p) = Σ[x=0 to c] C(n,x) pˣ(1-p)^(n-x)\nポアソン近似：L(p) ≈ Σ[x=0 to c] e^(-np)(np)ˣ/x!',
      explanation: 'n：サンプルサイズ、c：合格判定個数、p：不良率。np ≤ 5 かつ n ≥ 20 のときポアソン近似が有効。',
    ),
    FormulaBlock(
      label: 'OC曲線の主要点（AQL・LTPD）',
      formula: 'AQLにて：L(AQL) = 1 - α ≈ 0.95\nLTPDにて：L(LTPD) = β ≈ 0.10',
      explanation: 'OC曲線の理想形は AQL では L→1、LTPDでは L→0 の急な切れ込み。n を大きくするほど急峻になる。',
    ),
    ExampleBlock(
      id: '6-1',
      question: 'n=50, c=2 の計数抜取検査について、p=0.02（不良率2%）のとき合格確率 L(0.02) をポアソン近似で求めよ。e⁻¹=0.3679',
      hint: 'np = 50×0.02 = 1.0。ポアソン分布で x=0,1,2 の確率の和を計算する。',
      answer: 'np = 1.0\nP(x=0) = e⁻¹×1⁰/0! = 0.3679\nP(x=1) = e⁻¹×1¹/1! = 0.3679\nP(x=2) = e⁻¹×1²/2! = 0.1839\nL(0.02) = 0.3679+0.3679+0.1839 = 0.9197（約92%）',
      explanation: 'np=1（ポアソン近似有効）。p=0.02の不良率でロットが合格する確率は92%。生産者にとってまずまずの水準。',
    ),
    TextBlock(text: '6.3 計量抜取検査', style: BlockStyle.heading2),
    TextBlock(
      text: '測定値（連続量）で判定する計量抜取検査。JIS Z 9003 計量規準型一回抜取検査が基本。標本平均を管理限界と比較して合否を判定する。計数より小さいサンプルサイズで同等の識別力を発揮。',
      style: BlockStyle.body,
    ),
    FormulaBlock(
      label: '計量規準型抜取検査（既知σ）',
      formula: 'k = (x̄ - m₀) / (σ/√n)  または\n合否判定：x̄ ≤ XU = m₀ + kσ/√n（上限規格）\nx̄ ≥ XL = m₀ - kσ/√n（下限規格）',
      explanation: 'k：判定係数（AQL・LTPD・α・βから決定）、m₀：規格中心値。正規分布を仮定して設計。',
    ),
    PointBlock(
      title: '計数 vs 計量抜取検査の比較',
      points: [
        '計数抜取：実施が簡単、サンプル数が多く必要、情報量少',
        '計量抜取：測定が必要、サンプル数少（効率的）、分布仮定が必要',
        '計量抜取は正規分布仮定が崩れると保証精度が低下する',
        'JIS Z 9015：計数値抜取検査（AQL方式、MIL-STD-105Eに相当）',
        'JIS Z 9003/9004：計量規準型一回抜取検査（既知σ・未知σ）',
      ],
    ),
    TextBlock(text: '6.4 連続生産型抜取検査', style: BlockStyle.heading2),
    TextBlock(
      text: '連続生産ライン（コンベア生産）に適した抜取検査。Dodge のCSP-1（Continuous Sampling Plan-1）が代表的。正常時は抜取、不良発見後は全数検査に切り替える。AOQL（Average Outgoing Quality Limit）が品質保証指標。',
      style: BlockStyle.body,
    ),
    FormulaBlock(
      label: 'AOQ（平均出検品質）',
      formula: 'AOQ ≈ p × L(p) × (N-n) / N\nAOQL = max[AOQ(p)] for all p',
      explanation: 'AOQL：AOQ の最大値。どんな不良率 p でも出検品質は AOQL を超えない。連続生産型で品質の上限保証に使う。',
    ),
    ExampleBlock(
      id: '6-2',
      question: 'JIS Z 9015-1 においてAQL=1.0%, 検査水準Ⅱ, ロットサイズ N=1200 の場合、サンプル文字と一回抜取のサンプルサイズ n、合格判定個数 Ac を答えよ。（JIS表参照：N=1200→文字J, J→n=80, AQL1.0%→Ac=2）',
      answer: 'ロットサイズ 1200 → サンプル文字 J\nn=80, Ac=2（Re=3）\n不良品が2個以内 → 合格\n不良品が3個以上 → 不合格',
      explanation: 'JIS Z 9015-1 の表の読み方が実務で必須。検査水準（I/II/III/S1〜S4）によりサンプルサイズが変わる。水準Ⅱが標準。',
    ),
    TextBlock(text: '6.5 サンプリング方法の理論', style: BlockStyle.heading2),
    TextBlock(
      text: '母集団から標本を抽出する方法。サンプリング誤差（ランダム誤差）とサンプリングバイアス（系統誤差）の違いを理解することが重要。層別サンプリングと集落サンプリングの使い分けが1級の頻出テーマ。',
      style: BlockStyle.body,
    ),
    TableBlock(
      title: 'サンプリング方法の比較',
      headers: ['方法', '概要', '長所', '短所'],
      rows: [
        ['単純無作為', '乱数表で全個体から抽出', '偏りなし・推定理論が単純', '母集団リスト必要'],
        ['系統（等間隔）', 'k番目ごとに抽出', '実施容易', '周期性がある場合に偏り'],
        ['層別', '層ごとに比例割付', '精度向上・各層の推定可能', '層情報が事前に必要'],
        ['集落（クラスター）', 'グループごとに抽出', 'コスト低い', '同一集落で相関→精度低'],
      ],
    ),
    FormulaBlock(
      label: '層別サンプリングの標準誤差',
      formula: 'V(x̄st) = Σ(Nₕ/N)² × Sₕ²/nₕ\n比例割付：nₕ = n × Nₕ/N\n最適割付：nₕ ∝ Nₕ × Sₕ',
      explanation: 'Nₕ：h 層の大きさ、Sₕ：h 層の標準偏差、nₕ：h 層のサンプルサイズ。最適割付では変動の大きい層をより多くサンプリング。',
    ),
    PointBlock(
      title: '抜取検査・サンプリングまとめ（1級必須）',
      points: [
        'OC曲線：n 大・c 小 → 鋭い識別力（急峻な曲線）',
        '生産者危険 α：良品を不合格（AQL付近の保護）',
        '消費者危険 β：不良を合格（LTPD付近の保護）',
        'AOQLは連続抜取で品質の上限を保証する指標',
        '計量抜取は小サンプルで高精度だが正規性仮定が前提',
        '層別サンプリングは変動の大きい集団の推定精度向上に有効',
      ],
    ),
  ],
);
