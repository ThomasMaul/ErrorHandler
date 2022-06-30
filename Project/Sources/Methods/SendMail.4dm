//%attributes = {}
// Send an email as bug/error report
// this examples uses preset values
// in real live - most already have such a method, which already
// knows about SMTP Server, authentication, receiver and sender email address

// if you do not have one, see:
// https://blog.4d.com/a-new-way-to-send-mails/


#DECLARE($message : Text)

// send the message...


$email:=New object:C1471
$email.from:="noreply.mail@4d.com"
$email.to:="noreply.mail@4d.com"
$email.subject:="Error report"
$email.textBody:=$message

$smtp:=New object:C1471
$smtp.host:="smtp.hostname"
$smtp.port:=25
$smtp.user:="User"
$smtp.password:="Password"
$smtpTransporter:=SMTP New transporter:C1608($smtp)

$status:=$smtpTransporter.send($email)