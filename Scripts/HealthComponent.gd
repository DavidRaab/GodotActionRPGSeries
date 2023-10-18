class_name HealthComponent
extends Node

@export var _health     : int = 100
@export var _max_health : int = 100
@export var _min_health : int = 0

signal min_health_reached

func get_health() -> int:
    return _health

func set_health(value: int) -> void:
    if value > self._max_health:
        self._health = self._max_health
    elif value <= self._min_health:
        self._health = self._min_health
        self.emit_signal("min_health_reached")
    else:
        self._health = value

func add_health(value: int) -> void:
    self.set_health(self._health + value)

func subtract_health(value: int) -> void:
    self.set_health(self._health - value)

