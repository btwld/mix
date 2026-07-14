enum AtlasDestination {
  catalog('Catalog'),
  changes('Changes'),
  compare('Compare'),
  inspect('Inspect'),
  tokenUsage('Token Usage');

  const AtlasDestination(this.label);

  final String label;
}
