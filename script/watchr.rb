watch('app/views/assets/show.html.haml') { |md| system "osascript -e 'tell application \"Firefox\"' -e activate -e 'open location \"http://localhost:3000/assets/6\"' -e 'end tell' -e 'tell app \"System Events\"' -e 'keystroke \"r\" using {command down}' -e 'end tell'" }