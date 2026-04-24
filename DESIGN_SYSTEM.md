# CyberGuard Design System

CyberGuard uses a professional dark security product aesthetic: quiet near-black surfaces, crisp borders, restrained glow, and neon accents only for state, action, and risk.

## Tokens

- `AppColors`: background, surfaces, borders, text colors, and neon accents.
- `AppSpacing`: spacing scale, control height, page padding, and 8px radius.
- `RiskColors`: maps `RiskLevel` to green, blue, amber, and red risk accents.

## Typography

Typography is defined in `AppTheme.dark()`:

- `headlineMedium`: page and module headings.
- `titleLarge`: major metrics and card headers.
- `titleMedium`: entity titles and section titles.
- `bodyMedium`: supporting copy and metadata.
- `labelLarge` and `labelMedium`: buttons, badges, and compact state labels.

All text uses zero letter spacing and fixed sizes for predictable mobile layouts.

## Components

- `CyberButton`: primary, secondary, and danger actions with loading state.
- `SecurityCard`: bordered security panel with optional accent rail.
- `RiskIndicator`: compact risk score and state indicator.
- `RiskBadge`: compatibility wrapper over `RiskIndicator`.
- `SectionHeader`: page header with blue accent rail.
- `AppShell`: app scaffold, app bar, and bottom navigation.

## Usage

```dart
SecurityCard(
  accentColor: AppColors.neonGreen,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('Risk Trend', style: Theme.of(context).textTheme.titleMedium),
      const SizedBox(height: AppSpacing.md),
      RiskIndicator(level: RiskLevel.low, score: 42),
    ],
  ),
)
```

Keep neon accents purposeful: green for secure/primary, blue for intelligence and navigation, amber for caution, red for danger.
