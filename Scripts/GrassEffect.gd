extends Node2D

func _ready():
    var anim = $AnimatedSprite2D
    anim.connect("animation_finished", func():
        self.queue_free()
    )
    anim.play("default")
