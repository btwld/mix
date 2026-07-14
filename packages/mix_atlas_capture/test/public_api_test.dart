import 'package:flutter_test/flutter_test.dart';
import 'package:mix_atlas_capture/mix_atlas_capture.dart';

void main() {
  test('exposes Atlas-prefixed reader, source, and slot contracts', () {
    const request = AtlasRepositoryRequest(
      repository: 'btwld/remix',
      ref: 'main',
      manifestPath: 'atlas/fortal/capture.json',
    );
    final reader = AtlasCaptureReader(source: _NeverReadSource());
    final supported = AtlasSlotStyle.supported(
      documentPath: 'styles/button/container.mix.json',
    );
    final unsupported = AtlasSlotStyle.unsupported(
      diagnostics: const [
        AtlasComponentDiagnostic(
          code: 'unsupported.spinner',
          severity: 'warning',
          path: '/slots/spinner',
          message: 'Spinner is intentionally unsupported.',
        ),
      ],
    );

    expect(request.ref, 'main');
    expect(reader, isA<AtlasCaptureReader>());
    expect(supported.isSupported, true);
    expect(supported.documentPath, endsWith('.mix.json'));
    expect(unsupported.isSupported, false);
    expect(unsupported.diagnostics, hasLength(1));
  });
}

final class _NeverReadSource implements AtlasArtifactSource {
  @override
  Future<AtlasResolvedArtifactSource> resolve(AtlasRepositoryRequest request) =>
      throw UnsupportedError('not used');
}
