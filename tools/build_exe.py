import os
import shutil
import subprocess
import sys


def main():
    p_orig = os.path.join("meerk40t", "external_plugins.py")
    p_unused = os.path.join("meerk40t", "external_plugins.unused")
    p_build = os.path.join("meerk40t", "external_plugins_build.py")
    m_orig = "meerk40t.py"
    m_temp = "mk40t.py"

    print("==> [1/3] Chuan bi tep tin truoc khi build...")
    if sys.platform.startswith("win"):
        try:
            subprocess.run(["taskkill", "/f", "/im", "MeerK40t.exe"], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        except Exception:
            pass
    if os.path.exists(p_orig):
        shutil.move(p_orig, p_unused)
    if os.path.exists(p_build):
        shutil.copyfile(p_build, p_orig)
    if os.path.exists(m_orig):
        shutil.move(m_orig, m_temp)

    spec_path = os.path.join(".github", "workflows", "win", "meerk40t.spec")
    exit_code = 0
    try:
        print("==> [2/3] Dang thuc thi PyInstaller...")
        subprocess.run([sys.executable, "-m", "PyInstaller", spec_path], check=True)
        print("==> Build thanh cong! Tep exe nam tai thu muc dist/MeerK40t.exe")
    except Exception as e:
        print(f"==> Loi khi build exe: {e}")
        exit_code = 1
    finally:
        print("==> [3/3] Khoi phuc tep tin goc ve trang thai ban dau...")
        if os.path.exists(m_temp):
            if os.path.exists(m_orig):
                os.remove(m_orig)
            shutil.move(m_temp, m_orig)
        if os.path.exists(p_unused):
            if os.path.exists(p_orig):
                os.remove(p_orig)
            shutil.move(p_unused, p_orig)

    sys.exit(exit_code)


if __name__ == "__main__":
    main()
