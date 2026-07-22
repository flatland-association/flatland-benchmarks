import types
from subprocess import CalledProcessError
from unittest.mock import MagicMock, patch

import pytest

from docker_compose_fixture import _dump_compose_logs, _print_output, _test_containers_generator


def _fake_request():
  return types.SimpleNamespace(module=types.SimpleNamespace())


def test_print_output_prints_both_streams(capsys):
  _print_output("out-line", "err-line")
  captured = capsys.readouterr()
  assert "out-line" in captured.out
  assert "err-line" in captured.out


def test_dump_compose_logs_swallows_get_logs_errors():
  basic = MagicMock()
  basic.get_logs.side_effect = RuntimeError("boom")
  _dump_compose_logs(basic)  # must not raise


def test_fixture_skips_docker_compose_when_attended(monkeypatch):
  monkeypatch.setenv("ATTENDED", "True")
  gen = _test_containers_generator(_fake_request(), context=".")
  assert next(gen) is None
  with pytest.raises(StopIteration):
    next(gen)


@patch("docker_compose_fixture.DockerCompose")
def test_fixture_decodes_bytes_on_build_failure(mock_docker_compose_cls, capsys):
  basic = MagicMock()
  mock_docker_compose_cls.return_value = basic
  basic.get_logs.return_value = ("log-out", "log-err")
  basic.start.side_effect = CalledProcessError(
    returncode=1,
    cmd=["docker", "compose", "up", "--build"],
    output=b"raw-stdout-bytes",
    stderr=b"raw-stderr-bytes",
  )

  gen = _test_containers_generator(_fake_request(), context=".")
  # basic.start() raises before the fixture's first yield, so it surfaces on this first next() call
  with pytest.raises(CalledProcessError):
    next(gen)

  captured = capsys.readouterr()
  assert "raw-stdout-bytes" in captured.out
  assert "raw-stderr-bytes" in captured.out
  # regression guard for the bug fixed in this module: must be decoded text, not a bytes repr
  assert "b'raw-stdout-bytes'" not in captured.out
  assert "b'raw-stderr-bytes'" not in captured.out


@patch("docker_compose_fixture.DockerCompose")
def test_fixture_dumps_logs_and_reraises_on_other_exceptions(mock_docker_compose_cls):
  basic = MagicMock()
  mock_docker_compose_cls.return_value = basic
  basic.get_logs.return_value = ("log-out", "log-err")
  basic.stop.side_effect = RuntimeError("compose down failed")

  gen = _test_containers_generator(_fake_request(), context=".")
  with pytest.raises(RuntimeError):
    next(gen)

  basic.get_logs.assert_called_once()
