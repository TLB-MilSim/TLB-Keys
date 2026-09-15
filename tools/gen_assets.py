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


def key_layer(W, metal, dark, shine, outline=True):
    """A plain door key lying flat: bow on the left, bit at the bottom right."""
    s = W / 256
    img = Image.new("RGBA", (W, W), CLEAR)
    d = ImageDraw.Draw(img)

    def body(fill, g):
        g *= s
        d.ellipse([26 * s - g, 84 * s - g, 114 * s + g, 172 * s + g], fill=fill)
        d.rectangle([100 * s - g, 116 * s - g, 228 * s + g, 140 * s + g], fill=fill)
        for x0, x1, y1 in [(166, 180, 166), (188, 200, 156), (210, 228, 172)]:
            d.rectangle([x0 * s - g, 136 * s - g, x1 * s + g, y1 * s + g], fill=fill)

    if outline:
        body(dark, 4)
    body(metal, 0)
    if outline:
        d.ellipse([46 * s, 104 * s, 94 * s, 152 * s], fill=dark)
    d.ellipse([50 * s, 108 * s, 90 * s, 148 * s], fill=CLEAR)
    if outline:
        d.rectangle([104 * s, 120 * s, 222 * s, 125 * s], fill=shine)
        d.rectangle([112 * s, 131 * s, 224 * s, 134 * s], fill=dark)
    return img


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
    W = 256 * SS
    s = W / 256
    img = canvas(256)
    d = ImageDraw.Draw(img)
    metal, dark, shine = colours

    # Split ring through the bow, and the side tag hanging off it.
    d.line([(78 * s, 160 * s), (60 * s, 196 * s)], fill=(58, 60, 66, 255), width=int(7 * s))
    d.rounded_rectangle([14 * s, 186 * s, 110 * s, 244 * s], radius=int(12 * s), fill=(30, 30, 34, 255))
    d.rounded_rectangle([19 * s, 191 * s, 105 * s, 239 * s], radius=int(9 * s), fill=tag)
    d.ellipse([54 * s, 196 * s, 68 * s, 210 * s], fill=(30, 30, 34, 255))
    if master:
        star(d, 62 * s, 224 * s, 13 * s, WHITE)
    else:
        for y in (216, 226):
            d.line([(34 * s, y * s), (90 * s, y * s)], fill=(255, 255, 255, 200), width=int(3 * s))

    key = key_layer(W, metal, dark, shine).rotate(32, resample=Image.BICUBIC, center=(W / 2, W / 2))
    img = Image.alpha_composite(img, key)
    return save(img, 256, "items", name, shadow=True)


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
    img = key_layer(W, WHITE, WHITE, WHITE, outline=False).rotate(35, resample=Image.BICUBIC, center=(W / 2, W / 2))
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
    for angle, dx in ((60, -16), (35, 0), (10, 16)):
        k = key_layer(W, WHITE, WHITE, WHITE, outline=False).resize((int(W * 0.8), int(W * 0.8)), Image.LANCZOS)
        layer = Image.new("RGBA", (W, W), CLEAR)
        layer.paste(k, (int(W * 0.1 + dx * SS), int(W * 0.1)), k)
        img = Image.alpha_composite(img, layer.rotate(angle, resample=Image.BICUBIC, center=(W / 2, W / 2)))
    return save(img, 128, "modules", "module_keyset_ca")


def module_master():
    W = 128 * SS
    img = key_layer(W, WHITE, WHITE, WHITE, outline=False).rotate(35, resample=Image.BICUBIC, center=(W / 2, W / 2))
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
    items += [icon_key(), icon_master(), icon_give(), icon_lock("icon_lock_ca", False),
              icon_lock("icon_unlock_ca", True), icon_fob(), icon_pick()]
    items += [module_keyset(), module_master(), module_lock()]
    items += logo()
    convert(items)
    chirp("fob_lock", [(2900, 0.07, 0.06), (2900, 0.07, 0.0)])
    chirp("fob_unlock", [(2500, 0.13, 0.0)])
