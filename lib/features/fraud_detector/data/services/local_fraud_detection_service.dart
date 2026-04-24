class LocalFraudDetectionService {
  Future<FraudAnalysis> analyze(String input) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    final normalized = input.toLowerCase();
    final evidence = <FraudEvidence>[
      ..._keywordEvidence(normalized),
      ..._urgencyEvidence(normalized),
      ..._linkEvidence(normalized),
    ];
    final probability = _calculateProbability(evidence);

    return FraudAnalysis(
      input: input,
      evidence: evidence,
      probability: probability,
      warningMessage: _warningFor(probability, evidence),
      predictedImpact: _impactFor(evidence, probability),
    );
  }

  Future<List<String>> findMatches(String input) async {
    final analysis = await analyze(input);
    return analysis.evidence.map((item) => item.label).toList();
  }

  List<FraudEvidence> _keywordEvidence(String input) {
    final evidence = <FraudEvidence>[];

    if (_containsAny(input, const ['password', 'pin', 'otp', 'login', 'verify account'])) {
      evidence.add(
        const FraudEvidence(
          label: 'Credential harvesting language',
          type: FraudSignalType.phishingKeyword,
          weight: 0.32,
          impact: FraudImpact.accountTakeover,
        ),
      );
    }
    if (_containsAny(input, const ['bank', 'wallet', 'card', 'payment', 'refund'])) {
      evidence.add(
        const FraudEvidence(
          label: 'Financial lure',
          type: FraudSignalType.phishingKeyword,
          weight: 0.2,
          impact: FraudImpact.financialLoss,
        ),
      );
    }
    if (_containsAny(input, const ['prize', 'reward', 'gift', 'lottery'])) {
      evidence.add(
        const FraudEvidence(
          label: 'Reward lure',
          type: FraudSignalType.phishingKeyword,
          weight: 0.16,
          impact: FraudImpact.financialLoss,
        ),
      );
    }
    if (input.contains('account') && _containsAny(input, const ['locked', 'suspended', 'blocked'])) {
      evidence.add(
        const FraudEvidence(
          label: 'Account lock scare tactic',
          type: FraudSignalType.phishingKeyword,
          weight: 0.24,
          impact: FraudImpact.accountTakeover,
        ),
      );
    }

    return evidence;
  }

  List<FraudEvidence> _urgencyEvidence(String input) {
    final evidence = <FraudEvidence>[];

    if (_containsAny(input, const ['urgent', 'immediately', 'now', 'within 24 hours'])) {
      evidence.add(
        const FraudEvidence(
          label: 'Urgency pressure',
          type: FraudSignalType.urgencyPattern,
          weight: 0.18,
          impact: FraudImpact.socialEngineering,
        ),
      );
    }
    if (_containsAny(input, const ['final notice', 'last chance', 'avoid closure'])) {
      evidence.add(
        const FraudEvidence(
          label: 'Threatening deadline',
          type: FraudSignalType.urgencyPattern,
          weight: 0.16,
          impact: FraudImpact.socialEngineering,
        ),
      );
    }

    return evidence;
  }

  List<FraudEvidence> _linkEvidence(String input) {
    final evidence = <FraudEvidence>[];
    final hasUrl = RegExp(r'https?://|www\.').hasMatch(input);

    if (input.contains('http://')) {
      evidence.add(
        const FraudEvidence(
          label: 'Unencrypted link',
          type: FraudSignalType.suspiciousLink,
          weight: 0.2,
          impact: FraudImpact.malwareExposure,
        ),
      );
    }
    if (_containsAny(input, const ['bit.ly', 'tinyurl', 't.co', 'goo.gl'])) {
      evidence.add(
        const FraudEvidence(
          label: 'Shortened URL',
          type: FraudSignalType.suspiciousLink,
          weight: 0.26,
          impact: FraudImpact.malwareExposure,
        ),
      );
    }
    if (hasUrl && _containsAny(input, const ['verify', 'login', 'password', 'refund'])) {
      evidence.add(
        const FraudEvidence(
          label: 'Sensitive action requested through link',
          type: FraudSignalType.suspiciousLink,
          weight: 0.3,
          impact: FraudImpact.accountTakeover,
        ),
      );
    }

    return evidence;
  }

  int _calculateProbability(List<FraudEvidence> evidence) {
    if (evidence.isEmpty) {
      return 4;
    }

    final base = evidence.fold<double>(0, (sum, item) => sum + item.weight);
    final typeCount = evidence.map((item) => item.type).toSet().length;
    final correlationBonus = switch (typeCount) {
      3 => 0.18,
      2 => 0.1,
      _ => 0,
    };

    return ((base + correlationBonus).clamp(0, 1) * 100).round();
  }

  String _warningFor(int probability, List<FraudEvidence> evidence) {
    if (probability >= 85) {
      return 'Critical fraud risk. Do not open links or share credentials.';
    }
    if (probability >= 60) {
      return 'High fraud risk. Verify through an official channel.';
    }
    if (probability >= 30) {
      return 'Suspicious message. Review the sender and link before acting.';
    }
    return evidence.isEmpty
        ? 'No strong fraud indicators detected.'
        : 'Low fraud risk, but continue with caution.';
  }

  String _impactFor(List<FraudEvidence> evidence, int probability) {
    if (evidence.any((item) => item.impact == FraudImpact.accountTakeover)) {
      return 'Possible account takeover or credential theft';
    }
    if (evidence.any((item) => item.impact == FraudImpact.financialLoss)) {
      return 'Possible financial loss or payment fraud';
    }
    if (evidence.any((item) => item.impact == FraudImpact.malwareExposure)) {
      return 'Possible malware exposure from a suspicious link';
    }
    if (probability >= 30) {
      return 'Possible social engineering attempt';
    }
    return 'No immediate impact predicted';
  }

  bool _containsAny(String input, List<String> patterns) {
    return patterns.any(input.contains);
  }
}

class FraudAnalysis {
  const FraudAnalysis({
    required this.input,
    required this.evidence,
    required this.probability,
    required this.warningMessage,
    required this.predictedImpact,
  });

  final String input;
  final List<FraudEvidence> evidence;
  final int probability;
  final String warningMessage;
  final String predictedImpact;
}

class FraudEvidence {
  const FraudEvidence({
    required this.label,
    required this.type,
    required this.weight,
    required this.impact,
  });

  final String label;
  final FraudSignalType type;
  final double weight;
  final FraudImpact impact;
}

enum FraudSignalType {
  phishingKeyword,
  urgencyPattern,
  suspiciousLink,
}

enum FraudImpact {
  accountTakeover,
  financialLoss,
  malwareExposure,
  socialEngineering,
}
