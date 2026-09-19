# -*- coding: utf-8 -*-
"""Textures, icons and sounds for TLB Keys.

    python tools/gen_assets.py

Inventory pictures are 256x256, menu and module icons 128x128, all drawn at 4x
and downsampled, then converted to PAA with ImageToPAA from Arma 3 Tools. The
key fob chirps are written as 16-bit WAV.
"""
import math
import os
import shutil
import struct
import subprocess
import wave

from PIL import Image, ImageDraw, ImageFilter, ImageFont

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
PNG = os.path.join(ROOT, "tools", ".png")
ADDONS = os.path.join(ROOT, "addons")
SS = 4
os.makedirs(PNG, exist_ok=True)

# Arma's own side colours: BLUFOR blue, OPFOR red, Independent green, Civilian purple.
SIDES = {
    "west": (38, 104, 204, 255),
    "east": (196, 38, 38, 255),
    "indep": (38, 150, 64, 255),
    "civ": (128, 52, 164, 255),
}

STEEL = ((200, 204, 210, 255), (58, 60, 66, 255), (240, 242, 246, 255))
BRASS = ((222, 178, 70, 255), (92, 64, 18, 255), (252, 228, 150, 255))
WHITE = (255, 255, 255, 255)
CLEAR = (0, 0, 0, 0)


def canvas(size):
    return Image.new("RGBA", (size * SS, size * SS), CLEAR)


