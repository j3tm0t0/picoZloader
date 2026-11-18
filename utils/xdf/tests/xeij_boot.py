#!/usr/bin/env python3
"""起動フロッピーを XEiJ (Compact、主記憶 2MB) で起動し、SECONDS 秒後の画面の文字を出す。
usage: xeij_boot.py RUNDIR XDF [SECONDS]
XDF は RUNDIR/fd0.xdf に写してから使う (元のファイルは変えない)。2 つのイメージを同じ秒数で起動して画面を比べるのに使う。"""
import os, shutil, subprocess, sys, time
here = os.path.dirname(os.path.abspath(__file__))
tools = os.environ.get("XEIJ_TOOLS")      # xeij/XEiJ.jar、xeij/HUMAN302.XDF、xeijagent.jar を置いたディレクトリ
if not tools and __name__ == "__main__":
    sys.exit("XEIJ_TOOLS に XEiJ の道具のディレクトリ (xeij/XEiJ.jar、xeij/HUMAN302.XDF、xeijagent.jar) を指定してください")
run, xdf = os.path.abspath(sys.argv[1]), sys.argv[2]
secs = float(sys.argv[3]) if len(sys.argv) > 3 else 40
os.makedirs(run, exist_ok=True)
for f in ("cgrom.bin", "agent.cmd", "XEiJControl"):
    if os.path.exists(os.path.join(run, f)): os.remove(os.path.join(run, f))
fd0 = os.path.join(run, "fd0.xdf")
shutil.copy(xdf, fd0); os.chmod(fd0, 0o644)
java = "/opt/homebrew/opt/openjdk/bin/java"
if not os.path.exists(java): java = "java"
xe = subprocess.Popen([java, "-javaagent:%s/xeijagent.jar=%s/agent.cmd" % (tools, run), "-Djava.io.tmpdir=" + run,
                       "-jar", os.path.join(tools, "xeij/XEiJ.jar"), "-config=default", "-model=Compact", "-memory=2",
                       "-boot=fd0", "-fd0=" + fd0, "-flrinformed=on", "-usecanvas=off", "-pastepipe=on"],
                      cwd=run, stdin=subprocess.DEVNULL, stdout=open(os.path.join(run, "xeij.log"), "w"),
                      stderr=subprocess.STDOUT)
try:
    time.sleep(secs)
    r = subprocess.run([sys.executable, "-I", os.path.join(here, "xscreen.py"), run], capture_output=True, text=True)
    if r.returncode != 0:
        sys.exit("xeij_boot: cannot read the screen: %s" % (r.stderr.strip() or r.returncode))
    print(r.stdout.rstrip())
finally:
    xe.terminate()
    try: xe.wait(10)
    except subprocess.TimeoutExpired: xe.kill()
