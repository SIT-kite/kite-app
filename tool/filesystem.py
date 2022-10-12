import ntpath
import os.path as p
import os
from pathlib import Path
from typing import Union, Optional


class Pathable:
    path: str
    abs_path: str

    def __init__(self, path: Union[str, "Pathable"]):
        if isinstance(path, Pathable):
            self.path = path.path
            self.abs_path = p.abspath(path.path)
        else:
            self.path = path
            self.abs_path = p.abspath(path)

    def __eq__(self, other) -> bool:
        if isinstance(other, str):
            return self.abs_path == p.abspath(other)
        elif isinstance(other, File):
            return self.abs_path == other.abs_path
        return False

    def __repr__(self):
        return self.path

    def __str__(self):
        return self.path


class File(Pathable):

    def exists(self):
        return p.isfile(self.path)

    def __eq__(self, other) -> bool:
        if isinstance(other, str):
            return self.abs_path == p.abspath(other)
        elif isinstance(other, File):
            return self.abs_path == other.abs_path
        return False

    def split(self) -> tuple[Optional["Directory"], "File"]:
        parent, name = p.split(self.path)
        if len(parent) == 0:
            return None, File(name)
        else:
            return Directory(parent), File(name)

    def to_abs(self) -> "File":
        return File(self.abs_path)

    def parent(self) -> "Directory":
        parent, _ = p.split(self.path)
        return Directory(parent)

    @staticmethod
    def cast(path: Union[str, "File"]) -> "File":
        if isinstance(path, File):
            return path
        else:
            return File(path)

    def read(self, mode="r"):
        with open(self.path, mode=mode, encoding="UTF-8") as f:
            return f.read()

    def try_read(self, mode="r", fallback: str | None = None) -> None | str:
        if os.path.isfile(self.path):
            return self.read(mode)
        else:
            return fallback

    def write(self, content: str, mode="w"):
        with open(self.path, mode=mode, encoding="UTF-8") as f:
            f.write(content)

    def append(self, content: str, mode="a"):
        with open(self.path, mode=mode, encoding="UTF-8") as f:
            f.write(content)

    def ensure(self):
        return self.parent().ensure()

    def delete(self) -> bool:
        if os.path.isfile(self.path):
            try:
                os.unlink(self.path)
                return True
            except:
                return False
        return True


class Directory(Pathable):
    def exists(self):
        return p.isdir(self.path)

    def split(self) -> tuple[Optional["Directory"], "Directory"]:
        parent, name = p.split(self.path)
        if len(parent) == 0:
            return None, Directory(name)
        else:
            return Directory(parent), Directory(name)

    def to_abs(self) -> "Directory":
        return Directory(self.abs_path)

    def lists(self, rtype=File) -> list[Union[File, "Directory"]] | list[str]:
        files = os.listdir(self.path)
        if rtype == str:
            return files
        res = []
        for f in files:
            if p.isfile(f):
                res.append(File(f))
            elif p.isdir(f):
                res.append(Directory(f))
        return res

    def lists_files(self) -> list[File]:
        files = os.listdir(self.path)
        res = []
        for f in files:
            if p.isfile(f):
                res.append(File(f))
        return res

    def lists_dirs(self) -> list["Directory"]:
        files = os.listdir(self.path)
        res = []
        for f in files:
            if p.isdir(f):
                res.append(Directory(f))
        return res

    def subfi(self, *name) -> File:
        cur = self.path
        for part in name:
            cur = ntpath.join(cur, part)
        return File(cur)

    def subdir(self, *name) -> "Directory":
        cur = self.path
        for part in name:
            cur = ntpath.join(cur, part)
        return Directory(cur)

    def sub_exists(self, name) -> bool:
        return p.exists(ntpath.join(self.path, name))

    def sub_isdir(self, name) -> bool:
        return p.isdir(ntpath.join(self.path, name))

    def sub_isfile(self, name) -> bool:
        return p.isfile(ntpath.join(self.path, name))

    @staticmethod
    def cast(path: Union[str, "Directory"]) -> "Directory":
        if isinstance(path, Directory):
            return path
        else:
            return Directory(path)

    def ensure(self):
        if os.path.exists(self.path):
            if os.path.isdir(self.path):
                return True
            else:
                return False
        else:
            Path(self.path).mkdir(parents=True, exist_ok=True)
            return True

    def delete(self) -> bool:
        if os.path.isdir(self.path):
            try:
                os.rmdir(self.path)
                return True
            except:
                return False
        return True


def to_path(target: str | Directory) -> str:
    if isinstance(target, Directory):
        return target.path
    else:
        return target


def is_dir(folder: str | Directory) -> bool:
    if isinstance(folder, str):
        return p.isdir(folder)
    else:
        return folder.exists()


def is_file(file: str | File) -> bool:
    if isinstance(file, str):
        return p.isfile(file)
    else:
        return file.exists()


def try_parse(path: str) -> File | Directory:
    """
    if it's neither file nor dir, a File will be return as default.
    :param path: an existed path
    :return: the exact file or dir
    """
    if p.isfile(path):
        return File(path)
    elif p.isdir(path):
        return Directory(path)
    else:
        return File(path)
