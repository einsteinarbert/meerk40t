import glob
import os
import shutil


def clean():
    dirs = ["build", "dist", ".pytest_cache", ".mypy_cache", "meerk40t.egg-info"]
    for d in dirs:
        if os.path.exists(d):
            shutil.rmtree(d, ignore_errors=True)
    for pattern in ["**/*.pyc", "**/*.pyo", "**/__pycache__"]:
        for p in glob.glob(pattern, recursive=True):
            try:
                os.remove(p) if os.path.isfile(p) else shutil.rmtree(p, ignore_errors=True)
            except Exception:
                pass
    print("Da don dep sach se cac tep tin va thu muc tam.")


if __name__ == "__main__":
    clean()
