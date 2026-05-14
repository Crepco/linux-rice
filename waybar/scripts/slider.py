#!/usr/bin/env python3
import sys
import subprocess
import tkinter as tk

mode  = sys.argv[1] if len(sys.argv) > 1 else "volume"
title = sys.argv[2] if len(sys.argv) > 2 else "Volume"
val   = int(sys.argv[3]) if len(sys.argv) > 3 else 50

BG    = "#0d0d15"
PINK  = "#ff4081"
CYAN  = "#64c8ff"
TEXT  = "#ffffff"
TRACK = "#1c1c32"

root = tk.Tk()
root.title(title)
root.configure(bg=BG)
root.resizable(False, False)
root.attributes("-topmost", True)
root.geometry("360x80")

def close(e=None):
    root.destroy()

# Value label
val_label = tk.Label(root, text=f"{val}%", bg=BG, fg=CYAN,
                     font=("Hack Nerd Font", 10))
val_label.pack(anchor="e", padx=16, pady=(8, 0))

def on_change(v):
    pct = int(float(v))
    val_label.config(text=f"{pct}%")
    if mode == "volume":
        subprocess.run(["/usr/bin/wpctl", "set-volume",
                        "@DEFAULT_AUDIO_SINK@", f"{pct}%"], capture_output=True)
    elif mode == "brightness":
        subprocess.run(["/usr/bin/brightnessctl", "set", f"{pct}%", "-q"],
                       capture_output=True)

slider = tk.Scale(root, from_=1 if mode == "brightness" else 0, to=100,
                  orient="horizontal", length=330, width=16,
                  command=on_change,
                  bg=BG, fg=PINK, highlightthickness=0,
                  troughcolor=TRACK, activebackground=CYAN,
                  sliderrelief="flat", bd=0)
slider.set(val)
slider.pack(padx=14, pady=(0, 10))

root.bind("<Escape>", close)
root.bind("<Return>", close)
slider.bind("<Escape>", close)
slider.bind("<Return>", close)

root.focus_force()
slider.focus_set()

root.mainloop()
