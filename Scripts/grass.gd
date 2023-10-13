extends Node2D

@onready var main   : Node2D      = get_tree().current_scene
@onready var effect : PackedScene = preload("res://Prefabs/GrassEffect.tscn")

func destroy_me():
    var obj : Node2D = effect.instantiate()
    obj.global_position = self.global_position
    main.add_child(obj)
    self.queue_free()

func _on_area_2d_area_entered(_area):
    destroy_me()

func _on_area_2d_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
    destroy_me()

func _on_area_2d_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
    destroy_me()
