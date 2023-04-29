import 'event.dart';

class EventSnapshot<TEvent extends Event, TState> {
  final TEvent event;
  final TState state;

  const EventSnapshot(this.event, this.state); 
}