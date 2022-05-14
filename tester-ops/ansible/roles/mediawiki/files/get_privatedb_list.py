#! /usr/bin/python3

import requests, sys

def main():
    # Don't support Python 2.x
    if sys.version < '3':
        return

    # Download the database list
    r = requests.get("https://meta.orain.org/w/index.php?title=Database_list/Private&action=raw")

    # Return if the download wasn't successful (e.g. site is broken)
    if r.status_code != 200:
        return

    # Remove the <pre> formatting tags and trailing newline
    text = r.text.replace('<pre>\n', '').replace('</pre>', '').rstrip('\n')

    # Write to a file to be read by our settings
    with open("/srv/mediawiki/w/private.dblist", "w") as db_list:
        db_list.write(text)

if __name__ == "__main__":
    main()

