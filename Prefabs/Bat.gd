extends CharacterBody2D

# Getting References
var deathEffect        :PackedScene      = preload("res://Prefabs/bat_death_effect.tscn")
@onready var collision :CollisionShape2D = $Hitbox/CollisionShape2D
@onready var health    :HealthComponent  = $HealthComponent
@onready var detection :PlayerDetection  = $PlayerDetection

# State
enum State { Idle, Wander, Chase }
var current_state = State.Idle

# Chase variable
@export var chase_speed : int    = 100
var chase_body          : Node2D = null

var knockback               : Vector2 = Vector2.ZERO
@export var knockback_speed : float   = 200.0
@export var friction        : float   = 800.0

func _ready():
    health.connect("min_health_reached", func():
        self.queue_free()
        
        var obj : Node2D = deathEffect.instantiate()
        obj.global_position = self.global_position
        self.get_parent().add_child(obj)
    )
    detection.player_entered.connect(func(a,body,b,c):
        current_state = State.Chase
        chase_body    = body
    )
    detection.player_exited.connect( func(a,body,b,c):
        current_state = State.Idle
        chase_body    = null
    )

func _physics_process(delta):
    match current_state:
        State.Idle:
            self.velocity = self.velocity.move_toward(Vector2.ZERO, friction * delta)
        State.Wander:
            pass
        State.Chase:
            var direction = self.global_position.direction_to(self.chase_body.global_position).normalized()
            self.velocity = direction * chase_speed
        
    # Apply knockback
    self.velocity  = self.velocity + knockback
    self.knockback = self.knockback.move_toward(Vector2.ZERO, friction * delta)
    move_and_slide()

func _on_hitbox_area_entered(area):
    var direction = (collision.global_position - area.global_position).normalized()
    self.knockback = direction * knockback_speed
    
    if area is AreaDamage:
        self.health.subtract_health(area.damage)
