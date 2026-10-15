import os
from os.path import join, dirname
from dotenv import load_dotenv
from time import localtime, strftime
from libs.utility import to_bool

dotenv_path = join(dirname(__file__), "../.env")
load_dotenv(dotenv_path)


class Variable:
    leader = ""
    ss_dir = ""
    dl_dir = ""
    terminal = ""
    editor = ""
    username = ""
    homepage = ""
    timestamp = ""
    canvas = False
    webgl = False
    font_size = ""
    font_family = ""
    font = ""
    darkmode = False

    # initial constructor to set the values
    def __init__(self):
        self.leader = os.environ.get("LEADER_KEY")
        self.ss_dir = os.environ.get("SCREENSHORT_DIR")
        self.dl_dir = os.environ.get("DOWNLOAD_DIR")
        self.terminal = os.environ.get("TERMINAL")
        self.editor = os.environ.get("EDITOR")
        self.username = os.environ.get("GITHUB_USERNAME")
        self.homepage = os.environ.get("HOMEPAGE")
        self.timestamp = strftime("%Y-%m-%d-%H-%M-%S", localtime())
        self.canvas = to_bool(os.environ.get("CANVAS"))
        self.webgl = to_bool(os.environ.get("WEBGL"))
        self.font_size = os.environ.get("FONT_SIZE") + "pt"
        self.font_family = os.environ.get("FONT_FAMILY")
        self.font = self.font_size + " " + self.font_family
        self.darkmode = to_bool(os.environ.get("DARKMODE"))
