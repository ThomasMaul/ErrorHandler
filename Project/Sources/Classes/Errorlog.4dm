Class extends DataClass

Function create($message : Text)
	$ent:=This:C1470.new()
	$ent.issue:=$message
	$ent.date:=Timestamp:C1445
	$ent.user:=Current user:C182
	$ent.save()
	