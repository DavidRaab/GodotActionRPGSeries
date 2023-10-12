extends Node2D

@onready var main   : Node2D      = get_tree().current_scene
@onready var effect : PackedScene = preload("res://Prefabs/GrassEffect.tscn")

func _process(_delta):
    if Input.is_action_just_pressed("player_attack"):
        var obj : Node2D = effect.instantiate()
        obj.global_position = self.global_position
        main.add_child(obj)
        self.queue_free()
