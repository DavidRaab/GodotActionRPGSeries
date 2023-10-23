extends CharacterBody2D

# Getting References
var deathEffect        :PackedScene      = preload("res://Prefabs/bat_death_effect.tscn")
var hitEffect          :PackedScene      = preload("res://Prefabs/HitEffect.tscn")
@onready var collision :CollisionShape2D = $Hitbox/CollisionShape2D
@onready var health    :HealthComponent  = $HealthComponent
@onready var detection :PlayerDetection  = $PlayerDetection
@onready var playerAttackArea            = $PlayerAttackArea

# State
enum State { Idle, Wander, Chase, Attack }
var current_state = State.Idle

# Chase variable
@export var chase_speed : int    = 100
var chase_body          : Node2D = null

var knockback               : Vector2 = Vector2.ZERO
@export var knockback_speed : float   = 200.0
@export var friction        : float   = 800.0

# Attack state
var in_attack_range            = false
@export var attack_damage      = 1
@export var attacks_per_second = 1.0
var attack_timeout             = 1.0 / attacks_per_second
var time_since_last_attack     = 0.0

func _ready():
    # when health reached minimum, bat dies
    health.connect("min_health_reached", func():
        self.queue_free()
        
        var obj : Node2D = deathEffect.instantiate()
        obj.global_position = self.global_position
        self.get_parent().add_child(obj)
    )
    # when player detected, follow him
    detection.player_entered.connect(func(a,body,b,c):
        current_state = State.Chase
        chase_body    = body
    )
    # when player out of reach go idle
    detection.player_exited.connect( func(a,body,b,c):
        current_state = State.Idle
        chase_body    = null
    )
    # set in_attack_range
    playerAttackArea.body_shape_entered.connect(func(a,b,c,d): self.in_attack_range = true)
    playerAttackArea.body_shape_exited.connect( func(a,b,c,d): self.in_attack_range = false)

func _physics_process(delta):
    time_since_last_attack += delta
    if in_attack_range and time_since_last_attack > attack_timeout:
        current_state = State.Attack
        time_since_last_attack = 0.0
    
    match current_state:
        State.Idle:
            self.velocity = self.velocity.move_toward(Vector2.ZERO, friction * delta)
        State.Wander:
            pass
        State.Chase:
            var direction = self.global_position.direction_to(self.chase_body.global_position).normalized()
            self.velocity = direction * chase_speed
        State.Attack:
            # Try to do damage on player
            if self.chase_body.take_damage(self.attack_damage):
                # if succesfull spawn HitEffect
                for body in playerAttackArea.get_overlapping_bodies():
                    var hit = hitEffect.instantiate()
                    hit.global_position = body.global_position
                    get_parent().add_child(hit)
            
            self.current_state = State.Chase
        
    # Apply knockback
    self.velocity  = self.velocity + knockback
    self.knockback = self.knockback.move_toward(Vector2.ZERO, friction * delta)
    move_and_slide()

func _on_hitbox_area_entered(area):
    var direction = (collision.global_position - area.global_position).normalized()
    self.knockback = direction * knockback_speed
    
    if area is AreaDamage:
        self.health.subtract_health(area.damage)
