extends Node2D

func _process(_delta):
    if Input.is_action_pressed("ui_cancel"):
        get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
        get_tree().quit()
