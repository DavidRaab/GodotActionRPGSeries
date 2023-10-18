extends Node2D

func _ready():
    $DeathEffect.connect("animation_finished", func():
        self.queue_free()
    )
