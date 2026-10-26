class_name DLine extends Resource

var speaker: DialogManager.Speaker
var text: String

func _init(p_text: String, p_speaker: String = "customer"):
	speaker = DialogManager.Speaker.CUSTOMER
	if p_speaker == "protag":
		speaker = DialogManager.Speaker.PROTAG
		
	text = p_text
