from filesystem import File, Directory, to_path
import git

git_path = "https://github.com/liplum/L10nArbTool.git"


def install(cwd: str | Directory = ".", to: str = None):
    git.clone(git=git_path, cwd=cwd, to=to)
