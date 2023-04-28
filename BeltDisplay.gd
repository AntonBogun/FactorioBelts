extends PanelContainer


var end
var val
var Left
var Right
var Name
func format_float(value):
	#two decimal places
	return "%0.3f%s" % [value, end]

func update(_val=null, _end=null):
	if(_end != null):
		end = _end
	if(_val != null):
		val = _val
	Left.text = format_float(val[0])
	Right.text = format_float(val[1])

func update_Name(_name):
	Name.text = _name

func init(_name, _val, _end, is_horizontal=false):
	var box
	var sep
	if(is_horizontal):
		box= HBoxContainer.new()
		sep = VSeparator
	else:
		box= VBoxContainer.new()
		sep = HSeparator
	box.add_child(Label.new())
	box.add_child(sep.new())
	box.add_child(Label.new())
	box.add_child(sep.new())
	box.add_child(Label.new())
	add_child(box)
	Left = box.get_child(0)
	Right = box.get_child(2)
	Name = box.get_child(4)

	Name.text = _name
	update(_val, _end)
	return update
