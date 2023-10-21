class_name PlayerDetection
extends Area2D

@export var objectName = "Player"
signal player_entered
signal player_exited

func _ready():
    self.body_shape_entered.connect(on_body_entered)
    self.body_shape_exited.connect(on_body_exited)

func on_body_entered(rid:RID, body:Node2D, body_shape_index:int, local_shape_index:int):
    if body is CharacterBody2D and body.name == objectName:
        self.player_entered.emit(rid, body, body_shape_index, local_shape_index)

func on_body_exited(rid:RID, body:Node2D, body_shape_index:int, local_shape_index:int):
    if body is CharacterBody2D and body.name == objectName:
        self.player_exited.emit(rid, body, body_shape_index, local_shape_index)
