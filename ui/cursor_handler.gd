extends Control
class_name CursorHandler

@onready var parent = $"../.."

func _ready():
    SignalHandler.update_cursor.connect(_update_cursor)



func _update_cursor(bead_resource: Bead):
    if bead_resource:
        Input.set_custom_mouse_cursor(bead_resource.texture)
    else:
        Input.set_custom_mouse_cursor(null)
