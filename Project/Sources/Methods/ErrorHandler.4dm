//%attributes = {}
/* Generic Error handler
install using ON ERR CALL in On Startup, ON WEB AUTHENTICATON, ON SQL AUTHENTICATION, ON REST AUTHENTICATION
and every process or worker you start, as first line of that process/worker_init

The job consists of several parts
#1 collect all available info about the 4D error
#2 enhance with application data, such as your module/table name, user name
#3 you might want to add system info, such as OS type/version
#4 display using DIALOG if there is an user, hide on server/service clients/web
#5 in the dialog allow the end user to describe what he last did as text
#6 store as log in a record
#7 send as email to admin/developer
*/


$line:=" Line: "  // you might want to translate, such as "Zeile: "
ARRAY TEXT:C222($arrtext1; 0)
ARRAY TEXT:C222($arrtext2; 0)
ARRAY LONGINT:C221($arrerr1; 0)
GET LAST ERROR STACK:C1015($arrerr1; $arrtext1; $arrtext2)

$errormessage:=error method+$line+String:C10(error line)+Char:C90(13)
For ($i; 1; Size of array:C274($arrerr1))
	$errormessage+=($arrtext2{$i}+" ("+String:C10($arrerr1{$i})+") "+$arrtext1{$i}+Char:C90(13))
End for 

C_COLLECTION:C1488($chain)
$chain:=Get call chain:C1662
$errormessage+=(Char:C90(13)+Char:C90(13))
C_OBJECT:C1216($call)
For each ($call; $chain)
	$errormessage+=($call.type+": "+$call.name+$line+String:C10($call.line)+Char:C90(13))
End for each 

$errormessage+=("Error Formula: "+Error formula)
$errormessage+=Char:C90(13)

//MARK: #2-add application data
$errormessage+=("User: "+Current user:C182)  // ### modify this if you don't use SET USER ALIAS
// add your own application data, such as module/status data
//MARK: #3-add OS data
// add computer info if needed, such as Mac/Win, system info, etc

//MARK: #4-display dialog
If (Application type:C494=4D Server:K5:6)
	// hide dialog on Server - handle/detect here also service clients if you use them...
Else 
	$form:=New object:C1471
	$form.errormessage1:=$errormessage
	$form.errormessage2:=""
	$ref:=Open form window:C675("ErrorReport"; Modal dialog:K27:2+Form has no menu bar:K39:18)
	DIALOG:C40("ErrorReport"; $form)
	CLOSE WINDOW:C154($ref)
	If (OK=1)
		ABORT:C156
	End if 
End if 

//MARK: #6 - store in table
ds:C1482.Errorlog.create($errormessage+Char:C90(13)+Char:C90(13)+$form.errormessage2)

//MARK: #7 - send as email
// to use SendMail, you need to modify the method to set password, email server, email addresses, etc
If (False:C215)
	SendMail($errormessage+Char:C90(13)+Char:C90(13)+$form.errormessage2)
End if 