def save(img, size, addon, name, shadow=False):
    if shadow:
        blur = Image.new("RGBA", img.size, CLEAR)
        blur.putalpha(img.split()[3].filter(ImageFilter.GaussianBlur(4 * SS)).point(lambda v: v // 2))
        img = Image.alpha_composite(blur, img)
    img.resize((size, size), Image.LANCZOS).save(os.path.join(PNG, name + ".png"))
    return (addon, name)


HEAD = (30, 31, 35, 255)
HEAD_RIM = (74, 76, 84, 255)
HEAD_EDGE = (8, 8, 10, 255)
KEY_HOLE = (34, 128)  # where the ring goes, before rotation


def key_layer(W, metal, dark, shine, outline=True, emblem=None):
    """A car key lying flat, like the ones on the mod logo: a black rubber head
    with the ring hole on the left, a notched blade with a groove to the right.
    With outline off it is a plain silhouette in the metal colour, for the
    white menu and module icons."""
    s = W / 256
    img = Image.new("RGBA", (W, W), CLEAR)
    d = ImageDraw.Draw(img)

    def p(pts):
        return [(x * s, y * s) for x, y in pts]

    # Blade: wavy cuts along both edges, the tip bevelled.
    top = [(104, 114), (120, 114), (127, 121), (135, 114), (146, 114), (153, 121), (161, 114),
           (172, 114), (179, 121), (187, 114), (199, 114), (206, 121), (213, 114), (222, 117)]
    bottom = [(222, 141), (213, 142), (207, 136), (199, 142), (187, 142), (181, 135), (172, 142),
              (161, 142), (155, 135), (146, 142), (131, 142), (125, 135), (118, 142), (104, 142)]
    blade = p(top + [(238, 129)] + bottom)
    if outline:
        d.polygon(blade, fill=metal, outline=dark, width=int(3 * s))
        d.line(p([(110, 128), (220, 128)]), fill=dark, width=int(3 * s))
        d.line(p([(108, 119), (200, 119)]), fill=shine, width=int(2 * s))
    else:
        d.polygon(blade, fill=metal)
        d.line(p([(112, 128), (216, 128)]), fill=CLEAR, width=int(4 * s))

    # Collar where the blade meets the head.
    d.rounded_rectangle(p([(92, 106), (110, 150)]), radius=int(4 * s),
                        fill=HEAD_EDGE if outline else metal)

    # Rubber head.
    if outline:
        d.rounded_rectangle(p([(14, 86), (102, 170)]), radius=int(24 * s), fill=HEAD_EDGE)
        d.rounded_rectangle(p([(18, 90), (98, 166)]), radius=int(21 * s), fill=HEAD)
        d.rounded_rectangle(p([(24, 96), (92, 160)]), radius=int(17 * s), outline=HEAD_RIM, width=int(2 * s))
        # Grip ridges on the back of the head.
        for y in (106, 116, 140, 150):
            d.line(p([(58, y), (86, y)]), fill=HEAD_RIM, width=int(2 * s))
        if emblem:
            star(d, 72 * s, 128 * s, 13 * s, emblem)
    else:
        d.rounded_rectangle(p([(18, 90), (98, 166)]), radius=int(21 * s), fill=metal)

    hx, hy = KEY_HOLE
    if outline:
        d.ellipse(p([(hx - 11, hy - 11), (hx + 11, hy + 11)]), fill=HEAD_EDGE)
    d.ellipse(p([(hx - 8, hy - 8), (hx + 8, hy + 8)]), fill=CLEAR)
    return img


def rotated(point, angle, centre=(128, 128)):
    """Where a point of a layer lands after Image.rotate(angle) about centre."""
    a = math.radians(angle)
    dx, dy = point[0] - centre[0], point[1] - centre[1]
    return (centre[0] + dx * math.cos(a) + dy * math.sin(a),
            centre[1] - dx * math.sin(a) + dy * math.cos(a))


def star(d, cx, cy, r, fill):
    pts = []
    for i in range(10):
        a = math.radians(-90 + i * 36)
        rr = r if i % 2 == 0 else r * 0.45
        pts.append((cx + rr * math.cos(a), cy + rr * math.sin(a)))
    d.polygon(pts, fill=fill)


def padlock(d, cx, cy, size, fill, open_=False, hole=CLEAR, width=None):
    """Padlock centred on (cx, cy). size is the body width."""
    w = width or size * 0.16
    r = size * 0.32
    lift = size * 0.28 if open_ else 0
    top = cy - size * 0.62 - lift
    body_top = cy - size * 0.1
    d.arc([cx - r, top, cx + r, top + 2 * r], 180, 360, fill=fill, width=int(w))
    d.line([(cx - r + w / 2, top + r), (cx - r + w / 2, body_top + (0 if not open_ else -size * 0.2))], fill=fill, width=int(w))
    d.line([(cx + r - w / 2, top + r), (cx + r - w / 2, body_top)], fill=fill, width=int(w))
    d.rounded_rectangle([cx - size / 2, body_top, cx + size / 2, cy + size * 0.5], radius=int(size * 0.1), fill=fill)
    d.ellipse([cx - size * 0.08, cy + size * 0.06, cx + size * 0.08, cy + size * 0.22], fill=hole)
    d.rectangle([cx - size * 0.035, cy + size * 0.16, cx + size * 0.035, cy + size * 0.34], fill=hole)


# --- Inventory pictures ------------------------------------------------------

def item_key(name, colours, tag, master=False):
    """A car key hanging from a split ring, with a stitched fabric tag in the
    side's colour. Master keys have a brass blade and a gold star."""
    W = 256 * SS
    s = W / 256
    angle = -45
    shift = 16  # the hanging key sits top-left of its square; move it to the middle
    metal, dark, shine = colours
    pivot = rotated(KEY_HOLE, angle)
    ring = (pivot[0] + shift, pivot[1] + shift)

    # Fabric tag hanging from the ring, behind the key.
    tag_layer = Image.new("RGBA", (W, W), CLEAR)
    t = ImageDraw.Draw(tag_layer)
    edge = tuple(int(c * 0.55) for c in tag[:3]) + (255,)
    t.rounded_rectangle([42 * s, 70 * s, 80 * s, 186 * s], radius=int(9 * s), fill=edge)
    t.rounded_rectangle([45 * s, 73 * s, 77 * s, 183 * s], radius=int(7 * s), fill=tag)
    # Stitching around the edge, and the loop sewn over the ring.
    stitch = (236, 226, 196, 230)
    for x0, y0, x1, y1 in [(50, 94, 50, 176), (72, 94, 72, 176), (50, 176, 72, 176)]:
        steps = int(max(abs(x1 - x0), abs(y1 - y0)) / 7)
        for i in range(steps):
            a, b = i / steps, (i + 0.55) / steps
            t.line([((x0 + (x1 - x0) * a) * s, (y0 + (y1 - y0) * a) * s),
                    ((x0 + (x1 - x0) * b) * s, (y0 + (y1 - y0) * b) * s)], fill=stitch, width=int(2 * s))
    t.line([(46 * s, 88 * s), (76 * s, 88 * s)], fill=edge, width=int(3 * s))
    if master:
        star(t, 61 * s, 134 * s, 12 * s, (250, 214, 90, 255))
    tag_layer = tag_layer.rotate(-14, resample=Image.BICUBIC, center=(pivot[0] * s, pivot[1] * s),
                                 translate=(shift * s, shift * s))

    img = Image.alpha_composite(canvas(256), tag_layer)
    key = key_layer(W, metal, dark, shine, emblem=(222, 178, 70, 255) if master else None)
    img = Image.alpha_composite(img, key.rotate(angle, resample=Image.BICUBIC, center=(W / 2, W / 2),
                                                translate=(shift * s, shift * s)))

    # Split ring through the head's hole.
    d = ImageDraw.Draw(img)
    r = 19
    box = [(ring[0] - r) * s, (ring[1] - r) * s, (ring[0] + r) * s, (ring[1] + r) * s]
    d.ellipse(box, outline=STEEL[1], width=int(9 * s))
    d.ellipse([box[0] + 2 * s, box[1] + 2 * s, box[2] - 2 * s, box[3] - 2 * s], outline=STEEL[0], width=int(5 * s))
    d.arc([box[0] + 3 * s, box[1] + 3 * s, box[2] - 3 * s, box[3] - 3 * s], 200, 290, fill=STEEL[2], width=int(2 * s))
    return save(img, 256, "items", name, shadow=True)


def item_lockpick():
    """The lock pick kit: picks fanned out of a leather pouch, with a tension
    wrench across the front. Used when TLB Interactions is not loaded."""
    W = 256 * SS
    s = W / 256
    img = canvas(256)
    metal, dark, _ = STEEL

    for angle, kind in ((-34, "hook"), (-14, "rake"), (6, "diamond"), (26, "hook")):
        layer = Image.new("RGBA", (W, W), CLEAR)
        ld = ImageDraw.Draw(layer)
        x = 128 * s
        ld.rectangle([x - 5 * s, 40 * s, x + 5 * s, 190 * s], fill=dark)
        ld.rectangle([x - 3 * s, 42 * s, x + 3 * s, 190 * s], fill=metal)
        if kind == "hook":
            ld.line([(x, 44 * s), (x - 12 * s, 30 * s), (x - 14 * s, 20 * s)], fill=metal, width=int(6 * s), joint="curve")
        elif kind == "rake":
            ld.line([(x, 44 * s), (x - 8 * s, 36 * s), (x, 28 * s), (x - 8 * s, 20 * s), (x, 12 * s)], fill=metal, width=int(5 * s), joint="curve")
        else:
            ld.polygon([(x - 3 * s, 44 * s), (x - 12 * s, 26 * s), (x + 3 * s, 18 * s), (x + 3 * s, 44 * s)], fill=metal)
        img = Image.alpha_composite(img, layer.rotate(-angle, resample=Image.BICUBIC, center=(128 * s, 200 * s)))

    d = ImageDraw.Draw(img)
    # Tension wrench across the front.
    d.line([(58 * s, 150 * s), (58 * s, 128 * s), (150 * s, 128 * s)], fill=(40, 40, 42, 255), width=int(10 * s), joint="curve")
    d.line([(58 * s, 150 * s), (58 * s, 128 * s), (150 * s, 128 * s)], fill=(150, 152, 150, 255), width=int(6 * s), joint="curve")
    # Leather pouch.
    d.rounded_rectangle([40 * s, 150 * s, 216 * s, 236 * s], radius=int(14 * s), fill=(58, 38, 24, 255))
    d.rounded_rectangle([46 * s, 156 * s, 210 * s, 230 * s], radius=int(10 * s), outline=(120, 86, 52, 255), width=int(3 * s))
    d.rounded_rectangle([40 * s, 150 * s, 216 * s, 172 * s], radius=int(8 * s), fill=(76, 52, 32, 255))
    for i in range(14):
        xx = (54 + i * 11.5) * s
        d.line([(xx, 162 * s), (xx + 5 * s, 162 * s)], fill=(150, 116, 72, 255), width=int(2 * s))

    return save(img, 256, "items", "lockpick_ca", shadow=True)


def item_fob():
    W = 256 * SS
    s = W / 256
    img = canvas(256)
    d = ImageDraw.Draw(img)
    metal, dark, _ = STEEL

    d.ellipse([104 * s, 14 * s, 152 * s, 62 * s], outline=dark, width=int(12 * s))
    d.ellipse([106 * s, 16 * s, 150 * s, 60 * s], outline=metal, width=int(7 * s))
    d.rounded_rectangle([78 * s, 50 * s, 178 * s, 242 * s], radius=int(34 * s), fill=(22, 23, 26, 255))
    d.rounded_rectangle([84 * s, 56 * s, 172 * s, 236 * s], radius=int(29 * s), fill=(46, 48, 54, 255))
    for cy, open_ in ((116, False), (174, True)):
        d.ellipse([104 * s, (cy - 24) * s, 152 * s, (cy + 24) * s], fill=(24, 25, 28, 255))
        d.ellipse([107 * s, (cy - 21) * s, 149 * s, (cy + 21) * s], fill=(78, 80, 88, 255))
        padlock(d, 128 * s, (cy + 2) * s, 20 * s, (230, 232, 236, 255), open_=open_, hole=(78, 80, 88, 255))
    d.ellipse([122 * s, 212 * s, 134 * s, 224 * s], fill=(230, 40, 30, 255))
    return save(img, 256, "items", "fob_ca", shadow=True)


# --- ACE menu icons (white) --------------------------------------------------

def icon_key(name="icon_key_ca", addon="core", extra=None):
    W = 128 * SS
    img = key_layer(W, WHITE, WHITE, WHITE, outline=False).rotate(-45, resample=Image.BICUBIC, center=(W / 2, W / 2))
    if extra:
        extra(ImageDraw.Draw(img), W / 128)
    return save(img, 128, addon, name)


def icon_master():
    return icon_key("icon_master_ca", extra=lambda d, s: star(d, 96 * s, 30 * s, 26 * s, WHITE))


def icon_give():
    def arrow(d, s):
        d.line([(66 * s, 26 * s), (112 * s, 26 * s)], fill=WHITE, width=int(10 * s))
        d.polygon([(122 * s, 26 * s), (100 * s, 8 * s), (100 * s, 44 * s)], fill=WHITE)
    return icon_key("icon_give_ca", extra=arrow)


def icon_lock(name, open_):
    img = canvas(128)
    d = ImageDraw.Draw(img)
    s = SS
    padlock(d, 64 * s, 74 * s, 72 * s, WHITE, open_=open_)
    return save(img, 128, "core", name)


def icon_fob():
    img = canvas(128)
    d = ImageDraw.Draw(img)
    s = SS
    d.ellipse([50 * s, 2 * s, 78 * s, 30 * s], outline=WHITE, width=int(6 * s))
    d.rounded_rectangle([34 * s, 22 * s, 94 * s, 126 * s], radius=int(20 * s), fill=WHITE)
    for cy in (54, 90):
        d.ellipse([50 * s, (cy - 13) * s, 78 * s, (cy + 13) * s], fill=CLEAR)
    return save(img, 128, "core", "icon_fob_ca")


def icon_pick():
    img = canvas(128)
    d = ImageDraw.Draw(img)
    s = SS
    # Hook pick and tension wrench, crossed.
    d.rounded_rectangle([14 * s, 92 * s, 60 * s, 110 * s], radius=int(6 * s), fill=WHITE)
    d.line([(56 * s, 101 * s), (112 * s, 44 * s)], fill=WHITE, width=int(7 * s))
    d.line([(112 * s, 44 * s), (106 * s, 26 * s), (116 * s, 16 * s)], fill=WHITE, width=int(7 * s), joint="curve")
    d.line([(24 * s, 30 * s), (24 * s, 54 * s), (100 * s, 118 * s)], fill=WHITE, width=int(8 * s), joint="curve")
    return save(img, 128, "core", "icon_pick_ca")


# --- Module icons (white) ----------------------------------------------------

def module_keyset():
    W = 128 * SS
    img = canvas(128)
    # Three keys fanned out from one ring at the top left.
    s = W / 256
    hole = (KEY_HOLE[0] * s, KEY_HOLE[1] * s)
    ring = (30 * SS, 30 * SS)
    for angle in (-15, -45, -75):
        k = key_layer(W, WHITE, WHITE, WHITE, outline=False)
        img = Image.alpha_composite(img, k.rotate(angle, resample=Image.BICUBIC, center=hole,
                                                  translate=(ring[0] - hole[0], ring[1] - hole[1])))
    d = ImageDraw.Draw(img)
    d.ellipse([ring[0] - 14 * SS, ring[1] - 14 * SS, ring[0] + 14 * SS, ring[1] + 14 * SS], outline=WHITE, width=int(5 * SS))
    return save(img, 128, "modules", "module_keyset_ca")


def module_master():
    W = 128 * SS
    img = key_layer(W, WHITE, WHITE, WHITE, outline=False).rotate(-45, resample=Image.BICUBIC, center=(W / 2, W / 2))
    star(ImageDraw.Draw(img), 96 * SS, 30 * SS, 26 * SS, WHITE)
    return save(img, 128, "modules", "module_master_ca")


def module_lock():
    img = canvas(128)
    padlock(ImageDraw.Draw(img), 64 * SS, 74 * SS, 72 * SS, WHITE)
    return save(img, 128, "modules", "module_lock_ca")


# --- Mod logo ----------------------------------------------------------------

def logo():
    """The mod logo is artwork (tools/logo_source.png), only scaled here to the
    power-of-two sizes Arma wants, and copied to the docs."""
    src = Image.open(os.path.join(ROOT, "tools", "logo_source.png")).convert("RGBA")
    side = max(src.size)
    square = Image.new("RGBA", (side, side), CLEAR)
    square.paste(src, ((side - src.width) // 2, (side - src.height) // 2))

    square.resize((512, 512), Image.LANCZOS).save(os.path.join(ROOT, "docs", "images", "logo.png"))
    square.resize((256, 256), Image.LANCZOS).save(os.path.join(PNG, "logo_ca.png"))
    square.resize((64, 64), Image.LANCZOS).save(os.path.join(PNG, "logo_small_ca.png"))
    return [("main", "logo_ca"), ("main", "logo_small_ca")]


# --- Key fob chirps ------------------------------------------------------------

def chirp(name, beeps, rate=44100):
    frames = bytearray()
    for freq, dur, gap in beeps:
        n = int(dur * rate)
        for i in range(n):
            t = i / rate
            env = min(1.0, t / 0.004, (dur - t) / 0.02)
            v = math.sin(2 * math.pi * freq * t) + 0.35 * math.sin(4 * math.pi * freq * t)
            frames += struct.pack("<h", int(max(-1, min(1, v * 0.45 * env)) * 32767))
        frames += b"\0\0" * int(gap * rate)
    path = os.path.join(ADDONS, "core", "sounds", name + ".wav")
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with wave.open(path, "wb") as w:
        w.setnchannels(1)
        w.setsampwidth(2)
        w.setframerate(rate)
        w.writeframes(bytes(frames))
    print(name + ".wav ok")


def preview():
    """docs/images/items.png: every inventory picture in a row, labelled."""
    names = ["key_west_ca", "key_east_ca", "key_indep_ca", "key_civ_ca",
             "master_west_ca", "master_east_ca", "master_indep_ca", "master_civ_ca", "fob_ca"]
    labels = ["BLUFOR key", "OPFOR key", "Independent key", "Civilian key",
              "BLUFOR master", "OPFOR master", "Independent master", "Civilian master", "Key fob"]
    cell, pad = 180, 12
    sheet = Image.new("RGBA", (cell * len(names), cell + 34), (32, 34, 38, 255))
    d = ImageDraw.Draw(sheet)
    try:
        font = ImageFont.truetype(r"C:\Windows\Fonts\arial.ttf", 15)
    except OSError:
        font = ImageFont.load_default()
    for i, (name, label) in enumerate(zip(names, labels)):
        im = Image.open(os.path.join(PNG, name + ".png")).convert("RGBA").resize((cell - 2 * pad, cell - 2 * pad), Image.LANCZOS)
        sheet.alpha_composite(im, (i * cell + pad, pad))
        d.text((i * cell + cell / 2, cell + 12), label, font=font, fill=(220, 222, 226, 255), anchor="mm")
    sheet.convert("RGB").save(os.path.join(ROOT, "docs", "images", "items.png"))
    print("items.png ok")


def convert(items):
    candidates = [
        r"E:\SteamLibrary\steamapps\common\Arma 3 Tools\ImageToPAA\ImageToPAA.exe",
        r"C:\Program Files (x86)\Steam\steamapps\common\Arma 3 Tools\ImageToPAA\ImageToPAA.exe",
    ]
    tool = next((c for c in candidates if os.path.exists(c)), shutil.which("ImageToPAA"))
    if not tool:
        print("ImageToPAA not found - PNGs left in", PNG)
        return
    for addon, name in items:
        folder = os.path.join(ADDONS, addon, "data")
        os.makedirs(folder, exist_ok=True)
        dst = os.path.join(folder, name + ".paa")
        if os.path.exists(dst):
            os.remove(dst)
        subprocess.run([tool, os.path.join(PNG, name + ".png"), dst], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        print(addon, name, "ok" if os.path.exists(dst) else "FAILED")


if __name__ == "__main__":
    items = []
    for side, colour in SIDES.items():
        items.append(item_key("key_%s_ca" % side, STEEL, colour))
        items.append(item_key("master_%s_ca" % side, BRASS, colour, master=True))
    items.append(item_fob())
    items.append(item_lockpick())
    items += [icon_key(), icon_master(), icon_give(), icon_lock("icon_lock_ca", False),
              icon_lock("icon_unlock_ca", True), icon_fob(), icon_pick()]
    items += [module_keyset(), module_master(), module_lock()]
    items += logo()
    convert(items)
    preview()
    chirp("fob_lock", [(2900, 0.07, 0.06), (2900, 0.07, 0.0)])
    chirp("fob_unlock", [(2500, 0.13, 0.0)])
