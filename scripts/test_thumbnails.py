"""Exercise the real generator and commit hook in disposable Git repositories."""

import hashlib
import json
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile
import unittest

ROOT = Path(__file__).resolve().parent.parent


class ThumbnailTest(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix="bjola-thumbnail-test-")
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        for name in ("scripts/gen-thumbnails.py", "scripts/install-hooks.sh", ".githooks/pre-commit"):
            target = self.root / name
            target.parent.mkdir(parents=True, exist_ok=True)
            shutil.copy2(ROOT / name, target)
        self.run_command("git", "init", "-q")
        self.run_command("git", "config", "user.email", "test@example.com")
        self.run_command("git", "config", "user.name", "Thumbnail test")
        self.run_command("sh", "scripts/install-hooks.sh")
        self.image = "assets/images/a photo.JPG"
        self.thumb = "assets/thumbs/images/a photo.JPG.webp"
        self.make_image(self.image, "red")
        self.run_command("git", "add", "--", self.image)

    def run_command(self, *args, ok=True):
        result = subprocess.run(args, cwd=self.root, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        if ok:
            self.assertEqual(0, result.returncode, result.stderr.decode())
        else:
            self.assertNotEqual(0, result.returncode)
        return result

    def make_image(self, name, color, size="800x400"):
        target = self.root / name
        target.parent.mkdir(parents=True, exist_ok=True)
        self.run_command(shutil.which("magick") or "convert", "-size", size, "xc:" + color, str(target))

    def generate(self):
        self.run_command(sys.executable, "scripts/gen-thumbnails.py", "--stage")

    def check(self, ok=True):
        return self.run_command(sys.executable, "scripts/gen-thumbnails.py", "--check", ok=ok)

    def test_commit_hook_creates_small_previews_without_staging_unrelated_files(self):
        self.make_image("assets/images/tiny.png", "transparent", "20x10")
        self.run_command("git", "add", "assets/images/tiny.png")
        self.make_image("assets/images/private-upload.png", "blue")
        (self.root / "unrelated.txt").write_text("leave this alone")
        self.run_command("git", "commit", "-qm", "Add images")
        self.check()
        manifest = json.loads((self.root / "_data/thumbnails.json").read_text())["images"]
        self.assertEqual((400, 200), (manifest["/" + self.image]["width"], manifest["/" + self.image]["height"]))
        self.assertEqual((20, 10), (manifest["/assets/images/tiny.png"]["width"], manifest["/assets/images/tiny.png"]["height"]))
        tracked = self.run_command("git", "ls-files").stdout.decode()
        self.assertNotIn("private-upload", tracked)
        self.assertNotIn("unrelated.txt", tracked)
        stamp = (self.root / self.thumb).stat().st_mtime_ns
        self.generate()
        self.assertEqual(stamp, (self.root / self.thumb).stat().st_mtime_ns)

    def test_uses_staged_source_even_when_worktree_has_later_edits(self):
        staged = (self.root / self.image).read_bytes()
        self.make_image(self.image, "blue")
        unstaged = (self.root / self.image).read_bytes()
        self.run_command("git", "commit", "-qm", "Commit staged red image")
        entry = json.loads((self.root / "_data/thumbnails.json").read_text())["images"]["/" + self.image]
        self.assertEqual(hashlib.sha256(staged).hexdigest(), entry["source_sha256"])
        self.assertEqual(unstaged, (self.root / self.image).read_bytes())
        self.assertEqual(staged, self.run_command("git", "show", "HEAD:" + self.image).stdout)
        self.check()
        self.run_command("git", "add", "--", self.image)
        self.check(ok=False)
        self.generate()
        self.check()

    def test_rename_and_delete_remove_obsolete_previews(self):
        self.generate()
        self.run_command("git", "mv", self.image, "assets/images/renamed.JPG")
        self.check(ok=False)
        self.generate()
        self.check()
        self.assertFalse((self.root / self.thumb).exists())
        self.assertTrue((self.root / "assets/thumbs/images/renamed.JPG.webp").exists())
        self.run_command("git", "rm", "-f", "assets/images/renamed.JPG")
        self.generate()
        self.check()
        self.assertEqual({}, json.loads((self.root / "_data/thumbnails.json").read_text())["images"])

    def test_missing_and_corrupt_previews_are_detected_and_repaired(self):
        self.generate()
        self.run_command("git", "rm", "-f", self.thumb)
        self.check(ok=False)
        self.generate()
        self.check()
        (self.root / self.thumb).write_bytes(b"broken")
        self.run_command("git", "add", self.thumb)
        self.check(ok=False)
        self.generate()
        self.check()

    def test_does_not_overwrite_unstaged_generated_edits(self):
        self.generate()
        (self.root / self.thumb).write_bytes(b"manual edit")
        self.make_image(self.image, "blue")
        self.run_command("git", "add", "--", self.image)
        result = self.run_command(sys.executable, "scripts/gen-thumbnails.py", "--stage", ok=False)
        self.assertIn(b"Unstaged changes", result.stderr)
        self.assertEqual(b"manual edit", (self.root / self.thumb).read_bytes())


if __name__ == "__main__":
    unittest.main()
