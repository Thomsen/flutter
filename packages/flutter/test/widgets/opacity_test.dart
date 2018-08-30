// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../rendering/mock_canvas.dart';
import 'semantics_tester.dart';

void main() {
  testWidgets('Opacity', (WidgetTester tester) async {
    final SemanticsTester semantics = new SemanticsTester(tester);

    // Opacity 1.0: Semantics and painting
    await tester.pumpWidget(
      const Opacity(
        child: Text('a', textDirection: TextDirection.rtl),
        opacity: 1.0,
      ),
    );
    expect(semantics, hasSemantics(
      new TestSemantics.root(
        children: <TestSemantics>[
          new TestSemantics.rootChild(
            id: 1,
            rect: Rect.fromLTRB(0.0, 0.0, 800.0, 600.0),
            label: 'a',
            textDirection: TextDirection.rtl,
          )
        ],
      ),
    ));
    expect(find.byType(Opacity), paints..paragraph());

    // Opacity 0.0: Nothing
    await tester.pumpWidget(
      const Opacity(
        child: Text('a', textDirection: TextDirection.rtl),
        opacity: 0.0,
      ),
    );
    expect(semantics, hasSemantics(
      new TestSemantics.root(),
    ));
    expect(find.byType(Opacity), paintsNothing);

    // Opacity 0.0 with semantics: Just semantics
    await tester.pumpWidget(
      const Opacity(
        child: Text('a', textDirection: TextDirection.rtl),
        opacity: 0.0,
        alwaysIncludeSemantics: true,
      ),
    );
    expect(semantics, hasSemantics(
      new TestSemantics.root(
        children: <TestSemantics>[
          new TestSemantics.rootChild(
            id: 1,
            rect: Rect.fromLTRB(0.0, 0.0, 800.0, 600.0),
            label: 'a',
            textDirection: TextDirection.rtl,
          )
        ],
      ),
    ));
    expect(find.byType(Opacity), paintsNothing);

    // Opacity 0.0 without semantics: Nothing
    await tester.pumpWidget(
      const Opacity(
        child: Text('a', textDirection: TextDirection.rtl),
        opacity: 0.0,
        alwaysIncludeSemantics: false,
      ),
    );
    expect(semantics, hasSemantics(
      new TestSemantics.root(),
    ));
    expect(find.byType(Opacity), paintsNothing);

    // Opacity 0.1: Semantics and painting
    await tester.pumpWidget(
      const Opacity(
        child: Text('a', textDirection: TextDirection.rtl),
        opacity: 0.1,
      ),
    );
    expect(semantics, hasSemantics(
      new TestSemantics.root(
        children: <TestSemantics>[
          new TestSemantics.rootChild(
            id: 1,
            rect: Rect.fromLTRB(0.0, 0.0, 800.0, 600.0),
            label: 'a',
            textDirection: TextDirection.rtl,
          )
        ],
      ),
    ));
    expect(find.byType(Opacity), paints..paragraph());

    // Opacity 0.1 without semantics: Still has semantics and painting
    await tester.pumpWidget(
      const Opacity(
        child: Text('a', textDirection: TextDirection.rtl),
        opacity: 0.1,
        alwaysIncludeSemantics: false,
      ),
    );
    expect(semantics, hasSemantics(
      new TestSemantics.root(
        children: <TestSemantics>[
          new TestSemantics.rootChild(
            id: 1,
            rect: Rect.fromLTRB(0.0, 0.0, 800.0, 600.0),
            label: 'a',
            textDirection: TextDirection.rtl,
          )
        ],
      ),
    ));
    expect(find.byType(Opacity), paints..paragraph());

    // Opacity 0.1 with semantics: Semantics and painting
    await tester.pumpWidget(
      const Opacity(
        child: Text('a', textDirection: TextDirection.rtl),
        opacity: 0.1,
        alwaysIncludeSemantics: true,
      ),
    );
    expect(semantics, hasSemantics(
      new TestSemantics.root(
        children: <TestSemantics>[
          new TestSemantics.rootChild(
            id: 1,
            rect: Rect.fromLTRB(0.0, 0.0, 800.0, 600.0),
            label: 'a',
            textDirection: TextDirection.rtl,
          )
        ],
      ),
    ));
    expect(find.byType(Opacity), paints..paragraph());

    semantics.dispose();
  });
}
