extends PanelContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	_setup_line_edit_float("box/Left")
	_setup_line_edit_float("box/Right")

var max_val=2700



func get_val(_key):
	return lineedit_vals[_key]

func get_item():
	return get_node("box/Item").text

var lineedit_vals={}

func _setup_line_edit_float(_path):
	var _line_edit=get_node(_path)
	lineedit_vals[_path]=0 if not _line_edit.text.is_valid_float() else _line_edit.text.to_float()
	_line_edit.text_changed.connect(__on_text_changed.bind(_path))
	_line_edit.focus_exited.connect(__on_focus_exited.bind(_path))


func __on_text_changed(new_text,_path):
	if get_node(_path).has_focus():
		if new_text.is_valid_float():
			var f=new_text.to_float()
			if f>=0 and f<=max_val:
				print(f)
				lineedit_vals[_path]=f


func __on_focus_exited(_path):
	get_node(_path).text=str(lineedit_vals[_path])
	print("exit")
