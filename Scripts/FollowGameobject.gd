extends Camera2D

@export var to_follow : NodePath
var following : Node2D

func _ready():
    following = self.get_node(to_follow)

func _process(delta):
    if is_instance_valid(following):
        self.transform = following.transform
