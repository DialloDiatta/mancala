



class_name SignalLensDebugger
extends EditorDebuggerPlugin



signal started


signal received_node_data_from_remote(data)


signal received_signal_emission_from_remote(data)


signal requested_node_data_from_remote(node_path: NodePath)



signal breaked



signal continued



signal stopped



var current_session_id: int = 0



const DEBUGGER_MESSAGE_PREFIX: = "signal_lens"


func request_node_data_from_remote(node_path: NodePath):
    get_session(current_session_id).send_message("signal_lens:node_signal_data_requested", [node_path])
    requested_node_data_from_remote.emit(node_path)


func setup_editor_panel(editor_panel: SignalLensEditorPanel):
    get_session(current_session_id).add_session_tab(editor_panel)



func _has_capture(prefix) -> bool:
    return prefix == DEBUGGER_MESSAGE_PREFIX


func _capture(message, data, session_id) -> bool:
    if message == "signal_lens:incoming_node_signal_data":
        received_node_data_from_remote.emit(data)
        return true
    elif message == "signal_lens:incoming_node_signal_emission":
        received_signal_emission_from_remote.emit(data)
        return true
    return false


func _setup_session(session_id):
    current_session_id = session_id
    var session = get_session(current_session_id)
    session.started.connect(_on_session_started)
    session.stopped.connect(_on_session_stopped)
    session.breaked.connect(_on_session_breaked)
    session.continued.connect(_on_session_continued)

func _on_session_started(): started.emit()
func _on_session_stopped(): stopped.emit()
func _on_session_breaked(can_debug: bool): breaked.emit(can_debug)
func _on_session_continued(): continued.emit()
