# Diagnostic build based on the existing official webserver image.
# This is an isolated test: Chromium's process sandbox is disabled for root execution.
FROM ghcr.io/imputnet/yt-session-generator:webserver

RUN python3 - <<'PY'
from pathlib import Path
p = Path('/app/potoken_generator/extractor.py')
s = p.read_text()
old = 'user_data_dir=self.profile_path)'
new = 'user_data_dir=self.profile_path,\n                                               no_sandbox=True)'
if s.count(old) != 1:
    raise SystemExit(f'Expected one browser launch to patch; found {s.count(old)}. Stop build instead of deploying unverified code.')
p.write_text(s.replace(old, new, 1))
print('Patched nodriver launch with no_sandbox=True')
PY

RUN python3 -m py_compile /app/potoken_generator/extractor.py
