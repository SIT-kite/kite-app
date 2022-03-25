import 'package:flutter_test/flutter_test.dart';

import 'rule.dart';

void main() {
  test('test const rule', () {
    expect(const ConstRule(true).accept(''), true);
    expect(const ConstRule(false).accept(123), false);
  });

  test('test equal rule', () {
    expect(const EqualRule(true).accept(true), true);
    expect(const EqualRule(true).accept(false), false);
    expect(const EqualRule(false).accept(true), false);
    expect(const EqualRule(false).accept(false), true);
  });

  test('test rule cross', () {
    final rule1 = ['a', 'b', 'c'].map((e) => EqualRule(e));
    final rule2 = ['b', 'c', 'd'].map((e) => EqualRule(e));
    final ruleCross = RuleCross(<Rule<String>>[
      RuleSum(rule1),
      RuleSum(rule2),
    ]);
    expect(ruleCross.accept('a'), false);
    expect(ruleCross.accept('b'), true);
    expect(ruleCross.accept('c'), true);
    expect(ruleCross.accept('d'), false);
    expect(ruleCross.accept('e'), false);
    expect(ruleCross.accept('f'), false);
  });

  test('test rule exclude', () {
    final rule1 = ['a', 'b', 'c'].map((e) => EqualRule(e));
    final rule2 = ['b', 'c', 'd'].map((e) => EqualRule(e));
    final ruleExclude = RuleExclude(
      source: RuleSum(rule1),
      exclude: RuleSum(rule2),
    );
    expect(ruleExclude.accept('a'), true);
    expect(ruleExclude.accept('b'), false);
    expect(ruleExclude.accept('c'), false);
    expect(ruleExclude.accept('d'), false);
    expect(ruleExclude.accept('e'), false);
    expect(ruleExclude.accept('f'), false);
  });

  test('test reg exp rule', () {
    final rule1 = RegExpRule(RegExp(r'^.*absd$'));
    expect(rule1.accept('123absd'), true);
    expect(rule1.accept('absd345'), false);
    expect(rule1.accept('abs5'), false);
  });

  test('test chain rule', () {
    final rule1 = RuleSum(['a', 'b', 'c'].map((e) => EqualRule(e)));
    final rule2 = RuleSum(['b', 'f', 'g'].map((e) => EqualRule(e)));
    final rule3 = RuleSum(['d', 'f', 'h'].map((e) => EqualRule(e)));
    // A = rule1.cross(rule2) = {'b'}
    // B = A.sum(rule3) = {'d', 'f', 'h', 'b'}
    // C = B.exclude(rule2) = {'d','h'}
    final chainRule = ChainRule(rule1);
    final A = chainRule.cross(rule2);
    final B = A.sum(rule3);
    final C = B.exclude(rule2);
    expect(C.accept('a'), false);
    expect(C.accept('b'), false);
    expect(C.accept('c'), false);
    expect(C.accept('f'), false);
    expect(C.accept('g'), false);
    expect(C.accept('d'), true);
    expect(C.accept('h'), true);
  });

  test('test rule sum', () {
    final rule = ['a', 'b', 'c'].map((e) => EqualRule(e));
    final ruleSum = RuleSum(rule);
    expect(ruleSum.accept('a'), true);
    expect(ruleSum.accept('b'), true);
    expect(ruleSum.accept('c'), true);
    expect(ruleSum.accept('d'), false);
  });

  test('test functional rule', () {
    expect(FunctionalRule((obj) => true).accept(null), true);
    expect(FunctionalRule((obj) => false).accept(null), false);
    expect(FunctionalRule((String obj) => obj == 'abc').accept('abc'), true);
  });
}
