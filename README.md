# psflex-status-setter

### Motivation ###

With the implementation of the PSFlex program, it is important to keep your Slack status updated so coworkers know if they can find you in the office.  This can be a chore to remember, so I wanted to automate this process so that you don't have to remember every time you switch between WFH or the office.

### How It Works ###

Once you've successfully run the app and input your settings, you should be good to go!  Your computer will monitor any network changes during your work hours.  If you are in the office, your computer will detect the 'POPSUGAR' network and set your status to 'In the Office.'  If you are using any other network, your status will be set to 'Working Remotely.'  You can always manually change your status if you like, just be aware that any time your network changes during work hours it will set your status based on if you are using the office wifi network or not.

### Requesting a Slack Token ###

You will need to get a slack token so that the API knows which user to update the status for.  You can do so here https://api.slack.com/custom-integrations/legacy-tokens by clicking the 'Create token' button.

### Installation ###

1. Download the zip file for this repository and unzip the file.
2. Douple click the PSFlex Status Setter application file to run the application.
3. Input the slack token you previously generated at the link shown above.
4. Input your typical start and end times for your work day in military time. (i.e. 17 for 5pm).
5. Never worry about remembering to set your slack status again!

If you are in the office you can test that the installation was successful by switching to a network other than 'POPSUGAR,' 'POPSUGAR Guest' for example, and switching back.  If your status changed to 'Working Remotely' and back to 'In the Office' your installation was successful!

### Engineers ###

For engineers or command line comfortable employees, you can simply clone the repository, move into the directory, run the script with `sh psflex_status_setter.sh`, then input your token and start/end times.
