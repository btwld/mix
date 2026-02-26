import 'package:flutter_test/flutter_test.dart';
import 'package:mix_schema/mix_schema.dart';

void main() {
  group('SchemaEvent', () {
    test('TapEvent stores nodeId and actionId', () {
      final event = TapEvent(nodeId: 'btn1', actionId: 'submit');
      expect(event.nodeId, 'btn1');
      expect(event.actionId, 'submit');
      expect(event.timestamp, isA<DateTime>());
    });

    test('TapEvent without actionId', () {
      final event = TapEvent(nodeId: 'btn1');
      expect(event.actionId, isNull);
    });

    test('ChangeEvent stores field and value', () {
      final event = ChangeEvent(
        nodeId: 'input1',
        field: 'name',
        value: 'John',
      );
      expect(event.nodeId, 'input1');
      expect(event.field, 'name');
      expect(event.value, 'John');
    });

    test('SubmitEvent stores formData', () {
      final event = SubmitEvent(
        nodeId: 'form1',
        formData: {'name': 'John', 'email': 'john@test.com'},
      );
      expect(event.nodeId, 'form1');
      expect(event.formData['name'], 'John');
    });

    test('SelectEvent stores selected items', () {
      final event = SelectEvent(
        nodeId: 'list1',
        selected: ['a', 'b'],
      );
      expect(event.selected.length, 2);
    });

    test('DismissEvent stores reason', () {
      final event = DismissEvent(nodeId: 'dialog1', reason: 'cancel');
      expect(event.reason, 'cancel');
    });

    test('ScrollEndEvent', () {
      final event = ScrollEndEvent(nodeId: 'scroll1');
      expect(event.nodeId, 'scroll1');
    });

    test('all events have toString', () {
      final events = <SchemaEvent>[
        TapEvent(nodeId: 'a'),
        ChangeEvent(nodeId: 'b', field: 'f'),
        SubmitEvent(nodeId: 'c', formData: {}),
        SelectEvent(nodeId: 'd', selected: []),
        DismissEvent(nodeId: 'e'),
        ScrollEndEvent(nodeId: 'f'),
      ];

      for (final event in events) {
        expect(event.toString(), isNotEmpty);
      }
    });
  });

  group('SchemaAction', () {
    test('low risk actions', () {
      const actions = <SchemaAction>[
        NavigateAction(to: '/home'),
        SetStateAction(path: 'count', value: 1),
        ShowSnackbarAction(message: 'Done'),
        DismissAction(),
        RefreshAction(),
        LogEventAction(name: 'click'),
      ];

      for (final action in actions) {
        expect(action.risk, ActionRisk.low);
      }
    });

    test('medium risk actions', () {
      const actions = <SchemaAction>[
        ShowDialogAction(title: 'Alert', body: 'Are you sure?'),
        ResetStateAction(),
        EmitEventAction(name: 'custom'),
      ];

      for (final action in actions) {
        expect(action.risk, ActionRisk.medium);
      }
    });

    test('high risk actions', () {
      const actions = <SchemaAction>[
        OpenUrlAction(url: 'https://example.com'),
        RequestAction(method: 'POST', url: 'https://api.example.com'),
        SequenceAction(steps: [DismissAction()]),
      ];

      for (final action in actions) {
        expect(action.risk, ActionRisk.high);
      }
    });

    test('13 whitelisted action types', () {
      const actions = <SchemaAction>[
        NavigateAction(to: '/'),
        SetStateAction(path: 'x', value: 0),
        ShowSnackbarAction(message: 'm'),
        DismissAction(),
        RefreshAction(),
        LogEventAction(name: 'e'),
        ShowDialogAction(title: 't', body: 'b'),
        ResetStateAction(),
        EmitEventAction(name: 'e'),
        OpenUrlAction(url: 'u'),
        RequestAction(method: 'GET', url: 'u'),
        SequenceAction(steps: []),
        ConditionalAction(
          condition: 'isLoggedIn',
          then: NavigateAction(to: '/home'),
          elseAction: NavigateAction(to: '/login'),
        ),
      ];

      expect(actions.length, 13);
      final types = actions.map((a) => a.type).toSet();
      expect(types.length, 13); // All unique types
    });

    test('ConditionalAction is low risk', () {
      const action = ConditionalAction(
        condition: 'x',
        then: DismissAction(),
      );
      expect(action.risk, ActionRisk.low);
      expect(action.condition, 'x');
      expect(action.then, isA<DismissAction>());
      expect(action.elseAction, isNull);
    });
  });
}
