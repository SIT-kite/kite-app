from filesystem import Directory, to_path
import subprocess


def clone(*, git: str, cwd: str | Directory = ".", to: str = None):
    li = ["git", "clone", "--depth", "1", git]
    if to is not None:
        li.append(to)
    subprocess.run(li)
    subprocess.Popen(args=["flutter", "gen-l10n"],
                     bufsize=-1, shell=True,
                     cwd=to_path(cwd),
                     stdout=subprocess.STDOUT,
                     stderr=subprocess.STDOUT)
