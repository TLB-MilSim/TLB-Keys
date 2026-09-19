# -*- coding: utf-8 -*-
"""Builds the GitHub wiki pages from this repository.

Images come from docs/images in the repository, so a screenshot is added once
and both the wiki and the Steam Workshop description can use it.

    python tools/build_wiki.py [output folder]

The pages that are the same as the repository's documentation are generated
from docs/ and CHANGELOG.md, so the wiki and the repository cannot drift
apart. The pages that only exist on the wiki - Home, Quick Start, the sidebar
and the footer - live in tools/wiki/.

Output defaults to .wiki-build next to the addons; point it at a clone of
https://github.com/TLB-MilSim/TLB-Keys.wiki.git to publish:

    git clone https://github.com/TLB-MilSim/TLB-Keys.wiki.git
    python tools/build_wiki.py TLB-Keys.wiki
    cd TLB-Keys.wiki && git add -A && git commit && git push

Screenshots are read from the repository, so the wiki clone needs no images.
"""
import os
import re
import shutil
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
STATIC = os.path.join(ROOT, "tools", "wiki")
OUT = sys.argv[1] if len(sys.argv) > 1 else os.path.join(ROOT, ".wiki-build")
RAW = "https://raw.githubusercontent.com/TLB-MilSim/TLB-Keys/main/docs/images/"

# Documentation links become wiki page links.
LINKS = {
    "(settings.md)": "(Settings)",
    "(guide.md)": "(Player-Guide)",
    "(mission-making.md)": "(Mission-Making)",
    "(how-it-works.md)": "(How-It-Works)",
    "(CHANGELOG.md)": "(Changelog)",
    "(../README.md)": "(Home)",
    "(README.md)": "(Home)",
}

# Screenshots dropped in under a heading of the player guide.
SHOTS = {
    "## The keys": ("keys-in-the-arsenal.png", "The ACE Arsenal list: Key Fob, master keys and vehicle keys for each side", 360),
    "## Locking a vehicle for the first time": ("lock-a-vehicle.jpg", "Lock for BLUFOR, Lock for my squad, Lock to my key and Check lock"),
    "## Managing a vehicle": ("manage-keys.jpg", "Manage keys: Opens for, Cut keys, Change locks, Name vehicle, Release vehicle"),
    "## Your own keys": ("my-keys-menu.jpg", "The player's own Vehicle Keys menu listing a master key, a cut vehicle key and a key fob"),
    "## Key fobs": ("program-a-fob.jpg", "Manage keys, Cut keys, Program Key Fob (blank)"),
    "## Key bindings and key slots": ("key-bindings.png", "Controls, Configure Addons, TLB Keys: lock/unlock nearest vehicle and three key slots"),
    "## Lockpicking and hotwiring": ("pick-lock.jpg", "Vehicle Keys, Pick lock, With Lock Pick Kit on a locked vehicle"),
    "### Hotwiring from the driver's seat": ("hotwire.jpg", "Vehicle Keys, Hotwire from the driver's seat"),
    "## Handing keys to other players": ("hand-over-key.jpg", "Hand over key on another player, listing the keys carried"),
}


def convert(text, title):
    """One documentation page as a wiki page."""
    text = text.replace("[← Back to README](../README.md)\n\n", "").replace("[← Back to README](README.md)\n\n", "")
    for old, new in LINKS.items():
        text = text.replace(old, new)
    text = text.replace('src="images/', 'src="' + RAW).replace("](images/", "](" + RAW)
    text = text.replace('src="docs/images/', 'src="' + RAW).replace("](docs/images/", "](" + RAW)
    return re.sub(r"\A# .*\n", "# " + title + "\n", text, count=1)


def shots(text):
    """Screenshots are 820 wide unless the entry gives a width of its own."""
    for heading, shot in SHOTS.items():
        image, alt = shot[0], shot[1]
        width = str(shot[2]) if len(shot) > 2 else "820"
        block = heading + '\n\n<img src="' + RAW + image + '" alt="' + alt + '" width="' + width + '">\n'
        text = text.replace(heading + "\n", block, 1)
    return text


def split_troubleshooting(text):
    """The guide's troubleshooting section also becomes its own page."""
    index = text.index("## Troubleshooting")
    page = text[index:].replace("## Troubleshooting", "# Troubleshooting", 1).rstrip() + (
        "\n\nStill stuck? The [Player Guide](Player-Guide) explains each feature in full,"
        " and [Settings](Settings) lists what a server can switch off.\n"
    )
    guide = text[:index].rstrip() + (
        "\n\n## Troubleshooting\n\nMoved to its own page: **[Troubleshooting](Troubleshooting)**.\n"
    )
    guide = guide.replace("- [Troubleshooting](#troubleshooting)", "- [Troubleshooting](Troubleshooting)")
    return guide, page


def fobs_page(text):
    """Key fobs and key bindings, pulled out of the guide for quick reference."""
    body = text[text.index("## Key fobs"):text.index("## Handing keys to other players")].rstrip()
    return (
        "# Key Fobs and Key Bindings\n\n"
        "Two ways to lock a vehicle without walking into the ACE menu: a key fob"
        " that works from a distance, and key bindings that work on the vehicle"
        " in front of you.\n\n" + body + "\n\n"
        "---\n\nEverything else a key can do is in the [Player Guide](Player-Guide).\n"
    )


def read(*parts):
    return open(os.path.join(ROOT, *parts), encoding="utf-8").read().replace("\r\n", "\n")


os.makedirs(OUT, exist_ok=True)

guide = shots(convert(read("docs", "guide.md"), "Player Guide"))
fobs = fobs_page(guide)
guide, trouble = split_troubleshooting(guide)

pages = {
    "Player-Guide.md": guide,
    "Troubleshooting.md": trouble,
    "Key-Fobs-and-Key-Bindings.md": fobs,
    "Settings.md": convert(read("docs", "settings.md"), "Settings"),
    "Mission-Making.md": convert(read("docs", "mission-making.md"), "Mission Making"),
    "How-It-Works.md": convert(read("docs", "how-it-works.md"), "How It Works"),
    "Changelog.md": convert(read("CHANGELOG.md"), "Changelog"),
}

for name, body in pages.items():
    with open(os.path.join(OUT, name), "w", encoding="utf-8", newline="\n") as f:
        f.write(body)
    print("generated", name)

for name in sorted(os.listdir(STATIC)):
    if name.endswith(".md"):
        shutil.copyfile(os.path.join(STATIC, name), os.path.join(OUT, name))
        print("copied   ", name)

print("wiki pages in", OUT)
