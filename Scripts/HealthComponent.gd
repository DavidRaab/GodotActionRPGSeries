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
    self._health = clamp(value, _min_health, _max_health)
    
    # fire events when _health changed
    if _health != oldValue:
        self.health_changed.emit(_health, _min_health, _max_health)
        # when min_health is reached
        if _health == _min_health:
            self.min_health_reached.emit()
        

func add_health(value: int) -> void:
    self.set_health(self._health + value)

func subtract_health(value: int) -> void:
    self.set_health(self._health - value)

