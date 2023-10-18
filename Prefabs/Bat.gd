extends CharacterBody2D

@onready var collision :CollisionShape2D = $Hitbox/CollisionShape2D
@onready var health    :HealthComponent  = $HealthComponent

var knockback                            : Vector2 = Vector2.ZERO
@export var knockback_speed              : float   = 200.0
@export var knockback_falloff_per_second : float   = 800.0

func _ready():
    health.connect("min_health_reached", func(): self.queue_free())

func _physics_process(delta):
    self.velocity = knockback
    move_and_slide()
    knockback = knockback.move_toward(Vector2.ZERO, knockback_falloff_per_second * delta)

func _on_hitbox_area_entered(area):
    var direction = (collision.global_position - area.global_position).normalized()
    self.knockback = direction * knockback_speed
    
    if area is AreaDamage:
        self.health.subtract_health(area.damage)
