extends Node2D

func _ready():
    var anim = $AnimatedSprite2D
    anim.animation_finished.connect(func():
        self.queue_free()
    )
    anim.play("default")
