class_name HealthComponent
extends Node

@export var _health     : int = 100
@export var _max_health : int = 100
@export var _min_health : int = 0

signal min_health_reached
signal health_changed

func get_health() -> int:
    return _health

func set_health(value: int) -> void:
    var oldValue = self._health
    if value > self._max_health:
        self._health = self._max_health
    elif value <= self._min_health:
        self._health = self._min_health
        self.min_health_reached.emit()
    else:
        self._health = value
    
    # if current health changed
    if oldValue != _health:
        self.health_changed.emit(_health, _min_health, _max_health)
        

func add_health(value: int) -> void:
    self.set_health(self._health + value)

func subtract_health(value: int) -> void:
    self.set_health(self._health - value)

