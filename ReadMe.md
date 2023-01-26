# Generic Error Handler

### Best Practice
It is mandatory to have an error handler always running.
Not to install one when you think code might fail, it must run all the time for every code, every process, on client or server.

### Job description
The error handler should fetch as much information as possible about the error itself, the context and the environment.

It should log these data (either as database record or as text file) in all cases - and not just presenting it to the end user and hoping that the end user reports it correctly as bug/issue. It might send the data as email to admin/developer. It might display these data to the user in front of the computer as dialog (and of course hide it always on a server computer).

### Data to collect
- 4D Error context
- System info
- Application info

#### 4D Error context
- 4D Error description (as record could not be saved)
- Error stack (very important, record could not be saved - hard disk full)
- Call chain (stack of called methods to understand code context)
- Error line number (to quickly find the line in the method)
- Error line content (=formula, not mandatory as you could check code, but helpful)

#### System info
- Platform, Architecture
- OS Version
- additional info such as headless, network status, etc, depending of environment, depending about how good you know the installation and what you might need to retrieve

#### Application info
Data about your own application. User name, that could be 4D's command Current User or your own user record data. Module name (such as invoice, client, shipping), any information available about the context/status of your application, which might be helpful to identify/understand the reason for the error.

You could consider to create a screenshot (using FORM GET SCREENSHOT or via LAUNCH EXTERNAL PROCESS). The build in screenshot handles the front most window, which reduces issues about private data. External screenshots allow to handle the whole monitor, which could be helpful, but could produce conflicts with Data Privacy officiers and with unions, so it needs to be carefully checked upfront.

### Error Dialog

Except for a server or service clients, you will present the error on screen as dialog. You might want to design it similar to 4D's build in dialog, if you have technically skilled users, but in most cases, it is better to display only a fragment of the collected data. Call chain, Error formula or line numbers are totally useless information for the end user, only increasing confusion.
Usually it is better to focus on the Error stack, such as:

- Error writing 
- Error creating File "E:\path\export.txt"
- Error Hard disk is full

Displaying just the last error is often not helpful, while the stack helps to understand the reason for an issue. If not for the end user in front of the screen, but at least for an admin or more technical skilled person.

### How to install error handler
The error handler is installed using the command 
`ON ERR CALL(Formula(ErrorHandler).source; ek global)`
or
`ON ERR CALL("ErrorHandler"; ek global)`
The command only impacts the current running process, as such it must be called several times.

Call it directly, at the very beginning, of On Startup and On Server Startup.


### Example

the example shows a such an error handler, collecting information about the 4D error status, about the system, etc and presenting that as dialog on screen (except if running on 4D Server). It also logs the message in table "ErrorLog" for history and late checking.
Optionally it allows to send it as email (then you need to setup your email account credentials).

Use it as a template and adapt it to the need of your customer - some will like a screenshot, other will hate that idea.
Collecting infos such as free space on all hard disks might slow down for network disks, some customers might see that as private information.


That's why there is no general answer what to collect. As developer we want as much as possible, but customers/unions sometimes see that different, you need to discuss that with your customer upfront.