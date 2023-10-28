class_name MoveComponent
extends Node

# Enables the MoveComponent. If disabled the whole Component will do nothing
# indepent on whatever method is called.
@export var isEnabled  : bool    = true
# Global Position the character tries to move to
var targetPosition     : Vector2 = Vector2(0,0)
# The object that should be moved
@export var move       : CharacterBody2D
@export var speed      : float   = 10.0
@export var friction   : float   = 10.0

var knockback          : Vector2 = Vector2(0,0)
var knockback_duration : float   = 0.0
var knockback_runned   : float   = 0.0

# Character either don't move, move to targetPosition or applies the knockback
enum State { Stop, Move, Knockback }

var state_after_knockback : State = State.Stop
var current_state         : State = State.Stop

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
    if isEnabled:
        match current_state:
            State.Stop:
                move.velocity = move.velocity.move_toward(Vector2.ZERO, friction * delta)
                move.move_and_slide()
            State.Move:
                move.velocity = move.global_position.direction_to(targetPosition).normalized() * speed
                move.move_and_slide()
            State.Knockback:
                move.velocity = knockback
                move.move_and_slide()
                knockback_runned += delta
                if (knockback_runned >= knockback_duration):
                    move.velocity = Vector2.ZERO
                    current_state = state_after_knockback

func start_movement():
    match current_state:
        State.Stop:
            current_state = State.Move
        State.Move:
            pass
        State.Knockback:
            state_after_knockback = State.Move

func stop_movement():
    match current_state:
        State.Stop:
            pass
        State.Move:
            current_state = State.Stop
        State.Knockback:
            state_after_knockback = State.Stop

func move_to(target:Vector2):
    self.targetPosition = target
    match current_state:
        State.Stop:
            current_state = State.Move
        State.Move:
            pass
        State.Knockback:
            state_after_knockback = State.Move

func set_knockback(dir:Vector2, duration:float):
    self.knockback          = dir
    self.knockback_duration = duration
    self.knockback_runned   = 0.0
    match current_state:
        State.Stop:
            self.state_after_knockback = State.Stop
            self.current_state         = State.Knockback
        State.Move:
            self.state_after_knockback = State.Move
            self.current_state         = State.Knockback
        State.Knockback:
            pass